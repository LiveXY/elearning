lsof命令
==========
列出当前系统打开文件

```
lsof  [  -?abChKlnNOPRtUvVX ] [ -A A ] [ -c c ] [ +c c ] [ +|-d d ] [ +|-D D ] [
       +|-e s ] [ +|-f [cfgGn] ] [ -F [f] ] [ -g [s] ] [ -i [i] ] [ -k k ] [ +|-L [l] ]
       [  +|-m  m ] [ +|-M ] [ -o [o] ] [ -p s ] [ +|-r [t[m<fmt>]] ] [ -s [p:s] ] [ -S
       [t] ] [ -T [t] ] [ -u s ] [ +|-w ] [ -x [fl] ] [ -z [z] ] [ -Z  [Z]  ]  [  --  ]
       [names]
```

参数：
* 默认 : 没有选项，lsof列出活跃进程的所有打开文件
* `-a` 将结果进行“与”运算（而不是“或”运算）
* `-h` 显示帮助信息；
* `-v` 显示版本信息。
* `-n` 不将IP转换为hostname
* `-l` 在输出显示用户id而不是用户名
* `-t` 只显示进程PID
* `-U` 获取 UNIX 套接口地址
* `-c <进程名>` 列出指定进程所打开的文件；
* `-d <文件号>` 列出占用该文件号的进程；
* `+d <目录>` 列出目录下被打开的文件；
* `+D <目录>` 递归列出目录下被打开的文件；
* `-F` 格式化输出结果，用于其他命令。可以通过多种方式格式化，如-F pcfn（用户进程ID、命令名、文件描述符、文件名，并以空终止）
* `-g <组>` 列出组GID号进程详情；
* `-n <目录>` 列出使用NFS的文件；
* `-i <条件>` 列出符合条件的进程。（4、6、协议、:端口、 @ip ）
* `-p <进程号>` 列出指定进程号所打开的文件；
* `-u <账号>` 列出某用户或UID进程详情；
* `-r <秒>` 每几秒重复执行，+r当没有文件被打开的时候将自行结束，-r直到你中断它


输出：
COMMAND：进程的名称
PID：进程标识符
TID：
PPID：父进程标识符（需要指定-R参数）
PGID：进程组的ID编号（-g参数时可打开）
USER：进程所有者
FD：文件描述符，应用程序通过文件描述符识别该文件。如cwd、txt等
```
（1）cwd：表示current work dirctory，即：应用程序的当前工作目录，这是该应用程序启动的目录，除非它本身对这个目录进行更改
（2）txt ：该类型的文件是程序代码，如应用程序二进制文件本身或共享库，如上列表中显示的 /sbin/init 程序
（3）lnn：library references (AIX);
（4）er：FD information error (see NAME column);
（5）jld：jail directory (FreeBSD);
（6）ltx：shared library text (code and data);
（7）mxx ：hex memory-mapped type number xx.
（8）m86：DOS Merge mapped file;
（9）mem：memory-mapped file;
（10）mmap：memory-mapped device;
（11）pd：parent directory;
（12）rtd：root directory;
（13）tr：kernel trace file (OpenBSD);
（14）v86  VP/ix mapped file;
（15）0：表示标准输出
（16）1：表示标准输入
（17）2：表示标准错误
```
一般在标准输出、标准错误、标准输入后还跟着文件状态模式：r、w、u等
```
（1）u：表示该文件被打开并处于读取/写入模式
（2）r：表示该文件被打开并处于只读模式
（3）w：表示该文件被打开并处于
（4）空格：表示该文件的状态模式为unknow，且没有锁定
（5）-：表示该文件的状态模式为unknow，且被锁定
```
同时在文件状态模式后面，还跟着相关的锁
```
（1）N：for a Solaris NFS lock of unknown type;
（2）r：for read lock on part of the file;
（3）R：for a read lock on the entire file;
（4）w：for a write lock on part of the file;（文件的部分写锁）
（5）W：for a write lock on the entire file;（整个文件的写锁）
（6）u：for a read and write lock of any length;
（7）U：for a lock of unknown type;
（8）x：for an SCO OpenServer Xenix lock on part      of the file;
（9）X：for an SCO OpenServer Xenix lock on the      entire file;
（10）space：if there is no lock.
```
TYPE：文件类型，如DIR、REG等，常见的文件类型
```
（1）DIR：表示目录
（2）CHR：表示字符类型
（3）BLK：块设备类型
（4）UNIX： UNIX 域套接字
（5）FIFO：先进先出 (FIFO) 队列
（6）IPv4：网际协议 (IP) 套接字
```
DEVICE：指定磁盘的名称
SIZE/OFF：文件的大小
NODE：索引节点（文件在磁盘上的标识）
NAME：打开文件的确切名称


获取网络信息：
`lsof -n | awk '{print $2}'| sort | uniq -c | sort -nr | head` 显示前10个进程打开的文件句柄数量，`ps -aef | grep PID` 查看是那个进程
`lsof -i` 使用-i显示所有连接，可以替代netstat/ss
`lsof -i 6` 仅获取 IPv6 流量
`lsof -i:22` 查看端口22连接情况，逗号分隔多个端口
`lsof -iTCP` 仅显示TCP连接（同理可获得 UDP 连接）
`lsof -i@localhost:38526` 使用@host来显示指定到指定主机的连接
`lsof -i | grep -i LISTEN`、`lsof -i -sTCP:LISTEN` 找出监听端口
`lsof -i | grep -i ESTABLISHED`、`lsof -i -sTCP:ESTABLISHED` 找出已建立的连接
获取用户信息:
`lsof -u memcached` 使用-u显示指定用户打开了什么
`lsof -u ^memcached` 使用-u ^user来显示除指定用户以外的其他所有用户所做的事情
`kill -9 'lsof -t -u memcached'` 杀死指定用户所做的一切事情
`lsof -g gname/gid` 显示归属组gname或gid的进程情况
进程：
`lsof -c mongod -c MMO_GameServer` 查看命令打开了什么
`lsof -p 10075 -p 1111` 查看进程ID打开了什么
`lsof -c mongod -u ^root` //显示出那些文件被以courier打头的进程打开，但是并不属于用户zahn
文件目录：
`lsof /var/log/messages` 查看文件被谁在使用
`lsof +d /var/log/` 查看目录被谁在使用
`lsof +D /var/log/` 查看目录被谁在使用（包含子目录）
`lsof /dev/tty1` 查看文件、设备被哪些进程占用
`lsof -d 4` 显示使用fd为4的进程
`lsof /dev/cdrom` 那个进程在占用光驱
`lsof -a -u root -d txt` 查看所属root用户进程所打开的文件类型为txt的文件,0表示标准输入，1表示标准输出，2表示标准错误，从而可知：所以大多数应用程序所打开的文件的 FD 都是从 3 开始
高级
`lsof +L1` 显示被删除的文件

