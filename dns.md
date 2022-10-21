
搭建DNS
```
apt install bind9
2. 修改bind9配置文件

修改bind的主配置文件 /etc/bind/named.conf.options

增加或修改 forwarders 服务器地址，并增加 rpz zone。 可参考我的配置文件

options {
         directory "/var/cache/bind";
         version "nicai?";     

         forwarders {
                # 我的网络需要IPv6，所以配置了IPv6的DNS服务器地址，不需要的删除即可
                # 然后替换为性能好的、或者绿色的，总之能让你开心的DNS服务商地址
                2001:4860:4860::8888; 
                2001:4860:4860::8844;  
                8.8.8.8;
                8.8.4.4;
                2400:3200::1;
                223.6.6.6;
                2409:803c:2000:1::26;
                211.137.191.26;
         };

        listen-on { any; };
        listen-on-v6 { any; };
        dnssec-validation no;  # 是否开启验证
        recursion yes;  
        response-policy{zone "rpz";}; # 增加响应策略
        allow-query { any;};

};
修改 /etc/bind/named.conf.default-zones 文件，增加黑名单zone

zone "rpz"{
        type master;
        file "/etc/bind/db.rpz.blacklist";
        allow-update{none;};
        allow-transfer{none;};
        allow-query{none;};
};
3. 处理广告黑名单

创建mkADdomains.sh 文件，该脚本实现从https://anti-ad.net/上自动下载广告的黑名单列表，然后生成bind使用的格式。脚本内容如下：

$ cat mkADdomains.sh
#!/bin/bash

curl https://anti-ad.net/domains.txt > domains.txt
title=`head -n 1 domains.txt`
if [ "$title" = "#TITLE=anti-AD" ]; then
        tail -n +5 domains.txt > d.txt
        rm domains.txt
        sed -i "s/$/&   IN CNAME @/g" d.txt
        sed -i "s/^\.//g" d.txt
        tail -n -13 /etc/bind/db.rpz.blacklist >> d.txt
        sort -u d.txt
        head -n 13 /etc/bind/db.rpz.blacklist > db.rpz.blacklist
        cat d.txt  >> db.rpz.blacklist
        rm d.txt
        echo "Create block domains done !"
else
        echo "Invalid data!"
fi

4. 把生成的 db.rpz.blacklist 文件复制到 /etc/bind/db.rpz.blacklist 。

5. 重新加载配置文件或重启服务

# 重新加载配置文件
$ sudo rndc reload
server reload successful 

# 重启服务，如有必要
 sudo systemctl restart bind9 

最后把光猫上的主DNS设置为这台电脑的IP，就可以实现家庭所有设备过滤广告了。
```

测试：
```
ping mbd.baidu.com
dig mbd.baidu.com
nslookup mbd.baidu.com
drill mbd.baidu.com | grep "Query time"
dig mbd.baidu.com +dnssec @114.114.114.114
DNSPod DNS+	 119.29.29.29/182.254.116.116
dig mbd.baidu.com +dnssec @119.29.29.29
阿里CDN 223.5.5.5/223.6.6.6
dig mbd.baidu.com +dnssec @223.5.5.5
dig mbd.baidu.com +dnssec @8.8.8.8
dig mbd.baidu.com +dnssec @8.8.4.4
CNNIC SDNS：1.2.4.8/210.2.4.8
香港：速度极快 40-50ms 202.181.202.140/202.181.224.2
澳门：速度极快 40-50ms 202.175.3.8/202.175.3.3
台湾：速度极快 40-50ms 168.95.192.1/168.95.1.1
移动 219.141.136.10
百度 180.76.76.76
oneDNS	117.50.11.11/52.80.66.66
DNS 派电信/移动/铁通	101.226.4.6/218.30.118.6
DNS 派联通	123.125.81.6/140.207.198.6
CloudflareDNS	1.1.1.1/1.0.0.1
IBM Quad	9.9.9.9
DNS.SB	185.222.222.222/185.184.222.222
OpenDNS	208.67.222.222/208.67.220.220
V2EX DNS	199.91.73.222/178.79.131.110
湖北电信 DNS	202.103.24.68/202.103.0.68
微步在线onedns
拦截版：117.50.11.11 52.80.66.66
纯净版：117.50.10.10 52.80.52.52
家庭版：117.50.60.30 52.80.60.30
```

dnsmasq
```
yum install dnsmasq -y
dnsmasq -test
ss -ntl
rpm -qc dnsmasq
systemctl enable dnsmasq.service
systemctl start dnsmasq.service
dnsmasq -v 

vim /etc/dnsmasq.conf
#no-hosts
listen-address=192.168.88.1,127.0.0.1,::1
resolv-file=/etc/resolv.dnsmasq.conf
addn-hosts=/etc/hosts
addn-hosts=/etc/myhosts
conf-dir=/etc/dnsmasq.d
cache-size=10000
strict-order
address=/mbd.baidu.com/127.0.0.1
#server=/cn/114.114.114.114
#server=/taobao.com/114.114.114.114

只能配置2个域名服务器
vi /etc/resolv.conf
nameserver 192.168.88.1
nameserver 192.168.1.1

可配置3个以上域名服务器
vi /etc/resolv.dnsmasq.conf
nameserver 192.168.88.1
nameserver 192.168.1.1
nameserver 114.114.114.114
nameserver 119.29.29.29
nameserver 219.141.136.10
nameserver 8.8.8.8
nameserver 8.8.4.4

cd /etc/dnsmasq.d/
wget https://anti-ad.net/anti-ad-for-dnsmasq.conf

dnsmasq -test

```

OpenWrt dnsmasq
```
cat /tmp/resolv.conf.d/resolv.conf.auto
# Interface wan6
nameserver fe80::1%eth3
# Interface wan
nameserver 192.168.1.1
cat /tmp/resolv.conf
search lan
nameserver 127.0.0.1
nameserver ::1
/etc/dnsmasq.conf
/etc/dnsmasq.d/
ll /tmp/dnsmasq.d/
cd /tmp/dnsmasq.d/dnsmasq-ssrplus.d/
wget https://anti-ad.net/anti-ad-for-dnsmasq.conf
cat /usr/share/dnsmasq/rfc6761.conf
# RFC6761 included configuration file for dnsmasq
#
# includes a list of domains that should not be forwarded to Internet name servers
# to reduce burden on them, asking questions that they won't know the answer to.
server=/bind/
server=/invalid/
server=/local/
server=/localhost/
server=/onion/
server=/test/
cat /usr/share/dnsmasq/dhcpbogushostname.conf
# dhcpbogushostname.conf included configuration file for dnsmasq
#
# includes a list of hostnames that should not be associated with dhcp leases
# in response to CERT VU#598349
# file included by default, option dhcpbogushostname 0  to disable
dhcp-name-match=set:dhcp_bogus_hostname,localhost
dhcp-name-match=set:dhcp_bogus_hostname,wpad
cat /var/etc/dnsmasq.conf.cfg01411c
# auto-generated config file from /etc/config/dhcp
conf-file=/etc/dnsmasq.conf
dhcp-authoritative
domain-needed
localise-queries
read-ethers
enable-ubus=dnsmasq
expand-hosts
enable-tftp
bind-dynamic
local-service
filter-aaaa
port=53
domain=lan
local=/lan/
addn-hosts=/tmp/hosts
addn-hosts=/etc/myhosts
dhcp-leasefile=/tmp/dhcp.leases
tftp-root=/root
dhcp-boot=pxelinux.0
resolv-file=/tmp/resolv.conf.d/resolv.conf.auto
stop-dns-rebind
rebind-localhost-ok
dhcp-broadcast=tag:needs-broadcast
conf-dir=/tmp/dnsmasq.d
user=dnsmasq
group=dnsmasq
dhcp-ignore-names=tag:dhcp_bogus_hostname
conf-file=/usr/share/dnsmasq/dhcpbogushostname.conf
srv-host=_vlmcs._tcp,OpenWrt,1688,0,100
bogus-priv
conf-file=/usr/share/dnsmasq/rfc6761.conf
dhcp-range=set:lan,192.168.88.100,192.168.88.249,255.255.255.0,12h
no-dhcp-interface=eth3
cat /tmp/dhcp.leases
1666408324 5c:02:14:e5:30:c3 192.168.88.150 MiWiFi-RA72 *
cat /etc/config/dhcp

config dnsmasq
	option domainneeded '1'
	option localise_queries '1'
	option rebind_protection '1'
	option rebind_localhost '1'
	option local '/lan/'
	option domain 'lan'
	option expandhosts '1'
	option authoritative '1'
	option readethers '1'
	option leasefile '/tmp/dhcp.leases'
	option nonwildcard '1'
	option localservice '1'
	option filter_aaaa '1'
	option localuse '1'
	option enable_tftp '1'
	option dhcp_boot 'pxelinux.0'
	option tftp_root '/root'
	list addnhosts '/etc/myhosts'
	option resolvfile '/tmp/resolv.conf.d/resolv.conf.auto'
	option port '53'
	option noresolv '0'

config dhcp 'lan'
	option interface 'lan'
	option start '100'
	option limit '150'
	option leasetime '12h'
	option force '1'
	option ra_slaac '1'
	list ra_flags 'managed-config'
	list ra_flags 'other-config'

config dhcp 'wan'
	option interface 'wan'
	option ignore '1'

config odhcpd 'odhcpd'
	option maindhcp '0'
	option leasefile '/tmp/hosts/odhcpd'
	option leasetrigger '/usr/sbin/odhcpd-update'
	option loglevel '4'

config srvhost
	option srv '_vlmcs._tcp'
	option target 'OpenWrt'
	option port '1688'
	option class '0'
	option weight '100'

```

smartdns
```
https://github.com/xiaomi-sa/smartdns
https://anti-ad.net/anti-ad-for-smartdns.conf
```

adguard
```
https://anti-ad.net/adguard.txt
```
