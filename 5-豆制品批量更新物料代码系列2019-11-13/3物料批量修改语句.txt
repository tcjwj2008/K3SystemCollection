--1创建临时表

--补充修复旧数：

SELECT * FROM t_item WHERE fnumber='1.00'

--影响两行
UPDATE t_item SET FDetail=0 WHERE fnumber='1.00'

CREATE TABLE #tab_uorg
    (
      FItemID INT ,
      OldNumber VARCHAR(255) ,
      FNumber VARCHAR(255) ,
      FFullNumber VARCHAR(255) ,
      FShortNumber VARCHAR(255) ,
      FParentNumber VARCHAR(255) ,
      FParentID INT ,
      FLevel INT ,
      FFullName VARCHAR(255),
	  FParentID2001 INT
    );


--2插入临时表数据

--393行
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.010','8.01.010','8.01','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.020','8.01.020','8.01','020');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.040','8.01.030','8.01','030');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.040','8.01.040','8.01','040');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.030','8.01.050','8.01','050');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.076','8.01.060','8.01','060');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.075','8.01.900','8.01','900');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.031','8.01.901','8.01','901');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.013','8.02.010','8.02','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.011','8.02.011','8.02','011');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.012','8.02.012','8.02','012');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.022','8.02.020','8.02','020');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.021','8.02.021','8.02','021');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.077','8.02.030','8.02','030');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.030','8.02.040','8.02','040');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.031','8.02.041','8.02','041');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.050','8.02.900','8.02','900');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.083','8.02.901','8.02','901');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.053','8.03.010','8.03','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.051','8.03.011','8.03','011');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.050','8.03.012','8.03','012');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.024','8.03.020','8.03','020');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.022','8.03.021','8.03','021');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.020','8.03.022','8.03','022');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.330','8.03.023','8.03','023');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.073','8.03.030','8.03','030');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.071','8.03.031','8.03','031');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.070','8.03.032','8.03','032');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.018','8.03.040','8.03','040');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.014','8.03.041','8.03','041');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.016','8.03.042','8.03','042');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.012','8.03.043','8.03','043');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.019','8.03.050','8.03','050');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.015','8.03.051','8.03','051');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.017','8.03.052','8.03','052');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.013','8.03.053','8.03','053');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.082','8.03.060','8.03','060');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.081','8.03.061','8.03','061');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.080','8.03.062','8.03','062');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.062','8.03.070','8.03','070');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.061','8.03.071','8.03','071');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.060','8.03.072','8.03','072');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.110','8.03.080','8.03','080');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.111','8.03.081','8.03','081');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.090','8.03.082','8.03','082');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.160','8.03.090','8.03','090');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.142','8.03.100','8.03','100');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.143','8.03.101','8.03','101');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.141','8.03.102','8.03','102');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.140','8.03.103','8.03','103');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.150','8.03.110','8.03','110');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.010','8.03.900','8.03','900');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.011','8.03.901','8.03','901');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.021','8.03.902','8.03','902');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.023','8.03.903','8.03','903');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.052','8.03.904','8.03','904');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.072','8.03.905','8.03','905');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.191','8.03.906','8.03','906');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.332','8.03.907','8.03','907');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X10.100','8.03.908','8.03','908');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X10.110','8.03.909','8.03','909');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.032','8.04.010','8.04','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.052','8.04.020','8.04','020');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.014','8.04.030','8.04','030');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.012','8.04.031','8.04','031');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.132','8.04.032','8.04','032');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.013','8.04.033','8.04','033');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.011','8.04.034','8.04','034');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.133','8.04.040','8.04','040');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.022','8.04.041','8.04','041');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.020','8.04.042','8.04','042');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.137','8.04.050','8.04','050');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.062','8.04.060','8.04','060');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.010','8.04.900','8.04','900');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.083','8.04.901','8.04','901');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.082','8.04.902','8.04','902');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.080','8.04.903','8.04','903');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.116','8.04.904','8.04','904');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.190','8.04.905','8.04','905');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.331','8.04.906','8.04','906');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.015','8.04.907','8.04','907');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.021','8.04.909','8.04','909');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.030','8.04.910','8.04','910');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.040','8.04.911','8.04','911');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.042','8.04.912','8.04','912');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.050','8.04.913','8.04','913');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.060','8.04.914','8.04','914');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.061','8.04.915','8.04','915');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.070','8.04.916','8.04','916');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.021','8.05.010','8.05','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.010','8.05.020','8.05','020');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.120','8.05.021','8.05','021');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.011','8.05.022','8.05','022');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.013','8.05.023','8.05','023');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.030','8.05.030','8.05','030');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.122','8.05.031','8.05','031');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.031','8.05.032','8.05','032');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.050','8.05.040','8.05','040');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.060','8.05.041','8.05','041');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.051','8.05.042','8.05','042');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.101','8.05.050','8.05','050');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.137','8.05.051','8.05','051');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.081','8.05.060','8.05','060');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.082','8.05.061','8.05','061');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.090','8.05.070','8.05','070');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.091','8.05.080','8.05','080');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.138','8.05.081','8.05','081');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X02.120','8.05.082','8.05','082');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.100','8.05.090','8.05','090');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.140','8.05.100','8.05','100');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.040','8.05.110','8.05','110');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.121','8.05.111','8.05','111');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.123','8.05.120','8.05','120');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.012','8.05.900','8.05','900');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.020','8.05.901','8.05','901');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.041','8.05.902','8.05','902');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.070','8.05.903','8.05','903');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.080','8.05.904','8.05','904');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.092','8.05.905','8.05','905');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.102','8.05.906','8.05','906');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.124','8.05.907','8.05','907');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.125','8.05.908','8.05','908');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.126','8.05.909','8.05','909');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.127','8.05.910','8.05','910');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.128','8.05.911','8.05','911');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.129','8.05.912','8.05','912');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.130','8.05.913','8.05','913');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.135','8.05.914','8.05','914');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.139','8.05.915','8.05','915');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X09.010','8.06.010','8.06','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X09.030','8.06.020','8.06','020');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X09.020','8.06.030','8.06','030');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X09.050','8.06.900','8.06','900');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X09.060','8.06.901','8.06','901');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X09.070','8.06.902','8.06','902');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X10.010','8.06.903','8.06','903');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X10.020','8.06.904','8.06','904');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X10.030','8.06.905','8.06','905');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X10.040','8.06.906','8.06','906');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X10.050','8.06.907','8.06','907');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X10.060','8.06.908','8.06','908');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X10.070','8.06.909','8.06','909');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X10.080','8.06.910','8.06','910');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X10.090','8.06.911','8.06','911');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X11.010','8.09.010','8.09','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X11.011','8.09.011','8.09','011');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X11.050','8.09.030','8.09','030');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X11.052','8.09.031','8.09','031');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X11.051','8.09.032','8.09','032');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X11.021','8.20.010','8.20','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X11.031','8.20.020','8.20','020');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X11.030','8.20.021','8.20','021');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.011','8.20.030','8.20','030');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.090','8.20.031','8.20','031');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.021','8.20.040','8.20','040');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.091','8.20.041','8.20','041');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.030','8.20.050','8.20','050');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.092','8.20.051','8.20','051');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.050','8.20.060','8.20','060');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.093','8.20.061','8.20','061');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.060','8.20.070','8.20','070');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.094','8.20.071','8.20','071');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.041','8.20.080','8.20','080');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.095','8.20.081','8.20','081');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.089','8.20.082','8.20','082');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X11.020','8.20.900','8.20','900');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X11.061','8.20.901','8.20','901');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X11.062','8.20.902','8.20','902');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.010','8.20.903','8.20','903');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.020','8.20.904','8.20','904');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.031','8.20.905','8.20','905');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.040','8.20.906','8.20','906');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.051','8.20.907','8.20','907');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.061','8.20.908','8.20','908');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.096','8.21.010','8.21','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.097','8.21.011','8.21','011');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.080','8.21.012','8.21','012');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.098','8.21.013','8.21','013');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.070','8.21.020','8.21','020');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.099','8.21.021','8.21','021');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X98.071','8.21.900','8.21','900');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.112','8.30.010','8.30','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.090','8.30.011','8.30','011');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.128','8.30.020','8.30','020');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.119','8.30.021','8.30','021');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.120','8.30.022','8.30','022');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.131','8.30.030','8.30','030');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.130','8.30.040','8.30','040');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.136','8.30.050','8.30','050');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.061','8.30.051','8.30','051');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.060','8.30.052','8.30','052');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.084','8.30.060','8.30','060');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.078','8.30.061','8.30','061');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.085','8.30.070','8.30','070');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.086','8.30.071','8.30','071');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.088','8.30.080','8.30','080');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.089','8.30.090','8.30','090');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.121','8.30.100','8.30','100');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.126','8.30.101','8.30','101');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.133','8.30.110','8.30','110');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.136','8.30.120','8.30','120');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.134','8.30.130','8.30','130');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.131','8.30.140','8.30','140');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.132','8.30.141','8.30','141');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.062','8.30.900','8.30','900');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.079','8.30.901','8.30','901');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.080','8.30.902','8.30','902');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.081','8.30.903','8.30','903');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.082','8.30.904','8.30','904');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X01.087','8.30.905','8.30','905');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.114','8.30.906','8.30','906');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.117','8.30.907','8.30','907');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.118','8.30.908','8.30','908');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.122','8.30.909','8.30','909');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.124','8.30.910','8.30','910');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.125','8.30.911','8.30','911');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.127','8.30.912','8.30','912');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.129','8.30.913','8.30','913');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.134','8.30.914','8.30','914');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X03.135','8.30.915','8.30','915');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.014','8.30.916','8.30','916');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X04.141','8.30.917','8.30','917');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.090','8.40.010','8.40','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.109','8.40.011','8.40','011');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.087','8.40.012','8.40','012');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.096','8.40.013','8.40','013');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.081','8.40.020','8.40','020');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.092','8.40.021','8.40','021');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.107','8.40.030','8.40','030');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.108','8.40.031','8.40','031');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.011','8.40.040','8.40','040');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.093','8.40.041','8.40','041');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.079','8.40.042','8.40','042');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.012','8.40.043','8.40','043');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.010','8.40.044','8.40','044');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.013','8.40.045','8.40','045');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.014','8.40.046','8.40','046');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.031','8.40.050','8.40','050');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.032','8.40.051','8.40','051');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.041','8.40.060','8.40','060');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.042','8.40.061','8.40','061');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.050','8.40.070','8.40','070');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.106','8.40.080','8.40','080');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.101','8.40.090','8.40','090');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.102','8.40.091','8.40','091');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.063','8.40.092','8.40','092');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.064','8.40.093','8.40','093');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.066','8.40.094','8.40','094');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.067','8.40.095','8.40','095');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.065','8.40.100','8.40','100');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.068','8.40.111','8.40','111');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.103','8.40.112','8.40','112');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.072','8.40.120','8.40','120');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.104','8.40.121','8.40','121');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.105','8.40.122','8.40','122');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.084','8.40.130','8.40','130');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.086','8.40.140','8.40','140');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.111','8.40.150','8.40','150');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.080','8.40.900','8.40','900');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.088','8.40.901','8.40','901');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.089','8.40.902','8.40','902');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.091','8.40.903','8.40','903');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.094','8.40.904','8.40','904');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.095','8.40.905','8.40','905');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.097','8.40.906','8.40','906');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.110','8.40.907','8.40','907');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.071','8.50.010','8.50','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.100','8.50.020','8.50','020');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.070','8.50.030','8.50','030');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.085','8.50.040','8.50','040');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.098','8.50.050','8.50','050');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.099','8.50.060','8.50','060');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.060','8.50.070','8.50','070');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X12.062','8.50.080','8.50','080');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.115','8.99.010','8.99','010');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.021','8.99.011','8.99','011');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.109','8.99.020','8.99','020');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.020','8.99.030','8.99','030');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.108','8.99.040','8.99','040');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.112','8.99.050','8.99','050');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.114','8.99.060','8.99','060');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.023','8.99.070','8.99','070');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.111','8.99.080','8.99','080');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.091','8.99.081','8.99','081');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.022','8.99.090','8.99','090');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.089','8.99.091','8.99','091');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.131','8.99.100','8.99','100');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.132','8.99.110','8.99','110');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.027','8.99.120','8.99','120');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.026','8.99.130','8.99','130');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.138','8.99.140','8.99','140');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.066','8.99.150','8.99','150');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.011','8.99.160','8.99','160');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.010','8.99.161','8.99','161');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.015','8.99.170','8.99','170');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.016','8.99.171','8.99','171');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.017','8.99.180','8.99','180');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.018','8.99.181','8.99','181');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.044','8.99.190','8.99','190');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.152','8.99.191','8.99','191');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.043','8.99.200','8.99','200');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.151','8.99.201','8.99','201');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.045','8.99.210','8.99','210');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.153','8.99.211','8.99','211');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.047','8.99.220','8.99','220');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.046','8.99.230','8.99','230');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.038','8.99.240','8.99','240');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.142','8.99.250','8.99','250');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.141','8.99.260','8.99','260');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.067','8.99.270','8.99','270');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X10.120','8.99.900','8.99','900');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.024','8.99.901','8.99','901');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.025','8.99.902','8.99','902');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.028','8.99.903','8.99','903');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.029','8.99.904','8.99','904');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.030','8.99.905','8.99','905');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.031','8.99.906','8.99','906');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.032','8.99.907','8.99','907');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.033','8.99.908','8.99','908');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.037','8.99.909','8.99','909');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.039','8.99.910','8.99','910');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.048','8.99.911','8.99','911');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.049','8.99.912','8.99','912');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.053','8.99.913','8.99','913');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.054','8.99.914','8.99','914');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.055','8.99.915','8.99','915');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.056','8.99.916','8.99','916');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.057','8.99.917','8.99','917');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.060','8.99.918','8.99','918');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.063','8.99.919','8.99','919');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.072','8.99.920','8.99','920');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.073','8.99.921','8.99','921');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.074','8.99.922','8.99','922');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.076','8.99.923','8.99','923');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.077','8.99.924','8.99','924');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.078','8.99.925','8.99','925');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.079','8.99.926','8.99','926');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.080','8.99.927','8.99','927');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.081','8.99.928','8.99','928');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.083','8.99.929','8.99','929');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.084','8.99.930','8.99','930');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.085','8.99.931','8.99','931');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.087','8.99.932','8.99','932');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.088','8.99.933','8.99','933');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.090','8.99.934','8.99','934');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.092','8.99.935','8.99','935');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.093','8.99.936','8.99','936');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.094','8.99.937','8.99','937');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.095','8.99.938','8.99','938');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.096','8.99.939','8.99','939');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.097','8.99.940','8.99','940');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.098','8.99.941','8.99','941');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.099','8.99.942','8.99','942');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.102','8.99.943','8.99','943');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.103','8.99.944','8.99','944');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.104','8.99.945','8.99','945');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.105','8.99.946','8.99','946');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.106','8.99.947','8.99','947');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.107','8.99.948','8.99','948');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.110','8.99.949','8.99','949');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.113','8.99.950','8.99','950');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.116','8.99.951','8.99','951');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.117','8.99.952','8.99','952');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.118','8.99.953','8.99','953');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.119','8.99.954','8.99','954');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.120','8.99.955','8.99','955');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.121','8.99.956','8.99','956');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.122','8.99.957','8.99','957');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.123','8.99.958','8.99','958');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.124','8.99.959','8.99','959');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.125','8.99.960','8.99','960');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.126','8.99.961','8.99','961');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.127','8.99.962','8.99','962');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.128','8.99.963','8.99','963');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.129','8.99.964','8.99','964');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.130','8.99.965','8.99','965');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.133','8.99.966','8.99','966');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.134','8.99.967','8.99','967');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.135','8.99.968','8.99','968');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.136','8.99.969','8.99','969');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.137','8.99.970','8.99','970');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.139','8.99.971','8.99','971');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.140','8.99.972','8.99','972');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.143','8.99.973','8.99','973');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.144','8.99.974','8.99','974');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.145','8.99.975','8.99','975');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.146','8.99.976','8.99','976');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.147','8.99.977','8.99','977');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.148','8.99.978','8.99','978');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.149','8.99.979','8.99','979');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.150','8.99.980','8.99','980');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.154','8.99.981','8.99','981');
iNSERT  INTO #tab_uorg ( OldNumber ,  FNumber ,FParentNumber ,FShortNumber) values('8.X99.155','8.99.982','8.99','982');

--SELECT  * FROM #tab_uorg WHERE FNumber='8.03.070'
--SELECT  fnumber FROM #tab_uorg GROUP BY FNumber HAVING COUNT(*)>1
--SELECT * FROM #TAB_UORG WHERE OLDNUMBER LIKE '%XX%'
--UPDATE #tab_uorg SET fnumber='8.30.070' WHERE  OldNumber='8.X01.085'
--
--SELECT  * FROM #tab_uorg 
-- select * from t_item where fnumber='8.X01.010'
--  select * from t_item where fnumber='8.X01'
--3修改临时表值


--查询要修改的信息(临时表与现有物料表中类别为4的进行关联，与物料代码FNUMBER作为关联列）
--SELECT DISTINCT FParentNumber FROM #tab_uorg
--393行
SELECT a.FItemID ,t.FItemID ,
        a.FFullNumber, a.FNumber 
FROM    #tab_uorg a
        INNER JOIN dbo.t_Item t ON t.FNumber = a.OldNumber
                                   AND t.FItemClassID = 4

--393行
SELECT  a. FParentID , t2.FItemID ,
        a.FLevel , t2.FLevel + 1 ,
        a. FFullName  
 
FROM    #tab_uorg a
              INNER JOIN dbo.t_Item t2 ON t2.FNumber = a.FParentNumber
                                    AND t2.FItemClassID = 4;

--393行
SELECT a.FItemID ,t.FItemID ,
        a.FFullNumber, a.FNumber ,
       a. FParentID , t2.FItemID ,
        a.FLevel , t2.FLevel + 1 ,
       a. FFullName , t2.FFullName + '_' + t.FName
FROM    #tab_uorg a
        INNER JOIN dbo.t_Item t ON t.FNumber = a.OldNumber
                                   AND t.FItemClassID = 4
        inner JOIN dbo.t_Item t2 ON t2.FNumber = a.FParentNumber
                                    AND t2.FItemClassID = 4;
--393行
UPDATE  #tab_uorg
SET     FItemID = t.FItemID ,
        FFullNumber = a.FNumber ,
        FParentID = t2.FItemID ,
        FLevel = t2.FLevel + 1 ,
        FFullName = t2.FFullName + '_' + t.FName
FROM    #tab_uorg a
        INNER JOIN dbo.t_Item t ON t.FNumber = a.OldNumber
                                   AND t.FItemClassID = 4
        INNER JOIN dbo.t_Item t2 ON t2.FNumber = a.FParentNumber
                                    AND t2.FItemClassID = 4;


--4修改临时表值FParentid2001
--393行
SELECT   a.FParentID2001 , t2.FItemID 
FROM    #tab_uorg a
        INNER JOIN dbo.t_Item t2 ON t2.FNumber = a.FParentNumber
                                    AND t2.FItemClassID = 2001;
--SELECT   * FROM    #tab_uorg a
--SELECT * FROM t_Item WHERE FNumber='8.12.107'
--SELECT * FROM t_Item WHERE FNumber='8.991'
--SELECT * FROM dbo.t_Item WHERE FNumber='8.12'
--SELECT * FROM dbo.t_Item WHERE FNumber='8'
--5修改项目

--393行
UPDATE  #tab_uorg
SET   
        FParentID2001 = t2.FItemID 
FROM    #tab_uorg a
        INNER JOIN dbo.t_Item t2 ON t2.FNumber = a.FParentNumber
                                    AND t2.FItemClassID = 2001;


--SELECT   * FROM    #tab_uorg a
--SELECT * FROM t_Item WHERE FNumber='8.12.107'
--SELECT * FROM t_Item WHERE FNumber='8.991'
--SELECT * FROM dbo.t_Item WHERE FNumber='8.12'
--SELECT * FROM dbo.t_Item WHERE FNumber='8'
--5修改项目
--4修改t_item项目
SELECT  t.FNumber , u.FNumber ,
        t.FFullNumber , u.FFullNumber ,
        t.FShortNumber , u.FShortNumber ,
        t.FParentID, u.FParentID ,
        t.FLevel , u.FLevel ,
        t.FFullName , u.FFullName 
FROM    dbo.t_Item t
        INNER JOIN #tab_uorg u ON u.FItemID = t.FItemID
WHERE   t.FItemClassID = 4;

--update #tab_uorg SET FItemID=12170
--select * from 
--SELECT   * FROM    #tab_uorg a
--SELECT * FROM t_Item WHERE FNumber='8.991.999'
--SELECT * FROM t_Item WHERE FNumber='8.991'
--SELECT * FROM dbo.t_Item WHERE FNumber='8.12'
--SELECT * FROM dbo.t_Item WHERE FNumber='8'
--5修改项目

--393行
UPDATE  dbo.t_Item
SET     FNumber = u.FNumber ,
        FFullNumber = u.FFullNumber ,
        FShortNumber = u.FShortNumber ,
        FParentID = u.FParentID ,
        FLevel = u.FLevel ,
        FFullName = u.FFullName
FROM    dbo.t_Item t
        INNER JOIN #tab_uorg u ON u.FItemID = t.FItemID
WHERE   t.FItemClassID = 4;

--SELECT   * FROM    #tab_uorg a
--SELECT * FROM t_Item WHERE FNumber='8.03.070'
--SELECT * FROM t_Item WHERE FNumber='8.991'
--SELECT * FROM dbo.t_Item WHERE FNumber='8.12'
--SELECT * FROM dbo.t_Item WHERE FNumber='8'
--5修改项目
--select * from #tab_uorg where FNumber='8.03.070'
--SELECT DISTINCT FParentNumber FROM #tab_uorg



--SELECT * FROM    dbo.t_Item t
--        INNER JOIN #tab_uorg u ON u.fNumber = t.FNumber 
--WHERE   t.FItemClassID = 2001;
--378行
DECLARE @rCount int;
SELECT @rCount=COUNT(*) FROM    dbo.t_Item t
        INNER JOIN #tab_uorg u ON u.OldNumber = t.FNumber 
WHERE   t.FItemClassID = 2001;
PRINT @rCount;
IF @rCount>0 
BEGIN
UPDATE  dbo.t_Item
SET     FNumber = u.FNumber ,
        FFullNumber = u.FFullNumber ,
        FShortNumber = u.FShortNumber ,
        FParentID = u.FParentID2001 ,
        FLevel = u.FLevel ,
        FFullName = u.FFullName
FROM    dbo.t_Item t
        INNER JOIN #tab_uorg u ON u.OldNumber = t.FNumber 
WHERE   t.FItemClassID = 2001;
end

--SELECT * FROM cbCostObj
--SELECT * FROM #tab_uorg;
--SELECT * FROM T_ITEM;


--(393 行受影响)
UPDATE  cbCostObj
SET     FNumber = t.FNumber ,
        FParentID = t.FParentID2001 ,
        FShortNumber = t.FShortNumber
FROM    #tab_uorg t
WHERE    cbCostObj.FStdProductID = t.FItemID
        

SELECT cbCostObj.fname,t.fname
FROM    dbo.t_Item t,cbCostObj
WHERE   t.FItemClassID = 4
        AND cbCostObj.FStdProductID = t.FItemID
        AND EXISTS ( SELECT *
                     FROM   #tab_uorg
                     WHERE  FItemID = t.FItemID );

--0行受影响
UPDATE  cbCostObj
SET     FName = t.fname
   
FROM    dbo.t_Item t
WHERE   t.FItemClassID = 4
        AND cbCostObj.FStdProductID = t.FItemID
        AND EXISTS ( SELECT *
                     FROM   #tab_uorg
                     WHERE  FItemID = t.FItemID )
					 and cbcostobj.fname<>t.fname

--(393 行受影响)

UPDATE  t_ICItemCore
SET     FNumber = t.FNumber ,
        FParentID = t.FParentID ,
        FShortNumber = t.FShortNumber
FROM    dbo.t_Item t
WHERE   t.FItemClassID = 4
        AND t_ICItemCore.FItemID = t.FItemID
        AND EXISTS ( SELECT *
                     FROM   #tab_uorg
                     WHERE  FItemID = t.FItemID );


--(393 行受影响)
UPDATE  t_ICItemBase
SET     FFullName = t.FFullName
FROM    dbo.t_Item t
WHERE   t.FItemClassID = 4
        AND t_ICItemBase.FItemID = t.FItemID
        AND EXISTS ( SELECT *
                     FROM   #tab_uorg
                     WHERE  FItemID = t.FItemID );




SELECT  A.*
FROM    ICPrcPlyEntry A
        LEFT JOIN t_Item B ( NOLOCK ) ON A.FRelatedID = B.FItemID
        LEFT JOIN t_ICItem C ( NOLOCK ) ON A.FItemID = C.FItemID
        LEFT JOIN t_MeasureUnit D ( NOLOCK ) ON A.FUnitID = D.FItemID
        LEFT JOIN ICPrcPlyEntrySpec E ( NOLOCK ) ON A.FInterID = E.FInterID
                                                    AND A.FItemID = E.FItemID
                                                    AND A.FRelatedID = E.FRelatedID
        LEFT JOIN ICPrcPly F ( NOLOCK ) ON A.FInterID = F.FInterID
        INNER JOIN dbo.t_Organization S ON A.FRelatedID = S.FItemID
		INNER JOIN #tab_uorg temp ON A.FItemID=temp.FItemID
WHERE   F.FNumber = '01'
        AND B.FItemClassID = 1
--SELECT *  
UPDATE 	A	 SET A.FNOTE=1 
FROM    ICPrcPlyEntry A
        LEFT JOIN t_Item B ( NOLOCK ) ON A.FRelatedID = B.FItemID
        LEFT JOIN t_ICItem C ( NOLOCK ) ON A.FItemID = C.FItemID
        LEFT JOIN t_MeasureUnit D ( NOLOCK ) ON A.FUnitID = D.FItemID
        LEFT JOIN ICPrcPlyEntrySpec E ( NOLOCK ) ON A.FInterID = E.FInterID
                                                    AND A.FItemID = E.FItemID
                                                    AND A.FRelatedID = E.FRelatedID
        LEFT JOIN ICPrcPly F ( NOLOCK ) ON A.FInterID = F.FInterID
        INNER JOIN dbo.t_Organization S ON A.FRelatedID = S.FItemID
		INNER JOIN #tab_uorg temp ON A.FItemID=temp.FItemID
WHERE   F.FNumber = '01'
        AND B.FItemClassID = 1
		
		

SELECT  *
FROM    ICPrcPlyEntry A
        LEFT JOIN t_SubMessage B ( NOLOCK ) ON A.FRelatedID = B.FInterID
        LEFT JOIN t_ICItem C ( NOLOCK ) ON A.FItemID = C.FItemID
        LEFT JOIN t_MeasureUnit D ( NOLOCK ) ON A.FUnitID = D.FItemID
        LEFT JOIN ICPrcPlyEntrySpec E ( NOLOCK ) ON A.FInterID = E.FInterID
                                                    AND A.FItemID = E.FItemID
                                                    AND A.FRelatedID = E.FRelatedID
        LEFT JOIN ICPrcPly F ( NOLOCK ) ON A.FInterID = F.FInterID
		INNER JOIN #tab_uorg temp ON A.FItemID=temp.FItemID
WHERE   F.FNumber = '02'; 
			
--SELECT *  
UPDATE 	A	 SET A.FNOTE=1
FROM    ICPrcPlyEntry A
        LEFT JOIN t_SubMessage B ( NOLOCK ) ON A.FRelatedID = B.FInterID
        LEFT JOIN t_ICItem C ( NOLOCK ) ON A.FItemID = C.FItemID
        LEFT JOIN t_MeasureUnit D ( NOLOCK ) ON A.FUnitID = D.FItemID
        LEFT JOIN ICPrcPlyEntrySpec E ( NOLOCK ) ON A.FInterID = E.FInterID
                                                    AND A.FItemID = E.FItemID
                                                    AND A.FRelatedID = E.FRelatedID
        LEFT JOIN ICPrcPly F ( NOLOCK ) ON A.FInterID = F.FInterID
		INNER JOIN #tab_uorg temp ON A.FItemID=temp.FItemID
WHERE   F.FNumber = '02'; 

--删除表
--DROP TABLE #tab_uorg;

