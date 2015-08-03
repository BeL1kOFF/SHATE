#include "StdAfx.h"
#include "IniReader.h"


CIniReader::CIniReader(void)
: m_StrFileName(_T(""))
{
	m_StrFileName = "";
	bWriteToIni = TRUE;
	SetIniFileName();
}

CIniReader::~CIniReader(void)
{
}

int CIniReader::SetIniFileName(CString sNewFileName)
{
	if(sNewFileName.GetLength() < 1)
	{
		CString sFileName;
		sFileName = AfxGetApp()->m_pszProfileName;
		sFileName.MakeLower();
		m_StrFileName = sFileName;
	}
	else
		m_StrFileName = sNewFileName;
	return 0;
}

CString CIniReader::GetIniFileName(void)
{
	return m_StrFileName;
}

CString CIniReader::ReadFromIni(CString strSection, CString strKey, CString sDefValue)
{
	if(m_StrFileName.GetLength()>0)
	{ 
		wchar_t pstrString[MAX_PATH];
		if(!GetPrivateProfileString(strSection, strKey,_T("ReturnDefValue"), pstrString,MAX_PATH, m_StrFileName))
		{
			if(bWriteToIni)
			{
				WriteToIni(strSection, strKey,sDefValue);
			}
			return sDefValue;
		}
		else
		{
			CString strString;
			strString =pstrString;
			if(strString==_T("ReturnDefValue"))
			{
				WriteToIni(strSection, strKey,sDefValue);
				strString = sDefValue;
			}
			return strString;
		}
	}
	return _T("");
}

int CIniReader::ReadFromIni(CString strSection, CString strKey, int iDefValue)
{
	int i;
	if(m_StrFileName.GetLength()>0)
	{ 
		i = GetPrivateProfileInt(strSection,strKey,0,m_StrFileName);
		if(bWriteToIni)
		{
			if(0==i)
			{
				i = iDefValue;
				WriteToIni(strSection, strKey,iDefValue);
			}
		}
		iDefValue = i;
	}
	return iDefValue;
}


int CIniReader::SetWriteDefault(bool bWrite)
{
	bWriteToIni = bWrite;
	return 0;
}

BOOL CIniReader::GetWriteDefault()
{
	return bWriteToIni;
}

bool CIniReader::WriteToIni(CString strSection, CString strKey, CString sValue)
{
	if(m_StrFileName.GetLength()>0)
	{ 
		if (WritePrivateProfileString(strSection, strKey, sValue, m_StrFileName))
			return TRUE;
	}
	return FALSE;
}

bool CIniReader::WriteToIni(CString strSection, CString strKey, int Value)
{
	if(m_StrFileName.GetLength()>0)
	{ 
		CString sValue;
		sValue.Format(_T("%d"),Value);
		return WriteToIni(strSection,strKey,sValue);
	}
	return FALSE;
}