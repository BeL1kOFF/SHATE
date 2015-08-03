// Nav_Buh_Expl.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "Nav_Buh_Expl.h"
#include "Nav_Buh_ExplDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CNav_Buh_ExplApp

BEGIN_MESSAGE_MAP(CNav_Buh_ExplApp, CWinApp)
	ON_COMMAND(ID_HELP, &CWinApp::OnHelp)
END_MESSAGE_MAP()


// CNav_Buh_ExplApp construction

CNav_Buh_ExplApp::CNav_Buh_ExplApp()
{
	// TODO: add construction code here,
	// Place all significant initialization in InitInstance
}


// The one and only CNav_Buh_ExplApp object

CNav_Buh_ExplApp theApp;


// CNav_Buh_ExplApp initialization

BOOL CNav_Buh_ExplApp::InitInstance()
{
	// InitCommonControlsEx() is required on Windows XP if an application
	// manifest specifies use of ComCtl32.dll version 6 or later to enable
	// visual styles.  Otherwise, any window creation will fail.
	INITCOMMONCONTROLSEX InitCtrls;
	InitCtrls.dwSize = sizeof(InitCtrls);
	// Set this to include all the common control classes you want to use
	// in your application.
	InitCtrls.dwICC = ICC_WIN95_CLASSES;
	InitCommonControlsEx(&InitCtrls);

	CWinApp::InitInstance();

	AfxEnableControlContainer();

	// Standard initialization
	// If you are not using these features and wish to reduce the size
	// of your final executable, you should remove from the following
	// the specific initialization routines you do not need
	// Change the registry key under which our settings are stored
	// TODO: You should modify this string to be something appropriate
	// such as the name of your company or organization
	SetRegistryKey(_T("Local AppWizard-Generated Applications"));

	CString sPath;
	wchar_t cBuffer[MAX_PATH];
    ::GetModuleFileName(NULL, cBuffer, MAX_PATH);
    sPath = cBuffer;
    sPath = sPath.Left(sPath.ReverseFind('\\'));
	if (sPath.Right(1)!="\\") sPath += "\\";

	CString sFileName;
	sFileName = AfxGetApp()->m_pszProfileName;
	sFileName.MakeLower();
	if(sFileName.Right(4)!=_T(".ini"))
		sFileName = sFileName + _T(".ini");
	free((void*)AfxGetApp()->m_pszProfileName);
	AfxGetApp()->m_pszProfileName = _tcsdup(sPath+sFileName);

	
	CNav_Buh_ExplDlg dlg;
	m_pMainWnd = &dlg;
	CoInitializeEx(0, COINIT_MULTITHREADED);
	INT_PTR nResponse = dlg.DoModal();
	CoUninitialize();
	if (nResponse == IDOK)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with OK
	}
	else if (nResponse == IDCANCEL)
	{
		// TODO: Place code here to handle when the dialog is
		//  dismissed with Cancel
	}

	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}
