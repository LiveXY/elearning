mysql常用代码
==========

* `rename database olddbname to newdbname`
* `show engine innodb status /G;` 当 MySQL 出现问题通常我们需要执行的第一个命令
* `select @@datadir` 数据存放目录
* `select db, name, type, definer from mysql.proc where db='db';` 查看存贮过程权限
* `update mysql.proc set definer="root@%" where db='dbname';` 修改存贮过程权限
* `check table tablename;` 检查会加只读锁，`repair table tablename;`修复表 参数quick只修复索引树|extended逐行重建索引|use_frm MYI文件丢失时
* `optimize table tablename;` 优化表会加只读锁(在做过大量的更新或删除操作后操作，减少了文件碎片，又减少了表损坏的概率)
* `analyze table tablename;` 分析表会加只读锁
* `alter table db.tablename engine='InnoDB';` 修改表引擎
```
#大数据热修改表引擎
create table new_tablename like tablename;
alter table new_tablename engine='InnoDB';
mysqldump --single-transaction -uuser -ppass -t dbname tablename > mb.sql
find -name 'mb.sql' | xargs perl -pi -e 's|tablename|new_tablename|g'
mysql -uuser -ppass dbname < mb.sql
#找到最大的主键记录，将新数据导入到new_tablename
replace into new_tablename select * from tablename where ...;
lock tables tablename write;
rename table tablename to temp_tablename, new_tablename to tablename;
unlock tables;
```
* `select ... lock in share mode;` 添加读锁
* `select ... for update；` 添加写锁
* `create index indexname on tablename (field1, field2);` 或 `alter table tablename add index indexname(field1, field2);` 创建(添加)索引
* `alter table tablename drop index indexname;` 删除索引
* `show create table tablename\G;` 显示建表完整表结构
* `desc tablename;`,`show columns from tablename;` 显示表结构
* `show table status like 'tablename'\G;` 查看数据表类型
* `show master status\G;` 查看master状态
* `show slave status\G;` 查看slave状态
* `show global variables like 'slow%';`, `show variables like 'long%';`, `show global status like 'table_locks%'`, `show status like 'innodb_row_lock%';` 查看变量，状态值
* `set xxxx=value;`, `set global xxxx=value;` 修改配置
* `create schema databasename default character set utf8;` 或 `create database databasename default charset utf8;` 新建数据库
* `insert into table set ?`
* `insert into table set ? on duplicate key update ?`
* `replace into yly_online set ?`
* `update table set ? where lid=?`
* `select * from table1 inner join table2 using(uid) where uid=?`
* `insert into report_churn(day,value) values(today, 0) on duplicate key update value=0;` #不存在添加，存在修改
* `insert into table select * from oldtable;` #复制数据(锁select表) ignore
* `create table newtable like oldtable;`, `create table if not exists newtable like oldtable;` 只复制结构、索引、约束、主键
* `show create table tablename;` 复制代码 `copycode as (select * from tablename);` 复制结构和数据、索引、约束、主键
* `create table tb2 select * from book;`,`create table if not exists tb2 select * from book;` 复制表结构和数据、不复制索引、约束、主键 或替换为 `create table if not exists tmp_tamenabe(uid int(11) not null default 0); insert into tmp_tamenabe(uid) select uid from tablename`;
* `create temporary table if not exists users(uid int(11) primary key, golds bigint(20));` 建临时表
* `create table tb3 (id int(10) primary key, name varchar(20));` 建表
* `create table tb3 (id int(10) not null auto_increment, name varchar(20) not null default '' comment '', primary key (id), name2 varchar(20) default null comment '', primary key (id)) engine=InnoDB auto_increment=1 default charset=utf8 comment='';` 建表
* `set sql_safe_updates=0;` 安全更新
* `update game as a inner join server as b on a.gid=b.gid set a.gname=b.sname;` 更新 或 `update game as a inner join server b using(gid) set a.gname=b.sname;`
* `delete b from tablename1 as b inner join tablename1 as a on b.uid=a.uid;` 删除
* `drop table if exists tablename;` 或 `drop temporary table tablename;` 删除表
* `truncate db.tablename;` 清空表数据
* `alert table tablename add column columnname int not null default 0 comment '' (after columnname);` 增加字段
* `alter table tablename change column oldcolumnname newcolumnname int not null default 0 comment '';` 修改字段类型
* `alter table tablename drop columnname;` 删除字段
* `alter table tablename drop partition partitionname` 删除分拆表
* `alter table tablename alter columnname drop default;` 删除默认值
* `alter table tablename alter columnname set default value;` 修改默认值
* `alter table oldname rename to newname;` 或 `rename table oldname to newname` 或 `rename table db1.oldname to db2.newname` 表重命名
* `drop database dbname;` 删除数据库
* `alter table tablename auto_increment=1;` 修改自增编号
* `slave stop;`, `reset slave;`, `slave start;` 从机停止，重置，启动
* `change master to master_host='ip', master_user='user', master_password='pass', master_port=3306, master_log_file='mariadb-bin.000002', master_log_pos=1179, master_connect_retry=30;` 修改主从复制
* `set global server_id=2;` 修改主从复制的server_id
* `grant replication slave on *.* to username identified by 'password' with grant option;flush privileges;` 新建主从复制用户，如果支持监控增加super
* `flush tables with read lock;` 锁所有表, `lock tables tablename read, tablename2 write;`, `unlock tables;` 锁定数据库表只读，解锁
* `show processlist;`, `show full processlist;` 当前的连接
* `kill id` 关闭连接
* `pager grep "lock(s)"` 和 `show engine innodb status;` 查看当前锁行数
* `select @@global.tx_isolation,@@session.tx_isolation,@@tx_isolation;` 查看事务隔离级别
* `set tx_isolation='repeatable-read';` 或 `set session transaction isolation level repeatable read` 修改事务隔离级别(http://www.cnblogs.com/zemliu/archive/2012/06/17/2552301.html) read-uncommitted读取未提交内容/read-committed读取提交内容/repeatable-read可重读(mysql默认)/serializable可串行化
* innodb 对 `update ... where pk=value` 加行共享锁，`select .... for update;` 加排它锁，`select .... lock in share mode;` 加共享锁
* `select @@global.binlog_format, @@binlog_format;` 查看binlog format
* 清理大表数据
```
方法一有锁：
create table log_user_golds2 like log_user_golds;
insert into log_user_golds2 select * from log_user_golds where ltime > "2015-06-15";
lock tables log_user_golds write;
rename table log_user_golds to log_user_golds3,log_user_golds2 to log_user_golds;
unlock tables;
drop table log_user_golds3;
方法二无锁：
create table log_user_golds2 like log_user_golds;
select * from log_user_golds where ltime > "2015-06-15" into outfile '/tmp/log_user_golds.csv'; -- fields terminated by ',' optionally enclosed by '"' lines terminated by '\n';
load data infile '/tmp/log_user_golds.csv' into table log_user_golds2; -- fields terminated by ',' optionally enclosed by '"' lines terminated by '\n';
lock tables log_user_golds write;
rename table log_user_golds to log_user_golds3,log_user_golds2 to log_user_golds;
unlock tables;
drop table log_user_golds3;
```
* 大表增加，修改字段
```
alter table tablename disable keys; -- 禁用索引
lock tables tablename write;
alert table tablename add column columnname int not null default 0 comment '' (after columnname);
alter table tablename change column oldcolumnname newcolumnname int not null default 0 comment '';
unlock tables;
alter table tablename enable keys;
```
* `start transaction;` 事务开始， `commit;` 提交事务， `rollback;` 回滚事务，`set session autocommit=1;` 设置当前会话自动提交事务，`start transaction with consistent snapshot;` 快速的全局读锁替代`start transaction;`
* `checksum table tablename, tablename2;` 校验表
* `show tables like 'log%'` 查看批配表名
* `select sql_no_cache ... from table use index(indexname);` sql_no_cache不缓存sql，use index指定索引，force index强制索引，ignore index忽略索引
* high_priority可以使用在select和insert操作中，这个操作优先进行。low_priority可以使用在insert和update操作中，这个操作滞后。延时插入 insert delayed into。
* `order by rand() limit 2;`， `先count记录数，count>2时 然后limit count-2,2` 随机取2条记录
* 导入数据时提高速度
```
set unique_checks=0; -- 禁用唯一性检查
set foreign_key_checks=0; -- 禁用外键约束
set unique_checks=1;
set foreign_key_checks=1;
```
* date_format(current_date,'%Y%m%d')
* `alter table tablename discard tablespace;` 删除表空间, `alter table tablename import tablespace;` 重新导入表空间
* 查看时区：`show variables like '%time_zone%';`，`select CURTIME();`
* 查询排名：`select *, @rank:=@rank+1 as rank from table, (select @rank:=0) as r`
```
select uid, @rank := if (@prev = score, @rank, @rank + 1) as rank, @prev := score as score
from user_score, (select @prev := -1, @rank := 0) as s
where mid=2 order by score desc
select a.mid,uid, @rank := if (@prev = score, @rank, @rank + 1) as rank, @prev := score as score, if(rounds>=minround, 1, 0) r
from user_match_score as a inner join game_match_config as b on a.mid=b.mid and a.mid=56, (select @prev := -1, @rank := 1) as s
order by r desc, score desc
select a.mid,uid, @rank:=@rank+1 as rank,score, if(rounds>=minround, 1, 0) r
from user_match_score as a inner join game_match_config as b on a.mid=b.mid and a.mid=56, (select @rank:=0) as s
order by r desc, score desc, uid asc
```
* 索引碎片优化
```
查询哪些表需要索引碎片优化
select table_schema, table_name, round((data_length+index_length)/1024/1024) as total_mb, round(data_length/1024/1024) as data_mb, round(index_length/1024/1024) as index_mb, round(data_free/1024/1024) AS data_free_MB, TABLE_ROWS from information_schema.tables WHERE engine LIKE 'InnoDB' AND table_schema='dbname' AND data_free > 100*1024*1024 order by data_free_MB desc;
生成优化SQL脚本
select concat('ALTER TABLE ', table_name, ' ENGINE=InnoDB;') from information_schema.tables WHERE engine LIKE 'InnoDB' AND table_schema='dbname' AND data_free > 100*1024*1024 order by data_free asc;
或
select concat('optimize table ', table_name, ';') from information_schema.tables WHERE engine LIKE 'InnoDB' AND table_schema='dbname' AND data_free > 100*1024*1024 order by data_free asc;
这个优化不能每天执行，最好是1个月执行一次，或更长，如果有碎片空间>100M才清理
```
* 查看所有表记录情况按记录数排序
```
select table_name,`engine`,table_rows,avg_row_length,data_length,index_length,table_collation from information_schema.tables where table_schema = 'dbname' order by table_rows desc;
```
* 修改数据库表编码支持emoji表情
```
alter database xiaohun character set utf8mb4 collate utf8mb4_general_ci;
alter table sys_user convert to character set utf8mb4 collate utf8mb4_general_ci;
```
* 查询更改没有默认值的字段
```
select * from information_schema.columns WHERE table_schema='assess' and column_default is null and (column_key != 'PRI' and data_type != 'text')
select concat('alter table `',table_schema,'`.`',table_name,'` change column `',column_name,'` `',column_name,'` ',column_type,' not null default ',case  when data_type='varchar' then '\'\'' else '0' end ,';') from information_schema.columns WHERE table_schema='assess' and column_default is null and (column_key != 'PRI' and data_type != 'text')
```
* 无锁
```
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;
SELECT * FROM document ;
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ ;

SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ;

SELECT @@global.tx_isolation; (global isolation level)
SELECT @@tx_isolation; (session isolation level)
```
* 更新比之前大的数据
```
INSERT INTO t1 (id,a,b,c,d) VALUES (3,4,5,6,9),(4,5,6,7,11) ON DUPLICATE KEY UPDATE d=if(VALUES(d)>d, VALUES(d), d);
```
*

mysql命令
=========
* `mysqladmin -u root password '123456'` `mysqladmin -h 192.168.1.168 -u root password '123456'` 修改root密码
* `mysqlcheck -c -u root -p --all-databases` 全部数据库 `mysqlcheck -o root -p --all-databases` 优化
* `mysqlcheck -uroot -p123456 db -c;` 检查整个库那些表损坏
* `mysqlcheck -uroot -p123456 db table1 table2 -c;` 检查整个库那些表损坏
* `mysqlcheck -uroot -p123456 db -r;` 修复整个数据库表损坏
* `mysqlcheck -uroot -p123456 db table1 table2 -r;` 修复数据表
* `myisamchk --quick --check-only-changed --sort-index --analyze table.MYI;`
* `myisamchk -e table.MYI;` 检查表
* `myisamchk -r table.MYI;` 修复表
* `myisamchk -r /path/;` 修复表
* `mysqldump --single-transaction -uuser -ppass -R --databases dbname > dbname.sql` 导出数据库
  * `--extended-insert=false` 默认生成insert时多条合并成一条，如果主健重复错误后就不执行后续的对应表的插入语句了，需要加上此参数
  * `-d` 只导结构不导数据
  * `-t` 只导数据不到结构
  * `--single-transaction` 不锁表
* `mysqldump -h ip -uroot -p123456 --skip-add-drop-table --single-transaction db table --where=" pid<19703535" > temp.sql` 带where导出数据,不删除表
* `mysql -uuser -ppass -e "create schema dbname default character set utf8;"` 和 `mysql -uuser -ppass dbname < dbname.sql` 导入数据
* `mysql -uuser -ppass -e "sql code"` 执行SQL代码
* `mysql -h 127.0.0.1 -uroot -p123456 -D db -e "select uid,username from member" > /home/member.txt` linux导出部分字段和数据
* 重新修改密码：
  * service mysqld stop
  * mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
  * mysql -u root mysql
	* update user set Password=PASSWORD('123456') where User='root'; 或 update user set Password=PASSWORD('123456') where User='root' and Host='%';
	* flush privileges;
	* quit
  * mysql -uroot -p
或者
  * use mysql;
  * update user set host = '%' where user = 'root'  and host='localhost';
  * select host, user from user;
  * flush privileges;
或者
  * grant all privileges on *.* to 'root'@'10.0.0.10' identified by 'root' with grant option;
* `/innochecksum /var/lib/mysql/ibdata1` 或 `innodb_space -f /var/lib/mysql/ibdata1 space-summary | grep UNDO_LOG | wc -l` 检查什么被存储到了 ibdata1 里
* db备份还原:
```
mysqldump -h 192.168.6.153 -uroot -ppass -R qcloud>qcloud.sql
mysql -h 192.168.6.168 -uroot -ppass -e "create schema qcloud default character set utf8;"
`mysql -h 192.168.6.168 -uroot -ppass qcloud<qcloud.sql` 或 `mysql -h 192.168.6.153 -uroot -p123456 -e "use qcloud;source /root/qcloud.sql;"`
```
* db备份还原2:
```
#1，只导出表结构和存储过程
mysqldump -h 192.168.6.168 -uroot -ppass --skip-add-drop-table --single-transaction -R -d qcloud>qcloud_nodata.sql
#2，只导出表数据
mysqldump -h 192.168.6.168 -uroot -ppass --extended-insert=false --skip-add-drop-table --single-transaction -t --skip-add-locks qcloud activity_config game_activity_pool game_audit game_channel game_config game_lang game_mobilepay game_pay_currency game_props game_room_stat game_rooms game_tables game_type game_vip_level gm_question_type report_currency sys_app sys_app_function sys_role sys_role_function yly_area yly_city yly_province yly_gift_sort yly_gift yly_post_template > qcloud_data.sql
mysqldump -h 192.168.6.168 -uroot -ppass --extended-insert=false --skip-add-drop-table --single-transaction -t --skip-add-locks qcloud yly_member --where=" uid in (0,10000012) " >> qcloud_data.sql
mysqldump -h 192.168.6.168 -uroot -ppass --extended-insert=false --skip-add-drop-table --single-transaction -t --skip-add-locks qcloud game_userfield --where=" uid in (0,10000012) " >> qcloud_data.sql
mysqldump -h 192.168.6.168 -uroot -ppass --extended-insert=false --skip-add-drop-table --single-transaction -t --skip-add-locks qcloud user_achievement --where=" uid in (0,10000012) " >> qcloud_data.sql
mysqldump -h 192.168.6.168 -uroot -ppass --extended-insert=false --skip-add-drop-table --single-transaction -t --skip-add-locks qcloud sys_admin_user --where=" user_id in (0,10000012) " >> qcloud_data.sql
mysqldump -h 192.168.6.168 -uroot -ppass --extended-insert=false --skip-add-drop-table --single-transaction -t --skip-add-locks qcloud sys_admin_user_game --where=" user_id in (0,10000012) " >> qcloud_data.sql
#过滤
sed -ie 's/ROW_FORMAT=FIXED//g' qcloud_nodata.sql
sed -ie 's/CHECKSUM=1//g' qcloud_nodata.sql
#3，导入表结构和数据
mysql -h 192.168.6.168 -uroot -ppass qcloud<qcloud_nodata.sql
mysql -h 192.168.6.168 -uroot -ppass qcloud<qcloud_data.sql
```
* 转移mysql数据目录
```
#关闭服务
service nginx stop
service php-fpm stop
service mysqld stop
service mariadb stop
#转移数据
mv /var/lib/mysql /home/ 或者 cp -a /var/lib/mysql /home/mysql
#创建软连接:
ln -s /home/mysql /var/lib/mysql
#完成
#修改/etc/my.cnf配置
cat /etc/my.cnf | grep '/var/lib/'
vi /etc/my.cnf
datadir=/home/mysql
socket=/home/mysql/mysql.sock
其它：
[mysqld_safe]
socket=/home/mysql/mysql.sock
[client]
socket=/home/mysql/mysql.sock
[mysql.server]
socket=/home/mysql/mysql.sock
#启动服务
service nginx start
service php-fpm start
service mysqld start
service mariadb start
```
* 对比2数据库差异
```
mysqldump -h 10.66.187.161 -uroot -ppass -d qcloud>qcloud1.sql
mysqldump -h 10.66.187.161 -uroot -ppass -d qcloud2>qcloud2.sql
sed -i 's/AUTO_INCREMENT=.* //' qcloud1.sql
sed -i 's/AUTO_INCREMENT=.* //' qcloud2.sql
sed -i '/^\/\*!/d' qcloud1.sql
sed -i '/^\/\*!/d' qcloud2.sql
sed -i '/^--/d' qcloud1.sql
sed -i '/^--/d' qcloud2.sql
sed -i "s/COMMENT '.*'//" qcloud1.sql
sed -i "s/COMMENT '.*'//" qcloud2.sql
sed -i "s/COMMENT='.*'//" qcloud1.sql
sed -i "s/COMMENT='.*'//" qcloud2.sql
sed -i "s/ ,$/,/" qcloud1.sql
sed -i "s/ ,$/,/" qcloud2.sql
sed -i "s/ CHECKSUM=1//" qcloud1.sql
sed -i "s/ CHECKSUM=1//" qcloud2.sql
sed -i "s/ DELAY_KEY_WRITE=1//" qcloud1.sql
sed -i "s/ DELAY_KEY_WRITE=1//" qcloud2.sql
sed -i "s/ ROW_FORMAT=DYNAMIC//" qcloud1.sql
sed -i "s/ ROW_FORMAT=DYNAMIC//" qcloud2.sql
sed -i "s/ DEFAULT//" qcloud1.sql
sed -i "s/ DEFAULT//" qcloud2.sql
sed -i "s/ ;$/;/" qcloud1.sql
sed -i "s/ ;$/;/" qcloud2.sql
tr "\n" " " < qcloud1.sql > qcloud3.sql
tr ";" "\n" < qcloud3.sql > qcloud1.sql
tr "\n" " " < qcloud2.sql > qcloud4.sql
tr ";" "\n" < qcloud4.sql > qcloud2.sql
sed -i "s/^   DROP/DROP/" qcloud1.sql
sed -i "s/^   DROP/DROP/" qcloud2.sql
sed -i "s/^ CREATE/CREATE/" qcloud1.sql
sed -i "s/^ CREATE/CREATE/" qcloud2.sql
sed -i "s/(   /(/g" qcloud1.sql
sed -i "s/(   /(/g" qcloud2.sql
sed -i "s/,   /, /g" qcloud1.sql
sed -i "s/,   /, /g" qcloud2.sql
diff qcloud1.sql qcloud2.sql
或
yum install mysql-utilities.noarch
mysqldiff --server1=root:pass@192.168.6.168 --server2=root:pass@192.168.6.168 --difftype=differ qcloud:qfortune
mysqldiff --server1=root:pass@192.168.6.168 --server2=root:pass@192.168.6.168 --difftype=sql qcloud:qfortune
```
* 表结构
```
select table_name tabName from information_schema.tables where table_schema='qcloud'
select distinct specific_name proName from information_schema.parameters where specific_schema='qcloud'
select COLUMN_NAME, DATA_TYPE, COLUMN_DEFAULT, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH, COLUMN_TYPE, COLUMN_KEY, EXTRA, COLUMN_COMMENT
from INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'activity'
AND table_schema = 'qcloud'
describe activity
show columns from activity
desc activity
show create table activity
show create procedure crontab_report_day
show create function func_split
```
* MYSQL增加账号与权限分配
```
增加dba管理员方法1:
CREATE USER 'wound'@'%' IDENTIFIED BY '123456';
GRANT select, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, EXECUTE, CREATE VIEW, SHOW VIEW, TRIGGER,ALTER ROUTINE,CREATE ROUTINE,CREATE TEMPORARY TABLES ON `wound`.* TO 'wound'@'%';
GRANT select, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, EXECUTE, CREATE VIEW, SHOW VIEW, TRIGGER,ALTER ROUTINE,CREATE ROUTINE,CREATE TEMPORARY TABLES ON `research`.* TO 'wound'@'%';
FLUSH PRIVILEGES;

drop user wound
增加dba管理员方法2:
insert into mysql.user(Host,User,Password) VALUES('%','wound',PASSWORD('123456'));
select * from mysql.user where User='wound';

GRANT USAGE ON *.* TO 'wound'@'%' IDENTIFIED BY PASSWORD '123456';
FLUSH PRIVILEGES;
GRANT select, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, EXECUTE, CREATE VIEW, SHOW VIEW, TRIGGER,ALTER ROUTINE,CREATE ROUTINE,CREATE TEMPORARY TABLES ON `wound`.* TO 'wound'@'%';
FLUSH PRIVILEGES;

show grants for 'wound'@'%';

普通 DBA 管理某个 MySQL 数据库的权限
grant all privileges on 'wound'.* to 'wound'@'%'
管理所有 MySQL 数据库的权限
grant all on *.* to 'wound'@'%'
撤销权限
revoke all on *.* from 'wound'@'%';
REVOKE select,INSERT,UPDATE,DELETE,CREATE,DROP,INDEX,ALTER,CREATE VIEW,SHOW VIEW,EXECUTE,TRIGGER ON `wound`.* from 'wound'@'%';
```
* 清理部分数据
```
-- 初始化数据
select max(lid) from log_create_rooms where ltime < unix_timestamp(20180320);
select max(lxid) from log_round_212 where lid<1914644;
select count(lxid) from log_round_212 where lxid >= 4264485;
select auto_increment from information_schema.tables where table_schema='dbname' and table_name='log_round_212';
-- 方法一
create table log_round_212_bak like log_round_212;
insert into log_round_212_bak select * from log_round_212 where lxid >= 4264401;
-- 方法二
drop table log_round_212_bak3;
create table log_round_212_bak3 select * from log_round_212 where lxid >= 4264401;
alter table log_round_212_bak3 change column `lxid` `lxid` int(11) unsigned not null auto_increment, add primary key (`lxid`), add index `lid` (`lid` asc);
-- 改名替换源表
-- alter table log_round_212 rename to log_round_212_bak2;
-- alter table log_round_212_bak rename to log_round_212;
```
* 死锁改表名
```
delimiter $$
create definer=`root`@`%` procedure `killrename`(dbname varchar(50), tablename varchar(50))
begin
	declare pid int(11) default 0;
	set @inc = 0;
	select ID into pid from information_schema.processlist
	where DB=dbname and info not like '%information_schema.processlist%' and info like concat('%',tablename,'%') limit 1;

	while (pid > 0) do
		kill pid;

		select ID into pid from information_schema.processlist
		where DB=dbname and info not like '%information_schema.processlist%' and info like concat('%',tablename,'%') limit 1;

		set @inc = @inc + 1;
	end while;

	select @inc count;
	call crontab_exec(concat('alter table `', tablename, '` rename to `', tablename, '_bak`'));
end$$
delimiter ;

call killrename('dbname', table_name')
```
* `select * from mysql.slow_log_view` 查看慢查询
* 问题：Client does not support authentication protocol requested by server; consider upgrading MySQL client
```
alter user 'root'@'%' identified with mysql_native_password by '123456';
FLUSH PRIVILEGES;
```
* mysql 读取文件
```
CREATE TABLE `test` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `fields` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
load data local infile '/etc/passwd' into table test fields terminated by '\n';
load data local infile '/etc/shadow' into table test fields terminated by '\n';
```

* GRANT ALL PRIVILEGES ON gitlab.*TO 'gitlab'@'%' IDENTIFIED BY 'gitlab' WITH GRANT OPTION;
mysql8
* create user 'gitlab'@'%' IDENTIFIED BY '123456';
* GRANT ALL PRIVILEGES ON gitlab.* TO 'gitlab'@'%';
* flush privileges;
* 
* 
* 查看锁，杀掉锁进程
```
mysqladmin -h127.0.0.1 -uroot -p processlist | grep -i executing
mysqladmin -h127.0.0.1 -uroot -p processlist | grep -i locked

mysqladmin -h127.0.0.1 -uroot -p processlist | grep -i executing | awk '{print $2}'

mysql -h127.0.0.1 -uroot -p -se "select id from information_schema.processlist where state='executing'" | awk '{print $1}'
mysql -h127.0.0.1 -uroot -p -se "select id from information_schema.processlist where state='locked'" | awk '{print $1}'

for id in `mysqladmin -h127.0.0.1 -uroot -p processlist | grep -i executing | awk '{print $2}'`; do echo ${id}; done

for id in `mysqladmin -h127.0.0.1 -uroot -p processlist | grep -i locked | awk '{print $2}'`; do mysqladmin -h127.0.0.1 -uroot -p kill ${id}; echo ${id}; done
```
* 
* mysql归档工具
```
Red Hat Enterprise Linux
yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm
CentOS 8
/etc/yum.repos.d/下的repos，使用vault.centos.org替换mirror.centos.org
使用相应的包管理器安装Percona Toolkit
For RHEL or CentOS:
sudo yum install percona-toolkit
pt-archiver [OPTIONS] --source DSN --where WHERE
删除id<100000的记录

pt-archiver --source h=xxx.xx.xx.xx,P=3306,u=root,p=123456,D=test,t=user_test \
--purge \
--where "id<200000" \
--primary-key-only  \
--no-check-charset \
--bulk-delete \
--limit=1000 \
--why-quit \
--progress=100000  \
--sentinel=/tmp/pt-test
参数解释：
1：--source ：指定要归档表的信息，兼容DSN选项。
DSN语法是key=value[,key=value...],可选的参数有：
  KEY  COPY  MEANING
  ===  ====  =============================================
  A    yes   Default character set
  D    yes   Database that contains the table
  F    yes   Only read default options from the given file
  L    yes   Explicitly enable LOAD DATA LOCAL INFILE
  P    yes   Port number to use for connection
  S    yes   Socket file to use for connection
  a    no    Database to USE when executing queries
  b    no    If true, disable binlog with SQL_LOG_BIN
  h    yes   Connect to host
  i    yes   Index to use
  m    no    Plugin module name
  p    yes   Password to use when connecting
  t    yes   Table to archive from/to
  u    yes   User for login if not current user
2: --purge：直接清除数据而不是归档; 允许省略--file和--dest。如果只想清除数据，可以考虑使用--primary-key-only指定仅限表的主键列。这样可以防止从服务器获取所有列。
3: --primary-key-only：查询仅限主键列。用于指定具有主键列的--columns的快捷方式，它可以避免获取整行。
4: --[no]check-charset：不检查字符集，禁用此检查可能会导致文本被错误地从一个字符集转换为另一个字符集。进行字符集转换时，禁用此检查可能有用。此例中，我们是直接清除数据，所以可以禁用字符集检查。
5: --bulk-delete：批量删除source上的旧数据。
6: --limit: 每次取n行数据给pt-archive处理。
7: --why-quit：除非行耗尽，否则打印退出原因。
8: --progress: 每处理n行输出一次处理信息。

将历史数据导出到文件
pt-archiver --source h=xxx.xx.xx.xx,P=3306,u=root,p=123456,D=test,t=user_test \
--file=/tmp/%Y-%m-%d-%D.%t \
--where="1=1" \
--no-check-charset  \
--no-delete \
--no-safe-auto-increment \
--progress=1000 \
--statistics 
参数解释：
1: --no-delete：不要删除归档的行(如果需要删除源表数据,--no-delete改为--purge)。
2: --[no]safe-auto-increment: 不以最大AUTO_INCREMENT值归档行。默认值是YES。添加一个额外的where子句，以防止pt-archiver在对单列AUTO_INCERMENT值进行升序时删除最新的行。这可以防止在服务器重启时重用AUTO_INCREMENT值。
3: --statistics：结束的时候给出统计信息：开始的时间点，结束的时间点，查询的行数，归档的行数，删除的行数，以及各个阶段消耗的总的时间和比例，便于以此进行优化。
4: --file:要归档到的文件。
file输出文件的参数。
%d Day of the month, numeric (01..31)
%H Hour (00..23)
%i Minutes, numeric (00..59)
%m Month, numeric (01..12)
%s Seconds (00..59)
%Y Year, numeric, four digits
%D Database name
%t Table name

在不同库表之间同步数据
pt-archiver --source h=xxx.xx.xx.xx,P=3306,u=root,p=123456,D=test,t=user_test \
--where "id<300000" \
--dest t=user_test_his \
--purge \
--charset=utf8mb4 \
--limit=1000 \
--sleep=1 \
--nosafe-auto-increment \
--noversion-check \
--why-quit \
--progress=10000  \
--sentinel=/tmp/pt-test
参数解释：
1: --dest：指定要归档到的表，兼容DSN选项。
它使用与--source相同的参数格式。大多数缺失值默认为与--source相同的值，因此不必重复--source和--dest中相同的选项。
2: --charset：设置默认字符集。
3: --sentinel：优雅地退出操作。指定的文件的存在将导致pt-archiver停止存档并退出。默认值为/tmp/pt-archiver-sentinel。
4: --sleep: 指定SELECT语句之间的休眠时间。
pt-archiver的使用规则
源表必须有主键。
参数至少需要指定--dest,--file,--purge其中的一个。
--ignore和--replace互斥。
--txn-size和--commit-each互斥
--low-priority-insert和--delayed-insert互斥。
--share-lock和--for-update互斥。
--analyze和--optimize互斥。
--no-ascend和--no-delete互斥。
说明：--ignore和--replace参数：归档冲突时是跳过还是覆盖。


```
* 
* 
* 
* 
* 
* 