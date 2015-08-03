// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently,
// but are changed infrequently

#pragma once

#ifndef _SECURE_ATL
#define _SECURE_ATL 1
#endif

#ifndef VC_EXTRALEAN
#define VC_EXTRALEAN            // Exclude rarely-used stuff from Windows headers
#endif

#include "targetver.h"

#define _ATL_CSTRING_EXPLICIT_CONSTRUCTORS      // some CString constructors will be explicit

// turns off MFC's hiding of some common and often safely ignored warning messages
#define _AFX_ALL_WARNINGS

#include <afxwin.h>         // MFC core and standard components
#include <afxext.h>         // MFC extensions


#include <afxdisp.h>        // MFC Automation classes



#ifndef _AFX_NO_OLE_SUPPORT
#include <afxdtctl.h>           // MFC support for Internet Explorer 4 Common Controls
#endif
#ifndef _AFX_NO_AFXCMN_SUPPORT
#include <afxcmn.h>                     // MFC support for Windows Common Controls
#endif // _AFX_NO_AFXCMN_SUPPORT

#include "afxdb.h"







#ifdef _UNICODE
#if defined _M_IX86
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='x86' publicKeyToken='6595b64144ccf1df' language='*'\"")
#elif defined _M_IA64
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='ia64' publicKeyToken='6595b64144ccf1df' language='*'\"")
#elif defined _M_X64
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='amd64' publicKeyToken='6595b64144ccf1df' language='*'\"")
#else
#pragma comment(linker,"/manifestdependency:\"type='win32' name='Microsoft.Windows.Common-Controls' version='6.0.0.0' processorArchitecture='*' publicKeyToken='6595b64144ccf1df' language='*'\"")
#endif
#endif

//#import "C:\Program Files\Common Files\Microsoft Shared\OFFICE14\MSO.DLL"
#import "c:\Program Files (x86)\Common Files\Microsoft Shared\OFFICE14\MSO.DLL" 

//#import "C:\Program Files\Common Files\Microsoft Shared\VBA\VBA6\VBE6EXT.OLB"
#import "c:\Program Files (x86)\Common Files\Microsoft Shared\VBA\VBA6\VBE6EXT.OLB"

//#import "C:\Program Files\Microsoft Office\OFFICE14\EXCEL.EXE" 
#import "c:\Program Files (x86)\Microsoft Office\Office14\EXCEL.EXE" \
        rename("DialogBox","_DialogBox") \
        rename("RGB","_RGB") \
        exclude("IFont","IPicture")
    
CString GetLastErrorText();
CString GetErrorText(DWORD *pErr);

CString sReadFromIni(CString strSection, CString strKey, CString sDefValue);
bool sWriteToIni(CString strSection, CString strKey, CString sValue);
CStringW GetWinUserName();
CStringW Convert(CStringA sIN);
CStringW GetValue(CDBVariant* var);
CString sReplaceLeftSynmbol(CString sData);
CString GetSummPropis(int iValue);
CString GetNumPropis(int iValue,int iStep);