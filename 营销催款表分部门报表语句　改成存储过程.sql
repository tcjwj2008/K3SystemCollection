CREATE PROCEDURE yxckb_qiu --yxckb_qiu '2020','08.0445.000','08.0445.999','2020-04-01','2020-05-07'
(@fyear VARCHAR(100),@begin_CustNo VARCHAR(100),@end_CustNo VARCHAR(100),@beg_date VARCHAR(100),@end_date VARCHAR(100))
AS 
SELECT  fcustnumber ,
        fcustname ,
        fdept ,
        SUM(beginbalance) beginbalance ,
        SUM(sellamount) sellamount ,
        SUM(frecieved) frecieved ,
        SUM(fdiscount) fdiscount ,
        ( SUM(beginbalance) + SUM(sellamount) - SUM(frecieved) + SUM(fdiscount) ) endbalance
FROM    ( SELECT    DATEADD(DAY, -1, @beg_date) fdate ,
                    a.FCustomer fcustid ,
                    b.FNumber fcustnumber ,
                    b.FName fcustname ,
                    SUM(ISNULL(a.FEndBalance, 0)) beginbalance ,
                    0 sellamount ,
                    0 frecieved ,
                    0 fdiscount ,
                    c.FName fdept
          FROM      t_RP_ContactBal AS a
                    INNER JOIN t_Organization b ON a.FCustomer = b.FItemID
                    LEFT JOIN t_Department c ON a.FDepartment = c.FItemID
          WHERE     a.FYear = @fyear
                    AND a.FPeriod = MONTH(DATEADD(MONTH, -1, @beg_date))
                    AND a.FRP = '1'
          GROUP BY  a.FCustomer ,
                    b.FNumber ,
                    b.FName ,
                    c.FName
---期初余额表
          UNION ALL
          SELECT    a.FDate fdate ,
                    a.FSupplyID fcustid ,
                    c.FNumber fcustnumber ,
                    c.FName fcustname ,
                    0 beginbalance ,
                    SUM(b.FConsignAmount) sellamount ,
                    0 frecieved ,
                    0 fdiscount ,
                    f.FName fdept
          FROM      ICStockBill a
                    INNER JOIN ICStockBillEntry b ON a.FInterID = b.FInterID
                    INNER JOIN t_Organization c ON a.FSupplyID = c.FItemID
                    INNER JOIN t_ICItem d ON b.FItemID = d.FItemID
                    INNER JOIN t_MeasureUnit e ON d.FUnitID = e.FMeasureUnitID
                    LEFT JOIN t_Department f ON a.FDeptID = f.FItemID
          WHERE     a.FDate BETWEEN @beg_date AND @end_date
                    AND FTranType = '21'
                    AND FCancellation = 0
          GROUP BY  a.FDate ,
                    a.FSupplyID ,
                    c.FNumber ,
                    c.FName ,
                    f.FName
----销售出库单
          UNION ALL
          SELECT    a.FFincDate fdate ,
                    a.FCustomer fcustid ,
                    b.FNumber fcustnumber ,
                    b.FName fcustname ,
                    0 beginbalance ,
                    0 sellamount ,
                    SUM(a.FAmount) frecieved ,
                    0 fdiscount ,
                    c.FName fdept
          FROM      t_RP_Contact a
                    INNER JOIN t_Organization b ON a.FCustomer = b.FItemID
                    LEFT JOIN t_Department c ON a.FDepartment = c.FItemID
          WHERE     a.FDate BETWEEN @beg_date AND @end_date
                    AND FType = '5'
                    AND FRP = '1'
          GROUP BY  a.FFincDate ,
                    a.FCustomer ,
                    b.FNumber ,
                    b.FName ,
                    c.FName

---收款单
          UNION ALL
          SELECT    a.FFincDate fdate ,
                    a.FCustomer fcustid ,
                    b.FNumber fcustnumber ,
                    b.FName fcustname ,
                    0 beginbalance ,
                    0 sellamount ,
                    0 frecieved ,
                    SUM(a.FAmount) fdiscount ,
                    c.FName fdept
          FROM      t_RP_Contact a
                    INNER JOIN t_Organization b ON a.FCustomer = b.FItemID
                    LEFT JOIN t_Department c ON a.FDepartment = c.FItemID
          WHERE     a.FDate BETWEEN @beg_date AND @end_date
                    AND FType = '1'
                    AND FRP = '1'
          GROUP BY  a.FFincDate ,
                    a.FCustomer ,
                    b.FNumber ,
                    b.FName ,
                    c.FName

---其他应收单
        ) v
WHERE   fcustnumber BETWEEN @begin_CustNo AND @end_CustNo
GROUP BY fcustnumber ,
        fcustname ,
        fdept
HAVING  ( SUM(beginbalance) + SUM(sellamount) - SUM(frecieved) + SUM(fdiscount) ) <> 0
ORDER BY fcustnumber;
