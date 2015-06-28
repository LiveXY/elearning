centos7安装与优化
=========
* ping www.baidu.com #查看当前是否能上网
* ip add #查看当前IP
* rpm -q centos-release #查看系统版本
* yum repolist #查看已有源
* yum install wget curl

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
yum install yum-axelget
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
##安装集群MariaDB
```sh
vi /etc/yum.repos.d/MariaDB.repo
# MariaDB 10.0 CentOS repository list - created 2015-06-12 07:44 UTC
# http://mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
#baseurl = http://yum.mariadb.org/10.0/centos7-amd64
baseurl = http://mirrors.opencas.cn/mariadb/mariadb-10.0.19/yum/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
yum install MariaDB-Galera-server MariaDB-client rsync galera -y #安装集群
yum install MariaDB-server MariaDB-client -y
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
/usr/bin/mysql_secure_installation
```
##ERROR 1045 (28000): Access denied for user 'mysql'@'localhost' (using password: NO)
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
yum install git
yum install -y subversion
```
##配置站点
```sh
cd /home/
git clone https://git.upupgame.com/web/moodthermometer.git
mkdir /home/moodthermometer/application/cache
mkdir /home/moodthermometer/application/logs
chmod a+w /home/moodthermometer/application/cache
chmod a+w /home/moodthermometer/application/logs
vi /etc/nginx/conf.d/moodthermometer.conf
server {
	listen 8011;
	server_name localhost;
	index index.php index.htm index.html;
	set $htdocs /home/moodthermometer;
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
mysql -uroot -pnewlife -e "create schema mooddisorders default character set utf8;"
mysql -uroot -pnewlife -e "show mooddisorders;"
mysqldump -uroot -pnewlife  -R --databases mooddisorders > mooddisorders20150528.sql
wget http://192.168.1.222:8011/mooddisorders20150528.sql
mysql --user=root -pnewlife mooddisorders < mooddisorders20150528.sql
mysql -uroot -pnewlife -e "use mooddisorders; show tables;"
```
##防火墙 Firewalld
```sh
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=8011/tcp --permanent
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