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

CREATE TABLE `report_register_pay` (
  `day` int(11) NOT NULL DEFAULT '0' COMMENT '天',
  `registers` int(11) NOT NULL DEFAULT '0' COMMENT '注册用户数',
  `pay0` int(11) NOT NULL DEFAULT '0' COMMENT '当日付费人数',
  `pay1` int(11) NOT NULL DEFAULT '0' COMMENT '1日付费人数',
  `pay2` int(11) NOT NULL DEFAULT '0' COMMENT '2日付费人数',
  `pay3` int(11) NOT NULL DEFAULT '0' COMMENT '3日付费人数',
  `pay4` int(11) NOT NULL DEFAULT '0' COMMENT '4日付费人数',
  `pay5` int(11) NOT NULL DEFAULT '0' COMMENT '5日付费人数',
  `pay6` int(11) NOT NULL DEFAULT '0' COMMENT '6日付费人数',
  `pay7` int(11) NOT NULL DEFAULT '0' COMMENT '7日付费人数',
  `pay14` int(11) NOT NULL DEFAULT '0' COMMENT '14日付费人数',
  `pay30` int(11) NOT NULL DEFAULT '0' COMMENT '30日付费人数',
  PRIMARY KEY (`day`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='新用户付费';

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
    call crontab_report_register_pay(@day, @end_date);
    set @i=@i+1;
  end while;
  call crontab_pay(0, @end_date);
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

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_report_register_pay`(IN iday INT, idate INT)
BEGIN
  DECLARE beg_date1 INT(11) DEFAULT 0;
  DECLARE end_date1 INT(11) DEFAULT 0;
  DECLARE beg_date2 INT(11) DEFAULT 0;
  DECLARE end_date2 INT(11) DEFAULT 0;
  DECLARE iretention INT(11) DEFAULT 0;
  DECLARE retention_field CHAR(50) DEFAULT '';
  DECLARE today INT(11) DEFAULT 0;

  SET end_date2 = UNIX_TIMESTAMP(idate);
  SET beg_date2 = end_date2 - 86400;
  SET end_date1 = UNIX_TIMESTAMP(DATE_SUB(idate,INTERVAL iday DAY));
  SET beg_date1 = end_date1 - 86400;
  SET retention_field = CONCAT('pay',iday);
  SET today = DATE_FORMAT(FROM_UNIXTIME(beg_date1),'%Y%m%d');

  CREATE TEMPORARY TABLE IF NOT EXISTS tmp_userid (
    user_id INT(11) PRIMARY KEY
  );
  TRUNCATE TABLE tmp_userid;
  INSERT INTO tmp_userid(user_id) SELECT uid FROM yly_member WHERE reg_date>=beg_date1 AND reg_date<end_date1;
  SELECT COUNT(distinct a.user_id) INTO iretention FROM tmp_userid AS a INNER JOIN (
    SELECT uid FROM yly_member_order WHERE timeline>=beg_date2 AND timeline<end_date2 and state=1
  ) AS b ON a.user_id=b.uid;
  SET @STMT := CONCAT("UPDATE report_register_pay SET ",retention_field,"=",iretention," WHERE DAY = ",today) ;
  PREPARE STMT FROM @STMT;
  EXECUTE STMT;
END$$
DELIMITER ;

