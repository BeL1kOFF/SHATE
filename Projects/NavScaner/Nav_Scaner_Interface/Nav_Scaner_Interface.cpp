// Nav_Scaner_Interface.cpp : Defines the class behaviors for the application.
//

#include "stdafx.h"
#include "Nav_Scaner_Interface.h"
#include "Nav_Scaner_InterfaceDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CNav_Scaner_InterfaceApp

BEGIN_MESSAGE_MAP(CNav_Scaner_InterfaceApp, CWinApp)
	ON_COMMAND(ID_HELP, &CWinApp::OnHelp)
END_MESSAGE_MAP()


// CNav_Scaner_InterfaceApp construction

CNav_Scaner_InterfaceApp::CNav_Scaner_InterfaceApp()
{
	dBaseProg = NULL;
	dBaseNav = NULL;
}


// The one and only CNav_Scaner_InterfaceApp object

CNav_Scaner_InterfaceApp theApp;


// CNav_Scaner_InterfaceApp initialization

BOOL CNav_Scaner_InterfaceApp::InitInstance()
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
	CString sPath;
	wchar_t cBuffer[MAX_PATH];
    ::GetModuleFileName(NULL, cBuffer, MAX_PATH);
    sPath = cBuffer;
    sPath = sPath.Left(sPath.ReverseFind('\\'));
	if (sPath.Right(1)!="\\") sPath += "\\";

	CString sFileName = sPath+AfxGetApp()->m_pszProfileName;
	sFileName.MakeLower();
	if(sFileName.Right(4)!=_T(".ini"))
	{
		sFileName = sFileName.Left(sFileName.GetLength()-4);
		sFileName = sFileName + _T(".ini");
	}
	free((void*)AfxGetApp()->m_pszProfileName);
	AfxGetApp()->m_pszProfileName = _tcsdup(sFileName);
	
	IniReader.SetIniFileName();

	OpenDBNav();
	CString sError;
	if(!OpenDBProg(&sError))
	{
		AfxMessageBox(sError);
	}
	else
	{
		CNav_Scaner_InterfaceDlg dlg;
		m_pMainWnd = &dlg;
		INT_PTR nResponse = dlg.DoModal();
		if (nResponse == IDOK)
		{
		
		}
		else if (nResponse == IDCANCEL)
		{
	
		}
	}
	CloseDBProg();
	CloseDBNav();
	// Since the dialog has been closed, return FALSE so that we exit the
	//  application, rather than start the application's message pump.
	return FALSE;
}

BOOL CNav_Scaner_InterfaceApp::OpenDBNav(CString* sError)
{
	if(dBaseNav != NULL)
	{
		CloseDBNav();
	}

	CString sServer;
	CString sName;
	sServer = IniReader.ReadFromIni(_T("DB_NAV"),_T("SERVER"),_T("LOCALHOST"));
	sName = IniReader.ReadFromIni(_T("DB_NAV"),_T("NAME"),_T("Database"));

	dBaseNav = new(CNewDatabase);
	try
	{
		CString sConnect;
		sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sName);
		#ifdef _DEBUG
			sConnect.Format(_T("DSN=svbyprisa0018;UID=RomanK;PWD=bskQWErty432;"));			
		#endif
		dBaseNav->OpenEx(sConnect,CDatabase::noOdbcDialog);
		sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
		dBaseNav->ExecuteSQL(sConnect);
		dBaseNav->SetQueryTimeout(0);
	}
	catch(CDBException *exeption)
	{
		if(sError != NULL)
			sError->Format(_T("%s"),exeption->m_strError);
		exeption->Delete();
		delete(dBaseNav);
		dBaseNav = NULL;
		return FALSE;
	}


	return TRUE;
}

void CNav_Scaner_InterfaceApp::CloseDBNav(void)
{
	if(dBaseNav != NULL)
	{
		if(dBaseNav->IsOpen())
		{
			dBaseNav->Close();
		}
		delete(dBaseNav);
	}
	dBaseNav = NULL;
}


BOOL CNav_Scaner_InterfaceApp::OpenDBProg(CString* sError)
{
	if(dBaseProg != NULL)
	{
		CloseDBProg();
	}

	CString sServer;
	CString sName;
	sServer = IniReader.ReadFromIni(_T("DB"),_T("SERVER"),_T("LOCALHOST"));
	sName = IniReader.ReadFromIni(_T("DB"),_T("NAME"),_T("Database"));

	dBaseProg = new(CNewDatabase);
	CString sConnect;
	try
	{
		
		sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sName);
		#ifdef _DEBUG
			sConnect.Format(_T("DSN=Spbypril0777;UID=Admin2;PWD=Admin2;"));			
		#endif
		dBaseProg->OpenEx(sConnect,CDatabase::noOdbcDialog);
		dBaseProg->SetQueryTimeout(0);
	}
	catch(CDBException *exeption)
	{
		if(sError != NULL)
			sError->Format(_T("%s\n%s"),exeption->m_strError,sConnect);
		exeption->Delete();
		delete(dBaseProg);
		dBaseProg = NULL;
		return FALSE;
	}

	BOOL bOk;
	bOk = TRUE;
	try
	{
		CNewRecordset Query(dBaseProg);
		CString sSQL;
		
		sSQL.Format(_T("select top 1 us.[TYPE],we.[TYPE] from [Users] as us left join [Warehouse Employee]as we on we.[User ID] = us.[User ID] where us.[User ID] = '%s' and (us.[TYPE] %% 11 = 0 or we.[TYPE] %% 11 = 0)"),GetWinUserName());
		#ifdef _DEBUG
			sSQL.Format(_T("select top 1 us.[TYPE],we.[TYPE] from [Users] as us left join [Warehouse Employee]as we on we.[User ID] = us.[User ID] where us.[User ID] = '%s' and (us.[TYPE] %% 11 = 0 or we.[TYPE] %% 11 = 0)"),_T("KUSHEL"));		
		#endif
		Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
		if(Query.IsEOF())
		{
			if(sError != NULL)
			{
				sError->Format(_T("Доступ запрещен!"));
				Query.Close();
				bOk = FALSE;
			}
			
		}
		Query.Close();

	}
	catch(CDBException *exeption)
	{
		if(sError != NULL)
			sError->Format(_T("%s"),exeption->m_strError);
		exeption->Delete();
		if(dBaseProg->IsOpen())
					dBaseProg->Close();
		delete(dBaseProg);
		dBaseProg = NULL;
		return FALSE;
	}

	if(!bOk)
	{
		if(dBaseProg->IsOpen())
					dBaseProg->Close();
		delete(dBaseProg);
		dBaseProg = NULL;
	}
	return bOk;
}

void CNav_Scaner_InterfaceApp::CloseDBProg(void)
{
	if(dBaseProg != NULL)
	{
		if(dBaseProg->IsOpen())
		{
			dBaseProg->Close();
		}
		delete(dBaseProg);
	}
	dBaseProg = NULL;
}
