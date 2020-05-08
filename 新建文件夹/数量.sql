
USE AIS_YXRY2
GO 
ALTER    PROC SP_RY_qty_rp
    @Begdate VARCHAR(100) ,
    @Enddate VARCHAR(100) ,
    @FDepnumber VARCHAR(100)
  WITH ENCRYPTION  
AS
     IF @FDepnumber NOT IN ('10.12','10.11','10.13','10.14','10.15','10.16','10.17','10.18','10.19','10.20','10.22')
      SELECT 0.00
    
    
    IF @FDepnumber = '10.12' --白条批发部  
        BEGIN     
            SELECT  CONVERT(DECIMAL(18, 2), )
            FROM    ( SELECT    ISNULL(SUM(u1.FAuxQty), 0) AS FAuxQty --收入                
                      FROM      AIS_YXRY2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXRY2.dbo.t_Stock t8 ON u1.FDCStockID = t8.FItemID
                                                              AND t8.FItemID <> 0
                                LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                      WHERE     1 = 1
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                                AND v1.Fdate >= @begdate
                                AND v1.Fdate <= @enddate                
  --v1.Fdate >= '2014-03-01' AND  v1.Fdate <='2014-03-31'               
                                AND ISNULL(t105.fnumber, '') LIKE '10.12%'  --部门包含BT2              
                                AND ISNULL(t8.FNumber, '') NOT LIKE '%001.02%'  --发货仓库代码不包含001.02              
                    ) t1 --肉业账套供应链销售出库部门为20.205 取销售金额合计              
                
 
        END 
 
    IF @FDepnumber = '10.11' --门店管理部 原 营销一部  
        BEGIN 
---- 营销一部（含税）                
---  肉品产业 对外收入                
------食品账套总账--明细账5101.01+5101.99（折扣）+大小肠收入                
--------B              
--B1               
            SELECT  CONVERT(DECIMAL(18, 2), ISNULL(SUM(ve.FAmountFor), 0.00))
            FROM    AIS_YXSP2.dbo.t_Voucher v
                    INNER JOIN AIS_YXSP2.dbo.t_VoucherGroup vg ON v.FGroupID = vg.FGroupID
                    LEFT OUTER JOIN AIS_YXSP2.dbo.t_VoucherTplType tp ON v.FTranType = tp.FTplTypeID
                    INNER JOIN AIS_YXSP2.dbo.t_VoucherEntry ve ON v.FVoucherID = ve.FVoucherID
                    INNER JOIN AIS_YXSP2.dbo.t_Account a ON ve.FAccountID = a.FAccountID
                    LEFT OUTER JOIN ( SELECT    *
                                      FROM      AIS_YXSP2.dbo.t_Account b
                                    ) b ON ve.FAccountID2 = b.FAccountID
                    INNER JOIN AIS_YXSP2.dbo.t_Currency c ON ve.FCurrencyID = c.FCurrencyID
                    LEFT OUTER JOIN AIS_YXSP2.dbo.t_Settle e ON ve.FSettleTypeID = e.FitemID
                                                              AND e.FitemID <> 0
            WHERE   FDate BETWEEN @begdate AND @enddate
                    AND ( ( a.FNumber >= '5101.01'
                            AND a.FNumber <= '5101.01.zzzzzzz'
                          )
                          OR ( a.FNumber >= '5101.99'
                               AND a.FNumber <= '5101.99.zzzzzzz'
                             )
                        )
                    AND ve.FExplanation NOT LIKE '%营销二部%民兴%'  --摘要是否要改          
                    AND ve.FCurrencyID = 1                
        --AND v.FPosted <> 0 --20140612                
                    AND ve.FDC = 0

        END 
    IF @FDepnumber = '10.13' --加盟开发部 --与原肉品决算表白条批发条件一致,原部门20.205改为10.13 
        BEGIN 
            SELECT  CONVERT(DECIMAL(18, 2), ( ISNULL(t1.FConsignAmount, 0.00)
                                              + ISNULL(t2.FAmountFor, 0.00)
                                              + --T3.FAmountFor_2            
                                              +ISNULL(T4.FAmountFor_2, 0.00) ))
            FROM    ( SELECT    ISNULL(SUM(u1.FConsignAmount), 0) AS FConsignAmount --收入                
                      FROM      AIS_YXRY2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXRY2.dbo.t_Stock t8 ON u1.FDCStockID = t8.FItemID
                                                              AND t8.FItemID <> 0
                                LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                      WHERE     1 = 1
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                                AND v1.Fdate >= @begdate
                                AND v1.Fdate <= @enddate                
  --v1.Fdate >= '2014-03-01' AND  v1.Fdate <='2014-03-31'               
                                AND ISNULL(t105.fnumber, '') LIKE '10.13%'  --部门包含BT2              
                                AND ISNULL(t8.FNumber, '') NOT LIKE '%001.02%'  --发货仓库代码不包含001.02              
                    ) t1 ,--肉业账套供应链销售出库部门为20.205 取销售金额合计              
                    ( SELECT    ISNULL(SUM(ve.FAmountFor), 0) AS FAmountFor
                      FROM      AIS_YXSP2.dbo.t_Voucher v
                                INNER JOIN AIS_YXSP2.dbo.t_VoucherEntry ve ON v.FVoucherID = ve.FVoucherID
                                INNER JOIN AIS_YXSP2.dbo.t_Account a ON ve.FAccountID = a.FAccountID
                                INNER JOIN AIS_YXSP2.dbo.t_Currency c ON ve.FCurrencyID = c.FCurrencyID
                      WHERE     v.FDate BETWEEN @begdate AND @enddate
                                AND a.FNumber >= '5101.06'
                                AND a.FNumber <= '5101.06.zzzzzzz'
                                AND ve.FDetailID = 4931
                                AND ve.FCurrencyID = 1
                                AND ve.FDC = 0
                    ) t2 ,
                    ( SELECT    SUM(ROUND(ISNULL(AIS_YXRY2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                 0),
                                          AIS_YXRY2.dbo.t_currency.FScale)) AS FAmountFor_2
                      FROM      AIS_YXRY2.dbo.t_RP_ARPBill
                                LEFT JOIN AIS_YXRY2.dbo.t_RP_Plan_Ar ON AIS_YXRY2.dbo.t_RP_ARPBill.FBillID = AIS_YXRY2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXRY2.dbo.t_RP_Plan_Ar.FIsInit = 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_currency ON AIS_YXRY2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXRY2.dbo.t_currency.FCurrencyID
                                                              AND AIS_YXRY2.dbo.t_currency.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Department ON AIS_YXRY2.dbo.t_RP_ARPBill.FDepartment = AIS_YXRY2.dbo.t_Department.FItemID
                                                              AND AIS_YXRY2.dbo.t_Department.FItemID <> 0
                      WHERE     ( DATEDIFF(DAY, @begdate,
                                           AIS_YXRY2.dbo.t_RP_ARPBill.FDate) >= 0
                                  AND DATEDIFF(DAY, @enddate,
                                               AIS_YXRY2.dbo.t_RP_ARPBill.FDate) <= 0
                                  AND AIS_YXRY2.dbo.t_Department.fnumber LIKE '10.13%'
                                )
                                AND AIS_YXRY2.dbo.t_RP_ARPBill.FClassTypeID = 1000021
                    ) t4----肉业帐套 部门为BT2其它应收单金额   
 


        END 

 --冻品销售部 
 --与原肉品决算表冻品条件一致,原部门20.203改为10.14	 
    IF @FDepnumber = '10.14'
        BEGIN
            SELECT  CONVERT(DECIMAL(18, 2), ( t1.FConsignAmount
                                              + ISNULL(t2.FAmountFor_2, 0.00) )
                    / 1.13)
            FROM    ( SELECT    ISNULL(SUM(u1.FConsignAmount), 0.00) AS FConsignAmount --收入                
                      FROM      AIS_YXRY2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXRY2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0                 
 --LEFT OUTER JOIN AIS_YXRY2.dbo.t_SubMessage t7 ON     v1.FSaleStyle = t7.FInterID   AND t7.FInterID <>0                 
                                INNER JOIN AIS_YXRY2.dbo.t_Stock t8 ON u1.FDCStockID = t8.FItemID
                                                              AND t8.FItemID <> 0                 
-- INNER JOIN t_ICItem t14 ON     u1.FItemID = t14.FItemID   AND t14.FItemID <>0                 
 --INNER JOIN t_MeasureUnit t30 ON     t14.FUnitID = t30.FItemID   AND t30.FItemID <>0                 
                                LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0
                      WHERE     1 = 1
                                AND v1.Fdate >= @begdate
                                AND v1.Fdate <= @enddate               
  --v1.FDate BETWEEN '2014-03-01' AND '2014-03-31'               
                                AND ISNULL(t105.fnumber, '') LIKE '10.14%'
                                AND ISNULL(t8.FName, '') NOT LIKE '%回购%'
                                AND ISNULL(t4.FName, '') NOT LIKE '%集团食堂%'
                                AND v1.FTranType = 21
                                AND v1.FCancellation = 0
                    ) t1 ,
                    ( SELECT    SUM(ROUND(ISNULL(AIS_YXRY2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                 0),
                                          AIS_YXRY2.dbo.t_currency.FScale)) AS FAmountFor_2
                      FROM      AIS_YXRY2.dbo.t_RP_ARPBill
                                LEFT JOIN AIS_YXRY2.dbo.t_RP_Plan_Ar ON AIS_YXRY2.dbo.t_RP_ARPBill.FBillID = AIS_YXRY2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXRY2.dbo.t_RP_Plan_Ar.FIsInit = 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_currency ON AIS_YXRY2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXRY2.dbo.t_currency.FCurrencyID
                                                              AND AIS_YXRY2.dbo.t_currency.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Department ON AIS_YXRY2.dbo.t_RP_ARPBill.FDepartment = AIS_YXRY2.dbo.t_Department.FItemID
                                                              AND AIS_YXRY2.dbo.t_Department.FItemID <> 0
                      WHERE     ( DATEDIFF(DAY, @begdate,
                                           AIS_YXRY2.dbo.t_RP_ARPBill.FDate) >= 0
                                  AND DATEDIFF(DAY, @enddate,
                                               AIS_YXRY2.dbo.t_RP_ARPBill.FDate) <= 0                
          --( DATEDIFF(Day, '2014-03-01' , AIS_YXRY2.dbo.t_RP_ARPBill.FDate) >= 0                
          --AND DATEDIFF(Day, '2014-03-31', AIS_YXRY2.dbo.t_RP_ARPBill.FDate) <= 0               
                                  AND AIS_YXRY2.dbo.t_Department.fnumber LIKE '10.14%'
                                )
                                AND AIS_YXRY2.dbo.t_RP_ARPBill.FClassTypeID = 1000021
                    ) t2              
           
              
  
   
        END 
 
 --厦门办事处 
 --与原肉品决算表营销二部条件一致,原部门20.201改为10.15
    IF @FDepnumber = '10.15'
        BEGIN	
            SELECT  CONVERT(DECIMAL(18, 2), ( ISNULL( t1.FConsignAmount,0)
                                              + ISNULL(t4.FConsignAmount,0)
                                              + ISNULL(t5.FAmountFor_2,0)
                                              + ISNULL(t6.FAmountFor_2,0) ) / 1.13)
            FROM    ( SELECT    CONVERT(DECIMAL(18, 2), SUM(ISNULL(u1.FConsignAmount,
                                                              0))) AS FConsignAmount
                      FROM      AIS_YXRY2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXRY2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN AIS_YXRY2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0                 
 --INNER JOIN AIS_YXRY2.dbo.t_MeasureUnit t30 ON     t14.FUnitID = t30.FItemID   AND t30.FItemID <>0                 
                                LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0                 
 --LEFT OUTER JOIN AIS_YXRY2.dbo.t_MeasureUnit t500 ON     t14.FStoreUnitID = t500.FItemID   AND t500.FItemID <>0                 
                      WHERE     1 = 1
                                AND ( v1.Fdate >= @begdate
                                      AND v1.Fdate <= @enddate
                                      AND ISNULL(t4.FName, '') NOT LIKE '%集团食堂%'
                                      AND ISNULL(t105.fnumber, '') LIKE '10.15%'                
--  AND                  
--ISNULL(t14.Fname,'') NOT LIKE '%肠%'                
--  AND                  
--ISNULL(t14.Fname,'') NOT LIKE '%豆%'                
                                    )
                                AND ( v1.FTranType = 21
                                      AND ( v1.FCancellation = 0 )
                                    )
                    ) t1 ,
                    ( SELECT    CONVERT(DECIMAL(18, 2), SUM(ISNULL(u1.FConsignAmount,
                                                              0))) AS FConsignAmount
                      FROM      AIS_YXSP2.dbo.ICStockBill v1
                                INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_Stock t8 ON u1.FDCStockID = t8.FItemID
                                                              AND t8.FItemID <> 0                 
 --INNER JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0                 
                                INNER JOIN AIS_YXSP2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0                 
 --INNER JOIN t_MeasureUnit t30 ON     t14.FUnitID = t30.FItemID   AND t30.FItemID <>0                 
                                LEFT OUTER JOIN AIS_YXSP2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0                 
 --LEFT OUTER JOIN t_MeasureUnit t500 ON     t14.FStoreUnitID = t500.FItemID   AND t500.FItemID <>0                 
                      WHERE     1 = 1
                                AND ( v1.Fdate >= @begdate
                                      AND v1.Fdate <= @enddate
                                      AND ISNULL(t105.fnumber, '') LIKE '10.15%'
                                      AND ISNULL(t8.Fname, '') NOT LIKE '%号%'
                                    )
                                AND ( v1.FTranType = 21
                                      AND ( v1.FCancellation = 0 )
                                    )
                    ) t4 ,                
---                
---t5 食品账套其它应收单当月部门为201的数据              
---t6 肉业账套其它应收单当月部门为201的数据                
                    ( SELECT    ISNULL(CONVERT(DECIMAL(18, 2), SUM(ROUND(ISNULL(AIS_YXSP2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                              0),
                                                              AIS_YXSP2.dbo.t_currency.FScale))),
                                       0) AS FAmountFor_2
                      FROM      AIS_YXSP2.dbo.t_RP_ARPBill
                                LEFT JOIN AIS_YXSP2.dbo.t_RP_Plan_Ar ON AIS_YXSP2.dbo.t_RP_ARPBill.FBillID = AIS_YXSP2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXSP2.dbo.t_RP_Plan_Ar.FIsInit = 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_currency ON AIS_YXSP2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXSP2.dbo.t_currency.FCurrencyID
                                                              AND AIS_YXSP2.dbo.t_currency.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_Department ON AIS_YXSP2.dbo.t_RP_ARPBill.FDepartment = AIS_YXSP2.dbo.t_Department.FItemID
                                                              AND AIS_YXSP2.dbo.t_Department.FItemID <> 0
                      WHERE     ( DATEDIFF(DAY, @begdate,
                                           AIS_YXSP2.dbo.t_RP_ARPBill.FDate) >= 0
                                  AND DATEDIFF(DAY, @enddate,
                                               AIS_YXSP2.dbo.t_RP_ARPBill.FDate) <= 0
                                  AND AIS_YXSP2.dbo.t_Department.fnumber LIKE '10.15%'
                                )
                                AND AIS_YXSP2.dbo.t_RP_ARPBill.FClassTypeID = 1000021
                    ) t5 ,
                    ( SELECT    CONVERT(DECIMAL(18, 2), SUM(ROUND(ISNULL(AIS_YXRY2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                              0),
                                                              AIS_YXRY2.dbo.t_currency.FScale))) AS FAmountFor_2
                      FROM      AIS_YXRY2.dbo.t_RP_ARPBill
                                LEFT JOIN AIS_YXRY2.dbo.t_RP_Plan_Ar ON AIS_YXRY2.dbo.t_RP_ARPBill.FBillID = AIS_YXRY2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXRY2.dbo.t_RP_Plan_Ar.FIsInit = 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_currency ON AIS_YXRY2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXRY2.dbo.t_currency.FCurrencyID
                                                              AND AIS_YXRY2.dbo.t_currency.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Department ON AIS_YXRY2.dbo.t_RP_ARPBill.FDepartment = AIS_YXRY2.dbo.t_Department.FItemID
                                                              AND AIS_YXRY2.dbo.t_Department.FItemID <> 0
                      WHERE     ( DATEDIFF(DAY, @begdate,
                                           AIS_YXRY2.dbo.t_RP_ARPBill.FDate) >= 0
                                  AND DATEDIFF(DAY, @enddate,
                                               AIS_YXRY2.dbo.t_RP_ARPBill.FDate) <= 0
                                  AND AIS_YXRY2.dbo.t_Department.fnumber LIKE '10.15%'
                                )
                                AND AIS_YXRY2.dbo.t_RP_ARPBill.FClassTypeID = 1000021
                    ) t6
 	
 	
 	
        END 
 	
 -- 福州办事处 	
 --与原肉品决算表营销二部条件一致,原部门20.201改为10.16
    IF @FDepnumber = '10.16'
        BEGIN	
            SELECT  CONVERT(DECIMAL(18, 2), ( ISNULL( t1.FConsignAmount,0)
                                              + ISNULL(t4.FConsignAmount,0)
                                              + ISNULL(t5.FAmountFor_2,0)
                                              + ISNULL(t6.FAmountFor_2,0) ) / 1.13)
            FROM    ( SELECT    CONVERT(DECIMAL(18, 2), SUM(ISNULL(u1.FConsignAmount,
                                                              0))) AS FConsignAmount
                      FROM      AIS_YXRY2.dbo.ICStockBill v1
                                INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXRY2.dbo.t_Organization t4 ON v1.FSupplyID = t4.FItemID
                                                              AND t4.FItemID <> 0
                                INNER JOIN AIS_YXRY2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0                 
 --INNER JOIN AIS_YXRY2.dbo.t_MeasureUnit t30 ON     t14.FUnitID = t30.FItemID   AND t30.FItemID <>0                 
                                LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0                 
 --LEFT OUTER JOIN AIS_YXRY2.dbo.t_MeasureUnit t500 ON     t14.FStoreUnitID = t500.FItemID   AND t500.FItemID <>0                 
                      WHERE     1 = 1
                                AND ( v1.Fdate >= @begdate
                                      AND v1.Fdate <= @enddate
                                      AND ISNULL(t4.FName, '') NOT LIKE '%集团食堂%'
                                      AND ISNULL(t105.fnumber, '') LIKE '10.16%'                
--  AND                  
--ISNULL(t14.Fname,'') NOT LIKE '%肠%'                
--  AND                  
--ISNULL(t14.Fname,'') NOT LIKE '%豆%'                
                                    )
                                AND ( v1.FTranType = 21
                                      AND ( v1.FCancellation = 0 )
                                    )
                    ) t1 ,
                    ( SELECT    CONVERT(DECIMAL(18, 2), SUM(ISNULL(u1.FConsignAmount,
                                                              0))) AS FConsignAmount
                      FROM      AIS_YXSP2.dbo.ICStockBill v1
                                INNER JOIN ICStockBillEntry u1 ON v1.FInterID = u1.FInterID
                                                              AND u1.FInterID <> 0
                                INNER JOIN AIS_YXSP2.dbo.t_Stock t8 ON u1.FDCStockID = t8.FItemID
                                                              AND t8.FItemID <> 0                 
 --INNER JOIN t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0                 
                                INNER JOIN AIS_YXSP2.dbo.t_ICItem t14 ON u1.FItemID = t14.FItemID
                                                              AND t14.FItemID <> 0                 
 --INNER JOIN t_MeasureUnit t30 ON     t14.FUnitID = t30.FItemID   AND t30.FItemID <>0                 
                                LEFT OUTER JOIN AIS_YXSP2.dbo.t_Department t105 ON v1.FDeptID = t105.FItemID
                                                              AND t105.FItemID <> 0                 
 --LEFT OUTER JOIN t_MeasureUnit t500 ON     t14.FStoreUnitID = t500.FItemID   AND t500.FItemID <>0                 
                      WHERE     1 = 1
                                AND ( v1.Fdate >= @begdate
                                      AND v1.Fdate <= @enddate
                                      AND ISNULL(t105.fnumber, '') LIKE '10.16%'
                                      AND ISNULL(t8.Fname, '') NOT LIKE '%号%'
                                    )
                                AND ( v1.FTranType = 21
                                      AND ( v1.FCancellation = 0 )
                                    )
                    ) t4 ,                
---                
---t5 食品账套其它应收单当月部门为201的数据              
---t6 肉业账套其它应收单当月部门为201的数据                
                    ( SELECT    ISNULL(CONVERT(DECIMAL(18, 2), SUM(ROUND(ISNULL(AIS_YXSP2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                              0),
                                                              AIS_YXSP2.dbo.t_currency.FScale))),
                                       0) AS FAmountFor_2
                      FROM      AIS_YXSP2.dbo.t_RP_ARPBill
                                LEFT JOIN AIS_YXSP2.dbo.t_RP_Plan_Ar ON AIS_YXSP2.dbo.t_RP_ARPBill.FBillID = AIS_YXSP2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXSP2.dbo.t_RP_Plan_Ar.FIsInit = 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_currency ON AIS_YXSP2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXSP2.dbo.t_currency.FCurrencyID
                                                              AND AIS_YXSP2.dbo.t_currency.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_Department ON AIS_YXSP2.dbo.t_RP_ARPBill.FDepartment = AIS_YXSP2.dbo.t_Department.FItemID
                                                              AND AIS_YXSP2.dbo.t_Department.FItemID <> 0
                      WHERE     ( DATEDIFF(DAY, @begdate,
                                           AIS_YXSP2.dbo.t_RP_ARPBill.FDate) >= 0
                                  AND DATEDIFF(DAY, @enddate,
                                               AIS_YXSP2.dbo.t_RP_ARPBill.FDate) <= 0
                                  AND AIS_YXSP2.dbo.t_Department.fnumber LIKE '10.16%'
                                )
                                AND AIS_YXSP2.dbo.t_RP_ARPBill.FClassTypeID = 1000021
                    ) t5 ,
                    ( SELECT    CONVERT(DECIMAL(18, 2), SUM(ROUND(ISNULL(AIS_YXRY2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                              0),
                                                              AIS_YXRY2.dbo.t_currency.FScale))) AS FAmountFor_2
                      FROM      AIS_YXRY2.dbo.t_RP_ARPBill
                                LEFT JOIN AIS_YXRY2.dbo.t_RP_Plan_Ar ON AIS_YXRY2.dbo.t_RP_ARPBill.FBillID = AIS_YXRY2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXRY2.dbo.t_RP_Plan_Ar.FIsInit = 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_currency ON AIS_YXRY2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXRY2.dbo.t_currency.FCurrencyID
                                                              AND AIS_YXRY2.dbo.t_currency.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Department ON AIS_YXRY2.dbo.t_RP_ARPBill.FDepartment = AIS_YXRY2.dbo.t_Department.FItemID
                                                              AND AIS_YXRY2.dbo.t_Department.FItemID <> 0
                      WHERE     ( DATEDIFF(DAY, @begdate,
                                           AIS_YXRY2.dbo.t_RP_ARPBill.FDate) >= 0
                                  AND DATEDIFF(DAY, @enddate,
                                               AIS_YXRY2.dbo.t_RP_ARPBill.FDate) <= 0
                                  AND AIS_YXRY2.dbo.t_Department.fnumber LIKE '10.16%'
                                )
                                AND AIS_YXRY2.dbo.t_RP_ARPBill.FClassTypeID = 1000021
                    ) t6
 	
        END 
 --华东办事处 
 --与原肉品决算表华东条件一致,原部门20.202改为10.17
 	  IF @FDepnumber = '10.17'
        BEGIN	--CONVERT(DECIMAL(18,2),FConsignAmount/1.13 )
               
     SELECT   CONVERT(DECIMAL(18,2),ISNULL(SUM(u1.FConsignAmount),0.00)/1.13 )     
     FROM AIS_YXRY2.dbo.ICStockBill v1               
 INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0               
 --INNER JOIN AIS_YXRY2.dbo.t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0               
 --LEFT OUTER JOIN AIS_YXRY2.dbo.t_SubMessage t7 ON     v1.FSaleStyle = t7.FInterID   AND t7.FInterID <>0               
 INNER JOIN AIS_YXRY2.dbo.t_Stock t8 ON     u1.FDCStockID = t8.FItemID   AND t8.FItemID <>0               
 --INNER JOIN AIS_YXRY2.dbo.t_ICItem t14 ON     u1.FItemID = t14.FItemID   AND t14.FItemID <>0               
 --INNER JOIN t_MeasureUnit t30 ON     t14.FUnitID = t30.FItemID   AND t30.FItemID <>0               
 LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON     v1.FDeptID = t105.FItemID   AND t105.FItemID <>0               
 where 1=1 AND                 
  v1.Fdate >= @begdate AND  v1.Fdate <= @enddate             
   AND (v1.FTranType=21 AND v1.FCancellation = 0 )          
    AND   ISNULL(t105.fnumber,'')='10.17'            
    AND ISNULL(t8.fname,'') not LIKE '%号%' 
        
        END  
 --华南办事处 
 --与原肉品决算表华南条件一致,原部门20.204改为10.18
 	  IF @FDepnumber = '10.18'
 	  BEGIN
 SELECT CONVERT(DECIMAL(18,2),ISNULL(SUM(u1.FConsignAmount),0.00)/1.13 ) AS  FConsignAmount --收入     
 from AIS_YXRY2.dbo.ICStockBill v1               
 INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0               
 --INNER JOIN AIS_YXRY2.dbo.t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0               
 --LEFT OUTER JOIN AIS_YXRY2.dbo.t_SubMessage t7 ON     v1.FSaleStyle = t7.FInterID   AND t7.FInterID <>0               
 INNER JOIN AIS_YXRY2.dbo.t_Stock t8 ON     u1.FDCStockID = t8.FItemID   AND t8.FItemID <>0               
 --INNER JOIN AIS_YXRY2.dbo.t_ICItem t14 ON     u1.FItemID = t14.FItemID   AND t14.FItemID <>0               
 --INNER JOIN t_MeasureUnit t30 ON     t14.FUnitID = t30.FItemID   AND t30.FItemID <>0               
 LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON     v1.FDeptID = t105.FItemID   AND t105.FItemID <>0               
 where 1=1 AND                 
  v1.Fdate >= @begdate AND  v1.Fdate <= @enddate             
   AND v1.FTranType=21 AND v1.FCancellation = 0           
   AND  ISNULL(t105.fnumber,'')= '10.18'           
    AND ISNULL(t8.fname,'') not LIKE '%号%' 
 	  
 	  END 
 
 	
 	
 	 
 --小副产品 	
 --与原肉品决算表小副产品条件一致,原部门20.206改为10.19
	  IF @FDepnumber = '10.19'

 BEGIN                
 SELECT CONVERT(DECIMAL(18,2),ISNULL(SUM(u1.FConsignAmount),0.00)/1.13) AS  FConsignAmount --收入                
           
 from AIS_YXRY2.dbo.ICStockBill v1               
 INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0               
 --INNER JOIN AIS_YXRY2.dbo.t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0               
 --LEFT OUTER JOIN AIS_YXRY2.dbo.t_SubMessage t7 ON     v1.FSaleStyle = t7.FInterID   AND t7.FInterID <>0               
 INNER JOIN AIS_YXRY2.dbo.t_Stock t8 ON     u1.FDCStockID = t8.FItemID   AND t8.FItemID <>0               
 --INNER JOIN AIS_YXRY2.dbo.t_ICItem t14 ON     u1.FItemID = t14.FItemID   AND t14.FItemID <>0               
 --INNER JOIN t_MeasureUnit t30 ON     t14.FUnitID = t30.FItemID   AND t30.FItemID <>0               
 LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON     v1.FDeptID = t105.FItemID   AND t105.FItemID <>0               
 where 1=1 AND                 
  (v1.Fdate >= @begdate AND  v1.Fdate <= @enddate)             
  --v1.FDate BETWEEN '2014-03-01' AND '2014-03-31'             
    AND (v1.FTranType=21 AND v1.FCancellation = 0 )          
    AND ISNULL(t105.fnumber,'')='10.19'           
    AND ISNULL(t8.fnumber,'') not LIKE '%001.02%'  
  END 
 --代宰业务 10.20	 
 --与原肉品决算表代宰业务条件一致
 	  IF @FDepnumber = '10.20'
 	  begin
 
    SELECT SUM(ve.FAmountFor) -- AS  FAmountFor                      
        FROM   AIS_YXRY2.dbo. t_Voucher v                
        INNER JOIN AIS_YXRY2.dbo.t_VoucherGroup vg ON v.FGroupID = vg.FGroupID                
        LEFT OUTER JOIN AIS_YXRY2.dbo.t_VoucherTplType tp ON v.FTranType = tp.FTplTypeID                
        INNER JOIN AIS_YXRY2.dbo.t_VoucherEntry ve ON v.FVoucherID = ve.FVoucherID                
        INNER JOIN AIS_YXRY2.dbo.t_Account a ON ve.FAccountID = a.FAccountID                
        LEFT OUTER JOIN ( SELECT    *                
                          FROM      AIS_YXRY2.dbo.t_Account b                
                        ) b ON ve.FAccountID2 = b.FAccountID                
        INNER JOIN AIS_YXRY2.dbo.t_Currency c ON ve.FCurrencyID = c.FCurrencyID                
        LEFT OUTER JOIN AIS_YXRY2.dbo.t_Settle e ON ve.FSettleTypeID = e.FitemID                
                                      AND e.FitemID <> 0                
      WHERE   FDate BETWEEN @begdate AND @enddate                
       -- FDate BETWEEN '2014-03-01' AND '2014-03-31'                
        AND  ((a.FNumber >= '5102.03' AND a.FNumber <= '5102.03.zzzzzzz') OR                 
              (a.FNumber >= '5102.05' AND a.FNumber <= '5102.05.zzzzzzz')  )                
        AND ve.FCurrencyID = 1 --AND v.FPosted <> 0           
        AND ve.FDC=0  
   END 
 
 --内部交易 	 
 --无
 
 --国储肉 	
 --与原肉品决算表国储肉条件一致
   IF @FDepnumber = '10.22'
 	  begin
     SELECT CONVERT(DECIMAL(18,2),ISNULL(SUM(u1.FConsignAmount),0.00)/1.13)    AS  FConsignAmount --收入               
 from AIS_YXRY2.dbo.ICStockBill v1                 
 INNER JOIN AIS_YXRY2.dbo.ICStockBillEntry u1 ON     v1.FInterID = u1.FInterID   AND u1.FInterID <>0                 
 --INNER JOIN AIS_YXRY2.dbo.t_Organization t4 ON     v1.FSupplyID = t4.FItemID   AND t4.FItemID <>0                 
 --LEFT OUTER JOIN AIS_YXRY2.dbo.t_SubMessage t7 ON     v1.FSaleStyle = t7.FInterID   AND t7.FInterID <>0                 
 INNER JOIN AIS_YXRY2.dbo.t_Stock t8 ON     u1.FDCStockID = t8.FItemID   AND t8.FItemID <>0                 
-- INNER JOIN t_ICItem t14 ON     u1.FItemID = t14.FItemID   AND t14.FItemID <>0                 
 --INNER JOIN t_MeasureUnit t30 ON     t14.FUnitID = t30.FItemID   AND t30.FItemID <>0                 
 LEFT OUTER JOIN AIS_YXRY2.dbo.t_Department t105 ON     v1.FDeptID = t105.FItemID   AND t105.FItemID <>0                 
 where 1=1 AND                   
  v1.Fdate >= @begdate AND  v1.Fdate <= @enddate               
  --v1.FDate BETWEEN '2014-03-01' AND '2014-03-31'               
  AND    ISNULL(t105.fnumber,'')= '10.22'       
  AND  ISNULL(t8.FName,'')  LIKE '%回购%'                
  AND v1.FTranType=21 AND v1.FCancellation = 0  
  END 