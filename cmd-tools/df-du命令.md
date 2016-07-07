df报告磁盘空间的占用情况
========
df 命令列出指定的文件名所在的文件系统上可用磁盘空间的数量。 如果没有指定文件名，则显示当前所有使用中的文件系统。默认情况下，磁盘空间以 1K 为一块显示，如果设置了环境变量 POSIXLY_CORRECT，则采用 512 字节为一块显示。

###df命令格式
```sh
df [OPTION]... [FILE]...
```

###df命令参数
* `-a, --all` 显示所有文件系统磁盘空间的占用情况
* `-B, --block-size=SIZE` 指定块的大小
* `--total` 额外显示总体的磁盘空间的占用情况
* `-h, --human-readable` 以易于阅读的方式显示信息
* `-H, --si` 与 -h 类似，但是 1K = 1000 Byte 而不是 1K = 1024 Byte
* `-i, --inodes` 以 inode 信息代替块表示占用情况
* `-k` 相当于 --block-size=1K
* `-l, --local` 仅显示本地文件系统的占用情况
* `--no-sync` 在获取磁盘信息前不调用 sync
* `-P, --portability` 以 POSIX 格式输出
* `--sync` 在获取磁盘信息前先调用 syn
* `-t, --type=TYPE` 仅显示指定类型的文件系统的信息
* `-T, --print-type` 额外显示每个文件系统的类型
* `-x, --exclude-type=TYPE` 仅显示指定类型之外的文件系统的信息
* `-v` (忽略)
* `--help` 显示帮助信息
* `--version` 显示版本信息

###df实例
* `df` 列出所有文件系统磁盘空间的占用情况
* `df /etc/passwd` 列出 /etc/passwd 文件所在文件系统磁盘空间的占用情况
* `df -t ext4` 指定特定类型的文件系统
* `df -B 1M` 指定块的大小
* `df -h或df -ih` 以易于阅读的方式显示

du查询档案或目录的磁盘使用空间
=========

###du命令格式
```sh
du [OPTION]... [PATH]...
```

###du命令参数
* `-a` 显示全部目录和其次目录下的每个档案所占的磁盘空间
* `-b` 大小用bytes来表示 (默认值为k bytes)
* `-c` 最后再加上总计 (默认值)
* `-s` 只显示各档案大小的总合 (summarize)
* `-x` 只计算同属同一个档案系统的档案
* `-L` 计算所有的档案大小
* `-h` 参数来显示 human-readable 的格式
常用命令：

###du实例
* `du -a`
* `du -h /etc` -h 参数来显示 human-readable 的格式
* `du -sh /etc` -s 参数来省略指定目录下的子目录，而只显示该目录的总合
* `du -h --max-depth=1` 快速的了解哪些目录变得比较大
* `du -hm --max-depth=2 | sort -nr | head -12`
