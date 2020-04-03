alter procedure pro_HT_DeptSync

as
begin
set nocount on
--1.更新部门
--1.1找出（非禁用）部门的辅助表数据,插入新帐套
select t1.FItemID,t1.FItemClassID,isnull(t4.FItemID,0) as FParentID,t1.FLevel,t1.FName,t1.FNumber,
t1.FShortNumber,t1.FFullNumber,t1.FDetail,t1.FDeleted
into #tmp0
from AIS20121023172833.dbo.t_item t1
left join (select * from AIS20121023172833.dbo.t_item where fitemclassid=2 and fdetail=0) t3 on t3.FItemID=t1.FParentID
left join (select * from t_item where fitemclassid=2 and fdetail=0) t4 on t3.FNumber=t4.FNumber
where (1=1)
and t1.fitemclassid=2 
and t1.FDetail=1
and t1.FDeleted=0
and not exists 
(select * from t_HT_SyncControl where FOID=t1.FItemID and FType='辅助表-部门')

--找出部门主表
select FItemID,FManager,FPhone,FFax,FDProperty,FIsCreditMgr,
FAcctID,FNote,FCostAccountType,FOtherARAcctID,FPreARAcctID,
FOtherAPAcctID,FPreAPAcctID,FIsVDept,FShortNumber,FNumber,
FName
into #tmp1
from AIS20121023172833.dbo.t_Department where FDeleted=0

--逐条插入t_Item，一次性select插入报错
declare @FOItemClassID bigint
declare @FOParentID bigint 
declare @FOLevel bigint
declare @FOName varchar(100)
declare @FONumber varchar(100)
declare @FOShortNumber varchar(100)
declare @FOFullNumber varchar(100)
declare @FODetail bigint 
declare @FODeleted bigint
declare @FOItemID bigint
declare @FNItemID bigint
declare @FNParentID bigint 
declare @FNManager bigint --负责人
declare @FNPhone varchar(50)
declare @FNFax varchar(50)
declare @FNDProperty bigint --属性
declare @FNIsCreditMgr bigint --是否进行信用管理
declare @FNAcctID bigint --科目内码
declare @FNNote varchar(500)
declare @FNCostAccountType bigint --成本核算类型
declare @FNOtherARAcctID bigint  --其他应收账款科目代码                                                                                                                                                                                                                                                     
declare @FNPreARAcctID bigint  --预收账款科目代码                                                                                                                                                                                                                                                       
declare @FNOtherAPAcctID bigint  --其他应付账款科目代码                                                                                                                                                                                                                                                     
declare @FNPreAPAcctID bigint --预付账款科目代码                                                                                                                                                                                                                                                       
declare @FNIsVDept bigint
declare @FNShortNumber varchar(50)
declare @FNNumber varchar(50)
declare @FNName varchar(50)
declare mycursor cursor for 
select FItemID,FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,FDeleted
from #tmp0 
open mycursor  
fetch next from mycursor into @FOItemID,@FOItemClassID,@FNParentID,@FOLevel,@FOName,
@FONumber,@FOShortNumber,@FOFullNumber,@FODetail,@FODeleted
while (@@fetch_status=0) 
begin 
--插入辅助表-部门
INSERT INTO t_Item 
(FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
select @FOItemClassID,@FNParentID,@FOLevel,@FOName,@FONumber,
@FOShortNumber,@FOFullNumber,@FODetail,newid() as UUID,@FODeleted

select @FNItemID=FItemID from t_item where FItemClassID=2  and FNumber=@FONumber

--部门旧帐套取数
select @FNManager=FManager,@FNPhone=FPhone,@FNFax=FFax,@FNDProperty=FDProperty,@FNIsCreditMgr=FIsCreditMgr,
@FNAcctID=FAcctID,@FNNote=FNote,@FNCostAccountType=FCostAccountType,@FNOtherARAcctID=FOtherARAcctID,@FNPreARAcctID=FPreARAcctID,
@FNOtherAPAcctID=FOtherAPAcctID,@FNPreAPAcctID=FPreAPAcctID,@FNIsVDept=FIsVDept,@FNShortNumber=FShortNumber,@FNNumber=FNumber,
@FNName=FName
from #tmp1 t1
where t1.FItemID=@FOItemID

--插入部门主表
--FManager暂不做同步
INSERT INTO t_Department 
(FManager,FPhone,FFax,FDProperty,FIsCreditMgr,
FAcctID,FNote,FCostAccountType,FOtherARAcctID,FPreARAcctID,
FOtherAPAcctID,FPreAPAcctID,FIsVDept,FShortNumber,FNumber,
FName,FParentID,FItemID) 
VALUES (0,@FNPhone,@FNFax,@FNDProperty,@FNIsCreditMgr,
@FNAcctID,@FNNote,@FNCostAccountType,@FNOtherARAcctID,@FNPreARAcctID,
@FNOtherAPAcctID,@FNPreAPAcctID,@FNIsVDept,@FNShortNumber,@FNNumber,
@FNName,@FNParentID,@FNItemID)

--同步记录表
--数据表t_item同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'辅助表-部门',1,0,null,null,
@FOItemID,null,null,null

--数据表t_Department同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'部门',1,0,null,null,
@FOItemID,null,null,null

Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  
select fitemclassid,fuserid,@FNItemID 
from t_useritemclassright 
where (( FUserItemClassRight &  8)=8) and fitemclassid=2 and fuserid<>16394

Insert Into t_BaseProperty
(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate,
FLastModUser, FDeleteDate, FDeleteUser)
Values(3, @FNItemID, getdate(), 'administrator', Null, Null, Null, Null)

Delete from Access_t_Department where FItemID=@FNItemID

Insert into Access_t_Department(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
Values(@FNItemID,@FNParentID,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

update t_Item set FName=FName where FItemID=@FNItemID and FItemClassID=2

fetch next from mycursor into @FOItemID,@FOItemClassID,@FNParentID,@FOLevel,@FOName,
@FONumber,@FOShortNumber,@FOFullNumber,@FODetail,@FODeleted
end 
close mycursor 
DEALLOCATE mycursor

drop table #tmp0
drop table #tmp1

set nocount off
end 

--exec pro_HT_DeptSync

--select * from t_Department
--select * from t_item where fitemclassid=2 and fdetail=1

--delete from t_Department
--delete from t_item where fitemclassid=2 and fdetail=1
--delete from t_HT_SyncControl where FType='辅助表-部门'
--delete from t_HT_SyncControl where FType='部门'