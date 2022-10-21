centos8替代品
https://mirrors.almalinux.org/isos.html
https://download.rockylinux.org/pub/rocky/
https://atl.mirrors.knownhost.com/almalinux/


git clone --depth=1 https://github.com/wg/wrk.git wrk
cd wrk
make


centos7
cd /home
wget -c https://www.johnvansickle.com/ffmpeg/old-releases/ffmpeg-4.4-amd64-static.tar.xz
xz -d ffmpeg-4.4-amd64-static.tar.xz && tar xvf ffmpeg-4.4-amd64-static.tar
ln -s /home/ffmpeg-4.4-amd64-static/ffmpeg /usr/local/bin/ffmpeg
ln -s /home/ffmpeg-4.4-amd64-static/ffprobe /usr/local/bin/ffprobe

yum install libreoffice-pdfimport libreoffice-langpack-zh-Hans libreoffice-langpack-zh-Hant libreoffice-ure libreoffice-ure-common libreoffice-base libreoffice-data libreoffice-impress libreoffice-x11 libreofficekit libreoffice-writer -y

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
lsblk
dmidecode
cat /proc/interrupts
lspci：用于 PCI 设备
lsusb：用于 USB 设备
lspcmcia : 用于 PCMCIA 卡

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

yum install chromium -y


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

增加交换分区
swapon --show
创建
# if: 输入文件；of: 输出文件；bs: 块大小；count: 块数
dd if=/dev/zero of=/swapfile bs=1024 count=1048572
chmod 600 /swapfile
使用mkswap命令将文件标记为交换分区。
mkswap /swapfile
启用交换分区
swapon /swapfile
键入以下命令验证交换分区是否可用：
swapon --show
free -h

vi /etc/fstab
/swapfile swap swap defaults 0 0

cat /proc/sys/vm/swappiness
vi /etc/sysctl.conf
vm.swappiness=10
vm.vfs_cache_pressure=50

sysctl -p

删除交换分区是以上步骤的逆操作，首先将对应的分区条目从/etc/fstab文件中删除，再通过以下命令卸载交换分区：
swapoff -v /swapfile
最后删除交换文件：
rm /swapfile


golang 1.18
wget https://studygolang.com/dl/golang/go1.18.3.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz
ll /usr/local/go/bin
vi /etc/profile
export PATH=$PATH:/usr/local/go/bin
source /etc/profile
go version

no such tool "compile"
go env | grep GOTOOLDIR
vi /etc/profile
export GOROOT=/usr/local/go
source /etc/profile

扩容磁盘空间
fdisk -l
fdisk /dev/sda
n
p
w

fdisk /dev/sda
t
3
8e
w

partprobe
mkfs -t xfs /dev/sda3
mkfs.xfs /dev/sda3 -f
mount /dev/sda3 /opt
mount /dev/sda3 /data
df -TH
findmnt -A

umount /opt
mount /dev/sda3 /51learning

vi /etc/fstab
/dev/sda3 /51learning                       xfs     defaults        0 0
/dev/sda3 /data                       xfs     defaults        0 0

使用 UUID 来进行永久挂载
blkid
vi /etc/fstab
UUID=********** /51learning xfs defaults 0 0

在 Linux 中，外围设备都位于 /dev 挂载点，内核通过以下的方式理解硬盘：

/dev/hdX[a-z]: IDE 硬盘被命名为 hdX
/dev/sdX[a-z]: SCSI 硬盘被命名为 sdX
/dev/xdX[a-z]: XT 硬盘被命名为 xdX
/dev/vdX[a-z]: 虚拟硬盘被命名为 vdX
/dev/fdN: 软盘被命名为 fdN
/dev/scdN or /dev/srN: CD-ROM 被命名为 /dev/scdN 或 /dev/srN

l
0  Empty           24  NEC DOS         81  Minix / old Lin bf  Solaris        
 1  FAT12           27  Hidden NTFS Win 82  Linux swap / So c1  DRDOS/sec (FAT-
 2  XENIX root      39  Plan 9          83  Linux           c4  DRDOS/sec (FAT-
 3  XENIX usr       3c  PartitionMagic  84  OS/2 hidden or  c6  DRDOS/sec (FAT-
 4  FAT16 <32M      40  Venix 80286     85  Linux extended  c7  Syrinx         
 5  Extended        41  PPC PReP Boot   86  NTFS volume set da  Non-FS data    
 6  FAT16           42  SFS             87  NTFS volume set db  CP/M / CTOS / .
 7  HPFS/NTFS/exFAT 4d  QNX4.x          88  Linux plaintext de  Dell Utility   
 8  AIX             4e  QNX4.x 2nd part 8e  Linux LVM       df  BootIt         
 9  AIX bootable    4f  QNX4.x 3rd part 93  Amoeba          e1  DOS access     
 a  OS/2 Boot Manag 50  OnTrack DM      94  Amoeba BBT      e3  DOS R/O        
 b  W95 FAT32       51  OnTrack DM6 Aux 9f  BSD/OS          e4  SpeedStor      
 c  W95 FAT32 (LBA) 52  CP/M            a0  IBM Thinkpad hi ea  Rufus alignment
 e  W95 FAT16 (LBA) 53  OnTrack DM6 Aux a5  FreeBSD         eb  BeOS fs        
 f  W95 Ext'd (LBA) 54  OnTrackDM6      a6  OpenBSD         ee  GPT            
10  OPUS            55  EZ-Drive        a7  NeXTSTEP        ef  EFI (FAT-12/16/
11  Hidden FAT12    56  Golden Bow      a8  Darwin UFS      f0  Linux/PA-RISC b
12  Compaq diagnost 5c  Priam Edisk     a9  NetBSD          f1  SpeedStor      
14  Hidden FAT16 <3 61  SpeedStor       ab  Darwin boot     f4  SpeedStor      
16  Hidden FAT16    63  GNU HURD or Sys af  HFS / HFS+      f2  DOS secondary  
17  Hidden HPFS/NTF 64  Novell Netware  b7  BSDI fs         fb  VMware VMFS    
18  AST SmartSleep  65  Novell Netware  b8  BSDI swap       fc  VMware VMKCORE 
1b  Hidden W95 FAT3 70  DiskSecure Mult bb  Boot Wizard hid fd  Linux raid auto
1c  Hidden W95 FAT3 75  PC/IX           bc  Acronis FAT32 L fe  LANstep        
1e  Hidden W95 FAT1 80  Old Minix       be  Solaris boot    ff  BBT

阿里云配置
vi /etc/sysctl.conf
fs.file-max = 1048576
fs.nr_open = 1048576

vm.swappiness = 0
kernel.sysrq = 1

net.ipv4.neigh.default.gc_stale_time = 120

# see details in https://help.aliyun.com/knowledge_detail/39428.html
net.ipv4.conf.all.rp_filter = 0
net.ipv4.conf.default.rp_filter = 0
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_announce = 2

# see details in https://help.aliyun.com/knowledge_detail/41334.html
net.ipv4.tcp_max_tw_buckets = 262144
net.ipv4.tcp_syncookies = 1

# tcp_max_syn_backlog will only take effect when net.ipv4.tcp_syncookies == 0
# net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_slow_start_after_idle = 0

其他配置
net.core.somaxconn = 65536
/sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
