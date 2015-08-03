#include "StdAfx.h"
#include "ClientSocket.h"

bool bWork;
SOCKET ServerSocket;
HANDLE hSocketEvent;

BOOL CClientSocket::TestWifi()
{
	#ifdef _DEBUG
		return TRUE;
	#endif
	BOOL pStatus;
	pStatus = TRUE;
	BOOL bRet;
	bRet = DLASSOCIATION_GetStatus(&pStatus);
	int i = 50;
	while(!bRet)
	{		
		bRet = DLASSOCIATION_GetStatus(&pStatus);
		if(i<1)
			break;
		i--;
	}

	if(!bRet)
	{
		pStatus = FALSE;
	}
	
	//return TRUE;
	return pStatus;
}

DWORD CClientSocket::ServerEventHandlerProc (DWORD someparam)
{
	bWork = TRUE;
	WSANETWORKEVENTS NetworkEvents;
	hSocketEvent = WSACreateEvent();
	SOCKET sok;
	sok = ServerSocket;
	//WSAEventSelect(sok, hSocketEvent, FD_CLOSE|FD_CONNECT|FD_READ|FD_WRITE);
	BOOL bSend;
	bSend = FALSE;
	CString sValue;
	CClientSocket * thisSocket = (CClientSocket *)someparam;
	while (true) 
		{   
				WaitForSingleObject (hSocketEvent, INFINITE);
				WSAEnumNetworkEvents(sok, hSocketEvent, &NetworkEvents);
				if(NetworkEvents.lNetworkEvents == FD_CLOSE)
				{
					break;
				}
			
				if(NetworkEvents.lNetworkEvents == FD_READ)
					{
						if(!bWork)
						{
							continue;
						}
					/*if(!TestWifi())
						continue;*/
					char gettext[19];
					recv(sok,gettext,19,0);
					CStringA saValue;
					saValue.Format("%s",gettext);
					/*if (saValue.Left(5) != "MESS_")
					{
						continue;
					}
					sValue = saValue;
					if(sValue.GetLength()<1)
						continue;
					AfxMessageBox(sValue,MB_OK,0);*/
					}
					
				

		}		
	return 0l;
}


CClientSocket::CClientSocket(void)
{
	bCreateSocket = FALSE;
	bInitWinSocket = FALSE;	
	sCodeString ="";
	bStarted = FALSE;
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
	hThread =0;
	hThreadWiFi = 0;
}

CClientSocket::~CClientSocket(void)
{
	if(hThreadWiFi)
		{
			TerminateThread(hThreadWiFi,0);
		}
	CloseSocket();
	StopWinSock();
	
}

BOOL CClientSocket::StartWinSock()
{
	StopWinSock();
	bInitWinSocket = FALSE;
	WSADATA wsaData;
	sMessage = sMessage + _T("Инициализация WSA: ");
	if(!bInitWinSocket)
		if (WSAStartup(WINSOCK_VERSION, &wsaData)) 
		{
			sMessage = sMessage + _T("невыполнено\n");
			sMessage = sMessage + MyGetLastError();
			WSACleanup();
			return FALSE;
		}
	sMessage = sMessage + _T(" выполненно\n");
	bInitWinSocket = TRUE;
	return TRUE;
}

BOOL CClientSocket::StartServer()
{
	sMessage = "";
	if(!TestWifi())
	{
		sMessage = _T("WiFi - недоступен");
		return FALSE;
	}
	sMessage = _T("");
	if(bCreateSocket)
		CloseSocket();
	if(!bInitWinSocket)
		if (!StartWinSock()) return FALSE;
	if (!SocketGetHostName()) return FALSE;
	if (!CreateSocket()) return FALSE;
	if (!LinkSoketPort()) return FALSE;
	if (!LinkWindowSocket(hWnd)) return FALSE;
	if (!ListenSocket()) return FALSE;

	ULONG val = TRUE;
	if(SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		sMessage = sError;
		CloseSocket();
		return FALSE;
	}
	bStarted = TRUE;
	return TRUE;
}

BOOL CClientSocket::IsStartWSA()
{
	return bInitWinSocket;
}

BOOL CClientSocket::StopWinSock()
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

BOOL CClientSocket::SocketGetHostName()
{
	sHostName = "";
	sMessage = sMessage + _T("Получение имени хоста: ");
	if(!bInitWinSocket) return FALSE;
	char chInfo[64];
	if (gethostname(chInfo,sizeof(chInfo)))
	{
		sMessage = sMessage + _T("невыполнено\n");
		sMessage = sMessage + MyGetLastError();
		return FALSE;
	}
	else
	{	
		sHostName.Format(_T("%s"),chInfo);
		sMessage = sMessage + sHostName+_T("\n");
	}
	return TRUE;

}

BOOL CClientSocket::CreateSocket()
{
	if(bCreateSocket) 
		CloseSocket();
	bCreateSocket = FALSE;
	
	CString S;
	S.Format(_T("Создание сокета %s "),sProtokol);
	sMessage = sMessage + S;
	//pr = getprotobyname(_T("TCP"));
	//if(pr!=NULL)
		{
		sokClientSocket = socket(AF_INET,SOCK_STREAM,0);
		if (sokClientSocket==INVALID_SOCKET) 
			{
			sMessage = sMessage + _T(" сокет не создан\n");
			sMessage = sMessage + MyGetLastError();
			return FALSE;	
			}
		}
	/*else
		{
			sMessage = sMessage + _T(" сокет не создан\n");
			sMessage = sMessage + MyGetLastError();
			return FALSE;
		}
	*/
	bCreateSocket = TRUE;
	sMessage = sMessage + _T(" сокет создан\n");
	return TRUE;
}

BOOL CClientSocket::CloseSocket()
{
	if(hThread)
		{
			TerminateThread(hThread,0);
		}
	hThread = 0;
	bStarted = FALSE;
	CString S;
	S.Format(_T("Закрытие сокета"));
	sMessage = sMessage + S;
	if(bCreateSocket)
	{
		shutdown(sokClientSocket, /*SD_BOTH*/0);
		LINGER linger = { 1, 0 };
		setsockopt(sokClientSocket, SOL_SOCKET, SO_LINGER, (char*)&linger, sizeof(linger));
        closesocket(sokClientSocket);
	}
	bCreateSocket = FALSE;
	sokClientSocket = INVALID_SOCKET;
	StopWinSock();
	sMessage = sMessage + _T(" выполненно\n");
	return TRUE;
}

BOOL CClientSocket::IsSocketCreate()
{
	return bCreateSocket;
}

BOOL CClientSocket::LinkSoketPort()
{
	if(!bCreateSocket) return FALSE;
	SOCKADDR_IN socketaddr;
	socketaddr.sin_family = AF_INET;
	socketaddr.sin_addr.s_addr  = INADDR_ANY; 
	socketaddr.sin_port = iPort;
	CString S;
	S.Format(_T("Связываем сокет с портом %d"),iPort);
	sMessage = S;
	if (bind(sokClientSocket,(LPSOCKADDR)&socketaddr,sizeof(socketaddr)) == SOCKET_ERROR)
	{
		sMessage = sMessage+ _T("невыполненно\n");
		sMessage = sMessage + MyGetLastError();
		return FALSE;
	}
	sMessage = sMessage + _T(" выполненно\n");
	return TRUE;
}

BOOL CClientSocket::LinkWindowSocket(HWND m_hWnd)
{
	CString S;
	S.Format(_T("Подключение к серверу: '%s'"),sIP);
	sMessage = S;
	
	struct hostent *hp;
	struct sockaddr_in srv_sin;  
	hp = gethostbyname(CT2A(sHostName));
	srv_sin.sin_family = AF_INET; 
	srv_sin.sin_addr.s_addr = inet_addr(CT2A(sIP));
	srv_sin.sin_port = htons(iPort);
	sokServer = connect(sokClientSocket,(LPSOCKADDR)&srv_sin, sizeof(srv_sin));
	if(sokServer == SOCKET_ERROR)
		{
			/*
			sMessage = sMessage + _T(" невыполненно\n");
			sMessage = sMessage + MyGetLastError();
			*/
			sMessage =  sMessage+_T(" невыполненно\n");
			sMessage = sMessage + MyGetLastError();
			return FALSE;
		}
	sMessage = sMessage + _T(" выполненно\n");
	
	S.Format(_T("Привязывание к окну: ''"));
	sMessage = sMessage + S;

	ServerSocket = sokClientSocket;
//	hThread = CreateThread (NULL, NULL, (LPTHREAD_START_ROUTINE)ServerEventHandlerProc, this, NULL, &dwThreadID);

	/*Errors=WSASelect(sokClientSocket,m_hWnd,WM_SERVER_ACCEPT,FD_READ);
	//,WM_ASYNC,FD_READ);
	if (Errors == SOCKET_ERROR)
	{
		sMessage = sMessage + _T(" невыполненно\n");
		sMessage = sMessage + MyGetLastError();
		return FALSE;
	}*/
	sMessage = sMessage + _T(" выполненно\n");	
	return TRUE;

}

BOOL CClientSocket::ListenSocket()
{
	return TRUE;
}

//SaveFile
BOOL CClientSocket::SaveFile(CStringA buff, CString sNewName, int iTimeOut)
{
	CFile mFile;
	CFileException exp;
	if(!mFile.Open(sNewName,CFile::modeCreate|CFile::modeWrite,&exp))
	{
		return FALSE;
	}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				mFile.Close();
				return FALSE;
			}
	}

	if(!TestWifi())
	{
		mFile.Close();
		return FALSE;
	}

	int Errors;
	char* chr;
	chr = new char[101];

	while(recv(sokClientSocket,chr,60,0)!= SOCKET_ERROR)
	{
	}
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {iTimeOut,0};
	FD_ZERO(&fdset); 
	FD_SET(sokClientSocket,&fdset);
	int iLen;
	iLen = 100;
	Errors = send(sokClientSocket,buff,buff.GetLength()+1,0);
	if (Errors==0)
	{
		delete(chr);
		CloseSocket();
		mFile.Close();
				return FALSE;
	}

	if (Errors == SOCKET_ERROR) 
	{
		delete(chr);
		CloseSocket();
		mFile.Close();
				return FALSE;
	}

	int iFileLen;
	iFileLen = -1;

	BOOL bFirst;
	bFirst = TRUE;
	
	while(true)
	{
		Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv);
		if (Errors==0)
		{
			delete(chr);
			CloseSocket();
			mFile.Close();
				return FALSE;
		}

		if (Errors == SOCKET_ERROR) 
		{
			delete(chr);
			CloseSocket();
			mFile.Close();
			
				return FALSE;
		}
		
		
		Errors= recv(sokClientSocket, chr,iLen, 0);
		
		if (Errors==0)
		{
			delete(chr);
			CloseSocket();
			mFile.Close();
				return FALSE;
		}

		if (Errors == SOCKET_ERROR) 
		{
			delete(chr);
			CloseSocket();
			mFile.Close();
				mFile.Close();
				return FALSE;
		}
		
		if(iFileLen <= 0)
		{
			if(bFirst)
			{
				CStringA sVal = chr;
				int iFind;
				iFind = sVal.Find("_");
				bFirst = FALSE;
				
				if(iFind>0)
				{
					iFileLen = atoi(sVal.Left(iFind));
					iFind++;
					iFind++;
					for(iFind;iFind<Errors;iFind++)
					{
						mFile.Write(&chr[iFind],1);
						iFileLen--;
					}
				}
				Sleep(100);
			}
			else
			{
				break;
			}
		}
		else
		{
			mFile.Write(chr,Errors);
			iFileLen = iFileLen - Errors;
		}
		
		if(iFileLen < 1)
			break;
		
			
		
	}
	mFile.Close();
	return TRUE;
}
CStringA CClientSocket::SendData(CString sMess, CStringA sHead,int iTimeOut)
{
	CStringA sRet;
	sRet = _T("");
	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				CloseSocket();
				return Translate(_T("Подключение не выполненно проверте настройки!"));
			}
	}

	if(!TestWifi())
	{
		return Translate(_T("Wifi - не доступен!"));
	}

	int Errors;
	char* chr;
	chr = new char[101];

	int iRead;
	int iCicle;
	iCicle = 0;
	while((iRead = recv(sokClientSocket,chr,60,0))!= SOCKET_ERROR)
	{
		if(iRead == 0)
		{
			iCicle++;
		}
		else
		{
			iCicle = 0;
		}
		if(iCicle == 20)
			break;
	}
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {iTimeOut,0};
	FD_ZERO(&fdset); 
	FD_SET(sokClientSocket,&fdset);
	int iLen;
	iLen = 100;
	CStringA bf;
	Errors = 0;
	//Translate(sMess)
	bf = sHead+"_";
	while(sMess.GetLength()>0)
	{
		bf = bf + Translate(sMess.Left(1000));
		sMess = sMess.Right(sMess.GetLength()-1000);
		if(sMess.GetLength()<1)
		{
			bf = bf + "_"+sHead;
			Errors = send(sokClientSocket,bf,bf.GetLength()+1,0);
		}
		
		
	}

	if (Errors==0)
	{
		delete(chr);
		CloseSocket();
		return Translate(_T("Timeout!"));
	}

	if (Errors == SOCKET_ERROR) 
	{
		delete(chr);
		CloseSocket();
		return Translate(_T("Ошибка соединения!"));
	}

	
	while(true)
	{
		Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv);
		if (Errors==0)
		{
			delete(chr);
			CloseSocket();
			return Translate(_T("Таймаут ответа!"));
		}

		if (Errors == SOCKET_ERROR) 
		{
			delete(chr);
			CloseSocket();
			return Translate(_T("нет ответа!"));
		}
		
		
		Errors= recv(sokClientSocket, chr,iLen, 0);
		chr[iLen] = '\0';
		if (Errors==0)
		{
			delete(chr);
			CloseSocket();
			return Translate(_T("Таймаут ответа!"));
		}

		if (Errors == SOCKET_ERROR) 
		{
			delete(chr);
			CloseSocket();
			return Translate(_T("нет ответа!"));
		}
		sRet = sRet +chr;
		if(sRet.Left(5) != sHead+"_")
			return Translate(_T("Ошибка пакета"));

		if(sRet.Right(5)=="_"+sHead)
			break;
		Sleep(10);
	}
	return sRet;

}

CStringA CClientSocket::SendData(CStringA buff,int iTimeOut, int iSendLen)
{
	CStringA sRet;
	sRet = _T("");
	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				CloseSocket();
				return Translate(_T("Подключение не выполненно проверте настройки!"));
			}
	}

	if(!TestWifi())
	{
		return Translate(_T("Wifi - не доступен!"));
	}

	int Errors;
	char* chr;
	chr = new char[101];

	int iRead;
	int iCicle;
	iCicle = 0;
	while((iRead = recv(sokClientSocket,chr,60,0))!= SOCKET_ERROR)
	{
		if(iRead == 0)
		{
			iCicle++;
		}
		else
		{
			iCicle = 0;
		}
		if(iCicle == 20)
			break;
	}
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {iTimeOut,0};
	FD_ZERO(&fdset); 
	FD_SET(sokClientSocket,&fdset);
	int iLen;
	iLen = 100;
	CStringA bf;
	bf = buff;
	Errors = 0;
	if(iSendLen < 1)
		Errors = send(sokClientSocket,buff,buff.GetLength()+1,0);
	else
		Errors = send(sokClientSocket,buff,iSendLen+1,0);

	if (Errors==0)
	{
		delete(chr);
		CloseSocket();
		return Translate(_T("Timeout!"));
	}

	if (Errors == SOCKET_ERROR) 
	{
		delete(chr);
		CloseSocket();
		return Translate(_T("Ошибка соединения!"));
	}

	
	while(true)
	{
		Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv);
		if (Errors==0)
		{
			delete(chr);
			CloseSocket();
			return Translate(_T("Таймаут ответа!"));
		}

		if (Errors == SOCKET_ERROR) 
		{
			delete(chr);
			CloseSocket();
			return Translate(_T("нет ответа!"));
		}
		
		
		Errors= recv(sokClientSocket, chr,iLen, 0);
		chr[iLen] = '\0';
		if (Errors==0)
		{
			delete(chr);
			CloseSocket();
			return Translate(_T("Таймаут ответа!"));
		}

		if (Errors == SOCKET_ERROR) 
		{
			delete(chr);
			CloseSocket();
			return Translate(_T("нет ответа!"));
		}
		sRet = sRet +chr;
		if(sRet.Left(5) != buff.Left(5))
			return Translate(_T("Ошибка пакета"));

		if(sRet.Right(5)==buff.Right(5))
			break;
		Sleep(10);
	}
	return sRet;
}

CStringA CClientSocket::Translate(CString sBuff)
{

	CStringA Res;
	Res = "";
	int i,j;
	//sCodeString
	char ch;
	for(i=0;i<sBuff.GetLength();i++)
	{
		j = sCodeString.Find(sBuff[i],0)+1; 
		if (j > 0)
		{
			ch = j;
			Res =Res+ ch;
		}
		else
		{
			AfxMessageBox(sBuff[i]);
		}
	}
	return Res;
}

CString CClientSocket::Translate(char *sBuff, long lLength, long lStart)
{
	CString Res;
	Res = "";
	int i;
	char ch;
	CString sVal;
	for(i=lStart;i<lLength;i++)
	{
		ch = sBuff[i];
		int j;
		j = ch;
		if(j<0)
			j = j + 256;

		j=j-1;

		if(j < sCodeString.GetLength())
				{
					Res = Res + sCodeString[j];
				}
			else
				{
					sVal.Format(_T("не найден - %d,%d"),ch,j);
				}	
	}
	
	return Res;
}

char* CClientSocket::Translate(CString sBuff, bool bChar)
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

CString CClientSocket::Translate(CStringA sBuff)
{
	CString Res;
	Res = "";
	int i;
	char ch;
	CString sVal;
	
	for(i=0;i<sBuff.GetLength();i++)
	{
		
		ch = sBuff[i];
		sVal.Format(_T("%c"),ch);
		if(sVal == ")")
		{
			sVal = ")";
		}
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

CString CClientSocket::MyGetLastError()
{
	int iCode;
	iCode = GetLastError();
	/*wchar_t* cstr;
	FormatMessage(
		FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
		NULL,
		iCode,
		MAKELANGID(LANG_RUSSIAN, SUBLANG_DEFAULT), // Default language
		cstr,
		255,
		NULL
		);
	int nSize;
	WORD dwError = GetLastError();
	CString csDescription;
	FormatMessage( FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
		NULL, iCode, MAKELANGID(LANG_NEUTRAL,SUBLANG_DEFAULT),
	csDescription.GetBuffer(255), nSize, NULL );
	csDescription.ReleaseBuffer();
	*/
	
	CString s;
	s.Format(_T("ошибка: %d"),iCode);
	//res = s;
	//LocalFree(cstr);
	return s;
}
//SendBCAutorization
BOOL CClientSocket::SelectZone(int iUser, int iZone)
{
	if(!TestWifi())
		{
			return FALSE;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return FALSE;
			}
	}

	try
	{
	bWork = FALSE;
	CStringA type;
	type.Format("SZFU_%d_%d_",iUser,iZone);
	int Errors;
	char gettext[] = "AUTR_0";
	while(recv(sokClientSocket,gettext,6,0)!= SOCKET_ERROR)
	{
	}

	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return FALSE;
		}
	
	ULONG val = TRUE;
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {5,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset); // выставляем сокеты в дескриптор
	
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return FALSE;
		}

		Errors = recv(sokClientSocket,gettext,25,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
		if (gettext[5]=='0')
		{
			bWork = TRUE;
			return FALSE;
		}
		else
		{
			bWork = TRUE;
			return TRUE;
		}
	bWork = TRUE;
	return FALSE;
	}
	catch(...)
	{
		bWork = TRUE;
		return FALSE;
	}
}

int CClientSocket::SendBCAutorization(CString sName)
{
	if(!TestWifi())
		{
			return FALSE;
		}
	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return FALSE;
			}
	}
	bWork = FALSE;
	CStringA buf, type;
	buf = Translate(sName);
	type.Format("AUTB_%s",buf);
	int Errors;
	char getext[100];
	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return FALSE;
	}	
	while(recv(sokClientSocket,getext,100,0)!= SOCKET_ERROR)
	{
	}
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		bWork = TRUE;
		CloseSocket();
		return 0;
		}

	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {40,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset); // выставляем сокеты в дескриптор
	char gettext[100];
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return 0;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		return 0;
		}

		Errors = recv(sokClientSocket,gettext,25,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
		return 0;
		}
		
		type.Format("%s",gettext);
		if(type.Left(5)!="AUTB_")
		{
			bWork = TRUE;
			return 0;
		}

		type.Format("%s",gettext);
		type = type.Right(type.GetLength()-5);
		if(type.Find("_")<1)
			return 0;
		type = type.Left(type.Find("_"));
		bWork = TRUE;
		return atoi(type);
}

BOOL CClientSocket::SendAutorization(CString sName,CString Password)
{

	if(!TestWifi())
		{
			return FALSE;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return FALSE;
			}
	}

	bWork = FALSE;
	
	CStringA buf, type;
	buf = Translate(sName+_T("_")+Password);
	type.Format("AUTR_%s",buf);
	int Errors;
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return FALSE;
		}
	
	ULONG val = TRUE;
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {3,0}; // 0 секунд, 0 микросекунд
	/*
		FD_ZERO(&FdSet);
        FD_SET(sock, &FdSet);
         rc = select(sock+1, NULL, &FdSet, NULL, &Time);
 
                                    if (rc == 0) return NULL; // timeout!
                                    if (rc == -1) return NULL; // error
 
	*/

	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset); // выставляем сокеты в дескриптор
	char gettext[] = "AUTR_0";
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
			return FALSE;
		}
		Errors = recv(sokClientSocket,gettext,6,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
		bWork = TRUE;
			return FALSE;
		}
		if (gettext[5]=='1')
		{
			bWork = TRUE;
			return TRUE;
		}
		else
		{
			bWork = TRUE;
			return FALSE;
		}
	bWork = TRUE;
	return FALSE;
	
}


BOOL CClientSocket::SendSaveDocsPos(CString sValue)
{
	if(!TestWifi())
		{
			return FALSE;
		}
	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return FALSE;
			}
	}
	bWork = FALSE;
	CStringA type;
	type.Format("SDOC_%d_",sValue.GetLength());
	int Errors;
	char gettext[100];
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}

	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {10,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);
	
	while(sValue.GetLength()>100)
		{
			char *ch;
			ch = Translate(sValue.Left(100), TRUE);
			send(sokClientSocket,ch,101,0);
			sValue = sValue.Right(sValue.GetLength()-100);
			delete(ch);
		}

		if(sValue.GetLength()>0)
		{
			char *ch;
			ch = Translate(sValue, TRUE);
			send(sokClientSocket,ch,sValue.GetLength()+1,0);
			delete(ch);
		}	

		Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv);
		if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}

		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
				int res = WSAGetLastError ();
						sError.Format(_T("recv - %d"),res);
						AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
		bWork = TRUE;
			return FALSE;
		}
		
		char ch[6];
		recv(sokClientSocket,ch,6,0);
		if(ch[5]!='1')
		{
			bWork = TRUE;
			return FALSE;
		}
		
	bWork = TRUE;
	return TRUE;
}


bool CClientSocket::GetDocPositions(int iPositions,CString *sValue)
{
	if(!TestWifi())
	{
		return FALSE;
	}

	CStringA type;
	int iPos;
	iPos = 0;
	
	//char chr[0];
	int Errors;
	char* chr;
	chr = new char[60];
	while(recv(sokClientSocket,chr,60,0)!= SOCKET_ERROR)
	{
	}
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {1,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);

	int iLen = 70;
	CStringA StrA;
	while(iPos < iPositions)
	{
		type.Format("GDOP_%d_",iPos); //GetDocPositions
		Errors = send(sokClientSocket,type,type.GetLength()+1,0);
		Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv);
		type.Format("GDOP_%d_",iPos+1);
		iLen = 50 + type.GetLength()*2;
		chr = new char[iLen];
		if (Errors==0)
		{
			delete(chr);
			CloseSocket();
			return FALSE;
		}

		if (Errors == SOCKET_ERROR) 
		{
			delete(chr);
			CloseSocket();
			return FALSE;
		}
		
		Errors= recv(sokClientSocket, chr,iLen, 0);
		if (Errors==0)
		{
			delete(chr);
			CloseSocket();
			return FALSE;
		}

		if (Errors == SOCKET_ERROR) 
		{
			delete(chr);
			CloseSocket();
			return FALSE;
		}

		StrA.Format("%s", chr);
		if(StrA.Left(7)=="GDOP_0_")
		{
			delete(chr);
			CloseSocket();
			return FALSE;
		}

		if(StrA.Left(5)!="GDOP_")
		{
			delete(chr);
			CloseSocket();
			return FALSE;
		}
		//
		if(type == StrA.Left(type.GetLength()))
		{
			//int iFind;
			StrA = StrA.Right(StrA.GetLength()-type.GetLength());
			
			//Проверка пакета
			//57 - размер пакета + GDOP__ + завершающий символ пакета
			

			if(type == StrA.Right(type.GetLength()))
			{
				StrA = StrA.Left(StrA.GetLength()-type.GetLength());
				if(StrA.GetLength()==50)
				{
					CString str;
					str = Translate(chr,50+type.GetLength(),type.GetLength());
					*sValue = *sValue + str;
					iPos++;
				}
			}
			
		}
		else
		{
			delete(chr);
			return FALSE;
		}

		while(recv(sokClientSocket,chr,iLen,0)!= SOCKET_ERROR)
		{

		}
		delete(chr);
	}
	return TRUE;
}



CString CClientSocket::SendAskZones()
{
	CString sValue;
	if(!TestWifi())
		{
			return sValue;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return sValue;
			}
	}
	bWork = FALSE;
	
	CStringA saValue;
	CStringA type;
	type.Format("GALZ_");
	int Errors;
	char gettext[100];
	ULONG val = TRUE;
	sValue = _T("");
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return sValue;
	}					
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {10,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return sValue;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return sValue;
		}
		Errors = recv(sokClientSocket,gettext,100,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return sValue;
		}
		saValue.Format("%s",gettext);
		
		if(saValue.Left(5)!= type)
		{
			bWork = TRUE;
			return sValue;
		}
		saValue = saValue.Right(saValue.GetLength()-5);

		int iPos;
		iPos = saValue.Find("_",0);
		if(iPos<1)
		{
			bWork = TRUE;
			return sValue;
		}
		
		int iSize;
		iSize = atoi(saValue.Left(iPos));
		if(iSize<1)
		{
			bWork = TRUE;
			return sValue;
		}
		
		if(GetDocPositions(iSize,&sValue))
		{
			bWork = TRUE;
			return sValue;
		}
		else
		{
			bWork = TRUE;
			return sValue;
		}
		
}

CString CClientSocket::SendAskDocsPos(CString sNumber)
{
	if(!TestWifi())
		{
			return _T("");
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return _T("");
			}
	}
	bWork = FALSE;
	CString sValue;
	CStringA saValue;
	CStringA buf, type;
	buf = Translate(sNumber+_T("_"));
	type.Format("GDOC_%s",buf);
	int Errors;
	char gettext[100];
	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
							bWork = TRUE;
		return _T("");
	}					
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {10,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return sValue;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return sValue;
		}
		Errors = recv(sokClientSocket,gettext,100,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
		bWork = TRUE;
		return sValue;
		}
		saValue.Format("%s",gettext);
		saValue = saValue.Right(saValue.GetLength()-5);
		int iPos;
		iPos = saValue.Find("_",0);
		if(iPos>0)
		{
			int iSize;
			iSize = atoi(saValue.Left(iPos));
			
			if(iSize>0)
			{
				saValue = "";
				sValue = "";
				Errors = 10;
				CStringA saValueIt ="";
				{
					CString sError;
					int iRecv;
					iRecv = iSize;
					int iLen;
					int iSizeMessage;
					iSizeMessage = 100;
					int iPos;
					iPos = 0;
					char *chr;
					while(iSize > iPos)
					{
					
							iLen = iSizeMessage;
				
						type.Format("GDOP_%d_",iPos);//SendAskDocsPos
						Errors = send(sokClientSocket,type,type.GetLength()+1,0);

						Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv);
						if (Errors==0)
						{
							AfxMessageBox(_T("timeout!"),MB_OK,0);
							CloseSocket();
							bWork = TRUE;
							return _T("");
						}

						if (Errors == SOCKET_ERROR) 
						{
							CString sError;
							int res = WSAGetLastError ();
							sError.Format(_T("recv - %d"),res);
							AfxMessageBox(sError,MB_OK,0);
							CloseSocket();
							bWork = TRUE;
							return _T("");
						}

						chr = new char[iLen];
						Errors= recv(sokClientSocket, chr,iLen, 0);
						if (Errors==0)
						{
							AfxMessageBox(_T("timeout!"),MB_OK,0);
							CloseSocket();
							bWork = TRUE;
							return _T("");
						}

						if (Errors == SOCKET_ERROR) 
						{
							CString sError;
							int res = WSAGetLastError ();
							sError.Format(_T("recv - %d"),res);
							AfxMessageBox(sError,MB_OK,0);
							return _T("");
						}

						if(Errors>0)
						{
							
							iPos++;
							iRecv=iRecv-Errors;
							CString str;
							str = Translate(chr,Errors,0);
							sValue = sValue + str;
						
							sError.Format(_T("%d %d\n"),iPos-1,sValue.GetLength());
							TRACE(sError);
						}
					}
				} 
			
				bWork = TRUE;
				return sValue;
			}
		}
		
	bWork = TRUE;
	return sValue;
	
}

//CString CClientSocket::SendAskDocsPos(CString sNumber)
//{
BOOL CClientSocket::SendReadyToShipmentDoc(CString sMess)
{
	if(!TestWifi())
		{
			return FALSE;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return FALSE;
			}
	}


	bWork = FALSE;
	CStringA saValue;
	CStringA buf, type;
	buf = Translate(sMess+_T("_"));
	type.Format("SRTS_%s_",buf);
	int Errors;
	char gettext[100];
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {3,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return FALSE;
		}

	char getOk[8]; 
	//AUTR_1
	Errors = recv(sokClientSocket,getOk,7,0); // читаем из него
	if (Errors == SOCKET_ERROR) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("recv - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return FALSE;
	}
	if(getOk[5] == '1')	
		return TRUE;
	else
		return FALSE;
}	

int CClientSocket::AscZone(int iUser)
{
	if(!bWork)
		{
			return -1;
		}

	if(!TestWifi())
		{
			return -1;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return -1;
			}
	}
	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return -1;
	}
	char gettext[50];
	while(recv(sokClientSocket,gettext,50,0)!= SOCKET_ERROR)
	{
	}

	int iZone;
	iZone = -1;
	try
	{
		bWork = FALSE;
		CStringA buf, type;
		type.Format("SAUZ_%d_",iUser);
		
		int Errors;
		Errors = send(sokClientSocket,type,type.GetLength()+1,0);
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("%d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
		bWork = TRUE;
		return -1;
		}
	
		ULONG val = TRUE;
		fd_set fdset; // дескриптор сокетов
		struct timeval tv = {3,0}; // 0 секунд, 0 микросекунд
		FD_ZERO(&fdset); // обнуляем дескриптор сокетов
		FD_SET(sokClientSocket,&fdset); // выставляем сокеты в дескриптор
		
		Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
		if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return iZone;
		}

		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("select - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
		bWork = TRUE;
		return -1;
		}

		Errors = recv(sokClientSocket,gettext,50,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
		bWork = TRUE;
		return -1;
		}

		type.Format("%s",gettext);
		if(type.Left(5)!="AUTR_")
		{
			bWork = TRUE;
			return iZone;
		}
		type = type.Right(type.GetLength()-5);

		if(type.Find("_")>0)
			{
				type = type.Left(type.Find("_"));
				iZone = atoi(type);
			}
		
	bWork = TRUE;
	return iZone;
	}
	catch(...)
	{
		bWork = TRUE;
		return iZone;
	}

	bWork = TRUE;
	return iZone;
}

int CClientSocket::AscTasc(int iUser,CString* sDocNumber, int* lZone, int* iLine, int* iTask, bool *bAssString)
{
	sMessage = _T("");
	if(!bWork)
		{
			return 0;
		}

	if(!TestWifi())
		{
			return 0;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				CloseSocket();
				return 0;
			}
	}

	int iDoc;
	iDoc = 0;
	try
	{
	bWork = FALSE;
	CStringA buf, type;
	type.Format("SATU_%d_",iUser);
	int Errors;
	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		CloseSocket();
		bWork = TRUE;
		return -1;
	}
	char gettext[50];
	while(recv(sokClientSocket,gettext,50,0)!= SOCKET_ERROR)
	{
	}

	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		CloseSocket();
		bWork = TRUE;
		return 0;
		}
	

	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {5,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset); // выставляем сокеты в дескриптор
	
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			CloseSocket();
			bWork = TRUE;
			return iDoc;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		CloseSocket();
		bWork = TRUE;
		return 0;
		}

		Errors = recv(sokClientSocket,gettext,50,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			CloseSocket();
		bWork = TRUE;
		return 0;
		}

		//SATU_ Проверка
		type.Format("%s",gettext);
		if(type.Left(5)=="MATU_")
		{
			bWork = TRUE;
			type = type.Right(type.GetLength()-5);
			int iFind;
			iFind = type.Find("_");
			if(iFind<1)
				return 0;

			iDoc = atoi(type.Left(iFind ));
			return 0-iDoc;
		}

		if(type.Left(5)!="SATU_")
		{
			bWork = TRUE;
			return iDoc;
		}

		if(type.Left(7)=="SATU_0_")
		{
			bWork = TRUE;
			return iDoc;
		}
		else
		{
			bWork = TRUE;
			type = type.Right(type.GetLength()-5);
			iDoc = type.Find("_");
			if(iDoc<1)
				return 0;

			int iFind;
			iFind = iDoc;
			iDoc = atoi(type.Left(iFind ));
			type = type.Right(type.GetLength()-iFind-1);
			iFind = type.Find("_");
			if(iFind<1)
				return 0;
			sDocNumber->Format(_T("%d"),atoi(type.Left(iFind)));
			type = type.Right(type.GetLength()-iFind-1);
			iFind = type.Find("_");
			if(iFind<1)
				return 0;
			
			*lZone = atoi(type.Left(iFind));
			type = type.Right(type.GetLength()-iFind-1);
			iFind = type.Find("_");
			if(iFind<1)
				return 0;

			*iLine = atoi(type.Left(iFind));
			type = type.Right(type.GetLength()-iFind-1);
			iFind = type.Find("_");
			if(iFind<1)
				return 0;

			*iTask = atoi(type.Left(iFind));
			type = type.Right(type.GetLength()-iFind-1);
			iFind = type.Find("_");
			if(iFind<1)
				return 0;
			*bAssString = FALSE;
			if(atoi(type.Left(iFind))>0)
				*bAssString = TRUE;
			return iDoc;
		}
	bWork = TRUE;
	return iDoc;
	}
	catch(...)
	{
		bWork = TRUE;
		return FALSE;
	}


	return iDoc;
}

CString CClientSocket::SelectTask(int iUser,int iTask, int iZone, CStringArray* stArray, int iTaskZone)
{
	stArray->RemoveAll();
	if(!TestWifi())
		{
			return _T("");
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return _T("");
			}
	}

	bWork = FALSE;
	CString sValue;
	CStringA saValue;
	CStringA type;
	type.Format("STFU_%d_%d_%d_%d_",iUser,iTask,iZone,iTaskZone);
	int Errors;
	char gettext[100];
	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return _T("");
	}					
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {3,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return sValue;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return _T("");
		}
		Errors = recv(sokClientSocket,gettext,100,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
		bWork = TRUE;
		return _T("");
		}
		saValue.Format("%s",gettext);
		saValue = saValue.Right(saValue.GetLength()-5);
		int iPos;
		iPos = saValue.Find("_",0);
		if(iPos>0)
		{
			int iSize;
			iSize = atoi(saValue.Left(iPos));
			
			if(iSize>0)
			{

				if(GetDocPositions(iSize,&sValue))
				{
					while(sValue.GetLength()>0)
					{
						iPos = sValue.Find(_T("\n"));
						if(iPos>0)
						{
							stArray->Add(sValue.Left(iPos));
							sValue = sValue.Right(sValue.GetLength()-iPos-1);
						}
						while(sValue.Left(1)==_T(" "))
						{
							sValue = sValue.Right(sValue.GetLength()-1);
						}
					}
				}
	
				bWork = TRUE;
				return sValue;
			}
		}
		
	bWork = TRUE;
	return sValue;
}
void CClientSocket::SendPercent(int iDoc, int iZone, int iPercent, int iTask)
{
	if(!TestWifi())
		{
			return;
		}

	if(!bCreateSocket)
	{			
		return;			
	}

	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return;
	}		
	char gettext[100];
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	bWork = FALSE;
	CStringA type;
	type.Format("SPFD_%d_%d_%d_%d_",iDoc, iZone, iPercent,iTask);
	int Errors;
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return;
		}
	bWork = TRUE;
}


bool CClientSocket::SendUnlockUser(int iUser,int iDoc, CString sUserName)
{
	if(!TestWifi())
		{
			return FALSE;
		}
	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return FALSE;
			}
	}
	bWork = FALSE;
	CStringA buf, type;
	buf = Translate(sUserName);
	type.Format("SULU_%d_%d_%s",iUser,iDoc,buf);
	int Errors;
	char getext[100];
	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return FALSE;
	}	
	while(recv(sokClientSocket,getext,100,0)!= SOCKET_ERROR)
	{
	}
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		bWork = TRUE;
		CloseSocket();
		return FALSE;
		}

	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {3,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset); // выставляем сокеты в дескриптор
	char gettext[100];
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		return FALSE;
		}

		Errors = recv(sokClientSocket,gettext,25,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
		return FALSE;
		}
		
		type.Format("%s",gettext);
		if(type.Left(5)!="SULU_")
		{
			bWork = TRUE;
			return FALSE;
		}

		type.Format("%s",gettext);
		type = type.Right(type.GetLength()-5);
		if(type.Find("_")<1)
			return FALSE;
		type = type.Left(type.Find("_"));
		bWork = TRUE;
		if(atoi(type)>0)
			return TRUE;
		else
			return FALSE;
}

int CClientSocket::SelectBox(CString sBox, int iDoc, int iRand, int iUser )
{
	if(!TestWifi())
		{
			return -1;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				CloseSocket();
				return -1;
			}
	}

	ULONG val = TRUE;
  	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		CloseSocket();
		bWork = TRUE;
		return -1;
	}
	char gettext[100];
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	bWork = FALSE;
	
	CStringA buf,type;
	CString sValue;
	sBox = sBox.Right(3);
	
	buf = Translate(sValue+_T("_"));
	type.Format("SBFD_%d_%d_%d_%d_",iDoc,_wtoi(sBox),iRand,iUser);
	
	int Errors;
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		CloseSocket();
		bWork = TRUE;
		return -1;
		}
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {3,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			CloseSocket();
			bWork = TRUE;
			return -1;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		CloseSocket();
		bWork = TRUE;
		return -1;
		}
		Errors = recv(sokClientSocket,gettext,100,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			CloseSocket();
		bWork = TRUE;
		return -1;
		}

	type.Format("%s",gettext);
	
	bWork = TRUE;
	if(type.Left(7)=="SBFD_1_")
		return 1;

	if(type.Left(7)=="SBFD_0_")
		return 0;
	return -1;
}

bool CClientSocket::SendEndBox(CString sBox, int iDoc, int iZone, int Percent, int iTask)
{
	if(!TestWifi())
		{
			return FALSE;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				CloseSocket();
				return FALSE;
			}
	}

	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return FALSE;
	}
	char gettext[100];
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	bWork = FALSE;
	
	CStringA buf,type;
	CString sValue;
	sValue.Format(_T("%s_%d_%d_%d_%d_"),sBox,iDoc, iZone, Percent,iTask);
	buf = Translate(sValue+_T("_"));
	type.Format("SEBX_%s",buf);
	
	int Errors;
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return FALSE;
		}
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {10,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return FALSE;
		}
		Errors = recv(sokClientSocket,gettext,100,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
		bWork = TRUE;
		return FALSE;
		}

	type.Format("%s",gettext);
	
	bWork = TRUE;
		if(type.Left(6)=="AUTR_1")
			return TRUE;
		else
			return FALSE;
}

BOOL CClientSocket::DoByArray(void)
{
	if(!TestWifi())
		{
			return FALSE;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				CloseSocket();
				return FALSE;
			}
	}

	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return FALSE;
	}
	char gettext[100];
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	bWork = FALSE;
	
	int iPos;
	iPos = 0;
	while(iPos<saValues.GetSize())
	{
		CStringA type;
		type.Format("%s",saValues.ElementAt(iPos));
	
		int Errors;
		Errors = send(sokClientSocket,type,type.GetLength()+1,0);
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("%d"),res);
			AfxMessageBox(sError,MB_OK,0);
			bWork = TRUE;
			saValues.RemoveAll();
			CloseSocket();
		bWork = TRUE;
		return FALSE;
		}
	
		fd_set fdset; // дескриптор сокетов
		struct timeval tv = {10,0}; // 0 секунд, 0 микросекунд
		FD_ZERO(&fdset); // обнуляем дескриптор сокетов
		FD_SET(sokClientSocket,&fdset);
		Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
		if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			saValues.RemoveAll();
			return FALSE;
		}

		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("select - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
		
		Errors = recv(sokClientSocket,gettext,100,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			saValues.RemoveAll();
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
		
		CStringA type2;
		type2 = type.Left(5)+"1_";
		type.Format("%s",gettext);
		bWork = TRUE;
		if(type.Left(8)==type2)
		{
			iPos++;
		}
		else
		{
			saValues.RemoveAll();
			return FALSE;
		}
	}
	return TRUE;
}

BOOL CClientSocket::SelectSavePos(int iDoc, int iZone, CString* sValue,int iTask)
{
	*sValue = _T("");
	CString sRetValue;
	sRetValue = _T("");
	if(!TestWifi())
		{
			return FALSE;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return FALSE;
			}
	}

	bWork = FALSE;
	CStringA saValue;
	CStringA type;
	//SSDP_
	type.Format("SSDP_%d_%d_%d_",iDoc,iZone,iTask);
	int Errors;
	char gettext[100];
	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
			bWork = TRUE;
			return FALSE;
	}					
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {10,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
		Errors = recv(sokClientSocket,gettext,100,0); // читаем из него
		if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("recv - %d"),res);
			AfxMessageBox(sError,MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
		saValue.Format("%s",gettext);
		saValue = saValue.Right(saValue.GetLength()-5);
		int iPos;
		iPos = saValue.Find("_",0);
		if(iPos<1)
		{
			bWork = TRUE;
			return TRUE;
		}

		iPos = atoi(saValue.Left(iPos));
		if(iPos<1)
		{
			bWork = TRUE;
			return TRUE;
		}

		GetDocPositions(iPos,sValue);
	
	bWork = TRUE;
	return TRUE;
}

BOOL CClientSocket::PostNotFindPos(int iDoc, int iZone, int iTask)
{
	if(!TestWifi())
		{
			return FALSE;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return FALSE;
			}
	}

	bWork = FALSE;
	CStringA type;
	type.Format("PNFP_%d_%d_%d_",iDoc,iZone,iTask);
	int Errors;
	char gettext[100];
	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
			bWork = TRUE;
			return FALSE;
	}					
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {10,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
		
	
	Errors = recv(sokClientSocket,gettext,100,0); // читаем из него
	if (Errors == SOCKET_ERROR) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("recv - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
			bWork = TRUE;
			return FALSE;
	}
	
	type.Format("%s",gettext);
	bWork = TRUE;
	if(type == "AUTR_1")
		return TRUE;
	else
		return FALSE;
}

long CClientSocket::GetUserString(long iUser)
{
	if(!TestWifi())
		{
			return -1;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				CloseSocket();
				return -1;
			}
	}

	bWork = FALSE;
	CStringA type;
	type.Format("GUSA_%d_%d_",iUser);
	int Errors;
	char gettext[100];
	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CloseSocket();
		bWork = TRUE;
		return -1;
	}					
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {3,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			CloseSocket();
			bWork = TRUE;
			return -1;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CloseSocket();
			bWork = TRUE;
			return -1;
		}
		
	
	Errors = recv(sokClientSocket,gettext,100,0); // читаем из него
	if (Errors == SOCKET_ERROR) 
	{
		CloseSocket();
			bWork = TRUE;
			return -1;
	}
	
	type.Format("%s",gettext);
	bWork = TRUE;
	if(type.Left(5)!="GUSA_")
	{
		return -1;
	}

	if(type.Left(8) == "GUSA_-1_")
		return -1;
	else
	{
		type = type.Right(type.GetLength()-5);
		int iFind;
		iFind = type.Find("_");
		if(iFind<1)
			return -1;
		iFind = atoi(type.Left(iFind));
		return iFind;
	}
}

bool CClientSocket::SetState(long iUser, int iState)
{
	if(!TestWifi())
		{
			return FALSE;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return FALSE;
			}
	}

	bWork = FALSE;
	CStringA type;
	type.Format("STST_%d_%d_",iUser,iState);
	int Errors;
	char gettext[100];
	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
			bWork = TRUE;
			return FALSE;
	}					
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {3,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			AfxMessageBox(_T("timeout!"),MB_OK,0);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
	if (Errors == SOCKET_ERROR) 
		{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("select - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
		
	
	Errors = recv(sokClientSocket,gettext,100,0); // читаем из него
	if (Errors == SOCKET_ERROR) 
	{
		CString sError;
		int res = WSAGetLastError();
		sError.Format(_T("recv - %d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
			bWork = TRUE;
			return FALSE;
	}
	
	type.Format("%s",gettext);
	bWork = TRUE;
	if(type == "STST_1_")
		return TRUE;
	else
		return FALSE;

	return TRUE;
}


CString CClientSocket::ReplaceLeftSymbol(CString  sStr)
{
	CString sRet;
	sRet = _T("");
	for(int i = 0; i<sStr.GetLength();i++)
	{
		if(sCodeString.Find(sStr[i],0)>-1)
		{
			sRet = sRet + sStr[i];
		}
	}
	return sRet;
}

char* CClientSocket::Translate(CString sBuff, CStringA sStart,CStringA sEnd)
{
	char ch;
	
	char *chBuff;
	int i;
	i = sStart.GetLength()+sBuff.GetLength()+sEnd.GetLength();
	chBuff = new char[i];
	
	for(i=0;i<sStart.GetLength();i++)
	{
		ch = sStart[i]; 
		chBuff[i] = ch;
	}

	int iPos;
	for(i=sStart.GetLength();i<sStart.GetLength()+sBuff.GetLength();i++)
	{
		iPos = sCodeString.Find(sBuff[i-sStart.GetLength()],0);
		if(iPos>-1)
			chBuff[i] = iPos+1;
	}

	for(i=sStart.GetLength()+sBuff.GetLength();i<sStart.GetLength()+sBuff.GetLength()+sEnd.GetLength();i++)
	{
		ch = sEnd[i-sStart.GetLength()-sBuff.GetLength()]; 
		chBuff[i] = ch;
	}

	return chBuff;
}


BOOL CClientSocket::GetCloseBarCode(CString *sBarCode)
{
	sBarCode->Format(_T(""));
	if(!TestWifi())
		{
			return FALSE;
		}

	if(!bCreateSocket)
	{			
		sMessage = _T("");
		if (!StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+sMessage, MB_OK,0);	
				CloseSocket();
				return FALSE;
			}
	}

	bWork = FALSE;
	CString sValue;
	CStringA saValue;
	CStringA type;
	type.Format("GCFC__GCFC");
	int Errors;
	char gettext[100];
	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sokClientSocket, FIONBIO, &val)) 
	{
		CString sError;
		int res = WSAGetLastError ();
		sError.Format(_T("%d"),res);
		AfxMessageBox(sError,MB_OK,0);
		CloseSocket();
		bWork = TRUE;
		return FALSE;
	}					
	while(recv(sokClientSocket,gettext,100,0)!= SOCKET_ERROR)
	{
	}
	
	Errors = send(sokClientSocket,type,type.GetLength()+1,0);
	
	fd_set fdset; // дескриптор сокетов
	struct timeval tv = {3,0}; // 0 секунд, 0 микросекунд
	FD_ZERO(&fdset); // обнуляем дескриптор сокетов
	FD_SET(sokClientSocket,&fdset);
	Errors = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); // выбираем те, откуда можно производить чтение
	if (Errors==0)
		{
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
	if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			sError.Format(_T("select - %d"),res);
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}

	Errors = recv(sokClientSocket,gettext,100,0); // читаем из него
	if (Errors == SOCKET_ERROR) 
		{
			CString sError;
			int res = WSAGetLastError ();
			CloseSocket();
			bWork = TRUE;
			return FALSE;
		}
	
	saValue.Format("%s",gettext);
	
	if(saValue.Left(5)!="GCFC_")
	{
		bWork = TRUE;
		return FALSE;
	}
	saValue = saValue.Right(saValue.GetLength()-5);
	int iFind;
	iFind = saValue.Find("_GCFC",0);
	if(iFind<0)
	{
		bWork = TRUE;
		return FALSE;
	}
		sBarCode->Format(_T("%S"),saValue.Left(iFind));
	bWork = TRUE;
	return TRUE;
}