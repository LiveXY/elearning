smb 共享文件
==========

http://www.cnblogs.com/mchina/archive/2012/12/18/2816717.html

```sh
yum install samba samba-client samba-swat -y

vi /etc/samba/smb.conf
[share]
comment = share files
path = /home/share
browseable = yes
writeable = yes
valid users = root

mkdir /home/share
chmod 777 -R /home/share

smbpasswd -a root

service smb restart
chkconfig smb on

无密码共享
[global]
security = user
map to guest = Bad User
[share]
comment = share
path = /home/share
browseable = yes
guest ok = yes
writable = yes


vi /etc/samba/smbusers
# Unix_name = SMB_name1 SMB_name2 ...
root = administrator admin
nobody = guest pcguest smbguest
```










