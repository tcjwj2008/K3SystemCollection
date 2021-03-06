	Select 
	CONVERT(varchar(100),x.fdate,23) as 日期,
	t4.FName AS 购货单位,	
	z.FNumber AS 产品编码,
	'' as 送货司机,
    z.Fname AS 产品名称,
    z.Fmodel AS 规格型号,

    case when  len(z.Fmodel)-len(replace(z.Fmodel, '*', ''))>1  then 
   ( SUBSTRING(SUBSTRING(z.Fmodel, CHARINDEX('*', z.Fmodel) + 1,
   LEN(z.Fmodel) - LEN(SUBSTRING(z.Fmodel, 0, CHARINDEX('*', z.Fmodel)))),
0,
CHARINDEX('*',
SUBSTRING(z.Fmodel, CHARINDEX('*', z.Fmodel) + 1,
LEN(z.Fmodel) - LEN(SUBSTRING(z.Fmodel, 0,
CHARINDEX('*',
z.Fmodel)))))))
    else
    '0' 
    end as  装件数,

CONVERT(FLOAT,(case when  len(z.Fmodel)-len(replace(z.Fmodel, '*', ''))>1  then 
   ( SUBSTRING(SUBSTRING(z.Fmodel, CHARINDEX('*', z.Fmodel) + 1,
   LEN(z.Fmodel) - LEN(SUBSTRING(z.Fmodel, 0, CHARINDEX('*', z.Fmodel)))),
0,
CHARINDEX('*',
SUBSTRING(z.Fmodel, CHARINDEX('*', z.Fmodel) + 1,
LEN(z.Fmodel) - LEN(SUBSTRING(z.Fmodel, 0,
CHARINDEX('*',
z.Fmodel)))))))
    else
    '0' 
    end))*(CONVERT(FLOAT,

replace(  case when  (len(z.Fmodel)-len(replace(z.Fmodel, '*', ''))>1 and CHARINDEX('g',z.Fmodel)>0 )  then 
    SUBSTRING(Z.FMODEL,  
    CHARINDEX('*',z.Fmodel,CHARINDEX('*',z.Fmodel)+1)+1, CHARINDEX('g',z.Fmodel)-1)
    else
    '0' 
    end ,'g',''))) /1000  AS 装箱重量 ,
    	Case  
	when (CHARINDEX('同安',t4.FAddress)>0) then '同安'
	when (CHARINDEX('集美',t4.FAddress)>0) then '集美'
    when (CHARINDEX('思明',t4.FAddress)>0) then '思明'
	when (CHARINDEX('湖里',t4.FAddress)>0) then '湖里'
	when (CHARINDEX('海沧',t4.FAddress)>0) then '海沧'
	when (CHARINDEX('翔安',t4.FAddress)>0) then '翔安'		
	else ''
	END as 配送区域,
   CONVERT(decimal(18,2), y.FAuxQty) as 实发数量,
  convert (decimal(18,2), (case when (CONVERT(FLOAT,(case when  len(z.Fmodel)-len(replace(z.Fmodel, '*', ''))>1  then 
   ( SUBSTRING(SUBSTRING(z.Fmodel, CHARINDEX('*', z.Fmodel) + 1,
   LEN(z.Fmodel) - LEN(SUBSTRING(z.Fmodel, 0, CHARINDEX('*', z.Fmodel)))),
0,
CHARINDEX('*',
SUBSTRING(z.Fmodel, CHARINDEX('*', z.Fmodel) + 1,
LEN(z.Fmodel) - LEN(SUBSTRING(z.Fmodel, 0,
CHARINDEX('*',
z.Fmodel)))))))
    else
    '0' 
    end))<>0) then  (y.FAuxQty/CONVERT(FLOAT,(case when  len(z.Fmodel)-len(replace(z.Fmodel, '*', ''))>1  then 
   ( SUBSTRING(SUBSTRING(z.Fmodel, CHARINDEX('*', z.Fmodel) + 1,
   LEN(z.Fmodel) - LEN(SUBSTRING(z.Fmodel, 0, CHARINDEX('*', z.Fmodel)))),
0,
CHARINDEX('*',
SUBSTRING(z.Fmodel, CHARINDEX('*', z.Fmodel) + 1,
LEN(z.Fmodel) - LEN(SUBSTRING(z.Fmodel, 0,
CHARINDEX('*',
z.Fmodel)))))))
    else
    '0' 
    end))) else 0 end))  折合件数,
    t105.FName AS 部门,
    t4.FAddress as 地址 from 
	ICStockBill X
	INNER JOIN 
    ICStockBillEntry Y
    ON
    X.FInterID=Y.FInterID and y.FInterID<>0
    INNER JOIN t_icItem Z
    
    ON Y.FItemID=Z.FItemID  and y.FItemID <>0
     INNER JOIN t_Organization t4 ON     X.FSupplyID = t4.FItemID   AND t4.FItemID <>0 
     LEFT OUTER JOIN t_Department t105 ON     X.FDeptID = t105.FItemID   AND t105.FItemID <>0 
    WHERE X.FDate BETWEEN @BeginDate AND @EndDate and
     x.FTranType=21 
     and x.FBillNo='XOUT085245'
     order by x.FDate desc