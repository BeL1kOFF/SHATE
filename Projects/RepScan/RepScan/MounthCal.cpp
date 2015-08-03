// MounthCal.cpp : implementation file
//

#include "stdafx.h"
#include "RepScan.h"
#include "MounthCal.h"


// CMounthCal

IMPLEMENT_DYNAMIC(CMounthCal, CMonthCalCtrl)

CMounthCal::CMounthCal(CWnd *Win)
{
	RegisterWindowClass();
	CRect rec;
	rec.left = 0;
	rec.top = 0;
	rec.right = rec.left + 160;
	rec.bottom = rec.top + 160;

	if(Win!=NULL)
	{		
		Win->GetWindowRect(rec);
		rec.top = rec.bottom;
		rec.right = rec.left + 160;
		rec.bottom = rec.top +160;
		
		WndParent = Win;
		if (!CreateEx(WS_EX_TOOLWINDOW | WS_EX_TOPMOST  ,DATEEDIT_CLASSNAME, NULL ,WS_VISIBLE|WS_BORDER | WS_POPUP, rec,  NULL, NULL, NULL ))	
			return;
		SetFocus();
		GetClientRect(rec);
		WndParent->GetParent()->SetFocus();
	}
	else
	{
		WndParent = NULL;
		if(Create(WS_CHILD|WS_VISIBLE|WS_BORDER,rec,NULL,1000000))
		{
			SetFocus();
		}
	}
	CurrDate = COleDateTime::GetCurrentTime();
}

CMounthCal::~CMounthCal()
{
}


BEGIN_MESSAGE_MAP(CMounthCal, CMonthCalCtrl)
	ON_WM_KILLFOCUS()
	ON_WM_SHOWWINDOW()
	ON_WM_PAINT()
END_MESSAGE_MAP()



// CMounthCal message handlers

void CMounthCal::OnSelectDate()
{
	
	//CMonthCalCtrl::OnKillFocus(pNewWnd);
	PostMessage(WM_CLOSE, 0, 0);
}

void CMounthCal::OnKillFocus(CWnd* pNewWnd)
{
	//CMonthCalCtrl::OnKillFocus(pNewWnd);
	//PostMessage(WM_CLOSE, 0, 0);
}

BOOL CMounthCal::RegisterWindowClass()
{
    WNDCLASS wndcls;
    //HINSTANCE hInst = AfxGetInstanceHandle();
    HINSTANCE hInst = AfxGetResourceHandle();

    if (!(::GetClassInfo(hInst, DATEEDIT_CLASSNAME, &wndcls)))
    {
        // otherwise we need to register a new class
        wndcls.style            = CS_DBLCLKS | CS_HREDRAW | CS_VREDRAW;
        wndcls.lpfnWndProc      = ::DefWindowProc;
        wndcls.cbClsExtra       = wndcls.cbWndExtra = 0;
        wndcls.hInstance        = hInst;
        wndcls.hIcon            = NULL;
#ifndef _WIN32_WCE_NO_CURSOR
        wndcls.hCursor          = AfxGetApp()->LoadStandardCursor(IDC_ARROW);
#else
        wndcls.hCursor          = 0;
#endif
        wndcls.hbrBackground    = (HBRUSH) (COLOR_3DFACE + 1);
        wndcls.lpszMenuName     = NULL;
        wndcls.lpszClassName    = DATEEDIT_CLASSNAME;

        if (!AfxRegisterClass(&wndcls))
        {
            AfxThrowResourceException();
            return FALSE;
        }
    }

    return TRUE;
}

BOOL CMounthCal::PreTranslateMessage(MSG* pMsg)
{
	if(pMsg->message == WM_LBUTTONDBLCLK)
	{
		OnSelectDate();
	}
	else
	return CMonthCalCtrl::PreTranslateMessage(pMsg);
}

void CMounthCal::OnShowWindow(BOOL bShow, UINT nStatus)
{
	CMonthCalCtrl::OnShowWindow(bShow, nStatus);
	if(bShow)
	{
		WndParent->GetParent()->SetFocus();
	}
}

void CMounthCal::OnPaint()
{
	/*CPaintDC dc(this); 
	CRect rec;
	GetClientRect(rec);
	CBrush br(RGB(255,255,255));
	dc.FillRect(rec,&br);
	rec.bottom = rec.top+30;

	CBrush br1(RGB(100,100,255));
	dc.FillRect(rec,&br1);

	CFont f;
    f.CreateFont(...); // parameters not shown
    dc.SelectObject(&f);

	CString sMounth;
	sMounth = sMounthName(CurrDate.Format(_T("%m"))) +_T(" ")+ CurrDate.Format(_T("%Y"))+_T("ã.");
	dc.SetBkColor(RGB(100,100,255));
	dc.
	dc.SetTextColor(RGB(255,255,255));
	dc.TextOutW(rec.left + 40, rec.top+5,sMounth);*/
}
