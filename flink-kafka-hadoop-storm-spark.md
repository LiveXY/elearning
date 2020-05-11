java1.8 安装：
```
yum install ava-1.8.0-openjdk.x86_64
```

python36 安装
```
yum install python36 python36-pip
```

flink分布式流处理框架/大数据处理
=====
下载安装
```
https://flink.apache.org/downloads.html
http://www.54tianzhisheng.cn/2019/01/13/Flink-JobManager-High-availability/

wget http://mirror.bit.edu.cn/apache/flink/flink-1.8.0/flink-1.8.0-bin-scala_2.12.tgz
tar -zxvf flink-1.8.0-bin-scala_2.12.tgz
cd flink-1.8.0/
```
一.Local模式
```
启动：./bin/start-cluster.sh
停止：./bin/stop-cluster.sh
```

SSH免密码登录
```
master 访问 slaves
ssh-keygen -b 2048 -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 authorized_keys
scp ~/.ssh/authorized_keys root@ip:~/.ssh/
相互访问
scp ~/.ssh/id_rsa root@ip:~/.ssh/
chmod 600 ~/.ssh/id_rsa
```

二.Standalone模式
```
https://ci.apache.org/projects/flink/flink-docs-release-1.6/ops/deployment/cluster_setup.html
准备3台服务器
10.0.0.1 master JobManager
10.0.0.2 slaves TaskManager
10.0.0.3 slaves TaskManager

vi conf/flink-conf.yaml
jobmanager.rpc.address: 10.0.0.1
vi conf/slaves
10.0.0.2
10.0.0.3

启动
ssh 10.0.0.1
bin/start-cluster.sh
打开http://10.0.0.1:8081可查看WEB界面

执行jps查看是否启动完成
错误日志文件：
log/flink-root-jobmanager*.log
log/flink-root-taskmanager*.log

添加一个 JobManager
bin/jobmanager.sh (start cluster)|stop|stop-all
添加一个 TaskManager
bin/taskmanager.sh start|stop|stop-all

conf/flink-conf.yaml 配置
jobmanager.rpc.port: 6123 #JobManager监听端口
jobmanager.heap.size: 1024m #JobManager 总共能使用的内存大小
taskmanager.heap.size: 1024m #TaskManager 总共能使用的内存大小
taskmanager.numberOfTaskSlots: 1 #每一台机器上能使用的CPU个数
parallelism.default: 1 #集群中的总CPU个数
rest.port: 8081 #WEB监听端口
rest.address: 0.0.0.0 #WEB监听IP
high-availability: zookeeper #高可用模式
high-availability.zookeeper.quorum: ip1:2181,ip2:2181 #一组 ZooKeeper 服务器，它提供分布式协调服务
high-availability.storageDir: hdfs:///flink/ha/ #高可用存储目录
vi conf/zoo.cfg #中配置 Zookeeper 服务
server.0=localhost:2888:3888
vi conf/masters #高可用模式启动多个masters
localhost:8081
localhost:8082
bin/start-zookeeper-quorum.sh #启动 ZooKeeper 集群

./bin/flink run -p 10 ../word-count.jar
```

blink
=====
git clone https://github.com/apache/flink.git
cd flink/
git checkout blink
yum install maven.noarch -y
mvn clean package -DskipTests

flink-libraries && maven install
flink-shaded-hadoop && maven install
flink-connectors && maven install
flink-yarn && maven install
flink-queryable-state && maven install
flink-filesystems && maven install
flink-metrics && maven install
flink-dist && maven install
flink-dist/target/flink-2.11.tar.gz

kafka分布式发布-订阅消息系统
=====
下载安装
```
http://kafka.apache.org/downloads
http://www.54tianzhisheng.cn/2018/01/04/Kafka/

wget http://mirror.bit.edu.cn/apache/kafka/2.2.0/kafka_2.12-2.2.0.tgz
tar -zxvf kafka_2.12-2.2.0.tgz
cd kafka_2.12-2.2.0/
```

启动
```
vi config/server.properties
broker.id=1
log.dir=/data/kafka/logs-1

启动zookeeper lsof -i:2181
./bin/zookeeper-server-start.sh -daemon config/zookeeper.properties
启动kafka
./bin/kafka-server-start.sh  config/server.properties
创建单分区单副本的 topic test
./bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test
查看 topic 列表
./bin/kafka-topics.sh --list --zookeeper localhost:2181
ERROR Unable to open socket to localhost/0:0:0:0:0:0:0:1:2181
vim /etc/hosts
将 host 里的
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
修改为：
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         ip6-localhost ip6-localhost.localdomain localhost6 localhost6.localdomain6
产生消息
./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
接收消息并在终端打印
./bin/kafka-console-consumer.sh --zookeeper localhost:2181 --topic test --from-beginning
查看描述 topics 信息
./bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic test
```

单机多broker 集群配置
```
cp config/server.properties config/server-2.properties
cp config/server.properties config/server-3.properties
vim config/server-2.properties
broker.id=2
listeners = PLAINTEXT://your.host.name:9093
log.dir=/data/kafka/logs-2
vim config/server-3.properties
broker.id=3
listeners = PLAINTEXT://your.host.name:9094
log.dir=/data/kafka/logs-3
启动Kafka服务：
./bin/kafka-server-start.sh config/server-2.properties &
./bin/kafka-server-start.sh config/server-3.properties &
```
多机多 broker 集群配置
```
分别在多个节点按上述方式安装 Kafka，配置启动多个 Zookeeper 实例。
假设三台机器 IP 地址是 ： 192.168.153.135， 192.168.153.136， 192.168.153.137
分别配置多个机器上的 Kafka 服务，设置不同的 broker id，zookeeper.connect 设置如下:
vim config/server.properties
zookeeper.connect=192.168.153.135:2181,192.168.153.136:2181,192.168.153.137:2181
创建一些种子数据开始测试：
echo -e "zhisheng\ntian" > test.txt
启动两个以独立模式运行的连接器
./bin/connect-standalone.sh  config/connect-standalone.properties config/connect-file-source.properties config/connect-file-sink.properties
创建两个连接器：第一个是源连接器，用于读取输入文件中的行，并将每个连接生成为 Kafka topic，第二个为连接器它从 Kafka topic 读取消息，并在输出文件中产生每行消息。
数据存储在 Kafka topic 中 connect-test，因此我们也可以运行控制台使用者来查看 topic 中的数据
./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic connect-test --from-beginning

```

ES/Kibana是一个开源的分析和可视化平台
=====
下载安装
```
https://www.elastic.co/cn/downloads/kibana
https://www.elastic.co/guide/en/kibana/current/settings.html
https://www.cnblogs.com/yiwangzhibujian/p/7137546.html
https://www.cnblogs.com/cjsblog/p/9476813.html
https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started.html

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.1.1-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.1.1-x86_64.rpm

tar -zvxf elasticsearch-7.1.1-linux-x86_64.tar.gz

./bin/elasticsearch
curl http://localhost:9200/

wget https://artifacts.elastic.co/downloads/kibana/kibana-7.1.1-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.1.1-x86_64.rpm

tar -zvxf kibana-7.1.1-linux-x86_64.tar.gz

./bin/kibana
http://localhost:5601
```

hadoop分布式计算平台:HDFS和MapReduce共同组成了Hadoop分布式系统体系结构的核心。HDFS在集群上实现分布式文件系统，MapReduce在集群上实现了分布式计算和任务处理
=====
修改机器名
```
hostname master
hostnamectl set-hostname master
或
vi /etc/hostname
vi /etc/sysconfig/network
HOSTNAME=master
vi /etc/hosts
10.0.0.1 master
10.0.0.2 salve1
10.0.0.3 salve2

shutdown -r now
```
下载安装
```
https://hadoop.apache.org/releases.html
http://blog.51yip.com/hadoop/2013.html

wget http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz
tar -zvxf hadoop-3.1.2.tar.gz
mv hadoop-3.1.2 hadoop
mkdir -p hadoop/{tmp,var,dfs}
mkdir -p hadoop/dfs/{name,data}
adduser hadoop
passwd hadoop
chown -R hadoop:hadoop hadoop
./bin/hadoop -version

vim /etc/profile
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export HADOOP_HOME=~/hadoop/
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
source /etc/profile

hadoop version
```
配置文件
```
cp -r hadoop hadoop_bak
hadoop/etc/hadoop/hadoop-env.sh #在JAVA_HOME=/usr/java/testing hdfs dfs -ls一行下面添加如下代码
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export HADOOP_HOME=~/hadoop/
export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export YARN_RESOURCEMANAGER_USER=root
export YARN_NODEMANAGER_USER=root
hadoop/etc/hadoop/yarn-env.sh
hadoop/etc/hadoop/slaves
salve1
salve2
hadoop/etc/hadoop/core-site.xml
hadoop/etc/hadoop/hdfs-site.xml
hadoop/etc/hadoop/mapred-site.xml
hadoop/etc/hadoop/yarn-site.xml #hadoop classpath 返回的值yarn.application.classpath
```
namenode执行初始化（master）
```
./bin/hadoop namenode -format
./sbin/start-all.sh
jps 检查NameNode是否启动

./bin/hdfs dfs -mkdir /test #创建测试目录
./bin/hdfs dfs -put ./etc/hadoop/*.xml /test/ #上传测试文件到hdfs
./bin/hadoop jar ./share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar grep /test/ ./output 'dfs[a-z.]+' #测试mapredure

./bin/hdfs namenode -format #格式化namenode
./sbin/start-dfs.sh #启动hdfs
./sbin/stop-dfs.sh #停止hdfs

http://10.0.0.1:8088/ #集群各节点任务分析工具
http://10.0.0.1:50070/ #健康检查工具
http://10.0.0.1:19888 #历史
```
datanode节点查看日志
```
cd hadoop/logs/userlogs

```

设置环境变量
```
su hadoop
vim /etc/profile
export $HADOOP_HOME=~/hadoop/
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_YARN_HOME=$HADOOP_HOME
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export CLASSPATH=.:$HADOOP_HOME/lib:$CLASSPATH
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
source /etc/profile
开启历史服务器
./mr-jobhistory-daemon.sh start historyserver
./yarn-daemon.sh start historyserver
```

其它工具
```
数据转换工具Sqoop
文件收集框架Flume
任务调度框架Oozie
大数据WEB工具Hue
```

zookeeper一个分布式的，开源的分布式应用程序协调服务，实现数据发布与订阅、负载均衡、命名服务、分布式协调与通知、集群管理、Leader选举、分布式锁、分布式队列等功能
=====
下载安装
```
http://zookeeper.apache.org/releases.html#download

wget http://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.5.5/apache-zookeeper-3.5.5.tar.gz
tar -zxvf apache-zookeeper-3.5.5.tar.gz
mv apache-zookeeper-3.5.5 zookeeper
mkdir -p zookeeper/{data,logs}
cd zookeeper
cp conf/zoo-sample.cfg conf/zoo.cfg
vi conf/zoo.cfg
# 用于存储zookeeper的数据文件
dataDir=~/zookeeper/data
# 用于存储zookeeper的日志文件
dataLogDir=~/zookeeper/logs
# 添加集群的服务器
server.0=master:2888:3888
server.1=salve1:2888:3888
server.2=salve2:2888:3888
clientPort=2181

master:
echo "0" > data/myid
./bin/zkServer.sh start #启动
./bin/zkCli.sh #CLI
./bin/zkServer.sh status #状态 status 显示是 “Mode: standalone" , 也就是单机模式；“Mode：leader“和“Mode : follower”，表示集群模式。
./bin/zkServer.sh stop #停止
salve1:
echo "1" > data/myid
./bin/zkServer.sh start
salve2:
echo "2" > data/myid
./bin/zkServer.sh start
```

storm是一个分布式的、高容错的实时计算系统
=====
下载安装
```
http://storm.apache.org/downloads.html

wget https://mirrors.tuna.tsinghua.edu.cn/apache/storm/apache-storm-2.0.0/apache-storm-2.0.0.tar.gz
tar -zxvf apache-storm-2.0.0.tar.gz
mv apache-storm-2.0.0 apache-storm
cd apache-storm

vim conf/storm.yaml
storm.zookeeper.servers:
 - "master"
 - "slave1"
 - "slave2"
#避免与该集群中安装的scala端口冲突，修改storm的ui端口为9090
storm.zookeeper.port: 2181 #不使用默认端口
ui.port: 9090
storm.local.dir: "~/apache-storm/data" #数据存储路径
nimbus.seeds: ["master"]

##配置节点健康检测
storm.health.check.dir: "healthchecks"
storm.health.check.timeout.ms: 5000
#storm.local.hostname: "master" #当前服务器主机名

#配置supervisor： 开启几个端口插槽，就开启几个对应的worker进程
supervisor.slots.ports:
 - 6700
 - 6701
 - 6702
 - 6703

vim /etc/profile
export STORM_HOME=~/apache-storm
export PATH=$PATH:$STORM_HOME/bin
source /etc/profile

master:
./bin/storm nimbus > /dev/null 2>&1 &
./bin/storm logviewer > /dev/null 2>&1 &
./bin/storm ui > /dev/null 2>&1 &
http://10.0.0.1:9090/
运行拓扑
./storm jar storm-book.jar com.TopologyMain /usr/words.txt
删除拓扑
./storm kill Getting-Started-Toplogie
slave1 & slave2:
./bin/storm supervisor > /dev/null 2>&1 &
./bin/storm logviewer > /dev/null 2>&1 &

jps 检查 zookeeper/supervisor/nimbus 是否开启
```

scala是一门多范式的编程语言，一种类似java的编程语言，设计初衷是实现可伸缩的语言、并集成面向对象编程和函数式编程的各种特性。
=====
下载安装
```
https://www.scala-lang.org/download/

wget https://downloads.lightbend.com/scala/2.12.8/scala-2.12.8.tgz
wget https://downloads.lightbend.com/scala/2.12.8/scala-2.12.8.rpm
tar -zxvf scala-2.12.8.tgz
mv scala-2.12.8 scala
cd scala

vim /etc/profile
export SCALA_HOME=~/scala
export PATH=$PATH:$SCALA_HOME/bin
source /etc/profile

```

spark是专为大规模数据处理而设计的快速通用的计算引擎
=====

下载安装
```
http://spark.apache.org/downloads.html

wget http://mirror.bit.edu.cn/apache/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz
tar -zxvf spark-2.4.3-bin-hadoop2.7.tgz
mv spark-2.4.3-bin-hadoop2.7 spark
cd spark

vim /etc/profile
export SPARK_HOME=~/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
source /etc/profile

cp conf/spark-env.sh.template conf/spark-env.sh
vim spark-env.sh
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export SCALA_HOME=~/scala
export SPARK_HOME=~/spark
export SPARK_MASTER_IP=master #spark集群的Master节点的ip地址
export SPARK_EXECUTOR_MEMORY=1G #每个worker节点能够最大分配给exectors的内存大小
export SPARK_WORKER_CORES=2 #每个worker节点所占有的CPU核数目
export SPARK_WORKER_INSTANCES=1 #每台机器上开启的worker节点的数目

cp conf/slaves.template conf/slaves
slave1
slave2

启动SPARK
./sbin/start-all.sh
./sbin/start-master.sh

http://10.0.0.1:8080/
jps 检查 Worker/Master 是否开启

启动客户端：
./bin/spark-shell

调用Spark自带的计算圆周率的Demo，执行下面的命令：
./bin/spark-submit --class org.apache.spark.examples.SparkPi --master local   examples/jars/spark-examples_2.11-2.1.1.jar

```

hive基于Hadoop的一个数据仓库工具，可以将结构化的数据文件映射为一张数据库表，并提供简单的sql查询功能，可以将sql语句转换为MapReduce任务进行运行
=====

下载安装
```
http://hive.apache.org/downloads.html

wget https://mirrors.tuna.tsinghua.edu.cn/apache/hive/hive-3.1.1/apache-hive-3.1.1-bin.tar.gz
tar -zxvf apache-hive-3.1.1-bin.tar.gz
mv apache-hive-3.1.1-bin hive
cd hive

vi /etc/profile
export HIVE_HOME=~/hive
export HIVE_CONF_DIR=$HIVE_HOME/conf
PATH=$PATH:$HIVE_HOME/bin
source /etc/profile

mysql创建metastore数据库并为其授权
create database metastore;
grant all on metastore.* to hive@'%' identified by 'hive';
grant all on metastore.* to hive@'localhost' identified by 'hive';
flush privileges;

cp conf/hive-default.xml.template conf/hive-site.xml
vim conf/hive-site.xml
<name>hive.metastore.warehouse.dir</name>
<value>/user/hive/warehouse</value>
cd $HADOOP_HOME #进入Hadoop主目录
./bin/hadoop fs -mkdir -p /user/hive/warehouse #创建目录
./bin/hadoop fs -chmod -R 777 /user/hive/warehouse #新建的目录赋予读写权限
./bin/hadoop fs -mkdir -p /tmp/hive/#新建/tmp/hive/目录
./bin/hadoop fs -chmod -R 777 /tmp/hive #目录赋予读写权限
#用以下命令检查目录是否创建成功
./bin/hadoop fs -ls /user/hive
./bin/hadoop fs -ls /tmp/hive

cp conf/hive-env.sh.template conf/hive-env.sh
vim hive-env.sh
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export HADOOP_HOME=~/hadoop
export HIVE_CONF_DIR=~/hive/conf
export HIVE_AUX_JARS_PATH=~/hive/lib

在hdfs 中创建下面的目录 ，并且授权
hdfs dfs -mkdir -p ~/hive/warehouse
hdfs dfs -mkdir -p ~/hive/tmp
hdfs dfs -mkdir -p ~/hive/log
hdfs dfs -chmod -R 777 ~/hive/warehouse
hdfs dfs -chmod -R 777 ~/hive/tmp
hdfs dfs -chmod -R 777 ~/hive/log

wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.16-1.el7.noarch.rpm
rpm -ivh mysql-connector-java-8.0.16-1.el7.noarch.rpm

cd $HIVE_HOME/bin
schematool -initSchema -dbType mysql
./hive #执行hive启动

nohup ./hiveserver2 &
启动beeline
beeline
!connect jdbc:hive2://localhost:10000 hive hive
show databases;

hive命令
show functions;
desc function sum;
create database reqdb;
use reqdb;
create table req(request_id bigint,message_type_id int,request_type int,creation_date string) row format delimited fields terminated by '\t\t\t';
load data local inpath '/var/lib/mysql-files/req.dat' into table sbux_nc_req;
select * from req;

mysql导出数据
select * into outfile '/var/lib/mysql-files/req.dat' fields terminated  by '\t\t\t' from req;

```

hbase分布式的、面向列的开源数据库
=====

下载安装
```
http://hbase.apache.org/downloads.html

wget http://mirrors.tuna.tsinghua.edu.cn/apache/hbase/2.1.4/hbase-2.1.4-bin.tar.gz
tar -zxvf hbase-2.1.4-bin.tar.gz
mv hbase-2.1.4-bin hbase
cd hbase

vi /etc/profile
export ZK_HOME=~/zookeeper
export HBASE_HOME=~/hbase
export PATH=$PATH:$HBASE_HOME/bin:$HBASE_HOME/sbin:$ZK_HOME/bin
source /etc/profile

vi conf/hbase-env.sh
export JAVA_HOME=/usr/lib/jvm/jre-openjdk
export HADOOP_HOME=~/hadoop
export HBASE_HOME=~/hbase
export HBASE_CLASSPATH=~/hadoop/etc/hadoop
export HBASE_PID_DIR=~/hbase/pids
export HBASE_LOG_DIR=~/hbase/logs
export HBASE_MANAGES_ZK=false
export TZ="Asia/Shanghai"

vi conf/hbase-site.xml

vi conf/regionservers
slave1
slave2

在启动hbase前，先启动zookeeper和hadoop
./bin/start-hbase.sh
./bin/stop-hbase.sh

./bin/hbase-daemon.sh start master
./bin/hbase-daemon.sh stop master
./bin/hbase-daemon.sh start regionserver
./bin/hbase-daemon.sh stop regionserver

./bin/hbase shell
status
list
disable 'test'
drop 'test'

http://master:16010/master-status
http://slave1:16030/rs-status
```

sqoop Hadoop和关系数据库服务器之间传送数据
=====
下载安装
```
http://sqoop.apache.org/

wget https://mirrors.tuna.tsinghua.edu.cn/apache/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
tar -zxvf sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
mv sqoop-1.4.7.bin__hadoop-2.6.0 sqoop
cd sqoop

vi /etc/profile
export SQOOP_HOME=~/sqoop
export PATH=$PATH:$SQOOP_HOME/bin

cp conf/sqoop-env-template.sh conf/sqoop-env.sh
export HADOOP_COMMON_HOME=~/hadoop
export HADOOP_MAPRED_HOME=~/hadoop
export HIVE_HOME=~/hive

sqoop-version
```

pulsar 消息队列环境
======
下载安装
```
https://pulsar.apache.org/docs/zh-CN/standalone/
https://juejin.im/post/5af414365188256717765441
https://www.infoq.cn/article/1UaxFKWUhUKTY1t_5gPq

需要安装JAVA1.8+PYTHON3环境 内存要求4G以上

wget https://archive.apache.org/dist/pulsar/pulsar-2.4.0/apache-pulsar-2.4.0-bin.tar.gz # 下载pulsar安装包
tar xvfz apache-pulsar-2.4.0-bin.tar.gz # 解压安装包
cd apache-pulsar-2.4.0 # 打开pulsar目录
bin/pulsar standalone  # 启动单机pulsar
pulsar-daemon start standalone
pulsar-daemon stop standalone

bin/pulsar-client consume my-topic -s "first-subscription"
bin/pulsar-client produce my-topic --messages "hello-pulsar" # 发送一条消息

pip3 install pulsar-client
```
测试代码：
```
创建Pulsar消费者监听python3程序 consumer.py
import pulsar
client = pulsar.Client('pulsar://localhost:6650')
consumer = client.subscribe('my-topic2', 'my-subscription')
while True:
    msg = consumer.receive()
    try:
        print("Received message '{}' id='{}'".format(msg.data(), msg.message_id()))
        consumer.acknowledge(msg)
    except:
        consumer.negative_acknowledge(msg)
client.close()

创建Pulsar生产者python3程序 producer.py
import pulsar
client = pulsar.Client('pulsar://localhost:6650')
producer = client.create_producer('my-topic2')
for i in range(10):
	producer.send(('Hello-%d' % i).encode('utf-8'))
client.close()
```

beam 是一个统一的编程框架，支持批处理和流处理
======
下载安装
```
https://beam.apache.org/get-started/downloads/#2150-2019-08-22
https://blog.csdn.net/qq_34777600/article/details/87165765
https://www.linuxidc.com/Linux/2018-09/154074.htm
https://www.infoq.cn/article/apache-beam-in-practice/
https://www.cnblogs.com/smartloli/p/6685106.html
https://blog.csdn.net/zjerryj/article/details/77970607

pip3 install apache-beam

单词出现的次数
from __future__ import print_function
import apache_beam as beam
from apache_beam.options.pipeline_options import PipelineOptions
with beam.Pipeline(options=PipelineOptions()) as p:
    lines = p | 'Create' >> beam.Create(['cat dog', 'snake cat', 'dog'])
    counts = (
        lines
        | 'Split' >> (beam.FlatMap(lambda x: x.split(' '))
                      .with_output_types(unicode))
        | 'PairWithOne' >> beam.Map(lambda x: (x, 1))
        | 'GroupAndSum' >> beam.CombinePerKey(sum)
    )
    counts | 'Print' >> beam.ParDo(lambda (w, c): print('%s: %s' % (w, c)))
```

solr
======

http://lucene.apache.org/solr/downloads.html
https://www.cnblogs.com/lsdb/p/9805347.html
https://blog.csdn.net/qq_28601235/article/details/72779386
https://www.iteblog.com/archives/2393.html

./solr start
./solr stop
http://localhost:8983/solr
# 创建core，-c指定创建的core名
./solr create -c test_core1
# 删除core，-c指定删除的core名
./solr delete -c test_core1
上传文件创建索引
./post -c test_core1 ../example/example

flume
======

https://www.mtyun.com/library/how-to-install-flume-on-centos7

wget http://mirrors.hust.edu.cn/apache/flume/1.9.0/apache-flume-1.9.0-bin.tar.gz
tar -zxvf apache-flume-1.9.0-bin.tar.gz
cd apache-flume-1.9.0
cp conf/flume-conf.properties.template conf/flume-conf.properties
mkdir -p /tmp/log/flume
bin/flume-ng agent --conf conf -f conf/flume-conf.properties -n agent&

Anaconda
======
```
yum install bzip2
wget https://repo.anaconda.com/archive/Anaconda3-5.3.1-Linux-x86_64.sh
wget https://repo.anaconda.com/archive/Anaconda2-2019.07-Linux-x86_64.sh

bash Anaconda3-5.3.1-Linux-x86_64.sh
bash Anaconda3-5.3.1-Linux-x86_64.sh -p /opt/anaconda3
source ~/.bashrc
```

JupyterLab
======
```
https://blog.csdn.net/jh0218/article/details/85104233
https://blog.csdn.net/sqq513/article/details/80028675
https://blog.csdn.net/weixin_41571493/article/details/88830458
https://blog.csdn.net/weixin_34112208/article/details/86261660

conda安装
conda install -c conda-forge jupyterhub
conda install -c conda-forge jupyterlab ipython

pip安装
python3 -m pip install jupyterhub
npm install -g configurable-http-proxy
pip3 install jupyterlab ipython

jupyterhub -h
configurable-http-proxy -h

生成配置文件
jupyter notebook --generate-config

生成配置文件
python3 -c 'from notebook.auth import passwd; print(passwd("usepassword"));'

然后生成一个自签名认证的key
openssl req -x509 -nodes -days 365 -newkey rsa:4096 -keyout jkey.key -out jcert.pem

修改配置文件
vim ~/.jupyter/jupyter_notebook_config.py
c.NotebookApp.allow_root = True
# 设定ip访问，允许任意ip访问
c.NotebookApp.ip = '0.0.0.0'
# 不打开浏览器
c.NotebookApp.open_browser = False
# 用于访问的端口，设定一个不用的端口即可，这里设置为7000
c.NotebookApp.port = 7000
# 设置登录密码， 将刚刚复制的内容替换此处的xxx
c.NotebookApp.password = 'sha1:<your-sha1-hash-value>'
# 设置jupyter的工作路径
c.NotebookApp.notebook_dir = '/xxx/jupyter'
c.NotebookApp.certfile = '/home/user/jcert.pem'
c.NotebookApp.keyfile = '/home/user/jkey.key'

Jupyter Lab 插件安装
jupyter labextension install @jupyterlab/toc
jupyter labextension list
jupyter lab
Settings --> Advanced Settings Editor -> Extension Manager -> enabled=true

启动
jupyter notebook

```

KNIME一款强大开源的数据挖掘软件平台
======
```
https://www.knime.com/knime-analytics-platform
https://www.cnblogs.com/luweiseu/p/8487225.html
```

CockroachDB 是基于事务性和一致性键值存储而构建的分布式 SQL 数据库
=======
http://doc.cockroachchina.baidu.com
http://doc.cockroachchina.baidu.com/#quick-start/install-cockorachdb/

TiDB 是一款兼容 MySQL、支持混合事务和分析处理（HTAP）的分布式数据库
=====
https://blog.csdn.net/wjl7813/article/details/79044231
https://www.jianshu.com/p/21dc274fe5ad

Vitess 是通过分片实现 MySQL 水平扩展的数据库集群系统
======
https://www.cnblogs.com/davygeek/p/6433296.html

git clone https://github.com/youtube/vitess.git
cd src/github.com/youtube/vitess

kubectl/minikube

YugaByte DB 结合了分布式 ACID 事务、多区域部署、对 Cassandra 和 Redis API 的支持，对 PostgreSQL 的支持即将推出
=====

Neo4j 图形数据库在处理相关性网络的任务时，执行速度比 SQL 和 NoSQL 数据库更快，但图模型和 Cypher 查询语言需要进行专门的学习
=====

Pravega 分布式流存储
http://pravega.io/docs/latest/getting-started/
https://github.com/pravega/pravega



