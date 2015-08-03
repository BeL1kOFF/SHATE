-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-07-17
-- Description:	Загрузка клиента в справочник
-- =============================================
ALTER PROCEDURE [dbo].[call_ins_contact]
	@Number VARCHAR(128),
	@Description VARCHAR(128),
	@Code VARCHAR(20),
	@Type TINYINT
AS
BEGIN
	
	SET NOCOUNT ON;

  SET @Number = LEFT(REPLACE(REPLACE(@Number, '-', ''), ' ', ''), 9)

  IF EXISTS(SELECT * FROM Contact c
            WHERE c.Number = @Number)
    UPDATE Contact
    SET [Description] = @Description,
    	  Code = @Code,
    	  [Type] = @Type
    WHERE Number = @Number
  ELSE
  	INSERT INTO Contact
  	  (Number, [Description], Code, [Type])
  	VALUES
  	  (@Number, @Description, @Code, @Type)
  
END