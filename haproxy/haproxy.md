acl 名称 方法 -i [匹配的路径或文件]

acl：区分字符大小写，且其只能包含大小写字母、数字、-(连接线)、_(下划线)、.(点号)和:(冒号)；haproxy中，acl可以重名，这可以把多个测试条件定义为一个共同的acl。
-i：忽略大小写
-f：从指定的文件中加载模式；
1、hdr_beg(host)：用于测试请求报文的指定首部的开头部分是否符合指定的模式
acl host_static hdr_beg(host) -i img. video. download. ftp.
2、hdr_end(host)：用于测试请求报文的指定首部的结尾部分是否符合指定的模式
acl host_static hdr_beg(host) -i .aa.com .bb.com
3、hdr_reg(host)：正则匹配
acl bbs hdr_reg(host) -i ^(bbs.test.com|shequ.test.com|forum)
4、url_sub：表示请求url中包含什么字符串
5、url_dir：表示请求url中存在哪些字符串作为部分地址路径
6、path_beg： 用于测试请求的URL是否以指定的模式开头
acl url_static path_beg -i /static /iilannis /javascript /stylesheets
7、path_end：用于测试请求的URL是否以指定的模式结尾
acl url_static path_end -i .jpg .gif .png .css .js


	default_backend default   #设置默认访问页面
	#定义当请求的内容是静态内容时，将请求转交给static server的acl规则
	acl url_static path_beg  -i /static /images /img /javascript /stylesheets
	acl url_static path_end  -i .jpg .gif .png .css .js .html
	acl host_static hdr_beg(host)  -i img. video. download. ftp. imags. videos.
	#定义当请求的内容是php内容时，将请求转交给php server的acl规则
	acl url_php path_end     -i .php
	#定义当请求的内容是.jsp或.do内容时，将请求转交给tomcat server的acl规则
	acl url_jsp path_end     -i .jsp .do
	#引用acl匹配规则
	use_backend static_pool if  url_static or host_static
	use_backend php_pool    if  url_php
	use_backend tomcat_pool if  url_jsp

#定义后端backend server
backend static_pool
	option httpchk GET /index.html
	server static1 192.168.80.101:80 cookie id1 check inter 2000 rise 2 fall 3
backend php_pool
	option httpchk GET /info.php
	server php1 192.168.80.102:80 cookie id1 check inter 2000 rise 2 fall 3
backend tomcat_pool
	option httpchk GET /index.jsp
	server tomcat1 192.168.80.103:8086 cookie id2 check inter 2000 rise 2 fall 3
#<----------------------default site for listen and frontend------------------------------------>
backend default
	mode http
	option httpchk GET /index.html
	server default 192.168.80.104:80 cookie id1 check inter 2000 rise 2 fall 3 maxconn 5000

acl use_server_1 path_reg ^/q/[abc]/?.*$
use backend server1 if user_server_1
acl use_server_2 path_reg ^/q/[xy]/?.*$
use backend server2 if user_server_2

会话保持
session 识别
backend APPSESSION_srv
	mode http
	appsession JSESSIONID len 64 timeout 5h request-learn
	server web1 192.168.0.150:80 cookie 1 check inter 1500 rise 3 fall 3
	server web2 192.168.0.151:80 cookie 2 check inter 1500 rise 3 fall 3
cookie 识别
backend COOKIE_srv
	mode http
	cookie SESSION_COOKIE insert indirect nocache
	server web1 192.168.0.150:80  cookie 1 check inter 1500 rise 3 fall 3
	server web2 192.168.0.151:80  cookie 2 check inter 1500 rise 3 fall 3
用户源IP 识别 配置指令 balance source
backend www
	mode http
	balance source
	server web1  192.168.0.150:80 check inter 1500 rise 3 fall 3
	server web2  192.168.0.151:80 check inter 1500 rise 3 fall 3







