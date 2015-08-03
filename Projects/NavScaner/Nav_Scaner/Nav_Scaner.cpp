// Nav_Scaner.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "Nav_Scaner.h"
#include "Nav_ScanerDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif

#include "c:\\Program Files (x86)\\Windows CE Tools\\wce500\\datalogicWINCE5\\Include\\Armv4i\\BBCR_Parameters.h"
#include "c:\\Program Files (x86)\\Windows CE Tools\\wce500\\datalogicWINCE5\\Include\\Armv4i\\BCD_Parameters.h"
#include "c:\\Program Files (x86)\\Windows CE Tools\\wce500\\datalogicWINCE5\\Include\\Armv4i\\DL_SEDAPI.h"
#include "C:\\Program Files (x86)\\Windows CE Tools\\wce500\\datalogicWINCE5\\Include\\Armv4i\\SCAN_PARAMETERS.H"


// CNav_ScanerApp

BEGIN_MESSAGE_MAP(CNav_ScanerApp, CWinApp)
END_MESSAGE_MAP()


// CNav_ScanerApp construction
CNav_ScanerApp::CNav_ScanerApp()
	: CWinApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only CNav_ScanerApp object
CNav_ScanerApp theApp;

// CNav_ScanerApp initialization

BOOL CNav_ScanerApp::InitInstance()
{
	CString sNameProgramm;
	sNameProgramm = _T("ScanerApp");

	HANDLE mtx;
	SetRegistryKey(sNameProgramm);

	mtx=CreateMutex(NULL, TRUE, sNameProgramm);
	int res = WaitForSingleObject(mtx, 1);
    if (res != WAIT_OBJECT_0)
	{
		ReleaseMutex(mtx);
		AfxMessageBox(_T("Программа уже запущенна!"),0,0);
		return FALSE;
	}
	try
	{
		#pragma pack (1)
	       struct PostambleString
		       {
			       unsigned long m_nLength;
			       TCHAR m_sText[_MAX_PATH];
		       };
		DLScannerSetup oSetup;	

		int iStatus;
		oSetup.setParameter(SCAN_PARAM_REMOVE_NOTPRINTABLE_CHAR,SCAN_PARAM_DISABLE);
		iStatus = oSetup.getStatus();
		if (iStatus != DLScannerSetup::s_nOK)
		{
			AfxMessageBox(_T("Ошибка"),0,0);
	    }
		CString sBeep;
		sBeep = _T("Beep.wav");
		
		
		PostambleString psMusic;
		unsigned long nLen = (wcslen(sBeep)<=_MAX_PATH)? wcslen(sBeep):MAX_PATH;
		memcpy(psMusic.m_sText, sBeep, nLen*sizeof(TCHAR));
		psMusic.m_nLength = nLen;

		oSetup.setParameterByReference(SCAN_PARAM_GOOD_READ_SOUND_FILE,&psMusic);
		iStatus = oSetup.getStatus();
		if (iStatus != DLScannerSetup::s_nOK)
		{
			AfxMessageBox(_T("Ошибка"),0,0);
	    }
		CString szText = _T("\r\n");

		PostambleString oText;
		unsigned long nLength = (wcslen(szText)<=_MAX_PATH)? wcslen(szText):MAX_PATH;
		memcpy(oText.m_sText, szText, nLength*sizeof(TCHAR));
		oText.m_nLength = nLength;
		
		int nParamID = -1;
	    if (oSetup.getReaderIdentifier() == SE_READER_BBCR_CLASS_ID)
		   {
              nParamID = BBCR_PARAM_POSTAMBLE_STRING;
			}
		else if (oSetup.getReaderIdentifier() == SE_READER_BCD_CLASS_ID)
	       {
              nParamID = BCD_PARAM_POSTAMBLE_STRING;
	       }

		if (nParamID != -1)
			{
				oSetup.setParameterByReference (nParamID, &oText);
				int iStatus;
				iStatus = oSetup.getStatus();
				if (iStatus != DLScannerSetup::s_nOK)
				{
					AfxMessageBox(_T("Ошибка"),0,0);
	            }
			}

	
			csClientSocket.sMessage = "";
			csClientSocket.sProtokol = "TCP";
			csClientSocket.iPort = _wtoi(ReadStringFromIni(_T("CONNECT"),_T("PORT"),_T("0")));
			csClientSocket.sIP = ReadStringFromIni(_T("CONNECT"),_T("IP"),_T("127.0.0.1"));

			HCURSOR Cursor;
			Cursor = GetCursor();
			SetCursor(LoadCursor(IDC_WAIT));
			if (!csClientSocket.StartServer()) 	
			{
				AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+csClientSocket.sMessage, MB_OK,0);	
				csClientSocket.CloseSocket();
				SetCursor(Cursor);
			}
			else
				SetCursor(Cursor);

			CNav_ScanerDlg dlg;
			m_pMainWnd = &dlg;
			INT_PTR nResponse = dlg.DoModal();

	}
	catch(CException *e)
		{
			int iCode;
			iCode = GetLastError();
			CString s;
			s.Format(_T("ошибка: %d -  s"),iCode,GetErrorText(iCode));
			AfxMessageBox(s, MB_OK,0);	
			e->Delete();
			ReleaseMutex(mtx);
			CloseHandle(mtx);
			csClientSocket.CloseSocket();
			return FALSE;

		}
	csClientSocket.CloseSocket();
	ReleaseMutex(mtx);
	CloseHandle(mtx);
	return FALSE;
}

CString CNav_ScanerApp::GetVersion(void)
{
	CString sFileName;
	wchar_t cBuffer[MAX_PATH];
    ::GetModuleFileName(NULL, cBuffer, MAX_PATH);
    sFileName = cBuffer;

    DWORD dwHandle;
    DWORD dwSize = ::GetFileVersionInfoSize(cBuffer, &dwHandle);
    ASSERT(dwSize);
    CString strVersion; // результат
    if (dwSize)
    {
        TCHAR* lpData = new TCHAR[dwSize];
        ASSERT(lpData);
        if (lpData)
        {
            ::GetFileVersionInfo(cBuffer, dwHandle, dwSize, lpData);
            UINT uBufLen;
            VS_FIXEDFILEINFO* lpfi;
            VERIFY(::VerQueryValue(lpData, _T("\\"), (void**)&lpfi, &uBufLen));
            strVersion.Format( _T("%d.%d.%d.%d"),
                lpfi->dwFileVersionMS >> 16,
                lpfi->dwFileVersionMS & 0xFFFF,
                lpfi->dwFileVersionLS >> 16,
                lpfi->dwFileVersionLS & 0xFFFF);
            delete[] lpData;
        }
    }
    return strVersion;
}
