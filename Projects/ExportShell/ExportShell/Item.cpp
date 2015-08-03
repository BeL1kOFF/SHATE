#include "StdAfx.h"
#include "Item.h"

CItem::CItem(void)
{
	m_Item.RemoveAll();
	
}

CItem::~CItem(void)
{
	stItem* stOldItem;
	while(m_Item.GetCount()>0)
	{
		stOldItem = m_Item.ElementAt(0);
		stOldItem->sArray.RemoveAll();
		
		delete(stOldItem);
		m_Item.RemoveAt(0,1);
	}
	iSummFieldID.RemoveAll();
	
}

int CItem::Add(stItem* Item)
{
	if(Item == NULL)
		return -1;
	int i;
	i = 0;
	stItem* stOldItem;
	while(i < m_Item.GetCount())
	{
		stOldItem = m_Item.ElementAt(i);
		if(stOldItem->ID == Item->ID)
		{
			int iSumm;
			double dSumm;
			dSumm = 0;
			for(iSumm = 0;iSumm < iSummFieldID.GetCount();iSumm++)
			{
				dSumm = _wtof(stOldItem->sArray.ElementAt(iSummFieldID.ElementAt(iSumm)));
				dSumm = dSumm + _wtof(Item->sArray.ElementAt(iSummFieldID.ElementAt(iSumm)));
				stOldItem->sArray.ElementAt(iSummFieldID.ElementAt(iSumm)).Format(_T("%f"),dSumm);
			}
			delete(Item);
			return i;
		}

		if(stOldItem->ID > Item->ID)
		{
			m_Item.InsertAt(i,Item);
			return i;
		}
		i++;
	}
	m_Item.Add(Item);
	return -1;
}

int CItem::Add(CString ID,	CStringArray* sArray)
{
	stItem* Item;
	Item = new(stItem);
	Item->ID = ID;
	Item->sArray.RemoveAll();
	int iPos = 0;
	while(iPos <sArray->GetCount())
	{
		Item->sArray.Add(sArray->ElementAt(iPos));
		iPos++;
	}
	return Add(Item);
}

int CItem::GetCount()
{
	return m_Item.GetCount();
}

stItem* CItem::GetItem(int iPos)
{
	if(iPos < 0)
		return NULL;

	if(iPos >= m_Item.GetCount())
		return NULL;

	return m_Item.ElementAt(iPos);

}
int CItem::AddSummField(int iField)
{
	iSummFieldID.Add(iField);
	return 0;
}
