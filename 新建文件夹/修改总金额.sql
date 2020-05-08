--update y set y.fallamount=round(y.fauxqty*y.FAuxtaxPrice,2) from seorder t,seorderentry y ,t_icitem x 
--where t.finterid=y.finterid 
--and round(y.fauxqty*y.FAuxtaxPrice,2)<>y.fallamount 
--and t.fdate>='2019-07-30' and t.fdate<='2019-07-30' and y.fitemid=x.fitemid


update y set y.fallamount=round(y.fauxqty*y.FAuxtaxPrice,2)  from seorder t,seorderentry y ,t_icitem x 
where t.finterid=y.finterid 
and round(y.fauxqty*y.FAuxtaxPrice,2)<>y.fallamount 
and t.fdate>='2019-07-31' and t.fdate<='2019-07-31' and y.fitemid=x.fitemid