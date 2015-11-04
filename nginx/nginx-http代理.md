nginx http/https代理

http代理
```nginx
server{
	resolver 8.8.8.8;
	access_log /data/logs/nginx/access_proxy.log main;
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
```
https代理
```nginx
server{
	resolver 8.8.8.8;
	access_log /data/logs/nginx/access_proxy.log main;
	listen 443;
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