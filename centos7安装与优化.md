centos7安装与优化
=========
ping www.baidu.com #查看当前是否能上网
ip add #查看当前IP
rpm -q centos-release #查看系统版本
yum repolist #查看已有源
yum install wget curl

##设置连接网络
固定或自动分配IP
* 自动分配ip:
vi /etc/sysconfig/network-scripts/ifcfg-eno16777736
BOOTPROTO=dhcp
ONBOOT=yes
* 重启network服务
systemctl restart network.service
##更新系统
yum update
##安装第三方源
yum install epel-release
yum install yum-axelget
yum localinstall http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum localinstall http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm

##安装LNMP
yum install nginx -y
yum install --enablerepo=remi --enablerepo=remi-php56 php php-mysql php-gd php-mbstring php-mcrypt php-memcache php-openssl php-xml php-xmlrpc php-fpm php-opcache php-pdo -y
yum install mariadb-server mariadb -y
##安装集群MariaDB
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
##升级LNMP
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
##启动服务
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

##配置LNMP
安全配置 MariaDB
/usr/bin/mysql_secure_installation
##安装git/svn
yum install git
yum install -y subversion
##配置站点
cd /home/
git clone https://****/test.git
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
##数据库配置
mysql -uroot -p123456 -e "create schema test default character set utf8;"
mysql -uroot -p123456 -e "show test;"
mysqldump -uroot -p123456  -R --databases test > test20150528.sql
wget http://****/test20150528.sql
mysql --user=root -p123456 test < test20150528.sql
mysql -uroot -p123456 -e "use test; show tables;"


##防火墙 Firewalld
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=8011/tcp --permanent
firewall-cmd --reload

firewall-cmd –add-service=mysql
firewall-cmd --state
firewall-cmd --list-all
firewall-cmd --list-interfaces
firewall-cmd --get-service
firewall-cmd --query-service service_name
firewall-cmd --add-port=8080/tcp



