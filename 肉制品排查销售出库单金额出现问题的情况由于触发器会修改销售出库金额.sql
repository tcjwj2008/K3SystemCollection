SELECT fauxqty,fallamount FROM seorderentry WHERE FInterID=76058
144392.2300000000	3329684.8200
144664.5000000000	3437228.5200
142518.3700000000	3386236.4700

SELECT * FROM dbo.ICStockBill WHERE FBillNo='XOUT092161'

SELECT FAuxqty ,FConsignAmount FROM icstockbillentry WHERE FInterID=208422

144392.2300000000	3329684.68
144664.5000000000	3437228.52
142518.3700000000	3386236.33


SELECT 
--Update a set 
	FConsignAmount,b.FAllAmount,b.FAuxQty,a.FAuxqty,b.FAllAmount/b.FAuxQty,b.FAllAmount/b.FAuxQty*a.FAuxqty,ROUND(b.FAllAmount/b.FAuxQty*a.FAuxqty,2)
	from ICStockbillEntry a 
	inner join SeorderEntry b on a.FSourceInterid=b.FInterID and a.FSourceEntryID=b.FEntryID
	where a.FSourceTrantype=81 and a.FInterID=208422
	
	
SELECT 
--Update a set 
	b.FAllAmount,b.FAuxQty,a.FAuxqty,b.FAllAmount/b.FAuxQty,b.FAllAmount/b.FAuxQty*b.FAuxqty,ROUND(b.FAllAmount/b.FAuxQty*a.FAuxqty,2)
	from ICStockbillEntry a 
	inner join SeorderEntry b on a.FSourceInterid=b.FInterID and a.FSourceEntryID=b.FEntryID
	where a.FSourceTrantype=81 and a.FInterID=208422	
	
SELECT 
--	Update a set 
	FConsignPrice,ROUND(a.FConsignAmount/a.FAuxQty,c.FPriceDecimal)
	from ICStockbillEntry a 
	inner join t_icitem c on a.fitemid=c.fitemid
	where a.FSourceTrantype=81 and a.FInterID=208422
	

