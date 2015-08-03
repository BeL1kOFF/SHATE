// ExportShellDlg.h : header file
//
#include "SPMaskEdit.h"
#pragma once#include "afxwin.h"
#include "Item.h"

struct stPostCode
{
	CString sValue;
	CString iMin;
	CString iMax;
};

struct StParam
{
	CStatic* stMess;
	DWORD* dwThreadID;
	BOOL* bStateProcess;
	CString sStartDate;
	CString sEndDate;
};


// CExportShellDlg dialog
class CExportShellDlg : public CDialog
{
// Construction
public:
	CExportShellDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_EXPORTSHELL_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	HICON m_hIcon;
	DWORD dwThreadID;

	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
	virtual void OnOK();
	virtual void OnCancel();
public:
	
	afx_msg void OnBnClickedButton1();
	afx_msg void OnBnClickedButton2();
	static DWORD StartOperation(LPVOID param);
	static BOOL CreateExport(CString sStartDate, CString sEndDate,BOOL* bTerminate, CStatic *stInfo = NULL);
	CStatic m_stInfo;
	BOOL bStateProcess;

	CComboBox m_ComboMounth;
	CEdit m_edYear;
	afx_msg void OnBnClickedButtonOpenDir();
	CEdit m_edDir;
};
