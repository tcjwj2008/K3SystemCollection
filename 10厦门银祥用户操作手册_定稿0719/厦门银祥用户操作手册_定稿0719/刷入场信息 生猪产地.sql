SELECT * FROM TZ_CG_register2019  WHERE RGID='SZ201904110001'

SELECT * FROM TZ_CG_registerdata2019 WHERE RGID='SZ201904110001'


SELECT * FROM TZ_CG_registerwt2019 WHERE RGID='SZ201904110001'


SELECT * FROM TZ_CG_register2019 WHERE  RGID LIKE 'SZ20190410%' AND oneeartag='10'

SELECT * FROM TZ_CG_register2019 WHERE  RGID LIKE 'SZ20190410%' AND oneeartag='09'


SELECT * FROM TZ_CG_register2019 WHERE  RGID LIKE 'SZ20190410%' AND oneeartag='08'
-----------------------------------以下是执行代码------------------------------------------------------


CREATE TABLE #aa(ADDRESS VARCHAR(200),code VARCHAR(20))

insert into #aa(address,code) values('漳州龙海原大禾农业生态园有限公司','W10');
insert into #aa(address,code) values('龙岩长汀天蓬牧业养殖有限公司','Y9');
insert into #aa(address,code) values('漳州龙海原大禾农业生态园有限公司','W8');
insert into #aa(address,code) values('龙岩连城龙岩振沣牧业有限公司','W6');
insert into #aa(address,code) values('龙岩永定永定区呈祥农场','Y7');
insert into #aa(address,code) values('龙岩连城连城更旺生态农业有限公司','Y5');
insert into #aa(address,code) values('龙岩永定振东村旺顺养殖场','Y3');
insert into #aa(address,code) values('龙岩长汀寿生家庭农场','W2');
insert into #aa(address,code) values('厦门同安大同街道养殖场','W4');

SELECT *,SUBSTRING(code,2,3),case WHEN LEN(SUBSTRING(code,2,3))=2 THEN SUBSTRING(code,2,3) ELSE '0'+SUBSTRING(code,2,3) end FROM #aa

ALTER TABLE #aa ADD code2 VARCHAR(10)

UPDATE #aa SET code2=case WHEN LEN(SUBSTRING(code,2,3))=2 THEN SUBSTRING(code,2,3) ELSE '0'+SUBSTRING(code,2,3) END


SELECT * FROM #aa

SELECT address,areaname, * FROM TZ_CG_register2019 t
INNER JOIN #aa a ON code2=t.oneeartag
 WHERE  RGID LIKE 'SZ20190410%'

UPDATE t SET  areaname=address FROM TZ_CG_register2019 t
INNER JOIN #aa a ON code2=t.oneeartag
 WHERE  RGID LIKE 'SZ20190410%'




