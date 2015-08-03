#pragma once
#include "afxwin.h"


// CDlgDatabase dialog

class CDlgDatabase : public CDialog
{
	DECLARE_DYNAMIC(CDlgDatabase)

public:
	CDlgDatabase(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgDatabase();

// Dialog Data
	enum { IDD = IDD_DIALOG_DATABASE };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL OnInitDialog();
	CEdit m_edServerDB;
	CEdit m_EdDBName;
	CEdit m_edDBNav_Server;
	CEdit m_edDBNav_Name;
	afx_msg void OnBnClickedButtonSaveDbProg();
	afx_msg void OnBnClickedButtonDbProgCancel();
	afx_msg void OnBnClickedButtonDbNavCancel();
	afx_msg void OnBnClickedButtonDbNavSave();
};
