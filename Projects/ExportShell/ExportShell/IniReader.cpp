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
		if(!GetPrivateProfileString(strSection, strKey,sDefValue, pstrString,MAX_PATH, m_StrFileName))
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
			if(sDefValue.GetLength()>0)
			if((bWriteToIni)&&(sDefValue == pstrString))
			{
				WriteToIni(strSection, strKey,sDefValue);
			}
			return strString;
		}
	}
	return _T("");
}

int CIniReader::ReadFromIni(CString strSection, CString strKey, int iDefValue)
{
	if(m_StrFileName.GetLength()>0)
	{ 
		iDefValue = GetPrivateProfileInt(strSection,strKey,iDefValue,m_StrFileName);
		if(bWriteToIni)
		{
			WriteToIni(strSection, strKey,iDefValue);
		}
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
CString CIniReader::GetFilePath(void)
{
	CString sRet;
	sRet = "";
	int iFind;
	iFind = m_StrFileName.ReverseFind('\\');
	if(iFind > -1)
	{
		sRet = m_StrFileName.Left(iFind+1);
	}
	return sRet;
}
