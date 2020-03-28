alter procedure pro_HT_MaterialSync
as
begin
set nocount on
---删除物料 
--1.更新物料到t_item，包括非禁用、
--包括物料属性为1-外购、2-自制或自制(特性配置)、3-委外加工、5-虚拟件、6-特征类、7-配置类、8-规划类、9-组装件
--其中2-自制或自制(特性配置)、7-配置类会自动生成成本对象
--1.1旧帐套物料辅助表数据，存放临时表#tmp
select   t1.FItemID,t1.FItemClassID,isnull(t4.FItemID,0) as FParentID,t1.FLevel,t1.FName,t1.FNumber,
t1.FShortNumber,t1.FFullNumber,t1.FDetail,t1.FDeleted
into #tmp0
from AIS20121023172833.dbo.t_item t1
left join AIS20121023172833.dbo.t_ICItem t2 on t1.fnumber =t2.FNumber
left join (select * from AIS20121023172833.dbo.t_item where fitemclassid=4 and fdetail=0) t3 on t3.FItemID=t1.FParentID
left join (select * from t_item where fitemclassid=4 and fdetail=0) t4 on t3.FNumber=t4.FNumber
where (1=1)
and t1.fitemclassid=4 
and t1.FDetail=1
and t1.FDeleted=0
--and (t2.FErpClsID=1 or t2.FErpClsID=2)
and not exists 
(select * from t_HT_SyncControl where FOID=t1.FItemID and FType='辅助表-物料')

--1.2旧帐套物料数据，存放临时表#tmp1
select *
into #tmp1
from AIS20121023172833.dbo.t_icitem t1
where (1=1)
and t1.FDeleted=0
--and (t1.FErpClsID=1 or t1.FErpClsID=2)

--1.3计量单位组旧帐套与新帐套对应数据，存放临时表#tmp2
select t1.FUnitGroupID,isnull(t2.FUnitGroupID,0) as FNUnitGroupID
into #tmp2
from AIS20121023172833.dbo.t_UnitGroup t1
left join t_UnitGroup t2 on t1.FName=t2.FName

--1.4计量单位旧帐套与新帐套对应数据，存放临时表#tmp3 
select t1.FItemID,t2.FItemID as FNItemID
into #tmp3
from AIS20121023172833.dbo.t_MeasureUnit t1
left join t_MeasureUnit t2 on t1.FNumber=t2.FNumber

--1.5职员旧帐套与新帐套对应数据，存放临时表#tmp4
select t1.FItemID,t2.FItemID as FNItemID
into #tmp4
from AIS20121023172833.dbo.t_Emp t1
left join t_Emp t2 on t1.FNumber=t2.FNumber

--1.6科目旧帐套与新帐套对应数据，存放临时表#tmp5
select t1.FAccountID, t2.FAccountID as FNAccountID
into #tmp5
from AIS20121023172833.dbo.t_Account t1
left join t_Account t2 on t1.FNumber=t2.FNumber

--1.7成本项目辅助表旧帐套与新帐套对应数据，存放临时表#tmp6
select t1.FItemID,t2.FItemID as FNItemID
into #tmp6
from (select * from AIS20121023172833.dbo.t_Item where FItemClassID=2003) t1
left join (select * from t_Item where FItemClassID=2003) t2 on t1.FNumber=t2.FNumber

--存货科目FAcctID默认代码1243
--销售收入科目FSaleAcctID默认代码5101
--销售成本科目FCostAcctID默认代码5401
declare @FAcctID int
declare @FSaleAcctID int
declare @FCostAcctID int
select @FAcctID=FAccountID from t_Account where FNumber='1243'
select @FSaleAcctID=FAccountID from t_Account where FNumber='5101'
select @FCostAcctID=FAccountID from t_Account where FNumber='5401'

--逐条插入t_item,一次性select插入报错 
declare @FItemClassID bigint
declare @FParentID bigint 
declare @FLevel bigint
declare @FName varchar(100)
declare @FNumber varchar(100)
declare @FShortNumber varchar(100)
declare @FFullNumber varchar(100)
declare @FDetail bigint 
declare @FDeleted bigint
declare @FOItemID bigint
declare @FItemID bigint
declare @FErpClsID bigint
declare mycursor cursor for 
select FItemID,FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,FDeleted
from #tmp0 
open mycursor  
fetch next from mycursor into @FOItemID,@FItemClassID,@FParentID,@FLevel,@FName,
@FNumber,@FShortNumber,@FFullNumber,@FDetail,@FDeleted
while (@@fetch_status=0) 
begin 

--插入辅助表-物料
declare @MaxObjID bigint  
INSERT INTO t_Item
(FItemClassID,FParentID,FLevel,FName,FNumber,
FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
select @FItemClassID,@FParentID,@FLevel,@FName,@FNumber,
@FShortNumber,@FFullNumber,@FDetail,newid() as UUID,@FDeleted

update t_Identity set  fnext=fnext+1  where fname='t_item'
select @FItemID=FItemID from t_item where FItemClassID=4 and FDetail=1 and FNumber=@FNumber
select @FErpClsID=FErpClsID from #tmp1 where FNumber=@FNumber

--2.更新物料到t_icitem（非禁用、外购件、自制件）
INSERT INTO t_ICItem 
(FHelpCode,FModel,FAuxClassID,FErpClsID,FTypeID,
FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,
FStoreUnitID,FSecUnitID,FSecCoefficient,FDefaultLoc,FSPID,
FSource,FQtyDecimal,FLowLimit,FHighLimit,FSecInv,
FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,
FApproveNo,FAlias,FOrderRector,FPOHighPrice,FPOHghPrcMnyType,
FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,
FProfitRate,FOrderPrice,FSalePrice,FIsSpecialTax,FISKFPeriod,
FKFPeriod,FStockTime,FBatchManager,FBookPlan,FBeforeExpire,
FCheckCycUnit,FOIHighLimit,FOILowLimit,FSOHighLimit,FSOLowLimit,
FInHighLimit,FInLowLimit,FPickHighLimit,FPickLowLimit,FTrack,
FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,
FAPAcctID,FAdminAcctID,FGoodSpec,FTaxRate,FCostProject,
FIsSNManage,F_102,F_103,FCBRestore,
FNote,FPlanTrategy,FPlanMode,FOrderTrategy,FFixLeadTime,
FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,
FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,
FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,
FIsBackFlush,FBackFlushStockID,FBackFlushSPID,FPutInteger,FDailyConsume,
FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,
FNetWeight,FMaund,FLength,FWidth,FHeight,
FSize,FCubicMeasure,FStandardCost,FCBAppendRate,FCBAppendProject,
FCostBomID,FCBRouting,FStdBatchQty,FStandardManHour,FStdPayRate,
FChgFeeRate,FStdFixFeeRate,FOutMachFee,FOutMachFeeProject,FPieceRate,
FPOVAcctID,FPIVAcctID,FMCVAcctID,FPCVAcctID,FSLAcctID,
FCAVAcctID,FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,
FWthDrwChkMde,FStkChkMde,FOtherChkMde,FSampStdCritical,FSampStdStrict,
FSampStdSlight,FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,
FVersion,FNameEn,FModelEn,FHSNumber,FExportRate,
FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,
FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,
FWeightDecimal,FIsCharSourceItem,FCtrlType,FCtrlStraregy,FContainerName,
FKanBanCapability,FBatchSplitDays,FBatchSplit,FDefaultReadyLoc,FSPIDReady,
FStartService,FMakeFile,FIsFix,FTtermOfService,FTtermOfUsefulTime,
FIsFixedReOrder,FOnlineShopPNo,FOnlineShopPName,FForbbitBarcodeEdit,FDSManagerID,
FUnitPackageNumber,FOrderDept,FProductDesigner,FAuxInMrpCal,FShortNumber,
FNumber,FName,FParentID,FItemID) 
select t1.FHelpCode,t1.FModel,t1.FAuxClassID,t1.FErpClsID,t1.FTypeID,
t2.FNUnitGroupID,t4.FNItemID,t6.FNItemID,t8.FNItemID,t10.FNItemID,
t12.FNItemID,t14.FNItemID,t1.FSecCoefficient,t1.FDefaultLoc,t1.FSPID,
t1.FSource,t1.FQtyDecimal,t1.FLowLimit,t1.FHighLimit,t1.FSecInv,
t1.FUseState,t1.FIsEquipment,t1.FEquipmentNum,t1.FIsSparePart,t1.FFullName,
t1.FApproveNo,t1.FAlias,t16.FNItemID,t1.FPOHighPrice,t1.FPOHghPrcMnyType,
t1.FWWHghPrc,t1.FWWHghPrcMnyType,t1.FSOLowPrc,t1.FSOLowPrcMnyType,t1.FIsSale,
t1.FProfitRate,'0' as FOrderPrice,'0' as FSalePrice,t1.FIsSpecialTax,t1.FISKFPeriod,
t1.FKFPeriod,t1.FStockTime,t1.FBatchManager,t1.FBookPlan,t1.FBeforeExpire,
t1.FCheckCycUnit,t1.FOIHighLimit,t1.FOILowLimit,t1.FSOHighLimit,t1.FSOLowLimit,
t1.FInHighLimit,t1.FInLowLimit,'0' as FPickHighLimit,'0' as FPickLowLimit,t1.FTrack,
t1.FPlanPrice,t1.FPriceDecimal,isnull(@FAcctID,0),isnull(@FSaleAcctID,0),isnull(@FCostAcctID,0),
0 as FAPAcctID,t24.FNAccountID,0 as FGoodSpec,t1.FTaxRate,t26.FNItemID,
t1.FIsSNManage,t1.F_115,t1.F_117,1 as FCBRestore,
t1.FNote,t1.FPlanTrategy,14036 as FPlanMode,t1.FOrderTrategy,t1.FFixLeadTime,
t1.FLeadTime,t1.FTotalTQQ,t1.FOrderInterVal,t1.FQtyMin,t1.FQtyMax,
t1.FBatchAppendQty,t1.FOrderPoint,t1.FBatFixEconomy,t1.FBatChangeEconomy,t1.FRequirePoint,
t1.FPlanPoint,t1.FDefaultRoutingID,t1.FDefaultWorkTypeID,t1.FProductPrincipal,t1.FPlanner,
0 as FIsBackFlush,0 as FBackFlushStockID,0 as FBackFlushSPID,t1.FPutInteger,t1.FDailyConsume,
t1.FMRPCon,t1.FMRPOrder,t1.FChartNumber,t1.FIsKeyItem,t1.FGrossWeight,
t1.FNetWeight,t1.FMaund,t1.FLength,t1.FWidth,t1.FHeight,
t1.FSize,t1.FCubicMeasure,t1.FStandardCost,'0' as FCBAppendRate,0 as FCBAppendProject,
0 as FCostBomID,0 as FCBRouting,'1' as FStdBatchQty,t1.FStandardManHour,t1.FStdPayRate,
t1.FChgFeeRate,t1.FStdFixFeeRate,t1.FOutMachFee,0 as FOutMachFeeProject,t1.FPieceRate,
0 as FPOVAcctID,0 as FPIVAcctID,0 as FMCVAcctID,0 as FPCVAcctID,0 as FSLAcctID,
0 as FCAVAcctID,t1.FInspectionLevel,t1.FProChkMde,t1.FWWChkMde,t1.FSOChkMde,
t1.FWthDrwChkMde,t1.FStkChkMde,t1.FOtherChkMde,0 as FSampStdCritical,0 as FSampStdStrict,
0 as FSampStdSlight,t1.FStkChkPrd,t1.FStkChkAlrm,t1.FInspectionProject,t1.FIdentifier,
t1.FVersion,t1.FNameEn,t1.FModelEn,t1.FHSNumber,'0' as FExportRate,
t1.FFirstUnit,t1.FSecondUnit,t1.FImpostTaxRate,t1.FConsumeTaxRate,t1.FFirstUnitRate,
t1.FSecondUnitRate,t1.FIsManage,t1.FManageType,t1.FLenDecimal,t1.FCubageDecimal,
t1.FWeightDecimal,t1.FIsCharSourceItem,14039 as FCtrlType,0 as FCtrlStraregy,null as FContainerName,
1 as FKanBanCapability,0 as FBatchSplitDays,0 as FBatchSplit,0 as FDefaultReadyLoc,0 as FSPIDReady,
0 as FStartService,0 as FMakeFile,0 as FIsFix,0 as FTtermOfService,0 as FTtermOfUsefulTime,
1 as FIsFixedReOrder,null as FOnlineShopPNo,null as FOnlineShopPName,0 as FForbbitBarcodeEdit,0 as FDSManagerID,
0 as FUnitPackageNumber,0 as FOrderDept,0 as FProductDesigner,0 as FAuxInMrpCal,t1.FShortNumber,
t1.FNumber,t1.FName,@FParentID,@FItemID 
from #tmp1 t1
--inner join (select * from t_item where FDeleted=0 and FDetail=1 and FItemClassID=4 and FItemID=@FItemID) t0 on t1.FNumber=t0.FNumber
left join #tmp2 t2 on t1.FUnitGroupID =t2.FUnitGroupID  
left join #tmp3 t4 on  t1.FUnitID=t4.FItemID   
left join #tmp3 t6 on  t1.FOrderUnitID=t6.FItemID    
left join #tmp3 t8 on  t1.FSaleUnitID=t8.FItemID
left join #tmp3 t10 on  t1.FProductUnitID=t10.FItemID 
left join #tmp3 t12 on  t1.FStoreUnitID=t12.FItemID   
left join #tmp3 t14 on  t1.FSecUnitID=t14.FItemID
left join #tmp4 t16 on t1.FOrderRector=t16.FItemID
--left join AIS20121023172833.dbo.t_Account t18 on t1.FAcctID=t18.FAccountID
--left join t_Account t19 on t18.FNumber=t19.FNumber      
--left join AIS20121023172833.dbo.t_Account t20 on t1.FSaleAcctID=t20.FAccountID
--left join t_Account t21 on t20.FNumber=t21.FNumber         
--left join AIS20121023172833.dbo.t_Account t22 on t1.FCostAcctID=t22.FAccountID
--left join t_Account t23 on t22.FNumber=t23.FNumber   
left join #tmp5 t24 on t1.FAdminAcctID=t24.FAccountID
left join #tmp6 t26 on t1.FCostProject=t26.FItemID    
where t1.FNumber=@FNumber             

--同步记录表
--数据表t_item同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FItemID,null,@FName,@FNumber,null,
'辅助表-物料',1,0,null,null,
@FOItemID,null,null,null

--数据表t_icitem同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FItemID,null,@FName,@FNumber,null,
'物料',1,0,null,null,
@FOItemID,null,null,null

Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  
select t1.fitemclassid,t1.fuserid,@FItemID
from t_useritemclassright t1
where (( t1.FUserItemClassRight &  8)=8) and t1.fitemclassid=4 and t1.fuserid<>16394

Insert Into t_BaseProperty(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, FLastModUser, FDeleteDate, FDeleteUser)
Values(3, @FItemID,getdate(), 'administrator', Null, Null, Null, Null)

--=====写入对象成本开始===========================
if @FErpClsID=2 or @FErpClsID=7  --自制/配置物料增加成本有关数据
begin
--增加成本对象ID返回  
declare @CFItemID bigint
declare @CParentID bigint
set @CFItemID=(@FItemID+1)
exec cbAddCostObj @FItemID,@CFItemID output

select @CParentID= FParentID from t_item where fitemclassid=2001 and fitemid=@CFItemID

Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  
select t1.fitemclassid,t1.fuserid,@CFItemID
from t_useritemclassright t1
where (( t1.FUserItemClassRight &  8)=8) and t1.fitemclassid=2001 and t1.fuserid<>16394

Insert Into t_BaseProperty(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, FLastModUser, FDeleteDate, FDeleteUser)
Values(3, @CFItemID,getdate(), 'administrator', Null, Null, Null, Null)

Delete from Access_cbCostObj where FItemID=@CFItemID

Insert into Access_cbCostObj(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
Values(@CFItemID,@CParentID,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

Delete from  t_gr_itemcontrol where FItemID=@CFItemID and FItemClassID=2001
insert into t_gr_itemcontrol(FFrameWorkID,FItemClassID,FItemID,FCanUse,FCanAdd,FCanModi,FCanDel)
select FFrameWorkID,FItemClassID,@CFItemID,FCanUse,FCanAdd,FCanModi,FCanDel
from t_gr_itemcontrol where FItemID=@CParentID and FItemClassID=2001

update t_Item set FName=FName where FItemID=@CFItemID and FItemClassID=2001
end
--=====写入对象成本结束===========================

Delete from Access_t_ICItem where FItemID=@FItemID
Insert into Access_t_ICItem(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
 Values(@FItemID,@FParentID,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

Delete from  t_gr_itemcontrol where FItemID=@FItemID and FItemClassID=4
insert into t_gr_itemcontrol(FFrameWorkID,FItemClassID,FItemID,FCanUse,FCanAdd,FCanModi,FCanDel)
select FFrameWorkID,FItemClassID,@FItemID,FCanUse,FCanAdd,FCanModi,FCanDel
from t_gr_itemcontrol where FItemID=@FParentID and FItemClassID=4

update t_Item set FName=FName where FItemID=@FItemID and FItemClassID=4

UPDATE t1  SET t1.FFullName = t2.FFullName FROM t_ICItemBase t1 INNER JOIN t_Item t2 ON t1.FItemID = t2.FItemID AND t2.FItemID =@FItemID


fetch next from mycursor into @FOItemID,@FItemClassID,@FParentID,@FLevel,@FName,
@FNumber,@FShortNumber,@FFullNumber,@FDetail,@FDeleted
end 
close mycursor 
DEALLOCATE mycursor 

drop table #tmp0
drop table #tmp1
drop table #tmp2
drop table #tmp3
drop table #tmp4
drop table #tmp5
drop table #tmp6
set nocount off
end

--exec pro_HT_MaterialSync

/**
delete from t_ICItem
delete from t_item where FItemClassID=4 
delete from t_item where FItemClassID=2001
delete from cbcostobj where FNumber<>'MaterielShareID' and FNumber<>'MaterielMakeID'
                                                                                                                           
**/
--删除单位
--delete from t_UnitGroup   
--delete from t_MeasureUnit 
--delete from t_item where fitemclassid=7 
--delete from t_HT_SyncControl where FType='辅助表-物料'
--delete from t_HT_SyncControl where FType='物料'