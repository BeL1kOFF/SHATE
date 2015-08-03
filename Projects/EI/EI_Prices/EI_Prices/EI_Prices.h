// EI_Prices.h : main header file for the PROJECT_NAME application
//

#pragma once

#ifndef __AFXWIN_H__
	#error "include 'stdafx.h' before including this file for PCH"
#endif

#include "resource.h"		// main symbols


// CEI_PricesApp:
// See EI_Prices.cpp for the implementation of this class
//

class CEI_PricesApp : public CWinApp
{
public:
	CEI_PricesApp();

// Overrides
	public:
	virtual BOOL InitInstance();

// Implementation

	DECLARE_MESSAGE_MAP()
};

extern CEI_PricesApp theApp;