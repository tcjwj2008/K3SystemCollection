
  SELECT * FROM [yinxiang].dbo.t_product WHERE code LIKE '8.%' ORDER BY code


    SELECT *
  FROM [yinxiang].dbo.t_product
WHERE 
code LIKE '8.12%'


  SELECT *
  FROM [yinxiang].dbo.t_product
WHERE 
code IN (
'8.991.880',
'8.992.770',
'8.992.880',
'8.991.107')



8.992.770	�ඹ����  ---8.12.108
8.992.880	�ƽ�Ƥ��10����  ---8.12.109
8.991.880	ը����  ---8.12.110


UPDATE  yinxiang.dbo.t_product SET code='8.12.110'
WHERE code ='8.991.880'

UPDATE  yinxiang.dbo.t_product SET code='8.12.109'
WHERE code ='8.992.880'

UPDATE  yinxiang.dbo.t_product SET code='8.12.108'
WHERE code ='8.992.770'

UPDATE  yinxiang.dbo.t_product SET code='8.12.107'
WHERE code ='8.991.107'