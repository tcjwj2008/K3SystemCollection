--DROP TABLE #t_SubDBRKD  

--����ʽ���׶�ȡ��������д����ʱ�� #t_SubDBRKD
SELECT * INTO #t_SubDBRKD 
FROM CON11.AIS_YXSP2.dbo.t_SubDBRKD 
WHERE  FDate >='2018-06-01' AND FDate <'2018-07-01'  
ORDER BY FDate


--��������Ѵ���Ŀ�����ף�����ͬ��,��ʼʱ���2018-06-01��ʼ
DELETE FROM #t_SubDBRKD WHERE FBillNo IN(SELECT FBillNo FROM t_SubDBRKD WHERE FDate >='2018-06-01' ) 
 

--��ʱ�������ֶ� FZID 
ALTER TABLE #t_SubDBRKD ADD FZID INT IDENTITY(1,1)




--���ݰ���������ѭ����ȡ

DECLARE @ZID INT  --��������־
SELECT @ZID=1

DECLARE @CountNum INT --��ʱ������������
SELECT  @CountNum=COUNT(*) FROM #t_SubDBRKD	    

--��¼����Ҫ�䶯�Ĳ���
DECLARE @FID INT --��������


WHILE(@ZID<=@CountNum)
BEGIN --ѭ����ʼ

--1д���������� t_SubDBRKD
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


--2д���¼���� t_SubDBRKDEntry
INSERT INTO t_SubDBRKDEntry 
SELECT FID,	FIndex,
FItemID=( select FItemID from dbo.t_ICItem WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_ICItem WHERE FItemID=t.FItemID  ))  ,	
FBase=(select FItemID from dbo.t_MeasureUnit WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_MeasureUnit WHERE FItemID=t.FBase  ))  ,
FSubQty,FSubPrice,FAmount,Fnoteqty
FROM CON11.AIS_YXSP2.dbo.t_SubDBRKDEntry t where FID= @FID


--�����¼�� ICClassCheckRecords200000008
DELETE FROM ICClassCheckRecords200000008 WHERE FBillID=@FID

INSERT INTO ICClassCheckRecords200000008
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCheckLevel,FCheckLevelTo,FMode,
FCheckMan=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan  ))  ,
FCheckIdea,	FCheckDate,	FDescriptions
FROM CON11.AIS_YXSP2.dbo.ICClassCheckRecords200000008 t WHERE FBillID=@FID


--������˱� ICClassCheckStatus200000008
DELETE FROM ICClassCheckStatus200000008 WHERE FBillID=@FID
INSERT ICClassCheckStatus200000008(FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,FCheckMan1,FCheckIdea1,FCheckDate1)
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,
FCheckMan1=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan1  ))  ,
FCheckIdea1,FCheckDate1 FROM CON11.AIS_YXSP2.dbo.ICClassCheckStatus200000008 t WHERE FBillID= @FID


SELECT @ZID=@ZID+1 --��������1
PRINT @ZID


END --ѭ������




                                            
