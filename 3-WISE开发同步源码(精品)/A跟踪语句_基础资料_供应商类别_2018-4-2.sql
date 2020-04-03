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
VALUES  ( 8 ,
          0 ,
          1 ,
          '测试' ,
          '9' ,
          '9' ,
          '9' ,
          0 ,
          'F3AACF5D-5C50-437B-B3D8-3C89AA17454A' ,
          0
        )
        
        
        

INSERT  INTO t_ItemRight
        ( FTypeID ,
          FUserID ,
          FItemID
        )
        SELECT  fitemclassid ,
                fuserid ,
                39074
        FROM    t_useritemclassright
        WHERE   ( ( FUserItemClassRight & 8 ) = 8 )
                AND fitemclassid = 8
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
          '新建核算项目:9 核算项目类别:供应商' ,
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
          39074 ,
          '2018-04-02 19:16:28' ,
          'administrator' ,
          NULL ,
          NULL ,
          NULL ,
          NULL
        )

DELETE  FROM Access_t_Supplier
WHERE   FItemID = 39074
INSERT  INTO Access_t_Supplier
        ( FItemID ,
          FParentIDX ,
          FDataAccessView ,
          FDataAccessEdit ,
          FDataAccessDelete
        )
VALUES  ( 39074 ,
          0 ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100))
        )


UPDATE  t_Item
SET     FName = FName
WHERE   FItemID = 39074
        AND FItemClassID = 8