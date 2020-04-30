USE [yinxiang];
GO
/****** Object:  StoredProcedure [dbo].[sp_k3_2APPORDER_QIU]    Script Date: 03/24/2020 11:21:32 ******/
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

--执行测试　[sp_k3_2APPORDER_QIU] 'qiu'
ALTER   PROC [dbo].[sp_k3_2APPORDER_QIU] @username VARCHAR(50)
AS
    BEGIN     
        BEGIN TRAN;
        
        --豆制品测试环境禁用APP同步触发器
        ALTER TABLE AIS_YXDZP2018.dbo.t_Organization DISABLE TRIGGER trgSyn_Organization;  --同步客户
        ALTER TABLE AIS_YXDZP2018.dbo.t_Item DISABLE TRIGGER trgSyn_T_ICITEM;  --同步物料
        ALTER TABLE AIS_YXDZP2018.dbo.ICPrcPlyEntry DISABLE TRIGGER trgSyn_Levelprice;  --同步客户价格
        ALTER TABLE AIS_YXDZP2018.dbo.SEOrderEntry DISABLE TRIGGER trg_UpAppShipNum;  --反写销售出库
          
        SELECT  IDENTITY( INT ,1,1 ) AS FID ,
                [opener] ,
                [ordertime] ,
                [remarks] ,
                [state] ,
                [isread] ,
                [storeid] ,
                [storeno] ,
                [amount] ,
                [orderno] ,
                [productno] ,
                [productno1] ,
                [num1] ,
                [price1] ,
                [amount1] ,
                [kind] ,
                [product] ,
                [spec] ,
                [cmoney] ,
                [cunit] ,
                [aigo] ,
                [remarks1]
        INTO    #inserttab1
        FROM    AIS_YXDZP2018.dbo.k3_2APPORDER
        WHERE   FNAME = @username;  


--修改临时表里的物料代码
        UPDATE  b
        SET     b.productno = CONVERT(VARCHAR(100), t.FItemID)
        FROM    #inserttab1 b
                INNER JOIN AIS_YXDZP2018.dbo.t_ICItem t ON b.productno1 = t.FNumber;


-- SELECT * from AIS_YXDZP2018.dbo.t_ICItem where fnumber='8.09.010'
--修改门店id
        UPDATE  t
        SET     t.storeid = g.FItemID
        FROM    #inserttab1 t
                INNER JOIN AIS_YXDZP2018.dbo.t_Organization g ON t.storeno = g.FNumber
                                                              AND g.FDeleted = 0;


--遍历导入表      
        DECLARE @mid INT;       
        DECLARE @WID INT;       
        SELECT  @mid = MAX(FID)
        FROM    #inserttab1;      
        SET @WID = 1; 
        DECLARE @mainID INT;     
        SET @mainID = 0;  
        DECLARE @orderid VARCHAR(50);     
        SET @orderid = '';   
        DECLARE @AMOUNTID INT;     
        SET @AMOUNTID = 0;      
        WHILE @WID <= @mid
            BEGIN      
	
	--插入主表

                SELECT  @orderid = orderno ,      --单据号
                        @AMOUNTID = SUM(amount1)  --单据总金额
                FROM    #inserttab1
                WHERE   FID = @WID
                GROUP BY orderno;
                IF NOT EXISTS ( SELECT  1
                                FROM    t_order
                                WHERE   FBillNO = @orderid )
                    BEGIN
                        INSERT  INTO t_order
                                ( opener ,
                                  ordertime                  ,
                                  remarks    ,
                                  state      ,
                                  isread ,
                                  storeid ,
                                  amount ,
                                  orderno ,
                                  FBillNO
                                )
                                SELECT  opener ,
                                        ordertime ,
                                        remarks ,
                                        state ,
                                        isread ,
                                        storeid ,
                                        @AMOUNTID , --金额是计算出来的
                                        orderno ,
                                        orderno
                                FROM    #inserttab1
                                WHERE   FID = @WID;
                    
                    END;
                SELECT  @mainID = id
                FROM    t_order
                WHERE   orderno = @orderid;
               
                       
--插入分录     

                INSERT  INTO t_orderdetail
                        ( mainid ,
                          productno ,
                          num ,
                          price ,
                          amount ,
                          kind ,
                          product ,
                          spec ,
                          cmoney ,
                          cunit ,
                          agio ,
                          remarks
                        )
                        SELECT  @mainID ,
                                productno ,
                                num1 AS num1 ,
                                CONVERT(DECIMAL(18, 2), price1) AS price1 ,
                                CONVERT(DECIMAL(18, 2), amount1) AS amount1 ,
                                kind ,
                                product ,
                                spec ,
                                cmoney AS cmoney ,
                                cunit ,
                                0 ,--CONVERT(DECIMAL(18,2),aigo) AS aigo ,
                                remarks
                        FROM    #inserttab1
                        WHERE   FID = @WID;        
 
       
                SET @WID = @WID + 1;      
            END;     
        ALTER TABLE AIS_YXDZP2018.dbo.t_Organization ENABLE TRIGGER trgSyn_Organization;  --同步客户
        ALTER TABLE AIS_YXDZP2018.dbo.t_Item ENABLE TRIGGER trgSyn_T_ICITEM;  --同步物料
        ALTER TABLE AIS_YXDZP2018.dbo.ICPrcPlyEntry ENABLE TRIGGER trgSyn_Levelprice;  --同步客户价格
        ALTER TABLE AIS_YXDZP2018.dbo.SEOrderEntry ENABLE TRIGGER trg_UpAppShipNum;  --反写销售出库       
       
        COMMIT;
    END;
    
    --select * from AIS_YXDZP2018.dbo.k3_2APPORDER