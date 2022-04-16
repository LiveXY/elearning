#!/bin/sh

redis-cli -p 6880 set key `date +%Y%m%d%H%M%S`
redis-cli -p 6880 get key
redis-cli -p 6881 get key
redis-cli -p 6882 get key

redis-cli -p 6880 del key
redis-cli -p 6880 get key
redis-cli -p 6881 get key
redis-cli -p 6882 get key

#redis-cli -p 6881 DEBUG sleep 60
#redis-cli -p 26880 sentinel master mymaster
