CREATE DEFINER=`skip-grants user`@`skip-grants host` PROCEDURE `query_total_fee`(INOUT c_id bigint, OUT total_fee DECIMAL(9,2), OUT c_name VARCHAR(30), OUT c_address VARCHAR(90), OUT c_balance DECIMAL(9,2))
BEGIN
		
		DECLARE temp_date DATETIME;
		DECLARE temp_paid_fee DECIMAL(9,2);
		DECLARE temp_device_id BIGINT;
		DECLARE temp_type VARCHAR(2);
    DECLARE v_finished INTEGER DEFAULT 0;
    DECLARE add_price_this_year DECIMAL(9,4); -- 与设备类型关联的附加费2比率
    DECLARE add_price_other_year DECIMAL(9,4); -- 与设备类型关联的附加费2比率
		-- 1.获取欠费账单游标
		DECLARE cost_log_cursor CURSOR FOR SELECT payable_date, paid_fee, device_id
																			 FROM cost_log 
																			 WHERE DEVICE_ID IN (SELECT DEVICE_ID 
																													 FROM device 
																													 WHERE CLIENT_ID = c_id) AND PAY_STATE = 0;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;																											 
		-- 2.计算违约金
		OPEN cost_log_cursor;
    calculate: LOOP
		FETCH cost_log_cursor INTO temp_date, temp_paid_fee, temp_device_id;
		-- 2.1根据设备类型获取它的违约金比例
		SELECT device_type INTO temp_type
    FROM device
    WHERE device_id = temp_device_id;
    
    IF d_type='01' THEN 
				SET add_price_this_year = 0.001;
				SET add_price_other_year = 0.001;
		ELSE 
				SET add_price_this_year = 0.002;
				SET add_price_other_year = 0.003;
    END IF;
		
		SELECT v_finished, temp_date, temp_paid_fee;
				IF v_finished = 1 THEN 
						LEAVE calculate;
				END IF;
				IF YEAR(temp_date)=YEAR(NOW()) THEN
						SET total_fee=total_fee+temp_paid_fee*(DAY(NOW())-DAY(temp_date)-1)*add_price_this_year;
				ELSE 
						SET total_fee=total_fee+calculate_late(temp_date, temp_paid_fee, d_type);
				END IF;
		END LOOP calculate;
    CLOSE cost_log_cursor;
	
	
		-- 2.获取客户信息
		SELECT address, client_name, balance INTO c_address, c_name, c_balance
				FROM client
				WHERE client_id = c_id;
END