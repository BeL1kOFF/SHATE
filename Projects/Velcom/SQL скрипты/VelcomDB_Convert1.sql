INSERT INTO ExternalDepartment
(
	Id_Department,
	DepartmentExternalCode,
	Id_ExternalSystem
)
  SELECT
    d.Id_Department,
    dc.Code,
    1
  FROM
    [Department1C$] dc
    JOIN Department d
      ON d.Name = dc.Name
  WHERE
    dc.Code IS NOT NULL
  ORDER BY
    d.Id_Department
GO

INSERT INTO ExternalEmployee
(
	Id_Employee,
	EmployeeExternalCode,
	Id_ExternalSystem
)
  SELECT
    e.Id_Employee,
    ec.Code,
    1
  FROM
    [Employee1C$] ec
    JOIN Employee e
      ON ec.Name = e.Name
  WHERE
    ec.Code IS NOT NULL
  ORDER BY
    e.Id_Employee
GO

DROP TABLE [Department1C$]
DROP TABLE [Employee1C$]
GO