mkdir /var/log/haproxy
vi /etc/rsyslog.conf
# Provides UDP syslog reception
$ModLoad imudp
$UDPServerRun 514
# Save haproxy log
local2.* /var/log/haproxy/haproxy.log
vi /etc/sysconfig/rsyslog
SYSLOGD_OPTIONS="-r -m 0 -c 2"

systemctl restart haproxy
systemctl restart rsyslog

tailf -f -n 1000 /var/log/haproxy/haproxy.log


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

匹配
acl ddos_referer1 hdr_reg(referer) -i http://vip.renweiba.com
acl ddos_referer2 hdr_reg(referer) -i http://h.hongsita.com
acl ddos_referer3 hdr_reg(referer) -i http://hy.nihenpi.com
acl ddos_referer4 hdr_reg(referer) -i http://vip.zhasita.com
http-request deny if ddos_referer1 || ddos_referer2 || ddos_referer3 || ddos_referer4

global
ssl-default-bind-options no-sslv3 no-tlsv10 no-tlsv11 no-tls-tickets
ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
ssl-default-server-options no-sslv3
ssl-default-server-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
tune.ssl.default-dh-param 2048
frontend https-in
bind :::443 v4v6 alpn h2,http/1.1 ssl crt /usr/local/etc/haproxy/certs/
log global
option httplog
mode http
http-response set-header Strict-Transport-Security max-age=31540000
use_backend mail.domain.com if { ssl_fc_sni -i mail.domain.com }
use_backend mail.domain.com if { ssl_fc_sni -i autodiscover.domain.com }
use_backend rds.domain.com if { ssl_fc_sni -i rds.domain.com }
use_backend website.domain.com if { ssl_fc_sni -i website.domain.com }
default_backend mail.domain.com
backend mail.domain.com
mode http
server exchange exchange_server.local:443 ssl verify none maxconn 10000 check #alctl: server exchange configuration.
backend rds.domain.com
mode http
server rds rds_server.local:443 ssl verify none maxconn 10000 check #alctl: server rds configuration.
backend website.domain.com
mode http
server website website_server.local:443 ssl verify none maxconn 10000 check #alctl: server rds configuration.

backend bk_web
  balance roundrobin
  mode http
  log global
  option httplog
  option forwardfor
  cookie SERVERID insert indirect nocache
  default-server inter 3s rise 2 fall 3
  option httpchk HEAD /
  timeout server 25s
  server server1 192.168.10.11:80 maxconn 100 weight 10 cookie server1 check
  server server2 192.168.10.12:80 maxconn 100 weight 10 cookie server2 check


ModSecurity SQLi / XSS WAF 流量过滤
naxsi
https://www.haproxy.com/blog/high-performance-waf-platform-with-naxsi-and-haproxy/
https://www.haproxy.com/blog/scalable-waf-protection-with-haproxy-and-apache-with-modsecurity/
######## Default values for all entries till next defaults section
defaults
  option  http-server-close
  option  dontlognull
  option  redispatch
  option  contstats
  retries 3
  timeout connect 5s
  timeout http-keep-alive 1s
  # Slowloris protection
  timeout http-request 15s
  timeout queue 30s
  timeout tarpit 1m          # tarpit hold tim
  backlog 10000

# public frontend where users get connected to
frontend ft_waf
  bind 192.168.10.2:80 name http
  mode http
  log global
  option httplog
  timeout client 25s
  maxconn 10000

  # DDOS protection
  # Use General Purpose Couter (gpc) 0 in SC1 as a global abuse counter
  # Monitors the number of request sent by an IP over a period of 10 seconds
  stick-table type ip size 1m expire 1m store gpc0,http_req_rate(10s),http_err_rate(10s)
  tcp-request connection track-sc1 src
  tcp-request connection reject if { sc1_get_gpc0 gt 0 }
  # Abuser means more than 100reqs/10s
  acl abuse sc1_http_req_rate(ft_web) ge 100
  acl flag_abuser sc1_inc_gpc0(ft_web)
  tcp-request content reject if abuse flag_abuser

  acl static path_beg /static/ /dokuwiki/images/
  acl no_waf nbsrv(bk_waf) eq 0
  acl waf_max_capacity queue(bk_waf) ge 1
  # bypass WAF farm if no WAF available
  use_backend bk_web if no_waf
  # bypass WAF farm if it reaches its capacity
  use_backend bk_web if static waf_max_capacity
  default_backend bk_waf

# WAF farm where users' traffic is routed first
backend bk_waf
  balance roundrobin
  mode http
  log global
  option httplog
  option forwardfor header X-Client-IP
  option httpchk HEAD /waf_health_check HTTP/1.0

  # If the source IP generated 10 or more http request over the defined period,
  # flag the IP as abuser on the frontend
  acl abuse sc1_http_err_rate(ft_waf) ge 10
  acl flag_abuser sc1_inc_gpc0(ft_waf)
  tcp-request content reject if abuse flag_abuser

  # Specific WAF checking: a DENY means everything is OK
  http-check expect status 403
  timeout server 25s
  default-server inter 3s rise 2 fall 3
  server waf1 192.168.10.15:81 maxconn 100 weight 10 check
  server waf2 192.168.10.16:81 maxconn 100 weight 10 check

# Traffic secured by the WAF arrives here
frontend ft_web
  bind 192.168.10.2:81 name http
  mode http
  log global
  option httplog
  timeout client 25s
  maxconn 1000
  # route health check requests to a specific backend to avoid graph pollution in ALOHA GUI
  use_backend bk_waf_health_check if { path /waf_health_check }
  default_backend bk_web

# application server farm
backend bk_web
  balance roundrobin
  mode http
  log global
  option httplog
  option forwardfor
  cookie SERVERID insert indirect nocache
  default-server inter 3s rise 2 fall 3
  option httpchk HEAD /
  # get connected on the application server using the user ip
  # provided in the X-Client-IP header setup by ft_waf frontend
  source 0.0.0.0 usesrc hdr_ip(X-Client-IP)
  timeout server 25s
  server server1 192.168.10.11:80 maxconn 100 weight 10 cookie server1 check
  server server2 192.168.10.12:80 maxconn 100 weight 10 cookie server2 check

# backend dedicated to WAF checking (to avoid graph pollution)
backend bk_waf_health_check
  balance roundrobin
  mode http
  log global
  option httplog
  option forwardfor
  default-server inter 3s rise 2 fall 3
  timeout server 25s
  server server1 192.168.10.11:80 maxconn 100 weight 10 check
  server server2 192.168.10.12:80 maxconn 100 weight 10 check


========================================================
option forwardfor except 127.0.0.0/8
timeout queue 1m
timeout client 1m
timeout server 1m

cache test_80
    total-max-size 4
    max-age 24000
138 bind *:8083
139 mode http
140 maxconn 6
141 http-request cache-use test_80
142 http-response cache-store test_80
143 default_backend backend_87

46 bind *:82 ssl crt /etc/haproxy/ssl/demo.haproxy-wi.org.pem
47 mode http
48 maxconn 12
49 balance roundrobin
50 stick-table type ip size 10m expire 1000m store conn_rate(10h),conn_cur,sess_rate(10h),bytes_out_rate(10h)
51 # values below are specific to the backend
52 acl conn_rate_abuse sc2_conn_rate gt 11
53 #acl data_rate_abuse sc2_bytes_out_rate gt 1500000
54 # abuse is marked in the frontend so that it's shared between all sites
55 acl mark_as_abuser sc1_inc_gpc0(test_80) gt 0
56 tcp-request content track-sc2 src
57 tcp-request content reject if conn_rate_abuse mark_as_abuser #data_rate_abuse
59 acl too_fast be_sess_rate gt 11
60 acl too_many be_conn gt 20
61 tcp-request inspect-delay 10s
62 tcp-request content accept if ! too_fast or ! too_many
63 tcp-request content accept if WAIT_END
64 filter spoe engine modsecurity config /etc/haproxy//waf.conf
65 http-request deny if { var(txn.modsec.code) -m int gt 0 }
66 http-request deny if { src -f /etc/haproxy/black/123.lst }
67 http-request deny if { src -f /etc/haproxy/black/new_list.lst }
68 server 127.0.0.1 127.0.0.1:80 check maxconn 200
69 server localhost 127.0.0.1:80 check maxconn 1
backend waf
73 mode tcp
74 timeout connect 5s
75 timeout server 3m
76 server waf 127.0.0.1:12345 check
userlist test
81 group test_group
82 group test_group2
83 user user_test insecure-password pass groups test_group
84 user user_test2 insecure-password pass2
listen test_85
87 bind *:85
88 mode http
89 maxconn 2000
90 balance roundrobin
91 #Start config for DDOS atack protecte
92 stick-table type ip size 1m expire 1000m store gpc0,http_req_rate(10h),http_err_rate(10h)
93 tcp-request connection track-sc1 src
94 tcp-request connection reject if { sc1_get_gpc0 gt 0 }
95 # Abuser means more than 100reqs/10s
96 acl abuse sc1_http_req_rate(test_85) ge 100
97 acl flag_abuser sc1_inc_gpc0(test_85)
98 tcp-request content reject if abuse flag_abuser
99 #End config for DDOS
100 server 127.0.0.1 127.0.0.1:80 check
listen test_86
105 bind *:86
106 mode http
107 maxconn 90
108 balance roundrobin
109 #Start config for DDOS atack protecte
110 stick-table type ip size 2m expire 1000m store gpc0,http_req_rate(10h),http_err_rate(10h)
111 tcp-request connection track-sc1 src
112 tcp-request connection reject if { sc1_get_gpc0 gt 0 }
113 # Abuser means more than 100reqs/10s
114 acl abuse sc1_http_req_rate(test_86) gt 10
115 acl flag_abuser sc1_inc_gpc0(test_86)
116 tcp-request content reject if abuse flag_abuser
117 #End config for DDOS
118 http-request track-sc0 src table per_ip_rates
119 http-request track-sc1 url32+src table per_ip_and_url_rates unless { path_end .css .js .png .jpeg .gif }
120 # Set the threshold to 15 within the time period
121 acl exceeds_limit sc_gpc0_rate(0) gt 15
122 # Increase the new-page count if this is the first time
123 # they've accessed this page, unless they've already
124 # exceeded the limit
125 http-request sc-inc-gpc0(0) if { sc_http_req_rate(1) eq 1 } !exceeds_limit
126 # Deny requests if over the limit
127 http-request deny if exceeds_limit
128 server 127.0.0.1 127.0.0.1:80 check
backend per_ip_and_url_rates
147 stick-table type binary len 8 size 1m expire 24h store http_req_rate(24h)
backend per_ip_rates
150 stick-table type ip size 1m expire 24h store gpc0,gpc0_rate(30s)

Keepalived
global_defs {
   router_id LVS_DEVEL
}
#healt
#health-check for keepalive
vrrp_script chk_haproxy { 
    script "pgrep haproxy"
    interval 2
    weight 3 
}
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 100
    priority 102

    #check if we are still running
    track_script {
        chk_haproxy
    }

    advert_int 1
    authentication {
        auth_type PASS
        auth_pass VerySecretPass
    }
    virtual_ipaddress {
        10.0.0.1
    }
}
