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
		
		-- 1.查询pay_log里有无对应的转账id并设置state的值，即能否冲正
		SELECT count(*) INTO result_count
		FROM  pay_log
		WHERE transfer_id = t_id AND TO_DAYS(pay_time)=TO_DAYS(NOW());
		
		IF result_count = 1 THEN
			SET state = '存在';
		ELSEIF result_count = 0 THEN
			SET state = '不存在';
			LEAVE exist;
		END IF;
		
		-- 2.给原客户账户返钱
		SELECT client_id, pay_amount, bank_id INTO temp_client_id, temp_pay_amount, temp_bank_id
		FROM pay_log
		WHERE transfer_id = t_id AND TO_DAYS(pay_time)=TO_DAYS(NOW());
		
		SELECT balance INTO temp_balance
		FROM client
		WHERE client_id = temp_client_id;
		
		UPDATE client SET balance = temp_balance + temp_pay_amount WHERE client_id = temp_client_id;
		INSERT balance_log(now_balance, client_id, action, date) VALUES(temp_balance + temp_pay, temp_client_id, '03', NOW());
		
		-- 3.取消误操作，生成负值缴费记录
		-- 3.1生成负值的pay_log
		INSERT INTO pay_log(client_id, device_id, pay_time, pay_amount, pay_type, bank_id, transfer_id, notes)
		VALUES(temp_client_id, temp_device_id, NOW(), -1*money, '02', temp_bank_id, t_id,'');
		
END