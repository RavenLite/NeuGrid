-- 1.查客户信息
CREATE DEFINER=`skip-grants user`@`skip-grants host` PROCEDURE `query_total_fee`(IN c_id bigint, OUT total_fee bigint)
BEGIN
	SELECT sum(PAID_FEE) INTO total_fee 
    FROM cost_log 
    WHERE DEVICE_ID IN (SELECT DEVICE_ID 
						FROM device 
						WHERE CLIENT_ID = c_id) and PAY_STATE = 0;
END

-- 2.缴费
CREATE PROCEDURE `read` (IN r_date datetime, IN d_id bigint, IN r_number bigint, IN rr_id bigint)
BEGIN
	-- 根据device_id找到client_id
    DECLARE c_id bigint;
    SELECT client_id INTO c_id
    FROM device
    WHERE device_id = d_id;
    
    -- 插入一条新纪录到read_log中
    INSERT INTO read_log()
END

-- 3.冲正

-- 4.对总账
CREATE PROCEDURE `check_total` (IN b_id bigint, IN amout bigint, IN number bigint, IN date varchar(30), OUT state)
BEGIN
	select sum(transfer_amout)
    from transfer_log
    where bank_id = b_id;
END

-- 5.对明细

-- 6.抄表并生成账单 
CREATE PROCEDURE `read` (IN r_date datetime, IN d_id bigint, IN r_number bigint, IN rr_id bigint)
BEGIN
    DECLARE c_id bigint;
    DECLARE degree int;
	-- 根据device_id找到client_id
    SELECT client_id INTO c_id
    FROM device
    WHERE device_id = d_id;
    
    -- 插入一条新纪录到read_log中
    INSERT INTO read_log(READ_DATE, device_id, client_id, READ_NUMBER, READER_ID)
    values (str_to_date(datetime, '%d-%m-%Y'), d_id, c_id, r_number, rr_id);
    
    -- 生成cost_log记录
    
END