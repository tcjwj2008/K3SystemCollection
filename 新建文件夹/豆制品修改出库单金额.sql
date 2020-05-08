--update y set y.fallamount=round(y.fauxqty*y.FAuxtaxPrice,2) from seorder t,seorderentry y ,t_icitem x 
--where t.finterid=y.finterid 
--and round(y.fauxqty*y.FAuxtaxPrice,2)<>y.fallamount 
--and t.fdate>='2019-07-30' and t.fdate<='2019-07-30' and y.fitemid=x.fitemid 


select FAuxQtyMust
, FAuxQty,FConsignPrice,	FConsignAmount,ROUND(y.FAuxQty*y.FConsignPrice,2)

from icstockbill t, ICStockBillEntry y
where t.finterid=y.finterid 
and ROUND(y.FAuxQty*y.FConsignPrice,2)<>y.FConsignAmount 
and t.fdate>'2019-08-11' 


update y set y.FConsignAmount=ROUND(y.FAuxQty*y.FConsignPrice,2)
from icstockbill t, ICStockBillEntry y
where t.finterid=y.finterid 
and ROUND(y.FAuxQty*y.FConsignPrice,2)<>y.FConsignAmount 
and t.fdate>'2019-08-11' 


select *
from icstockbill t, ICStockBillEntry y
where t.finterid=y.finterid 
and ROUND(y.FAuxQty*y.FConsignPrice,2)<>y.FConsignAmount 
and t.fdate>'2019-08-11' 

 
 