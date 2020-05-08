--DROP TABLE #t_SubDBRKD  

--从正式账套读取主表数据写入临时表 #t_SubDBRKD
SELECT * INTO #t_SubDBRKD 
FROM CON11.AIS_YXSP2.dbo.t_SubDBRKD 
WHERE  FDate >='2018-06-01' AND FDate <'2018-07-01'  
ORDER BY FDate


--如果单号已存在目标账套，不再同步,开始时间从2018-06-01开始
DELETE FROM #t_SubDBRKD WHERE FBillNo IN(SELECT FBillNo FROM t_SubDBRKD WHERE FDate >='2018-06-01' ) 
 

--临时表增加字段 FZID 
ALTER TABLE #t_SubDBRKD ADD FZID INT IDENTITY(1,1)




--数据按日期排序，循环读取

DECLARE @ZID INT  --计数器标志
SELECT @ZID=1

DECLARE @CountNum INT --临时表数据总行数
SELECT  @CountNum=COUNT(*) FROM #t_SubDBRKD	    

--分录表需要变动的参数
DECLARE @FID INT --单据内码


WHILE(@ZID<=@CountNum)
BEGIN --循环开始

--1写入主表数据 t_SubDBRKD
SELECT @FID=FID FROM #t_SubDBRKD t WHERE FZID=@ZID

INSERT INTO t_SubDBRKD 
SELECT FID,FClassTypeID,FBillNo,
FBiller=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FBiller  ))  ,
FCheckUser=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckUser  ))  ,
FCheckDate,FVoucherID,FVoucherID_ID,
FSUbDBCkdID =(select FItemID from t_Item_3001 WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Item_3001 WHERE FItemID=t.FSUbDBCkdID  ))  ,
FSubDBRkID =(select FItemID from t_Item_3001 WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Item_3001 WHERE FItemID=t.FSubDBRkID  ))  ,
FDate,FText,FDecimal	
FROM #t_SubDBRKD t  WHERE fzid=@ZID


--2写入分录数据 t_SubDBRKDEntry
INSERT INTO t_SubDBRKDEntry 
SELECT FID,	FIndex,
FItemID=( select FItemID from dbo.t_ICItem WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_ICItem WHERE FItemID=t.FItemID  ))  ,	
FBase=(select FItemID from dbo.t_MeasureUnit WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_MeasureUnit WHERE FItemID=t.FBase  ))  ,
FSubQty,FSubPrice,FAmount,Fnoteqty
FROM CON11.AIS_YXSP2.dbo.t_SubDBRKDEntry t where FID= @FID


--插入记录表 ICClassCheckRecords200000008
DELETE FROM ICClassCheckRecords200000008 WHERE FBillID=@FID

INSERT INTO ICClassCheckRecords200000008
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCheckLevel,FCheckLevelTo,FMode,
FCheckMan=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan  ))  ,
FCheckIdea,	FCheckDate,	FDescriptions
FROM CON11.AIS_YXSP2.dbo.ICClassCheckRecords200000008 t WHERE FBillID=@FID


--插入审核表 ICClassCheckStatus200000008
DELETE FROM ICClassCheckStatus200000008 WHERE FBillID=@FID
INSERT ICClassCheckStatus200000008(FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,FCheckMan1,FCheckIdea1,FCheckDate1)
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,
FCheckMan1=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan1  ))  ,
FCheckIdea1,FCheckDate1 FROM CON11.AIS_YXSP2.dbo.ICClassCheckStatus200000008 t WHERE FBillID= @FID


SELECT @ZID=@ZID+1 --计数器加1
PRINT @ZID


END --循环结束




                                            
