-- 1.基础管理
-- 1.1创建新用户
-- 1.1.1创建用户1，余额0元
INSERT INTO client(client_name, address, balance) VALUES('用户1', '上海汤臣一品', 0); -- 用户1的client_id为1005
-- 1.1.2创建用户2，余额50元
INSERT INTO client(client_name, address, balance) VALUES('用户2', '沈阳尚盈丽景', 50); -- 用户2的client_id为1006

-- 1.2创建新电表
-- 1.2.1为'用户1'创建一个用户级电表和一个企业级电表
INSERT INTO device(client_id, device_type) VALUES(1005, '01'); -- 用户1表1的device_id为2008
INSERT INTO device(client_id, device_type) VALUES(1005, '02'); -- 用户1表2的device_id为2009
-- 1.2.2为'用户2'创建一个用户级电表
INSERT INTO device(client_id, device_type) VALUES(1006, '01'); -- 用户2表1的device_id为2010

-- 1.3查询出所有欠费超过半年的用户
SELECT DISTINCT client_id, client_name, address, balance
FROM cost_log JOIN (device JOIN client USING(client_id)) USING(device_id)
WHERE (pay_state = '未缴' OR pay_state = '部分缴') AND TIMESTAMPDIFF(MONTH, payable_date, NOW()) >= 6;

-- 1.4查询任意用户的欠费总额
-- (1)查具体某一个人
SELECT client_id, client_name, sum(paid_fee) AS '欠费总额', sum(paid_fee + calculate_late(payable_date, paid_fee, device_type)) AS '欠费总额(含滞纳金)'
FROM cost_log  JOIN (device JOIN client USING(client_id)) USING(device_id)
WHERE (pay_state = '未缴' OR pay_state = '部分缴') AND client_id = 1005; -- 在这里选择修改欲查询的用户，用户1为1005，用户2为1006

-- (2)查全部
SELECT client_id, client_name, sum(paid_fee) AS '欠费总额', sum(paid_fee + calculate_late(payable_date, paid_fee, device_type)) AS '欠费总额(含滞纳金)'
FROM cost_log  JOIN (device JOIN client USING(client_id)) USING(device_id)
WHERE (pay_state = '未缴' OR pay_state = '部分缴') 
GROUP BY client_id;

-- 1.5查询出某个月用电量最高的3名用户
SELECT MONTH(A.date) AS 'MONTH', client_id, client_name
FROM cost_log A JOIN client USING(client_id)
WHERE (SELECT count(client_id)
	   FROM cost_log B
	   WHERE (MONTH(A.date) = MONTH(B.date)) AND B.end_number - B.begin_number > A.end_number - A.begin_number) <= 2;
		 
-- 2.抄表
-- 2.1新电表抄表一次，时间为9月
-- 2.1.1默认抄用户1表1
CALL read_meter(str_to_date('01-09-2018', '%d-%m-%Y'), 2008, 100, 1); -- 默认抄用户1表1(用户1表1:2008, 用户1表2:2009, 用户2表1:2010)
-- 2.1.2查看欠费清单
SELECT * FROM cost_log;
-- 2.1.2查看抄表清单
SELECT * FROM read_log;

-- 2.2连续抄表5次，分别欠费50、60、50、60、50
-- 2.2.1连续抄表
CALL read_meter(str_to_date('01-10-2018', '%d-%m-%Y'), 2008, 200, 1);
CALL read_meter(str_to_date('01-11-2018', '%d-%m-%Y'), 2008, 320, 1);
CALL read_meter(str_to_date('01-12-2018', '%d-%m-%Y'), 2008, 420, 1);
CALL read_meter(str_to_date('01-01-2019', '%d-%m-%Y'), 2008, 540, 1);
CALL read_meter(str_to_date('01-02-2019', '%d-%m-%Y'), 2008, 640, 1);
-- 2.2.2查询出所有欠费超过半年的用户
SELECT DISTINCT client_id, client_name, address, balance
FROM cost_log JOIN (device JOIN client USING(client_id)) USING(device_id)
WHERE (pay_state = '未缴' OR pay_state = '部分缴') AND TIMESTAMPDIFF(MONTH, payable_date, NOW()) >= 6;
-- 2.2.3查询任意用户的欠费总额
SELECT client_id, client_name, sum(paid_fee) AS '欠费总额', sum(paid_fee + calculate_late(payable_date, paid_fee, device_type)) AS '欠费总额(含滞纳金)'
FROM cost_log  JOIN (device JOIN client USING(client_id)) USING(device_id)
WHERE (pay_state = '未缴' OR pay_state = '部分缴') AND client_id = 1005; -- 在这里选择修改欲查询的用户，用户1为1005，用户2为1006
-- 2.2.4查询出某个月用电量最高的3名用户
SELECT MONTH(A.date) AS 'MONTH', client_id, client_name
FROM cost_log A JOIN client USING(client_id)
WHERE (SELECT count(client_id)
	   FROM cost_log B
	   WHERE (MONTH(A.date) = MONTH(B.date)) AND B.end_number - B.begin_number > A.end_number - A.begin_number) <= 2;

-- 2.3查询抄表记录
-- 2.3.1查看欠费清单跟滞纳金
SELECT * FROM cost_log;
-- 2.3.2查看余额变化记录
SELECT * FROM balance_log;

-- 3.缴费
-- 3.1查询欠费清单
SELECT * FROM cost_log;

-- 3.2缴费
-- 3.2.1缴费缴纳小于等于0的数
CALL pay(1005, -50, 'CMB', 2008, @state);
SELECT @state;
-- 3.2.2缴费不存在电表
CALL pay(1005, 200, 'CMB', 20088, @state);
SELECT @state;
-- 3.2.3查看当日应缴费用和应收费用
SELECT 	(SELECT SUM(transfer_amount)
		FROM transfer_log
		WHERE TO_DAYS(transfer_time) = TO_DAYS(str_to_date('20-02-2019', '%d-%m-%Y'))) AS '总应收费用', 
		(SELECT SUM(pay_amount)
		FROM pay_log
		WHERE TO_DAYS(pay_time) = TO_DAYS(str_to_date('20-02-2019', '%d-%m-%Y'))) AS '总实收费用';
-- 3.2.4查询出电力企业某个月哪天的缴费人数最多
SELECT YEAR(pay_time), MONTH(pay_time), DAY(pay_time)
FROM pay_log
WHERE MONTH(pay_time) = 2 AND YEAR(pay_time) = 2019
GROUP BY(DAY(pay_time))
ORDER BY count(DAY(pay_time))
LIMIT 0,1;

-- 3.2.5统计每个月各银行缴费人次，从高到低排序
SELECT YEAR(transfer_time), MONTH(transfer_time) AS 'month', bank_id, COUNT(*) AS 'number'
FROM transfer_log
GROUP BY MONTH(transfer_time), bank_id
ORDER BY number DESC

-- 3.3缴费小于欠款，并缴费设备正确，缴纳费用为200元
-- 3.3.1缴费
CALL pay(1005, 200, 'CMB', 2008, @state1);
SELECT @state1;
-- 3.3.2查看欠费清单，跟滞纳金
SELECT * FROM cost_log;
-- 3.3.3查看欠费用户列表，是否有该用户
SELECT DISTINCT device.client_id, client_name
FROM cost_log JOIN (device JOIN client USING(client_id)) USING(device_id)
WHERE pay_state = '未缴' OR pay_state = '部分缴';
-- 3.3.4查看设备欠费金额
SELECT * FROM cost_log;
-- 3.3.5查看缴费记录是否正确
SELECT * FROM pay_log;

-- 3.4缴费大于欠款，并缴费设备正确，缴纳费用为200元
-- 3.4.1缴费
CALL pay(1005, 300, 'CMB', 2008, @state2);
SELECT @state2;
-- 3.4.2查看欠费清单，跟滞纳金
SELECT * FROM cost_log;
-- 3.4.3查看欠费用户列表，是否有该用户
SELECT DISTINCT device.client_id, client_name
FROM cost_log JOIN (device JOIN client USING(client_id)) USING(device_id)
WHERE pay_state = '未缴' OR pay_state = '部分缴';
-- 3.4.4查看设备欠费金额
SELECT * FROM cost_log;
-- 3.4.5查看缴费记录是否正确
SELECT * FROM pay_log;

-- 3.5冲正
-- 3.5.1缴费大于欠款，并缴费（其他人设备）正确，缴纳费用为100元，对方电表欠费50元
CALL pay(1005, 100, 'CMB', 2000, @state3); -- 用户1给裴行俭的设备2000缴费100元，100元足以支付设备2000全部欠款
SELECT @state3;
-- 3.5.2查看（其他）设备欠费金额
SELECT * FROM cost_log;
-- 3.5.3查看缴费记录是否正确
SELECT * FROM pay_log;
-- 3.5.4查看缴费用户余额跟余额变化记录
SELECT * FROM balance_log;
-- 3.5.5冲正
CALL revert(5005, @state4); -- 5005需要查看transfer_log得到
SELECT @state4;
-- 3.5.6查看缴费用户余额跟余额变化记录
SELECT * FROM balance_log;
-- 3.5.7查看（其他）设备欠费金额
SELECT * FROM cost_log;

-- 4.对账
-- 4.1对总账
-- 4.1.1执行对总账，核对2019-02-20日账单
CALL check_total('CMB', 3, 600, str_to_date('20-02-2019', '%d-%m-%Y'), @state5); -- 3和600是提前算好的
SELECT @state5;
-- 4.1.1查看对总账存储过程
SELECT * FROM total_log;

-- 4.2对明细
-- 4.2.1删除一次转账记录
DELETE FROM pay_log WHERE pay_id = 6005; -- 提前指定的6005(是冲正时产生的那条记录)
-- 4.2.2执行对明细，核对2019-02-20日账单
CALL check_detail('CMB', str_to_date('20-02-2019', '%d-%m-%Y'));
-- 4.2.3查看对明细存储过程

-- 4.3查看对账异常(打开错误日志，查看对账异常是否正确输出)
SELECT * FROM error_log;