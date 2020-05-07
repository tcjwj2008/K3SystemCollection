--开启guest用户“授予连接”
USE TEST
GO
grant connect to guest;  
 
--禁用guest用户“拒绝连接”
USE TEST
GO
deny connect to guest;