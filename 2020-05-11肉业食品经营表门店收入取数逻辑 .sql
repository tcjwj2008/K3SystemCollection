USE [YXERP]
GO
/****** Object:  StoredProcedure [dbo].[sp_sel_rsjybmdsl_qiu]    Script Date: 05/11/2020 17:14:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
alter   PROC [dbo].[sp_sel_rsjybmdsr_qiu] -- [sp_sel_rsjybmdsr_qiu] '2020-05-02','10.11'
    (
      @FDate VARCHAR(100) ,   --开始日期            
      @fdepnumber VARCHAR(100)--部门代码  
    )
AS
    BEGIN  
        DECLARE @EndDate2 VARCHAR(100);
        SET @EndDate2 = CONVERT(VARCHAR(100), DATEADD(DAY, 1,
                                                      CONVERT(DATETIME, @FDate)));

                SELECT 
                                CONVERT(VARCHAR(100), Z_SALE_DT, 23) AS 日期 ,
                                a.Z_STORE_NM AS 门店,
                                b.Z_GOODS_CODE AS 物料代码,
                                b.Z_GOODS_NM AS 物料名称,                              
                                (Z_TOTAL_MONEY) AS 金额
                         FROM   [zhuok].[dbo].[YINXIANG_DATA] a
                                INNER JOIN [zhuok].[dbo].[DZC_GOODS] b ON a.Z_GOODS_ID = b.ID_KEY
                         WHERE  b.Z_TYPE_NM = '猪肉'
                                AND b.Z_GOODS_CODE NOT LIKE '7.1.02%'
                                AND b.Z_GOODS_CODE NOT LIKE '8.8.02.02%'
                                AND b.Z_GOODS_CODE NOT LIKE '8.8.03.02%'
                                AND CONVERT(VARCHAR(100), Z_SALE_DT, 23)=@FDate
                                
                                
                                
                        UNION ALL
                            SELECT 
                                CONVERT(VARCHAR(100), Z_SALE_DT, 23) AS 日期 ,
                                '' AS 门店,
                                '' AS 物料代码,
                                '' 物料名称,                              
                                SUM(Z_TOTAL_MONEY) AS 金额
                         FROM   [zhuok].[dbo].[YINXIANG_DATA] a
                                INNER JOIN [zhuok].[dbo].[DZC_GOODS] b ON a.Z_GOODS_ID = b.ID_KEY
                         WHERE  b.Z_TYPE_NM = '猪肉'
                                AND b.Z_GOODS_CODE NOT LIKE '7.1.02%'
                                AND b.Z_GOODS_CODE NOT LIKE '8.8.02.02%'
                                AND b.Z_GOODS_CODE NOT LIKE '8.8.03.02%'
                                AND CONVERT(VARCHAR(100), Z_SALE_DT, 23)=@FDate 
                                
                                GROUP BY 
                                CONVERT(VARCHAR(100), Z_SALE_DT, 23)       
                        
                      
  
    END; 



