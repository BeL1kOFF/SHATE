#include "StdAfx.h"
#include "GridNotCopying.h"

CGridNotCopying::CGridNotCopying(void)
{
	bCanReDraw = TRUE;
}

CGridNotCopying::~CGridNotCopying(void)
{
}

BEGIN_MESSAGE_MAP(CGridNotCopying, CGridCtrl)
	ON_WM_PAINT()
END_MESSAGE_MAP()

void CGridNotCopying::OnPaint() 
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
void CGridNotCopying::SetCanreDraw(bool bReDraw)
{
	bCanReDraw = bReDraw;
}

void CGridNotCopying::SelectRow(long iRow)
{
	if(iRow < GetFixedRowCount())
		return;

	if(iRow > GetRowCount()-1)
		return;
	
	SetSelectedRange(iRow,GetFixedColumnCount(),iRow,GetColumnCount()-1,TRUE);
	
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
	}
	Invalidate();
}
