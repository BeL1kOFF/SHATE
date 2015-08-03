#pragma once

struct stItem
{
	CString sID;
	CStringArray sArray;
};


class CItem
{
public:
	CItem(void);
	~CItem(void);
public:
	CArray <stItem*, stItem*> m_Item;
	int Add(stItem* Item);
	int Add(CString ID,	CStringArray* sArray);
	int GetCount();
	stItem* GetItem(int iPos);
};
