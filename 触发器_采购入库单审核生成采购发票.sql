USE [AIS20130723115744]
GO
/****** 对象:  Trigger [dbo].[ut_icstockbill1to76]    脚本日期: 03/20/2014 13:57:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER trigger [dbo].[ut_icstockbill1to76] on [dbo].[ICStockBill]
for update
as

set nocount on

select * into #deleted1 from deleted where ftrantype=1

if ((select top 1 fstatus from #deleted1 )=0 and (select top 1 fstatus from icstockbill where finterid = (select top 1 finterid from #deleted1))=1)
begin

if exists (select 1 from icpurchase where ftrantype=76 and fbillno = (select fbillno from #deleted1))
begin

raiserror ('采购发票存在重复的单据编号!请更改本单编号',18,18)
rollback
end

else
begin

declare @N int
exec geticmaxnum 'ICPurchase', @N output
select @N

declare @finterid int
select @finterid = finterid from #deleted1

declare @famount decimal(28,2)
select @famount = sum(famount) from icstockbillentry where finterid = @finterid


--插入发票表体数据/select * from icpurchaseentry where finterid in(1178,1179)/select * from icstockbillentry
insert into icpurchaseentry (finterid,fentryid,fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,forderbillno,forderinterid,forderentryid,
fitemid,fqty,fprice,famount,ftaxrate,funitid,fauxprice,fauxqty,ftaxprice,fauxtaxprice,fnote,fstdamount,fbatchno,famountincludetax,fstdamountincludetax,
fclassid_src,fauxpropid,fpricediscount,fauxpricediscount,fremainqty,fremainamount,fremainamountfor,fplanmode)
select @N,a.fentryid,b.ftrantype,b.fbillno,a.finterid,a.fentryid,forderbillno,a.forderinterid,a.forderentryid,
a.fitemid,a.fqty,a.fprice,a.famount,a.ftaxrate,a.funitid,a.fprice,a.fqty,a.fprice,a.fprice,a.fnote,a.famount,a.fbatchno,a.famount,a.famount,
b.ftrantype,a.fauxpropid,a.fprice,a.fprice,a.fqty,a.famount,a.famount,a.fplanmode
from icstockbillentry a
inner join icstockbill b on a.finterid = b.finterid
where a.finterid = @finterid


--插入发票表头数据/select * from icpurchase where finterid in(1178,1180)/select * from icstockbill
insert into icpurchase (finterid,fbillno,ftrantype,fdate,fnote,fcurrencyid,fdeptid,fempid,fvchinterid,fbillername,fsupplyid,frob,fexchangerate,fcompactno,
fbillerid,fpostyle,fyearperiod,fytdintrate,ffincdate,fyear,fperiod,ftotalcost,ftotalcostfor,finvstyle,fclasstypeid,fitemclassid,fadjustexchangerate,fseltrantype,
fbrid,fcussentacctid,fpoordbillno,fsettledate,fsysstatus)
select @N,a.fbillno,76,a.fdate,a.fexplanation,1,a.fdeptid,a.fempid,0,'',a.fsupplyid,a.frob,1,'',
a.fcheckerid,a.fpostyle,'',0,a.fdate,year(a.fdate),month(a.fdate),@famount,@famount,12510,1000003,8,1,a.ftrantype,0,a.fcussentacctid,'',a.fdate,2
from icstockbill a where a.finterid = @finterid


--插入往来表数据/select * from t_rp_contact where finvoiceid in(1178,1179)
insert into t_rp_contact (fyear,fperiod,frp,ftype,fdate,ffincdate,fnumber,fcustomer,fdepartment,femployee,fcurrencyid,fexchangerate,
famount,famountfor,fremainamount,fremainamountfor,finvoiceid,frpdate,fk3import,fbilltype,finvoicetype,fitemclassid,fexplanation,fpreparer)
select year(a.fdate),month(a.fdate),0,4,a.fdate,a.fdate,a.fbillno,a.fsupplyid,a.fdeptid,a.fempid,a.fcurrencyid,a.fexchangerate,
@famount,@famount,@famount,@famount,a.finterid,a.fdate,1,1,2,a.fitemclassid,a.fnote,a.fbillerid
from icpurchase a where  a.finterid = @N


--插入付款计划数据/select * from t_rp_plan_ap where finterid in(1178,1179)
insert into t_rp_plan_ap (forgid,fdate,famount,famountFor,fremainamount,fremainamountfor,finterid)
select a.fid,a.fdate,a.famount,a.famountfor,a.fremainamount,a.fremainamountfor,a.finvoiceid
from t_rp_contact a where a.frp=0 and a.finvoiceid = @N


update icstockbill set frelateinvoiceid = @N, fchildren=1 where finterid = @finterid
update icstockbillentry set fqtyinvoice = fqty,fauxqtyinvoice = fqty where finterid = @finterid


end
end

drop table #deleted1
