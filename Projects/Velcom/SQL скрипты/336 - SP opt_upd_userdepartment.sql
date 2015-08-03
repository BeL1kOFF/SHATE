-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-03-31
-- Description:	Изменить привязку Пользователь/Отдел
-- =============================================
CREATE PROCEDURE [dbo].[opt_upd_userdepartment]
	@Id_User INT,
	@Id_Department INT,
	@Value BIT
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
    IF @Value = 0
   	  DELETE FROM CROSS_USERDEPARTMENT
  	  WHERE ID_USER = @Id_User AND ID_DEPARTMENT = @Id_Department
    ELSE
      IF NOT EXISTS (SELECT * FROM CROSS_USERDEPARTMENT cu
                     WHERE cu.ID_USER = @Id_User AND cu.ID_DEPARTMENT = @Id_Department)
        INSERT INTO CROSS_USERDEPARTMENT
          (ID_USER, ID_DEPARTMENT)
        VALUES
          (@Id_User, @Id_Department)
  
    SELECT 0, ''
  
  END TRY
  BEGIN CATCH
  	
  	SELECT -1, 'Ошибка: ' + ERROR_MESSAGE()
  	
  END CATCH
  
END