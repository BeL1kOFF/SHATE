-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-03-28
-- Description:	Выборка звонивших абонентов за период
-- =============================================
CREATE PROCEDURE [dbo].[call_sel_callers] 
	@Id_User INT,
	@BeginDate DATETIME,
	@EndDate DATETIME
AS
BEGIN
	
	SET NOCOUNT ON;

  DECLARE
  	@IsUserFilter BIT
  
  /*
   * Определяем, будет ли использоваться фильтр по пользователю
   */
  IF (SELECT COUNT(*) FROM CROSS_USERDEPARTMENT cu2 WHERE cu2.ID_USER = @Id_User) = 0
    SET @IsUserFilter = 0
  ELSE
  	SET @IsUserFilter = 1;

  WITH AB AS (
  	            /*
  	             * 1) Выборка всех абонентов на конец периода
  	             */
  	            SELECT
  	              a.NUMBER,
                  a.ABN_NAME,
                  a.ID_DEPARTMENT,
                  ROW_NUMBER() OVER (PARTITION BY a.NUMBER ORDER BY a.DateActive DESC) AS 'rown'
                FROM
                  ABONENTS a
                WHERE
                  a.DateActive < DATEADD(d, 1, @EndDate)
             ),
      CTE AS (
      	        /*
  	             * 2) Выборка всех звонков за период с учетом(без) фильтра пользователя
  	             */
      	        SELECT
                  c.CALLER_ID,
                  c.NUMBER,
                  c.NAME,
                  ISNULL(a.ABN_NAME, c.NAME) AS 'ABN_NAME',
                  ISNULL(d.NAME, '') AS 'ABN_DEPARTMENT',
                  cs.COST_ID,
                  cs.PRICE,
                  CAST(cs.DT AS TIME) AS DT,
                  COALESCE(ntw.BeginTime, d.BeginTime, CAST('09:00' AS TIME)) AS BeginTime,
                  COALESCE(ntw.EndTime, d.EndTime, CAST('18:00' AS TIME)) AS EndTime,
                  CASE
                    WHEN a.ABN_NAME IS NOT NULL THEN 1
                    ELSE 0
                  END AS 'ABN_EXISTS'
                FROM
                  CALLS cs
                  JOIN CALLERS c
                    ON c.CALLER_ID = cs.CALLER_ID
                  LEFT JOIN AB a
                    ON a.NUMBER = c.NUMBER AND
                       a.rown = 1
                  LEFT JOIN DEPARTMENTS d
                    ON d.ID_DEPARTMENT = a.ID_DEPARTMENT
                  LEFT JOIN NumberTimeWork ntw
                    ON ntw.Number = c.NUMBER
	              WHERE
	                (d.ID_DEPARTMENT IN (SELECT cu.ID_DEPARTMENT FROM CROSS_USERDEPARTMENT cu
	                                     WHERE cu.ID_USER = @Id_User) OR (@IsUserFilter = 0)) AND
                  cs.DT >= @BeginDate AND cs.DT < DATEADD(d, 1, @EndDate)
             ),
       CTE2 AS (
       	        /*
       	         * 3) Группируем звонки по абонентам и суммируем стоимости.
       	         */
                SELECT
                  cs.CALLER_ID,
                  cs.NUMBER,
                  cs.NAME,
                  cs.ABN_NAME,
                  cs.ABN_DEPARTMENT,
                  cs.ABN_EXISTS,
                  SUM(cs.PRICE) AS 'SUM',
                  SUM(CASE
                        WHEN (cs.DT BETWEEN cs.BeginTime AND cs.EndTime) OR (cs.DT = '00:00:00') THEN cs.PRICE
                        ELSE 0
                      END) AS 'SUM_WORK',
                  SUM(CASE
                        WHEN (cs.DT BETWEEN cs.BeginTime AND cs.EndTime) OR (cs.DT = '00:00:00') THEN 0
                        ELSE cs.PRICE
                      END) AS 'SUM_NOWORK'
                FROM
                  CTE cs
                GROUP BY
                  cs.CALLER_ID,
                  cs.NUMBER,
                  cs.NAME,
                  cs.ABN_NAME,
                  cs.ABN_DEPARTMENT,
                  cs.ABN_EXISTS
               ),
       CTE3 AS (
       	        /*
       	         * 4) Группируем звонки по абонентам + статьям и суммируем стоимость
       	         */
  	            SELECT
  	              cs.CALLER_ID,
  	              cs.COST_ID,
  	              SUM(cs.PRICE) AS 'SUM_COST',
  	              ROW_NUMBER() OVER (PARTITION BY cs.CALLER_ID ORDER BY SUM(cs.PRICE) DESC) AS 'rown'
  	            FROM
  	              CTE cs
  	            GROUP BY
  	              cs.CALLER_ID,
  	              cs.COST_ID
               )
  /*
   * 5) Объединяем звонки по абонентам, где расчитали стоимость в разрезе абонента и стоимость в разрезе статья/абонент, при том выбираем в статье/абонент
   * только максимальную стоимость (рассчитали ранее)
   */
  SELECT
    cs2.CALLER_ID,
    cs2.NUMBER,
    cs2.NAME,
    cs2.ABN_NAME,
    cs2.ABN_DEPARTMENT,
    cs2.[SUM] * (ISNULL(c.NDS, 0) + 100) / 100.0 AS 'SUM',
    cs2.SUM_WORK * (ISNULL(c.NDS, 0) + 100) / 100.0 AS 'SUM_WORK',
    cs2.SUM_NOWORK * (ISNULL(c.NDS, 0) + 100) / 100.0 AS 'SUM_NOWORK',
    cs3.SUM_COST * (ISNULL(c.NDS, 0) + 100) / 100.0 AS 'TOP_COST_SUM_CALC',
    c.NAME AS 'TOP_COST_CALC',
    cs2.ABN_EXISTS
  FROM
    CTE2 cs2
    JOIN CTE3 cs3
      ON cs2.CALLER_ID = cs3.CALLER_ID
    JOIN COSTS c
      ON c.COST_ID = cs3.COST_ID
  WHERE
    cs3.rown = 1
  ORDER BY
    cs2.CALLER_ID

END