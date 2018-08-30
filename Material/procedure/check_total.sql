CREATE DEFINER=`skip-grants user`@`skip-grants host` PROCEDURE `check_total`(IN b_id VARCHAR(9), IN count BIGINT, IN amount DECIMAL(9,2), IN date DATETIME, OUT state VARCHAR(10))
BEGIN
		DECLARE my_count BIGINT;
		DECLARE my_amount DECIMAL(9,2);
		SELECT count(*), sum(pay_amount) INTO my_count, my_amount
		FROM pay_log
		WHERE bank_id = b_id AND TO_DAYS(date) = TO_DAYS(pay_time) AND pay_type = '缴费';
	
		SET state = 'ok';
	
		IF my_count != count THEN
				SET state = 'error';
		END IF;
		IF my_amount != amount THEN
				SET state = 'error';
		END IF;	
			
		-- 生成对账记录
		IF state = 'ok' THEN
				INSERT INTO total_log(account_date, bank_id, bank_count, bank_amount, enterprise_count, enterprise_amount, is_success)
				VALUES(date, b_id, count, amount, my_count, my_amount, 'is');
				
		ELSEIF state = 'error' THEN
				INSERT INTO total_log(account_date, bank_id, bank_count, bank_amount, enterprise_count, enterprise_amount, is_success)
				VALUES(date, b_id, count, amount, my_count, my_amount, 'no');
		END IF;
END