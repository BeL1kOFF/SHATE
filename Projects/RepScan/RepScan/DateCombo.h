#include "MounthCal.h"
#pragma once


// CDateCombo

class CDateCombo : public CEdit
{
	DECLARE_DYNAMIC(CDateCombo)

public:
	CDateCombo();
	virtual ~CDateCombo();

protected:
	DECLARE_MESSAGE_MAP()
public:
	CMounthCal* MounthCal;
	afx_msg void OnSetFocus(CWnd* pOldWnd);
	afx_msg void OnKillFocus(CWnd* pNewWnd);
	afx_msg void OnShowWindow(BOOL bShow, UINT nStatus);
};


