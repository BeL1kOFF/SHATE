// ListDocs.cpp : implementation file
//

#include "stdafx.h"
#include "ListDocs.h"


// CListDocs

IMPLEMENT_DYNAMIC(CListDocs, CListCtrl)

CListDocs::CListDocs()
{
	lSelRow =-1;
}

CListDocs::~CListDocs()
{
}


BEGIN_MESSAGE_MAP(CListDocs, CListCtrl)
	ON_WM_DRAWITEM_REFLECT() 
END_MESSAGE_MAP()



// CListDocs message handlers



/*void CListDocs::DrawItem(LPDRAWITEMSTRUCT lpDrawItemStruct)
{
   if(lpDrawItemStruct->itemData<0)
		return;
	
   CDC* pDC=CDC::FromHandle(lpDrawItemStruct->hDC);
   CRect rcItem(lpDrawItemStruct->rcItem);
   UINT uiFlags=ILD_TRANSPARENT;
   
   int nItem=lpDrawItemStruct->itemID;
   BOOL bFocus=(GetFocus()==this);
   
   static _TCHAR szBuff[MAX_PATH];
   
   COLORREF  BkText;
   if(lSelRow==lpDrawItemStruct->itemID)
   {
	   BkText = ::GetSysColor(COLOR_HIGHLIGHT);
	   pDC->SetTextColor(RGB(255,255,255));
   }
   else
   {
	   BkText = RGB(255,255,255);	
	   pDC->SetTextColor(RGB(0,0,0));
   }
   CRect rcLabel;
   
   GetItemRect(nItem,rcLabel,LVIR_LABEL);
   UINT nJustify=DT_LEFT;
   

   CBrush b(BkText);
   CRect rcAllLabels;
   GetItemRect(nItem,rcAllLabels,LVIR_BOUNDS);

   LV_ITEM lvi;
          lvi.mask=LVIF_TEXT | LVIF_IMAGE | LVIF_STATE;
          lvi.iItem=nItem;
          lvi.iSubItem=0;
          lvi.pszText=szBuff;
          lvi.cchTextMax=sizeof(szBuff);
          lvi.stateMask=0xFFFF;       // get all state flags
          GetItem(&lvi);
       
          BOOL bSelected=(bFocus || (GetStyle() & LVS_SHOWSELALWAYS)) && lvi.state & LVIS_SELECTED;
          bSelected=bSelected || (lvi.state & LVIS_DROPHILITED);

	
	
	pDC->FillRect(rcAllLabels,&b);
	
	long lCount;
	lCount = GetHeaderCtrl()->GetItemCount();
	for(int i = 0;i<lCount;i++)
	{
		CString sName = GetItemText(nItem,i);
		GetSubItemRect(nItem,i,LVIR_BOUNDS,rcLabel);
		rcLabel.left = rcLabel.left + 2;
		pDC->DrawText(sName,-1,rcLabel,nJustify | DT_SINGLELINE | DT_NOPREFIX | DT_NOCLIP | DT_VCENTER);
	}
	
}
*/
void CListDocs::SelectItem(long lItem)
{
	if((lItem>-1)&&(lItem<GetItemCount()))
	{
		if(lSelRow != lItem)
		{
			if(lSelRow>-1)
			{
				RedrawItems(lSelRow,lSelRow);
			}
			
			lSelRow = lItem;
			RedrawItems(lSelRow,lSelRow);
			SendMessageToParent(NCLD_SELECTED);
		}
	}
	else
	{
		if(lSelRow>-1)
				RedrawItems(lSelRow,lSelRow);
		lSelRow = -1;
		SendMessageToParent(NCLD_SELECTED);
	}
}

LRESULT CListDocs::SendMessageToParent(int nMessage)
{
    if (!IsWindow(m_hWnd))
        return 0;
   

	NMHDR hdr;
	hdr.hwndFrom = m_hWnd;
    hdr.idFrom   = GetDlgCtrlID();
    hdr.code     = nMessage;
	
    CWnd *pOwner = GetOwner();
    if (pOwner && IsWindow(pOwner->m_hWnd))
        return pOwner->SendMessage(WM_NOTIFY, GetDlgCtrlID(), (LPARAM)&hdr);
    else
        return 0;
}
BOOL CListDocs::DeleteAllItems(void)
{
	lSelRow = -1;
	return CListCtrl::DeleteAllItems();
}

void CListDocs::OnDrawItem(int nIDCtl, LPDRAWITEMSTRUCT lpDrawItemStruct)
{
	if(lpDrawItemStruct->itemData<0)
		return;
	
   CDC* pDC=CDC::FromHandle(lpDrawItemStruct->hDC);
   CRect rcItem(lpDrawItemStruct->rcItem);
   UINT uiFlags=ILD_TRANSPARENT;
   
   int nItem=lpDrawItemStruct->itemID;
   BOOL bFocus=(GetFocus()==this);
   
   static _TCHAR szBuff[MAX_PATH];
   
   COLORREF  BkText;
   if(lSelRow==lpDrawItemStruct->itemID)
   {
	   BkText = ::GetSysColor(COLOR_HIGHLIGHT);
	   pDC->SetTextColor(RGB(255,255,255));
   }
   else
   {
	   BkText = RGB(255,255,255);	
	   pDC->SetTextColor(RGB(0,0,0));
   }
   CRect rcLabel;
   
   GetItemRect(nItem,rcLabel,LVIR_LABEL);
   UINT nJustify=DT_LEFT;
   

   CBrush b(BkText);
   CRect rcAllLabels;
   GetItemRect(nItem,rcAllLabels,LVIR_BOUNDS);

   LV_ITEM lvi;
          lvi.mask=LVIF_TEXT | LVIF_IMAGE | LVIF_STATE;
          lvi.iItem=nItem;
          lvi.iSubItem=0;
          lvi.pszText=szBuff;
          lvi.cchTextMax=sizeof(szBuff);
          lvi.stateMask=0xFFFF;       // get all state flags
          GetItem(&lvi);
       
          BOOL bSelected=(bFocus || (GetStyle() & LVS_SHOWSELALWAYS)) && lvi.state & LVIS_SELECTED;
          bSelected=bSelected || (lvi.state & LVIS_DROPHILITED);

	
	
	pDC->FillRect(rcAllLabels,&b);
	
	long lCount;
	lCount = GetHeaderCtrl()->GetItemCount();
	for(int i = 0;i<lCount;i++)
	{
		CString sName = GetItemText(nItem,i);
		GetSubItemRect(nItem,i,LVIR_BOUNDS,rcLabel);
		rcLabel.left = rcLabel.left + 2;
		pDC->DrawText(sName,-1,rcLabel,nJustify | DT_SINGLELINE | DT_NOPREFIX | DT_NOCLIP | DT_VCENTER);
	}
}

