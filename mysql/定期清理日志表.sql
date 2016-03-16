CREATE TABLE `report_log_backup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(45) DEFAULT NULL COMMENT '备份的表',
  `backup_count` int(11) NOT NULL DEFAULT '0' COMMENT '备份记录数',
  `delete_count` int(11) NOT NULL DEFAULT '0' COMMENT '删除记录数',
  `last_where` varchar(500) DEFAULT NULL COMMENT '条件',
  `time` int(11) NOT NULL COMMENT '时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_exec`(ssql text)
BEGIN
	set @ssql := ssql;
	prepare ssql from @ssql;
	execute ssql;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_backup_log`(sdb varchar(50), stable varchar(50), swhere varchar(100))
BEGIN
	set @imonth := DATE_FORMAT(CURRENT_DATE,'%Y%m');
	set @newTable := concat(sdb, 'log.', stable, @imonth);
	set @oldTable := concat(sdb, '.', stable);

	call crontab_exec(concat('create table if not exists ', @newTable, ' like ', @oldTable, ';'));
	-- call crontab_exec(concat('alter table ', @newTable, ' engine=MyISAM;'));
	call crontab_exec(concat('insert into ', @newTable, ' select * from ', @oldTable, ' where ', swhere, ';'));
	set @backup_count := row_count();

	set @delete_count := 0;

	if (@backup_count > 0) then
		call crontab_exec(concat('delete from ', @oldTable, ' where ', swhere));
		set @delete_count := row_count();
	end if;

	set @ssql = concat('insert into ', sdb, '.report_log_backup(time, table_name, backup_count, delete_count, last_where) values(unix_timestamp(now()), ''', stable, ''', ', @backup_count, ', ', @delete_count, ', ''', swhere, ''');');
	call crontab_exec(@ssql);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`%` PROCEDURE `crontab_clear_logs`()
BEGIN
	set @db := 'dbname';
	set @timeD := date_sub(now(),interval 2 month);
	set @timeI := unix_timestamp(@timeD);
	set @id := 0;

	call crontab_exec(concat('create schema if not exists `', @db, 'log` default character set utf8;'));

	call crontab_exec(concat('select max(pid) into @id from ', @db, '.', 'yly_post_hs where deletetime<', @timeI, ';'));
	if (ifnull(@id, 0) > 0) then call crontab_backup_log(@db, 'yly_post_hs', concat('pid<=', @id)); end if;

	call crontab_exec(concat('select max(lid) into @id from ', @db, '.', 'log_user_golds where ltime<''', @timeD, ''';'));
	if (ifnull(@id, 0) > 0) then call crontab_backup_log(@db, 'log_user_golds', concat('lid<=', @id)); end if;

END$$
DELIMITER ;
