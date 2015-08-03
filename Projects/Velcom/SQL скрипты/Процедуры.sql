-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-07-17
-- Description:	Загрузка клиента в справочник
-- =============================================
ALTER PROCEDURE [dbo].[call_ins_contact]
	@Number NVARCHAR(50),
	@Description NVARCHAR(128),
	@Code NVARCHAR(50),
	@Type TINYINT
AS
BEGIN
	
	SET NOCOUNT ON;

  SET @Number = LEFT(REPLACE(REPLACE(@Number, N'-', N''), N' ', N''), 9)

  IF EXISTS(SELECT * FROM Contact c
            WHERE c.Number = @Number)
    UPDATE Contact
    SET [Description] = @Description,
    	  Code = @Code,
    	  [Type] = @Type
    WHERE Number = @Number
  ELSE
  	INSERT INTO Contact
  	  (Number, [Description], Code, [Type])
  	VALUES
  	  (@Number, @Description, @Code, @Type)
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-04-03
-- Description:	Проверка на отсутствие НДС
-- =============================================
CREATE PROCEDURE [dbo].[call_sel_isvat]
AS
BEGIN

	SET NOCOUNT ON;

  IF EXISTS(SELECT c.Vat FROM Cost c
            WHERE c.Vat IS NULL)
    SELECT CAST(1 AS BIT) AS IsVAT
  ELSE
  	SELECT CAST(0 AS BIT) AS IsVAT

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-11
-- Description:	Загрузка прав пользователя
-- =============================================
CREATE PROCEDURE [dbo].[call_sel_userrights]
  @UserName NVARCHAR(128)
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    u.Id_User,
    u.CanLogin,
    u.CanUser,
    u.CanWrite,
    u.CanAdmin
  FROM
    [User] u
  WHERE
    u.Name = @UserName
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-25
-- Description:	Справочник номеров. Удаление номеров.
-- =============================================
CREATE PROCEDURE [dbo].[cll_del_item]
AS
BEGIN

	SET NOCOUNT ON;

  BEGIN TRY
  	
  	IF EXISTS (SELECT * FROM [Call] c
  	           WHERE c.Id_Caller IN (SELECT tmp.Id_Caller FROM #tmpDelCaller tmp))
    BEGIN
    	SELECT 0, N'Существуют звонки с выбранных номеров.' + CHAR(13) + CHAR(10) + N'Номера не могут быть удалены.'
      RETURN
    END
  	
  	BEGIN TRAN
  	
  	DELETE FROM CrossCallerEmployee
  	WHERE Id_Caller IN (SELECT tmp.Id_Caller FROM #tmpDelCaller tmp)
  	
  	DELETE FROM [Caller]
  	WHERE Id_Caller IN (SELECT tmp.Id_Caller FROM #tmpDelCaller tmp)
  	
  	COMMIT TRAN
  	
  	SELECT 1, N'Номера удалены'
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-25
-- Description:	Справочник номеров. Редактирование номера.
-- =============================================
CREATE PROCEDURE [dbo].[cll_edt_item]
	@Id_Caller INT,
	@Number NCHAR(9)
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	IF EXISTS (SELECT * FROM [Call] c
  	           WHERE c.Id_Caller = @Id_Caller)
    BEGIN
    	SELECT 0, N'Существуют звонки с этого номера.' + CHAR(13) + CHAR(10) + N'Номер не может быть изменен.'
      RETURN
    END
    
  	BEGIN TRAN
  	
  	UPDATE [Caller]
  	SET Number = @Number
  	WHERE Id_Caller = @Id_Caller
  	
  	COMMIT TRAN
  	
  	SELECT 1, N'Номер изменен'
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-25
-- Description:	Справочник номеров. Добавление номера.
-- =============================================
CREATE PROCEDURE [dbo].[cll_ins_item]
	@Number NCHAR(9)
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	BEGIN TRAN
  	
  	INSERT INTO [Caller]
  	  (Number, Name, Abonent)
  	VALUES
  	  (@Number, N'', N'')
  	
  	COMMIT TRAN
  	
  	SELECT 1, N'Номер сохранен'
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-25
-- Description:	Справочник номеров. Выборка номера.
-- =============================================
CREATE PROCEDURE [dbo].[cll_sel_item]
	@Id_Caller INT
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    c.Number
  FROM
    [Caller] c
  WHERE
    c.Id_Caller = @Id_Caller
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-25
-- Description:	Справочник номеров. Выборка номеров.
-- =============================================
CREATE PROCEDURE [dbo].[cll_sel_itemlist]
AS
BEGIN

	SET NOCOUNT ON;

  SELECT
    c.Id_Caller,
    c.Number,
    ISNULL(e.Name, N'') AS EmployeeName,
    ISNULL(d.Name, N'') AS DepartmentName
  FROM
    [Caller] c
    LEFT JOIN Employee e
      ON e.Id_Employee = dbo.fn_get_calleremployee_on_date(c.Id_Caller, GETDATE())
    LEFT JOIN Department d
      ON d.Id_Department = dbo.fn_get_employeedepartment_on_date(e.Id_Employee, GETDATE())
  ORDER BY
    c.Number

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-03-31
-- Description:	Изменение статьи
-- =============================================
CREATE PROCEDURE [dbo].[cst_edt_item]
	@Id_Cost INT,
	@Vat TINYINT
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
    UPDATE Cost
    SET Vat = @Vat
    WHERE Id_Cost = @Id_Cost
 
    SELECT 1, N''
 
  END TRY
  BEGIN CATCH
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-03-31
-- Description:	Загрузка списка статей
-- =============================================
CREATE PROCEDURE [dbo].[cst_sel_item]
AS
BEGIN

	SET NOCOUNT ON;

  SELECT
    c.Id_Cost,
    c.Name,
    c.Vat
  FROM
    Cost c
  ORDER BY
    c.Name

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-01
-- Description:	Справочник отделов. Удаление.
-- =============================================
CREATE PROCEDURE [dbo].[dpt_del_item]
AS
BEGIN

	SET NOCOUNT ON;

  BEGIN TRY
  	
    IF EXISTS (SELECT
                 *
               FROM
                 CrossEmployeeDepartment ced
                 JOIN #tmpDelDepartment tmp
                   ON ced.Id_Department = tmp.Id_Department) OR
       EXISTS (SELECT
                 *
               FROM
                 CrossUserDepartment cud
                 JOIN #tmpDelDepartment tmp
                   ON cud.Id_Department = tmp.Id_Department)
    BEGIN
  	  SELECT 0, N'Существуют привязанные отделы.' + CHAR(13) + CHAR(10) + N'Отделы не могут быть удалены.'
      RETURN
    END
  
    BEGIN TRAN
  
    DELETE FROM ExternalDepartment
    WHERE Id_Department IN (SELECT tmp.Id_Department FROM #tmpDelDepartment tmp)
  
    DELETE FROM Department
    WHERE Id_Department IN (SELECT tmp.Id_Department FROM #tmpDelDepartment tmp)

    COMMIT TRAN
    
    SELECT 1, N'Отделы удалены'

  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
  	
  END CATCH

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-04
-- Description:	Справочник отделов. Изменение внешнего кода.
-- =============================================
CREATE PROCEDURE [dbo].[dpt_edt_extcode]
	@Id_Department INT,
	@DepartmentExternalCode NVARCHAR(255),
	@Id_ExternalSystem INT
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	BEGIN TRAN
  	
  	SET @DepartmentExternalCode = LTRIM(RTRIM(@DepartmentExternalCode))
  	
  	IF @DepartmentExternalCode = ''
  	BEGIN
  		DELETE FROM ExternalDepartment
  		WHERE Id_Department = @Id_Department AND
  		      Id_ExternalSystem = @Id_ExternalSystem
  	END
  	ELSE
  	BEGIN
  		IF NOT EXISTS(SELECT * FROM ExternalDepartment ed
  		              WHERE ed.Id_Department = @Id_Department AND
  		                    ed.Id_ExternalSystem = @Id_ExternalSystem)
      BEGIN
      	
      	INSERT INTO ExternalDepartment
      	  (Id_Department, DepartmentExternalCode, Id_ExternalSystem)
      	VALUES
      	  (@Id_Department, @DepartmentExternalCode, @Id_ExternalSystem)
      	
      END
      ELSE
      BEGIN
      	
      	UPDATE ExternalDepartment
      	SET DepartmentExternalCode = @DepartmentExternalCode
      	WHERE Id_Department = @Id_Department AND
      	      Id_ExternalSystem = @Id_ExternalSystem
      	
      END
  	END
  	
  	COMMIT TRAN
  	
  	SELECT 1, ''
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-01
-- Description:	Справочник отделов. Редактирование.
-- =============================================
CREATE PROCEDURE [dbo].[dpt_edt_item]
	@Id_Department INT,
	@Name NVARCHAR(255),
	@Email NVARCHAR(255),
	@BeginTime TIME,
	@EndTime TIME
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	BEGIN TRAN
  	
  	UPDATE Department
  	SET Name = @Name,
  		  EMail = @Email,
  		  BeginTime = @BeginTime,
  		  EndTime = @EndTime
  	WHERE
  	  Id_Department = @Id_Department
  	
  	COMMIT TRAN
  	
  	SELECT 1, N'Отдел сохранен'
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-01
-- Description:	Справочник отделов. Добавление.
-- =============================================
CREATE PROCEDURE [dbo].[dpt_ins_item]
	@Name NVARCHAR(255),
	@EMail NVARCHAR(255),
	@BeginTime TIME,
	@EndTime TIME
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	BEGIN TRAN
  	
  	INSERT INTO Department
  	  (Name, EMail, BeginTime, EndTime)
  	VALUES
  	  (@Name, @EMail, @BeginTime, @EndTime)
  	
  	COMMIT TRAN
  	
  	SELECT 1, N'Отдел сохранен'
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-04
-- Description:	Справочник отделов. Внешние коды
-- =============================================
CREATE PROCEDURE [dbo].[dpt_sel_extcodelist]
  @Id_User INT
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE
  	@IsUserFilter BIT,
  	@SQL NVARCHAR(MAX),
	  @PivotList NVARCHAR(MAX) = N''

  IF (SELECT COUNT(*) FROM CrossUserDepartment cud WHERE cud.Id_User = @Id_User) = 0
    SET @IsUserFilter = 0
  ELSE
  	SET @IsUserFilter = 1;
  
  SELECT
    @PivotList = @PivotList + N'[' + CAST(es.Id_ExternalSystem AS NVARCHAR(MAX)) + N' - ' + es.Name + N'], '
  FROM
    ExternalSystem es
  ORDER BY
    es.Name
  
  SET @PivotList = LEFT(@PivotList, LEN(@PivotList) - 1)
  
  SET @SQL =
  N'SELECT
      pvt.*
    FROM 
      (SELECT
        d.Id_Department,
        d.Name AS DepartmentName,
        ed.DepartmentExternalCode,
        CAST(es.Id_ExternalSystem AS NVARCHAR(MAX)) + '' - '' + es.Name AS ExternalSystemName
      FROM
        Department d
        LEFT JOIN ExternalDepartment ed
          JOIN ExternalSystem es
            ON es.Id_ExternalSystem = ed.Id_ExternalSystem
          ON d.Id_Department = ed.Id_Department
      WHERE
        d.Id_Department IN (SELECT cud.Id_Department FROM CrossUserDepartment cud
                            WHERE cud.Id_User = ' + CAST(@Id_User AS NVARCHAR(MAX)) + N') OR (' + CAST(@IsUserFilter AS NVARCHAR(MAX)) + N' = 0)
      ) rez
    PIVOT (
       MAX(rez.DepartmentExternalCode) FOR rez.ExternalSystemName IN (' + @PivotList + N')
    ) pvt
    ORDER BY
      pvt.DepartmentName'
    
  EXEC (@SQL)

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-01
-- Description:	Справочник отделов. Выборка отдела.
-- =============================================
CREATE PROCEDURE [dbo].[dpt_sel_item]
	@Id_Department INT
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    d.Name,
    d.EMail,
    d.BeginTime,
    d.EndTime
  FROM
    Department d
  WHERE
    d.Id_Department = @Id_Department
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-01
-- Description:	Справочник отделов. Выборка отделов.
-- =============================================
CREATE PROCEDURE [dbo].[dpt_sel_itemlist]
	@Id_User INT
AS
BEGIN
	
	SET NOCOUNT ON;

  DECLARE
  	@IsUserFilter BIT

  IF (SELECT COUNT(*) FROM CrossUserDepartment cud WHERE cud.Id_User = @Id_User) = 0
    SET @IsUserFilter = 0
  ELSE
  	SET @IsUserFilter = 1;

  SELECT
    d.Id_Department,
    d.Name,
    d.EMail,
    d.BeginTime,
    d.EndTime,
    CAST(CASE
           WHEN rez.Id_ExternalDepartment IS NOT NULL THEN 1
           ELSE 0
         END AS BIT) AS IsExternalCode
  FROM
    Department d
    OUTER APPLY (SELECT TOP 1
                   ed.Id_ExternalDepartment
                 FROM
                   ExternalDepartment ed
                 WHERE
                   ed.Id_Department = d.Id_Department) AS rez
  WHERE
    d.Id_Department IN (SELECT cud.Id_Department FROM CrossUserDepartment cud
                        WHERE cud.Id_User = @Id_User) OR (@IsUserFilter = 0)
  ORDER BY
    d.Name
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-04
-- Description:	Справочник сотрудников. Удаление.
-- =============================================
CREATE PROCEDURE [dbo].[empl_del_item]
AS
BEGIN

	SET NOCOUNT ON;

  BEGIN TRY
  	
  	BEGIN TRAN
  	
  	DELETE FROM CrossEmployeeDepartment
  	WHERE Id_Employee IN (SELECT tmp.Id_Employee FROM #tmpDelEmployee tmp)
  	
  	DELETE FROM ExternalEmployee
  	WHERE Id_Employee IN (SELECT tmp.Id_Employee FROM #tmpDelEmployee tmp)
  	
  	DELETE FROM CrossCallerEmployee
  	WHERE Id_Employee IN (SELECT tmp.Id_Employee FROM #tmpDelEmployee tmp)
  	
  	DELETE FROM TableSheet
  	WHERE Id_Employee IN (SELECT tmp.Id_Employee FROM #tmpDelEmployee tmp)
  	
  	DELETE FROM Employee
  	WHERE Id_Employee IN (SELECT tmp.Id_Employee FROM #tmpDelEmployee tmp)
  	
  	COMMIT TRAN
  	
  	SELECT 1, N'Сотрудники удалены'
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-05
-- Description:	Справочник сотрудников. Изменение внешнего кода.
-- =============================================
CREATE PROCEDURE [dbo].[empl_edt_extcode]
	@Id_Employee INT,
	@EmployeeExternalCode NVARCHAR(255),
	@Id_ExternalSystem INT
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	BEGIN TRAN
  	
  	SET @EmployeeExternalCode = LTRIM(RTRIM(@EmployeeExternalCode))
  	
  	IF @EmployeeExternalCode = N''
  	BEGIN
  		DELETE FROM ExternalEmployee
  		WHERE Id_Employee = @Id_Employee AND
  		      Id_ExternalSystem = @Id_ExternalSystem
  	END
  	ELSE
  	BEGIN
  		IF NOT EXISTS(SELECT * FROM ExternalEmployee ee
  		              WHERE ee.Id_Employee = @Id_Employee AND
  		                    ee.Id_ExternalSystem = @Id_ExternalSystem)
      BEGIN
      	
      	INSERT INTO ExternalEmployee
      	  (Id_Employee, EmployeeExternalCode, Id_ExternalSystem)
      	VALUES
      	  (@Id_Employee, @EmployeeExternalCode, @Id_ExternalSystem)
      	
      END
      ELSE
      BEGIN
      	
      	UPDATE ExternalEmployee
      	SET EmployeeExternalCode = @EmployeeExternalCode
      	WHERE Id_Employee = @Id_Employee AND
      	      Id_ExternalSystem = @Id_ExternalSystem
      	
      END
  	END
  	
  	COMMIT TRAN
  	
  	SELECT 1, ''
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-04
-- Description:	Справочник сотрудников. Изменение.
-- =============================================
CREATE PROCEDURE [dbo].[empl_edt_item]
	@Id_Employee INT,
	@Name NVARCHAR(255),
	@BeginTime TIME,
	@EndTime TIME
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	BEGIN TRAN
  	
  	UPDATE Employee
  	SET Name = @Name,
  	    BeginTime = @BeginTime,
  	    EndTime = @EndTime
  	WHERE Id_Employee = @Id_Employee;
  	
  	MERGE CrossEmployeeDepartment AS ced
  	USING (SELECT
  	         tmp.Id_Department,
  	         tmp.DateActive
  	       FROM
  	         #tmpEmplDepartment tmp) AS tmp (Id_Department, DateActive)
    ON ced.Id_Department = tmp.Id_Department AND
       ced.DateActive = tmp.DateActive AND
       ced.Id_Employee = @Id_Employee
    WHEN NOT MATCHED THEN
    	INSERT (Id_Employee, Id_Department, DateActive)
    	VALUES (@Id_Employee, tmp.Id_Department, tmp.DateActive)
    WHEN NOT MATCHED BY SOURCE AND ced.Id_Employee = @Id_Employee THEN
    	DELETE;
  	
  	MERGE CrossCallerEmployee AS n
  	USING (SELECT
  	         tmp.Id_Caller,
  	         tmp.DateActive
  	       FROM
  	         #tmpEmplCaller tmp) AS tmp (Id_Caller, DateActive)
    ON n.Id_Caller = tmp.Id_Caller AND
       n.DateActive = tmp.DateActive AND
       n.Id_Employee = @Id_Employee
    WHEN NOT MATCHED THEN
    	INSERT (Id_Employee, Id_Caller, DateActive)
    	VALUES (@Id_Employee, tmp.Id_Caller, tmp.DateActive)
    WHEN NOT MATCHED BY SOURCE AND n.Id_Employee = @Id_Employee THEN
    	DELETE;
  	
  	COMMIT TRAN
  	
  	SELECT 1, N'Сотрудник изменен'
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-04
-- Description:	Справочник сотрудников. Вставка.
-- =============================================
CREATE PROCEDURE [dbo].[empl_ins_item]
	@Name NVARCHAR(255),
	@BeginTime TIME,
	@EndTime TIME
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	BEGIN TRAN
  	
  	DECLARE
  		@Id_Employee INT
  	
  	INSERT INTO Employee (Name, BeginTime, EndTime)
  	VALUES (@Name, @BeginTime, @EndTime)
  	
  	SET @Id_Employee = SCOPE_IDENTITY()
  	
  	INSERT INTO CrossEmployeeDepartment
  	  (Id_Employee, Id_Department, DateActive)
  	  SELECT
  	    @Id_Employee,
  	    tmp.Id_Department,
  	    tmp.DateActive
  	  FROM
  	    #tmpEmplDepartment tmp
  	
  	INSERT INTO CrossCallerEmployee
  	  (Id_Employee, Id_Caller, DateActive)
  	  SELECT
  	    @Id_Employee,
  	    tmp.Id_Caller,
  	    tmp.DateActive
  	  FROM
  	    #tmpEmplCaller tmp
  	
  	COMMIT TRAN
  	
  	SELECT 1, N'Сотрудник сохранен'
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-25
-- Description:	Справочник сотрудников. Загрузка номеров.
-- =============================================
CREATE PROCEDURE [dbo].[empl_sel_callerlist]
AS
BEGIN

	SET NOCOUNT ON;

  SELECT
    c.Id_Caller,
    c.Number
  FROM
    [Caller] c
  ORDER BY
    c.Number

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-04
-- Description:	Справочник сотрудников. Загрузка отделов.
-- =============================================
CREATE PROCEDURE [dbo].[empl_sel_departmentlist]
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    d.Id_Department,
    d.Name
  FROM
    Department d
  ORDER BY
    d.Name
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-05
-- Description:	Справочник сотрудников. Внешние коды
-- =============================================
CREATE PROCEDURE [dbo].[empl_sel_extcodelist]
  @Id_User INT
AS
BEGIN
	
	SET NOCOUNT ON;

  DECLARE
  	@IsUserFilter BIT,
  	@SQL NVARCHAR(MAX),
	  @PivotList NVARCHAR(MAX) = N''

  IF (SELECT COUNT(*) FROM CrossUserDepartment cud WHERE cud.Id_User = @Id_User) = 0
    SET @IsUserFilter = 0
  ELSE
  	SET @IsUserFilter = 1;
  
  SELECT
    @PivotList = @PivotList + N'[' + CAST(es.Id_ExternalSystem AS NVARCHAR(MAX)) + N' - ' + es.Name + N'], '
  FROM
    ExternalSystem es
  ORDER BY
    es.Name
  
  SET @PivotList = LEFT(@PivotList, LEN(@PivotList) - 1)
  
  SET @SQL =
  N'SELECT
      pvt.*
    FROM 
      (SELECT
        e.Id_Employee,
        e.Name,
        ee.EmployeeExternalCode,
        CAST(es.Id_ExternalSystem AS NVARCHAR(MAX)) + '' - '' + es.Name AS ExternalSystemName
       FROM
        Employee e
        LEFT JOIN ExternalEmployee ee
          JOIN ExternalSystem es
            ON es.Id_ExternalSystem = ee.Id_ExternalSystem
          ON e.Id_Employee = ee.Id_Employee
        LEFT JOIN Department d
          ON d.Id_Department = dbo.fn_get_employeedepartment_on_date(e.Id_Employee, GETDATE())
      WHERE
        d.Id_Department IN (SELECT cud.Id_Department FROM CrossUserDepartment cud
                            WHERE cud.Id_User = ' + CAST(@Id_User AS NVARCHAR(MAX)) + N') OR (' + CAST(@IsUserFilter AS NVARCHAR(MAX)) + N' = 0) OR (d.Id_Department IS NULL)
      ) rez
    PIVOT (
       MAX(rez.EmployeeExternalCode) FOR rez.ExternalSystemName IN (' + @PivotList + N')
    ) pvt
    ORDER BY
      pvt.Name'
    
  EXEC (@SQL)
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-04
-- Description:	Справочник сотрудников. Выборка сотрудника.
-- =============================================
CREATE PROCEDURE [dbo].[empl_sel_item]
	@Id_Employee INT
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    e.Name,
    e.BeginTime,
    e.EndTime
  FROM
    Employee e
  WHERE
    e.Id_Employee = @Id_Employee
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-04
-- Description:	Справочник сотрудников. Выборка отделов сотрудника.
-- =============================================
CREATE PROCEDURE [dbo].[empl_sel_item_departmentlist]
	@Id_Employee INT
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    d.Id_Department,
    d.Name,
    ced.DateActive
  FROM
    CrossEmployeeDepartment ced
    JOIN Department d
      ON d.Id_Department = ced.Id_Department
  WHERE
    ced.Id_Employee = @Id_Employee
  ORDER BY
    ced.DateActive
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-05
-- Description:	Справочник сотрудников. Выборка номеров сотрудника.
-- =============================================
CREATE PROCEDURE [dbo].[empl_sel_item_numberlist]
	@Id_Employee INT
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    c.Id_Caller,
    c.Number,
    cne.DateActive
  FROM
    CrossCallerEmployee cne
    JOIN [Caller] c
      ON c.Id_Caller = cne.Id_Caller
  WHERE
    cne.Id_Employee = @Id_Employee
  ORDER BY
    cne.DateActive
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-04
-- Description:	Справочник сотрудников. Выборка сотрудников.
-- =============================================
CREATE PROCEDURE [dbo].[empl_sel_itemlist]
	@Id_User INT
AS
BEGIN
	
	SET NOCOUNT ON;

  DECLARE
  	@IsUserFilter BIT

  IF (SELECT COUNT(*) FROM CrossUserDepartment cud WHERE cud.Id_User = @Id_User) = 0
    SET @IsUserFilter = 0
  ELSE
  	SET @IsUserFilter = 1;

  SELECT
    e.Id_Employee,
    e.Name,
    ISNULL(d.Name, N'') AS DepartmentName,
    dbo.fn_get_numbers_on_period(e.Id_Employee, GETDATE(), GETDATE()) AS Number,
    ISNULL(e.BeginTime, d.BeginTime) AS BeginTime,
    ISNULL(e.EndTime, d.EndTime) AS EndTime,
    CAST(CASE
           WHEN rez.Id_ExternalEmployee IS NOT NULL THEN 1
           ELSE 0
         END AS BIT) AS IsExternalCode
  FROM
    Employee e
    LEFT JOIN Department d
      ON d.Id_Department = dbo.fn_get_employeedepartment_on_date(e.Id_Employee, GETDATE())
    OUTER APPLY (SELECT TOP 1
                   ee.Id_ExternalEmployee
                 FROM
                   ExternalEmployee ee
                 WHERE
                   ee.Id_Employee = e.Id_Employee) rez
  WHERE
    d.Id_Department IN (SELECT cud.Id_Department FROM CrossUserDepartment cud
                        WHERE cud.Id_User = @Id_User) OR (@IsUserFilter = 0)
  ORDER BY
    e.Name

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-08
-- Description:	Справочник сотрудников. Загрузка времени работы отделов.
-- =============================================
CREATE PROCEDURE [dbo].[empl_sel_timedepartment]
	@Id_Employee INT
AS
BEGIN
	
	SELECT
	  ISNULL(e.BeginTime, d.BeginTime) AS BeginTime,
	  ISNULL(e.EndTime, d.EndTime) AS EndTime
	FROM
	  Employee e
	  LEFT JOIN Department d
	    ON d.Id_Department = dbo.fn_get_employeedepartment_on_date(e.Id_Employee, GETDATE())
	WHERE
	  e.Id_Employee = @Id_Employee
	  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-04-01
-- Description:	Выборка звонков абонента для печати в Excel
-- =============================================
ALTER PROCEDURE [dbo].[excl_sel_calls]
  @Id_Employee INT,
  @BeginDate DATE,
  @EndDate DATE
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    cs.CallDateTime,
    cs.Duration,
    cs.Price,
    cs.Price * (ISNULL(c.Vat, 0) + 100) / 100.0 AS PriceVAT,
    cs.Number,
    COALESCE(ct.[Description], e_whom.Name) AS AbonentWhom,
    c.Id_Cost,
    c.Name AS CostName,
    cs.TypeCode,
    CASE
      WHEN ct.Id_Contact IS NOT NULL THEN 2
      WHEN e_whom.Id_Employee IS NOT NULL THEN 1
      ELSE 0
    END AS IsAbonent,
    CASE
      WHEN ct.Id_Contact IS NOT NULL THEN N'Клиенты'
      WHEN e_whom.Id_Employee IS NOT NULL THEN N'Сотрудники'
      ELSE N''
    END AS Reference
  FROM
    [Call] cs
    JOIN [Caller] cl
      ON cl.Id_Caller = cs.Id_Caller
    JOIN Cost c
      ON c.Id_Cost = cs.Id_Cost
    LEFT JOIN Employee e
      ON e.Id_Employee = dbo.fn_get_calleremployee_on_date(cl.Id_Caller, cs.CallDateTime)
    LEFT JOIN [Caller] c_whom
      ON c_whom.Number = RIGHT(cs.Number, 9)
    LEFT JOIN Employee e_whom
      ON e_whom.Id_Employee = dbo.fn_get_calleremployee_on_date(c_whom.Id_Caller, cs.CallDateTime)
    LEFT JOIN Contact ct
      ON ct.Number = RIGHT(cs.Number, 9)
  WHERE
    (e.Id_Employee = @Id_Employee OR (@Id_Employee = -1 AND e.Id_Employee IS NULL)) AND
    cs.CallDateTime >= @BeginDate AND cs.CallDateTime < DATEADD(d, 1, @EndDate)
  ORDER BY
    cs.CallDateTime    
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-04-01
-- Description:	Выборка звонков сгруппированых по абоненту и статье для печати в Excel.
-- =============================================
ALTER PROCEDURE [dbo].[excl_sel_costcallers]
	@Id_Employee INT,
	@BeginDate DATE,
	@EndDate DATE
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    cs.Id_Caller,
    cs.Id_Cost,
    c.Name,
    SUM(cs.Duration) AS Duration,
    SUM(cs.Price) AS Price,
    SUM(cs.Price) * (ISNULL(c.Vat, 0) + 100) / 100.0 AS PriceVat
  FROM
    [Call] cs
    JOIN Cost c
      ON c.Id_Cost = cs.Id_Cost
    JOIN [Caller] cl
      ON cl.Id_Caller = cs.Id_Caller
    LEFT JOIN Employee e
      ON e.Id_Employee = dbo.fn_get_calleremployee_on_date(cl.Id_Caller, cs.CallDateTime)
  WHERE
    (e.Id_Employee = @Id_Employee OR (@Id_Employee = -1 AND e.Id_Employee IS NULL)) AND
    cs.CallDateTime >= @BeginDate AND cs.CallDateTime < DATEADD(d, 1, @EndDate)
  GROUP BY
    cs.Id_Caller,
    cs.Id_Cost,
    c.Name,
    c.Vat
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-11
-- Description:	Удаление звонков
-- =============================================
CREATE PROCEDURE [dbo].[ldd_del_item]
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	BEGIN TRAN
  	
  	  ;WITH CTE AS (
  	  	            SELECT
  	  	              c.Id_Call
  	  	            FROM
  	  	              Period p
  	  	              JOIN [Call] c
  	  	                ON c.CallDateTime >= p.BeginDate AND c.CallDateTime < DATEADD(d, 1, p.EndDate)
  	  	              JOIN #tmpDelPeriod tmp
  	  	                ON tmp.Id_Period = p.Id_Period
  	               )
        DELETE FROM [Call]
        WHERE Id_Call IN (SELECT c.Id_Call FROM CTE c)
  	
  	  DELETE FROM Period
  	  WHERE Id_Period IN (SELECT tmp.Id_Period FROM #tmpDelPeriod tmp)
  	
  	COMMIT TRAN

    SELECT 1, N'Звонки удалены'
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-21
-- Description:	Удаление звонков
-- =============================================
CREATE PROCEDURE [dbo].[ldd_del_itemfromdate]
	@BeginDate DATE,
	@EndDate DATE
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	BEGIN TRAN
  	
  	DELETE FROM [Call]
  	WHERE CallDateTime >= @BeginDate AND CallDateTime < DATEADD(d, 1, @EndDate)
  	
  	DELETE FROM Period
  	WHERE BeginDate = @BeginDate AND EndDate = @EndDate
  	
  	SELECT 1, N'Звонки удалены'
  	
  	COMMIT TRAN
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
  	
  	THROW;
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-21
-- Description:	Загрузка звонков
-- =============================================
CREATE PROCEDURE [dbo].[ldd_ins_calls] 
AS
BEGIN

	SET NOCOUNT ON;

  BEGIN TRY
  	
  BEGIN TRAN

    INSERT INTO [Caller]
      (Number, Name, Abonent)
      SELECT
        tmp.Number,
        tmp.Name,
        N''
      FROM
        #tmpCaller tmp
        LEFT JOIN [Caller] c
          ON c.Number = tmp.Number
      WHERE
        c.Id_Caller IS NULL

    INSERT INTO Cost
      (Name, Vat)
      SELECT
        tmp.NameCost,
        NULL
      FROM
        #tmpCallerCost tmp
      WHERE
        tmp.NameCost NOT IN (SELECT c.Name FROM Cost c)

    DECLARE @CostInserted TABLE (Id_Caller INT, Id_Cost INT)

    INSERT INTO [Call]
      (Id_Caller, Id_Cost, CallDateTime, TypeCode, Duration, Number, Price)
      OUTPUT INSERTED.Id_Caller, INSERTED.Id_Cost INTO @CostInserted
      SELECT
        cl.Id_Caller,
        c.Id_Cost,
        tmp.CallDateTime,
        tmp.TypeCode,
        tmp.Duration,
        tmp.NumberCall,
        tmp.Price
      FROM
        #tmpCalls tmp
        JOIN [Caller] cl
          ON cl.Number = tmp.NumberCaller
        JOIN Cost c
          ON c.Name = tmp.NameCost

    DELETE FROM #tmpCallerCost
    WHERE EXISTS (SELECT TOP 1
                    *
                  FROM
                    @CostInserted tmp
                    JOIN [Caller] cl
                      ON cl.Id_Caller = tmp.Id_Caller
                    JOIN Cost c
                      ON c.Id_Cost = tmp.Id_Cost
                  WHERE
                    cl.Number = #tmpCallerCost.Number AND
                    c.Name = #tmpCallerCost.NameCost)

    INSERT INTO [Call]
      (Id_Caller, Id_Cost, CallDateTime, TypeCode, Duration, Number, Price)
      SELECT
        cl.Id_Caller,
        c.Id_Cost,
        tmp.CallDateTime,
        N'',
        0,
        N'',
        tmp.Price
      FROM
        #tmpCallerCost tmp
        JOIN [Caller] cl
          ON cl.Number = tmp.Number
        JOIN Cost c
          ON c.Name = tmp.NameCost

    COMMIT TRAN

    SELECT 1, N'Звонки импортированы'

  END TRY
  BEGIN CATCH
  
    ROLLBACK TRAN
    
    SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
    
    THROW;
    
  END CATCH

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-21
-- Description:	Добавить период
-- =============================================
CREATE PROCEDURE [dbo].[ldd_ins_period]
	@BeginDate DATE,
	@EndDate DATE,
	@Month SMALLINT,
	@Year SMALLINT
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	BEGIN TRAN
  	
  	INSERT INTO Period
  	  (BeginDate, EndDate, [Month], [Year])
  	VALUES
  	  (@BeginDate, @EndDate, @Month, @Year)
  	
  	COMMIT TRAN
  	
  	SELECT 1, N'Период добавлен'
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
  	
  	THROW;
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-21
-- Description:	Проверка данных в периоде
-- =============================================
CREATE PROCEDURE [dbo].[ldd_sel_callinperiod]
	@BeginDate DATE,
	@EndDate DATE
AS
BEGIN
	
	SET NOCOUNT ON;

  IF EXISTS(SELECT TOP 1 * FROM [Call] c
	          WHERE c.CallDateTime >= @BeginDate AND c.CallDateTime < DATEADD(d, 1, @EndDate))
    SELECT CAST(1 AS BIT) AS IsExists
  ELSE
  	SELECT CAST(0 AS BIT) AS IsExists
	
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-11
-- Description:	Выборка периодов
-- =============================================
CREATE PROCEDURE [dbo].[ldd_sel_periodlist]
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    p.Id_Period,
    p.BeginDate,
    p.EndDate,
    p.[Month],
    p.[Year]
  FROM
    Period p
  ORDER BY
    p.BeginDate
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-07
-- Description:	Выборка звонивших абонентов за период
-- =============================================
CREATE PROCEDURE [dbo].[rep_all_sel] 
	@Id_User INT,
	@BeginDate DATE,
	@EndDate DATE
AS
BEGIN
	
	SET NOCOUNT ON;

  DECLARE
  	@IsUserFilter BIT;
  
  /*
   * Определяем, будет ли использоваться фильтр по пользователю
   */
  IF (SELECT COUNT(*) FROM CrossUserDepartment cud WHERE cud.Id_User = @Id_User) = 0
    SET @IsUserFilter = 0
  ELSE
  	SET @IsUserFilter = 1;

  WITH DateList([Date]) AS (
  	                        /*
                             * 1) Создаем диапазон дат, заполняя каждый день датой
                             */
                            SELECT
                              @BeginDate
                            WHERE
                              @BeginDate < @EndDate
                            UNION ALL
                            SELECT
                              DATEADD(DAY, 1, d.[Date])
                            FROM
                              DateList d
                            WHERE
                              d.[Date] < @EndDate
                           ),
      ABN AS (
    	        /*
               * 2) Выборка абонентов на каждый день у какого номера был какой сотрудник в каком отделе
               */
    	        SELECT
    	          cl.Id_Caller,
    	          dl.[Date],
    	          e.Id_Employee,
    	          d.Id_Department
    	        FROM
    	          DateList dl
    	          CROSS JOIN [Caller] cl
    	          LEFT JOIN Employee e
    	            ON e.Id_Employee = dbo.fn_get_calleremployee_on_date(cl.Id_Caller, dl.[Date])
    	          LEFT JOIN Department d
    	            ON d.Id_Department = dbo.fn_get_employeedepartment_on_date(e.Id_Employee, dl.[Date])
    	       ),
      CTE AS (
      	        /*
  	             * 3) Выборка всех звонков за период с учетом(без) фильтра пользователя
  	             */
      	        SELECT
                  cl.Id_Caller,
                  cl.Number,
                  a.Id_Employee,
                  a.Id_Department,
                  ISNULL(e.Name, cl.Name) AS AbonentName,
                  ISNULL(d.Name, N'') AS DepartmentName,
                  cs.Id_Cost,
                  cs.Price,
                  CAST(cs.CallDateTime AS TIME) AS CallTime,
                  COALESCE(e.BeginTime, d.BeginTime, CAST('09:00' AS TIME)) AS BeginTime,
                  COALESCE(e.EndTime, d.EndTime, CAST('18:00' AS TIME)) AS EndTime,
                  CASE
                    WHEN e.Name IS NOT NULL THEN 1
                    ELSE 0
                  END AS IsAbonentExists
                FROM
                  [Call] cs
                  JOIN [Caller] cl
                    ON cl.Id_Caller = cs.Id_Caller
                  LEFT JOIN ABN a
                    JOIN Employee e
                      ON e.Id_Employee = a.Id_Employee
                    JOIN Department d
                      ON d.Id_Department = a.Id_Department
                    ON a.Id_Caller = cl.Id_Caller AND
                       a.[Date] = CAST(cs.CallDateTime AS DATE)
	              WHERE
	                (a.Id_Department IN (SELECT cud.Id_Department FROM CrossUserDepartment cud
	                                     WHERE cud.Id_User = @Id_User) OR (@IsUserFilter = 0)) AND
                  cs.CallDateTime >= @BeginDate AND cs.CallDateTime < DATEADD(d, 1, @EndDate)
             ),
       CTE2 AS (
       	        /*
       	         * 4) Группируем звонки по абонентам и суммируем стоимости.
       	         */
                SELECT
                  cs.Id_Caller,
                  cs.Id_Employee,
                  cs.Id_Department,
                  cs.Number,
                  cs.AbonentName,
                  cs.DepartmentName,
                  cs.IsAbonentExists,
                  SUM(cs.Price) AS Summa,
                  SUM(CASE
                        WHEN (cs.CallTime BETWEEN cs.BeginTime AND cs.EndTime) OR (cs.CallTime = '00:00:00') THEN cs.Price
                        ELSE 0
                      END) AS SummaWork,
                  SUM(CASE
                        WHEN (cs.CallTime BETWEEN cs.BeginTime AND cs.EndTime) OR (cs.CallTime = '00:00:00') THEN 0
                        ELSE cs.Price
                      END) AS SummaNoWork
                FROM
                  CTE cs
                GROUP BY
                  cs.Id_Employee,
                  cs.Id_Department,
                  cs.Id_Caller,
                  cs.Number,
                  cs.AbonentName,
                  cs.DepartmentName,
                  cs.IsAbonentExists
               ),
       CTE3 AS (
       	        /*
       	         * 5) Группируем звонки по абонентам + статьям и суммируем стоимость
       	         */
  	            SELECT
  	              cs.Id_Caller,
  	              cs.Id_Cost,
  	              cs.Id_Employee,
                  cs.Id_Department,
  	              SUM(cs.Price) AS SummaCost,
  	              ROW_NUMBER() OVER (PARTITION BY cs.Id_Caller, cs.Id_Employee, cs.Id_Department ORDER BY SUM(cs.Price) DESC) AS rown
  	            FROM
  	              CTE cs
  	            GROUP BY
  	              cs.Id_Caller,
  	              cs.Id_Cost,
  	              cs.Id_Employee,
                  cs.Id_Department
               )
  /*
   * 6) Объединяем звонки по абонентам, где расчитали стоимость в разрезе абонента и стоимость в разрезе статья/абонент, при том выбираем в статье/абонент
   * только максимальную стоимость (рассчитали ранее)
   */
  SELECT
    cs2.Id_Caller,
    cs2.Number,
    cs2.AbonentName,
    cs2.DepartmentName,
    cs2.Summa * (ISNULL(c.Vat, 0) + 100) / 100.0 AS Summa,
    cs2.SummaWork * (ISNULL(c.Vat, 0) + 100) / 100.0 AS SummaWork,
    cs2.SummaNoWork * (ISNULL(c.Vat, 0) + 100) / 100.0 AS SummaNoWork,
    cs3.SummaCost * (ISNULL(c.Vat, 0) + 100) / 100.0 AS SummaCost,
    c.Name AS TopCost,
    cs2.IsAbonentExists,
    ISNULL(cs2.Id_Employee, -1) AS Id_Employee,
    ISNULL(cs2.Id_Department, -1) AS Id_Department
  FROM
    CTE2 cs2
    LEFT JOIN CTE3 cs3
      ON cs2.Id_Caller = cs3.Id_Caller AND
         (cs2.Id_Employee = cs3.Id_Employee OR cs3.Id_Employee IS NULL AND cs2.Id_Employee IS NULL) AND
         (cs2.Id_Department = cs3.Id_Department OR cs3.Id_Department IS NULL AND cs2.Id_Department IS NULL) AND
         cs3.rown = 1
    LEFT JOIN Cost c
      ON c.Id_Cost = cs3.Id_Cost
  ORDER BY
    cs2.Id_Caller
  OPTION (OPTIMIZE FOR UNKNOWN)

END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rep_all_sel_costcaller]
	@Id_Caller INT,
	@Id_Employee INT,
	@Id_Department INT,
	@BeginDate DATE,
	@EndDate DATE
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    c.Name,
    SUM(cs.Duration) AS Duration,
    SUM(cs.Price) * (ISNULL(c.Vat, 0) + 100) / 100.0 AS [Sum]
  FROM
    [Call] cs
    JOIN Cost c
      ON cs.Id_Cost = c.Id_Cost
    JOIN [Caller] cl
      ON cl.Id_Caller = cs.Id_Caller
    LEFT JOIN Employee e
      ON e.Id_Employee = dbo.fn_get_calleremployee_on_date(cl.Id_Caller, cs.CallDateTime)
    LEFT JOIN Department d
      ON d.Id_Department = dbo.fn_get_employeedepartment_on_date(e.Id_Employee, cs.CallDateTime)
  WHERE
    cl.Id_Caller = @Id_Caller AND
    (e.Id_Employee = @Id_Employee OR (@Id_Employee = -1 AND e.Id_Employee IS NULL)) AND
    (d.Id_Department = @Id_Department OR (@Id_Department = -1 AND d.Id_Department IS NULL)) AND
    cs.CallDateTime >= @BeginDate AND cs.CallDateTime < DATEADD(d, 1, @EndDate)
  GROUP BY
    c.Id_Cost,
    c.Name,
    c.Vat
  HAVING
    SUM(cs.Price) <> 0
  
END
GO

-- =============================================
-- Author: Матусевич Александр
-- Create date: 2014-08-08
-- Description:	Выборка периода
-- =============================================
CREATE PROCEDURE [dbo].[rep_all_sel_period]
	@Id_Period INT
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    p.BeginDate,
    p.EndDate
  FROM
    Period p
  WHERE
    p.Id_Period = @Id_Period
    
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-08
-- Description:	Выборка периодов
-- =============================================
CREATE PROCEDURE [dbo].[rep_all_sel_periods]
AS
BEGIN
	
	SELECT
	  p.Id_Period,
	  p.BeginDate,
	  p.EndDate,
	  p.[Month],
	  p.[Year]
	FROM
	  Period p
	ORDER BY
	  p.BeginDate
	
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-08
-- Description:	Выборка сотрудников звонивших за период
-- =============================================
CREATE PROCEDURE [dbo].[rep_empl_sel]
  @Id_User INT,
	@BeginDate DATE,
	@EndDate DATE
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE
  	@IsUserFilter BIT;
  
  /*
   * Определяем, будет ли использоваться фильтр по пользователю
   */
  IF (SELECT COUNT(*) FROM CrossUserDepartment cud WHERE cud.Id_User = @Id_User) = 0
    SET @IsUserFilter = 0
  ELSE
  	SET @IsUserFilter = 1

  SET @EndDate = DATEADD(d, 1, @EndDate);

  WITH CTE AS (
      	        /*
  	             * 1) Выборка всех звонков за период с учетом(без) фильтра пользователя
  	             */
      	        SELECT
                  ISNULL(e.Id_Employee, -1) AS Id_Employee,
                  ISNULL(e.Name, N'') AS Name,
                  ISNULL(d.Name, N'') AS DepartmentName,
                  cs.Id_Cost,
                  cs.Price,
                  CAST(cs.CallDateTime AS TIME) AS CallTime,
                  COALESCE(e.BeginTime, d.BeginTime, CAST('09:00' AS TIME)) AS BeginTime,
                  COALESCE(e.EndTime, d.EndTime, CAST('18:00' AS TIME)) AS EndTime
                FROM
                  [Call] cs
                  JOIN [Caller] cl
                    ON cl.Id_Caller = cs.Id_Caller
                  LEFT JOIN Employee e
                    ON e.Id_Employee = dbo.fn_get_calleremployee_on_date(cl.Id_Caller, cs.CallDateTime)
                  LEFT JOIN Department d
                    ON d.Id_Department = dbo.fn_get_employeedepartment_on_date(e.Id_Employee, @EndDate)
	              WHERE
	                (d.Id_Department IN (SELECT cud.Id_Department FROM CrossUserDepartment cud
	                                     WHERE cud.Id_User = @Id_User) OR (@IsUserFilter = 0)) AND
                  cs.CallDateTime >= @BeginDate AND cs.CallDateTime < @EndDate
             ),
       CTE2 AS (
       	        /*
       	         * 2) Группируем звонки по абонентам и суммируем стоимости.
       	         */
                SELECT
                  cs.Id_Employee,
                  cs.Name,
                  cs.DepartmentName,
                  SUM(cs.Price) AS Summa,
                  SUM(CASE
                        WHEN (cs.CallTime BETWEEN cs.BeginTime AND cs.EndTime) OR (cs.CallTime = '00:00:00') THEN cs.Price
                        ELSE 0
                      END) AS SummaWork,
                  SUM(CASE
                        WHEN (cs.CallTime BETWEEN cs.BeginTime AND cs.EndTime) OR (cs.CallTime = '00:00:00') THEN 0
                        ELSE cs.Price
                      END) AS SummaNoWork
                FROM
                  CTE cs
                GROUP BY
                  cs.Id_Employee,
                  cs.Name,
                  cs.DepartmentName
               ),
       CTE3 AS (
       	        /*
       	         * 3) Группируем звонки по абонентам + статьям и суммируем стоимость
       	         */
  	            SELECT
  	              cs.Id_Employee,
  	              cs.Id_Cost,
  	              SUM(cs.Price) AS SummaCost,
  	              ROW_NUMBER() OVER (PARTITION BY cs.Id_Employee ORDER BY SUM(cs.Price) DESC) AS rown
  	            FROM
  	              CTE cs
  	            GROUP BY
  	              cs.Id_Employee,
  	              cs.Id_Cost
               )
  /*
   * 4) Объединяем звонки по абонентам, где расчитали стоимость в разрезе абонента и стоимость в разрезе статья/абонент, при том выбираем в статье/абонент
   * только максимальную стоимость (рассчитали ранее)
   */
  SELECT
    cs2.Id_Employee,
    cs2.Name AS EmployeeName,
    dbo.fn_get_numbers_on_period(cs2.Id_Employee, @BeginDate, @EndDate) AS Numbers,
    cs2.DepartmentName,
    cs2.Summa * (ISNULL(c.Vat, 0) + 100) / 100.0 AS Summa,
    cs2.SummaWork * (ISNULL(c.Vat, 0) + 100) / 100.0 AS SummaWork,
    cs2.SummaNoWork * (ISNULL(c.Vat, 0) + 100) / 100.0 AS SummaNoWork,
    cs3.SummaCost * (ISNULL(c.Vat, 0) + 100) / 100.0 AS SummaCost,
    c.Name AS CostName
  FROM
    CTE2 cs2
    JOIN CTE3 cs3
      ON cs2.Id_Employee = cs3.Id_Employee
    JOIN Cost c
      ON c.Id_Cost = cs3.Id_Cost
  WHERE
    cs3.rown = 1
  ORDER BY
    cs2.Id_Employee
  OPTION (OPTIMIZE FOR UNKNOWN)
  
END
GO

-- =============================================
-- Author: Матусевич Александр
-- Create date: 2014-08-08
-- Description:	Выборка сумм по статьям сотрудника за период
-- =============================================
CREATE PROCEDURE [dbo].[rep_empl_sel_costscaller]
	@Id_Employee INT,
	@BeginDate DATE,
	@EndDate DATE
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    c.Name,
    SUM(cs.Duration) AS [Len],
    SUM(cs.Price) * (ISNULL(c.Vat, 0) + 100) / 100.0 AS [Sum]
  FROM
    [Call] cs
    JOIN Cost c
      ON cs.Id_Cost = c.Id_Cost
    JOIN [Caller] cl
      ON cl.Id_Caller = cs.Id_Caller
    LEFT JOIN Employee e
      ON e.Id_Employee = dbo.fn_get_calleremployee_on_date(cl.Id_Caller, cs.CallDateTime)
  WHERE
    (e.Id_Employee = @Id_Employee OR (@Id_Employee = -1 AND e.Id_Employee IS NULL)) AND
    cs.CallDateTime >= @BeginDate AND cs.CallDateTime < DATEADD(d, 1, @EndDate)
  GROUP BY
    c.Id_Cost,
    c.Name,
    c.Vat
  HAVING
    SUM(cs.Price) <> 0

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-08
-- Description:	Выборка детализации по сотрудникам за период
-- =============================================
CREATE PROCEDURE [dbo].[rep_empl_sel_detail]
	@Id_Employee INT,
  @BeginDate DATE,
  @EndDate DATE,
  @IsWorkTime INT
AS
BEGIN

  SET NOCOUNT ON;

  WITH CTE AS (
                SELECT
                  cl.Number AS EmployeeNumber,
                  cs.CallDateTime,
                  cs.Duration,
                  cs.Price,
                  cs.Price * (ISNULL(c.Vat, 0) + 100) / 100.0 AS PriceVat,
                  cs.Number,
                  COALESCE(ct.[Description], e_whom.Name) AS AbonentWhom,
                  c.Id_Cost,
                  c.Name AS CostName,
                  cs.TypeCode,
                  CASE
                    WHEN CAST(cs.CallDateTime AS TIME) BETWEEN COALESCE(e.BeginTime, d.BeginTime) AND COALESCE(e.EndTime, d.EndTime) OR (CAST(cs.CallDateTime AS TIME) = N'00:00:00') THEN 1
                    ELSE 2
                  END AS IsWorkTime,
                  CASE
                    WHEN ct.Id_Contact IS NOT NULL THEN 2
                    WHEN e_whom.Id_Employee IS NOT NULL THEN 1
                    ELSE 0
                  END AS IsAbonent,
                  CASE
                    WHEN ct.Id_Contact IS NOT NULL THEN N'Клиенты'
                    WHEN e_whom.Id_Employee IS NOT NULL THEN N'Сотрудники'
                    ELSE N''
                  END AS Reference
                FROM
                  [Call] cs
                  JOIN [Caller] cl
                    ON cl.Id_Caller = cs.Id_Caller
                  JOIN Cost c
                    ON c.Id_Cost = cs.Id_Cost
                  LEFT JOIN Employee e
                    ON e.Id_Employee = dbo.fn_get_calleremployee_on_date(cl.Id_Caller, cs.CallDateTime)
                  LEFT JOIN Department d
                    ON d.Id_Department = dbo.fn_get_employeedepartment_on_date(e.Id_Employee, cs.CallDateTime)
                  LEFT JOIN [Caller] c_whom
                    ON c_whom.Number = RIGHT(cs.Number, 9)
                  LEFT JOIN Employee e_whom
                    ON e_whom.Id_Employee = dbo.fn_get_calleremployee_on_date(c_whom.Id_Caller, cs.CallDateTime)
                  LEFT JOIN Contact ct
                    ON ct.Number = RIGHT(cs.Number, 9)
                WHERE
                  (e.Id_Employee = @Id_Employee OR (@Id_Employee = -1 AND e.Id_Employee IS NULL)) AND
                  cs.CallDateTime >= @BeginDate AND cs.CallDateTime < DATEADD(d, 1, @EndDate))
    SELECT
      c.EmployeeNumber,
      c.CallDateTime,
      c.Duration,
      c.Price,
      c.PriceVat,
      c.Number,
      c.AbonentWhom,
      c.Id_Cost,
      c.CostName,
      c.TypeCode,
      c.IsAbonent,
      c.Reference,
      c.IsWorkTime
    FROM
      CTE c
    WHERE
      c.IsWorkTime = @IsWorkTime OR @IsWorkTime = 0
    ORDER BY
      c.CallDateTime

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-08
-- Description:	Выборка отделов для отправки писем
-- =============================================
CREATE PROCEDURE [dbo].[rep_empl_sel_maildepartment]
  @Id_User INT,
  @BeginDate DATE,
  @EndDate DATE
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE
  	@IsUserFilter BIT

  IF (SELECT COUNT(*) FROM CrossUserDepartment cud WHERE cud.Id_User = @Id_User) = 0
    SET @IsUserFilter = 0
  ELSE
  	SET @IsUserFilter = 1;


  SELECT DISTINCT
    d.Name,
    d.EMail
  FROM
    [Call] cs
    JOIN [Caller] cl
      ON cl.Id_Caller = cs.Id_Caller
    JOIN Employee e
      ON e.Id_Employee = dbo.fn_get_calleremployee_on_date(cl.Id_Caller, cs.CallDateTime)
    JOIN Department d
      ON d.Id_Department = dbo.fn_get_employeedepartment_on_date(e.Id_Employee, cs.CallDateTime)
  WHERE
    d.EMail IS NOT NULL AND
	  (d.Id_Department IN (SELECT cud.Id_Department FROM CrossUserDepartment cud
	                        WHERE cud.Id_User = @Id_User) OR (@IsUserFilter = 0)) AND
    cs.CallDateTime >= @BeginDate AND cs.CallDateTime < DATEADD(d, 1, @EndDate)

END
GO

-- =============================================
-- Author: Матусевич Александр
-- Create date: 2014-08-08
-- Description:	Выборка периода
-- =============================================
CREATE PROCEDURE [dbo].[rep_empl_sel_period]
	@Id_Period INT
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    p.BeginDate,
    p.EndDate
  FROM
    Period p
  WHERE
    p.Id_Period = @Id_Period
    
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-08
-- Description:	Выборка периодов
-- =============================================
CREATE PROCEDURE [dbo].[rep_empl_sel_periods]
AS
BEGIN
	
	SELECT
	  p.Id_Period,
	  p.BeginDate,
	  p.EndDate,
	  p.[Month],
	  p.[Year]
	FROM
	  Period p
	ORDER BY
	  p.BeginDate
	
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-06
-- Description:	Выборка номеров звонивших за период
-- =============================================
CREATE PROCEDURE [dbo].[rep_numb_sel]
	@Id_User INT,
	@BeginDate DATE,
	@EndDate DATE
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE
  	@IsUserFilter BIT;
  
  /*
   * Определяем, будет ли использоваться фильтр по пользователю
   */
  IF (SELECT COUNT(*) FROM CrossUserDepartment cud WHERE cud.Id_User = @Id_User) = 0
    SET @IsUserFilter = 0
  ELSE
  	SET @IsUserFilter = 1;

  WITH ABN AS (
    	        /*
               * 1) Выборка сотрудников на конец периода
               */
    	        SELECT
    	          cne.Id_Employee,
    	          cne.Id_Caller,
    	          dbo.fn_get_employeedepartment_on_date(cne.Id_Employee, @EndDate) AS Id_Department,
    	          ROW_NUMBER() OVER (PARTITION BY cne.Id_Caller ORDER BY cne.DateActive DESC) AS rown
    	        FROM
    	          CrossCallerEmployee cne
    	        WHERE
    	          cne.DateActive < DATEADD(d, 1, @EndDate)
    	       ),
      CTE AS (
      	        /*
  	             * 2) Выборка всех звонков за период с учетом(без) фильтра пользователя
  	             */
      	        SELECT
                  cl.Id_Caller,
                  cl.Number,
                  ISNULL(d.Name, N'') AS DepartmentName,
                  cs.Id_Cost,
                  cs.Price,
                  CAST(cs.CallDateTime AS TIME) AS CallTime,
                  COALESCE(e.BeginTime, d.BeginTime, CAST('09:00' AS TIME)) AS BeginTime,
                  COALESCE(e.EndTime, d.EndTime, CAST('18:00' AS TIME)) AS EndTime,
                  CASE
                    WHEN a.Id_Employee IS NOT NULL THEN 1
                    ELSE 0
                  END AS IsAbonentExists
                FROM
                  [Call] cs
                  JOIN [Caller] cl
                    ON cl.Id_Caller = cs.Id_Caller
                  LEFT JOIN ABN a
                    JOIN Employee e
                      ON e.Id_Employee = a.Id_Employee
                    JOIN Department d
                      ON d.Id_Department = a.Id_Department
                    ON a.Id_Caller = cl.Id_Caller AND
                       a.rown = 1
	              WHERE
	                (d.Id_Department IN (SELECT cud.Id_Department FROM CrossUserDepartment cud
	                                     WHERE cud.Id_User = @Id_User) OR (@IsUserFilter = 0)) AND
                  cs.CallDateTime >= @BeginDate AND cs.CallDateTime < DATEADD(d, 1, @EndDate)
             ),
       CTE2 AS (
       	        /*
       	         * 3) Группируем звонки по абонентам и суммируем стоимости.
       	         */
                SELECT
                  cs.Id_Caller,
                  cs.Number,
                  cs.DepartmentName,
                  cs.IsAbonentExists,
                  SUM(cs.Price) AS Summa,
                  SUM(CASE
                        WHEN (cs.CallTime BETWEEN cs.BeginTime AND cs.EndTime) OR (cs.CallTime = '00:00:00') THEN cs.Price
                        ELSE 0
                      END) AS SummaWork,
                  SUM(CASE
                        WHEN (cs.CallTime BETWEEN cs.BeginTime AND cs.EndTime) OR (cs.CallTime = '00:00:00') THEN 0
                        ELSE cs.Price
                      END) AS SummaNoWork
                FROM
                  CTE cs
                GROUP BY
                  cs.Id_Caller,
                  cs.Number,
                  cs.DepartmentName,
                  cs.IsAbonentExists
               ),
       CTE3 AS (
       	        /*
       	         * 4) Группируем звонки по абонентам + статьям и суммируем стоимость
       	         */
  	            SELECT
  	              cs.Id_Caller,
  	              cs.Id_Cost,
  	              SUM(cs.Price) AS SummaCost,
  	              ROW_NUMBER() OVER (PARTITION BY cs.Id_Caller ORDER BY SUM(cs.Price) DESC) AS rown
  	            FROM
  	              CTE cs
  	            GROUP BY
  	              cs.Id_Caller,
  	              cs.Id_Cost
               )
  /*
   * 5) Объединяем звонки по абонентам, где расчитали стоимость в разрезе абонента и стоимость в разрезе статья/абонент, при том выбираем в статье/абонент
   * только максимальную стоимость (рассчитали ранее)
   */
  SELECT
    cs2.Id_Caller,
    cs2.Number,
    dbo.fn_get_employeesname_on_period(cs2.Id_Caller, @BeginDate, @EndDate) AS AbonentName,
    cs2.DepartmentName,
    cs2.Summa * (ISNULL(c.Vat, 0) + 100) / 100.0 AS Summa,
    cs2.SummaWork * (ISNULL(c.Vat, 0) + 100) / 100.0 AS SummaWork,
    cs2.SummaNoWork * (ISNULL(c.Vat, 0) + 100) / 100.0 AS SummaNoWork,
    cs3.SummaCost * (ISNULL(c.Vat, 0) + 100) / 100.0 AS SummaCost,
    c.Name AS CostName,
    cs2.IsAbonentExists
  FROM
    CTE2 cs2
    JOIN CTE3 cs3
      ON cs2.Id_Caller = cs3.Id_Caller
    JOIN Cost c
      ON c.Id_Cost = cs3.Id_Cost
  WHERE
    cs3.rown = 1
  ORDER BY
    cs2.Id_Caller
  OPTION (OPTIMIZE FOR UNKNOWN)

END
GO

-- =============================================
-- Author: Матусевич Александр
-- Create date: 2014-03-31
-- Description:	Выборка сумм по статьям номера за период
-- =============================================
CREATE PROCEDURE [dbo].[rep_numb_sel_costscaller]
	@Id_Caller INT,
	@BeginDate DATE,
	@EndDate DATE
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    c.Name,
    SUM(cs.Duration) AS Duration,
    SUM(cs.Price) * (ISNULL(c.Vat, 0) + 100) / 100.0 AS [Sum]
  FROM
    [Call] cs
    JOIN Cost c
      ON cs.Id_Cost = c.Id_Cost
  WHERE
    cs.Id_Caller = @Id_Caller AND
    cs.CallDateTime >= @BeginDate AND cs.CallDateTime < DATEADD(d, 1, @EndDate)
  GROUP BY
    c.Id_Cost,
    c.Name,
    c.Vat
  HAVING
    SUM(cs.Price) <> 0

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-07
-- Description:	Выборка детализации по номерам за период
-- =============================================
CREATE PROCEDURE [dbo].[rep_numb_sel_detail]
	@Id_Caller INT,
  @BeginDate DATE,
  @EndDate DATE,
  @IsWorkTime INT
AS
BEGIN

  SET NOCOUNT ON;

  WITH CTE AS (
                SELECT
                  e_who.Name AS EmployeeName,
                  cs.CallDateTime,
                  cs.Duration,
                  cs.Price,
                  cs.Price * (ISNULL(c.Vat, 0) + 100) / 100.0 AS PriceVat,
                  cs.Number,
                  COALESCE(ct.[Description], e_whom.Name) AS AbonentWhom,
                  c.Id_Cost,
                  c.Name AS CostName,
                  cs.TypeCode,
                  CASE
                    WHEN CAST(cs.CallDateTime AS TIME) BETWEEN COALESCE(e_who.BeginTime, d.BeginTime) AND COALESCE(e_who.EndTime, d.EndTime) OR (CAST(cs.CallDateTime AS TIME) = N'00:00:00') THEN 1
                    ELSE 2
                  END AS IsWorkTime,
                  CASE
                    WHEN ct.Id_Contact IS NOT NULL THEN 2
                    WHEN e_whom.Id_Employee IS NOT NULL THEN 1
                    ELSE 0
                  END AS IsAbonent,
                  CASE
                    WHEN ct.Id_Contact IS NOT NULL THEN N'Клиенты'
                    WHEN e_whom.Id_Employee IS NOT NULL THEN N'Сотрудники'
                    ELSE N''
                  END AS Reference
                FROM
                  [Call] cs
                  JOIN [Caller] cl
                    ON cl.Id_Caller = cs.Id_Caller
                  JOIN Cost c
                    ON c.Id_Cost = cs.Id_Cost
                  LEFT JOIN Employee e_who
                    ON e_who.Id_Employee = dbo.fn_get_calleremployee_on_date(cl.Id_Caller, cs.CallDateTime)
                  LEFT JOIN Department d
                    ON d.Id_Department = dbo.fn_get_employeedepartment_on_date(e_who.Id_Employee, cs.CallDateTime)
                  LEFT JOIN [Caller] c_whom
                    ON c_whom.Number = RIGHT(cs.Number, 9)
                  LEFT JOIN Employee e_whom
                      ON e_whom.Id_Employee = dbo.fn_get_calleremployee_on_date(c_whom.Id_Caller, cs.CallDateTime)
                  LEFT JOIN Contact ct
                    ON ct.Number = RIGHT(cs.Number, 9)
                WHERE
                  cs.Id_Caller = @Id_Caller AND
                  cs.CallDateTime >= @BeginDate AND cs.CallDateTime < DATEADD(d, 1, @EndDate))
    SELECT
      c.EmployeeName,
      c.CallDateTime,
      c.Duration,
      c.Price,
      c.PriceVat,
      c.Number,
      c.AbonentWhom,
      c.Id_Cost,
      c.CostName,
      c.TypeCode,
      c.IsAbonent,
      c.Reference,
      c.IsWorkTime
    FROM
      CTE c
    WHERE
      c.IsWorkTime = @IsWorkTime OR @IsWorkTime = 0
    ORDER BY
      c.CallDateTime

END
GO

-- =============================================
-- Author: Матусевич Александр
-- Create date: 2014-08-08
-- Description:	Выборка периода
-- =============================================
CREATE PROCEDURE [dbo].[rep_numb_sel_period]
	@Id_Period INT
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    p.BeginDate,
    p.EndDate
  FROM
    Period p
  WHERE
    p.Id_Period = @Id_Period
    
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-06
-- Description:	Выборка периодов
-- =============================================
CREATE PROCEDURE [dbo].[rep_numb_sel_periods]
AS
BEGIN
	
	SELECT
	  p.Id_Period,
	  p.BeginDate,
	  p.EndDate,
	  p.[Month],
	  p.[Year]
	FROM
	  Period p
	ORDER BY
	  p.BeginDate
	
END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rep_numbhist_sel]
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    c.Number,
    e.Name,
    cne.DateActive AS BeginDate,
    MAX(DATEADD(d, -1, cne.DateActive)) OVER (PARTITION BY c.Number ORDER BY cne.DateActive ROWS BETWEEN 1 following AND 1 following) AS EndDate
  FROM
    CrossCallerEmployee cne
    JOIN Employee e
      ON e.Id_Employee = cne.Id_Employee
    JOIN [Caller] c
      ON c.Id_Caller = cne.Id_Caller
  ORDER BY
    c.Number,
    cne.DateActive

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-05
-- Description:	Табель сотрудников. Изменение.
-- =============================================
CREATE PROCEDURE [dbo].[tbs_edt_item]
	@Id_Employee INT,
	@Date DATE,
	@Type NVARCHAR(5)
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
  	BEGIN TRAN
  	
  	SET @Type = RTRIM(LTRIM(@Type))
  	
  	IF @Type = N''
  	BEGIN
  		
  		DELETE FROM TableSheet
  		WHERE Id_Employee = @Id_Employee AND
  		      [Date] = @Date
  		      
  	END
  	ELSE
  	BEGIN
  		
  		IF NOT EXISTS(SELECT * FROM TableSheet ts
  		              WHERE ts.Id_Employee = @Id_Employee AND
  		                    ts.[Date] = @Date)
      BEGIN
      	
      	INSERT INTO TableSheet
      	  (Id_Employee, [Date], [Type])
      	VALUES
      	  (@Id_Employee, @Date, @Type)
      	
      END
      ELSE
      BEGIN
      	
      	UPDATE TableSheet
      	SET [Type] = @Type
      	WHERE Id_Employee = @Id_Employee AND
      	      [Date] = @Date
      	
      END
      
  	END
  	
  	COMMIT TRAN
  	
  	SELECT 1, N''
  	
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-05
-- Description:	Табель сотрудников
-- =============================================
CREATE PROCEDURE [dbo].[tbs_sel_itemlist]
	@Id_User INT,
	@BeginDate DATE,
	@EndDate DATE
AS
BEGIN
	
	SET NOCOUNT ON;

  DECLARE
  	@IsUserFilter BIT,
  	@SQL NVARCHAR(MAX),
	  @PivotList NVARCHAR(MAX) = N''
	
	IF (SELECT COUNT(*) FROM CrossUserDepartment cud WHERE cud.Id_User = @Id_User) = 0
    SET @IsUserFilter = 0
  ELSE
  	SET @IsUserFilter = 1;

  WITH DateList([Date]) AS
    (
      SELECT
        @BeginDate
      WHERE
        @BeginDate <= @EndDate
      UNION ALL
      SELECT
        DATEADD(DAY, 1, d.[Date])
      FROM
        DateList d
      WHERE
        d.[Date] < @EndDate
    )
  SELECT
    @PivotList = @PivotList + N'[' + CONVERT(NVARCHAR, d.[Date], 102) + N'], '
  FROM
    DateList d
  ORDER BY
    d.[Date]
  OPTION (MAXRECURSION 0)

  IF @PivotList <> N''
    SET @PivotList = LEFT(@PivotList, LEN(@PivotList) - 1)
  ELSE
  	SET @PivotList = N'[' + CONVERT(NVARCHAR, GETDATE(), 102) + N']'
  
  SET @SQL =
  N'SELECT
     pvt.*     
   FROM
     (SELECT
       e.Id_Employee,
       e.Name AS EmployeeName,
       ts.Date,
       ts.[Type]
      FROM
        Employee e
        LEFT JOIN Department d
          ON d.Id_Department = dbo.fn_get_employeedepartment_on_date(e.Id_Employee, GETDATE())
        LEFT JOIN TableSheet ts
          ON ts.Id_Employee = e.Id_Employee
      WHERE
        d.Id_Department IN (SELECT cud.Id_Department FROM CrossUserDepartment cud
                            WHERE cud.Id_User = ' + CAST(@Id_User AS NVARCHAR(MAX)) + N') OR (' + CAST(@IsUserFilter AS NVARCHAR(MAX)) + N' = 0)
     ) rez
   PIVOT (
	   MAX(rez.[Type]) FOR rez.Date IN (' + @PivotList + N')
   ) pvt
   ORDER BY
     pvt.EmployeeName'
  
  EXEC (@SQL)
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-11
-- Description:	Редактирование прав пользователей
-- =============================================
CREATE PROCEDURE [dbo].[usr_edt_item]
  @Id_User INT,
	@Field NVARCHAR(128),
	@Value BIT
AS
BEGIN
	
	SET NOCOUNT ON;

  DECLARE
  	@SQL NVARCHAR(MAX)

  BEGIN TRY
  	
  	BEGIN TRAN
  	
    SET @SQL =
    N'UPDATE [User]
      SET ' + @Field + N' = ' + CAST(@Value AS NVARCHAR(MAX)) + N'
      WHERE Id_User = ' + CAST(@Id_User AS NVARCHAR(MAX))
    
    EXEC (@SQL)
  
    SELECT 1, N''
  
    COMMIT TRAN
  
  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-11
-- Description:	Загрузка списка пользователей
-- =============================================
CREATE PROCEDURE [dbo].[usr_sel_itemlist]
AS
BEGIN

	SET NOCOUNT ON;

  SELECT
    u.Id_User,
    u.Name,
    u.CanLogin,
    u.CanUser,
    u.CanWrite,
    u.CanAdmin
  FROM
    [User] u
  ORDER BY
    u.Name

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-03-31
-- Description:	Изменить привязку Пользователь/Отдел
-- =============================================
CREATE PROCEDURE [dbo].[usrdep_edt_userdepartment]
	@Id_User INT,
	@Id_Department INT,
	@Value BIT
AS
BEGIN
	
	SET NOCOUNT ON;

  BEGIN TRY
  	
    IF @Value = 0
   	  DELETE FROM CrossUserDepartment
   	  WHERE Id_User = @Id_User AND Id_Department = @Id_Department
    ELSE
      IF NOT EXISTS (SELECT * FROM CrossUserDepartment cud
                     WHERE cud.Id_User = @Id_User AND cud.Id_Department = @Id_Department)
        INSERT INTO CrossUserDepartment
          (Id_User, Id_Department)
        VALUES
          (@Id_User, @Id_Department)
  
    SELECT 0, ''
  
  END TRY
  BEGIN CATCH
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE()
  	
  END CATCH
  
END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-03-31
-- Description:	Загрузка связки Пользователь/Отдел
-- =============================================
CREATE PROCEDURE [dbo].[usrdep_sel_userdepartment]
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE
	  @SQL NVARCHAR(MAX),
	  @PivotList NVARCHAR(MAX)
	
  SET @PivotList = N''

  SELECT
    @PivotList = @PivotList + N'[' + CAST(d.Id_Department AS NVARCHAR(MAX)) + N' - ' + d.Name + N'], '
  FROM
    Department d
  ORDER BY
    d.Name
  
    SET @PivotList = LEFT(@PivotList, LEN(@PivotList) - 1)
  
  SET @SQL = 
  N'SELECT * FROM
      (SELECT u.Id_User, u.Name AS UserName, CAST(d.Id_Department AS NVARCHAR(MAX)) + '' - '' + d.Name AS DepartmentName, cud.Id_Department FROM [User] u
       CROSS JOIN Department d
       LEFT JOIN CrossUserDepartment cud
         ON cud.Id_User = u.Id_User AND
            cud.Id_Department = d.Id_Department
        ) rez
    PIVOT(
	    COUNT(Id_Department) FOR DepartmentName IN (' + @PivotList + N')
    ) pvt
    ORDER BY
      pvt.UserName'
    
  EXEC (@SQL)

END
GO

CREATE PROCEDURE [dbo].[Поиск текста в хранимых процедурах]
	@TextSearch NVARCHAR(MAX)
AS
BEGIN
	
	SET NOCOUNT ON;

  SET @TextSearch = '%' + @TextSearch + '%'
  
  SELECT
    SCHEMA_NAME(ao.schema_id) AS SchemaName,
    ao.name
  FROM
    sys.all_sql_modules asm
    JOIN sys.all_objects ao
      ON ao.[object_id] = asm.[object_id]
  WHERE
    CASE
      WHEN ao.is_ms_shipped = 1 THEN 1
      WHEN (SELECT
              ep.major_id
            FROM
              sys.extended_properties ep
            WHERE
              ep.class = 1 AND
              ep.minor_id = 0 AND
              ep.name = N'microsoft_database_tools_support' AND
              ep.major_id = ao.[object_id]) IS NOT NULL THEN 1
      ELSE 0
    END = 0 AND
    asm.definition LIKE @TextSearch
  ORDER BY
    ao.name
  
END
GO

DROP PROCEDURE abn_sel_calls
DROP PROCEDURE call_sel_callers
DROP PROCEDURE call_sel_callers_new
DROP PROCEDURE call_sel_callers_test
DROP PROCEDURE call_sel_costscaller
DROP PROCEDURE call_sel_isnds
DROP PROCEDURE call_sel_maildepartment
DROP PROCEDURE call_sel_period
DROP PROCEDURE opt_del_phone
DROP PROCEDURE opt_ins_phone
DROP PROCEDURE opt_sel_costs
DROP PROCEDURE opt_sel_department
DROP PROCEDURE opt_sel_phone
DROP PROCEDURE opt_sel_usersdepartment
DROP PROCEDURE opt_upd_costnds
DROP PROCEDURE opt_upd_departmentemail
DROP PROCEDURE opt_upd_userdepartment
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-01
-- Description:	Импорт сотрудников из внешних источников
-- =============================================
CREATE PROCEDURE [dbo].[job_import_employee]
  @Id_ExternalSystem INT
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE
  	@Id_ImportEmployee INT,
  	@EmployeeExternalCode NVARCHAR(255),
  	@FIO NVARCHAR(255),
  	@DepartmentExternalCode NVARCHAR(255),
  	@NameDepartment NVARCHAR(255),
  	@Id_Employee INT,
  	@Id_Department INT,
  	@IsError BIT

  SET @IsError = 0

  DECLARE cur CURSOR LOCAL FOR
    SELECT
      ie.Id_ImportEmployee,
      ie.EmployeeExternalCode,
      ie.FIO,
      ie.DepartmentExternalCode,
      ie.NameDepartment
    FROM
      ImportEmployee ie
    WHERE
      ie.IsImport = 0 AND
      ie.Id_ExternalSystem = @Id_ExternalSystem
    ORDER BY
      ie.Id_ImportEmployee
  
  OPEN cur
  
  FETCH FROM cur INTO @Id_ImportEmployee, @EmployeeExternalCode, @FIO, @DepartmentExternalCode, @NameDepartment
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
  	
  	BEGIN TRY
  		
  		BEGIN TRAN
  		
  	  IF NOT EXISTS (SELECT * FROM ExternalDepartment ed
  	                 WHERE ed.Id_ExternalSystem = @Id_ExternalSystem AND
  	                       ed.DepartmentExternalCode = @DepartmentExternalCode)
      BEGIN

        INSERT INTO Department (Name, EMail, BeginTime, EndTime)
        VALUES(@NameDepartment, NULL, '09:00', '18:00')
        
        SET @Id_Department = SCOPE_IDENTITY()
    	
        INSERT INTO ExternalDepartment (Id_Department, DepartmentExternalCode, Id_ExternalSystem)
        VALUES (@Id_Department, @DepartmentExternalCode, @Id_ExternalSystem)
    	
      END
      ELSE
        UPDATE Department
        SET Name = @NameDepartment
        FROM ExternalDepartment ed
        WHERE
          ed.Id_Department = Department.Id_Department AND
          ed.Id_ExternalSystem = @Id_ExternalSystem AND
          ed.DepartmentExternalCode = @DepartmentExternalCode AND
          Department.Name <> @NameDepartment
  	
  	  SET @Id_Department = (SELECT ed.Id_Department FROM ExternalDepartment ed
  	                        WHERE ed.Id_ExternalSystem = @Id_ExternalSystem AND
  	                              ed.DepartmentExternalCode = @DepartmentExternalCode)
  	
  	  IF NOT EXISTS(SELECT * FROM ExternalEmployee ee
  	                WHERE ee.Id_ExternalSystem = @Id_ExternalSystem AND
  	                      ee.EmployeeExternalCode = @EmployeeExternalCode)
      BEGIN
    	
    	  INSERT INTO Employee (NAME, BeginTime, EndTime)
    	  VALUES (@FIO, NULL, NULL)
    	
    	  SET @Id_Employee = SCOPE_IDENTITY()
    	
    	  INSERT INTO ExternalEmployee (Id_Employee, EmployeeExternalCode, Id_ExternalSystem)
    	  VALUES (@Id_Employee, @EmployeeExternalCode, @Id_ExternalSystem)
    	
    	  INSERT INTO CrossEmployeeDepartment (Id_Employee, Id_Department, DateActive)
    	  VALUES (@Id_Employee, @Id_Department, GETDATE())
    	
      END
      ELSE
      BEGIN
    	
    	  UPDATE Employee
    	  SET Name = @FIO
    	  FROM ExternalEmployee ee
    	  WHERE
    	    ee.Id_Employee = Employee.Id_Employee AND
    	    ee.Id_ExternalSystem = @Id_ExternalSystem AND
    	    ee.EmployeeExternalCode = @EmployeeExternalCode AND
    	    Employee.Name <> @FIO
    	
    	  IF ISNULL((SELECT TOP 1
                     ced.Id_Department
                   FROM
                     CrossEmployeeDepartment ced
                   WHERE
                     ced.Id_Employee = @Id_Employee
                   ORDER BY
                     ced.DateActive DESC), -1) <> @Id_Department
        BEGIN
      	
      	  INSERT INTO CrossEmployeeDepartment (Id_Employee, Id_Department, DateActive)
      	  VALUES (@Id_Employee, @Id_Department, GETDATE())
      	
        END
    	
      END
  	  
  	  UPDATE ImportEmployee
  	  SET IsImport = 1,
  	      DateImport = GETDATE(),
  	      [Status] = N'Success'
  	  WHERE Id_ImportEmployee = @Id_ImportEmployee
  	  
  	  COMMIT TRAN
  	  
  	END TRY
  	BEGIN CATCH
  		
  		ROLLBACK TRAN
  		
  		UPDATE ImportEmployee
  		SET [Status] = ERROR_MESSAGE()
  		WHERE Id_ImportEmployee = @Id_ImportEmployee
  		
  		SET @IsError = 1
  		
  	END CATCH
  	
  	FETCH FROM cur INTO @Id_ImportEmployee, @EmployeeExternalCode, @FIO, @DepartmentExternalCode, @NameDepartment
  	
  END
  
  CLOSE cur
  DEALLOCATE cur

  IF @IsError = 1
    THROW 50001, N'Error', 1;

END
GO

-- =============================================
-- Author: Матусевич А.Л.
-- Create date: 2014-08-05
-- Description:	Импорт табеля сотрудников из внешних источников
-- =============================================
CREATE PROCEDURE [dbo].[job_import_tablesheet]
	@Id_ExternalSystem INT
AS
BEGIN
	
	SET NOCOUNT ON;

  DECLARE @Temp TABLE ([Action] SYSNAME, Id_Employee INT, [Date] SMALLDATETIME);

  MERGE TableSheet AS ts
  USING (SELECT
           ee.Id_Employee,
           its.[Type],
           its.[Date]           
         FROM
           ImportTableSheet its
           JOIN ExternalEmployee ee
             ON ee.EmployeeExternalCode = its.EmployeeExternalCode
         WHERE
          its.Id_ExternalSystem = @Id_ExternalSystem AND
          its.IsImport = 0) AS its (Id_Employee, [Type], [Date])
  ON ts.Id_Employee = its.Id_Employee AND
     ts.[Date] = its.[Date]
  WHEN NOT MATCHED THEN
    INSERT (Id_Employee, [Date], [Type])
    VALUES (its.Id_Employee, its.[Date], its.[Type])
  WHEN MATCHED THEN
  	UPDATE
  	SET [Type] = its.[Type]
  OUTPUT $action, INSERTED.Id_Employee, INSERTED.[Date] INTO @Temp;
  
  UPDATE its
  SET its.IsImport = 1
  FROM
    ImportTableSheet its
    JOIN ExternalEmployee ee
      ON ee.EmployeeExternalCode = its.EmployeeExternalCode
    JOIN @Temp tmp
      ON tmp.Id_Employee = ee.Id_Employee AND
         tmp.[Date] = its.[Date]
  WHERE
    ee.Id_ExternalSystem = @Id_ExternalSystem
    
END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ie_del_employee]
AS
BEGIN

	SET NOCOUNT ON;

  BEGIN TRY
  	
    BEGIN TRAN
  
    DELETE FROM ImportEmployee
    WHERE Id_ImportEmployee IN (SELECT tmp.Id_ImportEmployee FROM #tmpDelImport tmp)
  
    COMMIT TRAN
    
    SELECT 1, N'Данные удалены'

  END TRY
  BEGIN CATCH
  	
  	ROLLBACK TRAN
  	
  	SELECT -1, ERROR_PROCEDURE() + CHAR(13) + CHAR(10) + ERROR_MESSAGE();
  	
  END CATCH

END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ie_sel_employee]
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    ie.Id_ImportEmployee,
    ie.EmployeeExternalCode,
    ie.FIO,
    ie.DepartmentExternalCode,
    ie.NameDepartment,
    ie.[Status],
    es.Id_ExternalSystem,
    es.Name AS SystemName
  FROM
    ImportEmployee ie
    JOIN ExternalSystem es
      ON es.Id_ExternalSystem = ie.Id_ExternalSystem
  WHERE
    ie.IsImport = 0
  ORDER BY
    ie.Id_ImportEmployee
  
END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ie_import_employee]
AS
BEGIN

	SET NOCOUNT ON;

  DECLARE
  	@Id_ImportEmployee INT,
  	@EmployeeExternalCode NVARCHAR(255),
  	@FIO NVARCHAR(255),
  	@DepartmentExternalCode NVARCHAR(255),
  	@NameDepartment NVARCHAR(255),
  	@Id_Employee INT,
  	@Id_Department INT,
  	@IsError BIT,
  	@Id_ExternalSystem INT

  SET @IsError = 0

  DECLARE cur CURSOR LOCAL FOR
    SELECT
      ie.Id_ImportEmployee,
      ie.EmployeeExternalCode,
      ie.FIO,
      ie.DepartmentExternalCode,
      ie.NameDepartment,
      ie.Id_ExternalSystem
    FROM
      ImportEmployee ie
      JOIN #tmpImportEmployee tmp
        ON tmp.Id_ImportEmployee = ie.Id_ImportEmployee
    ORDER BY
      ie.Id_ImportEmployee
  
  OPEN cur
  
  FETCH FROM cur INTO @Id_ImportEmployee, @EmployeeExternalCode, @FIO, @DepartmentExternalCode, @NameDepartment, @Id_ExternalSystem
  
  WHILE @@FETCH_STATUS = 0
  BEGIN
  	
  	BEGIN TRY
  		
  		BEGIN TRAN
  		
  	  IF NOT EXISTS (SELECT * FROM ExternalDepartment ed
  	                 WHERE ed.Id_ExternalSystem = @Id_ExternalSystem AND
  	                       ed.DepartmentExternalCode = @DepartmentExternalCode)
      BEGIN

        INSERT INTO Department (Name, EMail, BeginTime, EndTime)
        VALUES(@NameDepartment, NULL, '09:00', '18:00')
        
        SET @Id_Department = SCOPE_IDENTITY()
    	
        INSERT INTO ExternalDepartment (Id_Department, DepartmentExternalCode, Id_ExternalSystem)
        VALUES (@Id_Department, @DepartmentExternalCode, @Id_ExternalSystem)
    	
      END
      ELSE
        UPDATE Department
        SET Name = @NameDepartment
        FROM ExternalDepartment ed
        WHERE
          ed.Id_Department = Department.Id_Department AND
          ed.Id_ExternalSystem = @Id_ExternalSystem AND
          ed.DepartmentExternalCode = @DepartmentExternalCode AND
          Department.Name <> @NameDepartment
  	
  	  SET @Id_Department = (SELECT ed.Id_Department FROM ExternalDepartment ed
  	                        WHERE ed.Id_ExternalSystem = @Id_ExternalSystem AND
  	                              ed.DepartmentExternalCode = @DepartmentExternalCode)
  	
  	  IF NOT EXISTS(SELECT * FROM ExternalEmployee ee
  	                WHERE ee.Id_ExternalSystem = @Id_ExternalSystem AND
  	                      ee.EmployeeExternalCode = @EmployeeExternalCode)
      BEGIN
    	
    	  INSERT INTO Employee (NAME, BeginTime, EndTime)
    	  VALUES (@FIO, NULL, NULL)
    	
    	  SET @Id_Employee = SCOPE_IDENTITY()
    	
    	  INSERT INTO ExternalEmployee (Id_Employee, EmployeeExternalCode, Id_ExternalSystem)
    	  VALUES (@Id_Employee, @EmployeeExternalCode, @Id_ExternalSystem)
    	
    	  INSERT INTO CrossEmployeeDepartment (Id_Employee, Id_Department, DateActive)
    	  VALUES (@Id_Employee, @Id_Department, GETDATE())
    	
      END
      ELSE
      BEGIN
    	
    	  UPDATE Employee
    	  SET Name = @FIO
    	  FROM ExternalEmployee ee
    	  WHERE
    	    ee.Id_Employee = Employee.Id_Employee AND
    	    ee.Id_ExternalSystem = @Id_ExternalSystem AND
    	    ee.EmployeeExternalCode = @EmployeeExternalCode AND
    	    Employee.Name <> @FIO
    	
    	  IF ISNULL((SELECT TOP 1
                     ced.Id_Department
                   FROM
                     CrossEmployeeDepartment ced
                   WHERE
                     ced.Id_Employee = @Id_Employee
                   ORDER BY
                     ced.DateActive DESC), -1) <> @Id_Department
        BEGIN
      	
      	  INSERT INTO CrossEmployeeDepartment (Id_Employee, Id_Department, DateActive)
      	  VALUES (@Id_Employee, @Id_Department, GETDATE())
      	
        END
    	
      END
  	  
  	  UPDATE ImportEmployee
  	  SET IsImport = 1,
  	      DateImport = GETDATE(),
  	      [Status] = N'Success'
  	  WHERE Id_ImportEmployee = @Id_ImportEmployee
  	  
  	  COMMIT TRAN
  	  
  	END TRY
  	BEGIN CATCH
  		
  		ROLLBACK TRAN
  		
  		UPDATE ImportEmployee
  		SET [Status] = ERROR_MESSAGE()
  		WHERE Id_ImportEmployee = @Id_ImportEmployee
  		
  		SET @IsError = 1
  		
  	END CATCH
  	
  	FETCH FROM cur INTO @Id_ImportEmployee, @EmployeeExternalCode, @FIO, @DepartmentExternalCode, @NameDepartment, @Id_ExternalSystem
  	
  END
  
  CLOSE cur
  DEALLOCATE cur

  IF @IsError = 1
    SELECT -1, 'При импорте были ошибки'
  ELSE
  	SELECT 1, 'Данные импортированы'

END
GO