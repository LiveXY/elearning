netstat ss网络命令
==========
[netstat命令](#netstat命令)，[ss命令](#ss命令)

### netstat命令

netstat参数：
5.1	netstat(中级)
功能说明：显示网络状态。
语　　法：netstat [-acCeFghilMnNoprstuvVwx][-A<网络类型>][--ip]
补充说明：利用netstat指令可让你得知整个Linux系统的网络情况。
参　　数：
-a或--all 显示所有连线中的Socket。
-A<网络类型>或--<网络类型> 列出该网络类型连线中的相关地址。
-c或--continuous 持续列出网络状态。
-C或--cache 显示路由器配置的快取信息。
-e或--extend 显示网络其他相关信息。
-F或--fib 显示FIB。
-g或--groups 显示多重广播功能群组组员名单。
-h或--help 在线帮助。
-i或--interfaces 显示网络界面信息表单。
-l或--listening 显示监控中的服务器的Socket。
-M或--masquerade 显示伪装的网络连线。
-n或--numeric 直接使用IP地址，而不通过域名服务器。
-N或--netlink或--symbolic 显示网络硬件外围设备的符号连接名称。
-o或--timers 显示计时器。
-p或--programs 显示正在使用Socket的程序识别码和程序名称。
-r或--route 显示Routing Table。
-s或--statistice 显示网络工作信息统计表。
-t或--tcp 显示TCP传输协议的连线状况。
-u或--udp 显示UDP传输协议的连线状况。
-v或--verbose 显示指令执行过程。
-V或--version 显示版本信息。
-w或--raw 显示RAW传输协议的连线状况。
-x或--unix 此参数的效果和指定"-A unix"参数相同。
--ip或--inet 此参数的效果和指定"-A inet"参数相同。

* `-a` (all)显示所有选项，默认不显示LISTEN相关
* `-t` (tcp)仅显示tcp相关选项
* `-u` (udp)仅显示udp相关选项
* `-n` 拒绝显示别名，能显示数字的全部转化成数字
* `-l` 仅列出有在 Listen (监听) 的服務状态
* `-p` 显示建立相关链接的程序名
* `-r` 显示路由信息，路由表
* `-e` 显示扩展信息，例如uid等
* `-s` 按各个协议进行统计
* `-c` 每隔一个固定时间，执行该netstat命令
* `-i` 显示是否有网络错误或

netstat实例：
* 查看所有tcp监听端口：`netstat -tnlp`
* 查看所有监听端口：`netstat -tunlp`
* 查看所有已经建立的连接：`netstat -antp`
* 查看网络统计信息：`netstat -s`
* 查看：`netstat -i`
* 查看连接某服务端口最多的的IP地址：`netstat -nat | grep ':80' | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr | head -20`
* 网络连接数目：`netstat -an | grep -E "^(tcp)" | cut -c 68- | sort | uniq -c | sort -n`
* 按状态查看连接连接数量：`netstat -an|awk '/^tcp/{++S[$NF]}END{for(a in S) print a,S[a]}'`或`netstat -nat|awk '{print $6}'|sort|uniq -c|sort -rn`
* 按IP查看连接数量：`netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n`或`netstat -antu | awk '$5 ~ /[0-9]:/{split($5, a, ":"); ips[a[1]]++} END {for (ip in ips) print ips[ip], ip | "sort -k1 -nr"}'`
* 查看80端口的连接，并排序：`netstat -an -t | grep ':80' | grep ESTABLISHED | awk '{printf "%s %s\n",$5,$6}' | sort`
* 查看当前的memcache连接：`netstat -n | grep :11211`
* 查看占用端口8080的进程：`netstat -tnlp | grep 8080`或`lsof -i:8080`
* 查看所有php进程：`netstat -anp | grep php | grep ^tcp`
* 查看所有nginx进程：`netstat -anp | grep nginx | grep ^tcp`
* 查看80端口连接数最多的20个IP：`netstat -anlp|grep 80|grep tcp|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -nr|head -n20`
* 查找较多time_wait连接：`netstat -n|grep TIME_WAIT|awk '{print $5}'|sort|uniq -c|sort -rn|head -n20`
* 找查较多的SYN连接：`netstat -an | grep SYN | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr | more`
* 输出正在占用UDP和TCP端口的所有程序连带计时器信息：`netstat -putona`：
* 查看指定IP的连接：`netstat -nat | grep "192.168.1.222"`：
* `netstat -tunlpean`

php检查
* 计算开启worker进程数目 ps -ef | grep 'php-fpm'|grep -v 'master'|grep -v 'grep' |wc -l
* 计算正在使用的worker进程，正在处理的请求 netstat -anp | grep 'php-fpm'|grep -v 'LISTENING'|grep -v 'php-fpm.conf'|wc -l


### ss命令

```sh
yum install iproute -y
```

ss参数：
* `-h`, `--help`：显示帮助信息
* `-v`, `-V`, `--version`：显示指令版本信息
* `-n`, `--numeric`：不解析服务名称，以数字方式显示
* `-r`, `--resolve` 解析主机名称
* `-a`, `--all`：显示所有的套接字
* `-l`, `--listening`：显示处于监听状态的套接字
* `-o`, `--options`：显示计时器信息
* `-e`, `--extended` 显示详细的通讯端
* `-m`, `--memory`：显示套接字的内存使用情况
* `-p`, `--processes`：显示使用套接字的进程信息
* `-i`, `--info`：显示内部的TCP信息
* `-s`, `--summary` 显示通讯端使用概况
* `-4`, `--ipv4`：只显示ipv4的套接字
* `-6`, `--ipv6`：只显示ipv6的套接字
* `-0`, `--packet` 显示 PACKET 通讯端
* `-t`, `--tcp`：只显示tcp套接字
* `-u`, `--udp`：只显示udp套接字
* `-d`, `--dccp`：只显示DCCP套接字
* `-w`, `--raw`：仅显示RAW套接字
* `-x`, `--unix`：仅显示UNIX域套接字
* `-f`, `--family=FAMILY` 显示 FAMILY类型的通讯端（sockets），FAMILY可选，支援 unix, inet, inet6, link, netlink
* `-A`, `--query=QUERY`, `--socket=QUERY` QUERY := {all|inet|tcp|udp|raw|unix|packet|netlink}[,QUERY]
* `-D`, `--diag=FILE` 将原始TCP通讯端（sockets）资讯转储到档
* `-F`, `--filter=FILE` 从档中都去筛检程式资讯 FILTER := [ state TCP-STATE ] [ EXPRESSION ]

ss实例：
* `ss -a` 显示所有连接
* `ss -ta` 显示TCP连接
* `ss -ua` 显示所有UDP连接
* `ss -s` 显示Sockets摘要
* `ss -l` 列出所有打开的网络连接端口
* `ss -pl` 查看进程使用的socket
* `ss -pl | grep 3306` 找出打开套接字/端口应用程序
* `ss -o state established '( dport = :smtp or sport = :smtp )'` 显示所有状态为established的smtp连接
* `ss -o state established '( dport = :http or sport = :http )'` 显示所有状态为established的http连接
* `ss -o state fin-wait-1 '( sport = :http or sport = :https )'` dst 193.233.7/24 列举出 FIN-WAIT-1状态的源 80或者 443，目标网路 193.233.7/24所有 tcp
* `ss -4 state FILTER-NAME-HERE或ss -6 state` FILTER-NAME-HERE 用TCP 状态过滤Sockets, FILTER-NAME-HERE：established/syn-sent/syn-recv/fin-wait-1/fin-wait-2/time-wait/closed/close-wait/last-ack/listen/closing/all : 所有以上/connected : 除了listen and closed的所有状态/synchronized :所有已连接的状态除了syn-sent/bucket : 显示状态为maintained as minisockets,如：time-wait和syn-recv./big : 和bucket相反.
* `ss -4 state closing`
* 匹配远端地址和端口：`ss dst 192.168.1.5` `ss dst 192.168.119.113:http` `ss dst 192.168.119.113:smtp` `ss dst 192.168.119.113:443`
* 匹配本地地址和端口：`ss src 192.168.119.103` `ss src 192.168.119.103:http` `ss src 192.168.119.103:80` `ss src 192.168.119.103:smtp` `ss src 192.168.119.103:25`
* 将本地或者远端口比较 `ss dport OP PORT` `ss sport OP PORT` `ss dport OP PORT` 远端比较；`ss sport OP PORT` 本地比较。OP：<= or le : 小於或等於埠號、>= or ge : 大於或等於埠號、== or eq : 等於埠號、!= or ne : 不等於埠號、< or gt : 小於埠號、> or lt : 大於埠號
* 按状态查看连接连接数量：`ss -ant | awk '{++s[$1]} END {for(k in s) print k,s[k]}'`

# 列出所有网卡，包含ip以及mtu信息
ip link show
# 查看网卡ethX的统计信息
ip -h -s link show dev eth0
# 查看网卡最大ring_buffer和当前配置的ring_buffer大小
ethtool -g eth0

用途	net-tool/iproute2
地址和链路配置 ifconfig/ip addr,ip link
路由表 route/ip route
邻居 arp/ip neigh
VLAN vconfig/ip link
隧道 iptunnel/ip tunnel
组播 ipmaddr/ip maddr
统计 netstat/ss


监控总体带宽使用――nload、bmon、slurm、bwm-ng、cbm、speedometer和netload
监控总体带宽使用（批量式输出）――vnstat、ifstat、dstat和collectl
每个套接字连接的带宽使用――iftop、iptraf、tcptrack、pktstat、netwatch和trafshow
每个进程的带宽使用――nethogs

nload是一个命令行工具，让用户可以分开来监控入站流量和出站流量。
iftop -n可测量通过每一个套接字连接传输的数据
iptraf是一款交互式、色彩鲜艳的IP局域网监控工具。它可以显示每个连接以及主机之间传输的数据量。
nethogs是一款小巧的"net top"工具，可以显示每个进程所使用的带宽，并对列表排序，将耗用带宽最多的进程排在最上面。
bmon（带宽监控器）是一款类似nload的工具，它可以显示系统上所有网络接口的流量负载。
slurm是另一款网络负载监控器，可以显示设备的统计信息，还能显示ASCII图形。
tcptrack类似iftop，使用pcap库来捕获数据包，并计算各种统计信息，比如每个连接所使用的带宽。它还支持标准的pcap过滤器，这些过滤器可用来监控特定的连接。
vnstat与另外大多数工具有点不一样。它实际上运行后台服务/守护进程，始终不停地记录所传输数据的大小。之外，它可以用来制作显示网络使用历史情况的报告。
bwm-ng（下一代带宽监控器）是另一款非常简单的实时网络负载监控工具，可以报告摘要信息，显示进出系统上所有可用网络接口的不同数据的传输速度。
speedometer这是另一款小巧而简单的工具，仅仅绘制外观漂亮的图形，显示通过某个接口传输的入站流量和出站流量。
$ speedometer -r eth0 -t eth0
pktstat可以实时显示所有活动连接，并显示哪些数据通过这些活动连接传输的速度。它还可以显示连接类型，比如TCP连接或UDP连接；如果涉及HTTP连接，还会显示关于HTTP请求的详细信息。
$ sudo pktstat -i eth0 -nt
netwatch是netdiag工具库的一部分，它也可以显示本地主机与其他远程主机之间的连接，并显示哪些数据在每个连接上所传输的速度。
$ sudo netwatch -e eth0 -nt
trafshow与netwatch和pktstat一样，trafshow也可以报告当前活动连接、它们使用的协议以及每条连接上的数据传输速度。它能使用pcap类型过滤器，对连接进行过滤。只监控TCP连接
$ sudo trafshow -i eth0 tcp
netload命令只显示关于当前流量负载的一份简短报告，并显示自程序启动以来所传输的总字节量。没有更多的功能特性。它是netdiag的一部分。
ifstat能够以批处理式模式显示网络带宽。输出采用的一种格式便于用户使用其他程序或实用工具来记入日志和分析。
dstat是一款用途广泛的工具（用python语言编写），它可以监控系统的不同统计信息，并使用批处理模式来报告，或者将相关数据记入到CSV或类似的文件。这个例子显示了如何使用dstat来报告网络带宽。
collectl以一种类似dstat的格式报告系统的统计信息；与dstat一样，它也收集关于系统不同资源（如处理器、内存和网络等）的统计信息。这里给出的一个简单例子显示了如何使用collectl来报告网络使用/带宽。
$ collectl -sn -oT -i0.5

ping gping
Nmap nc瑞士军刀
nc -vz 192.168.1.2 8080
nc -v -v -w3 -z 192.168.1.2 8080-8083

tcpdump
tracert和traceroute

My Traceroute (MTR)
apt install mtr
yum install mtr
mtr qq.com
mtr -s 100 qq.com
mtr -c 100 qq.com
mtr -n qq.com
mtr -r qq.com

Mockoon
Wireshark
OpenVAS
Grey Matter
Dig命令
DNS和NS查找工具 nslookup
Speedtest-Plotter
Batfish
Fiddler
New Relic And Pingdom

获取本机ip地址
ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"

设置固定ip
ifconfig em1 192.168.5.177 netmask 255.255.255.0

网络排查
测试80端口延迟
hping3 -c 3 -S -p 80 google.com
hping3 -c 3 -S -p 80 192.168.0.30
wrk --latency -c 100 -t 2 --timeout 2 http://192.168.0.30/
tcpdump -nn tcp port 80 -w nginx.pcap
strace -f wrk --latency -c 100 -t 2 --timeout 2 http://192.168.0.30/
traceroute --tcp -p 80 -n google.com


