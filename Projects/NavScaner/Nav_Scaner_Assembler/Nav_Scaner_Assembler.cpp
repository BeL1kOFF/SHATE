// Nav_Scaner_Assembler.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "Nav_Scaner_Assembler.h"
#include "AssemblerDlg.h"

#include "c:\\Program Files (x86)\\Windows CE Tools\\wce500\\datalogicWINCE5\\Include\\Armv4i\\BBCR_Parameters.h"
#include "c:\\Program Files (x86)\\Windows CE Tools\\wce500\\datalogicWINCE5\\Include\\Armv4i\\BCD_Parameters.h"
#include "c:\\Program Files (x86)\\Windows CE Tools\\wce500\\datalogicWINCE5\\Include\\Armv4i\\DL_SEDAPI.h"
#include "C:\\Program Files (x86)\\Windows CE Tools\\wce500\\datalogicWINCE5\\Include\\Armv4i\\SCAN_PARAMETERS.H"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CAssemblerApp

BEGIN_MESSAGE_MAP(CAssemblerApp, CWinApp)
END_MESSAGE_MAP()


// CAssemblerApp construction
CAssemblerApp::CAssemblerApp()
	: CWinApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only CAssemblerApp object
CAssemblerApp theApp;

// CAssemblerApp initialization

BOOL CAssemblerApp::InitInstance()
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
		sBeep = _T("");
		
		
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
			CAssemblerDlg dlg;
			m_pMainWnd = &dlg;
			INT_PTR nResponse = dlg.DoModal();
			if (nResponse == IDOK)
			{
				
			}

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
