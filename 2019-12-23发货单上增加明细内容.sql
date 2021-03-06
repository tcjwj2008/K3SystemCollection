USE [yrtzdata]
GO
/****** Object:  StoredProcedure [dbo].[xs_se_deliverydata_mx_qiu]    Script Date: 12/23/2019 11:21:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --[xs_se_deliverydata_mx_qiu] '11','2019-10-26','2019-10-30'                                    
ALTER procedure [dbo].[xs_se_deliverydata_mx_qiu]      
( @cid           varchar(50),                                    
  @starttime     datetime,                                   
  @endtime       datetime                                         
)                                     
as                                    
begin                                    
declare @TZ_XS_delivery varchar(50),                                                                                            
        @year varchar(10),                                             
        @sqlText varchar(max)  ,                                             
        @xsys    integer                                                                                                
declare @i integer     
set @endtime=DATEADD(D,1,@endtime)                                               
select @i=datediff(year,convert(datetime,@starttime),convert(datetime,@endtime))                                 
set @xsys=0        
select @xsys=convert(integer,yxz) from TZ_XT_sysset where CID=REPLACE(@cid,'''','') and Gnbh='4016' and ISNULL(Yxz,'')<>''     
                              
  
  select @year=convert(varchar,year(getdate()))                                          
  
  select @TZ_XS_delivery='TZ_XS_delivery'+@year                                             
  
  select @sqlText=''                                            
  
  select @sqlText='          
  
                 select convert(bit,0) isselect,c.instoragecode,b.CID,b.CNAME,a.ordercode,a.deliverycode,a.carcode,a.fhclientcode,a.fhclientname,a.logistictype,        
  
                       a.logisticname,                                  
  
                       a.logisticcode,a.clientcode,a.clientname,a.groupname,a.storagecode,a.storagename,a.deliverydate,a.allweight,                                 
  
                       a.stutus,a.checkoutcode,a.checkdate,a.checkperson,a.remark,a.receipt,a.receiptremark,                                  
  
                       a.dealremark,a.dealperson,a.dealtime,zz.productscode,c.productcode,c.productname,c.numbercode,c.levelcode,c.levelname,zz.producttime,zz.outstoragetime,zz.weight,        
  
                       zz.quantity,doublequantity,packweight,packquantity,allpackweight,c.packallweight,              
  
                       d.sortone,d.sorttwo,c.price,c.money,c.receiveweight,c.productname cproductname,      
  
                       c.levelname clevelname,a.delpername,c.saleunit,c.saletype                                                 
  
                   into #ls_data                                      
  
from '+@TZ_XS_delivery+' a inner join TZ_ZD_company b on 1=2 and a.cid=b.cid       
  
                   inner join TZ_XS_deliveryinfo'+@year+' zz on a.deliverycode=zz.deliverycode      
      inner join TZ_XS_deliverydata'+@year+' c on a.deliverycode=c.deliverycode      
   
                   inner join tz_zd_product d on c.productcode=d.productcode and c.levelcode=d.levelcode                                        
  
                   where 1=2  '                          
  
if @i>=0                                    
  
begin                                            
  
  declare @k int,              
  
          @yearnew varchar(20)                                            
  
  select @k=0                                            
  
while @k<=@i   --动态拼接sql语句                                            
  
  begin                                    
  
  select @year=convert(varchar,year(@starttime))                                            
  
   select @yearnew=convert(varchar(20),convert(int,@year)+@k)                                            
  
   select @TZ_XS_delivery='TZ_XS_delivery'+@yearnew                                            
  
    if exists(SELECT name FROM sys.objects WHERE name =@TZ_XS_delivery AND type in (N'U'))                                            
  
    begin                                    
  
      select @sqltext=@sqltext+'insert #ls_data(isselect,instoragecode,CID,CNAME,ordercode,deliverycode,carcode,fhclientcode,fhclientname,logistictype,logisticname,                                  
  
                       logisticcode,clientcode,clientname,groupname,storagecode,storagename,deliverydate,allweight,                                  
  
                       stutus,checkoutcode,checkdate,checkperson,remark,receipt,receiptremark,                                  
  
                       dealremark,dealperson,dealtime,productscode,productcode,productname,numbercode,levelcode,levelname,producttime,outstoragetime,weight,        
  
                       quantity,doublequantity,packweight,packquantity,allpackweight,packallweight,sortone,        
  
                       sorttwo,price,money,receiveweight,cproductname,clevelname,delpername,saleunit,saletype )                                  
  
      select 0,d.instoragecode,com.CID,com.shortname CNAME,ordercode,dis.deliverycode,dis.carcode,dis.fhclientcode,dis.fhclientname,dis.logistictype,dis.logisticname,                                  
  
                       dis.logisticcode,dis.clientcode,dis.clientname,dis.groupname,dis.storagecode,dis.storagename,dis.deliverydate,dis.allweight,                                  
  
                       dis.stutus,dis.checkoutcode,dis.checkdate,dis.checkperson,dis.remark,dis.receipt,dis.receiptremark,                                  
  
                       dis.dealremark,dis.dealperson,dis.dealtime,zz.productscode,b.productcode,b.productname,d.numbercode,b.levelcode,b.levelname, zz.producttime,zz.outstoragetime,       
  
                       zz.weight,zz.quantity,d.doublequantity,d.packweight,d.packquantity,d.allpackweight,d.packallweight,        
  
                       b.sortone,b.sorttwo,d.price,d.money,d.receiveweight,isnull(e.clientproductname,d.productname),      
  
                       isnull(e.clientlevelname,d.levelname),dis.delpername,d.saleunit,d.saletype                                   
  
       from '+@TZ_XS_delivery+' dis         
  
       inner join  TZ_ZD_company com on dis.cid=com.CID                    
       inner join TZ_XS_deliveryinfo'+@year+' zz on dis.deliverycode=zz.deliverycode  
       inner join TZ_XS_deliverydata'+@year+' d on dis.deliverycode=d.deliverycode                   
  
       inner join tz_zd_product b on d.productcode=b.productcode and d.levelcode=b.levelcode and b.isdelete=0      
  
       inner join tz_zd_pclient c on dis.cid=c.cid and dis.fhclientcode=c.clientcode     
  
        left join TZ_ZD_Pclientproduct e on dis.cid=e.cid and e.grouptype=0 and e.productgroupid=c.progroupcode and d.productcode=e.productcode and d.levelcode=e.levelcode                            
  
      where dis.stutus>=0                                  
  
        and dis.isdelete=0                                  
  
        and dis.cid in('+@cid+')                                  
  
        and dateadd(hour,-('+CONVERT(varchar(30),@xsys)+'),dis.deliverydate)>='''+convert(char,@starttime,23)+'''                                                  
  
        and dateadd(hour,-('+CONVERT(varchar(30),@xsys)+'),dis.deliverydate)<'''+convert(char,@endtime,23)+''' '                                           
  
    end                                   
  
    select @k=@k+1                                         
  
  end                                  
  
  select @sqltext=@sqltext+'                            

    select CONVERT(varchar(100), ( dateadd(hour,-('+CONVERT(varchar(30),@xsys)+'),deliverydate)), 23) as  ''发货日期'',fhclientname as ''发货客户名称'',b.mnemoniccode as ''发货客户代码'',productname as ''产品名称'',productscode as ''产品二维码'',productcode as ''产品编码'',  producttime  as ''生产时间'', outstoragetime as ''出库时间'',weight as  ''发货重量'', doublequantity''双计量数'', quantity as ''数量'',deliverydate as  ''实际发货日期'', storagename as ''仓库名称'',groupname as ''客户分组'',delpername as  ''发货人'', instoragecode''入库单号'' ,  deliverycode as ''发货单号'' ,fhclientcode as ''之前发货客户代码''                     
  
    from #ls_data left join TZ_ZD_client b on b.clientcode=fhclientcode
  
	   
    order by deliverydate,deliverycode                                             
  
    drop table #ls_data '                           
  
end                                   
--print @sqltext  
exec (@sqltext)                                             
  
end           