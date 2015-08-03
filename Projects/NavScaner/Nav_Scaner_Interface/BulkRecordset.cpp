#include "StdAfx.h"
#include "BulkRecordset.h"

CBulkRecordset::CBulkRecordset(CNewDatabase *pDB)
: CNewRecordset(pDB)
{
	m_rgID = NULL;
	m_rgName = NULL;
	m_rgIDLengths = NULL;
	m_rgNameLengths = NULL;
	m_strNameParam = "";
	m_nFields = 0;
	m_nParams = 0;
    CRecordset::CRecordset(pDB);
	SetRowsetSize(10);
}

CBulkRecordset::~CBulkRecordset(void)
{
}


void CBulkRecordset::DoBulkFieldExchange(CFieldExchange *pFX)
{
	int i;
	i = 0;
	
	CODBCFieldInfo infoField;
	stField * Element;
	
	if(m_Fields.arrField.GetCount()<1)
		ReadAllFields();
	
	while(i < GetODBCFieldCount())
	{
	
		Element = m_Fields.arrField.ElementAt(i);
		pFX->SetFieldType( CFieldExchange::outputColumn );
		switch(Element->iType)
		{
			case -5:
			case -8:
				
				RFX_Text_Bulk(pFX, Element->sName,(LPWSTR*)&(Element->sValue), &(Element->lValueLength),Element->iFieldLen*2);
				//RFX_Text_Bulk(pFX, Element->sName,&(m_rgName), &(m_rgIDLengths), 255 );
				break;

			
				/*RFX_Long(pFX, Element->sName,*(Element->lValue));
				break;*/
			case 12:
				RFX_Text_Bulk(pFX, Element->sName,(LPWSTR*)&(Element->sValue), &(Element->lValueLength), Element->iFieldLen*2 );
				break;
			case 3:
				RFX_Double_Bulk(pFX,  Element->sName,&(Element->dValue), &(Element->lValueLength));
				break;

			case 4:
				RFX_Long_Bulk(pFX,  Element->sName,&(Element->lValue), &(Element->lValueLength));
				break;

		}
		
		i++;
	}
 if(m_nParams>0)
   {
		pFX->SetFieldType( CFieldExchange::inputParam );
		RFX_Text( pFX, _T("NameParam"), m_strNameParam );
   }
 Element = m_Fields.arrField.ElementAt(0);
}

void CBulkRecordset::SetRowsetSize(int iCountItem)
{
	CRecordset::SetRowsetSize(iCountItem);
	m_ICountItem = iCountItem;
}
CString CBulkRecordset::GetValue(int iPos, int iField)
{
	CString sValue;
	sValue = "";
	stField * Element;
	Element = m_Fields.arrField.ElementAt(iField);
	if(Element == NULL)
		return sValue;

	if (*(Element->lValueLength + iPos) == SQL_NULL_DATA)
        return sValue;

	switch(Element->iType)
		{
			case -5:
			case -8:
				
				sValue = Element->sValue + (iPos * Element->iFieldLen);
				break;

			case 12:
				sValue = Element->sValue + (iPos * Element->iFieldLen);
				break;
			
			case 3:
				sValue.Format(_T("%f"),*(Element->dValue + iPos));
				break;

			case 4:
				sValue.Format(_T("%d"),*(Element->lValue + iPos));
				break;

		}
	
	while(sValue.Right(1)==_T(" "))
	{
		sValue = sValue.Left(sValue.GetLength()-1);
	}
	return sValue;
}

BOOL CBulkRecordset::Open(UINT nOpenType , LPCTSTR lpszSql , DWORD dwOptions)
{
	// TODO: Add your specialized code here and/or call the base class
	CRecordset::SetRowsetSize(m_ICountItem);
	BOOL bRet;
	bRet = CRecordset::Open(nOpenType, lpszSql, dwOptions);
	return bRet;
}

BOOL CBulkRecordset::ReadAllFields(void)
{
	int i;
	i = 0;
	m_Fields.RemoveAll();

	CODBCFieldInfo infoField;
	
	m_nFields = GetODBCFieldCount();
	while(i < GetODBCFieldCount())
	{
		GetODBCFieldInfo(i,infoField);
		m_Fields.Add(infoField);
		i++;
	}

	return TRUE;
}

void CBulkRecordset::Close()
{
	// TODO: Add your specialized code here and/or call the base class
	CRecordset::Close();
	m_Fields.RemoveAll();
}
