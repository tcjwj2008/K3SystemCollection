SELECT  FAssetNumber
FROM    t_FACard
WHERE   FAlterID IN ( SELECT DISTINCT
                                FAlterID
                      FROM      t_FAAlter
                      WHERE     FCleared = 0
                                AND FAssetID = 187
                                AND FYear = 2019
                                AND FPeriod = 12 )
        AND FModule = 'CL';

--����鲻�����ݻᱨ����ɾ������ʷ�ı䶯��¼

SELECT *
--DELETE  
FROM t_FAAlter
WHERE   FAlterID = 1915;

SELECT *
--DELETE  
FROM t_FAAlter
WHERE   FAlterID = 1916;
SELECT *
--DELETE  
FROM t_FAAlter
WHERE   FAlterID = 1917;
SELECT *
--DELETE  
FROM t_FAAlter
WHERE   FAlterID = 1918;


SELECT * INTO t_faalter20200423 FROM t_faalter