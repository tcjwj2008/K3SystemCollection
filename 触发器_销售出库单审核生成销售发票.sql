USE [AIS20130723115744]
GO
/****** 对象:  Trigger [dbo].[ut_icstockbill_21to86]    脚本日期: 03/20/2014 13:58:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER trigger [dbo].[ut_icstockbill_21to86] on [dbo].[ICStockBill]
for update
as

set nocount on

select * into #deleted_21to86 from deleted where ftrantype=21 and fheadselfb0149=2214

if ((select top 1 fstatus from #deleted_21to86)=0 and (select top 1 fstatus from icstockbill where finterid = (select top 1 finterid from #deleted_21to86))=1)
begin

if exists (select 1 from icsale where ftrantype=86 and fbillno = (select fbillno from #deleted_21to86))
begin

raiserror ('存在重复的销售发票单据编号!请修改出库单号',18,18)
rollback
end

else
begin


declare @finterid86 int
exec geticmaxnum 'ICSale', @finterid86 output
select @finterid86

declare @finterid21 int
select @finterid21 = finterid from #deleted_21to86

declare @famount decimal(28,2)
select @famount = sum(fconsignamount) from icstockbillentry where finterid = @finterid21

declare @fcustid int
select @fcustid = fsupplyid from icstockbill where finterid = @finterid21


/*插入发票表体数据
insert into icsaleentry (finterid,fentryid)
select * from icsaleentry where finterid in(1191,1174,1201) and fentryid=1
*/
insert into icsaleentry (
finterid,fentryid,fsourcetrantype,fsourcebillno,fsourceinterid,fsourceentryid,forderbillno,forderinterid,forderentryid,
fitemid,fqty,fprice,famount,ftaxrate,ftaxamount,funitid,fauxprice,fauxqty,ftaxprice,fauxtaxprice,fnote,
fstdamount,famountincludetax,fstdamountincludetax,fbatchno,fclassid_src,fauxpropid,fpricediscount,
fauxpricediscount,fremainqty,fremainamount,fremainamountfor,fplanmode)

select @finterid86,a.fentryid,b.ftrantype,b.fbillno,a.finterid,a.fentryid,forderbillno,a.forderinterid,a.forderentryid,
a.fitemid,a.fqty,a.fconsignprice,a.fconsignamount,a.ftaxrate,0,a.funitid,a.fconsignprice,a.fqty,a.fconsignprice,a.fconsignprice,a.fnote,
a.fconsignamount,a.fconsignamount,a.fconsignamount,a.fbatchno,b.ftrantype,a.fauxpropid,a.fconsignprice,
a.fconsignprice,a.fqty,a.fconsignamount,a.fconsignamount,a.fplanmode
from icstockbillentry a 
inner join icstockbill b on a.finterid = b.finterid
where a.finterid = @finterid21


/*插入发票表头数据
insert into icsale (finterid,fbillno)
select * from icsale where finterid in(1191,1174,1201)
*/
insert into icsale (finterid,fbillno,ftrantype,fdate,fcustid,fnote,fcurrencyid,fdeptid,fempid,fvchinterid,fbillerid,fmanagerid,fsettleid,frob,
fexchangerate,fcompactno,fsalestyle,facctid,fyearperiod,fytdintrate,farapstatus,fyear,fperiod,ffincdate,fclasstypeid,fitemclassid,
fadjustexchangerate,fseltrantype,fbrid,fcussentacctid,fpoordbillno,fsettledate,fsysstatus,fheadselfi0546)

select @finterid86,fbillno,86,fdate,fsupplyid,fexplanation,1,fdeptid,fempid,0,fcheckerid,0,0,frob,
1,'',fsalestyle,0,'',0,0,year(fdate),month(fdate),fdate,1000000,1,1,ftrantype,0,fcussentacctid,'',fsettledate,2,fheadselfb0149
from icstockbill where finterid = @finterid21


/*插入往来表数据
select * from t_rp_contact where frp=1 and ftype=3 and finvoiceid in(1381,1384)
*/
insert into t_rp_contact (fyear,fperiod,frp,ftype,fdate,ffincdate,fnumber,fcustomer,fdepartment,femployee,fcurrencyid,fexchangerate,
famount,famountfor,fremainamount,fremainamountfor,finvoiceid,frpdate,fk3import,fbilltype,finvoicetype,fitemclassid,fexplanation,fpreparer)

select year(fdate),month(fdate),1,3,fdate,fdate,fbillno,fcustid,fdeptid,fempid,fcurrencyid,fexchangerate,
@famount,@famount,@famount,@famount,finterid,fdate,1,1,1,1,fexplanation,fbillerid
from icsale where finterid = @finterid86


/*插入付款计划数据
select * from t_rp_plan_ap where frp=1 and finterid in(1178,1179)
*/
insert into t_rp_plan_ar (forgid,fdate,famount,famountfor,fremainamount,fremainamountfor,finterid)
select fid,fdate,famount,famountfor,fremainamount,fremainamountfor,finvoiceid
from t_rp_contact where frp=1 and finvoiceid = @finterid86


/*更新出库单关联信息和开票数量*/
update icstockbill set frelateinvoiceid = @finterid86, fchildren = 1 where finterid = @finterid21
update icstockbillentry set fqtyinvoice = fqty,fauxqtyInvoice = fqty where finterid = @finterid21


/*销售信用额度控制相关
select fnumber,fname,fitemid from t_organization
select * from iccreditinstant where fitemid in(15027)
fcreditclass/信用对象类别(0-客户,1-业务员,2-部门,3客户类别,4-业务员类别)
fgroupid/信用单据组ID(来源于iccreditoption单据组ID)
fmainamtpara1(未审核金额)/fmainamtpara2(已审核金额)/fmainamtpara3(已执行金额)
fstatus/单据状态(销售发票:0-非现销,1-现销;销售出库:0-蓝单,1-红单)

if exists (select 1 from iccreditinstant where fgroupid=3 and fstatus=0 and fitemid = @fcustid)
begin

update iccreditinstant set fmainamtpara1 = fmainamtpara1 + @famount,fmainamtpara0 = @famount
where fgroupid=3 and fstatus=0 and fitemid = @fcustid
end

else
begin

insert into iccreditinstant (fcreditclass,fitemid,fgroupid,fstatus,fmainamtpara1,fmainamtpara2,fmainamtpara3,fmainamtpara0)
values (0,@fcustid,3,0,@famount,0,0,@famount)
end
*/

end
end

drop table #deleted_21to86