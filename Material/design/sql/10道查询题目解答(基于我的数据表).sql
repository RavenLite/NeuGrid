/*==============================================================*/
/* DBMS name:      MySQL 5.7                                    */
/* Created on:     2018/8/24 20:26:16                           */
/* Content:		   2018数据库实验课 SQL语句 10题
/*==============================================================*/

-- Q1：查询出所有欠费用户
SELECT DISTINCT device.client_id
FROM cost_log JOIN device USING(device_id)
WHERE pay_state = '未缴' OR pay_state = '部分缴';

/* Runnig Result
client_id
1000
1002
1004
*/

-- Q2；查询出拥有超过2个设备的用户
SELECT client_id, client_name, address, balance
FROM device JOIN client USING(client_id)
GROUP BY client_id
HAVING COUNT(*) > 2;

/* Runnig Result
client_id	client_name	address	balance
1002	潘育龙	沈阳长白岛	5.00
*/

-- Q3：统计电力企业某天的总应收费用，实收费用
SELECT 	(SELECT SUM(transfer_amount)
		FROM transfer_log
		WHERE TO_DAYS(transfer_time) = TO_DAYS(str_to_date('20-08-2018', '%d-%m-%Y'))) AS '总应收费用', 
		(SELECT SUM(pay_amount)
		FROM pay_log
		WHERE TO_DAYS(pay_time) = TO_DAYS(str_to_date('20-08-2018', '%d-%m-%Y'))) AS '总实收费用';
/* Runnig Result
总应收费用	总实收费用
381.00	331.00
*/

-- Q4：查询出所有欠费超过半年的用户
SELECT client_id, client_name, address, balance
FROM cost_log JOIN (device JOIN client USING(client_id)) USING(device_id)
WHERE (pay_state = '未缴' OR pay_state = '部分缴') AND TIMESTAMPDIFF(MONTH, payable_date, NOW()) >= 6;

/* Runnig Result
client_id	client_name	address	balance
1000	裴行俭	沈阳海润国际	4.98
*/

-- Q5：查询任意用户的欠费总额
SELECT client_id, client_name, sum(paid_fee + calculate_late(payable_date, paid_fee, device_type)) AS '欠费总额'
FROM cost_log  JOIN (device JOIN client USING(client_id)) USING(device_id)
WHERE (pay_state = '未缴' OR pay_state = '部分缴') AND client_id = '1000';

/* Runnig Result
client_id	client_name	欠费总额
1000	裴行俭	58.78
*/

-- Q6：查询出某个月用电量最高的3名用户
SELECT MONTH(A.date) AS 'MONTH', client_id, client_name
FROM cost_log A JOIN client USING(client_id)
WHERE (SELECT count(client_id)
	   FROM cost_log B
	   WHERE (MONTH(A.date) = MONTH(B.date)) AND B.end_number - B.begin_number > A.end_number - A.begin_number) <= 2;
	   
	   
-- Q7：查询出电力企业某个月哪天的缴费人数最多
SELECT YEAR(pay_time), MONTH(pay_time), DAY(pay_time)
FROM pay_log
WHERE MONTH(pay_time) = 8 AND YEAR(pay_time) = 2018
GROUP BY(DAY(pay_time))
ORDER BY count(DAY(pay_time))
LIMIT 0,1;

/* Runnig Result
YEAR(pay_time)	MONTH(pay_time)	DAY(pay_time)
2018	8	20
*/

-- Q8：按设备类型使用人数从高到低排序查询列出设备类型，使用人数。
SELECT device_type, count(*) AS 'number'
FROM device JOIN client USING(client_id)
GROUP BY device_type
ORDER BY number DESC;

/* Runnig Result
device_type	number
01	5
02	3
*/

-- Q9：统计每个月各银行缴费人次，从高到低排序。
SELECT MONTH(transfer_time) AS 'month', COUNT(*) AS 'number'
FROM transfer_log
GROUP BY MONTH(transfer_time)
ORDER BY number DESC

/* Runnig Result
month	number
8	4
*/

-- Q10：查询出电力企业所有新增用户（使用设备不足半年）。
SELECT client_id, client_name
FROM read_log JOIN (client JOIN device USING(client_id)) USING(device_id)
GROUP BY client_id
HAVING MAX(MONTH(NOW()) - MONTH(read_date)) <= 6;

/* Running Result
client_id	client_name
1001	秦良玉
1002	潘育龙
1004	周亚夫
*/