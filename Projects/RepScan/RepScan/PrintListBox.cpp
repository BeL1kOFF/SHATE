// PrintListBox.cpp : implementation file
//

#include "stdafx.h"
#include "RepScan.h"
#include "PrintListBox.h"


// CPrintListBox

IMPLEMENT_DYNAMIC(CPrintListBox, CListBox)

CPrintListBox::CPrintListBox()
{
	Menu = NULL;
}

CPrintListBox::~CPrintListBox()
{
}


BEGIN_MESSAGE_MAP(CPrintListBox, CListBox)
	ON_WM_RBUTTONUP()
END_MESSAGE_MAP()



// CPrintListBox message handlers



void CPrintListBox::OnRButtonUp(UINT nFlags, CPoint point)
{
	CListBox::OnRButtonUp(nFlags, point);

	if(Menu != NULL)
	{
		CRect rec;
		GetWindowRect(rec);
		Menu->TrackPopupMenu(TPM_LEFTALIGN | TPM_RIGHTBUTTON, rec.left+point.x,rec.top+ point.y, AfxGetMainWnd());
	}

}
