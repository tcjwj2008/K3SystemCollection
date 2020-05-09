SELECT TOP 1
        t2.FInterID ,
        t2.FEntryID ,
        t2.FItemID ,
        ROUND(( CASE WHEN t2.FCuryID = 1 THEN t2.FPrice
                     ELSE t2.FPrice / CAST(1 AS FLOAT)
                END ) / CAST(tm.FCoefficient AS FLOAT)
              * CAST(0.2 AS FLOAT), ti.FPriceDecimal) AS FPrice ,
        ( CASE WHEN tc.FOperator = ' * '
               THEN ROUND(CAST(t4.FLowPrice AS FLOAT)
                          * ( CASE WHEN tc.FCurrencyID = 1 THEN 1
                                   ELSE ( ( CASE WHEN te.FExchangeRate IS NOT NULL
                                                 THEN CAST(te.FExchangeRate AS FLOAT)
                                                 ELSE CAST(tc.FExchangeRate AS FLOAT)
                                            END ) / CAST(1 AS FLOAT) )
                              END ) * CAST(0.2 AS FLOAT),
                          ti.FPriceDecimal)
               ELSE ROUND(CAST(t4.FLowPrice AS FLOAT)
                          / ( CASE WHEN tc.FCurrencyID = 1 THEN 1
                                   ELSE ( ( CASE WHEN te.FExchangeRate IS NOT NULL
                                                 THEN CAST(te.FExchangeRate AS FLOAT)
                                                 ELSE CAST(tc.FExchangeRate AS FLOAT)
                                            END ) / CAST(1 AS FLOAT) )
                              END ) * CAST(0.2 AS FLOAT),
                          ti.FPriceDecimal)
          END ) AS FLowPrice ,
        t4.FCanSell ,
        t4.FLPriceCtrl ,
        CASE WHEN t2.FCuryID = 1 THEN 0
             ELSE 1
        END AS FOrder1 ,
        CASE WHEN t2.FUnitID = 2421 THEN 0
             ELSE 1
        END AS FOrder2 ,
        CASE WHEN t2.FBegQty = 0
                  AND t2.FEndQty = 0 THEN 1
             ELSE 0
        END AS FOrder3 ,
        ( 1 - SIGN(t2.FAuxPropID) ) AS FOrder4
FROM    ICPrcPly t1
        INNER JOIN ICPrcPlyEntry t2 ON t1.FInterID = t2.FInterID
        INNER JOIN t_ICItem ti ON t2.FItemID = ti.FItemID
        INNER JOIN t_MeasureUnit tm ON t2.FUnitID = tm.FMeasureUnitID
        INNER JOIN IcPrcOpt t3 ON t1.FPlyType = t3.FKey
                                  AND t3.FValue = '1'
        INNER JOIN ICPrcPlyEntrySpec t4 ON t2.FInterID = t4.FInterID
                                           AND t2.FItemID = t4.FItemID
                                           AND t2.FRelatedID = t4.FRelatedID
        INNER JOIN t_Currency tc ON t4.FLPriceCuryID = tc.FCurrencyID
        LEFT JOIN t_ExchangeRateEntry te ON te.FBegDate <= '2019-12-20'
                                            AND te.FEndDate >= '2019-12-20'
                                            AND te.FExchangeRateType = 1
                                            AND te.FCyTo = t4.FLPriceCuryID
WHERE   ( ( t2.FRelatedID IN ( 0, 1540, 0 )
            AND t1.FSysTypeID IN ( 1, 3 )
          )
          OR ( t2.FRelatedID IN ( 0, 20011, 0 )
               AND t1.FSysTypeID IN ( 501, 30 )
             )
          OR ( t2.FRelatedID IN ( 0, 0 )
               AND t1.FSysTypeID = 1007735
             )
          OR t1.FSysTypeID = -1000
        )
        AND t2.FBegDate <= '2019-12-19'
        AND t2.FEndDate >= '2019-12-19'
        AND t2.FItemID = 10515
        AND t2.FAuxPropID IN ( 0, 0 )
        AND ( ( t2.FUnitID = 2421
                AND ( ( t2.FBegQty <= 0
                        AND t2.FEndQty >= 0
                      )
                      OR ( t2.FBegQty = 0
                           AND t2.FEndQty = 0
                         )
                    )
              )
              OR ( t2.FUnitID = ti.FUnitID
                   AND ( ( t2.FBegQty <= 0
                           AND t2.FEndQty >= 0
                         )
                         OR ( t2.FBegQty = 0
                              AND t2.FEndQty = 0
                            )
                       )
                 )
            )
        AND ( t2.FCuryID = 1
              OR t2.FCuryID = 1
            )
        AND t2.FChecked = 1
        AND ( FPeriodType = 0
              OR ( FPeriodType = 1
                   AND FCycBegTime <= '16:48:21'
                   AND FCycEndTime >= '16:48:21'
                 )
              OR ( FPeriodType = 2
                   AND FCycBegTime <= '16:48:21'
                   AND FCycEndTime >= '16:48:21'
                   AND CHARINDEX('4', FWeek) > 0
                 )
              OR ( FPeriodType = 3
                   AND FCycBegTime <= '16:48:21'
                   AND FCycEndTime >= '16:48:21'
                   AND CHARINDEX('@Month', FMonth) > 0
                   AND ( FDayPerMonth = '19'
                         OR ( FSerialWeekPerMonth = '3'
                              AND FWeekDayPerMonth = '4'
                            )
                       )
                 )
            )
ORDER BY t1.FPri ,
        t3.FSort ,
        FOrder1 ,
        FOrder2 ,
        FOrder3 ,
        FOrder4 ,
        t2.FBegDate DESC;

