#pragma once

struct stItem
{
	CString ID;
	CStringArray sArray;
	
};


class CItem
{
public:
	CItem(void);
	~CItem(void);
public:
	CArray<int,int> iSummFieldID;
	CArray <stItem*, stItem*> m_Item;
	int Add(stItem* Item);
	int Add(CString ID,	CStringArray* sArray);
	int GetCount();
	stItem* GetItem(int iPos);
	int AddSummField(int iField);
};
