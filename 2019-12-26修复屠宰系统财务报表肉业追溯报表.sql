USE yxceshi;
--up_xsfh_bt
SELECT   DISTINCT productname
--update TZ_XS_deliveryinfo2019 set productscode='YXBT11111111111111',OLDPRODUCTSCODE=''
FROM dbo.TZ_XS_deliveryinfo2019 t
WHERE 
 producttime>='2019-10-02 20:21:59.000' AND producttime<='2019-10-03 06:29:59.000'
--ORDER BY t.producttime DESC

SELECT DISTINCT productname FROM TZ_SC_pig2019 WHERE  
冷鲜带蹄白条A级
冷鲜带蹄白条A级
    killtime>='2019-10-02 20:21:59.000' AND killtime<='2019-10-03 06:29:59.000'