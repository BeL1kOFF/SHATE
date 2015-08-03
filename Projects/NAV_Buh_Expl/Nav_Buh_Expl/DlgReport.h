#pragma once
#include "afxwin.h"
#include "afxcmn.h"


// CDlgReport dialog

class CDlgReport : public CDialog
{
	DECLARE_DYNAMIC(CDlgReport)

public:
	CDlgReport(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgReport();
	int iCurrReport;

// Dialog Data
	enum { IDD = IDD_DIALOG_REPORT };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedButtonNew();
	virtual BOOL OnInitDialog();
	CListBox m_ListReportName;
	int LoadReports(int iPos = 0);
	void SaveReport(int iReport);
	int LoadReport();
	afx_msg void OnLbnSelchangeListReportName();
	CDatabase* dBase;
	CDatabase* OpenDatabase(CString * sError);
	CDatabase* CloseDatabase(CString * sError=NULL);
	afx_msg void OnBnClickedButtonDel();
	CListCtrl m_ListField;
	afx_msg void OnLvnItemchangedListReportField(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnClose();
	CComboBox m_ComboCurr;
	CEdit m_EdFlNum;
	afx_msg void OnCbnSelchangeComboCurr();
	afx_msg void OnEnChangeEditFloatNumber();
};
