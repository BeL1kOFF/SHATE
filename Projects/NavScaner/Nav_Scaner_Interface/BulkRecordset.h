#pragma once
#include "afxdb.h"
#include "Fields.h"
#include "newrecordset.h"

class CBulkRecordset :
	public CNewRecordset
{
protected:
	
public:
	CFields m_Fields;
	CBulkRecordset(CNewDatabase *pDB=NULL);
	~CBulkRecordset(void);
public:
      long* m_rgID;
      LPSTR m_rgName;
      long* m_rgIDLengths;
      long* m_rgNameLengths;
	  int m_ICountItem;
      CString m_strNameParam;
      void DoBulkFieldExchange(CFieldExchange *pFX);
	  void SetRowsetSize(int iCountItem);
	  CString GetValue(int iPos, int iField);
	  virtual BOOL Open(UINT nOpenType = snapshot, LPCTSTR lpszSql = NULL, DWORD dwOptions = none);
protected:
	BOOL ReadAllFields(void);
public:
	virtual void Close();
};
