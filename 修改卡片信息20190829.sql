

SELECT  *                         --2行
FROM    t_FACard
WHERE   FAssetNumber = '90' AND FAssetAcctID=1 
--1、更改固定资产卡片上的名称
UPDATE  t_FACard
SET     FAssetName = '三星数码相机（两台）NEW'
WHERE   FAssetNumber = '90';  

--2\更改（查询，有数据的话，需更改）  --无
SELECT  *
FROM    t_FaTransAssetApp
WHERE   FAssetNumber = '90';  
UPDATE  t_FaTransAssetApp
SET     FAssetName =  '三星数码相机（两台）NEW'
WHERE   FAssetNumber = '90';  
--3\多次变动基本表
SELECT  *                          --2行
FROM    t_FACardMulAlter
WHERE FAssetNumber = '90'; 
UPDATE  t_FACardMulAlter
SET     FAssetName =  '三星数码相机（两台）NEW'
WHERE   FAssetNumber = '90';  
--4\更改每期状况表
SELECT  *                          --90行
FROM    t_FABalCard
WHERE   FAssetNumber = '90';  
UPDATE  t_FABalCard
SET     FAssetName =  '三星数码相机（两台）NEW'
WHERE   FAssetNumber = '90';  


/*
SELECT * FROM dbo.t_TableDescription WHERE FSubSystemID=3
FTableName	FDescription
t_FABalance                                                                     	余额表                                                                                                                                                                                                                                                            
t_FASchmOption                                                                  	选项设置表                                                                                                                                                                                                                                                          
t_FAExpenseDetailMulAlter                                                       	折旧费用分配明细多次变动表                                                                                                                                                                                                                                                  
t_FaTmpCard                                                                     	卡片暂存表                                                                                                                                                                                                                                                          
t_FAAlterMode                                                                   	变动方式表                                                                                                                                                                                                                                                          
t_FAGroup                                                                       	资产类别表                                                                                                                                                                                                                                                          
t_FAStatus                                                                      	使用状态表                                                                                                                                                                                                                                                          
t_FALocation                                                                    	存放地点表                                                                                                                                                                                                                                                          
t_FAEconomyUse                                                                  	经济用途表                                                                                                                                                                                                                                                          
t_FABalCard                                                                     	卡片每期状况表                                                                                                                                                                                                                                                        
t_FABalDevice                                                                   	附属设备每期状况表                                                                                                                                                                                                                                                      
t_FABalOrgFor                                                                   	原值原币每期状况表                                                                                                                                                                                                                                                      
t_FABalDept                                                                     	部门每期分配情况表                                                                                                                                                                                                                                                      
t_FABalExpense                                                                  	折旧费用每期分配情况表                                                                                                                                                                                                                                                    
t_FASchmSort                                                                    	索引条件表                                                                                                                                                                                                                                                          
t_FASchmSumItems                                                                	汇总项目表                                                                                                                                                                                                                                                          
t_FACardMulAlter                                                                	多次变动基本表                                                                                                                                                                                                                                                        
t_FADeptMulAlter                                                                	部门多次变动表                                                                                                                                                                                                                                                        
t_FADeviceMulAlter                                                              	附属设备多次变动表                                                                                                                                                                                                                                                      
t_FAExpenseMulAlter                                                             	折旧费用分配多次变动表                                                                                                                                                                                                                                                    
t_FAOrgForMulAlter                                                              	原值原币多次变动表                                                                                                                                                                                                                                                      
t_FADeviceBill                                                                  	检修单据表                                                                                                                                                                                                                                                          
t_FADeviceItem                                                                  	单据自定义项目表                                                                                                                                                                                                                                                       
t_FADeviceItemDefine                                                            	单据项目定义表                                                                                                                                                                                                                                                        
t_FACardItemDefine                                                              	卡片项目定义表                                                                                                                                                                                                                                                        
t_FACard                                                                        	卡片表                                                                                                                                                                                                                                                            
t_FABalCardItem                                                                 	卡片自定义项目每期状况表                                                                                                                                                                                                                                                   
t_FADeviceGroupItem                                                             	检修单中类别项目对照表                                                                                                                                                                                                                                                    
t_FABalPurchase                                                                 	修购基金余额表                                                                                                                                                                                                                                                        
t_FAPurchase                                                                    	修购基金表                                                                                                                                                                                                                                                          
t_FAPurchaseDetailMulAlter                                                      	修购基金多次变动明细表                                                                                                                                                                                                                                                    
t_FAPurchaseMulAlter                                                            	修购基金多次变动表                                                                                                                                                                                                                                                      
t_FAImage                                                                       	自定义项目图片表                                                                                                                                                                                                                                                       
t_FAGroupItem                                                                   	类别项目对照表                                                                                                                                                                                                                                                        
t_FADeprMethod                                                                  	折旧方法定义表                                                                                                                                                                                                                                                        
t_FaDeprFormulaItems                                                            	折旧公式项目表                                                                                                                                                                                                                                                        
t_FAUserDeprRate                                                                	每期自定义折旧率表                                                                                                                                                                                                                                                      
t_FAAlter                                                                       	变动基本表                                                                                                                                                                                                                                                          
t_FADevice                                                                      	附属设备表                                                                                                                                                                                                                                                          
t_FAOrgFor                                                                      	原值原币表                                                                                                                                                                                                                                                          
t_FADept                                                                        	部门分配表                                                                                                                                                                                                                                                          
t_FAExpense                                                                     	折旧费用分配表                                                                                                                                                                                                                                                        
t_FACardItem                                                                    	卡片自定义项目表                                                                                                                                                                                                                                                       
t_FAClear                                                                       	报废清理表                                                                                                                                                                                                                                                          
t_FAVoucher                                                                     	凭证对照表                                                                                                                                                                                                                                                          
t_FARptSheetSchemeItems                                                         	固定资产清单显示方案表                                                                                                                                                                                                                                                    
t_FASchemes                                                                     	显示方案表                                                                                                                                                                                                                                                          
t_FASchmFilter                                                                  	过滤条件表   */                                                                                                                                                                                                                                                       

SELECT * FROM dbo.t_TableDescription WHERE FSubSystemID=3
SELECT  *
FROM    t_FABalance   
GO
dbo.SpK3_2Str @sName = 't_FABalance' -- varchar(50)
                                                                  
SELECT  *
FROM    t_FASchmOption                                                                  
SELECT  *
FROM    t_FAExpenseDetailMulAlter                                                       
SELECT  *
FROM    t_FaTmpCard                                                                     
SELECT  *
FROM    t_FAAlterMode                                                                   
SELECT  *
FROM    t_FAGroup                                                                       
SELECT  *
FROM    t_FAStatus                                                                      
SELECT  *
FROM    t_FALocation                                                                    
SELECT  *
FROM    t_FAEconomyUse                                                                  
SELECT  *
FROM    t_FABalCard                                                                     
SELECT  *
FROM    t_FABalDevice                                                                   
SELECT  *
FROM    t_FABalOrgFor                                                                   
SELECT  *
FROM    t_FABalDept                                                                     
SELECT  *
FROM    t_FABalExpense                                                                  
SELECT  *
FROM    t_FASchmSort                                                                    
SELECT  *
FROM    t_FASchmSumItems                                                                
SELECT  *
FROM    t_FACardMulAlter                                                                
SELECT  *
FROM    t_FADeptMulAlter                                                                
SELECT  *
FROM    t_FADeviceMulAlter                                                              
SELECT  *
FROM    t_FAExpenseMulAlter                                                             
SELECT  *
FROM    t_FAOrgForMulAlter                                                              
SELECT  *
FROM    t_FADeviceBill                                                                  
SELECT  *
FROM    t_FADeviceItem                                                                  
SELECT  *
FROM    t_FADeviceItemDefine                                                            
SELECT  *
FROM    t_FACardItemDefine                                                              
SELECT  *
FROM    t_FACard                                                                        
SELECT  *
FROM    t_FABalCardItem                                                                 
SELECT  *
FROM    t_FADeviceGroupItem                                                             
SELECT  *
FROM    t_FABalPurchase                                                                 
SELECT  *
FROM    t_FAPurchase                                                                    
SELECT  *
FROM    t_FAPurchaseDetailMulAlter                                                      
SELECT  *
FROM    t_FAPurchaseMulAlter                                                            
SELECT  *
FROM    t_FAImage                                                                       
SELECT  *
FROM    t_FAGroupItem                                                                   
SELECT  *
FROM    t_FADeprMethod                                                                  
SELECT  *
FROM    t_FaDeprFormulaItems                                                            
SELECT  *
FROM    t_FAUserDeprRate                                                                
SELECT  *
FROM    t_FAAlter                                                                       
SELECT  *
FROM    t_FADevice                                                                      
SELECT  *
FROM    t_FAOrgFor                                                                      
SELECT  *
FROM    t_FADept                                                                        
SELECT  *
FROM    t_FAExpense                                                                     
SELECT  *
FROM    t_FACardItem                                                                    
SELECT  *
FROM    t_FAClear                                                                       
SELECT  *
FROM    t_FAVoucher                                                                     
SELECT  *
FROM    t_FARptSheetSchemeItems                                                         
SELECT  *
FROM    t_FASchemes                                                                     
SELECT  *
FROM    t_FASchmFilter                                                                  