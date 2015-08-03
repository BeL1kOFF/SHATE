-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-03-31
-- Description:	Удаление рабочего времени телефонов
-- =============================================
CREATE PROCEDURE [dbo].[opt_del_phone]
AS
BEGIN

	SET NOCOUNT ON;

  BEGIN TRY
  
    DELETE FROM NumberTimeWork
    
    SELECT 0, ''
  	
  END TRY
  BEGIN CATCH
  	
  	SELECT -1, 'Ошибка: ' + ERROR_MESSAGE()
  	
  END CATCH
  	
  

END