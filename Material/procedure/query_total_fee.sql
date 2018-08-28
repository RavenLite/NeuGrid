CREATE DEFINER=`skip-grants user`@`skip-grants host` PROCEDURE `query_total_fee`(INOUT c_id bigint, OUT total_fee DECIMAL(9,2), OUT c_name VARCHAR(30), OUT c_address VARCHAR(90), OUT c_balance DECIMAL(9,2))
BEGIN
		
		DECLARE temp_payable_date DATETIME;
		DECLARE temp_paid_fee DECIMAL(9,2);
		DECLARE temp_device_id BIGINT;
		DECLARE temp_device_type VARCHAR(2);
    DECLARE v_finished INTEGER DEFAULT 0;
		-- 1.获取欠费账单游标
		DECLARE cost_log_cursor CURSOR FOR SELECT payable_date, paid_fee, device_id
																			 FROM cost_log 
																			 WHERE DEVICE_ID IN (SELECT DEVICE_ID 
																													 FROM device 
																													 WHERE CLIENT_ID = c_id) AND PAY_STATE = 0;
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;																											 
		
		SET total_fee = 0.00;
		-- 2.计算违约金
		OPEN cost_log_cursor;
    calculate: LOOP
		FETCH cost_log_cursor INTO temp_payable_date, temp_paid_fee, temp_device_id;
		IF v_finished = 1 THEN 
				LEAVE calculate;
		END IF;
		
		-- 2.1根据设备类型获取它的违约金比例
		SELECT device_type INTO temp_device_type
    FROM device
    WHERE device_id = temp_device_id;
		
		-- SET total_fee = 0;
		-- SELECT temp_payable_date, temp_paid_fee, temp_device_id, temp_device_type, total_fee;
		-- SELECT calculate_late(temp_payable_date, temp_paid_fee, temp_device_type) + temp_paid_fee;
		-- 2.2计算总费用
		SET total_fee = total_fee + calculate_late(temp_payable_date, temp_paid_fee, temp_device_type) + temp_paid_fee;
		
		END LOOP calculate;
    CLOSE cost_log_cursor;
	
	
		-- 3.获取客户信息
		SELECT address, client_name, balance INTO c_address, c_name, c_balance
		FROM client
		WHERE client_id = c_id;
END