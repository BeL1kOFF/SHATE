#pragma once
#include "afxwin.h"


// CDlgEmail dialog

class CDlgEmail : public CDialog
{
	DECLARE_DYNAMIC(CDlgEmail)

public:
	CDlgEmail(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgEmail();
	CString sEmail;
// Dialog Data
	enum { IDD = IDD_DIALOG_EMAIL };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
	CEdit m_EdEmail;
	virtual BOOL OnInitDialog();
};
