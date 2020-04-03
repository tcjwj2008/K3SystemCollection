alter procedure pro_HT_SEOrderSync
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

--1.2获取同步客户列表
select *
into #tmp02
from
(
--1.2.1获取同步不转换客户列表
select t1.*,t2.FItemID as FOItemID,t3.FItemID as FNItemID
from t_item_3005 t1
left join AIS20121023172833.dbo.t_Organization t2 on t1.F_101=t2.FNumber
left join t_Organization t3 on t1.F_101=t3.FNumber
where isnull(F_103,'')=''
union all
--1.2.2获取同步转换客户列表
select t1.*,t2.FItemID as FOItemID,t3.FItemID as FNItemID
from t_item_3005 t1
left join AIS20121023172833.dbo.t_Organization t2 on t1.F_101=t2.FNumber
left join t_Organization t3 on t1.F_103=t3.FNumber
where isnull(F_103,'')<>''
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

--1.9获取客户单价转换列表
select F_101 as 原客户代码,F_102 as 原客户名称,F_103 as 物料规格型号,
F_104 as 单价系数,F_105 as 规格型号关联关系, F_106 as 备注,F_107 as 优先级 
into #tmp09
from t_item_3006 t1
left join t_item t2 on t1.FItemID=t2.FItemID
where t2.FDeleted=0

--1.11获取仓库同步列表
select t1.F_103 as 物料代码首字母,t1.F_104 as 同步到新仓库代码,t1.F_101 as 同步到新仓库名称,t3.FItemID as 新仓库内码
into #tmp11
from t_item_3004 t1
left join t_Stock t3 on t1.f_104=t3.FNumber
left join t_item t4 on t1.FItemID=t4.FItemID
where t4.FDeleted=0

--2.0获取需要同步过来的销售订单
--2.00获取可以同步的物料
--只同步物料首字母1、2、A、B、C、D开头的
--如果一个订单，订单明细的物料都是不可同步，那整单会被排除掉
select * 
into #tmp200
from AIS20121023172833.dbo.t_ICItem t1
where exists (select * from #tmp11 where 物料代码首字母=left(t1.FNumber,1))

--2.01获取可以同步的销售订单
select t1.*
into #tmp201
from AIS20121023172833.dbo.SEOrderEntry t1
left join AIS20121023172833.dbo.SEOrder t2 on t1.FInterID=t2.FInterID
where (1=1)
and t2.FDate>='2018-01-01'
and t2.FCancellation=0
and t2.FStatus>0
and exists
( select * from #tmp200 where FItemID=t1.FItemID)
and not exists 
( select * from t_HT_SyncControl where FOID=t1.FInterID and FType='销售订单')

--2.02获取可以同步销售订单的FInterID
select FInterID
into #tmp202
from #tmp201
group by FInterID

--2.获取销售订单旧帐套单据头数据(审核后数据)
select t1.*,t3.FNUserID as FNBillerID,t4.FNUserID as FNCheckerID,t2.FNItemID as FNCustID ,t2.F_101 as FOCustNumber,
t5.FNItemID as FNEmpID,t6.FNItemID as FNManagerID,t7.FNItemID as FNDeptID
into #tmp1
from AIS20121023172833.dbo.SEOrder t1
inner join #tmp02 t2 on t1.FCustID=t2.FOItemID
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
(select * from t_HT_SyncControl where FOID=t1.FInterID and FType='销售订单')
and exists --可以同步的销售订单内码，已排除不能同步的物料
(select * from #tmp202 where FInterID=t1.FInterID)

--3.获取销售订单列表，写入新帐套
declare @FNInterID bigint
declare @FInterID bigint
declare @FBillNo varchar(100)  
declare @FBrNo varchar(100) --公司机构内码
declare @FTranType bigint  --单据类型 
declare @FCancellation bigint --作废 0-未作废，1-作废
declare @FStatus bigint --状态 0-未审核，1-已审核，2-部分关联，3-全部关联  
declare @FDiscountType bigint  --折扣方式
declare @Fdate datetime --单据日期  
declare @FCustAddress bigint
declare @FSaleStyle bigint --销售方式
declare @FFetchStyle varchar(100)  --交货方式
declare @FCurrencyID bigint --币别  
declare @FCustID bigint --客户
declare @FFetchAdd varchar(100)  --交货地点
declare @FCheckDate  datetime --审核日期
declare @FMangerID bigint --主管  
declare @FDeptID bigint --部门 
declare @FEmpID bigint --业务员
declare @FBillerID bigint --制单人
declare @FSettleID bigint --结算方式
declare @FExchangeRateType bigint ----汇率类型
declare @FExchangeRate decimal(21,2)   --汇率
declare @FMultiCheckLevel1 bigint --一审
declare @FMultiCheckDate1 datetime 
declare @FMultiCheckLevel2 bigint
declare @FMultiCheckDate2 datetime 
declare @FMultiCheckLevel3 bigint
declare @FMultiCheckDate3 datetime 
declare @FMultiCheckLevel4 bigint
declare @FMultiCheckDate4 datetime 
declare @FMultiCheckLevel5 bigint
declare @FMultiCheckDate5 datetime 
declare @FMultiCheckLevel6 bigint 
declare @FMultiCheckDate6 datetime 
declare @FPOOrdBillNo varchar(100) --分销订单号
declare @FRelateBrID bigint --供货机构
declare @FTransitAheadTime float --运输提前期
declare @FImport bigint  --引入标志
declare @FSelTranType bigint --源单类型
declare @FBrID bigint --制单机构
declare @FSettleDate datetime --结算日期
declare @FExplanation varchar(500) --摘要
declare @FAreaPS bigint --销售范围
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
declare @FPlanCategory bigint --计划类别  
declare @FEnterpriseID bigint
declare @FSendStatus bigint
declare @FCheckerID bigint --审核人
declare @FOCustNumber varchar(100) --新帐套客户代码

--按客户单价转换列表来修改单价，需要用到的临时变量
declare @uFAuxPrice decimal(21,10)  --基本单位单价
declare @uFPrice  decimal(21,10)  --单价

declare @单价系数 varchar(10) 
declare @物料规格型号 varchar(100)


declare mycursor cursor for 
select FInterID,FBillNo,FBrNo,FTranType,FCancellation,
FStatus,FDiscountType,Fdate,FCustAddress,FSaleStyle,
FFetchStyle,FCurrencyID,FNCustID,FFetchAdd,FCheckDate,
FNManagerID,FNDeptID,FNEmpID,FNBillerID,FSettleID,
FExchangeRateType,FExchangeRate,FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,
FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,FMultiCheckDate4,
FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FPOOrdBillNo,
FRelateBrID,FTransitAheadTime,FImport,FSelTranType,FBrID,
FSettleDate,FExplanation,FAreaPS,FManageType,FSysStatus,
FValidaterName,FConsignee,FVersionNo,FChangeDate,FChangeUser,
FChangeCauses,FChangeMark,FPrintCount,FPlanCategory,FEnterpriseID,
FSendStatus,FNCheckerID,FOCustNumber
from #tmp1 
open mycursor 
fetch next from mycursor into @FInterID,@FBillNo,@FBrNo,@FTranType,@FCancellation,
@FStatus,@FDiscountType,@Fdate,@FCustAddress,@FSaleStyle,
@FFetchStyle,@FCurrencyID,@FCustID,@FFetchAdd,@FCheckDate,
@FMangerID,@FDeptID,@FEmpID,@FBillerID,@FSettleID,
@FExchangeRateType,@FExchangeRate,@FMultiCheckLevel1,@FMultiCheckDate1,@FMultiCheckLevel2,
@FMultiCheckDate2,@FMultiCheckLevel3,@FMultiCheckDate3,@FMultiCheckLevel4,@FMultiCheckDate4,
@FMultiCheckLevel5,@FMultiCheckDate5,@FMultiCheckLevel6,@FMultiCheckDate6,@FPOOrdBillNo,
@FRelateBrID,@FTransitAheadTime,@FImport,@FSelTranType,@FBrID,
@FSettleDate,@FExplanation,@FAreaPS,@FManageType,@FSysStatus,
@FValidaterName,@FConsignee,@FVersionNo,@FChangeDate,@FChangeUser,
@FChangeCauses,@FChangeMark,@FPrintCount,@FPlanCategory,@FEnterpriseID,
@FSendStatus,@FCheckerID,@FOCustNumber
while (@@fetch_status=0) 
begin 
--生成新帐套SEOrder的最新FInterID
set @FNInterID=0
exec GetICMaxNum 'SEOrder',@FNInterID output,1,16394

--写入分录体
INSERT INTO SEOrderEntry 
(FInterID,FEntryID,FBrNo,FMapNumber,FMapName,
FItemID,FAuxPropID,FQty,FUnitID,Fauxqty,
FSecCoefficient,FSecQty,Fauxprice,FAuxTaxPrice,Famount,
FCess,FTaxRate,FUniDiscount,FTaxAmount,FAuxPriceDiscount,
FTaxAmt,FAllAmount,FTranLeadTime,FInForecast,FDate,
Fnote,FPlanMode,FMTONo,FBOMCategory,FBomInterID,
FOrderBOMStatus,FCostObjectID,FAdviceConsignDate,FATPDeduct,FLockFlag,
FSourceBillNo,FSourceTranType,FSourceInterId,FSourceEntryID,FContractBillNo,
FContractInterID,FContractEntryID,FSecCommitInstall,FCommitInstall,FAuxCommitInstall,
FAllStdAmount,FMrpLockFlag,FHaveMrp,FReceiveAmountFor_Commit,FOrderBOMInterID,
FOrderBillNo,FOrderEntryID,FOutSourceInterID,FOutSourceEntryID,FOutSourceTranType)  
select @FNInterID,t1.FEntryID,t1.FBrNo,t1.FMapNumber,t1.FMapName,
t2.FNItemID,t1.FAuxPropID,t1.FQty,t3.FNItemID,t1.Fauxqty,
t1.FSecCoefficient,t1.FSecQty,t1.Fauxprice,t1.FAuxTaxPrice,t1.Famount,
t1.FCess,t1.FTaxRate,t1.FUniDiscount,t1.FTaxAmount,t1.FAuxPriceDiscount,
t1.FTaxAmt,t1.FAllAmount,t1.FTranLeadTime,t1.FInForecast,t1.FDate,
t1.Fnote,t1.FPlanMode,t1.FMTONo,t1.FBOMCategory,t1.FBomInterID,
t1.FOrderBOMStatus,t1.FCostObjectID,t1.FAdviceConsignDate,t1.FATPDeduct,t1.FLockFlag,
t1.FSourceBillNo,t1.FSourceTranType,t1.FSourceInterId,t1.FSourceEntryID,t1.FContractBillNo,
t1.FContractInterID,t1.FContractEntryID,t1.FSecCommitInstall,t1.FCommitInstall,t1.FAuxCommitInstall,
t1.FAllStdAmount,t1.FMrpLockFlag,t1.FHaveMrp,t1.FReceiveAmountFor_Commit,t1.FOrderBOMInterID,
t1.FOrderBillNo,t1.FOrderEntryID,t1.FOutSourceInterID,t1.FOutSourceEntryID,t1.FOutSourceTranType
from #tmp201 t1
left join #tmp07 t2 on t1.FItemID=t2.FItemID
left join #tmp08 t3 on t1.FUnitID=t3.FItemID
where t1.FInterID=@FInterID

EXEC p_UpdateBillRelateData 81,@FNInterID,'SEOrder','SEOrderEntry' 

INSERT INTO SEOrder
(FInterID,FBillNo,FBrNo,FTranType,FCancellation,
FStatus,FDiscountType,Fdate,FCustAddress,FSaleStyle,
FFetchStyle,FCurrencyID,FCustID,FFetchAdd,FCheckDate,
FMangerID,FDeptID,FEmpID,FBillerID,FSettleID,
FExchangeRateType,FExchangeRate,FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,
FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,FMultiCheckDate4,
FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FPOOrdBillNo,
FRelateBrID,FTransitAheadTime,FImport,FSelTranType,FBrID,
FSettleDate,FExplanation,FAreaPS,FManageType,FSysStatus,
FValidaterName,FConsignee,FVersionNo,FChangeDate,FChangeUser,
FChangeCauses,FChangeMark,FPrintCount,FPlanCategory,FEnterpriseID,
FSendStatus,FCheckerID) 
select @FNInterID,@FBillNo,@FBrNo,@FTranType,@FCancellation,
@FStatus,@FDiscountType,@Fdate,@FCustAddress,@FSaleStyle,
@FFetchStyle,@FCurrencyID,@FCustID,@FFetchAdd,@FCheckDate,
@FMangerID,@FDeptID,@FEmpID,@FBillerID,@FSettleID,
@FExchangeRateType,@FExchangeRate,@FMultiCheckLevel1,@FMultiCheckDate1,@FMultiCheckLevel2,
@FMultiCheckDate2,@FMultiCheckLevel3,@FMultiCheckDate3,@FMultiCheckLevel4,@FMultiCheckDate4,
@FMultiCheckLevel5,@FMultiCheckDate5,@FMultiCheckLevel6,@FMultiCheckDate6,@FPOOrdBillNo,
@FRelateBrID,@FTransitAheadTime,@FImport,@FSelTranType,@FBrID,
@FSettleDate,@FExplanation,@FAreaPS,@FManageType,@FSysStatus,
@FValidaterName,@FConsignee,@FVersionNo,@FChangeDate,@FChangeUser,
@FChangeCauses,@FChangeMark,@FPrintCount,@FPlanCategory,@FEnterpriseID,
@FSendStatus,@FCheckerID

UPDATE SEOrder SET FSysStatus = 2 WHERE FInterID = @FNInterID

UPDATE SEOrder SET FUUID=NEWID() WHERE FInterID=@FNInterID


declare mycursor2 cursor for 
select 单价系数,物料规格型号
from #tmp09 
where 原客户代码=@FOCustNumber
order by 优先级 asc
open mycursor2 
fetch next from mycursor2 into @单价系数,@物料规格型号 
while (@@fetch_status=0) 
begin 
if isnull(@物料规格型号,'')=''
begin
set @物料规格型号='%'
end

update t1 set @uFAuxPrice=(t4.FAuxPrice*convert(decimal(21,2),@单价系数)),
@uFPrice=(t4.FPrice*convert(decimal(21,2),@单价系数)),
t1.FQty=t4.FAuxQty * t0.FCoefficient,  
t1.FAuxPrice=(t4.FAuxPrice*convert(decimal(21,2),@单价系数)),
t1.FPrice=(t4.FPrice*convert(decimal(21,2),@单价系数)),
t1.FAuxTaxPrice=(t4.FAuxPrice*convert(decimal(21,2),@单价系数)) * (1 + t1.FCESS/100), 
t1.FTaxPrice= (t4.FPrice*convert(decimal(21,2),@单价系数)) * (1 + t1.FCESS/100),
t1.FAuxPriceDiscount=(t4.FAuxPrice*convert(decimal(21,2),@单价系数)) * (1 + t1.FCESS/100) - t1.FUniDiscount,
t1.FPriceDiscount=(t4.FPrice*convert(decimal(21,2),@单价系数)) * (1 + t1.FCESS/100)- t1.FUniDiscount,
t1.FTaxAmt=(t4.FAuxPrice*convert(decimal(21,2),@单价系数)) * t4.FAuxQty * t1.FCESS/100 - t1.FTaxAmount / (1 + t1.FCESS/100) * t1.FCESS,
t1.FAmount= (t4.FAuxPrice*convert(decimal(21,2),@单价系数)) * t4.FAuxQty - t1.FTaxAmount / (1 + t1.FCESS/100),
t1.FAllAmount=(t4.FAuxPrice*convert(decimal(21,2),@单价系数)) * t4.FAuxQty * (1 + t1.FCESS/100)- t1.FTaxAmount,
t1.FAllStdAmount=((t4.FAuxPrice*convert(decimal(21,2),@单价系数)) * t4.FAuxQty * (1 + t1.FCESS/100)- t1.FTaxAmount)*t2.FExchangeRate
from SEOrderEntry t1
left join t_MeasureUnit t0 on t1.FUnitID=t0.FItemID
left join SEOrder t2 on t2.FInterID=t1.FInterID
left join t_ICItem t3 on t1.FItemID=t3.FItemID
left join (select * from AIS20121023172833.dbo.SEOrderEntry where FInterID=@FInterID) t4 on t1.FEntryID=t4.FEntryID
where t1.FInterID=@FNInterID
and t3.FModel like '%'+@物料规格型号+'%'

fetch next from mycursor2 into @单价系数,@物料规格型号 
end 
close mycursor2 
DEALLOCATE mycursor2 

SELECT v1.FBillNo,u1.FCostObjectID INTO #OldCostObject FROM SEOrder v1 INNER JOIN SEOrderEntry u1 ON v1.FInterID=u1.FInterID WHERE v1.FInterID=@FNInterID
SELECT v1.FBillNo,u1.FCostObjectID INTO #NewCostObject FROM SEOrder v1 INNER JOIN SEOrderEntry u1 ON v1.FInterID=u1.FInterID
 WHERE v1.FInterID=@FNInterID
 AND u1.FCostObjectID>0
 Update t1 Set FSBillNo='' FROM CBCostobj t1 INNER JOIN #OldCostObject t2 on t1.FSBillNo=t2.FBillNo 
 Update t1 Set FSBillNo=t2.FBillNo FROM CBCostobj t1 INNER JOIN #NewCostObject t2 on t2.FCostObjectID=t1.FItemID 
DROP TABLE #OldCostObject
DROP TABLE #NewCostObject

--价格政策
INSERT INTO IcPrcPlyEntry
(FItemID,FRelatedID,FAuxPropID,FInterID,
FUnitID,FBegQty,FEndQty,FCuryID,FPriceType,
FPrice,FBegDate,FEndDate,FLeadTime,FMainterID,
FMaintDate,FNote,FCheckerID,FCheckDate,Fchecked,FFlagSave) 
select t1.FItemID,t0.FCustID,0,2,
t1.FUnitID,0,0,t0.FCurrencyID,0,
t1.FTaxPrice,getdate(),'2100-01-01',0,16394,
getdate(),'',0,null,0,'{'+convert(varchar(200), NEWID())+'}'
from SEOrderEntry t1
left join SEOrder t0 on t1.FInterID=t0.FInterID
where t1.FInterID=@FNInterID
and not exists
(
select * from IcPrcPlyEntry where FItemID=t1.FItemID and FRelatedID=t0.FCustID
)

fetch next from mycursor into @FInterID,@FBillNo,@FBrNo,@FTranType,@FCancellation,
@FStatus,@FDiscountType,@Fdate,@FCustAddress,@FSaleStyle,
@FFetchStyle,@FCurrencyID,@FCustID,@FFetchAdd,@FCheckDate,
@FMangerID,@FDeptID,@FEmpID,@FBillerID,@FSettleID,
@FExchangeRateType,@FExchangeRate,@FMultiCheckLevel1,@FMultiCheckDate1,@FMultiCheckLevel2,
@FMultiCheckDate2,@FMultiCheckLevel3,@FMultiCheckDate3,@FMultiCheckLevel4,@FMultiCheckDate4,
@FMultiCheckLevel5,@FMultiCheckDate5,@FMultiCheckLevel6,@FMultiCheckDate6,@FPOOrdBillNo,
@FRelateBrID,@FTransitAheadTime,@FImport,@FSelTranType,@FBrID,
@FSettleDate,@FExplanation,@FAreaPS,@FManageType,@FSysStatus,
@FValidaterName,@FConsignee,@FVersionNo,@FChangeDate,@FChangeUser,
@FChangeCauses,@FChangeMark,@FPrintCount,@FPlanCategory,@FEnterpriseID,
@FSendStatus,@FCheckerID,@FOCustNumber
end 
close mycursor 
DEALLOCATE mycursor
drop table #tmp01
drop table #tmp02
drop table #tmp05
drop table #tmp06
drop table #tmp07
drop table #tmp08
drop table #tmp09
drop table #tmp11
drop table #tmp1
drop table #tmp200
drop table #tmp201
drop table #tmp202
set nocount off
end 

--exec pro_HT_SEOrderSync