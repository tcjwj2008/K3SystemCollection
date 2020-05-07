create TRIGGER [dbo].[ICPurchase_Update]
            ON [dbo].[ICPurchase]
FOR Update
AS 
declare @DBName varchar(50)
declare @FInterID varchar(50)
declare @FCheckerID bigint
declare @sql varchar(4000)

declare @Frob integer --判断红字出货
declare @FStatus int
declare @pp int
declare @FBillNo varchar(50)
declare @nSql nvarchar(4000)
declare @FSynchroID varchar(50)

declare @FLastChecker bigint 
begin
	BEGIN TRANSACTION  
	SET NOCOUNT ON
--	1	同步外购入库单
--2	同步采购发票
--3	同步付款单
--4	同步销售出库单
--5	同步销售发票
--6	同步收款单
--7	同步生产领料单
--8	同步产品入库单
--9	同步其他入库单
--10	同步其他出库单
--11	同步记账凭证	
	select @DBName=FDBName from t_BOS_Synchro where FK3Name='帐套同步'
	select @FInterID=FInterID,@FCheckerID= ISNULL(FCheckerID,0),@FSynchroID=isnull(FSynchroID,0),@FStatus=FStatus from inserted  
	
    select @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=2

	if (len(@DBName) > 0) and UPDATE(FCheckerID) and @FCheckerID >0 and @FStatus=1 and  @FLastChecker=@FCheckerID
	begin 
	
		set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''ICPurchase'',@p2 output,1,16394'
		exec sp_executesql  @nSql ,N'@p2   int   output ',@pp   output
    
		set @Sql = 
		    ' insert into ' + @DBName + '.dbo.ICPurchase(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FROB,FClassTypeID,FSubSystemID,
			FYear,FPeriod,FItemClassID,FFincDate,FHookStatus,Fdate,FTaxNum,FSupplyID,FDeptID,FEmpID,FManagerID,FCussentAcctID,
			FBillerID,FCurrencyID,FInvStyle,FExchangeRate,FCompactNo,Fnote,FPOStyle,FYearPeriod,
			FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,FMultiCheckDate2,FPOOrdBillNo,FMultiCheckLevel3,FMultiCheckDate3,
			FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,
			FYtdIntRate,FAcctID,FOrgBillInterID,FHookerID,FSelTranType,FBrID,FSettleDate,FSysStatus,FVchInterID,
			FAdjustExchangeRate,FArApStatus,FTotalCost,FTotalCostFor,FCheckerID,FCheckDate) '+
				
			' select '+cast(@pp as varchar(10))+',FBillNo,FBrNo,FTranType,FCancellation,FStatus,FROB,FClassTypeID,FSubSystemID,  
			FYear,FPeriod,FItemClassID,FFincDate,FHookStatus,Fdate,FTaxNum,
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_supplier where FNumber=(select FNumber from t_supplier where FItemID=t.FSupplyID)),0),
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_department where FNumber=(select FNumber from t_department where FItemID=t.FDeptID)),0),
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FEmpID)),0),
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FManagerID)),0),
			isnull((select top 1 FAccountID from ' + @DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FCussentAcctID)),0),			
			16394,FCurrencyID,FInvStyle,FExchangeRate,FCompactNo,Fnote,FPOStyle,FYearPeriod,
			FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,FMultiCheckDate2,FPOOrdBillNo,FMultiCheckLevel3,FMultiCheckDate3,   
			FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,    
			FYtdIntRate,FAcctID,FOrgBillInterID,FHookerID,FSelTranType,FBrID,FSettleDate,FSysStatus,FVchInterID,
			FAdjustExchangeRate,FArApStatus,FTotalCost,FTotalCostFor,16394,FCheckDate   
			from ICPurchase t 
			where t.FInterID='+ @FinterID
			
			
		exec(@Sql)		--插入购货发票（专用）主表
			
		update ICPurchase  set FSynchroID= @pp   where FInterid=@FInterID 
 
 
		set @Sql =  
		  'insert into ' + @DBName + '.dbo.ICPurchaseEntry (FInterID,FEntryID,FBrNo,FMapNumber,FMapName,FItemID,FUnitID,
		  FAuxPropID,FQty,FAuxqty,FSecCoefficient,FSecQty,FDiscountRate,' +
		  'FTaxRate,FOrgBillEntryID,FOrderPrice,FAuxOrderPrice,FClassID_SRC,FEntryID_SRC,' +
		  'FSourceTranType,FSourceEntryID,FSourceInterId,FOrderEntryID,FOrderInterID,FSourceBillNo,FOrderBillNo,FContractBillNo,FContractInterID,FContractEntryID,' +
		  'FAllHookQTY,FStdAllHookAmount,FCurrentHookQTY,FStdCurrentHookAmount,FPlanMode,FMTONo,FBatchNo,'+
		  'FPrice,Fauxprice,FTaxPrice,FAuxTaxPrice,FPriceDiscount,FAuxPriceDiscount,FRemainQty,FRemainAmountFor,FRemainAmount,
		  Famount,FStdAmount,FTaxAmount,FStdTaxAmount,FAllAmount,FAmtDiscount,FStdAmtDiscount,FAmountincludetax,FStdAmountincludetax) '+
		  
		  	'select '+cast(@pp as varchar(10))+',FEntryID,FBrNo,FMapNumber,FMapName,
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_ICItem where FNumber=(select FNumber from t_ICItem where FItemID=t.FItemID)),0),
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_measureunit where FNumber=(select FNumber from t_measureunit where FMeasureUnitID=t.FUnitID)),0),
			FAuxPropID,FQty,Fauxqty,FSecCoefficient,FSecQty,FDiscountRate,
			FTaxRate, FOrgBillEntryID,FOrderPrice,FAuxOrderPrice,1,FEntryID_SRC,
			1,FSourceEntryID,isnull(t2.FSynchroID,0),FOrderEntryID,0,
			isnull((select top 1 FBillNo  from ' + @DBName +'.dbo.ICStockBill where FInterID=t2.FSynchroID),''''),FOrderBillNo,
			FContractBillNo,FContractInterID,FContractEntryID,
			FAllHookQTY,FStdAllHookAmount,FCurrentHookQTY,FStdCurrentHookAmount,FPlanMode,FMTONo,FBatchNo, 
			FPrice,Fauxprice,FTaxPrice,FAuxTaxPrice,FPriceDiscount,FAuxPriceDiscount,FQty,FAmountincludetax,FStdAmountincludetax,
			Famount,FStdAmount,FTaxAmount,FStdTaxAmount,FAllAmount,FAmtDiscount,FStdAmtDiscount,FAmountincludetax,FStdAmountincludetax
			 from ICPurchaseEntry t 
			 left join (select FSynchroID,FInterID from ICStockBill) t2 on t2.FInterID=t.FSourceInterId
			 --left join (select FInterID,FEntryID from ' + @DBName + '.dbo.ICStockBillEntry) t3 on t3.FInterID=t2.FSynchroID
			where t.FinterID='+ @FinterID 
		exec(@Sql)	
			
	  
--***********************************************************			
		--	插入t_rp_plan_ap，t_RP_Contact (Edit:2013-04-01)采购发票
		
				-- 1.  t_rp_plan_ap 
			set @sql =' insert into ' + @DBName + '.dbo.t_rp_plan_ap(FOrgID,FDate,FAmount,FAmountFor, FRemainAmount,FRemainAmountFor,FRP,FinterID) 
					select FOrgID,FDate,FAmount,FAmountFor, FRemainAmount,FRemainAmountFor,FRP,' + cast(@pp as varchar(10)) + '
					from t_rp_plan_ap t	where t.FInterID=' + @FInterID 
			exec(@sql) 

				----2.t_RP_Contact
			set @sql =' INSERT INTO ' + @DBName + '.dbo.t_RP_Contact (FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,FExchangeRate,FCustomer,FDepartment,FEmployee,FCurrencyID,
			FStatus,FToBal,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FK3Import,FInterestRate,FBillType,finvoicetype,FItemClassID,FExplanation,FPreparer) 
			select FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,FExchangeRate,
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_Item where FItemClassID=t.FItemClassID and FNumber = (select top 1 FNumber from t_Item where FItemID= t.FCustomer)),0),     
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_Department where FNumber =(select top 1 FNumber from t_department where FItemID= t.FDepartment)),0),
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_emp where FNumber =(select top 1 FNumber from t_emp where FItemID= t.FEmployee)),0),
			isnull((select top 1 FCurrencyID from ' + @DBName + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),1),
			FStatus,FToBal,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,' + cast(@pp as varchar(10)) + ',FRPDate,FK3Import,FInterestRate,FBillType,finvoicetype,FItemClassID,FExplanation,16394
			from t_RP_Contact t where FType=4 and t.FInvoiceID='+ @FInterID
			exec(@sql) 

				----3. FOrgID
			set @sql='update t set FOrgID=t2.FID
			from ' + @DBName + '.dbo.t_rp_plan_ap t	inner join ' + @DBName + '.dbo.t_rp_contact t2 on t.FInterID=t2.FInvoiceID
			where  t.FInterID =' + cast(@pp as varchar(10))
			exec(@sql)

	--********************************************		  

	end


	---- 反审核
	if (len(@DBName) > 0) and UPDATE(FCheckerID) and @FCheckerID =0 
	begin
		update  ICPurchase set FSynchroID=null where FInterID=@FInterID 
		
		set @Sql ='update ' + @DBName + '.dbo.ICPurchase set FCheckerID=Null,FStatus=0,FCheckDate=Null  where FInterID=' + @FSynchroID
		exec(@sql) 
		
		set @Sql ='delete from ' + @DBName + '.dbo.t_rp_plan_ap where FInterID=' + @FSynchroID
		exec(@Sql)
		set @Sql ='delete from ' + @DBName + '.dbo.t_rp_contact where FType=4 and FInvoiceID=' + @FSynchroID
		exec(@Sql)		  
		set @Sql ='delete from ' + @DBName + '.dbo.ICPurchase where FInterID=' + @FSynchroID
		exec(@Sql) 
		  
	end



	IF (@@error <> 0)  
		ROLLBACK TRANSACTION  
		
	ELSE  
		COMMIT TRANSACTION 

END