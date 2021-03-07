SET STATISTICS IO ON
SET STATISTICS TIME ON
SET SHOWPLAN_ALL ON

dbo.SP_LOCKINFO 0,1
dbo.SP_LOCKINFO 1,1

--查看SQL执行时间
SET STATISTICS PROFILE ON
SET STATISTICS IO ON
SET STATISTICS TIME ON
GO
select * from TC_ExamPaperResultDetail where ResultID>1220 and ResultID<10000
GO
SET STATISTICS PROFILE OFF
SET STATISTICS IO OFF
SET STATISTICS TIME OFF

select name from master.dbo.sysdatabases
SELECT table_name FROM information_schema.tables
select name from dbo.sysobjects where xtype='U'

-- 发EMAIL
msdb.dbo.sp_send_dbmail
	@recipients='cexo255@163.com',
	@body=N'这是测试邮件',
	@subject=N'这是测试邮件内容',
	@body_format='HTML'

-- CPU的使用状况
select top 50 total_worker_time/1000 as [总耗CPU时间(MS)],
	execution_count [执行次数],
	qs.total_worker_time/qs.execution_count/1000 as [平均耗CPU时间(MS)],
	SUBSTRING(
		qt.text,
		qs.statement_start_offset/2+1, (
			case when qs.statement_end_offset=-1 then datalength(qt.text)
			else qs.statement_end_offset end - qs.statement_start_offset
		)/2 + 1
	) as [使用CPU语法],
	qt.text [完整语法],
	qt.dbid, dbname = DB_NAME(qt.dbid),
	qt.objectid, OBJECT_NAME(qt.objectid, qt.dbid) ObjectName
from sys.dm_exec_query_stats qs cross apply sys.dm_exec_sql_text(qs.sql_handle) as qt
where DB_NAME(qt.dbid) is not null and DB_NAME(qt.dbid)!=N'msdb'
order by total_worker_time/execution_count desc

-- 显示锁定与被锁定间的链状关系
select t1.resource_type as [资源锁定类型],
	DB_NAME(resource_database_id) as [数据库名],
	t1.resource_associated_entity_id as [锁定的对像],
	t1.request_mode as [等待者需求的锁定类型],
	t1.request_session_id as [等待者SID],
	t2.wait_duration_ms as [等待时间],(
		select text
		from sys.dm_exec_requests as r cross apply sys.dm_exec_sql_text(r.sql_handle)
		where r.session_id=t1.request_session_id
	) as [等待者要执行的批处理],(
		select SUBSTRING(qt.text, r.statement_start_offset/2+1, (
			case when r.statement_end_offset=-1 then DATALENGTH(qt.text)
			else r.statement_end_offset end - r.statement_start_offset
		)/2+1)
		from sys.dm_exec_requests as r cross apply sys.dm_exec_sql_text(r.sql_handle) as qt
		where r.session_id=t1.request_session_id
	) as [等待者正要执行的语法]
from sys.dm_tran_locks as t1, sys.dm_os_waiting_tasks as t2
where t1.lock_owner_address=t2.resource_address

-- 观察硬盘I/O
select DB_NAME(i.database_id) db,
	name,
	physical_name,
	io_stall [用户等待文件完成I/O的总时间(MS)],
	io_type [I/O要求的类型],
	io_pending_ms_ticks [个别I/O在队列(Pending queue)等待的总时间]
from sys.dm_io_virtual_file_stats(null, null) i
join sys.dm_io_pending_io_requests as p on i.file_handle=p.io_handle
join sys.master_files m on m.database_id=i.database_id and m.file_id=i.file_id

-- 查询最消耗I/O资源的SQL语法
select total_logical_reads/execution_count as [平均逻辑读取次数],
	total_logical_writes/execution_count as [平均逻辑写入次数],
	total_physical_reads/execution_count as [平均物理读取次数],
	execution_count as [执行次数],
	SUBSTRING(qt.text, r.statement_start_offset/2 + 1, (
		case when r.statement_end_offset = -1 then DATALENGTH(qt.text)
		else r.statement_end_offset end - r.statement_start_offset
	)/2 + 1) as [执行语法]
from sys.dm_exec_query_stats as r cross apply sys.dm_exec_sql_text(r.sql_handle) as qt
order by (total_logical_reads+total_logical_writes) desc

--SQL语句执行时间
SELECT
      total_cpu_time,
      total_execution_count,
      number_of_statements,
      s2.text
      --(SELECT SUBSTRING(s2.text, statement_start_offset / 2, ((CASE WHEN statement_end_offset = -1 THEN (LEN(CONVERT(NVARCHAR(MAX), s2.text)) * 2) ELSE statement_end_offset END) - statement_start_offset) / 2) ) AS query_text
FROM
      (SELECT TOP 100
            SUM(qs.total_worker_time) AS total_cpu_time,
            SUM(qs.execution_count) AS total_execution_count,
            COUNT(*) AS  number_of_statements,
            qs.sql_handle --,
            --MIN(statement_start_offset) AS statement_start_offset,
            --MAX(statement_end_offset) AS statement_end_offset
      FROM
            sys.dm_exec_query_stats AS qs
      GROUP BY qs.sql_handle
      ORDER BY SUM(qs.total_worker_time) DESC) AS stats
      CROSS APPLY sys.dm_exec_sql_text(stats.sql_handle) AS s2

--CPU 平均占用率最高的前 50 个 SQL 语句。
SELECT TOP 50
total_worker_time/execution_count AS [Avg CPU Time],
(SELECT SUBSTRING(text,statement_start_offset/2,(CASE WHEN statement_end_offset = -1 then LEN(CONVERT(nvarchar(max), text)) * 2 ELSE statement_end_offset end -statement_start_offset)/2) FROM sys.dm_exec_sql_text(sql_handle)) AS query_text, *
FROM sys.dm_exec_query_stats
ORDER BY [Avg CPU Time] DESC

--不能存在没有主键的表
SELECT name FROM sys.tables
EXCEPT
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'

--不能存在允许空的字段
select TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION, COLUMN_DEFAULT
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME in (select name from sysobjects where type = 'U')
and IS_NULLABLE='YES'

--碎片
SELECT  DB_NAME(ps.database_id) AS '数据库名', OBJECT_NAME(ps.OBJECT_ID) AS '表名',
        b.name as '索引名', ps.index_id as '索引ID', fill_factor as '填充因子',
        ps.avg_fragmentation_in_percent as '碎片率'
FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS ps
        INNER JOIN sys.indexes AS b ON ps.OBJECT_ID = b.OBJECT_ID AND ps.index_id = b.index_id
--WHERE   ps.database_id = DB_ID('Traingo.LMS_test')
ORDER BY ps.avg_fragmentation_in_percent DESC
-- >30重建索引
SELECT  'alter index all on ' + OBJECT_NAME(ps.OBJECT_ID) + ' rebuild;', ps.avg_fragmentation_in_percent
FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS ps
        INNER JOIN sys.indexes AS b ON ps.OBJECT_ID = b.OBJECT_ID AND ps.index_id = b.index_id
WHERE   ps.avg_fragmentation_in_percent > 30
ORDER BY ps.avg_fragmentation_in_percent DESC

create procedure [dbo].[clearDBFragmentation](@dbname varchar(100)) as
begin
  declare @@execSql nvarchar(max), @@execSql2 nvarchar(max)

  set @@execSql = '
    use [' + @dbname + '];
    select table_schema + ''.'' + object_name(ps.object_id) 表名, round(ps.avg_fragmentation_in_percent, 0) 碎片率, b.name as 索引名
    from sys.dm_db_index_physical_stats(db_id(), null, null, null, null) as ps 
    inner join sys.indexes as b on ps.OBJECT_ID = b.OBJECT_ID and ps.index_id = b.index_id 
    inner join information_schema.tables as c on c.table_name=object_name(ps.object_id)
    where ps.avg_fragmentation_in_percent > 50
    order by ps.avg_fragmentation_in_percent desc'
  exec(@@execSql);

  set @@execSql = '
    use [' + @dbname + '];
    (select @execSql2=stuff((
      select distinct ''alter index all on '' + table_schema + ''.'' + object_name(ps.object_id) + '' rebuild;'' 
      from sys.dm_db_index_physical_stats(db_id(), null, null, null, null) as ps 
      inner join sys.indexes as b on ps.OBJECT_ID = b.OBJECT_ID and ps.index_id = b.index_id 
      inner join information_schema.tables as c on c.table_name=object_name(ps.object_id)
      where ps.avg_fragmentation_in_percent > 50
    FOR xml path('''')) , 1 , 0 , ''''))'
  exec sp_executesql @@execSql, N'@execSql2 nvarchar(max) out', @@execSql2 out
  if @@execSql2 is not null begin
    set @@execSql = 'use [' + @dbname + '];' + @@execSql2
    exec(@@execSql);
    print @dbname + '=>' + ltrim(str(@@error)) + '=>' + @@execSql
  end
end
create procedure [dbo].[clearAllDBFragmentation] as
begin
  declare @@dbname varchar(200)
  declare @@dbs int, @@i int
  if object_id(N'tempdb..#all_databases',N'U') is null begin
    create table #all_databases([id] [INT] identity(1,1) not null, [dbname] varchar(255) not null);
  end

  truncate table #all_databases
  insert into #all_databases(dbname)
  select name from master.dbo.sysdatabases where name not in ('master', 'model', 'msdb', 'tempdb')

  set @@dbs = (select max(id) from #all_databases)
  set @@i=1
  while @@i<=@@dbs
  begin
    set @@dbname = (select dbname from #all_databases where id=@@i)
    print @@dbname
    exec clearDBFragmentation @@dbname
    set @@i=@@i+1
  end
end
exec clearAllDBFragmentation


--重建索引
--avg_fragmentation_in_percent >5% and <=30%： 重组索引（ALTER INDEX REORGANIZE）；
ALTER INDEX ALL ON Employee REORGANIZE
--avg_fragmentation_in_percent >30%： 重建索引（ALTER INDEX REBUILD）；
ALTER INDEX ALL ON Employee REBUILD
-- partition=all with (FILLFACTOR = 80, ONLINE = OFF, DATA_COMPRESSION = PAGE )
-- WITH (FILLFACTOR = 60, SORT_IN_TEMPDB = ON,STATISTICS_NORECOMPUTE = ON);
dbcc showconfig('LMS_RewardIntegralLog')
dbcc dbreindex('LMS_RewardIntegralLog', '', 80)
dbcc indexdefrag('LMS_RewardIntegralLog', '', 80)
dbcc cleantable('LMS_RewardIntegralLog', '')

--缺失索引
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT TOP 20
  ROUND(s.avg_total_user_cost * s.avg_user_impact * (s.user_seeks + s.user_scans),0) AS [Total Cost]
  , d.[statement] AS [Table Name]
  , equality_columns
  , inequality_columns
  , included_columns
FROM sys.dm_db_missing_index_groups g INNER JOIN sys.dm_db_missing_index_group_stats s ON s.group_handle = g.index_group_handle
  INNER JOIN sys.dm_db_missing_index_details d ON d.index_handle = g.index_handle
ORDER BY [Total Cost] DESC

--没有用的索引
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
  DB_NAME() AS DatabaseName
  , SCHEMA_NAME(o.Schema_ID) AS SchemaName
  , OBJECT_NAME(s.[object_id]) AS TableName
  , i.name AS IndexName
  , s.user_updates
  , s.system_seeks + s.system_scans + s.system_lookups AS [System usage]
  INTO #TempUnusedIndexes
FROM sys.dm_db_index_usage_stats s INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
  INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE 1=2

--表记录数量
SELECT A.NAME ,B.ROWS FROM sysobjects A JOIN sysindexes B ON A.id = B.id WHERE A.xtype = 'U' AND B.indid IN(0,1) ORDER BY B.ROWS DESC
--表记录数量2
create table #tb(表名 sysname,记录数 int ,保留空间 varchar(10),使用空间 varchar(10),索引使用空间 varchar(10),未用空间 varchar(10))
truncate table #tb
insert into #tb exec sp_MSForEachTable 'EXEC sp_spaceused ''?'''
select * from #tb order by 记录数 desc
select * from #tb order by cast(replace(使用空间,'KB','') as int) desc


--查看数据库大小
Exec master.dbo.xp_fixeddrives -- 剩余空间
Exec sp_spaceused
dbcc sqlperf(logspace) with no_infomsgs
select name, convert(float,size) * (8192.0/1024.0)/1024. from dbo.sysfiles
insert into dbo.DbLogSize execute('dbcc sqlperf(logspace) with no_infomsgs')

SELECT DB_NAME(database_id) AS DatabaseName, Name AS Logical_Name, (size*8)/1024 SizeMB, Physical_Name
FROM sys.master_files where DB_NAME(database_id) not in ('master', 'model', 'msdb', 'tempdb')
  and right(Physical_Name, 4)='.ldf'
order by SizeMB desc

清理LOG
create procedure [dbo].[clearDBLog](@dbname varchar(100)) as
begin
  declare @@execSql varchar(max)
  set @@execSql = '
    select db_name(database_id) 数据库, Name 逻辑文件, (size*8)/1024 大小M, Physical_Name 物理文件
    from sys.master_files where DB_NAME(database_id) = ''' + @dbname + ''''
  exec(@@execSql)
  set @@execSql = '
    alter database [' + @dbname + '] set recovery simple with no_wait;
    alter database [' + @dbname + '] set recovery simple;
    dbcc shrinkdatabase([' + @dbname + '], 1, truncateonly);
    alter database [' + @dbname + '] set recovery full with no_wait;
    alter database [' + @dbname + '] set recovery full;'
  exec(@@execSql)
  print @dbname + '=>' + ltrim(str(@@error))
  if @@error<>0 begin
    set @@execSql = '
      alter database [' + @dbname + '] set recovery full with no_wait;
      alter database [' + @dbname + '] set recovery full;'
    exec(@@execSql)
  end
end
exec clearDBLog 'Traingo.LY_test'
create procedure [dbo].[clearAllDBLog] as
begin
  declare @@dbname varchar(200)
  declare @@dbs int, @@i int
  if object_id(N'tempdb..#all_databases',N'U') is null begin
    create table #all_databases([id] [INT] identity(1,1) not null, [dbname] varchar(255) not null);
  end

  truncate table #all_databases
  insert into #all_databases(dbname)
  select distinct DB_NAME(database_id)
  from sys.master_files where DB_NAME(database_id) not in ('master', 'model', 'msdb', 'tempdb')
  and right(Physical_Name, 4)='.ldf' and size>1024*1024/8

  set @@dbs = (select max(id) from #all_databases)
  set @@i=1
  while @@i<=@@dbs
  begin
    set @@dbname = (select dbname from #all_databases where id=@@i)
    --select @@dbname
    exec clearDBLog @@dbname
    set @@i=@@i+1
  end
end
exec clearAllDBLog

--显示用于找出过多编译/重新编译的 DMV 查询。
select * from sys.dm_exec_query_optimizer_info
where
      counter = 'optimizations'
      or counter = 'elapsed time'

--显示已重新编译的前 25 个存储过程。plan_generation_num 指示该查询已重新编译的次数。
select top 25
      sql_text.text,
      sql_handle,
      plan_generation_num,
      execution_count,
      dbid,
      objectid
from sys.dm_exec_query_stats a
      cross apply sys.dm_exec_sql_text(sql_handle) as sql_text
where plan_generation_num > 1
order by plan_generation_num desc

--显示哪个查询占用了最多的 CPU 累计使用率。
SELECT
    highest_cpu_queries.plan_handle,
    highest_cpu_queries.total_worker_time,
    q.dbid,
    q.objectid,
    q.number,
    q.encrypted,
    q.[text]
from
    (select top 50
        qs.plan_handle,
        qs.total_worker_time
    from
        sys.dm_exec_query_stats qs
    order by qs.total_worker_time desc) as highest_cpu_queries
    cross apply sys.dm_exec_sql_text(plan_handle) as q
order by highest_cpu_queries.total_worker_time desc

--显示一些可能占用大量 CPU 使用率的运算符（例如 ‘%Hash Match%’、‘%Sort%’）以找出可疑对象。
select *
from
      sys.dm_exec_cached_plans
      cross apply sys.dm_exec_query_plan(plan_handle)
where
      cast(query_plan as nvarchar(max)) like '%Sort%'
      or cast(query_plan as nvarchar(max)) like '%Hash Match%'


内存瓶颈
开始内存压力检测和调查之前，请确保已启用 SQL Server 中的高级选项。请先对 master 数据库运行以下查询以启用此选项。
sp_configure 'show advanced options'
go
sp_configure 'show advanced options', 1
go
reconfigure
go
首先运行以下查询以检查内存相关配置选项。
sp_configure 'awe_enabled'
go
sp_configure 'min server memory'
go
sp_configure 'max server memory'
go
sp_configure 'min memory per query'
go
sp_configure 'query wait'
go
运行下面的 DMV 查询以查看 CPU、计划程序内存和缓冲池信息。
select
	cpu_count,
	hyperthread_ratio,
	scheduler_count,
	physical_memory_in_bytes / 1024 / 1024 as physical_memory_mb,
	virtual_memory_in_bytes / 1024 / 1024 as virtual_memory_mb,
	bpool_committed * 8 / 1024 as bpool_committed_mb,
	bpool_commit_target * 8 / 1024 as bpool_target_mb,
	bpool_visible * 8 / 1024 as bpool_visible_mb
from sys.dm_os_sys_info

I/O 瓶颈
检查闩锁等待统计信息以确定 I/O 瓶颈。运行下面的 DMV 查询以查找 I/O 闩锁等待统计信息。
select wait_type, waiting_tasks_count, wait_time_ms, signal_wait_time_ms, wait_time_ms / waiting_tasks_count
from sys.dm_os_wait_stats
where wait_type like 'PAGEIOLATCH%'  and waiting_tasks_count > 0
order by wait_type

如果 waiting_task_counts 和 wait_time_ms 与正常情况相比有显著变化，则可以确定存在 I/O 问题。获取 SQL Server 平稳运行时性能计数器和主要 DMV 查询输出的基线非常重要。
这些 wait_types 可以指示您的 I/O 子系统是否遇到瓶颈。
使用以下 DMV 查询来查找当前挂起的 I/O 请求。请定期执行此查询以检查 I/O 子系统的运行状况，并隔离 I/O 瓶颈中涉及的物理磁盘。
select
	database_id,
	file_id,
	io_stall,
	io_pending_ms_ticks,
	scheduler_address
from  sys.dm_io_virtual_file_stats(NULL, NULL)t1,
	sys.dm_io_pending_io_requests as t2
where t1.file_handle = t2.io_handle

在正常情况下，该查询通常不返回任何内容。如果此查询返回一些行，则需要进一步调查。
您还可以执行下面的 DMV 查询以查找 I/O 相关查询。
select top 5 (total_logical_reads/execution_count) as avg_logical_reads,
	(total_logical_writes/execution_count) as avg_logical_writes,
	(total_physical_reads/execution_count) as avg_physical_reads,
	Execution_count, statement_start_offset, p.query_plan, q.text
from sys.dm_exec_query_stats
	cross apply sys.dm_exec_query_plan(plan_handle) p
	cross apply sys.dm_exec_sql_text(plan_handle) as q
order by (total_logical_reads + total_logical_writes)/execution_count Desc

下面的 DMV 查询可用于查找哪些批处理/请求生成的 I/O 最多。如下所示的 DMV 查询可用于查找可生成最多 I/O 的前五个请求。调整这些查询将提高系统性能。
select top 5
    (total_logical_reads/execution_count) as avg_logical_reads,
    (total_logical_writes/execution_count) as avg_logical_writes,
    (total_physical_reads/execution_count) as avg_phys_reads,
     Execution_count,
    statement_start_offset as stmt_start_offset,
    sql_handle,
    plan_handle
from sys.dm_exec_query_stats
order by  (total_logical_reads + total_logical_writes) Desc
阻塞
运行下面的查询可确定阻塞的会话。
select blocking_session_id, wait_duration_ms, session_id
from sys.dm_os_waiting_tasks
where blocking_session_id is not null
使用此调用可找出 blocking_session_id 所返回的 SQL。例如，如果 blocking_session_id 是 87，则运行此查询可获得相应的 SQL。
dbcc INPUTBUFFER(87)
下面的查询显示 SQL 等待分析和前 10 个等待的资源。
select top 10 *
from sys.dm_os_wait_stats
--where wait_type not in ('CLR_SEMAPHORE','LAZYWRITER_SLEEP','RESOURCE_QUEUE','SLEEP_TASK','SLEEP_SYSTEMTASK','WAITFOR')
order by wait_time_ms desc
若要找出哪个 spid 正在阻塞另一个 spid，可在数据库中创建以下存储过程，然后执行该存储过程。此存储过程会报告此阻塞情况。键入 sp_who 可找出 @spid；@spid 是可选参数。
create proc dbo.sp_block (@spid bigint=NULL)
as
select
    t1.resource_type,
    'database'=db_name(resource_database_id),
    'blk object' = t1.resource_associated_entity_id,
    t1.request_mode,
    t1.request_session_id,
    t2.blocking_session_id
from
    sys.dm_tran_locks as t1,
    sys.dm_os_waiting_tasks as t2
where
    t1.lock_owner_address = t2.resource_address and
    t1.request_session_id = isnull(@spid,t1.request_session_id)
以下是使用此存储过程的示例。
exec sp_block
exec sp_block @spid = 7

--查看和清理死锁存贮过程
CREATE PROC [dbo].[SP_LOCKINFO](
@KILL_LOCK_SPID BIT = 1,                --是否杀掉死锁的进程,1 杀掉, 0 仅显示
@SHOW_SPID_IF_NOLOCK BIT = 1
) AS           --如果没有死锁的进程,是否显示正常进程信息,1 显示,0 不显示

SET NOCOUNT ON
DECLARE @COUNT     INT,
        @S         NVARCHAR(1000),
        @I         INT

SELECT ID=IDENTITY(INT,1,1),
       标志,
       进程ID=SPID,
       线程ID=KPID,
       块进程ID=BLOCKED,
       数据库ID=DBID,
       数据库名=DB_NAME(DBID),
       用户ID=UID,
       用户名=LOGINAME,
       累计CPU时间=CPU,
       登陆时间=LOGIN_TIME,打开事务数=OPEN_TRAN,
       进程状态=STATUS,
       工作站名=HOSTNAME,
       应用程序名=PROGRAM_NAME,
       工作站进程ID=HOSTPROCESS,
       域名=NT_DOMAIN,
       网卡地址=NET_ADDRESS

INTO #T FROM(
        SELECT 标志='死锁的进程',
                SPID,KPID,A.BLOCKED,DBID,UID,LOGINAME,CPU,LOGIN_TIME,OPEN_TRAN,
                STATUS,HOSTNAME,PROGRAM_NAME,HOSTPROCESS,NT_DOMAIN,NET_ADDRESS,
                S1=A.SPID,S2=0
                FROM MASTER..SYSPROCESSES A JOIN (
                SELECT BLOCKED FROM MASTER..SYSPROCESSES GROUP BY BLOCKED
                )B ON A.SPID=B.BLOCKED WHERE A.BLOCKED=0
        UNION ALL
        SELECT '|_牺牲品_>',
                SPID,KPID,BLOCKED,DBID,UID,LOGINAME,CPU,LOGIN_TIME,OPEN_TRAN,
                STATUS,HOSTNAME,PROGRAM_NAME,HOSTPROCESS,NT_DOMAIN,NET_ADDRESS,
                S1=BLOCKED,S2=1
        FROM MASTER..SYSPROCESSES A WHERE BLOCKED<>0
)A ORDER BY S1,S2

SELECT @COUNT=@@ROWCOUNT,@I=1

IF @COUNT=0 AND @SHOW_SPID_IF_NOLOCK=1
BEGIN
        INSERT #T
        SELECT 标志='正常的进程',
                SPID,KPID,BLOCKED,DBID,DB_NAME(DBID),UID,LOGINAME,CPU,LOGIN_TIME,
                OPEN_TRAN,STATUS,HOSTNAME,PROGRAM_NAME,HOSTPROCESS,NT_DOMAIN,NET_ADDRESS
        FROM MASTER..SYSPROCESSES
        SET @COUNT=@@ROWCOUNT
END

IF @COUNT>0
BEGIN
        CREATE TABLE #T1(ID INT IDENTITY(1,1),A NVARCHAR(30),B INT,EVENTINFO NVARCHAR(4000))
        IF @KILL_LOCK_SPID=1
              BEGIN
                     DECLARE @SPID VARCHAR(10),@标志 VARCHAR(10)
                     WHILE @I<=@COUNT
                     BEGIN
                            SELECT @SPID=进程ID,@标志=标志 FROM #T WHERE ID=@I
                            INSERT #T1 EXEC('DBCC INPUTBUFFER('+@SPID+')')
                            IF @@ROWCOUNT=0 INSERT #T1(A) VALUES(NULL)
                            IF @标志='死锁的进程' EXEC('KILL '+@SPID)
                            SET @I=@I+1
                     END
              END
        ELSE
                WHILE @I<=@COUNT
                BEGIN
                        SELECT @S='DBCC INPUTBUFFER('+CAST(进程ID AS VARCHAR)+')' FROM #T WHERE ID=@I
                        INSERT #T1 EXEC(@S)
                        IF @@ROWCOUNT=0 INSERT #T1(A) VALUES(NULL)
                        SET @I=@I+1
                END
        SELECT 进程的SQL语句=B.EVENTINFO,A.*
        FROM #T A JOIN #T1 B ON A.ID=B.ID
        where 进程状态<>'sleeping' and B.EVENTINFO is not null
        ORDER BY 进程的SQL语句 desc
END


EXEC sp_MSForEachDB 'USE [?];
INSERT INTO #TempUnusedIndexes
SELECT TOP 20
	DB_NAME() AS DatabaseName
	, SCHEMA_NAME(o.Schema_ID) AS SchemaName
	, OBJECT_NAME(s.[object_id]) AS TableName
	, i.name AS IndexName
	, s.user_updates
	, s.system_seeks + s.system_scans + s.system_lookups AS [System usage]
FROM sys.dm_db_index_usage_stats s INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
	INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE s.database_id = DB_ID()
	AND OBJECTPROPERTY(s.[object_id], ''IsMsShipped'') = 0
	AND s.user_seeks = 0 AND s.user_scans = 0 AND s.user_lookups = 0 AND i.name IS NOT NULL
ORDER BY s.user_updates DESC'
SELECT TOP 20 * FROM #TempUnusedIndexes ORDER BY [user_updates] DESC
DROP TABLE #TempUnusedIndexes


查看连接当前数据库的SPID所加的锁
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT DB_NAME(resource_database_id) AS DatabaseName
	, request_session_id
	, resource_type
	, CASE WHEN resource_type = 'OBJECT' THEN OBJECT_NAME(resource_associated_entity_id)
		WHEN resource_type IN ('KEY', 'PAGE', 'RID') THEN (
			SELECT OBJECT_NAME(OBJECT_ID)
			FROM sys.partitions p
			WHERE p.hobt_id = l.resource_associated_entity_id)
		END AS resource_type_name
	, request_status
	, request_mode
FROM sys.dm_tran_locks l
WHERE request_session_id !=@@spid
ORDER BY request_session_id
如果像查看更多的锁，调整where条件即可

查看没关闭事务的空闲Session
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT es.session_id, es.login_name, es.host_name, est.text
  , cn.last_read, cn.last_write, es.program_name
FROM sys.dm_exec_sessions es
INNER JOIN sys.dm_tran_session_transactions st ON es.session_id = st.session_id
INNER JOIN sys.dm_exec_connections cn ON es.session_id = cn.session_id
CROSS APPLY sys.dm_exec_sql_text(cn.most_recent_sql_handle) est
LEFT OUTER JOIN sys.dm_exec_requests er ON st.session_id = er.session_id AND er.session_id IS NULL

查看被阻塞的语句和它们的等待时间
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
  Waits.wait_duration_ms / 1000 AS WaitInSeconds
  , Blocking.session_id as BlockingSessionId
  , DB_NAME(Blocked.database_id) AS DatabaseName
  , Sess.login_name AS BlockingUser
  , Sess.host_name AS BlockingLocation
  , BlockingSQL.text AS BlockingSQL
  , Blocked.session_id AS BlockedSessionId
  , BlockedSess.login_name AS BlockedUser
  , BlockedSess.host_name AS BlockedLocation
  , BlockedSQL.text AS BlockedSQL
  , SUBSTRING (BlockedSQL.text, (BlockedReq.statement_start_offset/2) + 1,
    ((CASE WHEN BlockedReq.statement_end_offset = -1
      THEN LEN(CONVERT(NVARCHAR(MAX), BlockedSQL.text)) * 2
      ELSE BlockedReq.statement_end_offset
      END - BlockedReq.statement_start_offset)/2) + 1)
                    AS [Blocked Individual Query]
  , Waits.wait_type
FROM sys.dm_exec_connections AS Blocking
INNER JOIN sys.dm_exec_requests AS Blocked ON Blocking.session_id = Blocked.blocking_session_id
INNER JOIN sys.dm_exec_sessions Sess ON Blocking.session_id = sess.session_id
INNER JOIN sys.dm_tran_session_transactions st ON Blocking.session_id = st.session_id
LEFT OUTER JOIN sys.dm_exec_requests er ON st.session_id = er.session_id AND er.session_id IS NULL
INNER JOIN sys.dm_os_waiting_tasks AS Waits ON Blocked.session_id = Waits.session_id
CROSS APPLY sys.dm_exec_sql_text(Blocking.most_recent_sql_handle) AS BlockingSQL
INNER JOIN sys.dm_exec_requests AS BlockedReq ON Waits.session_id = BlockedReq.session_id
INNER JOIN sys.dm_exec_sessions AS BlockedSess ON Waits.session_id = BlockedSess.session_id
CROSS APPLY sys.dm_exec_sql_text(Blocked.sql_handle) AS BlockedSQL
ORDER BY WaitInSeconds

查看超过30秒等待的查询
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
	Waits.wait_duration_ms / 1000 AS WaitInSeconds
	, Blocking.session_id as BlockingSessionId
	, Sess.login_name AS BlockingUser
	, Sess.host_name AS BlockingLocation
	, BlockingSQL.text AS BlockingSQL
	, Blocked.session_id AS BlockedSessionId
	, BlockedSess.login_name AS BlockedUser
	, BlockedSess.host_name AS BlockedLocation
	, BlockedSQL.text AS BlockedSQL
	, DB_NAME(Blocked.database_id) AS DatabaseName
FROM sys.dm_exec_connections AS Blocking
INNER JOIN sys.dm_exec_requests AS Blocked ON Blocking.session_id = Blocked.blocking_session_id
INNER JOIN sys.dm_exec_sessions Sess ON Blocking.session_id = sess.session_id
INNER JOIN sys.dm_tran_session_transactions st ON Blocking.session_id = st.session_id
LEFT OUTER JOIN sys.dm_exec_requests er ON st.session_id = er.session_id AND er.session_id IS NULL
INNER JOIN sys.dm_os_waiting_tasks AS Waits ON Blocked.session_id = Waits.session_id
CROSS APPLY sys.dm_exec_sql_text(Blocking.most_recent_sql_handle) AS BlockingSQL
INNER JOIN sys.dm_exec_requests AS BlockedReq ON Waits.session_id = BlockedReq.session_id
INNER JOIN sys.dm_exec_sessions AS BlockedSess ON Waits.session_id = BlockedSess.session_id
CROSS APPLY sys.dm_exec_sql_text(Blocked.sql_handle) AS BlockedSQL
WHERE Waits.wait_duration_ms > 30000
ORDER BY WaitInSeconds

buffer中缓存每个数据库所占的buffer
SET TRAN ISOLATION LEVEL READ UNCOMMITTED
SELECT
    ISNULL(DB_NAME(database_id), 'ResourceDb') AS DatabaseName
    , CAST(COUNT(row_count) * 8.0 / (1024.0) AS DECIMAL(28,2)) AS [Size (MB)]
FROM sys.dm_os_buffer_descriptors
GROUP BY database_id
ORDER BY DatabaseName

当前数据库中每个表所占缓存的大小和页数
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
     OBJECT_NAME(p.[object_id]) AS [TableName]
     , (COUNT(*) * 8) / 1024   AS [Buffer size(MB)]
     , ISNULL(i.name, '-- HEAP --') AS ObjectName
     ,  COUNT(*) AS NumberOf8KPages
FROM sys.allocation_units AS a
INNER JOIN sys.dm_os_buffer_descriptors AS b ON a.allocation_unit_id = b.allocation_unit_id
INNER JOIN sys.partitions AS p
INNER JOIN sys.indexes i ON p.index_id = i.index_id AND p.[object_id] = i.[object_id] ON a.container_id = p.hobt_id
WHERE b.database_id = DB_ID() AND p.[object_id] > 100
GROUP BY p.[object_id], i.name
ORDER BY NumberOf8KPages DESC

数据库级别等待的IO
SET TRAN ISOLATION LEVEL READ UNCOMMITTED
SELECT DB_NAME(database_id) AS [DatabaseName]
	, SUM(CAST(io_stall / 1000.0 AS DECIMAL(20,2))) AS [IO stall (secs)]
	, SUM(CAST(num_of_bytes_read / 1024.0 / 1024.0 AS DECIMAL(20,2))) AS [IO read (MB)]
	, SUM(CAST(num_of_bytes_written / 1024.0 / 1024.0  AS DECIMAL(20,2))) AS [IO written (MB)]
	, SUM(CAST((num_of_bytes_read + num_of_bytes_written) / 1024.0 / 1024.0 AS DECIMAL(20,2))) AS [TotalIO (MB)]
FROM sys.dm_io_virtual_file_stats(NULL, NULL)
GROUP BY database_id
ORDER BY [IO stall (secs)] DESC

按文件查看IO情况
SET TRAN ISOLATION LEVEL READ UNCOMMITTED
SELECT DB_NAME(database_id) AS [DatabaseName]
	, file_id
	, SUM(CAST(io_stall / 1000.0 AS DECIMAL(20,2))) AS [IO stall (secs)]
	, SUM(CAST(num_of_bytes_read / 1024.0 / 1024.0 AS DECIMAL(20,2))) AS [IO read (MB)]
	, SUM(CAST(num_of_bytes_written / 1024.0 / 1024.0  AS DECIMAL(20,2))) AS [IO written (MB)]
	, SUM(CAST((num_of_bytes_read + num_of_bytes_written) / 1024.0 / 1024.0 AS DECIMAL(20,2))) AS [TotalIO (MB)]
FROM sys.dm_io_virtual_file_stats(NULL, NULL)
GROUP BY database_id, file_id
ORDER BY [IO stall (secs)] DESC

查看被缓存的查询计划
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT TOP 20
    st.text AS [SQL]
    , cp.cacheobjtype
    , cp.objtype
    , COALESCE(DB_NAME(st.dbid), DB_NAME(CAST(pa.value AS INT))+'*', 'Resource') AS [DatabaseName]
    , cp.usecounts AS [Plan usage]
    , qp.query_plan
FROM sys.dm_exec_cached_plans cp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
CROSS APPLY sys.dm_exec_query_plan(cp.plan_handle) qp
OUTER APPLY sys.dm_exec_plan_attributes(cp.plan_handle) pa
WHERE pa.attribute = 'dbid' AND st.text LIKE '%这里是查询语句包含的内容%'
可以根据查询字段来根据关键字查看缓冲的查询计划。

查看某一查询是如何使用查询计划的
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT TOP 20
	SUBSTRING (qt.text,(qs.statement_start_offset/2) + 1,
	((CASE WHEN qs.statement_end_offset = -1
		THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
		ELSE qs.statement_end_offset
	END - qs.statement_start_offset)/2) + 1) AS [Individual Query]
	, qt.text AS [Parent Query]
	, DB_NAME(qt.dbid) AS DatabaseName
	, qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE SUBSTRING (qt.text,(qs.statement_start_offset/2) + 1,
  ((CASE WHEN qs.statement_end_offset = -1
    THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
    ELSE qs.statement_end_offset
    END - qs.statement_start_offset)/2) + 1)
LIKE '%指定查询包含的字段%'

查看数据库中跑的最慢的前20个查询以及它们的执行计划
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT TOP 20
	CAST(qs.total_elapsed_time / 1000000.0 AS DECIMAL(28, 2)) AS [Total Duration (s)]
	, CAST(qs.total_worker_time * 100.0 / qs.total_elapsed_time AS DECIMAL(28, 2)) AS [% CPU]
	, CAST((qs.total_elapsed_time - qs.total_worker_time)* 100.0 / qs.total_elapsed_time AS DECIMAL(28, 2)) AS [% Waiting]
	, qs.execution_count
	, CAST(qs.total_elapsed_time / 1000000.0 / qs.execution_count AS DECIMAL(28, 2)) AS [Average Duration (s)]
	, SUBSTRING (qt.text,(qs.statement_start_offset/2) + 1,
	((CASE WHEN qs.statement_end_offset = -1
	  THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
	  ELSE qs.statement_end_offset
	  END - qs.statement_start_offset)/2) + 1) AS [Individual Query
	, qt.text AS [Parent Query]
	, DB_NAME(qt.dbid) AS DatabaseName
	, qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE qs.total_elapsed_time > 0
ORDER BY qs.total_elapsed_time DESC

查看数据库中哪个查询最耗费资源有助于你解决问题

被阻塞时间最长的前20个查询以及它们的执行计划
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT TOP 20
	CAST((qs.total_elapsed_time - qs.total_worker_time) /  1000000.0 AS DECIMAL(28,2)) AS [Total time blocked (s)]
	, CAST(qs.total_worker_time * 100.0 / qs.total_elapsed_time AS DECIMAL(28,2)) AS [% CPU]
	, CAST((qs.total_elapsed_time - qs.total_worker_time)* 100.0 / qs.total_elapsed_time AS DECIMAL(28, 2)) AS [% Waiting]
	, qs.execution_count
	, CAST((qs.total_elapsed_time  - qs.total_worker_time) / 1000000.0  / qs.execution_count AS DECIMAL(28, 2)) AS [Blocking average (s)]
	, SUBSTRING (qt.text,(qs.statement_start_offset/2) + 1,
	((CASE WHEN qs.statement_end_offset = -1
	THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
	ELSE qs.statement_end_offset
	END - qs.statement_start_offset)/2) + 1) AS [Individual Query]
	, qt.text AS [Parent Query]
	, DB_NAME(qt.dbid) AS DatabaseName
	, qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE qs.total_elapsed_time > 0
ORDER BY [Total time blocked (s)] DESC
找出这类查询也是数据库调优的必须品

最耗费CPU的前20个查询以及它们的执行计划
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT TOP 20
	CAST((qs.total_worker_time) / 1000000.0 AS DECIMAL(28,2)) AS [Total CPU time (s)]
	, CAST(qs.total_worker_time * 100.0 / qs.total_elapsed_time AS DECIMAL(28,2)) AS [% CPU]
	, CAST((qs.total_elapsed_time - qs.total_worker_time)* 100.0 / qs.total_elapsed_time AS DECIMAL(28, 2)) AS [% Waiting]
	, qs.execution_count
	, CAST((qs.total_worker_time) / 1000000.0 / qs.execution_count AS DECIMAL(28, 2)) AS [CPU time average (s)]
	, SUBSTRING (qt.text,(qs.statement_start_offset/2) + 1,
	((CASE WHEN qs.statement_end_offset = -1
	  THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
	  ELSE qs.statement_end_offset
	  END - qs.statement_start_offset)/2) + 1) AS [Individual Query]
	, qt.text AS [Parent Query]
	, DB_NAME(qt.dbid) AS DatabaseName
	, qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
WHERE qs.total_elapsed_time > 0
ORDER BY [Total CPU time (s)] DESC


最占IO的前20个查询以及它们的执行计划
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT TOP 20
	[Total IO] = (qs.total_logical_reads + qs.total_logical_writes)
	, [Average IO] = (qs.total_logical_reads + qs.total_logical_writes) / qs.execution_count
	, qs.execution_count
	, SUBSTRING (qt.text,(qs.statement_start_offset/2) + 1,
	((CASE WHEN qs.statement_end_offset = -1
	THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
	ELSE qs.statement_end_offset
	END - qs.statement_start_offset)/2) + 1) AS [Individual Query]
	, qt.text AS [Parent Query]
	, DB_NAME(qt.dbid) AS DatabaseName
	, qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY [Total IO] DESC

能帮助找出占IO的查询
查找被执行次数最多的查询以及它们的执行计划
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT TOP 20
    qs.execution_count
    , SUBSTRING (qt.text,(qs.statement_start_offset/2) + 1,
    ((CASE WHEN qs.statement_end_offset = -1
      THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2
      ELSE qs.statement_end_offset
      END - qs.statement_start_offset)/2) + 1) AS [Individual Query]
    , qt.text AS [Parent Query]
    , DB_NAME(qt.dbid) AS DatabaseName
    , qp.query_plan
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
ORDER BY qs.execution_count DESC;
可以针对用的最多的查询语句做特定优化。

特定语句的最后运行时间
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT DISTINCT TOP 20
    qs.last_execution_time
    , qt.text AS [Parent Query]
    , DB_NAME(qt.dbid) AS DatabaseName
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) as qt
WHERE qt.text LIKE '%特定语句的部分%'
ORDER BY qs.last_execution_time DESC

查看那些被大量更新，却很少被使用的索引
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    DB_NAME() AS DatabaseName
    , SCHEMA_NAME(o.Schema_ID) AS SchemaName
    , OBJECT_NAME(s.[object_id]) AS TableName
    , i.name AS IndexName
    , s.user_updates
    , s.system_seeks + s.system_scans + s.system_lookups AS [System usage]
	INTO #TempUnusedIndexes
FROM   sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE 1=2

EXEC sp_MSForEachDB 'USE [?];
INSERT INTO #TempUnusedIndexes
SELECT TOP 20
    DB_NAME() AS DatabaseName
    , SCHEMA_NAME(o.Schema_ID) AS SchemaName
    , OBJECT_NAME(s.[object_id]) AS TableName
    , i.name AS IndexName
    , s.user_updates
    , s.system_seeks + s.system_scans + s.system_lookups AS [System usage]
FROM   sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE s.database_id = DB_ID()
	AND OBJECTPROPERTY(s.[object_id], ''IsMsShipped'') = 0
	AND s.user_seeks = 0 AND s.user_scans = 0  AND s.user_lookups = 0
	AND i.name IS NOT NULL
ORDER BY s.user_updates DESC'
SELECT TOP 20 * FROM #TempUnusedIndexes ORDER BY [user_updates] DESC
DROP TABLE #TempUnusedIndexes
这类索引应该被Drop掉


最高维护代价的索引
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    DB_NAME() AS DatabaseName
    , SCHEMA_NAME(o.Schema_ID) AS SchemaName
    , OBJECT_NAME(s.[object_id]) AS TableName
    , i.name AS IndexName
    , (s.user_updates ) AS [update usage]
    , (s.user_seeks + s.user_scans + s.user_lookups) AS [Retrieval usage]
    , (s.user_updates) -
      (s.user_seeks + s.user_scans + s.user_lookups) AS [Maintenance cost]
    , s.system_seeks + s.system_scans + s.system_lookups AS [System usage]
    , s.last_user_seek
    , s.last_user_scan
    , s.last_user_lookup
INTO #TempMaintenanceCost
FROM   sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON  s.[object_id] = i.[object_id]
    AND s.index_id = i.index_id
INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE 1=2
EXEC sp_MSForEachDB 'USE [?];
INSERT INTO #TempMaintenanceCost
SELECT TOP 20
    DB_NAME() AS DatabaseName
    , SCHEMA_NAME(o.Schema_ID) AS SchemaName
    , OBJECT_NAME(s.[object_id]) AS TableName
    , i.name AS IndexName
    , (s.user_updates ) AS [update usage]
    , (s.user_seeks + s.user_scans + s.user_lookups) AS [Retrieval usage]
    , (s.user_updates) - (s.user_seeks + user_scans + s.user_lookups) AS [Maintenance cost]
    , s.system_seeks + s.system_scans + s.system_lookups AS [System usage]
    , s.last_user_seek
    , s.last_user_scan
    , s.last_user_lookup
FROM   sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id]
    AND s.index_id = i.index_id
INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE s.database_id = DB_ID()
    AND i.name IS NOT NULL
    AND OBJECTPROPERTY(s.[object_id], ''IsMsShipped'') = 0
    AND (s.user_seeks + s.user_scans + s.user_lookups) > 0
ORDER BY [Maintenance cost] DESC'
SELECT top 20 * FROM #TempMaintenanceCost ORDER BY [Maintenance cost] DESC
DROP TABLE #TempMaintenanceCost
Maintenance cost高的应该被Drop掉

使用频繁的索引
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    DB_NAME() AS DatabaseName
    , SCHEMA_NAME(o.Schema_ID) AS SchemaName
    , OBJECT_NAME(s.[object_id]) AS TableName
    , i.name AS IndexName
    , (s.user_seeks + s.user_scans + s.user_lookups) AS [Usage]
    , s.user_updates
    , i.fill_factor
INTO #TempUsage
FROM sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id]
    AND s.index_id = i.index_id
INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE 1=2
EXEC sp_MSForEachDB 'USE [?];
INSERT INTO #TempUsage
SELECT TOP 20
    DB_NAME() AS DatabaseName
    , SCHEMA_NAME(o.Schema_ID) AS SchemaName
    , OBJECT_NAME(s.[object_id]) AS TableName
    , i.name AS IndexName
    , (s.user_seeks + s.user_scans + s.user_lookups) AS [Usage]
    , s.user_updates
    , i.fill_factor
FROM   sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE s.database_id = DB_ID()
    AND i.name IS NOT NULL
    AND OBJECTPROPERTY(s.[object_id], ''IsMsShipped'') = 0
ORDER BY [Usage] DESC'
SELECT TOP 20 * FROM #TempUsage ORDER BY [Usage] DESC
DROP TABLE #TempUsage
这类索引需要格外注意，不要在优化的时候干掉

碎片最多的索引
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    DB_NAME() AS DatbaseName
    , SCHEMA_NAME(o.Schema_ID) AS SchemaName
    , OBJECT_NAME(s.[object_id]) AS TableName
    , i.name AS IndexName
    , ROUND(s.avg_fragmentation_in_percent,2) AS [Fragmentation %]
INTO #TempFragmentation
FROM sys.dm_db_index_physical_stats(db_id(),null, null, null, null) s
INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE 1=2
EXEC sp_MSForEachDB 'USE [?];
INSERT INTO #TempFragmentation
SELECT TOP 20
    DB_NAME() AS DatbaseName
    , SCHEMA_NAME(o.Schema_ID) AS SchemaName
    , OBJECT_NAME(s.[object_id]) AS TableName
    , i.name AS IndexName
    , ROUND(s.avg_fragmentation_in_percent,2) AS [Fragmentation %]
FROM sys.dm_db_index_physical_stats(db_id(),null, null, null, null) s
INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id] AND s.index_id = i.index_id
INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE s.database_id = DB_ID()
  AND i.name IS NOT NULL
  AND OBJECTPROPERTY(s.[object_id], ''IsMsShipped'') = 0
ORDER BY [Fragmentation %] DESC'
SELECT top 20 * FROM #TempFragmentation ORDER BY [Fragmentation %] DESC
DROP TABLE #TempFragmentation
这类索引需要Rebuild,否则会严重拖累数据库性能

自上次SQL Server重启后，找出完全没有使用的索引
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    DB_NAME() AS DatbaseName
    , SCHEMA_NAME(O.Schema_ID) AS SchemaName
    , OBJECT_NAME(I.object_id) AS TableName
    , I.name AS IndexName
INTO #TempNeverUsedIndexes
FROM sys.indexes I INNER JOIN sys.objects O ON I.object_id = O.object_id
WHERE 1=2
EXEC sp_MSForEachDB 'USE [?];
INSERT INTO #TempNeverUsedIndexes
SELECT
    DB_NAME() AS DatbaseName
    , SCHEMA_NAME(O.Schema_ID) AS SchemaName
    , OBJECT_NAME(I.object_id) AS TableName
    , I.NAME AS IndexName
FROM sys.indexes I INNER JOIN sys.objects O ON I.object_id = O.object_id
LEFT OUTER JOIN sys.dm_db_index_usage_stats S ON S.object_id = I.object_id
	AND I.index_id = S.index_id
	AND DATABASE_ID = DB_ID()
WHERE OBJECTPROPERTY(O.object_id,''IsMsShipped'') = 0
	AND I.name IS NOT NULL
	AND S.object_id IS NULL'
SELECT * FROM #TempNeverUsedIndexes
ORDER BY DatbaseName, SchemaName, TableName, IndexName
DROP TABLE #TempNeverUsedIndexes
这类索引应该小心对待，不能一概而论，要看是什么原因导致这种问题

查看索引统计的相关信息
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT
    ss.name AS SchemaName
    , st.name AS TableName
    , s.name AS IndexName
    , STATS_DATE(s.id,s.indid) AS 'Statistics Last Updated'
    , s.rowcnt AS 'Row Count'
    , s.rowmodctr AS 'Number Of Changes'
    , CAST((CAST(s.rowmodctr AS DECIMAL(28,8))/CAST(s.rowcnt AS DECIMAL(28,2)) * 100.0) AS DECIMAL(28,2)) AS '% Rows Changed'
FROM sys.sysindexes s
INNER JOIN sys.tables st ON st.[object_id] = s.[id]
INNER JOIN sys.schemas ss ON ss.[schema_id] = st.[schema_id]
WHERE s.id > 100 AND s.indid > 0 AND s.rowcnt >= 500
ORDER BY SchemaName, TableName, IndexName
因为查询计划是根据统计信息来的，索引的选择同样取决于统计信息，所以根据统计信息更新的多寡可以看出数据库的大体状况，20%的自动更新对于大表来说非常慢。

SELECT TOP 20
DB_NAME() AS DatbaseName
, SCHEMA_NAME(o.Schema_ID) AS SchemaName
, OBJECT_NAME(s.[object_id]) AS TableName
, i.name AS IndexName
, ROUND(s.avg_fragmentation_in_percent,2) AS [Fragmentation %]
FROM sys.dm_db_index_physical_stats(db_id(),null, null, null, null) s
INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id]
AND s.index_id = i.index_id
INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE s.database_id = DB_ID()
AND i.name IS NOT NULL
AND OBJECTPROPERTY(s.[object_id],  'IsMsShipped' ) = 0
ORDER BY [Fragmentation %] DESC

wait type查询1：
SELECT TOP 20
wait_type ,
max_wait_time_ms wait_time_ms ,
signal_wait_time_ms ,
wait_time_ms - signal_wait_time_ms AS resource_wait_time_ms ,
100.0 * wait_time_ms / SUM(wait_time_ms) OVER ( )
AS percent_total_waits ,
100.0 * signal_wait_time_ms / SUM(signal_wait_time_ms) OVER ( )
AS percent_total_signal_waits ,
100.0 * ( wait_time_ms - signal_wait_time_ms )
/ SUM(wait_time_ms) OVER ( ) AS percent_total_resource_waits
FROM sys.dm_os_wait_stats
WHERE wait_time_ms > 0 -- remove zero wait_time
AND wait_type NOT IN -- filter out additional irrelevant waits
( 'SLEEP_TASK', 'BROKER_TASK_STOP', 'BROKER_TO_FLUSH',
'SQLTRACE_BUFFER_FLUSH','CLR_AUTO_EVENT', 'CLR_MANUAL_EVENT',
'LAZYWRITER_SLEEP', 'SLEEP_SYSTEMTASK', 'SLEEP_BPOOL_FLUSH',
'BROKER_EVENTHANDLER', 'XE_DISPATCHER_WAIT', 'FT_IFTSHC_MUTEX',
'CHECKPOINT_QUEUE', 'FT_IFTS_SCHEDULER_IDLE_WAIT',
'BROKER_TRANSMITTER', 'FT_IFTSHC_MUTEX', 'KSOURCE_WAKEUP',
'LAZYWRITER_SLEEP', 'LOGMGR_QUEUE', 'ONDEMAND_TASK_QUEUE',
'REQUEST_FOR_DEADLOCK_SEARCH', 'XE_TIMER_EVENT', 'BAD_PAGE_PROCESS',
'DBMIRROR_EVENTS_QUEUE', 'BROKER_RECEIVE_WAITFOR',
'PREEMPTIVE_OS_GETPROCADDRESS', 'PREEMPTIVE_OS_AUTHENTICATIONOPS',
'WAITFOR', 'DISPATCHER_QUEUE_SEMAPHORE', 'XE_DISPATCHER_JOIN',
'RESOURCE_QUEUE' )
ORDER BY wait_time_ms DESC

Unused查询2：
SELECT TOP 20
DB_NAME() AS DatabaseName
, SCHEMA_NAME(o.Schema_ID) AS SchemaName
, OBJECT_NAME(s.[object_id]) AS TableName
, i.name AS IndexName
, s.user_updates
, s.system_seeks + s.system_scans + s.system_lookups
AS [System usage]
FROM sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id]
AND s.index_id = i.index_id
INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE s.database_id = DB_ID()
AND OBJECTPROPERTY(s.[object_id], 'IsMsShipped') = 0
AND s.user_seeks = 0
AND s.user_scans = 0
AND s.user_lookups = 0
AND i.name IS NOT NULL
ORDER BY s.user_updates DESC

Maintenance查询3：
SELECT TOP 20
DB_NAME() AS DatabaseName
, SCHEMA_NAME(o.Schema_ID) AS SchemaName
, OBJECT_NAME(s.[object_id]) AS TableName
, i.name AS IndexName
, (s.user_updates ) AS [update usage]
, (s.user_seeks + s.user_scans + s.user_lookups)
AS [Retrieval usage]
, (s.user_updates) -
(s.user_seeks + user_scans +
s.user_lookups) AS [Maintenance cost]
, s.system_seeks + s.system_scans + s.system_lookups AS [System usage]
, s.last_user_seek
, s.last_user_scan
, s.last_user_lookup
FROM sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON s.[object_id] = i.[object_id]
AND s.index_id = i.index_id
INNER JOIN sys.objects o ON i.object_id = O.object_id
WHERE s.database_id = DB_ID()
AND i.name IS NOT NULL
AND OBJECTPROPERTY(s.[object_id], 'IsMsShipped') = 0
AND (s.user_seeks + s.user_scans + s.user_lookups) > 0
ORDER BY [Maintenance cost] DESC

missing查询4：
SELECT TOP 20
ROUND(s.avg_total_user_cost *
s.avg_user_impact
* (s.user_seeks + s.user_scans),0)
AS [Total Cost]
, d.[statement] AS [Table Name]
, equality_columns
, inequality_columns
, included_columns
FROM sys.dm_db_missing_index_groups g
INNER JOIN sys.dm_db_missing_index_group_stats s
ON s.group_handle = g.index_group_handle
INNER JOIN sys.dm_db_missing_index_details d
ON d.index_handle = g.index_handle
ORDER BY [Total Cost] DESC

SELECT   a.id as [对象Id],
      CASE WHEN a.colorder = 1 THEN d.name ELSE '' END AS [表名称],
      CASE WHEN a.colorder = 1 THEN isnull(f.value, '') ELSE '' END AS [表备注],
      a.colorder AS [字段顺序号], a.name AS [字段名称],
       CASE WHEN COLUMNPROPERTY(a.id,
      a.name, 'IsIdentity') = 1 THEN '√' ELSE '' END AS [是否标识列],
      CASE WHEN EXISTS
          (SELECT 1
         FROM dbo.sysindexes si INNER JOIN
               dbo.sysindexkeys sik ON si.id = sik.id AND si.indid = sik.indid INNER JOIN
               dbo.syscolumns sc ON sc.id = sik.id AND sc.colid = sik.colid INNER JOIN
               dbo.sysobjects so ON so.name = si.name AND so.xtype = 'PK'
         WHERE sc.id = a.id AND sc.colid = a.colid) THEN '√' ELSE '' END AS [是否主键],
      b.name AS [字段类型], a.length AS [字段长度], COLUMNPROPERTY(a.id, a.name, 'PRECISION')
      AS [字段精度], ISNULL(COLUMNPROPERTY(a.id, a.name, 'Scale'), 0) AS [字段小数位数],
      CASE WHEN a.isnullable = 1 THEN '√' ELSE '' END AS [是否允许null], ISNULL(e.text, '')
      AS [字段默认值], ISNULL(g.[value], '') AS [字段备注], d.crdate AS [对象创建时间],
      CASE WHEN a.colorder = 1 THEN d.refdate ELSE NULL END AS [对象修改时间]
FROM dbo.syscolumns a LEFT OUTER JOIN
      dbo.systypes b ON a.xtype = b.xusertype INNER JOIN
      dbo.sysobjects d ON a.id = d.id AND d.xtype = 'U' AND
      d.status >= 0 LEFT OUTER JOIN
      dbo.syscomments e ON a.cdefault = e.id LEFT OUTER JOIN
      sys.extended_properties g ON a.id = g.major_id AND a.colid = g.minor_id AND
      g.name = 'MS_Description' LEFT OUTER JOIN
      sys.extended_properties f ON d.id = f.major_id AND f.minor_id = 0 AND
      f.name = 'MS_Description'
ORDER BY d.name, [字段顺序号]