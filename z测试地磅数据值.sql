select * from scaledb.dbo.Trade
     SELECT   ticketno1 ,
                 sparestr2 ,
                 net / 1000 ,
                 truckno
        FROM    Trade where id>10000
        
        order by id desc
       
       
       set xact_abort on 
        insert into trade(ticketno1 ,
                 sparestr2 ,
                 net ,
                 truckno) values('02201211290013','1436','27.94','ÔÁDY0098')

