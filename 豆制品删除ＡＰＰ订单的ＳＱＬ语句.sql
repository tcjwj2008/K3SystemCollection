SELECT * FROM t_order,dbo.t_orderdetail WHERE dbo.t_order.id=dbo.t_orderdetail.mainid

AND t_order.storeid=8091 AND orderno='XOUT2566093'
DELETE FROM t_order WHERE  t_order.storeid=8091 AND remarks='z'
DELETE FROM dbo.t_orderdetail WHERE mainid IN (SELECT id FROM t_order WHERE  t_order.storeid=8091 AND remarks='z')
AND remarks='z'
SELECT *
--DELETE 
FROM t_order WHERE  t_order.storeid=8091 AND remarks='z'
SELECT 
* 
--DELETE 
 FROM dbo.t_orderdetail WHERE mainid IN (
 SELECT id FROM t_order WHERE  t_order.storeid=8091 AND remarks='z')
AND remarks='z'

delete FROM t_order WHERE  t_order.storeid=8091 AND remarks='z' AND createtime='2020-03-31 00:00:00.0000000'
delete FROM dbo.t_orderdetail WHERE mainid IN (SELECT id FROM t_order WHERE  t_order.storeid=8091 AND remarks='z' AND createtime='2020-03-31 00:00:00.0000000')
AND remarks='z' AND createtime='2020-03-31 00:00:00.0000000'


SELECT * FROM dbo.t_store WHERE store LIKE '%ÇÛ%';