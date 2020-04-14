--DROP TABLE #t_SubCustomSell

--����ʽ���׶�ȡ��������д����ʱ�� #t_SubCustomSell
SELECT * INTO #t_SubCustomSell 
FROM CON11.AIS_YXSP2.dbo.t_SubCustomSell 
WHERE FDate >='2018-06-01' AND FDate <'2018-07-01'  
ORDER BY FDate


--��������Ѵ���Ŀ�����ף�����ͬ��,��ʼʱ���2018-06-01��ʼ
DELETE FROM #t_SubCustomSell WHERE FBillNo IN(SELECT FBillNo FROM t_SubCustomSell WHERE FDate >='2018-06-01' ) 
 

--��ʱ�������ֶ� FZID 
ALTER TABLE #t_SubCustomSell ADD FZID INT IDENTITY(1,1)

--SELECT * FROM #t_SubCustomSell


--���ݰ���������ѭ����ȡ

DECLARE @ZID INT  --��������־
SELECT @ZID=1

DECLARE @CountNum INT --��ʱ������������
SELECT  @CountNum=COUNT(*) FROM #t_SubCustomSell


DECLARE  @FID INT --��������

WHILE(@ZID<=@CountNum)
BEGIN --ѭ����ʼ

--1д���������� T_SubRKD
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


--2д���¼����(�������) t_SubCustomSellMX
INSERT INTO t_SubCustomSellMX
SELECT FID,FIndex,
FSCSMXRY=(select FItemID from t_Emp WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Emp WHERE FItemID=t.FSCSMXRY  ))  ,--����Ա
FSCSMXYesDayAmount,FSCSMXYPrintAmount,FSCSMXNPrintAmount,FSCSMXExAmount,FSCSMXBlAmount,
FSCSMXCashAmount,FSCSMXSaleAmount,FSCSMXSumAmount,FSCSMXRetAmount,FSCSMXBankAmount,FSCSMXProAmount,
FSCSMXLeavAmount,FSubDBCKAmount,FSubDBRKAmount,FSubSJAmount,FSCSMXOtherAmount 
FROM CON11.AIS_YXSP2.dbo.t_SubCustomSellMX t where FID=@FID 

--3д���¼����(�������) t_SubCustomSaleMX
INSERT INTO t_SubCustomSaleMX
SELECT FID,FIndex,
FSCSaleCustomid=( select FItemID from dbo.t_Organization WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Organization WHERE FItemID=t.FSCSaleCustomid  ))  ,   --�ͻ�����
FSCSaleItemID=( select FItemID from dbo.t_ICItem WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_ICItem WHERE FItemID=t.FSCSaleItemID  ))  ,	    --��������
FSCSaleQty,FSCSalePrice,FSCSaleAmount,FSubYSQty,FSubLoseQty,FNOTE,FNOTE2
FROM CON11.AIS_YXSP2.dbo.t_SubCustomSaleMX t where FID=@FID 		


--4д���¼����(�ؿ����) t_SubCustomRetMX
INSERT INTO  t_SubCustomRetMX
SELECT FID,	FIndex,	
FSCRetCustomID=( select FItemID from dbo.t_Organization WHERE FNumber=(SELECT FNumber  FROM CON11.AIS_YXSP2.dbo.t_Organization WHERE FItemID=t.FSCRetCustomID  ))  ,   --�ͻ�����	
FSCRetAmount,FNOTE3 
FROM CON11.AIS_YXSP2.dbo.t_SubCustomRetMX t where FID=@FID 


--�����¼�� ICClassCheckRecords200000003
DELETE FROM ICClassCheckRecords200000003 WHERE FBillID=@FID
INSERT INTO ICClassCheckRecords200000003
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCheckLevel,FCheckLevelTo,FMode,
FCheckMan=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan  ))  ,
FCheckIdea,	FCheckDate,	FDescriptions
FROM CON11.AIS_YXSP2.dbo.ICClassCheckRecords200000003 t WHERE FBillID=@FID


--������˱� ICClassCheckStatus200000003
DELETE FROM ICClassCheckStatus200000003 WHERE FBillID=@FID
INSERT ICClassCheckStatus200000003(FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,FCheckMan1,FCheckIdea1,FCheckDate1)
SELECT FPage,FBillID,FBillEntryID,FBillNo,FBillEntryIndex,FCurrentLevel,
FCheckMan1=(select FUserID from t_User WHERE FName=(SELECT FName  FROM CON11.AIS_YXSP2.dbo.t_User WHERE FUserID=t.FCheckMan1  ))  ,
FCheckIdea1,FCheckDate1 FROM CON11.AIS_YXSP2.dbo.ICClassCheckStatus200000003 t WHERE FBillID= @FID


SELECT @ZID=@ZID+1 --��������1
PRINT @ZID


END --ѭ������




                                            
