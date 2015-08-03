#pragma once

#define MYIMAGE_CLASSNAME    _T("MYIMAGE")
// CMyImage
#define WM_MOUSELEAVE                   0x02A3

class CMyImage : public CWnd
{
	DECLARE_DYNAMIC(CMyImage)

public:
	CMyImage();
	BOOL bClicked;
	virtual ~CMyImage();
	CImageList* m_ImageList;
	int iImage;
	BOOL Create(const RECT& rect, CWnd* parent, UINT nID,DWORD dwStyle = WS_CHILD | WS_BORDER | WS_TABSTOP | WS_VISIBLE);
	BOOL SetImage(CImageList* List, int iImageNumber);
	LRESULT SendMessageToParent(int nMessage);
protected:
	DECLARE_MESSAGE_MAP()
	BOOL RegisterWindowClass();
	afx_msg void OnPaint();
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnMouseLeave();
};


