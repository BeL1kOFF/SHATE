// MyStatic.cpp : implementation file
//

#include "stdafx.h"
#include "MyStatic.h"

// CMyStatic

IMPLEMENT_DYNAMIC(CMyStatic, CStatic)

CMyStatic::CMyStatic()
{
	m_crTextColor = ::GetSysColor(COLOR_BTNTEXT);
	m_crBkColor = ::GetSysColor(COLOR_BTNFACE);
	m_brBkgnd.CreateSolidBrush(m_crBkColor);
}

CMyStatic::~CMyStatic()
{
}


BEGIN_MESSAGE_MAP(CMyStatic, CStatic)
	ON_WM_CTLCOLOR_REFLECT()
END_MESSAGE_MAP()



// CMyStatic message handlers




HBRUSH CMyStatic::CtlColor(CDC* pDC, UINT nCtlColor)
{
	pDC->SetTextColor(m_crTextColor);
	pDC->SetBkColor(m_crBkColor);
    return (HBRUSH)m_brBkgnd;
}

void CMyStatic::SetTextColor(COLORREF crTextColor)
{
	if (crTextColor != 0xffffffff)
	{
		m_crTextColor = crTextColor;
	}
	else
	{
		m_crTextColor = ::GetSysColor(COLOR_BTNTEXT);
	}
	Invalidate();
}