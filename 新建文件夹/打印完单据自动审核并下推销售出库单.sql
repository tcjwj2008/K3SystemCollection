USE [Test_dzp]
GO
/****** Object:  Trigger [dbo].[tr_seordercheck_toicstockbill]    Script Date: 05/29/2019 14:21:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER    TRIGGER [dbo].[tr_seordercheck_toicstockbill] ON [dbo].[SEOrder]  
AFTER   UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
----
--作用：打印后自动审核 且生成销售出库
--条件：原单第一次打印且未审核未关闭未作废未出库
---create :yexuefeng
DECLARE @FInterID INT,@FBillNo VARCHAR(50), @FPrintCount INT ,@fdate DATETIME
SELECT @FInterID=FInterID,@FBillNo=FBillNo,@FPrintCount=FPrintCount,@fdate =FDate FROM INSERTED
SET  @fdate=DATEADD(DAY,1,@fdate)--日期+1天
IF  update(FPrintCount) AND @FPrintCount=1
BEGIN--如果是第一次打印
   IF EXISTS(--如果该单据未审核未关闭
           SELECT 1 FROM SEOrder 
           WHERE FInterID=@FInterID AND ISNULL(FCheckerID,0)=0  
           AND    ISNULL(FClosed,0)=0  
           AND FCancellation=0     
           )
BEGIN
 --审核该单据
 Update SEOrder 
 Set FCheckerID=16527,--要改**********************************
 FStatus=1,
 FCheckDate=@fdate --审核日期
 WHERE FInterID=@FInterID
 
 ----信用处理
declare @S_FCustID int
declare @S_FCustFID int 
declare @S_FEmpID int 
declare @S_FEmpFID int 
declare @S_FDepID int 
declare @S_FDepFID int 
declare @S_FStatus int 
declare @S_FPara int 
declare @S_FAmt numeric(18,4) 

select @S_FCustID=FCustID,@S_FEmpID=FEmpID,@S_FDepID=FDeptID,
 @S_FAmt=(select sum(FAllStdAmount) from SEOrderEntry where FInterID=@FInterID),@S_FStatus=(0),@S_FPara=(case when isnull(FCheckerID,0)=0 then 1 else 2 end)
from SEOrder where FInterID=@FInterID

Update ICCreditInstant
 set FMainAmtPara1=FMainAmtPara1 - @S_FAmt  ,
     FMainAmtPara2=FMainAmtPara2 + @S_FAmt , 
     FMainAmtPara0=@S_FAmt, 
    @S_FCustFID=case when FItemID=@S_FCustID and FCreditClass=0 then FInterID else @S_FCustFID end ,
    @S_FEmpFID=case when FItemID=@S_FEmpID and FCreditClass=1 then FInterID else @S_FEmpFID end ,
    @S_FDepFID=case when FItemID=@S_FDepID and FCreditClass=2 then FInterID else @S_FDepFID end 
where (FItemID=@S_FCustID and FCreditClass=0 and FGroupID=1 and FStatus=@S_FStatus ) 
     or (FItemID=@S_FEmpID and FCreditClass=1 and FGroupID=1 and FStatus=@S_FStatus) 
     or (FItemID=@S_FDepID and FCreditClass=2 and FGroupID=1 and FStatus=@S_FStatus) 

Update ICCreditInstantEntry 
Set FEntryQtyPara1 = FEntryQtyPara1 - b.FQty ,
    FEntryQtyPara2 = FEntryQtyPara2 + b.FQty ,
    FEntryQtyPara0 = b.FQty 
from ICCreditInstantEntry a
     inner join (select b.FInterID,a.FItemID as FItemID ,sum(FQty) as FQty from SEOrderEntry a ,
                 (select @S_FCustFID as FInterID union all select @S_FEmpFID union all select @S_FDepFID ) b  where a.FInterID=@FInterID
                 group by b.FInterID,a.FItemID) b on a.FInterID=b.FInterID and a.FItemID=b.FItemID 
  ----信用处理                
---处理PPOrder
UPDATE t1 SET t1.FSaleQty=t1.FSaleQty+t2.FQty,t1.FAuxSaleQty= (t1.FSaleQty+t2.FQty)/M1.FCoefficient,t1.FOrderClosed=(CASE WHEN t1.FSaleQty+t2.FQty>=t1.FQty THEN 1 ELSE 0 END)
FROM PPOrderEntry t1 INNER JOIN T_MEASUREUNIT M1 ON T1.FUNITID=M1.FMEASUREUNITID 
INNER Join (SELECT FSourceInterID,FSourceEntryID,SUM(FQty) AS FQty FROM SEOrderEntry WHERE FInterID=@FInterID GROUP BY FSourceInterID,FSourceEntryID) t2 ON t1.FInterID=t2.FSourceInterID AND t1.FEntryID=t2.FSourceEntryID
IF EXISTS(SELECT 1 FROM PPOrderEntry t1 INNER Join SEOrderEntry t2 ON t1.FInterID=t2.FSourceInterID AND t2.FInterID=@FInterID WHERE t1.FOrderClosed = 0) 
UPDATE t1 SET FStatus = 1 FROM PPOrder t1 INNER Join SEOrderEntry t2 ON t1.FInterID=t2.FSourceInterID AND t2.FInterID=@FInterID
ELSE
UPDATE t1 SET FStatus = 3 FROM PPOrder t1 INNER Join SEOrderEntry t2 ON t1.FInterID=t2.FSourceInterID AND t2.FInterID=@FInterID

--处理ICCustNetOrder
UPDATE v1 SET v1.FExecStatus =2 FROM ICCustNetOrder v1 INNER JOIN SEOrderEntry u2 ON v1.FID = u2.FSourceInterID  AND u2.FSourceTranType = 1007553 AND u2.FInterID =@FInterID
--审核日志
INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress) 
VALUES (getdate(),16527,'K030101',1,'编号'+@FBillNo+'的单据审核成功！','系统审核','188.188.1.4')

---生成销售出库
IF NOT EXISTS(--如果分录有行关闭或出库数量大于0或关联数量大于0则不生成销售出库应手动生成
            SELECT 1 FROM dbo.SEOrderEntry 
            WHERE FInterID=@FInterID and (FMrpClosed=1 
                  OR FStockQty>0
                  OR FAuxStockQty>0
                  OR FCommitQty>0
                  OR FAuxCommitQty>0)
             )
BEGIN
----生成销售出库
--1 信用处理
Create Table #551DB1AF44EA04EC0E8B5C9600F569B00000000
(FInterID int , 
 FItemID int ,
 FType int ) 


Create Table #D8356C6847A6C7902AD6BEA9DE1F336300000000
(FItemID int  ,
 FQty numeric(28,10) ,
 FAmt numeric(28,2),
 FType int ) 


set nocount on 

declare @S_FCustID2 int 
declare @S_FCustFID2 int 
declare @S_FEmpID2 int 
declare @S_FEmpFID2 int 
declare @S_FDepID2 int 
declare @S_FDepFID2 int 
declare @D_FCustID2 int 
declare @D_FCustFID2 int 
declare @D_FEmpID2 int 
declare @D_FEmpFID2 int 
declare @D_FDepID2 int 
declare @D_FDepFID2 int 
declare @S_FStatus2 int 
declare @S_FAmt2 numeric(18,4) 
declare @FID2 int 
declare @Num2 int 

set @S_FCustID2=0
set @S_FEmpID2=0
set @S_FDepID2=0
set @S_FStatus2=0 
set @Num2=0

Insert #D8356C6847A6C7902AD6BEA9DE1F336300000000 (FItemID,FQty,FType) 
--          select 1097,6,1 --fitemid，fbaseqty
--union all select 1101,6.2,1 
--union all select 1071,3,1 
SELECT FItemID, FQty,1
FROM SEOrderEntry WHERE FInterID=@FInterID

--
declare @FCustID INT,@FEmpID INT ,@FDepID INT ,@sumFAllAmount FLOAT                         
SELECT @FCustID=FCustID, @FEmpID =FEmpID, @FDepID=FDeptID FROM  SEOrder WHERE FInterID=@FInterID
SELECT @sumFAllAmount =SUM(FAllAmount) FROM seorderentry WHERE FInterID =@FInterID  --@sumFAllAmount

if (@S_FCustID2<>@FCustID or @S_FStatus2<>0) and @FCustID<>0
 begin 
     update ICCreditInstant 
         set FMainAmtPara1=FMainAmtPara1+ case when FItemID=@S_FCustID2 and FStatus=@S_FStatus2 then -@S_FAmt2 else @sumFAllAmount end ,FMainAmtPara0=@sumFAllAmount,
             @D_FCustFID2=case when FItemID=@S_FCustID2 and FStatus=@S_FStatus2 then @D_FCustFID2 else FInterID end 
     where FCreditClass=0 and ((FItemID=@FCustID and FStatus=0) or (FItemID=@S_FCustID2 and FStatus=@S_FStatus2)) and FGroupID=2
     if @D_FCustFID2 is null 
       begin 
         insert ICCreditInstant (FCreditClass,FItemID,FGroupID ,FStatus,FMainAmtPara1,FMainAmtPara0) 
         Values ( 0,@FCustID,2,0,@sumFAllAmount,@sumFAllAmount)
         set @D_FCustFID2=SCOPE_IDENTITY( ) 
       end 
     insert #551DB1AF44EA04EC0E8B5C9600F569B00000000 (FInterID,FItemID,FType) 
     select @D_FCUstFID2,@FCustID,1 union all select @S_FCustFID2,@S_FCustID2,-1 where @S_FCustID2<>0 
 end 
else if @S_FCustID2 <>0  
 begin 
     update ICCreditInstant set FmainAmtPara1=FMainAmtPara1 - @S_FAmt2 + @sumFAllAmount,FMainAmtPara0=@sumFAllAmount
     where FInterID=@S_FCustFID2 
     insert #551DB1AF44EA04EC0E8B5C9600F569B00000000 (FInterID,FItemID,FType) values (@S_FCustFID2,@S_FCustID2,0) 
 end 

if (@S_FEmpID2<>@FEmpID or @S_FStatus2<>0) and @FEmpID<>0
 begin 
     update ICCreditInstant 
         set FMainAmtPara1=FMainAmtPara1+ case when FItemID=@S_FEmpID2 and FStatus=@S_FStatus2 then -@S_FAmt2 else @sumFAllAmount end ,FMainAmtPara0=@sumFAllAmount,
             @D_FEmpFID2=case when FItemID=@S_FEmpID2 and FStatus=@S_FStatus2 then @D_FEmpFID2 else FInterID end 
     where FCreditClass=1 and ((FItemID=@FEmpID and FStatus=0) or (FItemID=@S_FEmpID2 and FStatus=@S_FStatus2)) and FGroupID=2
     if @D_FEmpFID2 is null 
       begin 
         insert ICCreditInstant (FCreditClass,FItemID,FGroupID,FStatus,FMainAmtPara1,FMainAmtPara0) 
         Values ( 1,@FEmpID,2,0,@sumFAllAmount,@sumFAllAmount)
         set @D_FEmpFID2=SCOPE_IDENTITY( ) 
       end 
     insert #551DB1AF44EA04EC0E8B5C9600F569B00000000 (FInterID,FItemID,FType) 
     select @D_FEmpFID2,@FEmpID,1 union all select @S_FEmpFID2,@S_FEmpID2,-1 where @S_FEmpID2<>0 
 end 
else if @S_FEmpID2 <>0  
 begin 
     update ICCreditInstant set FmainAmtPara1=FMainAmtPara1 - @S_FAmt2 + @sumFAllAmount,FMainAmtPara0=@sumFAllAmount
     where FInterID=@S_FEmpFID2 
     insert #551DB1AF44EA04EC0E8B5C9600F569B00000000 (FInterID,FItemID,FType) values (@S_FEmpFID2,@S_FEmpID2,0) 
 end 

if (@S_FDepID2<>@FDepID or @S_FStatus2<>0) and @FDepID<>0
 begin 
     update ICCreditInstant 
         set FMainAmtPara1=FMainAmtPara1+ case when FItemID=@S_FDepID2 and FStatus=@S_FStatus2 then -@S_FAmt2 else @sumFAllAmount end ,FMainAmtPara0=@sumFAllAmount,
             @D_FDepFID2=case when FItemID=@S_FDepID2 and FStatus=@S_FStatus2 then @D_FDepFID2 else FInterID end 
     where FCreditClass=2 and ((FItemID=@FDepID and FStatus=0) or (FItemID=@S_FDepID2 and FStatus=@S_FStatus2)) and FGroupID=2
     if @D_FDepFID2 is null 
       begin 
         insert ICCreditInstant (FCreditClass,FItemID,FGroupID ,FStatus,FMainAmtPara1,FMainAmtPara0) 
         Values ( 2,@FDepID,2,0,@sumFAllAmount,@sumFAllAmount)
         set @D_FDepFID2=SCOPE_IDENTITY( )
       end 
     insert #551DB1AF44EA04EC0E8B5C9600F569B00000000 (FInterID,FItemID,FType) 
     select @D_FDepFID2,@FDepID,1 union all select @S_FDepFID2,@S_FDepID2,-1 where @S_FDepID2<>0 
 end 
else if @S_FDepID2 <>0  
 begin 
     update ICCreditInstant set FmainAmtPara1=FMainAmtPara1 - @S_FAmt2 + @sumFAllAmount,FMainAmtPara0=@sumFAllAmount
     where FInterID=@S_FDepFID2 
     insert #551DB1AF44EA04EC0E8B5C9600F569B00000000 (FInterID,FItemID,FType) values (@S_FDepFID2,@S_FDepID2,0) 
 end 

select a.FInterID,b.FItemID,sum(b.FType*FQty) as FQty,sum(Case When b.FType=-1 Then 0 Else FQty end) as FCurrentQty into #D8356C6847A6C7902AD6BEA9DE1F336300000000_Sum
from #551DB1AF44EA04EC0E8B5C9600F569B00000000 a ,#D8356C6847A6C7902AD6BEA9DE1F336300000000 b 
where (a.FType=b.FType) or (a.FType=0)
Group by a.FInterID,b.FItemID having sum(b.FType*FQty)<>0 
set @Num2=@@rowcount 

if @Num2>0 
 UPdate ICCreditInstantEntry set FEntryQtyPara1=a.FEntryQtyPara1 + b.FQty, FEntryQtyPara0 = b.FCurrentQty
 from ICCreditInstantEntry a 
    inner join #D8356C6847A6C7902AD6BEA9DE1F336300000000_Sum b on a.FInterID=b.FInterID and a.FItemID=b.FItemID 

If @@rowcount<>@Num2 
 insert ICCreditInstantEntry (FInterID,FItemID,FEntryQtyPara1, FEntryQtyPara0) 
     select a.FInterID,a.FItemID,a.FQty,a.FCurrentQty 
     from #D8356C6847A6C7902AD6BEA9DE1F336300000000_Sum a 
         left join ICCreditInstantEntry b on a.FInterID=b.FInterID and a.FItemID=b.FItemID
     where b.FInterID is null 

Drop table #D8356C6847A6C7902AD6BEA9DE1F336300000000
Drop table #D8356C6847A6C7902AD6BEA9DE1F336300000000_Sum
Drop table #551DB1AF44EA04EC0E8B5C9600F569B00000000
--信用处理


--2 获得内码单据编号
DECLARE @xfinterid INT, --销售出库内码
        @xfbillno VARCHAR(50) --销售出库单据编号
--获得
set @xfinterid =0    
SET @xfbillno=''    
exec GetICMaxNum 'ICStockBill',@xfinterid output,1,1   
EXEC p_GetICBillNo 21,@xfbillno OUTPUT    
--SELECT @xFBillNo,@xFInterID  
-----插入销售出库分录
INSERT INTO ICStockBillEntry (FInterID,FEntryID,FBrNo,FMapNumber,FMapName,FItemID,FAuxPropID,FOLOrderBillNo,FBatchNo,FQty,FUnitID,FAuxQtyMust,Fauxqty,FEntrySelfB0158,FEntrySelfB0159,FSecCoefficient,FSecQty,FAuxPlanPrice,FPlanAmount,Fauxprice,Famount,FKFDate,FKFPeriod,FPeriodDate,FIsVMI,FEntrySupply,FDCStockID,FDCSPID,FConsignPrice,FDiscountRate,FConsignAmount,FDiscountAmount,FOrgBillEntryID,FSNListID,FSourceBillNo,FSourceTranType,FSourceInterId,FSourceEntryID,FContractBillNo,FContractInterID,FContractEntryID,FOrderBillNo,FOrderInterID,FOrderEntryID,FAllHookQTY,FCurrentHookQTY,FQtyMust,FSepcialSaleId,FPlanMode,FMTONo,Fnote,FEntrySelfB0161,FEntrySelfB0162,FClientEntryID,FClientOrderNo,FConfirmMemEntry,FChkPassItem,FSEOutBillNo,FSEOutEntryID,FSEOutInterID)  
   -- SELECT 1205890,1,'0','','',1097,0,'','',6,124,1,1,'',0,0,0,0,0,0,0,Null,0,Null,0,0,1236,0,22.4,0,22.4,0,0,0,'SEORD1046315',81,@FInterID,1,'',0,0,'SEORD1046315',@FInterID,1,0,0,6,0,14036,'','','','','0','','',1058,'',0,0 union all 
   --SELECT 1205890,2,'0','','',1101,0,'','',6.2,125,1,1,'',0,0,0,0,0,0,0,Null,0,Null,0,0,1236,0,25.6,0,25.6,0,0,0,'SEORD1046315',81,@FInterID,2,'',0,0,'SEORD1046315',@FInterID,2,0,0,6.2,0,14036,'','','','','0','','',1058,'',0,0 union all 
   --SELECT 1205890,3,'0','','',1071,0,'','',3,121,3,3,'',0,0,0,0,0,0,0,Null,0,Null,0,0,1236,0,8.5,0,25.5,0,0,0,'SEORD1046315',81,@FInterID,3,'',0,0,'SEORD1046315',@FInterID,3,0,0,3,0,14036,'','','','','0','','',1058,'',0,0 


SELECT 
@xFInterID     FInterID ,
u.FEntryID      FEntryID ,
'0'           FBrNo ,
 ''           FMapNumber ,
''            FMapName ,
u.FItemID       FItemID ,
 0            FAuxPropID ,
''            FOLOrderBillNo ,
''            FBatchNo ,
FQty          FQty ,
u.FUnitID       FUnitID ,
u.FAuxQty       FAuxQtyMust ,
u.FAuxQty       Fauxqty ,
 ''           FEntrySelfB0158 ,
u.FEntrySelfS0161   FEntrySelfB0159 ,--赠品数量
0             FSecCoefficient ,
0             FSecQty ,
0             FAuxPlanPrice ,
0             FPlanAmount ,
0             Fauxprice ,
0             Famount ,
NULL          FKFDate ,
 0            FKFPeriod ,
NULL          FPeriodDate ,
 0            FIsVMI ,
 0            FEntrySupply ,
t.FDefaultLoc   FDCStockID ,
 0            FDCSPID ,
u.FAuxTaxPrice   FConsignPrice ,
 0            FDiscountRate ,
u.FAllAmount  FConsignAmount ,
 0            FDiscountAmount ,
 0            FOrgBillEntryID ,
 0             FSNListID ,
@FBillNo       FSourceBillNo ,
81            FSourceTranType ,
@FInterId      FSourceInterId ,
u.FEntryID       FSourceEntryID ,
''            FContractBillNo ,
 0          FContractInterID ,
 0           FContractEntryID ,
@FBillNo          FOrderBillNo ,
@FInterId         FOrderInterID ,
u.FEntryID           FOrderEntryID ,
0               FAllHookQTY ,
0            FCurrentHookQTY ,
u.FAuxQty          FQtyMust ,
0          FSepcialSaleId ,
14036         FPlanMode ,
 ''          FMTONo ,
''           Fnote ,
 ''          FEntrySelfB0161 ,
''          FEntrySelfB0162 ,
 '0'           FClientEntryID ,
''           FClientOrderNo ,
''          FConfirmMemEntry ,
1058          FChkPassItem ,
''          FSEOutBillNo ,
 0          FSEOutEntryID ,
0	FSEOutInterID


FROM SEOrderEntry u
INNER JOIN t_ICItem t ON t.FItemID=u.FItemID 
WHERE FInterID =@FInterID
EXEC p_UpdateBillRelateData 21,@xFInterID,'ICStockBill','ICStockBillEntry' 

----插入销售出库主表
INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FROB,FHookStatus,Fdate,FSupplyID,FSaleStyle,FCheckDate,FFManagerID,FSManagerID,FConfirmDate,FBillerID,FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,FConfirmer,FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FPOOrdBillNo,FMultiCheckLevel6,FMultiCheckDate6,FRelateBrID,FOrgBillInterID,FMarketingStyle,FSelTranType,FBrID,FFetchAdd,FExplanation,FDeptID,FEmpID,FManagerID,FVIPCardID,FPrintCount,FVIPScore,FHolisticDiscountRate,FPOSName,FConfirmMem,FWorkShiftId,FLSSrcInterID,FManageType,FSettleDate,FReceiver,FPayCondition,FHeadSelfB0150,FConsignee,FHeadSelfB0152,FHeadSelfB0155,FHeadSelfB0156,FHeadSelfB0157) 
--SELECT 1205890,'XOUT1162726','0',21,0,0,1,1,0,'2014-08-27',6008,101,Null,3791,176,Null,16394,Null,Null,Null,0,Null,Null,Null,Null,Null,Null,Null,'',Null,Null,0,0,12530,81,0,'','',3574,311,311,0,0,0,0,'','',0,0,0,'2014-08-27','',0,'特通',0,0,'',1,0
SELECT
@xFInterID	FInterID,
@xFBillNo	FBillNo,
'0'	        FBrNo,
21	        FTranType,
0	       FCancellation,
0	       FStatus,
1	      FUpStockWhenSave,
1	       FROB,
0	      FHookStatus,
--@fdate Fdate,
@fdate Fdate,
 FCustID	FSupplyID,
101	    FSaleStyle,
NULL	FCheckDate,
3791	FFManagerID,
176	    FSManagerID,
NULL	FConfirmDate,
16521	FBillerID,  ------------制单人要改******************************
NULL	FMultiCheckLevel1,
NULL	FMultiCheckDate1,
NULL	FMultiCheckLevel2,
0	    FConfirmer,
NULL	FMultiCheckDate2,
NULL	FMultiCheckLevel3,
NULL	FMultiCheckDate3,
NULL	FMultiCheckLevel4,
NULL	FMultiCheckDate4,
NULL	FMultiCheckLevel5,
NULL	FMultiCheckDate5,
''	    FPOOrdBillNo,
NULL	FMultiCheckLevel6,
NULL	FMultiCheckDate6,
0	    FRelateBrID,
0	    FOrgBillInterID,
12530	FMarketingStyle,
81	    FSelTranType,
0	    FBrID,
''	    FFetchAdd,
''	    FExplanation,
FDeptID	FDeptID,
FEmpID	FEmpID,
FEmpID	FManagerID,
0	FVIPCardID,
0	FPrintCount,
0	FVIPScore,
0	FHolisticDiscountRate,
''	FPOSName,
''	FConfirmMem,
0	FWorkShiftId,
0	FLSSrcInterID,
0	FManageType,
@fdate	FSettleDate,
''	FReceiver,
0	FPayCondition,
FHeadSelfS0148	FHeadSelfB0150,
0	FConsignee,
0	FHeadSelfB0152,
''	FHeadSelfB0155,
1	FHeadSelfB0156,
0	FHeadSelfB0157

FROM SEOrder where FInterID=@FInterID



IF (SELECT COUNT(*) FROM SYSCOLUMNS WHERE ID=OBJECT_ID('ICStockBill') AND NAME='FSettleDate')>0
UPDATE t1 SET t1.FSettleDate=GetDate()
FROM ICStockBill t1  WHERE FInterID =@xFInterID AND FSettleDate IS NULL 

UPDATE ICStockBill SET FUUID=NEWID() WHERE FInterID=@xFInterID



-----更新seorder关联数量
declare @fcheck_fail int
declare @fsrccommitfield_prevalue decimal(28,13)
declare @fsrccommitfield_endvalue decimal(28,13)
declare @maxorder int 
update src set @fsrccommitfield_prevalue= isnull(src.fcommitqty,0),
     @fsrccommitfield_endvalue=@fsrccommitfield_prevalue+dest.fqty,
@maxorder=(select fvalue from t_systemprofile where fcategory='ic' and fkey='cqtylargerseqty'),
     @fcheck_fail=case isnull(@maxorder,0) when 1 then 0 else (case when (abs(src.fqty)>abs(@fsrccommitfield_prevalue) or abs(src.fqty)>abs(@fsrccommitfield_endvalue)) then @fcheck_fail else -1 end) end,
     src.fcommitqty=@fsrccommitfield_endvalue,
     src.fauxcommitqty=@fsrccommitfield_endvalue/cast(t1.fcoefficient as float)
 from seorderentry src 
     inner join seorder srchead on src.finterid=srchead.finterid
     inner join 
 (select u1.fsourceinterid as fsourceinterid,u1.fsourceentryid,u1.fitemid,sum(u1.fqty) as fqty
 from  icstockbillentry u1 
 where u1.finterid=@xfinterid
 group by u1.fsourceinterid,u1.fsourceentryid,u1.fitemid) dest 
 on dest.fsourceinterid = src.finterid
 and dest.fitemid = src.fitemid
 and src.fentryid = dest.fsourceentryid
 inner join t_measureunit t1 on src.funitid=t1.fitemid
-----
Update t
Set t.FStatus =Case When (SELECT COUNT(1) FROM SEOrderEntry WHERE (FCommitQty>0 OR (ISNULL(FMRPClosed,0)=1 AND ISNULL(FMRPAutoClosed,1)=0)) AND FInterID IN(@FInterID))=0 Then 1 When (SELECT COUNT(1) FROM SEOrderEntry WHERE (ISNULL(FMRPClosed,0)=1 OR  FCommitQty >= FQty ) AND FInterID IN(@FInterID))<(SELECT COUNT(1) FROM SEOrderEntry WHERE FInterID IN(@FInterID)) Then 2 Else 3 End
,t.FClosed =Case WHEN (SELECT COUNT(1) FROM SEOrderEntry te WHERE (te.FCommitQty>=FQty OR (ISNULL(te.FMRPAutoClosed,1)=0 AND ISNULL(FMRPClosed,0)=1)) AND te.FInterID IN(@FInterID))=(SELECT COUNT(1) FROM SEOrderEntry te WHERE te.FInterID IN(@FInterID)) Then 1 Else 0 End
From SEOrder t
WHERE t.FInterID IN(@FInterID)
---
declare @fcheck_fail2 int
declare @fsrccommitfield_prevalue2 decimal(28,13)
declare @fsrccommitfield_endvalue2 decimal(28,13)
declare @maxorde2r int 
update src set @fsrccommitfield_prevalue2= isnull(src.fseccommitqty,0),
     @fsrccommitfield_endvalue2=@fsrccommitfield_prevalue2+dest.fsecqty,
@maxorde2r=(select fvalue from t_systemprofile where fcategory='ic' and fkey='cqtylargerseqty'),
     @fcheck_fail2=case isnull(@maxorder,0) when 1 then 0 else (case when (1=1) then @fcheck_fail2 else -1 end) end,
     src.fseccommitqty=@fsrccommitfield_endvalue2
 from seorderentry src 
     inner join seorder srchead on src.finterid=srchead.finterid
     inner join 
 (select u1.fsourceinterid as fsourceinterid,u1.fsourceentryid,u1.fitemid,sum(u1.fsecqty) as fsecqty
 from  icstockbillentry u1 
 where u1.finterid=@xfinterid
 group by u1.fsourceinterid,u1.fsourceentryid,u1.fitemid) dest 
 on dest.fsourceinterid = src.finterid
 and dest.fitemid = src.fitemid
 and src.fentryid = dest.fsourceentryid
----
---
IF EXISTS (SELECT 1 FROM ICBillRelations_Sale WHERE FBillType = 21 AND FBillID=@xfinterid)
BEGIN
    UPDATE t1 SET t1.FChildren=t1.FChildren+1
    FROM SEOrder t1 INNER JOIN SEOrderEntry t2 ON     t1.FInterID=t2.FInterID
    INNER JOIN ICBillRelations_Sale t3 ON t3.FMultiEntryID=t2.FEntryID AND t3.FMultiInterID=t2.FInterID
    WHERE t3.FBillType=21 AND t3.FBillID=@xfinterid
END
ELSE
BEGIN
    UPDATE t3 SET t3.FChildren=t3.FChildren+1
    FROM ICStockBill t1 INNER JOIN ICStockBillEntry     t2 ON t1.FInterID=t2.FInterID
    INNER JOIN SEOrder t3 ON t3.FTranType=t2.FSourceTranType AND t3.FInterID=t2.FSourceInterID
    WHERE t1.FTranType=21 AND t1.FInterID=@xfinterid AND t2.FSourceInterID>0
END
----信用
Update ICCreditInstantEntry 
     Set FEntryQtyPara3 = FEntryQtyPara3 + a.FQty 
from (select d.FInterID,d.FItemID,sum(a.FQty) as FQty
      from ICStockBillEntry a 
         inner join SEOrder b on a.FOrderInterID=b.FInterID
         inner join ICCreditInstant c on c.FItemID in (b.FCustID,b.FEmpID,b.FDeptID) and c.FGroupID=1 and c.FStatus=0
         inner join ICCreditInstantEntry d on c.FInterID=d.FInterID and a.FItemID=d.FItemID 
      where a.FInterID=@xfinterid and a.FOrderInterID<>0 
      group by d.FInterID,d.FItemID) a 
where ICCreditInstantEntry.FInterID=a.FInterID and ICCreditInstantEntry.FItemID=a.FItemID 

Update ICCreditInstantEntry 
    Set FEntryQtyPara3 = FEntryQtyPara3 + a.FQty 
from (select d.FInterID,d.FItemID,sum(a.FQty) as FQty 
      from ICStockBillEntry a 
         inner join t_RPContract b on a.FContractInterID=b.FContractID
         inner join ICCreditInstant c on c.FItemID in (b.FCustomer,b.FEmployee,b.FDepartment) and c.FGroupID=0 and c.FStatus=0
         inner join ICCreditInstantEntry d on c.FInterID=d.FInterID and a.FItemID=d.FItemID 
      where a.FInterID=@xfinterid and a.FContractInterID<>0 
      group by d.FInterID,d.FItemID) a 
where ICCreditInstantEntry.FInterID=a.FInterID and ICCreditInstantEntry.FItemID=a.FItemID

Update ICCreditInstantEntry 
     Set FEntryQtyPara3 = FEntryQtyPara3 + a.FQty 
from (select d.FInterID,d.FItemID,sum(a.FQty) as FQty
      from ICStockBillEntry a 
         inner join SEOutStock b on a.FSEOutInterID=b.FInterID
         inner join ICCreditInstant c on c.FItemID in (b.FCustID,b.FEmpID,b.FDeptID) and c.FGroupID=9 and c.FStatus=0
         inner join ICCreditInstantEntry d on c.FInterID=d.FInterID and a.FItemID=d.FItemID 
      where a.FInterID=@xfinterid and a.FSEOutInterID<>0 
      group by d.FInterID,d.FItemID) a 
where ICCreditInstantEntry.FInterID=a.FInterID and ICCreditInstantEntry.FItemID=a.FItemID 

---------------
------------库存处理

CREATE TABLE #TempBill
(FID INT IDENTITY (1,1),FBrNo VARCHAR(10) NOT NULL DEFAULT(''),
 FInterID INT NOT NULL DEFAULT(0),
 FEntryID INT NOT NULL DEFAULT(0),
 FTranType INT NOT NULL DEFAULT(0),
 FItemID INT NOT NULL DEFAULT(0),
 FBatchNo NVARCHAR(255) NOT NULL DEFAULT(''),
 FMTONo NVARCHAR(255) NOT NULL DEFAULT(''),
 FAuxPropID INT NOT NULL DEFAULT(0),
 FStockID INT NOT NULL DEFAULT(0),
 FStockPlaceID INT NOT NULL DEFAULT(0),
 FKFPeriod INT NOT NULL DEFAULT(0),
 FKFDate VARCHAR(20) NOT NULL DEFAULT(''),
 FSupplyID INT NOT NULL DEFAULT(0),
 FQty DECIMAL(28,10) NOT NULL DEFAULT(0),
 FSecQty DECIMAL(28,10) NOT NULL DEFAULT(0),
 FAmount DECIMAL(28,2)  NOT NULL DEFAULT(0) 
)


INSERT INTO #TempBill(FBrNo,FInterID,FEntryID,FTranType,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FSupplyID,FQty,FSecQty,FAmount)
SELECT '',u1.FInterID,u1.FEntryID,21 AS FTranType,u1.FItemID,ISNULL(u1.FBatchNo,'') AS FBatchNo,ISNULL(u1.FMTONo,'') AS FMTONo,
       u1.FAuxPropID,ISNULL(u1.FDCStockID,0) AS FDCStockID,ISNULL(u1.FDCSPID,0) AS FDCSPID,ISNULL(u1.FKFPeriod,0) AS FKFPeriod,
       LEFT(ISNULL(CONVERT(VARCHAR(20),u1.FKFdate ,120),''),10) AS FKFDate,FEntrySupply,
-1*u1.FQty AS FQty,-1*u1.FSecQty AS FSecQty,-1*u1.FAmount
FROM ICStockBillEntry u1 
WHERE u1.FInterID=@xFInterID
 order by  u1.FEntryID

SELECT * INTO #TempBill2 FROM #TempBill 

UPDATE t1
SET t1.FQty=t1.FQty+(u1.FQty),
t1.FSecQty=t1.FSecQty+(u1.FSecQty)
FROM ICInventory t1 INNER JOIN
(SELECT FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FSupplyID
        ,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty
 FROM #TempBill2
 GROUP BY FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FSupplyID
) u1
ON t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
   AND t1.FStockID=u1.FStockID AND t1.FStockPlaceID=u1.FStockPlaceID 
   AND t1.FKFPeriod=u1.FKFPeriod AND t1.FKFDate=u1.FKFDate AND t1.FSupplyID=u1.FSupplyID

DELETE u1
FROM ICInventory t1 INNER JOIN #TempBill2 u1
ON t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
   AND t1.FStockID=u1.FStockID AND t1.FStockPlaceID=u1.FStockPlaceID 
   AND t1.FKFPeriod=u1.FKFPeriod AND t1.FKFDate=u1.FKFDate AND t1.FSupplyID=u1.FSupplyID

INSERT INTO ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FSupplyID,FQty,FSecQty)
SELECT '',FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FSupplyID,
       SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty
FROM #TempBill2
GROUP BY FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FSupplyID


DROP TABLE #TempBill2 
DROP TABLE #TempBill

-----
UPDATE P1 SET P1.FLockFlag=(CASE WHEN ISNULL(t1.FQty,0)<=0 THEN 0 ELSE 1 END)
FROM SEOrderEntry P1 
INNER JOIN ICStockBillEntry u1 ON u1.FOrderInterID=P1.FInterID AND u1.FOrderEntryID=P1.FEntryID AND u1.FItemID=P1.FItemID
INNER JOIN (SELECT FInterID,FEntryID,SUM(FQty) AS FQty FROM t_LockStock WHERE FTranType=81 GROUP BY FInterID,FEntryID) t1 ON P1.FInterID=t1.FInterID AND P1.FEntryID=t1.FEntryID
WHERE u1.FInterID=@xfinterid

-----
UPDATE ICStockBill SET FOrderAffirm=0 WHERE FInterID=@xfinterid
----
IF EXISTS(SELECT FOrderInterID FROM ICStockBillEntry WHERE FOrderInterID>0 AND FInterID=@xfinterid)
 UPDATE u1
 SET u1.FStockQty=u1.FStockQty+1*Cast(u2.FStockQty as Float)
     ,u1.FSecStockQty=u1.FSecStockQty+1*Cast(u2.FSecStockQty as Float)
     ,u1.FAuxStockQty=ROUND((u1.FStockQty+1*Cast(u2.FStockQty as Float))/Cast(t3.FCoefficient as Float),t1.FQtyDecimal)
 FROM SEOrderEntry u1 
 INNER JOIN 
 (SELECT FOrderInterID,FOrderEntryID,FItemID,SUM(FQty)AS FStockQty,SUM(FAuxQty) AS FAuxStockQty,SUM(FSecQty) AS FSecStockQty
  FROM ICStockBillEntry WHERE FInterID=@xfinterid
  GROUP BY FOrderInterID,FOrderEntryID,FItemID) u2
 ON u1.FInterID=u2.FOrderInterID AND u1.FEntryID=u2.FOrderEntryID AND u1.FItemID=u2.FItemID
 INNER JOIN t_ICItem t1 ON u1.FItemID=t1.FItemID INNER JOIN t_MeasureUnit t3 ON u1.FUnitID=t3.FItemID
 ---
 
 UPDATE p1 
SET p1.FMrpClosed=CASE WHEN ISNULL(p1.FMRPAutoClosed,1)=1 THEN (CASE WHEN p1.FStockQty<p1.FQty THEN 0 ELSE 1 END) ELSE p1.FMrpClosed END
FROM SEOrderEntry p1 INNER JOIN ICStockBillEntry u1 ON u1.FOrderInterID=p1.FInterID AND u1.FOrderEntryID=p1.FEntryID
WHERE u1.FInterID=@xfinterid
Update t
Set t.FStatus =Case When (SELECT COUNT(1) FROM SEOrderEntry WHERE (FCommitQty>0 OR (ISNULL(FMRPClosed,0)=1 AND ISNULL(FMRPAutoClosed,1)=0)) AND FInterID IN(@FInterID))=0 Then 1 When (SELECT COUNT(1) FROM SEOrderEntry WHERE (ISNULL(FMRPClosed,0)=1 OR  FCommitQty >= FQty ) AND FInterID IN(@FInterID))<(SELECT COUNT(1) FROM SEOrderEntry WHERE FInterID IN(@FInterID)) Then 2 Else 3 End
,t.FClosed =Case WHEN (SELECT COUNT(1) FROM SEOrderEntry te WHERE (te.FCommitQty>=FQty OR (ISNULL(te.FMRPAutoClosed,1)=0 AND ISNULL(FMRPClosed,0)=1)) AND te.FInterID IN(@FInterID))=(SELECT COUNT(1) FROM SEOrderEntry te WHERE te.FInterID IN(@FInterID)) Then 1 Else 0 End
From SEOrder t
WHERE t.FInterID IN(@FInterID)
----
IF EXISTS(SELECT FOrderInterID FROM ICStockBillEntry WHERE FSEOutInterID>0 AND FInterID=@xFInterID)
 UPDATE u1
 SET u1.FStockQty=u1.FStockQty+1*Cast(u2.FStockQty as Float)
     ,u1.FSecStockQty=u1.FSecStockQty+1*Cast(u2.FSecStockQty as Float)
     ,u1.FAuxStockQty=ROUND((u1.FStockQty+1*Cast(u2.FStockQty as Float))/Cast(t3.FCoefficient as Float),t1.FQtyDecimal)
 FROM SEOutStockEntry u1 
 INNER JOIN 
 (SELECT FSEOutInterID,FSEOutEntryID,FItemID,SUM(FQty)AS FStockQty,SUM(FAuxQty) AS FAuxStockQty,SUM(FSecQty) AS FSecStockQty
  FROM ICStockBillEntry WHERE FInterID=@xFInterID
  GROUP BY FSEOutInterID,FSEOutEntryID,FItemID) u2
 ON u1.FInterID=u2.FSEOutInterID AND u1.FEntryID=u2.FSEOutEntryID AND u1.FItemID=u2.FItemID
 INNER JOIN t_ICItemBase t1 ON u1.FItemID=t1.FItemID INNER JOIN t_MeasureUnit t3 ON u1.FUnitID=t3.FItemID
 ----
 update t1 set FcmtQty_O=FcmtQty_O from ExpOutReqEntry t1  
 inner join (  select sum(t1.FQty) FQty,t3.fdetailid  from ICStockBillEntry t1  
               inner join ExpOutReqEntry t2 on t2.fdetailid=t1.fsourceEntryid  
               inner join ExpOutReqEntry t3 on t3.fdetailid=t2.fentryid_src  
               where fsourceinterid>0 and fsourcebillno<>'' and fsourcetrantype=1007131 
               and t1.finterid=@xfinterid group by t3.fdetailid) t2  on t1.fdetailid=t2.fdetailid
---
declare @S_FCustID5 int
declare @S_FCustFID5 int 
declare @S_FEmpID5 int 
declare @S_FEmpFID5 int 
declare @S_FDepID5 int 
declare @S_FDepFID5 int 
declare @S_FStatus5 int 
declare @S_FPara5 int 
declare @S_FAmt5 numeric(18,4) 

select @S_FCustID5=FCustID,@S_FEmpID5=FEmpID,@S_FDepID5=FDeptID,
 @S_FAmt5=(select sum( case when FQty=0 then 0 else convert(numeric(18,2),(CASE WHEN v1.FClosed =1 OR u1.FMRPClosed = 1 THEN (FQty-(CASE WHEN FCommitQty>FQtyInvoice THEN FCommitQty ELSE FQtyInvoice END) - FDiffQtyClosed) ELSE -FDiffQtyClosed END ) / FQty * FAllStdAmount ) END ) from SEOrderEntry u1 INNER JOIN SEOrder v1 ON u1.FInterID=v1.FInterID where (u1.FEntryID =3 or 3 = 0) and u1.FInterID=@FInterID),@S_FStatus=(0),@S_FPara=(2)
from SEOrder where FInterID=@FInterID

if isnull(@S_FAmt5,0)<>0 
begin

Update ICCreditInstant
 set FMainAmtPara2=FMainAmtPara2 - @S_FAmt5  ,
    @S_FCustFID5=case when FItemID=@S_FCustID5 and FCreditClass=0 then FInterID else @S_FCustFID5 end ,
    @S_FEmpFID5=case when FItemID=@S_FEmpID5 and FCreditClass=1 then FInterID else @S_FEmpFID5 end ,
    @S_FDepFID5=case when FItemID=@S_FDepID5 and FCreditClass=2 then FInterID else @S_FDepFID5 end 
where (FItemID=@S_FCustID5 and FCreditClass=0 and FGroupID=1 and FStatus=@S_FStatus5 ) 
     or (FItemID=@S_FEmpID5 and FCreditClass=1 and FGroupID=1 and FStatus=@S_FStatus5) 
     or (FItemID=@S_FDepID5 and FCreditClass=2 and FGroupID=1 and FStatus=@S_FStatus5) 

Update ICCreditInstantEntry 
Set FEntryQtyPara2 = FEntryQtyPara2 - b.FQty
from ICCreditInstantEntry a
     inner join (select b.FInterID,a.FItemID as FItemID ,sum( CASE WHEN c.FClosed =1 OR a.FMRPClosed = 1 THEN (FQty-(CASE WHEN FCommitQty>FQtyInvoice THEN FCommitQty ELSE FQtyInvoice END) - FDiffQtyClosed) ELSE - FDiffQtyClosed END ) as FQty from SEOrderEntry a ,
                 SEOrder c, 
                 (select @S_FCustFID5 as FInterID union all select @S_FEmpFID5 union all select @S_FDepFID5 ) b  
                 where  a.FInterID = c.FInterID AND a.FInterID=@FInterID
                 group by b.FInterID,a.FItemID) b on a.FInterID=b.FInterID and a.FItemID=b.FItemID 
END 


----
UPDATE t1 SET t1.FDiffQtyClosed = (CASE WHEN t2.FClosed =1 OR t1.FMRPClosed =1 THEN t1.FQty-(CASE WHEN t1.FCommitQty>t1.FQtyInvoice THEN t1.FCommitQty ELSE t1.FQtyInvoice END) ELSE 0 END)
  FROM SEOrderEntry t1 INNER JOIN SEOrder t2 ON t1.FInterID = t2.FInterID 
 WHERE t1.FInterID IN (@FInterID)
 ---

 ---
 update ICStockBill set FVIPScore=ABS(FVIPScore)*(-1) WHERE FROB=-1 AND FInterID=@xFInterID
 ---
   UPDATE A SET A.FCommitQty=A.FCommitQty-D.FQty,A.FAuxCommitQty=A.FAuxCommitQty-(D.FQty/T.FCoefficient),
    A.FSecCommitQty=A.FSecCommitQty -D.FSecQty 
    FROM ICStockBillEntry A
    INNER JOIN ICWebReturnEntry B ON B.FID_SRC=A.FInterID AND B.FEntryID_SRC=A.FDetailID AND B.FClassID_SRC=1007572
    INNER JOIN SEOutStockEntry C ON C.FSourceInterId=B.FID AND C.FSourceEntryID=B.FEntryID 
    INNER JOIN ICStockBillEntry D ON D.FSourceInterId =C.FInterID AND D.FSourceEntryID =C.FEntryID AND D.FSourceTranType =82
    LEFT JOIN t_MeasureUnit T ON A.FUnitID=T.FMeasureUnitID 
    WHERE D.FInterID=@xFInterID

---
INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress) 
VALUES (getdate(),16527,'K030500',1,'','系统生成','188.188.1.4')

----生成销售出库
END 
END 
END 

END
