SELECT  A.* ,
        B.*
--UPDATE B SET B.deductioncode=A.deductioncode
FROM    TZ_CG_settlezdde2019 A ,
        yrtzdata.dbo.TZ_CG_settlezdde2019 B
WHERE   A.settlecode = B.settlecode
        AND A.deductionname = B.deductionname;