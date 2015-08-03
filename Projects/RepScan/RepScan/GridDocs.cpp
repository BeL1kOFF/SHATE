#include "StdAfx.h"
#include "GridDocs.h"

CGridDocs::CGridDocs(void)
{
	bCanReDraw = TRUE;
	iSelRow = -1;
	Menu = NULL;
}

CGridDocs::~CGridDocs(void)
{
	if(Menu!=NULL)
	{
		delete(Menu);
		Menu = NULL;
	}
}

BEGIN_MESSAGE_MAP(CGridDocs, CGridCtrl)
	ON_WM_LBUTTONDOWN()
	ON_WM_KEYDOWN()
	ON_WM_PAINT()
	ON_WM_RBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_RBUTTONUP()
	ON_NOTIFY(Mess_Filter, Mess_Filter_Edit, OnSetFilter)
	ON_WM_CTLCOLOR()
	ON_WM_CHAR()
	ON_WM_LBUTTONDBLCLK()
END_MESSAGE_MAP()

void CGridDocs::OnLButtonDown(UINT nFlags, CPoint point)
{
	m_LeftClickDownCell  = GetCellFromPt(point);
	if (!IsValid(m_LeftClickDownCell))
        return;
	if(m_LeftClickDownCell.row < GetFixedRowCount())
	{
		if (m_MouseMode == MOUSE_OVER_COL_DIVIDE)
			CGridCtrl::OnLButtonDown(nFlags, point);
		return;
	}
	if(GetFixedColumnCount()> m_LeftClickDownCell.col)
	{
		if (m_MouseMode == MOUSE_OVER_ROW_DIVIDE) 
			CGridCtrl::OnLButtonDown(nFlags, point);
		return;
	}
	int iSelectRow;
	iSelectRow = m_LeftClickDownCell.row;
	SelectItem(iSelectRow);
}

void CGridDocs::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	int iSelectRow;
	iSelectRow = iSelRow;
	if((nChar >= VK_NUMPAD0)&&(nChar <= VK_NUMPAD9))
	{
		nChar = nChar - VK_NUMPAD0;
		nChar = nChar +'0';
	}
	if((nChar >='0')&&(nChar <= '9'))
		{
			CRect rect;
			if (!GetCellRect(0, 1, rect))
				return;
			
			tr = new CFilterEdit(WS_VISIBLE|WS_BORDER, rect,(CWnd*)this, Mess_Filter_Edit);
			CString a;
			a.Format(_T("%c"),nChar);
			tr->SetWindowTextW(a);
			tr->SetSel(2,1);
			return;
		}
    if (nChar == VK_DOWN)
    {
		iSelectRow++;
    }
    else if (nChar == VK_UP)
    {
       iSelectRow--;
    }
    
	if(iSelectRow < GetFixedRowCount())
		iSelectRow = GetFixedRowCount();

	if(iSelectRow > GetRowCount()-1)
		iSelectRow = GetRowCount() -1;
	if(iSelectRow < GetFixedRowCount())
		return;
	
	CCellID cell;
	cell.col = 0;
	cell.row = iSelectRow;
	if (!IsCellVisible(cell))
        {
			switch (nChar)
            {
              
            case VK_DOWN:   
                SendMessage(WM_VSCROLL, SB_LINEDOWN, 0);  
                break;
                
            case VK_UP:     
                SendMessage(WM_VSCROLL, SB_LINEUP, 0);    
                break;    
			}
	
		}
	SelectItem(iSelectRow);
}


void CGridDocs::SelectRow(int iRow)
{
	if(iRow < GetFixedRowCount())
		return;

	if(iRow > GetRowCount()-1)
		return;
	long iSelectRow;
	iSelectRow = iRow;
	SelectItem(iSelectRow);
	
}

void CGridDocs::SelectItem(int iRow, BOOL bSetFocus)
{
	if(iSelRow != iRow)
	{
		CCellID cell;
		cell.col = 0;
		cell.row = iRow;
		if (!IsCellVisible(cell))
        {
			CCellID idTopLeft = GetTopleftNonFixedCell();
			int iPos;
			iPos = 0;
			for(int i = 1;i<iRow;i++)
			{
				iPos = iPos + GetRowHeight(i); 
			}
			SetScrollPos(SB_VERT, iPos, TRUE);
			GetTopleftNonFixedCell(TRUE);
			Invalidate();
		}
	
		iSelRow = iRow;
		SetSelectedRange(iRow,GetFixedColumnCount(),iRow,GetColumnCount()-1,TRUE,TRUE);
		SendMessageToParent(iRow,GetFixedColumnCount(), GVN_SELCHANGED);
		if(bSetFocus)
			SetFocus();
		
	}
}
BOOL CGridDocs::SetRowCount(int nRows)
{
	iSelRow = -1;
	return CGridCtrl::SetRowCount(nRows);
}

void CGridDocs::SetCanreDraw(bool bReDraw)
{
	bCanReDraw = bReDraw;
	if(!bCanReDraw)
	{
		SetRedraw(FALSE, FALSE);
	}
	else
	{
		SetRedraw(TRUE, TRUE);
	}
}

void CGridDocs::OnPaint()
{
	if(!bCanReDraw)
	{
		bCanReDraw = FALSE;
	}
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

void CGridDocs::OnRButtonDown(UINT nFlags, CPoint point)
{

	if(Menu!=NULL)
	{
		m_LeftClickDownCell  = GetCellFromPt(point);
		if (!IsValid(m_LeftClickDownCell))
		  return;
		
		if(m_LeftClickDownCell.row < GetFixedRowCount())
		{
			return;
		}

		if(GetFixedColumnCount()> m_LeftClickDownCell.col)
		{	
			return;
		}
		
		int iSelectRow;
		iSelectRow = m_LeftClickDownCell.row;
		SelectItem(iSelectRow);
		CRect rec;
		GetWindowRect(rec);
		Menu->TrackPopupMenu(TPM_LEFTALIGN | TPM_RIGHTBUTTON, rec.left+point.x,rec.top+ point.y,(CWnd*)GetParent());
	}
}

void CGridDocs::OnLButtonUp(UINT nFlags, CPoint point)
{
	CGridCtrl::OnLButtonUp(nFlags, point);
}

void CGridDocs::OnRButtonUp(UINT nFlags, CPoint point)
{
	
}

BOOL CGridDocs::PreTranslateMessage(MSG* pMsg)
{
	return CGridCtrl::PreTranslateMessage(pMsg);
}

//OnSetFilter
void CGridDocs::OnSetFilter(NMHDR* pNMHDR, LRESULT* pResult)
{
	FIL_EDIT *Param;
	Param = (FIL_EDIT*)pNMHDR;
	CString sFilter;
	CString sCode;
	sFilter.Format(_T("%s"),Param->sItem);
	int i;
	i=1;
	if(sFilter.GetLength()<1)
	{
		if(tr->m_hWnd!=NULL)
			{
					tr->SetTrue(TRUE);
			}
		return;
	}

	if(iSelRow>0)
		{
			sCode = GetItemText(iSelRow,1);
			if(sCode.Left(sFilter.GetLength()) == sFilter)
			{
				if(tr->m_hWnd!=NULL)
				{
					tr->SetTrue(TRUE);
				}
				return;
			}
		}

	while(i<GetRowCount())
	{
		
		sCode = GetItemText(i,1);
		if(sCode.Left(sFilter.GetLength()) == sFilter)
		{
			SelectItem(i, FALSE);
			if(tr->m_hWnd!=NULL)
			{
					tr->SetTrue(TRUE);
			}
			return;
		}
			i++;
	}
	if(tr->m_hWnd!=NULL)
	{
		tr->SetTrue(FALSE);
	}
}
HBRUSH CGridDocs::OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor)
{
	
	return CGridCtrl::OnCtlColor(pDC, pWnd, nCtlColor);

}

void CGridDocs::OnChar(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	// TODO: Add your message handler code here and/or call default

	CGridCtrl::OnChar(nChar, nRepCnt, nFlags);
}

//void SetRowColor(long lRow, int iColor);
void CGridDocs::SetRowTextColor(long lRow, int iColor)
{
	if((lRow<GetFixedRowCount())||(lRow>=GetRowCount()))
		return;
	int i;
	for(i=GetFixedColumnCount();i<GetColumnCount();i++)
	{
		SetItemFgColour(lRow,i,iColor);
		RedrawCell(lRow,i);
	}
}


void CGridDocs::SetRowColor(long lRow, int iColor)
{
	if((lRow<GetFixedRowCount())||(lRow>=GetRowCount()))
		return;
	int i;
	for(i=GetFixedColumnCount();i<GetColumnCount();i++)
	{
		SetItemBkColour(lRow,i,iColor);
		RedrawCell(lRow,i);
	}
}

BOOL CGridDocs::DeleteRow(long lRow)
{
	if(lRow == iSelRow)
	{
		iSelRow = -1;
		SendMessageToParent(iSelRow,GetFixedColumnCount(), GVN_SELCHANGED);
	}
	return CGridCtrl::DeleteRow(lRow);
}

void CGridDocs::OnLButtonDblClk(UINT nFlags, CPoint point)
{
	SendMessageToParent(iSelRow,GetFixedColumnCount(), Mess_OpenDoc);
}
