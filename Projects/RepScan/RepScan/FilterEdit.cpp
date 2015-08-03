// FilterEdit.cpp : implementation file
//

#include "stdafx.h"
#include "FilterEdit.h"
#include "GridDocs.h"

// CFilterEdit

IMPLEMENT_DYNAMIC(CFilterEdit, CWnd)

CFilterEdit::CFilterEdit(DWORD dwStyle, CRect& rect, CWnd* pParent,   UINT nID)
{
	bFind = TRUE;
	bClear = TRUE;
	BgBrush = NULL;
	if(Create(dwStyle, rect,pParent,nID))
	{
		SetFocus();
	}
}

CFilterEdit::~CFilterEdit()
{
	if(BgBrush!=NULL)
		delete(BgBrush);
	BgBrush = NULL;
}


BEGIN_MESSAGE_MAP(CFilterEdit, CWnd)
	ON_WM_KILLFOCUS()
	ON_CONTROL_REFLECT(EN_CHANGE, &CFilterEdit::OnEnChange)
	ON_WM_KEYDOWN()
	ON_WM_CHAR()
	ON_WM_CTLCOLOR_REFLECT()
END_MESSAGE_MAP()



// CFilterEdit message handlers



void CFilterEdit::OnKillFocus(CWnd* pNewWnd)
{

	CEdit::OnKillFocus(pNewWnd);
	if(bClear)
	{
		SetWindowText(_T(""));
		bClear = TRUE;
	}

	SendMessageToParent(Mess_Filter);
	PostMessage(WM_CLOSE, 0, 0);
}

void CFilterEdit::OnEnChange()
{
	bClear = FALSE;
	SendMessageToParent(Mess_Filter);
}

LRESULT CFilterEdit::SendMessageToParent(int nMessage)
{
    if (!IsWindow(m_hWnd))
        return 0;
   

	FIL_EDIT hdr;
	hdr.hdr.hwndFrom = m_hWnd;
    hdr.hdr.idFrom   = GetDlgCtrlID();
    hdr.hdr.code     = nMessage;
	GetWindowText(hdr.sItem);
    CWnd *pOwner = GetOwner();
    if (pOwner && IsWindow(pOwner->m_hWnd))
        return pOwner->SendMessage(WM_NOTIFY, GetDlgCtrlID(), (LPARAM)&hdr);
    else
        return 0;


	/*FIL_EDIT hdr;
	hdr.hdr.hwndFrom = m_hWnd;
    hdr.hdr.idFrom   = GetDlgCtrlID();
    hdr.hdr.code     = nMessage;
	GetWindowText(hdr.sItem);



	CWnd *pOwner = GetParent();
    
	if (pOwner && IsWindow(pOwner->m_hWnd))
        return pOwner->SendMessage(WM_NOTIFY, GetDlgCtrlID(), (LPARAM)&hdr);
    else
        return 0;*/
}

void CFilterEdit::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	// TODO: Add your message handler code here and/or call default
	if(nChar == VK_RETURN)
	{
		bClear = FALSE;
		SendMessageToParent(Mess_Filter);
		PostMessage(WM_CLOSE, 0, 0);
	}
	else
		CEdit::OnKeyDown(nChar, nRepCnt, nFlags);
}

BOOL CFilterEdit::PreTranslateMessage(MSG* pMsg)
{
	if ( WM_KEYDOWN == pMsg->message )
	{
		if((int)pMsg->wParam == VK_RETURN)
		{
			SetWindowText(_T(""));
			PostMessage(WM_CLOSE, 0, 0);
			return TRUE;
		}


		if((int)pMsg->wParam == VK_TAB)
		{
			SetWindowText(_T(""));
			PostMessage(WM_CLOSE, 0, 0);
			return TRUE;
		}

		if((int)pMsg->wParam == VK_ESCAPE)
		{
			SetWindowText(_T(""));
			PostMessage(WM_CLOSE, 0, 0);
			return TRUE;
		}
	}
	return CEdit::PreTranslateMessage(pMsg);
}

bool CFilterEdit::SetColor(int iColor)
{
	Color = iColor;
	if(BgBrush!=NULL)
		delete(BgBrush);
	BgBrush = NULL;
	BgBrush = new CBrush(iColor);
	
	return TRUE;
}
void CFilterEdit::OnChar(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	// TODO: Add your message handler code here and/or call default
	
	if((nChar >= VK_NUMPAD0)&&(nChar <= VK_NUMPAD9))
	{
		nChar = nChar - VK_NUMPAD0;
		nChar = nChar +'0';
	}
	
	if(((nChar >='0')&&(nChar <= '9'))||(nChar == VK_BACK))
		{
			return CEdit::OnChar(nChar, nRepCnt, nFlags);;
		}
	else
		{
			nChar = 0;
		}
	
}

HBRUSH CFilterEdit::CtlColor(CDC* pDC, UINT /*nCtlColor*/)
{
	CGridDocs * grid;
	grid = (CGridDocs *)GetParent();
	COLORREF bkColor;
	if(bFind)
	{
		bkColor = RGB(255,255,255);
	}
	else
	{
		bkColor = RGB(255,100,100);
	}
	SetColor(bkColor);
	pDC->SetBkColor(bkColor);
	return (HBRUSH)(BgBrush->GetSafeHandle());
}

void CFilterEdit::SetTrue(bool bTr)
{
	if(bTr!=bFind)
	{
		bFind = bTr;
		Invalidate();
	}
}