centeros exec 执行权限设置
==========

```sh
vi /etc/sudoers
#Defaults    requiretty
Defaults   visiblepw
apache ALL=(ALL) NOPASSWD: /usr/bin/svn
www ALL=(ALL) NOPASSWD: /usr/bin/svn

Defaults    requiretty这个找到注释掉
Defaults   visiblepw这个原来是Defaults   !visiblepw
```