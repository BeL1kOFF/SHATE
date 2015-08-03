// stdafx.cpp : source file that includes just the standard includes
// NavReport.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"

// TODO: reference any additional headers you need in STDAFX.H
// and not in this file
CString GetErrorText(DWORD *pErr)
{
	void* cstr;
	FormatMessageA(
	FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
		NULL,
		*pErr,
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
		(LPSTR) &cstr,
		0,
		NULL
		);
	CString res((char*)cstr);
	return res;
}