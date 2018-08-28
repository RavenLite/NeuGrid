CREATE DEFINER=`skip-grants user`@`skip-grants host` FUNCTION `calculate_late`(date DATETIME, paid_fee DECIMAL(9,2), device_type VARCHAR(2)) RETURNS decimal(9,2)
BEGIN
-- date 账单产生时间
-- paid_fee 账单费用
-- device_type 设备类型
    DECLARE add_price_this_year DECIMAL(9,4); -- 与设备类型关联的附加费2比率
    DECLARE add_price_other_year DECIMAL(9,4); -- 与设备类型关联的附加费2比率
		DECLARE temp_fee DECIMAL(9,2);

    IF device_type='01' THEN 
				SET add_price_this_year = 0.001;
				SET add_price_other_year = 0.001;
		ELSE 
				SET add_price_this_year = 0.002;
				SET add_price_other_year = 0.003;
    END IF;
		
		IF YEAR(date)=YEAR(NOW()) THEN
		SET temp_fee = paid_fee * (TO_DAYS(NOW()) - TO_DAYS(date)) * add_price_this_year;
		ELSE
		SET temp_fee = paid_fee * (TO_DAYS(str_to_date((concat('31-12-', YEAR(date))), '%d-%m-%Y')) - TO_DAYS(date)) * add_price_this_year + paid_fee * (TO_DAYS(NOW())-TO_DAYS(str_to_date((concat('31-12-', YEAR(date))), '%d-%m-%Y'))) * add_price_other_year;
		END IF;

		RETURN temp_fee;
END