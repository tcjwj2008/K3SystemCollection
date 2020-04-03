ALTER  TRIGGER [dbo].[t_RP_ARPBill_Update] ON [dbo].t_RP_ARPBill
    FOR UPDATE
AS
    DECLARE @DBName VARCHAR(50)
    DECLARE @FCheckerID BIGINT
    DECLARE @FInterID VARCHAR(50)

    DECLARE @FClassTypeID VARCHAR(50)			
    ---- 1000021	其他应收单 1000022	其他应付单    
    DECLARE @FSynchroID VARCHAR(50)

    DECLARE @sql VARCHAR(4000)
    DECLARE @pp INT
    DECLARE @FBillNo VARCHAR(50)
    DECLARE @nSql NVARCHAR(4000)

    DECLARE @FLastChecker BIGINT 
    DECLARE @LastCheckLevel INTEGER
    BEGIN 
        BEGIN TRANSACTION  
        SET NOCOUNT ON
		--1	同步外购入库单
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
        SELECT  @DBName = FDBName
        FROM    t_BOS_Synchro
        WHERE   FK3Name = '帐套同步'
        SELECT  @FInterID = FBillID ,
                @FClassTypeID = FClassTypeID ,
                @FSynchroID = ISNULL(FSynchroID, 0)
        FROM    inserted
        WHERE   FClassTypeID IN ( 1000021, 1000022 )
	

        SELECT  @LastCheckLevel = ISNULL(FMaxLevel, 0)
        FROM    ICClassMCFlowInfo
        WHERE   FID = @FClassTypeID--1000021
        IF @LastCheckLevel = 2 
            SELECT  @FCheckerID = ISNULL(FCheckMan2, 0)
            FROM    ICClassCheckStatus1000021
            WHERE   FBIllID = @FInterID
	    	
        IF ISNULL(@FCheckerID, 0) = 0 
            SELECT  @FCheckerID = ISNULL(FCheckMan2, 0)
            FROM    ICClassCheckStatus1000022
            WHERE   FBIllID = @FInterID
    	
        IF @LastCheckLevel = 3 
            SELECT  @FCheckerID = ISNULL(FCheckMan3, 0)
            FROM    ICClassCheckStatus1000021
            WHERE   FBIllID = @FInterID
        IF ISNULL(@FCheckerID, 0) = 0 
            SELECT  @FCheckerID = ISNULL(FCheckMan3, 0)
            FROM    ICClassCheckStatus1000022
            WHERE   FBIllID = @FInterID
    	
        IF @LastCheckLevel = 4 
            SELECT  @FCheckerID = ISNULL(FCheckMan4, 0)
            FROM    ICClassCheckStatus1000021
            WHERE   FBIllID = @FInterID
        IF ISNULL(@FCheckerID, 0) = 0 
            SELECT  @FCheckerID = ISNULL(FCheckMan4, 0)
            FROM    ICClassCheckStatus1000022
            WHERE   FBIllID = @FInterID
    	
        IF @LastCheckLevel = 5 
            SELECT  @FCheckerID = ISNULL(FCheckMan5, 0)
            FROM    ICClassCheckStatus1000021
            WHERE   FBIllID = @FInterID
        IF ISNULL(@FCheckerID, 0) = 0 
            SELECT  @FCheckerID = ISNULL(FCheckMan5, 0)
            FROM    ICClassCheckStatus1000022
            WHERE   FBIllID = @FInterID
    	
        IF @LastCheckLevel = 6 
            SELECT  @FCheckerID = ISNULL(FCheckMan6, 0)
            FROM    ICClassCheckStatus1000021
            WHERE   FBIllID = @FInterID
        IF ISNULL(@FCheckerID, 0) = 0 
            SELECT  @FCheckerID = ISNULL(FCheckMan6, 0)
            FROM    ICClassCheckStatus1000022
            WHERE   FBIllID = @FInterID
    	

 
        IF @FClassTypeID IN ( 1000021, 1000021 ) 
            SELECT TOP 1
                    @FLastChecker = ISNULL(FChecker, 0)
            FROM    t_YXSetEntry
            WHERE   FTableName = 6
                    AND FChecker = @FCheckerID
        IF @FClassTypeID IN ( 1000022, 1000022 ) 
            SELECT TOP 1
                    @FLastChecker = ISNULL(FChecker, 0)
            FROM    t_YXSetEntry
            WHERE   FTableName = 3
                    AND FChecker = @FCheckerID
 
        IF ( LEN(@DBName) > 0 )
            AND UPDATE(FMultiCheckStatus)
            AND @FCheckerID > 0
            AND @FLastChecker = @FCheckerID
            AND @FSynchroID = 0 
            BEGIN 
	
	--生成编号    
                DECLARE @SBillNo NVARCHAR(50)
                SET @SBillNo = ''
                DECLARE @BNoSql NVARCHAR(300)
                SET @BNoSql = ' exec ' + @DBName
                    + '.dbo.Pro_BosBillNo  ''QTYS'',40020,@p2 output'
                EXEC sp_executesql @BNoSql, N'@p2   nvarchar(50)   output ',
                    @SBillNo OUTPUT
			--t_rp_ARBillOfSH:    FCostType,FFeesMode,FBrID,FExpenseID
                SET @pp = 0
                SET @nSql = ' exec ' + @DBName
                    + '.dbo.GetICMaxNum ''t_RP_ARPBill'',@p2 output,1,16394'
                EXEC sp_executesql @nSql, N'@p2   int   output ', @pp OUTPUT
    
                SET @sql = ' insert into ' + @DBName
                    + '.dbo.t_RP_ARPBill(FBrID,	FTranStatus	,FBillID,	FRP	,FYear,	FPeriod	,FDate,	FNumber,	FBillType	,FCustomer,	
			FDepartment,	FEmployee,	FAccountID,
	FAccountID2,	FCurrencyID,	FExchangeRate,	FCheckAmount,	FCheckAmountFor,	FRemainAmount,	FRemainAMountFor,	FCheckQty,	FRemainQty,
		FAmount,	FAmountFor,	FOldBill,	FCashDiscount,	FContractID,	FContractNo,	FExplanation,	FDelete,	FVoucherID,	FGroupID,
			FRPDate,	FInterestRate,	FPreparer,	FChecker,	FStatus,	FCheckStatus,	FConnectFlag,	FSource,	FSourceID,	FItemClassID,
				FFincDate,	FCheckDate,	FConfirm,	FAdjustExchangeRate,	FAdjustAmount,	FClassTypeID,	FTaskID,	FResourceID	,FOrderID,
					FBudgetAmountFor,	FOrderAmountFor,		FDC,	FBase) '
                    + 'select FBrID,	FTranStatus	,'
                    + CAST(@pp AS VARCHAR(10))
                    + ',	FRP	,FYear,	FPeriod	,FDate,	' + '''' + @SBillNo
                    + '''' + ',	FBillType	,
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_Item where FItemClassID=t.FItemClassID and FNumber = (select top 1 FNumber from t_Item where FItemID= t.FCustomer)),0), 
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_Department where FNumber =(select top 1 FNumber from t_department where FItemID= t.FDepartment)),0),
 isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_emp where FNumber =(select top 1 FNumber from t_emp where FItemID= t.FEmployee)),0),
 isnull((select top 1 FAccountID from ' + @DBName
                    + '.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAccountID)),0),
	FAccountID2,	
 isnull((select top 1 FCurrencyID from ' + @DBName
                    + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),1),
	FExchangeRate,	FCheckAmount,	FCheckAmountFor,	FRemainAmount,	FRemainAMountFor,	FCheckQty,	FRemainQty,
		FAmount,	FAmountFor,	FOldBill,	FCashDiscount,	FContractID,	FContractNo,	FExplanation,	FDelete,	FVoucherID,	FGroupID,
			FRPDate,	FInterestRate,	
						isnull((select top 1 FUserID from ' + @DBName
                    + '.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FPreparer)),16394),
	
			isnull((select top 1 FUserID from ' + @DBName
                    + '.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FChecker)),16394)
			,	FStatus,	FCheckStatus,	FConnectFlag,	FSource,	FSourceID,	FItemClassID,
				FFincDate,	FCheckDate,	FConfirm,	FAdjustExchangeRate,	FAdjustAmount,	FClassTypeID,	FTaskID,	FResourceID	,FOrderID,
					FBudgetAmountFor,	FOrderAmountFor,		FDC,	FBase from  t_RP_ARPBill t where t.FBillID='
                    + @FinterID
--					SELECT TOP 1 * FROM  t_rp_arpbill
--SELECT * FROM t_fielddescription WHERE FTableID =50040 --从表查新单据字段
 
 
                EXEC(@sql)--插入付款单主表
	
                UPDATE  t_RP_ARPBill
                SET     FSynchroID = @pp
                WHERE   FBillID = @FInterID 
		
                SET @sql = ' insert into ' + @DBName
                    + '.dbo.t_rp_arpbillentry(FBillID	,FEntryID,	FContractNo,	FContractEntryID,	FOrderNo,	FOrderEntryID,	FID_SRC	,FBillNo_SRC,	FEntryID_SRC,
	FClassID_SRC,	famountFor,	famount,	FCheckAmount,	FCheckAmountFor,	FCheckQty,	FLinkCheckAmount,	FLinkCheckAmountFor,
		FLinkCheckQty,	FCheckDate,	FRemainQty,	FPayApplyAmountFor,	FPayApplyAmount,	FAmountFor_Commit,	FAmount_Commit,	FRemainAmountFor_SRC,
			FRemainAmount_SRC,	FRemainAmountFor,	FRemainAmount,		FInvoiceAmountFor,	FInvoiceAmount	,FInvLinkCheckAmountFor,
				FInvLinkCheckAmount) ' + 'select ' + CAST(@pp AS VARCHAR(10))
                    + '	,FEntryID,	FContractNo,	FContractEntryID,	FOrderNo,	FOrderEntryID,	FID_SRC	,FBillNo_SRC,	FEntryID_SRC,
	FClassID_SRC,	famountFor,	famount,	FCheckAmount,	FCheckAmountFor,	FCheckQty,	FLinkCheckAmount,	FLinkCheckAmountFor,
		FLinkCheckQty,	FCheckDate,	FRemainQty,	FPayApplyAmountFor,	FPayApplyAmount,	FAmountFor_Commit,	FAmount_Commit,	FRemainAmountFor_SRC,
			FRemainAmount_SRC,	FRemainAmountFor,	FRemainAmount,		FInvoiceAmountFor,	FInvoiceAmount	,FInvLinkCheckAmountFor,
				FInvLinkCheckAmount from  t_rp_arpbillentry a where FBillID='
                    + @FinterID	
					
--										SELECT TOP 1 * FROM  t_rp_arpbillentry
--SELECT * FROM t_fielddescription WHERE FTableID =50042 --从表查新单据字段
                EXEC(@sql)
	 
                SET @sql = ' insert into ' + @DBName
                    + '.dbo.t_rp_plan_Ar(	FOrgID,	FDate,	FAmount,	FAmountFor,	FRemainAmount,	FRemainAmountFor,	FType,	FExplanation,	FInterID,	FBillID,
	FEntryID,	FRP,	FIsInit)'
                    + 'select  	FOrgID,	FDate,	FAmount,	FAmountFor,	FRemainAmount,	FRemainAmountFor,	FType,	FExplanation,	FInterID,	 '
                    + CAST(@pp AS VARCHAR(10)) + ',
	FEntryID,	FRP,	FIsInit from t_rp_plan_Ar where FbillID=' + @FinterID	
--										SELECT TOP 1 * FROM  t_rp_plan_Ar
--SELECT * FROM t_fielddescription WHERE FTableID =50038 --从表查新单据字段
	
                EXEC(@sql)	
		
                SET @sql = 'INSERT INTO ' + @DBName
                    + '.dbo.t_RP_Contact (FRPBillID,FBillID,FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,FCustomer,FDepartment,FEmployee,FCurrencyID,
			FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FPre,FK3Import,FInterestRate,FCheckType,
			FStatus,FToBal,FBillType,FInvoiceType,FItemClassID,FExplanation,FPreparer)
			select ' + CAST(@pp AS VARCHAR(10))
                    + ',FBillID,FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_Item where FItemClassID=t.FItemClassID and FNumber = (select top 1 FNumber from t_Item where FItemID= t.FCustomer)),0),     
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_Department where FNumber =(select top 1 FNumber from t_department where FItemID= t.FDepartment)),0),
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_emp where FNumber =(select top 1 FNumber from t_emp where FItemID= t.FEmployee)),0),
			isnull((select top 1 FCurrencyID from ' + @DBName
                    + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),1),
			FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FPre,FK3Import,FInterestRate,FCheckType,
			FStatus,FToBal,FBillType,FInvoiceType,FItemClassID,FExplanation,
			isnull((select top 1 FUserID from ' + @DBName
                    + '.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FPreparer)),16394) 
			from t_RP_Contact t where FBillType in (995,992) and FRPBillID='
                    + @FinterID
                EXEC(@sql)	
					--FType=(case ' + @FClassTypeID + ' when 1000005 then 5 when 1000016 then 6 end) and
            END			----- 审核 END ----
	
	
        IF ( LEN(@DBName) > 0 )
            AND UPDATE(FMultiCheckStatus)
            AND @FCheckerID <= 0 
            BEGIN
			----删除
	 
                SET @sql = 'delete from ' + @DBName
                    + '.dbo.t_RP_Contact where FRPBillID=' + @FSynchroID
                EXEC(@sql)
		  
                SET @sql = 'delete from ' + @DBName
                    + '.dbo.t_rp_plan_Ar where FBillID=' + @FSynchroID
                EXEC(@sql)
		  
                SET @sql = 'delete from ' + @DBName
                    + '.dbo.t_rp_arpbillentry where FBillID=' + @FSynchroID
                EXEC(@sql) 
		  
                SET @sql = 'delete from ' + @DBName
                    + '.dbo.t_rp_arpbill where FBillID=' + @FSynchroID
                EXEC(@sql)
		  
                SET @sql = 'update  t_rp_arpbill set  FSynchroID=0 where FBIllID='
                    + @FinterID
                EXEC(@sql)

            END
	
	
	
        IF ( @@error <> 0 ) 
            ROLLBACK TRANSACTION  
		
        ELSE 
            COMMIT TRANSACTION 
		
    END

 
 