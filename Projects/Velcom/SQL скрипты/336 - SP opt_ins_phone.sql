-- =============================================
-- Author: ��������� �.�.
-- Create date: 2014-03-31
-- Description:	��������� �������� ������� ���������
-- =============================================
CREATE PROCEDURE [dbo].[opt_ins_phone]
  @Number VARCHAR(7),
  @BeginTime TIME,
  @EndTime TIME
AS
BEGIN

	SET NOCOUNT ON;

  BEGIN TRY
  	
  	INSERT INTO NumberTimeWork
  	  (Number, BeginTime, EndTime)
  	VALUES
  	  (@Number, @BeginTime, @EndTime)
  	
  	SELECT 0, ''
  	
  END TRY
  BEGIN CATCH
  	
  	SELECT -1, '������: ' + ERROR_MESSAGE()
  	
  END CATCH
  
END