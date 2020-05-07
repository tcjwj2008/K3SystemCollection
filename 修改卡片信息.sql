SELECT  *                         --2行
FROM    t_FACard
WHERE   FAssetNumber = '352';  
--1、更改固定资产卡片上的名称
UPDATE  t_FACard
SET     FAssetName = '三星数码相机（两台）NEW'
WHERE   FAssetNumber = '352';  

--2\更改（查询，有数据的话，需更改）  --无
SELECT  *
FROM    t_FaTransAssetApp
WHERE   FAssetNumber = '352';  
UPDATE  t_FaTransAssetApp
SET     FAssetName =  '三星数码相机（两台）NEW'
WHERE   FAssetNumber = '352';  
--3\多次变动基本表
SELECT  *                          --1行
FROM    t_FACardMulAlter
WHERE FAssetNumber = '352'; 
UPDATE  t_FACardMulAlter
SET     FAssetName =  '三星数码相机（两台）NEW'
WHERE   FAssetNumber = '352';  
--4\更改每期状况表
SELECT  *                          --90行
FROM    t_FABalCard
WHERE   FAssetNumber = '352';  
UPDATE  t_FABalCard
SET     FAssetName =  '三星数码相机（两台）NEW'
WHERE   FAssetNumber = '352';  


