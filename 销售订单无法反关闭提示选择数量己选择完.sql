SELECT * FROM seorder;
GO
dbo.SpK3_2Str @sName = 'seorderentry' -- varchar(50)
GO


SELECT FStockQty,FSecStockQty,FCommitQty FROM seorderentry,seorder WHERE FBillNo = 'SEORD007549'
AND seorder.FInterID=dbo.SEOrderEntry.FInterID

UPDATE seorderentry SET 

FCommitQty=0 

FROM seorderentry,seorder WHERE FBillNo = 'SEORD007549'
AND seorder.FInterID=dbo.SEOrderEntry.FInterID

