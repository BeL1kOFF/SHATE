#pragma once
#include "afxwin.h"


// CDLgEditGroup dialog

class CDLgEditGroup : public CDialog
{
	DECLARE_DYNAMIC(CDLgEditGroup)

public:
	CDLgEditGroup(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDLgEditGroup();

// Dialog Data
	enum { IDD = IDD_DLG_EDIT_GROUP };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	int iCurrGroup;
	virtual BOOL OnInitDialog();
	CListBox m_ListGroup;
	afx_msg void OnLbnSelcancelList1();
	CEdit m_EdDecr;
	afx_msg void OnLbnSelchangeList1();
	afx_msg void OnBnClickedButtonEdit();
	int LoadGroup(void);
	afx_msg void OnBnClickedButton2();
};
