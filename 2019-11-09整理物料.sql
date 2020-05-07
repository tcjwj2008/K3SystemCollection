            SELECT  *
            FROM    dbo.t_Item
            WHERE   FItemID > 12182  OR FNumber ='8.12.110'
            SELECT  *
            FROM    dbo.t_ICItemBase
            WHERE   FItemID IN ( 12184, 12182 );
            SELECT  *
            FROM    dbo.t_ICItemMaterial
            WHERE   FItemID IN ( 12184, 12182 );
            SELECT  *
            FROM    dbo.t_ICItemPlan
            WHERE   FItemID IN ( 12184, 12182 );
            SELECT  *
            FROM    dbo.t_ICItemDesign
            WHERE   FItemID IN ( 12184, 12182 );
            SELECT  *
            FROM    dbo.t_ICItemStandard
            WHERE   FItemID IN ( 12184, 12182 );
            SELECT  *
            FROM    dbo.t_ICItemQuality
            WHERE   FItemID IN ( 12184, 12182 );
            SELECT  *
            FROM    dbo.t_ICItemCustom
            WHERE   FItemID IN ( 12184, 12182 );
            SELECT  *
            FROM    dbo.T_BASE_ICItemEntrance
            WHERE   FItemID IN ( 12184, 12182 );