-- =============================================
-- Author: ��������� �.�.
-- Create date: 2014-03-31
-- Description:	�������� ������ ������ � ����������
-- =============================================
CREATE PROCEDURE [dbo].[opt_sel_costs]
AS
BEGIN

	SET NOCOUNT ON;

  SELECT
    c.COST_ID,
    c.NAME,
    c.NDS
  FROM
    COSTS c
  ORDER BY
    c.NAME

END