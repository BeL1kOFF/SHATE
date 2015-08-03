// Nav_Scaner_InterfaceDlg.h : header file
//

#pragma once
#include "afxwin.h"
#include "DocGridCtrl.h"
#include "afxcmn.h"
const int WM_ACTION = WM_USER+3000;


struct stUpdate
{
	CString sTableName;
	CString sNavName;
	CString sSQL;
	CString sVersion;
	CString sInsertSQL;
	CString sUpdateSQL;
};


// CNav_Scaner_InterfaceDlg dialog
class CNav_Scaner_InterfaceDlg : public CDialog
{
// Construction
public:
	CNav_Scaner_InterfaceDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_NAV_SCANER_INTERFACE_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	CMenu*  menuAction;
	BOOL bTerminate;
	HICON m_hIcon;
	DWORD dwThreadID;
	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
	virtual void OnOK();
public:
	CDocGridCtrl GridPosition;
	CDocGridCtrl GridLog;
	CMenu* Main_Menu;
	void OnDataBaseSetting(void);
	void OnCreateDoc();
	void OnExportDoc();
	static DWORD UpdateThread(LPVOID param);
	void UpdateData(void);
	CComboBox m_ComboLocation;
	void LoadLocation(void);
	afx_msg void OnCbnSelchangeComboLocation();
	void LoadInvDoc(void);
	CListBox m_ListDocs;
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	afx_msg void OnLbnSelchangeListDocs();
	
	void LoadTreeTask(long lDoc);
	void LoadInvDocData(void);
	void CancelTest(void);
	void TestPosition(void);
	void OnSelectedPos(NMHDR* pNMHDR, LRESULT* pResult);
protected:
	virtual void OnCancel();
public:
	afx_msg void OnSize(UINT nType, int cx, int cy);
	void Resize(void);
	CStatic m_stLocation;
	CStatic m_stDocs;
	CButton m_btFilter;
	CComboBox m_ComboFilterField;
	CComboBox m_ComboFilterOperation;
	CEdit m_EdFilterValue;
	CString GetFilterString(void);
	afx_msg void OnBnClickedButtonFilter();
	CButton m_btDistinOnly;
	CTreeCtrl m_TreeAsk;
	CStatic m_stTask;
	afx_msg void OnTvnSelchangedTreeTask(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnLbnDblclkListDocs();
	CStatic m_StGroup;
	CComboBox m_ComboGroup;
	afx_msg void OnBnClickedButtonEditGroup();
	void LoadGroup(void);
	afx_msg void OnCbnSelchangeComboGroup();
	CButton m_BtEditGroup;
};
