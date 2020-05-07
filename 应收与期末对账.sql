--应收应付账期初数据 t_rp_begdata
--期初发票明细表 t_rp_begdateentry
--往来余额表 t_rp_contactbal
--t_rp_contact
--SELECT TOP 100* FROM t_rp_contactbal



SELECT  t1.fyear ,
        t1.fperiod ,
        t2.faccountid ,
        t2.fname ,
        t1.fcomid ,
        t3.fname ,
        t1.FDetail ,
        t1.foccamountfor ,
        *
FROM    t_rp_begdata t1
        INNER JOIN t_account t2 ON t2.faccountid = t1.faccountid
                                   AND t1.faccountid = 1018
        INNER JOIN t_organization t3 ON t3.fitemid = t1.fcomid
                                        AND t3.fnumber = '01.99.0003'
WHERE   fyear <= 2015


SELECT  ( CASE WHEN t1.fyear < 2015 THEN 2015
               ELSE 2016
          END ) ,
        t2.faccountid ,
        t2.fname ,
        t1.fcomid ,
        t3.fname ,
        t3.fnumber ,
        SUM(t1.foccamountfor)
FROM    t_rp_begdata t1
        INNER JOIN t_account t2 ON t2.faccountid = t1.faccountid
                                   AND t1.faccountid = 1018
                                   AND t1.fyear <= 2015
        INNER JOIN t_organization t3 ON t3.fitemid = t1.fcomid
                                        AND t3.fnumber = '01.99.0003'
GROUP BY ( CASE WHEN t1.fyear < 2015 THEN 2015
                ELSE 2016
           END ) ,
        t2.faccountid ,
        t2.fname ,
        t1.fcomid ,
        t3.fname ,
        t3.fnumber 
         
SELECT  t1.fyear ,
        t1.fperiod ,
        t2.fname ,
        *
FROM    t_RP_ContactBal t1
        LEFT JOIN t_account t2 ON t2.faccountid = t1.faccountid --and t1.faccountid = 1018
        INNER JOIN t_organization t3 ON t3.fitemid = t1.fcustomer
                                        AND t3.fnumber = '01.99.0003'
WHERE   t1.fperiod = 1
        AND t1.fyear = 2015
           
      
UPDATE  t1
SET     t1.fbeginbalancefor = 3591.75 ,
        t1.fendbalancefor = 3591.75 ,
        t1.fbeginbalance = 3591.75 ,
        t1.fendbalance = 3591.75
FROM    t_RP_ContactBal t1
        LEFT JOIN t_account t2 ON t2.faccountid = t1.faccountid --and t1.faccountid = 1018
        INNER JOIN t_organization t3 ON t3.fitemid = t1.fcustomer
                                        AND t3.fnumber = '01.99.0003'
WHERE   t1.fperiod = 1
        AND t1.fyear = 2015
        AND t1.FAccountID = 0