alter procedure pro_HT_ICPurchaseSync
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
select t1.*,t2.FItemID as FNItemID
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

--1.10获取旧帐套采购发票在新帐套有上游单据
select *
into #tmp10
from
(
--1.10.1上游单据是外购入库单
select t1.* ,t3.FInterID as FNSourceInterID,t1.FSourceEntryID as FNSourceEntryID,t4.FInterID as FNOrderInterID
from AIS20121023172833.dbo.ICPurchaseentry t1
left join AIS20121023172833.dbo.ICPurchase t2 on t1.FInterID=t2.FInterID
inner join ICStockBill t3 on t1.FSourceBillNo=t3.FBillNo
left join POOrder t4 on t1.FOrderBillNo=t4.FBillNo
where (t2.FTranType=75 or t2.FTranType=76)
and (t2.FClassTypeID=1000003 or t2.FClassTypeID=1000004)
and t1.FSourceTranType =1
union all
--1.10.2上游单据是采购订单
select t1.* ,t3.FInterID as FNSourceInterID,t1.FSourceEntryID as FNSourceEntryID,t3.FInterID as FNOrderInterID
from AIS20121023172833.dbo.ICPurchaseentry t1
left join AIS20121023172833.dbo.ICPurchase t2 on t1.FInterID=t2.FInterID
inner join POOrder t3 on t1.FSourceBillNo=t3.FBillNo
where (t2.FTranType=75 or t2.FTranType=76)
and (t2.FClassTypeID=1000003 or t2.FClassTypeID=1000004)
and t1.FSourceTranType =71
) s

--2.0获取需要同步过来的采购发票
--2.00获取可以同步的物料
--只同步物料首字母1、2、A、B、C、D开头的
--如果一个订单，订单明细的物料都是不可同步，那整单会被排除掉
select * 
into #tmp200
from AIS20121023172833.dbo.t_ICItem t1
where exists (select * from #tmp11 where 物料代码首字母=left(t1.FNumber,1))

--2.01获取可以同步的采购发票
select t1.*
into #tmp201
from AIS20121023172833.dbo.ICPurchaseentry t1
left join AIS20121023172833.dbo.ICPurchase t2 on t1.FInterID=t2.FInterID
where (1=1)
and (t2.FTranType=75 or t2.FTranType=76)
and (t2.FClassTypeID=1000003 or t2.FClassTypeID=1000004)
and t2.FDate>='2018-01-01'
and t2.FCancellation=0
and t2.FStatus>0
and exists
( select * from #tmp200 where FItemID=t1.FItemID)
and not exists 
( select * from t_HT_SyncControl where FOID=t1.FInterID and FType='采购发票')

--2.02获取可以同步采购发票的FInterID
select FInterID
into #tmp202
from #tmp201
group by FInterID


--这里还少考虑一步，假如同步过来的上游外购入库单被人为下推了。这时再把下游单据同步过来会出问题。

--2.获取采购发票旧帐套单据头数据(审核后数据)
select t1.*,t3.FNUserID as FNBillerID,t4.FNUserID as FNCheckerID,t2.FNItemID as FNSupplyID ,
t5.FNItemID as FNEmpID,isnull(t6.FNItemID,0) as FNManagerID,isnull(t7.FNItemID,0) as FNDeptID
into #tmp1
from AIS20121023172833.dbo.ICPurchase t1
inner join #tmp04 t2 on t1.FSupplyID=t2.FItemID
left join #tmp01 t3 on t1.FBillerID=t3.FOUserID
left join #tmp01 t4 on t1.FCheckerID=t4.FOUserID
left join #tmp05 t5 on t1.FEmpID=t5.FItemID
left join #tmp05 t6 on t1.FManagerID=t6.FItemID
left join #tmp06 t7 on t1.FDeptID=t7.FItemID
where (1=1)
and (t1.FTrantype=75 or t1.FTranType=76)
and (t1.FClassTypeID=1000003 or t1.FClassTypeID=1000004)
and t1.FDate>='2018-01-01'
and t1.FCancellation=0
and t1.FStatus>0
and not exists 
(select * from t_HT_SyncControl where FOID=t1.FInterID and FType='采购发票')
and exists  --新帐套有上游单据
(select * from #tmp10 where FInterID=t1.FInterID)
and exists --可以同步的采购发票内码，已排除不能同步的物料
(select * from #tmp202 where FInterID=t1.FInterID)

--3.获取采购发票列表，写入新帐套
declare @FNInterID bigint
declare @FNSourceInterId bigint
declare @FInterID bigint
declare @FBillNo varchar(50)
declare @FBrNo varchar(10)  --公司机构内码 
declare @FTranType bigint --单据类型
declare @FCancellation bigint --作废
declare @FStatus bigint  --单据状态0-未审核,1-已审核
declare @FROB bigint --红蓝字  1-蓝字,-1-红字
declare @FClassTypeID bigint --新单据类型ID                                                                                                                                                                                                                                                        
declare @FSubSystemID bigint --子系统内码                                                                                                                                                                                                                                                          
declare @FYear bigint --年份                                                                                                                                                                                                                                                             
declare @FPeriod bigint --期间
declare @FItemClassID bigint --核算项目内码                                                                                                                                                                                                                                                         
declare @FFincDate  datetime --财务日期                                                                                                                                                                                                                                                           
declare @FHookStatus bigint --钩稽标志
declare @FTotalCostFor decimal(21,10) --总成本额原币                                                                                                                                                                                                                                                         
declare @FTotalCost decimal(21,10) --总成本额（本位币）                                                                                                                                                                                                                                                      
declare @Fdate datetime 
declare @FSupplyID bigint --供应商内码  
declare @FTaxNum varchar(100) --税务登记号                                                                                                                                                                                                                                                          
declare @FCheckDate datetime --审核日期
declare @FDeptID bigint --部门
declare @FEmpID bigint --业务员
declare @FBillerName varchar(100) --开票人                                                                                                                                                                                                                                                            
declare @FCurrencyID bigint --币别                                                                                                                                                                                                                                                             
declare @FInvStyle bigint --业务类型 12510－外购入库类型，12511－委外加工类型                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
declare @FExchangeRateType bigint --汇率类型                                                                                                                                                                                                                                                           
declare @FExchangeRate float --汇率                                                                                                                                                                                                                                                             
declare @FCompactNo varchar(100) --合同号                                                                                                                                                                                                                                                            
declare @Fnote varchar(500) --备注                                                                                                                                                                                                                                                             
declare @FBillerID bigint --制单人
declare @FPOStyle bigint --采购方式 
declare @FYearPeriod varchar(50) --钩稽期间                                                                                                                                                                                                                                                           
declare @FMultiCheckDate1 datetime 
declare @FMultiCheckDate2 datetime
declare @FPOOrdBillNo varchar(100) --对方单据号                                                                                                                                                                                                                                                          
declare @FMultiCheckDate3 datetime
declare @FMultiCheckDate4 datetime
declare @FMultiCheckDate5 datetime
declare @FMultiCheckDate6 datetime
declare @FPrintCount  bigint --打印次数
declare @FYtdIntRate float --年利率(%)                                                                                                                                                                                                                                                         
declare @FAcctID bigint --贷方科目                                                                                                                                                                                                                                                           
declare @FOrgBillInterID bigint --源单内码                                                                                                                                                                                                                                                           
declare @FHookerID bigint --钩稽人                                                                                                                                                                                                                                                            
declare @FSelTranType bigint --源单类型 
declare @FBrID bigint --制单机构  
declare @FManagerID bigint --主管
declare @FCussentAcctID bigint --往来科目                                                                                                                                                                                                                                                           
declare @FPayCondition varchar(100) --收款条件       
declare @FSettleDate datetime --收付款日期       
declare @FSysStatus bigint --整单折扣参数 整单折扣参数: 第一位-是否启用整单折扣，第二位-折扣是否含税                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
declare @FCheckerID bigint --审核人
declare mycursor cursor for 
select FInterID,FBillNo,FBrNo,FTranType,FCancellation,
FStatus,FROB,FClassTypeID,FSubSystemID,FYear,
FPeriod,FItemClassID,FFincDate,FHookStatus,FTotalCostFor,
FTotalCost,Fdate,FNSupplyID,FTaxNum,FCheckDate,
FNDeptID,FNEmpID,FBillerName,FCurrencyID,FInvStyle,
FExchangeRateType,FExchangeRate,FCompactNo,Fnote,FNBillerID,
FPOStyle,FYearPeriod,FMultiCheckDate1,FMultiCheckDate2,FPOOrdBillNo,
FMultiCheckDate3,FMultiCheckDate4,FMultiCheckDate5,FMultiCheckDate6,FPrintCount,
FYtdIntRate,FAcctID,FOrgBillInterID,FHookerID,FSelTranType,
FBrID,FNManagerID,FCussentAcctID,FPayCondition,FSettleDate,FSysStatus,FNCheckerID
from #tmp1 
open mycursor 
fetch next from mycursor into @FInterID,@FBillNo,@FBrNo,@FTranType,@FCancellation,
@FStatus,@FROB,@FClassTypeID,@FSubSystemID,@FYear,
@FPeriod,@FItemClassID,@FFincDate,@FHookStatus,@FTotalCostFor,
@FTotalCost,@Fdate,@FSupplyID,@FTaxNum,@FCheckDate,
@FDeptID,@FEmpID,@FBillerName,@FCurrencyID,@FInvStyle,
@FExchangeRateType,@FExchangeRate,@FCompactNo,@Fnote,@FBillerID,
@FPOStyle,@FYearPeriod,@FMultiCheckDate1,@FMultiCheckDate2,@FPOOrdBillNo,
@FMultiCheckDate3,@FMultiCheckDate4,@FMultiCheckDate5,@FMultiCheckDate6,@FPrintCount,
@FYtdIntRate,@FAcctID,@FOrgBillInterID,@FHookerID,@FSelTranType,
@FBrID,@FManagerID,@FCussentAcctID,@FPayCondition,@FSettleDate,@FSysStatus,@FCheckerID
while (@@fetch_status=0) 
begin 
--生成新帐套ICPurchase的最新FInterID
set @FNInterID=0
exec GetICMaxNum 'ICPurchase',@FNInterID output,1,16394

--写入分录体
INSERT INTO ICPurchaseEntry 
(FInterID,FEntryID,FBrNo,FMapNumber,FMapName,
FItemID,FAuxPropID,FQty,FUnitID,Fauxqty,
FSecCoefficient,FSecQty,Fauxprice,FAuxTaxPrice,FDiscountRate,
FAuxPriceDiscount,Famount,FStdAmount,FAmtDiscount,FStdAmtDiscount,
FTaxRate,FTaxAmount,FStdTaxAmount,FAmountMust,FAmountMustOld,
FNoMust,FNoMustOld,FDeductTax,FDeductTaxOld,FOrgBillEntryID,
FOrderPrice,FAuxOrderPrice,FClassID_SRC,FEntryID_SRC,FSourceBillNo,
FSourceTranType,FSourceInterId,FSourceEntryID,FContractBillNo,FContractInterID,
FContractEntryID,FOrderBillNo,FOrderInterID,FOrderEntryID,FAllHookQTY,
FStdAllHookAmount,FCurrentHookQTY,FStdCurrentHookAmount,FPlanMode,FMTONo,
FOrderType,FBatchNo,FItemStatementBillNO,FItemStatementEntryID,FItemStatementInterID)  
SELECT @FNInterID,t1.FEntryID,t1.FBrNo,t1.FMapNumber,t1.FMapName,
t2.FNItemID,t1.FAuxPropID,t1.FQty,t3.FNItemID,t1.Fauxqty,
t1.FSecCoefficient,t1.FSecQty,t1.Fauxprice,t1.FAuxTaxPrice,t1.FDiscountRate,
t1.FAuxPriceDiscount,t1.Famount,t1.FStdAmount,t1.FAmtDiscount,t1.FStdAmtDiscount,
t1.FTaxRate,t1.FTaxAmount,t1.FStdTaxAmount,t1.FAmountMust,t1.FAmountMustOld,
t1.FNoMust,t1.FNoMustOld,t1.FDeductTax,t1.FDeductTaxOld,t1.FOrgBillEntryID,
t1.FOrderPrice,t1.FAuxOrderPrice,t1.FClassID_SRC,t1.FEntryID_SRC,t1.FSourceBillNo,
t1.FSourceTranType,t4.FNSourceInterId,t4.FNSourceEntryID,t1.FContractBillNo,t1.FContractInterID,
t1.FContractEntryID,t1.FOrderBillNo,t4.FNOrderInterID,t4.FNSourceEntryID,t1.FAllHookQTY,
t1.FStdAllHookAmount,t1.FCurrentHookQTY,t1.FStdCurrentHookAmount,t1.FPlanMode,t1.FMTONo,
t1.FOrderType,t1.FBatchNo,t1.FItemStatementBillNO,t1.FItemStatementEntryID,t1.FItemStatementInterID
from #tmp201 t1
left join #tmp07 t2 on t1.FItemID=t2.FItemID
left join #tmp08 t3 on t1.FUnitID=t3.FItemID
left join #tmp10 t4 on t1.FInterID=t4.FInterID and t1.FEntryID = t4.FEntryID
where t1.FInterID=@FInterID

EXEC p_UpdateBillRelateData @FTranType,@FNInterID,'ICPurchase','ICPurchaseEntry' 

INSERT INTO ICPurchase
(FInterID,FBillNo,FBrNo,FTranType,FCancellation,
FStatus,FROB,FClassTypeID,FSubSystemID,FYear,
FPeriod,FItemClassID,FFincDate,FHookStatus,FTotalCostFor,
FTotalCost,Fdate,FSupplyID,FTaxNum,FCheckDate,
FDeptID,FEmpID,FBillerName,FCurrencyID,FInvStyle,
FExchangeRateType,FExchangeRate,FCompactNo,Fnote,FBillerID,
FPOStyle,FYearPeriod,FMultiCheckDate1,FMultiCheckDate2,FPOOrdBillNo,
FMultiCheckDate3,FMultiCheckDate4,FMultiCheckDate5,FMultiCheckDate6,FPrintCount,
FYtdIntRate,FAcctID,FOrgBillInterID,FHookerID,FSelTranType,
FBrID,FManagerID,FCussentAcctID,FPayCondition,FSettleDate,FSysStatus,FCheckerID) 
SELECT @FNInterID,@FBillNo,@FBrNo,@FTranType,@FCancellation,
@FStatus,@FROB,@FClassTypeID,@FSubSystemID,@FYear,
@FPeriod,@FItemClassID,@FFincDate,@FHookStatus,@FTotalCostFor,
@FTotalCost,@Fdate,@FSupplyID,@FTaxNum,@FCheckDate,
@FDeptID,@FEmpID,@FBillerName,@FCurrencyID,@FInvStyle,
@FExchangeRateType,@FExchangeRate,@FCompactNo,@Fnote,@FBillerID,
@FPOStyle,@FYearPeriod,@FMultiCheckDate1,@FMultiCheckDate2,@FPOOrdBillNo,
@FMultiCheckDate3,@FMultiCheckDate4,@FMultiCheckDate5,@FMultiCheckDate6,@FPrintCount,
@FYtdIntRate,@FAcctID,@FOrgBillInterID,@FHookerID,@FSelTranType,
@FBrID,@FManagerID,@FCussentAcctID,@FPayCondition,@FSettleDate,@FSysStatus,@FCheckerID

UPDATE ICPurchase SET FSysStatus = 2 WHERE FInterID = @FNInterID

--UPDATE ICPurchase SET FUUID=NEWID() WHERE FInterID=@FNInterID

declare @fcheck_fail int
declare @fsrccommitfield_prevalue decimal(28,13)
declare @fsrccommitfield_endvalue decimal(28,10)
declare @maxorder int 

--更新采购入库单的开票数量
update src set @fsrccommitfield_prevalue= isnull(src.fqtyinvoice,0),
     @fsrccommitfield_endvalue=@fsrccommitfield_prevalue+dest.fqty,
     @fcheck_fail=case isnull(@maxorder,0) when 1 then 0 else (case when (abs(src.fqty)>abs(@fsrccommitfield_prevalue) or abs(src.fqty)>abs(@fsrccommitfield_endvalue)) then @fcheck_fail else -1 end) end,
     src.fqtyinvoice=@fsrccommitfield_endvalue, --基本单位开票数量
     src.fauxqtyinvoice=@fsrccommitfield_endvalue/cast(t1.fcoefficient as float)  --开票数量
 from icstockbillentry src 
     inner join icstockbill srchead on src.finterid=srchead.finterid
     inner join 
 (select u1.fsourceinterid as fsourceinterid,u1.fsourceentryid,u1.fitemid,sum(u1.fqty) as fqty
 from  icpurchaseentry u1 
 where u1.finterid=@FNInterID
 group by u1.fsourceinterid,u1.fsourceentryid,u1.fitemid) dest 
 on dest.fsourceinterid = src.finterid
 and dest.fitemid = src.fitemid
 and src.fentryid = dest.fsourceentryid
 inner join t_measureunit t1 on src.funitid=t1.fitemid

 --更新采购订单的开票数量
 update src set @fsrccommitfield_prevalue= isnull(src.fqtyinvoice,0),
     @fsrccommitfield_endvalue=@fsrccommitfield_prevalue+dest.fqty,
     @fcheck_fail=case isnull(@maxorder,0) when 1 then 0 else (case when (1=1) then @fcheck_fail else -1 end) end,
     src.fqtyinvoice=@fsrccommitfield_endvalue,
     src.fauxqtyinvoice=@fsrccommitfield_endvalue/cast(t1.fcoefficient as float)
 from poorderentry src 
     inner join poorder srchead on src.finterid=srchead.finterid
     inner join 
 (select u1.forderinterid as fsourceinterid,u1.forderentryid,u1.fitemid,sum(u1.fqty) as fqty
 from  icpurchaseentry u1 
 where u1.finterid=@FNInterID
 group by u1.forderinterid,u1.forderentryid,u1.fitemid) dest 
 on dest.fsourceinterid = src.finterid
 and dest.fitemid = src.fitemid
 and src.fentryid = dest.forderentryid
 inner join t_measureunit t1 on src.funitid=t1.fitemid

 --更新外购入库的辅助单位开票数量
 update src set @fsrccommitfield_prevalue= isnull(src.fsecinvoiceqty,0),
     @fsrccommitfield_endvalue=@fsrccommitfield_prevalue+dest.fsecqty,
     @fcheck_fail=case isnull(@maxorder,0) when 1 then 0 else (case when (1=1) then @fcheck_fail else -1 end) end,
     src.fsecinvoiceqty=@fsrccommitfield_endvalue
 from icstockbillentry src 
     inner join icstockbill srchead on src.finterid=srchead.finterid
     inner join 
 (select u1.fsourceinterid as fsourceinterid,u1.fsourceentryid,u1.fitemid,sum(u1.fsecqty) as fsecqty
 from  icpurchaseentry u1 
 where u1.finterid=@FNInterID
 group by u1.fsourceinterid,u1.fsourceentryid,u1.fitemid) dest 
 on dest.fsourceinterid = src.finterid
 and dest.fitemid = src.fitemid
 and src.fentryid = dest.fsourceentryid

 --更新采购订单的辅助单位开票数量
 update src set @fsrccommitfield_prevalue= isnull(src.fsecinvoiceqty,0),
     @fsrccommitfield_endvalue=@fsrccommitfield_prevalue+dest.fsecqty,
     @fcheck_fail=case isnull(@maxorder,0) when 1 then 0 else (case when (1=1) then @fcheck_fail else -1 end) end,
     src.fsecinvoiceqty=@fsrccommitfield_endvalue
 from poorderentry src 
     inner join poorder srchead on src.finterid=srchead.finterid
     inner join 
 (select u1.forderinterid as fsourceinterid,u1.forderentryid,u1.fitemid,sum(u1.fsecqty) as fsecqty
 from  icpurchaseentry u1 
 where u1.finterid=@FNInterID
 group by u1.forderinterid,u1.forderentryid,u1.fitemid) dest 
 on dest.fsourceinterid = src.finterid
 and dest.fitemid = src.fitemid
 and src.fentryid = dest.forderentryid

 --更新外购入库的
 update src set @fsrccommitfield_prevalue= isnull(src.fcommitamt,0),
     @fsrccommitfield_endvalue=@fsrccommitfield_prevalue+dest.famount,
     @fcheck_fail=case isnull(@maxorder,0) when 1 then 0 else (case when (1=1) then @fcheck_fail else -1 end) end,
     src.fcommitamt=@fsrccommitfield_endvalue
 from icstockbillentry src 
     inner join icstockbill srchead on src.finterid=srchead.finterid
     inner join 
 (select u1.fsourceinterid as fsourceinterid,u1.fsourceentryid,u1.fitemid,sum(u1.famount) as famount
 from  icpurchaseentry u1 
 where u1.finterid=@FNInterID
 group by u1.fsourceinterid,u1.fsourceentryid,u1.fitemid) dest 
 on dest.fsourceinterid = src.finterid
 and dest.fitemid = src.fitemid
 and src.fentryid = dest.fsourceentryid

 IF EXISTS (SELECT 1 FROM ICBillRelations_Purchase WHERE FBillType = 75 AND FBillID=@FNInterID)
BEGIN
    UPDATE t1 SET t1.FChildren=t1.FChildren+1
    FROM ICStockBill t1 INNER JOIN ICStockBillEntry t2 ON     t1.FInterID=t2.FInterID
    INNER JOIN ICBillRelations_Purchase t3 ON t3.FMultiEntryID=t2.FEntryID AND t3.FMultiInterID=t2.FInterID
    WHERE t3.FBillType=@FTranType AND t3.FBillID=@FNInterID
END
ELSE
BEGIN
    UPDATE t3 SET t3.FChildren=t3.FChildren+1
    FROM ICPurchase t1 INNER JOIN ICPurchaseEntry     t2 ON t1.FInterID=t2.FInterID
    INNER JOIN ICStockBill t3 ON t3.FTranType=t2.FSourceTranType AND t3.FInterID=t2.FSourceInterID
    WHERE t1.FTranType=@FTranType AND t1.FInterID=@FNInterID AND t2.FSourceInterID>0
END

--更新采购订单
 Update Src
       Set Src.FReceiveAmountFor_Commit=Src.FReceiveAmountFor_Commit + (IsNull(Dest.FCommitAmtFor, 0) * IsNull(Dest.FExchangeRate, 1) / IsNull(Head.FExchangeRate, 1)), 
       Src.FReceiveAmount_Commit=Src.FReceiveAmount_Commit+ISNull(Dest.FCommitAmt,0)
 From POOrderEntry Src Inner Join POOrder Head On Src.FInterID=Head.FInterID 
 Inner Join  (
            Select isnull(ti.FOrderInterID,t1.FOrderInterID) as FOrderInterID,isnull(ti.FOrderEntryID,t1.FOrderEntryID) as FOrderEntryID,t1.Fitemid,
              sum(case when ti.FOrderInterID is null then (Case t2.FTranType  When 75 Then t1.FAmountIncludeTax  When 76 Then  t1.FAmount Else 0  End) else ti.FQty*(Case t2.FTranType  When 75 Then t1.FAmountIncludeTax  When 76 Then  t1.FAmount Else 0  End)/t1.FQty end) as FCommitAmtFor,
              sum(case when ti.FOrderInterID is null then (Case t2.FTranType  When 75 Then t1.FStdAmountIncludeTax When 76 Then  t1.FStdAmount Else 0 End)  else ti.FQty*(Case t2.FTranType  When 75 Then t1.FStdAmountIncludeTax When 76 Then  t1.FStdAmount Else 0 End)/t1.FQty end) as FCommitAmt,
              t2.FExchangeRate
              From ICPurchaseEntry t1 left Join ICPurchase t2 On t1.FInterID=t2.FInterID 
                   left join (select a.fbillid,a.FDestEntryID,b.FOrderInterID,b.FOrderEntryID,a.fqty from ICBillRelations_Purchase a 
                               join ICStockBillEntry b on a.FMultiInterID=b.FInterID and a.FMultiEntryID=b.fentryid ) ti on t1.FInterID=ti.FBillID and t1.FEntryID=ti.FDestEntryID							                 Where t2.FTranType in (75,76) and t2.FPOStyle=251 and t1.FOrderInterID>0 and t2.FInterID= @FNInterID              Group by isnull(ti.FOrderInterID,t1.FOrderInterID),isnull(ti.FOrderEntryID,t1.FOrderEntryID), t1.FItemID,t2.FTranType,t2.FExchangeRate 
 ) Dest on Dest.FOrderInterID = Src.FInterID 
 and Dest.Fitemid = Src.Fitemid and Src.Fentryid = Dest.FOrderEntryID 

update ICPurchase set FFincDate=FDate,  FYear=@FYear, FPeriod=@FPeriod where FinterID=@FNInterID

Update e
SET e.FRemainAmount=(case h.FClassTypeID when 1000003 then e.FStdAmount else e.FStdAmountincludetax end),
       e.FRemainAmountFor=(case h.FClassTypeID when 1000003 then e.FAmount else e.FAmountincludetax end),
       e.FRemainQty=e.FAuxQty,e.FClassID_SRC=e.FSourceTranType
from ICPurchaseEntry e join ICPurchase h on e.FinterID=h.FinterID
Where e.FinterID = @FNInterID

Update t1
    set t1.FAdjustExchangeRate=case when t2.FOperator='/' then 1/t1.FExchangerate else t1.FExchangerate end, 
        t1.FCheckStatus=(case t1.FPoStyle when 251 then 1 else 0 end),t1.FArapStatus=(case t1.FPoStyle when 251 then 4 else 0 end)
from ICPurchase t1
    inner join t_Currency t2 on t1.FCurrencyID=t2.FCurrencyID
where t1.FinterID = @FNInterID

--新增付款计划
 insert into t_rp_plan_ap
 (FOrgID,FDate,FAmount,FAmountFor, FRemainAmount,
 FRemainAmountFor,FRP,FinterID) 
 select FOrgID,FDate,FAmount,FAmountFor, FRemainAmount,
 FRemainAmountFor,FRP,@FNInterID
 from AIS20121023172833.dbo.t_rp_plan_ap
 where FInterID=@FInterID

  --应收、应付往来表                                                                                                                                                                                                                                                       
 INSERT INTO t_RP_Contact 
 (FYear,FPeriod,FRP,FType,FDate,
 FFincDate,FNumber,FCustomer,FDepartment,FEmployee,
 FCurrencyID,FExchangeRate,FAmount,FAmountFor,FRemainAmount,
 FRemainAmountFor,FInvoiceID,FRPDate,FK3Import,FInterestRate,
 FBillType,finvoicetype,FItemClassID,FExplanation,FPreparer) 
 select FYear,FPeriod,FRP,FType,FDate,
 FFincDate,FNumber,FCustomer,FDepartment,FEmployee,
 FCurrencyID,FExchangeRate,FAmount,FAmountFor,FRemainAmount,
 FRemainAmountFor,@FNInterID,FRPDate,FK3Import,FInterestRate,
 FBillType,finvoicetype,FItemClassID,FExplanation,FPreparer
 from AIS20121023172833.dbo.t_RP_Contact
 where FInvoiceID=@FInterID

update t_rp_plan_ap set FOrgID=(select max(FOrgID)+1 from t_rp_plan_ap) where FIsinit=0 and FinterID=@FNInterID and FRP=0

Update ICPurchase Set FSubSystemID=0 Where  Ftrantype in(75,76) and FInterID=@FNInterID

Update v1 set v1.FOrderPrice=round(u1.FPrice *w1.FExchangeRate*(100-u1.FDiscountRate)/100,t1.FPriceDecimal)
From t_ICItemCore v1 
Right Join ICPurchaseEntry u1  On v1.FItemID=u1.FItemID 
Left Join ICPurchase w1 On u1.FInterID=w1.FInterID 
Left Join t_ICItem t1 On t1.FItemID =u1.FItemID 
Where u1.finterid=@FNInterID
And u1.FEntryID=(Select Max(FEntryid) From ICPurchaseEntry Where FInterid=u1.FInterid and FItemid=u1.FItemid)

UPDATE ICPurchaseEntry SET FAmountMustOld=FAmountMust,FNoMustOld=FNoMust,FDeductTaxOld=FDeductTax WHERE FInterID=@FNInterID

update t1 set t1.FRelateInvoiceID=@FNInterID 
from ICStockBill t1
where exists
(
select FSourceInterId
from ICPurchaseEntry
where FInterID=@FNInterID and FSourceInterId=t1.FInterID
)

update icpurchase  set FCheckerID=@FCheckerID ,FArApStatus=FArApStatus | 1  ,fcheckdate=getdate()  where FInterID=@FNInterID 

UPDATE ICPurchase SET FCheckerID=@FCheckerID,FStatus=1
,FCheckDate=@FCheckDate WHERE FInterID=@FNInterID

--同步记录表
--数据表ICPurChase同步记录登记
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNInterID,t1.FEntryID,t2.FName,t2.FNumber,@FBillNo,
'采购发票',5,@FStatus,0,null,
@FInterID,t1.FEntryID,0,null
from ICPurchaseEntry t1
left join t_ICItem t2 on t1.FItemID=t2.FItemID
where t1.FInterID=@FNInterID

fetch next from mycursor into @FInterID,@FBillNo,@FBrNo,@FTranType,@FCancellation,
@FStatus,@FROB,@FClassTypeID,@FSubSystemID,@FYear,
@FPeriod,@FItemClassID,@FFincDate,@FHookStatus,@FTotalCostFor,
@FTotalCost,@Fdate,@FSupplyID,@FTaxNum,@FCheckDate,
@FDeptID,@FEmpID,@FBillerName,@FCurrencyID,@FInvStyle,
@FExchangeRateType,@FExchangeRate,@FCompactNo,@Fnote,@FBillerID,
@FPOStyle,@FYearPeriod,@FMultiCheckDate1,@FMultiCheckDate2,@FPOOrdBillNo,
@FMultiCheckDate3,@FMultiCheckDate4,@FMultiCheckDate5,@FMultiCheckDate6,@FPrintCount,
@FYtdIntRate,@FAcctID,@FOrgBillInterID,@FHookerID,@FSelTranType,
@FBrID,@FManagerID,@FCussentAcctID,@FPayCondition,@FSettleDate,@FSysStatus,@FCheckerID
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
drop table #tmp10
drop table #tmp11
drop table #tmp1
drop table #tmp200
drop table #tmp201
drop table #tmp202
set nocount off 
end 

--exec pro_HT_ICPurchaseSync
--update ICPurchase set fcheckerid=0,fcheckdate=null,fstatus=0 where (FTrantype=75 or FTranType=76) and (FClassTypeID=1000003 or FClassTypeID=1000004)
--delete from ICPurchase where (FTrantype=75 or FTranType=76) and (FClassTypeID=1000003 or FClassTypeID=1000004)
--delete from t_HT_SyncControl where FType='采购发票'