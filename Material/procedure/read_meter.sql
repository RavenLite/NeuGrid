CREATE DEFINER=`skip-grants user`@`skip-grants host` PROCEDURE `read_meter`(IN r_date datetime, IN d_id bigint, IN r_number bigint, IN rr_id bigint)
BEGIN
    DECLARE c_id BIGINT;
    DECLARE begin_num BIGINT DEFAULT 0; -- 开始读数
    DECLARE price DECIMAL(9,2); -- 每度电价格
    DECLARE d_type VARCHAR(2); -- 设备类型
    DECLARE add_price DECIMAL(3,2); -- 与设备类型关联的附加费2比率
    DECLARE temp_price VARCHAR(9);
    DECLARE degree INT; -- 用电量
    DECLARE close_time BIGINT DEFAULT 0;
    DECLARE temp_time BIGINT;
    DECLARE close_id BIGINT;
    DECLARE temp_id BIGINT;
    DECLARE b_fee DECIMAL(9,2); -- 使用最多的基础费用
    DECLARE v_finished INTEGER DEFAULT 0;
    -- 将抄表日期转化成距0000-01-01 00:00:00的秒数，以此找到最近的读表日期
    DECLARE read_log_cursor CURSOR FOR SELECT read_id, TO_DAYS(read_date) FROM read_log WHERE device_id=d_id; 
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;

    
		-- 1.根据device_id找到client_id
    SELECT client_id INTO c_id
    FROM device
    WHERE device_id = d_id;

    -- 2.生成cost_log记录
    -- 2.1找到最近抄表记录的id
    OPEN read_log_cursor;
    find_closest: LOOP
		FETCH read_log_cursor INTO temp_id, temp_time;
		-- SELECT v_finished, temp_id, temp_time;
				IF v_finished = 1 THEN 
						LEAVE find_closest;
				END IF;
				IF temp_time > close_time THEN 
            SET close_time = temp_time;
            SET close_id = temp_id;
        END IF;
		END LOOP find_closest;
    CLOSE read_log_cursor;
		-- 2.2根据抄表id找到区间用电量
    SELECT read_number INTO begin_num
    FROM read_log
    WHERE read_id = close_id;
    
    SET degree = r_number - begin_num;
    
    -- 2.3获取电费单价
    SELECT code_value INTO temp_price
    FROM code_table
    WHERE code_key = '每度电价格';
    
    SET price = CONVERT(temp_price, DECIMAL(9,2));
    
    -- 2.4根据设备类型确定附加费2比率
    SELECT device_type INTO d_type
    FROM device
    WHERE device_id = d_id;
    
    IF d_type='01'
    THEN SET add_price = 0.1;
    ELSE SET add_price = 0.15;
    END IF;
    
    -- 2.5生成cost_log(*PAYABLE_FEE转换成本月最后一天)
    SET b_fee = degree*price;
	INSERT INTO cost_log (DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
    VALUES (d_id, r_date, begin_num, r_number, b_fee, b_fee*0.08, b_fee*add_price, b_fee + b_fee*0.08 + b_fee*add_price, null, null, LAST_DAY(r_date), null, 0, '未缴');
		    
    -- 3.插入一条新纪录到read_log中
    INSERT INTO read_log(READ_DATE, device_id, READ_NUMBER, READER_ID)
    values (r_date, d_id, r_number, rr_id);
END