-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-04-01
-- Description:	Выборка детализации по абоненту за период
-- =============================================
ALTER PROCEDURE [dbo].[abn_sel_calls] 
  @Id_Caller INT,
  @BeginDate DATETIME,
  @EndDate DATETIME
AS
BEGIN
	
	SET NOCOUNT ON;

  DECLARE
  	@BeginTime TIME,
  	@EndTime TIME;

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
    SELECT
      @BeginTime = COALESCE(ntw.BeginTime, d.BeginTime, CAST('09:00' AS TIME)),
      @EndTime = COALESCE(ntw.EndTime, d.EndTime, CAST('18:00' AS TIME))
    FROM
      CALLERS c
      LEFT JOIN CTE a
        ON a.NUMBER = c.NUMBER AND
           a.rown = 1
      LEFT JOIN DEPARTMENTS d
        ON d.ID_DEPARTMENT = a.ID_DEPARTMENT
      LEFT JOIN NumberTimeWork ntw
        ON ntw.Number = c.NUMBER
    WHERE
      c.CALLER_ID = @Id_Caller;

  WITH CTE AS (
  	            SELECT
  	              a.NUMBER,
  	              a.ABN_NAME,
  	              ROW_NUMBER() OVER (PARTITION BY a.NUMBER ORDER BY a.DateActive DESC) AS 'rown'
  	            FROM
  	              ABONENTS a
  	            WHERE
  	              a.DateActive < DATEADD(d, 1, @EndDate)
  	          )
  SELECT
    cs.DT,
    cs.[LEN],
    cs.PRICE,
    cs.PRICE * (ISNULL(c.NDS, 0) + 100) / 100.0 AS 'PRICENDS',
    cs.NUMBER,
    COALESCE(a.ABN_NAME, c2.[Description], '') AS 'ABN_TO',
    c.NAME AS 'COST',
    cs.TYPE_CODE,
    CASE
      WHEN (CAST(cs.DT AS TIME) BETWEEN @BeginTime AND @EndTime) OR (CAST(cs.DT AS TIME) = '00:00:00') THEN 1
      ELSE 0
    END AS 'IsWorkTime',
    CASE
      WHEN a.NUMBER IS NOT NULL THEN 1
      ELSE 0
    END AS 'ABN_FOUND',
    cs.COST_ID,
    ISNULL(c2.Id_Contact, 0) AS Id_Contact,
    CASE
      WHEN a.NUMBER IS NOT NULL THEN 'Сотрудники'
      WHEN c2.Id_Contact IS NOT NULL THEN 'Клиенты'
      ELSE ''
    END AS 'Reference'
  FROM
    CALLS cs
    JOIN COSTS c
      ON c.COST_ID = cs.COST_ID
    LEFT JOIN CTE a
      ON a.NUMBER = RIGHT(cs.NUMBER, 7) AND
         a.rown = 1
    LEFT JOIN Contact c2
      ON c2.Number = RIGHT(cs.NUMBER, 9)
  WHERE
    cs.CALLER_ID = @Id_Caller AND
    cs.DT >= @BeginDate AND cs.DT < DATEADD(d, 1, @EndDate)
  ORDER BY
    cs.DT
  
END