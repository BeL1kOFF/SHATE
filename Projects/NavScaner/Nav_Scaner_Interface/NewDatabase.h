#pragma once
#include "afxdb.h"

class CNewDatabase :
	public CDatabase
{

public:
	CNewDatabase(void);
	~CNewDatabase(void);
	CString sSQL;
};
