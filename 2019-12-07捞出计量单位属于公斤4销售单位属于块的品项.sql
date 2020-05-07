SELECT  a.*
FROM    t_ICItem a
        INNER JOIN dbo.t_MeasureUnit c ON a.FUnitID = c.FMeasureUnitID
                                          AND c.FName = '¹«½ï4'
        INNER JOIN t_MeasureUnit b ON a.FSaleUnitID = b.FMeasureUnitID
                                      AND b.FName = '¿é';



SELECT  a.*
FROM    t_ICItem a
        INNER JOIN dbo.t_MeasureUnit c ON a.FUnitID = c.FMeasureUnitID
                                          AND c.FName = '¹«½ï2'
        INNER JOIN t_MeasureUnit b ON a.FSaleUnitID = b.FMeasureUnitID
                                      AND b.FName = '´ü31';

