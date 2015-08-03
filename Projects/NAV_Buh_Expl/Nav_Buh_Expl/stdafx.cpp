// stdafx.cpp : source file that includes just the standard includes
// Nav_Buh_Expl.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"


CString GetLastErrorText()
{
	
	DWORD Err = GetLastError();
	return GetErrorText(&Err);
}

CString GetNumPropis(int iValue,int iStep)
{
	
	CString sRet;
	int iSot;
	iSot = iValue/100;
	iValue = iValue - iSot*100;
	int iDes;
	iDes = iValue/10;
	int iEd;
	iEd = iValue%10;
	sRet = "";
	switch(iSot)
	{
		case 1:
			sRet = sRet + _T(" ��� ");
			break;

		case 2:
			sRet = sRet + _T(" ������ ");
			break;

		case 3:
			sRet = sRet + _T(" ������ ");
			break;
	
		case 4:
			sRet = sRet + _T(" ��������� ");
			break;

		case 5:
			sRet = sRet + _T(" ������� ");
			break;

		case 6:
			sRet = sRet + _T(" �������� ");
			break;

		case 7:
			sRet = sRet + _T(" ������� ");
			break;

		case 8:
			sRet = sRet + _T(" ��������� ");
			break;
		case 9:
			sRet = sRet + _T(" ��������� ");
			break;
	}

	switch(iDes)
	{
		case 2:
			sRet = sRet + _T(" �������� ");
			break;

		case 3:
			sRet = sRet + _T(" �������� ");
			break;

		case 4:
			sRet = sRet + _T(" ����� ");
			break;
	
		case 5:
			sRet = sRet + _T(" ��������� ");
			break;

		case 6:
			sRet = sRet + _T(" ���������� ");
			break;

		case 7:
			sRet = sRet + _T(" ��������� ");
			break;

		case 8:
			sRet = sRet + _T(" ����������� ");
			break;

		case 9:
			sRet = sRet + _T(" ��������� ");
			break;
		
		case 1:
			switch(iEd)
			{
			case 0:
				sRet = sRet + _T(" ������ ");
				break;
			case 1:
				sRet = sRet + _T(" ����������� ");
				break;
			case 2:
				sRet = sRet + _T(" ���������� ");
				break;
			case 3:
				sRet = sRet + _T(" ���������� ");
				break;
			case 4:
				sRet = sRet + _T(" ������������ ");
				break;
			case 5:
				sRet = sRet + _T(" ���������� ");
				break;
			case 6:
				sRet = sRet + _T(" ����������� ");
				break;
			case 7:
				sRet = sRet + _T(" ���������� ");
				break;
			case 8:
				sRet = sRet + _T(" ������������ ");
				break;
			case 9:
				sRet = sRet + _T(" ������������ ");
				break;
			}
			break;
	}

	if(iDes != 1)
	{
	switch(iEd)
	{
		case 1:
			switch(iStep)
			{
				case 1:
					sRet = sRet + _T(" ���� ");
					break;
				default:
					sRet = sRet + _T(" ���� ");
					break;
			}
			break;

		case 2:
			switch(iStep)
			{
				case 1:
					sRet = sRet + _T(" ��� ");
					break;
				default:
				sRet = sRet + _T(" ��� ");
				break;
			}
			break;

		case 3:
			sRet = sRet + _T(" ��� ");
			break;
	
		case 4:
			sRet = sRet + _T(" ������ ");
			break;

		case 5:
			sRet = sRet + _T(" ���� ");
			break;

		case 6:
			sRet = sRet + _T(" ����� ");
			break;

		case 7:
			sRet = sRet + _T(" ���� ");
			break;

		case 8:
			sRet = sRet + _T(" ������ ");
			break;
		case 9:
			sRet = sRet + _T(" ������ ");
			break;
	}
	}
	
	switch(iStep)
	{
		case 1:
			if(iDes != 1)
			{
				switch(iEd)
				{
					case 1:
						sRet = sRet + _T(" ������ ");
						break;

					case 2:
					case 3:
					case 4:
						sRet = sRet + _T(" ������ ");
						break;

					default:
						sRet = sRet + _T(" ����� ");
						break;
				}
			}
			else
				sRet = sRet + _T(" ����� ");
			break;

		case 2:
			if(iDes != 1)
			{
				
				switch(iEd)
				{
					case 1:
						sRet = sRet + _T(" ������� ");
						break;

					case 2:
					case 3:
					case 4:
						sRet = sRet + _T(" �������� ");
						break;

					default:
						sRet = sRet + _T(" ��������� ");
						break;
				}
			}
			else
				sRet = sRet + _T(" ��������� ");
			break;
			
			
		case 3:
			if(iDes != 1)
			{
				switch(iEd)
				{
					case 1:
						sRet = sRet + _T(" �������� ");
						break;

					case 2:
					case 3:
					case 4:
						sRet = sRet + _T(" ��������� ");
						break;

					default:
						sRet = sRet + _T(" ���������� ");
						break;
				}
			}
			else
				sRet = sRet + _T(" ���������� ");
			break;
	}
	//��������
	sRet.Replace(_T("  "),_T(" "));


	return sRet;
}

CString GetSummPropis(int iValue)
{
	CString sValue;
	int iStep;
	iStep = 0;
	int iSave;
	iSave = iValue%100;
	sValue.Format(_T(""));
	while(iValue > 0)
	{
		sValue = GetNumPropis(iValue%1000,iStep) + sValue;
		iValue = iValue/1000;
		iStep++;
	}

	if(iSave%10 != 1)
	{
		switch(iSave%10)
		{
			case 1:
				sValue = sValue + _T(" �����");
				break;

			case 2:
			case 3:
			case 4:
				sValue = sValue + _T(" �����");
				break;
	
			default:
				sValue = sValue + _T(" ������");
				break;
		}
	}
	else
	{
		sValue = sValue + _T(" ������");
	}
	sValue.Replace(_T("  "),_T(" "));

	return sValue;
}

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

CString sReadFromIni(CString strSection, CString strKey, CString sDefValue =_T(""))
{
	CString sFileName;
	sFileName = AfxGetApp()->m_pszProfileName;
	sFileName.MakeLower();

	wchar_t pstrString[MAX_PATH];
	if(!GetPrivateProfileString(strSection, strKey,sDefValue, pstrString,MAX_PATH, sFileName))
		return _T("");
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

CStringW GetWinUserName()
{
	wchar_t buffer[257];		// �����
	DWORD size;			// ������
	size=sizeof(buffer);		// ������ ������
	if (GetUserName(buffer,&size)==0)
		throw "Error GetWinUserName";	// ��� ������ ������� ������ 0
	return buffer;
}

CStringW Convert2(char* chArray)
{
	CString utf16;
	utf16 ="";
	int len = MultiByteToWideChar(0, 1251, chArray, -1, NULL, 0);
	if (len>1)
	{
		wchar_t *ptr = utf16.GetBuffer(len-1);
		if (ptr) MultiByteToWideChar(0, 1251, chArray, -1, ptr, len);
		utf16.ReleaseBuffer();
	}
	return utf16;
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

CString sReplaceLeftSynmbol(CString sData)
{
	sData.Replace(_T(";"),_T(" "));
	sData.Replace(_T("\n"),_T(" "));
	sData.Replace(_T("\r"),_T(" "));
	sData.Replace(_T("\t"),_T(" "));
	return sData;
}