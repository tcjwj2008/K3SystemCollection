
UPDATE b set B.F_102=C.F5,B.F_106=C.F5

SELECT CONVERT(VARCHAR(100),B.F_102)
FROM T_ICItemCore A,
 T_ICItemCustom B ,dbo.[test_codeX] C WHERE A.FItemID=B.FItemID  AND 
 C.F1=A.FNumber


SELECT CONVERT(BIGINT,C.F5)
FROM T_ICItemCore A,
 T_ICItemCustom B ,dbo.[test_code] C WHERE A.FItemID=B.FItemID  AND 
 C.F1=A.FNumber


 DROP TABLE [test_code];
 DROP TABLE [test_codeX]
 DROP TABLE [test_code$]
