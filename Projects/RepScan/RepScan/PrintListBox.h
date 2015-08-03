#pragma once


// CPrintListBox

class CPrintListBox : public CListBox
{
	DECLARE_DYNAMIC(CPrintListBox)

public:
	CPrintListBox();
	virtual ~CPrintListBox();
	CMenu * Menu;
protected:
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnRButtonUp(UINT nFlags, CPoint point);
};


