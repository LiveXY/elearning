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



BACKUP DATABASE mirror
    TO DISK = '\\SQLServer-1\backup\mirror.bak'
    WITH FORMAT
GO
BACKUP LOG mirror
    TO DISK = '\\SQLServer-1\backup\mirror.bak'
GO
RESTORE DATABASE TESTPROJECT
FROM DISK = N'\\SQLServer-1\Backup\mirror.bak'
with NORECOVERY
GO

RESTORE LOG AdventureWorks
    FROM DISK = '\\SQLServer-1\Backup\mirror.bak'
    WITH FILE=1, NORECOVERY
GO

--整完备份
Backup Database NorthwindCS
To disk='G:\Backup\NorthwindCS_Full_20070908.bak'

--差异备份
Backup Database NorthwindCS
To disk='G:\Backup\NorthwindCS_Diff_20070908.bak'
With Differential

--日记备份，认默截断日记
Backup Log NorthwindCS
To disk='G:\Backup\NorthwindCS_Log_20070908.bak'

--日记备份，不截断日记
Backup Log NorthwindCS
To disk='G:\Backup\NorthwindCS_Log_20070908.bak'
With No_Truncate

--截断日记不保存
Backup Log NorthwindCS
With No_Log

--或者
Backup Log NorthwindCS
With Truncate_Only
--截断后之日记文件不会变小
--有须要可以行进缩收

    每日一道理
我拽着春姑娘的衣裙，春姑娘把我带到了绿色的世界里。

--文件备份
Exec Sp_Helpdb NorthwindCS --看查据数文件
Backup Database NorthwindCS
File='NorthwindCS'   --据数文件的逻辑名
To disk='G:\Backup\NorthwindCS_File_20070908.bak'

--文件组备份
Exec Sp_Helpdb NorthwindCS --看查据数文件
Backup Database NorthwindCS
FileGroup='Primary'   --据数文件的逻辑名
To disk='G:\Backup\NorthwindCS_FileGroup_20070908.bak'
With init

--割分备份到多个目标
--恢复的时候不允许丧失任何一个目标
Backup Database NorthwindCS
To disk='G:\Backup\NorthwindCS_Full_1.bak'
     ,disk='G:\Backup\NorthwindCS_Full_2.bak'

--镜像备份
--个每目标都是雷同的
Backup Database NorthwindCS
To disk='G:\Backup\NorthwindCS_Mirror_1.bak'
Mirror
To disk='G:\Backup\NorthwindCS_Mirror_2.bak'
With Format --第一次做镜像备份的时候格式化目标

--镜像备份到地本和近程
Backup Database NorthwindCS
To disk='G:\Backup\NorthwindCS_Mirror_1.bak'
Mirror
To disk='\\192.168.1.200\Backup\NorthwindCS_Mirror_2.bak'
With Format

--天每生成一个备份文件
Declare @Path Nvarchar(2000)
Set @Path ='G:\Backup\NorthwindCS_Full_'
+Convert(Nvarchar,Getdate(),112)+'.bak'

Backup Database NorthwindCS
To disk=@Path

--从NoRecovery或者
--Standby模式恢复据数库为可用
Restore Database NorthwindCS_Bak
With Recovery

--看查目标备份中的备份集
Restore HeaderOnly
From Disk ='G:\Backup\NorthwindCS_Full_20070908.bak'

--看查目标备份的第一个备份集的息信
Restore FileListOnly
From Disk ='G:\Backup\NorthwindCS_Full_20070908_2.bak'
With File=1

--看查目标备份的卷标
Restore LabelOnly
From Disk ='G:\Backup\NorthwindCS_Full_20070908_2.bak'

--备份设置码密保护备份
Backup Database NorthwindCS
To disk='G:\Backup\NorthwindCS_Full_20070908.bak'
With Password = '123',init

Restore Database NorthwindCS
From disk='G:\Backup\NorthwindCS_Full_20070908.bak'
With Password = '123'