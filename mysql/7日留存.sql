CREATE TABLE `report_user_retention` (
  `day` int(11) NOT NULL DEFAULT '0' COMMENT '天',
  `registers` int(11) NOT NULL DEFAULT '0' COMMENT '注册用户数',
  `retention1` int(11) NOT NULL DEFAULT '0' COMMENT '1日留存人数',
  `retention2` int(11) NOT NULL DEFAULT '0' COMMENT '2日留存人数',
  `retention3` int(11) NOT NULL DEFAULT '0' COMMENT '3日留存人数',
  `retention4` int(11) NOT NULL DEFAULT '0' COMMENT '4日留存人数',
  `retention5` int(11) NOT NULL DEFAULT '0' COMMENT '5日留存人数',
  `retention6` int(11) NOT NULL DEFAULT '0' COMMENT '6日留存人数',
  `retention7` int(11) NOT NULL DEFAULT '0' COMMENT '7日留存人数',
  `retention14` int(11) NOT NULL DEFAULT '0' COMMENT '14日留存人数',
  `retention30` int(11) NOT NULL DEFAULT '0' COMMENT '30日留存人数',
  PRIMARY KEY (`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='留存报表';

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_report_retention`(inday INT)
BEGIN
  set @array_content = "1 2 3 4 5 6 7 14 30";
  set @i = 1;
  set @count = char_length(@array_content)-char_length(replace(@array_content,' ','')) + 1;
  set @end_date = date_format(date_sub(inday, interval -1 day),'%Y%m%d');

  while @i <= @count
  do
    set @day = substring_index(substring_index(@array_content,' ',@i), ' ', -1);
    call crontab_report_user_retention(@day, @end_date);
    set @i=@i+1;
  end while;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_report_user_retention`(IN iday int, idate int)
BEGIN
  declare beg_date1 int(11) default 0;
  declare end_date1 int(11) default 0;
  declare beg_date2 int(11) default 0;
  declare end_date2 int(11) default 0;
  declare iretention int(11) default 0;
  declare retention_field char(50) default '';
  declare today int(11) default 0;

  set end_date2 = unix_timestamp(idate);
  set beg_date2 = end_date2 - 86400;
  set end_date1 = unix_timestamp(date_sub(idate,intERVAL iday DAY));
  set beg_date1 = end_date1 - 86400;
  set retention_field = concat('retention',iday);
  set today = date_format(from_unixtime(beg_date1),'%Y%m%d');

  create temporary table if not exists tmp_userid (
    user_id int(11) primary key
  );

  truncate table tmp_userid;

  insert into tmp_userid(user_id) select uid from sys_user where reg_date>=beg_date1 and reg_date<end_date1;

  select COUNT(a.user_id) into iretention from tmp_userid AS a inner join (
    select distinct(uid) as uid from log_user_login where ldate>=beg_date2 and ldate<end_date2
  ) as b on a.user_id=b.uid;

  set @stmt := concat("update report_user_retention set ",retention_field,"=",iretention," where day = ",today) ;
  prepare stmt from @stmt;
  execute stmt;
END$$
DELIMITER ;
