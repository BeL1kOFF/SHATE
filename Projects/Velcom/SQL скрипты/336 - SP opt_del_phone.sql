-- =============================================
-- Author: ��������� �.�.
-- Create date: 2014-03-31
-- Description:	�������� �������� ������� ���������
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
  	
  	SELECT -1, '������: ' + ERROR_MESSAGE()
  	
  END CATCH
  	
  

END