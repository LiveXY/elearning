mysql命令
==========

mysql参数
* `-?`, `--help` 显示帮助信息并退出
* `-I`, `--help` 显示帮助信息并退出
* `--auto-rehash` 自动补全功能，就像linux里面，按Tab键出提示差不多
* `-A`, `--no-auto-rehash` 默认状态是没有自动补全功能的。`-A`就是不要自动补全功能
* `-B`, `--batch` mysql不使用历史文件，禁用交互
* `--character-sets-dir=name` 字体集的安装目录
* `--default-character-set=name` 设置数据库的默认字符集
* `--column-type-info` 结果集返回时，同时显示字段的类型等相关信息
* `-c`, `--comments` Preserve comments. Send comments to the server. The default is `--skip-comments` (discard comments), enable with `--comments`
* `-C`, `--compress` 在客户端和服务器端传递信息时使用压缩
* `-#`, `--debug[=#]` bug调用功能
* `-D`, `--database=name` 使用哪个数据库
* `--default-character-set=name` 设置默认的字符集
* `--delimiter=name` 设置默认命令结束符
* `-e`, `--execute=name` 执行mysql的sql语句
* `-E`, `--vertical` 垂直打印查询输出
* `-f`, `--force` 如果有错误跳过去，继续执行下面的
* `-G`, `--named-commands` Enable named commands. Named commands mean this program's internal commands; see mysql> help . When enabled, the named commands can be used from any line of the query, otherwise only from the first line, before an enter. Disable with `--disable-named-commands`. This option is disabled by default.
* `-g`, `--no-named-commands` Named commands are disabled. Use \* form only, or use named commands only in the beginning of a line ending with a semicolon (;) Since version 10.9 the client now starts with this option ENABLED by default! Disable with `-G`. Long format commands still work from the first line. WARNING: option deprecated; use `--disable-named-commands` instead.
* `-i`, `--ignore-spaces` 忽视函数名后面的空格.
* `--local-infile` 启动/禁用LOAD DATA LOCAL INFILE.
* `-b`, `--no-beep` sql错误时，禁止嘟的一声
* `-h`, `--host=name` 设置连接的服务器名或者Ip
* `-H`, `--html` 以html的方式输出
* `-X`, `--xml` 以xml的方式输出
* `--line-numbers` 显示错误的行号
* `-L`, `--skip-line-numbers` 忽略错误的行号
* `-n`, `--unbuffered` 每执行一次sql后，刷新缓存
* `--column-names` 查寻时显示列信息，默认是加上的
* `-N`, `--skip-column-names` 不显示列信息
* `-O`, `--set-variable=name` 设置变量用法是`--set-variable=var_name=var_value`
* `--sigint-ignore` 忽视SIGINT符号(登录退出时Control-C的结果)
* `-o`, `--one-database` 忽视除了为命令行中命名的默认数据库的语句。可以帮跳过日志中的其它数据库的更新。
* `--pager[=name]` 使用分页器来显示查询输出，这个要在linux可以用more,less等。
* `--no-pager` 不使用分页器来显示查询输出。
* `-p`, `--password[=name]` 输入密码
* `-W`, `--pipe` Use named pipes to connect to server.
* `-P`, `--port=#` 设置端口
* `--prompt=name` 设置mysql提示符
* `--protocol=name` 设置使用的协议
* `-q`, `--quick` 不缓存查询的结果，顺序打印每一行。如果输出被挂起，服务器会慢下来，mysql不使用历史文件。
* `-r`, `--raw` 写列的值而不转义转换。通常结合`--batch`选项使用。
* `--reconnect` 如果与服务器之间的连接断开，自动尝试重新连接。禁止重新连接，使用`--disable-reconnect`。
* `-s`, `--silent` 一行一行输出，中间有tab分隔
* `-S`, `--socket=name` 连接服务器的sockey文件
* `--ssl` 激活ssl连接，不激活`--skip-ssl`
* `--ssl-ca=name` CA file in PEM format (check OpenSSL docs, implies `--ssl`).
* `--ssl-capath=name` CA directory (check OpenSSL docs, implies `--ssl`).
* `--ssl-cert=name` X509 cert in PEM format (implies `--ssl`).
* `--ssl-cipher=name` SSL cipher to use (implies `--ssl`).
* `--ssl-key=name` X509 key in PEM format (implies `--ssl`).
* `--ssl-verify-server-cert` 连接时审核服务器的证书
* `-t`, `--table` 以表格的形式输出
* `--tee=name` 将输出拷贝添加到给定的文件中，禁时用`--disable-tee`
* `--no-tee` 根`--disable-tee`功能一样
* `-u`, `--user=name` 用户名
* `-U`, `--safe-updates` Only allow UPDATE and DELETE that uses keys.
* `-U`, `--i-am-a-dummy` Synonym for option `--safe-updates`, `-U`.
* `-v`, `--verbose` 输出mysql执行的语句
* `-V`, `--version` 版本信息
* `-w`, `--wait` 服务器down后，等待到重起的时间
* `--connect_timeout=#` 连接前要等待的时间
* `--max_allowed_packet=#` 服务器接收／发送包的最大长度
* `--net_buffer_length=#` TCP/IP和套接字通信缓冲区大小。
* `--select_limit=#` 使用`--safe-updates`时SELECT语句的自动限制
* `--max_join_size=#` 使用`--safe-updates`时联接中的行的自动限制
* `--secure-auth` 拒绝用(pre-4.1.1)的方式连接到数据库
* `--server-arg=name`
* `--show-warnings` 显示警告

mysql实例：
* `mysql -h host -uroot -p123456` 连接数据库
* `mysql -h host -uroot -p123456 db < temp.sql` 导入sql代码文件
* `mysql -h 127.0.0.1 -uroot -p123456 -D db -e "select uid,username from member" > /home/member.txt` linux导出部分字段和数据
* `mysql -h 127.0.0.1 -uroot -p123456 -D db -e "select uid,username from member" > d:\\member.txt` windows导出部分字段和数据
* `select uid,username from member into outfile '/tmp/member.txt'`和`load data local infile '/tmp/member_fb.txt' into table db.member(uid, username); ` 导出和导入部分字段和数据
* `mysql -uroot -p123456 -e "show databases;"` 显示所有数据库
* `mysql -uroot -p123456 -D test -e "show tables;"` 显示test库的所有表
* `mysql -uroot -p123456 -e "select * from table;"` 执行SQL
