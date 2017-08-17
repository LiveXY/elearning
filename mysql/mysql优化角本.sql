http://www.cnblogs.com/zhoujinyi/p/3491059.html
pt-online-schema-change 修改大表结构
安装：https://www.percona.com/downloads/percona-toolkit/LATEST/
wget percona.com/get/percona-toolkit.tar.gz
tar -zxvf percona-toolkit-2.2.6.tar.gz
perl Makefile.PL
make
make test
make install
实例：
首先，我们用--dry-run验证是否可以执行修改：
pt-online-schema-change --alter "modify treatment_afterday INT(4) NULL" D=portal,t=comment_expert -uroot -p*** --dry-run
确认无误之后，再用--execute真正执行：
pt-online-schema-change --alter "modify treatment_afterday INT(4) NULL" D=portal,t=comment_expert -uroot -p*** --execute

pt-online-schema-change h=127.0.0.1,P=3306,t=db1.tablename --alter "add key pid(pid), add flag  tinyint" --sleep 0.1 --bin-log
pt-online-schema-change h=127.0.0.1,P=3306,t=db1.tablename --alter "add key pid(pid), add flag  tinyint default null" --bin-log
--sleep的单位是秒，在每插入--chunk-size行后，sleep --sleep指定的秒，可以用小数。
--chunk-size单位是行，每次insert select的行数，缺省是1000
--bin-log参数，以保证master和slave的数据一致性。不使用--bin-log时，有部分数据更改的操作不写入binlog
当修改过程中出现死锁导致的异常退出时，把--chunk-size改小再试。重试之前先清理一下pt-online-schema-change产生的临时表和trigger。

1，增加字段：
pt-online-schema-change --user=root --password=123456 --host=192.168.200.25  --alter "ADD COLUMN content text" D=aaa,t=tmp_test --no-check-replication-filters --alter-foreign-keys-method=auto --recursion-method=none --print --execute
2，删除字段：
pt-online-schema-change --user=root --password=123456 --host=192.168.200.25  --alter "DROP COLUMN content " D=aaa,t=tmp_test --no-check-replication-filters --alter-foreign-keys-method=auto --recursion-method=none --quiet --execute
3，修改字段：
pt-online-schema-change --user=root --password=123456 --host=192.168.200.25  --alter "MODIFY COLUMN age TINYINT NOT NULL DEFAULT 0" D=aaa,t=tmp_test --no-check-replication-filters --alter-foreign-keys-method=auto --recursion-method=none --quiet --execute
4，字段改名：
pt-online-schema-change --user=root --password=123456 --host=192.168.200.25  --alter "CHANGE COLUMN age address varchar(30)" D=aaa,t=tmp_test --no-check-alter --no-check-replication-filters --alter-foreign-keys-method=auto --recursion-method=none --quiet --execut
5，增加索引：
pt-online-schema-change --user=root --password=123456 --host=192.168.200.25  --alter "ADD INDEX idx_address(address)" D=aaa,t=tmp_test --no-check-alter --no-check-replication-filters --alter-foreign-keys-method=auto --recursion-method=none --print --execute
6，删除索引：
pt-online-schema-change --user=root --password=123456 --host=192.168.200.25  --alter "DROP INDEX idx_address" D=aaa,t=tmp_test --no-check-alter --no-check-replication-filters --alter-foreign-keys-method=auto --recursion-method=none --print --execute
原理：
use `db1`;
alter table tablename using temporary table __tmp_tablename;
show triggers from `db1` LIKE 'tablename';
create table `db1`.`__tmp_tablename` like `db1`.`tablename`;
alter table `db1`.`__tmp_tablename` add key pid(pid), add flag tinyint default null;
create trigger mk_osc_del after delete on `db1`.`tablename` for each row delete ignore from `db1`.`__tmp_tablename` where `db1`.`__tmp_tablename`.id = OLD.id;
create trigger mk_osc_upd after update on `db1`.`tablename` for each row replace into `db1`.`__tmp_tablename` (id, pid, sid, create_on) values(NEW.id, NEW.pid, NEW.sid, NEW.create_on);
create trigger mk_osc_ins after insert on `db1`.`tablename` for each row replace into `db1`.`__tmp_tablename` (id, pid, sid, create_on) values(NEW.id, NEW.pid, NEW.sid, NEW.create_on);
复制数据
insert low_priority ignore into `db1`.`__tmp_tablename`(id, pid, sid, create_on) select * from `db1`.`tablename` lock in share mode;
rename table `db1`.`tablename` TO `db1`.`__old_tablename`, `db1`.`__tmp_tablename` to `db1`.`tablename`;
drop trigger if exists `db1`.`mk_osc_del`;
drop trigger if exists `db1`.`mk_osc_upd`;
drop trigger if exists `db1`.`mk_osc_ins`;

============================================
索引分为聚簇索引和非聚簇索引两种，聚簇索引是按照数据存放的物理位置为顺序的，而非聚簇索引就不一样了；聚簇索引能提高多行检索的速度，而非聚簇索引对于单行的检索很快。
索引分：普通索引／唯一索引／主键索引／组合索引（最左前缀）／全文索引／短索引
1，多表关联查询，关联字段加索引。
2，添加字段时，设置字段不能为空，设置个默认值。null是不走索引的。
3，尽可能少使用字符串类型，不常用字符串类型可以单独放个表，尽量避免使用字符串作为主键。
4，多个字段为主键时，常用的字段放前面
5，组合索引，列的顺序非常重要
6，字符串like查询时，后%是走索引的
7，HASH索引只支持等值比较
8，InnoDB对自增主键建立聚簇索引
9，MySQL查询只使用一个索引
10，不要在列上进行运算
11，建议不要建太多索引，索引影响增删该操作
12，纯日志表不建议加索引
==========================================
explain/explain extended -- 查询分析
-- 实例：
explain extended select * from aaa;
-- 字符串匹配
explain select count(uid) from yly_member where email like "%@hotmail.com"; -- 12.3/2.38 158688
explain select count(uid) from yly_member where email REGEXP "@hotmail.com$"; -- 2.64/2.53 158689
explain select count(uid) from yly_member where locate('@hotmail.com',email)>0; -- 2.23/2.01 161579
Extra 列的结果:
Using temporary，表示需要创建临时表以满足需求，通常是因为GROUP BY的列没有索引，或者GROUP BY和ORDER BY的列不一样，也需要创建临时表，建议添加适当的索引。
Using filesort，表示无法利用索引完成排序，也有可能是因为多表连接时，排序字段不是驱动表中的字段，因此也没办法利用索引完成排序，建议添加适当的索引。
Using where，通常是因为全表扫描或全索引扫描时（type 列显示为 ALL 或 index），又加上了WHERE条件，建议添加适当的索引。
Using index、Using index condition、Using index for group-by 则都还好
system > const > eq_ref > ref > fulltext > ref_or_null > index_merge > unique_subquery > index_subquery > range > index > ALL
==========================================
profiling -- 分析查询
select @@profiling; -- 查看是否开启profiling
set profiling=1; -- 开启profiling 0关1开
show profiles\G; -- 可以得到被执行的SQL语句的时间和ID
show profile for query 1; -- 得到对应SQL语句执行的详细信息
-- 实例：
set profiling=1;
select * from aaa;
show profiles\G;
show profile for query 1;
set profiling=0;
==========================================
show status -- 显示状态信息（扩展show status like ‘XXX’）
show variables -- 显示系统变量
show innodb status -- 显示InnoDB存储引擎的状态
==========================================
-- 慢查询和没有使用索引
vi /etc/my.ini
[mysqld]
log-slow-queries=/data/mysqldata/slow-query.log
long_query_time=2
log-slow-queries=/data/mysqldata/slow-query.log
long_query_time=10
log-queries-not-using-indexes

show global variables like 'slow%'; -- 查看慢查询
show global variables like '%not_using%';
set global slow_query_log = ON
set global slow_query_log_file = '/var/log/mysql/mysql-slow.log';
set global log_queries_not_using_indexes = ON;
show variables like 'long%'; -- 慢查询时间
set long_query_time=5
show variables like 'log_output'
show global variables like 'general%';
mysql 慢查询日志分析工具:
-- 查看访问次数最多的 20 个 sql 语句
mysqldumpslow -s c -t 20 /var/lib/mysql/sg3-slow.log
-- 查看返回记录集最多的 20 个 sql
mysqldumpslow -s r -t 20 /var/lib/mysql/sg3-slow.log
-- 按照时间返回前 10 条里面含有左连接的 sql 语句
mysqldumpslow -t 10 -s t -g "LEFT JOIN" /var/lib/mysql/sg3-slow.log
IO大的SQL(Rows exammine项)/未命中索引的SQL(Rows	examine和Rows Send的对比):
--分析本地的慢查询文件
pt-query-digest --user=root --password=test@123 /data/dbdata/localhost-slow.log
==========================================
show global status like 'table_locks%' -- Table_locks_immediate 表示立即释放MySQL表锁数，Table_locks_waited 表示需要等待的MySQL表锁数如果Table_locks_waited的值比较高，则说明存在着较严重的表级锁争用情况。这时，需要我们对应用做进一步的检查，来确定问题所在。
show status like 'innodb_row_lock%'; -- 分析系统上的行锁的争夺情况
==========================================
show global status like 'threads_connected'; -- 当前的连接数
show processlist; show full processlist; -- 当前的连接
show global status like 'connections'; -- 试图连接到(不管是否成功)MySQL服务器的连接数。
show variables like 'max_connections'; -- 查看最大连接数
show variables like 'max_connect_errors'; -- 查看最大连接错误数
show variables like 'back_log'; -- MySQL暂时停止回答新请求之前的短时间内有多少个请求可以被存在堆栈中。只有如果期望在一个短时间内有很多连接，你需要增加它，换句话说，这值对到来的TCP/IP连接的侦听队列的大小。
show global status like 'max_used_connections'; -- 服务器启动后已经同时使用的连接的最大数量
max_used_connections / max_connections * 100% ≈ 85% -- 最大连接数占上限连接数的85%左右，如果发现比例在10%以下，MySQL服务器连接上线就设置得过高了。
set global max_connections = 2000; -- 修改最大连接数 一般来说 500 到 800 左右是一个比较合适的参考值
set global max_connect_errors = 100000
==========================================
show variables like 'interactive_timeout'; -- 一个交互连接在被服务器在关闭前等待行动的秒数默认数值是28800，可调优为7200。

show variables like 'key_buffer_size'; -- 只对myISAM生效指定索引缓冲区的大小，它决定索引处理的速度，尤其是索引读的速度。默认配置数值是8388600(8M)，主机有4GB内存，可以调优值为268435456(256MB)
/*
show global status like 'key_read%';
key_reads / key_read_requests = 1:100，1:1000更好
key_cache_miss_rate ＝Key_reads / Key_read_requests * 100%，设置在1/1000左右较好
*/
show global status like 'created_tmp%' -- 临时表信息
/*
Created_tmp_disk_tables / Created_tmp_tables * 100% <= 25%比如上面的服务器
Created_tmp_disk_tables / Created_tmp_tables * 100% ＝1.20%，应该相当好了
默认为16M，可调到64-256最佳，线程独占，太大可能内存不够I/O堵塞
*/

show global status like "%aborted%"; -- 用户联接使用完后没有自己释放而被MYSQL强行关闭的连接数。未成功的试图的连接次数。

show global status like 'open%tables%'; -- 打开表的数量和打开过的表数量，如果Opened_tables数量过大，说明配置中table_cache(5.1.3之后这个值叫做table_open_cache)值可能太小
show variables like 'table_open_cache';
/*
Open_tables / Opened_tables  * 100% >= 85%
Open_tables / table_cache * 100% <= 95%
1G内存机器，推荐值是128－256。内存在4GB左右的服务器该参数可设置为256M或384M。
*/

show variables like 'query_cache%'; -- query_cache_size使用查询缓冲，MySQL将查询结果存放在缓冲区中，今后对于同样的SELECT语句（区分大小写），将直接从缓冲区中读取结果。
show global status like 'qcache%'; -- 如果Qcache_lowmem_prunes的值非常大，则表明经常出现缓冲不够的情况，如果Qcache_hits的值也非常大，则表明查询缓冲使用非常频繁，此时需要增加缓冲大小；如果Qcache_hits的值不大，则表明你的查询重复率很低，这种情况下使用查询缓冲反而会影响效率，那么可以考虑不用查询缓冲。此外，在SELECT语句中加入SQL_NO_CACHE可以明确表示不使用查询缓冲。
/*
查询缓存碎片率= Qcache_free_blocks / Qcache_total_blocks * 100%
如果查询缓存碎片率超过20%，可以用FLUSH QUERY CACHE整理缓存碎片，或者试试减小query_cache_min_res_unit，如果你的查询都是小数据量的话。
查询缓存利用率= (query_cache_size – Qcache_free_memory) / query_cache_size * 100%
查询缓存利用率在25%以下的话说明query_cache_size设置的过大，可适当减小；查询缓存利用率在80％以上而且Qcache_lowmem_prunes > 50的话说明query_cache_size可能有点小，要不就是碎片太多。
查询缓存命中率= (Qcache_hits – Qcache_inserts) / Qcache_hits * 100%
示例服务器查询缓存碎片率＝20.46％，查询缓存利用率＝62.26％，查询缓存命中率＝1.94％，命中率很差，可能写操作比较频繁吧，而且可能有些碎片。
*/

show global variables like '%buffer_size';
show variables like 'record_buffer_size'; -- 每个进行一个顺序扫描的线程为其扫描的每张表分配这个大小的一个缓冲区。如果你做很多顺序扫描，你可能想要增加该值。默认数值是131072(128K)，可改为16773120 (16M)

show global status like 'Thread%'
show global status like 'handler_read%'

show variables like 'innodb_buffer_pool_size'; -- 对于InnoDB表来说，innodb_buffer_pool_size的作用就相当于key_buffer_size对于MyISAM表的作用一样。InnoDB使用该参数指定大小的内存来缓冲数据和索引。对于单独的MySQL数据库服务器，最大可以把该值设置成物理内存的80%。根据MySQL手册，对于2G内存的机器，推荐值是1G（60%-70%）。
-- 分配足够 innodb_buffer_pool_size ，来将整个InnoDB 文件加载到内存 — 减少从磁盘上读。

show variables like 'innodb_log_file_size';
set global innodb_log_file_size=256M;
set global innodb_log_files_in_group=2;
-- 不要让 innodb_log_file_size 太大，这样能够更快，也有更多的磁盘空间 — 经常刷新有利降低发生故障时的恢复时间。设置100M左右
-- show engine innodb status\G;
-- (innodb_log_file_size*innodb_log_files_in_group(default 2))*0.75=Log sequence number-Last checkpoint at,可以算出合理的innodb_log_file_size为100MB左右
-- 修改此参数要停止mysql 备份原有的logfile 修改/etc/my.cnf后重启

show variables like 'tmp_table_size'; -- 默认33M
show variables like 'max_heap_table_size'; -- 默认16M
set global tmp_table_size=64*1024*1024;
set global max_heap_table_size=64*1024*1024;
-- 配置临时表容量和内存表最大容量 每 GB 内存给 64M

show variables like 'sort_buffer_size';
-- 不要将 sort_buffer_size 的值设置的太高 — 可能导致连接很快耗尽所有内存。

==========================================
优化Limit分页
select film_id,actor,description from film where actor='WaterBin' order by title limit 100000,5
优化 延迟关联
select film.film_id,film.actor,film.description from film inner join (
	select film_id from film where f.actor='WaterBin' order by title limit 100000,5
) as f using(film_id);
==========================================
innodb_data_file_path = ibdata1:1G:autoextend --千万不要用默认的10M，否则在有高并发事务时，会受到不小的影响；
尽可能不使用TEXT/BLOB类型，确实需要的话，建议拆分到子表中，不要和主表放在一起，避免SELECT * 的时候读性能太差。

/*
insert …select …带来的问题
当使用insert...select...进行记录的插入时，如果select的表是innodb类型的，不论insert的表是什么类型的表，都会对select的表的纪录进行锁定。
我们推荐使用select...into outfile和load data infile的组合来实现，这样是不会对纪录进行锁定的。
select uid,username,utype from yly_member into outfile '/tmp/yly_member.txt'
load data local infile '/tmp/yly_member_fb.txt' into table test.yly_member(uid, username, utype);
导入：
mysqlimport -u root -p --local database_name /tmp/yly_member_fb.txt
mysqlimport -u root -p --local --fields-terminated-by=":" --lines-terminated-by="\r\n"  database_name /tmp/yly_member_fb.txt
mysqlimport -u root -p --local --columns=uid, username, utype database_name /tmp/yly_member_fb.txt

SELECT * FROM ip_country
INTO OUTFILE '/Users/hcxiong/xiong/ip-to-country1.csv'
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'

LOAD DATA INFILE '/Users/hcxiong/xiong/country.csv'
INTO TABLE country
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
*/

show global status like 'open_files';

show global status like 'Questions';
show global status like 'Uptime';
QPS = Questions / Uptime

==========================================
net.ipv4.tcp_fin_timeout = 30
-- TIME_WAIT超时时间，默认是60s
net.ipv4.tcp_tw_reuse = 1
-- 1表示开启复用，允许TIME_WAIT socket重新用于新的TCP连接，0表示关闭
net.ipv4.tcp_tw_recycle = 1
-- 1表示开启TIME_WAIT socket快速回收，0表示关闭
net.ipv4.tcp_max_tw_buckets = 4096
-- 系统保持TIME_WAIT socket最大数量，如果超出这个数，系统将随机清除一些TIME_WAIT并打印警告信息
net.ipv4.tcp_max_syn_backlog = 4096
-- 进入SYN队列最大长度，加大队列长度可容纳更多的等待连接
==========================================

将 MySQL 数据库数据存储到独立分区上,此设置只在 MySQL 上有效, 在 MariaDB 上无效。
fdisk /dev/sdb -- NP1
mkfs.ext4 /dev/sdb1
mkdir /ssd/
mount /dev/sdb1  /ssd/
vi /etc/fstab
/dev/sdb1 /ssd ext3 defaults 0 0
MySQL 移动到新磁盘中
service mysqld stop
service httpd stop
service nginx stop
cp /var/lib/mysql /ssd/ -Rp
mv /var/lib/mysql /var/lib/mysql-backup
ln -s /ssd/mysql /var/lib/mysql
service mysqld start
service httpd start
service nginx start

==========================================
MySQL高可用性之Keepalived+Mysql（双主热备）http://lizhenliang.blog.51cto.com/7876557/1362313
Mysql主从复制http://lizhenliang.blog.51cto.com/7876557/1290431
MySQL-Proxy实现MySQL读写分离提高并发负载http://lizhenliang.blog.51cto.com/7876557/1305083
MySQL高可用集群之MySQL-MMMhttp://lizhenliang.blog.51cto.com/7876557/1354576
Percona Xtrabackup快速备份MySQLhttp://lizhenliang.blog.51cto.com/7876557/1612800

======================================================================
vi /etc/my.cnf -- 配置
[mysqld]
binlog_format=row
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
innodb_locks_unsafe_for_binlog=1
query_cache_size=0
query_cache_type=0
#关闭query cache
bind-address=0.0.0.0

datadir=/var/lib/mysql
innodb_log_file_size=100M
innodb_file_per_table=1
#独立表空间,每张表一个数据文件设置
innodb_flush_log_at_trx_commit=2
#如果要求数据不能丢失，那么两个都设为1。如果允许丢失一点数据，则可分别设为2和10。而如果完全不用care数据是否丢失的话（例如在slave上，反正大不了重做一次），则可都设为0。

wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_address="gcomm://172.16.180.136,172.16.180.138,172.16.180.137"
wsrep_cluster_name='galera_cluster'
wsrep_node_address='172.16.180.136'
wsrep_node_name='db1'
wsrep_sst_method=rsync
wsrep_sst_auth=sst_user:pass

innodb_buffer_pool_size=2G
#InnoDB 的缓冲池配置内存的60-70％
skip-name-resolve
#禁用 MySQL 的 DNS 反向查询
tmp_table_size= 64M
max_heap_table_size= 64M
#配置临时表容量和内存表最大容量 每 GB 内存给 64M
innodb_data_file_path = ibdata1:1G:autoextend
#千万不要用默认的10M，否则在有高并发事务时，会受到不小的影响；
==========================================

#避免使用 Swappiness
sysctl vm.swappiness
sysctl -w vm.swappiness=1 #在Centos7之前,这个值建议设置为0，但是在新版本的内核里面,这样设置可能导致OOM(内存溢出),然后kernel会杀掉使用内存最多的mysqld进程。所以现在这个值推荐设置为1
sysctl -w vm.dirty_background_ratio=5 #设置5-10 确保能持续将脏数据刷新到磁盘，避免瞬间I/O写，产生严重等待
sysctl -w vm.dirty_ratio=10 #设置dirty_background_ratio*2
sysctl -p
==========================================
-- 最大连接数
set global max_connections = 300;

-- 线程缓存数量
show status like 'Threads_created';
show status like 'Connections';
100 - ((Threads_created / Connections) * 100)
set global thread_cache_size = 16; -- 100 - 13/15*100

-- 配置 MySQL 的查询缓存容量
set global query_cache_type = 1
set global query_cache_limit = 256K
set global query_cache_min_res_unit = 2k
set global query_cache_size = 80M -- 通常设置为 200-300 MB应该足够了。如果你的网站比较小的，你可以尝试给 64M 并在以后及时去增加。

-- 启用 MySQL 慢查询日志
set global slow-query-log = 1
set global slow-query-log-file = /var/lib/mysql/mysql-slow.log
set global long_query_time = 2

-- 检查 MySQL 的空闲连接
mysqladmin processlist -uroot -ppass | grep "Sleep"
PHP 调用 mysql_pconnect 可以打开这个连接修改 wait_timeout=60;
==========================================
-- 为 MySQL 选择正确的文件系统
按照 MariaDB 的建议，最好的文件系统是XFS、ext4 和 Btrfs
文件系统	XFS	Ext4	Btrfs
文件系统最大容量	8EB	1EB	16EB
最大文件大小	8EB	16TB	16EB
==========================================
-- 设置 MySQL 允许的最大数据包
set global max_allowed_packet=最大包大小，此值设置得过低可能会导致查询速度变得非常慢

-- 测试 MySQL 的性能优化
wget https://github.com/major/MySQLTuner-perl/tarball/master
tar xf master && cd major-MySQLTuner-perl-993bc18/
./mysqltuner.pl

-- 优化和修复 MySQL 数据库
mysqlcheck -u root -p --auto-repair --check --optimize --all-databases
mysqlcheck -u root -p --auto-repair --check --optimize databasename

===================================================================
当只要一行数据时使用 LIMIT 1
为搜索字段建索引
千万不要 ORDER BY RAND()
避免 SELECT *
永远为每张表设置一个主键
尽可能的使用 NOT NULL
越小的列会越快，字符串比较慢
选择正确的存储引擎
不要使用“永久链接”
select/where时不要对列做函数运算
排序／where字段要有索引
尽量用 join 代替子查询
避免类型转换
优先优化高并发的SQL
insert多数据时不要单条insert应使用,()多条合并成一条insert
查找重复及冗余索引
SELECT a.TABLE_SCHEMA AS '数据库名',a.table_name as '表名',a.index_name AS '索引1',b.INDEX_NAME AS '索引2',a.COLUMN_NAME AS '重复列名' FROM STATISTICS a JOIN STATISTICS b ON a.TABLE_SCHEMA=b.TABLE_SCHEMA AND a.TABLE_NAME=b.TABLE_NAME AND a.SEQ_IN_INDEX=b.SEQ_IN_INDEX AND a.COLUMN_NAME=b.COLUMN_NAME WHERE a.SEQ_IN_INDEX = 1 AND a.INDEX_NAME <> b.INDEX_NAME;
工具：使用pt-duplicate-key-checker工具
删除不用的索引，目前mysql中只能使用慢查询日志配合pt-index-usage工具来进行索引使用情况的分析。
尽量少用text类型，非用不可是最好考虑分表
表的垂直拆分：
a)把不常用的字段单独存放到一个表中。
b)把大字段独立存放到一个表中。
c)把经常一起使用的字段放到一起。
表的水平拆分：按纬度拆分（时间／区域）
分表分库
定期使用pt-duplicate-key-checker检查并删除重复的索引。定期使用pt-index-usage工具检查并删除使用频率很低的索引；
定期采集slow query log，用pt-query-digest工具进行分析，可结合Anemometer系统进行slow query管理以便分析slow query并进行后续优化工作；
可使用pt-kill杀掉超长时间的SQL请求，Percona版本中有个选项 innodb_kill_idle_transaction 也可实现该功能；
使用pt-online-schema-change来完成大表的ONLINE DDL需求；
定期使用pt-table-checksum、pt-table-sync来检查并修复mysql主从复制的数据差异；
===============================================================

3、自动修复mysql 表脚本
#!/bin/bash
#This script edit by badboy connect leezhenhua17@163.com
#This script used by repair tables
mysql_host=localhost
mysql_user=root
mysql_pass=123456   #密码如果带特殊字符如分号可以这么写  root\;2010就可以了
database=test
tables=$(mysql -h$mysql_host -u$mysql_user -p$mysql_pass $database -A -Bse “show tables”)
for arg in $tables
do
check_status=$(mysql -h$mysql_host -u$mysql_user -p$mysql_pass $database -A -Bse “check table $arg” | awk ‘{ print $4 }’)
if [ "$check_status" = "OK" ]
then
echo “$arg is ok”
else
echo $(mysql -h$mysql_host -u$mysql_user -p$mysql_pass $database -A -Bse “repair table $arg”)
fi
echo $(mysql -h$mysql_host -u$mysql_user -p$mysql_pass $database -A -Bse “optimize table $arg”)
done
vim mysql_optimize.sh
#!/bin/sh
echo -n "MySQL username: " ; read username
echo -n "MySQL password: " ; stty -echo ; read password ; stty echo ; echo
mysql -u $username -p"$password" -NBe "SHOW DATABASES;" | grep -v 'lost+found' | while read database ; do
mysql -u $username -p"$password" -NBe "SHOW TABLE STATUS;" $database | while read name engine version rowformat rows avgrowlength datalength maxdatalength indexlength datafree autoincrement createtime updatetime checktime collation checksum createoptions comment ; do
if [ "$datafree" -gt 0 ] ; then
fragmentation=$(($datafree * 100 / $datalength))
echo "$database.$name is $fragmentation% fragmented."
mysql -u "$username" -p"$password" -NBe "OPTIMIZE TABLE $name;" "$database"
fi
done
done
chmod +x ./mysql_optimize.sh
=============================================================================
vi /etc/my.cnf
#
# This group is read both both by the client and the server
# use it for options that affect everything
#
[client-server]

#
# include all files from the config directory
#
!includedir /etc/my.cnf.d
vi /etc/my.cnf.d/server.cnf
#
# These groups are read by MariaDB server.
# Use it for options that only the server (but not clients) should see
#
# See the examples of server my.cnf files in /usr/share/mysql/
#

# this is read by the standalone daemon and embedded servers
[server]

# this is only for the mysqld standalone daemon
[mysqld]
#basedir=/var/lib/mysql
datadir=/var/lib/mysql
log-error=/var/log/mysqld.log
#slave_skip_errors=ALL
#同步的时候忽略错误
innodb_fast_shutdown=0
long_query_time = 2
slow_query_log=1
log_bin_trust_function_creators=1
log_queries_not_using_indexes=0
slow_query_log_file =slow.log

#log_long_format


open_files_limit=10240
back_log = 600
#在MYSQL暂时停止响应新请求之前，短时间内的多少个请求可以被存在堆栈中。如果系统在短时间内有很多连接，则需要增大该参数的值，该参数值指定到来的TCP/IP连接的监听队列的大小。默认值50。

max_connections = 40000
#MySQL允许最大的进程连接数，如果经常出现Too Many Connections的错误提示，则需要增大此值。

max_connect_errors = 6000
#设置每个主机的连接请求异常中断的最大次数，当超过该次数，MYSQL服务器将禁止host的连接请求，直到mysql服务器重启或通过flush hosts命令清空此host的相关信息。

table_cache = 614
#指示表调整缓冲区大小。# table_cache 参数设置表高速缓存的数目。每个连接进来，都会至少打开一个表缓存。#因此， table_cache 的大小应与 max_connections 的设置有关。例如，对于 200 个#并行运行的连接，应该让表的缓存至少有 200 × N ，这里 N 是应用可以执行的查询#的一个联接中表的最大数量。此外，还需要为临时表和文件保留一些额外的文件描述符。
# 当 Mysql 访问一个表时，如果该表在缓存中已经被打开，则可以直接访问缓存；如果#还没有被缓存，但是在 Mysql 表缓冲区中还有空间，那么这个表就被打开并放入表缓#冲区；如果表缓存满了，则会按照一定的规则将当前未用的表释放，或者临时扩大表缓存来存放，使用表缓存的好处是可以更快速地访问表中的内容。执行 flush tables 会#清空缓存的内容。一般来说，可以通过查看数据库运行峰值时间的状态值 Open_tables #和 Opened_tables ，判断是否需要增加 table_cache 的值（其中 open_tables 是当#前打开的表的数量， Opened_tables 则是已经打开的表的数量）。即如果open_tables接近table_cache的时候，并且Opened_tables这个值在逐步增加，那就要考虑增加这个#值的大小了。还有就是Table_locks_waited比较高的时候，也需要增加table_cache。


external-locking = FALSE
skip-external-locking
#使用–skip-external-locking MySQL选项以避免外部锁定。该选项默认开启

max_allowed_packet = 32M
#设置在网络传输中一次消息传输量的最大值。系统默认值 为1MB，最大值是1GB，必须设置1024的倍数。

sort_buffer_size = 8M
# Sort_Buffer_Size 是一个connection级参数，在每个connection（session）第一次需要使用这个buffer的时候，一次性分配设置的内存。
#Sort_Buffer_Size 并不是越大越好，由于是connection级的参数，过大的设置+高并发可能会耗尽系统内存资源。例如：500个连接将会消耗 500*sort_buffer_size(8M)=4G内存
#Sort_Buffer_Size 超过2KB的时候，就会使用mmap() 而不是 malloc() 来进行内存分配，导致效率降低。
#技术导读 http://blog.webshuo.com/2011/02/16/mysql-sort_buffer_size/
#dev-doc: http://dev.mysql.com/doc/refman/5.5/en/server-parameters.html
#explain select*from table where order limit；出现filesort
#属重点优化参数

join_buffer_size = 16M
#用于表间关联缓存的大小，和sort_buffer_size一样，该参数对应的分配内存也是每个连接独享。

thread_cache_size = 320
# 服务器线程缓存这个值表示可以重新利用保存在缓存中线程的数量,当断开连接时如果缓存中还有空间,那么客户端的线程将被放到缓存中,如果线程重新被请求，那么请求将从缓存中读取,如果缓存中是空的或者是新的请求，那么这个线程将被重新创建,如果有很多新的线程，增加这个值可以改善系统性能.通过比较 Connections 和 Threads_created 状态的变量，可以看到这个变量的作用。设置规则如下：1GB 内存配置为8，2GB配置为16，3GB配置为32，4GB或更高内存，可配置更大。

thread_concurrency = 24
# 设置thread_concurrency的值的正确与否, 对mysql的性能影响很大, 在多个cpu(或多核)的情况下，错误设置了thread_concurrency的值, 会导致mysql不能充分利用多cpu(或多核), 出现同一时刻只能一个cpu(或核)在工作的情况。thread_concurrency应设为CPU核数的2倍. 比如有一个双核的CPU, 那么thread_concurrency的应该为4; 2个双核的cpu, thread_concurrency的值应为8
#属重点优化参数

query_cache_size = 64M
## 对于使用MySQL的用户，对于这个变量大家一定不会陌生。前几年的MyISAM引擎优化中，这个参数也是一个重要的优化参数。但随着发展，这个参数也爆露出来一些问题。机器的内存越来越大，人们也都习惯性的把以前有用的参数分配的值越来越大。这个参数加大后也引发了一系列问题。我们首先分析一下 query_cache_size的工作原理：一个SELECT查询在DB中工作后，DB会把该语句缓存下来，当同样的一个SQL再次来到DB里调用时，DB在该表没发生变化的情况下把结果从缓存中返回给Client。这里有一个关建点，就是DB在利用Query_cache工作时，要求该语句涉及的表在这段时间内没有发生变更。那如果该表在发生变更时，Query_cache里的数据又怎么处理呢？首先要把Query_cache和该表相关的语句全部置为失效，然后在写入更新。那么如果Query_cache非常大，该表的查询结构又比较多，查询语句失效也慢，一个更新或是Insert就会很慢，这样看到的就是Update或是Insert怎么这么慢了。所以在数据库写入量或是更新量也比较大的系统，该参数不适合分配过大。而且在高并发，写入量大的系统，建议把该功能禁掉。
#重点优化参数（主库 增删改-MyISAM）

query_cache_limit = 16M
#指定单个查询能够使用的缓冲区大小，缺省为1M

query_cache_min_res_unit = 2k
#默认是4KB，设置值大对大数据查询有好处，但如果你的查询都是小数据查询，就容易造成内存碎片和浪费
#查询缓存碎片率 = Qcache_free_blocks / Qcache_total_blocks * 100%
#如果查询缓存碎片率超过20%，可以用FLUSH QUERY CACHE整理缓存碎片，或者试试减小query_cache_min_res_unit，如果你的查询都是小数据量的话。
#查询缓存利用率 = (query_cache_size – Qcache_free_memory) / query_cache_size * 100%
#查询缓存利用率在25%以下的话说明query_cache_size设置的过大，可适当减小;查询缓存利用率在80%以上而且Qcache_lowmem_prunes > 50的话说明query_cache_size可能有点小，要不就是碎片太多。
#查询缓存命中率 = (Qcache_hits – Qcache_inserts) / Qcache_hits * 100%

default-storage-engine = InnoDB
#default_table_type = InnoDB

thread_stack = 1M
#设置MYSQL每个线程的堆栈大小，默认值足够大，可满足普通操作。可设置范围为128K至4GB，默认为192KB。

#transaction_isolation = READ-COMMITTED
# 设定默认的事务隔离级别.可用的级别如下:
# READ-UNCOMMITTED, READ-COMMITTED, REPEATABLE-READ, SERIALIZABLE
# 1.READ UNCOMMITTED-读未提交2.READ COMMITTE-读已提交3.REPEATABLE READ -可重复读4.SERIALIZABLE -串行


tmp_table_size = 2048M
# tmp_table_size 的默认大小是 32M。如果一张临时表超出该大小，MySQL产生一个 The table tbl_name is full 形式的错误，如果你做很多高级 GROUP BY 查询，增加 tmp_table_size 值。如果超过该值，则会将临时表写入磁盘。
max_heap_table_size = 1024M

#log-bin = /data/3306/mysql-bin
log_bin=mysql-bin
binlog_cache_size = 4M
#max_binlog_cache_size = 8M
max_binlog_size = 1G
expire_logs_days = 7
key_buffer_size = 16M
#binlog_format=MIXED
#批定用于索引的缓冲区大小，增加它可以得到更好的索引处理性能，对于内存在4GB左右的服务器来说，该参数可设置为256MB或384MB。

read_buffer_size = 1M
# MySql读入缓冲区大小。对表进行顺序扫描的请求将分配一个读入缓冲区，MySql会为它分配一段内存缓冲区。read_buffer_size变量控制这一缓冲区的大小。如果对表的顺序扫描请求非常频繁，并且你认为频繁扫描进行得太慢，可以通过增加该变量值以及内存缓冲区大小提高其性能。和sort_buffer_size一样，该参数对应的分配内存也是每个连接独享。

read_rnd_buffer_size = 16M
# MySql的随机读（查询操作）缓冲区大小。当按任意顺序读取行时(例如，按照排序顺序)，将分配一个随机读缓存区。进行排序查询时，MySql会首先扫描一遍该缓冲，以避免磁盘搜索，提高查询速度，如果需要排序大量数据，可适当调高该值。但MySql会为每个客户连接发放该缓冲空间，所以应尽量适当设置该值，以避免内存开销过大。

bulk_insert_buffer_size = 64M
#批量插入数据缓存大小，可以有效提高插入效率，默认为8M

#myisam_sort_buffer_size = 128M
# MyISAM表发生变化时重新排序所需的缓冲

#myisam_max_sort_file_size = 10G
# MySQL重建索引时所允许的最大临时文件的大小 (当 REPAIR, ALTER TABLE 或者 LOAD DATA INFILE).
# 如果文件大小比此值更大,索引会通过键值缓冲创建(更慢)

#myisam_max_extra_sort_file_size = 10G
myisam_repair_threads = 1
# 如果一个表拥有超过一个索引, MyISAM 可以通过并行排序使用超过一个线程去修复他们.
# 这对于拥有多个CPU以及大量内存情况的用户,是一个很好的选择.

#myisam_recover
#自动检查和修复没有适当关闭的 MyISAM 表
skip-name-resolve
lower_case_table_names = 1


innodb_additional_mem_pool_size = 2048M
#这个参数用来设置 InnoDB 存储的数据目录信息和其它内部数据结构的内存池大小，类似于Oracle的library cache。这不是一个强制参数，可以被突破。

innodb_buffer_pool_size = 24G
# 这对Innodb表来说非常重要。Innodb相比MyISAM表对缓冲更为敏感。MyISAM可以在默认的 key_buffer_size 设置下运行的可以，然而Innodb在默认的 innodb_buffer_pool_size 设置下却跟蜗牛似的。由于Innodb把数据和索引都缓存起来，无需留给操作系统太多的内存，因此如果只需要用Innodb的话则可以设置它高达 70-80% 的可用内存。一些应用于 key_buffer 的规则有 — 如果你的数据量不大，并且不会暴增，那么无需把 innodb_buffer_pool_size 设置的太大了

#innodb_data_file_path = ibdata1:1024M:autoextend
#表空间文件 重要数据

#innodb_file_io_threads = 4
#文件IO的线程数，一般为 4，但是在 Windows 下，可以设置得较大。

innodb_thread_concurrency = 12
#服务器有几个CPU就设置为几，建议用默认设置，一般为8.
innodb_flush_log_at_trx_commit = 2
# 如果将此参数设置为1，将在每次提交事务后将日志写入磁盘。为提供性能，可以设置为0或2，但要承担在发生故障时丢失数据的风险。设置为0表示事务日志写入日志文件，而日志文件每秒刷新到磁盘一次。设置为2表示事务日志将在提交时写入日志，但日志文件每次刷新到磁盘一次。

innodb_log_buffer_size = 64M
#此参数确定些日志文件所用的内存大小，以M为单位。缓冲区更大能提高性能，但意外的故障将会丢失数据.MySQL开发人员建议设置为1－8M之间

innodb_log_file_size = 256M
#此参数确定数据日志文件的大小，以M为单位，更大的设置可以提高性能，但也会增加恢复故障数据库所需的时间

innodb_log_files_in_group = 3
#为提高性能，MySQL可以以循环方式将日志文件写到多个文件。推荐设置为3M

innodb_max_dirty_pages_pct = 75
#推荐阅读 http://www.taobaodba.com/html/221_innodb_max_dirty_pages_pct_checkpoint.html
# Buffer_Pool中Dirty_Page所占的数量，直接影响InnoDB的关闭时间。参数innodb_max_dirty_pages_pct 可以直接控制了Dirty_Page在Buffer_Pool中所占的比率，而且幸运的是innodb_max_dirty_pages_pct是可以动态改变的。所以，在关闭InnoDB之前先将innodb_max_dirty_pages_pct调小，强制数据块Flush一段时间，则能够大大缩短 MySQL关闭的时间。

innodb_lock_wait_timeout = 120
# InnoDB 有其内置的死锁检测机制，能导致未完成的事务回滚。但是，如果结合InnoDB使用MyISAM的lock tables 语句或第三方事务引擎,则InnoDB无法识别死锁。为消除这种可能性，可以将innodb_lock_wait_timeout设置为一个整数值，指示 MySQL在允许其他事务修改那些最终受事务回滚的数据之前要等待多长时间(秒数)

innodb_file_per_table = 1
#独享表空间（关闭）

interactive_timeout=28800
wait_timeout=7200
event_scheduler=ON
table_open_cache=2048
server_id=11
#pid-file =/var/lib/mysql/db.pid

#
# * Galera-related settings
#
[galera]
# Mandatory settings
#wsrep_provider=
#wsrep_cluster_address=
#binlog_format=row
#default_storage_engine=InnoDB
#innodb_autoinc_lock_mode=2
#bind-address=0.0.0.0
#
# Optional setting
#wsrep_slave_threads=1
#innodb_flush_log_at_trx_commit=0

# this is only for embedded server
[embedded]

# This group is only read by MariaDB servers, not by MySQL.
# If you use the same .cnf file for MySQL and MariaDB,
# you can put MariaDB-only options here
[mariadb]

# This group is only read by MariaDB-10.0 servers.
# If you use the same .cnf file for MariaDB of different versions,
# use this group for options that older servers don't understand
[mariadb-10.0]

vi /etc/my.cnf.d/wsrep.cnf
# This file contains wsrep-related mysqld options. It should be included
# in the main MySQL configuration file.
#
# Options that need to be customized:
#  - wsrep_provider
#  - wsrep_cluster_address
#  - wsrep_sst_auth
# The rest of defaults should work out of the box.

##
## mysqld options _MANDATORY_ for correct opration of the cluster
##
[mysqld]

# (This must be substituted by wsrep_format)
binlog_format=ROW

# Currently only InnoDB storage engine is supported
default-storage-engine=innodb

# to avoid issues with 'bulk mode inserts' using autoinc
innodb_autoinc_lock_mode=2
innodb_locks_unsafe_for_binlog=1
# Override bind-address
# In some systems bind-address defaults to 127.0.0.1, and with mysqldump SST
# it will have (most likely) disastrous consequences on donor node
bind-address=0.0.0.0

##
## WSREP options
##

# Full path to wsrep provider library or 'none'
wsrep_provider=/usr/lib64/galera/libgalera_smm.so

# Provider specific configuration options
wsrep_provider_options="gcache.size=5G; gcache.page_size=512M"
wsrep_node_address="10.0.0.9"
wsrep_node_name="db1"

# Logical cluster name. Should be the same for all nodes.
wsrep_cluster_name="sc_cluster"

# Group communication system handle
wsrep_cluster_address="gcomm://"
#db1,db2,db3"

# Human-readable node name (non-unique). Hostname by default.
#wsrep_node_name=

# Base replication <address|hostname>[:port] of the node.
# The values supplied will be used as defaults for state transfer receiving,
# listening ports and so on. Default: address of the first network interface.
#wsrep_node_address=

# Address for incoming client connections. Autodetect by default.
#wsrep_node_incoming_address=

# How many threads will process writesets from other nodes
wsrep_slave_threads=12

# DBUG options for wsrep provider
#wsrep_dbug_option

# Generate fake primary keys for non-PK tables (required for multi-master
# and parallel applying operation)
wsrep_certify_nonPK=1

# Maximum number of rows in write set
wsrep_max_ws_rows=131072

# Maximum size of write set
wsrep_max_ws_size=1073741824

# to enable debug level logging, set this to 1
wsrep_debug=0

# convert locking sessions into transactions
wsrep_convert_LOCK_to_trx=0

# how many times to retry deadlocked autocommits
wsrep_retry_autocommit=1

# change auto_increment_increment and auto_increment_offset automatically
wsrep_auto_increment_control=1

# retry autoinc insert, which failed for duplicate key error
wsrep_drupal_282555_workaround=0

# enable "strictly synchronous" semantics for read operations
wsrep_causal_reads=0

# Command to call when node status or cluster membership changes.
# Will be passed all or some of the following options:
# --status  - new status of this node
# --uuid    - UUID of the cluster
# --primary - whether the component is primary or not ("yes"/"no")
# --members - comma-separated list of members
# --index   - index of this node in the list
wsrep_notify_cmd=

##
## WSREP State Transfer options
##

# State Snapshot Transfer method
wsrep_sst_method=xtrabackup

# Address which donor should send State Snapshot to.
# Should be the address of THIS node. DON'T SET IT TO DONOR ADDRESS!!!
# (SST method dependent. Defaults to the first IP of the first interface)
#wsrep_node_incoming_address=10.0.0.14
#wsrep_sst_receive_address=10.0.0.14

# SST authentication string. This will be used to send SST to joining nodes.
# Depends on SST method. For mysqldump method it is root:<root password>
wsrep_sst_auth=sst:sstpass123:

# Desired SST donor name.
#wsrep_sst_donor=db2

# Reject client queries when donating SST (false)
#wsrep_sst_donor_rejects_queries=0

# Protocol version to use
# wsrep_protocol_version=:
