#pragma once
#include "afxdb.h"
#include "newdatabase.h"

class CNewRecordset :
	public CRecordset
{
public:
	CNewRecordset(CNewDatabase *pDB);
	~CNewRecordset(void);
	virtual void PreBindFields();
	virtual BOOL Open(UINT nOpenType = snapshot, LPCTSTR lpszSql = NULL, DWORD dwOptions = none);
};
