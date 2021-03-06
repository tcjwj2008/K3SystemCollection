USE [AIS_YXDZP2018]
GO
/****** Object:  Trigger [dbo].[GP_INERT_FDate]    Script Date: 09/11/2019 09:13:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER TRIGGER [dbo].[GP_INERT_FDate] ON [dbo].[SEOrder] 
FOR INSERT,update,DELETE
AS
 Begin
   DECLARE @FInterID INT
   SET @FInterID = 0
   Select @FInterID = FInterID From Inserted

  update seorder set fheadselfs0158=' ' ,FHeadSelfS0172=GETDATE() where FINTERID = @FINTERID
  update seorder 
  set fheadselfs0158=(case when fcancellation=1 then '作废' else ' ' end )
  where  fcancellation=1 and  FINTERID = @FINTERID
/******************************************************************************/
/******************************************************************************/
   update seorder set FHeadSelfs0154= 0 where FInterID = @FInterID
   UPDATE SEorder  SET FHeadSelfs0146 = dateadd(day,1,FDATE), FHeadSelfS0169=FDate, FHeadSelfs0170='2017-05-26 00:00:00.000',FHeadSelfs0171='2017-05-27 00:00:00.000' Where FInterID = @FInterID
   
   UPDATE SEorderEntry SET FAllStdAmount=FAllAmount Where FInterID = @FInterID --2017-04-27新增更新  更新价税合计(本位币)=价税合计
   
   
   update t1  set t1.fheadselfs0154=isnull(t2.fauxqty,0)+isnull(t2.fauxqty2,0)  from seorder as t1 
inner join (select finterid ,sum(fauxqty) as fauxqty,sum(fentryselfs0161) as fauxqty2 from seorderentry where finterid = 
@FInterID and funitid in ('124','125','126','1570','1755','10441','10263') group by finterid) as t2 on 
t1.finterid = t2.finterid   where  t1.finterid = @FInterID 
 End
/******************************************************************************
01.001	水豆腐	豆腐类_水豆腐	101	16块/板	124	板1
01.004	卤水老豆腐	豆腐类_卤水老豆腐	104	16块/板	125	板2
01.007	本地豆干	豆腐类_本地豆干	107	36块/板	126	板3
01.015	发菜豆腐	豆腐类_发菜豆腐	109	16块/板	125	板2
01.016	家常豆腐	豆腐类_家常豆腐	110	49块/板	1570	板4
06.007	仙草冻	其他类_仙草冻	213	16块/板	1755	板5
10264	8.01.075	盐卤老豆腐
10442	8.01.076	韧豆腐                      *
 ******************************************************************************/
------赠品品项统计 fentryselfs0161为赠品数量 fheadselfs0154为筐具数量
