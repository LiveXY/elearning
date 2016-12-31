mysql修改表引擎
==========

38w-153/170w-259/110w-147/130w-170

```mysql
#查看表用的是什么引擎
select table_name,`engine` from information_schema.tables where table_schema = 'db';

#查看所有没有使用innodb引擎的表 按数据量排序
select table_name,`engine`,table_rows,avg_row_length,data_length,index_length,table_collation
from information_schema.tables
where table_schema = 'db' and engine != 'InnoDB'
order by table_rows asc;

#批量生成修改表引擎
select concat('alert table `db`.`', table_name, '` engine = InnoDB ;')
from information_schema.tables
where table_schema = 'db' and engine <> 'InnoDB';
order by table_rows asc

#查看表是否有主键
select distinct
	concat(t.table_schema,'.',t.table_name) as tbl,
	t.engine,
	if(isnull(c.constraint_name),'NOPK','') as nopk,
	if(s.index_type = 'FULLTEXT','FULLTEXT','') as ftidx,
	if(s.index_type = 'SPATIAL','SPATIAL','') as gisidx
from information_schema.tables as t
left join information_schema.key_column_usage as c on (t.table_schema = c.constraint_schema and t.table_name = c.table_name and c.constraint_name = 'PRIMARY')
left join information_schema.statistics as s on (t.table_schema = s.table_schema and t.table_name = s.table_name and s.index_type in ('FULLTEXT','SPATIAL'))
where t.table_schema not in ('information_schema','performance_schema','mysql') and t.table_type = 'BASE TABLE' and (t.engine <> 'InnoDB' or c.constraint_name is null or s.index_type in ('FULLTEXT','SPATIAL'))
order by t.table_schema,t.table_name;

#修改表引擎
vi /usr/bin/mysql_convert_table_format
$opt_engine = "InnoDB";
mysql_convert_table_format db --user='root' --password='123456' --socket='/var/lib/mysql/mysql.sock' --verbose

#表数据大小
select
     table_schema as `Database`,
     table_name AS `Table`,
     round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB`
from information_schema.TABLES
order by (data_length + index_length) desc;
```