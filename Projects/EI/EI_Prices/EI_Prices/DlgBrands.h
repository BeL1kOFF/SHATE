#pragma once
#include "afxcmn.h"


// CDlgBrands dialog

class CDlgBrands : public CDialog
{
	DECLARE_DYNAMIC(CDlgBrands)

public:
	CDlgBrands(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgBrands();
	CDatabase *dBase;
	long lID_Client;

// Dialog Data
	enum { IDD = IDD_DIALOG_BRANDS };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	CListCtrl m_ListBrands;
	afx_msg void OnBnClickedButtonNewBrand();
	virtual BOOL OnInitDialog();
	void LoadBrands(void);
	afx_msg void OnBnClickedButtonEditBrand();
	afx_msg void OnBnClickedButtonDel();
};
