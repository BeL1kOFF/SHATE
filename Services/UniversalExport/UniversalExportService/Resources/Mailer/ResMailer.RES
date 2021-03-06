        ��  ��                    @   T E X T   S Q L I N S E R T E M A I L       0         INSERT INTO [Mails]
           ([ExpID]
           ,[priority]
           ,[AddingTimestamp]
           --,[status]
           --,[ProcessingTimestamp]
           ,[email]
           ,[bcc]
           ,[Subject]
           ,[Body]
           ,[attouch]
           ,[arch])
     VALUES
           (##ExpID##-- int
           ,(Select [Priority] From [Exports] Where ID = ##ExpID##)--(##priority##)--, int,
           ,GetDate()--(##AddingTimestamp##)--, datetime,
           --,(##status##), bit,
           --,(##ProcessingTimestamp##), datetime,
           ,'##email##'--, char(255),
           ,##bcc##--, bit,
           ,'##Subject##'--, nvarchar(max),
           ,'##Body##'--, text,
           ,'##attouch##'--, nvarchar(max),
           ,##arch##--, bit,
		   )�   H   T E X T   S Q L M A R K O L D M E S S A G E S       0         UPDATE MAILS 
SET [status] = 1
WHERE COALESCE(Status, 0) <> 1 AND ID NOT IN (select max(ID) from MAILS 
			where COALESCE(Status, 0) <> 1 AND ProcessingTimestamp IS NULL
			group by ExpID	
			)  =  <   T E X T   S Q L L O A D Q U E U E       0         SELECT * 
FROM MAILS MM
WHERE COALESCE(Status, 0) <> 1 AND ProcessingTimestamp IS NULL AND NOT EXISTS (
	Select ID From MAILS m0 Where m0.ID>mm.ID AND m0.ExpID = mm.ExpID AND m0.email=mm.email	
	)
ORDER BY (CASE WHEN [priority] IS NULL THEN 0 ELSE 1 END) DESC, priority, [status], AddingTimeStamp		


			
			   U  \   T E X T   S Q L U P D A T E S T A T U S C U R R E N T R E C O R D       0         DECLARE @state as BIT
	SET @state = ##STATE##
	
DECLARE @ID as BIGINT
	SET @ID = ##ID##

DECLARE @ExpID as BIGINT
	SET @ExpID = ##ExpID##	
	
DECLARE @Email as char(255)
SET @Email='##e-mail##'	

DECLARE @MAXID AS BIGINT
SET @MAXID = (1-SIGN(@ID))*(SELECT MAX(ID) FROM MAILS WHERE ExpID = @ExpID AND email = @Email)
	
UPDATE 	MAILS
 SET 
 [status] = @state
 ,[ProcessingTimeStamp] = 	CASE @state 
							WHEN 1 THEN COALESCE([ProcessingTimeStamp],GetDate())
							ELSE [ProcessingTimeStamp]
							END
 WHERE ([ProcessingTimeStamp] IS NULL) AND (ID = @ID OR ID = @MAXID)  
    i   L   T E X T   S Q L D E L E T E O L D M E S S A G E S       0         DELETE FROM MAILS
WHERE ID NOT IN ( select max(ID) from MAILS group by ExpID, email, ISNULL(Status, 0) )   �  D   T E X T   S Q L F A U L T R E C O V E R Y       0         DECLARE @FAULTSTAMP AS INT
SET @FAULTSTAMP = ##FAULTSTAMP##

DECLARE @FAULTID AS BIGINT
SET @FAULTID = 
 (
	SELECT MIN(ID) FROM MAILS MM
	WHERE ExpID = @FAULTSTAMP AND [status] IS NULL AND ProcessingTimestamp IS NULL
	AND NOT EXISTS (SELECT * FROM MAILS M0 WHERE M0.ID>MM.ID AND M0.[status] IS NOT NULL AND M0.ProcessingTimestamp IS NOT NULL)
	  
 )

 UPDATE MAILS 
 SET 
	[status] = 1    
 WHERE ID>=@FAULTID 
 