#pragma once

#ifdef WINCE
#pragma comment(lib, "ws2.lib")
#else
#pragma comment(lib, "ws2_32.lib")
#endif

#pragma comment(lib, "C:\\Program Files\\Microsoft SDKs\\Windows\\v6.0A\\Lib\\Wsock32.lib")

//const int WINSOCK_VERSION = 0x0101;
const int WM_SERVER_ACCEPT = WM_USER+1;

//#include "winsock.h"
#include "Winsock2.h"

class CClientSocket
{
public:
	CClientSocket();
	CArray<CStringA,CStringA> saValues;
	virtual ~CClientSocket();
	CString MyGetLastError();
	CStringA SendData(CString sMess, CStringA sHead,int iTimeOut = 1);


	CStringA SendData(CStringA buff, int iTimeOut = 1, int iSendLen = 0);
	BOOL SaveFile(CStringA buff, CString sNewName, int iTimeOut = 1);

	DWORD dwThreadID; 
	HANDLE hThread;
	HANDLE hThreadWiFi;
	BOOL ListenSocket();
	BOOL LinkWindowSocket(HWND m_hWnd);
	BOOL LinkSoketPort();
	BOOL IsSocketCreate();
	BOOL CloseSocket();
	BOOL CreateSocket();
	CString sHostName;
	BOOL SocketGetHostName();
	BOOL StopWinSock();
	BOOL IsStartWSA();
	BOOL StartServer();
	BOOL StartWinSock();
	
	static DWORD ServerEventHandlerProc (DWORD someparam);

	BOOL TestWifi();
	CString sMessage;
	HWND hWnd;
	SOCKET sokClientSocket;
	SOCKET sokServer;
	CString sProtokol;
	CStringA Translate(CString sBuff);
	CString Translate(CStringA sBuff);
	CString Translate(char *sBuff, long lLength, long lStart);
	char* Translate(CString sBuff, bool bChar);

	CString sCodeString;
	int iPort;
	int iMaxCol;
	CString sIP;
	BOOL bStarted;
	BOOL SendAutorization(CString sName,CString Password);
	int SendBCAutorization(CString sName);
	BOOL SelectZone(int iUser,int iZone);
	CString SelectTask(int iUser,int iTask, int iZone, CStringArray* stArray, int iTaskZone);
	BOOL GetCloseBarCode(CString *sBarCode);
	CString SendAskDocsPos(CString sNumber);
	CString SendAskZones();
	BOOL SendSaveDocsPos(CString sValue);
	BOOL SendReadyToShipmentDoc(CString sMess);
	
protected:
	BOOL bCreateSocket;
	BOOL bInitWinSocket;
	
public:
	int AscTasc(int iUser, CString* sDocNumber, int* lZone, int* iLine, int* iTask, bool *bAssString);
	int AscZone(int iUser);
	void SendPercent(int iDoc, int iZone, int iPercent, int iTask);
	bool SendEndBox(CString sBox, int iDoc, int iZone, int Percent, int iTask);
	int SelectBox(CString sBox, int iDoc,int iRand, int iUser );
	bool SendUnlockUser(int iUser, int iDoc, CString sUserName);

	BOOL DoByArray(void);
	BOOL SelectSavePos(int iDoc, int iZone, CString* sValue,int iTask);
	BOOL PostNotFindPos(int iDoc, int iZone, int iTask);
	bool SetState(long iUser, int iState);
	long GetUserString(long iUser);
	bool GetDocPositions(int iPositions,CString *sValue);
	CString ReplaceLeftSymbol(CString  sStr);
	char* Translate(CString sBuff, CStringA sStart,CStringA sEnd);
};
