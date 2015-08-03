-- =============================================
-- Author: ��������� �.�.
-- Create date: 2014-03-31
-- Description:	��������� Email � ������
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
  	
  	SELECT -1, '������: ' + ERROR_MESSAGE()
  	
  END CATCH
  
  
END