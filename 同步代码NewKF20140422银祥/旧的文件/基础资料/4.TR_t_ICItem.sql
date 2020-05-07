
 
ALTER TRIGGER [dbo].[TR_t_ICItem] ON [dbo].[t_ICItem]  
        INSTEAD OF INSERT,UPDATE,DELETE  
        AS  
declare @FItemID varchar(10)
declare @FNumber Varchar(100)
declare @DBName varchar(100)
declare @Sql varchar(max)
declare @InsertSQL varchar(4000)
declare @T_ItemSQL varchar(4000)
declare @IsHere varchar(10)
declare @FDetail varchar(10)
declare @FParentID varchar(50)
declare @FItemidTemp varchar(50)
declare @NewFNumber varchar(50)

declare @FErpClsID  varchar(50)
declare @FSource varchar(50)
declare @NewFSource varchar(50)
declare @pp2 int
declare @strSQL nvarchar(1000)
        
        BEGIN  
           BEGIN TRANSACTION  
           SET NOCOUNT ON  
           IF EXISTS(SELECT * FROM Deleted)  
           BEGIN  
            DELETE t_ICItemCore FROM t_ICItemCore INNER JOIN Deleted  
                ON t_ICItemCore.FItemID=Deleted.FItemID  
                DELETE t_ICItemBase FROM t_ICItemBase INNER JOIN Deleted  
                ON t_ICItemBase.FItemID=Deleted.FItemID  
                DELETE t_ICItemMaterial FROM t_ICItemMaterial INNER JOIN Deleted  
                ON t_ICItemMaterial.FItemID=Deleted.FItemID   
                DELETE t_ICItemPlan FROM t_ICItemPlan INNER JOIN Deleted   
                ON t_ICItemPlan.FItemID=Deleted.FItemID  
                DELETE t_ICItemDesign FROM t_ICItemDesign INNER JOIN Deleted   
                ON t_ICItemDesign.FItemID=Deleted.FitemID  
                DELETE t_ICItemStandard FROM t_ICItemStandard INNER JOIN Deleted  
                ON t_ICItemStandard.FItemID=Deleted.FItemID  
                DELETE t_ICItemQuality FROM t_ICItemQuality INNER JOIN Deleted  
                ON t_ICItemQuality.FItemID=Deleted.FItemID  
                DELETE T_BASE_ICItemEntrance FROM T_BASE_ICItemEntrance INNER JOIN Deleted  
                ON T_BASE_ICItemEntrance.FItemID=Deleted.FItemID  
                DELETE t_ICItemCustom FROM t_ICItemCustom INNER JOIN Deleted  
                ON t_ICItemCustom.FItemID=Deleted.FItemID  
                
            END  
            IF EXISTS (SELECT * FROM Inserted)  
            BEGIN
    
     INSERT INTO t_ICItemCore ( FItemID,FModel,FName,FHelpCode,FDeleted,FShortNumber,FNumber,FParentID,FBrNo,FTopID,FRP,FOmortize,FOmortizeScale,FForSale,FStaCost,FOrderPrice,FOrderMethod,FPriceFixingType,FSalePriceFixingType,FPerWastage,FARAcctID,FPlanPriceMethod,FPlanClass)
 SELECT FItemID,FModel,FName,FHelpCode,ISNULL(FDeleted,0),FShortNumber,FNumber,ISNULL(FParentID,0),ISNULL(FBrNo,'0'),ISNULL(FTopID,0),FRP,FOmortize,FOmortizeScale,ISNULL(FForSale,0),FStaCost,FOrderPrice,FOrderMethod,FPriceFixingType,FSalePriceFixingType,ISNULL(FPerWastage,0),FARAcctID,FPlanPriceMethod,FPlanClass FROM Inserted
    INSERT INTO t_ICItemBase ( FItemID,FErpClsID,FUnitID,FUnitGroupID,FDefaultLoc,FSPID,FSource,FQtyDecimal,FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,FSecUnitID,FSecCoefficient,FSecUnitDecimal,FAlias,FOrderUnitID,FSaleUnitID,FStoreUnitID,FProductUnitID,FApproveNo,FAuxClassID,FTypeID,FPreDeadLine,FSerialClassID)
 SELECT FItemID,FErpClsID,ISNULL(FUnitID,0),ISNULL(FUnitGroupID,0),FDefaultLoc,ISNULL(FSPID,0),FSource,ISNULL(FQtyDecimal,2),ISNULL(FLowLimit,0),ISNULL(FHighLimit,0),ISNULL(FSecInv,1),ISNULL(FUseState,341),ISNULL(FIsEquipment,0),FEquipmentNum,ISNULL(FIsSparePart,0),FFullName,ISNULL(FSecUnitID,0),ISNULL(FSecCoefficient,0),ISNULL(FSecUnitDecimal,0),FAlias,ISNULL(FOrderUnitID,0),ISNULL(FSaleUnitID,0),ISNULL(FStoreUnitID,0),ISNULL(FProductUnitID,0),FApproveNo,ISNULL(FAuxClassID,0),FTypeID,FPreDeadLine,ISNULL(FSerialClassID,0) FROM Inserted
    INSERT INTO t_ICItemMaterial ( FItemID,FOrderRector,FPOHghPrcMnyType,FPOHighPrice,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,FProfitRate,FSalePrice,FBatchManager,FISKFPeriod,FKFPeriod,FTrack,FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,FGoodSpec,FCostProject,FIsSnManage,FStockTime,FBookPlan,FBeforeExpire,FTaxRate,FAdminAcctID,FNote,FIsSpecialTax,FSOHighLimit,FSOLowLimit,FOIHighLimit,FOILowLimit,FDaysPer,FLastCheckDate,FCheckCycle,FCheckCycUnit,FStockPrice,FABCCls,FBatchQty,FClass,FCostDiffRate,FDepartment,FSaleTaxAcctID,FCBBmStandardID)
 SELECT FItemID,FOrderRector,isnull(FPOHghPrcMnyType,1),isnull(FPOHighPrice,0),FWWHghPrc,isnull(FWWHghPrcMnyType,1),FSOLowPrc,isnull(FSOLowPrcMnyType,1),isnull(FIsSale,' '),FProfitRate,FSalePrice,isnull(FBatchManager,0),isnull(FISKFPeriod,0),isnull(FKFPeriod,0),FTrack,FPlanPrice,isnull(FPriceDecimal,2),FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,isnull(FGoodSpec,0),isnull(FCostProject,0),FIsSnManage,isnull(FStockTime,0),FBookPlan,FBeforeExpire,isnull(FTaxRate,17),isnull(FAdminAcctID,0),FNote,FIsSpecialTax,isnull(FSOHighLimit,100),isnull(FSOLowLimit,100),isnull(FOIHighLimit,100),isnull(FOILowLimit,100),FDaysPer,FLastCheckDate,FCheckCycle,FCheckCycUnit,isnull(FStockPrice,0),FABCCls,FBatchQty,isnull(FClass,0),FCostDiffRate,isnull(FDepartment,0),FSaleTaxAcctID,isnull(FCBBmStandardID,0) FROM Inserted
    INSERT INTO t_ICItemPlan ( FItemID,FPlanTrategy,FOrderTrategy,FLeadTime,FFixLeadTime,FTotalTQQ,FQtyMin,FQtyMax,FCUUnitID,FOrderInterVal,FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FDailyConsume,FMRPCon,FPlanner,FPutInteger,FInHighLimit,FInLowLimit,FLowestBomCode,FMRPOrder,FIsCharSourceItem,FCharSourceItemID,FPlanMode,FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability)
 SELECT FItemID,isnull(FPlanTrategy,321),isnull(FOrderTrategy,331),isnull(FLeadTime,0),isnull(FFixLeadTime,0),isnull(FTotalTQQ,1),isnull(FQtyMin,1),isnull(FQtyMax,10000),isnull(FCUUnitID,0),isnull(FOrderInterVal,1),FBatchAppendQty,isnull(FOrderPoint,1),isnull(FBatFixEconomy,1),isnull(FBatChangeEconomy,1),isnull(FRequirePoint,1),isnull(FPlanPoint,1),isnull(FDefaultRoutingID,1),isnull(FDefaultWorkTypeID,0),isnull(FProductPrincipal,' '),FDailyConsume,isnull(FMRPCon,1),FPlanner,isnull(FPutInteger,0),isnull(FInHighLimit,0),isnull(FInLowLimit,0),FLowestBomCode,isnull(FMRPOrder,0),FIsCharSourceItem,FCharSourceItemID,isnull(FPlanMode,14036),FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability FROM Inserted
    INSERT INTO t_ICItemDesign ( FItemID,FChartNumber,FIsKeyItem,FMaund,FGrossWeight,FNetWeight,FCubicMeasure,FLength,FWidth,FHeight,FSize,FVersion)
 SELECT FItemID,FChartNumber,isnull(FIsKeyItem,0),isnull(FMaund,0),isnull(FGrossWeight,0),isnull(FNetWeight,0),isnull(FCubicMeasure,0),isnull(FLength,0),isnull(FWidth,0),isnull(FHeight,0),isnull(FSize,0),FVersion FROM Inserted
    INSERT INTO t_ICItemStandard ( FItemID,FStandardCost,FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate)
 SELECT FItemID,isnull(FStandardCost,0),isnull(FStandardManHour,0),isnull(FStdPayRate,0),isnull(FChgFeeRate,0),isnull(FStdFixFeeRate,0),isnull(FOutMachFee,0),isnull(FPieceRate,0) FROM Inserted
    INSERT INTO t_ICItemQuality ( FItemID,FInspectionLevel,FInspectionProject,FIsListControl,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,FStkChkPrd,FStkChkAlrm,FIdentifier)
 SELECT FItemID,isnull(FInspectionLevel,352),isnull(FInspectionProject,0),FIsListControl,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,isnull(FStkChkPrd,9999),isnull(FStkChkAlrm,0),isnull(FIdentifier,' ') FROM Inserted
    INSERT INTO T_BASE_ICItemEntrance ( FItemID,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,FFirstUnitRate,FSecondUnitRate,FIsManage,FPackType,FLenDecimal,FCubageDecimal,FWeightDecimal,FImpostTaxRate,FConsumeTaxRate,FManageType)
 SELECT FItemID,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,isnull(FFirstUnitRate,0),isnull(FSecondUnitRate,0),isnull(FIsManage,0),FPackType,isnull(FLenDecimal,2),isnull(FCubageDecimal,4),isnull(FWeightDecimal,2),isnull(FImpostTaxRate,0),isnull(FConsumeTaxRate,0),FManageType FROM Inserted
   INSERT INTO t_ICItemCustom(FItemID) SELECT FItemID FROM Inserted
        END
        
        
-----删除	
IF EXISTS(SELECT * FROM Deleted)  and (not EXISTS (SELECT * FROM Inserted) )
BEGIN    
	select @DBName=FDBName from t_BOS_Synchro where FK3Name='帐套同步'
	if LEN(@DBName) > 0
	begin
		select @FItemID = FItemID,@FNumber=FNumber from deleted

		set @Sql= 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=4 and  FNumber=''' + @FNumber + ''''
		exec (@sql)
		set @Sql= 'delete from '+@DBName+'.dbo.t_ICItem where FNumber=''' + @FNumber + ''''
		exec (@sql)
	end
END
				
				
----同步添加(开始)    
 IF EXISTS (SELECT * FROM Inserted)                           
BEGIN    

	select @DBName=FDBName from t_BOS_Synchro where FK3Name='帐套同步'
	if LEN(@DBName) > 0
	begin			

	set @InsertSQL='Insert into ' +@DBName+'.dbo.t_ICItem (FHelpCode,FModel,FErpClsID,FTypeID,'+
		'FAuxClassID,FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,FStoreUnitID,FSecUnitID,'+
		'FSource,FDefaultLoc,FOrderRector,FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,FAdminAcctID,'+
		'FSecCoefficient,FSPID,FQtyDecimal,'+
		'FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,FApproveNo,FAlias,'+
		'FPOHighPrice,FPOHghPrcMnyType,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,FProfitRate,FOrderPrice,'+
		'FSalePrice,FIsSpecialTax,FISKFPeriod,FKFPeriod,FStockTime,FBatchManager,FBeforeExpire,FCheckCycUnit,FOIHighLimit,'+
		'FOILowLimit,FSOHighLimit,FSOLowLimit,FInHighLimit,FInLowLimit,FTrack,FPlanPrice,'+
		'FPriceDecimal,FGoodSpec,FTaxRate,FCostProject,FIsSNManage,'+
		'FNote,FPlanTrategy,FPlanMode,'+
		'FOrderTrategy,FFixLeadTime,FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,FBatchAppendQty,FOrderPoint,FBatFixEconomy,'+
		'FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,'+
		'FPutInteger,FDailyConsume,FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,FNetWeight,'+
		'FMaund,FLength,FWidth,FHeight,FSize,FCubicMeasure,FStandardCost,'+
		'FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,'+
		'FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,'+
		'FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,FVersion,FNameEn,FModelEn,FHSNumber,'+
		'FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,'+
		'FWeightDecimal,FIsCharSourceItem,FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability,'+
		'FShortNumber,FNumber,FName,FParentID,FItemID)  ' 

		set @T_ItemSQL='Insert into ' +@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '
		
		if  EXISTS (SELECT * FROM deleted )
		begin
			select @FItemID = FItemID,@FNumber=FNumber from deleted
			select @NewFNumber=FNumber,@FErpClsID=FErpClsID,@FSource=FSource from inserted
		end
		
		if not EXISTS (SELECT * FROM deleted )
		begin
			select @FItemID = FItemID,@FNumber=FNumber,@FErpClsID=FErpClsID,@FSource=FSource from inserted
		end
		
		set @FItemidTemp=0
		set @strSQL=' select @p2=FItemID from ' +@DBName+'.dbo.T_Item where  FItemClassID=4 and Fnumber='+''''+@FNumber+''''
		exec sp_executesql  @strSQL ,N'@p2   int   output ',@FItemidTemp   output
		
		if @FItemidTemp = 0
		begin
			set @strSQL=' exec '+ @DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394'
			exec sp_executesql  @StrSQL ,N'@p2   int   output ',@FItemidTemp   output
		end
		

		-------
		set @Sql= 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=4 and FItemID=' + @FItemidTemp
		exec (@sql)

		set @Sql= 'delete from '+@DBName+'.dbo.T_Icitem where FItemID=' + @FItemidTemp
		exec (@sql)
		
		------	t_Item ----
		set @Sql=@T_ItemSQL + 'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '+
				@DBName+'.dbo.T_Item where  FItemClassID=4 and Fnumber=(select top 1 FNumber from T_Item where  FItemClassID=4 and FItemID=a.FParentID)),0),'+@FItemidTemp+' from T_Item a where FITemID='+@FItemID
		exec (@SQL)	
		
		set @Sql=' update  '+ @DBName+'..t_Item set FName=FName where FItemID=' + cast(@FItemidTemp as varchar(10))
		exec (@sql)


				
		set @Sql =@InsertSQL +  ' select  FHelpCode,FModel,FErpClsID,FTypeID,'+
			'isnull((select top 1 FItemClassID as FAuxClassID from  ' +
			@DBName+'.dbo.t_ItemClass where FNumber=(select top 1 FNumber from t_ItemClass where FItemClassID=a.FAuxClassID)),0),'+
			'isnull((select top 1 FUnitGroupID from  ' +
			@DBName+'.dbo.t_UnitGroup where FName=(select top 1 FName from t_UnitGroup where FUnitGroupID=a.FUnitGroupID)),0),'+
			'isnull((select top 1 FMeasureUnitID as FUnitID from  ' +
			@DBName+'.dbo.t_measureunit where FNumber=(select top 1 FNumber from t_measureunit where FMeasureUnitID=a.FUnitID)),0),'+
			'isnull((select top 1 FMeasureUnitID as FOrderUnitID from  ' +
			@DBName+'.dbo.t_measureunit where FNumber=(select top 1 FNumber from t_measureunit where FMeasureUnitID=a.FOrderUnitID)),0),'+
			'isnull((select top 1 FMeasureUnitID as FSaleUnitID from  ' +
			@DBName+'.dbo.t_measureunit where FNumber=(select top 1 FNumber from t_measureunit where FMeasureUnitID=a.FSaleUnitID)),0),'+
			'isnull((select top 1 FMeasureUnitID as FProductUnitID from  ' +
			@DBName+'.dbo.t_measureunit where FNumber=(select top 1 FNumber from t_measureunit where FMeasureUnitID=a.FProductUnitID)),0),'+
			'isnull((select top 1 FMeasureUnitID as FStoreUnitID from  ' +
			@DBName+'.dbo.t_measureunit where FNumber=(select top 1 FNumber from t_measureunit where FMeasureUnitID=a.FStoreUnitID)),0),'+
			'isnull((select top 1 FMeasureUnitID as FSecUnitID from  ' +
			@DBName+'.dbo.t_measureunit where FNumber=(select top 1 FNumber from t_measureunit where FMeasureUnitID=a.FSecUnitID)),0),'+
			'FSource,FDefaultLoc,'+
			--'isnull((select  FItemID  from  ' +
			--@DBName+'.dbo.t_supplier where FNumber=(select top 1 FNumber from t_supplier where FItemID=a.FSource)),0),'+
			--'isnull((select FItemID from  ' +
			--@DBName+'.dbo.t_stock where FNumber=(select top 1 FNumber from t_stock where FItemID=a.FDefaultLoc)),0),'+
			--'isnull((select FItemID from  ' +
			--@DBName+'.dbo.t_stock where FNumber=(select top 1 FNumber from t_stock where FItemID=a.FDefaultReadyLoc)),0),'+
				
			'isnull((select FItemID from ' +@DBName+'.dbo.t_emp where FNumber=(select top 1 FNumber from t_emp where FItemID=a.FOrderRector)),0),'+
			'isnull((select FAccountID from  ' + @DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=a.FAcctID)),0),'+
			'isnull((select FAccountID from  ' + @DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=a.FSaleAcctID)),0),'+
			'isnull((select FAccountID from  ' + @DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=a.FCostAcctID)),0),'+
			'isnull((select FAccountID from  ' + @DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=a.FAPAcctID)),0),'+
			'isnull((select FAccountID from  ' + @DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=a.FAdminAcctID)),0),'+
			
			'FSecCoefficient,FSPID,FQtyDecimal,'+
			'FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,FApproveNo,FAlias,'+
			'FPOHighPrice,FPOHghPrcMnyType,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,FProfitRate,FOrderPrice,'+
			'FSalePrice,FIsSpecialTax,FISKFPeriod,FKFPeriod,FStockTime,FBatchManager,FBeforeExpire,FCheckCycUnit,FOIHighLimit,'+
			'FOILowLimit,FSOHighLimit,FSOLowLimit,FInHighLimit,FInLowLimit,FTrack,FPlanPrice,'+
			'FPriceDecimal,FGoodSpec,FTaxRate,FCostProject,FIsSNManage,'+
			'FNote,FPlanTrategy,FPlanMode,'+
			'FOrderTrategy,FFixLeadTime,FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,FBatchAppendQty,FOrderPoint,FBatFixEconomy,'+
			'FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,'+
			'FPutInteger,FDailyConsume,FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,FNetWeight,'+
			'FMaund,FLength,FWidth,FHeight,FSize,FCubicMeasure,FStandardCost,'+
			'FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,'+
			'FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,'+
			'FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,FVersion,FNameEn,FModelEn,FHSNumber,'+
			'FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,'+
			'FWeightDecimal,FIsCharSourceItem,FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability,'+
			'FShortNumber,FNumber,FName,isnull((select top 1 FItemID as FParentID from '+
			@DBName+'.dbo.T_Item where  FItemClassID=4 and Fnumber=(select top 1 FNumber from T_Item where FItemClassID=4 and FItemID=a.FParentID)),0),'
			+@FItemidTemp+' from t_ICItem a where FItemID='+@FItemID		
		
		exec (@sql) 
			

	end
END

				
				
				
        
        IF (@@error <> 0)  
            ROLLBACK TRANSACTION  
        ELSE  
            COMMIT TRANSACTION  
        END
    