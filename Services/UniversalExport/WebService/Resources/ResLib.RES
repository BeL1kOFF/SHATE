        ��  ��                  A   P   T E X T   S Q L S E L E C T C L E N T B Y L O G I N         0         SELECT [Customer No_] 
FROM [##Firm##$Web User] 
WHERE [Login]=   �   H   T E X T   S Q L S E L E C T C U S T O M E R         0         SELECT  [No_] 
		,[Name]
		,[E-Mail]
        ,CASE [Customer Price Group] 
		WHEN '���' THEN NULL 
		WHEN '��� ��' THEN 1 
		WHEN '��� ��' THEN 2 
		ELSE NULL 
		END as PrGr
FROM [##Firm##$Customer] 
WHERE  [No_] =�   L   T E X T   S Q L S E L E C T W E B E X P O R T S         0         SELECT * FROM Exports 
WHERE [ID_Client] = ##ClientID##
	AND Web = 1 
     AND ([email] like '%##Email##%' OR '##Email##'='') 
     AND INTERVAL>0 AND emailflag = 1 
ORDER BY ID_WH ASC, ID DESC  O  H   T E X T   S Q L I N S E R T W E B E X P O R T       0         INSERT INTO Exports ([ID_Client],[ID_WH],[CY],[blocked],[PRICE],[NAV_Client],[INTERVAL],[NEXT_EXPORT]
           ,[FILE_NAME],[ID_TEMPL],[emailflag],[email],[emailsubj],[web])
      VALUES (##ClientID##,##WHID##,'##CY##', 0 , NULL , NULL , 1440 , DATEADD(hh,+12,GETDATE()) 
			,'##FILENAME##' , 6 , 1, '##EMAIL##','##SUBJECT##',1 )  �   L   T E X T   S Q L U P D A T E W E B E X P O R T S         0         UPDATE Exports 
SET Emailflag = 1,  email = '##Email##'
    ,blocked = 0, Interval = 1440, NEXT_Export = DATEADD(hh, 12, GetDate())
    , CY = '##CY##'
 WHERE web=1
     AND ID_Client =##ClientID##
     AND ID_WH = ##WHID##   i   D   T E X T   S Q L S E L E C T C L I E N T         0         SELECT TOP 1 * FROM Clients 
WHERE ID_WH = ##WHID## AND NAV_Client = '##ClientNAV##' 
 ORDER BY ID DESC   