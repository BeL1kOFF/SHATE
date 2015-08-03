// stdafx.cpp : source file that includes just the standard includes
// EI_Prices.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"


CString sReadFromIni(CString strSection, CString strKey, CString sDefValue =_T(""))
{
	CString sPath;
	wchar_t cBuffer[MAX_PATH];
	::GetModuleFileName(NULL, cBuffer, MAX_PATH);
	sPath = cBuffer;
	sPath = sPath.Left(sPath.ReverseFind('\\'));
	if (sPath.Right(1)!="\\") sPath += "\\";

	wchar_t pstrString[MAX_PATH];
	if(!GetPrivateProfileString(strSection, strKey,sDefValue, pstrString,MAX_PATH, sPath+_T("EI_Prices.ini")))
		return _T("");
	CString strString;
	strString =pstrString;

	return strString;
}

bool sWriteToIni(CString strSection, CString strKey, CString sValue)
{
	CString sPath;
	wchar_t cBuffer[MAX_PATH];
	::GetModuleFileName(NULL, cBuffer, MAX_PATH);
	sPath = cBuffer;
	sPath = sPath.Left(sPath.ReverseFind('\\'));
	if (sPath.Right(1)!="\\") sPath += "\\";

	if (WritePrivateProfileString(strSection, strKey, sValue, sPath+_T("EI_Prices.ini")))
		return TRUE;
	else
		return FALSE;
}

CString ReplaceLeftSymbol(CString sSQL, BOOL bAllLeft)
{
	CString sRet;

	int i;
	sSQL = sSQL.MakeUpper();
	if(bAllLeft)
	{
		for(i = 0; i < sSQL.GetLength();i++)
		{
			if(((sSQL[i]>=_T('0'))&&(sSQL[i]<=_T('9')))
				||((sSQL[i]>=_T('A'))&&(sSQL[i]<=_T('Z')))
				||((sSQL[i]>=_T('À'))&&(sSQL[i]<=_T('ß')))
				)
			{
				sRet = sRet + sSQL[i];
			}
		}
	}
	else
	{
		for(i = 0; i < sSQL.GetLength();i++)
		{
			if((sSQL[i]!=_T('_'))&&(sSQL[i]!=_T(' '))&&(sSQL[i]!=_T('\'')))
			{
				sRet = sRet + sSQL[i];
			}
		}
	}



	return sRet;
}

CStringW GetValue(CDBVariant* var)
{
	CString sName;
	if(var->m_dwType==6)
	{
		sName.Format(_T("%.0f"),var->m_dblVal);
	}

	if(var->m_dwType==DBVT_LONG)
	{
		sName.Format(_T("%d"),var->m_lVal);
	}
	if(var->m_dwType==DBVT_SHORT)
	{
		sName.Format(_T("%d"),var->m_iVal);
	}
	if(var->m_dwType==DBVT_ASTRING)
	{
		CStringA stra;
		stra.Format("%s",*var->m_pstringA);
		sName = Convert(stra);
	}
	if(var->m_dwType==DBVT_WSTRING)
	{
	
		sName.Format(_T("%s"),*var->m_pstringW);
	}
	if(var->m_dwType==DBVT_STRING)
	{
		sName.Format(_T("%s"),*var->m_pstring);
	}

	while(sName.Right(1)==_T(" "))
	{
		sName = sName.Left(sName.GetLength()-1);
	}
	return sName;
}

CStringW Convert(CStringA sIN)
{
	CString utf16;
	utf16 ="";
	int len = MultiByteToWideChar(1251, 0, sIN, -1, NULL, 0);
	if (len>1)
	{
		wchar_t *ptr = utf16.GetBuffer(len-1);
		if (ptr) MultiByteToWideChar(1251, 0, sIN, -1, ptr, len);
		utf16.ReleaseBuffer();
	}
	return utf16;
}

long GetValueID(CDBVariant* var)
{
	CString sName;
	if(var->m_dwType==6)
	{
		sName.Format(_T("%.0f"),var->m_dblVal);
	}

	if(var->m_dwType==DBVT_LONG)
	{
		sName.Format(_T("%d"),var->m_lVal);
	}
	if(var->m_dwType==DBVT_SHORT)
	{
		sName.Format(_T("%d"),var->m_iVal);
	}
	if(var->m_dwType==DBVT_ASTRING)
	{
		CStringA stra;
		stra.Format("%s",*var->m_pstringA);
		sName = Convert(stra);
	}
	if(var->m_dwType==DBVT_WSTRING)
	{
		sName.Format(_T("%s"),*var->m_pstringW);
	}
	if(var->m_dwType==DBVT_STRING)
	{
		sName.Format(_T("%s"),*var->m_pstring);
	}
	return _ttoi(sName);
}


CString GetLastErrorText()
{
	void* cstr;
	DWORD dError = GetLastError();
	if(dError > 0)
	{
		FormatMessageA(
		FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
			NULL,
		dError,
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
		(LPSTR) &cstr,
		0,
		NULL
		);
	}
	else
		return _T("");

	CString res((char*)cstr),res1;
	res1.Format(_T("%d - %s"),dError,res);
	LocalFree(cstr);
	return res1;
}


