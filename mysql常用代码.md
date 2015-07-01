mysql常用代码
==========

* `update mysql.proc set definer="root@%" where db='dbname';` 修改存贮过程权限
* `check table tablename;`检查，`repair table tablename;`修复表
* `alter table db.tablename engine='InnoDB';` 修改表引擎
* `optimize table tablename;` 优化表
* `create index indexname on tablename (field1, field2);` 创建索引
* `show create table tablename\G;` 显示建表完整表结构
* `desc tablename;`,`show columns from tablename;` 显示表结构
* `show table status like tablename\G;` 查看数据表类型
* `show master status\G;` 查看master状态
* `show slave status\G;` 查看slave状态
* `show global variables like 'slow%';`, `show variables like 'long%';`, `show global status like 'table_locks%'`, `show status like 'innodb_row_lock%';` 查看变量，状态值
* `alert table tablename add column columnname int not null default 0 comment '' (after columnname);` 增加字段
* `alter table tablename change column oldcolumnname newcolumnname int not null default 0 comment '';` 修改字段类型
* `create schema databasename default character set utf8;` 或 `create database databasename default charset utf8;` 新建数据库
* `insert into report_churn(day,value) values(today, 0) on duplicate key update value=0;` #不存在添加，存在修改
* `insert into table select * from table_old;`
* `create table tb2 like book;`,`create table tb2 select * from book;`,`create table if not exists tb2 select * from book;` 复制表结构和数据
* `create table tb3 (id int(10) primary key,name varchar(20));` 建表
* `create table tb3 (id int(10) not null auto_increment, name varchar(20) not null default '' comment '', primary key (id), name2 varchar(20) default null comment '', primary key (id)) engine=InnoDB auto_increment=1 default charset=utf8 comment='';` 建表
* `SET SQL_SAFE_UPDATES=0;` 安全更新
* `update game as a inner join server as b on a.gid=b.gid set a.gname=b.sname;` 更新
* `delete b from tablename1 as b inner join tablename1 as a on b.uid=a.uid;` 删除
* `create temporary table if not exists users(uid int(11) primary key, golds bigint(20));` 建临时表
* `drop table if exists tablename;` 删除表
* `truncate db.tablename;` 清空表数据
* `alter table tablename drop columnname;` 删除字段
* `alter table tablename alter columnname drop default;` 删除默认值
* `alter table oldname rename to newname;` 表重命名
* `drop database dbname;` 删除数据库
* `alter table tablename auto_increment=1;` 修改自增编号
* `slave stop;`, `reset slave;`, `slave start;` 从机停止，重置，启动
* `change master to master_host='ip', master_user='user', master_password='pass', master_port=3306, master_log_file='mariadb-bin.000002', master_log_pos=1179, master_connect_retry=30;` 修改主从复制
* `set xxxx=value;`, `set global xxxx=value;` 修改配置
* `set global server_id=2;` 修改主从复制的server_id
* `grant replication slave on *.* to username identified by 'password' with grant option;flush privileges;` 新建主从复制用户，如果支持监控增加super
* `flush tables with read lock;`, `unlock tables;` #锁定数据库表只读，解锁
* `show processlist;`, `show full processlist;` 当前的连接
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
* ##一些命令
* `mysqlcheck -uroot -p123456 db -c;` 检查整个库那些表损坏
* `mysqlcheck -uroot -p123456 db -r;` 修复整个数据库表损坏
* `mysqlcheck -uroot -p123456 db table -r;` 修复数据表
* `myisamchk -e table.MYI;` 检查表
* `myisamchk -r table.MYI;` 修复表
* `mysqldump -uuser -ppass -R --databases dbname > dbname.sql` 导出数据库
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