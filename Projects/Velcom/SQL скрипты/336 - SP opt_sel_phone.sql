-- =============================================
-- Author: ��������� �.�.
-- Create date: 2014-03-31
-- Description:	�������� ������ ��������� � ����������
-- =============================================
CREATE PROCEDURE [dbo].[opt_sel_phone]
AS
BEGIN

	SET NOCOUNT ON;

  SELECT
    ntw.Number,
    ntw.BeginTime,
    ntw.EndTime
  FROM
    NumberTimeWork ntw
  ORDER BY
    ntw.Number

END