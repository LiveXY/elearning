#!/bin/bash

list=$(redis-cli --scan --pattern $1)
for key in $list; do
	redis-cli unlink $key
	echo $key
done
