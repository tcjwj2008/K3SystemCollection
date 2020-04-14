--DROP TABLE #T_SubRKD

--从正式账套读取主表数据写入临时表 #T_SubRKD
SELECT * INTO #T_SubRKD FROM CON11.AIS_YXSP2.dbo.T_SubRKD 
WHERE FSubRKDate >='2018-04-01' AND FSubRKDate <'2018-05-01'  
ORDER BY FSubRKDate


SELECT * FROM #T_SubRKD WHERE FSubID=9186


--如果单号已存在目标账套，不再同步,开始时间从2018-04-01开始
DELETE FROM #T_SubRKD WHERE FBillNo IN(SELECT FBillNo FROM T_SubRKD WHERE FSubRKDate >='2018-04-01' )
 
 

--临时表增加字段 FZID 
ALTER TABLE #T_SubRKD ADD FZID INT IDENTITY(1,1)


--数据按日期排序，循环读取

DECLARE @ZID INT  --计数器标志
SELECT @ZID=1

DECLARE @CountNum INT --临时表数据总行数
SELECT  @CountNum=COUNT(*) FROM #T_SubRKD

--主表需要变动的参数
DECLARE @FSubID int,       --门店内码
	    @FBiller INT,      --制单人
	    @FSubSupplier INT, --供应商内码
	    @Fcheckerid INT    --审核人内码
	    

--分录表需要变动的参数
DECLARE @FSubRKDItemID int	, --物料内码
        @FSubRKDMeasure INT,   --单位内码
        @FID INT --单据内码


WHILE(@ZID<=@CountNum)
BEGIN --循环开始

--1写入主表数据 T_SubRKD
SELECT @FID=FID FROM #T_SubRKD t WHERE FZID=@ZID

INSERT INTO T_SubRKD 
SELECT FID,	FClassTypeID,FBillNo,FSubRKDate,
FSubID =(select FItemID from t_Item_3001 WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Item_3001 WHERE FItemID=t.FSubID  ))  ,
FBiller=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FBiller  ))  ,
FBase,
FSubSupplier=(select FItemID from t_Supplier WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Supplier WHERE FItemID=t.FSubSupplier  ))  ,
Fcheckid=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.Fcheckid  ))  ,
FcheckDate,Fcheckerid,FVoucherID,FVoucherID_ID,FSubCustomid,CarNO FROM #T_SubRKD t  WHERE fzid=@ZID

--2写入分录数据 T_SubRKDEntry
INSERT INTO T_SubRKDEntry 
SELECT FID,	FIndex,	FBase1,	
FSubRKDItemID=( select FItemID from dbo.t_ICItem WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_ICItem WHERE FItemID=t.FSubRKDItemID  ))  ,	
FSubRKDMeasure=(select FItemID from dbo.t_MeasureUnit WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_MeasureUnit WHERE FItemID=t.FSubRKDMeasure  ))  ,
FSubRKDPSQty,FSubRKDQty,FSubRKDPrice,FSubRKDLoseQty,FSubRKDAmount,FBaseText,
FSaleprice,	FsaleAmount,Fcommitqty,	Secunit,secqty
FROM CON11.AIS_YXSP2.dbo.T_SubRKDEntry t where FID= @FID --ORDER BY FIndex


--插入记录表 ICClassCheckRecords200000004
DELETE FROM ICClassCheckRecords200000004 WHERE FBillID=@FID

INSERT INTO ICClassCheckRecords200000004
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCheckLevel,FCheckLevelTo,FMode,
FCheckMan=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan  ))  ,
FCheckIdea,	FCheckDate,	FDescriptions
FROM CON11.AIS_YXSP2.dbo.ICClassCheckRecords200000004 t WHERE FBillID=@FID


--插入审核表 ICClassCheckStatus200000004
DELETE FROM ICClassCheckStatus200000004 WHERE FBillID=@FID
INSERT ICClassCheckStatus200000004(FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,FCheckMan1,FCheckIdea1,FCheckDate1)
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,
FCheckMan1=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan1  ))  ,
FCheckIdea1,FCheckDate1 FROM CON11.AIS_YXSP2.dbo.ICClassCheckStatus200000004 t WHERE FBillID= @FID


SELECT @ZID=@ZID+1 --计数器加1
PRINT @ZID


END --循环结束




                                            
