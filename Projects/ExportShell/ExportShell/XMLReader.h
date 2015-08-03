#pragma once
#include "locale.h"
struct stXMLPropesty
{
	CString sName;
	CString sValue;
};


struct stXMLElemet
{
	stXMLElemet* Parent;
	stXMLElemet* Next;
	CString sValue;
	CString sName;
	CString wc_Separator;
	CArray<stXMLPropesty*,stXMLPropesty*> aPropertes;
};


class CXMLReader
{
protected:
	stXMLElemet* XMLGlobal;
	wchar_t *p_Buffer;
	long lWidth;
public:
	CXMLReader(void);
	~CXMLReader(void);
	BOOL ReadFromFile(CString sFileName);
	BOOL ParseBuffer();
	int ClearTree(void);
	stXMLElemet* AddParseElement(CString sValue,stXMLElemet *Element);
	stXMLElemet* AddElement(CString sName,CString sValue,stXMLElemet *Element);
	BOOL AddProperty(CString sName,CString sValue,stXMLElemet *Element);
	BOOL SetSeparator(CString sValue,stXMLElemet *Element);
	BOOL WriteToFile(CString sFileName);
};
