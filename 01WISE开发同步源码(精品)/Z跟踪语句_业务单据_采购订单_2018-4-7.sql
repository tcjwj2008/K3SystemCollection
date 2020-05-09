SELECT  *
FROM    t_TableDescription
WHERE   FtableName = 'POOrder'
SELECT  *
FROM    t_FieldDescription
WHERE   FTableID = 200004
ORDER BY ffieldname
SELECT  *
FROM    t_TableDescription
WHERE   FtableName = 'POOrderEntry'
SELECT  *
FROM    t_FieldDescription
WHERE   FTableID = 200005
ORDER BY ffieldname

DECLARE @p2 INT
SET @p2 = 1142
EXEC GetICMaxNum 'POOrder', @p2 OUTPUT, 1, 16394
SELECT  @p2

INSERT  INTO POOrderEntry
        ( FInterID ,
          FEntryID ,
          FBrNo ,
          FMapNumber ,
          FMapName ,
          FItemID ,
          FAuxPropID ,
          FQty ,
          FUnitID ,
          FAuxQty ,
          FSecCoefficient ,
          FSecQty ,
          Fauxprice ,
          FAuxTaxPrice ,
          FAmount ,
          FTaxRate ,
          FAuxPriceDiscount ,
          FDescount ,
          FCess ,
          FTaxAmount ,
          FAllAmount ,
          Fdate ,
          Fnote ,
          FSourceBillNo ,
          FSourceTranType ,
          FSourceInterId ,
          FSourceEntryID ,
          FContractBillNo ,
          FContractInterID ,
          FContractEntryID ,
          FMrpLockFlag ,
          FReceiveAmountFor_Commit ,
          FPlanMode ,
          FMTONo ,
          FSupConfirm ,
          FSupConDate ,
          FSupConMem ,
          FSupConFetchDate ,
          FSupConfirmor ,
          FPRInterID ,
          FPREntryID ,
          FEntryAccessoryCount ,
          FCheckMethod ,
          FIsCheck ,
          FCloseEntryDate ,
          FCloseEntryUser ,
          FCloseEntryCauses ,
          FOutSourceInterID ,
          FOutSourceEntryID ,
          FOutSourceTranType
        )
        SELECT  1142 ,
                1 ,
                '0' ,
                '' ,
                '' ,
                42571 ,
                0 ,
                100000 ,
                39272 ,
                100 ,
                0 ,
                0 ,
                85.47 ,
                100 ,
                8547.01 ,
                0 ,
                100 ,
                0 ,
                17 ,
                1452.99 ,
                10000 ,
                '2018-04-07' ,
                '' ,
                '' ,
                0 ,
                0 ,
                0 ,
                '' ,
                0 ,
                0 ,
                0 ,
                0 ,
                14036 ,
                '' ,
                '' ,
                NULL ,
                '' ,
                NULL ,
                0 ,
                0 ,
                0 ,
                0 ,
                352 ,
                '0' ,
                NULL ,
                0 ,
                '' ,
                0 ,
                0 ,
                0
        UNION ALL
        SELECT  1142 ,
                2 ,
                '0' ,
                '' ,
                '' ,
                42573 ,
                0 ,
                100000 ,
                39272 ,
                100 ,
                0 ,
                0 ,
                85.47 ,
                100 ,
                8547.01 ,
                0 ,
                100 ,
                0 ,
                17 ,
                1452.99 ,
                10000 ,
                '2018-04-07' ,
                '' ,
                '' ,
                0 ,
                0 ,
                0 ,
                '' ,
                0 ,
                0 ,
                0 ,
                0 ,
                14036 ,
                '' ,
                '' ,
                NULL ,
                '' ,
                NULL ,
                0 ,
                0 ,
                0 ,
                0 ,
                352 ,
                '0' ,
                NULL ,
                0 ,
                '' ,
                0 ,
                0 ,
                0 

EXEC p_UpdateBillRelateData 71, 1142, 'POOrder', 'POOrderEntry' 

INSERT  INTO POOrder
        ( FInterID ,
          FBillNo ,
          FBrNo ,
          FTranType ,
          FCancellation ,
          FStatus ,
          FSupplyID ,
          Fdate ,
          FCurrencyID ,
          FCheckDate ,
          FMangerID ,
          FDeptID ,
          FEmpID ,
          FBillerID ,
          FExchangeRateType ,
          FExchangeRate ,
          FPOStyle ,
          FRelateBrID ,
          FMultiCheckDate1 ,
          FMultiCheckDate2 ,
          FMultiCheckDate3 ,
          FMultiCheckDate4 ,
          FMultiCheckDate5 ,
          FMultiCheckDate6 ,
          FSelTranType ,
          FBrID ,
          FExplanation ,
          FSettleID ,
          FSettleDate ,
          FAreaPS ,
          FPOOrdBillNo ,
          FManageType ,
          FSysStatus ,
          FValidaterName ,
          FConsignee ,
          FHeadSelfP0246 ,
          FVersionNo ,
          FChangeDate ,
          FChangeUser ,
          FChangeCauses ,
          FChangeMark ,
          FPrintCount ,
          FDeliveryPlace ,
          FPOMode ,
          FAccessoryCount ,
          FLastAlterBillNo ,
          FPlanCategory ,
          FCloseDate ,
          FCloseUser ,
          FCloseCauses ,
          FEnterpriseID ,
          FSendStatus
        )
        SELECT  1142 ,
                'POORD000001' ,
                '0' ,
                71 ,
                0 ,
                0 ,
                42755 ,
                '2018-04-07' ,
                1 ,
                NULL ,
                0 ,
                35637 ,
                42657 ,
                16394 ,
                1 ,
                1 ,
                252 ,
                0 ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                NULL ,
                0 ,
                0 ,
                '' ,
                0 ,
                '2018-04-07' ,
                20302 ,
                '' ,
                0 ,
                0 ,
                '' ,
                0 ,
                0 ,
                '000' ,
                NULL ,
                0 ,
                '' ,
                '' ,
                0 ,
                '' ,
                36680 ,
                0 ,
                '' ,
                '1' ,
                NULL ,
                0 ,
                '' ,
                0 ,
                0
--FSysStatus系统设置                                                                                                                                                                                                                                                           
UPDATE  POOrder
SET     FSysStatus = 2
WHERE   FInterID = 1142

--附件表
DELETE  t_Accessory
WHERE   FTypeID = 200071
        AND FItemID = 1142
        AND FEntryID = 0 

INSERT  INTO t_Accessory
        ( FTypeID ,
          FItemID ,
          FDesc ,
          FFileName ,
          FFile ,
          FFileSize ,
          FUpLoader ,
          FUpLoadTime ,
          FChecker ,
          FIsPIC ,
          FData ,
          FVersion ,
          FSaveMode ,
          FPage ,
          FEntryID
        )
        SELECT  200071 ,
                1142 ,
                M.Fdesc ,
                M.FFileName ,
                M.FFile ,
                M.FFileSize ,
                M.FUpLoader ,
                M.FUpLoadTime ,
                M.FChecker ,
                M.FIsPIC ,
                M.FData ,
                M.FVersion ,
                M.FSaveMode ,
                M.FPage ,
                0
        FROM    t_Accessory M
                INNER JOIN ( SELECT DISTINCT
                                    ( B.FID )
                             FROM   POOrderEntry A
                                    INNER JOIN ICSampleReqPetitionEntry B ON A.FSourceInterID = B.FID
                                                              AND A.FSourceEntryID = B.FEntryID
                             WHERE  A.FInterID = 1142
                           ) N ON M.FItemID = N.FID
                                  AND M.FTypeID = 2580015
                                  AND M.FEntryID = 0
DELETE  t_Accessory
WHERE   FTypeID = 200071
        AND FItemID = 1142
        AND FEntryID <> 0
INSERT  INTO t_Accessory
        ( FTypeID ,
          FItemID ,
          FDesc ,
          FFileName ,
          FFile ,
          FFileSize ,
          FUpLoader ,
          FUpLoadTime ,
          FChecker ,
          FIsPIC ,
          FData ,
          FVersion ,
          FSaveMode ,
          FPage ,
          FEntryID
        )
        SELECT  200071 ,
                1142 ,
                M.Fdesc ,
                M.FFileName ,
                M.FFile ,
                M.FFileSize ,
                M.FUpLoader ,
                M.FUpLoadTime ,
                M.FChecker ,
                M.FIsPIC ,
                M.FData ,
                M.FVersion ,
                M.FSaveMode ,
                M.FPage ,
                P.FEntryID
        FROM    t_Accessory M
                INNER JOIN ICSampleReqPetitionEntry N ON M.FItemID = N.FID
                                                         AND M.FEntryID = N.FEntryID
                INNER JOIN POOrderEntry P ON N.FID = P.FSourceInterID
                                             AND N.FEntryID = P.FSourceEntryID
        WHERE   P.FInterID = 1142
                AND M.FTypeID = 2580015
                AND P.FSourceTranType = 1007315
                AND M.FEntryID <> 0
                
 --dbo.SpK3_2tab @sName = 't_Accessory' -- varchar(50)
--dbo.SpK3_2str @sName = 't_Accessory' -- varchar(50)
--select * from t_Accessory               
                
                
UPDATE  A
SET     A.FAutoClosed = CASE WHEN A.FReqCommitQty >= A.FQty THEN 1
                             ELSE 0
                        END ,
        A.FClosed = CASE WHEN ( A.FClosed = 1
                                AND A.FAutoClosed = 0
                              ) THEN 1
                         ELSE CASE WHEN A.FReqCommitQty >= A.FQty THEN 1
                                   ELSE 0
                              END
                    END
FROM    ICSampleReqPetitionEntry A
        INNER JOIN POOrderEntry B ON A.FID = B.FSourceInterID
                                     AND A.FEntryID = B.FSourceEntryID
WHERE   B.FInterID = 1142



INSERT  INTO t_Log
        ( FDate ,
          FUserID ,
          FFunctionID ,
          FStatement ,
          FDescription ,
          FMachineName ,
          FIPAddress
        )
VALUES  ( GETDATE() ,
          16394 ,
          'K000101' ,
          3 ,
          '编号为POORD000001的单据保存成功' ,
          'WIN-5579AATH4RN' ,
          '192.168.6.149'
        )
        
        
--dbo.SpK3_2tab @sName = 'ICSampleReqPetitionEntry' -- varchar(50)
--dbo.SpK3_2str @sName = 'ICSampleReqPetitionEntry' -- varchar(50)
--select * from ICSampleReqPetitionEntry