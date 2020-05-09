--dzp_psdd_qiu '2019-05-18'

ALTER PROCEDURE dzp_psdd_qiu @fdate VARCHAR(20)
AS
    BEGIN
        DECLARE @sql VARCHAR(MAX);
        SELECT  CONVERT(VARCHAR(50), FDate, 23) ,
                ���� ,
                �ͻ����� ,
                �ͻ����� ,
                �ͻ���ַ ,
                ( SELECT    'sum(case  Ʒ����� when  ''' + Ʒ�����
                            + ''' then ���� end) [' + Ʒ����� + '],'
                  FROM      ( SELECT DISTINCT
                                        Ʒ�����
                              FROM      ( SELECT    t1.FDate ,
                                                    CAST(t3.F_102 AS INT) AS ���� ,
                                                    t3.FNumber AS �ͻ����� ,
                                                    t3.FName AS �ͻ����� ,
                                                    t3.FAddress AS �ͻ���ַ ,
                                                    t4.FNumber AS ���ϱ��� ,
                                                    t2.FEntrySelfS0162 AS Ʒ����� ,
                                                    SUM(t2.FEntrySelfS0163) AS ���� ,
                                                    t4.F_103 AS ���˳��
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
                                        AND ( ���ϱ��� LIKE '8.06.%'
                                              OR ���ϱ��� LIKE '8.20.%'
                                              OR ���ϱ��� LIKE '8.21.%'
                                            )
                            ) t
                FOR
                  XML PATH('')
                ) ,
                SUM(����) AS �ϼ�
        FROM    ( SELECT    t1.FDate ,
                            CAST(t3.F_102 AS INT) AS ���� ,
                            t3.FNumber AS �ͻ����� ,
                            t3.FName AS �ͻ����� ,
                            t3.FAddress AS �ͻ���ַ ,
                            t4.FNumber AS ���ϱ��� ,
                            t2.FEntrySelfS0162 AS Ʒ����� ,
                            SUM(t2.FEntrySelfS0163) AS ���� ,
                            t4.F_103 AS ���˳��
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
        WHERE   ( ���ϱ��� LIKE '8.06.%'
                  OR ���ϱ��� LIKE '8.20.%'
                  OR ���ϱ��� LIKE '8.21.%'
                )
                AND FDate = @fdate
        GROUP BY FDate ,
                ���� ,
                �ͻ����� ,
                �ͻ����� ,
                �ͻ���ַ;
        
        
    END;