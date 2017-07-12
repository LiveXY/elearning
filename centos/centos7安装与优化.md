centos7安装与优化
=========
* ping www.baidu.com #查看当前是否能上网
* ip add #查看当前IP
* rpm -q centos-release #查看系统版本
* yum repolist #查看已有源
* yum install wget curl psmisc -y
* sudo yum install update -y && sudo yum install upgrade -y

##设置上下键选择历史命令
```sh
vi ~/.inputrc
"\e[B": history-search-forward
"\e[A": history-search-backward
```

##设置连接网络
固定或自动分配IP
* 自动分配ip:
```sh
vi /etc/sysconfig/network-scripts/ifcfg-eno16777736 或 vi ifcfg-eno16777736
BOOTPROTO=dhcp
ONBOOT=yes
```
* 静态ip,VM网络适配器一定要使用桥接模式
```sh
vi /etc/sysconfig/network-scripts/ifcfg-eno16777736 或 vi ifcfg-eno16777736
BOOTPROTO=static
IPADDR=192.168.1.223
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
ONBOOT=yes
DNS1=***********
```
* 重启network服务
```sh
systemctl restart network.service
```
##安装第三方源
```sh
yum install epel-release -y
#yum install yum-axelget yum-fastestmirror -y
yum install axel -y
下载配置文件axelget.conf与axelget.py到yum里：
cd /etc/yum/pluginconf.d/
wget http://cnfreesoft.googlecode.com/svn/trunk/axelget/axelget.conf（或wget http://www.ha97.com/code/axelget.conf）
cd /usr/lib/yum-plugins/
wget http://cnfreesoft.googlecode.com/svn/trunk/axelget/axelget.py（或wget http://www.ha97.com/code/axelget.py）
最后确认 /etc/yum.conf中plugins=1
yum localinstall http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum localinstall http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
```
##更新系统
```sh
yum update
```
##安装LNMP
```sh
yum install nginx -y
yum install --enablerepo=remi --enablerepo=remi-php70 php php-mysql php-gd php-mbstring php-mcrypt php-memcached php-openssl php-xml php-xmlrpc php-fpm php-opcache php-pdo -y
yum install mariadb-server mariadb -y
```
##升级LNMP
```sh
vi /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1
vi /etc/yum.repos.d/remi.repo
[remi]
enabled=1
[remi-php56]
enabled=1
yum update
```
##启动服务
```sh
systemctl start nginx.service
systemctl start mariadb.service
systemctl start php-fpm.service
systemctl start memcached.service

systemctl enable nginx.service
systemctl enable mariadb.service
systemctl enable php-fpm.service

systemctl enable mariadb.service #加入随系统启动
systemctl start mariadb.service #启动 mariadb 守护进程
systemctl stop mariadb.service #停止
systemctl restart mariadb.service #重启
systemctl disable mariadb.service #禁用
systemctl is-active mariadb.service #检查 mariadb 服务器 是否正在运行
systemctl status mariadb.service #状态
```
##配置LNMP
安全配置 MariaDB
```sh
systemctl start mariadb.service
/usr/bin/mysql_secure_installation
```
##修改密码(ERROR 1045 (28000): Access denied for user 'mysql'@'localhost' (using password: NO))
```sh
systemctl stop mariadb.service
mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
mysql -u root mysql
> update user set Password=PASSWORD('123456') where User='root';
> flush privileges;
> quit
mysql -uroot -p
```
##安装git/svn
```sh
yum install git -y
yum install -y subversion
```
##安装memcache
```sh
yum install memcached -y
systemctl start memcached.service
```
##配置站点
```sh
cd /home/
git clone https://*****.git
mkdir /home/test/application/cache
mkdir /home/test/application/logs
chmod a+w /home/test/application/cache
chmod a+w /home/test/application/logs
vi /etc/nginx/conf.d/test.conf
server {
	listen 8011;
	server_name localhost;
	index index.php index.htm index.html;
	set $htdocs /home/test;
	root $htdocs;
	large_client_header_buffers 4 16k;
	client_max_body_size 300m;
	client_body_buffer_size 128k;
	#proxy_connect_timeout 600;
	#proxy_read_timeout 600;
	#proxy_send_timeout 600;
	proxy_buffer_size 128k;
	proxy_buffers 4 256k;
	proxy_busy_buffers_size 256k;
	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

	gzip on;
	gzip_min_length 1k;
	gzip_buffers 4 16k;
	gzip_http_version 1.0;
	gzip_comp_level 2;
	gzip_types text/plain application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;
	gzip_vary off;
	gzip_disable "MSIE [1-6]\.";

	location / {
		index index.php index.html index.htm;
		try_files $uri $uri/ index.php$uri?$args;
	}
	location ~ ^(.+.php)(.*)$ {
		fastcgi_split_path_info 			^(.+.php)(.*)$;
		fastcgi_param	SCRIPT_NAME			$fastcgi_script_name;
		fastcgi_param	PATH_INFO			$fastcgi_path_info;
		fastcgi_pass	127.0.0.1:9000;
		fastcgi_index	index.php;
		fastcgi_param	SCRIPT_FILENAME		$htdocs/$fastcgi_script_name;
		include			fastcgi_params;
	}
	location /status {
		stub_status	on;
		access_log	off;
	}
	location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$ {
		expires		30d;
	}
	location ~ .*\.(js|css)?$ {
		expires		12h;
	}
	location /client/ {
		location ~ ^(.+.php)(.*)$ {
			deny all;
		}
	}
}
systemctl reload nginx.service
```
##数据库配置
```sh
mysql -uuser -ppass -e "create schema testdb default character set utf8; create table testtable(id int(10) not null auto_increment, name varchar(20) not null default '', primary key (id)) engine=InnoDB auto_increment=1 default charset=utf8;show testdb;use testdb; show tables;"
```
##防火墙 Firewalld
```sh
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=8011/tcp --permanent
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload

firewall-cmd –-add-service=mysql
firewall-cmd --state
firewall-cmd --list-all
firewall-cmd --list-interfaces
firewall-cmd --get-service
firewall-cmd --query-service service_name
firewall-cmd --add-port=8080/tcp
```
##关闭SELINUX
```sh
getenforce #查看状态
setenforce 0
vi /etc/sysconfig/selinux
SELINUX=disabled
```
##nfs文件共享系统
```sh
服务器端配置：
yum install nfs-utils nfs-utils-lib -y

vi /etc/exports
/home/test/ 192.168.1.0/24(rw,no_root_squash,no_all_squash,sync)
exportfs -r #使配置生效

注：配置文件说明：
/home/test/ 为共享的目录，使用绝对路径。
192.168.1.65(rw,no_root_squash,no_all_squash,sync) 为客户端的地址及权限，地址可以是一个网段，一个ip地址或者是一个域名，域名支持通配符，如：*.youxia.com，地址与权限中间没有空格，权限说明：
rw：read-write，可读写；
ro：read-only，只读；
sync：文件同时写入硬盘和内存；
async：文件暂存于内存，而不是直接写入内存；
no_root_squash：NFS客户端连接服务端时如果使用的是root的话，那么对服务端分享的目录来说，也拥有root权限。显然开启这项是不安全的。
root_squash：NFS客户端连接服务端时如果使用的是root的话，那么对服务端分享的目录来说，拥有匿名用户权限，通常他将使用nobody或nfsnobody身份；
all_squash：不论NFS客户端连接服务端时使用什么用户，对服务端分享的目录来说都是拥有匿名用户权限；
anonuid：匿名用户的UID值，通常是nobody或nfsnobody，可以在此处自行设定；
anongid：匿名用户的GID值。

systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap

firewall-cmd --permanent --zone=public --add-service=nfs
firewall-cmd --reload

systemctl restart rpcbind
systemctl restart nfs-server
systemctl restart nfs-lock
systemctl restart nfs-idmap

mount.nfs: Connection timed out
服务器端防火墙设置（NFS 开启防墙配置）：
vi /etc/sysconfig/nfs
LOCKD_TCPPORT=32803
LOCKD_UDPPORT=32769
MOUNTD_PORT=892
STATD_PORT=662

可以在Linux NFS服务器上执行以下命令获得NFS端口信息:rpcinfo -p
在 Linux NFS 服务器上使用以下命令开启iptables防火墙允许访问以上端口
firewall-cmd --permanent --add-port=111/tcp
firewall-cmd --permanent --add-port=111/udp
firewall-cmd --permanent --add-port=20048/tcp
firewall-cmd --permanent --add-port=20048/udp
firewall-cmd --permanent --add-port=2049/tcp
firewall-cmd --permanent --add-port=2049/udp
firewall-cmd --permanent --add-port=50054/tcp
firewall-cmd --permanent --add-port=50054/udp
firewall-cmd --permanent --add-port=51009/tcp
firewall-cmd --permanent --add-port=51009/udp
firewall-cmd --permanent --add-port=44224/tcp
firewall-cmd --permanent --add-port=38849/udp
firewall-cmd --reload

firewall-cmd --remove-port=111/tcp
firewall-cmd --remove-port=111/udp
firewall-cmd --remove-port=20048/tcp
firewall-cmd --remove-port=20048/udp
firewall-cmd --remove-port=2049/tcp
firewall-cmd --remove-port=2049/udp
firewall-cmd --remove-port=50054/tcp
firewall-cmd --remove-port=50054/udp
firewall-cmd --remove-port=51009/tcp
firewall-cmd --remove-port=51009/udp
firewall-cmd --remove-port=44224/tcp
firewall-cmd --remove-port=38849/udp
firewall-cmd --reload


客户端挂载：
showmount -e 192.168.1.65
rpcinfo -p 192.168.1.65

yum install rpcbind nfs-utils -y
mount -t nfs 10.0.0.10:/home /home
vi /etc/fstab
10.0.0.10:/home    /home   nfs  defaults  0 0

mount -t nfs 192.168.1.65:/home/test/ /home/test/
mount
如果显示：rpc mount export: RPC: Unable to receive; errno = No route to host，则需要在服务端关闭防火墙

解除挂载：
umount /home/test/
如果遇到：umount.nfs: /home/test/: device is busy
可能用命令：
fuser -m -v /home/test/
kill -9 id
umount /home/test/

设置客户端启动时候就挂载NFS
vi /etc/fstab
192.168.1.65:/home/test/ /home/test/ nfs auto,rw,vers=3,hard,intr,tcp,rsize=32768,wsize=32768 0 0
192.168.1.65:/home/test/ /home/test/ nfs rw,hard,intr,nolock 0 0
```
##MariaDB主从复制(同步)
* master
```sh
vi /etc/my.cnf
[mysqld]
server_id = 1
#log-basename = master
log-bin
#log-slave-updates/log-bin
binlog-format = mixed
#复制模式statement/row/mixed 或 set global binlog_format='mixed'; MIXED，可以防止主键重复。
binlog-do-db = testdb
#需要备份的数据库名，可写多行
binlog-ignore-db = mysql
#不需要备份的数据库名，可写多行
max_binlog_size = 500M
binlog_cache_size = 128K
expire_logs_day = 2
auto-increment-increment = 3
auto-increment-offset = 1
systemctl restart mariadb
mysql -uroot -ppass
> show master status\G; #查看master状态
> grant replication slave on *.* to replication_user identified by 'pass' with grant option; #新建复制用户
> flush privileges;
> select * from mysql.user WHERE user="replication_user"\G; #数据库中检查用户
> flush tables with read lock; #锁定数据库表只读 unlock tables;
mysqldump -uroot -ppass  -R --databases testdb > testdb20150528.sql #导出数据库
```
* slave
```sh
vi /etc/my.cnf #不建议
[mysqld]
server_id=2
master-host=172.16.180.133
master-user=replication_user
master-password=pass
master-port=3306
master-connect-retry=30
replicate-do-db = testdb
replicate-ignore-db = mysql
slave-skip-errors=1007,1008,1053,1062,1213,1158,1159
master-info-file = /var/log/mariadb/master.info
relay-log = /var/log/mariadb/relay-bin
relay-log-index = /var/log/mariadb/relay-bin.index
relay-log-info-file = /var/log/mariadb/relay-log.info
```
或
```sh
mysql -uroot -ppass
> change master to master_host='172.16.180.133', master_user='replication_user', master_password='pass', master_port=3306, master_log_file='mariadb-bin.000002', master_log_pos=1179, master_connect_retry=30;
> set global server_id=2;
> slave start;
> show slave status\G;
查看到以下二项都是Yes表示成功：
Slave_IO_Running: Yes
Slave_SQL_Running: Yes
如果看到No表示没有同步成功，查看日志找到错误原因
cat /var/log/mariadb/mariadb.log
```
* 双主从 将上面的主从返过来配置
```
主my.cnf中加入，防止重复自增编号
auto-increment-increment = 3
auto-increment-offset = 1
```
* ERROR 1201 (HY000): Could not initialize master info structure; more error messages can be found in the MariaDB error log
```
> slave stop;
> reset slave;
> change master to ....
> slave start;
```
* Can't connect to MySQL server on '172.16.180.134'
```
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload
```
##安装MariaDB-Galera-server
* 安装
```
ss -na |grep -e 4567 -e 4568 -e 3306
sudo setenforce 0
vi /etc/selinux/config
SELINUX=permissive
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --zone=public --add-port=4444/tcp --permanent
firewall-cmd --zone=public --add-port=4567/tcp --permanent
firewall-cmd --zone=public --add-port=4568/tcp --permanent
firewall-cmd --reload

sudo cat >> /etc/yum.repos.d/MariaDB.repo << EOF
# MariaDB 10.0 CentOS repository list - created 2015-06-12 07:44 UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos7-amd64
#baseurl = http://mirrors.opencas.cn/mariadb/mariadb-10.0.19/yum/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

yum install MariaDB-Galera-server MariaDB-client rsync galera -y #安装集群
如果无法下载需要手动下：
cd /var/cache/yum/x86_64/7/mariadb/packages
axel -n 10 http://yum.mariadb.org/10.0/centos7-amd64/rpms/galera-25.3.9-1.rhel7.el7.centos.x86_64.rpm
axel -n 10 http://yum.mariadb.org/10.0/centos7-amd64/rpms/MariaDB-10.0.20-centos7-x86_64-client.rpm
axel -n 10 http://yum.mariadb.org/10.0/centos7-amd64/rpms/MariaDB-Galera-10.0.20-centos7-x86_64-server.rpm
axel -n 10 http://yum.mariadb.org/10.0/centos7-amd64/rpms/MariaDB-10.0.20-centos7-x86_64-shared.rpm
axel -n 10 http://yum.mariadb.org/10.0/centos7-amd64/rpms/MariaDB-10.0.20-centos7-x86_64-common.rpm
scp MariaDB-10.0.20-centos7-x86_64-shared.rpm root@172.16.180.131:/var/cache/yum/x86_64/7/mariadb/packages
scp MariaDB-10.0.20-centos7-x86_64-common.rpm root@172.16.180.131:/var/cache/yum/x86_64/7/mariadb/packages
scp MariaDB-Galera-10.0.20-centos7-x86_64-server.rpm root@172.16.180.131:/var/cache/yum/x86_64/7/mariadb/packages
scp MariaDB-10.0.20-centos7-x86_64-client.rpm root@172.16.180.131:/var/cache/yum/x86_64/7/mariadb/packages

service mysql start
mysql_secure_installation
service mysql stop
mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
mysql -u root mysql -e "update user set Password=PASSWORD('pass') where User='root';flush privileges;"
mysql -uroot -ppass -e "delete from mysql.user where user=''; grant all on *.* to 'root'@'%' identified by 'pass';grant usage on *.* to sst_user@'%' identified by 'pass'; grant all privileges on *.* to sst_user@'%'; flush privileges;select Host,User from mysql.user;"
service mysql stop
```
* 配置
```
ip: db1-172.16.180.136,db3-172.16.180.137,db2-172.16.180.138

#db1:
vi /etc/my.cnf.d/server.cnf
[mysqld]
binlog_format=row
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
innodb_locks_unsafe_for_binlog=1
query_cache_size=0
query_cache_type=0
bind-address=0.0.0.0

datadir=/var/lib/mysql
innodb_log_file_size=100M
innodb_file_per_table=1
innodb_flush_log_at_trx_commit=2

wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_address="gcomm://172.16.180.136,172.16.180.138,172.16.180.137"
wsrep_cluster_name='galera_cluster'
wsrep_node_address='172.16.180.136'
wsrep_node_name='db1'
wsrep_sst_method=rsync
wsrep_sst_auth=sst_user:pass

#db2:
vi /etc/my.cnf.d/server.cnf
[mysqld]
binlog_format=row
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
innodb_locks_unsafe_for_binlog=1
query_cache_size=0
query_cache_type=0
bind-address=0.0.0.0

datadir=/var/lib/mysql
innodb_log_file_size=100M
innodb_file_per_table=1
innodb_flush_log_at_trx_commit=2

wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_address="gcomm://172.16.180.136,172.16.180.138,172.16.180.137"
wsrep_cluster_name='galera_cluster'
wsrep_node_address='172.16.180.138'
wsrep_node_name='db2'
wsrep_sst_method=rsync
wsrep_sst_auth=sst_user:pass

#db3:
vi /etc/my.cnf.d/server.cnf
[mysqld]
binlog_format=row
default-storage-engine=innodb
innodb_autoinc_lock_mode=2
innodb_locks_unsafe_for_binlog=1
query_cache_size=0
query_cache_type=0
bind-address=0.0.0.0

datadir=/var/lib/mysql
innodb_log_file_size=100M
innodb_file_per_table=1
innodb_flush_log_at_trx_commit=2

wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_address="gcomm://172.16.180.136,172.16.180.138,172.16.180.137"
wsrep_cluster_name='galera_cluster'
wsrep_node_address='172.16.180.137'
wsrep_node_name='db3'
wsrep_sst_method=rsync
wsrep_sst_auth=sst_user:pass

#db1:
service mysql start --wsrep-new-cluster
mysql -uroot -ppass -e "show status like 'wsrep%'"
mysql -uroot -ppass -e "SHOW VARIABLES LIKE 'wsrep_cluster_address'"
#db2:
service mysql start
mysql -uroot -ppass -e "show status like 'wsrep%'"
#db3:
service mysql start
mysql -uroot -ppass -e "show status like 'wsrep%'"

#db1:
mysql -uroot -ppass -e 'CREATE DATABASE clustertest;'
mysql -uroot -ppass -e 'CREATE TABLE clustertest.mycluster ( id INT NOT NULL AUTO_INCREMENT, name VARCHAR(50), ipaddress VARCHAR(20), PRIMARY KEY(id));'
mysql -uroot -ppass -e 'INSERT INTO clustertest.mycluster (name, ipaddress) VALUES ("db1", "172.16.180.136");'
mysql -uroot -ppass -e 'SELECT * FROM clustertest.mycluster;'

#db2:
mysql -uroot -ppass -e 'SELECT * FROM clustertest.mycluster;'
mysql -uroot -ppass -e 'INSERT INTO clustertest.mycluster (name, ipaddress) VALUES ("db2", "172.16.180.138");'

#db3:
mysql -uroot -ppass -e 'SELECT * FROM clustertest.mycluster;'
mysql -uroot -ppass -e 'INSERT INTO clustertest.mycluster (name, ipaddress) VALUES ("db3", "172.16.180.137");'
```
##haproxy为数据库作负载均衡

* db1-db3:
```
mysql -uroot -ppass -e 'grant process on *.* to "clustercheckuser"@"localhost" identified by "clustercheckpassword!";'
git clone https://github.com/olafz/percona-clustercheck.git
cp percona-clustercheck/clustercheck /usr/bin/
chmod +x /usr/bin/clustercheck

cat >> /etc/xinetd.d/mysqlchk << EOF
# default: on
# description: mysqlchk
service mysqlchk
{
    disable = no
    flags = REUSE
    socket_type = stream
    port = 9200
    wait = no
    user = nobody
    server = /usr/bin/clustercheck
    log_on_failure += USERID
    only_from = 0.0.0.0/0
    per_source = UNLIMITED
}
EOF
echo 'mysqlchk 9200/tcp # mysqlchk' >> /etc/services

firewall-cmd --zone=public --add-port=9200/tcp --permanent
firewall-cmd --reload

yum install xinetd -y
systemctl start xinetd
/usr/bin/clustercheck
```
* haproxy:
```
yum install haproxy -y

vi /etc/haproxy/haproxy.cfg
global
	log 127.0.0.1 local2
	chroot /var/lib/haproxy
	pidfile /var/run/haproxy.pid
	maxconn 60000
	user haproxy
	group haproxy
	daemon

defaults
	mode http
	log global
	option dontlognull
	option httpclose
	#option httplog
	option tcplog
	#option forwardfor
	option redispatch
	timeout connect 5000ms # default 10 second time out if a backend is not found
	timeout client 50000ms
	timeout server 50000ms
	maxconn 60000
	retries 3

listen stats-front *:8000
	mode http
	stats enable
	stats realm HAProxy\ Galera
	stats uri /dbs/stats
	stats auth a:a
	stats admin if TRUE

frontend db-cluster-front
	bind *:3306
	mode tcp
	default_backend db-cluster-write-back

backend db-cluster-write-back
	mode tcp
	option httpchk
	balance leastconn
    option tcpka
	server db1 172.16.180.136:3306 check port 9200 inter 1000 rise 3 fall 1
	server db2 172.16.180.138:3306 check port 9200 inter 1000 rise 3 fall 1 backup
	server db3 172.16.180.137:3306 check port 9200 inter 1000 rise 3 fall 1 backup

frontend db-cluster-read-front
	bind *:4306
	mode tcp
	default_backend db-cluster-read-back

backend db-cluster-read-back
	mode tcp
	balance leastconn
	option tcpka
	option httpchk
	server db1 172.16.180.136:3306 weight 1 check port 9200 inter 1000 rise 3 fall 1
	server db2 172.16.180.138:3306 weight 2 check port 9200 inter 1000 rise 3 fall 1
	server db3 172.16.180.137:3306 weight 2 check port 9200 inter 1000 rise 3 fall 1

systemctl start haproxy
firewall-cmd --zone=public --add-port=8000/tcp --permanent
firewall-cmd --reload
http://172.16.180.139:8000/dbs/stats

#一写二备份
mysql -h 172.16.180.139 -uroot -ppass -e 'show status like "wsrep%";' | grep wsrep_gcomm_uuid
#三读
mysql -h 172.16.180.139 -P 4306 -uroot -ppass -e 'show status like "wsrep%";' | grep wsrep_gcomm_uuid
#任何一台或二台死掉其它都能正常访问，除非所有数据库死掉。
```
#haproxy php
```
vi /etc/haproxy/haproxy.cfg
global
    log         127.0.0.1 local2
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     40000
    user         haproxy
    group       haproxy
    daemon # 以后台程序运行；

defaults
    mode                   http # 选择HTTP模式，即可进行7层过滤；
    log                     global
    option                  httplog # 可以得到更加丰富的日志输出；
    option                  dontlognull
    option http-server-close # server端可关闭HTTP连接的功能；
    option forwardfor except 127.0.0.0/8 # 传递client端的IP地址给server端，并写入“X-Forward_for”首部中；
    option originalto
    option                  redispatch
    retries                 3
    timeout http-request    30s
    timeout queue           1m
    timeout connect         30s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 30s
    timeout check           30s
    maxconn                 30000

listen stats
    mode http
    bind 0.0.0.0:1080 # 统计页面绑定1080端口；
    stats enable # 开启统计页面功能；
    #stats hide-version # 隐藏Haproxy版本号；
    stats uri     /stats # 自定义统计页面的访问uri；
    stats realm   Haproxy\ Statistics # 统计页面密码验证时的提示信息；
    stats auth    a:a # 为统计页面开启登录验证功能；
    stats admin if TRUE # 若登录用户验证通过，则赋予管理功能；

frontend jggame
    bind *:80
    mode http
    log global
#    option httpclose
    option logasap
    option dontlognull
#    capture request  header Host len 20
#    capture request  header Referer len 60
    #acl url_static       path_beg       -i /static /images /javascript /stylesheets
    #acl url_static       path_end       -i .jpg .jpeg .gif .png .css .js .html
    #use_backend static_servers if url_static # 符合ACL规则的，请求转入后端静态服务器
    default_backend jgnode # 默认请求转入后端动态服务器

backend jgnode
    balance roundrobin
        option httpchk  GET / HTTP/1.1\r\nHost:\ SCSC
        server php1 10.0.0.11:80 cookie php1 check port 333 inter 5000 rise 3 fall 2
        server php2 10.0.0.12:80 cookie php2 check port 333 inter 5000 rise 3 fall 2

vi /home/nginx/conf.d/server333.conf
server
{
        listen  333;
#		listen 80;
#		listen 443;
#		ssl_certificate      /home/ssl/cert.crt;
#               ssl_certificate_key  /home/ssl/cert.key;

#                ssl_ciphers RC4:HIGH:!aNULL:!MD5;
#		ssl_prefer_server_ciphers   on;

		server_name _ SCSC;
        index index.php index.htm index.html;
		set $htdoc /home/ssl;
        root  $htdoc;
        large_client_header_buffers 4 16k;
        client_max_body_size 300m;
        client_body_buffer_size 128k;
        proxy_connect_timeout 600;
        proxy_read_timeout 600;
        proxy_send_timeout 600;
        proxy_buffer_size 64k;
        proxy_buffers   4 32k;
        proxy_busy_buffers_size 64k;
        proxy_temp_file_write_size 64k;

		location ~ .*\.(php|php5)?$
		{
                    #limit_rate 20k;
	            #limit_conn one 2;
		    root $htdoc;
		    fastcgi_pass   127.0.0.1:9000;
		    fastcgi_index  index.php;
		    fastcgi_param  SCRIPT_FILENAME  $htdoc$fastcgi_script_name;
		    include        fastcgi_params;
		}
        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
        {
                expires      30d;
        }

        location ~ .*\.(js|css)?$
	    {
	            expires      12h;
	    }
}
vi /home/ssl/index.php
<?php
$timestamp=time();
//$url=" google-public-dns-a.google.com";
$url="www.baidu.com";
$file="/tmp/".$url;

$mem=new Memcached();
//$mem->connect( "10.0.0.10",11211 );
$mem->addServer("10.0.0.10",11211);
if(empty($_SERVER["SERVER_ADDR"]))$_SERVER["SERVER_ADDR"]="127";
$key=implode("_", explode(".",$_SERVER["SERVER_ADDR"].$url));

$res=$mem->get($key);

if(!empty($res)){
	$res=json_decode($res,true);
}else{
	$res=['time'=>0,'ping'=>0];
}

if($timestamp>($res['time']+5)){
	$ping=pingAddress($url);
	if($ping!=0){
		$ping=pingAddress("www.qq.com");
	}
	$res['time']=$timestamp;
	$res['ping']=$ping;
	$mem->set($key,json_encode($res),0);
}
if (0 == $res['ping']) {
    header("HTTP/1.1 200 OK");
	header("Content-Type: text/plain");
	header("Connection: close");
	header("Content-Length: 15");
	echo "PUB NETWORK OK.";
} else {
    header("HTTP/1.1 503 Service Unavailable");
	header("Content-Type: text/plain");
	header("Connection: close");
	header("Content-Length: 27");
	echo "Out Network Is Unavailable!";
}
function pingAddress($ip) {
    $pingresult = exec("/bin/ping -c 2 $ip", $outcome, $status);
    return $status;
}
php /home/ssl/index.php
```

#haproxy web80 nodejs8080
```
vi /etc/haproxy/haproxy.cfg
global
    log         127.0.0.1 local2
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     40000
    user         haproxy
    group       haproxy
    daemon # 以后台程序运行；

defaults
    mode                   http # 选择HTTP模式，即可进行7层过滤；
    log                     global
    option                  httplog # 可以得到更加丰富的日志输出；
    option                  dontlognull
    option http-server-close # server端可关闭HTTP连接的功能；
    option forwardfor except 127.0.0.0/8 # 传递client端的IP地址给server端，并写入“X-Forward_for”首部中；
    option originalto
    option                  redispatch
    retries                 3
    timeout http-request    30s
    timeout queue           1m
    timeout connect         30s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 30s
    timeout check           30s
    maxconn                 30000

listen stats
    mode http
    bind 0.0.0.0:1080 # 统计页面绑定1080端口；
    stats enable # 开启统计页面功能；
    #stats hide-version # 隐藏Haproxy版本号；
    stats uri     /stats # 自定义统计页面的访问uri；
    stats realm   Haproxy\ Statistics # 统计页面密码验证时的提示信息；
    stats auth    a:a # 为统计页面开启登录验证功能；
    stats admin if TRUE # 若登录用户验证通过，则赋予管理功能；

frontend tcp-8080-front
    bind *:8080
    mode tcp
    default_backend     tcp-8080-back

backend tcp-8080-back
   mode tcp
   balance leastconn
   server tcp-8080 10.0.0.43:8080

frontend kwx
    bind *:80
    mode http
    log global
    option logasap
    option dontlognull
    default_backend kwxlb # 默认请求转入后端动态服务器

backend kwxlb
    balance roundrobin
    server lb 10.0.0.43:80

```

#nodejs
```
rpm -Uvh https://rpm.nodesource.com/pub_5.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm
yum install nodejs -y
yum install "gcc-c++.x86_64"

rpm -Uvh https://rpm.nodesource.com/pub_5.x/el/6/x86_64/nodesource-release-el6-1.noarch.rpm
rpm -qa | grep node
yum clean all
```

#安全策略
禁止所有可连接端口后开启外网的22;80;443端口，开启内网可访问的所有端口。

#CentOS性能分析
yum install sysstat -y
* `uptime` #分析1，5，15分钟平均负载
* `dmesg | tail` #该命令会输出系统日志的最后10行
* `vmstat 1` #每一秒输出一些系统核心指标
r：等待在CPU资源的进程数，如果这个数值大于机器CPU核数，那么机器的CPU资源已经饱和
free：系统可用内存数
si，so：交换区写入和读取的数量。如果这个数据不为0，说明系统已经在使用交换区（swap），机器物理内存已经不足。
us, sy, id, wa, st：这些都代表了CPU时间的消耗，它们分别表示用户时间（user）、系统（内核）时间（sys）、空闲时间（idle）、IO等待时间（wait）和被偷走的时间（stolen，一般被其他虚拟机消耗）
* `mpstat -P ALL 1` 显示每个CPU的占用情况，如果有一个CPU占用率特别高，那么有可能是一个单线程应用程序引起的
* `pidstat 1` pidstat命令输出进程的CPU占用率
* `iostat -xz 1` iostat命令主要用于查看机器磁盘IO情况
r/s, w/s, rkB/s, wkB/s：分别表示每秒读写次数和每秒读写数据量（千字节）。读写量过大，可能会引起性能问题。
await：IO操作的平均等待时间，单位是毫秒。这是应用程序在和磁盘交互时，需要消耗的时间，包括IO等待和实际操作的耗时。如果这个数值过大，可能是硬件设备遇到了瓶颈或者出现故障。
avgqu-sz：向设备发出的请求平均数量。如果这个数值大于1，可能是硬件设备已经饱和（部分前端硬件设备支持并行写入）。
%util：设备利用率。这个数值表示设备的繁忙程度，经验值是如果超过60，可能会影响IO性能（可以参照IO操作平均等待时间）。如果到达100%，说明硬件设备已经饱和。
* `free -m` free命令可以查看系统内存的使用情况，-m参数表示按照兆字节展示
* `sar -n DEV 1` sar命令在这里可以查看网络设备的吞吐率
* `sar -n TCP,ETCP 1` sar命令在这里用于查看TCP连接状态，其中包括：
active/s：每秒本地发起的TCP连接数，既通过connect调用创建的TCP连接；
passive/s：每秒远程发起的TCP连接数，即通过accept调用创建的TCP连接；
retrans/s：每秒TCP重传数量；
* `pmap -d pid` 查看进程占内存详情
* `ps auxw|head -1;ps auxw|sort -rn -k3|head -10` 或 `ps auxw --sort=%cpu` CPU占用最多的前10个进程
* `ps auxw|head -1;ps auxw|sort -rn -k4|head -10` 或 `ps auxw --sort=rss` 内存消耗最多的前10个进程
* `ps auxw|head -1;ps auxw|sort -rn -k5|head -10` 虚拟内存使用最多的前10个进程
* `ps -e -o 'pid,comm,args,pcpu,rsz,vsz,stime,user,uid' | grep node |  sort -nrk5` 查看node内存
* `strace -p $(pgrep php-fpm |head -1)` `strace -T -tt -F -e trace=all -p $(pgrep php-fpm |head -1)` 跟踪php-fpm进程执行时的系统调用和所接收的信号
file_get_contents 会导致：select(7, [6], [6], [], {15, 0}) = 1 (out [6], left {15, 0}) poll([{fd=6, events=POLLIN}], 1, 0) = 0 (Timeout) CPU100%
vi /etc/php-fpm.d/www.conf 修改 request_terminate_timeout=30s
* `pmap -p $(pgrep php-fpm |head -1)` 查看php-fpm进程使用内存
* 分析进程占用 cpu过高 方法
```
1.进程 里线程cpu排序: ps H -e -o pid,tid,pcpu,cmd --sort=pcpu |grep php-fpm
2. gdb  attach 到进程号码
3. gdb  info threads 找到线程号码对应的thread,thread 线程号码切换到线程
bt 查看线程调用。
```
* 按状态查看连接连接数量：`ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}'`
* 列出大文件和目录 `du -h | grep -P "^\S*G"` 或 `find . -type f -size +10M`
* 显示下2行 `cat test.log | grep test -A 2`
* 显示上2行 `cat test.log | grep test -B 2`
* 显示上下2行 `cat test.log | grep test -C 2`
* 查看所有监听端口 `netstat -tulpn`
* 抓取访问服务器80的IP数 `tcpdump -tnn dst port 80 -c 100 | awk -F"." '{print $1"."$2"."$3"."$4}' | sort | uniq -c | sort -n -r |head -20`


#CentOS安全分析
* `lastb` 检查系统错误登陆日志，统计IP重试次数
* 查看是否存在空口令帐户
`cat /etc/passwd` 查看是否有异常的系统用户
`grep '0' /etc/passwd` 查看是否产生了新用户，UID和GID为0的用户
`ls -l /etc/passwd` 查看passwd的修改时间，判断是否在不知的情况下添加用户
`awk -F: "$3= =0 {print $1}" /etc/passwd` 查看是否存在特权用户
`awk -F: 'length($2)= =0 {print $1}' /etc/shadow` 查看是否存在空口令帐户
* 检查异常进程
`ps -ef` 注意UID为0的进程使用
`lsof -p pid` 察看该进程所打开的端口和文件
检查隐藏进程:
ps -ef | awk '{print }' | sort -n | uniq >1
ls /porc |sort -n|uniq >2
diff 1 2
* 检查网络
ip link | grep PROMISC（正常网卡不该在promisc模式，可能存在sniffer）
lsof -i:80
netstat -nap（察看不正常打开的TCP/UDP端口)
arp -a
* 检查系统后门
cat /etc/crontab
ls /var/spool/cron/
cat /etc/rc.d/rc.local
ls /etc/rc.d
ls /etc/rc3.d
* 检查系统服务
chkconfig -list
rpcinfo -p（查看RPC服务）
* 检查rootkit
rkhunter -c
chkrootkit -q

列出 Linux 系统下所有的设备
ls /dev/sda*
df -h
lsblk
fdisk -l

buff/cache占有太高
通过echo 3 > /proc/sys/vm/drop_caches，即可清空buff/cache

永久删除文件
1，shred -zvu test.log
-z – 最后一次使用 0 进行覆盖以隐藏覆写动作。
-u – 覆写后截断并移除文件。
-v – 显示详细过程。
2，yum install wipe
wipe -rfi private/*
-r - 告诉 wipe 递归地擦除子目录
-f - 启用强制删除并禁用确认查询
-i - 显示擦除进度
3，yum install secure-delete
srm -vz private/*
-v – 启用 verbose 模式
-z – 用0而不是随机数据来擦除最后的写入
4，sfill -v /home/username
5，cat /proc/swaps
swapon
swapoff /dev/sda6
sswap /dev/sda6
6，sdmem -f -v


以下命令会将所有 .pdf 文件重命名为 .doc 文件，使用的规则为 's/\.pdf$/\.doc/'：
rename -v 's/\.pdf$/\.doc/' *.pdf
所有匹配 "*.bak" 的文件来移除其拓展名
rename -v 's/\e.bak$//' *.bak

检查单词拼写 look docum
