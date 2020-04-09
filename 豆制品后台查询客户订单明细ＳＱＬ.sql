SELECT  *
FROM    t_orderdetail ,
        t_order ,
        dbo.t_store
WHERE   dbo.t_order.id = t_orderdetail.mainid
        AND t_order.storeid = dbo.t_store.id
        AND dbo.t_store.store LIKE 'ÇðÇÛºì';