CREATE TRIGGER [dbo].[ICSale_Update] ON [dbo].[ICSale]
    FOR UPDATE
AS
    DECLARE @DBName VARCHAR(50)
    DECLARE @FInterID VARCHAR(50)
    DECLARE @FCheckerID BIGINT
    DECLARE @sql VARCHAR(4000)
    DECLARE @Frob INTEGER --判断红字出货
    DECLARE @FStatus INT
    DECLARE @pp INT
    DECLARE @FBillNo VARCHAR(50)
    DECLARE @nSql NVARCHAR(4000)
    DECLARE @FSynchroID VARCHAR(50)
    DECLARE @FLastChecker BIGINT 
    BEGIN
--1	同步外购入库单
--2	同步采购发票
--3	同步付款单
--4	同步销售出库单

--6	同步收款单
--7	同步生产领料单
--8	同步产品入库单
--9	同步其他入库单
--10同步其他出库单
--11同步记账凭证
			
        SELECT  @DBName = FDBName
        FROM    t_BOS_Synchro
        WHERE   FK3Name = '帐套同步'
        SELECT  @FInterID = FInterID ,
                @FCheckerID = ISNULL(FCheckerID, 0) ,
                @FSynchroID = ISNULL(FSynchroID, 0) ,
                @FStatus = FStatus
        FROM    inserted  
	
        SELECT  @FLastChecker = ISNULL(FChecker, 0)
        FROM    t_YXSetEntry
        WHERE   FTableName = 5
        
        
     
	   
        IF ( LEN(@DBName) > 0 )
            AND UPDATE(FCheckerID)
            AND @FCheckerID > 0
            AND @FStatus = 1
            AND @FLastChecker = @FCheckerID 
            BEGIN 
		
                SET @nSql = ' exec ' + @DBName
                    + '.dbo.GetICMaxNum ''ICSale'',@p2 output,1,16394'
                EXEC sp_executesql @nSql, N'@p2   int   output ', @pp OUTPUT
 
                SET @sql = ' insert into ' + @DBName
                    + '.dbo.ICSale(FInterID,FBillNo,FBrNo,FTranType,FCancellation,FStatus,FROB,FClassTypeID,   
			FSubSystemID,FYear,FPeriod,FItemClassID,FFincDate,FHookStatus,FDate,FSettleID,FTaxNum,FArApStatus,FAdjustExchangeRate,
			FCustID,FDeptID,FEmpID,FManagerID,FBillerID,FCurrencyID,FCussentAcctID,FAcctID,FCheckerID,
			FCheckDate,FExchangeRate,FCompactNo,FSaleStyle,FPOOrdBillNo,
			FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,
			FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FYearPeriod,FYtdIntRate,  
			FOrgBillInterID,FImport,FHookerID,FSelTranType,FBrID,FSettleDate,FSysStatus,FVchInterID,FJSBillNo)'
                    + ' select ' + CAST(@pp AS VARCHAR(10))
                    + ',FBillNo,FBrNo,FTranType,FCancellation,FStatus,FROB,FClassTypeID,   
			FSubSystemID,FYear,FPeriod,FItemClassID,FFincDate,FHookStatus,FDate,FSettleID,FTaxNum,FArApStatus,FAdjustExchangeRate,
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo. t_organization where fNumber=(select top 1 FNumber from t_organization where fItemID=t.FCustID )),0),
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_department where FNumber = (select top 1 FNumber from t_department where FItemID= t.FDeptID)),0),   
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_emp where FNumber = (select top 1 FNumber from t_emp where FItemID= t.FEmpID)),0),
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_emp where FNumber = (select top 1 FNumber from t_emp where FItemID= t.FEmpID)),0),
			isnull((select top 1 FUserID from ' + @DBName
                    + '.dbo.t_User where FName = (select top 1 FName from  t_User where FUserID= t.FBillerID)),16394),
			isnull((select top 1 FCurrencyID from ' + @DBName
                    + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),0),
			isnull((select top 1 FAccountID from ' + @DBName
                    + '.dbo. t_Account where fNumber=(select top 1 FNumber from t_Account where FAccountID=t.FCussentAcctID)),0),
			isnull((select top 1 FAccountID from ' + @DBName
                    + '.dbo. t_Account where fNumber=(select top 1 FNumber from t_Account where FAccountID=t.FCussentAcctID)),0),
			isnull((select top 1 FUserID from ' + @DBName
                    + '.dbo.t_User where FName = (select top 1 FName from  t_User where FUserID= t.FBillerID)),16394),
			FCheckDate,FExchangeRate,FCompactNo,FSaleStyle,FPOOrdBillNo,
			FMultiCheckLevel1,FMultiCheckDate1,FMultiCheckLevel2,FMultiCheckDate2,FMultiCheckLevel3,FMultiCheckDate3,
			FMultiCheckLevel4,FMultiCheckDate4,FMultiCheckLevel5,FMultiCheckDate5,FMultiCheckLevel6,FMultiCheckDate6,FYearPeriod,FYtdIntRate,
			FOrgBillInterID,FImport,FHookerID,FSelTranType,FBrID,FSettleDate,FSysStatus,FVchInterID,FJSBillNo
			from ICSale t where t.FInterID=' + @FinterID
                EXEC(@sql)
		
                UPDATE  ICSale
                SET     FSynchroID = @pp
                WHERE   FInterid = @FInterID 
		
		--FTaxPrice,FPriceDiscount,FAmountincludetax,FStdAmountincludetax,FRemainQty,FRemainAmount,FRemainAmountFor,
                SET @sql = ' insert into ' + @DBName
                    + '.dbo.ICSaleEntry (FInterID,FEntryID,FBrNo,FMapNumber,FMapName,FItemID,FUnitID,FAuxPropID,FQty,Fauxqty,
			FSecCoefficient,FSecQty,FDiscountRate,FUniDiscount,
			FBatchNo,FTaxRate,FOrgBillEntryID,FOrderPrice,FAuxOrderPrice,FClassID_SRC,FEntryID_SRC,FSourceTranType,FSourceBillNo,
			FSourceInterId,FSourceEntryID,FContractBillNo,FContractInterID,FContractEntryID,FOrderBillNo,
			FOrderInterID,FOrderEntryID,FAllHookQTY,FStdAllHookAmount,FCurrentHookQTY,FStdCurrentHookAmount,FPlanMode,FMTONo,FSEOutInterID,
			FSEOutEntryID,FKFDate,FKFperiod,FPeriodDate,FNote,FSEOutBillNo,
			FPrice,FAuxPrice,FTaxPrice,FAuxTaxPrice,FPriceDiscount,FAuxPriceDiscount,FRemainQty,FRemainAmount,FRemainAmountFor,
			FAmount,FStdAmount,FTaxAmount,FStdTaxAmount,FAllAmount,FAmtDiscount,FStdAmtDiscount,FAmountincludetax,FStdAmountincludetax) '
                    + ' select ' + CAST(@pp AS VARCHAR(10))
                    + ',FEntryID,FBrNo,FMapNumber,FMapName,
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_ICItem where FNumber=(select FNumber from t_ICItem where FItemID=t.FItemID)),0),
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_measureunit where FNumber=(select FNumber from t_measureunit where FMeasureUnitID=t.FUnitID)),0),
			 FAuxPropID,FQty,Fauxqty,FSecCoefficient,FSecQty,FDiscountRate,FUniDiscount,
			FBatchNo,FTaxRate,FOrgBillEntryID,FOrderPrice,FAuxOrderPrice,FClassID_SRC,FEntryID_SRC,FSourceTranType,FSourceBillNo,		
			isnull(t2.FSynchroID,0),FSourceEntryID,FContractBillNo,FContractInterID,FContractEntryID,FOrderBillNo,
			0,FOrderEntryID,FAllHookQTY,FStdAllHookAmount,FCurrentHookQTY,FStdCurrentHookAmount,FPlanMode,FMTONo,FSEOutInterID,
			FSEOutEntryID,FKFDate,FKFperiod,FPeriodDate,FNote,FSEOutBillNo,
			FPrice,FAuxPrice,FTaxPrice,FAuxTaxPrice,FPriceDiscount,FAuxPriceDiscount,FRemainQty,FRemainAmount,FRemainAmountFor,
			FAmount,FStdAmount,FTaxAmount,FStdTaxAmount,FAllAmount,FAmtDiscount,FStdAmtDiscount,FAmountincludetax,FStdAmountincludetax
			from ICSaleEntry t
			 left join (select FSynchroID,FInterID from ICStockBill) t2 on t2.FInterID=t.FSourceInterId
			 where t.FinterID=' + @FinterID 

                EXEC(@sql)

----***********************************************************			
		--	插入t_rp_plan_ar，t_RP_Contact (Edit:2013-04-01)
		
				-- 1.  t_rp_plan_ar 
                SET @sql = ' insert into ' + @DBName
                    + '.dbo.t_rp_plan_ar(FOrgID,FDate,FAmount,FAmountFor, FRemainAmount,FRemainAmountFor,FRP,FinterID) 
					select FOrgID,FDate,FAmount,FAmountFor, FRemainAmount,FRemainAmountFor,FRP,'
                    + CAST(@pp AS VARCHAR(10)) + '
					from t_rp_plan_ar t	where t.FInterID=' + @FInterID 
                EXEC(@sql) 
			
				----2.t_RP_Contact
                SET @sql = ' INSERT INTO ' + @DBName
                    + '.dbo.t_RP_Contact (FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,FExchangeRate,FCustomer,FDepartment,FEmployee,FCurrencyID,
			FStatus,FToBal,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FK3Import,FInterestRate,FBillType,finvoicetype,FItemClassID,FExplanation,FPreparer) 
			select FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,FExchangeRate,
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_Item where FItemClassID=t.FItemClassID and FNumber = (select top 1 FNumber from t_Item where FItemID= t.FCustomer)),0),     
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_Department where FNumber =(select top 1 FNumber from t_department where FItemID= t.FDepartment)),0),
			isnull((select top 1 FItemID from ' + @DBName
                    + '.dbo.t_emp where FNumber =(select top 1 FNumber from t_emp where FItemID= t.FEmployee)),0),
			isnull((select top 1 FCurrencyID from ' + @DBName
                    + '.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),1),
			FStatus,FToBal,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,'
                    + CAST(@pp AS VARCHAR(10))
                    + ',FRPDate,FK3Import,FInterestRate,FBillType,finvoicetype,FItemClassID,FExplanation,16394
			from t_RP_Contact t where FType=3 and t.FInvoiceID=' + @FInterID
                EXEC(@sql) 
			
				--3. FOrgID
                SET @sql = 'update t set FOrgID=t2.FID  
					from ' + @DBName + '.dbo.t_rp_plan_ar t	inner join '
                    + @DBName
                    + '.dbo.t_rp_contact t2 on t.FInterID=t2.FInvoiceID
					where  t.FInterID =' + CAST(@pp AS VARCHAR(10))
                EXEC(@sql)

	

--***********************************************************	

            END	
	
	
	
		---- 反审核
        IF ( LEN(@DBName) > 0 )
            AND UPDATE(FCheckerID)
            AND @FCheckerID = 0 
            BEGIN
                UPDATE  ICSale
                SET     FSynchroID = NULL
                WHERE   FInterID = @FInterID 
		
                SET @Sql = 'update ' + @DBName
                    + '.dbo.ICSale set FCheckerID=Null,FStatus=0,FCheckDate=Null  where FInterID='
                    + @FSynchroID
                EXEC(@sql) 
		
                SET @Sql = 'delete from ' + @DBName
                    + '.dbo.t_rp_plan_ar where FInterID=' + @FSynchroID
                EXEC(@Sql)
                SET @Sql = 'delete from ' + @DBName
                    + '.dbo.t_rp_contact where FType=4 and FInvoiceID='
                    + @FSynchroID
                EXEC(@Sql)		  
                SET @Sql = 'delete from ' + @DBName
                    + '.dbo.ICSale where FInterID=' + @FSynchroID
                EXEC(@Sql) 
		  
            END
				

			
    END			
			