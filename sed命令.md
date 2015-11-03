sed命令
==========

命令格式：`sed  [-参数]  '命令'  文本`

sed参数：
a 增 在当前行后附加文本
d 删 删除当前行
p 查 打印当前行。默认是把所有的行都打印出来，并把符合条件的行也打印出来。要是屏蔽默认，加参数-n
i 插 在当前行前插入文本
s/regex/replacement/ 换 把regex用replacement替换
y/set1/set2 换 把set1中的字符用对应的set2中的字符替换（必须保证两个集合的字符个数相等）
= 输出当前行的行号
q 处理完当前行后退出sed
Q 直接推出sed

-n 安静模式，不加-n会把输入流都输出到终端，加上后只输出符合条件的
-e 多点
-f -f filename 执行filename文件里的sed命令
-i 直接修改读取的文件内容（慎重）

sed实例：
cat del2 | sed '2s/hello/HELLO/'        #替换第2行
cat del2 | sed '2,3s/hello/HELLO/'      #替换第2到3行
cat del2 | sed 's/hello/HELLO/'         #替换所有行（没有地址，就是默认）
sed '1a HELLO' del2                #在第一行后增加一行，内容是“HELLO”
sed '2,3a HELLO' del2              #从第2到3行，每行后面添加一行，内容是“HELLO”
sed '2,3a HELLO\nHELLOTWO' del2    #从第2到3行，每行增添一些内容“HELLO\nHELLO”，注意增加的里面有回车
sed '1d' del2                   #删除第一行
sed '$d' del2                   #删除最后一行
sed '2,3d' del2                 #删除第2到3行
sed '2p' del2                   #查看第2行，没有-n参数，原来的数据也会输出
sed -n '2p' del2                #查看第2行
sed -n '2,$p' del2              #查看2到最后一行
cat del2 | sed 'iMM:'           #所有的行插入‘iMM:’
cat del2 | sed '2,3iMM:'        #从第23行插入‘iMM:’
sed '1,2s/hello/NO/' del2       #第1到2行hello替换成NO（一行只替换一次）
sed '1,2s/hello/NO/g' del2      #地1到2行的hello全部替换成NO（参数g表示替换全部）
sed '1,2c NO' del2              #把1到2行用NO替换
sed 's/hello/HELLO/' del2       #把所有行的“hello”替换成“HELLO”,等价与sed '1,$s/hello/HELLO/' del2
cat del2 | sed 'y/hel/HEL/'  #把‘hel’对应的‘HEL’
cat del2 | sed '='          #输出当前行的行号
cat del2 | sed 'q'          #输出当前行就结束sed
cat del2 | sed 'Q'          #立马结束sed
cat del2 | sed  -n '2p'            #只输出符号条件的行
cat del2 | sed  -e '2p' -e '3p'    #多重命令同时
sed -f DEL del2                    #按着DEL文件里的awk命令修改
sed -i 's/hel/HEL/' del2             #直接修改del2

