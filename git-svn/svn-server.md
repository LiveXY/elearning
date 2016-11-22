SVN Server
==========

```sh
yum install subversion mod_dav_svn -y
svnserve --version

mkdir /home/svn
mkdir /home/svn/lms

创建lms代码仓库
svnadmin create /home/svn/lms

添加账号
vim /home/svn/lms/conf/passwd
user = 123456

设置权限
vim /home/svn/lms/conf/authz
[/]
user = rw

vim /home/svn/lms/conf/svnserve.conf
[general]
anon-access=read
auth-access=write
password-db=passwd
authz-db=authz

启动svnserve
svnserve -d -r /home/svn

查看是否启动
ps -ef | grep svn

svn co svn://ip/lms

iptables -A INPUT -i eth0 -p tcp --dport 3690 -j ACCEPT

lsof -i:3690
```


