SELECT * from t_FABalance  WHERE   FAssetID='5'  AND FYear=2020 AND FPeriod=1
DELETE FROM  t_FABalance    WHERE   FAssetID='5'  AND FYear=2020 AND FPeriod=1
delete from dbo.t_FABalCardItem WHERE FBalID=123180
delete FROM dbo.t_FABalExpense WHERE fbalid=123180
delete FROM dbo.t_FABalDept WHERE fbalid=123180
delete FROM dbo.t_FABalOrgFor WHERE fbalid=123180
delete FROM dbo.t_FABalCard WHERE fbalid=123180
SELECT * FROM  t_FABalance   WHERE   FAssetID='5'  AND FYear=2020 AND FPeriod=2
DELETE FROM  t_FABalance    WHERE   FAssetID='5'  AND FYear=2020 AND FPeriod=2
delete from dbo.t_FABalCardItem WHERE FBalID=126914
delete FROM dbo.t_FABalExpense WHERE fbalid=126914
delete FROM dbo.t_FABalDept WHERE fbalid=126914
delete FROM dbo.t_FABalOrgFor WHERE fbalid=126914
delete FROM dbo.t_FABalCard WHERE fbalid=126914
SELECT * FROM  t_FABalance   WHERE   FAssetID='5'  AND FYear=2020 AND FPeriod=3 
DELETE FROM  t_FABalance    WHERE   FAssetID='5'  AND FYear=2020 AND FPeriod=3
delete from dbo.t_FABalCardItem WHERE FBalID=128161
delete FROM dbo.t_FABalExpense WHERE fbalid=128161
delete FROM dbo.t_FABalDept WHERE fbalid=128161
delete FROM dbo.t_FABalOrgFor WHERE fbalid=128161
delete FROM dbo.t_FABalCard WHERE fbalid=128161
SELECT * FROM  t_FABalance   WHERE   FAssetID='5'  AND FYear=2020 AND FPeriod=4 
DELETE FROM  t_FABalance    WHERE   FAssetID='5'  AND FYear=2020 AND FPeriod=4
delete from dbo.t_FABalCardItem WHERE FBalID=129409
delete FROM dbo.t_FABalExpense WHERE fbalid=129409
delete FROM dbo.t_FABalDept WHERE fbalid=129409
delete FROM dbo.t_FABalOrgFor WHERE fbalid=129409
delete FROM dbo.t_FABalCard WHERE fbalid=129409


GO
dbo.SpK3_2tab @sName = 't_FABalOrgFor' -- varchar(50)

dbo.SpK3_2tab @sName = 't_FABalCard' -- varchar(50)

dbo.SpK3_2tab @sName = 't_FABalance' -- varchar(50)

dbo.SpK3_2tab @sName = 't_FABalCardItem' -- varchar(50)

dbo.SpK3_2tab @sName = 't_FABalExpense' -- varchar(50)

dbo.spk3_2tab @sname='t_FABalDevice'



SELECT * 
--DELETE   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=4

SELECT * 
--DELETE   
from dbo.t_FABalCardItem WHERE FBalID IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=4)

SELECT * 
--DELETE  
FROM dbo.t_FABalExpense WHERE fbalid  IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=4)
SELECT * 
--DELETE 
FROM dbo.t_FABalDept WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=4)
SELECT * 
--DELETE 
FROM dbo.t_FABalOrgFor WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=4)

SELECT * 
--DELETE 
FROM dbo.t_FABalCard WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=4)

SELECT * 
--DELETE 
FROM dbo.t_FABalDevice WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=4)


SELECT * 
--DELETE   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=3

SELECT * 
--DELETE   
from dbo.t_FABalCardItem WHERE FBalID IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=3)
SELECT * 
--DELETE  
FROM dbo.t_FABalExpense WHERE fbalid  IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=3)
SELECT * 
--DELETE 
FROM dbo.t_FABalDept WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=3)
SELECT * 
--DELETE 
FROM dbo.t_FABalOrgFor WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=3)

SELECT * 
--DELETE 
FROM dbo.t_FABalCard WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=3)

SELECT * 
--DELETE 
FROM dbo.t_FABalDevice WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=3)



SELECT * 
--DELETE   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=2

SELECT * 
--DELETE   
from dbo.t_FABalCardItem WHERE FBalID IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=2)
SELECT * 
--DELETE  
FROM dbo.t_FABalExpense WHERE fbalid  IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=2)
SELECT * 
--DELETE 
FROM dbo.t_FABalDept WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=2)
SELECT * 
--DELETE 
FROM dbo.t_FABalOrgFor WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=2)

SELECT * 
--DELETE 
FROM dbo.t_FABalCard WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=2)
SELECT * 
--DELETE 
FROM dbo.t_FABalDevice WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=2)



SELECT * 
--DELETE   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=1

SELECT * 
--DELETE   
from dbo.t_FABalCardItem WHERE FBalID IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=1)
SELECT * 
--DELETE  
FROM dbo.t_FABalExpense WHERE fbalid  IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=1)
SELECT * 
--DELETE 
FROM dbo.t_FABalDept WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=1)
SELECT * 
--DELETE 
FROM dbo.t_FABalOrgFor WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=1)

SELECT * 
--DELETE 
FROM dbo.t_FABalCard WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=1)
SELECT * 
--DELETE 
FROM dbo.t_FABalDevice WHERE fbalid IN (SELECT FBalID   
FROM  t_FABalance    WHERE     FYear=2020 AND FPeriod=1)