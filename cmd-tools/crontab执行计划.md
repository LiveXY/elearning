crontab执行计划
==========

crontab实例：
```sh
crontab -e

10  * * * * wget -O /dev/null http://127.0.0.1/index.php > /dev/null 2>&1 #第10分钟执行
10,20  * * * * wget -O /dev/null http://127.0.0.1/index.php > /dev/null 2>&1 #第10和20分钟执行
10  */1 * * * wget -O /dev/null http://127.0.0.1/index.php > /dev/null 2>&1 #每小时的第10分钟执行
10 0 * * * wget -O /dev/null http://127.0.0.1/index.php > /dev/null 2>&1 #每天的0:10分执行
10  0 1 * * wget -O /dev/null http://127.0.0.1/index.php > /dev/null 2>&1 #每月的1号0:10分执行
*/1 * * * * /root/test.sh #每1分钟执行
0,30 18-23 * * * wget -O /dev/null http://127.0.0.1/index.php > /dev/null 2>&1 #每天18至23之间每隔30分钟。
10,40 */1 * * * wget -O /dev/null http://127.0.0.1/index.php > /dev/null 2>&1 #每小时的第10,40分钟执行
```

需要每秒执行一次命令，通过linux自带的cron却不能实现，新版的cron据说可以精确到秒。
```sh
vi /root/test.sh #每秒执行
#!/bin/bash
while [ true ]; do
/bin/sleep 1
netstat -n | grep 8080
done

nohub /root/test.sh & 
```

还可以用php来实现每秒执行：
```sh
nohup /usr/bin/php ./test.php &
```



