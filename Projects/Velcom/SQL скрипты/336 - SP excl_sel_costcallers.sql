-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-04-01
-- Description:	Выборка звонков сгруппированых по абоненту и статье для печати в Excel.
-- =============================================
CREATE PROCEDURE [dbo].[excl_sel_costcallers]
	@Id_Caller INT,
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    cs.CALLER_ID,
    cs.COST_ID,
    c.NAME,
    SUM(cs.[LEN]) AS 'LEN',
    SUM(cs.PRICE) AS 'PRICE',
    SUM(cs.PRICE) * (ISNULL(c.NDS, 0) + 100) / 100.0 AS 'PRICENDS'
  FROM
    CALLS cs
    JOIN COSTS c
      ON c.COST_ID = cs.COST_ID
  WHERE
    cs.CALLER_ID = @Id_Caller AND
    cs.DT >= @BeginDate AND cs.DT < DATEADD(d, 1, @EndDate)
  GROUP BY
    cs.CALLER_ID,
    cs.COST_ID,
    c.NAME,
    c.NDS
  
END