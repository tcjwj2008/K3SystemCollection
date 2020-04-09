--DROP TABLE #T_YX_SubInStock  

--����ʽ���׶�ȡ��������д����ʱ�� #T_YX_SubInStock
SELECT  *
INTO    #T_YX_SubInStock
FROM    CON11.AIS_YXSP2.dbo.T_YX_SubInStock
WHERE   FDate >= '2018-06-01'
        AND FDate < '2018-07-01'
ORDER BY FDate;


--��������Ѵ���Ŀ�����ף�����ͬ��,��ʼʱ���2018-06-01��ʼ
DELETE  FROM #T_YX_SubInStock
WHERE   FBillNo IN ( SELECT FBillNo
                     FROM   T_YX_SubInStock
                     WHERE  FDate >= '2018-06-01' ); 
 

--��ʱ�������ֶ� FZID 
ALTER TABLE #T_YX_SubInStock ADD FZID INT IDENTITY(1,1);


--SELECT * FROM #T_YX_SubInStock


--���ݰ���������ѭ����ȡ

DECLARE @ZID INT;
  --��������־
SELECT  @ZID = 1;

DECLARE @CountNum INT;
 --��ʱ������������
SELECT  @CountNum = COUNT(*)
FROM    #T_YX_SubInStock;	    

--��¼����Ҫ�䶯�Ĳ���
DECLARE @FID INT;
 --��������


WHILE ( @ZID <= @CountNum )
    BEGIN --ѭ����ʼ

--1д���������� T_YX_SubInStock
        SELECT  @FID = FID
        FROM    #T_YX_SubInStock t
        WHERE   FZID = @ZID;

        INSERT  INTO T_YX_SubInStock
                SELECT  FID ,
                        FClassTypeID ,
                        FBillNo ,
                        FDate ,
                        FSubId = ( SELECT   FItemID
                                   FROM     t_Item_3001
                                   WHERE    FNumber = ( SELECT
                                                              FNumber
                                                        FROM  CON11.AIS_YXSP2.dbo.t_Item_3001
                                                        WHERE FItemID = t.FSubID
                                                      )
                                 ) ,
                        FBiller = ( SELECT  FUserID
                                    FROM    t_User
                                    WHERE   FName = ( SELECT  FName
                                                      FROM    CON11.AIS_YXSP2.dbo.t_User
                                                      WHERE   FUserID = t.FBiller
                                                    )
                                  ) ,
                        FCheckDate ,
                        FChecker = ( SELECT FUserID
                                     FROM   t_User
                                     WHERE  FName = ( SELECT  FName
                                                      FROM    CON11.AIS_YXSP2.dbo.t_User
                                                      WHERE   FUserID = t.FChecker
                                                    )
                                   )
                FROM    #T_YX_SubInStock t
                WHERE   fzid = @ZID;


--2д���¼���� T_YX_SubInStockEntry
        INSERT  INTO T_YX_SubInStockEntry
                SELECT  FID ,
                        FIndex ,
                        FItemId = ( SELECT  FItemID
                                    FROM    dbo.t_ICItem
                                    WHERE   FNumber = ( SELECT
                                                              FNumber
                                                        FROM  CON11.AIS_YXSP2.dbo.t_ICItem
                                                        WHERE FItemID = t.FItemID
                                                      )
                                  ) ,
                        Fqty ,
                        Fprice ,
                        FAmount
                FROM    CON11.AIS_YXSP2.dbo.T_YX_SubInStockEntry t
                WHERE   FID = @FID;


--�����¼�� ICClassCheckRecords200000012
        DELETE  FROM ICClassCheckRecords200000012
        WHERE   FBillID = @FID;
        INSERT  INTO ICClassCheckRecords200000012
                SELECT  FPage ,
                        FBillID ,
                        FBillEntryID ,
                        FBillNo ,
                        FBillEntryIndex ,
                        FCheckLevel ,
                        FCheckLevelTo ,
                        FMode ,
                        FCheckMan = ( SELECT    FUserID
                                      FROM      t_User
                                      WHERE     FName = ( SELECT
                                                              FName
                                                          FROM
                                                              CON11.AIS_YXSP2.dbo.t_User
                                                          WHERE
                                                              FUserID = t.FCheckMan
                                                        )
                                    ) ,
                        FCheckIdea ,
                        FCheckDate ,
                        FDescriptions
                FROM    CON11.AIS_YXSP2.dbo.ICClassCheckRecords200000012 t
                WHERE   FBillID = @FID;


--������˱� ICClassCheckStatus200000012
        DELETE  FROM ICClassCheckStatus200000012
        WHERE   FBillID = @FID;
        INSERT  ICClassCheckStatus200000012
                ( FPage ,
                  FBillID ,
                  FBillEntryID ,
                  FBillNo ,
                  FBillEntryIndex ,
                  FCurrentLevel ,
                  FCheckMan1 ,
                  FCheckIdea1 ,
                  FCheckDate1
                )
                SELECT  FPage ,
                        FBillID ,
                        FBillEntryID ,
                        FBillNo ,
                        FBillEntryIndex ,
                        FCurrentLevel ,
                        FCheckMan1 = ( SELECT   FUserID
                                       FROM     t_User
                                       WHERE    FName = ( SELECT
                                                              FName
                                                          FROM
                                                              CON11.AIS_YXSP2.dbo.t_User
                                                          WHERE
                                                              FUserID = t.FCheckMan1
                                                        )
                                     ) ,
                        FCheckIdea1 ,
                        FCheckDate1
                FROM    CON11.AIS_YXSP2.dbo.ICClassCheckStatus200000012 t
                WHERE   FBillID = @FID;


        SELECT  @ZID = @ZID + 1; --��������1
        PRINT @ZID;


    END; --ѭ������




                                            
