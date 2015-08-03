#pragma once
#include "afxwin.h"


// CDlgAddTest dialog

class CDlgAddTest : public CDialog
{
	DECLARE_DYNAMIC(CDlgAddTest)

public:
	CString sCell;
	CString sCount;
	CDlgAddTest(CWnd* pParent = NULL,CStringArray* stArray = NULL);   // standard constructor
	virtual ~CDlgAddTest();

// Dialog Data
	enum { IDD = IDD_DLG_TEST_ITEM };

protected:
	CString sNo2;
	CString sBrand;
	CString sDescr;
	CString sCountInTare;
	
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedOk();
	CStatic m_stNo2;
	virtual BOOL OnInitDialog();
	CStatic m_stBrand;
	CStatic m_stDescr;
	CEdit m_edCount;
	CStatic m_CountInTare;
	CEdit m_edCell;
};
