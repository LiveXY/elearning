centos6.5安装与优化
==========
linux下载地址：http://mirrors.163.com/centos/6.5/isos/x86_64/CentOS-6.5-x86_64-minimal.iso

## 目录介绍：
* 配置目录：`/etc/`
  * `/etc/nginx/conf.d/` nginx配置目录
  * `/etc/php.d/` php组件配置目录
* 日志目录：`/var/log/`
  * `/var/log/php-fpm/` php日志目录
* 服务目录：`/usr/sbin/`、`/sbin/`
* 程序目录：`/usr/bin/`、`/bin/`
* mysql目录：`/var/lib/mysql/`
* php组件目录：`/usr/lib64/php/modules/`

## 准备：
* cat /etc/redhat-release 或 rpm -q centos-release #查看系统版本
* `su root` 切换root
* `passwd root` 修改root密码
* `yum install perl -y` mini版本不带perl 需要安装perl
* `yum install yum-fastestmirror -y` 解决loaded plugins:fastestmirror错误
* `yum install wget -y` 安装wget
* `yum remove httpd` 使用nginx就不需要httpd了 或 `chkconfig httpd off && service httpd stop` 关闭httpd
* `wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && rpm -ivh epel-release-6-8.noarch.rpm` 导入epel源
* `wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm && rpm -ivh remi-release-6.rpm` 导入remi源
* `yum upgrade -y` 更新内核
* `yum update -y` 更新软件
* `yum clean all` 清理全部缓存文件

## 创建免密登录
```
ssh-keygen -t rsa
ssh-keygen -t rsa -P ''
ssh-keygen -t rsa -P '' -f ~/id_rsa
yum -y install openssh-clients
ssh-copy-id -i /root/.ssh/id_rsa.pub root@ipaddress
```

## nginx安装与配置
* nginx安装：
```sh
yum install nginx -y
chkconfig nginx on
service nginx start
```
* nginx配置：
```nginx
vi /etc/nginx/conf.d/default.conf
server_tokens   off; #不显示Nginx版本
```
* nginx升级：
```sh
vi /etc/yum.repos.d/nginx.repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/6/$basearch/
gpgcheck=0
enabled=1
yum update nginx
vi /etc/yum.repos.d/nginx.repo
enabled=0
service nginx restart
```

## mysql安装与配置
* mysql安装：
```sh
yum install mysql mysql-server -y
chkconfig mysqld on
service mysqld start
```
* mysql配置：
```sh
vi /etc/my.cnf
innodb_file_per_table=1
log-bin=mysql-bin
service mysqld restart
```

## php安装与配置
* php安装：
```sh
yum install php php-mysql php-gd php-mbstring php-mcrypt php-memcache php-openssl php-xml php-xmlrpc php-fpm php-opcache -y
chkconfig php-fpm on
service php-fpm start
yum install libmemcached -y
yum install php-pear php-pecl-memcache -y
```
* php配置：
```sh
vi /etc/php.ini
short_open_tag = On  #启用短名
expose_php = Off #不显示PHP版本
max_input_vars = 3000 #POST字段个数
service php-fpm restart
```
* php升级：
```sh
vi /etc/yum.repos.d/remi.repo
[remi]
enabled=1
[php55]
enabled=1
```
* opcached配置：
```sh
方法一：
vi /etc/php.d/opcached.ini
方法二：
vi /etc/php.ini
zend_extension = opcached.so
或
zend_extension = /usr/lib64/php/modules/opcache.so
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4096
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.enable=1
opcache.enable_cli=1
opcache.save_comments=0
```
* memcached配置
```
vi /etc/php.d/memcached.ini

```
## svn client安装：
```sh
yum install -y subversion
svn checkout url
```

## memcached安装：
```sh
yum install memcached -y
chkconfig memcached on
service memcached start
telnet 127.0.0.1 11211
```

## redis安装与配置
* redis安装：
```sh
yum install redis -y
service redis restart
redis-server /etc/redis.conf
redis-cli
redis-cli -h 192.168.1.229 info
redis-cli -h 192.168.1.229 config set slave-read-only no
```
* redis配置：
```sh
vi etc/redis.conf
daemonize yes
slaveof 192.168.1.119 6379 表示设置本redis为slave，并且设置redis的master为192.168.1.119 6379
slave库执行>SLAVEOF NO ONE 避免主库没更新而丢数据。
```
redis升级2.8.17
```sh
wget http://download.redis.io/releases/redis-2.8.17.tar.gz
tar zxvf redis-2.8.17.tar.gz
cd redis-2.8.17
make
make PREFIX=/usr install
cp /etc/redis.conf /etc/redis.conf.bak
cp redis.conf /etc/
mv /usr/bin/redis-server /usr/sbin/
```

MISCONF Redis is configured to save RDB snapshots, but is currently not able to persist on disk. Commands that may modify the data set are disabled. Please check Redis logs for details about the error.
```sh
redis-cli
config set stop-writes-on-bgsave-error no
```

## ntp ntpd更新系统时间安装与配置
* ntp安装：
```sh
yum install ntp ntpd -y
chkconfig ntpd on
```
* ntp配置：
```sh
ntpdate us.pool.ntp.org
date -R
cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```
* 设置任务计划每天零点同步一次
```sh
crontab –e
0 * * * * /usr/sbin/ntpdate cn.pool.ntp.org ; hwclock -w
```
* 修改系统时间
```sh
date --set '01/20/2015 15:39:00'
hwclock -w
```

## iptraf-ng网络监控工具
```sh
yum install -y iptraf-ng
iptraf-ng
```

## nethogs查询网络带宽占用安装
```sh
yum install nethogs -y
ifconfig -a
nethogs venet0:0
```

## iftop网络带宽安装
```sh
yum install iftop -y
iftop
```

## nmon监控安装与配置
* nmon安装：
```sh
yum install nmon -y
nmon
输入c可显示CPU的信息,“m”对应内存、“n”对应网络,“d”可以查看磁盘信息；“t”可以查看系统的进程信息；“
```
* nmon数据采集：
```sh
nmon –f –t –r test –s 30 –c 10
-f ：按标准格式输出文件名称：<hostname>_YYYYMMDD_HHMM.nmon
-t 输出最耗资源的进程
-s ：每隔n秒抽样一次，这里为30秒
-c ：取出多少个抽样数量，这里为10，即监控=10*30/60=5分钟
test:监控记录的标题
将.nmon文件转化成.csv文件，在当前目录生成对应的.csv文件
sort BOSS1_110810_1438.nmon>BOSS1_110810_1438.csv
将BOSS1_110810_1438.csv文件下载到本地。通过nmon analyser工具（ nmon analyser v33g.xls）转化为excel文件
```

## iptables升级与配置：
* iptables升级1.4.20
```sh
iptables -V
service iptables stop
wget -c http://netfilter.org/projects/iptables/files/iptables-1.4.20.tar.bz2
tar jxf iptables-1.4.20.tar.bz2 && cd iptables-1.4.20
./configure
make && make install
cd /usr/local/sbin
cp iptables /sbin
cp iptables-restore /sbin/
cp iptables-save /sbin/
service iptables start
iptables -V
```
* iptables配置：
```sh
iptables -L 查看防火墙规则
iptables -F 清理防火墙规则
iptables -I INPUT -p tcp --dport 80 -j ACCEPT 开启80端口
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --dport 123 -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -P INPUT DROP
iptables save
iptables -A INPUT -p icmp --icmp-type 8 -s 0/0 -j DROP 禁ping
iptables -D INPUT -p icmp --icmp-type 8 -s 0/0 -j DROP 解禁ping
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
```

## goaccess网站日志分析安装：
```sh
方法一：
yum install goaccess -y
方法二：
$ wget http://tar.goaccess.io/goaccess-0.8.3.tar.gz
$ tar -xzvf goaccess-0.8.3.tar.gz
$ cd goaccess-0.8.3/
$ ./configure --enable-geoip --enable-utf8
$ make
# make install
分析：
goaccess -f /var/log/nginx/access.log
tab切换，s弹小窗口显示详细内容
选择 NCSA Combined Log Format
goaccess -f /var/log/nginx/access.log -a > report.html
goaccess -f /var/log/nginx/access.log -a -o report.html
grep ^123.123.123.123 /var/log/httpd/access_log | goaccess #只统计来自某IP的记录
grep " 403 " /var/log/httpd/access_log | goaccess #只统计来自某IP的记录
grep " 500 " /var/log/nginx/access.log
```

## 磁盘连续读写性能测试
```sh
一、磁盘连续写入测试（268MB）
dd if=/dev/zero of=kwxgd bs=64k count=4k oflag=dsync
二、磁盘连续读取测试（268MB）
echo 3 > /proc/sys/vm/drop_caches #清缓存
dd if=kwxgd of=/dev/zero bs=64k count=4k iflag=direct
方法二：
评估SSD VPS硬盘性能
yum install hdparm -y
hdparm -t /dev/xvda
“/dev/xvda”指的是对应磁盘的驱动号，请执行“fdisk -l”查看
```

## SSH端口修改
```sh
vi /etc/ssh/sshd_config
#port 22
port 26611
PermitRootLogin no 禁用root远程登录
PermitEmptyPasswords no #禁止空密码登录
UseDNS no #关闭DNS查询
service sshd restart
```

## chkconfig命令
```sh
chkconfig --list 列出所有服务
chkconfig --add mysqld [在服务清单中添加mysql服务]
chkconfig mysqld on [设置mysql服务开机启动]
chkconfig mysqld off [设置mysql服务开机启动关闭]
chkconfig --del mysqld [在服务清单中清除mysql服务]
```

## 添加普通用户并进行sudo授权管理
```sh
useradd test
echo "123456" | passwd --stdin test
vi /etc/sudoers
root       ALL=(ALL)       ALL
test       ALL=(ALL)       ALL
```

## rkhunter安全工具安装：
```sh
yum install rkhunter -y
rkhunter -c
```

## 安装mysql-utilities
```sh
http://dev.mysql.com/downloads/utilities/
wget http://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-utilities-1.4.4.zip
unzip mysql-utilities-1.4.4.zip
cd mysql-utilities-1.4.4
python ./setup.py build
sudo python ./setup.py install
```

## 优化
* 查看网络情况：请见网络命令.md
* 删除不必要的系统用户
```sh
awk -F ":" '{print $1}' /etc/passwd
userdel adm
userdel lp
userdel shutdown
userdel halt
userdel uucp
userdel operator
userdel games
userdel gopher
```
* 停止没用的服务
```sh
for sun in `chkconfig --list|grep 3:on|awk '{print $1}'`;do chkconfig --level 3 $sun off;done
for sun in crond rsyslog sshd network mysqld nginx php-fpm;do chkconfig --level 3 $sun on;done
chkconfig --list|grep 3:on
```
* 锁定关键文件系统
```sh
lsattr /etc/passwd
chattr +i /etc/passwd
chattr +i /etc/inittab
chattr +i /etc/group
chattr +i /etc/shadow
chattr +i /etc/gshadow
chattr -i /etc/passwd
使用chattr命令后，为了安全我们需要将其改名 mv /usr/bin/chattr /usr/bin/任意名称
```
* 关闭重启ctl-alt-delete组合键
```sh
vi /etc/init/control-alt-delete.conf
#exec /sbin/shutdown -r now "Control-Alt-Deletepressed" #注释掉
```
* 调整文件描述符大小
```sh
ulimit -n #默认是1024
echo "ulimit -SHn 122880" >> /etc/rc.local #设置开机自动生效
echo 'ulimit -HSn 122880' >> /etc/profile
source /etc/profile
```
* 去除系统相关信息
```sh
echo "Welcome to Server" >/etc/issue
echo "Welcome to Server" >/etc/redhat-release
```
* 内核参数优化
```sh
vi /etc/sysctl.conf
fs.file-max = 122880
fs.nr_open = 122880
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.ip_local_port_range = 1024 65535

net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_max_tw_buckets = 10000
net.ipv4.tcp_max_syn_backlog = 4096

net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.inet.udp.checksum = 1
net.ipv4.conf.default.accept_source_route = 0

net.core.netdev_max_backlog =  262144
net.core.somaxconn = 262144
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_mem = 94500000 915000000 927000000
#net.ipv4.tcp_orphan_retries = 3
sysctl -p
```
* 打开文件数的限制
```sh
ulimit -a 来显示当前的各种用户进程限制
#php
cat /etc/php-fpm.conf | grep rlimit_files
cat /etc/php-fpm.d/www.conf | grep rlimit_files
vi /etc/php-fpm.conf #vi cat /etc/php-fpm.d/www.conf
rlimit_files = 122880
#limits
vi /etc/security/limits.conf 加上：
* soft nproc 122880
* hard nproc 122880
* soft nofile 122880
* hard nofile 122880
#nginx
vi /etc/nginx/nginx.conf
worker_rlimit_nofile 122880;
#profile
echo "ulimit -SHn 122880" >> /etc/rc.local
echo 'ulimit -HSn 122880' >> /etc/profile
source /etc/profile
#limits
要使 /etc/security/limits.conf 文件配置生效，必须要确保 pam_limits.so 文件被加入到启动文件中
修改/etc/pam.d/login文件，在文件中添加如下行：
session required /lib/security/pam_limits.so
如果是64bit系统的话，应该为
session required /lib64/security/pam_limits.so
```
* 删除不必要的软件包
```sh
yum remove Deployment_Guide-en-US finger cups-libs cups ypbind
yum remove bluez-libs desktop-file-utils ppp rp-pppoe wireless-tools irda-utils
yum remove sendmail* samba* talk-server finger-server bind* xinetd
yum remove nfs-utils nfs-utils-lib rdate fetchmail eject ksh mkbootdisk mtools
yum remove syslinux tcsh startup-notification talk apmd rmt dump setserial portmap yp-tools
yum groupremove "Mail Server" "Games and Entertainment" "X Window System" "X Software Development"
yum groupremove "Development Libraries" "Dialup Networking Support"
yum groupremove "Games and Entertainment" "Sound and Video" "Graphics" "Editors"
yum groupremove "Text-based Internet" "GNOME Desktop Environment" "GNOME Software Development"
```
* 文件系统崩溃修复
```sh
fsck -y /dev/sda1
```
* MySQL性能建议者：mysqltuner.pl
```sh
wget http://mysqltuner.pl/mysqltuner.pl
chmod +x mysqltuner.pl
```
* mysql
```sh
默认profile是关闭的，通过profiling参数控制，为session级
开启：SET profiling=1
关闭：set profiling=0
查询：select @@profiling
show profiles;
show profile cpu,block io for query 2;
SELECT STATE, FORMAT(DURATION, 6) AS DURATION FROM INFORMATION_SCHEMA.PROFILING WHERE QUERY_ID = 2 ORDER BY DURATION DESC;
```
* nginx 优化
```nginx
grep processor /proc/cpuinfo | wc -l
vi /etc/nginx/nginx.conf
worker_processes 4; #上面得到的
worker_rlimit_nofile 122880;
events {
	worker_connections 102400;
	# use [ kqueue | rtsig | epoll | /dev/poll | select | poll ] ;
	use epoll;
}
max_clients = worker_processes*worker_connections;
http {
	sendfile on;
	tcp_nodelay on;
	server_tokens off; #隐藏Nginx版本号
	keepalive_timeout 60; #keepalive超时时间。
	client_body_timeout 10;
	client_header_timeout 10;
	send_timeout 60;
	client_header_buffer_size 128k; #getconf PAGESIZE取得
	large_client_header_buffers 4 128k;
	client_max_body_size 8m; #上传文件大小

	open_file_cache max= 122880 inactive=20s; #20s过期
	open_file_cache_valid 30s; #这个是指多长时间检查一次缓存的有效信息。
	open_file_cache_min_uses 1; #open_file_cache指令中的inactive参数时间内文件的最少使用次数，如果超过这个数字，文件描述符一直是在缓存中打开的，如上例，如果有一个文件在inactive时间内一次没被使用，它将被移除。

	fastcgi_cache_path /usr/local/nginx/fastcgi_cache levels=1:2 keys_zone=TEST:10m inactive=5m;
	fastcgi_connect_timeout 300;
	fastcgi_send_timeout 300;
	fastcgi_read_timeout 300;
	fastcgi_buffer_size 128k;
	fastcgi_buffers 4 128k;
	fastcgi_busy_buffers_size 128k;
	fastcgi_temp_file_write_size 128k;
	fastcgi_cache TEST;
	fastcgi_cache_valid 200 302 1h;
	fastcgi_cache_valid 301 1d;
	fastcgi_cache_valid any 1m;
	fastcgi_cache_min_uses 1;
	fastcgi_cache_use_stale error timeout invalid_header http_500;
}
server {
	listen  119.81.27.72:443 ssl;
	ssl_certificate      /home/ssl/cert.crt;
	ssl_certificate_key  /home/ssl/cert.key;
	ssl_ciphers RC4:HIGH:!aNULL:!MD5;
	ssl_prefer_server_ciphers   on;

	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

	gzip on;
	gzip_min_length  1k;
	gzip_buffers     4 16k;
	gzip_http_version 1.0;
	gzip_comp_level 2;
	gzip_types text/plain application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;
	gzip_vary off;
	gzip_disable "MSIE [1-6]\.";

	client_body_buffer_size 128k;
	large_client_header_buffers 4 128k;
	client_max_body_size 8m; #上传文件大小限制

	proxy_buffer_size 128k;
	proxy_buffers   4 256k;
	proxy_busy_buffers_size 256k;

	location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml)$ {
		access_log        off;
		log_not_found     off;
		expires           360d;
	}
	location ~ /\. {
		access_log off;
		log_not_found off;
		deny all;
	}
}
```
* php 优化
```sh
ps --no-headers -o "rss,cmd" -C php-fpm | awk '{ sum+=$1 } END { printf ("%d%s\n", sum/NR/1024,"M") }' #php进程占内存大小
vi /etc/php-fpm.d/www.conf
pm.max_children = (total RAM - RAM used by other process) / (average amount of RAM used by a PHP process)
vi cat /etc/php-fpm.d/www.conf
pm = dynamic
pm.max_children = 24
pm.start_servers = 16
pm.min_spare_servers = 12
pm.max_spare_servers = 24
pm.max_requests = 200

pm.max_children = Mem/2/20     =》1024/2/20= 25
pm.start_servers = Mem/2/30     =》 1024/2/30=17
pm.min_spare_servers = Mem/2/40   =》 1024/2/40= 12
pm.max_spare_servers = Mem/2/20  =》 1024/2/20=25
pm.start_servers = min_spare_servers + (max_spare_servers - min_spare_servers) / 2

ps -ylC php-fpm —sort:rss
#rss avg 15M
pm.max_children = 分配给ＰＨＰ10G/每个进程15Ｍ
pm.min_spare_servers = CPUcore * 2
pm.max_spare_servers = CPUcore * 4
pm.start_servers = pm.max_spare_servers /2
pm.max_requests = 500

pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35
pm.max_requests = 500

pm.max_children = 160
pm.start_servers = 130
pm.min_spare_servers = 115
pm.max_spare_servers = 145
pm.max_requests = 5000

pm.max_children = 120
pm.start_servers = 60
pm.min_spare_servers = 30
pm.max_spare_servers = 90
pm.max_requests = 500

pm.max_children = 60
pm.start_servers = 30
pm.min_spare_servers = 15
pm.max_spare_servers = 45
pm.max_requests = 500

物理cpu个数:cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l
cpu核数:cat /proc/cpuinfo | grep "cpu cores" | uniq
逻辑cpu个数(线程数):cat /proc/cpuinfo | grep "cpu cores" | wc -l
单个物理cpu的逻辑cpu个数(线程数):cat /proc/cpuinfo | grep "siblings" | uniq
```
* php部分目录取消执行权限
```sh
nginx:
location ~ ^/upload/.*\.(php|php5)$ {
	deny all;
}
apache:
<Directory “/var/www/blog/data/”>
<FilesMatch “.(php|asp|jsp)$”>
Order allow,deny
Deny from all
</FilesMatch>
</Directory>
```
###php7
```
yum remove php*
yum install php70-php php70-php-pear php70-php-bcmath php70-php-pecl-jsond-devel php70-php-mysqlnd php70-php-gd php70-php-common php70-php-fpm php70-php-intl php70-php-cli php70-php php70-php-xml php70-php-opcache php70-php-pecl-apcu php70-php-pecl-jsond php70-php-pdo php70-php-gmp php70-php-process php70-php-pecl-imagick php70-php-devel php70-php-mbstring php70-php-memcache -y
ln -s /usr/bin/php70 /usr/bin/php
cp /etc/php.ini.rpmsave /etc/php.ini
service php-fpm stop
service php70-php-fpm start
```
###shadowsocks
```
yum install -y m2crypto python-setuptools
easy_install pip
pip install shadowsocks
pip install -U shadowsocks #更新
pip uninstall shadowsocks #卸载
vi /etc/shadowsocks.json
{
    "server":"0.0.0.0",
    "server_port":7070,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"password",
    "timeout":600,
    "method":"aes-128-cfb"
}
多账号
{
    "server":"服务器ip地址",
    "local_address":"127.0.0.1",
    "local_port":1080,
    "port_password":{
        "9011":"1234567890",
        "9012":"4561237980",
        "9013":"3216549870",
        "9014":"0987654321"
    },
    "timeout":300,
    "method":"rc4-md5",
    "fast_open": false
}
#fast_open：true 或 false。如果你的服务器 Linux 内核在3.7+，可以开启 fast_open 以降低延迟。开启方法：echo 3 > /proc/sys/net/ipv4/tcp_fastopen
ssserver -c /etc/shadowsocks.json -d start
ssserver -c /etc/shadowsocks.json -d stop
vi /etc/sysconfig/iptables
-A INPUT -m state --state NEW -m tcp -p tcp --dport 8989 -j ACCEPT
service iptables restart
iphone使用SuperWingy MAC使用ShadowsocksX.app
```
###Outline
```
#安装docker
yum install docker -y
systemctl restart docker.service
systemctl status docker.service
systemctl enable docker.service
Failed at step LIMITS spawning /usr/bin/dockerd-current: Operation not permitted
rm -rf /var/lib/docker
systemctl daemon-reload
systemctl restart docker.service
#部署 Outline
wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh | bash
会生成一串 "apiUrl","cerSha256" 的 json 配置文件
#下载 Outline Manager
https://github.com/Jigsaw-Code/outline-releases/tree/master/manager
复制输入上面生成的“apiUrl”，“certSha256”即可开始使用
选择 "GET CONNECTED" 生成 ss 链接自己本地使用
#下载 Outline
iphone: https://itunes.apple.com/us/app/outline-app/id1356177741
macos: https://itunes.apple.com/us/app/outline-app/id1356178125
```
###V2RAY
```
bash <(curl -L -s https://install.direct/go.sh)
vi /etc/v2ray/config.json
"port": 51888, => 7070
"method": "aes-256-gcm" => "aes-128-cfb"
"password": "123456"
service v2ray restart
https://github.com/yanue/V2rayU/releases
https://github.com/v2ray/v2ray-core/releases
或者
docker pull v2ray/official
mkdir /etc/v2ray/
http://www.ofmonkey.com/transfer/guid
生成配置文件：https://intmainreturn0.com/v2ray-config-gen/
vi /etc/v2ray/config.json
{
	"log": {
		"access": "/var/log/v2ray/access.log",
		"error": "/var/log/v2ray/error.log",
		"loglevel": "warning"
	},
	"inbound": {
		"port": 80,
		"protocol": "vmess",
		"settings": {
			"clients": [{
				"id": "01947a19-d50f-40ad-a3e0-7d25081f82a7",
				"level": 1,
				"alterId": 100
			}]
		},
		"streamSettings": {
			"network": "tcp",
			"tcpSettings": {
				"header": {
					"request": {
						"path": [
							"/"
						],
						"version": "1.1",
						"method": "GET",
						"headers": {
							"Host": "www.baidu.com",
							"Connection": [
								"keep-alive"
							],
							"Accept-Encoding": [
								"gzip, deflate"
							],
							"Pragma": "no-cache",
							"User-Agent": [
								"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.75 Safari/537.36",
								"Mozilla/5.0 (iPhone; CPU iPhone OS 10_0_2 like Mac OS X) AppleWebKit/601.1 (KHTML, like Gecko) CriOS/53.0.2785.109 Mobile/14A456 Safari/601.1.46"
							]
						}
					},
					"type": "http",
					"response": {
						"status": "200",
						"headers": {
							"Transfer-Encoding": [
								"chunked"
							],
							"Connection": [
								"keep-alive"
							],
							"Content-Type": [
								"application/octet-stream",
								"video/mpeg"
							],
							"Pragma": "no-cache"
						},
						"reason": "OK",
						"version": "1.1"
					}
				},
				"connectionReuse": true
			}
		}
	},
	"outbound": {
		"protocol": "freedom",
		"settings": {}
	},
	"outboundDetour": [{
		"protocol": "blackhole",
		"settings": {},
		"tag": "blocked"
	}],
	"routing": {
		"strategy": "rules",
		"settings": {
			"rules": [{
				"type": "field",
				"ip": [
					"0.0.0.0/8",
					"10.0.0.0/8",
					"100.64.0.0/10",
					"127.0.0.0/8",
					"169.254.0.0/16",
					"172.16.0.0/12",
					"192.0.0.0/24",
					"192.0.2.0/24",
					"192.168.0.0/16",
					"198.18.0.0/15",
					"198.51.100.0/24",
					"203.0.113.0/24",
					"::1/128",
					"fc00::/7",
					"fe80::/10"
				],
				"outboundTag": "blocked"
			}]
		}
	}
}
docker run -d --name v2ray -v /etc/v2ray:/etc/v2ray -p 8888:80 v2ray/official v2ray -config=/etc/v2ray/config.json
docker container start v2ray
docker container stop v2ray
docker container restart v2ray
docker container logs v2ray
更新配置后，需要重新部署容器，命令如下
docker container stop v2ray
docker container rm v2ray
docker run -d --name v2ray -v /etc/v2ray:/etc/v2ray -p 8888:80 v2ray/official v2ray -config=/etc/v2ray/config.json
https://github.com/2dust/v2rayNG/releases/download/1.2.6/v2rayNG_1.2.6_armeabi-v7a.apk
https://github.com/yanue/V2rayU/releases/download/2.1.0/V2rayU.dmg
https://github.com/Cenmrev/V2RayX/releases/download/v1.5.1/V2RayX.app.zip
https://tlanyan.me/v2ray-clients-download/
https://github.com/v2ray/v2ray-core/releases

https://github.com/shadowsocks/ShadowsocksX-NG/releases
https://github.com/shadowsocksr-backup/ShadowsocksX-NG/releases
```


