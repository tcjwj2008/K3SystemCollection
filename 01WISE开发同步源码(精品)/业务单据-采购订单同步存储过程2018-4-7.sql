--同步的采购单号从旧帐套直接带过来
--新帐套自增的采购单号按系统标准规则
--防止新旧采购单号命名冲突或重复，新采购单号规则要不同于旧采购单号规则
alter procedure pro_HT_POOrderSync
as
begin
set nocount on
--1.1获取用户转换列表
select t1.*,t2.FUserID as FOUserID,t3.FUserID as FNUserID
into #tmp01
from t_Item_3001 t1
left join AIS20121023172833.dbo.t_user t2 on t1.F_101=t2.FName
left join t_user t3 on t1.F_102=t3.FName
left join t_item t4 on t1.FItemID=t4.FItemID
where t4.FDeleted=0

--1.2获取转换供应商列表
select t1.*,t2.FItemID as FOItemID,t3.FItemID as FNItemID
into #tmp02
from t_item_3002 t1
left join AIS20121023172833.dbo.t_Supplier t2 on t1.F_103=t2.FNumber
left join t_Supplier t3 on t1.F_101=t3.FNumber
left join t_item t4 on t1.FItemID=t4.FItemID
where t4.FDeleted=0


--1.3获取不转换供应商列表
select t1.*,t2.FItemID as FOItemID
into #tmp03
from t_item_3003 t1
left join AIS20121023172833.dbo.t_Supplier t2 on t1.F_101=t2.FNumber
left join t_item t4 on t1.FItemID=t4.FItemID
where t4.FDeleted=0

--1.4转换处理后供应商
--1.4.1转换供应商处理（排除不同步供应商）
select *
into #tmp04
from
(
select t1.*,t2.FNItemID
from AIS20121023172833.dbo.t_Supplier t1
inner join #tmp02 t2 on t1.FItemID=t2.FOItemID
where (1=1) and t1.FDeleted=0
and not exists
(select FOItemID from #tmp03 where FOItemID=t1.FItemID)
--1.4.2正常供应商处理（排除不同步供应商,排除转换供应商）
union all
select t1.*,t2.FItemID as FNItemID
from AIS20121023172833.dbo.t_Supplier t1
inner join t_Supplier t2 on t1.FNumber=t2.FNumber
where (1=1) and t1.FDeleted=0
and not exists
(select FOItemID from #tmp03 where FOItemID=t1.FItemID)
and not exists
(select FOItemID from #tmp02 where FOItemID=t1.FItemID)
) s1

--1.5获取职员列表
select t1.*,t2.FItemID as FNItemID
into #tmp05
from AIS20121023172833.dbo.t_Emp t1
left join t_Emp t2 on t1.FNumber=t2.FNumber
where t1.FDeleted=0

--1.6获取部门列表
select t1.*,t2.FItemID as FNItemID
into #tmp06
from AIS20121023172833.dbo.t_Department t1
left join t_Department t2 on t1.FNumber=t2.FNumber
where t1.FDeleted=0

--1.7获取物料列表
select t1.*,t2.FItemID as FNItemID,t2.FNumber as FNNumber
into #tmp07
from AIS20121023172833.dbo.t_ICItem t1
left join t_ICItem t2 on t1.FNumber=t2.FNumber
where t1.FDeleted=0

--1.8获取计量单位列表
select t1.*,t2.FItemID as FNItemID
into #tmp08
from AIS20121023172833.dbo.t_MeasureUnit t1
left join t_MeasureUnit t2 on t1.FNumber=t2.FNumber
where t1.FDeleted=0

--1.11获取仓库同步列表
select t1.F_103 as 物料代码首字母,t1.F_104 as 同步到新仓库代码,t1.F_101 as 同步到新仓库名称,t3.FItemID as 新仓库内码
into #tmp11
from t_item_3004 t1
left join t_Stock t3 on t1.f_104=t3.FNumber
left join t_item t4 on t1.FItemID=t4.FItemID
where t4.FDeleted=0

--2.0获取需要同步过来的采购订单
--2.00获取可以同步的物料
--只同步物料首字母1、2、A、B、C、D开头的
--如果一个订单，订单明细的物料都是不可同步，那整单会被排除掉
select * 
into #tmp200
from AIS20121023172833.dbo.t_ICItem t1
where exists (select * from #tmp11 where 物料代码首字母=left(t1.FNumber,1))

--2.01获取可以同步的采购订单
select t1.*
into #tmp201
from AIS20121023172833.dbo.POOrderEntry t1
left join AIS20121023172833.dbo.POOrder t2 on t1.FInterID=t2.FInterID
where (1=1)
and t2.FDate>='2018-01-01'
and t2.FCancellation=0
and t2.FStatus>0
and exists
( select * from #tmp200 where FItemID=t1.FItemID)
and not exists 
(select * from t_HT_SyncControl where FOID=t1.FInterID and FType='采购订单')

--2.02获取可以同步采购订单的FInterID
select FInterID
into #tmp202
from #tmp201
group by FInterID

--2.获取采购订单旧帐套单据头数据(审核后数据),已经排除掉采购订单不能同步物料的单子
select t1.*,t3.FNUserID as FNBillerID,t4.FNUserID as FNCheckerID,t2.FNItemID as FNSupplyID ,
t5.FNItemID as FNEmpID,t6.FNItemID as FNManagerID,t7.FNItemID as FNDeptID
into #tmp1
from AIS20121023172833.dbo.POOrder t1
inner join #tmp04 t2 on t1.FSupplyID=t2.FItemID
left join #tmp01 t3 on t1.FBillerID=t3.FOUserID
left join #tmp01 t4 on t1.FCheckerID=t4.FOUserID
left join #tmp05 t5 on t1.FEmpID=t5.FItemID
left join #tmp05 t6 on t1.FMangerID=t6.FItemID
left join #tmp06 t7 on t1.FDeptID=t7.FItemID
where (1=1)
and t1.FDate>='2018-01-01'
and t1.FCancellation=0
and t1.FStatus>0
and not exists 
(select * from t_HT_SyncControl where FOID=t1.FInterID and FType='采购订单')
and exists  --可以同步的采购订单内码，已排除不能同步的物料
(select * from #tmp202 where FInterID=t1.FInterID)

--3.获取采购订单列表，写入新帐套
declare @FNInterID bigint
declare @FInterID bigint
declare @FBillNo varchar(100)  
declare @FBrNo varchar(100) --公司机构内码                                                                                                                                                                                                                                                         
declare @FTranType bigint  --单据类型 71-采购订单                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
declare @FCancellation bigint --作废 0-未作废，1-作废                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
declare @FStatus bigint --状态 0-未审核，1-已审核，2-部分关闭，3-全部关闭                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
declare @FSupplyID bigint --供应商内码                                                                                                                                                                                                                                                          
declare @Fdate datetime --单据日期                                                                                                                                                                                                                                                           
declare @FCurrencyID bigint --币别                                                                                                                                                                                                                                                             
declare @FCheckDate datetime --审核日期
declare @FMangerID bigint --主管                                                                                                                                                                                                                                                             
declare @FDeptID bigint --部门                                                                                                                                                                                                                                                             
declare @FEmpID bigint --业务员
declare @FBillerID bigint --制单人
declare @FExchangeRateType bigint ----汇率类型
declare @FExchangeRate decimal(21,2)   --汇率                                                                                                                                                                                                                                                         
declare @FPOStyle bigint --采购方式                                                                                                                                                                                                                                                           
declare @FRelateBrID bigint --供货机构                                                                                                                                                                                                                                                           
declare @FMultiCheckDate1 datetime 
declare @FMultiCheckDate2 datetime
declare @FMultiCheckDate3 datetime 
declare @FMultiCheckDate4 datetime
declare @FMultiCheckDate5 datetime
declare @FMultiCheckDate6 datetime
declare @FSelTranType bigint --源单类型                                                                                                                                                                                                                                                           
declare @FBrID bigint --制单机构                                                                                                                                                                                                                                                           
declare @FExplanation varchar(500) --摘要
declare @FSettleID bigint --结算方式                                                                                                                                                                                                                                                           
declare @FSettleDate datetime --结算日期                                                                                                                                                                                                                                                           
declare @FAreaPS bigint --采购范围                                                                                                                                                                                                                                                           
declare @FPOOrdBillNo varchar(100) --分销订单号                                                                                                                                                                                                                                                          
declare @FManageType bigint --保税监管类型                                                                                                                                                                                                                                                         
declare @FSysStatus bigint --系统设置                                                                                                                                                                                                                                                            
declare @FValidaterName varchar(100) --确认人                                                                                                                                                                                                                                                            
declare @FConsignee varchar(100) --收货方                                                                                                                                                                                                                                                            
declare @FVersionNo varchar(100) --版本号                                                                                                                                                                                                                                                            
declare @FChangeDate datetime --变更日期                                                                                                                                                                                                                                                           
declare @FChangeUser bigint --变更人                                                                                                                                                                                                                                                            
declare @FChangeCauses varchar(500) --变更原因                                                                                                                                                                                                                                                           
declare @FChangeMark varchar(100) --变更标志:                                                                                                                                                                                                                                                          
declare @FPrintCount bigint --打印次数                                                                                                                                                                                                                                                           
declare @FDeliveryPlace varchar(100) --交货地点                                                                                                                                                                                                                                                           
declare @FPOMode bigint --采购模式                                                                                                                                                                                                                                                           
declare @FAccessoryCount bigint
declare @FLastAlterBillNo varchar(100)
declare @FPlanCategory bigint --计划类别                                                                                                                                                                                                                                                           
declare @FCloseDate datetime
declare @FCloseUser bigint
declare @FCloseCauses varchar(500)
declare @FEnterpriseID bigint
declare @FSendStatus bigint
declare @FCheckerID bigint --审核人
declare mycursor cursor for 
select FInterID,FBillNo,FBrNo,FTranType,FCancellation,
FStatus,FNSupplyID,Fdate,FCurrencyID,FCheckDate,
FNManagerID,FNDeptID,FNEmpID,FNBillerID,FExchangeRateType,
FExchangeRate,FPOStyle,FRelateBrID,FMultiCheckDate1,FMultiCheckDate2,
FMultiCheckDate3,FMultiCheckDate4,FMultiCheckDate5,FMultiCheckDate6,FSelTranType,
FBrID,FExplanation,FSettleID,FSettleDate,FAreaPS,
FPOOrdBillNo,FManageType,FSysStatus,FValidaterName,FConsignee,
FVersionNo,FChangeDate,FChangeUser,FChangeCauses,
FChangeMark,FPrintCount,FDeliveryPlace,FPOMode,FAccessoryCount,
FLastAlterBillNo,FPlanCategory,FCloseDate,FCloseUser,FCloseCauses,
FEnterpriseID,FSendStatus,FNCheckerID
from #tmp1 
open mycursor 
fetch next from mycursor into @FInterID,@FBillNo,@FBrNo,@FTranType,@FCancellation,
@FStatus,@FSupplyID,@Fdate,@FCurrencyID,@FCheckDate,
@FMangerID,@FDeptID,@FEmpID,@FBillerID,@FExchangeRateType,
@FExchangeRate,@FPOStyle,@FRelateBrID,@FMultiCheckDate1,@FMultiCheckDate2,
@FMultiCheckDate3,@FMultiCheckDate4,@FMultiCheckDate5,@FMultiCheckDate6,@FSelTranType,
@FBrID,@FExplanation,@FSettleID,@FSettleDate,@FAreaPS,
@FPOOrdBillNo,@FManageType,@FSysStatus,@FValidaterName,@FConsignee,
@FVersionNo,@FChangeDate,@FChangeUser,@FChangeCauses,
@FChangeMark,@FPrintCount,@FDeliveryPlace,@FPOMode,@FAccessoryCount,
@FLastAlterBillNo,@FPlanCategory,@FCloseDate,@FCloseUser,@FCloseCauses,
@FEnterpriseID,@FSendStatus,@FCheckerID
while (@@fetch_status=0) 
begin 
--生成新帐套POOrder的最新FInterID
set @FNInterID=0
exec GetICMaxNum 'POOrder',@FNInterID output,1,16394

--写入分录体
INSERT INTO POOrderEntry 
(FInterID,FEntryID,FBrNo,FMapNumber,FMapName,
FItemID,FAuxPropID,FQty,FUnitID,FAuxQty,
FSecCoefficient,FSecQty,Fauxprice,FAuxTaxPrice,FAmount,
FTaxRate,FAuxPriceDiscount,FDescount,FCess,FTaxAmount,
FAllAmount,Fdate,Fnote,FSourceBillNo,FSourceTranType,
FSourceInterId,FSourceEntryID,FContractBillNo,FContractInterID,FContractEntryID,
FMrpLockFlag,FReceiveAmountFor_Commit,FPlanMode,FMTONo,FSupConfirm,
FSupConDate,FSupConMem,FSupConFetchDate,FSupConfirmor,FPRInterID,
FPREntryID,FEntryAccessoryCount,FCheckMethod,FIsCheck,FCloseEntryDate,
FCloseEntryUser,FCloseEntryCauses,FOutSourceInterID,FOutSourceEntryID,FOutSourceTranType)  
select @FNInterID,t1.FEntryID,t1.FBrNo,t1.FMapNumber,t1.FMapName,
t2.FNItemID,t1.FAuxPropID,t1.FQty,t3.FNItemID,t1.FAuxQty,
t1.FSecCoefficient,t1.FSecQty,t1.Fauxprice,t1.FAuxTaxPrice,t1.FAmount,
t1.FTaxRate,t1.FAuxPriceDiscount,t1.FDescount,t1.FCess,t1.FTaxAmount,
t1.FAllAmount,t1.Fdate,t1.Fnote,t1.FSourceBillNo,t1.FSourceTranType,
t1.FSourceInterId,t1.FSourceEntryID,t1.FContractBillNo,t1.FContractInterID,t1.FContractEntryID,
t1.FMrpLockFlag,t1.FReceiveAmountFor_Commit,t1.FPlanMode,t1.FMTONo,t1.FSupConfirm,
t1.FSupConDate,t1.FSupConMem,t1.FSupConFetchDate,t1.FSupConfirmor,t1.FPRInterID,
t1.FPREntryID,t1.FEntryAccessoryCount,t1.FCheckMethod,t1.FIsCheck,t1.FCloseEntryDate,
t1.FCloseEntryUser,t1.FCloseEntryCauses,t1.FOutSourceInterID,t1.FOutSourceEntryID,t1.FOutSourceTranType
from #tmp201 t1
left join #tmp07 t2 on t1.FItemID=t2.FItemID
left join #tmp08 t3 on t1.FUnitID=t3.FItemID
where t1.FInterID=@FInterID

EXEC p_UpdateBillRelateData 71,@FNInterID,'POOrder','POOrderEntry' 

--写入单据头
INSERT INTO POOrder
(FInterID,FBillNo,FBrNo,FTranType,FCancellation,
FStatus,FSupplyID,Fdate,FCurrencyID,FCheckDate,
FMangerID,FDeptID,FEmpID,FBillerID,FExchangeRateType,
FExchangeRate,FPOStyle,FRelateBrID,FMultiCheckDate1,FMultiCheckDate2,
FMultiCheckDate3,FMultiCheckDate4,FMultiCheckDate5,FMultiCheckDate6,FSelTranType,
FBrID,FExplanation,FSettleID,FSettleDate,FAreaPS,
FPOOrdBillNo,FManageType,FSysStatus,FValidaterName,FConsignee,
FVersionNo,FChangeDate,FChangeUser,FChangeCauses,
FChangeMark,FPrintCount,FDeliveryPlace,FPOMode,FAccessoryCount,
FLastAlterBillNo,FPlanCategory,FCloseDate,FCloseUser,FCloseCauses,
FEnterpriseID,FSendStatus,FCheckerID) 
SELECT @FNInterID,@FBillNo,@FBrNo,@FTranType,@FCancellation,
@FStatus,@FSupplyID,@Fdate,@FCurrencyID,@FCheckDate,
@FMangerID,@FDeptID,@FEmpID,@FBillerID,@FExchangeRateType,
@FExchangeRate,@FPOStyle,@FRelateBrID,@FMultiCheckDate1,@FMultiCheckDate2,
@FMultiCheckDate3,@FMultiCheckDate4,@FMultiCheckDate5,@FMultiCheckDate6,@FSelTranType,
@FBrID,@FExplanation,@FSettleID,@FSettleDate,@FAreaPS,
@FPOOrdBillNo,@FManageType,@FSysStatus,@FValidaterName,@FConsignee,
@FVersionNo,@FChangeDate,@FChangeUser,@FChangeCauses,
@FChangeMark,@FPrintCount,@FDeliveryPlace,@FPOMode,@FAccessoryCount,
@FLastAlterBillNo,@FPlanCategory,@FCloseDate,@FCloseUser,@FCloseCauses,
@FEnterpriseID,@FSendStatus,@FCheckerID

--FSysStatus系统设置                                                                                                                                                                                                                                                           
UPDATE POOrder SET FSysStatus = 2 WHERE FInterID = @FNInterID

--同步记录表
--数据表POOrder同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNInterID,t1.FEntryID,t2.FName,t2.FNumber,@FBillNo,
'采购订单',5,@FStatus,t1.FMrpClosed,null,
@FInterID,t1.FEntryID,0,null
from POOrderEntry t1
left join t_ICItem t2 on t1.FItemID=t2.FItemID
where t1.FInterID=@FNInterID

fetch next from mycursor into @FInterID,@FBillNo,@FBrNo,@FTranType,@FCancellation,
@FStatus,@FSupplyID,@Fdate,@FCurrencyID,@FCheckDate,
@FMangerID,@FDeptID,@FEmpID,@FBillerID,@FExchangeRateType,
@FExchangeRate,@FPOStyle,@FRelateBrID,@FMultiCheckDate1,@FMultiCheckDate2,
@FMultiCheckDate3,@FMultiCheckDate4,@FMultiCheckDate5,@FMultiCheckDate6,@FSelTranType,
@FBrID,@FExplanation,@FSettleID,@FSettleDate,@FAreaPS,
@FPOOrdBillNo,@FManageType,@FSysStatus,@FValidaterName,@FConsignee,
@FVersionNo,@FChangeDate,@FChangeUser,@FChangeCauses,
@FChangeMark,@FPrintCount,@FDeliveryPlace,@FPOMode,@FAccessoryCount,
@FLastAlterBillNo,@FPlanCategory,@FCloseDate,@FCloseUser,@FCloseCauses,
@FEnterpriseID,@FSendStatus,@FCheckerID
end 
close mycursor 
DEALLOCATE mycursor

drop table #tmp01
drop table #tmp02
drop table #tmp03
drop table #tmp04
drop table #tmp05
drop table #tmp06
drop table #tmp07
drop table #tmp08
drop table #tmp11
drop table #tmp1
drop table #tmp200
drop table #tmp201
drop table #tmp202
set nocount off
end

--exec pro_HT_POOrderSync

--delete from POOrder 
--update poorder set fcheckerid=0,fcheckdate=null,fstatus=0
--delete from t_HT_SyncControl where FType='采购订单'