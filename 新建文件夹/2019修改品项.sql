select distinct z.fnumber,z.fname from icstockbill x ,icstockbillentry y ,t_icitem z 
where x.finterid=y.finterid and y.fitemid=z.fitemid and x.fdate>'2018-12-31' and
( x.ftrantype=2)
order by z.fnumber 

select * from ICSTOCKBILL WHERE FBILLNO='CIN010917'
