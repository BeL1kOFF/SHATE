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
		delete(stOldItem);
		m_Item.RemoveAt(0,1);
	}
}

int CItem::Add(stItem* Item)
{
	if(Item == NULL)
		return -1;
	int i;
	i = 0;
	stItem* stOldItem;
	int iVal;
	double dVal;
	while(i < m_Item.GetCount())
	{
		stOldItem = m_Item.ElementAt(i);
		if(stOldItem->sID == Item->sID)
		{

			for(iVal=3;iVal<7;iVal++)
			{
				dVal = _wtofmy(stOldItem->sArray.ElementAt(i));
				dVal = dVal+_wtofmy(Item->sArray.ElementAt(i));
				if(iVal=3)
				stOldItem->sArray.ElementAt(i).Format(_T("%.0f"),dVal);
				else
				stOldItem->sArray.ElementAt(i).Format(_T("%.2f"),dVal);
			}
			delete(Item);
			return i;
		}

		if(stOldItem->sID > Item->sID)
		{
			//m_Item.InsertAt(i,Item);
			return i;
		}
		i++;
	}
	m_Item.Add(Item);
	return m_Item.GetCount();
}

int CItem::Add(CString ID,	CStringArray* sArray)
{
	stItem* Item;
	Item = new(stItem);
	Item->sID = ID;

	
	while(sArray->GetCount()>0)
	{
		Item->sArray.Add(sArray->ElementAt(0));
		sArray->RemoveAt(0,1);
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