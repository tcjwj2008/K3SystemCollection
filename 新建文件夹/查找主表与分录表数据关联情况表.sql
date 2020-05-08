select t.*
from 
(

select a.* from ICStockBillEntry 

a ,icstockbill b  where 


 b.FDate>'2019-07-31'  and a.FInterID=b.finterid
 )
 
t
where t.finterid not in (select finterid from ICStockBill where FDate>'2019-07-31')