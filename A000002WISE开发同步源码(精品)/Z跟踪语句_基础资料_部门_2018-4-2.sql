SELECT  *
FROM    t_TableDescription
WHERE   FDescription LIKE '%部门%'
SELECT  *
FROM    t_FieldDescription
WHERE   FTableID = 20

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
          '销售一部' ,
          '001' ,
          '001' ,
          '001' ,
          1 ,
          'CDD3F1E8-A896-41B5-B2AA-3CBC148DD7DF' ,
          0
        )

INSERT  INTO t_Department
        ( FManager ,
          FPhone ,
          FFax ,
          FDProperty ,
          FIsCreditMgr ,
          FAcctID ,
          FNote ,
          FCostAccountType ,
          FOtherARAcctID ,
          FPreARAcctID ,
          FOtherAPAcctID ,
          FPreAPAcctID ,
          FIsVDept ,
          FShortNumber ,
          FNumber ,
          FName ,
          FParentID ,
          FItemID
        )
VALUES  ( 0 ,
          NULL ,
          NULL ,
          1071 ,
          0 ,
          0 ,
          NULL ,
          363 ,
          0 ,
          0 ,
          0 ,
          0 ,
          0 ,
          '001' ,
          '001' ,
          '销售一部' ,
          0 ,
          35609
        )
        
go

--dbo.SpK3_2tab @sName = 't_ItemRight' -- varchar(50)
--dbo.SpK3_2str @sName = 't_ItemRight' -- varchar(50)
--select * from t_ItemRight

INSERT  INTO t_ItemRight
        ( FTypeID ,
          FUserID ,
          FItemID
        )
        SELECT  fitemclassid ,
                fuserid ,
                35609
        FROM    t_useritemclassright
        WHERE   ( ( FUserItemClassRight & 8 ) = 8 )
                AND fitemclassid = 2
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
          '新建核算项目:001 核算项目类别:部门' ,
          'WIN-5579AATH4RN' ,
          '192.168.6.149'
        )
--dbo.SpK3_2tab @sName = 't_BaseProperty' -- varchar(50)
--dbo.SpK3_2str @sName = 't_BaseProperty' -- varchar(50)
--select * from t_BaseProperty

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
          35609 ,
          '2018-04-02 15:05:54' ,
          'administrator' ,
          NULL ,
          NULL ,
          NULL ,
          NULL
        )


--dbo.SpK3_2tab @sName = 'Access_t_Department' -- varchar(50)
--dbo.SpK3_2str @sName = 'Access_t_Department' -- varchar(50)
--select * from Access_t_Department
DELETE  FROM Access_t_Department
WHERE   FItemID = 35609
INSERT  INTO Access_t_Department
        ( FItemID ,
          FParentIDX ,
          FDataAccessView ,
          FDataAccessEdit ,
          FDataAccessDelete
        )
VALUES  ( 35609 ,
          0 ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100))
        )

UPDATE  t_Item
SET     FName = FName
WHERE   FItemID = 35609
        AND FItemClassID = 2

