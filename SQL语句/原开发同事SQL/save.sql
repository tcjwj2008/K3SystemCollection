DROP table #t ;

DECLARE @strDate1 VARCHAR(20) = '2017-07-01';
DECLARE @strDate2 VARCHAR(20) = '2017-07-31';
DEClARE @name	  VARCHAR(50);
DEClARE @flaot	  VARCHAR(50);

DECLARE @startDate DATETIME = CONVERT(DATETIME,@strDate1,120);
DECLARE @endDate   DATETIME = CONVERT(DATETIME,@strDate2,120);
SELECT * INTO #t FROM (
SELECT TOP 10
	   @name AS �ͻ�
	  ,LEFT(t3.FNumber,8)							AS �ͻ�����
	  --,SUM(t2.FAuxQty) - SUM(t2.FEntrySelfB0167)	AS [�������֣�]
	  ,SUM(t2.FAuxQtyInvoice)						AS [�������֣�]
	  --,SUM(t2.FEntrySelfB0167)					AS ��� 
	  ,SUM(t2.FConsignAmount)/10000					AS [����Ԫ��]
	  ,SUM(t2.FConsignAmount)/1.11/10000			AS [���루��Ԫ��]
	  ,@flaot										AS �ۿ�
	  ,SUM(t2.FAuxQtyInvoice * t2.FPrice)/10000 	AS [�ɱ�����Ԫ��]
	  /*,SUM(t2.FConsignAmount)/1.11 - SUM(CONVERT(decimal(18,2),t2.FAuxQtyInvoice * t2.FPrice))		AS ë��
	  ,SUM(t2.FConsignAmount)/1.11 - SUM(CONVERT(decimal(18,2),t2.FAuxQtyInvoice * t2.FPrice)) / (SUM(t2.FConsignAmount)/1.11) AS ë����
	  ,SUM(t2.FQtyInvoice)								AS ��˰je2
	  ,LEFT(t3.FNumber,8)							AS �ͻ�����
	  ,CASE WHEN CHARINDEX('��', t3.FName) > 0  
	   THEN SUBSTRING(t3.FName, 1, CHARINDEX('��',t3.FName)-1)
	   ELSE t3.FName END							AS �ͻ�����
	  ,t4.FNumber									AS ���Ŵ���*/
FROM ICStockBill			AS t1
INNER JOIN ICStockBillEntry AS t2 ON t1.FInterID  = t2.FInterID
INNER JOIN t_Organization   AS t3 ON t1.FSupplyID = t3.FItemID
INNER JOIN t_Department     AS t4 ON t1.FDeptID   = t4.FItemID
WHERE t1.FDate BETWEEN @startDate AND @endDate 
	  AND t3.FName not like '%����%'
	  AND t4.FNumber = '10.16'
	  AND t1.FCancellation='0'
GROUP BY LEFT(t3.fnumber,8)
		,t1.FTranType
		 /*,CASE WHEN CHARINDEX('��',t3.FName) > 0 THEN  
	     SUBSTRING(t3.FName,1,CHARINDEX('��',t3.FName)-1)
	     ELSE t3.FName END
	     ,t4.FNumber*/
ORDER BY [�������֣�] DESC
) AS T;

ALTER TABLE #t ADD ��ĳɱ�				FLOAT;  
ALTER TABLE #t ADD [ë������Ԫ��]		FLOAT;
ALTER TABLE #t ADD ë����				varchar(50);   
ALTER TABLE #t ADD [�־�ë����Ԫ/�֣�]	FLOAT;


UPDATE #t SET �ͻ� = 
	   (SELECT TOP 1 
	   CASE WHEN CHARINDEX('��', t.FName) > 0  
	   THEN SUBSTRING(t.FName, 1, CHARINDEX('��',t.FName)-1)
	   ELSE t.FName END
	   FROM t_Organization AS t WHERE t.FNumber like [#t].[�ͻ�����]+'%');
UPDATE #t SET [�������֣�]		  = [�������֣�] / 1000;
UPDATE #t SET [ë������Ԫ��]	  = ([���루��Ԫ��] - ISNULL(�ۿ�,0) - [�ɱ�����Ԫ��] - ISNULL(��ĳɱ�,0));
UPDATE #t SET ë����			  = CONVERT(varchar(20),CONVERT(decimal(20,2),[ë������Ԫ��] / ([���루��Ԫ��] - ISNULL(�ۿ�,0)) * 100)) + '%';
UPDATE #t SET [�־�ë����Ԫ/�֣�] = [ë������Ԫ��] / [�������֣�] * 10000;

DECLARE @strDate1 VARCHAR(20) = '2017-07-01';
DECLARE @strDate2 VARCHAR(20) = '2017-07-31';

DECLARE @startDate DATETIME = CONVERT(DATETIME,@strDate1,120);
DECLARE @endDate   DATETIME = CONVERT(DATETIME,@strDate2,120);

select SUM(t2.FQty * t2.FPrice)  AS test 
		,LEFT(t3.FNumber,8) AS dm
FROM ICStockBill			AS t1
INNER JOIN ICStockBillEntry AS t2 ON t1.FInterID  = t2.FInterID
INNER JOIN t_Organization   AS t3 ON t1.FSupplyID = t3.FItemID
INNER JOIN t_Department     AS t4 ON t1.FDeptID   = t4.FItemID
INNER JOIN #t				AS t5 ON LEFT(t3.FNumber,8) = t5.�ͻ�����
WHERE t1.FDate BETWEEN @startDate AND @endDate 
	  AND t3.FName not like '%����%'
	  AND t4.FNumber = '10.16'
	 -- AND t1.FCancellation = '0'
	  AND t1.FTranType = 29
	  AND t3.FNumber NOT LIKE 'X%'
GROUP BY LEFT(t3.fnumber,8)

--SELECT [�ͻ�],[�ͻ�����],[�������֣�],[����Ԫ��],[���루��Ԫ��],[�ۿ�],[�ɱ�����Ԫ��],[��ĳɱ�],[ë������Ԫ��],[ë����],[�־�ë����Ԫ/�֣�] FROM #t





