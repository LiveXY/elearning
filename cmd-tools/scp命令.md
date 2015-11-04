scp 命令
==========

格式：
```sh
scp 本地用户名@IP地址:文件名1 远程用户名@IP地址:文件名2
```

scp参数 :
* `-a` 尽可能将档案状态、权限等资料都照原状予以复制。
* `-r` 若 source 中含有目录名，则将目录下之档案亦皆依序拷贝至目的地。
* `-f` 若目的地已经有相同档名的档案存在，则在复制前先予以删除再行复制。
* `-v` 和大多数 linux 命令中的 -v 意思一样 , 用来显示进度 . 可以用来查看连接 , 认证 , 或是配置错误 .
* `-C` 使能压缩选项 .
* `-P` 选择端口 . 注意 -p 已经被 rcp 使用 .
* `-4` 强行使用 IPV4 地址 .
* `-6` 强行使用 IPV6 地址 .

文件从 本地 复制到 远程
```sh
scp local_file remote_username@remote_ip:remote_folder
或者
scp local_file remote_username@remote_ip:remote_file
或者
scp local_file remote_ip:remote_folder
或者
scp local_file remote_ip:remote_file

scp xiong.zip root@127.0.0.1:/home/
```
目录从 本地 复制到 远程
```sh
scp -r local_folder remote_username@remote_ip:remote_folder
或者
scp -r local_folder remote_ip:remote_folder
```

从 远程 复制到 本地, 只要将 从 本地 复制到 远程 的命令 的 后2个参数 调换顺序 即可；
```sh
scp root@127.0.0.1:/etc/nginx/conf.d/default.conf ./relaxlife.conf
```
