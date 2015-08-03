#pragma once
#include "afxwin.h"


// CDlgBrand dialog

class CDlgBrand : public CDialog
{
	DECLARE_DYNAMIC(CDlgBrand)

public:
	CDlgBrand(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgBrand();

	CString sBrandShate;
	CString sBrand;

// Dialog Data
	enum { IDD = IDD_DIALOG_BRAND };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	CEdit m_EdBrandShate;
	CEdit m_EdBrand;
	afx_msg void OnBnClickedOk();
	virtual BOOL OnInitDialog();
};
