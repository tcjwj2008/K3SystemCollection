IF  OBJECT_ID('tempWGLK') IS NOT NULL DROP TABLE tempWGLK
CREATE TABLE tempWGLK(FDate DATETIME NOT Null,FBillno VARCHAR(255) NOT Null,FExplanation VARCHAR(255),FSupplyNumber VARCHAR(255) NOT Null,FAccountNumber VARCHAR(40),FItemNumber VARCHAR(80) NOT Null,FBatchNo VARCHAR(200),FQty DECIMAL(28,10) NOT Null,FPrice DECIMAL(28,10) NOT Null,FStockNumber VARCHAR(80) NOT Null,FNote VARCHAR(255),FDeptName VARCHAR(80),FEmpName VARCHAR(50) NOT Null,FBillerName VARCHAR(50) NOT Null,FFManagerName VARCHAR(50) NOT Null,FSManager VARCHAR(50) NOT Null,FReturnBillno VARCHAR(255),productdate DATETIME,FSecCoefficient DECIMAL(28,10),FSecQty DECIMAL(28,10),FEntrySelfA0158 DECIMAL(28,10),FEntrySelfA0160 DECIMAL(28,10))
GO
IF  OBJECT_ID('sp_K3_insertoutsourceWarehousing') IS NOT NULL DROP PROC sp_K3_insertoutsourceWarehousing
go
CREATE PROC sp_K3_insertoutsourceWarehousing
AS 
BEGIN
DECLARE @FDate DATETIME,@FBillno VARCHAR(255),@FExplanation VARCHAR(255),@FSupplyNumber VARCHAR(255),@FAccountNumber VARCHAR(40),
@FItemNumber VARCHAR(80),@FBatchNo VARCHAR(200),@FQty DECIMAL(28,10),@FStockNumber VARCHAR(80),@FNote VARCHAR(255),
@FDeptName VARCHAR(80),@FEmpName VARCHAR(50),@FBillerName VARCHAR(50),@FFManagerName VARCHAR(50),@FSManager VARCHAR(50),
@FReturnBillno VARCHAR(255),@productdate DATETIME,@FPrice DECIMAL(28,10),@FSecCoefficient DECIMAL(28,10),@FSecQty DECIMAL(28,10),
@FEntrySelfA0158 DECIMAL(28,10),@FEntrySelfA0160 DECIMAL(28,10)
DECLARE  @FInterID INT,@FEntryID INT,@FWareID INT,@FStockID INT,@FBillno_New VARCHAR(255),@FUerid INT,@FSupplyID INT
DECLARE curWGLK CURSOR FOR
SELECT  FDate,FBillno,FExplanation,FSupplyNumber,FAccountNumber,FItemNumber,FBatchNo,FQty,FPrice,FStockNumber,FNote,FDeptName,FEmpName,
FBillerName,FFManagerName,FSManager,productdate,FSecCoefficient,FSecQty,FEntrySelfA0158,FEntrySelfA0160 FROM tempWGLK
OPEN curWGLK 
FETCH   next  FROM curWGLK  into @FDate,@FBillno,@FExplanation,@FSupplyNumber,@FAccountNumber,@FItemNumber,@FBatchNo,@FQty,@FPrice,
@FStockNumber,@FNote,@FDeptName,@FEmpName,@FBillerName,@FFManagerName,@FSManager,@productdate,@FSecCoefficient,@FSecQty,@FEntrySelfA0158,
@FEntrySelfA0160
WHILE @@FETCH_STATUS = 0 
    BEGIN 
	SET @FInterID =NULL
	SET @FEntryID =1
	SELECT  @FUerid=FUserID FROM dbo.t_User WHERE FName=@FBillerName
	SELECT  @FWareID=FItemID FROM dbo.t_ICItem WHERE FNumber=@FItemNumber
	SELECT  @FStockID=FItemID  FROM dbo.t_Stock WHERE FNumber =@FStockNumber
	SELECT @FSupplyID= FItemID FROM dbo.t_Supplier WHERE FNumber=@FSupplyNumber
	IF EXISTS(select * from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC'  AND FValue =1)
	BEGIN
		IF @productdate =''
		SET @productdate =	NULL
		IF EXISTS(SELECT  * FROM dbo.ICInventory WHERE FItemID=@FWareID AND FStockID=@FStockID AND FBatchNo=@FBatchNo)
			UPDATE ICInventory SET FQty  =FQty+@FQty WHERE FItemID=@FWareID AND FStockID=@FStockID AND FBatchNo=@FBatchNo
		ELSE
			INSERT INTO dbo.ICInventory(FBrNo,FItemID,FBatchNo,FStockID,FBal,FStockPlaceID,FKFPeriod,FKFDate,FQtyLock,FAuxPropID,FSecQty,
				      FMTONo,FSupplyID)
			VALUES  ('0',@FWareID,@FBatchNo,@FStockID,0,0,0,'',0,0,@FQty,'',0)
	END
	
	IF EXISTS(SELECT  * FROM tempWGLK WHERE ISNULL(FReturnBillno,'')='' AND FBillno =@FBillno AND FDate =@FDate )
	BEGIN
		EXEC dbo.GetICMaxNum  'ICStockBill', @FInterID OUTPUT,1,@FUerid
		EXEC dbo.p_GetICBillNo 1,@FBillno_New OUTPUT
		INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FROB,FHookStatus,
		Fdate,FSupplyID,FCheckDate,FFManagerID,FSManagerID,FBillerID,FPOStyle,FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,
		FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,
		FMultiCheckLevel6,FMultiCheckDate6,FRelateBrID,FPOOrdBillNo,FOrgBillInterID,FSelTranType,FBrID,FExplanation,FDeptID,
		FManagerID,FEmpID,FCussentAcctID,FManageType,FSettleDate,FPrintCount,FPOMode,FPayCondition,FHeadSelfA0139,FHeadSelfA0140) 
		SELECT @FInterID,@FBillno_New,'0',1,0,0,1,1,0,@FDate,@FSupplyID,Null,(SELECT  TOP 1 FItemID FROM dbo.t_Emp WHERE 
		FName=@FFManagerName),(SELECT  TOP 1 FItemID FROM dbo.t_Emp WHERE FName=@FSManager),@FUerid,252,Null,Null,Null,Null,Null,Null,
		NULL,NULL,Null,Null,Null,Null,0,'',0,0,0,'',(SELECT TOP 1 FItemID FROM dbo.t_Department WHERE FName=@FDeptName),0,
		((SELECT  TOP 1 FItemID FROM dbo.t_Emp WHERE FName=@FEmpName)),0,0,@FDate,0,36680,0,9439,7592
		UPDATE  tempWGLK SET FReturnBillno=@FBillno_New WHERE ISNULL(FReturnBillno,'')='' AND FBillno =@FBillno
	END
	ELSE
	BEGIN
		SELECT @FInterID=MIN(b.FInterID) FROM dbo.tempWGLK a, dbo.ICStockBill b WHERE a.FReturnBillno=b.FBillNo AND a.FBillno=@FBillno
		SELECT @FEntryID= COUNT(*)+1 FROM dbo.ICStockBillEntry WHERE FInterID =@FInterID
	END  
	select @FBillno ,@FInterID,@FEntryID,@FDate
	INSERT INTO ICStockBillEntry (FInterID,FEntryID,FBrNo,FMapNumber,FMapName,FItemID,FAuxPropID,FBatchNo,FQtyMust,FQty,FUnitID,
	FAuxQtyMust,Fauxqty,FSecCoefficient,FSecQty,FAuxPlanPrice,FPlanAmount,Fauxprice,Famount,FEntrySelfA0158,FEntrySelfA0160,Fnote,
	FKFDate,FKFPeriod,FPeriodDate,FDCStockID,FDCSPID,FOrgBillEntryID,FSNListID,FSourceBillNo,FSourceTranType,FSourceInterId,
	FSourceEntryID,FContractBillNo,FContractInterID,FContractEntryID,FOrderBillNo,FOrderInterID,FOrderEntryID,FAllHookQTY,
	FAllHookAmount,FCurrentHookQTY,FCurrentHookAmount,FPlanMode,FMTONo,FChkPassItem,FDeliveryNoticeFID,FDeliveryNoticeEntryID,
	FEntrySelfA0159)  SELECT @FInterID,@FEntryID,'0','','',@FWareID,0,@FBatchNo,@FQty,@FQty,(SELECT FUnitID FROM dbo.t_ICItem WHERE 
	FItemID=@FWareID),@FQty,@FQty,@FSecCoefficient,@FSecQty,0,0,@FPrice/@FQty,@FPrice,@FEntrySelfA0158,@FEntrySelfA0160,@FNote,
	@productdate,(SELECT TOP 1 FKFPeriod FROM dbo.t_ICItem  WHERE FItemID=@FWareID),DATEADD(DAY,(SELECT  TOP 1 FKFPeriod FROM dbo.t_ICItem  
	WHERE FItemID=@FWareID),@productdate),@FStockID,0,0,0,'',0,0,0,'',0,0,'',0,0,0,0,0,0,14036,'',1058,0,0,5100
	SET @productdate =NULL 
	--EXEC p_UpdateBillRelateData  1,@FInterID,'ICStockBill','ICStockBillEntry' 
	FETCH   next  FROM curWGLK  into @FDate,@FBillno,@FExplanation,@FSupplyNumber,@FAccountNumber,@FItemNumber,@FBatchNo,@FQty,@FPrice,
	@FStockNumber,@FNote,@FDeptName,@FEmpName,@FBillerName,@FFManagerName,@FSManager,@productdate,@FSecCoefficient,@FSecQty,@FEntrySelfA0158,
	@FEntrySelfA0160
	END
CLOSE curWGLK
DEALLOCATE curWGLK
--DELETE FROM  tempWGLK
END
go
IF  OBJECT_ID('validationdate') IS NOT NULL DROP PROC validationdate
GO
CREATE PROC   validationdate AS
BEGIN
	SELECT  1
END

