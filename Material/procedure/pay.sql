CREATE DEFINER=`skip-grants user`@`skip-grants host` PROCEDURE `pay`(IN c_id bigint, IN money bigint, IN b_id VARCHAR(9), IN d_id bigint)
BEGIN
		-- c_id 客户id
		-- money 缴费金额
		-- b_id 银行id
		-- d_id 设备id
		DECLARE origin_balance BIGINT; -- 客户充值前的余额
		DECLARE new_balance BIGINT; -- 客户充值后的余额
		DECLARE temp_cost_id BIGINT; -- 正在操作的账单id
		DECLARE temp_paid_fee DECIMAL(9,2); -- 正在操作的账单基础费用
		DECLARE temp_payable_date DATETIME; -- 正在操作的账单可付费日期
		DECLARE temp_device_type VARCHAR(2); -- 待缴费的设备类型
		
		DECLARE	temp_actual_fee DECIMAL(9,2); -- 总金额(写入change_log)
		DECLARE temp_late_fee DECIMAL(9,2); -- 滞纳金(写入change_log)
		DECLARE temp_pay_date DATETIME; -- 最近一次付款日期(写入change_log)
		DECLARE temp_already_fee DECIMAL(9,2); -- 已付款金额(写入change_log)
		DECLARE	temp_pay_state VARCHAR(2); -- 付款状态(写入change_log)
		
		DECLARE	total_fee DECIMAL(9,2); -- 应缴费总金额(基本费用+滞纳金)
		DECLARE temp_now DATETIME; -- 缴费时间，统一使用此时间！
		DECLARE temp_transfer_id BIGINT; -- 银行流水id
		-- DECLARE:找到该客户拥有的全部欠费清单
    DECLARE v_finished INTEGER DEFAULT 0;
    DECLARE cost_log_cursor CURSOR FOR SELECT cost_id, paid_fee, actual_fee, late_fee, payable_date, pay_date, already_fee, pay_state FROM cost_log WHERE device_id=d_id ORDER BY TO_DAYS(date);
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;

		-- 1.根据客户id修改客户余额，生成新的余额记录
		-- 1.1获取原始余额，确定充值后余额
		SELECT balance INTO origin_balance
		FROM client
		WHERE client_id = c_id;

		SET new_balance = origin_balance+money;
		
		-- 1.2修改客户当前余额
		UPDATE client SET balance = new_balance WHERE client_id = c_id;
		
		-- 1.3生成新的余额记录
		INSERT INTO balance_log(now_balance, client_id, action, date)
		VALUES(new_balance, c_id, '01', NOW());
		
		-- 1.4生成新的转账记录和付款记录
		-- 1.4.1生成新的转账记录
		SET temp_now = NOW();
		INSERT INTO transfer_log(bank_id, client_id, transfer_amount, transfer_time)
		VALUES(b_id, c_id, money, temp_now);
		
		-- 1.4.2根据新的转账记录获得新的转账id
		SELECT transfer_id INTO temp_transfer_id
		FROM transfer_log
		WHERE transfer_time = temp_now AND client_id = c_id;
		
		-- 1.4.3生成新的付款记录
		INSERT INTO pay_log(client_id, device_id, pay_time, pay_amount, pay_type, bank_id, transfer_id, notes)
		VALUES(c_id, d_id, temp_now, money, '01', b_id, temp_transfer_id,'');
		
		-- 1.5判断设备类型
		SELECT device_type INTO temp_device_type
		FROM device
		WHERE device_id = d_id;

		-- 2.循环遍历当前账单(当改变某项账单信息时，会对应生成change_log，记录改变字段的前后值，这是冲正操作所依赖的关键)
		-- 要写入change_log的五个属性
		-- temp_actual_fee
		-- temp_late_fee
		-- temp_pay_date
		-- temp_already_fee
		-- temp_pay_state
    OPEN cost_log_cursor;
    pay: LOOP
		FETCH cost_log_cursor INTO temp_cost_id, temp_paid_fee, temp_actual_fee, temp_late_fee, temp_payable_date, temp_pay_date, temp_already_fee, temp_pay_state;
		SELECT v_finished, temp_paid_fee, temp_payable_fee, temp_already_fee;
				IF v_finished = 1 THEN 
						LEAVE pay;
				END IF;
				IF new_balance = 0 THEN
						LEAVE pay;
				END IF;
				-- 如果当前余额足够缴纳当前遍历到的账单
				SET total_fee = calculate(temp_payable_date, temp_paid_fee, d_id); -- total_fee包含滞纳金的总花费
				-- 当前余额大于待缴费金额
				IF new_balance >= (total_fee - temp_already_fee) THEN 
						-- 更新客户余额并生成余额变化记录
						SET new_balance = new_balance - (total_fee - temp_already_fee);
						INSERT INTO balance_log(now_balance, client_id, action, date) VALUES(new_balance, c_id, '02', temp_now); -- 生成新的余额变动记录
						UPDATE client SET balance = new_balance WHERE client_id = c_id; -- 更新用户余额
						-- 更新原有cost_log
						UPDATE cost_log SET actual_fee = total_fee, late_fee = total_fee - temp_paid_fee, pay_date = temp_now, already_fee = total_fee, pay_state = '02' WHERE cost_id = temp_cost_id;
						-- 增加change_log
						INSERT change_log(cost_id, actual_fee_1, late_fee_1, pay_date_1, already_fee_1, pay_state_1) VALUES(temp_cost_id, temp_actual_fee, temp_late_fee, temp_pay_date, temp_already_fee, temp_pay_state);
        END IF;
				-- 当前余额小于待缴费金额，但不等于0
				IF new_balance < (total_fee-temp_already_fee) THEN
						-- 更新客户余额并生成余额变化记录
						SET new_balance = 0; -- 余额一定会被花光变为0
						INSERT INTO balance_log(now_balance, client_id, action, date) VALUES(new_balance, c_id, '02', temp_now); -- 生成新的余额变动记录
						UPDATE client SET balance = new_balance WHERE client_id = c_id;
						-- 更新原有cost_log
						UPDATE cost_log SET pay_date = temp_now, already_fee = new_balance, pay_state = '03' WHERE cost_id = temp_cost_id;
						-- 增加change_log
						INSERT change_log(cost_id, actual_fee_1, late_fee_1, pay_date_1, already_fee_1, pay_state_1) VALUES(temp_cost_id, temp_actual_fee, temp_late_fee, temp_pay_date, temp_already_fee, temp_pay_state);
				END IF;
				
		END LOOP pay;
    CLOSE cost_log_cursor;
END