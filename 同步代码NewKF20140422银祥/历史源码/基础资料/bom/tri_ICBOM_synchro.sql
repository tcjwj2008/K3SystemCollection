-- =============================================
-- Author:opco
-- Create date: 
-- Description:	synchro - BOMÉóºËÍ¬²½£¬·´ÉóºËÉ¾³ý
-- =============================================
create TRIGGER [dbo].[tri_ICBOM_synchro] on [dbo].[ICBOM]
for Update
AS 
declare @DBName varchar(100)
declare @Sql varchar(4000)
declare @FCheckerID varchar(10)
declare @FUseStatus int

declare @FInterID varchar(10)
declare @FParentID varchar(50)
declare @FParentName varchar(50)

declare @pp int
declare @FBillNo varchar(50)
declare @nSql nvarchar(4000)
declare @FSynchroID varchar(10)
BEGIN    

	select @FInterID = t.FInterID,@FBillNo= FBOMNumber,@FUseStatus=FUseStatus,@FCheckerID=isnull(FCheckerID,0),@FSynchroID=isnull(FSynchroID,0) from inserted t
	select @DBName=FDBName from t_BOS_Synchro where FK3Name='ÕÊÌ×Í¬²½'
	
	if (LEN(@DBName) > 0) and UPDATE(FCheckerID) and (@FCheckerID>0) 
	begin		
		--select @FInterID=FInterID from inserted
		
		--set @nSql=' exec '+ @DBName+'.dbo.p_BM_GetBillNo 50,@p2 output' 
		--exec sp_executesql  @nSql ,N'@p2   varchar(50)   output ',@FBillNo   output		
		set @pp=0
		set @nSql='select @p2=FInterID from '+ @DBName+'.dbo.ICBOM where FBOMNumber=''' + @FBillNo + ''''
		exec sp_executesql  @nSql ,N'@p2   int   output ',@pp   output
		
		if @pp=0 
		begin 
			set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''ICBOM'',@p2 output,1,16394'
			exec sp_executesql  @nSql ,N'@p2   int   output ',@pp   output
		
			set @Sql='insert into '	+@DBName+'.dbo.ICBOM(FBrNo,FInterID,FBOMNumber,FImpMode,FUseStatus,FVersion,FQty,FYield,FCheckID,'+
				'FCheckDate,FOperatorID,FEnterTime,FStatus,FTranType,FParentID,FItemId,FUnitID,FAUXQTY,FCheckerID,FAudDate,FBeenChecked,FBOMSkip) ' +
				
				'select FBrNo,'+ cast(@pp as varchar(10))+',FBOMNumber,FImpMode,FUseStatus,FVersion,FQty,FYield,16394,'+
				'FCheckDate,16394,FEnterTime,FStatus,FTranType,'+
				' isnull((select top 1 FInterID as FParentID from ' + @DBName+'.dbo.ICBOMGroup where FNumber=(select top 1 FNumber from ICBOMGroup where FInterID=t.FParentID)),0),'+
				' isnull((select top 1 FItemID as FItemID from ' + @DBName+'.dbo.t_ICItem where FNumber=(select top 1 FNumber from t_ICItem where FItemID=t.FItemID)),0),'+
				' isnull((select top 1 FItemID as FUnitID from ' + @DBName+'.dbo.t_MeasureUnit where FNumber=(select top 1 FNumber from t_MeasureUnit where FItemID=t.FUnitID)),0),'+	
				'FAUXQTY,16394,FAudDate,FBeenChecked,FBOMSkip '+
				'from ICBOM  t where FInterID=' + @FInterID
			exec (@sql)

			
			set @Sql='insert into '	+@DBName+'.dbo.ICBOMChild( FBrNo,FEntryID,FInterID,FItemID,FUnitID,FStockID,
				FAuxQty,FQty,FScrap,FOperSN,FOperID,FMachinePos,'+
				'FNote,FMaterielType,FMarshalType,FPercent,FBeginDay,FEndDay,FOffSetDay,FBackFlush,FPositionNo,FHasChar) '+
				'select  FBrNo,FEntryID,'+ cast(@pp as varchar(10))+','+
				' isnull((select top 1 FItemID from ' +	@DBName+'.dbo.t_ICItem where FNumber=(select top 1 FNumber from t_ICItem where FItemID=t.FItemID)),0),'+
				' isnull((select top 1 FItemID from ' +	@DBName+'.dbo.t_MeasureUnit where FNumber=(select top 1 FNumber from t_MeasureUnit where FItemID=t.FUnitID)),0),'+	
				' isnull((select top 1 FItemID from ' + @DBName+'.dbo.t_Stock where FNumber=(select top 1 FNumber from t_Stock where FItemID=t.FStockID)),0),'+	
				'FAuxQty,FQty,FScrap,FOperSN,FOperID,FMachinePos,'	+
				'FNote,FMaterielType,FMarshalType,FPercent,FBeginDay,FEndDay,FOffSetDay,FBackFlush,FPositionNo,FHasChar '+
				'from ICBOMChild t where FInterID=' + @FInterID
			exec (@sql)	
			
			update ICBOM set FSynchroID=@pp where FInterID=@FInterID
		
		end


	end
	
	if (LEN(@DBName) > 0) and UPDATE(FCheckerID) and (@FCheckerID=0) 
	begin		
		set @Sql='delete '+ @DBName+'.dbo.ICBOM  where FInterID=''' + @FSynchroID + ''''
		exec (@sql)
	end
	
END

