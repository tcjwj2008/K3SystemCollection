SELECT  E.*
-- UPDATE icprcplyentry set  FBegDate='2019-11-29 00:00:00.000'
FROM    dbo.ICPrcPlyEntry E
        INNER JOIN t_SubMessage S ON E.FRelatedID = S.FInterID
WHERE   S.FID IN ( 'A01','A02','A03','C01','C02','C07','C05') AND E.FChecked=0 

AND( E.FBegDate='2019-10-31 00:00:00.000' OR E.FBegDate='2019-11-01 00:00:00.000');