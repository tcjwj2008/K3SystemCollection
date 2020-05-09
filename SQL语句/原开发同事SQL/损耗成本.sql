declare @strDate1 varchar(20) = '2017-07-01'
declare @strDate2 varchar(20) = '2017-07-31'

declare @startDate datetime = CONVERT(datetime,@strDate1,120);
declare @endDate   datetime = CONVERT(datetime,@strDate2,120);

SELECT 
	   sum(t2.famount)
FROM ICStockBill			AS t1
INNER JOIN ICStockBillEntry AS t2 ON t1.FInterID  = t2.FInterID
INNER JOIN t_Organization   AS t3 ON t1.FSupplyID = t3.FItemID
INNER JOIN t_Department     AS t4 ON t1.FDeptID   = t4.FItemID
WHERE t1.FDate BETWEEN @startDate AND @endDate 
	  AND t3.FName not like '%ÒøÏé%'
	  AND t4.FNumber = '10.16'
	  AND t1.FCancellation='0'
	  AND t1.FTranType = 29
	  AND t3.FNumber like '02.0042%'
group by LEFT(t3.fnumber,8)


