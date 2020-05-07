-- ================================================
-- 桥明追溯系统取实际含税单价，值为零作触发使用
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		qiu
-- Create date: <2019-05-29>
-- Description:	<更新实际含税单价>
-- =============================================
CREATE TRIGGER Tr_CheckTaxPrice ON SEOrder
    AFTER UPDATE
AS
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;
        DECLARE @FBillNo VARCHAR(255)
        DECLARE @VerifyStatus SMALLINT
        SET @Verifystatus = 0
        SELECT  @FBillNo = INSERTED.FBillNo ,
                @VerifyStatus = INSERTED.FStatus
        FROM    INSERTED
                INNER JOIN dbo.SEOrderentry see ON see.FInterID = INSERTED.finterID 
    
        IF UPDATE(FStatus) AND
             @VerifyStatus = 1
            BEGIN
                UPDATE  seorderentry
                SET     FAuxPriceDiscount = FAuxTaxPrice
                FROM    seorderentry
                        INNER JOIN INSERTED ON seorderentry.FAuxPriceDiscount = 0
                                                  AND seorderentry.FInterID = INSERTED.FInterID
                --RETURN
            END

    -- IF BILL NOT VERIFIED 

    END
GO
