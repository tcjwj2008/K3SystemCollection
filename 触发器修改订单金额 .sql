SELECT  y.* into seorderentry20190802_backup
FROM    seorder t
inner  JOIN seorderentry y ON t.finterid = y.finterid
WHERE FAmount<> ROUND(FAuxQty*FAuxTaxPrice/(100+FCESS)*100,2) AND   t.FDate>'2019-07-29' 


--ÐÞ¸Ä/*
update  y   set 
FAmount= ROUND(FAuxQty*FAuxTaxPrice/(100+FCESS)*100,2)

FROM    seorder t
inner  JOIN seorderentry y ON t.finterid = y.finterid
WHERE FAmount<> ROUND(FAuxQty*FAuxTaxPrice/(100+FCESS)*100,2) AND   t.FDate='2019-7-31'


update  y   set 
FAmount= ROUND(FAuxQty*FAuxTaxPrice/(100+FCESS)*100,2)

FROM    seorder t
inner  JOIN seorderentry y ON t.finterid = y.finterid
WHERE FAmount<> ROUND(FAuxQty*FAuxTaxPrice/(100+FCESS)*100,2) AND   t.FDate='2019-7-30'  

update  y   set 
FAmount= ROUND(FAuxQty*FAuxTaxPrice/(100+FCESS)*100,2)

FROM    seorder t
inner  JOIN seorderentry y ON t.finterid = y.finterid
WHERE FAmount<> ROUND(FAuxQty*FAuxTaxPrice/(100+FCESS)*100,2) AND   t.FDate='2019-8-01' 


update  y   set 
FAmount= ROUND(FAuxQty*FAuxTaxPrice/(100+FCESS)*100,2)

FROM    seorder t
inner  JOIN seorderentry y ON t.finterid = y.finterid
WHERE FAmount<> ROUND(FAuxQty*FAuxTaxPrice/(100+FCESS)*100,2) AND   t.FDate='2019-8-02' 