#pragma once


// CColorTree

class CColorTree : public CTreeCtrl
{
	DECLARE_DYNAMIC(CColorTree)
	HTREEITEM hFirst;
public:
	CColorTree();
	virtual ~CColorTree();
	HBRUSH m_Brush;

	COLORREF m_colRow1;
	COLORREF m_colRow2;

protected:
	DECLARE_MESSAGE_MAP()
public:
	afx_msg HBRUSH OnCtlColor(CDC* pDC, CWnd* pWnd, UINT nCtlColor);
	afx_msg void OnNMCustomdraw(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnPaint();
};


