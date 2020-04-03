alter procedure pro_HT_StockSync

as
begin
set nocount on
--1.更新仓库
--1.1找出（非禁用）仓库的辅助表数据,插入新帐套
select t1.FItemID,t1.FItemClassID,isnull(t4.FItemID,0) as FParentID,t1.FLevel,t1.FName,t1.FNumber,
t1.FShortNumber,t1.FFullNumber,t1.FDetail,t1.FDeleted
into #tmp0
from AIS20121023172833.dbo.t_item t1
left join (select * from AIS20121023172833.dbo.t_item where fitemclassid=5 and fdetail=0) t3 on t3.FItemID=t1.FParentID
left join (select * from t_item where fitemclassid=5 and fdetail=0) t4 on t3.FNumber=t4.FNumber
where (1=1)
and t1.fitemclassid=5 
and t1.FDetail=1
and t1.FDeleted=0
and not exists 
(select * from t_HT_SyncControl where FOID=t1.FItemID and FType='辅助表-仓库')

--找出仓库主表
select FItemID,FEmpID,FAddress,FPhone,FProperty,FTypeID,
FUnderStock,FMRPAvail,FIsStockMgr,FSPGroupID,FIncludeAccounting,
FShortNumber,FNumber,FName
into #tmp1
from AIS20121023172833.dbo.t_Stock where FDeleted=0


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
declare @FNEmpID bigint
declare @FNAddress varchar(200)
declare @FNPhone varchar(20)
declare @FNProperty bigint --库房属性 10-良品,11-在检,12-不良                                                                                                                                                                                                                                              
declare @FNTypeID bigint  --
declare @FNUnderStock bigint --是否允许负库存
declare @FNMRPAvail bigint --是否MRP可用量                                                                                                                                                                                                                                                       
declare @FNIsStockMgr bigint  --是否进行仓位管理                                                                                                                                                                                                                                                       
declare @FNSPGroupID bigint  --仓位组ID                                                                                                                                                                                                                                                          
declare @FNIncludeAccounting bigint 
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
--插入辅助表-仓库
INSERT INTO t_Item 
(FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
select @FOItemClassID,@FNParentID,@FOLevel,@FOName,@FONumber,
@FOShortNumber,@FOFullNumber,@FODetail,newid() as UUID,@FODeleted

select @FNItemID=FItemID from t_item where FItemClassID=5  and FNumber=@FONumber

--仓库旧帐套取数
--FEmpID字段暂不做同步
--仓位组暂不做同步
select @FNEmpID=FEmpID,@FNAddress=FAddress,@FNPhone=FPhone,@FNProperty=FProperty,@FNTypeID=FTypeID,@FNUnderStock=FUnderStock,
@FNMRPAvail=FMRPAvail,@FNIsStockMgr=FIsStockMgr,@FNIncludeAccounting=FIncludeAccounting,@FNShortNumber=FShortNumber,
@FNNumber=FNumber,@FNName=FName
from #tmp1 t1
where t1.FItemID=@FOItemID

--插入仓库主表
INSERT INTO t_Stock
(FEmpID,FAddress,FPhone,FProperty,FTypeID,
FUnderStock,FMRPAvail,FIsStockMgr,FSPGroupID,FIncludeAccounting,
FShortNumber,FNumber,FName,FParentID,FItemID) 
select 0,@FNAddress,@FNPhone,@FNProperty,@FNTypeID,
@FNUnderStock,@FNMRPAvail,@FNIsStockMgr,0,@FNIncludeAccounting,
@FNShortNumber,@FNNumber,@FNName,@FNParentID,@FNItemID

--同步记录表
--数据表t_item同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'辅助表-仓库',1,0,null,null,
@FOItemID,null,null,null

--数据表t_UnitGroup同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNItemID,null,@FOName,@FONumber,null,
'仓库',1,0,null,null,
@FOItemID,null,null,null


Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  
select fitemclassid,fuserid,@FNItemID 
from t_useritemclassright where (( FUserItemClassRight &  8)=8) and fitemclassid=5 and fuserid<>16394

Insert Into t_BaseProperty
(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, FLastModUser, FDeleteDate, FDeleteUser)
Values(3, @FNItemID, getdate(), 'administrator', Null, Null, Null, Null)

Delete from Access_t_Stock where FItemID=@FNItemID

Insert into Access_t_Stock(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
Values(@FNItemID,@FNParentID,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

delete from  t_gr_itemcontrol where FItemID=@FNItemID and FItemClassID=5

insert into t_gr_itemcontrol(FFrameWorkID,FItemClassID,FItemID,FCanUse,FCanAdd,FCanModi,FCanDel)
select FFrameWorkID,FItemClassID,@FNItemID,FCanUse,FCanAdd,FCanModi,FCanDel
from t_gr_itemcontrol where FItemID=@FNParentID and FItemClassID=5

update t_Item set FName=FName where FItemID=@FNItemID and FItemClassID=5

fetch next from mycursor into @FOItemID,@FOItemClassID,@FNParentID,@FOLevel,@FOName,
@FONumber,@FOShortNumber,@FOFullNumber,@FODetail,@FODeleted
end 
close mycursor 
DEALLOCATE mycursor 

drop table #tmp0
drop table #tmp1
set nocount off 
end 

--exec pro_HT_StockSync

--select * from t_Stock
--select * from t_item where fitemclassid=5 and fdetail=1

--delete from t_Stock
--delete from icinventory
--delete from POInventory   代管库存表                                                                                                                                   
--delete from t_item where fitemclassid=5 and fdetail=1
--delete from t_HT_SyncControl where FType='辅助表-仓库'
--delete from t_HT_SyncControl where FType='仓库'





