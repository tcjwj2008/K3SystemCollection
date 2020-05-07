dbo.SpK3_2Str  @sName = 'ICSTOCKBILL' -- varchar(50)


SELECT * INTO ICStockBill20191115 FROM dbo.ICStockBill WHERE FInterID NOT IN (SELECT FInterID FROM dbo.ICStockBillEntry)
UPDATE ICStockBill SET FCancellation=1  WHERE FInterID NOT IN (SELECT FInterID FROM dbo.ICStockBillEntry)
