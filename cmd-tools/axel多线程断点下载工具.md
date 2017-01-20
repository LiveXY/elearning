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

aria2
=======
```
yum install aria2
#下载单个文件
aria2c https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
aria2c -o owncloud.zip https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
aria2c --max-download-limit=500k https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2 #限制速度
#下载多个文件
aria2c -Z https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2 ftp://ftp.gnu.org/gnu/wget/wget-1.17.tar.gz
#续传未完成的下载
aria2c -c https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
#从文件获取输入
aria2c -i test-aria2.txt
#每个主机使用两个连接来下载
aria2c -x2 https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
#下载 BitTorrent 种子文件
aria2c https://torcache.net/torrent/C86F4E743253E0EBF3090CCFFCC9B56FA38451A3.torrent?title=[kat.cr]irudhi.suttru.2015.official.teaser.full.hd.1080p.pathi.team.sr
#下载 BitTorrent 磁力链接
aria2c 'magnet:?xt=urn:btih:248D0A1CD08284299DE78D5C1ED359BB46717D8C'
#下载 BitTorrent Metalink 种子
aria2c https://curl.haxx.se/metalink.cgi?curl=tar.bz2
#从密码保护的网站下载一个文件
aria2c --http-user=xxx --http-password=xxx https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2
aria2c --ftp-user=xxx --ftp-password=xxx ftp://ftp.gnu.org/gnu/wget/wget-1.17.tar.gz
```

