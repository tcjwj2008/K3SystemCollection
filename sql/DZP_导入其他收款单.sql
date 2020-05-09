CREATE PROC sp_K3_insertreceipt_other 
AS
BEGIN
DECLARE  @FNumber VARCHAR(255),@FDate DATETIME,@FFincDate DATETIME,@FClassTypeID VARCHAR(50),@FExplanation VARCHAR(255),
@FAmount DECIMAL(20,13),@FPreparer VARCHAR(50),@FDepartment VARCHAR(50),@FRNumber VARCHAR(255)
DECLARE @FInterID INT ,@FUserID INT ,@FPR_H VARCHAR(4) ,@FPR_E INT,@FPR VARCHAR(15),@FEntryID INT,@FAmount_Sum DECIMAL(20,13)
DECLARE  curReceipt CURSOR FOR
SELECT  FNumber,FDate,FFincDate,FClassTypeID,FExplanation,FAmount,FPreparer,FDepartment FROM dbo.t_dzpreceipt_other
OPEN curReceipt 
FETCH   next  FROM curReceipt  into @FNumber,@FDate,@FFincDate,@FClassTypeID,@FExplanation,@FAmount,@FPreparer,@FDepartment 
WHILE @@FETCH_STATUS = 0 
     BEGIN 
	 SET @FEntryID =1
	 IF NOT EXISTS(SELECT * FROM dbo.t_dzpreceipt WHERE  FNumber=@FNumber and ISNULL(FRNumber,'')<>'' )
	 BEGIN
	 SELECT  FUserID FROM dbo.t_User WHERE FName =@FPreparer
		EXEC dbo.GetICMaxNum 't_RP_ARPBill',@FInterID OUTPUT,1
		SELECT  @FPR_H =FProjectVal  FROM t_BillCodeRule WHERE FBillTypeID='1000021' AND FProjectID =1
		SELECT @FPR_E=FProjectVal+1 FROM t_BillCodeRule WHERE FBillTypeID='1000021' AND FProjectID =3
		UPDATE t_BillCodeRule SET FProjectVal=@FPR_E  WHERE FBillTypeID='1000021' AND FProjectID =3
		SET @FPR=@FPR_H + CONVERT(VARCHAR(11),@FPR_E)
		INSERT INTO t_RP_ARPBill(FItemClassID,FBillType,FDate,FCustomer,FFincDate,FBillID,FExchangeRateType,FCurrencyID,FExchangeRate
		,FInterestRate,FAccountID,FExplanation,FDepartment,FEmployee,FContractNo,FNumber,FAmountFor,FAmount,FChecker,FPreparer,FTaskID,
		FResourceID,FOrderID,FRP,FRemainAmount,FRemainAmountFor,FClassTypeID,FRPDate,FAdjustExchangeRate,FPeriod,FYear,FContractID,
		FSource,FBudgetAmountFor,FPrintCount,FAdjustAmount,FRPBank,FBankAcct,FBankAcctName,FSubSystemID,FPayCondition,FObtainRateWay) 
		VALUES(1,'995',@FDate,(SELECT  FItemID FROM dbo.t_Organization WHERE FNumber = @FClassTypeID),@FFincDate,@FInterID,1,1,1,0,1300,
		@FExplanation,(SELECT  FItemID FROM dbo.t_Department WHERE FName=@FDepartment),0,'',@FPR,@FAmount,@FAmount,0,(SELECT  FUserID 
		FROM dbo.t_User WHERE FName = @FPreparer),0,0,0,'1',@FAmount,@FAmount,1000021,@FDate,1,DATEPART(MONTH,@FFincDate),
		DATEPART(YEAR,@FFincDate),0,0,0,0,0,'','','',0,0,0)
		UPDATE dbo.t_dzpreceipt_other SET FRNumber = @FPR WHERE FNumber =@FNumber
	END
    ELSE
    BEGIN
		SELECT  @FPR =FRNumber FROM dbo.t_dzpreceipt WHERE FNumber=@FNumber
		SELECT  @FInterID =FBillID FROM  t_RP_NewReceiveBill WHERE FNumber =@FPR
		SELECT  @FEntryID=COUNT(*)+1 FROM t_rp_ARBillOfSH WHERE FBillID =@FInterID
	END
	INSERT INTO t_RP_Plan_Ar(FEntryID,FBillID,FDate,FAmountFor,FRemainAmount,FRemainAmountFor,FOrgID,FAmount,FRP) VALUES
	(@FEntryID,@FInterID,@FFincDate,@FAmount,@FAmount,@FAmount,0,@FAmount,1)
	INSERT INTO t_rp_arpbillEntry(FEntryID,FBillID,FClassID_SRC,FBillNo_SRC,FContractNo,famountFor,FID_SRC,FEntryID_SRC,FAmount,
	FTaxRate,FTaxAmountFor,FTaxAmount,FAmountNoTaxFor,FAmountNoTax,FAmountFor_Commit,FRemainAmountFor,FRemainAmountFor_SRC,
	FAmount_Commit,FRemainAmount,FRemainAmount_SRC,FContractEntryID,FPayApplyAmountFor,FPayApplyAmount,FLinkCheckAmountFor,
	FLinkCheckAmount,FInvLinkCheckAmount,FInvLinkCheckAmountFor,FInvoiceAmount,FInvoiceAmountFor,FAPAcctID,FIncomeCode) 
	VALUES(@FEntryID,@FInterID,0,'','',@FAmount,0,0,@FAmount,0,0,0,@FAmount,@FAmount,0,@FAmount,0,0,@FAmount,0,0,0,0,0,0,0,0,0,0,0,0)
	SELECT  @FAmount_Sum=SUM(famountFor) FROM t_rp_arpbillEntry WHERE FBillID =@FInterID
	UPDATE t_RP_ARPBill SET famountFor = @FAmount_Sum,FAmount = @FAmount_Sum,FRemainAmount = @FAmount_Sum
	,FRemainAmountFor = @FAmount_Sum WHERE FBillID=@FInterID
	UPDATE t_organization   set   FLastReceiveDate=@FFincDate,  FLastRPAmount=@FAmount  where FNumber=@FClassTypeID
 FETCH   next  FROM curReceipt  into @FNumber,@FDate,@FFincDate,@FClassTypeID,@FExplanation,@FAmount,@FPreparer,@FDepartment 
 end
end