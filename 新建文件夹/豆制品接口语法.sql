/*修改客户某个字段值*/
SELECT *  INTO t_Organization20190826
FROM t_Organization



SELECT  *
FROM    dbo.t_Organization
WHERE FNumber NOT LIKE 'X%' AND FNumber NOT LIKE '99%'
AND FDeleted=0
GO

UPDATE dbo.t_Organization SET FPostalCode=0
WHERE FNumber NOT LIKE 'X%' AND FNumber NOT LIKE '99%'
AND FDeleted=0
GO



dbo.SpK3_2Str @sName = 't_Organization' -- varchar(50)


/***更新物料*/
SELECT * FROM t_ICItem  WHERE  FDeleted=0 AND FNumber LIKE '8.%'

SELECT *  INTO t_icitem20190826  WHERE  FDeleted=0 AND FNumber LIKE '8.%'

SELECT * FROM t_icitem WHERE  FDeleted=0 AND FNumber LIKE '8.%'
--update  dbo.t_ICItem SET FApproveNo =NULL
UPDATE dbo.t_ICItem SET FApproveNo =0
WHERE 1=1 AND FDeleted=0 AND FNumber LIKE '8.%'
GO
dbo.SpK3_2Str @sName = 't_icItem' -- varchar(50)


/**更新什么*/

SELECT * INTO ICPrcPlyEntry20190826 FROM ICPrcPlyEntry
UPDATE dbo.ICPrcPlyEntry SET FNote =0
WHERE 1=1
go
dbo.SpK3_2Str @sName = 'ICPrcPlyEntry' -- varchar(50)


