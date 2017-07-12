xtrabackup备份和恢复
=========
备份方式：
* 热备份：读写不受影响（mysqldump-->innodb）
* 温备份：仅可以执行读操作（mysqldump-->myisam）
* 冷备份：离线备份，读写都不可用
* 逻辑备份：将数据导出文本文件中（mysqldump）
* 物理备份：将数据文件拷贝（xtrabackup、mysqlhotcopy）
* 完整备份：备份所有数据
* 增量备份：仅备份上次完整备份或增量备份以来变化的数据
* 差异备份：仅备份上次完整备份以来变化的数据
创建备份用户：
```
mysql -uroot -ppass -e "grant reload,lock tables,replication client on *.* to 'bak'@'localhost' identified by '123456';flush privileges;"
```
安装：
```
rpm -ivh http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm
yum install percona-xtrabackup -y
```
xtrabackup参数：
* --user=     #指定数据库备份用户
* --password=  #指定数据库备份用户密码
* --port=     #指定数据库端口
* --host=     #指定备份主机
* --socket=    #指定socket文件路径
* --databases=  #备份指定数据库,多个空格隔开，如--databases="dbname1 dbname2"，不加备份所有库
* --defaults-file=       #指定my.cnf配置文件
* --apply-log         #日志回滚
* --incremental=          #增量备份，后跟增量备份路径
* --incremental-basedir=     #增量备份，指上次增量备份路径
* --redo-only         #合并全备和增量备份数据文件
* --copy-back         #将备份数据复制到数据库，数据库目录要为空
* --no-timestamp          #生成备份文件不以时间戳为目录名
* --stream=             #指定流的格式做备份，--stream=tar，将备份文件归档
* --remote-host=user@ip DST_DIR #备份到远程主机
完整备份与恢复：
```
#完整备份
innobackupex --user=bak --password='123456' --no-lock /home/dbbak
#备份恢复
service mysql stop 或 systemctl stop mariadb;
innobackupex --defaults-file=/etc/my2.cnf --copy-back /home/dbbak/2015-07-09_11-26-00/
chown -R mysql.mysql /var/lib/mysql
service mysql start 或 systemctl mariadb start;
```
备份文件说明：
* backup-my.cnf：记录innobackup使用到mysql参数
* xtrabackup_binary：备份中用到的可执行文件
* xtrabackup_checkpoints：记录备份的类型、开始和结束的日志序列号
* xtrabackup_logfile：备份中会开启一个log copy线程，用来监控innodb日志文件（ib_logfile），如果修改就会复制到这个文件
完整备份+增量备份与恢复：
```
#完整备份
innobackupex --user=bak --password='123456' --no-lock /home/dbbak
#增量备份1
innobackupex --user=bak --password='123456' --incremental /home/dbbak --incremental-basedir=/home/dbbak/2015-07-09_11-26-00  #指定上次完整备份目录
#增量备份2
innobackupex --user=bak --password='123456' --incremental /home/dbbak --incremental-basedir=/home/dbbak/2015-07-09_11-47-04  #指定上次增量备份目录
#查看xtrabackup_checkpoints文件
cat /home/dbbak/2015-07-09_11-26-00/xtrabackup_checkpoints
cat /home/dbbak/2015-07-09_11-47-04/xtrabackup_checkpoints
cat /home/dbbak/2015-07-09_11-48-00/xtrabackup_checkpoints
#备份恢复：将增量备份1、增量备份2...合并到完整备份，加到一起出来一个新的完整备份，将新的完整备份以拷贝的形式到数据库空目录（rm /var/lib/mysql/* -rf）
service mysql stop 或 systemctl stop mariadb;
#合并完整备份 xtrabackup把备份过程中可能有尚未提交的事务或已经提交但未同步数据文件的事务，写到xtrabackup_logfile文件，所以要先通过这个日志文件回滚，把未完成的事务同步到备份文件，保证数据文件处于一致性。
innobackupex --apply-log --redo-only /home/dbbak/2015-07-09_11-26-00/
#合并第一个增量备份
innobackupex --apply-log --redo-only /home/dbbak/2015-07-09_11-26-00/ --incremental-dir=/home/dbbak/2015-07-09_11-47-04/
#合并第二个增量备份
innobackupex --apply-log --redo-only /home/dbbak/2015-07-09_11-26-00/ --incremental-dir=/home/dbbak/2015-07-09_11-48-00/
#恢复完整备份
innobackupex --defaults-file=/etc/my2.cnf --copy-back /home/dbbak/2015-07-09_11-26-00/
#修改恢复数据文件权限
chown -R mysql.mysql /var/lib/mysql
service mysql start 或 systemctl mariadb start
#增加从日志恢复
cat /home/dbbak/2015-07-09_11-48-00/xtrabackup_binlog_info
mysql-bin.000005    979
mysqlbinlog --start-position=979 /var/lib/mysql/mysql-bin.000005 > /home/dbbak/timepoint.sql
mysql -u root -p < /home/dbbak/timepoint.sql
```
备份文件归档压缩：
```
#归档并发送到备份服务器
#归档备份
innobackupex --databases=test --user=bak --password='123456' --stream=tar /home/dbbak > /home/dbbak/`date +%F`.tar
tar -ixvf `date +%F`.tar
#压缩归档备份
innobackupex --databases=test --user=bak --password='123456' --stream=tar /home/dbbak | gzip >/home/dbbak/`date +%F`.tar.gz
tar zxfi /home/dbbak/`date +%F`.tar.gz
```
增量备份单个数据库：
```
#全量备份
innobackupex --user=bak --password='123456' --databases="mooddisorders" --no-lock /home/dbbak/
#完整备份目录上做第一次增量备份
innobackupex --user=bak --password='123456' --databases="mooddisorders" --apply-log-only --incremental /home/dbbak/ --incremental-basedir=/home/dbbak/2015-07-09_12-43-36/
#完整恢复：
service mysql stop 或 systemctl stop mariadb;
innobackupex --apply-log --redo-only /home/dbbak/2015-07-09_12-43-36/
innobackupex --apply-log --redo-only /home/dbbak/2015-07-09_12-43-36/ --incremental-dir=/home/dbbak/2015-07-09_12-45-06/
innobackupex --copy-back --defaults-file=/etc/my2.cnf /home/dbbak/2015-07-09_12-43-36/
chown -R mysql.mysql /var/lib/mysql
service mysql start 或 systemctl mariadb start;
```


mysqlhotcopy备份和恢复 只支持MyISAM引擎
==========
```
#备份
mysqlhotcopy dbname -u root -p pass /home/dbbak
mysqlhotcopy --addtodest db1 db2 -u root -p pass /home/dbbak
#还原
cp /path /var/lib/mysql/ -R
chown -R mysql.mysql /var/lib/mysql
service mysql start
```


mysqlbinlog恢复数据
==========
mysqlbinlog支持下面的选项：
* ---help，-？    显示帮助消息并退出。
* ---database=db_name，-d db_name     只列出该数据库的条目(只用本地日志)。
* --force-read，-f     使用该选项，如果mysqlbinlog读它不能识别的二进制日志事件，它会打印警告，忽略该事件并继续。没有该选项，如果mysqlbinlog读到此类事件则停止。
* --hexdump，-H    在注释中显示日志的十六进制转储。该输出可以帮助复制过程中的调试。在MySQL 5.1.2中添加了该选项。
* --host=host_name，-h host_name    获取给定主机上的MySQL服务器的二进制日志。
* --local-load=path，-l pat    为指定目录中的LOAD DATA INFILE预处理本地临时文件。
* --offset=N，-o N     跳过前N个条目。
* --password[=password]，-p[password]    当连接服务器时使用的密码。如果使用短选项形式(-p)，选项和 密码之间不能有空格。如果在命令行中--password或-p选项后面没有 密码值，则提示输入一个密码。
* --port=port_num，-P port_num    用于连接远程服务器的TCP/IP端口号。
* --position=N，-j N    不赞成使用，应使用--start-position。
* --protocol={TCP | SOCKET | PIPE | -position    使用的连接协议。
* --read-from-remote-server，-R    从MySQL服务器读二进制日志。如果未给出该选项，任何连接参数选项将被忽略。这些选项是--host、--password、--port、--protocol、--socket和--user。
* --result-file=name, -r name    将输出指向给定的文件。
* --short-form，-s    只显示日志中包含的语句，不显示其它信息。
* --socket=path，-S path    用于连接的套接字文件。
* --start-datetime=datetime    从二进制日志中第1个日期时间等于或晚于datetime参量的事件开始读取。datetime值相对于运行mysqlbinlog的机器上的本地时区。该值格式应符合DATETIME或TIMESTAMP数据类型。
* --stop-datetime=datetime    从二进制日志中第1个日期时间等于或晚于datetime参量的事件起停止读。关于datetime值的描述参见--start-datetime选项。该选项可以帮助及时恢复。
* --start-position=N    从二进制日志中第1个位置等于N参量时的事件开始读。
* --stop-position=N    从二进制日志中第1个位置等于和大于N参量时的事件起停止读。
* --to-last-logs，-t    在MySQL服务器中请求的二进制日志的结尾处不停止，而是继续打印直到最后一个二进制日志的结尾。如果将输出发送给同一台MySQL服务器，会导致无限循环。该选项要求--read-from-remote-server。
* --disable-logs-bin，-D    禁用二进制日志。如果使用--to-last-logs选项将输出发送给同一台MySQL服务器，可以避免无限循环。该选项在崩溃恢复时也很有用，可以避免复制已经记录的语句。注释：该选项要求有SUPER权限。
* --user=user_name，-u user_name    连接远程服务器时使用的MySQL用户名。
* --version，-V   显示版本信息并退出。
实例：
* mysqlbinlog logfilepath 显示日志内容
* mysqlbinlog --start-position="20" --stop-position="2000" --database=resource mysql-bin.407 --result-file=result.sql 根据position从20-2000查找resource库相关记录，并输出到指定文件
* mysqlbinlog --start-position="20" --stop-position="2000" --database=resource mysql-bin.407 | mysql -u root 查找并导入数据库
* mysqlbinlog --start-datetime="2012-09-20 8:10:00" --stop-datetim="2012-09-25 07:30:00" mysql-bin.407 --result-file=result.sql 还可以根据时间来查找记录
* mysqlbinlog --position=387426452 --set-charset=utf8 --database=resource mysql-bin.407 --result-file=result_resource.sql 原中文编码为gb2312，转换utf8编码 或 iconv -t utf-8 -f gb2312 -c result_resource.sql > new_result_resource.sql_utf8.sql
* mysqlbinlog --no-defaults mysql-bin.000014 mysql-bin.000015 --start-datetime='2014-06-24 02:23:00'>bin.sql
less bin.sql

mysqldump备份和恢复
==========
```
mysqldump --all-databases -uroot -p123456 > file.sql
mysql -uroot -p123456 < file.sql
```

其它
======
```
chmod 755 /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql/dbname/
chmod 755 /var/lib/mysql/dbname/
chmod 644 /var/lib/mysql/dbname/*
chmod 644 /var/lib/mysql/ib*
```

binlog2sql
======
git clone https://github.com/danfengcao/binlog2sql.git && cd binlog2sql
pip install -r requirements.txt
```
查看目前的binlog文件
show master status;
根据大致时间过滤数据。
python binlog2sql/binlog2sql.py -h127.0.0.1 -P3306 -uadmin -p'admin' -dtest -ttbl --start-file='mysql-bin.000052' --start-datetime='2016-12-13 20:25:00' --stop-datetime='2016-12-13 20:30:00'
找到误操作sql的准确位置，使用flashback模式生成回滚sql
python binlog2sql/binlog2sql.py -h127.0.0.1 -P3306 -uadmin -p'admin' -dtest -ttbl --start-file='mysql-bin.000052' --start-position=3346 --stop-position=3556 -B > rollback.sql | cat
mysql -h127.0.0.1 -P3306 -uadmin -p'admin' < rollback.sql
```

mysqlbinlog恢复数据
======
show master status;
mysqlbinlog --start-datetime='2017-01-10 14:00:00' --stop-datetime='2017-01-10 14:00:00' cdb70405_binmysqlbin.000297 > test.sql



