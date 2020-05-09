SELECT  *
FROM    t_TableDescription
WHERE   FDescription LIKE '%仓库%'
SELECT  *
FROM    t_FieldDescription
WHERE   FTableID = 9

INSERT  INTO t_Item
        ( FItemClassID ,
          FParentID ,
          FLevel ,
          FName ,
          FNumber ,
          FShortNumber ,
          FFullNumber ,
          FDetail ,
          UUID ,
          FDeleted
        )
VALUES  ( 5 ,
          487 ,
          2 ,
          '测试' ,
          '1.3' ,
          '3' ,
          '1.3' ,
          1 ,
          '5FEEBFC6-4AED-4F81-83EC-1A008626F413' ,
          0
        )

INSERT  INTO t_Stock
        ( FEmpID ,
          FAddress ,
          FPhone ,
          FProperty ,
          FTypeID ,
          FUnderStock ,
          FMRPAvail ,
          FIsStockMgr ,
          FSPGroupID ,
          FIncludeAccounting ,
          FShortNumber ,
          FNumber ,
          FName ,
          FParentID ,
          FItemID
        )
VALUES  ( 0 ,
          NULL ,
          NULL ,
          10 ,
          500 ,
          0 ,
          1 ,
          0 ,
          0 ,
          1 ,
          '3' ,
          '1.3' ,
          '测试' ,
          487 ,
          35499
        )

INSERT  INTO t_ItemRight
        ( FTypeID ,
          FUserID ,
          FItemID
        )
        SELECT  fitemclassid ,
                fuserid ,
                35499
        FROM    t_useritemclassright
        WHERE   ( ( FUserItemClassRight & 8 ) = 8 )
                AND fitemclassid = 5
                AND fuserid <> 16394

INSERT  INTO t_Log
        ( FDate ,
          FUserID ,
          FFunctionID ,
          FStatement ,
          FDescription ,
          FMachineName ,
          FIPAddress
        )
VALUES  ( GETDATE() ,
          16394 ,
          'A00701' ,
          5 ,
          '新建核算项目:1.3 核算项目类别:仓库' ,
          'WIN-5579AATH4RN' ,
          '192.168.6.149'
        )

INSERT  INTO t_BaseProperty
        ( FTypeID ,
          FItemID ,
          FCreateDate ,
          FCreateUser ,
          FLastModDate ,
          FLastModUser ,
          FDeleteDate ,
          FDeleteUser
        )
VALUES  ( 3 ,
          35499 ,
          '2018-04-01 00:35:00' ,
          'administrator' ,
          NULL ,
          NULL ,
          NULL ,
          NULL
        )

DELETE  FROM Access_t_Stock
WHERE   FItemID = 35499
INSERT  INTO Access_t_Stock
        ( FItemID ,
          FParentIDX ,
          FDataAccessView ,
          FDataAccessEdit ,
          FDataAccessDelete
        )
VALUES  ( 35499 ,
          487 ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100))
        )

DELETE  FROM t_gr_itemcontrol
WHERE   FItemID = 35499
        AND FItemClassID = 5
        
        
      --spk3_2tab @sname='t_gr_itemcontrol'
      --select * from t_gr_itemcontrol

INSERT  INTO t_gr_itemcontrol
        ( FFrameWorkID ,
          FItemClassID ,
          FItemID ,
          FCanUse ,
          FCanAdd ,
          FCanModi ,
          FCanDel
        )
        SELECT  FFrameWorkID ,
                FItemClassID ,
                35499 ,
                FCanUse ,
                FCanAdd ,
                FCanModi ,
                FCanDel
        FROM    t_gr_itemcontrol
        WHERE   FItemID = 487
                AND FItemClassID = 5

UPDATE  t_Item
SET     FName = FName
WHERE   FItemID = 35499
        AND FItemClassID = 5