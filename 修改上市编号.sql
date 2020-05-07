SELECT TOP 100 * 

-- update t_Organization   set F_110=a.f1

FROM dbo.t_Organization t INNER JOIN 

TEST_YXDZP2018.dbo.test_a a ON a.f3=t.FNumber
WHERE 1=1
 --a.f3='02.02.03.06'


--dbo.SpK3_2Str @sName = 't_Organization' -- varchar(50)
