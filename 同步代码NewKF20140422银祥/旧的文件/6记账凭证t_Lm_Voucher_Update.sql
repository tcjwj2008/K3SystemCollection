
ALTER TRIGGER [dbo].[t_Lm_Voucher_Update]
            ON [dbo].[t_Voucher]
FOR Update
AS 
--select ftablename,* from t_TableDescription where ftablename='t_Voucher'
--SELECT * FROM t_fielddescription WHERE FTableID =2

--select ftablename,* from t_TableDescription where ftablename='t_VoucherEntry'
--SELECT * FROM t_fielddescription WHERE FTableID =10068
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

DECLARE @FYear INT
DECLARE @FNumber INT
DECLARE @FPeriod INT

declare @FLastChecker bigint 
declare @FTranType bigint 
begin
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
--11	同步记账凭证  FPosterID 记账人   FPosted 是否过账     	0-未过账,1-已过账                                
			
	select @DBName=FDBName from t_BOS_Synchro where FK3Name='帐套同步'
	select @FInterID=FVoucherID,@FTranType=isnull(FTranType,0),@FCheckerID= ISNULL(FPosterID,0),@FSynchroID=isnull(FSynchroID,0),@FStatus=isnull(FPosted,0) from inserted  
	SELECT  @FYear=FYear,@FNumber=FNumber,@FPeriod=FPeriod FROM inserted
	
	   SELECT TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=11 AND FChecker=@FCheckerID
	   

	if (len(@DBName) > 0) and UPDATE(FPosterID) and @FCheckerID >0  and @FStatus=1 and  @FLastChecker=@FCheckerID --and @FTranType=2
	begin 
		
		set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''t_Voucher'',@p2 output,1,16394'
		exec sp_executesql  @nSql ,N'@p2   int   output ',@pp   output
 
 		SET @sql='update  t_Voucher  set FSynchroID='+CAST(@pp AS VARCHAR)+' where FVoucherID='+@FInterID +
+ ' and FNumber not in (select FNumber from ' + @DBName + '.dbo.t_Voucher where FYear='+CAST(@fyear AS VARCHAR) + ' and FPeriod='+ CAST(@FPeriod AS VARCHAR)+
' and FNumber='+   CAST(@FNumber AS VARCHAR) +')'
		EXEC(@sql)
 
		
				set @sql = 
		'insert into ' + @DBName + '.dbo.t_VoucherEntry(
FVoucherID,FAccountID,FAccountID2,FAmount,FAmountFor,FBrNo
,FCashFlowItem,FCurrencyID,FDC,FDetailID,FEntryID,FExchangeRate,FExplanation
,FInternalInd,FMeasureUnitID,FQuantity,FResourceID,FSettleNo,FSettleTypeID,FTaskID,FTransNo,FUnitPrice)    
select '+cast(@pp as varchar(10))+'
,isnull((select top 1 FAccountID from ' + @DBName + '.dbo.t_Account where fNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAccountID)),0)
,isnull((select top 1 FAccountID from ' + @DBName + '.dbo.t_Account where fNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAccountID2)),0)                                                                     
,FAmount,FAmountFor
,isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_organization where fNumber=(select top 1 FNumber from t_organization where fItemID=t.FBrNo )),0)      
,FCashFlowItem,FCurrencyID,FDC       
,isnull((select top 1 FPRopID from ' + @DBName + '.dbo.t_ItemPropDesc where fName=(select top 1 fName from t_ItemPropDesc where FPRopID=t.FDetailID )),0)       
,FEntryID,FExchangeRate,t.FExplanation                                                                    
,t.FInternalInd,FMeasureUnitID,FQuantity,FResourceID,FSettleNo,FSettleTypeID,FTaskID,FTransNo,FUnitPrice
 from t_VoucherEntry t , t_Voucher ee where t.FVoucherID=ee.FVoucherID and t.FVoucherID='+ @FinterID  
 
+ ' and ee.FNumber not in (select FNumber from ' + @DBName + '.dbo.t_Voucher where FYear='+CAST(@fyear AS VARCHAR) + ' and FPeriod='+ CAST(@FPeriod AS VARCHAR)+
' and FNumber='+  CAST(@FNumber AS VARCHAR)+')'
			
 
		  exec(@sql)
		  
		
		set @sql = 
		'insert into ' + @DBName + '.dbo.t_Voucher(FVoucherID,FAttachments,FBrNo,FCashierID,FChecked,FCheckerID,FCreditTotal,
FDate,FDebitTotal,FEntryCount,FExplanation,FFootNote,FFrameWorkID,FGroupID,FHandler,FInternalInd,FNumber,
FObjectName,FOwnerGroupID,FParameter,FPeriod,FPosted,FPreparerID,FReference,FSerialNum,FTransDate,FTranType,FApproveID,FYear) 
select   '+cast(@pp as varchar(10))+'
,FAttachments,isnull((select top 1 FItemID from ' + @DBName + '.dbo. t_organization where fNumber=(select top 1 FNumber from t_organization where fItemID=t.FBrNo )),0)      
,-1
,0,-1
,FCreditTotal,FDate,FDebitTotal,FEntryCount,FExplanation,FFootNote,FFrameWorkID,FGroupID
,isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_emp where FNumber = (select top 1 FNumber from t_emp where FItemID= t.FHandler)),0)
,FInternalInd,FNumber
,FObjectName,FOwnerGroupID,FParameter,FPeriod  
,0,isnull((select top 1 FUserID from ' + @DBName + '.dbo.t_User where FName = (select top 1 FName from  t_User where FUserID= t.FPreparerID)),16394)
,FReference,FSerialNum,FTransDate,FTranType,FApproveID,FYear  from t_Voucher t where t.FVoucherID='+@FinterID 

+ ' and FNumber not in (select FNumber from ' + @DBName + '.dbo.t_Voucher where FYear='+CAST(@fyear AS VARCHAR) + ' and FPeriod='+ CAST(@FPeriod AS VARCHAR)+
' and FNumber='+  CAST(@FNumber AS VARCHAR)+')'

                                                   
		exec(@sql)
		


  
  


 
	end	
	
	
 
		---- 反审核 select *   from   test  insert into ljwtest(oo) values(@Sql)
	if (len(@DBName) > 0) and UPDATE(FCheckerID) and @FCheckerID =-1 -- and @FTranType=2 
	begin
		--update  t_Voucher set FSynchroID=null where FVoucherID=@FInterID 
		SET @sql='update  t_Voucher  set FSynchroID=null where FVoucherID='+@FInterID +
+ ' and FNumber  in (select FNumber from ' + @DBName + '.dbo.t_Voucher where FChecked <=0 and FYear='+CAST(@fyear AS VARCHAR) + ' and FPeriod='+ CAST(@FPeriod AS VARCHAR)+
' and FNumber='+   CAST(@FNumber AS VARCHAR) +')'
		EXEC(@sql)  
		 
		--set @Sql ='update ' + @DBName + '.dbo.t_Voucher set FCheckerID=-1,FChecked=0 where FVoucherID=' + @FSynchroID
		--exec(@sql) 
		
		set @Sql ='alter table ' + @DBName + '.dbo.t_Voucher disable trigger t_Voucher_Delete' 
		exec(@Sql)	
		
				set @Sql ='delete from ' + @DBName + '.dbo.t_VoucherEntry where FVoucherID=' + @FSynchroID
				+ ' and FVoucherID in ('+'select FVoucherID from ' + @DBName + '.dbo.t_Voucher where FChecked <=0 and  FVoucherID=' + @FSynchroID+')'
		 
		exec(@Sql)	
		
		set @Sql ='delete from ' + @DBName + '.dbo.t_Voucher where FChecked <=0 and  FVoucherID=' + @FSynchroID
 
		exec(@Sql)
	  
 		set @Sql ='alter table ' + @DBName + '.dbo.t_Voucher enable  trigger t_Voucher_Delete' 
		exec(@Sql)	
		   
	end
				

			
end			
 