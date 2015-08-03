#pragma once
#define MSG_LEN 256
#include "winsvc.h"
#define SERVICE_PARENT_KEY TEXT("System\\CurrentControlSet\\Services")
#define LOG_PARENT_KEY     TEXT("System\\CurrentControlSet\\Services\\Eventlog\\Application")
#define MSG_PARAMETERS_CHANGED           0x00000002L
#define PARAMETERS_CHANGED           129
typedef void (*RunClient)();

/*
ssServerSocet.sokClientSocket[i]->hThread = CreateThread (NULL, NULL, (LPTHREAD_START_ROUTINE)ClientEventHandlerProc, (void*)stCurrSocet, NULL, &dwThreadID); 
*/

class CService
{
protected:
		CString DefName;
		CString sServiceName;
		CString sDisplayName;
		CString sDescription;
		CString sEventSource;
		CString sHelpData;
		SERVICE_STATUS_HANDLE ssHandle;
		SERVICE_STATUS sStatus;
		HANDLE hSendThread;
		HANDLE eSendPending;
		HANDLE hEndEvent;
		RunClient m_RunClient;		
public:
	CService(CString sName=_T(""));
	~CService(void);
	CString GetLastErrorText();
	CString GetErrorText(DWORD dError);
	BOOL LoadFromIni(void);
	BOOL Install(CString * sError=NULL);
	BOOL InstallService(CString * sError=NULL);
	BOOL WriteDescription(CString * sError=NULL);
	BOOL InstallEventLog(CString * sError=NULL);
	BOOL Uninstall(CString * sError =NULL);
	BOOL UninstallService(CString * sError=NULL);
	BOOL UninstallEventLog(CString * sError=NULL);
	BOOL SetHelpInfo(CString sNewValue);
	void DisplayHelp();
	void Run();
	static void WINAPI ServiceMain(DWORD dwArgc, LPTSTR *psArgv);
	static void WINAPI ServiceHandler(DWORD dwCode);
	void BeginSendPending(DWORD dwPendingType);
	bool Init(DWORD* pErr, DWORD* pSpecErr);
	void EndSendPending();
	static CString GetServiceName();
	static DWORD WINAPI SendPending(LPVOID dwState);
	void SetWorkDirectory();
	
	void SetClientFunction(RunClient Fuction);
	DWORD GetStatus(void);
};
