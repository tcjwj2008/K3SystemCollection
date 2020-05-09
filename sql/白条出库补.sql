USE yrtzdata
DECLARE @deliverycode VARCHAR(50),@productscode varchar(50),@productcode VARCHAR(50),@oldproductscode VARCHAR(50),@outstoragetime VARCHAR(10),
@Year1 INT,@Month1 INT,@Day1 INT, @Hour1 INT
DECLARE @datetime1 DATETIME,@datetime2 DATETIME,@Year2 VARCHAR(4),@Month2 VARCHAR(2),@Month3 varchar(2),@Day2 VARCHAR(2),@Day3 VARCHAR(2),
@datetime3 DATETIME,@Day4 INT ,@Day5 INT,@productscode_New VARCHAR(50)
DECLARE mycursor CURSOR FOR
SELECT  a.deliverycode, productname,productscode,oldproductscode,outstoragetime,DATEPART(HOUR,outstoragetime) AS Hour1 
FROM TZ_XS_deliveryinfo2019 a  INNER JOIN   TZ_XS_delivery2019 b on a.deliverycode=b.deliverycode WHERE
stutus>=0  and isdelete=0  AND  outstoragetime >='2019-01-16 20:00:00.000'  AND outstoragetime <='2019-01-17 08:00:00.000'
AND productscode LIKE '%YXBT%'  AND  productscode NOT IN (SELECT  carcasscode FROM TZ_SC_pig2019 WHERE weightpalce =0)
ORDER BY outstoragetime
open mycursor
FETCH next from mycursor into @deliverycode,@productcode,@productscode,@oldproductscode,@outstoragetime,@Hour1
WHILE @@FETCH_STATUS=0
BEGIN
	SET @productscode_New =NULL
	SELECT @Day4= DATEPART(DAY,DATEADD(mm,DATEDIFF(mm,0,@datetime3),0))
	,@Day5=DATEPART(DAY,DATEADD(DAY,-1,DATEADD( MONTH,1,DATEADD(mm,DATEDIFF(mm,0,@datetime3),0))))
	IF @Hour1 >16 
	BEGIN
		SET @datetime1  = CONVERT(DATETIME,@outstoragetime + ' 20:00')
		SET @datetime2 = DATEADD( HOUR,-12,DATEADD(DAY,1,@datetime1))
	END
	ELSE IF @Hour1 <8
	BEGIN
		SET @datetime1  = DATEADD(DAY,-1,CONVERT(DATETIME,@outstoragetime + ' 20:00'))
		SET @datetime2 = DATEADD( HOUR,-12,DATEADD(DAY,1,@datetime1))
	END
    
	--select @datetime1 ,@datetime2
	IF not EXISTS(SELECT * FROM TZ_SC_pig2019 WHERE weightpalce =0 AND carcasscode =@productscode  )
	BEGIN
		--PRINT 1
	SELECT  TOP 1 @productscode_New=carcasscode FROM TZ_SC_pig2019 a ,TZ_ZD_product b WHERE carcasscode NOT IN
	(SELECT  productscode FROM TZ_XS_deliveryinfo2019 WHERE  weightpalce =0) AND a.productcode=b.productcode

	AND weightpalce =0 AND   killtime >@datetime1 AND killtime <@datetime2 AND ISNULL(a.pigcode,'')<>''
	-- AND b.productname =@productcode 
	--SELECT  @productscode_New,@productcode
	IF @productscode_New IS NOT NULL
    BEGIN
     
		UPDATE  TZ_XS_deliveryinfo2019 SET productscode =@productscode_New,oldproductscode =@productscode WHERE deliverycode =@deliverycode 
		AND productscode =@productscode
		IF @@ERROR >0
		BEGIN
			ROLLBACK
		END
    
		UPDATE TZ_SC_pig2019 SET outtype =0 WHERE carcasscode =@productscode_New
	END
    
	END
	FETCH next from mycursor into @deliverycode,@productcode,@productscode,@oldproductscode,@outstoragetime,@Hour1
END
close mycursor
deallocate mycursor 

