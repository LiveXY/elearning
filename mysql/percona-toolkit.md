Percona Toolkit
==========

yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm
https://www.percona.com/downloads/percona-toolkit/LATEST/
https://downloads.percona.com/downloads/percona-toolkit/3.4.0/binary/redhat/7/x86_64/percona-toolkit-3.4.0-3.el7.x86_64.rpm
yum install percona-toolkit

依赖
yum install perl-TermReadKey
yum install perl-DBI
yum install perl-DBD-MySQL
yum install perl-Time-HiRes
yum install perl-IO-Socket-SSL

pt-online-schema-change --charset=utf8mb4 --no-version-check --user=root --password=123456 --host=127.0.0.1  P=3306,D=dbname,t=tablename --alter "ADD COLUMN column1 tinyint(4) DEFAULT '0'" --execute
"MODIFY COLUMN num int(11) unsigned NOT NULL DEFAULT '0'"
"CHANGE COLUMN num address varchar(30) NOT NULL DEFAULT ''"
"ADD INDEX idx_address(address)"
"DROP COLUMN num"
"ALTER column age SET DEFAULT 100"
"ADD COLUMN column1 tinyint(4) DEFAULT '0',ADD COLUMN column2 tinyint(4) DEFAULT '0'"
pt-online-schema-change --socket=/tmp/mysql3310.sock --user=root --password=****  D=dbosc,t=tbosc --alter "add column stunum int "  --recursion-method=none --no-check-replication-filters --alter-foreign-keys-method auto --print --execute

pt-query-digest --help
pt-query-digest slow.log
pt-query-digest --processlist h=host1
使用tcppdump捕获MySQL协议数据，然后报告最慢的查询
tcpdump -s 65535 -x -nn -q -tttt -i any -c 1000 port 3306 > mysql.tcp.txt
pt-query-digest --type tcpdump mysql.tcp.txt
pt-query-digest --review h=host2 --no-report slow.log
pt-query-digest test2-slow.log --no-report --output slowlog --filter '$event->{fingerprint} && make_checksum($event->{fingerprint}) eq "6F7A87D11DDD9CC608CCACD1427CD832"'

pt-kill
pt-kill --busy-time 60 --kill #kill掉执行时间超过60s的query
pt-kill --busy-time 60 --print
pt-kill --host=192.168.56.103 --user=root --password=111111 --port=3306 --busy-time 15   --match-user="nice|dbuser01|dbuser02" --victim all --interval 1 --kill  --pid=/tmp/ptkill.pid --print --log=/home/pt-kill.log
pt-kill --host=192.168.56.103 --user=root --password=111111 --port=3306 --busy-time 15 --match-command="query|Execute" --victim all --interval 1 --kill --daemonize --pid=/tmp/ptkill.pid --print --log=/home/pt-kill.log
pt-kill --host=192.168.56.103 --user=root --password=111111 --port=3306  --busy-time 15 --match-state="Locked | Sending data" --victim all --interval 1 --kill --daemonize --pid=/tmp/ptkill.pid --print --log=/home/pt-kill.log
pt-kill --host=192.168.56.103 --user=root --password=111111 --port=3306 --busy-time 15 --match-info="SELECT | DELETE" --victim all --interval 1 --kill --daemonize --pid=/tmp/ptkill.pid --print --log=/home/pt-kill.log


