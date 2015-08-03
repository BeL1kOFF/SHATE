-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-04-01
-- Description:	Выборка отделов для отправки писем
-- =============================================
CREATE PROCEDURE [dbo].[call_sel_maildepartment]
  @Id_User INT,
  @BeginDate DATETIME,
  @EndDate DATETIME
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE
  	@IsUserFilter BIT

  IF (SELECT COUNT(*) FROM CROSS_USERDEPARTMENT cu2 WHERE cu2.ID_USER = @Id_User) = 0
    SET @IsUserFilter = 0
  ELSE
  	SET @IsUserFilter = 1;


  WITH CTE AS (
  	            SELECT
  	              a.NUMBER,
  	              a.ID_DEPARTMENT,
  	              ROW_NUMBER() OVER (PARTITION BY a.NUMBER ORDER BY a.DateActive DESC) AS 'rown'
  	            FROM
  	              ABONENTS a
  	            WHERE
  	              a.DateActive < DATEADD(d, 1, @EndDate)
  	          )
    SELECT DISTINCT
      d.NAME,
      d.EMAIL
    FROM
      DEPARTMENTS d
      JOIN CTE a
        ON a.ID_DEPARTMENT = d.ID_DEPARTMENT
      JOIN CALLERS c
        ON c.NUMBER = a.NUMBER
      JOIN CALLS cs
        ON cs.CALLER_ID = c.CALLER_ID
      LEFT JOIN CROSS_USERDEPARTMENT cu
        ON cu.ID_DEPARTMENT = d.ID_DEPARTMENT
    WHERE
      a.rown = 1 AND
      ISNULL(d.EMAIL, '') <> '' AND
      cs.DT >= @BeginDate AND cs.DT < DATEADD(d, 1, @EndDate) AND
      (cu.ID_USER = @Id_User OR @IsUserFilter = 0)

END