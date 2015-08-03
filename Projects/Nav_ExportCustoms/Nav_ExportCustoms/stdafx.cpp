// stdafx.cpp : source file that includes just the standard includes
// Nav_ExportCustoms.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"


CStringW GetWinUserName()
{
	wchar_t buffer[257];		// буфер
	DWORD size;			// размер
	size=sizeof(buffer);		// размер буфера
	if (GetUserName(buffer,&size)==0)
		throw "Error GetWinUserName";	// при ошибке функция вернет 0
	return buffer;
}

CString sReadFromIni(CString strSection, CString strKey, CString sDefValue =_T(""))
{
	wchar_t pstrString[MAX_PATH];
	CString sFileName;
	sFileName = AfxGetApp()->m_pszProfileName;
	sFileName.MakeLower();
	
	if(!GetPrivateProfileString(strSection, strKey,sDefValue, pstrString,MAX_PATH, sFileName))
		return sDefValue;
	CString strString;
	strString =pstrString;

	return strString;
}

bool sWriteToIni(CString strSection, CString strKey, CString sValue)
{
	CString sFileName;
	sFileName = AfxGetApp()->m_pszProfileName;
	sFileName.MakeLower();
	if (WritePrivateProfileString(strSection, strKey, sValue, sFileName))
		return TRUE;
	else
		return FALSE;
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


CStringW GetValue(CDBVariant* var)
{
	CString sName;
	if(var->m_dwType==6)
	{
		sName.Format(_T("%.0f"),var->m_dblVal);
	}

	if (var->m_dwType == DBVT_DATE)
	{
		TIMESTAMP_STRUCT * times = var->m_pdate;
		CString sDay, sMonth;
		if(times->day < 10)
		{
			sDay.Format(_T("0%d"),times->day);
		}
		else
		{
			sDay.Format(_T("%d"),times->day);
		}

		if(times->month < 10)
		{
			sMonth.Format(_T("0%d"),times->month);
		}
		else
		{
			sMonth.Format(_T("%d"),times->month);
		}

		sName.Format(_T("%s.%s.%d"),sDay, sMonth,times->year);
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
