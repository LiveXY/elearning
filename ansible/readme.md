ansible使用
```
ansible 6168 -m ping #测试主机是否是通的
ansible 6168 --list #查看6168有几台服务器

ansible 6168 -m setup #查看服务器配置
ansible 6168 -m setup -a 'filter=ansible_*_mb' #查看主机内存信息

ansible 6168 -m file -a 'path=/tmp/1111.log state=absent' #删除文件
ansible 6168 -m file -a "dest=/tmp/1/2 state=directory" #创建目录-p
ansible 6168 -m file -a 'src=/tmp/1111.log dest=/tmp/1111.link state=link' #创建链接
ansible 6168 -m file -a 'path=/tmp/2222.log mode=0644 state=touch' #创建文件

ansible 6168 -m copy -a 'src=./foo.conf dest=/tmp/foo.conf' #复制文件
ansible 6168 -m copy -a 'content="hello world" dest=/tmp/foo.conf mode=640'  #复制文件

ansible 6168 -m service -a 'name=nginx state=reloaded' #nginx重新加载 started启动,stopped停止,restarted重启,reloaded重新加载
ansible 6168 -m service -a 'name=nginx state=started enabled=yes' #nginx启动并设为自动启动
ansible 6168 -m shell -a 'ps aux|grep nginx' #查看nginx是否启动

ansible 6168 -m yum -a 'name=nginx state=latest' #安装最新nginx latest更新，present当前，absent删除
ansible 6168 -m yum -a 'name=http://rpms.famillecollet.com/enterprise/remi-release-7.rpm state=present' #安装源

ansible 6168 -m script -a '/tmp/a.sh' #执行脚本
ansible 6168 -m command -a "uptime" #执行脚本
ansible 6168 -m shell -a 'echo $HOME' #执行脚本
ansible 6168 -m raw -a "uptime" #执行脚本 可以使用管道
ansible 6168 -m shell -a "ss -tnl | grep :80" #执行脚本 可以使用管道
ansible 6168 -m command -a  'useradd tom' #添加用户
ansible 6168 -m shell -a 'echo "123456" | passwd --stdin tom' #修改密码

ansible 6168 -m git -a "repo=repo dest=/home/tttthz version=HEAD" #克隆git
ansible 6168 -m git -a "repo=repo dest=/home/tttthz" #更新最新

ansible 6168 -m get_url -a 'url=http://server/favicon.ico dest=/tmp' #下载
ansible 6168 -m stat -a 'path=/etc/sysctl.conf' #查看状态
ansible 6168 -m fetch -a 'src=/etc/sysctl.conf dest=./' #从线上拉取到本地

#pm2
ansible 6168 -m shell -a 'pm2 list'
ansible 6168 -m shell -a 'pm2 start /home/hzmj-mass/app.js -n hzmj'
ansible 6168 -m shell -a 'pm2 restart hzmj'
ansible 6168 -m shell -a 'ls -l ~/.pm2/logs/'
ansible 6168 -m shell -a 'tail -n 1000 ~/.pm2/logs/hzmj-out-16.log'

#rpcman
ansible 6168 -m shell -a 'rpcman list /home/hzmj-mass'
ansible 6168 -m shell -a 'rpcman servers /home/hzmj-mass'
ansible 6168 -m shell -a 'rpcman connections /home/hzmj-mass'
ansible 6168 -m shell -a 'rpcman gamehub /home/hzmj-mass'
ansible 6168 -m shell -a 'rpcman check /home/hzmj-mass'
ansible 6168 -m shell -a 'rpcman ps /home/hzmj-mass'
ansible 6168 -m shell -a 'rpcman testssh /home/hzmj-mass'
ansible 6168 -m shell -a 'rpcman getmain /home/hzmj-mass'
ansible 6168 -m shell -a 'rpcman kill /home/hzmj-mass'
ansible 6168 -m shell -a 'rpcman restart /home/hzmj-mass -y'

cd a/ #进入次目录才可以使用下面指令
ansible-playbook centos7-base-tools.yml -e host=6168 #安装centos7常用源和工具
ansible-playbook selinux.yml -e host=6168 #禁用selinux
ansible-playbook inputrc.yml -e host=6168 #开启上下键快速查找历史命令
ansible-playbook memcache.yml -e host=6168 #安装memcache
ansible-playbook php.yml -e host=6168 #安装nginx+php
ansible-playbook nodejs6.yml -e host=6168 #安装nodejs6
ansible-playbook nodejs8.yml -e host=6168 #安装nodejs8
ansible-playbook n.yml -e 'host=6168 v=6.12.2' #切换nodejs版本
ansible-playbook n.yml -e 'host=6168 v=8.10.0' #切换nodejs版本

ansible-playbook analysis.yml --tags net-conn -e host=6168 #显示连接状态
ansible-playbook analysis.yml --tags net-wait -e host=6168 #显示处于等待状态的IP
ansible-playbook analysis.yml --tags net-syn -e host=6168 #显示处于syn状态的IP
ansible-playbook analysis.yml --tags pnum -e 'host=6168 p=php-fpm' #显示php-fpm进程数量
ansible-playbook analysis.yml --tags uptime -e host=6168 #显示最近3次的负荷
ansible-playbook analysis.yml --tags free -e host=6168 #显示内存空间
ansible-playbook analysis.yml --tags cpu-top10 -e host=6168 #显示占CPU最多的前10个进程
ansible-playbook analysis.yml --tags mem-top10 -e host=6168 #显示占内存最多的前10个进程
ansible-playbook analysis.yml --tags ps -e 'host=6168 p=php-fpm' #显示php-fpm进程
ansible-playbook analysis.yml --tags df -e host=6168 #显示磁盘空间
ansible-playbook analysis.yml --tags du -e 'host=6168 p=~/.pm2/logs' #显示pm2日志目录的大文件

ansible-playbook haproxy.yml --tags install -e host=6168 #安装haproxy
ansible-playbook haproxy.yml --tags stop -e host=6168 #停止haproxy
ansible-playbook haproxy.yml --tags restart -e host=6168 #重起haproxy

#php代理服务器
ansible-playbook haproxy.yml --tags add -e 'host=6168 \
	mode=http haname=php balance=roundrobin listen=5000 \
	option="\n\tlog global\n\toption logasap\n\toption dontlognull" \
	server="server php-back 127.0.0.1:5001 check"'

#nodejs代理服务器
ansible-playbook haproxy.yml --tags add -e 'host=6168 \
	mode=tcp haname=node balance=leastconn listen=5005 \
	option="" \
	server="server node-back 127.0.0.1:5006"'

#安装nfs-server
ansible-playbook nfs.yml --tags server -e 'host=6168 \
	path=/home/tttthz \
	inet=192.168.6.0/8(rw,sync,no_root_squash)'

#安装nfs-client
ansible-playbook nfs.yml --tags client -e 'host=6168 \
	iname=/tttthz \
	isrc=192.168.6.168:/home/tttthz'

ansible-playbook nfs.yml --tags umount -e 'host=6168 iname=/tttthz' #nfs取消挂载
ansible-playbook nfs.yml --tags uninstall -e host=6168 #卸载nfs

#WEB站点配置
ansible-playbook nginx-site.yml -e 'host=6168 \
	conf=/etc/nginx/conf.d/hzmjttt.conf \
	domain=hzmj2.realbullgame.com \
	sport=192.168.6.168:5009 \
	path=/home/hzmj_laravel/public'

#无缓存和GZIP的简单站点配置
ansible-playbook nginx-site.yml -e 'host=6168 \
	stemplate=./templates/nginx-small.conf.j2 \
	conf=/etc/nginx/conf.d/hzmjttt.conf \
	domain=hzmj2.realbullgame.com \
	sport=192.168.6.168:5009 \
	path=/home/hzmj_laravel/public'

#代理服务器配置
ansible-playbook nginx-site.yml -e 'host=6168 \
	stemplate=./templates/nginx-proxy.conf.j2 \
	ssl=/home/ssl/ssl \
	conf=/etc/nginx/conf.d/hzmj-node-proxy.conf \
	domain=hzmj2.realbullgame.com \
	sport=192.168.6.168:5008 \
	server=192.168.6.168:17071'

#系统优化
ansible-playbook optimize.yml -e host=6168
ansible-playbook optimize.yml -e host=6168 --tags ulimit
ansible-playbook optimize.yml -e host=6168 --tags sysctl
ansible-playbook optimize.yml -e host=6168 --tags php
ansible-playbook optimize.yml -e host=6168 --tags nginx
ansible-playbook optimize.yml -e host=6168 --tags ulimit,sysctl
ansible-playbook optimize.yml -e host=6168 --tags php,nginx

ansible-playbook log-clear.yml --tags pm2 -e host=6168 #清理pm2一个月未更改的日志文件，清理pm2大于100M日志文件
ansible-playbook log-clear.yml --tags nohup -e host=6168 #清理nohup日志文件
ansible-playbook log-clear.yml --tags php -e host=6168 #清理php项目日志30天未更改大于10M文件

ansible-playbook centos7-repo.yml --tags base,aliyun -e host=6168 #将系统的源更改为阿里云的源

#自动部署例子
#1，GIT拉取代码
ansible mmphp -m git -a "repo=repo dest=/home/site version=HEAD"
#设置目录权限
ansible mmphp -m file -a "dest=/home/site/public/client/upload/ state=directory mode=777 recurse=true"
ansible mmphp -m file -a "dest=/home/site/bootstrap/cache/ state=directory mode=777 recurse=true"
ansible mmphp -m file -a "dest=/home/site/storage/ state=directory mode=777 recurse=true"
ansible mmphp -m file -a "dest=/home/site/storage/logs state=directory mode=777 recurse=true"
#修改env文件配置
ansible-playbook laravel-env.yml -e '\
	host=mmphp \
	stemplate=./templates/laravel.env.j2 \
	envfile=/home/site/.env \
	ROOTURL=http://domain.com \
	CDNSERVER=http://domain.com \
	DB_HOST=127.0.0.1 \
	DB_DATABASE=db \
	DB_USERNAME=root \
	DB_PASSWORD=123456 \
	MEMCACHED_HOST=127.0.0.1'
#配置站点
ansible-playbook nginx-site.yml -e 'host=mmphp \
	ssl=/home/ssl/site \
	conf=/home/nginx/conf.d/test.conf \
	domain=domain.com \
	sport=80 \
	path=/home/site/public'
#内网数据库复制到线上
ansible-playbook copydb.yml -e "\
	ohost=6168 \
	odbhost=127.0.0.1 \
	odbuser=root \
	odbpass=123456 \
	odbname=db \
	nhost=mmphp \
	ndbhost=127.0.0.1 \
	ndbuser=root \
	ndbpass=123456 \
	ndbname=db"

```