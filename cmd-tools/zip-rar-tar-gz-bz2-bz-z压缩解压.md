linux压缩解压
==========

tar打包解包
```sh
tar -cvf file.tar dir/ 打包
tar -xvf file.tar 解包
tar -tf file.tar 列出 tar 文件中的所有文件列表
tar -dvf file.tar file1.txt file2.txt 解压指定文件
tar --delete -f file.tar file1.txt 从归档 file.tar 中删除 file1.txt
tar -rf file.tar file3.txt 追加 file3.txt 到 file.tar
tar -Af file.tar archive.tar 追加
tar -xvf file.tar -C /root/TAR2 提取文件到另外一个目录
```

zip
```sh
zip -r file.zip dir/ 压缩
unzip file.tar -d dir/ 解压
zip ../file.zip dir/file1.txt -d 删除内部文件
zip -d "zipfile.zip" "path/*"
zip -m file.zip ./file.txt 向压缩文件中file.zip中添加file.txt文件
zip -r -P password mytest.zip mytest/
```

.gz
```sh
解压1：gunzip FileName.gz
解压2：gzip -d FileName.gz
压缩：gzip FileName
.tar.gz 和 .tgz
解压：tar zxvf FileName.tar.gz
压缩：tar zcvf FileName.tar.gz DirName
```

.bz2
```sh
解压1：bzip2 -d FileName.bz2
解压2：bunzip2 FileName.bz2
压缩： bzip2 -z FileName
.tar.bz2
解压：tar jxvf FileName.tar.bz2
压缩：tar jcvf FileName.tar.bz2 DirName
```

.bz
```sh
解压1：bzip2 -d FileName.bz
解压2：bunzip2 FileName.bz
压缩：未知
.tar.bz
解压：tar jxvf FileName.tar.bz
压缩：未知
```

.Z
```sh
解压：uncompress FileName.Z
压缩：compress FileName
.tar.Z
解压：tar Zxvf FileName.tar.Z
压缩：tar Zcvf FileName.tar.Z DirName
.zip
解压：unzip FileName.zip
压缩：zip FileName.zip DirName
```

.rar
```sh
解压：rar x FileName.rar
压缩：rar a FileName.rar DirName 
```
