CREATE PROC sp_K3_insertreceipt
AS 
BEGIN
DECLARE  @FNumber VARCHAR(255),@FDate DATETIME,@FFincDate DATETIME,@FClassTypeID VARCHAR(50),@FExplanation VARCHAR(255),
@FAmount DECIMAL(20,13),@FPreparer VARCHAR(50),@FDepartment VARCHAR(50),@FRNumber VARCHAR(255)
DECLARE @FInterID INT ,@FUserID INT ,@FPR_H VARCHAR(4) ,@FPR_E INT,@FPR VARCHAR(15),@FEntryID INT,@FAmount_Sum DECIMAL(20,13)
DECLARE  curReceipt CURSOR FOR
SELECT  FNumber,FDate,FFincDate,FClassTypeID,FExplanation,FAmount,FPreparer,FDepartment FROM t_dzpreceipt
OPEN curReceipt 
FETCH   next  FROM curReceipt  into @FNumber,@FDate,@FFincDate,@FClassTypeID,@FExplanation,@FAmount,@FPreparer,@FDepartment 
WHILE @@FETCH_STATUS = 0 
     BEGIN 
	 SET @FEntryID =1
	 IF NOT EXISTS(SELECT * FROM dbo.t_dzpreceipt WHERE  FNumber=@FNumber and ISNULL(FRNumber,'')<>'' )
	 BEGIN
	 SELECT  FUserID FROM dbo.t_User WHERE FName =@FPreparer
		EXEC dbo.GetICMaxNum 't_RP_NewReceiveBill',@FInterID OUTPUT,1
		SELECT  @FPR_H =FProjectVal  FROM t_BillCodeRule WHERE FBillTypeID='1000005' AND FProjectID =1
		SELECT @FPR_E=FProjectVal+1 FROM t_BillCodeRule WHERE FBillTypeID='1000005' AND FProjectID =3
		UPDATE t_BillCodeRule SET FProjectVal=@FPR_E  WHERE FBillTypeID='1000005' AND FProjectID =3
		SET @FPR=@FPR_H + CONVERT(VARCHAR(11),@FPR_E)
		INSERT INTO t_RP_NewReceiveBill(FBillID,FMulCy,FNumber,FDate,FFincDate,FAdjustExchangeRate,FItemClassID,FCustomer,FSettle,
		FClassTypeID,FSettleNo,FRPBank_Pay,FBankAcct_Pay,faccountid,FRPBank,FBankAcct,FBillType,FExchangeRateType,FCurrencyID,
		FExchangeRate,FExplanation,FAmountFor,FAmount,FSubSystemID,FContractNo,FSettleAmount,FChecker,FPreparer,FDepartment,
		FSettleDiscount,FEmployee,FTaskID,FReceiveCyID,FResourceID,FBudgetAmountFor,FSettleCyID,FOrderID,FReceiveAmount,FYear,
		FPeriod,FReceiveAmountFor,FDiscountAmount,FAdjustAmount,FSettleAmountFor,FDiscountAmountFor,FPrintCount,FSettleDiscountFor,
		FSource,FSourceID,FOrderNo,FContractID,FRP,FPre,FBankAcctName,FObtainRateWay,FConfirmAdvice,FBase,FConfirmor,FPaySettNo,
		FConfirmDate,FText,FConfirmFlag) 
		VALUES(@FInterID,0,@FPR,@FDate,@FFincDate,1,1,(SELECT  FItemID FROM dbo.t_Organization WHERE FNumber = @FClassTypeID),0,1000005,'',
		'','',0,'','','1000',1,1,1,@FExplanation,@FAmount,@FAmount,'','',@FAmount,0,(SELECT  FUserID FROM dbo.t_User WHERE FName = 
		@FPreparer),(SELECT  FItemID FROM dbo.t_Department WHERE FName=@FDepartment),0,0,0,1,0,0,1,0,@FAmount,DATEPART(YEAR,@FFincDate),
		DATEPART(MONTH,@FFincDate),@FAmount,0,0,@FAmount,0,0,0,0,0,'',0,1,0,'',0,'',0,0,'',NULL,'','')
		UPDATE dbo.t_dzpreceipt SET FRNumber = @FPR WHERE FNumber =@FNumber
	END
    ELSE
    BEGIN
		SELECT  @FPR =FRNumber FROM dbo.t_dzpreceipt WHERE FNumber=@FNumber
		SELECT  @FInterID =FBillID FROM  t_RP_NewReceiveBill WHERE FNumber =@FPR
		SELECT  @FEntryID=COUNT(*)+1 FROM t_rp_ARBillOfSH WHERE FBillID =@FInterID
	END
	INSERT INTO t_rp_ARBillOfSH(FBackAmount_Relative,FBackAmountFor_Relative,FIndex,FLinkCheckAmount,FLinkCheckAmountFor,FLinkCheckQty,
	FBillID,FClassID_SRC,FBillNo_SRC,FContractNo,FOrderNo,FReceiveCyName,FReceiveAmountFor,FReceiveAmount,FReceiveExchangeRate,
	FSettleCyName,FSettleQuantity,FSettleAmountFor,FID_SRC,FReceiveCyID,FSettleCyID,FEntryID_SRC,FSettleAmount,FDiscountFor,FDiscount,
	FExchangeExpenseFor,FRemainAmountFor,FRemainAmountFor_SRC,FRemainAmount,FRemainAmount_SRC,FOrderEntryID,FContractEntryID,
	FExchangeExpense,FOrderInterID,FSettleExchangeRate,FAccountID,FItemID,FAuxPropID,funitid,FQuantity,FTaxPrice,FAmountFor_SRC,
	Famount_SRC,FCheckAmountFor,FCheckAmount,FAmountFor_Entry,Famount_Entry,FRemainQty,
	FConfirmAdvice,FFeeObjID) Values(0,0,@FEntryID,0,0,0,@FInterID,0,'','','','',@FAmount,@FAmount,1,'',0,@FAmount,0,1,1,0,@FAmount,0,0,0,
	100,0,@FAmount,0,0,0,0,0,1,1364,0,0,0,0,0,0,0,0,0,@FAmount,@FAmount,0,'',0)
	SELECT  @FAmount_Sum=SUM(FReceiveAmountFor) FROM t_rp_ARBillOfSH WHERE FBillID =@FInterID
	UPDATE t_RP_NewReceiveBill SET FReceiveAmountFor = @FAmount_Sum,FReceiveAmount = @FAmount_Sum,FSettleAmountFor = @FAmount_Sum
	,FSettleAmount = @FAmount_Sum,FRemainAmount=@FAmount_Sum WHERE FBillID=@FInterID
	UPDATE t_organization   set   FLastReceiveDate=@FFincDate,  FLastRPAmount=@FAmount  where FNumber=@FClassTypeID
 FETCH   next  FROM curReceipt  into @FNumber,@FDate,@FFincDate,@FClassTypeID,@FExplanation,@FAmount,@FPreparer,@FDepartment 
 end
end



CREATE TABLE [dbo].[t_dzpreceipt](
	[FNumber] [VARCHAR](255) NULL,
	[FDate] [DATETIME] NULL,
	[FFincDate] [DATETIME] NULL,
	[FClassTypeID] [VARCHAR](50) NULL,
	[FExplanation] [VARCHAR](255) NULL,
	[FAmount] [DECIMAL](20, 8) NULL,
	[FPreparer] [VARCHAR](50) NULL,
	[FDepartment] [VARCHAR](50) NULL,
	[FRNumber] [VARCHAR](255) NULL
) ON [PRIMARY]