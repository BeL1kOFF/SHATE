// Nav_Scaner_Server.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "Nav_Scaner_Actions.h"
#include "..\Modul\Service.h"
#include "..\Modul\ServerSocket.h"
#include "..\Modul\IniReader.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// The one and only application object

CWinApp theApp;

using namespace std;
CService m_Service(_T("Nav_Assembler_Service"));

CStringW GetWinUserName()
{
	wchar_t buffer[257];		// буфер
	DWORD size;			// размер
	size=sizeof(buffer);		// размер буфера
	if (GetUserName(buffer,&size)==0)
		throw "Error GetWinUserName";	// при ошибке функция вернет 0
	return buffer;
}

CDatabase* OpenDatabase(CDatabase* dClientBase)
{
	if(dClientBase == NULL)
	{
		WriteToLog(_T("NULL база"));	
		return NULL;
	}

	try
	{
		if(dClientBase!=NULL)
		{
			if(dClientBase->IsOpen())
				dClientBase->Close();
		}
	}
	catch(CDBException *exsept)
	{
		WriteToLog(exsept->m_strError);	
		exsept->Delete();
		return dClientBase;
	}

	CIniReader iniReader;
	CString sConnect;

	CString sServer, sDatabase;
	sServer = iniReader.ReadFromIni(_T("NAV"),_T("SERVER"),_T("svbyminssq3"));
	sDatabase = iniReader.ReadFromIni(_T("NAV"),_T("DATABASE"),_T("SHATE-M-8"));
	
	try
	{

		sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
		dClientBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
		dClientBase->ExecuteSQL(sConnect);
		dClientBase->SetQueryTimeout(0);
		sDatabase =iniReader.ReadFromIni(_T("NAV"),_T("FIRM"),_T("SHATE-M-8"));
		
	}
	catch(CDBException *exsept)
	{
		WriteToLog(sConnect);	
		WriteToLog(exsept->m_strError);	
		exsept->Delete();
	}
	return dClientBase;
}

int SendAutorization(CDatabase *dClientBase, CStringA* saValue, SOCKET* sok,CString *sFirm, CString *sError)
{
	CString sSQL;
	CString sValue;
	long lUser;
	lUser = -1;
	CServerSocet socet;
	
	*saValue = saValue->Right(saValue->GetLength()-5);
	*saValue = saValue->Left(saValue->GetLength()-5);
	sValue = socet.Translate(*saValue);
	
	CString sName;
	sName = sValue;
	if(!dClientBase->IsOpen())
	{
		
		CStringA sValue;
		sValue.Format("AUTR_%s_AUTR",socet.Translate(_T("Не подключились к БД!"))); 
		*sError = sValue;
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	try
	{
		lUser = 1;
		CRecordset Query(dClientBase);
		sName.Replace(_T("'"),_T(""));
		lUser = 1;
		sSQL.Format(_T("select top 1 we.[User ID],  we.[Location Code],  wze.[Zone Code],  wze.[Confirm Quantity], wze.[Number in Turn],  wze.[Last Connect] from [Shate-m$Warehouse Employee] as we left join [Shate-m$Warehouse Zone Employee] as wze on wze.[User ID] = we.[User ID] and wze.[Location Code] = we.[Location Code] where we.[User ID] = '%s' and we.[Default] = 1"),sFirm, sFirm,sName);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		if(Query.IsEOF())
		{
			Query.Close();
			CStringA sValue;
			sValue.Format("AUTR_%s_AUTR",socet.Translate(_T("Пользователь не найден!"))); 
			send(*sok,sValue,sValue.GetLength()+1,0);
		}
		else
		{
			CDBVariant dbValue;
			CString sWValue;
			int i;
			for(i=0;i<Query.GetODBCFieldCount();i++)
			{
				Query.GetFieldValue(i,dbValue);
				sWValue = sWValue+ ReplaceLeftSymbols(GetValue(&dbValue),2)+_T("|");
			}
			Query.Close();
			CStringA sValue;
			sValue.Format("AUTR_%s_AUTR",socet.Translate(sWValue)); 
			send(*sok,sValue,sValue.GetLength()+1,0);
			return lUser;
		}
		
	}
	catch(CDBException *exsept)
	{
		lUser = -1;
		sError->Format(_T("%s %s"),exsept->m_strError, sSQL);
		exsept->Delete();
		CStringA sValue;
		sValue.Format("AUTR_%s_AUTR",socet.Translate(_T("Ошибка при выполнении!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
	}
	return lUser;
}

LPTHREAD_START_ROUTINE ClientEventHandlerProc(LPVOID pparam)
{
	HANDLE hSocketEvent;
	WSANETWORKEVENTS NetworkEvents;
	hSocketEvent = WSACreateEvent();
	SOCKET sok;
	CServerSocet socet;
	CDatabase *dClientBase;
	dClientBase = NULL;
	CurrSocet *stCurrSocet = (CurrSocet*)pparam;
	sok = *stCurrSocet->sSocet->sokClientSocket[stCurrSocet->CurrPos]->sok;
	dClientBase = stCurrSocet->sSocet->sokClientSocket[stCurrSocet->CurrPos]->dBase;
	WSAEventSelect(sok, hSocketEvent, FD_CLOSE|FD_CONNECT|FD_READ);
	BOOL bSend;
	bSend = FALSE;
	CString sValue;
	

	
	CStringArray sDocsPos;
	CString sConnect;
	CStringA saValue;
	int iRet;
	CString sError;
	
	CString sFirm;
	CIniReader iniReader;
	sFirm = iniReader.ReadFromIni(_T("NAV"),_T("FIRM"),_T("SHATE-M-8"));
	while (true) 
		{   
			WaitForSingleObject(hSocketEvent, INFINITE);
			WSAEnumNetworkEvents(sok, hSocketEvent, &NetworkEvents);
			if(NetworkEvents.lNetworkEvents == FD_CLOSE)
			{
				return 0L;
			}
			
			if(NetworkEvents.lNetworkEvents == FD_READ)
			{
				saValue = "";
				char gettext[100];
				
				while(recv(sok,gettext,100,0) > 0)
				{
					saValue = saValue +gettext;
				}

				CString s;
				s = saValue;
				
				if(dClientBase == NULL)
				{
					return 0L;
				}
				
				if(!dClientBase->IsOpen())
					{
						dClientBase = OpenDatabase(stCurrSocet->sSocet->sokClientSocket[stCurrSocet->CurrPos]->dBase);
						stCurrSocet->sSocet->sokClientSocket[stCurrSocet->CurrPos]->dBase = dClientBase;
						if(!dClientBase->IsOpen())
							continue; 	
					}

				//AUTR Авторизация
				if((saValue.Left(5) == "AUTR_")&&(saValue.Right(5)=="_AUTR"))
				{
					iRet = SendAutorization(dClientBase,&saValue, &sok,&sFirm, &sError);
					continue;
				}

				if(iRet < 1)
				{
					if(sError.GetLength()>0)
					{
						WriteToLog(sError);				
					}
					break;
				}
			}				
		}
	return 0l;
}

void Run()
{
	CIniReader iniReader;
	
	

	CServerSocet ServerSocket;
	CString sError;
	CString sVal;
	//ServerSocket
	while(m_Service.GetStatus() != SERVICE_STOPPED)
	{
		if(!ServerSocket.GetState())
		{
			ServerSocket.sProtokol = iniReader.ReadFromIni(_T("SERVER"),_T("PROTOCOL"),_T("TCP"));
			ServerSocket.iPort = _wtoi(iniReader.ReadFromIni(_T("SERVER"),_T("PORT"),_T("6010")));
			ServerSocket.iMaxCol = _wtoi(iniReader.ReadFromIni(_T("SERVER"),_T("USER_COUNT"),_T("100")));
			if(ServerSocket.iMaxCol>1)
			{
				sError = "";
				if(!ServerSocket.StartServer(&sError))
				{
					iniReader.WriteToIni(_T("SERVER"),_T("LAST_ERROR"),_T("Описание в логе"));
				}
				else
					iniReader.WriteToIni(_T("SERVER_LOG"),_T("ERROR"),_T(""));
				int iFind;
				iFind = sError.Find(_T("\n"),0);
				
				while(iFind >0)
				{
					sVal = sError.Left(iFind);
					sError = sError.Right(sError.GetLength()-iFind-1);
					iFind = sVal.Find(_T("\t"),0);
					iniReader.WriteToIni(_T("SERVER_LOG"),sVal.Left(iFind),sVal.Right(sVal.GetLength()-iFind-1));
					iFind = sError.Find(_T("\n"),0);
				}
			}
			else
			{
				COleDateTime oDate;
				oDate = COleDateTime::GetCurrentTime();
				iniReader.WriteToIni(_T("SERVER"),_T("LAST_ERROR_TIME"),oDate.Format(_T("%d.%m.%Y %H:%M:%S")));
				iniReader.WriteToIni(_T("SERVER"),_T("LAST_ERROR"),_T("Не корректное число USER_COUNT"));
			}
			
		}
		else
		{
			MSG msg;
			//ClientEventHandlerProc
			ServerSocket.m_ClientTread = &ClientEventHandlerProc;
			while(GetMessage( &msg, ServerSocket.SocWin->m_hWnd, 0, 0 ) )
			{
				TranslateMessage(&msg);
				DispatchMessage(&msg);
			}

			if(iniReader.ReadFromIni(_T("SERVER"),_T("RESTART"),_T("0"))==_T("1"))
			{
				ServerSocket.CloseSocket();
			}
		}
		#ifdef _DEBUG
			if(iniReader.ReadFromIni(_T("DEBUG"),_T("STOP"),_T("0"))==_T("1"))
				break;
		#endif
		Sleep(500);	
	}
}

int _tmain(int argc, TCHAR* argv[], TCHAR* envp[])
{
	int nRetCode = 0;
	CString sValue;
	if (!AfxWinInit(::GetModuleHandle(NULL), NULL, ::GetCommandLine(), 0))
	{
		nRetCode = 1;
		return nRetCode;
	}
	CString sFileName =argv[0];
	sFileName.MakeLower();
	if(sFileName.Right(4)!=_T(".ini"))
	{
		sFileName = sFileName.Left(sFileName.GetLength()-4);
		sFileName = sFileName + _T(".ini");
	}
	free((void*)AfxGetApp()->m_pszProfileName);
	AfxGetApp()->m_pszProfileName = _tcsdup(sFileName);

	
	
	
	
	m_Service.LoadFromIni();
	m_Service.SetHelpInfo(_T("Сервис сервера ТСД для ведения инвентаризаций"));

	if (argc > 1)
	{
		CString sValue = argv[1];
		sValue.MakeLower();

		if (sValue == _T("/install"))
		{
			
			if(!m_Service.Install(&sValue))			
				AfxMessageBox(sValue);
			else
				AfxMessageBox(_T("install"));
		}
		else if (sValue == _T("/uninstall"))
		{
			if(!m_Service.Uninstall(&sValue))			
				AfxMessageBox(sValue);
			else
				AfxMessageBox(_T("uninstall"));
		}
		else
		{
			m_Service.DisplayHelp();
		}
		return 0;
	}
	m_Service.SetClientFunction(&Run);
	m_Service.Run();
	return nRetCode;
}
