nginx http/https代理

http正向代理
```nginx
server{
	resolver 8.8.8.8;
	listen 7070;
	location / {
		root html;
		index index.html index.htm;
		proxy_pass $scheme://$host$request_uri;
		proxy_set_header HOST $http_host;
		proxy_buffers 256 4k;
		proxy_max_temp_file_size 0k;
		proxy_connect_timeout 30;
		proxy_send_timeout 60;
		proxy_read_timeout 60;
		proxy_next_upstream error timeout invalid_header http_502;
	}
	error_page 500 502 503 504 /50x.html;
	location = /50x.html {
		root html;
	}
}
查看dns方法 cat /etc/resolv.conf
```
https正向代理
```nginx
server{
	resolver 8.8.8.8;
	listen 443 ssl;
	location / {
		root html;
		index index.html index.htm;
		proxy_pass https://$host$request_uri;
		proxy_buffers 256 4k;
		proxy_max_temp_file_size 0k;
		proxy_connect_timeout 30;
		proxy_send_timeout 60;
		proxy_read_timeout 60;
		proxy_next_upstream error timeout invalid_header http_502;
	}
	error_page 500 502 503 504 /50x.html;
	location = /50x.html {
		root html;
	}
}
```
wss代理
```
server {
	listen 443 ssl;
	server_name domain.com;

	ssl_certificate /home/ssl/ssl.crt;
	ssl_certificate_key /home/ssl/ssl.key;
	ssl_session_timeout 5m;
	ssl_session_cache shared:SSL:50m;
	ssl_prefer_server_ciphers on;
	ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2;

	location / {
		proxy_pass http://wss/;
		proxy_set_header Host $host:$server_port;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
	}
}
upstream wss {
	hash $remote_addr consistent;
	server 10.0.0.1:7510;
}
```
ws代理web
```
server {
	listen 8889;
	server_name domain.com;

	location / {
		proxy_pass http://192.168.6.169:8889;
		proxy_set_header Host $host:$server_port;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection "upgrade";
	}
}
```

TCP代理 nginx1.9版本
```
stream {
	upstream ds_nodejs {
	 	server 10.10.0.11:8008;
	}
	server {
	 	listen 8008;
	 	proxy_pass ds_nodejs;
	}
}
```

匹配优先级：= > ^~ >  ~ > ~* > 不带任何字符。

$variable 仅为变量时，值为空或以0开头字符串都会被当做 false 处理；
= 或 != 相等或不等；
~ 正则匹配；
! ~ 非正则匹配；
~* 正则匹配，不区分大小写；
-f 或 ! -f 检测文件存在或不存在；
-d 或 ! -d 检测目录存在或不存在；
-e 或 ! -e 检测文件、目录、符号链接等存在或不存在；
-x 或 ! -x 检测文件可以执行或不可执行；