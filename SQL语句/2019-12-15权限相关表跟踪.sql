/****权限相关表跟踪****/
select * from t_Group where FUserID = 16394 and FGroupID = 1
select * from t_UserType;
select * from t_useraddinfo
select * from t_AccessControl;
select * from T_OfflineInfo;
select * from t_GroupAccessType
select * from t_GroupAccess
Select * From t_GroupAccessType a left join t_GroupAccess b on b.FUserID=20 And a.FGroupID = b.FGroupID order by a.FGroupID,a.FMask
select * from t_group;
select * from t_user;
go
exec SpK3_2Str  't_user'
exec spk3_2tab  't_user'

go


