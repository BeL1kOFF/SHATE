-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-03-31
-- Description:	Изменение Email в отделе
-- =============================================
CREATE PROCEDURE [dbo].[opt_upd_departmentemail]
  @Id_Department INT,
  @EMail VARCHAR(255),
  @BeginTime TIME
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	UPDATE DEPARTMENTS
  	SET EMAIL = @EMail,
  	    BeginTime = @BeginTime
  	WHERE ID_DEPARTMENT = @Id_Department
  	
    SELECT 0, ''
  END TRY
  BEGIN CATCH
  	
  	SELECT -1, 'Ошибка: ' + ERROR_MESSAGE()
  	
  END CATCH
  
  
END