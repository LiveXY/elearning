#!/bin/sh

echo "6880 主节点写数据，其它节点读数据"
redis-cli -c -p 6880 set key `date +%Y%m%d%H%M%S`
redis-cli -c -p 6880 get key
redis-cli -c -p 6881 get key
redis-cli -c -p 6882 get key
redis-cli -c -p 6883 get key
redis-cli -c -p 6884 get key
redis-cli -c -p 6885 get key

echo "6885 从节点写数据，其它节点读数据"
redis-cli -c -p 6885 set key `date +%Y%m%d%H%M%S2`
redis-cli -c -p 6880 get key
redis-cli -c -p 6881 get key
redis-cli -c -p 6882 get key
redis-cli -c -p 6883 get key
redis-cli -c -p 6884 get key
redis-cli -c -p 6885 get key

echo "6884 从节点删除数据，其它节点读数据"
redis-cli -c -p 6884 del key
redis-cli -c -p 6880 get key
redis-cli -c -p 6881 get key
redis-cli -c -p 6882 get key
redis-cli -c -p 6883 get key
redis-cli -c -p 6884 get key
redis-cli -c -p 6885 get key

#redis-cli -p 6881 DEBUG sleep 60
#redis-cli -p 26880 sentinel master mymaster
