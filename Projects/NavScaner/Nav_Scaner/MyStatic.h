#pragma once


// CMyStatic

class CMyStatic : public CStatic
{
	DECLARE_DYNAMIC(CMyStatic)
	
public:
	CMyStatic();
	virtual ~CMyStatic();
	CFont font;
private:
	COLORREF m_crTextColor;
	COLORREF m_crBkColor;
	CBrush m_brBkgnd;
protected:
	DECLARE_MESSAGE_MAP()
	
public:
	
	void SetTextColor(COLORREF crTextColor);
	afx_msg HBRUSH CtlColor(CDC* /*pDC*/, UINT /*nCtlColor*/);
};


