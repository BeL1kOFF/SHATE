// ScanerEdit.cpp : implementation file
//

#include "stdafx.h"
#include "ScanerEdit.h"


// CScanerEdit

IMPLEMENT_DYNAMIC(CScanerEdit, CEdit)

CScanerEdit::CScanerEdit()
{
		newColor = 0;
}

CScanerEdit::~CScanerEdit()
{
}


BEGIN_MESSAGE_MAP(CScanerEdit, CEdit)
	ON_WM_KEYDOWN()
	ON_WM_PAINT()
END_MESSAGE_MAP()



// CScanerEdit message handlers

/*LRESULT CScanerEdit::SendMessageToParent(int nRow, int nCol, int nMessage)
{
    if (!IsWindow(m_hWnd))
        return 0;

    NM_GRIDVIEW nmgv;
    nmgv.iRow         = nRow;
    nmgv.iColumn      = nCol;
    nmgv.hdr.hwndFrom = m_hWnd;
    nmgv.hdr.idFrom   = GetDlgCtrlID();
    nmgv.hdr.code     = nMessage;

    CWnd *pOwner = GetOwner();
    if (pOwner && IsWindow(pOwner->m_hWnd))
        return pOwner->SendMessage(WM_NOTIFY, nmgv.hdr.idFrom, (LPARAM)&nmgv);
    else
        return 0;
}*/
void CScanerEdit::OnPaint()
{
	CEdit::OnPaint();
	if(	newColor != 0)
	{
		CDC * pDC = GetDC();
		CRect newRec;
		GetClientRect(newRec);
		CBrush brush(newColor);
		pDC->FillRect(newRec,&brush);
	}
}

void CScanerEdit::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags) 
{
    CEdit::OnKeyDown(nChar, nRepCnt, nFlags);
}


void CScanerEdit::TestState(bool bState)
{
	
	SetWindowText(_T(""));
	COLORREF color;
	CDC * pDC = GetDC();
	color = GetBkColor(pDC->m_hDC);
	EnableWindow(FALSE);
	if(bState)
	{
		newColor = RGB(0,255,0);
		Invalidate(0);
		CDC * pDC = GetDC();
		CRect newRec;
		GetClientRect(newRec);
		CBrush brush(newColor);
		pDC->FillRect(newRec,&brush);
	}
	else
	{
		//SetBkColor(pDC->m_hDC,RGB(255,0,0));
		newColor = RGB(255,0,0);
		Invalidate(0);
		CDC * pDC = GetDC();
		CRect newRec;
		GetClientRect(newRec);
		CBrush brush(newColor);
		pDC->FillRect(newRec,&brush);
		MessageBeep(MB_ICONWARNING);
	}
	
	Sleep(500);
	EnableWindow(TRUE);
	newColor = 0;
	Invalidate(0);
}
