// Nav_ScanerDlg.h : header file
//

#pragma once
#include "afxwin.h"
#include "afxcmn.h"


// CNav_ScanerDlg dialog
class CNav_ScanerDlg : public CDialog
{
// Construction
public:
	CNav_ScanerDlg(CWnd* pParent = NULL);	// standard constructor
	CClientSocket ClientSocket;
// Dialog Data
	enum { IDD = IDD_NAV_SCANER_DIALOG };


	protected:
	int iVisible;
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support

// Implementation
protected:
	CString sWinVersion;
	HICON m_hIcon;

	// Generated message map functions
	virtual BOOL OnInitDialog();
#if defined(_DEVICE_RESOLUTION_AWARE) && !defined(WIN32_PLATFORM_WFSP)
	afx_msg void OnSize(UINT /*nType*/, int /*cx*/, int /*cy*/);
#endif
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedButtonSetting();
	void SetVisible(void);
	CStatic m_StUser;
	CEdit m_EdUser;
	CButton m_btOk;
	CButton m_btCancel;
	CButton m_BtSetting;
	CButton m_BtSort;
	CStatic m_StaticIP;
	CStatic m_StaticPort;
	CButton m_ButtonConnect;
	CEdit m_EditIP;
	CEdit m_EditPort;
	CString sUserNav;
	afx_msg void OnBnClickedButtonClose();
	afx_msg void OnBnClickedButtonConnect();
//	virtual BOOL PreTranslateMessage(MSG* pMsg);
	void SendAutorization(void);
	CString sUserName;
	CComboBox m_ComboLocation;
	CStatic m_StLocation;
	int LoadLocation(void);
	afx_msg void OnEnChangeEdit1();
	afx_msg void OnCbnSelchangeComboLocation();
	CListCtrl m_ListInventory;
	CStatic m_stListInvetory;
	CComboBox m_ComboInvDoc;
	CButton m_btStart;
	afx_msg void OnBnClickedButtonStart();
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	afx_msg void OnCbnSelchangeComboInvDoc();
	afx_msg void OnBnClickedButtonOk();
	CComboBox m_ComboZone;
protected:
	virtual void OnOK();
};
