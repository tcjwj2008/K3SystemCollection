SELECT a.Z_ORG_ID ,
                                CONVERT(VARCHAR(100), Z_SALE_DT, 23) AS Z_SALE_DT ,
                                SUM(Z_TOTAL_MONEY) AS Z_TOTAL_MONEY
                         FROM   [zhuok].[dbo].[YINXIANG_DATA] a
                                INNER JOIN [zhuok].[dbo].[DZC_GOODS] b ON a.Z_GOODS_ID = b.ID_KEY
                         WHERE  b.Z_TYPE_NM = '÷Ì»‚'
                                AND b.Z_GOODS_CODE NOT LIKE '7.1.02%'
                                AND b.Z_GOODS_CODE NOT LIKE '8.8.02.02%'
                                AND b.Z_GOODS_CODE NOT LIKE '8.8.03.02%'
                         GROUP BY a.Z_ORG_ID ,
                                CONVERT(VARCHAR(100), Z_SALE_DT, 23)