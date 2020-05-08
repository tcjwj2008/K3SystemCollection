/***修改单据体无法更改的问题****/
SELECT * FROM ictransactiontype
GO
dbo.SpK3_2tab @sName = 'ictransactiontype' -- varchar(50)
go
SELECT * FROM ictemplate
go
dbo.SpK3_2tab @sName = 'ictemplate' -- varchar(50)
GO
SELECT * FROM ictemplateentry WHERE FID=''
go
dbo.SpK3_2tab @sName = 'ictemplateentry' -- varchar(50)
GO
SELECT * FROM ICUserTemplateEntry
dbo.SpK3_2tab @sName = 'ICUserTemplateEntry' -- varchar(50)
GO

UPDATE dbo.ICUserTemplateEntry SET FVisForBillType=31 WHERE
FTemplateID='' AND FFieldName=''
GO


--------------------------------------------------------------

SELECT * FROM seorder