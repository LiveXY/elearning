#!/bin/sh

redis-cli -p 6880 shutdown
redis-cli -p 6881 shutdown
redis-cli -p 6882 shutdown
redis-cli -p 6883 shutdown
redis-cli -p 6884 shutdown
redis-cli -p 6885 shutdown

sleep 1
ps aux | grep redis | grep -v grep
