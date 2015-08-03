// Nav_Buh_Expl.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols


// CNav_Buh_ExplApp:
// See Nav_Buh_Expl.cpp for the implementation of this class
//

class CNav_Buh_ExplApp : public CWinApp
{
public:
	CNav_Buh_ExplApp();

// Overrides
	public:
	virtual BOOL InitInstance();

// Implementation

	DECLARE_MESSAGE_MAP()
};

extern CNav_Buh_ExplApp theApp;