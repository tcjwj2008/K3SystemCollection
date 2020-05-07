/*
@FTradeID 地磅内码
@@cardno 地磅编号
@FOrderNO 运单号对应 k3订单号  地磅表字段sparestr2
@FTradeNo 单号  地磅表字段 ticketno1
@FGross 毛重  地磅表字段 gross
@FNet 净重 地磅表字段 net
@truckno 车牌
*/
alter proc pro_TradeToOutStock(@FTradeID int,@cardno varchar(30), @FTradeNo varchar(30),@FOrderNO varchar(30),@FNet decimal(16,2),@truckno varchar(30))
as
begin 
--获取单据编号
declare @FOrderID varchar(10) 
if exists(select 1 from SEOrder where fbillno like '%'+@FOrderNO)
begin
--按右匹配销售订单，若存在多个匹配订单取最新的订单号
  select top 1 @FOrderID=FInterID,@FOrderNO=FBillNo from SEOrder where fbillno like '%'+@FOrderNO order by finterid desc
end
else
begin
--单号不匹配
  return
end
--判断出库单是否已生成且已审核 不处理
if exists(select 1 from ICStockBill a 
inner join ICStockBillEntry b on a.finterid=b.FInterID 
where b.FSCBillInterID=@FTradeID and a.FCheckerID>0 and a.FExplanation like '地磅导入%' )
begin  
  return
end

--判断出库单是否已生成未审核 则删除出库单
if exists(select 1 from ICStockBill a 
inner join ICStockBillEntry b on a.finterid=b.FInterID 
where b.FSCBillInterID=@FTradeID and a.FCheckerID=0 and a.FExplanation like '地磅导入%' )
begin  
--删除销售出库
  delete from ICStockBill where FInterID in (select finterid from ICStockBillEntry where FSCBillInterID=@FTradeID) and FExplanation like '地磅导入%' 
  delete from ICStockBillEntry where FInterID not in (select finterid from ICStockBill) and FSCBillInterID=@FTradeID
end

/*
匹配订单行
1.若订单只有一行则可拆分行
2.若订单多行不运行拆分
  按从上往下，尾差行最后匹配
*/
declare @EntryCount int
declare @FEntryID int --订单匹配行
select @EntryCount=count(1) from SEOrderEntry where FInterID=@FOrderID
if(@EntryCount=1)
begin
	select @FEntryID=FEntryID from SEOrderEntry where FInterID=@FOrderID
end
else
begin
   select top 1 @FEntryID=FEntryID  from SEOrderEntry where FInterID=@FOrderID and FCommitQty=0  
end

--获取单据编号
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

--获取单据内码
declare @FID int
exec GetICMaxNum 'ICStockBill',@FID out

--新增出库明细 
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
null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,0,0,0,null,0,0,NEWID(),0,0,0,12530,0,null,'地磅导入：'+@FTradeNo,'',311,0,0,'81',
0,0,0,0,0,0,0,0,0,0,0,'',0,0,0,'',0,getdate(),0,0,0,0,0,0,0,0,0,0,'',null,0,0,'',0,37521,'','',0,0,null,null,null,null,null,1059,null
from SEOrder 
where FInterID=@FOrderID

--更新订单关联数量及基本单位数量
 update b set   
 FAuxStockQty= c.Fauxqty,-- 出库数量
 FStockQty=c.FQty,-- 基本单位出库数量
 FAuxCommitQty= c.Fauxqty,-- 关联数量
 FCommitQty=c.FQty  --基本单位关联数量 
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
 
