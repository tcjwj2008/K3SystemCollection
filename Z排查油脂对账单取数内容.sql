
--应收付数据 不包括现销 加实收实付数据
        SELECT  NULL ,
                NULL ,
                '' ,
                '' ,
                '' ,
                '' ,
                '' ,
                '' ,
                '' ,
                b.FDepartment ,
                b.FEmployee ,
                '' ,
                '' ,
                0 ,
                0 ,
                0 ,
                0 ,
                '' ,
                SUM(b.famountfor) ,
                SUM(b.famount) ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                SUM(b.FAmountFor) FEndBalanceFor ,
                SUM(b.FAmount) FEndBalance ,
                0 FBillID ,
                0 FType ,
                0 FPre ,
                b.FYear FYear ,
                b.FPeriod FPeriod ,
                b.FCurrencyID ,
                b.FCustomer ,
                '' AS FSettleName ,
                '' AS FSettleNo
        FROM    ( SELECT    b.FDate ,
                            b.FFincDate ,
                            b.FAmount ,
                            b.FAmountFor ,
                            b.FIsinit ,
                            b.FType ,
                            b.FCustomer ,
                            b.FEmployee ,
                            b.FInvoiceType ,
                            b.FDepartment ,
                            b.FRP ,
                            b.FPeriod ,
                            b.FYear ,
                            b.FStatus ,
                            b.FItemClassID ,
                            b.FCurrencyID ,
                            ( CASE b.FIsinit
                                WHEN 1 THEN s1.FAccountID
                                ELSE ( CASE WHEN b.FType >= 1
                                                 AND b.FType <= 2
                                            THEN s2.FAccountID
                                            WHEN b.FType = 3
                                            THEN s3.FCussentAcctID
                                            WHEN b.FType = 4
                                            THEN s3.FCussentAcctID
                                            ELSE b.FAccountID
                                       END )
                              END ) FAccountID
                  FROM      t_rp_contact b
                            LEFT JOIN t_rp_begData s1 ON b.FBegID = s1.FInterID
                                                         AND b.FIsinit = 1
                            LEFT JOIN t_rp_arpbill s2 ON b.FRPBillID = s2.FBillID
                                                         AND b.FType = 1
                            LEFT JOIN icsale s3 ON b.FInvoiceID = s3.FInterID
                                                   AND b.FType = 3
                  WHERE     b.FRP = 1
                            AND b.FType IN ( 1, 3, 11, 13, 9 )
                            AND ISNULL(s3.FCancellation, 0) <> 1
                ) b
                JOIN t_item k ON b.FCustomer = k.FItemID
                LEFT JOIN t_item d ON b.FDepartment = d.FItemID
                LEFT JOIN t_item e ON b.FEmployee = e.FItemID
                LEFT JOIN t_account t ON b.FAccountID = t.FAccountID
        WHERE   b.FRP = 1
                AND b.FItemClassID = 1
                AND b.FCurrencyID = 1
                AND k.FNumber >= '01.011'
                AND k.FNumber <= '01.011'
                AND b.FInvoiceType NOT IN ( 3, 4 )
                AND b.FDate >= '2019-09-01'
                AND b.FDate <= '2019-09-30 23:59:59'
                AND b.FType IN ( 1, 2, 3, 4 )
                AND FIsinit <> 1
        GROUP BY b.FDepartment ,
                b.FEmployee ,
                b.fyear ,
                b.fperiod ,
                b.FCurrencyID ,
                b.fcustomer
                
                
                
          --spk3_2tab @sname='t_rp_systemEnum'      
                
                
                
                
        UNION ALL
--实收实付（包括收付款，退款，预收付） 
        SELECT  b.FDate ,
                b.FFincDate ,
                b.FBillTypeName ,
                b.FNumber ,
                b.FDetailBillTypeName AS FDetailBillTypeName ,
                b.FVoucherNo ,
                b.FJSBillNo ,
                t.fName ,
                CASE b.FIsBad
                  WHEN 1 THEN '坏账收回'
                  ELSE b.FExplanation
                END AS FExplanation ,
                b.FDepartment ,
                b.FEmployee ,
                b.FContractNo ,
                d.FName ,
                b.fClasstypeID ,
                0 ,
                b.FInterID ,
                b.FSubsystemid ,
                e.fName ,
                SUM(CASE b.FISBAD
                      WHEN 1 THEN ISNULL(tb.FAmountFor, 0)
                      ELSE 0
                    END) AS FAmountFor ,
                SUM(CASE b.FISBAD
                      WHEN 1 THEN ISNULL(tb.FAmount, 0)
                      ELSE 0
                    END) AS FAmount ,
                SUM(b.FAmountFor) AS ReceiveAmountFor ,
                SUM(b.FAmount) AS ReceiveAmount ,
                0 ,
                0 ,
                0 AS FSumSort ,
                SUM(CASE b.FISBAD
                      WHEN 1 THEN ISNULL(tb.FAmountFor, 0)
                      ELSE 0
                    END) - SUM(b.FAmountFor) FEndBalanceFor ,
                SUM(CASE b.FISBAD
                      WHEN 1 THEN ISNULL(tb.FAmount, 0)
                      ELSE 0
                    END) - SUM(b.FAmount) FEndBalance ,
                0 FBillID ,
                CASE WHEN MIN(b.FClassTypeID) IN ( 1000016, 1000005 ) THEN 2
                     WHEN MIN(b.FClassTypeID) IN ( 1000017, 1000015 ) THEN 3
                     ELSE 4
                END FType ,
                0 FPre ,
                b.FYear FYear ,
                b.FPeriod FPeriod ,
                b.FCurrencyID ,
                b.FCustomer ,
                b.FSettleName ,
                b.FSettleNo
        FROM    ( SELECT    b.FClassTypeID ,
                            b.FBillID AS FInterID ,
                            0 AS FID ,
                            b.FYear ,
                            b.FPeriod ,
                            b.FRP AS FRP ,
                            ( CASE WHEN b.FRP = 0 THEN 6
                                   ELSE 5
                              END ) AS FType ,
                            b.FDate AS FDate ,
                            ISNULL(b.FFincDate, b.FDate) AS FFincDate ,
                            b.FNumber AS FNumber ,
                            b.FPre ,
                            b.FCustomer AS FCustomer ,
                            b.FDepartment AS FDepartment ,
                            b.FEmployee AS FEmployee ,
                            b.FCurrencyID ,
                            b.FExchangeRate ,
                            b.FContractNo ,
                            CASE WHEN b.FPre = -1
                                 THEN ( -1 ) * ( ISNULL(a.FSettleAmount, 0)
                                                 + ISNULL(a.FDiscount, 0) )
                                 ELSE ISNULL(a.FSettleAmount, 0)
                                      + ISNULL(a.FDiscount, 0)
                            END FAmount ,
                            CASE WHEN b.FPre = -1
                                 THEN ( -1 ) * ( ISNULL(a.FSettleAmountFor, 0)
                                                 + ISNULL(a.FDiscountFor, 0) )
                                 ELSE ISNULL(a.FSettleAmountFor, 0)
                                      + ISNULL(a.FDiscountFor, 0)
                            END FAmountFor ,
                            CASE WHEN b.FPre = -1
                                 THEN ( -1 ) * a.FRemainAmount
                                 ELSE a.FRemainAmount
                            END FRemainAmount ,
                            CASE WHEN b.FPre = -1
                                 THEN ( -1 ) * a.FRemainAmountFor
                                 ELSE a.FRemainAmountFor
                            END FRemainAmountFor ,
                            ISNULL(ct.Fisbad, 0) AS FIsBad ,
                            b.FVoucherID AS FVoucherID ,
                            v.FGroupID AS FGroupID ,
                            a.FAccountID AS FAccountID ,
                            0 AS FIsInit ,
                            b.FStatus AS FStatus ,
                            b.FBillType AS FDetailBillType ,
                            c1.FName AS FDetailBillTypeName ,
                            0 AS FInvoiceType ,
                            b.FItemClassID ,
                            b.FExplanation FExplanation ,
                            b.FSubSystemID ,
                            0 AS FTranType ,
                            CAST(v1.FName AS NVARCHAR(30)) + '-'
                            + CAST(v.FNumber AS NVARCHAR(30)) AS FVoucherNo ,
                            bt.FName AS FBillTypeName ,
                            '' AS FJSBillNo ,
                            s.FName AS FSettleName ,
                            b.FSettleNo AS FSettleNo
                  FROM      t_rp_newreceivebill b
                            JOIN t_rp_contact ct ON ct.FBillID = b.FBillID
                                                    AND ct.FType = 5
                            JOIN t_rp_arbillofsh a ON b.fbillid = a.fbillid
                            LEFT JOIN t_rp_billType bt ON b.FClasstypeid = bt.FID
                            LEFT JOIN t_voucher v ON b.FVoucherID = v.FVoucherID
                            LEFT JOIN t_VoucherGroup v1 ON v.FGroupID = v1.FGroupID
                            LEFT JOIN t_rp_systemEnum c1 ON b.FBillType = c1.FItemID
                            LEFT JOIN t_Settle s ON b.FSettle = s.FItemID
                  WHERE     ( b.FSubSystemID = 0
                              OR ( b.FSubSystemID = 1
                                   AND fconfirm = 1
                                 )
                            )
                            AND b.FRP = 1
                            AND b.FDate >= '2019-09-01'
                            AND b.FDate <= '2019-09-30 23:59:59'
                ) b
                JOIN t_item k ON b.FCustomer = k.FItemID
                LEFT JOIN t_item d ON b.FDepartment = d.FItemID
                LEFT JOIN t_item e ON b.FEmployee = e.FItemID
                LEFT JOIN t_account t ON b.FAccountID = t.FAccountID
                LEFT JOIN ( SELECT  FReContactID ,
                                    SUM(FAmount) AS FAmount ,
                                    SUM(FAmountFor) AS FAmountFor
                            FROM    t_RP_NewBadDebt
                            WHERE   ISNULL(FType, 0) = 0
                                    AND FReContactID > 0
                            GROUP BY FReContactID
                          ) tb ON b.FInterID = tb.FReContactID
        WHERE   b.FRP = 1
                AND b.FItemClassID = 1
                AND b.FCurrencyID = 1
                AND k.FNumber >= '01.011'
                AND k.FNumber <= '01.011'
                AND b.FDate >= '2019-09-01'
                AND b.FDate <= '2019-09-30 23:59:59'
        GROUP BY b.fdate ,
                b.ffincdate ,
                b.fbilltypename ,
                b.fnumber ,
                b.FDetailBillTypeName ,
                b.fvoucherno ,
                b.FJSBillNo ,
                t.fname ,
                b.fexplanation ,
                b.FDepartment ,
                b.FEmployee ,
                b.FIsBad ,
                b.FContractNo ,
                d.FName ,
                b.fclasstypeid ,
                b.finterid ,
                b.fsubsystemid ,
                e.fname ,
                b.fyear ,
                b.fperiod ,
                b.FCurrencyID ,
                b.fcustomer ,
                b.FSettleName ,
                b.FSettleNo
        UNION ALL 

--调汇记录 
        SELECT  p.FEndDate ,
                p.FEndDate ,
                '调汇记录小计' ,
                '调汇序号:' + CAST(b.FAdjustID AS NVARCHAR(30)) AS FBillNo ,
                '' DetailTypeName ,
                CAST(v1.FName AS NVARCHAR(10)) + '-'
                + CAST(v.FNumber AS NVARCHAR(10)) AS FVoucherNo ,
                '' AS FJSBillNo ,
                t.FName AccountName ,
                CAST(p.FYear AS NVARCHAR(4)) + '年'
                + CAST(p.FPeriod AS NVARCHAR(2)) + '月期末调汇' AS FNote ,
                b.FDepartment ,
                b.FEmployee ,
                '' ,
                d.FName ,
                -91314 FClassTypeID ,
                0 FTranType ,
                b.FInterID ,
                0 ,
                e.FName ,
                SUM(CASE WHEN b.FRP = 1
                         THEN CASE WHEN b.FAccountID > 0
                                   THEN CASE WHEN b.FDC = 1
                                             THEN b.FAdjustAmountFor
                                             ELSE 0
                                        END
                                   ELSE b.FAdjustAmountFor
                              END
                         ELSE CASE WHEN b.FAccountID > 0
                                   THEN CASE WHEN b.FDC = -1
                                             THEN b.FAdjustAmountFor
                                             ELSE 0
                                        END
                                   ELSE b.FAdjustAmountFor
                              END
                    END) ,
                SUM(CASE WHEN b.FRP = 1
                         THEN CASE WHEN b.FAccountID > 0
                                   THEN CASE WHEN b.FDC = 1
                                             THEN b.FAdjustAmount
                                             ELSE 0
                                        END
                                   ELSE b.FAdjustAmount
                              END
                         ELSE CASE WHEN b.FAccountID > 0
                                   THEN CASE WHEN b.FDC = -1
                                             THEN b.FAdjustAmount
                                             ELSE 0
                                        END
                                   ELSE b.FAdjustAmount
                              END
                    END) ,
                SUM(CASE WHEN b.FRP = 1
                         THEN CASE WHEN b.FAccountID > 0
                                   THEN CASE WHEN b.FDC = -1
                                             THEN b.FAdjustAmountFor
                                             ELSE 0
                                        END
                                   ELSE 0
                              END
                         ELSE CASE WHEN b.FAccountID > 0
                                   THEN CASE WHEN b.FDC = 1
                                             THEN b.FAdjustAmountFor
                                             ELSE 0
                                        END
                                   ELSE 0
                              END
                    END) ,
                SUM(CASE WHEN b.FRP = 1
                         THEN CASE WHEN b.FAccountID > 0
                                   THEN CASE WHEN b.FDC = -1
                                             THEN b.FAdjustAmount
                                             ELSE 0
                                        END
                                   ELSE 0
                              END
                         ELSE CASE WHEN b.FAccountID > 0
                                   THEN CASE WHEN b.FDC = 1
                                             THEN b.FAdjustAmount
                                             ELSE 0
                                        END
                                   ELSE 0
                              END
                    END) ,
                0 ,
                0 ,
                0 ,
                SUM(CASE WHEN b.FRP = 1
                         THEN CASE WHEN b.FAccountID > 0
                                   THEN CASE WHEN b.FDC = 1
                                             THEN b.FAdjustAmountFor
                                             ELSE 0
                                        END
                                   ELSE b.FAdjustAmountFor
                              END
                         ELSE CASE WHEN b.FAccountID > 0
                                   THEN CASE WHEN b.FDC = -1
                                             THEN b.FAdjustAmountFor
                                             ELSE 0
                                        END
                                   ELSE b.FAdjustAmountFor
                              END
                    END)
                - SUM(CASE WHEN b.FRP = 1
                           THEN CASE WHEN b.FAccountID > 0
                                     THEN CASE WHEN b.FDC = -1
                                               THEN b.FAdjustAmountFor
                                               ELSE 0
                                          END
                                     ELSE 0
                                END
                           ELSE CASE WHEN b.FAccountID > 0
                                     THEN CASE WHEN b.FDC = 1
                                               THEN b.FAdjustAmountFor
                                               ELSE 0
                                          END
                                     ELSE 0
                                END
                      END) ,
                SUM(CASE WHEN b.FRP = 1
                         THEN CASE WHEN b.FAccountID > 0
                                   THEN CASE WHEN b.FDC = 1
                                             THEN b.FAdjustAmount
                                             ELSE 0
                                        END
                                   ELSE b.FAdjustAmount
                              END
                         ELSE CASE WHEN b.FAccountID > 0
                                   THEN CASE WHEN b.FDC = -1
                                             THEN b.FAdjustAmount
                                             ELSE 0
                                        END
                                   ELSE b.FAdjustAmount
                              END
                    END)
                - SUM(CASE WHEN b.FRP = 1
                           THEN CASE WHEN b.FAccountID > 0
                                     THEN CASE WHEN b.FDC = -1
                                               THEN b.FAdjustAmount
                                               ELSE 0
                                          END
                                     ELSE 0
                                END
                           ELSE CASE WHEN b.FAccountID > 0
                                     THEN CASE WHEN b.FDC = 1
                                               THEN b.FAdjustAmount
                                               ELSE 0
                                          END
                                     ELSE 0
                                END
                      END) ,
                0 FBillID ,
                3 ,
                0 ,
                b.FYear ,
                b.FPeriod ,
                1 FCurrencyID ,
                b.FCustomer ,
                '' AS FSettleName ,
                '' AS FSettleNo
        FROM    t_rp_adjustaccount b
                LEFT JOIN t_PeriodDate p ON b.FYear = p.FYear
                                            AND b.FPeriod = p.FPeriod
                LEFT JOIN t_voucher v ON b.FVoucherID = v.FVoucherID
                LEFT JOIN t_VoucherGroup v1 ON v.FGroupID = v1.FGroupID
                JOIN t_item k ON b.FCustomer = k.FItemID
                LEFT JOIN t_item d ON b.FDepartment = d.FItemID
                LEFT JOIN t_item e ON b.FEmployee = e.FItemID
                LEFT JOIN t_account t ON b.FAccountID = t.FAccountID
        WHERE   b.FRP = 1
                AND b.FItemClassID = 1
                AND b.FCurrencyID = 1
                AND k.FNumber >= '01.011'
                AND k.FNumber <= '01.011'
                AND p.FEndDate >= '2019-09-01'
                AND p.FEndDate <= '2019-09-30 23:59:59'
        GROUP BY p.FEndDate ,
                v1.FName ,
                v.FNumber ,
                t.FName ,
                d.FName ,
                b.FInterID ,
                e.FName ,
                b.fyear ,
                b.fperiod ,
                b.FDepartment ,
                b.FEmployee ,
                b.fcustomer ,
                b.FAdjustID ,
                p.FYear ,
                p.FPeriod
        UNION ALL 

--坏账损失 
        SELECT  b.FDate ,
                b.FFincdate ,
                '坏账损失' AS FBillTypeName ,
                b.fnumber ,
                '' ,
                CAST(v1.FName AS NVARCHAR(30)) + '-'
                + CAST(v.FNumber AS NVARCHAR(30)) ,
                '' AS FJSBillNo ,
                t.FName ,
                b.FExplanation ,
                b.FDepartment ,
                b.FEmployee ,
                '' ,
                d.fName ,
                0 ,
                0 ,
                0 ,
                0 ,
                e.fname ,
                -SUM(b.FAmountFor) AS FAmountFor ,
                -SUM(b.FAmount) AS FAmount ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 AS FSumSort ,
                -SUM(b.FAmountFor) FEndBalanceFor ,
                -SUM(b.FAmount) FEndBalance ,
                0 FBillID ,
                8 FType ,
                0 FPre ,
                b.FYear FYear ,
                b.FPeriod FPeriod ,
                b.FCurrencyID ,
                b.FCustomer ,
                '' AS FSettleName ,
                '' AS FSettleNo
        FROM    t_rp_contact b
                LEFT JOIN t_voucher v ON b.FVoucherID = v.FVoucherID
                LEFT JOIN t_VoucherGroup v1 ON v.FGroupID = v1.FGroupID
                JOIN t_item k ON b.FCustomer = k.FItemID
                LEFT JOIN t_item d ON b.FDepartment = d.FItemID
                LEFT JOIN t_item e ON b.FEmployee = e.FItemID
                LEFT JOIN t_account t ON b.FAccountID = t.FAccountID
        WHERE   b.FRP = 1
                AND b.FItemClassID = 1
                AND b.FCurrencyID = 1
                AND k.FNumber >= '01.011'
                AND k.FNumber <= '01.011'
                AND b.FType = 8
                AND b.FIsinit <> 1
                AND b.FDate >= '2019-09-01'
                AND b.FDate <= '2019-09-30 23:59:59'
        GROUP BY b.fdate ,
                b.ffincdate ,
                b.fnumber ,
                CAST(v1.FName AS NVARCHAR(30)) + '-'
                + CAST(v.FNumber AS NVARCHAR(30)) ,
                b.FDepartment ,
                b.FEmployee ,
                t.fname ,
                b.fexplanation ,
                d.FName ,
                b.FCurrencyID ,
                e.fname ,
                b.fyear ,
                b.fperiod ,
                b.fcustomer
        UNION ALL 

--应收冲应付 
        SELECT  b.FDate ,
                b.FFincdate ,
                '应收冲应付' AS FBillTypeName ,
                '' ,
                '应收款冲抵应付款' ,
                CAST(v1.FName AS NVARCHAR(30)) + '-'
                + CAST(v.FNumber AS NVARCHAR(30)) ,
                '' AS FJSBillNo ,
                t.FName ,
                b.FExplanation ,
                b.FDepartment ,
                b.FEmployee ,
                '' ,
                d.FName ,
                0 ,
                0 ,
                0 ,
                0 ,
                e.fname ,
                0 AS FAmountFor ,
                0 AS FAmount ,
                SUM(b.FAmountFor) ,
                SUM(b.FAmount) ,
                0 ,
                0 ,
                0 AS FSumSort ,
                -SUM(b.FAmountFor) FEndBalanceFor ,
                -SUM(b.FAmount) FEndBalance ,
                0 FBillID ,
                9 FType ,
                0 FPre ,
                b.FYear FYear ,
                b.FPeriod FPeriod ,
                b.FCurrencyID ,
                b.FCustomer ,
                '' AS FSettleName ,
                '' AS FSettleNo
        FROM    t_rp_contact b
                LEFT JOIN t_voucher v ON b.FVoucherID = v.FVoucherID
                LEFT JOIN t_VoucherGroup v1 ON v.FGroupID = v1.FGroupID
                JOIN t_item k ON b.FCustomer = k.FItemID
                LEFT JOIN t_item d ON b.FDepartment = d.FItemID
                LEFT JOIN t_item e ON b.FEmployee = e.FItemID
                LEFT JOIN t_account t ON b.FAccountID = t.FAccountID
        WHERE   b.FRP = 1
                AND b.FItemClassID = 1
                AND b.FCurrencyID = 1
                AND k.FNumber >= '01.011'
                AND k.FNumber <= '01.011'
                AND b.FType IN ( 9, 101 )
                AND b.FIsinit <> 1
                AND b.FDate >= '2019-09-01'
                AND b.FDate <= '2019-09-30 23:59:59'
        GROUP BY b.fdate ,
                b.ffincdate ,
                b.fnumber ,
                CAST(v1.FName AS NVARCHAR(30)) + '-'
                + CAST(v.FNumber AS NVARCHAR(30)) ,
                b.FDepartment ,
                b.FEmployee ,
                t.fname ,
                b.fexplanation ,
                d.FName ,
                b.FCurrencyID ,
                e.fname ,
                b.fyear ,
                b.fperiod ,
                b.fcustomer
        UNION ALL 

--已出库未开票 
        SELECT  b.FDate ,
                ISNULL(v.FDate, b.FDate) FFincDate ,
                '销售出库单' FBillTypeName ,
                b.FBillNO FNumber ,
                '' FDetailBillTypeName ,
                CAST(v1.FName AS NVARCHAR(30)) + '-'
                + CAST(v.FNumber AS NVARCHAR(30)) AS FVoucherNo ,
                '' AS FJSBillNo ,
                t.fName ,
                b.FExplanation ,
                b.FDeptID ,
                b.FEmpID ,
                '' ,
                d.FName ,
                0 FClasstypeID ,
                b.FTrantype ,
                b.FInterID ,
                0 FSubsystemid ,
                e.fName ,
                SUM(CASE WHEN a.FQty = 0 THEN a.FConsignAmount
                         ELSE ( a.FQty - ISNULL(tz.FHookQty, 0) )
                              * a.FConsignAmount / a.FQty
                    END) ,
                SUM(CASE WHEN a.FQty = 0 THEN a.FConsignAmount
                         ELSE ( a.FQty - ISNULL(tz.FHookQty, 0) )
                              * a.FConsignAmount / a.FQty
                    END) ,
                0 ,
                0 ,
                0 ,
                0 ,
                0 ,
                SUM(CASE WHEN a.FQty = 0 THEN a.FConsignAmount
                         ELSE ( a.FQty - ISNULL(tz.FHookQty, 0) )
                              * a.FConsignAmount / a.FQty
                    END) FEndBalanceFor ,
                SUM(CASE WHEN a.FQty = 0 THEN a.FConsignAmount
                         ELSE ( a.FQty - ISNULL(tz.FHookQty, 0) )
                              * a.FConsignAmount / a.FQty
                    END) FEndBalance ,
                0 FBillID ,
                5 FType ,
                0 FPre ,
                ISNULL(tp.FYear, 0) FYear ,
                ISNULL(tp.FPeriod, 0) FPeriod ,
                1 FCurrencyID ,
                b.FSupplyID ,
                '' AS FSettleName ,
                '' AS FSettleNo
        FROM    ICStockBill b
                JOIN ICStockBillEntry a ON a.FInterID = b.FInterID
                                           AND b.FDate >= '2019-09-01'
                                           AND b.FDate <= '2019-09-30 23:59:59'
                INNER JOIN t_perioddate tp ON b.FDate >= tp.FStartDate
                                              AND b.FDate <= tp.FEndDate
                LEFT JOIN t_Voucher v ON b.FVchInterID = v.FVoucherID
                LEFT JOIN t_VoucherGroup v1 ON v.FGroupID = v1.FGroupID
                JOIN t_item k ON b.FSupplyID = k.FItemID
                LEFT JOIN t_item d ON b.FDeptID = d.FItemID
                LEFT JOIN t_item e ON b.FEmpID = e.FItemID
                LEFT JOIN t_account t ON b.FCussentAcctID = t.FAccountID
                LEFT JOIN ( SELECT  fibinterid ,
                                    fentryid ,
                                    SUM(fhookqty) AS fhookqty
                            FROM    icHookRelations
                            WHERE   FIBTag = 1
                                    AND ftrantype <> 1002523
                                    AND ( Fyear * 12 + FPeriod ) <= 24237
                            GROUP BY fibinterid ,
                                    fentryid
                          ) tz ON b.finterid = tz.fibinterid
                                  AND a.fentryid = tz.fentryid
                LEFT JOIN ( SELECT  fibinterid
                            FROM    icHookRelations
                            WHERE   FIBTag = 1
                                    AND ftrantype <> 1002523
                                    AND FEquityHook = 1
                                    AND ( Fyear * 12 + FPeriod ) <= 24237
                          ) ty ON b.finterid = ty.fibinterid
        WHERE   1 = 1
                AND 1 = 1
                AND 1 = 1
                AND k.FNumber >= '01.011'
                AND k.FNumber <= '01.011'
                AND b.FTranType = 21
                AND b.FCancellation <> 1
                AND NOT EXISTS ( SELECT 1
                                 FROM   ICHookRelations
                                 WHERE  FIBTag = 4
                                        AND FIBInterID = b.finterid
                                        AND FTranType = 21 )
                AND b.FDate >= '2019-09-01'
                AND b.FDate <= '2019-09-30 23:59:59'
                AND ( CASE WHEN a.FQty = 0 THEN a.FConsignAmount
                           ELSE ( a.FQty - ISNULL(tz.FHookQty, 0) )
                                * a.FConsignAmount / a.FQty
                      END ) <> 0
                AND ty.fibinterid IS NULL
        GROUP BY b.fdate ,
                v.fdate ,
                b.FBillNO ,
                v1.FName ,
                v.FNumber ,
                t.fname ,
                b.fexplanation ,
                b.FDeptID ,
                b.FEmpID ,
                d.FName ,
                b.ftrantype ,
                b.finterid ,
                e.fname ,
                tp.fyear ,
                tp.fperiod ,
                b.FSupplyID