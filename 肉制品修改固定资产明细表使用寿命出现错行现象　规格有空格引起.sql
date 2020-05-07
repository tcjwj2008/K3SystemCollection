SELECT  *
FROM    t_FACard
WHERE   FAssetNumber = 'RZPQT0148';
UPDATE  t_FACard
SET     FModel = '长6180*宽600*高900'
WHERE   FAssetNumber = 'RZPQT0148';
SELECT  *
FROM    t_FACard
WHERE   FAssetNumber = 'RZPQT0149';
UPDATE  t_FACard
SET     FModel = '长2300*宽600'
WHERE   FAssetNumber = 'RZPQT0149';
SELECT  *
FROM    t_FABalCard
WHERE   FAssetNumber = 'RZPQT0148';
UPDATE  dbo.t_FABalCard
SET     FModel = '长6180*宽600*高900'
WHERE   FAssetNumber = 'RZPQT0148';
SELECT  *
FROM    t_FABalCard
WHERE   FAssetNumber = 'RZPQT0149';
UPDATE  dbo.t_FABalCard
SET     FModel = '长2300*宽600'
WHERE   FAssetNumber = 'RZPQT0149';


SELECT fmodel,RTRIM(fmodel) FROM t_FABalCard WHERE fmodel<>RTRIM(fmodel)
SELECT fmodel,RTRIM(fmodel) FROM t_FACard WHERE fmodel<>RTRIM(fmodel)
