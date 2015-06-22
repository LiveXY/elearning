--备份报表数据
select * from GTS_MiniBoxReport.dbo.总表

--关闭所有IIS
--清理垃圾文件
--重新启动服务器 远程重启shutdown /r /m \\10.0.0.4 -t 0

--清理sql2008数据库日志
USE GTS_MiniBoxLog201211
GO
ALTER DATABASE GTS_MiniBoxLog201211 SET RECOVERY SIMPLE WITH NO_WAIT
GO
ALTER DATABASE GTS_MiniBoxLog201211 SET RECOVERY SIMPLE
GO
USE GTS_MiniBoxLog201211
GO
DBCC SHRINKFILE (N'GTS_MiniBoxLog201211_log' , 1, TRUNCATEONLY)
GO
USE GTS_MiniBoxLog201211
GO
ALTER DATABASE GTS_MiniBoxLog201211 SET RECOVERY FULL WITH NO_WAIT
GO
ALTER DATABASE GTS_MiniBoxLog201211 SET RECOVERY FULL
GO

无日志恢复数据库方法一：
Use Master
Go
sp_configure 'allow updates', 1 reconfigure with override
Go
alter database MClubDB set emergency
Go
sp_dboption 'MClubDB', 'single user', 'true'
Go
dbcc checkdb('MClubDB',REPAIR_ALLOW_DATA_LOSS)
dbcc checkdb('MClubDB',REPAIR_REBUILD)
Go
sp_configure 'allow updates', 0 reconfigure with override
Go
sp_dboption 'MClubDB', 'single user', 'false'
Go

无日志恢复数据库方法二：
CREATE DATABASE MClubDBN
ON (FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\DATA\MClubDB.mdf')
FOR ATTACH_REBUILD_LOG ;
GO
如果是2005转2008要放在安装目录下

如果数据库日志太大清理不掉，右击数据库属性选择“文件” 将日志文件初始大小修改为1M


--数据库修复
1. DBCC CHECKDB
use master
declare @databasename varchar(255)
set @databasename='需要修复的数据库实体的名称'
--ALTER DATABASE 需要修复的数据库实体的名称 SET EMERGENCY  修改数据库为紧急模式
exec sp_dboption @databasename, N'single', N'true' --将目标数据库置为单用户状态
dbcc checkdb(@databasename,REPAIR_ALLOW_DATA_LOSS)
dbcc checkdb(@databasename,REPAIR_REBUILD)
exec sp_dboption @databasename, N'single', N'false'--将目标数据库置为多用户状态

如果出现CHECKDB found 0 allocation errors and 19 consistency errors in database 'POS_DB'.
执行：
DBCC CHECKDB('POS_DB') with NO_INFOMSGS,PHYSICAL_ONLY
DBCC CHECKDB('POS_DB',repair_allow_data_loss) WITH TABLOCK



2. DBCC CHECKTABLE
如果DBCC CHECKDB 检查仍旧存在错误，可以使用DBCC CHECKTABLE来修复。
use 需要修复的数据库实体的名称
declare @dbname varchar(255)
set @dbname='需要修复的数据库实体的名称'
exec sp_dboption @dbname,'single user','true'
dbcc checktable('需要修复的数据表的名称',REPAIR_ALLOW_DATA_LOSS)
dbcc checktable('需要修复的数据表的名称',REPAIR_REBUILD)
------把’ 需要修复的数据表的名称’更改为执行DBCC CHECKDB时报错的数据表的名称
exec sp_dboption @dbname,'single user','false'

3.
步骤1:创建一个新的数据库,命名为原来数据库的名字，停止SQL Server
步骤2:把老数据库的MDF文件替换新数据库的相应的MDF文件, 并把LDF文件删除，重新启动SQL Server 服务
步骤3:运行如下命令
Use Master
Go
sp_configure 'allow updates', 1
reconfigure with override
Go

update sysdatabases set status = 32768 where name='db_name' --将这个数据库置为紧急模式
update sysdatabases set status=32768 where dbid=DB_ID('test')

GO


步骤4:停止SQL然后重新启动SQL Server 服务,然后运行如下命令
DBCC TRACEON (3604)
DBCC REBUILD_LOG('db_name','c:\mssql7\data\dbxxx_3.LDF')
Go

设置数据库为正常状态
sp_dboption 'test','dbo use only','false'


步骤5:停止SQL然后重新启动SQL Server 服务,然后运行:
use master
update sysdatabases set status = 8 where name='db_name'
Go
sp_configure 'allow updates', 0
reconfigure with override
GO


