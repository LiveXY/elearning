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

```