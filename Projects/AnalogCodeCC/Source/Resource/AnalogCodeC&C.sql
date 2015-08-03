SET NOCOUNT ON;

--CREATE TABLE #ItemGroupFilter (NodeId INT)

--CREATE TABLE #TMFilter (tm VARCHAR(60) COLLATE SQL_Ukrainian_CP1251_CI_AS)

-- Фильтр --

/*INSERT INTO #ItemGroupFilter (NodeID)
VALUES (10101)

INSERT INTO #TMFilter (tm)
VALUES ('CYCLO'),
       ('WD-40')*/

------------

IF (SELECT COUNT(*) FROM #ItemGroupFilter) <> 1
BEGIN
	
	SELECT 0, 'Ошибка: Необходимо указать только 1 группу(подгруппу)'
	
	DROP TABLE #TMFilter
	DROP TABLE #ItemGroupFilter
	
	RETURN
		
END

CREATE TABLE #ItemGroupWork (Code VARCHAR(20) COLLATE SQL_Ukrainian_CP1251_CI_AS)
CREATE TABLE #ItemWork (ItemNo VARCHAR(20) COLLATE SQL_Ukrainian_CP1251_CI_AS)
CREATE TABLE #ItemOne (ItemNo VARCHAR(20) COLLATE SQL_Ukrainian_CP1251_CI_AS)
CREATE TABLE #ItemSubs (ItemNo VARCHAR(20) COLLATE SQL_Ukrainian_CP1251_CI_AS, ItemNo2 VARCHAR(20) COLLATE SQL_Ukrainian_CP1251_CI_AS)
CREATE TABLE #PartOne (Id_Part INT)
CREATE TABLE #PartSubs (Id_Part INT, Id_Part2 INT)

BEGIN TRY

  BEGIN TRAN
	
  /*
   * Создаем рекурсивный список всех входящих подгрупп в указанную группу #ItemGroupFilter
   */

  ;WITH CTE AS (
                SELECT
                  smg.nodeid,
                  smg.parentid,
                  smg.Code,
                  smg.[Description],
                  smg.[Item Group Type Code]
                FROM
                  [%company$Item Group] smg
                  JOIN #ItemGroupFilter tmp
                    ON tmp.NodeId = smg.nodeid
                WHERE
                  smg.[Item Group Type Code] = 'ТОВЛИНИЯ'
                UNION ALL
                SELECT
                  smg.nodeid,
                  smg.parentid,
                  smg.Code,
                  smg.[Description],
                  smg.[Item Group Type Code]
                FROM
                  CTE c
                  JOIN [%company$Item Group] smg
                    ON smg.parentid = c.nodeid)
    INSERT INTO #ItemGroupWork (Code)
      SELECT
        c.Code
      FROM
        CTE c
      ORDER BY
        c.nodeid,
        c.parentid,
        c.Code

  /*
   * Создаем список товаров в отфильтрованных подгруппах и выбранных брендах среди которых будут кроссироваться замены
   */

  INSERT INTO #ItemWork (ItemNo)
    SELECT
      sm.No_
    FROM
      [%company$Item Item Group] smig
      JOIN #ItemGroupWork igw
        ON igw.Code = smig.[Item Group Code]
      JOIN [%company$Item] sm
        ON sm.No_ = smig.[Item No_]
      JOIN part p
        ON p.partid = sm.[Part ID]
      JOIN tm t
        ON t.[Trade Mark Code] = p.tmid
      JOIN #TMFilter tmp
        ON tmp.tm = t.[Trade Mark Name]
    WHERE
      tmp.IsFlag = 1 AND
      smig.[Item Group Type Code] = 'ТОВЛИНИЯ'

  DECLARE
	  @ItemNo VARCHAR(20),
	  @KaCode VARCHAR(15),
	  @Id_AnalogCode INT,
	  @Id_Crosses INT,
	  @Text NVARCHAR(MAX),
	  
	  @CountCrossesItemInsert INT = 0,
	  @CountCrossesItemUpdate INT = 0,
	  @CountCrossesPartInsert INT = 0,
	  @CountCrossesPartUpdate INT = 0

  DECLARE cur CURSOR LOCAL FOR
    SELECT
      iw.ItemNo
    FROM
      #ItemWork iw
    ORDER BY
      iw.ItemNo

  OPEN cur

  FETCH FROM cur INTO @ItemNo

  WHILE @@FETCH_STATUS = 0
  BEGIN
	
	  TRUNCATE TABLE #ItemOne
	
	  INSERT INTO #ItemOne (ItemNo)
	  VALUES (@ItemNo)
	
	  /*
     * Добавляем товары пока есть замены выбранного товара на другие товары и их замены на другие и т.д. по рекурсии из тех же подгрупп по выбранным брендам
     */
	
	  WHILE EXISTS(SELECT
                   sms.[Substitute No_]
                 FROM
                   #ItemOne ito
                   JOIN [%company$Item Substitution] sms
                     LEFT JOIN #ItemOne ito2
                       ON ito2.ItemNo = sms.[Substitute No_]
                     ON sms.No_ = ito.ItemNo AND
                        ito2.ItemNo IS NULL
                   JOIN #ItemWork iw
                     ON iw.ItemNo = sms.[Substitute No_]
                 UNION
                 SELECT
                   sms.No_
                 FROM
                   #ItemOne ito
                   JOIN [%company$Item Substitution] sms
                     LEFT JOIN #ItemOne ito2
                       ON ito2.ItemNo = sms.No_
                     ON sms.[Substitute No_] = ito.ItemNo AND
                        ito2.ItemNo IS NULL
                   JOIN #ItemWork iw
                     ON iw.ItemNo = sms.No_)
    BEGIN
	  
      INSERT INTO #ItemOne (ItemNo)
        SELECT
          sms.[Substitute No_]
        FROM
          #ItemOne ito
          JOIN [%company$Item Substitution] sms
            LEFT JOIN #ItemOne ito2
              ON ito2.ItemNo = sms.[Substitute No_]
            ON sms.No_ = ito.ItemNo AND
               ito2.ItemNo IS NULL
          JOIN #ItemWork iw
            ON iw.ItemNo = sms.[Substitute No_]
        UNION
        SELECT
          sms.No_
        FROM
          #ItemOne ito
          JOIN [%company$Item Substitution] sms
            LEFT JOIN #ItemOne ito2
              ON ito2.ItemNo = sms.No_
            ON sms.[Substitute No_] = ito.ItemNo AND
               ito2.ItemNo IS NULL
          JOIN #ItemWork iw
            ON iw.ItemNo = sms.No_
        ORDER BY
          sms.[Substitute No_]

    END
	  
	  /*
	   * Создаем список кроссов всех на всех, кроме самих себя.
	   */
	  
	  TRUNCATE TABLE #ItemSubs
	  
	  INSERT INTO #ItemSubs (ItemNo, ItemNo2)
	    SELECT
	      i.ItemNo,
	      i2.ItemNo
	    FROM
	      #ItemOne i
	      CROSS JOIN #ItemOne i2
	    WHERE
	      i.ItemNo <> i2.ItemNo
	  
	  IF EXISTS(SELECT * FROM #ItemSubs its)
	  BEGIN
	  
	    /*
	     * Получаем код аналога
	     */
	
	    SET @KaCode = (SELECT TOP 1
	                     sm.[KA Code]
	                   FROM
	                     [%company$Item] sm
	                     JOIN #ItemOne ito
	                       ON ito.ItemNo = sm.No_
	                   WHERE
	                     sm.[KA Code] <> '')
	
	    IF @KaCode IS NULL
	    BEGIN
		
		    INSERT INTO [Analogs Code]
		      (Code, User_Modifed, Last_Modifed, Number, Brand)
		    VALUES
		      ('', UPPER(SUSER_NAME()), GETDATE(), '', '')
		
		    SET @Id_AnalogCode = SCOPE_IDENTITY()
		
		    SET @KaCode = 'N' + RIGHT('0000000' + CAST(@Id_AnalogCode AS NVARCHAR(MAX)), 7)
		
		    UPDATE [Analogs Code]
		    SET Code = @KaCode
		    WHERE ID = @Id_AnalogCode		
		
	    END
	
	    SET @Text = 'Item: @KaCode = ' + @KaCode
	
	    --RAISERROR(@Text, 0, 1) WITH NOWAIT
	
	    /*
	     * Создаем замены с полученным кодом аналога
	     */

      UPDATE crosses
      SET crchecked = 1,
          Interchangeable = 1,
          [Type] = @KaCode,
          Cross_source = 'AnalogCodeC&C',
          Created = UPPER(SUSER_NAME()),
          [Created at] = DATEADD(hh, -3, GETDATE())
      FROM
        #ItemSubs its
        JOIN [%company$Item] sm
          ON sm.No_ = its.ItemNo
        JOIN [%company$Item] sm2
          ON sm2.No_ = its.ItemNo2
      WHERE
        sm.[Part ID] = crosses.partid AND
        sm2.[Part ID] = crosses.cpartid AND
        crosses.[Type] <> @KaCode

      SET @CountCrossesItemUpdate = @CountCrossesItemUpdate + @@ROWCOUNT

      SET @Id_Crosses = ISNULL((SELECT MAX(c.crossid) FROM crosses c), 0)

      INSERT INTO crosses
        (crossid, partid, cpartid, crchecked, Interchangeable, ExportERP, [Type], Cross_source, Created)
        SELECT
          @Id_Crosses + ROW_NUMBER() OVER (ORDER BY its.ItemNo, its.ItemNo2),
          sm.[Part ID],
          sm2.[Part ID],
          1,
          1,
          0,
          @KaCode,
          'AnalogCodeC&C',
          UPPER(SUSER_NAME())
        FROM
          #ItemSubs its
          JOIN [%company$Item] sm
            ON sm.No_ = its.ItemNo
          JOIN [%company$Item] sm2
            ON sm2.No_ = its.ItemNo2
          LEFT JOIN crosses c
            ON c.partid = sm.[Part ID] AND
               c.cpartid = sm2.[Part ID]
        WHERE
          c.crossid IS NULL
    
      SET @CountCrossesItemInsert = @CountCrossesItemInsert + @@ROWCOUNT
    
      UPDATE part
      SET [KA Code] = @KaCode
      FROM
        #ItemOne ito
        JOIN [%company$Item] sm
          ON sm.No_ = ito.ItemNo
      WHERE
        part.partid = sm.[Part ID]
    
      UPDATE [%company$Item]
      SET [KA Code] = @KaCode
      FROM
        #ItemOne ito
      WHERE
        [%company$Item].No_ = ito.ItemNo
    
    END
      
    /*
     * То же самое только по запчастям
     */
    
    IF (1 = :IsPartExec)
    BEGIN
    
      TRUNCATE TABLE #PartOne
	
	    INSERT INTO #PartOne (Id_Part)
	      SELECT
	        sm.[Part ID]
	      FROM
	        [%company$Item] sm
	      WHERE
	        sm.No_ = @ItemNo
    
      /*
       * Добавляем запчасти пока есть замены запчасти выбранного товара на другие запчасти и их замены на другие и т.д. по рекурсии из тех же подгрупп по выбранным брендам
       */
	
	    WHILE EXISTS(SELECT
                     c.cpartid
                   FROM
                     #PartOne po
                     JOIN crosses c
                       LEFT JOIN #PartOne po2
                         ON po2.Id_Part = c.cpartid
                       ON c.partid = po.Id_Part AND
                          po2.Id_Part IS NULL
                     JOIN part p
                       ON p.partid = c.cpartid
                     JOIN tm t
                       ON t.[Trade Mark Code] = p.tmid
                     JOIN #TMFilter tmf
                       ON tmf.tm = t.[Trade Mark Name]
                   UNION
                   SELECT
                     c.partid
                   FROM
                     #PartOne po
                     JOIN crosses c
                       LEFT JOIN #PartOne po2
                         ON po2.Id_Part = c.partid
                       ON c.cpartid = po.Id_Part AND
                          po2.Id_Part IS NULL
                     JOIN part p
                       ON p.partid = c.partid
                     JOIN tm t
                       ON t.[Trade Mark Code] = p.tmid
                     JOIN #TMFilter tmf
                       ON tmf.tm = t.[Trade Mark Name])
      BEGIN
	  
        INSERT INTO #PartOne (Id_Part)
          SELECT
            c.cpartid
          FROM
            #PartOne po
            JOIN crosses c
              LEFT JOIN #PartOne po2
                ON po2.Id_Part = c.cpartid
              ON c.partid = po.Id_Part AND
                po2.Id_Part IS NULL
            JOIN part p
              ON p.partid = c.cpartid
            JOIN tm t
              ON t.[Trade Mark Code] = p.tmid
            JOIN #TMFilter tmf
              ON tmf.tm = t.[Trade Mark Name]
          UNION
          SELECT
            c.partid
          FROM
            #PartOne po
            JOIN crosses c
              LEFT JOIN #PartOne po2
                ON po2.Id_Part = c.partid
              ON c.cpartid = po.Id_Part AND
                po2.Id_Part IS NULL
            JOIN part p
              ON p.partid = c.partid
            JOIN tm t
              ON t.[Trade Mark Code] = p.tmid
            JOIN #TMFilter tmf
              ON tmf.tm = t.[Trade Mark Name]

      END
    
      /*
	     * Создаем список кроссов всех на всех, кроме самих себя.
	     */
	  
	    TRUNCATE TABLE #PartSubs
	  
	    INSERT INTO #PartSubs (Id_Part, Id_Part2)
	      SELECT
	        po.Id_Part,
	        po2.Id_Part
	      FROM
	        #PartOne po
	        CROSS JOIN #PartOne po2
	      WHERE
	        po.Id_Part <> po2.Id_Part
    
      IF EXISTS(SELECT * FROM #PartSubs ps)
	    BEGIN
	  
	      /*
	       * Получаем код аналога
	       */
	
	      SET @KaCode = (SELECT TOP 1
	                       p.[KA Code]
	                     FROM
	                       part p
	                       JOIN #PartOne po
	                         ON po.Id_Part = p.partid
	                     WHERE
	                       p.[KA Code] <> '')
	
	      IF @KaCode IS NULL
	      BEGIN
		
		      INSERT INTO [Analogs Code]
		        (Code, User_Modifed, Last_Modifed, Number, Brand)
		      VALUES
		        ('', UPPER(SUSER_NAME()), GETDATE(), '', '')
		
		      SET @Id_AnalogCode = SCOPE_IDENTITY()
		
		      SET @KaCode = 'N' + RIGHT('0000000' + CAST(@Id_AnalogCode AS NVARCHAR(MAX)), 7)
		
		      UPDATE [Analogs Code]
		      SET Code = @KaCode
		      WHERE ID = @Id_AnalogCode		
		
	      END
	
	      SET @Text = 'Part: @KaCode = ' + @KaCode
	
	      --RAISERROR(@Text, 0, 1) WITH NOWAIT
	    
	      /*
	       * Создаем замены с полученным кодом аналога
	       */

        UPDATE crosses
        SET Interchangeable = 1,
            [Type] = @KaCode,
            Cross_source = 'AnalogCodeC&C',
            Created = UPPER(SUSER_NAME()),
            [Created at] = DATEADD(hh, -3, GETDATE())
        FROM
          #PartSubs ps
        WHERE
          ps.Id_Part = crosses.partid AND
          ps.Id_Part2 = crosses.cpartid AND
          crosses.[Type] <> @KaCode

        SET @CountCrossesPartUpdate = @CountCrossesPartUpdate + @@ROWCOUNT

        SET @Id_Crosses = ISNULL((SELECT MAX(c.crossid) FROM crosses c), 0)

        INSERT INTO crosses
          (crossid, partid, cpartid, crchecked, Interchangeable, ExportERP, [Type], Cross_source, Created)
          SELECT
            @Id_Crosses + ROW_NUMBER() OVER (ORDER BY ps.Id_Part, ps.Id_Part2),
            ps.Id_Part,
            ps.Id_Part2,
            0,
            1,
            0,
            @KaCode,
            'AnalogCodeC&C',
            UPPER(SUSER_NAME())
          FROM
            #PartSubs ps
            LEFT JOIN crosses c
              ON c.partid = ps.Id_Part AND
                 c.cpartid = ps.Id_Part2
          WHERE
            c.crossid IS NULL
    
        SET @CountCrossesPartInsert = @CountCrossesPartInsert + @@ROWCOUNT
    
        UPDATE part
        SET [KA Code] = @KaCode
        FROM
          #PartOne po
        WHERE
          part.partid = po.Id_Part
    
      END
    
	  END
    
	  FETCH FROM cur INTO @ItemNo
	
  END

  CLOSE cur
  DEALLOCATE cur

  COMMIT TRAN

  SELECT 1, 'Выполнено.' + CHAR(13) + CHAR(10) +
            'Проверенных кроссов: Вставлено - ' + CAST(@CountCrossesItemInsert AS NVARCHAR(MAX)) + '. Обновлено - ' + CAST(@CountCrossesItemUpdate AS NVARCHAR(MAX)) + CHAR(13) + CHAR(10) +
            'Непроверенных кроссов: Вставлено - ' + CAST(@CountCrossesPartInsert AS NVARCHAR(MAX)) + '. Обновлено - ' + CAST(@CountCrossesPartUpdate AS NVARCHAR(MAX))

END TRY
BEGIN CATCH
	 
	ROLLBACK TRAN
	
	SELECT -1, 'Ошибка: ' +  ERROR_MESSAGE()
	
END CATCH

DROP TABLE #PartSubs
DROP TABLE #PartOne
DROP TABLE #ItemSubs
DROP TABLE #ItemOne
DROP TABLE #ItemWork
DROP TABLE #ItemGroupWork
--DROP TABLE #TMFilter
--DROP TABLE #ItemGroupFilter