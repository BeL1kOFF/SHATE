-- =============================================
-- Author: Матусевич Александр
-- Create date: 2014-03-28
-- Description:	Выборка периодов
-- =============================================
CREATE PROCEDURE [dbo].[call_sel_period] 
	@Id INT
AS
BEGIN
	
	SET NOCOUNT ON;

  SELECT
    p.DATE1,
    p.DATE2
  FROM
    PERIODS p
  WHERE
    p.ID = @Id
  
END