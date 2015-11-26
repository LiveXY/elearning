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
