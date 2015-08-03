#define DATEEDIT_CLASSNAME    _T("DATEEDIT")
#pragma once


// CMounthCal

class CMounthCal : public CMonthCalCtrl
{
	DECLARE_DYNAMIC(CMounthCal)

public:
	CMounthCal(CWnd *Win);
	virtual ~CMounthCal();

protected:
	CWnd *WndParent;
	BOOL RegisterWindowClass();
	COleDateTime CurrDate;
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnKillFocus(CWnd* pNewWnd);
	void OnSelectDate();
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	afx_msg void OnShowWindow(BOOL bShow, UINT nStatus);
	afx_msg void OnPaint();
};


