
/****

****/

SELECT 
CIP_AssetsApplicationEntry.FBillNo_SRC,CIP_AssetsApplication.FBillNo,CIP_AssetsApplication.FDate,CIP_AssetsApplication.FMultiCheckStatus,CIP_AssetsApplication.FMultiCheckStatus,CIP_AssetsApplication.FSourceID,
CIP_AssetsApplication.FPurposeID,CIP_AssetsApplication.FProjectID,t_Base_ProjectItem.FNumber AS FProjectID_FNDName,t_Base_ProjectItem.FName AS FProjectID_DSPName,CIP_AssetsApplication.FStockID,t_Stock.FNumber AS FStockID_FNDName,
t_Stock.FName AS FStockID_DSPName,CIP_AssetsApplication.FDeliveryID,t_Emp.FNumber AS FDeliveryID_FNDName,t_Emp.FName AS FDeliveryID_DSPName,CIP_AssetsApplication.FApplyDeptID,t_Department.FNumber AS FApplyDeptID_FNDName,
t_Department.FName AS FApplyDeptID_DSPName,CIP_AssetsApplication.FApplyID,t_Emp1.FNumber AS FApplyID_FNDName,t_Emp1.FName AS FApplyID_DSPName,CIP_AssetsApplication.FID,CIP_AssetsApplicationEntry.FBatchNo,
CIP_AssetsApplicationEntry.FItemID AS FPriceDecimal,t_ICItem1.FPriceDecimal AS FPriceDecimal_DSPName,CIP_AssetsApplication.FBiller,t_User.FName AS FBiller_FNDName,t_User.FName AS FBiller_DSPName,CIP_AssetsApplication.FCheckerID,
t_User1.FName AS FCheckerID_FNDName,t_User1.FName AS FCheckerID_DSPName,CIP_AssetsApplication.FCheckDate,CIP_AssetsApplication.FVoucherID,CIP_AssetsApplication.FVoucherID,CIP_AssetsApplication.FYearPeriod,
CIP_AssetsApplication.FLVCAcctID,t_Account.FNumber AS FLVCAcctID_FNDName,t_Account.FName AS FLVCAcctID_DSPName,CIP_AssetsApplication.FNote,CIP_AssetsApplicationEntry.FAssetCategoryID,vw_CIPFAGroupEntry.FNumber AS FAssetCategoryID_FNDName,
vw_CIPFAGroupEntry.FName AS FAssetCategoryID_DSPName,CIP_AssetsApplicationEntry.FItemID,t_ICItem1.FNumber AS FItemID_FNDName,t_ICItem1.FTrack AS FItemID_Track,t_ICItem1.FBatchManager AS FItemID_BatchNoManage,t_ICItem1.FQtyDecimal AS FItemID_FQtyDecimal,
t_ICItem1.FPriceDecimal AS FItemID_FPriceDecimal,t_ICItem1.FUnitGroupID AS FItemID_UnitGroupID,t_ICItem1.FISKFPeriod AS FItemID_FISKFPeriod,t_ICItem1.FAuxClassID AS FItemID_FAuxClassID,t_ICItem1.FNumber AS FItemID_DSPName,CIP_AssetsApplicationEntry.FItemID AS FItemName,
t_ICItem1.FName AS FItemName_DSPName,CIP_AssetsApplicationEntry.FItemID AS FItemModel,t_ICItem1.FModel AS FItemModel_DSPName,CIP_AssetsApplicationEntry.FItemAuxProPertyID,t_AuxItem.FNumber AS FItemAuxProPertyID_FNDName,t_AuxItem.FName AS FItemAuxProPertyID_DSPName,
CIP_AssetsApplicationEntry.FStockID AS FEntryStockID,t_Stock1.FNumber AS FEntryStockID_FNDName,t_Stock1.FName AS FEntryStockID_DSPName,CIP_AssetsApplicationEntry.FDcspID,t_StockPlace.FNumber AS FDcspID_FNDName,t_StockPlace.FName AS FDcspID_DSPName,
CIP_AssetsApplicationEntry.FUseTimes,CIP_AssetsApplicationEntry.FItemID AS FBaseUnit,t_ICItem1_FBaseUnit.FName AS FBaseUnit_DSPName,CIP_AssetsApplicationEntry.FBaseQty,CIP_AssetsApplicationEntry.FUnitID,t_Measureunit.FNumber AS FUnitID_FNDName,
t_Measureunit.FName AS FUnitID_DSPName,CIP_AssetsApplicationEntry.FQty,CIP_AssetsApplicationEntry.FStockQty,CIP_AssetsApplicationEntry.FCheckQty,CIP_AssetsApplicationEntry.FClassID_SRC,ICClassType1.FName_CHS AS FClassID_SRC_FNDName,
ICClassType1.FName_CHS AS FClassID_SRC_DSPName,CIP_AssetsApplicationEntry.FItemID AS FAuxUnit,t_ICItem1_FAuxUnit.FName AS FAuxUnit_DSPName,CIP_AssetsApplicationEntry.FSecCoefficient,CIP_AssetsApplicationEntry.FAuxQty,CIP_AssetsApplicationEntry.FPrice,
CIP_AssetsApplicationEntry.FAmount,CIP_AssetsApplicationEntry.FBackQty,CIP_AssetsApplicationEntry.FBackAmount,CIP_AssetsApplicationEntry.FTaxRate,CIP_AssetsApplicationEntry.FTaxAmt,CIP_AssetsApplicationEntry.FTotalAmt,
CIP_AssetsApplicationEntry.FOrigin,CIP_AssetsApplicationEntry.FSupplyID,t_Supplier.FNumber AS FSupplyID_FNDName,t_Supplier.FName AS FSupplyID_DSPName,CIP_AssetsApplicationEntry.FManufacturer,CIP_AssetsApplicationEntry.FEmpID,
t_Emp2.FNumber AS FEmpID_FNDName,t_Emp2.FName AS FEmpID_DSPName,CIP_AssetsApplicationEntry.FUseYear,CIP_AssetsApplicationEntry.FFStorePlaceID,vw_CIPFALocationEntry.FNumber AS FFStorePlaceID_FNDName,vw_CIPFALocationEntry.FName AS FFStorePlaceID_DSPName,
CIP_AssetsApplicationEntry.FEconomicPurposeID,CIP_AssetsApplicationEntry.FFAQty,CIP_AssetsApplicationEntry.FFAAmount,CIP_AssetsApplicationEntry.FFATaxAmt,CIP_AssetsApplicationEntry.FLVCQty,CIP_AssetsApplicationEntry.FLVCAmount,
CIP_AssetsApplicationEntry.FLVCTaxAmt,CIP_AssetsApplicationEntry.FCIPQty,CIP_AssetsApplicationEntry.FCIPAmount,CIP_AssetsApplicationEntry.FCIPTaxAmt,CIP_AssetsApplicationEntry.FID_SRC,CIP_AssetsApplicationEntry.FEntryID_SRC,
CIP_AssetsApplication.FClassTypeID,CIP_AssetsApplicationEntry.FEntryID AS FEntryID2,CIP_AssetsApplicationEntry.FID AS FID2,CIP_AssetsApplicationEntry.FIndex AS FIndex2,CIP_AssetsApplicationEntry.FBackStatus,CIP_AssetsApplication.FBillType 



 FROM  CIP_AssetsApplication  INNER JOIN CIP_AssetsApplicationEntry  ON CIP_AssetsApplication.FID=CIP_AssetsApplicationEntry.FID
 LEFT  JOIN t_Department  ON CIP_AssetsApplication.FApplyDeptID=t_Department.FItemID AND t_Department.FItemID<>0
 LEFT  JOIN t_Stock  ON CIP_AssetsApplication.FStockID=t_Stock.FItemID AND t_Stock.FItemID<>0
 LEFT  JOIN t_Emp t_Emp1 ON CIP_AssetsApplication.FApplyID=t_Emp1.FItemID AND t_Emp1.FItemID<>0
 LEFT  JOIN t_Emp  ON CIP_AssetsApplication.FDeliveryID=t_Emp.FItemID AND t_Emp.FItemID<>0
 LEFT  JOIN t_Base_ProjectItem  ON CIP_AssetsApplication.FProjectID=t_Base_ProjectItem.FItemID AND t_Base_ProjectItem.FItemID<>0
 LEFT  JOIN t_Account  ON CIP_AssetsApplication.FLVCAcctID=t_Account.FAccountID AND t_Account.FAccountID<>0
 LEFT  JOIN t_User t_User1 ON CIP_AssetsApplication.FCheckerID=t_User1.FUserID AND t_User1.FUserID<>0
 LEFT  JOIN t_User  ON CIP_AssetsApplication.FBiller=t_User.FUserID AND t_User.FUserID<>0
 LEFT  JOIN vw_CIPFAGroupEntry  ON CIP_AssetsApplicationEntry.FAssetCategoryID=vw_CIPFAGroupEntry.FID
 LEFT  JOIN t_ICItem t_ICItem1 ON CIP_AssetsApplicationEntry.FItemID=t_ICItem1.FItemID AND t_ICItem1.FItemID<>0
 LEFT  JOIN t_AuxItem  ON CIP_AssetsApplicationEntry.FItemAuxProPertyID=t_AuxItem.FItemID AND t_AuxItem.FItemID<>0
 LEFT  JOIN t_Stock t_Stock1 ON CIP_AssetsApplicationEntry.FStockID=t_Stock1.FItemID AND t_Stock1.FItemID<>0
 LEFT  JOIN t_StockPlace  ON CIP_AssetsApplicationEntry.FDcspID=t_StockPlace.FSPID AND t_StockPlace.FSPID<>0
 LEFT  JOIN t_Item t_ICItem1_FBaseUnit ON t_ICItem1.FUnitID=t_ICItem1_FBaseUnit.FItemID AND t_ICItem1_FBaseUnit.FItemID<>0
 LEFT  JOIN t_Measureunit  ON CIP_AssetsApplicationEntry.FUnitID=t_Measureunit.FItemID AND t_Measureunit.FItemID<>0
 LEFT  JOIN t_MeasureUnit t_ICItem1_FAuxUnit ON t_ICItem1.FSecUnitID=t_ICItem1_FAuxUnit.FItemID AND t_ICItem1_FAuxUnit.FItemID<>0
 LEFT  JOIN t_Supplier  ON CIP_AssetsApplicationEntry.FSupplyID=t_Supplier.FItemID AND t_Supplier.FItemID<>0
 LEFT  JOIN t_Emp t_Emp2 ON CIP_AssetsApplicationEntry.FEmpID=t_Emp2.FItemID AND t_Emp2.FItemID<>0
 LEFT  JOIN vw_CIPFALocationEntry  ON CIP_AssetsApplicationEntry.FFStorePlaceID=vw_CIPFALocationEntry.FID
 LEFT  JOIN ICClassType ICClassType1 ON ABS(CIP_AssetsApplicationEntry.FClassID_SRC)=ABS(ICClassType1.FID) AND ICClassType1.FID<>0
 
 

 
 UPDATE CIP_AssetsApplication SET
 FVOUCHERID='',FVOUCHERID_ID=''
 WHERE CIP_AssetsApplication.FID=1064