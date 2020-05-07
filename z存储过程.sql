/*
@FTradeID �ذ�����
@@cardno �ذ����
@FOrderNO �˵��Ŷ�Ӧ k3������  �ذ����ֶ�sparestr2
@FTradeNo ����  �ذ����ֶ� ticketno1
@FGross ë��  �ذ����ֶ� gross
@FNet ���� �ذ����ֶ� net
@truckno ����
*/
alter proc pro_TradeToOutStock(@FTradeID int,@cardno varchar(30), @FTradeNo varchar(30),@FOrderNO varchar(30),@FNet decimal(16,2),@truckno varchar(30))
as
begin 
--��ȡ���ݱ��
declare @FOrderID varchar(10) 
if exists(select 1 from SEOrder where fbillno like '%'+@FOrderNO)
begin
--����ƥ�����۶����������ڶ��ƥ�䶩��ȡ���µĶ�����
  select top 1 @FOrderID=FInterID,@FOrderNO=FBillNo from SEOrder where fbillno like '%'+@FOrderNO order by finterid desc
end
else
begin
--���Ų�ƥ��
  return
end
--�жϳ��ⵥ�Ƿ�������������� ������
if exists(select 1 from ICStockBill a 
inner join ICStockBillEntry b on a.finterid=b.FInterID 
where b.FSCBillInterID=@FTradeID and a.FCheckerID>0 and a.FExplanation like '�ذ�����%' )
begin  
  return
end

--�жϳ��ⵥ�Ƿ�������δ��� ��ɾ�����ⵥ
if exists(select 1 from ICStockBill a 
inner join ICStockBillEntry b on a.finterid=b.FInterID 
where b.FSCBillInterID=@FTradeID and a.FCheckerID=0 and a.FExplanation like '�ذ�����%' )
begin  
--ɾ�����۳���
  delete from ICStockBill where FInterID in (select finterid from ICStockBillEntry where FSCBillInterID=@FTradeID) and FExplanation like '�ذ�����%' 
  delete from ICStockBillEntry where FInterID not in (select finterid from ICStockBill) and FSCBillInterID=@FTradeID
end

/*
ƥ�䶩����
1.������ֻ��һ����ɲ����
2.���������в����в��
  ���������£�β�������ƥ��
*/
declare @EntryCount int
declare @FEntryID int --����ƥ����
select @EntryCount=count(1) from SEOrderEntry where FInterID=@FOrderID
if(@EntryCount=1)
begin
	select @FEntryID=FEntryID from SEOrderEntry where FInterID=@FOrderID
end
else
begin
   select top 1 @FEntryID=FEntryID  from SEOrderEntry where FInterID=@FOrderID and FCommitQty=0  
end

--��ȡ���ݱ��
declare @FProjectVal varchar(10)
declare @FCurNo varchar(10)
declare @FFormat varchar(10)
declare @Len int
declare @FBillNo varchar(20)
select @FProjectVal= FProjectVal from t_billcoderule where fbilltypeid=21 and FProjectID=1 
select @FCurNo= FCurNo,@Len=len(FFormat),@FFormat=FFormat  from ICBillNo WHERE FBillID = 21 

if(@Len>LEN(@FCurNo))
begin
set @FBillNo=@FProjectVal+left(@FFormat,@Len-LEN(@FCurNo))+@FCurNo
end
else
begin
set @FBillNo=@FProjectVal+@FCurNo
end

UPDATE ICBillNo SET FCurNo = FCurNo+1 WHERE FBillID = 21

--��ȡ��������
declare @FID int
exec GetICMaxNum 'ICStockBill',@FID out

--����������ϸ 
INSERT INTO ICStockBillEntry
           (FBrNo
           ,FInterID
           ,FEntryID
           ,FItemID
           ,FQtyMust
           ,FQty
           ,FPrice
           ,FBatchNo
           ,FAmount
           ,FNote
           ,FSCBillInterID
           ,FSCBillNo
           ,FUnitID
           ,FAuxPrice
           ,FAuxQty
           ,FAuxQtyMust
           ,FQtyActual
           ,FAuxQtyActual
           ,FPlanPrice
           ,FAuxPlanPrice
           ,FSourceEntryID
           ,FCommitQty
           ,FAuxCommitQty
           ,FKFDate
           ,FKFPeriod
           ,FDCSPID
           ,FSCSPID
           ,FConsignPrice
           ,FConsignAmount
           ,FProcessCost
           ,FMaterialCost
           ,FTaxAmount
           ,FMapNumber
           ,FMapName
           ,FOrgBillEntryID
           ,FOperID
           ,FPlanAmount
           ,FProcessPrice
           ,FTaxRate
           ,FSnListID
           ,FAmtRef
           ,FAuxPropID
           ,FCost
           ,FPriceRef
           ,FAuxPriceRef
           ,FFetchDate
           ,FQtyInvoice
           ,FQtyInvoiceBase
           ,FUnitCost
           ,FSecCoefficient
           ,FSecQty
           ,FSecCommitQty
           ,FSourceTranType
           ,FSourceInterId
           ,FSourceBillNo
           ,FContractInterID
           ,FContractEntryID
           ,FContractBillNo
           ,FICMOBillNo
           ,FICMOInterID
           ,FPPBomEntryID
           ,FOrderInterID
           ,FOrderEntryID
           ,FOrderBillNo
           ,FAllHookQTY
           ,FAllHookAmount
           ,FCurrentHookQTY
           ,FCurrentHookAmount
           ,FStdAllHookAmount
           ,FStdCurrentHookAmount
           ,FSCStockID
           ,FDCStockID
           ,FPeriodDate
           ,FCostObjGroupID
           ,FCostOBJID
           ,FMaterialCostPrice
           ,FReProduceType
           ,FBomInterID
           ,FDiscountRate
           ,FDiscountAmount
           ,FSepcialSaleId
           ,FOutCommitQty
           ,FOutSecCommitQty
           ,FDBCommitQty
           ,FDBSecCommitQty
           ,FAuxQtyInvoice
           ,FOperSN
           ,FCheckStatus
           ,FSplitSecQty
           ,FInStockID
           ,FSaleCommitQty
           ,FSaleSecCommitQty
           ,FSaleAuxCommitQty
           ,FSelectedProcID
           ,FVWInStockQty
           ,FAuxVWInStockQty
           ,FSecVWInStockQty
           ,FSecInvoiceQty
           ,FCostCenterID
           ,FPlanMode
           ,FMTONo
           ,FSecQtyActual
           ,FSecQtyMust
           ,FClientOrderNo
           ,FClientEntryID
           ,FRowClosed
           ,FCostPercentage
           ,FItemSize
           ,FItemSuite
           ,FPositionNo
           ,FAcctCheck
           ,FClosing
           ,FDeliveryNoticeEntryID
           ,FDeliveryNoticeFID
           ,FIsVMI
           ,FEntrySupply
           ,FChkPassItem
           ,FSEOutInterID
           ,FSEOutEntryID
           ,FSEOutBillNo
           ,FConfirmMemEntry
           ,FWebReturnQty
           ,FWebReturnAuxQty
           ,FItemStatementBillNO
           ,FItemStatementEntryID
           ,FItemStatementInterID
           ,FCommitAmt
           ,FFatherProductID
           ,FRealAmount
           ,FRealPrice
           ,FDefaultBaseQty
           ,FDefaultQty
           ,FRealStockBaseQty
           ,FRealStockQty
           ,FDiscardID
           ,FOLOrderBillNo
           ,FLockFlag
           ,FReturnNoticeBillNO
           ,FReturnNoticeEntryID
           ,FReturnNoticeInterID
           ,FProductFileQty
           ,FServiceRequestNo
           ,FSplitState
           ,FQtySplit
           ,FAuxQtySplit
           ,FAddQty
           ,FAuxAddQty
           ,FPurchasePrice
           ,FPurchaseAmount
           ,FCheckAmount
           ,FOutSourceInterID
           ,FOutSourceEntryID
           ,FOutSourceTranType
           ,FProcessTaxPrice
           ,FProcessTaxCost
           ,FShopName
           ,FPostFee
           ,FReviewBillsQty
           ,FPTLQty
           ,FEntrySelfB0180
           ,FEntrySelfA0168
           ,FEntrySelfB0181
           ,FEntrySelfA0169
           ,FEntrySelfA0170
           ,FAUXQTY_Gain
           ,FAUXQTY_Loss
           ,FEntrySelfB0182)
select 
--0,@FID,1,b.FItemID,b.FQty-b.FCommitQty,@FNet,0,'',0,@truckno,a.finterid,a.FBillNo,b.FUnitID,0,@FNet,b.FQty-b.FCommitQty,
--0,0,0,0,1,b.FEntryID,0,0,null,0,0,null,b.FAuxPrice,b.FAuxPrice*@FNet,0,0,0,'','',0,0,0,0,0,0,0,0,0,0,0,null,0,0,0,0,0,0,
----81,a.FInterID,b.FEntryID,a.fbillno,0,0,0,0,0,0,0,
--81,a.finterid,a.fbillno,b.FSourceInterId,b.FSourceEntryID,b.FSourceBillNo,'',0,0,a.FInterID,b.FEntryID,a.FBillNo,0,0,0,0,0,0,0
--,456,null,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,null,0,0,0,0,0,0,0,0,0,0,
--14038,'',0,0,'',0,0,0,'','','',
--0,0,0,0,0,0,1058,0,0,'','',0,0,'',0,0,0,0,0,0,0,0,0,0,0,'',0,'',0,0,0,null,'',0,0,0,0,0,0,0,0,0,0,0,0,'',0,0,0,
--b.FEntrySelfS0170,null,b.FEntrySelfS0171,null,null,null,null,null 
0,@FID,1,b.FItemID,b.FQty-b.FCommitQty,@FNet,0,'',0,@truckno
,@FTradeID,@cardno,b.FUnitID,0,@FNet,b.FQty-b.FCommitQty
,0,0,0,0,b.FEntryID,0,0
,null,0,0,null,b.FAuxPrice,b.FAuxPrice*@FNet
,0,0,0,'','',0,0,0,0,0,0,0,0,0,0,0,null,0,0,0,0,0,0
,81,a.finterid,a.fbillno,b.FSourceInterId,b.FSourceEntryID,b.FSourceBillNo,'',0,0,a.FInterID,b.FEntryID,a.FBillNo,0,0,0,0,0,0,0
,isnull(c.fbase,0),null,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
 ,null,0,0,0,0,0,0,0,0,0,0
,14036,'',0,0,'',0,0,0,'','','',0,0,0,0,0,0,1058,0,0,'','',0,0,'',0,0,0,0,0,0,0,0,0,0,0,'',0,'',0,0,0,null,'',0,0,0,0,0,0,0,0,0,0,0,0,'',0,0,0,
b.FEntrySelfS0170,null,b.FEntrySelfS0171,null,null,null,null,0  
from SEOrder a
inner join SEOrderEntry b on a.finterid=b.finterid  
left join (select a.FContractID,b.FEntryID,b.fbase from t_RPContract a
left join t_rpContractEntry b on a.FContractID=b.FContractID ) c on b.FContractInterID=c.FContractID and b.FContractEntryID=c.FEntryID
where a.FInterID=@FOrderID  

insert into ICStockBill(FBrNo
           ,FInterID
           ,FTranType
           ,FDate
           ,FBillNo
           ,FUse
           ,FNote
           ,FDCStockID
           ,FSCStockID
           ,FDeptID
           ,FEmpID
           ,FSupplyID
           ,FPosterID
           ,FCheckerID
           ,FFManagerID
           ,FSManagerID
           ,FBillerID
           ,FReturnBillInterID
           ,FSCBillNo
           ,FHookInterID
   ,FVchInterID
           ,FPosted
           ,FCheckSelect
           ,FCurrencyID
           ,FSaleStyle
           ,FAcctID
           ,FROB
           ,FRSCBillNo
           ,FStatus
           ,FUpStockWhenSave
           ,FCancellation
           ,FOrgBillInterID
           ,FBillTypeID
           ,FPOStyle
           ,FMultiCheckLevel1
           ,FMultiCheckLevel2
           ,FMultiCheckLevel3
           ,FMultiCheckLevel4
           ,FMultiCheckLevel5
           ,FMultiCheckLevel6
           ,FMultiCheckDate1
           ,FMultiCheckDate2
           ,FMultiCheckDate3
           ,FMultiCheckDate4
           ,FMultiCheckDate5
           ,FMultiCheckDate6
           ,FCurCheckLevel
           ,FTaskID
           ,FResourceID
           ,FBackFlushed
           ,FWBInterID
           ,FTranStatus
           ,FZPBillInterID
           ,FRelateBrID
           ,FPurposeID
           ,FUUID
           ,FRelateInvoiceID
           ,FImport
           ,FSystemType
           ,FMarketingStyle
           ,FPayBillID
           ,FCheckDate
           ,FExplanation
           ,FFetchAdd
           ,FFetchDate
           ,FManagerID
           ,FRefType
           ,FSelTranType
           ,FChildren
           ,FHookStatus
           ,FActPriceVchTplID
           ,FPlanPriceVchTplID
           ,FProcID
           ,FActualVchTplID
           ,FPlanVchTplID
           ,FBrID
           ,FVIPCardID
           ,FVIPScore
           ,FHolisticDiscountRate
           ,FPOSName
           ,FWorkShiftId
           ,FCussentAcctID
           ,FZanGuCount
           ,FPOOrdBillNo
           ,FLSSrcInterID
           ,FSettleDate
           ,FManageType
           ,FOrderAffirm
           ,FAutoCreType
           ,FConsignee
           ,FDrpRelateTranType
           ,FPrintCount
           ,FPOMode
           ,FInventoryType
           ,FObjectItem
           ,FConfirmStatus
           ,FConfirmMem
           ,FConfirmDate
           ,FConfirmer
           ,FAutoCreatePeriod
           ,FYearPeriod
           ,FPayCondition
           ,FsourceType
           ,FReceiver
           ,FInvoiceStatus
           ,FSendStatus
           ,FEnterpriseID
           ,FBillReviewer
           ,FBillReviewDate
           ,FCod
           ,FReceiveMan
           ,FConsigneeAdd
           ,FISUpLoad
           ,FReceiverMobile)
select 
0,@FID,21,FDate,@FBillNo,null,null,null,null,FDeptID,FEmpID,FCustID,null,null,FEmpID,FEmpID,0,null,null,0,null,0,0,null,101,null,1,null,0,1,0,0,0,null,
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,0,0,0,null,0,0,NEWID(),0,0,0,12530,0,null,'�ذ����룺'+@FTradeNo,'',311,0,0,'81',
0,0,0,0,0,0,0,0,0,0,0,'',0,0,0,'',0,getdate(),0,0,0,0,0,0,0,0,0,0,'',null,0,0,'',0,37521,'','',0,0,null,null,null,null,null,1059,null
from SEOrder 
where FInterID=@FOrderID

--���¶�������������������λ����
 update b set   
 FAuxStockQty= c.Fauxqty,-- ��������
 FStockQty=c.FQty,-- ������λ��������
 FAuxCommitQty= c.Fauxqty,-- ��������
 FCommitQty=c.FQty  --������λ�������� 
 from SEOrder a 
 inner join SEOrderEntry b on a.FInterID=b.FInterID
 left join ( select b.FSourceEntryID,b.FSourceInterId,b.FSourceBillNo,sum(b.Fauxqty) Fauxqty,sum(b.FQty) FQty 
 from ICStockBill a 
 inner join ICStockBillEntry b on a.FInterID=b.FInterID
 where a.FTranType=21 and b.FSourceTranType=81 
 group by b.FSourceEntryID,b.FSourceInterId,b.FSourceBillNo) c on a.FBillNo=c.FSourceBillNo and a.FInterID=c.FSourceInterId and b.FEntryID=c.FSourceEntryID
 where a.FBillNo=@FOrderNO  

 select 1
end
 
