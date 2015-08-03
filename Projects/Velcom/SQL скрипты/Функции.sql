-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_numbers_on_period]
(
	@Id_Employee INT,
	@BeginDate DATE,
	@EndDate DATE
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	
	DECLARE
		@Result NVARCHAR(MAX) = N'';
		
	WITH CTE AS (
              SELECT
                cne.Id_Caller,
                cne.DateActive,
                MAX(cne.DateActive) OVER(PARTITION BY cne.Id_Caller ORDER BY cne.DateActive ROWS BETWEEN 1 FOLLOWING AND 1 FOLLOWING) AS DateActive_Next,
                cne.Id_Employee
              FROM
                CrossCallerEmployee cne)
    SELECT
      @Result = @Result + cl.Number + N', '
    FROM
      CTE c
      JOIN [Caller] cl
        ON cl.Id_Caller = c.Id_Caller
    WHERE
      c.Id_Employee = @Id_Employee AND
      ((c.DateActive < @BeginDate) OR (c.DateActive BETWEEN @BeginDate AND @EndDate)) AND
      ((c.DateActive_Next BETWEEN @BeginDate AND @EndDate) OR
       (c.DateActive_Next > @EndDate) OR
       (c.DateActive_Next IS NULL))
    GROUP BY
      cl.Number
    ORDER BY
      cl.Number

  IF @Result <> N''
    SET @Result = LEFT(@Result, LEN(@Result) - 1)

  RETURN @Result

END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_employeesname_on_period]
(
	@Id_Caller INT,
	@BeginDate DATE,
	@EndDate DATE
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	
	DECLARE
		@Result NVARCHAR(MAX) = N'';

  WITH CTE AS (
              SELECT
                cne.Id_Caller,
                cne.DateActive,
                MAX(cne.DateActive) OVER(PARTITION BY cne.Id_Caller ORDER BY cne.DateActive ROWS BETWEEN 1 FOLLOWING AND 1 FOLLOWING) AS DateActive_Next,
                cne.Id_Employee
              FROM
                CrossCallerEmployee cne)
    SELECT
      @Result = @Result + e.Name + N', '
    FROM
      CTE c
      JOIN Employee e
        ON e.Id_Employee = c.Id_Employee
    WHERE
      c.Id_Caller = @Id_Caller AND
      ((c.DateActive < @BeginDate) OR (c.DateActive BETWEEN @BeginDate AND @EndDate)) AND
      ((c.DateActive_Next BETWEEN @BeginDate AND @EndDate) OR
       (c.DateActive_Next > @EndDate) OR
       (c.DateActive_Next IS NULL))
    GROUP BY
      c.Id_Employee,
      e.Name
    ORDER BY
      e.Name

  IF @Result <> ''
    SET @Result = LEFT(@Result, LEN(@Result) - 1)

  RETURN @Result

END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_employeedepartment_on_date]
(
	@Id_Employee INT,
	@Date DATE
)
RETURNS INT
AS
BEGIN
	
	DECLARE
		@Result INT = NULL
	
	SELECT TOP 1
	  @Result = ced.Id_Department
	FROM
	  CrossEmployeeDepartment ced
	WHERE
	  ced.Id_Employee = @Id_Employee AND
	  ced.DateActive < DATEADD(d, 1, @Date)
	ORDER BY
	  ced.DateActive DESC
	  
	RETURN @Result

END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_get_calleremployee_on_date]
(
	@Id_Caller INT,
	@Date DATE
)
RETURNS INT
AS
BEGIN
	
	DECLARE
		@Result INT = NULL
  
  SELECT TOP 1
    @Result = cne.Id_Employee
  FROM
    CrossCallerEmployee cne
  WHERE
    cne.Id_Caller = @Id_Caller AND
    cne.DateActive < DATEADD(d, 1, @Date)
  ORDER BY
    cne.DateActive DESC
  
  RETURN @Result

END
GO