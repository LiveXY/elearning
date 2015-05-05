wget curl命令
======
###wget命令格式:
```sh
wget [option]... [URL]...
```
###wget命令参数
* `-V, --version` 打印版本信息
* `-h, --help` 打印帮助信息
* `-o logfile, --output-file=logfile` 将日志消息写入 logfile
* `-a logfile, --append-output=logfile` 将日志消息追加到 logfile
* `-d, --debug` 打开调试输出，打印调试信息
* `-q, --quiet` 打开安静输出，不打印任何信息
* `-v, --verbose` 打开详情输出，这是默认的输出
* `-nv, --no-verbose` 关闭详情输出，但不等于是安静输出
* `-i file, --input-file=file` 从 file 读取 URL
* `-t number, --tries=number` 设置重试次数，number 为 0 表示无限重试
* `-O file, --output-document=file` 将文档写到file文件
* `-c, --continue` 端点续传
* `-S, --server-response` 打印服务器的响应消息
* `--spider` 只检查资源是否存在而不下载资源
* `-T seconds, --timeout=seconds` 设置网络超时
* `--dns-timeout=seconds` 设置 DNS 超时
* `--connect-timeout=seconds` 设置连接超时
* `--read-timeout=seconds` 设置读写超时
* `--limit-rate=amount` 限制下载速度
* `-Q, --quota=NUMBER` 设置下载的容量限制
###wget实例
* `wget http://url/file.jpg` 下载文件
* `wget -O test.jpg http://url/file.jpg` 下载文件并指定文件名
* `wget -i imglist.txt` 下载文件中指定的 URL
* `wget --limit-rate 3K http://url/file` 限制下载速度
* `wget -c http://url/file` 断点下载
* `wget --spider http://url/file` 判断资源是否存在
* `wget -P /home http://url/file` 指定文件保存目录


###curl命令格式:
```sh
curl [options] [URL...]
```
###curl命令参数
* `-A, --user-agent` 指定用户代理
* `-b/--cookie <name=string/file>` 传递 cookie
* `-c, --cookie-jar <file name>` 完成操作后，将 cookie 写入到指定的文件
* `-C, --continue-at <offset>` 断点续传
* `-d, --data <data>` 以 POST 方式向 HTTP 服务器发送指定的数据
* `--data-ascii <data>` -d/--data 选项的别名
* `--data-binary <data>` 以 POST 方式向 HTTP 服务器发送指定的二进制数据
* `-D/--dump-header <file>` 将响应的头部信息输出到指定的文件
* `-e, --referer <URL>` 指定 HTTP 请求的 Referer 头部信息
* `-G, --get` 与 -d 选项一起使用时，以 GET 方式向 HTTP 服务器发送指定的数据
* `-h, --help` 显示帮助信息
* `-H, --header <header>` 传递额外的头信息
* `-i, --include` 输出信息时包含协议的头部信息
* `-I, --head` 只显示文档信息
* `--limit-rate <speed>` 限定最大的传输速率
* `-L, --location` 重定向
* `-o, --output <file>` 将响应消息写到文件而不是标准输出
* `-O, --remote-name` 将响应消息写到文件，文件名与远程文件一致
* `--trace <file>` 将调试信息输出到指定的文件
* `--trace-ascii <file>` 与trace相同，但是不显示十六进制信息
* `-x, --proxy <proxyhost[:port]>` 指定 HTTP 代理
* `-X, --request <command>` 指定请求方法，而不是默认的 GET 方法（FTP 协议默认的请求方法是 LIST）
* `-u, --user <user:password>` 指定用户名和密码
* `-U, --proxy-user <user:password>` 指定代理的用户名和密码
* `-v, --verbose` 显示更为详细的通信信息，如果觉得信息不够详细，可以考虑使用 --trace 或 --trace-ascii 选项
* `-V, --version` 显示版本信息
###curl实例
* `curl http://url` 查看网页源码
* `curl -o example.html http://url` 保存网页源码
* `curl -i http://url` 显示 HTTP 响应的头部信息
* `curl -d "username=?&password=?" http://url` 发送 HTTP POST 请求
* `curl -G -d "username=?&password=?" http://url` 发送 HTTP GET 请求
* `curl -H "Content-Type: application/json" http://url` 添加额外的头部信息
* `curl -e http://www.baidu.com/ http://www.example.com/` 指定源地址
* `curl -A "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; WOW64; Trident/6.0)" http://url` 指定 HTTP 客户端信息
* `curl -b "username=?; password=?" http://url` 使用 cookie
* `curl -b cookie.txt http://url` 使用 cookie
* `curl -L http://url` 输出重定向后的响应信息
* `curl -u name:password http://url` 若需要 HTTP 认证，指定用户名和密码
