mydumper
===========

release=$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/mydumper/mydumper/releases/latest | cut -d'/' -f8)
yum install https://github.com/mydumper/mydumper/releases/download/${release}/mydumper-${release:1}.el7.x86_64.rpm
yum install https://github.com/mydumper/mydumper/releases/download/${release}/mydumper-${release:1}.el8.x86_64.rpm

brew install mydumper


一旦可以使用 --regex 功能，例如不转储 mysql 和测试数据库：

 mydumper --regex '^(?!(mysql\.|test\.))'
仅转储 mysql 和测试数据库：

 mydumper --regex '^(mysql\.|test\.)'
不转储所有以 test 开头的数据库：

 mydumper --regex '^(?!(test))'
转储不同数据库中的指定表（注意：表的名称应以 $. 结尾。相关问题）：

 mydumper --regex '^(db1\.table1$|db2\.table2$)'
如果你想转储几个数据库但丢弃一些表，你可以这样做：

 mydumper --regex '^(?=(?:(db1\.|db2\.)))(?!(?:(db1\.table1$|db2\.table2$)))'
这将转储 db1 和 db2 中的所有表，但它将排除 db1.table1 和 db2.table2

 mydumper --exec "/usr/bin/gzip FILENAME"
--exec 是单线程的，与 Stream 类似的实现。exec 程序必须是绝对路径。FILENAME 将替换为您要处理的文件名。您可以在任何地方设置 FILENAME 作为参数。

默认文件（又名：--defaults-file 参数）在 MyDumper 中开始变得更加重要
mydumper 和 myloader 部分：
[mydumper]
host = 127.0.0.1
user = root
password = p455w0rd
database = db
rows = 10000

[myloader]
host = 127.0.0.1
user = root
password = p455w0rd
database = new_db
innodb-optimize-keys = AFTER_IMPORT_PER_TABLE

mydumper 和 myloader 执行的变量：
[mydumper_variables]
wait_timeout = 300
sql_mode = ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION

[myloader_variables]
long_query_time = 300
innodb_flush_log_at_trx_commit = 0

每个表部分：
[`db`.`table`]
where = column > 20

多线程导出数据：
nohup echo `date +%T` && mydumper -u $user -p $passwd -S $socket  -B $db -c  -T $table_name  -o $backupdir  -t 32 -r 2000000 && echo `date +%T` &

多线程导入数据：
time myloader -u root -S /datas/mysql/data/3308/mysqld.sock -P 3308 -p root -B test -d /datas/dump_arrival_record -t 32

