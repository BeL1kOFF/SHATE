#pragma once

struct stField
{
	int iFieldLen;
	CString sName;
	int iType;
	LPWSTR sValue;
	long* lValueLength;
	double* dValue; 
	long* lValue;
};

class CFields
{
protected:
	
public:
	CArray<stField*,stField*> arrField; 
	CFields(void);
	~CFields(void);
	void RemoveAll(void);
	stField* Add(CODBCFieldInfo info);
};
