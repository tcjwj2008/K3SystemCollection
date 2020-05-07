SELECT  e.FVoucherID,e.FAccountID,AAA.FNumber,AAA.FName, e.FAmountFor, e.FAmount,
                                                (b.FAmountFor) FAmountFor ,
                                                (b.FAmount) FAmount
FROM    t_CashFlowBal b
        INNER JOIN t_VoucherEntry e ON e.FVoucherID = b.FVoucherID
                                       AND e.FEntryID = b.FEntryID
                                       
                                          LEFT JOIN dbo.t_Account  AAA ON E.FAccountID=AAA.FAccountID  
        INNER JOIN t_Item i ON b.FItemID = i.FItemID
        INNER JOIN ( SELECT FBrNo ,
                            FVoucherID ,
                            FDate ,
                            FYear ,
                            FPeriod ,
                            FGroupID ,
                            FNumber ,
                            FReference ,
                            FExplanation ,
                            FAttachments ,
                            FEntryCount ,
                            FDebitTotal ,
                            FCreditTotal ,
                            FInternalInd ,
                            FChecked ,
                            FPosted ,
                            FPreparerID ,
                            FCheckerID ,
                            FPosterID ,
                            FCashierID ,
                            FHandler ,
                            FOwnerGroupID ,
                            FObjectName ,
                            FParameter ,
                            FSerialNum ,
                            FTranType ,
                            FTransDate ,
                            FFrameWorkID ,
                            FApproveID ,
                            FFootNote ,
                            UUID ,
                            FModifyTime
                     FROM   t_Voucher
                     UNION ALL
                     SELECT FBrNo ,
                            FVoucherID ,
                            FDate ,
                            FYear ,
                            FPeriod ,
                            FGroupID ,
                            FNumber ,
                            FReference ,
                            FExplanation ,
                            FAttachments ,
                            FEntryCount ,
                            FDebitTotal ,
                            FCreditTotal ,
                            FInternalInd ,
                            FChecked ,
                            FPosted ,
                            FPreparerID ,
                            FCheckerID ,
                            FPosterID ,
                            FCashierID ,
                            FHandler ,
                            FOwnerGroupID ,
                            FObjectName ,
                            FParameter ,
                            FSerialNum ,
                            FTranType ,
                            FTransDate ,
                            FFrameWorkID ,
                            FApproveID ,
                            FFootNote ,
                            UUID ,
                            FModifyTime
                     FROM   t_VoucherAdjust
                   ) v ON e.FVoucherID = v.FVoucherID
WHERE   v.FYear * 100 + v.FPeriod >= 201911
        AND v.FYear * 100 + v.FPeriod <= 201911
        AND i.FItemClassID = 9
        AND i.FItemID > 0
        AND i.FNumber < N'CI5'
        AND i.FLevel = 3
--GROUP BY i.FNumber;