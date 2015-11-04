PSSH集群管理
==========

* `pssh` 在多个主机上并行地运行命令。
* `pscp` 把文件并行地复制到多个主机上。
* `prsync` 通过 rsync 协议把文件高效地并行复制到多个主机上。
* `pslurp` 把文件并行地从多个远程主机复制到中心主机上。
* `pnuke` 并行地在多个远程主机上杀死进程。

pssh安装
```sh
wget http://parallel-ssh.googlecode.com/files/pssh-2.3.1.tar.gz
tar -xvf pssh-2.3.1.tar.gz
cd pssh-2.3.1
python setup.py build
python setup.py install

pssh --ersion

创建主机列表：
vi host.list
10.211.55.17
10.211.55.18

配置SSH信任关系
mkdir ~/.ssh
ssh-keygen -t rsa
scp ~/.ssh/id_rsa.pub 10.211.55.17:/root/.ssh/authorized_keys
scp ~/.ssh/id_rsa.pub 10.211.55.18:/root/.ssh/authorized_keys
指定端口
scp -P 58422 ~/.ssh/id_rsa.pub 10.211.55.17:/root/.ssh/authorized_keys

或
for i in `cat host.list`
do
ssh $i -C mkdir /root/.ssh
scp ~/.ssh/id_rsa.pub $i:/root/.ssh/authorized_keys
done
```

pssh
* pssh -h host.list -l root -P uptime 
* pssh -h host.list -l root -P hostname
* pssh -h host.list -l root -P date
* pssh -h host.list -P "mkdir /home/test"
* pssh -h host.list -P "rmdir /home/test"
* pssh -h host.list -P "ls /home/"
* pssh -H '10.211.55.17' -P "mkdir /home/test1"
* pssh -h host.list -t 10000 -l root -P "svn up /home/test/ --username root --password root"

pscp
* pscp -h host.list -l root host.list /home/
* pscp -h host.list -l root -r host.list /home/
* pscp -h host.list -l root -r pssh-2.3.1/ /home/

pslurp
* `pslurp --recursive -h host.list /etc/passwd passwd` /etc/passwd 为远程文件 passwd存到./IP/目录下,也可以为拷贝到本地后的文件名.
* `pslurp --recursive -h host.list /home/test/ test/`
* `pslurp --recursive -h host.list -L /home/test/ /etc/passwd passwd` --recursive表示递归子目录 -L 选项指定创建子目录的位置 /etc/passwd为远程文件或目录 passwd为拷贝到本地后的目录名 看目录结构就知道了tree /srv/test/

pnuke
* `pnuke -h host.list --user=root top` 节点主机上执行killall cron命令

可能出现问题：
* scp: /root/.ssh/authorized_keys: No such file or directory 新建好的用户默认没有.ssh目录，需要自己建立。`su root`
* `mkdir -p ~/.ssh` scp: /root/.ssh/authorized_keys: Permission denied是root用户新建的.ssh目录，导致没有权限。改变用户属主就行。`chown -R root:root .ssh`

prsync
* prsync -l root -h grids -A -r develop/ /tmp/production/

prsync参数：
* `-h` 执行命令的远程主机列表  或者 -H user@ip:port  文件内容格式[user@]host[:port]
* `-l` 远程机器的用户名
* `-p` 一次最大允许多少连接
* `-o` 输出内容重定向到一个文件
* `-e` 执行错误重定向到一个文件
* `-t` 设置命令执行的超时时间
* `-A` 提示输入密码并且把密码传递给ssh
* `-O` 设置ssh参数的具体配置，参照ssh_config配置文件
* `-x` 传递多个SSH 命令，多个命令用空格分开，用引号括起来
* `-X` 同-x 但是一次只能传递一个命令
* `-i` 显示标准输出和标准错误在每台host执行完毕后
* `-I` 读取每个输入命令，并传递给ssh进程 允许命令脚本传送到标准输入
