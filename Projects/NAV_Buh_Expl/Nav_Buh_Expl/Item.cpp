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
	while(i < m_Item.GetCount())
	{
		stOldItem = m_Item.ElementAt(i);
		if(stOldItem->ID == Item->ID)
		{
			stOldItem->iQuant = stOldItem->iQuant+Item->iQuant;
			stOldItem->dS = stOldItem->dS+Item->dS;
			stOldItem->dSUPR = stOldItem->dSUPR+Item->dSUPR;
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

int CItem::Add(CString ID, CString szCode, CString szDesc, CString szCell, CString sCodeNav, CString sMesure, CString sDate, CString sSupplier,
	int iQuant, double dS, double dSUPR)
{
	stItem* Item;
	Item = new(stItem);
	Item->ID = ID;
	Item->szCode = szCode;
	Item->szDesc = szDesc;
	Item->szCell = szCell;
	Item->iQuant = iQuant;
	Item->dS = dS;
	Item->sCodeNav = sCodeNav;
	Item->sMesure = sMesure;
	Item->sDate = sDate;
	Item->dSUPR = dSUPR;
	Item->sSupplier = sSupplier;
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