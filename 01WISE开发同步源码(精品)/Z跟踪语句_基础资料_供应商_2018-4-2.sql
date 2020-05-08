SELECT  *
FROM    t_TableDescription
WHERE   FDescription LIKE '%供应商%'
SELECT  *
FROM    t_FieldDescription
WHERE   FTableID = 6
ORDER BY FFieldName

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
          39074 ,
          2 ,
          '测试供应商' ,
          '9.1' ,
          '1' ,
          '9.1' ,
          1 ,
          'D0C5E725-4EF9-480A-ABD6-3A2192E26053' ,
          0
        )

INSERT  INTO t_Supplier
        ( FHelpCode ,
          FShortName ,
          FAddress ,
          FStatus ,
          FRegionID ,
          FTrade ,
          FContact ,
          FPhone ,
          FMobilePhone ,
          FFax ,
          FPostalCode ,
          FEmail ,
          FBank ,
          FAccount ,
          FTaxNum ,
          FValueAddRate ,
          FCountry ,
          FProvinceID ,
          FCityID ,
          Fcorperate ,
          FDiscount ,
          FTypeID ,
          FPOMode ,
          FVMIStockID ,
          FStockIDAssignee ,
          FBr ,
          FRegmark ,
          FLicence ,
          FCyID ,
          FSetID ,
          FAPAccountID ,
          FPreAcctID ,
          FOtherAPAcctID ,
          FPayTaxAcctID ,
          FARAccountID ,
          FPreARAcctID ,
          FOtherARAcctID ,
          FfavorPolicy ,
          Fdepartment ,
          Femployee ,
          FlastTradeDate ,
          FlastTradeAmount ,
          FlastRPAmount ,
          FmaxDealAmount ,
          FminForeReceiveRate ,
          FCreditDays ,
          FNameEN ,
          FAddrEn ,
          FCIQCode ,
          FRegion ,
          FManageType ,
          FRegsterDate ,
          FAbateDate ,
          FSupplyGrade ,
          FSupplyType ,
          FCompanyType ,
          FAutoCreateMR ,
          FAutoValidateOrderFlag ,
          FSupplierCoroutineFlag ,
          FAPFrozenFlag ,
          FShortNumber ,
          FNumber ,
          FName ,
          FParentID ,
          FItemID
        )
VALUES  ( NULL ,
          NULL ,
          NULL ,
          1072 ,
          0 ,
          0 ,
          NULL ,
          NULL ,
          NULL ,
          NULL ,
          NULL ,
          NULL ,
          NULL ,
          NULL ,
          NULL ,
          '0' ,
          NULL ,
          0 ,
          0 ,
          NULL ,
          '0' ,
          0 ,
          0 ,
          0 ,
          0 ,
          0 ,
          NULL ,
          NULL ,
          0 ,
          0 ,
          0 ,
          0 ,
          0 ,
          0 ,
          0 ,
          0 ,
          0 ,
          NULL ,
          0 ,
          0 ,
          '2006-08-14 00:00:00' ,
          '118360' ,
          '0' ,
          '0' ,
          '1' ,
          0 ,
          NULL ,
          NULL ,
          NULL ,
          0 ,
          0 ,
          NULL ,
          '2100-12-31 00:00:00' ,
          0 ,
          0 ,
          0 ,
          0 ,
          0 ,
          0 ,
          0 ,
          '1' ,
          '9.1' ,
          '测试供应商' ,
          39074 ,
          39075
        )


INSERT  INTO t_ItemRight
        ( FTypeID ,
          FUserID ,
          FItemID
        )
        SELECT  fitemclassid ,
                fuserid ,
                39075
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
          '新建核算项目:9.1 核算项目类别:供应商' ,
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
          39075 ,
          '2018-04-02 19:28:15' ,
          'administrator' ,
          NULL ,
          NULL ,
          NULL ,
          NULL
        )


DELETE  FROM Access_t_Supplier
WHERE   FItemID = 39075
INSERT  INTO Access_t_Supplier
        ( FItemID ,
          FParentIDX ,
          FDataAccessView ,
          FDataAccessEdit ,
          FDataAccessDelete
        )
VALUES  ( 39075 ,
          39074 ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100)) ,
          CONVERT(VARBINARY(7200), REPLICATE(CHAR(255), 100))
        )


DELETE  FROM t_gr_itemcontrol
WHERE   FItemID = 39075
        AND FItemClassID = 8
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
                39075 ,
                FCanUse ,
                FCanAdd ,
                FCanModi ,
                FCanDel
        FROM    t_gr_itemcontrol
        WHERE   FItemID = 39074
                AND FItemClassID = 8

UPDATE  t_Item
SET     FName = FName
WHERE   FItemID = 39075
        AND FItemClassID = 8

