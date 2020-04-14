--DROP TABLE #T_SubRKD

--����ʽ���׶�ȡ��������д����ʱ�� #T_SubRKD
SELECT * INTO #T_SubRKD FROM CON11.AIS_YXSP2.dbo.T_SubRKD 
WHERE FSubRKDate >='2018-04-01' AND FSubRKDate <'2018-05-01'  
ORDER BY FSubRKDate


SELECT * FROM #T_SubRKD WHERE FSubID=9186


--��������Ѵ���Ŀ�����ף�����ͬ��,��ʼʱ���2018-04-01��ʼ
DELETE FROM #T_SubRKD WHERE FBillNo IN(SELECT FBillNo FROM T_SubRKD WHERE FSubRKDate >='2018-04-01' )
 
 

--��ʱ�������ֶ� FZID 
ALTER TABLE #T_SubRKD ADD FZID INT IDENTITY(1,1)


--���ݰ���������ѭ����ȡ

DECLARE @ZID INT  --��������־
SELECT @ZID=1

DECLARE @CountNum INT --��ʱ������������
SELECT  @CountNum=COUNT(*) FROM #T_SubRKD

--������Ҫ�䶯�Ĳ���
DECLARE @FSubID int,       --�ŵ�����
	    @FBiller INT,      --�Ƶ���
	    @FSubSupplier INT, --��Ӧ������
	    @Fcheckerid INT    --���������
	    

--��¼����Ҫ�䶯�Ĳ���
DECLARE @FSubRKDItemID int	, --��������
        @FSubRKDMeasure INT,   --��λ����
        @FID INT --��������


WHILE(@ZID<=@CountNum)
BEGIN --ѭ����ʼ

--1д���������� T_SubRKD
SELECT @FID=FID FROM #T_SubRKD t WHERE FZID=@ZID

INSERT INTO T_SubRKD 
SELECT FID,	FClassTypeID,FBillNo,FSubRKDate,
FSubID =(select FItemID from t_Item_3001 WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Item_3001 WHERE FItemID=t.FSubID  ))  ,
FBiller=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FBiller  ))  ,
FBase,
FSubSupplier=(select FItemID from t_Supplier WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Supplier WHERE FItemID=t.FSubSupplier  ))  ,
Fcheckid=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.Fcheckid  ))  ,
FcheckDate,Fcheckerid,FVoucherID,FVoucherID_ID,FSubCustomid,CarNO FROM #T_SubRKD t  WHERE fzid=@ZID

--2д���¼���� T_SubRKDEntry
INSERT INTO T_SubRKDEntry 
SELECT FID,	FIndex,	FBase1,	
FSubRKDItemID=( select FItemID from dbo.t_ICItem WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_ICItem WHERE FItemID=t.FSubRKDItemID  ))  ,	
FSubRKDMeasure=(select FItemID from dbo.t_MeasureUnit WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_MeasureUnit WHERE FItemID=t.FSubRKDMeasure  ))  ,
FSubRKDPSQty,FSubRKDQty,FSubRKDPrice,FSubRKDLoseQty,FSubRKDAmount,FBaseText,
FSaleprice,	FsaleAmount,Fcommitqty,	Secunit,secqty
FROM CON11.AIS_YXSP2.dbo.T_SubRKDEntry t where FID= @FID --ORDER BY FIndex


--�����¼�� ICClassCheckRecords200000004
DELETE FROM ICClassCheckRecords200000004 WHERE FBillID=@FID

INSERT INTO ICClassCheckRecords200000004
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCheckLevel,FCheckLevelTo,FMode,
FCheckMan=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan  ))  ,
FCheckIdea,	FCheckDate,	FDescriptions
FROM CON11.AIS_YXSP2.dbo.ICClassCheckRecords200000004 t WHERE FBillID=@FID


--������˱� ICClassCheckStatus200000004
DELETE FROM ICClassCheckStatus200000004 WHERE FBillID=@FID
INSERT ICClassCheckStatus200000004(FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,FCheckMan1,FCheckIdea1,FCheckDate1)
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,
FCheckMan1=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan1  ))  ,
FCheckIdea1,FCheckDate1 FROM CON11.AIS_YXSP2.dbo.ICClassCheckStatus200000004 t WHERE FBillID= @FID


SELECT @ZID=@ZID+1 --��������1
PRINT @ZID


END --ѭ������




                                            
