SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
ALTER   PROC [dbo].[sp_k3_2checkApp_qiu] ( @FNAME VARCHAR(50) )
AS
    DECLARE @msg VARCHAR(500);--��Ϣ      
    DECLARE @isok INT;       
    DECLARE @k3userid INT;       
 
--�ж��Ƿ����û�      
    SELECT  @k3userid = ISNULL(FUserID, 0)
    FROM    t_User
    WHERE   FName = @FNAME;      
    IF ISNULL(@k3userid, 0) = 0
        BEGIN      
            SET @msg = '����K3ϵͳ��û��ע���û���';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
      
        END;       
--�жϿ�ֵ      
    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND Fbillno IS NULL )
        BEGIN      
            SET @msg = '�б��Ϊ�յĵ��ݣ�';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;       
    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND Fdate IS NULL )
        BEGIN      
            SET @msg = '������Ϊ�յĵ��ݣ�';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;       
    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND Fpax IS NULL )
        BEGIN      
            SET @msg = '��������Ϊ�յĵ��ݣ�';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;

    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FNumberC IS NULL )
        BEGIN      
            SET @msg = '�пͻ�����Ϊ�յĵ��ݣ�';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;  

    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FNumberC NOT IN ( SELECT    FNumber
                                              FROM      dbo.t_Organization ) )
        BEGIN      
            SET @msg = '�пͻ����벻����K3�ͻ���ĵ��ݣ�';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;         

      
      
    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FWeight IS NULL )
        BEGIN      
            SET @msg = '������Ϊ�յĵ��ݣ�';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;   
    
     
      

    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FNumberM IS NULL )
        BEGIN      
            SET @msg = '�����ϴ���Ϊ�յĵ��ݣ�';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END; 

    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FNumberM NOT IN ( SELECT    FNumber
                                              FROM      dbo.t_ICItem ) )
        BEGIN      
            SET @msg = '�����ϴ��벻����K3���ϱ�ĵ��ݣ�';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END; 

       
      
    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FSTOCK IS NULL )
        BEGIN      
            SET @msg = '�вֿ�Ϊ�յĵ��ݣ�';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;  

    IF EXISTS ( SELECT  1
                FROM    k3_2inSalelibrary
                WHERE   FNAME = @FNAME
                        AND FSTOCK NOT IN ( '���װ��Ʒ', '�ָ��Ʒ��', '�����Ʒ��' ) )
        BEGIN      
            SET @msg = '�вֿⳬ����Χ�ĵ��ݣ�';      
            SET @isok = -1;      
            DELETE  k3_2inSalelibrary
            WHERE   FNAME = @FNAME;      
            GOTO ENDD;      
        END;  


        
      
--�ж��ڼ�      
    DECLARE @y INT;       
    DECLARE @m INT;       
      
    DECLARE @CurrentYear INT;       
    DECLARE @CurrentPeriod INT;       
    SELECT  @CurrentYear = CONVERT(INT, FValue)
    FROM    t_SystemProfile
    WHERE   FCategory = 'IC'
            AND FKey = 'CurrentYear';      
    SELECT  @CurrentPeriod = CONVERT(INT, FValue)
    FROM    t_SystemProfile
    WHERE   FCategory = 'IC'
            AND FKey = 'CurrentPeriod';      
      
    SELECT  @y = DATEPART(YEAR, MIN(Fdate)) ,
            @m = DATEPART(MONTH, MIN(Fdate))
    FROM    k3_2inSalelibrary
    WHERE   FNAME = @FNAME;      
      
--IF (@CurrentPeriod>@y) OR (@CurrentPeriod> @m)      
--BEGIN      
-- SET @msg='�����������С�ڵ�ǰ�ڼ�����ݣ�'      
-- SET @isok=-1      
--  DELETE k3_2inSalelibrary WHERE FNAME=@FNAME      
--  GOTO ENDD      
--END       
      
    SET @msg = '���������';      
    SET @isok = 1;      
      
      
    ENDD:
    SELECT  @msg AS msg ,
            @isok AS isok;       
       
--д��洢���� 