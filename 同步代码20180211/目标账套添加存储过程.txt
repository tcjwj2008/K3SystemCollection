--AIS_YXDZP2018_3 
--AIS_YXRY2_3
--AIS_YXRZP2_3
--AIS_YXYZ_3

-


CREATE    PROC sp_update_t_Voucher_fnumber @FVoucherID INT

AS 
--凭证号自动填充中断的号码  在目标帐套创建 在同步触发器中添加调用代码
SET NOCOUNT ON 
DECLARE @FYear INT, @FPeriod INT, @FNumber INT,@Num INT
SET @Num =1
SELECT @FYear=FYear, @FPeriod=FPeriod, @FNumber=FNumber 
FROM dbo.t_Voucher WHERE FVoucherID=@FVoucherID
WHILE @Num<@FNumber
BEGIN
   IF NOT  EXISTS(SELECT 1 FROM t_Voucher WHERE FNumber=@Num AND FYear=@FYear AND FPeriod=@FPeriod)
   BEGIN
     UPDATE  t_Voucher SET  FNumber=@Num WHERE FVoucherID=@FVoucherID

     BREAK
   END 
    
   SET @Num=@Num+1
END 

go


create procedure [dbo].[Ly_GetICBillNo]  
    @IsSave         smallint,  
    @FBillType     int,  
    @BillID     VARCHAR (50) output  
AS  
declare @FNumMax INT  
declare @DateFormat varchar(8)  
declare @i int  
declare @FID varchar(10)  
  
--SELECT * ,FFormat,FCurNo FROM ICBillNo where FBillId= 1000021  
select @FNumMax= FCurNo + 1,@DateFormat=FFormat from ICBillNo where FBillId = @FBillType  
  
    if len(@FNumMax) < LEN(@DateFormat)  
    begin     
  set @i = len(@FNumMax)  
  set @FID = ''  
  while @i < LEN(@DateFormat)  
  begin  
    set @FID = @FID + '0'    
    set @i = @i + 1  
  end  
  set @FID = @FID --+ CAST(@FNumMax as VARCHAR(8))  
  --set @BillID = @BillNoTitle + @DateFormat + @FID  
    END  
        else  
        set @FID = ''  
  
    select @BillID = isnull(FPreLetter,'') + @FID + convert(VARCHAR (20),isnull(FCurNo+0,1))+ isnull(FSufLetter,'')  
      from ICBillNo  
     where FBillId= @FBillType  
    begin tran  
    if @IsSave=1 
    BEGIN
    
    --源语句
     --UPDATE ICBillNo set FCurNo=FCurNo+1 where FBillId = @FBillType       
    --修改后语句2015-7-3
    UPDATE ICBillNo set FCurNo=FCurNo+1,FDesc=FPreLetter+'+'+ CAST( (FCurNo+1) AS varchar) where FBillId = @FBillType  
    DECLARE @FProjectVal VARCHAR(20)
    SELECT @FProjectVal=CAST((FCurNo) AS varchar) FROM ICBillNo WHERE  FBillId = @FBillType    
    UPDATE t_BillCodeRule SET FProjectVal=@FProjectVal   WHERE FBillTypeID=@FBillType and FClassIndex=2
      
    end
    if @@error=0 commit  
    else  
    begin  
        rollback  
        select @BillID=''  
    end  
    return  


CREATE PROC [dbo].[sp_ic41tb_auto_ICInventory] @cfinterid int   
AS   
SET NOCOUNT ON  
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
  
  
INSERT INTO #TempBill(FBrNo,FInterID,FEntryID,FTranType,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty,FAmount)  
SELECT '',u1.FInterID,u1.FEntryID,41 AS FTranType,u1.FItemID,ISNULL(u1.FBatchNo,'') AS FBatchNo,ISNULL(u1.FMTONo,'') AS FMTONo,  
       u1.FAuxPropID,ISNULL(u1.FDCStockID,0) AS FDCStockID,ISNULL(u1.FDCSPID,0) AS FDCSPID,ISNULL(u1.FKFPeriod,0) AS FKFPeriod,  
       LEFT(ISNULL(CONVERT(VARCHAR(20),u1.FKFdate ,120),''),10) AS FKFDate,  
1*u1.FQty AS FQty,1*u1.FSecQty AS FSecQty,1*u1.FAmtRef  
FROM ICStockBillEntry u1   
WHERE u1.FInterID=@cfinterid  
INSERT INTO #TempBill(FBrNo,FInterID,FEntryID,FTranType,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FSupplyID,FQty,FSecQty,FAmount)  
SELECT '',u1.FInterID,u1.FEntryID,41 AS FTranType,u1.FItemID,ISNULL(u1.FBatchNo,'') AS FBatchNo,ISNULL(u1.FMTONo,'') AS FMTONo,  
       u1.FAuxPropID,ISNULL(u1.FSCStockID,0) AS FSCStockID,ISNULL(u1.FSCSPID,0) AS FSCSPID,ISNULL(u1.FKFPeriod,0) AS FKFPeriod,  
       LEFT(ISNULL(CONVERT(VARCHAR(20),u1.FKFdate ,120),''),10) AS FKFDate,FEntrySupply,  
-u1.FQty*1 AS FQty,-u1.FSecQty*1 AS FSecQty,1*(-1)*u1.FAmount  
FROM ICStockBillEntry u1   
WHERE u1.FInterID=@cfinterid  
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
DROP  TABLE #TempBill  
  
  
