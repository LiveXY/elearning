git命令

http://rongjih.blog.163.com/blog/static/335744612010112562833316/
git cherry-pick 92960fe 一个bug修改后并到多个分支

撤销(几乎)任何操作
1, git revert <SHA> #撤销一个“已公开”的改变
2, git commit --amend 或 git commit --amend -m "" #修正最后一个 commit 消息
3, git checkout -- <bad filename> #撤销“本地的”修改
4, git reset <last good SHA> 或 git reset --hard <last good SHA> #重置“本地的”修改
http://mp.weixin.qq.com/s?__biz=MzAxODI5ODMwOA==&mid=209020276&idx=1&sn=f1c4a675aaf0d7d082965f947abd5a41#rd

1,git pull时error: Your local changes to the following files would be overwritten by merge:
git checkout -f 或 git checkout HEAD^ file/to/overwrite
git pull
2,git push时error: RPC failed; result=22, HTTP code = 411
git config http.postBuffer 524288000
3,删除.svn/.git文件
find . -name ".svn" | xargs rm -rf #删除文件夹下的所有 .svn 文件
find . -name ".git" | xargs rm -rf #删除文件夹下的所有 .git 文件
4,正确的更新代码：
git fetch
git checkout origin/master -- path/to/file
git checkout [branch] -- [file name] 从其它分支提取文件
5,文件回退到指定的版本
git log file.txt 查看文件的修改记录
git reset a4e215234aa4927c85693dca7b68e9976948a35e file.txt 回退到指定的版本
git commit -m ""  提交到本地参考
git checkout file.txt 更新到工作目录
git push origin master 提交到远程仓库
6,转换svn代码到git
-s 等于 -T trunk -b branches -t tags
git svn clone http://svn.web.com:3680/svn/slots/web/ -T trunk -b branches -t tags -A user.txt --no-metadata slotshz/ #用ＧＩＴ克隆ＳＶＮ项目并保留ＳＶＮ提交日志
git gc #进行垃圾搜集和压缩
git remote add origin https://git.web.com/web/shz.git
git push origin --all #提交所有
git push origin --tags
提交到ＳＶＮ：git svn rebase / git svn dcommit
提交到ＧＩＴ：git svn rebase / git pull / git commit -am "" / git push
git svn rebase #拉取服务器上所有最新的改变，在基础上衍合你的修改
sit svn fetch #拉取最新修改，不更新本地数据
git svn dcommit #提交到SVN

7,常用命令
git remote set-url origin git@git.web.com:web/web.com.git 更换新的仓库地址
git push #将本地修改推送到远程
git pull #将远程合并到当前分支 = git fetch & git merge(此方法更安全一些)
git fetch #从远程获取最新版本到本地，不会自动合并
git merge #合并不同分支
git rebase #跟远程分支同步
git branch -a #查看所有分支
git status #检查一下代码库的状态
git diff file #比较本地文件和最近一次提交的区别
git show #查看最近一次提交的内容
git rm file #删除文件
git rm path -rf #删除目录和子目录
git mv file newfile #修改文件名
git checkout master #切换分支
8,实例
git fetch origin master #从远程的origin的master主分支下载最新的版本到origin/master分支上
git log -p master..origin/master #比较本地的master分支和origin/master分支的差别
git merge origin/master #合并到本地
git fetch origin master:tmp #从远程的origin的master主分支下载最新的版本到origin/master分支上
git diff tmp #比较本地的master分支和origin/master分支的差别
git merge tmp #合并到本地

删除当前仓库内未受版本管理的文件：$ git clean -f
恢复仓库到上一次的提交状态：$ git reset --hard
回退所有内容到上一个版本：$ git reset HEAD^
回退a.py这个文件的版本到上一个版本：$ git reset HEAD^ a.py
回退到某个版本：$ git reset 057d
将本地的状态回退到和远程的一样：$ git reset –hard origin/master
向前回退到第3个版本：$ git reset –soft HEAD~3
修改最后的提交日志：$ git commit --amend

git pull origin master #从远程获取origin的master最新版本并merge到本地

要更新本地仓库的远程地址请运行(使用ssh):
git remote set-url origin git@git.web.com:user/ios.git
或使用http(s):
git remote set-url origin https://git.web.com/user/ios.git

git checkout path/file #还原(等同svn revert)

git pull --rebase #1.把本地repo. 从上次pull 之后的变更暂存起来2. 回复到上次pull 时的情况3. 套用远端的变更4. 最后再套用刚暂存下来的本地变更。得到一个线性的特性分支
merge 操作遇到冲突的时候，当前merge不能继续进行下去。手动修改冲突内容后，add 修改，commit 就可以了。
rebase 冲突，会中断rebase,同时会提示去解决冲突。解决冲突后,将修改add后执行git rebase --continue继续操作，或者git rebase --skip忽略冲突。
同分支 git pull --rebase origin xxx, 合并分支 git merge --no-ff xxx

git checkout master #切换到master分支
git merge --no-ff myfeature #将我的新功能分支合并到master分支
git branch -d myfeature #删除功能分支
git push origin master #推送到master分支

git checkout -b release-1.0 master #从master发布一个release-1.0分支
修改部分内容
git commit -a -m "release-1.0" #提交新版本
git checkout master #切换到master
git merge --no-ff release-1.0 #将release-1.0合并到master
git tag -a 1.0 #打个1.0的tag

更新单个文件：
git fetch origin master #下载master最新版本
git checkout origin/master -- path/to/file #更新指定文件
更新全部文件：
git pull origin master

开始一个无历史的新分支git checkout --orphan NEW_BRANCH_NAME_HERE
无切换分支的从其它分支Checkout文件git checkout BRANCH_NAME_HERE -- PATH_TO_FILE_IN_BRANCH_HERE
检查提交的变动是否是release的一部分git name-rev --name-only COMMIT_HASH_HERE

Git自动补全
cd ~
curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
然后，添加下面几行到你的 ~/.bash_profile 文件中：
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi


cd /home/
git clone git@git.web.com:web/tt.git _temp/
git clone git@git.web.com:web/tt.com.git _temp/
mkdir _temp/application/logs/
mkdir _temp/application/cache/
chmod 777 _temp/application/logs/
chmod 777 _temp/application/cache/

rm web.com/application/cache/*.txt -f
rm web.com/application/logs/*.html -f
rm web.com/application/logs/2014/ -rf
rm web.com/application/logs/2015/ -rf

svn status web.com/
cp -R web.com/static/upload/avatar/ _temp/static/upload/
cp web.com/application/bootstrap.php _temp/application/
mkdir _temp/static/upload/water
mkdir _temp/static/upload/delete

mv web.com/ _web.com/
mv _temp/ web.com/

git pull

yum install git -y
or
yum install git -y --disablerepo=rpmforge

git clone https://github.com/mono/mwf-designer.git
git pull/git fetch
git push
初始化git仓库: git init
自报家门:
git config --global user.name "xxxx"
git config --global user.email "xxxx"
把文件添加到仓库(添加前必须文件已存在)：
git add readme.txt
提交到仓库:
git commit -m "xxxxx"
xxxxx:本次提交说明
查看目前git状态：
git status
察看提交历史记录：
git log
如果烟花缭乱，可以加上参数：
git log --pretty=oneline
回滚到上一版本：
git reset --hard HEAD^
再回到未来某个版本：
git reset --hard xxxxxxx
git提供了一个git reflog命令来记录你的每一次命令。
git reflog
git add实际上是把文件修改添加到暂存区
git commit实际上是把暂存区的所有内容提交到当前分支。
当你乱修改工作区的内容，想丢弃工作区的修改：
git checkout -- file
当你不但乱改了工作区的内容，还修改了暂存区的内容，想丢弃修改，分两步：
1：git reset HEAD file
2: git checkout -- file
假设你删除了某个文件，有两个选择，第一是你确实想删除某个文件，那就是：
git rm file
第二就是在你删错了，想还原，那就是：
git checkout -- file
创建sshkey：
ssh-keygen -t rsa -C "youemail@example.com"
接下来一路回车，生成两个文件：id_rsa是私匙，不能泄露。id_rsa.pub是公匙。可以放心告诉任何人
登陆github，add ssh key，title任意填写，key里边粘贴id_rsa.pub内容即可。
远端先创建一个仓库，点击Create a new repo,填写仓库名字learngit，其他默认，点击Create repository。
关联一个远程库：
git remote add origin git@github.com:guangmangdz/learngit.git
接下来再推送：
git push -u origin master,实际上就是把当前分支推送到远程。由于远端库是空的，所以加了-u参数，以后可以不加。
从现在起，只要本地做了提交，就可以通过命令：
git push origin master，把本地master分支最新更改推送之github。
从远程库克隆：
git clone git@github.com:xxxxxxxx/xxxxx.git
接下来：分支管理
创建分支，例如dev：
git checkout -b dev
也可以用一下两条命令创建：
git branch dev，创建dev分支
git checkout dev,切换到dev分支
列出当前分支：
git branch
合并分支：
git merge dev，操作前提是已经处于master分支状态
合并完成后，就可以放心的删除dev分支了：
git branch -d dev
察看git分支合并图：
git lob --graph
正常的合并是fast forward模式，当然也可以禁用：
git merge --no-ff -m "merge with no-ff" dev
首先，master分支应该是非常稳定的，也就是用来发布新版本，平时不用在上面干活。干活都在dev分支上，也就是说，你和你的小伙伴们每个人都在dev分支上干活，每个人都有自己的分支，是不是的往dev分支上合并就可以了。
bug分支：
假如这种情况，你正在dev分支下写代码，但还没写完，又不能提交，而此时接到一个紧急处理bug的紧急任务，且该人物来源于master分支。可以先用git stash将当前工作现场储存起来。
bug解决完了，再回到dev分支，如何恢复现场？
1：git stash apply，恢复后，stash不删除，需要调用git stash drop
2: git stash pop，恢复同时把stash内容也删除。
feature分支：
开发过程中，有无穷无尽的新功能添加进来，但你不希望一些实验性质的代码把主分支搞乱了，所以，每添加一个新功能，最好新建一个feature分支，在上面开发。
git checkout -b feature
开发完成后，切回dev，准备合并
git checkout dev
但是！突然该功能要求取消，必须销毁这个分支：
git branch -d feature,正常的话会提示销毁失败，因为还未合并，所以就来了下面的命令：
git branch -D feature，强制删除一个分支
多人写作：
察看远程库信息：
git remote
加-v可以察看更详细的信息：
git remote -v
推送分支：
git push origin master
git push origin dev
你的小伙伴想在dev分支下开发，就必须创建远程origin的dev分支到本地：
git checkout -b dev origin/dev
多人写作工作模式通常如下：
1、首先，试图用git push origin branch-name推送自己的修改
2、如果推送失败，则因为远程分支比你的本地更新，需要先用git pull试图合并
3、如果合并有冲突，则解决冲突，并在本地提交
4、没有冲突或者解决冲突后，在用git push origin branch-name推送就能成功
5、如果git pull提示“no tracking infor...”，说明本地分支和远程分支的链接关系没有创建，用命令git branch --set-upstream branch-name origin/branch-name
标签管理：
发布一个新版本时，通常大一个标签。这个标签唯一确定了打标签时刻的版本。标签也是版本库的一个快照。
git tag xxx
察看所有标签：
git tag
给历史某次提交的commit id打标签：
git tag vx.x xxxxxxx
创建带说明的标签：
git tag -a vx.x -m "tags shuoming" xxxxxxx
打错了标签，也可以删除：
git tag -d Vx.x
推送某个标签到远程：
git push origin vx.x
一次性推送所有未推送的标签到远程：
git push origin --tags
删除远程标签（需先删除本地标签）：
git tag -d v0.9
git push origin :refs/tags/v0.9
让git显示颜色：
git config --global color.ui true
git可以忽略特殊文件，所有配置文件在：
https://github.com/github/gitignore
.gitignore文件本身也需要放到版本库里
最后说说搭建git服务器：
1、ubuntu或debian及其，安装git
sudo apt-get install git
2、创建一个git用户，用来运行git服务
sudo adduser git
3、创建证书登陆：
收集所有需要登陆的用户的公匙，把所有公匙导入到home/git/.ssh/authorized_keys文件里，易行一个。
4、初始化git仓库：
sudo git init --bare sample.git
5、把owner改为git：
sudo chown -R git:git sample.git
6、禁用shell登陆：编辑etc/passwd
git:x:1001:1001:,,,:/home/git:/bin/bash
改为
git:x:1001:1001:,,,:/home/git:/usr/bin/git-shell

Git常用操作命令收集：
1) 远程仓库相关命令
检出仓库：$ git clone git://github.com/jquery/jquery.git
查看远程仓库：$ git remote -v
添加远程仓库：$ git remote add [name] [url]
删除远程仓库：$ git remote rm [name]
修改远程仓库：$ git remote set-url --push [name] [newUrl]
拉取远程仓库：$ git pull [remoteName] [localBranchName]
推送远程仓库：$ git push [remoteName] [localBranchName]
强制推送更改：$ git push --force origin master

* 如果想把本地的某个分支test提交到远程仓库，并作为远程仓库的master分支，或者作为另外一个名叫test的分支，如下：
$ git push origin test:master         // 提交本地test分支作为远程的master分支
$ git push origin test:test              // 提交本地test分支作为远程的test分支

2）分支(branch)操作相关命令
查看本地分支：$ git branch
查看远程分支：$ git branch -r （如果还是看不到就先 git fetch origin 先）
创建本地分支：$ git branch [name] ----注意新分支创建后不会自动切换为当前分支
切换分支：$ git checkout [name]
创建新分支并立即切换到新分支：$ git checkout -b [name]
直接检出远程分支：$ git checkout -b [name] [remoteName] (如：git checkout -b myNewBranch origin/dragon)
删除分支：$ git branch -d [name] ---- -d选项只能删除已经参与了合并的分支，对于未有合并的分支是无法删除的。如果想强制删除一个分支，可以使用-D选项
合并分支：$ git merge [name] ----将名称为[name]的分支与当前分支合并
合并最后的2个提交：$ git rebase -i HEAD~2 ---- 数字2按需修改即可（如果需提交到远端$ git push -f origin master 慎用！）
创建远程分支(本地分支push到远程)：$ git push origin [name]
删除远程分支：$ git push origin :heads/[name] 或 $ git push origin :[name]
修改分支名称：git branch -m <old_branch_name> <new_branch_name>

* 创建空的分支：(执行命令之前记得先提交你当前分支的修改，否则会被强制删干净没得后悔)
$ git symbolic-ref HEAD refs/heads/[name]
$ rm .git/index
$ git clean -fdx

3）版本(tag)操作相关命令
查看版本：$ git tag
创建版本：$ git tag [name]
删除版本：$ git tag -d [name]
查看远程版本：$ git tag -r
创建远程版本(本地版本push到远程)：$ git push origin [name]
删除远程版本：$ git push origin :refs/tags/[name]
合并远程仓库的tag到本地：$ git pull origin --tags
上传本地tag到远程仓库：$ git push origin --tags
创建带注释的tag：$ git tag -a [name] -m 'yourMessage'

4) 子模块(submodule)相关操作命令
添加子模块：$ git submodule add [url] [path]
    如：$ git submodule add git://github.com/soberh/ui-libs.git src/main/webapp/ui-libs
初始化子模块：$ git submodule init  ----只在首次检出仓库时运行一次就行
更新子模块：$ git submodule update ----每次更新或切换分支后都需要运行一下
删除子模块：（分4步走哦）
 1) $ git rm --cached [path]
 2) 编辑“.gitmodules”文件，将子模块的相关配置节点删除掉
 3) 编辑“ .git/config”文件，将子模块的相关配置节点删除掉
 4) 手动删除子模块残留的目录

5）忽略一些文件、文件夹不提交
在仓库根目录下创建名称为“.gitignore”的文件，写入不需要的文件夹名或文件，每个元素占一行即可，如
target
bin
*.db

6）后悔药
删除当前仓库内未受版本管理的文件：$ git clean -f
恢复仓库到上一次的提交状态：$ git reset --hard
回退所有内容到上一个版本：$ git reset HEAD^
回退a.py这个文件的版本到上一个版本：$ git reset HEAD^ a.py
回退到某个版本：$ git reset 057d
将本地的状态回退到和远程的一样：$ git reset –hard origin/master
向前回退到第3个版本：$ git reset –soft HEAD~3
修改最后的提交日志：$ git commit --amend

7）Git一键推送多个远程仓库
编辑本地仓库的.git/config文件：
[remote "all"]
    url = git@github.com:dragon/test.git
    url = git@gitcafe.com:dragon/test.git
这样，使用git push all即可一键Push到多个远程仓库中。

8）缓存认证信息
$ git config credential.helper cache

9）查看提交日志
》查看文件中的每一行的作者、最新的变更提交和提交时间
$ git blame [fileName]
Git常用操作命令 - rongjih - 拥有自己的梦想，跟随心的召唤
》查看仓库历史记录
有三个应该知道的选项。
--oneline - 压缩模式，在每个提交的旁边显示经过精简的提交哈希码和提交信息，以一行显示。
--graph - 图形模式，使用该选项会在输出的左边绘制一张基于文本格式的历史信息表示图。如果你查看的是单个分支的历史记录的话，该选项无效。
--all - 显示所有分支的历史记录
把这些选项组合起来之后如下：
Git常用操作命令 - rongjih - 拥有自己的梦想，跟随心的召唤
使用 $ git log --oneline --graph --name-status 既可以看到简介的日志信息，也可以看到改了哪些文件，一举两得：
Git常用操作命令 - rongjih - 拥有自己的梦想，跟随心的召唤

10）有选择的合并 - 这个功能最赞，没有之一
cherry-pick 可以从不同的分支中捡出一个单独的commit，并把它和你当前的分支合并。如果你以并行方式在处理两个或以上分支，你可能会发现一个在全部分支中都有的bug。如果你在一个分支中解决了它，你可以使用cherry-pick命令把它commit到其它分支上去，而不会弄乱其他的文件或commit。
$ git cherry-pick [commitHash]

11）Stash未提交的更改
正在修改某个bug或者某个特性，又突然被要求展示工作。而现在所做的工作还不足以提交，这个阶段还无法进行展示（不能回到更改之前）。在这种情况下， git stash可以帮到忙了。stash在本质上会取走所有的变更并存储它们以备将来使用。
$ git stash
检查stash列表：$ git stash list
想解除stash并且恢复未提交的变更，就进行apply stash：$ git stash apply
如果只想留有余地进行apply stash，给apply添加特定的标识符：$ git stash apply stash@{0}

12）多次修改后拆分提交 - 暂存文件的部分改动
一般情况下，创建一个基于特性的提交是比较好的做法，意思是每次提交都必须代表一个新特性的产生或者是一个bug的修复。如果你修复了两个bug，或是添加了多个新特性但是却没有提交这些变化会怎样呢？在这种情况下，你可以把这些变化放在一次提交中。但更好的方法是把文件暂存(Stage)然后分别提交。
例如你对一个文件进行了多次修改并且想把他们分别提交。这种情况下，可以在 add 命令中加上 -p 参数
$ git add -p [fileName]

13）压缩多个Commit
用rebase命令把多个commit压缩成一个
git rebase -i HEAD~[number_of_commits]
如果你想要压缩最后两个commit，你需要运行下列命令：
git rebase -i HEAD~2
Docs: http://git-scm.com/book/en/v2/Git-Branching-Rebasing

14）差异查看
$ git diff --name-status HEAD~2 HEAD~3 <-- 获得两个版本间所有变更的文件列表
$ git diff HEAD HEAD~1 <-- 查看最近两个提交之间的差异
$ git diff HEAD HEAD~2 <-- 查看第1个与第3个提交之间的差异
^ - 代表父提交，^n 表示第n个父提交，^相当于^1 git寻根：^和~的区别 - 分析得很到位
~ - 代表连续的提交，~n相当于连续的第n个提交
$ git diff master..test <-- 比较两个分支之间的差异
$ git diff master...test <-- 比较master、test的共有父分支和 test 分支之间的差异
$ git diff test <-- 比较当前工作目录与 test 分支的差异
$ git diff HEAD <-- 比较当前工作目录与上次提交的差异
$ git diff HEAD -- ./lib  <-- 比较当前工作目录下的lib目录与上次提交的差异
$ git diff --stat  <-- 统计一下有哪些文件被改动，有多少行被改动
$ git diff --cached  <-- 查看下次提交时要提交的内容(staged,添加到索引中)

15）Git for Windows 中文乱码问题 (1.9.4-preview20140611)
》git log 显示的文件名乱码
执行 "git config –global core.quotepath false"可以解决之。core.quotepath设为false，就不会对0×80以上的字符进行quote，中文就显示正常。
修正前：
Git常用操作命令 - rongjih - 拥有自己的梦想，跟随心的召唤
修正后：
Git常用操作命令 - rongjih - 拥有自己的梦想，跟随心的召唤
》ls命令显示的中文名乱码
改用"ls --show-control-chars"命令代替单纯的"ls"命令即可。
或者编辑.../Git/etc/git-completion.bash，新增一行 alias ls="ls –show-control-chars"

16,把当前分支中未提交的修改移动到其他分支
git stash
git checkout branch2
git stash pop

17, 搜索
从当前目录的所有文件中查找文本内容：
$ git grep "Hello"
在某一版本中搜索文本：
$ git grep "Hello" v2.5

18, 提交历史
从最新提交开始，显示所有的提交记录（显示hash， 作者信息，提交的标题和时间）：
$ git log
显示所有提交（仅显示提交的hash和message）：
$ git log --oneline
显示某个用户的所有提交：
$ git log --author="username"
显示某个文件的所有修改：
$ git log -p <file>
谁，在什么时间，修改了文件的什么内容：
$ git blame <file>

19,分支与标签
列出所有的分支：
$ git branch
切换分支：
$ git checkout <branch>
创建并切换到新分支:
$ git checkout -b <branch>
基于当前分支创建新分支：
$ git branch <new-branch>
基于远程分支创建新的可追溯的分支：
$ git branch --track <new-branch> <remote-branch>
删除本地分支:
$ git branch -d <branch>
给当前版本打标签：
$ git tag <tag-name>

20, 更新与发布
列出当前配置的远程端：
$ git remote -v
显示远程端的信息：
$ git remote show <remote>
添加新的远程端：
$ git remote add <remote> <url>
下载远程端版本，但不合并到HEAD中：
$ git fetch <remote>
下载远程端版本，并自动与HEAD版本合并：
$ git remote pull <remote> <url>
将远程端版本合并到本地版本中：
$ git pull origin master
将本地版本发布到远程端：
$ git push remote <remote> <branch>
删除远程端分支：
$ git push <remote> :<branch> (since Git v1.5.0)
或
git push <remote> --delete <branch> (since Git v1.7.0)
发布标签:
$ git push --tags

21， 合并与重置
将分支合并到当前HEAD中：
$ git merge <branch>
将当前HEAD版本重置到分支中:
请勿重置已发布的提交!
$ git rebase <branch>
退出重置:
$ git rebase --abort
解决冲突后继续重置：
$ git rebase --continue
使用配置好的merge tool 解决冲突：
$ git mergetool
在编辑器中手动解决冲突后，标记文件为已解决冲突
$ git add <resolved-file>
$ git rm <resolved-file>

22, 撤销
放弃工作目录下的所有修改：
$ git reset --hard HEAD
移除缓存区的所有文件（i.e. 撤销上次git add）:
$ git reset HEAD
放弃某个文件的所有本地修改：
$ git checkout HEAD <file>
重置一个提交（通过创建一个截然不同的新提交）
$ git revert <commit>
将HEAD重置到指定的版本，并抛弃该版本之后的所有修改：
$ git reset --hard <commit>
将HEAD重置到上一次提交的版本，并将之后的修改标记为未添加到缓存区的修改：
$ git reset <commit>
将HEAD重置到上一次提交的版本，并保留未提交的本地修改：
$ git reset --keep <commit>

git log --oneline --abbrev-commit --branches=* --graph --decorate --color
