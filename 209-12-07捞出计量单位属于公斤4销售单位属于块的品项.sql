SELECT  a.*
FROM    t_ICItem a
        INNER JOIN dbo.t_MeasureUnit c ON a.FUnitID = c.FMeasureUnitID
                                          AND c.FName = '����4'
        INNER JOIN t_MeasureUnit b ON a.FSaleUnitID = b.FMeasureUnitID
                                      AND b.FName = '��';



SELECT  a.*
FROM    t_ICItem a
        INNER JOIN dbo.t_MeasureUnit c ON a.FUnitID = c.FMeasureUnitID
                                          AND c.FName = '����2'
        INNER JOIN t_MeasureUnit b ON a.FSaleUnitID = b.FMeasureUnitID
                                      AND b.FName = '��31';

