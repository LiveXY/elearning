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

自动挂载
```
vi /etc/fstab
/dev/hda2 / ext3 defaults 1 1      　　
/dev/hda1 /boot ext3 defaults 1 2      　　
none /dev/pts devpts gid=5,mode=620 0 0      　　
none /proc proc defaults 0 0      　　
none /dev/shm tmpfs defaults 0 0      　　
/dev/hda3 swap swap defaults 0 0      　　
/dev/cdrom /mnt/cdrom iso9660 noauto,codepage=936,iocharset=gb2312 0 0      　　
/dev/fd0 /mnt/floppy auto noauto,owner,kudzu 0 0      　　
/dev/hdb1 /mnt/winc vfat defaults,codepage=936,iocharset=cp936 0 0      　　
/dev/hda5 /mnt/wind vfat defaults,codepage=936,iocharset=cp936 0 0
alipan.cn:/ /data nfs vers=3,nolock,proto=tcp,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0

第一列是挂载的文件系统的设备名，
第二列是挂载点，
第三列是挂载的文件系统类型，
第四列是挂载的选项，选项间用逗号分隔。
rw 以可读写模式挂载
suid 开启用户ID和群组ID设置位
dev 可解读文件系统上的字符或区块设备
exec 可执行二进制文件
auto 自动挂载
nouser 使一般用户无法挂载
async 以非同步方式执行文件系统的输入输出操作
```