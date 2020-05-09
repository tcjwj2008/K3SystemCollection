SELECT  a.Z_STORE_ID 猪ＯＫ门店代码,
        a.Z_STORE_NM 猪ＯＫ门店名称,
        CONVERT(VARCHAR(100), Z_SALE_DT, 23) AS 日期,
        SUM(Z_TOTAL_MONEY) AS 收入金额
FROM    [zhuok].[dbo].[YINXIANG_DATA] a
        INNER JOIN [zhuok].[dbo].[DZC_GOODS] b ON a.Z_GOODS_ID = b.ID_KEY
WHERE   b.Z_TYPE_NM = '猪肉'
        AND b.Z_GOODS_CODE NOT LIKE '7.1.02%'
        AND b.Z_GOODS_CODE NOT LIKE '8.8.02.02%'
        AND b.Z_GOODS_CODE NOT LIKE '8.8.03.02%'
GROUP BY a.Z_STORE_ID,
        a.Z_STORE_NM ,
        CONVERT(VARCHAR(100), Z_SALE_DT, 23);