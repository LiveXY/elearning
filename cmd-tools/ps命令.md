ps 命令
==========

功能说明：报告程序状况。
语法：ps [-aAcdefHjlmNVwy][acefghLnrsSTuvxX][-C <指令名称>][-g <群组名称>][-G <群组识别码>][-p <程序识别码>][p <程序识别码>][-s <阶段作业>][-t <终端机编号>][t <终端机编号>][-u <用户识别码>][-U <用户识别码>][U <用户名称>][-<程序识别码>][--cols <每列字符数>][--columns <每列字符数>][--cumulative][--deselect][--forest][--headers][--help][--info][--lines <显示列数>][--no-headers][--group <群组名称>][-Group <群组识别码>][--pid <程序识别码>][--rows <显示列数>][--sid <阶段作业>][--tty <终端机编号>][--user <用户名称>][--User <用户识别码>][--version][--width <每列字符数>]
补充说明：ps是用来报告程序执行状况的指令，您可以搭配kill指令随时中断，删除不必要的程序。
参数：
* `-a` 显示所有终端机下执行的程序，除了阶段作业领导者之外。
* `a` 显示现行终端机下的所有程序，包括其他用户的程序。
* `-A` 显示所有程序。
* `-c` 显示CLS和PRI栏位。
* `c` 列出程序时，显示每个程序真正的指令名称，而不包含路径，参数或常驻服务的标示。
* `-C<指令名称>` 指定执行指令的名称，并列出该指令的程序的状况。
* `-d` 显示所有程序，但不包括阶段作业领导者的程序。
* `-e` 此参数的效果和指定"A"参数相同。
* `e` 列出程序时，显示每个程序所使用的环境变量。
* `-f` 显示UID,PPIP,C与STIME栏位。
* `f` 用ASCII字符显示树状结构，表达程序间的相互关系。
* `-g<群组名称>` 此参数的效果和指定"-G"参数相同，当亦能使用阶段作业领导者的名称来指定。
* `g` 显示现行终端机下的所有程序，包括群组领导者的程序。
* `-G<群组识别码>` 列出属于该群组的程序的状况，也可使用群组名称来指定。
* `h` 不显示标题列。
* `-H` 显示树状结构，表示程序间的相互关系。
* `-j或j` 采用工作控制的格式显示程序状况。
* `-l或l` 采用详细的格式来显示程序状况。
* `L` 列出栏位的相关信息。
* `-m或m` 显示所有的执行绪。
* `n` 以数字来表示USER和WCHAN栏位。
* `-N` 显示所有的程序，除了执行ps指令终端机下的程序之外。
* `-p<程序识别码>` 指定程序识别码，并列出该程序的状况。
* `p<程序识别码>` 此参数的效果和指定"-p"参数相同，只在列表格式方面稍有差异。
* `r` 只列出现行终端机正在执行中的程序。
* `-s<阶段作业>` 指定阶段作业的程序识别码，并列出隶属该阶段作业的程序的状况。
* `s` 采用程序信号的格式显示程序状况。
* `S` 列出程序时，包括已中断的子程序资料。
* `-t<终端机编号>` 指定终端机编号，并列出属于该终端机的程序的状况。
* `t<终端机编号>` 此参数的效果和指定"-t"参数相同，只在列表格式方面稍有差异。
* `-T` 显示现行终端机下的所有程序。
* `-u<用户识别码>` 此参数的效果和指定"-U"参数相同。
* `u` 以用户为主的格式来显示程序状况。
* `-U<用户识别码>` 列出属于该用户的程序的状况，也可使用用户名称来指定。
* `U<用户名称>` 列出属于该用户的程序的状况。
* `v` 采用虚拟内存的格式显示程序状况。
* `-V或V` 显示版本信息。
* `-w或w` 采用宽阔的格式来显示程序状况。
* `x` 显示所有程序，不以终端机来区分。
* `X` 采用旧式的Linux i386登陆格式显示程序状况。
* `-y` 配合参数"-l"使用时，不显示F(flag)栏位，并以RSS栏位取代ADDR栏位。
* `-<程序识别码>` 此参数的效果和指定"p"参数相同。
* `--cols<每列字符数>` 设置每列的最大字符数。
* `--columns<每列字符数>` 此参数的效果和指定"--cols"参数相同。
* `--cumulative` 此参数的效果和指定"S"参数相同。
* `--deselect` 此参数的效果和指定"-N"参数相同。
* `--forest` 此参数的效果和指定"f"参数相同。
* `--headers` 重复显示标题列。
* `--help` 在线帮助。
* `--info` 显示排错信息。
* `--lines<显示列数>` 设置显示画面的列数。
* `--no-headers` 此参数的效果和指定"h"参数相同，只在列表格式方面稍有差异。
* `--group<群组名称>` 此参数的效果和指定"-G"参数相同。
* `--Group<群组识别码>` 此参数的效果和指定"-G"参数相同。
* `--pid<程序识别码>` 此参数的效果和指定"-p"参数相同。
* `--rows<显示列数>` 此参数的效果和指定"--lines"参数相同。
* `--sid<阶段作业>` 此参数的效果和指定"-s"参数相同。
* `--tty<终端机编号>` 此参数的效果和指定"-t"参数相同。
* `--user<用户名称>` 此参数的效果和指定"-U"参数相同。
* `--User<用户识别码>` 此参数的效果和指定"-U"参数相同。
* `--version` 此参数的效果和指定"-V"参数相同。
* `--widty<每列字符数>` 此参数的效果和指定"-cols"参数相同
常用方式及使用技巧：ps–ef |grep 12345

输出：
F 進程的標誌（flag），4表示用戶為超級用戶
S 進程的狀態（stat），各STAT的意義見下文
C CPU使用資源的百分比
PRI priority(優先級)的縮寫，
NI Nice值，
ADDR 核心功能，指出該進程在內存的那一部分，如果是運行的進程，一般都是“-”
SZ 用掉的內存的大小
WCHAN 當前進程是否正在運行，若為“-”表示正在運行
NI 进程的NICE值，数值大，表示较少占用CPU时间；
TIME 进程使用的总cpu时间
VSZ 进程所使用的虚存的大小（Virtual Size）
RSS 进程使用的驻留集大小或者是实际内存的大小，Kbytes字节
USER 进程的属主；
PID 进程的ID；
PPID 父进程；
%CPU 进程占用的CPU百分比；
%MEM 占用内存的百分比；
NI 进程的NICE值，数值大，表示较少占用CPU时间；
VSZ 該进程使用的虚拟內存量（KB）；
RSS 該進程占用的固定內存量（KB）（驻留中页的数量）；
TTY 該進程在那個終端上運行（登陸者的終端位置），若與終端無關，則顯示（？）。若為pts/0等，則表示由網絡連接主機進程
WCHAN 當前進程是否正在進行，若為-表示正在進行；
START 該進程被觸發启动时间；
TIME 該进程實際使用CPU運行的时间；
COMMAND 命令的名称和参数；

STAT 进程的状态：进程状态使用字符表示的（STAT的状态码）
R 运行 Runnable (on run queue) 正在运行或在运行队列中等待。
S 睡眠 Sleeping 休眠中, 受阻, 在等待某个条件的形成或接受到信号。
I 空闲 Idle
Z 僵死 Zombie（a defunct process) 进程已终止, 但进程描述符存在, 直到父进程调用wait4()系统调用后释放。
D 不可中断 Uninterruptible sleep (ususally IO) 收到信号不唤醒和不可运行, 进程必须等待直到有中断发生。
D 无法中断的休眠状态（通常 IO 的进程）；
T 终止 Terminate 进程收到SIGSTOP, SIGSTP, SIGTIN, SIGTOU信号后停止运行运行。
P 等待交换页
W 无驻留页 has no resident pages 没有足够的记忆体分页可分配。
X 死掉的进程
< 高优先级进程 高优先序的进程
N 低优先级进程 低优先序的进程
L 内存锁页 Lock 有记忆体分页分配并缩在记忆体内
s 进程的领导者（在它之下有子进程）；
l 多进程的（使用 CLONE_THREAD, 类似 NPTL pthreads）
+ 位于后台的进程组

实例：
* `ps -C node -O rss | grep hall` 查看大厅进程显示内存占用

* `ps -auxf | sort -nr -k 3 | head -10` 或 `ps -aux | sort -k3nr | head -10` 显示10个消耗cpu最多的进程
* `ps -eo %cpu,pid,user,args | awk 'NR>1' | sort -k1nr | head -10` 显示10个消耗cpu最多的进程
* `ps -eo '%C | %p | %z | %a' | sort -nr | head -10` 显示10个消耗cpu最多的进程
* `ps aux --sort=-%cpu | grep -m 11 -v whoami` 显示10个消耗cpu最多的进程

* `ps -auxf | sort -k4nr | head -10` 或 `ps -aux | sort -k4nr | head -10` 显示10个消耗内存最多的进程
* `ps -eo %mem,pid,user,args | awk 'NR>1' | sort -k1nr | head -10` 前10个站内存最高的进程
* `ps -eo '%C | %p | %z | %a' | sort -k5nr | head -10` 前10个站内存最高的进程
* `ps aux --sort=-%mem | grep -m 11 -v whoami` 前10个站内存最高的进程

* `ps aux |head -1; ps aux |grep -v PID |sort -k4rn |head -10` 显示10个换页最多的进程
* `ps aux |head -1 ;ps aux |sort -rn +3 |head -10` 显示10个消耗存储空间最多的进程


* `ps -ef | grep $USER` 当前用户名下运行的进程
* `ps -ef`  #看完整的进程信息
* `ps -eLf`  #如果每个进程不显示其中的线程，则L参数可以显示每个线程
* `ps -eo ppid,pid,user,args,%mem,vsz,rss --sort rss` #显示进程名，内存占用，虚拟内存，物理内存，并按照物理内存使用量排序
* `ps -eo ppid,pid,user,args,%mem,vsz,rss --sort vsz` #显示进程名，内存占用，虚拟内存，物理内存，并按照虚拟内存使用量排序(虚拟内存和物理内存使用很大都可能产生大量碎片)
* `ps -eo pid,user,wchan=WIDE-WCHAN-COLUMN -o s,cmd|awk ' $4 ~ /D/ {print $0}'` 查看哪个进程在iowait中
* `ps -ef | grep nginx` 显示UID,PPIP
* `ps -aux | grep nginx` 不显示PPID
* `ps -xj | grep nginx` 只查看主进程
* `ps aux | grep -v whoami` 不是由你运行的程序
检查当前僵尸进程信息
* `ps -ef | grep defunct`
* `ps -ef | grep defunct | grep -v grep | wc -l`
* `ps -ef | grep defunct | grep -v grep`
* `ps -ef | grep defunct | grep -v grep | awk '{print "kill -9 " $2,$3}'`
* `ps -ef | grep defunct | grep -v grep | awk '{print "kill -18 " $3}'`
杀死僵尸进程
* `ps -e -o ppid,stat | grep Z | cut -d" " -f2 | xargs kill -9`
kill -HUP `ps -A -ostat,ppid | grep -e '^[Zz]' | awk '{print $2}'`
清除僵死进程。
* `ps -eal | awk '{ if ($2 == "Z") {print $4}}' | kill -9`
* for x in `ps -aux | grep nginx | grep -v grep | awk '{ print $2 }'`;do ls /proc/$x/fd | wc -l;done 查看指定用户打开的文件数量
* `ps -ef | grep httpd | grep -v grep | wc -l` 或 `ps aux | grep httpd | grep -v grep | wc -l` 统计httpd协议连接数进程数
* `ps xH | grep nginx` 这样可以查看所有存在的线程。
* `ps -mp <PID>` 这样可以查看一个进程起的线程数。
* `ps aux | grep mysql | grep -v grep | awk '{print $2}' | xargs kill -9` 或 `pgrep mysql | xargs kill -9` 或 `killall -TERM mysqld` 如何杀掉mysql进程
* `ps aux | wc -l` 进程总数
* `ps aufx` 查看进程树
* `ps -eo pid,args,psr` 怎样知道某个进程在哪个CPU上运行？
查看PHP-CGI占用的内存总数：total=0; for i in `ps -C php-cgi -o rss=`; do total=$(($total+$i)); done; echo "PHP-CGI Memory usage: $total kb"

pkill
# 命令来完成强制活动用户退出.其中TTY表示终端名称
pkill -kill -t [TTY]

查看进程启动路径
ps auwxf

ps eww -p  XXXXX(进程号)
查看进程树找到服务器进程



