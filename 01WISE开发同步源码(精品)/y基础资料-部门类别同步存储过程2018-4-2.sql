alter procedure pro_HT_DeptGroupSync

as
begin
set nocount on
--1.更新部门类别
--1.1找出（非禁用）部门类别的辅助表分组数据,插入新帐套
select  FItemID,FItemClassID,0 as FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,FDeleted
into #tmp0
from AIS20121023172833.dbo.t_item t1
where (1=1)
and t1.fitemclassid=2
and t1.FDetail=0
and t1.FDeleted=0
and not exists 
(select * from t_HT_SyncControl where FOID=t1.FItemID and FType='辅助表-部门类别')

--逐条插入t_Item，一次性select插入报错
declare @FItemClassID bigint
declare @FParentID bigint 
declare @FLevel bigint
declare @FName varchar(100)
declare @FNumber varchar(100)
declare @FShortNumber varchar(100)
declare @FFullNumber varchar(100)
declare @FDetail bigint 
declare @FDeleted bigint
declare @FItemID bigint
declare @FOItemID bigint
declare mycursor cursor for 
select FItemID,FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,FDeleted
from #tmp0 
open mycursor  
fetch next from mycursor into @FOItemID,@FItemClassID,@FParentID,@FLevel,@FName,
@FNumber,@FShortNumber,@FFullNumber,@FDetail,@FDeleted
while (@@fetch_status=0) 
begin 
--插入辅助表-部门类别
INSERT INTO t_Item
(FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
select @FItemClassID,@FParentID,@FLevel,@FName,@FNumber,
@FShortNumber,@FFullNumber,@FDetail,newid() as UUID,@FDeleted

select @FItemID=FItemID from t_item where FItemClassID=2 and FNumber=@FNumber

--同步记录表
--数据表t_item同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FItemID,null,@FName,null,null,
'辅助表-部门类别',1,0,null,null,
@FOItemID,null,null,null

Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  
select fitemclassid,fuserid,@FItemID 
from t_useritemclassright 
where (( FUserItemClassRight &  8)=8) and fitemclassid=2 and fuserid<>16394

Insert Into t_BaseProperty(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, FLastModUser, FDeleteDate, FDeleteUser)
Values(3, @FItemID,getdate(), 'administrator', Null, Null, Null, Null)

Delete from Access_t_Department where FItemID=@FItemID

Insert into Access_t_Department(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
Values(@FItemID,@FParentID,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

update t_Item set FName=FName where FItemID=@FItemID and FItemClassID=2

fetch next from mycursor into @FOItemID,@FItemClassID,@FParentID,@FLevel,@FName,
@FNumber,@FShortNumber,@FFullNumber,@FDetail,@FDeleted
end 
close mycursor 
DEALLOCATE mycursor 

--1.2找出（非禁用）仓库类别的数据,旧帐套数据1
select FItemID,FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,FDeleted
into #tmp1
from AIS20121023172833.dbo.t_item t1
where (1=1)
and t1.fitemclassid=2
and t1.FDetail=0
and t1.FDeleted=0

--1.3旧帐套数据关联旧帐套数据，找出FParentNumber,旧帐套数据2
select t1.*,t2.FNumber as FParentNumber 
into #tmp2
from #tmp1 t1
left join #tmp1 t2 on t1.FParentID=t2.FItemID

--1.4旧帐套数据2关联新帐套数据，找出新帐套FParentID，旧帐套数据3
select t1.*,isnull(t2.FItemID,0) as FNewParentID
into #tmp3
from #tmp2 t1
left join 
(select * from t_item where FItemClassID=2 and FDetail=0 and FDeleted=0) t2 on t1.FParentNumber=t2.FNumber

--1.5旧帐套数据3更新FNewParentID到t_item的FParentID
update t1 set t1.FParentID=t2.FNewParentID
from t_item t1 inner join #tmp3 t2 on t1.FNumber=t2.FNumber
where t1.FItemClassID=2 and t1.FDetail=0

drop table #tmp0
drop table #tmp1
drop table #tmp2
drop table #tmp3

set nocount off
end 

--exec pro_HT_DeptGroupSync
--delete from t_item where fitemclassid=2 and fdetail=0
--delete from t_HT_SyncControl where FType='辅助表-部门类别'