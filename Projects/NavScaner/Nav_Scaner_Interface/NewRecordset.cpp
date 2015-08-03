#include "StdAfx.h"
#include "NewRecordset.h"

CNewRecordset::CNewRecordset(CNewDatabase *pDB)
: CRecordset(pDB)
{
}

CNewRecordset::~CNewRecordset(void)
{
}

void CNewRecordset::PreBindFields()
{
    if  ( ! (m_dwOptions & useMultiRowFetch) )
    {
        delete [] m_rgRowStatus;
        m_rgRowStatus = new WORD[2];
    }

    CRecordset::PreBindFields();
}

BOOL CNewRecordset::Open(UINT nOpenType , LPCTSTR lpszSql , DWORD dwOptions)
{
	BOOL bValue;
	bValue = CRecordset::Open(nOpenType, lpszSql, dwOptions);
	if(bValue)
	{
		//sSQL
		if(m_pDatabase != NULL)
		{
			CNewDatabase * dBase = (CNewDatabase *)m_pDatabase;
			if(dBase!=NULL)
				dBase->sSQL = lpszSql;
		}
	}
	return bValue;
}
