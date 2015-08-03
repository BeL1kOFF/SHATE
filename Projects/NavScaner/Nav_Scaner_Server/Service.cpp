#include "StdAfx.h"
#include "Service.h"
#include "IniReader.h"

CService *Service;

CService::CService(CString sName)
{
	m_RunClient = NULL;
	hSendThread = NULL;
	eSendPending  = NULL;
	hEndEvent = NULL;
	Service = this;
	DefName = sName;
}

CService::~CService(void)
{
}

CString CService::GetErrorText(DWORD dError)
{
	void* cstr;
	if(dError > 0)
	{
		FormatMessageA(
		FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
			NULL,
		dError,
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
		(LPSTR) &cstr,
		0,
		NULL
		);
	}
	else
		return _T("");

	CString res((char*)cstr),res1;
	res1.Format(_T("%d - %s"),dError,res);
	LocalFree(cstr);
	return res1;
}
CString CService::GetLastErrorText()
{
	
	DWORD dError = GetLastError();
	return GetErrorText(dError);
}


BOOL CService::LoadFromIni(void)
{
	CIniReader iniReader;
	
	sServiceName = iniReader.ReadFromIni(_T("SERVICE"),_T("NAME"),DefName);
	sDisplayName = iniReader.ReadFromIni(_T("SERVICE"),_T("DISPLAY_NAME"),DefName);
	sDescription = iniReader.ReadFromIni(_T("SERVICE"),_T("DESCRIPTION"),DefName);
	sEventSource = iniReader.ReadFromIni(_T("SERVICE"),_T("EVENTSOURCE"),DefName);
	sHelpData = iniReader.ReadFromIni(_T("SERVICE"),_T("HELPDATE"),DefName);
	
	return TRUE;
}

BOOL CService::Install(CString * sError)
{
	Uninstall();
	if(!InstallService(sError))
	{
		
		return FALSE;
	}
	if(!WriteDescription(sError))
	{
		Uninstall();
		return FALSE;
	}
	if(!InstallEventLog(sError))
	{
		Uninstall();
		return FALSE;
	}
	return TRUE;
}


BOOL CService::InstallService(CString * sError)
{
	SC_HANDLE hSCM;
	SC_HANDLE hService;	
	hSCM = OpenSCManager(NULL, NULL, SC_MANAGER_CREATE_SERVICE);
	if (!hSCM)
	{
		if(sError != NULL)
			sError->Format(_T("%s"),GetLastError());
		return FALSE;
	}
		
	TCHAR ServicePath[_MAX_PATH + 3];
	GetModuleFileName(NULL, ServicePath + 1, _MAX_PATH);

	ServicePath[0] = TEXT('\"');
	ServicePath[lstrlen(ServicePath) + 1] = 0;
	ServicePath[lstrlen(ServicePath)] = TEXT('\"');

	hService = CreateService(
		hSCM,
		sServiceName,
		sDisplayName,
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
	

    if (!hService)
	{
		if(sError != NULL)
			sError->Format(_T("%s"),GetLastErrorText());
		CloseServiceHandle(hSCM);
		return FALSE;
	}

	CloseServiceHandle(hSCM);
	CloseServiceHandle(hService);
	return TRUE;
}

BOOL CService::WriteDescription(CString * sError)
{
	DWORD res;
	TCHAR KeyName[MSG_LEN];
	wsprintf(KeyName, TEXT("%s\\%s"), SERVICE_PARENT_KEY, sServiceName);

	HKEY hKey;

	res = RegOpenKeyEx(
			HKEY_LOCAL_MACHINE,
			KeyName,
			0,
			KEY_SET_VALUE,
			&hKey);

	if (res!=ERROR_SUCCESS)
	{
		if(sError != NULL)
			sError->Format(_T("%s"),GetLastError());
		return false;
	}

	res = RegSetValueEx(
			hKey,
			TEXT("Description"),
			0,
			REG_SZ,
			(CONST BYTE*) sDescription.GetBuffer(),
			(sDescription.GetLength() + 1)*sizeof(TCHAR));

	if (res!=ERROR_SUCCESS)
	{
		if(sError != NULL)
			sError->Format(_T("%s"),GetLastError());
		RegCloseKey(hKey);
		return false;
	}

	RegCloseKey(hKey);
	return true;
}


BOOL CService::InstallEventLog(CString * sError)
{
	return TRUE;
}

BOOL CService::Uninstall(CString * sError)
{
	if (!UninstallService(sError)		
		||!UninstallEventLog(sError)
		)
	{
		return FALSE;
	}
	return TRUE;
}

BOOL CService::UninstallService(CString * sError)
{
	SC_HANDLE hSCM;
	SC_HANDLE hService;

	hSCM = OpenSCManager(NULL, NULL, SC_MANAGER_ALL_ACCESS);

	if (!hSCM)
	{
		if(sError != NULL)
			sError->Format(_T("%s"),GetLastError());
		return FALSE;
	}

	hService = OpenService(hSCM, sServiceName,  DELETE | SERVICE_STOP);
	
	if (!hService)
	{
		CloseServiceHandle(hSCM);

		DWORD dError = GetLastError();
		if (dError==ERROR_SERVICE_DOES_NOT_EXIST)
		{
			return TRUE;
		}
		else
		if(sError != NULL)
			sError->Format(_T("%s"),GetErrorText(dError));
		return FALSE;
	}

    SERVICE_STATUS ss;

	ControlService(hService, SERVICE_CONTROL_STOP, &ss);

	DeleteService(hService);

	CloseServiceHandle(hService);
	CloseServiceHandle(hSCM);

	return TRUE;
}

BOOL CService::UninstallEventLog(CString * sError)
{
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
		if(res != ERROR_FILE_NOT_FOUND)
		{	
			if(sError != NULL)
				sError->Format(_T("%s"),GetErrorText(res));
			return FALSE;
		}
	}

	res = RegDeleteKey(hKey, sEventSource);

	if (res!=ERROR_SUCCESS)
	{
		if(res != ERROR_FILE_NOT_FOUND)
		{	
			if(sError != NULL)
				sError->Format(_T("%s"),GetLastErrorText());
			RegCloseKey(hKey);
			return FALSE;
		}
	}

	RegCloseKey(hKey);
	return TRUE;
}

BOOL CService::SetHelpInfo(CString sNewValue)
{
	CIniReader iniReader;
	sHelpData = sNewValue;
	iniReader.WriteToIni(_T("SERVICE"),_T("HELPDATE"),sNewValue);
	return TRUE;
}

void CService::DisplayHelp()
{
	AfxMessageBox(sHelpData);
}
CString  CService::GetServiceName()
{
	//return Service->sServiceName;
	return _T("");
}

void CService::ServiceMain(DWORD dwArgc, LPTSTR *psArgv)
{
	Service->ssHandle =  RegisterServiceCtrlHandler(GetServiceName(), ServiceHandler);
	Service->sStatus.dwCheckPoint = 0;
	Service->sStatus.dwWaitHint = 0;
	Service->sStatus.dwControlsAccepted = SERVICE_ACCEPT_STOP 
							| SERVICE_ACCEPT_SHUTDOWN
							| SERVICE_ACCEPT_PAUSE_CONTINUE;	
	Service->sStatus.dwServiceType = SERVICE_WIN32_OWN_PROCESS;	
	Service->sStatus.dwWin32ExitCode = NOERROR;
	Service->sStatus.dwServiceSpecificExitCode = 0;
	DWORD Err, SpecErr;

	Service->BeginSendPending(SERVICE_START_PENDING);
	if (!Service->Init(&Err, &SpecErr))
	{
		Service->EndSendPending();
		Service->sStatus.dwCurrentState = SERVICE_STOPPED;
		Service->sStatus.dwWin32ExitCode = Err;
		Service->sStatus.dwServiceSpecificExitCode = SpecErr;
		SetServiceStatus(Service->ssHandle, &(Service->sStatus));
		return;
	}
	
	Service->EndSendPending();
	Service->sStatus.dwCurrentState = SERVICE_RUNNING;
	SetServiceStatus(Service->ssHandle, &(Service->sStatus));
	
	if(Service->m_RunClient != NULL)
		(*(Service->m_RunClient))();
	
}

//DWORD WINAPI CService::ServiceHandler(DWORD dwControl,DWORD dwEventType,PVOID pvEventData,PVOID pvContext)
void WINAPI CService::ServiceHandler(DWORD dwCode)
{
	switch (dwCode)
	{
	case SERVICE_CONTROL_PAUSE:
		Service->sStatus.dwCurrentState = SERVICE_PAUSED;		
		break;
	case SERVICE_CONTROL_CONTINUE:
		Service->sStatus.dwCurrentState = SERVICE_RUNNING;		
		break;
	case SERVICE_CONTROL_STOP:
	case SERVICE_CONTROL_SHUTDOWN:		
		Service->sStatus.dwCurrentState = SERVICE_STOPPED;		
		break;	
	case PARAMETERS_CHANGED:
		//ParametersChanged();		
		break;
	default:		
		break;
	}
	SetServiceStatus(Service->ssHandle, &(Service->sStatus));
}

/*
ClientEventHandlerProc
*/
void CService::Run()
{
	#ifdef _DEBUG
		if(m_RunClient != NULL)
		{
			(*m_RunClient)();
		}
		return;
	#endif

	SERVICE_TABLE_ENTRY steTable[] = 
	{
		{sServiceName.GetBuffer(), ServiceMain},
		{NULL, NULL}
	};
	StartServiceCtrlDispatcher(steTable);
}

DWORD WINAPI CService::SendPending(LPVOID dwState)
{
	Service->sStatus.dwCheckPoint = 0;	
	Service->sStatus.dwWaitHint = 2000;
	Service->sStatus.dwCurrentState = (DWORD)dwState;
	
	for (;;)
	{				
		if (WaitForSingleObject(Service->eSendPending, 1000)!=WAIT_TIMEOUT) break;
        Service->sStatus.dwCheckPoint++;
        SetServiceStatus(Service->ssHandle, &(Service->sStatus));
	}

	Service->sStatus.dwCheckPoint = 0;
	Service->sStatus.dwWaitHint = 0;
	return 0;
}


void CService::BeginSendPending(DWORD dwPendingType)
{
	Service->hSendThread = NULL;
	Service->eSendPending = CreateEvent(NULL, TRUE, FALSE, NULL);
	if (!Service->eSendPending) return;
	
	DWORD dwId;
	
	
	hSendThread = CreateThread(NULL, 0, SendPending, (LPVOID)dwPendingType, 0, &dwId);
	
	if (!hSendThread) 
	{
		CloseHandle(eSendPending);
		eSendPending = NULL;
		return;
	}
}


bool CService::Init(DWORD* pErr, DWORD* pSpecErr)
{	
	Service = this;
	*pErr = 0;
	*pSpecErr = 0;	

	Service->hEndEvent = CreateEvent(NULL, TRUE, FALSE, NULL);

	if (!hEndEvent)
	{
		*pErr = GetLastError();
		return false;
	}

	Service->SetWorkDirectory();
    return true;
}

void CService::EndSendPending()
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

void CService::SetWorkDirectory()
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
void CService::SetClientFunction(RunClient Fuction)
{
	m_RunClient = Fuction;
}

DWORD CService::GetStatus(void)
{
	return Service->sStatus.dwCurrentState;
}
