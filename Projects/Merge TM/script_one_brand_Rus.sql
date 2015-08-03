SET NOCOUNT ON;

DECLARE
	@Id_Part INT,
	@Id_Part_New INT

SET @Id_Part = :Id_Part_Old
SET @Id_Part_New = :Id_Part_New

BEGIN TRY
	
    IF (SELECT COUNT(*) FROM partchars p
    	  WHERE p.partid = @Id_Part_new) = 0
    BEGIN
    		
    	UPDATE partchars
    	SET partid = @Id_Part_new
    	WHERE partid = @Id_Part
    		
    END
    	
    IF (SELECT COUNT(*) FROM partsets p
    	  WHERE p.partid = @Id_Part_new) = 0
    BEGIN
    		
    	UPDATE partsets
    	SET partid = @Id_Part_new
    	WHERE partid = @Id_Part
    		
    END
		
		/*
    	* ��������� �������� � ������
    	*/
    	 
    UPDATE [Shate-M RU$Item]
    SET [Part ID] = @Id_Part_new
    WHERE [Part ID] = @Id_Part
		
		UPDATE [Shate-M RU$Item Stock and Price]
    SET [Part ID] = @Id_Part_new
    WHERE [Part ID] = @Id_Part
    	
    /*
    	* �������
    	*/
    	
    UPDATE crosses
    SET partid = @Id_Part_new
    WHERE partid = @Id_Part
    	
    UPDATE crosses
    SET cpartid = @Id_Part_new
    WHERE partid = @Id_Part
    	
    DELETE FROM crosses
    WHERE partid = cpartid AND
    	    partid = @Id_Part_new
    
    IF (SELECT p.textid FROM part p
    	  WHERE p.partid = @Id_Part_new) = 0
    BEGIN
    		
    	UPDATE part
    	SET textid = (SELECT p.textid FROM part p
    		            WHERE p.partid = @Id_Part)
    	WHERE partid = @Id_Part_new
    	
    END

    DELETE FROM partchars
    WHERE partid = @Id_Part
    	
    DELETE FROM partsets
    WHERE partid = @Id_Part
    	
    DELETE FROM part
    WHERE partid = @Id_Part
		
END TRY
BEGIN CATCH
	
  PRINT '��������� ' + CAST(ERROR_NUMBER() AS VARCHAR) + ', ������� ' + CAST(ERROR_SEVERITY() AS VARCHAR) +
	  ', ��������� ' + CAST(ERROR_STATE() AS VARCHAR) + ', ������ ' + CAST(ERROR_LINE() AS VARCHAR) + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
	
	THROW;
	
END CATCH