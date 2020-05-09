SELECT a.Z_ORG_ID,CONVERT(VARCHAR(100), Z_SALE_DT, 23) as Z_SALE_DT  
  
      ,sum(Z_TOTAL_MONEY) as Z_TOTAL_MONEY  ,Z_STORE_NM
     
    FROM [zhuok].[dbo].[YINXIANG_DATA]  a inner join [zhuok].[dbo].[DZC_GOODS] b  
    on a.Z_GOODS_ID=b.ID_KEY
    where b.Z_TYPE_NM='÷Ì»‚'
    group by a.Z_ORG_ID,CONVERT(VARCHAR(100), Z_SALE_DT, 23),Z_STORE_NM
 ORDER BY Z_STORE_NM,Z_SALE_DT

--

SELECT a.Z_ORG_ID,CONVERT(VARCHAR(100), Z_SALE_DT, 23) as Z_SALE_DT  
  
      ,sum(Z_TOTAL_MONEY) as Z_TOTAL_MONEY  
     
    FROM [zhuok].[dbo].[YINXIANG_DATA]  a inner join [zhuok].[dbo].[DZC_GOODS] b  
    on a.Z_GOODS_ID=b.ID_KEY
    where b.Z_TYPE_NM='÷Ì»‚'
    group by a.Z_ORG_ID,CONVERT(VARCHAR(100), Z_SALE_DT, 23)
    ORDER BY Z_SALE_DT              