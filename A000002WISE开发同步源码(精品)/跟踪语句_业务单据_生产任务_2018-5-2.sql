SELECT * FROM t_TableDescription where FDescription like '%生产任务%'
select * from t_TableDescription where ftablename='T_MutiWorkCal'
select * from t_FieldDescription where FTableID=470000 order by FFieldName

SELECT FCharSourceItemID,* FROM t_ICItem WHERE FItemID=39420

declare @p2 int
set @p2=1012
exec GetICMaxNum 'ICMO',@p2 output,1,16394
select @p2

INSERT INTO ICMO
(FInterID,FBillNo,FBrNo,FTranType,FCancellation,
FCheckDate,Fstatus,FMRP,FItemID,FCostObjID,
FBomInterID,FRoutingID,FWorkShop,FSupplyID,FWorktypeID,
FUnitID,Fauxqty,FPlanCommitDate,FPlanFinishDate,Fnote,
FCommitDate,FBillerID,FOrderInterID,FParentInterID,FPPOrderInterID,
FType,FSourceEntryID,FProcessPrice,FProcessFee,FPlanOrderInterID,
FScheduleID,FCustID,FMultiCheckDate1,FMultiCheckDate2,FMultiCheckDate3,
FMultiCheckDate4,FMultiCheckDate5,FMultiCheckDate6,FConfirmDate,FInHighLimit,
FAuxInHighLimitQty,FInLowLimit,FAuxInLowLimitQty,FGMPBatchNo,FChangeTimes,
FMrpLockFlag,FCloseDate,FPlanMode,FMtoNo,FPlanConfirmed,
FPrintCount,FCardClosed,FHRReadyTime,FFinClosed,FFinCloseer,
FFinClosedate,FStockFlag,FPlanCategory,FBomCategory,FSourceTranType,
FSourceInterId,FSourceBillNo,FAddInterID,FAPSImported,FAuxPropID,FOrderBOMEntryID) 
SELECT 1012,'WORK000012','0',85,0,
'2018-05-02',0,1052,39420,'39422',
1478,0,35635,0,55,
39249,100,'2018-05-02','2018-05-16','备注',
Null,16394,0,0,0,
1054,0,0,0,0,
0,0,Null,Null,Null,
Null,Null,Null,Null,0,
100,0,100,'',0,
0,Null,14036,'',0,
0,1059,0,0,0,
Null,14215,'1','36820',0,
0,'',0,'0',0,0

DECLARE @FPlanOrderInterID AS INT 
DECLARE @FMRP AS INT  
SELECT @FPlanOrderInterID=ISNULL(FPlanOrderInterID,0)  
      ,@FMRP=ISNULL(FMRP,0) FROM ICMO WHERE FInterid=1012
IF @FMRP=14094 AND ISNULL(@FPlanOrderInterID ,0)>0 
BEGIN 
  Update t_APS_ProcessTaskRelation
  SET FIcomNumber='WORK000012',FICMOID=1012
  WHERE  FMpsOrderId=@FPlanOrderInterID 
END 


 update ICMO set FSourceTranType = 0, FSourceInterID = 0, FSourceBillNo = '' where FSourceTranType = 1201006 AND FMRP = 1052 AND FInterID=1012