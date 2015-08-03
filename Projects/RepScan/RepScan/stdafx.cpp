// stdafx.cpp : source file that includes just the standard includes
// RepScan.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"
   
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

CStringW GetWinUserName()
{
	wchar_t buffer[257];		// буфер
	DWORD size;			// размер
	size=sizeof(buffer);		// размер буфера
	if (GetUserName(buffer,&size)==0)
		throw "Error GetWinUserName";	// при ошибке функци€ вернет 0
	return buffer;
}

CStringW sMounthName(CStringW id)
{
	if(id ==_T("01"))
	{
		return _T("€нварь");
	}

	if(id ==_T("02"))
	{
		return _T("февраль");
	}

	if(id ==_T("03"))
	{
		return _T("март");
	}

	if(id ==_T("04"))
	{
		return _T("апрель");
	}

	if(id ==_T("05"))
	{
		return _T("май");
	}

	if(id ==_T("06"))
	{
		return _T("июнь");
	}

	if(id ==_T("07"))
	{
		return _T("июль");
	}

	if(id ==_T("08"))
	{
		return _T("август");
	}

	if(id ==_T("09"))
	{
		return _T("сент€брь");
	}

	if(id ==_T("10"))
	{
		return _T("окт€брь");
	}

	if(id ==_T("11"))
	{
		return _T("но€брь");
	}

	if(id ==_T("12"))
	{
		return _T("декабрь");
	}

	return _T("");
}

CStringW GetMountID(CStringW id)
{
	if(id ==_T("€нварь"))
	{
		return _T("01");
	}

	if(id == _T("февраль"))
	{
		return  _T("02");
	}

	if(id ==_T("март"))
	{
		return _T("03");
	}

	if(id == _T("апрель"))
	{
		return _T("04");
	}

	if(id ==_T("май"))
	{
		return _T("05");
	}

	if(id == _T("июнь"))
	{
		return _T("06");
	}

	if(id == _T("июль"))
	{
		return _T("07");
	}

	if(id == _T("август"))
	{
		return _T("08");
	}

	if(id == _T("сент€брь"))
	{
		return _T("09");
	}

	if(id == _T("окт€брь"))
	{
		return _T("10");
	}

	if(id == _T("но€брь"))
	{
		return _T("11");
	}

	if(id == _T("декабрь"))
	{
		return _T("12");
	}

	return _T("");
}
