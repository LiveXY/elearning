使用ab压力测试
==========

命令格式：`ab [options] [http://]hostname[:port]/path`

ab参数：
* `-n requests` Number of requests to perform(在测试会话中所执行的请求个数。默认时，仅执行一个请求)
* `-c concurrency` Number of multiple requests to make(一次产生的请求个数。默认是一次一个。) 
* `-t timelimit` Seconds to max. wait for responses(测试所进行的最大秒数。其内部隐含值是-n 50000。它可以使对服务器的测试限制在一个固定的总时间以内。默认时，没有时间限制。)
* `-p postfile` File containing data to POST(包含了需要POST的数据的文件. )
* `-T content-type` Content-type header for POSTing(POST数据所使用的Content-type头信息。)
* `-v verbosity` How much troubleshooting info to print(设置显示信息的详细程度 - 4或更大值会显示头信息， 3或更大值可以显示响应代码(404, 200等), 2或更大值可以显示警告和其他信息。 -V 显示版本号并退出。)
* `-w` Print out results in HTML tables(以HTML表的格式输出结果。默认时，它是白色背景的两列宽度的一张表。)
* `-i` Use HEAD instead of GET(执行HEAD请求，而不是GET。)
* `-x attributes` String to insert as table attributes
* `-y attributes` String to insert as tr attributes
* `-z attributes` String to insert as td or th attributes
* `-C attribute` Add cookie, eg. 'Apache=1234. (repeatable)(-C cookie-name=value 对请求附加一个Cookie:行。 其典型形式是name=value的一个参数对。此参数可以重复。)
* `-H attribute` Add Arbitrary header line, eg. 'Accept-Encoding: gzip' Inserted after all normal header lines. (repeatable)
* `-A attribute` Add Basic WWW Authentication, the attributes are a colon separated username and password.
* `-P attribute` Add Basic Proxy Authentication, the attributes are a colon separated username and password.(-P proxy-auth-username:password 对一个中转代理提供BASIC认证信任。用户名和密码由一个:隔开，并以base64编码形式发送。无论服务器是否需要(即, 是否发送了401认证需求代码)，此字符串都会被发送。)
* `-X proxy:port` Proxyserver and port number to use
* `-V` Print version number and exit
* `-k` Use HTTP KeepAlive feature
* `-d` Do not show percentiles served table.
* `-S` Do not show confidence estimators and warnings.
* `-g filename` Output collected data to gnuplot format file.
* `-e filename` Output CSV file with percentages served
* `-h` Display usage information (this message)(-attributes 设置 属性的字符串. 缺陷程序中有各种静态声明的固定长度的缓冲区。另外，对命令行参数、服务器的响应头和其他外部输入的解析也很简单，这可能会有不良后果。它没有完整地实现HTTP/1.x; 仅接受某些'预想'的响应格式。 strstr(3)的频繁使用可能会带来性能问题，即, 你可能是在测试ab而不是服务器的性能。)

ab实例：
* `ab -c 10 -t 10 -p ./postdata -T 'application/x-www-form-urlencoded' http://127.0.0.1/index.php` post测试，从文件读取post数据
* `ab -c 10 -t 10 'http://127.0.0.1/index.php?data=test'` get测试
* `ab -n 100 -c 10 -p ./post.txt -T "multipart/form-data; boundary=ASD45FJHF42DJHT" http://127.0.0.1/index.php` post上传文件
* `ab -c 1000 -n 1000 http://127.0.0.1/index.php` 这个表示同时处理1000个请求并运行1000次index.php文件.

ab测试结果分析：
* Server Software:		//平台apache 版本2.0.54
* Server Hostname:		//服务器主机名
* Server Port:			//服务器端口
* Document Path:		//测试的页面文档
* Document Length:		//文档大小
* Concurrency Level:	//并发数
* Time taken for tests: //整个测试持续的时间
* Complete requests:	//完成的请求数量
* Failed requests:		//失败的请求数量
* Total transferred:	//整个场景中的网络传输量
* HTML transferred:		//整个场景中的HTML内容传输量
* Requests per second:	//大家最关心的指标之一，相当于 LR 中的 每秒事务数 ，后面括号中的 mean 表示这是一个平均值
* Time per request:		//大家最关心的指标之二，相当于 LR 中的 平均事务响应时间 ，后面括号中的 mean 表示这是一个平均值
* Time per request:		//每个请求实际运行时间的平均值
* Transfer rate:		//平均每秒网络上的流量，可以帮助排除是否存在网络流量过大导致响应时间延长的问题
* Connection Times (ms) //网络上消耗的时间
* Percentage of the requests served within a certain time (ms)//整个场景中所有请求的响应情况。

wrk HTTP压力测试
=======
`wrk -t16 -c100 -d30s -T30s --latency http://127.0.0.1:8080/rest/hello` 16个线程，进行并发100,持续30秒的测试,30秒超时时间，打印延迟

bombardier
====
```
go get -u github.com/codesenberg/bombardier
bombardier -c 125 -n 500000 http://localhost:8080/v1/api/todos
```

plow
=======
```
go get -u github.com/six-ddc/plow
plow http://127.0.0.1:8080/hello -c 20 -d 15s -n 5000000
get请求本地接口：建立了20个连接，在15秒内请求了500w次，相信大家也看懂了这里，下面的flag还是解释一下吧。
-c 指定连接数(connections)
-n指定请求数(number)
-d 指定请求的时间(duration)
```

locust
=======
```
pip install locust
-H：指定测试的主机地址（注：会覆盖Locust类指定的主机地址）
-f：指定测试脚本地址（注：脚本中必须包含一个Locust的衍生类）
--no-web：不启动web网页，而是直接开始运行测试，需提供属性-c和-r
-c：并发的用户数，与--no-web一起使用
-r：每秒启动的用户数，与--no-web一起使用
-t：运行时间（单位：秒），与--no-web一起使用
-L：日志级别，默认为INFO
locust -f **.py --no-web -c 1 -t 1
locust -f **.py --port 8089
from locust import HttpLocust,TaskSet,between,task

class WebsiteTasks(TaskSet):

    def on_start(self):
        self.client.post("/login", {
            "username": "test",
            "password": "123456"
        })

    @task(2)
    def index(self):
        self.client.get("/")

    @task(1)
    def about(self):
        self.client.get("/about/")

    def on_stop(self):
        print("stop")

class WebSiteUser(HttpLocust):
    task_set = WebsiteTasks
    host = "http://192.168.31.180"
    wait_time = between(1, 2)
```
