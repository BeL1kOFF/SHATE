#pragma once
#include "afxwin.h"


// CDlgEditDoc dialog

class CDlgEditDoc : public CDialog
{
	DECLARE_DYNAMIC(CDlgEditDoc)

public:
	CDlgEditDoc(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgEditDoc();

// Dialog Data
	enum { IDD = IDD_DLG_DOC };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	long lID;
	long lGroup;
	
	virtual BOOL OnInitDialog();
	CStatic m_StDate;
	CStatic m_StLocation;
	CEdit m_EdDescr;
	CComboBox m_ComboGroup;
	afx_msg void OnBnClickedButtonEditGroup();
	int LoadGroup(void);
	afx_msg void OnCbnSelchangeComboGroup();
	afx_msg void OnBnClickedOk();
	afx_msg void OnEnKillfocusEditDescr();
	afx_msg void OnEnChangeEditDescr();
};
