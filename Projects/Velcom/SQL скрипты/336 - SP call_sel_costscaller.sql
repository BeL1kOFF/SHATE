-- =============================================
-- Author: Матусевич Александр
-- Create date: 2014-03-31
-- Description:	Выборка сумм по статьям абонента за период
-- =============================================
CREATE PROCEDURE [dbo].[call_sel_costscaller]
	@Id_Caller INT,
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    c.NAME,
    SUM(cs.[LEN]) AS [Len],
    SUM(cs.PRICE) * (ISNULL(c.NDS, 0) + 100) / 100.0 AS [Sum]
  FROM
    CALLS cs
    JOIN COSTS c
      ON cs.COST_ID = c.COST_ID
  WHERE
    cs.CALLER_ID = @Id_Caller AND
    cs.DT >= @BeginDate AND cs.DT < DATEADD(d, 1, @EndDate)
  GROUP BY
    c.COST_ID,
    c.NAME,
    c.NDS
  HAVING
    SUM(cs.PRICE) > 0

END