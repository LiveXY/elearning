axel多线程断点下载工具
==========

包地址：http://pkgs.repoforge.org/axel/

axel安装：
```sh
wget http://pkgs.repoforge.org/axel/axel-2.4-1.el6.rf.x86_64.rpm
rpm -i axel-2.4-1.el6.rf.x86_64.rpm
```
axel参数：
* `-n x`：启动x个线程下载
* `-s x`：最大速度（byte/s）为x
* `-o f`：指定输出文件
* `-S [x]`：搜索境像并且从指定的x服务器（可以是多个）下载
* `-U x`：设置user agent
* `-N`：不合用代理服务器
* `-q`：静默退出
* `-v`：更多状态信息
* `-h`：帮助信息
* `-v`：版本
axel示例：
```sh
axel -n 10 http://xxx.xxx.xxx.xxx/xxx.xxx
```
