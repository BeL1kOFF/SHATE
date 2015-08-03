#pragma once

#define ED_KEYENTERDOWN WM_USER+100

// CScanerEdit

class CScanerEdit : public CEdit
{
	DECLARE_DYNAMIC(CScanerEdit)
	
public:
	CScanerEdit();
	virtual ~CScanerEdit();
	COLORREF newColor;
protected:
	DECLARE_MESSAGE_MAP()
	afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnPaint();
public:
	void TestState(bool bState);
};


