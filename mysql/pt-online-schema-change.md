####pt-online-schema-change [OPTIONS] DSN

常用的参数：
* --user:
-u，连接的用户名
* `--password` `-p`，连接的密码
* `--database` `-D`，连接的数据库
* `--port` `-P`，连接数据库的端口
* `--host` `-h`，连接的主机地址
* `--socket` `-S`，连接的套接字文件
* `--ask-pass` 隐式输入连接MySQL的密码
* `--charset` 指定修改的字符集
* `--defaults-file` `-F`，读取配置文件
* `--alter`：
```
结构变更语句，不需要alter table关键字。可以指定多个更改，用逗号分隔。如下场景，需要注意：
不能用RENAME来重命名表。
列不能通过先删除，再添加的方式进行重命名，不会将数据拷贝到新列。
如果加入的列非空而且没有默认值，则工具会失败。即其不会为你设置一个默认值，必须显示指定。
删除外键(drop foreign key constrain_name)时，需要指定名称_constraint_name，而不是原始的constraint_name。
如：CONSTRAINT `fk_foo` FOREIGN KEY (`foo_id`) REFERENCES `bar` (`foo_id`)，需要指定：--alter "DROP FOREIGN KEY _fk_foo"
```
* `--alter-foreign-keys-method`
```
如何把外键引用到新表?需要特殊处理带有外键约束的表,以保证它们可以应用到新表.当重命名表的时候,外键关系会带到重命名后的表上。
该工具有两种方法,可以自动找到子表,并修改约束关系。
auto： 在rebuild_constraints和drop_swap两种处理方式中选择一个。
rebuild_constraints：使用 ALTER TABLE语句先删除外键约束,然后再添加.如果子表很大的话,会导致长时间的阻塞。
drop_swap： 执行FOREIGN_KEY_CHECKS=0,禁止外键约束,删除原表,再重命名新表。这种方式很快,也不会产生阻塞,但是有风险：
1, 在删除原表和重命名新表的短时间内,表是不存在的,程序会返回错误。
2, 如果重命名表出现错误,也不能回滚了.因为原表已经被删除。
none： 类似"drop_swap"的处理方式,但是它不删除原表,并且外键关系会随着重命名转到老表上面。
```
* `--[no]check-alter` 默认yes，语法解析。配合--dry-run 和 --print 一起运行，来检查是否有问题（change column，drop primary key）。
* `--max-lag` 默认1s。每个chunk拷贝完成后，会查看所有复制Slave的延迟情况。要是延迟大于该值，则暂停复制数据，直到所有从的滞后小于这个值，使用Seconds_Behind_Master。如果有任何从滞后超过此选项的值，则该工具将睡眠--check-interval指定的时间，再检查。如果从被停止，将会永远等待，直到从开始同步，并且延迟小于该值。如果指定--check-slave-lag，该工具只检查该服务器的延迟，而不是所有服务器。
* `--check-slave-lag` 指定一个从库的DSN连接地址,如果从库超过--max-lag参数设置的值,就会暂停操作。
* `--recursion-method`
```
默认是show processlist，发现从的方法，也可以是host，但需要在从上指定report_host，通过show slave hosts来找到，可以指定none来不检查Slave。
METHOD       USES
===========  ==================
processlist  SHOW PROCESSLIST
hosts        SHOW SLAVE HOSTS
dsn=DSN      DSNs from a table
none         Do not find slaves
指定none则表示不在乎从的延迟。
--check-interval
默认是1。--max-lag检查的睡眠时间。
```
* `--[no]check-plan` 默认yes。检查查询执行计划的安全性。
* `--[no]check-replication-filters` 默认yes。如果工具检测到服务器选项中有任何复制相关的筛选，如指定binlog_ignore_db和replicate_do_db此类。发现有这样的筛选，工具会报错且退出。因为如果更新的表Master上存在，而Slave上不存在，会导致复制的失败。使用–no-check-replication-filters选项来禁用该检查。
* `--[no]swap-tables` 默认yes。交换原始表和新表，除非你禁止--[no]drop-old-table。
* `--[no]drop-triggers` 默认yes，删除原表上的触发器。 --no-drop-triggers 会强制开启 --no-drop-old-table 即：不删除触发器就会强制不删除原表。
* `--new-table-name` 复制创建新表的名称，默认%T_new。
* `--[no]drop-new-table` 默认yes。删除新表，如果复制组织表失败。
* `--[no]drop-old-table` 默认yes。复制数据完成重命名之后，删除原表。如果有错误则会保留原表。
* `--max-load` 默认为Threads_running=25。每个chunk拷贝完后，会检查SHOW GLOBAL STATUS的内容，检查指标是否超过了指定的阈值。如果超过，则先暂停。这里可以用逗号分隔，指定多个条件，每个条件格式： status指标=MAX_VALUE或者status指标:MAX_VALUE。如果不指定MAX_VALUE，那么工具会这只其为当前值的120%。
* `--critical-load` 默认为Threads_running=50。用法基本与--max-load类似，如果不指定MAX_VALUE，那么工具会这只其为当前值的200%。如果超过指定值，则工具直接退出，而不是暂停。
* `--default-engine` 默认情况下，新的表与原始表是相同的存储引擎，所以如果原来的表使用InnoDB的，那么新表将使用InnoDB的。在涉及复制某些情况下，很可能主从的存储引擎不一样。使用该选项会默认使用默认的存储引擎。
* `--set-vars` 设置MySQL变量，多个用逗号分割。默认该工具设置的是： wait_timeout=10000 innodb_lock_wait_timeout=1 lock_wait_timeout=60
* `--chunk-size-limit` 当需要复制的块远大于设置的chunk-size大小,就不复制.默认值是4.0，一个没有主键或唯一索引的表,块大小就是不确定的。
* `--chunk-time` 在chunk-time执行的时间内,动态调整chunk-size的大小,以适应服务器性能的变化，该参数设置为0,或者指定chunk-size,都可以禁止动态调整。
* `--chunk-size` 指定块的大小,默认是1000行,可以添加k,M,G后缀.这个块的大小要尽量与--chunk-time匹配，如果明确指定这个选项,那么每个块就会指定行数的大小.
* `--[no]check-plan` 默认yes。为了安全,检查查询的执行计划.默认情况下,这个工具在执行查询之前会先EXPLAIN,以获取一次少量的数据,如果是不好的EXPLAIN,那么会获取一次大量的数据，这个工具会多次执行EXPALIN,如果EXPLAIN不同的结果,那么就会认为这个查询是不安全的。
* `--statistics` 打印出内部事件的数目，可以看到复制数据插入的数目。
* `--dry-run` 创建和修改新表，但不会创建触发器、复制数据、和替换原表。并不真正执行，可以看到生成的执行语句，了解其执行步骤与细节。--dry-run与--execute必须指定一个，二者相互排斥。和--print配合最佳。
* `--execute` 确定修改表，则指定该参数。真正执行。--dry-run与--execute必须指定一个，二者相互排斥。
* `--print` 打印SQL语句到标准输出。指定此选项可以让你看到该工具所执行的语句，和--dry-run配合最佳。
* `--progress` 复制数据的时候打印进度报告，二部分组成：第一部分是百分比，第二部分是时间。
* `--quiet` `-q`，不把信息标准输出。