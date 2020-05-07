/****** Script for SelectTopNRows command from SSMS  ******/
SELECT a.Z_ORG_ID,Z_STORE_ID,Z_STORE_NM,Z_SALE_DT    
      ,sum(Z_TOTAL_MONEY) --avg min max count
      ,sum(Z_TOTAL_NUM)
      ,sum(Z_TOTAL_Z_WEIGHT)
     
  FROM [zhuok].[dbo].[YINXIANG_DATA]  a inner join [zhuok].[dbo].[DZC_GOODS] b
  
  on a.Z_GOODS_ID=b.ID_KEY
  where b.Z_TYPE_NM='÷Ì»‚'
  group by a.Z_ORG_ID,Z_STORE_ID,Z_STORE_NM,Z_SALE_DT
  order by Z_SALE_DT,z_store_id
  
  