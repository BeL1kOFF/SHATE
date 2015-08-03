// RepScan.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols
#include "afxdb.h"

// CRepScanApp:
// See RepScan.cpp for the implementation of this class
//

class CRepScanApp : public CWinApp
{
public:
	CRepScanApp();

// Overrides
	public:
	virtual BOOL InitInstance();
	CDatabase* dBase;
// Implementation

	DECLARE_MESSAGE_MAP()
	
};

extern CRepScanApp theApp;