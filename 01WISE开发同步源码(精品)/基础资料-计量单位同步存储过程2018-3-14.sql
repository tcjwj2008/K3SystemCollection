alter procedure pro_MT_UnitSync

as
begin
set nocount on
---查询计量单位辅助表，并循环 
select  t1.FItemID,t1.FItemClassID,isnull(t4.FItemID,0) as FParentID,t1.FLevel,t1.FName,t1.FNumber,
t1.FShortNumber,t1.FFullNumber,t1.FDetail,t1.FDeleted
into #tmp0
from AIS20121023172833.dbo.t_item t1
left join (select * from AIS20121023172833.dbo.t_item where fitemclassid=7 and fdetail=0) t3 on t3.FItemID=t1.FParentID
left join (select * from t_item where fitemclassid=7 and fdetail=0) t4 on t3.FNumber=t4.FNumber
where (1=1)
and t1.fitemclassid=7 
and t1.FDetail=1
and t1.FDeleted=0
and not exists 
(select * from t_HT_SyncControl where FOID=t1.FItemID and FType='辅助表-计量单位')

--查询计量单位主表
select FItemID,FName,FNumber,FAuxClass,FCoefficient,
FConversation,FNameEn,FNameEnPlu,FUnitGroupID,FPrecision,
FShortNumber,FParentID,FStandard 
into #tmp1
from AIS20121023172833.dbo.t_MeasureUnit where fitemid>0 and FDeleted=0

--逐条插入t_Item，一次性select插入报错
declare @FOName varchar(100)
declare @FONumber varchar(100)
declare @FOItemClassID bigint
declare @FOLevel bigint
declare @FOParentID bigint 
declare @FODetail bigint 
declare @FOFullNumber varchar(100)
declare @FOShortNumber varchar(100)
declare @FODeleted bigint
declare @FOItemID bigint
declare @FNItemID bigint
declare @FNCoefficient decimal(21,10)
declare @FNFConversation bigint
declare @FNNameEn varchar(100)
declare @FNNameEnPlu varchar(100)
declare @FNPrecision bigint
declare @FNShortNumber varchar(100)
declare @FNParentID bigint 
declare @FNStandard int  --是否默认值
declare mycursor cursor for 
select FItemID,FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,FDeleted
from #tmp0 
open mycursor  
fetch next from mycursor into @FOItemID,@FOItemClassID,@FNParentID,@FOLevel,@FOName,
@FONumber,@FOShortNumber,@FOFullNumber,@FODetail,@FODeleted
while (@@fetch_status=0) 
begin

--计量单位旧帐套取数
select @FNCoefficient=FCoefficient,@FNFConversation=FConversation,@FNNameEn=FNameEN,
@FNNameEnPlu=FNameEnPlu,@FNPrecision=FPrecision,@FNShortNumber=FShortNumber,@FNStandard=FStandard
from #tmp1 t1
where t1.FItemID=@FOItemID

--插入计量单位表
INSERT INTO t_MeasureUnit 
(FName,FNumber,FAuxClass,FCoefficient,FConversation,
FNameEn,FNameEnPlu,FUnitGroupID,FPrecision,FShortNumber,FParentID,FStandard) 
VALUES
 (@FOName,@FONumber,' ',@FNCoefficient,@FNFConversation,
 @FNNameEn,@FNNameEnPlu,@FNParentID,@FNPrecision,@FONumber,@FNParentID,@FNStandard)

select @FNItemID=FItemID from t_MeasureUnit where fnumber =@FONumber

--插入辅助表-计量单位
Insert Into t_Item
(FItemID,FItemClassID,FDetail,FLevel,FParentID,
FNumber,FName,FShortNumber,FFullNumber,FDeleted) 
Values
(@FNItemID,@FOItemClassID,@FODetail,@FOLevel,@FNParentID,
@FONumber,@FOName,@FONumber,@FONumber,0)

--同步记录表
--数据表t_item同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'辅助表-计量单位',1,0,null,null,
@FOItemID,null,null,null

--数据表t_UnitGroup同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'计量单位',1,0,null,null,
@FOItemID,null,null,null

Insert Into t_BaseProperty
(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, 
FLastModUser, FDeleteDate, FDeleteUser)
Values
(7, @FNItemID,getdate(), 'administrator', Null,
 Null, Null, Null)

fetch next from mycursor into @FOItemID,@FOItemClassID,@FNParentID,@FOLevel,@FOName,
@FONumber,@FOShortNumber,@FOFullNumber,@FODetail,@FODeleted
end 
close mycursor 
DEALLOCATE mycursor 

drop table #tmp0
drop table #tmp1
set nocount off
end
--exec pro_MT_UnitSync

--select * from t_MeasureUnit
--select * from t_item where fitemclassid=7 and fdetail=1

--delete from t_MeasureUnit
--delete from t_item where fitemclassid=7 and fdetail=1
--delete from t_HT_SyncControl where FType='辅助表-计量单位'
--delete from t_HT_SyncControl where FType='计量单位'
