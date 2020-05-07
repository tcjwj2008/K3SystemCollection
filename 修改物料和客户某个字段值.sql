/*修改客户某个字段值*/


SELECT  *
FROM    dbo.t_Organization
WHERE FNumber NOT LIKE 'X%' AND FNumber NOT LIKE '99%'
AND FDeleted=0
GO


UPDATE dbo.t_Organization SET FPostalCode=0
WHERE FNumber NOT LIKE 'X%' AND FNumber NOT LIKE '99%'
AND FDeleted=0
GO

SELECT *  INTO t_Organization20190826
FROM t_Organization

dbo.SpK3_2Str @sName = 't_Organization' -- varchar(50)


/***更新物料*/
SELECT * FROM t_Item

GO
dbo.SpK3_2Str @sName = 't_Item' -- varchar(50)


/**更新什么*/

SELECT * FROM ICPrcPlyEntry

dbo.SpK3_2Str @sName = 'ICPrcPlyEntry' -- varchar(50)


