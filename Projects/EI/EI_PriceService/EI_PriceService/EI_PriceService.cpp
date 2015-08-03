// Nav_Export.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "locale.h"
#include "EI_priceService.h"
#include "SMTP\SMTPClass.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// The one and only application object




bool UninstallService(DWORD* pErr)
{
	*pErr = 0;

	SC_HANDLE hSCM;
	SC_HANDLE hService;

	hSCM = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS);

	if (!hSCM)
	{
		*pErr = GetLastError();
		return false;
	}

	hService = OpenService(hSCM, ServiceName,  DELETE | SERVICE_STOP);
	
	if (!hService)
	{
		CloseServiceHandle(hSCM);

		*pErr = GetLastError();
		if (*pErr==ERROR_SERVICE_DOES_NOT_EXIST)
		{
			*pErr = 0;
			return true;
		}
		return false;
	}

    SERVICE_STATUS ss;

	ControlService(hService, SERVICE_CONTROL_STOP, &ss);

	DeleteService(hService);

	CloseServiceHandle(hService);
	CloseServiceHandle(hSCM);

	return true;
}

bool UninstallEventLog(DWORD* pErr)
{
	*pErr = 0;

	HKEY  hKey;
	DWORD res;

	res = RegOpenKeyEx(
			HKEY_LOCAL_MACHINE, 
			LOG_PARENT_KEY,
			0,
			DELETE,
			&hKey);

	if (res!=ERROR_SUCCESS)
	{
		return false;
	}

	res = RegDeleteKey(hKey, EventSource);

	if (res!=ERROR_SUCCESS)
	{
		RegCloseKey(hKey);
		return false;
	}

	RegCloseKey(hKey);
	return true;
}

bool Uninstall()
{
	DWORD		Err;
	HINSTANCE   hInst;
	
	hInst = GetModuleHandle(NULL);

	if (  !UninstallService(&Err)		
		||!UninstallEventLog(&Err)
		)
	{
		MessageBox(NULL, GetErrorText(&Err), DisplayName, MB_OK);
		return false;
	}

	return true;
}


bool InstallService(DWORD* pErr)
{
	*pErr = 0;
	SC_HANDLE hSCM;
	SC_HANDLE hService;	
	hSCM = OpenSCManager(NULL, NULL, SC_MANAGER_CREATE_SERVICE);

	if (!hSCM)
	{
		*pErr = GetLastError();
		return false;
	}
		
	TCHAR ServicePath[_MAX_PATH + 3];

	// Получаем путь к exe-файлу
	GetModuleFileName(NULL, ServicePath + 1, _MAX_PATH);

	// Заключаем в кавычки
	ServicePath[0] = TEXT('\"');
	ServicePath[lstrlen(ServicePath) + 1] = 0;
	ServicePath[lstrlen(ServicePath)] = TEXT('\"');

	// Созддаём службу
	hService = CreateService(
		hSCM,
		ServiceName,
		DisplayName,
		0,
		SERVICE_WIN32_OWN_PROCESS,
		SERVICE_DEMAND_START,
		SERVICE_ERROR_NORMAL,
		ServicePath,
		NULL,
		NULL,
		NULL,
		NULL,
		NULL);

	// Закрываем SCM
	CloseServiceHandle(hSCM);

    if (!hService)
	{
		*pErr = GetLastError();
		return false;
	}

	// Закрываем службу
	CloseServiceHandle(hService);

	return true;
}

bool WriteDescription(HINSTANCE hInst, DWORD* pErr)
{
	*pErr = 0;

	TCHAR Descr[MSG_LEN];
	DWORD res;	

	// Получает описание
	res = LoadString(hInst, IDS_DESCRIPTION, Descr, MSG_LEN);
	
	if (res==0)
	{
		return false;
	}

	TCHAR KeyName[KEY_LEN];

	wsprintf(KeyName, TEXT("%s\\%s"), SERVICE_PARENT_KEY, ServiceName);

	HKEY hKey;

	res = RegOpenKeyEx(
			HKEY_LOCAL_MACHINE,
			KeyName,
			0,
			KEY_SET_VALUE,
			&hKey);

	if (res!=ERROR_SUCCESS)
	{
		return false;
	}

	res = RegSetValueEx(
			hKey,
			TEXT("Description"),
			0,
			REG_SZ,
			(CONST BYTE*) Descr,
			(lstrlen(Descr) + 1)*sizeof(TCHAR));

	if (res!=ERROR_SUCCESS)
	{
		RegCloseKey(hKey);
		return false;
	}

	RegCloseKey(hKey);
	return true;
}

bool InstallEventLog(DWORD* pErr)
{
	return true;
}


bool Install()
{
	DWORD		Err;
	HINSTANCE   hInst;
	hInst = GetModuleHandle(NULL);
	if (!InstallService(&Err)
		||!WriteDescription(hInst, &Err)
		||!InstallEventLog(&Err)
		)
	{
		MessageBox(NULL, GetErrorText(&Err), DisplayName, MB_OK);
		Uninstall();
		
		return false;
	}
	return true;
}

void Stop()
{
	bStop = TRUE;
	SetEvent(hEndEvent);
    Sleep(1000);
	CloseHandle(hEndEvent);
	WriteToLogFile(_T("Завершение работы"));
}

void Pause()
{
	bPause = TRUE;
	InterlockedExchange(&fPause, 1); 
}

void Continue()
{
	bPause = FALSE;
	InterlockedExchange(&fPause, 0); 
}

void ParametersChanged()
{
	if (hSource==NULL)
	{
		return;
	}

	ReportEvent(
		hSource, 
		EVENTLOG_INFORMATION_TYPE,
		0,
		MSG_PARAMETERS_CHANGED,
		NULL,
		0,
		0,
		NULL,
		NULL);
}

void WINAPI ServiceHandler(DWORD dwCode)
{
    switch (dwCode)
	{
	case SERVICE_CONTROL_PAUSE:
		Pause();
		sStatus.dwCurrentState = SERVICE_PAUSED;		
		break;
	case SERVICE_CONTROL_CONTINUE:
		Continue();
		sStatus.dwCurrentState = SERVICE_RUNNING;		
		break;
	case SERVICE_CONTROL_STOP:
	case SERVICE_CONTROL_SHUTDOWN:		
		Stop();
		sStatus.dwCurrentState = SERVICE_STOPPED;		
		break;	
	case PARAMETERS_CHANGED:
		ParametersChanged();		
		break;
	default:		
		break;
	}
	SetServiceStatus(ssHandle, &sStatus);
}

DWORD WINAPI SendPending(LPVOID dwState)
{
	sStatus.dwCheckPoint = 0;	
	sStatus.dwWaitHint = 2000;
	sStatus.dwCurrentState = (DWORD)dwState;
	
	for (;;)
	{				
		if (WaitForSingleObject(eSendPending, 1000)!=WAIT_TIMEOUT) break;
        sStatus.dwCheckPoint++;
        SetServiceStatus(ssHandle, &sStatus);
	}

	sStatus.dwCheckPoint = 0;
	sStatus.dwWaitHint = 0;
	return 0;
}

void BeginSendPending(DWORD dwPendingType)
{
	hSendThread = NULL;
	eSendPending = CreateEvent(NULL, TRUE, FALSE, NULL);
	if (!eSendPending) return;
	
	DWORD dwId;
	
	hSendThread = CreateThread(NULL, 0, SendPending, (LPVOID)dwPendingType, 0, &dwId);
	
	if (!hSendThread) 
	{
		CloseHandle(eSendPending);
		eSendPending = NULL;
		return;
	}
}

void SetWorkDirectory()
{
	TCHAR buff[_MAX_PATH];
	DWORD Size = _MAX_PATH;
	GetModuleFileName(NULL, buff, Size);
	Size = lstrlen(buff);
	while (Size > 0)
	{
		if (buff[Size]==TEXT('\\')) break;
		Size--;
	}
	buff[Size] = 0;
	SetCurrentDirectory(buff);
}

bool Init(DWORD* pErr, DWORD* pSpecErr)
{	
	*pErr = 0;
	*pSpecErr = 0;	

	hEndEvent = CreateEvent(NULL, TRUE, FALSE, NULL);

	if (!hEndEvent)
	{
		*pErr = GetLastError();
		return false;
	}

	SetWorkDirectory();
    return true;
}

void EndSendPending()
{
	// Если поток и не запускался
	if (!hSendThread) return;

	SetEvent(eSendPending);

	if (WaitForSingleObject(hSendThread, 1000)!=WAIT_OBJECT_0) 
	{
		TerminateThread(hSendThread,0);
	}

	CloseHandle(eSendPending);
	CloseHandle(hSendThread);

	hSendThread = NULL;
	eSendPending = NULL;
}
CString PostEmailMessage(CString sFrom,CString sTo, CString sSubject, CString sBody, CString sAttachFile)
{
	CString sError;
	CSMTPConnection smtp;
	CString sMailServer;
	sMailServer = sReadFromIni(_T("E-MAIL"),_T("SERVER"),_T("10.0.0.144"));
	int iPort = _wtoi(sReadFromIni(_T("E-MAIL"),_T("PORT"),_T("25")));
	smtp.SetTimeout(_wtoi(sReadFromIni(_T("E-MAIL"),_T("TIMEOUT"),_T("50000"))));

	if (!smtp.Connect(sMailServer,iPort))
	{
		CString sResponse = smtp.GetLastCommandResponse();
		sError.Format(_T("SMTP - CONNECT %s (%s %d)"),sResponse,sMailServer,iPort);
		return sError;
	}
	
	CSMTPMessage m;
	CSMTPAddress From(sFrom); //Change these values to your settings
	m.m_From = From;
	CSMTPAddress To(sTo);   //Change these values to your settings
	m.AddRecipient(To, CSMTPMessage::TO);
	m.m_sSubject = sSubject;
	
	
	CSMTPAttachment attachment;
	attachment.Attach(sAttachFile);
	m.AddAttachment(&attachment);
	if (!smtp.SendMessage(m))
	{
		CString sResponse = smtp.GetLastCommandResponse();
		sError.Format(_T("SMTP - SendMessage %s"),sResponse);
		return sError;
	}

	if(!smtp.Disconnect())
	{
		CString sResponse = smtp.GetLastCommandResponse();
		sError.Format(_T("SMTP - SendMessage %s"),sResponse);
		return sError;
	}
	return sError;
}

bool PostEmailMessages(CDatabase * dBase)
{
	if(dBase == NULL)
	{
		WriteToLogFile(_T("Не открыта БД"));
		return FALSE;
	}

	if(!dBase->IsOpen())
	{
		WriteToLogFile(_T("Не открыта БД"));
		return FALSE;
	}

	CString sSQL;

	try
	{
		CDBVariant dbVar;
		CRecordset Query(dBase);
		
		CStringArray sItog;
		//
		int TRY_COUNT =_wtoi(sReadFromIni(_T("E-MAIL"),_T("TRY_COUNT"),_T("10"))); 
		sSQL.Format(_T("select [ID],[From],[TO],[SUBJECT],[BODY],[ATTACH] from [EMAIL_MESSAGE] where [POST] < %d"),TRY_COUNT);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		short i;
		sItog.RemoveAll();
		while(!Query.IsEOF())
		{
			for(i=0;i<6;i++)
			{
				Query.GetFieldValue(i,dbVar);
				sItog.Add(GetValue(&dbVar));
			}
			Query.MoveNext();
			if((bStop)||(bPause))
			{
				break;
			}
		}
		Query.Close();
		if((bStop)||(bPause))
		{
			return FALSE;
		}

		while(sItog.GetSize()>0)
		{
			CString sError;
			sError = PostEmailMessage(sItog.ElementAt(1),sItog.ElementAt(2), sItog.ElementAt(3), sItog.ElementAt(4), sItog.ElementAt(5));
			if(sError.GetLength() > 0)
			{
				sError.Replace(_T("'"),_T(""));
				sSQL.Format(_T("UPDATE [EMAIL_MESSAGE] SET [POST] = [POST] + 1, [ERROR] = '%s' WHERE ID = %s"),sError,sItog.ElementAt(0));
			}
			else
			{
				sSQL.Format(_T("DELETE FROM [EMAIL_MESSAGE] WHERE ID = %s"),sItog.ElementAt(0));
			}

			dBase->ExecuteSQL(sSQL);
			sItog.RemoveAt(0,6);
			if((bStop)||(bPause))
			{
				return FALSE;
			}
		}
	}
	catch(CDBException * Ex)
	{
		WriteToLogFile(Ex->m_strError);
		WriteToLogFile(sSQL);
		Ex->Delete();
		return FALSE;
	}

	return TRUE;
}

bool AddToMail(CDatabase * dBase, CString sFrom,CString sTo, CString sSubject, CString sBody, CString sAttachFile)
{
	if(dBase == NULL)
	{
		WriteToLogFile(_T("Не открыта БД"));
		return FALSE;
	}

	if(!dBase->IsOpen())
	{
		WriteToLogFile(_T("Не открыта БД"));
		return FALSE;
	}

	CString sSQL;
	int iMaxCount;
	try
	{
		CDBVariant dbVar;
		CRecordset Query(dBase);
		
		sSQL.Format(_T("select max(ID) from [EMAIL_MESSAGE]"));
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		short i;
		iMaxCount = 0;
		if(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			iMaxCount = GetValueID(&dbVar);	
		}

		iMaxCount++;
		Query.Close();

		if(iMaxCount > 0)
		{ 
			sSQL.Format(_T("INSERT INTO [EMAIL_MESSAGE] ([ID],[From],[TO],[SUBJECT],[BODY],[ATTACH],[POST])   VALUES  (%d,'%s','%s','%s','%s','%s',0)"),iMaxCount,sFrom,sTo,sSubject,sBody,sAttachFile);
			dBase->ExecuteSQL(sSQL);
		}
	}
	catch(CDBException * Ex)
	{
		WriteToLogFile(Ex->m_strError);
		WriteToLogFile(sSQL);
		Ex->Delete();
		return FALSE;
	}
	return TRUE;
}
CStringW GetWinUserName()
{
	wchar_t buffer[257];		// буфер
	DWORD size;			// размер
	size=sizeof(buffer);		// размер буфера
	if (GetUserName(buffer,&size)==0)
		throw "Error GetWinUserName";	// при ошибке функция вернет 0
	return buffer;
}

void CloseDatabase(CDatabase ** dBase)
{
	if(*dBase != NULL)
	{
		if((*dBase)->IsOpen())
			(*dBase)->Close();
		delete(*dBase);
		*dBase = NULL;
	}
}

bool bOpenDatabase(CDatabase ** dBase, CString* sError)
{
	bool bRet = FALSE;
	if(*dBase != NULL)
	{
		CloseDatabase(dBase);	
	}
	CString sServer;
	CString sDatabase;
	CString sUser;
	CString sPass;
	sServer = sReadFromIni(_T("BASE"),_T("SQL_SERVER"),_T("sqlserver"));
	sDatabase = sReadFromIni(_T("BASE"),_T("SQL_DATABASE"),_T("sqlserver"));
	sUser = sReadFromIni(_T("BASE"),_T("SQL_USER"),_T("sqlserver"));
	sPass = sReadFromIni(_T("BASE"),_T("SQL_PASS"),_T("sqlserver"));
	*dBase = new(CDatabase);
	
	CString sConnect;
	try
	{
		
		sConnect.Format(_T("Driver={SQL Server};SERVER=%s;DATABASE=%s;LANGUAGE=русский;Network=DBMSSOCN;UID=%s;PWD=%s;"),sServer,sDatabase,sUser,sPass);
		(*dBase)->OpenEx(sConnect,CDatabase::noOdbcDialog);
	}
	catch(CDBException *exsept)
	{
		sError->Format(_T("%s %s"),exsept->m_strError,sConnect);
		exsept->Delete();
		return bRet;
	}
	bRet = TRUE;
	return bRet;
}

bool bLoadExports(CDatabase * dBase,stBases ** massBases,int * iMaxCount, CString* sError)
{
	bool bRet = FALSE;
	
	if(*iMaxCount>0)
	{
		if((*massBases)==NULL)
		{
			delete((*massBases));
		}
		*massBases = NULL;
		*iMaxCount = 0;
	}
	
	if(dBase == NULL)
	{
		return bRet;
	}

	
	CString sSQL;
	try
	{
		CDBVariant dbVar;
		CRecordset Query(dBase);
		
		sSQL.Format(_T("select count(*) from (select  distinct cl.ID as con from dbo.CLIENTS as cl join CLIENTS_EMAILS on cl.id = CLIENTS_EMAILS.CLI_ID where PRICE_FILE <> '') as t"));
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		short i;
		
		if(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			*iMaxCount = GetValueID(&dbVar);	
		}
		Query.Close();
		
		if(*iMaxCount < 1)
		{
			return bRet;
		}
		
		*massBases = new(stBases[*iMaxCount]);
		
		sSQL.Format(_T("select distinct cl.ID,PRICE_FILE,[FROM],[SUBJECT],EXPORT_TYPE,EXPORT_FILE_TYPE,[AT_NAME],[ARCHIV],[COPY_TO] from dbo.CLIENTS as cl join CLIENTS_EMAILS on cl.id = CLIENTS_EMAILS.CLI_ID where PRICE_FILE <> ''"));
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		int iPos;
		iPos = 0;
		stBases * St;
		St = *massBases;
		while(!Query.IsEOF())
		{
			
			
			i = 0;
			Query.GetFieldValue(i,dbVar);
			St[iPos].sID = GetValue(&dbVar);
			//(*massBases[iPos]).sID = GetValue(&dbVar);

			i++;
			Query.GetFieldValue(i,dbVar);
			St[iPos].sFilePrice= GetValue(&dbVar);
			
			i++;
			Query.GetFieldValue(i,dbVar);
			St[iPos].sFrom  = GetValue(&dbVar);
			
			i++;
			Query.GetFieldValue(i,dbVar);
			St[iPos].sSubject = GetValue(&dbVar);
			
			i++;
			Query.GetFieldValue(i,dbVar);
			St[iPos].iType = GetValueID(&dbVar);

			i++;
			Query.GetFieldValue(i,dbVar);
			St[iPos].iTypeExport = GetValueID(&dbVar);

			i++;
			Query.GetFieldValue(i,dbVar);
			St[iPos].sAttach = GetValue(&dbVar);
			
			St[iPos].bArchiv = FALSE;
			i++;
			Query.GetFieldValue(i,dbVar);
			if(GetValue(&dbVar) == _T("1"))
			{
				St[iPos].bArchiv = TRUE;
			}
			//копировать в папку
			i++;
			Query.GetFieldValue(i,dbVar);
			St[iPos].sCopyTo = GetValue(&dbVar);

			iPos++;
			Query.MoveNext();
			
		}
		Query.Close();
		
		CString sOUT;
		for(iPos=0;iPos<*iMaxCount;iPos++)
		{
			sOUT = "";
			sSQL.Format(_T("select EMAIL from dbo.CLIENTS_EMAILS where CLIENTS_EMAILS.CLI_ID  = %s"),St[iPos].sID);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
			
					i = 0;
					Query.GetFieldValue(i,dbVar);
			sOUT = sOUT + GetValue(&dbVar)+_T(";");
			Query.MoveNext();
			}
			Query.Close();

			St[iPos].sTo = sOUT;
		}
		

	}
	catch(CDBException *exsept)
	{
		sError->Format(_T("%s\n%s"),exsept->m_strError, sSQL);
		exsept->Delete();
		return bRet;
	}
	
	bRet = TRUE;
	return bRet;
}

CString ChangeFileExt(CString sFileName, CString sExt)
{
	if (sExt=="") return sFileName;
	int p, l;
	p=sFileName.ReverseFind('.');
	l=sFileName.StringLength(sFileName);
	if (p>0) //exclude ".FileName" or ""
	{
		sFileName.Left(p);
		sFileName = sFileName +_T(".")+ sExt;		
	}
	return sFileName;
}

BOOL isTitlesPresent(CString sFilename)
{
		CStdioFile file;		
		TCHAR Ch = 0x00;
		try
		{				
			if(file.Open(sFilename, CFile::modeRead))
			{
				CString sLine;
				file.ReadString(sLine);
				Ch = sLine.GetAt(0);				
			}
			file.Close();
		} catch(CFileException* error){			
			error->Delete();			
		}		
		
		if (Ch<0x80) return FALSE;
		else return TRUE;
}
CString TitlesFromFile(CString sFilename)
{
		CStdioFile file;
		CString sEmpty=_T("");
		CString sLine;
		TCHAR Ch = 0x00;
		try
		{				
			if(file.Open(sFilename, CFile::modeRead))
			{				
				file.ReadString(sLine);
				Ch = sLine.GetAt(0);				
			}
			file.Close();
		} catch(CFileException* error){			
			error->Delete();			
		}		
		
		if (Ch<0x80) return sEmpty;
		else return sLine;
}
CString GenerateProcessingRequest(CString sID, CString sFileName, BOOL titles_row=TRUE)
{	
	CString Res;
	Res = "";
    CString ext, fmt;
	int p, l;
	p=sFileName.ReverseFind('.');
	l=sFileName.StringLength(sFileName);
	if (p>0) 
	{
		ext = sFileName.Right(l-p);
		fmt = sFileName;
		if (fmt.Replace(ext,_T(".fmt")) != 1) return Res;
	}
	
	int first_row= titles_row + 1; //skip titles row


const wchar_t* REQUEST = L"SELECT ISNULL(RB.BRAND_EXPORT,PRICELIST.Brand) AS 'BRAND', ISNULL(RC.CODE_EXPORT,PriceList.Code) AS 'CODE', PRICELIST.* FROM OPENROWSET( BULK '%s',FORMATFILE = '%s', FIRSTROW =%d) AS PRICELIST  LEFT JOIN REBRAND RB ON PRICELIST.Brand=RB.BRAND AND RB.CLI_ID = %s  LEFT JOIN RECODE RC ON RC.CODE=PRICELIST.Code AND PRICELIST.BRAND=RC.BRAND  AND RC.CLI_ID=%s ORDER BY PRICELIST.BRAND DESC, PRICELIST.CODE";
	Res.Format(REQUEST,sFileName,fmt,first_row,sID,sID);
	return Res;
}



bool ConvertationProcessing(CRecordset* Query, CString sID,CString sFileName, CString* Titles,CString*sError)
{
	setlocale(LC_ALL,"Russian");
	//CString sConnect;
	CString sSQL;
	CString sTitles=TitlesFromFile(sFileName);	
	BOOL titlesRow = ( sTitles.GetLength()>0 ? TRUE : FALSE ); //= isTitlesPresent(sFileName);

	sSQL = GenerateProcessingRequest(sID,sFileName,titlesRow);
	if (sSQL=="") return false;
    *Titles = sTitles;
	return Query->Open(CRecordset::snapshot, sSQL, CRecordset::readOnly)==TRUE;
}


bool LoadPrice_1(CDatabase* dBase ,CString sID,CString sFileName,CString*sError)
{
	setlocale(LC_ALL,"Russian");
	CString sConnect;
	try
	{
		 
		sConnect.Format(_T("DELETE FROM PRICE"));
		dBase->ExecuteSQL(sConnect);


		CStdioFile file;
		if(!file.Open(sFileName, CFile::modeRead))
		{
			sError->Format(_T("Не открыли файл %s"), sFileName);
			return 0;
		}


		CString sName;
		CString sBrand,sCode, sQuant, sEUR, sDesc, sSale;
		int iNum = 0;
		while(file.ReadString(sName))
				{
					
					if(sName.Right(1)!=";")
						sName = sName + _T(";");

					sBrand = "";
					sCode = "";
					sQuant = "";
					sEUR = "";
					sDesc = "";
					sSale = "";
					
					sBrand = sName.Left(sName.Find(_T(";")));
					sName = sName.Right(sName.GetLength()-	sBrand.GetLength()-1);

					sCode = sName.Left(sName.Find(_T(";")));
					sName = sName.Right(sName.GetLength()-	sCode.GetLength()-1);

					sQuant = sName.Left(sName.Find(_T(";")));
					sName = sName.Right(sName.GetLength()-	sQuant.GetLength()-1);

					sEUR = sName.Left(sName.Find(_T(";")));
					sName = sName.Right(sName.GetLength()-	sEUR.GetLength()-1);

					sDesc = sName.Left(sName.Find(_T(";")));
					sName = sName.Right(sName.GetLength()-	sDesc.GetLength()-1);

					sSale = sName.Left(sName.Find(_T(";")));
					sName = sName.Right(sName.GetLength()-	sSale.GetLength()-1);

					sBrand.Replace(_T("'"),_T("''"));
					sCode.Replace(_T("'"),_T("''"));
					sQuant.Replace(_T("'"),_T("''"));
					sEUR.Replace(_T("'"),_T("''"));
					sDesc.Replace(_T("'"),_T("''"));
					sSale.Replace(_T("'"),_T("''"));
					sName.Replace(_T("'"),_T("''"));
					iNum++;
					sConnect.Format(_T("INSERT INTO PRICE (ID, BRAND, CODE, QUANT, EUR, [DESC], SALE, COMMENT) SELECT %d,'%s','%s','%s','%s','%s','%s','%s'"),iNum,sBrand,sCode, sQuant, sEUR, sDesc, sSale, sName);
					dBase->ExecuteSQL(sConnect);

					
					if((bStop)||(bPause))
					{
						break;
					}
				}
			file.Close();
			
	
	}
	catch(CDBException* error)
		{
			sError->Format(_T("%s\n%s"),error->m_strError,sConnect);
			error->Delete();
			return FALSE;
		}

	WriteToLogFile(_T("Файл загружен"));
	return TRUE;

}


bool SaveRecordsetToFileCSV(CRecordset* Query, CString sTitles, CString sFileOut, CString *sError)
{

	CStdioFile sFile;
	WriteToLogFile(_T("Generate - ")+sFileOut);
	if(!sFile.Open(sFileOut,CFile::modeCreate|CFile::modeWrite) != 0)
	{
		sError->Format(_T("%s\n%s"),GetLastErrorText(), sFileOut);
		return FALSE;
	}

	
	int iMax;
	iMax = 0;
	
	int iList;
	iList = 0;
	short i;
	CString sValue;
	
	try{
			
			
			CString  sLine;//sValue,
			CDBVariant dbval;
				
			CODBCFieldInfo fieldInfo;
			CString sTableName;
			CString sFields;
			
			if(sTitles.GetLength()>0)
			{	
				i = 0;
				while(i<Query->GetODBCFieldCount()-1)//-submit native code, brand
				{
					i=sTitles.Find(';',++i);
					if (i<0)
						break; //incorrect csv Titles format
				}				
				if (i>0)
				 sFile.WriteString(sTitles+_T("\n"));					
			}

			while(!Query->IsEOF())	
			{
			
				CODBCFieldInfo fieldInfo;
				sValue = "";
				sLine = "";
				i=0;//1;
				
				if((bStop)||(bPause))
					{
						break;
					}

				while(i<Query->GetODBCFieldCount()-2)//-submit native code, brand
					{
						Query->GetFieldValue(i,dbval);
						sValue = GetValue(&dbval);
						sLine = sLine+sValue+_T(";");
						i++;
					}
				
				sLine = sLine.Left(sLine.GetLength()-1);
			
				if(sLine.GetLength()>0)
				{	
					sFile.WriteString(sLine+_T("\n"));
					
				}
				if((bStop)||(bPause))
					{
						break;
					}
				Query->MoveNext();			
				
			}

		Query->Close();
		sFile.Close();
		
	}
	catch(CDBException * error)
	{
		sError->Format(_T("%s\n%s"), error->m_strError,sValue);
		sFile.Close();
		return false;
	}
	

	return true;

	
	;

}

bool SaveRecordsetToFileXLS_(CRecordset* Query, CString sTitles, CString sFileOut, CString *sError)
{
	
	const int MAXLINES = 1048576 - 1;
	const wchar_t* SHEETNAME = L"DATA";//"PRICELIST"
	const wchar_t* EXCELDRIVER = L"Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)";
	const wchar_t* TEMPLATEXLSX=L"0.xlsx";


	if (CFileFind().FindFile(sPath + TEMPLATEXLSX)==TRUE)
		CopyFile(sPath + TEMPLATEXLSX,sFileOut,FALSE);//sPath +
	else
	{
		CString sMsg;
		sMsg.Format(_T("Template '%s' is not found - output format will be changed to binary Excel worksheet (*.xlsb)"),sPath + TEMPLATEXLSX);
		WriteToLogFile(sMsg);			
		CString sExt = _T(".xlsb");
		sFileOut = sPath + ChangeFileExt(sFileOut,sExt);
		//sFileOut.Format(_T("%s"),sPath + (LPCTSTR)sFileout+sExt);
		DeleteFile(sFileOut);
		*sError = sFileOut;
	}

	WriteToLogFile(_T("Generate - ")+sFileOut);	
	CDatabase* ExcelData;//CStdioFile sFile;
	//CString sDriver =  "Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)";	
	CString sSql;
	try
	{
		BOOL FirstRowHasTitles = (sTitles.GetLength()>0 ? TRUE : FALSE);
		//sSql.Format(_T("DRIVER={%s};DSN='Excel Files';READONLY=FALSE;DBQ=%s;DefaultDir=%s"), /*sDriver*/ EXCELDRIVER,sFileOut,sPath);
		sSql.Format(_T("DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DriverID=1046;DSN='Excel Files';FIRSTROWHASNAMES=%d;READONLY=FALSE;DBQ=%s;DefaultDir=%s"), /*sDriver,*/ FirstRowHasTitles, sFileOut,sPath);
		ExcelData = new(CDatabase);		
		if(!ExcelData->OpenEx(sSql,CDatabase::noOdbcDialog))
		{
			WriteToLogFile(_T("Не удалось соединиться с Excel"));
			delete(ExcelData);	
			sError->Format(_T("Не удалось соединиться с Excel"));
			return false;
		}	
//		sSql.Format("DROP TABLE [%s_0]",SHEETNAME);
//		ExcelData->ExecuteSQL(sSql);	//выполняется для в цикле для листа			
	}      
	catch(CDBException *exc)	
	{
		WriteToLogFile(_T(" ODBC Excel драйвер не установлен. - ") +exc->m_strError);
		sError->Format(_T("%s"), exc->m_strError);
		exc->Delete();
		if(ExcelData->IsOpen())
			ExcelData->Close();
		delete(ExcelData);	
		return false;
	}


	int i,j, iSheetNo;
	CString sSQL;
	CString sTableName; //CString sSheetName;
	CString sFields;
	try{		
        
		iSheetNo=0;			
		i=0;						
		while(!Query->IsEOF())
		{
			CDBVariant dbval;
			CString sLine;

			
			sLine = "";

			if(i % MAXLINES == 0)
				{					
					//CString sI;sI.Format(_T("%d==0"),i);WriteToLogFile(sI);//WriteToLogFile(_T("==0"));
					
					sTableName.Format(_T("%s%d"),SHEETNAME,iSheetNo);	//_			

					try{
						sSQL = _T("DROP TABLE [")+sTableName+_T("] ");
						ExcelData->ExecuteSQL(sSQL);
					}catch(CDBException * error){
					}

					sSQL = "";
					for(j=0;j<Query->GetODBCFieldCount()-2;j++) /*--1*/
					{
						CODBCFieldInfo fieldInfo;
						Query->GetODBCFieldInfo(j,fieldInfo);						
						sSQL = sSQL +_T("[")+fieldInfo.m_strName+_T("] TEXT, ");
						sFields = sFields +_T("[")+ fieldInfo.m_strName+_T("],");
					}
					sFields = sFields.Left(sFields.GetLength()-1);
					
					sSQL = _T("CREATE TABLE [")+sTableName+_T("] (")+sSQL.Left(sSQL.GetLength()-2)+ _T(")");
					ExcelData->ExecuteSQL(sSQL);
					iSheetNo++;
				}

			if((bStop)||(bPause))
			{
				break;
			}

			for(j=0;j<Query->GetODBCFieldCount()-2;j++)//j=1;while(j<Query.GetODBCFieldCount())j++;
			{
				CString sVal;
				Query->GetFieldValue(j,dbval);
				sVal = GetValue(&dbval);
				sVal.Replace(_T("'"),_T("''"));
				sLine = sLine+_T("'")+sVal+_T("',");
				
			}
			sLine = sLine.Left(sLine.GetLength()-1);
				
			if(sLine.GetLength()>0)
			{	
				sSQL = _T("INSERT INTO [") +sTableName +_T("] (")+sFields+_T(") VALUES (")+sLine+_T(")");
				ExcelData->ExecuteSQL(sSQL);
			}
			
			Query->MoveNext();			
			i++;
		}
		Query->Close();
		
		

		if(ExcelData->IsOpen())
			ExcelData->Close();
		
		delete(ExcelData);
	}
	catch(CDBException * error){
		sError->Format(_T("%s\n%s"), error->m_strError,sSQL);
		//sFile.Close();
		return false;
	}

	WriteToLogFile(_T("Выполнено"));
	
	return true;
}

CString SaveRecordsetToFile(CRecordset* Query, CString sTitles, CString sAttach, CString sFormatExt, BOOL bArchiv, CString *sError)
{
	CString sRet;
	sRet = "";
	
	//***if ( (*Query).IsOpen == FALSE) return sRet;
	
	CString sExt;
	sExt = sFormatExt;
	WriteToLogFile(_T("Создаем выходной файл"));
	
	CString sFileOut,sArrayOut;	

	if(sFileOut.GetLength() < 2)
		sFileOut.Format(_T("%s"),sPath + sAttach+sExt);

	if(sArrayOut.GetLength() < 2)
		sArrayOut.Format(_T("%s"),sPath + sAttach+_T(".zip"));	

	
	
	DeleteFile(sFileOut);
	DeleteFile(sArrayOut);	
	
	
	if (sFormatExt==_T(".csv"))
	{
		if(SaveRecordsetToFileCSV(Query, sTitles, sFileOut, sError)) 
			sRet=sFileOut;
		else return sRet;//"";

	}
	else if (sFormatExt==_T(".xlsx"))
	{
			*sError="";
			if(SaveRecordsetToFileXLS_(Query, sTitles, sFileOut, sError)) 
			{
				if (sError->StringLength(*sError)>0) sFileOut=*sError;
				sRet=sFileOut;
			}
			else return sRet;//""	
	}	
	else return sRet;//""
	
	if(bArchiv)
	{
		CZipArchive archiv;
		archiv.Open(sArrayOut,CZipArchive::create);
		archiv.AddNewFile(sFileOut,5,FALSE);
		archiv.Close();
		sRet = sArrayOut;
	}
//	else
//	{
//		sRet = sFileOut;
//	}
	
	WriteToLogFile(_T("Выполнено"));
	return sRet;
}




CString Create_CSVFilePrice(CDatabase* dBase, CString sID, CString sAttach, BOOL bArchiv, CString *sError)
{
	CString sRet;
	sRet = "";
	WriteToLogFile(_T("Создаем файл обновления"));
	CString sFileOut,sArrayOut;
	if(sFileOut.GetLength() < 2)
		sFileOut.Format(_T("%s"),sPath + sAttach+_T(".csv"));

	if(sArrayOut.GetLength() < 2)
		sArrayOut.Format(_T("%s"),sPath + sAttach+_T(".zip"));

	

	DeleteFile(sFileOut);
	DeleteFile(sArrayOut);

	CStdioFile sFile;
	WriteToLogFile(_T("Generate - ")+sFileOut);
	if(!sFile.Open(sFileOut,CFile::modeCreate|CFile::modeWrite) != 0)
	{
		sError->Format(_T("%s\n%s"),GetLastErrorText(), sFileOut);
		return FALSE;
	}

	
	int iMax;
	iMax = 0;
	
	int iList;
	iList = 0;
	short i;
	CString sSQL;
	
	try{
			/*
				sSQL.Format("UPDATE PRICE SET PRICE.CODEVIS = [PRICE]![CODE]");
				dDB->ExecuteSQL(sSQL);
			*/
			
			sSQL.Format(_T("UPDATE [PRICE]	SET [PRICE].[CODE] = [RECODE].[CODE_EXPORT]	FROM [PRICE], [RECODE] WHERE [PRICE].[BRAND] = [RECODE].[BRAND] AND [PRICE].[CODE] = [RECODE].[CODE] AND [CLI_ID] = %s"),sID);
			dBase->ExecuteSQL(sSQL);
			
			//sSQL.Format("UPDATE PRICE, BRANDS SET PRICE.BRAND = [BRANDS]![BRANDVIS] WHERE [BRANDS]![BRAND]=[PRICE]![BRAND] AND [BRANDS]![ID]= %d",iUserID);
			sSQL.Format(_T("UPDATE [PRICE] SET [PRICE].[BRAND] = [REBRAND].[BRAND_EXPORT] FROM [PRICE], [REBRAND] WHERE [PRICE].[BRAND] = [REBRAND].[BRAND] AND CLI_ID = %s"),sID);
			dBase->ExecuteSQL(sSQL);

		
			sSQL.Format(_T("SELECT * FROM PRICE"));	
			
			
			CRecordset Query(dBase);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			
			sSQL = "";
			CString sValue, sName;
			CDBVariant dbval;
				
			CODBCFieldInfo fieldInfo;
			CString sTableName;
			CString sFields;
			
			while(!Query.IsEOF())	
			{
			
				CODBCFieldInfo fieldInfo;
				sSQL = "";
				sName = "";
				i=1;
				
				if((bStop)||(bPause))
					{
						break;
					}

				while(i<Query.GetODBCFieldCount())
					{
						Query.GetFieldValue(i,dbval);
						sSQL = GetValue(&dbval);
						sName = sName+sSQL+_T(";");
						i++;
					}
				
				sName = sName.Left(sName.GetLength()-1);
			
				if(sName.GetLength()>0)
				{	
					sFile.WriteString(sName+_T("\n"));
					
				}
				if((bStop)||(bPause))
					{
						break;
					}
				Query.MoveNext();			
				
			}

		Query.Close();
		sFile.Close();
	}
	catch(CDBException * error)
	{
		sError->Format(_T("%s\n%s"), error->m_strError,sSQL);
		sFile.Close();
		return sRet;
	}
	
	if(bArchiv)
	{
		CZipArchive archiv;
		archiv.Open(sArrayOut,CZipArchive::create);
		archiv.AddNewFile(sFileOut,5,FALSE);
		archiv.Close();
		sRet = sArrayOut;
	}
	else
	{
		sRet = sFileOut;
	}
	WriteToLogFile(_T("Выполнено"));
	return sRet;

}




CString Create_XLSXFilePrice(CDatabase* dBase, CString sID, CString sAttach, BOOL bArchiv, CString *sError)
{
	CString sRet;
	sRet = "";
	CString sExt;
	sExt = ".xlsx";

	const int MAXLINES = 1048576 - 1;
	const wchar_t* SHEETNAME = L"DATA";//"PRICELIST"
	const wchar_t* EXCELDRIVER = L"Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)";
	const wchar_t* TEMPLATEXLSX=L"0.xlsx";




	WriteToLogFile(_T("Создаем файл обновления"));
	CString sFileOut,sArchOut;
	if(sFileOut.GetLength() < 2)
		sFileOut.Format(_T("%s"),sPath + sAttach+sExt);//_T(".xlsb");//x

	if(sArchOut.GetLength() < 2)
		sArchOut.Format(_T("%s"),sPath + sAttach+_T(".zip"));

	

	DeleteFile(sFileOut);
	DeleteFile(sArchOut);

	

	if (CFileFind().FindFile(sPath + TEMPLATEXLSX)==TRUE)
		CopyFile(sPath + TEMPLATEXLSX,sFileOut,FALSE);//sPath +
	else
	{
		sFileOut.Format(_T("Template '%s' is not found - output format will be changed to binary Excel worksheet (*.xlsb)"),sPath + TEMPLATEXLSX);
		WriteToLogFile(sFileOut);			
		sExt = _T(".xlsb");
		sFileOut.Format(_T("%s"),sPath + sAttach+sExt);
		DeleteFile(sFileOut);
	}

	WriteToLogFile(_T("Generate - ")+sFileOut);	
	CDatabase* ExcelData;//CStdioFile sFile;
	//CString sDriver =  "Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)";	
	CString sSql;
	try
	{
		
		//sSql.Format(_T("DRIVER={%s};DSN='Excel Files';READONLY=FALSE;DBQ=%s;DefaultDir=%s"), /*sDriver*/ EXCELDRIVER,sFileOut,sPath);
		sSql.Format(_T("DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DriverID=1046;DSN='Excel Files';FIRSTROWHASNAMES=1;READONLY=FALSE;DBQ=%s;DefaultDir=%s"), /*sDriver*/ sFileOut,sPath);
		ExcelData = new(CDatabase);		
		if(!ExcelData->OpenEx(sSql,CDatabase::noOdbcDialog))
		{
			WriteToLogFile(_T("Не удалось соединиться с Excel"));
			delete(ExcelData);	
			sError->Format(_T("Не удалось соединиться с Excel"));
			return sRet;
		}	
//		sSql.Format("DROP TABLE [%s_0]",SHEETNAME);
//		ExcelData->ExecuteSQL(sSql);	//выполняется для в цикле для листа			
	}      
	catch(CDBException *exc)	
	{
		WriteToLogFile(_T(" ODBC Excel драйвер не установлен. - ") +exc->m_strError);
		sError->Format(_T("%s"), exc->m_strError);
		exc->Delete();
		if(ExcelData->IsOpen())
			ExcelData->Close();
		delete(ExcelData);	
		return sRet;
	}


	int i,j, iSheetNo;
	CString sSQL;
	CString sTableName; //CString sSheetName;
	CString sFields;
	try{
		sSQL.Format(_T("UPDATE [PRICE]	SET [PRICE].[CODE] = [RECODE].[CODE_EXPORT]	FROM [PRICE], [RECODE] WHERE [PRICE].[BRAND] = [RECODE].[BRAND] AND [PRICE].[CODE] = [RECODE].[CODE] AND [CLI_ID] = %s"),sID);
		dBase->ExecuteSQL(sSQL);			
		
		sSQL.Format(_T("UPDATE [PRICE] SET [PRICE].[BRAND] = [REBRAND].[BRAND_EXPORT] FROM [PRICE], [REBRAND] WHERE [PRICE].[BRAND] = [REBRAND].[BRAND] AND CLI_ID = %s"),sID);
		dBase->ExecuteSQL(sSQL);   
		
		sSQL.Format(_T("SELECT * FROM PRICE"));	
		CRecordset Query(dBase);
		Query.Open(CRecordset::snapshot, sSQL, CRecordset::readOnly); 
		
        
		iSheetNo=0;			
		i=0;						
		while(!Query.IsEOF())
		{
			CDBVariant dbval;
			CString sLine;

			
			sLine = "";

			if(i % MAXLINES == 0)
				{					
					//CString sI;sI.Format(_T("%d==0"),i);WriteToLogFile(sI);//WriteToLogFile(_T("==0"));
					
					sTableName.Format(_T("%s%d"),SHEETNAME,iSheetNo);	//_			

					try{
						sSQL = _T("DROP TABLE [")+sTableName+_T("] ");
						ExcelData->ExecuteSQL(sSQL);
					}catch(CDBException * error){
					}

					sSQL = "";
					for(j=1;j<Query.GetODBCFieldCount();j++)
					{
						CODBCFieldInfo fieldInfo;
						Query.GetODBCFieldInfo(j,fieldInfo);						
						sSQL = sSQL +_T("[")+fieldInfo.m_strName+_T("] TEXT, ");
						sFields = sFields +_T("[")+ fieldInfo.m_strName+_T("],");
					}
					sFields = sFields.Left(sFields.GetLength()-1);
					
					sSQL = _T("CREATE TABLE [")+sTableName+_T("] (")+sSQL.Left(sSQL.GetLength()-2)+ _T(")");
					ExcelData->ExecuteSQL(sSQL);
					iSheetNo++;
				}

			if((bStop)||(bPause))
			{
				break;
			}

			for(j=1;j<Query.GetODBCFieldCount();j++)//j=1;while(j<Query.GetODBCFieldCount())j++;
			{
				CString sVal;
				Query.GetFieldValue(j,dbval);
				sVal = GetValue(&dbval);
				sVal.Replace(_T("'"),_T("''"));
				sLine = sLine+_T("'")+sVal+_T("',");
				
			}
			sLine = sLine.Left(sLine.GetLength()-1);
				
			if(sLine.GetLength()>0)
			{	
				sSQL = _T("INSERT INTO [") +sTableName +_T("] (")+sFields+_T(") VALUES (")+sLine+_T(")");
				ExcelData->ExecuteSQL(sSQL);
			}
			
			Query.MoveNext();			
			i++;
		}
		Query.Close();
		
		

		if(ExcelData->IsOpen())
			ExcelData->Close();
		
		delete(ExcelData);
	}
	catch(CDBException * error){
		sError->Format(_T("%s\n%s"), error->m_strError,sSQL);
		//sFile.Close();
		return sRet;
	}

	if(bArchiv)
	{
		CZipArchive archiv;
		archiv.Open(sArchOut,CZipArchive::create);
		archiv.AddNewFile(sFileOut,5,FALSE);
		archiv.Close();
		sRet = sArchOut;
	}
	else
	{
		sRet = sFileOut;
	}
	WriteToLogFile(_T("Выполнено"));

	return sRet;
}

bool StartExport(CDatabase * dBase,stBases * m_stBases, CString* sError)
{
	
	CString sFileName;
	CString sAttachFile;
	HANDLE bWorking;
	WIN32_FIND_DATA findData;
	bWorking = FindFirstFile(m_stBases->sFilePrice,&findData);
	if (bWorking==INVALID_HANDLE_VALUE)
		return FALSE;
	
	sFileName = 	m_stBases->sFilePrice;		
	do
	{
		sFileName = sFileName.Left(sFileName.ReverseFind('\\'));
		sFileName =sFileName+_T("\\")+ findData.cFileName;
		CString sMess;
		sMess.Format(_T("Найден Файл %s"),sFileName);
		WriteToLogFile(sMess);
		break;
	}
	while (FindNextFile(bWorking,&findData)!=0);
		FindClose(bWorking);
/* Exclude because loading and converting implemented in SQL request, saving carried out is separate procedure  [refactoring]
	switch(m_stBases->iType)
	{
		case 1:
			if(!LoadPrice_1(dBase,m_stBases->sID,sFileName,sError))
				return FALSE;
			break;
		
		
		default:
			return FALSE;
	}
*/
	CRecordset Query(dBase);
	CString sTitles = _T("");
	try{
		if(ConvertationProcessing(&Query,m_stBases->sID,m_stBases->sFilePrice,&sTitles,sError))
			switch(m_stBases->iTypeExport)
			{
				case 1:
					sAttachFile = SaveRecordsetToFile(&Query,sTitles,m_stBases->sAttach,_T(".xlsx"),m_stBases->bArchiv,sError);//Create_XLSXFilePrice(dBase,m_stBases->sID,m_stBases->sAttach,m_stBases->bArchiv,sError);
					break;
				case 3:
					sAttachFile = SaveRecordsetToFile(&Query,sTitles,m_stBases->sAttach,_T(".csv"),m_stBases->bArchiv,sError);//Create_CSVFilePrice(dBase,m_stBases->sID,m_stBases->sAttach,m_stBases->bArchiv,sError);
					break;
				default:
					return FALSE;
			}
		else return false;
	}catch(CDBException* error){
		CString sMsg = *sError;
		sError->Format(_T("%s\n%s"),error->m_strError, sMsg);//(LPSTR)*sError
		WriteToLogFile(*sError);
	}
	
	if(sAttachFile.GetLength()<3)
	{
		return TRUE;
	}

	if((bStop)||(bPause))
	{
		return FALSE;
	}

	if (m_stBases->sCopyTo.GetLength() >= 3)
	{
		CString sMess;
		if (CopyFile(sAttachFile, m_stBases->sCopyTo, 0) != 0)
		{
			sMess.Format(_T("Скопирован в %s"), m_stBases->sCopyTo);
			WriteToLogFile(sMess);
		}
		else
		{
			sMess.Format(_T("!Ошибка копирования в %s"), m_stBases->sCopyTo);
			WriteToLogFile(sMess);
		}
	}
	
	/*
	SELECT TOP 1000 [ID]
      ,[From]
      ,[TO]
      ,[SUBJECT]
      ,[BODY]
      ,[ATTACH]
      ,[ERROR]
  FROM [exports].[dbo].[EMAIL_MESSAGE]
	*/
	CString sMailServer;
	sMailServer = m_stBases->sTo;
	int iFind;
	iFind = sMailServer.Find(_T(";"));
	while(iFind > 0)
	{
		if(iFind>0)
		{
			WriteToLogFile(_T("Добавление письма в очередь\t")+sMailServer.Left(iFind));
			if(!AddToMail(dBase, m_stBases->sFrom,sMailServer.Left(iFind),m_stBases->sSubject,_T(""),sAttachFile))
			{
				WriteToLogFile(_T("Письмо не добавленно\t")+sMailServer.Left(iFind));
			}
		}
		sMailServer = sMailServer.Right(sMailServer.GetLength()-iFind-1);
		iFind = sMailServer.Find(_T(";"));
	}

	/*
	CSMTPConnection smtp;
	CString sMailServer;
	sMailServer = sReadFromIni(_T("E-MAIL"),_T("SERVER"),_T("10.0.0.144"));
	int iPort = _wtoi(sReadFromIni(_T("E-MAIL"),_T("PORT"),_T("25")));
	
	
	smtp.SetTimeout(5000);
	if (!smtp.Connect(sMailServer,iPort))
	{
		CString sResponse = smtp.GetLastCommandResponse();
		sError->Format(_T("SMTP - CONNECT %s (%s)"),sResponse,sMailServer);
		WriteToLogFile(*sError);
		return FALSE;
	}
	
	CSMTPMessage m;
	CSMTPAddress From(m_stBases->sFrom); //Change these values to your settings
	WriteToLogFile(_T("FROM ")+m_stBases->sFrom);
	m.m_From = From;
	int iFind;
	
	sMailServer = m_stBases->sTo;
	WriteToLogFile(_T("TO ")+sMailServer);
	iFind = sMailServer.Find(_T(";"));

	while(iFind > 0)
	{
		if(iFind>0)
		{
			CSMTPAddress To(sMailServer.Left(iFind));   //Change these values to your settings
			WriteToLogFile(_T("\t")+sMailServer.Left(iFind));
			m.AddRecipient(To, CSMTPMessage::TO);
		}
		sMailServer = sMailServer.Right(sMailServer.GetLength()-iFind-1);
		iFind = sMailServer.Find(_T(";"));
	}
	
	m.m_sSubject = m_stBases->sSubject;
	
	
	CSMTPAttachment attachment;
	attachment.Attach(sAttachFile);
	m.AddAttachment(&attachment);
	if (!smtp.SendMessage(m))
	{
		CString sResponse = smtp.GetLastCommandResponse();
		sError->Format(_T("SMTP - SendMessage %s"),sResponse);
		WriteToLogFile(*sError);
		return FALSE;
	}

	if(!smtp.Disconnect())
	{
		CString sResponse = smtp.GetLastCommandResponse();
		sError->Format(_T("SMTP - SendMessage %s"),sResponse);
		WriteToLogFile(*sError);
		return FALSE;
	}
	*/

	WriteToLogFile(_T("В очереди на отправку"));
	DeleteFile(sFileName);
	return TRUE;
}



void Run()
{
	WriteToLogFile(_T("Начало работы"));
	int iIterVal; 
	iIterVal = 0;
	int iMaxCount;
	
	CDatabase * dBase;
	dBase = NULL;

	CString sError;
	CString sOldError;
	sOldError = "";
	
	stBases * massBases;
	massBases = NULL;
	iMaxCount = 0;
	sError = "";
	while(!bStop)
	{
		
		if(sError != sOldError)
		{
			if(sError.GetLength()>0)
			{
				WriteToLogFile(_T("Error - ")+sError);	
			}
			else
			{
				WriteToLogFile(_T("Прекратилась - ")+sOldError);	
			}
			sOldError = sError;
		}

		sError = "";
		if(iIterVal > 0)
		{
			iIterVal = iIterVal - 500;
			Sleep(500);
			continue;
		}

		if (bPause)
		{
			Sleep(500);
			continue;
		}
		
		iIterVal = _wtoi(sReadFromIni(_T("BASE"),_T("INTERVAL"),_T("60000")));
		if(!bOpenDatabase(&dBase, &sError))
		{
			continue;
		}
		
		//massBases
		if(bStop)
		{
			CloseDatabase(&dBase);
			continue;
		}

		//iMaxCount
		PostEmailMessages(dBase);
		if(!bLoadExports(dBase,&massBases,&iMaxCount, &sError))
		{
			CloseDatabase(&dBase);
			continue;
		}
		
		while(iMaxCount > 0)
		{
			iMaxCount--;
			if(bStop)
			{
				iIterVal = 0;
				break;
			}
			
			StartExport(dBase,&massBases[iMaxCount],&sError);		
		}
		PostEmailMessages(dBase);
		CloseDatabase(&dBase);
	}
}

void WINAPI ServiceMain(DWORD dwArgc, LPTSTR *psArgv)
{
	ssHandle = RegisterServiceCtrlHandler(ServiceName, ServiceHandler);
	sStatus.dwCheckPoint = 0;
	sStatus.dwWaitHint = 0;
	
	sStatus.dwControlsAccepted = SERVICE_ACCEPT_STOP 
							| SERVICE_ACCEPT_SHUTDOWN
							| SERVICE_ACCEPT_PAUSE_CONTINUE;	
	sStatus.dwServiceType = SERVICE_WIN32_OWN_PROCESS;	
	sStatus.dwWin32ExitCode = NOERROR;
	sStatus.dwServiceSpecificExitCode = 0;

	DWORD Err, SpecErr;

	BeginSendPending(SERVICE_START_PENDING);
	if (!Init(&Err, &SpecErr))
	{
		EndSendPending();
		sStatus.dwCurrentState = SERVICE_STOPPED;
		sStatus.dwWin32ExitCode = Err;
		sStatus.dwServiceSpecificExitCode = SpecErr;
		SetServiceStatus(ssHandle, &sStatus);
		return;
	}
	EndSendPending();
	sStatus.dwCurrentState = SERVICE_RUNNING;
	SetServiceStatus(ssHandle, &sStatus);
	Run();
}




int _tmain(int argc, TCHAR* argv[], TCHAR* envp[])
{
	

	wchar_t cBuffer[MAX_PATH];
    ::GetModuleFileName(NULL, cBuffer, MAX_PATH);
    sPath = cBuffer;
    sPath = sPath.Left(sPath.ReverseFind('\\'));
	if (sPath.Right(1)!="\\") sPath += "\\";

	//*/
	int nRetCode = 0;
	bStop = FALSE;
	bPause = FALSE;
	if (!AfxWinInit(::GetModuleHandle(NULL), NULL, ::GetCommandLine(), 0))
	{
		nRetCode = 1;
		return nRetCode;
	}

	if (argc > 1)
	{
		CString sVal;
		sVal = argv[1];
		sVal.MakeLower();
		if ((sVal == _T("/install"))||(sVal == _T("-install")))
		{
			Install();			
		}
		else if ((sVal ==("/uninstall"))||(sVal ==("-uninstall")))
		{
			Uninstall();
		}
		return 0;
	}
	

	CString sFileName;
	sFileName = AfxGetApp()->m_pszProfileName;
	sFileName.MakeLower();
	if(sFileName.Right(4)!=_T(".ini"))
		sFileName = sFileName + _T(".ini");
	free((void*)AfxGetApp()->m_pszProfileName);
	AfxGetApp()->m_pszProfileName = _tcsdup(sPath+sFileName);
	
	SERVICE_TABLE_ENTRY steTable[] = 
	{
		{ServiceName, ServiceMain},
		{NULL, NULL}
	};
	//Run();
	StartServiceCtrlDispatcher(steTable);
	return nRetCode;
}



CString ReplaceLeftSymbols(CString sText, int iType)
{

	CString sRet, sMask;
	sRet = "";
	sMask = "";
	wchar_t ch;
	for(ch = _T('0');ch <= _T('9');ch++)
	{
		sMask = sMask + ch;
	}
	
	int i;
	for(i = 0; i < sText.GetLength();i++)
	{
		if(sMask.Find(sText[i])>-1)
		{
			sRet = sRet + sText[i];
		}
	}

	return sRet;
}


