-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-03-31
-- Description:	Изменение ндс в статье
-- =============================================
CREATE PROCEDURE [dbo].[opt_upd_costnds]
	@Id_Cost INT,
	@NDS INT
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
    UPDATE COSTS
    SET NDS = @NDS
    WHERE COST_ID = @Id_Cost
 
    SELECT 0, ''
 
  END TRY
  BEGIN CATCH
  	
  	SELECT -1, 'Ошибка: ' + ERROR_MESSAGE()
  	
  END CATCH
  
END