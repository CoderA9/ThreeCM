/*
 *  LocalDef.h
 *  CQTComment
 *
 *  Created by sky on 12-2-14.
 *  Copyright 2012 CQTimes.cn. All rights reserved.
 *
 */


//
#define kCurrentServicesTableNameKey     @"currentServicesTableName"


#define kID                     @"_ID"
#define kCaseDate			    @"date"
#define kTableUserInfo		    @"UserInfo"
#define kTableMessages		    @"Messages"
#define kTableServices  		@"Services"

#define kServiceAppURLKey                                 @"s_app_url"
#define kServiceAppSchemaKey                              @"s_app_schema"
#define kServiceAppValidateTimeKey                        @"s_app_time"
#define kServiceAppPathKey                                @"s_app_path"

#define  kCreateTableMessagesSQL      @"CREATE TABLE IF NOT EXISTS messages (_ID integer PRIMARY KEY AUTOINCREMENT, id int(32), s_id int(32), s_name varchar(32), h_name varchar(32), h_id int(32),  m_id int(32), m_name varchar(32), cardid int(32), mes varchar(200),  time int(32) not null default 0, read int not null default 0)"


#define  kCreateTableServicesSQL      @"CREATE TABLE IF NOT EXISTS Services (_ID integer PRIMARY KEY AUTOINCREMENT, id int(32), s_id int(32), user_id int, user_id_mod int, user_id_Cre int, pid int, pname varchar(32), s_name varchar(32), s_discount float, s_frequency int, s_cash_max double, s_cash_min double, s_type int, department varchar(32), departmentid int, s_money double, s_point float, s_Conversiontype int(8), s_Increaseintype int(8), s_Money_integration float, s_Integration_money float, s_hdnums int(8), s_persons int(8), s_introduce varchar(1024), s_sflow varchar(1024), s_rights varchar(1024), s_time int, min_thumb_url varchar(256), s_app_url varchar(128), s_app_schema varchar(32), s_app_path varchar(128), s_app_time int(32))"
