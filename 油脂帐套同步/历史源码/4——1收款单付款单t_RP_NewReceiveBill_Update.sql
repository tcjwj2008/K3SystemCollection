ALTER  TRIGGER [dbo].[t_RP_NewReceiveBill_Update]
            ON [dbo].[t_RP_NewReceiveBill]
FOR Update
AS 
declare @DBName varchar(50)
declare @FCheckerID bigint
declare @FInterID varchar(50)

declare @FClassTypeID varchar(50)			---- 1000005	收款单 1000016	付款单 1000015 应收退款单 1000017	应付退款单
declare @FSynchroID varchar(50)

declare @sql varchar(4000)
declare @pp int
declare @FBillNo varchar(50)
declare @nSql nvarchar(4000)

declare @FLastChecker bigint 
DECLARE @LastCheckLevel INTEGER
begin 
 	BEGIN TRANSACTION  
	SET NOCOUNT ON
--	1	同步外购入库单
--2	同步采购发票
--3	同步付款单 3
--4	同步销售出库单
--5	同步销售发票
--6	同步收款单 6
--7	同步生产领料单
--8	同步产品入库单
--9	同步其他入库单  select * from ICClassMCFlowInfo
--10	同步其他出库单
--11	同步记账凭证	
	select @DBName=FDBName from t_BOS_Synchro where FK3Name='帐套同步'
	select @FInterID = FBillID,@FClassTypeID=FClassTypeID,@FSynchroID=ISNULL(FSynchroID,0) from inserted  where FClassTypeID in (1000005,1000016,1000015,1000017)
	


--SELECT TOP 1 @FCheckerID=isnull(FProcessUserID,0)@FCheckerID=isnull(FChecker,0),  FROM ICClassMCTaskCenter where FClassTypeID = @FClassTypeID  AND fbillid=@FInterID ORDER BY fid desc


    --Select TOP 1 @LastCheckLevel=ISNULL(FCheckLevel,0) From t_MultiLevelCheck Where FBillType = @FTranType order by fchecklevel DESC
    SELECT @LastCheckLevel=ISNULL(FMaxLevel,0)  FROM ICClassMCFlowInfo WHERE FID=@FClassTypeID--1000005
    IF @LastCheckLevel=2 
    	select @FCheckerID=isnull(FCheckMan2,0) from ICClassCheckStatus1000005  where FBIllID =@FInterID
    	
    IF isnull(@FCheckerID,0)=0  
    	select @FCheckerID=isnull(FCheckMan2,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
    	
        IF @LastCheckLevel=3 
    	select @FCheckerID=isnull(FCheckMan3,0) from ICClassCheckStatus1000005  where FBIllID =@FInterID
    	    IF isnull(@FCheckerID,0)=0  
    	select @FCheckerID=isnull(FCheckMan3,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
    	
    	    IF @LastCheckLevel=4 
    	select @FCheckerID=isnull(FCheckMan4,0) from ICClassCheckStatus1000005  where FBIllID =@FInterID
    	    IF isnull(@FCheckerID,0)=0  
    	select @FCheckerID=isnull(FCheckMan4,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
    	
    	    IF @LastCheckLevel=5 
    	select @FCheckerID=isnull(FCheckMan5,0) from ICClassCheckStatus1000005  where FBIllID =@FInterID
    	    IF isnull(@FCheckerID,0)=0  
    	select @FCheckerID=isnull(FCheckMan5,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
    	
    	    IF @LastCheckLevel=6 
    	select @FCheckerID=isnull(FCheckMan6,0) from ICClassCheckStatus1000005  where FBIllID =@FInterID
    	    IF isnull(@FCheckerID,0)=0  
    	select @FCheckerID=isnull(FCheckMan6,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
    	
    	
     --  IF (@LastCheckLevel=2) AND (@FCheckerID<=0)
    	--select @FCheckerID=isnull(FCheckMan2,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
     --   IF (@LastCheckLevel=3) AND (@FCheckerID<=0)
    	--select @FCheckerID=isnull(FCheckMan3,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
    	--    IF (@LastCheckLevel=4) AND (@FCheckerID<=0)
    	--select @FCheckerID=isnull(FCheckMan4,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
    	--    IF (@LastCheckLevel=5) AND (@FCheckerID<=0)
    	--select @FCheckerID=isnull(FCheckMan5,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
    	--    IF (@LastCheckLevel=6) AND (@FCheckerID<=0) select * from t_RP_NewReceiveBill
    	--select @FCheckerID=isnull(FCheckMan6,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
 
	if @FClassTypeID in (1000005,1000015)
		SELECT TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=6 AND FChecker=@FCheckerID
	if @FClassTypeID in (1000016,1000017)
		SELECT TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=3 AND FChecker=@FCheckerID
 
		if (len(@DBName) > 0)  and update(FMultiCheckStatus) and @FCheckerID > 0  and @FLastChecker=@FCheckerID AND @FSynchroID=0
	begin 
	
	--生成编号    
	declare @SBillNo nvarchar(50)
        set @SBillNo = ''
        declare @BNoSql nvarchar(300)
        set @BNoSql =' exec '+ @DBName+'.dbo.Pro_BosBillNo  ''XSKD'',40020,@p2 output'
		exec sp_executesql  @BNoSql ,N'@p2   nvarchar(50)   output ',@SBillNo   output
			--t_rp_ARBillOfSH:    FCostType,FFeesMode,FBrID,FExpenseID
		set @pp=0
		set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''t_RP_NewReceiveBill'',@p2 output,1,16394'
		exec sp_executesql  @nSql ,N'@p2   int   output ',@pp  output
    
		set @sql = 
			' insert into ' + @DBName + '.dbo.t_RP_NewReceiveBill(FBillID,FMulCy,FPreAmountFor,FNumber,FDate,FFincDate,FItemClassID,FClassTypeID,
			FCustomer,FPreparer,FDepartment,FEmployee,FAccountID,FCurrencyID,FReceiveCyID,FSettleCyID,FChecker,
			FStatus,FCheckDate,FSettle,FSettleNo,FRPBank,FAdjustExchangeRate,FBankAcct,FBillType,FRPBank_Pay,FContractNo,FBankAcct_Pay,FExplanation,
			FAmountFor,FAmount,FExchangeRate,FOrderID,FSubSystemID,FYear,FPeriod,FSettleAmount,FAdjustAmount,FSettleAmountFor,
			FSettleDiscount,FSettleDiscountFor,FTaskID,FSource,FSourceID,FResourceID,FBudgetAmountFor,FOrderNo,FReceiveAmount,
			FReceiveAmountFor,FDiscountAmount,FDiscountAmountFor,FContractID,FRP,FPre,FTranType_CN) '+

			' select '+cast(@pp as varchar(10))+',FMulCy,FPreAmountFor,'+''''+@SBillNo +''''+ ',FDate,FFincDate,FItemClassID,FClassTypeID,
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_Item where FItemClassID=t.FItemClassID and FNumber = (select top 1 FNumber from t_Item where FItemID= t.FCustomer)),0),     
			isnull((select top 1 FUserID from ' + @DBName + '.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FPreparer)),16394),
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_Department where FNumber =(select top 1 FNumber from t_department where FItemID= t.FDepartment)),0),
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_emp where FNumber =(select top 1 FNumber from t_emp where FItemID= t.FEmployee)),0),
			isnull((select top 1 FAccountID from ' + @DBName +  '.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAccountID)),0),
			isnull((select top 1 FCurrencyID from ' + @DBName + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),1),
			isnull((select top 1 FCurrencyID from ' + @DBName + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FReceiveCyID)),1),
			isnull((select top 1 FCurrencyID from ' + @DBName + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FSettleCyID)),1),
			isnull((select top 1 FUserID from ' + @DBName + '.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FChecker)),16394),
			
			FStatus,FCheckDate,FSettle,FSettleNo,FRPBank,FAdjustExchangeRate,FBankAcct,FBillType,FRPBank_Pay,FContractNo,FBankAcct_Pay,FExplanation,
			FAmountFor,FAmount,FExchangeRate,FOrderID,FSubSystemID,FYear,FPeriod,FSettleAmount,FAdjustAmount,FSettleAmountFor,
			FSettleDiscount,FSettleDiscountFor,FTaskID,FSource,FSourceID,FResourceID,FBudgetAmountFor,FOrderNo,FReceiveAmount,
			FReceiveAmountFor,FDiscountAmount,FDiscountAmountFor,FContractID,FRP,FPre,FTranType_CN
			from  t_RP_NewReceiveBill t where t.FBillID='+@FinterID
 
		exec(@sql)--插入付款单主表
	
		update t_RP_NewReceiveBill  set FSynchroID= @pp   where FBillID=@FInterID 
		
		set @sql = ' insert into ' + @DBName + '.dbo.t_rp_Exchange(FIndex,FSerial,FBillID,FExchangeCyID,FExchangeAmountFor,FExchangeExpenseFor,
			FExchangeExpense,FExchangeRate,FExchangeAmount,FSettleCyID,FSettleAmountFor,FSettleAmount) '+
			' select FIndex,FSerial,'+cast(@pp as varchar(10))+',FExchangeCyID,FExchangeAmountFor,FExchangeExpenseFor,
			FExchangeExpense,FExchangeRate,FExchangeAmount,FSettleCyID,FSettleAmountFor,FSettleAmount 
			from  t_rp_Exchange a where FBillID='+@FinterID
		exec(@sql)
	 
		set @sql = 
			' insert into ' + @DBName + '.dbo.t_rp_ARBillOfSH(FBackAmount_Relative,FBackAmountFor_Relative,FIndex,' +
			'FLinkCheckAmount,FLinkCheckAmountFor,FLinkCheckQty,FRemainAmount,FRemainAmountFor,FBillID,FClassID_SRC,' +
			'FBillNo_SRC,FID_SRC,FEntryID_SRC,FContractNo,FOrderNo,FReceiveCyName,FReceiveAmountFor,FReceiveAmount,FReceiveExchangeRate,' +
			'FSettleCyName,FSettleQuantity,FSettleAmountFor,FSettleAmount,' +
			'FDiscountFor,FDiscount,FExchangeExpenseFor,FRemainAmountFor_SRC,FRemainAmount_SRC,FOrderEntryID,FContractEntryID,' +
			'FExchangeExpense,FOrderInterID,FSettleExchangeRate,FAuxPropID,FQuantity,FTaxPrice,FAccountID,FItemID,FUnitID,FReceiveCyID,FSettleCyID,' +
			'FAmountFor_SRC,Famount_SRC,FCheckAmountFor,FCheckAmount,FAmountFor_Entry,Famount_Entry,FRemainQty)' +

			' select FBackAmount_Relative,FBackAmountFor_Relative,FIndex,
			FLinkCheckAmount,FLinkCheckAmountFor,FLinkCheckQty,FRemainAmount,FRemainAmountFor,'+cast(@pp as varchar(10))+',FClassID_SRC,
			FBillNo_SRC,isnull(t4.FInterID,0),isnull(t4.FDetailID,0),FContractNo,FOrderNo,FReceiveCyName,FReceiveAmountFor,FReceiveAmount,FReceiveExchangeRate,
			FSettleCyName,FSettleQuantity,FSettleAmountFor,FSettleAmount,
			FDiscountFor,FDiscount,FExchangeExpenseFor,FRemainAmountFor_SRC,FRemainAmount_SRC,FOrderEntryID,FContractEntryID,
			FExchangeExpense,FOrderInterID,FSettleExchangeRate,FAuxPropID,FQuantity,FTaxPrice,
			isnull((select top 1 FAccountID from ' + @DBName +  '.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAccountID)),0),
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_ICItem where FNumber=(select FNumber from t_ICItem where FItemID=t.FItemID)),0),
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_measureunit where FNumber=(select FNumber from t_measureunit where FMeasureUnitID=t.FUnitID)),0),
			isnull((select top 1 FCurrencyID from ' + @DBName + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FReceiveCyID)),1),
			isnull((select top 1 FCurrencyID from ' + @DBName + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FSettleCyID)),1),
			
			FAmountFor_SRC,Famount_SRC,FCheckAmountFor,FCheckAmount,FAmountFor_Entry,Famount_Entry,FRemainQty 
			from t_rp_ARBillOfSH t 
			left join (select FInterID,FSynchroID from ICSale) t2 on t2.FInterID=t.FID_SRC     
			left join (select FInterID,FDetailID,FEntryID from ICSaleEntry) t3 on t3.FDetailID=t.FEntryID_SRC   
			left join (select FInterID,FDetailID,FEntryID from ' + @DBName+'.dbo.ICSaleEntry)t4 on t4.FInterID=t2.FSynchroID and  t4.FEntryID=t3.FEntryID
			where t.FBillID='+@FinterID
		exec(@sql)	
		
		set @sql='INSERT INTO ' + @DBName + '.dbo.t_RP_Contact (FBillID,FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,FCustomer,FDepartment,FEmployee,FCurrencyID,
			FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FPre,FK3Import,FInterestRate,FCheckType,
			FStatus,FToBal,FBillType,FInvoiceType,FItemClassID,FExplanation,FPreparer)
			select '+cast(@pp as varchar(10))+',FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_Item where FItemClassID=t.FItemClassID and FNumber = (select top 1 FNumber from t_Item where FItemID= t.FCustomer)),0),     
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_Department where FNumber =(select top 1 FNumber from t_department where FItemID= t.FDepartment)),0),
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_emp where FNumber =(select top 1 FNumber from t_emp where FItemID= t.FEmployee)),0),
			isnull((select top 1 FCurrencyID from ' + @DBName + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),1),
			FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FPre,FK3Import,FInterestRate,FCheckType,
			FStatus,FToBal,FBillType,FInvoiceType,FItemClassID,FExplanation,
			isnull((select top 1 FUserID from ' + @DBName + '.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FPreparer)),16394) 
			from t_RP_Contact t where FType in (5,6) and FBillID='+@FinterID
		exec(@sql)	
					--FType=(case ' + @FClassTypeID + ' when 1000005 then 5 when 1000016 then 6 end) and
	end			----- 审核 END ----
	
	
	if (len(@DBName) > 0) and update(FMultiCheckStatus) and @FCheckerID <= 0 
	begin
			----删除
		  --set @sql ='update ' + @DBName + '.dbo.t_RP_NewReceiveBill set FChecker=0,FStatus=0 where FBillID=' + @FSynchroID
		  --exec(@sql) 
		  set @sql ='delete from ' + @DBName + '.dbo.t_RP_Contact where FBillID=' + @FSynchroID
		  exec(@sql)
		  
		  set @sql ='delete from ' + @DBName + '.dbo.t_rp_ARBillOfSH where FBillID=' + @FSynchroID
		  exec(@sql)
		  
		  set @sql ='delete from ' + @DBName + '.dbo.t_rp_Exchange where FBillID=' + @FSynchroID
		  exec(@sql) 
		  
		  set @sql ='delete from ' + @DBName + '.dbo.t_RP_NewReceiveBill where FBillID=' + @FSynchroID
		  exec(@sql)
		  
		  	  set @sql ='update  t_RP_NewReceiveBill set  FSynchroID=0 where FBIllID='+ @FinterID
		  exec(@sql)

	end
	
	
	
	IF (@@error <> 0)  
		ROLLBACK TRANSACTION  
		
	ELSE  
		COMMIT TRANSACTION 
		
end

 
 