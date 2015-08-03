#pragma once
#include "gridctrl\gridctrl.h"
#include "gridctrl\MemDC.h"

class CDocGridCtrl :
	public CGridCtrl
{
public:
	CDocGridCtrl(void);
	~CDocGridCtrl(void);
	DECLARE_MESSAGE_MAP()
	afx_msg void OnPaint();
	BOOL bCanReDraw;
public:
	void SetCanDraw(BOOL bReDraw);
	int SetItemText(int iRow, int iCol, CString sValue);
	afx_msg void OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	afx_msg void OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
	afx_msg void OnVScrollClipboard(CWnd* pClipAppWnd, UINT nSBCode, UINT nPos);
	int GetSelectRow(void);
};
