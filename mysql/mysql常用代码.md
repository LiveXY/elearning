mysql常用代码
==========

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
```
* 
* 
* 
* 
* 
* 

mysql命令
=========

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
SELECT COLUMN_NAME, DATA_TYPE, COLUMN_DEFAULT, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH, COLUMN_TYPE, COLUMN_KEY, EXTRA, COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'activity'
AND table_schema = 'qcloud'
describe activity
show columns from activity
desc activity
show create table activity
show create procedure crontab_report_day
show create function func_split
```
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 
* 