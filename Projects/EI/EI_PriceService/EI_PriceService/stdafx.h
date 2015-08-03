// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once
#define _AFXDLL
#include "targetver.h"

#include <stdio.h>
#include <tchar.h>
#define _ATL_CSTRING_EXPLICIT_CONSTRUCTORS      // some CString constructors will be explicit

#ifndef VC_EXTRALEAN
#define VC_EXTRALEAN            // Exclude rarely-used stuff from Windows headers
#endif

#include <afx.h>
#include <afxwin.h>         // MFC core and standard components
#include <afxext.h>         // MFC extensions
#ifndef _AFX_NO_OLE_SUPPORT
#include <afxdtctl.h>           // MFC support for Internet Explorer 4 Common Controls
#endif
#ifndef _AFX_NO_AFXCMN_SUPPORT
#include <afxcmn.h>                     // MFC support for Windows Common Controls
#endif // _AFX_NO_AFXCMN_SUPPORT

#include <iostream>
#include "afxdb.h"
//#pragma comment (lib, "D:\\Work\\ServiceExist\\zlib.lib")
#pragma comment (lib, "D:\\Work\\EI_PriceService2\\EI_PriceService\\zip\\zlib.lib");

// TODO: reference additional headers your program requires here
long GetValueID(CDBVariant* var);
CString GetValue(CDBVariant* var);
CStringW Convert(CStringA sIN);

CString ReplaceLeftSymbol(CString sSQL, BOOL bAllLeft = TRUE);
CString GetLastErrorText();
CString GetErrorText(DWORD *pErr);
CString sReadFromIni(CString strSection, CString strKey, CString sDefValue);
bool sWriteToIni(CString strSection, CString strKey, CString sValue);

void WriteToLogFile(CString sWrite);

