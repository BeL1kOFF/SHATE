-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-03-31
-- Description:	Загрузка связки Пользователь/Отдел
-- =============================================
CREATE PROCEDURE [dbo].[opt_sel_usersdepartment]
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE
	  @SQL VARCHAR(MAX),
	  @PivotList VARCHAR(MAX)
	
  SET @PivotList = ''

  SELECT
    @PivotList = @PivotList + '[' + CAST(d.ID_DEPARTMENT AS VARCHAR(MAX)) + ' - ' + d.NAME + '], '
  FROM
    DEPARTMENTS d
  ORDER BY
    d.NAME
  
    SET @PivotList = LEFT(@PivotList, LEN(@PivotList) - 1)
  
  SET @SQL = 
  'SELECT * FROM
    (SELECT u.ID AS Id_User, u.NAME AS UserName, CAST(d.ID_DEPARTMENT AS VARCHAR(MAX)) + '' - '' + d.NAME AS DepartmentName, cu.ID_DEPARTMENT FROM USERS u
     CROSS JOIN DEPARTMENTS d
     LEFT JOIN CROSS_USERDEPARTMENT cu
       ON cu.ID_USER = u.ID AND
          cu.ID_DEPARTMENT = d.ID_DEPARTMENT
      ) rez
  PIVOT(
	  COUNT(ID_DEPARTMENT) FOR DepartmentName IN (' + @PivotList + ')
  ) pvt
  ORDER BY
    pvt.UserName'

  EXEC (@SQL)

END