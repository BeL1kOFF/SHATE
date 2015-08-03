// Nav_Export.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "Nav_Export.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// The one and only application object



void WriteToLogFile(CString sWrite)
{
	setlocale(LC_ALL,"Russian");
	
	CTime time;
	CStdioFile oFile;
	time = time.GetCurrentTime();
	if(!oFile.Open(sPath+_T("nav_export.log"),CFile::modeReadWrite))
		if(!oFile.Open(sPath+_T("nav_export.log"),CFile::modeCreate|CFile::modeWrite))
			return;
		
		oFile.SeekToEnd();
		oFile.WriteString(time.Format("%y%m%d %H:%M")+_T("\t")+sWrite+_T("\n"));
		oFile.Close();
}



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

CString sReplaceLeftSynmbol(CString sData)
{
	sData.Replace(_T(";"),_T(" "));
	sData.Replace(_T("\n"),_T(" "));
	sData.Replace(_T("\r"),_T(" "));
	sData.Replace(_T("\t"),_T(" "));
	return sData;
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
    
	CloseHandle(hEndEvent);
	while(sStatus.dwCurrentState != SERVICE_STOPPED)
	{
		Sleep(50);
	}
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

CString sReadFromIni(CString strSection, CString strKey, CString sDefValue =_T(""))
{
	wchar_t pstrString[MAX_PATH];
	CString sFileName;
	sFileName = AfxGetApp()->m_pszProfileName;
	sFileName.MakeLower();
	
	if(!GetPrivateProfileString(strSection, strKey,sDefValue, pstrString,MAX_PATH, sFileName))
		return sDefValue;
	CString strString;
	strString =pstrString;

	return strString;
}

bool sWriteToIni(CString strSection, CString strKey, CString sValue)
{
	CString sFileName;
	sFileName = AfxGetApp()->m_pszProfileName;
	sFileName.MakeLower();
	if (WritePrivateProfileString(strSection, strKey, sValue, sFileName))
		return TRUE;
	else
		return FALSE;
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



CString EXPORT_TYPE_1(int iPosition)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	//sPos
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказан файл выгрузки");
		return sError;
	}

	CStdioFile stFile;
	CFileException exFile;
	sFileName = sFileName + _T("_export");
	if(!stFile.Open(sFileName,CFile::modeCreate|CFile::modeWrite))
	{
		sError.Format(_T("Немогу открыть файл выгрузки :%s, %s"),sFileName,GetLastErrorText());
		return sError;
	}

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}
	CString sConnect;
	CString sServer, sDatabase;

	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));
	
	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		stFile.Close();
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}

	if(dBase!=NULL)
	{
		CString sSQL;
		CRecordset Query(dBase);
		int iField;
		CDBVariant dbValue;

		CStringArray sMarketsArray;
		try
		{
			
			sFileName = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));
			sSQL.Format(_T("select Code from [%s$Location] where Code like '%s' order by Code"),sDatabase,sFileName);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sSQL = GetValue(&dbValue);
				sMarketsArray.Add(sSQL);
				Query.MoveNext();

				if((bStop)||(bPause))
				{
					break;
				}
			}
			Query.Close();



			if(sMarketsArray.GetCount() < 1)
			{
				WriteToLogFile(_T("Список складов не получен!"));
			}
			else
			{

				int iIter;
				CString sWrite, sTest;
				for(iIter = 0;iIter<sMarketsArray.GetCount();iIter++)
				{
					
					if((bStop)||(bPause))
						{
							break;
						}
					WriteToLogFile(sMarketsArray.ElementAt(iIter));
					sSQL.Format(_T("select [No_ 2], mn.[Trade Mark Name], [Item No_], su.[Maximum Inventory] from [%s$Stockkeeping Unit] as su left join [%s$Item] as it on su.[Item No_] = [No_] left join [tm] as mn on it.[TM Code] = mn.[Trade Mark Code] where su.[Location Code] = '%s' and su.[Maximum Inventory] > 0"),sDatabase,sDatabase, sMarketsArray.ElementAt(iIter));
					Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
					while(!Query.IsEOF())
					{
						sWrite = "";
						if((bStop)||(bPause))
						{
							break;
						}
						for(iField = 0;iField<4;iField++)
						{
							if((bStop)||(bPause))
							{
								break;
							};
							Query.GetFieldValue(iField, dbValue);
							//При этом необходимо 
							if(iField == 3)
							{
								sTest = GetValue(&dbValue);
								sTest.Replace(_T(","),_T("."));
								if(sTest.Find(_T(".")) > 0)
								{
									sTest = sTest.Left(sTest.Find(_T(".")));
								}
							}
							else
							{
								sTest = GetValue(&dbValue);
								sTest.Replace(_T("\n"),_T(""));
								sTest.Replace(_T("\r"),_T(""));
							}
							sWrite = sWrite+sTest+_T(";");
						}
						stFile.WriteString(sWrite+sMarketsArray.ElementAt(iIter)+_T("\n"));
						Query.MoveNext();
					}
					Query.Close();
				}
			
			}
			sMarketsArray.RemoveAll();
		}	
		catch(CDBException *exsept)
		{
			stFile.Close();
			sMarketsArray.RemoveAll();
			sError.Format(_T("%s\n%s"),exsept->m_strError,sSQL);
			exsept->Delete();
			if(dBase != NULL)
			{
				if(dBase->IsOpen())
				{
					dBase->Close();
				}
				delete(dBase);
			}
			dBase = NULL;
			return sError;
		}
	}
	stFile.Close();
	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
	}
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if((!bStop)&&(!bPause))
	if(!DeleteFile(sFileName))
	{
		DWORD Err;
		Err = GetLastError();
		if(Err != 2)
		{
			sError.Format(_T("Errror %d"),Err);
		}
		else
		{
			CFile::Rename(sFileName + _T("_export"),sFileName);
		}
	}
	else
	{
		CFile::Rename(sFileName + _T("_export"),sFileName);
	}
	return sError;
}



CString EXPORT_TYPE_2(int iPosition, CString sOldDate)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	CStringArray sFileArray;
	CDBVariant dbValue;

	CString sTHO;
	sTHO = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));

	CString sFilter;
	sFilter = sReadFromIni(sPos,_T("PARAMETR_1"),_T(""));

	if(sFilter.GetLength()>0)
	{
		sFilter = _T(" and ")+ sFilter; 
	}

	//sPos
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказана директория выгрузки");
		return sError;
	}

	if(sFileName.Right(1)!=_T("\\"))
		sFileName = sFileName + _T("\\");

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}

	CString sSQL;
	if(dBase!=NULL)
	{	
		
		sFileArray.RemoveAll();
		CStringArray sDocArray;

		sSQL.Format(_T("select distinct tsh.[No_], tsh.[TTN Series]+tsh.[TTN Number] as tt, 'TN' as TN,tsh.[TTN Series], tsh.[TTN Number],CONVERT ( nchar ,tsh.[Posting Date], 104) as Dat from [%s$Transfer Shipment Header] as tsh where tsh.[Sales Process Type Code] = '%s' and tsh.[TTN Number] <> ''   and Left(CONVERT ( nchar , tsh.[TN_TTN Print Date_Time], 112),8) >= '%s' and Left(CONVERT ( nchar , tsh.[TN_TTN Print Date_Time], 112),8) <= '%s' order by tt"),sDatabase,sTHO,sOldDate.Left(8),sOldDate.Left(8));
		CRecordset Query(dBase);
		CRecordset Query1(dBase);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		short i;
		sDocArray.RemoveAll();
		while(!Query.IsEOF())
		{
			sSQL = "";
			for(int i = 0; i < 6; i++)
			{
				Query.GetFieldValue(i, dbValue);
				sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
			}
			sDocArray.Add(sSQL);
			if((bStop)||(bPause))
				{
					sError = _T("Прервано");
					break;
				}
			Query.MoveNext();		
		}
		Query.Close();

		CStdioFile stFile;
		CString sValue;
		CString sDocNumber;

		int iPos;
		CString sOldFile;
		sOldFile = "";
		if((!bStop)&&(!bPause))
		try
		{
			while(sDocArray.GetCount()>0)
			{
				sValue = sDocArray.ElementAt(0);
				iPos = sValue.Find(_T(";"),0);
				if(iPos < 2)
				{
					sDocArray.RemoveAt(0,1);
					continue;
				}
				sDocNumber = sValue.Left(iPos);
			
				sValue = sValue.Right(sValue.GetLength() - iPos -1);
				iPos = sValue.Find(_T(";"),0);
				if(iPos < 2)
				{
					sDocArray.RemoveAt(0,1);
					continue;
				}	

				if(sOldFile != sValue.Left(iPos))
				{
					sOldFile = sValue.Left(iPos);
					
					if(!stFile.Open(sFileName+sOldFile+_T(".txt"),CFile::modeCreate|CFile::modeWrite))
					{
						sError = GetLastErrorText()+_T("\t")+sFileName+sOldFile;
						break;
					}
					sFileArray.Add(sFileName+sOldFile+_T(".txt"));
					sValue = sValue.Right(sValue.GetLength() - iPos -1);
					stFile.WriteString(sValue+_T("\n"));
				
				}
				else
				{
					stFile.Open(sFileName+sOldFile+_T(".txt"),CFile::modeReadWrite);
					stFile.SeekToEnd();
				}
			
				//sFilter
				sSQL.Format(_T("select tsl.[Line No_],cdr.[Source Item Ledger Entry No_],cdr.[CD No_],(it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode,it.[Description 2], cdr.[Quantity]*-1,coalesce((select '10.9' from [%s$Item item group] as [iig] join [%s$Item group] as ig on  [iig].[Item Group Node Id] = ig.[nodeid] join [%s$Item group] as ig1 on ig1.[nodeid] = ig.[parentid] join [%s$Item group] as ig2 on ig2.[nodeid] = ig1.[parentid] where iig.[Item No_]  = it.[No_] and [iig].[Item Group Type Code] = 'ТОВЛИНИЯ' %s),'10.5') from [%s$Transfer Shipment Line] as tsl join [%s$Item] as it on tsl.[Item No_] = it.[No_] join [tm] on it.[TM Code] = tm.[Trade Mark Code] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = tsl.[Document No_] and cdr.[Line No_] = tsl.[Line No_] where tsl.[Document No_] = '%s'"),sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sDatabase,sDatabase,sDatabase,sDocNumber);
		
				Query.Open(CRecordset::snapshot ,sSQL,CRecordset::readOnly);
					
				CString sItemEntry,sCDR;
				int iCount;	
				double dVal,dSumm;
				while(!Query.IsEOF())
				{
					if((bStop)||(bPause))
					{
						
						sError = _T("Прервано");
						break;
					}
					i = 0;
					Query.GetFieldValue(i, dbValue);
					sValue = GetValue(&dbValue);

					i = 1;
					Query.GetFieldValue(i, dbValue);
					sItemEntry = GetValue(&dbValue);

					i = 2;
					Query.GetFieldValue(i, dbValue);
					sCDR = GetValue(&dbValue);
						
					sSQL.Format(_T("select [Item Charge No_],[Acc_ Cost per Unit], cdr.[CD No_], cdh.[Country_Region of Origin Code], eep.NAME from [%s$Custom Declaration Relation] as cdr left join [%s$Value Entry] as ve on (ve.[Item Ledger Entry Type] = 0 or ve.[Item Ledger Entry Type] = 1 or ve.[Item Ledger Entry Type] = 2) and   ve.[Item Ledger Entry No_] = cdr.[Source Item Ledger Entry No_] and  ve.[Expected Cost] = 0 and ve.[Entry Type] = 0 left join [%s$Item Charge] as ic on  ic.[No_] = ve.[Item Charge No_] left join [%s$Custom Declaration Line] as cdh on cdh.[CD No_] = cdr.[CD No_] and cdh.[CD Line No_] = cdr.[CD Line No_] left join [Country_Region] as eep on eep.[Code] = cdh.[Country_Region of Origin Code] where ((ic.[Include in Accounting Cost] = 1)or(ve.[Item Charge No_] = ''))  and cdr.[Document No_] = '%s' and cdr.[Line No_] = %s and ( (ve.[Item Ledger Entry Type] = 0) OR(	(ve.[Item Ledger Entry Type] = 1) AND(ve.[Document Type] = 4) ) OR  ((	(ve.[Document Type] = 14) OR (ve.[Document Type] = 16)) AND	(ve.[Item Ledger Entry Type] = 2)) OR ((ve.[Item Ledger Entry Type] = 2) AND (ve.[Document No_] = 'START STOCK'))) and cdr.[CD No_] = '%s' and cdr.[Source Item Ledger Entry No_] = %s order by ve.[Item Charge No_]"),sDatabase,sDatabase,sDatabase,sDatabase,sDocNumber,sValue,sCDR,sItemEntry);
					sValue = "";

					iCount = 0;
					dVal = 0.0;
					dSumm = 0.0;
					Query1.Open(CRecordset::snapshot ,sSQL,CRecordset::readOnly);
					while(!Query1.IsEOF())
					{
						i = 0;
						Query1.GetFieldValue(i, dbValue);
						sValue = GetValue(&dbValue);
						i++;
						if(sValue.GetLength()<1)
						{
							Query1.GetFieldValue(1, dbValue);
							sValue = GetValue(&dbValue);
							dVal = dVal+ _wtofmy(GetValue(&dbValue));
							iCount++;
						}
						else
						{
							Query1.GetFieldValue(1, dbValue);
							dSumm = dSumm+  _wtofmy(GetValue(&dbValue));
						}
						Query1.MoveNext();
					}
					Query1.Close();

					dSumm = dSumm + dVal/iCount;
					dSumm = (int)(dSumm+0.5);

					sValue = "";
					for(int i = 3; i < 7; i++)
					{
						Query.GetFieldValue(i, dbValue);
						sValue = sValue +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
					}
					sSQL.Format(_T("%.0f"),dSumm);
					sValue = sValue + sSQL;
					stFile.WriteString(sValue+_T("\n"));
					Query.MoveNext();
				}
				Query.Close();
				stFile.Close();
			
				sDocArray.RemoveAt(0,1);
				if((bStop)||(bPause))
				{
					
					sError = _T("Прервано");
					break;
				}
			}
		}
		catch(CDBException *err)
		{
			sError.Format(_T("%s %s"),err->m_strError,sSQL);
			if(sOldFile.GetLength()>0)
			{
				stFile.Close();
			}
		}
	}


	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	if((bStop)||(bPause)||(sError.GetLength()>0))
	{
		if(sError.GetLength()<1)
			sError = _T("Прервано");
		while(sFileArray.GetCount())
		{
			if(!DeleteFile(sFileArray.ElementAt(0)))
			{
				DWORD Err;
				Err = GetLastError();
				if(Err != 2)
				{
					CFile::Rename(sFileArray.ElementAt(0),sFileArray.ElementAt(0)+_T("_damage"));
				}
			}
			sFileArray.RemoveAt(0,1);
		}
	}
	
	
	
		
	return sError;
}

CString EXPORT_TYPE_13(int iPosition, CString sOldDate)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	CStringArray sFileArray;
	CDBVariant dbValue;

	CString sTHO;
	sTHO = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));

	CString sFilter;
	sFilter = sReadFromIni(sPos,_T("PARAMETR_1"),_T(""));
	CString sFilter2;
	sFilter2 = sReadFromIni(sPos,_T("PARAMETR_2"),_T(""));
	if(sFilter.GetLength()>0)
	{
		sFilter = _T(" and ")+ sFilter; 
	}

	if(sFilter2.GetLength()>0)
	{
		sFilter2 = sFilter2+_T(" and "); 
	}

	//sPos
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказана директория выгрузки");
		return sError;
	}

	if(sFileName.Right(1)!=_T("\\"))
		sFileName = sFileName + _T("\\");

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}

	CString sSQL;
	if(dBase!=NULL)
	{	
		
		sFileArray.RemoveAll();
		CStringArray sDocArray;

		sSQL.Format(_T("select distinct tsh.[No_], tsh.[TTN Series]+tsh.[TTN Number] as tt, 'TN' as TN,tsh.[TTN Series], tsh.[TTN Number],CONVERT ( nchar ,tsh.[Posting Date], 104) as Dat ,[Transfer-from Code],[Transfer-from Name] from [%s$Transfer Shipment Header] as tsh where tsh.[Sales Process Type Code] = '%s' and tsh.[TTN Number] <> ''   and Left(CONVERT ( nchar , tsh.[TN_TTN Print Date_Time], 112),8) >= '%s' and Left(CONVERT ( nchar , tsh.[TN_TTN Print Date_Time], 112),8) <= '%s' order by tt"),sDatabase,sTHO,sOldDate.Left(8),sOldDate.Left(8));
		CRecordset Query(dBase);
		CRecordset Query1(dBase);
		
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		short i;
		sDocArray.RemoveAll();
		while(!Query.IsEOF())
		{
			sSQL = "";
			for(int i = 0; i < 8; i++)
			{
				Query.GetFieldValue(i, dbValue);
				sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
			}
			sDocArray.Add(sSQL);
			if((bStop)||(bPause))
				{
					sError = _T("Прервано");
					break;
				}
			Query.MoveNext();		
		}
		Query.Close();

		CStdioFile stFile;
		CString sValue;
		CString sDocNumber;

		int iPos;
		CString sOldFile;
		sOldFile = "";
		if((!bStop)&&(!bPause))
		try
		{
			while(sDocArray.GetCount()>0)
			{
				sValue = sDocArray.ElementAt(0);
				iPos = sValue.Find(_T(";"),0);
				if(iPos < 2)
				{
					sDocArray.RemoveAt(0,1);
					continue;
				}
				sDocNumber = sValue.Left(iPos);
			
				sValue = sValue.Right(sValue.GetLength() - iPos -1);
				iPos = sValue.Find(_T(";"),0);
				if(iPos < 2)
				{
					sDocArray.RemoveAt(0,1);
					continue;
				}	

				if(sOldFile != sValue.Left(iPos))
				{
					sOldFile = sValue.Left(iPos);
					
					if(!stFile.Open(sFileName+sOldFile+_T(".txt"),CFile::modeCreate|CFile::modeWrite))
					{
						sError = GetLastErrorText()+_T("\t")+sFileName+sOldFile;
						break;
					}
					sFileArray.Add(sFileName+sOldFile+_T(".txt"));
					sValue = sValue.Right(sValue.GetLength() - iPos -1);
					stFile.WriteString(sValue+_T("\n"));
				
				}
				else
				{
					stFile.Open(sFileName+sOldFile+_T(".txt"),CFile::modeReadWrite);
					stFile.SeekToEnd();
				}
			
				//sFilter
				sSQL.Format(_T("select tsl.[Line No_],cdr.[Source Item Ledger Entry No_],cdr.[CD No_], tsl.[Description 2],it.[Description],it.[Description],it.[No_ 2],it.[No_],coalesce((select '10.9' from [%s$Item item group] as [iig] join [%s$Item group] as ig on  [iig].[Item Group Node Id] = ig.[nodeid] join [%s$Item group] as ig1 on ig1.[nodeid] = ig.[parentid] join [%s$Item group] as ig2 on ig2.[nodeid] = ig1.[parentid] 	where iig.[Item No_]  = it.[No_] and [iig].[Item Group Type Code] = 'ТОВЛИНИЯ' %s),'10.5'),tsl.[Unit of Measure Code],[tm].[Trade Mark Name],coalesce(cdr.[Quantity],0)*-1,(select top 1 [Unit Price] from [%s$Sales Price] as sp where %s sp.[Item No_] = it.[No_] and (sp.[Ending Date] >= CONVERT (date,getdate()) or (CONVERT ( nchar ,sp.[Ending Date],112) = '17530101')))		from [%s$Transfer Shipment Line] as tsl join [%s$Item] as it on tsl.[Item No_] = it.[No_] join [tm] on it.[TM Code] = tm.[Trade Mark Code] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = tsl.[Document No_] and cdr.[Line No_] = tsl.[Line No_] where tsl.[Document No_] = '%s'"),sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sDatabase,sFilter2,sDatabase,sDatabase,sDatabase,sDocNumber);
				
				Query.Open(CRecordset::snapshot ,sSQL,CRecordset::readOnly);
					
				CString sItemEntry,sCDR;
				int iCount;	
				double dCount;
				double dSummSale;
				double dVal,dSumm;
				CString sCountry;
				while(!Query.IsEOF())
				{
					if((bStop)||(bPause))
					{
						
						sError = _T("Прервано");
						break;
					}
					i = 0;
					Query.GetFieldValue(i, dbValue);
					sValue = GetValue(&dbValue);

					i = 1;
					Query.GetFieldValue(i, dbValue);
					sItemEntry = GetValue(&dbValue);

					i = 2;
					Query.GetFieldValue(i, dbValue);
					sCDR = GetValue(&dbValue);
						
					sSQL.Format(_T("select [Item Charge No_],[Acc_ Cost per Unit],  cdh.[Country_Region of Origin Code],eep.NAME, cdr.[CD No_] from [%s$Custom Declaration Relation] as cdr left join [%s$Value Entry] as ve on (ve.[Item Ledger Entry Type] = 0 or ve.[Item Ledger Entry Type] = 1 or ve.[Item Ledger Entry Type] = 2) and   ve.[Item Ledger Entry No_] = cdr.[Source Item Ledger Entry No_] and  ve.[Expected Cost] = 0 and ve.[Entry Type] = 0 left join [%s$Item Charge] as ic on  ic.[No_] = ve.[Item Charge No_] left join [%s$Custom Declaration Line] as cdh on cdh.[CD No_] = cdr.[CD No_] and cdh.[CD Line No_] = cdr.[CD Line No_] left join [Country_Region] as eep on eep.[Code] = cdh.[Country_Region of Origin Code] where ((ic.[Include in Accounting Cost] = 1)or(ve.[Item Charge No_] = ''))  and cdr.[Document No_] = '%s' and cdr.[Line No_] = %s and ( (ve.[Item Ledger Entry Type] = 0) OR(	(ve.[Item Ledger Entry Type] = 1) AND(ve.[Document Type] = 4) ) OR  ((	(ve.[Document Type] = 14) OR (ve.[Document Type] = 16)) AND	(ve.[Item Ledger Entry Type] = 2)) OR ((ve.[Item Ledger Entry Type] = 2) AND (ve.[Document No_] = 'START STOCK'))) and cdr.[CD No_] = '%s' and cdr.[Source Item Ledger Entry No_] = %s order by ve.[Item Charge No_]"),sDatabase,sDatabase,sDatabase,sDatabase,sDocNumber,sValue,sCDR,sItemEntry);
					sValue = "";

					iCount = 0;
					dVal = 0.0;
					dSumm = 0.0;
					Query1.Open(CRecordset::snapshot ,sSQL,CRecordset::readOnly);
					while(!Query1.IsEOF())
					{
						i = 0;
						Query1.GetFieldValue(i, dbValue);
						sValue = GetValue(&dbValue);
						i++;
						if(sValue.GetLength()<1)
						{
							Query1.GetFieldValue(1, dbValue);
							sValue = GetValue(&dbValue);
							dVal = dVal+ _wtofmy(GetValue(&dbValue));
							iCount++;
						}
						else
						{
							Query1.GetFieldValue(1, dbValue);
							dSumm = dSumm+  _wtofmy(GetValue(&dbValue));
						}
						i++;
						Query1.GetFieldValue(i, dbValue);
						sCountry =  GetValue(&dbValue);
						i++;
						Query1.GetFieldValue(i, dbValue);
						sCountry =  GetValue(&dbValue)+_T(";")+sCountry;
						
						Query1.MoveNext();
					}
					Query1.Close();

					

					dSumm = dSumm + dVal/iCount;
					dSumm = (int)(dSumm+0.5);

					sValue = "";

					dSummSale = 0;
					dCount = 0;
					for(int i = 3; i < 13; i++)
					{
						Query.GetFieldValue(i, dbValue);
						if(i==12)
						{
							dSummSale = _wtofmy(GetValue(&dbValue));
						}
						else
						sValue = sValue +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
						if(i==11)
						{
							dCount = _wtofmy(GetValue(&dbValue));
						}

						
					}
					sSQL.Format(_T("%.0f;%.0f;%s;%s;%.0f;%.0f;"),dSumm,dCount*dSumm,sCDR,sCountry,dSummSale,dCount*dSummSale);
					sValue = sValue + sSQL;
					stFile.WriteString(sValue+_T("\n"));
					Query.MoveNext();
				}
				Query.Close();
				stFile.Close();
			
				sDocArray.RemoveAt(0,1);
				if((bStop)||(bPause))
				{
					
					sError = _T("Прервано");
					break;
				}
			}
		}
		catch(CDBException *err)
		{
			sError.Format(_T("%s %s"),err->m_strError,sSQL);
			if(sOldFile.GetLength()>0)
			{
				stFile.Close();
			}
		}
	}


	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	if((bStop)||(bPause)||(sError.GetLength()>0))
	{
		if(sError.GetLength()<1)
			sError = _T("Прервано");
		while(sFileArray.GetCount())
		{
			if(!DeleteFile(sFileArray.ElementAt(0)))
			{
				DWORD Err;
				Err = GetLastError();
				if(Err != 2)
				{
					CFile::Rename(sFileArray.ElementAt(0),sFileArray.ElementAt(0)+_T("_damage"));
				}
			}
			sFileArray.RemoveAt(0,1);
		}
	}
	
	
	
		
	return sError;
}


CString EXPORT_TYPE_3(int iPosition)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	CStringArray sFileArray;
	CDBVariant dbValue;

	CString sFilter;
	sFilter = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));

	CString sLastDoc;
	sLastDoc = sReadFromIni(sPos,_T("PARAMETR_1"),_T(""));

	CString sDivision;
	sDivision = sReadFromIni(sPos,_T("PARAMETR_2"),_T(""));

	//sPos
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказана директория выгрузки");
		return sError;
	}

	if(sFileName.Right(1)!=_T("\\"))
		sFileName = sFileName + _T("\\");

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}

	CString sSQL;
	int iFieldCount;
	if(dBase!=NULL)
	{	
		CStdioFile stFile;
		try
		{

		try
		{
			sFileArray.RemoveAll();
			CStringArray sDocArray;
			CDBVariant dbVar;
			CString sFirm;
			sFirm = sReadFromIni(_T("DB"),_T("FIRM"),_T("Shate-M Ru"));
		
			if(sFilter.GetLength()>0)
				sFilter = sFilter + _T(" and ");
		
			if(sDivision.GetLength()>0)
			{
				sSQL.Format(_T("select pih.[No_],'TN' as TN,'' as TNSer,[Vendor Invoice No_] as TNNumber, CONVERT ( nchar , pih.[Posting Date], 104), vn.[VAT Registration No_], pih.[Agreement No_], pih.[Currency Code], vn.[Name], vn.[Full Name], vn.[Ownership Code], vn.[VAT Registration No_], vn.[VAT Registration No_], vn.[KPP Code], vn.[OKPO Code], vn.[Address 2], vn.[Address], vn.[Phone No_] + ', факс' + vn.[Fax No_], va.[Vendor No_], va.[VAT Bus_ Posting Group], va.[Currency Code], va.[External Agreement No_], CONVERT ( nchar , va.[Agreement Date], 104), va.[Legal Entity], CONVERT ( nchar , va.[Expire Date], 104), va.[No_], %s from [%s$Purch_ Inv_ Header] as pih join [%s$Vendor] as vn on vn.[No_] = pih.[Buy-from Vendor No_] left join [%s$NoExport1C]on DocNumber = pih.[No_] join [%s$Vendor Agreement] as va on va.[Vendor No_] = pih.[Buy-from Vendor No_] and va.[No_] = pih.[Agreement No_] where %s (Export1C is Null or Export1C = 0) and pih.[No_] > '%s' order by pih.[No_]"),sDivision,sFirm,sFirm,sFirm,sFirm,sFilter,sLastDoc);
				iFieldCount = 27;
			}
			else
			{
				sSQL.Format(_T("select pih.[No_],'TN' as TN,'' as TNSer,[Vendor Invoice No_] as TNNumber, CONVERT ( nchar , pih.[Posting Date], 104), vn.[VAT Registration No_], pih.[Agreement No_], pih.[Currency Code], vn.[Name], vn.[Full Name], vn.[Ownership Code], vn.[VAT Registration No_], vn.[VAT Registration No_], vn.[KPP Code], vn.[OKPO Code], vn.[Address 2], vn.[Address], vn.[Phone No_] + ', факс' + vn.[Fax No_], va.[Vendor No_], va.[VAT Bus_ Posting Group], va.[Currency Code], va.[External Agreement No_], CONVERT ( nchar , va.[Agreement Date], 104), va.[Legal Entity], CONVERT ( nchar , va.[Expire Date], 104), va.[No_] from [%s$Purch_ Inv_ Header] as pih join [%s$Vendor] as vn on vn.[No_] = pih.[Buy-from Vendor No_] left join [%s$NoExport1C]on DocNumber = pih.[No_] join [%s$Vendor Agreement] as va on va.[Vendor No_] = pih.[Buy-from Vendor No_] and va.[No_] = pih.[Agreement No_] where %s (Export1C is Null or Export1C = 0) and pih.[No_] > '%s' order by pih.[No_]"),sFirm,sFirm,sFirm,sFirm,sFilter,sLastDoc);
				iFieldCount = 26;
			}
		
			CRecordset Query(dBase);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		
			sDocArray.RemoveAll();
			while(!Query.IsEOF())
			{
				if((bStop)||(bPause))
				{
					sError = _T("Прервано");
					break;
				}
				sSQL = "";
				
				for(int i = 0; i < iFieldCount; i++)
				{
					Query.GetFieldValue(i, dbValue);
					if(i==0)
					{
						sLastDoc = sReplaceLeftSynmbol(GetValue(&dbValue));
					}
					sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
				}
				sDocArray.Add(sSQL);
				Query.MoveNext();		
			}
			Query.Close();

			CString sValue;
			CString sDocNumber;

			int iPos;
			while(sDocArray.GetCount()>0)
			{
				if((bStop)||(bPause))
				{
					sError = _T("Прервано");
					break;
				}
				sValue = sDocArray.ElementAt(0);
				iPos = sValue.Find(_T(";"),0);
				if(iPos < 2)
				{
					sDocArray.RemoveAt(0,1);
					continue;
				}
				sDocNumber = sValue.Left(iPos);
				sValue = sValue.Right(sValue.GetLength() - iPos -1);	
				
				if(stFile.Open(sFileName+_T("temp"),CFile::modeCreate|CFile::modeWrite))
				{
					
					stFile.WriteString(sValue+_T("\n"));
					sSQL.Format(_T("select (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode, pil.[Unit of Measure], it.[Description 2], pil.[Quantity], pil.[Direct Unit Cost], pil.[Ext_ VAT %%], pil.[Line Amount], (select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = pil.[Unit of Measure Code])*0.9, (select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = pil.[Unit of Measure Code]) as wth, pil.[CD No_], pil.[Country_Region of Origin Code], eep.NAME, it.[Description 2], it.[Description 2], it.[No_ 2], [tm].[Trade Mark Name], it.[No_] from [%s$Purch_ Inv_ line] as pil join [%s$Item] as it on pil.[No_] = it.[No_] join [tm] on it.[TM Code] = tm.[Trade Mark Code] join [Country_Region] as eep on eep.[Code] = pil.[Country_Region of Origin Code] where pil.[Document No_] = '%s'"),sFirm,sFirm,sFirm,sFirm,sDocNumber);
					
					Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
					while(!Query.IsEOF())
					{
						sValue = "";
						for(int i = 0; i < 17; i++)
						{
							Query.GetFieldValue(i, dbValue);
							sValue = sValue +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
						}

						stFile.WriteString(sValue+_T("\n"));
		
						if((bStop)||(bPause))
						{
							sError = _T("Прервано");
							break;
						}
						Query.MoveNext();		
					}
					Query.Close();
					stFile.Close();
					if(sError.GetLength()<1)
					{
						try
						{
							stFile.Remove(sFileName+sDocNumber+_T(".txt"));
						}
						catch(...)
						{
							DWORD Err;
							Err = GetLastError();
							if(Err != 2)
							{
								sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+sDocNumber+_T(".txt"),GetLastErrorText());
								break;
							}
						}
					
						try
						{
							stFile.Rename(sFileName+_T("temp"),sFileName+sDocNumber+_T(".txt"));
						}
						catch(...)
						{
							sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sFileName+sDocNumber+_T(".txt"),GetLastErrorText());
							break;
						}
				
						sFileArray.Add(sFileName+sDocNumber+_T(".txt"));
					}
			}
			else
			{
				sError.Format(_T("Ошибка при создании файла %s %s"),sFileName+sDocNumber+_T(".txt"),GetLastErrorText());
				break;
			}
			if(sError.GetLength()>0)
				break;
			sDocArray.RemoveAt(0,1);
		}
	}
	catch(CDBException *exsept)
	{
		stFile.Close();
		sError.Format(_T("%s %s"),exsept->m_strError, sSQL);
		exsept->Delete();
	}
	}
	catch(...)
	{
		sError = GetLastErrorText();
	}
}


	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		while(sFileArray.GetCount()>0)
		{
			WriteToLogFile(_T("Удаление - ")+sFileArray.ElementAt(0));
			if(!DeleteFile(sFileArray.ElementAt(0)))
			{
				WriteToLogFile(_T("не удалили"));
				DWORD Err;
				Err = GetLastError();
				if(Err != 2)
				{
					CFile::Rename(sFileArray.ElementAt(0),sFileArray.ElementAt(0)+_T("_damage"));
				}
			}
			else
				WriteToLogFile(_T("Удалили"));
			sFileArray.RemoveAt(0,1);
		}
	}
	else
	{
		if(sError.GetLength()<1)
		{
			if(sLastDoc.GetLength()>0)
			{
				sWriteToIni(sPos,_T("PARAMETR_1"),sLastDoc);
			}
		}
	}
	return sError;
}

CString EXPORT_TYPE_4(int iPosition)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	CStringArray sFileArray;
	CDBVariant dbValue;

	CString sFilter;
	sFilter = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));

	CString sLastDoc;
	sLastDoc = sReadFromIni(sPos,_T("PARAMETR_1"),_T(""));

	CString sDivision;
	sDivision = sReadFromIni(sPos,_T("PARAMETR_2"),_T(""));
	//sPos
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказана директория выгрузки");
		return sError;
	}

	if(sFileName.Right(1)!=_T("\\"))
		sFileName = sFileName + _T("\\");

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}
try
{
	CString sSQL;
	if(dBase!=NULL)
	{	
		int i;
		CStdioFile stFile;
		CString sOldFile;
		sOldFile = "";
		int iFieldCount;
		try
		{
			sFileArray.RemoveAll();
			CStringArray sDocArray;
			CDBVariant dbVar;
					
			if(sFilter.GetLength()>0)
				sFilter = sFilter + _T(" and ");
		
			

			if(sDivision.GetLength()>0)
			{
				sSQL.Format(_T("select CONVERT ( nchar , [TN_TTN Print Date_Time], 120),pih.[No_], ([TTN Series]+[TTN Number]) as SortF,'TN' as TN,[TTN Series] as TNSer,[TTN Number] as TNNumber,CONVERT ( nchar , pih.[Posting Date], 104),'V1',pih.[Agreement No_],'BYR',vn.[Name],vn.[Full Name],vn.[Ownership Code], vn.[VAT Registration No_],vn.[VAT Registration No_],vn.[KPP Code],vn.[OKPO Code],vn.[Address 2],vn.[Address],vn.[Phone No_] + ', факс' + vn.[Fax No_],va.[Customer No_],va.[VAT Bus_ Posting Group],va.[Currency Code],va.[External Agreement No_],CONVERT ( nchar , va.[Agreement Date], 104),va.[Legal Entity],CONVERT ( nchar , va.[Expire Date], 104),va.[No_],%s from [%s$Sales Invoice Header] as pih left join [%s$Customer] as vn on vn.[No_] = pih.[Bill-to Customer No_] left join [%s$Customer Agreement] as va on va.[Customer No_] = pih.[Bill-to Customer No_] and va.[No_] = pih.[Agreement No_] where %s CONVERT ( nchar , pih.[TN_TTN Print Date_Time], 120) > '%s'  order by SortF"),sDivision,sDatabase,sDatabase,sDatabase,sFilter,sLastDoc);
				iFieldCount = 29;
			}
			else
			{
				sSQL.Format(_T("select CONVERT ( nchar , [TN_TTN Print Date_Time], 120),pih.[No_], ([TTN Series]+[TTN Number]) as SortF,'TN' as TN,[TTN Series] as TNSer,[TTN Number] as TNNumber,CONVERT ( nchar , pih.[Posting Date], 104),'V1',pih.[Agreement No_],'BYR',vn.[Name],vn.[Full Name],vn.[Ownership Code], vn.[VAT Registration No_],vn.[VAT Registration No_],vn.[KPP Code],vn.[OKPO Code],vn.[Address 2],vn.[Address],vn.[Phone No_] + ', факс' + vn.[Fax No_],va.[Customer No_],va.[VAT Bus_ Posting Group],va.[Currency Code],va.[External Agreement No_],CONVERT ( nchar , va.[Agreement Date], 104),va.[Legal Entity],CONVERT ( nchar , va.[Expire Date], 104),va.[No_] from [%s$Sales Invoice Header] as pih left join [%s$Customer] as vn on vn.[No_] = pih.[Bill-to Customer No_] left join [%s$Customer Agreement] as va on va.[Customer No_] = pih.[Bill-to Customer No_] and va.[No_] = pih.[Agreement No_] where %s CONVERT ( nchar , pih.[TN_TTN Print Date_Time], 120) > '%s'  order by SortF"),sDatabase,sDatabase,sDatabase,sFilter,sLastDoc);
				iFieldCount = 28;
			}
			//sSQL.Format(_T("select pih.[No_], ([TTN Series]+[TTN Number]) as SortF,'TN' as TN,[TTN Series] as TNSer,[TTN Number] as TNNumber,CONVERT ( nchar , pih.[Posting Date], 104),'V1',pih.[Agreement No_],'BYR',vn.[Name],vn.[Full Name],vn.[Ownership Code], vn.[VAT Registration No_],vn.[VAT Registration No_],vn.[KPP Code],vn.[OKPO Code],vn.[Address 2],vn.[Address],vn.[Phone No_] + ', факс' + vn.[Fax No_],va.[Customer No_],va.[VAT Bus_ Posting Group],va.[Currency Code],va.[External Agreement No_],CONVERT ( nchar , va.[Agreement Date], 104),va.[Legal Entity],CONVERT ( nchar , va.[Expire Date], 104),va.[No_] from [%s$Sales Invoice Header] as pih left join [%s$Customer] as vn on vn.[No_] = pih.[Bill-to Customer No_] left join [%s$Customer Agreement] as va on va.[Customer No_] = pih.[Bill-to Customer No_] and va.[No_] = pih.[Agreement No_] where %s pih.[No_] > '%s'  order by SortF"),sDatabase,sDatabase,sDatabase,sFilter,sLastDoc);
			
			CRecordset Query(dBase);
			CRecordset Query1(dBase);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			

			sDocArray.RemoveAll();
			while(!Query.IsEOF())
			{
				if((bStop)||(bPause))
				{
					sError = _T("Прервано");
					break;
				}
				sSQL = "";
				
				for(int i = 0; i < iFieldCount; i++)
				{
					Query.GetFieldValue(i, dbValue);
					if(i==0)
					{
						if(sLastDoc < sReplaceLeftSynmbol(GetValue(&dbValue)))
						sLastDoc = sReplaceLeftSynmbol(GetValue(&dbValue));
					}
					else
					sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
				}
				sDocArray.Add(sSQL);
				Query.MoveNext();		
			}
			Query.Close();

			CString sValue;
			CString sDocNumber;

			int iPos;

			while(sDocArray.GetCount()>0)
			{
				if((bStop)||(bPause))
				{
					sError = _T("Прервано");
					break;
				}
				sValue = sDocArray.ElementAt(0);
				
			iPos = sValue.Find(_T(";"),0);
			if(iPos < 2)
			{
				sDocArray.RemoveAt(0,1);
				continue;
			}
			sDocNumber = sValue.Left(iPos);
			
			sValue = sValue.Right(sValue.GetLength() - iPos -1);
			iPos = sValue.Find(_T(";"),0);
			if(iPos < 2)
			{
				sDocArray.RemoveAt(0,1);
				continue;
			}

			if(sOldFile != sValue.Left(iPos))
			{
				if(sOldFile.GetLength()>0)
				{
					try
					{
						stFile.Remove(sFileName+sOldFile+_T(".txt"));
					}
					catch(...)
					{
						DWORD Err;
						Err = GetLastError();
						if(Err != 2)
						{
							sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+sOldFile+_T(".txt"),GetLastErrorText());
							break;
						}
					}

					try
					{
						stFile.Rename(sFileName+_T("temp"),sFileName+sOldFile+_T(".txt"));
					}
					catch(...)
					{
						sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sFileName+sOldFile+_T(".txt"),GetLastErrorText());
						break;
					}
					sFileArray.Add(sFileName+sOldFile+_T(".txt"));
				}

				
				if(!stFile.Open(sFileName+_T("temp"),CFile::modeCreate|CFile::modeWrite))
				{
					sError.Format(_T("Ошибка при создании файла(temp) %s %s"),sFileName+sDocNumber+_T(".txt"),GetLastErrorText());
					break;
				}
				sOldFile = sValue.Left(iPos);
				sValue = sValue.Right(sValue.GetLength() - iPos -1);
				stFile.WriteString(sValue+_T("\n"));	
				
			}
			else
			{
				if(!stFile.Open(sFileName+_T("temp"),CFile::modeReadWrite))
				{
					sError.Format(_T("Ошибка при создании дозаписи %s %s"),sFileName+sDocNumber+_T(".txt"),GetLastErrorText());
					break;
				}
				stFile.SeekToEnd();
			}
			
			sSQL.Format(_T("select pil.[Line No_],cdr.[Source Item Ledger Entry No_],cdr.[CD No_], (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode, pil.[Unit of Measure], it.[Description 2], cdr.[Quantity]*-1, pil.[Optimization Price] as Price, pil.[Ext_ VAT %%], '  ' As Summ, (select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = pil.[Unit of Measure Code])*0.9, (select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = pil.[Unit of Measure Code]) as wth,'  ' as GTD, it.[Country_Region of Origin Code] as Country_Code, eep.NAME as Country_Name, it.[Description 2] as d2, it.[Description 2] as D1, it.[No_ 2], [tm].[Trade Mark Name], it.[No_] from [%s$Sales Invoice Line] as pil left join [%s$Item] as it on pil.[No_] = it.[No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] left join [Country_Region] as eep on eep.[Code] = it.[Country_Region of Origin Code] left join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = pil.[Document No_] and cdr.[Line No_] = pil.[Line No_] where pil.[Document No_] = '%s'	and pil.[Quantity] > 0"),sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDocNumber);
			Query.Open(CRecordset::snapshot ,sSQL,CRecordset::readOnly);
			
			CString sCDR;
			CString sCCode;
			CString sCName;
			CString sss;
			CString sItemEntry;
			int iCount;
			double dVal;
			double dSumm;
			
			while(!Query.IsEOF())
			{		
				if((bStop)||(bPause))
				{
					sError = _T("Прервано");
					break;
				}
				i = 0;

				Query.GetFieldValue(i, dbValue);
				sValue = GetValue(&dbValue);
				

				i = 1;
				Query.GetFieldValue(i, dbValue);
				sItemEntry = GetValue(&dbValue);

				i = 2;
				Query.GetFieldValue(i, dbValue);
				sCDR = GetValue(&dbValue);
				


				
				sSQL.Format(_T("select [Item Charge No_],[Acc_ Cost per Unit], cdr.[CD No_], cdh.[Country_Region of Origin Code], eep.NAME from [%s$Custom Declaration Relation] as cdr left join [%s$Value Entry] as ve on (ve.[Item Ledger Entry Type] = 0 or ve.[Item Ledger Entry Type] = 1 or ve.[Item Ledger Entry Type] = 2) and   ve.[Item Ledger Entry No_] = cdr.[Source Item Ledger Entry No_] and  ve.[Expected Cost] = 0 and ve.[Entry Type] = 0 left join [%s$Item Charge] as ic on  ic.[No_] = ve.[Item Charge No_] left join [%s$Custom Declaration Line] as cdh on cdh.[CD No_] = cdr.[CD No_] and cdh.[CD Line No_] = cdr.[CD Line No_] left join [Country_Region] as eep on eep.[Code] = cdh.[Country_Region of Origin Code] where ((ic.[Include in Accounting Cost] = 1)or(ve.[Item Charge No_] = ''))  and cdr.[Document No_] = '%s' and cdr.[Line No_] = %s and ( (ve.[Item Ledger Entry Type] = 0) OR(	(ve.[Item Ledger Entry Type] = 1) AND(ve.[Document Type] = 4) ) OR  ((	(ve.[Document Type] = 14) OR (ve.[Document Type] = 16)) AND	(ve.[Item Ledger Entry Type] = 2)) OR ((ve.[Item Ledger Entry Type] = 2) AND (ve.[Document No_] = 'START STOCK'))) and cdr.[CD No_] = '%s' and cdr.[Source Item Ledger Entry No_] = %s order by ve.[Item Charge No_]"),sDatabase,sDatabase,sDatabase,sDatabase,sDocNumber,sValue,sCDR,sItemEntry);
				sValue = "";

				iCount = 0;
				dVal = 0.0;
				dSumm = 0.0;
				Query1.Open(CRecordset::snapshot ,sSQL,CRecordset::readOnly);
				while(!Query1.IsEOF())
				{
					if((bStop)||(bPause))
					{
						sError = _T("Прервано");
						break;
					}
					i = 0;
					Query1.GetFieldValue(i, dbValue);
					sValue = GetValue(&dbValue);
					i++;
					if(sValue.GetLength()<1)
					{
						Query1.GetFieldValue(1, dbValue);
						sValue = GetValue(&dbValue);
						dVal = dVal+ _wtofmy(GetValue(&dbValue));
						iCount++;
					}
					else
					{
						Query1.GetFieldValue(1, dbValue);
						dSumm = dSumm+  _wtofmy(GetValue(&dbValue));
					}

					i++;
					Query1.GetFieldValue(i, dbValue);
					sCDR = GetValue(&dbValue);
	
					i++;
					Query1.GetFieldValue(i, dbValue);
					sCCode = GetValue(&dbValue);

					i++;
					Query1.GetFieldValue(i, dbValue);
					sCName = GetValue(&dbValue);
					Query1.MoveNext();
				}
				Query1.Close();

				dSumm = dSumm + dVal/iCount;
				dSumm = (int)(dSumm+0.5);

				sValue = "";
				for(int i = 3; i < 20; i++)
				{
					switch(i)
					{
						case 6:
							Query.GetFieldValue(i, dbValue);
							iCount = _wtoi(GetValue(&dbValue));
							sValue = sValue +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
							break;

						case 7:
							sss.Format(_T("%.0f"),dSumm);
							sValue = sValue +sss+_T(";");
							break;

						case 8:
						case 10:
						case 11:
							Query.GetFieldValue(i, dbValue);
							sss = GetValue(&dbValue);
							if(sss.Left(1) == _T("."))
							{
								sss = _T("0")+sss;
							}
							sValue = sValue +sss+_T(";");
							break;

						case 9:
							
							sss.Format(_T("%.0f"),dSumm*iCount);
							sValue = sValue +sss+_T(";");
							break;

						case 12:
							sValue = sValue +sCDR+_T(";");
							break;

						case 13:
							sValue = sValue +sCCode+_T(";");
							break;

						case 14:
							sValue = sValue +sCName+_T(";");
							break;
							
						default:
							Query.GetFieldValue(i, dbValue);
							sValue = sValue +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
							break;
					}
				}
				stFile.WriteString(sValue+_T("\n"));
				Query.MoveNext();
			}
			Query.Close();
			stFile.Close();
			sDocArray.RemoveAt(0,1);
			}

			if(sOldFile.GetLength()>0)
				{
					try
					{
						stFile.Remove(sFileName+sOldFile+_T(".txt"));
					}
					catch(...)
					{
						DWORD Err;
						Err = GetLastError();
						if(Err != 2)
						{
							sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+sOldFile+_T(".txt"),GetLastErrorText());
						}
					}

					if(sError.GetLength()<1)
					{
						try
						{
							stFile.Rename(sFileName+_T("temp"),sFileName+sOldFile+_T(".txt"));
						}
						catch(...)
						{
							sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sFileName+sOldFile+_T(".txt"),GetLastErrorText());
						}
						sFileArray.Add(sFileName+sOldFile+_T(".txt"));
					}
				}
		}
		catch(CDBException *exsept)
		{
			if(stFile.GetFileTitle()  != _T(""))
				stFile.Close();
			sError.Format(_T("%s %s"),exsept->m_strError, sSQL);
		exsept->Delete();
		}
	}
	}
catch(...)
	{
		sError = GetLastErrorText();
	}

	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		while(sFileArray.GetCount())
		{
			WriteToLogFile(_T("Удаление - ")+sFileArray.ElementAt(0));
			if(!DeleteFile(sFileArray.ElementAt(0)))
			{
				DWORD Err;
				Err = GetLastError();
				if(Err != 2)
				{
					CFile::Rename(sFileArray.ElementAt(0),sFileArray.ElementAt(0)+_T("_damage"));
				}
			}
			sFileArray.RemoveAt(0,1);
		}
	}
	else
	{
		if(sError.GetLength()<1)
		if(sLastDoc.GetLength()>0)
		{
			sWriteToIni(sPos,_T("PARAMETR_1"),sLastDoc);
		}
	}
	return sError;
}

CString EXPORT_TYPE_5(int iPosition)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	CStringArray sFileArray;
	CDBVariant dbValue;

	CString sFilter;
	sFilter = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));

	CString sLastDoc;
	sLastDoc = sReadFromIni(sPos,_T("PARAMETR_1"),_T(""));

	CString sDivision;
	sDivision = sReadFromIni(sPos,_T("PARAMETR_2"),_T(""));

	//sPos
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказана директория выгрузки");
		return sError;
	}

	if(sFileName.Right(1)!=_T("\\"))
		sFileName = sFileName + _T("\\");

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}

	CString sSQL;
	int iFieldCount;
	try
	{	
		if(dBase!=NULL)
		{	
			try
			{
				int i;
				CStdioFile stFile;
				CString sOldFile;
				sOldFile = "";
		
				sFileArray.RemoveAll();
				CStringArray sDocArray;
				CDBVariant dbVar;
					
				if(sFilter.GetLength()>0)
					sFilter = sFilter + _T(" and ");
		
				if(sDivision.GetLength()>0)
				{
					sSQL.Format(_T("select CONVERT ( nchar , pih.[TN_TTN Print Date_Time], 120),pih.[No_], ([TTN Series]+[TTN Number]) as SortF,'TN' as TN,[TTN Series] as TNSer,[TTN Number] as TNNumber,CONVERT ( nchar , pih.[Posting Date], 104),'V1',pih.[Agreement No_],'BYR',vn.[Name],vn.[Full Name],vn.[Ownership Code], vn.[VAT Registration No_],vn.[VAT Registration No_],vn.[KPP Code],vn.[OKPO Code],vn.[Address 2],vn.[Address],vn.[Phone No_] + ', факс' + vn.[Fax No_],va.[Customer No_],va.[VAT Bus_ Posting Group],va.[Currency Code],va.[External Agreement No_],CONVERT ( nchar , va.[Agreement Date], 104),va.[Legal Entity],CONVERT ( nchar , va.[Expire Date], 104),va.[No_],%s from [%s$Sales Invoice Header] as pih left join [%s$Customer] as vn on vn.[No_] = pih.[Bill-to Customer No_] left join [%s$Customer Agreement] as va on va.[Customer No_] = pih.[Bill-to Customer No_] and va.[No_] = 'S10200_608' where %s CONVERT ( nchar , pih.[TN_TTN Print Date_Time], 120) > '%s' order by SortF"),sDivision,sDatabase,sDatabase,sDatabase,sFilter,sLastDoc);
					iFieldCount = 29;
				}
				else
				{
					sSQL.Format(_T("select CONVERT ( nchar , pih.[TN_TTN Print Date_Time], 120),pih.[No_], ([TTN Series]+[TTN Number]) as SortF,'TN' as TN,[TTN Series] as TNSer,[TTN Number] as TNNumber,CONVERT ( nchar , pih.[Posting Date], 104),'V1',pih.[Agreement No_],'BYR',vn.[Name],vn.[Full Name],vn.[Ownership Code], vn.[VAT Registration No_],vn.[VAT Registration No_],vn.[KPP Code],vn.[OKPO Code],vn.[Address 2],vn.[Address],vn.[Phone No_] + ', факс' + vn.[Fax No_],va.[Customer No_],va.[VAT Bus_ Posting Group],va.[Currency Code],va.[External Agreement No_],CONVERT ( nchar , va.[Agreement Date], 104),va.[Legal Entity],CONVERT ( nchar , va.[Expire Date], 104),va.[No_] from [%s$Sales Invoice Header] as pih left join [%s$Customer] as vn on vn.[No_] = pih.[Bill-to Customer No_] left join [%s$Customer Agreement] as va on va.[Customer No_] = pih.[Bill-to Customer No_] and va.[No_] = 'S10200_608' where %s CONVERT ( nchar , pih.[TN_TTN Print Date_Time], 120) > '%s' order by SortF"),sDatabase,sDatabase,sDatabase,sFilter,sLastDoc);
					iFieldCount = 28;
				}
			
				//end
				//sSQL.Format(_T("select pih.[No_], ([TTN Series]+[TTN Number]) as SortF,'TN' as TN,[TTN Series] as TNSer,[TTN Number] as TNNumber,CONVERT ( nchar , pih.[Posting Date], 104),'V1',pih.[Agreement No_],'BYR',vn.[Name],vn.[Full Name],vn.[Ownership Code], vn.[VAT Registration No_],vn.[VAT Registration No_],vn.[KPP Code],vn.[OKPO Code],vn.[Address 2],vn.[Address],vn.[Phone No_] + ', факс' + vn.[Fax No_],va.[Customer No_],va.[VAT Bus_ Posting Group],va.[Currency Code],va.[External Agreement No_],CONVERT ( nchar , va.[Agreement Date], 104),va.[Legal Entity],CONVERT ( nchar , va.[Expire Date], 104),va.[No_] from [%s$Sales Invoice Header] as pih left join [%s$Customer] as vn on vn.[No_] = pih.[Bill-to Customer No_] left join [%s$Customer Agreement] as va on va.[Customer No_] = pih.[Bill-to Customer No_] and va.[No_] = 'S10200_608' where %s pih.[No_] > '%s' order by SortF"),sDatabase,sDatabase,sDatabase,sFilter,sLastDoc);
			
				CRecordset Query(dBase);
				CRecordset Query1(dBase);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			
				sDocArray.RemoveAll();
				while(!Query.IsEOF())
				{
					if((bStop)||(bPause))
					{
						sError = _T("Прервано");
						break;
					}
					sSQL = "";
					
					for(int i = 0; i < iFieldCount; i++)
					{
						Query.GetFieldValue(i, dbValue);
						if(i==0)
						{
							if(sLastDoc < sReplaceLeftSynmbol(GetValue(&dbValue)))
							sLastDoc = sReplaceLeftSynmbol(GetValue(&dbValue));
						}
						else
						sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
					}
					sDocArray.Add(sSQL);
					Query.MoveNext();		
				}
				Query.Close();

				CString sValue;
				CString sDocNumber;

				int iPos;
				while(sDocArray.GetCount()>0)
				{
					if((bStop)||(bPause))
					{
						sError = _T("Прервано");
						break;
					}
					sValue = sDocArray.ElementAt(0);
					iPos = sValue.Find(_T(";"),0);
					if(iPos < 2)
					{
						sDocArray.RemoveAt(0,1);
						continue;
					}
					sDocNumber = sValue.Left(iPos);
					
					sValue = sValue.Right(sValue.GetLength() - iPos -1);
					iPos = sValue.Find(_T(";"),0);
					if(iPos < 2)
					{
						sDocArray.RemoveAt(0,1);
						continue;
					}

					if(sOldFile != sValue.Left(iPos))
					{
						if(sOldFile.GetLength()>0)
						{
							try
							{
								stFile.Remove(sFileName+sOldFile+_T(".txt"));
							}
							catch(...)
							{
								DWORD Err;
								Err = GetLastError();
								if(Err != 2)
								{
									sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+sOldFile+_T(".txt"),GetLastErrorText());
									break;
								}
							}

							try
							{
								stFile.Rename(sFileName+_T("temp"),sFileName+sOldFile+_T(".txt"));
								sFileArray.Add(sFileName+sOldFile+_T(".txt"));
							}
							catch(...)
							{
								sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sFileName+sOldFile+_T(".txt"),GetLastErrorText());
								break;
							}
							
						}

						
						if(!stFile.Open(sFileName+_T("temp"),CFile::modeCreate|CFile::modeWrite))
						{
							sError.Format(_T("Ошибка при создании файла %s %s"),sFileName+sDocNumber+_T(".txt"),GetLastErrorText());
							break;
						}
						sOldFile = sValue.Left(iPos);
						sValue = sValue.Right(sValue.GetLength() - iPos -1);
						stFile.WriteString(sValue+_T("\n"));	
						
					}
					else
					{
						if(!stFile.Open(sFileName+_T("temp"),CFile::modeReadWrite))
						{
							sError.Format(_T("Ошибка при создании дозаписи %s %s"),sFileName+sDocNumber+_T(".txt"),GetLastErrorText());
							break;
						}
						stFile.SeekToEnd();
					}
				
					sSQL.Format(_T("select pil.[Line No_],cdr.[Source Item Ledger Entry No_],cdr.[CD No_], (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode, pil.[Unit of Measure], it.[Description 2], cdr.[Quantity]*-1, pil.[Optimization Price] as Price, pil.[Ext_ VAT %%], '  ' As Summ, (select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = pil.[Unit of Measure Code])*0.9, (select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = pil.[Unit of Measure Code]) as wth,	'  ' as GTD, it.[Country_Region of Origin Code] as Country_Code, eep.NAME as Country_Name, it.[Description 2] as d2, it.[Description 2] as D1, it.[No_ 2], [tm].[Trade Mark Name], it.[No_] from [%s$Sales Invoice Line] as pil left join [%s$Item] as it on pil.[No_] = it.[No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] left join [Country_Region] as eep on eep.[Code] = it.[Country_Region of Origin Code] left join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = pil.[Document No_] and cdr.[Line No_] = pil.[Line No_] where pil.[Document No_] = '%s'	and pil.[Quantity] > 0"),sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDocNumber);
					Query.Open(CRecordset::snapshot ,sSQL,CRecordset::readOnly);
					
					CString sCDR;
					CString sCCode;
					CString sCName;
					CString sss;
					CString sItemEntry;
					int iCount;
					double dVal;
					double dSumm;
					
					while(!Query.IsEOF())
					{		
						if((bStop)||(bPause))
						{
							sError = _T("Прервано");
							break;
						}
						i = 0;
						Query.GetFieldValue(i, dbValue);
						sValue = GetValue(&dbValue);

						i = 1;
						Query.GetFieldValue(i, dbValue);
						sItemEntry = GetValue(&dbValue);

						i = 2;
						Query.GetFieldValue(i, dbValue);
						sCDR = GetValue(&dbValue);
						
						//sItemEntry
						sSQL.Format(_T("select [Item Charge No_],[Acc_ Cost per Unit], cdr.[CD No_], cdh.[Country_Region of Origin Code], eep.NAME from [%s$Custom Declaration Relation] as cdr left join [%s$Value Entry] as ve on (ve.[Item Ledger Entry Type] = 0 or ve.[Item Ledger Entry Type] = 1 or ve.[Item Ledger Entry Type] = 2) and   ve.[Item Ledger Entry No_] = cdr.[Source Item Ledger Entry No_] and  ve.[Expected Cost] = 0 and ve.[Entry Type] = 0 left join [%s$Item Charge] as ic on  ic.[No_] = ve.[Item Charge No_] left join [%s$Custom Declaration Line] as cdh on cdh.[CD No_] = cdr.[CD No_] and cdh.[CD Line No_] = cdr.[CD Line No_] left join [Country_Region] as eep on eep.[Code] = cdh.[Country_Region of Origin Code] where ((ic.[Include in Accounting Cost] = 1)or(ve.[Item Charge No_] = ''))  and cdr.[Document No_] = '%s' and cdr.[Line No_] = %s and ( (ve.[Item Ledger Entry Type] = 0) OR(	(ve.[Item Ledger Entry Type] = 1) AND(ve.[Document Type] = 4) ) OR  ((	(ve.[Document Type] = 14) OR (ve.[Document Type] = 16)) AND	(ve.[Item Ledger Entry Type] = 2)) OR ((ve.[Item Ledger Entry Type] = 2) AND (ve.[Document No_] = 'START STOCK'))) and cdr.[CD No_] = '%s' and cdr.[Source Item Ledger Entry No_] = %s order by ve.[Item Charge No_]"),sDatabase,sDatabase,sDatabase,sDatabase,sDocNumber,sValue,sCDR,sItemEntry);

						sValue = "";

						iCount = 0;
						dVal = 0.0;
						dSumm = 0.0;
						Query1.Open(CRecordset::snapshot ,sSQL,CRecordset::readOnly);
						
						while(!Query1.IsEOF())
						{
							if((bStop)||(bPause))
							{
								sError = _T("Прервано");
								break;
							}
							i = 0;
							Query1.GetFieldValue(i, dbValue);
							sValue = GetValue(&dbValue);
							i++;
							if(sValue.GetLength()<1)
							{
								Query1.GetFieldValue(1, dbValue);
								sValue = GetValue(&dbValue);
								dVal = dVal+ _wtofmy(GetValue(&dbValue));
								iCount++;
							}
							else
							{
								Query1.GetFieldValue(1, dbValue);
								dSumm = dSumm+  _wtofmy(GetValue(&dbValue));
							}

							i++;
							Query1.GetFieldValue(i, dbValue);
							sCDR = GetValue(&dbValue);

							i++;
							Query1.GetFieldValue(i, dbValue);
							sCCode = GetValue(&dbValue);

							i++;
							Query1.GetFieldValue(i, dbValue);
							sCName = GetValue(&dbValue);

							Query1.MoveNext();
						}
						Query1.Close();

						dSumm = dSumm + dVal/iCount;
						dSumm = (int)((dSumm+0.5)*100);
						dSumm = dSumm/100;
						
						sValue = "";
						for(int i = 3; i < 20; i++)
						{
							switch(i)
							{
								case 6:
									Query.GetFieldValue(i, dbValue);
									iCount = _wtoi(GetValue(&dbValue));
									sValue = sValue +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
									break;

								case 7:
									
									Query.GetFieldValue(i, dbValue);
									dSumm = _wtofmy(GetValue(&dbValue));	
									dSumm = (int)((dSumm+0.005)*100);
									dSumm = dSumm/100;

									sss.Format(_T("%.2f"),dSumm);
									sValue = sValue +sss+_T(";");
									break;

								case 8:
								case 10:
								case 11:
									Query.GetFieldValue(i, dbValue);
									sss = GetValue(&dbValue);
									if(sss.Left(1) == _T("."))
									{
										sss = _T("0")+sss;
									}
									sValue = sValue +sss+_T(";");
									break;

								case 9:
									sss.Format(_T("%.2f"),dSumm*iCount);
									
									sValue = sValue +sss+_T(";");
									break;

								case 12:
									sValue = sValue +sCDR+_T(";");
									break;

								case 13:
									sValue = sValue +sCCode+_T(";");
									break;

								case 14:
									sValue = sValue +sCName+_T(";");
									break;
								

								default:
									Query.GetFieldValue(i, dbValue);
									sValue = sValue +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
									break;
							}
						}
						stFile.WriteString(sValue+_T("\n"));
						Query.MoveNext();
					}
					Query.Close();
					stFile.Close();
				sDocArray.RemoveAt(0,1);
				}
		
				if(sOldFile.GetLength()>0)
				{
					try
					{
						stFile.Remove(sFileName+sOldFile+_T(".txt"));
					}
					catch(...)
					{
						DWORD Err;
						Err = GetLastError();
						if(Err != 2)
						{
							sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+sOldFile+_T(".txt"),GetLastErrorText());
						}
					}

					try
					{
						stFile.Rename(sFileName+_T("temp"),sFileName+sOldFile+_T(".txt"));
						sFileArray.Add(sFileName+sOldFile+_T(".txt"));
					}
					catch(...)
					{
						sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sFileName+sOldFile+_T(".txt"),GetLastErrorText());
					}
					
				}
			}
			catch(CDBException *exsept)
			{
				sError.Format(_T("%s %s"),exsept->m_strError, sSQL);
				exsept->Delete();
			}

		}
	}
	catch(...)
	{
		sError = GetLastErrorText();
	}

	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		while(sFileArray.GetCount())
		{
			WriteToLogFile(_T("Удаление ")+sFileArray.ElementAt(0));
			if(!DeleteFile(sFileArray.ElementAt(0)))
			{
				DWORD Err;
				Err = GetLastError();
				if(Err != 2)
				{
					CFile::Rename(sFileArray.ElementAt(0),sFileArray.ElementAt(0)+_T("_damage"));
				}
			}
			else
			{
				
			}
			sFileArray.RemoveAt(0,1);
		}
	}
	else
	{
		if(sError.GetLength()<1)
		{
			if(sLastDoc.GetLength()>0)
			{
				sWriteToIni(sPos,_T("PARAMETR_1"),sLastDoc);
			}
		}
	}
	return sError;
}

CString EXPORT_TYPE_8(int iPosition, CString sOldData, CString sNewData)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	CStringArray sFileArray;
	CDBVariant dbValue;

	CString sFilter;
	sFilter = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));

	CString sLastDoc;
	sLastDoc = sReadFromIni(sPos,_T("PARAMETR_1"),_T(""));
	
	CString sDivision;
	sDivision = sReadFromIni(sPos,_T("PARAMETR_2"),_T(""));

	//sPos
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказана директория выгрузки");
		return sError;
	}

	if(sFileName.Right(1)!=_T("\\"))
		sFileName = sFileName + _T("\\");

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}

	CString sSQL;
	CStdioFile stFile;
	int iFieldCount;
	CString sOldFile;
	try
	{
		if(dBase!=NULL)
		{	
			CStdioFile stFile;
			sOldFile = "";
			try
			{
				CStringArray sDocArray;
				if(sFilter.GetLength()>0)
					sFilter = sFilter+_T(" and ");
					

				if(sDivision.GetLength()>0)
				{
					sSQL.Format(_T("select distinct Left(CONVERT ( nchar , sih.[Posting Date], 112),8) as DatImport, sih.[No_],CONVERT ( nchar , sih.[Posting Date], 104), %s from [%s$Sales Invoice Line] as sil join [%s$Sales Invoice Header] as sih on sih.[No_] = sil.[Document No_] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = sil.[Document No_]	and cdr.[Line No_] = sil.[Line No_] left join [%s$NoExport1C]on DocNumber = sih.[No_] where %s Left(CONVERT ( nchar , sih.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , sih.[Posting Date], 112),8) < '%s' and (Export1C is Null or Export1C = 0) order by DatImport,sih.[No_]"),sDivision,sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sOldData,sNewData);
					iFieldCount = 4;
				}
				else
				{
					sSQL.Format(_T("select distinct sih.[No_], 'TN' as TN, '' as TNSer, '' as TNNumber, CONVERT ( nchar , sih.[Posting Date], 104), sih.[Currency Code],sih.[Posting Date]  from [%s$Sales Invoice Line] as sil join [%s$Sales Invoice Header] as sih on sih.[No_] = sil.[Document No_] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = sil.[Document No_]	and cdr.[Line No_] = sil.[Line No_] left join [%s$NoExport1C]on DocNumber = sih.[No_] join [%s$Custom Declaration Header] as cdh on cdh.[Custom Declaration No_] = cdr.[CD No_] and cdh.[Source No_] = 'V1' where %s Left(CONVERT ( nchar , sih.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , sih.[Posting Date], 112),8) < '%s' and (Export1C is Null or Export1C = 0) order by sih.[Posting Date],sih.[No_]"),sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sOldData,sNewData);
					iFieldCount = 3;
				}	
				
				//sSQL.Format(_T("select distinct Left(CONVERT ( nchar , sih.[Posting Date], 112),8) as DatImport, sih.[No_],CONVERT ( nchar , sih.[Posting Date], 104) from [%s$Sales Invoice Line] as sil join [%s$Sales Invoice Header] as sih on sih.[No_] = sil.[Document No_] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = sil.[Document No_]	and cdr.[Line No_] = sil.[Line No_] left join [%s$NoExport1C]on DocNumber = sih.[No_] where %s Left(CONVERT ( nchar , sih.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , sih.[Posting Date], 112),8) < '%s' and (Export1C is Null or Export1C = 0) order by DatImport,sih.[No_]"),sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sOldData,sNewData);
				
				CRecordset Query(dBase);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			
				sDocArray.RemoveAll();
				while(!Query.IsEOF())
				{
					if((bStop)||(bPause))
					{
						sError = _T("Прервано");
						break;
					}

					sSQL = "";
					for(int i = 0; i < iFieldCount; i++)
					{
						Query.GetFieldValue(i, dbValue);
						sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
					}

					sDocArray.Add(sSQL);
					Query.MoveNext();		
				}
				Query.Close();

			CStdioFile stFile;
			CString sValue;
			CString sDocNumber;

			int iPos;
			int iCol;
			iCol = 0;
			
			//int iPos;


			double dSumm;
			CString sData;
			iPos = 0;
			sOldFile = "";
			while(sDocArray.GetCount()>0)
			{

				if((bStop)||(bPause))
				{
					sError = _T("Прервано");
					break;
				}

				sValue = sDocArray.ElementAt(0);
				iPos = sValue.Find(_T(";"),0);
				if(iPos < 2)
				{
					sDocArray.RemoveAt(0,1);
					continue;
				}
				sData = sValue.Left(iPos);
				sValue = sValue.Right(sValue.GetLength() - iPos -1);

				/*
				sValue.Left(iPos)
				*/
				iPos = sValue.Find(_T(";"),0);
				if(iPos < 2)
				{
					sDocArray.RemoveAt(0,1);
					continue;
				}

				sDocNumber = sValue.Left(iPos);
				sValue = sValue.Right(sValue.GetLength() - iPos -1);


				iPos = sValue.Find(_T(";"),0);
				
				if(sOldFile != sData)
				{
					
					if(sOldFile.GetLength()>0)
					{
						try
						{
							stFile.Remove(sFileName+sOldFile+_T(".txt"));
						}
						catch(...)
						{
							DWORD Err;
							Err = GetLastError();
							if(Err != 2)
							{
								sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+sOldFile+_T(".txt"),GetLastErrorText());
								break;
							}
						}

						try
						{
							stFile.Rename(sFileName+_T("temp"),sFileName+sOldFile+_T(".txt"));
						}
						catch(...)
						{
							sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sFileName+sOldFile+_T(".txt"),GetLastErrorText());
							break;
						}
						
						sFileArray.Add(sFileName+sLastDoc+sOldFile+_T(".txt"));
					}
					
					
					if(!stFile.Open(sFileName+_T("temp"),CFile::modeCreate|CFile::modeWrite))
					{
						sError.Format(_T("Ошибка при создании файла %s %s"),sFileName+sDocNumber+_T(".txt"),GetLastErrorText());
						break;
					}
					
					stFile.WriteString(sValue+_T("\n"));	
					sOldFile = sData;
				}
				else
				{
					if(!stFile.Open(sFileName+_T("temp"),CFile::modeReadWrite))
					{
						sError.Format(_T("Ошибка при создании дозаписи %s %s"),sFileName+sDocNumber+_T(".txt"),GetLastErrorText());
						break;
					}
					stFile.SeekToEnd();
				}
			

			

				dSumm = 0.0;
				sSQL.Format(_T("select (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode,pil.[Unit of Measure],it.[Description 2],-cdr.[Quantity],pil.[Optimization Price],pil.[Ext_ VAT %%], pil.[Optimization Price]*(-cdr.[Quantity]),(select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = pil.[Unit of Measure Code])*0.9, (select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = pil.[Unit of Measure Code]) as wth,	cdr.[CD No_],cdh.[Country_Region of Origin Code],eep.NAME,it.[Description 2],it.[Description 2],it.[No_ 2],[tm].[Trade Mark Name],it.[No_] from [%s$Sales Invoice line] as pil left join [%s$Item] as it on pil.[No_] = it.[No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = pil.[Document No_] and cdr.[Line No_] = pil.[Line No_] join [%s$Custom Declaration Line] as cdh on cdh.[CD No_] = cdr.[CD No_] and cdh.[CD Line No_] = cdr.[CD Line No_] join [Country_Region] as eep on eep.[Code] = cdh.[Country_Region of Origin Code] where pil.[Document No_] = '%s' and pil.[Quantity] > 0"),sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDocNumber);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				while(!Query.IsEOF())
				{
					if((bStop)||(bPause))
					{
						sError = _T("Прервано");
						break;
					}

					sValue = "";
					for(int i = 0; i < 17; i++)
						{
							
							Query.GetFieldValue(i, dbValue);

							if(i==6)
							{
								dSumm = dSumm +  _wtof(GetValue(&dbValue));
							}


							if((i==7)||(i==8))
							{
								sDocNumber = GetValue(&dbValue);
								if(sDocNumber.Left(1)==_T("."))
									sDocNumber = _T("0")+sDocNumber;
								sValue = sValue+sDocNumber+ _T(";");
							}
							else
								sValue = sValue +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
						}
						stFile.WriteString(sValue+_T("\n"));
					Query.MoveNext();		
					}
					Query.Close();
					stFile.Close();
				
					sDocArray.RemoveAt(0,1);
			}


			if(stFile.m_pStream != NULL)
					stFile.Close();


				
			}
			catch(CDBException *exsept)
			{
				if(sOldFile.GetLength()>0)
					stFile.Close();
				sError.Format(_T("%s %s"),exsept->m_strError, sSQL);
				WriteToLogFile(sError);
				exsept->Delete();
			}
		
		}
		
		if(sOldFile.GetLength()>0)
		{
			try
			{
				stFile.Remove(sFileName+sLastDoc+sOldFile+_T(".txt"));
			}
			catch(...)
			{
				DWORD Err;
				Err = GetLastError();
				if(Err != 2)
				{
					sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+sLastDoc+sOldFile+_T(".txt"),GetLastErrorText());					
				}
			}

			try
			{
				stFile.Rename(sFileName+_T("temp"),sFileName+sLastDoc+sOldFile+_T(".txt"));
			}
			catch(...)
			{
				sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sFileName+sLastDoc+sOldFile+_T(".txt"),GetLastErrorText());
			}
			sFileArray.Add(sFileName+sLastDoc+sOldFile+_T(".txt"));
		}
	}
	catch(...)
	{
		sError = GetLastErrorText();
	}

	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	
	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		while(sFileArray.GetCount())
		{
			WriteToLogFile(_T("Удаление - ")+sFileArray.ElementAt(0));
			if(!DeleteFile(sFileArray.ElementAt(0)))
			{
				DWORD Err;
				Err = GetLastError();
				if(Err != 2)
				{
					CFile::Rename(sFileArray.ElementAt(0),sFileArray.ElementAt(0)+_T("_damage"));
				}
			}
			sFileArray.RemoveAt(0,1);
		}
	}
	else
	{
		if(sError.GetLength()<1)
		if(sLastDoc.GetLength()>0)
		{
			sWriteToIni(sPos,_T("PARAMETR_1"),sLastDoc);
		}
	}
	return sError;
}

CString EXPORT_TYPE_9(int iPosition, CString sOldData, CString sEndDate)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	CStringArray sFileArray;
	CDBVariant dbValue;

	CString sFilter;
	sFilter = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));

	CString sLastDoc;
	sLastDoc = sReadFromIni(sPos,_T("PARAMETR_1"),_T(""));

	CString sDivision;
	sDivision = sReadFromIni(sPos,_T("PARAMETR_2"),_T(""));

	//sPos
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказана директория выгрузки");
		return sError;
	}

	if(sFileName.Right(1)!=_T("\\"))
		sFileName = sFileName + _T("\\");

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}


	CString sSQL;
	int iFieldCount;
	try
	{
		if(dBase!=NULL)
		{	
			CStdioFile stFile;
			CString sOldFile;
			sOldFile = "";
			try
			{
				CRecordset Query(dBase);
				CStringArray sDocArray;


				CString sNewData;



				sNewData = sEndDate.Left(4);
				sNewData = sEndDate.Left(6).Right(2)+_T(".") + sNewData;
				sNewData = sEndDate.Right(2)+_T(".") + sNewData;
				short i;
					
				
				i = 0;
				
				//sOldData, sEndDate

				if(sFilter.GetLength()>0)
					sFilter = sFilter + _T(" and ");
				if(sDivision.GetLength()>0)
					{
						sSQL.Format(_T("select sih.[No_],'TN' as TN,'' as TNSer,sih.[Factura-Invoice No_],'%s', '7714881981','RSAG_SIRIUS', sih.[Currency Code], vn.[Name], vn.[Full Name], vn.[Ownership Code], vn.[No_], vn.[VAT Registration No_], vn.[KPP Code], vn.[OKPO Code], vn.[Address 2], vn.[Address], vn.[Phone No_] + ', факс' + vn.[Fax No_],va.[Customer No_], va.[VAT Bus_ Posting Group], va.[Currency Code], va.[External Agreement No_], CONVERT ( nchar , va.[Agreement Date], 104), va.[Legal Entity], CONVERT ( nchar , va.[Expire Date], 104), va.[No_], %s from [%s$Sales Invoice Header] as sih join [%s$Customer] as vn on vn.[No_] = sih.[Bill-to Customer No_] join [%s$Customer Agreement] as va on va.[Customer No_] = sih.[Bill-to Customer No_] and va.[No_] = sih.[Agreement No_] left join [%s$NoExport1C]on DocNumber = sih.[No_]  where %s Left(CONVERT ( nchar , sih.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , sih.[Posting Date], 112),8) < '%s' and (Export1C is Null or Export1C = 0) order by sih.[No_]"),sNewData,sDivision,sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sOldData, sEndDate);
						iFieldCount = 27;
					}
					else
					{
						sSQL.Format(_T("select sih.[No_],'TN' as TN,'' as TNSer,sih.[Factura-Invoice No_],'%s', '7714881981','RSAG_SIRIUS', sih.[Currency Code], vn.[Name], vn.[Full Name], vn.[Ownership Code], vn.[No_], vn.[VAT Registration No_], vn.[KPP Code], vn.[OKPO Code], vn.[Address 2], vn.[Address], vn.[Phone No_] + ', факс' + vn.[Fax No_],va.[Customer No_], va.[VAT Bus_ Posting Group], va.[Currency Code], va.[External Agreement No_], CONVERT ( nchar , va.[Agreement Date], 104), va.[Legal Entity], CONVERT ( nchar , va.[Expire Date], 104), va.[No_] from [%s$Sales Invoice Header] as sih join [%s$Customer] as vn on vn.[No_] = sih.[Bill-to Customer No_] join [%s$Customer Agreement] as va on va.[Customer No_] = sih.[Bill-to Customer No_] and va.[No_] = sih.[Agreement No_] left join [%s$NoExport1C]on DocNumber = sih.[No_]  where %s Left(CONVERT ( nchar , sih.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , sih.[Posting Date], 112),8) < '%s' and (Export1C is Null or Export1C = 0) order by sih.[No_]"),sNewData,sDivision,sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sOldData, sEndDate);
						iFieldCount = 26;
					}
					
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				sDocArray.RemoveAll();

				
				while(!Query.IsEOF())
				{
					if((bStop)||(bPause))
						{	
							sError = _T("Прервано");
							break;
						}

					sSQL = "";
					int i;
					i = 0; 
					while(i < iFieldCount)
					{
						Query.GetFieldValue(i, dbValue);
						sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
						i++;
					}
					sDocArray.Add(sSQL);
					Query.MoveNext();		
				}

				Query.Close();

				CStdioFile stFile;
				CString sValue;
				CString sDocNumber;

				int iPos;
				
				
				
				if(sDocArray.GetCount()>0)
				{
					if(!stFile.Open(sFileName+_T("temp"),CFile::modeCreate|CFile::modeWrite))
						{
							sError = GetLastErrorText();
						}
						else
						{
							sValue = sDocArray.ElementAt(0);
							iPos = sValue.Find(_T(";"),0);
							sValue = sValue.Right(sValue.GetLength() - iPos -1);
							stFile.WriteString(sValue+_T("\n"));
							stFile.Close();
						}
				
						while((sDocArray.GetCount()>0)&&(sError.GetLength()<1))
						{
							if((bStop)||(bPause))
							{
								sError = _T("Прервано");
								break;
							}

							sValue = sDocArray.ElementAt(0);
							iPos = sValue.Find(_T(";"),0);
							if(iPos < 2)
							{
								sDocArray.RemoveAt(0,1);
								continue;
							}
							
							sDocNumber = sValue.Left(iPos);
							sValue = sValue.Right(sValue.GetLength() - iPos -1);

			
							if(stFile.Open(sFileName+_T("temp"),CFile::modeReadWrite))
							{
								stFile.SeekToEnd();
							}
							
							sSQL.Format(_T("select (select Sum(ril_cdr.[Quantity]) from [%s$Sales Cr_Memo Line] as ril join [%s$Custom Declaration Relation] as ril_cdr on ril_cdr.[Document No_] = ril.[Document No_] and ril_cdr.[Line No_] = ril.[Line No_] where ril.[No_] = pil.[No_] and ril.[Bill-to Customer No_] = pil.[Bill-to Customer No_] and ril.[Appl_-from Item Entry] = coalesce(sl.[Item Shpt_ Entry No_],(select top 1 ve.[Item Ledger Entry No_] from [%s$Value Entry] as ve where pil.[Document No_] = ve.[Document No_] and pil.[No_] = ve.[Item No_] and pil.[Posting Date] = ve.[Posting Date] and ve.[Source Code] ='ПРОДАЖИ')) ) as Cr,(it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode,pil.[Unit of Measure],it.[Description 2],-cdr.[Quantity],pil.[Optimization Price],pil.[Ext_ VAT %%], pil.[Optimization Price],(select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = pil.[Unit of Measure Code])*0.9, (select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = pil.[Unit of Measure Code]) as wth,	cdr.[CD No_],cdh.[Country_Region of Origin Code],eep.NAME,it.[Description 2],it.[Description 2],it.[No_ 2],[tm].[Trade Mark Name],it.[No_] from [%s$Sales Invoice line] as pil left join [%s$Item] as it on pil.[No_] = it.[No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] left join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = pil.[Document No_] and cdr.[Line No_] = pil.[Line No_] left join [%s$Custom Declaration Line] as cdh on cdh.[CD No_] = cdr.[CD No_] and cdh.[CD Line No_] = cdr.[CD Line No_] left join [Country_Region] as eep on eep.[Code] = cdh.[Country_Region of Origin Code] left join [%s$Sales Shipment Line] as sl on pil.[Shipment No_] = sl.[Document No_] and sl.[No_] = pil.[No_] and pil.[Shipment Line No_] = sl.[Line No_] where pil.[Document No_] = '%s' and pil.[Quantity] > 0"),sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDocNumber);
							Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
							double dCol;
						
							while(!Query.IsEOF())
							{
								if((bStop)||(bPause))
								{	
									sError = _T("Прервано");
									break;
								}
		
								dCol = 0;
								sValue = "";
								for(int i = 0; i < 18; i++)
								{
										
								Query.GetFieldValue(i, dbValue);
								switch(i)
								{
									case 0:
										dCol = dCol - _wtof(GetValue(&dbValue));
										break;
										case 4:
										dCol = dCol + _wtof(GetValue(&dbValue));
										sDocNumber.Format(_T("%.2f"),dCol);
										sValue = sValue+sDocNumber+ _T(";");
										break;
										case 7:
										dCol = dCol * _wtof(GetValue(&dbValue));
										sDocNumber.Format(_T("%.2f"),dCol);
										sValue = sValue+sDocNumber+ _T(";");
										break;
										case 8:
									case 9:
										sDocNumber = GetValue(&dbValue);
										if(sDocNumber.Left(1)==_T("."))
											sDocNumber = _T("0")+sDocNumber;
										sValue = sValue+sDocNumber+ _T(";");
										break;
								
									default:
										sValue = sValue +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
										break;
								}
						
							}
							
							if(dCol>0)
								stFile.WriteString(sValue+_T("\n"));
							Query.MoveNext();		
						}
						Query.Close();
						stFile.Close();
						sDocArray.RemoveAt(0,1);
					}

					CString sName;
					try
					{
						sName.Format(_T("%sSir%s-%s_%s.txt"),sFileName,sOldData,sEndDate.Right(2),sDivision);
						if(sError.GetLength()<1)
						{
							if(!DeleteFile(sName))
							{
								DWORD Err;
								Err = GetLastError();
								if(Err != 2)
								{
									CFile::Rename(sName,sName+_T("_damage"));
								}
							}
							if(sError.GetLength()<1)
								stFile.Rename(sFileName+_T("temp"),sName);
						}
					}
					catch(...)
					{
						sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sName,GetLastErrorText());
					}
				}
			}
			catch(CDBException *exsept)
			{
				if(stFile.GetFileTitle()  != _T(""))
					stFile.Close();
				sError.Format(_T("%s %s"),exsept->m_strError, sSQL);
				WriteToLogFile(sError);
				exsept->Delete();	
			}
		
		}
	}
	catch(...)
	{
		sError = GetLastErrorText();
	}

	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	WriteToLogFile(sError);
	if(sError.GetLength()<1)
		if(sLastDoc.GetLength()>0)
		{			
			sWriteToIni(sPos,_T("PARAMETR_1"),sLastDoc);
		}

	return sError;
}

CString EXPORT_TYPE_10(int iPosition, CString sOldData, CString sNewData)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	CStringArray sFileArray;
	CDBVariant dbValue;

	CString sFilter;
	sFilter = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));

	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказана директория выгрузки");
		return sError;
	}

	if(sFileName.Right(1)!=_T("\\"))
		sFileName = sFileName + _T("\\");

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}

	CString sSQL;
	int iFieldCount;
	try
	{
		if(dBase!=NULL)
		{	
			CStdioFile stFile;
			CString sOldFile;
			sOldFile = "";
			try
			{
				CStringArray sDocArray;
				if(sFilter.GetLength()>0)
					sFilter = sFilter+_T(" and ");
				
				sSQL.Format(_T("select distinct sih.[No_], sih.[Factura-Invoice No_],CONVERT ( nchar , sih.[Posting Date],  104) from [%s$Batch Printing Log] as bpl join [%s$Sales Invoice Header] as sih on bpl.[Document No_] = sih.[No_] where %s Left(CONVERT ( nchar , Date_Time , 112),8) >= '%s' and Left(CONVERT ( nchar , Date_Time , 112),8) < '%s'"),sDatabase,sDatabase,sFilter,sOldData,sNewData);
				iFieldCount = 3;
					
				
				CRecordset Query(dBase);
				CStdioFile stFile;
				CString sValue;
				CString sDocNumber;


				CString sName;
				
				if(stFile.Open(sFileName+_T("temp"),CFile::modeCreate|CFile::modeWrite))
				{
					Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
					while(!Query.IsEOF())
					{
						if((bStop)||(bPause))
						{	
							sError = _T("Прервано");
							break;
						}

						sValue = "";
						for(int i = 0; i < iFieldCount; i++)
						{
							Query.GetFieldValue(i, dbValue);
							sDocNumber = GetValue(&dbValue);
							sValue = sValue +sReplaceLeftSynmbol(sDocNumber)+ _T(";");
						}
						stFile.WriteString(sValue+_T("\n"));
						Query.MoveNext();	
					}
					Query.Close();
					stFile.Close();
					
					if(sError.GetLength()<1)
					{
						try
						{
							sName.Format(_T("%s%s.txt"),sFileName,sOldData);
							if(!DeleteFile(sName))
							{
								DWORD Err;
								Err = GetLastError();
								if(Err != 2)
								{
									CFile::Rename(sName,sName+_T("_damage"));
								}
							}
							if(sError.GetLength()<1)
								stFile.Rename(sFileName+_T("temp"),sName);
						}
						catch(...)
						{
							sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sName,GetLastErrorText());
						}
					}
				}
				else
				{
					sError = GetLastErrorText();
				}
			}
			catch(CDBException *exsept)
			{
				if(stFile.GetFileTitle()  != _T(""))
					stFile.Close();
				sError.Format(_T("%s %s"),exsept->m_strError, sSQL);
				WriteToLogFile(sError);
				exsept->Delete();

			}
		
		}
	}
	catch(...)
	{
		sError = GetLastErrorText();
	}
	
	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	
	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
	}
	
	return sError;
}

CString EXPORT_TYPE_11(int iPosition)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	CStringArray sFileArray;
	CDBVariant dbValue;
	
	CString sFilter;
	sFilter = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));

	CString sLastDoc;
	sLastDoc = sReadFromIni(sPos,_T("PARAMETR_1"),_T(""));

	CString sDivision;
	sDivision = sReadFromIni(sPos,_T("PARAMETR_2"),_T(""));

	//PARAMETR_3

	CString sPostFix;
	sPostFix = sReadFromIni(sPos,_T("PARAMETR_3"),_T(""));
	//sPos
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказана директория выгрузки");
		return sError;
	}

	if(sFileName.Right(1)!=_T("\\"))
		sFileName = sFileName + _T("\\");

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}
	
	CString sSQL;
	try
	{
		if(dBase!=NULL)
		{	
			CStdioFile stFile;
			CString sOldFile;
			sOldFile = "";
			int iFieldCount;
			try
			{
				sFileArray.RemoveAll();
				CStringArray sDocArray;
				CDBVariant dbVar;
						
				if(sFilter.GetLength()>0)
					sFilter = sFilter + _T(" and ");
				
				
				//
				/*
				0,1,'V1'
				*/
				iFieldCount = 5;
				if(sDivision.GetLength()>0)
					{
						int iFind;
						iFind = -1;
						do
						{
							iFieldCount++;
							iFind = sDivision.Find(_T(","),iFind+1);
						}
						while(iFind > 0);
						sSQL.Format(_T("select distinct trh.[No_], 'TN' as TN, '' as TNSer, '' as TNNumber, CONVERT ( nchar , trh.[Posting Date], 104),%s from [%s$Transfer Receipt Header] as trh join [%s$Transfer Receipt Line] as trl on  trh.[No_] = trl.[Document No_] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = trl.[Document No_]	and cdr.[Line No_] = trl.[Line No_] left join [%s$NoExport1C]on DocNumber = trh.[No_] join [%s$Custom Declaration Header] as cdh on cdh.[Custom Declaration No_] = cdr.[CD No_]  join [%s$Custom Declaration Relation] as cdr2 on cdr2.[Source Item Ledger Entry No_] = cdr.[Source Item Ledger Entry No_] and cdr2.[Document Type] = 5 join [%s$Purch_ Rcpt_ Line] as prl on prl.[Document No_] = cdr2.[Document No_] and prl.[Line No_] = cdr2.[Line No_] join [%s$Purch_ Rcpt_ Header] as pih on pih.[No_] = cdr2.[Document No_]  where %s trh.[No_] > '%s'"),sDivision ,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sLastDoc);
						
					}
					else
					{
						sSQL.Format(_T("select distinct trh.[No_], 'TN' as TN, '' as TNSer, '' as TNNumber, CONVERT ( nchar , trh.[Posting Date], 104) from [%s$Transfer Receipt Header] as trh join [%s$Transfer Receipt Line] as trl on  trh.[No_] = trl.[Document No_] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = trl.[Document No_]	and cdr.[Line No_] = trl.[Line No_] left join [%s$NoExport1C]on DocNumber = trh.[No_] join [%s$Custom Declaration Header] as cdh on cdh.[Custom Declaration No_] = cdr.[CD No_]  join [%s$Custom Declaration Relation] as cdr2 on cdr2.[Source Item Ledger Entry No_] = cdr.[Source Item Ledger Entry No_] and cdr2.[Document Type] = 5 join [%s$Purch_ Rcpt_ Line] as prl on prl.[Document No_] = cdr2.[Document No_] and prl.[Line No_] = cdr2.[Line No_] join [%s$Purch_ Rcpt_ Header] as pih on pih.[No_] = cdr2.[Document No_]  where %s trh.[No_] > '%s'"),sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sLastDoc);
					}
					
				
				
				

				CRecordset Query(dBase);
				CRecordset Query1(dBase);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			
				sDocArray.RemoveAll();
				
				while(!Query.IsEOF())
				{
					if((bStop)||(bPause))
					{
						sError = _T("Прервано");
						break;
					}
					sSQL = "";
					
					for(int i = 0; i < iFieldCount; i++)
					{
						Query.GetFieldValue(i, dbValue);
						if(i==0)
						{
							if(sLastDoc < sReplaceLeftSynmbol(GetValue(&dbValue)))
								sLastDoc = sReplaceLeftSynmbol(GetValue(&dbValue));

							sSQL = sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
						}
						else
							sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
						
					}
					sDocArray.Add(sSQL);
					Query.MoveNext();		
				}
				Query.Close();

				CStdioFile stFile;
				CString sValue;
				CString sDocNumber,sDoc;

				sFileArray.RemoveAll();
				int iPos;
				//WriteToLogFile(_T("Cicle"));
				while(sDocArray.GetCount()>0)
				{
					
					sValue = sDocArray.ElementAt(0);
					iPos = sValue.Find(_T(";"),0);
					if(iPos < 2)
					{
						sDocArray.RemoveAt(0,1);
						continue;
					}
					sDocNumber = sValue.Left(iPos);
					sDoc = sDocNumber;
					sValue = sValue.Right(sValue.GetLength() - iPos -1);

					iPos = sValue.Find(_T(";"),0);
					if(iPos < 2)
					{
						sDocArray.RemoveAt(0,1);
						continue;
					}

					if((bStop)||(bPause))
						{
							sError = _T("Прервано");
							break;
						}

					
					if(stFile.Open(sFileName+_T("temp"),CFile::modeCreate|CFile::modeWrite))
					{
						stFile.WriteString(sValue+_T("\n"));
						sSQL.Format(_T("select (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode,trl.[Unit of Measure],it.[Description 2],cdr.[Quantity],'','','',(select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = trl.[Unit of Measure Code])*0.9, (select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = trl.[Unit of Measure Code]) as wth,cdr.[CD No_],cdl.[Country_Region of Origin Code],eep.NAME,it.[Description 2],it.[Description 2],it.[No_ 2],[tm].[Trade Mark Name],it.[No_] from [%s$Transfer Receipt Line] as trl left join [%s$Item] as it on trl.[Item No_] = it.[No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = trl.[Document No_] and cdr.[Line No_] = trl.[Line No_] join [%s$Custom Declaration Line] as cdl on cdl.[CD No_] = cdr.[CD No_] and cdl.[CD Line No_] = cdr.[CD Line No_] join [Country_Region] as eep on eep.[Code] = cdl.[Country_Region of Origin Code] join [%s$Custom Declaration Header] as cdh on cdh.[Custom Declaration No_] = cdr.[CD No_] join [%s$Custom Declaration Relation] as cdr2 on cdr2.[Source Item Ledger Entry No_] = cdr.[Source Item Ledger Entry No_] and cdr2.[Document Type] = 5 join [%s$Purch_ Rcpt_ Line] as prl on prl.[Document No_] = cdr2.[Document No_] and prl.[Line No_] = cdr2.[Line No_] join [%s$Purch_ Rcpt_ Header] as pih on pih.[No_] = cdr2.[Document No_] where %s trl.[Document No_] = '%s' and trl.[Quantity] > 0"),sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sFilter, sDocNumber);
						
						Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
						while(!Query.IsEOF())
						{
							if((bStop)||(bPause))
							{
								sError = _T("Прервано");
								break;
							}
							sValue = "";
							for(int i = 0; i < 17; i++)
							{
								Query.GetFieldValue(i, dbValue);
								sValue = sValue +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
							}
							stFile.WriteString(sValue+_T("\n"));
						Query.MoveNext();		
						}
						Query.Close();
						stFile.Close();
						
						try
						{
							if(!DeleteFile(sFileName+sDoc+_T("_")+sPostFix+_T(".txt")))
							{
								DWORD Err;
								Err = GetLastError();
								if(Err != 2)
								{
									CFile::Rename(sFileName+sDoc+_T("_")+sPostFix+_T(".txt"),sFileName+sDoc+_T("_")+sPostFix+_T(".txt")+_T("_damage"));
								}
							}
							if(sError.GetLength()<1)
							{
								stFile.Rename(sFileName+_T("temp"),sFileName+sDoc+_T("_")+sPostFix+_T(".txt"));
							}
							else
								break;
						}
						catch(...)
						{
							sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sFileName+sDoc+_T("_")+sPostFix+_T(".txt"),GetLastErrorText());
							break;
						}
						
						sFileArray.Add(sFileName+sDocNumber+_T("_")+sPostFix+_T(".txt"));
					}
					

					sDocArray.RemoveAt(0,1);
				}
			}
			catch(CDBException *exsept)
			{
				//if(stFile.)
				if(stFile.GetFileTitle()  != _T(""))
					stFile.Close();
				sError.Format(_T("%s %s"),exsept->m_strError, sSQL);
				exsept->Delete();
			}
		}
	}
	catch(...)
	{
		sError = GetLastErrorText();
	}


	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		while(sFileArray.GetCount())
		{
			if(!DeleteFile(sFileArray.ElementAt(0)))
			{
				DWORD Err;
				Err = GetLastError();
				if(Err != 2)
				{
					CFile::Rename(sFileArray.ElementAt(0),sFileArray.ElementAt(0)+_T("_damage"));
				}
			}
			sFileArray.RemoveAt(0,1);
		}
	}
	else
	{
		if(sError.GetLength()<1)
		if(sLastDoc.GetLength()>0)
		{
			sWriteToIni(sPos,_T("PARAMETR_1"),sLastDoc);
		}
	}
	return sError;
}

CString EXPORT_TYPE_12(int iPosition, CString sOldDate)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	

	CDBVariant dbValue;
	
	int iCountField;
	iCountField = _wtoi(sReadFromIni(sPos,_T("FIELD"),_T("0")));
	if(iCountField < 1)
	{
		sError.Format(_T("Неопределены поля"));
		return sError;
	}
	
	int iPos;
	iPos = 0;
	CStringArray sFieldArray;
	sFieldArray.RemoveAll();

	CString sLastDoc;
	
	CString sFilter;
	sFilter = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));
	if(sFilter.GetLength()<1)
	{
		sError.Format(_T("Не указанна таблица БД"));
		return sError;
	}
	sFilter.Replace(_T("\\"),_T("_"));
	sFilter.Replace(_T("/"),_T("_"));
	sFilter.Replace(_T("."),_T("_"));
	sFilter = _T("[")+sFilter+_T("]");

	CString sFilt;
	sFilt = sReadFromIni(sPos,_T("PARAMETR_2"),_T(""));
	if(sFilt.GetLength()>0)
	{
		sFilt = _T(" and ")+sFilt;
	}
	while(iPos<iCountField)
	{
		sLastDoc.Format(_T("FIELD_%d"),iPos);
		sLastDoc = sReadFromIni(sPos,sLastDoc,_T(""));
		sLastDoc = _T("[")+sLastDoc+_T("]");
		if(sLastDoc.GetLength()<1)
		{
			sError.Format(_T("Неопределено поле - %d"),iPos);
			return sError;
		}
		sLastDoc.Replace(_T("\\"),_T("_"));
		sLastDoc.Replace(_T("/"),_T("_"));
		sLastDoc.Replace(_T("."),_T("_"));
		sFieldArray.Add(sLastDoc);
		sLastDoc.Format(_T("FIELD_NAME_%d"),iPos);
		sFieldArray.Add(sReadFromIni(sPos,sLastDoc,sFieldArray.ElementAt(sFieldArray.GetCount()-1)));
		iPos++;
	}
	sLastDoc = sReadFromIni(sPos,_T("PARAMETR_1"),_T("0"));

	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказана директория выгрузки");
		return sError;
	}

	if(sFileName.Right(1)!=_T("\\"))
		sFileName = sFileName + _T("\\");

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}
	
	CString sSQL;
	CStdioFile stFile;
	try
	{
		if(dBase!=NULL)
		{	
			
			CString sOldFile;
			sOldFile = "";
			
			try
			{
				CStdioFile stFile;
				CDBVariant dbVar;
				BOOL bFile;
				bFile = TRUE;
				if(!stFile.Open(sFileName+ _T("temp"),CFile::modeCreate|CFile::modeWrite))
				{
					sError.Format(_T("Немогу создать файл выгрузки :%s, %s"),sFileName,GetLastErrorText());
					if(dBase!=NULL)
					{	
						if(dBase->IsOpen())
						{
							dBase->Close();
						}
						delete(dBase);
					}
					return sError;
				}

				
				CRecordset Query(dBase);
				
				sSQL.Format(_T("select CONVERT(bigint, [timestamp]),"));
				iPos = 0;
				while(iPos<sFieldArray.GetCount())
				{
					sSQL = sSQL + sFieldArray.ElementAt(iPos)+_T(",");
					stFile.WriteString(sFieldArray.ElementAt(iPos+1)+_T(";"));
					iPos = iPos + 2;
				}
				stFile.WriteString(_T("\n"));
			
				sSQL = sSQL.Left(sSQL.GetLength()-1) + _T(" From ");
				sSQL = sSQL+ sFilter;
				sSQL = sSQL + _T(" where CONVERT(bigint, [timestamp]) > ")+ sLastDoc;
				sSQL = sSQL + sFilt;
				sSQL = sSQL + _T(" order by [timestamp]");
				
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				if(Query.IsEOF())
				{
					stFile.Close();
					Query.Close();
					stFile.Remove(sFileName+ _T("temp"));
					bFile = FALSE;
				}
				else
				{
					CString sNewDoc;
					while(!Query.IsEOF())
					{
						if((bStop)||(bPause))
						{
							sError = _T("Прервано");
							break;
						}
						sSQL = "";
						iPos = 0;
						Query.GetFieldValue(iPos, dbValue);
						iPos = _wtoi(GetValue(&dbValue));
						sNewDoc = GetValue(&dbValue);
						while(sNewDoc.GetLength()> sLastDoc.GetLength())
						{
							sLastDoc = _T("0")+sLastDoc;
						}

						if(sLastDoc < sNewDoc)
						{
							sLastDoc = sNewDoc;
						}
					
						for(iPos = 1;iPos <= iCountField;iPos++)
						{
							Query.GetFieldValue(iPos, dbValue);
							sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
						}
						stFile.WriteString(sSQL+_T("\n"));
						Query.MoveNext();		
					}
					Query.Close();
					stFile.Close();
				}

				if((sError.GetLength()<1)&&(bFile))
				{
					try
					{
						stFile.Remove(sFileName+sFilter+sOldDate+_T(".txt"));
					}
					catch(...)
					{
						DWORD Err;
						Err = GetLastError();
						if(Err != 2)
						{
							sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+sOldDate+_T(".txt"),GetLastErrorText());
						}
					}
					
					try
					{
						stFile.Rename(sFileName+_T("temp"),sFileName+sFilter+sOldDate+_T(".txt"));
					}
					catch(...)
					{
						sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sFileName+sFilter+sOldDate+_T(".txt"),GetLastErrorText());
					}
				}
			}
			catch(CDBException *exsept)
			{
				//if(stFile.)
				if(stFile.GetFileTitle()  != _T(""))
					stFile.Close();
				sError.Format(_T("%s %s"),exsept->m_strError, sSQL);
				exsept->Delete();
			}
		}
		
	}
	catch(...)
	{
		sError = GetLastErrorText();
	}
	
	

	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		try
		{
			stFile.Remove(sFileName+sFilter+_T(".txt"));
		}
		catch(...)
		{
			DWORD Err;
			Err = GetLastError();
			if(Err != 2)
			{
				sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+sOldDate+_T(".txt"),GetLastErrorText());
			}
		}
	}
	else
	{
		if(sError.GetLength()<1)
		if(sLastDoc.GetLength()>0)
		{
			sWriteToIni(sPos,_T("PARAMETR_1"),sLastDoc);
		}
	}
	return sError;
}


CString EXPORT_TYPE_14(int iPosition, CString sOldDate)
{
	
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	

	CDBVariant dbValue;
	
	CString Par = sReadFromIni(sPos,_T("PARAMETR_0"),_T("Russian"));
	setlocale(LC_ALL,(CStringA)Par);

	int iCountField;
	iCountField = _wtoi(sReadFromIni(sPos,_T("SQL_COUNT"),_T("0")));
	if(iCountField < 1)
	{
		sError.Format(_T("Неопределен SQL инструкция"));
		return sError;
	}
	
	int iPos;
	iPos = 0;
	CStringArray sFieldArray;
	sFieldArray.RemoveAll();

	CString sLastDoc;
	
	CString sSQL;
	sSQL = "";
	while(iPos<iCountField)
	{
		sLastDoc.Format(_T("SQL_%d"),iPos);
		sLastDoc = sReadFromIni(sPos,sLastDoc,_T(""));
		sSQL = sSQL+sLastDoc+_T(" ");
		iPos++;
	}
	
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказан файл выгрузки");
		return sError;
	}

	

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}
	

	CStdioFile stFile;
	CString sNewName;
	try
	{
		if(dBase!=NULL)
		{	
			
			CString sOldFile;
			sOldFile = "";
			
			try
			{
				CStdioFile stFile;
				CDBVariant dbVar;
				BOOL bFile;
				bFile = TRUE;
				if(!stFile.Open(sFileName+ _T("temp"),CFile::modeCreate|CFile::modeWrite))
				{
					sError.Format(_T("Немогу создать файл выгрузки :%s, %s"),sFileName,GetLastErrorText());
					if(dBase!=NULL)
					{	
						if(dBase->IsOpen())
						{
							dBase->Close();
						}
						delete(dBase);
					}
					return sError;
				}

				
				CRecordset Query(dBase);
				
					
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				
				if(Query.IsEOF())
				{
					stFile.Close();
					Query.Close();
					stFile.Remove(sFileName+ _T("temp"));
					bFile = FALSE;
				}
				else
				{
					CString sNewDoc;
					int iCountField;
					iCountField = _wtoi(sReadFromIni(sPos,_T("FIELD_COUNT"),_T("0")));

					if (iCountField > 0)
					while(!Query.IsEOF())
					{
						if((bStop)||(bPause))
						{
							sError = _T("Прервано");
							break;
						}
						sSQL = "";
						
						for(iPos = 0;iPos < iCountField;iPos++)
						{
							Query.GetFieldValue(iPos, dbValue);
							sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
						}
						/*
						sSQL
						*/
						stFile.WriteString( sSQL+_T("\n"));
						Query.MoveNext();		
					}
					Query.Close();
					stFile.Close();
				}

				if((sError.GetLength()<1)&&(bFile))
				{
					try
					{
						stFile.Remove(sFileName);
					}
					catch(...)
					{
						DWORD Err;
						Err = GetLastError();
						if(Err != 2)
						{
							sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+sOldDate+_T(".txt"),GetLastErrorText());
						}
					}
					
					try
					{
						COleDateTime oDate;
						oDate = COleDateTime::GetCurrentTime();
						//sFileName.Replace(_T("_date"),oDate.Format(_T("_%d.%m.%Y_%H.%M")));
						sNewName = sFileName;
						sNewName.Replace(_T("_date"),oDate.Format(_T("_%d.%m.%Y_%H.%M")));
						stFile.Rename(sFileName+_T("temp"),sNewName);
					}
					catch(...)
					{
						sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sFileName,GetLastErrorText());
					}
				}
			}
			catch(CDBException *exsept)
			{
				//if(stFile.)
				if(stFile.GetFileTitle()  != _T(""))
					stFile.Close();
				sError.Format(_T("%s %s"),exsept->m_strError, sSQL);
				exsept->Delete();
			}
		}
		
	}
	catch(...)
	{
		sError = GetLastErrorText();
	}
	
	

	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		try
		{
			stFile.Remove(sFileName);
		}
		catch(...)
		{
			DWORD Err;
			Err = GetLastError();
			if(Err != 2)
			{
				sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+_T(".txt"),GetLastErrorText());
			}
		}
	}
	else
	{
		if(sError.GetLength()<1)
		if(sLastDoc.GetLength()>0)
		{
			sWriteToIni(sPos,_T("PARAMETR_1"),sLastDoc);
		}
	}
	return sError;
}

CString EXPORT_TYPE_15(int iPosition, CString sOldDate)
{
	
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	

	CDBVariant dbValue;
	
	
	setlocale(LC_ALL,"Russian");

	CString sFilter = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));
	CString sLastDoc = sReadFromIni(sPos,_T("PARAMETR_1"),_T("0"));
	
	CString sSQL;
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Не указанна директория выгрузки");
		return sError;	
	}

	if(sFileName.Right(1)!=_T("\\"))
	{
		sFileName = sFileName+_T("\\");
	}

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}
	

	CStdioFile stFile;
	int iPos;
	CString sNewName;
	try
	{
		if(dBase!=NULL)
		{	
			
			CString sOldFile;
			sOldFile = "";
			
			try
			{
				CStdioFile stFile;
				CDBVariant dbVar;
				BOOL bFile;
				bFile = TRUE;
						
				CRecordset Query(dBase);
			
				if(sFilter.GetLength()>0)
				{
					sFilter = sFilter + _T(" and ");
				}
				CString sNewFile;
				sSQL.Format(_T("select [Entry No_],CONVERT ( nchar , bale.[Posting Date], 112)+'_'+[Bank Account No_]+'_'+CONVERT ( nchar ,[Entry No_]),[Bank Account No_],CONVERT ( nchar , bale.[Posting Date], 104) ,-1*[Amount] from [%s$Bank Account Ledger Entry] as bale where %s [Entry No_] > %s order by [Entry No_]"),sDatabase,sFilter,sLastDoc);
				WriteToLogFile(sSQL);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				while(!Query.IsEOF())
					{
						if((bStop)||(bPause))
						{
							sError = _T("Прервано");
							break;
						}
						sSQL = "";
						if(!stFile.Open(sFileName+ _T("temp"),CFile::modeCreate|CFile::modeWrite))
						{
							sError.Format(_T("Немогу создать файл выгрузки :%s, %s"),sFileName,GetLastErrorText());
							break;
						}

						iPos = 0;
						Query.GetFieldValue(iPos, dbValue);
						sNewFile = sReplaceLeftSynmbol(GetValue(&dbValue));
						if(_wtoi(sNewFile) > _wtoi(sLastDoc))
						{
							sLastDoc = sNewFile;
						}

						iPos = 1;
						Query.GetFieldValue(iPos, dbValue);
						sNewFile = sReplaceLeftSynmbol(GetValue(&dbValue));
						sNewFile.Replace(_T(" "),_T(""));

						sNewFile = sFileName+sNewFile+ _T(".txt");
						

						sSQL = "";
						for(iPos = 2;iPos < 5;iPos++)
						{
							Query.GetFieldValue(iPos, dbValue);
							sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
						}
						
						stFile.WriteString(sSQL+_T("\n"));
						stFile.Close();

						try
						{
							stFile.Remove(sNewFile);
						}
						catch(...)
						{
							DWORD Err;
							Err = GetLastError();
							if(Err != 2)
							{
								sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+sOldDate+_T(".txt"),GetLastErrorText());
								break;
							}
							
						}

						try
						{
							stFile.Rename(sFileName+_T("temp"),sNewFile);
						}
						catch(...)
						{
							sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sFileName,GetLastErrorText());
							break;
						}
						Query.MoveNext();		
					}
					Query.Close();
			}
			catch(CDBException *exsept)
			{
				if(stFile.m_pStream != NULL)
					stFile.Close();
				sError.Format(_T("%s %s"),exsept->m_strError, sSQL);
				exsept->Delete();
			}
		}
		
	}
	catch(...)
	{
		sError = GetLastErrorText();
	}
	
	

	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		try
		{
			stFile.Remove(sFileName);
		}
		catch(...)
		{
			DWORD Err;
			Err = GetLastError();
			if(Err != 2)
			{
				sError.Format(_T("Ошибка удаление %s в %s %s"),sFileName+_T(".txt"),GetLastErrorText());
			}
		}
	}
	else
	{
		if(sError.GetLength()<1)
		if(sLastDoc.GetLength()>0)
		{
			sWriteToIni(sPos,_T("PARAMETR_1"),sLastDoc);
		}
	}
	return sError;
}


CString EXPORT_TYPE_6(int iPosition, CString sOldData, CString sNewData)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	CStringArray sFileArray;
	CDBVariant dbValue;

	CString sFilter;
	sFilter = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));

	CString sDivision;
	sDivision = sReadFromIni(sPos,_T("PARAMETR_1"),_T(""));

	//sPos
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказана директория выгрузки");
		return sError;
	}

	if(sFileName.Right(1)!=_T("\\"))
		sFileName = sFileName + _T("\\");

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}

	CString sSQL;
	int iFieldCount;
	try
	{
		if(dBase!=NULL)
		{	
			CStdioFile stFile;
			CString sOldFile;
			sOldFile = "";
			try
			{
				CStringArray sDocArray;
				if(sFilter.GetLength()>0)
					sFilter = sFilter+_T(" and ");
				
				if(sDivision.GetLength()>0)
					{
						//sSQL.Format(_T("select distinct sih.[No_], 'TN' as TN, '' as TNSer, '' as TNNumber, CONVERT ( nchar , sih.[Posting Date], 104), sih.[Currency Code],%s, sih.[Posting Date]   from [%s$Sales Invoice Line] as sil join [%s$Sales Invoice Header] as sih on sih.[No_] = sil.[Document No_] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = sil.[Document No_]	and cdr.[Line No_] = sil.[Line No_] left join [%s$NoExport1C]on DocNumber = sih.[No_] join [%s$Custom Declaration Header] as cdh on cdh.[Custom Declaration No_] = cdr.[CD No_] and cdh.[Source No_] = 'V1' join [%s$Custom Declaration Relation] as cdr2 on cdr.[Source Item Ledger Entry No_] = cdr2.[Source Item Ledger Entry No_] and cdr2.[Document Type] = 5 join [%s$Purch_ Rcpt_ Header] as prh on prh.[No_] = cdr2.[Document No_] and pih.[Buy-from Vendor No_] = 'V1' where %s Left(CONVERT ( nchar , sih.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , sih.[Posting Date], 112),8) < '%s' and (Export1C is Null or Export1C = 0) order by sih.[Posting Date],sih.[No_]"),sDivision,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sOldData,sNewData);
						sSQL.Format(_T("select distinct sih.[No_], 'TN' as TN, '' as TNSer, '' as TNNumber, CONVERT ( nchar , sih.[Posting Date], 104), sih.[Currency Code],%s, sih.[Posting Date]   from [%s$Sales Invoice Line] as sil join [%s$Sales Invoice Header] as sih on sih.[No_] = sil.[Document No_] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = sil.[Document No_]	and cdr.[Line No_] = sil.[Line No_] left join [%s$NoExport1C]on DocNumber = sih.[No_] join [%s$Custom Declaration Header] as cdh on cdh.[Custom Declaration No_] = cdr.[CD No_] join [%s$Custom Declaration Relation] as cdr2 on cdr.[Source Item Ledger Entry No_] = cdr2.[Source Item Ledger Entry No_] and cdr2.[Document Type] = 5 join [%s$Purch_ Rcpt_ Header] as prh on prh.[No_] = cdr2.[Document No_] and prh.[Buy-from Vendor No_] = 'V1' where %s Left(CONVERT ( nchar , sih.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , sih.[Posting Date], 112),8) < '%s' and (Export1C is Null or Export1C = 0) order by sih.[Posting Date],sih.[No_]"),sDivision,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sOldData,sNewData);
						iFieldCount = 7;
					}
					else
					{
						sSQL.Format(_T("select distinct sih.[No_], 'TN' as TN, '' as TNSer, '' as TNNumber, CONVERT ( nchar , sih.[Posting Date], 104), sih.[Currency Code],sih.[Posting Date]  from [%s$Sales Invoice Line] as sil join [%s$Sales Invoice Header] as sih on sih.[No_] = sil.[Document No_] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = sil.[Document No_]	and cdr.[Line No_] = sil.[Line No_] left join [%s$NoExport1C]on DocNumber = sih.[No_] join [%s$Custom Declaration Header] as cdh on cdh.[Custom Declaration No_] = cdr.[CD No_] join [%s$Custom Declaration Relation] as cdr2 on cdr.[Source Item Ledger Entry No_] = cdr2.[Source Item Ledger Entry No_] and cdr2.[Document Type] = 5 join [%s$Purch_ Rcpt_ Header] as prh on prh.[No_] = cdr2.[Document No_] and prh.[Buy-from Vendor No_] = 'V1' where %s Left(CONVERT ( nchar , sih.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , sih.[Posting Date], 112),8) < '%s' and (Export1C is Null or Export1C = 0) order by sih.[Posting Date],sih.[No_]"),sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sOldData,sNewData);
						iFieldCount = 6;
					}
					
				//sSQL.Format(_T("select distinct sih.[No_], 'TN' as TN, '' as TNSer, '' as TNNumber, CONVERT ( nchar , sih.[Posting Date], 104), sih.[Currency Code],sih.[Posting Date]  from [%s$Sales Invoice Line] as sil join [%s$Sales Invoice Header] as sih on sih.[No_] = sil.[Document No_] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = sil.[Document No_]	and cdr.[Line No_] = sil.[Line No_] left join [%s$NoExport1C]on DocNumber = sih.[No_] join [%s$Custom Declaration Header] as cdh on cdh.[Custom Declaration No_] = cdr.[CD No_] and cdh.[Source No_] = 'V1' where %s Left(CONVERT ( nchar , sih.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , sih.[Posting Date], 112),8) < '%s' and (Export1C is Null or Export1C = 0) order by sih.[Posting Date],sih.[No_]"),sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sOldData,sNewData);
				
				CRecordset Query(dBase);
				
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				
				sDocArray.RemoveAll();
				
				while(!Query.IsEOF())
				{
					if((bStop)||(bPause))
					{
						sError = _T("Прервано");
						break;
					}

					sSQL = "";
					for(int i = 0; i < iFieldCount; i++)
					{
						Query.GetFieldValue(i, dbValue);
						sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
					}
					
					sDocArray.Add(sSQL);
					Query.MoveNext();		
				}
				
				Query.Close();

				CStdioFile stFile;
				CString sValue;
				CString sDocNumber;

				int iPos;
				CString sName;
				
				//sName.Format(_T("%s%s_%d.txt"),sFileName,sOldData,0);
				//sFileArray.Add(sName);
				if(sDocArray.GetCount() > 0)
				{
					if(stFile.Open(sFileName+_T("temp"),CFile::modeCreate|CFile::modeWrite))
					{
						
						sValue = sDocArray.ElementAt(0);
						
						iPos = sValue.Find(_T(";"),0);
						if(iPos < 2)
						{
							sDocArray.RemoveAt(0,1);
						}
					
						sDocNumber = sValue.Left(iPos);
						sValue = sValue.Right(sValue.GetLength() - iPos -1);
	
						stFile.WriteString(sValue+_T("\n"));
						
						while(sDocArray.GetCount()>0)
						{
							if((bStop)||(bPause))
							{
								sError = _T("Прервано");
								break;
							}
				
							sValue = sDocArray.ElementAt(0);
							iPos = sValue.Find(_T(";"),0);
							if(iPos < 2)
							{
								sDocArray.RemoveAt(0,1);
								continue;
							}
						
							sDocNumber = sValue.Left(iPos);
							sValue = sValue.Right(sValue.GetLength() - iPos -1);
					
							sSQL.Format(_T("select (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode,sil.[Unit of Measure],it.[Description 2],-cdr.[Quantity],prl.[Direct Unit Cost],'0', sil.[Line Amount],(select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = sil.[Unit of Measure Code])*0.9, (select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = sil.[Unit of Measure Code]) as wth,cdr.[CD No_],cdl.[Country_Region of Origin Code] as Country_Code,eep.NAME as Country_Name,it.[Description 2], it.[Description 2], it.[No_ 2], [tm].[Trade Mark Name],it.[No_] from [%s$Sales Invoice Line] as sil join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = sil.[Document No_] and cdr.[Line No_] = sil.[Line No_] join [%s$Custom Declaration Relation] as cdr2 on cdr2.[Source Item Ledger Entry No_] = cdr.[Source Item Ledger Entry No_] and cdr2.[Document Type] = 5 left join [%s$Custom Declaration Line] as cdl on cdl.[CD No_] = cdr.[CD No_] and cdl.[CD Line No_] = cdr.[CD Line No_] join [%s$Purch_ Rcpt_ Line] as prl on prl.[Document No_] = cdr2.[Document No_] and prl.[Line No_] = cdr2.[Line No_] join [%s$Purch_ Rcpt_ Header] as pih on pih.[No_] = cdr2.[Document No_] and pih.[Buy-from Vendor No_] = 'V1' join [%s$Item] as it on it.[No_] = sil.[No_] join [tm] on it.[TM Code] = tm.[Trade Mark Code] left join [Country_Region] as eep on eep.[Code] = cdl.[Country_Region of Origin Code] join [%s$Purch_ Rcpt_ Header] as prh on prh.[No_] = cdr2.[Document No_] where %s sil.[Document No_] = '%s' "),sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sDocNumber);
							
							Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
							double dSumm, dPrise;
							while(!Query.IsEOF())
							{
								if((bStop)||(bPause))
								{
									sError = _T("Прервано");
									break;
								}
								
								sValue = "";
								for(int i = 0; i < 17; i++)
								{
									Query.GetFieldValue(i, dbValue);
									sDocNumber = GetValue(&dbValue);
									if(sDocNumber.Left(1)==_T("."))
										sDocNumber = _T("0")+sDocNumber;
							
									switch(i)
									{
										case 0:
											sValue = sValue +sReplaceLeftSynmbol(sDocNumber)+ _T(";");
											break;
										case 3:
											dSumm = _wtofmy(sDocNumber);
											sDocNumber.Format(_T("%.0f"),dSumm);
											sValue = sValue +sDocNumber+ _T(";");
											break;		

										case 4:
											dPrise = _wtofmy(sDocNumber);
											dPrise = dPrise *100;
											dPrise = (int)(dPrise+0.5);
											dPrise = dPrise/100;
											sDocNumber.Format(_T("%.2f"),dPrise);
											sValue = sValue +sDocNumber+ _T(";");
											break;

										case 6:
											dSumm = dPrise*dSumm;
											sDocNumber.Format(_T("%.2f"),dSumm);
											sValue = sValue +sDocNumber+ _T(";");
											break;	


										default:
											sValue = sValue +sReplaceLeftSynmbol(sDocNumber)+ _T(";");
											break;
									}
								}
							
								stFile.WriteString(sValue+_T("\n"));
								Query.MoveNext();	
							}
							Query.Close();
							sDocArray.RemoveAt(0,1);
						}
						stFile.Close();
					
						try
						{
							sName.Format(_T("%s%s_%s.txt"),sFileName,sOldData,sDivision);
							if(!DeleteFile(sName))
							{
								DWORD Err;
								Err = GetLastError();
								if(Err != 2)
								{
									CFile::Rename(sName,sName+_T("_damage"));
								}
							}
							if(sError.GetLength()<1)
								stFile.Rename(sFileName+_T("temp"),sName);
						}
						catch(...)
						{
							sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sName,GetLastErrorText());
						}
					}
					else
					{
						sError = GetLastErrorText();
					}
				}
			}
			catch(CDBException *exsept)
			{
				if(stFile.GetFileTitle()  != _T(""))
					stFile.Close();
				sError.Format(_T("%s %s"),exsept->m_strError, sSQL);
				WriteToLogFile(sError);
				exsept->Delete();

			}
		
		}
	}
	catch(...)
	{
		sError = GetLastErrorText();
	}
	
	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	
	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
	}
	
	return sError;
}

CString EXPORT_TYPE_7(int iPosition)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	sError = _T("");
	CString sPos;
	iPosition--;
	sPos.Format(_T("EXPORT_%d"),iPosition);
	CString sFileName;
	CStringArray sFileArray;
	CDBVariant dbValue;
	
	CString sFilter;
	sFilter = sReadFromIni(sPos,_T("PARAMETR_0"),_T(""));

	CString sLastDoc;
	sLastDoc = sReadFromIni(sPos,_T("PARAMETR_1"),_T(""));

	CString sDivision;
	sDivision = sReadFromIni(sPos,_T("PARAMETR_2"),_T(""));
	//sPos
	sFileName = sReadFromIni(sPos,_T("FILE_EXPORT"),_T(""));
	if(sFileName.GetLength()<3)
	{
		sError = _T("Неуказана директория выгрузки");
		return sError;
	}

	if(sFileName.Right(1)!=_T("\\"))
		sFileName = sFileName + _T("\\");

	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		return sError;
	}

	CString sConnect;
	CString sServer, sDatabase;
	sServer = sReadFromIni(sPos,_T("SERVER"),_T("svbyminssq3"));
	sDatabase = sReadFromIni(sPos,_T("DATABASE"),_T("SHATE-M-8"));

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	CDatabase* dBase;
	dBase = NULL;
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		int iAppRole;
		iAppRole = _wtoi(sReadFromIni(sPos, _T("USEAPPROLE"), _T("1")));
		if (iAppRole == 1){
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		dBase->SetQueryTimeout(0);
		sDatabase = sReadFromIni(sPos,_T("FIRM"),_T("SHATE-M-8"));
	}
	catch(CDBException *exsept)
	{
		sError.Format(_T("%s"),exsept->m_strError);
		exsept->Delete();
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;
		return sError;
	}
	
	CString sSQL;
	try
	{
		if(dBase!=NULL)
		{	
			CStdioFile stFile;
			CString sOldFile;
			sOldFile = "";
			int iFieldCount;
			try
			{
				sFileArray.RemoveAll();
				CStringArray sDocArray;
				CDBVariant dbVar;
						
				if(sFilter.GetLength()>0)
					sFilter = _T(" and ")+sFilter;
				
				
				
				if(sDivision.GetLength()>0)
					{
						sSQL.Format(_T("select sih.[No_],Left(CONVERT ( nchar , sih.[Posting Date], 112),8),'TN' as TN,'' as TNSer,sih.[Factura-Invoice No_],CONVERT ( nchar , sih.[Posting Date], 104), vn.[VAT Registration No_],sih.[Agreement No_], sih.[Currency Code], vn.[Name], vn.[Full Name], vn.[Ownership Code], vn.[VAT Registration No_], vn.[VAT Registration No_], vn.[KPP Code], vn.[OKPO Code], vn.[Address 2], vn.[Address], vn.[Phone No_] + ', факс' + vn.[Fax No_],va.[Customer No_], va.[VAT Bus_ Posting Group], va.[Currency Code], va.[External Agreement No_], CONVERT ( nchar , va.[Agreement Date], 104), va.[Legal Entity], CONVERT ( nchar , va.[Expire Date], 104), va.[No_], %s from [%s$Sales Invoice Header] as sih join [%s$Customer] as vn on vn.[No_] = sih.[Bill-to Customer No_] join [%s$Customer Agreement] as va on va.[Customer No_] = sih.[Bill-to Customer No_] and va.[No_] = sih.[Agreement No_] left join [%s$NoExport1C]on DocNumber = sih.[No_]  where (Export1C is Null or Export1C = 0)  %s and sih.[No_] > '%s' order by sih.[No_]"),sDivision ,sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sLastDoc);
						iFieldCount = 28;
					}
					else
					{
						sSQL.Format(_T("select sih.[No_],Left(CONVERT ( nchar , sih.[Posting Date], 112),8),'TN' as TN,'' as TNSer,sih.[Factura-Invoice No_],CONVERT ( nchar , sih.[Posting Date], 104), vn.[VAT Registration No_],sih.[Agreement No_], sih.[Currency Code], vn.[Name], vn.[Full Name], vn.[Ownership Code], vn.[VAT Registration No_], vn.[VAT Registration No_], vn.[KPP Code], vn.[OKPO Code], vn.[Address 2], vn.[Address], vn.[Phone No_] + ', факс' + vn.[Fax No_],va.[Customer No_], va.[VAT Bus_ Posting Group], va.[Currency Code], va.[External Agreement No_], CONVERT ( nchar , va.[Agreement Date], 104), va.[Legal Entity], CONVERT ( nchar , va.[Expire Date], 104), va.[No_] from [%s$Sales Invoice Header] as sih join [%s$Customer] as vn on vn.[No_] = sih.[Bill-to Customer No_] join [%s$Customer Agreement] as va on va.[Customer No_] = sih.[Bill-to Customer No_] and va.[No_] = sih.[Agreement No_] left join [%s$NoExport1C]on DocNumber = sih.[No_]  where (Export1C is Null or Export1C = 0)  %s and sih.[No_] > '%s' order by sih.[No_]"),sDatabase,sDatabase,sDatabase,sDatabase,sFilter,sLastDoc);
						iFieldCount = 27;
					}
				

				CRecordset Query(dBase);
				CRecordset Query1(dBase);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			
				sDocArray.RemoveAll();
				
				while(!Query.IsEOF())
				{
					if((bStop)||(bPause))
					{
						sError = _T("Прервано");
						break;
					}
					sSQL = "";
					
					for(int i = 0; i < iFieldCount; i++)
					{
						Query.GetFieldValue(i, dbValue);
						if(i==0)
						{
							if(sLastDoc < sReplaceLeftSynmbol(GetValue(&dbValue)))
								sLastDoc = sReplaceLeftSynmbol(GetValue(&dbValue));
							sSQL = sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
						}
						else
							sSQL = sSQL +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
					}
					sDocArray.Add(sSQL);
					Query.MoveNext();		
				}
				Query.Close();

				CStdioFile stFile;
				CString sValue;
				CString sDocNumber,sDoc;

				sFileArray.RemoveAll();
				int iPos;
				CString sDate;
				while(sDocArray.GetCount()>0)
				{
					
					sValue = sDocArray.ElementAt(0);
					iPos = sValue.Find(_T(";"),0);
					if(iPos < 2)
					{
						sDocArray.RemoveAt(0,1);
						continue;
					}
					sDocNumber = sValue.Left(iPos);
					sDoc = sDocNumber;
					sValue = sValue.Right(sValue.GetLength() - iPos -1);

					iPos = sValue.Find(_T(";"),0);
					if(iPos < 2)
					{
						sDocArray.RemoveAt(0,1);
						continue;
					}
					sDate = sValue.Left(iPos);
					sValue = sValue.Right(sValue.GetLength() - iPos -1);
					
					if((bStop)||(bPause))
						{
							sError = _T("Прервано");
							break;
						}

					if(stFile.Open(sFileName+_T("temp"),CFile::modeCreate|CFile::modeWrite))
					{
						stFile.WriteString(sValue+_T("\n"));
						sSQL.Format(_T("select (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode,pil.[Unit of Measure],it.[Description 2],-cdr.[Quantity],pil.[Optimization Price],pil.[Ext_ VAT %%], pil.[Optimization Price]*(-cdr.[Quantity]),(select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = pil.[Unit of Measure Code])*0.9, (select top 1 [Weight] from [%s$Item Unit of Measure] as ium where ium.[Item No_] = it.[No_] and ium.[Code] = pil.[Unit of Measure Code]) as wth,	cdr.[CD No_],cdh.[Country_Region of Origin Code],eep.NAME,it.[Description 2],it.[Description 2],it.[No_ 2],[tm].[Trade Mark Name],it.[No_] from [%s$Sales Invoice line] as pil left join [%s$Item] as it on pil.[No_] = it.[No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] join [%s$Custom Declaration Relation] as cdr on cdr.[Document No_] = pil.[Document No_] and cdr.[Line No_] = pil.[Line No_] join [%s$Custom Declaration Line] as cdh on cdh.[CD No_] = cdr.[CD No_] and cdh.[CD Line No_] = cdr.[CD Line No_] join [Country_Region] as eep on eep.[Code] = cdh.[Country_Region of Origin Code] where pil.[Document No_] = '%s' and pil.[Quantity] > 0"),sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDatabase,sDocNumber);
						Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
						while(!Query.IsEOF())
						{
							if((bStop)||(bPause))
							{
								sError = _T("Прервано");
								break;
							}
							sValue = "";
							for(int i = 0; i < 17; i++)
							{
								Query.GetFieldValue(i, dbValue);
								if((i==7)||(i==8))
								{
									sDocNumber = GetValue(&dbValue);
									if(sDocNumber.Left(1)==_T("."))
										sDocNumber = _T("0")+sDocNumber;
									sValue = sValue+sDocNumber+ _T(";");
								}
								else
									sValue = sValue +sReplaceLeftSynmbol(GetValue(&dbValue))+ _T(";");
							}
							stFile.WriteString(sValue+_T("\n"));
						Query.MoveNext();		
						}
						Query.Close();
						stFile.Close();
						
						try
						{
							
							if(!DeleteFile(sFileName+sDate+_T("_")+sDoc+_T(".txt")))
							{
								DWORD Err;
								Err = GetLastError();
								if(Err != 2)
								{
									CFile::Rename(sFileName+sDate+_T("_")+sDoc+_T(".txt"),sFileName+sDate+_T("_")+sDoc+_T(".txt")+_T("_damage"));
								}
							}
							if(sError.GetLength()<1)
							{
								stFile.Rename(sFileName+_T("temp"),sFileName+sDate+_T("_")+sDoc+_T(".txt"));
							}
							else
								break;
						}
						catch(...)
						{
							sError.Format(_T("Ошибка переименование %s в %s %s"),sFileName+_T("temp"),sFileName+sDate+_T("_")+sDoc+_T(".txt"),GetLastErrorText());
							break;
						}
						
						sFileArray.Add(sFileName+sDate+_T("_")+sDocNumber+_T(".txt"));
					}
					

					sDocArray.RemoveAt(0,1);
				}
			}
			catch(CDBException *exsept)
			{
				//if(stFile.)
				if(stFile.GetFileTitle()  != _T(""))
					stFile.Close();
				sError.Format(_T("%s %s"),exsept->m_strError, sSQL);
				exsept->Delete();
			}
		}
	}
	catch(...)
	{
		sError = GetLastErrorText();
	}


	if(dBase!=NULL)
	{
		if(dBase->IsOpen())
			{
				dBase->Close();
			}
		delete(dBase);
	}
	if((bStop)||(bPause))
	{
		sError = _T("Прервано");
		while(sFileArray.GetCount())
		{
			if(!DeleteFile(sFileArray.ElementAt(0)))
			{
				DWORD Err;
				Err = GetLastError();
				if(Err != 2)
				{
					CFile::Rename(sFileArray.ElementAt(0),sFileArray.ElementAt(0)+_T("_damage"));
				}
			}
			sFileArray.RemoveAt(0,1);
		}
	}
	else
	{
		if(sError.GetLength()<1)
		{
			if(sLastDoc.GetLength()>0)
			{
			sWriteToIni(sPos,_T("PARAMETR_1"),sLastDoc);
			}
		}
	}
	return sError;
}

void Run()
{
	WriteToLogFile(_T("Начало работы"));
	int iIterVal; 
	iIterVal = 0;
	
	int COUNT_EXPORTS;
	int iPosition;
	CString sReadVal;
	COleDateTime datStart;
	COleDateTimeSpan ts;
	int iMin;
	int iHour;
	int iDays;
	int iMounth;
	int iYear;

	int iStartTime;

	while(!bStop)
	{
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
		COUNT_EXPORTS = _wtoi(sReadFromIni(_T("BASE"),_T("EXPORT_COUNT"),_T("0")));
		
		if(COUNT_EXPORTS < 1)
		{
			continue;
		}


		iPosition=0;
		
		CString sOldDate;

		while(iPosition < COUNT_EXPORTS)
		{
			if(bStop)
			{
				break;
			}
			
			if (bPause)
			{
				break;
			}

			sReadVal.Format(_T("EXPORT_%d"),iPosition);
			
			iPosition++;
			datStart = COleDateTime::GetCurrentTime();
			
			sOldDate = sReadFromIni(sReadVal,_T("INTERVAL"), _T("0"));		
			sOldDate = ReplaceLeftSymbols(sOldDate);
			iStartTime = _wtoi(sOldDate);
			
			
			
			
			if(iStartTime < 1)
			{
				COleDateTime oDate;
				sOldDate = sReadFromIni(sReadVal,_T("SCHEDULE"), _T(""));	
				sOldDate = ReplaceLeftSymbols(sOldDate);

				while(sOldDate.GetLength()<12)
				{
					sOldDate = sOldDate+_T("0");
				}
				sOldDate = sOldDate.Left(12);

				iMin = -1;
				iHour = -1;
				iDays = -1;
				iMounth = -1;
				iYear = -1;

				iMin = _wtoi(sOldDate.Right(2));
				sOldDate = sOldDate.Left(10);

				iHour = _wtoi(sOldDate.Right(2));
				sOldDate = sOldDate.Left(8);

				iDays = _wtoi(sOldDate.Right(2));
				sOldDate = sOldDate.Left(6);

				iMounth = _wtoi(sOldDate.Right(2));
				sOldDate = sOldDate.Left(4);

				iYear = _wtoi(sOldDate.Right(2));
				//201301010101
				sOldDate = sReadFromIni(sReadVal,_T("DATE"), _T(""));
				if(sOldDate.GetLength()<12)
				{
					sOldDate = _T("200001010101");
				}

				if(iYear > 0)
				{
					sOldDate = sOldDate.Left(4);
					iYear = iYear+_wtoi(sOldDate);
					oDate.SetDateTime(iYear,iMounth,iDays,iHour,iMin,0);
				}
				else
				{
					sOldDate = sOldDate.Left(4);
					iYear = _wtoi(sOldDate);
				
					sOldDate = sReadFromIni(sReadVal,_T("DATE"), _T(""));
					if(iMounth > 0)
					{
						sOldDate = sOldDate.Left(6);
						oDate.SetDateTime(iYear,_wtoi(sOldDate.Right(2)),iDays,iHour,iMin,0);
						iMounth = iMounth+_wtoi(sOldDate.Right(2));	
						iMounth = iMounth%12;
						
						if(iMounth == 0)
							iMounth = 12;
						ts.SetDateTimeSpan(1,0,0,0);
						while(oDate.GetMonth() != iMounth)
						{
							oDate = oDate + ts;
						}
					}
					else
					{
						sOldDate = sOldDate.Left(6);
						iMounth = _wtoi(sOldDate.Right(2));
						sOldDate = sReadFromIni(sReadVal,_T("DATE"), _T(""));
						if(iDays > 0)
						{
							sOldDate = sOldDate.Left(8);
							oDate.SetDateTime(iYear,iMounth,_wtoi(sOldDate.Right(2)),iHour,iMin,0);
							ts.SetDateTimeSpan(iDays,0,0,0);
							oDate = oDate + ts;
						}
						else
						{
							sOldDate = sOldDate.Left(8);
							iDays = _wtoi(sOldDate.Right(2));
							sOldDate = sReadFromIni(sReadVal,_T("DATE"), _T(""));
							if(iHour > 0)
							{
								sOldDate = sOldDate.Left(10);
								
								oDate.SetDateTime(iYear,iMounth,iDays,_wtoi(sOldDate.Right(2)),iMin,0);
								ts.SetDateTimeSpan(0,iHour,0,0);
								oDate = oDate + ts;
								
							}
							else
							{
								sOldDate = sOldDate.Left(10);
								iHour = _wtoi(sOldDate.Right(2));
								sOldDate = sReadFromIni(sReadVal,_T("DATE"), _T(""));
								if(iMin > 0)
								{
									sOldDate = sOldDate.Left(12);
									oDate.SetDateTime(iYear,iMounth,iDays,iHour,_wtoi(sOldDate.Right(2)),0);
									ts.SetDateTimeSpan(0,0,iMin,0);
									oDate = oDate + ts;
								}
								else
								{
									continue;
								}
							}
						}
					}
				}

				
				if((iYear==0)&&(iMounth == 0)&&(iDays==0)&&(iHour==0)&&(iMin==0))
					continue;

				
     			
				sOldDate = oDate.Format(_T("%Y%m%d%H%M%S"));
			}	
			else
			{
				iMin = iStartTime % 60;
				iStartTime = (iStartTime - iMin)/ 60;
				iHour = iStartTime % 24;
				iStartTime = (iStartTime - iHour)/ 24;
				iDays = iStartTime;
				ts.SetDateTimeSpan(iDays,iHour,iMin,0);
				datStart = datStart - ts;
				
				sOldDate = sReadFromIni(sReadVal,_T("DATE"), _T(""));
				if(sOldDate.GetLength()<1)
				{
					sOldDate = _T("000000000");
				}
			}

			

			
			if(sOldDate > datStart.Format(_T("%Y%m%d%H%M%S")))
			{
				continue;
			}
		

			iStartTime = _wtoi(sReadFromIni(sReadVal,_T("TYPE"), _T("0")));
			
			WriteToLogFile(sReadVal);
			CString sError;
			switch(iStartTime)
			{
				case 1:
					sOldDate = EXPORT_TYPE_1(iPosition);
					if(sOldDate.GetLength()>0)
					{
						WriteToLogFile(sOldDate);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						datStart = COleDateTime::GetCurrentTime();
						sWriteToIni(sReadVal,_T("DATE"),datStart.Format(_T("%Y%m%d%H%M%S")));
					}
					break;

				case 2:
					
					sError = EXPORT_TYPE_2(iPosition,sOldDate);
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;

				case 13:
					
					sError = EXPORT_TYPE_13(iPosition,sOldDate);
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;

				case 3:
					
					sError = EXPORT_TYPE_3(iPosition);
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;

				case 4:
					
					sError = EXPORT_TYPE_4(iPosition);
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;

				case 5:
					
					sError = EXPORT_TYPE_5(iPosition);
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;

				case 6:
					
					sError = sReadFromIni(sReadVal,_T("DATE"), _T(""));
					sError = EXPORT_TYPE_6(iPosition,sError.Left(8), sOldDate.Left(8));
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;

				case 7:
					
					sError = EXPORT_TYPE_7(iPosition);
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;
				
				case 8:
					
					sError = sReadFromIni(sReadVal,_T("DATE"), _T(""));
					sError = EXPORT_TYPE_8(iPosition,sError.Left(8), sOldDate.Left(8));
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;

				case 9:
					
					sError = sReadFromIni(sReadVal,_T("DATE"), _T(""));
					sError = EXPORT_TYPE_9(iPosition,sError.Left(8), sOldDate.Left(8));
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;
				//EXPORT_TYPE_10

				case 10:
					
					sError = sReadFromIni(sReadVal,_T("DATE"), _T(""));
					sError = EXPORT_TYPE_10(iPosition,sError.Left(8), sOldDate.Left(8));
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;

			case 11:
					
					sError = EXPORT_TYPE_11(iPosition);
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;

			case 12:
					sError = EXPORT_TYPE_12(iPosition, sOldDate);
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;

			case 14:
					sError = EXPORT_TYPE_14(iPosition, sOldDate);
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;

			case 15:
					sError = EXPORT_TYPE_15(iPosition, sOldDate);
					if(sError.GetLength()>0)
					{
						WriteToLogFile(sError);
					}
					else
					{
						WriteToLogFile(_T("Выполненно"));
						sWriteToIni(sReadVal,_T("DATE"),sOldDate);
					}
					break;
			}
		}

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
	sStatus.dwCurrentState = SERVICE_STOPPED;
	SetServiceStatus(ssHandle, &sStatus);
}




int _tmain(int argc, TCHAR* argv[], TCHAR* envp[])
{
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
	
	wchar_t cBuffer[MAX_PATH];
    ::GetModuleFileName(NULL, cBuffer, MAX_PATH);
    sPath = cBuffer;
    sPath = sPath.Left(sPath.ReverseFind('\\'));
	if (sPath.Right(1)!="\\") sPath += "\\";

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
	#ifdef _DEBUG
		Run();
		return nRetCode;
	#endif

	StartServiceCtrlDispatcher(steTable);
	return nRetCode;
}

CString GetLastErrorText()
{	
	DWORD Err = GetLastError();
	return GetErrorText(&Err);
}

CString GetErrorText(DWORD *pErr)
{
	void* cstr;
	FormatMessageA(
	FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
		NULL,
		*pErr,
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
		(LPSTR) &cstr,
		0,
		NULL
		);
	CString res((char*)cstr);
	return res;
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
CStringW Convert(CStringA sIN)
{
	CString utf16;
	utf16 ="";
	int len = MultiByteToWideChar(1251, 0, sIN, -1, NULL, 0);
	if (len>1)
	{
		wchar_t *ptr = utf16.GetBuffer(len-1);
		if (ptr) MultiByteToWideChar(1251, 0, sIN, -1, ptr, len);
		utf16.ReleaseBuffer();
	}
	return utf16;
}

CStringW GetValue(CDBVariant* var)
{
	CString sName;

	if(var->m_dwType==DBVT_UCHAR)
	{
		sName.Format(_T("%d"),var->m_chVal);
	}

	if(var->m_dwType==6)
	{
		sName.Format(_T("%.0f"),var->m_dblVal);
	}

	if(var->m_dwType==DBVT_LONG)
	{
		sName.Format(_T("%d"),var->m_lVal);
	}
	if(var->m_dwType==DBVT_SHORT)
	{
		sName.Format(_T("%d"),var->m_iVal);
	}
	if(var->m_dwType==DBVT_ASTRING)
	{
		CStringA stra;
		stra.Format("%s",*var->m_pstringA);
		sName = Convert(stra);
	}
	if(var->m_dwType==DBVT_WSTRING)
	{
	
		sName.Format(_T("%s"),*var->m_pstringW);
		if(sName.Left(1)==_T("."))
		{
			sName = _T("0")+sName;
			/*try
			{
				WriteToLogFile(sName);
				double fl;
				fl = _wtofmy(sName);
				sName.Replace(_T(","),_T("."));
				if(fl < _wtofmy(sName))
					fl = _wtofmy(sName);
				sName.Format(_T("%.3f"),fl);
				WriteToLogFile(sName);

			}
			catch(...)
			{
				sName.Format(_T("%s"),*var->m_pstringW);
			}*/
		}
	}
	if(var->m_dwType==DBVT_STRING)
	{
		sName.Format(_T("%s"),*var->m_pstring);
	}

	while(sName.Right(1)==_T(" "))
	{
		sName = sName.Left(sName.GetLength()-1);
	}
	return sName;
}