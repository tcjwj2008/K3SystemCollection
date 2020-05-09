--��Ӧ�̹�ѡ�����ù�Ӧ��Эͬ�����������⹺���
ALTER PROCEDURE pro_HT_ICStockBill1Sync
AS 
    BEGIN
        SET nocount ON
        
--1.1��ȡ�û�ת���б�
        SELECT  t1.* ,
                t2.FUserID AS FOUserID ,
                t3.FUserID AS FNUserID
        INTO    #tmp01
        FROM    t_Item_3001 t1
                LEFT JOIN AIS20121023172833.dbo.t_user t2 ON t1.F_101 = t2.FName
                LEFT JOIN t_user t3 ON t1.F_102 = t3.FName
                LEFT JOIN t_item t4 ON t1.FItemID = t4.FItemID
        WHERE   t4.FDeleted = 0

--1.2��ȡת����Ӧ���б�
        SELECT  t1.* ,
                t2.FItemID AS FOItemID ,
                t3.FItemID AS FNItemID
        INTO    #tmp02
        FROM    t_item_3002 t1
                LEFT JOIN AIS20121023172833.dbo.t_Supplier t2 ON t1.F_103 = t2.FNumber
                LEFT JOIN t_Supplier t3 ON t1.F_101 = t3.FNumber
                LEFT JOIN t_item t4 ON t1.FItemID = t4.FItemID
        WHERE   t4.FDeleted = 0


--1.3��ȡ��ת����Ӧ���б�
        SELECT  t1.* ,
                t2.FItemID AS FOItemID
        INTO    #tmp03
        FROM    t_item_3003 t1
                LEFT JOIN AIS20121023172833.dbo.t_Supplier t2 ON t1.F_101 = t2.FNumber
                LEFT JOIN t_item t4 ON t1.FItemID = t4.FItemID
        WHERE   t4.FDeleted = 0

--1.4ת�������Ӧ��--1.4.1ת����Ӧ�̴����ų���ͬ����Ӧ�̣�
        SELECT  *
        INTO    #tmp04
        FROM    ( SELECT    t1.* ,
                            t2.FNItemID
                  FROM      AIS20121023172833.dbo.t_Supplier t1
                            INNER JOIN #tmp02 t2 ON t1.FItemID = t2.FOItemID
                  WHERE     ( 1 = 1 )
                            AND t1.FDeleted = 0
                            AND NOT EXISTS ( SELECT FOItemID
                                             FROM   #tmp03
                                             WHERE  FOItemID = t1.FItemID )
 
                                             
--1.4.2������Ӧ�̴����ų���ͬ����Ӧ��,�ų�ת����Ӧ�̣�
                  UNION ALL
                  SELECT    t1.* ,
                            t2.FItemID AS FNItemID
                  FROM      AIS20121023172833.dbo.t_Supplier t1
                            INNER JOIN t_Supplier t2 ON t1.FNumber = t2.FNumber
                  WHERE     ( 1 = 1 )
                            AND t1.FDeleted = 0
                            AND NOT EXISTS ( SELECT FOItemID
                                             FROM   #tmp03
                                             WHERE  FOItemID = t1.FItemID )
                            AND NOT EXISTS ( SELECT FOItemID
                                             FROM   #tmp02
                                             WHERE  FOItemID = t1.FItemID )
                ) s1


--1.5��ȡְԱ�б�
        SELECT  t1.* ,
                t2.FItemID AS FNItemID
        INTO    #tmp05
        FROM    AIS20121023172833.dbo.t_Emp t1
                LEFT JOIN t_Emp t2 ON t1.FNumber = t2.FNumber
        WHERE   t1.FDeleted = 0
        

--1.6��ȡ�����б�
        SELECT  t1.* ,
                t2.FItemID AS FNItemID
        INTO    #tmp06
        FROM    AIS20121023172833.dbo.t_Department t1
                LEFT JOIN t_Department t2 ON t1.FNumber = t2.FNumber
        WHERE   t1.FDeleted = 0
        

--1.7��ȡ�����б�
        SELECT  t1.* ,
                t2.FItemID AS FNItemID ,
                t2.FNumber AS FNNumber
        INTO    #tmp07
        FROM    AIS20121023172833.dbo.t_ICItem t1
                LEFT JOIN t_ICItem t2 ON t1.FNumber = t2.FNumber
        WHERE   t1.FDeleted = 0


--1.8��ȡ������λ�б�
        SELECT  t1.* ,
                t2.FItemID AS FNItemID
        INTO    #tmp08
        FROM    AIS20121023172833.dbo.t_MeasureUnit t1
                LEFT JOIN t_MeasureUnit t2 ON t1.FNumber = t2.FNumber
        WHERE   t1.FDeleted = 0

--1.11��ȡ�ֿ�ͬ���б�
        SELECT  t1.F_103 AS ���ϴ�������ĸ ,
                t1.F_104 AS ͬ�����²ֿ���� ,
                t1.F_101 AS ͬ�����²ֿ����� ,
                t3.FItemID AS �²ֿ�����
        INTO    #tmp11
        FROM    t_item_3004 t1
                LEFT JOIN t_Stock t3 ON t1.f_104 = t3.FNumber
                LEFT JOIN t_item t4 ON t1.FItemID = t4.FItemID
        WHERE   t4.FDeleted = 0

--1.10��ȡ�������⹺��ⵥ�������������ε���
        SELECT  *
        INTO    #tmp10
        FROM    (
        
--1.10.1���ε����ǲɹ�����
                  SELECT    t1.* ,
                            t3.FInterID AS FNSourceInterID ,
                            t1.FSourceEntryID AS FNSourceEntryID ,
                            t3.FInterID AS FNOrderInterID
                  FROM      AIS20121023172833.dbo.ICStockbillEntry t1
                            LEFT JOIN AIS20121023172833.dbo.ICStockbill t2 ON t1.FInterID = t2.FInterID
                            INNER JOIN POOrder t3 ON t1.FSourceBillNo = t3.FBillNo
                  WHERE     t2.FTranType = 1
                            AND t1.FSourceTranType = 71
                  UNION ALL
                  
--1.10.2���ε���������֪ͨ��
                  SELECT    t1.* ,
                            t3.FInterID AS FNSourceInterID ,
                            t1.FSourceEntryID AS FNSourceEntryID ,
                            t4.FInterID AS FNOrderInterID
                  FROM      AIS20121023172833.dbo.ICStockbillEntry t1
                            LEFT JOIN AIS20121023172833.dbo.ICStockbill t2 ON t1.FInterID = t2.FInterID
                            INNER JOIN POInStock t3 ON t1.FSourceBillNo = t3.FBillNo
                            LEFT JOIN POOrder t4 ON t1.FOrderBillNo = t4.FBillNo
                  WHERE     t2.FTranType = 1
                            AND t1.FSourceTranType = 72
                ) s

--2.0��ȡ��Ҫͬ�������Ĳɹ����
--2.00��ȡ����ͬ��������
--ֻͬ����������ĸ1��2��A��B��C��D��ͷ��
--���һ��������������ϸ�����϶��ǲ���ͬ�����������ᱻ�ų���
        SELECT  *
        INTO    #tmp200
        FROM    AIS20121023172833.dbo.t_ICItem t1
        WHERE   EXISTS ( SELECT *
                         FROM   #tmp11
                         WHERE  ���ϴ�������ĸ = LEFT(t1.FNumber, 1) )

--2.01��ȡ����ͬ���Ĳɹ����
        SELECT  t1.*
        INTO    #tmp201
        FROM    AIS20121023172833.dbo.ICStockBillEntry t1
                LEFT JOIN AIS20121023172833.dbo.ICStockBill t2 ON t1.FInterID = t2.FInterID
        WHERE   ( 1 = 1 )
                AND t2.FTranType = 1
                AND t2.FDate >= '2018-01-01'
                AND t2.FCancellation = 0
                AND t2.FStatus > 0
                AND EXISTS ( SELECT *
                             FROM   #tmp200
                             WHERE  FItemID = t1.FItemID )
                AND NOT EXISTS ( SELECT *
                                 FROM   t_HT_SyncControl
                                 WHERE  FOID = t1.FInterID
                                        AND FType = '�ɹ����' )

--2.02��ȡ����ͬ���ɹ�����FInterID
        SELECT  FInterID
        INTO    #tmp202
        FROM    #tmp201
        GROUP BY FInterID

--���ﻹ�ٿ���һ��������ͬ�������������⹺��ⵥ����Ϊ�����ˡ���ʱ�ٰ����ε���ͬ������������⡣

--2.��ȡ�ɹ��������׵���ͷ����(��˺�����)
        SELECT  t1.* ,
                t3.FNUserID AS FNBillerID ,
                t4.FNUserID AS FNCheckerID ,
                t2.FNItemID AS FNSupplyID ,
                t5.FNItemID AS FNEmpID ,
                ISNULL(t6.FNItemID, 0) AS FNManagerID ,
                ISNULL(t7.FNItemID, 0) AS FNDeptID ,
                t8.FItemID AS FNFManagerID ,
                t9.FItemID AS FNSManagerID
        INTO    #tmp1
        FROM    AIS20121023172833.dbo.ICStockbill t1
                INNER JOIN #tmp04 t2 ON t1.FSupplyID = t2.FItemID
                LEFT JOIN #tmp01 t3 ON t1.FBillerID = t3.FOUserID
                LEFT JOIN #tmp01 t4 ON t1.FCheckerID = t4.FOUserID
                LEFT JOIN #tmp05 t5 ON t1.FEmpID = t5.FItemID
                LEFT JOIN #tmp05 t6 ON t1.FManagerID = t6.FItemID
                LEFT JOIN #tmp06 t7 ON t1.FDeptID = t7.FItemID
                LEFT JOIN #tmp05 t8 ON t1.FFManagerID = t8.FItemID
                LEFT JOIN #tmp05 t9 ON t1.FSManagerID = t9.FItemID
        WHERE   ( 1 = 1 )
                AND t1.FTrantype = 1
                AND t1.FDate >= '2018-01-01'
                AND t1.FCancellation = 0
                AND t1.FStatus > 0
                AND NOT EXISTS ( SELECT *
                                 FROM   t_HT_SyncControl
                                 WHERE  FOID = t1.FInterID
                                        AND FType = '�ɹ����' )
                AND EXISTS --�����������ε���
( SELECT    *
  FROM      #tmp10
  WHERE     FInterID = t1.FInterID )
                AND EXISTS --����ͬ���Ĳɹ���ⵥ���룬���ų�����ͬ��������
( SELECT    *
  FROM      #tmp202
  WHERE     FInterID = t1.FInterID )

--3.��ȡ�ɹ�����б�д��������
        DECLARE @FNInterID BIGINT
        DECLARE @FNSourceInterId BIGINT
        DECLARE @FInterID BIGINT
        DECLARE @FBillNo VARCHAR(50)
        DECLARE @FBrNo VARCHAR(10)  --��˾��������                                                                                                                                                                                                                                                         
        DECLARE @FTranType BIGINT --��������                                                                                                                                                                                                                                                           
        DECLARE @FCancellation BIGINT --����
        DECLARE @FStatus BIGINT  --����״̬0-δ���,1-�����                                                                                                                                                                                                                                                    
        DECLARE @FUpStockWhenSave BIGINT --���¿��    0-���ʱ,1-����ʱ���¿��                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
        DECLARE @FROB BIGINT --������  1-����,-1-����                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
        DECLARE @FHookStatus BIGINT --������־                                                                                                                                                                                                                                                           
        DECLARE @Fdate DATETIME 
        DECLARE @FSupplyID BIGINT --��Ӧ������                                                                                                                                                                                                                                                          
        DECLARE @FCheckDate DATETIME --�������
        DECLARE @FFManagerID BIGINT --������                                                                                                                                                                                                                                                            
        DECLARE @FSManagerID BIGINT --������                                                                                                                                                                                                                                                            
        DECLARE @FBillerID BIGINT --�Ƶ���
        DECLARE @FPOStyle BIGINT --�ɹ���ʽ                                                                                                                                                                                                                                                           
        DECLARE @FMultiCheckDate1 DATETIME 
        DECLARE @FMultiCheckDate2 DATETIME 
        DECLARE @FMultiCheckDate3 DATETIME 
        DECLARE @FMultiCheckDate4 DATETIME
        DECLARE @FMultiCheckDate5 DATETIME
        DECLARE @FMultiCheckDate6 DATETIME 
        DECLARE @FRelateBrID BIGINT --��֧��������                                                                                                                                                                                                                                                         
        DECLARE @FPOOrdBillNo VARCHAR(100) --�Է����ݺ�                                                                                                                                                                                                                                                          
        DECLARE @FOrgBillInterID BIGINT --Դ������                                                                                                                                                                                                                                                           
        DECLARE @FSelTranType BIGINT --Դ������                                                                                                                                                                                                                                                           
        DECLARE @FBrID BIGINT --�Ƶ�����                                                                                                                                                                                                                                                           
        DECLARE @FExplanation VARCHAR(500) --ժҪ                                                                                                                                                                                                                                                             
        DECLARE @FDeptID BIGINT --����
        DECLARE @FManagerID BIGINT --����
        DECLARE @FEmpID BIGINT --ҵ��Ա
        DECLARE @FCussentAcctID BIGINT
        DECLARE @FManageType BIGINT --��˰�������                                                                                                                                                                                                                                                         
        DECLARE @FPOMode BIGINT --�ɹ�ģʽ                                                                                                                                                                                                                                                           
        DECLARE @FSettleDate DATETIME --�ո�������                                                                                                                                                                                                                                                          
        DECLARE @FPrintCount BIGINT --��ӡ����
        DECLARE @FPayCondition VARCHAR(100) --�տ�����                                                                                                                                                                                                                                                           
        DECLARE @FEnterpriseID BIGINT 
        DECLARE @FSendStatus BIGINT 
        DECLARE @FISUpLoad BIGINT 
        DECLARE @FCheckerID BIGINT --�����

        DECLARE mycursor CURSOR
        FOR
            SELECT  FInterID ,
                    FBillNo ,
                    FBrNo ,
                    FTranType ,
                    FCancellation ,
                    FStatus ,
                    FUpStockWhenSave ,
                    FROB ,
                    FHookStatus ,
                    Fdate ,
                    FNSupplyID ,
                    FCheckDate ,
                    FNFManagerID ,
                    FNSManagerID ,
                    FNBillerID ,
                    FPOStyle ,
                    FMultiCheckDate1 ,
                    FMultiCheckDate2 ,
                    FMultiCheckDate3 ,
                    FMultiCheckDate4 ,
                    FMultiCheckDate5 ,
                    FMultiCheckDate6 ,
                    FRelateBrID ,
                    FPOOrdBillNo ,
                    FOrgBillInterID ,
                    FSelTranType ,
                    FBrID ,
                    FExplanation ,
                    FNDeptID ,
                    FNManagerID ,
                    FNEmpID ,
                    FCussentAcctID ,
                    FManageType ,
                    FPOMode ,
                    FSettleDate ,
                    FPrintCount ,
                    FPayCondition ,
                    FEnterpriseID ,
                    FSendStatus ,
                    FISUpLoad ,
                    FNCheckerID
            FROM    #tmp1 
        OPEN mycursor 
        FETCH NEXT FROM mycursor INTO @FInterID, @FBillNo, @FBrNo, @FTranType,
            @FCancellation, @FStatus, @FUpStockWhenSave, @FROB, @FHookStatus,
            @Fdate, @FSupplyID, @FCheckDate, @FFManagerID, @FSManagerID,
            @FBillerID, @FPOStyle, @FMultiCheckDate1, @FMultiCheckDate2,
            @FMultiCheckDate3, @FMultiCheckDate4, @FMultiCheckDate5,
            @FMultiCheckDate6, @FRelateBrID, @FPOOrdBillNo, @FOrgBillInterID,
            @FSelTranType, @FBrID, @FExplanation, @FDeptID, @FManagerID,
            @FEmpID, @FCussentAcctID, @FManageType, @FPOMode, @FSettleDate,
            @FPrintCount, @FPayCondition, @FEnterpriseID, @FSendStatus,
            @FISUpLoad, @FCheckerID
        WHILE ( @@fetch_status = 0 ) 
            BEGIN 
--����������ICStockBill������FInterID
                SET @FNInterID = 0
                EXEC GetICMaxNum 'ICStockBill', @FNInterID OUTPUT, 1, 16394

--д���¼��
                INSERT  INTO ICStockBillEntry
                        ( FInterID ,
                          FEntryID ,
                          FBrNo ,
                          FMapNumber ,
                          FMapName ,
                          FItemID ,
                          FAuxPropID ,
                          FBatchNo ,
                          FQtyMust ,
                          FQty ,
                          FUnitID ,
                          FAuxQtyMust ,
                          Fauxqty ,
                          FSecCoefficient ,
                          FSecQty ,
                          FAuxPlanPrice ,
                          FPurchasePrice ,
                          FPlanAmount ,
                          Fauxprice ,
                          FDiscountRate ,
                          FDiscountAmount ,
                          Famount ,
                          Fnote ,
                          FPurchaseAmount ,
                          FKFDate ,
                          FKFPeriod ,
                          FPeriodDate ,
                          FDCStockID ,
                          FDCSPID ,
                          FOrgBillEntryID ,
                          FSNListID ,
                          FSourceBillNo ,
                          FSourceTranType ,
                          FSourceInterId ,
                          FSourceEntryID ,
                          FContractBillNo ,
                          FContractInterID ,
                          FContractEntryID ,
                          FOrderBillNo ,
                          FOrderInterID ,
                          FOrderEntryID ,
                          FAllHookQTY ,
                          FAllHookAmount ,
                          FCurrentHookQTY ,
                          FCurrentHookAmount ,
                          FPlanMode ,
                          FMTONo ,
                          FChkPassItem ,
                          FDeliveryNoticeFID ,
                          FDeliveryNoticeEntryID ,
                          FCheckAmount ,
                          FOutSourceInterID ,
                          FOutSourceEntryID ,
                          FOutSourceTranType
                        )
                        SELECT  @FNInterID ,
                                t1.FEntryID ,
                                t1.FBrNo ,
                                t1.FMapNumber ,
                                t1.FMapName ,
                                t2.FNItemID ,
                                t1.FAuxPropID ,
                                t1.FBatchNo ,
                                t1.FQtyMust ,
                                t1.FQty ,
                                t3.FNItemID ,
                                t1.FAuxQtyMust ,
                                t1.Fauxqty ,
                                t1.FSecCoefficient ,
                                t1.FSecQty ,
                                t1.FAuxPlanPrice ,
                                t1.FPurchasePrice ,
                                t1.FPlanAmount ,
                                t1.Fauxprice ,
                                t1.FDiscountRate ,
                                t1.FDiscountAmount ,
                                t1.Famount ,
                                t1.Fnote ,
                                t1.FPurchaseAmount ,
                                t1.FKFDate ,
                                t1.FKFPeriod ,
                                t1.FPeriodDate ,
                                t5.�²ֿ����� ,
                                t1.FDCSPID ,
                                t1.FOrgBillEntryID ,
                                t1.FSNListID ,
                                t1.FSourceBillNo ,
                                t1.FSourceTranType ,
                                t4.FNSourceInterId ,
                                t4.FNSourceEntryID ,
                                t1.FContractBillNo ,
                                t1.FContractInterID ,
                                t1.FContractEntryID ,
                                t1.FOrderBillNo ,
                                t4.FNOrderInterID ,
                                t4.FNSourceEntryID ,
                                t1.FAllHookQTY ,
                                t1.FAllHookAmount ,
                                t1.FCurrentHookQTY ,
                                t1.FCurrentHookAmount ,
                                t1.FPlanMode ,
                                t1.FMTONo ,
                                t1.FChkPassItem ,
                                t1.FDeliveryNoticeFID ,
                                t1.FDeliveryNoticeEntryID ,
                                t1.FCheckAmount ,
                                t1.FOutSourceInterID ,
                                t1.FOutSourceEntryID ,
                                t1.FOutSourceTranType
                        FROM    #tmp201 t1
                                LEFT JOIN #tmp07 t2 ON t1.FItemID = t2.FItemID
                                LEFT JOIN #tmp08 t3 ON t1.FUnitID = t3.FItemID
                                LEFT JOIN #tmp10 t4 ON t1.FInterID = t4.FInterID
                                                       AND t1.FEntryID = t4.FEntryID
                                LEFT JOIN #tmp11 t5 ON LEFT(t2.FNNumber, 1) = t5.���ϴ�������ĸ
                        WHERE   t1.FInterID = @FInterID

                EXEC p_UpdateBillRelateData 1, @FNInterID, 'ICStockBill',
                    'ICStockBillEntry' 

                INSERT  INTO ICStockBill
                        ( FInterID ,
                          FBillNo ,
                          FBrNo ,
                          FTranType ,
                          FCancellation ,
                          FStatus ,
                          FUpStockWhenSave ,
                          FROB ,
                          FHookStatus ,
                          Fdate ,
                          FSupplyID ,
                          FCheckDate ,
                          FFManagerID ,
                          FSManagerID ,
                          FBillerID ,
                          FPOStyle ,
                          FMultiCheckDate1 ,
                          FMultiCheckDate2 ,
                          FMultiCheckDate3 ,
                          FMultiCheckDate4 ,
                          FMultiCheckDate5 ,
                          FMultiCheckDate6 ,
                          FRelateBrID ,
                          FPOOrdBillNo ,
                          FOrgBillInterID ,
                          FSelTranType ,
                          FBrID ,
                          FExplanation ,
                          FDeptID ,
                          FManagerID ,
                          FEmpID ,
                          FCussentAcctID ,
                          FManageType ,
                          FPOMode ,
                          FSettleDate ,
                          FPrintCount ,
                          FPayCondition ,
                          FEnterpriseID ,
                          FSendStatus ,
                          FISUpLoad ,
                          FCheckerID
                        )
                        SELECT  @FNInterID ,
                                @FBillNo ,
                                @FBrNo ,
                                @FTranType ,
                                @FCancellation ,
                                @FStatus ,
                                @FUpStockWhenSave ,
                                @FROB ,
                                @FHookStatus ,
                                @Fdate ,
                                @FSupplyID ,
                                @FCheckDate ,
                                @FFManagerID ,
                                @FSManagerID ,
                                @FBillerID ,
                                @FPOStyle ,
                                @FMultiCheckDate1 ,
                                @FMultiCheckDate2 ,
                                @FMultiCheckDate3 ,
                                @FMultiCheckDate4 ,
                                @FMultiCheckDate5 ,
                                @FMultiCheckDate6 ,
                                @FRelateBrID ,
                                @FPOOrdBillNo ,
                                @FOrgBillInterID ,
                                @FSelTranType ,
                                @FBrID ,
                                @FExplanation ,
                                @FDeptID ,
                                @FManagerID ,
                                @FEmpID ,
                                @FCussentAcctID ,
                                @FManageType ,
                                @FPOMode ,
                                @FSettleDate ,
                                @FPrintCount ,
                                @FPayCondition ,
                                @FEnterpriseID ,
                                @FSendStatus ,
                                @FISUpLoad ,
                                @FCheckerID

                UPDATE  ICStockBill
                SET     FUUID = NEWID()
                WHERE   FInterID = @FNInterID

                SELECT  @FNSourceInterId = FNSourceInterID
                FROM    #tmp10
                WHERE   FInterID = @FInterID

                UPDATE  t
                SET     t.FStatus = CASE WHEN ( SELECT  COUNT(1)
                                                FROM    POOrderEntry
                                                WHERE   ( FCommitQty > 0
                                                          OR ( ISNULL(FMRPClosed,
                                                              0) = 1
                                                              AND ISNULL(FMRPAutoClosed,
                                                              1) = 0
                                                             )
                                                        )
                                                        AND FInterID IN (
                                                        @FNSourceInterId )
                                              ) = 0 THEN 1
                                         WHEN ( SELECT  COUNT(1)
                                                FROM    POOrderEntry te
                                                WHERE   ( ISNULL(FMRPClosed, 0) = 1
                                                          OR FCommitQty >= FQty
                                                        )
                                                        AND FInterID IN (
                                                        @FNSourceInterId )
                                              ) < ( SELECT  COUNT(1)
                                                    FROM    POOrderEntry
                                                    WHERE   FInterID IN (
                                                            @FNSourceInterId )
                                                  ) THEN 2
                                         ELSE 3
                                    END ,
                        t.FClosed = CASE WHEN ( SELECT  COUNT(1)
                                                FROM    POOrderEntry te
                                                WHERE   ( FCommitQty >= FQty
                                                          OR ( ISNULL(te.FMRPAutoClosed,
                                                              1) = 0
                                                              AND ISNULL(FMRPClosed,
                                                              0) = 1
                                                             )
                                                        )
                                                        AND te.FInterID IN (
                                                        @FNSourceInterId )
                                              ) = ( SELECT  COUNT(1)
                                                    FROM    POOrderEntry te
                                                    WHERE   te.FInterID IN (
                                                            @FNSourceInterId )
                                                  ) THEN 1
                                         ELSE 0
                                    END
                FROM    POOrder t
                WHERE   t.FInterID IN ( @FNSourceInterId )

                UPDATE  v1
                SET     v1.FStatus = ( CASE WHEN u1.sumqty > 0
                                            THEN ( CASE WHEN u1.qty <= u1.sumqty
                                                        THEN 3
                                                        ELSE 1
                                                   END )
                                            ELSE v1.FStatus
                                       END ) ,
                        FChildren = ( CASE WHEN u1.sumqty > 0 THEN 1
                                           ELSE 0
                                      END )
                FROM    POInStock v1
                        INNER JOIN ( SELECT t2.FInterID ,
                                            SUM(t2.fqty) AS qty ,
                                            SUM(t2.fconcommitqty
                                                + t2.fcommitqty
                                                + t2.FSampleBreakQty) AS sumqty
                                     FROM   POInStockEntry t2
                                            INNER JOIN ICStockBillEntry t3 ON t2.FInterID = t3.fsourceinterid
                                     WHERE  t3.fsourcetrantype = 72
                                            AND t3.FInterID = @FNInterID
                                     GROUP BY t2.FInterID
                                   ) u1 ON v1.FInterID = u1.FInterID

                IF EXISTS ( SELECT  1
                            FROM    ICBillRelations_Sale
                            WHERE   FBillType = 1
                                    AND FBillID = @FNInterID ) 
                    BEGIN
                        UPDATE  t1
                        SET     t1.FChildren = t1.FChildren + 1
                        FROM    POOrder t1
                                INNER JOIN POOrderEntry t2 ON t1.FInterID = t2.FInterID
                                INNER JOIN ICBillRelations_Sale t3 ON t3.FMultiEntryID = t2.FEntryID
                                                              AND t3.FMultiInterID = t2.FInterID
                        WHERE   t3.FBillType = 1
                                AND t3.FBillID = @FNInterID
                    END
                ELSE 
                    BEGIN
                        UPDATE  t3
                        SET     t3.FChildren = t3.FChildren + 1
                        FROM    ICStockBill t1
                                INNER JOIN ICStockBillEntry t2 ON t1.FInterID = t2.FInterID
                                INNER JOIN POOrder t3 ON t3.FTranType = t2.FSourceTranType
                                                         AND t3.FInterID = t2.FSourceInterID
                        WHERE   t1.FTranType = 1
                                AND t1.FInterID = @FNInterID
                                AND t2.FSourceInterID > 0
                    END

--���
                IF OBJECT_ID('tempdb..#TempBill') IS NOT NULL 
                    DROP TABLE #TempBill

                SET NOCOUNT ON
                CREATE TABLE #TempBill
                    (
                      FID INT IDENTITY(1, 1) ,
                      FBrNo VARCHAR(10) NOT NULL
                                        DEFAULT ( '' ) ,
                      FInterID INT NOT NULL
                                   DEFAULT ( 0 ) ,
                      FEntryID INT NOT NULL
                                   DEFAULT ( 0 ) ,
                      FTranType INT NOT NULL
                                    DEFAULT ( 0 ) ,
                      FItemID INT NOT NULL
                                  DEFAULT ( 0 ) ,
                      FBatchNo NVARCHAR(255) NOT NULL
                                             DEFAULT ( '' ) ,
                      FMTONo NVARCHAR(255) NOT NULL
                                           DEFAULT ( '' ) ,
                      FAuxPropID INT NOT NULL
                                     DEFAULT ( 0 ) ,
                      FStockID INT NOT NULL
                                   DEFAULT ( 0 ) ,
                      FStockPlaceID INT NOT NULL
                                        DEFAULT ( 0 ) ,
                      FKFPeriod INT NOT NULL
                                    DEFAULT ( 0 ) ,
                      FKFDate VARCHAR(20) NOT NULL
                                          DEFAULT ( '' ) ,
                      FSupplyID INT NOT NULL
                                    DEFAULT ( 0 ) ,
                      FQty DECIMAL(28, 10) NOT NULL
                                           DEFAULT ( 0 ) ,
                      FSecQty DECIMAL(28, 10) NOT NULL
                                              DEFAULT ( 0 ) ,
                      FAmount DECIMAL(28, 2) NOT NULL
                                             DEFAULT ( 0 )
                    )

                INSERT  INTO #TempBill
                        ( FBrNo ,
                          FInterID ,
                          FEntryID ,
                          FTranType ,
                          FItemID ,
                          FBatchNo ,
                          FMTONo ,
                          FAuxPropID ,
                          FStockID ,
                          FStockPlaceID ,
                          FKFPeriod ,
                          FKFDate ,
                          FSupplyID ,
                          FQty ,
                          FSecQty ,
                          FAmount
                        )
                        SELECT  '' ,
                                u1.FInterID ,
                                u1.FEntryID ,
                                1 AS FTranType ,
                                u1.FItemID ,
                                ISNULL(u1.FBatchNo, '') AS FBatchNo ,
                                ISNULL(u1.FMTONo, '') AS FMTONo ,
                                u1.FAuxPropID ,
                                ISNULL(u1.FDCStockID, 0) AS FDCStockID ,
                                ISNULL(u1.FDCSPID, 0) AS FDCSPID ,
                                ISNULL(u1.FKFPeriod, 0) AS FKFPeriod ,
                                LEFT(ISNULL(CONVERT(VARCHAR(20), u1.FKFdate, 120),
                                            ''), 10) AS FKFDate ,
                                FEntrySupply ,
                                1 * u1.FQty AS FQty ,
                                1 * u1.FSecQty AS FSecQty ,
                                1 * u1.FAmount
                        FROM    ICStockBillEntry u1
                        WHERE   u1.FInterID = @FNInterID
                        ORDER BY u1.FEntryID

                IF OBJECT_ID('tempdb..#TempPOBill') IS NOT NULL 
                    DROP TABLE #TempPOBill

                UPDATE  ICStockBill
                SET     FOrderAffirm = 0
                WHERE   FInterID = @FNInterID

                UPDATE  ICStockBill
                SET     FCheckerID = @FCheckerID ,
                        FStatus = 1 ,
                        FCheckDate = GETDATE()
                WHERE   FInterID = @FNInterID

                IF EXISTS ( SELECT  FOrderInterID
                            FROM    ICStockBillEntry
                            WHERE   FOrderInterID > 0
                                    AND FInterID = @FNInterID ) 
                    UPDATE  u1
                    SET     u1.FStockQty = u1.FStockQty + 1
                            * CAST(u2.FStockQty AS FLOAT) ,
                            u1.FSecStockQty = u1.FSecStockQty + 1
                            * CAST(u2.FSecStockQty AS FLOAT) ,
                            u1.FAuxStockQty = ROUND(( u1.FStockQty + 1
                                                      * CAST(u2.FStockQty AS FLOAT) )
                                                    / CAST(t3.FCoefficient AS FLOAT),
                                                    t1.FQtyDecimal)
                    FROM    POOrderEntry u1
                            INNER JOIN ( SELECT FOrderInterID ,
                                                FOrderEntryID ,
                                                FItemID ,
                                                SUM(FQty) AS FStockQty ,
                                                SUM(FSecQty) AS FSecStockQty ,
                                                SUM(FAuxQty) AS FAuxStockQty
                                         FROM   ICStockBillEntry
                                         WHERE  FInterID = @FNInterID
                                         GROUP BY FOrderInterID ,
                                                FOrderEntryID ,
                                                FItemID
                                       ) u2 ON u1.FInterID = u2.FOrderInterID
                                               AND u1.FEntryID = u2.FOrderEntryID
                                               AND u1.FItemID = u2.FItemID
                            INNER JOIN t_ICItem t1 ON u1.FItemID = t1.FItemID
                            INNER JOIN t_MeasureUnit t3 ON u1.FUnitID = t3.FItemID

                UPDATE  p1
                SET     p1.FMrpClosed = CASE WHEN ISNULL(p1.FMRPAutoClosed, 1) = 1
                                             THEN ( CASE WHEN p1.FStockQty < p1.FQty
                                                         THEN 0
                                                         ELSE 1
                                                    END )
                                             ELSE p1.FMrpClosed
                                        END
                FROM    POOrderEntry p1
                        INNER JOIN ICStockBillEntry u1 ON u1.FOrderInterID = p1.FInterID
                                                          AND u1.FOrderEntryID = p1.FEntryID
                WHERE   u1.FInterID = @FNInterID

                UPDATE  t
                SET     t.FStatus = CASE WHEN ( SELECT  COUNT(1)
                                                FROM    POOrderEntry
                                                WHERE   ( FCommitQty > 0
                                                          OR ( ISNULL(FMRPClosed,
                                                              0) = 1
                                                              AND ISNULL(FMRPAutoClosed,
                                                              1) = 0
                                                             )
                                                        )
                                                        AND FInterID IN (
                                                        @FNSourceInterId )
                                              ) = 0 THEN 1
                                         WHEN ( SELECT  COUNT(1)
                                                FROM    POOrderEntry te
                                                WHERE   ( ISNULL(FMRPClosed, 0) = 1
                                                          OR FCommitQty >= FQty
                                                        )
                                                        AND FInterID IN (
                                                        @FNSourceInterId )
                                              ) < ( SELECT  COUNT(1)
                                                    FROM    POOrderEntry
                                                    WHERE   FInterID IN (
                                                            @FNSourceInterId )
                                                  ) THEN 2
                                         ELSE 3
                                    END ,
                        t.FClosed = CASE WHEN ( SELECT  COUNT(1)
                                                FROM    POOrderEntry te
                                                WHERE   ( FCommitQty >= FQty
                                                          OR ( ISNULL(te.FMRPAutoClosed,
                                                              1) = 0
                                                              AND ISNULL(FMRPClosed,
                                                              0) = 1
                                                             )
                                                        )
                                                        AND te.FInterID IN (
                                                        @FNSourceInterId )
                                              ) = ( SELECT  COUNT(1)
                                                    FROM    POOrderEntry te
                                                    WHERE   te.FInterID IN (
                                                            @FNSourceInterId )
                                                  ) THEN 1
                                         ELSE 0
                                    END
                FROM    POOrder t
                WHERE   t.FInterID IN ( @FNSourceInterId )

--ͬ����¼��
--���ݱ�ICStockBillͬ����¼�Ǽ�
                INSERT  INTO t_HT_SyncControl
                        ( FID ,
                          FEntryID ,
                          FName ,
                          FNumber ,
                          FBillNo ,
                          FType ,
                          FIsSync ,
                          FStatus ,
                          FRStatus ,
                          FMStatus ,
                          FOID ,
                          FOEntryID ,
                          FIsEntrySync ,
                          FIsPrdSync
                        )
                        SELECT  @FNInterID ,
                                t1.FEntryID ,
                                t2.FName ,
                                t2.FNumber ,
                                @FBillNo ,
                                '�ɹ����' ,
                                5 ,
                                @FStatus ,
                                0 ,
                                NULL ,
                                @FInterID ,
                                t1.FEntryID ,
                                0 ,
                                NULL
                        FROM    ICStockBillEntry t1
                                LEFT JOIN t_ICItem t2 ON t1.FItemID = t2.FItemID
                        WHERE   t1.FInterID = @FNInterID

                FETCH NEXT FROM mycursor INTO @FInterID, @FBillNo, @FBrNo,
                    @FTranType, @FCancellation, @FStatus, @FUpStockWhenSave,
                    @FROB, @FHookStatus, @Fdate, @FSupplyID, @FCheckDate,
                    @FFManagerID, @FSManagerID, @FBillerID, @FPOStyle,
                    @FMultiCheckDate1, @FMultiCheckDate2, @FMultiCheckDate3,
                    @FMultiCheckDate4, @FMultiCheckDate5, @FMultiCheckDate6,
                    @FRelateBrID, @FPOOrdBillNo, @FOrgBillInterID,
                    @FSelTranType, @FBrID, @FExplanation, @FDeptID,
                    @FManagerID, @FEmpID, @FCussentAcctID, @FManageType,
                    @FPOMode, @FSettleDate, @FPrintCount, @FPayCondition,
                    @FEnterpriseID, @FSendStatus, @FISUpLoad, @FCheckerID
            END 
        CLOSE mycursor 
        DEALLOCATE mycursor

        DROP TABLE #tmp01
        DROP TABLE #tmp02
        DROP TABLE #tmp03
        DROP TABLE #tmp04
        DROP TABLE #tmp05
        DROP TABLE #tmp06
        DROP TABLE #tmp07
        DROP TABLE #tmp08
        DROP TABLE #tmp10
        DROP TABLE #tmp11
        DROP TABLE #tmp1
        DROP TABLE #tmp200
        DROP TABLE #tmp201
        DROP TABLE #tmp202
        SET nocount OFF
    END


--exec pro_HT_ICStockBill1Sync
--�漰���ε��ݵ�������д������ɾ��
--delete from ICStockBill where FTrantype=1
--update icstockbill set fcheckerid=0,fcheckdate=null,fstatus=0 where ftrantype=1
--delete from t_HT_SyncControl where FType='�ɹ����'

