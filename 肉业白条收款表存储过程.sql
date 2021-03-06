USE [YXERP];
GO
/****** Object:  StoredProcedure [dbo].[spk3_2_BTSKBM_czq]    Script Date: 04/26/2020 08:56:08 ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
ALTER    PROC [dbo].[spk3_2_BTSKBM_czq] @date DATETIME
AS
    TRUNCATE TABLE BTSKBM_B_czq;      
        
--写入客户：添加肉业和食品客户

    INSERT  INTO BTSKBM_B_czq
            ( 内码 ,
              K3代码 ,
              客户名称 ,
              标记 ,
              账套 ,
              fdate
            )
            SELECT  FItemID ,
                    FNumber ,
                    FName ,
                    '明细' 标记 ,
                    '食品' ,
                    @date
            FROM    AIS_YXSP2.dbo.t_Organization
            WHERE   ( FNumber LIKE '03.%'
                      OR FNumber LIKE '04.%'
                    )
                    AND FDeleted = 0;

    INSERT  INTO BTSKBM_B_czq
            ( 内码 ,
              K3代码 ,
              客户名称 ,
              标记 ,
              账套 ,
              fdate
            )
            SELECT  FItemID ,
                    FNumber ,
                    FName ,
                    '汇总' 标记 ,
                    '食品' ,
                    @date
            FROM    AIS_YXSP2.dbo.t_Item t
            WHERE   ( FNumber LIKE '03.%'
                      OR FNumber LIKE '04.%'
                    )
                    AND t.FItemClassID = 1
                    AND FDetail = 0;  

--更新收营员\市场

    UPDATE  a
    SET     收银员 = ISNULL(t1.F_104, '') ,
            市场 = ISNULL(t1.FAddress, '')
    FROM    BTSKBM_B_czq a
            INNER JOIN AIS_YXSP2.dbo.t_Organization t1 ON a.K3代码 = t1.FNumber;



    INSERT  INTO BTSKBM_B_czq
            ( 内码 ,
              K3代码 ,
              客户名称 ,
              标记 ,
              账套 ,
              fdate
            )
            SELECT  FItemID ,
                    FNumber ,
                    FName ,
                    '明细' 标记 ,
                    '肉业' ,
                    @date
            FROM    AIS_YXRY2.dbo.t_Organization
            WHERE   ( FNumber LIKE '03.%'
                      OR FNumber LIKE '04.%'
                    )
                    AND FDeleted = 0;
 
    INSERT  INTO BTSKBM_B_czq
            ( 内码 ,
              K3代码 ,
              客户名称 ,
              标记 ,
              账套 ,
              fdate
            )
            SELECT  FItemID ,
                    FNumber ,
                    FName ,
                    '汇总' 标记 ,
                    '肉业' ,
                    @date
            FROM    AIS_YXRY2.dbo.t_Item t
            WHERE   ( FNumber LIKE '03.%'
                      OR FNumber LIKE '04.%'
                    )
                    AND t.FItemClassID = 1
                    AND FDetail = 0;    


--处理重复的类别代码(客户以食品账套为主)

    DELETE  FROM BTSKBM_B_czq
    WHERE   K3代码 IN ( SELECT    K3代码
                      FROM      ( SELECT    K3代码 ,
                                            COUNT(*) ff
                                  FROM      BTSKBM_B_czq
                                  WHERE     标记 = '汇总'
                                  GROUP BY  K3代码
                                  HAVING    ( COUNT(*) > 1 )
                                ) t )
            AND 账套 = '肉业';
            
            
            

    DELETE  FROM BTSKBM_B_czq
    WHERE   K3代码 IN ( SELECT    K3代码
                      FROM      ( SELECT    K3代码 ,
                                            COUNT(*) ff
                                  FROM      BTSKBM_B_czq
                                  WHERE     标记 = '明细'
                                  GROUP BY  K3代码
                                  HAVING    ( COUNT(*) > 1 )
                                ) t )
            AND 账套 = '肉业';

--统一收银员和市场

    UPDATE  BTSKBM_B_czq
    SET     收银员 = ''
    WHERE   账套 = '肉业';


--更新收营员\市场
    UPDATE  a
    SET     收银员 = ISNULL(t1.F_106, '') ,
            市场 = ISNULL(t1.FAddress, '')
    FROM    BTSKBM_B_czq a
            INNER JOIN AIS_YXRY2.dbo.t_Organization t1 ON a.K3代码 = t1.FNumber
    WHERE   账套 = '肉业'; 

--以食品账套为准
    UPDATE  a
    SET     a.市场 = b.市场 ,
            a.收银员 = b.收银员
    FROM    BTSKBM_B_czq a
            INNER JOIN ( SELECT SUBSTRING(K3代码, 1, 7) K3代码 ,
                                市场 ,
                                收银员 ,
                                COUNT(*) countNum
                         FROM   BTSKBM_B_czq
                         WHERE  账套 = '食品'  
GROUP BY                        SUBSTRING(K3代码, 1, 7) ,
                                市场 ,
                                收银员
                       ) b ON SUBSTRING(a.K3代码, 1, 7) = b.K3代码
    WHERE   ISNULL(a.市场, '') = '';  



    UPDATE  a
    SET     a.收银员 = b.收银员
    FROM    BTSKBM_B_czq a
            INNER JOIN ( SELECT DISTINCT
                                SUBSTRING(K3代码, 1, 7) K3代码 ,
                                收银员
                         FROM   BTSKBM_B_czq
                         WHERE  收银员 <> ''
                       ) b ON SUBSTRING(a.K3代码, 1, 7) = SUBSTRING(b.K3代码, 1, 7)
    WHERE   a.收银员 = '';
 
 
--修改空的市场 
    UPDATE  a
    SET     a.市场 = b.市场 ,
            a.收银员 = b.收银员
    FROM    BTSKBM_B_czq a
            INNER JOIN ( SELECT DISTINCT
                                SUBSTRING(K3代码, 1, 7) K3代码 ,
                                市场 ,
                                收银员
                         FROM   BTSKBM_B_czq a
                         WHERE  ISNULL(a.市场, '') <> ''
                       ) b ON b.K3代码 = SUBSTRING(a.K3代码, 1, 7)
    WHERE   ISNULL(a.市场, '') = ''; 
 
 
 
 
 --补足市场收银员信息完毕      
        
    EXEC AIS_YXSP2.dbo.SPK3_2GetEndBalance_czq @date;        
    EXEC AIS_YXRY2.dbo.SPK3_2GetEndBalance_czq @date;        
       
       
  
--UPDATE BTSKBM_B_czq SET 前日累欠=0 WHERE 前日累欠 IS NULL         
        
---当日回款明细           
--礼券 FLOAT, 现金收款  FLOAT, 银行存款 FLOAT, [余额(不含当天销售)] FLOAT,        
    UPDATE  BTSKBM_B_czq
    SET     礼券 = ISNULL(t1.FAmountFor, 0) + ISNULL(t2.FAmountFor, 0)        
      
    FROM    BTSKBM_B_czq a
            LEFT JOIN ( SELECT  t2.FNumber ,
                                ISNULL(SUM(t.FAmountFor), 0) AS FAmountFor
                        FROM    AIS_YXRY2.dbo.t_RP_NewReceiveBill t --        LEFT JOIN t_rp_Exchange ON t_RP_NewReceiveBill.FBillID = t_rp_Exchange.FBillID        
                                LEFT  JOIN AIS_YXRY2.dbo.t_ItemClass t1 ON t.FItemClassID = t1.FItemClassID
                                                              AND t1.FItemClassID <> 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Item t2 ON t.FCustomer = t2.FItemID
                                                              AND t2.FItemID <> 0
                        WHERE   ( DATEDIFF(DAY, @date, t.FDate) = 0
                                  AND t.FExplanation LIKE '%礼券%'
                                  AND t1.FName = '客户'
                                )
                                AND t.FClassTypeID = 1000005
                                AND t.FChecker > 0
                                AND ( (t.FSubSystemID = 0
                                      OR t.FConfirm = 1 )
                                    )
                        GROUP BY t2.FNumber
                      ) t1 ON t1.FNumber = a.K3代码
            LEFT JOIN ( SELECT  t2.FNumber ,
                                ISNULL(SUM(t.FAmountFor), 0) AS FAmountFor
                        FROM    AIS_YXSP2.dbo.t_RP_NewReceiveBill t --        LEFT JOIN t_rp_Exchange ON t_RP_NewReceiveBill.FBillID = t_rp_Exchange.FBillID        
                                LEFT  JOIN AIS_YXSP2.dbo.t_ItemClass t1 ON t.FItemClassID = t1.FItemClassID
                                                              AND t1.FItemClassID <> 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_Item t2 ON t.FCustomer = t2.FItemID
                                                              AND t2.FItemID <> 0
                        WHERE   ( DATEDIFF(DAY, @date, t.FDate) = 0
                                  AND t.FExplanation LIKE '%礼券%'
                                  AND t1.FName = '客户'
                                )
                                AND t.FClassTypeID = 1000005
                                AND t.FChecker > 0
                                AND ( (t.FSubSystemID = 0
                                      OR t.FConfirm = 1 )
                                    )
                        GROUP BY t2.FNumber
                      ) t2 ON t2.FNumber = a.K3代码;        
        
    UPDATE  BTSKBM_B_czq
    SET     现金收款 = ISNULL(t1.FAmountFor, 0) + ISNULL(t2.FAmountFor, 0)        
       
    FROM    BTSKBM_B_czq a
            LEFT JOIN ( SELECT  t2.FNumber ,
                                ISNULL(SUM(t.FAmountFor), 0) AS FAmountFor
                        FROM    AIS_YXRY2.dbo.t_RP_NewReceiveBill t --        LEFT JOIN t_rp_Exchange ON t_RP_NewReceiveBill.FBillID = t_rp_Exchange.FBillID        
                                LEFT  JOIN AIS_YXRY2.dbo.t_ItemClass t1 ON t.FItemClassID = t1.FItemClassID
                                                              AND t1.FItemClassID <> 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Item t2 ON t.FCustomer = t2.FItemID
                                                              AND t2.FItemID <> 0
                        WHERE   ( DATEDIFF(DAY, @date, t.FDate) = 0
                                  AND t.FExplanation LIKE '%现金%'
                                  AND t1.FName = '客户'
                                )
                                AND t.FClassTypeID = 1000005
                                AND t.FChecker > 0
                                AND ( (t.FSubSystemID = 0
                                      OR t.FConfirm = 1 )
                                    )
                        GROUP BY t2.FNumber
                      ) t1 ON t1.FNumber = a.K3代码
            LEFT JOIN ( SELECT  t2.FNumber ,
                                ISNULL(SUM(t.FAmountFor), 0) AS FAmountFor
                        FROM    AIS_YXSP2.dbo.t_RP_NewReceiveBill t --        LEFT JOIN t_rp_Exchange ON t_RP_NewReceiveBill.FBillID = t_rp_Exchange.FBillID        
                                LEFT  JOIN AIS_YXSP2.dbo.t_ItemClass t1 ON t.FItemClassID = t1.FItemClassID
                                                              AND t1.FItemClassID <> 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_Item t2 ON t.FCustomer = t2.FItemID
                                                              AND t2.FItemID <> 0
                        WHERE   ( DATEDIFF(DAY, @date, t.FDate) = 0
                                  AND t.FExplanation LIKE '%现金%'
                                  AND t1.FName = '客户'
                                )
                                AND t.FClassTypeID = 1000005
                                AND t.FChecker > 0
                                AND ( (t.FSubSystemID = 0
                                      OR t.FConfirm = 1 )
                                    )
                        GROUP BY t2.FNumber
                      ) t2 ON t2.FNumber = a.K3代码;        
        
        



      
---银行存款修改　：2015-10-12　
           
    UPDATE  BTSKBM_B_czq
    SET     银行存款 = ISNULL(t1.FAmountFor, 0) + ISNULL(t2.FAmountFor, 0)        
--SELECT a.K3代码,t1.FAmountFor        
    FROM    BTSKBM_B_czq a
            LEFT JOIN ( SELECT  t2.FNumber ,
                                ISNULL(SUM(t.FAmountFor), 0) AS FAmountFor
                        FROM    AIS_YXRY2.dbo.t_RP_NewReceiveBill t --        LEFT JOIN t_rp_Exchange ON t_RP_NewReceiveBill.FBillID = t_rp_Exchange.FBillID        
                                LEFT  JOIN AIS_YXRY2.dbo.t_ItemClass t1 ON t.FItemClassID = t1.FItemClassID
                                                              AND t1.FItemClassID <> 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Item t2 ON t.FCustomer = t2.FItemID
                                                              AND t2.FItemID <> 0        
   --WHERE   ( DATEDIFF(Day, @date, t.FDate) = 0  --FFincDate      
                        WHERE   ( DATEDIFF(DAY, @date, t.FFincDate) = 0  --FFincDate      
                                  AND t.FExplanation LIKE '%银行存款%'
                                  AND t1.FName = '客户'
                                )
                                AND t.FClassTypeID = 1000005
                                AND t.FChecker > 0
                                AND ( (t.FSubSystemID = 0
                                      OR t.FConfirm = 1 )
                                    )
                        GROUP BY t2.FNumber
                      ) t1 ON t1.FNumber = a.K3代码
            LEFT JOIN ( SELECT  t2.FNumber ,
                                ISNULL(SUM(t.FAmountFor), 0) AS FAmountFor
                        FROM    AIS_YXSP2.dbo.t_RP_NewReceiveBill t --        LEFT JOIN t_rp_Exchange ON t_RP_NewReceiveBill.FBillID = t_rp_Exchange.FBillID        
                                LEFT  JOIN AIS_YXSP2.dbo.t_ItemClass t1 ON t.FItemClassID = t1.FItemClassID
                                                              AND t1.FItemClassID <> 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_Item t2 ON t.FCustomer = t2.FItemID
                                                              AND t2.FItemID <> 0
                        WHERE   ( DATEDIFF(DAY, @date, t.FFincDate) = 0
                                  AND t.FExplanation LIKE '%银行存款%'
                                  AND t1.FName = '客户'
                                )
                                AND t.FClassTypeID = 1000005
                                AND t.FChecker > 0
                                AND ( (t.FSubSystemID = 0
                                      OR t.FConfirm = 1 )
                                    )
                        GROUP BY t2.FNumber
                      ) t2 ON t2.FNumber = a.K3代码;         
       
       
    
--差额       
       
      
    UPDATE  dbo.BTSKBM_B_czq
    SET     差额 = ISNULL(t1.FAmountFor_2, 0) + ISNULL(t2.FAmountFor_2, 0)
    FROM    BTSKBM_B_czq a
            LEFT JOIN ( SELECT  t2.FNumber ,
                                SUM(ROUND(ISNULL(u.FAmountFor, 0), t1.FScale)) AS FAmountFor_2
                        FROM    AIS_YXRY2.dbo.t_RP_ARPBill v
                                LEFT JOIN AIS_YXRY2.dbo.t_RP_Plan_Ar u ON v.FBillID = u.FBillID
                                                              AND u.FIsInit = 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Currency t1 ON v.FCurrencyID = t1.FCurrencyID
                                                              AND t1.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Item t2 ON v.FCustomer = t2.FItemID
                                                              AND t2.FItemID <> 0
                        WHERE   ( DATEDIFF(DAY, @date, v.FDate) = 0
                                  AND v.FExplanation LIKE '%尾差%'
                                )
                                AND v.FClassTypeID = 1000021
                        GROUP BY t2.FNumber
                      ) t1 ON t1.FNumber = a.K3代码
            LEFT JOIN ( SELECT  t2.FNumber ,
                                SUM(ROUND(ISNULL(u.FAmountFor, 0), t1.FScale)) AS FAmountFor_2
                        FROM    AIS_YXSP2.dbo.t_RP_ARPBill v
                                LEFT JOIN AIS_YXSP2.dbo.t_RP_Plan_Ar u ON v.FBillID = u.FBillID
                                                              AND u.FIsInit = 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_Currency t1 ON v.FCurrencyID = t1.FCurrencyID
                                                              AND t1.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_Item t2 ON v.FCustomer = t2.FItemID
                                                              AND t2.FItemID <> 0
                        WHERE   ( DATEDIFF(DAY, @date, v.FDate) = 0
                                  AND v.FExplanation LIKE '%尾差%'
                                )
                                AND v.FClassTypeID = 1000021
                        GROUP BY t2.FNumber
                      ) t2 ON t2.FNumber = a.K3代码;         
--[余额(不含当天销售)]        
    UPDATE  BTSKBM_B_czq
    SET     [余额(不含当天销售)] = 前日累欠 - 礼券 - 现金收款 - 银行存款 + 差额;         
--折让金额        
    UPDATE  dbo.BTSKBM_B_czq
    SET     折让金额 = ISNULL(t1.FAmountFor_2, 0) + ISNULL(t2.FAmountFor_2, 0)
    FROM    BTSKBM_B_czq a
            LEFT JOIN ( SELECT  t2.FNumber ,
                                ISNULL(SUM(ROUND(ISNULL(u.FAmountFor, 0),
                                                 t1.FScale)), 0) AS FAmountFor_2
                        FROM    AIS_YXRY2.dbo.t_RP_ARPBill v
                                LEFT JOIN AIS_YXRY2.dbo.t_RP_Plan_Ar u ON v.FBillID = u.FBillID
                                                              AND u.FIsInit = 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Currency t1 ON v.FCurrencyID = t1.FCurrencyID
                                                              AND t1.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Item t2 ON v.FCustomer = t2.FItemID
                                                              AND t2.FItemID <> 0
                        WHERE   ( DATEDIFF(DAY, @date, v.FDate) = 0
                                  AND ( v.FExplanation LIKE '%折%'
                                        OR v.FBase IN (
                                        SELECT  FItemID
                                        FROM    AIS_YXRY2.dbo.t_Item
                                        WHERE   FName = '折扣' )
                                      )
                                )
                                AND v.FClassTypeID = 1000021
                        GROUP BY t2.FNumber
                      ) t1 ON t1.FNumber = a.K3代码
            LEFT JOIN ( SELECT  t2.FNumber ,
                                ISNULL(SUM(ROUND(ISNULL(u.FAmountFor, 0),
                                                 t1.FScale)), 0) AS FAmountFor_2
                        FROM    AIS_YXSP2.dbo.t_RP_ARPBill v
                                LEFT JOIN AIS_YXSP2.dbo.t_RP_Plan_Ar u ON v.FBillID = u.FBillID
                                                              AND u.FIsInit = 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_Currency t1 ON v.FCurrencyID = t1.FCurrencyID
                                                              AND t1.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_Item t2 ON v.FCustomer = t2.FItemID
                                                              AND t2.FItemID <> 0
                        WHERE   ( DATEDIFF(DAY, @date, v.FDate) = 0
                                  AND ( v.FExplanation LIKE '%折%'
                                        OR v.Fdisctype IN (
                                        SELECT  FItemID
                                        FROM    AIS_YXSP2.dbo.t_Item
                                        WHERE   FName = '折扣' )
                                      )
                                )
                                AND v.FClassTypeID = 1000021
                        GROUP BY t2.FNumber
                      ) t2 ON t2.FNumber = a.K3代码;         
----当日销售明细        
--带猪头毛白条1级        
--头数 重量 金额        
        
    UPDATE  dbo.BTSKBM_B_czq
    SET     头数1 = ISNULL(t1.FSecQty, 0) + ISNULL(t2.FSecQty, 0) ,
            重量1 = ISNULL(t1.FQty, 0) + ISNULL(t2.FQty, 0) ,
            金额1 = ISNULL(t1.FConsignAmount, 0) + ISNULL(t2.FConsignAmount, 0)
    FROM    dbo.BTSKBM_B_czq a
            LEFT JOIN ( SELECT  t5.K3代码 AS FNumber ,
                                SUM(u1.FConsignAmount + u1.FDiscountAmount) AS FConsignAmount ,
                                SUM(u1.FQty) FQty ,
                                SUM(u1.FSecQty) FSecQty
                        FROM    AIS_YXRY2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXRY2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                LEFT JOIN dbo.BTSKBM_B_czq t5 ON t4.FNumber = t5.K3代码
                                INNER JOIN AIS_YXRY2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
                                LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                        WHERE   1 = 1
                                AND v1.FDate = @date
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                                AND t14.FNumber IN (
                                SELECT  FNumber
                                FROM    AIS_YXRY2.dbo.t_ICItem
                                WHERE   F_106 = 83747 )
                        GROUP BY t5.K3代码
                      ) t1 ON t1.FNumber = a.K3代码
            LEFT JOIN ( SELECT  t4.FNumber ,
                                SUM(u1.FConsignAmount + u1.FDiscountAmount) AS FConsignAmount ,
                                SUM(u1.FQty) FQty ,
                                SUM(u1.FSecQty) FSecQty
                        FROM    AIS_YXSP2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXSP2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
                                LEFT OUTER JOIN AIS_YXSP2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                        WHERE   1 = 1
                                AND v1.FDate = @date
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                                AND t14.FNumber IN (
                                SELECT  FNumber
                                FROM    AIS_YXSP2.dbo.t_ICItem
                                WHERE   F_105 = 83557 )
                        GROUP BY t4.FNumber
                      ) t2 ON t2.FNumber = a.K3代码;                 
--2级        
    UPDATE  dbo.BTSKBM_B_czq
    SET     头数2 = ISNULL(t1.FSecQty, 0) + ISNULL(t2.FSecQty, 0) ,
            重量2 = ISNULL(t1.FQty, 0) + ISNULL(t2.FQty, 0) ,
            金额2 = ISNULL(t1.FConsignAmount, 0) + ISNULL(t2.FConsignAmount, 0)
    FROM    dbo.BTSKBM_B_czq a
            LEFT JOIN ( SELECT  t5.K3代码 AS FNumber ,
                                SUM(u1.FConsignAmount + u1.FDiscountAmount) AS FConsignAmount ,
                                SUM(u1.FQty) FQty ,
                                SUM(u1.FSecQty) FSecQty
                        FROM    AIS_YXRY2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXRY2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                LEFT JOIN dbo.BTSKBM_B_czq t5 ON t4.FNumber = t5.K3代码
                                INNER JOIN AIS_YXRY2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
                                LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                        WHERE   1 = 1
                                AND v1.FDate = @date
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                                AND t14.FNumber IN (
                                SELECT  FNumber
                                FROM    AIS_YXRY2.dbo.t_ICItem
                                WHERE   F_106 = 83748 )
                        GROUP BY t5.K3代码
                      ) t1 ON t1.FNumber = a.K3代码
            LEFT JOIN ( SELECT  t4.FNumber ,
                                SUM(u1.FConsignAmount + u1.FDiscountAmount) AS FConsignAmount ,
                                SUM(u1.FQty) FQty ,
                                SUM(u1.FSecQty) FSecQty
                        FROM    AIS_YXSP2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXSP2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
                                LEFT OUTER JOIN AIS_YXSP2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                        WHERE   1 = 1
                                AND v1.FDate = @date
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                                AND t14.FNumber IN (
                                SELECT  FNumber
                                FROM    AIS_YXSP2.dbo.t_ICItem
                                WHERE   F_105 = 83558 )
                        GROUP BY t4.FNumber
                      ) t2 ON t2.FNumber = a.K3代码;         
--3级        
    UPDATE  dbo.BTSKBM_B_czq
    SET     头数3 = ISNULL(t1.FSecQty, 0) + ISNULL(t2.FSecQty, 0) ,
            重量3 = ISNULL(t1.FQty, 0) + ISNULL(t2.FQty, 0) ,
            金额3 = ISNULL(t1.FConsignAmount, 0) + ISNULL(t2.FConsignAmount, 0)
    FROM    dbo.BTSKBM_B_czq a
            LEFT JOIN ( SELECT  t5.K3代码 AS FNumber ,
                                SUM(u1.FConsignAmount + u1.FDiscountAmount) AS FConsignAmount ,
                                SUM(u1.FQty) FQty ,
                                SUM(u1.FSecQty) FSecQty
                        FROM    AIS_YXRY2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXRY2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                LEFT JOIN dbo.BTSKBM_B_czq t5 ON t4.FNumber = t5.K3代码
                                INNER JOIN AIS_YXRY2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
                                LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                        WHERE   1 = 1
                                AND v1.FDate = @date
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                                AND t14.FNumber IN (
                                SELECT  FNumber
                                FROM    AIS_YXRY2.dbo.t_ICItem
                                WHERE   F_106 = 83749 )
                        GROUP BY t5.K3代码
                      ) t1 ON t1.FNumber = a.K3代码
            LEFT JOIN ( SELECT  t4.FNumber ,
                                SUM(u1.FConsignAmount + u1.FDiscountAmount) AS FConsignAmount ,
                                SUM(u1.FQty) FQty ,
                                SUM(u1.FSecQty) FSecQty
                        FROM    AIS_YXSP2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXSP2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
                                LEFT OUTER JOIN AIS_YXSP2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                        WHERE   1 = 1
                                AND v1.FDate = @date
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                                AND t14.FNumber IN (
                                SELECT  FNumber
                                FROM    AIS_YXSP2.dbo.t_ICItem
                                WHERE   F_105 = 83559 )
                        GROUP BY t4.FNumber
                      ) t2 ON t2.FNumber = a.K3代码;         
--4级        
    UPDATE  dbo.BTSKBM_B_czq
    SET     头数4 = ISNULL(t1.FSecQty, 0) + ISNULL(t2.FSecQty, 0) ,
            重量4 = ISNULL(t1.FQty, 0) + ISNULL(t2.FQty, 0) ,
            金额4 = ISNULL(t1.FConsignAmount, 0) + ISNULL(t2.FConsignAmount, 0)
    FROM    dbo.BTSKBM_B_czq a
            LEFT JOIN ( SELECT  t5.K3代码 AS FNumber ,
                                SUM(u1.FConsignAmount + u1.FDiscountAmount) AS FConsignAmount ,
                                SUM(u1.FQty) FQty ,
                                SUM(u1.FSecQty) FSecQty
                        FROM    AIS_YXRY2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXRY2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                LEFT JOIN dbo.BTSKBM_B_czq t5 ON t4.FNumber = t5.K3代码
                                INNER JOIN AIS_YXRY2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
                                LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                        WHERE   1 = 1
                                AND v1.FDate = @date
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                                AND t14.FNumber IN (
                                SELECT  FNumber
                                FROM    AIS_YXRY2.dbo.t_ICItem
                                WHERE   F_106 = 83750 )
                        GROUP BY t5.K3代码
                      ) t1 ON t1.FNumber = a.K3代码
            LEFT JOIN ( SELECT  t4.FNumber ,
                                SUM(u1.FConsignAmount + u1.FDiscountAmount) AS FConsignAmount ,
                                SUM(u1.FQty) FQty ,
                                SUM(u1.FSecQty) FSecQty
                        FROM    AIS_YXSP2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXSP2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
                                LEFT OUTER JOIN AIS_YXSP2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                        WHERE   1 = 1
                                AND v1.FDate = @date
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                                AND t14.FNumber IN (
                                SELECT  FNumber
                                FROM    AIS_YXSP2.dbo.t_ICItem
                                WHERE   F_105 = 83560 )
                        GROUP BY t4.FNumber
                      ) t2 ON t2.FNumber = a.K3代码;         
--5级        
    UPDATE  dbo.BTSKBM_B_czq
    SET     头数5 = ISNULL(t1.FSecQty, 0) + ISNULL(t2.FSecQty, 0) ,
            重量5 = ISNULL(t1.FQty, 0) + ISNULL(t2.FQty, 0) ,
            金额5 = ISNULL(t1.FConsignAmount, 0) + ISNULL(t2.FConsignAmount, 0)
    FROM    dbo.BTSKBM_B_czq a
            LEFT JOIN ( SELECT  t5.K3代码 AS FNumber ,
                                SUM(u1.FConsignAmount + u1.FDiscountAmount) AS FConsignAmount ,
                                SUM(u1.FQty) FQty ,
                                SUM(u1.FSecQty) FSecQty
                        FROM    AIS_YXRY2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXRY2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                LEFT JOIN dbo.BTSKBM_B_czq t5 ON t4.FNumber = t5.K3代码
                                INNER JOIN AIS_YXRY2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
                                LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                        WHERE   1 = 1
                                AND v1.FDate = @date
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                                AND t14.FNumber IN (
                                SELECT  FNumber
                                FROM    AIS_YXRY2.dbo.t_ICItem
                                WHERE   F_106 = 83751 )
                        GROUP BY t5.K3代码
                      ) t1 ON t1.FNumber = a.K3代码
            LEFT JOIN ( SELECT  t4.FNumber ,
                                SUM(u1.FConsignAmount + u1.FDiscountAmount) AS FConsignAmount ,
                                SUM(u1.FQty) FQty ,
                                SUM(u1.FSecQty) FSecQty
                        FROM    AIS_YXSP2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXSP2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0
                                LEFT OUTER JOIN AIS_YXSP2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                        WHERE   1 = 1
                                AND v1.FDate = @date
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                                AND t14.FNumber IN (
                                SELECT  FNumber
                                FROM    AIS_YXSP2.dbo.t_ICItem
                                WHERE   F_105 = 83561 )
                        GROUP BY t4.FNumber
                      ) t2 ON t2.FNumber = a.K3代码;   
          
          
          
          
        
                
        
    UPDATE  dbo.BTSKBM_B_czq
    SET     当日应付 = [余额(不含当天销售)] + 金额1 + 金额2 + 金额3 + 金额4 + 金额5 + 折让金额; 

 --计算汇总金额 
 
    UPDATE  a
    SET     a.前日累欠 = b.前日累欠 ,
            a.礼券 = b.礼券 ,
            a.现金收款 = b.现金收款 ,
            a.银行存款 = b.银行存款 ,
            a.[余额(不含当天销售)] = b.[余额(不含当天销售)] ,
            a.重量1 = b.重量1 ,
            a.重量2 = b.重量2 ,
            a.重量3 = b.重量3 ,
            a.重量4 = b.重量4 ,
            a.重量5 = b.重量5 ,
            a.金额1 = b.金额1 ,
            a.金额2 = b.金额2 ,
            a.金额3 = b.金额3 ,
            a.金额4 = b.金额4 ,
            a.金额5 = b.金额5 ,
            a.折让金额 = b.折让金额 ,
            a.当日应付 = b.当日应付
    FROM    BTSKBM_B_czq a
            LEFT JOIN ( SELECT  SUBSTRING(K3代码, 1, 7) k3代码 ,
                                SUM(前日累欠) 前日累欠 ,
                                SUM(礼券) 礼券 ,
                                SUM(现金收款) 现金收款 ,
                                SUM(银行存款) 银行存款 ,
                                SUM([余额(不含当天销售)]) [余额(不含当天销售)] ,
                                SUM(重量1) 重量1 ,
                                SUM(重量2) 重量2 ,
                                SUM(重量3) 重量3 ,
                                SUM(重量4) 重量4 ,
                                SUM(重量5) 重量5 ,
                                SUM(金额1) 金额1 ,
                                SUM(金额2) 金额2 ,
                                SUM(金额3) 金额3 ,
                                SUM(金额4) 金额4 ,
                                SUM(金额5) 金额5 ,
                                SUM(折让金额) 折让金额 ,
                                SUM(当日应付) 当日应付
                        FROM    BTSKBM_B_czq
                        WHERE   标记 = '明细'
                        GROUP BY SUBSTRING(k3代码, 1, 7)
                      ) b ON a.K3代码 = b.k3代码
    WHERE   a.标记 = '汇总';






       
    DELETE  dbo.BTSKBM_B_czq
    WHERE   前日累欠 = 0.00
            AND 当日应付 = 0.00
            AND 标记 = '明细'
            AND ( ( ISNULL(金额1, 0) + ISNULL(金额2, 0) + ISNULL(金额3, 0)
                    + ISNULL(金额4, 0) + ISNULL(金额5, 0) ) = 0 );



    DELETE  dbo.BTSKBM_B_czq
    WHERE   标记 = '汇总'
            AND SUBSTRING(K3代码, 1, 7) NOT IN ( SELECT   SUBSTRING(K3代码, 1, 7)
                                               FROM     dbo.BTSKBM_B_czq
                                               WHERE    fdate = @date
                                                        AND 标记 = '明细' );


    
--DELETE dbo.BTSKBM_B_czq WHERE   (金额1+金额2+金额3+金额4+金额5)=0.00  --AND 前日累欠<1      
    UPDATE  BTSKBM_B_czq
    SET     礼券 = NULL
    WHERE   礼券 = 0.00;      
    UPDATE  BTSKBM_B_czq
    SET     现金收款 = NULL
    WHERE   现金收款 = 0.00;      
    UPDATE  BTSKBM_B_czq
    SET     银行存款 = NULL
    WHERE   银行存款 = 0.00;      
    UPDATE  BTSKBM_B_czq
    SET     [余额(不含当天销售)] = NULL
    WHERE   [余额(不含当天销售)] = 0.00;      
    UPDATE  BTSKBM_B_czq
    SET     重量1 = NULL
    WHERE   重量1 = 0.0;      
    UPDATE  BTSKBM_B_czq
    SET     重量2 = NULL
    WHERE   重量2 = 0.0;      
    UPDATE  BTSKBM_B_czq
    SET     重量3 = NULL
    WHERE   重量3 = 0.0;      
    UPDATE  BTSKBM_B_czq
    SET     重量4 = NULL
    WHERE   重量4 = 0.0;      
    UPDATE  BTSKBM_B_czq
    SET     重量5 = NULL
    WHERE   重量5 = 0.0;      
    UPDATE  BTSKBM_B_czq
    SET     金额1 = NULL
    WHERE   金额1 = 0.00;      
    UPDATE  BTSKBM_B_czq
    SET     金额2 = NULL
    WHERE   金额2 = 0.00;      
    UPDATE  BTSKBM_B_czq
    SET     金额3 = NULL
    WHERE   金额3 = 0.00;      
    UPDATE  BTSKBM_B_czq
    SET     金额4 = NULL
    WHERE   金额4 = 0.00;      
    UPDATE  BTSKBM_B_czq
    SET     金额5 = NULL
    WHERE   金额5 = 0.00;      
    UPDATE  BTSKBM_B_czq
    SET     折让金额 = NULL
    WHERE   折让金额 = 0.00;      
    UPDATE  BTSKBM_B_czq
    SET     当日应付 = NULL
    WHERE   当日应付 = 0.00;      
      


    DELETE  BTSKBM
    WHERE   fdate = @date;  
     
    INSERT  INTO BTSKBM
            SELECT  *
            FROM    BTSKBM_B_czq; 