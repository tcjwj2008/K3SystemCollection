USE [test_yxry]
GO
/****** Object:  Trigger [dbo].[tr_updatestockid_qiu]    Script Date: 08/27/2019 10:17:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================

-- =============================================
ALTER TRIGGER [dbo].[tr_updatestockid_qiu]
   ON  [dbo].[ICStockBillEntry]
   FOR UPDATE,INSERT
AS 
BEGIN


     SET NOCOUNT ON;
        DECLARE @FInterID INT ,
            @FTranType INT ,
            @FSupplyID INT;
           -- @fitemno varchar(100);   --增加物料代码20190827
        SELECT  @FInterID = FInterID
        FROM    INSERTED; 
--看物料，查默认仓情况20190827

        IF EXISTS(
			SELECT 1 FROM 
			dbo.ICStockBillEntry ,t_icitem
			WHERE FInterID=@FInterID   AND  t_icitem.FItemID=dbo.ICStockBillEntry.FItemID 
			AND   t_icitem.FDefaultLoc=240 )
        BEGIN
            UPDATE dbo.ICStockBillEntry SET 
            FDCStockID=240 FROM 
			dbo.ICStockBillEntry ,t_icitem
			WHERE FInterID=@FInterID   AND  t_icitem.FItemID=dbo.ICStockBillEntry.FItemID 
			AND   t_icitem.FDefaultLoc=240          
        END
         

END
