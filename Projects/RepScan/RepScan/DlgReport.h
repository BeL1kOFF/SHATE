#pragma once
#include "spmaskedit.h"


// CDlgReport dialog

class CDlgReport : public CDialog
{
	DECLARE_DYNAMIC(CDlgReport)

public:
	CDlgReport(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgReport();
	BOOL bAssemble;
// Dialog Data
	enum { IDD = IDD_DLG_REPORT };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	Excel::_ApplicationPtr appExcel;
	DECLARE_MESSAGE_MAP()
public:
	CString sDatabase;
	SPMaskEdit m_EdStart;
	
	virtual BOOL OnInitDialog();
	SPMaskEdit m_EdEnd;
	afx_msg void OnBnClickedOk();
	int GetRowPos(CString* sData, int* Val);
	int GetRowsZones(CString* sString, CString* sData, int* iTasks,int* iStrings,int* iAssemblers);
	int GetRowsLines(CString* sString, CString* sData, int* iLine,int* iTasc,int* iTested);
};
