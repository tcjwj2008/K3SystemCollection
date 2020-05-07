/*
*跟踪单价出错问题*
*/

USE test_yxry  DELETE FROM dbo.ICStockBill WHERE FInterID=1030314
USE test_yxry  DELETE FROM dbo.ICStockBillentry WHERE FInterID=1030314

SELECT  *
FROM    ICStockBill
WHERE   FBillNo IN ( 'XOUT791376', 'XOUT791379' );


SELECT  *
FROM    dbo.ICStockBillEntry
WHERE   FInterID IN ( '1030310', '1030314' );


USE test_yxry
INSERT  INTO ICStockBill
        ( FBrNo ,
          FInterID ,
          FTranType ,
          FDate ,
          FBillNo ,
          FDCStockID ,
          FDeptID ,
          FEmpID ,
          FSupplyID ,
          FFManagerID ,
          FSManagerID ,
          FBillerID ,
          FSaleStyle ,
          FUUID ,
          FBrID ,
          FHeadSelfB0148 ,
          FHeadSelfB0152 ,
          FHeadSelfB0164
        )
VALUES  ( '0' ,
          1030314 ,
          21 ,
          '2019-09-01' ,
          'XOUT791379' ,
          11200 ,
          13593 ,
          8999 ,
          2366 ,
          1203 ,
          1261 ,
          16541 ,
          101 ,
          '{8D00EBEF-4670-4D4D-ADB5-279B092E47B3}' ,
          0 ,
          '漳州好亦鲜食品有限公司' ,
          '' ,
          '云睿系统导入'
        );

INSERT  INTO ICStockBillEntry
        ( FBrNo ,
          FInterID ,
          FEntryID ,
          FItemID ,
          FQty ,
          FUnitID ,
          FAuxQty ,
          FConsignPrice ,
          FConsignAmount ,
          FSecCoefficient ,
          FSecQty ,
          FDCStockID ,
          FEntrySelfB0164 ,
          FChkPassItem
        )
VALUES  ( '0' ,
          1030314 ,
          1 ,
          11132 ,
          1868.1 ,
          123 ,
          1868.1 ,
          36.4 ,
          67998.84 ,
          62.270 ,
          30 ,
          7643 ,
          '67998.84' ,
          1058
        );
        
        
INSERT  INTO ICStockBillEntry
        ( FBrNo ,
          FInterID ,
          FEntryID ,
          FItemID ,
          FQty ,
          FUnitID ,
          FAuxQty ,
          FConsignPrice ,
          FConsignAmount ,
          FSecCoefficient ,
          FSecQty ,
          FDCStockID ,
          FEntrySelfB0164 ,
          FChkPassItem
        )
VALUES  ( '0' ,
          1030314 ,
          2 ,
          11180 ,
          467.9 ,
          123 ,
          467.9 ,
          36.4 ,
          17031.56 ,
          58.487 ,
          8 ,
          7643 ,
          '17031.56' ,
          1058
        );





