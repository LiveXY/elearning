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
