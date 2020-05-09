
declare @strDate1 varchar(20) = '2017-07-01'
declare @strDate2 varchar(20) = '2017-07-31'

declare @startDate datetime = CONVERT(datetime,@strDate1,120);
declare @endDate   datetime = CONVERT(datetime,@strDate2,120);

select t2.*
	   ,LEFT(t3.FNumber,8)  AS 客户代码
	   /*,CASE WHEN CHARINDEX('（', t3.FName) > 0  
	    THEN SUBSTRING(t3.FName, 1, CHARINDEX('（',t3.FName)-1)
	    ELSE t3.FName END	AS 客户名称
	   ,t4.FNumber			AS 部门代码*/
from ICStockBill			as t1
inner join ICStockBillEntry as t2 on t1.finterid  = t2.finterid
inner join t_Organization   as t3 on t1.FSupplyID = t3.FItemID
inner join t_Department     as t4 on t1.FDeptID   = t4.FItemID
where t1.FDate between @startDate and @endDate 
	  and t3.fname not like '%银祥%' 
	  and t4.FNumber = '10.16'
	  AND t1.fcancellation='0'



