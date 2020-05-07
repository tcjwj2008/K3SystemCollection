select distinct t.fdate, t.fbillno,x.fnumber,x.fname,'大',
  FAuxPrice 单价 ,FAuxQty 数量 ,FAuxTaxPrice 含税单价,FAuxPriceDiscount 实际含税单价, FAllAmount 含税金额,FAmount 金额,FAllStdAmount 价税合计本位币
  ,y.fauxqty*y.FAuxtaxPrice,round(y.fauxqty*y.FAuxtaxPrice,2) from seorder t,seorderentry y ,t_icitem x where t.finterid=y.finterid 
and 
 round(y.fauxqty*y.FAuxtaxPrice,2)<>y.fallamount and t.fdate>='2019-07-30' and t.fdate<='2019-07-30' and y.fitemid=x.fitemid 
 
--union all
--select distinct t.fdate,t.fbillno,x.fnumber,x.fname,'小' from seorder t,seorderentry y ,t_icitem x where t.finterid=y.finterid 
--and 
-- y.fauxqty*y.FAuxtaxPrice<y.fallamount and t.fdate>='2019-07-30' and t.fdate<='2019-07-30' and y.fitemid=x.fitemid 
 
 
--------------------------------------------------------------------------------------------


--update y set y.fallamount=y.fauxqty*y.FAuxtaxPrice from seorder t,seorderentry y ,t_icitem x where t.finterid=y.finterid 
--and 
-- y.fauxqty*y.FAuxtaxPrice>y.fallamount and t.fdate>='2019-07-30' and t.fdate<='2019-07-30' and y.fitemid=x.fitemid 


--update y set y.fallamount=y.fauxqty*y.FAuxtaxPrice from seorder t,seorderentry y ,t_icitem x where t.finterid=y.finterid 
--and 
-- y.fauxqty*y.FAuxtaxPrice<y.fallamount and t.fdate>='2019-07-30' and t.fdate<='2019-07-30' and y.fitemid=x.fitemid 
 
 
update y set y.fallamount=round(y.fauxqty*y.FAuxtaxPrice,2) from seorder t,seorderentry y ,t_icitem x where t.finterid=y.finterid 
and 
 round(y.fauxqty*y.FAuxtaxPrice,2)<>y.fallamount and t.fdate>='2019-07-30' and t.fdate<='2019-07-30' and y.fitemid=x.fitemid 
 
 
 
 spk3_2str @sname ='seorderentry'