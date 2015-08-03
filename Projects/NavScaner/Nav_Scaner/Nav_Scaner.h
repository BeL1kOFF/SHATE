// Nav_Scaner.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#ifdef STANDARDSHELL_UI_MODEL
#include "resource.h"
#endif

#include "ClientSocket.h"

// CNav_ScanerApp:
// See Nav_Scaner.cpp for the implementation of this class
//

class CNav_ScanerApp : public CWinApp
{
public:
	CNav_ScanerApp();
// Overrides
public:
	CString GetVersion(void);
	virtual BOOL InitInstance();
	CClientSocket csClientSocket;
// Implementation

	DECLARE_MESSAGE_MAP()
	
};

extern CNav_ScanerApp theApp;
