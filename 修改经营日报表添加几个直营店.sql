USE [YXERP]
GO
/****** Object:  StoredProcedure [dbo].[sp_sel_rsjyb]    Script Date: 08/22/2019 15:42:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER     PROC [dbo].[sp_sel_rsjyb](      
    @BegDate  VARCHAR(100),  --开始日期                
    @EndDate  VARCHAR(100),  --结束日期       
    @fdepnumber VARCHAR(100),--部门代码 
    @fType VARCHAR(2)        --特殊过滤  
)      
AS 
DECLARE @BegDate1  VARCHAR(100), --开始日期                
    @EndDate1  VARCHAR(100),     --结束日期       
    @fdepnumber1 VARCHAR(100),   --部门代码 
    @fType1 VARCHAR(2)   ,        --特殊过滤 
    
    @EndDate2 varchar(100),
    @CalNum float,
    @CalKg    float
    set @CalKg=0
    set @CalNum=0
    set  @EndDate2=convert(varchar(100),DATEADD(DAY,1,CONVERT(datetime,@EndDate)))
    SELECT @BegDate1=@BegDate,@EndDate1=@EndDate,@fdepnumber1=@fdepnumber,@fType1=@fType
    SELECT @fType='1'   --取消过滤
      
    SELECT 'R' AS ztname,v.fdate,w.fnumber AS wnumber ,t.FNumber AS dnumber,      
		CASE t.fnumber WHEN '10.12' THEN u.FSecQty WHEN '10.13' THEN u.FSecQty 
		ELSE 0.0000 END FSecQty,      
		FAuxQty,
		FConsignPrice,
		FConsignAmount,ISNULL(p.fprice,0.000) AS fCBprice      
    INTO #rsjybmx      
    FROM  ais_yxry2.dbo.ICStockBillEntry u      
	INNER JOIN  ais_yxry2.dbo.ICStockBill v ON v.finterid=u.FInterID      
	INNER JOIN  ais_yxry2.dbo.t_item w ON w.FItemID=u.FItemID  AND FItemClassID=4      
	LEFT  JOIN  ais_yxry2.dbo.t_Department t ON t.FItemID=v.FDeptID      
	LEFT  JOIN  yx_rs_ysprice p ON p.fnumber=w.fnumber AND p.fdate=v.fdate      
	LEFT  JOIN  ais_yxry2.dbo.t_Stock s ON s.FItemID=u.FDCStockID       
	WHERE v.FTranType=21 AND v.FCancellation=0      
	AND v.fdate BETWEEN  @BegDate1 AND @EndDate1      
	AND t.fnumber LIKE '%'+@fdepnumber1+'%'      
	AND t.fnumber>='10.12' AND  t.fnumber<='10.18'      
	AND t.fnumber<>'10.14'      
	AND  CHARINDEX('号',s.fname)=0    
  
  
--加入10.19   
    INSERT INTO #rsjybmx (ztname,fdate, wnumber,dnumber,FSecQty,FAuxQty,FConsignPrice,FConsignAmount,fCBprice)      
    SELECT 'R' AS ztname,v.fdate,w.fnumber AS wnumber ,t.FNumber AS dnumber,      
	CASE t.fnumber WHEN '10.12' THEN u.FSecQty WHEN '10.13' THEN u.FSecQty ELSE 0.0000 END FSecQty,      
	FQty,FConsignPrice,FConsignAmount,ISNULL(p.fprice,0.000) AS fCBprice      
	FROM  ais_yxry2.dbo.ICStockBillEntry u      
	INNER JOIN  ais_yxry2.dbo.ICStockBill v ON v.finterid=u.FInterID      
	INNER JOIN  ais_yxry2.dbo.t_item w ON w.FItemID=u.FItemID  AND FItemClassID=4      
	LEFT JOIN  ais_yxry2.dbo.t_Department t ON t.FItemID=v.FDeptID      
	LEFT JOIN yx_rs_ysprice p ON p.fnumber=w.fnumber AND p.fdate=v.fdate      
	LEFT JOIN  ais_yxry2.dbo.t_Stock s ON s.FItemID=u.FDCStockID       
	WHERE v.FTranType=21 AND v.FCancellation=0      
	AND v.fdate BETWEEN  @BegDate1 AND @EndDate1      
	AND t.fnumber LIKE '%'+@fdepnumber1+'%'      
	AND t.fnumber='10.19'      
	AND  CHARINDEX('号',s.fname)=0 
	AND  CHARINDEX('小副',t.fname)>0  

    --从肉业取数, 加入10.20   
    INSERT INTO #rsjybmx (ztname,fdate, wnumber,dnumber,FSecQty,FAuxQty,FConsignPrice,FConsignAmount,fCBprice)      
    SELECT 'R' AS ztname,v.fdate,w.fnumber AS wnumber ,t.FNumber AS dnumber,      
	CASE t.fnumber WHEN '10.12' THEN u.FSecQty WHEN '10.13' THEN u.FSecQty ELSE 0.0000 END FSecQty,      
	FQty,FConsignPrice,FConsignAmount,ISNULL(p.fprice,0.000) AS fCBprice      
	FROM  ais_yxry2.dbo.ICStockBillEntry u      
	INNER JOIN  ais_yxry2.dbo.ICStockBill v ON v.finterid=u.FInterID      
	INNER JOIN  ais_yxry2.dbo.t_item w ON w.FItemID=u.FItemID  AND FItemClassID=4      
	LEFT JOIN  ais_yxry2.dbo.t_Department t ON t.FItemID=v.FDeptID      
	LEFT JOIN yx_rs_ysprice p ON p.fnumber=w.fnumber AND p.fdate=v.fdate      
	LEFT JOIN  ais_yxry2.dbo.t_Stock s ON s.FItemID=u.FDCStockID       
	WHERE v.FTranType=21 AND v.FCancellation=0      
	AND v.fdate BETWEEN  @BegDate1 AND @EndDate1 
	AND t.fnumber='10.20' 
	AND  CHARINDEX('号',s.fname)=0 

--从肉业取数, 加入10.21  
	INSERT INTO #rsjybmx (ztname,fdate, wnumber,dnumber,FSecQty,FAuxQty,FConsignPrice,FConsignAmount,fCBprice)      
	SELECT 'R' AS ztname,v.fdate,w.fnumber AS wnumber ,t.FNumber AS dnumber,      
	CASE t.fnumber WHEN '10.12' THEN u.FSecQty WHEN '10.13' THEN u.FSecQty ELSE 0.0000 END FSecQty,      
	FQty,FConsignPrice,FConsignAmount,ISNULL(p.fprice,0.000) AS fCBprice      
	FROM  ais_yxry2.dbo.ICStockBillEntry u      
	INNER JOIN  ais_yxry2.dbo.ICStockBill v ON v.finterid=u.FInterID      
	INNER JOIN  ais_yxry2.dbo.t_item w ON w.FItemID=u.FItemID  AND FItemClassID=4 AND w.FNumber NOT LIKE '8%'     
	LEFT JOIN  ais_yxry2.dbo.t_Department t ON t.FItemID=v.FDeptID      
	LEFT JOIN yx_rs_ysprice p ON p.fnumber=w.fnumber AND p.fdate=v.fdate      
	LEFT JOIN  ais_yxry2.dbo.t_Stock s ON s.FItemID=u.FDCStockID       
	WHERE v.FTranType=21 AND v.FCancellation=0      
	AND v.fdate BETWEEN  @BegDate1 AND @EndDate1 
	AND t.fnumber='10.21' 
	AND  CHARINDEX('号',s.fname)=0 
   
      
INSERT INTO #rsjybmx (ztname,fdate, wnumber,dnumber,FSecQty,FAuxQty,FConsignPrice,FConsignAmount,fCBprice)      
	SELECT 'S' AS ztname,v.fdate,w.fnumber AS wnumber ,t.FNumber AS dnumber,      
	CASE t.fnumber WHEN '10.12' THEN u.FSecQty WHEN '10.13' THEN u.FSecQty ELSE 0.0000 END FSecQty,      
	FAuxQty,FConsignPrice,FConsignAmount,ISNULL(p.fprice,0.000) AS fCBprice      
	FROM AIS_YXSP2.dbo.ICStockBillEntry u      
	INNER JOIN AIS_YXSP2.dbo.ICStockBill v ON v.finterid=u.FInterID      
	INNER JOIN AIS_YXSP2.dbo.t_item w ON w.FItemID=u.FItemID  AND FItemClassID=4      
	LEFT JOIN AIS_YXSP2.dbo.t_Department t ON t.FItemID=v.FDeptID      
	LEFT JOIN yx_rs_ysprice p ON p.fnumber=w.fnumber AND p.fdate=v.fdate      
	LEFT JOIN AIS_YXSP2.dbo.t_Stock s ON s.FItemID=u.FDCStockID       
	WHERE v.FTranType=21 AND v.FCancellation=0      
	AND v.fdate BETWEEN  @BegDate1 AND @EndDate1      
	AND t.fnumber LIKE '%'+@fdepnumber1+'%'      
	AND t.fnumber>='10.12' AND  t.fnumber<='10.18'      
	AND t.fnumber<>'10.14'      
	AND  CHARINDEX('号',s.fname)=0   

INSERT INTO #rsjybmx (ztname,fdate, wnumber,dnumber,FSecQty,FAuxQty,FConsignPrice,FConsignAmount,fCBprice)      
SELECT 'S' AS ztname,v.fdate,w.fnumber AS wnumber ,t.FNumber AS dnumber,      
CASE t.fnumber WHEN '10.12' THEN u.FSecQty WHEN '10.13' THEN u.FSecQty ELSE 0.0000 END FSecQty,      
FAuxQty,FConsignPrice,FConsignAmount,ISNULL(p.fprice,0.000) AS fCBprice      
FROM AIS_YXSP2.dbo.ICStockBillEntry u      
INNER JOIN AIS_YXSP2.dbo.ICStockBill v ON v.finterid=u.FInterID      
INNER JOIN AIS_YXSP2.dbo.t_item w ON w.FItemID=u.FItemID  AND FItemClassID=4      
LEFT JOIN AIS_YXSP2.dbo.t_Department t ON t.FItemID=v.FDeptID      
LEFT JOIN yx_rs_ysprice p ON p.fnumber=w.fnumber AND p.fdate=v.fdate      
LEFT JOIN AIS_YXSP2.dbo.t_Stock s ON s.FItemID=u.FDCStockID       
WHERE v.FTranType=21 AND v.FCancellation=0      
AND v.fdate BETWEEN  @BegDate1 AND @EndDate1      
AND t.fnumber='10.20' 
AND  CHARINDEX('号',s.fname)=0    

INSERT INTO #rsjybmx (ztname,fdate, wnumber,dnumber,FSecQty,FAuxQty,FConsignPrice,FConsignAmount,fCBprice)      
SELECT 'S' AS ztname,v.fdate,w.fnumber AS wnumber ,t.FNumber AS dnumber,      
CASE t.fnumber WHEN '10.12' THEN u.FSecQty WHEN '10.13' THEN u.FSecQty ELSE 0.0000 END FSecQty,      
FAuxQty,FConsignPrice,FConsignAmount,ISNULL(p.fprice,0.000) AS fCBprice      
FROM AIS_YXSP2.dbo.ICStockBillEntry u      
INNER JOIN AIS_YXSP2.dbo.ICStockBill v ON v.finterid=u.FInterID      
INNER JOIN AIS_YXSP2.dbo.t_item w ON w.FItemID=u.FItemID  AND FItemClassID=4  AND w.FNumber NOT LIKE '8%'    
LEFT JOIN AIS_YXSP2.dbo.t_Department t ON t.FItemID=v.FDeptID      
LEFT JOIN yx_rs_ysprice p ON p.fnumber=w.fnumber AND p.fdate=v.fdate      
LEFT JOIN AIS_YXSP2.dbo.t_Stock s ON s.FItemID=u.FDCStockID       
WHERE v.FTranType=21 AND v.FCancellation=0      
AND v.fdate BETWEEN  @BegDate1 AND @EndDate1      
AND t.fnumber='10.21' 
AND  CHARINDEX('号',s.fname)=0    
   
   
ALTER TABLE #rsjybmx ADD FCBAmount FLOAT       
      
      
---分类计算收入成本      
--白条批发部、加盟开发部
UPDATE #rsjybmx       
   SET FConsignAmount=FConsignAmount,FCBAmount=ROUND(FAuxQty*fCBprice/0.91,2)   
WHERE ztname='R' AND dnumber IN ('10.12','10.13')      
--食品部门为 10.12 10.13的 收入直接计算     
UPDATE #rsjybmx       
   SET FConsignAmount=FConsignAmount,FCBAmount=ROUND(FAuxQty*fCBprice/0.91,2)      
WHERE ztname='S' AND dnumber IN ('10.12','10.13')      
--非白条批发部和加盟开发部门，收入和成本计算     
UPDATE #rsjybmx       
SET FConsignAmount=ROUND(FConsignAmount/1.09,2),FCBAmount=ROUND(FAuxQty*fCBprice,2)      
WHERE  dnumber NOT  IN ('10.12','10.13')    
    
SELECT  CONVERT(VARCHAR(100), a.fdate, 23) 日期 ,      
        a.dnumber 部门代码 ,      
        d.FName 部门名称 ,      
        CONVERT(numeric(10,2),ROUND(SUM(FSecQty), 2))  头数 ,      
        CONVERT(numeric(10,2),ROUND(SUM(FAuxQty), 2))  数量 ,      
        CONVERT(numeric(10,2),ROUND(SUM(FConsignAmount), 2))  收入 ,      
        CONVERT(numeric(10,2),ROUND(SUM(FCBAmount), 2))  成本       
INTO #rsjyb      
FROM    #rsjybmx a      
        LEFT JOIN  ais_yxry2.dbo.t_Department d ON d.fnumber = a.dnumber      
GROUP BY a.fdate ,      
        a.dnumber ,      
        d.FName      
ORDER BY a.fdate ,      
        a.dnumber      
       
UPDATE #rsjyb SET 收入=收入+ISNULL(t1.FAmountFor_2,0.00)+ISNULL(t2.FAmountFor_2,0.00)
FROM   #rsjyb a
LEFT  JOIN (--肉业
               SELECT   AIS_YXRY2.dbo.t_Department.FNumber AS 部门代码,
                CONVERT(VARCHAR(100), AIS_YXRY2.dbo.t_RP_ARPBill.FDate, 23) AS 日期,
                      ISNULL( SUM(ROUND(ISNULL(AIS_YXRY2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                 0),
                                          AIS_YXRY2.dbo.t_currency.FScale)),0.00) AS FAmountFor_2
                      FROM      AIS_YXRY2.dbo.t_RP_ARPBill
                                LEFT JOIN AIS_YXRY2.dbo.t_RP_Plan_Ar ON AIS_YXRY2.dbo.t_RP_ARPBill.FBillID = AIS_YXRY2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXRY2.dbo.t_RP_Plan_Ar.FIsInit = 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_currency ON AIS_YXRY2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXRY2.dbo.t_currency.FCurrencyID
                                                              AND AIS_YXRY2.dbo.t_currency.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Department ON AIS_YXRY2.dbo.t_RP_ARPBill.FDepartment = AIS_YXRY2.dbo.t_Department.FItemID
                                                              AND AIS_YXRY2.dbo.t_Department.FItemID <> 0
                      WHERE     ( DATEDIFF(DAY, @BegDate1,
                                           AIS_YXRY2.dbo.t_RP_ARPBill.FDate) >= 0
                                  AND DATEDIFF(DAY, @EndDate1,
                                               AIS_YXRY2.dbo.t_RP_ARPBill.FDate) <= 0
                                  AND AIS_YXRY2.dbo.t_Department.fnumber IN('10.12','10.13')
                                )
                                AND AIS_YXRY2.dbo.t_RP_ARPBill.FClassTypeID = 1000021  
                      GROUP BY AIS_YXRY2.dbo.t_Department.fnumber,
                      
                      CONVERT(VARCHAR(100), AIS_YXRY2.dbo.t_RP_ARPBill.FDate, 23)
            ) t1 ON t1.部门代码=a.部门代码 AND t1.日期 = a.日期
LEFT  JOIN (--食品
                 SELECT  AIS_YXSP2.dbo.t_Department.fnumber AS 部门代码, 
                    CONVERT(VARCHAR(100), AIS_YXSP2.dbo.t_RP_ARPBill.FDate, 23)  AS 日期,
                          ISNULL( SUM(ROUND(ISNULL(AIS_YXSP2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                 0),
                                          AIS_YXSP2.dbo.t_currency.FScale)),0.00) AS FAmountFor_2
                      FROM      AIS_YXSP2.dbo.t_RP_ARPBill
                                LEFT JOIN AIS_YXSP2.dbo.t_RP_Plan_Ar ON AIS_YXSP2.dbo.t_RP_ARPBill.FBillID = AIS_YXSP2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXSP2.dbo.t_RP_Plan_Ar.FIsInit = 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_currency ON AIS_YXSP2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXSP2.dbo.t_currency.FCurrencyID
                                                              AND AIS_YXSP2.dbo.t_currency.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_Department ON AIS_YXSP2.dbo.t_RP_ARPBill.FDepartment = AIS_YXSP2.dbo.t_Department.FItemID
                                                              AND AIS_YXSP2.dbo.t_Department.FItemID <> 0
                      WHERE     ( DATEDIFF(DAY, @BegDate1,
                                           AIS_YXSP2.dbo.t_RP_ARPBill.FDate) >= 0
                                  AND DATEDIFF(DAY, @EndDate1,
                                               AIS_YXSP2.dbo.t_RP_ARPBill.FDate) <= 0
                                  AND AIS_YXSP2.dbo.t_Department.fnumber IN('10.12','10.13')
                                )
                                AND AIS_YXSP2.dbo.t_RP_ARPBill.FClassTypeID = 1000021
                                GROUP BY AIS_YXSP2.dbo.t_Department.fnumber,
                                CONVERT(VARCHAR(100), AIS_YXSP2.dbo.t_RP_ARPBill.FDate, 23)


            ) t2 ON t2.部门代码=a.部门代码 AND t2.日期 = a.日期
WHERE a.部门代码 IN('10.12','10.13')
 
 
UPDATE #rsjyb SET 收入=收入+ISNULL(t1.FAmountFor_2/1.09,0.00)+ISNULL(t2.FAmountFor_2/1.09,0.00)
FROM #rsjyb a
LEFT  JOIN (--肉业
               SELECT   AIS_YXRY2.dbo.t_Department.FNumber AS 部门代码,
                CONVERT(VARCHAR(100), AIS_YXRY2.dbo.t_RP_ARPBill.FDate, 23) AS 日期,
                      ISNULL( SUM(ROUND(ISNULL(AIS_YXRY2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                 0),
                                          AIS_YXRY2.dbo.t_currency.FScale)),0.00) AS FAmountFor_2
                      FROM      AIS_YXRY2.dbo.t_RP_ARPBill
                                LEFT JOIN AIS_YXRY2.dbo.t_RP_Plan_Ar ON AIS_YXRY2.dbo.t_RP_ARPBill.FBillID = AIS_YXRY2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXRY2.dbo.t_RP_Plan_Ar.FIsInit = 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_currency ON AIS_YXRY2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXRY2.dbo.t_currency.FCurrencyID
                                                              AND AIS_YXRY2.dbo.t_currency.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXRY2.dbo.t_Department ON AIS_YXRY2.dbo.t_RP_ARPBill.FDepartment = AIS_YXRY2.dbo.t_Department.FItemID
                                                              AND AIS_YXRY2.dbo.t_Department.FItemID <> 0
                      WHERE     ( DATEDIFF(DAY, @BegDate1,
                                           AIS_YXRY2.dbo.t_RP_ARPBill.FDate) >= 0
                                  AND DATEDIFF(DAY, @EndDate1,
                                               AIS_YXRY2.dbo.t_RP_ARPBill.FDate) <= 0
                                  AND AIS_YXRY2.dbo.t_Department.fnumber IN('10.15','10.16','10.17','10.19','10.20','10.21')
                                )
                                AND AIS_YXRY2.dbo.t_RP_ARPBill.FClassTypeID = 1000021  
                      GROUP BY AIS_YXRY2.dbo.t_Department.fnumber,
                      
                      CONVERT(VARCHAR(100), AIS_YXRY2.dbo.t_RP_ARPBill.FDate, 23)
            ) t1 ON t1.部门代码=a.部门代码 AND t1.日期 = a.日期
LEFT  JOIN (--食品
                 SELECT  AIS_YXSP2.dbo.t_Department.fnumber AS 部门代码, 
                    CONVERT(VARCHAR(100), AIS_YXSP2.dbo.t_RP_ARPBill.FDate, 23)  AS 日期,
                          ISNULL( SUM(ROUND(ISNULL(AIS_YXSP2.dbo.t_RP_Plan_Ar.FAmountFor,
                                                 0),
                                          AIS_YXSP2.dbo.t_currency.FScale)),0.00) AS FAmountFor_2
                      FROM      AIS_YXSP2.dbo.t_RP_ARPBill
                                LEFT JOIN AIS_YXSP2.dbo.t_RP_Plan_Ar ON AIS_YXSP2.dbo.t_RP_ARPBill.FBillID = AIS_YXSP2.dbo.t_RP_Plan_Ar.FBillID
                                                              AND AIS_YXSP2.dbo.t_RP_Plan_Ar.FIsInit = 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_currency ON AIS_YXSP2.dbo.t_RP_ARPBill.FCurrencyID = AIS_YXSP2.dbo.t_currency.FCurrencyID
                                                              AND AIS_YXSP2.dbo.t_currency.FCurrencyID <> 0
                                LEFT  JOIN AIS_YXSP2.dbo.t_Department ON AIS_YXSP2.dbo.t_RP_ARPBill.FDepartment = AIS_YXSP2.dbo.t_Department.FItemID
                                                              AND AIS_YXSP2.dbo.t_Department.FItemID <> 0
                      WHERE     ( DATEDIFF(DAY, @BegDate1,
                                           AIS_YXSP2.dbo.t_RP_ARPBill.FDate) >= 0
                                  AND DATEDIFF(DAY, @EndDate1,
                                               AIS_YXSP2.dbo.t_RP_ARPBill.FDate) <= 0
                                  AND AIS_YXSP2.dbo.t_Department.fnumber IN('10.15')
                                )
                                AND AIS_YXSP2.dbo.t_RP_ARPBill.FClassTypeID = 1000021
                                GROUP BY AIS_YXSP2.dbo.t_Department.fnumber,
                                CONVERT(VARCHAR(100), AIS_YXSP2.dbo.t_RP_ARPBill.FDate, 23)


            ) t2 ON t2.部门代码=a.部门代码 AND t2.日期 = a.日期

 

 

ALTER TABLE  #rsjyb ADD 毛利 FLOAT  
ALTER TABLE  #rsjyb ADD 单头毛利 FLOAT 
UPDATE #rsjyb SET 毛利=CONVERT(numeric(10,2),收入-成本)    
UPDATE #rsjyb SET  单头毛利=CONVERT(numeric(10,2),ROUND(毛利/头数,2))      
WHERE 头数<>0             
              
              
-----部门10.11计算      
--猪      
INSERT INTO #rsjyb (日期,部门代码,部门名称,头数,数量,收入,成本,毛利,单头毛利)       
SELECT  CONVERT(VARCHAR(100), v.FSubRKDate, 23)  ,'10.11','门店管理部(猪)',0.00, 0.00,0.00,      
        ROUND( SUM( u.Fcommitqty* ISNULL(p.fprice, 0.00)/0.91),2) AS fcbamout,      
        0.00,null      
FROM    AIS_YXSP2.DBO.T_SubRKDEntry u      
        INNER JOIN AIS_YXSP2.DBO.T_SubRKD v ON v.FID = u.FID      
        INNER JOIN AIS_YXSP2.dbo.t_Item t ON t.FItemID = u.FSubRKDItemID  AND t.FItemClassID = 4  AND t.FNumber NOT LIKE '%7.1.03.%'     
        LEFT JOIN yx_rs_ysprice p ON p.fnumber = t.fnumber  AND p.fdate = v.FSubRKDate 
WHERE   FSubRKDate BETWEEN  @BegDate1 AND @EndDate1      
GROUP BY v.FSubRKDate  

--羊
INSERT INTO #rsjyb (日期,部门代码,部门名称,头数,数量,收入,成本,毛利,单头毛利)       
SELECT CONVERT(VARCHAR(100), v.FSubRKDate, 23)  ,'10.11','门店管理部(羊)',0.00, 0.00,0.00,      
        ROUND( SUM( u.Fcommitqty* ISNULL(p.fprice, 0.00)*1.11),2) AS fcbamout,      
        0.00,null      
FROM    AIS_YXSP2.DBO.T_SubRKDEntry u      
        INNER JOIN AIS_YXSP2.DBO.T_SubRKD v ON v.FID = u.FID      
        INNER JOIN AIS_YXSP2.dbo.t_Item t ON t.FItemID = u.FSubRKDItemID  AND t.FItemClassID = 4  AND t.FNumber  LIKE '%7.1.03.%'     
        LEFT JOIN yx_rs_ysprice p ON p.fnumber = t.fnumber  AND p.fdate = v.FSubRKDate 
WHERE   FSubRKDate BETWEEN  @BegDate1 AND @EndDate1      
GROUP BY v.FSubRKDate 
 

--计算10.11 头数 

UPDATE b SET  头数=gg.FSubAffQty FROM #rsjyb b 
INNER JOIN
 (
 SELECT fdate fdate, SUM(ISNULL(FSubAffQty, 0)) AS FSubAffQty                                        
                    FROM    AIS_YXSP2.DBO.t_subcustomsell
                    WHERE   fdate BETWEEN @BegDate1 AND @EndDate1 GROUP BY fdate 
  ) gg ON b.日期=gg.fdate
    WHERE 部门代码='10.11'  AND 部门名称='门店管理部(猪)'
    
UPDATE b SET  头数=gg.FSubAffQty FROM #rsjyb b 
INNER JOIN
 (
 SELECT fdate fdate, SUM(ISNULL(FDecimal2, 0)) AS FSubAffQty   --FDecimal2  羊头数                                    
                    FROM    AIS_YXSP2.DBO.t_subcustomsell
                    WHERE   fdate BETWEEN @BegDate1 AND @EndDate1 GROUP BY fdate 
  ) gg ON b.日期=gg.fdate
    WHERE 部门代码='10.11'  AND 部门名称='门店管理部(羊)'
  
      
--T_YX_SubInStockEntry  门店鲜肉结余表   FAmount      
      
--加上上一日的门店鲜肉结余表的金额 (猪)     
UPDATE #rsjyb SET 成本=成本+b.FAmount      
FROM #rsjyb a      
INNER JOIN (      
SELECT CONVERT(VARCHAR(100), DATEADD(DAY,1,v.FDate), 23) AS 日期,'10.11' AS 部门代码, '门店管理部(猪)'   部门名称,   
CONVERT(numeric(10,2),ROUND(SUM( u.FAmount),2)) AS FAmount      
FROM AIS_YXSP2.DBO.T_YX_SubInStockEntry u      
INNER JOIN AIS_YXSP2.DBO.T_YX_SubInStock v ON v.fid=u.fid 
INNER JOIN AIS_YXSP2.DBO.t_ICItem t ON t.FItemID = u.FItemId AND  t.FNumber NOT LIKE '%7.1.03.%'   -- 过滤山羊肉    
WHERE v.FDate BETWEEN DATEADD(DAY,-1,@BegDate1) AND DATEADD(DAY,-1,@EndDate1)      
GROUP BY CONVERT(VARCHAR(100), DATEADD(DAY,1,v.FDate), 23)      
)   b ON b.部门代码 = a.部门代码 AND b.日期 = a.日期  AND a.部门名称=b.部门名称    
WHERE a.部门代码='10.11' AND a.部门名称='门店管理部(猪)'    

--加上上一日的门店鲜肉结余表的金额 (羊)     
UPDATE #rsjyb SET 成本=成本+b.FAmount      
FROM #rsjyb a      
INNER JOIN (      
SELECT CONVERT(VARCHAR(100), DATEADD(DAY,1,v.FDate), 23) AS 日期,'10.11' AS 部门代码,  '门店管理部(羊)'   部门名称,    
CONVERT(numeric(10,2),ROUND(SUM( u.FAmount),2)) AS FAmount      
FROM AIS_YXSP2.DBO.T_YX_SubInStockEntry u      
INNER JOIN AIS_YXSP2.DBO.T_YX_SubInStock v ON v.fid=u.fid 
INNER JOIN AIS_YXSP2.DBO.t_ICItem t ON t.FItemID = u.FItemId AND  t.FNumber  LIKE '%7.1.03.%'   -- 过滤山羊肉    
WHERE v.FDate BETWEEN DATEADD(DAY,-1,@BegDate1) AND DATEADD(DAY,-1,@EndDate1)      
GROUP BY CONVERT(VARCHAR(100), DATEADD(DAY,1,v.FDate), 23)      
)   b ON b.部门代码 = a.部门代码 AND b.日期 = a.日期  AND a.部门名称=b.部门名称        
WHERE a.部门代码='10.11' AND a.部门名称='门店管理部(羊)' 

  
      
--减去本日门店鲜肉结余表的金额  (猪)    
UPDATE #rsjyb SET 成本=成本-b.FAmount      
FROM #rsjyb a      
INNER JOIN (      
SELECT CONVERT(VARCHAR(100), v.FDate, 23) AS 日期,'10.11' AS 部门代码,'门店管理部(猪)'   部门名称, 
CONVERT(numeric(10,2),ROUND(SUM( u.FAmount),2)) AS FAmount      
FROM AIS_YXSP2.DBO.T_YX_SubInStockEntry u      
INNER JOIN AIS_YXSP2.DBO.T_YX_SubInStock v ON v.fid=u.fid 
INNER JOIN AIS_YXSP2.DBO.t_ICItem t ON t.FItemID = u.FItemId AND  t.FNumber NOT  LIKE '%7.1.03.%'   -- 过滤山羊肉       
WHERE v.FDate BETWEEN @BegDate1 AND @EndDate1      
GROUP BY CONVERT(VARCHAR(100), v.FDate, 23))   b ON b.部门代码 = a.部门代码 AND b.日期 = a.日期  AND a.部门名称=b.部门名称     
WHERE a.部门代码='10.11'  AND a.部门名称='门店管理部(猪)'   

--减去本日门店鲜肉结余表的金额  (羊)    
UPDATE #rsjyb SET 成本=成本-b.FAmount      
FROM #rsjyb a      
INNER JOIN (      
SELECT CONVERT(VARCHAR(100), v.FDate, 23) AS 日期,'10.11' AS 部门代码,'门店管理部(羊)'   部门名称, 
CONVERT(numeric(10,2),ROUND(SUM( u.FAmount),2)) AS FAmount      
FROM AIS_YXSP2.DBO.T_YX_SubInStockEntry u      
INNER JOIN AIS_YXSP2.DBO.T_YX_SubInStock v ON v.fid=u.fid 
INNER JOIN AIS_YXSP2.DBO.t_ICItem t ON t.FItemID = u.FItemId AND  t.FNumber   LIKE '%7.1.03.%'   -- 过滤山羊肉       
WHERE v.FDate BETWEEN @BegDate1 AND @EndDate1      
GROUP BY CONVERT(VARCHAR(100), v.FDate, 23))   b ON b.部门代码 = a.部门代码 AND b.日期 = a.日期  AND a.部门名称=b.部门名称     
WHERE a.部门代码='10.11'  AND a.部门名称='门店管理部(羊)'  



--收入  增加肉业 czq  2017-08-15 

SELECT '10.11' 部门代码, 部门名称='门店管理部(猪)', v.fdate '日期' , 
SUM(FAuxQty)  数量, 
SUM(ISNULL(p.fprice,0.000) *FAuxQty)/0.91 成本,
SUM(FConsignAmount)FConsignAmount    INTO #abcd  
FROM AIS_YXRY2.dbo.ICStockBillEntry u      
INNER JOIN AIS_YXRY2.dbo.ICStockBill v ON v.finterid=u.FInterID      
INNER JOIN AIS_YXRY2.dbo.t_item w ON w.FItemID=u.FItemID  AND FItemClassID=4      
LEFT JOIN AIS_YXRY2.dbo.t_Department t ON t.FItemID=v.FDeptID      
LEFT JOIN yx_rs_ysprice p ON p.fnumber=w.fnumber AND p.fdate=v.fdate      
LEFT JOIN AIS_YXRY2.dbo.t_Stock s ON s.FItemID=u.FDCStockID       
WHERE v.FTranType=21 AND v.FCancellation=0      
AND v.fdate BETWEEN  @BegDate1 AND @EndDate1   
AND t.fnumber='10.11'  GROUP BY v.fdate 

UPDATE b SET 收入=ISNULL(b.收入,0)+ISNULL(FConsignAmount,0),
数量=ISNULL(b.数量,0)+ISNULL(d.数量,0),
成本=ISNULL(b.成本,0)+ISNULL(d.成本,0)   FROM #rsjyb b
INNER JOIN #abcd d ON b.部门代码=d.部门代码 AND b.部门名称=d.部门名称 AND b.日期=d.日期



  
 --猪     
UPDATE a SET 数量=a.数量+b.数量,收入=a.收入+b.收入, 毛利=a.收入+b.收入-成本      
FROM #rsjyb a      
INNER JOIN (      
SELECT CONVERT(VARCHAR(100), fdate, 23) AS 日期 ,'10.11' 部门代码,'门店管理部(猪)' 部门名称,        
      SUM(ISNULL(FSubSellSumQty, 0)) AS 数量,SUM(ISNULL(FSubRYAmount, 0)) AS 收入     --替换字段FSubRYAmount  
FROM    AIS_YXSP2.DBO.t_subcustomsell      
WHERE   fdate BETWEEN @BegDate1 AND @EndDate1      
GROUP BY fdate) b ON b.部门代码 = a.部门代码 AND b.日期 = a.日期  AND b.部门名称=a.部门名称   


--羊     
UPDATE #rsjyb SET 数量=b.数量,收入=b.收入, 毛利=b.收入-成本      
FROM #rsjyb a      
INNER JOIN (      
SELECT CONVERT(VARCHAR(100), fdate, 23) AS 日期 ,'10.11' 部门代码,'门店管理部(羊)' 部门名称,        
      SUM(ISNULL(fdecimal3, 0)) AS 数量,
      SUM(ISNULL(FSubJDJE, 0))   AS 收入     --替换字段FSubRYAmount  
FROM    AIS_YXSP2.DBO.t_subcustomsell      
WHERE   fdate BETWEEN @BegDate1 AND @EndDate1      
GROUP BY fdate) b ON b.部门代码 = a.部门代码 AND b.日期 = a.日期  AND b.部门名称=a.部门名称   




--门店数量与头数以这个为准
UPDATE #rsjyb SET  头数=b.CalNum  
FROM  #rsjyb a 
INNER JOIN(
select 
convert(varchar(100),a.deliverydate,23) as CalDate,SUM(b.quantity) as CalNum
from 
(SELECT deliverydate,DELIVERYCODE FROM CON12.YRTZDATA.dbo.TZ_XS_delivery2019 WHERE
(fhclientcode like 'R09.0004.%' OR fhclientname like 'S%') and storagename='白条库') a
,con12.YRTZDATA.dbo.TZ_XS_deliveryinfo2019 b
where a.deliverycode=b.deliverycode
and a.deliverydate between @BegDate and   @EndDate2

group by convert(varchar(100),a.deliverydate,23)
) b on a.日期=b.CalDate and a.部门代码='10.11'


UPDATE #rsjyb SET  数量=b.CalWeight  
FROM  #rsjyb a 
INNER JOIN(
select 
convert(varchar(100),a.deliverydate,23) as CalDate,SUM(b.weight) as CalWeight
from 
(SELECT deliverydate,DELIVERYCODE FROM CON12.YRTZDATA.dbo.TZ_XS_delivery2019 WHERE
(fhclientcode like 'R09.0004.%' )OR fhclientname like 'S%') a
,con12.YRTZDATA.dbo.TZ_XS_deliveryinfo2019 b
where a.deliverycode=b.deliverycode
and a.deliverydate between @BegDate and   @EndDate2
group by convert(varchar(100),a.deliverydate,23)
) b on a.日期=b.CalDate and a.部门代码='10.11'

--门店数量与头数以这个为准
  


UPDATE #rsjyb SET  单头毛利=CONVERT(numeric(10,2),ROUND(毛利/头数,2))      
 WHERE 部门代码='10.11' AND 部门名称='门店管理部(猪)'   AND   头数<>0   

UPDATE #rsjyb SET  单头毛利=CONVERT(numeric(10,2),ROUND(毛利/头数,2))      
 WHERE 部门代码='10.11' AND 部门名称='门店管理部(羊)'   AND   头数<>0   
  

 
 --添加字段
 ALTER TABLE  #rsjyb Add 当天屠宰头数 FLOAT NULL 
 ALTER TABLE  #rsjyb Add 当月屠宰头数 FLOAT NULL 
 
       
SELECT a.* FROM ( 
     
SELECT Q.日期,部门代码,部门名称,头数,数量,收入,成本,毛利,单头毛利,ISNULL(P.FDayHeadNum,0) AS 当天屠宰头数,P.FMonthHeadNum AS 当月屠宰头数  FROM #rsjyb Q --ORDER BY 日期,部门代码 
LEFT JOIN yx_rs_DayHeadNum P ON Q.日期=P.FDate    
WHERE 部门代码 LIKE '%'+@fdepnumber1+'%' 
     
UNION ALL 
     
SELECT       
 日期,      
'本日小计' AS 部门代码,'' AS 部门名称,      
SUM(头数) AS 头数,SUM(数量) AS 数量,SUM(收入) AS 收入,SUM( 成本) AS 成本,SUM( 毛利) AS 毛利,NULL AS 单头毛利,NULL AS 当天屠宰头数,NULL AS 当月屠宰头数      
FROM #rsjyb      
WHERE 部门代码 LIKE '%'+@fdepnumber1+'%'      
GROUP BY 日期      
      
UNION ALL  
     
SELECT       
'合计' AS 日期,      
'' AS 部门代码,'' AS 部门名称,      
SUM(头数) AS 头数,SUM(数量) AS 数量,SUM(收入) AS 收入,SUM( 成本) AS 成本,SUM( 毛利) AS 毛利,NULL AS 单头毛利,NULL AS 当天屠宰头数,NULL AS 当月屠宰头数      
FROM #rsjyb  WHERE 部门代码 LIKE '%'+@fdepnumber1+'%' ) a      
      
ORDER BY a.日期,a.部门代码    
      
      
      
DROP TABLE #rsjyb      
DROP TABLE #rsjybmx      
      
