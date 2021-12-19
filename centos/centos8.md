centos8

dnf install wget git -y

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module list nginx
dnf module reset nginx
dnf module enable nginx:1.18 -y
dnf install nginx -y

dnf module list redis
dnf module reset redis
dnf module enable redis:6 -y
dnf install redis -y

dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
dnf install https://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm

dnf upgrade
dnf config-manager --set-enabled PowerTools

rpm -ivh http://mirror.centos.org/centos/8/PowerTools/x86_64/os/Packages/SDL2-2.0.10-2.el8.x86_64.rpm
rpm -ivh https://centos.pkgs.org/8/centos-powertools-x86_64/SDL2-2.0.10-2.el8.x86_64.rpm.html

dnf install ffmpeg
ffmpeg -version

dnf install libreoffice-pdfimport libreoffice-langpack-zh-Hans libreoffice-langpack-zh-Hant libreoffice-ure libreoffice-ure-common libreoffice-base libreoffice-data libreoffice-impress libreoffice-x11 libreofficekit libreoffice-writer


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


