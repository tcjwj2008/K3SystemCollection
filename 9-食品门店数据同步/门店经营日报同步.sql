--DROP TABLE #t_SubCustomSell

--从正式账套读取主表数据写入临时表 #t_SubCustomSell
SELECT * INTO #t_SubCustomSell 
FROM CON11.AIS_YXSP2.dbo.t_SubCustomSell 
WHERE FDate >='2018-06-01' AND FDate <'2018-07-01'  
ORDER BY FDate


--如果单号已存在目标账套，不再同步,开始时间从2018-06-01开始
DELETE FROM #t_SubCustomSell WHERE FBillNo IN(SELECT FBillNo FROM t_SubCustomSell WHERE FDate >='2018-06-01' ) 
 

--临时表增加字段 FZID 
ALTER TABLE #t_SubCustomSell ADD FZID INT IDENTITY(1,1)

--SELECT * FROM #t_SubCustomSell


--数据按日期排序，循环读取

DECLARE @ZID INT  --计数器标志
SELECT @ZID=1

DECLARE @CountNum INT --临时表数据总行数
SELECT  @CountNum=COUNT(*) FROM #t_SubCustomSell


DECLARE  @FID INT --单据内码

WHILE(@ZID<=@CountNum)
BEGIN --循环开始

--1写入主表数据 T_SubRKD
SELECT @FID=FID FROM #t_SubCustomSell t WHERE FZID=@ZID

INSERT INTO t_SubCustomSell 
SELECT FID,FClassTypeID,FBillNo,
FSubBHID=(select FItemID from t_Item_3001 WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Item_3001 WHERE FItemID=t.FSubBHID  ))  ,
FDate,FSub,FSubAffQty,FSubAffWgt,FSubCustQty,FSubRYAmount,FSubDZPAmount,
FSubRZPAmount,FSubSumAmount,FSubEggAmount,FSubDBCqty,FSubDBCAmount,FSubDBRQty,FSubDBRAmount,FSubRemQty,
FSubRemAmount,FSubRembz,FSubFrostQty,FSubSellSumQty,FSubDesQty,FSubCustomSellBz,FVoucherID,FVoucherID_ID,
FBiller=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FBiller  ))  ,
FCheckUserID=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckUserID  ))  ,
FCheckDate,FSubVol1,FSubVol2,FSunVol3,FSubVol_ID1,FSubVol_ID2,FSubVol_ID3,FSubAllBankAmount,
FSubTokenAllAmount,FSubXDFAmount,FSubDisCount,FSubPCSQty,FSubXRJe,FSubXRSe,FSubDZPJe,FSubDZPSe,FSubRZPJe,
FSubRZPSe,FSubJDJe,FSubJDSe,FSubXDFJe,FSubXDFSe,FItemClassType,FDecimal,FDecimal1,FDecimal2,FDecimal3,
FDecimal4,FSubOtherAmount,FChickenWeight,FChickenSaleWeight,FChickenIncome FROM #t_SubCustomSell t where fzid= @ZID


--2写入分录数据(销售情况) t_SubCustomSellMX
INSERT INTO t_SubCustomSellMX
SELECT FID,FIndex,
FSCSMXRY=(select FItemID from t_Emp WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Emp WHERE FItemID=t.FSCSMXRY  ))  ,--收银员
FSCSMXYesDayAmount,FSCSMXYPrintAmount,FSCSMXNPrintAmount,FSCSMXExAmount,FSCSMXBlAmount,
FSCSMXCashAmount,FSCSMXSaleAmount,FSCSMXSumAmount,FSCSMXRetAmount,FSCSMXBankAmount,FSCSMXProAmount,
FSCSMXLeavAmount,FSubDBCKAmount,FSubDBRKAmount,FSubSJAmount,FSCSMXOtherAmount 
FROM CON11.AIS_YXSP2.dbo.t_SubCustomSellMX t where FID=@FID 

--3写入分录数据(赊销情况) t_SubCustomSaleMX
INSERT INTO t_SubCustomSaleMX
SELECT FID,FIndex,
FSCSaleCustomid=( select FItemID from dbo.t_Organization WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Organization WHERE FItemID=t.FSCSaleCustomid  ))  ,   --客户代码
FSCSaleItemID=( select FItemID from dbo.t_ICItem WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_ICItem WHERE FItemID=t.FSCSaleItemID  ))  ,	    --物料内码
FSCSaleQty,FSCSalePrice,FSCSaleAmount,FSubYSQty,FSubLoseQty,FNOTE,FNOTE2
FROM CON11.AIS_YXSP2.dbo.t_SubCustomSaleMX t where FID=@FID 		


--4写入分录数据(回款情况) t_SubCustomRetMX
INSERT INTO  t_SubCustomRetMX
SELECT FID,	FIndex,	
FSCRetCustomID=( select FItemID from dbo.t_Organization WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Organization WHERE FItemID=t.FSCRetCustomID  ))  ,   --客户代码	
FSCRetAmount,FNOTE3 
FROM CON11.AIS_YXSP2.dbo.t_SubCustomRetMX t where FID=@FID 


--插入记录表 ICClassCheckRecords200000003
DELETE FROM ICClassCheckRecords200000003 WHERE FBillID=@FID
INSERT INTO ICClassCheckRecords200000003
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCheckLevel,FCheckLevelTo,FMode,
FCheckMan=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan  ))  ,
FCheckIdea,	FCheckDate,	FDescriptions
FROM CON11.AIS_YXSP2.dbo.ICClassCheckRecords200000003 t WHERE FBillID=@FID


--插入审核表 ICClassCheckStatus200000003
DELETE FROM ICClassCheckStatus200000003 WHERE FBillID=@FID
INSERT ICClassCheckStatus200000003(FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,FCheckMan1,FCheckIdea1,FCheckDate1)
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,
FCheckMan1=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan1  ))  ,
FCheckIdea1,FCheckDate1 FROM CON11.AIS_YXSP2.dbo.ICClassCheckStatus200000003 t WHERE FBillID= @FID


SELECT @ZID=@ZID+1 --计数器加1
PRINT @ZID


END --循环结束




                                            
