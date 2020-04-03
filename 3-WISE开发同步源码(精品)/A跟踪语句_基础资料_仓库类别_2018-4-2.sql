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
          0 ,
          1 ,
          '测试' ,
          '999' ,
          '999' ,
          '999' ,
          0 ,
          'A26C534A-9871-4EBF-A172-D6C6C17F91B6' ,
          0
        )

INSERT  INTO t_ItemRight
        ( FTypeID ,
          FUserID ,
          FItemID
        )
        SELECT  fitemclassid ,
                fuserid ,
                35500
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
          '新建核算项目:999 核算项目类别:仓库' ,
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
          35500 ,
          '2018-04-01 23:15:10' ,
          'administrator' ,
          NULL ,
          NULL ,
          NULL ,
          NULL
        )
--spk3_2tab @sname='Access_t_Stock'
DELETE  FROM Access_t_Stock
WHERE   FItemID = 35500
INSERT  INTO Access_t_Stock
        ( FItemID ,
          FParentIDX ,
          FDataAccessView ,
          FDataAccessEdit ,
          FDataAccessDelete
        )
VALUES  ( 35500 ,
          0 ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100))
        )


UPDATE  t_Item
SET     FName = FName
WHERE   FItemID = 35500
        AND FItemClassID = 5