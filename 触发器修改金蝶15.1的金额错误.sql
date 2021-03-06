USE [AIS_YXDZP2018]
GO
/****** Object:  Trigger [dbo].[GP_TRI_UPITEM]    Script Date: 08/02/2019 16:42:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  TRIGGER [dbo].[GP_TRI_UPITEM] ON [dbo].[SEOrderEntry] 
FOR INSERT, UPDATE
AS
 BEGIN
  DECLARE @InterID INT
  Set @InterID = 0
  Select @InterID = FInterID from Inserted
  
  
  --临时触发，系统BUG  
  Update seorderentry Set FAmount= ROUND(FAuxQty*FAuxTaxPrice/(100+FCESS)*100,2),FAllAmount= round(FAuxTaxPrice*fauxqty,2), FAllStdAmount= round(FAuxTaxPrice*fauxqty,2)
  Where finterid=@InterID    
  
  --Update seorderentry Set FAllAmount= round(FAuxTaxPrice*fauxqty,2), FAllStdAmount= round(FAuxTaxPrice*fauxqty,2)
  -- Where finterid=@InterID    
  
  
update b set b.fentryselfs0165=(CASE WHEN left(rtrim(ltrim(c.fname)),2)='公斤' THEN '公斤' ELSE left(rtrim(ltrim(c.fname)),1) END)
from  seorderentry as b 
inner join t_measureunit as c on b.funitid = c.fmeasureunitid where b.finterid = @InterID

update t1 set 
t1.fentryselfs0162 = isnull(t2.fname,'')+' '+isnull(t2.fmodel,''),
t1.fentryselfs0163 = t1.fauxqty + isnull(t1.fentryselfs0161,0), 
t1.FEntrySelfS0174=t2.fnumber+ REPLACE(CONVERT(VARCHAR(12),r.FDate,23),'-','')	--合格编码                                                                                                                                                                                                                                                           
from seorderentry as t1 
INNER JOIN seorder r ON r.FInterID=t1.FInterID
inner join t_icitem t2 on t1.fitemid = t2.fitemid where t1.finterid = @InterID
 
 
 
 END