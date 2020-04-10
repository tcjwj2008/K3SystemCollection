SELECT  SUM(t_orderdetail.amount)
FROM    t_orderdetail ,
        t_order ,
        dbo.t_store
WHERE   dbo.t_order.id = t_orderdetail.mainid
        AND t_order.storeid = dbo.t_store.id
        AND ( dbo.t_store.store LIKE '%福州朴朴电子商务有限公司26店%'
              OR dbo.t_store.store LIKE '%福州朴朴电子商务有限公司12店%'
            )
        AND t_order.createtime >= '2020-01-01 00:00:01.0470000'
        AND t_order.createtime <= '2020-03-31 23:59:43.0470000'
        AND dbo.t_order.state <> '新建';
        
      --  AND dbo.t_store.storeno LIKE '02.%'
        
       
       
       
SELECT  SUM(t_orderdetail.amount)
FROM    t_orderdetail ,
        t_order ,
        dbo.t_store
WHERE   dbo.t_order.id = t_orderdetail.mainid
        AND t_order.storeid = dbo.t_store.id
        --AND (dbo.t_store.store LIKE '%福州朴朴电子商务有限公司26店%' OR dbo.t_store.store LIKE '%福州朴朴电子商务有限公司12店%')
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
--AND (dbo.t_store.store LIKE '%福州朴朴电子商务有限公司26店%' OR dbo.t_store.store LIKE '%福州朴朴电子商务有限公司12店%')
        AND t_order.createtime >= '2020-03-01 00:00:01.0470000'
        AND t_order.createtime <= '2020-03-31 23:59:43.0470000'
        AND dbo.t_order.state <> '新建'
        AND dbo.t_store.storeno LIKE '02.%';       
        
               
       
  SELECT SUM(t_orderdetail.amount)
FROM    t_orderdetail ,
        t_order 
WHERE   dbo.t_order.id = t_orderdetail.mainid
     
AND t_order.createtime >= '2020-01-01 00:00:00.0000000'
        AND t_order.createtime <= '2020-03-31 23:59:43.0470000'
       
        AND t_order.storeid=8091
        
        ORDER BY t_order.createtime
           
       
       
       
        
SELECT  *
FROM    dbo.t_store WHERE dbo.t_store.store LIKE '丘芹红';
        
       
       
       
       
       
/*福州朴朴电子商务有限公司12店
厦门朴朴电子商务有限公司5店
福州朴朴电子商务有限公司
福州朴朴电子商务有限公司26店
厦门朴朴电子商务有限公司3店*/





