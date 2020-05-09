SELECT deductionway AS 扣减方式 ,* FROM  TZ_CG_settlezdde2019   settlecode
--UPDATE TZ_CG_settlezdde2019 SET deductioncode=13 FROM  TZ_CG_settlezdde2019
WHERE settlecode IN ('CGJS201912200001','CGJS201912200003')AND deductionname ='调整值'


SELECT deductionway AS 扣减方式 ,* FROM  TZ_CG_settlezdde2019   settlecode
--UPDATE TZ_CG_settlezdde2019 SET deductioncode=13 FROM  TZ_CG_settlezdde2019
WHERE  deductionname ='调整值'
AND settlecode.deductioncode=13

--SELECT *
UPDATE TZ_CG_settlezdde2019 SET deductioncode=13
--FROM TZ_CG_settlezdde2019
WHERE  deductionname ='调整值'
AND deductioncode=18