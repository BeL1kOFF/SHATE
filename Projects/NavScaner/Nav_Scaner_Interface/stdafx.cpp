// stdafx.cpp : source file that includes just the standard includes
// Nav_Scaner_Interface.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"


CStringW GetWinUserName()
{
	#ifdef _DEBUG
			return _T("KUSHEL");			
	#endif

	wchar_t buffer[257];		// буфер
	DWORD size;			// размер
	size=sizeof(buffer);		// размер буфера
	if (GetUserName(buffer,&size)==0)
		throw "Error GetWinUserName";	// при ошибке функция вернет 0
	return buffer;
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
		if(sName.Left(1)==_T("."))
		{
			sName = _T("0")+sName;
			/*try
			{
				WriteToLogFile(sName);
				double fl;
				fl = _wtofmy(sName);
				sName.Replace(_T(","),_T("."));
				if(fl < _wtofmy(sName))
					fl = _wtofmy(sName);
				sName.Format(_T("%.3f"),fl);
				WriteToLogFile(sName);

			}
			catch(...)
			{
				sName.Format(_T("%s"),*var->m_pstringW);
			}*/
		}
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

CString ReplaceLeftSymbols(CString sVal, int iType)
{
	int i;
	CString sRet;
	switch(iType)
	{
		case 0:
			for(i=0;i<sVal.GetLength();i++)
			{
				if(
					((sVal[i]>='0')&&(sVal[i]<='9'))
					||((sVal[i]>='A')&&(sVal[i]<='Z'))
					||((sVal[i]>='А')&&(sVal[i]<='Я'))
					||((sVal[i]>='a')&&(sVal[i]<='z'))
					||((sVal[i]>='а')&&(sVal[i]<='я'))
					)
					sRet = sRet+sVal[i];
			}
			break;

		case 1:
			for(i=0;i<sVal.GetLength();i++)
			{
				if(
					((sVal[i]>=_T('0'))&&(sVal[i]<=_T('9')))
					||((sVal[i]>=_T('A'))&&(sVal[i]<=_T('Z')))
					||((sVal[i]>=_T('А'))&&(sVal[i]<=_T('Я')))
					||((sVal[i]>=_T('a'))&&(sVal[i]<=_T('z')))
					||((sVal[i]>=_T('а'))&&(sVal[i]<=_T('я')))
					||(sVal[i]==' ')
					)
					sRet = sRet+sVal[i];
			}
			break;

		case 2:
			for(i=0;i<sVal.GetLength();i++)
			{
				if(
					((sVal[i]>=_T('0'))&&(sVal[i]<=_T('9')))
					||((sVal[i]>=_T('A'))&&(sVal[i]<=_T('Z')))
					||((sVal[i]>=_T('А'))&&(sVal[i]<=_T('Я')))
					||((sVal[i]>=_T('a'))&&(sVal[i]<=_T('z')))
					||((sVal[i]>=_T('а'))&&(sVal[i]<=_T('я')))
					||(sVal[i]==' ')
					||(sVal[i]==',')
					||(sVal[i]=='.')
					||(sVal[i]=='_')
					||(sVal[i]=='-')
					)
					sRet = sRet+sVal[i];
			}
			break;
		case 3:
			if(sCodeString.GetLength()<2)
			{
				sCodeString ="";
				int i;
				for(i=_T('А');i<=_T('Я');i++)
					{
						wchar_t wchar;	
						wchar = i;
						sCodeString =sCodeString + wchar;
					}
				for(i=_T('а');i<=_T('я');i++)
					{
						wchar_t wchar;	
						wchar = i;
						sCodeString =sCodeString + wchar;
					}
				for(i=_T('A');i<=_T('Z');i++)
					{
						wchar_t wchar;	
						wchar = i;
						sCodeString =sCodeString + wchar;
					}
				for(i=_T('a');i<=_T('z');i++)
					{
						wchar_t wchar;	
						wchar = i;
						sCodeString =sCodeString + wchar;
					}
				for(i=_T('0');i<=_T('9');i++)
					{
						wchar_t wchar;	
						wchar = i;
						sCodeString =sCodeString + wchar;
					}
				
				wchar_t wchar;	
				wchar = _T(' ');
				sCodeString =sCodeString + wchar;
				wchar = _T('!');
				sCodeString =sCodeString + wchar;
				wchar = _T('?');
				sCodeString =sCodeString + wchar;
				wchar = _T('.');
				sCodeString =sCodeString + wchar;
				wchar = _T('-');
				sCodeString =sCodeString + wchar;
				wchar = _T('+');
				sCodeString =sCodeString + wchar;
				wchar = _T('_');
				sCodeString =sCodeString + wchar;
				wchar = _T('*');
				sCodeString =sCodeString + wchar;
				wchar = _T('/');
				sCodeString =sCodeString + wchar;
				wchar = _T('\n');
				sCodeString =sCodeString + wchar;
				wchar = _T('|');
				sCodeString =sCodeString + wchar;
				wchar = _T(')');
				sCodeString =sCodeString + wchar;
				wchar = _T('(');
				sCodeString =sCodeString + wchar;
				wchar = _T(',');
				sCodeString =sCodeString + wchar;
				wchar = _T('&');
				sCodeString =sCodeString + wchar;
				wchar = _T('=');
				sCodeString =sCodeString + wchar;
			}
			for(i=0;i<sVal.GetLength();i++)
			{
				if(sCodeString.Find(sVal[i],0)>-1)
					sRet = sRet+sVal[i];
			}

			break;
	
	}
	return sRet;
}
