// ServerSocet.h: interface for the CServerSocet class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_SERVERSOCET_H__0FC32703_9C0E_4DA5_8FE5_7F87757ADFB2__INCLUDED_)
#define AFX_SERVERSOCET_H__0FC32703_9C0E_4DA5_8FE5_7F87757ADFB2__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

//#include "winsock.h"

//const int WINSOCK_VERSION = 0x0101;

#include "winsock2.h"
#include "afxdb.h"
#include "SocketWindow.h"
//#include "Message.h"
/*
#define PORT_ADDR 80
#define QUEUE_SIZE 250*/

typedef LPTHREAD_START_ROUTINE (*ClientTread)(LPVOID pparam);

struct stSockets
{
	SOCKET* sok;
	CDatabase* dBase;
	CString sUserIP;
	CString sDataStart;
	HANDLE hThread;
	bool bAdmin;
};




class CServerSocet  : public CMessage
{
protected:
	BOOL bStatus;
public:
	ClientTread m_ClientTread;
	CSocketWindow* SocWin;
	CString MyGetLastError();
	void SendData(LPSTR buff,int iCurr,CString* sMessage=NULL);
	BOOL ListenSocket(CString* sMessage=NULL);
	BOOL LinkWindowSocket(HWND m_hWnd,CString* sMessage=NULL);
	BOOL LinkSoketPort(CString* sMessage=NULL);
	BOOL IsSocketCreate(CString* sMessage=NULL);
	BOOL CloseSocket(CString* sMessage=NULL);
	BOOL CreateSocket(CString* sMessage=NULL);
	CString sHostName;
	BOOL SocketGetHostName(CString* sMessage=NULL);
	BOOL StopWinSock(CString* sMessage=NULL);
	BOOL IsStartWSA(CString* sMessage=NULL);
	BOOL StartServer(CString* sError=NULL);
	BOOL StartWinSock(CString* sMessage=NULL);
	void AddClient(LPARAM lParam);
	CServerSocet();
	virtual ~CServerSocet();

	HWND hWnd;
	SOCKET sokServerSocket;
	stSockets** sokClientSocket;
	CStringA Translate(CString sBuff);
	CString Translate(CStringA sBuff);
	char* Translate(CString sBuff, bool bChar);
	CString Translate(char *sBuff, long lLength, long lStart);
	CString sCodeString;

	CString sProtokol;
	int iPort;
	int iMaxCol;
	
protected:
	BOOL bCreateSocket;
	BOOL bInitWinSocket;
	
	
/*private:
	SOCKET sokServerSocket;
	SOCKET sokClientSocket;*/
public:
	BOOL GetState(void);
};


struct CurrSocet
{
	int CurrPos;
	CServerSocet* sSocet;
	CDialog *dlg;
};

#endif // !defined(AFX_SERVERSOCET_H__0FC32703_9C0E_4DA5_8FE5_7F87757ADFB2__INCLUDED_)
