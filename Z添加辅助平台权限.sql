
                                             
                                             select * from k3_2Operator
                                             
                                             
                                             delete from dbo.SYAssignRight where userid=83
                                             
                                             
                                             insert into dbo.SYAssignRight
                                             (UserID, Moduleid, RightTag, IsRight )
                                             
                                             select '83',Moduleid, RightTag, IsRight
                                             from dbo.SYAssignRight where 
                                             userid=72