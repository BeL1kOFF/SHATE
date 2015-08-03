-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-03-31
-- Description:	Загрузка списка отделов в настройках
-- =============================================
CREATE PROCEDURE [dbo].[opt_sel_department]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT
	  d.ID_DEPARTMENT,
	  d.NAME,
	  d.EMAIL,
	  d.BeginTime,
	  d.EndTime
	FROM
	  DEPARTMENTS d
	ORDER BY
	  d.NAME
	
END