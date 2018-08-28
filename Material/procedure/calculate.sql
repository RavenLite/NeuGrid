CREATE DEFINER=`skip-grants user`@`skip-grants host` FUNCTION `calculate_late`(date DATETIME, paid_fee DECIMAL(9,2), device_type VARCHAR(2)) RETURNS int(11)
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

		SET temp_fee = paid_fee*(TO_DAYS(concat(YEAR(date),'-12-31')) - TO_DAYS(date))*add_price_this_year + TO_DAYS(NOW())-TO_DAYS(concat(YEAR(date),'-12-31'))*add_price_other_year;

		RETURN temp_fee;
END