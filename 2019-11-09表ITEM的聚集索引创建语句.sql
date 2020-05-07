DELETE  FROM t_Gr_ItemControl
WHERE   FItemID = 12191
        AND FItemClassID = 2001;
INSERT  INTO t_Gr_ItemControl
        ( FFrameWorkID ,
          FItemClassID ,
          FItemID ,
          FCanUse ,
          FCanAdd ,
          FCanModi ,
          FCanDel
        )
        SELECT  FFrameWorkID ,
                FItemClassID ,
                12191 ,
                FCanUse ,
                FCanAdd ,
                FCanModi ,
                FCanDel
        FROM    t_Gr_ItemControl
        WHERE   FItemID = 12173
                AND FItemClassID = 2001;


				GO
                SELECT * FROM t_Gr_ItemControl
				dbo.SpK3_2tab @sName = 't_Gr_ItemControl' -- varchar(50)
				