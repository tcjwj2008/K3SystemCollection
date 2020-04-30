--��ͬ����200����˰���2234

SELECT  FCustomer ,
        dbo.t_RPContract.FContractNo ,
        MAX(t_rpContractEntry.fhtbh) FHTBH ,
        MAX(dbo.t_RPContract.FValiStartDate) AS FValiStartDate ,
        MAX(FValiEndDate) AS FValiEndDate ,
        SUM(dbo.t_rpContractEntry.FQuantity) AS FQuantity ,--�ϼƺ�ͬ����
        MAX(dbo.t_rpContractEntry.FTaxPrice) FTaxPrice  --��ߵ���
FROM    t_RPContract
        INNER JOIN t_rpContractEntry ON t_RPContract.FContractID = t_rpContractEntry.FContractID
        INNER JOIN t_ICItem ON t_ICItem.FItemID = dbo.t_rpContractEntry.FProductID
        INNER JOIN dbo.t_Organization ON t_Organization.FItemID = t_RPContract.FCustomer
WHERE   ( t_ICItem.FNumber LIKE '10.01.%'
          OR t_ICItem.FNumber LIKE '10.03.%'
        )
        AND dbo.t_Organization.FName LIKE '%һ��%'
        AND 1 = 1
        AND fhtbh = 'DFYX202003001-01-3'
        AND CHARINDEX('_', t_RPContract.FContractNo) <= 0
        AND dbo.t_RPContract.Fstatus < 2
        AND byl = '��' --�����벹����
GROUP BY FCustomer ,
        dbo.t_RPContract.FContractNo;
                                                        
                                                        
--��������985.1800000000
                          
                                                    
                                                        
SELECT  FContractBillNo AS FContractNo ,
        SUM(FQty) AS FQTY
FROM    dbo.ICStockBill A ,
        dbo.ICStockBillEntry B
WHERE   A.FInterID = B.FInterID
        AND A.FTranType = 21
        AND A.FCancellation = 0
        AND A.FStatus = 1
        AND B.FContractBillNo = 'DFYX202003001'
GROUP BY B.FContractBillNo;    
                                                 
--��������Ϊ��                                              
                                                 
SELECT  B.FContractBillNo AS FContractNo ,
        SUM(FQty) AS FQTY ,
        SUM(B.FAmount) AS FTAXAMOUNT
FROM    dbo.SEOrder A ,
        dbo.SEOrderEntry B
WHERE   A.FInterID = B.FInterID
        AND A.FCancellation = 0
                                          --  AND A.FStatus = 1
        AND B.FMrpClosed = 0
        AND B.FContractBillNo = 'DFYX202003001'
GROUP BY B.FContractBillNo;
                                                
                                                                         
                                                 
    
    
    
   --����ʽ
   
     --CASE WHEN ( ( ISNULL(d.FQuantity, 0)
     --                                     - ISNULL(e.FQTY, 0)
     --                                      - ISNULL(f.FQTY, 0) ) >= ( ISNULL(d.FQuantity,
     --                                  0) * 0.1 ) )
     --                             THEN ( ISNULL(d.FQuantity, 0)
     --                                    * ISNULL(d.FTaxPrice, 0) * 0.1 )
     --                               ELSE ( ISNULL(d.FQuantity, 0)
     --                                     - ISNULL(e.FQTY, 0)
     --                                    - ISNULL(f.FQTY, 0) )
     --                                         * ISNULL(d.FTaxPrice, 0)
     --                               END AS BeforePay ,   --����
     
     
     
SELECT  FCustomer ,
        dbo.t_RPContract.FContractNo ,
        MAX(t_rpContractEntry.fhtbh) FHTBH ,
        MAX(dbo.t_RPContract.FValiStartDate) AS FValiStartDate ,
        MAX(FValiEndDate) AS FValiEndDate ,
        SUM(dbo.t_rpContractEntry.FQuantity) AS FQuantity ,--�ϼƺ�ͬ����
        MAX(dbo.t_rpContractEntry.FTaxPrice) FTaxPrice  --��ߵ���
FROM    t_RPContract
        INNER JOIN t_rpContractEntry ON t_RPContract.FContractID = t_rpContractEntry.FContractID
        INNER JOIN t_ICItem ON t_ICItem.FItemID = dbo.t_rpContractEntry.FProductID
        INNER JOIN dbo.t_Organization ON t_Organization.FItemID = t_RPContract.FCustomer
WHERE   ( t_ICItem.FNumber LIKE '10.01.%'
          OR t_ICItem.FNumber LIKE '10.03.%'
        )
        AND dbo.t_Organization.FName LIKE '%һ��%'
        AND 1 = 1
        AND FContractNo = 'DFYX202003001'
        AND CHARINDEX('_', t_RPContract.FContractNo) <= 0
        AND dbo.t_RPContract.Fstatus < 2
        AND byl = '��' --�����벹����
GROUP BY FCustomer ,
        dbo.t_RPContract.FContractNo;    
        
        
        --��ͬ����Ϊ��������
        
SELECT  FContractBillNo AS FContractNo ,
        SUM(FQty) AS FQTY
FROM    dbo.ICStockBill A ,
        dbo.ICStockBillEntry B
WHERE   A.FInterID = B.FInterID
        AND A.FTranType = 21
        AND A.FCancellation = 0
        AND A.FStatus = 1
        AND B.FContractBillNo = 'DFYX202003001'
GROUP BY B.FContractBillNo;   
                                                         
                                                         
                                                         --������Ϊ985.1800000000
                                                         
                                                         
SELECT  B.FContractBillNo AS FContractNo ,
        SUM(FQty) AS FQTY ,
        SUM(B.FAmount) AS FTAXAMOUNT
FROM    dbo.SEOrder A ,
        dbo.SEOrderEntry B
WHERE   A.FInterID = B.FInterID
        AND A.FCancellation = 0
                                          --  AND A.FStatus = 1
        AND B.FContractBillNo = 'DFYX202003001'
        AND B.FMrpClosed = 0
GROUP BY B.FContractBillNo;

--������Ϊ��


-------------------------------------------------------------------

/*����

1000-985.18-0=14.82

14.82<1000*0.1

[����]��14.82��2254��33404.2800000001



*/


SELECT  B.FEntrySelfB0180 AS FHTBH ,
        SUM(FQty) AS FQTY
FROM    dbo.ICStockBill A ,
        dbo.ICStockBillEntry B
WHERE   A.FInterID = B.FInterID
        AND A.FTranType = 21
        AND A.FCancellation = 0
        AND A.FStatus = 1
        AND B.FEntrySelfB0180 = 'DFYX202003001-01-3'
GROUP BY B.FEntrySelfB0180;
                                                 
                                                 
                                                 
SELECT  *
FROM    dbo.ICStockBill A ,
        dbo.ICStockBillEntry B
WHERE   A.FInterID = B.FInterID
        AND A.FTranType = 21
       -- AND A.FCancellation = 0
        --AND A.FStatus = 1
        AND  FEntrySelfB0180 LIKE 'DFYX202003001%'
        AND fqty=14.82



GO

dbo.SpK3_2Str @sName = 'ICStockBillEntry' -- varchar(50)



                                                         
                                                         
                                                                                                                          