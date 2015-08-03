#pragma once
#include <typeinfo>

class CIniReader
{


public:
	CIniReader(void);
	~CIniReader(void);
	
	int SetIniFileName(CString sNewFileName =_T(""));

protected:	
	CString m_StrFileName;
	BOOL bWriteToIni; //записывать в файл деволтовые значения
public:
	CString GetIniFileName(void);
	CString ReadFromIni(CString strSection, CString strKey, CString sDefValue =_T(""));
	int ReadFromIni(CString strSection, CString strKey, int iDefValue);
	int SetWriteDefault(bool bWrite);
	BOOL GetWriteDefault();
	bool WriteToIni(CString strSection, CString strKey, CString sValue);
	bool WriteToIni(CString strSection, CString strKey, int sValue);
};
