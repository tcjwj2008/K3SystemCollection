SELECT deductionway AS �ۼ���ʽ ,* FROM  TZ_CG_settlezdde2019   settlecode
--UPDATE TZ_CG_settlezdde2019 SET deductioncode=13 FROM  TZ_CG_settlezdde2019
WHERE settlecode IN ('CGJS201912200001','CGJS201912200003')AND deductionname ='����ֵ'


SELECT deductionway AS �ۼ���ʽ ,* FROM  TZ_CG_settlezdde2019   settlecode
--UPDATE TZ_CG_settlezdde2019 SET deductioncode=13 FROM  TZ_CG_settlezdde2019
WHERE  deductionname ='����ֵ'
AND settlecode.deductioncode=13

--SELECT *
UPDATE TZ_CG_settlezdde2019 SET deductioncode=13
--FROM TZ_CG_settlezdde2019
WHERE  deductionname ='����ֵ'
AND deductioncode=18