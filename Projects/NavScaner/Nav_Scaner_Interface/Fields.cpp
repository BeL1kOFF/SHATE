#include "StdAfx.h"
#include "Fields.h"

CFields::CFields(void)
{
	
}

CFields::~CFields(void)
{
	RemoveAll();
}

void CFields::RemoveAll(void)
{
	stField * Element;
	while(arrField.GetCount()>0)
	{
		Element = arrField.ElementAt(0);
		delete(Element);
		arrField.RemoveAt(0,1);
	}
}

stField* CFields::Add(CODBCFieldInfo info)
{
	stField* NewElement;	
	NewElement = new(stField);
	NewElement->sName = info.m_strName;
	NewElement->iType = info.m_nSQLType;
	NewElement->sValue = NULL;
	NewElement->lValueLength= NULL;
	NewElement->dValue = NULL;
	NewElement->lValue = NULL;
	NewElement->iFieldLen = (info.m_nPrecision+1);
	arrField.Add(NewElement);
	return NewElement;
}
