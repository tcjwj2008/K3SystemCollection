

/**Begin 新单据模板数据脚本，名称 同步数据配置表    Script Date: 2013-09-06 **/


/****** Object:Data   单据描述：ICClassType    Script Date: 2013-09-06 ******/

Delete ICClassType WHERE FID=200000000
GO
INSERT INTO ICClassType(FID,FName_CHS,FName_CHT,FName_EN,FShowIndex,FTableName,FShowType,FTemplateID,FImgID,FModel,FLogic,FBillWidth,FBillHeight,FMenuControl,FFunctionID,FFilter,FBillTypeID,FIsManageBillNo,FBillNoKey,FEntryCount,FLayerCount,FLayerNames,FPrimaryKey,FEPrimaryKey,FClassTypeKey,FIndexKey,FObjectType,FObjectID,FGroupIDView,FGroupIDManage,FComponentExt,FBillNoManageType,FAccessoryTypeID,FControl,FTimeStamp,FExtBaseDataAccess
) --,fpropertyext,FPGUID,FEGUID
VALUES (200000000,'同步数据配置表','基礎資料200000000','Master Data200000000',0,'t_YXSet',0,200000000,'',0,3,11895,3885,'',23,'',1,0,'',0,1,'CHS=;CHT=;EN=','FID','FEntryID','FClassTypeID','FIndex',4100,200000000,2101,2102,'',1,80000294,1075775667,NULL,''
) --,'','FPGUID','FEGUID'
GO

/****** Object:Data   单据分录描述：ICClassTypeEntry    Script Date: 2013-09-06 ******/

Delete ICClassTypeEntry WHERE FParentID=200000000
GO
INSERT INTO ICClassTypeEntry(FIndex,FParentID,FTableName,FLeft,FTop,FWidth,FHeight,FLayer,FEntryType,FTabIndex,FMustInput,FKeyField,FDescription_CHS,FDescription_CHT,FDescription_EN,FFilter,FUserDefine,FContainer
) --,FCanSort,FParentEntry
VALUES (1,200000000,'t_YXSet',0,2190,6000,4740,0,0,0,1,'','','','','',1,'') --,1,1
GO

INSERT INTO ICClassTypeEntry(FIndex,FParentID,FTableName,FLeft,FTop,FWidth,FHeight,FLayer,FEntryType,FTabIndex,FMustInput,FKeyField,FDescription_CHS,FDescription_CHT,FDescription_EN,FFilter,FUserDefine,FContainer
) --,FCanSort,FParentEntry
VALUES (2,200000000,'t_YXSetEntry',2775,5010,870,645,0,0,5,1,'','','','','',1,'') --,1,1
GO

/****** Object:Data   单据模板字段描述：ICClassTableInfo    Script Date: 2013-09-06 ******/

Delete ICClassTableInfo WHERE FClassTypeID=200000000
GO
INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000000,1,'代码','代碼','Code','FNumber','FNumber','t_YXSet','',2,1,2047,1,1,0,1,'',0,0,'','','','','','',1,'','',167,500,255,255,'','','SetEquation{FParentNumber}',1,'代码','',610,1125,350,2200,'0,13',0,24,0,0,0,0,'',8193,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000000,1,'是否明细','是否明細','Details (Y/N)','FDetail','FDetail','t_YXSet','',21,2,0,1,1,1,1,'',0,0,'','','','','','',1,'','',104,500,255,48,'','','',1,'是否明细','DETAIL',240,120,350,0,'-1',1,24,0,0,0,0,'',8193,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000000,1,'类别','類別','Category','FClassTypeID','FClassTypeID','t_YXSet','',22,2,0,1,1,1,1,'',0,0,'','','','','','',1,'','',231,500,255,48,'','','',1,'类别','CLASSTYPEID',240,120,350,0,'-1',2,24,0,0,0,0,'',8193,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000000,1,'父级内码','父級內碼','Parent ISN','FParentID','FParentID','t_YXSet','',5,2,0,1,1,1,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'父级内码','GRPPARENTID',0,0,0,0,'-1',4,24,0,0,0,0,'',8193,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000000,1,'名称','名稱','Name','FName','FName','t_YXSet','',4,1,12,1,1,0,1,'',0,0,'','','','','','',1,'','',167,500,255,255,'','','SetEquation{FParentName}',1,'名称','',2695,3840,350,2200,'0,13',5,24,0,0,0,0,'',8193,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000000,1,'菜单控制','功能表控制','Menu Control','FLogic','FLogic','t_YXSet','',0,2,0,1,0,1,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'内码','',240,120,350,0,'-1',7,24,0,0,0,0,'',8193,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000000,1,'内码','內碼','ISN','FID','FID','t_YXSet','',0,1,0,1,1,1,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'内码','PRIMARY',240,120,350,0,'-1',8,24,0,0,0,0,'',8193,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000000,1,'同步表单名称','下拉清單','Drop-down List','FComboBox','FTableName','t_YXSetEntry','',2,1,2047,0,1,1,8,'',0,0,'VALUELIST{1=同步外购入库单,2=同步采购发票,3=同步付款单,4=同步销售出库单,5=同步销售发票,6=同步收款单,7=同步生产领料单,8=同步产品入库单,9=同步其他入库单,10=同步其他出库单,11=同步记账凭证}','','','','','',1,'','',231,500,255,255,'','','',1,'','',3240,1200,315,4275,'5',29,24,0,0,0,0,'',24631,'',9,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000000,1,'指定审核人员','指定审核人员','Drop-down List1','FComboBox1','FChecker','t_YXSetEntry','',2,1,2047,0,1,1,8,'',0,9999,'SQL{ SELECT FUserID,FName  FROM t_user WHERE  1=1}','FUserID','t_user','t_user1','FName','',1,'','',231,500,255,255,'','','',1,'','',8010,1170,330,3195,'5',30,24,0,0,0,0,'',24631,'',9,'','',0,2,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000000,2,'内码','內碼','ISN','FID2','FID','t_YXSetEntry','',0,1,0,1,1,1,3,'',0,0,'','','','','','',1,'','',56,500,255,4,'','','',1,'内码','PARENTID',240,120,350,0,'-1',-1,24,0,0,0,0,'',8193,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000000,2,'名称','名稱','Name','FParentName','FName','t_YXSetEntry','',4,1,0,1,1,0,1,'',0,0,'','','','','','',1,'','',167,500,255,255,'','','',1,'名称','',4435,840,350,2200,'-1',-1,24,0,0,0,0,'',8193,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

INSERT INTO ICClassTableInfo(FClassTypeID,FPage,FCaption_CHS,FCaption_CHT,FCaption_EN,FKey,FFieldName,FTableName,FTableNameAs,FListIndex,FListClassName,FVisible,FEnable,FNeedSave,FMustInput,FCtlType,FProperty,FLookUpType,FLookUpClassID,FLookUpList,FSRCFieldName,FSRCTableName,FSRCTableNameAs,FDSPFieldName,FFNDFieldName,FValueLocation,FFilter,FFilterGroup,FValueType,FDspColType,FEditlen,FValuePrecision,FSaveRule,FDefValue,FAction,FUserDefine,FNote,FKeyWord,FLeft,FTop,FHeight,FWidth,FCondition,FTabIndex,FLock,FSum,FPrec,FScale,FLayer,FLoadAction,FUnControl,FFont,FSourceType,FSubKey,FParentKey,FConditionExt,FFrameBorder,FFrameBorderColor,FLabelWidth,FLabelColor,FTextColor,FIsF7,FContainer,FStyle) 
VALUES (200000000,2,'代码','代碼','Code','FParentNumber','FNumber','t_YXSetEntry','',2,1,0,1,1,0,1,'',0,0,'','','','','','',1,'','',167,500,255,255,'','','',1,'代码','',3655,300,350,2200,'-1',-1,24,0,0,0,0,'',8193,'',0,'','',0,0,0,0,0,0,0,'',0) 
GO

/****** Object:Data   单据模板通用控件描述：ICClassCtl    Script Date: 2013-09-06 ******/

Delete ICClassCtl WHERE FClassTypeID=200000000
GO
/****** Object:Data   单据多布局列表：ICClassLayout    Script Date: 2013-09-06 ******/

--Delete ICClassLayout WHERE FClassTypeID = 200000000
GO
/****** Object:Data   单据多布局明细：ICClassTableInfoLayout    Script Date: 2013-09-06 ******/

--Delete ICClassTableInfoLayout WHERE FClassTypeID = 200000000
GO
/****** Object:Data   单据多布局通用控件明细：ICClassCtlLayout    Script Date: 2013-09-06 ******/

--Delete ICClassCtlLayout WHERE FClassTypeID = 200000000
GO
/****** Object:Data   单据多布局的Page明细：ICClassBillEntryLayout    Script Date: 2013-09-06 ******/

--Delete ICClassBillEntryLayout WHERE FClassTypeID = 200000000
GO
/****** Object:Data   单据模板单据布局控件描述：ICClassEntryEditorLayout    Script Date: 2013-09-06 ******/

--Delete ICClassEntryEditorLayout WHERE FClassTypeID = 200000000 and FLayoutID = 0
GO
/****** Object:Data   序时簿综合查询设置主关系表：icCLassUnionQuery    Script Date: 2013-09-06 ******/

--DELETE icCLassUnionQuery WHERE FSourClassTypeID=200000000
GO
/****** Object:Data   序时簿综合查询设置配置表：icCLassUnionQueryEntry    Script Date: 2013-09-06 ******/

--DELETE icCLassUnionQueryEntry WHERE FSourClassTypeID=200000000
GO
/****** Object:Data   单据权限类弄表：t_ObjectAccessType    Script Date: 2013-09-06 ******/

----Delete t_ObjectAccessType WHERE FObjectType=4100 And FObjectID =200000000
--GO
--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000000,1,2097152,1048576,'查看','查看','查看','View','查看','View') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000000,2,131072,3145728,'新增','新增','新增','New','新增','New') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000000,3,65536,3145728,'删除','删除','刪除','Delete','刪除','Delete') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000000,4,4194304,3145728,'修改','修改','修改','Edit','修改','Edit') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000000,5,64,3145728,'禁用','禁用','禁用','Disable','禁用','Disable') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000000,6,16,3145728,'引出内部数据','引出内部数据','引出內部資料','Export Internal Data','引出內部資料','Export Internal Data') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000000,7,16384,0,'导出单据模板','导出单据模板','導出單據模板','Export Doc Template','導出單據模板','Export Doc Template') 
--GO

--INSERT INTO t_ObjectAccessType(FObjectType,FObjectID,FIndex,FAccessMask,FAccessUse,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
--VALUES (4100,200000000,8,32768,3145728,'打印','打印','列印','Print','列印','Print') 
--GO

/****** Object:Data   单据权限对象表：t_ObjectType    Script Date: 2013-09-06 ******/

Delete t_ObjectType WHERE FObjectType=4100 And FObjectID =200000000
GO
INSERT INTO t_ObjectType(FObjectType,FObjectID,FName,FDescription,FName_cht,FName_en,FDescription_cht,FDescription_en) 
VALUES (4100,200000000,'同步数据配置表','','基礎資料200000000','Master Data200000000',NULL,NULL) 
GO

/****** Object:Data   单据权限表：t_ObjectAccess    Script Date: 2013-09-06 ******/

Delete t_ObjectAccess WHERE FObjectType=4100 And FObjectID =200000000
GO
INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2101,4100,200000000,0) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2101,4100,200000000,1) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000000,0) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000000,1) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000000,2) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000000,3) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000000,4) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000000,5) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000000,6) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000000,7) 
GO

INSERT INTO t_ObjectAccess(FGroupID,FObjectType,FObjectID,FIndex) 
VALUES (2102,4100,200000000,8) 
GO

/****** Object:Data   选单关联：ICClassLink    Script Date: 2013-09-06 ******/

Delete ICClassLink WHERE FDestClassTypeID = 200000000 OR FSourClassTypeID =  200000000
GO
/****** Object:Data   选单关联明细：ICClassLinkEntry    Script Date: 2013-09-06 ******/

Delete ICClassLinkEntry WHERE FDestClassTypeID=200000000 OR FSourClassTypeID =  200000000
GO
/****** Object:Data   选单钩稽明细：ICClassLinkCommit    Script Date: 2013-09-06 ******/

 DELETE ICClassLinkCommit WHERE FDstClsTypID = 200000000 OR FSrcClsTypID =  200000000
GO
/****** Object:Data   选单流程基本信息：ICClassWorkFlow    Script Date: 2013-09-06 ******/


GO
DECLARE @MaxID AS INT

SELECT @MaxID = ISNUll(Max(FID),10000) FROM ICClassWorkFlow


UPDATE ICMaxNum SET FMaxNum = @MaxID + 1 WHERE FTableName = 'ICClassWorkFlow'
GO


/****** Object:Data   选单流程关联单据：ICClassWorkFlowBill    Script Date: 2013-09-06 ******/

DELETE ICClassWorkFlowBill WHERE FClassTypeID = 200000000
GO
DELETE ICClassWorkFlowBill WHERE FID < 0 AND FEntryID NOT IN ( SELECT MAX(FEntryID)  FROM ICClassWorkFlowBill WHERE FID < 0 GROUP BY FClassTypeID HAVING COUNT(FClassTypeID) >= 1 ) 
DELETE ICClassWorkFlowBill WHERE FID=( SELECT MAX(FID) FROM ICClassWorkFlow )  and FClassTypeID in (SELECT FClassTypeID from ICCLASSWORKFLOWBILL where FID<0)
 UPDATE ICClassWorkFlowBill SET FID =( SELECT MAX(FID) FROM ICClassWorkFlow ) WHERE FID < 0 
 DELETE ICClassWorkFlowBill WHERE FID < 0 
/****** Object:Data   选单流程关联关系：ICClassWorkFlowJoin    Script Date: 2013-09-06 ******/

 DELETE ICClassWorkFlowJoin WHERE FDestClassTypeID = 200000000 OR FSourClassTypeID = 200000000
GO
 UPDATE ICClassWorkFlowJoin SET FID =( SELECT MAX(FID) FROM ICClassWorkFlow ) WHERE FID < 0 
 DELETE ICClassWorkFlowJoin WHERE FID < 0 
/****** Object:Data   网络控制模板数据：ICClassMutex    Script Date: 2013-09-06 ******/

Delete ICClassMutex WHERE FClassTypeID=200000000
GO
/****** Object:Data   网络控制互斥表明细数据：t_Mutex    Script Date: 2013-09-06 ******/

DELETE t_Mutex 
WHERE FFuncId IN
(Select FFuncID from icClassMutex where FClassTypeID=200000000)
OR FForbidden IN
(Select FFuncID from icClassMutex where FClassTypeID=200000000)

GO
/****** Object:Data   网络控制操作定义明细：t_SysFunction    Script Date: 2013-09-06 ******/

DELETE t_SysFunction 
WHERE FFuncId IN
(Select FFuncID from icClassMutex where FClassTypeID=200000000)

GO
/****** Object:Data   打印控制模板数据：ICPrintMaxCount    Script Date: 2013-09-06 ******/

Delete ICPrintMaxCount WHERE FID =200000000
GO
/****** Object:Data   多级审核配置模板数据：ICClassMCFlowInfo    Script Date: 2013-09-06 ******/

DELETE ICClassMCFlowInfo WHERE FID = 200000000
GO
/****** Object:Data   多级审核的工作流任务（各审核级次）模板数据：ICClassMCTasks    Script Date: 2013-09-06 ******/

DELETE ICClassMCTasks WHERE FID = 200000000
GO
/****** Object:Data   多级审核的流程流转和规则模板数据：ICClassMCRule    Script Date: 2013-09-06 ******/

DELETE ICClassMCRule WHERE FID = 200000000
GO
/****** Object:Data   单据操作明细模板数据：ICClassBillAction    Script Date: 2013-09-06 ******/

DELETE ICClassBillAction WHERE FClassTypeID = 200000000
GO
DECLARE @MaxID AS INT

SELECT @MaxID = ISNUll(Max(FID),10000) FROM ICClassBillAction

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 1,200000000,'mnuEditCopy','复制','複製','Copy','复制','複製','Copy',39,131072,0,7,1,0,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 2,200000000,'mnuEditDel','删除','刪除','Delete','删除','刪除','Delete',4096,65536,0,7,1,1,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 3,200000000,'mnuEditDelGroup','删除组','刪除組','Delete Group ','删除组','刪除組','Delete Group ',4096,65536,0,7,1,1,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 4,200000000,'mnuEditModify','修改','修改','Edit','修改','修改','Edit',4160,4194304,0,7,1,0,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 5,200000000,'mnuEditUnuse','禁用','禁用','Disabled','禁用','禁用','Disabled',4096,64,0,7,1,1,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 6,200000000,'mnuEditUse','反禁用','反禁用','Enable','反禁用','反禁用','Enable',4096,64,0,7,1,1,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 7,200000000,'mnuExportData','引出内部数据','引出內部資料','Export Internal Data','引出内部数据','引出內部資料','Export Internal Data',5056,16,0,7,1,0,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 8,200000000,'mnuFileExportBillTpl','导出单据模板','導出單據模板','Export Doc Template','导出单据模板','導出單據模板','Export Doc Template',0,16384,0,7,1,1,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 9,200000000,'mnuFileImportBill','导入单据数据','導入單據資料','Import Doc Data','导入单据数据','導入單據資料','Import Doc Data',0,16384,0,7,1,1,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 10,200000000,'mnuFileNewGroup','新增组','新增組','New Group','新增组','新增組','New Group',4096,131072,0,7,1,0,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 11,200000000,'mnuFileNewItem','新增项目','新增項目','New Item','新增项目','新增項目','New Item',4096,131072,0,7,1,0,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 12,200000000,'mnuFilePrint','打印','列印','Print','打印','列印','Print',5095,32768,0,7,1,0,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 13,200000000,'mnuFileSave','保存','保存','Save','保存','保存','Save',6,0,0,7,0,1,1,0,0,1,0) 

INSERT INTO ICClassBillAction(FID,FClassTypeID,FCode,FName_CHS,FName_CHT,FName_EN,FDescriptions_CHS,FDescriptions_CHT,FDescriptions_EN,FEnvironment,FRightMask,FRightUseMask,FRightGroupMask,FRightControl,FAddLog,FIsPredefine,FIsFirst,FShortCut,FListActionCirculation,FOperationType) 
VALUES ( @MaxID + 14,200000000,'mnuStockQuery','库存查询','庫存查詢','Query Inventory','库存查询','庫存查詢','Query Inventory',0,0,0,7,0,1,1,0,0,1,0) 


UPDATE ICMaxNum SET FMaxNum = @MaxID + 15 WHERE FTableName = 'ICClassBillAction'
GO


/****** Object:Data   单据操作日志模板数据：t_LogFunction    Script Date: 2013-09-06 ******/

DELETE t_LogFunction WHERE FFunctionID LIKE 'BOS200000000%'
GO
INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000000_mnuEditDel','销售管理系统-同步数据配置表',23,'銷售管理系統-基礎資料200000000','Sales Module-Master Data200000000') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000000_mnuEditDelGroup','销售管理系统-同步数据配置表',23,'銷售管理系統-基礎資料200000000','Sales Module-Master Data200000000') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000000_mnuEditUnuse','销售管理系统-同步数据配置表',23,'銷售管理系統-基礎資料200000000','Sales Module-Master Data200000000') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000000_mnuEditUse','销售管理系统-同步数据配置表',23,'銷售管理系統-基礎資料200000000','Sales Module-Master Data200000000') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000000_mnuFileExportBillTpl','销售管理系统-同步数据配置表',23,'銷售管理系統-基礎資料200000000','Sales Module-Master Data200000000') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000000_mnuFileImportBill','销售管理系统-同步数据配置表',23,'銷售管理系統-基礎資料200000000','Sales Module-Master Data200000000') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000000_mnuFileSave','销售管理系统-同步数据配置表',23,'銷售管理系統-基礎資料200000000','Sales Module-Master Data200000000') 
GO

INSERT INTO t_LogFunction(FFunctionID,FFunctionName,FSubSysID,FFunctionName_Cht,FFunctionName_EN) 
VALUES ('BOS200000000_mnuStockQuery','销售管理系统-同步数据配置表',23,'銷售管理系統-基礎資料200000000','Sales Module-Master Data200000000') 
GO

/****** Object:Data   单据操作位置模板数据：ICClassActionPosition    Script Date: 2013-09-06 ******/

DELETE ICClassActionPosition WHERE FClassTypeID = 200000000
GO
/****** Object:Data   单据扩展服务模板数据：ICClassActionList    Script Date: 2013-09-06 ******/

DELETE ICClassActionList WHERE FClassTypeID = 200000000
GO
INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000000,6,'FName',0,4096,'FAction','FParentName','',1,'Update By Function UpdateOldFiledAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000000,6,'FNumber',0,4096,'FAction','FParentNumber','',1,'Update By Function UpdateOldFiledAction') 
GO

INSERT INTO ICClassActionList(FClassTypeID,FClassActionID,FObject,FDefineType,FSourceType,FSourceField,FAction,FExpression,FOrder,FDescription) 
VALUES (200000000,12,'FNumber',0,4096,'FSaveRule','FNumber','',1,'Update By Function UpdateOldFiledAction') 
GO



/**End  新单据模板数据脚本，名称 同步数据配置表    Script Date: 2013-09-06 **/
