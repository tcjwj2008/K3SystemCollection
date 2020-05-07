SELECT t1.*
--UPDATE  t1  SET     t1.FSecBegQty = 0 ,        t1.FSecEndQty = 0,        t1.FSecReceive =0,        t1.FSecSend = 0 ,        t1.FSecYtdReceive = 0 ,        t1.FSecYtdSend = 0
FROM    ICBal t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
WHERE   1 = 1
        -- AND t1.FYear = 2019
        --  AND t1.FPeriod = 8
        AND t2.FSecCoefficient > 0
 AND t2.FNumber LIKE '7.1.01.04%'

SELECT t1.*
--UPDATE  t1 SET     t1.FSecBegQty = 0 ,        t1.FSecEndQty =0 ,        t1.FSecReceive =0 ,        t1.FSecSend =0 ,        t1.FSecYtdReceive = 0 ,        t1.FSecYtdSend =0
FROM    ICInvBal t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
WHERE   1 = 1
      --  AND t1.FYear = 2018
      --  AND t1.FPeriod = 8
        AND t2.FSecCoefficient > 0
 AND t2.FNumber LIKE '7.1.01.04%'

SELECT t1.*
--UPDATE  t1 SET     t1.FSecBegQty =0 ,        t1.FSecEndQty = 0 ,        t1.FSecReceive = 0 ,        t1.FSecSend = 0 ,        t1.FSecYtdReceive =0 ,        t1.FSecYtdSend = 0
FROM    POInvBal t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
WHERE   1 = 1
      --    AND t1.FYear = 2018
      --     AND t1.FPeriod = 8
        AND t2.FSecCoefficient > 0 
		AND t2.FNumber LIKE '7.1.01.04%'



SELECT t1.*
--UPDATE  t1 SET     t1.FSecCoefficient =0,        t1.FSecQty = 0,        t1.FSecQtyMust = 0 ,        t1.FSecCommitQty = 0 ,        t1.FSecVWInStockQty = 0 ,        t1.FSecInvoiceQty =0,        t1.FSecQtyActual = 0 ,        t1.FOutSecCommitQty = 0
FROM    ICStockBillEntry t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
      --  INNER JOIN ICStockBill t3 ON t3.FInterID = t1.FInterID
WHERE  --  AND CONVERT(NVARCHAR, t3.FDate, 112) BETWEEN '20180801'  AND     '20180931' 
	    t2.FSecCoefficient > 0
		AND t2.FNumber LIKE '7.1.01.04%'



SELECT t1.* 
--UPDATE  t1 SET     t1.FSecCoefficient = 0 ,        t1.FSecQty = 0 ,        t1.FSecCommitQty = 0 ,        t1.FSecStockQty = 0,        t1.FSecInvoiceQty = 0 ,        t1.FSecDeliveryQty = 0
FROM    POOrderEntry t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
       -- INNER JOIN POOrder t3 ON t3.FInterID = t1.FInterID
WHERE   1 = 1
      --  AND CONVERT(NVARCHAR, t3.FDate, 112) BETWEEN '20180801'
      --                                       AND     '20180931'
        AND t2.FSecCoefficient > 0
			AND t2.FNumber LIKE '7.1.01.04%'


SELECT t1.* 
--UPDATE  t1 SET     t1.FSecCoefficient = 0,        t1.FSecQty = 0 ,        t1.FSecCommitQty = 0 ,        t1.FSecBackQty = 0 ,        t1.FSecConCommitQty = 0 ,        t1.FSecScrapQty = 0 ,        t1.FSecScrapInCommitQty = 0 ,        t1.FSecQtyPass = 0 ,        t1.FSecConPassQty = 0 ,        t1.FSecNotPassQty = 0,        t1.FSecSampleBreakQty = 0 ,        t1.FSecRelateQty =0 ,        t1.FSecQCheckQty = 0
FROM    POInStockEntry t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
       -- INNER JOIN POInStock t3 ON t3.FInterID = t1.FInterID
WHERE   1 = 1
      --  AND CONVERT(NVARCHAR, t3.FDate, 112) BETWEEN '20180801'
     --                                        AND     '20180931'
        AND t2.FSecCoefficient > 0
	AND t2.FNumber LIKE '7.1.01.04%'



--查物料
SELECT FSecUnitID,FSecCoefficient,* FROM T_ICItem  WHERE 1=1  AND 
 FNumber LIKE '7.1.01.04%' 

SELECT t1.* 
--UPDATE  t1 SET  FSecUnitID = 0 ,  FSecCoefficient = 0
FROM    t_ICItemBase t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
WHERE t2.FNumber LIKE '7.1.01.04%'
 
        --5.校对即时库存
EXEC dbo.CheckInventory;

