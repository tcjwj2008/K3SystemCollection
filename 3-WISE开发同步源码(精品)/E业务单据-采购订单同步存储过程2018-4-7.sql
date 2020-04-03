--ͬ���Ĳɹ����ŴӾ�����ֱ�Ӵ�����
--�����������Ĳɹ����Ű�ϵͳ��׼����
--��ֹ�¾ɲɹ�����������ͻ���ظ����²ɹ����Ź���Ҫ��ͬ�ھɲɹ����Ź���
alter procedure pro_HT_POOrderSync
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

--1.2��ȡת����Ӧ���б�
select t1.*,t2.FItemID as FOItemID,t3.FItemID as FNItemID
into #tmp02
from t_item_3002 t1
left join AIS20121023172833.dbo.t_Supplier t2 on t1.F_103=t2.FNumber
left join t_Supplier t3 on t1.F_101=t3.FNumber
left join t_item t4 on t1.FItemID=t4.FItemID
where t4.FDeleted=0


--1.3��ȡ��ת����Ӧ���б�
select t1.*,t2.FItemID as FOItemID
into #tmp03
from t_item_3003 t1
left join AIS20121023172833.dbo.t_Supplier t2 on t1.F_101=t2.FNumber
left join t_item t4 on t1.FItemID=t4.FItemID
where t4.FDeleted=0

--1.4ת�������Ӧ��
--1.4.1ת����Ӧ�̴����ų���ͬ����Ӧ�̣�
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
--1.4.2������Ӧ�̴����ų���ͬ����Ӧ��,�ų�ת����Ӧ�̣�
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
select t1.*,t2.FItemID as FNItemID,t2.FNumber as FNNumber
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

--1.11��ȡ�ֿ�ͬ���б�
select t1.F_103 as ���ϴ�������ĸ,t1.F_104 as ͬ�����²ֿ����,t1.F_101 as ͬ�����²ֿ�����,t3.FItemID as �²ֿ�����
into #tmp11
from t_item_3004 t1
left join t_Stock t3 on t1.f_104=t3.FNumber
left join t_item t4 on t1.FItemID=t4.FItemID
where t4.FDeleted=0

--2.0��ȡ��Ҫͬ�������Ĳɹ�����
--2.00��ȡ����ͬ��������
--ֻͬ����������ĸ1��2��A��B��C��D��ͷ��
--���һ��������������ϸ�����϶��ǲ���ͬ�����������ᱻ�ų���
select * 
into #tmp200
from AIS20121023172833.dbo.t_ICItem t1
where exists (select * from #tmp11 where ���ϴ�������ĸ=left(t1.FNumber,1))

--2.01��ȡ����ͬ���Ĳɹ�����
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
(select * from t_HT_SyncControl where FOID=t1.FInterID and FType='�ɹ�����')

--2.02��ȡ����ͬ���ɹ�������FInterID
select FInterID
into #tmp202
from #tmp201
group by FInterID

--2.��ȡ�ɹ����������׵���ͷ����(��˺�����),�Ѿ��ų����ɹ���������ͬ�����ϵĵ���
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
(select * from t_HT_SyncControl where FOID=t1.FInterID and FType='�ɹ�����')
and exists  --����ͬ���Ĳɹ��������룬���ų�����ͬ��������
(select * from #tmp202 where FInterID=t1.FInterID)

--3.��ȡ�ɹ������б�д��������
declare @FNInterID bigint
declare @FInterID bigint
declare @FBillNo varchar(100)  
declare @FBrNo varchar(100) --��˾��������                                                                                                                                                                                                                                                         
declare @FTranType bigint  --�������� 71-�ɹ�����                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
declare @FCancellation bigint --���� 0-δ���ϣ�1-����                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
declare @FStatus bigint --״̬ 0-δ��ˣ�1-����ˣ�2-���ֹرգ�3-ȫ���ر�                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
declare @FSupplyID bigint --��Ӧ������                                                                                                                                                                                                                                                          
declare @Fdate datetime --��������                                                                                                                                                                                                                                                           
declare @FCurrencyID bigint --�ұ�                                                                                                                                                                                                                                                             
declare @FCheckDate datetime --�������
declare @FMangerID bigint --����                                                                                                                                                                                                                                                             
declare @FDeptID bigint --����                                                                                                                                                                                                                                                             
declare @FEmpID bigint --ҵ��Ա
declare @FBillerID bigint --�Ƶ���
declare @FExchangeRateType bigint ----��������
declare @FExchangeRate decimal(21,2)   --����                                                                                                                                                                                                                                                         
declare @FPOStyle bigint --�ɹ���ʽ                                                                                                                                                                                                                                                           
declare @FRelateBrID bigint --��������                                                                                                                                                                                                                                                           
declare @FMultiCheckDate1 datetime 
declare @FMultiCheckDate2 datetime
declare @FMultiCheckDate3 datetime 
declare @FMultiCheckDate4 datetime
declare @FMultiCheckDate5 datetime
declare @FMultiCheckDate6 datetime
declare @FSelTranType bigint --Դ������                                                                                                                                                                                                                                                           
declare @FBrID bigint --�Ƶ�����                                                                                                                                                                                                                                                           
declare @FExplanation varchar(500) --ժҪ
declare @FSettleID bigint --���㷽ʽ                                                                                                                                                                                                                                                           
declare @FSettleDate datetime --��������                                                                                                                                                                                                                                                           
declare @FAreaPS bigint --�ɹ���Χ                                                                                                                                                                                                                                                           
declare @FPOOrdBillNo varchar(100) --����������                                                                                                                                                                                                                                                          
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
declare @FDeliveryPlace varchar(100) --�����ص�                                                                                                                                                                                                                                                           
declare @FPOMode bigint --�ɹ�ģʽ                                                                                                                                                                                                                                                           
declare @FAccessoryCount bigint
declare @FLastAlterBillNo varchar(100)
declare @FPlanCategory bigint --�ƻ����                                                                                                                                                                                                                                                           
declare @FCloseDate datetime
declare @FCloseUser bigint
declare @FCloseCauses varchar(500)
declare @FEnterpriseID bigint
declare @FSendStatus bigint
declare @FCheckerID bigint --�����
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
--����������POOrder������FInterID
set @FNInterID=0
exec GetICMaxNum 'POOrder',@FNInterID output,1,16394

--д���¼��
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

--д�뵥��ͷ
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

--FSysStatusϵͳ����                                                                                                                                                                                                                                                           
UPDATE POOrder SET FSysStatus = 2 WHERE FInterID = @FNInterID

--ͬ����¼��
--���ݱ�POOrderͬ����¼�Ǽ�
INSERT INTO t_HT_SyncControl
(
FID,FEntryID,FName,FNumber,FBillNo,
FType,FIsSync,FStatus,FRStatus,FMStatus,
FOID,FOEntryID,FIsEntrySync,FIsPrdSync
)
select @FNInterID,t1.FEntryID,t2.FName,t2.FNumber,@FBillNo,
'�ɹ�����',5,@FStatus,t1.FMrpClosed,null,
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
--delete from t_HT_SyncControl where FType='�ɹ�����'