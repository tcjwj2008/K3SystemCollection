SELECT * FROM TZ_CG_register2019  WHERE RGID='SZ201904110001'

SELECT * FROM TZ_CG_registerdata2019 WHERE RGID='SZ201904110001'


SELECT * FROM TZ_CG_registerwt2019 WHERE RGID='SZ201904110001'


SELECT * FROM TZ_CG_register2019 WHERE  RGID LIKE 'SZ20190410%' AND oneeartag='10'

SELECT * FROM TZ_CG_register2019 WHERE  RGID LIKE 'SZ20190410%' AND oneeartag='09'


SELECT * FROM TZ_CG_register2019 WHERE  RGID LIKE 'SZ20190410%' AND oneeartag='08'
-----------------------------------������ִ�д���------------------------------------------------------


CREATE TABLE #aa(ADDRESS VARCHAR(200),code VARCHAR(20))

insert into #aa(address,code) values('��������ԭ���ũҵ��̬԰���޹�˾','W10');
insert into #aa(address,code) values('���ҳ�͡������ҵ��ֳ���޹�˾','Y9');
insert into #aa(address,code) values('��������ԭ���ũҵ��̬԰���޹�˾','W8');
insert into #aa(address,code) values('������������������ҵ���޹�˾','W6');
insert into #aa(address,code) values('������������������ũ��','Y7');
insert into #aa(address,code) values('�����������Ǹ�����̬ũҵ���޹�˾','Y5');
insert into #aa(address,code) values('���������񶫴���˳��ֳ��','Y3');
insert into #aa(address,code) values('���ҳ�͡������ͥũ��','W2');
insert into #aa(address,code) values('����ͬ����ͬ�ֵ���ֳ��','W4');

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




