#pragma once

#define MYM_CHECKITEM WM_USER
#define MYM_CHECKITEMSSATE WM_USER+1

// CMyTreeCtrl view

typedef struct tagNM_TREEVIEW_MY {
    NMHDR hdr;
	int iValue;
} NM_TREEVIEW_MY;

class CMyTreeCtrl : public CTreeCtrl
{
	DECLARE_DYNCREATE(CMyTreeCtrl)

public:
	CMyTreeCtrl(); 
	virtual ~CMyTreeCtrl();
protected:
	          // protected constructor used by dynamic creation
	

public:
#ifdef _DEBUG
	virtual void AssertValid() const;
#ifndef _WIN32_WCE
	virtual void Dump(CDumpContext& dc) const;
#endif
#endif

protected:
	HTREEITEM hFirst;
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnTvnItemChanged(NMHDR *pNMHDR, LRESULT *pResult);
protected:
	virtual BOOL OnNotify(WPARAM wParam, LPARAM lParam, LRESULT* pResult);
public:
	afx_msg void OnNMClick(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnTvnKeydown(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg LRESULT OnCheckItem(WPARAM wParam, LPARAM lParam);
	void SetChildCheck(HTREEITEM hItem, BOOL bCheck);
	BOOL CheckAll(BOOL bCheck);
	HTREEITEM InsertItem(CString sItem, HTREEITEM Parent,HTREEITEM InsertAfter);
	void TestTreeState(void);
	CString GetSelectID(void);
};


