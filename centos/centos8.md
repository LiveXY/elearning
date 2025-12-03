centos8替代品
https://mirrors.almalinux.org/isos.html
https://download.rockylinux.org/pub/rocky/
https://atl.mirrors.knownhost.com/almalinux/


jenkins 太占内存
vim /etc/sysconfig/jenkins
JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true"
修改为
JENKINS_JAVA_OPTIONS="-Djava.awt.headless=true -Xms512m -Xmx1024m -XX:MaxNewSize=512m -XX:MaxPermSize=512m"
ps aux | grep java
vi /etc/systemd/system/multi-user.target.wants/jenkins.service
Environment="JAVA_OPTS=-Djava.awt.headless=true"
修改为
Environment="JAVA_OPTS=-Djava.awt.headless=true -Xms512m -Xmx1024m -XX:MaxNewSize=512m"
systemctl daemon-reload
systemctl restart jenkins

LINUX 扩容大于2TB盘, 挂载10TB磁盘
lsblk -f
fdisk -l
parted /dev/sdc
mklabel gpt
unit TB
mkpart primary 0.00TB 11.00TB
print
quit
Information: You may need to update /etc/fstab.
mkfs.ext4 /dev/sdc1
挂载
mkdir /data2
mount /dev/sdc1 /data2
df -hT

curl -sSL https://get.docker.com/ | sh

echo 3 > /proc/sys/vm/drop_caches

git clone --depth=1 https://github.com/wg/wrk.git wrk
cd wrk
make

yum install chromium -y
yum -y install fontconfig ttmkfdir mkfontscale wqy-microhei-fonts
fc-list
fc-list :lang=zh

自己上传字体
mkdir -p /usr/share/fonts/chinese
chmod -R 755 /usr/share/fonts/chinese
cd  /usr/share/fonts/chinese && mkfontscale
fc-list :lang=zh

centos7
cd /home
wget -c https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
xz -d ffmpeg-release-amd64-static.tar.xz && tar xvf ffmpeg-release-amd64-static.tar
ln -s /root/ffmpeg-6.0-amd64-static/ffmpeg /usr/local/bin/ffmpeg
ln -s /root/ffmpeg-6.0-amd64-static/ffprobe /usr/local/bin/ffprobe
mv /root/ffmpeg-6.0-amd64-static/ffmpeg /usr/local/bin/ffmpeg
mv /root/ffmpeg-6.0-amd64-static/ffprobe /usr/local/bin/ffprobe

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

多实例
libreoffice -env:UserInstallation=file:///tmp/delete_me_#{timestamp} \
            --headless \
            --convert-to pdf \
            --outdir /tmp \
            /path/to/my_file.doc

soffice --headless --invisible --nocrashreport --norestart --nolockcheck --nodefault --nofirststartwizard --nologo --norestore --accept='socket,host=localhost,port=2002,tcpNoDelay=1;urp;StarOffice.ComponentContext'
soffice --headless --invisible --nocrashreport --norestart --nolockcheck --nodefault --nofirststartwizard --nologo --norestore -env:SingleAppInstance=false -env:UserInstallation=file:///tmp/libreoffice2002 --accept="socket,host=localhost,port=2002,tcpNoDelay=1;urp;StarOffice.ServiceManager" --headless --norestore

nohup soffice --headless --invisible --nocrashreport --norestart --nolockcheck --nodefault --nofirststartwizard --nologo --norestore -env:SingleAppInstance=false -env:UserInstallation=file:///tmp/libreoffice2002 --accept="socket,host=localhost,port=2002,tcpNoDelay=1;urp;StarOffice.ServiceManager" --headless --norestore 1>soffice2001.log 2>&1 &

vi /lib/systemd/system/libreoffice@.service
# headless soffice instance
[Unit]
Description=Control headless soffice instance %i
After=network.target

[Service]
Type=simple
ExecStart=/usr/lib64/libreoffice/program/soffice.bin -env:SingleAppInstance=false -env:UserInstallation=file:///tmp/LibO_Process%i --accept=socket,host=localhost,port=%i;urp; --headless --norestore
Nice=5

[Install]
WantedBy=multi-user.target

sudo systemctl start libreoffice@8101.service
sudo systemctl start libreoffice@8102.service
sudo systemctl start libreoffice@8103.service

yum -y install wget
wget https://www.libreoffice.org/donate/dl/rpm-x86_64/7.2.0/zh-CN/LibreOffice_7.2.0_Linux_x86-64_rpm.tar.gz
tar -xvf LibreOffice_7.2.0_Linux_x86-64_rpm.tar.gz
yum localinstall *.rpm

wget https://mirrors.ustc.edu.cn/tdf/libreoffice/stable/7.5.2/rpm/x86_64/LibreOffice_7.5.2_Linux_x86-64_rpm.tar.gz
tar -xvf LibreOffice_7.5.2_Linux_x86-64_rpm.tar.gz
wget https://mirrors.ustc.edu.cn/tdf/libreoffice/stable/7.5.2/rpm/x86_64/LibreOffice_7.5.2_Linux_x86-64_rpm_langpack_zh-CN.tar.gz
tar -xvf LibreOffice_7.5.2_Linux_x86-64_rpm_langpack_zh-CN.tar.gz
mv LibreOffice_7.5.2.2_Linux_x86-64_rpm_langpack_zh-CN/RPMS/* LibreOffice_7.5.2.2_Linux_x86-64_rpm/RPMS/
yum localinstall ./LibreOffice_7.5.2.2_Linux_x86-64_rpm/RPMS/*.rpm

rm -rf /usr/bin/soffice
ln -s /usr/bin/libreoffice7.5 /usr/bin/soffice
soffice --version

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

3001转发到192.168.0.59:3306
firewall-cmd --zone=public --add-forward-port=port=3389:proto=tcp:toport=3306:toaddr=192.168.0.59 --permanent
firewall-cmd --zone=public --add-port=22/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=3389/tcp --permanent
firewall-cmd --reload
firewall-cmd --zone=public --remove-forward-port=port=3389:proto=tcp:toport=3306:toaddr=192.168.0.59 --permanent

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


假设想让进程可以打开100万个文件描述符，这里用修改conf文件的方式给出一个建议。如果日后工作里有类似的需求可以作为参考。
vim /etc/sysctl.conf
fs.file-max=1100000 // 系统级别设置成110万，多留点buffer
fs.nr_open=1100000 // 进程级别也设置成110万，因为要保证比 hard nofile大
使上面的配置生效sysctl -p
vim /etc/security/limits.conf
// 用户进程级别都设置成100完
soft nofile 1000000
hard nofile 1000000

限制网速
apt install -y wondersharper
wondershaper -a enp0s8 -d 1024 -u 512
wondershaper eth0 1024 512
下载和上传的带宽限制分别限制于1024 Kbps和512 kbps
wondershaper clear eth0
wondershaper -c -a enp0s8
wondershaper -c enp0s8


yum install -y ImageMagick ffmpeg
convert -version
ffmpeg -version
yum install -y opencv

el7
yum install -y centos-release-scl
yum install -y rh-python38
rm -rf /usr/bin/python3
ln -s /opt/rh/rh-python38/root/usr/bin/python3.8 /usr/bin/python3
export PATH=$PATH:/opt/rh/rh-python38/root/usr/local/bin
vi /etc/profile
export PATH=$PATH:/opt/rh/rh-python38/root/usr/local/bin

el8
yum install -y python39 python39-devel
rm -rf /usr/bin/python3
ln -s /usr/bin/python3.9 /usr/bin/python3
python3 -V

python3 -m pip install --upgrade pip -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
pip install --upgrade pip
pip -V
pip3 -V

https://github.com/chenxwh/insanely-fast-whisper

pip install whisper-ctranslate2 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
wget https://paddlespeech.bj.bcebos.com/PaddleAudio/zh.wav
whisper-ctranslate2 zh.wav

pip3 install paddlehub paddlepaddle -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
pip install numpy==1.21.6 -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
wget https://img.traingo.cn/data/pic/course/m_20200724190403588.png
hub run chinese_ocr_db_crnn_mobile --input_path m_20200724190403588.png

el7 莫名其秒的问题
pip install cmake -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
pip install opencv-python -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
pip install Cython -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
pip install shapely pyclipper -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
pip list | grep numpy

ImportError: /lib64/libstdc++.so.6: version `GLIBCXX_3.4.20' not found (required by /opt/rh/rh-python38/root/usr/local/lib64/python3.8/site-packages/paddle/fluid/libpaddle.so)
strings /usr/lib64/libstdc++.so.6 | grep GLIBCXX
wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh --no-check-certificate
chmod u+x Miniconda3-latest-Linux-x86_64.sh 
./Miniconda3-latest-Linux-x86_64.sh
find /root/miniconda3/ -name "libstdc++.so*"
ln -s /root/miniconda3/lib/libstdc++.so.6.0.29 /usr/lib64/libstdc++.so.6



腾讯云容器服务TKE产品介绍
Global Route
独立部署版：基于 Flannel 实现
VPC CIDR
独立部署版：基于 IP-Pool 实现


yum install mysql mysql-server
vi /etc/my.cnf.d/mysql-server.cnf 
[mysqld]
max_connections = 2000
max_connect_errors = 2000
slow_query_log=on
slow_query_log_file=/var/log/mysql/slow.log
long_query_time=2
port=3001
binlog_expire_logs_seconds      = 604800

systemctl enable mysqld
systemctl restart mysqld
mysqladmin -u root password '123456'
mysql -uroot -p


yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sed -i 's/download.docker.com/mirrors.aliyun.com\/docker-ce/g' /etc/yum.repos.d/docker-ce.repo
yum install -y docker-ce
systemctl restart docker

docker pull gogs/gogs
mkdir -p /data/gogs
docker run -d --restart=always --name=gogs -p 10022:22 -p 9091:3000 -v /data/gogs:/data gogs/gogs

server {
    listen 80;
    server_name _;
    location / {
        proxy_pass http://127.0.0.1:9091;
        proxy_redirect default;
    }
}


迁移
git clone --bare http://git.test.cn/test/test.git && cd test.git && git push --mirror http://ip/test/test


麒麟V10 ARM编译安装libreoffice
```
yum install -y automake autoconf cups-devel fontconfig-devel gperf libxslt-devel python3-devel libXext-devel libICE-devel libSM-devel libXrender-devel xorg-x11-xauth x11* libX11 libXrandr-devel cairo-devel  gtk3-devel gstreamer-devel gstreamer-plugins-base gstreamer1-*  gstreamer* glibc-headers  gcc-c++ fakeroot rpm-build nss nspr bison flex

wget http://download.documentfoundation.org/libreoffice/src/7.1.8/libreoffice-7.1.8.1.tar.xz
tar xf /root/libreoffice-7.1.8.1.tar.xz -C /opt/
cd /opt/libreoffice-7.1.8.1/
vi autogen.input
# 禁用帮助
--without-help
--without-helppack-integration

# 启用简体及繁体中文用户界面
--with-lang=zh-CN zh-TW

# 禁用在线更新和崩溃报告
--disable-online-update
--disable-breakpad

# 禁用 Office Development Kit。若启用 ODK，则额外需要 doxygen 依赖项。
--disable-odk
--without-doxygen

# 若编译好之后您需要 rpm （或 deb) 包，则需要启用下列两项：
--enable-epm
--with-package-format=rpm

# 禁用 java
--without-java
--enable-python=internal

--disable-postgresql-sdbc
--enable-option-checking=fatal
--srcdir=/opt/libreoffice-7.1.8.1

./autogen.sh

./autogen.sh --without-java --without-junit --with-lang="zh-CN zh-TW" --disable-postgresql-sdbc --without-doxygen --with-package-format=rpm --enable-epm --srcdir=/opt/libreoffice-7.1.8.1 --enable-option-checking=fatal

chown -R libreoffice:libreoffice /opt/libreoffice-7.1.8.1/

useradd libreoffice
su libreoffice

make

cd /opt/libreoffice-7.1.8.1/workdir/UnpackedTarball/python3/build/lib.linux-aarch64-3.8
cp _sysconfigdata__linux_aarch64-linux-gnu.py _sysconfigdata__linux_aarch64-unknown-linux-gnu.py

cd /opt/libreoffice-7.1.8.1/instdir/


```

alinux 安装docker
```
sudo dnf config-manager --add-repo=https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo dnf -y install dnf-plugin-releasever-adapter --repo alinux3-plus
sudo dnf -y install docker-ce --nobest
sudo docker -v

sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
```

挂载NAS
```
mkdir /data
mount -o username=nas,password=pass,iocharset=utf8 //192.168.2.90/产品部 /data
umount -l /data

yum install -y samba samba-client nfs-utils
systemctl restart nfs
mount -t nfs 10.1.1.133:/nas/nfs-ts /backup
df -Th
vi /etc/fstab
10.1.1.133:/nas/nfs-ts /backup                  nfs     defaults        0 0

showmount -e 10.1.1.133

mount -t nfs 10.1.1.133:/nas/nfs-ts /backup -o nfsvers=3
(如果出现问题mount.nfs: Protocol not supported，将nfsvers改成4
```

