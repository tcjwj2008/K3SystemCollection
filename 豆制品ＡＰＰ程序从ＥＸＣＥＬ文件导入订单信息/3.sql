SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
ALTER   PROC [dbo].[sp_k3_2checkApp_qiu] ( @FNAME VARCHAR(50) )
AS
    DECLARE @msg VARCHAR(500);--消息      
    DECLARE @isok INT;       
    DECLARE @k3userid INT;       
 
--判断是否有用户      
    SELECT  @k3userid = ISNULL(FUserID, 0)
    FROM    t_User
    WHERE   FName = @FNAME;      
    IF ISNULL(@k3userid, 0) = 0
        BEGIN      
            SET @msg = '您在K3系统中没有注册用户！';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
      
        END;       
--判断空值      
    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND Fbillno IS NULL )
        BEGIN      
            SET @msg = '有编号为空的单据！';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;       
    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND Fdate IS NULL )
        BEGIN      
            SET @msg = '有日期为空的单据！';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;       
    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND Fpax IS NULL )
        BEGIN      
            SET @msg = '有批发行为空的单据！';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;

    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FNumberC IS NULL )
        BEGIN      
            SET @msg = '有客户代码为空的单据！';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;  

    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FNumberC NOT IN ( SELECT    FNumber
                                              FROM      dbo.t_Organization ) )
        BEGIN      
            SET @msg = '有客户代码不存在K3客户表的单据！';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;         

      
      
    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FWeight IS NULL )
        BEGIN      
            SET @msg = '有重量为空的单据！';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;   
    
     
      

    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FNumberM IS NULL )
        BEGIN      
            SET @msg = '有物料代码为空的单据！';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END; 

    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FNumberM NOT IN ( SELECT    FNumber
                                              FROM      dbo.t_ICItem ) )
        BEGIN      
            SET @msg = '有物料代码不存在K3物料表的单据！';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END; 

       
      
    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FSTOCK IS NULL )
        BEGIN      
            SET @msg = '有仓库为空的单据！';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;  

    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FSTOCK NOT IN ( '屠宰半成品', '分割成品仓', '排酸成品仓' ) )
        BEGIN      
            SET @msg = '有仓库超出范围的单据！';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;  


        
      
--判断期间      
    DECLARE @y INT;       
    DECLARE @m INT;       
      
    DECLARE @CurrentYear INT;       
    DECLARE @CurrentPeriod INT;       
    SELECT  @CurrentYear = CONVERT(INT, FValue)
    FROM    t_SystemProfile
    WHERE   FCategory = 'IC'
            AND FKey = 'CurrentYear';      
    SELECT  @CurrentPeriod = CONVERT(INT, FValue)
    FROM    t_SystemProfile
    WHERE   FCategory = 'IC'
            AND FKey = 'CurrentPeriod';      
      
    SELECT  @y = DATEPART(YEAR, MIN(Fdate)) ,
            @m = DATEPART(MONTH, MIN(Fdate))
    FROM    k3_2inSalelibrary
    WHERE   FNAME = @FNAME;      
      
--IF (@CurrentPeriod>@y) OR (@CurrentPeriod> @m)      
--BEGIN      
-- SET @msg='导入的日期有小于当前期间的数据！'      
-- SET @isok=-1      
--  DELETE k3_2inSalelibrary WHERE FNAME=@FNAME      
--  GOTO ENDD      
--END       
      
    SET @msg = '检查正常！';      
    SET @isok = 1;      
      
      
    ENDD:
    SELECT  @msg AS msg ,
            @isok AS isok;       
       
--写入存储过程 