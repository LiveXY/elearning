#!/bin/sh

if [ -f ../redis-server ]; then
    version=$(../redis-server -v | cut -f 2 -d '=' | cut -f 1 -d ' ')
    if [ x"$version" \< x"5.0" ]; then
        echo "redis版本太低"
        exit 1
    fi
else
    version=$(redis-server -v | cut -f 2 -d '=' | cut -f 1 -d ' ')
    if [ x"$version" \< x"5.0" ]; then
        echo "redis版本太低"
        exit 1
    fi
fi
mkdir -p ./data

echo "启动redis-server"
if [ -f ../redis-server ]; then
    ../redis-server ./redis-6880.conf
    ../redis-server ./redis-6881.conf
    ../redis-server ./redis-6882.conf
    ../redis-server ./redis-6883.conf
    ../redis-server ./redis-6884.conf
    ../redis-server ./redis-6885.conf
else
    redis-server ./redis-6880.conf
    redis-server ./redis-6881.conf
    redis-server ./redis-6882.conf
    redis-server ./redis-6883.conf
    redis-server ./redis-6884.conf
    redis-server ./redis-6885.conf
fi

sleep 1
echo "查看redis-server进程"
ps aux | grep redis-server | grep -v grep

if [ -f ../redis-server ]; then
    check=$(../redis-cli --cluster check 127.0.0.1:6880 | grep 'Not all 16384 slots are covered by nodes' | grep -v grep)
    if [ "$check" ]; then
        echo "创建集群"
        ../redis-cli --cluster create 127.0.0.1:6880 127.0.0.1:6881 127.0.0.1:6882 127.0.0.1:6883 127.0.0.1:6884 127.0.0.1:6885 --cluster-replicas 1
    fi
    echo "检查集群"
    ../redis-cli --cluster check 127.0.0.1:6880
else
    check=$(redis-cli --cluster check 127.0.0.1:6880 | grep 'Not all 16384 slots are covered by nodes' | grep -v grep)
    if [ "$check" ]; then
        echo "创建集群"
        redis-cli --cluster create 127.0.0.1:6880 127.0.0.1:6881 127.0.0.1:6882 127.0.0.1:6883 127.0.0.1:6884 127.0.0.1:6885 --cluster-replicas 1
    fi
    echo "检查集群"
    redis-cli --cluster check 127.0.0.1:6880
fi
