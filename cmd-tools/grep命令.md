grep命令
==========
```sh
grep pattern [file...]
pgrep pattern [file...]
```

grep参数：
* `-c`：只输出匹配行的计数。
* `-I`：不区分大 小写(只适用于单字符)。
* `-h`：查询多文件时不显示文件名。
* `-l`：查询多文件时只输出包含匹配字符的文件名。
* `-n`：显示匹配行及 行号。
* `-s`：不显示不存在或无匹配文本的错误信息。
* `-v`：显示不包含匹配文本的所有行。
* `-r`：明确要求搜索子目录
* `-d skip`：忽略子目录

pattern正则表达式主要参数：
* `\`： 忽略正则表达式中特殊字符的原有含义。
* `^`：匹配正则表达式的开始行。
* `$`: 匹配正则表达式的结束行。
* `\<`：从匹配正则表达 式的行开始。
* `\>`：到匹配正则表达式的行结束。
* `[ ]`：单个字符，如[A]即A符合要求 。
* `[ - ]`：范围，如[A-Za-z0-9]，即A、B、C一直到Z都符合要求 。
* `.` ：所有的单个字符。
* `*` ：有字符，长度可以为0。

grep实例
* `grep ‘test’ d*` 显示所有以d开头的文件中包含 test的行。
* `grep ‘test’ aa bb cc` 显示在aa，bb，cc文件中匹配test的行。
* `grep '[a-z]\{5\}' aa*` 显示所有包含每个字符串至少有5个连续小写字符的字符串的行。
* `grep 'w\(es\)t.*\1' aa` 如果west被匹配，则es就被存储到内存中，并标记为1，然后搜索任意个字符(.*)，这些字符后面紧跟着 另外一个es(\1)，找到就显示该行。如果用egrep或grep -E，就不用”\”号进行转义，直接写成’w(es)t.*\1′就可以了。
* `grep magic /usr/src/Linux/Doc/* | less` 假设您正在’/usr/src/Linux/Doc’目录下搜索带字符 串’magic’的文件
* `grep -i pattern files` ：不区分大小写地搜索。默认情况区分大小写，
* `grep -l pattern files` ：只列出匹配的文件名，
* `grep -L pattern files` ：列出不匹配的文件名，
* `grep -w pattern files` ：只匹配整个单词，而不是字符串的一部分(如匹配’magic’，而不是’magical’)，
* `grep -C number pattern files` ：匹配的上下文分别显示[number]行，
* `grep pattern1 | pattern2 files` ：显示匹配 pattern1 或 pattern2 的行，
* `grep pattern1 files | grep pattern2` ：显示既匹配 pattern1 又匹配 pattern2 的行。
* `grep -n pattern files`  即可显示行号信息
* `grep -c pattern files`  即可查找总行数
* `grep man * 会匹配` ‘Batman’、’manic’、’man’等，
* `grep '\<man' *` 匹配’manic’和’man’，但不是’Batman’，
* `grep '\<man\>'` 只匹配’man’，而不是’Batman’或’manic’等其他的字符串。
* `more size.txt | grep '[a-b]'` 范围 ；如[A-Z]即A，B，C一直到Z都符合要求
* `more size.txt | grep 'b'` 单个字符；如[A] 即A符合要求
* `grep 'root' /etc/group `
* `grep '^root' /etc/group` 匹配正则表达式的开始行
* `grep 'uucp' /etc/group `, `grep '\<uucp' /etc/group`
* `grep 'root$' /etc/group` 匹配正则表达式的结束行
* `more size.txt | grep -i 'b1..*3'` -i ：忽略大小写
* `more size.txt | grep -iv 'b1..*3'` -v ：查找不包含匹配项的行
* `more size.txt | grep -in 'b1..*3' `
* `grep '5[[:upper:]][[:upper:]]' data.doc`     #查询以5开头以两个大写字母结尾的行
* `grep "func main" * -r -n --include=*.go > func_main.txt` #查找内容为func main的文件
* `grep php /home/sh_laravel/public/upload/ -r` 或者 `find /home/sh_laravel/public/ -name *.php` 查看上传目录是否被别人上传木马
* `find /home/sh_laravel/ -name *.php | xargs grep -RPnDskip "(php|passthru|shell_exec|system|phpinfo|base64_decode|chmod|mkdir|fopen|fclose|readfile) *\("` 查看文件内容是否包含不安全代码
grep -Hrv ";" /etc/php.ini | grep "extension="
* `grep -5 'parttern' INPUT_FILE` ： #打印匹配行的前后5行
* `grep -C 5 'parttern' INPUT_FILE` ： #打印匹配行的前后5行
* `grep -A 5 'parttern' INPUT_FILE` ： #打印匹配行的后5行
* `grep -B 5 'parttern' INPUT_FILE` ： #打印匹配行的前5行
* `grep -A -15  --color 1010061938 *` ： #查找后着色

使用类名, 可以使用国际模式匹配的类名：
* `[[:upper:]]`   [A-Z]
* `[[:lower:]]`   [a-z]
* `[[:digit:]]`   [0-9]
* `[[:alnum:]]`   [0-9a-zA-Z]
* `[[:space:]]`   空格或tab
* `[[:alpha:]]`   [a-zA-Z]

附加-w（整个单词）-n显示行号。当找到匹配项时，除了找到它的文件路径之外，grep 还会显示找到该模式的行号
-i执行不区分大小写的搜索（默认情况下区分大小写）。根据文件的数量，这可能会减慢搜索速度，因此在使用时要考虑到这一点
--include=GLOB/--exclude=GLOB包括或排除某些文件
--exclude-dir=GLOB 用于从搜索中排除文件夹
grep -Rni --exclude-dir={linuxmi,linuxmi.com} --include={*.txt,*.js} 'linuxmi' /home/linuxmi/www.linuxmi.com

有一点要注意，您必需提供一个文件过滤方式(搜索全部文件的话用 *)。如果您忘了，’grep’会一直等着，直到该程序被中断。如果您遇到了这样的情况，按 <CTRL c> ，然后再试。

ack
======
yum install -y ack
命令特点
默认搜索当前工作目录
默认递归搜索子目录
忽略元数据目录，比如.svn,.git,CSV等目录
忽略二进制文件（比如pdf，image，coredumps)和备份文件（比如foo~,*.swp)
在搜索结果中打印行号，有助于找到目标代码
能搜索特定文件类型（比如Perl,C++,Makefile),该文件类型可以有多种文件后缀
高亮搜索结果
支持Perl的高级正则表达式，比grep所使用GNU正则表达式更有表现力。
相比于搜索速度，ack总体上比grep更快。ack的速度只要表现在它的内置的文件类型过滤器。在搜索过程中，ack维持着认可的文件类型的列表，同时跳过未知或不必要的文件类型。它同样避免检查多余的元数据目录。

命令参数
-n, 显示行号
-l/L, 显示匹配/不匹配的文件名
-c, 统计次数
-v, invert match
-w, 词匹配
-i, 忽略大小写
-f, 只显示文件名,不进行搜索.
-h, 不显示名称
-v, 显示不匹配
在当前目录递归搜索单词”eat”,不匹配类似于”feature”或”eating”的字符串:
> ack -w eat
搜索有特殊字符的字符串’$path=.’,所有的元字符（比如’$’,’.’)需要在字面上被匹配:
> ack -Q '$path=.' /etc
除了temp目录，在所有目录搜索use单词
> ack use --ignore-dir=temp
只搜索包含’main’单词的Python文件，然后通过文件名把搜索结果整合在一起，打印每个文件对应的搜索结果
> ack  --python  --group -w main
ack --help-types
获取包含CFLAG关键字的Makefile的文件名
> ack --make CFLAG
ack查找my.cnf文件
> ack -f /etc/ | ack my.cnf
//或者
> ack -g my.cnf /etc/

ag
======
yum install the_silver_searcher
ag [options] pattern [path ...]
ag [可选项] 匹配模式 [路径...]
ag类似grep 和 find，但是执行效率比后两者高。
ag -g <File Name> 类似于 find . -name <File Name>
ag -i PATTERN： 忽略大小写搜索含PATTERN文本
ag -A PATTERN：搜索含PATTERN文本，并显示匹配内容之后的n行文本，例如：ag -A 5  abc会显示搜索到的包含abc的行以及它之后5行的文本信息。
ag -B PATTERN：搜索含PATTERN文本，并显示匹配内容之前的n行文本
ag -C PATTERN：搜索含PATTERN文本，并同时显示匹配内容以及它前后各n行文本的内容。
ag --ignore-dir <Dir Name>：忽略某些文件目录进行搜索。
ag -w PATTERN： 全匹配搜索，只搜索与所搜内容完全匹配的文本。
ag --java PATTERN： 在java文件中搜索含PATTERN的文本。
ag --xml PATTERN：在XML文件中搜索含PATTERN的文本。

rg 面向行的搜索工具
======
ripgrep 递归搜索目录中的正则表达式模式，同时尊重您的 gitignore
https://github.com/BurntSushi/ripgrep
brew install ripgrep
cargo install ripgrep
dnf install ripgrep

rg -n -w '[A-Z]+_SUSPEND'
git grep -P -n -w '[A-Z]+_SUSPEND'
ugrep -r --ignore-files --no-hidden -I -w '[A-Z]+_SUSPEND'
ag -w '[A-Z]+_SUSPEND'
LC_ALL=C git grep -E -n -w '[A-Z]+_SUSPEND'
ack -w '[A-Z]+_SUSPEND'
LC_ALL=en_US.UTF-8 git grep -E -n -w '[A-Z]+_SUSPEND'
rg -uuu -tc -n -w '[A-Z]+_SUSPEND'
ugrep -r -n --include='*.c' --include='*.h' -w '[A-Z]+_SUSPEND'
egrep -r -n --include='*.c' --include='*.h' -w '[A-Z]+_SUSPEND'
rg -w 'Sherlock [A-Z]\w+'
ugrep -w 'Sherlock [A-Z]\w+'
LC_ALL=en_US.UTF-8 egrep -w 'Sherlock [A-Z]\w+'

