DROP table #t ;

--����ǰʮ���ͻ���ϸ(��������������)
DECLARE @startDate VARCHAR(20) = '2017-07-01'; --��ʼ����
DECLARE @endDate VARCHAR(20) = '2017-07-31';   --��������
DECLARE @depNum   VARCHAR(20) = '10.16' --���Ŵ���:10.12;����������:10.13;���˿�����:10.14;��Ʒ���۲�:10.15;���Ű��´�:10.16	���ݰ��´� 10.17	פ����´�
DEClARE @name	  VARCHAR(50);
DEClARE @flaot	  VARCHAR(50);

SELECT * INTO #t FROM (
SELECT TOP 10
	   @name AS �ͻ�
	  ,LEFT(t3.FNumber,8)							AS �ͻ�����
	  ,SUM(t2.FAuxQtyInvoice)						AS [�������֣�]
	  --,SUM(t2.FAuxQty) - SUM(t2.FEntrySelfB0167)	AS [�������֣�]
	  --,SUM(t2.FEntrySelfB0167)					AS ��� 
	  ,SUM(t2.FConsignAmount)/10000					AS [����Ԫ��]
	  ,SUM(t2.FConsignAmount)/1.11/10000			AS [���루��Ԫ��]
	  ,@flaot										AS �ۿ�
	  ,SUM(t2.FAuxQtyInvoice * t2.FPrice)/10000 	AS [�ɱ�����Ԫ��]
FROM  ICStockBill			AS t1
INNER JOIN ICStockBillEntry AS t2 ON t1.FInterID  = t2.FInterID
INNER JOIN t_Organization   AS t3 ON t1.FSupplyID = t3.FItemID
INNER JOIN t_Department     AS t4 ON t1.FDeptID   = t4.FItemID
WHERE t1.FDate BETWEEN @startDate AND @endDate 
	  AND t3.FName NOT LIKE '%����%'
	  AND t4.FNumber = @depNum
	  AND t3.FNumber NOT LIKE 'X%'
	  AND t1.FCancellation = 0
	  AND t1.FCheckerID > 0
	  AND t1.FTranType = 21
GROUP BY LEFT(t3.fnumber,8)
ORDER BY [�������֣�] DESC
) AS T;

--�޸�#t��ṹ��������
ALTER TABLE #t ADD ��ĳɱ�				FLOAT;  
ALTER TABLE #t ADD [ë������Ԫ��]		FLOAT;
ALTER TABLE #t ADD ë����				varchar(50);   
ALTER TABLE #t ADD [�־�ë����Ԫ/�֣�]	FLOAT;

--�����ۿ�
UPDATE #t SET #t.�ۿ� = N.�ۿ� FROM (
SELECT LEFT(g.fnumber,8) AS �ͻ�����,ABS(SUM(v.famount)/10000) AS �ۿ� FROM t_RP_ARPBill AS b
INNER  JOIN AIS_YXRY2.dbo.t_RP_ARPBillEntry v ON   v.FBillID   = b.FBillID
INNER  JOIN AIS_YXRY2.dbo.t_Organization g    ON   b.FCustomer = g.FItemID
where b.FDate between @startDate AND @endDate 
	  AND b.frp=1 AND b.FRP = 1 
	  AND b.FBase IN  (SELECT FItemID FROM AIS_YXRY2.dbo.t_Item WHERE FItemClassID=3002 AND fname='�ۿ�')
GROUP BY LEFT(g.fnumber,8)
) AS N
WHERE #t.�ͻ����� = N.�ͻ�����

--������ĳɱ�
UPDATE #t SET #t.��ĳɱ� = N.��ĳɱ� FROM (
select SUM(t2.FAmount)/10000 AS ��ĳɱ� 
	  ,LEFT(t3.FNumber,8)	 AS �ͻ�����
FROM ICStockBill			 AS t1
INNER JOIN ICStockBillEntry  AS t2 ON t1.FInterID 	    = t2.FInterID
INNER JOIN t_Organization    AS t3 ON t1.FSupplyID	    = t3.FItemID
INNER JOIN t_Department      AS t4 ON t1.FDeptID  		= t4.FItemID
INNER JOIN #t				 AS t5 ON LEFT(t3.FNumber,8) = t5.�ͻ�����
WHERE t1.FDate BETWEEN @startDate AND @endDate 
	  AND t3.FName not like '%����%'
	  AND t4.FNumber = @depNum
	  AND t1.FCancellation = 0
	  AND t1.FTranType = 29
	  AND t3.FNumber NOT LIKE 'X%'
	  AND t1.FCheckerID > 0
GROUP BY LEFT(t3.fnumber,8)
) AS N
WHERE #t.�ͻ����� = N.�ͻ�����

--��ȡ�ͻ�����
UPDATE #t SET �ͻ� = 
	   (SELECT TOP 1 
	   CASE WHEN CHARINDEX('��', t.FName) > 0  
	   THEN SUBSTRING(t.FName, 1, CHARINDEX('��',t.FName)-1)
	   ELSE t.FName END
	   FROM t_Organization AS t WHERE t.FNumber like [#t].[�ͻ�����]+'%');
	   
--����������ë����ë���ʣ��־�ë��
UPDATE #t SET [�������֣�]		  = [�������֣�] / 1000;
UPDATE #t SET [ë������Ԫ��]	  = ([���루��Ԫ��] - ISNULL(�ۿ�,0) - [�ɱ�����Ԫ��] - ISNULL(��ĳɱ�,0));
UPDATE #t SET ë����			  = CONVERT(varchar(20),CONVERT(decimal(20,2),[ë������Ԫ��] / ([���루��Ԫ��] - ISNULL(�ۿ�,0)) * 100)) + '%';
UPDATE #t SET [�־�ë����Ԫ/�֣�] = [ë������Ԫ��] / [�������֣�] * 10000;

SELECT [�ͻ�],[�ͻ�����],[�������֣�],[����Ԫ��],[���루��Ԫ��],[�ۿ�],[�ɱ�����Ԫ��],[��ĳɱ�],[ë������Ԫ��],[ë����],[�־�ë����Ԫ/�֣�] FROM #t

