alter PROC sp_K3_insertmarketstore
AS
BEGIN
DECLARE @FDate DATETIME,@FBillno VARCHAR(255),@FExplanation VARCHAR(255),@FSupplyNumber VARCHAR(255),@FAccountNumber VARCHAR(40),
@FItemNumber VARCHAR(80),@FBatchNo VARCHAR(200),@FQty DECIMAL(28,10),@FPrice DECIMAL(28,10),@FStockNumber VARCHAR(80),
@FNote VARCHAR(255),@FDeptName VARCHAR(80),@FEmpName VARCHAR(50),@FBillerName VARCHAR(50),@FFManagerName VARCHAR(50),
@FSManager VARCHAR(50),@FReturnBillno VARCHAR(255),@productdate DATETIME,@FSaleStyle VARCHAR(30)
DECLARE @FInterID INT,@FEntryID INT ,@FWareid INT ,@FCustomerID INT,@FStockID INT,@FUnderStock INT,@FUerid INT,
@FBillno_New VARCHAR(255)
DECLARE curXSCK CURSOR FOR
SELECT FDate,FBillno,FExplanation,FSupplyNumber,FAccountNumber,FItemNumber,FBatchNo,FQty,FPrice,FStockNumber,FNote,FDeptName,FEmpName,
FBillerName,FFManagerName,FSManager,productdate,FSaleStyle  FROM  dbo.t_SaleIns
OPEN curXSCK 
FETCH   next  FROM curXSCK  into @FDate,@FBillno,@FExplanation,@FSupplyNumber,@FAccountNumber,@FItemNumber,@FBatchNo,@FQty,@FPrice,
@FStockNumber,@FNote,@FDeptName,@FEmpName,@FBillerName,@FFManagerName,@FSManager,@productdate,@FSaleStyle 
WHILE @@FETCH_STATUS = 0 
    BEGIN 
	SET @FEntryID =1
	SELECT  @FWareid=FItemID FROM t_icitem WHERE FNumber=@FItemNumber
	SELECT @FCustomerID=FItemID FROM dbo.t_Organization WHERE FNumber=@FSupplyNumber
	SELECT  @FUerid=FUserID FROM dbo.t_User WHERE FName =@FBillerName
	SELECT  @FStockID=FItemID,@FUnderStock=FUnderStock FROM dbo.t_Stock WHERE FNumber=@FStockNumber
	IF EXISTS(select * from t_systemprofile where Fkey in ('UPSTOCKWHENSAVE') AND FCateGory='IC'  AND FValue =1)
	BEGIN
		IF @FUnderStock =1
		BEGIN
			IF EXISTS(SELECT  * FROM dbo.ICInventory WHERE FItemID=@FWareID AND FStockID=@FStockID AND FBatchNo=@FBatchNo)
				UPDATE ICInventory SET FQty  = FQty - @FQty WHERE FItemID=@FWareID AND FStockID=@FStockID AND FBatchNo=@FBatchNo
			ELSE
				INSERT INTO dbo.ICInventory(FBrNo,FItemID,FBatchNo,FStockID,FBal,FStockPlaceID,FKFPeriod,FKFDate,FQtyLock,FAuxPropID,FSecQty,
						FMTONo,FSupplyID)
				VALUES  ('0',@FWareID,@FBatchNo,@FStockID,NULL,0,0,0,0,0,-@FQty,'',0)
		END
		ELSE
		BEGIN
			IF EXISTS(SELECT  * FROM dbo.ICInventory WHERE FItemID=@FWareID AND FStockID=@FStockID AND FBatchNo=@FBatchNo AND FQty >@FQty)
				UPDATE ICInventory SET FQty  =FQty - @FQty WHERE FItemID=@FWareID AND FStockID=@FStockID AND FBatchNo=@FBatchNo
			ELSE
				RAISERROR('ц╩сп©Б╢Ф',1,16)
		END		
	END			
	IF EXISTS(SELECT  * FROM dbo.t_SaleIns WHERE ISNULL(FReturnBillno,'')='' AND FBillno =@FBillno )	BEGIN
		EXEC dbo.GetICMaxNum  'ICStockBill', @FInterID OUTPUT,1,@FUerid
		EXEC dbo.p_GetICBillNo 21,@FBillno_New OUTPUT
		INSERT INTO ICStockBill(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FUpStockWhenSave,FROB,FHookStatus,
		Fdate,FSupplyID,FCheckDate,FFManagerID,FSManagerID,FBillerID,FPOStyle,FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,
		FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,
		FMultiCheckLevel6,FMultiCheckDate6,FRelateBrID,FPOOrdBillNo,FOrgBillInterID,FSelTranType,FBrID,FExplanation,FDeptID,
		FManagerID,FEmpID,FCussentAcctID,FManageType,FSettleDate,FPrintCount,FPOMode,FPayCondition,FHeadSelfA0139,FHeadSelfA0140,FSaleStyle) 
		SELECT @FInterID,@FBillno_New,'0',21,0,0,1,1,0,@FDate,@FCustomerID,Null,(SELECT TOP 1 FItemID FROM dbo.t_Emp WHERE 
		FName=@FFManagerName),(SELECT TOP 1 FItemID FROM dbo.t_Emp WHERE FName=@FSManager),@FUerid,252,Null,Null,Null,Null,Null,Null,
		NULL,NULL,Null,Null,Null,Null,0,'',0,0,0,'',(SELECT TOP 1 FItemID FROM dbo.t_Department WHERE FName=@FDeptName),0,
		(SELECT TOP 1  FItemID FROM dbo.t_Emp WHERE FName=@FEmpName),0,0,@FDate,0,36680,0,9439,7592,'101'
		UPDATE  dbo.t_SaleIns SET FReturnBillno=@FBillno_New WHERE ISNULL(FReturnBillno,'')='' AND FBillno =@FBillno        
	END
	ELSE
	BEGIN
		SELECT @FInterID=MIN(b.FInterID) FROM dbo.t_SaleIns a, dbo.ICStockBill b WHERE a.FReturnBillno=b.FBillNo
		SELECT @FEntryID= COUNT(*)+1 FROM dbo.ICStockBillEntry WHERE FInterID =@FInterID
	END  
	INSERT INTO ICStockBillEntry (FInterID,FEntryID,FBrNo,FMapNumber,FMapName,FItemID,FAuxPropID,FBatchNo,FQtyMust,FQty,FUnitID,
	FAuxQtyMust,Fauxqty,FSecCoefficient,FSecQty,FAuxPlanPrice,FPlanAmount,Fauxprice,Famount,FEntrySelfA0160,Fnote,
	FKFDate,FKFPeriod,FPeriodDate,FDCStockID,FDCSPID,FOrgBillEntryID,FSNListID,FSourceBillNo,FSourceTranType,FSourceInterId,
	FSourceEntryID,FContractBillNo,FContractInterID,FContractEntryID,FOrderBillNo,FOrderInterID,FOrderEntryID,FAllHookQTY,
	FAllHookAmount,FCurrentHookQTY,FCurrentHookAmount,FPlanMode,FMTONo,FChkPassItem,FDeliveryNoticeFID,FDeliveryNoticeEntryID,
	FEntrySelfA0159)  SELECT @FInterID,@FEntryID,'0','','',@FWareID,0,@FBatchNo,@FQty,@FQty,(SELECT FUnitID FROM dbo.t_ICItem WHERE 
	FItemID=@FWareID),@FQty,@FQty,0,0,0,0,@FPrice,@FQty*@FPrice,5100,@FNote,
	@productdate,(SELECT  FKFPeriod FROM dbo.t_ICItem  WHERE FItemID=@FWareID),DATEADD(DAY,(SELECT  FKFPeriod FROM dbo.t_ICItem  
	WHERE FItemID=@FWareID),@productdate),@FStockID,0,0,0,'',0,0,0,'',0,0,'',0,0,0,0,0,0,14036,'',1058,0,0,5100 
	--EXEC p_UpdateBillRelateData  21,@FInterID,'ICStockBill','ICStockBillEntry' 
	FETCH   next  FROM curXSCK  into @FDate,@FBillno,@FExplanation,@FSupplyNumber,@FAccountNumber,@FItemNumber,@FBatchNo,@FQty,@FPrice,
@FStockNumber,@FNote,@FDeptName,@FEmpName,@FBillerName,@FFManagerName,@FSManager,@productdate,@FSaleStyle 
	END
	CLOSE curXSCK
	DEALLOCATE curXSCK
END




CREATE TABLE [dbo].[t_SaleIns](
	[FDate] [DATETIME] NULL,
	[FBillno] [VARCHAR](255) NULL,
	[FExplanation] [VARCHAR](255) NULL,
	[FSupplyNumber] [VARCHAR](255) NULL,
	[FAccountNumber] [VARCHAR](40) NULL,
	[FItemNumber] [VARCHAR](80) NULL,
	[FBatchNo] [VARCHAR](200) NULL,
	[FQty] [DECIMAL](28, 10) NULL,
	[FPrice] [DECIMAL](28, 10) NULL,
	[FStockNumber] [VARCHAR](80) NULL,
	[FNote] [VARCHAR](255) NULL,
	[FDeptName] [VARCHAR](80) NULL,
	[FEmpName] [VARCHAR](50) NULL,
	[FBillerName] [VARCHAR](50) NULL,
	[FFManagerName] [VARCHAR](50) NULL,
	[FSManager] [VARCHAR](50) NULL,
	[FReturnBillno] [VARCHAR](255) NULL,
	[productdate] [DATETIME] NULL,
	[FSaleStyle] [VARCHAR](30) NULL
) ON [PRIMARY]
