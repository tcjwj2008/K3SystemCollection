SELECT  *
FROM    ( SELECT    0 AS FSumSort ,
                    a.FItemID ,
                    c.FNumber AS FNumber ,
                    c.FName AS FName ,
                    e.FCurrencyID ,
                    e.FName AS FCurrencyName ,
                    a.FCreditLevel ,
                    ISNULL(FStdAmt, 0) AS FStdAmt ,
                    CONVERT(NUMERIC(18, 2), ( CASE WHEN e.FOperator = '*'
                                                   THEN ISNULL(FStdAmt, 0)
                                                        / e.FExchangeRate
                                                   ELSE ISNULL(FStdAmt, 0)
                                                        * e.FExchangeRate
                                              END )) AS FAmt ,
                    CONVERT(NUMERIC(18, 2), ( CASE WHEN d.FOperator = '*'
                                                   THEN a.FAmount
                                                        * d.FExchangeRate
                                                   ELSE a.FAmount
                                                        / d.FExchangeRate
                                              END )) AS FCreditStdAmt ,
                    CONVERT(NUMERIC(18, 2), CASE WHEN e.FOperator = '*'
                                                 THEN ( CASE WHEN d.FOperator = '*'
                                                             THEN a.FAmount
                                                              * d.FExchangeRate
                                                             ELSE a.FAmount
                                                              / d.FExchangeRate
                                                        END )
                                                      / e.FExchangeRate
                                                 ELSE ( CASE WHEN d.FOperator = '*'
                                                             THEN a.FAmount
                                                              * d.FExchangeRate
                                                             ELSE a.FAmount
                                                              / d.FExchangeRate
                                                        END )
                                                      * e.FExchangeRate
                                            END) AS FCreditAmt ,
                    CONVERT(NUMERIC(18, 2), ( CASE WHEN d.FOperator = '*'
                                                   THEN a.FAmount
                                                        * d.FExchangeRate
                                                   ELSE a.FAmount
                                                        / d.FExchangeRate
                                              END )) - ISNULL(FStdAmt, 0) AS FBalStdAmt ,
                    CONVERT(NUMERIC(18, 2), CASE WHEN e.FOperator = '*'
                                                 THEN ( CASE WHEN d.FOperator = '*'
                                                             THEN a.FAmount
                                                              * d.FExchangeRate
                                                             ELSE a.FAmount
                                                              / d.FExchangeRate
                                                        END )
                                                      / e.FExchangeRate
                                                 ELSE ( CASE WHEN d.FOperator = '*'
                                                             THEN a.FAmount
                                                              * d.FExchangeRate
                                                             ELSE a.FAmount
                                                              / d.FExchangeRate
                                                        END )
                                                      * e.FExchangeRate
                                            END)
                    - CONVERT(NUMERIC(18, 2), CASE WHEN e.FOperator = '*'
                                                   THEN ISNULL(FStdAmt, 0)
                                                        / e.FExchangeRate
                                                   ELSE ISNULL(FStdAmt, 0)
                                                        * e.FExchangeRate
                                              END) AS FBalAmt
          FROM      ICCreditObject a
                    LEFT JOIN ( SELECT  a.FCreditClass ,
                                        a.FItemID ,
                                        CONVERT(NUMERIC(18, 2), ISNULL(SUM(+CASE
                                                              WHEN FGroupID = 3
                                                              THEN FMainAmtPara2
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 3
                                                              THEN FMainAmtPara3
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 3
                                                              AND ( a.FStatus
                                                              & 1 = 1 )
                                                              THEN FMainAmtPara2
                                                              ELSE 0
                                                              END
                                                              + CASE
                                                              WHEN FGroupID = 3
                                                              THEN FMainAmtPara1
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 3
                                                              AND ( a.FStatus
                                                              & 1 = 1 )
                                                              THEN FMainAmtPara1
                                                              ELSE 0
                                                              END
                                                              + CASE
                                                              WHEN FGroupID = 6
                                                              THEN FMainAmtPara2
                                                              ELSE 0
                                                              END
                                                              + CASE
                                                              WHEN FGroupID = 6
                                                              THEN FMainAmtPara1
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 4
                                                              THEN FMainAmtPara2
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 4
                                                              THEN FMainAmtPara1
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 5
                                                              THEN FMainAmtPara2
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 5
                                                              THEN FMainAmtPara1
                                                              ELSE 0
                                                              END
                                                              + CASE
                                                              WHEN FGroupID = 1
                                                              THEN FMainAmtPara2
                                                              ELSE 0
                                                              END
                                                              + CASE
                                                              WHEN FGroupID = 1
                                                              THEN FMainAmtPara1
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 1
                                                              THEN FMainAmtPara3
                                                              ELSE 0
                                                              END), 0)) AS FStdAmt
                                FROM    ICCreditInstant a
                                GROUP BY a.FCreditClass ,
                                        a.FItemID
                              ) b ON a.FCreditClass = b.FCreditClass
                                     AND a.FItemID = b.FItemID
                    INNER JOIN t_Organization c ON a.FItemID = c.FItemID
                    INNER JOIN ( SELECT FCurrencyID ,
                                        FName ,
                                        FOperator ,
                                        CASE WHEN FOperator = '/'
                                             THEN 1 / FExchangeRate
                                             ELSE FExchangeRate
                                        END AS FExchangeRate
                                 FROM   t_Currency
                               ) d ON a.FcurrencyID = d.FCurrencyID
                    INNER JOIN ( SELECT FCurrencyID ,
                                        FName ,
                                        FOperator ,
                                        CASE WHEN FOperator = '/'
                                             THEN 1 / FExchangeRate
                                             ELSE FExchangeRate
                                        END AS FExchangeRate
                                 FROM   t_Currency
                               ) e ON e.FCurrencyID = 1
          WHERE     a.FCreditClass = 0
                    AND c.FNumber >= '01.01.006'
                    AND c.FNumber <= '01.01.006'
          UNION ALL
          SELECT    101 AS FSumSort ,
                    0 ,
                    'ºÏ¼Æ' AS FNumber ,
                    '' AS FName ,
                    0 ,
                    MAX(e.FName) AS FCurrencyName ,
                    '' ,
                    SUM(ISNULL(FStdAmt, 0)) AS FStdAmt ,
                    SUM(CONVERT(NUMERIC(18, 2), ( CASE WHEN e.FOperator = '*'
                                                       THEN ISNULL(FStdAmt, 0)
                                                            / e.FExchangeRate
                                                       ELSE ISNULL(FStdAmt, 0)
                                                            * e.FExchangeRate
                                                  END ))) AS FAmt ,
                    SUM(CONVERT(NUMERIC(18, 2), ( CASE WHEN d.FOperator = '*'
                                                       THEN a.FAmount
                                                            * d.FExchangeRate
                                                       ELSE a.FAmount
                                                            / d.FExchangeRate
                                                  END ))) AS FCreditStdAmt ,
                    SUM(CONVERT(NUMERIC(18, 2), CASE WHEN e.FOperator = '*'
                                                     THEN ( CASE
                                                              WHEN d.FOperator = '*'
                                                              THEN a.FAmount
                                                              * d.FExchangeRate
                                                              ELSE a.FAmount
                                                              / d.FExchangeRate
                                                            END )
                                                          / e.FExchangeRate
                                                     ELSE ( CASE
                                                              WHEN d.FOperator = '*'
                                                              THEN a.FAmount
                                                              * d.FExchangeRate
                                                              ELSE a.FAmount
                                                              / d.FExchangeRate
                                                            END )
                                                          * e.FExchangeRate
                                                END)) AS FCreditAmt ,
                    SUM(CONVERT(NUMERIC(18, 2), ( CASE WHEN d.FOperator = '*'
                                                       THEN a.FAmount
                                                            * d.FExchangeRate
                                                       ELSE a.FAmount
                                                            / d.FExchangeRate
                                                  END )) - ISNULL(FStdAmt, 0)) AS FBalStdAmt ,
                    SUM(CONVERT(NUMERIC(18, 2), CASE WHEN e.FOperator = '*'
                                                     THEN ( CASE
                                                              WHEN d.FOperator = '*'
                                                              THEN a.FAmount
                                                              * d.FExchangeRate
                                                              ELSE a.FAmount
                                                              / d.FExchangeRate
                                                            END )
                                                          / e.FExchangeRate
                                                     ELSE ( CASE
                                                              WHEN d.FOperator = '*'
                                                              THEN a.FAmount
                                                              * d.FExchangeRate
                                                              ELSE a.FAmount
                                                              / d.FExchangeRate
                                                            END )
                                                          * e.FExchangeRate
                                                END)
                        - CONVERT(NUMERIC(18, 2), CASE WHEN e.FOperator = '*'
                                                       THEN ISNULL(FStdAmt, 0)
                                                            / e.FExchangeRate
                                                       ELSE ISNULL(FStdAmt, 0)
                                                            * e.FExchangeRate
                                                  END)) AS FBalAmt
          FROM      ICCreditObject a
                    LEFT JOIN ( SELECT  a.FCreditClass ,
                                        a.FItemID ,
                                        CONVERT(NUMERIC(18, 2), ISNULL(SUM(+CASE
                                                              WHEN FGroupID = 3
                                                              THEN FMainAmtPara2
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 3
                                                              THEN FMainAmtPara3
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 3
                                                              AND ( a.FStatus
                                                              & 1 = 1 )
                                                              THEN FMainAmtPara2
                                                              ELSE 0
                                                              END
                                                              + CASE
                                                              WHEN FGroupID = 3
                                                              THEN FMainAmtPara1
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 3
                                                              AND ( a.FStatus
                                                              & 1 = 1 )
                                                              THEN FMainAmtPara1
                                                              ELSE 0
                                                              END
                                                              + CASE
                                                              WHEN FGroupID = 6
                                                              THEN FMainAmtPara2
                                                              ELSE 0
                                                              END
                                                              + CASE
                                                              WHEN FGroupID = 6
                                                              THEN FMainAmtPara1
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 4
                                                              THEN FMainAmtPara2
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 4
                                                              THEN FMainAmtPara1
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 5
                                                              THEN FMainAmtPara2
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 5
                                                              THEN FMainAmtPara1
                                                              ELSE 0
                                                              END
                                                              + CASE
                                                              WHEN FGroupID = 1
                                                              THEN FMainAmtPara2
                                                              ELSE 0
                                                              END
                                                              + CASE
                                                              WHEN FGroupID = 1
                                                              THEN FMainAmtPara1
                                                              ELSE 0
                                                              END
                                                              - CASE
                                                              WHEN FGroupID = 1
                                                              THEN FMainAmtPara3
                                                              ELSE 0
                                                              END), 0)) AS FStdAmt
                                FROM    ICCreditInstant a
                                GROUP BY a.FCreditClass ,
                                        a.FItemID
                              ) b ON a.FCreditClass = b.FCreditClass
                                     AND a.FItemID = b.FItemID
                    INNER JOIN t_Organization c ON a.FItemID = c.FItemID
                    INNER JOIN ( SELECT FCurrencyID ,
                                        FName ,
                                        FOperator ,
                                        CASE WHEN FOperator = '/'
                                             THEN 1 / FExchangeRate
                                             ELSE FExchangeRate
                                        END AS FExchangeRate
                                 FROM   t_Currency
                               ) d ON a.FcurrencyID = d.FCurrencyID
                    INNER JOIN ( SELECT FCurrencyID ,
                                        FName ,
                                        FOperator ,
                                        CASE WHEN FOperator = '/'
                                             THEN 1 / FExchangeRate
                                             ELSE FExchangeRate
                                        END AS FExchangeRate
                                 FROM   t_Currency
                               ) e ON e.FCurrencyID = 1
          WHERE     a.FCreditClass = 0
                    AND c.FNumber >= '01.01.006'
                    AND c.FNumber <= '01.01.006'
        ) t
ORDER BY FSumSort ,
        FNumber;