ALTER PROCEDURE pro_HT_MaterialGroupSync
AS 
    BEGIN 
        SET nocount ON
--1.�����������
--ͬ���������ʱ�����Զ�����һ�ݳɱ��������
--ͬ������ʱ��ֻ����������Ϊ���ƺ�����ʱ���Ż��Զ�����һ�ݳɱ�����
--1.1�ҳ����ǽ��ã��������ĸ������������,����������
        SELECT  FItemID ,
                FItemClassID ,
                0 AS FParentID ,
                FLevel ,
                FName ,
                FNumber ,
                FShortNumber ,
                FFullNumber ,
                FDetail ,
                FDeleted
        INTO    #tmp0
        FROM    AIS20121023172833.dbo.t_item t1
        WHERE   ( 1 = 1 )
                AND t1.fitemclassid = 4
                AND t1.FDetail = 0
                AND t1.FDeleted = 0
                AND NOT EXISTS ( SELECT *
                                 FROM   t_HT_SyncControl
                                 WHERE  FOID = t1.FItemID
                                        AND FType = '������-�������' )

--��������t_Item��һ����select���뱨��
        DECLARE @FItemClassID BIGINT
        DECLARE @FParentID BIGINT 
        DECLARE @FLevel BIGINT
        DECLARE @FName VARCHAR(100)
        DECLARE @FNumber VARCHAR(100)
        DECLARE @FShortNumber VARCHAR(100)
        DECLARE @FFullNumber VARCHAR(100)
        DECLARE @FDetail BIGINT 
        DECLARE @FDeleted BIGINT
        DECLARE @FItemID BIGINT
        DECLARE @FOItemID BIGINT
        DECLARE mycursor CURSOR
        FOR
            SELECT  FItemID ,
                    FItemClassID ,
                    FParentID ,
                    FLevel ,
                    FName ,
                    FNumber ,
                    FShortNumber ,
                    FFullNumber ,
                    FDetail ,
                    FDeleted
            FROM    #tmp0 
        OPEN mycursor  
        FETCH NEXT FROM mycursor INTO @FOItemID, @FItemClassID, @FParentID,
            @FLevel, @FName, @FNumber, @FShortNumber, @FFullNumber, @FDetail,
            @FDeleted
        WHILE ( @@fetch_status = 0 ) 
            BEGIN 
--���븨����-�������
                INSERT  INTO t_Item
                        ( FItemClassID ,
                          FParentID ,
                          FLevel ,
                          FName ,
                          FNumber ,
                          FShortNumber ,
                          FFullNumber ,
                          FDetail ,
                          UUID ,
                          FDeleted
                        )
                        SELECT  @FItemClassID ,
                                @FParentID ,
                                @FLevel ,
                                @FName ,
                                @FNumber ,
                                @FShortNumber ,
                                @FFullNumber ,
                                @FDetail ,
                                NEWID() AS UUID ,
                                @FDeleted

                SELECT  @FItemID = FItemID
                FROM    t_item
                WHERE   FItemClassID = 4
                        AND FNumber = @FNumber

                INSERT  INTO t_ItemRight
                        ( FTypeID ,
                          FUserID ,
                          FItemID
                        )
                        SELECT  fitemclassid ,
                                fuserid ,
                                @FItemID
                        FROM    t_useritemclassright
                        WHERE   ( ( FUserItemClassRight & 8 ) = 8 )
                                AND fitemclassid = 4
                                AND fuserid <> 16394

                INSERT  INTO t_BaseProperty
                        ( FTypeID ,
                          FItemID ,
                          FCreateDate ,
                          FCreateUser ,
                          FLastModDate ,
                          FLastModUser ,
                          FDeleteDate ,
                          FDeleteUser
                        )
                VALUES  ( 3 ,
                          @FItemID ,
                          GETDATE() ,
                          'administrator' ,
                          NULL ,
                          NULL ,
                          NULL ,
                          NULL
                        )

                DELETE  FROM Access_t_ICItem
                WHERE   FItemID = @FItemID
                INSERT  INTO Access_t_ICItem
                        ( FItemID ,
                          FParentIDX ,
                          FDataAccessView ,
                          FDataAccessEdit ,
                          FDataAccessDelete
                        )
                VALUES  ( @FItemID ,
                          0 ,
                          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
                          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
                          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100))
                        )

                UPDATE  t_Item
                SET     FName = FName
                WHERE   FItemID = @FItemID
                        AND FItemClassID = 4
                UPDATE  t1
                SET     t1.FFullName = t2.FFullName
                FROM    t_ICItemBase t1
                        INNER JOIN t_Item t2 ON t1.FItemID = t2.FItemID
                                                AND t2.FItemID = @FItemID

--����ɱ�����
                INSERT  INTO t_Item
                        ( FItemClassID ,
                          FParentID ,
                          FLevel ,
                          FName ,
                          FNumber ,
                          FShortNumber ,
                          FFullNumber ,
                          FDetail ,
                          UUID ,
                          FDeleted
                        )
                        SELECT  2001 ,
                                @FParentID ,
                                @FLevel ,
                                @FName ,
                                @FNumber ,
                                @FShortNumber ,
                                @FFullNumber ,
                                @FDetail ,
                                NEWID() AS UUID ,
                                @FDeleted

                SELECT  @FItemID = FItemID
                FROM    t_item
                WHERE   FItemClassID = 2001
                        AND FNumber = @FNumber

                INSERT  INTO t_ItemRight
                        ( FTypeID ,
                          FUserID ,
                          FItemID
                        )
                        SELECT  fitemclassid ,
                                fuserid ,
                                @FItemID
                        FROM    t_useritemclassright
                        WHERE   ( ( FUserItemClassRight & 8 ) = 8 )
                                AND fitemclassid = 2001
                                AND fuserid <> 16394

                INSERT  INTO t_BaseProperty
                        ( FTypeID ,
                          FItemID ,
                          FCreateDate ,
                          FCreateUser ,
                          FLastModDate ,
                          FLastModUser ,
                          FDeleteDate ,
                          FDeleteUser
                        )
                VALUES  ( 3 ,
                          @FItemID ,
                          GETDATE() ,
                          'administrator' ,
                          NULL ,
                          NULL ,
                          NULL ,
                          NULL
                        )

                DELETE  FROM Access_cbCostObj
                WHERE   FItemID = @FItemID
                INSERT  INTO Access_cbCostObj
                        ( FItemID ,
                          FParentIDX ,
                          FDataAccessView ,
                          FDataAccessEdit ,
                          FDataAccessDelete
                        )
                VALUES  ( @FItemID ,
                          0 ,
                          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
                          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
                          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100))
                        )

                UPDATE  t_Item
                SET     FName = FName
                WHERE   FItemID = @FItemID
                        AND FItemClassID = 2001

--ͬ����¼��
--���ݱ�t_itemͬ����¼�Ǽ�
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
                        SELECT  @FItemID ,
                                NULL ,
                                @FName ,
                                @FNumber ,
                                NULL ,
                                '������-�������' ,
                                1 ,
                                0 ,
                                NULL ,
                                NULL ,
                                @FOItemID ,
                                NULL ,
                                NULL ,
                                NULL

                FETCH NEXT FROM mycursor INTO @FOItemID, @FItemClassID,
                    @FParentID, @FLevel, @FName, @FNumber, @FShortNumber,
                    @FFullNumber, @FDetail, @FDeleted
            END 
        CLOSE mycursor 
        DEALLOCATE mycursor 

--1.2�ҳ����ǽ��ã�������������,����������1
        SELECT  FItemID ,
                FItemClassID ,
                FParentID ,
                FLevel ,
                FName ,
                FNumber ,
                FShortNumber ,
                FFullNumber ,
                FDetail ,
                FDeleted
        INTO    #tmp1
        FROM    AIS20121023172833.dbo.t_item t1
        WHERE   ( 1 = 1 )
                AND t1.fitemclassid = 4
                AND t1.FDetail = 0
                AND t1.FDeleted = 0

--1.3���������ݹ������������ݣ��ҳ�FParentNumber,����������2
        SELECT  t1.* ,
                t2.FNumber AS FParentNumber
        INTO    #tmp2
        FROM    #tmp1 t1
                LEFT JOIN #tmp1 t2 ON t1.FParentID = t2.FItemID

--1.4����������2�������������ݣ��ҳ�������FParentID������������3
        SELECT  t1.* ,
                ISNULL(t2.FItemID, 0) AS FNewParentID ,
                ISNULL(t3.FItemID, 0) AS FCBNewParentID
        INTO    #tmp3
        FROM    #tmp2 t1
                LEFT JOIN ( SELECT  *
                            FROM    t_item
                            WHERE   FItemClassID = 4
                                    AND FDetail = 0
                                    AND FDeleted = 0
                          ) t2 ON t1.FParentNumber = t2.FNumber
                LEFT JOIN ( SELECT  *
                            FROM    t_item
                            WHERE   FItemClassID = 2001
                                    AND FDetail = 0
                                    AND FDeleted = 0
                          ) t3 ON t1.FParentNumber = t3.FNumber

--1.5����������3����FNewParentID��t_item��FParentID
        UPDATE  t1
        SET     t1.FParentID = t2.FNewParentID
        FROM    t_item t1
                INNER JOIN #tmp3 t2 ON t1.FNumber = t2.FNumber
        WHERE   t1.FItemClassID = 4
                AND t1.FDetail = 0

        UPDATE  t1
        SET     t1.FParentID = t2.FCBNewParentID
        FROM    t_item t1
                INNER JOIN #tmp3 t2 ON t1.FNumber = t2.FNumber
        WHERE   t1.FItemClassID = 2001
                AND t1.FDetail = 0

        DROP TABLE #tmp0
        DROP TABLE #tmp1
        DROP TABLE #tmp2
        DROP TABLE #tmp3

        SET nocount OFF
    END 

--exec pro_HT_MaterialGroupSync

--delete from t_HT_SyncControl where FType='������-�������'
