SELECT  *                         --2��
FROM    t_FACard
WHERE   FAssetNumber = '352';  
--1�����Ĺ̶��ʲ���Ƭ�ϵ�����
UPDATE  t_FACard
SET     FAssetName = '���������������̨��NEW'
WHERE   FAssetNumber = '352';  

--2\���ģ���ѯ�������ݵĻ�������ģ�  --��
SELECT  *
FROM    t_FaTransAssetApp
WHERE   FAssetNumber = '352';  
UPDATE  t_FaTransAssetApp
SET     FAssetName =  '���������������̨��NEW'
WHERE   FAssetNumber = '352';  
--3\��α䶯������
SELECT  *                          --1��
FROM    t_FACardMulAlter
WHERE FAssetNumber = '352'; 
UPDATE  t_FACardMulAlter
SET     FAssetName =  '���������������̨��NEW'
WHERE   FAssetNumber = '352';  
--4\����ÿ��״����
SELECT  *                          --90��
FROM    t_FABalCard
WHERE   FAssetNumber = '352';  
UPDATE  t_FABalCard
SET     FAssetName =  '���������������̨��NEW'
WHERE   FAssetNumber = '352';  


