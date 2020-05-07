--测试参考数据
	--dbo.t_Organization	;
	--dbo.t_Item;
	--T_ICItem;
	--T_ICItemCore;
	--T_ICItemBase;
	--T_ICItemMaterial;
	--t_item;

	--创建临时表
	CREATE TABLE #tab_uorg
		(
		  FItemID INT ,         --物料
		  OldNumber VARCHAR(255) ,
		  FNumber VARCHAR(255) ,
		  FFullNumber VARCHAR(255) ,
		  FShortNumber VARCHAR(255) ,
		  FParentNumber VARCHAR(255) ,
		  FParentID INT ,
		  FLevel INT ,
		  FFullName VARCHAR(255)
		);


    --插入临时数据
	INSERT  INTO #tab_uorg( OldNumber ,  FNumber , FParentNumber , FShortNumber)	VALUES  ( '01.01.8888' ,'01.01.7777' , '01.01' , '7777');
	INSERT  INTO #tab_uorg( OldNumber ,  FNumber , FParentNumber , FShortNumber)	VALUES  ( '01.42.0012.03' ,'01.42.0012.08' , '01.42.0012' , '08');
	

	
	SELECT * FROM #tab_uorg


	UPDATE  #tab_uorg 	SET     FItemID = t.FItemID ,			FFullNumber = a.FNumber ,			
	FParentID = t2.FItemID ,			FLevel = t2.FLevel + 1 ,			
	FFullName = t2.FFullName + '_' + t.fname
	FROM    #tab_uorg a
			INNER JOIN dbo.t_Item t ON t.FNumber = a.OldNumber
									   AND t.FItemClassID = 1
			INNER JOIN dbo.t_Item t2 ON t2.FNumber = a.FParentNumber
										AND t2.FItemClassID = 1;
	--删除无ID记录
   DELETE  #tab_uorg 	WHERE   FItemID IS NULL;
   

 
 
 	--修改t_item表
	UPDATE  dbo.t_Item	SET     fnumber = u.FNumber ,	FFullNumber = u.FFullNumber ,	
	FShortNumber = u.FShortNumber ,	
	FParentID = u.FParentID ,			
	FLevel = u.FLevel ,			FFullName = u.FFullName
	FROM    dbo.t_Item t
			INNER JOIN #tab_uorg u ON u.FItemID = t.FItemID
	WHERE   t.FItemClassID = 1;






	--修改ORGANIZATION表
	UPDATE  t_Organization
	SET     FNumber = t.fnumber ,
			FParentID = t.FParentID ,
			FShortNumber = t.FShortNumber
	FROM    t_Organization k
			INNER JOIN dbo.t_Item t ON t.FItemID = k.FItemID
			INNER JOIN #tab_uorg u ON u.FItemID=t.FItemID
	WHERE   t.FItemClassID = 1 AND t.fnumber NOT LIKE 'x%'



	--删除临时表
    DROP TABLE #tab_uorg  ;
