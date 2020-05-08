SELECT  t.fdate ,
        t.fcustnumber ,
        t.fcustname ,
        t.fcontractbillno ,
        t.fbillno ,
        t.fitemname ,
        t.fmodel ,
        t.funitname ,
        t.fnote ,
        t.sellqty ,
        CAST(ROUND(t.sellprice, 0) AS INT) AS sellprice ,
        t.sellamount ,
        t.frecieved ,
        t.fdiscount ,
        t.beginbalance + ISNULL(q.beginbalance, 0) AS beginbalance
FROM    ( SELECT    fdate ,
                    fcustnumber ,
                    fcustname ,
                    fcontractbillno ,
                    fbillno ,
                    fitemname ,
                    fmodel ,
                    funitname ,
                    fnote ,
                    sellqty ,
                    sellprice ,
                    sellamount ,
                    frecieved ,
                    fdiscount ,
                    beginbalance
          FROM      ( SELECT    DATEADD(day, -1, '********') fdate ,
                                ' ' fcontractbillno ,
                                ' ' fbillno ,
                                a.fcustomer fcustid ,
                                b.fnumber fcustnumber ,
                                b.fname fcustname ,
                                SUM(ISNULL(a.fendbalance, 0)) beginbalance ,
                                0 sellprice ,
                                0 sellqty ,
                                0 sellamount ,
                                ' ' fmodel ,
                                ' ' fitemname ,
                                ' ' funitname ,
                                0 frecieved ,
                                0 fdiscount ,
                                ' ' fnote
                      FROM      t_rp_contactbal AS a
                                INNER JOIN t_organization b ON a.fcustomer = b.fitemid
                      WHERE     a.fyear = '*fyear*'
                                AND a.fperiod = MONTH(DATEADD(month, -1,
                                                              '********'))
                                AND a.frp = '1'
                      GROUP BY  a.fcustomer ,
                                b.fnumber ,
                                b.fname 
---�ڳ�����
                      UNION ALL
                      SELECT    v.fdate fdate ,
                                v.fcontractbillno ,
                                v.fbillno ,
                                v.fcustid ,
                                v.fcustnumber ,
                                v.fcustname ,
                                0 beginbalance ,
                                v.sellprice ,
                                v.sellqty ,
                                v.sellamount ,
                                v.fmodel ,
                                v.fitemname ,
                                v.funitname ,
                                0 frecieved ,
                                0 fdiscount ,
                                v.fnote
                      FROM      ( SELECT    a.fdate fdate ,
                                            b.fcontractbillno ,
                                            a.fbillno ,
                                            a.fsupplyid fcustid ,
                                            c.fnumber fcustnumber ,
                                            c.fname fcustname ,
                                            SUM(b.fqty) sellqty ,
                                            SUM(b.fconsignamount) sellamount ,
                                            SUM(b.fconsignamount) / SUM(b.fqty) sellprice ,
                                            d.fmodel ,
                                            d.fname fitemname ,
                                            e.fname funitname ,
                                            b.fnote fnote
                                  FROM      icstockbill a
                                            INNER JOIN icstockbillentry b ON a.finterid = b.finterid
                                            INNER JOIN t_organization c ON a.fsupplyid = c.fitemid
                                            INNER JOIN t_icitem d ON b.fitemid = d.fitemid
                                            INNER JOIN t_measureunit e ON d.funitid = e.fmeasureunitid
                                  WHERE     a.fdate BETWEEN '********' AND '########'
                                            AND ftrantype = '21'
                                            AND fcancellation = 0
                                  GROUP BY  a.fdate ,
                                            b.fcontractbillno ,
                                            a.fbillno ,
                                            a.fsupplyid ,
                                            c.fnumber ,
                                            c.fname ,
                                            d.fmodel ,
                                            d.fname ,
                                            e.fname ,
                                            b.fnote
                                ) v
----���۳��ⵥ        
                      UNION ALL
                      SELECT    a.ffincdate fdate ,
                                ' ' fcontractbillno ,
                                a.fnumber fbillno ,
                                a.fcustomer fcustid ,
                                b.fnumber fcustnumber ,
                                b.fname fcustname ,
                                0 beginbalance ,
                                0 sellprice ,
                                0 sellqty ,
                                0 sellamount ,
                                ' ' fmodel ,
                                ' ' fitemname ,
                                ' ' funitname ,
                                a.famount frecieved ,
                                0 fdiscount ,
                                fexplanation fnote
                      FROM      t_rp_contact a
                                INNER JOIN t_organization b ON a.fcustomer = b.fitemid
                      WHERE     a.fdate BETWEEN '********' AND '########'
                                AND ftype = '5'
                                AND frp = '1'
---�տ(�˿)
                      UNION ALL
                      SELECT    a.ffincdate fdate ,
                                ' ' fcontractbillno ,
                                a.fnumber fbillno ,
                                a.fcustomer fcustid ,
                                b.fnumber fcustnumber ,
                                b.fname fcustname ,
                                0 beginbalance ,
                                0 sellprice ,
                                0 sellqty ,
                                0 sellamount ,
                                ' ' fmodel ,
                                ' ' fitemname ,
                                ' ' funitname ,
                                0 frecieved ,
                                a.famount fdiscount ,
                                fexplanation fnote
                      FROM      t_rp_contact a
                                INNER JOIN t_organization b ON a.fcustomer = b.fitemid
                      WHERE     a.fdate BETWEEN '********' AND '########'
                                AND ftype = '1'
                                AND frp = '1'
---����Ӧ�յ�
                    ) v
          WHERE     fcustnumber BETWEEN '*CustNo*' AND '#CustNo#'
        ) T
        LEFT JOIN ( SELECT  a.fdate fdate ,
                            ' ' fcontractbillno ,
                            ' ' fbillno ,
                            a.fsupplyid fcustid ,
                            c.fnumber fcustnumber ,
                            c.fname fcustname ,
                            SUM(b.fconsignamount) AS beginbalance ,
                            0 sellprice ,
                            0 sellqty ,
                            0 sellamount ,
                            ' ' fmodel ,
                            ' ' fitemname ,
                            ' ' funitname ,
                            0 frecieved ,
                            0 fdiscount ,
                            ' ' fnote
                    FROM    icstockbill a
                            INNER JOIN icstockbillentry b ON a.finterid = b.finterid
                            INNER JOIN t_organization c ON a.fsupplyid = c.fitemid
                            INNER JOIN t_icitem d ON b.fitemid = d.fitemid
                            INNER JOIN t_measureunit e ON d.funitid = e.fmeasureunitid
                            LEFT JOIN icsale f ON a.frelateinvoiceid = f.finterid
                    WHERE   f.fyear = '*fyear*'
                            AND f.fperiod = MONTH('********')
                            AND a.ftrantype = '21'
                            AND a.fcancellation = 0
                            AND a.fdate < '********'
                            AND a.fsalestyle = '102'
                    GROUP BY a.fdate ,
                            a.fsupplyid ,
                            c.fnumber ,
                            c.fname
                  ) Q ON Q.fdate = T.fdate
                         AND Q.fcustnumber = T.fcustnumber
UNION ALL
SELECT  '######## 00:00:01' fdate ,
        fcustnumber ,
        '���ںϼ�' fcustname ,
        ' ' fcontractbillno ,
        ' ' fbillno ,
        ' ' fitemname ,
        ' ' fmodel ,
        ' ' funitname ,
        '��' fnote ,
        SUM(ISNULL(sellqty, 0)) ,
        0 sellprice ,
        SUM(ISNULL(sellamount, 0)) ,
        SUM(ISNULL(frecieved, 0)) ,
        SUM(ISNULL(fdiscount, 0)) ,
        SUM(ISNULL(beginbalance, 0)) + SUM(ISNULL(sellamount, 0))
        - SUM(ISNULL(frecieved, 0)) + SUM(ISNULL(fdiscount, 0))
FROM    ( SELECT    DATEADD(day, -1, '********') fdate ,
                    ' ' fcontractbillno ,
                    ' ' fbillno ,
                    a.fcustomer fcustid ,
                    b.fnumber fcustnumber ,
                    b.fname fcustname ,
                    a.fendbalance beginbalance ,
                    0 sellprice ,
                    0 sellqty ,
                    0 sellamount ,
                    ' ' fmodel ,
                    ' ' fitemname ,
                    ' ' funitname ,
                    0 frecieved ,
                    0 fdiscount ,
                    ' ' fnote
          FROM      t_rp_contactbal AS a
                    INNER JOIN t_organization b ON a.fcustomer = b.fitemid
          WHERE     a.fyear = '*fyear*'
                    AND a.fperiod = MONTH(DATEADD(month, -1, '********'))
                    AND a.frp = '1' 
---�ڳ�����
          UNION ALL
          SELECT    v.fdate fdate ,
                    v.fcontractbillno ,
                    v.fbillno ,
                    v.fcustid ,
                    v.fcustnumber ,
                    v.fcustname ,
                    0 beginbalance ,
                    v.sellprice ,
                    v.sellqty ,
                    v.sellamount ,
                    v.fmodel ,
                    v.fitemname ,
                    v.funitname ,
                    0 frecieved ,
                    0 fdiscount ,
                    v.fnote
          FROM      ( SELECT    a.fdate fdate ,
                                b.fcontractbillno ,
                                a.fbillno ,
                                a.fsupplyid fcustid ,
                                c.fnumber fcustnumber ,
                                c.fname fcustname ,
                                SUM(b.fqty) sellqty ,
                                SUM(b.fconsignamount) sellamount ,
                                SUM(b.fconsignamount) / SUM(b.fqty) sellprice ,
                                d.fmodel ,
                                d.fname fitemname ,
                                e.fname funitname ,
                                b.fnote fnote
                      FROM      icstockbill a
                                INNER JOIN icstockbillentry b ON a.finterid = b.finterid
                                INNER JOIN t_organization c ON a.fsupplyid = c.fitemid
                                INNER JOIN t_icitem d ON b.fitemid = d.fitemid
                                INNER JOIN t_measureunit e ON d.funitid = e.fmeasureunitid
                      WHERE     a.fdate BETWEEN '********' AND '########'
                                AND ftrantype = '21'
                                AND fcancellation = 0
                      GROUP BY  a.fdate ,
                                b.fcontractbillno ,
                                a.fbillno ,
                                a.fsupplyid ,
                                c.fnumber ,
                                c.fname ,
                                d.fmodel ,
                                d.fname ,
                                e.fname ,
                                b.fnote
                    ) v
---���۳��ⵥ
          UNION ALL
          SELECT    a.ffincdate fdate ,
                    ' ' fcontractbillno ,
                    a.fnumber fbillno ,
                    a.fcustomer fcustid ,
                    b.fnumber fcustnumber ,
                    b.fname fcustname ,
                    0 beginbalance ,
                    0 sellprice ,
                    0 sellqty ,
                    0 sellamount ,
                    ' ' fmodel ,
                    ' ' fitemname ,
                    ' ' funitname ,
                    a.famount frecieved ,
                    0 fdiscount ,
                    fexplanation fnote
          FROM      t_rp_contact a
                    INNER JOIN t_organization b ON a.fcustomer = b.fitemid
          WHERE     a.fdate BETWEEN '********' AND '########'
                    AND ftype = '5'
                    AND frp = '1'
          UNION ALL
          SELECT    a.fdate fdate ,
                    b.fcontractbillno ,
                    a.fbillno ,
                    a.fsupplyid fcustid ,
                    c.fnumber fcustnumber ,
                    c.fname fcustname ,
                    b.fconsignamount beginbalance ,
                    b.fconsignprice sellprice ,
                    b.fqty sellqty ,
                    0 sellamount ,
                    d.fmodel ,
                    d.fname fitemname ,
                    e.fname funitname ,
                    0 frecieved ,
                    0 fdiscount ,
                    b.fnote fnote
          FROM      icstockbill a
                    INNER JOIN icstockbillentry b ON a.finterid = b.finterid
                    INNER JOIN t_organization c ON a.fsupplyid = c.fitemid
                    INNER JOIN t_icitem d ON b.fitemid = d.fitemid
                    INNER JOIN t_measureunit e ON d.funitid = e.fmeasureunitid
                    LEFT JOIN icsale f ON a.frelateinvoiceid = f.finterid
          WHERE     f.fyear = '*fyear*'
                    AND f.fperiod = MONTH('********')
                    AND a.ftrantype = '21'
                    AND a.fcancellation = 0
                    AND a.fdate < '********'
                    AND a.fsalestyle = '102' 
---f.fsettledate,f.fyear,f.fperiod f.fsettledate<'********'
----�����տ����·������������տ����Ʒ��

---�տ
          UNION ALL
          SELECT    a.ffincdate fdate ,
                    ' ' fcontractbillno ,
                    a.fnumber fbillno ,
                    a.fcustomer fcustid ,
                    b.fnumber fcustnumber ,
                    b.fname fcustname ,
                    0 beginbalance ,
                    0 sellprice ,
                    0 sellqty ,
                    0 sellamount ,
                    ' ' fmodel ,
                    ' ' fitemname ,
                    ' ' funitname ,
                    0 frecieved ,
                    a.famount fdiscount ,
                    fexplanation fnote
          FROM      t_rp_contact a
                    INNER JOIN t_organization b ON a.fcustomer = b.fitemid
          WHERE     a.fdate BETWEEN '********' AND '########'
                    AND ftype = '1'
                    AND frp = '1'
---����Ӧ�յ�
        ) v
WHERE   fcustnumber BETWEEN '*CustNo*' AND '#CustNo#'
GROUP BY fcustnumber
ORDER BY --fcustnumber ,
        T.fdate 
       -- beginbalance 
       --DESC

