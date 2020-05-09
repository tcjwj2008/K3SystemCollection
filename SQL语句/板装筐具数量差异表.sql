
SET NOCOUNT ON;

SELECT  t3.fname ,
        t1.fbillno ,
        t1.fdate ,
        t1.fheadselfs0154 ,
        t2.fauxqty ,
        t2.fauxqty2 ,
        ISNULL(( fheadselfs0154 - t2.fauxqty2 - t2.fauxqty ), 0) AS diff
FROM    seorder AS t1
        INNER JOIN ( SELECT finterid ,
                            SUM(fauxqty) AS fauxqty ,
                            SUM(fentryselfs0161) AS fauxqty2
                     FROM   seorderentry
                     WHERE  funitid IN ( '124', '125', '126', '1570', '1755' )
                     GROUP BY finterid
                   ) AS t2 ON t1.finterid = t2.finterid
        INNER JOIN t_organization t3 ON t1.fcustid = t3.fitemid
WHERE   t1.fdate >= '2012-12-01'
        AND ( fheadselfs0154 - t2.fauxqty ) <> 0;
SET NOCOUNT OFF;
