#!/bin/sh

mysqlH="ip"
mysqlU="test"
mysqlP="test"
mysqlDB="qcloud"

currPath=$(pwd)
bakPath="$currPath/$mysqlDB"

#昨天
yesterday=$(php -r "date_default_timezone_set('Asia/Shanghai');echo date('Ymd', strtotime('-1 day', time()));")
yesterdaySI=$(php -r "date_default_timezone_set('Asia/Shanghai');echo strtotime($yesterday);")
yesterdayEI=$(php -r "date_default_timezone_set('Asia/Shanghai');echo strtotime($yesterday)+86400;")
yesterdaySS=$(php -r "date_default_timezone_set('Asia/Shanghai');echo date('Y-m-d H:i:s', strtotime($yesterday));")
yesterdayES=$(php -r "date_default_timezone_set('Asia/Shanghai');echo date('Y-m-d H:i:s', strtotime($yesterday)+86400);")

#2个月之前
deleteD=$(php -r "date_default_timezone_set('Asia/Shanghai');echo date('Ymd', strtotime('-2 month', time()));")
deleteDI=$(php -r "date_default_timezone_set('Asia/Shanghai');echo strtotime($deleteD);")
deleteDS=$(php -r "date_default_timezone_set('Asia/Shanghai');echo date('Y-m-d H:i:s', strtotime($deleteD));")

mkdir -p "$bakPath"

backup_table_data() {
	echo "=====backup=$1==============================================="
	echo "正在备份：$mysqlDB $yesterday $1 $2"

	filePath="$bakPath/$1_$yesterday.log"
	`mysqldump qcloud -h $mysqlH -u$mysqlU -p$mysqlP --no-create-info --tables $1 --where="$2" > "$filePath"`
	ret=$?
	if [ $ret -eq 0 ]; then
		echo "备份文件成功！$mysqlDB/$1_$yesterday.log"

		cd "$bakPath"
		if [ -f "$1_$yesterday.zip" ]; then
			rm -f "$1_$yesterday.zip"
		fi
		zip "$1_$yesterday.zip" "$1_$yesterday.log"
		if [ -f "$1_$yesterday.zip" ]; then
			rm -f "$1_$yesterday.log"
			echo "压缩备份文件成功！$mysqlDB/$1_$yesterday.zip"
		fi
	else
		echo '备份失败！'
	fi
	echo ''
}

delete_table_data(){
	echo "=====delete=$1================================================="
	echo "删除：$mysqlDB $deleteD $1 $2"
	`mysql -h $mysqlH -u$mysqlU -p$mysqlP -e "use $mysqlDB; delete from $1 where $2;"`
	ret=$?
	if [ $ret -eq 0 ]; then
		echo "删除数据成功！"
	else
		echo '删除数据失败！'
	fi
	echo ''
}

clear
#backup
backup_table_data "yly_member" "uid=0"
backup_table_data "log_user_golds" "ltime>='$yesterdaySS' and ltime<'$yesterdayES'"

#delete
delete_table_data "log_user_golds" "ltime<'$deleteDS'"

echo "=====end=================================================================="

