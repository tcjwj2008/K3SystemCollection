select    
    request_session_id spid,   
    OBJECT_NAME(resource_associated_entity_id) tableName    
from    
    sys.dm_tran_locks   
where    
    resource_type='OBJECT' 
    
    exec master.dbo.sp_who_lock