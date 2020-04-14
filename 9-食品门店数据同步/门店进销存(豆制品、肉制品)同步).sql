--DROP TABLE #t_SubRD_Balance  

--����ʽ���׶�ȡ��������д����ʱ�� #t_SubRD_Balance
SELECT * INTO #t_SubRD_Balance 
FROM CON11.AIS_YXSP2.dbo.t_SubRD_Balance 
WHERE  FDate >='2018-06-01' AND FDate <'2018-07-01'  
ORDER BY FDate


--��������Ѵ���Ŀ�����ף�����ͬ��,��ʼʱ���2018-06-01��ʼ
DELETE FROM #t_SubRD_Balance WHERE FBillNo IN(SELECT FBillNo FROM t_SubRD_Balance WHERE FDate >='2018-06-01' ) 
 

--��ʱ�������ֶ� FZID 
ALTER TABLE #t_SubRD_Balance ADD FZID INT IDENTITY(1,1)


--SELECT * FROM #t_SubRD_Balance


--���ݰ���������ѭ����ȡ

DECLARE @ZID INT  --��������־
SELECT @ZID=1

DECLARE @CountNum INT --��ʱ������������
SELECT  @CountNum=COUNT(*) FROM #t_SubRD_Balance	    

--��¼����Ҫ�䶯�Ĳ���
DECLARE @FID INT --��������


WHILE(@ZID<=@CountNum)
BEGIN --ѭ����ʼ

--1д���������� t_SubRD_Balance
SELECT @FID=FID FROM #t_SubRD_Balance t WHERE FZID=@ZID

INSERT INTO t_SubRD_Balance
SELECT FID,FClassTypeID,FBillNo,FDate,FBase,FSukID,FVoucherID,FVoucherID_ID,
FSubSupLierID=(select FItemID FROM t_Supplier WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Supplier WHERE FItemID=t.FSubSupLierID  ))  ,
FBiller=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FBiller  ))  ,
FCheckUserID=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckUserID  ))  ,
FCheckDate,
FSubID=(select FItemID from t_Item_3001 WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Item_3001 WHERE FItemID=t.FSubID  ))  
FROM #t_SubRD_Balance t  WHERE fzid=@ZID


--2д���¼���� t_SubRD_BalanceEntry
INSERT INTO t_SubRD_BalanceEntry 
SELECT FID,FIndex,
FSubItemID=( select FItemID from dbo.t_ICItem WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_ICItem WHERE FItemID=t.FSubItemID  ))  ,
FYesDayQty,FSubItemCBJ,FSubYesDayAmount,FSubPurQty,FSubPurPrice,FSubPurAmount,
FSubSallQty,FSubPresentqty,FSubProfitqty,FSubTodayRemQty,
FBase1=(select FItemID from dbo.t_MeasureUnit WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_MeasureUnit WHERE FItemID=t.FBase1  ))  ,
FPrice,FAmount,FSubItemCBJ1,FPrice1,FNOTE
FROM CON11.AIS_YXSP2.dbo.t_SubRD_BalanceEntry t where FID= @FID


--�����¼�� ICClassCheckRecords200000005
DELETE FROM ICClassCheckRecords200000005 WHERE FBillID=@FID

INSERT INTO ICClassCheckRecords200000005
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCheckLevel,FCheckLevelTo,FMode,
FCheckMan=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan  ))  ,
FCheckIdea,	FCheckDate,	FDescriptions
FROM CON11.AIS_YXSP2.dbo.ICClassCheckRecords200000005 t WHERE FBillID=@FID


--������˱� ICClassCheckStatus200000005
DELETE FROM ICClassCheckStatus200000005 WHERE FBillID=@FID
INSERT ICClassCheckStatus200000005(FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,FCheckMan1,FCheckIdea1,FCheckDate1)
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,
FCheckMan1=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan1  ))  ,
FCheckIdea1,FCheckDate1 FROM CON11.AIS_YXSP2.dbo.ICClassCheckStatus200000005 t WHERE FBillID= @FID


SELECT @ZID=@ZID+1 --��������1
PRINT @ZID


END --ѭ������




                                            
