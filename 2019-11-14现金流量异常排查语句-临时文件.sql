SELECT    
                                         DISTINCT   FCashAccountID 
                                        
                                  FROM      dbo.t_CashFlowBal
                                  WHERE    FCashAccountID IN (

								  SELECT    
                                            FAccountID 
                                           
                                  FROM      dbo.t_VoucherEntry
                                  WHERE     1 = 1
                                          AND FVoucherID = 32394  )


  SELECT    
                                           FAccountID,*  
                                           
                                  FROM      dbo.t_VoucherEntry WHERE FAccountID IN(
SELECT    
                                         DISTINCT   FCashAccountID 
                                        
                                  FROM      dbo.t_CashFlowBal
                                  WHERE   FVoucherID=32394) AND   FVoucherID=32394

							



										  SELECT * FROM dbo.t_Voucher WHERE FVoucherID=32394




										  SELECT * FROM dbo.t_VoucherEntry WHERE FVoucherID=32394