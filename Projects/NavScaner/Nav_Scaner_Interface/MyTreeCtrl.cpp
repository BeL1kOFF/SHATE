// MyTreeCtrl.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner_Interface.h"
#include "MyTreeCtrl.h"


// CMyTreeCtrl

IMPLEMENT_DYNCREATE(CMyTreeCtrl, CTreeCtrl)

CMyTreeCtrl::CMyTreeCtrl()
{
	hFirst = NULL;
}

CMyTreeCtrl::~CMyTreeCtrl()
{
}

BEGIN_MESSAGE_MAP(CMyTreeCtrl, CTreeCtrl)
	ON_NOTIFY_REFLECT(TVN_ITEMCHANGED, &CMyTreeCtrl::OnTvnItemChanged)
	ON_NOTIFY_REFLECT(NM_CLICK, &CMyTreeCtrl::OnNMClick)
	ON_WM_LBUTTONDOWN()
	ON_NOTIFY_REFLECT(TVN_KEYDOWN, &CMyTreeCtrl::OnTvnKeydown)
	ON_MESSAGE(MYM_CHECKITEM,OnCheckItem)
END_MESSAGE_MAP()


// CMyTreeCtrl diagnostics

#ifdef _DEBUG
void CMyTreeCtrl::AssertValid() const
{
	CTreeCtrl::AssertValid();
}

#ifndef _WIN32_WCE
void CMyTreeCtrl::Dump(CDumpContext& dc) const
{
	CTreeCtrl::Dump(dc);
}
#endif
#endif //_DEBUG


// CMyTreeCtrl message handlers

void CMyTreeCtrl::OnTvnItemChanged(NMHDR *pNMHDR, LRESULT *pResult)
{
	NMTVITEMCHANGE *pNMTVItemChange = reinterpret_cast<NMTVITEMCHANGE*>(pNMHDR);
	// TODO: Add your control notification handler code here
	*pResult = 0;
}

BOOL CMyTreeCtrl::OnNotify(WPARAM wParam, LPARAM lParam, LRESULT* pResult)
{
	// TODO: Add your specialized code here and/or call the base class

	return CTreeCtrl::OnNotify(wParam, lParam, pResult);
}

void CMyTreeCtrl::OnNMClick(NMHDR *pNMHDR, LRESULT *pResult)
{
	// TODO: Add your control notification handler code here
	*pResult = 0;
}

void CMyTreeCtrl::OnLButtonDown(UINT nFlags, CPoint point)
{
	// TODO: Add your message handler code here and/or call default
	UINT flags = 0;
    HTREEITEM    hitem = HitTest(point, &flags);
    
    if ( hitem != NULL && flags & TVHT_ONITEMSTATEICON )
	{
		SetChildCheck(hitem,!GetCheck(hitem));
		TestTreeState();
	}
	else
		CTreeCtrl::OnLButtonDown(nFlags, point);
}

//OnCheckItem
void CMyTreeCtrl::OnTvnKeydown(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMTVKEYDOWN pTVKeyDown = reinterpret_cast<LPNMTVKEYDOWN>(pNMHDR);
	// TODO: Add your control notification handler code here
	*pResult = 0;

	HTREEITEM    hitem;
	hitem = GetSelectedItem();
	if(hitem == NULL)
		return;

	if(pTVKeyDown->wVKey==VK_SPACE)
	{
		PostMessage(MYM_CHECKITEM,GetCheck(hitem),0);
	}
}

afx_msg LRESULT CMyTreeCtrl::OnCheckItem(WPARAM wParam, LPARAM lParam)
{
	HTREEITEM    hitem;
	hitem = GetSelectedItem();
	if(hitem == NULL)
		return 0L;

	if((BOOL)wParam != GetCheck(hitem))
	{
		SetChildCheck(hitem,GetCheck(hitem));
		TestTreeState();
	}

	return 0L;
}
void CMyTreeCtrl::SetChildCheck(HTREEITEM hItem, BOOL bCheck)
{
	if(hItem == NULL)
		return;

	HTREEITEM hItemChild = NULL;

	hItemChild = GetChildItem(hItem);
	while(hItemChild != NULL)
	{
		SetChildCheck(hItemChild,bCheck);
		hItemChild = GetNextItem(hItemChild,TVGN_NEXT);
		if(GetParentItem(hItemChild) != hItem)
			break;
	}
	SetCheck(hItem,bCheck);

}

BOOL CMyTreeCtrl::CheckAll(BOOL bCheck)
{
	if(hFirst == NULL)
		return FALSE;

	HTREEITEM hItemChild;
	hItemChild = hFirst;
	while(hItemChild != NULL)
	{
		SetChildCheck(hItemChild,bCheck);
		hItemChild = GetNextItem(hItemChild,TVGN_NEXT);
	}
	SetChildCheck(hFirst,bCheck);
	TestTreeState();
	return bCheck;
}

HTREEITEM CMyTreeCtrl::InsertItem(CString sItem, HTREEITEM Parent,HTREEITEM InsertAfter)
{
	if(hFirst == NULL)
	{
		hFirst = CTreeCtrl::InsertItem(sItem,Parent,InsertAfter);
		return hFirst;
	}
	else
		return CTreeCtrl::InsertItem(sItem,Parent,InsertAfter);
}

void CMyTreeCtrl::TestTreeState(void)
{
	int iStyle;
	iStyle = 0;

	HTREEITEM hItemChild;
	hItemChild = hFirst;

	BOOL bAllSelect, bAllNotSelect;
	bAllSelect = TRUE;
	bAllNotSelect = TRUE;
	hItemChild = hFirst;
	while(((bAllSelect)||(bAllNotSelect))&&(hItemChild != NULL))
	{
		if(GetCheck(hItemChild))
		{
			bAllNotSelect = FALSE;
		}
		else
		{
			bAllSelect = FALSE;
		}
		if(GetNextItem(hItemChild,TVGN_CHILD) == NULL)
		{
			if(GetNextItem(hItemChild,TVGN_NEXT) == NULL)
			{
				while((hItemChild = GetNextItem(hItemChild,TVGN_PARENT))!=NULL)
				{
					if(GetNextItem(hItemChild,TVGN_NEXT)!=NULL)
					{
						hItemChild = GetNextItem(hItemChild,TVGN_NEXT);
						break;
					}
				}
			}
			else
				hItemChild = GetNextItem(hItemChild,TVGN_NEXT);
		}
		else
		{
			hItemChild = GetNextItem(hItemChild,TVGN_CHILD);
		}
	}
	if((!bAllNotSelect)&&(!bAllSelect))
	{
		iStyle = 2;
	}
	else
		if(bAllSelect) iStyle = 1;
	

	NM_TREEVIEW_MY mTree;
	
	mTree.hdr.hwndFrom = m_hWnd;
	mTree.hdr.idFrom   = GetDlgCtrlID();
	mTree.hdr.code     = MYM_CHECKITEMSSATE;
	mTree.iValue = iStyle;

    CWnd *pOwner = GetOwner();
    if (pOwner && IsWindow(pOwner->m_hWnd))
        pOwner->SendMessage(WM_NOTIFY, mTree.hdr.idFrom, (LPARAM)&mTree);
}

CString CMyTreeCtrl::GetSelectID(void)
{
	HTREEITEM hItemChild;
	CString sRet;
	CString sValue;
	hItemChild = hFirst;
	while(hItemChild != NULL)
	{
		if(GetCheck(hItemChild))
		{
			if(GetNextItem(hItemChild,TVGN_CHILD) == NULL)
			{
				sValue.Format(_T(",%d"),GetItemData(hItemChild));
				sRet = sRet + sValue;
			}
		}

		if(GetNextItem(hItemChild,TVGN_CHILD) == NULL)
		{
			if(GetNextItem(hItemChild,TVGN_NEXT) == NULL)
			{
				while((hItemChild = GetNextItem(hItemChild,TVGN_PARENT))!=NULL)
				{
					if(GetNextItem(hItemChild,TVGN_NEXT)!=NULL)
					{
						hItemChild = GetNextItem(hItemChild,TVGN_NEXT);
						break;
					}
				}
			}
			else
				hItemChild = GetNextItem(hItemChild,TVGN_NEXT);
		}
		else
		{
			hItemChild = GetNextItem(hItemChild,TVGN_CHILD);
		}
		
	}
	if(sRet.GetLength()>0)
	{
		sRet = sRet.Right(sRet.GetLength()-1);  
	}
	return sRet;
}
