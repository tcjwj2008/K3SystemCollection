/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP 1000 [id]
      ,[createtime]
      ,[opener]
      ,[company]
      ,[area]
      ,[kinds]
      ,[storeno]
      ,[store]
      ,[mcode]
      ,[linkman]
      ,[phone]
      ,[account]
      ,[password]
      ,[address]
      ,[mobilephone]
      ,[iscredit]
      ,[legal]
      ,[divison]
      ,[salesperson]
      ,[bestservice]
      ,[orderamount]
      ,[totalcharge]
      ,[lettercredit]
      ,[balance]
      ,[trannum]
      ,[remark]
      ,[mailaddress]
      ,[openid]
  FROM [yinxiang].[dbo].[t_store]
  
  WHERE mcode='12049'
  
  
  UPDATE [yinxiang].[dbo].[t_store] SET account=12049
  
  WHERE mcode='12049'