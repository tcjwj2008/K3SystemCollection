--¸ú×ÙÓï¾ä

SELECT  FMergeRowBeg = 9999 ,
        t1_FName = ISNULL(t1.FName, '') ,
        FAssetID ,
        FAssetNumber ,
        FAssetName ,
        FModel ,
        FBeginUseDate ,
        FOrgNum ,
        FNumDec ,
        FLife ,
        FLeftLife ,
        FJobUnit ,
        FClearDate ,
        FClearReason ,
        FOrgValDec ,
        FAccumDeprDec ,
        FDecPreDec ,
        FExpense ,
        FResidueEarn ,
        FRate
INTO    #t_FARptClearList135116497
FROM    ( SELECT    t1_FNumber = CASE t1_FNumber_Inde
                                   WHEN 0 THEN t1_FNumber
                                   ELSE LEFT(t1_FNumber, t1_FNumber_Inde - 1)
                                 END ,
                    FAssetID ,
                    FAssetNumber ,
                    FAssetName ,
                    FModel ,
                    FBeginUseDate ,
                    FOrgNum ,
                    FNumDec ,
                    FLife ,
                    FLeftLife ,
                    FJobUnit ,
                    FClearDate ,
                    FClearReason ,
                    FOrgValDec = SUM(FOrgValDec * FRate) ,
                    FAccumDeprDec = SUM(FAccumDeprDec * FRate) ,
                    FDecPreDec = SUM(FDecPreDec * FRate) ,
                    FExpense = SUM(FExpense * FRate) ,
                    FResidueEarn = SUM(FResidueEarn * FRate) ,
                    FRate = SUM(FRate)
          FROM      ( SELECT    t1_FNumber_Inde = CASE WHEN t1_FLevel <= 0
                                                       THEN 0
                                                       ELSE 0
                                                  END ,
                                SQLAux.*
                      FROM      ( SELECT    t1_FNumber ,
                                            t1_FLevel ,
                                            FAssetID ,
                                            FAssetNumber ,
                                            FAssetName ,
                                            FModel ,
                                            FBeginUseDate ,
                                            FOrgNum ,
                                            FNumDec ,
                                            FOrgValDec ,
                                            FAccumDeprDec ,
                                            FDecPreDec ,
                                            FExpense ,
                                            FResidueEarn ,
                                            FLife ,
                                            FLeftLife ,
                                            FJobUnit ,
                                            FClearDate ,
                                            FClearReason ,
                                            FRate
                                  FROM      ( SELECT    t1_FNumber = ISNULL(t1.FNumber,
                                                              '') ,
                                                        t1_FLevel = ISNULL(t1.FLevel,
                                                              0) ,
                                                        t2_FNumber = ISNULL(t2.FNumber,
                                                              '') ,
                                                        t2_FLevel = ISNULL(t2.FLevel,
                                                              0) ,
                                                        t3_FNumber = ISNULL(t3.FNumber,
                                                              '') ,
                                                        t3_FLevel = ISNULL(t3.FLevel,
                                                              0) ,
                                                        t4_FNumber = ISNULL(t4.FNumber,
                                                              '') ,
                                                        t4_FLevel = ISNULL(t4.FLevel,
                                                              0) ,
                                                        t5_FNumber = ISNULL(t5.FNumber,
                                                              '') ,
                                                        t5_FLevel = ISNULL(t5.FLevel,
                                                              0) ,
                                                        t6_FNumber = ISNULL(t6.FNumber,
                                                              '') ,
                                                        t6_FLevel = ISNULL(t6.FLevel,
                                                              0) ,
                                                        B.FAssetID ,
                                                        C.FAssetNumber ,
                                                        C.FAssetName ,
                                                        C.FModel ,
                                                        C.FBeginUseDate ,
                                                        FOrgNum = B.FNumP ,
                                                        FNumDec = -B.FNumAlter ,
                                                        B.FOrgValDec ,
                                                        B.FAccumDeprDec ,
                                                        B.FDecPreDec ,
                                                        CL.FExpense ,
                                                        CL.FResidueEarn ,
                                                        FLife = C.FLifePeriods ,
                                                        FLeftLife = C.FLifePeriods
                                                        - B.FDeprPeriods ,
                                                        FJobUnit = CASE ISNULL(Z.FIsWorkload,
                                                              0)
                                                              WHEN 0 THEN 'ÆÚ'
                                                              ELSE C.FJobUnit
                                                              END ,
                                                        CL.FDate FClearDate ,
                                                        CL.FExplanation FClearReason ,
                                                        D.FRate
                                              FROM      t_FABalance B
                                                        JOIN t_FABalCard C ON B.FBalID = C.FBalID
                                                              AND B.FWorkBookID = 1
                                                        LEFT JOIN t_FADeprMethod Z ON C.FDeprMethodID = Z.FID
                                                        JOIN t_FABalDept D ON B.FBalID = D.FBalID
                                                        JOIN t_FABalCardItem UI ON B.FBalID = UI.FBalID
                                                        LEFT JOIN t_FAGroup t1 ON C.FGroupID = t1.FID
                                                              AND t1.FWorkBookID = 1
                                                        LEFT JOIN t_Item t2 ON D.FItemID = t2.FItemID
                                                              AND t2.FItemClassID = 2
                                                        LEFT JOIN t_FAEconomyUse t3 ON C.FEconomyUseID = t3.FID
                                                        LEFT JOIN t_FALocation t4 ON C.FLocationID = t4.FID
                                                        LEFT JOIN t_FAAlterMode t5 ON C.FAlterModeID = t5.FID
                                                        LEFT JOIN t_FAStatus t6 ON C.FStatusID = t6.FID
                                                        JOIN t_FAClear CL ON ( B.FAssetID = CL.FAssetID
                                                              AND B.FYear = CL.FYear
                                                              AND B.FPeriod = CL.FPeriod
                                                              )
                                              WHERE     ( B.FYear * 100
                                                          + B.FPeriod ) >= ( 201912 )
                                                        AND ( B.FYear * 100
                                                              + B.FPeriod ) <= ( 201912 )
                                            ) SQ1
                                  WHERE     ( t1_FNumber = '02' )
                                ) SQLAux
                    ) SQ2
          GROUP BY  CASE t1_FNumber_Inde
                      WHEN 0 THEN t1_FNumber
                      ELSE LEFT(t1_FNumber, t1_FNumber_Inde - 1)
                    END ,
                    FAssetID ,
                    FAssetNumber ,
                    FAssetName ,
                    FModel ,
                    FBeginUseDate ,
                    FOrgNum ,
                    FNumDec ,
                    FLife ,
                    FLeftLife ,
                    FJobUnit ,
                    FClearDate ,
                    FClearReason
        ) SQ3
        LEFT JOIN t_FAGroup t1 ON SQ3.t1_FNumber = t1.FNumber
                                  AND t1.FWorkBookID = 1
ORDER BY t1_FNumber ,
        FAssetNumber;
        
        
        
UPDATE  #t_FARptClearList135116497
SET     FOrgNum = t.FNum ,
        FNumDec = t.FNumCleared ,
        FOrgValDec = t.FOrgVal ,
        FAccumDeprDec = t.FAccumDepr
FROM    ( SELECT    s1.FAssetID ,
                    s2.FNum ,
                    s1.FNumCleared ,
                    FOrgVal = s2.FOrgVal * s1.FNumCleared / s2.FNum ,
                    FAccumDepr = s2.FAccumDepr * s1.FNumCleared / s2.FNum
          FROM      ( SELECT    c.*
                      FROM      t_FAClear c
                                INNER JOIN ( SELECT FAlterID
                                             FROM   t_FAAlter
                                             WHERE  FALterNum > 0
                                                    AND ( FYear * 100
                                                          + FPeriod ) >= ( 201912 )
                                                    AND ( FYear * 100
                                                          + FPeriod ) <= ( 201912 )
                                                    AND FWorkBookID = 1
                                           ) a ON c.FAlterID = a.FAlterID
                    ) s1
                    INNER JOIN ( SELECT d.* ,
                                        a.FAssetID
                                 FROM   t_FACard d
                                        INNER JOIN ( SELECT FAlterID ,
                                                            FAssetID
                                                     FROM   t_FAAlter
                                                     WHERE  FNew = 1
                                                            AND FAssetID IN (
                                                            SELECT
                                                              FAssetID
                                                            FROM
                                                              t_FAAlter
                                                            WHERE
                                                              FALterNum > 0
                                                              AND ( FYear
                                                              * 100 + FPeriod ) >= ( 201912 )
                                                              AND ( FYear
                                                              * 100 + FPeriod ) <= ( 201912 )
                                                              AND FWorkBookID = 1 )
                                                   ) a ON d.FAlterID = a.FAlterID
                               ) s2 ON s1.FAssetID = s2.FAssetID
        ) t
        INNER JOIN #t_FARptClearList135116497 z ON z.FAssetID = t.FAssetID;
        
        
        
        
UPDATE  #t_FARptClearList135116497
SET     FLeftLife = 0
WHERE   FOrgNum = FNumDec;


--¸ú×ÙÓï¾ä

--·ÖÎö