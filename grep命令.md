grep命令
==========
```sh
grep pattern [file...]
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
* `[ - ]`：范围，如[A-Z]，即A、B、C一直到Z都符合要求 。
* `.` ：所有的单个字符。
* `*` ：有字符，长度可以为0。

grep实例
* `grep ‘test’ d*` 显示所有以d开头的文件中包含 test的行。
* `grep ‘test’ aa bb cc` 显示在aa，bb，cc文件中匹配test的行。
* `* grep '[a-z]\{5\}' aa*` 显示所有包含每个字符串至少有5个连续小写字符的字符串的行。
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

使用类名, 可以使用国际模式匹配的类名：
* `[[:upper:]]`   [A-Z]
* `[[:lower:]]`   [a-z]
* `[[:digit:]]`   [0-9]
* `[[:alnum:]]`   [0-9a-zA-Z]
* `[[:space:]]`   空格或tab
* `[[:alpha:]]`   [a-zA-Z]

有一点要注意，您必需提供一个文件过滤方式(搜索全部文件的话用 *)。如果您忘了，’grep’会一直等着，直到该程序被中断。如果您遇到了这样的情况，按 <CTRL c> ，然后再试。

