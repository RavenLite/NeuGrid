CREATE DEFINER=`skip-grants user`@`skip-grants host` PROCEDURE `revert`(IN t_id BIGINT, IN d_id BIGINT, OUT state VARCHAR(9))
exist:
BEGIN
		-- t_id 银行流水id
		-- d_id 新欲充值的设备id
		-- state 冲正是否成功
		DECLARE result_count BIGINT; -- 是否存在满足条件的缴费记录
		DECLARE temp_client_id BIGINT; -- 误操作的客户id
		DECLARE temp_device_id BIGINT; -- 误操作的设备id
		DECLARE temp_bank_id VARCHAR(9); -- 误操作的银行id
		DECLARE temp_pay_amount DECIMAL(9,2); -- 误操作金额
		DECLARE temp_balance DECIMAL(9,2); -- 客户当前余额
		DECLARE temp_pay_time DATETIME; -- 误操作付款时间
		DECLARE temp_cost_id BIGINT;
		
		DECLARE	temp_actual_fee DECIMAL(9,2); -- 总金额(写入change_log)
		DECLARE temp_late_fee DECIMAL(9,2); -- 滞纳金(写入change_log)
		DECLARE temp_pay_date DATETIME; -- 最近一次付款日期(写入change_log)
		DECLARE temp_already_fee DECIMAL(9,2); -- 已付款金额(写入change_log)
		DECLARE	temp_pay_state VARCHAR(2); -- 付款状态(写入change_log)
		
		-- 误操作的账单id
		DECLARE v_finished INTEGER DEFAULT 0;
    DECLARE cost_log_cursor CURSOR FOR SELECT cost_id FROM cost_log WHERE pay_date = temp_pay_time;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;
		
		-- 1.查询pay_log里有无对应的转账id并设置state的值，即能否冲正
		SELECT count(*) INTO result_count
		FROM  pay_log
		WHERE transfer_id = t_id AND TO_DAYS(pay_time)=TO_DAYS(NOW()) AND pay_amount > 0;
		
		IF result_count = 1 THEN
			SET state = '存在';
		ELSEIF result_count = 0 THEN
			SET state = '不存在';
			LEAVE exist;
		END IF;
		
		-- 2.给原客户账户返钱
		SELECT client_id, pay_amount, bank_id, client_id INTO temp_client_id, temp_pay_amount, temp_bank_id, temp_device_id
				FROM pay_log
		WHERE transfer_id = t_id AND TO_DAYS(pay_time)=TO_DAYS(NOW()) AND pay_amount > 0;
		
		SELECT balance INTO temp_balance
				FROM client
		WHERE client_id = temp_client_id;
		
 		UPDATE client SET balance = temp_balance + temp_pay_amount WHERE client_id = temp_client_id;
 		INSERT balance_log(now_balance, client_id, action, date) VALUES(temp_balance + temp_pay_amount, temp_client_id, '03', NOW());
		
 		-- 3.取消误操作，生成负值缴费记录
 		-- 3.1生成负值的pay_log
 		INSERT INTO pay_log(client_id, device_id, pay_time, pay_amount, pay_type, bank_id, transfer_id)
 		VALUES(temp_client_id, temp_device_id, NOW(), -1*(temp_balance + temp_pay_amount), '02', temp_bank_id, t_id);
 		
 		-- 3.2根据t_id找到付款时间
 		SELECT pay_time INTO temp_pay_time
 		FROM pay_log
 		WHERE transfer_id = t_id AND pay_amount > 0;
 		
 		-- 3.3根据付款时间找到cost_log
 		OPEN cost_log_cursor;
		
		renew: LOOP
				FETCH cost_log_cursor INTO temp_cost_id;
 				-- 获取cost_log原始记录值
				IF v_finished = 1 THEN 
						LEAVE renew;
				END IF;
 				SELECT actual_fee_1, late_fee_1, pay_date_1, already_fee_1, pay_state_1 INTO temp_actual_fee, temp_late_fee, temp_pay_date, temp_already_fee, temp_pay_state
						FROM change_log
 				WHERE cost_id = temp_cost_id;
 				
 				-- 将cost_log改回原始记录
 				UPDATE cost_log SET actual_fee = temp_actual_fee, late_fee = temp_late_fee, pay_date = temp_pay_date, already_fee = temp_already_fee, pay_state = temp_pay_state WHERE cost_id = temp_cost_id;
 				
		END LOOP renew;
		
    CLOSE cost_log_cursor;
		
END