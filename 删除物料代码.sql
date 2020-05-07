DELETE FROM CON12.yrtzdata.dbo.TZ_ZD_product WHERE productcode in ('7.1.01.04.11940','7.1.01.04.11950')
DELETE  FROM CON12.yrtzdata.dbo.TZ_ZD_Pproduct WHERE productcode in ('7.1.01.04.11940','7.1.01.04.11950')
DELETE  from CON12.yrtzdata.dbo.TZ_ZD_productsort WHERE productcode in ('7.1.01.04.11940','7.1.01.04.11950')


--INSERT INTO CON12.yrtzdata.dbo.TZ_ZD_Pproduct (CID,pid,productcode,levelcode,CGlevelcode,deviation,measuretype,saletype,      
--  saleunit,showcode,discountflag,measurevalue,minprice,shownumber,appshowname,appshowflag,mnemoniccode,      
--  shelflife,shelflifeunit,sweight,sunit,halfflag,sflag,judgecaption,fpflag,onepackcount,ischeck,      
--  packweight,platequantity,reducerate,reduceweight,lowerdeviation,weightinflag,printfilename)       
--VALUES ('11',821,'7.1.02.01.00750','','',-1, 0 ,0, '公斤' ,      
--  '',0,0,0,0,'冻猪去骨去皮后腿肉（进口）',1,'',      
--  0,'日',10, ISNULL('件b','头') , 1 ,  0 ,
--  '冻猪去骨去皮后腿肉（进口）',0,0,      
--  0,0,0,0,0,-1, 0 ,'')   
  
SELECT SUBSTRING('冻猪去骨去皮后腿肉（进口）',1,10)   
SELECT * from CON12.yrtzdata.dbo.TZ_ZD_Pproduct