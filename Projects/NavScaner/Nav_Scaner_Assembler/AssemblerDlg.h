// AssemblerDlg.h : header file
//
#include "..\Modul\ScanerEdit.h"
#pragma once
#include "afxwin.h"

// CAssemblerDlg dialog
class CAssemblerDlg : public CDialog
{
// Construction
public:
	CAssemblerDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_NAV_SCANER_ASSEMBLER_DIALOG };


	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support

// Implementation
protected:
	int iVisible;
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
#if defined(_DEVICE_RESOLUTION_AWARE) && !defined(WIN32_PLATFORM_WFSP)
	afx_msg void OnSize(UINT /*nType*/, int /*cx*/, int /*cy*/);
#endif
	DECLARE_MESSAGE_MAP()
public:
	CScanerEdit m_stUser;
	CStatic m_stLocation;
	CStatic m_stZone;
	CStatic m_stConfirm;
	CStatic m_stNumber;
	CStatic m_stLastConnect;
	CButton m_btSetting;
	afx_msg void OnBnClickedButtonSetting();
	void SetVisible(bool bPos = FALSE);
	CStatic m_stUserText;
	CStatic m_stLocationText;
	CStatic m_stZoneText;
	CStatic m_stBRText;
	CStatic m_stTurnText;
	CStatic m_stConnectText;
	CStatic m_stStateText;
	CStatic m_stState;
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	void TestUserName(void);
	void TestScanerData(void);
protected:
	virtual void OnOK();
};
