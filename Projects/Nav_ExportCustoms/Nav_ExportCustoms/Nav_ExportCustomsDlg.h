// Nav_ExportCustomsDlg.h : header file
//

#pragma once
#include "afxwin.h"
#include "spmaskedit.h"


// CNav_ExportCustomsDlg dialog
class CNav_ExportCustomsDlg : public CDialog
{
// Construction
public:
	CNav_ExportCustomsDlg(CWnd* pParent = NULL);	// standard constructor
	
// Dialog Data
	enum { IDD = IDD_NAV_EXPORTCUSTOMS_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	CWinThread *SecondThread;
	SPMaskEdit m_StartDate;
	SPMaskEdit m_EndDate;
	CEdit m_EdGTDNUMBER;
	afx_msg void OnBnClickedOk();
	static unsigned ExportData(LPVOID p);
	CButton m_BtOK;
	CStatic m_stState;
	CEdit m_EdError;
};
