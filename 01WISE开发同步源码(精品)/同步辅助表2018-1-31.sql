--单据同步控制表
--已同步的基础资料、业务单据，会在同步控制表生成记录
--已同步的数据，不再做重复同步。
--drop table t_HT_SyncControl
create table t_HT_SyncControl
(
--===新帐套同步记录===
FID bigint,  --同步的基础资料内码、业务单据内码
FName varchar(100),  --同步的名称
FNumber varchar(100),  --同步的代码
FBillNo varchar(100),  --同步的单据编号
FEntryID bigint, --同步的业务单据分录内码
FType varchar(100), --单据类型 01-物料，02-计量单位
--是否同步 
--1-基础资料创建同步 2-基础资料创建转审核同步 
--3-基础资料创建转禁用同步 4-基础资料审核转创建同步
--5-业务单据审核同步 6-业务单据审核转关闭同步 7-业务单据审核转创建预警
FIsSync int, --单据同步状态
FStatus int, --单据状态 0-创建 1-审核 2-关闭 3-禁用/作废 4-拆分 5-合并
FRStatus int, --行状态 0-正常 1-行关闭
FMStatus int, --生产执行状态 0-计划 1-计划确认 2-确认 3-下达 4-开工 5-完工 6-结案
FDate datetime default(getdate()),  --创建时间
--===旧帐套同步记录===
FOID bigint,  --同步的基础资料内码、业务单据内码
FOEntryID bigint, --同步的业务单据分录内码
FIsEntrySync int, --分录行同步状态 0-业务分录正常同步 1-业务分录正常转行关闭同步
FIsPrdSync int --生产任务单据同步状态 0-计划 1-计划确认 2-确认 3-下达 4-开工 5-完工 6-结案
)

--单据同步记录表
--每次单据状态变化，做一次同步操作，并记录。
/*create table t_HT_SyncRecord
(
FID bigint,  --同步的基础资料内码、业务单据内码
FType varchar(10), --单据类型01-物料，02-计量单位
FSyncStatus int, --单据状态 -1-禁用，0-创建，1-审核，2-关闭，3-反审核，4-删除，5-作废
FDate datetime default(getdate())
)*/

select * from t_HT_SyncControl