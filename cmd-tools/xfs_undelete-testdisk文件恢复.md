xfs_undelete
=========

https://github.com/ianka/xfs_undelete

```
yum install tcl tcl-dev tcllib
apt install -y tcllib

wget https://github.com/ianka/xfs_undelete/archive/refs/tags/v12.0.tar.gz
tar zxvf v12.0.tar.gz

umount /data
df -hT | grep /data

恢复最近48小时之内被删除的文件，恢复到/mnt/
xfs_undelete -t -48hour -o /mnt/ /dev/mapper/git-git
xfs_undelete -t -6hour -o /mnt/ repair /dev/mapper/rl-home
xfs_undelete -t -6hour -o /mnt/ /dev/mapper/centos-root
xfs_undelete -t -6hour -o /mnt/ /dev/sda3
恢复2小时内修改过的文件，恢复到/mnt/
xfs_undelete -T 2hour -o /mnt/ /dev/sdb

```

TestDisk
========

https://www.cgsecurity.org/wiki/TestDisk_Download
https://www.cgsecurity.org/Download_and_donate.php/testdisk-7.2-WIP.win64.zip
https://www.cgsecurity.org/Download_and_donate.php/testdisk-7.2-WIP.mac_intel_x86_64.tar.bz2
https://www.cgsecurity.org/testdisk-7.2-WIP.linux26-x86_64.tar.bz2

```
yum install epel-release
yum install testdisk
apt-get install testdisk
dnf install testdisk
testdisk -v
https://cloud.tencent.com/developer/article/1876739
步骤1：创建一个日志文件
第2步：选择恢复驱动器
步骤3：选择分区类型
高级恢复
步骤4：导航到“已删除文件目录”
https://zhongguo.eskere.club/%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8testdisk%E5%9C%A8linux%E4%B8%8A%E6%81%A2%E5%A4%8D%E5%B7%B2%E5%88%A0%E9%99%A4%E7%9A%84%E6%96%87%E4%BB%B6/2021-05-08/
https://vitux.com/how-to-recover-deleted-files-in-ubuntu-through-testdisk/

wget https://www.cgsecurity.org/testdisk-7.2-WIP.linux26-x86_64.tar.bz2
tar xvf testdisk-7.2-WIP.linux26-x86_64.tar.bz2
cd testdisk-7.2-WIP
./photorec_static

photorec /dev/sda3
https://www.lxlinux.net/5479.html

```
