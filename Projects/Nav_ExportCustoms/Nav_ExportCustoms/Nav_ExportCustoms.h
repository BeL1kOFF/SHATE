// Nav_ExportCustoms.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols


// CNav_ExportCustomsApp:
// See Nav_ExportCustoms.cpp for the implementation of this class
//

class CNav_ExportCustomsApp : public CWinApp
{
public:
	CNav_ExportCustomsApp();

// Overrides
	public:
	virtual BOOL InitInstance();

// Implementation

	DECLARE_MESSAGE_MAP()
};

extern CNav_ExportCustomsApp theApp;