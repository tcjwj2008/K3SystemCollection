USE [yrtzdata]
GO
/****** Object:  StoredProcedure [dbo].[bb_se_offerdata_csp]    Script Date: 08/22/2019 14:33:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================                                                                                                                                  
-- Author:  <陈星宇>                                                                                                                                  
-- Create date: <2014-11-06,,>                                                                                                                                  
-- Description: <付款单查询,,>        
--caig jiesuan 2                                                                                                                                
-- =============================================                                            
ALTER procedure [dbo].[bb_se_offerdata_csp]      -- bb_se_offerdata_new3 '11','2018-08-23','2018-08-24'                                                   
(@cid                 varchar(50),                                                
 @startime            datetime,                                              
 @endtime             datetime                                              
)                                              
as                                                          
begin                                              
declare @TZ_CG_settle varchar(50),                          
        @TZ_CG_register varchar(50),                           
        @TZ_CG_registerdata varchar(50),                                                                                          
        @year varchar(10),                                              
        @sqlText varchar(max)                                               
if (@endtime<@startime)                                              
   return                        
declare @ls_data_settle2 table(                      
  cid        varchar(10),                      
  CNAME      varchar(50),                      
  RGID       varchar(50),                      
  clientcode varchar(20),                      
  clientname   varchar(50),                      
  settlecode   varchar(50),                      
  settletype      int,                      
  documenttype    int,                      
  redcode         varchar(50),                      
  isreplacesettle int,                      
  usercode     varchar(20),                      
  settleperson varchar(50),                      
  settledate   datetime,                      
  allmoney     numeric(16,4),                      
  stutus       int,                      
  isdelete     int,                    
  pricedate    datetime,                    
  fuweight     numeric(16,4),        
  judgemoney   numeric(16,4),        
  washcarmoney numeric(16,4),        
  paycode      varchar(50),         
  paymoney     numeric(16,4),      
  zcweight     numeric(16,4),      
  zcprice      numeric(16,4),      
  zcpaymoney   numeric(16,4),      
  zcremark     varchar(100),      
  avgweight    numeric(16,4),        
  quantity     numeric(16,4),        
  carcode      varchar(20),      
  jzquantity   numeric(16,4)        
  )                            
                                                   
declare @i integer      
                                              
declare @scys int       
select @scys=isnull(yxz,0) from TZ_XT_sysset where Gnbh='3012' and CID=REPLACE(@cid,'''','')      
                                            
select @endtime=DATEADD(DAY,1,@endtime)                
select @i=datediff(year,@startime,@endtime)                                         
  select @year=convert(varchar(4),year(getdate()))                                              
  select @TZ_CG_settle='TZ_CG_settle'+@year                                               
  select @sqlText=''                                              
 select com.CID,com.CNAME,settlecode,settletype,documenttype,redcode,isreplacesettle,                       
        usercode,settleperson,settledate,clientcode,clientname,allmoney,stutus,isdelete,      
        RGID,pricedate,fuweight,judgemoney,washcarmoney,        
        paycode,paymoney,zcweight,zcprice,zcpaymoney,zcremark,avgweight,quantity,carcode,jzquantity                       
   into #ls_data_settle2                        
   from @ls_data_settle2 dis, TZ_ZD_company com                      
  where 1=2                       
print 1                                            
if @i>=0                                            
begin                                              
  declare @k int,                                              
   @yearnew varchar(20)                                              
  select @k=0                                              
  while @k<=@i  --动态拼接sql语句                                              
  begin                                              
    select @year=substring(convert(char,@startime,112),1,4)                                      
    select @yearnew=convert(varchar(20),convert(int,@year)+@k)                                        
    select @TZ_CG_settle='TZ_CG_settle'+@yearnew                                              
    if exists(SELECT name FROM sys.objects WHERE name =@TZ_CG_settle AND type in (N'U'))                                              
    begin     
	 IF (@k=1) AND (MONTH(@endtime)=1) AND  (exists(SELECT name FROM sys.objects WHERE name ='tz_cg_register'+@year AND type in (N'U')) )
	 BEGIN
	 select @sqlText=@sqlText+'        
  insert #ls_data_settle2(CID,CNAME,settlecode,settletype,documenttype,redcode,isreplacesettle,                                  
         usercode,settleperson,settledate,clientcode,clientname,allmoney,stutus,isdelete,RGID,pricedate,fuweight,        
         judgemoney,washcarmoney,paycode,paymoney,zcweight,zcprice,zcpaymoney,zcremark,avgweight,quantity,carcode,      
         jzquantity)                                              
  select com.CID,com.shortname CNAME,che.settlecode,che.settletype,che.documenttype,che.redcode,che.isreplacesettle,                                  
         che.usercode,che.settleperson,che.settledate,che.clientcode,che.clientname,che.allmoney,che.stutus,che.isdelete,c.RGID,che.pricedate,                    
        (select isnull(sum(isnull(weight,0)),0) from TZ_CG_settlefudata'+@yearnew+' where settlecode=che.settlecode and price<>0) as fuweight,        
        d.alldeduction,dd.alldeduction,cc.paycode,cc.money,re.zcweight,re.zcprice,re.zcpaymoney,re.zcremark,      
        case when isnull(re.weight*re.quantity,0) =0 then 0 else round(re.weight/re.quantity,2) end  avgweight,      
        re.quantity,re.carcode,ddd.alldeduction                                                
   from '+@TZ_CG_settle+' che      
   inner join TZ_ZD_company com on che.CID=com.CID                                 
   inner join TZ_CG_settledata'+@yearnew+' c on che.settlecode=c.settlecode        
   inner join tz_cg_register'+@year+' re on c.rgid=re.rgid and che.cid=re.cid         
    left join TZ_CG_settlezdde'+@yearnew+' d on che.settlecode=d.settlecode and d.deductioncode=13          
    left join TZ_CG_settlezdde'+@yearnew+' dd on che.settlecode=dd.settlecode and dd.deductioncode in(14,15,16)       
    left join TZ_CG_settlezdde'+@yearnew+' ddd on che.settlecode=ddd.settlecode and ddd.deductioncode=17           
    left join (select cc.* from TZ_CW_paydata'+@yearnew+' cc             
    inner join TZ_CW_pay'+@yearnew+' ee on ee.paycode=cc.paycode and ee.stutus=1 and ee.isdelete=0) cc on che.settlecode=cc.settlecode                                            
  where che.CID in('+@cid+')                                                
    and re.offerdate>='''+convert(char,@startime-CONVERT(datetime,@scys/24.0,120),25)+'''                                             
    and re.offerdate<='''+convert(char,@endtime-CONVERT(datetime,@scys/24.0,120),25)+'''                                     
    and che.isdelete=0                         
    and che.stutus in (-2,0,1)'  
	 END
	                                          
  select @sqlText=@sqlText+'        
  insert #ls_data_settle2(CID,CNAME,settlecode,settletype,documenttype,redcode,isreplacesettle,                                  
         usercode,settleperson,settledate,clientcode,clientname,allmoney,stutus,isdelete,RGID,pricedate,fuweight,        
         judgemoney,washcarmoney,paycode,paymoney,zcweight,zcprice,zcpaymoney,zcremark,avgweight,quantity,carcode,      
         jzquantity)                                              
  select com.CID,com.shortname CNAME,che.settlecode,che.settletype,che.documenttype,che.redcode,che.isreplacesettle,                                  
         che.usercode,che.settleperson,che.settledate,che.clientcode,che.clientname,che.allmoney,che.stutus,che.isdelete,c.RGID,che.pricedate,                    
        (select isnull(sum(isnull(weight,0)),0) from TZ_CG_settlefudata'+@yearnew+' where settlecode=che.settlecode and price<>0) as fuweight,        
        d.alldeduction,dd.alldeduction,cc.paycode,cc.money,re.zcweight,re.zcprice,re.zcpaymoney,re.zcremark,      
        case when isnull(re.weight*re.quantity,0) =0 then 0 else round(re.weight/re.quantity,2) end  avgweight,      
        re.quantity,re.carcode,ddd.alldeduction                                                
   from '+@TZ_CG_settle+' che      
   inner join TZ_ZD_company com on che.CID=com.CID                                 
   inner join TZ_CG_settledata'+@yearnew+' c on che.settlecode=c.settlecode        
   inner join tz_cg_register'+@yearnew+' re on c.rgid=re.rgid and che.cid=re.cid         
    left join TZ_CG_settlezdde'+@yearnew+' d on che.settlecode=d.settlecode and d.deductioncode=13          
    left join TZ_CG_settlezdde'+@yearnew+' dd on che.settlecode=dd.settlecode and dd.deductioncode in(14,15,16)       
    left join TZ_CG_settlezdde'+@yearnew+' ddd on che.settlecode=ddd.settlecode and ddd.deductioncode=17           
    left join (select cc.* from TZ_CW_paydata'+@yearnew+' cc             
    inner join TZ_CW_pay'+@yearnew+' ee on ee.paycode=cc.paycode and ee.stutus=1 and ee.isdelete=0) cc on che.settlecode=cc.settlecode                                            
  where che.CID in('+@cid+')                                                
    and re.offerdate>='''+convert(char,@startime-CONVERT(datetime,@scys/24.0,120),25)+'''                                             
    and re.offerdate<='''+convert(char,@endtime-CONVERT(datetime,@scys/24.0,120),25)+'''                                     
    and che.isdelete=0                         
    and che.stutus in (-2,0,1)'                                          
    end                                              
    select @k=@k+1                                              
  end                                           
end                                
print @sqlText                 
exec(@sqlText)                        
                     
select @sqlText=''                         
if (select COUNT(RGID) from #ls_data_settle2)>0                        
begin                        
  declare @minstr varchar(20),@maxstr varchar(20),@minint int,@maxint int                        
  select top 1 @minstr=rgid  from #ls_data_settle2 order by rgid asc             
  select @minint=convert(int,dbo.sys_getYearFromCode(@minstr) )                        
  select top 1 @maxstr=rgid  from #ls_data_settle2 order by rgid desc                        
  select @maxint=convert(int,dbo.sys_getYearFromCode(@maxstr) )                        
  select @i=@maxint-@minint                            
  select @minstr=convert(varchar(20),@minint)                                                                                       
  select @TZ_CG_register='TZ_CG_register'+@minstr                           
  select @TZ_CG_registerdata='TZ_CG_registerdata'+@minstr                                                                     
  select @sqlText='            
   select a.cid,a.RGID,a.areacode,a.areaname,a.quantity,a.grossweight,a.weight,a.outrate,a.goodrate,            
          a.selectrate,a.pigprice,a.pigmoney,a.nomalmoney,a.levelmoney,a.ortherdeduction,            
          a.alldeduction,a.offerdate,settlemoney,realpigprice,convert(numeric(16,4),0) levelweight,            
          convert(numeric(16,4),0) headpitiweight,0 realquantity,a.oneeartag,a.fumoney,a.remark                                 
     into #ls_data                                               
     from '+@TZ_CG_register+' a, TZ_ZD_company com                              
    where 1=2                      
                 
   select rgid,cglevelcode,cglevelname,killstutus,killtime                                            
     into #ls_datamx                               
     from '+@TZ_CG_registerdata+' where 1=2  '                               
                            
  if @i>=0                                              
  begin                                              
   declare @j int,                                              
     @yearnew2 varchar(20),
	 @yearold2 VARCHAR(20)                                              
   select @j=0                                              
   while @j<=@i   --动态拼接sql语句                                              
  begin         
   select @yearold2=convert(varchar(20),@minint)                                                      
  select @yearnew2=convert(varchar(20),@minint+@j)                                              
  select @TZ_CG_register='TZ_CG_register'+@yearnew2                        
  select @TZ_CG_registerdata='TZ_CG_registerdata'+@yearnew2                                              
  if exists(SELECT name FROM sys.objects WHERE name =@TZ_CG_register AND type in (N'U'))                                              
  begin   
                                               
       select @sqlText=@sqlText+'             
       insert #ls_data(cid,RGID,areacode,areaname,quantity,grossweight,weight,outrate,goodrate,selectrate,pigprice,            
              pigmoney,nomalmoney,levelmoney,ortherdeduction,alldeduction,offerdate,settlemoney,realpigprice,            
              levelweight,headpitiweight,realquantity,oneeartag,fumoney,remark )                                                     
       select distinct a.cid,a.RGID,a.areacode,a.areaname,a.quantity,a.grossweight,a.weight,a.outrate,a.goodrate,            
              a.selectrate,a.pigprice,a.pigmoney,a.nomalmoney,a.levelmoney,a.ortherdeduction,a.alldeduction,a.offerdate,            
              a.settlemoney,a.realpigprice,c.levelweight,c.headpitiweight,c.realquantity,a.oneeartag,a.fumoney,a.remark                                                 
        from '+@TZ_CG_register+' a inner join TZ_ZD_company com on a.CID=com.CID                                 
       inner join (select rgid,count(rgid) realquantity,sum(levelweight) levelweight,sum(weight-levelweight) headpitiweight             
             from '+@TZ_CG_registerdata+' where killstutus<>3 and isdelete=0 group by rgid) c on a.RGID=c.RGID                            
       inner join #ls_data_settle2 d on a.CID=d.CID  and a.RGID=d.RGID and d.settletype=0                                             
       where a.CID in('+@cid+')                                                           
         and a.isdelete=0                 
                     
      insert #ls_datamx(rgid,cglevelcode,cglevelname,killstutus,killtime)                      
      select e.rgid,e.cglevelcode,e.cglevelname,killstutus,killtime                       
        from '+@TZ_CG_registerdata+' e                                            
       where e.isdelete=0 and e.killstutus<>3                          
         and e.rgid in (select a.rgid from '+@TZ_CG_register+' a                       
        inner join #ls_data_settle2 d on a.CID=d.CID  and a.RGID=d.RGID and d.settletype=0                      
         where a.CID in('+@cid+') and a.isdelete=0 )                       
                                        '                                       
  end                                              
  select @j=@j+1                                              
   end                                                
  end                              
                                      
end                      
else                      
begin                           
  select @year=substring(convert(char,getdate(),112),1,4)                                                                                  
  select @TZ_CG_register='TZ_CG_register'+@year                           
  select @TZ_CG_registerdata='TZ_CG_registerdata'+@year                     
  select @sqlText='            
   select a.cid,a.RGID,a.areacode,a.areaname,a.quantity,a.grossweight,a.weight,a.outrate,a.goodrate,a.selectrate,            
          a.pigprice,a.pigmoney,a.nomalmoney,a.levelmoney,a.ortherdeduction,a.alldeduction,a.offerdate,settlemoney,            
          realpigprice,convert(numeric(16,4),0) levelweight,convert(numeric(16,4),0) headpitiweight,0 realquantity,            
          a.oneeartag,a.fumoney,a.remark                                                 
    into #ls_data                                                 
    from '+@TZ_CG_register+' a, TZ_ZD_company com                                               
   where 1=2                       
                                                                 
   select rgid,cglevelcode,cglevelname,killstutus,killtime                                            
     into #ls_datamx                                                
     from '+@TZ_CG_registerdata+' where 1=2   '                                                           
end                       
                       
select @sqlText=@sqlText+'     
select * into #ls_cai from #ls_data_settle2 where rgid like ''%拆''   
delete  #ls_data_settle2 where rgid like ''%拆''  
update #ls_cai set rgid=SUBSTRING(rgid,1,charindex(''拆'',rgid)-1)
update a   
   set a.settlecode=rtrim(a.settlecode)+''\''+rtrim(b.settlecode),  
       a.allmoney=isnull(a.allmoney,0)+isnull(b.allmoney,0),  
       a.fuweight=isnull(a.fuweight,0)+isnull(b.fuweight,0),  
       a.judgemoney=isnull(a.judgemoney,0)+isnull(b.judgemoney,0),  
       a.washcarmoney=isnull(a.washcarmoney,0)+isnull(b.washcarmoney,0),  
       a.paymoney=isnull(a.paymoney,0)+isnull(b.paymoney,0),  
       a.zcweight=isnull(a.zcweight,0)+isnull(b.zcweight,0),  
       a.zcprice=round((isnull(a.zcprice,0)+isnull(b.zcprice,0))/2,2),  
       a.zcpaymoney=isnull(a.zcpaymoney,0)+isnull(b.zcpaymoney,0),  
       a.avgweight=round((isnull(a.avgweight,0)*isnull(a.quantity,0)+isnull(b.avgweight,0)*isnull(b.quantity,0))/(isnull(a.quantity,0)+isnull(b.quantity,0)),2),  
       a.quantity=isnull(a.quantity,0)+isnull(b.quantity,0),  
       a.jzquantity=isnull(a.jzquantity,0)+isnull(b.jzquantity,0)   
  from #ls_data_settle2 a  
 inner join #ls_cai b on a.rgid=b.rgid  
  
drop table #ls_cai   
  
 update #ls_data   
  set rgid=SUBSTRING(rgid,1,charindex(''拆'',rgid)-1)
  where rgid like ''%拆''  
  
select cid,RGID,areacode,areaname,sum(quantity) quantity,sum(grossweight) grossweight,sum(weight) weight,  
       case when sum(isnull(grossweight,0))=0 then 0 else round(sum(isnull(weight,0))/sum(isnull(grossweight,0))*100,2) end outrate,
       case when sum(isnull(goodrate,0))=0 then 0 else round(sum(isnull(outrate,0)*isnull(quantity,0))/sum(isnull(quantity,0)),2) end goodrate,
	   case when sum(isnull(selectrate,0))=0 then 0 else round(sum(isnull(outrate,0)*isnull(quantity,0))/sum(isnull(quantity,0)),2) end selectrate,
	   case when sum(isnull(pigprice,0))=0 then 0 else round(sum(isnull(pigprice,0)*isnull(grossweight,0))/sum(isnull(grossweight,0)),2) end pigprice,     
       sum(pigmoney) pigmoney,sum(nomalmoney) nomalmoney,sum(levelmoney) levelmoney,sum(ortherdeduction) ortherdeduction,  
       sum(alldeduction) alldeduction,min(offerdate) offerdate,sum(settlemoney) settlemoney,round(sum(settlemoney)/ sum(grossweight),2) realpigprice,            
       sum(levelweight) levelweight,sum(headpitiweight) headpitiweight,sum(realquantity) realquantity,oneeartag,sum(fumoney) fumoney,remark  
  into #ls_datanew  
  from #ls_data   
 group by cid,RGID,areacode,areaname,oneeartag,remark  
 
     
 update #ls_datamx  
    set rgid=SUBSTRING(rgid,1,charindex(''拆'',rgid)-1)
  where rgid like ''%拆''  
    
  
                     
       select distinct cglevelcode,cglevelname into #lscs from #ls_datamx where isnull(cglevelcode,'''')<>''''                     
       declare @sql varchar(max)                      
       declare @sql2 varchar(max)                      
       declare @sql3 varchar(1000)                      
       select @sql=''select rgid,''                      
       select @sql=@sql+''sum(case cglevelcode when ''''''+cglevelcode+'''''' then 1 else 0 end) as ''''''+cglevelname+'''''',round(100.0*sum(case cglevelcode when ''''''+cglevelcode+'''''' then 1 else 0 end)/count(*),2) as ''''''+cglevelname+''占比'''',''
  
  from #lscs        
      
        
          
                   
       select @sql=LEFT(@sql,LEN(@sql)-1)+'' from #ls_datamx group by rgid''                      
       select @sql3='',''                      
       select @sql3=@sql3+cglevelname+'',''+cglevelname+''占比,'' from #lscs order by cglevelname                       
       select @sql3=LEFT(@sql3,LEN(@sql3)-1)  '                      
  select @sqlText=@sqlText+'                       
       select @sql2=''                          
             select  a.CNAME,SUBSTRING(a.settlecode,1,18) settlecode ,a.documenttype,a.isreplacesettle,                                  
                     a.usercode,a.settleperson,a.settledate,SUBSTRING(a.clientcode,1,18) clientcode ,a.clientname,a.allmoney,a.stutus,SUBSTRING(a.RGID,7,18) RGID,a.pricedate,                        
                     b.quantity,b.grossweight,b.grossweight as grossweight1,b.weight,case right(CAST(CAST(b.outrate AS NUMERIC(10,2)) AS VARCHAR(10)),2) when ''''00'''' then CAST(CAST(b.outrate AS NUMERIC(10,0)) AS VARCHAR(10))+''''%'''' else CAST(CAST(b.outrate AS NUMERIC(10,2)) AS VARCHAR(10))+''''%'''' end AS outrate,b.nomalmoney,b.oneeartag,                        
                    b.ortherdeduction,b.alldeduction,b.ortherdeduction+b.alldeduction allde,b.realpigprice,b.levelweight,case when isnull(a.fuweight,0)<>0 then a.fuweight else b.headpitiweight end as headpitiweight,                        
                     convert(numeric(16,4),case b.grossweight when 0 then 0 else round(b.levelweight/b.grossweight*100,2) end) purrate,                      
                     convert(numeric(16,4),case b.weight when 0 then 0 else round(b.settlemoney/b.weight,2) end) dj,                      
                     convert(numeric(16,4), round(b.grossweight/b.quantity,2)) jz,b.realquantity''+@sql3+'',                      
                     a.CID,a.settletype,a.redcode,a.isdelete,b.goodrate,b.selectrate,100-b.goodrate-b.selectrate as 普级率,b.pigprice, CONVERT(VARCHAR(12),b.offerdate,23) offerdate,b.settlemoney,b.pigmoney,b.levelmoney,b.fumoney,                            
                     round((isnull(b.nomalmoney,0)+isnull(b.fumoney,0))/b.grossweight,2) as realpigprice2,b.areacode,b.areaname,b.remark,        
                     judgemoney,washcarmoney,paycode,paymoney,zcweight,zcprice,zcpaymoney,zcremark,avgweight,a.jzquantity,      
                     a.quantity as quantity1,a.carcode,d.quantity as xhquantity,dd.killtime,cle.clientname as pclientname,uu.username   
                                 
			 into #ls_date  
              from #ls_data_settle2 a         
             inner join tz_zd_pclient cl on a.clientcode=cl.clientcode and a.cid=cl.cid      
              left join tz_zd_client cle on cl.pclientcode=cle.clientcode         
              left join TZ_YH_user uu on cl.getusercode=uu.usercode                 
              left join #ls_datanew b on a.cid=b.cid and a.rgid=b.rgid       
              left join (select count(1) quantity,rgid from #ls_datamx where killstutus=3 group by rgid) d on a.rgid=d.rgid       
              left join (select convert(char,min(dateadd(hour,5,killtime)),23) killtime,rgid from #ls_datamx group by rgid) dd on a.rgid=dd.rgid                     
              left join (''+@sql+'') c on a.rgid=c.rgid                       
              order by a.cid,a.settlecode 
			  
			  select  convert(datetime, CONVERT(VARCHAR(10),pricedate) )as 日期,
SUM(quantity) AS 头数 ,SUM(grossweight) AS  结算净重,case when SUM(quantity)=0 then 0 else
SUM(grossweight)/SUM(quantity) end as 头均重量,case when SUM(quantity)=0 then 0 else
SUM(settlemoney)/SUM(quantity) end as 头均价格, case when SUM(grossweight)=0 then 0 else SUM(settlemoney)/SUM(grossweight) end  as 均价,SUM(settlemoney) AS 实际结算金额,
SUM(nomalmoney) AS 壳肉原始金额  


 from #ls_date  group by CONVERT(VARCHAR(10),pricedate)
			   drop table #ls_date
			  ''                      
       -- print @sql2                  
        exec(@sql2)                                                                                                                
    drop table #ls_data_settle2                         
    drop table #ls_data,#ls_datanew                      
    drop table #ls_datamx
	 '      
  print(@sqlText)                                             
 exec(@sqlText)                        
                                              
end                           
      
      
      
 --备份20190814 把验收净重改成均价
 --SUM(quantity) AS 头数 ,SUM(grossweight) AS  结算净重, SUM(grossweight1) AS 验收净重,SUM(settlemoney) AS 实际结算金额,
                       
