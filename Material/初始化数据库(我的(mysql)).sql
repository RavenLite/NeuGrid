/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2018/8/24 10:12:14                           */
/*==============================================================*/


drop table if exists ACCOUNT;

drop table if exists BANK;

drop table if exists CLIENT;

drop table if exists CODE_TABLE;

drop index POWER_DEVICE_ID_PAYABLE_DATE on COST_LOG;

drop table if exists COST_LOG;

drop table if exists DEVICE;

drop table if exists ERROR_LOG;

drop table if exists PAY_LOG;

drop table if exists READER;

drop index METER_LOG_DEVICE_ID_MT_DATE on READ_LOG;

drop table if exists READ_LOG;

drop table if exists TOTAL_LOG;

drop table if exists TRANSFER_LOG;

/*==============================================================*/
/* Table: ACCOUNT                                               */
/*==============================================================*/
create table ACCOUNT
(
   CLIENT_ID            bigint,
   BANK_ID              varchar(9)
);

/*==============================================================*/
/* Table: BANK                                                  */
/*==============================================================*/
create table BANK
(
   BANK_ID              VARCHAR(9) not null,
   BANK_NAME            VARCHAR(30) not null,
   primary key (BANK_ID)
);

/*==============================================================*/
/* Table: CLIENT                                                */
/*==============================================================*/
create table CLIENT
(
   CLIENT_ID            BIGINT not null,
   CLIENT_NAME          VARCHAR(30) not null,
   ADDRESS              VARCHAR(90) not null,
   BALANCE              DECIMAL(9,2),
   primary key (CLIENT_ID)
);

/*==============================================================*/
/* Table: CODE_TABLE                                            */
/*==============================================================*/
create table CODE_TABLE
(
   C_KEY                VARCHAR(30) not null,
   C_VALUE              VARCHAR(9) not null,
   primary key (C_KEY)
);

/*==============================================================*/
/* Table: COST_LOG                                              */
/*==============================================================*/
create table COST_LOG
(
   COST_ID              BIGINT not null,
   DEVICE_ID            BIGINT not null,
   DATE                 DATETIME not null,
   BEGIN_NUMBER         BIGINT,
   END_NUMBER           BIGINT,
   BASIC_COST           DECIMAL(9,2),
   ADDITIONAL_COST_1    DECIMAL(9,2),
   ADDITIONAL_COST_2    DECIMAL(9,2),
   PAID_FEE             DECIMAL(9,2),
   ACTUAL_FEE           DECIMAL(9,2),
   LATE_FEE             DECIMAL(9,2),
   PAYABLE_DATE         DATETIME,
   PAY_DATE             DATETIME,
   ALREADY_FEE          DECIMAL(9,2) default 0.00,
   PAY_STATE            VARCHAR(1),
   primary key (COST_ID)
);

/*==============================================================*/
/* Index: POWER_DEVICE_ID_PAYABLE_DATE                          */
/*==============================================================*/
create unique index POWER_DEVICE_ID_PAYABLE_DATE on COST_LOG
(
   DEVICE_ID,
   PAYABLE_DATE
);

/*==============================================================*/
/* Table: DEVICE                                                */
/*==============================================================*/
create table DEVICE
(
   DEVICE_ID            BIGINT not null,
   CLIENT_ID            BIGINT not null,
   DEVICE_TYPE          VARCHAR(2) not null,
   primary key (DEVICE_ID)
);

/*==============================================================*/
/* Table: ERROR_LOG                                             */
/*==============================================================*/
create table ERROR_LOG
(
   ERROR_ID             BIGINT not null,
   ACCOUNT_TIME         DATETIME not null,
   BANK_ID              VARCHAR(9) not null,
   TRANSFER_ID          BIGINT not null,
   CLIENT_ID            BIGINT not null,
   BANK_AMOUNT          DECIMAL(9,2) not null,
   ENTERPRISE_AMOUNT    DECIMAL(9,2) not null,
   ACCOUNT_INFO         VARCHAR(30),
   primary key (ERROR_ID)
);

/*==============================================================*/
/* Table: PAY_LOG                                               */
/*==============================================================*/
create table PAY_LOG
(
   PAY_ID               BIGINT not null,
   CLIENT_ID            BIGINT not null,
   PAY_TIME             DATETIME not null,
   PAY_AMOUNT           DECIMAL(9,2) not null,
   PAY_TYPE             VARCHAR(2) not null,
   BANK_ID              varchar(9),
   TRANSFER_ID          bigint,
   NOTES                VARCHAR(90),
   primary key (PAY_ID)
);

/*==============================================================*/
/* Table: READER                                                */
/*==============================================================*/
create table READER
(
   READER_ID            BIGINT not null,
   READER_NAME          VARCHAR(30) not null,
   primary key (READER_ID)
);

/*==============================================================*/
/* Table: READ_LOG                                              */
/*==============================================================*/
create table READ_LOG
(
   READ_ID              BIGINT not null,
   READ_DATE            DATETIME not null,
   DEVICE_ID            BIGINT not null,
   CLIENT_ID            BIGINT not null,
   READ_NUMBER          BIGINT not null,
   READER_ID            BIGINT,
   primary key (READ_ID)
);

/*==============================================================*/
/* Index: METER_LOG_DEVICE_ID_MT_DATE                           */
/*==============================================================*/
create unique index METER_LOG_DEVICE_ID_MT_DATE on READ_LOG
(
   DEVICE_ID,
   READ_DATE
);

/*==============================================================*/
/* Table: TOTAL_LOG                                             */
/*==============================================================*/
create table TOTAL_LOG
(
   TOTAL_ID             BIGINT not null,
   ACCOUNT_DATE         DATETIME not null,
   BANK_ID              VARCHAR(9) not null,
   BANK_COUNT           BIGINT not null,
   BANK_AMOUNT          DECIMAL(9,2) not null,
   ENTERPRISE_COUNT     BIGINT not null,
   ENTERPRISE_AMOUNT    DECIMAL(9,2) not null,
   IS_SUCCESS           VARCHAR(2),
   primary key (TOTAL_ID)
);

/*==============================================================*/
/* Table: TRANSFER_LOG                                          */
/*==============================================================*/
create table TRANSFER_LOG
(
   TRANSFER_ID          BIGINT not null,
   BANK_ID              VARCHAR(9) not null,
   CLIENT_ID            BIGINT not null,
   TRANSFER_AMOUNT      DECIMAL(9,2) not null,
   TRANSFER_TIME        DATETIME not null,
   primary key (TRANSFER_ID)
);

alter table ACCOUNT add constraint FK_Reference_10 foreign key (CLIENT_ID)
      references CLIENT (CLIENT_ID) on delete restrict on update restrict;

alter table ACCOUNT add constraint FK_Reference_11 foreign key (BANK_ID)
      references BANK (BANK_ID) on delete restrict on update restrict;

alter table COST_LOG add constraint POWER_RATE_LIST_DEVICE_ID_FK foreign key (DEVICE_ID)
      references DEVICE (DEVICE_ID);

alter table ERROR_LOG add constraint FK_Reference_8 foreign key (BANK_ID)
      references BANK (BANK_ID) on delete restrict on update restrict;

alter table PAY_LOG add constraint PAY_LOG_CUSTOMER_ID_FK foreign key (CLIENT_ID)
      references CLIENT (CLIENT_ID);

alter table READ_LOG add constraint METER_LOG_CUSTOMER_ID_FK foreign key (CLIENT_ID)
      references CLIENT (CLIENT_ID);

alter table READ_LOG add constraint METER_LOG_DEVICE_ID_FK foreign key (DEVICE_ID)
      references DEVICE (DEVICE_ID);

alter table READ_LOG add constraint METER_LOG_MR_ID_FK foreign key (READER_ID)
      references READER (READER_ID);

alter table TOTAL_LOG add constraint FK_Reference_9 foreign key (BANK_ID)
      references BANK (BANK_ID) on delete restrict on update restrict;

alter table TRANSFER_LOG add constraint BANK_TRANSFER_CUSTOMER_ID_FK foreign key (CLIENT_ID)
      references CLIENT (CLIENT_ID);

alter table TRANSFER_LOG add constraint FK_Reference_7 foreign key (BANK_ID)
      references BANK (BANK_ID) on delete restrict on update restrict;

/*==============================================================*/
/* Insert                                    					*/
/*==============================================================*/
insert into COST_LOG (COST_ID, DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (4006, 2006, str_to_date('07-07-2018', '%d-%m-%Y'), 0, 64, 31.36, 2.51, 4.7, 38.57, 40.19, 1.62, str_to_date('31-07-2018', '%d-%m-%Y'), str_to_date('19-08-2018 19:54:56', '%d-%m-%Y %H:%i:%s'), 40.19, '1');
insert into COST_LOG (COST_ID, DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (4000, 2000, str_to_date('05-01-2018', '%d-%m-%Y'), 0, 50, 24.5, 1.96, 2.45, 28.91, null, null, str_to_date('31-01-2018', '%d-%m-%Y'), null, 0, '0');
insert into COST_LOG (COST_ID, DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (4001, 2003, str_to_date('05-06-2018', '%d-%m-%Y'), 0, 75, 36.75, 2.94, 3.68, 43.37, null, null, str_to_date('30-06-2018', '%d-%m-%Y'), null, 0, '0');
insert into COST_LOG (COST_ID, DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (4002, 2003, str_to_date('05-07-2018', '%d-%m-%Y'), 75, 175, 49, 3.92, 4.9, 57.82, null, null, str_to_date('31-07-2018', '%d-%m-%Y'), null, 0, '0');
insert into COST_LOG (COST_ID, DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (4003, 2000, str_to_date('05-07-2018', '%d-%m-%Y'), 50, 90, 19.6, 1.57, 1.96, 23.13, null, null, str_to_date('31-07-2018', '%d-%m-%Y'), null, 0, '0');
insert into COST_LOG (COST_ID, DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (4004, 2002, str_to_date('05-03-2018', '%d-%m-%Y'), 0, 90, 44.1, 3.53, 4.41, 52.04, 59.43, 7.39, str_to_date('31-03-2018', '%d-%m-%Y'), str_to_date('20-08-2018 00:46:27', '%d-%m-%Y %H:%i:%s'), 59.43, '1');
insert into COST_LOG (COST_ID, DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (4005, 2002, str_to_date('05-04-2018', '%d-%m-%Y'), 90, 210, 58.8, 4.7, 5.88, 69.38, 77.15, 7.77, str_to_date('30-04-2018', '%d-%m-%Y'), str_to_date('20-08-2018 00:47:48', '%d-%m-%Y %H:%i:%s'), 77.15, '1');
insert into COST_LOG (COST_ID, DEVICE_ID, DATE, BEGIN_NUMBER, END_NUMBER, BASIC_COST, ADDITIONAL_COST_1, ADDITIONAL_COST_2, PAID_FEE, ACTUAL_FEE, LATE_FEE, PAYABLE_DATE, PAY_DATE, ALREADY_FEE, PAY_STATE)
values (4007, 2007, str_to_date('01-07-2018', '%d-%m-%Y'), 0, 98, 48.02, 3.84, 4.8, 56.66, null, null, str_to_date('31-07-2018', '%d-%m-%Y'), null, 0, '0');
commit;

insert into PAY_LOG (PAY_ID, CLIENT_ID, PAY_TIME, PAY_AMOUNT, PAY_TYPE, BANK_ID, TRANSFER_ID, NOTES)
values (6000, 1001, str_to_date('20-08-2018 00:46:27', '%d-%m-%Y %H:%i:%s'), 100, '01', 'CMB', 5000, '4004');
insert into PAY_LOG (PAY_ID, CLIENT_ID, PAY_TIME, PAY_AMOUNT, PAY_TYPE, BANK_ID, TRANSFER_ID, NOTES)
values (6001, 1001, str_to_date('20-08-2018 00:47:48', '%d-%m-%Y %H:%i:%s'), 150, '01', 'CMB', 5001, '4005');
insert into PAY_LOG (PAY_ID, CLIENT_ID, PAY_TIME, PAY_AMOUNT, PAY_TYPE, BANK_ID, TRANSFER_ID, NOTES)
values (6002, 1003, str_to_date('20-08-2018 19:54:56', '%d-%m-%Y %H:%i:%s'), 81, '01', 'ICBC', 5002, '4006');
commit;

insert into PAY_LOG (PAY_ID, CLIENT_ID, PAY_TIME, PAY_AMOUNT, PAY_TYPE, BANK_ID, BT_ID, NOTES)
values (6000, 1001, str_to_date('20-08-2018 00:46:27', '%d-%m-%Y %H:%i:%s'), 100, '01', 'CMB', 5000, '4004');
insert into PAY_LOG (PAY_ID, CLIENT_ID, PAY_TIME, PAY_AMOUNT, PAY_TYPE, BANK_ID, BT_ID, NOTES)
values (6001, 1001, str_to_date('20-08-2018 00:47:48', '%d-%m-%Y %H:%i:%s'), 150, '01', 'CMB', 5001, '4005');
insert into PAY_LOG (PAY_ID, CLIENT_ID, PAY_TIME, PAY_AMOUNT, PAY_TYPE, BANK_ID, BT_ID, NOTES)
values (6002, 1003, str_to_date('20-08-2018 19:54:56', '%d-%m-%Y %H:%i:%s'), 81, '01', 'ICBC', 5002, '4006');
commit;

insert into READ_LOG (READ_ID, READ_DATE, DEVICE_ID, CLIENT_ID, READ_NUMBER, READER_ID)
values (3006, str_to_date('07-07-2018', '%d-%m-%Y'), 2006, 1003, 64, 1);
insert into READ_LOG (READ_ID, READ_DATE, DEVICE_ID, CLIENT_ID, READ_NUMBER, READER_ID)
values (3000, str_to_date('05-01-2018', '%d-%m-%Y'), 2000, 1000, 50, 1);
insert into READ_LOG (READ_ID, READ_DATE, DEVICE_ID, CLIENT_ID, READ_NUMBER, READER_ID)
values (3001, str_to_date('05-06-2018', '%d-%m-%Y'), 2003, 1002, 75, 1);
insert into READ_LOG (READ_ID, READ_DATE, DEVICE_ID, CLIENT_ID, READ_NUMBER, READER_ID)
values (3002, str_to_date('05-07-2018', '%d-%m-%Y'), 2003, 1002, 175, 1);
insert into READ_LOG (READ_ID, READ_DATE, DEVICE_ID, CLIENT_ID, READ_NUMBER, READER_ID)
values (3003, str_to_date('05-07-2018', '%d-%m-%Y'), 2000, 1000, 90, 1);
insert into READ_LOG (READ_ID, READ_DATE, DEVICE_ID, CLIENT_ID, READ_NUMBER, READER_ID)
values (3004, str_to_date('05-03-2018', '%d-%m-%Y'), 2002, 1001, 90, 1);
insert into READ_LOG (READ_ID, READ_DATE, DEVICE_ID, CLIENT_ID, READ_NUMBER, READER_ID)
values (3005, str_to_date('05-04-2018', '%d-%m-%Y'), 2002, 1001, 210, 1);
insert into READ_LOG (READ_ID, READ_DATE, DEVICE_ID, CLIENT_ID, READ_NUMBER, READER_ID)
values (3007, str_to_date('01-07-2018', '%d-%m-%Y'), 2007, 1004, 98, 1);
commit;

insert into READER (READER_ID, READER_NAME)
values (1, '王进宝');
commit;

insert into DEVICE (DEVICE_ID, CLIENT_ID, DEVICE_TYPE)
values (2000, 1000, '01');
insert into DEVICE (DEVICE_ID, CLIENT_ID, DEVICE_TYPE)
values (2001, 1000, '02');
insert into DEVICE (DEVICE_ID, CLIENT_ID, DEVICE_TYPE)
values (2002, 1001, '01');
insert into DEVICE (DEVICE_ID, CLIENT_ID, DEVICE_TYPE)
values (2003, 1002, '01');
insert into DEVICE (DEVICE_ID, CLIENT_ID, DEVICE_TYPE)
values (2006, 1003, '02');
insert into DEVICE (DEVICE_ID, CLIENT_ID, DEVICE_TYPE)
values (2004, 1002, '02');
insert into DEVICE (DEVICE_ID, CLIENT_ID, DEVICE_TYPE)
values (2005, 1002, '01');
insert into DEVICE (DEVICE_ID, CLIENT_ID, DEVICE_TYPE)
values (2007, 1004, '01');
commit;

insert into CODE_TABLE (C_KEY, C_VALUE)
values ('每度电价格', '0.49');
insert into CODE_TABLE (C_KEY, C_VALUE)
values ('居民当年违约金比例', '0.001');
insert into CODE_TABLE (C_KEY, C_VALUE)
values ('居民跨年违约金比例', '0.001');
insert into CODE_TABLE (C_KEY, C_VALUE)
values ('企业当年违约金比例', '0.002');
insert into CODE_TABLE (C_KEY, C_VALUE)
values ('企业跨年违约金比例', '0.003');
commit;

insert into TRANSFER_LOG (TRANSFER_ID, BANK_ID, CLIENT_ID, TRANSFER_AMOUNT, TRANSFER_TIME)
values (5000, 'CMB', 1001, 100, str_to_date('20-08-2018 00:46:27', '%d-%m-%Y %H:%i:%s'));
insert into TRANSFER_LOG (TRANSFER_ID, BANK_ID, CLIENT_ID, TRANSFER_AMOUNT, TRANSFER_TIME)
values (5001, 'CMB', 1001, 150, str_to_date('20-08-2018 00:47:48', '%d-%m-%Y %H:%i:%s'));
insert into TRANSFER_LOG (TRANSFER_ID, BANK_ID, CLIENT_ID, TRANSFER_AMOUNT, TRANSFER_TIME)
values (5002, 'ICBC', 1003, 81, str_to_date('20-08-2018 19:54:56', '%d-%m-%Y %H:%i:%s'));
commit;

insert into CLIENT (CLIENT_ID, CLIENT_NAME, ADDRESS, BALANCE)
values (1000, '裴行俭', '沈阳海润国际', 4.98);
insert into CLIENT (CLIENT_ID, CLIENT_NAME, ADDRESS, BALANCE)
values (1001, '秦良玉', '沈阳碧桂园银河城', 130.32);
insert into CLIENT (CLIENT_ID, CLIENT_NAME, ADDRESS, BALANCE)
values (1002, '潘育龙', '沈阳长白岛', 101.45);
insert into CLIENT (CLIENT_ID, CLIENT_NAME, ADDRESS, BALANCE)
values (1003, '卫青', '沈阳华强城', 90.81);
insert into CLIENT (CLIENT_ID, CLIENT_NAME, ADDRESS, BALANCE)
values (1004, '周亚夫', '沈阳恒大绿洲', 80);
commit;

insert into BANK (BANK_ID, BANK_NAME)
values ('CMB', '中国招商银行');
insert into BANK (BANK_ID, BANK_NAME)
values ('CCB', '中国建设银行');
insert into BANK (BANK_ID, BANK_NAME)
values ('ICBC', '中国工商银行');
commit;