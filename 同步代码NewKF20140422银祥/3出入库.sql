ALTER  TRIGGER [dbo].[ICStockBill_Update]
            ON [dbo].[ICStockBill]
FOR Update
AS 
declare @DBName varchar(50)
declare @FCheckerID bigint
declare @FInterID varchar(50)

declare @Sql varchar(4000)
declare @pp int
declare @FBillNo varchar(50)
declare @nSql nvarchar(4000)

declare @FTranType int
declare @FSynchroID varchar(50)

declare @msg varchar(50)
declare @FLastChecker bigint 
DECLARE @LastCheckLevel INTEGER
BEGIN  
	BEGIN TRANSACTION  
	SET NOCOUNT ON
--	1	同步外购入库单1
--2	同步采购发票
--3	同步付款单
--4	同步销售出库单21
--5	同步销售发票
--6	同步收款单
--7	同步生产领料单24
--8	同步产品入库单2
--9	同步其他入库单9
--10	同步其他出库单29
--11	同步记账凭证


--1	外购入库
--2	产成品入库
--3	自制入库
--5	委外加工入库
--10	其他入库
--21	销售产品
--24	生产领料
--28	委外加工发出
--29	其他出库
--40	盘盈入库
--41	仓库调拨
--43	盘亏毁损
--65	计划价调价
--70	采购申请
--71	采购订单
--72	采购收货
--73	采购退货
--75	购货发票
--76	购货发票(普通)
--80	销售发票
--81	销售订单
--82	销售退货
--83	销售发货
--84	销售报价单
--85	生产任务单
--86	销售发票(普通)
--90	凭证
--100	金额调整
--101	外购入库暂估补差
--102	委外加工费补差单
--137	受托加工领料          select * from ictemplate WHERE fid='a01'
--一审:	FMultiCheckLevel1
--二审:	FMultiCheckLevel2
--三审:	FMultiCheckLevel3
--四审:	FMultiCheckLevel4
--五审:	FMultiCheckLevel5
--六审:	FMultiCheckLevel6
	--select * from ictranstype  Select top 1 * From t_MultiLevelCheck Where FBillType = 1 order by fchecklevel desc


	select @DBName=FDBName from t_BOS_Synchro where FK3Name='帐套同步'
	select @FInterID = FInterID,@FCheckerID=isnull(FCheckerID,0),@FTranType=FTranType,@FSynchroID=FSynchroID from inserted  where FTranType in (1,21,10,29,2,24)
    
    Select TOP 1 @LastCheckLevel=ISNULL(FCheckLevel,0) From t_MultiLevelCheck Where FBillType = @FTranType order by fchecklevel DESC
    IF @LastCheckLevel=2 
    	select @FCheckerID=isnull(FMultiCheckLevel2,0) from inserted  where FTranType in (1,21,10,29,2,24)
        IF @LastCheckLevel=3 
    	select @FCheckerID=isnull(FMultiCheckLevel3,0) from inserted  where FTranType in (1,21,10,29,2,24)
    	    IF @LastCheckLevel=4 
    	select @FCheckerID=isnull(FMultiCheckLevel4,0) from inserted  where FTranType in (1,21,10,29,2,24)
    	    IF @LastCheckLevel=5 
    	select @FCheckerID=isnull(FMultiCheckLevel5,0) from inserted  where FTranType in (1,21,10,29,2,24)
    	    IF @LastCheckLevel=6 
    	select @FCheckerID=isnull(FMultiCheckLevel6,0) from inserted  where FTranType in (1,21,10,29,2,24)
    
    
    if @FTranType=1
    SELECT TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=1 AND FChecker=@FCheckerID
    
       if @FTranType=21
    select TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=4 AND FChecker=@FCheckerID
   
            if @FTranType=10
    select TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=9 AND FChecker=@FCheckerID
     
           if @FTranType=24
    select TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=7 AND FChecker=@FCheckerID
               if @FTranType=2
    select TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=8 AND FChecker=@FCheckerID
                  if @FTranType=29
    select TOP 1 @FLastChecker=isnull(FChecker,0)  from t_YXSetEntry where FTableName=10 AND FChecker=@FCheckerID

if @FLastChecker=@FCheckerID
begin
    
	if (len(@DBName) > 0) AND UPDATE(FCurCheckLevel) and @FCheckerID >0  --and UPDATE(FCheckerID)
	begin
		
		
	
	
		--------物料、单位、仓库---------------
			set @msg=''
			set @nSQL=' select @p2=t2.FNumber from  ICStockBillEntry t inner join t_ICItem t2 on t.FItemID=t2.FItemID  left join '+ @DBName+'.dbo.t_ICItem t21 on t21.FNumber=t2.FNumber 
					where t21.FItemID is null and  t.FInterID='+ @FinterID
			exec sp_executesql  @nSQL ,N'@p2   Varchar(50)  output ',@msg   output
			if len(@msg)>0
			begin
				set @msg='<物料：' + @msg + '>,财务帐套不存在该物料,不能审核!'
				RAISERROR(@msg,18,18)
				ROLLBACK TRAN
			end 
			
			set @nSQL=' select @p2=t2.FNumber from  ICStockBillEntry t inner join t_measureunit t2 on t.FUnitID=t2.FMeasureUnitID  left join '+ @DBName+'.dbo.t_measureunit t21 on t21.FNumber=t2.FNumber 
					where t21.FItemID is null and  t.FInterID='+ @FinterID
			exec sp_executesql  @nSQL ,N'@p2   Varchar(50)  output ',@msg   output
			if len(@msg)>0
			begin
				set @msg='<计量单位：' + @msg + '>,财务帐套不存在该计量单位,不能审核!'
				RAISERROR(@msg,18,18)
				ROLLBACK TRAN
			end 
			
			set @nSQL=' select @p2=t2.FNumber from  (select FInterID,FDCStockID from ICStockBillEntry union select FInterID,FSCStockID from ICStockBillEntry  ) t 
					inner join t_Stock t2 on t2.FItemID=t.FDCStockID  left join '+ @DBName+'.dbo.t_Stock t21 on t21.FNumber=t2.FNumber 
					where t21.FItemID is null and  t.FInterID='+ @FinterID
			exec sp_executesql  @nSQL ,N'@p2   Varchar(50)  output ',@msg   output
			if len(@msg)>0
			begin
				set @msg='<仓库：' + @msg + '>,财务帐套不存在该仓库,不能审核!'
				RAISERROR(@msg,18,18)
				ROLLBACK TRAN
			end 
		------------------------
		

		set @pp=0
		set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''ICStockBill'',@p2 output,1,16394'
		exec sp_executesql  @nSql ,N'@p2   int   output ',@pp   output
		
		--set @nSql=' exec '+ @DBName+'.dbo.p_BM_GetBillNo 1,@p2 output' 
		--exec sp_executesql  @nSql ,N'@p2   varchar(50)   output ',@FBillNo   output
	   if @FTranType=1   or @FTranType=10 or @FTranType=2 
	   begin
			set @Sql = 'insert into ' + @DBName + '.dbo.ICStockBill(FBrNo,FInterID,FTranType,FDate,FBillNo,FRefType,
						FSupplyID,FDeptID,FEmpID,FFManagerID,FSManagerID,FManagerID,FAcctID,
						FBillerID,FROB,FStatus,FSaleStyle,FPOStyle,FSelTranType,FSettleDate,FBrID,FVchInterID,FRelateBrID,
						FPurposeID,FBillTypeID,FExplanation,FCheckerID,FCheckDate,FMultiCheckLevel2,FMultiCheckDate2) '+
				'select FBrNo,'+cast(@pp as varchar(10))+',FTranType,FDate,FBillNo,FRefType,
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_supplier where FNumber=(select FNumber from t_supplier where FItemID=t.FSupplyID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_department where FNumber=(select FNumber from t_department where FItemID=t.FDeptID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FEmpID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FFManagerID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FSManagerID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FManagerID)),0),
				isnull((select top 1 FAccountID from ' + @DBName + '.dbo. t_Account where fNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAcctID)),0),
				FBillerID,FROB,FStatus,FSaleStyle,FPOStyle,FSelTranType,FSettleDate,FBrID,0,FRelateBrID,
				FPurposeID,FBillTypeID,FExplanation,FCheckerID,FCheckDate,
				isnull((select top 1 fuserid from ' + @DBName+'.dbo.t_User where FName=(select FName from t_User where fuserid=t.FMultiCheckLevel2)),0), (case when '+CAST(@LastCheckLevel AS VARCHAR)+' =3 then FMultiCheckDate2 else null end) as FMultiCheckDate2  
				from ICStockBill t 
				where t.FinterID='+ @FinterID  
			exec (@Sql)
 
		end																	
		else if @FTranType=21 or @FTranType=29	  or @FTranType=24 		----FBillTypeID,FManagerID,
		begin
			set @Sql = 'insert into ' + @DBName + '.dbo.ICStockBill(FBrNo,FInterID,FTranType,FDate,FBillNo,FRefType,
						FSupplyID,FDeptID,FEmpID,FFManagerID,FSManagerID,FManagerID,FAcctID,
						FBillerID,FROB,FStatus,FSaleStyle,FPOStyle,FSelTranType,FSettleDate,FBrID,FVchInterID,FRelateBrID,
						FPurposeID,FBillTypeID,FExplanation,FCheckerID,FCheckDate,FMultiCheckLevel2,FMultiCheckDate2) '+
				'select FBrNo,'+cast(@pp as varchar(10))+',FTranType,FDate,FBillNo,FRefType,
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_Organization where FNumber=(select FNumber from t_Organization where FItemID=t.FSupplyID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_department where FNumber=(select FNumber from t_department where FItemID=t.FDeptID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FEmpID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FFManagerID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FSManagerID)),0),
				isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FManagerID)),0),
				isnull((select top 1 FAccountID from ' + @DBName + '.dbo. t_Account where fNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAcctID)),0),
				FBillerID,FROB,FStatus,FSaleStyle,FPOStyle,FSelTranType,FSettleDate,FBrID,0,FRelateBrID,
				FPurposeID,FBillTypeID,FExplanation,FCheckerID,FCheckDate,
				isnull((select top 1 fuserid from ' + @DBName+'.dbo.t_User where FName=(select FName from t_User where fuserid=t.FMultiCheckLevel2)),0), (case when '+CAST(@LastCheckLevel AS VARCHAR)+' =3 then FMultiCheckDate2 else null end) as FMultiCheckDate2  
				from ICStockBill t 
				where t.FinterID='+ @FinterID  
			exec (@Sql)
 
		end
		
		update  ICStockBill set FSynchroID=@pp where FInterID=@FInterID
		
		
		set @Sql='insert into ' + @DBName + '..ICStockBillEntry(FBrNo,FInterID,FEntryID,FBatchNo,FNote,
				FItemID,FUnitID,FDCStockID,FSCStockID,FPrice,FAuxPrice,FQty,FAuxQty,FQtyMust,FAuxQtyMust,FAmount,FConsignPrice,FConsignAmount,FKFDate,FKFPeriod,FPeriodDate,
				FReProduceType,FSourceTranType,FSourceEntryID,FSourceBillNo,FSourceInterId,FOrderEntryID, FOrderBillNo, FOrderInterID) '+

			'select FBrNo,'+cast(@pp as varchar(10))+',FEntryID,FBatchNo,FNote,
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_ICItem where FNumber=(select FNumber from t_ICItem where FItemID=t.FItemID)),0),
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_measureunit where FNumber=(select FNumber from t_measureunit where FMeasureUnitID=t.FUnitID)),0),
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_Stock where FNumber=(select FNumber from t_Stock where FItemID=t.FDCStockID)),0),
			isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_Stock where FNumber=(select FNumber from t_Stock where FItemID=t.FSCStockID)),0),
			FPrice,FAuxPrice,FQty,FAuxQty,FQtyMust,FAuxQtyMust,FAmount,FConsignPrice,FConsignAmount,FKFDate,FKFPeriod,FPeriodDate,
			FReProduceType,0,0,'''',0,0, '''', 0
			from ICStockBillEntry t 
			where t.FInterID=' + @FinterID
		  
		exec (@Sql)

		-----------库存更新----------------------
		if @FTranType=1  or @FTranType=10 or @FTranType=2  		-- 外购入库、其他入库、产品入库
		begin
			set @Sql='update t1 set t1.FQty=t1.FQty+(u1.FQty),t1.FSecQty=t1.FSecQty+(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@pp as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  '
			exec(@sql)

				
			set @Sql='insert into ' + @DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,u1.FQty,u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@pp as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null'
			exec(@sql)
		end 
		else if @FTranType=21 or @FTranType=29	   --销售出库、其他出库
		begin
			set @Sql='update t1 set t1.FQty=t1.FQty-(u1.FQty),t1.FSecQty=t1.FSecQty-(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@pp as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  '
			exec(@sql)
			set @Sql='insert into ' + @DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,-1*u1.FQty,-1*u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@pp as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null'
			exec(@sql)
		end 
		else if @FTranType=24		--生产领料
		begin
			set @Sql='update t1 set t1.FQty=t1.FQty-(u1.FQty),t1.FSecQty=t1.FSecQty-(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@pp as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  '
			exec(@sql)
			set @Sql='insert into ' + @DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,-1*u1.FQty,-1*u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@pp as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null'
			exec(@sql)
		end 
		
		
		-----------------------------------------
	end

end

	if (len(@DBName) > 0) AND UPDATE(FCurCheckLevel) and @FCheckerID =0  --and UPDATE(FCheckerID)
	begin
	
	  IF EXISTS(select 1 from AIS_YXYZ_2.dbo.ICStockBill where isnull(FCheckerID,0)>0 and FInterID= @FSynchroID)

  begin
		
		          RAISERROR('请选反审目标帐套单据',18,18)
          ROLLBACK TRAN
      end
      
		
		-----------库存更新----------------------
		if @FTranType=1   or @FTranType=10 or @FTranType=2 --外购入库、其他入库、产品入库
		begin
		

		
			set @Sql='update t1 set t1.FQty=t1.FQty-(u1.FQty),t1.FSecQty=t1.FSecQty-(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@FSynchroID as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  '
			exec(@sql)

			set @Sql='insert into ' + @DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,-1 * u1.FQty,-1 * u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@FSynchroID as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null'
			exec(@sql)
		end 
		else if @FTranType=21 or @FTranType=29
		begin
			set @Sql='update t1 set t1.FQty=t1.FQty+(u1.FQty),t1.FSecQty=t1.FSecQty+(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@FSynchroID as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  '
			exec(@sql)

			set @Sql='insert into ' + @DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,u1.FQty,u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@FSynchroID as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null'
			exec(@sql)
		end
		else if @FTranType=24
		begin
			set @Sql='update t1 set t1.FQty=t1.FQty+(u1.FQty),t1.FSecQty=t1.FSecQty+(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@FSynchroID as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  '
			exec(@sql)

			set @Sql='insert into ' + @DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,u1.FQty,u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from ' + @DBName+'.dbo.ICStockBillEntry where  FInterID ='+cast(@FSynchroID as varchar(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join ' + @DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null'
			exec(@sql)
		end
		
		-----------------------------------------
		update  ICStockBill set FSynchroID=0 where FInterID=@FInterID
	 
		set @Sql ='update ' + @DBName + '.dbo.ICStockBill set FCheckerID=Null,FStatus=0,FCheckDate=Null  where FInterID=' + @FSynchroID
		exec(@sql) 
		
		set @Sql ='delete from ' + @DBName + '.dbo.ICStockBill where isnull(FCheckerID,0)=0 and FInterID=' + @FSynchroID
		exec(@sql) 
		
	end



	IF (@@error <> 0)  
		ROLLBACK TRANSACTION  
		
	ELSE  
		COMMIT TRANSACTION 

end
