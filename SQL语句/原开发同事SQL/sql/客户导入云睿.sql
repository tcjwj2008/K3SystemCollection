Create PROC yunrui_Organizatio_Insert_csp(
@FNumber varchar(150)
)
as
IF EXISTS(SELECT  * FROM con12.yrtzdata.dbo.TZ_ZD_client WHERE clientcode =@FNumber)
	BEGIN
		RAISERROR('已经存在该产品',16,1)--提交错误信息。
		RETURN--退出过程
	END
 INSERT con12.yrtzdata.dbo.TZ_ZD_client(CID,cardid,clientcode,clientname,birthtime,birthtimetype,pycode,appaccount,apppassword,shortname,mnemoniccode,clientlevel,areacode,                                                                  
         phone,cellphone,address,email,cultivation,cultivation2,bank,bankname,bankaccount,remark,isdelete,recordtime,bankprovince,bankcity,bankaddress)                                                                  
  select '11',FNumber,'R'+FNumber,FName,b.FCreateDate,0,dbo.sys_getpym(a.FName),'',                            
         case ISNULL(f_107,'') when '' then dbo.MD5(right(FNumber,6)) else f_107 end,a.FShortName,'',0,'',                                                           
         ISNULL(a.FPhone,a.FMobilePhone),'',a.FAddress,a.FEmail,'','',a.FBank,a.FBank,a.FAccount,'',0,b.FCreateDate,'','',''                                                                  
    from t_Organization  a ,t_BaseProperty b WHERE a.FItemID=b.FItemID AND  b.FTypeID = 3 AND a.FNumber=@FNumber

	  insert con12.yrtzdata.dbo.TZ_ZD_pclient(CID,clientcode,ispigclient,issupplyclient,isreplaceclient,iscoldsaleclient,ishotsaleclient,                                                                  
         isleaseclient,leasedate,pclientcode,payclientcode,getusercode,saleusercode,isshowprice,saleareacode,                                                                  
         priceareacode,cgareacode,notesend,appsend,remark,recordtime,isdelete,discountflag,parentdiscountflag,qudao,readyorder,userflag,                                
         beihuoflag,sendtype,fdflag,isinvoice,carcode,psperson,pigreducerate,returnbill,groupname,progroupcode,          
         sharearrearsflag,checkoutway,ocode,printunit,xsocode,xsoname,getcname   )                                                                  
  select '11','R'+a.FNumber,0,0,0,1,1,                                                                  
         0,null,(SELECT clientcode  FROM con12.yrtzdata.dbo.tz_zd_client WHERE clientcode ='R'+c.FNumber),'R'+a.FNumber,'',(SELECT TOP 1  usercode FROM CON12.yrtzdata.dbo.TZ_YH_user WHERE username IN 
		 (SELECT  FName FROM dbo.t_Emp WHERE FItemID =a.Femployee)),
		 1,'',                                                                  
         '','',0,0,'',b.FCreateDate,0,1,0,(SELECT TOP 1 QDcode FROM CON12.yrtzdata.dbo.TZ_ZD_qudao WHERE QDname IN
		  (SELECT   FName FROM dbo.t_Department WHERE FItemID =a.Fdepartment)),F_108,0,                                
         1,0,0,0,'','R'+a.FNumber,0,0,'',0,          
         0,0,'','',(SELECT TOP 1 ocode  FROM CON12.yrtzdata.dbo.TZ_YH_oz WHERE oname =
		  (SELECT   FName FROM dbo.t_Department WHERE FItemID =a.Fdepartment)),(SELECT   FName FROM dbo.t_Department WHERE FItemID =a.Fdepartment)
		  ,''                                                                  
    from t_Organization  a ,t_BaseProperty b ,dbo.t_Item c WHERE a.FItemID=b.FItemID AND 
	a.FParentID=c.FItemID AND  b.FTypeID = 3 AND a.FNumber=@FNumber