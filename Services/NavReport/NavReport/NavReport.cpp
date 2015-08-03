// NavReport.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "NavReport.h"
#include "winsvc.h"
#include "locale.h"
#include "afxdb.h"
#include "SMTPClass.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

#define MSG_LEN 256
#define KEY_LEN MSG_LEN
#define ServiceName TEXT("Reports_Nav")
#define DisplayName TEXT("Reports Nav for Pavlova")
#define EventSource TEXT("Reports_Nav")
#define SERVICE_PARENT_KEY TEXT("System\\CurrentControlSet\\Services")
#define LOG_PARENT_KEY     TEXT("System\\CurrentControlSet\\Services\\Eventlog\\Application")
#define PARAMETERS_CHANGED           129
#define MSG_PARAMETERS_CHANGED           0x00000002L
//#define COUNT_EXPORTS 6


SERVICE_STATUS_HANDLE ssHandle; 
SERVICE_STATUS sStatus;
HANDLE hEndEvent;
LONG   fPause = 0;
DWORD  lWait;
HANDLE hSource = NULL;
HANDLE hSendThread;
HANDLE eSendPending;

BOOL bStop;

CString sPath;

struct stUsers
{
	CString sUser_ID;
	CString sUser_Name;
	CString sUser_Email;
};

// The one and only application object

CWinApp theApp;

using namespace std;

void DisplayHelp()
{
	AfxMessageBox(_T("Отчеты НАВ по операторам"));
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

void WriteToLogFile(CString sWrite)
{
	setlocale(LC_ALL,"Russian");
	
	CTime time;
	CStdioFile oFile;
	time = time.GetCurrentTime();
	if(!oFile.Open(sPath+ServiceName+_T(".log"),CFile::modeReadWrite))
		if(!oFile.Open(sPath+ServiceName+_T(".log"),CFile::modeCreate|CFile::modeWrite))
			return;
		
		oFile.SeekToEnd();
		oFile.WriteString(time.Format("%y%m%d %H:%M")+_T("\t")+sWrite+_T("\n"));
		oFile.Close();
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
	InterlockedExchange(&fPause, 1); 
}

void Continue()
{
	InterlockedExchange(&fPause, 0); 
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

bool GetUserList(CArray<stUsers*, stUsers*> *mUsers, CString sStartDate, CString sEndDate, CString sUserType, int iExport)
{

	int i;
	stUsers *elUser;
	for(i=0;i<mUsers->GetCount();i++)
	{
		elUser = mUsers->ElementAt(i);
		delete(elUser);
	}
	mUsers->RemoveAll();
	
	CDatabase * dBase;
	CString sSQL;
	CString sServer, sDatabase;
	sServer = sReadFromIni(_T("DB"),_T("SERVER"),_T("svbyminssq3"));
	sWriteToIni(_T("DB"),_T("SERVER"),sServer);
	sDatabase = sReadFromIni(_T("DB"),_T("DATABASE"),_T("SHATE-M-8"));
	sWriteToIni(_T("DB"),_T("DATABASE"),sDatabase);

	sSQL.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sSQL,CDatabase::noOdbcDialog);
		sSQL.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
		dBase->ExecuteSQL(sSQL);
		sDatabase = sReadFromIni(_T("DB"),_T("FIRM"),sDatabase);
		dBase->SetQueryTimeout(0);
	}
	catch(CDBException *exsept)
	{
		WriteToLogFile(exsept->m_strError+_T("\n")+sSQL);
		exsept->Delete();
		if(dBase->IsOpen())
		{
			dBase->Close();
		}
		delete(dBase);
		dBase = NULL;
		return FALSE;
	}
	try
	{
		CRecordset Query(dBase);
		int iField;
		CDBVariant dbValue;

		if(iExport == 1)
		{
			sSQL.Format(_T("SELECT DISTINCT sm.[Driver No_] AS [UserName], sm.[Driver No_] AS [NAME], sae.[Registration Address] AS [E-Mail] FROM [%s$Trip] sm JOIN [%s$Shipping Agent Employee]  AS sae ON sm.[Driver No_] = sae.code WHERE LEFT(CONVERT(NCHAR, [Create Date], 112), 8) >= '%s' AND LEFT(CONVERT(NCHAR, [Create Date], 112), 8) <= '%s' AND [Driver No_] <> '' ORDER BY sae.[Registration Address], [Driver No_]"), sDatabase,sDatabase,sStartDate,sEndDate);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				i=0;
				while(i<mUsers->GetCount())
				{
					elUser = mUsers->ElementAt(i);
					if(elUser->sUser_ID == GetValue(&dbValue))
						break;
					else
						i++;
				}
				if(i<mUsers->GetCount())
				{
					Query.MoveNext();
					continue;
				}
				elUser = new (stUsers);
				elUser->sUser_ID = GetValue(&dbValue);		

				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Name = GetValue(&dbValue);

				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Email = GetValue(&dbValue);
				mUsers->Add(elUser);
				Query.MoveNext();
			}
			Query.Close();
		}
		
		if(iExport == 0)
		{
			sUserType.Replace(_T(";"),_T("' or [Job Title] = '"));
			sUserType = _T(" and ([Job Title] = '")+sUserType+_T("')");
			sSQL.Format(_T("select distinct [Assigned User ID] as [UserName],[NAME],Sal.[E-Mail],[Job Title] from [%s$Sales Invoice Line] join [%s$User setup] as US on [Assigned User ID] = [User ID] join [%s$Salesperson_Purchaser] as Sal on [Salespers__Purch_ Code] = Sal.[code] %s where Left(CONVERT ( nchar , [Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Posting Date], 112),8) <= '%s'order by [Assigned User ID]"), sDatabase,sDatabase,sDatabase,sUserType,sStartDate,sEndDate);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
		
			while(!Query.IsEOF())
			{
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				i=0;
				while(i<mUsers->GetCount())
				{
					elUser = mUsers->ElementAt(i);
					if(elUser->sUser_ID == GetValue(&dbValue))
						break;
						else
						i++;
				}
			
				if(i<mUsers->GetCount())
				{
					Query.MoveNext();
					continue;
				}
			
				elUser = new (stUsers);
				elUser->sUser_ID = GetValue(&dbValue);

				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Name = GetValue(&dbValue);
	
				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Email = GetValue(&dbValue);
				mUsers->Add(elUser);
				Query.MoveNext();
			}
			Query.Close();

			sSQL.Format(_T("select distinct [Created By User] as [UserName],[NAME],Sal.[E-Mail],[Job Title]  from [%s$Trip] join [%s$User setup] as US on [Created By User] = [User ID] join [%s$Salesperson_Purchaser] as Sal on [Salespers__Purch_ Code] = Sal.[code] %s where [Created By User] <> '' and Left(CONVERT ( nchar , [Create Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Create Date], 112),8) <= '%s' order by [UserName]"), sDatabase,sDatabase,sDatabase,sUserType,sStartDate,sEndDate);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				i=0;
				while(i<mUsers->GetCount())
				{
					elUser = mUsers->ElementAt(i);
					if(elUser->sUser_ID == GetValue(&dbValue))
						break;
					else
					i++;
				}

				if(i<mUsers->GetCount())
				{
					Query.MoveNext();
					continue;
				}
				
				elUser = new (stUsers);
				elUser->sUser_ID = GetValue(&dbValue);

				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Name = GetValue(&dbValue);

				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Email = GetValue(&dbValue);
				mUsers->Add(elUser);
				Query.MoveNext();
			}
			Query.Close();

			sSQL.Format(_T("select distinct [Created by user] as [UserName],[NAME],Sal.[E-Mail],[Job Title] from [%s$Delivery Request] join [%s$User setup] as US on [Created by user] = [User ID] join [%s$Salesperson_Purchaser] as Sal on [Salespers__Purch_ Code] = Sal.[code] %s where [Created by user] <> '' and Left(CONVERT ( nchar , [Create Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Create Date], 112),8) <= '%s' order by [Created by user]"), sDatabase,sDatabase,sDatabase,sUserType,sStartDate,sEndDate);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				i=0;
				while(i<mUsers->GetCount())
				{
					elUser = mUsers->ElementAt(i);
					if(elUser->sUser_ID == GetValue(&dbValue))
						break;
					else
						i++;
				}
				if(i<mUsers->GetCount())
				{
					Query.MoveNext();
					continue;
				}
				elUser = new (stUsers);
				elUser->sUser_ID = GetValue(&dbValue);
	
				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Name = GetValue(&dbValue);

				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Email = GetValue(&dbValue);
				mUsers->Add(elUser);
				Query.MoveNext();
			}
			Query.Close();

			

			sSQL.Format(_T("select distinct [Create User ID] as [UserName], [NAME],Sal.[E-Mail],[Job Title] from [%s$Posted Whse_Shipment Header SW] join [%s$User setup] as US on [Create User ID] = [User ID] join [%s$Salesperson_Purchaser] as Sal on [Salespers__Purch_ Code] = Sal.[code] %s where [Create User ID] <> '' and Left(CONVERT ( nchar , [Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Posting Date], 112),8) <= '%s' order by [Create User ID]"), sDatabase,sDatabase,sDatabase,sUserType,sStartDate,sEndDate);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				i=0;
				while(i<mUsers->GetCount())
				{
					elUser = mUsers->ElementAt(i);
					if(elUser->sUser_ID == GetValue(&dbValue))
						break;
					else
						i++;
				}
				if(i<mUsers->GetCount())
				{
					Query.MoveNext();
					continue;
				}
				
				elUser = new (stUsers);
				elUser->sUser_ID = GetValue(&dbValue);

				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Name = GetValue(&dbValue);

				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Email = GetValue(&dbValue);
				mUsers->Add(elUser);
				Query.MoveNext();
			}
			Query.Close();


			/*
			Заказы на покупку (считаются по учтенному счету покупки - Purch. Inv. Line – поле Created By User) 		
			*/
			sSQL.Format(_T("select distinct [Created By User] as [UserName], [NAME],Sal.[E-Mail],[Job Title] from [%s$Purch_ Inv_ Line] join [%s$User setup] as US on [Created By User] = [User ID] join [%s$Salesperson_Purchaser] as Sal on [Salespers__Purch_ Code] = Sal.[code] %s where [Created By User] <> '' and Left(CONVERT ( nchar , [Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Posting Date], 112),8) <= '%s' order by [Created By User]"), sDatabase,sDatabase,sDatabase,sUserType,sStartDate,sEndDate);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				i=0;
				while(i<mUsers->GetCount())
				{
					elUser = mUsers->ElementAt(i);
					if(elUser->sUser_ID == GetValue(&dbValue))
						break;
					else
						i++;
				}
				if(i<mUsers->GetCount())
				{
					Query.MoveNext();
					continue;
				}
				
				elUser = new (stUsers);
				elUser->sUser_ID = GetValue(&dbValue);

				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Name = GetValue(&dbValue);

				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Email = GetValue(&dbValue);
				mUsers->Add(elUser);
				Query.MoveNext();
			}
			Query.Close();

			/*
			Заказы внутреннего перемещения(считаются по учтенной расходной накладной Transfer Shipment Line – поле Created By User)		
			*/
			sSQL.Format(_T("select distinct [Created By User] as [UserName], [NAME],Sal.[E-Mail],[Job Title] from [%s$Transfer Shipment Header] as tsh join [%s$Transfer Shipment Line] as tsl on tsh.[No_] = tsl.[Document No_]	join [%s$User setup] as US on [Created By User] = [User ID] join [%s$Salesperson_Purchaser] as Sal on [Salespers__Purch_ Code] = Sal.[code] %s where [Created By User] <> '' and Left(CONVERT ( nchar , [Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Posting Date], 112),8) <= '%s' order by [Created By User]"), sDatabase,sDatabase,sDatabase,sDatabase,sUserType,sStartDate,sEndDate);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				i=0;
				while(i<mUsers->GetCount())
				{
					elUser = mUsers->ElementAt(i);
					if(elUser->sUser_ID == GetValue(&dbValue))
						break;
					else
						i++;
				}
				if(i<mUsers->GetCount())
				{
					Query.MoveNext();
					continue;
				}
				
				elUser = new (stUsers);
				elUser->sUser_ID = GetValue(&dbValue);

				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Name = GetValue(&dbValue);

				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Email = GetValue(&dbValue);
				mUsers->Add(elUser);
				Query.MoveNext();
			}
			Query.Close();

			/*
			Самовывозы (оформление складских отгрузок, приемок без доставки) по перемещениям
			*/
			sSQL.Format(_T("select distinct [Created By User] as [UserName], [NAME],Sal.[E-Mail],[Job Title] from [%s$Transfer Shipment Header] as tsh join [%s$Transfer Shipment Line] as tsl on tsh.[No_] = tsl.[Document No_]	join [%s$User setup] as US on [Created By User] = [User ID] join [%s$Salesperson_Purchaser] as Sal on [Salespers__Purch_ Code] = Sal.[code] %s where [Created By User] <> '' and Left(CONVERT ( nchar , [Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Posting Date], 112),8) <= '%s' and tsh.[Shipment Method Code] = 'САМОВЫВОЗ' order by [Created By User]"), sDatabase,sDatabase,sDatabase,sDatabase,sUserType,sStartDate,sEndDate);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				i=0;
				while(i<mUsers->GetCount())
				{
					elUser = mUsers->ElementAt(i);
					if(elUser->sUser_ID == GetValue(&dbValue))
						break;
					else
						i++;
				}
				if(i<mUsers->GetCount())
				{
					Query.MoveNext();
					continue;
				}
				
				elUser = new (stUsers);
				elUser->sUser_ID = GetValue(&dbValue);

				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Name = GetValue(&dbValue);

				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Email = GetValue(&dbValue);
				mUsers->Add(elUser);
				Query.MoveNext();
			}
			Query.Close();
			

			/*
			Самовывозы (оформление складских отгрузок, приемок без доставки) по покупкам
			*/
			sSQL.Format(_T("select distinct prl.[Created By User] as [UserName], [NAME],Sal.[E-Mail],[Job Title] from [%s$Purch_ Rcpt_ Header] as prh join [%s$Purch_ Rcpt_ Line] as prl on prh.[No_] = prl.[Document No_]	join [%s$User setup] as US on [Created By User] = US.[User ID] join [%s$Salesperson_Purchaser] as Sal on [Salespers__Purch_ Code] = Sal.[code]  %s where [Created By User] <> '' and Left(CONVERT ( nchar , prh.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , prh.[Posting Date], 112),8) <= '%s' order by [Created By User]"), sDatabase,sDatabase,sDatabase,sDatabase,sUserType,sStartDate,sEndDate);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				i=0;
				while(i<mUsers->GetCount())
				{
					elUser = mUsers->ElementAt(i);
					if(elUser->sUser_ID == GetValue(&dbValue))
						break;
					else
						i++;
				}
				if(i<mUsers->GetCount())
				{
					Query.MoveNext();
					continue;
				}
				
				elUser = new (stUsers);
				elUser->sUser_ID = GetValue(&dbValue);

				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Name = GetValue(&dbValue);

				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Email = GetValue(&dbValue);
				mUsers->Add(elUser);
				Query.MoveNext();
			}
			Query.Close();
			

			/*
			Самовывозы (оформление складских отгрузок, приемок без доставки) по продажам
			*/
			sSQL.Format(_T("select distinct prl.[Created By User] as [UserName], [NAME],Sal.[E-Mail],[Job Title] from [%s$Purch_ Rcpt_ Header] as prh join [%s$Purch_ Rcpt_ Line] as prl on prh.[No_] = prl.[Document No_]	join [%s$User setup] as US on [Created By User] = US.[User ID] join [%s$Salesperson_Purchaser] as Sal on [Salespers__Purch_ Code] = Sal.[code]  %s where [Created By User] <> '' and Left(CONVERT ( nchar , prh.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , prh.[Posting Date], 112),8) <= '%s' order by [Created By User]"), sDatabase,sDatabase,sDatabase,sDatabase,sUserType,sStartDate,sEndDate);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				i=0;
				while(i<mUsers->GetCount())
				{
					elUser = mUsers->ElementAt(i);
					if(elUser->sUser_ID == GetValue(&dbValue))
						break;
					else
						i++;
				}
				if(i<mUsers->GetCount())
				{
					Query.MoveNext();
					continue;
				}
				
				elUser = new (stUsers);
				elUser->sUser_ID = GetValue(&dbValue);

				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Name = GetValue(&dbValue);

				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Email = GetValue(&dbValue);
				mUsers->Add(elUser);
				Query.MoveNext();
			}
			Query.Close();











			//Posted Whse_Shipment Header SW
			sSQL.Format(_T("select distinct [Created By User] as [UserName], [NAME],Sal.[E-Mail],[Job Title] from [%s$Purch_ Rcpt_ Line] as tsl join [%s$User setup] as US on [Created By User] = [User ID] join [%s$Salesperson_Purchaser] as Sal on [Salespers__Purch_ Code] = Sal.[code] %s where [Created By User] <> '' and Left(CONVERT ( nchar , [Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Posting Date], 112),8) <= '%s' order by [Created By User]"), sDatabase,sDatabase,sDatabase,sUserType,sStartDate,sEndDate);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				i=0;
				while(i<mUsers->GetCount())
				{
					elUser = mUsers->ElementAt(i);
					if(elUser->sUser_ID == GetValue(&dbValue))
						break;
					else
						i++;
				}
				if(i<mUsers->GetCount())
				{
					Query.MoveNext();
					continue;
				}
				
				elUser = new (stUsers);
				elUser->sUser_ID = GetValue(&dbValue);

				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Name = GetValue(&dbValue);

				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Email = GetValue(&dbValue);
				mUsers->Add(elUser);
				Query.MoveNext();
			}
			Query.Close();


		}
			
		if(iExport == 2)
		{
			//Sal.[code]
			sUserType.Replace(_T(";"),_T("' or Sal.[code] = '"));
			sUserType = _T(" and (Sal.[code] = '")+sUserType+_T("')");
			sSQL.Format(_T("select distinct [Assigned User ID] as [UserName],[NAME],Sal.[E-Mail],[Job Title] from [%s$Sales Invoice Line] join [%s$User setup] as US on [Assigned User ID] = [User ID] join [%s$Salesperson_Purchaser] as Sal on [Salespers__Purch_ Code] = Sal.[code] %s where Left(CONVERT ( nchar , [Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Posting Date], 112),8) <= '%s'order by [Assigned User ID]"), sDatabase,sDatabase,sDatabase,sUserType,sStartDate,sEndDate);
			
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				i=0;
				while(i<mUsers->GetCount())
				{
					elUser = mUsers->ElementAt(i);
					if(elUser->sUser_ID == GetValue(&dbValue))
						break;
						else
						i++;
				}
			
				if(i<mUsers->GetCount())
				{
					Query.MoveNext();
					continue;
				}
			
				elUser = new (stUsers);
				elUser->sUser_ID = GetValue(&dbValue);

				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Name = GetValue(&dbValue);
	
				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				elUser->sUser_Email = GetValue(&dbValue);
				mUsers->Add(elUser);
				Query.MoveNext();
			}
			Query.Close();
		}
	
	}
	catch(CDBException *exsept)
	{
		WriteToLogFile(exsept->m_strError+_T("\n")+sSQL);
		exsept->Delete();
		if(dBase->IsOpen())
		{
			dBase->Close();
		}
		delete(dBase);
		dBase = NULL;
		return FALSE;
	}
	if(dBase->IsOpen())
		{
			dBase->Close();
		}
		delete(dBase);
	return TRUE;
}

bool GetUserData(stUsers * ElUser, CString sStartDate, CString sEndDate, CStringArray * sArray, int iExport)
{
	CDatabase * dBase;
	CString sSQL;
	CString sServer, sDatabase;
	sServer = sReadFromIni(_T("DB"),_T("SERVER"),_T("svbyminssq3"));
	sWriteToIni(_T("DB"),_T("SERVER"),sServer);
	sDatabase = sReadFromIni(_T("DB"),_T("DATABASE"),_T("SHATE-M-8"));
	sWriteToIni(_T("DB"),_T("DATABASE"),sDatabase);

	sSQL.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	try
	{
		dBase = new(CDatabase);
		dBase->OpenEx(sSQL,CDatabase::noOdbcDialog);
		sSQL.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
		dBase->ExecuteSQL(sSQL);
		sDatabase = sReadFromIni(_T("DB"),_T("FIRM"),sDatabase);
		dBase->SetQueryTimeout(0);
	}
	catch(CDBException *exsept)
	{
		WriteToLogFile(exsept->m_strError+_T("\n")+sSQL);
		exsept->Delete();
		if(dBase->IsOpen())
		{
			dBase->Close();
		}
		delete(dBase);
		dBase = NULL;
		return FALSE;
	}
	try
	{
		sArray->RemoveAll();
		CRecordset Query(dBase);
		int iField;
			CDBVariant dbValue;
		if((iExport == 0)||(iExport == 2))
		{
			sSQL.Format(_T("select count(*) as con from [%s$Sales Invoice Line] where Left(CONVERT ( nchar , [Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Posting Date], 112),8) <= '%s' and [Assigned User ID] = '%s'"), sDatabase, sStartDate, sEndDate, ElUser->sUser_ID);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			
			while(!Query.IsEOF())
			{
				sSQL = _T("Строк");
			
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sSQL = sSQL+_T("\t")+GetValue(&dbValue);
				if(GetValue(&dbValue)!=_T("0"))
				{
					sArray->Add(sSQL);
				}
				Query.MoveNext();
			}
			Query.Close();
		}

		if(iExport == 0)
		{
			sSQL.Format(_T("select count(*) as con from [%s$Trip] where Left(CONVERT ( nchar , [Create Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Create Date], 112),8) <= '%s' and [Created By User] = '%s'"), sDatabase, sStartDate, sEndDate, ElUser->sUser_ID);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sSQL = _T("Карт\t");
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sSQL = sSQL+GetValue(&dbValue);
				if(GetValue(&dbValue)!=_T("0"))
				{
					sArray->Add(sSQL);
				}
				Query.MoveNext();
			}
			Query.Close();
		}

		
		if(iExport == 0)
		{
			sSQL.Format(_T("select count(*) from [%s$Purch_ Inv_ Line] as pil where Left(CONVERT ( nchar , pil.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , pil.[Posting Date], 112),8) <= '%s' and pil.[Created By User] = '%s'"), sDatabase, sStartDate, sEndDate, ElUser->sUser_ID);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				//Pjcbvjdf
				sSQL = _T("Покупки\t");
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sSQL = sSQL+GetValue(&dbValue);
				if(GetValue(&dbValue)!=_T("0"))
				{
					sArray->Add(sSQL);
				}
				Query.MoveNext();
			}
			Query.Close();
		}

		if(iExport == 0)
		{
			sSQL.Format(_T("select count(*) from [%s$Transfer Shipment Header] as tsh join [%s$Transfer Shipment Line] as tsl on tsh.[No_] = tsl.[Document No_]	where Left(CONVERT ( nchar , tsh.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , tsh.[Posting Date], 112),8) <= '%s' and tsl.[Created By User] = '%s'"), sDatabase,sDatabase, sStartDate, sEndDate, ElUser->sUser_ID);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sSQL = _T("внутреннее перемещение\t");
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sSQL = sSQL+GetValue(&dbValue);
				if(GetValue(&dbValue)!=_T("0"))
				{
					sArray->Add(sSQL);
				}
				Query.MoveNext();
			}
			Query.Close();
		}

		if(iExport == 0)
		{
			sSQL.Format(_T("select count(*) from (select tsh.[No_] ,(select top 1 [Created By User] from [%s$Transfer Shipment Line] as tsl where tsh.[No_] = tsl.[Document No_]) as Name_User from [%s$Transfer Shipment Header] as tsh where Left(CONVERT ( nchar , tsh.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , tsh.[Posting Date], 112),8) <= '%s' and tsh.[Shipment Method Code] = 'САМОВЫВОЗ') as tab where tab.Name_User is not NULL  and Name_User = '%s'"), sDatabase,sDatabase, sStartDate, sEndDate, ElUser->sUser_ID);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sSQL = _T("Самовывоз\\перемещение\t");
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sSQL = sSQL+GetValue(&dbValue);
				if(GetValue(&dbValue)!=_T("0"))
				{
					sArray->Add(sSQL);
				}
				Query.MoveNext();
			}
			Query.Close();
		}


		if(iExport == 0)
		{
			sSQL.Format(_T("select count(*) from (select prh.[No_] ,(select top 1 [Created By User] from [%s$Purch_ Rcpt_ Line] as prl where prh.[No_] = prl.[Document No_]) as Name_User from [%s$Purch_ Rcpt_ Header] as prh where Left(CONVERT ( nchar , prh.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , prh.[Posting Date], 112),8) <= '%s' ) as tab where tab.Name_User is not NULL and Name_User = '%s'"), sDatabase,sDatabase, sStartDate, sEndDate, ElUser->sUser_ID);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sSQL = _T("Самовывоз\\по покупкам\t");
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sSQL = sSQL+GetValue(&dbValue);
				if(GetValue(&dbValue)!=_T("0"))
				{
					sArray->Add(sSQL);
				}
				Query.MoveNext();
			}
			Query.Close();
		}
		
		
		if(iExport == 0)
		{
			sSQL.Format(_T("select count(*) as con from [%s$Posted Whse_Shipment Header SW] as SW left join [%s$Delivery Request] as RS on SW.[General Delivery Code] = RS.[General Delivery Code] where Left(CONVERT ( nchar , SW.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , SW.[Posting Date], 112),8) <= '%s' and SW.[Create User ID] = '%s' and (SW.[General Delivery Code] = '' or  RS.[Created By User] = 'n-nav') "), sDatabase,sDatabase, sStartDate, sEndDate, ElUser->sUser_ID);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sSQL = _T("Самовывоз\\по продажам \t");
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sSQL = sSQL+GetValue(&dbValue);
				if(GetValue(&dbValue)!=_T("0"))
				{
					sArray->Add(sSQL);
				}
				Query.MoveNext();
			}
			Query.Close();
		}

		if(iExport == 0)
		{
			sSQL.Format(_T("select Count(*) from [%s$Posted Whse_Shipment Header SW] as pw join [%s$Delivery Request] as drs on pw.[General Delivery Code] = drs.[General Delivery Code] where Left(CONVERT ( nchar , [Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Posting Date], 112),8) <= '%s' and [Create User ID] = '%s' and pw.[General Delivery Code] <> '' and drs.[Created By User] <> 'n-nav'"), sDatabase,sDatabase, sStartDate, sEndDate, ElUser->sUser_ID);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sSQL = _T("Доставки\\ по продажам \t");
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sSQL = sSQL+GetValue(&dbValue);
				if(GetValue(&dbValue)!=_T("0"))
				{
					sArray->Add(sSQL);
				}
				Query.MoveNext();
			}
			Query.Close();
		}

		if(iExport == 0)
		{
			sSQL.Format(_T("select count(*) as con from [%s$Delivery Request] where Left(CONVERT ( nchar , [Create Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Create Date], 112),8) <= '%s' and [Created by user] = '%s' and [Delivery Pattern Code] = 'ПЕРЕМЕЩЕНИЕ'"), sDatabase, sStartDate, sEndDate, ElUser->sUser_ID);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sSQL = _T("Доставки перемещение\t");
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sSQL = sSQL+GetValue(&dbValue);
				if(GetValue(&dbValue)!=_T("0"))
				{
					sArray->Add(sSQL);
				}
				Query.MoveNext();
			}
			Query.Close();
		}

	/*	if(iExport == 0)
		{
			sSQL.Format(_T("select count(*) as con from [%s$Delivery Routing Sheet] where Left(CONVERT ( nchar , [Create Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Create Date], 112),8) <= '%s' and [Created by user] = '%s' and [Delivery Pattern Code] = 'ПЕРЕМЕЩЕНИЕ'"), sDatabase, sStartDate, sEndDate, ElUser->sUser_ID);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sSQL = _T("Доставки продажи\t");
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sSQL = sSQL+GetValue(&dbValue);
				if(GetValue(&dbValue)!=_T("0"))
				{
					sArray->Add(sSQL);
				}
				Query.MoveNext();
			}
			Query.Close();
		}
*/
		if(iExport == 1)
		{
			sSQL.Format(_T("select count(*) as Con, SUM(ConLine) as ConLine ,SUM(ConUniLine) as ConUniLine from (select HD.[Trip Code],(select count(*) from [%s$Delivery Request] as RS where RS.[Trip Code] = HD.[Trip Code]) as ConLine, (select count(*) from (select distinct [Contractor No_],[Delivery Zone Of Arrival] from [%s$Delivery Request] as RS2 where RS2.[Trip Code] = HD.[Trip Code]) as TB) as ConUniLine from [%s$Trip]  as HD where Left(CONVERT ( nchar , HD.[Create Date], 112),8) >= '%s' and Left(CONVERT ( nchar , HD.[Create Date], 112),8) <= '%s' and HD.[Driver No_] = '%s') as TB2"), sDatabase,sDatabase,sDatabase, sStartDate, sEndDate, ElUser->sUser_ID);
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sSQL = ElUser->sUser_Email+_T("\t");
								
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sSQL = sSQL+GetValue(&dbValue);	

				if(GetValue(&dbValue)!=_T("0"))
				{
					iField = 1;
					Query.GetFieldValue(iField, dbValue);
					sSQL = sSQL+_T("\t")+GetValue(&dbValue);

					iField = 2;
					Query.GetFieldValue(iField, dbValue);
					sSQL = sSQL+_T("\t")+GetValue(&dbValue);
					sArray->Add(sSQL);
				}
				Query.MoveNext();
			}
		}
		Query.Close();
		
	}
	catch(CDBException *exsept)
	{
		WriteToLogFile(exsept->m_strError+_T("\n")+sSQL);
		exsept->Delete();
		if(dBase->IsOpen())
		{
			dBase->Close();
		}
		delete(dBase);
		dBase = NULL;
		return FALSE;
	}
	if(dBase->IsOpen())
		{
			dBase->Close();
		}
		delete(dBase);
	return TRUE;
}

bool SaveAsExcel(CStringArray * sArray, CString sFields)
{
	CDatabase* ExcelData;
	CString sSQL;
	try{
		CString sDriver =  _T("MICROSOFT EXCEL DRIVER (*.XLS)");
		
		try
		{
			
			CString sExport;
			sExport = sPath + _T("Report.xls");
			DeleteFile(sExport);
			
			
			ExcelData = new(CDatabase);
			sSQL.Format(_T("DRIVER={%s};DSN='';FIRSTROWHASNAMES=1;READONLY=FALSE;CREATE_DB=\"%s\";DBQ=%s"), sDriver,sExport,sExport);
			
			if(!ExcelData->OpenEx(sSQL,CDatabase::noOdbcDialog))
			{
				WriteToLogFile(_T("Не открыта Excel дата"));
				delete(ExcelData);	
				return FALSE;
			}
			
		}      
		catch(CDBException *exc)	
		{
			WriteToLogFile(_T("ODBC Excel драйвер не установлен. - ") +exc->m_strError);
			exc->Delete();
			if(ExcelData->IsOpen())
				ExcelData->Close();
			delete(ExcelData);	
				return FALSE;
		
		}

		CString sValue;
		sValue = sFields;
		sValue.Replace(_T(","),_T(" TEXT,"));
		if(sValue.Right(4) != _T("TEXT"))
		{
			sValue = sValue + _T("TEXT");
		}
		sSQL = _T("CREATE TABLE [REPORT] (")+sValue+_T(")");		
		ExcelData->ExecuteSQL(sSQL);
		

		for(int j=1;j<sArray->GetCount();j++)
		{
			sValue = sArray->ElementAt(j);
			sValue.Replace(_T("\t"),_T("','"));
			sValue = _T("'")+sValue+_T("'");
			
			sSQL =_T("INSERT INTO [REPORT] (")+sFields+_T(") VALUES (")+sValue+_T(")");			
			ExcelData->ExecuteSQL(sSQL);
				//sSQL.Format(_T(""),0)
		}
		if(ExcelData->IsOpen())
				ExcelData->Close();
			delete(ExcelData);
		}
		catch(CDBException * error)
		{
			WriteToLogFile(error->m_strError);
			WriteToLogFile(sSQL);
			if(ExcelData->IsOpen())
				ExcelData->Close();
			delete(ExcelData);
			return FALSE;
		}
	
	return TRUE;
}

void Run()
{
	WriteToLogFile(_T("Начало работы"));
	int iIterVal;
	
	iIterVal = 0;
	CArray<stUsers*, stUsers*> mUsers;
	
	COleDateTime datStart,datEnd;
	COleDateTimeSpan ts = 1;

	COleDateTime datStartService;
	stUsers * elUser;

	CString sMess;
	int i;
	int iEXPORT_USER_MAIL;
	CStringArray sArray;
	CStringArray sArrayAll;
	
	CString sUserType;
	int iPosition;
	iPosition = 0;
	int COUNT_EXPORTS;
	
	CString sReadVal;
	CString sOldDate;
	int iExportTime;
	BOOL bContinue;
	int iEXPORT_TYPE;
	
	while(!bStop)
	{
		if(iIterVal > 0)
		{
			iIterVal = iIterVal - 500;
			Sleep(500);
			continue;
		}
		
		COUNT_EXPORTS = _wtoi(sReadFromIni(_T("COUNT"),_T("EXPORT_COUNT"),_T("0")));

		if(COUNT_EXPORTS < 1)
		{
			iIterVal = 600000;
			continue;
		}

		iPosition=0;
		while(iPosition < COUNT_EXPORTS)
		{
			iIterVal = 0;
			if(bStop)
				{
					break;
				}
			sReadVal.Format(_T("EXPORT_%d"),iPosition);
			
			
			datStart = COleDateTime::GetCurrentTime();
			sOldDate = sReadFromIni(sReadVal,_T("DATE"), _T(""));
			if(sOldDate.GetLength()<2)
			{
				datEnd = datStart - ts;
				sOldDate = datEnd.Format(_T("%Y%m%d"));
			}
			/*else
			{
				
			}*/
			
			
			
			iExportTime = -1;
			iExportTime = _wtoi(sReadFromIni(sReadVal,_T("EXPORT_TIME"), _T("-1")));
			bContinue = TRUE;
			sUserType = sReadFromIni(sReadVal,_T("USER_TYPE"), _T(""));
			iEXPORT_USER_MAIL = _wtoi(sReadFromIni(sReadVal,_T("EXPORT_USER_MAIL"),_T("0")));
			switch(iExportTime)
			{
				case 0:
					if(sOldDate < datStart.Format(_T("%Y%m%d")))
					{
						int iYear,iMouth,iDay;
						iYear = _wtoi(sOldDate.Left(4));
						sOldDate = sOldDate.Right(sOldDate.GetLength()-4);
						iDay = _wtoi(sOldDate.Right(2));
						iMouth = _wtoi(sOldDate.Left(2));
						datStart.SetDate(iYear,iMouth,iDay);
						datEnd = datStart;
						datStart = datEnd;
						sOldDate = datEnd.Format(_T("%Y%m%d"));
						WriteToLogFile(_T("Ежедневный - ")+sUserType);
						bContinue = FALSE;
						
					}
					break;
					
				case 1:
					if(sOldDate < datStart.Format(_T("%Y%m%d")))
					{
						WriteToLogFile(_T("C начала месяца - ")+sUserType);
						datStart = datStart - ts;	
						datEnd = datStart;
						while(datStart.GetMonth() == datEnd.GetMonth())
						{
							datStart = datStart - ts;
						}
						datStart = datStart + ts;
						bContinue = FALSE;
					}
					break;
					
				case 2:
					if(sOldDate.Left(6) < datStart.Format(_T("%Y%m")))
					{
						WriteToLogFile(_T("Ежемесячный - ")+sUserType);
						datStart = datStart - ts;	
						datEnd = datStart;
						while(datStart.GetMonth() == datEnd.GetMonth())
						{
							datStart = datStart - ts;
						}
						datStart = datStart + ts;
						bContinue = FALSE;
					}
					break;
				default:
					break;
			}
			
			if(bContinue)
			{
				iPosition++;
				continue;
			}
			
			iEXPORT_TYPE = _wtoi(sReadFromIni(sReadVal,_T("EXPORT_TYPE"), _T("0")));
			CString sLog;
			sLog.Format(_T("EXPORT_TYPE - %d"),iEXPORT_TYPE);
			WriteToLogFile(sLog);

			
			if(!GetUserList(&mUsers,datStart.Format(_T("%Y%m%d")),datEnd.Format(_T("%Y%m%d")),sUserType,iEXPORT_TYPE))
			{
				iPosition++;
				WriteToLogFile(_T("не выполненно"));
				continue; 
			}
			
			i=0;
			sArrayAll.RemoveAll();
			sArrayAll.Add(_T("Период с ")+datStart.Format(_T("%d.%m.%Y"))+_T(" по ")+datEnd.Format(_T("%d.%m.%Y")));
			
			while(i<mUsers.GetCount())
			{
				CString sBody;
				elUser = mUsers.ElementAt(i);
				if(!GetUserData(elUser,datStart.Format(_T("%Y%m%d")),datEnd.Format(_T("%Y%m%d")), &sArray, iEXPORT_TYPE))
				{
					iPosition++;
					WriteToLogFile(_T("не выполненно"));
					continue; 
				}

				sBody = _T("Период с ")+datStart.Format(_T("%d.%m.%Y"))+_T(" по ")+datEnd.Format(_T("%d.%m.%Y"));
				for(int j=0;j<sArray.GetCount();j++)
				{
					sArrayAll.Add(elUser->sUser_Name+_T("\t")+sArray.ElementAt(j));
					sBody = sBody + _T("\n")+sArray.ElementAt(j);
				}
					
				if((elUser->sUser_Email.GetLength()>5)&&(iEXPORT_USER_MAIL == 1))
				{
					WriteToLogFile(_T("SMTP"));
					CSMTPConnection smtp;
					CString sMailServer;
					sMailServer = sReadFromIni(_T("E-MAIL"),_T("SERVER"),_T("10.0.0.1"));
					
					if (!smtp.Connect(sMailServer))
					{
						DWORD dError = WSAGetLastError();
						if(dError > 0)
						{
							CString sResponse;
							sResponse = "";
								//sResponse = smtp.GetLastCommandResponse();
							
							sResponse = GetErrorText(&dError);
							WriteToLogFile(sResponse);
						}
						else
						{
							CString sResponse = smtp.GetLastCommandResponse()+GetErrorText(&dError);
							WriteToLogFile(sResponse);
						}
					}
					else
					{
						CSMTPMessage m;
						sMailServer = sReadFromIni(_T("E-MAIL"),_T("FROM"),_T("roman.kushel@shate-m.com"));
						CSMTPAddress From(sMailServer); //Change these values to your settings
						m.m_From = sMailServer;
						CSMTPAddress To(elUser->sUser_Email);   //Change these values to your settings					
						m.AddRecipient(To, CSMTPMessage::TO);
						sMailServer = sReadFromIni(_T("E-MAIL"),_T("SUBJECT"),_T(""));
						m.m_sSubject = sMailServer;
						m.AddBody(sBody);
						if (!smtp.SendMessage(m))
						{
							CString sResponse = smtp.GetLastCommandResponse();
							WriteToLogFile(sResponse);
						}
				
						if(!smtp.Disconnect())
						{
							CString sResponse = smtp.GetLastCommandResponse();
							WriteToLogFile(sResponse);
						}
					}
				}
				i++;
			}
			
			

			if(sArrayAll.GetCount()>1)
			{
				WriteToLogFile(_T("SMTP"));
				CSMTPConnection smtp;
				CString sMailServer;
				sMailServer = sReadFromIni(_T("E-MAIL"),_T("SERVER"),_T("10.0.0.1"));
			
				if (!smtp.Connect(sMailServer))
				{
					CString sResponse = smtp.GetLastCommandResponse();
					WriteToLogFile(sResponse);
					iIterVal = 10000;
				}
				else
				{
					CSMTPMessage m;
					sMailServer = sReadFromIni(_T("E-MAIL"),_T("FROM"),_T("roman.kushel@shate-m.com"));
					CSMTPAddress From(sMailServer); //Change these values to your settings
					m.m_From = sMailServer;

					sMailServer = sReadFromIni(sReadVal,_T("TO"),_T("roman.kushel@shate-m.com"));
					int iFind;
					sMailServer = sMailServer+ _T(";");
					WriteToLogFile(sMailServer);
					iFind = sMailServer.Find(_T(";"));
					while(iFind > 0)
					{
						if(iFind>0)
						{
							CSMTPAddress To(sMailServer.Left(iFind));   //Change these values to your settings
							m.AddRecipient(To, CSMTPMessage::TO);
						}
						sMailServer = sMailServer.Right(sMailServer.GetLength()-iFind-1);
						iFind = sMailServer.Find(_T(";"));
					}

					
					sMailServer = sReadFromIni(_T("E-MAIL"),_T("SUBJECT"),_T(""));
					m.m_sSubject = sMailServer+_T(" ")+sUserType;
					sMailServer = "";
					sMailServer = sReadFromIni(sReadVal,_T("FIELDS"),_T(""));
					
					if(!SaveAsExcel(&sArrayAll, sMailServer))
					{
						CString sResponse = smtp.GetLastCommandResponse();
						WriteToLogFile(sResponse);
						iIterVal = 10000;
					}
					else
					{
						CSMTPAttachment attachment;
						CString sExport;
						m.AddBody(sArrayAll.ElementAt(0));
						sExport = sPath + _T("Report.xls");
						attachment.Attach(sExport);
						m.AddAttachment(&attachment);
						
						if (!smtp.SendMessage(m))
						{
							CString sResponse = smtp.GetLastCommandResponse();
							WriteToLogFile(sResponse);
							iIterVal = 10000;	
						}
					}
					if(!smtp.Disconnect())
					{
						CString sResponse = smtp.GetLastCommandResponse();
						WriteToLogFile(sResponse);
						iIterVal = 10000;	
					}
						
				}
			}
				
			if(iIterVal < 1)
			{
				WriteToLogFile(_T("Выполненно"));
				datStartService = datEnd + ts;
				sWriteToIni(sReadVal,_T("DATE"),datStartService.Format(_T("%Y%m%d")));
			}				
			iPosition++;	
		}
		iIterVal = 600000;
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


bool UninstallService(DWORD* pErr)
{
	*pErr = 0;

	SC_HANDLE hSCM;
	SC_HANDLE hService;

	hSCM = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS);

	if (!hSCM)
	{
		if (GetLastError()==ERROR_ACCESS_DENIED)
		{
		}
		else
		{
		}		
		return false;
	}

	hService = OpenService(hSCM, ServiceName,  DELETE | SERVICE_STOP);
	
	if (!hService)
	{
		CloseServiceHandle(hSCM);

		if (GetLastError()==ERROR_SERVICE_DOES_NOT_EXIST)
		{
			// Службы не существует, значит удаление завершено успешно
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
		if(Err != 0)
		MessageBox(NULL, GetErrorText(&Err), DisplayName, MB_OK);
		return false;
	}

	return true;
}

bool InstallEventLog(DWORD* pErr)
{
	WriteToLogFile(_T("InstallEventLog"));
	return true;
}

bool InstallService(DWORD* pErr)
{
	WriteToLogFile(_T("InstallService"));
	*pErr = 0;
	SC_HANDLE hSCM;
	SC_HANDLE hService;	
	WriteToLogFile(_T("InstallService - OpenSCManager"));
	hSCM = OpenSCManager(NULL, NULL, SC_MANAGER_CREATE_SERVICE);
	
	*pErr = GetLastError();
	if (!hSCM)
	{
		return false;
	}
		
	TCHAR ServicePath[_MAX_PATH + 3];
	WriteToLogFile(_T("InstallService - ServicePath"));
	// Получаем путь к exe-файлу
	GetModuleFileName(NULL, ServicePath + 1, _MAX_PATH);

	// Заключаем в кавычки
	ServicePath[0] = TEXT('\"');
	ServicePath[lstrlen(ServicePath) + 1] = 0;
	ServicePath[lstrlen(ServicePath)] = TEXT('\"');

	// Созддаём службу
	WriteToLogFile(_T("InstallService - CreateService"));
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
	WriteToLogFile(_T("InstallService - CloseServiceHandle"));
    if (!hService)
	{
		int iError = GetLastError();
		switch (iError)
		{
		case ERROR_DUP_NAME:
			break;
		case ERROR_SERVICE_EXISTS:
			break;
		}		

		return false;
	}

	// Закрываем службу
	CloseServiceHandle(hService);
	WriteToLogFile(_T("InstallService - end"));
	return true;
}


bool WriteDescription(HINSTANCE hInst, DWORD* pErr)
{
	WriteToLogFile(_T("WriteDescription"));
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


int _tmain(int argc, TCHAR* argv[], TCHAR* envp[])
{
	int nRetCode = 0;


	bStop = FALSE;
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
		else
		{
			DisplayHelp();
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

    
	StartServiceCtrlDispatcher(steTable);
	
	
	return nRetCode;
}
