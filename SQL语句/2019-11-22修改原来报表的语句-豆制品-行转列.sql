--dzp_psdd_qiu '2019-05-18'

ALTER PROCEDURE dzp_psdd_qiu @fdate VARCHAR(20)
AS
    BEGIN
        DECLARE @sql VARCHAR(MAX);
        SELECT  CONVERT(VARCHAR(50), FDate, 23) ,
                车次 ,
                客户代码 ,
                客户名称 ,
                客户地址 ,
                ( SELECT    'sum(case  品名规格 when  ''' + 品名规格
                            + ''' then 数量 end) [' + 品名规格 + '],'
                  FROM      ( SELECT DISTINCT
                                        品名规格
                              FROM      ( SELECT    t1.FDate ,
                                                    CAST(t3.F_102 AS INT) AS 车次 ,
                                                    t3.FNumber AS 客户代码 ,
                                                    t3.FName AS 客户名称 ,
                                                    t3.FAddress AS 客户地址 ,
                                                    t4.FNumber AS 物料编码 ,
                                                    t2.FEntrySelfS0162 AS 品名规格 ,
                                                    SUM(t2.FEntrySelfS0163) AS 数量 ,
                                                    t4.F_103 AS 配货顺序
                                          FROM      dbo.SEOrder AS t1
                                                    INNER JOIN dbo.SEOrderEntry
                                                    AS t2 ON t1.FInterID = t2.FInterID
                                                    INNER JOIN dbo.t_Organization
                                                    AS t3 ON t1.FCustID = t3.FItemID
                                                    INNER JOIN dbo.t_ICItem AS t4 ON t2.FItemID = t4.FItemID
                                          WHERE     ( t3.FNumber LIKE '03.%'
                                                      OR t3.FNumber LIKE '02.%'
                                                    )
                                                    AND ( t1.FCancellation = '0' )
                                                    AND ( t1.FBillerID NOT IN (
                                                          16590, 16591, 16592 ) )
                                          GROUP BY  t1.FDate ,
                                                    CAST(t3.F_102 AS INT) ,
                                                    t3.FNumber ,
                                                    t3.FName ,
                                                    t3.FAddress ,
                                                    t4.FNumber ,
                                                    t2.FEntrySelfS0162 ,
                                                    t4.F_103
                                        ) tt
                              WHERE     tt.FDate = @fdate
                                        AND ( 物料编码 LIKE '8.06.%'
                                              OR 物料编码 LIKE '8.20.%'
                                              OR 物料编码 LIKE '8.21.%'
                                            )
                            ) t
                FOR
                  XML PATH('')
                ) ,
                SUM(数量) AS 合计
        FROM    ( SELECT    t1.FDate ,
                            CAST(t3.F_102 AS INT) AS 车次 ,
                            t3.FNumber AS 客户代码 ,
                            t3.FName AS 客户名称 ,
                            t3.FAddress AS 客户地址 ,
                            t4.FNumber AS 物料编码 ,
                            t2.FEntrySelfS0162 AS 品名规格 ,
                            SUM(t2.FEntrySelfS0163) AS 数量 ,
                            t4.F_103 AS 配货顺序
                  FROM      dbo.SEOrder AS t1
                            INNER JOIN dbo.SEOrderEntry AS t2 ON t1.FInterID = t2.FInterID
                            INNER JOIN dbo.t_Organization AS t3 ON t1.FCustID = t3.FItemID
                            INNER JOIN dbo.t_ICItem AS t4 ON t2.FItemID = t4.FItemID
                  WHERE     ( t3.FNumber LIKE '03.%'
                              OR t3.FNumber LIKE '02.%'
                            )
                            AND ( t1.FCancellation = 0 )
                            AND ( t1.FBillerID NOT IN ( 16590, 16591, 16592 ) )
                  GROUP BY  t1.FDate ,
                            CAST(t3.F_102 AS INT) ,
                            t3.FNumber ,
                            t3.FName ,
                            t3.FAddress ,
                            t4.FNumber ,
                            t2.FEntrySelfS0162 ,
                            t4.F_103
                ) A
        WHERE   ( 物料编码 LIKE '8.06.%'
                  OR 物料编码 LIKE '8.20.%'
                  OR 物料编码 LIKE '8.21.%'
                )
                AND FDate = @fdate
        GROUP BY FDate ,
                车次 ,
                客户代码 ,
                客户名称 ,
                客户地址;
        
        
    END;