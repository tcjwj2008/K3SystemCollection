SELECT * FROM t_ICITEM
WHERE FNumber LIKE '7.1.01.%'  and  FErpClsID=2

GO
UPDATE t_ICITEM SET  FErpClsID=1
WHERE FNumber LIKE '7.1.01.%'  and  FErpClsID=2
dbo.SpK3_2Str @sName = 't_ICITEM' -- varchar(50)


