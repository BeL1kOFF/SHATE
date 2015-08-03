#pragma once

#include "resource.h"
#include "winsvc.h"
#include "afxdb.h"
#include "Item.h"
CWinApp theApp;

using namespace std;

#define MSG_LEN 256
#define KEY_LEN MSG_LEN
#define ServiceName TEXT("NAV - Export from NAV")
#define DisplayName TEXT("NAV - Export from NAV")
#define EventSource TEXT("NAV - Export from NAV")
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
BOOL bPause;
CString sPath;

CString GetLastErrorText();
CString GetErrorText(DWORD *pErr);
CString ReplaceLeftSymbols(CString sText, int iType=0);
CStringW GetValue(CDBVariant* var);
CStringW Convert(CStringA sIN);


