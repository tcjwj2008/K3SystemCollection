
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC yunrui_item_insert_csp(@FNumber VARCHAR(200))
as
BEGIN
	IF EXISTS(SELECT  * FROM CON12.yrtzdata.dbo.TZ_ZD_product WHERE productcode =@FNumber)
	BEGIN
		RAISERROR('已经存在该产品',16,1)--提交错误信息。
		RETURN--退出过程
    end
	DECLARE @FName VARCHAR(500),@sortone INT,@sorttwo INT,@leibie VARCHAR(30),@sweight FLOAT,@sunit VARCHAR(10)
	declare @pid int ,@sortcode varchar(100)      
	set @pid=-1   
	SELECT  @FName=a.FName,@sweight =FSecCoefficient,@sunit =b.FName ,@leibie=c.FName FROM dbo.t_ICItem a LEFT JOIN
	dbo.t_MeasureUnit b  ON a.FSecUnitID=b.FMeasureUnitID LEFT JOIN t_SubMessage c ON a.f_107 =c.FInterID WHERE a.FNumber =@FNumber
	IF(@FNumber LIKE '7.1.01%')
	BEGIN	
		SELECT @sortone =2
		IF(@FNumber LIKE '7.1.01.01%')
 			SELECT  @sortcode ='01'
		ELSE IF(@FNumber LIKE '7.1.01.02%')
			SELECT  @sortcode ='02'
		ELSE IF(@FNumber LIKE '7.1.01.03%')
			SELECT  @sortcode ='03'
		ELSE IF(@FNumber LIKE '7.1.01.04%')
			SELECT  @sortcode ='09'
	END 
	ELSE IF (@FNumber LIKE '7.1.02%')
	BEGIN
		SELECT @sortone =1
		IF(@FNumber LIKE '7.1.02.01%')
			SELECT  @sortcode ='05'
		ELSE IF(@FNumber LIKE '7.1.02.02%')
			SELECT  @sortcode ='06'
	END
	ELSE
		SELECT @sortone =0
	IF @leibie ='白条'
		SET @sorttwo =1
	ELSE IF @leibie ='副产品'
		SET @sorttwo =2
	ELSE IF @leibie ='分割品'
		SET @sorttwo =3 
	ELSE
		SET @sorttwo =0
	IF ISNULL(@sunit,'')=''
		SELECT  @sunit ='头'
	
	INSERT into CON12.yrtzdata.dbo.TZ_ZD_product(productcode,productname,levelcode,levelname,PYcode,sortone,sorttwo,mnemoniccode,      
          shelflife,shelflifeunit,sweight,EANcode,showname,sunit,sortthree,explaintxt,eatwaytxt,sflag)       
	values (@FNumber,@FName,'','',dbo.SYS_GETPYM(@FName),@sortone,@sorttwo,      
          '',0,'日',@sweight,'',@FName,CASE @sortcode WHEN  '09' THEN '盒'else  ISNULL(@sunit,'头') end,'','',      
          '',CASE @sortcode WHEN  '09' THEN 1 ELSE   0 end)
		  SELECT  @pid=pid FROM CON12.yrtzdata.dbo.TZ_ZD_product WHERE productcode =@FNumber
	/*SELECT  CID,pid,productcode,levelcode,CGlevelcode,deviation,measuretype,saletype,      
          saleunit,showcode,discountflag,measurevalue,minprice,shownumber,appshowname,appshowflag,mnemoniccode,      
          shelflife,shelflifeunit,sweight,sunit,halfflag,sflag,judgecaption,fpflag,onepackcount,ischeck,      
          packweight,platequantity,reducerate,reduceweight,lowerdeviation,weightinflag,printfilename FROM CON12.yrtzdata.dbo.TZ_ZD_Pproduct*/
	INSERT INTO CON12.yrtzdata.dbo.TZ_ZD_Pproduct (CID,pid,productcode,levelcode,CGlevelcode,deviation,measuretype,saletype,      
          saleunit,showcode,discountflag,measurevalue,minprice,shownumber,appshowname,appshowflag,mnemoniccode,      
          shelflife,shelflifeunit,sweight,sunit,halfflag,sflag,judgecaption,fpflag,onepackcount,ischeck,      
          packweight,platequantity,reducerate,reduceweight,lowerdeviation,weightinflag,printfilename)       
	VALUES ('11',@pid,@FNumber,'','',-1,CASE @sorttwo  WHEN  2 THEN 3 ELSE 0 end,0,CASE WHEN @sortcode ='09'  THEN '盒' ELSE '公斤' end,      
          '',0,0,0,0,@FName,1,'',      
          0,'日',@sweight,CASE @sortcode WHEN  '09' THEN '盒' ELSE   ISNULL(@sunit,'头') end,CASE WHEN @sortcode ='01' THEN 1 ELSE 0 END,CASE @sortcode WHEN  '09' THEN 1 ELSE   0 end,
		  @FName,0,0,      
          0,0,0,0,0,-1,CASE WHEN @sortcode ='09' THEN 1 ELSE 0 end,'')   
	--SELECT  * FROM CON12.yrtzdata.dbo.TZ_ZD_productsort

	 INSERT INTO CON12.yrtzdata.dbo.TZ_ZD_productsort (sortway,sortcode,productcode,levelcode) 
	 VALUES (1,@sortcode,@FNumber,'')        
	 SELECT 1
END
GO
