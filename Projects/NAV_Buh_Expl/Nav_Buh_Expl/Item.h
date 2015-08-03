#pragma once

struct stItem
{
	CString ID;
	CString sDate;
	CString szCode;
	CString szDesc;
	CString szCell;
	CString sCodeNav;
	CString sMesure;
	CString sSupplier;
	int iQuant;
	double dS;
	double dSUPR;
};


class CItem
{
public:
	CItem(void);
	~CItem(void);
public:
	CArray <stItem*, stItem*> m_Item;
	int Add(stItem* Item);
	int Add(CString ID,	CString szCode, CString szDesc, CString szCell, CString sCodeNav, CString sMesure, CString sDate, CString sSupplier,
		int iQuant = 0, double dS = 0.0, double dSUPR = 0.0);
	int GetCount();
	stItem* GetItem(int iPos);
};
