// FTPService.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "FTPService.h"
#include "winsvc.h"
#include "afxinet.h"
#include "ZipArchive.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif

#pragma comment (lib, "c:\\SVN\\zlib.lib")

#define MSG_LEN 256
#define KEY_LEN MSG_LEN
#define ServiceName TEXT("FTPUpdateQuantsService")
#define DisplayName TEXT("FTP Update Quants Service")
#define EventSource TEXT("FTPUpdateQuantsService")
#define SERVICE_PARENT_KEY TEXT("System\\CurrentControlSet\\Services")
#define LOG_PARENT_KEY     TEXT("System\\CurrentControlSet\\Services\\Eventlog\\Application")
#define PARAMETERS_CHANGED           129
#define MSG_PARAMETERS_CHANGED           0x00000002L

HANDLE eSendPending;
HANDLE hSendThread;
HANDLE hSource = NULL;

SERVICE_STATUS_HANDLE ssHandle; 
SERVICE_STATUS sStatus;
HANDLE hEndEvent;
LONG   fPause = 0;
DWORD  lWait;
//cp=session->GetFtpConnection("ftp.shate.by","shateby","kj,pbrcsv",INTERNET_INVALID_PORT_NUMBER,TRUE);

struct stServers
{
	CString sServerName;
	CString sUserName;
	CString sPassword;
};

struct stFTPAdress
{
	CString sFTPAdress;
	int iServer;
};


struct stBases
{
	CString sKursesFile;
	CString sCSVFileName;
	CString sAchiveName;
	CArray<stFTPAdress *,stFTPAdress*> sFTPAdress;
	CString sRusName;
	CString sCataloge;
	long lMinLen;
	int iType;
	int iColFTP;
};


/////////////////////////////////////////////////////////////////////////////
// The one and only application object


void WriteToLogFile(CString sWrite)
{
	CString sPath;
	char cBuffer[MAX_PATH];
    ::GetModuleFileName(NULL, cBuffer, MAX_PATH);
    sPath = cBuffer;
    sPath = sPath.Left(sPath.ReverseFind('\\'));
	if (sPath.Right(1)!="\\") sPath += "\\";

	CTime time;
	CStdioFile oFile;
	time = time.GetCurrentTime();
	if(!oFile.Open(sPath+"FTPService.log",CFile::modeReadWrite))
		if(!oFile.Open(sPath+"FTPService.log",CFile::modeCreate|CFile::modeWrite))
			return;
		
		oFile.SeekToEnd();
		oFile.WriteString(time.Format("%y%m%d %H:%M:%S")+"\t"+sWrite+"\n");
		oFile.Close();
}


void RestartService()
{
	CString sPath;
	char cBuffer[MAX_PATH];
    ::GetModuleFileName(NULL, cBuffer, MAX_PATH);
    sPath = cBuffer;
    sPath = sPath.Left(sPath.ReverseFind('\\'));
	if (sPath.Right(1)!="\\") sPath += "\\";
		STARTUPINFO si;
		PROCESS_INFORMATION pi;
        ZeroMemory( &si, sizeof(si) );
		si.cb = sizeof(si);
		ZeroMemory( &pi, sizeof(pi) );
		char szCommand[MAX_PATH+15] = "";
		strcat(szCommand, sPath+"restart.bat");
		if (CreateProcess(NULL,szCommand, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, sPath, &si, &pi)>0)
		{
			void* cstr;
			FormatMessage(
			FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
			NULL,
			GetLastError(),
			MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
			(LPTSTR) &cstr,
			0,
			NULL
			);
			CString res((char*)cstr);
			LocalFree(cstr);
			WriteToLogFile(res);
		}
	Sleep(100000);

}


bool InstallService(DWORD* pErr)
{
	*pErr = 0;
	SC_HANDLE hSCM;
	SC_HANDLE hService;	
	hSCM = OpenSCManager(NULL, NULL, SC_MANAGER_CREATE_SERVICE);

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
		
	TCHAR ServicePath[_MAX_PATH + 3];

	// Получаем путь к exe-файлу
	GetModuleFileName(NULL, ServicePath + 1, _MAX_PATH);

	// Заключаем в кавычки
	ServicePath[0] = TEXT('\"');
	ServicePath[lstrlen(ServicePath) + 1] = 0;
	ServicePath[lstrlen(ServicePath)] = TEXT('\"');

	// Созддаём службу
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

    if (!hService)
	{
		switch (GetLastError())
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

	return true;
}

// WriteDescription
//   записывает в реестр описание службы
bool WriteDescription(HINSTANCE hInst, DWORD* pErr)
{
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

// InstallEventLog
//   создаёт новый источник событий для Event Log'а
bool InstallEventLog(DWORD* pErr)
{
	return true;
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

// UninstallEventLog
//   удаляет службу из списка источников сообщений Event Log'а
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
	TCHAR		msgString[MSG_LEN];
	HINSTANCE   hInst;
	
	hInst = GetModuleHandle(NULL);

	if (  !UninstallService(&Err)		
		||!UninstallEventLog(&Err)
		)
	{
		LoadString(hInst, Err, msgString, MSG_LEN);
		MessageBox(NULL, msgString, DisplayName, MB_OK);
		return false;
	}

	return true;
}

void DisplayHelp()
{
}



bool Install()
{
	DWORD		Err;
	TCHAR		msgString[MSG_LEN];
	HINSTANCE   hInst;
	hInst = GetModuleHandle(NULL);
	if (!InstallService(&Err)
		||!WriteDescription(hInst, &Err)
		||!InstallEventLog(&Err)
		)
	{
		Uninstall();
		LoadString(hInst, Err, msgString, MSG_LEN);
		MessageBox(NULL, msgString, DisplayName, MB_OK);
		return false;
	}
	return true;
}

void Stop()
{
	SetEvent(hEndEvent);
    Sleep(1000);
	CloseHandle(hEndEvent);
	WriteToLogFile("Завершение работы");
}

void Pause()
{
	InterlockedExchange(&fPause, 1); 
}

void Continue()
{
	InterlockedExchange(&fPause, 0); 
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


//GetUpdate(massBases[i].sCataloge,massBases[i].sFTPAdress,massBases[i].sRusName,massBases[i].sAchiveName,20)

bool ExistFile(LPCTSTR filename)
{
    return CFileFind().FindFile(filename) == TRUE;
}


int GetUpdate(CString sWorkingPath, CString sFtpAdress, CString sRusName, CString sAchiveName, int iCicle, int iType,CString sServerFTP,CString sUserFTP,CString sPassFTP )
{
	bool bNew;
	bNew = FALSE;

	iCicle = iCicle -1;
	CString sFilePath;
	CString sFile;
	CString sOutFile;
	CString sFileQuants;
	if (sWorkingPath.Right(1)!="\\")
		sWorkingPath = sWorkingPath + "\\";

	if (sFtpAdress.Right(1)!="/")
		sFtpAdress = sFtpAdress + "/";
	
	sFilePath= sWorkingPath;
	if(sAchiveName.GetLength()<1)
		sAchiveName = sRusName;
	
	sFileQuants = sFilePath+sAchiveName;
	
	CStdioFile oFile, oFileOut, oFileQuants;
	long lFileLength;
	lFileLength = 0;
	CFileStatus FileQuantsStatus;

	CTime time;
	try
	{

		if(!oFileQuants.GetStatus(sFileQuants,FileQuantsStatus))
		{
			CString sError;
			sError.Format(_T("Ошибка - %s (%d) " ),sFileQuants,GetLastError());
			WriteToLogFile(sError);	
			return iCicle;
		}


		lFileLength = FileQuantsStatus.m_size;
		time = FileQuantsStatus.m_atime;
	}
	catch(...)
	{
		WriteToLogFile("Проблема с файлом - " +sFileQuants);	
		
		return iCicle;
	}

	
	if (lFileLength < 1)
		{
		//lFileLength
		CString sError;
		sError.Format(_T("Не корректная длина файла - %s (%d) " ),sFileQuants,lFileLength);
		WriteToLogFile(sError);	
		
		return iCicle;
		}

	CString sNewTime; 
	CString sPartComData; 
	sNewTime = time.Format("%y%m%d");
	sPartComData = 	time.Format("%d.%m.%Y");
	BOOL res;
	sFile = sFilePath+"update.txt";
	
	if(ExistFile(sFile))
	{
		try
		{
			CFile::Remove(sFile);
		}
		catch(...)
		{
			WriteToLogFile("Не удален файл - " + sFile);
			return iCicle;
		}
	}
	
	CInternetSession* session;
	session = new CInternetSession(_T("FTP UPDATE"));
	CFtpConnection *cp;
	cp = NULL;
	try
		{
			cp=session->GetFtpConnection(sServerFTP,sUserFTP,sPassFTP,INTERNET_INVALID_PORT_NUMBER,TRUE);
		}	
	catch(...)
		{
			WriteToLogFile("Не доступно FTP подключение.");
			session->Close(); 
			delete session;
			return iCicle;
		}
	
	CFtpFileFind ftpFindFile(cp);
	cp->SetCurrentDirectory(sFtpAdress);
	WriteToLogFile("Корневая папка -" + sFtpAdress);

	if(iType < 2)
	{
		sOutFile = sFilePath+"update.inf";
		res = ftpFindFile.FindFile("update.inf",INTERNET_FLAG_DONT_CACHE);
		if (res==TRUE)
		{
			try
			{
				res = cp->GetFile(sFtpAdress+"update.inf",sFile);
				if(res)
				{
					WriteToLogFile("Скачен файл - " +sFtpAdress+"update.inf");
				}
				else
				{
					WriteToLogFile("Не скачен файл - " +sFtpAdress+"update.inf");
					void* cstr;
					FormatMessage(
						FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
						NULL,
						GetLastError(),
						MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
						(LPTSTR) &cstr,
						0,
						NULL
						);
					
					CString res((char*)cstr);
					LocalFree(cstr);
					WriteToLogFile(res);
					cp->Close();
					delete cp; session->Close(); delete session;
						return iCicle;
				}
			}
			catch(...)
				{
						void* cstr;
						FormatMessage(
						FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
						NULL,
						GetLastError(),
						MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
						(LPTSTR) &cstr,
						0,
						NULL
						);
								CString res((char*)cstr);
						LocalFree(cstr);
						WriteToLogFile(res);
						cp->Close();
						delete cp; session->Close(); delete session;
						return iCicle;
				}
		}
		else
		{
			res = ftpFindFile.FindFile("__update.inf",INTERNET_FLAG_DONT_CACHE);
			if (res!=TRUE)
			{
				void* cstr;
				FormatMessage(
				FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
				NULL,
				GetLastError(),
				MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
				(LPTSTR) &cstr,
				0,
				NULL
				);
				CString res((char*)cstr);
				LocalFree(cstr);
				WriteToLogFile(res);
				WriteToLogFile("Не найден файл: "+sFtpAdress+"update.inf");
				delete cp; 
				session->Close(); 
				delete session;
				return iCicle;
			}
			else
			{
				try
				{
						cp->GetFile(sFtpAdress+"__update.inf",sFile);
						if(res)
						{
							WriteToLogFile("Скачен файл - " +sFtpAdress+"__update.inf");
						}
						else
						{
							WriteToLogFile("Не скачен файл - " +sFtpAdress+"__update.inf");
							void* cstr;
							FormatMessage(
								FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
								NULL,
								GetLastError(),
								MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
								(LPTSTR) &cstr,
								0,
								NULL
								);
							
							CString res((char*)cstr);
							LocalFree(cstr);
							WriteToLogFile(res);
							cp->Close();
							delete cp; session->Close(); delete session;
							return iCicle;
					}
				}
				catch(...)
					{
							void* cstr;
							FormatMessage(
							FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
							NULL,
							GetLastError(),
							MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
							(LPTSTR) &cstr,
							0,
							NULL
							);
	
							CString res((char*)cstr);
							LocalFree(cstr);
							WriteToLogFile(res);
							cp->Close();
							delete cp; session->Close(); delete session;
							return iCicle;
					}
			}
		}
		

		long lLenUpdate = 0;
		try
		{
			if(!oFile.GetStatus(sFile,FileQuantsStatus))
			{
				WriteToLogFile("Размер файла - " +sFile+" не получен");
				cp->Close();
				delete cp; session->Close(); delete session;
				return iCicle;
			}
			else
			{
				WriteToLogFile("Размер файла - " +sFile+" получен");
			}
			lLenUpdate = FileQuantsStatus.m_size;
		}
		catch(...)
		{
			WriteToLogFile("Проблема с файлом - " +sFile);	
			cp->Close();
			delete cp; session->Close(); delete session;
			return iCicle;
		}
		
		if(lLenUpdate<500)
		{
			WriteToLogFile("Проблема с файлом - " +sFile);	
			cp->Close();
			delete cp; session->Close(); delete session;
			return iCicle;
		}

		try
		{	
			if(!oFile.Open(sFile,CFile::modeRead))
			{
				WriteToLogFile("Немогу прочитать файл - " +sFile);	
				cp->Close();
				delete cp; session->Close(); delete session;
				return iCicle;
			}
		}
		catch(...)
		{
			WriteToLogFile("Не открыт файл - "+sFile);
			cp->Close();
			delete cp; session->Close(); delete session;
			return iCicle;
		}
	
		lLenUpdate = 0;
		try
		{
			oFile.GetStatus(sFile,FileQuantsStatus);
			lLenUpdate = FileQuantsStatus.m_size;
		}
		catch(...)
		{
			WriteToLogFile("Проблема с файлом - " +sFile);	
			cp->Close();
			delete cp; session->Close(); delete session;
			return iCicle;
		}

		if(lLenUpdate < 1)
		{
			WriteToLogFile("Не корректно закачен - " +oFile);	
			cp->Close();
			delete cp; session->Close(); delete session;
			return iCicle;
		}
	
		try
		{		
			if(!oFileOut.Open(sOutFile,CFile::modeCreate|CFile::modeWrite))
			{
				WriteToLogFile("Немогу создать файл - " +sOutFile);	
				oFile.Close();
				cp->Close();
				delete cp; session->Close(); delete session;
				return iCicle;
			}
		}
		catch(...)
		{
			WriteToLogFile("Не открыт файл - "+oFileOut);
			oFile.Close();
			cp->Close();
			delete cp; session->Close(); delete session;
			return iCicle;
		}


		CString sText;
		CString sOld;
		
	
		
			while(oFile.ReadString(sText)>0)
			{


				if(sText.Find(sRusName,0)>-1)
				{
					

					float fLenFile;
					CString sNewOut;
					sNewOut = sText.Left(sText.Find("[",0));
					sNewOut = sNewOut+"[%s] %.2fКб\n";
					oFile.ReadString(sText);
					sNewOut = sNewOut+sText.Left(sText.Find("=",0)+1)+"%d\n";//size
					oFile.ReadString(sText);
					sNewOut = sNewOut+sText+"\n";
					oFile.ReadString(sText);
					sOld = sText.Right(sText.GetLength()-sText.Find("=")-1);
			
				if(sNewTime >= sOld.Left(sNewTime.GetLength()))
				{
					if(sNewTime == sOld.Left(sNewTime.GetLength()))	
					{
						sOld = sOld.Right(sOld.GetLength() - sNewTime.GetLength()-1);
						int I;
						I = atoi(sOld)+1;
						sOld.Format("%s_%d",sPartComData,I);
						sPartComData = sOld;
						sOld.Format("%s.%d",sNewTime,I);
					}
					else
					{
						sOld = sNewTime + ".1";
						sPartComData = sPartComData + "_1";
					}
					fLenFile = lFileLength;
					fLenFile = fLenFile/1024;
					sNewOut = sNewOut+sText.Left(sText.Find("=")+1)+"%s";
					sNewTime.Format(sNewOut,sOld, fLenFile,lFileLength,sOld);
					oFileOut.WriteString(sNewTime+'\n');		
					while(oFile.ReadString(sText)>0)
					oFileOut.WriteString(sText+'\n');
					bNew = TRUE;
					break;
				}
				else
					WriteToLogFile("Ошибка времени файла - "+ sNewTime + " "+sOld);	
			}
			else
				oFileOut.WriteString(sText+'\n');	
		}

		oFile.Close();
		oFileOut.Close();
	

		
		lFileLength =0;
	
	try
	{
		oFileQuants.GetStatus(sOutFile,FileQuantsStatus);
		lFileLength = FileQuantsStatus.m_size;
	}
	catch(...)
	{
		WriteToLogFile("Проблема с файлом - " +sOutFile);
		cp->Close();
			delete cp; session->Close(); delete session;
		return iCicle;
	}
	WriteToLogFile("Создан - " +sOutFile);	
	if (lFileLength < 100)
		{
		WriteToLogFile("Проблема с файлом - " +sOutFile);
		cp->Close();
			delete cp; session->Close(); delete session;
		return iCicle;
		}
	}
	else
	{
		bNew = TRUE;
	}

	
	if(bNew)
		{
		
			try
			{
				if(!cp->PutFile(sFileQuants,sFtpAdress+"_"+sAchiveName))
				{
						WriteToLogFile("не передали файл по FTP -" +sFtpAdress+"_"+sAchiveName);
						cp->Close();
						delete cp; 
						session->Close(); 
						delete session;
						return iCicle;
				}
				
				
		
			}
			catch(...)
			{
				WriteToLogFile("FTP ->"+sFtpAdress+sAchiveName);	
				cp->Close();
				delete cp; session->Close(); delete session;
				return iCicle;
			}

			if(iType < 2)
			{
				try
				{
					if(!cp->PutFile(sOutFile,sFtpAdress+"_update.inf"))
					{
							WriteToLogFile("не передали файл по FTP -" +sFtpAdress+"_update.inf");
							cp->Close();
							delete cp; 
							session->Close(); 
							delete session;
							return iCicle;
					}	

				}
				catch(...)
				{
					WriteToLogFile("FTP ->"+sFtpAdress+"update.inf");	
					cp->Close();
					delete cp; session->Close(); delete session;
					return iCicle;
				}
			}
			

			try
			{
				
				if(iType == 1)
				{
					sPartComData = sAchiveName.Left(sAchiveName.GetLength()-4)+"_"+sPartComData + ".zip";
					if(cp->Rename(sFtpAdress+"_"+sAchiveName,sFtpAdress+sPartComData)!=0)
					{
						WriteToLogFile("Rename FTP File ->"+sFtpAdress+sPartComData);
					}
					else
					{
						CString sError;
						sError.Format("Error - %d rename FTP File %s",GetLastError(),sFtpAdress+sPartComData);
						WriteToLogFile(sError);
						cp->Close();
						delete cp; session->Close(); delete session;
						return iCicle;
					}
				}			
				else
				{
					
					cp->Remove(sFtpAdress+"__"+sAchiveName);
					cp->Rename(sFtpAdress+sAchiveName,sFtpAdress+"__"+sAchiveName);
					if(cp->Rename(sFtpAdress+"_"+sAchiveName,sFtpAdress+sAchiveName)!=0)
					{
						WriteToLogFile("Rename FTP File ->"+sFtpAdress+sAchiveName);
					}
					else
					{
						CString sError;
						sError.Format("Error - %d rename FTP File %s",GetLastError(),sFtpAdress+sAchiveName);
						WriteToLogFile(sError);
						cp->Close();
						delete cp; session->Close(); delete session;
						return iCicle;
					}
				}
				if(iType < 2)
				{
					cp->Remove(sFtpAdress+"__"+"update.inf");
					cp->Rename(sFtpAdress+"update.inf",sFtpAdress+"__"+"update.inf");
					if(cp->Rename(sFtpAdress+"_update.inf",sFtpAdress+"update.inf")!=0)
					{
						WriteToLogFile("Rename FTP File ->"+sFtpAdress+"update.inf");
					}
					else
					{
						CString sError;
							sError.Format("Error - %d rename FTP File %s",GetLastError(),sFtpAdress+"update.inf");
							cp->Close();
							WriteToLogFile(sError);
							delete cp; session->Close(); delete session;
							return iCicle;
					}
				}
			}
			catch(...)
			{
				WriteToLogFile("FTP ->"+sFtpAdress+"update.inf");	
				cp->Close();
				delete cp; session->Close(); delete session;
				return iCicle;
			}

			

			cp->Close();
			delete cp; 
			session->Close(); 
			delete session;
		if(iType == 1)
			WriteToLogFile("Обновление завершено: "+sFtpAdress+sPartComData);		
		else
			WriteToLogFile("Обновление завершено: "+sFtpAdress+sAchiveName);		
		}
		else
		{
			WriteToLogFile("Обновление не завершено: bNew = FALSE");		
		}
	return -100;			
}






void Run()
{
	try
	{
		WriteToLogFile("Начало работы");	
		stServers* sServer;
		
			
		/*sServer[0].sServerName = "ftp.shate.by";
		sServer[0].sUserName = "shateby";
		sServer[0].sPassword = "APz<i52w";

		sServer[1].sServerName = "orf";
		sServer[1].sUserName = "service";
		sServer[1].sPassword = "APz<i52w";

		sServer[2].sServerName = "shate-shina.by";
		sServer[2].sUserName = "shateby";
		sServer[2].sPassword = "APz<i52w";

		sServer[3].sServerName = "91.211.52.46";
		sServer[3].sUserName = "shate-m";
		sServer[3].sPassword = "shate-mplus";*/

		CString sPath;
		char cBuffer[MAX_PATH];
		::GetModuleFileName(NULL, cBuffer, MAX_PATH);
		sPath = cBuffer;
		sPath = sPath.Left(sPath.ReverseFind('\\'));
		CString sOld;
		if (sPath.Right(1)!="\\") sPath += "\\";
		
		CWinApp *myap = AfxGetApp();

		long lCountFTP;

		lCountFTP = GetPrivateProfileInt("FTPServer","COUNT",0,sPath+myap->m_pszProfileName);
		if (lCountFTP < 1)
		{
			WriteToLogFile("Не указаны сервера!");
			return;
		}

		sServer = new(stServers[lCountFTP]);

		int i;

		for (i = 1; i <= lCountFTP; i++)
		{
			CString sValue;

			sValue.Format("%d",i);

			GetPrivateProfileString("FTPServer",sValue+"_FTPNAME","",cBuffer,MAX_PATH,sPath+myap->m_pszProfileName);
			sServer[i - 1].sServerName = cBuffer;

			GetPrivateProfileString("FTPServer",sValue+"_FTPUSER","",cBuffer,MAX_PATH,sPath+myap->m_pszProfileName);
			sServer[i - 1].sUserName = cBuffer;

			GetPrivateProfileString("FTPServer",sValue+"_FTPPASS","",cBuffer,MAX_PATH,sPath+myap->m_pszProfileName);

			CString tmpStr = cBuffer;
			CString tmpStrNew = "";
			
			int k;
			for (k = 0; k < tmpStr.GetLength(); k++){
				int codeChar;
				codeChar = (int)tmpStr[k] - 1;
				if (codeChar <= 0)
				{
					codeChar = codeChar + 255;
				}
				tmpStrNew = tmpStrNew + (char)codeChar;
			}

			sServer[i - 1].sPassword = tmpStrNew;
		}


		CString sValue;
		long lCountBase; 

		lCountBase = GetPrivateProfileInt("BASES","COUNT",0,sPath+myap->m_pszProfileName);
		if (lCountBase<1) 
			{
			WriteToLogFile("Не подключенны базы!");
		//	return;
			}
		

		stBases * massBases;
		massBases = new (stBases[lCountBase]);

		CString sMess;

		int iColFTP;
		stFTPAdress* FTPAdress;
		for(i=1;i<=lCountBase;i++)
		{
			massBases[i-1].sFTPAdress.RemoveAll(); 

			CString sValue;
			sValue.Format("%d",i);

			GetPrivateProfileString("BASES", sValue + "_FileKurs", "", cBuffer, MAX_PATH, sPath + myap->m_pszProfileName);
			massBases[i - 1].sKursesFile = cBuffer;
			
			GetPrivateProfileString("BASES",sValue+"_ARCHIVENAME","",cBuffer,MAX_PATH,sPath+myap->m_pszProfileName);
			massBases[i-1].sAchiveName = cBuffer;
			
			GetPrivateProfileString("BASES",sValue+"_CSVFILENAME","",cBuffer,MAX_PATH,sPath+myap->m_pszProfileName);
			massBases[i-1].sCSVFileName = cBuffer;
			
			massBases[i-1].iColFTP = GetPrivateProfileInt("BASES",sValue+"_FTP_COUNT",0,sPath+myap->m_pszProfileName);
			iColFTP = massBases[i-1].iColFTP;
			if(iColFTP > 0)
			{
				while(iColFTP > 0)
				{
					FTPAdress = new(stFTPAdress);
					CString sNameFTPID;
					sNameFTPID.Format("%s_FTPADRESS_%d",sValue,iColFTP);
					GetPrivateProfileString("BASES",sNameFTPID,"",cBuffer,MAX_PATH,sPath+myap->m_pszProfileName);
					FTPAdress->sFTPAdress = cBuffer;


					sNameFTPID.Format("%s_FTPSERVER_%d",sValue,iColFTP);
					FTPAdress->iServer = GetPrivateProfileInt("BASES",sNameFTPID,0,sPath+myap->m_pszProfileName);
					iColFTP--;
					massBases[i-1].sFTPAdress.Add(FTPAdress);
				}
			}
			else
			{
				FTPAdress = new(stFTPAdress);
				CString sNameFTPID;
				sNameFTPID.Format("%s_FTPADRESS",sValue);
				GetPrivateProfileString("BASES",sNameFTPID,"",cBuffer,MAX_PATH,sPath+myap->m_pszProfileName);
				FTPAdress->sFTPAdress = cBuffer;
				sNameFTPID.Format("%s_FTPSERVER",sValue,iColFTP);
				FTPAdress->iServer = GetPrivateProfileInt("BASES",sNameFTPID,0,sPath+myap->m_pszProfileName);
				massBases[i-1].sFTPAdress.Add(FTPAdress);
				massBases[i-1].iColFTP = 1;
			}
			
			GetPrivateProfileString("BASES",sValue+"_RUSNAME","",cBuffer,MAX_PATH,sPath+myap->m_pszProfileName);
			massBases[i-1].sRusName = cBuffer;
			
			

			GetPrivateProfileString("BASES",sValue+"_CATALOGE","",cBuffer,MAX_PATH,sPath+myap->m_pszProfileName);
			massBases[i-1].sCataloge = cBuffer;
			massBases[i-1].lMinLen = GetPrivateProfileInt("BASES",sValue+"_MINSIZE",0,sPath+myap->m_pszProfileName);
			massBases[i-1].iType = GetPrivateProfileInt("BASES",sValue+"_TYPE",0,sPath+myap->m_pszProfileName);
			
			if (massBases[i-1].sCataloge.Right(1)!="\\")
				massBases[i-1].sCataloge = massBases[i-1].sCataloge + "\\";


		}
		

		
		BOOL bNotUpfate;
		BOOL bFind;

		
		
		for (;;)
		{
			bNotUpfate = TRUE;
			bFind = FALSE;
			for(i=0;i<lCountBase;i++)
			{
				HANDLE bWorking;
				CString sFileName;
				CTime time;
				time = time.GetCurrentTime();
				if(massBases[i].sCSVFileName.Right(4)!= ".csv")
					sFileName.Format("%s%s_%s_*.csv",massBases[i].sCataloge,massBases[i].sCSVFileName,time.Format("%d.%m.%Y"));
				else
					sFileName.Format("%s%s",massBases[i].sCataloge,massBases[i].sCSVFileName);
				//WriteToLogFile("Поиск - "+sFileName);
				WIN32_FIND_DATA findData;
				bWorking = FindFirstFile(sFileName,&findData);
				if (bWorking!=INVALID_HANDLE_VALUE)
				{
					
						CString sFile;
						
						bool bContinie;
						bContinie = TRUE;
						do
						{
							CFileStatus FileQuantsStatus;
							long lFileLength;
							sFile = findData.cFileName;
							CFile::GetStatus(massBases[i].sCataloge+sFile,FileQuantsStatus);
							lFileLength = FileQuantsStatus.m_size;
							if(lFileLength > massBases[i].lMinLen)
							{
								sMess.Format("Файл %s %d",sFile,lFileLength);
								WriteToLogFile(sMess);
								bContinie = FALSE;
								break;
							}
						}

						while (FindNextFile(bWorking,&findData)!=0);
						
						if (sFile.GetLength()< 7)
							{
							WriteToLogFile(sFile);
							continue;
							}
							
						if(bContinie)
							continue;


						FindClose(bWorking);
						bool bFTP;
						bFTP = TRUE;
						
						if(massBases[i].iType == 0)
						{
							if(ExistFile(massBases[i].sCataloge+"qnt.csv"))
							{
								try
									{
										CFile::Remove(massBases[i].sCataloge+"qnt.csv");
									}
								catch(...)
									{
										WriteToLogFile("Не возможно удалить - "+massBases[i].sCataloge+"qnt.csv");	
										bFTP = FALSE;
									}
							}
						}
						else
						{
							if(massBases[i].iType != 2)
							if(ExistFile(massBases[i].sCataloge+massBases[i].sRusName))
							{
								try
									{
										CFile::Remove(massBases[i].sCataloge+massBases[i].sRusName);
									}
								catch(...)
									{
										WriteToLogFile("Не возможно удалить - "+massBases[i].sCataloge+massBases[i].sRusName);	
										bFTP = FALSE;
									}
							}

							
							
						
						}



						if(bFTP)
						{
							if(ExistFile(massBases[i].sCataloge+massBases[i].sAchiveName))
							{
								try
									{
										CFile::Remove(massBases[i].sCataloge+massBases[i].sAchiveName);
									}
								catch(...)
									{
										WriteToLogFile("Не возможно удалить - "+massBases[i].sCataloge+massBases[i].sAchiveName);
										bFTP = FALSE;
									}
							}

							if(bFTP)
							{
						
								CFileStatus FileQuantsStatus;
								__int64 lFileLength;
								try
								{
									CFile::GetStatus(massBases[i].sCataloge+sFile,FileQuantsStatus);
									lFileLength = FileQuantsStatus.m_size;
									if(lFileLength <= massBases[i].lMinLen)
									{
										CString tmpStrFL;
										tmpStrFL.Format("%i", lFileLength);

										CString tmpStrML;
										tmpStrML.Format("%i", massBases[i].lMinLen);
										WriteToLogFile("Не достаточная длина файла! - " + massBases[i].sCataloge+sFile + 
											" Длинна: " + tmpStrFL + " <= " + tmpStrML);
										continue;
									}

									if(lFileLength < 1)
										continue;


									Sleep(20000);
									CFile::GetStatus(massBases[i].sCataloge+sFile,FileQuantsStatus);
									if(lFileLength!=FileQuantsStatus.m_size)
										continue;

								}
								catch(...)
								{
									WriteToLogFile("Проблема с длиной - " +massBases[i].sCataloge+sFile);	
									continue;
								}


								try
								{
									if(massBases[i].iType == 0)
									{
										CFile::Rename(massBases[i].sCataloge+sFile,massBases[i].sCataloge+"qnt.csv");
									}
									
									if((massBases[i].iType == 1)||(massBases[i].iType == 3))
									{
										CFile::Rename(massBases[i].sCataloge+sFile,massBases[i].sCataloge+massBases[i].sRusName);
									}
									
								}
								catch(...)
								{
									WriteToLogFile("Не возможно переименовать - "+massBases[i].sCataloge+sFile + " в файл " +
										massBases[i].sCataloge+massBases[i].sRusName);
									bFTP = FALSE;
								}
							
								if(bFTP)
								{
									int iCicle;
									iCicle = 20;
									if(massBases[i].sAchiveName.GetLength()>0)
									{
										CZipArchive archiv;
										archiv.Open(massBases[i].sCataloge+massBases[i].sAchiveName,CZipArchive::create);
										CString sWrite;
										if(massBases[i].iType == 0)
										{
											archiv.AddNewFile(massBases[i].sCataloge+"qnt.csv",5,FALSE);
											
											WriteToLogFile(massBases[i].sKursesFile);
											TCHAR lpTempPathBuffer[MAX_PATH];
											::GetTempPath(MAX_PATH, lpTempPathBuffer);
											CString sTempPath;
											sTempPath = lpTempPathBuffer;
											CopyFile(massBases[i].sKursesFile, sTempPath + "rates.csv", false);

											if (!archiv.AddNewFile(sTempPath + "rates.csv",5,FALSE))
											{
												iCicle = 0;
												WriteToLogFile("Файл курсов не добавлен! - " + sTempPath + "rates.csv" + " - ");
											}
										}
										else
										{
											archiv.AddNewFile(massBases[i].sCataloge+massBases[i].sRusName,5,FALSE);
										}
										archiv.Close();
									}
									
									iColFTP = massBases[i].iColFTP;
									WriteToLogFile("Попытки отправки");
								
									bFind = TRUE;
									bNotUpfate = TRUE;
									while(iColFTP>0)
									{
										iColFTP--;
										iCicle = 20;
									
										while(iCicle>0)	
											{
												FTPAdress = massBases[i].sFTPAdress.ElementAt(iColFTP);
												iCicle = GetUpdate(massBases[i].sCataloge,FTPAdress->sFTPAdress,massBases[i].sRusName,massBases[i].sAchiveName,iCicle,massBases[i].iType, sServer[FTPAdress->iServer].sServerName,sServer[FTPAdress->iServer].sUserName,sServer[FTPAdress->iServer].sPassword);
												if (iCicle>0)	
													Sleep(2000);
											}
										if(iCicle == -100)
											bNotUpfate = FALSE;
									}
									WriteToLogFile("Обработка завершина");
								
									if(!bNotUpfate)
									{
										WriteToLogFile("Remove - " + massBases[i].sCataloge+sFile);

										CString tmpFileName;

										try
										{
											switch(massBases[i].iType)
											{
												case 1:
												case 3:
													tmpFileName = massBases[i].sCataloge + massBases[i].sRusName;
													break;

												case 0:
													tmpFileName = massBases[i].sCataloge + "qnt.csv";
													break;

												case 2:
													tmpFileName = massBases[i].sCataloge + massBases[i].sCSVFileName;
													break;
											}
											CFile::Remove(tmpFileName);
										}
										catch(...)
										{
											WriteToLogFile("Не возможно удалить - " + tmpFileName);
										}
									}
								
									if((iCicle<=0)&&(iCicle!=-100)&&(bNotUpfate))
										{
											try
												{
													if(massBases[i].iType == 0)
													{
														WriteToLogFile("Rename - " + massBases[i].sCataloge+sFile);
														try
														{	
															CFile::Rename(massBases[i].sCataloge+"qnt.csv",massBases[i].sCataloge+sFile);
														}
														catch(...)
														{
															WriteToLogFile("Не возможно переименовать - "+massBases[i].sCataloge+"qnt.csv");	
														}
													}

													if((massBases[i].iType == 1)||(massBases[i].iType == 3))
													{
														WriteToLogFile("Rename - " + massBases[i].sCataloge+sFile);
														try
														{
															CFile::Rename(massBases[i].sCataloge+massBases[i].sRusName,massBases[i].sCataloge+sFile);
														}
														catch(...) 
														{
															WriteToLogFile("Не возможно переименовать - "+massBases[i].sCataloge+massBases[i].sRusName);	
														}
													}
												}
												catch(...)
												{
													WriteToLogFile("Не возможно переименовать - "+massBases[i].sCataloge+"qnt.csv");
												}
										}
								
								}
						}
					
				}
					
				}
				else
					{
						FindClose(bWorking);
					}
				Sleep(200);
				
			}
			if ((bNotUpfate)&&(bFind))
			{
				WriteToLogFile("Ошибка: - служба будет перезапущена!");
				RestartService();
			}
			Sleep(600000);
		}
		delete(sServer);
		delete (massBases);
	}
	catch(...)
	{
		WriteToLogFile("Неизвестная ошибка!!!!!!!!!!");
		throw;
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



CWinApp theApp;
using namespace std;
int _tmain(int argc, TCHAR* argv[], TCHAR* envp[])
{
	
	int nRetCode = 0;
	if (!AfxWinInit(::GetModuleHandle(NULL), NULL, ::GetCommandLine(), 0))
	{
		nRetCode = 1;
		return nRetCode;
	}
	if (argc > 1)
	{
		if (lstrcmpi(argv[1], TEXT("/install"))==0)
		{
			Install();			
		}
		else if (lstrcmpi(argv[1], TEXT("/uninstall"))==0)
		{
			Uninstall();
		}
		else
		{
			DisplayHelp();
		}
		return 0;
	}
	
	SERVICE_TABLE_ENTRY steTable[] = 
	{
		{ServiceName, ServiceMain},
		{NULL, NULL}
	};
	
	//Run();
	StartServiceCtrlDispatcher(steTable);
	return nRetCode;
}


