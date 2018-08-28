CREATE DEFINER=`skip-grants user`@`skip-grants host` PROCEDURE `check_total`(IN b_id VARCHAR(9), IN count BIGINT, IN amount DECIMAL(9,2), IN date DATETIME, OUT state VARCHAR(10))
BEGIN
	DECLARE my_count BIGINT;
	DECLARE my_amount DECIMAL(9,2);
	SELECT count(*), sum(pay_amount) INTO my_count, my_amount
  FROM pay_log
  WHERE bank_id = b_id AND TO_DAYS(date) = TO_DAYS(pay_time) AND pay_type = '01';
	
	SET state = 'ok';
	
	IF my_count != count THEN
		SET state = 'error';
	END IF;
	IF my_amount != amount THEN
		SET state = 'error';
	END IF;	
END