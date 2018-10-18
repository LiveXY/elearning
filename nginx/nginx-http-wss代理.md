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