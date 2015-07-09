mysql常用代码
==========

* `select @@datadir` 数据存放目录
* `update mysql.proc set definer="root@%" where db='dbname';` 修改存贮过程权限
* `check table tablename;`检查，`repair table tablename;`修复表
* `alter table db.tablename engine='InnoDB';` 修改表引擎
* `optimize table tablename;` 优化表
* `create index indexname on tablename (field1, field2);` 或 `alter table tablename add index indexname(field1, field2);` 创建(添加)索引
* `alter table tablename drop index indexname;` 删除索引
* `show create table tablename\G;` 显示建表完整表结构
* `desc tablename;`,`show columns from tablename;` 显示表结构
* `show table status like tablename\G;` 查看数据表类型
* `show master status\G;` 查看master状态
* `show slave status\G;` 查看slave状态
* `show global variables like 'slow%';`, `show variables like 'long%';`, `show global status like 'table_locks%'`, `show status like 'innodb_row_lock%';` 查看变量，状态值
* `create schema databasename default character set utf8;` 或 `create database databasename default charset utf8;` 新建数据库
* `insert into report_churn(day,value) values(today, 0) on duplicate key update value=0;` #不存在添加，存在修改
* `insert into table select * from oldtable;` #复制数据 ignore
* `create table newtable like oldtable;`, `create table if not exists newtable like oldtable;` 只复制结构、索引、约束、主键
* `show create table tablename;` 复制代码 `copycode as (select * from tablename);` 只复制结构和数据、索引、约束、主键
* `create table tb2 select * from book;`,`create table if not exists tb2 select * from book;` 复制表结构和数据、不复制索引、约束、主键
* `create temporary table if not exists users(uid int(11) primary key, golds bigint(20));` 建临时表
* `create table tb3 (id int(10) primary key,name varchar(20));` 建表
* `create table tb3 (id int(10) not null auto_increment, name varchar(20) not null default '' comment '', primary key (id), name2 varchar(20) default null comment '', primary key (id)) engine=InnoDB auto_increment=1 default charset=utf8 comment='';` 建表
* `set sql_safe_updates=0;` 安全更新
* `update game as a inner join server as b on a.gid=b.gid set a.gname=b.sname;` 更新
* `delete b from tablename1 as b inner join tablename1 as a on b.uid=a.uid;` 删除
* `drop table if exists tablename;` 或 `drop temporary table tablename;` 删除表
* `truncate db.tablename;` 清空表数据
* `alert table tablename add column columnname int not null default 0 comment '' (after columnname);` 增加字段
* `alter table tablename change column oldcolumnname newcolumnname int not null default 0 comment '';` 修改字段类型
* `alter table tablename drop columnname;` 删除字段
* `alter table tablename drip partition partitionname` 删除分拆表
* `alter table tablename alter columnname drop default;` 删除默认值
* `alter table tablename alter columnname set default value;` 修改默认值
* `alter table oldname rename to newname;` 或 `rename table oldname to newname` 或 `rename table db1.oldname to db2.newname` 表重命名
* `drop database dbname;` 删除数据库
* `alter table tablename auto_increment=1;` 修改自增编号
* `slave stop;`, `reset slave;`, `slave start;` 从机停止，重置，启动
* `change master to master_host='ip', master_user='user', master_password='pass', master_port=3306, master_log_file='mariadb-bin.000002', master_log_pos=1179, master_connect_retry=30;` 修改主从复制
* `set xxxx=value;`, `set global xxxx=value;` 修改配置
* `set global server_id=2;` 修改主从复制的server_id
* `grant replication slave on *.* to username identified by 'password' with grant option;flush privileges;` 新建主从复制用户，如果支持监控增加super
* `flush tables with read lock;` 锁所有表, `lock tables tablename read, tablename2 write;`, `unlock tables;` #锁定数据库表只读，解锁
* `show processlist;`, `show full processlist;` 当前的连接
* `kill id` 关闭连接
* `pager grep "lock(s)"` 和 `show engine innodb status;` 查看当前锁行数
* `select @@global.tx_isolation,@@session.tx_isolation,@@tx_isolation;` 查看事务隔离级别
* `set tx_isolation='repeatable-read';` 或 `set session transaction isolation level repeatable read` 修改事务隔离级别(http://www.cnblogs.com/zemliu/archive/2012/06/17/2552301.html) read-uncommitted读取未提交内容/read-committed读取提交内容/repeatable-read可重读(mysql默认)/serializable可串行化
* innodb 对 update ... where pk=value 加行共享锁，`select .... for update;` 加排它锁
* `select @@global.binlog_format, @@binlog_format;` 查看binlog format
* 清理大表数据
```
方法一有锁：
create table log_user_golds2 like log_user_golds;
insert into log_user_golds2 select * from log_user_golds where ltime > "2015-06-15";
rename table log_user_golds to log_user_golds3,log_user_golds2 to log_user_golds;
drop table log_user_golds3;
方法二无锁：
create table log_user_golds2 like log_user_golds;
select * from log_user_golds where ltime > "2015-06-15" into outfile '/tmp/log_user_golds.csv'; -- fields terminated by ',' optionally enclosed by '"' lines terminated by '\n';
load data infile '/tmp/log_user_golds.csv' into table log_user_golds2; -- fields terminated by ',' optionally enclosed by '"' lines terminated by '\n';
rename table log_user_golds to log_user_golds3,log_user_golds2 to log_user_golds;
drop table log_user_golds3;
```
* 大表增加，修改字段
```
alter table tablename drop index indexname;
alert table tablename add column columnname int not null default 0 comment '' (after columnname);
alter table tablename change column oldcolumnname newcolumnname int not null default 0 comment '';
alter table tablename add index indexname(field1, field2);
```
* `start transaction;` 事务开始， `commit;` 提交事务， `rollback;` 回滚事务，`set session autocommit=1;` 设置当前会话自动提交事务，`start transaction with consistent snapshot;` 快速的全局读锁替代`start transaction;`
* `analyze table tablename;` 分析表
* `checksum table tablename, tablename2;` 校验表
* `show tables like 'log%'` 查看批配表名
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

mysql命令
=========

* `mysqlcheck -uroot -p123456 db -c;` 检查整个库那些表损坏
* `mysqlcheck -uroot -p123456 db -r;` 修复整个数据库表损坏
* `mysqlcheck -uroot -p123456 db table -r;` 修复数据表
* `myisamchk -e table.MYI;` 检查表
* `myisamchk -r table.MYI;` 修复表
* `mysqldump -uuser -ppass -R --databases dbname > dbname.sql` 导出数据库
  * `--extended-insert=false` 默认生成insert时多条合并成一条，如果主健重复错误后就不执行后续的对应表的插入语句了，需要加上此参数
  * `-d` 只导结构不导数据
  * `-t` 只导数据不到结构
  * `--single-transaction` 不锁表
* `mysql -uuser -ppass -e "create schema dbname default character set utf8;"` 和 `mysql -uuser -ppass dbname < dbname.sql` 导入数据
* `mysql -uuser -ppass -e "sql code"` 执行SQL代码
* 重新修改密码：
  * service mysqld stop
  * mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
  * mysql -u root mysql
    * update user set Password=PASSWORD('123456') where User='root';
    * flush privileges;
    * quit
  * mysql -uroot -p
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
* 
* 
* 
* 
* 