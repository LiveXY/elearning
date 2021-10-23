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


