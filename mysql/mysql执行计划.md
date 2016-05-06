mysql执行计划
==========

```mysql
show variables like 'event_scheduler';
set global event_scheduler = 1;

alter event event_report_minute_online on completion preserve enable; -- 开启事件
alter event event_report_minute_online on completion preserve disable; -- 关闭事件

drop event if exists event_report_minute_online;
create event event_report_minute_online
on schedule every 1 minute
on completion preserve enable
do call crontab_report_minute_online();

on schedule at current_timestamp + interval 5 day -- 5 天后
on schedule at timestamp '2007-07-20 12:00:00' -- 2007 年 7 月 20 日 12 点
on schedule every 1 day starts '2007-07-20 12:00:00' -- 2007 年 7 月 20 日 12 点 begin evenday
on schedule every 1 day starts current_timestamp + interval 5 day -- 5 天后开启每天定时
on schedule every 1 day ends current_timestamp + interval 5 day -- 每天定时， 5天后停止执行
on schedule every 1 day starts current_timestamp + interval 5 day ends current_timestamp + interval 1 month -- 5天后开启每天定时，一个月后停止执行
on schedule every 1 day on completion not preserve -- 每天定时执行 ( 只执行一次，任务完成后就终止该事件 ) 
on schedule every 9 day starts now() -- 从现在开始每隔九天定时执行
on schedule every 1 month starts date_add(date_add(date_sub(curdate(),interval day(curdate())-1 day), interval 1 month),interval 1 hour) -- 每个月的一号凌晨1 点执行
on schedule every 1 quarter starts date_add(date_add(date(concat(year(curdate()),'-',elt(quarter(curdate()),1,4,7,10),'-',1)),interval 1 quarter),interval 2 hour) -- 每个季度一号的凌晨2点执行 
on schedule every 1 year starts date_add(date(concat(year(curdate()) + 1,'-',1,'-',1)),interval 4 hour) -- 每年1月1号凌晨四点执行

-- year | quarter | month | day | hour | minute | week | second | year_month | day_hour | day_minute | day_second | hour_minute | hour_second | minute_second
```