#pragma once

#include "resource.h"
#include "winsvc.h"
#include "ZipArchive.h"
CWinApp theApp;

using namespace std;

#define MSG_LEN 256
#define KEY_LEN MSG_LEN
#define ServiceName TEXT("EI Price Servise")
#define DisplayName TEXT("EI Price Servise - преобразование номеров зч для клиентов")
#define EventSource TEXT("EI Price Servise - преобразование номеров зч для клиентов")
#define SERVICE_PARENT_KEY TEXT("System\\CurrentControlSet\\Services")
#define LOG_PARENT_KEY     TEXT("System\\CurrentControlSet\\Services\\Eventlog\\Application")
#define PARAMETERS_CHANGED           129
#define MSG_PARAMETERS_CHANGED           0x00000002L
//#define COUNT_EXPORTS 6

struct stBases
{
	CString sID;
	CString sFrom;
	CString sFilePrice;
	CString sSubject;
	int iType;
	int iTypeExport;
	CString sTo;
	CString sAttach;
	BOOL bArchiv;
	CString sCopyTo;
};

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

CString ReplaceLeftSymbols(CString sText, int iType = 0);
bool bOpenDatabase(CDatabase ** dBase, CString* sError);
void CloseDatabase(CDatabase * dBase);
bool bLoadExports(CDatabase * dBase,stBases ** massBases,int * iMaxCount, CString* sError);
bool StartExport(CDatabase * dBase,stBases * m_stBases, CString* sError);
bool LoadPrice_1(CDatabase* dBase ,CString sID,CString sFileName,CString*sError);
