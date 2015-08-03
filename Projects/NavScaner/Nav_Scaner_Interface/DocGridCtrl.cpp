#include "StdAfx.h"
#include "DocGridCtrl.h"

CDocGridCtrl::CDocGridCtrl(void)
{
	bCanReDraw = TRUE;
}

CDocGridCtrl::~CDocGridCtrl(void)
{
}
BEGIN_MESSAGE_MAP(CDocGridCtrl, CGridCtrl)
	ON_WM_PAINT()
	ON_WM_HSCROLL()
	ON_WM_VSCROLL()
	ON_WM_VSCROLLCLIPBOARD()
END_MESSAGE_MAP()

void CDocGridCtrl::OnPaint()
{
	if(bCanReDraw)
	{
		CPaintDC dc(this);      
	    if (m_bDoubleBuffer)    
		{
			CMemDC MemDC(&dc);
			OnDraw(&MemDC);
		}
		else                    
			OnDraw(&dc);
	}
}

void CDocGridCtrl::SetCanDraw(BOOL bReDraw)
{
	bCanReDraw = bReDraw;
	if(!bCanReDraw)
	{
		SetRedraw(FALSE, FALSE);
	}
	else
	{
		SetRedraw(TRUE, TRUE);
		Invalidate();
	}
}

int CDocGridCtrl::SetItemText(int iRow, int iCol, CString sValue)
{
	CGridCellBase * pCell;
	pCell = GetCell(iRow,iCol);
	if(pCell != NULL)
	{		
		pCell->SetText(sValue);			
	}
	return 0;
}

void CDocGridCtrl::OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
{
	CGridCtrl::OnHScroll(nSBCode, nPos, pScrollBar);

}

void CDocGridCtrl::OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar)
{
	// TODO: Add your message handler code here and/or call default

	CGridCtrl::OnVScroll(nSBCode, nPos, pScrollBar);
}

void CDocGridCtrl::OnVScrollClipboard(CWnd* pClipAppWnd, UINT nSBCode, UINT nPos)
{
	// TODO: Add your message handler code here and/or call default

	CGridCtrl::OnVScrollClipboard(pClipAppWnd, nSBCode, nPos);
}

int CDocGridCtrl::GetSelectRow(void)
{
	CCellRange range;
	range = GetSelectedCellRange();
	int iRet;
	iRet = range.GetMinRow();
	if(iRet > range.GetMaxRow())
		iRet = range.GetMaxRow();

	
	
	
	return iRet;
}

