select distinct t.fdate, t.fbillno,x.fnumber,x.fname,'��' from seorder t,seorderentry y ,t_icitem x where t.finterid=y.finterid 
and 
 y.fauxqty*y.FAuxtaxPrice>y.fallamount and t.fdate>='2019-07-30' and t.fdate<='2019-07-30' and y.fitemid=x.fitemid 
 
union all
select distinct t.fdate,t.fbillno,x.fnumber,x.fname,'С' from seorder t,seorderentry y ,t_icitem x where t.finterid=y.finterid 
and 
 y.fauxqty*y.FAuxtaxPrice<y.fallamount and t.fdate>='2019-07-30' and t.fdate<='2019-07-30' and y.fitemid=x.fitemid 
 
 
-------


update y set y.fallamount=y.fauxqty*y.FAuxtaxPrice from seorder t,seorderentry y ,t_icitem x where t.finterid=y.finterid 
and 
 y.fauxqty*y.FAuxtaxPrice>y.fallamount and t.fdate>='2019-07-30' and t.fdate<='2019-07-30' and y.fitemid=x.fitemid 
 

update y set y.fallamount=y.fauxqty*y.FAuxtaxPrice from seorder t,seorderentry y ,t_icitem x where t.finterid=y.finterid 
and 
 y.fauxqty*y.FAuxtaxPrice<y.fallamount and t.fdate>='2019-07-30' and t.fdate<='2019-07-30' and y.fitemid=x.fitemid 
 
 
