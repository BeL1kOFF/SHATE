#pragma once
#include "..\gridctrl\gridctrl.h"
#include "..\gridctrl\MemDC.h"
#include "FilterEdit.h"

#define Mess_Filter_Edit WM_USER +13
#define Mess_OpenDoc WM_USER +70

class CGridDocs :
	public CGridCtrl
{
public:
	CGridDocs(void);
	~CGridDocs(void);
	int iSelRow;
	bool bCanReDraw;
	DECLARE_MESSAGE_MAP()
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnSetFilter(NMHDR* pNMHDR, LRESULT* pResult);
	CFilterEdit* tr;
	
public:
	CMenu *Menu;
	void SelectRow(int iRow);
	void SelectItem(int iRow, BOOL bSetFocus = TRUE);
	void SetCanreDraw(bool bReDraw);
	BOOL SetRowCount(int nRows);
	afx_msg void OnPaint();
	afx_msg void OnRButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnRButtonUp(UINT nFlags, CPoint point);
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
	afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
	void SetRowColor(long lRow, int iColor);
	void SetRowTextColor(long lRow, int iColor);
	BOOL DeleteRow(long lRow);
	afx_msg void OnLButtonDblClk(UINT nFlags, CPoint point);
};
