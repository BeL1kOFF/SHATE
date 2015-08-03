-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-03-31
-- Description:	Загрузка списка телефонов в настройках
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