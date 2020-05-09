DROP table #t ;

DECLARE @strDate1 VARCHAR(20) = '2017-07-01';
DECLARE @strDate2 VARCHAR(20) = '2017-07-31';
DEClARE @name	  VARCHAR(50);
DEClARE @flaot	  VARCHAR(50);

DECLARE @startDate DATETIME = CONVERT(DATETIME,@strDate1,120);
DECLARE @endDate   DATETIME = CONVERT(DATETIME,@strDate2,120);
SELECT * INTO #t FROM (
SELECT TOP 10
	   @name AS 客户
	  ,LEFT(t3.FNumber,8)							AS 客户代码
	  --,SUM(t2.FAuxQty) - SUM(t2.FEntrySelfB0167)	AS [销量（吨）]
	  ,SUM(t2.FAuxQtyInvoice)						AS [销量（吨）]
	  --,SUM(t2.FEntrySelfB0167)					AS 损耗 
	  ,SUM(t2.FConsignAmount)/10000					AS [金额（万元）]
	  ,SUM(t2.FConsignAmount)/1.11/10000			AS [收入（万元）]
	  ,@flaot										AS 折扣
	  ,SUM(t2.FAuxQtyInvoice * t2.FPrice)/10000 	AS [成本（万元）]
	  /*,SUM(t2.FConsignAmount)/1.11 - SUM(CONVERT(decimal(18,2),t2.FAuxQtyInvoice * t2.FPrice))		AS 毛利
	  ,SUM(t2.FConsignAmount)/1.11 - SUM(CONVERT(decimal(18,2),t2.FAuxQtyInvoice * t2.FPrice)) / (SUM(t2.FConsignAmount)/1.11) AS 毛利率
	  ,SUM(t2.FQtyInvoice)								AS 含税je2
	  ,LEFT(t3.FNumber,8)							AS 客户代码
	  ,CASE WHEN CHARINDEX('（', t3.FName) > 0  
	   THEN SUBSTRING(t3.FName, 1, CHARINDEX('（',t3.FName)-1)
	   ELSE t3.FName END							AS 客户名称
	  ,t4.FNumber									AS 部门代码*/
FROM ICStockBill			AS t1
INNER JOIN ICStockBillEntry AS t2 ON t1.FInterID  = t2.FInterID
INNER JOIN t_Organization   AS t3 ON t1.FSupplyID = t3.FItemID
INNER JOIN t_Department     AS t4 ON t1.FDeptID   = t4.FItemID
WHERE t1.FDate BETWEEN @startDate AND @endDate 
	  AND t3.FName not like '%银祥%'
	  AND t4.FNumber = '10.16'
	  AND t1.FCancellation='0'
GROUP BY LEFT(t3.fnumber,8)
		,t1.FTranType
		 /*,CASE WHEN CHARINDEX('（',t3.FName) > 0 THEN  
	     SUBSTRING(t3.FName,1,CHARINDEX('（',t3.FName)-1)
	     ELSE t3.FName END
	     ,t4.FNumber*/
ORDER BY [销量（吨）] DESC
) AS T;

ALTER TABLE #t ADD 损耗成本				FLOAT;  
ALTER TABLE #t ADD [毛利（万元）]		FLOAT;
ALTER TABLE #t ADD 毛利率				varchar(50);   
ALTER TABLE #t ADD [吨均毛利（元/吨）]	FLOAT;


UPDATE #t SET 客户 = 
	   (SELECT TOP 1 
	   CASE WHEN CHARINDEX('（', t.FName) > 0  
	   THEN SUBSTRING(t.FName, 1, CHARINDEX('（',t.FName)-1)
	   ELSE t.FName END
	   FROM t_Organization AS t WHERE t.FNumber like [#t].[客户代码]+'%');
UPDATE #t SET [销量（吨）]		  = [销量（吨）] / 1000;
UPDATE #t SET [毛利（万元）]	  = ([收入（万元）] - ISNULL(折扣,0) - [成本（万元）] - ISNULL(损耗成本,0));
UPDATE #t SET 毛利率			  = CONVERT(varchar(20),CONVERT(decimal(20,2),[毛利（万元）] / ([收入（万元）] - ISNULL(折扣,0)) * 100)) + '%';
UPDATE #t SET [吨均毛利（元/吨）] = [毛利（万元）] / [销量（吨）] * 10000;

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
INNER JOIN #t				AS t5 ON LEFT(t3.FNumber,8) = t5.客户代码
WHERE t1.FDate BETWEEN @startDate AND @endDate 
	  AND t3.FName not like '%银祥%'
	  AND t4.FNumber = '10.16'
	 -- AND t1.FCancellation = '0'
	  AND t1.FTranType = 29
	  AND t3.FNumber NOT LIKE 'X%'
GROUP BY LEFT(t3.fnumber,8)

--SELECT [客户],[客户代码],[销量（吨）],[金额（万元）],[收入（万元）],[折扣],[成本（万元）],[损耗成本],[毛利（万元）],[毛利率],[吨均毛利（元/吨）] FROM #t





