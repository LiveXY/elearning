linux 常用命令

1 目录与文件操作
1.1	ls(初级)
使用权限：所有人
功能 : 显示指定工作目录下之内容（列出目前工作目录所含之档案及子目录)。
参数 :
-a 显示所有档案及目录 (ls内定将档案名或目录名称开头为"."的视为隐藏档，不会列出)
-l 除档案名称外，亦将档案型态、权限、拥有者、档案大小等资讯详细列出
-r 将档案以相反次序显示(原定依英文字母次序)
-t 将档案依建立时间之先后次序列出
-A 同 -a ，但不列出 "." (目前目录) 及 ".." (父目录)
-F 在列出的档案名称后加一符号；例如可执行档则加 "*", 目录则加 "/"
-R 若目录下有档案，则以下之档案亦皆依序列出
-h 使打印结果易于使用者查看(human readable)
-s 显示文件大小
-S 以大小进行排序
-L 显示文件链接名
范例：
列出目前工作目录下所有名称是 s 开头的档案，愈新的排愈后面 :
　　 ls -ltr s*
　　将 /bin 目录以下所有目录及档案详细资料列出 :
　　 ls -lR /bin
　　列出目前工作目录下所有档案及目录；目录于名称后加 "/", 可执行档于名称后加*
　　 ls –AF
常用方式及使用技巧：
　　ls –l 以列表形式输出当前目录中存在的文件
　　ls –lt 按照修改时间倒序排序，即最新的在最上面展示
1.2 ll(初级)
ls –l的缩写形式
cd(初级)
使用权限 : 所有使用者
使用方式 : cd [dirName]
说明 : 变换工作目录至 dirName。 其中 dirName 表示法可为绝对路径或相对路径。若目录名称省略，则变换至使用者的 home directory (也就是刚 login 时所在的目录)。
另外，"~" 也表示为 home directory 的意思，"." 则是表示目前所在的目录，".." 则表示目前目录位置的上一层目录。
范例 : 跳到 /usr/bin/ : cd /usr/bin
跳到自己的 home directory : cd ~
跳到目前目录的上上两层 : cd ../..
返回进入当前目录前所在目录：cd -
常用方式及使用技巧：~表示当前用户的家目录，另外需要大家关注相对路径以及绝对路径的概念
1.3 pwd(初级)
功能：显示当前工作目录
范例：$pwd
常用方式及使用技巧:手动打补丁上传补丁文件时通常先在服务端找到该文件，然后使用pwd将路径输出并且拷贝，然后将路径粘贴到ftp工具的路径栏中
1.4 mkdir(初级)
名称： mkdir
使用权限：于目前目录有适当权限的所有使用者
使用方式：mkdir [-p] dirName
说明：建立名称为 dirName 之子目录。
参数：-p 确保目录名称存在，不存在的就建一个。
范例：
在工作目录下，建立一个名为 AAA 的子目录 :
mkdir AAA
在工作目录下的 BBB 目录中，建立一个名为 Test 的子目录。若 BBB 目录原本不存在，则建立一个。（注：本例若不加 -p，且原本 BBB目录不存在，则产生错误。）
mkdir -p BBB/Test
1.5 rmdir(初级)
功能说明：删除目录。
语　　法：rmdir [-p][--help][--ignore-fail-on-non-empty][--verbose][--version][目录...]
补充说明：当有空目录要删除时，可使用rmdir指令。
参　　数：
-p或--parents 删除指定目录后，若该目录的上层目录已变成空目录，则将其一并删除。
1.6	rm(初级)
功能说明：删除文件或目录。
语　　法：rm [-dfirv][--help][--version][文件或目录...]
补充说明：执行rm指令可删除文件或目录，如欲删除目录必须加上参数"-r"，否则预设仅会删除文件。
参　　数：
　-d或--directory 　直接把欲删除的目录的硬连接数据删成0，删除该目录。
　-f或--force 　强制删除文件或目录。
　-i或--interactive 　删除既有文件或目录之前先询问用户。
　-r或-R或--recursive 　递归处理，将指定目录下的所有文件及子目录一并处理。

注意：在使用rm –rf * 命令前请使用pwd确定当前目录，以免发生误删除

1.7	head(初级)
功能说明：看一个文件的头几行
语法：head –n filename
参数：
-n ：后面接数字，代表显示几行的意思
-c number 显示前几个字节

常用方式及使用技巧：$head -10 error.log

1.8	more(初级)
功能说明：一页一页的显示文件的内容
语法：more filename
使用方式：
空格键 (space)：代表向下翻一页；
Enter ：代表向下翻『一行』；
/字符串 ：代表在这个显示的内容当中，向下搜寻『字符串』；
:f ：立刻显示出文件名以及目前显示的行数；
q ：代表立刻离开 more ，不再显示该档案内容。

常用方式及使用技巧:#ifconfig –a | more

more [option] [filename]
+n 从第n行开始显示
-n 定义屏幕大小为n行
+/pattern 再显示前按pattern匹配子串并显示
-s 把连续的多个空行显示为一行
常用操作命令：
Enter 向下n行，默认为1行
Ctrl+F 跳过一屏
Ctrl+B 返回上一屏
空格键 向下滚动一屏
= 输出当前行的行号
在more模式中回车，输入/pattern可以持续向下搜索

1.9	less(初级)
功能说明：less 与 more 类似，但是比 more 更好的是，他可以往前翻页！
语法：less filename
使用方式：
空格键 ：向下翻动一页；
[pagedown]：向下翻动一页；
[pageup] ：向上翻动一页；
/字符串 ：向下搜寻『字符串』的功能；
?字符串 ：向上搜寻『字符串』的功能；
n ：重复前一个搜寻 (与 / 或 ? 有关！)
N ：反向的重复前一个搜寻 (与 / 或 ? 有关！)
q ：离开 less 这个程序；

常用方式及使用技巧:less error.log
－N 显示每行的行号
-i 忽略搜索时的大小写
-s 将连续空行显示为一行
-m 显示百分比
常用操作命令：
/字符串 向下搜索“字符串”功能
?字符串 向上搜索“字符串”功能
n 重复前一个搜索
空格键 滚动一页
d 滚动半页
b 回溯一页
y 回溯一行
q 退出less命令

1.10	tail(初级)
功能说明：看一个文件末尾n行
语法：tail [ -f ] [ -c Number | -n Number | -m Number | -b Number | -k Number ] [ File ]
使用说明：tail 命令从指定点开始将 File 参数指定的文件写到标准输出。如果没有指定文件，则会使用标准输入。 Number 变量指定将多少单元写入标准输出。 Number 变量的值可以是正的或负的整数。如果值的前面有 +（加号），从文件开头指定的单元数开始将文件写到标准输出。如果值的前面有 -（减号），则从文件末尾指定的单元数开始将文件写到标准输出。如果值前面没有 +（加号）或 -（减号），那么从文件末尾指定的单元号开始读取文件。
主要参数：
-f 如果输入文件是常规文件或如果 File 参数指定 FIFO（先进先出），那么 tail 命令不会在复制了输入文件的最后的指定单元后终止，而是继续从输入文件读取和复制额外的单元（当这些单元可用时）。如果没有指定 File 参数，并且标准输入是管道，则会忽略 -f 标志。tail -f 命令可用于监视另一个进程正在写入的文件的增长。
-n Number 从首行或末行位置来读取指定文件，位置由 Number 变量的符号（+ 或 - 或无）表示，并通过行号 Number 进行位移。

常用方式及使用技巧:tail –f error.log

1.11	cp(初级)
功能说明：复制文件或目录。
语　　法：cp [-abdfilpPrRsuvx][-S <备份字尾字符串>][-V <备份方式>][--help][--spares=<使用时机>][--version][源文件或目录][目标文件或目录] [目的目录]
补充说明：cp指令用在复制文件或目录，如同时指定两个以上的文件或目录，且最后的目的地是一个已经存在的目录，则它会把前面指定的所有文件或目录复制到该目录中。若同时指定多个文件或目录，而最后的目的地并非是一个已存在的目录，则会出现错误信息。
参　　数：
　-r 　递归处理，将指定目录下的文件与子目录一并处理。
　-R或--recursive 　递归处理，将指定目录下的所有文件与子目录一并处理。

常用方式及使用技巧:cp server.xml ../bak

cp -ruv test1 test2 拷贝test1中的新的文件到test2目录 -r 是“递归”， -u 是“更新”，-v 是“详细”
cp --force --backup=numbered test1.py test1.py 带编号的连续备份


1.12	mv(初级)
功能说明：移动或更名现有的文件或目录。
语　　法：mv [-bfiuv][--help][--version][-S <附加字尾>][-V <方法>][源文件或目录][目标文件或目录]
补充说明：mv可移动文件或目录，或是更改文件或目录的名称。
参　　数：
　-b或--backup 　若需覆盖文件，则覆盖前先行备份。
　-f或--force 　若目标文件或目录与现有的文件或目录重复，则直接覆盖现有的文　件或目录。
　-i或--interactive 　覆盖前先行询问用户。

常用方式及使用技巧：mv server.xml server.xml_bak

1.13	chmod(初级)
功能说明：变更文件或目录的权限。
语　　法：chmod [-cfRv][--help][--version][<权限范围>+/-/=<权限设置...>][文件或目录...] 或 chmod [-cfRv][--help][--version][数字代号][文件或目录...] 或 chmod [-cfRv][--help][--reference=<参考文件或目录>][--version][文件或目录...]
补充说明：在UNIX系统家族里，文件或目录权限的控制分别以读取，写入，执行3种一般权限来区分，另有3种特殊权限可供运用，再搭配拥有者与所属群组管理权限范围。您可以使用chmod指令去变更文件与目录的权限，设置方式采用文字或数字代号皆可。符号连接的权限无法变更，如果您对符号连接修改权限，其改变会作用在被连接的原始文件。权限范围的表示法如下：
　u：User，即文件或目录的拥有者。
　g：Group，即文件或目录的所属群组。
　o：Other，除了文件或目录拥有者或所属群组之外，其他用户皆属于这个范围。
　a：All，即全部的用户，包含拥有者，所属群组以及其他用户。
　有关权限代号的部分，列表于下：
　r：读取权限，数字代号为"4"。
　w：写入权限，数字代号为"2"。
　x：执行或切换权限，数字代号为"1"。
　-：不具任何权限，数字代号为"0"。
　s：特殊?b>功能说明：变更文件或目录的权限。
参　　数：
　-c或--changes 　效果类似"-v"参数，但仅回报更改的部分。
　-f或--quiet或--silent 　不显示错误信息。
　-R或--recursive 　递归处理，将指定目录下的所有文件及子目录一并处理。
　<权限范围>+<权限设置> 　开启权限范围的文件或目录的该项权限设置。
　<权限范围>-<权限设置> 　关闭权限范围的文件或目录的该项权限设置。
　<权限范围>=<权限设置> 　指定权限范围的文件或目录的该项权限设置。

常用方式及使用技巧:chmod +x *

1.14	chown(初级)
功能说明：变更文件或目录的拥有者或所属群组。
语　　法：chown [-cfhRv][--dereference][--help][--version][拥有者.<所属群组>][文件或目录..] 或chown [-chfRv][--dereference][--help][--version][.所属群组][文件或目录... ...] 或chown [-cfhRv][--dereference][--help][--reference=<参考文件或目录>][--version][文件或目录...]
补充说明：在UNIX系统家族里，文件或目录权限的掌控以拥有者及所属群组来管理。您可以使用chown指令去变更文件与目录的拥有者或所属群组，设置方式采用用户名称或用户识别码皆可，设置群组则用群组名称或群组识别码。
参　　数：
　-c或--changes 　效果类似"-v"参数，但仅回报更改的部分。
　-f或--quite或--silent 　不显示错误信息。
　-R或--recursive 　递归处理，将指定目录下的所有文件及子目录一并处理。

常用方式及使用技巧:chown –R portal：JavaMegroup JavaMe

1.15	wc(初级)
功能说明：计算字数。
语　　法：wc [-clw][--help][--version][文件...]
补充说明：利用wc指令我们可以计算文件的Byte数、字数、或是列数，若不指定文件名称、或是所给予的文件名为“-”，则wc指令会从标准输入设备读取数据。
参　　数：
-c或--bytes或--chars 只显示Bytes数。
-l或--lines 只显示列数。
-m 统计字符数
-w或--words 只显示字数。

常用方式及使用技巧：netstat –an | grep 1521 | wc -l

1.16	file(中级)
功能说明：辨识文件类型。
语　　法：file [-beLvz][-f <名称文件>][-m <魔法数字文件>...][文件或目录...]
补充说明：通过file指令，我们得以辨识该文件的类型。
参　　数：
　-b 　列出辨识结果时，不显示文件名称。
　-c 　详细显示指令执行过程，便于排错或分析程序执行的情形。
　-f<名称文件> 　指定名称文件，其内容有一个或多个文件名称呢感，让file依序辨识这些文件，格式为每列一个文件名称。
　-L 　直接显示符号连接所指向的文件的类别。
　-m<魔法数字文件> 　指定魔法数字文件。
　-v 　显示版本信息。
　-z 　尝试去解读压缩文件的内容。

常用方式及使用技巧：file common.xml

1.17	find(中级)
功能说明：查找文件或目录。
语　　法：find [目录...][-amin <分钟>][-anewer <参考文件或目录>][-atime <24小时数>][-cmin <分钟>][-cnewer <参考文件或目录>][-ctime <24小时数>][-daystart][-depyh][-empty][-exec <执行指令>][-false][-fls <列表文件>][-follow][-fprint <列表文件>][-fprint0 <列表文件>][-fprintf <列表文件><输出格式>][-fstype <文件系统类型>][-gid <群组识别码>][-group <群组名称>][-help][-ilname <范本样式>][-iname <范本样式>][-inum <inode编号>][-ipath <范本样式>][-iregex <范本样式>][-links <连接数目>][-lname <范本样式>][-ls][-maxdepth <目录层级>][-mindepth <目录层级>][-mmin <分钟>][-mount]
[-mtime <24小时数>][-name <范本样式>][-newer <参考文件或目录>][-nogroup][noleaf] [-nouser][-ok <执行指令>][-path <范本样式>][-perm <权限数值>][-print][-print0][-printf <输出格式>][-prune][-regex <范本样式>][-size <文件大小>][-true][-type <文件类型>][-uid <用户识别码>][-used <日数>][-user <拥有者名称>][-version][-xdev][-xtype <文件类型>]
补充说明：find指令用于查找符合条件的文件。任何位于参数之前的字符串都将被视为欲查找的目录。
参　　数：
　-amin<分钟> 　查找在指定时间曾被存取过的文件或目录，单位以分钟计算。
　-anewer<参考文件或目录> 　查找其存取时间较指定文件或目录的存取时间更接近现在的文件或目录。
　-atime<24小时数> 　查找在指定时间曾被存取过的文件或目录，单位以24小时计算。
　-cmin<分钟> 　查找在指定时间之时被更改的文件或目录。
　-cnewer<参考文件或目录> 　查找其更改时间较指定文件或目录的更改时间更接近现在的文件或目录。
　-ctime<24小时数> 　查找在指定时间之时被更改的文件或目录，单位以24小时计算。
　-daystart 　从本日开始计算时间。
　-depth 　从指定目录下最深层的子目录开始查找。
　-expty 　寻找文件大小为0 Byte的文件，或目录下没有任何子目录或文件的空目录。
　-exec<执行指令> 　假设find指令的回传值为True，就执行该指令。
　-false 　将find指令的回传值皆设为False。
　-fls<列表文件> 　此参数的效果和指定"-ls"参数类似，但会把结果保存为指定的列表文件。
　-follow 　排除符号连接。
　-fprint<列表文件> 　此参数的效果和指定"-print"参数类似，但会把结果保存成指定的列表文件。
　-fprint0<列表文件> 　此参数的效果和指定"-print0"参数类似，但会把结果保存成指定的列表文件。
　-fprintf<列表文件><输出格式> 　此参数的效果和指定"-printf"参数类似，但会把结果保存成指定的列表文件。
　-fstype<文件系统类型> 　只寻找该文件系统类型下的文件或目录。
　-gid<群组识别码> 　查找符合指定之群组识别码的文件或目录。
　-group<群组名称> 　查找符合指定之群组名称的文件或目录。
　-ilname<范本样式> 　此参数的效果和指定"-lname"参数类似，但忽略字符大小写的差别。
　-iname<范本样式> 　此参数的效果和指定"-name"参数类似，但忽略字符大小写的差别。
　-inum<inode编号> 　查找符合指定的inode编号的文件或目录。
　-ipath<范本样式> 　此参数的效果和指定"-ipath"参数类似，但忽略字符大小写的差别。
　-iregex<范本样式> 　此参数的效果和指定"-regexe"参数类似，但忽略字符大小写的差别。
　-links<连接数目> 　查找符合指定的硬连接数目的文件或目录。
　-iname<范本样式> 　指定字符串作为寻找符号连接的范本样式。
　-ls 　假设find指令的回传值为True，就将文件或目录名称列出到标准输出。
　-maxdepth<目录层级> 　设置最大目录层级。
　-mindepth<目录层级> 　设置最小目录层级。
　-mmin<分钟> 　查找在指定时间曾被更改过的文件或目录，单位以分钟计算。
　-mount 　此参数的效果和指定"-xdev"相同。
　-mtime<24小时数> 　查找在指定时间曾被更改过的文件或目录，单位以24小时计算。
　-name<范本样式> 　指定字符串作为寻找文件或目录的范本样式。
　-newer<参考文件或目录> 　查找其更改时间较指定文件或目录的更改时间更接近现在的文件或目录。
　-nogroup 　找出不属于本地主机群组识别码的文件或目录。
　-noleaf 　不去考虑目录至少需拥有两个硬连接存在。
　-nouser 　找出不属于本地主机用户识别码的文件或目录。
　-ok<执行指令> 　此参数的效果和指定"-exec"参数类似，但在执行指令之前会先询问用户，若回答"y"或"Y"，则放弃执行指令。
　-path<范本样式> 　指定字符串作为寻找目录的范本样式。
　-perm<权限数值> 　查找符合指定的权限数值的文件或目录。
　-print 　假设find指令的回传值为True，就将文件或目录名称列出到标准输出。格式为每列一个名称，每个名称之前皆有"./"字符串。
　-print0 　假设find指令的回传值为True，就将文件或目录名称列出到标准输出。格式为全部的名称皆在同一行。
　-printf<输出格式> 　假设find指令的回传值为True，就将文件或目录名称列出到标准输出。格式可以自行指定。
　-prune 　不寻找字符串作为寻找文件或目录的范本样式。
　-regex<范本样式> 　指定字符串作为寻找文件或目录的范本样式。
　-size<文件大小> 　查找符合指定的文件大小的文件。
　-true 　将find指令的回传值皆设为True。
　-typ<文件类型> 　只寻找符合指定的文件类型的文件。
　-uid<用户识别码> 　查找符合指定的用户识别码的文件或目录。
　-used<日数> 　查找文件或目录被更改之后在指定时间曾被存取过的文件或目录，单位以日计算。
　-user<拥有者名称> 　查找符合指定的拥有者名称的文件或目录。
　-version或--version 　显示版本信息。
　-xdev 　将范围局限在先行的文件系统中。
　-xtype<文件类型> 　此参数的效果和指定"-type"参数类似，差别在于它针对符号连接检查。

常用方式及使用技巧:find ./ -name “*.xml” xargs –print | grep –i “time-out”

1.18	grep(中级)
功能说明：查找文件里符合条件的字符串。
语　　法：grep [-abcEFGhHilLnqrsvVwxy][-A<显示列数>][-B<显示列数>][-C<显示列数>][-d<进行动作>][-e<范本样式>][-f<范本文件>][--help][范本样式][文件或目录...]
补充说明：grep指令用于查找内容包含指定的范本样式的文件，如果发现某文件的内容符合所指定的范本样式，预设grep指令会把含有范本样式的那一列显示出来。若不指定任何文件名称，或是所给予的文件名为“-”，则grep指令会从标准输入设备读取数据。
参　　数：
-i或--ignore-case 忽略字符大小写的差别。
-v或--revert-match 反转查找。
基本格式 grep [option] [regex] [path]

-o 只按行显示匹配的字符
-c 只输出匹配行的数目
-n 显示匹配行的行号
-v 显示不包含匹配文本的行
-i 不区分大小写 (grep是大小写敏感的)
-R 文件夹下递归搜索
-l 只显示匹配的文件名 
-H 显示文件名
-A NUM(after)显示匹配的后几行
-B NUM(before)显示匹配的前几行
-C NUM显示匹配的前后几行 
–color 标出颜色

常用方式及使用技巧:find ./ -name “*.xml” xargs –print | grep –i “time-out”

1.19	diff(中级)
功能说明：比较文件的差异。
语　　法：diff [-abBcdefHilnNpPqrstTuvwy][-<行数>][-C <行数>][-D <巨集名称>][-I <字符或字符串>][-S <文件>][-W <宽度>][-x <文件或目录>][-X <文件>][--help][--left-column][--suppress-common-line][文件或目录1][文件或目录2]
补充说明：diff以逐行的方式，比较文本文件的异同处。所是指定要比较目录，则diff会比较目录中相同文件名的文件，但不会比较其中子目录。
参　　数：
　-r或--recursive 　比较子目录中的文件。

常用方式及使用技巧:diff server.xml server.xml_bak

1.20	cat(初级)
使用权限：所有使用者
使用方式：cat [-AbeEnstTuv] [--help] [--version] fileName
说明：把档案串连接后传到基本输出（萤幕或加 > fileName 到另一个档案）
参数：
-n 或 --number 由 1 开始对所有输出的行数编号
-b 与-n类似，但空行不编号

范例：
cat -n textfile1 > textfile2 把 textfile1 的档案内容加上行号后输入 textfile2 这个档案里
cat -b textfile1 textfile2 >> textfile3 把 textfile1 和 textfile2 的档案内容加上行号（空白行不加）之后将内容附加到 textfile3 里。
常用方式及使用技巧:cat common_settings.xml

1.21	tar(初级)
功能说明：备份文件。
语　　法：tar [-ABcdgGhiklmMoOpPrRsStuUvwWxzZ][-b <区块数目>][-C <目的目录>][-f <备份文件>][-F <Script文件>][-K <文件>][-L <媒体容量>][-N <日期时间>][-T <范本文件>][-V <卷册名称>][-X <范本文件>][-<设备编号><存储密度>][--after-date=<日期时间>][--atime-preserve][--backuup=<备份方式>][--checkpoint][--concatenate][--confirmation][--delete][--exclude=<范本样式>][--force-local][--group=<群组名称>][--help][--ignore-failed-read][--new-volume-script=<Script文件>][--newer-mtime][--no-recursion][--null][--numeric-owner][--owner=<用户名称>][--posix][--erve][--preserve-order][--preserve-permissions][--record-size=<区块数目>][--recursive-unlink][--remove-files][--rsh-command=<执行指令>][--same-owner][--suffix=<备份字尾字符串>][--totals][--use-compress-program=<执行指令>][--version][--volno-file=<编号文件>][文件或目录...]
补充说明：tar是用来建立，还原备份文件的工具程序，它可以加入，解开备份文件内的文件。
参　　数：
-c或--create 建立新的备份文件。
-f<备份文件>或--file=<备份文件> 指定备份文件。
-v或--verbose 显示指令执行过程。
-w或--interactive 遭遇问题时先询问用户。
-W或--verify 写入备份文件后，确认文件正确无误。
-x或--extract或--get 从备份文件中还原文件。

常用方式及使用技巧:
tar –cvf JavaMe.tar JavaMe
tar –xvf JavaMe JavaMe.tar
tar –zcvf JavaMe.tar.gz JavaMe
tar –zxvf JavaMe JavaMe.tar.gz

1.22	source(初级)
功能说明: 在当前bash环境下读取并执行FileName中的命令
补充说明：该命令通常用命令“.”来替代。如：source .bash_rc 与 . .bash_rc 是等效的。

语法：
source FileName
常用方式及使用技巧:source .bashrc

1.23	“>” (初级)
功能说明：输出重定向
补充说明：以重写的方式输出重定向

语法：
tail –f Error.log > test.log
常用方式及使用技巧: cat /dev/null > Error.log

1.24	“>>” (初级)
功能说明：输出重定向
补充说明：以追加的方式进行输出重定向

语法：
tail –f Error.log >> test.log
常用方式及使用技巧:cat Error.log > > test.log
基本格式 tail [option] [filename]
-n number 定位参数，+5表示从第五行开始显示，10或-10表示显示最后10行
-f 监控文本变化，更新内容
-k number 从number所指的KB处开始读取

2	设备管理
2.1	mount(中级)
名称 : mount
　　使用权限 : 系统管理者或/etc/fstab中允许的使用者
　　使用方式 :
　　mount [-hV]
　　mount -a [-fFnrsvw] [-t vfstype]
　　mount [-fnrsvw] [-o options [,...]] device | dir
　　mount [-fnrsvw] [-t vfstype] [-o options] device dir
说明 :
　　将某个档案的内容解读成档案系统，然后将其挂在目录的某个位置之上。当这个命令执行成功后，直到我们使用 umnount 将这个档案系统移除为止，这个命令之下的所有档案将暂时无法被调用。
　　这个命令可以被用来挂上任何的档案系统，你甚至可以用 -o loop 选项将某个一般的档案当成硬盘机分割挂上系统。这个功能对于 ramdisk,romdisk 或是 ISO 9660 的影像档之解读非常实用。
参数 ：
　　-a 　将 /etc/fstab 中定义的所有档案系统挂上。
　　-F 　这个命令通常和 -a 一起使用，它会为每一个 mount 的动作产生一个行程负责执行。在系统需要挂上大量 NFS 档案系统时可以加快挂上的动作。
　　-f 　通常用在除错的用途。它会使 mount 并不执行实际挂上的动作，而是模拟整个挂上的过程。通常会和 -v 一起使用。
　　-n 　一般而言，mount 在挂上后会在 /etc/mtab 中写入一笔资料。但在系统中没有可写入档案系统存在的情况下可以用这个选项取消这个动作。
　　-s-r 　等于 -o ro
　　-w 　等于 -o rw
　　-L 　将含有特定标签的硬盘分割挂上。
　　-U 将档案分割序号为 的档案系统挂下。-L 和 -U 必须在/proc/partition 这种档案存在时才有意义。
　　-t 　指定档案系统的型态，通常不必指定。mount 会自动选择正确的型态。
　　-o async 打开非同步模式，所有的档案读写动作都会用非同步模式执行。
　　-o sync 在同步模式下执行。
　　-o atime
　　-o noatime 当 atime 打开时，系统会在每次读取档案时更新档案的『上一次调用时间』。当我们使用 flash 档案系统时可能会选项把这个选项关闭以减少写入的次数。
　　-o auto
　　-o noauto 打开/关闭自动挂上模式。
　　-o defaults 使用预设的选项 rw, suid, dev, exec, auto, nouser, and async.
　　-o dev
　　-o nodev-o exec
　　-o noexec 允许执行档被执行。
　　-o suid
　　-o nosuid 　允许执行档在 root 权限下执行。
　　-o user
　　-o nouser 　使用者可以执行 mount/umount 的动作。
　　-o remount 将一个已经挂下的档案系统重新用不同的方式挂上。例如原先是唯读的系统，现在用可读写的模式重新挂上。
　　-o ro 　用唯读模式挂上。
　　-o rw 用可读写模式挂上。
　　-o loop= 　使用 loop 模式用来将一个档案当成硬盘分割挂上系统。


范例：
　　将 /dev/hda1 挂在 /mnt 之下。
　　 #mount /dev/hda1 /mnt
　　将 /dev/hda1 用唯读模式挂在 /mnt 之下。
　　 #mount -o ro /dev/hda1 /mnt
　　将 /tmp/image.iso 这个光碟的 image 档使用 loop 模式挂在 /mnt/cdrom之下。用这种方法可以将一般网络上可以找到的 Linux 光 碟 ISO 档在不烧录成光碟的情况下检视其内容。
　　 #mount -o loop /tmp/image.iso /mnt/cdrom
相关命令：umount
常用方式及使用技巧: mount -t nfs 10.137.22.245:/home /home


2.2	umount(中级)
功能说明：卸除文件系统。
语　　法：umount [-ahnrvV][-t <文件系统类型>][文件系统]
补充说明：umount可卸除目前挂在Linux目录中的文件系统。
参　　数：
-a 卸除/etc/mtab中记录的所有文件系统。
-h 显示帮助。
-n 卸除时不要将信息存入/etc/mtab文件中。
-r 若无法成功卸除，则尝试以只读的方式重新挂入文件系统。
-t<文件系统类型> 仅卸除选项中所指定的文件系统。
-v 执行时显示详细的信息。
-V 显示版本信息。
[文件系统] 除了直接指定文件系统外，也可以用设备名称或挂入点来表示文件系统。
常用方式及使用技巧	:umount /home
2.3	du(中级)
功能说明：显示目录或文件的大小。
语　　法：du [-abcDhHklmsSx][-L <符号连接>][-X <文件>][--block-size][--exclude=<目录或文件>][--max-depth=<目录层数>][--help][--version][目录或文件]
补充说明：du会显示指定的目录或文件所占用的磁盘空间。
参　　数：
-a或-all 显示目录中个别文件的大小。
-b或-bytes 显示目录或文件大小时，以byte为单位。
-c或--total 除了显示个别目录或文件的大小外，同时也显示所有目录或文件的总和。
-D或--dereference-args 显示指定符号连接的源文件大小。
-h或--human-readable 以K，M，G为单位，提高信息的可读性。
-H或--si 与-h参数相同，但是K，M，G是以1000为换算单位。
-k或--kilobytes 以1024 bytes为单位。
-l或--count-links 重复计算硬件连接的文件。
-L<符号连接>或--dereference<符号连接> 显示选项中所指定符号连接的源文件大小。
-m或--megabytes 以1MB为单位。
-s或--summarize 仅显示总计。
-S或--separate-dirs 显示个别目录的大小时，并不含其子目录的大小。
常用方式及使用技巧: du –sh *
2.4	df(初级)
功能说明：显示磁盘的相关信息。
语　　法：df [-ahHiklmPT][--block-size=<区块大小>][-t <文件系统类型>][-x <文件系统类型>][--help][--no-sync][--sync][--version][文件或设备]
补充说明：df可显示磁盘的文件系统与使用情形。
参　　数：
-a或--all 包含全部的文件系统。
--block-size=<区块大小> 以指定的区块大小来显示区块数目。
-h或--human-readable 以可读性较高的方式来显示信息。
-H或--si 与-h参数相同，但在计算时是以1000 Bytes为换算单位而非1024 Bytes。
-i或--inodes 显示inode的信息。
-k或--kilobytes 指定区块大小为1024字节。
-l或--local 仅显示本地端的文件系统。
-m或--megabytes 指定区块大小为1048576字节。
--no-sync 在取得磁盘使用信息前，不要执行sync指令，此为预设值。
-P或--portability 使用POSIX的输出格式。
--sync 在取得磁盘使用信息前，先执行sync指令。
-t<文件系统类型>或--type=<文件系统类型> 仅显示指定文件系统类型的磁盘信息。
-T或--print-type 显示文件系统的类型。
-x<文件系统类型>或--exclude-type=<文件系统类型> 不要显示指定文件系统类型的磁盘信息。
--help 显示帮助。
--version 显示版本信息。
[文件或设备] 指定磁盘设备。
常用方式及使用技巧:df -h
2.5	fdisk(中级)
功能说明：磁盘分区。
语　　法：fdisk [-b <分区大小>][-uv][外围设备代号] 或 fdisk [-l][-b <分区大小>][-uv][外围设备代号...] 或 fdisk [-s <分区编号>]
补充说明：fdisk是用来磁盘分区的程序，它采用传统的问答式界面，而非类似DOS fdisk的cfdisk互动式操作界面，因此在使用上较为不便，但功能却丝毫不打折扣。
参　　数：
-b<分区大小> 指定每个分区的大小。
-l 列出指定的外围设备的分区表状况。
-s<分区编号> 将指定的分区大小输出到标准输出上，单位为区块。
-u 搭配"-l"参数列表，会用分区数目取代柱面数目，来表示每个分区的起始地址。
常用方式及使用技巧:fdisk -l
2.6	ln(中级)
功能说明：连接文件或目录。
语　　法：ln [-bdfinsv][-S <字尾备份字符串>][-V <备份方式>][--help][--version][源文件或目录][目标文件或目录] 或 ln [-bdfinsv][-S <字尾备份字符串>][-V <备份方式>][--help][--version][源文件或目录...][目的目录]
补充说明：ln指令用在连接文件或目录，如同时指定两个以上的文件或目录，且最后的目的地是一个已经存在的目录，则会把前面指定的所有文件或目录复制到该目录中。若同时指定多个文件或目录，且最后的目的地并非是一个已存在的目录，则会出现错误信息。
参　　数：
　-b或--backup 　删除，覆盖目标文件之前的备份。
　-d或-F或--directory 　建立目录的硬连接。
　-f或--force 　强行建立文件或目录的连接，不论文件或目录是否存在。
　-i或--interactive 　覆盖既有文件之前先询问用户。
　-n或--no-dereference 　把符号连接的目的目录视为一般文件。
　-s或--symbolic 　对源文件建立符号连接，而非硬连接。
常用方式及使用技巧:ln –s /home/pnfs/share /share
2.7	unzip(初级)
功能说明：解压缩zip文件
语　　法：unzip [-cflptuvz][-agCjLMnoqsVX][-P <密码>][.zip文件][文件][-d <目录>][-x <文件>] 或 unzip [-Z]
补充说明：unzip为.zip压缩文件的解压缩程序。
参　　数：
-c 将解压缩的结果显示到屏幕上，并对字符做适当的转换。
-f 更新现有的文件。
-l 显示压缩文件内所包含的文件。
-p 与-c参数类似，会将解压缩的结果显示到屏幕上，但不会执行任何的转换。
-t 检查压缩文件是否正确。
-u 与-f参数类似，但是除了更新现有的文件外，也会将压缩文件中的其他文件解压缩到目录中。
-v 执行是时显示详细的信息。
-z 仅显示压缩文件的备注文字。
-a 对文本文件进行必要的字符转换。
-b 不要对文本文件进行字符转换。
-C 压缩文件中的文件名称区分大小写。
-j 不处理压缩文件中原有的目录路径。
-L 将压缩文件中的全部文件名改为小写。
-M 将输出结果送到more程序处理。
-n 解压缩时不要覆盖原有的文件。
-o 不必先询问用户，unzip执行后覆盖原有文件。
-P<密码> 使用zip的密码选项。
-q 执行时不显示任何信息。
-s 将文件名中的空白字符转换为底线字符。
-V 保留VMS的文件版本信息。
-X 解压缩时同时回存文件原来的UID/GID。
[.zip文件] 指定.zip压缩文件。
[文件] 指定要处理.zip压缩文件中的哪些文件。
-d<目录> 指定文件解压缩后所要存储的目录。
-x<文件> 指定不要处理.zip压缩文件中的哪些文件。
-Z unzip -Z等于执行zipinfo指令。
常用方式及使用技巧: unzip test1.zip
2.8	unrar(中级)
功能说明：解压rar文件
语法：unrar –x JavaMe.rar
常用方式及使用技巧:unrar –x JavaMe.rar
2.9	gunzip(初级)
功能说明：解压文件。
语　　法：gunzip [-acfhlLnNqrtvV][-s <压缩字尾字符串>][文件...] 或 gunzip [-acfhlLnNqrtvV][-s <压缩字尾字符串>][目录]
补充说明：gunzip是个使用广泛的解压缩程序，它用于解开被gzip压缩过的文件，这些压缩文件预设最后的扩展名为".gz"。事实上gunzip就是gzip的硬连接，因此不论是压缩或解压缩，都可通过gzip指令单独完成。
参　　数：
　-a或--ascii 　使用ASCII文字模式。
　-c或--stdout或--to-stdout 　把解压后的文件输出到标准输出设备。
　-f或-force 　强行解开压缩文件，不理会文件名称或硬连接是否存在以及该文件是否为符号连接。
　-h或--help 　在线帮助。
　-l或--list 　列出压缩文件的相关信息。
　-L或--license 　显示版本与版权信息。
　-n或--no-name 　解压缩时，若压缩文件内含有远来的文件名称及时间戳记，则将其忽略不予处理。
　-N或--name 　解压缩时，若压缩文件内含有原来的文件名称及时间戳记，则将其回存到解开的文件上。
　-q或--quiet 　不显示警告信息。
　-r或--recursive 　递归处理，将指定目录下的所有文件及子目录一并处理。
　-S<压缩字尾字符串>或--suffix<压缩字尾字符串> 　更改压缩字尾字符串。
　-t或--test 　测试压缩文件是否正确无误。
　-v或--verbose 　显示指令执行过程。
　-V或--version 显示版本信息。
常用方式及使用技巧:gunzip JavaMe.tar.gz
2.10	free(中级)
功能说明：显示内存状态。
语　　法： free [-bkmotV][-s <间隔秒数>]
补充说明：free指令会显示内存的使用情况，包括实体内存，虚拟的交换文件内存，共享内存区段，以及系统核心使用的缓冲区等。
参　　数：
　-b 　以Byte为单位显示内存使用情况。
　-k 　以KB为单位显示内存使用情况。
　-m 　以MB为单位显示内存使用情况。
　-o 　不显示缓冲区调节列。
　-s<间隔秒数> 　持续观察内存使用状况。
　-t 　显示内存总和列。
　-V 　显示版本信息。
常用方式及使用技巧:free -m
2.11	sync(中级)
功能说明：将内存缓冲区内的数据写入磁盘。
语　　法：sync [--help][--version]
补充说明：在Linux系统中，当数据需要存入磁盘时，通常会先放到缓冲区内，等到适当的时刻再写入磁盘，如此可提高系统的执行效率。
参　　数：
--help 显示帮助。
--version 显示版本信息。

常用方式及使用技巧:sync;
在执行reboot或者shutdown等命令时一定要首先使用sync将内存中的信息同步到磁盘上，以免造成数据丢失

3	系统设置与用户管理
3.1	who(初级)
功能说明：显示目前登入系统的用户信息。
语　　法：who [-Himqsw][--help][--version][am i][记录文件]
补充说明：执行这项指令可得知目前有那些用户登入系统，单独执行who指令会列出登入帐号，使用的
终端机，登入时间以及从何处登入或正在使用哪个X显示器。
参　　数：
　-H或--heading 　显示各栏位的标题信息列。
　-i或-u或--idle 　显示闲置时间，若该用户在前一分钟之内有进行任何动作，将标示成"."号，如果该用户已超过24小时没有任何动作，则标示出"old"字符串。
　-m 　此参数的效果和指定"am i"字符串相同。
　-q或--count 　只显示登入系统的帐号名称和总人数。
　-s 　此参数将忽略不予处理，仅负责解决who指令其他版本的兼容性问题。
　-w或-T或--mesg或--message或--writable 　显示用户的信息状态栏。
3.2	whoami(初级)
功能说明：先似乎用户名称。
语　　法：whoami [--help][--version]
补充说明：显示自身的用户名称，本指令相当于执行"id -un"指令
3.3	groupadd(初级)
功能说明:添加用户群组

语法：groupadd –g 1000 JavaMegroup

3.4	groupdel(初级)
功能说明：删除群组。
语　　法：groupdel [群组名称]
补充说明：需要从系统上删除群组时，可用groupdel指令来完成这项工作。倘若该群组中仍包括某些用户，则必须先删除这些用户后，方能删除群组。
3.5	useradd(初级)
功能说明：建立用户帐号。
语　　法：useradd [-mMnr][-c <备注>][-d <登入目录>][-e <有效期限>][-f <缓冲天数>][-g <群组>][-G <群组>][-s <shell>][-u <uid>][用户帐号] 或 useradd -D [-b][-e <有效期限>][-f <缓冲天数>][-g <群组>][-G <群组>][-s <shell>]
补充说明：useradd可用来建立用户帐号。帐号建好之后，再用passwd设定帐号的密码．而可用userdel删除帐号。使用useradd指令所建立的帐号，实际上是保存在/etc/passwd文本文件中。
参　　数：
　-c<备注> 　加上备注文字。备注文字会保存在passwd的备注栏位中。　
　-d<登入目录> 　指定用户登入时的启始目录。
　-D 　变更预设值．
　-e<有效期限> 　指定帐号的有效期限。
　-f<缓冲天数> 　指定在密码过期后多少天即关闭该帐号。
　-g<群组> 　指定用户所属的群组。
　-G<群组> 　指定用户所属的附加群组。
　-m 　自动建立用户的登入目录。
　-M 　不要自动建立用户的登入目录。
　-n 　取消建立以用户名称为名的群组．
　-r 　建立系统帐号。
　-s<shell>　 　指定用户登入后所使用的shell。
　-u<uid> 　指定用户ID。
常用方式及使用技巧:useradd –g JavaMegroup –u 1003 –d /home/JavaMe –m –s /bin/bash JavaMe
3.6	userdel(初级)
功能说明：删除用户帐号。
语　　法：userdel [-r][用户帐号]
补充说明：userdel可删除用户帐号与相关的文件。若不加参数，则仅删除用户帐号，而不删除相关文件。
参　　数：
-f 　删除用户登入目录以及目录中所有文件。
常用方式及使用技巧:Userdel –r JavaMe
3.7	passwd(初级)
功能说明：设置密码。
语　　法：passwd [-dklS][-u <-f>][用户名称]
补充说明：passwd指令让用户可以更改自己的密码，而系统管理者则能用它管理系统用户的密码。只有管理者可以指定用户名称，一般用户只能变更自己的密码。
参　　数：
-d 　删除密码。本参数仅有系统管理者才能使用。
-f 　强制执行。
-k 　设置只有在密码过期失效后，方能更新。
-l 　锁住密码。
-s 　列出密码的相关信息。本参数仅有系统管理者才能使用。
-u 　解开已上锁的帐号。
3.8	su(初级)
功能说明：变更用户身份。
语　　法：su [-flmp][--help][--version][-][-c <指令>][-s <shell>][用户帐号]
补充说明：su可让用户暂时变更登入的身份。变更时须输入所要变更的用户帐号与密码。
参　　数：
　-c<指令>或--command=<指令> 　执行完指定的指令后，即恢复原来的身份。
　-f或--fast 　适用于csh与tsch，使shell不用去读取启动文件。
　-.-l或--login 　改变身份时，也同时变更工作目录，以及HOME,SHELL,USER,LOGNAME。此外，也会变更PATH变量。
　-m,-p或--preserve-environment 　变更身份时，不要变更环境变量。
　-s<shell>或--shell=<shell> 　指定要执行的shell。
　--help 　显示帮助。
　--version 　显示版本信息。
　[用户帐号] 　指定要变更的用户。若不指定此参数，则预设变更为root。

常用方式及使用技巧: su – oracle
su oracle
使用同一个命令中间加不加“-”是有很大的区别的：添加“-”时改变身份时，也同时变更工作目录，以及HOME,SHELL,USER,LOGNAME。此外，也会变更PATH变量。
如果不添加“-”，只是改变了用户，其余的信息都不会发生变化

3.9	alias(中级)
功能说明：设置指令的别名。
语　　法：alias[别名]=[指令名称]
补充说明：用户可利用alias，自定指令的别名。若仅输入alias，则可列出目前所有的别名设置。　alias的效力仅及于该次登入的操作。若要每次登入是即自动设好别名，可在.profile或.cshrc中设定指令的别名。
参　　数：若不加任何参数，则列出目前所有的别名设置。
常用方式及使用技巧：alias stop="cd $HOME/JavaMe/tomcat/bin;./shutdown.sh"
3.10	export(中级)
功能说明：设置或显示环境变量。
语　　法：export [-fnp][变量名称]=[变量设置值]
补充说明：在shell中执行程序时，shell会提供一组环境变量。export可新增，修改或删除环境变量，供后续执行的程序使用。export的效力仅及于该此登陆操作。
参　　数：
　-f 　代表[变量名称]中为函数名称。
　-n 　删除指定的变量。变量实际上并未删除，只是不会输出到后续指令的执行环境中。
　-p 　列出所有的shell赋予程序的环境变量。
常用方式及使用技巧：export PATH=${PATH}:${HOME}/JavaMe/tomcat/bin（为bash中设置环境变量使用的命令）
3.11	setenv(中级)
setenv(set environment variable)
功能说明：查询或显示环境变量。
语　　法：setenv [变量名称][变量值]
补充说明：setenv为tsch中查询或设置环境变量的指令。
常用方式及使用技巧：setenv PATH=${PATH}:${HOME}/JavaMe/tomcat/bin（为csh中设置环境变量使用的命令）
3.12	yast(高级)
功能说明：YaST是中心管理和安装工具，用于完成大多数管理性任务，类似于Windows的控制面板
补充说明：需要以root用户来执行
语法：
#yast得到如下界面

我们常用Network Device选项为网卡绑定IP地址以及路由，另外使用Network service中的Network services（xinetd）开通各种网络服务：如ftp、telnet等、Remote Administration开通系统远程服务，NFS Server以及NFS Client开通NFS服务。
另外，如果使用XManager等图形界面登录系统，可以使用yast2&命令，如下图：

可以使用鼠标进行选择操作。
3.13	reboot(初级)
功能说明：重启系统。
语　　法：dreboot [-dfinw]
补充说明：执行reboot指令可让系统停止运作，并重新开机。
参　　数：
-d 　重新开机时不把数据写入记录文件/var/tmp/wtmp。本参数具有"-n"参数的效果。
-f 　强制重新开机，不调用shutdown指令的功能。
-i 　在重开机之前，先关闭所有网络界面。
-n 　重开机之前不检查是否有未结束的程序。
-w 　仅做测试，并不真的将系统重新开机，只会把重开机的数据写入/var/log目录下的wtmp记录文件。
3.14	halt(初级)
功能说明：关闭系统。
语　　法：halt [-dfinpw]
补充说明：halt会先检测系统的runlevel。若runlevel为0或6，则关闭系统，否则即调用shutdown来关闭系统。
参　　数：
-d 　不要在wtmp中记录。
-f 　不论目前的runlevel为何，不调用shutdown即强制关闭系统。
-i 　在halt之前，关闭全部的网络界面。
-n 　halt前，不用先执行sync。
-p 　halt之后，执行poweroff。
-w 　仅在wtmp中记录，而不实际结束系统。
3.15	shutdown(初级)
功能说明：系统关机指令。
语　　法：shutdown [-efFhknr][-t 秒数][时间][警告信息]
补充说明：shutdown指令可以关闭所有程序，并依用户的需要，进行重新开机或关机的动作。
参　　数：
　-c 　当执行"shutdown -h 11:50"指令时，只要按+键就可以中断关机的指令。
　-f 　重新启动时不执行fsck。
　-F 　重新启动时执行fsck。
　-h 　将系统关机。
　-k 　只是送出信息给所有用户，但不会实际关机。
　-n 　不调用init程序进行关机，而由shutdown自己进行。
　-r 　shutdown之后重新启动。
　-t<秒数> 　送出警告信息和删除信息之间要延迟多少秒。
　[时间] 　设置多久时间后执行shutdown指令。
　[警告信息] 　要传送给所有登入用户的信息。
4	进程管理
4.1
4.2	sleep(中级)
功能说明: sleep
　　使用权限 : 所有使用者
　　使用方式 : sleep [--help] [--version] number[smhd]
　　说明 : sleep 可以用来将目前动作延迟一段时间
　　参数说明 :
　　--help : 显示辅助讯息
　　--version : 显示版本编号
　　number : 时间长度，后面可接 s、m、h 或 d
　　其中 s 为秒，m 为 分钟，h 为小时，d 为日数
　　例子 :
　　显示目前时间后延迟 1 分钟，之后再次显示时间 :
　　常用方式及使用技巧：date;sleep 1m;date
4.3	kill(初级)
功能说明：删除执行中的程序或工作。
语　　法：kill [-s <信息名称或编号>][程序]　或　kill [-l <信息编号>]
补充说明：kill可将指定的信息送至程序。预设的信息为SIGTERM(15)，可将指定程序终止。若仍无法终止该程序，可使用SIGKILL(9)信息尝试强制删除程序。程序或工作的编号可利用ps指令或jobs指令查看。
参　　数：
　-l <信息编号> 　若不加<信息编号>选项，则-l参数会列出全部的信息名称。
　-s <信息名称或编号> 　指定要送出的信息。
　[程序] 　[程序]可以是程序的PID或是PGID，也可以是工作编号。
常用方式及使用技巧：kill -9 12345

4.4 “|” (初级)
功能说明：管道,管道符前面命令的输出作为后面命令的输入

语法：
find ./ -name “*.xml” –print | xargs grep –i “time-out”

4.5	top(中级)
功能说明：显示，管理执行中的程序。
语　　法：top [bciqsS][d <间隔秒数>][n <执行次数>]
补充说明：执行top指令可显示目前正在系统中执行的程序，并通过它所提供的互动式界面，用热键加以管理。
参　　数：
　b 　使用批处理模式。
　c 　列出程序时，显示每个程序的完整指令，包括指令名称，路径和参数等相关信息。
　d<间隔秒数> 　设置top监控程序执行状况的间隔时间，单位以秒计算。
　i 　执行top指令时，忽略闲置或是已成为Zombie的程序。
　n<执行次数> 　设置监控信息的更新次数。
　q 　持续监控程序执行的状况。
　s 　使用保密模式，消除互动模式下的潜在危机。
　S 　使用累计模式，其效果类似ps指令的"-S"参数。
5	网络通信

5.2	ping(初级)
功能说明：检测主机。
语　　法：ping [-dfnqrRv][-c<完成次数>][-i<间隔秒数>][-I<网络界面>][-l<前置载入>][-p<范本样式>][-s<数据包大小>][-t<存活数值>][主机名称或IP地址]
补充说明：执行ping指令会使用ICMP传输协议，发出要求回应的信息，若远端主机的网络功能没有问题，就会回应该信息，因而得知该主机运作正常。
参　　数：
-d 使用Socket的SO_DEBUG功能。
-c<完成次数> 设置完成要求回应的次数。
-f 极限检测。
-i<间隔秒数> 指定收发信息的间隔时间。
-I<网络界面> 使用指定的网络界面送出数据包。
-l<前置载入> 设置在送出要求信息之前，先行发出的数据包。
-n 只输出数值。
-p<范本样式> 设置填满数据包的范本样式。
-q 不显示指令执行过程，开头和结尾的相关信息除外。
-r 忽略普通的Routing Table，直接将数据包送到远端主机上。
-R 记录路由过程。
-s<数据包大小> 设置数据包的大小。
-t<存活数值> 设置存活数值TTL的大小。
-v 详细显示指令的执行过程。
常用方式及使用技巧：ping 10.137.41.21
5.3	route(中级)
功能说明: 使用 Route 命令行工具查看并编辑计算机的 IP 路由表
语法：route [-f] [-p] [Command [Destination] [mask Netmask] [Gateway] [metric Metric]] [if Interface]]
参数：
-f 清除所有网关入口的路由表。
-p 与 add 命令一起使用时使路由具有永久性。
Command 指定您想运行的命令 (Add/Change/Delete/Print)。
Destination 指定该路由的网络目标。
mask Netmask 指定与网络目标相关的网络掩码（也被称作子网掩码）。
Gateway 指定网络目标定义的地址集和子网掩码可以到达的前进或下一跃点 IP 地址。
metric Metric 为路由指定一个整数成本值标（从 1 至 9999），当在路由表(与转发的数据包目标地址最匹配)的多个路由中进行选择时可以使用。
if Interface 为可以访问目标的接口指定接口索引。若要获得一个接口列表和它们相应的接口索引，使用 route print 命令的显示功能。可以使用十进制或十六进制值进行接口索引。
示例：
若要显示 IP 路由表的全部内容，请键入：
route print
若要显示以 10. 起始的 IP 路由表中的路由，请键入：
route print 10.*
若要添加带有 192.168.12.1 默认网关地址的默认路由，请键入：
route add 0.0.0.0 mask 0.0.0.0 192.168.12.1
若要向带有 255.255.0.0 子网掩码和 10.27.0.1 下一跃点地址的 10.41.0.0 目标中添加一个路由，请键入：
route add 10.41.0.0 mask 255.255.0.0 10.27.0.1
若要向带有 255.255.0.0 子网掩码和 10.27.0.1 下一跃点地址的 10.41.0.0 目标中添加一个永久路由，请键入：
route -p add 10.41.0.0 mask 255.255.0.0 10.27.0.1
若要向带有 255.255.0.0 子网掩码、10.27.0.1 下一跃点地址且其成本值标为 7 的 10.41.0.0 目标中添加一个路由，请键入：
route add 10.41.0.0 mask 255.255.0.0 10.27.0.1 metric 7
若要向带有 255.255.0.0 子网掩码、10.27.0.1 下一跃点地址且使用 0x3 接口索引的 10.41.0.0 目标中添加一个路由，请键入：
route add 10.41.0.0 mask 255.255.0.0 10.27.0.1 if 0x3
若要删除到带有 255.255.0.0 子网掩码的 10.41.0.0 目标的路由，请键入：
route delete 10.41.0.0 mask 255.255.0.0
若要删除以 10. 起始的 IP 路由表中的所有路由，请键入：
route delete 10.*
若要将带有 10.41.0.0 目标和 255.255.0.0 子网掩码的下一跃点地址从 10.27.0.1 修改为 10.27.0.25，请键入：
route change 10.41.0.0 mask 255.255.0.0 10.27.0.25
相关命令：nestat –an
5.4	ifconfig(初级)
功能说明：显示或设置网络设备。
语　　法：ifconfig [网络设备][down up -allmulti -arp -promisc][add<地址>][del<地址>][<hw<网络设备类型><硬件地址>][io_addr<I/O地址>][irq<IRQ地址>][media<网络媒介类型>][mem_start<内存地址>][metric<数目>][mtu<字节>][netmask<子网掩码>][tunnel<地址>][-broadcast<地址>][-pointopoint<地址>][IP地址]
补充说明：ifconfig可设置网络设备的状态，或是显示目前的设置。
参　　数：
add<地址> 设置网络设备IPv6的IP地址。
del<地址> 删除网络设备IPv6的IP地址。
down 关闭指定的网络设备。
<hw<网络设备类型><硬件地址> 设置网络设备的类型与硬件地址。
io_addr<I/O地址> 设置网络设备的I/O地址。
irq<IRQ地址> 设置网络设备的IRQ。
media<网络媒介类型> 设置网络设备的媒介类型。
mem_start<内存地址> 设置网络设备在主内存所占用的起始地址。
metric<数目> 指定在计算数据包的转送次数时，所要加上的数目。
mtu<字节> 设置网络设备的MTU。
netmask<子网掩码> 设置网络设备的子网掩码。
tunnel<地址> 建立IPv4与IPv6之间的隧道通信地址。
up 启动指定的网络设备。
-broadcast<地址> 将要送往指定地址的数据包当成广播数据包来处理。
-pointopoint<地址> 与指定地址的网络设备建立直接连线，此模式具有保密功能。
-promisc 关闭或启动指定网络设备的promiscuous模式。
[IP地址] 指定网络设备的IP地址。
[网络设备] 指定网络设备的名称。
常用方式及使用技巧:使用ifconfig配置的IP地址在系统重启时会导致IP无效，如果要持久话需要使用yast命令进行设置或者是写入文件/etc/sysconfig/network/ ifcfg-eth-id-00:25:9e:f3:a4:8e
ifconfig默认需要使用root帐号进行，普通用户可以通过如下方式使用：
/sbin/ifconfig
5.5	tcpdump(中级)
功能说明：倾倒网络传输数据。
语　　法：tcpdump [-adeflnNOpqStvx][-c<数据包数目>][-dd][-ddd][-F<表达文件>][-i<网络界面>][-r<数据包文件>][-s<数据包大小>][-tt][-T<数据包类型>][-vv][-w<数据包文件>][输出数据栏位]
补充说明：执行tcpdump指令可列出经过指定网络界面的数据包文件头，在Linux操作系统中，你必须是系统管理员。
参　　数：
-a 尝试将网络和广播地址转换成名称。
-c<数据包数目> 收到指定的数据包数目后，就停止进行倾倒操作。
-d 把编译过的数据包编码转换成可阅读的格式，并倾倒到标准输出。
-dd 把编译过的数据包编码转换成C语言的格式，并倾倒到标准输出。
-ddd 把编译过的数据包编码转换成十进制数字的格式，并倾倒到标准输出。
-e 在每列倾倒资料上显示连接层级的文件头。
-f 用数字显示网际网络地址。
-F<表达文件> 指定内含表达方式的文件。
-i<网络界面> 使用指定的网络截面送出数据包。
-l 使用标准输出列的缓冲区。
-n 不把主机的网络地址转换成名字。
-N 不列出域名。
-O 不将数据包编码最佳化。
-p 不让网络界面进入混杂模式。
-q 快速输出，仅列出少数的传输协议信息。
-r<数据包文件> 从指定的文件读取数据包数据。
-s<数据包大小> 设置每个数据包的大小。
-S 用绝对而非相对数值列出TCP关联数。
-t 在每列倾倒资料上不显示时间戳记。
-tt 在每列倾倒资料上显示未经格式化的时间戳记。
-T<数据包类型> 强制将表达方式所指定的数据包转译成设置的数据包类型。
-v 详细显示指令执行过程。
-vv 更详细显示指令执行过程。
-x 用十六进制字码列出数据包资料。
-w<数据包文件> 把数据包数据写入指定的文件。：

常用方式及使用技巧:
使用tcpdump之前需要使用ifconfig来看使用那个网卡进行交互
tcpdump –s –i eth0 –w login.cap port 8080
注意：如果想抓本机到本机的包（例如：JavaMe和其他应用安装在同一台机器上），必须抓lo网卡的包
tcpdump –s –i eth0 –w login.cap port 8080

5.6	ftp(初级)
功能说明：设置文件系统相关功能。
语　　法：ftp [-dignv][主机名称或IP地址]
补充说明：FTP是ARPANet的标准文件传输协议，该网络就是现今Internet的前身。
参　　数：
-d 详细显示指令执行过程，便于排错或分析程序执行的情形。
-i 关闭互动模式，不询问任何问题。
-g 关闭本地主机文件名称支持特殊字符的扩充特性。
-n 不使用自动登陆。
-v 显示指令执行过程。
5.7	wget(中级)
6	vi命令(中级)
:set nu
:set ic
/
:%s/string/replacestring/g
:x
:w
:q!
:wq

7	获取帮助的途径
7.1	man(初级)

敏捷测试团队，不再仅仅是在coding之后。而是和研发人员贯穿在需求分析、规格说明、自动化单元测试、自动化验收测试、静态代码分析、技术债等环节中。所以敏捷项目必定在将来效率的趋势下成为主流。

sort [option] [filename]
-u 忽略重复行
-n 按照数字大小排序
-r 逆序
-k start,endstart为比较的起始位置，end为结束位置
sort -nk 2 -t - sort.txt 以-进行分割，对分割后的第二个域进行排序；
sort -nrk 2 -t - sort.txt 逆序排序

login
login [name][-p][-h 主机名称]

at [-V] [-q x] [-f file] [-m] time
－V：显示标准错误输出。
－q：许多队列输出。
－f：从文件中读取作业。
－m：执行完作业后发送电子邮件到用户。
time：设定作业执行的时间。time格式有严格的要求，由小时、分钟、日期和时间的偏移量组成，其中日期的格式为MM.DD.YY，MM是分钟，DD是日期，YY是指年份。偏移量的格式为时间＋偏移量，单位是minutes、hours和days。
at -f data 15:30 +2 days #两天后的17：30执行文件data中指明的作业

lp [－c][－d][－m][－number][－title][-p]
－c：先拷贝文件再打印。
－d：打印队列文件。
－m：打印结束后发送电子邮件到用户。
－number：打印份数。
－title：打印标题。
－p：设定打印的优先级别，最高为100。


1、最后一个参数：!$
mv /path/to/wrongfile /some/other/place
mv: cannot stat '/path/to/wrongfile': No such file or directory
mv /path/to/rightfile !$
mv /path/to/rightfile /some/other/place
2、第 n 个参数：!:2
$ tar -cvf afolder afolder.tar
tar: failed to open
$ !:0 !:1 !:3 !:2
tar -cvf afolder.tar afolder
3、全部参数：!:1-$
grep '(ping|pong)' afile
egrep !:1-$
egrep '(ping|pong)' afile
ping
4、倒数第 n 行的最后一个参数：!-2:$
$ mv /path/to/wrongfile /some/other/place
mv: cannot stat '/path/to/wrongfile': No such file or directory
$ ls /path/to/
rightfile
mv /path/to/rightfile !-2:$
mv /path/to/rightfile /some/other/place
5、进入文件夹：!$:h
tar -cvf system.tar /etc/system
tar: /etc/system: Cannot stat: No such file or directory
tar: Error exit delayed from previous errors.
cd !$:h
cd /etc
6、当前行：!#:1
cp /path/to/some/file !#:1.bak
cp /path/to/some/file /path/to/some/file.bak
7、搜索并替换：!!:gs
echo my f key doef not work
my f key doef not work
!!:gs/f /s /
echo my s key does not work
my s key does not work
!!:gs/does/did/
echo my s key did not work
my s key did not work
$ ping !#:0:gs/i/o
$ vi /tmp/!:0.txt
$ ls !$:h
$ cd !-2:$:h
$ touch !$!-3:$ !! !$.txt
$ cat !:1-$

tig：字符模式下交互查看git项目，可以替代git命令。
mycli：mysql客户端，支持语法高亮和命令补全，效果类似ipython，可以替代mysql命令。
jq: json文件处理以及格式化显示，支持高亮，可以替换python -m json.tool。
shellcheck：shell脚本静态检查工具，能够识别语法错误以及不规范的写法。
fzf：命令行下模糊搜索工具，能够交互式智能搜索并选取文件或者内容，配合终端ctrl-r历史命令搜索简直完美。
htop: 提供更美观、更方便的进程监控工具，替代top命令。
glances：更强大的 htop / top 代替者。
axel：多线程下载工具，下载文件时可以替代curl、wget。
sz/rz：交互式文件传输，在多重跳板机下传输文件非常好用，不用一级一级传输。
cloc：代码统计工具，能够统计代码的空行数、注释行、编程语言。
multitail：多重  tail。
htmlq 像jq，但对于 HTML

文件切割 - split
-a: #指定输出文件名的后缀长度(默认为2个:aa,ab...)
-d: #指定输出文件名的后缀用数字代替
-l: #行数分割模式(指定每多少行切成一个小文件;默认行数是1000行)
-b: #二进制分割模式(支持单位:k/m)
-C: #文件大小分割模式(切割时尽量维持每行的完整性)
split [-a] [-d] [-l <行数>] [-b <字节>] [-C <字节>] [要切割的文件] [输出文件名]
使用实例
# 行切割文件
split -l 300000 users.sql /data/users_
# 使用数字后缀
split -d -l 300000 users.sql /data/users_
# 按字节大小分割
split -d -b 100m users.sql /data/users_
文件合并 - cat
-n: #显示行号
-e: #以$字符作为每行的结尾
-t: #显示TAB字符(^I)
cat [-n] [-e] [-t] [输出文件名]
# 合并文件
cat /data/users_* > users.sql

uniq
uniq [OPTION]... [INPUT [OUTPUT]]
-c, --count
  显示行出现的次数
-d, --repeated
  仅显示重复出现的行，即出现次数 >=2 的行，且只打印一次
-D, --all-repeated[=delimit-method]
  仅显示重复的行，即出现次数 >=2 的行，且打印重复行的所有行。其中 delimit-method 表示对重复行集合的分隔方式，有三种取值，分别为none、prepend和separate。其中none表示不进行分隔，为默认选项，uniq -D等同于uniq --all-repeated=none；prepend表示在每一个重复行集合前面插入一个空行；separate表示在每个重复行集合间插入一个空行。
-f, --skip-fields=N
  忽略前N个字段。字段由空白字符（空格符、Tab）分隔。如果您的文档的行被编号，并且您希望比较行中除行号之外的所有内容。如果指定了选项 -f 1，那么下面相邻的两行：
  1 这是一条线
  2 这是一条线
  将被认为是相同的。如果没有指定 -f 1 选项，它们将被认为是不同的
-i, --ignore-case
  忽略大小写字符的不同
-s, --skip-chars=N
  跳过前面N个字符不比较
-u, --unique
  只显示唯一的行，即出现次数等于1的行
-w, --check-chars=N
  指定每行要比较的前N个字符数
--help
  显示帮助信息并退出
--version
  显示版本信息并退出

uniq testfile
cat testfile | sort | uniq
sort testfile | uniq -c
sort testfile | uniq -dc
sort testfile | uniq -u
uniq -w3 -D test.txt

export 环境变量命令
export [-fn] [NAME[=WORD]]...
-f
 表示 NAME 为函数名称
-n
 删除指定的变量。变量实际上并未删除，只是不会输出到后续指令的执行环境中
-p
 列出所有的 Shell 环境变量
export MYNEWV=8
export PATH=$PATH:/usr/local/mysql/bin
export -p | grep PATH
echo $PATH

stat 命令
stat [OPTION]... FILE..
-L, --dereference: 跟随符号链接解析原文件而非符号链接；
-f, --file-system: 显示文件所在文件系统信息而非文件信息；
-c,--format=FORMAT: 以指定格式输出，而非默认格式；
 显示文件信息可用格式控制符如下：
 %a：以八进制显示访问权限
 %A：以可读形式显示访问权限
 %b：显示占有块数
 %B：显示每一块占有的字节数
 %C：SELinux security context string
 %d：十进制显示文件所在设备号
 %D：十六进制显示文件所在设备号
 %f：十六进制显示文件类型
 %F：文件类型。Linux 下文件类型主要分为普通文件、目录、字符设备文件、块设备文件、符号链接文件、套接字等
 %g：文件所有者组 ID
 %G：文件所有者组名称
 %h：文件硬链接数
 %i：inode 号
 %m：文件所在磁盘分区挂载点，比如/data
 %n：文件名称
 %N：单引号括起来的文件名称，如果是软链接，则同时显示指向的文件名称
 %o：optimal I/O transfer size hint
 %s：实际文件大小，单位字节
 %t：major device type in hex, for character/block device special files
 %T：minor device type in hex, for character/block device special files
 %u：所有者用户 ID
 %U：所有者用户名称
 %w：文件创建时间，输出-表示无法得知
 %W：文件创建时间，输出 Unix 时间戳，0 表示无法得知
 %x：可读形式输出最后访问时间 atime
 %X：Unix 时间戳输出最后访问时间 atime
 %y：可读形式输出最后修改时间 mtime
 %Y：Unix 时间戳输出后修改时间 mtime
 %z：可读形式输出最后状态改变时间 ctime
 %Z：Unix 时间戳输出最后状态改变时间 ctime
 
 显示文件系统信息可用格式控制符有：
 %a：非超级用户可使用的自由 block 数
 %b：文件系统总 block 数
 %c：文件系统总文件节点数
 %d：可用文件节点数
 %f：可用文件 block 数
 %i：十六进制文件系统 ID
 %l：最大文件名称长度
 %n：文件名称
 %s：一个块的大小，单位字节（for faster transfers）
 %S：一个块的基本大小，单位字节（用于统计 block 的数量）
 %t：十六进制输出文件系统类型
 %T：可读形式输出文件系统类型
--printf=FORMAT: 以指定格式输出，而非默认格式。与--format 作用类似，但可以解释反斜杠转义字符，比如换行符、n；
-t, --terse: 简洁模式输出，只显示摘要信息；
--help: 显示帮助信息；
--version: 显示版本信息。

stat test.log
File: test.log: 文件名称为 test.log
Size: 1598: 文件大小 1598 字节
Blocks: 8：文件占用的块数
IO Block: 4096：
regular file：文件类型（普通文件）
Device: fd01h/64769d：文件所在设备号，分别以十六进制和十进制显示
Inode: 1579435：文件节点号
Links: 1：硬链接数
Access: (0644/-rw-r--r--)：访问权限
Uid：所有者 ID 与名称
Gid：所有者用户组 ID 与名称
Access：最后访问时间
Modify：最后修改时间
Change：最后状态改变时间
Birth -：无法获知文件创建时间。注意：Linux 下的文件未存储文件创建时间

stat -f Makefile
File: "Makefile"：文件名称为"Makefile"；
ID: 6f75a4f02634e23e：文件系统 ID
Namelen: 255：最大文件名称长度
Type: ext2/ext3：文件系统类型名称
Block size: 4096：块大小为 4096 字节
Fundamental block size: 4096：基本块大小为 4096 字节

export 命令
export [-fn] [NAME[=WORD]]...
export -p
-f
 表示 NAME 为函数名称
-n
 删除指定的变量。变量实际上并未删除，只是不会输出到后续指令的执行环境中
-p
 列出所有的 Shell 环境变量
export MYNEWV=8
export PATH=$PATH:/usr/local/mysql/bin
export -p | grep PATH
echo $PATH
vi test1.sh
#!/bin/sh
shareVar=666
export shareVar
./test2.sh
vi test2.sh
#!/bin/sh
echo "in $0"
echo $shareVar

time 命令
time [OPTIONS] COMMAND [ARGUMENTS]
-f, --format=FORMAT
 使用指定格式输出。如果没有指定输出格式，采用环境变量 TIME 指定的格式
-p, --portability
 使用兼容 POSIX 的格式输出，real %e\nuser %U\nsys %S
-o, --output=FILE
 结果输出到指定文件。如果文件已经存在，覆写其内容
-a, --append
 与 -o 选项一起使用，使用追加模式将输出写入指定文件
-v, --verbose
 使用冗余模式尽可能地输出统计信息
--help
 显示帮助信息
-V, --version
 显示版本信息
--
 终止选项列表
Time
%E：执行指令所花费的时间，格式 [hours:]minutes:seconds
%e：执行指令所花费的时间，单位是秒
%S：指令执行时在内核模式（kernel mode）所花费的时间，单位是秒
%U：指令执行时在用户模式（user mode）所花费的时间，单位是秒
%P：执行指令时 CPU 的占用比例。其实这个数字就是内核模式加上用户模式的 CPU 时间除以总时间（(%S+%U)/%E）

Memory
%M：执行时所占用的内存的最大值。单位 KB
%t：执行时所占用的内存的平均值，单位是 KB
%K：执行程序所占用的内存总量（stack+data+text）的平均大小，单位是 KB
%D：执行程序的自有数据区（unshared data area）的平均大小，单位是 KB
%p：执行程序的自有栈（unshared stack）的平均大小，单位是 KB
%X：执行程序是共享代码段（shared text）的平均值，单位是 KB
%Z：系统内存页的大小，单位是 byte。对同一个系统来说这是个常数
%F：内存页错误次数。内存页错误指需要从磁盘读取数据到内存
%R：次要或可恢复的页面错误数。这些是无效页面的错误，但其他虚拟页面尚未使用该内存页。因此，页面中的数据仍然有效，但必须更新系统表
%W：进程从内存中交换的次数
%c：进程上下文被切换的次数（因为时间片已过期）
%w：进程等待次数，指程序主动进行上下文切换的次数，例如等待 I/O 操作完成

I/O
%I：此程序所输入的档案数
%O：此程序所输出的档案数
%r：此程序所收到的 Socket Message
%s：此程序所送出的 Socket Message
%k：此程序所收到的信号 （Signal）数量

Command Info
%C：执行时的参数指令名称
%x：指令的结束代码 ( Exit Status )

time date
time --format="%C\n%x" date +%s


ldconfig 命令
/sbin/ldconfig [ -nNvXV ] [ -f conf ] [ -C cache ] [ -r root ] directory ...
/sbin/ldconfig -l [ -v ] library ...
/sbin/ldconfig -p
-v, --verbose
 用此选项时，ldconfig 将显示正在扫描的目录及搜索到的动态链接库，还有它所创建的链接的名字

-n
 ldconfig 仅扫描命令行指定的目录，不扫描默认目录（/lib、/usr/lib），也不扫描配置文件 /etc/ld.so.conf 所列的目录。

-N
 ldconfig 不重建缓存文件（/etc/ld.so.cache），若未用 -X 选项，ldconfig 照常更新文件的链接

-X
 ldconfig 不更新文件的链接，若未用 -N 选项，则缓存文件照常重建

-f <conf >
 指定动态链接库的配置文件为 <conf > ，系统默认为 /etc/ld.so.conf

-C <cache>
 指定生成的缓存文件为 <cache>，系统默认的是 /etc/ld.so.cache，此文件存放已排好序的可共享的动态链接库的列表

-r <root>
 改变应用程序的根目录为 <root>（是调用 chroot 函数实现的）。选择此项时，系统默认的配置文件 /etc/ld.so.conf，实际对应的为 <root>/etc/ld.so.conf。如用 -r /usr/zzz 时，打开配置文件 /etc/ld.so.conf 时，实际打开的是 /usr/zzz/etc/ld.so.conf 文件。用此选项，可以大大增加动态链接库管理的灵活性

-l
 通常情况下，ldconfig 搜索动态链接库时将自动建立动态链接库的链接，选择此项时，将进入专家模式，需要手工设置链接，一般用户不用此项

-p, --print-cache
 ldconfig 打印出当前缓存文件保存的所有共享库的名字

-c FORMAT 或 --format=FORMAT：此选项用于指定缓存文件所使用的格式，共有三种：old（老格式），new（新格式）和 compat（兼容格式，此为默认格式）。

-V
 打印出 ldconfig 的版本信息

-?, --help, --usage
 这三个选项作用相同，都是让 ldconfig 打印出其帮助信息

 ulimit 命令
 ulimit [-HSTabcdefilmnpqrstuvx [limit]]
-H
 设定资源的硬限制，只有 root 用户可以操作
-S
 设置资源的软限制
-a
 显示目前所有资源设定的限制
-b
 socket 缓冲的最大值，单位 
-c
 core 文件的最大值，单位 blocks
-d
 进程数据段的最大值，单位 KB
-e
 调度优先级上限，这里的优先级指 NICE 值。只针对普通用户进程有效
-f
 当前 Shell 可创建文件总大小的上限，单位 blocks
-i
 被挂起/阻塞的最大信号数量
-l
 可以锁住的物理内存的最大值，单位 KB
-m
 可以使用的常驻内存的最大值，单位 KB
-n
 每个进程可以同时打开的最大文件数
-p
 管道的最大值，单位 block，1 block = 512 bytes
-q
 POSIX 消息队列的最大值
-r
 限制程序实时优先级，只针对普通用户进程有效
-s
 进程栈最大值，单位 KB
-t
 最大 CPU 时间，单位 s
-u
 用户最多可启动的进程数目
-v
 当前 Shell 可使用的最大虚拟内存，单位 KB
-x
 文件锁的最大数量
-T
 线程的最大数量
ulimit -a
ulimit -c unlimited
ulimit -s unlimited
