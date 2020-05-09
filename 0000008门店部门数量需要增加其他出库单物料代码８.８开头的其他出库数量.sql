SELECT CONVERT(VARCHAR(100), v1.FDate, 23) AS CalDate ,
                                SUM(u1.FAuxQty) AS CalNumber
                         FROM   AIS_YXSP2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXSP2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_ICItem t12 ON u1.FItemID = t12.FItemID
                                                              AND t12.FItemID <> 0
                         WHERE  1 = 1
                                AND ( v1.FDate BETWEEN '2020-04-22' AND '2020-04-22'
                                      AND ISNULL(t12.FNumber, '') LIKE '8.8%'
                                    )
                                AND ( v1.FTranType = 29 )
                         GROUP BY v1.FDate
                         
                         
                         
                         