find which type whereis locate
=====

which [文件...]
======
which命令的作用是，在PATH变量指定的路径中，搜索某个系统命令的位置，并且返回第一个搜索结果。
参 数：
* `-n<文件名长度>` 指定文件名长度，指定的长度必须大于或等于所有文件中最长的文件名。
* `-p<文件名长度>` 与-n参数相同，但此处的<文件名长度>包括了文件的路径。
* `-w` 指定输出时栏位的宽度。
* `-V` 显示版本信息

type命令其实不能算查找命令，它是用来区分某个命令到底是由shell自带的，还是由shell外部的独立二进制文件提供的。如果一个命令是外部命令，那么使用-p参数，会显示该命令的路径，相当于which命令

whereis
======
命令用来查找命令的位置，包括执行文件、源代码和手册页文件。如果要查找任意文件的所在位置，可以使用locate或者find命令。使用说明如下
whereis [-bfmsu][-B ...][-M ...][-S ...][文件...]
* `-b` 只查找二进制文件。
* `-B` 只在设置的目录下查找二进制文件。
* `-f` 不显示文件名前的路径名称。
* `-m` 只查找说明文件。
* `-M` 只在设置的目录下查找说明文件。
* `-s` 只查找原始代码文件。
* `-S` 只在设置的目录下查找原始代码文件。
* `-u` 查找不包含指定类型的文件

find
======
最强大的文件搜索命令，命令使用方式如下
find [PATH] [option] [action]
常用的参数查找方式
时间查找参数：
-atime n :将n*24小时内存取过的的文件列出来
-ctime n :将n*24小时内改变、新增的文件或者目录列出来
-mtime n :将n*24小时内修改过的文件或者目录列出来
-newer file ：把比file还要新的文件列出来
名称查找参数：
-gid n       ：寻找群组ID为n的文件
-group name  ：寻找群组名称为name的文件
-uid n       ：寻找拥有者ID为n的文件
-user name   ：寻找用户者名称为name的文件
-name file   ：寻找文件名为file的文件（可以使用通配符）

find ./ -name *.log
find ./ -size +204800 = 100M
find /home -user file
find ./ -mmin -120
cmin/amin/mmin 分钟为单位
ctime/atime/mtime 天为单位
c修改 a访问 m修改
在/etc下查找24小时内被修改过属性的文件和目录
find /etc -size +163840 -a -size -204800

在/etc下查找大于80mb小于100mb的文件
find /etc -name inittab -exec ls -l{} \


find . -type f -size +800M
find / -size +10M -exec du -h {} \;
* `find /home/sh_laravel/ -name *.php | xargs grep -RPnDskip "(php|passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|readfile) *\("` 查看文件内容是否包含不安全代码

从根目录查找大于50MB的文件，并按大小列表显示前10个：
find / -printf "%k %p\n"|sort -g -k 1,1|\awk '{if($1>50000) print $1/1024 "MB" " " $2}'|tail -n 10

从当前目录开始, 查找本目录下大于10M的文件并显示详细信息：
find . -size +10000000c -exec ls -lh {} \;

find . ( -name "*.txt"-o -name "*.pdf") -print
find . -regex ".*(.txt|.pdf)$"
find . ! -name "*.txt"
find . -maxdepth 1 -type f
find . -type d -print  //只列出所有目录
find . -atime 7 -type f -print
find . -type f -size +2k
find . -type f -perm 644
find . -type f -user weber -print //找用户weber所拥有的文件
find . -type f -name "*.swp" -delete //删除当前目录下所有的swp文件：
find . -type f -user root -exec chown weber {} ; //将当前目录下的所有权变更为weber
find . -type f -mtime +10 -name "*.txt" -exec cp {} OLD ; //将找到的文件全都copy到另一个目录

du -h
du -h --max-depth=1 快速的了解哪些目录变得比较大
du -hm --max-depth=2 | sort -nr | head -12
df

locate命令其实是"find -name"的另一种写法，但是要比后者快得多，原因在于它不搜索具体目录，而是搜索一个数据库（/var/lib/locatedb），这个数据库中含有本地所有文件信息。Linux系统自动创建这个数据库，并且每天自动更新一次，所以使用locate命令查不到最新变动过的文件。为了避免这种情况，可以在使用locate之前，先使用updatedb命令，手动更新数据库。
locate命令的使用实例：
$ locate /etc/sh
搜索etc目录下所有以sh开头的文件。
$ locate ~/m
搜索用户主目录下，所有以m开头的文件。
$ locate -i ~/m
搜索用户主目录下，所有以m开头的文件，并且忽略大小写。

fd 标准库
cargo install fd-find
# 转换 所有 jpg 到  png :
fd -e jpg -x convert {} {.}.png
# Unpack all zip files (if no placeholder is given, the path is appended):
fd -e zip -x unzip
# Convert all flac files into opus files:
fd -e flac -x ffmpeg -i {} -c:a libopus {.}.opus
# Count the number of lines in Rust files (the command template can be terminated with ';'):
fd -x wc -l \; -e rs
USAGE:
    fd [FLAGS/OPTIONS] [<pattern>] [<path>...]
FLAGS:
    -H, --hidden            搜索隐藏的文件和目录
    -I, --no-ignore         不要忽略 .(git | fd)ignore 文件匹配
        --no-ignore-vcs     不要忽略.gitignore文件的匹配
    -s, --case-sensitive    区分大小写的搜索（默认值：智能案例）
    -i, --ignore-case       不区分大小写的搜索（默认值：智能案例）
    -F, --fixed-strings     将模式视为文字字符串
    -a, --absolute-path     显示绝对路径而不是相对路径
    -L, --follow            遵循符号链接
    -p, --full-path         搜索完整路径（默认值：仅限 file-/dirname）
    -0, --print0            用null字符分隔结果
    -h, --help              打印帮助信息
    -V, --version           打印版本信息
OPTIONS:
    -d, --max-depth <depth>        设置最大搜索深度（默认值：无）
    -t, --type <filetype>...       按类型过滤：文件（f），目录（d），符号链接（l），
                                   可执行（x），空（e）
    -e, --extension <ext>...       按文件扩展名过滤
    -x, --exec <cmd>               为每个搜索结果执行命令
    -E, --exclude <pattern>...     排除与给定glob模式匹配的条目
        --ignore-file <path>...    以.gitignore格式添加自定义忽略文件
    -c, --color <when>             何时使用颜色：never，*auto*, always
    -j, --threads <num>            设置用于搜索和执行的线程数
    -S, --size <size>...           根据文件大小限制结果。
ARGS:
    <pattern>    the search pattern, a regular expression (optional)
    <path>...    the root directory for the filesystem search (optional)


