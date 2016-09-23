CREATE TABLE `report_user_summary` (
  `day` int(11) NOT NULL DEFAULT '0' COMMENT '天',
  `totals` int(11) NOT NULL DEFAULT '0' COMMENT '总用户数',
  `registers` int(11) NOT NULL DEFAULT '0' COMMENT '注册用户数',
  `logins` int(11) NOT NULL DEFAULT '0' COMMENT '登陆用户数',
  PRIMARY KEY (`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='总表报表';

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_report_day`(iday int)
BEGIN
	call crontab_report_user_summary(iday);

	if (unix_timestamp(current_date) != unix_timestamp(iday)) then
		call crontab_report_retention(iday);
	end if;
	select 1 count;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_report_user_summary`(iday int)
BEGIN
	declare beg_date int(11) default 0;
	declare end_date int(11) default 0;

    declare itotals int(11) default 0;
    declare iregisters int(11) default 0;
	declare ilogins int(11) default 0;

	set beg_date = UNIX_TIMESTAMP(iday);
	set end_date = beg_date + 86400;

	select count(uid) into itotals from sys_user;
	select count(uid) into iregisters from sys_user where reg_date>=beg_date and reg_date<end_date;
	select count(DISTINCT(uid)) into ilogins from log_user_login where ldate>=beg_date and ldate<end_date;

	replace into report_user_summary(day,totals,registers,logins)
	values(iday,ifnull(itotals, 0),ifnull(iregisters, 0),ifnull(ilogins, 0));

	replace into report_user_retention(day, registers) values(iday,ifnull(iregisters, 0));

END$$
DELIMITER ;

-- 在线时长
CREATE TABLE `report_online_times` (
  `day` int(11) NOT NULL DEFAULT '0' COMMENT '天',
  `type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '类型 0-5/5-10/10-20/20-30/30-40/40-50/50-60/60-120/120-',
  `users` int(11) NOT NULL DEFAULT '0' COMMENT '在线用户数',
  `tusers` int(11) NOT NULL DEFAULT '0' COMMENT '在线总用户数',
  PRIMARY KEY (`day`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='在线时长报表';

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_report_online_times`(iday int)
BEGIN
	declare beg_date int(11) default 0;
	declare end_date int(11) default 0;
    declare itotals int(11) default 0;
	declare iusers int(11) default 0;

	select count(ldate) into itotals from log_user_liushui as a where ldate=iday and not exists(select 1 from yly_motor where uid = a.uid);

	set beg_date = 0; set end_date = 5*60;
	select count(ldate) into iusers from log_user_liushui as a where ldate=iday and game_time>=beg_date and game_time<end_date and not exists(select 1 from yly_motor where uid = a.uid);
	replace into report_online_times(day, type, users, tusers) values(iday, 1, ifnull(iusers, 0), ifnull(itotals, 0));

	set beg_date = end_date; set end_date = 10*60;
	select count(ldate) into iusers from log_user_liushui as a where ldate=iday and game_time>=beg_date and game_time<end_date and not exists(select 1 from yly_motor where uid = a.uid);
	replace into report_online_times(day, type, users, tusers) values(iday, 2, ifnull(iusers, 0), ifnull(itotals, 0));

	set beg_date = end_date; set end_date = 20*60;
	select count(ldate) into iusers from log_user_liushui as a where ldate=iday and game_time>=beg_date and game_time<end_date and not exists(select 1 from yly_motor where uid = a.uid);
	replace into report_online_times(day, type, users, tusers) values(iday, 3, ifnull(iusers, 0), ifnull(itotals, 0));

	set beg_date = end_date; set end_date = 30*60;
	select count(ldate) into iusers from log_user_liushui as a where ldate=iday and game_time>=beg_date and game_time<end_date and not exists(select 1 from yly_motor where uid = a.uid);
	replace into report_online_times(day, type, users, tusers) values(iday, 4, ifnull(iusers, 0), ifnull(itotals, 0));

	set beg_date = end_date; set end_date = 40*60;
	select count(ldate) into iusers from log_user_liushui as a where ldate=iday and game_time>=beg_date and game_time<end_date and not exists(select 1 from yly_motor where uid = a.uid);
	replace into report_online_times(day, type, users, tusers) values(iday, 5, ifnull(iusers, 0), ifnull(itotals, 0));

	set beg_date = end_date; set end_date = 50*60;
	select count(ldate) into iusers from log_user_liushui as a where ldate=iday and game_time>=beg_date and game_time<end_date and not exists(select 1 from yly_motor where uid = a.uid);
	replace into report_online_times(day, type, users, tusers) values(iday, 6, ifnull(iusers, 0), ifnull(itotals, 0));

	set beg_date = end_date; set end_date = 60*60;
	select count(ldate) into iusers from log_user_liushui as a where ldate=iday and game_time>=beg_date and game_time<end_date and not exists(select 1 from yly_motor where uid = a.uid);
	replace into report_online_times(day, type, users, tusers) values(iday, 7, ifnull(iusers, 0), ifnull(itotals, 0));

	set beg_date = end_date; set end_date = 120*60;
	select count(ldate) into iusers from log_user_liushui as a where ldate=iday and game_time>=beg_date and game_time<end_date and not exists(select 1 from yly_motor where uid = a.uid);
	replace into report_online_times(day, type, users, tusers) values(iday, 8, ifnull(iusers, 0), ifnull(itotals, 0));

	set beg_date = end_date;
	select count(ldate) into iusers from log_user_liushui as a where ldate=iday and game_time>=beg_date and not exists(select 1 from yly_motor where uid = a.uid);
	replace into report_online_times(day, type, users, tusers) values(iday, 9, ifnull(iusers, 0), ifnull(itotals, 0));

END$$
DELIMITER ;

-- 新用户
CREATE TABLE `report_newuser_golds_num` (
  `day` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `num1` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户金币0-100',
  `num2` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户金币100-1000',
  `num3` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户金币1000-5000',
  `num4` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户金币5000-10000',
  `num5` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户金币10000-20000',
  `num6` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户金币20000-100000',
  `num7` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户金币大于100000',
  PRIMARY KEY (`day`)
) ENGINE=InnoDB AUTO_INCREMENT=20160924 DEFAULT CHARSET=utf8;
CREATE TABLE `report_newuser_level_num` (
  `day` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `num1` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户等级0',
  `num2` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户等级1-5',
  `num3` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户等级6-10',
  `num4` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户等级11-15',
  `num5` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户等级16-20',
  `num6` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户等级20-30',
  `num7` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户等级大于30',
  `users` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`day`)
) ENGINE=InnoDB AUTO_INCREMENT=20160924 DEFAULT CHARSET=utf8;
CREATE TABLE `report_newuser_rounds_num` (
  `day` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `gameid` int(10) unsigned NOT NULL COMMENT '游戏id',
  `users` int(11) NOT NULL DEFAULT '0',
  `num1` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户局数为0',
  `num2` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户局数1-10',
  `num3` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户局数为11-50',
  `num4` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户局数为51-100',
  `num5` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户局数为101-200',
  `num6` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户局数为201－300',
  `num7` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '新用户局数为大于300',
  PRIMARY KEY (`day`,`gameid`)
) ENGINE=InnoDB AUTO_INCREMENT=20160924 DEFAULT CHARSET=utf8;
DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_report_newuser`(iday int)
BEGIN
	declare beg_time int(11) default 0;
	declare end_time int(11) default 0;
	declare ncount int(11) default 0;
	declare num1 int(11) default 0;
	declare num2 int(11) default 0;
	declare num3 int(11) default 0;
	declare num4 int(11) default 0;
	declare num5 int(11) default 0;
	declare num6 int(11) default 0;
	declare num7 int(11) default 0;
	set beg_time = UNIX_TIMESTAMP(iday);
	set end_time = beg_time + 86400;


	create temporary table if not exists tmp_new_user (uid int(10) not null default 0, golds bigint(20) not null default 0, level int(11) not null default 0);
	truncate table tmp_new_user;

	insert into tmp_new_user(uid, golds,level)
    select a.uid, (cast(golds as signed) + bonus_golds + cast(bank as signed)) as all_golds, level
    from yly_member as a inner join game_userfield as b on a.uid=b.uid and reg_date >= beg_time and reg_date < end_time;

	select count(uid) into num1 from tmp_new_user where golds >= 0 and golds < 100;
	select count(uid) into num2 from tmp_new_user where golds >= 100 and golds < 1000;
	select count(uid) into num3 from tmp_new_user where golds >= 1000 and golds < 5000;
	select count(uid) into num4 from tmp_new_user where golds >= 5000 and golds < 10000;
	select count(uid) into num5 from tmp_new_user where golds > 10000 and golds < 20000;
	select count(uid) into num6 from tmp_new_user where golds >= 20000 and golds < 100000;
	select count(uid) into num7 from tmp_new_user where golds >= 100000;

    delete from report_newuser_golds_num where day = iday;
	insert into report_newuser_golds_num(`day`,num1,num2,num3,num4,num5,num6,num7)
    value(iday,num1,num2,num3,num4,num5,num6,num7);

    delete from report_newuser_rounds_num where day = iday;

	select count(a.uid) into num1 from log_user_liushui as a inner join tmp_new_user as b on a.uid=b.uid and ldate=iday and rounds = 0;
    select count(a.uid) into num2 from log_user_liushui as a inner join tmp_new_user as b on a.uid=b.uid and ldate=iday and rounds between 1 and 10;
    select count(a.uid) into num3 from log_user_liushui as a inner join tmp_new_user as b on a.uid=b.uid and ldate=iday and rounds between 11 and 50;
    select count(a.uid) into num4 from log_user_liushui as a inner join tmp_new_user as b on a.uid=b.uid and ldate=iday and rounds between 51 and 100;
    select count(a.uid) into num5 from log_user_liushui as a inner join tmp_new_user as b on a.uid=b.uid and ldate=iday and rounds between 101 and 200;
    select count(a.uid) into num6 from log_user_liushui as a inner join tmp_new_user as b on a.uid=b.uid and ldate=iday and rounds between 201 and 300;
    select count(a.uid) into num7 from log_user_liushui as a inner join tmp_new_user as b on a.uid=b.uid and ldate=iday and rounds > 300;
    select count(a.uid) into ncount from log_user_liushui as a inner join tmp_new_user as b on a.uid=b.uid and ldate=iday;

    insert into report_newuser_rounds_num(`day`,gameid,num1,num2,num3,num4,num5,num6,num7,users)
    value(iday,0,num1,num2,num3,num4,num5,num6,num7,ncount);

    select count(uid) into num1 from tmp_new_user where level = 0;
	select count(uid) into num2 from tmp_new_user where level between 1 and 5;
	select count(uid) into num3 from tmp_new_user where level between 6 and 10;
	select count(uid) into num4 from tmp_new_user where level between 11 and 15;
	select count(uid) into num5 from tmp_new_user where level between 16 and 20;
	select count(uid) into num6 from tmp_new_user where level between 21 and 30;
	select count(uid) into num7 from tmp_new_user where level > 30;
	select count(uid) into ncount from tmp_new_user;

    delete from report_newuser_level_num where day = iday;
	insert into report_newuser_level_num(`day`,num1,num2,num3,num4,num5,num6,num7,users)
    value(iday,num1,num2,num3,num4,num5,num6,num7,ncount);

END$$
DELIMITER ;

