john暴力破解
==========

john安装：
```sh
wget http://www.openwall.com/john/j/john-1.8.0.tar.gz
tar xzvf john-1.8.0.tar.gz
cd john-1.8.0/src/
make
make clean linux-x86-64
cd ../run/
./john --test
./john hcpasswd
```