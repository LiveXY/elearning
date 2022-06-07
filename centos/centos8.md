centos8替代品
https://download.rockylinux.org/pub/rocky/
https://atl.mirrors.knownhost.com/almalinux/

centos8

useradd test
passwd -S test #显示账号密码相关信息
passwd -d test #取消密码
passwd -l test #锁定账号
passwd -u test #解锁账号
chage -l test #查看账号有效期
chage -I 5 test #密码过期后5天，密码自动失效
chage -M 60 -m 7 -W 7 test #60天后密码过期，至少7天后才能修改密码，密码过期前7天开始收到告警信息
chage -d 0 test #强制首次登陆后修改密码
usermod -s /usr/sbin/nologin test #账号不可登陆
usermod -s /bin/bash test #账号可登陆


hostnamectl
cat /etc/redhat-release 或 rpm -q centos-release #查看系统版本
uname -a
cat /proc/cpuinfo
cat /proc/meminfo
cat /proc/version
cat /etc/issue
dmesg | grep Linux
dmesg | grep -i eth
lscpu
dmidecode
cat /proc/interrupts

麒麟
nkvers
cat /etc/kylin-release
cat /etc/.productinfo

dnf upgrade

dnf install wget git -y

rpm -qa | grep remi
rpm -e remi-release-8.5-2.el8.remi.noarch
dnf install http://mirrors.aliyun.com/remi/enterprise/remi-release-8.rpm -y

dnf module list redis
dnf module reset redis
dnf module enable redis:6 -y
dnf install redis -y
systemctl enable redis
systemctl restart redis

dnf install mariadb mariadb-server -y

rpm -qa | grep epel
rpm -e epel-release-8-13.el8.noarch
dnf install https://mirrors.aliyun.com/epel/epel-release-latest-8.noarch.rpm -y

Repository epel is listed more than once in the configuration
grep '\[epel\]' /etc/yum.repos.d/*

dnf module list nginx
dnf module reset nginx
dnf module enable nginx:1.18 -y
dnf module enable nginx:1.20 -y
dnf install nginx -y
systemctl enable nginx
systemctl restart nginx

rpm -qa | grep rpmfusion
rpm -e rpmfusion-free-release-8-0.1.noarch
dnf install http://mirrors.aliyun.com/rpmfusion/free/el/rpmfusion-free-release-8.noarch.rpm -y

dnf upgrade --refresh -y
yum makecache && yum repolist
dnf config-manager --set-enabled PowerTools

rpm -e SDL2-2.0.10-2.el8.x86_64
dnf install https://mirrors.aliyun.com/centos/8/PowerTools/x86_64/os/Packages/SDL2-2.0.10-2.el8.x86_64.rpm -y

dnf install ffmpeg -y
ffmpeg -version

dnf install libreoffice-pdfimport libreoffice-langpack-zh-Hans libreoffice-langpack-zh-Hant libreoffice-ure libreoffice-ure-common libreoffice-base libreoffice-data libreoffice-impress libreoffice-x11 libreofficekit libreoffice-writer -y


yum -y install wget
wget https://www.libreoffice.org/donate/dl/rpm-x86_64/7.2.0/zh-CN/LibreOffice_7.2.0_Linux_x86-64_rpm.tar.gz
tar -xvf LibreOffice_7.2.0_Linux_x86-64_rpm.tar.gz
yum localinstall *.rpm


百度云盘 TO 阿里云盘
https://github.com/yaronzz/BaiduYunToAliYun

百度云盘
https://github.com/houtianze/bypy
pip3 install screen
screen -S bypy
pip3 install bypy
bypy info

bypy list
bypy downfile GeoSetter.zip
bypy downdir clean_data
bypy upload 本地地址  网盘地址
bypy -c #退出登录

screen -ls # 查看当前所有终端
screen -r bypy # 回到之前的终端
screen -X -S bypy quit # 删除一个终端

cd /data/course
bypy syncdown -v #从百度云同步到当前目录
bypy syncup
bypy upload
bypy compare

调用aria2下载
echo 'export DOWNLOADER_ARGUMENTS="-c -k10M -x16 -s16 --file-allocation=none"' > /etc/profile.d/bypy.sh
chmod +x /etc/profile.d/bypy.sh
source /etc/profile.d/bypy.sh

echo $DOWNLOADER_ARGUMENTS

bypy --downloader aria2 download 远程文件名 本地路径
bypy --downloader aria2 download 远程目录 本地路径
bypy --downloader aria2 download example.zip folder
bypy --downloader aria2 download 妹子 folder

nano ~/.bashrc
alias dw='bypy --downloader aria2 download '
dw example.zip folder

先安装epel源
dnf install aria2
aria2c http://example.org/file.iso
aria2c http://a/f.iso ftp://b/f.iso

cd /data/qihui
screen -S qihui
aria2c --max-concurrent-downloads=2 --input-file=uris.txt
aria2c -c -Z -V -x2 -d /data/qihui/ -i uris.txt --deferred-input=true --check-certificate=false

vi uris.txt
http://example.org/a.pdf
	out=a.pdf
	header=Cookie:a=b
http://example.org/b.pdf
	out=b.pdf

nginx.service: Failed to adjust resource limit RLIMIT_NOFILE: Operation not permitted
nginx.service: Failed at step LIMITS spawning /usr/bin/rm: Operation not permitted
systemctl daemon-reload


两个最受欢迎和占有CentOS市场份额最高的发行版是Rocky Linux和Alma Linux

Firewalld 查看所有区域
ls -l /usr/lib/firewalld/zones/
查看 public 区域
cat /usr/lib/firewalld/zones/public.xml
预定义区域
block：所有传入的网络连接都被拒绝。只可以从系统内部发起网络连接。
dmz：经典的非军事区 (DMZ) 区域，提供对 LAN 的有限访问，并且只允许指定的传入端口。
drop：丢弃所有传入的网络连接，只允许传出的网络连接。
external：对于路由器类型的连接很有用。您还需要 LAN 和 WAN 接口才能使伪装 NAT 正常工作。
home：适用于您信任其他计算机的 LAN 中的家用计算机，例如笔记本电脑和台式机。仅允许指定的 TCP/IP 端口。
internal：用于内部网络，当您非常信任 LAN 上的其他服务器或计算机时适用。
public：您不信任网络上的任何其他计算机和服务器。您只允许所需的端口和服务。对于托管在您所在地的云服务器或服务器，请始终使用公共区域。
trusted：接受所有网络连接。我不建议将此区域用于连接到 WAN 的专用服务器或虚拟机。
work：用于您比较信任的同事和其他服务器的工作场所。
所有区域
firewall-cmd --get-zones
firewall-cmd --get-default-zone
查看您的网络接口名称
ip link show
nmcli device status
firewall-cmd --get-active-zones

firewall-cmd --list-all
firewall-cmd --list-all --zone=public

firewall-cmd --remove-service=cockpit --permanent
firewall-cmd --remove-service=dhcpv6-client --permanent
firewall-cmd --reload
firewall-cmd --list-services
firewall-cmd --list-services --zone=public
firewall-cmd --list-services --zone=home
firewall-cmd --get-services

firewall-cmd --state
firewall-cmd --zone=public --add-service=http --permanent #80
firewall-cmd --zone=public --add-service=https --permanent #443
firewall-cmd --zone=public --add-service=dns --permanent #53
firewall-cmd --zone=public --remove-service=vnc-server --permanent #5900-5903
firewall-cmd --zone=public --add-port=9009/tcp --permanent
firewall-cmd --zone=internal --list-ports
firewall-cmd --reload

firewall-cmd --zone=public --remove-port=23/tcp --permanent
443 TCP 端口转发到 8080
firewall-cmd --zone=public --add-forward-port=port=80:proto=tcp:toport=8080 --permanent
firewall-cmd --zone=public --remove-forward-port=port=80:proto=tcp:toport=8080
将流量（端口 443）转发到托管在 192.168.2.42 的 lxd 服务器/容器的 443 端口，请开启伪装
firewall-cmd --zone=public --add-masquerade
firewall-cmd --zone=public --add-forward-port=port=443:proto=tcp:toport=443:toaddr=192.168.2.42 --permanent
firewall-cmd --zone=public --remove-masquerade
firewall-cmd --zone=public --remove-forward-port=port=443:proto=tcp:toport=443:toaddr=192.168.2.42 --permanent

firewall-cmd --zone=public --list-all --permanent
只想允许从 10.8.0.8 IP 地址访问 SSH 端口 22
firewall-cmd --permanent --zone=public --add-rich-rule 'rule family="ipv4" source address="10.8.0.8" port port=22 protocol=tcp accept'
firewall-cmd --list-rich-rules --permanent
允许 192.168.1.0/24 子网访问 tcp 端口 11211
firewall-cmd --permanent --zone=public --add-rich-rule='
rule family="ipv4"
source address="192.168.1.0/24"
port protocol="tcp" port="11211" accept'
firewall-cmd --list-rich-rules --permanent
firewall-cmd --remove-rich-rule 'rule family="ipv4" source address="10.8.0.8" port port=22 protocol=tcp accept' --permanent
firewall-cmd --remove-rich-rule 'rule family="ipv4" source address="192.168.1.0/24" port port="11211" protocol="tcp" accept' --permanent


