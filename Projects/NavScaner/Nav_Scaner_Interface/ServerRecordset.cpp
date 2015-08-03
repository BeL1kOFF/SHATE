#include "StdAfx.h"
#include "ServerRecordset.h"

CServerRecordset::CServerRecordset(CNewDatabase *pDB)
: CRecordset(pDB)
{
}

CServerRecordset::~CServerRecordset(void)
{
}

void CServerRecordset::OnSetOptions(HSTMT hstmt)
{
	CRecordset::OnSetOptions(hstmt);
	SQLRETURN  nRetCode= ::SQLSetStmtAttr(hstmt, SQL_ATTR_CURSOR_TYPE, (SQLPOINTER)SQL_CURSOR_STATIC, 4);
	nRetCode= ::SQLSetStmtAttr(hstmt, SQL_ATTR_CONCURRENCY, (SQLPOINTER)SQL_CONCUR_LOCK, 4); 
	
}
