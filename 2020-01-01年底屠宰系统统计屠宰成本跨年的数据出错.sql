SELECT  convert(char,bbbc.killtime,23) killtime,a.clientname, 
                                a.quantity,a.grossweight,a.weight,a.settlemoney 
                                
                                INTO                           tmp_20200101	
FROM    TZ_CG_register2019 a
        INNER JOIN TZ_CG_settle2020 b ON a.CID = b.CID
                                         AND a.clientcode = b.clientcode
                                         AND b.isdelete = 0
                                         AND b.documenttype = 1
                                         AND b.stutus <> -1
        INNER JOIN TZ_CG_settledata2020 c ON b.settlecode = c.settlecode
                                         AND a.RGID = c.RGID
        INNER JOIN ( SELECT RGID ,
                            MIN(CONVERT(CHAR, DATEADD(HOUR, -( -7 ), killtime), 23)) killtime
                     FROM   TZ_CG_registerdata2019
                     WHERE  CID IN ( 11 )
                            AND DATEADD(HOUR, -( -7 ), killtime) >= '2020-01-01                    '
                           -- AND DATEADD(HOUR, -( -7 ), killtime) < '2019-12-31                    '
                            AND killtime IS NOT NULL
                     GROUP BY RGID
                   ) bbbc ON a.RGID = bbbc.RGID
WHERE   a.CID IN ( '11' )
        AND a.issettle = 1
        AND a.isdelete = 0
        AND DATEADD(HOUR, -( -7 ), b.settledate) >= '2020-01-01                    '
       -- AND DATEADD(HOUR, -( -7 ), b.settledate) < '2019-12-31   '