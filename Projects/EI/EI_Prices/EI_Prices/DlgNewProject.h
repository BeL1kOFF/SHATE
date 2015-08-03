#pragma once
#include "afxwin.h"


// CDlgNewProject dialog

class CDlgNewProject : public CDialog
{
	DECLARE_DYNAMIC(CDlgNewProject)

public:
	CDlgNewProject(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgNewProject();
	CString sNewProjectName;
// Dialog Data
	enum { IDD = IDD_DIALOG_NEW_PROJECT };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
	CEdit m_EdProjectName;
};
