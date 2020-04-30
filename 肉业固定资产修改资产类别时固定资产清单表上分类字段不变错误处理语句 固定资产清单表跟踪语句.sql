SELECT  ISNULL(Y.FAlterStatus, 0) AS FAlterStatus ,
        B.FCleared ,
        C.FAssetNumber ,
        C.FAssetName ,
        G.FNumber AS FGroupNumber ,
        G.FName AS FGroupName ,
        AM.FNumber AS FAlterModeNumber ,
        AM.FName AS FAlterModeName ,
        C.FModel ,
        C.FUnit ,
        C.FManufacturer ,
        C.FProductingArea ,
        C.FVender ,
        FEnterDate = ISNULL(a.FDate, '1900-01-01') ,
        C.FBeginUseDate ,
        S.FName AS FStatus ,
        S.FNumber FStatusNumber ,
        FEconomyUse = ISNULL(E.FName, '') ,
        FEconomyUseNumber = ISNULL(E.FNumber, '') ,
        M.FName AS FDeprMethod ,
        ISNULL(L.FName, '') FLocationName ,
        ISNULL(L.FNumber, '') FLocationNumber ,
        CY.FCurrencyID FCyID ,
        CY.FName FCyName ,
        O.FExchRate FExchRate ,
        O.FAmountFor FAmountFor ,
        O.FAmount FAmount ,
        C.FOrgValBuy FEnterOrgVal ,
        C.FAccumDeprBuy FEnterAccumDepr ,
        C.FNum ,
        FOrgVal = ( B.FOrgValP + B.FOrgValInc - B.FOrgValDec ) ,
        FAccumDepr = ( B.FAccumDeprP + B.FAccumDeprInc - B.FAccumDeprDec
                       + B.FDepr ) ,
        FNetVal = ( B.FOrgValP + B.FOrgValInc - B.FOrgValDec )
        - ( B.FAccumDeprP + B.FAccumDeprInc - B.FAccumDeprDec + B.FDepr ) ,
        FDecPre = ( B.FDecPreP + B.FDecPreInc - B.FDecPreDec ) ,
        FNetAmt = ( B.FOrgValP + B.FOrgValInc - B.FOrgValDec )
        - ( B.FAccumDeprP + B.FAccumDeprInc - B.FAccumDeprDec + B.FDepr )
        - ( B.FDecPreP + B.FDecPreInc - B.FDecPreDec ) ,
        C.FResidueVal ,
        B.FDepr ,
        SM.FExplanation ,
        FLeftLife = CASE WHEN C.FLifePeriods - B.FDeprPeriods > 0
                         THEN C.FLifePeriods - B.FDeprPeriods
                         ELSE 0
                    END ,
        FLife = C.FLifePeriods ,
        FJobUnit = CASE ISNULL(Z.FIsWorkload, 0)
                     WHEN 0 THEN '期'
                     ELSE C.FJobUnit
                   END ,
        F1001_FName = I.F1001 ,
        I.* ,/*资产组名称*/
        FTypeName  /*进项税额 by pan */ ,
        C.FIncomeTax ,
        Y.FAssetAcctName ,
        Y.FDeprAcctName ,
        FExpenseAcctNumber = CONVERT(NVARCHAR, FExpenseAcctNumber) ,
        SM.FAlterID ,
        FCostCenterNumber = tcc.FNumber ,
        FCostCenterName = tcc.FName ,
        FWorkCenterNumber = twc.FNumber ,
        FWorkCenterName = twc.FName ,
        FBarCode = tbc.FBarCode
INTO    #A
FROM    t_FABalance B
        JOIN t_FABalCard C ON B.FBalID = C.FBalID
        LEFT JOIN t_FADeprMethod Z ON C.FDeprMethodID = Z.FID
        LEFT JOIN t_FAAlter a ON ( B.FAssetID = a.FAssetID
                                   AND a.FNew = 1
                                   AND B.FWorkBookID = a.FWorkBookID
                                 )
        LEFT JOIN ( SELECT  a.*
                    FROM    ( SELECT    MAX(FAlterID) AS FMax
                              FROM      t_FAAlter
                              WHERE     FYear * 12 + FPeriod <= 24237
                              GROUP BY  FAssetID
                            ) S
                            LEFT JOIN t_FAAlter a ON S.FMax = a.FAlterID
                  ) SM ON a.FAssetID = SM.FAssetID
        LEFT JOIN t_FABalOrgFor O ON ( B.FBalID = O.FBalID )
        LEFT JOIN t_Currency CY ON ( O.FCyID = CY.FCurrencyID )
        JOIN t_FABalCardItem I ON B.FBalID = I.FBalID
        JOIN t_FAGroup G ON C.FGroupID = G.FID
        LEFT JOIN t_FAAlterMode AM ON C.FAlterModeID = AM.FID
        LEFT JOIN t_FAEconomyUse E ON C.FEconomyUseID = E.FID
        LEFT JOIN t_FALocation L ON C.FLocationID = L.FID
        JOIN t_FAStatus S ON C.FStatusID = S.FID
        JOIN t_FADeprMethod M ON C.FDeprMethodID = M.FID
        LEFT JOIN ( SELECT /*资产组名称*/
                            FAlterID ,
                            '' FExpenseAcctNumber ,
                            FAssetAcctName ,
                            FDeprAcctName ,
                            FTypeName ,
                            FAssetID ,
                            FAlterStatus = CASE WHEN FNew = 1 THEN 1
                                                WHEN FCleared = 1 THEN 8
                                                WHEN FCleared = 0
                                                     AND FModule = 'CL' THEN 4
                                                ELSE 2
                                           END ,
                            FWorkCenterID ,
                            FCostCenterID
                    FROM    vw_fa_card
                    WHERE   FAlterID = ( SELECT MAX(FAlterID)
                                         FROM   t_FAAlter
                                         WHERE  t_FAAlter.FAssetID = vw_fa_card.FAssetID
                                                AND ( FYear * 1000 + FPeriod ) <= 2019009
                                       )
                  ) Y ON B.FAssetID = Y.FAssetID
        LEFT JOIN ( SELECT  FAlterID ,
                            FBarCode = '1111'
                    FROM    t_FABarCode
                    GROUP BY FAlterID
                  ) tbc ON Y.FAlterID = tbc.FAlterID
        LEFT JOIN t_WorkCenter twc ON twc.FItemID = Y.FWorkCenterID
        LEFT JOIN t_BASE_CostCenter tcc ON tcc.FItemID = Y.FCostCenterID
WHERE   B.FWorkBookID = 1;
SELECT DISTINCT
        SQ1.FAlterID ,
        FRowOrder = 0 ,
        FBasicRow = 1 ,
        FDeptAuxi = FDeptName ,
        FSumFldInde = -1 ,
        FGrdFldVal = '                                        ' ,
        FBalID ,
        FDeptRate ,
        FDeptNumber AS FDeptNo ,
        FCyID ,
        FIsFirstCy = 1 ,
        FAssetNumber ,
        FAssetName ,
        FGroupName ,
        FTypeName ,
        FModel ,
        FUnit ,
        FAlterModeName ,
        FManufacturer ,
        FProductingArea ,
        FVender ,
        FEnterDate ,
        FBeginUseDate ,
        FStatus ,
        FDeptName ,
        FDeptNumber ,
        FEconomyUse ,
        FDeprMethod ,
        FLocationName ,
        FNum ,
        FCyName ,
        FExchRate ,
        FAmountFor ,
        FAmount ,
        FIncometax ,
        FAccumDepr ,
        FNetVal ,
        FDecPre ,
        FNetAmt ,
        FResidueVal ,
        FDepr ,
        FLife ,
        FLeftLife ,
        FExplanation ,
        FASSETACCTNAME ,
        FDEPRACCTNAME ,
        FExpenseAcctNumber ,
        FCostCenterNumber ,
        FCostCenterName ,
        FWorkCenterNumber ,
        FWorkCenterName ,
        FBarCode ,
        F1001_FName ,
        FGroupNumber ,
        FAlterModeNumber ,
        FStatusNumber ,
        FEconomyUseNumber ,
        FLocationNumber ,
        FJobUnit
INTO    #t_FARptSheet8425190
FROM    ( SELECT    B.* ,
                    ISNULL(T.FNumber, '') FDeptNumber ,
                    ISNULL(T.FName, '') FDeptName ,
                    D.FRate FDeptRate
          FROM      #A B
                    JOIN ( SELECT   D.FBalID ,
                                    D.FRate ,
                                    ( D.FItemClsID ) AS FItemClsID ,
                                    ( D.FItemID ) AS FItemID
                           FROM     t_FABalDept D
                                    JOIN ( SELECT   D.FBalID ,
                                                    MAX(D.FRate) AS FMaxRate
                                           FROM     t_FABalance B
                                                    JOIN t_FABalDept D ON B.FBalID = D.FBalID
                                           WHERE    B.FYear = 2019
                                                    AND B.FPeriod = 9
                                           GROUP BY D.FBalID
                                         ) R ON D.FBalID = R.FBalID
                                                AND D.FRate = R.FMaxRate
                         ) D ON B.FBalID = D.FBalID
                    LEFT JOIN t_Item T ON ( D.FItemClsID = T.FItemClassID
                                            AND D.FItemID = T.FItemID
                                          )
        ) SQ1
WHERE   FCleared = 0
        AND ( FAssetNumber = '1001' )
        AND FDeptRate = 1;
DROP TABLE #A;


--------------------------------------------自己分析语句------------------------------------

SELECT  FBalID ,
        *
FROM    #A
WHERE   FAssetNumber = '1001'
ORDER BY FBalID;



SELECT  B.* ,
        ISNULL(T.FNumber, '') FDeptNumber ,
        ISNULL(T.FName, '') FDeptName ,
        D.FRate FDeptRate
FROM    #A B
        JOIN ( SELECT   D.FBalID ,
                        D.FRate ,
                        ( D.FItemClsID ) AS FItemClsID ,
                        ( D.FItemID ) AS FItemID
               FROM     t_FABalDept D
                        JOIN ( SELECT   D.FBalID ,
                                        MAX(D.FRate) AS FMaxRate
                               FROM     t_FABalance B
                                        JOIN t_FABalDept D ON B.FBalID = D.FBalID
                               WHERE    B.FYear = 2019
                                        AND B.FPeriod = 9
                               GROUP BY D.FBalID
                             ) R ON D.FBalID = R.FBalID
                                    AND D.FRate = R.FMaxRate
             ) D ON B.FBalID = D.FBalID
        LEFT JOIN t_Item T ON ( D.FItemClsID = T.FItemClassID
                                AND D.FItemID = T.FItemID
                              )
WHERE   B.fassetnumber = '1001';





GO

dbo.SpK3_2tab @sName = 't_FAcardMulAlter' -- varchar(50)
--DELETE FROM t_FAcardMulAlter WHERE FAssetNumber='5' and FAlterID=4596
select* from t_FAcardMulAlter where FAssetNumber='5' -- FAlterID=966

select * from t_FACard where FAssetNumber='5'  --最新变动4595


--UPDATE t_FAcardMulAlter SET fgroupid=4 where FAssetNumber='5' AND FAlterID=4595

select FGroupID,* from t_FABalCard where FAssetNumber='5'

select * from t_FAgroup  --办公设备5，电子设备4

select  * from t_FABalance  where FAssetID='5' and FBalID=121940



select FGroupID,* from t_FABalCard where FAssetNumber='5'
update t_FABalCard where FAssetNumber='5'



