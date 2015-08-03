// Nav_Scaner_Assembler.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#ifdef STANDARDSHELL_UI_MODEL
#include "resource.h"
#endif
#include "..\Modul\ClientSocket.h"
// CAssemblerApp:
// See Nav_Scaner_Assembler.cpp for the implementation of this class
//

class CAssemblerApp : public CWinApp
{
public:
	CAssemblerApp();
	
// Overrides
public:
	virtual BOOL InitInstance();
	CClientSocket csClientSocket;
// Implementation

	DECLARE_MESSAGE_MAP()
};

extern CAssemblerApp theApp;
