haproxy + keepalived 高可用配置
主haproxy 10.1.1.99
备haproxy 10.1.1.96
VIP 10.1.1.103

HA检测
```
vi /etc/keepalived/check_haproxy.sh
#!/bin/sh
if [ $(ps -C haproxy --no-header | wc -l) -eq 0 ]; then
	systemctl restart haproxy
	sleep 1
	if [ $(ps -C haproxy --no-header | wc -l) -eq 0 ]; then
		systemctl stop keepalived
	fi
fi
vi /etc/keepalived/clean_arp.sh
#!/bin/sh
VIP=$1
GATEWAY=10.1.1.100 # 本机的网卡网关地址
arping -I eth0 -c 5 -s $VIP $GATEWAY &>/dev/null

chmod u+x /etc/keepalived/check_haproxy.sh
chmod u+x /etc/keepalived/clean_arp.sh
```
安装keepalived必须开启
```
vi /etc/sysctl.conf
net.ipv4.ip_nonlocal_bind = 1 #忽略监听ip的检查
sysctl -p
```

主备haproxy配置更改
```
vi /etc/haproxy/haproxy.cfg
	bind *:80
更改为：
	bind 10.1.1.103:80
```

主haproxy 10.1.1.99 配置 keepalived
```
yum install keepalived -y

vi /etc/keepalived/keepalived.conf
global_defs {
	smtp_connect_timeout 30
	router_id LVS_HA01

	vrrp_skip_check_adv_addr
	#vrrp_strict
	vrrp_garp_interval 0
	vrrp_gna_interval 0
}
vrrp_script check_haproxy {
	script "/etc/keepalived/check_haproxy.sh"
	interval 3
	fall 3
	rise 2
}
vrrp_instance VI_HA {
	state MASTER
	interface eth1
	virtual_router_id 52
	priority 100
	advert_int 1
	#mcast_src_ip 10.1.1.99
	authentication {
		auth_type PASS
		auth_pass HA@@
	}
	virtual_ipaddress {
		10.1.1.103
		#10.1.1.103 dev eth1
		#10.1.1.103/24 brd 10.1.1.255 dev eth1 label eth1:1
	}
	track_script {
		check_haproxy
	}
	notify_master '/etc/keepalived/clean_arp.sh 10.1.1.103'
}
systemctl start keepalived.service
systemctl enable keepalived.service
```

备haproxy 10.1.1.96 配置 keepalived
```
yum install keepalived -y

vi /etc/keepalived/keepalived.conf
global_defs {
	smtp_connect_timeout 30
	router_id LVS_HA02
}
vrrp_script check_haproxy {
	script "/etc/keepalived/check_haproxy.sh"
	interval 3
	fall 3
	rise 2
}
vrrp_instance VI_HA {
	state BACKUP
	interface eth1
	virtual_router_id 52
	priority 90
	advert_int 1
	#mcast_src_ip 10.1.1.96
	authentication {
		auth_type PASS
		auth_pass HA@@
	}
	virtual_ipaddress {
		10.1.1.103
		#10.1.1.103 dev eth1
		#10.1.1.103/24 brd 10.1.1.255 dev eth1 label eth1:1
	}
	track_script {
		check_haproxy
	}
}
systemctl start keepalived.service
systemctl enable keepalived.service
```

Keepalived的非抢占模式的配置（无MASTER节点，全部依据优先级确定哪个节点进行工作）：
```
vi /etc/keepalived/keepalived.conf
global_defs {
	smtp_connect_timeout 30
	router_id LVS_HA01
}
vrrp_script check_haproxy {
	script "/etc/keepalived/check_haproxy.sh"
	interval 3
	fall 3
	rise 2
	weight -2 #节点数量有关
}
vrrp_instance VI_HA {
	state BACKUP
	interface eth1
	virtual_router_id 52
	nopreempt #设置为非抢占模式
	priority 100 #每个节点的优先级一定要不一样
	advert_int 1
	mcast_src_ip 10.1.1.99 #本机IP
	authentication {
		auth_type PASS
		auth_pass HA@@
	}
	virtual_ipaddress {
		10.1.1.103 dev eth1
	}
	track_script {
		check_haproxy
	}
}
systemctl start keepalived.service
systemctl enable keepalived.service
```

加入邮件提醒
```
global_defs {
	notification_email {
		acassen@firewall.loc
		failover@firewall.loc
		sysadmin@firewall.loc
	}
	notification_email_from Alexandre.Cassen@firewall.loc
	smtp_server 192.168.200.1
}
```

# 开通服务器间的 vrrp 协议通信，用于Keepalived通信：
firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 --in-interface eth1 -d 224.0.0.18 -p vrrp -j ACCEPT

firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 -d 224.0.0.0/8 -p vrrp -j ACCEPT
firewall-cmd --direct --permanent --add-rule ipv4 filter OUTPUT 0 -d 224.0.0.0/8 -p vrrp -j ACCEPT

firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 -d 224.0.0.18 -p vrrp -j ACCEPT
firewall-cmd --direct --permanent --add-rule ipv4 filter OUTPUT 0 -d 224.0.0.18 -p vrrp -j ACCEPT

firewall-cmd --reload

# Doc: http://www.keepalived.org/doc/scheduling_algorithms.html
# Round Robin (rr)
# Weighted Round Robin (wrr)
# Least Connection (lc)
# Weighted Least Connection (wlc)
# Locality-Based Least Connection (lblc)
# Locality-Based Least Connection with Replication (lblcr)
# Destination Hashing (dh)
# Source Hashing (sh)
# Shortest Expected Delay (seq)
# Never Queue (nq)
# Overflow-Connection (ovf)
virtual_server 10.1.1.103 443 {
	delay_loop 6
	lb_algo rr
	lb_kind NAT
	persistence_timeout 50
	protocol TCP
	real_server 10.1.1.99 443 {
		weight 1
		TCP_CHECK {
			connect_port 443
			connect_timeout 3
			nb_get_retry 3
			delay_before_retry 5
		}
	}
	real_server 10.1.1.96 443 {
		weight 1
		TCP_CHECK {
			connect_port 443
			connect_timeout 3
		}
	}
}


tcpdump -i eth1 -vvn arp
ip route

unicast_src_ip 172.20.27.10 #配置单薄的源地址
unicast_peer {
	#配置单薄的目标地址
}

