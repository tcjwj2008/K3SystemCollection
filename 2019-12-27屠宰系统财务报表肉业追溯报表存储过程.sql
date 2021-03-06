USE [yxceshi];
GO
/****** Object:  StoredProcedure [dbo].[up_xsfh_bt]    Script Date: 12/27/2019 08:54:15 ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
ALTER PROC [dbo].[up_xsfh_bt]
AS
    BEGIN
        DECLARE @deliverycode VARCHAR(50) ,
            @productscode VARCHAR(50) ,
            @productcode VARCHAR(50) ,
            @oldproductscode VARCHAR(50) ,
            @outstoragetime VARCHAR(10) ,
            @Year1 INT ,
            @Month1 INT ,
            @Day1 INT ,
            @Hour1 INT;
        DECLARE @datetime1 DATETIME ,
            @datetime2 DATETIME ,
            @Year2 VARCHAR(4) ,
            @Month2 VARCHAR(2) ,
            @Month3 VARCHAR(2) ,
            @Day2 VARCHAR(2) ,
            @Day3 VARCHAR(2) ,
            @datetime3 DATETIME ,
            @Day4 INT ,
            @Day5 INT ,
            @productscode_New VARCHAR(50);
        DECLARE @year VARCHAR(4) ,
            @year6 VARCHAR(4);
        DECLARE @month VARCHAR(2) ,
            @month6 VARCHAR(2);
        DECLARE @day VARCHAR(2) ,
            @day6 VARCHAR(2);
        SELECT  @year = DATEPART(YEAR, GETDATE()) ,
                @month = DATEPART(MONTH, GETDATE()) ,
                @day = DATEPART(DAY, GETDATE() - 1);
        SELECT  @year6 = DATEPART(YEAR, GETDATE()) ,
                @month6 = DATEPART(MONTH, GETDATE()) ,
                @day6 = DATEPART(DAY, GETDATE());
                
        --SELECT  @year = 2019,
        --        @month =10 ,
        --        @day = 02;
        --SELECT  @year6 = 2019 ,
        --        @month6 = 10,
        --        @day6 = 03;           
                
                
        DECLARE mycursor CURSOR
        FOR
            SELECT  a.deliverycode ,
                    productname ,
                    productscode ,
                    oldproductscode ,
                    outstoragetime ,
                    DATEPART(HOUR, outstoragetime) AS Hour1
            FROM    TZ_XS_deliveryinfo2019 a
                    INNER JOIN TZ_XS_delivery2019 b ON a.deliverycode = b.deliverycode
            WHERE   stutus >= 0
                    AND isdelete = 0
                    AND outstoragetime >= @year + '-' + @month + '-' + @day
                    + ' 20:00:00.000'
                    AND outstoragetime <= @year6 + '-' + @month6 + '-' + @day6
                    + ' 08:00:00.000'
                    AND productscode LIKE '%YXBT%'
                   -- AND a.productname='冷鲜带蹄白条A级'  --测试添加条件
                    AND productscode NOT IN (
                    SELECT  carcasscode
                    FROM    TZ_SC_pig2019
                    WHERE   ISNULL(pigkillID, '') <> ''
                    
                    --限定时间
                            AND killtime >= @year + '-' + @month + '-' + @day
                            + ' 20:00:00.000'
                            AND killtime <= @year6 + '-' + @month6 + '-'
                            + @day6 + ' 08:00:00.000' )
            ORDER BY outstoragetime;
        OPEN mycursor;
        FETCH NEXT FROM mycursor INTO @deliverycode, @productcode,
            @productscode, @oldproductscode, @outstoragetime, @Hour1;
        WHILE @@FETCH_STATUS = 0
            BEGIN
                PRINT '修改前的物料编码：'+ @productscode+'|物料名称：'+@productcode+'|旧代码：'+@oldproductscode
                SET @productscode_New = NULL;
           
                IF @Hour1 > 16
                    BEGIN
                        SET @datetime1 = CONVERT(DATETIME, @outstoragetime
                            + ' 20:00');
                        SET @datetime2 = DATEADD(HOUR, -12,
                                                 DATEADD(DAY, 1, @datetime1));
                    END;
                ELSE
                    IF @Hour1 < 8
                        BEGIN
                            SET @datetime1 = DATEADD(DAY, -1,
                                                     CONVERT(DATETIME, @outstoragetime
                                                     + ' 20:00'));
                            SET @datetime2 = DATEADD(HOUR, -12,
                                                     DATEADD(DAY, 1,
                                                             @datetime1));
                        END;
    

                IF NOT EXISTS ( SELECT  *
                                FROM    TZ_SC_pig2019
                                WHERE   weightpalce = 0
                                        AND carcasscode = @productscode 
                            --增加限定时间
                                        AND killtime >= @year + '-' + @month
                                        + '-' + @day + ' 20:00:00.000'
                                        AND killtime <= @year6 + '-' + @month6
                                        + '-' + @day6 + ' 08:00:00.000' )
                    BEGIN

                        SELECT TOP 1
                                @productscode_New = carcasscode
                        FROM    TZ_SC_pig2019 a ,
                                TZ_ZD_product b
                        WHERE   carcasscode NOT IN (
                                SELECT  productscode
                                FROM    TZ_XS_deliveryinfo2019
                                WHERE   weightpalce = 0                               
                                
                                --增加限定时间
                                 AND outstoragetime >= @year + '-' + @month + '-' + @day
								+ ' 20:00:00.000'
								AND outstoragetime <= @year6 + '-' + @month6 + '-' + @day6
								+ ' 08:00:00.000'                                
                                
                                 )
                                AND a.productcode = b.productcode
                                AND a.isdelete = 0
                                AND a.pigkillID <> ''
                                AND weightpalce = 0
                                AND killtime > @datetime1
                                AND killtime < @datetime2
                                AND ISNULL(a.pigcode, '') <> ''
                                --设定同个产品要一样
                               --AND a.productname =@productcode ;
                        IF @productscode_New IS NOT NULL
                            BEGIN
     
                                UPDATE  TZ_XS_deliveryinfo2019
                                SET     productscode = @productscode_New ,
                                        oldproductscode = @productscode
                                WHERE   deliverycode = @deliverycode
                                        AND productscode = @productscode;
                                IF @@ERROR > 0
                                    BEGIN
                                        ROLLBACK;
                                    END;
    
                                UPDATE  TZ_SC_pig2019
                                SET     outtype = 0
                                WHERE   carcasscode = @productscode_New;

                              
                            END
                            ELSE
                            BEGIN
                              PRINT '没有获取到新编码！';
                            END
                        PRINT @productscode_New;
                    END;
                FETCH NEXT FROM mycursor INTO @deliverycode, @productcode,
                    @productscode, @oldproductscode, @outstoragetime, @Hour1;
            END;
        CLOSE mycursor;
        DEALLOCATE mycursor; 

    END;
