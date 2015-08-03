#pragma once
#include "afxdb.h"
#include "newrecordset.h"
class CServerRecordset :
	public CRecordset
{
public:
	CServerRecordset(CNewDatabase *pDB=NULL);
	~CServerRecordset(void);
	virtual void OnSetOptions(HSTMT hstmt);
};
