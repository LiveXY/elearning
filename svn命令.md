svn命令
======
```
svn checkout svnurl dir 取svn
svn co svnurl dir 取svn
svn status  显示未同步文件的状态
svn up /svn up -r 200 test.php 更新最新版本或指定版本
svn add file/path 添加文件
svn commit/svn ci /svn commit -m 'text' 提交版本
svn ci --file text.txt 提交文件
svn delete 删除ＳＶＮ文件
svn diff test.php 比较ＳＶＮ文件
svn merge -r 200:205 test.php（将版本200与205之间的差异合并到当前文件，但是一般都会产生冲突，需要处理一下）
svn ls
svn revert file.txt 还原最新版本
svn resolved file.txt 移除工作副本的目录或文件的“冲突”状态。
svn st -q 查看本地代码做了哪些改动
svn cp http://destpath/trunk http://destpath/branches/my-branch/ -m "create branche for xxx" 创建分支
svn merge -r 14829:HEAD my/branch http://path/to/trunk 合并分支代码到主干
svn blame filename 查看某段代码最后是谁改的
svn revert file #撤销某文件本地的改动 这条命令要谨慎使用，使用之后自己的改动就找不回来了
svn ci -m '' . 提交多个文件
svn up 更新目录文件
svn sw branches_svn_url 切换分支
svn sw --relocate oldsvnurl newsvnurl 切换svn地址
```

取消对代码的修改分为两种情况：
第一种情况：改动没有被提交（commit）。
这种情况下，使用svn revert就能取消之前的修改。
svn revert用法如下：
# svn revert [-R] something
其中something可以是（目录或文件的）相对路径也可以是绝对路径。
当something为单个文件时，直接svn revert something就行了；当something为目录时，需要加上参数-R(Recursive,递归)，否则只会将something这个目录的改动。
在这种情况下也可以使用svn update命令来取消对之前的修改，但不建议使用。因为svn update会去连接仓库服务器，耗费时间。
注意：svn revert本身有固有的危险，因为它的目的是放弃未提交的修改。一旦你选择了恢复，Subversion没有方法找回未提交的修改。

第二种情况：改动已经被提交（commit）。
这种情况下，用svn merge命令来进行回滚。
回滚的操作过程如下：
1、保证我们拿到的是最新代码：
svn update
假设最新版本号是28。
2、然后找出要回滚的确切版本号：
svn log [something]
假设根据svn log日志查出要回滚的版本号是25，此处的something可以是文件、目录或整个项目
如果想要更详细的了解情况，可以使用svn diff -r 28:25 [something]
3、回滚到版本号25：
svn merge -r 28:25 something
为了保险起见，再次确认回滚的结果：
svn diff [something]
发现正确无误，提交。
4、提交回滚：
svn commit -m ”Revert revision from r28 to r25,because of …”
提交后版本变成了29。
将以上操作总结为三条如下：
1. svn update，svn log，找到最新版本（latest revision）
2. 找到自己想要回滚的版本号（rollbak revision）
3. 用svn merge来回滚： svn merge -r : something





