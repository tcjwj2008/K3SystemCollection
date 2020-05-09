SELECT  E.*
-- delete e.* 
FROM    dbo.ICPrcPlyEntry E
        INNER JOIN t_SubMessage S ON E.FRelatedID = S.FInterID
WHERE   S.FID IN ( '01', '02', '100', '104', '106', '107', '108', '109', '110',
                   '112', '115', '117', '119', '122', '199', '200', '303',
                   '304', '305', '308', '309', '310', '311', '312', '313',
                   '401', '402', '502', 'C06' );


----------------------------------------


SELECT  E.*
-- UPDATE icprcplyentry set  FBegDate='2019-11-29 00:00:00.000'
FROM    dbo.ICPrcPlyEntry E
        INNER JOIN t_SubMessage S ON E.FRelatedID = S.FInterID
WHERE   S.FID IN ( 'A01','A02','A03','C01','C02','C07','C05') AND E.FChecked=0 

AND( E.FBegDate='2019-10-31 00:00:00.000' OR E.FBegDate='2019-11-01 00:00:00.000');

--(844)


--(1085 行受影响)

---1.....
SELECT  E.*
-- UPDATE icprcplyentry set  FBegDate='2019-11-29 00:00:00.000'
FROM    dbo.ICPrcPlyEntry E
        INNER JOIN t_SubMessage S ON E.FRelatedID = S.FInterID
WHERE   S.FID IN ( 'A01','A02','A03','C01','C02','C07','C05') AND E.FChecked=0 AND E.FBegDate='2019-10-31 00:00:00.000';
--(1085 行受影响)

SELECT  E.*
-- UPDATE icprcplyentry set  FBegDate='2019-11-30 00:00:00.000'
FROM    dbo.ICPrcPlyEntry E
        INNER JOIN t_SubMessage S ON E.FRelatedID = S.FInterID
WHERE   S.FID IN ( 'A01','A02','A03','C01','C02','C07','C05') AND E.FChecked=0 AND E.FBegDate='2019-11-01 00:00:00.000';
--(252 行受影响)

--dbo.SpK3_2Str @sName = 'ICPrcPlyEntry' -- varchar(50)




