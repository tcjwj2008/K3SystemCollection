--物料上加上业务批次管理标志

SELECT * FROM  t_icitemmaterial WHERE fitemid in (select fitemid from t_icitem where fnumber like '8.8.02.02.000220%')
SELECT * FROM  icinvinitial WHERE FItemID=16510
SELECT * FROM  icstockbillentry WHERE FItemID=16510
SELECT * FROM  icinventory WHERE FItemID=16510
SELECT * from icinvbal WHERE fitemid=16510
SELECT * FROM  icbal WHERE fitemid=16510

GO

--dbo.SpK3_2tab @sName = 't_icitemmaterial' -- varchar(50)

--delete FROM  icinventory WHERE FItemID=16510


---修改231

SELECT * FROM  t_icitemmaterial WHERE fitemid in (select fitemid from t_icitem where fnumber like '8.8.02.02.000231%')
SELECT * FROM  icinvinitial WHERE FItemID=16710
SELECT * FROM  icstockbillentry WHERE FItemID=16710
SELECT * FROM  icinventory WHERE FItemID=16710
SELECT * from icinvbal WHERE fitemid=16710
SELECT * FROM  icbal WHERE fitemid=16710

GO

--dbo.SpK3_2tab @sName = 't_icitemmaterial' -- varchar(50)

--delete FROM  icinventory WHERE FItemID=16710





