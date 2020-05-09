--����ǰʮ���ͻ�ͳ��

ALTER PROC sp_CustSaleTop10_czq
(
@FBeginDate varchar(20), --��ʼʱ��
@FEndDate varchar(20),   --����ʱ��
@FDepart varchar(20)     --���Ŵ���
)


AS

--��ʱ��ȡ���пͻ����


declare @FBeginDate varchar(20) = '2017-07-01'; --��ʼʱ��
declare @FEndDate varchar(20) = '2017-07-31';   --����ʱ��
declare @FDepart varchar(20) = '10.16';			--���Ŵ���

SELECT * INTO #c FROM(
SELECT FNumber, REPLACE(FName,'[����]','') FName FROM AIS_YXRY2.dbo.t_Item WHERE FItemClassID=1 AND FDetail=0 AND SUBSTRING(FNumber,1,1)<>'X'
UNION
SELECT FNumber, REPLACE(FName,'[����]','') FName FROM AIS_YXSP2.dbo.t_Item WHERE FItemClassID=1 AND FDetail=0 AND SUBSTRING(FNumber,1,1)<>'X'
)c

--���Ŵ��룺 10.12	����������  10.13	���˿�����  10.14	��Ʒ���۲�  10.15	���Ű��´�  10.16	���ݰ��´� 10.17	פ����´�

--1ȡ��ҵ
SELECT g.FNumber,g.FName,
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
SUM(FAuxQty) SumFAuxQty  ,SUM(FConsignAmount) SumFConsignAmount, '��ҵ'��� INTO #t FROM AIS_YXRY2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXRY2.dbo.ICStockBill b ON v.FInterID=b.FInterID
INNER JOIN AIS_YXRY2.dbo.t_Organization g ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXRY2.dbo.t_Department d ON b.FDeptID=d.FItemID
WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=21
AND d.FNumber=@FDepart
GROUP BY  g.FNumber,g.FName

--2ȡʳƷ
INSERT INTO #t
SELECT g.FNumber,g.FName,
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
SUM(FAuxQty) SumFAuxQty ,SUM(FConsignAmount) SumFConsignAmount,'ʳƷ'��� FROM AIS_YXSP2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXSP2.dbo.ICStockBill b ON v.FInterID=b.FInterID
INNER JOIN AIS_YXSP2.dbo.t_Organization g ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXSP2.dbo.t_Department d ON b.FDeptID=d.FItemID
WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=21
AND d.FNumber=@FDepart
GROUP BY  g.FNumber,g.FName

--SELECT * FROM #t


--ȡǰ10������
SELECT TOP 10 ParentNum, SUM(SumFAuxQty)SumFAuxQty,SUM(SumFConsignAmount) SumFConsignAmount INTO #tResult FROM #t t
GROUP BY ParentNum ORDER BY SumFAuxQty DESC

--�����ۿ� ��ʱ�� #t2
ALTER TABLE #tResult ADD �ۿ� FLOAT

--�ۿ�(������-Ӧ���˿�-����Ӧ�յ� ���)
SELECT CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
SUM(SumFamount) SumFamount INTO #t2 FROM (
SELECT g.fnumber,SUM(v.famount) SumFamount FROM AIS_YXRY2.dbo.t_RP_ARPBill b
INNER JOIN AIS_YXRY2.dbo.t_RP_ARPBillEntry v ON v.FBillID = b.FBillID
INNER JOIN AIS_YXRY2.dbo.t_Organization g ON b.FCustomer=g.FItemID
WHERE b.frp=1 AND b.FDate>=@FBeginDate AND b.FDate<=@FEndDate AND b.FChecker >0
AND b.FBase IN( SELECT FItemID FROM AIS_YXRY2.dbo.t_Item WHERE FItemClassID=3002 AND fname='�ۿ�'  )
GROUP BY g.fnumber

UNION ALL

SELECT g.fnumber,SUM(v.famount) SumFamount FROM AIS_YXSP2.dbo.t_RP_ARPBill b
INNER JOIN AIS_YXSP2.dbo.t_RP_ARPBillEntry v ON v.FBillID = b.FBillID
INNER JOIN AIS_YXSP2.dbo.t_Organization g ON b.FCustomer=g.FItemID
WHERE b.frp=1 AND b.FDate>=@FBeginDate AND b.FDate<=@FEndDate AND b.FChecker >0
AND b.Fdisctype IN( SELECT FItemID FROM AIS_YXSP2.dbo.t_Item WHERE FItemClassID=3003 AND fname='�ۿ�'  )
GROUP BY  g.fnumber

)g
GROUP BY CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END


UPDATE t SET t.�ۿ�=abs(c.SumFamount/1.11) FROM #tResult t
INNER JOIN #t2 c ON t.ParentNum=c.ParentNum

--����ɱ� ��ʱ�� #t3
ALTER TABLE #tResult ADD �ɱ� FLOAT

IF(@FDepart='10.12' OR @FDepart='10.13')
BEGIN --����Ϊ '10.12' '10.13'
SELECT SUM(FAuxQty *ISNULL(Fprice,0)) �ɱ�,ParentNum INTO #t3 FROM (
--1ȡ��ҵ
SELECT b.fdate,
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
FAuxQty ,p.Fprice, c.FNumber   FROM AIS_YXRY2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXRY2.dbo.ICStockBill b ON v.FInterID=b.FInterID
INNER JOIN AIS_YXRY2.dbo.t_ICItem c ON v.FItemID=c.FItemID
INNER JOIN AIS_YXRY2.dbo.t_Organization g ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXRY2.dbo.t_Department d ON b.FDeptID=d.FItemID
LEFT JOIN YXERP.dbo.yx_rs_ysprice p ON b.fdate=p.fdate AND p.Fnumber = c.FNumber
WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=21
AND d.FNumber=@FDepart
AND CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END IN(SELECT ParentNum FROM #tResult)

--2ȡʳƷ
UNION ALL

SELECT b.fdate,
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
FAuxQty ,p.Fprice, c.FNumber   FROM AIS_YXSP2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXSP2.dbo.ICStockBill b ON v.FInterID=b.FInterID
INNER JOIN AIS_YXSP2.dbo.t_ICItem c ON v.FItemID=c.FItemID
INNER JOIN AIS_YXSP2.dbo.t_Organization g ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXSP2.dbo.t_Department d ON b.FDeptID=d.FItemID
LEFT JOIN YXERP.dbo.yx_rs_ysprice p ON b.fdate=p.fdate AND p.Fnumber = c.FNumber
WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=21
AND d.FNumber=@FDepart
AND CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END IN(SELECT ParentNum FROM #tResult)
)G GROUP BY ParentNum

UPDATE t SET t.�ɱ�=c.�ɱ� FROM #tResult t
INNER JOIN #t3 c ON t.ParentNum=c.ParentNum
END  --����Ϊ '10.12' '10.13'
ELSE
BEGIN --��������

SELECT SUM(FAuxQty *ISNULL(FAuxPrice,0)) �ɱ�,ParentNum INTO #t33 FROM (
--1ȡ��ҵ
SELECT b.fdate,
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
FAuxQty , FAuxPrice, c.FNumber   FROM AIS_YXRY2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXRY2.dbo.ICStockBill b ON v.FInterID=b.FInterID
INNER JOIN AIS_YXRY2.dbo.t_ICItem c ON v.FItemID=c.FItemID
INNER JOIN AIS_YXRY2.dbo.t_Organization g ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXRY2.dbo.t_Department d ON b.FDeptID=d.FItemID

WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=21
AND d.FNumber=@FDepart
AND CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END IN(SELECT ParentNum FROM #tResult)

--2ȡʳƷ
UNION ALL

SELECT b.fdate,
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
FAuxQty ,FAuxPrice, c.FNumber   FROM AIS_YXSP2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXSP2.dbo.ICStockBill b ON v.FInterID=b.FInterID
INNER JOIN AIS_YXSP2.dbo.t_ICItem c ON v.FItemID=c.FItemID
INNER JOIN AIS_YXSP2.dbo.t_Organization g ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXSP2.dbo.t_Department d ON b.FDeptID=d.FItemID

WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=21
AND d.FNumber=@FDepart
AND CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END IN(SELECT ParentNum FROM #tResult)
)G GROUP BY ParentNum

UPDATE t SET t.�ɱ�=c.�ɱ� FROM #tResult t
INNER JOIN #t33 c ON t.ParentNum=c.ParentNum


END   --��������

--������ĳɱ� ��ʱ�� #t4
ALTER TABLE #tResult ADD ��ĳɱ� FLOAT

--ʳƷ��������ҵ����-��Ӧ��-�ִ����-���Ϸ���-�������� FTranType=29

SELECT SUM(FConsignAmount) ��ĳɱ�,ParentNum INTO #t4 FROM (
--1ȡ��ҵ
SELECT
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
FConsignAmount   FROM AIS_YXRY2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXRY2.dbo.ICStockBill b		ON v.FInterID=b.FInterID
INNER JOIN AIS_YXRY2.dbo.t_ICItem c			ON v.FItemID=c.FItemID
INNER JOIN AIS_YXRY2.dbo.t_Organization g	ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXRY2.dbo.t_Department d ON b.FDeptID=d.FItemID
WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=29
AND d.FNumber=@FDepart
AND CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END IN(SELECT ParentNum FROM #tResult)

--2ȡʳƷ
UNION ALL

SELECT
CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END ParentNum,
FConsignAmount   FROM AIS_YXSP2.dbo.ICStockBillEntry  v
INNER JOIN AIS_YXSP2.dbo.ICStockBill b		ON v.FInterID=b.FInterID
INNER JOIN AIS_YXSP2.dbo.t_ICItem c			ON v.FItemID=c.FItemID
INNER JOIN AIS_YXSP2.dbo.t_Organization g	ON b.FSupplyID=g.FItemID AND SUBSTRING(g.FNumber,1,1)<>'X'
INNER JOIN AIS_YXSP2.dbo.t_Department d		ON b.FDeptID=d.FItemID
WHERE b.FDate >=@FBeginDate AND b.FDate <=@FEndDate AND b.FCancellation=0 AND FCheckerID>0 AND FTranType=29
AND d.FNumber=@FDepart
AND CASE when LEN(g.FNumber)-LEN(REPLACE(g.FNumber,'.',''))=1 THEN g.FNumber else SUBSTRING(g.FNumber,0,LEN(g.FNumber)-CHARINDEX('.', REVERSE(g.FNumber))+1)  END IN(SELECT ParentNum FROM #tResult)
)G GROUP BY ParentNum

UPDATE t SET t.��ĳɱ�=c.��ĳɱ� FROM #tResult t
INNER JOIN #t4 c ON t.ParentNum=c.ParentNum


--����޸�����
ALTER TABLE #tResult ADD FName VARCHAR(50)

UPDATE t SET t.FName=c.FName FROM #tResult t
INNER JOIN #c c ON t.ParentNum=c.FNumber

UPDATE t SET t.FName=c.FName FROM #tResult t
INNER JOIN #t c ON t.ParentNum=c.FNumber
WHERE t.FName IS NULL


--��ѯ���

ALTER TABLE #tResult ADD ���� INT IDENTITY(1,1)

ALTER TABLE #tResult ADD ë�� FLOAT

ALTER TABLE #tResult ADD ë���� FLOAT
ALTER TABLE #tResult ADD �־�ë�� FLOAT

UPDATE #tResult SET ë��=(SumFConsignAmount/1.11)-ISNULL(�ۿ�,0)-ISNULL(�ɱ�,0)-ISNULL(��ĳɱ�,0)

UPDATE #tResult SET ë����=((SumFConsignAmount/1.11)-ISNULL(�ۿ�,0)-ISNULL(�ɱ�,0)-ISNULL(��ĳɱ�,0))/((SumFConsignAmount/1.11)-ISNULL(�ۿ�,0))

UPDATE #tResult set �־�ë��=ë��/SumFAuxQty


SELECT ����, FName �ͻ�, ROUND(SumFAuxQty/1000,2) [����(��)],
ROUND(SumFConsignAmount/10000,2) [���(��)],
ROUND(SumFConsignAmount/(1.11* 10000),2) [����(��)],
ROUND(�ۿ�/(10000),2) [�ۿ�(��)],
ROUND(�ɱ�/(10000),2) [�ɱ�(��)],
ROUND(��ĳɱ�/(10000),2) [��ĳɱ�(��)],
ROUND(ë��/(10000),2) [ë��(��)],
CAST(ROUND(ë����*100,2) AS varchar)+'%' ë����,
ROUND(�־�ë��*1000,2) �־�ë��



FROM #tResult