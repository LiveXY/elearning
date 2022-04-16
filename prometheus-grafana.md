
https://prometheus.io/docs/instrumenting/exporters/
https://prometheus.io/download/#mysqld_exporter

安装 prometheus
```
wget https://github.com/prometheus/prometheus/releases/download/v2.34.0/prometheus-2.34.0.linux-amd64.tar.gz
tar -zxvf prometheus-2.34.0.linux-amd64.tar.gz
mv prometheus-2.34.0.linux-amd64 prometheus

groupadd prometheus
useradd -g prometheus -s /sbin/nologin prometheus
chown -R prometheus:prometheus ./prometheus/

vi /usr/lib/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/
After=network.target

[Service]
Type=simple
User=prometheus
ExecStart=/data/prometheus/prometheus --config.file=/data/prometheus/prometheus.yml --storage.tsdb.path=/data/prometheus
Restart=on-failure

[Install]
WantedBy=multi-user.target
chown prometheus:prometheus /usr/lib/systemd/system/prometheus.service
systemctl daemon-reload
systemctl enable prometheus
systemctl restart prometheus

http://127.0.0.1:9090
```

安装 grafana
```
vim /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://mirrors.tuna.tsinghua.edu.cn/grafana/yum/rpm
repo_gpgcheck=0
enabled=1
gpgcheck=0

yum makecache
yum install grafana -y
systemctl enable grafana-server
systemctl restart grafana-server
http://127.0.0.1:3000
admin/admin

点击"Add data source/Add your first data source"按钮，并选择Prometheus
在"Dashboards"页签下"import"自带的模版
Prometheus 2.0 Status
在"Settings"页签下 填http URL http://ip:9090

```

安装监控LINUX
```
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar -zxvf node_exporter-1.3.1.linux-amd64.tar.gz
mv node_exporter-1.3.1.linux-amd64 node_exporter
chown -R prometheus:prometheus ./node_exporter/
vim /usr/lib/systemd/system/node_exporter.service
[Unit]
Description=node_exporter service
After=network.target

[Service]
User=prometheus
ExecStart=/data/node_exporter/node_exporter

[Install]
WantedBy=multi-user.target

systemctl daemon-reload
systemctl enable node_exporter
systemctl restart node_exporter
http://127.0.0.1:9100

vi ./prometheus/prometheus.yml
  - job_name: 'linux-node'
    static_configs:
    - targets: ['ip:9100']
      labels:
        instance: linux-node1

systemctl restart prometheus


Grafana首页-->左上角图标-->Dashboard-->import
Upload已下载至本地的json文件（或者使用dashboard id，如这里的405）
数据源选择"prometheus"，即添加的数据源name，点击"Import"按钮
Grafana首页-->左上角图标-->Dashboard-->Home，Home下拉列表中可见有已添加的两个dashboard，"Prometheus Stats"与"Node Exporter Server Metrics"，选择1个即可

https://grafana.com/grafana/dashboards/405

```

安装报警器
```
wget https://github.com/prometheus/alertmanager/releases/download/v0.24.0/alertmanager-0.24.0.linux-amd64.tar.gz
tar zvf alertmanager-0.24.0.linux-amd64.tar.gz alertmanager

```

安装监控MySQL
```
GRANT REPLICATION CLIENT, PROCESS ON *.* TO 'mysqld_exporter'@'127.0.0.1' identified by 'mysqld_exporter';
GRANT SELECT ON performance_schema.* TO 'mysqld_exporter'@'127.0.0.1';
flush privileges;

wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.14.0/mysqld_exporter-0.14.0.linux-amd64.tar.gz
tar zxvf mysqld_exporter-0.14.0.linux-amd64.tar.gz mysqld_exporter

vim .my.cnf
[client]
host=127.0.0.1
port=3306
user=mysqld_exporter
password=mysqld_exporter

vim /usr/lib/systemd/system/mysqld_exporter.service
[Unit]
Description=mysqld_exporter service

[Service]
User=root
ExecStart=/data/mysqld_exporter/mysqld_exporter --config.my-cnf=/data/mysqld_exporter/.my.cnf

TimeoutStopSec=10
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

systemctl daemon-reload
systemctl enable mysqld_exporter
systemctl restart mysqld_exporter

vim /opt/monitor/prometheus/prometheus.yml
  - job_name: 'mysqld-node'
    static_configs:
    - targets: ['192.168.1.235:9104']
      labels:
        instance: mysqld-node1

systemctl restart prometheus

导入MYSQL监控
dashboard id 7362
https://grafana.com/grafana/dashboards/7362
```

安装监控Redis
```
wget https://github.com/oliver006/redis_exporter/releases/download/v1.37.0/redis_exporter-v1.37.0.linux-amd64.tar.gz
tar -zxvf redis_exporter-v1.37.0.linux-amd64.tar.gz
mv redis_exporter-v1.37.0.linux-amd64 redis_exporter
vim /usr/lib/systemd/system/redis_exporter.service
[Unit]
Description=redis_exporter service

[Service]
User=root
ExecStart=/data/redis_exporter/redis_exporter -redis.addr redis://127.0.0.1:6379 -redis.password 123456

TimeoutStopSec=10
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

systemctl daemon-reload
systemctl enable redis_exporter
systemctl restart redis_exporter

vim /data/prometheus/prometheus.yml
  - job_name: 'redis-node'
    static_configs:
    - targets: ['ip:9121']
      labels:
        instance: redis-node1

systemctl restart prometheus
导入 Grafana ID: 4074 或者 14091
https://grafana.com/grafana/dashboards/4074
https://grafana.com/grafana/dashboards/14091

```

安装监控Elasticsearch
```
wget https://github.com/prometheus-community/elasticsearch_exporter/releases/download/v1.3.0/elasticsearch_exporter-1.3.0.linux-amd64.tar.gz
tar zxf elasticsearch_exporter-1.3.0.linux-amd64.tar.gz
mv elasticsearch_exporter-1.3.0.linux-amd64 elasticsearch_exporter
vim /usr/lib/systemd/system/elasticsearch_exporter.service
[Unit]
Description=elasticsearch_exporter service

[Service]
User=root
ExecStart=/data/elasticsearch_exporter/elasticsearch_exporter --es.uri=http://elastic:123456@127.0.0.1:9200

TimeoutStopSec=10
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

systemctl daemon-reload
systemctl enable elasticsearch_exporter
systemctl restart elasticsearch_exporter

vim /opt/prometheus/prometheus.yml
  - job_name: 'elasticsearch-node'
    static_configs:
    - targets: ['192.168.0.116:9114']
      labels:
        instance: elasticsearch-node1

这里提供一段通过公网https协议进行监控的配置项：
  - job_name: 'es-node'
    static_configs:
    - targets: ['mmbapoc.zhizhangyi.com:9070']
      labels:
        instance: es-node1
    scheme: https
    metrics_path: /es/node1
Nginx反向代理配置：
    location /es/node1 {
        proxy_pass   http://127.0.0.1:9114/metrics;
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

systemctl restart prometheus
导入 Grafana ID: 2322
https://grafana.com/grafana/dashboards/2322

```

