-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-04-01
-- Description:	Выборка звонков абонента для печати в Excel
-- =============================================
ALTER PROCEDURE [dbo].[excl_sel_calls]
  @Id_Caller INT,
  @BeginDate DATETIME,
  @EndDate DATETIME
AS
BEGIN
	
	SET NOCOUNT ON;

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
        WHEN a.NUMBER IS NOT NULL THEN 1
        ELSE 0
      END AS 'ABN_FOUND',
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