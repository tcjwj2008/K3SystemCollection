--联达双计量单位  yLD_K3Data_SecUnit

--        1.SQL 批量更新物料的辅助计量单位和换算率
--        2.SQL 批量更新期初的辅助数量（ICBal和ICInvBal和POInvBal）
--        3.SQL 批量更新本期发生的物流单据的辅助数量
--        4.SQL 批量更新本期发生的非物流单据的辅助数量
--        5.SQL 校对即时库存(收料通知单会影响虚仓库存)


--        1.领料系统增加辅助计量数量
--        2.领料分配的时候进一法(将多余的领料分配到最后一张领料单)
--     ******************************************************************************/  

        --1.批量更新物料的辅助计量单位和换算率
 --		dbo.SpK3_2tab @sName = 'ICBal' -- varchar(50)

 SELECT FSecUnitID,FSecCoefficient FROM T_ICItem    --物料表
--物料属性 1- 外购； 2-自制 或 自制（特性配置） ；3- 委外加工；4- ；5- 虚拟件；6-特征类 ；7- 配置类； 8- 规划类；9- 组装件；
--物料属性 1-无成本对象；2-有成本对象；3-无；5-无；6-无；7-有；8-无；9-无；
SELECT * FROM T_ICItemCore    --核心表，通过FItemID与其它表相关联
SELECT * FROM T_ICItemBase    --基本资料表，包含了规则型号，单位等
SELECT * FROM T_ICItemMaterial    --物流资料表，包含了成本计价方法，核算会计科目
SELECT * FROM T_ICItemPlan    --计划资料表，包含了计划策略和工艺路线等
SELECT * FROM T_ICItemDesign    --设计资料表，包含了净重，毛重，长宽高等
SELECT * FROM T_ICItemStandard    --标准资料表，包含了标准成本，工时等
SELECT * FROM T_ICItemQuality    --质量资料表，检验资料
SELECT * FROM T_Base_ICItemEntrance    --进出口资料表，英文名称，HS编码等
SELECT * FROM T_ICItemCustom ;         --物料所有自定义的字段表
?USE test_YXRY20191006;
UPDATE  t1 SET     FSecUnitID = 0 ,        FSecCoefficient = 0
FROM    T_ICItem t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
	--	WHERE t2.FNumber LIKE '7.1.01.04%'


USE test_YXRY20191006;
UPDATE  t1 SET     FSecUnitID = 0 ,        FSecCoefficient = 0
FROM    t_ICItemBase t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
	--	WHERE t2.FNumber LIKE '7.1.01.04%'
 
 --(323 行受影响)

        --2.批量更新期初的辅助数量(ICBal)
	--	SELECT t1.*
		UPDATE  t1  SET     t1.FSecBegQty = 0 ,        t1.FSecEndQty = 0,        t1.FSecReceive =0,        t1.FSecSend = 0 ,        t1.FSecYtdReceive = 0 ,        t1.FSecYtdSend = 0
FROM    ICBal t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
WHERE   1 = 1
      -- AND t1.FYear = 2019
    --  AND t1.FPeriod = 8
        AND t2.FSecCoefficient > 0
 --AND t2.FNumber LIKE '7.1.01.04%'

        --2.批量更新期初的辅助数量(ICInvBal)
UPDATE  t1
SET     t1.FSecBegQty = 0 ,
        t1.FSecEndQty =0 ,
        t1.FSecReceive =0 ,
        t1.FSecSend =0 ,
        t1.FSecYtdReceive = 0 ,
        t1.FSecYtdSend =0
FROM    ICInvBal t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
WHERE   1 = 1
      --  AND t1.FYear = 2018
      --  AND t1.FPeriod = 8
        AND t2.FSecCoefficient > 0;


        --2.批量更新期初的辅助数量(POInvBal)
UPDATE  t1
SET     t1.FSecBegQty =0 ,
        t1.FSecEndQty = 0 ,
        t1.FSecReceive = 0 ,
        t1.FSecSend = 0 ,
        t1.FSecYtdReceive =0 ,
        t1.FSecYtdSend = 0
FROM    POInvBal t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
WHERE   1 = 1
    --    AND t1.FYear = 2018
   --     AND t1.FPeriod = 8
        AND t2.FSecCoefficient > 0;


        --3.批量更新本期发生的物流单据的辅助数量
UPDATE  t1
SET     t1.FSecCoefficient =0,
        t1.FSecQty = 0,
        t1.FSecQtyMust = 0 ,
        t1.FSecCommitQty = 0 ,
        t1.FSecVWInStockQty = 0 ,
        t1.FSecInvoiceQty =0,
        t1.FSecQtyActual = 0 ,
        t1.FOutSecCommitQty = 0
FROM    ICStockBillEntry t1
        --INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
        INNER JOIN ICStockBill t3 ON t3.FInterID = t1.FInterID
WHERE   1 = 1
      --  AND CONVERT(NVARCHAR, t3.FDate, 112) BETWEEN '20180801'
       --                                      AND     '20180931'
        AND t2.FSecCoefficient > 0;


        --4.批量更新本期发生的非物流单据的辅助数量
UPDATE  t1
SET     t1.FSecCoefficient = 0 ,
        t1.FSecQty = 0 ,
        t1.FSecCommitQty = 0 ,
        t1.FSecStockQty = 0,
        t1.FSecInvoiceQty = 0 ,
        t1.FSecDeliveryQty = 0
FROM    POOrderEntry t1
       -- INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
        INNER JOIN POOrder t3 ON t3.FInterID = t1.FInterID
WHERE   1 = 1
      --  AND CONVERT(NVARCHAR, t3.FDate, 112) BETWEEN '20180801'
      --                                       AND     '20180931'
        AND t2.FSecCoefficient > 0;


UPDATE  t1
SET     t1.FSecCoefficient = 0,
        t1.FSecQty = 0 ,
        t1.FSecCommitQty = 0 ,
        t1.FSecBackQty = 0 ,
        t1.FSecConCommitQty = 0 ,
        t1.FSecScrapQty = 0 ,
        t1.FSecScrapInCommitQty = 0 ,
        t1.FSecQtyPass = 0 ,
        t1.FSecConPassQty = 0 ,
        t1.FSecNotPassQty = 0,
        t1.FSecSampleBreakQty = 0 ,
        t1.FSecRelateQty =0 ,
        t1.FSecQCheckQty = 0
FROM    POInStockEntry t1
        INNER JOIN t_ICItem t2 ON t2.FItemID = t1.FItemID
        INNER JOIN POInStock t3 ON t3.FInterID = t1.FInterID
WHERE   1 = 1
      --  AND CONVERT(NVARCHAR, t3.FDate, 112) BETWEEN '20180801'
     --                                        AND     '20180931'
        AND t2.FSecCoefficient > 0;


        --5.校对即时库存
EXEC dbo.CheckInventory;