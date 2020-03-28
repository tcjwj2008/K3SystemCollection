------同步上级组

select FDetail,* from t_Item where fnumber='02.002'

select * from t_ItemClass

select * from t_item where  fitemclassID=4
select * from t_item where  FNumber='02.002'

Select FNumber from t_item where FItemClassID = 2001

select * from t_DataTypeInfo

Select newid() as UUID

SELECT FItemID FROM t_Item WHERE FItemClassID=4 AND FNumber='02'


SELECT FItemID FROM t_Item WHERE FItemClassID=0 AND FNumber=' '

INSERT INTO t_Item
 (FItemClassID,FParentID,FLevel,FName,FNumber,
 FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
 VALUES 
 (4,0,1,'测试上级组','03',
 '03','03',0,'35E34BD1-276E-4AB0-A6F8-26F5E4DD4F61',0)

Select FName,FName_CHT,FName_EN From t_ItemClass Where FItemClassID = 4

 Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  select fitemclassid,fuserid,944 from t_useritemclassright where (( FUserItemClassRight &  8)=8) and fitemclassid=4 and fuserid<>16394

INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress) VALUES (getdate(),16394,'A00701',5,'新建核算项目:02 核算项目类别:物料','WIN-5579AATH4RN','192.168.6.149')

Select * from t_BaseProperty Where FTypeID = 3 And FItemID = 936

select * from t_TableDescription where FTableName='t_BaseProperty'
select * from t_FieldDescription where FTableID=41


Select FTypeID from t_BaseProperty  group by ftypeID

Insert Into t_BaseProperty(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, FLastModUser, FDeleteDate, FDeleteUser)
Values(3, 936, '2018-01-28 22:36:30', 'administrator', Null, Null, Null, Null)

select FItemClassID from t_ItemClass where FItemClassID = 2001

SELECT FItemID FROM t_Item WHERE FItemClassID=2001 AND FNumber='02'

INSERT INTO t_Item
 (FItemClassID,FParentID,FLevel,FName,FNumber,
 FShortNumber,FFullNumber,FDetail,UUID,FDeleted)
  VALUES (2001,0,1,'测试上级组','02',
  '02','02',0,'1FA16BC5-05CD-4075-9F9A-9B2026E63B9A',0)

   Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  select fitemclassid,fuserid,945 from t_useritemclassright where (( FUserItemClassRight &  8)=8) and fitemclassid=2001 and fuserid<>16394

INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress) VALUES (getdate(),16394,'A00701',5,'新建核算项目:02 核算项目类别:成本对象','WIN-5579AATH4RN','192.168.6.149')


Select * from t_BaseProperty Where FTypeID = 3 And FItemID = 937

Insert Into t_BaseProperty(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, FLastModUser, FDeleteDate, FDeleteUser)Values(3, 937, '2018-01-28 22:36:30', 'administrator', Null, Null, Null, Null)

select * from Access_cbCostObj

Delete from Access_cbCostObj where FItemID=937
 Insert into Access_cbCostObj(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
 Values(937,0,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

 update t_Item set FName=FName where FItemID=937 and FItemClassID=2001

 Delete from Access_t_ICItem where FItemID=936
 Insert into Access_t_ICItem(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
 Values(936,0,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

 update t_Item set FName=FName where FItemID=936 and FItemClassID=4
 UPDATE t1  SET t1.FFullName = t2.FFullName FROM t_ICItemBase t1 INNER JOIN t_Item t2 ON t1.FItemID = t2.FItemID AND t2.FItemID =936


 ------同步外购物料明细
 INSERT INTO t_Item 
 (FItemClassID,FParentID,FLevel,FName,FNumber,
 FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
 VALUES (
4,936,2,'物料测试','02.003',
'003','02.003',1,'698AA4DF-ED81-4C26-9D5A-D098B9595B01',0)


INSERT INTO t_ICItem 
(FHelpCode,FModel,FAuxClassID,FErpClsID,FTypeID,
FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,
FStoreUnitID,FSecUnitID,FSecCoefficient,FDefaultLoc,FSPID,
FSource,FQtyDecimal,FLowLimit,FHighLimit,FSecInv,
FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,
FApproveNo,FAlias,FOrderRector,FPOHighPrice,FPOHghPrcMnyType,
FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,
FProfitRate,FOrderPrice,FSalePrice,FIsSpecialTax,FISKFPeriod,
FKFPeriod,FStockTime,FBatchManager,FBookPlan,FBeforeExpire,
FCheckCycUnit,FOIHighLimit,FOILowLimit,FSOHighLimit,FSOLowLimit,
FInHighLimit,FInLowLimit,FPickHighLimit,FPickLowLimit,FTrack,
FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,
FAPAcctID,FAdminAcctID,FGoodSpec,FTaxRate,FCostProject,
FIsSNManage,F_101,F_102,F_103,FCBRestore,
FNote,FPlanTrategy,FPlanMode,FOrderTrategy,FFixLeadTime,
FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,
FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,
FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,
FIsBackFlush,FBackFlushStockID,FBackFlushSPID,FPutInteger,FDailyConsume,
FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,
FNetWeight,FMaund,FLength,FWidth,FHeight,
FSize,FCubicMeasure,FStandardCost,FCBAppendRate,FCBAppendProject,
FCostBomID,FCBRouting,FStdBatchQty,FStandardManHour,FStdPayRate,
FChgFeeRate,FStdFixFeeRate,FOutMachFee,FOutMachFeeProject,FPieceRate,
FPOVAcctID,FPIVAcctID,FMCVAcctID,FPCVAcctID,FSLAcctID,
FCAVAcctID,FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,
FWthDrwChkMde,FStkChkMde,FOtherChkMde,FSampStdCritical,FSampStdStrict,
FSampStdSlight,FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,
FVersion,FNameEn,FModelEn,FHSNumber,FExportRate,
FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,
FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,
FWeightDecimal,FIsCharSourceItem,FCtrlType,FCtrlStraregy,FContainerName,
FKanBanCapability,FBatchSplitDays,FBatchSplit,FDefaultReadyLoc,FSPIDReady,
FStartService,FMakeFile,FIsFix,FTtermOfService,FTtermOfUsefulTime,
FIsFixedReOrder,FOnlineShopPNo,FOnlineShopPName,FForbbitBarcodeEdit,FDSManagerID,
FUnitPackageNumber,FOrderDept,FProductDesigner,FAuxInMrpCal,FShortNumber,
FNumber,FName,FParentID,FItemID) 
VALUES (NULL,NULL,0,1,0,FHelpCode,FModel,FAuxClassID,FErpClsID,FTypeID,
341,342,342,342,342,FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,
342,0,'0',0,0,FStoreUnitID,FSecUnitID,FSecCoefficient,FDefaultLoc,FSPID,
0,4,'0','1000','0',FSource,FQtyDecimal,FLowLimit,FHighLimit,FSecInv,
341,0,NULL,0,'测试上级组_物料测试',FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,
NULL,NULL,0,'0',1,FApproveNo,FAlias,FOrderRector,FPOHighPrice,FPOHghPrcMnyType,
'0',1,'0',1,0,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,
'0','0','0',0,0,FProfitRate,FOrderPrice,FSalePrice,FIsSpecialTax,FISKFPeriod,
0,0,0,0,0,FKFPeriod,FStockTime,FBatchManager,FBookPlan,FBeforeExpire,
0,'0','0','0','0',FCheckCycUnit,FOIHighLimit,FOILowLimit,FSOHighLimit,FSOLowLimit,
'0','0','0','0',76,FInHighLimit,FInLowLimit,FPickHighLimit,FPickLowLimit,FTrack,
'0',2,1000,1000,1000,FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,
0,0,0,'17',0,FAPAcctID,FAdminAcctID,FGoodSpec,FTaxRate,FCostProject,
0,0,NULL,NULL,1,FIsSNManage,F_101,F_102,F_103,FCBRestore,
NULL,321,14036,331,0,FNote,FPlanTrategy,FPlanMode,FOrderTrategy,FFixLeadTime,
0,0,0,'1','10000',FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,
'1','0','0','1',1,FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,
1,0,0,0,0,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,
0,0,0,0,'0',FIsBackFlush,FBackFlushStockID,FBackFlushSPID,FPutInteger,FDailyConsume,
1,0,NULL,0,'0',FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,
'0',0,'0','0','0',FNetWeight,FMaund,FLength,FWidth,FHeight,
'0',0,'0','0',0,FSize,FCubicMeasure,FStandardCost,FCBAppendRate,FCBAppendProject,
0,0,'1','0','0',FCostBomID,FCBRouting,FStdBatchQty,FStandardManHour,FStdPayRate,
'0','0','0',0,'0',FChgFeeRate,FStdFixFeeRate,FOutMachFee,FOutMachFeeProject,FPieceRate,
0,0,0,0,0,FPOVAcctID,FPIVAcctID,FMCVAcctID,FPCVAcctID,FSLAcctID,
0,352,352,352,352,FCAVAcctID,FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,
352,352,352,0,0,FWthDrwChkMde,FStkChkMde,FOtherChkMde,FSampStdCritical,FSampStdStrict,
0,9999,0,0,0,FSampStdSlight,FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,
NULL,NULL,NULL,0,'0',FVersion,FNameEn,FModelEn,FHSNumber,FExportRate,
NULL,NULL,'0','0','0',FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,
'0',0,0,2,4,FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,
2,0,14039,0,NULL,FWeightDecimal,FIsCharSourceItem,FCtrlType,FCtrlStraregy,FContainerName,
1,0,0,0,0,FKanBanCapability,FBatchSplitDays,FBatchSplit,FDefaultReadyLoc,FSPIDReady,
0,0,0,0,0,FStartService,FMakeFile,FIsFix,FTtermOfService,FTtermOfUsefulTime,
1,NULL,NULL,0,0,FIsFixedReOrder,FOnlineShopPNo,FOnlineShopPName,FForbbitBarcodeEdit,FDSManagerID,
0,0,0,0,'003',FUnitPackageNumber,FOrderDept,FProductDesigner,FAuxInMrpCal,FShortNumber,
'02.003','物料测试',936,941)FNumber,FName,FParentID,FItemID)

Update t_ICItem Set FModel='' Where FItemID=941

 Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  select fitemclassid,fuserid,2579 from t_useritemclassright where (( FUserItemClassRight &  8)=8) and fitemclassid=4 and fuserid<>16394
 INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress) VALUES (getdate(),16394,'A00701',5,'新建核算项目:1.01.04.10 核算项目类别:物料','WIN-5579AATH4RN','192.168.6.149')

Insert Into t_BaseProperty
(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, 
FLastModUser, FDeleteDate, FDeleteUser)
Values(3, 941, '2018-01-29 15:17:57', 'administrator', Null, 
Null, Null, Null)

Delete from Access_t_ICItem where FItemID=941
 Insert into Access_t_ICItem(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
 Values(941,936,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

 Delete from  t_gr_itemcontrol where FItemID=941 and FItemClassID=4
insert into t_gr_itemcontrol(FFrameWorkID,FItemClassID,FItemID,FCanUse,FCanAdd,FCanModi,FCanDel)
select FFrameWorkID,FItemClassID,941,FCanUse,FCanAdd,FCanModi,FCanDel
from t_gr_itemcontrol where FItemID=936 and FItemClassID=4

update t_Item set FName=FName where FItemID=941 and FItemClassID=4

UPDATE t1  SET t1.FFullName = t2.FFullName FROM t_ICItemBase t1 INNER JOIN t_Item t2 ON t1.FItemID = t2.FItemID AND t2.FItemID =941


--------同步自制物料明细
SELECT FItemID FROM t_Item WHERE FItemClassID=4 AND FNumber='02.004'

INSERT INTO t_Item
 (FItemClassID,FParentID,FLevel,FName,FNumber,
 FShortNumber,FFullNumber,FDetail,UUID,FDeleted) 
 VALUES (4,936,2,'物料测试','02.004',
 '004','02.004',1,'CB5AAD33-F943-47C3-80F2-53982FF2ACF7',0)

 SELECT FItemID FROM t_Item WHERE FItemClassID=4 AND FNumber='02.004'

INSERT INTO t_ICItem 
(FHelpCode,FModel,FAuxClassID,FErpClsID,FTypeID,
FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,
FStoreUnitID,FSecUnitID,FSecCoefficient,FDefaultLoc,FSPID,
FSource,FQtyDecimal,FLowLimit,FHighLimit,FSecInv,
FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,
FApproveNo,FAlias,FOrderRector,FPOHighPrice,FPOHghPrcMnyType,
FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,
FProfitRate,FOrderPrice,FSalePrice,FIsSpecialTax,FISKFPeriod,
FKFPeriod,FStockTime,FBatchManager,FBookPlan,FBeforeExpire,
FCheckCycUnit,FOIHighLimit,FOILowLimit,FSOHighLimit,FSOLowLimit,
FInHighLimit,FInLowLimit,FPickHighLimit,FPickLowLimit,FTrack,
FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,
FAPAcctID,FAdminAcctID,FGoodSpec,FTaxRate,FCostProject,
FIsSNManage,F_101,F_102,F_103,FCBRestore,
FNote,FPlanTrategy,FPlanMode,FOrderTrategy,FFixLeadTime,
FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,
FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,
FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,
FIsBackFlush,FBackFlushStockID,FBackFlushSPID,FPutInteger,FDailyConsume,
FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,
FNetWeight,FMaund,FLength,FWidth,FHeight,
FSize,FCubicMeasure,FStandardCost,FCBAppendRate,FCBAppendProject,
FCostBomID,FCBRouting,FStdBatchQty,FStandardManHour,FStdPayRate,
FChgFeeRate,FStdFixFeeRate,FOutMachFee,FOutMachFeeProject,FPieceRate,
FPOVAcctID,FPIVAcctID,FMCVAcctID,FPCVAcctID,FSLAcctID,
FCAVAcctID,FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,
FWthDrwChkMde,FStkChkMde,FOtherChkMde,FSampStdCritical,FSampStdStrict,
FSampStdSlight,FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,
FVersion,FNameEn,FModelEn,FHSNumber,FExportRate,
FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,
FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,
FWeightDecimal,FIsCharSourceItem,FCtrlType,FCtrlStraregy,FContainerName,
FKanBanCapability,FBatchSplitDays,FBatchSplit,FDefaultReadyLoc,FSPIDReady,
FStartService,FMakeFile,FIsFix,FTtermOfService,FTtermOfUsefulTime,
FIsFixedReOrder,FOnlineShopPNo,FOnlineShopPName,FForbbitBarcodeEdit,FDSManagerID,
FUnitPackageNumber,FOrderDept,FProductDesigner,FAuxInMrpCal,FShortNumber,
FNumber,FName,FParentID,FItemID) 
VALUES (NULL,NULL,0,2,0,
341,342,342,342,342,
342,0,'0',0,0,
0,4,'0','1000','0',
341,0,NULL,0,'测试上级组_物料测试',
NULL,NULL,0,'0',1,
'0',1,'0',1,0,
'0','0','0',0,0,
0,0,0,0,0,
0,'0','0','0','0',
'0','0','0','0',76,
'0',2,1000,1000,1000,
0,0,0,'17',0,
0,0,NULL,NULL,1,
NULL,321,14036,331,0,
0,0,0,'1','10000',
'1','0','0','1',1,
1,0,0,0,0,
0,0,0,0,'0',
1,0,NULL,0,'0',
'0',0,'0','0','0',
'0',0,'0','0',0,
0,0,'1','0','0',
'0','0','0',0,'0',
0,0,0,0,0,
0,352,352,352,352,
352,352,352,0,0,
0,9999,0,0,0,
NULL,NULL,NULL,0,'0',
NULL,NULL,'0','0','0',
'0',0,0,2,4,
2,0,14039,0,NULL,
1,0,0,0,0,
0,0,0,0,0,
1,NULL,NULL,0,0,
0,0,0,0,'004',
'02.004','物料测试',936,942)

Update t_ICItem Set FModel='' Where FItemID=942

 Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  select fitemclassid,fuserid,942 from t_useritemclassright where (( FUserItemClassRight &  8)=8) and fitemclassid=4 and fuserid<>16394

 INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress) VALUES (getdate(),16394,'A00701',5,'新建核算项目:02.004 核算项目类别:物料','WIN-5579AATH4RN','192.168.6.149')

 Insert Into t_BaseProperty(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, FLastModUser, FDeleteDate, FDeleteUser)Values(3, 942, '2018-01-29 16:42:34', 'administrator', Null, Null, Null, Null)

 --增加成本对象ID返回  
 declare @p2 bigint
--set @p2=943
exec cbAddCostObj 942,@p2 output
select @p2

 Insert Into t_ItemRight (FTypeID,FUserID,FItemID)  select fitemclassid,fuserid,943 from t_useritemclassright where (( FUserItemClassRight &  8)=8) and fitemclassid=2001 and fuserid<>16394

 INSERT INTO t_Log (FDate,FUserID,FFunctionID,FStatement,FDescription,FMachineName,FIPAddress) VALUES (getdate(),16394,'A00701',5,'新建核算项目:02.004 核算项目类别:成本对象','WIN-5579AATH4RN','192.168.6.149')

 Insert Into t_BaseProperty(FTypeID, FItemID, FCreateDate, FCreateUser, FLastModDate, FLastModUser, FDeleteDate, FDeleteUser)Values(3, 943, '2018-01-29 16:42:35', 'administrator', Null, Null, Null, Null)

 Delete from Access_cbCostObj where FItemID=943
 Insert into Access_cbCostObj(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
 Values(943,937,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

 delete from  t_gr_itemcontrol where FItemID=943 and FItemClassID=2001
insert into t_gr_itemcontrol(FFrameWorkID,FItemClassID,FItemID,FCanUse,FCanAdd,FCanModi,FCanDel)
select FFrameWorkID,FItemClassID,943,FCanUse,FCanAdd,FCanModi,FCanDel
from t_gr_itemcontrol where FItemID=937 and FItemClassID=2001

update t_Item set FName=FName where FItemID=943 and FItemClassID=2001

Delete from Access_t_ICItem where FItemID=942
 Insert into Access_t_ICItem(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
 Values(942,936,convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)),convert(varbinary(7200),REPLICATE(char(255),100)))

 delete from  t_gr_itemcontrol where FItemID=942 and FItemClassID=4
insert into t_gr_itemcontrol(FFrameWorkID,FItemClassID,FItemID,FCanUse,FCanAdd,FCanModi,FCanDel)
select FFrameWorkID,FItemClassID,942,FCanUse,FCanAdd,FCanModi,FCanDel
from t_gr_itemcontrol where FItemID=936 and FItemClassID=4

UPDATE t1  SET t1.FFullName = t2.FFullName FROM t_ICItemBase t1 INNER JOIN t_Item t2 ON t1.FItemID = t2.FItemID AND t2.FItemID =942

