#pragma once
#include "afxwin.h"


// CDlgName dialog

class CDlgName : public CDialog
{
	DECLARE_DYNAMIC(CDlgName)

public:
	int iCount;
	CDlgName(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgName();
	CString sName;
// Dialog Data
	enum { IDD = IDD_DIALOG_NAME };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
	CEdit m_edName;
};
