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
df -a #显示所有文件系统磁盘空间使用信息
df -h #以人类可读的格式显示磁盘空间使用情况
df -hT /home #显示 / home 文件系统信息
df -k #以字节为单位显示文件系统信息
df -m #以MB为单位显示文件系统信息
df -g #以 GB 为单位显示文件系统信息
df -i #显示文件系统 inode
df -T #显示文件系统类型
df -t ext3 #包括某些文件系统类型
df -x ext3 #排除某些文件系统类型

2.5	fdisk(中级)
功能说明：磁盘分区。
语　　法：fdisk [-b <分区大小>][-uv][外围设备代号] 或 fdisk [-l][-b <分区大小>][-uv][外围设备代号...] 或 fdisk [-s <分区编号>]
补充说明：fdisk是用来磁盘分区的程序，它采用传统的问答式界面，而非类似DOS fdisk的cfdisk互动式操作界面，因此在使用上较为不便，但功能却丝毫不打折扣。
fdisk [-uc] [-b sectorsize] [-C cyls] [-H heads] [-S sects] device
fdisk -l [-u] [device...]
fdisk -s partition...
fdisk -v
fdisk -h
参　　数：
-b [sectorsize]:指定硬盘扇区大小，可用数值为512, 1024, 2048 or 4096；
-c：关闭DOS兼容模式；
-C [cyls]:指定硬盘的柱面数（number of cylinders）；
-H [heads]:指定硬盘的磁头数（number of heads），当然不是物理数值，而是作用于分区表。合理取值是255和16；
-S [sects]:指定每个磁道的扇区数，当然不是物理数值，而是用于分区表。一个合理的数值是63；
-l：列出指定设备的分区表，然后退出。如果没有给定设备，则使用在/proc/partitions（如果存在）中提到的那些设备；
-u：在列出分区表时，给出扇区大小而不是柱面大小；
-s [partition]:以块（block）为单位，显示指定分区的大小；
-v:显示版本信息；
-h:显示帮助信息。
常用方式及使用技巧:fdisk -l
fdisk -l /dev/sda
Device：分区名称；
Boot：是否是活动分区。活动分区只能是主分区，一个硬盘只能有一个活动的主分区；一个硬盘的主分区与扩展分区总和不能超过4个。硬盘分区遵循着“主分区→扩展分区→逻辑分区”的次序原则，而删除分区则与之相反。
 主分区：一个硬盘可以划分多个主分区，但没必要划分那么多，一个足矣。
 扩展分区：主分区之外的硬盘空间就是扩展分区，
 逻辑分区：是对扩展分区再行划分得到的。
Start：分区柱面的开始下标；
End：分区柱面的结束下标；
Blocks：该分区的块数量。当前文件系统block=2*sector，所以块数量=（End-Start）*柱面的扇区数/2=1305*255*63/2=10482412.5；
Id：各种分区的文件系统不同，如有ntfs分区，fat32分区，ext3分区，swap分区等。每一种文件系统都有一个代号，对应这里的Id。常见的文件系统ID有：
 f：FAT32 Extend,只限于扩展分区。
 86：NTFS。
 7：HPFS/NTFS
 b：FAT32。
 83：Linux Ext2。
 82：Linux 交换区。
System：文件系统名称。
mkfs.ext3 /dev/sdb6
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
-b, --ignore-leading-blanks
 忽略每行前面的空格字符
-c, --check, --check=diagnose-first
 只检查文件是否已排序，不进行排序
-C, --check=quiet, --check=silent
 类似于 -c，但不报告第一个乱序的行
-d, --dictionary-order
 按照字典序，只考虑字母、数字及空格字符，忽略其他字符
--files0-from=F
 从文件 F 中以 NUL 字符结尾的字符串作为输入文件名；如果 F 是 -，则从标准输入中读取文件名
-f, --ignore-case
 排序时，将小写字母视为大写字母
-i, --ignore-nonprinting
 排序时，只考虑可打印字符，忽略不可打印字符
-m, --merge
 合并多个已排序的文件
-n, --numeric-sort
 按数值大小排序
-o, --output=FILE
 将排序结果输出到指定文件
-r,--reverse
 逆向输出排序结果（降序排序）
-t, --field-separator=SEP
 指定排序时使用的分隔字符，sort命令默认字段分隔符为空格和Tab
-u, --unique
 相同的数据中，仅输出一行
-k,--key=POS1[,POS2]
 以第 POS1 栏到 POS2 栏排序，默认到最后一栏
--help
 显示帮助信息并退出
--version
 显示版本信息并退出
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

tr（translate）用来转换或者删除一段文字。tr 所有的功能均可由 sed 来完成，可以将 tr 视为 sed 一个极简的实现。
tr [OPTIONS] SET1 [SET2]
-c, -C, --complement SET1 [SET2]
 将字符集 SET1 以外的其他字符删除或者转换为字符集 SET2 中的最后一个字符（如果你指定了多个字符的话）
-d, --delete
 删除 SET1 这个字符串
-s, --squeeze-repeats
 如果 SET1 中的字符连续出现多次，压缩重复的字符，只保留一个
-t, --truncate-set1
 先将 SET1 的长度截为和 SET2 相等
--help
 显示帮助信息并退出
--version
 显示版本信息并退出
（1）将 last 输出的信息中所有小写的字符变成大写字符。
last | tr [a-z] [A-Z]
（2）将 /etc/passwd 输出的信息中的冒号 : 删除。
cat /etc/passwd | tr -d ':'
（3）将 DOS 文件转成 Unix 文件。
cat /etc/passwd | tr -d '\r'
（4）删除空行。
cat file | tr -s "\n" > new_file
（5）将文件中 “abc” 分别替换为 “xyz” 中对应的字符。
cat file | tr "abc" "xyz" > newFile
这里凡是在 file 中出现的"a"字母，都替换成"x"字母，"b"字母替换为"y"字母，“c"字母替换为"z"字母，而不是将字符串"abc"替换为字符串"xyz”。
（6）替换指定字符集以外的字符。
echo -n "alv blv" | tr -c "lv " "x"
xlv xlv
echo -n 表示不输出换行符。
（7）从输入文本中将不在补集中的所有字符删除。
echo -n "alv blv" | tr -dc "lv"

su [OPTIONS] [-] [USER [ARG...]]
-c, --command=CMD
 执行完指定命令后，立即恢复原来的用户身份
--session-command=CMD
 等同于选项 -c，但不创建新会话
-, -l, --login
 切换用户身份时启动一个新的 Shell。此选项可同时改变工作目录和 HOME、SHELL、USER、LOGNAME 等环境变量，也包括环境变量 PATH
-f, --fast
 不必读启动文件（如 csh.cshrc 等），仅用于 csh 或 tcsh 两种 Shell
-m, --preserve-environment
 保留原用户的 Shell 环境变量
-p
 同 -m
-s, --shell=SHELL
 指定使用的 Shell
-h, --help
 显示帮助信息并退出
-v, --version
 显示版本信息并退出

sudo [OPTIONS] [CMD]
-A
 使用辅助程序（可能是图形化界面的程序）读取用户的密码并将密码输出到标准输出。如果设置了环境变量 SUDO_ASKPASS，它会指定辅助程序的路径，否则，由配置文件 /etc/sudo.conf 的 askpass 选项来指定辅助程序的路径。如果没有可用的辅助程序，sudo 将错误退出
-b
 选项 -b（background）把 sudo 所要运行的命令放到后台运行
-E
 选项 -E（preserve Environment）向安全策略指示用户希望保存他们现有的环境变量。如果指定了 -E 选项，且用户没有保留环境变量的权限，则安全策略可能返回错误
-H
 选项 -H（Home）将 HOME 环境变量设置为目标用户的家目录，目标用户默认为 root
-h
 选项 -h（help）显示帮助信息并退出
-i [CMD]
 选项 -i（simulate initial login）将模拟初始登录，即启动目标用户在 /etc/passwd 中配置的 Shell，相关的资源文件将被读取并执行，比如 ~/.profile 和 ~/.login。如果后跟命令 CMD，则 CMD 将被传递给 Shell 并被执行
-K
 选项 -K（sure Kill）类似于 -k，它只用于删除了用户的缓存凭据，不能与命令或其他选项一起使用
-k [CMD]
 单独使用 -k（kill）选项时，使密码缓存失效，也就是下次执行 sudo 时便需要输入密码。如果后跟命令，表示忽略缓存密码，需要用户重新输入密码 ，新输入的密码不会更新密码缓存
-l[l] [CMD]
 如果选项 -l（list）后不跟命令，则列出 sudo 允许当前用户（或使用 -U 指定的其他用户）执行的指令和无法执行的指令。如果指定了命令并被安全策略所允许，则将显示该命令绝对路径以及命令参数。如果指定了命令不被允许，sudo 以状态码 1 退出。如果使用 -ll 或多次指定 -l 选项，则使用长格式输出
-n
 选项 -n（non-interactive）表示以非交互模式执行 sudo，阻止 sudo 向用户询问密码。如果执行命令时需要密码，则 sudo 将报错误信息并退出
-p PROMPT
 改变询问密码的提示符号
-s [CMD]
 选项 -s（shell）执行环境变量 SHELL 表示的 Shell，如果 SHELL 没有值，则执行目标用户在配置文件 /etc/passwd 中配置的 Shell。如果选项后跟命令，则传递给 Shell 执行，如果没有指定命令，则执行交互式 Shell
-U USER
 选项 -U（other user）与 -l 选项一起使用，以指定应列出其权限的用户。sudoers 策略仅允许 root 用户或当前主机上具有 ALL 权限的用户使用此选项
-u USER
 选项 -u（user）指定执行命令时使用的用户身份，默认为 root。如果使用 uid 则使用 #uid 表示用户
-V
 选项 -V（version）显示版本信息并退出
-v
 选项 -v（validate）使密码有效期延长 5 分钟

sudo –u USERNAME CMD

nc [-46DdhklnrStUuvzC] [-i interval] [-p source_port] [-s source_ip_address] [-T ToS] [-w timeout] [-X proxy_protocol] [-x proxy_address[:port]] [hostname] [port[s]]
-4/6
 强制只使用 IPv4/IPv6 地址
-D
 在套接字上启用调试
-d
 不从 stdin 读取
-h
 打印出帮助信息
-k
 强制 nc 在当前连接完成后继续侦听另一个连接。注意如果不使用 -l 选项，则使用此选项是错误的
-l
 指定 nc 应该侦听传入的连接，而不是启动到远程主机的连接。将此选项与 -p、-s 或 -z 选项结合使用是错误的。此外，使用 -w 选项指定的超时将被忽略
-n
 不要在任何指定的地址、主机名或端口上执行任何 DNS 或服务查找
-r
 随机选择源端口和目标端口，而不是按照系统分配的顺序或范围内的顺序选择它们
-S
 启用 RFC 2385 TCP MD5 签名选项
-t
 使 nc 发送 RFC 854 DON'T 和 WON'T 响应 RFC 854 的 DO 和 WILL 请求。这使得使用 nc 编写 telnet 会话脚本成为可能
-U
 指定使用 Unix 域套接字
-u
 使用 UDP 代替默认选项 TCP
-v
 显示命令执行过程
-z
 表示 zero，只扫描侦听守护进程，而不向它们发送任何数据。此选项与 -l 选项结合使用是错误的
-C
 发送 CRLF 作为换行符
-i interval
 指定发送和接收的文本之间的延迟时间间隔。还可指定连接到多个端口之间的延迟时间
-p source_port
 指定 nc 应使用的源端口，但须受特权限制和可用性限制。将此选项与 -l 选项结合使用是错误的
-s source_ip_address
 设置本地主机送出数据包的 IP 地址。注意将此选项与 -l 选项结合使用是错误的
-T ToS
 指定连接的 IP 服务类型 (TOS)。有效值是标记 ''lowdelay'', ''throughput'', ''reliability''，或以 0x 开头的 8 位十六进制值
-w timeout
 如果连接和 stdin 空闲超过指定秒数，则连接将被关闭。-w 标志对 -l 选项没有影响。缺省不超时
-X proxy_protocol
 请求 nc 在与代理服务器对话时使用指定的协议。支持的协议是 “4”(SOCKsv.4)、“5”(SOCKV.5) 和 “connect”(HTTPS proxy)。如果未指定协议，则使用 SOCKS v.5
-x proxy_address[:port]
 使用指定代理服务器地址和端口连接到主机。如果未指定端口，则使用代理协议的已知端口（SOCKS 为 1080，HTTPS 为 3128）
nc 的控制参数不少，常用的几个参数如下所列：

-l
 指定 nc 将处于侦听模式。指定该参数，则意味着 nc 被当作 server，侦听并接受连接，而非向其它地址发起连接
-p PORT
 指定 nc 使用的源端口
-s 
 指定发送数据的源 IP 地址，适用于多网卡机器
-u
 指定 nc 使用 UDP 协议，默认为 TCP
-v
 输出交互或出错信息，新手调试时尤为有用
-w
 超时秒数，后面跟数字 
-z
 表示 zero，扫描时不发送任何数据

监听本地端口。假设在当前命令行终端 A 进行监听。
nc -vl 8888
开启另外一个命令行终端 B，同样使用 nc 发起连接。
nc -v 127.0.0.1 8888
receiver：
nc -l 8888 > received.txt
sender:
nc 127.0.0.1 8888 < file.txt
receiver：
nc -l 8888 | tar -xzvf -
sender：
tar -czvf - DIR_NAME | nc 127.0.0.1 8888
第 1 步，在 A 机器先启动接收数据的命令，监听自己的 8888 端口，把来自这个端口的数据都输出给空设备（这样不写磁盘，测试网速更准确）。
nc -l 8888 > /dev/null
第 2 步，在 B 机器发送数据，把无限个 0 发送给 A 机器的 8888 端口。
nc 10.0.1.161 8888 < /dev/zero

gpasswd [OPTIONS] GROUP
-a, --add USER
 向组 GROUP 中添加用户 USER
-d, --delete USER
 从组 GROUP 中添加或删除用户
-h, --help
 显示此帮助信息并退出
-r, --delete-password
 删除组密码
-R, --restric t
向其成员限制访问组 GROUP
-M, --members USER,...
 设置组 GROUP 的成员列表
-A, --administrators ADMIN,...
 设置组的管理员列表
（1）向组 test 中添加用户 itcast。
gpasswd -a itcast test
（2）从组 test 中删除用户。
gpasswd -d itcast test
（3）移除组的密码。
gpasswd  -r test
（4）设置组的管理员列表。
gpasswd -A deng test
（5）给用户组创建密码。
gpasswd test

groupmod [OPTIONS] GROUP
-g, --gid GID
 将组 ID 改为 GID
-h, --help
 显示此帮助信息并推出
-n, --new-name NEW_GROUP
 改名为 NEW_GROUP
-o, --non-unique
 允许使用重复的 GID
-p, --password PASSWORD
 将密码更改为（加密过的） PASSWORD
1）改用户组 ID。
groupmod -g 8888 g5
2）更改用户组名。
groupmod -n heima g5
（4）允许使用重复的 GID。
groupmod -g 8888 -o g4

groupdel [OPTIONS] GROUP
groupdel g1
groupdel -h

groupadd [OPTIONS] GROUP
-f, --force
   如果组已经存在则成功退出并且如果 GID 已经存在则取消 -g
  -g, --gid GID
   为新组使用 GID
  -h, --help
   显示帮助信息并推出
  -K, --key KEY=VALUE
   不使用 /etc/login.defs 中的默认值
  -o, --non-unique
   允许创建有重复 GID 的组
  -p, --password PASSWORD
   为新组使用加密过的密码
  -r, --system
   创建一个系统组
groupadd  g1
groupadd -g 888 g2
groupadd -r -g 889 g3
groupadd -o -r -g 889 g4
/etc/group  #群组信息
/etc/gshadow #群组加密信息

userdel [options] LOGIN
-f, --force
  强制删除用户，即使用户当前已登录
-h, --help
 显示帮助信息并推出
-r, --remove
 删除用户的同时删除与用户相关的所有文件，比如删除主目录和邮件池
-R, --root CHROOT_DIR
   在 CHROOT_DIR 目录中应用更改并使用 CHROOT_DIR 目录中的配置文件
-Z, --selinux-user
 为用户删除所有的 SELinux 用户映射
userdel tom
userdel -r tom
userdel -f tom

usermod [OPTIONS] LOGIN
-c, --comment
 添加备信息
-d, --home HOME_DIR
 用户的新主目录
-e, --expiredate EXPIRE_DATE
 设定帐户过期的日期
-f, --inactive INACTIVE
 过期 INACTIVE 天数后，设定密码为失效状态
-g, --gid GROUP
 强制使用 GROUP 为新主组
-G, --groups GROUPS
 新的附加组列表 GROUPS
-a, --append GROUP
 将用户追加至上边 -G 中提到的附加组中，并不从其它组中删除此用户
-h, --help
 显示此帮助信息并推出
-l, --login LOGIN
 新的登录名称
-L, --lock
 锁定用户帐号
-m, --move-home
 将家目录内容移至新位置 （仅于 -d 一起使用）
-o, --non-unique
 允许使用重复的（非唯一的） UID
-p, --password PASSWORD
 将加密过的密码 (PASSWORD) 设为新密码
-s, --shell SHELL
 该用户帐号的新登录 shell
-u, --uid UID
   用户帐号的新 UID
-U, --unlock
 解锁用户帐号
-Z, --selinux-user  SEUSER
 用户账户的新 SELinux 用户映射
（1）修改用户的家目录。
usermod -d /home/tom tom
（2）改变用户的 uid。
usermod -u 888 tom
（3）修改用户名为 jerry。
usermod -l jerry tom
（4）锁定 tom 用户。
usermod -L tom
（5）解锁 tom 用户。
usermod -U tom
（6）添加新的附加组。
usermod -G deng tom
（7）修改用户登录 Shell。
usermod -s /bin/sh tom
（8）修改用户的 GID。
usermod -g 1003 tom
（9）指定帐号过期日期。
usermod -e 2020-12-31 tom
（10）指定用户帐号密码过期多少天后，禁用该帐号。
usermod -f 3 tom

useradd [options] LOGIN
useradd -D
useradd -D [options]
-b, --base-dir BASE_DIR
 新账户的主目录的基目录
-c, --comment COMMENT
 新账户的备注信息，备注信息保存在 /etc/passwd 的备注栏中
-d, --home-dir HOME_DIR
 新账户的主目录
-D, --defaults
 显示或更改默认的 useradd 配置
-e, --expiredate EXPIRE_DATE
 新账户的过期日期，日期格式为 YYYY-MM-DD。如果未指定，useradd 将使用在 /etc/default/useradd 中指定的到期日期 EXPIRE，或默认情况下使用空字符串（无过期）
-f, --inactive INACTIVE
 指定在密码过期后多少天即关闭该账号。如果为 0 账号立即被停用；如果为 -1 则账号一直可用。默认值为 -1
-g, --gid GROUP
 指定用户所属的主组。主组必须已经存在
-G, --groups GROUPS
 指定用户所属的附加组，多个组使用逗号分隔
-h, --help
  显示帮助信息并推出
-k, --skel SKEL_DIR
 指定用户的骨架目录。与选项 -m （或 --create-home）联用，骨架目录包含要复制到用户主目录中的文件和目录
-K, --key KEY=VALUE
 不使用 /etc/login.defs 中的默认值（UID_MIN、UID_MAX、UMASK、PASS_MAX_DAYS 等）
-l, --no-log-init
 不要将此用户添加到最近登录和登录失败数据库
-m, --create-home
 创建用户的家目录。useradd 默认会创建 home 目录，除非 /etc/login.defs 中的 CREATE_HOME 设置为 no
-M, --no-create-home
 不创建用户的主目录。即使 /etc/login.defs 中的 CREATE_HOME 设置为 yes
-N, --no-user-group
 不创建同名的组
-o, --non-unique
  允许使用重复的 UID 创建用户
-p, --password PASSWORD 
  设置账户密码，注意是使用 crypt(3) 加密后的用户密码，不是密码的明文。默认是用户密码不可用。推荐使用 passwd 命令给用户设置密码
-r, --system
   创建一个系统账户
-R, --root CHROOT_DIR
 设置根目录。在 Linux 系统中，系统默认的根目录是 /
-s, --shell SHELL 
 新账户的登录 Shell
-u, --uid UID
 新账户的用户 ID
-U, --user-group
 创建与用户同名的组，并将用户添加到此组中。为默认动作，除非  /etc/login.defs 中 USERGROUPS_ENAB 被设置为 no 或显示使用选项 -N, --no-user-group
-Z, --selinux-user SEUSER
 为 SELinux 用户映射使用指定 SEUSER

ssh [OPTIONS] [-p PORT] [USER@]HOSTNAME [COMMAND]
-1
    强制只使用协议第一版
-2
    强制只使用协议第二版
-4
    强制只使用 IPv4 地址.
-6
    强制只使用 IPv6 地址
-A
    允许转发认证代理的连接。可以在配置文件中对每个主机单独设定这个参数
-a
    禁止转发认证代理的连接
-b BIND_ADDRESS
    在拥有多个地址的本地机器上，指定连接的源地址
-C
 压缩所有数据。压缩算法与 gzip(1) 使用的相同
-c {blowfish | 3des | des}
    选择会话的密码算法。3des 是默认算法
-c CIPHER_SPEC
    另外, 对于协议第二版，这里可以指定一组用逗号隔开、按优先顺序排列的加密算法
-D [BIND_ADDRESS:]PORT
 指定一个本地主机动态的应用程序级的转发端口。工作原理是这样的，本地机器上分配了一个 socket 侦听 port 端口，一旦这个端口上有了连接，该连接就经过安全通道转发出去，根据应用程序的协议可以判断出远程主机将和哪里连接。目前支持 SOCKS4 和 SOCKS5 协议，而 ssh 将充当 SOCKS 服务器. 只有 root 才能转发特权端口。可以在配置文件中指定动态端口的转发
-e ESCAPE_CHAR
 设置 pty 会话的转义字符，默认为字符 ~。转义字符只在行首有效，转义字符后面跟一个点表示结束连接，后跟一个 control-Z 表示挂起连接，跟转义字符自己表示输出转义字符自身。把转义字符设为 none 则禁止 转义功能，使会话完全透明
-F CONFIGFILE
 指定 ssh 指令的配置文件，将忽略系统级配置文件 /etc/ssh/ssh_config 和用户级配置文件 ~/.ssh/config
-f 
    ssh 在执行命令前退至后台
-g
    允许远端主机连接本地的转发端口
-I SMARTCARD_DEVICE
    指定智能卡设备。智能卡里面存储了用户的 RSA 私钥
-i IDENTITY_FILE
    指定一个 RSA 或 DSA 认证所需的身份（私钥）文件。协议第一版的默认文件是 ~/.ssh/identity 以及协议第二版的 ~/.ssh/id_rsa 和 ~/.ssh/id_dsa 文件。可以同时使用多个 -i 选项，也可以在配置文件中指定多个身份文件
-K
 启用基于 GSSAPI 的身份验证和向服务器转发 GSSAPI 凭据
-k
   禁用向服务器转发 GSSAPI 凭据
-L [BIND_ADDRESS:]PORT:HOST:HOSTPORT
 将本地主机的地址和端口接收到的数据通过安全通道转发给远程主机的地址和端口
-l LOGIN_NAME
    指定登录远程主机的用户。可以在配置文件中对每个主机单独设定这个参数
-M
 将 ssh 客户端置于主模式进行连接共享。多个 -M 选项将 ssh 置于主模式，并在接受从连接之前进行确认
-m MAC_SPEC
 对于协议第二版，可以指定一组用逗号隔开，按优先顺序排列的 MAC (message authentication code) 算法
-N
    不执行远程命令，用于转发端口。仅限协议第二版
-n
 把 stdin 重定向到 /dev/null，防止从 stdin 读取数据。在后台运行时一定会用到这个选项
-O CTL_CMD
 控制主动连接多路复用主进程。参数 CTL_CMD 将被传递给主进程。CTL_CMD 可取值 check（检查主进程是否正在运行）和 exit（让主进程退出）
-o OPTION
    可以在这里给出某些选项，格式和配置文件中的格式一样。它用来设置那些没有单独的命令行标志的选项
-p PORT
    指定远程主机的端口。可以在配置文件中对每个主机单独设定这个参数
-q
    安静模式。消除大多数的警告和诊断信息
-R [BIND_ADDRESS:]PORT:HOST:HOSTPORT
 将远程主机上的地址和端口接收的数据通过安全通道转发给本地主机的地址和端口
-S CTL_PATH
 指定用于连接共享的控制套接字的位置
-s
    用于请求远程系统上的子系统调用。子系统是 SSH2 协议的一个特性，它有助于将 SSH 用作其他应用程序（如 sftp(1)）的安全传输。子系统通过远程命令指定
-T
    禁止分配伪终端
-t
 强制分配伪终端。这可用于在远程计算机上执行基于屏幕的任意程序，例如菜单服务。多个 -t  选项强制分配终端, 即使没有本地终端
-V
 显示版本信息并退出
-v
    冗详模式。打印关于运行情况的调试信息。在调试连接、认证和配置问题时非常有用。多个 -v 选项能够增加冗详程度，最多三个
-W HOST:PORT
 将客户端上的标准输入和输出通过安全通道转发给指定主机的端口
-w LOCAL_TUN[:REMOTE_TUN]
 指定客户端和服务端之间转发的隧道设备
-X
    允许 X11 转发，可以在配置文件中对每个主机单独设定这个参数
-x
    禁止 X11 转发
-Y
 启用受信任的 X11 转发。受信任的 X11 转发不受 X11 安全扩展控制的约束
-y
 使用 syslog(3) 系统模块发送日志信息。默认情况下，此信息被发送到 stderr

ssh -p1022 root@127.0.0.1

basename NAME [SUFFIX]
basename OPTION... NAME...
-a, --multiple
 支持多个文件名称参数，将每一个参数当做文件名对待
-s, --suffix=SUFFIX
 移除后缀
-z, --zero
 以空字符 NUL 分隔输出而不是换行符
--help
 显示帮助并退出
--version
 显示版本并退出
（1）获取文件名，不包含目录
basename /root/go/src/main.go
（2）获取文件名，不包含目录与后缀
basename /root/go/src/main.go .go
（3）同时获取多个文件名，不包含目录与后缀
basename -a -s .go /root/go/src/main.go /root/go/src/util.go
（4）如果路径最后一个是目录，那么即匹配最后一个目录的名字。
basename /root/go/src/

dirname [OPTION] NAME...
-z, --zero
 用空字符 NUL 而不是换行符分隔输出
--help
 显示帮助并退出
--version
 显示版本并退出
（1）获取目录部分，剥掉文件名。
dirname /root/go/src/main.go
获取目录部分，剥掉文件名，后跟多个文件路径。
dirname /root/go/src/main.go /root/go/src/util.go
获取目录的目录。即如果文件路径最后一个字符是 /，那么剥离倒数第二个 / 及其后的内容。
dirname /usr/bin/
如果文件路径中不包含 /，那么输出 . 表示当前目录
路径是根目录的特殊情况。不剥除任何内容，输出 /

ctrl + z、jobs、fg、bg
jobs
bg 1  
fg 2   

yum install screen
screen -S yourname
screen -ls
screen -r yourname
screen -d yourname
screen -d -r yourname
screen -S pid-X quit

info [OPTION]... [MENU-ITEM...]
-k, --apropos=STRING
 在所有手册的所有索引中查找 STRING
-d, --directory=DIR
 添加包含 info 格式帮助文档的目录
--dribble=FILENAME
 将用户按键记录在指定的文件
-f, --file=FILENAME
 指定要读取的info格式的帮助文档
-h, --help
 显示帮助信息并退出
--index-search=STRING
 转到由索引项 STRING 指向的节点
-n, --node=NODENAME
 指定首先访问的 info 帮助文件的节点
-o, --output=FILENAME
 输出被选择的节点内容到指定的文件
-R, --raw-escapes
 输出原始 ANSI 转义字符(默认)
--no-raw-escapes
 转义字符输出为文本
--restore=FILENAME
 从文件 FILENAME 中读取初始击键
-O, --show-options, --usage
 转到命令行选项节点
--strict-node-location
 (用于调试)按原样使用 info 文件指针
--subnodes
 递归输出菜单项
--vi-keys
 使用类 vi 和类 less 的绑定键
--version
 显示版本并退出
-w, --where, --location
info 有自己的交互式命令，不同于 man 使用的 less 的交互式命令
 显示 info 文件路径
?
 显示帮助窗口
x
 关闭帮助窗口
q
 关闭整个 Info
Up
 向上键，向上移动一行
Down
 向下键，向下移动一行
Space, PageDown
 翻滚到下一页，当前页的最后两行保留为下一页的起始两行
Del, PageUp
 翻滚到上一页，当前页的起始两行保留为上一页的最后两行
b, t, Home
 跳转到文档的开始
e, End
 跳转到文档的末尾
[
 转到文档中的上一个节点
]
 转到文档中的下一个节点
n
 转到与当前 Node 同等级的下一个 Node
p
 转到与当前 Node 同等级的前一个 Node
u
 转到与当前 Node 关联的上一级 Node
l
 回到上一次访问的 Node
m, g
 输入指定菜单的名字后按回车，跳转到指定的菜单项（Node 的名字）

watch [OPTIONS] COMMAND
watch date
watch -n 1 date
watch -n 1 -d date
watch -t date
watch -g date

id [OPTION]... [USER]
选项说明
-a
 忽略, 仅为与其他版本相兼容而设计
-Z, --context
 显示当前用户的安全环境（仅当系统支持 SELinux 时可用）
-g, --group
 仅显示用户所属的主组
-G, --groups
 显示用户所有的属组，包括附属组
-n, --name
 对于 -ugG 显示名称而不是替数字 ID
-r, --real
  对于 -ugG 显示真实 ID 而不是有效 ID
-u, --user
 只显示有效用户 ID
-z, --zero
 使用 NUL 字符分隔条目而不是空格符。默认输出格式不支持该选项
--help
 显示帮助信息并退出
--version
 显示版本信息并退出
（1）查看当前用户 root 与属组的信息。

id
uid=0(root) gid=0(root) groups=0(root)
输出结果中，uid 表用用户 ID，gid 表示用户主组 ID，groups 表示用户所有的属组。从 groups 可以看出，当前用户 root 只属于主用户组 root，没有附属组。
（2）查看当前用户 root 的主组 ID。
id -g
0
0 表示用户组 root 的组 ID。
（3）查看当前用户主组的名称。
id -gn
root

readelf <option> <elffile...>
readelf 用于读取 ELF（Executable and Linkable Format）格式文件的详细信息，包括目标文件、可执行文件、共享目标文件与核心转储文件。
运行 readelf 的时候，除了 -v 和 -H 之外，其它的选项必须有一个被指定。
-a,--all：显示全部信息，等价于 -h -l -S -s -r -d -V -A -I
-h,--file-header：显示文件头信息
-l,--program-headers,--segments：显示程序头（如果有的话）
-S,--section-headers,--sections：显示节头信息（如果有的话）
-g,--section-groups：显示节组信息（如果有的话）
-t,--section-details：显示节的详细信息（-S的）
-s,--syms,--symbols：显示符号表节中的项（如果有的话）
--dyn-syms：显示动态符号表节中的项（如果有的话）
-e,--headers：显示全部头信息，等价于-h -l -S
-n,--notes：显示note段（内核注释）的信息
-r,--relocs：显示可重定位段的信息。 
-u,--unwind：显示unwind段信息。当前只支持IA64 ELF的unwind段信息。 
-d,--dynamic：显示动态段的信息
-V,--version-info：显示版本段的信息
-A ,--arch-specific：显示CPU构架信息
-D,--use-dynamic：使用动态符号表显示符号，而不是符号表
-x <number or name>,--hex-dump=<number or name>：以16进制方式显示指定节内容。number指定节表中节的索引，或字符串指定文件中的节名
-R <number or name>,--relocated-dump=<number or name>：以16进制方式显示指定节内容。number指定节表中节的索引，或字符串指定文件中的节名。节的内容被展示前将被重定位。
-p <number or name>,--string-dump=<number or name>：以可打印的字符串显示指定节内容。number指定节表中节的索引，或字符串指定文件中的节名。
-c,--archive-index：展示档案头中的文件符号索引信息，执行与 ar 的 t 命令相同的功能，但不使用 BFD 库
-w[liaprmfFsoR],--debug-dump[=line,=info,=abbrev,=pubnames,=aranges,=macro,=frames,=frames-interp,=str,=loc,=Ranges]：显示调试段中指定的内容
--dwarf-depth=n：将“.debug_info”节的转储限制为n个子级。这只对--debug dump=info有用。默认为打印所有DIE（debugging information entry）；n的特殊值0也将具有此效果
--dwarf-start=n：只打印以编号为n的模具开始的DIE，仅适用于使用--debug dump=info选项时。该选项可以与--dwarf-depth=n连用。
-I,--histogram：显示符号的时候，显示 bucket list 长度的柱状图
-v,--version：显示 readelf 的版本信息
-H,--help：显示 readelf 所支持的命令行选项
-W,--wide：宽行输出
@file：可以将选项集中到一个文件中，然后使用这个 @file 选项载入
读取可执行文件形式的 ELF 文件头信息。
readelf -h file
1.1 ELF 文件分类
（1）可重定位文件（Relocatable File），这类文件包含了代码和数据，用于链接生成可以执行文件或共享目标文件，目标文件和静态链接库均属于可重定位文件，例如*.o或lib*.a文件；
（2）可执行文件（Executable File），用于生成进程映像，载入内存执行。Linux 环境下的 ELF 可执行文件一般没有扩展名，例如用户命令 ls；
（3）共享目标文件（Shared Object File），这种文件包含了代码和数据，用于和可重定位文件或其他共享目标文件一起生成可执行文件。例如 Linux 的动态共享对象（Dynamic Shared Object），C 语言运行时库 glibc-2.5.so；
（4）核心转储文件（Core Dump File），当进程意外终止时，系统可以将该进程的地址空间的内容及终止时的一些其他信息转储到核心转储文件。例如 Linux 下的 core dump。
1.2 ELF 文件组成
ELF 文件头描述了 ELF 文件的总体信息，包括系统相关、类型相关、加载相关和链接相关的信息。
（1）系统相关，比如ELF 文件标识的魔数，以及硬件和平台等相关信息，增加了 ELF 文件的移植性，使交叉编译成为可能；
（2）类型相关，比如 ELF 文件类型，分别有目标文件、可执行文件、动态链接库与核心转储文件；
（3）加载相关，比如程序头，描述了 ELF 文件被加载时的段信息；
（4）链接相关，比如节头，描述了 ELF 文件的节信息。

pidof [-s] [-c] [-n] [-x] [-m] [-o omitpid[,omitpid..]] [-o omitpid[,omitpid..]..]  program [program..]
-s
 只返回一个 PID
-c
 只显示运行在 root 目录下的进程，这个选项只对 root 用户有效
-x
 显示指定脚本名称的进程
-o OMITPID
 指定不显示的进程ID。该选项可以出现多次
-m
 与 -o 选项一起使用，使得 argv[0] 与 argv[1] 和被忽略进程相同的进程同时被忽略。一般用于忽略由同名 Shell 脚本启动的进程，因为 argv[0] 为 Shell，一般为 /bin/bash，argv[1] 为脚本名称
（1）查看程序名称为 sshd 的进程 ID。
pidof sshd

lsblk 列出所有块设备
NAME：这是块设备名。
MAJ:MIN：本栏显示主要和次要设备号。
RM：本栏显示设备是否可移动设备。注意，在本例中设备sdb和sr0的RM值等于1，这说明他们是可移动设备。
SIZE：本栏列出设备的容量大小信息。例如298.1G表明该设备大小为298.1GB，而1K表明该设备大小为1KB。
RO：该项表明设备是否为只读。在本案例中，所有设备的RO值为0，表明他们不是只读的。
TYPE：本栏显示块设备是否是磁盘或磁盘上的一个分区。在本例中，sda和sdb是磁盘，而sr0是只读存储（rom）。
MOUNTPOINT：本栏指出设备挂载的挂载点。
lsblk -m 列出一个特定设备的拥有关系
lsblk -S 获取SCSI设备的列表
lsblk -nl 以列表形式列出块设备
lsblk -b /dev/sda 获取指定块设备信息
blkid 判断raid信息
用法：lsblk [选项] [<块设备> …]
-a, --all	显示所有设备。
-b, --bytes	以bytes方式显示设备大小。
-d, --nodeps	不显示 slaves 或 holders。
-D, --discard	打印丢弃功能
-e, --exclude <list>	排除设备 (default: RAM disks)。
-I, --include <list>	仅显示具有指定主要编号的设备
-f, --fs	显示文件系统信息。
-i, --ascii	仅使用ascii字符
-m, --perms	显示权限信息。
-l, --list	使用列表格式显示。
-n, --noheadings	不显示标题。
-o, --output <list>	输出列。
-p, --paths	打印打印设备路径
-P, --pairs	使用key="value"格式显示。
-r, --raw	使用原始格式显示。
-s, --inverse	反向依赖关系
-S, --scsi	输出有关SCSI设备的信息
-t, --topology	显示拓扑结构信息。
-h, --help	显示帮助信息。
-V, --version	显示版本信息

trap 命令是 Shell 内建命令，用于指定在接收到信号后将要采取的动作。常见的用途是在脚本程序被中断时完成清理工作。
trap [-lp] [ARG] [SIGSPECS]
-l
 列出信号名称与对应的数值
-p
 列出信号与其绑定的命令列表
ARG
 与指定信号绑定的命令。如果 ARG 为空字符串，表示忽略信号；如果 ARG 不指定（缺省）或为 -，表示执行信号的默认动作
SIGSPECS
 信号列表，可以是信号名称，也可以是信号对应的数值。可用信号可以使用 trap -l 查看
（1）忽略 HUP、INT、QUIT、TSTP 信号。
trap "" HUP INT QUIT TSTP
（2）捕获 HUP、INT、QUIT、TSTP 信号，并执行默认动作。
trap HUP INT QUIT TSTP
#或
trap - HUP INT QUIT TSTP
（3）挂载 Shell 进程结束前需要执行的命令。格式为：trap “commands” EXIT。如脚本 exit.sh：
#!/bin/bash
echo "start"
trap "echo 'end'" EXIT
echo "before exit"
exit 0
执行 exit.sh 输出：
start
before exit
end


for 命令
for i in 1 2 3; do
 echo "Current # $i"
done
for i in {1..3}; do
 echo "当前值 # $i: 示例 2"
done
for i in {1..10..2}; do
 echo "Number = $i"
done
for name in str1 str2 str3; do
 echo "My name is $name"
done

#!/bin/bash
#一月前
historyTime=$(date "+%Y-%m-%d %H" -d '1 month ago')
echo ${historyTime}
historyTimeStamp=$(date -d "$historyTime" +%s)
echo ${historyTimeStamp}
 
#一周前
$(date "+%Y-%m-%d %H" -d '7 day ago')
 
#本月一月一日
date_this_month=`date +%Y%m01`
 
#一天前
date_today=`date -d '1 day ago' +%Y%m%d`
 
#一小时前
$(date "+%Y-%m-%d %H" -d '-1 hours')


iconv -f FROMCODE -t TOCODE FILE ...
iconv 命令将给定编码的文件，转换为指定编码的内容，结果默认输出到标准输出，可以使用--output或-o输出到指定文件。

-c 
 静默丢弃不能识别的字符，而不是终止转换
-f, --from-code=CODE
 指定待转换文件的编码。
-t, --to-code=CODE
 指定目标编码
-l, --list
 列出已知的字符编码。
-o, --output=FILE
 列出指定输出文件，而非默认输出到标准输出
-s, --silent
 关闭警告。
--verbose
 显示进度信息
-?, --help
 显示帮助信息
--usage
 显示简要使用方法
-V, --version
 显示版本信息
-f 和 -t 所能指定的合法编码可以在 -l 选项的结果中查看。

4.常用示例
（1）将 GBK 文件转换为 UTF8 文件。

iconv -f gbk -t utf8 inputFile.txt -o outputFile.txt.utf8
（2）转换时报如下错误：“iconv: 未知 126590 处的非法输入序列”。此时使用-c选项。

iconv -c -f gbk -t utf8 inputFile.txt -o outputFile.txt.utf8


declare（别名 typeset）属 Shell 内建命令，用于申明 Shell 变量并设置变量属性，或查看已定义的 Shell 变量和函数。若不加上任何参数，只执行 declare/typeset 则会显示全部的 Shell 变量与函数（与执行 set 指令的效果相同）。
declare [-aAfFgilrtux] [-p] [name[=value] ...]
typeset [-aAfFgilrtux] [-p] [name[=value] ...]

-a：申明数组变量
-A：申明关联数组，可以使用字符串作为数组索引
-f：仅显示已定义的函数
-F：不显示函数定义
-g：指定变量为全局变量，即使在函数内定义变量
-i：声明整型变量
-l：将变量值的小写字母变为小写
-r：设置只读属性
-t：设置变量跟踪属性，用于跟踪函数进行调试，对于变量没有特殊意义
-u：变量值的大写字母变为大写
-x：将指定的Shell变量换成环境变量
-p：显示变量定义的方式和值
+：取消变量属性，但是 +a 和 +r 无效，无法删除数组和只读属性，可以使用unset删除数组，但是 unset 不能删除只读变量

1）定义关联数组并访问。

declare -A assArray=([lucy]=beijing [yoona]=shanghai)

#读取关联数组全部内容
echo ${assArray[*]}
#或
echo ${assArray[@]}
#输出
beijing shanghai

#读取指定索引的数组值
echo ${assArray[lucy]}
#输出：
beijing

#列出数组索引列表
echo ${!assArray[*]}
#或
echo ${!assArray[@]}
#输出
yoona lucy
（2）定义只读变量。

declare -r name1="lvlv1"
#或
typeset -r name2="lvlv2"
#或
readonly name3="lvlv3"
Shell 规定，只读变量生命周期与当前 Shell 脚本进程相同，且不能消除只读属性和删除只读变量，除非 kill 当前 Shell 脚本进程。

（3）使用-p选项显示变量 name1 和 name2 的定义方式和当前值。

declare -p name1 name2
#输出
declare -r name1="lvlv1"
declare -r name2="lvlv2"
（4）使用-x选项将shell变量转换为临时环境变量，供当前Shell会话的其他shell进程使用，退出当前Shell会话则失效。

declare -x name1;
（5）显示所有 Shell 环境变量。

declare -x
（6）使用+x选项取消变量为环境变量。

delcare +x name1
（7）申明整型变量，赋值浮点型数值将报错。

declare -i integer=666

awk [OPTIONS]
awk [OPTIONS] 'PATTERN{ACTION}' FILE...
awk 的 PATTERN 可能是以下情况之一：

BEGIN
END
BEGINFILE
ENDFILE
/regular expression/
relational expression
pattern && pattern
pattern || pattern
! pattern
pattern ? pattern : pattern
(pattern)
pattern1, pattern2
BEGIN 和 END 是两个特殊的模式，不会对输入的内容进行测试。BEGIN 后的 action 在 awk 读取文本前执行，END 后的 action 在 awk 结束前执行。模式表达式中的 BEGIN 和 END 模式不能与其他模式组合。

BEGINFILE 和 ENDFILE 是额外的两个特殊模式，BEGINFILE 的 action 在读取每个命令行输入文件的第一条记录之前执行，ENDFILE 的 action 在读取每个文件的最后一条记录之后执行。与 BEGIN 和 END 的区别是，如果给定多个文件，BEGINFILE 和 ENDFILE 的 action 将被执行多次，而 BEGIN 和 END 不管是否给定文件，其 action 只会执行一次。

/regular expression/ 表示正则表达式，用于选择符合指定 pattern 的行。

relational expression 表示正则表达式的关系式，即多个正则表达式通过运算符进行组合。常见组合有：

pattern && pattern
 逻辑与式，两个 pattern 同时满足才算满足
pattern || pattern
 逻辑或式，只要有一个 pattern 满足即满足
! pattern
 逻辑非式，不符合 pattern 则为 true
pattern ? pattern : pattern
 条件运算符式，第一个 pattern 满足则判断第二个 pattern，否则判断第三个 pattern
(pattern)
 括号用于改变 pattern 运算的优先级
pattern1, pattern2
 表示一个范围，用于选择所有记录行中第一个符合 pattern1 的记录到下一个符合 pattern2 的记录之间的记录
4.选项说明
-C, --copyright
 显示版权信息并退出
-c, --traditional
 是 awk 运行在兼容模式下，gawk 的任何扩展都不会生效
-d, --dump-variables[=FILE]
 将 awk 排序后的全局变量的类型和值打印到指定的文件中，如果没有指定 FILE，则在当前目录默认生成一个 awkvars.out
-E, --exec FILE
 功能类似于选项 -f，但脚本文件需要以 #! 开头；另外命令行的变量将不再生效
-e, --source PROGRAM_TEXT
 指定 awk 的源码文件
-F, --field-separator FS
 使用字符或字符串 FS 作为域分隔符。可以同时指定多个域分隔符，此时需要使用一对中括号括起来。例如使用-和|可写作 -F '[-|]'。如果用[]作为分隔符，可写作-F '[][]'。不指定分隔符，默认为空格和 Tab。注意，使用 -F' '显示指定空格时，Tab 也会被作为分隔符。使用 [] 指定多个分隔符时，又想使多个分隔符组成的字符串也作为分隔符，在 [] 后添加一个 +，如 -F"[ab]+"，那么分隔符有三个，a，b 和 ab
-f, --file PROGRAM_FILE
 从指定的 awk 脚本文件 PROGRAM_FILE 读取 awk 指令
-g, --gen-pot
 解析 awk 程序，产生 .po（Portable Object Template） 格式的文件到标准输出，来标明程序中每一个可本地化的字符串位置
-h, --help
 显示简要的帮助信息并退出
-L, --lint[=VALUE]
 打印有关在其它版本 awk 中出现可疑的或不可移植结构的警告。该选项提供了一个可选的参数 fatal，即将警告视为致命的错误
-m{f|r} VAL
 -mf 将最大字段数设为 VAL；-mr 将最大记录数设为 VAL。这两个功能是 Bell 实验室版awk 的扩展功能，在标准 awk 中不适用
-N, --use-lc-numeric
 使用本地小数点解析输入的数据
-n, --non-decimal-data
 识别输入数据中八进制和十六进制数
-O, --optimize
 在程序的内部表示上启用优化。目前，这只包括简单的常量折叠。gawk 维护者希望随着时间的推移增加额外的优化
-P, --posix
 打开兼容模式，会出现以下限制：
 不识别 \x；
 当域分隔符 FS 是一个空格时，只有空格和 Tab 能作为域分隔符，换行符将不能作为一个域分隔符；
 在 ? 和 : 之后，不能继续当前行；
 函数关键字 func 将不能被识别；
 操作符 ** 和 **= 不能代替 ^ 和 ^=；
 fflush 函数无效。
-R, --command FILE
 只限于 Dgawk。从文件中读取调试器命令
-r, --re-interval
 允许间隔正则表达式的使用。为默认选项
-S, --sandbox
 在沙盒模式下运行gawk，禁用 system() 函数，使用 getline 进行输入重定向，使用 print 和 printf 进行输出重定向，以及加载动态扩展。命令执行也被禁用，这有效地阻止了脚本访问本地资源
-t, --lint-old
 打印关于不能向传统 Unix awk 移植的构造的警告
--profile[=FILE]
 输出性能分析报告至指定的文件，默认输出到 awkprof.out
-V, --version
 打印版本信息并退出
-v, --assign VAR=VAL
 定义一个 awk 变量并赋值，可以将外部变量传递给 awk
--
 标识命令选项结束
gawk 有许多内置变量用来设置环境信息，这些变量可以被改变，下面给出常见的内置变量说明。

$0    当前处理行
$n    当前记录的第 n 个字段，n 从 1 开始，字段间由 FS 分隔
ARGC            命令行参数个数
ARGIND    当前处理命令行中的第几个文件，文件下标从 0 开始
ARGV            命令行参数数组
CONVFMT   数字转换格式，默认值为%.6g
ENVIRON         支持队列中系统环境变量的使用
ERRNO   最后一个系统错误的描述
FIELDWIDTHS  字段宽度列表(用空格键分隔)
FILENAME        awk浏览的文件名
FNR             当前被处理文件的记录数
FS              设置输入域分隔符，等价于命令行-F选项
IGNORECASE  如果为真，则进行忽略大小写的匹配
LINT   动态控制--lint选项是否生效，为false不生效，为true则生效；
NF              浏览记录的域的个数
NR              已读的记录数
OFMT   数字的输出格式，默认值是%.6g
OFS             输出域分隔符
ORS             输出记录分隔符    
RS              The input record separator，输入记录的分隔符，默认为换行符
RT    The record terminator，输入记录的结束符  
RSTART   由 match 函数所匹配的字符串的第一个位置
RLENGTH   由 match 函数所匹配的字符串的长度
SUBSEP   数组下标分隔符（默认值是 \034）
TEXTDOMAIN  awk 程序所使用的文本所处的地域

realpath [OPTIONS] FILES
-e, --canonicalize-existing
 文件 FILE 的所有组成部件必须都存在
-m, --canonicalize-missing
 文件 FILE 的组成部件可以不存在
-L, --logical
 在软链接之前解析父目录 ..
-P, --physical
 解析软链接，默认动作
-q, --quiet
 静默模式输出，禁止显示大多数错误消息
--relative-to=DIR
 相对于目录 DIR 的路径
--relative-base=DIR
 如果文件在基目录 DIR下，打印结果会省去基目录，否则打印绝对路径
-s, --strip, --no-symlinks
 不扩展软链接
-z, --zero
 不分隔输出，即所有的输出均在一行而不是单独每行
--help
 显示帮助信息
--version
 显示版本信息

realpath ./hello.txt
realpath --relative-to=./src ./foo
realpath --relative-base=/data/test ./foo

功能：修改帐号和密码的有效期限
用法：chage[-l][-m mindays][-M maxdays][-I inactive][-E expiredate][-W warndays][-d lastdays]username
参数：
-l：列出用户的以及密码的有效期限
-m:修改密码的最小天数
-M：修改密码的最大天数
-I：密码过期后，锁定帐号的天数
-d：指定密码最后修改的日期
-E：有效期，0表示立即过期，-1表示永不过期
-W：密码过期前，开始警告天数
可以编辑/etc/login.defs来设定几个参数，以后设置口令默认就按照参数设定为准：
PASS_MAX_DAYS   99999
PASS_MIN_DAYS   0
PASS_MIN_LEN    5
PASS_WARN_AGE   7
当然在/etc/default/useradd可以找到如下2个参数进行设置：
# useradd defaults file
GROUP=100
HOME=/home
INACTIVE=-1
EXPIRE=
SHELL=/bin/bash
SKEL=/etc/skel
CREATE_MAIL_SPOOL=yes

useradd test
passwd -S test #显示账号密码相关信息
passwd -d test #取消密码
passwd -l test #锁定账号
passwd -u test #解锁账号
chage -l test #查看账号有效期
chage -I 5 test #密码过期后5天，密码自动失效
chage -M 60 -m 7 -W 7 test #60天后密码过期，至少7天后才能修改密码，密码过期前7天开始收到告警信息
chage -d 0 test #强制首次登陆后修改密码
usermod -s /usr/sbin/nologin test #账号不可登陆
usermod -s /bin/bash test #账号可登陆

patch 命令用于修补文件
patch [-bceEflnNRstTuvZ][-B <备份字首字符串>][-d <工作目录>][-D <标示符号>][-F <监别列数>][-g <控制数值>][-i <修补文件>][-o <输出文件>][-p <剥离层级>][-r <拒绝文件>][-V <备份方式>][-Y <备份字首字符串>][-z <备份字尾字符串>][--backup-if -mismatch][--binary][--help][--nobackup-if-mismatch][--verbose][原始文件 <修补文件>] 或 path [-p <剥离层级>] < [修补文件]
参数：
- -b 或--backup  备份每一个原始文件。
- -B<备份字首字符串>或--prefix=<备份字首字符串>  设置文件备份时，附加在文件名称前面的字首字符串，该字符串可以是路径名称。
- -c 或--context  把修补数据解译成关联性的差异。
- -d<工作目录>或--directory=<工作目录>  设置工作目录。
- -D<标示符号>或--ifdef=<标示符号>  用指定的符号把改变的地方标示出来。
- -e 或--ed  把修补数据解译成 ed 指令可用的叙述文件。
- -E 或--remove-empty-files  若修补过后输出的文件其内容是一片空白，则移除该文件。
- -f 或--force  此参数的效果和指定"-t"参数类似，但会假设修补数据的版本为新 版本。
- -F<监别列数>或--fuzz<监别列数>  设置监别列数的最大值。
- -g<控制数值>或--get=<控制数值>  设置以 RSC 或 SCCS 控制修补作业。
- -i<修补文件>或--input=<修补文件>  读取指定的修补文件。
- -l 或--ignore-whitespace  忽略修补数据与输入数据的跳格，空格字符。
- -n 或--normal  把修补数据解译成一般性的差异。
- -N 或--forward  忽略修补的数据较原始文件的版本更旧，或该版本的修补数据已使 用过。
- -o<输出文件>或--output=<输出文件>  设置输出文件的名称，修补过的文件会以该名称存放。
- -p<剥离层级>或--strip=<剥离层级>  设置欲剥离几层路径名称。
- -f<拒绝文件>或--reject-file=<拒绝文件>  设置保存拒绝修补相关信息的文件名称，预设的文件名称为。rej。
- -R 或--reverse  假设修补数据是由新旧文件交换位置而产生。
- -s 或--quiet 或--silent  不显示指令执行过程，除非发生错误。
- -t 或--batch  自动略过错误，不询问任何问题。
- -T 或--set-time  此参数的效果和指定"-Z"参数类似，但以本地时间为主。
- -u 或--unified  把修补数据解译成一致化的差异。
- -v 或--version  显示版本信息。
- -V<备份方式>或--version-control=<备份方式>  用"-b"参数备份目标文件后，备份文件的字尾会被加上一个备份字符串，这个字符串不仅可用"-z"参数变更，当使用"-V"参数指定不同备份方式时，也会产生不同字尾的备份字符串。
- -Y<备份字首字符串>或--basename-prefix=--<备份字首字符串>  设置文件备份时，附加在文件基本名称开头的字首字符串。
- -z<备份字尾字符串>或--suffix=<备份字尾字符串>  此参数的效果和指定"-B"参数类似，差别在于修补作业使用的路径与文件名若为 src/linux/fs/super.c，加上"backup/"字符串后，文件 super.c 会备份于/src/linux/fs/backup 目录里。
- -Z 或--set-utc  把修补过的文件更改，存取时间设为 UTC。
- --backup-if-mismatch  在修补数据不完全吻合，且没有刻意指定要备份文件时，才备份文件。
- --binary  以二进制模式读写数据，而不通过标准输出设备。
- --help  在线帮助。
- --nobackup-if-mismatch  在修补数据不完全吻合，且没有刻意指定要备份文件时，不要备份文件。
- --verbose  详细显示指令的执行过程。
使用 patch 指令将文件"testfile1"升级，其升级补丁文件为"testfile.patch"，输入如下命令：
$ patch -p0 testfile1 testfile.patch    #使用补丁程序升级文件
使用该命令前，可以先使用指令"cat"查看"testfile1"的内容。在需要修改升级的文件与原文件之间使用指令"diff"比较可以生成补丁文件。具体操作如下所示：

$ cat testfile1                 #查看 testfile1 的内容  
Hello,This is the firstfile!  
$ cat testfile2                 #查看 testfile2 的内容  
Hello,Thisisthesecondfile!  
$ diff testfile1 testfile2          #比较两个文件  
1c1  
<Hello,Thisisthefirstfile!  
---  
>Hello,Thisisthesecondfile!  
#将比较结果保存到 tetsfile.patch 文件  
$ diff testfile1 testfile2>testfile.patch     
$ cat testfile.patch                #查看补丁包的内容  
1c1  
<Hello,Thisisthefirstfile!  
---  
>Hello,Thisisthesecondfile!  
#使用补丁包升级 testfile1 文件  
$ patch -p0 testfile1 testfile.patch      
patching file testfile1  
$cat testfile1                  #再次查看 testfile1 的内容  
#testfile1 文件被修改为与 testfile2 一样的内容  
Hello,This is the secondfile!   
注意：
上述命令代码中，"$ diff testfile1 testfile2>testfile. patch"所使用的操作符"＞"表示将该操作符左边的文件数据写入到右边所指向的文件中。在这里，即是指将两个文件比较后的结果写入到文件"testfile.patch"中

od命令用于输出文件内容
od [-abcdfhilovx][-A <字码基数>][-j <字符数目>][-N <字符数目>][-s <字符串字符数>][-t <输出格式>][-w <每列字符数>][--help][--version][文件...]
参数：
- -a  此参数的效果和同时指定"-ta"参数相同。
- -A<字码基数>  选择要以何种基数计算字码。
- -b  此参数的效果和同时指定"-toC"参数相同。
- -c  此参数的效果和同时指定"-tC"参数相同。
- -d  此参数的效果和同时指定"-tu2"参数相同。
- -f  此参数的效果和同时指定"-tfF"参数相同。
- -h  此参数的效果和同时指定"-tx2"参数相同。
- -i  此参数的效果和同时指定"-td2"参数相同。
- -j<字符数目>或--skip-bytes=<字符数目>  略过设置的字符数目。
- -l  此参数的效果和同时指定"-td4"参数相同。
- -N<字符数目>或--read-bytes=<字符数目>  到设置的字符数目为止。
- -o  此参数的效果和同时指定"-to2"参数相同。
- -s<字符串字符数>或--strings=<字符串字符数>  只显示符合指定的字符数目的字符串。
- -t<输出格式>或--format=<输出格式>  设置输出格式。
- -v或--output-duplicates  输出时不省略重复的数据。
- -w<每列字符数>或--width=<每列字符数>  设置每列的最大字符数。
- -x  此参数的效果和同时指定"-h"参数相同。
- --help  在线帮助。
- --version  显示版本信息。
echo abcdef g > tmp
od -b tmp 
#八进制解释进行输出
od -c tmp
#ASCII码进行输出
od -t d1 tmp 
#十进制进行解释
od -A d -c tmp

rhmask [加密文件][输出文件] 或 rhmask [-d][加密文件][源文件][输出文件]
- -d  产生加密过的文件。
rhmask code.txt demo.txt


tee 命令用于读取标准输入的数据，并将其内容输出成文件。
tee [-ai][--help][--version][文件。..]
- -a 或--append  附加到既有文件的后面，而非覆盖它．
- -i 或--ignore-interrupts  忽略中断信号。
- --help  在线帮助。
- --version  显示版本a信息。
tee file1 file2                   #在两个文件中复制内容 

slocate 命令查找文件或目录
slocate [-u][--help][--version][-d <目录>][查找的文件]
- -d<目录>或--database=<目录>  指定数据库所在的目录。
- -u  更新 slocate 数据库。
- --help  显示帮助。
- --version  显示版本信息。
slocate fdisk #显示文件名中含有 fdisk 关键字的文件的路径信息 

红帽忘记密码修改root密码
1  在重启的时候 e 进入
2  在linux16 后面找到UTF-8 在后面加 rd.break   然后ctrl+x
3  这时候可以输入mount 看一下 会发现根为 /sysroot/  没有w权限，只有ro权限
4  输入 mount  -o  remount,rw  /sysroot/    重新挂载，就有rw权限
5 改变根  chroot  /sysroot/
6 echo “密码" | passwd --stdin root   设置密码
7  使 seliunx 生效  touch /.autorelabel
8  exit
9  reboot
10  切换ROOT用户登陆

centOS 6 修改密码
1 e 进入
2 选择第二个  kernel
3 在 quiet 后面 加 1  然后回车
4  b
5  进去passwd 就可以修改密码了

RedHat init 修改密码
1  启动RedHat ,进入后 e 进入编辑。
2  光标往下，找到以 linux16开头 ro改成 rw  UTF-8结尾的参数行,并在UTF-8后面加 init=/bin/sh 
3  输入init=/bin/sh 后，按 ctrl+x
4  进入下图界面
5  这时候我们可以mount看一下，有rw 权限，我们就省去重新挂载步骤。（看不见，没有回显， 自己输入，尽量正确）
6  这个时候我们就可以输入下面的语句设置自己的密码
	echo “wll” | passwd --stdin root（看不见，没有回显， 自己输入，尽量正确）
7 显示成功 输入touch /.autorelabe（看不见，没有回显， 自己输入，尽量正确）
8 输入 exec /sbin/init  重启
9．重启成功

Kali 重新设置密码（有些版本可能界面会不一样，但是操作大同小异）
1）在grub界面按e进入*Advaced options for kali GNU/Linux
2）编辑模式 下找到 "Linux "开头的那行修改ro 修改为 rw  添加 init=/bin/bash  修改完按 F10
3）保存后，输入passwd重置密码

Ubuntu 重置密码
1，长按shift或者ese进入grub,选择高级选项回车
2，选择版本较高的recovery mode
3，按下e后进入如下界面，找到linux /boot/vmlinuz-…ro recovery nomodeset 所在行。找到recovery nomodeset并将其删掉，再在这一行的最后面（dis_ucode_ldr后面）输入quiet splash rw init=/bin/bash
4，输入passwd，修改密码成功

关机 命令  shutdown   poweroff -f  init 0
重启 命令	 reboot   init 6
sleep 2 | init 0   设置两秒后关机
注销  logout

comm 命令用于比较两个已排过序的文件
comm [-123][--help][--version][第 1 个文件][第 2 个文件]
- -1 不显示只在第 1 个文件里出现过的列。
- -2 不显示只在第 2 个文件里出现过的列。
- -3 不显示只在第 1 和第 2 个文件里出现过的列。
- --help 在线帮助。
- --version 显示版本信息。

comm aaa.txt bbb.txt


lsattr
lsattr 命令用于显示文件属性。
用chattr执行改变文件或目录的属性，可执行lsattr指令查询其属性。
lsattr [-adlRvV][文件或目录...]
- -a  显示所有文件和目录，包括以"."为名称开头字符的额外内建，现行目录"."与上层目录".."。
- -d  显示，目录名称，而非其内容。
- -l  此参数目前没有任何作用。
- -R  递归处理，将指定目录下的所有文件及子目录一并处理。
- -v  显示文件或目录版本。
- -V  显示版本信息。
1、用chattr命令防止系统中某个关键文件被修改：
# chattr +i /etc/resolv.conf
chattr -i /etc/resolv.conf
lsattr /etc/resolv.conf
让某个文件只能往里面追加数据，但不能删除，适用于各种日志文件：
# chattr +a /var/log/messages

diffstat
Linux diffstat命令根据diff的比较结果，显示统计数字。
diffstat读取diff的输出结果，然后统计各文件的插入，删除，修改等差异计量。

diff [-wV][-n <文件名长度>][-p <文件名长度>]
参数：
- -n<文件名长度>  指定文件名长度，指定的长度必须大于或等于所有文件中最长的文件名。
- -p<文件名长度>  与-n参数相同，但此处的<文件名长度>包括了文件的路径。
- -w  指定输出时栏位的宽度。
- -V  显示版本信息。


indent可辨识C的原始代码文件，并加以格式化，以方便程序设计师阅读。
indent [参数][源文件] 或 indent [参数][源文件][-o 目标文件]

参数：
- -bad或--blank-lines-after-declarations  在声明区段或加上空白行。
- -bap或--blank-lines-after-procedures  在程序或加上空白行。
- -bbb或--blank-lines-after-block-comments  在注释区段后加上空白行。
- -bc或--blank-lines-after-commas  在声明区段中，若出现逗号即换行。
- -bl或--braces-after-if-line  if(或是else,for等等)与后面执行区段的"{"不同行，且"}"自成一行。
- -bli<缩排格数>或--brace-indent<缩排格数>  设置{ }缩排的格数。
- -br或--braces-on-if-line  if(或是else,for等等)与后面执行跛段的"{"不同行，且"}"自成一行。
- -bs或--blank-before-sizeof  在sizeof之后空一格。
- -c<栏数>或--comment-indentation<栏数>  将注释置于程序码右侧指定的栏位。
- -cd<栏数>或--declaration-comment-column<栏数>  将注释置于声明右侧指定的栏位。
- -cdb或--comment-delimiters-on-blank-lines  注释符号自成一行。
- -ce或--cuddle-else  将else置于"}"(if执行区段的结尾)之后。
- -ci<缩排格数>或--continuation-indentation<缩排格数>  叙述过长而换行时，指定换行后缩排的格数。
- -cli<缩排格数>或--case-indentation-<缩排格数>  使用case时，switch缩排的格数。
- -cp<栏数>或-else-endif-column<栏数>  将注释置于else与elseif叙述右侧定的栏位。
- -cs或--space-after-cast  在cast之后空一格。
- -d<缩排格数>或-line-comments-indentation<缩排格数>  针对不是放在程序码右侧的注释，设置其缩排格数。
- -di<栏数>或--declaration-indentation<栏数>  将声明区段的变量置于指定的栏位。
- -fc1或--format-first-column-comments  针对放在每行最前端的注释，设置其格式。
- -fca或--format-all-comments  设置所有注释的格式。
- -gnu或--gnu-style  指定使用GNU的格式，此为预设值。
- -i<格数>或--indent-level<格数>  设置缩排的格数。
- -ip<格数>或--parameter-indentation<格数>  设置参数的缩排格数。
- -kr或--k-and-r-style  指定使用Kernighan&Ritchie的格式。
- -lp或--continue-at-parentheses  叙述过长而换行，且叙述中包含了括弧时，将括弧中的每行起始栏位内容垂直对其排列。
- -nbad或--no-blank-lines-after-declarations  在声明区段后不要加上空白行。
- -nbap或--no-blank-lines-after-procedures  在程序后不要加上空白行。
- -nbbb或--no-blank-lines-after-block-comments  在注释区段后不要加上空白行。
- -nbc或--no-blank-lines-after-commas  在声明区段中，即使出现逗号，仍旧不要换行。
- -ncdb或--no-comment-delimiters-on-blank-lines  注释符号不要自成一行。
- -nce或--dont-cuddle-else  不要将else置于"}"之后。
- -ncs或--no-space-after-casts  不要在cast之后空一格。
- -nfc1或--dont-format-first-column-comments  不要格式化放在每行最前端的注释。
- -nfca或--dont-format-comments  不要格式化任何的注释。
- -nip或--no-parameter-indentation  参数不要缩排。
- -nlp或--dont-line-up-parentheses  叙述过长而换行，且叙述中包含了括弧时，不用将括弧中的每行起始栏位垂直对其排列。
- -npcs或--no-space-after-function-call-names  在调用的函数名称之后，不要加上空格。
- -npro或--ignore-profile  不要读取indent的配置文件.indent.pro。
- -npsl或--dont-break-procedure-type  程序类型与程序名称放在同一行。
- -nsc或--dont-star-comments  注解左侧不要加上星号(*)。
- -nsob或--leave-optional-semicolon  不用处理多余的空白行。
- -nss或--dont-space-special-semicolon  若for或while区段仅有一行时，在分号前不加上空格。
- -nv或--no-verbosity  不显示详细的信息。
- -orig或--original  使用Berkeley的格式。
- -pcs或--space-after-procedure-calls  在调用的函数名称与"{"之间加上空格。
- -psl或--procnames-start-lines  程序类型置于程序名称的前一行。
- -sc或--start-left-side-of-comments  在每行注释左侧加上星号(*)。
- -sob或--swallow-optional-blank-lines  删除多余的空白行。
- -ss或--space-special-semicolon  若for或swile区段今有一行时，在分号前加上空格。
- -st或--standard-output  将结果显示在标准输出设备。
- -T  数据类型名称缩排。
- -ts<格数>或--tab-size<格数>  设置tab的长度。
- -v或--verbose  执行时显示详细的信息。
- -version  显示版本信息。

Indent代码格式化说明
使用的indent参数	值	含义
--blank-lines-after-declarations	bad	变量声明后加空行
--blank-lines-after-procedures	bap	函数结束后加空行
--blank-lines-before-block-comments	bbb	块注释前加空行
--break-before-boolean-operator	bbo	较长的行，在逻辑运算符前分行
--blank-lines-after-commas	nbc	变量声明中，逗号分隔的变量不分行
--braces-after-if-line	bl	"if"和"{"分做两行
--brace-indent 0	bli0	"{"不继续缩进
--braces-after-struct-decl-line	bls	定义结构，"struct"和"{"分行
--comment-indentationn	c33	语句后注释开始于行33
--declaration-comment-columnn	cd33	变量声明后注释开始于行33
--comment-delimiters-on-blank-lines	ncdb	不将单行注释变为块注释
--cuddle-do-while	ncdw	"do --- while"的"while"和其前面的"}"另起一行
--cuddle-else	nce	"else"和其前面的"}"另起一行
--case-indentation 0	cli0	switch中的case语句所进0个空格
--else-endif-columnn	cp33	#else, #endif后面的注释开始于行33
--space-after-cast	cs	在类型转换后面加空格
--line-comments-indentation n	d0	单行注释（不从1列开始的），不向左缩进
--break-function-decl-args	nbfda	关闭：函数的参数一个一行
--declaration-indentationn	di2	变量声明，变量开始于2行，即不必对齐
--format-first-column-comments	nfc1	不格式化起于第一行的注释
--format-all-comments	nfca	不开启全部格式化注释的开关
--honour-newlines	hnl	Prefer to break long lines at the position of newlines in the input.
--indent-leveln	i4	设置缩进多少字符，如果为tab的整数倍，用tab来缩进，否则用空格填充。
--parameter-indentationn	ip5	旧风格的函数定义中参数说明缩进5个空格
--line-length 75	l75	非注释行最长75
--continue-at-parentheses	lp	续行从上一行出现的括号开始
--space-after-procedure-calls	pcs	函数和"("之间插入一个空格
--space-after-parentheses	nprs	在"（"后"）"前不插入空格
--procnames-start-lines	psl	将函数名和返回类型放在两行定义
--space-after-for	saf	for后面有空格
--space-after-if	sai	if后面有空格
--space-after-while	saw	while后面有空格
--start-left-side-of-comments	nsc	不在生成的块注释中加*
--swallow-optional-blank-lines	nsob	不去掉可添加的空行
--space-special-semicolon	nss	一行的for或while语句，在";"前不加空。
--tab-size	ts4	一个tab为4个空格（要能整除"-in"）
--use-tabs	ut	使用tab来缩进

cmp命令用于比较两个文件是否有差异
cmp [-clsv][-i <字符数目>][--help][第一个文件][第二个文件]
- -c或--print-chars  除了标明差异处的十进制字码之外，一并显示该字符所对应字符。
- -i<字符数目>或--ignore-initial=<字符数目>  指定一个数目。
- -l或--verbose  标示出所有不一样的地方。
- -s或--quiet或--silent  不显示错误信息。
- -v或--version  显示版本信息。
- --help  在线帮助。
cmp prog.o.bak prog.o 

objcopy 工具使用 BFD 库读写目标文件，它可以将一个目标文件的内容拷贝到另外一个目标文件
objcopy [OPTION] [INFILE] [OUTFILE]
-I bfdname, --input-target=bfdname
 指定输入文件的格式 bfdname，可取值 elf32-little，elf32-big 等，而不是让 objcopy 去推测
-O bfdname, --output-target=bfdname
    指定输出文件的的格式 bfdname
-F bfdname, --target=bfdname
    指定输入、输出文件的 bfdname，目标文件格式，只用于在目标和源文件之间传输数据，不转换
-B bfdarch, --binary-architecture=bfdarch
 将无架构的输入文件转换为目标文件时很有用，输出体系结构可以设置为 bfdarch。如果输入文件具有已知的架构，将忽略此选项。可以在程序内通过引用转换过程创建的特殊符号来访问二进制数据。这些符号称为 _binary_objfile_start、_binary_objfile_end 和 _binary_objfile_size。例如，您可以将图片文件转换为对象文件，然后使用这些符号在代码中访问它
-j sectionname, --only-section=sectionname 
    只将由 sectionname 指定的 section 拷贝到输出文件，可以多次指定，并且注意如果使用不当会导致输出文件不可用
-R sectionname, --remove-section=sectionname 
 从输出文件中去除掉指定的 section，可以多次指定，并且注意如果使用不当会导致输出文件不可用
-S, --strip-all 
    不从源文件拷贝符号信息和relocation信息。 
-g, --strip-debug 
    不从源文件拷贝调试符号信息和相关的段。对使用 -g 编译生成的可执行文件执行该选项后，生成的结果文件几乎和不用 -g 编译生成的可执行文件一样
--strip-unneeded 
 去掉所有重定位处理不需要的符号
-K symbolname, --keep-symbol=symbolname
    strip 的时候，保留由 symbolname 指定的符号信息。该选项可以多次指定
-N symbolname, --strip-symbol=symbolname 
    不拷贝由 symbolname 指定的符号信息。该选项可以多次指定 
--strip-unneeded-symbol=symbolname
 不拷贝重定位不需要的符号。该选项可以多次指定
-G symbolname, --keep-global-symbol=symbolname
 只保留 symbolname 为全局的，让其他符号均为局部符号，外部不可见。该选项可以多次指定
--localize-hidden
 在 ELF 目标文件中，将所有具有隐藏或内部可见性的符号标记为“局部”。此选项适用于特定的符号本地化的选项，如 -L
-L symbolname, --localize-symbol=symbolname 
 将变量 symbolname 变成文件局部的变量。该选项可以多次指定
-W symbolname, --weaken-symbol=symbolname 
    将指定符号变为弱符号。该选项可以多次指定
--globalize-symbol=symbolname 
    让变量symbolname变成全局范围，这样它可以在定义它的文件外部可见。可以多次指定。 
-w, --wildcard
    允许对其他选项中的 symbolname 使用正则表达式。问号(?)，星号(*)，反斜线(\)，和中括号([])可以出现在 symbolname 的任何位置。如果 symbolname 
 的第一个字符是感叹号(!)，那么表示相反的含义，例如
    -w -W !foo -W fo*
    表示将要弱化所有以 "fo" 开头的符号，但是除了符号 "foo"
-x, --discard-all
 不从源文件中拷贝非全局符号
-X, --discard-locals
 不拷贝编译器生成的局部变量(一般以 L 或者 .. 开头)
-b byte, --byte=byte
 只保留输入文件的每个第 byte 个字节(不会影响头部数据)。byte 的范围可以是 0 到 interleave-1。这里，interleave 通过 -i 选项指定，默认为 4。将文件创建成程序 rom 的时候，这个命令很有用。它经常用于 srec 输出目标
-i interleave, --interleave=interleave 
 每隔 interleave 字节拷贝 1 byte，interleave 默认为 4。通过 -b 选项指定选择哪个字节如果不指定 -b 那么 objcopy 会忽略这个选项
--interleave-width=width
 与 --interleave 配合使用，-b 指定起始下标，--interleave-width 则指定每次拷贝的字节数为 width，width 默认为 1。注意 -b 指定的下标与 --interleave-width 指定的字节数相加不能超过 -i 设定的宽度
-p, --preserve-dates
 将输出文件的访问和修改日期设置为与输入文件的访问和修改日期相同
-D, --enable-deterministic-archives
 以确定性模式操作。复制存档成员和写入存档索引时，对 uid、gid、时间戳使用零，对所有文件使用一致的文件模式。如果 binutils 配置了 --enable-deterministic-archives，那么这个模式是打开的，可以使用 -U 来禁止
-U, --disable-deterministic-archives
 与 -D 作用相反。复制存档成员和写入存档索引时，复制存档成员和写入存档索引时，使用他们实际的 uid、gid、时间戳和文件模式。这个选项是默认的，除非 binutils 配置了 --enable-deterministic-archives
--debugging
 如果可能，转换调试信息。这不是默认设置，因为只支持某些调试格式，而且转换过程可能很耗时
--gap-fill val
    在 section 之间的空隙中填充 val
--pad-to address
 将输出文件填充到加载地址 address。这是通过增加最后一段的大小来完成的。用 --gap-fill 指定的值（默认为零）填充额外的空间
--set-start val 
    设定新文件的起始地址为 val，并不是所有格式的目标文件都支持设置起始地址
--change-start INCR, --adjust-start INCR
    通过增加指定的值 INCR来调整起始地址，并不是所有格式的目标文件都支持设置起始地址
--change-addresses INCR, --adjust-vma INCR
 通过增加 INCR 调整所有 sections 的 VMA（virtual memory address）和 LMA（load memory address）以及起始地址。有些目标文件格式不支持对段地址的任意改动。注意，这不会重新定位分区
--change-section-address sectionpattern{=,+,-}val, --adjust-section-vma sectionpattern{=,+,-}val 
 调整指定 section 的 VMA/LMA 地址。如果 sectionpattern 未匹配到 section，则会引发告警，除非使用 --no-change-warnings 抑制告警
--change-section-lma sectionpattern{=,+,-}val
 调整指定 section 的 LMA 地址
--change-section-vma sectionpattern{=,+,-}val
 调整指定 section 的 VMA 地址
--change-warnings, --adjust-warnings
 使用 --change-section-address、--adjust-section-lma、--adjust-section-vma，如果 section pattern 没有匹配到 section，引发告警。该选项为默认选项
--no-change-warnings, --no-adjust-warnings
 使用 --change-section-address、--adjust-section-lma、--adjust-section-vma，如果 section pattern 没有匹配到 section，不引发告警
--set-section-flags sectionpattern=flag 
    为指定的 section 设置 flag，flag 是一个逗号分隔的由 flag name 组成的字符串，取值可以为 alloc, contents, load, noload, readonly, code, data, rom, share, debug。我们可以为一个没有内容的 section 设置 contents flag，但是清除一个有内容的 section 的 contents flag 是没有意义的--应当把相应的 section 移除。并不是所有的 flags 对所有格式的目标文件都有意义
--add-section sectionname=filename
    在拷贝文件的时候，添加一个名为 sectionname 的 section，该 section 的内容为 filename 的内容，大小为文件大小。这个选项只在那些可以支持任意名称 section 的文件格式上生效
--rename-section oldname=newname[,flags]
 将一个 section 的名字从 oldname 更改为 newname，同时也可以更改其 flags。这个在执行 linker 脚本进行重命名的时候，并且输出文件还是一个目标文件且不会是可执行文件的时候很有优势。 
    这个项在输入文件格式是 binary 的时候很有用，因为这经常会创建一个名称为 .data 的 section，例如，你想创建一个名称为 .rodata 的包含二进制数据的 section，这时候，你可以使用如下命令： 
    objcopy -I binary -O <output_format> -B <architecture> --rename-section .data=.rodata,alloc,load,readonly,data,contents <input_binary_file> <output_object_file>
--long-section-names {enable,disable,keep}
 在处理 COFF 和 PE-COFF 格式目标文件时，控制对长段名称的处理。默认行为是 keep，保留长段名称（如果有）。enable 和 disable 分别强制启用或禁用在输出目标文件中使用长段名称
--change-leading-char
 有些格式的目标文件在符号前使用特殊的前导字符，最常用的是下划线。此选项告诉 objcopy 在目标文件格式之间转换时更改每个符号的前导字符。如果不同的目标文件使用相同的前导字符，则此选项无效。否则，它将根据需要添加字符、删除字符或更改字符
--remove-leading-char
 移除目标文件全局符号前的前导字符
--reverse-bytes=num
 反转段中的字节。注意，段的大小必须可以被指定的数值 num 均分。该选项一般用于产生 ROM 映像用于在有问题的目标系统上进行调试。假如一个段的内容只有 8 个字节，为 12345678。
 使用 --reverse-bytes=2 ，输出文件中的结果是 21436587
 使用 --reverse-bytes=4，输出文件中的结果是 43218765
 使用 --reverse-bytes=2，接着再对输出文件使用 --reverse-bytes=4，再第二个输出文件中的结果将是 34127856
--srec-len=ival
 只对输出目标文件格式 SREC 有意义。指定生成 SREC 文件的最大长度为 ival
--srec-forceS3
 只对输出目标文件格式是 SREC 有意义。避免产生 S1/S2 记录，只产生 S3 格式的记录
--redefine-sym old=new
 变更符号名称。当链接两个目标文件产生符号名称冲突时，可以使用该选项来解决
--redefine-syms=filename
 将 --redefine-sym 选项应用于指定的文件 filename。该选项可以多次出现
--weaken
 将所有全局符号变更为弱符号。改选只对在支持弱符号的目标文件格式有效
--keep-symbols=filename
 将 --keep-symbol 选项应用于指定的文件 filename。该选项可以多次出现
--strip-symbols=filename
 将 --strip-symbol 选项应用于指定的文件 filename。该选项可以多次出现
--strip-unneeded-symbols=filename
 将 --strip-unneeded-symbol 选项应用于指定的文件 filename。该选项可以多次出现
--keep-global-symbols=filename
 将 --keep-global-symbol 选项应用于指定的文件 filename。该选项可以多次出现
--localize-symbols=filename
 将 --localize-symbol 选项应用于指定的文件 filename。该选项可以多次出现
--globalize-symbols=filename
 将 --globalize-symbol 选项应用于指定的文件 filename。该选项可以多次出现
--weaken-symbols=filename
 将 --weaken-symbol 选项应用于指定的文件 filename。该选项可以多次出现
--alt-machine-code=index
 果输出体系结构具有备用机器代码，请使用 indexth 代码而不是默认代码
--add-gnu-debuglink=path-to-file 
    为输出文件创建一个.gnu_debuglink 段，该段包含对一个调试信息文件 path-to-file 的引用
--writable-text
 将输出文本标记为可写。此选项对所有目标文件格式都没有意义
--readonly-text
 将输出文本标记为只读。此选项对所有目标文件格式都没有意义
--pure
 将输出文件标记为按需分页。此选项对所有目标文件格式都没有意义
--impure
 将输出文件标记为不纯。此选项对所有对象文件格式都没有意义
--prefix-symbols=string
 在输出文件中使用指定的字符串作为符号的前缀
--prefix-sections=string
 在输出文件中使用指定的字符串作为所有段名的前缀
--prefix-alloc-sections=string
 在输出文件中使用指定的字符串作为所有分配的段名的前缀
--add-gnu-debuglink=path-to-file
 创建一个 .gnu-debuglink 段，该段包含一个特定路径的文件引用，并且把它添加到输出文件中
--only-keep-debug 
    对文件进行 strip，移走所有不会被 --strip-debug 移走的 section，并且保持调试相关的 section 原封不动
--strip-dwo
 删除所有 DWARF .dwo 段的内容，保留其余调试段和所有符号的完整性
--extract-dwo
 提取所有 DWARF .dwo 段的内容
--file-alignment num
 指定文件对齐方式。文件中的段始终相对于文件起始部分的偏移量是数值 num 的整数倍，默认值为512。此选项特定于 PE 文件
--heap reserve, --heap reserve,commit
 指定要保留的内存字节数，以用作此程序的堆。此选项特定于 PE 文件
--image-base value
 使用指定的值 value 作为程序或 dll 的基地址。这是加载程序或 dll 时使用的最低内存位置。为了减少重新定位进而提高 dll 性能，每个 dll 都应该有一个唯一的基地址，且不应与其他 dll 重叠。对于可执行文件，默认值为 0x400000，对于 dll，默认值为 0x10000000。此选项特定于 PE 文件
--section-alignment num
 设置段的对齐方式。段在内存中的起始地址是指定数值 num 的整数倍。num 默认为 0x1000。此选项特定于 PE 文件
--stack reserve, --stack reserve,commit
 指定要保留的内存字节数，以用作此程序的栈。此选项特定于 PE 文件
--subsystem which, --subsystem which:major, --subsystem which:major.minor
 指定程序执行的子系统。which 的合法值为 "native"、"windows"、"console"、"posix"、"efi-app"、"efi-bsd"、"efi-rtd"、"sal-rtd" 和 "xbox"。您也可以选择性地设置子系统版本。此选项特定于 PE 文件
--extract-symbol
 保留文件的段标志和符号，但删除段的数据
--compress-debug-sections
 使用 zlib 压缩 DWARF 调试部分
-V, --version
 显示版本
-v,--verbose
 冗余输出
--help
 显示帮助
--info
 显示所有可用架构和目标文件格式
@file
 从文件中读取命令行选项

g++ -g -o main.debug main.cpp
g++ -o main main.cpp
#1.生成调试信息文件，将其中的调试信息提取出来之后保存成一个文件
objcopy --only-keep-debug main.debug main.debuginfo

#2.将调试信息从可执行文件中剥离
objcopy --strip-debug main.debug main.stripdebug

#3.为不含调试信息的可执行文件添加调试信息
objcopy --add-gnu-debuglink=main.debuginfo main.stripdebug
objcopy --add-section mysection=text.txt main main.add
objcopy --only-section=mysection main.add section_hello
objcopy -R mysection main.add main.remove

xargs 可以将 stdin 中以空格或换行符进行分隔的数据，形成以空格分隔的参数（arguments），传递给其他命令。因为以空格作为分隔符，所以有一些文件名或者其他意义的字符串内含有空格的时候，xargs 可能会误判。简单来说，xargs 的作用是给其他命令传递参数，是构建单行命令的重要组件之一。
find /sbin -perm +700 | ls -l         # 这个命令是错误,因为标准输入不能作为ls的参数
find /sbin -perm +700 | xargs ls -l   # 这样才是正确的
xargs [OPTIONS] [COMMAND]
-0, --null
 如果输入的 stdin 含有特殊字符，例如反引号 `、反斜杠 \、空格等字符时，xargs 将它还原成一般字符。为默认选项
-a, --arg-file=FILE
 从指定的文件 FILE 中读取输入内容而不是从标准输入
-d, --delimiter=DEL
 指定 xargs 处理输入内容时的分隔符。xargs 处理输入内容默认是按空格和换行符作为分隔符，输出 arguments 时按空格分隔
-E EOF_STR
 EOF_STR 是 end of file string，表示输入的结束
-e, --eof[=EOF_STR]
 作用等同于 -E 选项，与 -E 选项不同时，该选项不符合 POSIX 标准且 EOF_STR 不是强制的。如果没有 EOF_STR 则表示输入没有结束符
-I REPLACE_STR
 将 xargs 输出的每一项参数单独赋值给后面的命令，参数需要用指定的替代字符串 REPLACE_STR 代替。REPLACE_STR 可以使用 {} $ @ 等符号，其主要作用是当 xargs command 后有多个参数时，调整参数位置。例如备份以 txt 为后缀的文件：find . -name "*.txt" | xargs -I {}  cp {} /tmp/{}.bak
-i, --replace[=REPLACE_STR]
 作用同 -I 选项，参数 REPLACE_STR 是可选的，缺省为 {}。建议使用 -I 选项，因为其符合 POSIX
-L MAX_LINES
 限定最大输入行数。隐含了 -x 选项
-l, --max-lines[=MAX_LINES]
 作用同 -L 选项，参数 MAX_LINES 是可选的，缺省为 1。建议使用 -L 选项，因为其符合 POSIX 标准
-n, --max-args=MAX_ARGS
 表示命令在执行的时候一次使用参数的最大个数
-o, --open-tty
 在执行命令之前，在子进程中重新打开stdin作为/dev/TTY。如果您希望xargs运行交互式应用程序，这是非常有用的
-P, --max-procs=MAX_PROCS
 每次运行最大进程；缺省值为 1。如果 MAX_PROCS 为 0，xargs 将一次运行尽可能多的进程。一般和 -n 或 -L 选项一起使用
-p, --interactive
 当每次执行一个 argument 的时候询问一次用户
--process-slot-var=NAME
 将指定的环境变量设置为每个正在运行的子进程中的唯一值。一旦子进程退出，将重用该值。例如，这可以用于初始负荷分配方案
-r, --no-run-if-empty
 当 xargs 的输入为空的时候则停止 xargs，不用再去执行后面的命令了。为默认选项
-s, --max-chars=MAX_CHARS
 命令行的最大字符数，指的是 xargs 后面那个命令的最大命令行字符数，包括命令、空格和换行符。每个参数单独传入 xargs 后面的命令
--show-limits
 显示操作系统对命令行长度的限制
-t， --verbose
 先打印命令到标准错误输出，然后再执行
-x, --exit
 配合 -s 使用，当命令行字符数大于 -s 指定的数值时，退出 xargs
--help
 显示帮助信息并退出
--version
 显示版本信息并退出

echo '`0123`4 56789' | xargs -t echo
ls | xargs -t -i mv {} {}.bak
ps -ef | grep spp | awk '{printf "%s ",$2}' | xargs kill -9


od（Octal Dump）命令用于将指定文件内容以八进制、十进制、十六进制、浮点格式或 ASCII 编码字符方式显示，通常用于显示或查看文件中不能直接显示在终端的字符。od 命令系统默认的显示方式是八进制。

常见的文件为文本文件和二进制文件。od 命令主要用来查看保存在二进制文件中的值，按照指定格式解释文件中的数据并输出，不管是 IEEE754 格式的浮点数还是 ASCII 码，od 命令都能按照需求输出它们的值。

大家也可以了解一下 hexdump 命令，以十六进制输出，但感觉 hexdump 命令没有 od 命令强大。

od [OPTION]... [FILE]...
-A RADIX
--address-radix=RADIX
 选择以何种基数表示地址偏移
-j BYTES
--skip-bytes=BYTES
 跳过指定数目的字节
-N BYTES
--read-bytes=BYTES
 输出指定字节数
-S [BYTES]
--strings[=BYTES]
 输出长度不小于指定字节数的字符串，BYTES 缺省为 3
-v
--output-duplicates
 输出时不省略重复的数据
-w [BYTES]
--width[=BYTES]
 设置每行显示的字节数，BYTES 缺省为 32 字节
-t TYPE
--format=TYPE
 指定输出格式，格式包括 a、c、d、f、o、u 和 x，各含义如下：
   a：具名字符；比如换行符显示为 nl
   c：可打印字符或反斜杠表示的转义字符；比如换行符显示为 \n
  d[SIZE]：SIZE 字节组成一个有符号十进制整数。SIZE 缺省为 sizeof(int)
  f[SIZE]：SIZE 字节组成一个浮点数。SIZE 缺省为 sizeof(double)
   o[SIZE]：SIZE 字节组成一个八进制整数。SIZE 缺省为 sizeof(int)
   u[SIZE]：SIZE 字节组成一个无符号十进制整数。SIZE 缺省为 sizeof(int)
   x[SIZE]：SIZE 字节组成一个十六进制整数。SIZE 缺省为 sizeof(int)
   SIZE 可以为数字，也可以为大写字母。如果 TYPE 是 [doux] 中的一个，那么 SIZE 可以为 C  = sizeof(char)，S = sizeof(short)，I = sizeof(int)，L = sizeof(long)。如果 TYPE 是 f，那么 SIZE 可以为 F = sizeof(float)，D = sizeof(double) ，L = sizeof(long double)
--help
 在线帮助
--version
 显示版本信息
od -Ad testfile
od -An testfile
od -tx testfile
od -tx1 testfile

rename [OPTIONS] EXPRESSION REPLACEMENT FILE...
EXPRESSION：原字符串，即文件名需要替换的字符串；REPLACEMENT ：目标字符串，将文件名中含有的原字符替换成目标字符串；FILE…：指定要改变文件名的文件列表。

rename 支持的通配符：

?    可替代单个字符
*    可替代多个字符
[charset] 可替代charset集中的任意单个字符
3.选项说明
-s, --symlink
 不要重命名符号链接，而是重命名它的目标
-v, --verbose
 以冗余模式运行，显示哪些文件已被重命名
-o, --no-overwrite
 不要覆盖现有文件
-i, --interactive
 更名前询问是否确定
-h, --help
 显示帮助信息并退出
-V, --version
 显示版本信息
4.常用示例
（1）重命名文件 lvlv 为 lala。

rename v a lv??
（2）将当前目录下的所有文件的后缀名由 .html 改为 .php。

rename .html .php *

test 用于检查某个条件是否成立，它可以进行数值、字符串和文件三个方面的测试。本文介绍的是 GNU 版本的 test，其它版本（如 POSIX 版）的实现可能会有所不同。

test
test EXPRESSION
省略表达式 EXPRESSION 默认为 false。[] 实际上是 Bash 中 test 命令的简写，即所有的 test EXPRESSION 等于 [ EXPRESSION ]。

3.选项说明
--help
 显示帮助信息并退出
--version
 显示版本信息并退出

# 1.逻辑运算
! EXPRESSION
 逻辑非，EXPRESSION 为 false 返回 true
EXPRESSION1 -a EXPRESSION2
 逻辑与，两个表达式均为 true 返回 true
EXPRESSION1 -o EXPRESSION2
 逻辑或，两个表达式只要有一个为 true 返回 true

# 2.数值间的比较
INTEGER1 -eq INTEGER2
 两整数是否相等
INTEGER1 -ne INTEGER2
 整数 INTEGER1 是否不等于 INTEGER2
INTEGER1 -gt INTEGER2
 整数 INTEGER1 是否大于 INTEGER2
INTEGER1 -ge INTEGER2
 整数 INTEGER1 是否大于等于 INTEGER2
INTEGER1 -lt INTEGER2
 整数 INTEGER1 是否小于 INTEGER2
INTEGER1 -le INTEGER2
 整数 INTEGER1 是否小于等于 INTEGER2

# 3.字符串的比较
-n STRING
 字符串不为空返回 true
-z STRING
 字符串为空返回 true
STRING1 = STRING2
 字符串相等返回 true
STRING1 != STRING2
 字符串不相等返回 true

# 4.文件的比较与类型判断
FILE1 -ef FILE2
 两个文件是否为同一个文件。主要看文件设备号与 inode 是否一致
FILE1 -nt FILE2
 文件 FILE1 是否比 FILE2 新（修改时间新）
FILE1 -ot FILE2
 文件 FILE1 是否比 FILE2 旧（修改时间旧）
-b FILE
 文件存在且是块（block）设备文件
-c FILE
 文件存在且是字符（character）设备文件
-d FILE
 文件存在且是目录（directory）
-e FILE
 文件存在（exist）返回 true
-f FILE
 文件存在且是普通文件
-g FILE
 文件存在且设置了 SGID
-G FILE
 文件存在且属于有效组ID
-h FILE
 文件存在且是软链接。同 -L
-k FILE
 文件存在且设置了粘着位（Sticky Bit）
-L FILE
 文件存在且是软链接。同 -h
-O FILE
 文件存在且属于有效用户ID
-p FILE
 文件存在且属于命名管道
-r FILE
 文件存在且可读
-s FILE
 文件存在且内容不为空
-S FILE
 文件存在且是一个套接字（socket）
-t FD
 文件描述符是在一个终端打开的
-u FILE
 文件存在且设置了 SUID 位
-w FILE
 文件存在且且可写
-x FILE
 文件存在且可执行
注意：

（1）test 拥有选项 --help 与 --version，但无法使用。test 将这两个选项当做非空的普通字符串进行处理，并返回 true；

（2）文件的比较与类型判断，除了 -h 与 -L，其它所有的选项都对软链接进行解引用。

4.常用示例
（1）判断数值是否相等。

test 0 -eq 0; echo $?
0
test 退出状态码等于 0 表示条件成立。

（2）判断文件是否存在。

test -e /etc/passwd; echo $?
0
test 退出状态码等于 0 表示文件存在。

（3）判断文件是否是同一个文件。

test /etc/passwd -ef /etc/shadow; echo $?
1
test 退出状态码等于 1 表示不是同一个文件。
