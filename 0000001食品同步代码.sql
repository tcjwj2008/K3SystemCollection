
/******
食品账套同步代码
***/

---部署bos开发
/**Begin 新单据模板数据脚本，名称 同步数据配置表    Script Date: 2013-09-06 **/

GO
SELECT *
FROM ICClassType
WHERE FID = 200000014;

/****** Object:Data   单据描述：ICClassType    Script Date: 2013-09-06 ******/

--SELECT * FROM ICClassType WHERE FID=200000003
DELETE ICClassType
WHERE FID = 200000014;
GO
INSERT INTO ICClassType
(FID,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FShowIndex,
 FTableName,
 FShowType,
 FTemplateID,
 FImgID,
 FModel,
 FLogic,
 FBillWidth,
 FBillHeight,
 FMenuControl,
 FFunctionID,
 FFilter,
 FBillTypeID,
 FIsManageBillNo,
 FBillNoKey,
 FEntryCount,
 FLayerCount,
 FLayerNames,
 FPrimaryKey,
 FEPrimaryKey,
 FClassTypeKey,
 FIndexKey,
 FObjectType,
 FObjectID,
 FGroupIDView,
 FGroupIDManage,
 FComponentExt,
 FBillNoManageType,
 FAccessoryTypeID,
 FControl,
 FTimeStamp,
 FExtBaseDataAccess
) --,fpropertyext,FPGUID,FEGUID
VALUES
(200000014,
 '同步数据配置表',
 '基礎資料200000014',
 'Master Data200000014',
 0,
 't_YXSet',
 0,
 200000014,
 '',
 0,
 3,
 11895,
 3885,
 '',
 23,
 '',
 1,
 0,
 '',
 0,
 1,
 'CHS=;CHT=;EN=',
 'FID',
 'FEntryID',
 'FClassTypeID',
 'FIndex',
 4100,
 200000014,
 2101,
 2102,
 '',
 1,
 80000294,
 1075775667,
 NULL,
 ''
); --,'','FPGUID','FEGUID'
GO

/****** Object:Data   单据分录描述：ICClassTypeEntry    Script Date: 2013-09-06 ******/

DELETE ICClassTypeEntry
WHERE FParentID = 200000014;
GO
INSERT INTO ICClassTypeEntry
(FIndex,
 FParentID,
 FTableName,
 FLeft,
 FTop,
 FWidth,
 FHeight,
 FLayer,
 FEntryType,
 FTabIndex,
 FMustInput,
 FKeyField,
 FDescription_CHS,
 FDescription_CHT,
 FDescription_EN,
 FFilter,
 FUserDefine,
 FContainer
) --,FCanSort,FParentEntry
VALUES
(1,
 200000014,
 't_YXSet',
 0,
 2190,
 6000,
 4740,
 0,
 0,
 0,
 1,
 '',
 '',
 '',
 '',
 '',
 1,
 ''
); --,1,1
GO
INSERT INTO ICClassTypeEntry
(FIndex,
 FParentID,
 FTableName,
 FLeft,
 FTop,
 FWidth,
 FHeight,
 FLayer,
 FEntryType,
 FTabIndex,
 FMustInput,
 FKeyField,
 FDescription_CHS,
 FDescription_CHT,
 FDescription_EN,
 FFilter,
 FUserDefine,
 FContainer
) --,FCanSort,FParentEntry
VALUES
(2,
 200000014,
 't_YXSetEntry',
 2775,
 5010,
 870,
 645,
 0,
 0,
 5,
 1,
 '',
 '',
 '',
 '',
 '',
 1,
 ''
); --,1,1
GO

/****** Object:Data   单据模板字段描述：ICClassTableInfo    Script Date: 2013-09-06 ******/

DELETE ICClassTableInfo
WHERE FClassTypeID = 200000014;
GO
INSERT INTO ICClassTableInfo
(FClassTypeID,
 FPage,
 FCaption_CHS,
 FCaption_CHT,
 FCaption_EN,
 FKey,
 FFieldName,
 FTableName,
 FTableNameAs,
 FListIndex,
 FListClassName,
 FVisible,
 FEnable,
 FNeedSave,
 FMustInput,
 FCtlType,
 FProperty,
 FLookUpType,
 FLookUpClassID,
 FLookUpList,
 FSRCFieldName,
 FSRCTableName,
 FSRCTableNameAs,
 FDSPFieldName,
 FFNDFieldName,
 FValueLocation,
 FFilter,
 FFilterGroup,
 FValueType,
 FDspColType,
 FEditlen,
 FValuePrecision,
 FSaveRule,
 FDefValue,
 FAction,
 FUserDefine,
 FNote,
 FKeyWord,
 FLeft,
 FTop,
 FHeight,
 FWidth,
 FCondition,
 FTabIndex,
 FLock,
 FSum,
 FPrec,
 FScale,
 FLayer,
 FLoadAction,
 FUnControl,
 FFont,
 FSourceType,
 FSubKey,
 FParentKey,
 FConditionExt,
 FFrameBorder,
 FFrameBorderColor,
 FLabelWidth,
 FLabelColor,
 FTextColor,
 FIsF7,
 FContainer,
 FStyle
)
VALUES
(200000014,
 1,
 '代码',
 '代碼',
 'Code',
 'FNumber',
 'FNumber',
 't_YXSet',
 '',
 2,
 1,
 2047,
 1,
 1,
 0,
 1,
 '',
 0,
 0,
 '',
 '',
 '',
 '',
 '',
 '',
 1,
 '',
 '',
 167,
 500,
 255,
 255,
 '',
 '',
 'SetEquation{FParentNumber}',
 1,
 '代码',
 '',
 610,
 1125,
 350,
 2200,
 '0,13',
 0,
 24,
 0,
 0,
 0,
 0,
 '',
 8193,
 '',
 0,
 '',
 '',
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 '',
 0
);
GO
INSERT INTO ICClassTableInfo
(FClassTypeID,
 FPage,
 FCaption_CHS,
 FCaption_CHT,
 FCaption_EN,
 FKey,
 FFieldName,
 FTableName,
 FTableNameAs,
 FListIndex,
 FListClassName,
 FVisible,
 FEnable,
 FNeedSave,
 FMustInput,
 FCtlType,
 FProperty,
 FLookUpType,
 FLookUpClassID,
 FLookUpList,
 FSRCFieldName,
 FSRCTableName,
 FSRCTableNameAs,
 FDSPFieldName,
 FFNDFieldName,
 FValueLocation,
 FFilter,
 FFilterGroup,
 FValueType,
 FDspColType,
 FEditlen,
 FValuePrecision,
 FSaveRule,
 FDefValue,
 FAction,
 FUserDefine,
 FNote,
 FKeyWord,
 FLeft,
 FTop,
 FHeight,
 FWidth,
 FCondition,
 FTabIndex,
 FLock,
 FSum,
 FPrec,
 FScale,
 FLayer,
 FLoadAction,
 FUnControl,
 FFont,
 FSourceType,
 FSubKey,
 FParentKey,
 FConditionExt,
 FFrameBorder,
 FFrameBorderColor,
 FLabelWidth,
 FLabelColor,
 FTextColor,
 FIsF7,
 FContainer,
 FStyle
)
VALUES
(200000014,
 1,
 '是否明细',
 '是否明細',
 'Details (Y/N)',
 'FDetail',
 'FDetail',
 't_YXSet',
 '',
 21,
 2,
 0,
 1,
 1,
 1,
 1,
 '',
 0,
 0,
 '',
 '',
 '',
 '',
 '',
 '',
 1,
 '',
 '',
 104,
 500,
 255,
 48,
 '',
 '',
 '',
 1,
 '是否明细',
 'DETAIL',
 240,
 120,
 350,
 0,
 '-1',
 1,
 24,
 0,
 0,
 0,
 0,
 '',
 8193,
 '',
 0,
 '',
 '',
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 '',
 0
);
GO
INSERT INTO ICClassTableInfo
(FClassTypeID,
 FPage,
 FCaption_CHS,
 FCaption_CHT,
 FCaption_EN,
 FKey,
 FFieldName,
 FTableName,
 FTableNameAs,
 FListIndex,
 FListClassName,
 FVisible,
 FEnable,
 FNeedSave,
 FMustInput,
 FCtlType,
 FProperty,
 FLookUpType,
 FLookUpClassID,
 FLookUpList,
 FSRCFieldName,
 FSRCTableName,
 FSRCTableNameAs,
 FDSPFieldName,
 FFNDFieldName,
 FValueLocation,
 FFilter,
 FFilterGroup,
 FValueType,
 FDspColType,
 FEditlen,
 FValuePrecision,
 FSaveRule,
 FDefValue,
 FAction,
 FUserDefine,
 FNote,
 FKeyWord,
 FLeft,
 FTop,
 FHeight,
 FWidth,
 FCondition,
 FTabIndex,
 FLock,
 FSum,
 FPrec,
 FScale,
 FLayer,
 FLoadAction,
 FUnControl,
 FFont,
 FSourceType,
 FSubKey,
 FParentKey,
 FConditionExt,
 FFrameBorder,
 FFrameBorderColor,
 FLabelWidth,
 FLabelColor,
 FTextColor,
 FIsF7,
 FContainer,
 FStyle
)
VALUES
(200000014,
 1,
 '类别',
 '類別',
 'Category',
 'FClassTypeID',
 'FClassTypeID',
 't_YXSet',
 '',
 22,
 2,
 0,
 1,
 1,
 1,
 1,
 '',
 0,
 0,
 '',
 '',
 '',
 '',
 '',
 '',
 1,
 '',
 '',
 231,
 500,
 255,
 48,
 '',
 '',
 '',
 1,
 '类别',
 'CLASSTYPEID',
 240,
 120,
 350,
 0,
 '-1',
 2,
 24,
 0,
 0,
 0,
 0,
 '',
 8193,
 '',
 0,
 '',
 '',
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 '',
 0
);
GO
INSERT INTO ICClassTableInfo
(FClassTypeID,
 FPage,
 FCaption_CHS,
 FCaption_CHT,
 FCaption_EN,
 FKey,
 FFieldName,
 FTableName,
 FTableNameAs,
 FListIndex,
 FListClassName,
 FVisible,
 FEnable,
 FNeedSave,
 FMustInput,
 FCtlType,
 FProperty,
 FLookUpType,
 FLookUpClassID,
 FLookUpList,
 FSRCFieldName,
 FSRCTableName,
 FSRCTableNameAs,
 FDSPFieldName,
 FFNDFieldName,
 FValueLocation,
 FFilter,
 FFilterGroup,
 FValueType,
 FDspColType,
 FEditlen,
 FValuePrecision,
 FSaveRule,
 FDefValue,
 FAction,
 FUserDefine,
 FNote,
 FKeyWord,
 FLeft,
 FTop,
 FHeight,
 FWidth,
 FCondition,
 FTabIndex,
 FLock,
 FSum,
 FPrec,
 FScale,
 FLayer,
 FLoadAction,
 FUnControl,
 FFont,
 FSourceType,
 FSubKey,
 FParentKey,
 FConditionExt,
 FFrameBorder,
 FFrameBorderColor,
 FLabelWidth,
 FLabelColor,
 FTextColor,
 FIsF7,
 FContainer,
 FStyle
)
VALUES
(200000014,
 1,
 '父级内码',
 '父級內碼',
 'Parent ISN',
 'FParentID',
 'FParentID',
 't_YXSet',
 '',
 5,
 2,
 0,
 1,
 1,
 1,
 3,
 '',
 0,
 0,
 '',
 '',
 '',
 '',
 '',
 '',
 1,
 '',
 '',
 56,
 500,
 255,
 4,
 '',
 '',
 '',
 1,
 '父级内码',
 'GRPPARENTID',
 0,
 0,
 0,
 0,
 '-1',
 4,
 24,
 0,
 0,
 0,
 0,
 '',
 8193,
 '',
 0,
 '',
 '',
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 '',
 0
);
GO
INSERT INTO ICClassTableInfo
(FClassTypeID,
 FPage,
 FCaption_CHS,
 FCaption_CHT,
 FCaption_EN,
 FKey,
 FFieldName,
 FTableName,
 FTableNameAs,
 FListIndex,
 FListClassName,
 FVisible,
 FEnable,
 FNeedSave,
 FMustInput,
 FCtlType,
 FProperty,
 FLookUpType,
 FLookUpClassID,
 FLookUpList,
 FSRCFieldName,
 FSRCTableName,
 FSRCTableNameAs,
 FDSPFieldName,
 FFNDFieldName,
 FValueLocation,
 FFilter,
 FFilterGroup,
 FValueType,
 FDspColType,
 FEditlen,
 FValuePrecision,
 FSaveRule,
 FDefValue,
 FAction,
 FUserDefine,
 FNote,
 FKeyWord,
 FLeft,
 FTop,
 FHeight,
 FWidth,
 FCondition,
 FTabIndex,
 FLock,
 FSum,
 FPrec,
 FScale,
 FLayer,
 FLoadAction,
 FUnControl,
 FFont,
 FSourceType,
 FSubKey,
 FParentKey,
 FConditionExt,
 FFrameBorder,
 FFrameBorderColor,
 FLabelWidth,
 FLabelColor,
 FTextColor,
 FIsF7,
 FContainer,
 FStyle
)
VALUES
(200000014,
 1,
 '名称',
 '名稱',
 'Name',
 'FName',
 'FName',
 't_YXSet',
 '',
 4,
 1,
 12,
 1,
 1,
 0,
 1,
 '',
 0,
 0,
 '',
 '',
 '',
 '',
 '',
 '',
 1,
 '',
 '',
 167,
 500,
 255,
 255,
 '',
 '',
 'SetEquation{FParentName}',
 1,
 '名称',
 '',
 2695,
 3840,
 350,
 2200,
 '0,13',
 5,
 24,
 0,
 0,
 0,
 0,
 '',
 8193,
 '',
 0,
 '',
 '',
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 '',
 0
);
GO
INSERT INTO ICClassTableInfo
(FClassTypeID,
 FPage,
 FCaption_CHS,
 FCaption_CHT,
 FCaption_EN,
 FKey,
 FFieldName,
 FTableName,
 FTableNameAs,
 FListIndex,
 FListClassName,
 FVisible,
 FEnable,
 FNeedSave,
 FMustInput,
 FCtlType,
 FProperty,
 FLookUpType,
 FLookUpClassID,
 FLookUpList,
 FSRCFieldName,
 FSRCTableName,
 FSRCTableNameAs,
 FDSPFieldName,
 FFNDFieldName,
 FValueLocation,
 FFilter,
 FFilterGroup,
 FValueType,
 FDspColType,
 FEditlen,
 FValuePrecision,
 FSaveRule,
 FDefValue,
 FAction,
 FUserDefine,
 FNote,
 FKeyWord,
 FLeft,
 FTop,
 FHeight,
 FWidth,
 FCondition,
 FTabIndex,
 FLock,
 FSum,
 FPrec,
 FScale,
 FLayer,
 FLoadAction,
 FUnControl,
 FFont,
 FSourceType,
 FSubKey,
 FParentKey,
 FConditionExt,
 FFrameBorder,
 FFrameBorderColor,
 FLabelWidth,
 FLabelColor,
 FTextColor,
 FIsF7,
 FContainer,
 FStyle
)
VALUES
(200000014,
 1,
 '菜单控制',
 '功能表控制',
 'Menu Control',
 'FLogic',
 'FLogic',
 't_YXSet',
 '',
 0,
 2,
 0,
 1,
 0,
 1,
 3,
 '',
 0,
 0,
 '',
 '',
 '',
 '',
 '',
 '',
 1,
 '',
 '',
 56,
 500,
 255,
 4,
 '',
 '',
 '',
 1,
 '内码',
 '',
 240,
 120,
 350,
 0,
 '-1',
 7,
 24,
 0,
 0,
 0,
 0,
 '',
 8193,
 '',
 0,
 '',
 '',
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 '',
 0
);
GO
INSERT INTO ICClassTableInfo
(FClassTypeID,
 FPage,
 FCaption_CHS,
 FCaption_CHT,
 FCaption_EN,
 FKey,
 FFieldName,
 FTableName,
 FTableNameAs,
 FListIndex,
 FListClassName,
 FVisible,
 FEnable,
 FNeedSave,
 FMustInput,
 FCtlType,
 FProperty,
 FLookUpType,
 FLookUpClassID,
 FLookUpList,
 FSRCFieldName,
 FSRCTableName,
 FSRCTableNameAs,
 FDSPFieldName,
 FFNDFieldName,
 FValueLocation,
 FFilter,
 FFilterGroup,
 FValueType,
 FDspColType,
 FEditlen,
 FValuePrecision,
 FSaveRule,
 FDefValue,
 FAction,
 FUserDefine,
 FNote,
 FKeyWord,
 FLeft,
 FTop,
 FHeight,
 FWidth,
 FCondition,
 FTabIndex,
 FLock,
 FSum,
 FPrec,
 FScale,
 FLayer,
 FLoadAction,
 FUnControl,
 FFont,
 FSourceType,
 FSubKey,
 FParentKey,
 FConditionExt,
 FFrameBorder,
 FFrameBorderColor,
 FLabelWidth,
 FLabelColor,
 FTextColor,
 FIsF7,
 FContainer,
 FStyle
)
VALUES
(200000014,
 1,
 '内码',
 '內碼',
 'ISN',
 'FID',
 'FID',
 't_YXSet',
 '',
 0,
 1,
 0,
 1,
 1,
 1,
 3,
 '',
 0,
 0,
 '',
 '',
 '',
 '',
 '',
 '',
 1,
 '',
 '',
 56,
 500,
 255,
 4,
 '',
 '',
 '',
 1,
 '内码',
 'PRIMARY',
 240,
 120,
 350,
 0,
 '-1',
 8,
 24,
 0,
 0,
 0,
 0,
 '',
 8193,
 '',
 0,
 '',
 '',
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 '',
 0
);
GO
INSERT INTO ICClassTableInfo
(FClassTypeID,
 FPage,
 FCaption_CHS,
 FCaption_CHT,
 FCaption_EN,
 FKey,
 FFieldName,
 FTableName,
 FTableNameAs,
 FListIndex,
 FListClassName,
 FVisible,
 FEnable,
 FNeedSave,
 FMustInput,
 FCtlType,
 FProperty,
 FLookUpType,
 FLookUpClassID,
 FLookUpList,
 FSRCFieldName,
 FSRCTableName,
 FSRCTableNameAs,
 FDSPFieldName,
 FFNDFieldName,
 FValueLocation,
 FFilter,
 FFilterGroup,
 FValueType,
 FDspColType,
 FEditlen,
 FValuePrecision,
 FSaveRule,
 FDefValue,
 FAction,
 FUserDefine,
 FNote,
 FKeyWord,
 FLeft,
 FTop,
 FHeight,
 FWidth,
 FCondition,
 FTabIndex,
 FLock,
 FSum,
 FPrec,
 FScale,
 FLayer,
 FLoadAction,
 FUnControl,
 FFont,
 FSourceType,
 FSubKey,
 FParentKey,
 FConditionExt,
 FFrameBorder,
 FFrameBorderColor,
 FLabelWidth,
 FLabelColor,
 FTextColor,
 FIsF7,
 FContainer,
 FStyle
)
VALUES
(200000014,
 1,
 '同步表单名称',
 '下拉清單',
 'Drop-down List',
 'FComboBox',
 'FTableName',
 't_YXSetEntry',
 '',
 2,
 1,
 2047,
 0,
 1,
 1,
 8,
 '',
 0,
 0,
 'VALUELIST{1=同步外购入库单,2=同步采购发票,3=同步付款单,4=同步销售出库单,5=同步销售发票,6=同步收款单,7=同步生产领料单,8=同步产品入库单,9=同步其他入库单,10=同步其他出库单,11=同步记账凭证}',
 '',
 '',
 '',
 '',
 '',
 1,
 '',
 '',
 231,
 500,
 255,
 255,
 '',
 '',
 '',
 1,
 '',
 '',
 3240,
 1200,
 315,
 4275,
 '5',
 29,
 24,
 0,
 0,
 0,
 0,
 '',
 24631,
 '',
 9,
 '',
 '',
 0,
 2,
 0,
 0,
 0,
 0,
 0,
 '',
 0
);
GO
INSERT INTO ICClassTableInfo
(FClassTypeID,
 FPage,
 FCaption_CHS,
 FCaption_CHT,
 FCaption_EN,
 FKey,
 FFieldName,
 FTableName,
 FTableNameAs,
 FListIndex,
 FListClassName,
 FVisible,
 FEnable,
 FNeedSave,
 FMustInput,
 FCtlType,
 FProperty,
 FLookUpType,
 FLookUpClassID,
 FLookUpList,
 FSRCFieldName,
 FSRCTableName,
 FSRCTableNameAs,
 FDSPFieldName,
 FFNDFieldName,
 FValueLocation,
 FFilter,
 FFilterGroup,
 FValueType,
 FDspColType,
 FEditlen,
 FValuePrecision,
 FSaveRule,
 FDefValue,
 FAction,
 FUserDefine,
 FNote,
 FKeyWord,
 FLeft,
 FTop,
 FHeight,
 FWidth,
 FCondition,
 FTabIndex,
 FLock,
 FSum,
 FPrec,
 FScale,
 FLayer,
 FLoadAction,
 FUnControl,
 FFont,
 FSourceType,
 FSubKey,
 FParentKey,
 FConditionExt,
 FFrameBorder,
 FFrameBorderColor,
 FLabelWidth,
 FLabelColor,
 FTextColor,
 FIsF7,
 FContainer,
 FStyle
)
VALUES
(200000014,
 1,
 '指定审核人员',
 '指定审核人员',
 'Drop-down List1',
 'FComboBox1',
 'FChecker',
 't_YXSetEntry',
 '',
 2,
 1,
 2047,
 0,
 1,
 1,
 8,
 '',
 0,
 9999,
 'SQL{ SELECT FUserID,FName  FROM t_user WHERE  1=1}',
 'FUserID',
 't_user',
 't_user1',
 'FName',
 '',
 1,
 '',
 '',
 231,
 500,
 255,
 255,
 '',
 '',
 '',
 1,
 '',
 '',
 8010,
 1170,
 330,
 3195,
 '5',
 30,
 24,
 0,
 0,
 0,
 0,
 '',
 24631,
 '',
 9,
 '',
 '',
 0,
 2,
 0,
 0,
 0,
 0,
 0,
 '',
 0
);
GO
INSERT INTO ICClassTableInfo
(FClassTypeID,
 FPage,
 FCaption_CHS,
 FCaption_CHT,
 FCaption_EN,
 FKey,
 FFieldName,
 FTableName,
 FTableNameAs,
 FListIndex,
 FListClassName,
 FVisible,
 FEnable,
 FNeedSave,
 FMustInput,
 FCtlType,
 FProperty,
 FLookUpType,
 FLookUpClassID,
 FLookUpList,
 FSRCFieldName,
 FSRCTableName,
 FSRCTableNameAs,
 FDSPFieldName,
 FFNDFieldName,
 FValueLocation,
 FFilter,
 FFilterGroup,
 FValueType,
 FDspColType,
 FEditlen,
 FValuePrecision,
 FSaveRule,
 FDefValue,
 FAction,
 FUserDefine,
 FNote,
 FKeyWord,
 FLeft,
 FTop,
 FHeight,
 FWidth,
 FCondition,
 FTabIndex,
 FLock,
 FSum,
 FPrec,
 FScale,
 FLayer,
 FLoadAction,
 FUnControl,
 FFont,
 FSourceType,
 FSubKey,
 FParentKey,
 FConditionExt,
 FFrameBorder,
 FFrameBorderColor,
 FLabelWidth,
 FLabelColor,
 FTextColor,
 FIsF7,
 FContainer,
 FStyle
)
VALUES
(200000014,
 2,
 '内码',
 '內碼',
 'ISN',
 'FID2',
 'FID',
 't_YXSetEntry',
 '',
 0,
 1,
 0,
 1,
 1,
 1,
 3,
 '',
 0,
 0,
 '',
 '',
 '',
 '',
 '',
 '',
 1,
 '',
 '',
 56,
 500,
 255,
 4,
 '',
 '',
 '',
 1,
 '内码',
 'PARENTID',
 240,
 120,
 350,
 0,
 '-1',
 -1,
 24,
 0,
 0,
 0,
 0,
 '',
 8193,
 '',
 0,
 '',
 '',
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 '',
 0
);
GO
INSERT INTO ICClassTableInfo
(FClassTypeID,
 FPage,
 FCaption_CHS,
 FCaption_CHT,
 FCaption_EN,
 FKey,
 FFieldName,
 FTableName,
 FTableNameAs,
 FListIndex,
 FListClassName,
 FVisible,
 FEnable,
 FNeedSave,
 FMustInput,
 FCtlType,
 FProperty,
 FLookUpType,
 FLookUpClassID,
 FLookUpList,
 FSRCFieldName,
 FSRCTableName,
 FSRCTableNameAs,
 FDSPFieldName,
 FFNDFieldName,
 FValueLocation,
 FFilter,
 FFilterGroup,
 FValueType,
 FDspColType,
 FEditlen,
 FValuePrecision,
 FSaveRule,
 FDefValue,
 FAction,
 FUserDefine,
 FNote,
 FKeyWord,
 FLeft,
 FTop,
 FHeight,
 FWidth,
 FCondition,
 FTabIndex,
 FLock,
 FSum,
 FPrec,
 FScale,
 FLayer,
 FLoadAction,
 FUnControl,
 FFont,
 FSourceType,
 FSubKey,
 FParentKey,
 FConditionExt,
 FFrameBorder,
 FFrameBorderColor,
 FLabelWidth,
 FLabelColor,
 FTextColor,
 FIsF7,
 FContainer,
 FStyle
)
VALUES
(200000014,
 2,
 '名称',
 '名稱',
 'Name',
 'FParentName',
 'FName',
 't_YXSetEntry',
 '',
 4,
 1,
 0,
 1,
 1,
 0,
 1,
 '',
 0,
 0,
 '',
 '',
 '',
 '',
 '',
 '',
 1,
 '',
 '',
 167,
 500,
 255,
 255,
 '',
 '',
 '',
 1,
 '名称',
 '',
 4435,
 840,
 350,
 2200,
 '-1',
 -1,
 24,
 0,
 0,
 0,
 0,
 '',
 8193,
 '',
 0,
 '',
 '',
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 '',
 0
);
GO
INSERT INTO ICClassTableInfo
(FClassTypeID,
 FPage,
 FCaption_CHS,
 FCaption_CHT,
 FCaption_EN,
 FKey,
 FFieldName,
 FTableName,
 FTableNameAs,
 FListIndex,
 FListClassName,
 FVisible,
 FEnable,
 FNeedSave,
 FMustInput,
 FCtlType,
 FProperty,
 FLookUpType,
 FLookUpClassID,
 FLookUpList,
 FSRCFieldName,
 FSRCTableName,
 FSRCTableNameAs,
 FDSPFieldName,
 FFNDFieldName,
 FValueLocation,
 FFilter,
 FFilterGroup,
 FValueType,
 FDspColType,
 FEditlen,
 FValuePrecision,
 FSaveRule,
 FDefValue,
 FAction,
 FUserDefine,
 FNote,
 FKeyWord,
 FLeft,
 FTop,
 FHeight,
 FWidth,
 FCondition,
 FTabIndex,
 FLock,
 FSum,
 FPrec,
 FScale,
 FLayer,
 FLoadAction,
 FUnControl,
 FFont,
 FSourceType,
 FSubKey,
 FParentKey,
 FConditionExt,
 FFrameBorder,
 FFrameBorderColor,
 FLabelWidth,
 FLabelColor,
 FTextColor,
 FIsF7,
 FContainer,
 FStyle
)
VALUES
(200000014,
 2,
 '代码',
 '代碼',
 'Code',
 'FParentNumber',
 'FNumber',
 't_YXSetEntry',
 '',
 2,
 1,
 0,
 1,
 1,
 0,
 1,
 '',
 0,
 0,
 '',
 '',
 '',
 '',
 '',
 '',
 1,
 '',
 '',
 167,
 500,
 255,
 255,
 '',
 '',
 '',
 1,
 '代码',
 '',
 3655,
 300,
 350,
 2200,
 '-1',
 -1,
 24,
 0,
 0,
 0,
 0,
 '',
 8193,
 '',
 0,
 '',
 '',
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 '',
 0
);
GO

/****** Object:Data   单据模板通用控件描述：ICClassCtl    Script Date: 2013-09-06 ******/

DELETE ICClassCtl
WHERE FClassTypeID = 200000014;
GO

/****** Object:Data   单据多布局列表：ICClassLayout    Script Date: 2013-09-06 ******/

--Delete ICClassLayout WHERE FClassTypeID = 200000014
GO

/****** Object:Data   单据多布局明细：ICClassTableInfoLayout    Script Date: 2013-09-06 ******/

--Delete ICClassTableInfoLayout WHERE FClassTypeID = 200000014
GO

/****** Object:Data   单据多布局通用控件明细：ICClassCtlLayout    Script Date: 2013-09-06 ******/

--Delete ICClassCtlLayout WHERE FClassTypeID = 200000014
GO

/****** Object:Data   单据多布局的Page明细：ICClassBillEntryLayout    Script Date: 2013-09-06 ******/

--Delete ICClassBillEntryLayout WHERE FClassTypeID = 200000014
GO

/****** Object:Data   单据模板单据布局控件描述：ICClassEntryEditorLayout    Script Date: 2013-09-06 ******/

--Delete ICClassEntryEditorLayout WHERE FClassTypeID = 200000014 and FLayoutID = 0
GO

/****** Object:Data   序时簿综合查询设置主关系表：icCLassUnionQuery    Script Date: 2013-09-06 ******/

--DELETE icCLassUnionQuery WHERE FSourClassTypeID=200000014
GO

/****** Object:Data   序时簿综合查询设置配置表：icCLassUnionQueryEntry    Script Date: 2013-09-06 ******/

--DELETE icCLassUnionQueryEntry WHERE FSourClassTypeID=200000014
GO

/****** Object:Data   单据权限类弄表：t_ObjectAccessType    Script Date: 2013-09-06 ******/

----Delete t_ObjectAccessType WHERE FObjectType=4100 And FObjectID =200000014
--GO
--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000014,1,2097152,1048576,'查看','查看','查看','View','查看','View') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000014,2,131072,3145728,'新增','新增','新增','New','新增','New') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000014,3,65536,3145728,'删除','删除','刪除','Delete','刪除','Delete') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000014,4,4194304,3145728,'修改','修改','修改','Edit','修改','Edit') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000014,5,64,3145728,'禁用','禁用','禁用','Disable','禁用','Disable') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000014,6,16,3145728,'引出内部数据','引出内部数据','引出內部資料','Export Internal Data','引出內部資料','Export Internal Data') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000014,7,16384,0,'导出单据模板','导出单据模板','導出單據模板','Export Doc Template','導出單據模板','Export Doc Template') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000014,8,32768,3145728,'打印','打印','列印','Print','列印','Print') 
--GO
/****** Object:Data   单据权限对象表：t_ObjectType    Script Date: 2013-09-06 ******/

DELETE t_ObjectType
WHERE FObjectType = 4100
      AND FObjectID = 200000014;
GO
INSERT INTO t_ObjectType
(FObjectType,
 FObjectID,
 FName,
 FDescription,
 FName_cht,
 FName_en,
 FDescription_cht,
 FDescription_en
)
VALUES
(4100,
 200000014,
 '同步数据配置表',
 '',
 '基礎資料200000014',
 'Master Data200000014',
 NULL,
 NULL
);
GO

/****** Object:Data   单据权限表：t_ObjectAccess    Script Date: 2013-09-06 ******/

DELETE t_ObjectAccess
WHERE FObjectType = 4100
      AND FObjectID = 200000014;
GO
INSERT INTO t_ObjectAccess
(FGroupID,
 FObjectType,
 FObjectID,
 FIndex
)
VALUES
(2101,
 4100,
 200000014,
 0
);
GO
INSERT INTO t_ObjectAccess
(FGroupID,
 FObjectType,
 FObjectID,
 FIndex
)
VALUES
(2101,
 4100,
 200000014,
 1
);
GO
INSERT INTO t_ObjectAccess
(FGroupID,
 FObjectType,
 FObjectID,
 FIndex
)
VALUES
(2102,
 4100,
 200000014,
 0
);
GO
INSERT INTO t_ObjectAccess
(FGroupID,
 FObjectType,
 FObjectID,
 FIndex
)
VALUES
(2102,
 4100,
 200000014,
 1
);
GO
INSERT INTO t_ObjectAccess
(FGroupID,
 FObjectType,
 FObjectID,
 FIndex
)
VALUES
(2102,
 4100,
 200000014,
 2
);
GO
INSERT INTO t_ObjectAccess
(FGroupID,
 FObjectType,
 FObjectID,
 FIndex
)
VALUES
(2102,
 4100,
 200000014,
 3
);
GO
INSERT INTO t_ObjectAccess
(FGroupID,
 FObjectType,
 FObjectID,
 FIndex
)
VALUES
(2102,
 4100,
 200000014,
 4
);
GO
INSERT INTO t_ObjectAccess
(FGroupID,
 FObjectType,
 FObjectID,
 FIndex
)
VALUES
(2102,
 4100,
 200000014,
 5
);
GO
INSERT INTO t_ObjectAccess
(FGroupID,
 FObjectType,
 FObjectID,
 FIndex
)
VALUES
(2102,
 4100,
 200000014,
 6
);
GO
INSERT INTO t_ObjectAccess
(FGroupID,
 FObjectType,
 FObjectID,
 FIndex
)
VALUES
(2102,
 4100,
 200000014,
 7
);
GO
INSERT INTO t_ObjectAccess
(FGroupID,
 FObjectType,
 FObjectID,
 FIndex
)
VALUES
(2102,
 4100,
 200000014,
 8
);
GO

/****** Object:Data   选单关联：ICClassLink    Script Date: 2013-09-06 ******/

DELETE ICClassLink
WHERE FDestClassTypeID = 200000014
      OR FSourClassTypeID = 200000014;
GO

/****** Object:Data   选单关联明细：ICClassLinkEntry    Script Date: 2013-09-06 ******/

DELETE ICClassLinkEntry
WHERE FDestClassTypeID = 200000014
      OR FSourClassTypeID = 200000014;
GO

/****** Object:Data   选单钩稽明细：ICClassLinkCommit    Script Date: 2013-09-06 ******/

DELETE ICClassLinkCommit
WHERE FDstClsTypID = 200000014
      OR FSrcClsTypID = 200000014;
GO

/****** Object:Data   选单流程基本信息：ICClassWorkFlow    Script Date: 2013-09-06 ******/


GO
DECLARE @MaxID AS INT;
SELECT @MaxID = ISNUll(MAX(FID), 10000)
FROM ICClassWorkFlow;
UPDATE ICMaxNum
  SET
      FMaxNum = @MaxID + 1
WHERE FTableName = 'ICClassWorkFlow';
GO


/****** Object:Data   选单流程关联单据：ICClassWorkFlowBill    Script Date: 2013-09-06 ******/

DELETE ICClassWorkFlowBill
WHERE FClassTypeID = 200000014;
GO
DELETE ICClassWorkFlowBill
WHERE FID < 0
      AND FEntryID NOT IN(SELECT MAX(FEntryID)
                          FROM ICClassWorkFlowBill
                          WHERE FID < 0
                          GROUP BY FClassTypeID
                          HAVING COUNT(FClassTypeID) >= 1);
DELETE ICClassWorkFlowBill
WHERE FID =
(
    SELECT MAX(FID)
    FROM ICClassWorkFlow
)
      AND FClassTypeID IN(SELECT FClassTypeID
                          FROM ICCLASSWORKFLOWBILL
                          WHERE FID < 0);
UPDATE ICClassWorkFlowBill
  SET
      FID =
(
    SELECT MAX(FID)
    FROM ICClassWorkFlow
)
WHERE FID < 0;
DELETE ICClassWorkFlowBill
WHERE FID < 0; 

/****** Object:Data   选单流程关联关系：ICClassWorkFlowJoin    Script Date: 2013-09-06 ******/

DELETE ICClassWorkFlowJoin
WHERE FDestClassTypeID = 200000014
      OR FSourClassTypeID = 200000014;
GO
UPDATE ICClassWorkFlowJoin
  SET
      FID =
(
    SELECT MAX(FID)
    FROM ICClassWorkFlow
)
WHERE FID < 0;
DELETE ICClassWorkFlowJoin
WHERE FID < 0; 

/****** Object:Data   网络控制模板数据：ICClassMutex    Script Date: 2013-09-06 ******/

DELETE ICClassMutex
WHERE FClassTypeID = 200000014;
GO

/****** Object:Data   网络控制互斥表明细数据：t_Mutex    Script Date: 2013-09-06 ******/

DELETE t_Mutex
WHERE FFuncId IN(SELECT FFuncID
                 FROM icClassMutex
                 WHERE FClassTypeID = 200000014)
      OR FForbidden IN(SELECT FFuncID
                       FROM icClassMutex
                       WHERE FClassTypeID = 200000014);
GO

/****** Object:Data   网络控制操作定义明细：t_SysFunction    Script Date: 2013-09-06 ******/

DELETE t_SysFunction
WHERE FFuncId IN(SELECT FFuncID
                 FROM icClassMutex
                 WHERE FClassTypeID = 200000014);
GO

/****** Object:Data   打印控制模板数据：ICPrintMaxCount    Script Date: 2013-09-06 ******/

DELETE ICPrintMaxCount
WHERE FID = 200000014;
GO

/****** Object:Data   多级审核配置模板数据：ICClassMCFlowInfo    Script Date: 2013-09-06 ******/

DELETE ICClassMCFlowInfo
WHERE FID = 200000014;
GO

/****** Object:Data   多级审核的工作流任务（各审核级次）模板数据：ICClassMCTasks    Script Date: 2013-09-06 ******/

DELETE ICClassMCTasks
WHERE FID = 200000014;
GO

/****** Object:Data   多级审核的流程流转和规则模板数据：ICClassMCRule    Script Date: 2013-09-06 ******/

DELETE ICClassMCRule
WHERE FID = 200000014;
GO

/****** Object:Data   单据操作明细模板数据：ICClassBillAction    Script Date: 2013-09-06 ******/

DELETE ICClassBillAction
WHERE FClassTypeID = 200000014;
GO
DECLARE @MaxID AS INT;
SELECT @MaxID = ISNUll(MAX(FID), 10000)
FROM ICClassBillAction;
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 1,
 200000014,
 'mnuEditCopy',
 '复制',
 '複製',
 'Copy',
 '复制',
 '複製',
 'Copy',
 39,
 131072,
 0,
 7,
 1,
 0,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 2,
 200000014,
 'mnuEditDel',
 '删除',
 '刪除',
 'Delete',
 '删除',
 '刪除',
 'Delete',
 4096,
 65536,
 0,
 7,
 1,
 1,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 3,
 200000014,
 'mnuEditDelGroup',
 '删除组',
 '刪除組',
 'Delete Group ',
 '删除组',
 '刪除組',
 'Delete Group ',
 4096,
 65536,
 0,
 7,
 1,
 1,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 4,
 200000014,
 'mnuEditModify',
 '修改',
 '修改',
 'Edit',
 '修改',
 '修改',
 'Edit',
 4160,
 4194304,
 0,
 7,
 1,
 0,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 5,
 200000014,
 'mnuEditUnuse',
 '禁用',
 '禁用',
 'Disabled',
 '禁用',
 '禁用',
 'Disabled',
 4096,
 64,
 0,
 7,
 1,
 1,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 6,
 200000014,
 'mnuEditUse',
 '反禁用',
 '反禁用',
 'Enable',
 '反禁用',
 '反禁用',
 'Enable',
 4096,
 64,
 0,
 7,
 1,
 1,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 7,
 200000014,
 'mnuExportData',
 '引出内部数据',
 '引出內部資料',
 'Export Internal Data',
 '引出内部数据',
 '引出內部資料',
 'Export Internal Data',
 5056,
 16,
 0,
 7,
 1,
 0,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 8,
 200000014,
 'mnuFileExportBillTpl',
 '导出单据模板',
 '導出單據模板',
 'Export Doc Template',
 '导出单据模板',
 '導出單據模板',
 'Export Doc Template',
 0,
 16384,
 0,
 7,
 1,
 1,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 9,
 200000014,
 'mnuFileImportBill',
 '导入单据数据',
 '導入單據資料',
 'Import Doc Data',
 '导入单据数据',
 '導入單據資料',
 'Import Doc Data',
 0,
 16384,
 0,
 7,
 1,
 1,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 10,
 200000014,
 'mnuFileNewGroup',
 '新增组',
 '新增組',
 'New Group',
 '新增组',
 '新增組',
 'New Group',
 4096,
 131072,
 0,
 7,
 1,
 0,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 11,
 200000014,
 'mnuFileNewItem',
 '新增项目',
 '新增項目',
 'New Item',
 '新增项目',
 '新增項目',
 'New Item',
 4096,
 131072,
 0,
 7,
 1,
 0,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 12,
 200000014,
 'mnuFilePrint',
 '打印',
 '列印',
 'Print',
 '打印',
 '列印',
 'Print',
 5095,
 32768,
 0,
 7,
 1,
 0,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 13,
 200000014,
 'mnuFileSave',
 '保存',
 '保存',
 'Save',
 '保存',
 '保存',
 'Save',
 6,
 0,
 0,
 7,
 0,
 1,
 1,
 0,
 0,
 1,
 0
);
INSERT INTO ICClassBillAction
(FID,
 FClassTypeID,
 FCode,
 FName_CHS,
 FName_CHT,
 FName_EN,
 FDescriptions_CHS,
 FDescriptions_CHT,
 FDescriptions_EN,
 FEnvironment,
 FRightMask,
 FRightUseMask,
 FRightGroupMask,
 FRightControl,
 FAddLog,
 FIsPredefine,
 FIsFirst,
 FShortCut,
 FListActionCirculation,
 FOperationType
)
VALUES
(@MaxID + 14,
 200000014,
 'mnuStockQuery',
 '库存查询',
 '庫存查詢',
 'Query Inventory',
 '库存查询',
 '庫存查詢',
 'Query Inventory',
 0,
 0,
 0,
 7,
 0,
 1,
 1,
 0,
 0,
 1,
 0
);
UPDATE ICMaxNum
  SET
      FMaxNum = @MaxID + 15
WHERE FTableName = 'ICClassBillAction';
GO


/****** Object:Data   单据操作日志模板数据：t_LogFunction    Script Date: 2013-09-06 ******/

DELETE t_LogFunction
WHERE FFunctionID LIKE 'BOS200000014%';
GO
INSERT INTO t_LogFunction
(FFunctionID,
 FFunctionName,
 FSubSysID,
 FFunctionName_Cht,
 FFunctionName_EN
)
VALUES
('BOS200000014_mnuEditDel',
 '销售管理系统-同步数据配置表',
 23,
 '銷售管理系統-基礎資料200000014',
 'Sales Module-Master Data200000014'
);
GO
INSERT INTO t_LogFunction
(FFunctionID,
 FFunctionName,
 FSubSysID,
 FFunctionName_Cht,
 FFunctionName_EN
)
VALUES
('BOS200000014_mnuEditDelGroup',
 '销售管理系统-同步数据配置表',
 23,
 '銷售管理系統-基礎資料200000014',
 'Sales Module-Master Data200000014'
);
GO
INSERT INTO t_LogFunction
(FFunctionID,
 FFunctionName,
 FSubSysID,
 FFunctionName_Cht,
 FFunctionName_EN
)
VALUES
('BOS200000014_mnuEditUnuse',
 '销售管理系统-同步数据配置表',
 23,
 '銷售管理系統-基礎資料200000014',
 'Sales Module-Master Data200000014'
);
GO
INSERT INTO t_LogFunction
(FFunctionID,
 FFunctionName,
 FSubSysID,
 FFunctionName_Cht,
 FFunctionName_EN
)
VALUES
('BOS200000014_mnuEditUse',
 '销售管理系统-同步数据配置表',
 23,
 '銷售管理系統-基礎資料200000014',
 'Sales Module-Master Data200000014'
);
GO
INSERT INTO t_LogFunction
(FFunctionID,
 FFunctionName,
 FSubSysID,
 FFunctionName_Cht,
 FFunctionName_EN
)
VALUES
('BOS200000014_mnuFileExportBillTpl',
 '销售管理系统-同步数据配置表',
 23,
 '銷售管理系統-基礎資料200000014',
 'Sales Module-Master Data200000014'
);
GO
INSERT INTO t_LogFunction
(FFunctionID,
 FFunctionName,
 FSubSysID,
 FFunctionName_Cht,
 FFunctionName_EN
)
VALUES
('BOS200000014_mnuFileImportBill',
 '销售管理系统-同步数据配置表',
 23,
 '銷售管理系統-基礎資料200000014',
 'Sales Module-Master Data200000014'
);
GO
INSERT INTO t_LogFunction
(FFunctionID,
 FFunctionName,
 FSubSysID,
 FFunctionName_Cht,
 FFunctionName_EN
)
VALUES
('BOS200000014_mnuFileSave',
 '销售管理系统-同步数据配置表',
 23,
 '銷售管理系統-基礎資料200000014',
 'Sales Module-Master Data200000014'
);
GO
INSERT INTO t_LogFunction
(FFunctionID,
 FFunctionName,
 FSubSysID,
 FFunctionName_Cht,
 FFunctionName_EN
)
VALUES
('BOS200000014_mnuStockQuery',
 '销售管理系统-同步数据配置表',
 23,
 '銷售管理系統-基礎資料200000014',
 'Sales Module-Master Data200000014'
);
GO

/****** Object:Data   单据操作位置模板数据：ICClassActionPosition    Script Date: 2013-09-06 ******/

DELETE ICClassActionPosition
WHERE FClassTypeID = 200000014;
GO

/****** Object:Data   单据扩展服务模板数据：ICClassActionList    Script Date: 2013-09-06 ******/

DELETE ICClassActionList
WHERE FClassTypeID = 200000014;
GO
INSERT INTO ICClassActionList
(FClassTypeID,
 FClassActionID,
 FObject,
 FDefineType,
 FSourceType,
 FSourceField,
 FAction,
 FExpression,
 FOrder,
 FDescription
)
VALUES
(200000014,
 6,
 'FName',
 0,
 4096,
 'FAction',
 'FParentName',
 '',
 1,
 'Update By Function UpdateOldFiledAction'
);
GO
INSERT INTO ICClassActionList
(FClassTypeID,
 FClassActionID,
 FObject,
 FDefineType,
 FSourceType,
 FSourceField,
 FAction,
 FExpression,
 FOrder,
 FDescription
)
VALUES
(200000014,
 6,
 'FNumber',
 0,
 4096,
 'FAction',
 'FParentNumber',
 '',
 1,
 'Update By Function UpdateOldFiledAction'
);
GO
INSERT INTO ICClassActionList
(FClassTypeID,
 FClassActionID,
 FObject,
 FDefineType,
 FSourceType,
 FSourceField,
 FAction,
 FExpression,
 FOrder,
 FDescription
)
VALUES
(200000014,
 12,
 'FNumber',
 0,
 4096,
 'FSaveRule',
 'FNumber',
 '',
 1,
 'Update By Function UpdateOldFiledAction'
);
GO



/**End  新单据模板数据脚本，名称 同步数据配置表    Script Date: 2013-09-06 **/

--2 进入bos 供应链 销售管理 发布
--3 部署同步代码




---1 创建同步表 写入同步目标帐套名
IF EXISTS
(
    SELECT *
    FROM dbo.SysObjects
    WHERE ID = OBJECT_ID(N'[t_BOS_Synchro]')
          AND OBJECTPROPERTY(ID, 'IsTable') = 1
)
    DROP TABLE t_BOS_Synchro;
GO
CREATE TABLE t_BOS_Synchro
([ID]      [INT] IDENTITY(1, 1) NOT NULL,
 [FDBName] VARCHAR(100),
 [FK3Name] VARCHAR(100)
)
ON [PRIMARY];
GO
INSERT INTO t_BOS_Synchro
(FDBName,
 FK3Name
)--select * from t_BOS_Synchro
       SELECT 'CON14.Test_YXSP2_3B',
              '帐套同步';
GO
----------------------------------------------------------
----------------------------------------------------------



--基础资料同步
--添加BOM字段
ALTER TABLE ICStockBill
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE ICStockBill_1
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE ICStockBill_2
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE ICStockBill_21
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE ICStockBill_10
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE ICStockBill_24
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE ICStockBill_28
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE ICStockBill_29
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE ICStockBill_41
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE ICStockBill_5
ADD FSynchroID VARCHAR(50) NULL;
ALTER TABLE ICSale
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE ICPurchase
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE t_RP_NewReceiveBill
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE ICBOM
ADD FSynchroID VARCHAR(50) NULL;
GO
GO
---10 添加字段
ALTER TABLE t_rp_arpbill
ADD FMultiCheckStatus INT;
GO
ALTER TABLE t_rp_arpbill
ADD FSynchroID VARCHAR(50) NULL;
--1添加t_Voucher字段

ALTER TABLE t_Voucher
ADD FSynchroID VARCHAR(50) NULL;
GO
ALTER TABLE t_RP_NewReceiveBill
ADD FMultiCheckStatus INT;
GO
--添加t_VoucherBlankout字段  

ALTER TABLE t_VoucherBlankout
ADD FSynchroID VARCHAR(50) NULL;

--添加t_VoucherAdjust字段因为没这个表省了

ALTER TABLE t_VoucherAdjust
ADD FSynchroID VARCHAR(50) NULL;
GO
--添加t_Voucher字段

ALTER TABLE t_Voucher
ADD FSynchroIDNum VARCHAR(50) NULL;
ALTER TABLE t_VoucherAdjust
ADD FSynchroIDNum VARCHAR(50) NULL;   --yxf添加

GO
--添加t_VoucherBlankout字段

ALTER TABLE t_VoucherBlankout
ADD FSynchroIDNum VARCHAR(50) NULL;
GO


---- 2 t_item 创建触发器
--同步基础资料
----1-客户 t_organization；
----2-部门 t_department;
----3-职员 t_emp;
----4-商品 t_icitem;
----5-仓位 t_stock;
----6 仓库 t_stock
----7-单位 t_measureunit；
----8-供应商 t_supplier

IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[yj_t_item]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
--PRINT '1' ELSE PRINT '0'


    DROP TRIGGER yj_t_item;
GO
CREATE TRIGGER [dbo].[yj_t_item] ON [dbo].[t_Item]
FOR INSERT, UPDATE, DELETE
AS
     DECLARE @DBName VARCHAR(100);
     DECLARE @FDetail VARCHAR(10);
     DECLARE @FItemClassID VARCHAR(50);
     DECLARE @FItemID VARCHAR(10);
     DECLARE @FNumber VARCHAR(100);
     DECLARE @OldFnumber VARCHAR(100);
     DECLARE @FName VARCHAR(100);
     DECLARE @FShortNumber VARCHAR(100);
     DECLARE @FParentID INT;
     DECLARE @Sql VARCHAR(4000);
     DECLARE @T_ItemSQL VARCHAR(4000);
     DECLARE @nSql NVARCHAR(4000);
     DECLARE @pp2 INT;
     BEGIN
         SELECT @DBName = FDBName
         FROM t_BOS_Synchro
         WHERE FK3Name = '帐套同步';
         SELECT @FDetail = FDetail
         FROM inserted
         WHERE FItemClassID IN(1, 2, 3, 4, 5, 7, 8, 2001);
         SELECT @FDetail = FDetail
         FROM deleted
         WHERE FItemClassID IN(1, 2, 3, 4, 5, 7, 8, 2001);
         IF(LEN(@DBName) > 0)
           AND (@FDetail = 0)
             BEGIN
	
		-----1. 添加    -----
                 IF EXISTS
(
    SELECT *
    FROM Inserted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM deleted
))
                     BEGIN
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ';
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber,
                                @FItemClassID = FItemClassID
                         FROM inserted;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_item where FItemClassID='+@FItemClassID+' and FNumber='+''''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 = 0
                             BEGIN
                                 SET @nSql = ' exec '+@DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394';
                                 EXEC sp_executesql
                                      @nSql,
                                      N'@p2   int   output ',
                                      @pp2 OUTPUT;
                                 SET @Sql = @T_ItemSQL+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID= t.FItemClassID and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item t where FItemClassID= '+''''+@FItemClassID+''''+' and FNumber='+''''+@FNumber+'''';
                                 EXEC (@SQL);
                             END;
                     END;

		
		-----2.修改 (对应帐套存在相同目录，才同步)----- 
                 IF EXISTS
(
    SELECT 1
    FROM Inserted
)
                    AND EXISTS
(
    SELECT 1
    FROM deleted
)
                     BEGIN
                         IF((UPDATE(FName))
                            OR (UPDATE(FNumber)))
                             BEGIN
                                 SELECT @FItemID = FItemID,
                                        @FNumber = FNumber,
                                        @FShortNumber = FShortNumber,
                                        @FName = FName,
                                        @FItemClassID = FItemClassID
                                 FROM inserted;
                                 SELECT @OldFnumber = FNumber
                                 FROM deleted;
                                 SET @pp2 = 0;
                                 SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_item where FItemClassID='+@FItemClassID+' and FNumber='+''''+@OldFnumber+'''';
                                 EXEC sp_executesql
                                      @nSQL,
                                      N'@p2   int   output ',
                                      @pp2 OUTPUT;
		
						---- 1.不存在，新增  ----
                                 IF @pp2 = 0
                                     BEGIN
                                         SET @nSql = ' exec '+@DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394';
                                         EXEC sp_executesql
                                              @nSql,
                                              N'@p2   int   output ',
                                              @pp2 OUTPUT;
                                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ';
                                         SET @Sql = @T_ItemSQL+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID= t.FItemClassID and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item t where FItemClassID= '+''''+@FItemClassID+''''+' and FNumber='+''''+@FNumber+'''';
                                         EXEC (@SQL);
                                     END;
				
				
						---- 2.修改	----
                                 IF @pp2 > 0
                                     BEGIN
                                         SET @FParentID = 0;
                                         SET @nSQL = ' select @p2=isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item 
								where FItemClassID= t.FItemClassID and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0)
								from T_Item t where FItemID='+@FItemID;
                                         EXEC sp_executesql
                                              @nSQL,
                                              N'@p2   int   output ',
                                              @FParentID OUTPUT;
                                         SET @Sql = 'update   '+@DBName+'.dbo.T_Item  set FName='+''''+@FName+''''+',FNumber='+''''+@FNumber+''''+' ,FFullNumber='+''''+@FNumber+''''+',FShortNumber='+''''+@FShortNumber+''''+',FParentID='+CAST(@FParentID AS VARCHAR(10))+'  where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                         EXEC (@Sql);
                                         UPDATE T_Item
                                           SET
                                               FFullName = FFullName
                                         WHERE FNumber LIKE @FNumber+'.%';
                                     END;
                             END;
                     END;
		
			
		-----3. 删除 -----
                 IF EXISTS
(
    SELECT *
    FROM Deleted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM Inserted
))
                     BEGIN
                         SELECT @FNumber = FNumber,
                                @FItemClassID = FItemClassID
                         FROM deleted;
                         SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemClassID='+@FItemClassID+' and FNumber='+''''+@FNumber+'''';
                         EXEC (@sql);
                     END;
		-----

             END;
     END;
GO 

------3 t_emp 触发器
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[trg_t_Emp_InsUptDel]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    PRINT '1';
    ELSE
PRINT '0';
DROP TRIGGER trg_t_Emp_InsUptDel;
--EXEC sp_helptext trg_t_Emp_InsUptDel
GO --备份改触发器（原本有的）
--CREATE TRIGGER trg_t_Emp_InsUptDel ON t_Emp    
--    INSTEAD OF INSERT,UPDATE,DELETE    
--    AS      
--    BEGIN    
--        BEGIN TRANSACTION      
--        SET NOCOUNT ON    
--        DECLARE @ERROR INT    
--        SET @ERROR=0    
--        IF EXISTS(SELECT 1 FROM Deleted)      
--        BEGIN    
--            DELETE t_Base_Emp FROM t_Base_Emp INNER JOIN Deleted   ON t_Base_Emp.FItemID=Deleted.FItemID    
--            SET @ERROR=@ERROR+@@ERROR    
--            DELETE HR_Base_Emp FROM HR_Base_Emp INNER JOIN (SELECT FItemID FROM Deleted WHERE NOT EXISTS(SELECT FItemID FROM Inserted WHERE  Deleted.FItemID=Inserted.FItemID)) t1 ON HR_Base_Emp.FItemID=t1.FItemID    
--            SET @ERROR=@ERROR+@@ERROR    
--            UPDATE HR_Base_User SET FEmpID=NULL WHERE FEmpID NOT IN (SELECT EM_ID FROM HR_Base_Emp)    
--            SET @ERROR=@ERROR+@@ERROR    
--        END    
--        IF EXISTS (SELECT 1 FROM Inserted)    
--        BEGIN    
--             INSERT INTO t_Base_Emp (FItemID,FAccountName,FAddress,FAllotPercent,FAllotWeight,FBankAccount,FBankID,FBirthday,FBrNO,FCreditAmount,FCreditDays,FCreditLevel,FCreditPeriod,FDegree,FDeleted,FDepartmentID,FDuty,FEmail,FEmpGroup,FEmpGroupID,  
--             FGender,FHireDate,FID,FIsCreditMgr,FItemDepID,FJobTypeID,FLeaveDate,FMobilePhone,FName,FNote,FNumber,FOperationGroup,FOtherAPAcctID,FOtherARAcctID,FParentID,FPersonalBank,FPhone,FPreAPAcctID,FPreARAcctID,FProfessionalGroup,FShortNumber)    
--             SELECT FItemID,FAccountName,FAddress,ISNULL(FAllotPercent,0),ISNULL(FAllotWeight,0),FBankAccount,ISNULL(FBankID,0),FBirthday,ISNULL(FBrNO,'0'),FCreditAmount,FCreditDays,ISNULL(FCreditLevel,0),ISNULL(FCreditPeriod,0),FDegree,ISNULL(FDeleted,0)
  
--,FDepartmentID,FDuty,FEmail,FEmpGroup,ISNULL(FEmpGroupID,0),ISNULL(FGender,1068),FHireDate,FID,ISNULL(FIsCreditMgr,0),ISNULL(FItemDepID,0),ISNULL(FJobTypeID,0),FLeaveDate,FMobilePhone,FName,FNote,FNumber,ISNULL(FOperationGroup,0),ISNULL(FOtherAPAcctID,0),
  
--ISNULL(FOtherARAcctID,0),FParentID,FPersonalBank,FPhone,ISNULL(FPreAPAcctID,0),ISNULL(FPreARAcctID,0),ISNULL(FProfessionalGroup,0),FShortNumber FROM Inserted    
--  INSERT INTO Access_t_emp(FItemID,FParentIDX,FDataAccessDelete,FDataAccessEdit,FDataAccessView)    
--  SELECT t1.FItemID,ISNULL(t1.FParentID,0),t3.FDataAccessDelete,t3.FDataAccessEdit,t3.FDataAccessView     
--  FROM  Inserted t1 LEFT JOIN Access_t_emp t2 ON t1.FItemiD=t2.FItemID    
--  LEFT JOIN Access_t_emp t3  ON t3.FItemID=0    
--  WHERE t2.FItemID IS NULL    
--             SET @ERROR=@ERROR+@@ERROR    
--            UPDATE HR_Base_Emp SET Name=Inserted.FName,Sex=Case Inserted.FGender When 1068 Then 1 When 1069 Then 2 Else 9 End,Birthday=Inserted.FBirthDay,    
--                    Mobile=Inserted.FMobilePhone,IDCardID=Inserted.FID,EMail=Inserted.FEMail    
--                    FROM HR_Base_Emp,Inserted WHERE HR_Base_Emp.FItemID=Inserted.FItemID AND Inserted.FItemID IN (SELECT Inserted.FItemID FROM Deleted,Inserted WHERE Deleted.FItemID=Inserted.FItemID)    
--            SET @ERROR=@ERROR+@@ERROR    
--            INSERT INTO HR_Base_Emp(FItemID,Name,Sex,Birthday,Mobile,IDCardID,EMail,EM_ID)    
--            SELECT FItemID,FName,Case FGender When 1068 Then 1 When 1069 Then 2 Else 9 End,FBirthDay,FMobilePhone,FID,FEMail,NEWID() FROM Inserted    
--                  WHERE FItemID NOT IN (SELECT Inserted.FItemID FROM Deleted,Inserted WHERE Deleted.FItemID=Inserted.FItemID)    
--            SET @ERROR=@ERROR+@@ERROR    
--        END    
--        IF (@ERROR <> 0)    
--            ROLLBACK TRANSACTION    
--        ELSE    
--            COMMIT TRANSACTION    
--    END    


GO
CREATE TRIGGER [dbo].[trg_t_Emp_InsUptDel] ON [dbo].[t_Emp]
INSTEAD OF INSERT, UPDATE, DELETE
AS
     DECLARE @FItemID VARCHAR(10);
     DECLARE @FNumber VARCHAR(100);
     DECLARE @DBName VARCHAR(100);
     DECLARE @Sql VARCHAR(4000);
     DECLARE @InsertSQL VARCHAR(2000);
     DECLARE @T_ItemSQL VARCHAR(2000);
     DECLARE @IsHere VARCHAR(10);
     DECLARE @FDetail VARCHAR(10);
     DECLARE @FParentID VARCHAR(50);
     DECLARE @FItemidTemp VARCHAR(50);
     DECLARE @NewFNumber VARCHAR(50);
     DECLARE @FDepartmentID VARCHAR(50);
     DECLARE @nSql NVARCHAR(4000);
     DECLARE @pp2 INT;
     BEGIN
         BEGIN TRANSACTION;
         SET NOCOUNT ON;
         DECLARE @ERROR INT;
         SET @ERROR = 0;
         IF EXISTS
(
    SELECT 1
    FROM Deleted
)
             BEGIN
                 DELETE t_Base_Emp
                 FROM t_Base_Emp
                      INNER JOIN Deleted ON t_Base_Emp.FItemID = Deleted.FItemID;
                 SET @ERROR = @ERROR + @@ERROR;
                 DELETE HR_Base_Emp
                 FROM HR_Base_Emp
                      INNER JOIN
(
    SELECT FItemID
    FROM Deleted
    WHERE NOT EXISTS
(
    SELECT FItemID
    FROM Inserted
    WHERE Deleted.FItemID = Inserted.FItemID
)
) t1 ON HR_Base_Emp.FItemID = t1.FItemID;
                 SET @ERROR = @ERROR + @@ERROR;
                 UPDATE HR_Base_User
                   SET
                       FEmpID = NULL
                 WHERE FEmpID NOT IN(SELECT EM_ID
                                     FROM HR_Base_Emp);
                 SET @ERROR = @ERROR + @@ERROR;
             END;
         IF EXISTS
(
    SELECT 1
    FROM Inserted
)
             BEGIN
                 INSERT INTO t_Base_Emp
(FItemID,
 FAccountName,
 FAddress,
 FAllotPercent,
 FAllotWeight,
 FBankAccount,
 FBankID,
 FBirthday,
 FBrNO,
 FCreditAmount,
 FCreditDays,
 FCreditLevel,
 FCreditPeriod,
 FDegree,
 FDeleted,
 FDepartmentID,
 FDuty,
 FEmail,
 FEmpGroup,
 FEmpGroupID,
 FGender,
 FHireDate,
 FID,
 FIsCreditMgr,
 FItemDepID,
 FJobTypeID,
 FLeaveDate,
 FMobilePhone,
 FName,
 FNote,
 FNumber,
 FOperationGroup,
 FOtherAPAcctID,
 FOtherARAcctID,
 FParentID,
 FPersonalBank,
 FPhone,
 FPreAPAcctID,
 FPreARAcctID,
 FProfessionalGroup,
 FShortNumber
)
                        SELECT FItemID,
                               FAccountName,
                               FAddress,
                               ISNULL(FAllotPercent, 0),
                               ISNULL(FAllotWeight, 0),
                               FBankAccount,
                               ISNULL(FBankID, 0),
                               FBirthday,
                               ISNULL(FBrNO, '0'),
                               FCreditAmount,
                               FCreditDays,
                               ISNULL(FCreditLevel, 0),
                               ISNULL(FCreditPeriod, 0),
                               FDegree,
                               ISNULL(FDeleted, 0),
                               FDepartmentID,
                               FDuty,
                               FEmail,
                               FEmpGroup,
                               ISNULL(FEmpGroupID, 0),
                               ISNULL(FGender, 1068),
                               FHireDate,
                               FID,
                               ISNULL(FIsCreditMgr, 0),
                               ISNULL(FItemDepID, 0),
                               ISNULL(FJobTypeID, 0),
                               FLeaveDate,
                               FMobilePhone,
                               FName,
                               FNote,
                               FNumber,
                               ISNULL(FOperationGroup, 0),
                               ISNULL(FOtherAPAcctID, 0),
                               ISNULL(FOtherARAcctID, 0),
                               FParentID,
                               FPersonalBank,
                               FPhone,
                               ISNULL(FPreAPAcctID, 0),
                               ISNULL(FPreARAcctID, 0),
                               ISNULL(FProfessionalGroup, 0),
                               FShortNumber
                        FROM Inserted;
                 INSERT INTO Access_t_emp
(FItemID,
 FParentIDX,
 FDataAccessDelete,
 FDataAccessEdit,
 FDataAccessView
)
                        SELECT t1.FItemID,
                               ISNULL(t1.FParentID, 0),
                               t3.FDataAccessDelete,
                               t3.FDataAccessEdit,
                               t3.FDataAccessView
                        FROM Inserted t1
                             LEFT JOIN Access_t_emp t2 ON t1.FItemiD = t2.FItemID
                             LEFT JOIN Access_t_emp t3 ON t3.FItemID = 0
                        WHERE t2.FItemID IS NULL;
                 SET @ERROR = @ERROR + @@ERROR;
                 UPDATE HR_Base_Emp
                   SET
                       Name = Inserted.FName,
                       Sex = CASE Inserted.FGender
                                 WHEN 1068
                                 THEN 1
                                 WHEN 1069
                                 THEN 2
                                 ELSE 9
                             END,
                       Birthday = Inserted.FBirthDay,
                       Mobile = Inserted.FMobilePhone,
                       IDCardID = Inserted.FID,
                       EMail = Inserted.FEMail
                 FROM HR_Base_Emp, Inserted
                 WHERE HR_Base_Emp.FItemID = Inserted.FItemID
                       AND Inserted.FItemID IN(SELECT Inserted.FItemID
                                               FROM Deleted,
                                                    Inserted
                                               WHERE Deleted.FItemID = Inserted.FItemID);
                 SET @ERROR = @ERROR + @@ERROR;
                 INSERT INTO HR_Base_Emp
(FItemID,
 Name,
 Sex,
 Birthday,
 Mobile,
 IDCardID,
 EMail,
 EM_ID
)
                        SELECT FItemID,
                               FName,
                               CASE FGender
                                   WHEN 1068
                                   THEN 1
                                   WHEN 1069
                                   THEN 2
                                   ELSE 9
                               END,
                               FBirthDay,
                               FMobilePhone,
                               FID,
                               FEMail,
                               NEWID()
                        FROM Inserted
                        WHERE FItemID NOT IN
(
    SELECT Inserted.FItemID
    FROM Deleted,
         Inserted
    WHERE Deleted.FItemID = Inserted.FItemID
);
                 SET @ERROR = @ERROR + @@ERROR;
             END;
   
            
          ---- 1. 添加 ----      
         IF EXISTS
(
    SELECT 1
    FROM Inserted
)
            AND (NOT EXISTS
(
    SELECT 1
    FROM deleted
))
             BEGIN
                 SELECT @DBName = FDBName
                 FROM t_BOS_Synchro
                 WHERE FK3Name = '帐套同步';
                 IF LEN(@DBName) > 0
                     BEGIN
                         SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_Emp (FEmpGroup,FGender,FBirthDay,FDegree,FPhone,FMobilePhone,FID,FDuty,'+'FHireDate,FLeaveDate,FBankAccount,FAddress,FEmail,FNote,FIsCreditMgr,FProfessionalGroup,FJobTypeID,'+'FAllotPercent,FOperationGroup,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,FShortNumber,FNumber,FName,FDepartmentID,FParentID,FItemID)  ';
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ';
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber,
                                @FDepartmentID = FDepartmentID
                         FROM inserted;
                         SELECT @FParentID = FParentID,
                                @FDetail = FDetail
                         FROM t_Item
                         WHERE FNumber = @FNumber;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_Emp where  FNumber='+''''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 = 0			--插入到t_Emp和t_item
                             BEGIN
                                 SET @nSql = ' exec '+@DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394';
                                 EXEC sp_executesql
                                      @nSql,
                                      N'@p2   int   output ',
                                      @pp2 OUTPUT;
                                 SET @Sql = 'Insert into '+@DBName+'.dbo.t_item (FFullName,FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '+'select FName as FFullName,FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=3 and Fnumber=(select top 1 FNumber from T_Item where FItemClassID=3 and FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item  t where FITemID='+@FItemID;
                                 EXEC (@SQL);	
			  
                                --SET @Sql = @InsertSQL
                                --    + ' select  FEmpGroup,FGender,FBirthDay,FDegree,FPhone,FMobilePhone,FID,FDuty,'
                                --    + 'FHireDate,FLeaveDate,FBankAccount,FAddress,FEmail,FNote,FIsCreditMgr,FProfessionalGroup,FJobTypeID,'
                                --    + 'FAllotPercent,FOperationGroup,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,FShortNumber,FNumber,FName,'
                                --    + 'isnull((select FItemID from ' + @DBName
                                --    + '.dbo.t_department where Fnumber=(select FNumber from t_department where FItemID=t.FDepartmentID)),0),'
                                --    + 'isnull((select FItemID as FParentID from '
                                --    + @DBName
                                --    + '.dbo.T_Item where FItemClassID=3 and Fnumber=(select FNumber from T_Item where FItemClassID=3 and FItemID=t.FParentID)),0),'
                                --    + CAST(@pp2 AS VARCHAR(10))
                                --    + ' from t_Emp t where FItemID='
                                --    + @FItemID
                                   --跨服务器更新视图报错 	
                               -- FDepartmentID,FParentID,FItemID
                               --改为直接插入表
                                 SET @Sql = ' INSERT INTO '+@DBName+'.dbo.t_Base_Emp (FItemID,FAddress,FAllotPercent,FBankAccount,FBankID,FBirthday,FBrNO,FCreditAmount,
                                           FCreditDays,FCreditLevel,FCreditPeriod,FDegree,FDeleted,FDepartmentID,FDuty,FEmail,FEmpGroup,FEmpGroupID,FGender,FHireDate,
                                           FID,FIsCreditMgr,FItemDepID,FJobTypeID,FLeaveDate,FMobilePhone,FName,FNote,FNumber,FOperationGroup,FOtherAPAcctID,FOtherARAcctID,
                                           FParentID,FPhone,FPreAPAcctID,FPreARAcctID,FProfessionalGroup,FShortNumber)
                                     SELECT '+CAST(@pp2 AS VARCHAR(10))+',FAddress,ISNULL(FAllotPercent,0),FBankAccount,ISNULL(FBankID,0),FBirthday,ISNULL(FBrNO,''0''),
                                           FCreditAmount,FCreditDays,ISNULL(FCreditLevel,0),ISNULL(FCreditPeriod,0),FDegree,ISNULL(FDeleted,0),
                                           isnull((select FItemID from '+@DBName+'.dbo.t_department where Fnumber=(select FNumber from t_department where FItemID=t.FDepartmentID)),0)    as  FDepartmentID,
                                           FDuty,FEmail,FEmpGroup,
                                           ISNULL(FEmpGroupID,0),ISNULL(FGender,1068),FHireDate,FID,ISNULL(FIsCreditMgr,0),ISNULL(FItemDepID,0),ISNULL(FJobTypeID,0),FLeaveDate,FMobilePhone,
                                           FName,FNote,FNumber,ISNULL(FOperationGroup,0),ISNULL(FOtherAPAcctID,0),ISNULL(FOtherARAcctID,0),
                                           isnull((select FItemID  from '+@DBName+'.dbo.T_Item where FItemClassID=3 and Fnumber=(select FNumber from T_Item where FItemClassID=3 and FItemID=t.FParentID)),0) as FParentID,
                                           FPhone,ISNULL(FPreAPAcctID,0),ISNULL(FPreARAcctID,0),ISNULL(FProfessionalGroup,0),FShortNumber
                                           FROM t_Emp  t
                                           WHERE   t.FItemID ='+@FItemID;
                                 SET @Sql = @Sql+' INSERT INTO '+@DBName+'.dbo.HR_Base_Emp(FItemID,Name,Sex,Birthday,Mobile,IDCardID,EMail,EM_ID)
                                          SELECT '+CAST(@pp2 AS VARCHAR(10))+',FName,Case FGender When 1068 Then 1 When 1069 Then 2 Else 0 End,FBirthDay,FMobilePhone,FID,FEMail,NEWID() 
                                          FROM t_Emp 
                                          WHERE FItemID='+@FItemID;
                                 EXEC (@sql);  
                                
                                
                    --                                           SET @Sql = 'update ' + @DBName
                    --+ '.dbo.T_Item set FFullName=FName where FItemClassID=3 and   FITemID='
                    --                + @FItemID
                    --EXEC (@sql)   
                             END;
                     END;
             END;
	
	
	-----2.修改 ----
         IF EXISTS
(
    SELECT 1
    FROM Inserted
)
            AND EXISTS
(
    SELECT 1
    FROM deleted
)
             BEGIN
                 SELECT @DBName = FDBName
                 FROM t_BOS_Synchro
                 WHERE FK3Name = '帐套同步';
                 IF LEN(@DBName) > 0
                     BEGIN
                         SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_Emp (FEmpGroup,FGender,FBirthDay,FDegree,FPhone,FMobilePhone,FID,FDuty,'+'FHireDate,FLeaveDate,FBankAccount,FAddress,FEmail,FNote,FIsCreditMgr,FProfessionalGroup,FJobTypeID,'+'FAllotPercent,FOperationGroup,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,FShortNumber,FNumber,FName,FDepartmentID,FParentID,FItemID)  ';
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ';
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ';
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM deleted;
                         SELECT @NewFNumber = FNumber,
                                @FDepartmentID = FDepartmentID
                         FROM inserted;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_Emp where  FNumber='+''''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 > 0
                             BEGIN
                                 SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=3 and FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                                 SET @Sql = 'delete from '+@DBName+'.dbo.t_Emp where  FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                                 SET @Sql = 'Insert into '+@DBName+'.dbo.t_item (FFullName,FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '+'select FFullName,FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=3 and Fnumber=(select FNumber from T_Item where FItemClassID=3 and FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item  t where FITemID='+@FItemID;
                                 EXEC (@SQL);
                                 SET @Sql = @InsertSQL+' select  FEmpGroup,FGender,FBirthDay,FDegree,FPhone,FMobilePhone,FID,FDuty,'+'FHireDate,FLeaveDate,FBankAccount,FAddress,FEmail,FNote,FIsCreditMgr,FProfessionalGroup,FJobTypeID,'+'FAllotPercent,FOperationGroup,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,FShortNumber,FNumber,FName,'+'isnull((select FItemID from '+@DBName+'.dbo.t_department where Fnumber=(select FNumber from t_department where FItemID=t.FDepartmentID)),0),'+'isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=3 and Fnumber=(select FNumber from T_Item where FItemClassID=3 and FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from t_Emp t where FItemID='+@FItemID;
                                 EXEC (@sql); 
                                
                    --                          SET @Sql = 'update ' + @DBName
                    --+ '.dbo.T_Item set FFullName=FName where FItemClassID=3 and   FITemID='
                    --                + @FItemID
                    --EXEC (@sql)  

                             END;
                     END;
             END;
	           
        
				
		-----3. 删除 ----
         IF EXISTS
(
    SELECT *
    FROM Deleted
)
            AND (NOT EXISTS
(
    SELECT *
    FROM Inserted
))
             BEGIN
                 SELECT @DBName = FDBName
                 FROM t_BOS_Synchro
                 WHERE FK3Name = '帐套同步';
                 SELECT @FItemID = FItemID,
                        @FNumber = FNumber
                 FROM deleted;
                 SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=3 and  FNumber='''+@FNumber+'''';
                 EXEC (@sql);
                 SET @Sql = 'delete from '+@DBName+'.dbo.t_Emp where FNumber='''+@FNumber+'''';
                 EXEC (@sql);
             END;
		-----3. 删除 End ----





         IF(@ERROR <> 0)
             ROLLBACK TRANSACTION;
             ELSE
         COMMIT TRANSACTION;
     END;
GO
 
 ------4 t_icitem 触发器
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[TR_t_ICItem]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER TR_t_ICItem;
GO
 
--PRINT '1' ELSE PRINT '0'
--EXEC sp_helptext TR_t_ICItem
--备份系统原有的触发器
     
--   CREATE TRIGGER TR_t_ICItem ON t_ICItem     
--        INSTEAD OF INSERT,UPDATE,DELETE        
--        AS        
--        BEGIN        
--           BEGIN TRANSACTION        
--           SET NOCOUNT ON        
--           IF EXISTS(SELECT * FROM Deleted)        
--           BEGIN        
--            DELETE t_ICItemCore FROM t_ICItemCore INNER JOIN Deleted        
--                ON t_ICItemCore.FItemID=Deleted.FItemID        
--                DELETE t_ICItemBase FROM t_ICItemBase INNER JOIN Deleted        
--                ON t_ICItemBase.FItemID=Deleted.FItemID        
--                DELETE t_ICItemMaterial FROM t_ICItemMaterial INNER JOIN Deleted        
--                ON t_ICItemMaterial.FItemID=Deleted.FItemID         
--                DELETE t_ICItemPlan FROM t_ICItemPlan INNER JOIN Deleted         
--                ON t_ICItemPlan.FItemID=Deleted.FItemID        
--                DELETE t_ICItemDesign FROM t_ICItemDesign INNER JOIN Deleted         
--                ON t_ICItemDesign.FItemID=Deleted.FitemID        
--                DELETE t_ICItemStandard FROM t_ICItemStandard INNER JOIN Deleted        
--                ON t_ICItemStandard.FItemID=Deleted.FItemID        
--                DELETE t_ICItemQuality FROM t_ICItemQuality INNER JOIN Deleted        
--                ON t_ICItemQuality.FItemID=Deleted.FItemID        
--                DELETE T_BASE_ICItemEntrance FROM T_BASE_ICItemEntrance INNER JOIN Deleted        
--                ON T_BASE_ICItemEntrance.FItemID=Deleted.FItemID        
--                DELETE t_ICItemCustom FROM t_ICItemCustom INNER JOIN Deleted        
--                ON t_ICItemCustom.FItemID=Deleted.FItemID        
                      
--            END        
--            IF EXISTS (SELECT * FROM Inserted)        
--            BEGIN      
          
--        INSERT INTO t_ICItemCore ( FItemID,FModel,FName,FHelpCode,FDeleted,FShortNumber,FNumber,FParentID,FBrNo,FTopID,FRP,FOmortize,FOmortizeScale,FForSale,FStaCost,FOrderPrice,FOrderMethod,FPriceFixingType,FSalePriceFixingType,FPerWastage,FARAcctID,  
--        FPlanPriceMethod,FPlanClass,FPY,FPinYin)  SELECT FItemID,FModel,FName,FHelpCode,ISNULL(FDeleted,0),FShortNumber,FNumber,ISNULL(FParentID,0),ISNULL(FBrNo,'0'),ISNULL(FTopID,0),FRP,FOmortize,FOmortizeScale,ISNULL(FForSale,0),FStaCost,FOrderPrice,
--        FOrderMethod,  
--FPriceFixingType,FSalePriceFixingType,ISNULL(FPerWastage,0),FARAcctID,FPlanPriceMethod,FPlanClass,ISNULL(FPY,' '),ISNULL(FPinYin,' ') FROM Inserted     
--INSERT INTO t_ICItemBase ( FItemID,FErpClsID,FUnitID,FUnitGroupID,FDefaultLoc,FSPID,FSource,FQtyDecimal,  
--        FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,FSecUnitID,FSecCoefficient,FSecUnitDecimal,FAlias,FOrderUnitID,FSaleUnitID,FStoreUnitID,FProductUnitID,FApproveNo,FAuxClassID,FTypeID,FPreDeadLine,FSerialClassID,  
--FDefaultReadyLoc,FSPIDReady)  SELECT FItemID,FErpClsID,ISNULL(FUnitID,0),ISNULL(FUnitGroupID,0),FDefaultLoc,ISNULL(FSPID,0),FSource,ISNULL(FQtyDecimal,2),ISNULL(FLowLimit,0),ISNULL(FHighLimit,0),ISNULL(FSecInv,1),ISNULL(FUseState,341),ISNULL(FIsEquipment,
--0),  
--FEquipmentNum,ISNULL(FIsSparePart,0),FFullName,ISNULL(FSecUnitID,0),ISNULL(FSecCoefficient,0),ISNULL(FSecUnitDecimal,0),FAlias,ISNULL(FOrderUnitID,0),ISNULL(FSaleUnitID,0),ISNULL(FStoreUnitID,0),ISNULL(FProductUnitID,0),FApproveNo,ISNULL(FAuxClassID,0),  
--FTypeID,FPreDeadLine,ISNULL(FSerialClassID,0),ISNULL(FDefaultReadyLoc,0),ISNULL(FSPIDReady,0) FROM Inserted     INSERT INTO t_ICItemMaterial ( FItemID,FOrderRector,FPOHghPrcMnyType,FPOHighPrice,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale
--,  
--FProfitRate,FSalePrice,FBatchManager,FISKFPeriod,FKFPeriod,FTrack,FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,FGoodSpec,FCostProject,FIsSnManage,FStockTime,FBookPlan,FBeforeExpire,FTaxRate,FAdminAcctID,FNote,FIsSpecialTax,FSOHighLimit,  
--FSOLowLimit,FOIHighLimit,FOILowLimit,FDaysPer,FLastCheckDate,FCheckCycle,FCheckCycUnit,FStockPrice,FABCCls,FBatchQty,FClass,FCostDiffRate,FDepartment,FSaleTaxAcctID,FCBBmStandardID,FCBRestore,FPickHighLimit,FPickLowLimit,FOnlineShopPName,FOnlineShopPNo)  
  
--SELECT FItemID,FOrderRector,isnull(FPOHghPrcMnyType,1),isnull(FPOHighPrice,0),FWWHghPrc,isnull(FWWHghPrcMnyType,1),FSOLowPrc,isnull(FSOLowPrcMnyType,1),isnull(FIsSale,' '),FProfitRate,FSalePrice,isnull(FBatchManager,0),isnull(FISKFPeriod,0),  
--isnull(FKFPeriod,0),FTrack,FPlanPrice,isnull(FPriceDecimal,2),FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,isnull(FGoodSpec,0),isnull(FCostProject,0),FIsSnManage,isnull(FStockTime,0),FBookPlan,FBeforeExpire,isnull(FTaxRate,17),isnull(FAdminAcctID,0),FNote,  
--FIsSpecialTax,isnull(FSOHighLimit,100),isnull(FSOLowLimit,100),isnull(FOIHighLimit,100),isnull(FOILowLimit,100),FDaysPer,FLastCheckDate,FCheckCycle,FCheckCycUnit,isnull(FStockPrice,0),FABCCls,FBatchQty,isnull(FClass,0),FCostDiffRate,isnull(FDepartment,0),
--FSaleTaxAcctID,  
--isnull(FCBBmStandardID,0),FCBRestore,FPickHighLimit,FPickLowLimit,FOnlineShopPName,FOnlineShopPNo FROM Inserted     INSERT INTO t_ICItemPlan ( FItemID,FPlanTrategy,FOrderTrategy,FLeadTime,FFixLeadTime,FTotalTQQ,FQtyMin,FQtyMax,FCUUnitID,FOrderInterVal,  
--FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FDailyConsume,FMRPCon,FPlanner,FPutInteger,FInHighLimit,FInLowLimit,FLowestBomCode,FMRPOrder,FIsCharSourceItem,  
--FCharSourceItemID,FPlanMode,FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability,FIsBackFlush,FBackFlushStockID,FBackFlushSPID,FBatchSplitDays,FBatchSplit,FIsFixedReOrder)  SELECT FItemID,isnull(FPlanTrategy,321),isnull(FOrderTrategy,331),isnull(FLeadTime,0)  
--,isnull(FFixLeadTime,0),isnull(FTotalTQQ,1),isnull(FQtyMin,1),isnull(FQtyMax,10000),isnull(FCUUnitID,0),isnull(FOrderInterVal,1),FBatchAppendQty,isnull(FOrderPoint,1),isnull(FBatFixEconomy,1),isnull(FBatChangeEconomy,1),isnull(FRequirePoint,1),  
--isnull(FPlanPoint,1),isnull(FDefaultRoutingID,1),isnull(FDefaultWorkTypeID,0),isnull(FProductPrincipal,' '),FDailyConsume,isnull(FMRPCon,1),FPlanner,isnull(FPutInteger,0),isnull(FInHighLimit,0),isnull(FInLowLimit,0),FLowestBomCode,isnull(FMRPOrder,0),  
--FIsCharSourceItem,FCharSourceItemID,isnull(FPlanMode,14036),FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability,isnull(FIsBackFlush,0),FBackFlushStockID,FBackFlushSPID,isnull(FBatchSplitDays,0),isnull(FBatchSplit,0),isnull(FIsFixedReOrder,0) FROM Ins
--erted       
--INSERT INTO t_ICItemDesign ( FItemID,FChartNumber,FIsKeyItem,FMaund,FGrossWeight,FNetWeight,FCubicMeasure,FLength,FWidth,FHeight,FSize,FVersion,FStartService,FMakeFile,FIsFix,FTtermOfService,FTtermOfUsefulTime)  SELECT FItemID,FChartNumber,isnull(FIsKeyItem,0)  
--,isnull(FMaund,0),isnull(FGrossWeight,0),isnull(FNetWeight,0),isnull(FCubicMeasure,0),isnull(FLength,0),isnull(FWidth,0),isnull(FHeight,0),isnull(FSize,0),FVersion,isnull(FStartService,0),isnull(FMakeFile,0),isnull(FIsFix,0),isnull(FTtermOfService,0),  
--isnull(FTtermOfUsefulTime,0) FROM Inserted     INSERT INTO t_ICItemStandard ( FItemID,FStandardCost,FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,FStdBatchQty,FPOVAcctID,FPIVAcctID,FMCVAcctID,FPCVAcctID,FSLAcctID,FCAVAcctID,  
--FCBAppendRate,FCBAppendProject,FCostBomID,FCBRouting,FOutMachFeeProject)  SELECT FItemID,isnull(FStandardCost,0),isnull(FStandardManHour,0),isnull(FStdPayRate,0),isnull(FChgFeeRate,0),isnull(FStdFixFeeRate,0),isnull(FOutMachFee,0),isnull(FPieceRate,0),  
--isnull(FStdBatchQty,1),FPOVAcctID,FPIVAcctID,FMCVAcctID,FPCVAcctID,FSLAcctID,FCAVAcctID,FCBAppendRate,FCBAppendProject,isnull(FCostBomID,0),isnull(FCBRouting,0),FOutMachFeeProject FROM Inserted     INSERT INTO t_ICItemQuality ( FItemID,FInspectionLevel,  
--FInspectionProject,FIsListControl,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,FStkChkPrd,FStkChkAlrm,FIdentifier,FSampStdCritical,FSampStdStrict,FSampStdSlight)  SELECT FItemID,isnull(FInspectionLevel,352),isnull(FInspectionProject,0),  
--FIsListControl,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,isnull(FStkChkPrd,9999),isnull(FStkChkAlrm,0),isnull(FIdentifier,' '),FSampStdCritical,FSampStdStrict,FSampStdSlight FROM Inserted       
--INSERT INTO T_BASE_ICItemEntrance ( FItemID,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,FFirstUnitRate,FSecondUnitRate,FIsManage,FPackType,FLenDecimal,FCubageDecimal,FWeightDecimal,FImpostTaxRate,FConsumeTaxRate,FManageType,FExportRate)    
--SELECT FItemID,FNameEn,FModelEn,FHSNumber,FFirstUnit,FSecondUnit,isnull(FFirstUnitRate,0),isnull(FSecondUnitRate,0),isnull(FIsManage,0),FPackType,isnull(FLenDecimal,2),isnull(FCubageDecimal,4),isnull(FWeightDecimal,2),isnull(FImpostTaxRate,0),  
--isnull(FConsumeTaxRate,0),FManageType,FExportRate FROM Inserted       
--INSERT INTO t_ICItemCustom(FItemID) SELECT  FItemID FROM Inserted      
--        END      
--        IF (@@error <> 0)        
--            ROLLBACK TRANSACTION        
--        ELSE        
--            COMMIT TRANSACTION        
--        END 
----GO

GO
CREATE TRIGGER [dbo].[TR_t_ICItem] ON [dbo].[t_ICItem]
INSTEAD OF INSERT, UPDATE, DELETE
AS
     DECLARE @FItemID VARCHAR(10);
     DECLARE @FNumber VARCHAR(100);
     DECLARE @DBName VARCHAR(100);
     DECLARE @Sql VARCHAR(8000);
     DECLARE @InsertSQL VARCHAR(8000);
     DECLARE @T_ItemSQL VARCHAR(8000);
     DECLARE @IsHere VARCHAR(10);
     DECLARE @FDetail VARCHAR(10);
     DECLARE @FParentID VARCHAR(50);
     DECLARE @FItemidTemp VARCHAR(50);
     DECLARE @NewFNumber VARCHAR(50);
     DECLARE @FErpClsID VARCHAR(50);
     DECLARE @FSource VARCHAR(50);
     DECLARE @NewFSource VARCHAR(50);
     DECLARE @pp2 INT;
     DECLARE @strSQL NVARCHAR(4000);
     BEGIN
         BEGIN TRANSACTION;
         SET NOCOUNT ON;
         IF EXISTS
(
    SELECT *
    FROM Deleted
)
             BEGIN
                 DELETE t_ICItemCore
                 FROM t_ICItemCore
                      INNER JOIN Deleted ON t_ICItemCore.FItemID = Deleted.FItemID;
                 DELETE t_ICItemBase
                 FROM t_ICItemBase
                      INNER JOIN Deleted ON t_ICItemBase.FItemID = Deleted.FItemID;
                 DELETE t_ICItemMaterial
                 FROM t_ICItemMaterial
                      INNER JOIN Deleted ON t_ICItemMaterial.FItemID = Deleted.FItemID;
                 DELETE t_ICItemPlan
                 FROM t_ICItemPlan
                      INNER JOIN Deleted ON t_ICItemPlan.FItemID = Deleted.FItemID;
                 DELETE t_ICItemDesign
                 FROM t_ICItemDesign
                      INNER JOIN Deleted ON t_ICItemDesign.FItemID = Deleted.FitemID;
                 DELETE t_ICItemStandard
                 FROM t_ICItemStandard
                      INNER JOIN Deleted ON t_ICItemStandard.FItemID = Deleted.FItemID;
                 DELETE t_ICItemQuality
                 FROM t_ICItemQuality
                      INNER JOIN Deleted ON t_ICItemQuality.FItemID = Deleted.FItemID;
                 DELETE T_BASE_ICItemEntrance
                 FROM T_BASE_ICItemEntrance
                      INNER JOIN Deleted ON T_BASE_ICItemEntrance.FItemID = Deleted.FItemID;
                 DELETE t_ICItemCustom
                 FROM t_ICItemCustom
                      INNER JOIN Deleted ON t_ICItemCustom.FItemID = Deleted.FItemID;
             END;
         IF EXISTS
(
    SELECT *
    FROM Inserted
)
             BEGIN
                 INSERT INTO t_ICItemCore
(FItemID,
 FModel,
 FName,
 FHelpCode,
 FDeleted,
 FShortNumber,
 FNumber,
 FParentID,
 FBrNo,
 FTopID,
 FRP,
 FOmortize,
 FOmortizeScale,
 FForSale,
 FStaCost,
 FOrderPrice,
 FOrderMethod,
 FPriceFixingType,
 FSalePriceFixingType,
 FPerWastage,
 FARAcctID,
 FPlanPriceMethod,
 FPlanClass,
 FPY,
 FPinYin
)
                        SELECT FItemID,
                               FModel,
                               FName,
                               FHelpCode,
                               ISNULL(FDeleted, 0),
                               FShortNumber,
                               FNumber,
                               ISNULL(FParentID, 0),
                               ISNULL(FBrNo, '0'),
                               ISNULL(FTopID, 0),
                               FRP,
                               FOmortize,
                               FOmortizeScale,
                               ISNULL(FForSale, 0),
                               FStaCost,
                               FOrderPrice,
                               FORderMethod,
                               FPriceFixingType,
                               FSalePriceFixingType,
                               ISNULL(FPerWastage, 0),
                               FARAcctID,
                               FPlanPriceMethod,
                               FPlanClass,
                               ISNULL(FPY, ' '),
                               ISNULL(FPinYin, ' ')
                        FROM Inserted;
                 INSERT INTO t_ICItemBase
(FItemID,
 FErpClsID,
 FUnitID,
 FUnitGroupID,
 FDefaultLoc,
 FSPID,
 FSource,
 FQtyDecimal,
 FLowLimit,
 FHighLimit,
 FSecInv,
 FUseState,
 FIsEquipment,
 FEquipmentNum,
 FIsSparePart,
 FFullName,
 FSecUnitID,
 FSecCoefficient,
 FSecUnitDecimal,
 FAlias,
 FOrderUnitID,
 FSaleUnitID,
 FStoreUnitID,
 FProductUnitID,
 FApproveNo,
 FAuxClassID,
 FTypeID,
 FPreDeadLine,
 FSerialClassID,
 FDefaultReadyLoc,
 FSPIDReady
)
                        SELECT FItemID,
                               FErpClsID,
                               ISNULL(FUnitID, 0),
                               ISNULL(FUnitGroupID, 0),
                               FDefaultLoc,
                               ISNULL(FSPID, 0),
                               FSource,
                               ISNULL(FQtyDecimal, 2),
                               ISNULL(FLowLimit, 0),
                               ISNULL(FHighLimit, 0),
                               ISNULL(FSecInv, 1),
                               ISNULL(FUseState, 341),
                               ISNULL(FIsEquipment, 0),
                               FEquipmentNum,
                               ISNULL(FIsSparePart, 0),
                               FFullName,
                               ISNULL(FSecUnitID, 0),
                               ISNULL(FSecCoefficient, 0),
                               ISNULL(FSecUnitDecimal, 0),
                               FAlias,
                               ISNULL(FOrderUnitID, 0),
                               ISNULL(FSaleUnitID, 0),
                               ISNULL(FStoreUnitID, 0),
                               ISNULL(FProductUnitID, 0),
                               FApproveNo,
                               ISNULL(FAuxClassID, 0),
                               FTypeID,
                               FPreDeadLine,
                               ISNULL(FSerialClassID, 0),
                               ISNULL(FDefaultReadyLoc, 0),
                               ISNULL(FSPIDReady, 0)
                        FROM Inserted;
                 INSERT INTO t_ICItemMaterial
(FItemID,
 FOrderRector,
 FPOHghPrcMnyType,
 FPOHighPrice,
 FWWHghPrc,
 FWWHghPrcMnyType,
 FSOLowPrc,
 FSOLowPrcMnyType,
 FIsSale,
 FProfitRate,
 FSalePrice,
 FBatchManager,
 FISKFPeriod,
 FKFPeriod,
 FTrack,
 FPlanPrice,
 FPriceDecimal,
 FAcctID,
 FSaleAcctID,
 FCostAcctID,
 FAPAcctID,
 FGoodSpec,
 FCostProject,
 FIsSnManage,
 FStockTime,
 FBookPlan,
 FBeforeExpire,
 FTaxRate,
 FAdminAcctID,
 FNote,
 FIsSpecialTax,
 FSOHighLimit,
 FSOLowLimit,
 FOIHighLimit,
 FOILowLimit,
 FDaysPer,
 FLastCheckDate,
 FCheckCycle,
 FCheckCycUnit,
 FStockPrice,
 FABCCls,
 FBatchQty,
 FClass,
 FCostDiffRate,
 FDepartment,
 FSaleTaxAcctID,
 FCBBmStandardID,
 FCBRestore,
 FPickHighLimit,
 FPickLowLimit,
 FOnlineShopPName,
 FOnlineShopPNo
)
                        SELECT FItemID,
                               FOrderRector,
                               isnull(FPOHghPrcMnyType, 1),
                               isnull(FPOHighPrice, 0),
                               FWWHghPrc,
                               isnull(FWWHghPrcMnyType, 1),
                               FSOLowPrc,
                               isnull(FSOLowPrcMnyType, 1),
                               isnull(FIsSale, ' '),
                               FProfitRate,
                               FSalePrice,
                               isnull(FBatchManager, 0),
                               isnull(FISKFPeriod, 0),
                               ISNULL(FKFPeriod, 0),
                               FTrack,
                               FPlanPrice,
                               isnull(FPriceDecimal, 2),
                               FAcctID,
                               FSaleAcctID,
                               FCostAcctID,
                               FAPAcctID,
                               isnull(FGoodSpec, 0),
                               isnull(FCostProject, 0),
                               FIsSnManage,
                               isnull(FStockTime, 0),
                               FBookPlan,
                               FBeforeExpire,
                               isnull(FTaxRate, 17),
                               isnull(FAdminAcctID, 0),
                               FNote,
                               FIsSpecialTax,
                               isnull(FSOHighLimit, 100),
                               isnull(FSOLowLimit, 100),
                               isnull(FOIHighLimit, 100),
                               isnull(FOILowLimit, 100),
                               FDaysPer,
                               FLastCheckDate,
                               FCheckCycle,
                               FCheckCycUnit,
                               isnull(FStockPrice, 0),
                               FABCCls,
                               FBatchQty,
                               isnull(FClass, 0),
                               FCostDiffRate,
                               isnull(FDepartment, 0),
                               FSaleTaxAcctID,
                               ISNULL(FCBBmStandardID, 0),
                               FCBRestore,
                               FPickHighLimit,
                               FPickLowLimit,
                               FOnlineShopPName,
                               FOnlineShopPNo
                        FROM Inserted;
                 INSERT INTO t_ICItemPlan
(FItemID,
 FPlanTrategy,
 FOrderTrategy,
 FLeadTime,
 FFixLeadTime,
 FTotalTQQ,
 FQtyMin,
 FQtyMax,
 FCUUnitID,
 FOrderInterVal,
 FBatchAppendQty,
 FOrderPoint,
 FBatFixEconomy,
 FBatChangeEconomy,
 FRequirePoint,
 FPlanPoint,
 FDefaultRoutingID,
 FDefaultWorkTypeID,
 FProductPrincipal,
 FDailyConsume,
 FMRPCon,
 FPlanner,
 FPutInteger,
 FInHighLimit,
 FInLowLimit,
 FLowestBomCode,
 FMRPOrder,
 FIsCharSourceItem,
 FCharSourceItemID,
 FPlanMode,
 FCtrlType,
 FCtrlStraregy,
 FContainerName,
 FKanBanCapability,
 FIsBackFlush,
 FBackFlushStockID,
 FBackFlushSPID,
 FBatchSplitDays,
 FBatchSplit,
 FIsFixedReOrder
)
                        SELECT FItemID,
                               isnull(FPlanTrategy, 321),
                               isnull(FOrderTrategy, 331),
                               isnull(FLeadTime, 0),
                               isnull(FFixLeadTime, 0),
                               isnull(FTotalTQQ, 1),
                               isnull(FQtyMin, 1),
                               isnull(FQtyMax, 10000),
                               isnull(FCUUnitID, 0),
                               isnull(FOrderInterVal, 1),
                               FBatchAppendQty,
                               isnull(FOrderPoint, 1),
                               ISNULL(FBatFixEconomy, 1),
                               isnull(FBatChangeEconomy, 1),
                               isnull(FRequirePoint, 1),
                               ISNULL(FPlanPoint, 1),
                               isnull(FDefaultRoutingID, 1),
                               isnull(FDefaultWorkTypeID, 0),
                               isnull(FProductPrincipal, ' '),
                               FDailyConsume,
                               isnull(FMRPCon, 1),
                               FPlanner,
                               isnull(FPutInteger, 0),
                               isnull(FInHighLimit, 0),
                               isnull(FInLowLimit, 0),
                               FLowestBomCode,
                               isnull(FMRPOrder, 0),
                               FIsCharSourceItem,
                               FCharSourceItemID,
                               isnull(FPlanMode, 14036),
                               FCtrlType,
                               FCtrlStraregy,
                               FContainerName,
                               FKanBanCapability,
                               isnull(FIsBackFlush, 0),
                               FBackFlushStockID,
                               FBackFlushSPID,
                               isnull(FBatchSplitDays, 0),
                               isnull(FBatchSplit, 0),
                               isnull(FIsFixedReOrder, 0)
                        FROM Inserted;
                 INSERT INTO t_ICItemDesign
(FItemID,
 FChartNumber,
 FIsKeyItem,
 FMaund,
 FGrossWeight,
 FNetWeight,
 FCubicMeasure,
 FLength,
 FWidth,
 FHeight,
 FSize,
 FVersion,
 FStartService,
 FMakeFile,
 FIsFix,
 FTtermOfService,
 FTtermOfUsefulTime
)
                        SELECT FItemID,
                               FChartNumber,
                               isnull(FIsKeyItem, 0),
                               isnull(FMaund, 0),
                               isnull(FGrossWeight, 0),
                               isnull(FNetWeight, 0),
                               isnull(FCubicMeasure, 0),
                               isnull(FLength, 0),
                               isnull(FWidth, 0),
                               isnull(FHeight, 0),
                               isnull(FSize, 0),
                               FVersion,
                               isnull(FStartService, 0),
                               isnull(FMakeFile, 0),
                               isnull(FIsFix, 0),
                               isnull(FTtermOfService, 0),
                               ISNULL(FTtermOfUsefulTime, 0)
                        FROM Inserted;
                 INSERT INTO t_ICItemStandard
(FItemID,
 FStandardCost,
 FStandardManHour,
 FStdPayRate,
 FChgFeeRate,
 FStdFixFeeRate,
 FOutMachFee,
 FPieceRate,
 FStdBatchQty,
 FPOVAcctID,
 FPIVAcctID,
 FMCVAcctID,
 FPCVAcctID,
 FSLAcctID,
 FCAVAcctID,
 FCBAppendRate,
 FCBAppendProject,
 FCostBomID,
 FCBRouting,
 FOutMachFeeProject
)
                        SELECT FItemID,
                               isnull(FStandardCost, 0),
                               isnull(FStandardManHour, 0),
                               isnull(FStdPayRate, 0),
                               isnull(FChgFeeRate, 0),
                               isnull(FStdFixFeeRate, 0),
                               isnull(FOutMachFee, 0),
                               isnull(FPieceRate, 0),
                               isnull(FStdBatchQty, 1),
                               FPOVAcctID,
                               FPIVAcctID,
                               FMCVAcctID,
                               FPCVAcctID,
                               FSLAcctID,
                               FCAVAcctID,
                               FCBAppendRate,
                               FCBAppendProject,
                               isnull(FCostBomID, 0),
                               isnull(FCBRouting, 0),
                               FOutMachFeeProject
                        FROM Inserted;
                 INSERT INTO t_ICItemQuality
(FItemID,
 FInspectionLevel,
 FInspectionProject,
 FIsListControl,
 FProChkMde,
 FWWChkMde,
 FSOChkMde,
 FWthDrwChkMde,
 FStkChkMde,
 FOtherChkMde,
 FStkChkPrd,
 FStkChkAlrm,
 FIdentifier,
 FSampStdCritical,
 FSampStdStrict,
 FSampStdSlight
)
                        SELECT FItemID,
                               isnull(FInspectionLevel, 352),
                               ISNULL(FInspectionProject, 0),
                               FIsListControl,
                               FProChkMde,
                               FWWChkMde,
                               FSOChkMde,
                               FWthDrwChkMde,
                               FStkChkMde,
                               FOtherChkMde,
                               isnull(FStkChkPrd, 9999),
                               isnull(FStkChkAlrm, 0),
                               isnull(FIdentifier, ' '),
                               FSampStdCritical,
                               FSampStdStrict,
                               FSampStdSlight
                        FROM Inserted;
                 INSERT INTO T_BASE_ICItemEntrance
(FItemID,
 FNameEn,
 FModelEn,
 FHSNumber,
 FFirstUnit,
 FSecondUnit,
 FFirstUnitRate,
 FSecondUnitRate,
 FIsManage,
 FPackType,
 FLenDecimal,
 FCubageDecimal,
 FWeightDecimal,
 FImpostTaxRate,
 FConsumeTaxRate,
 FManageType,
 FExportRate
)
                        SELECT FItemID,
                               FNameEn,
                               FModelEn,
                               FHSNumber,
                               FFirstUnit,
                               FSecondUnit,
                               isnull(FFirstUnitRate, 0),
                               isnull(FSecondUnitRate, 0),
                               isnull(FIsManage, 0),
                               FPackType,
                               isnull(FLenDecimal, 2),
                               isnull(FCubageDecimal, 4),
                               isnull(FWeightDecimal, 2),
                               isnull(FImpostTaxRate, 0),
                               isnull(FConsumeTaxRate, 0),
                               FManageType,
                               FExportRate
                        FROM Inserted;
                 INSERT INTO t_ICItemCustom(FItemID)
                        SELECT FItemID
                        FROM Inserted;
             END;
        
               
        
-----删除	
         IF EXISTS
(
    SELECT *
    FROM Deleted
)
            AND (NOT EXISTS
(
    SELECT *
    FROM Inserted
))
             BEGIN
                 SELECT @DBName = FDBName
                 FROM t_BOS_Synchro
                 WHERE FK3Name = '帐套同步';
                 IF LEN(@DBName) > 0
                     BEGIN
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM deleted;
                         SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=4 and  FNumber='''+@FNumber+'''';
                         EXEC (@sql);
                         SET @Sql = 'delete from '+@DBName+'.dbo.t_ICItem where FNumber='''+@FNumber+'''';
                         EXEC (@sql);
                     END;
             END;
				
				
----同步添加(开始)    
         IF EXISTS
(
    SELECT *
    FROM Inserted
)
             BEGIN
                 SELECT @DBName = FDBName
                 FROM t_BOS_Synchro
                 WHERE FK3Name = '帐套同步';
                 IF LEN(@DBName) > 0
                     BEGIN
                         SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_ICItem (FHelpCode,FModel,FErpClsID,FTypeID,'+'FAuxClassID,FUnitGroupID,FUnitID,FOrderUnitID,FSaleUnitID,FProductUnitID,FStoreUnitID,FSecUnitID,'+'FSource,FDefaultLoc,FOrderRector,FAcctID,FSaleAcctID,FCostAcctID,FAPAcctID,FAdminAcctID,'+'FSecCoefficient,FSPID,FQtyDecimal,'+'FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,FApproveNo,FAlias,'+'FPOHighPrice,FPOHghPrcMnyType,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,FProfitRate,FOrderPrice,'+'FSalePrice,FIsSpecialTax,FISKFPeriod,FKFPeriod,FStockTime,FBatchManager,FBeforeExpire,FCheckCycUnit,FOIHighLimit,'+'FOILowLimit,FSOHighLimit,FSOLowLimit,FInHighLimit,FInLowLimit,FTrack,FPlanPrice,'+'FPriceDecimal,FGoodSpec,FTaxRate,FCostProject,FIsSNManage,'+'FNote,FPlanTrategy,FPlanMode,'+'FOrderTrategy,FFixLeadTime,FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,FBatchAppendQty,FOrderPoint,FBatFixEconomy,'+'FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,'+'FPutInteger,FDailyConsume,FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,FNetWeight,'+'FMaund,FLength,FWidth,FHeight,FSize,FCubicMeasure,FStandardCost,'+'FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,'+'FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,'+'FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,FVersion,FNameEn,FModelEn,FHSNumber,'+'FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,'+'FWeightDecimal,FIsCharSourceItem,FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability,'+'FShortNumber,FNumber,FName,FParentID,FItemID)  ';
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ';
                         IF EXISTS
(
    SELECT *
    FROM deleted
)
                             BEGIN
                                 SELECT @FItemID = FItemID,
                                        @FNumber = FNumber
                                 FROM deleted;
                                 SELECT @NewFNumber = FNumber,
                                        @FErpClsID = FErpClsID,
                                        @FSource = FSource
                                 FROM inserted;
                             END;
                         IF NOT EXISTS
(
    SELECT *
    FROM deleted
)
                             BEGIN
                                 SELECT @FItemID = FItemID,
                                        @FNumber = FNumber,
                                        @FErpClsID = FErpClsID,
                                        @FSource = FSource
                                 FROM inserted;
                             END;
                         SET @FItemidTemp = 0;
                         SET @strSQL = ' select @p2=FItemID from '+@DBName+'.dbo.T_Item where  FItemClassID=4 and Fnumber='+''''+@FNumber+'''';
                         EXEC sp_executesql
                              @strSQL,
                              N'@p2   int   output ',
                              @FItemidTemp OUTPUT;
                         IF @FItemidTemp = 0
                             BEGIN
                                 SET @strSQL = ' exec '+@DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394';
                                 EXEC sp_executesql
                                      @StrSQL,
                                      N'@p2   int   output ',
                                      @FItemidTemp OUTPUT;
                             END;
		

		-------
                         SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=4 and FItemID='+@FItemidTemp;
                         EXEC (@sql);
                         SET @Sql = 'delete from '+@DBName+'.dbo.T_Icitem where FItemID='+@FItemidTemp;
                         EXEC (@sql);
		
		------	t_Item ----
                         SET @Sql = @T_ItemSQL+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item where  FItemClassID=4 and Fnumber=(select top 1 FNumber from T_Item where  FItemClassID=4 and FItemID=a.FParentID)),0),'+@FItemidTemp+' from T_Item a where FITemID='+@FItemID;
                         EXEC (@SQL);
                         SET @Sql = ' update  '+@DBName+'.dbo.t_Item set FName=FName where FItemID='+CAST(@FItemidTemp AS VARCHAR(10));
                         EXEC (@sql);
                         SET @Sql = @InsertSQL+' select  FHelpCode,FModel,FErpClsID,FTypeID,'+'isnull((select top 1 FItemClassID as FAuxClassID from  '+@DBName+'.dbo.t_ItemClass where FNumber=(select top 1 FNumber from t_ItemClass where FItemClassID=a.FAuxClassID)),0),'+'isnull((select top 1 FUnitGroupID from  '+@DBName+'.dbo.t_UnitGroup where FName=(select top 1 FName from t_UnitGroup where FUnitGroupID=a.FUnitGroupID)),0),'+'isnull((select top 1 FMeasureUnitID as FUnitID from  '+@DBName+'.dbo.t_measureunit where FNumber=(select top 1 FNumber from t_measureunit where FMeasureUnitID=a.FUnitID)),0),'+'isnull((select top 1 FMeasureUnitID as FOrderUnitID from  '+@DBName+'.dbo.t_measureunit where FNumber=(select top 1 FNumber from t_measureunit where FMeasureUnitID=a.FOrderUnitID)),0),'+'isnull((select top 1 FMeasureUnitID as FSaleUnitID from  '+@DBName+'.dbo.t_measureunit where FNumber=(select top 1 FNumber from t_measureunit where FMeasureUnitID=a.FSaleUnitID)),0),'+'isnull((select top 1 FMeasureUnitID as FProductUnitID from  '+@DBName+'.dbo.t_measureunit where FNumber=(select top 1 FNumber from t_measureunit where FMeasureUnitID=a.FProductUnitID)),0),'+'isnull((select top 1 FMeasureUnitID as FStoreUnitID from  '+@DBName+'.dbo.t_measureunit where FNumber=(select top 1 FNumber from t_measureunit where FMeasureUnitID=a.FStoreUnitID)),0),'+'isnull((select top 1 FMeasureUnitID as FSecUnitID from  '+@DBName+'.dbo.t_measureunit where FNumber=(select top 1 FNumber from t_measureunit where FMeasureUnitID=a.FSecUnitID)),0),'+'FSource,FDefaultLoc,'+
			--'isnull((select  FItemID  from  ' +
			--@DBName+'.dbo.t_supplier where FNumber=(select top 1 FNumber from t_supplier where FItemID=a.FSource)),0),'+
			--'isnull((select FItemID from  ' +
			--@DBName+'.dbo.t_stock where FNumber=(select top 1 FNumber from t_stock where FItemID=a.FDefaultLoc)),0),'+
			--'isnull((select FItemID from  ' +
			--@DBName+'.dbo.t_stock where FNumber=(select top 1 FNumber from t_stock where FItemID=a.FDefaultReadyLoc)),0),'+
				
                         'isnull((select FItemID from '+@DBName+'.dbo.t_emp where FNumber=(select top 1 FNumber from t_emp where FItemID=a.FOrderRector)),0),'+'isnull((select FAccountID from  '+@DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=a.FAcctID)),0),'+'isnull((select FAccountID from  '+@DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=a.FSaleAcctID)),0),'+'isnull((select FAccountID from  '+@DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=a.FCostAcctID)),0),'+'isnull((select FAccountID from  '+@DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=a.FAPAcctID)),0),'+'isnull((select FAccountID from  '+@DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=a.FAdminAcctID)),0),'+'FSecCoefficient,FSPID,FQtyDecimal,'+'FLowLimit,FHighLimit,FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,FFullName,FApproveNo,FAlias,'+'FPOHighPrice,FPOHghPrcMnyType,FWWHghPrc,FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,FProfitRate,FOrderPrice,'+'FSalePrice,FIsSpecialTax,FISKFPeriod,FKFPeriod,FStockTime,FBatchManager,FBeforeExpire,FCheckCycUnit,FOIHighLimit,'+'FOILowLimit,FSOHighLimit,FSOLowLimit,FInHighLimit,FInLowLimit,FTrack,FPlanPrice,'+'FPriceDecimal,FGoodSpec,FTaxRate,FCostProject,FIsSNManage,'+'FNote,FPlanTrategy,FPlanMode,'+'FOrderTrategy,FFixLeadTime,FLeadTime,FTotalTQQ,FOrderInterVal,FQtyMin,FQtyMax,FBatchAppendQty,FOrderPoint,FBatFixEconomy,'+'FBatChangeEconomy,FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,FPlanner,'+'FPutInteger,FDailyConsume,FMRPCon,FMRPOrder,FChartNumber,FIsKeyItem,FGrossWeight,FNetWeight,'+'FMaund,FLength,FWidth,FHeight,FSize,FCubicMeasure,FStandardCost,'+'FStandardManHour,FStdPayRate,FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,'+'FInspectionLevel,FProChkMde,FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,'+'FStkChkPrd,FStkChkAlrm,FInspectionProject,FIdentifier,FVersion,FNameEn,FModelEn,FHSNumber,'+'FFirstUnit,FSecondUnit,FImpostTaxRate,FConsumeTaxRate,FFirstUnitRate,FSecondUnitRate,FIsManage,FManageType,FLenDecimal,FCubageDecimal,'+'FWeightDecimal,FIsCharSourceItem,FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability,'+'FShortNumber,FNumber,FName,isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item where  FItemClassID=4 and Fnumber=(select top 1 FNumber from T_Item where FItemClassID=4 and FItemID=a.FParentID)),0),'+@FItemidTemp+' from t_ICItem a where FItemID='+@FItemID;
                         EXEC (@sql);
                     END;
             END;
         IF(@@error <> 0)
             ROLLBACK TRANSACTION;
             ELSE
         COMMIT TRANSACTION;
     END;  
    
 -----5  部门同步
GO
 -- =============================================
-- Author:
-- Create date: 
-- Description:	部门同步
-- =============================================
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[yj_t_Department]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER yj_t_Department;
GO
CREATE TRIGGER [dbo].[yj_t_Department] ON [dbo].[t_Department]
FOR INSERT, UPDATE, DELETE
AS
     DECLARE @DBName VARCHAR(100);
     DECLARE @FItemID VARCHAR(10);
     DECLARE @FNumber VARCHAR(100);
     DECLARE @Sql VARCHAR(4000);
     DECLARE @InsertSQL VARCHAR(2000);
     DECLARE @T_ItemSQL VARCHAR(2000);
     DECLARE @nSql NVARCHAR(4000);
     DECLARE @pp2 INT;
     DECLARE @NewFNumber VARCHAR(50);
     BEGIN
         SELECT @DBName = FDBName
         FROM t_BOS_Synchro
         WHERE FK3Name = '帐套同步';
         IF LEN(@DBName) > 0
             BEGIN
			---- 1. 添加 ----    
                 IF EXISTS
(
    SELECT *
    FROM Inserted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM deleted
))
                     BEGIN
                         SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_Department (FPhone,FFax,FDProperty,FIsCreditMgr,FNote,FCostAccountType,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,FShortNumber,FNumber,FName,FManager,FAcctID,FParentID,FItemID) ';
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ';
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM inserted;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_Department where  FNumber='+''''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 = 0
                             BEGIN
                                 SET @nSql = ' exec '+@DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394';
                                 EXEC sp_executesql
                                      @nSql,
                                      N'@p2   int   output ',
                                      @pp2 OUTPUT;
                                 SET @Sql = @T_ItemSQL+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=2 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item t where FITemID='+@FItemID;
                                 EXEC (@SQL);
                                 SET @Sql = @InsertSQL+' select FPhone,FFax,FDProperty,FIsCreditMgr,FNote,FCostAccountType,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,FShortNumber,FNumber,FName,'+'isnull((select FItemID from '+@DBName+'.dbo.t_emp where  Fnumber=(select FNumber from t_emp where FItemID=t.FManager)),0),'+'isnull((select FAccountID from '+@DBName+'.dbo.t_Account where Fnumber=(select FNumber from t_Account where FAccountID=t.FAcctID)),0),'+'isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=2 and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from t_Department t where FItemID='+@FItemID;
                                 EXEC (@sql);
                                 SET @Sql = 'update '+@DBName+'.dbo.T_Item set FFullName= FName where FItemID ='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                             END;
                     END;
		
		
				-----2.修改 ----
                 IF EXISTS
(
    SELECT 1
    FROM Inserted
)
                    AND EXISTS
(
    SELECT 1
    FROM deleted
)
                     BEGIN
                         SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_Department (FPhone,FFax,FDProperty,FIsCreditMgr,FNote,FCostAccountType,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,FShortNumber,FNumber,FName,FManager,FAcctID,FParentID,FItemID) ';
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ';
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM deleted;
                         SELECT @NewFNumber = FNumber
                         FROM inserted;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_Department where  FNumber='+''''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 > 0
                             BEGIN
                                 SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=2 and FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                                 SET @Sql = 'delete from '+@DBName+'.dbo.t_Department where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                                 SET @Sql = @T_ItemSQL+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=2 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item t where FITemID='+@FItemID;
                                 EXEC (@SQL);
                                 SET @Sql = @InsertSQL+' select FPhone,FFax,FDProperty,FIsCreditMgr,FNote,FCostAccountType,FOtherARAcctID,FPreARAcctID,FOtherAPAcctID,FPreAPAcctID,FShortNumber,FNumber,FName,'+'isnull((select FItemID from '+@DBName+'.dbo.t_emp where  Fnumber=(select FNumber from t_emp where FItemID=t.FManager)),0),'+'isnull((select FAccountID from '+@DBName+'.dbo.t_Account where Fnumber=(select FNumber from t_Account where FAccountID=t.FAcctID)),0),'+'isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=2 and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from t_Department t where FItemID='+@FItemID;
                                 EXEC (@sql);
                                 SET @Sql = 'update '+@DBName+'.dbo.T_Item set FFullName= FName where FItemID ='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                             END;
                     END;
		
				-----3. 删除----
                 IF EXISTS
(
    SELECT *
    FROM Deleted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM Inserted
))
                     BEGIN
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM deleted;
                         SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=2 and  FNumber='''+@FNumber+'''';
                         EXEC (@sql);
                         SET @Sql = 'delete from '+@DBName+'.dbo.t_Department where FNumber='''+@FNumber+'''';
                         EXEC (@sql);
                     END;
		-----3. 删除 End ----


             END;    -----if LEN(@DBName) > 0

     END;
GO 
---6 客户同步
 
-- =============================================
-- Author:opco
-- Create date: 2012-09
-- Description:	客户同步
-- =============================================
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[yj_t_Organization]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER yj_t_Organization;
GO
CREATE TRIGGER [dbo].[yj_t_Organization] ON [dbo].[t_Organization]
FOR INSERT, UPDATE, DELETE
AS
     DECLARE @DBName VARCHAR(100);
     DECLARE @FItemID VARCHAR(10);
     DECLARE @FNumber VARCHAR(100);
     DECLARE @Sql VARCHAR(4000);
     DECLARE @InsertSQL VARCHAR(4000);
     DECLARE @T_ItemSQL VARCHAR(4000);
     DECLARE @IsHere VARCHAR(10);
     DECLARE @FDetail VARCHAR(10);
     DECLARE @FParentID VARCHAR(50);
     DECLARE @isSynchro INT;
     DECLARE @nSql NVARCHAR(4000);
     DECLARE @pp2 INT;
     DECLARE @NewFNumber VARCHAR(50);
     BEGIN
         SELECT @DBName = FDBName
         FROM t_BOS_Synchro
         WHERE FK3Name = '帐套同步';
         IF LEN(@DBName) > 0
             BEGIN
	
		---- 1. 添加 ----    
                 IF EXISTS
(
    SELECT *
    FROM Inserted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM deleted
))
                     BEGIN
                         SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_Organization (FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,'+'FMobilePhone,FFax,FPostalCode,FEmail,FBank,FAccount,FTaxNum,FIsCreditMgr,FSaleMode,FValueAddRate,FCountry,FHomePage,'+'Fcorperate,FCarryingAOS,FTypeID,FSaleID,FStockIDKeep,FCyID,FSetID,FCIQNumber,'+'FARAccountID,FAPAccountID,FOtherAPAcctID,FOtherARAcctID,FPayTaxAcctID,FpreAcctID,FPreAPAcctID,'+'FfavorPolicy,Fdepartment,Femployee,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,'+'FminForeReceiveRate,FminReserverate,FdebtLevel,FPayCondition,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,FShortNumber,FNumber,FName,'+'FParentID,FItemID) ';
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ';
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM inserted;
                         SELECT @FParentID = FParentID,
                                @FDetail = FDetail
                         FROM t_Item
                         WHERE FNumber = @FNumber;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_Organization where  FNumber='+''''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 = 0
                             BEGIN
                                 SET @nSql = ' exec '+@DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394';
                                 EXEC sp_executesql
                                      @nSql,
                                      N'@p2   int   output ',
                                      @pp2 OUTPUT;
                                 SET @Sql = @T_ItemSQL+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=1 and Fnumber=(select FNumber from T_Item where  FItemID='+@FParentID+')),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item where FITemID='+@FItemID;
                                 EXEC (@SQL);
                                 SET @Sql = @InsertSQL+' select FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,FMobilePhone,FFax,FPostalCode,FEmail,'+'FBank,FAccount,FTaxNum,FIsCreditMgr,FSaleMode,FValueAddRate,FCountry,FHomePage,Fcorperate,FCarryingAOS,FTypeID,FSaleID,'+'FStockIDKeep,FCyID,FSetID,FCIQNumber,'+'ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FARAccountID)),0),
					 ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FAPAccountID)),0),
					 ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FOtherAPAcctID)),0),
					 ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FOtherARAcctID)),0),
					 ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FPayTaxAcctID)),0),
					 ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FpreAcctID)),0),
					 ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FPreAPAcctID)),0),
					'+'FfavorPolicy,0,0,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,FminForeReceiveRate,FminReserverate,'+'FdebtLevel,FPayCondition,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,FShortNumber,FNumber,FName,'+'isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=1 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from t_Organization t where FItemID='+@FItemID;
                                 EXEC (@sql);
                                 SET @Sql = 'IF not exists(Select * from '+@DBName+'.dbo.Access_t_Organization where FItemID='+CAST(@pp2 AS VARCHAR(10))+')'+'Insert into '+@DBName+'.dbo.Access_t_Organization(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
					select '+CAST(@pp2 AS VARCHAR(10))+',isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item 
					where FItemClassID=1 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),
					convert(varbinary(7200),REPLICATE(char(0),7200)),
					convert(varbinary(7200),REPLICATE(char(0),7200)),
					convert(varbinary(7200),REPLICATE(char(0),7200))
					from t_item t where FItemID='+@FItemID;
                                 EXEC (@sql);
                                 SET @Sql = ' update  '+@DBName+'.dbo.t_Item set FName=FName where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                                 SET @Sql = 'IF not exists(Select * from '+@DBName+'.dbo.Access_t_Organization where FItemID='+CAST(@pp2 AS VARCHAR(10))+')'+'Insert into '+@DBName+'.dbo.Access_t_Organization(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
					select '+CAST(@pp2 AS VARCHAR(10))+',isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item 
					where FItemClassID=1 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),
					(SELECT  TOP 1  FDataAccessView FROM '+@DBName+'.dbo.Access_t_Organization  ORDER BY FItemID DESC  ),
					(SELECT  TOP 1  FDataAccessEdit  FROM '+@DBName+'.dbo.Access_t_Organization  ORDER BY FItemID DESC  ),
					(SELECT  TOP 1  FDataAccessDelete  FROM '+@DBName+'.dbo.Access_t_Organization  ORDER BY FItemID DESC  )
					
					from t_item t where FItemID='+@FItemID;
                                 EXEC (@sql);
                             END;
                     END;
		-----1. 添加 end ----
		
		-----2.修改 ----
                 IF EXISTS
(
    SELECT 1
    FROM Inserted
)
                    AND EXISTS
(
    SELECT 1
    FROM deleted
)
                     BEGIN
                         SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_Organization (FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,'+'FMobilePhone,FFax,FPostalCode,FEmail,FBank,FAccount,FTaxNum,FIsCreditMgr,FSaleMode,FValueAddRate,FCountry,FHomePage,'+'Fcorperate,FCarryingAOS,FTypeID,FSaleID,FStockIDKeep,FCyID,FSetID,FCIQNumber,'+'FARAccountID,FAPAccountID,FOtherAPAcctID,FOtherARAcctID,FPayTaxAcctID,FpreAcctID,FPreAPAcctID,'+'FfavorPolicy,Fdepartment,Femployee,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,'+'FminForeReceiveRate,FminReserverate,FdebtLevel,FPayCondition,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,FShortNumber,FNumber,FName,'+'FParentID,FItemID) ';
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ';
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber,
                                @FParentID = FParentID
                         FROM deleted;
                         SELECT @NewFNumber = FNumber
                         FROM inserted;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_Organization where  FNumber='+''''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 > 0
                             BEGIN
                                 SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=1 and FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                                 SET @Sql = 'delete from '+@DBName+'.dbo.t_Organization where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                                 SET @Sql = @T_ItemSQL+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=1 and Fnumber=(select FNumber from T_Item where FItemID='+@FParentID+')),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item where FITemID='+@FItemID;
                                 EXEC (@SQL);
                                 SET @Sql = @InsertSQL+' select FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,FMobilePhone,FFax,FPostalCode,FEmail,'+'FBank,FAccount,FTaxNum,FIsCreditMgr,FSaleMode,FValueAddRate,FCountry,FHomePage,Fcorperate,FCarryingAOS,FTypeID,FSaleID,'+'FStockIDKeep,FCyID,FSetID,FCIQNumber,'+'ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FARAccountID)),0),
					 ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FAPAccountID)),0),
					 ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FOtherAPAcctID)),0),
					 ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FOtherARAcctID)),0),
					 ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FPayTaxAcctID)),0),
					 ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FpreAcctID)),0),
					 ISNULL((select FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select FNumber from t_Account where FAccountID=t.FPreAPAcctID)),0),
					'+'FfavorPolicy,0,0,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,FminForeReceiveRate,FminReserverate,'+'FdebtLevel,FPayCondition,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,FShortNumber,FNumber,FName,'+'isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=1 and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from t_Organization t where FItemID='+@FItemID;
                                 EXEC (@sql);
                                 SET @Sql = ' update  '+@DBName+'.dbo.t_Item set FName=FName where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                                 SET @Sql = 'IF not exists(Select * from '+@DBName+'.dbo.Access_t_Organization where FItemID='+CAST(@pp2 AS VARCHAR(10))+')'+'Insert into '+@DBName+'.dbo.Access_t_Organization(FItemID,FParentIDX,FDataAccessView,FDataAccessEdit,FDataAccessDelete)
					select '+CAST(@pp2 AS VARCHAR(10))+',isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item 
					where FItemClassID=1 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),
					convert(varbinary(7200),REPLICATE(char(0),7200)),
					convert(varbinary(7200),REPLICATE(char(0),7200)),
					convert(varbinary(7200),REPLICATE(char(0),7200))
					from t_item t where FItemID='+@FItemID;
                                 EXEC (@sql);
                             END;
                     END;
		-----2.修改 end ----
		
		
		-----3. 删除----
                 IF EXISTS
(
    SELECT *
    FROM Deleted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM Inserted
))
                     BEGIN
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM deleted;
                         SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=1 and  FNumber='''+@FNumber+'''';
                         EXEC (@sql);
                         SET @Sql = 'delete from '+@DBName+'.dbo.t_Organization where FNumber='''+@FNumber+'''';
                         EXEC (@sql);
                     END;
		-----3. 删除 End ----




             END;
     END;
GO 
----7成本对象

-- =============================================
-- Author:
-- Last Modify: 2013-03
-- Description:	成本对象
-- =============================================
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[yj_CBCostObj]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER yj_CBCostObj;
GO
CREATE TRIGGER [dbo].yj_CBCostObj ON [dbo].t_item
FOR INSERT, UPDATE, DELETE
AS
     DECLARE @DBName VARCHAR(100);
     DECLARE @FDetail VARCHAR(10);
--declare @FItemClassID varchar(50)

     DECLARE @FItemID VARCHAR(10);
     DECLARE @FNumber VARCHAR(100);
     DECLARE @OldFnumber VARCHAR(100);
     DECLARE @FName VARCHAR(100);
     DECLARE @FShortNumber VARCHAR(100);
     DECLARE @FParentID INT;
     DECLARE @Sql VARCHAR(4000);
     DECLARE @T_ItemSQL VARCHAR(4000);
     DECLARE @nSql NVARCHAR(4000);
     DECLARE @pp2 INT;
     DECLARE @P1 INT, @P3 VARCHAR(50), @P4 VARCHAR(50);
     BEGIN
         SELECT @DBName = FDBName
         FROM t_BOS_Synchro
         WHERE FK3Name = '帐套同步';
         SELECT @FDetail = FDetail
         FROM inserted
         WHERE FItemClassID = 2001
               AND FDetail = 1;
         SELECT @FDetail = FDetail
         FROM deleted
         WHERE FItemClassID = 2001
               AND FDetail = 1;
         IF(LEN(@DBName) > 0)
           AND @FDetail = 1
             BEGIN
	
		-----1. 添加    -----
                 IF EXISTS
(
    SELECT *
    FROM Inserted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM deleted
))
                     BEGIN
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM inserted;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_item where FItemClassID=2001 and FNumber='+''''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 = 0
                             BEGIN
                                 SET @nSql = ' exec '+@DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394';
                                 EXEC sp_executesql
                                      @nSql,
                                      N'@p2   int   output ',
                                      @pp2 OUTPUT;
                                 SET @Sql = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=2001 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item t where FITemID='+@FItemID;
                                 EXEC (@Sql);
                                 SET @sql = 'insert into '+@DBName+'.dbo.CBCostObj (FItemID,FNumber,FName,FStdID,FStdSubID,FParentID,FShortNumber,FUnUsed,FCalculateType,FStdProductID,FBatchNo,FBomID,
							FEditable,FSBillNo,FDeleted,FStdSubItemID)
						 select t.FItemID,t.FNumber,t.FName,0,0,t.FParentID,t.FShortNumber,0,906,isnull(t2.FItemID,0)-1,'''',0,0,'''',0,0
						 from '+@DBName+'.dbo.t_item  t 
						 left join '+@DBName+'.dbo.t_Item t2 on t2.FNumber=t.FNumber and t2.FItemClassID=4
						 where t.FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@Sql);
                                 SET @sql = 'insert into '+@DBName+'.dbo.CB_CostObj_Product(FCostObjID,FProductID,FQuotiety,FIsStand,FIsDeputy)
						select '+CAST(@pp2 AS VARCHAR(10))+',FItemID,1,1,0
						from '+@DBName+'.dbo.t_Item where FItemClassID=4 and FNumber='''+@FNumber+'''';
                                 EXEC (@Sql);
                             END;
                     END;

		
		-----2.修改 ----- 
                 IF EXISTS
(
    SELECT 1
    FROM Inserted
)
                    AND EXISTS
(
    SELECT 1
    FROM deleted
)
                     BEGIN
                         IF((UPDATE(FName))
                            OR (UPDATE(FNumber)))
                             BEGIN
                                 SELECT @FItemID = FItemID,
                                        @FNumber = FNumber,
                                        @FShortNumber = FShortNumber,
                                        @FName = FName
                                 FROM inserted;
                                 SELECT @OldFnumber = FNumber
                                 FROM deleted;
                                 SET @pp2 = 0;
                                 SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_item where FItemClassID=2001 and FNumber='+''''+@OldFnumber+'''';
                                 EXEC sp_executesql
                                      @nSQL,
                                      N'@p2   int   output ',
                                      @pp2 OUTPUT;

				---- 1.不存在，新增  ----
                                 IF @pp2 = 0
                                     BEGIN
                                         SET @nSql = ' exec '+@DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394';
                                         EXEC sp_executesql
                                              @nSql,
                                              N'@p2   int   output ',
                                              @pp2 OUTPUT;
                                         SET @Sql = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) '+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=2001 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item t where FITemID='+@FItemID;
                                         EXEC (@Sql);
                                         SET @sql = 'insert into '+@DBName+'.dbo.CBCostObj (FItemID,FNumber,FName,FStdID,FStdSubID,FParentID,FShortNumber,FUnUsed,FCalculateType,FStdProductID,FBatchNo,FBomID,
								FEditable,FSBillNo,FDeleted,FStdSubItemID)
							 select t.FItemID,t.FNumber,t.FName,0,0,t.FParentID,t.FShortNumber,0,906,isnull(t2.FItemID,0)-1,'''',0,0,'''',0,0,0
							 from '+@DBName+'.dbo.t_item  t 
							 left join '+@DBName+'.dbo.t_Item t2 on t2.FNumber=t.FNumber and t2.FItemClassID=4
							 where t.FItemID='+CAST(@pp2 AS VARCHAR(10));
                                         EXEC (@Sql);
                                         SET @sql = 'insert into '+@DBName+'.dbo.CB_CostObj_Product(FCostObjID,FProductID,FQuotiety,FIsStand,FIsDeputy)
							select '+CAST(@pp2 AS VARCHAR(10))+',FItemID,1,1,0
							from '+@DBName+'.dbo.t_Item where FItemClassID=4 and FNumber='''+@FNumber+'''';
                                         EXEC (@Sql);
                                     END;
                                     ELSE
                                     BEGIN
                                         SET @FParentID = 0;
                                         SET @nSQL = ' select @p2=isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item 
								where FItemClassID= 2001 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0)
								from T_Item t where FItemID='+@FItemID;
                                         EXEC sp_executesql
                                              @nSQL,
                                              N'@p2   int   output ',
                                              @FParentID OUTPUT;
                                         SET @Sql = 'update   '+@DBName+'.dbo.T_Item  set FName='+''''+@FName+''''+',FNumber='+''''+@FNumber+''''+' ,FFullNumber='+''''+@FNumber+''''+',FShortNumber='+''''+@FShortNumber+''''+',FParentID='+CAST(@FParentID AS VARCHAR(10))+'  where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                         EXEC (@Sql);
                                         SET @Sql = 'update   '+@DBName+'.dbo.CBCostObj  set FNumber='+''''+@FNumber+''''+',FName='+''''+@FName+''''+',FShortNumber='+''''+@FShortNumber+''''+',FParentID='+CAST(@FParentID AS VARCHAR(10))+'  where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                         EXEC (@Sql);			
								
				
					--select * from CBCostObj order by FItemID desc 
                                     END;
                             END;
                     END;
		
			
		------ 3. 删除 -----
                 IF EXISTS
(
    SELECT *
    FROM Deleted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM Inserted
))
                     BEGIN
                         SELECT @FNumber = FNumber
                         FROM deleted;
                         SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=2001 and FNumber='+''''+@FNumber+'''';
                         EXEC (@sql);
                         SET @Sql = 'delete from '+@DBName+'.dbo.CBCostObj where FNumber='+''''+@FNumber+'''';
                         EXEC (@sql);
                     END;
		-----

             END;
     END;
GO 
------8 仓库
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[yj_t_stock]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER yj_t_stock;
GO
CREATE TRIGGER [dbo].[yj_t_stock] ON [dbo].[t_Stock]
FOR INSERT, UPDATE, DELETE
AS
     DECLARE @FItemID VARCHAR(10);
     DECLARE @FNumber VARCHAR(100);
     DECLARE @DBName VARCHAR(100);
     DECLARE @Sql VARCHAR(4000);
     DECLARE @InsertSQL VARCHAR(2000);
     DECLARE @T_ItemSQL VARCHAR(2000);
     DECLARE @nSQL NVARCHAR(4000);
     DECLARE @pp2 INT;
     DECLARE @NewFnumber VARCHAR(50);
     BEGIN
         SELECT @DBName = FDBName
         FROM t_BOS_Synchro
         WHERE FK3Name = '帐套同步';
         IF LEN(@DBName) > 0
             BEGIN
	
		-----  1. 添加   ---- 
                 IF EXISTS
(
    SELECT *
    FROM Inserted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM deleted
))
                     BEGIN
                         SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_stock (FEmpID,FAddress,FPhone,FProperty,FTypeID,FMRPAvail,FIsStockMgr,FSPGroupID,FShortNumber,FNumber,FName,FParentID,FItemID) ';
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,FParentID,FItemID) ';
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM inserted;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_Stock where Fnumber='''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 = 0
                             BEGIN
                                 SET @nSQL = ' exec '+@DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394';
                                 EXEC sp_executesql
                                      @nSQL,
                                      N'@p2   int   output ',
                                      @pp2 OUTPUT;
                                 SET @Sql = @T_ItemSQL+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=t.FItemClassID and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item t where FITemID='+@FItemID;
                                 EXEC (@SQL);
                                 SET @Sql = @InsertSQL+' select '+'isnull((select FItemID from '+@DBName+'.dbo.t_emp where Fnumber=(select FNumber from t_emp where FItemID=t.FEmpID)),0),'+'FAddress,FPhone,FProperty,FTypeID,FMRPAvail,FIsStockMgr,FSPGroupID,FShortNumber,FNumber,FName,
							isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=5 and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from t_stock t where FItemID='+@FItemID;
                                 EXEC (@sql);
                                 SET @Sql = ' update  '+@DBName+'.dbo.t_Item set FName=FName where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                             END;
                     END;
		
		
		---- 2.修改----
                 IF EXISTS
(
    SELECT 1
    FROM Inserted
)
                    AND EXISTS
(
    SELECT 1
    FROM deleted
)
                     BEGIN
                         SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_stock (FEmpID,FAddress,FPhone,FProperty,FTypeID,FMRPAvail,FIsStockMgr,FSPGroupID,FShortNumber,FNumber,FName,FParentID,FItemID) ';
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,FParentID,FItemID) ';
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM deleted;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_stock where Fnumber='''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 > 0
                             BEGIN
                                 SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where  FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                                 SET @Sql = 'delete from '+@DBName+'.dbo.t_stock where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                                 SET @Sql = @T_ItemSQL+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=t.FItemClassID and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item t where FITemID='+@FItemID;
                                 EXEC (@SQL);
                                 SET @Sql = @InsertSQL+' select '+'isnull((select FItemID from '+@DBName+'.dbo.t_emp where Fnumber=(select FNumber from t_emp where FItemID=t.FEmpID)),0),'+'FAddress,FPhone,FProperty,FTypeID,FMRPAvail,FIsStockMgr,FSPGroupID,FShortNumber,FNumber,FName,
							isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=5 and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from t_stock t where FItemID='+@FItemID;
                                 EXEC (@sql);
                                 SET @Sql = ' update  '+@DBName+'.dbo.t_Item set FName=FName where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                             END;
                     END;
		
		
		-----  3. 删除 ----
                 IF EXISTS
(
    SELECT *
    FROM Deleted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM Inserted
))
                     BEGIN
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM deleted;
                         SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=5 and  FNumber='''+@FNumber+'''';
                         EXEC (@sql);
                         SET @Sql = 'delete from '+@DBName+'.dbo.t_stock where  FNumber='''+@FNumber+'''';
                         EXEC (@sql);
                     END;
             END;
     END;
GO 
---9  供应商
-- =============================================
-- Author:Lyman
-- Create date: 
-- Description:	供应商同步
-- =============================================
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[yj_t_supplier]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
) 
--PRINT '1' ELSE PRINT '0'
    DROP TRIGGER yj_t_supplier;
GO
CREATE TRIGGER [dbo].[yj_t_supplier] ON [dbo].[t_supplier]
FOR INSERT, UPDATE, DELETE
AS
     DECLARE @FItemID VARCHAR(10);
     DECLARE @FNumber VARCHAR(100);
     DECLARE @DBName VARCHAR(100);
     DECLARE @Sql VARCHAR(4000);
     DECLARE @InsertSQL VARCHAR(2000);
     DECLARE @T_ItemSQL VARCHAR(2000);
     DECLARE @nSql NVARCHAR(4000);
     DECLARE @pp2 INT;
     DECLARE @NewFNumber VARCHAR(50);
     BEGIN
         SELECT @DBName = FDBName
         FROM t_BOS_Synchro
         WHERE FK3Name = '帐套同步';
         IF LEN(@DBName) > 0
             BEGIN
	
	---- 1. 添加 ----    
                 IF EXISTS
(
    SELECT *
    FROM Inserted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM deleted
))
                     BEGIN
                         SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_supplier (FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,'+'FMobilePhone,FFax,FPostalCode,FEmail,FBank,FAccount,FTaxNum,FValueAddRate,FCountry,FProvince,Fcorperate,FDiscount,FTypeID,'+'FStockIDAssignee,FBr,FRegmark,FLicence,FCyID,FSetID,FAPAccountID,FPreAcctID,FOtherAPAcctID,FPayTaxAcctID,'+'FARAccountID,FPreARAcctID,FOtherARAcctID,FfavorPolicy,Fdepartment,Femployee,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,'+'FminForeReceiveRate,FCreditDays,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,'+'FShortNumber,FNumber,FName,FParentID,FItemID)  ';
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,FParentID,FItemID) ';
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM inserted;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_supplier where  FNumber='+''''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 = 0
                             BEGIN
                                 SET @nSql = ' exec '+@DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394';
                                 EXEC sp_executesql
                                      @nSql,
                                      N'@p2   int   output ',
                                      @pp2 OUTPUT;
                                 SET @Sql = @T_ItemSQL+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=8  and  Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item t where FITemID='+@FItemID;
                                 EXEC (@Sql);
                                 SET @Sql = @InsertSQL+' select FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,'+'FMobilePhone,FFax,FPostalCode,FEmail,FBank,FAccount,FTaxNum,FValueAddRate,FCountry,FProvince,Fcorperate,FDiscount,FTypeID,'+'FStockIDAssignee,FBr,FRegmark,FLicence,FCyID,FSetID,FAPAccountID,FPreAcctID,FOtherAPAcctID,FPayTaxAcctID,'+'FARAccountID,FPreARAcctID,FOtherARAcctID,FfavorPolicy,Fdepartment,Femployee,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,'+'FminForeReceiveRate,FCreditDays,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,'+'FShortNumber,FNumber,FName,isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=8  and Fnumber=(select FNumber from T_Item where FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from t_supplier t where FItemID='+@FItemID;
                                 EXEC (@Sql);
                                 SET @Sql = ' update  '+@DBName+'.dbo.t_Item set FName=FName where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                             END;
                     END;
	-----1. 添加 end ----
	
	-----2.修改 ----
                 IF EXISTS
(
    SELECT 1
    FROM Inserted
)
                    AND EXISTS
(
    SELECT 1
    FROM deleted
)
                     BEGIN
                         SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_supplier (FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,'+'FMobilePhone,FFax,FPostalCode,FEmail,FBank,FAccount,FTaxNum,FValueAddRate,FCountry,FProvince,Fcorperate,FDiscount,FTypeID,'+'FStockIDAssignee,FBr,FRegmark,FLicence,FCyID,FSetID,FAPAccountID,FPreAcctID,FOtherAPAcctID,FPayTaxAcctID,'+'FARAccountID,FPreARAcctID,FOtherARAcctID,FfavorPolicy,Fdepartment,Femployee,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,'+'FminForeReceiveRate,FCreditDays,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,'+'FShortNumber,FNumber,FName,FParentID,FItemID)  ';
                         SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FFullName,FParentID,FItemID) ';
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM deleted;
                         SELECT @NewFNumber = FNumber
                         FROM inserted;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_supplier where  FNumber='+''''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 > 0
                             BEGIN
                                 SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                                 SET @Sql = 'delete from '+@DBName+'.dbo.t_supplier where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                                 SET @Sql = @T_ItemSQL+'select FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted, FFullName,isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=8 and Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from T_Item t where FITemID='+@FItemID;
                                 EXEC (@sql);
                                 SET @Sql = @InsertSQL+' select FHelpCode,FShortName,FAddress,FStatus,FRegionID,FTrade,FContact,FPhone,'+'FMobilePhone,FFax,FPostalCode,FEmail,FBank,FAccount,FTaxNum,FValueAddRate,FCountry,FProvince,Fcorperate,FDiscount,FTypeID,'+'FStockIDAssignee,FBr,FRegmark,FLicence,FCyID,FSetID,FAPAccountID,FPreAcctID,FOtherAPAcctID,FPayTaxAcctID,'+'FARAccountID,FPreARAcctID,FOtherARAcctID,FfavorPolicy,Fdepartment,Femployee,FLastTradeDate,FlastTradeAmount,FlastRPAmount,FmaxDealAmount,'+'FminForeReceiveRate,FCreditDays,FNameEN,FAddrEn,FCIQCode,FRegion,FManageType,'+'FShortNumber,FNumber,FName,isnull((select FItemID as FParentID from '+@DBName+'.dbo.T_Item where FItemClassID=8 and  Fnumber=(select FNumber from T_Item where  FItemID=t.FParentID)),0),'+CAST(@pp2 AS VARCHAR(10))+' from t_supplier t where FItemID='+@FItemID;
                                 EXEC (@sql);
                                 SET @Sql = ' update  '+@DBName+'.dbo.t_Item set FName=FName where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                 EXEC (@sql);
                             END;
                     END;	
	-----2.修改 end----		
	
	-----3. 删除----
                 IF EXISTS
(
    SELECT *
    FROM Deleted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM Inserted
))
                     BEGIN
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM deleted;
                         SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where FItemClassID=8 and  FNumber='''+@FNumber+'''';
                         EXEC (@sql);
                         SET @Sql = 'delete from '+@DBName+'.dbo.t_supplier where FNumber='''+@FNumber+'''';
                         EXEC (@sql);
                     END;
	-----3. 删除 End ----


             END;
     END;
GO
-----9 计量单位(组)同步
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[yj_t_UnitGroup]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER yj_t_UnitGroup;
GO

-- =============================================
-- Author:opco
-- Create date: 
-- Description:	synchro-计量单位(组)同步
-- =============================================
CREATE TRIGGER [dbo].[yj_t_UnitGroup] ON [dbo].[t_UnitGroup]
FOR INSERT, UPDATE, DELETE
AS
     DECLARE @FItemID VARCHAR(10);
     DECLARE @FNumber VARCHAR(100);
     DECLARE @DBName VARCHAR(100);
     DECLARE @Sql VARCHAR(4000);
     DECLARE @IsHere VARCHAR(10);
     DECLARE @NewFnumber VARCHAR(50);
     DECLARE @FItemidTemp VARCHAR(50);
     BEGIN
         BEGIN TRANSACTION;
         SET NOCOUNT ON;
         SELECT @DBName = FDBName
         FROM t_BOS_Synchro
         WHERE FK3Name = '帐套同步';
         IF LEN(@DBName) > 0
             BEGIN	
		-----1. 添加    
                 IF EXISTS
(
    SELECT *
    FROM Inserted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM deleted
))
                     BEGIN
                         SELECT @FNumber = FName,
                                @FItemID = FUnitGroupID
                         FROM inserted;

			--IF  EXISTS (SELECT * FROM tempdb.sys.objects WHERE object_id = OBJECT_ID(N'tempdbdbo.TongBuTemp') AND type in (N'U'))
				--drop table TongBuTemp  
			--Create table TongBuTemp (TempID varchar(10))
                         DELETE FROM TongBuTemp;
                         SET @sql = 'insert into  TongBuTemp (TempID) select FitemID from '+@DBName+'.dbo.t_item where FItemClassID=7 and FNumber='+''''+@FNumber+'''';
                         EXEC (@sql);
                         SET @IsHere = '0';
                         SELECT @IsHere = tempID
                         FROM TongBuTemp;
                         IF @IsHere > 0
                             BEGIN
                                 SET @Sql = 'Insert into '+@DBName+'.dbo.t_UnitGroup (FUnitGroupID,FName) ';
                                 SET @Sql = @Sql+' select '+CAST(@IsHere AS VARCHAR(10))+',FName from t_UnitGroup where FUnitGroupID='+@FItemID;
                                 EXEC (@sql);
                             END;
                     END;
        
		-----2.修改(只修改名称FName)
                 IF EXISTS
(
    SELECT 1
    FROM Inserted
)
                    AND EXISTS
(
    SELECT 1
    FROM deleted
)
                     BEGIN
                         SELECT @FItemID = FUnitGroupID,
                                @FNumber = FName
                         FROM deleted;
                         SELECT @NewFNumber = FName
                         FROM inserted;
			
			--set @Sql = 'update '+ @DBName+'.dbo.T_Item set FNumber='+''''+@NewFNumber+''''+' where FItemClassID=7 and FNumber='+ ''''+@FNumber+''''
			--exec (@sql) 
                         SET @Sql = 'update '+@DBName+'.dbo.t_UnitGroup set FName='+''''+@NewFNumber+''''+' where FName='+''''+@FNumber+'''';
                         EXEC (@sql);
                     END;
	
		-----3. 删除
                 IF EXISTS
(
    SELECT *
    FROM Deleted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM Inserted
))
                     BEGIN
                         SELECT @FItemID = FUnitGroupID,
                                @FNumber = Fname
                         FROM deleted;
                         SET @Sql = '  delete from '+@DBName+'.dbo.T_Item where FItemClassID=7 and  FParentID IN (select FUnitGroupID as FParentID from '+@DBName+'.dbo.t_UnitGroup where FName='+''''+@FNumber+''''+')';
                         EXEC (@sql);
                         SET @Sql = 'delete from '+@DBName+'.dbo.t_UnitGroup where FName='+''''+@FNumber+'''';
                         EXEC (@sql);
                         SET @Sql = '  delete from '+@DBName+'.dbo.T_Item where FItemClassID=7 and  FNumber='+''''+@FNumber+'''';
                         EXEC (@sql);
                     END;
             END;
         IF(@@error <> 0)
             ROLLBACK TRANSACTION;
             ELSE
         COMMIT TRANSACTION;
     END;
GO
---10 计量单位同步

-- =============================================
-- Author:opco
-- Create date: 
-- Description:	synchro-计量单位同步
-- =============================================

GO
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[yj_t_measureunit]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER yj_t_measureunit;
GO
CREATE TRIGGER [dbo].[yj_t_measureunit] ON [dbo].[t_measureunit]
FOR INSERT, UPDATE, DELETE
AS
     DECLARE @FItemID VARCHAR(10);
     DECLARE @FNumber VARCHAR(100);
     DECLARE @DBName VARCHAR(100);
     DECLARE @Sql VARCHAR(4000);
     DECLARE @InsertSQL VARCHAR(4000);
     DECLARE @T_ItemSQL VARCHAR(4000);
     DECLARE @FParentID VARCHAR(50);			---- FParentID=FUnitGroupID
     DECLARE @IsHere VARCHAR(10);
     DECLARE @FDetail VARCHAR(10);
     DECLARE @NewFnumber VARCHAR(50);
--declare @FItemidTemp varchar(50)
     DECLARE @nSql NVARCHAR(4000);
     DECLARE @pp2 INT;
     BEGIN
         SELECT @DBName = FDBName
         FROM t_BOS_Synchro
         WHERE FK3Name = '帐套同步';
         IF LEN(@DBName) > 0
             BEGIN
                 SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_measureunit (FStandard,FName,FNumber,FAuxClass,FCoefficient,FConversation,FNameEn,FNameEnPlu,FPrecision,FShortNumber,FUnitGroupID,FParentID,FMeasureUnitID,FItemID) ';
                 SET @T_ItemSQL = 'Insert into '+@DBName+'.dbo.t_item (FItemClassID,FLevel,FName,FNumber,FShortNumber,FFullNumber,FDetail,UUID,FDeleted,FParentID,FItemID) ';

		
		-----1. 添加    
                 IF EXISTS
(
    SELECT *
    FROM Inserted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM deleted
))
                     BEGIN
                         SELECT @FNumber = FNumber,
                                @FParentID = FParentID
                         FROM inserted;
                         SET @pp2 = 0;
                         SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_measureunit where  FNumber='+''''+@FNumber+'''';
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   int   output ',
                              @pp2 OUTPUT;
                         IF @pp2 = 0
                             BEGIN
                                 SET @nSQL = ' exec '+@DBName+'.dbo.GetICMaxNum ''T_Item'',@p2 output,1,16394';
                                 EXEC sp_executesql
                                      @nSQL,
                                      N'@p2   int   output ',
                                      @pp2 OUTPUT;
                                 SET @Sql = @T_ItemSQL+'select 7,2,FName,FNumber,FShortNumber,FShortNumber,1,UUID,0,isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item where Fnumber=(select top 1 FNumber from T_Item where FItemID='+@FParentID+')),0),'+CAST(@pp2 AS VARCHAR(10))+' from t_measureunit where  FNumber='+''''+@FNumber+'''';
                                 EXEC (@Sql);
                                 SET @Sql = @InsertSQL+' select FStandard,FName,FNumber,FAuxClass,FCoefficient,FConversation,FNameEn,FNameEnPlu,FPrecision,FShortNumber,isnull((select  top 1 FUnitGroupID as FUnitGroupID from '+@DBName+'.dbo.t_UnitGroup where FName=(select top 1 FName from t_UnitGroup where FUnitGroupID='+@FParentID+')),0),'+' isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item where FNumber=(select top 1 FNumber from T_Item where FItemID='+@FParentID+')),0),'+CAST(@pp2 AS VARCHAR(10))+','+CAST(@pp2 AS VARCHAR(10))+' from t_measureunit where FNumber='+''''+@FNumber+'''';
                                 EXEC (@sql);
                                 IF NOT EXISTS
(
    SELECT *
    FROM t_measureunit
    WHERE FParentID = @FParentID
          AND FNumber <> @FNumber
)
                                     BEGIN
                                         SET @Sql = 'update '+@DBName+'.dbo.t_measureunit set FStandard=1  where FNumber='+''''+@FNumber+'''';
                                         EXEC (@sql);
                                     END;
                             END;
                     END;
        
		-----2.修改
                 IF EXISTS
(
    SELECT 1
    FROM Inserted
)
                    AND EXISTS
(
    SELECT 1
    FROM deleted
)
                     BEGIN
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber,
                                @FParentID = FParentID
                         FROM deleted;
                         SELECT @FParentID = FParentID,
                                @FDetail = FDetail
                         FROM t_Item
                         WHERE FItemID = @FItemID;
                         IF @FDetail = '1' --插入到t_measureunit和t_item
                             BEGIN
                                 SET @pp2 = 0;
                                 SET @nSQL = ' select @p2=FItemID from  '+@DBName+'.dbo.t_measureunit where  FNumber='+''''+@FNumber+'''';
                                 EXEC sp_executesql
                                      @nSQL,
                                      N'@p2   int   output ',
                                      @pp2 OUTPUT;
                                 IF @pp2 > 0
                                     BEGIN
					------删除
                                         SET @Sql = 'delete from '+@DBName+'.dbo.T_Item where  FItemID='+CAST(@pp2 AS VARCHAR(10));
                                         EXEC (@sql);
                                         SET @Sql = 'delete from '+@DBName+'.dbo.t_measureunit where FItemID='+CAST(@pp2 AS VARCHAR(10));
                                         EXEC (@sql);
			  
					-------插入
                                         SET @InsertSQL = 'Insert into '+@DBName+'.dbo.t_measureunit (FStandard,FName,FNumber,FAuxClass,FCoefficient,FConversation,FNameEn,FNameEnPlu,FPrecision,FShortNumber,FUnitGroupID,FParentID,FMeasureUnitID,FItemID,FDeleted) ';
                                         SET @Sql = @T_ItemSQL+'select 7,2,FName,FNumber,FShortNumber,FShortNumber,1,UUID,FDeleted,isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item where Fnumber=(select top 1 FNumber from T_Item where FItemID='+@FParentID+')),0),'+CAST(@pp2 AS VARCHAR(10))+' from t_measureunit where  FItemID='+@FItemID;
                                         EXEC (@Sql);
                                         SET @Sql = @InsertSQL+' select FStandard,FName,FNumber,FAuxClass,FCoefficient,FConversation,FNameEn,FNameEnPlu,FPrecision,FShortNumber,isnull((select  top 1 FUnitGroupID as FUnitGroupID from '+@DBName+'.dbo.t_UnitGroup where FName=(select top 1 FName from t_UnitGroup where FUnitGroupID='+@FParentID+')),0),'+' isnull((select top 1 FItemID as FParentID from '+@DBName+'.dbo.T_Item where Fnumber=(select top 1 FNumber from T_Item where FItemID='+@FParentID+')),0),'+CAST(@pp2 AS VARCHAR(10))+','+CAST(@pp2 AS VARCHAR(10))+',FDeleted  from t_measureunit where FItemID='+@FItemID;
                                         EXEC (@sql);
                                     END;
                             END;
                     END;
	
		-----3. 删除
                 IF EXISTS
(
    SELECT *
    FROM Deleted
)
                    AND (NOT EXISTS
(
    SELECT *
    FROM Inserted
))
                     BEGIN
                         SELECT @FItemID = FItemID,
                                @FNumber = FNumber
                         FROM deleted;
                         SET @Sql = 'delete from '+@DBName+'.dbo.t_item where FItemClassID=7 and  Fnumber='+''''+@FNumber+'''';
                         SET @Sql = @Sql+'delete from '+@DBName+'.dbo.t_measureunit where Fnumber='+''''+@FNumber+'''';
                         EXEC (@sql);
                     END;
             END;
     END;
GO 



------------------------------------------------------------
------------------------------------------------------------
--业务单据同步  
------------------- 
------------------------------------------------------------
------------------------------------------------------------
---2 出入库
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[ICStockBill_Update]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
) 
--PRINT '111' ELSE PRINT '000' 
    DROP TRIGGER ICStockBill_Update;
GO
CREATE TRIGGER [dbo].[ICStockBill_Update] ON [dbo].[ICStockBill]
FOR UPDATE
AS
     DECLARE @DBName VARCHAR(50);
     DECLARE @FCheckerID BIGINT;
     DECLARE @FInterID VARCHAR(50);
     DECLARE @Sql VARCHAR(4000);
     DECLARE @pp INT;
     DECLARE @FBillNo VARCHAR(50);
     DECLARE @nSql NVARCHAR(4000);
     DECLARE @FTranType INT;
     DECLARE @FSynchroID VARCHAR(50);
     DECLARE @msg VARCHAR(50);
     DECLARE @FLastChecker BIGINT;
     DECLARE @LastCheckLevel INTEGER;
     BEGIN
         BEGIN TRANSACTION;
         SET NOCOUNT ON;
--	1	同步外购入库单1
--2	同步采购发票
--3	同步付款单
--4	同步销售出库单21
--5	同步销售发票
--6	同步收款单
--7	同步生产领料单24
--8	同步产品入库单2
--9	同步其他入库单9
--10	同步其他出库单29
--11	同步记账凭证


--1	外购入库
--2	产成品入库
--3	自制入库
--5	委外加工入库
--10	其他入库
--21	销售产品
--24	生产领料
--28	委外加工发出
--29	其他出库
--40	盘盈入库
--41	仓库调拨
--43	盘亏毁损
--65	计划价调价
--70	采购申请
--71	采购订单
--72	采购收货
--73	采购退货
--75	购货发票
--76	购货发票(普通)
--80	销售发票
--81	销售订单
--82	销售退货
--83	销售发货
--84	销售报价单
--85	生产任务单
--86	销售发票(普通)
--90	凭证
--100	金额调整
--101	外购入库暂估补差
--102	委外加工费补差单
--137	受托加工领料          select * from ictemplate WHERE fid='a01'
--一审:	FMultiCheckLevel1
--二审:	FMultiCheckLevel2
--三审:	FMultiCheckLevel3
--四审:	FMultiCheckLevel4
--五审:	FMultiCheckLevel5
--六审:	FMultiCheckLevel6
	--select * from ictranstype  Select top 1 * From t_MultiLevelCheck Where FBillType = 1 order by fchecklevel desc


         SELECT @DBName = FDBName
         FROM t_BOS_Synchro
         WHERE FK3Name = '帐套同步';
         SELECT @FInterID = FInterID,
                @FCheckerID = isnull(FCheckerID, 0),
                @FTranType = FTranType,
                @FSynchroID = FSynchroID
         FROM inserted
         WHERE FTranType IN(1, 21, 10, 29, 2, 24, 41);
         SELECT TOP 1 @LastCheckLevel = ISNULL(FCheckLevel, 0)
         FROM t_MultiLevelCheck
         WHERE FBillType = @FTranType
         ORDER BY fchecklevel DESC;
         IF @LastCheckLevel = 2
             SELECT @FCheckerID = isnull(FMultiCheckLevel2, 0)
             FROM inserted
             WHERE FTranType IN(1, 21, 10, 29, 2, 24, 41);
         IF @LastCheckLevel = 3
             SELECT @FCheckerID = isnull(FMultiCheckLevel3, 0)
             FROM inserted
             WHERE FTranType IN(1, 21, 10, 29, 2, 24, 41);
         IF @LastCheckLevel = 4
             SELECT @FCheckerID = isnull(FMultiCheckLevel4, 0)
             FROM inserted
             WHERE FTranType IN(1, 21, 10, 29, 2, 24, 41);
         IF @LastCheckLevel = 5
             SELECT @FCheckerID = isnull(FMultiCheckLevel5, 0)
             FROM inserted
             WHERE FTranType IN(1, 21, 10, 29, 2, 24, 41);
         IF @LastCheckLevel = 6
             SELECT @FCheckerID = isnull(FMultiCheckLevel6, 0)
             FROM inserted
             WHERE FTranType IN(1, 21, 10, 29, 2, 24, 41);
         IF @FTranType = 1
             SELECT TOP 1 @FLastChecker = isnull(FChecker, 0)
             FROM t_YXSetEntry
             WHERE FTableName = 1
                   AND FChecker = @FCheckerID;
         IF @FTranType = 21
             SELECT TOP 1 @FLastChecker = isnull(FChecker, 0)
             FROM t_YXSetEntry
             WHERE FTableName = 4
                   AND FChecker = @FCheckerID;
         IF @FTranType = 10
             SELECT TOP 1 @FLastChecker = isnull(FChecker, 0)
             FROM t_YXSetEntry
             WHERE FTableName = 9
                   AND FChecker = @FCheckerID;
         IF @FTranType = 24
             SELECT TOP 1 @FLastChecker = isnull(FChecker, 0)
             FROM t_YXSetEntry
             WHERE FTableName = 7
                   AND FChecker = @FCheckerID;
         IF @FTranType = 2
             SELECT TOP 1 @FLastChecker = isnull(FChecker, 0)
             FROM t_YXSetEntry
             WHERE FTableName = 8
                   AND FChecker = @FCheckerID;
         IF @FTranType = 29
             SELECT TOP 1 @FLastChecker = isnull(FChecker, 0)
             FROM t_YXSetEntry
             WHERE FTableName = 10
                   AND FChecker = @FCheckerID;
         IF @FTranType = 41
             SELECT TOP 1 @FLastChecker = isnull(FChecker, 0)
             FROM t_YXSetEntry
             WHERE FTableName = 15
                   AND FChecker = @FCheckerID;
         IF @FLastChecker = @FCheckerID
             BEGIN
                 IF(LEN(@DBName) > 0)
                   AND UPDATE(FCurCheckLevel)
                   AND @FCheckerID > 0  --and UPDATE(FCheckerID)
                     BEGIN
		
		
	
	
		--------物料、单位、仓库---------------
                         SET @msg = '';
                         SET @nSQL = ' select @p2=t2.FNumber from  ICStockBillEntry t inner join t_ICItem t2 on t.FItemID=t2.FItemID  left join '+@DBName+'.dbo.t_ICItem t21 on t21.FNumber=t2.FNumber 
					where t21.FItemID is null and  t.FInterID='+@FinterID;
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   Varchar(50)  output ',
                              @msg OUTPUT;
                         IF LEN(@msg) > 0
                             BEGIN
                                 SET @msg = '<物料：'+@msg+'>,财务帐套不存在该物料,不能审核!';
                                 RAISERROR(@msg, 18, 18);
                                 ROLLBACK TRAN;
                             END;
                         SET @nSQL = ' select @p2=t2.FNumber from  ICStockBillEntry t inner join t_measureunit t2 on t.FUnitID=t2.FMeasureUnitID  left join '+@DBName+'.dbo.t_measureunit t21 on t21.FNumber=t2.FNumber 
					where t21.FItemID is null and  t.FInterID='+@FinterID;
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   Varchar(50)  output ',
                              @msg OUTPUT;
                         IF LEN(@msg) > 0
                             BEGIN
                                 SET @msg = '<计量单位：'+@msg+'>,财务帐套不存在该计量单位,不能审核!';
                                 RAISERROR(@msg, 18, 18);
                                 ROLLBACK TRAN;
                             END;
                         SET @nSQL = ' select @p2=t2.FNumber from  (select FInterID,FDCStockID from ICStockBillEntry union select FInterID,FSCStockID from ICStockBillEntry  ) t 
					inner join t_Stock t2 on t2.FItemID=t.FDCStockID  left join '+@DBName+'.dbo.t_Stock t21 on t21.FNumber=t2.FNumber 
					where t21.FItemID is null and  t.FInterID='+@FinterID;
                         EXEC sp_executesql
                              @nSQL,
                              N'@p2   Varchar(50)  output ',
                              @msg OUTPUT;
                         IF LEN(@msg) > 0
                             BEGIN
                                 SET @msg = '<仓库：'+@msg+'>,财务帐套不存在该仓库,不能审核!';
                                 RAISERROR(@msg, 18, 18);
                                 ROLLBACK TRAN;
                             END; 
		------------------------


                         SET @pp = 0;
                         SET @nSql = ' exec '+@DBName+'.dbo.GetICMaxNum ''ICStockBill'',@p2 output,1,16394';
                         EXEC sp_executesql
                              @nSql,
                              N'@p2   int   output ',
                              @pp OUTPUT;
		
		--set @nSql=' exec '+ @DBName+'.dbo.p_BM_GetBillNo 1,@p2 output' 
		--exec sp_executesql  @nSql ,N'@p2   varchar(50)   output ',@FBillNo   output
                         IF @FTranType = 1
                            OR @FTranType = 10
                            OR @FTranType = 2
                             BEGIN
                                 SET @Sql = 'insert into '+@DBName+'.dbo.ICStockBill(FBrNo,FInterID,FTranType,FDate,FBillNo,FRefType,
						FSupplyID,FDeptID,FEmpID,FFManagerID,FSManagerID,FManagerID,FAcctID,
						FBillerID,FROB,FStatus,FSaleStyle,FPOStyle,FSelTranType,FSettleDate,FBrID,FVchInterID,FRelateBrID,
						FPurposeID,FBillTypeID,FExplanation,FCheckerID,FCheckDate,FMultiCheckLevel2,FMultiCheckDate2) '+'select FBrNo,'+CAST(@pp AS VARCHAR(10))+',FTranType,FDate,FBillNo,FRefType,
				isnull((select top 1 FItemID from '+@DBName+'.dbo.t_supplier where FNumber=(select FNumber from t_supplier where FItemID=t.FSupplyID)),0),
				isnull((select top 1 FItemID from '+@DBName+'.dbo.t_department where FNumber=(select FNumber from t_department where FItemID=t.FDeptID)),0),
				isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FEmpID)),0),
				isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FFManagerID)),0),
				isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FSManagerID)),0),
				isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FManagerID)),0),
				isnull((select top 1 FAccountID from '+@DBName+'.dbo. t_Account where fNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAcctID)),0),
				FBillerID,FROB,FStatus,FSaleStyle,FPOStyle,FSelTranType,FSettleDate,FBrID,0,FRelateBrID,
				FPurposeID,FBillTypeID,FExplanation,FCheckerID,FCheckDate,
				isnull((select top 1 fuserid from '+@DBName+'.dbo.t_User where FName=(select FName from t_User where fuserid=t.FMultiCheckLevel2)),0), (case when '+CAST(@LastCheckLevel AS VARCHAR)+' =3 then FMultiCheckDate2 else null end) as FMultiCheckDate2  
				from ICStockBill t 
				where t.FinterID='+@FinterID;
                                 EXEC (@Sql);
                             END;
                             ELSE
                         IF @FTranType = 21
                            OR @FTranType = 29
                            OR @FTranType = 24
                            OR @FTranType = 41	----FBillTypeID,FManagerID,
                             BEGIN
                                 SET @Sql = 'insert into '+@DBName+'.dbo.ICStockBill(FBrNo,FInterID,FTranType,FDate,FBillNo,FRefType,
						FSupplyID,FDeptID,FEmpID,FFManagerID,FSManagerID,FManagerID,FAcctID,
						FBillerID,FROB,FStatus,FSaleStyle,FPOStyle,FSelTranType,FSettleDate,FBrID,FVchInterID,FRelateBrID,
						FPurposeID,FBillTypeID,FExplanation,FCheckerID,FCheckDate,FMultiCheckLevel2,FMultiCheckDate2) '+'select FBrNo,'+CAST(@pp AS VARCHAR(10))+',FTranType,FDate,FBillNo,FRefType,
				isnull((select top 1 FItemID from '+@DBName+'.dbo.t_Organization where FNumber=(select FNumber from t_Organization where FItemID=t.FSupplyID)),0),
				isnull((select top 1 FItemID from '+@DBName+'.dbo.t_department where FNumber=(select FNumber from t_department where FItemID=t.FDeptID)),0),
				isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FEmpID)),0),
				isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FFManagerID)),0),
				isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FSManagerID)),0),
				isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber=(select FNumber from t_emp where FItemID=t.FManagerID)),0),
				isnull((select top 1 FAccountID from '+@DBName+'.dbo. t_Account where fNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAcctID)),0),
				FBillerID,FROB,FStatus,FSaleStyle,FPOStyle,FSelTranType,FSettleDate,FBrID,0,FRelateBrID,
				FPurposeID,FBillTypeID,FExplanation,FCheckerID,FCheckDate,
				isnull((select top 1 fuserid from '+@DBName+'.dbo.t_User where FName=(select FName from t_User where fuserid=t.FMultiCheckLevel2)),0), (case when '+CAST(@LastCheckLevel AS VARCHAR)+' =3 then FMultiCheckDate2 else null end) as FMultiCheckDate2  
				from ICStockBill t 
				where t.FinterID='+@FinterID;
                                 EXEC (@Sql);
                             END;
                         UPDATE ICStockBill
                           SET
                               FSynchroID = @pp
                         WHERE FInterID = @FInterID;
		--select FSynchroID from ICStockBill

                         SET @Sql = 'insert into '+@DBName+'.dbo.ICStockBillEntry(FBrNo,FInterID,FEntryID,FBatchNo,FNote,
				FItemID,FUnitID,FDCStockID,FSCStockID,FPrice,FAuxPrice,FQty,FAuxQty,FQtyMust,FAuxQtyMust,FAmount,FConsignPrice,FConsignAmount,FKFDate,FKFPeriod,FPeriodDate,
				FReProduceType,FSourceTranType,FSourceEntryID,FSourceBillNo,FSourceInterId,FOrderEntryID, FOrderBillNo, FOrderInterID,FChkPassItem) '+'select FBrNo,'+CAST(@pp AS VARCHAR(10))+',FEntryID,FBatchNo,FNote,
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_ICItem where FNumber=(select FNumber from t_ICItem where FItemID=t.FItemID)),0),
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_measureunit where FNumber=(select FNumber from t_measureunit where FMeasureUnitID=t.FUnitID)),0),
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_Stock where FNumber=(select FNumber from t_Stock where FItemID=t.FDCStockID)),0),
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_Stock where FNumber=(select FNumber from t_Stock where FItemID=t.FSCStockID)),0),
			FPrice,FAuxPrice,FQty,FAuxQty,FQtyMust,FAuxQtyMust,FAmount,FConsignPrice,FConsignAmount,FKFDate,FKFPeriod,FPeriodDate,
			FReProduceType,0,0,'''',0,0, '''', 0,FChkPassItem
			from ICStockBillEntry t 
			where t.FInterID='+@FinterID;
                         EXEC (@Sql);

		-----------库存更新----------------------
                         IF @FTranType = 1
                            OR @FTranType = 10
                            OR @FTranType = 2  		-- 外购入库、其他入库、产品入库
                             BEGIN
                                 SET @Sql = 'update t1 set t1.FQty=t1.FQty+(u1.FQty),t1.FSecQty=t1.FSecQty+(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from '+@DBName+'.dbo.ICStockBillEntry where  FInterID ='+CAST(@pp AS VARCHAR(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join '+@DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  ';
                                 EXEC (@sql);
                                 SET @Sql = 'insert into '+@DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,u1.FQty,u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from '+@DBName+'.dbo.ICStockBillEntry where  FInterID ='+CAST(@pp AS VARCHAR(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join '+@DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null';
                                 EXEC (@sql);
                             END;
                             ELSE
                         IF @FTranType = 21
                            OR @FTranType = 29	   --销售出库、其他出库
                             BEGIN
                                 SET @Sql = 'update t1 set t1.FQty=t1.FQty-(u1.FQty),t1.FSecQty=t1.FSecQty-(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from '+@DBName+'.dbo.ICStockBillEntry where  FInterID ='+CAST(@pp AS VARCHAR(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join '+@DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  ';
                                 EXEC (@sql);
                                 SET @Sql = 'insert into '+@DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,-1*u1.FQty,-1*u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from '+@DBName+'.dbo.ICStockBillEntry where  FInterID ='+CAST(@pp AS VARCHAR(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join '+@DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null';
                                 EXEC (@sql);
				----2014-11-13 yexuefeng add AutoIcsale
                                 IF @FTranType = 21--生成销售发票
                                     BEGIN
                                         SET @Sql = 'EXEC '+@DBName+'.dbo.sp_xsckAutoIcsale '+CAST(@pp AS VARCHAR(10));
                                         EXEC (@sql);
                                     END; 
			----2014-11-13 yexuefeng add AutoIcsale
                             END;
                             ELSE
                         IF @FTranType = 24		--生产领料
                             BEGIN
                                 SET @Sql = 'update t1 set t1.FQty=t1.FQty-(u1.FQty),t1.FSecQty=t1.FSecQty-(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from '+@DBName+'.dbo.ICStockBillEntry where  FInterID ='+CAST(@pp AS VARCHAR(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join '+@DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  ';
                                 EXEC (@sql);
                                 SET @Sql = 'insert into '+@DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,-1*u1.FQty,-1*u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from '+@DBName+'.dbo.ICStockBillEntry where  FInterID ='+CAST(@pp AS VARCHAR(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join '+@DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null';
                                 EXEC (@sql);
                             END;
                             ELSE
                         IF @FTranType = 41	--调拨单库存 yexuefeng
                             BEGIN
                                 SET @Sql = 'EXEC '+@DBName+'.dbo.sp_ic41tb_auto_ICInventory  '+CAST(@pp AS VARCHAR(10));
                                 EXEC (@sql);
                             END; 
		
		-----------------------------------------
                     END;
             END;
         IF(LEN(@DBName) > 0)
           AND UPDATE(FCurCheckLevel)
           AND @FCheckerID = 0  --and UPDATE(FCheckerID)
             BEGIN
------*********************** 此处要改目标帐套名*****************************************	
                 IF EXISTS
(
    SELECT 1
    FROM CON14.Test_YXSP2_3B.dbo.ICStockBill
    WHERE isnull(FCheckerID, 0) > 0
          AND FInterID = @FSynchroID
)
------*********************** 此处要改目标帐套名*****************************************
                     BEGIN
                         RAISERROR('请选反审目标帐套单据', 18, 18);
                         ROLLBACK TRAN;
                     END;
      
		
		-----------库存更新----------------------
                 IF @FTranType = 1
                    OR @FTranType = 10
                    OR @FTranType = 2 --外购入库、其他入库、产品入库
                     BEGIN
                         SET @Sql = 'update t1 set t1.FQty=t1.FQty-(u1.FQty),t1.FSecQty=t1.FSecQty-(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from '+@DBName+'.dbo.ICStockBillEntry where  FInterID ='+CAST(@FSynchroID AS VARCHAR(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join '+@DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  ';
                         EXEC (@sql);
                         SET @Sql = 'insert into '+@DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,-1 * u1.FQty,-1 * u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from '+@DBName+'.dbo.ICStockBillEntry where  FInterID ='+CAST(@FSynchroID AS VARCHAR(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join '+@DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null';
                         EXEC (@sql);
                     END;
                     ELSE
                 IF @FTranType = 21
                    OR @FTranType = 29
                     BEGIN
                         SET @Sql = 'update t1 set t1.FQty=t1.FQty+(u1.FQty),t1.FSecQty=t1.FSecQty+(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from '+@DBName+'.dbo.ICStockBillEntry where  FInterID ='+CAST(@FSynchroID AS VARCHAR(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join '+@DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  ';
                         EXEC (@sql);
                         SET @Sql = 'insert into '+@DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,u1.FQty,u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from '+@DBName+'.dbo.ICStockBillEntry where  FInterID ='+CAST(@FSynchroID AS VARCHAR(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FDCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join '+@DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null';
                         EXEC (@sql);
                     END;
                     ELSE
                 IF @FTranType = 24
                     BEGIN
                         SET @Sql = 'update t1 set t1.FQty=t1.FQty+(u1.FQty),t1.FSecQty=t1.FSecQty+(u1.FSecQty)
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID as FStockID,FDCSPID as FStockPlaceID,FKFPeriod,FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from '+@DBName+'.dbo.ICStockBillEntry where  FInterID ='+CAST(@FSynchroID AS VARCHAR(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				inner join '+@DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
				   AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0)  AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')  ';
                         EXEC (@sql);
                         SET @Sql = 'insert into '+@DBName+'.dbo.ICInventory(FBrNo,FItemID,FBatchNo,FMTONo,FAuxPropID,FStockID,FStockPlaceID,FKFPeriod,FKFDate,FQty,FSecQty)
				select '''',u1.FItemID,u1.FBatchNo,u1.FMTONo,u1.FAuxPropID,u1.FStockID,u1.FStockPlaceID,u1.FKFPeriod,u1.FKFDate,u1.FQty,u1.FSecQty
				from  (select FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID as FStockID,isnull(FDCSPID,0) as FStockPlaceID,FKFPeriod,isnull(convert(varchar(10),FKFDate,120),'''') as FKFDate,SUM(FQty) AS FQty,SUM(FSecQty) AS FSecQty 
						from '+@DBName+'.dbo.ICStockBillEntry where  FInterID ='+CAST(@FSynchroID AS VARCHAR(10))+' group by FItemID,FBatchNo,FMTONo,FAuxPropID,FSCStockID,FDCSPID,FKFPeriod,FKFDate) u1
				left join '+@DBName+'.dbo.ICInventory t1 on t1.FItemID=u1.FItemID AND t1.FBatchNo=u1.FBatchNo AND t1.FMTONo=u1.FMTONo AND t1.FAuxPropID=u1.FAuxPropID
						AND t1.FStockID=u1.FStockID AND isnull(t1.FStockPlaceID,0)=isnull(u1.FStockPlaceID,0) AND t1.FKFPeriod=u1.FKFPeriod AND isnull(t1.FKFDate,'''')=isnull(convert(varchar(10),u1.FKFDate,120),'''')
				where t1.FItemID is null';
                         EXEC (@sql);
                     END;
                     ELSE
                 IF @FTranType = 41--调拨单库存 yexuefeng
                     BEGIN
                         SET @Sql = 'EXEC '+@DBName+'.dbo.sp_ic41del_auto_ICInventory  '+CAST(@FSynchroID AS VARCHAR(10));
                         EXEC (@sql);
                     END; 
		-----------------------------------------
                 UPDATE ICStockBill
                   SET
                       FSynchroID = 0
                 WHERE FInterID = @FInterID;
                 SET @Sql = 'update '+@DBName+'.dbo.ICStockBill set FCheckerID=Null,FStatus=0,FCheckDate=Null  where FInterID='+@FSynchroID;
                 EXEC (@sql);
                 SET @Sql = 'delete from '+@DBName+'.dbo.ICStockBill where isnull(FCheckerID,0)=0 and FInterID='+@FSynchroID;
                 EXEC (@sql);
             END;
         IF(@@error <> 0)
             ROLLBACK TRANSACTION;
             ELSE
         COMMIT TRANSACTION;
     END;
GO 
---4 收款单 付款单
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[t_RP_NewReceiveBill_Update]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
) 
--print '1'else print '0'
    DROP TRIGGER t_RP_NewReceiveBill_Update;
GO
CREATE TRIGGER [dbo].[t_RP_NewReceiveBill_Update] ON [dbo].[t_RP_NewReceiveBill]
FOR UPDATE
AS
     DECLARE @DBName VARCHAR(50);
     DECLARE @FCheckerID BIGINT;
     DECLARE @FInterID VARCHAR(50);
     DECLARE @FClassTypeID VARCHAR(50);			---- 1000005	收款单 1000016	付款单 1000015 应收退款单 1000017	应付退款单
     DECLARE @FSynchroID VARCHAR(50);
     DECLARE @sql VARCHAR(4000);
     DECLARE @pp INT;
     DECLARE @FBillNo VARCHAR(50);
     DECLARE @nSql NVARCHAR(4000);
     DECLARE @FLastChecker BIGINT;
     DECLARE @LastCheckLevel INTEGER;
     BEGIN
         BEGIN TRANSACTION;
         SET NOCOUNT ON;
--	1	同步外购入库单
--2	同步采购发票
--3	同步付款单 3
--4	同步销售出库单
--5	同步销售发票
--6	同步收款单 6
--7	同步生产领料单
--8	同步产品入库单
--9	同步其他入库单  select * from ICClassMCFlowInfo
--10	同步其他出库单
--11	同步记账凭证	
         SELECT @DBName = FDBName
         FROM t_BOS_Synchro
         WHERE FK3Name = '帐套同步';
         SELECT @FInterID = FBillID,
                @FClassTypeID = FClassTypeID,
                @FSynchroID = ISNULL(FSynchroID, 0)
         FROM inserted
         WHERE FClassTypeID IN(1000005, 1000016, 1000015, 1000017);
	


--SELECT TOP 1 @FCheckerID=isnull(FProcessUserID,0)@FCheckerID=isnull(FChecker,0),  FROM ICClassMCTaskCenter where FClassTypeID = @FClassTypeID  AND fbillid=@FInterID ORDER BY fid desc


    --Select TOP 1 @LastCheckLevel=ISNULL(FCheckLevel,0) From t_MultiLevelCheck Where FBillType = @FTranType order by fchecklevel DESC
         SELECT @LastCheckLevel = ISNULL(FMaxLevel, 0)
         FROM ICClassMCFlowInfo
         WHERE FID = @FClassTypeID;--1000005
         IF @LastCheckLevel = 2
             SELECT @FCheckerID = isnull(FCheckMan2, 0)
             FROM ICClassCheckStatus1000005
             WHERE FBIllID = @FInterID;
         IF isnull(@FCheckerID, 0) = 0
             SELECT @FCheckerID = isnull(FCheckMan2, 0)
             FROM ICClassCheckStatus1000016
             WHERE FBIllID = @FInterID;
         IF @LastCheckLevel = 3
             SELECT @FCheckerID = isnull(FCheckMan3, 0)
             FROM ICClassCheckStatus1000005
             WHERE FBIllID = @FInterID;
         IF isnull(@FCheckerID, 0) = 0
             SELECT @FCheckerID = isnull(FCheckMan3, 0)
             FROM ICClassCheckStatus1000016
             WHERE FBIllID = @FInterID;
         IF @LastCheckLevel = 4
             SELECT @FCheckerID = isnull(FCheckMan4, 0)
             FROM ICClassCheckStatus1000005
             WHERE FBIllID = @FInterID;
         IF isnull(@FCheckerID, 0) = 0
             SELECT @FCheckerID = isnull(FCheckMan4, 0)
             FROM ICClassCheckStatus1000016
             WHERE FBIllID = @FInterID;
         IF @LastCheckLevel = 5
             SELECT @FCheckerID = isnull(FCheckMan5, 0)
             FROM ICClassCheckStatus1000005
             WHERE FBIllID = @FInterID;
         IF isnull(@FCheckerID, 0) = 0
             SELECT @FCheckerID = isnull(FCheckMan5, 0)
             FROM ICClassCheckStatus1000016
             WHERE FBIllID = @FInterID;
         IF @LastCheckLevel = 6
             SELECT @FCheckerID = isnull(FCheckMan6, 0)
             FROM ICClassCheckStatus1000005
             WHERE FBIllID = @FInterID;
         IF isnull(@FCheckerID, 0) = 0
             SELECT @FCheckerID = isnull(FCheckMan6, 0)
             FROM ICClassCheckStatus1000016
             WHERE FBIllID = @FInterID;
    	
    	
     --  IF (@LastCheckLevel=2) AND (@FCheckerID<=0)
    	--select @FCheckerID=isnull(FCheckMan2,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
     --   IF (@LastCheckLevel=3) AND (@FCheckerID<=0)
    	--select @FCheckerID=isnull(FCheckMan3,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
    	--    IF (@LastCheckLevel=4) AND (@FCheckerID<=0)
    	--select @FCheckerID=isnull(FCheckMan4,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
    	--    IF (@LastCheckLevel=5) AND (@FCheckerID<=0)
    	--select @FCheckerID=isnull(FCheckMan5,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID
    	--    IF (@LastCheckLevel=6) AND (@FCheckerID<=0) select * from t_RP_NewReceiveBill
    	--select @FCheckerID=isnull(FCheckMan6,0) from ICClassCheckStatus1000016  where FBIllID =@FInterID

         IF @FClassTypeID IN(1000005, 1000015)
             SELECT TOP 1 @FLastChecker = isnull(FChecker, 0)
             FROM t_YXSetEntry
             WHERE FTableName = 6
                   AND FChecker = @FCheckerID;
         IF @FClassTypeID IN(1000016, 1000017)
             SELECT TOP 1 @FLastChecker = isnull(FChecker, 0)
             FROM t_YXSetEntry
             WHERE FTableName = 3
                   AND FChecker = @FCheckerID;
         IF(LEN(@DBName) > 0)
           AND UPDATE(FMultiCheckStatus)
           AND @FCheckerID > 0
           AND @FLastChecker = @FCheckerID
           AND @FSynchroID = 0
             BEGIN 
	
	--生成编号    
                 DECLARE @SBillNo NVARCHAR(50);
                 SET @SBillNo = '';
                 DECLARE @BNoSql NVARCHAR(300);
                 SET @BNoSql = ' exec '+@DBName+'.dbo.Ly_GetICBillNo  1,'+@FClassTypeID+' ,@p2 output';
                 EXEC sp_executesql
                      @BNoSql,
                      N'@p2   nvarchar(50)   output ',
                      @SBillNo OUTPUT;
		
  --      set @BNoSql =' exec '+ @DBName+'.dbo.Pro_BosBillNo  ''XSKD'',40020,@p2 output'
		--exec sp_executesql  @BNoSql ,N'@p2   nvarchar(50)   output ',@SBillNo   output
			--t_rp_ARBillOfSH:    FCostType,FFeesMode,FBrID,FExpenseID
                 SET @pp = 0;
                 SET @nSql = ' exec '+@DBName+'.dbo.GetICMaxNum ''t_RP_NewReceiveBill'',@p2 output,1,16394';
                 EXEC sp_executesql
                      @nSql,
                      N'@p2   int   output ',
                      @pp OUTPUT;
                 SET @sql = ' insert into '+@DBName+'.dbo.t_RP_NewReceiveBill(FBillID,FMulCy,FPreAmountFor,FNumber,FDate,FFincDate,FItemClassID,FClassTypeID,
			FCustomer,FPreparer,FDepartment,FEmployee,FAccountID,FCurrencyID,FReceiveCyID,FSettleCyID,FChecker,
			FStatus,FCheckDate,FSettle,FSettleNo,FRPBank,FAdjustExchangeRate,FBankAcct,FBillType,FRPBank_Pay,FContractNo,FBankAcct_Pay,FExplanation,
			FAmountFor,FAmount,FExchangeRate,FOrderID,FSubSystemID,FYear,FPeriod,FSettleAmount,FAdjustAmount,FSettleAmountFor,
			FSettleDiscount,FSettleDiscountFor,FTaskID,FSource,FSourceID,FResourceID,FBudgetAmountFor,FOrderNo,FReceiveAmount,
			FReceiveAmountFor,FDiscountAmount,FDiscountAmountFor,FContractID,FRP,FPre,FTranType_CN) '+' select '+CAST(@pp AS VARCHAR(10))+',FMulCy,FPreAmountFor,'+''''+@SBillNo+''''+',FDate,FFincDate,FItemClassID,FClassTypeID,
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_Item where FItemClassID=t.FItemClassID and FNumber = (select top 1 FNumber from t_Item where FItemID= t.FCustomer)),0),     
			isnull((select top 1 FUserID from '+@DBName+'.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FPreparer)),16394),
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_Department where FNumber =(select top 1 FNumber from t_department where FItemID= t.FDepartment)),0),
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber =(select top 1 FNumber from t_emp where FItemID= t.FEmployee)),0),
			isnull((select top 1 FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAccountID)),0),
			isnull((select top 1 FCurrencyID from '+@DBName+'.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),1),
			isnull((select top 1 FCurrencyID from '+@DBName+'.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FReceiveCyID)),1),
			isnull((select top 1 FCurrencyID from '+@DBName+'.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FSettleCyID)),1),
			isnull((select top 1 FUserID from '+@DBName+'.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FChecker)),16394),
			
			1 as FStatus,FCheckDate,FSettle,FSettleNo,FRPBank,FAdjustExchangeRate,FBankAcct,FBillType,FRPBank_Pay,FContractNo,FBankAcct_Pay,FExplanation,
			FAmountFor,FAmount,FExchangeRate,FOrderID,FSubSystemID,FYear,FPeriod,FSettleAmount,FAdjustAmount,FSettleAmountFor,
			FSettleDiscount,FSettleDiscountFor,FTaskID,FSource,FSourceID,FResourceID,FBudgetAmountFor,FOrderNo,FReceiveAmount,
			FReceiveAmountFor,FDiscountAmount,FDiscountAmountFor,FContractID,FRP,FPre,FTranType_CN
			from  t_RP_NewReceiveBill t where t.FBillID='+@FinterID;
                 EXEC (@sql);--插入付款单主表

                 UPDATE t_RP_NewReceiveBill
                   SET
                       FSynchroID = @pp
                 WHERE FBillID = @FInterID; 
		---------插入审核流记录 2014-12-01  yexuefeng
                 SET @sql = 'INSERT INTO '+@DBName+'.dbo.ICClassCheckRecords1000005( FPage ,FBillID , FBillEntryID ,FBillNo ,FBillEntryIndex ,FCheckLevel ,
                   FCheckLevelTo ,FMode ,FCheckMan ,FCheckIdea ,FCheckDate ,FDescriptions)
                   SELECT  1 FPage ,FBillID ,0 FBillEntryID ,FNumber  FBillNo ,0 FBillEntryIndex , -99 FCheckLevel ,
                   -1 FCheckLevelTo ,0  FMode ,FChecker FCheckMan ,''''  FCheckIdea ,FCheckDate ,''审核''  FDescriptions
                   FROM '+@DBName+'.dbo.t_RP_NewReceiveBill WHERE FBillID in ('+CAST(@pp AS VARCHAR(10))+') UNION
                   SELECT 1 FPage ,FBillID ,0 FBillEntryID ,FNumber  FBillNo ,0 FBillEntryIndex ,-1 FCheckLevel ,1 FCheckLevelTo ,
                   0  FMode , FChecker FCheckMan ,''''  FCheckIdea , FCheckDate , ''审核''  FDescriptions
                   FROM '+@DBName+'.dbo.t_RP_NewReceiveBill WHERE FBillID in ('+CAST(@pp AS VARCHAR(10))+') ';
                 EXEC (@sql);          
		 
		---------插入审核流记录 2014-12-01  yexuefeng
                 SET @sql = ' insert into '+@DBName+'.dbo.t_rp_Exchange(FIndex,FSerial,FBillID,FExchangeCyID,FExchangeAmountFor,FExchangeExpenseFor,
			FExchangeExpense,FExchangeRate,FExchangeAmount,FSettleCyID,FSettleAmountFor,FSettleAmount) '+' select FIndex,FSerial,'+CAST(@pp AS VARCHAR(10))+',FExchangeCyID,FExchangeAmountFor,FExchangeExpenseFor,
			FExchangeExpense,FExchangeRate,FExchangeAmount,FSettleCyID,FSettleAmountFor,FSettleAmount 
			from  t_rp_Exchange a where FBillID='+@FinterID;
                 EXEC (@sql);
                 SET @sql = ' insert into '+@DBName+'.dbo.t_rp_ARBillOfSH(FBackAmount_Relative,FBackAmountFor_Relative,FIndex,'+'FLinkCheckAmount,FLinkCheckAmountFor,FLinkCheckQty,FRemainAmount,FRemainAmountFor,FBillID,FClassID_SRC,'+'FBillNo_SRC,FID_SRC,FEntryID_SRC,FContractNo,FOrderNo,FReceiveCyName,FReceiveAmountFor,FReceiveAmount,FReceiveExchangeRate,'+'FSettleCyName,FSettleQuantity,FSettleAmountFor,FSettleAmount,'+'FDiscountFor,FDiscount,FExchangeExpenseFor,FRemainAmountFor_SRC,FRemainAmount_SRC,FOrderEntryID,FContractEntryID,'+'FExchangeExpense,FOrderInterID,FSettleExchangeRate,FAuxPropID,FQuantity,FTaxPrice,FAccountID,FItemID,FUnitID,FReceiveCyID,FSettleCyID,'+'FAmountFor_SRC,Famount_SRC,FCheckAmountFor,FCheckAmount,FAmountFor_Entry,Famount_Entry,FRemainQty)'+' select FBackAmount_Relative,FBackAmountFor_Relative,FIndex,
			FLinkCheckAmount,FLinkCheckAmountFor,FLinkCheckQty,FRemainAmount,FRemainAmountFor,'+CAST(@pp AS VARCHAR(10))+',FClassID_SRC,
			FBillNo_SRC,isnull(t4.FInterID,0),isnull(t4.FDetailID,0),FContractNo,FOrderNo,FReceiveCyName,FReceiveAmountFor,FReceiveAmount,FReceiveExchangeRate,
			FSettleCyName,FSettleQuantity,FSettleAmountFor,FSettleAmount,
			FDiscountFor,FDiscount,FExchangeExpenseFor,FRemainAmountFor_SRC,FRemainAmount_SRC,FOrderEntryID,FContractEntryID,
			FExchangeExpense,FOrderInterID,FSettleExchangeRate,FAuxPropID,FQuantity,FTaxPrice,
			isnull((select top 1 FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAccountID)),0),
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_ICItem where FNumber=(select FNumber from t_ICItem where FItemID=t.FItemID)),0),
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_measureunit where FNumber=(select FNumber from t_measureunit where FMeasureUnitID=t.FUnitID)),0),
			isnull((select top 1 FCurrencyID from '+@DBName+'.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FReceiveCyID)),1),
			isnull((select top 1 FCurrencyID from '+@DBName+'.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FSettleCyID)),1),
			
			FAmountFor_SRC,Famount_SRC,FCheckAmountFor,FCheckAmount,FAmountFor_Entry,Famount_Entry,FRemainQty 
			from t_rp_ARBillOfSH t 
			left join (select FInterID,FSynchroID from ICSale) t2 on t2.FInterID=t.FID_SRC     
			left join (select FInterID,FDetailID,FEntryID from ICSaleEntry) t3 on t3.FDetailID=t.FEntryID_SRC   
			left join (select FInterID,FDetailID,FEntryID from '+@DBName+'.dbo.ICSaleEntry)t4 on t4.FInterID=t2.FSynchroID and  t4.FEntryID=t3.FEntryID
			where t.FBillID='+@FinterID;
                 EXEC (@sql);	--

                 SET @sql = 'INSERT INTO '+@DBName+'.dbo.t_RP_Contact (FBillID,FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,FCustomer,FDepartment,FEmployee,FCurrencyID,
			FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FPre,FK3Import,FInterestRate,FCheckType,
			FStatus,FToBal,FBillType,FInvoiceType,FItemClassID,FExplanation,FPreparer)
			select '+CAST(@pp AS VARCHAR(10))+',FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_Item where FItemClassID=t.FItemClassID and FNumber = (select top 1 FNumber from t_Item where FItemID= t.FCustomer)),0),     
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_Department where FNumber =(select top 1 FNumber from t_department where FItemID= t.FDepartment)),0),
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber =(select top 1 FNumber from t_emp where FItemID= t.FEmployee)),0),
			isnull((select top 1 FCurrencyID from '+@DBName+'.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),1),
			FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FPre,FK3Import,FInterestRate,FCheckType,
			1 AS FStatus,FToBal,FBillType,FInvoiceType,FItemClassID,FExplanation,
			isnull((select top 1 FUserID from '+@DBName+'.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FPreparer)),16394) 
			from t_RP_Contact t where FType in (5,6) and FBillID='+@FinterID;
                 EXEC (@sql);	
					--FType=(case ' + @FClassTypeID + ' when 1000005 then 5 when 1000016 then 6 end) and
             END;			----- 审核 END ---- select * from t_RP_NewReceiveBill


         IF(LEN(@DBName) > 0)
           AND UPDATE(FMultiCheckStatus)
           AND @FCheckerID <= 0
             BEGIN
--**************************************************
                 IF EXISTS
(
    SELECT 1
    FROM CON14.Test_YXSP2_3B.dbo.t_RP_NewReceiveBill
    WHERE isnull(FChecker, 0) > 0
          AND FBillID = @FSynchroID
)
--**************************************************

                     BEGIN
                         RAISERROR('请先反审目标帐套单据', 18, 18);
                         ROLLBACK TRAN;
                     END;
                 UPDATE t_RP_NewReceiveBill
                   SET
                       FSynchroID = NULL
                 WHERE FBillID = @FInterID; 
			----删除
		  --set @sql ='update ' + @DBName + '.dbo.t_RP_NewReceiveBill set FChecker=0,FStatus=0 where FBillID=' + @FSynchroID
		  --exec(@sql) 
                 SET @sql = 'delete from '+@DBName+'.dbo.t_RP_Contact where isnull(fbillid,0)>0 and  FBillID='+@FSynchroID;
                 EXEC (@sql);
                 SET @sql = 'delete from '+@DBName+'.dbo.t_rp_ARBillOfSH WHERE isnull(fbillid,0)>0 and  FBillID='+@FSynchroID;
                 EXEC (@sql);
                 SET @sql = 'delete from '+@DBName+'.dbo.t_rp_Exchange where isnull(fbillid,0)>0 and  FBillID='+@FSynchroID;
                 EXEC (@sql);
                 SET @sql = 'delete from '+@DBName+'.dbo.t_RP_NewReceiveBill where isnull(fbillid,0)>0 and  FBillID='+@FSynchroID;
                 EXEC (@sql);
                 SET @sql = 'update  t_RP_NewReceiveBill set  FSynchroID=0 where isnull(fbillid,0)>0 and  FBIllID='+@FinterID;
                 EXEC (@sql);
             END;
         IF(@@error <> 0)
             ROLLBACK TRANSACTION;
             ELSE
         COMMIT TRANSACTION;
     END;
GO 

--5 凭证
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[t_Lm_Voucher_Update]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER t_Lm_Voucher_Update;
GO
CREATE TRIGGER [dbo].[t_Lm_Voucher_Update] ON [dbo].[t_Voucher]
FOR UPDATE
AS 
--select ftablename,* from t_TableDescription where ftablename='t_Voucher'
--SELECT * FROM t_fielddescription WHERE FTableID =2

--select ftablename,* from t_TableDescription where ftablename='t_VoucherEntry'
--SELECT * FROM t_fielddescription WHERE FTableID =10068
     DECLARE @DBName VARCHAR(50);
     DECLARE @FInterID VARCHAR(50);
     DECLARE @FCheckerID BIGINT;
     DECLARE @FCheckerID2 BIGINT;  ---yxf20140924
     DECLARE @sql VARCHAR(4000);
     DECLARE @Frob INTEGER; --判断红字出货
     DECLARE @FStatus INT;
     DECLARE @pp INT;
     DECLARE @FBillNo VARCHAR(50);
     DECLARE @nSql NVARCHAR(4000);
     DECLARE @FSynchroID VARCHAR(50);
     DECLARE @FYear INT;
     DECLARE @FNumber INT;
     DECLARE @FPeriod INT;
     DECLARE @FLastChecker BIGINT;
     DECLARE @FTranType BIGINT;
     DECLARE @FDetailID INTEGER;
     BEGIN
--	1	同步外购入库单
--2	同步采购发票
--3	同步付款单
--4	同步销售出库单
--5	同步销售发票
--6	同步收款单
--7	同步生产领料单
--8	同步产品入库单
--9	同步其他入库单
--10	同步其他出库单          select FDBName from t_BOS_Synchro                                 
--11	同步记账凭证  FPosterID 记账人   FPosted 是否过账     	0-未过账,1-已过账                                

         SELECT @DBName = FDBName
         FROM t_BOS_Synchro
         WHERE FK3Name = '帐套同步';
         SELECT @FInterID = FVoucherID,
                @FTranType = isnull(FTranType, 0),
                @FCheckerID = ISNULL(FPosterID, 0),
                @FCheckerID2 = isnull(FCheckerID, 0),
                @FSynchroID = isnull(FSynchroID, 0),
                @FStatus = isnull(FPosted, 0)
         FROM inserted;
         SELECT @FYear = FYear,
                @FNumber = ISNULL(FSerialNum, ''),
                @FPeriod = FPeriod
         FROM inserted;
         SELECT TOP 1 @FLastChecker = isnull(FChecker, 0)
         FROM t_YXSetEntry
         WHERE FTableName = 11
               AND FChecker = @FCheckerID;
         IF(LEN(@DBName) > 0)
           AND UPDATE(FPosterID)
           AND @FCheckerID > 0
           AND @FStatus = 1
           AND @FLastChecker = @FCheckerID --and @FTranType=2
             BEGIN
                 DECLARE @F1 INTEGER, @F2 INTEGER, @F3 INTEGER, @F8 INTEGER, @FdetailCount INTEGER, @FdetailIDMax INTEGER;
                 DECLARE itemdetail_cursor CURSOR
                 FOR
 --********************************************************
                     SELECT a.*
                     FROM
(
    SELECT ISNULL(
(
    SELECT TOP 1 Fitemid
    FROM CON14.Test_YXSP2_3B.dbo.t_item
    WHERE FItemClassID = 1
          AND FNumber = ISNULL(
(
    SELECT TOP 1 fnumber
    FROM t_item
    WHERE FItemClassID = 1
          AND FItemID = f1
), 0)
), 0) AS F1,
           ISNULL(
(
    SELECT TOP 1 Fitemid
    FROM CON14.Test_YXSP2_3B.dbo.t_item
    WHERE FItemClassID = 2
          AND FNumber = ISNULL(
(
    SELECT TOP 1 fnumber
    FROM t_item
    WHERE FItemClassID = 2
          AND FItemID = f2
), 0)
), 0) AS F2,
           ISNULL(
(
    SELECT TOP 1 Fitemid
    FROM CON14.Test_YXSP2_3B.dbo.t_item
    WHERE FItemClassID = 3
          AND FNumber = ISNULL(
(
    SELECT TOP 1 fnumber
    FROM t_item
    WHERE FItemClassID = 3
          AND FItemID = f3
), 0)
), 0) AS F3,
           ISNULL(
(
    SELECT TOP 1 Fitemid
    FROM CON14.Test_YXSP2_3B.dbo.t_item
    WHERE FItemClassID = 8
          AND FNumber = ISNULL(
(
    SELECT TOP 1 fnumber
    FROM t_item
    WHERE FItemClassID = 8
          AND FItemID = f8
), 0)
), 0) AS F8,
           a.FdetailCount 
  --****************************************************************
    FROM t_itemdetail a,
         t_VoucherEntry b
    WHERE a.FDetailID = b.FDetailID
          AND b.FVoucherID = @FinterID
          AND a.FDetailID > 0
) a,
CON14.Test_YXSP2_3B.dbo.t_itemdetail b
                     WHERE a.f1 <> b.f1
                           AND a.f2 <> b.f2
                           AND a.f3 <> b.f3
                           AND a.f8 <> b.f8;
                 OPEN itemdetail_cursor;
                 FETCH NEXT FROM itemdetail_cursor INTO @F1, @F2, @F3, @F8, @FdetailCount;
                 WHILE @@FETCH_STATUS = 0
                     BEGIN
--****************************************************
                         SELECT @FdetailIDMax = ISNULL(MAX(FdetailID) + 1, 0)
                         FROM CON14.Test_YXSP2_3B.dbo.t_itemdetail;
                         INSERT INTO CON14.Test_YXSP2_3B.dbo.T_itemdetail
(F1,
 F2,
 F3,
 F8,
 FdetailCount,
 FdetailID
)
                                SELECT ISNULL(@F1, 0),
                                       ISNULL(@F2, 0),
                                       ISNULL(@F3, 0),
                                       ISNULL(@F8, 0),
                                       ISNULL(@FdetailCount, 0),
                                       @FdetailIDMax;
                         IF @F1 > 0
                             INSERT INTO t_itemdetailv
(fdetailid,
 fitemclassid,
 fitemid
) 
     --*****************************************************
                                    SELECT fdetailid,
                                           ISNULL(
(
    SELECT TOP 1 fitemclassid
    FROM CON14.Test_YXSP2_3B.dbo.t_Item
    WHERE FItemClassID = 1
          AND FItemID = @F1
), 0),
                                           ISNULL(@F1, 0)
                                    FROM CON14.Test_YXSP2_3B.dbo.t_itemdetail
                                    WHERE FDetailID = @FdetailIDMax;
                         IF @F2 > 0
                             INSERT INTO t_itemdetailv
(fdetailid,
 fitemclassid,
 fitemid
) 
     --********************************************************
                                    SELECT fdetailid,
                                           ISNULL(
(
    SELECT TOP 1 fitemclassid
    FROM CON14.Test_YXSP2_3B.dbo.t_Item
    WHERE FItemClassID = 2
          AND FItemID = @F2
), 0),
                                           ISNULL(@F2, 0)
                                    FROM CON14.Test_YXSP2_3B.dbo.t_itemdetail
                                    WHERE FDetailID = @FdetailIDMax;
                         IF @F3 > 0
                             INSERT INTO t_itemdetailv
(fdetailid,
 fitemclassid,
 fitemid
)
                                    SELECT fdetailid,
                                           ISNULL(
(
    SELECT TOP 1 fitemclassid
    FROM CON14.Test_YXSP2_3B.dbo.t_Item
    WHERE FItemClassID = 3
          AND FItemID = @F3
), 0),
                                           ISNULL(@F3, 0)
                                    FROM CON14.Test_YXSP2_3B.dbo.t_itemdetail
                                    WHERE FDetailID = @FdetailIDMax;
                         IF @F8 > 0
                             INSERT INTO t_itemdetailv
(fdetailid,
 fitemclassid,
 fitemid
)
                                    SELECT fdetailid,
                                           ISNULL(
(
    SELECT TOP 1 fitemclassid
    FROM CON14.Test_YXSP2_3B.dbo.t_Item
    WHERE FItemClassID = 8
          AND FItemID = @F8
), 0),
                                           ISNULL(@F8, 0)
                                    FROM CON14.Test_YXSP2_3B.dbo.t_itemdetail
                                    WHERE FDetailID = @FdetailIDMax;
	--************************************************************* 
                         FETCH NEXT FROM itemdetail_cursor INTO @F1, @F2, @F3, @F8, @FdetailCount;
                     END;
                 CLOSE itemdetail_cursor;
                 DEALLOCATE itemdetail_cursor; 
--**************************************
                 UPDATE a
                   SET
                       FNext = FNext + 1
                 FROM CON14.Test_YXSP2_3B.dbo.t_Identity a
                 WHERE FName = 't_Voucher';
                 SELECT TOP 1 @pp = FNext
                 FROM CON14.Test_YXSP2_3B.dbo.t_Identity
                 WHERE FName = 't_Voucher';
		--set @nSql=' exec '+ @DBName+'.dbo.GetICMaxNum ''t_Voucher'',@p2 output,1,16394'
		--exec sp_executesql  @nSql ,N'@p2   int   output ',@pp   output

                 SET @sql = 'update  t_Voucher  set FSynchroID='+CAST(@pp AS VARCHAR)+',FSynchroIDNum=(select isnull(max(FNumber),0)+1 as FNum from '+@DBName+'.dbo.t_Voucher where FYear='+CAST(@fyear AS VARCHAR)+' and FPeriod='+CAST(@FPeriod AS VARCHAR)+')  where FVoucherID='+@FInterID+' and  ISNULL(FSynchroID,0) not in (select FVoucherID from '+@DBName+'.dbo.t_Voucher  )';
--+ ' and FSerialNum not in (select FSerialNum from ' + @DBName + '.dbo.t_Voucher where FYear='+CAST(@fyear AS VARCHAR) + ' and FPeriod='+ CAST(@FPeriod AS VARCHAR)+
--' and FSerialNum='+   CAST(@FNumber AS VARCHAR) +')'
                 EXEC (@sql);
                 SET @sql = 'insert into '+@DBName+'.dbo.t_VoucherEntry(
FVoucherID,FAccountID,FAccountID2,FAmount,FAmountFor,FBrNo
,FCashFlowItem,FCurrencyID,FDC,FDetailID,FEntryID,FExchangeRate,FExplanation
,FInternalInd,FMeasureUnitID,FQuantity,FResourceID,FSettleNo,FSettleTypeID,FTaskID,FTransNo,FUnitPrice)    
select '+CAST(@pp AS VARCHAR(10))+'
,isnull((select top 1 FAccountID from '+@DBName+'.dbo.t_Account where fNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAccountID)),0)
,isnull((select top 1 FAccountID from '+@DBName+'.dbo.t_Account where fNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAccountID2)),0)                                                                     
,FAmount,FAmountFor
,isnull((select top 1 FItemID from '+@DBName+'.dbo.t_organization where fNumber=(select top 1 FNumber from t_organization where fItemID=t.FBrNo )),0)      
,FCashFlowItem,FCurrencyID,FDC,       




 isnull((SELECT top 1 isnull(b.FDetailID,0) FROM   (SELECT ISNULL((SELECT TOP 1 Fitemid FROM  '+@DBName+'.dbo.t_item WHERE FItemClassID=1 AND FNumber =ISNULL((SELECT TOP 1 fnumber FROM t_item WHERE FItemClassID=1 AND FItemID=f1),0)),0) AS F1,
  ISNULL((SELECT TOP 1 Fitemid FROM  '+@DBName+'.dbo.t_item WHERE FItemClassID=2 AND FNumber =ISNULL((SELECT TOP 1 fnumber FROM t_item WHERE FItemClassID=2 AND FItemID=f2),0)),0) AS F2,
  ISNULL((select TOP 1 Fitemid FROM  '+@DBName+'.dbo.t_item WHERE FItemClassID=3 AND FNumber =ISNULL((SELECT TOP 1 fnumber FROM t_item WHERE FItemClassID=3 AND FItemID=f3),0)),0) AS F3,
  ISNULL((select TOP 1 Fitemid FROM  '+@DBName+'.dbo.t_item WHERE FItemClassID=8 AND FNumber =ISNULL((SELECT TOP 1 fnumber FROM t_item WHERE FItemClassID=8 AND FItemID=f8),0)),0) AS F8,
  a.FdetailCount 
   FROM t_itemdetail a WHERE a.FDetailID=t.FDetailID AND a.FDetailID>0 ) a , '+@DBName+'.dbo.t_itemdetail b 
   WHERE a.f1=b.f1 AND a.f2=b.f2 AND a.f3=b.f3 AND a.f8=b.f8),0)






       
,FEntryID,FExchangeRate,t.FExplanation                                                                    
,t.FInternalInd,FMeasureUnitID,FQuantity,FResourceID,FSettleNo,FSettleTypeID,FTaskID,FTransNo,FUnitPrice
 from t_VoucherEntry t , t_Voucher ee where t.FVoucherID=ee.FVoucherID and t.FVoucherID='+@FinterID+' and isnull(ee.FSynchroID,0) not in (select FVoucherID from '+@DBName+'.dbo.t_Voucher where FYear='+CAST(@fyear AS VARCHAR)+' and FPeriod='+CAST(@FPeriod AS VARCHAR)+')';
                 EXEC (@sql);
                 SET @sql = --		'insert into ' + @DBName + '.dbo.t_Voucher(FVoucherID,FAttachments,FBrNo,FCashierID,FChecked,FCheckerID,FCreditTotal,
--FDate,FDebitTotal,FEntryCount,FExplanation,FFootNote,FFrameWorkID,FGroupID,FHandler,FInternalInd,FNumber,
--FObjectName,FOwnerGroupID,FParameter,FPeriod,FPosted,FPreparerID,FReference,FSerialNum,FTransDate,FTranType,FApproveID,FYear) 
--select   '+cast(@pp as varchar(10))+'
--,FAttachments,isnull((select top 1 FItemID from ' + @DBName + '.dbo. t_organization where fNumber=(select top 1 FNumber from t_organization where fItemID=t.FBrNo )),0)      
--,-1
--,0,-1
--,FCreditTotal,FDate,FDebitTotal,FEntryCount,FExplanation,FFootNote,FFrameWorkID,FGroupID
--,isnull((select top 1 FItemID from ' + @DBName + '.dbo.t_emp where FNumber = (select top 1 FNumber from t_emp where FItemID= t.FHandler)),0)
--,FInternalInd,0
--,FObjectName,FOwnerGroupID,FParameter,FPeriod  
--,0,isnull((select top 1 FUserID from ' + @DBName + '.dbo.t_User where FName = (select top 1 FName from  t_User where FUserID= t.FPreparerID)),16394)
--,FReference,FSerialNum,FTransDate,FTranType,FApproveID,FYear  from t_Voucher t where t.FVoucherID='+@FinterID 

--+ ' and t.FSynchroID not in (select FVoucherID from ' + @DBName + '.dbo.t_Voucher where FYear='+CAST(@fyear AS VARCHAR) + ' and FPeriod='+ CAST(@FPeriod AS VARCHAR)+
--')'
                 'insert into '+@DBName+'.dbo.t_Voucher(FVoucherID,FAttachments,FBrNo,FCashierID,FChecked,FCheckerID,FCreditTotal,
FDate,FDebitTotal,FEntryCount,FExplanation,FFootNote,FFrameWorkID,FGroupID,FHandler,FInternalInd,FNumber,
FObjectName,FOwnerGroupID,FParameter,FPeriod,FPosted,FPreparerID,FReference,FSerialNum,FTransDate,FTranType,FApproveID,FYear) 
select   '+CAST(@pp AS VARCHAR(10))+'
,FAttachments,isnull((select top 1 FItemID from '+@DBName+'.dbo. t_organization where fNumber=(select top 1 FNumber from t_organization where fItemID=t.FBrNo )),0)      
,-1
,0,-1
,FCreditTotal,FDate,FDebitTotal,FEntryCount,FExplanation,FFootNote,FFrameWorkID,FGroupID
,isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber = (select top 1 FNumber from t_emp where FItemID= t.FHandler)),null)
,FInternalInd,0
,FObjectName,FOwnerGroupID,FParameter,FPeriod  
,0,isnull((select top 1 FUserID from '+@DBName+'.dbo.t_User where FName = (select top 1 FName from  t_User where FUserID= t.FPreparerID)),16394)
,FReference,FSerialNum,FTransDate,FTranType,FApproveID,FYear  from t_Voucher t where t.FVoucherID='+@FinterID+' and isnull(t.FSynchroID,0) not in (select FVoucherID from '+@DBName+'.dbo.t_Voucher where FYear='+CAST(@fyear AS VARCHAR)+' and FPeriod='+CAST(@FPeriod AS VARCHAR)+')';
                 EXEC (@sql);
                 SET @sql = 'Update '+@DBName+'.dbo.t_Voucher set FNumber=(select isnull(max(FNumber),0)+1 as FNum from '+@DBName+'.dbo.t_Voucher where FYear='+CAST(@fyear AS VARCHAR)+' and FPeriod='+CAST(@FPeriod AS VARCHAR)+') where FVoucherID='+CAST(@pp AS VARCHAR(10));
                 EXEC (@sql);
             END;	
	
	
 
		---- 反审核 select *   from   test  insert into ljwtest(oo) values(@Sql)
         IF(LEN(@DBName) > 0)
           AND UPDATE(FCheckerID)
           AND @FCheckerID = -1
           AND @FCheckerID2 = -1-- and @FTranType=2 
             BEGIN
                 SET @sql = 'update  t_Voucher  set FSynchroID=null,FSynchroIDNum=0 where FVoucherID='+@FInterID+' and FSynchroID in ('+'select FVoucherID from '+@DBName+'.dbo.t_Voucher where FChecked <=0 and  FVoucherID='+@FSynchroID+')';
                 EXEC (@Sql);	
		
		--SET @Sql ='alter table ' + @DBName + '.dbo.t_Voucher disable trigger t_Voucher_Delete' 
		--EXEC(@Sql)	

                 SET @Sql = 'delete from '+@DBName+'.dbo.t_VoucherEntry where FVoucherID='+@FSynchroID+' and FVoucherID in ('+'select FVoucherID from '+@DBName+'.dbo.t_Voucher where FChecked <=0 and  FVoucherID='+@FSynchroID+')';
                 EXEC (@Sql);
                 SET @Sql = 'delete from '+@DBName+'.dbo.t_Voucher where FChecked <=0 and  FVoucherID='+@FSynchroID;
                 EXEC (@Sql);
	  
 		--SET @Sql ='alter table ' + @DBName + '.dbo.t_Voucher enable  trigger t_Voucher_Delete' 
		--EXEC(@Sql)	



             END;
     END;
GO


------13其他应收单其他应付单 
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[t_RP_ARPBill_Update]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER t_RP_ARPBill_Update;
GO
CREATE TRIGGER [dbo].[t_RP_ARPBill_Update] ON [dbo].t_RP_ARPBill
FOR UPDATE
AS
     DECLARE @DBName VARCHAR(50);
     DECLARE @FCheckerID BIGINT;
     DECLARE @FInterID VARCHAR(50);
     DECLARE @FClassTypeID VARCHAR(50);			---- 1000021	其他应收单 1000022	其他应付单    
     DECLARE @FSynchroID VARCHAR(50);
     DECLARE @sql VARCHAR(4000);
     DECLARE @pp INT;
     DECLARE @FBillNo VARCHAR(50);
     DECLARE @nSql NVARCHAR(4000);
     DECLARE @FLastChecker BIGINT;
     DECLARE @LastCheckLevel INTEGER;
     DECLARE @FSource VARCHAR(50);
     BEGIN
         BEGIN TRANSACTION;
         SET NOCOUNT ON;
--	1	同步外购入库单
--2	同步采购发票
--3	同步付款单 3
--4	同步销售出库单
--5	同步销售发票
--6	同步收款单 6
--7	同步生产领料单
--8	同步产品入库单
--9	同步其他入库单  select * from ICClassMCFlowInfo
--10	同步其他出库单
--11	同步记账凭证	
         SELECT @DBName = FDBName
         FROM t_BOS_Synchro
         WHERE FK3Name = '帐套同步';
         SELECT @FInterID = FBillID,
                @FClassTypeID = FClassTypeID,
                @FSynchroID = ISNULL(FSynchroID, 0),
                @FSource = ISNULL(FSource, 0)
         FROM inserted
         WHERE FClassTypeID IN(1000021, 1000022);
         SELECT @LastCheckLevel = ISNULL(FMaxLevel, 0)
         FROM ICClassMCFlowInfo
         WHERE FID = @FClassTypeID;--1000021
         IF @LastCheckLevel = 2
             SELECT @FCheckerID = isnull(FCheckMan2, 0)
             FROM ICClassCheckStatus1000021
             WHERE FBIllID = @FInterID;
         IF isnull(@FCheckerID, 0) = 0
             SELECT @FCheckerID = isnull(FCheckMan2, 0)
             FROM ICClassCheckStatus1000022
             WHERE FBIllID = @FInterID;
         IF @LastCheckLevel = 3
             SELECT @FCheckerID = isnull(FCheckMan3, 0)
             FROM ICClassCheckStatus1000021
             WHERE FBIllID = @FInterID;
         IF isnull(@FCheckerID, 0) = 0
             SELECT @FCheckerID = isnull(FCheckMan3, 0)
             FROM ICClassCheckStatus1000022
             WHERE FBIllID = @FInterID;
         IF @LastCheckLevel = 4
             SELECT @FCheckerID = isnull(FCheckMan4, 0)
             FROM ICClassCheckStatus1000021
             WHERE FBIllID = @FInterID;
         IF isnull(@FCheckerID, 0) = 0
             SELECT @FCheckerID = isnull(FCheckMan4, 0)
             FROM ICClassCheckStatus1000022
             WHERE FBIllID = @FInterID;
         IF @LastCheckLevel = 5
             SELECT @FCheckerID = isnull(FCheckMan5, 0)
             FROM ICClassCheckStatus1000021
             WHERE FBIllID = @FInterID;
         IF isnull(@FCheckerID, 0) = 0
             SELECT @FCheckerID = isnull(FCheckMan5, 0)
             FROM ICClassCheckStatus1000022
             WHERE FBIllID = @FInterID;
         IF @LastCheckLevel = 6
             SELECT @FCheckerID = isnull(FCheckMan6, 0)
             FROM ICClassCheckStatus1000021
             WHERE FBIllID = @FInterID;
         IF isnull(@FCheckerID, 0) = 0
             SELECT @FCheckerID = isnull(FCheckMan6, 0)
             FROM ICClassCheckStatus1000022
             WHERE FBIllID = @FInterID;
         IF @FClassTypeID IN(1000021, 1000021)
             SELECT TOP 1 @FLastChecker = isnull(FChecker, 0)
             FROM t_YXSetEntry
             WHERE FTableName = 6
                   AND FChecker = @FCheckerID;
         IF @FClassTypeID IN(1000022, 1000022)
             SELECT TOP 1 @FLastChecker = isnull(FChecker, 0)
             FROM t_YXSetEntry
             WHERE FTableName = 3
                   AND FChecker = @FCheckerID;
         IF(LEN(@DBName) > 0)
           AND UPDATE(FMultiCheckStatus)
           AND @FCheckerID > 0
           AND @FLastChecker = @FCheckerID
           AND @FSynchroID = 0
           AND @FSource <= 0
             BEGIN 
	
	--生成编号    
                 DECLARE @SBillNo NVARCHAR(50);
                 SET @SBillNo = '';
                 DECLARE @BNoSql NVARCHAR(300);
                 SET @BNoSql = ' exec '+@DBName+'.dbo.Ly_GetICBillNo  1,'+@FClassTypeID+' ,@p2 output';
                 EXEC sp_executesql
                      @BNoSql,
                      N'@p2   nvarchar(50)   output ',
                      @SBillNo OUTPUT;
  --      set @BNoSql =' exec '+ @DBName+'.dbo.Pro_BosBillNo  ''QTYS'',40020,@p2 output'
		--exec sp_executesql  @BNoSql ,N'@p2   nvarchar(50)   output ',@SBillNo   output
			--t_rp_ARBillOfSH:    FCostType,FFeesMode,FBrID,FExpenseID
                 SET @pp = 0;
                 SET @nSql = ' exec '+@DBName+'.dbo.GetICMaxNum ''t_RP_ARPBill'',@p2 output,1,16394';
                 EXEC sp_executesql
                      @nSql,
                      N'@p2   int   output ',
                      @pp OUTPUT;
                 SET @sql = ' insert into '+@DBName+'.dbo.t_RP_ARPBill(FBrID,	FTranStatus	,FBillID,	FRP	,FYear,	FPeriod	,FDate,	FNumber,	FBillType	,FCustomer,	
			FDepartment,	FEmployee,	FAccountID,
	FAccountID2,	FCurrencyID,	FExchangeRate,	FCheckAmount,	FCheckAmountFor,	FRemainAmount,	FRemainAMountFor,	FCheckQty,	FRemainQty,
		FAmount,	FAmountFor,	FOldBill,	FCashDiscount,	FContractID,	FContractNo,	FExplanation,	FDelete,	FVoucherID,	FGroupID,
			FRPDate,	FInterestRate,	FPreparer,	FChecker,	FStatus,	FCheckStatus,	FConnectFlag,	FSource,	FSourceID,	FItemClassID,
				FFincDate,	FCheckDate,	FConfirm,	FAdjustExchangeRate,	FAdjustAmount,	FClassTypeID,	FTaskID,	FResourceID	,FOrderID,
					FBudgetAmountFor,	FOrderAmountFor,		FDC) '+'select FBrID,	FTranStatus	,'+CAST(@pp AS VARCHAR(10))+',	FRP	,FYear,	FPeriod	,FDate,	'+''''+@SBillNo+''''+',	FBillType	,
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_Item where FItemClassID=t.FItemClassID and FNumber = (select top 1 FNumber from t_Item where FItemID= t.FCustomer)),0), 
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_Department where FNumber =(select top 1 FNumber from t_department where FItemID= t.FDepartment)),0),
 isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber =(select top 1 FNumber from t_emp where FItemID= t.FEmployee)),0),
 isnull((select top 1 FAccountID from '+@DBName+'.dbo.t_Account where FNumber=(select top 1 FNumber from t_Account where FAccountID=t.FAccountID)),0),
	FAccountID2,	
 isnull((select top 1 FCurrencyID from '+@DBName+'.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),1),
	FExchangeRate,	FCheckAmount,	FCheckAmountFor,	FRemainAmount,	FRemainAMountFor,	FCheckQty,	FRemainQty,
		FAmount,	FAmountFor,	FOldBill,	FCashDiscount,	FContractID,	FContractNo,	FExplanation,	FDelete,	0,	0,
			FRPDate,	FInterestRate,	
						isnull((select top 1 FUserID from '+@DBName+'.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FPreparer)),16394),
	
			isnull((select top 1 FUserID from '+@DBName+'.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FChecker)),16394)
			,	1 as FStatus,	FCheckStatus,	FConnectFlag,	FSource,	FSourceID,	FItemClassID,
				FFincDate,	FCheckDate,	FConfirm,	FAdjustExchangeRate,	FAdjustAmount,	FClassTypeID,	FTaskID,	FResourceID	,FOrderID,
					FBudgetAmountFor,	FOrderAmountFor,		FDC from  t_RP_ARPBill t where  t.FBillID='+@FinterID;
--					SELECT TOP 1 * FROM  t_rp_arpbill  ISNULL(t.FSource,0)<=0 and
--SELECT * FROM t_fielddescription WHERE FTableID =50040 --从表查新单据字段


                 EXEC (@sql);--插入付款单主表

                 UPDATE t_RP_ARPBill
                   SET
                       FSynchroID = @pp
                 WHERE FBillID = @FInterID;
                 SET @sql = ' insert into '+@DBName+'.dbo.t_rp_arpbillentry(FBillID	,FEntryID,	FContractNo,	FContractEntryID,	FOrderNo,	FOrderEntryID,	FID_SRC	,FBillNo_SRC,	FEntryID_SRC,
	FClassID_SRC,	famountFor,	famount,	FCheckAmount,	FCheckAmountFor,	FCheckQty,	FLinkCheckAmount,	FLinkCheckAmountFor,
		FLinkCheckQty,	FCheckDate,	FRemainQty,	FPayApplyAmountFor,	FPayApplyAmount,	FAmountFor_Commit,	FAmount_Commit,	FRemainAmountFor_SRC,
			FRemainAmount_SRC,	FRemainAmountFor,	FRemainAmount,		FInvoiceAmountFor,	FInvoiceAmount	,FInvLinkCheckAmountFor,
				FInvLinkCheckAmount) '+'select '+CAST(@pp AS VARCHAR(10))+'	,FEntryID,	FContractNo,	FContractEntryID,	FOrderNo,	FOrderEntryID,	FID_SRC	,FBillNo_SRC,	FEntryID_SRC,
	FClassID_SRC,	famountFor,	famount,	FCheckAmount,	FCheckAmountFor,	FCheckQty,	FLinkCheckAmount,	FLinkCheckAmountFor,
		FLinkCheckQty,	FCheckDate,	FRemainQty,	FPayApplyAmountFor,	FPayApplyAmount,	FAmountFor_Commit,	FAmount_Commit,	FRemainAmountFor_SRC,
			FRemainAmount_SRC,	FRemainAmountFor,	FRemainAmount,		FInvoiceAmountFor,	FInvoiceAmount	,FInvLinkCheckAmountFor,
				FInvLinkCheckAmount from  t_rp_arpbillentry a where FBillID='+@FinterID;	
					
--										SELECT TOP 1 * FROM  t_rp_arpbillentry
--SELECT * FROM t_fielddescription WHERE FTableID =50042 --从表查新单据字段
                 EXEC (@sql);
                 SET @sql = ' insert into '+@DBName+'.dbo.t_rp_plan_Ar(	FOrgID,	FDate,	FAmount,	FAmountFor,	FRemainAmount,	FRemainAmountFor,	FType,	FExplanation,	FInterID,	FBillID,
	FEntryID,	FRP,	FIsInit)'+'select  	FOrgID,	FDate,	FAmount,	FAmountFor,	FRemainAmount,	FRemainAmountFor,	FType,	FExplanation,	FInterID,	 '+CAST(@pp AS VARCHAR(10))+',
	FEntryID,	FRP,	FIsInit from t_rp_plan_Ar where FbillID='+@FinterID;	
--										SELECT TOP 1 * FROM  t_rp_plan_Ar
--SELECT * FROM t_fielddescription WHERE FTableID =50038 --从表查新单据字段

                 EXEC (@sql);
                 SET @sql = 'INSERT INTO '+@DBName+'.dbo.t_RP_Contact (FRPBillID,FBillID,FYear,FPeriod,FRP,FType,FDate,FFincDate,FNumber,FCustomer,FDepartment,FEmployee,FCurrencyID,
			FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FPre,FK3Import,FInterestRate,FCheckType,
			FStatus,FToBal,FBillType,FInvoiceType,FItemClassID,FExplanation,FPreparer)
			select '+CAST(@pp AS VARCHAR(10))+',FBillID,FYear,FPeriod,FRP,FType,FDate,FFincDate,'+''''+@SBillNo+''''+',
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_Item where FItemClassID=t.FItemClassID and FNumber = (select top 1 FNumber from t_Item where FItemID= t.FCustomer)),0),     
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_Department where FNumber =(select top 1 FNumber from t_department where FItemID= t.FDepartment)),0),
			isnull((select top 1 FItemID from '+@DBName+'.dbo.t_emp where FNumber =(select top 1 FNumber from t_emp where FItemID= t.FEmployee)),0),
			isnull((select top 1 FCurrencyID from '+@DBName+'.dbo.t_Currency where FNumber = (select top 1 FNumber from  t_Currency where FCurrencyID= t.FCurrencyID)),1),
			FExchangeRate,FAmount,FAmountFor,FRemainAmount,FRemainAmountFor,FInvoiceID,FRPDate,FPre,FK3Import,FInterestRate,FCheckType,
			1 AS FStatus,FToBal,FBillType,FInvoiceType,FItemClassID,FExplanation,
			isnull((select top 1 FUserID from '+@DBName+'.dbo.t_User where FName = (select FName from  t_User where FUserID= t.FPreparer)),16394) 
			from t_RP_Contact t where FBillType in (995,992) and FRPBillID='+@FinterID;
                 EXEC (@sql);	
					--FType=(case ' + @FClassTypeID + ' when 1000005 then 5 when 1000016 then 6 end) and
             END;			----- 审核 END ----


         IF(LEN(@DBName) > 0)
           AND UPDATE(FMultiCheckStatus)
           AND @FCheckerID <= 0
             BEGIN
			----删除 select * from t_rp_arpbill
--*********************************************************
                 IF EXISTS
(
    SELECT 1
    FROM CON14.Test_YXSP2_3B.dbo.t_rp_arpbill
    WHERE isnull(FChecker, 0) > 0
          AND FBillID = @FSynchroID
)
                     BEGIN
                         RAISERROR('请选反审目标帐套单据', 18, 18);
                         ROLLBACK TRAN;
                     END;
                 UPDATE t_RP_ARPBill
                   SET
                       FSynchroID = NULL
                 WHERE FBillID = @FInterID;
                 SET @sql = 'delete from '+@DBName+'.dbo.t_RP_Contact WHERE isnull(FRPBillID,0)>0 and  FRPBillID='+@FSynchroID;
                 EXEC (@sql);
                 SET @sql = 'delete from '+@DBName+'.dbo.t_rp_plan_Ar WHERE isnull(fbillid,0)>0 and  FBillID='+@FSynchroID;
                 EXEC (@sql);
                 SET @sql = 'delete from '+@DBName+'.dbo.t_rp_arpbillentry WHERE isnull(fbillid,0)>0 and  FBillID='+@FSynchroID;
                 EXEC (@sql);
                 SET @sql = 'delete from '+@DBName+'.dbo.t_rp_arpbill WHERE isnull(fbillid,0)>0 and  FBillID='+@FSynchroID;
                 EXEC (@sql);
                 SET @sql = 'update  t_rp_arpbill set  FSynchroID=0 where isnull(fbillid,0)>0 and FBIllID='+@FinterID;
                 EXEC (@sql);
             END;
         IF(@@error <> 0)
             ROLLBACK TRANSACTION;
             ELSE
         COMMIT TRANSACTION;
     END;
GO




--------------------------

---7 tr_ICClassCheckStatus1000016_Update
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[tr_ICClassCheckStatus1000016_Update]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER tr_ICClassCheckStatus1000016_Update;
GO

--SELECT* FROM ICClassCheckStatus1000016

CREATE TRIGGER [dbo].[tr_ICClassCheckStatus1000016_Update] ON [dbo].[ICClassCheckStatus1000016]
FOR INSERT, UPDATE
AS
     BEGIN
         UPDATE a
           SET
               FMultiCheckStatus = FMultiCheckStatus
         FROM t_RP_NewReceiveBill a, inserted b
         WHERE b.FBillID = a.FBillID;
     END;
GO
----8tr_ICClassCheckStatus1000005
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[tr_ICClassCheckStatus1000005_Update]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER tr_ICClassCheckStatus1000005_Update;
GO
CREATE TRIGGER [dbo].[tr_ICClassCheckStatus1000005_Update] ON [dbo].[ICClassCheckStatus1000005]
FOR INSERT, UPDATE
AS
     BEGIN
         UPDATE a
           SET
               FMultiCheckStatus = FMultiCheckStatus
         FROM t_RP_NewReceiveBill a, inserted b
         WHERE b.FBillID = a.FBillID;
     END;
GO
---11tr_ICClassCheckStatus1000021_Update
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[tr_ICClassCheckStatus1000021_Update]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER tr_ICClassCheckStatus1000021_Update;
GO
CREATE TRIGGER [dbo].[tr_ICClassCheckStatus1000021_Update] ON [dbo].ICClassCheckStatus1000021
FOR INSERT, UPDATE
AS
     BEGIN
         UPDATE a
           SET
               FMultiCheckStatus = FMultiCheckStatus
         FROM t_RP_ARPBill a, inserted b
         WHERE b.FBillID = a.FBillID;
     END;
GO
------12 tr_ICClassCheckStatus1000022
IF EXISTS
(
    SELECT *
    FROM dbo.sysobjects
    WHERE id = OBJECT_ID(N'[dbo].[tr_ICClassCheckStatus1000022_Update]')
          AND OBJECTPROPERTY(id, N'IsTrigger') = 1
)
    DROP TRIGGER tr_ICClassCheckStatus1000022_Update;
GO
CREATE TRIGGER [dbo].[tr_ICClassCheckStatus1000022_Update] ON [dbo].ICClassCheckStatus1000022
FOR INSERT, UPDATE
AS
     BEGIN
         UPDATE a
           SET
               FMultiCheckStatus = FMultiCheckStatus
         FROM t_RP_ARPBill a, inserted b
         WHERE b.FBillID = a.FBillID;
     END;
GO