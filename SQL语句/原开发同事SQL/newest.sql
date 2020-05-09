DROP table #t ;

--销量前十名客户明细(按部门日期排序)
DECLARE @startDate VARCHAR(20) = '2017-07-01'; --开始日期
DECLARE @endDate VARCHAR(20) = '2017-07-31';   --结束日期
DECLARE @depNum   VARCHAR(20) = '10.16' --部门代码:10.12;白条批发部:10.13;加盟开发部:10.14;冻品销售部:10.15;厦门办事处:10.16	福州办事处 10.17	驻外办事处
DEClARE @name	  VARCHAR(50);
DEClARE @flaot	  VARCHAR(50);

SELECT * INTO #t FROM (
SELECT TOP 10
	   @name AS 客户
	  ,LEFT(t3.FNumber,8)							AS 客户代码
	  ,SUM(t2.FAuxQtyInvoice)						AS [销量（吨）]
	  --,SUM(t2.FAuxQty) - SUM(t2.FEntrySelfB0167)	AS [销量（吨）]
	  --,SUM(t2.FEntrySelfB0167)					AS 损耗 
	  ,SUM(t2.FConsignAmount)/10000					AS [金额（万元）]
	  ,SUM(t2.FConsignAmount)/1.11/10000			AS [收入（万元）]
	  ,@flaot										AS 折扣
	  ,SUM(t2.FAuxQtyInvoice * t2.FPrice)/10000 	AS [成本（万元）]
FROM  ICStockBill			AS t1
INNER JOIN ICStockBillEntry AS t2 ON t1.FInterID  = t2.FInterID
INNER JOIN t_Organization   AS t3 ON t1.FSupplyID = t3.FItemID
INNER JOIN t_Department     AS t4 ON t1.FDeptID   = t4.FItemID
WHERE t1.FDate BETWEEN @startDate AND @endDate 
	  AND t3.FName NOT LIKE '%银祥%'
	  AND t4.FNumber = @depNum
	  AND t3.FNumber NOT LIKE 'X%'
	  AND t1.FCancellation = 0
	  AND t1.FCheckerID > 0
	  AND t1.FTranType = 21
GROUP BY LEFT(t3.fnumber,8)
ORDER BY [销量（吨）] DESC
) AS T;

--修改#t表结构，新增列
ALTER TABLE #t ADD 损耗成本				FLOAT;  
ALTER TABLE #t ADD [毛利（万元）]		FLOAT;
ALTER TABLE #t ADD 毛利率				varchar(50);   
ALTER TABLE #t ADD [吨均毛利（元/吨）]	FLOAT;

--计算折扣
UPDATE #t SET #t.折扣 = N.折扣 FROM (
SELECT LEFT(g.fnumber,8) AS 客户代码,ABS(SUM(v.famount)/10000) AS 折扣 FROM t_RP_ARPBill AS b
INNER  JOIN AIS_YXRY2.dbo.t_RP_ARPBillEntry v ON   v.FBillID   = b.FBillID
INNER  JOIN AIS_YXRY2.dbo.t_Organization g    ON   b.FCustomer = g.FItemID
where b.FDate between @startDate AND @endDate 
	  AND b.frp=1 AND b.FRP = 1 
	  AND b.FBase IN  (SELECT FItemID FROM AIS_YXRY2.dbo.t_Item WHERE FItemClassID=3002 AND fname='折扣')
GROUP BY LEFT(g.fnumber,8)
) AS N
WHERE #t.客户代码 = N.客户代码

--计算损耗成本
UPDATE #t SET #t.损耗成本 = N.损耗成本 FROM (
select SUM(t2.FAmount)/10000 AS 损耗成本 
	  ,LEFT(t3.FNumber,8)	 AS 客户代码
FROM ICStockBill			 AS t1
INNER JOIN ICStockBillEntry  AS t2 ON t1.FInterID 	    = t2.FInterID
INNER JOIN t_Organization    AS t3 ON t1.FSupplyID	    = t3.FItemID
INNER JOIN t_Department      AS t4 ON t1.FDeptID  		= t4.FItemID
INNER JOIN #t				 AS t5 ON LEFT(t3.FNumber,8) = t5.客户代码
WHERE t1.FDate BETWEEN @startDate AND @endDate 
	  AND t3.FName not like '%银祥%'
	  AND t4.FNumber = @depNum
	  AND t1.FCancellation = 0
	  AND t1.FTranType = 29
	  AND t3.FNumber NOT LIKE 'X%'
	  AND t1.FCheckerID > 0
GROUP BY LEFT(t3.fnumber,8)
) AS N
WHERE #t.客户代码 = N.客户代码

--获取客户名称
UPDATE #t SET 客户 = 
	   (SELECT TOP 1 
	   CASE WHEN CHARINDEX('（', t.FName) > 0  
	   THEN SUBSTRING(t.FName, 1, CHARINDEX('（',t.FName)-1)
	   ELSE t.FName END
	   FROM t_Organization AS t WHERE t.FNumber like [#t].[客户代码]+'%');
	   
--计算销量，毛利，毛利率，吨均毛利
UPDATE #t SET [销量（吨）]		  = [销量（吨）] / 1000;
UPDATE #t SET [毛利（万元）]	  = ([收入（万元）] - ISNULL(折扣,0) - [成本（万元）] - ISNULL(损耗成本,0));
UPDATE #t SET 毛利率			  = CONVERT(varchar(20),CONVERT(decimal(20,2),[毛利（万元）] / ([收入（万元）] - ISNULL(折扣,0)) * 100)) + '%';
UPDATE #t SET [吨均毛利（元/吨）] = [毛利（万元）] / [销量（吨）] * 10000;

SELECT [客户],[客户代码],[销量（吨）],[金额（万元）],[收入（万元）],[折扣],[成本（万元）],[损耗成本],[毛利（万元）],[毛利率],[吨均毛利（元/吨）] FROM #t

