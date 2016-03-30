centos7安装与优化
=========
* ping www.baidu.com #查看当前是否能上网
* ip add #查看当前IP
* rpm -q centos-release #查看系统版本
* yum repolist #查看已有源
* yum install wget curl
* sudo yum install update -y && sudo yum install upgrade -y

##设置上下键选择历史命令
```sh
vi .inputrc
"\e[B": history-search-forward
"\e[A": history-search-backward
```

##设置连接网络
固定或自动分配IP
* 自动分配ip:
```sh
vi /etc/sysconfig/network-scripts/ifcfg-eno16777736
BOOTPROTO=dhcp
ONBOOT=yes
```
* 静态ip,VM网络适配器一定要使用桥接模式
```sh
vi /etc/sysconfig/network-scripts/ifcfg-eno16777736
BOOTPROTO=static
IPADDR=192.168.1.223
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
ONBOOT=yes
```
* 重启network服务
```sh
systemctl restart network.service
```
##安装第三方源
```sh
yum install epel-release
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
yum install --enablerepo=remi --enablerepo=remi-php56 php php-mysql php-gd php-mbstring php-mcrypt php-memcache php-openssl php-xml php-xmlrpc php-fpm php-opcache php-pdo -y
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
setenforce 0
vi /etc/sysconfig/selinux
SELINUX=disabled
```
##nfs文件共享系统
```sh
服务器端配置：
yum install nfs-utils nfs-utils-lib

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
	stats auth admin:123456
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

#nodejs
```
rpm -Uvh https://rpm.nodesource.com/pub_5.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm
yum install nodejs
```

