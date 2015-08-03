#pragma once
#include "afxwin.h"


// CDlgReportMounth dialog

class CDlgReportMounth : public CDialog
{
	DECLARE_DYNAMIC(CDlgReportMounth)

public:
	CDlgReportMounth(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgReportMounth();

// Dialog Data
	enum { IDD = IDD_DLG_REPORT_ASS_MOUNTH };
	Excel::_ApplicationPtr appExcel;
protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	CString sDatabase;
	virtual BOOL OnInitDialog();
	CComboBox m_ComboMounth;
	CComboBox m_ComboYear;
	afx_msg void OnBnClickedOk();
};
