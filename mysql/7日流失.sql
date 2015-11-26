CREATE TABLE `report_churn` (
  `day1` int(11) NOT NULL DEFAULT '0',
  `day2` int(11) NOT NULL DEFAULT '0',
  `registers` int(11) NOT NULL DEFAULT '0' COMMENT '注册总人数',
  `churns` int(11) NOT NULL DEFAULT '0' COMMENT '当日流失总人数',
  `round0` int(11) NOT NULL DEFAULT '0' COMMENT '局数为0人数',
  `golds0` int(11) NOT NULL DEFAULT '0' COMMENT '没钱的玩家',
  `round10` int(11) NOT NULL DEFAULT '0' COMMENT '有钱但是局数<10',
  `round5m` int(11) NOT NULL DEFAULT '0' COMMENT '有钱但是局数<30',
  `roundM` int(11) NOT NULL DEFAULT '0' COMMENT '局数<100',
  `roundN` int(11) NOT NULL DEFAULT '0' COMMENT '有钱，局数>100',
  `ground5` int(11) NOT NULL DEFAULT '0' COMMENT '没钱局数<5',
  `ground10` int(11) NOT NULL DEFAULT '0' COMMENT '没钱局数<10',
  `ground30` int(11) NOT NULL DEFAULT '0' COMMENT '没钱局数<30',
  `groundN` int(11) NOT NULL DEFAULT '0' COMMENT '没钱局数>30',
  `pays` int(11) NOT NULL DEFAULT '0' COMMENT '充值用户数',
  `roundNuid` text COMMENT 'uid列表',
  PRIMARY KEY (`day1`,`day2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_report_day`(iday int)
BEGIN
  if (unix_timestamp(current_date) != unix_timestamp(iday)) then
    call crontab_report_churn(iday);
  end if;
  select 1 count;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_report_churn`(inday INT)
BEGIN
  set @array_content = "1 2 3 4 5 6 7";
  set @i = 1;
  set @count = char_length(@array_content)-char_length(replace(@array_content,' ','')) + 1;
  set @end_date = date_format(date_sub(inday, interval -1 day),'%Y%m%d');

  while @i <= @count
  do
    set @day = substring_index(substring_index(@array_content,' ',@i), ' ', -1);
    call crontab_churn(@day, @end_date);
    set @i=@i+1;
  end while;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_churn`(iday int, idate int)
BEGIN
  declare beg_date1 int(11) default 0;
  declare end_date1 int(11) default 0;
  declare beg_date2 int(11) default 0;
  declare end_date2 int(11) default 0;
  declare today int(11) default 0;

  declare regs int(11) default 0;
  declare logins int(11) default 0;
  declare churns int(11) default 0;
  declare users int(11) default 0;
  declare uids text;

  set end_date2 = unix_timestamp(idate);
  set beg_date2 = end_date2 - 86400;
  set end_date1 = unix_timestamp(date_sub(idate,intERVAL iday DAY));
  set beg_date1 = end_date1 - 86400;
  set today = date_format(from_unixtime(beg_date1),'%Y%m%d');
  set idate = date_format(from_unixtime(beg_date2),'%Y%m%d');

  -- register users
  create temporary table if not exists tmp_register_users(uid int(11) primary key, golds bigint(20));
  truncate table tmp_register_users;
  insert into tmp_register_users(uid, golds)
  select a.uid, golds + bonus_golds + bank from yly_member as a inner join game_userfield as b on a.uid=b.uid where reg_date>=beg_date1 and reg_date<end_date1;
  select count(uid) into regs from tmp_register_users;

  -- login users
  create temporary table if not exists tmp_login_users(uid int(11) primary key);
  truncate table tmp_login_users;
  insert into tmp_login_users(uid)
  select a.uid from tmp_register_users as a inner join (select distinct(uid) as uid from log_user_login where ldate>=beg_date2 AND ldate<end_date2) as b on a.uid=b.uid;
  select count(uid) into logins from tmp_login_users;

  -- churn users
  create temporary table if not exists tmp_churn_users(uid int(11) primary key);
  truncate table tmp_churn_users;
  insert into tmp_churn_users(uid)
  select uid from tmp_register_users where uid not in (select uid from tmp_login_users);
  select count(uid) into churns from tmp_churn_users;

  -- user rounds
  create temporary table if not exists tmp_user_rounds(uid int(11) primary key, rounds int(11));
  truncate table tmp_user_rounds;
  insert into tmp_user_rounds(uid,rounds)
  select uid, sum(rounds) from log_user_liushui_17 where ldate>=today and ldate<=idate group by uid;

  insert into report_churn(day1,day2,registers,churns) values(today,idate, ifnull(regs, 0), ifnull(churns,0))
  on duplicate key update registers=ifnull(regs, 0),churns = ifnull(churns,0);

  set users = 0;
  select count(a.uid) into users from tmp_churn_users as a inner join tmp_user_rounds as b on a.uid=b.uid and rounds > 0;
  update report_churn set round0 = ifnull(churns, 0) - ifnull(users, 0) where day1=today and day2=idate;

  set users = 0;
  select count(a.uid) into users from tmp_churn_users as a inner join tmp_register_users b on a.uid=b.uid and golds<3600;
  update report_churn set golds0 = ifnull(users, 0) where day1=today and day2=idate;

  set users = 0;
  select count(a.uid) into users from tmp_churn_users as a inner join tmp_register_users b on a.uid=b.uid and golds<3600
  inner join tmp_user_rounds as c on c.uid=a.uid and rounds < 5;
  update report_churn set ground5 = ifnull(users, 0) where day1=today and day2=idate;

  set users = 0;
  select count(a.uid) into users from tmp_churn_users as a inner join tmp_register_users b on a.uid=b.uid and golds<3600
  inner join tmp_user_rounds as c on c.uid=a.uid and rounds < 10;
  update report_churn set ground10 = ifnull(users, 0) where day1=today and day2=idate;

  set users = 0;
  select count(a.uid) into users from tmp_churn_users as a inner join tmp_register_users b on a.uid=b.uid and golds<3600
  inner join tmp_user_rounds as c on c.uid=a.uid and rounds < 30;
  update report_churn set ground30 = ifnull(users, 0) where day1=today and day2=idate;

  set users = 0;
  select count(a.uid) into users from tmp_churn_users as a inner join tmp_register_users b on a.uid=b.uid and golds<3600
  inner join tmp_user_rounds as c on c.uid=a.uid and rounds >= 30;
  update report_churn set groundN = ifnull(users, 0) where day1=today and day2=idate;

  set users = 0;
  select count(a.uid) into users from tmp_churn_users as a inner join tmp_register_users b on a.uid=b.uid and golds>3600
  inner join tmp_user_rounds as c on c.uid=a.uid and rounds < 10;
  update report_churn set round10 = ifnull(users, 0) where day1=today and day2=idate;

  set users = 0;
  select count(a.uid) into users from tmp_churn_users as a inner join tmp_register_users b on a.uid=b.uid and golds>3600
  inner join tmp_user_rounds as c on c.uid=a.uid and rounds < 30;
  update report_churn set round5m = ifnull(users, 0) where day1=today and day2=idate;

  set users = 0;
  select count(a.uid) into users from tmp_churn_users as a inner join tmp_register_users b on a.uid=b.uid and golds>3600
  inner join tmp_user_rounds as c on c.uid=a.uid and rounds < 100;
  update report_churn set roundM = ifnull(users, 0) where day1=today and day2=idate;

  set users = 0;
  select count(a.uid),group_concat(a.uid separator ',') into users, uids from tmp_churn_users as a inner join tmp_register_users b on a.uid=b.uid and golds>3600
  inner join tmp_user_rounds as c on c.uid=a.uid and rounds > 100;
  update report_churn set roundN = ifnull(users, 0), roundNuid=uids where day1=today and day2=idate;

  -- pay users
  set users = 0;
  select count(a.uid) into users from tmp_register_users as a inner join (select distinct(uid) as uid from yly_member_order where timeline>=beg_date2 and timeline<end_date2 and state>0) as b on a.uid=b.uid;
  update report_churn set pays = ifnull(users, 0) where day1=today and day2=idate;

END$$
DELIMITER ;

