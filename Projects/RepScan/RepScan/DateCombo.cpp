// DateCombo.cpp : implementation file
//

#include "stdafx.h"
#include "RepScan.h"
#include "DateCombo.h"


// CDateCombo

IMPLEMENT_DYNAMIC(CDateCombo, CEdit)

CDateCombo::CDateCombo()
{
	MounthCal = NULL;
}

CDateCombo::~CDateCombo()
{
	if(MounthCal!=NULL)
	{
		MounthCal->DestroyWindow();
		delete(MounthCal);
		MounthCal = NULL;
	}
}


BEGIN_MESSAGE_MAP(CDateCombo, CEdit)	
	ON_WM_SETFOCUS()
	ON_WM_KILLFOCUS()
	ON_WM_SHOWWINDOW()
END_MESSAGE_MAP()



// CDateCombo message handlers





void CDateCombo::OnSetFocus(CWnd* pOldWnd)
{
	if(MounthCal==NULL)
		MounthCal = new CMounthCal(this);
	else
		MounthCal->ShowWindow(1);
}

void CDateCombo::OnKillFocus(CWnd* pNewWnd)
{
	CEdit::OnKillFocus(pNewWnd);
	if(pNewWnd!=MounthCal)
	{
		if(MounthCal!=NULL)
		{
			MounthCal->DestroyWindow();
			delete(MounthCal);
			MounthCal = NULL;
		}
	}
}

void CDateCombo::OnShowWindow(BOOL bShow, UINT nStatus)
{
	CEdit::OnShowWindow(bShow, nStatus);
	if(!bShow)
	{
		if(MounthCal!=NULL)
		{
			MounthCal->DestroyWindow();
			delete(MounthCal);
			MounthCal = NULL;
		}
	}
}
