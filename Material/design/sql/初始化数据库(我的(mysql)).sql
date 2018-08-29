/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* CREATEd on:     2018/8/24 10:12:14                           */
/*==============================================================*/
DROP TABLE IF EXISTS transfer_log;
DROP TABLE IF EXISTS total_log;
DROP TABLE IF EXISTS read_log;
DROP TABLE IF EXISTS pay_log;
DROP TABLE IF EXISTS error_log;
DROP TABLE IF EXISTS cost_log;
DROP TABLE IF EXISTS change_log;
DROP TABLE IF EXISTS balance_log;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS bank;
DROP TABLE IF EXISTS client;
DROP TABLE IF EXISTS code_table;
DROP TABLE IF EXISTS device;
DROP TABLE IF EXISTS reader;

-- CREATE SCHEMA neugrid;
-- USE neugrid;

/*==============================================================*/
/* Table 1: ACCOUNT	                                               */
/*==============================================================*/
CREATE TABLE account
(
   account_id			BIGINT AUTO_INCREMENT,  	-- 账户id
   client_id            BIGINT,						-- 客户id
   bank_id              VARCHAR(9),					-- 银行id
   PRIMARY KEY (account_id)
);

/*==============================================================*/
/* Table 2: BANK                                                  */
/*==============================================================*/
CREATE TABLE bank
(
   bank_id              VARCHAR(9) NOT NULL,		-- 银行id
   bank_name            VARCHAR(30) NOT NULL,		-- 银行名称
   PRIMARY KEY (bank_id)
);

/*================================================================*/
/* Table 3: CLIENT                                                */
/*================================================================*/
CREATE TABLE client
(
   client_id            BIGINT AUTO_INCREMENT,		-- 客户id，自增
   client_name          VARCHAR(30) NOT NULL,		-- 客户姓名
   ADDRESS              VARCHAR(90) NOT NULL,		-- 客户住址
   BALANCE              DECIMAL(9,2),				-- 客户余额
   PRIMARY KEY (client_id)
);

/*==============================================================*/
/* Table 4: CODE_TABLE                                            */
/*==============================================================*/
CREATE TABLE code_table
(
   code_key                VARCHAR(30) NOT NULL,	-- 常量键
   code_value              VARCHAR(9) NOT NULL,		-- 常量值
   PRIMARY KEY (code_key)
);

/*==============================================================*/
/* Table 5: COST_LOG                                              */
/*==============================================================*/
CREATE TABLE cost_log
(
   cost_id              BIGINT AUTO_INCREMENT,		-- 账单id，自增
   device_id            BIGINT NOT NULL,			-- 设备id
   date                 DATETIME NOT NULL,			-- 生成日期
   begin_number         BIGINT,						-- 初始表数
   end_number           BIGINT,						-- 抄表表数
   basic_cost           DECIMAL(9,2),				-- 基础花费
   additional_cost_1    DECIMAL(9,2),				-- 附加费1
   additional_cost_2    DECIMAL(9,2),				-- 附加费2
   paid_fee             DECIMAL(9,2),				-- 待支付费用(基础花费+附加费1+附加费2)
   actual_fee           DECIMAL(9,2),				-- 实际应付费用(待支付费用+滞纳金)
   late_fee             DECIMAL(9,2),				-- 滞纳金
   payable_date         DATETIME,					-- 应缴日期
   pay_date             DATETIME,					-- 缴费日期
   already_fee          DECIMAL(9,2) default 0.00,	-- 已交费用
   pay_state            VARCHAR(9),					-- 缴费状态(01:未缴 02:已缴 03:部分缴)
   PRIMARY KEY (cost_id)
);

/*==============================================================*/
/* Table 6: DEVICE                                                */
/*==============================================================*/
CREATE TABLE device
(
   device_id            BIGINT AUTO_INCREMENT,  	-- 设备id，自增
   client_id            BIGINT NOT NULL,			-- 客户id
   device_type          VARCHAR(2) NOT NULL,		-- 设备类型 01=个人 02=企业
   PRIMARY KEY (device_id)
);

/*==============================================================*/
/* Table 7: ERROR_LOG                                             */
/*==============================================================*/
CREATE TABLE error_log
(
   error_id             BIGINT AUTO_INCREMENT,		-- 错误id，自增
   account_time         DATETIME NOT NULL,			-- 交易时间
   bank_id              VARCHAR(9) NOT NULL,		-- 银行id
   transfer_id          BIGINT NOT NULL,			-- 转账id
   client_id            BIGINT NOT NULL,			-- 客户id
   bank_amount          DECIMAL(9,2) NOT NULL,		-- 银行金额
   enterprise_amount    DECIMAL(9,2) NOT NULL,		-- 企业金额
   error_type           VARCHAR(20),				-- 错误类型 01=企业方无流水信息，02=银行方无流水信息  03=金额不等
   PRIMARY KEY (error_id)
);

/*==============================================================*/
/* Table 8: PAY_LOG                                               */
/*==============================================================*/
CREATE TABLE pay_log
(
   pay_id               BIGINT AUTO_INCREMENT,		-- 缴费id
   client_id            BIGINT NOT NULL,			-- 客户id
   device_id            BIGINT NOT NULL,			-- 设备id
   pay_time             DATETIME NOT NULL,			-- 缴费时间
   pay_amount           DECIMAL(9,2) NOT NULL,		-- 缴费金额
   pay_type             VARCHAR(9) NOT NULL,		-- 缴费类型	01=缴费，02=冲正
   bank_id              VARCHAR(9),					-- 银行id
   transfer_id          BIGINT,						-- 银行流水id
   PRIMARY KEY (pay_id)
);

/*==============================================================*/
/* Table 9: READER                                                */
/*==============================================================*/
CREATE TABLE reader
(
   reader_id            BIGINT NOT NULL,			-- 抄表员id
   reader_name          VARCHAR(30) NOT NULL,		-- 抄表员姓名
   PRIMARY KEY (reader_id)
);

/*==============================================================*/
/* Table 10: READ_LOG                                              */
/*==============================================================*/
CREATE TABLE read_log
(
   read_id              BIGINT AUTO_INCREMENT,		-- 抄表记录id，自增
   read_date            DATETIME NOT NULL,			-- 抄表日期
   device_id            BIGINT NOT NULL,			-- 设备id
   read_number          BIGINT NOT NULL,			-- 当前读数
   reader_id            BIGINT,						-- 抄表员id
   PRIMARY KEY (read_id)
);

/*==============================================================*/
/* Table 11: TOTAL_LOG                                             */
/*==============================================================*/
CREATE TABLE total_log
(
   total_id             BIGINT AUTO_INCREMENT,
   account_date         DATETIME NOT NULL,
   bank_id              VARCHAR(9) NOT NULL,
   bank_count           BIGINT NOT NULL,
   bank_amount          DECIMAL(9,2) NOT NULL,
   enterprise_count     BIGINT NOT NULL,
   enterprise_amount    DECIMAL(9,2) NOT NULL,
   is_success           VARCHAR(2),
   PRIMARY KEY (total_id)
);

/*==============================================================*/
/* Table 12: TRANSFER_LOG                                          */
/*==============================================================*/
CREATE TABLE transfer_log
(
   transfer_id          BIGINT AUTO_INCREMENT,		-- 银行流水id，自增
   bank_id              VARCHAR(9) NOT NULL,		-- 银行id
   client_id            BIGINT NOT NULL,			-- 客户id
   transfer_amount      DECIMAL(9,2) NOT NULL,		-- 转账金额
   transfer_time        DATETIME NOT NULL,			-- 转账时间
   PRIMARY KEY (transfer_id)
);

/*==============================================================*/
/* Table 13: BALANCE_LOG                                          */
/*==============================================================*/
CREATE TABLE balance_log
(
   balance_id          	BIGINT AUTO_INCREMENT,		-- 余额变动id，自增
   now_balance          DECIMAL(9,2),				-- 当前余额
   client_id            BIGINT NOT NULL,			-- 客户id
   action		      	VARCHAR(9),					-- 变动类型(01-转账，02-缴费，03-冲正)
   date			        DATETIME NOT NULL,			-- 变动时间
   PRIMARY KEY (balance_id)
);

/*==============================================================*/
/* Table 14: CHANGE_LOG                                          */
/*==============================================================*/
CREATE TABLE change_log
(
   change_id          	BIGINT AUTO_INCREMENT,		-- 改变记录id，自增
   cost_id          	BIGINT,						-- 关联的账单id
   actual_fee_1         DECIMAL(9,2),				-- 改变前实际金额
   late_fee_1		    DECIMAL(9,2),				-- 改变前滞纳金
   pay_date_1			DATETIME,					-- 改变前付款日期
   already_fee_1		DECIMAL(9,2),				-- 改变前已付款金额
   pay_state_1			VARCHAR(2),					-- 改变前付款状态
   PRIMARY KEY (change_id)
);

alter table ACCOUNT add constraint FK_Reference_10 foreign key (client_id)
      references CLIENT (client_id) on delete restrict on update restrict;

alter table ACCOUNT add constraint FK_Reference_11 foreign key (bank_id)
      references BANK (bank_id) on delete restrict on update restrict;

alter table COST_LOG add constraint POWER_RATE_LIST_device_id_FK foreign key (device_id)
      references DEVICE (device_id);

alter table ERROR_LOG add constraint FK_Reference_8 foreign key (bank_id)
      references BANK (bank_id) on delete restrict on update restrict;

alter table PAY_LOG add constraint PAY_LOG_CUSTOMER_ID_FK foreign key (client_id)
      references CLIENT (client_id);

alter table READ_LOG add constraint METER_LOG_device_id_FK foreign key (device_id)
      references DEVICE (device_id);

alter table READ_LOG add constraint METER_LOG_MR_ID_FK foreign key (READER_ID)
      references READER (READER_ID);

alter table TOTAL_LOG add constraint FK_Reference_9 foreign key (bank_id)
      references BANK (bank_id) on delete restrict on update restrict;

alter table TRANSFER_LOG add constraint BANK_TRANSFER_CUSTOMER_ID_FK foreign key (client_id)
      references CLIENT (client_id);

alter table TRANSFER_LOG add constraint FK_Reference_7 foreign key (bank_id)
      references BANK (bank_id) on delete restrict on update restrict;
	  
alter table client AUTO_INCREMENT = 1000;
alter table device AUTO_INCREMENT = 2000;
alter table read_log AUTO_INCREMENT = 3000;
alter table cost_log AUTO_INCREMENT = 4000;
alter table transfer_log AUTO_INCREMENT = 5000;
alter table pay_log AUTO_INCREMENT = 6000;
alter table total_log AUTO_INCREMENT = 7000;
alter table error_log AUTO_INCREMENT = 8000;
alter table balance_log AUTO_INCREMENT = 9000;
alter table account AUTO_INCREMENT = 10000;
alter table change_log AUTO_INCREMENT = 11000;

/*==============================================================*/
/* Insert                                    					*/
/*==============================================================*/

insert into CLIENT (client_name, ADDRESS, BALANCE)
values ('裴行俭', '沈阳海润国际', 4.98);
insert into CLIENT (client_name, ADDRESS, BALANCE)
values ('秦良玉', '沈阳碧桂园银河城', 130.32);
insert into CLIENT (client_name, ADDRESS, BALANCE)
values ('潘育龙', '沈阳长白岛', 101.45);
insert into CLIENT (client_name, ADDRESS, BALANCE)
values ('卫青', '沈阳华强城', 90.81);
insert into CLIENT (client_name, ADDRESS, BALANCE)
values ('周亚夫', '沈阳恒大绿洲', 80);
commit;

insert into BANK (bank_id, BANK_NAME)
values ('CMB', '中国招商银行');
insert into BANK (bank_id, BANK_NAME)
values ('CCB', '中国建设银行');
insert into BANK (bank_id, BANK_NAME)
values ('ICBC', '中国工商银行');
commit;

insert into CODE_TABLE (code_key, code_value)
values ('每度电价格', '0.49');
insert into CODE_TABLE (code_key, code_value)
values ('居民当年违约金比例', '0.001');
insert into CODE_TABLE (code_key, code_value)
values ('居民跨年违约金比例', '0.001');
insert into CODE_TABLE (code_key, code_value)
values ('企业当年违约金比例', '0.002');
insert into CODE_TABLE (code_key, code_value)
values ('企业跨年违约金比例', '0.003');
commit;

insert into TRANSFER_LOG (bank_id, client_id, transfer_amount, transfer_time)
values ('CMB', 1001, 100, str_to_date('20-08-2018 00:46:27', '%d-%m-%Y %H:%i:%s'));
insert into TRANSFER_LOG (bank_id, client_id, transfer_amount, transfer_time)
values ('CMB', 1001, 150, str_to_date('20-08-2018 00:47:48', '%d-%m-%Y %H:%i:%s'));
insert into TRANSFER_LOG (bank_id, client_id, transfer_amount, transfer_time)
values ('ICBC', 1003, 81, str_to_date('20-08-2018 19:54:56', '%d-%m-%Y %H:%i:%s'));
insert into TRANSFER_LOG (bank_id, client_id, transfer_amount, transfer_time)
values ('CMB', 1001, 50, str_to_date('20-08-2018 00:47:27', '%d-%m-%Y %H:%i:%s'));
commit;

insert into READER (READER_ID, READER_NAME)
values (1, '王进宝');
commit;

insert into DEVICE (client_id, device_type)
values (1000, '01');
insert into DEVICE (client_id, device_type)
values (1000, '02');
insert into DEVICE (client_id, device_type)
values (1001, '01');
insert into DEVICE (client_id, device_type)
values (1002, '01');
insert into DEVICE (client_id, device_type)
values (1003, '02');
insert into DEVICE (client_id, device_type)
values (1002, '02');
insert into DEVICE (client_id, device_type)
values (1002, '01');
insert into DEVICE (client_id, device_type)
values (1004, '01');
commit;

insert into READ_LOG (READ_DATE, device_id, READ_NUMBER, READER_ID)
values (str_to_date('07-07-2018', '%d-%m-%Y'), 2006, 64, 1);
insert into READ_LOG (READ_DATE, device_id, READ_NUMBER, READER_ID)
values (str_to_date('05-01-2018', '%d-%m-%Y'), 2000, 50, 1);
insert into READ_LOG (READ_DATE, device_id, READ_NUMBER, READER_ID)
values (str_to_date('05-06-2018', '%d-%m-%Y'), 2003, 75, 1);
insert into READ_LOG (READ_DATE, device_id, READ_NUMBER, READER_ID)
values (str_to_date('05-07-2018', '%d-%m-%Y'), 2003, 175, 1);
insert into READ_LOG (READ_DATE, device_id, READ_NUMBER, READER_ID)
values (str_to_date('05-07-2018', '%d-%m-%Y'), 2000, 90, 1);
insert into READ_LOG (READ_DATE, device_id, READ_NUMBER, READER_ID)
values (str_to_date('05-03-2018', '%d-%m-%Y'), 2002, 90, 1);
insert into READ_LOG (READ_DATE, device_id, READ_NUMBER, READER_ID)
values (str_to_date('05-04-2018', '%d-%m-%Y'), 2002, 210, 1);
insert into READ_LOG (READ_DATE, device_id, READ_NUMBER, READER_ID)
values (str_to_date('01-07-2018', '%d-%m-%Y'), 2007, 98, 1);
commit;

insert into COST_LOG (DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (2006, str_to_date('07-07-2018', '%d-%m-%Y'), 0, 64, 31.36, 2.51, 4.7, 38.57, 40.19, 1.62, str_to_date('31-07-2018', '%d-%m-%Y'), str_to_date('19-08-2018 19:54:56', '%d-%m-%Y %H:%i:%s'), 40.19, '已缴');
insert into COST_LOG (DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (2000, str_to_date('05-01-2018', '%d-%m-%Y'), 0, 50, 24.5, 1.96, 2.45, 28.91, null, null, str_to_date('31-01-2018', '%d-%m-%Y'), null, 0, '未缴');
insert into COST_LOG (DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (2003, str_to_date('05-06-2018', '%d-%m-%Y'), 0, 75, 36.75, 2.94, 3.68, 43.37, null, null, str_to_date('30-06-2018', '%d-%m-%Y'), null, 0, '未缴');
insert into COST_LOG (DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (2003, str_to_date('05-07-2018', '%d-%m-%Y'), 75, 175, 49, 3.92, 4.9, 57.82, null, null, str_to_date('31-07-2018', '%d-%m-%Y'), null, 0, '未缴');
insert into COST_LOG (DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (2000, str_to_date('05-07-2018', '%d-%m-%Y'), 50, 90, 19.6, 1.57, 1.96, 23.13, null, null, str_to_date('31-07-2018', '%d-%m-%Y'), null, 0, '未缴');
insert into COST_LOG (DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (2002, str_to_date('05-03-2018', '%d-%m-%Y'), 0, 90, 44.1, 3.53, 4.41, 52.04, 59.43, 7.39, str_to_date('31-03-2018', '%d-%m-%Y'), str_to_date('20-08-2018 00:46:27', '%d-%m-%Y %H:%i:%s'), 59.43, '已缴');
insert into COST_LOG (DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (2002, str_to_date('05-04-2018', '%d-%m-%Y'), 90, 210, 58.8, 4.7, 5.88, 69.38, 77.15, 7.77, str_to_date('30-04-2018', '%d-%m-%Y'), str_to_date('20-08-2018 00:47:48', '%d-%m-%Y %H:%i:%s'), 77.15, '已缴');
insert into COST_LOG (DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (2007, str_to_date('01-07-2018', '%d-%m-%Y'), 0, 98, 48.02, 3.84, 4.8, 56.66, null, null, str_to_date('31-07-2018', '%d-%m-%Y'), null, 0, '未缴');
commit;

insert into PAY_LOG (client_id, device_id, PAY_TIME, PAY_AMOUNT, PAY_TYPE, bank_id, transfer_id)
values (1001, 2002, str_to_date('20-08-2018 00:46:27', '%d-%m-%Y %H:%i:%s'), 100, '缴费', 'CMB', 5000);
insert into PAY_LOG (client_id, device_id, PAY_TIME, PAY_AMOUNT, PAY_TYPE, bank_id, transfer_id)
values (1001, 2002, str_to_date('20-08-2018 00:47:48', '%d-%m-%Y %H:%i:%s'), 150, '缴费', 'CMB', 5001);
insert into PAY_LOG (client_id, device_id, PAY_TIME, PAY_AMOUNT, PAY_TYPE, bank_id, transfer_id)
values (1003, 2004, str_to_date('20-08-2018 19:54:56', '%d-%m-%Y %H:%i:%s'), 81, '缴费', 'ICBC', 5002);
commit;