USE [YXERP]
GO
/****** Object:  StoredProcedure [dbo].[sp_checkToyx_rs_ysprice]    Script Date: 08/06/2019 08:47:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROC [dbo].[sp_checkToyx_rs_ysprice] @FuserName VARCHAR(100) 
AS 
DECLARE @msg VARCHAR(500)--消息        
DECLARE @isok INT   

IF EXISTS(SELECT 1 FROM yx_rs_ysprice_CHECK WHERE fnumber IS NULL OR fnumber='' )        
begin        
 SET @msg='有编号为空的单据！'        
 SET @isok=-1        
  DELETE yx_rs_ysprice_CHECK WHERE FuserName=@FuserName        
  GOTO ENDD        
END 

IF EXISTS(SELECT 1 FROM yx_rs_ysprice_CHECK WHERE fdate IS NULL )        
begin        
 SET @msg='有日期为空的单据！'        
 SET @isok=-1        
  DELETE yx_rs_ysprice_CHECK WHERE FuserName=@FuserName        
  GOTO ENDD        
END 

IF EXISTS(SELECT * FROM yx_rs_ysprice_CHECK WHERE fprice IS NULL  )        
begin        
 SET @msg='有单价为空的单据！'        
 SET @isok=-1        
  DELETE yx_rs_ysprice_CHECK WHERE FuserName=@FuserName        
  GOTO ENDD        
END 

IF EXISTS( SELECT COUNT(id),MAX(fnumber) FROM yx_rs_ysprice_CHECK
           WHERE FuserName=@FuserName   
           GROUP BY fnumber,fdate 
           HAVING COUNT(id)>1  )        
begin   
  declare @fnumber varchar(100)
 SELECT @fnumber=MAX(fnumber) FROM yx_rs_ysprice_CHECK
           WHERE FuserName=@FuserName   
           GROUP BY fnumber,fdate 
           HAVING COUNT(id)>1    
 SET @msg='同一天同物料有重复的记录,物料代码为：'+ @fnumber       
 SET @isok=-1        
  DELETE yx_rs_ysprice_CHECK WHERE FuserName=@FuserName        
  GOTO ENDD        
END 


IF EXISTS(SELECT 1 FROM yx_rs_DayHeadNum_Check WHERE fdate IS NULL )        
begin        
 SET @msg='当天屠宰日期不能为空！Sheet2!!!'        
 SET @isok=-1        
  DELETE yx_rs_DayHeadNum_Check WHERE FuserName=@FuserName        
  GOTO ENDD        
END 

IF EXISTS(SELECT 1 FROM yx_rs_DayHeadNum_Check WHERE FDayHeadNum IS NULL )        
begin        
 SET @msg='当天屠宰头数不能为空！Sheet2!!!'        
 SET @isok=-1        
  DELETE yx_rs_DayHeadNum_Check WHERE FuserName=@FuserName        
  GOTO ENDD        
END 


 SET @msg='检查正常！'        
 SET @isok=1        
        
  
  
  
        
ENDD:SELECT @msg AS msg,@isok AS isok   


