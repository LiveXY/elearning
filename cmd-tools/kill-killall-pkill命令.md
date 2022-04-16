kill
======
语法：kill[参数][进程号]
参数：
* -l  信号，若果不加信号的编号参数，则使用“-l”参数会列出全部的信号名称
* -a  当处理当前进程时，不限制命令名和进程号的对应关系
* -p  指定kill 命令只打印相关进程的进程号，而不发送任何信号
* -s  指定发送信号
* -u  指定用户
实例：
* kill -l 列出所有信号名称
```
 1) SIGHUP	 2) SIGINT	 3) SIGQUIT	 4) SIGILL	 5) SIGTRAP
 6) SIGABRT	 7) SIGBUS	 8) SIGFPE	 9) SIGKILL	10) SIGUSR1
11) SIGSEGV	12) SIGUSR2	13) SIGPIPE	14) SIGALRM	15) SIGTERM
16) SIGSTKFLT	17) SIGCHLD	18) SIGCONT	19) SIGSTOP	20) SIGTSTP
21) SIGTTIN	22) SIGTTOU	23) SIGURG	24) SIGXCPU	25) SIGXFSZ
26) SIGVTALRM	27) SIGPROF	28) SIGWINCH	29) SIGIO	30) SIGPWR
31) SIGSYS	34) SIGRTMIN	35) SIGRTMIN+1	36) SIGRTMIN+2	37) SIGRTMIN+3
38) SIGRTMIN+4	39) SIGRTMIN+5	40) SIGRTMIN+6	41) SIGRTMIN+7	42) SIGRTMIN+8
43) SIGRTMIN+9	44) SIGRTMIN+10	45) SIGRTMIN+11	46) SIGRTMIN+12	47) SIGRTMIN+13
48) SIGRTMIN+14	49) SIGRTMIN+15	50) SIGRTMAX-14	51) SIGRTMAX-13	52) SIGRTMAX-12
53) SIGRTMAX-11	54) SIGRTMAX-10	55) SIGRTMAX-9	56) SIGRTMAX-8	57) SIGRTMAX-7
58) SIGRTMAX-6	59) SIGRTMAX-5	60) SIGRTMAX-4	61) SIGRTMAX-3	62) SIGRTMAX-2
63) SIGRTMAX-1	64) SIGRTMAX
只有第9种信号(SIGKILL)才可以无条件终止进程，其他信号进程都有权利忽略。 下面是常用的信号：
HUP    1    终端断线
INT     2    中断（同 Ctrl + C）
QUIT    3    退出（同 Ctrl + \）
TERM   15    终止
KILL    9    强制终止
CONT   18    继续（与STOP相反， fg/bg命令）
STOP    19    暂停（同 Ctrl + Z）
```
* kill -0 pid 不发送任何信号，但是系统会进行错误检查。
* kill -9 `ps -ef | grep 'nginx' | grep -v grep | awk '{print $2}'` 杀死所有nginx进程
* ps -ef | grep 'nginx' | grep -v grep | awk '{print $2}' | xargs -L 1 kill -9 杀死所有nginx进程
* kill -9 $(ps -ef | grep nginx | grep -v grep | awk '{print $2}') 杀死所有nginx进程
* kill -u root 终止root运行的进程

killall命令
======
安装：yum install psmisc -y
语法：killall[参数][进程名]
选项：
-Z 只杀死拥有scontext 的进程
-e 要求匹配进程名称
-I 忽略小写
-g 杀死进程组而不是进程
-i 交互模式，杀死进程前先询问用户
-l 列出所有的已知信号名称
-q 不输出警告信息
-s 发送指定的信号
-v 报告信号是否成功发送
-w 等待进程死亡
--help 显示帮助信息
--version 显示版本显示
实例：
* killall nginx 或 killall -9 nginx 杀死所有nginx进程
* killall -TERM ngixn  或者  killall -KILL nginx 向进程发送指定信号

pkill
======
语法：pkill(选项)(参数)
选项：
* -c ctidlist　仅匹配列表中列出的ID的进程。
* -d delim　指定每一个匹配的进程ID之间分割字符串。如果没有 -d 选项指定，默认的是新行字符。-d 选项仅在pgrep命令中有效。
* -f正则表达式模式将执行与完全进程参数字符串 (从/proc/nnnnn/psinfo文件的pr_psargs字段获得)匹配。如果没有 -f 选项，表达式仅对执行文件名称(从/proc/nnnnn/psinfo文件pr_fname字段获得)匹配。
* -g pgrplist仅匹配进程组ID在给定列表中的进程。如果组0包括在列表中，这个被解释为pgrep或者pkill进程的组ID。
* -G gidlist仅匹配真实组ID在给定列表中的进程。每一个组ID可以使用组名称或者数字的组ID指定。
* -J projidlist匹配项目ID在给定列表中的进程。每一个项目ID可以使用项目的名称或者数字项目ID来指定。
* -l长格式输出。输出每一个匹配进程的名称连同进程ID。进程名称从pr_psargs 或者 pr_fname字段获得，依赖于-f选项是否指定。-l选项仅在pgrep命令中有效。
* -n匹配最新（最近生成的）符合所有其它匹配条件的进程。不能和-o选项一起使用。
* -o匹配最旧（最早生成的）符合所有其它匹配条件的进程。不能和-n选项一起使用。
* -P ppidlist 仅匹配给定列表中父进程ID的进程。
* -s sidlist 仅匹配进程会话ID在给定列表中的进程。如果ID 0在列表中，这个解释为pgrep或者pikill进程的会话ID。
* -t termlist　仅匹配与给定列表中终端关联的进程。每一个终端指定为在/dev中终端设备路径名称的后缀。例如term/a 或者 pts/0。
* -T taskidlist 仅匹配在给定列表中任务ID的进程。如果ID 0包括在列表中，这个解释为pgrep或者pikill进程的会话ID。
* -u euidlist 仅匹配有效用户ID在给定列表中的进程。每个用户ID可以通过一个登录名称或者数字的用户ID指定。
* -U uidlist 仅匹配真实的用户ID在给定列表中的进程。每个用户ID可以通过一个登录名称或者数字的用户ID指定。
* -v 反向匹配。匹配所有的进程除了符合匹配条件的。
* -x 仅认为进程其参数字符串或者执行文件名称正确匹配规定模式是匹配的进程。模式被认为是准确的当所有在进程参数字符串或者可执行文件名称的字符匹配模式。
* -z zoneidlist 仅匹配区域ID在给定列表中的进程。每一个区域ID可以使用一个区域名称或者一个数字的区域ID指定。这个选项仅在全局区域中执行有效。如果pkill程序用来往其它区域的进程发信号，进城必须宣称{PRIV_PROC_ZONE}特权。
* -signal 指定发往每一个匹配进程的信号。如果没有指定，SIGTERM 是默认的信号。-signal仅在pkill命令中作为第一个选项有效。信号可以是在signal.h中定义的没有SIG前缀的一个符号名字，也可是一个相应的信号数值。
实例：
* pkill -kill -t pts/3 踢掉pts/3这个用户
* pkill -9 nginx 杀死所有nginx进程
* pkill -u username 关闭指定用户的进程
* pkill -vu username 关闭非指定用户的其他用户进程

pkill
# 命令来完成强制活动用户退出.其中TTY表示终端名称
pkill -kill -t [TTY]


