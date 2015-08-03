-- =============================================
-- Author: ��������� �.�.
-- Create date: 2014-04-03
-- Description:	�������� �� ���������� ���
-- =============================================
CREATE PROCEDURE [dbo].[call_sel_isnds]
AS
BEGIN

	SET NOCOUNT ON;

  IF EXISTS(SELECT c.NDS FROM COSTS c
            WHERE c.NDS IS NULL)
    SELECT 1 AS 'IsNDS'
  ELSE
  	SELECT 0 AS 'IsNDS'

END