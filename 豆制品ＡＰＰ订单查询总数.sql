       
 select count(*) from      t_order    where    dbo.t_order.state <> 'ÐÂ½¨'
 
     AND t_order.createtime <= '2020-03-31 23:59:43.0470000'
     AND t_order.createtime >= '2019-09-01 00:00:00.0000000'