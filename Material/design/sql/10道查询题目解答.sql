/*==============================================================*/
/* DBMS name:      MySQL 5.7                                    */
/* Created on:     2018/8/24 20:26:16                           */
/* Content:		   2018数据库实验课 SQL语句 10题
/*==============================================================*/

-- Q1：查询出所有欠费用户
SELECT power_rate_list.CUSTOMER_ID, CUSTOMER_NAME
FROM power_rate_list JOIN customer USING (CUSTOMER_ID)
WHERE PAY_STATE = 0

/* Runnig Result
# CUSTOMER_ID, CUSTOMER_NAME
1000, 裴行俭
1002, 潘育龙
1002, 潘育龙
1000, 裴行俭
1004, 周亚夫

*/

-- Q2；查询出拥有超过2个设备的用户
SELECT CUSTOMER_ID, CUSTOMER_NAME
FROM device JOIN customer USING (CUSTOMER_ID)
GROUP BY CUSTOMER_ID
HAVING COUNT(CUSTOMER_ID) > 2

/* Runnig Result
# CUSTOMER_ID, CUSTOMER_NAME
1002, 潘育龙

*/

-- Q3：统计电力企业某每天的总应收费用，实收费用
SELECT 	(SELECT SUM(TRANSFER_AMOUNT)
		FROM bank_transfer_record) AS '总应收费用', 
		(SELECT SUM(PAY_AMOUNT)
		FROM pay_log) AS '总实收费用'
        
/* Runnig Result
# 总应收费用, 总实收费用
331.00, 331.00

*/

-- Q4：查询出所有欠费超过半年的用户
SELECT power_rate_list.CUSTOMER_ID, CUSTOMER_NAME
FROM power_rate_list JOIN customer USING (CUSTOMER_ID)
WHERE PAY_STATE = 0 AND TIMESTAMPDIFF(MONTH, MT_DATE, NOW()) > 6

/* Runnig Result
# CUSTOMER_ID, CUSTOMER_NAME
1000, 裴行俭

*/

-- Q5：查询任意用户的欠费总额
SELECT CUSTOMER_ID, CUSTOMER_NAME, (PAID_FEE)
FROM power_rate_list JOIN CUSTOMER USING (CUSTOMER_ID)
WHERE PAY_STATE = 0
GROUP BY CUSTOMER_ID

/* Runnig Result
# CUSTOMER_ID, CUSTOMER_NAME, PAID_FEE
1000, 裴行俭, 28.91
1002, 潘育龙, 43.37
1004, 周亚夫, 56.66

*/

-- Q6：查询出某个月用电量最高的3名用户
SELECT MONTH(A.MT_DATE) AS 'MONTH' ,CUSTOMER_ID, CUSTOMER_NAME
FROM power_rate_list A JOIN CUSTOMER USING (CUSTOMER_ID)
WHERE (SELECT count(CUSTOMER_ID)
FROM power_rate_list B
WHERE MONTH(A.MT_DATE) = MONTH(B.MT_DATE) AND B.END_NUMBER-B.BEGIN_NUMBER > A.END_NUMBER-A.BEGIN_NUMBER) <=2

/*
# MONTH, CUSTOMER_ID, CUSTOMER_NAME
1, 1000, 裴行俭
6, 1002, 潘育龙
7, 1002, 潘育龙
3, 1001, 秦良玉
4, 1001, 秦良玉
7, 1003, 卫青
7, 1004, 周亚夫

*/

-- Q7：查询出电力企业某每个月哪天的缴费人数最多
SELECT MONTH(PAY_TIME) AS '月份', DAY(PAY_TIME) AS '缴费人数最多日'
FROM pay_log A
WHERE DAY(A.PAY_TIME) >= ALL (SELECT DAY(PAY_TIME)
							  FROM pay_log B
							  WHERE MONTH(A.PAY_TIME) = MONTH(B.PAY_TIME))
GROUP BY MONTH(PAY_TIME)

/*
# 月份, 缴费人数最多日
8, 20

*/

-- Q8：按设备类型使用人数从高到低排序查询列出设备类型，使用人数。
SELECT DEVICE_TYPE, COUNT(*) AS 'number'
FROM device
GROUP BY DEVICE_TYPE
ORDER BY number DESC

/*
# DEVICE_TYPE, number
01, 5
02, 3

*/

-- Q9：统计每个月各银行缴费人次，从高到低排序。
SELECT MONTH(TRANSFER_TIME) AS 'month', COUNT(*) AS 'number'
FROM bank_transfer_record
GROUP BY MONTH(TRANSFER_TIME)
ORDER BY number DESC

/*
# month, number
8, 3

*/

-- Q10：查询出电力企业所有新增用户（使用设备不足半年）。
SELECT CUSTOMER_ID, CUSTOMER_NAME, MAX(MONTH(NOW())-MONTH(MT_DATE)) AS 'months'
FROM meter_log JOIN CUSTOMER USING (CUSTOMER_ID)
GROUP BY CUSTOMER_ID
HAVING MAX(MONTH(NOW())-MONTH(MT_DATE))<=6

/*
# CUSTOMER_ID, CUSTOMER_NAME, months
1001, 秦良玉, 5
1002, 潘育龙, 2
1003, 卫青, 1
1004, 周亚夫, 1

*/