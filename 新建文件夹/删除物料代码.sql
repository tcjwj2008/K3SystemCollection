DELETE FROM CON12.yrtzdata.dbo.TZ_ZD_product WHERE productcode in ('7.1.01.04.11940','7.1.01.04.11950')
DELETE  FROM CON12.yrtzdata.dbo.TZ_ZD_Pproduct WHERE productcode in ('7.1.01.04.11940','7.1.01.04.11950')
DELETE  from CON12.yrtzdata.dbo.TZ_ZD_productsort WHERE productcode in ('7.1.01.04.11940','7.1.01.04.11950')


--INSERT INTO CON12.yrtzdata.dbo.TZ_ZD_Pproduct (CID,pid,productcode,levelcode,CGlevelcode,deviation,measuretype,saletype,      
--  saleunit,showcode,discountflag,measurevalue,minprice,shownumber,appshowname,appshowflag,mnemoniccode,      
--  shelflife,shelflifeunit,sweight,sunit,halfflag,sflag,judgecaption,fpflag,onepackcount,ischeck,      
--  packweight,platequantity,reducerate,reduceweight,lowerdeviation,weightinflag,printfilename)       
--VALUES ('11',821,'7.1.02.01.00750','','',-1, 0 ,0, '����' ,      
--  '',0,0,0,0,'����ȥ��ȥƤ�����⣨���ڣ�',1,'',      
--  0,'��',10, ISNULL('��b','ͷ') , 1 ,  0 ,
--  '����ȥ��ȥƤ�����⣨���ڣ�',0,0,      
--  0,0,0,0,0,-1, 0 ,'')   
  
SELECT SUBSTRING('����ȥ��ȥƤ�����⣨���ڣ�',1,10)   
SELECT * from CON12.yrtzdata.dbo.TZ_ZD_Pproduct