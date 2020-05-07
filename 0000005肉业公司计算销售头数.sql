SELECT CONVERT(VARCHAR(100), a.deliverydate, 23) as ÈÕÆÚ,b.*
                               
                         FROM   ( SELECT    deliverydate ,
                                            deliverycode
                                  FROM      CON12.yrtzdata.dbo.TZ_XS_delivery2019
                                  WHERE     ( fhclientcode LIKE 'R09.0004.%' )
                                            OR fhclientname LIKE 'S%'
                                ) a ,
                                CON12.yrtzdata.dbo.TZ_XS_deliveryinfo2019 b
                         WHERE  a.deliverycode = b.deliverycode
                                AND a.deliverydate BETWEEN '2019-10-05' AND '2019-10-06'
                     --    GROUP BY CONVERT(VARCHAR(100), a.deliverydate, 23)