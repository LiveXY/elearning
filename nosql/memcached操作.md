memcached操作
======
```
telnet ip port
```
###set/add/replace/cas操作
* 格式
```
set/add/replace key flags exptime bytes
<command name> set/add/replace
<key> 查找关键字
<flags>	客户机使用它存储关于键值对的额外信息
<exptime> 该数据的存活时间，0表示永远
<bytes>	存储字节数
```
* 实例
```
set key 0 0 4
test
```
###get/gets操作
* 格式
```
get/gets key
```
* 实例
```
get key
gets key1 key2
```
###delete删除
* 格式
```
delete key
```
* 实例
```
delete key
```
###flush_all清理所有数据
* 格式
```
flush_all
```
###stats/stats items状态命令
* 格式
```
stats
stats items
```
###自曾（incr） 自减（decr）
* 格式
```
incr key
decr key
```
###后续追加append和prepend前面插入命令
* 格式
```
set/add/replace key flags exptime bytes
```

mcrouter集群配置
```
git clone https://github.com/facebook/mcrouter
cd mcrouter/mcrouter
autoreconf --install
./configure
make
make install
mcrouter --help

或者
wget -c https://github.com/ipcpu/MCRouterSetupCentOS7/raw/master/release/mcrouter.x86_64.el7
mv mcrouter.x86_64.el7 mcrouter
chmod u+x mcrouter
mv mcrouter /usr/local/bin/

mcrouter -p 12000 --config-str='{"pools":{"A":{"servers":["10.10.3.22:11212","10.10.3.22:11213"]}}, "route":"PoolRoute|A"}'

```

magent集群配置
```
yum -y install keepalived
vim /etc/keepalived/keepalived.conf
global_defs {
	router_id M1
}
vrrp_instance VI_1 {
	state MASTER
	interface eth0
	virtual_router_id 51
	priority 100
	advert_int 1
	authentication {
		auth_type PASS
		auth_pass 1111
	}
	virtual_ipaddress {
		10.10.3.22
	}
}
vim /etc/keepalived/keepalived.conf
global_defs {
	router_id M2
}
vrrp_instance VI_1 {
	state BACKUP
	interface eth0
	virtual_router_id 51
	priority 100
	advert_int 1 authentication {
		auth_type PASS
		auth_pass 1111
	}
	virtual_ipaddress {
		10.10.3.23
	}
}

yum install libevent-devel -y
ln -s /usr/lib64/libm.so /usr/lib64/libm.a
ln -s /usr/lib64/libevent.so /usr/lib64/libevent.a
git clone -b centos https://github.com/LiveXY/memagent.git
cd memagent
vi ketama.h
#ifndef SSIZE_MAX
#define SSIZE_MAX 32767
#endif

make

或者
wget https://github.com/LiveXY/memagent/raw/centos/magent
chmod u+x magent
cp magent /usr/local/bin/

memcached -d -m 64 -u root -l 10.10.3.22 -p 11212
memcached -d -m 64 -u root -l 10.10.3.22 -p 11213
./magent -u root -n 4096 -l 10.10.3.22 -p 12000 -s 10.10.3.22:11212 -b 10.10.3.22:11213
```
