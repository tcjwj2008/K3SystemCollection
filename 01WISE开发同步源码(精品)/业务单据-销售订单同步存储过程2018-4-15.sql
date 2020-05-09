alter procedure pro_HT_SEOrderSync
as 
begin
set nocount on
--1.1��ȡ�û�ת���б�
select t1.*,t2.FUserID as FOUserID,t3.FUserID as FNUserID
into #tmp01
from t_Item_3001 t1
left join AIS20121023172833.dbo.t_user t2 on t1.F_101=t2.FName
left join t_user t3 on t1.F_102=t3.FName
left join t_item t4 on t1.FItemID=t4.FItemID
where t4.FDeleted=0

--1.2��ȡͬ���ͻ��б�
select *
into #tmp02
from
(
--1.2.1��ȡͬ����ת���ͻ��б�
select t1.*,t2.FItemID as FOItemID,t3.FItemID as FNItemID
from t_item_3005 t1
left join AIS20121023172833.dbo.t_Organization t2 on t1.F_101=t2.FNumber
left join t_Organization t3 on t1.F_101=t3.FNumber
where isnull(F_103,'')=''
union all
--1.2.2��ȡͬ��ת���ͻ��б�
select t1.*,t2.FItemID as FOItemID,t3.FItemID as FNItemID
from t_item_3005 t1
left join AIS20121023172833.dbo.t_Organization t2 on t1.F_101=t2.FNumber
left join t_Organization t3 on t1.F_103=t3.FNumber
where isnull(F_103,'')<>''
) s1

--1.5��ȡְԱ�б�
select t1.*,t2.FItemID as FNItemID
into #tmp05
from AIS20121023172833.dbo.t_Emp t1
left join t_Emp t2 on t1.FNumber=t2.FNumber
where t1.FDeleted=0

--1.6��ȡ�����б�
select t1.*,t2.FItemID as FNItemID
into #tmp06
from AIS20121023172833.dbo.t_Department t1
left join t_Department t2 on t1.FNumber=t2.FNumber
where t1.FDeleted=0

--1.7��ȡ�����б�
select t1.*,t2.FItemID as FNItemID
into #tmp07
from AIS20121023172833.dbo.t_ICItem t1
left join t_ICItem t2 on t1.FNumber=t2.FNumber
where t1.FDeleted=0

--1.8��ȡ������λ�б�
select t1.*,t2.FItemID as FNItemID
into #tmp08
from AIS20121023172833.dbo.t_MeasureUnit t1
left join t_MeasureUnit t2 on t1.FNumber=t2.FNumber
where t1.FDeleted=0

--1.9��ȡ�ͻ�����ת���б�
select F_101 as ԭ�ͻ�����,F_102 as ԭ�ͻ�����,F_103 as ���Ϲ���ͺ�,
F_104 as ����ϵ��,F_105 as ����ͺŹ�����ϵ, F_106 as ��ע,F_107 as ���ȼ� 
into #tmp09
from t_item_3006 t1
left join t_item t2 on t1.FItemID=t2.FItemID
where t2.FDeleted=0

--1.11��ȡ�ֿ�ͬ���б�
select t1.F_103 as ���ϴ�������ĸ,t1.F_104 as ͬ�����²ֿ����,t1.F_101 as ͬ�����²ֿ�����,t3.FItemID as �²ֿ�����
into #tmp11
from t_item_3004 t1
left join t_Stock t3 on t1.f_104=t3.FNumber
left join t_item t4 on t1.FItemID=t4.FItemID
where t4.FDeleted=0

--2.0��ȡ��Ҫͬ�����������۶���
--2.00��ȡ����ͬ��������
--ֻͬ����������ĸ1��2��A��B��C��D��ͷ��
--���һ��������������ϸ�����϶��ǲ���ͬ�����������ᱻ�ų���
select * 
into #tmp200
from AIS20121023172833.dbo.t_ICItem t1
where exists (select * from #tmp11 where ���ϴ�������ĸ=left(t1.FNumber,1))

--2.01��ȡ����ͬ�������۶���
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
( select * from t_HT_SyncControl where FOID=t1.FInterID and FType='���۶���')

--2.02��ȡ����ͬ�����۶�����FInterID
select FInterID
into #tmp202
from #tmp201
group by FInterID

--2.��ȡ���۶��������׵���ͷ����(��˺�����)
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
(select * from t_HT_SyncControl where FOID=t1.FInterID and FType='���۶���')
and exists --����ͬ�������۶������룬���ų�����ͬ��������
(select * from #tmp202 where FInterID=t1.FInterID)

--3.��ȡ���۶����б�д��������
declare @FNInterID bigint
declare @FInterID bigint
declare @FBillNo varchar(100)  
declare @FBrNo varchar(100) --��˾��������
declare @FTranType bigint  --�������� 
declare @FCancellation bigint --���� 0-δ���ϣ�1-����
declare @FStatus bigint --״̬ 0-δ��ˣ�1-����ˣ�2-���ֹ�����3-ȫ������  
declare @FDiscountType bigint  --�ۿ۷�ʽ
declare @Fdate datetime --��������  
declare @FCustAddress bigint
declare @FSaleStyle bigint --���۷�ʽ
declare @FFetchStyle varchar(100)  --������ʽ
declare @FCurrencyID bigint --�ұ�  
declare @FCustID bigint --�ͻ�
declare @FFetchAdd varchar(100)  --�����ص�
declare @FCheckDate  datetime --�������
declare @FMangerID bigint --����  
declare @FDeptID bigint --���� 
declare @FEmpID bigint --ҵ��Ա
declare @FBillerID bigint --�Ƶ���
declare @FSettleID bigint --���㷽ʽ
declare @FExchangeRateType bigint ----��������
declare @FExchangeRate decimal(21,2)   --����
declare @FMultiCheckLevel1 bigint --һ��
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
declare @FPOOrdBillNo varchar(100) --����������
declare @FRelateBrID bigint --��������
declare @FTransitAheadTime float --������ǰ��
declare @FImport bigint  --�����־
declare @FSelTranType bigint --Դ������
declare @FBrID bigint --�Ƶ�����
declare @FSettleDate datetime --��������
declare @FExplanation varchar(500) --ժҪ
declare @FAreaPS bigint --���۷�Χ
declare @FManageType bigint --��˰�������    
declare @FSysStatus bigint --ϵͳ����    
declare @FValidaterName varchar(100) --ȷ����
declare @FConsignee varchar(100) --�ջ���  
declare @FVersionNo varchar(100) --�汾�� 
declare @FChangeDate datetime --�������  
declare @FChangeUser bigint --����� 
declare @FChangeCauses varchar(500) --���ԭ��  
declare @FChangeMark varchar(100) --�����־:  
declare @FPrintCount bigint --��ӡ����    
declare @FPlanCategory bigint --�ƻ����  
declare @FEnterpriseID bigint
declare @FSendStatus bigint
declare @FCheckerID bigint --�����
declare @FOCustNumber varchar(100) --�����׿ͻ�����

--���ͻ�����ת���б����޸ĵ��ۣ���Ҫ�õ�����ʱ����
declare @uFAuxPrice decimal(21,10)  --������λ����
declare @uFPrice  decimal(21,10)  --����

declare @����ϵ�� varchar(10) 
declare @���Ϲ���ͺ� varchar(100)


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
--����������SEOrder������FInterID
set @FNInterID=0
exec GetICMaxNum 'SEOrder',@FNInterID output,1,16394

--д���¼��
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
select ����ϵ��,���Ϲ���ͺ�
from #tmp09 
where ԭ�ͻ�����=@FOCustNumber
order by ���ȼ� asc
open mycursor2 
fetch next from mycursor2 into @����ϵ��,@���Ϲ���ͺ� 
while (@@fetch_status=0) 
begin 
if isnull(@���Ϲ���ͺ�,'')=''
begin
set @���Ϲ���ͺ�='%'
end

update t1 set @uFAuxPrice=(t4.FAuxPrice*convert(decimal(21,2),@����ϵ��)),
@uFPrice=(t4.FPrice*convert(decimal(21,2),@����ϵ��)),
t1.FQty=t4.FAuxQty * t0.FCoefficient,  
t1.FAuxPrice=(t4.FAuxPrice*convert(decimal(21,2),@����ϵ��)),
t1.FPrice=(t4.FPrice*convert(decimal(21,2),@����ϵ��)),
t1.FAuxTaxPrice=(t4.FAuxPrice*convert(decimal(21,2),@����ϵ��)) * (1 + t1.FCESS/100), 
t1.FTaxPrice= (t4.FPrice*convert(decimal(21,2),@����ϵ��)) * (1 + t1.FCESS/100),
t1.FAuxPriceDiscount=(t4.FAuxPrice*convert(decimal(21,2),@����ϵ��)) * (1 + t1.FCESS/100) - t1.FUniDiscount,
t1.FPriceDiscount=(t4.FPrice*convert(decimal(21,2),@����ϵ��)) * (1 + t1.FCESS/100)- t1.FUniDiscount,
t1.FTaxAmt=(t4.FAuxPrice*convert(decimal(21,2),@����ϵ��)) * t4.FAuxQty * t1.FCESS/100 - t1.FTaxAmount / (1 + t1.FCESS/100) * t1.FCESS,
t1.FAmount= (t4.FAuxPrice*convert(decimal(21,2),@����ϵ��)) * t4.FAuxQty - t1.FTaxAmount / (1 + t1.FCESS/100),
t1.FAllAmount=(t4.FAuxPrice*convert(decimal(21,2),@����ϵ��)) * t4.FAuxQty * (1 + t1.FCESS/100)- t1.FTaxAmount,
t1.FAllStdAmount=((t4.FAuxPrice*convert(decimal(21,2),@����ϵ��)) * t4.FAuxQty * (1 + t1.FCESS/100)- t1.FTaxAmount)*t2.FExchangeRate
from SEOrderEntry t1
left join t_MeasureUnit t0 on t1.FUnitID=t0.FItemID
left join SEOrder t2 on t2.FInterID=t1.FInterID
left join t_ICItem t3 on t1.FItemID=t3.FItemID
left join (select * from AIS20121023172833.dbo.SEOrderEntry where FInterID=@FInterID) t4 on t1.FEntryID=t4.FEntryID
where t1.FInterID=@FNInterID
and t3.FModel like '%'+@���Ϲ���ͺ�+'%'

fetch next from mycursor2 into @����ϵ��,@���Ϲ���ͺ� 
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

--�۸�����
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