SELECT  FTaxRate
FROM    t_ICItemMaterial
WHERE   FItemID = 1586;
SELECT  *
INTO    t_ICItemMaterial20191106
FROM    t_ICItemMaterial;
UPDATE  t_ICItemMaterial
SET     FTaxRate = 13.0000000000
WHERE   1 = 1;