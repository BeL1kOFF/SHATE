#pragma once
#include "afxwin.h"


// CDLGEmails dialog

class CDLGEmails : public CDialog
{
	DECLARE_DYNAMIC(CDLGEmails)

public:
	CDLGEmails(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDLGEmails();
	CDatabase * dBase;
	long lID_Client;
	CString sEmails;
// Dialog Data
	enum { IDD = IDD_DIALOG_EMAILS };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedButtonAddEmail();
	virtual BOOL OnInitDialog();
	CListBox m_ListEmails;
	afx_msg void OnBnClickedButtonEdit();
	afx_msg void OnBnClickedButtonDel();
	afx_msg void OnClose();
protected:
	virtual void OnOK();
};
