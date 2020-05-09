SELECT    T.FNumber ,
                                T.FName ,
                                SUM(FQty) AS FQty 
                      FROM      dbo.ICStockBillEntry E
                                INNER JOIN dbo.ICStockBill B ON B.FInterID = E.FInterID
                                                              AND b.FCancellation = 0
                                INNER JOIN t_Department t4 ON b.FDeptID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN dbo.t_ICItem T ON E.FItemID = T.FItemID
                              
                      WHERE     B.FDate = '2019-11-01'
                                AND B.FTranType = 2
                                AND ISNULL(t4.FName, '') = '·Ö¸î³µ¼ä'
                      GROUP BY  T.FNumber ,
                                T.FName 
								ORDER BY t.FNumber
                         