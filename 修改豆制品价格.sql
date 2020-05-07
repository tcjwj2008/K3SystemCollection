
SELECT DISTINCT E.FRelatedID,S.FNAME,S.FID

FROM    dbo.ICPrcPlyEntry E
            INNER JOIN t_SubMessage S ON E.FRelatedID = S.FInterID
WHERE S.FID IN ('01','02','100','104','106','107','108')


)
			WHERE E.FRelatedID