
--SELECT * INTO icstockbill_BACKUP20191228 FROM icstockbill
--SELECT * INTO ICStockBillEntry_BACKUP20191228 FROM dbo.ICStockBillEntry
SELECT * FROM icstockbill WHERE FBillNo='XOUT824870'
--UPDATE icstockbill  SET FCancellation=0 WHERE FBillNo='XOUT824870'
--DELETE  FROM icstockbill WHERE FBillNo='XOUT824870'

SELECT FSourceBillNo FROM dbo.ICStockBillEntry WHERE FInterID=1074375
--DELETE FROM dbo.ICStockBillEntry WHERE FInterID=1074375


SELECT * FROM icstockbill WHERE FBillNo='XOUT824869'
--UPDATE icstockbill  SET FCancellation=0 WHERE FBillNo='XOUT824869'
--DELETE  FROM icstockbill WHERE FBillNo='XOUT824869'
--
SELECT FSourceBillNo FROM dbo.ICStockBillEntry WHERE FInterID=1074374
--DELETE FROM dbo.ICStockBillEntry WHERE FInterID=1074374


SELECT * FROM icstockbill WHERE FBillNo='XOUT824868'
--UPDATE icstockbill  SET FCancellation=0 WHERE FBillNo='XOUT824868'
--DELETE  FROM icstockbill WHERE FBillNo='XOUT824868'
--
SELECT FSourceBillNo FROM dbo.ICStockBillEntry WHERE FInterID=1074373
--DELETE FROM dbo.ICStockBillEntry WHERE FInterID=1074373


SELECT * FROM icstockbill WHERE FBillNo='XOUT825451'
--UPDATE icstockbill  SET FCancellation=0 WHERE FBillNo='XOUT825451'
--DELETE  FROM icstockbill WHERE FBillNo='XOUT825451'

SELECT FSourceBillNo FROM dbo.ICStockBillEntry WHERE FInterID=1075041
--DELETE FROM dbo.ICStockBillEntry WHERE FInterID=1075041


SELECT * FROM icstockbill WHERE FBillNo='XOUT825452'
--UPDATE icstockbill  SET FCancellation=0 WHERE FBillNo='XOUT825452'
--DELETE  FROM icstockbill WHERE FBillNo='XOUT825452'
--
SELECT FSourceBillNo FROM dbo.ICStockBillEntry WHERE FInterID=1075042
--DELETE FROM dbo.ICStockBillEntry WHERE FInterID=1075042


SELECT * FROM icstockbill WHERE FBillNo='XOUT824868'
--UPDATE icstockbill  SET FCancellation=0 WHERE FBillNo='XOUT824868'
--DELETE  FROM icstockbill WHERE FBillNo='XOUT824868'
--
SELECT FSourceBillNo FROM dbo.ICStockBillEntry WHERE FInterID=1074373
--DELETE FROM dbo.ICStockBillEntry WHERE FInterID=1074373


SELECT * FROM seorder WHERE fbillno='SEORD006687'
--update seorder SET FStatus=0 ,FCurCheckLevel=0,FCheckerID='' WHERE fbillno='SEORD006687'
--DELETE FROM seorder WHERE fbillno='SEORD006687'
--SELECT * FROM dbo.SEOrderEntry WHERE FInterID=11078
--DELETE FROM dbo.SEOrderEntry WHERE FInterID=11078