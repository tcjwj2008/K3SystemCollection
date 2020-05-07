ALTER  TRIGGER [dbo].[t_RP_ARPBill_Update]
            ON [dbo].t_RP_ARPBill
FOR Update
AS 
declare @DBName varchar(50)
declare @FCheckerID bigint
declare @FInterID varchar(50)

declare @FClassTypeID varchar(50)			---- 1000021	其他应收单 1000022	其他应付单    
declare @FSynchroID varchar(50)

declare @sql varchar(4000)
declare @pp int
declare @FBillNo varchar(50)
declare @nSql nvarchar(4000)

declare @FLastChecker bigint 
DECLARE @LastCheckLevel INTEGER
DECLARE @FSource VARCHAR(50)
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
	select @FInterID = FBillID,@FClassTypeID=FClassTypeID,@FSynchroID=ISNULL(FSynchroID,0),@FSource=ISNULL(FSource,0) from inserted  where FClassTypeID in (1000021,1000022)
	

		SELECT @LastCheckLevel=ISNULL(FMaxLevel,0)  FROM ICClassMCFlowInfo WHERE FID=@FClassTypeID--1000021
		IF @LastCheckLevel=2 
    		select @FCheckerID=isnull(FCheckMan2,0) from ICClassCheckStatus1000021  where FBIllID =@FInterID
	    	
		IF isnull(@FCheckerID,0)=0  
    		select @FCheckerID=isnull(FCheckMan2,0) from ICClassCheckStatus1000022  where FBIllID =@FInterID
    	
        IF @LastCheckLevel=3 
    	select @FCheckerID=isnull(FCheckMan3,0) from ICClassCheckStatus1000021  where FBIllID =@FInterID
    	    IF isnull(@FCheckerID,0)=0  
    	select @FCheckerID=isnull(FCheckMan3,0) from ICClassCheckStatus1000022  where FBIllID =@FInterID
    	
    	    IF @LastCheckLevel=4 
    	select @FCheckerID=isnull(FCheckMan4,0) from ICClassCheckStatus1000021  where FBIllID =@FInterID
    	    IF isnull(@FCheckerID,0)=0  
    	select @FCheckerID=isnull(FCheckMan4,0) from ICClassCheckStatus1000022  where FBIllID =@FInterID
    	
    	    IF @LastCheckLevel=5 
    	select @FCheckerID=isnull(FCheckMan5,0) from ICClassCheckStatus1000021  where FBIllID =@FInterID
    	    IF isnull(@FCheckerID,0)=0  
    	select @FCheckerID=isnull(FCheckMan5,0) from ICClassCheckStatus1000022  where FBIllID =@FInterID
    	
    	    IF @LastCheckLevel=6 
    	select @FCheckerID=isnull(FCheckMan6,0) from ICClassCheckStatus1000021  where FBIllID =@FInterID
    	    IF isnull(@FCheckerID,0)=0  
    	select @FCheckerID=isnull(FCheckMan6,0) from ICClassCheckStatus1000022  where FBIllID =@FInterID
    	

 
	if @FClassTypeID in (1000021,1000021)
		SELECT TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=6 AND FChecker=@FCheckerID
	if @FClassTypeID in (1000022,1000022)
		SELECT TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=3 AND FChecker=@FCheckerID
 
		if (len(@DBName) > 0)  and update(FMultiCheckStatus) and @FCheckerID > 0  and @FLastChecker=@FCheckerID AND @FSynchroID=0 AND @FSource<=0
	begin 
	
	--生成编号    
	declare @SBillNo nvarchar(50)
        set @SBillNo = ''
        declare @BNoSql nvarchar(300)
                        set @BNoSql =' exec '+ @DBName+'.dbo.Ly_GetICBillNo  1,'+@FClassTypeID+' ,@p2 output'
		exec sp_executesql  @BNoSql ,N'@p2   nvarchar(50)   output ',@SBillNo   output
  --      set @BNoSql =' exec '+ @DBName+'.dbo.Pro_BosBillNo  ''QTYS'',40020,@p2 output'
		--exec sp_executesql  @BNoSql ,N'@p2   nvarchar(50)   output ',@SBillNo   output
			--t_rp_ARBillOfSH:    FCostType,FFeesMode,FBrID,FExpenseID
		set @pp=0
		set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''t_RP_ARPBill'',@p2 output,1,16394'
		exec sp_executesql  @nSql ,N'@p2   int   output ',@pp  output
    
		set @sql = 
			' insert into ' + @DBName + '.dbo.t_RP_ARPBill(FBrID,	FTranStatus	,FBillID,	FRP	,FYear,	FPeriod	,FDate,	FNumber,	FBillType	,FCustomer,	
			FDepartment,	FEmployee,	FAccountID,
	FAccountID2,	FCurrencyID,	FExchangeRate,	FCheckAmount,	FCheckAmountFor,	FRemainAmount,	FRemainAMountFor,	FCheckQty,	FRemainQty,
		FAmount,	FAmountFor,	FOldBill,	FCashDiscount,	FContractID,	FContractNo,	FExplanation,	FDelete,	FVoucherID,	FGroupID,
			FRPDate,	FInterestRate,	FPreparer,	FChecker,	FStatus,	FCheckStatus,	FConnectFlag,	FSource,	FSourceID,	FItemClassID,
				FFincDate,	FCheckDate,	FConfirm,	FAdjustExchangeRate,	FAdjustAmount,	FClassTypeID,	FTaskID,	FResourceID	,FOrderID,
					FBudgetAmountFor,	FOrderAmountFor,		FDC,	FBase) '+
					
			'select FBrID,	FTranStatus	,'+cast(@pp as varchar(10))+',	FRP	,FYear,	FPeriod	,FDate,	'+''''+@SBillNo +''''+ ',	FBillType	,
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_Item where FItemClassID=t.FItemClassID and FNumber = (select top 1 FNumber from t_Item where FItemID= t.FCustomer)),0), 
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_Department where FNumber =(select top 1 FNumber from t_department where FItemID= t.FDepartment)),0),
 isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_emp where FNumber =(select top 1 FNumber from t_emp where FItemID= t.FEmployee)),0),
 isnull((select top 1 FAccountID from ' + @DBName +  '.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAccountID)),0),
	FAccountID2,	
 isnull((select top 1 FCurrencyID from ' + @DBName + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),1),
	FExchangeRate,	FCheckAmount,	FCheckAmountFor,	FRemainAmount,	FRemainAMountFor,	FCheckQty,	FRemainQty,
		FAmount,	FAmountFor,	FOldBill,	FCashDiscount,	FContractID,	FContractNo,	FExplanation,	FDelete,	0,	0,
			FRPDate,	FInterestRate,	
						isnull((select top 1 FUserID from ' + @DBName + '.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FPreparer)),16394),
	
			isnull((select top 1 FUserID from ' + @DBName + '.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FChecker)),16394)
			,	1 as FStatus,	FCheckStatus,	FConnectFlag,	FSource,	FSourceID,	FItemClassID,
				FFincDate,	FCheckDate,	FConfirm,	FAdjustExchangeRate,	FAdjustAmount,	FClassTypeID,	FTaskID,	FResourceID	,FOrderID,
					FBudgetAmountFor,	FOrderAmountFor,		FDC,	FBase from  t_RP_ARPBill t where  t.FBillID='+@FinterID
--					SELECT TOP 1 * FROM  t_rp_arpbill  ISNULL(t.FSource,0)<=0 and
--SELECT * FROM t_fielddescription WHERE FTableID =50040 --从表查新单据字段
 
 
		exec(@sql)--插入付款单主表
	
		update t_RP_ARPBill  set FSynchroID= @pp   where FBillID=@FInterID 
		
		set @sql = ' insert into ' + @DBName + '.dbo.t_rp_arpbillentry(FBillID	,FEntryID,	FContractNo,	FContractEntryID,	FOrderNo,	FOrderEntryID,	FID_SRC	,FBillNo_SRC,	FEntryID_SRC,
	FClassID_SRC,	famountFor,	famount,	FCheckAmount,	FCheckAmountFor,	FCheckQty,	FLinkCheckAmount,	FLinkCheckAmountFor,
		FLinkCheckQty,	FCheckDate,	FRemainQty,	FPayApplyAmountFor,	FPayApplyAmount,	FAmountFor_Commit,	FAmount_Commit,	FRemainAmountFor_SRC,
			FRemainAmount_SRC,	FRemainAmountFor,	FRemainAmount,		FInvoiceAmountFor,	FInvoiceAmount	,FInvLinkCheckAmountFor,
				FInvLinkCheckAmount) '+
				'select '+cast(@pp as varchar(10))+'	,FEntryID,	FContractNo,	FContractEntryID,	FOrderNo,	FOrderEntryID,	FID_SRC	,FBillNo_SRC,	FEntryID_SRC,
	FClassID_SRC,	famountFor,	famount,	FCheckAmount,	FCheckAmountFor,	FCheckQty,	FLinkCheckAmount,	FLinkCheckAmountFor,
		FLinkCheckQty,	FCheckDate,	FRemainQty,	FPayApplyAmountFor,	FPayApplyAmount,	FAmountFor_Commit,	FAmount_Commit,	FRemainAmountFor_SRC,
			FRemainAmount_SRC,	FRemainAmountFor,	FRemainAmount,		FInvoiceAmountFor,	FInvoiceAmount	,FInvLinkCheckAmountFor,
				FInvLinkCheckAmount from  t_rp_arpbillentry a where FBillID='+@FinterID	
					
--										SELECT TOP 1 * FROM  t_rp_arpbillentry
--SELECT * FROM t_fielddescription WHERE FTableID =50042 --从表查新单据字段
		exec(@sql)
	 
		set @sql = 
			' insert into ' + @DBName + '.dbo.t_rp_plan_Ar(	FOrgID,	FDate,	FAmount,	FAmountFor,	FRemainAmount,	FRemainAmountFor,	FType,	FExplanation,	FInterID,	FBillID,
	FEntryID,	FRP,	FIsInit)' +
	
	'select  	FOrgID,	FDate,	FAmount,	FAmountFor,	FRemainAmount,	FRemainAmountFor,	FType,	FExplanation,	FInterID,	 '+cast(@pp as varchar(10))+',
	FEntryID,	FRP,	FIsInit from t_rp_plan_Ar where FbillID='+@FinterID	
--										SELECT TOP 1 * FROM  t_rp_plan_Ar
--SELECT * FROM t_fielddescription WHERE FTableID =50038 --从表查新单据字段
	
		exec(@sql)	
		
		set @sql='INSERT INTO ' + @DBName + '.dbo.t_RP_Contact (FRPBillID,FBillID,FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,FCustomer,FDepartment,FEmployee,FCurrencyID,
			FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FPre,FK3Import,FInterestRate,FCheckType,
			FStatus,FToBal,FBillType,FInvoiceType,FItemClassID,FExplanation,FPreparer)
			select '+cast(@pp as varchar(10))+',FBillID,FYear,FPeriod,FRP,FType,FDate,FFincDate,'+''''+@SBillNo +''''+ ',
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_Item where FItemClassID=t.FItemClassID and FNumber = (select top 1 FNumber from t_Item where FItemID= t.FCustomer)),0),     
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_Department where FNumber =(select top 1 FNumber from t_department where FItemID= t.FDepartment)),0),
			isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_emp where FNumber =(select top 1 FNumber from t_emp where FItemID= t.FEmployee)),0),
			isnull((select top 1 FCurrencyID from ' + @DBName + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),1),
			FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FPre,FK3Import,FInterestRate,FCheckType,
			1 AS FStatus,FToBal,FBillType,FInvoiceType,FItemClassID,FExplanation,
			isnull((select top 1 FUserID from ' + @DBName + '.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FPreparer)),16394) 
			from t_RP_Contact t where FBillType in (995,992) and FRPBillID='+@FinterID
		exec(@sql)	
					--FType=(case ' + @FClassTypeID + ' when 1000005 then 5 when 1000016 then 6 end) and
	end			----- 审核 END ----
	
	
	if (len(@DBName) > 0) and update(FMultiCheckStatus) and @FCheckerID <= 0 
	begin
			----删除 select * from t_rp_arpbill
					  IF EXISTS(select 1 from AIS_YXYZ_2.dbo.t_rp_arpbill where isnull(FChecker,0)>0 and FBillID= @FSynchroID)

  begin
		
		          RAISERROR('请选反审目标帐套单据',18,18)
          ROLLBACK TRAN
      END
	 update t_RP_ARPBill  set FSynchroID= null   where FBillID=@FInterID 
		  set @sql ='delete from ' + @DBName + '.dbo.t_RP_Contact WHERE isnull(FRPBillID,0)>0 and  FRPBillID=' + @FSynchroID
		  exec(@sql)
		  
		  set @sql ='delete from ' + @DBName + '.dbo.t_rp_plan_Ar WHERE isnull(fbillid,0)>0 and  FBillID=' + @FSynchroID
		  exec(@sql)
		  
		  set @sql ='delete from ' + @DBName + '.dbo.t_rp_arpbillentry WHERE isnull(fbillid,0)>0 and  FBillID=' + @FSynchroID
		  exec(@sql) 
		  
		  set @sql ='delete from ' + @DBName + '.dbo.t_rp_arpbill WHERE isnull(fbillid,0)>0 and  FBillID=' + @FSynchroID
		  exec(@sql)
		  
		  	  set @sql ='update  t_rp_arpbill set  FSynchroID=0 where isnull(fbillid,0)>0 and FBIllID='+ @FinterID
		  exec(@sql)

	end
	
	
	
	IF (@@error <> 0)  
		ROLLBACK TRANSACTION  
		
	ELSE  
		COMMIT TRANSACTION 
		
end

 
 