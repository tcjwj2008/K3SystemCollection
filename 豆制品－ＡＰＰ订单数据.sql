--SELECT  *
--FROM    dbo.t_orderdetail;


SELECT * 
--DELETE 
FROM dbo.t_order WHERE storeid=12013
SELECT *
--delete 
FROM dbo.t_orderdetail WHERE mainid IN (SELECT id FROM t_order WHERE  storeid=12013)

SELECT  t_order.createtime ,
        storeid ,
        store ,
        dbo.t_product.code ,
        dbo.t_product.name ,
        dbo.t_product.spec ,
        dbo.t_product.unit ,
        t_orderdetail.num,
        dbo.t_orderdetail.price ,
        dbo.t_orderdetail.amount
FROM    t_order
        inner JOIN dbo.t_store ON t_order.storeid = t_store.id
        INNER JOIN dbo.t_orderdetail ON t_order.id = dbo.t_orderdetail.mainid
        INNER JOIN dbo.t_product ON t_orderdetail.productno = dbo.t_product.id
WHERE   t_order.createtime >= '2020-01-01'
        AND t_order.createtime <= '2020-03-29'
      
ORDER BY t_order.createtime,t_store.id



SELECT * FROM dbo.t_orderdetail