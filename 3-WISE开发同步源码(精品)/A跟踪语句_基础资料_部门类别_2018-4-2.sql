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
VALUES  ( 2 ,
          0 ,
          1 ,
          '测试' ,
          '02' ,
          '02' ,
          '02' ,
          0 ,
          '5F4BA51A-E9C5-49C2-B2E3-B0FC8447479C' ,
          0
        )

--dbo.SpK3_2tab @sName = 't_Item' -- varchar(50)
--dbo.SpK3_2str @sName = 't_Item' -- varchar(50)
--select * from t_Item


INSERT  INTO t_ItemRight
        ( FTypeID ,
          FUserID ,
          FItemID
        )
        SELECT  fitemclassid ,
                fuserid ,
                35607
        FROM    t_useritemclassright
        WHERE   ( ( FUserItemClassRight & 8 ) = 8 )
                AND fitemclassid = 2
                AND fuserid <> 16394


--dbo.SpK3_2tab @sName = 't_useritemclassright' -- varchar(50)
--dbo.SpK3_2str @sName = 't_useritemclassright' -- varchar(50)
--select * from t_useritemclassright


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
          '新建核算项目:02 核算项目类别:部门' ,
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
          35607 ,
          '2018-04-02 10:33:50' ,
          'administrator' ,
          NULL ,
          NULL ,
          NULL ,
          NULL
        )

DELETE  FROM Access_t_Department
WHERE   FItemID = 35607
INSERT  INTO Access_t_Department
        ( FItemID ,
          FParentIDX ,
          FDataAccessView ,
          FDataAccessEdit ,
          FDataAccessDelete
        )
VALUES  ( 35607 ,
          0 ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100))
        )

UPDATE  t_Item
SET     FName = FName
WHERE   FItemID = 35607
        AND FItemClassID = 2