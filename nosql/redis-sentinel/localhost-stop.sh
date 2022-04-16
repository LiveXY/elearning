#!/bin/sh

killall redis-server redis-sentinel
sleep 1
ps aux | grep redis | grep -v grep
