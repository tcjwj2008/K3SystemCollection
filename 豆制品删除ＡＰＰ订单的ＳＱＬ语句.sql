SELECT  *
FROM    t_order ,
        dbo.t_orderdetail
WHERE   dbo.t_order.id = dbo.t_orderdetail.mainid
        AND t_order.storeid = 8091
        AND orderno = 'XOUT2566093';
        
        
--DELETE FROM t_order WHERE  t_order.storeid=8091 AND remarks='z'
--DELETE FROM dbo.t_orderdetail WHERE mainid IN (SELECT id FROM t_order WHERE  t_order.storeid=8091 AND remarks='z')
--AND remarks='z'


SELECT  *
--DELETE 
FROM    t_order
WHERE   t_order.storeid = 8091
        AND remarks = 'z';
SELECT  * 
--DELETE 
FROM    dbo.t_orderdetail
WHERE   mainid IN ( SELECT  id
                    FROM    t_order
                    WHERE   t_order.storeid = 8091
                            AND remarks = 'z' )
        AND remarks = 'z'

--delete FROM t_order WHERE  t_order.storeid=8091 AND remarks='z' AND createtime='2020-03-31 00:00:00.0000000'
--delete FROM dbo.t_orderdetail WHERE mainid IN (SELECT id FROM t_order WHERE  t_order.storeid=8091 AND remarks='z' AND createtime='2020-03-31 00:00:00.0000000')
        AND remarks = 'z'
        AND createtime = '2020-03-31 00:00:00.0000000';


SELECT  *
FROM    dbo.t_store
WHERE   store LIKE '%芹%';





SELECT  SUM(t_orderdetail.amount)
--DELETE 
FROM    dbo.t_orderdetail
WHERE   mainid IN (
        SELECT  ( dbo.t_order.id )
        FROM    t_orderdetail ,
                t_order ,
                dbo.t_store
        WHERE   dbo.t_order.id = t_orderdetail.mainid
                AND t_order.storeid = dbo.t_store.id
               -- AND ( dbo.t_store.store LIKE '%朴朴%' )
                AND t_order.createtime >= '2020-01-01 00:00:01.0470000'
                AND t_order.createtime <= '2020-03-31 23:59:43.0470000'
                AND dbo.t_order.state <> '新建' );
        
--SELECT  * 
--   --delete
--FROM    t_order
--WHERE   id IN (
--        SELECT  ( dbo.t_order.id )
--        FROM    t_orderdetail ,
--                t_order ,
--                dbo.t_store
--        WHERE   dbo.t_order.id = t_orderdetail.mainid
--                AND t_order.storeid = dbo.t_store.id
--                AND ( dbo.t_store.store LIKE '%朴朴%' )
--                AND t_order.createtime >= '2020-01-01 00:00:01.0470000'
--                AND t_order.createtime <= '2020-03-31 23:59:43.0470000'
--                AND dbo.t_order.state <> '新建' );     
        
   
   
SELECT  * 
 --delete
FROM    t_order
WHERE   id IN (
        SELECT  ( dbo.t_order.id )
        FROM    t_order ,
                dbo.t_store
        WHERE   t_order.storeid = dbo.t_store.id
                AND ( dbo.t_store.store LIKE '%朴朴%' )
                AND t_order.createtime >= '2020-01-01 00:00:01.0470000'
                AND t_order.createtime <= '2020-03-31 23:59:43.0470000'
                AND dbo.t_order.state <> '新建' );     
        
 
        
       
    
SELECT  *
 
 --delete 
FROM    dbo.t_orderdetail
WHERE   mainid IN (
        SELECT  ( t_order.id )
        FROM    t_orderdetail ,
                t_order ,
                dbo.t_store
        WHERE   dbo.t_order.id = t_orderdetail.mainid
                AND t_order.storeid = dbo.t_store.id
                AND t_order.createtime >= '2020-01-01 00:00:01.0470000'
                AND t_order.createtime <= '2020-03-31 23:59:43.0470000'
                AND dbo.t_order.state <> '新建'
                AND dbo.t_store.storeno LIKE '02.%' );
           
 
SELECT  *
 --delete 
FROM    t_order
WHERE   id IN (
        SELECT  (t_order.id)
        FROM    
                t_order ,
                dbo.t_store
        WHERE     t_order.storeid = dbo.t_store.id
                AND t_order.createtime >= '2020-01-01 00:00:01.0470000'
                AND t_order.createtime <= '2020-03-31 23:59:43.0470000'
                AND dbo.t_order.state <> '新建'
                AND dbo.t_store.storeno LIKE '02.%' );
 
    
    
    
       
       
SELECT  SUM(t_orderdetail.amount)
FROM    t_orderdetail ,
        t_order ,
        dbo.t_store
WHERE   dbo.t_order.id = t_orderdetail.mainid
        AND t_order.storeid = dbo.t_store.id
        AND t_order.createtime >= '2020-02-01 00:00:01.0470000'
        AND t_order.createtime <= '2020-02-29 23:59:43.0470000'
        AND dbo.t_order.state <> '新建'
        AND dbo.t_store.storeno LIKE '02.%';
        
        
        
SELECT  *
FROM    t_orderdetail ,
        t_order ,
        dbo.t_store
WHERE   dbo.t_order.id = t_orderdetail.mainid
        AND t_order.storeid = dbo.t_store.id
        AND t_order.createtime >= '2020-03-01 00:00:01.0470000'
        AND t_order.createtime <= '2020-03-31 23:59:43.0470000'
        AND dbo.t_order.state <> '新建'
        AND dbo.t_store.storeno LIKE '02.%';     