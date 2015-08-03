#pragma once

#define NCLD_SELECTED WM_USER +15

// CListDocs

class CListDocs : public CListCtrl
{
	DECLARE_DYNAMIC(CListDocs)

public:
	CListDocs();
	virtual ~CListDocs();
	long iDoc;
	CString sDate;
	long lZone;
	long lSelRow;
protected:
	DECLARE_MESSAGE_MAP()
public:
	void SelectItem(long lItem);
	LRESULT SendMessageToParent(int nMessage);
	BOOL DeleteAllItems(void);
	afx_msg void OnDrawItem(int nIDCtl, LPDRAWITEMSTRUCT lpDrawItemStruct);
};


