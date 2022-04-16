#!/bin/sh

echo "启动redis-server"
redis-server ./localhost-master/redis-6880.conf
redis-server ./localhost-slave1/redis-6881.conf
redis-server ./localhost-slave2/redis-6882.conf
sleep 1
echo "查看redis-server进程"
ps aux | grep redis-server | grep -v grep

echo "查看master"
redis-cli -p 6880 info Replication | head -n 5 | tail -n 4
echo "查看slave1"
redis-cli -p 6881 info Replication | head -n 5 | tail -n 4
echo "查看slave2"
redis-cli -p 6882 info Replication | head -n 5 | tail -n 4

echo "启动redis-sentinel"
redis-sentinel ./localhost-master/redis-sentinel-26880.conf
redis-sentinel ./localhost-slave1/redis-sentinel-26881.conf
redis-sentinel ./localhost-slave2/redis-sentinel-26882.conf
sleep 1
echo "查看redis-sentinel进程"
ps aux | grep redis-sentinel | grep -v grep

#redis-cli -p 26880 sentinel master mymaster
#redis-cli -p 26880 sentinel replicas mymaster
#redis-cli -p 26880 sentinel sentinels mymaster

