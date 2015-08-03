// Nav_Buh_ExplDlg.h : header file
//
#include "SPMaskEdit.h"
#pragma once
#include "afxwin.h"
#include "Item.h"

/*
struct stItem
{
	CString ID;
	LPWSTR szCode;
	LPWSTR szDesc;
	int iQuant;	

};
*/

// CNav_Buh_ExplDlg dialog
class CNav_Buh_ExplDlg : public CDialog
{
// Construction
public:
	CNav_Buh_ExplDlg(CWnd* pParent = NULL);	// standard constructor
	BOOL bExit;
	
// Dialog Data
	enum { IDD = IDD_NAV_BUH_EXPL_DIALOG };

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
	afx_msg void OnBnClickedOk();
	afx_msg BOOL OnHelpInfo(HELPINFO* pHelpInfo);
	afx_msg void OnBnClickedCancel();
	static void SetVisible(CNav_Buh_ExplDlg* dlg, int iType);
	static DWORD StartExport_All(DWORD someparam);
	static void CreateExcelAkt(DWORD someparam,CItem * Items, CString sDocNumber, CString sDate);
	static DWORD StartExport_Auto(DWORD someparam);
	static DWORD StartExport_Auto_AKT(DWORD someparam);
	static DWORD StartExport_NotAuto(DWORD someparam);
	static DWORD StartExport_CurrentQuants(DWORD someparam);
	static DWORD StartExcel_All(DWORD someparam);
	bool bTerminate;
protected:
	virtual void OnCancel();
public:
	SPMaskEdit m_edFrom;
	SPMaskEdit m_edTo;
	CComboBox m_ComboType;
	afx_msg void OnCbnSelchangeComboCelss();
	//CStatic m_stSelCell;
	//CComboBox m_ComboSelCell;
	afx_msg void OnCbnSelchangeComboType();
	static CDatabase* OpenDatabase(CString * sError);
	static CDatabase* CloseDatabase(CDatabase* dBase,CString * sError=NULL);
	bool LoadCells(void);
	CButton m_btExit;
	CButton m_btStart;
	CStatic m_stType;
	CStatic m_stFrom;
	CStatic m_stTo;
	afx_msg void OnBnClickedButtonStop();
	CButton m_btTerninate;
	CStatic m_stInfo;
	CButton m_btNoZero;
	afx_msg void OnBnClickedButton1();
	CButton m_ButPrintAkt;
	static CString GetPath(void);
	CButton m_btWithUPRSS;
	afx_msg void OnBnClickedButtonEditReport();
	int LoadReports(void);
	CButton m_btEditReport;
	CButton m_btBuhSS;
	CString vAktNum;
	CEdit edAktNum;
	CStatic l_act;
};
