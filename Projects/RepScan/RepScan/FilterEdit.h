#pragma once
#define Mess_Filter WM_USER +12

// CFilterEdit

struct FIL_EDIT{
    NMHDR   hdr;
    CString sItem;
};

class CFilterEdit : public CEdit
{
	DECLARE_DYNAMIC(CFilterEdit)

public:
	CFilterEdit(DWORD dwStyle, CRect& rect, CWnd* pParent,   UINT nID);
	LRESULT SendMessageToParent(int nMessage);
	virtual ~CFilterEdit(); 
	CBrush* BgBrush;
	bool bClear;	
	bool SetColor(int iColor);
	int Color;
	bool bFind;
	void SetTrue(bool bTr);
protected:
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnKillFocus(CWnd* pNewWnd);
	afx_msg void OnEnChange();
	afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg HBRUSH CtlColor(CDC* /*pDC*/, UINT /*nCtlColor*/);
};


