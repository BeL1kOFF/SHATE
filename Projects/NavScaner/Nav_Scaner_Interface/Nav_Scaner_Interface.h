// Nav_Scaner_Interface.h : main header file for the PROJECT_NAME application
//
#include "IniReader.h"
#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols
#include "newrecordset.h"

// CNav_Scaner_InterfaceApp:
// See Nav_Scaner_Interface.cpp for the implementation of this class
//

class CNav_Scaner_InterfaceApp : public CWinApp
{
public:
	CNav_Scaner_InterfaceApp();
	CNewDatabase *dBaseProg;
	CNewDatabase *dBaseNav;
// Overrides
	public:
	CIniReader IniReader;
	virtual BOOL InitInstance();

// Implementation

	DECLARE_MESSAGE_MAP()
public:	
	BOOL OpenDBProg(CString* sError = NULL);
	BOOL OpenDBNav(CString* sError = NULL);
	void CloseDBProg(void);
	void CloseDBNav(void);

};

extern CNav_Scaner_InterfaceApp theApp;