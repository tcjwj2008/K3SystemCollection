USE ais_yxry2;
GO
/****** Object:  Trigger [dbo].[ICStockBillEntry_insert]    Script Date: 09/09/2019 14:41:16 ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
ALTER TRIGGER [dbo].[ICStockBillEntry_insert] ON [dbo].[ICStockBillEntry]
    FOR INSERT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @FInterID INT ,
            @FTranType INT ,
            @FSupplyID INT ,
            @fitemno INT;   --增加物料代码20190827qiu
        SELECT  @FInterID = FInterID ,
                @fitemno = FItemID
        FROM    INSERTED;   --增加物料代码20190827qiu

        SELECT  @FTranType = FTranType ,
                @FSupplyID = FSupplyID
        FROM    dbo.ICStockBill
        WHERE   FTranType = 21
                AND FInterID = @FInterID;

--处理公斤转换斤单位
        UPDATE  dbo.ICStockBillEntry
        SET     FEntrySelfB0179 = ISNULL(FAuxQty, 0) * 2
        WHERE   FInterID = @FInterID; 

--FEntrySelfB0180	单价（斤） 
        UPDATE  dbo.ICStockBillEntry
        SET     FEntrySelfB0180 = ISNULL(FConsignPrice, 0) / 2
        WHERE   FInterID = @FInterID;
        
        
--看物料，查默认仓情况20190827  

        IF EXISTS ( SELECT  1
                    FROM    dbo.ICStockBillEntry ,
                            t_ICItem
                    WHERE   FInterID = @FInterID
                            AND t_ICItem.FItemID = dbo.ICStockBillEntry.FItemID
                            AND t_ICItem.FDefaultLoc = 240 ) --AND t_icitem.FNumber IN('7.1.01.01.00686','7.1.01.01.00685'))
            BEGIN
                UPDATE  dbo.ICStockBillEntry
                SET     FDCStockID = 240 ,
                        FDCSPID = t_ICItem.FSPID
                FROM    dbo.ICStockBillEntry ,
                        t_ICItem
                WHERE   FInterID = @FInterID
                        AND t_ICItem.FItemID = dbo.ICStockBillEntry.FItemID
                        AND t_ICItem.FDefaultLoc = 240;  --  AND t_icitem.FNumber IN('7.1.01.01.00686','7.1.01.01.00685')        
            END;
         
       
         
         --临时表，读以折扣方案对应的折扣率
        SELECT  *
        INTO    #AA
        FROM    ( SELECT    t.FNumber 物料代码 ,
                            t.FName 物料名称 ,
                            g.FNumber 客户代码 ,
                            g.FName 客户名称 ,
                            t.FItemID 物料内码 ,
                            g.FItemID 客户内码 ,
                            e.FValue 折扣率
                  FROM      dbo.ICDisPlyEntry e
                            INNER JOIN dbo.t_ICItem t ON t.FItemID = e.FItemID
                            INNER JOIN dbo.t_Organization g ON g.FItemID = e.FRelatedID
                  WHERE     e.FInterID = 1
                            AND FChecked = 1
                            AND e.FCheckerID > 0--客户+物料                                                                                                                                                                                                                                                    
                  UNION ALL

--客户类别+物料
                  SELECT    t.FNumber 物料代码 ,
                            t.FName 物料名称 ,
                            g.FNumber 客户代码 ,
                            g.FName 客户名称 ,
                            t.FItemID 物料内码 ,
                            g.FItemID 客户内码 ,
                            e.FValue 折扣率
                  FROM      ICDisPlyEntry e
                            INNER JOIN dbo.t_ICItem t ON e.FItemID = t.FItemID
                            INNER JOIN dbo.t_SubMessage s ON s.FInterID = e.FRelatedID
                            INNER JOIN dbo.t_Organization g ON g.FTypeID = s.FInterID
                  WHERE     e.FInterID = 2
                            AND FChecked = 1
                            AND FCheckerID > 0  --客户类别+物料
                ) T;


        IF EXISTS ( SELECT  客户内码
                    FROM    #AA
                    WHERE   客户内码 = @FSupplyID )
            BEGIN  --处理折扣开始 
 
                UPDATE  e
                SET     FDiscountRate = 折扣率 ,
                        FDiscountAmount = 折扣率 * FConsignAmount / 100 ,
                        FConsignAmount = FConsignAmount - FConsignAmount * 折扣率
                        / 100 ,
                        FEntrySelfB0164 = FConsignAmount - FConsignAmount
                        * 折扣率 / 100
                FROM    ICStockBillEntry e
                        INNER JOIN #AA a ON e.FItemID = a.物料内码
                WHERE   a.客户内码 = @FSupplyID
                        AND e.FInterID = @FInterID
                        AND e.FItemID=@fitemno
 
                PRINT ( '折扣处理OK' );
 
            END; --处理折扣结束
 
 
 --处理 客户物料对应表 
        SELECT  FItemID ,
                FMapNumber ,
                FMapName
        INTO    #BB
        FROM    ICItemMapping
        WHERE   FID = 4
                AND FCompanyID = @FSupplyID;
        IF EXISTS ( SELECT  *
                    FROM    #BB )
            BEGIN 
 
                UPDATE  E
                SET     E.FMapName = a.FMapName ,
                        E.FMapNumber = a.FMapNumber
                FROM    ICStockBillEntry E
                        INNER JOIN #BB a ON E.FItemID = a.FItemID
                WHERE   E.FInterID = @FInterID;
 
                PRINT ( '物料对应表处理OK' );
 
            END;

    END;