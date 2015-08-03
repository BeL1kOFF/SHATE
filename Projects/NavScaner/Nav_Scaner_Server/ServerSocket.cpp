// ServerSocet.cpp: implementation of the CServerSocet class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "ServerSocket.h"



#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CServerSocet::CServerSocet()
{
	SocWin = NULL;
	hWnd = NULL;
	bStatus = FALSE;
	bInitWinSocket = FALSE;
	bCreateSocket = FALSE;
	sokClientSocket = NULL;
	sCodeString ="";
	int i;
	for(i=_T('А');i<=_T('Я');i++)
		{
			wchar_t wchar;	
			wchar = i;
			sCodeString =sCodeString + wchar;
		}
	for(i=_T('а');i<=_T('я');i++)
		{
			wchar_t wchar;	
			wchar = i;
			sCodeString =sCodeString + wchar;
		}
	for(i=_T('A');i<=_T('Z');i++)
		{
			wchar_t wchar;	
			wchar = i;
			sCodeString =sCodeString + wchar;
		}
	for(i=_T('a');i<=_T('z');i++)
		{
			wchar_t wchar;	
			wchar = i;
			sCodeString =sCodeString + wchar;
		}
	for(i=_T('0');i<=_T('9');i++)
		{
			wchar_t wchar;	
			wchar = i;
			sCodeString =sCodeString + wchar;
		}
	
	wchar_t wchar;	
	wchar = _T(' ');
	sCodeString =sCodeString + wchar;
	wchar = _T('!');
	sCodeString =sCodeString + wchar;
	wchar = _T('?');
	sCodeString =sCodeString + wchar;
	wchar = _T('.');
	sCodeString =sCodeString + wchar;
	wchar = _T('-');
	sCodeString =sCodeString + wchar;
	wchar = _T('+');
	sCodeString =sCodeString + wchar;
	wchar = _T('_');
	sCodeString =sCodeString + wchar;
	wchar = _T('*');
	sCodeString =sCodeString + wchar;
	wchar = _T('/');
	sCodeString =sCodeString + wchar;
	wchar = _T('\n');
	sCodeString =sCodeString + wchar;
	wchar = _T('|');
	sCodeString =sCodeString + wchar;
	wchar = _T(')');
	sCodeString =sCodeString + wchar;
	wchar = _T('(');
	sCodeString =sCodeString + wchar;
	wchar = _T(',');
	sCodeString =sCodeString + wchar;
	wchar = _T('&');
	sCodeString =sCodeString + wchar;
	wchar = _T('=');
	sCodeString =sCodeString + wchar;
}

CServerSocet::~CServerSocet()
{
	CloseSocket(NULL);
	StopWinSock(NULL);
}


CString CServerSocet::Translate(char *sBuff, long lLength, long lStart)
{
	CString Res;
	Res = "";
	int i;
	char ch;
	CString sVal;
	for(i=lStart;i<lLength;i++)
	{
		ch = sBuff[i];
		sVal.Format(_T("%d"),ch);
		if(ch>0)
		{
			if(ch < sCodeString.GetLength())
				Res = Res + sCodeString[ch-1];
		}
		else
			if(ch+256 < sCodeString.GetLength())
				Res = Res + sCodeString[ch+255];
	}
	return Res;
}

char* CServerSocet::Translate(CString sBuff, bool bChar)
{
	char ch;
	
	char *chBuff;
	chBuff = new char[sBuff.GetLength()];
	int i;
	for(i=0;i<sBuff.GetLength();i++)
	{
		ch = sCodeString.Find(sBuff[i]-1,0); 
		chBuff[i] = ch;
	}
	return chBuff;
}

CStringA CServerSocet::Translate(CString sBuff)
{
	CStringA Res;
	Res = "";
	int i;
	//sCodeString
	char ch;
	for(i=0;i<sBuff.GetLength();i++)
	{
		if(sBuff[i] == _T('и'))
		{
			ch = 0;
		}
		
		ch = sCodeString.Find(sBuff[i],0); 
		ch++;
		Res =Res+ch;
	}
	return Res;
}

CString CServerSocet::Translate(CStringA sBuff)
{
	CString Res;
	Res = "";
	int i,j;
	char ch;
	for(i=0;i<sBuff.GetLength();i++)
	{
		ch = sBuff[i];
		if (ch < 1)
			j = ch +255;
		else
			j = ch-1;	
		if(j < sCodeString.GetLength())
			Res = Res + sCodeString[j];
	}
	return Res;
}


BOOL CServerSocet::StartWinSock(CString* sMessage)
{
	bInitWinSocket = FALSE;
	WSADATA wsaData;
	if(sMessage != NULL)
		*sMessage = *sMessage + _T("Инициализация WSA\t ");
	
	if(!bInitWinSocket)
		if (WSAStartup(WINSOCK_VERSION, &wsaData)) 
		{
			if(sMessage != NULL)
			{
				*sMessage = *sMessage + _T("невыполнено\n");
				*sMessage = *sMessage + MyGetLastError();
			}
			WSACleanup();
			return FALSE;
		}
	if(sMessage != NULL)
	{
		*sMessage = *sMessage + _T("\tвыполненно\n");
	}
	bInitWinSocket = TRUE;
	return TRUE;
}

BOOL CServerSocet::StartServer(CString* sError)
{

	if(bCreateSocket)
		CloseSocket(sError);
	
	if(!bInitWinSocket)
		if (!StartWinSock(sError)) return FALSE;
	if (!SocketGetHostName(sError)) return FALSE;
	if (!CreateSocket(sError)) return FALSE;
	if (!LinkSoketPort(sError)) return FALSE;
	if (!LinkWindowSocket(hWnd,sError)) return FALSE;
	if (!ListenSocket(sError)) return FALSE;

	sokClientSocket = new stSockets *[iMaxCol];
	int i;
	for(i=0;i<iMaxCol;i++)
	{
		sokClientSocket[i] = new (stSockets);
		sokClientSocket[i]->dBase = NULL;
		sokClientSocket[i]->sUserIP = _T("");
		sokClientSocket[i]->bAdmin = FALSE;
		sokClientSocket[i]->sDataStart = _T("");
		sokClientSocket[i]->sok = NULL;
		sokClientSocket[i]->hThread = 0;
	}	
	bStatus = TRUE;
	return TRUE;
}

BOOL CServerSocet::IsStartWSA(CString* sMessage)
{
	return bInitWinSocket;
}

BOOL CServerSocet::StopWinSock(CString* sMessage)
{
	if(bInitWinSocket)
		{
			bInitWinSocket = FALSE;
			if (WSACleanup())
				{
					return FALSE;					
				}
			else
				{
					return TRUE;					
				}

		}
	return TRUE;
}

BOOL CServerSocet::SocketGetHostName(CString* sMessage)
{
	sHostName = "";
	if(sMessage != NULL)
		*sMessage = *sMessage + _T("Получение имени хоста\t");
	if(!bInitWinSocket) return FALSE;
	char chInfo[64];
	if (gethostname(chInfo,sizeof(chInfo)))
	{
		if(sMessage != NULL)
		{
			*sMessage = *sMessage + _T("невыполнено\n");
			*sMessage = *sMessage + MyGetLastError();
		}
		return FALSE;
	}
	else
	{	
		sHostName.Format(_T("%S"),chInfo);
		if(sMessage != NULL)
		{
			*sMessage = *sMessage + sHostName+_T("\n");
		}
	}
	return TRUE;

}

BOOL CServerSocet::CreateSocket(CString* sMessage)
{
	if(bCreateSocket) 
		CloseSocket(NULL);
	bCreateSocket = FALSE;

	CString S;
	S.Format(_T("Создание сокета %s \t"),sProtokol);
	if(sMessage != NULL)
		*sMessage = *sMessage + S;

	sokServerSocket = socket(AF_INET,SOCK_STREAM,0);
	if (sokServerSocket==INVALID_SOCKET) 
	{
		if(sMessage != NULL)
		{
			*sMessage = *sMessage + _T(" сокет не создан\n");
			*sMessage = *sMessage + MyGetLastError();
		}
		return FALSE;	
	}
	
	bCreateSocket = TRUE;
	*sMessage = *sMessage + _T(" сокет создан\n");
	return TRUE;
}

BOOL CServerSocet::CloseSocket(CString* sMessage)
{
	if(SocWin != NULL)
	if(SocWin->m_hWnd != NULL)
		SocWin->DestroyWindow();

	if (sokClientSocket!= NULL)
	{
		int i;
		for(i=0;i<iMaxCol;i++)
		{
			if(sokClientSocket[i]!=NULL)
			{
				CDatabase* dBase;
				if(sokClientSocket[i]->dBase != NULL)
				{
					try
					{
						dBase = sokClientSocket[i]->dBase;
						if(dBase!=NULL)
						{
							if(dBase->IsOpen())
							{
								dBase->Close(); 
							}
							
						}
					}
					catch(...)
					{
					}
					delete(dBase);
					sokClientSocket[i]->dBase = NULL;
				}
				if(sokClientSocket[i]->hThread != NULL)
				{
					TerminateThread(sokClientSocket[i]->hThread,0);
				}
				sokClientSocket[i]->hThread = NULL;
				delete(sokClientSocket[i]);
				sokClientSocket[i] = NULL;
				}
			}
			delete(sokClientSocket);
			sokClientSocket = NULL;
		}
	
	CString S;
	S.Format(_T("Закрытие сокета"));
	if(sMessage != NULL)
	{
		*sMessage = *sMessage + S;
	}
	if(bCreateSocket)
		closesocket(sokServerSocket);
	bCreateSocket = FALSE;
	if(sMessage != NULL)
		*sMessage = *sMessage + _T("\tвыполненно\n");
	bStatus = FALSE;
	return TRUE;
}

BOOL CServerSocet::IsSocketCreate(CString* sMessage)
{
	return bCreateSocket;
}

BOOL CServerSocet::LinkSoketPort(CString* sMessage)
{
	if(!bCreateSocket) return FALSE;
	SOCKADDR_IN socketaddr;
	socketaddr.sin_family = AF_INET;
	socketaddr.sin_addr.s_addr  = INADDR_ANY; 
	socketaddr.sin_port = htons(iPort);
	CString S;
	S.Format(_T("Связываем сокет с портом %d"),iPort);
	if(sMessage != NULL)
		*sMessage = *sMessage + S;
	if (bind(sokServerSocket,(LPSOCKADDR)&socketaddr,sizeof(socketaddr)) == SOCKET_ERROR)
	{
		if(sMessage != NULL)
		{
			*sMessage = *sMessage + _T("\tневыполненно\n");
			*sMessage = *sMessage + MyGetLastError();
		}
		return FALSE;
	}
	if(sMessage != NULL)
		*sMessage = *sMessage + _T("\tвыполненно\n");

	return TRUE;
}

BOOL CServerSocet::LinkWindowSocket(HWND m_hWnd,CString* sMessage)
{
	CString S;
	if(!bCreateSocket) return FALSE;
	
	CWnd win;
	win.SubclassWindow(m_hWnd);
	m_hWnd = GetConsoleWindow();
	SocWin = new(CSocketWindow);
	S.Format(_T("Создание окна"));
	if(sMessage != NULL)
		*sMessage = *sMessage + S;
	if(!SocWin->Create(101))
	{
		if(sMessage != NULL)
		{
			*sMessage = *sMessage + _T("\tневыполненно\n");
			*sMessage = *sMessage + MyGetLastError();
		}
		return FALSE;
	}	
	SocWin->SetFunction(this);
	if(sMessage != NULL)
		*sMessage = *sMessage + _T("\tвыполненно\n");

	int Errors;
	
	S.Format(_T("Связываем сокет с окном "));
	if(sMessage != NULL)
		*sMessage = *sMessage + S;
	Errors=WSAAsyncSelect(sokServerSocket,SocWin->m_hWnd,WM_SERVER_ACCEPT,FD_ACCEPT|FD_READ);
	if (Errors == SOCKET_ERROR)
	{
		if(sMessage != NULL)
		{
			*sMessage = *sMessage + _T("\tневыполненно\n");
			*sMessage = *sMessage + MyGetLastError();
		}
		return FALSE;
	}
	if(sMessage != NULL)
		*sMessage = *sMessage + _T("\tвыполненно\n");	
	
	*sMessage = *sMessage + _T("Установка HOOK");	
	if(sMessage != NULL)
		*sMessage = *sMessage + _T("\tвыполненно\n");
	//SendMessage(SocWin->m_hWnd ,WM_SERVER_ACCEPT,0,0);	
	//SocWin->ShowWindow(1);
	return TRUE;
}

BOOL CServerSocet::ListenSocket(CString* sMessage)
{
	if(!bCreateSocket) return FALSE;
	int Errors;
	CString S;
	S.Format(_T("Устанавлеваем кол-во подключений\t %d "),iMaxCol);
	if(sMessage != NULL)
		*sMessage = *sMessage + S;

	Errors=listen(sokServerSocket,iMaxCol+10);
	if ( Errors == SOCKET_ERROR)
	{
		if(sMessage != NULL)
		{
			*sMessage = *sMessage + _T("невыполненно\n");
			*sMessage = *sMessage + MyGetLastError();
		}
		return FALSE;
	}
		if(sMessage != NULL)
		{
			*sMessage = *sMessage + _T("выполненно\n");
		}
	return TRUE;
}

void CServerSocet::SendData(LPSTR buff, int iCurr,CString* sMessage)
{
	CString S;
	S.Format(_T("Передача данных"));
	if(sMessage != NULL)
		*sMessage = *sMessage + S;
	int Errors;
	Errors = send(*sokClientSocket[iCurr]->sok,(LPSTR)buff,lstrlenA(buff),0);
	if (Errors == SOCKET_ERROR) 
		{
			if(sMessage != NULL)
			{
				*sMessage = *sMessage + _T("\tневыполненно\n");
				*sMessage = *sMessage + MyGetLastError();
			}
		return;
		}
	if(sMessage != NULL)
		*sMessage = *sMessage + _T("\tвыполненно\n");
}

CString CServerSocet::MyGetLastError()
{
	DWORD dError;
	dError = GetLastError();
	void* cstr;
	FormatMessageA(
		FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
		NULL,
		dError,
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
		(LPSTR) &cstr,
		0,
		NULL
		);
	CString res((char*)cstr);
	res = ReplaceLeftSymbols(res, TRUE);
	LocalFree(cstr);
	CString sRet;
	sRet.Format(_T("ERROR\t%d %s\n"),dError,res);
	return sRet;
}

BOOL CServerSocet::GetState(void)
{
	return bStatus;
}


void CServerSocet::AddClient(LPARAM lParam)
{
	try
	{
		if (sokClientSocket == NULL)
		{
			WriteToLog(_T("Не инициализированы клиенты"));
			return;
		}

		int i;
		i=0;
	
		while (sokClientSocket[i]!=NULL)
		{
			if(sokClientSocket[i]->sUserIP != _T(""))
				i++;
			else
				break;
		}

		if (i >= iMaxCol)
		{
			WriteToLog(_T("Привышенно колличество клиентов!"));
			return;	
		}

		
		
		if (WSAGETASYNCERROR(lParam))
		{
			return;
		}

		if (WSAGETSELECTEVENT(lParam) == FD_ACCEPT)
		{
			int length=sizeof(SOCKADDR);
			SOCKADDR_IN socketclientaddr;	

			if(sokClientSocket[i]->sok == NULL)
			{
				sokClientSocket[i]->sok = new SOCKET;
			}
			*sokClientSocket[i]->sok=accept(sokServerSocket,(LPSOCKADDR)&socketclientaddr, (LPINT) &length);
			socketclientaddr.sin_addr;
		
			CString sIP;
			sIP=inet_ntoa(socketclientaddr.sin_addr);
			int j=0;
			while(iMaxCol>j)
			{
				if(sokClientSocket[j]->sUserIP == sIP)
				{
					if(sokClientSocket[j]->dBase != NULL)
					{
						if(sokClientSocket[j]->dBase->IsOpen())
							sokClientSocket[j]->dBase->Close();
						delete(sokClientSocket[j]->dBase);
						sokClientSocket[j]->dBase = NULL;
					}

					if(sokClientSocket[j]->hThread != 0)
					{
						TerminateThread(sokClientSocket[j]->hThread,0);
					}

					if(sokClientSocket[j]->sok != NULL)
					{
						shutdown(*sokClientSocket[j]->sok, 0);
						LINGER linger = { 1, 0 };
						setsockopt(*sokClientSocket[j]->sok, SOL_SOCKET, SO_LINGER, (char*)&linger, sizeof(linger));
						closesocket(*sokClientSocket[j]->sok);
						delete(sokClientSocket[j]->sok);
						sokClientSocket[j]->sok = NULL;
					}
					sokClientSocket[j]->sUserIP = _T("");
				}
				j++;
			}

			sokClientSocket[i]->sUserIP = sIP;
			if (*sokClientSocket[i]->sok == INVALID_SOCKET)
			{
				return;
			}

			DWORD dwThreadID; 
			CurrSocet* stCurrSocet;
			stCurrSocet = new CurrSocet;
			stCurrSocet->sSocet = this;
			stCurrSocet->CurrPos = i;
			
			if(sokClientSocket[i]->dBase == NULL)
				sokClientSocket[i]->dBase = new(CDatabase);
			sokClientSocket[i]->hThread = CreateThread (NULL, NULL, (LPTHREAD_START_ROUTINE)*m_ClientTread, (void*)stCurrSocet, NULL, &dwThreadID); 
		}
	}
	catch(CException *except)
	{
		CString sError;
		except->GetErrorMessage((LPTSTR)&sError,255,0);
		except->Delete();
		WriteToLog(sError);
	}
}
