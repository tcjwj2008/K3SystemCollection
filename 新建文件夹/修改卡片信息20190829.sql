

SELECT  *                         --2��
FROM    t_FACard
WHERE   FAssetNumber = '90' AND FAssetAcctID=1 
--1�����Ĺ̶��ʲ���Ƭ�ϵ�����
UPDATE  t_FACard
SET     FAssetName = '���������������̨��NEW'
WHERE   FAssetNumber = '90';  

--2\���ģ���ѯ�������ݵĻ�������ģ�  --��
SELECT  *
FROM    t_FaTransAssetApp
WHERE   FAssetNumber = '90';  
UPDATE  t_FaTransAssetApp
SET     FAssetName =  '���������������̨��NEW'
WHERE   FAssetNumber = '90';  
--3\��α䶯������
SELECT  *                          --2��
FROM    t_FACardMulAlter
WHERE FAssetNumber = '90'; 
UPDATE  t_FACardMulAlter
SET     FAssetName =  '���������������̨��NEW'
WHERE   FAssetNumber = '90';  
--4\����ÿ��״����
SELECT  *                          --90��
FROM    t_FABalCard
WHERE   FAssetNumber = '90';  
UPDATE  t_FABalCard
SET     FAssetName =  '���������������̨��NEW'
WHERE   FAssetNumber = '90';  


/*
SELECT * FROM dbo.t_TableDescription WHERE FSubSystemID=3
FTableName	FDescription
t_FABalance                                                                     	����                                                                                                                                                                                                                                                            
t_FASchmOption                                                                  	ѡ�����ñ�                                                                                                                                                                                                                                                          
t_FAExpenseDetailMulAlter                                                       	�۾ɷ��÷�����ϸ��α䶯��                                                                                                                                                                                                                                                  
t_FaTmpCard                                                                     	��Ƭ�ݴ��                                                                                                                                                                                                                                                          
t_FAAlterMode                                                                   	�䶯��ʽ��                                                                                                                                                                                                                                                          
t_FAGroup                                                                       	�ʲ�����                                                                                                                                                                                                                                                          
t_FAStatus                                                                      	ʹ��״̬��                                                                                                                                                                                                                                                          
t_FALocation                                                                    	��ŵص��                                                                                                                                                                                                                                                          
t_FAEconomyUse                                                                  	������;��                                                                                                                                                                                                                                                          
t_FABalCard                                                                     	��Ƭÿ��״����                                                                                                                                                                                                                                                        
t_FABalDevice                                                                   	�����豸ÿ��״����                                                                                                                                                                                                                                                      
t_FABalOrgFor                                                                   	ԭֵԭ��ÿ��״����                                                                                                                                                                                                                                                      
t_FABalDept                                                                     	����ÿ�ڷ��������                                                                                                                                                                                                                                                      
t_FABalExpense                                                                  	�۾ɷ���ÿ�ڷ��������                                                                                                                                                                                                                                                    
t_FASchmSort                                                                    	����������                                                                                                                                                                                                                                                          
t_FASchmSumItems                                                                	������Ŀ��                                                                                                                                                                                                                                                          
t_FACardMulAlter                                                                	��α䶯������                                                                                                                                                                                                                                                        
t_FADeptMulAlter                                                                	���Ŷ�α䶯��                                                                                                                                                                                                                                                        
t_FADeviceMulAlter                                                              	�����豸��α䶯��                                                                                                                                                                                                                                                      
t_FAExpenseMulAlter                                                             	�۾ɷ��÷����α䶯��                                                                                                                                                                                                                                                    
t_FAOrgForMulAlter                                                              	ԭֵԭ�Ҷ�α䶯��                                                                                                                                                                                                                                                      
t_FADeviceBill                                                                  	���޵��ݱ�                                                                                                                                                                                                                                                          
t_FADeviceItem                                                                  	�����Զ�����Ŀ��                                                                                                                                                                                                                                                       
t_FADeviceItemDefine                                                            	������Ŀ�����                                                                                                                                                                                                                                                        
t_FACardItemDefine                                                              	��Ƭ��Ŀ�����                                                                                                                                                                                                                                                        
t_FACard                                                                        	��Ƭ��                                                                                                                                                                                                                                                            
t_FABalCardItem                                                                 	��Ƭ�Զ�����Ŀÿ��״����                                                                                                                                                                                                                                                   
t_FADeviceGroupItem                                                             	���޵��������Ŀ���ձ�                                                                                                                                                                                                                                                    
t_FABalPurchase                                                                 	�޹���������                                                                                                                                                                                                                                                        
t_FAPurchase                                                                    	�޹������                                                                                                                                                                                                                                                          
t_FAPurchaseDetailMulAlter                                                      	�޹������α䶯��ϸ��                                                                                                                                                                                                                                                    
t_FAPurchaseMulAlter                                                            	�޹������α䶯��                                                                                                                                                                                                                                                      
t_FAImage                                                                       	�Զ�����ĿͼƬ��                                                                                                                                                                                                                                                       
t_FAGroupItem                                                                   	�����Ŀ���ձ�                                                                                                                                                                                                                                                        
t_FADeprMethod                                                                  	�۾ɷ��������                                                                                                                                                                                                                                                        
t_FaDeprFormulaItems                                                            	�۾ɹ�ʽ��Ŀ��                                                                                                                                                                                                                                                        
t_FAUserDeprRate                                                                	ÿ���Զ����۾��ʱ�                                                                                                                                                                                                                                                      
t_FAAlter                                                                       	�䶯������                                                                                                                                                                                                                                                          
t_FADevice                                                                      	�����豸��                                                                                                                                                                                                                                                          
t_FAOrgFor                                                                      	ԭֵԭ�ұ�                                                                                                                                                                                                                                                          
t_FADept                                                                        	���ŷ����                                                                                                                                                                                                                                                          
t_FAExpense                                                                     	�۾ɷ��÷����                                                                                                                                                                                                                                                        
t_FACardItem                                                                    	��Ƭ�Զ�����Ŀ��                                                                                                                                                                                                                                                       
t_FAClear                                                                       	���������                                                                                                                                                                                                                                                          
t_FAVoucher                                                                     	ƾ֤���ձ�                                                                                                                                                                                                                                                          
t_FARptSheetSchemeItems                                                         	�̶��ʲ��嵥��ʾ������                                                                                                                                                                                                                                                    
t_FASchemes                                                                     	��ʾ������                                                                                                                                                                                                                                                          
t_FASchmFilter                                                                  	����������   */                                                                                                                                                                                                                                                       

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