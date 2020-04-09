--DROP TABLE #T_YX_SubInStock  

--从正式账套读取主表数据写入临时表 #T_YX_SubInStock
SELECT  *
INTO    #T_YX_SubInStock
FROM    CON11.AIS_YXSP2.dbo.T_YX_SubInStock
WHERE   FDate >= '2018-06-01'
        AND FDate < '2018-07-01'
ORDER BY FDate;


--如果单号已存在目标账套，不再同步,开始时间从2018-06-01开始
DELETE  FROM #T_YX_SubInStock
WHERE   FBillNo IN ( SELECT FBillNo
                     FROM   T_YX_SubInStock
                     WHERE  FDate >= '2018-06-01' ); 
 

--临时表增加字段 FZID 
ALTER TABLE #T_YX_SubInStock ADD FZID INT IDENTITY(1,1);


--SELECT * FROM #T_YX_SubInStock


--数据按日期排序，循环读取

DECLARE @ZID INT;
  --计数器标志
SELECT  @ZID = 1;

DECLARE @CountNum INT;
 --临时表数据总行数
SELECT  @CountNum = COUNT(*)
FROM    #T_YX_SubInStock;	    

--分录表需要变动的参数
DECLARE @FID INT;
 --单据内码


WHILE ( @ZID <= @CountNum )
    BEGIN --循环开始

--1写入主表数据 T_YX_SubInStock
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


--2写入分录数据 T_YX_SubInStockEntry
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


--插入记录表 ICClassCheckRecords200000012
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


--插入审核表 ICClassCheckStatus200000012
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


        SELECT  @ZID = @ZID + 1; --计数器加1
        PRINT @ZID;


    END; --循环结束




                                            
