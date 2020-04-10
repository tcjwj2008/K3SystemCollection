SELECT * FROM t_order WHERE remarks='z'

--UPDATE  t_order SET createtime =DATEADD(SECOND,3,createtime) WHERE remarks='z'
--UPDATE  t_order SET ordertime =DATEADD(SECOND,3,ordertime) WHERE remarks='z'


SELECT ordertime, DATEADD(SECOND,3,ordertime) FROM  t_order WHERE remarks='z'
