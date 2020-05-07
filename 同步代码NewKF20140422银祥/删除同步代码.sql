USE yz2_20140705
--
GO
--其他应收应付
--USE ais_yxyz
--t_RP_ARPBill_Update
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[t_RP_ARPBill_Update]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER t_RP_ARPBill_Update
--tr_ICClassCheckStatus1000022_Update
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tr_ICClassCheckStatus1000022_Update]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER tr_ICClassCheckStatus1000022_Update
--tr_ICClassCheckStatus1000021_Update
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tr_ICClassCheckStatus1000021_Update]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER tr_ICClassCheckStatus1000021_Update

GO
--tr_ICClassCheckStatus1000005_Update
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tr_ICClassCheckStatus1000005_Update]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER tr_ICClassCheckStatus1000005_Update
--tr_ICClassCheckStatus1000016_Update
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tr_ICClassCheckStatus1000016_Update]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER tr_ICClassCheckStatus1000016_Update

GO 
--t_Lm_Voucher_Update--t_Lm_Voucher_Update
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[t_Lm_Voucher_Update]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER t_Lm_Voucher_Update
GO 
--ICSale_Update
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ICSale_Update]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER ICSale_Update

GO
--t_RP_NewReceiveBill_Update
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[t_RP_NewReceiveBill_Update]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER t_RP_NewReceiveBill_Update
GO
--ICStockBill_Update
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ICStockBill_Update]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER ICStockBill_Update
GO
--ICPurchase_Update
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ICPurchase_Update]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER ICPurchase_Update
GO
--yj_t_supplier
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[yj_t_supplier]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER yj_t_supplier
GO
--yj_t_measureunit
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[yj_t_measureunit]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER yj_t_measureunit
GO
--yj_t_UnitGroup
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[yj_t_UnitGroup]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER yj_t_UnitGroup
GO
--yj_t_stock
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[yj_t_stock]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER yj_t_stock
GO
--yj_CBCostObj
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[yj_CBCostObj]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER yj_CBCostObj
--TR_t_ICItem
GO
ALTER TRIGGER [dbo].[TR_t_ICItem] ON [dbo].[t_ICItem]  
        INSTEAD OF INSERT,UPDATE,DELETE  
        AS  
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
 SELECT FItemID,FOrderRector,ISNULL(FPOHghPrcMnyType,1),ISNULL(FPOHighPrice,0),FWWHghPrc,ISNULL(FWWHghPrcMnyType,1),FSOLowPrc,ISNULL(FSOLowPrcMnyType,1),ISNULL(FIsSale,' '),FProfitRate,FSalePrice,ISNULL(FBatchManager,0),ISNULL(FISKFPeriod,0),ISNULL(FKFPeriod,0),FTrack,FPlanPrice,ISNULL(FPriceDecimal,2),FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,ISNULL(FGoodSpec,0),ISNULL(FCostProject,0),FIsSnManage,ISNULL(FStockTime,0),FBookPlan,FBeforeExpire,ISNULL(FTaxRate,17),ISNULL(FAdminAcctID,0),FNote,FIsSpecialTax,ISNULL(FSOHighLimit,100),ISNULL(FSOLowLimit,100),ISNULL(FOIHighLimit,100),ISNULL(FOILowLimit,100),FDaysPer,FLastCheckDate,FCheckCycle,FCheckCycUnit,ISNULL(FStockPrice,0),FABCCls,FBatchQty,ISNULL(FClass,0),FCostDiffRate,ISNULL(FDepartment,0),FSaleTaxAcctID,ISNULL(FCBBmStandardID,0) FROM Inserted
    INSERT INTO t_ICItemPlan ( FItemID,FPlanTrategy,FOrderTrategy,FLeadTime,FFixLeadTime,FTotalTQQ,FQtyMin,FQtyMax,FCUUnitID,FOrderInterVal,FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FDailyConsume,FMRPCon,FPlanner,FPutInteger,FInHighLimit,FInLowLimit,FLowestBomCode,FMRPOrder,FIsCharSourceItem,FCharSourceItemID,FPlanMode,FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability)
 SELECT FItemID,ISNULL(FPlanTrategy,321),ISNULL(FOrderTrategy,331),ISNULL(FLeadTime,0),ISNULL(FFixLeadTime,0),ISNULL(FTotalTQQ,1),ISNULL(FQtyMin,1),ISNULL(FQtyMax,10000),ISNULL(FCUUnitID,0),ISNULL(FOrderInterVal,1),FBatchAppendQty,ISNULL(FOrderPoint,1),ISNULL(FBatFixEconomy,1),ISNULL(FBatChangeEconomy,1),ISNULL(FRequirePoint,1),ISNULL(FPlanPoint,1),ISNULL(FDefaultRoutingID,1),ISNULL(FDefaultWorkTypeID,0),ISNULL(FProductPrincipal,' '),FDailyConsume,ISNULL(FMRPCon,1),FPlanner,ISNULL(FPutInteger,0),ISNULL(FInHighLimit,0),ISNULL(FInLowLimit,0),FLowestBomCode,ISNULL(FMRPOrder,0),FIsCharSourceItem,FCharSourceItemID,FPlanMode,FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability FROM Inserted
    INSERT INTO t_ICItemDesign ( FItemID,FChartNumber,FIsKeyItem,FMaund,FGrossWeight,FNetWeight,FCubicMeasure,FLength,FWidth,FHeight,FSize,FVersion)
 SELECT FItemID,FChartNumber,ISNULL(FIsKeyItem,0),ISNULL(FMaund,0),ISNULL(FGrossWeight,0),ISNULL(FNetWeight,0),ISNULL(FCubicMeasure,0),ISNULL(FLength,0),ISNULL(FWidth,0),ISNULL(FHeight,0),ISNULL(FSize,0),FVersion FROM Inserted
    INSERT INTO t_ICItemStandard ( FItemID,FStandardCost,FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate)
 SELECT FItemID,ISNULL(FStandardCost,0),ISNULL(FStandardManHour,0),ISNULL(FStdPayRate,0),ISNULL(FChgFeeRate,0),ISNULL(FStdFixFeeRate,0),ISNULL(FOutMachFee,0),ISNULL(FPieceRate,0) FROM Inserted
    INSERT INTO t_ICItemQuality ( FItemID,FInspectionLevel,FInspectionProject,FIsListControl,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,FStkChkPrd,FStkChkAlrm,FIdentifier)
 SELECT FItemID,ISNULL(FInspectionLevel,352),ISNULL(FInspectionProject,0),FIsListControl,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,ISNULL(FStkChkPrd,9999),ISNULL(FStkChkAlrm,0),ISNULL(FIdentifier,' ') FROM Inserted
    INSERT INTO T_BASE_ICItemEntrance ( FItemID,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,FFirstUnitRate,FSecondUnitRate,FIsManage,FPackType,FLenDecimal,FCubageDecimal,FWeightDecimal,FImpostTaxRate,FConsumeTaxRate,FManageType)
 SELECT FItemID,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,ISNULL(FFirstUnitRate,0),ISNULL(FSecondUnitRate,0),ISNULL(FIsManage,0),FPackType,ISNULL(FLenDecimal,2),ISNULL(FCubageDecimal,4),ISNULL(FWeightDecimal,2),ISNULL(FImpostTaxRate,0),ISNULL(FConsumeTaxRate,0),FManageType FROM Inserted
    INSERT INTO t_ICItemCustom(FItemID) SELECT FItemID FROM Inserted
        END
        IF (@@ERROR <> 0)  
            ROLLBACK TRANSACTION  
        ELSE  
            COMMIT TRANSACTION  
        END
    


GO 
---trg_t_Emp_InsUptDel
ALTER TRIGGER [dbo].[trg_t_Emp_InsUptDel] ON [dbo].[t_Emp]
        INSTEAD OF INSERT,UPDATE,DELETE
        AS  
        BEGIN
            BEGIN TRANSACTION  
            SET NOCOUNT ON
            DECLARE @ERROR INT
            SET @ERROR=0
            IF EXISTS(SELECT 1 FROM Deleted)  
            BEGIN
                DELETE t_Base_Emp FROM t_Base_Emp INNER JOIN Deleted   ON t_Base_Emp.FItemID=Deleted.FItemID
                SET @ERROR=@ERROR+@@ERROR
                DELETE HR_Base_Emp FROM HR_Base_Emp INNER JOIN (SELECT FItemID FROM Deleted WHERE NOT EXISTS(SELECT FItemID FROM Inserted WHERE  Deleted.FItemID=Inserted.FItemID)) t1 ON HR_Base_Emp.FItemID=t1.FItemID
                SET @ERROR=@ERROR+@@ERROR
                UPDATE HR_Base_User SET FEmpID=NULL WHERE FEmpID NOT IN (SELECT EM_ID FROM HR_Base_Emp)
                SET @ERROR=@ERROR+@@ERROR
            END
            IF EXISTS (SELECT 1 FROM Inserted)
            BEGIN
                 INSERT INTO t_Base_Emp (FItemID,FAddress,FAllotPercent,FBankAccount,FBankID,FBirthday,FBrNO,FCreditAmount,FCreditDays,FCreditLevel,FCreditPeriod,FDegree,FDeleted,FDepartmentID,FDuty,FEmail,FEmpGroup,FEmpGroupID,FGender,FHireDate,FID,FIsCreditMgr,FItemDepID,FJobTypeID,FLeaveDate,FMobilePhone,FName,FNote,FNumber,FOperationGroup,FOtherAPAcctID,FOtherARAcctID,FParentID,FPhone,FPreAPAcctID,FPreARAcctID,FProfessionalGroup,FShortNumber)
                 SELECT FItemID,FAddress,ISNULL(FAllotPercent,0),FBankAccount,ISNULL(FBankID,0),FBirthday,ISNULL(FBrNO,'0'),FCreditAmount,FCreditDays,ISNULL(FCreditLevel,0),ISNULL(FCreditPeriod,0),FDegree,ISNULL(FDeleted,0),FDepartmentID,FDuty,FEmail,FEmpGroup,ISNULL(FEmpGroupID,0),ISNULL(FGender,1068),FHireDate,FID,ISNULL(FIsCreditMgr,0),ISNULL(FItemDepID,0),ISNULL(FJobTypeID,0),FLeaveDate,FMobilePhone,FName,FNote,FNumber,ISNULL(FOperationGroup,0),ISNULL(FOtherAPAcctID,0),ISNULL(FOtherARAcctID,0),FParentID,FPhone,ISNULL(FPreAPAcctID,0),ISNULL(FPreARAcctID,0),ISNULL(FProfessionalGroup,0),FShortNumber FROM Inserted
                 SET @ERROR=@ERROR+@@ERROR
                UPDATE HR_Base_Emp SET Name=Inserted.FName,Sex=CASE Inserted.FGender WHEN 1068 THEN 1 WHEN 1069 THEN 2 ELSE 0 END,Birthday=Inserted.FBirthDay,
                        Mobile=Inserted.FMobilePhone,IDCardID=Inserted.FID,EMail=Inserted.FEMail
                        FROM HR_Base_Emp,Inserted WHERE HR_Base_Emp.FItemID=Inserted.FItemID AND Inserted.FItemID IN (SELECT Inserted.FItemID FROM Deleted,Inserted WHERE Deleted.FItemID=Inserted.FItemID)
                SET @ERROR=@ERROR+@@ERROR
                INSERT INTO HR_Base_Emp(FItemID,Name,Sex,Birthday,Mobile,IDCardID,EMail,EM_ID)
                SELECT FItemID,FName,CASE FGender WHEN 1068 THEN 1 WHEN 1069 THEN 2 ELSE 0 END,FBirthDay,FMobilePhone,FID,FEMail,NEWID() FROM Inserted
                      WHERE FItemID NOT IN (SELECT Inserted.FItemID FROM Deleted,Inserted WHERE Deleted.FItemID=Inserted.FItemID)
                SET @ERROR=@ERROR+@@ERROR
            END
            IF (@ERROR <> 0)
                ROLLBACK TRANSACTION
            ELSE
                COMMIT TRANSACTION
        END

GO
--yj_t_Department
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[yj_t_Department]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER yj_t_Department
GO
--yj_t_Organization
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[yj_t_Organization]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER yj_t_Organization
GO
--yj_t_item
IF EXISTS(SELECT 1 FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[yj_t_item]') AND OBJECTPROPERTY(id, N'IsTrigger') = 1) 
DROP TRIGGER yj_t_item
GO
---存储过程
--Pro_BosBillNo 暂时不删
--if Exists(select name from sysobjects where NAME = 'Pro_BosBillNo' and type='P') 
--    drop procedure Pro_BosBillNo

--删除字段

ALTER TABLE t_Voucher DROP COLUMN FSynchroID
ALTER TABLE t_VoucherBlankout  DROP COLUMN FSynchroID 
ALTER TABLE t_Voucher DROP COLUMN  FSynchroIDNum  
ALTER TABLE t_VoucherBlankout DROP COLUMN  FSynchroIDNum  
ALTER TABLE t_rp_arpbill  DROP COLUMN  FMultiCheckStatus  
ALTER TABLE t_rp_arpbill  DROP COLUMN  FSynchroID 
 ALTER TABLE t_RP_NewReceiveBill DROP COLUMN  FMultiCheckStatus 
 --添加BOM字段
ALTER TABLE ICStockBill DROP COLUMN  FSynchroID 
GO 
ALTER TABLE ICSale DROP COLUMN  FSynchroID 
GO 
ALTER TABLE ICPurchase DROP COLUMN  FSynchroID 
GO 
ALTER TABLE t_RP_NewReceiveBill DROP COLUMN  FSynchroID 
GO
ALTER TABLE ICBOM DROP COLUMN  FSynchroID 
GO 
ALTER TABLE ICStockBill_1 DROP COLUMN  FSynchroID 
GO
ALTER TABLE ICStockBill_2 DROP COLUMN  FSynchroID 
GO
ALTER TABLE ICStockBill_21 DROP COLUMN  FSynchroID 
GO
ALTER TABLE ICStockBill_10 DROP COLUMN  FSynchroID 
GO
ALTER TABLE ICStockBill_24 DROP COLUMN  FSynchroID 
GO
ALTER TABLE ICStockBill_28 DROP COLUMN  FSynchroID 
GO
ALTER TABLE ICStockBill_29 DROP COLUMN  FSynchroID 
GO
ALTER TABLE ICStockBill_41 DROP COLUMN  FSynchroID  
GO
ALTER TABLE ICStockBill_5 DROP COLUMN  FSynchroID  
 
 
 
 
 

 --drop table 
 GO
--table iCClassMCTaskCenter
IF (EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'ICClassMCTaskCenter')AND OBJECTPROPERTY(id, N'IsUserTable') = 1)) 
DROP TABLE iCClassMCTaskCenter

IF (EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'TongBuTemp')AND OBJECTPROPERTY(id, N'IsUserTable') = 1)) 
DROP TABLE TongBuTemp

IF (EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N't_BOS_Synchro')AND OBJECTPROPERTY(id, N'IsUserTable') = 1)) 
DROP TABLE t_BOS_Synchro

--同步数据配置表 
--这个从bos删除




