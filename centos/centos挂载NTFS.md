centos 挂载NTFS
==========
```sh
wget http://tuxera.com/opensource/ntfs-3g_ntfsprogs-2014.2.15.tgz
tar zxvf ntfs-3g_ntfsprogs-2014.2.15.tgz
cd ntfs-3g_ntfsprogs-2014.2.15

./configure
make
make install
或
yum install ntfs-3g -y

mount -t ntfs-3g /dev/sda1 /mnt/windows

fdisk -l

启动加载：
/dev/sda1 /mnt/windows ntfs-3g defaults 0 0
```