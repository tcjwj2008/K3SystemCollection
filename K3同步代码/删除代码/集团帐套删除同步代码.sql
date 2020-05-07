USE AIS_YXJT
go
-------------------------
--1 删除触发器
--------------------------
GO
--1
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[yj_t_item]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
--PRINT '1' ELSE PRINT '0'
DROP TRIGGER yj_t_item
--2
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[trg_t_Emp_InsUptDel]') and OBJECTPROPERTY(id, N'IsTrigger') = 1)
--PRINT '1' ELSE PRINT '0'
DROP TRIGGER trg_t_Emp_InsUptDel
--3
 ------ t_icitem 触发器
 if exists(select * from dbo.sysobjects 
 where id = object_id(N'[dbo].[TR_t_ICItem]') 
 and OBJECTPROPERTY(id, N'IsTrigger') = 1)
--PRINT '1' ELSE PRINT '0'
DROP TRIGGER TR_t_ICItem
--4
--  部门
 go
 -- =============================================
-- Author:
-- Create date: 
-- Description:	部门同步
-- =============================================
 if exists(select * from dbo.sysobjects 
 where id = object_id(N'[dbo].[yj_t_Department]') 
 and OBJECTPROPERTY(id, N'IsTrigger') = 1)
--PRINT '1' ELSE PRINT '0'
DROP TRIGGER yj_t_Department
--5客户
 go 
-- =============================================
-- Author:opco
-- Create date: 2012-09
-- Description:	客户同步
-- =============================================
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[yj_t_Organization]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
-- PRINT '1' ELSE PRINT '0' 
drop trigger yj_t_Organization
go 


GO 
----6成本对象

-- =============================================
-- Author:
-- Last Modify: 2013-03
-- Description:	成本对象
-- =============================================
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[yj_CBCostObj]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
 --PRINT '1' ELSE PRINT '0'  
   drop trigger yj_CBCostObj 
   
go
--7 仓库
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[yj_t_stock]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
--PRINT '1' ELSE PRINT '0'  
drop trigger yj_t_stock  
--8供应商
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[yj_t_supplier') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
--PRINT '1' ELSE PRINT '0'
drop trigger yj_t_supplier
go 
--9
-----9 计量单位(组)同步
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[yj_t_UnitGroup]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
   drop trigger yj_t_UnitGroup

--10 计量单位同步


go
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[yj_t_measureunit]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
   drop trigger yj_t_measureunit
-------------------------------------
--2 删除业务单据触发器
--------------------------------------
go
--1 出入库
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[ICStockBill_Update]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
drop trigger ICStockBill_Update
go 
--2收款单 付款单
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[t_RP_NewReceiveBill_Update]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
--print '1'else print '0'
drop trigger t_RP_NewReceiveBill_Update
go 
--3凭证
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[t_Lm_Voucher_Update]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
   drop trigger t_Lm_Voucher_Update
go

--4 
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_ICClassCheckStatus1000016_Update]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
   drop trigger tr_ICClassCheckStatus1000016_Update
go
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_ICClassCheckStatus1000005_Update]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
   drop trigger tr_ICClassCheckStatus1000005_Update
go
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_ICClassCheckStatus1000021_Update]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
   drop trigger tr_ICClassCheckStatus1000021_Update
go
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[tr_ICClassCheckStatus1000022_Update]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
   drop trigger tr_ICClassCheckStatus1000022_Update

--5其他应收单其他应付单 
if exists(select * from dbo.sysobjects where id = object_id(N'[dbo].[t_RP_ARPBill_Update]') and OBJECTPROPERTY(id, N'IsTrigger') = 1) 
   drop trigger t_RP_ARPBill_Update
go 
-----------------------------------------------
--3 删除字段
----------------------------------------------
ALTER TABLE ICStockBill drop COLUMN  FSynchroID 
go
ALTER TABLE ICStockBill_1 drop  COLUMN  FSynchroID 
go
ALTER TABLE ICStockBill_2 DROP COLUMN  FSynchroID 
go
ALTER TABLE ICStockBill_21 drop  COLUMN  FSynchroID 
go
ALTER TABLE ICStockBill_10 drop COLUMN  FSynchroID 
go
ALTER TABLE ICStockBill_24 DROP COLUMN FSynchroID 
go
ALTER TABLE ICStockBill_28 DROP COLUMN FSynchroID 
go
ALTER TABLE ICStockBill_29 DROP COLUMN FSynchroID 
go
ALTER TABLE ICStockBill_41 DROP COLUMN FSynchroID 
go
ALTER TABLE ICStockBill_5 DROP COLUMN FSynchroID 

ALTER TABLE ICSale DROP COLUMN FSynchroID 
go
ALTER TABLE ICPurchase DROP  COLUMN FSynchroID 
go
ALTER TABLE t_RP_NewReceiveBill DROP COLUMN  FSynchroID 
go
ALTER TABLE ICBOM DROP COLUMN  FSynchroID 
go
GO

alter table t_rp_arpbill drop COLUMN  FMultiCheckStatus 

go 
ALTER TABLE t_rp_arpbill DROP COLUMN  FSynchroID 
--1添加t_Voucher字段

ALTER TABLE t_Voucher drop COLUMN  FSynchroID  

go
alter table t_RP_NewReceiveBill drop COLUMN  FMultiCheckStatus  

go
--添加t_VoucherBlankout字段  

ALTER TABLE t_VoucherBlankout drop COLUMN  FSynchroID  

--添加t_VoucherAdjust字段因为没这个表省了

ALTER TABLE t_VoucherAdjust drop COLUMN  FSynchroID  

go
--添加t_Voucher字段

ALTER TABLE t_Voucher drop COLUMN  FSynchroIDNum  
 ALTER TABLE t_VoucherAdjust DROP COLUMN  FSynchroIDNum     --yxf添加

go
--添加t_VoucherBlankout字段

ALTER TABLE    t_VoucherBlankout drop COLUMN  FSynchroIDNum 

go
-------------------------------------------- 
--4删除表
------------------------------------------------
--1
IF EXISTS  (SELECT  * FROM dbo.SysObjects WHERE ID = object_id(N'[TongBuTemp]') AND OBJECTPROPERTY(ID, 'IsTable') = 1) 
--PRINT '1' ELSE PRINT '0'
drop table TongBuTemp  
--2
go 
IF EXISTS  (SELECT  * FROM dbo.SysObjects WHERE ID = object_id(N'[t_BOS_Synchro]') AND OBJECTPROPERTY(ID, 'IsTable') = 1) 
--PRINT '1' ELSE PRINT '0'
DROP TABLE t_BOS_Synchro
go 

-------------------------------------------- 
--5删除bos 删除审核流程
------------------------------------------------
--主控台删除



-------------------------------------------- 
--6恢复触发器
------------------------------------------------



go 

CREATE TRIGGER trg_t_Emp_InsUptDel ON t_Emp  
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
             INSERT INTO t_Base_Emp (FItemID,FAccountName,FAddress,FAllotPercent,FAllotWeight,FBankAccount,FBankID,FBirthday,FBrNO,FCreditAmount,FCreditDays,FCreditLevel,FCreditPeriod,FDegree,FDeleted,FDepartmentID,FDuty,FEmail,FEmpGroup,FEmpGroupID,
             FGender,FHireDate,FID,FIsCreditMgr,FItemDepID,FJobTypeID,FLeaveDate,FMobilePhone,FName,FNote,FNumber,FOperationGroup,FOtherAPAcctID,FOtherARAcctID,FParentID,FPersonalBank,FPhone,FPreAPAcctID,FPreARAcctID,FProfessionalGroup,FShortNumber)  
             SELECT FItemID,FAccountName,FAddress,ISNULL(FAllotPercent,0),ISNULL(FAllotWeight,0),FBankAccount,ISNULL(FBankID,0),FBirthday,ISNULL(FBrNO,'0'),FCreditAmount,FCreditDays,ISNULL(FCreditLevel,0),ISNULL(FCreditPeriod,0),FDegree,ISNULL(FDeleted,0)
,FDepartmentID,FDuty,FEmail,FEmpGroup,ISNULL(FEmpGroupID,0),ISNULL(FGender,1068),FHireDate,FID,ISNULL(FIsCreditMgr,0),ISNULL(FItemDepID,0),ISNULL(FJobTypeID,0),FLeaveDate,FMobilePhone,FName,FNote,FNumber,ISNULL(FOperationGroup,0),ISNULL(FOtherAPAcctID,0),
ISNULL(FOtherARAcctID,0),FParentID,FPersonalBank,FPhone,ISNULL(FPreAPAcctID,0),ISNULL(FPreARAcctID,0),ISNULL(FProfessionalGroup,0),FShortNumber FROM Inserted  
  INSERT INTO Access_t_emp(FItemID,FParentIDX,FDataAccessDelete,FDataAccessEdit,FDataAccessView)  
  SELECT t1.FItemID,ISNULL(t1.FParentID,0),t3.FDataAccessDelete,t3.FDataAccessEdit,t3.FDataAccessView   
  FROM  Inserted t1 LEFT JOIN Access_t_emp t2 ON t1.FItemiD=t2.FItemID  
  LEFT JOIN Access_t_emp t3  ON t3.FItemID=0  
  WHERE t2.FItemID IS NULL  
             SET @ERROR=@ERROR+@@ERROR  
            UPDATE HR_Base_Emp SET Name=Inserted.FName,Sex=Case Inserted.FGender When 1068 Then 1 When 1069 Then 2 Else 9 End,Birthday=Inserted.FBirthDay,  
                    Mobile=Inserted.FMobilePhone,IDCardID=Inserted.FID,EMail=Inserted.FEMail  
                    FROM HR_Base_Emp,Inserted WHERE HR_Base_Emp.FItemID=Inserted.FItemID AND Inserted.FItemID IN (SELECT Inserted.FItemID FROM Deleted,Inserted WHERE Deleted.FItemID=Inserted.FItemID)  
            SET @ERROR=@ERROR+@@ERROR  
            INSERT INTO HR_Base_Emp(FItemID,Name,Sex,Birthday,Mobile,IDCardID,EMail,EM_ID)  
            SELECT FItemID,FName,Case FGender When 1068 Then 1 When 1069 Then 2 Else 9 End,FBirthDay,FMobilePhone,FID,FEMail,NEWID() FROM Inserted  
                  WHERE FItemID NOT IN (SELECT Inserted.FItemID FROM Deleted,Inserted WHERE Deleted.FItemID=Inserted.FItemID)  
            SET @ERROR=@ERROR+@@ERROR  
        END  
        IF (@ERROR <> 0)  
            ROLLBACK TRANSACTION  
        ELSE  
            COMMIT TRANSACTION  
    END  
    
   GO
   
   CREATE TRIGGER TR_t_ICItem ON t_ICItem      
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
        
        INSERT INTO t_ICItemCore ( FItemID,FModel,FName,FHelpCode,FDeleted,FShortNumber,FNumber,FParentID,FBrNo,FTopID,FRP,FOmortize,FOmortizeScale,FForSale,FStaCost,FOrderPrice,FOrderMethod,FPriceFixingType,FSalePriceFixingType,FPerWastage,FARAcctID,
        FPlanPriceMethod,FPlanClass,FPY,FPinYin)  SELECT FItemID,FModel,FName,FHelpCode,ISNULL(FDeleted,0),FShortNumber,FNumber,ISNULL(FParentID,0),ISNULL(FBrNo,'0'),ISNULL(FTopID,0),FRP,FOmortize,FOmortizeScale,ISNULL(FForSale,0),FStaCost,FOrderPrice,FOrderMethod,
        FPriceFixingType,FSalePriceFixingType,ISNULL(FPerWastage,0),FARAcctID,FPlanPriceMethod,FPlanClass,ISNULL(FPY,' '),ISNULL(FPinYin,' ') FROM Inserted     INSERT INTO t_ICItemBase ( FItemID,FErpClsID,FUnitID,FUnitGroupID,FDefaultLoc,FSPID,FSource,FQtyDecimal,
        FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,FSecUnitID,FSecCoefficient,FSecUnitDecimal,FAlias,FOrderUnitID,FSaleUnitID,FStoreUnitID,FProductUnitID,FApproveNo,FAuxClassID,FTypeID,FPreDeadLine,FSerialClassID,
FDefaultReadyLoc,FSPIDReady)  SELECT FItemID,FErpClsID,ISNULL(FUnitID,0),ISNULL(FUnitGroupID,0),FDefaultLoc,ISNULL(FSPID,0),FSource,ISNULL(FQtyDecimal,2),ISNULL(FLowLimit,0),ISNULL(FHighLimit,0),ISNULL(FSecInv,1),ISNULL(FUseState,341),ISNULL(FIsEquipment,0),
FEquipmentNum,ISNULL(FIsSparePart,0),FFullName,ISNULL(FSecUnitID,0),ISNULL(FSecCoefficient,0),ISNULL(FSecUnitDecimal,0),FAlias,ISNULL(FOrderUnitID,0),ISNULL(FSaleUnitID,0),ISNULL(FStoreUnitID,0),ISNULL(FProductUnitID,0),FApproveNo,ISNULL(FAuxClassID,0),
FTypeID,FPreDeadLine,ISNULL(FSerialClassID,0),ISNULL(FDefaultReadyLoc,0),ISNULL(FSPIDReady,0) FROM Inserted     INSERT INTO t_ICItemMaterial ( FItemID,FOrderRector,FPOHghPrcMnyType,FPOHighPrice,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,
FProfitRate,FSalePrice,FBatchManager,FISKFPeriod,FKFPeriod,FTrack,FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,FGoodSpec,FCostProject,FIsSnManage,FStockTime,FBookPlan,FBeforeExpire,FTaxRate,FAdminAcctID,FNote,FIsSpecialTax,FSOHighLimit,
FSOLowLimit,FOIHighLimit,FOILowLimit,FDaysPer,FLastCheckDate,FCheckCycle,FCheckCycUnit,FStockPrice,FABCCls,FBatchQty,FClass,FCostDiffRate,FDepartment,FSaleTaxAcctID,FCBBmStandardID,FCBRestore,FPickHighLimit,FPickLowLimit,FOnlineShopPName,FOnlineShopPNo)  
SELECT FItemID,FOrderRector,isnull(FPOHghPrcMnyType,1),isnull(FPOHighPrice,0),FWWHghPrc,isnull(FWWHghPrcMnyType,1),FSOLowPrc,isnull(FSOLowPrcMnyType,1),isnull(FIsSale,' '),FProfitRate,FSalePrice,isnull(FBatchManager,0),isnull(FISKFPeriod,0),
isnull(FKFPeriod,0),FTrack,FPlanPrice,isnull(FPriceDecimal,2),FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,isnull(FGoodSpec,0),isnull(FCostProject,0),FIsSnManage,isnull(FStockTime,0),FBookPlan,FBeforeExpire,isnull(FTaxRate,17),isnull(FAdminAcctID,0),FNote,
FIsSpecialTax,isnull(FSOHighLimit,100),isnull(FSOLowLimit,100),isnull(FOIHighLimit,100),isnull(FOILowLimit,100),FDaysPer,FLastCheckDate,FCheckCycle,FCheckCycUnit,isnull(FStockPrice,0),FABCCls,FBatchQty,isnull(FClass,0),FCostDiffRate,isnull(FDepartment,0),FSaleTaxAcctID,
isnull(FCBBmStandardID,0),FCBRestore,FPickHighLimit,FPickLowLimit,FOnlineShopPName,FOnlineShopPNo FROM Inserted     INSERT INTO t_ICItemPlan ( FItemID,FPlanTrategy,FOrderTrategy,FLeadTime,FFixLeadTime,FTotalTQQ,FQtyMin,FQtyMax,FCUUnitID,FOrderInterVal,
FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FDailyConsume,FMRPCon,FPlanner,FPutInteger,FInHighLimit,FInLowLimit,FLowestBomCode,FMRPOrder,FIsCharSourceItem,
FCharSourceItemID,FPlanMode,FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability,FIsBackFlush,FBackFlushStockID,FBackFlushSPID,FBatchSplitDays,FBatchSplit,FIsFixedReOrder)  SELECT FItemID,isnull(FPlanTrategy,321),isnull(FOrderTrategy,331),isnull(FLeadTime,0)
,isnull(FFixLeadTime,0),isnull(FTotalTQQ,1),isnull(FQtyMin,1),isnull(FQtyMax,10000),isnull(FCUUnitID,0),isnull(FOrderInterVal,1),FBatchAppendQty,isnull(FOrderPoint,1),isnull(FBatFixEconomy,1),isnull(FBatChangeEconomy,1),isnull(FRequirePoint,1),
isnull(FPlanPoint,1),isnull(FDefaultRoutingID,1),isnull(FDefaultWorkTypeID,0),isnull(FProductPrincipal,' '),FDailyConsume,isnull(FMRPCon,1),FPlanner,isnull(FPutInteger,0),isnull(FInHighLimit,0),isnull(FInLowLimit,0),FLowestBomCode,isnull(FMRPOrder,0),
FIsCharSourceItem,FCharSourceItemID,isnull(FPlanMode,14036),FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability,isnull(FIsBackFlush,0),FBackFlushStockID,FBackFlushSPID,isnull(FBatchSplitDays,0),isnull(FBatchSplit,0),isnull(FIsFixedReOrder,0) FROM Inserted     
INSERT INTO t_ICItemDesign ( FItemID,FChartNumber,FIsKeyItem,FMaund,FGrossWeight,FNetWeight,FCubicMeasure,FLength,FWidth,FHeight,FSize,FVersion,FStartService,FMakeFile,FIsFix,FTtermOfService,FTtermOfUsefulTime)  SELECT FItemID,FChartNumber,isnull(FIsKeyItem,0)
,isnull(FMaund,0),isnull(FGrossWeight,0),isnull(FNetWeight,0),isnull(FCubicMeasure,0),isnull(FLength,0),isnull(FWidth,0),isnull(FHeight,0),isnull(FSize,0),FVersion,isnull(FStartService,0),isnull(FMakeFile,0),isnull(FIsFix,0),isnull(FTtermOfService,0),
isnull(FTtermOfUsefulTime,0) FROM Inserted     INSERT INTO t_ICItemStandard ( FItemID,FStandardCost,FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,FStdBatchQty,FPOVAcctID,FPIVAcctID,FMCVAcctID,FPCVAcctID,FSLAcctID,FCAVAcctID,
FCBAppendRate,FCBAppendProject,FCostBomID,FCBRouting,FOutMachFeeProject)  SELECT FItemID,isnull(FStandardCost,0),isnull(FStandardManHour,0),isnull(FStdPayRate,0),isnull(FChgFeeRate,0),isnull(FStdFixFeeRate,0),isnull(FOutMachFee,0),isnull(FPieceRate,0),
isnull(FStdBatchQty,1),FPOVAcctID,FPIVAcctID,FMCVAcctID,FPCVAcctID,FSLAcctID,FCAVAcctID,FCBAppendRate,FCBAppendProject,isnull(FCostBomID,0),isnull(FCBRouting,0),FOutMachFeeProject FROM Inserted     INSERT INTO t_ICItemQuality ( FItemID,FInspectionLevel,
FInspectionProject,FIsListControl,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,FStkChkPrd,FStkChkAlrm,FIdentifier,FSampStdCritical,FSampStdStrict,FSampStdSlight)  SELECT FItemID,isnull(FInspectionLevel,352),isnull(FInspectionProject,0),
FIsListControl,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,isnull(FStkChkPrd,9999),isnull(FStkChkAlrm,0),isnull(FIdentifier,' '),FSampStdCritical,FSampStdStrict,FSampStdSlight FROM Inserted     
INSERT INTO T_BASE_ICItemEntrance ( FItemID,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,FFirstUnitRate,FSecondUnitRate,FIsManage,FPackType,FLenDecimal,FCubageDecimal,FWeightDecimal,FImpostTaxRate,FConsumeTaxRate,FManageType,FExportRate)  
SELECT FItemID,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,isnull(FFirstUnitRate,0),isnull(FSecondUnitRate,0),isnull(FIsManage,0),FPackType,isnull(FLenDecimal,2),isnull(FCubageDecimal,4),isnull(FWeightDecimal,2),isnull(FImpostTaxRate,0),
isnull(FConsumeTaxRate,0),FManageType,FExportRate FROM Inserted     
INSERT INTO t_ICItemCustom(FItemID) SELECT  FItemID FROM Inserted    
        END    
        IF (@@error <> 0)      
            ROLLBACK TRANSACTION      
        ELSE      
            COMMIT TRANSACTION      
        END    