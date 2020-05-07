

SELECT TOP 100 * FROM CON12.YRTZDATA.dbo.TZ_XS_delivery2019 WHERE deliverydate between '2019-08-06' and  '2019-08-07'
and fhclientcode = 'R09.0004.305' --OR CLIENTNAME LIKE '%Æì½¢%'

SELECT * FROM con12.YRTZDATA.dbo.TZ_XS_deliverydata2019 WHERE DELIVERYCODE IN(
SELECT DELIVERYCODE FROM CON12.YRTZDATA.dbo.TZ_XS_delivery2019 WHERE deliverydate between '2019-08-06' and  '2019-08-07'
and fhclientcode = 'R09.0004.305')


SELECT * FROM con12.YRTZDATA.dbo.TZ_XS_deliveryinfo2019 WHERE DELIVERYCODE IN(
SELECT DELIVERYCODE FROM CON12.YRTZDATA.dbo.TZ_XS_delivery2019 WHERE deliverydate between '2019-08-06' and  '2019-08-07'
and fhclientcode = 'R09.0004.305' and storagename='°×Ìõ¿â' )

SELECT * FROM CON12.YRTZDATA.dbo.TZ_XS_delivery2019 x
left join con12.YRTZDATA.dbo.TZ_XS_deliverydata2019 y
on x.deliverycode=y.deliverycode
left join con12.YRTZDATA.dbo.TZ_XS_deliveryinfo2019 z
on  z.deliverycode=y.deliverycode
where 
x.deliverydate between '2019-08-06' and  '2019-08-07' and x.fhclientcode like 'R09.0004.%'




