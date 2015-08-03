#pragma once
#include "afxwin.h"
#include "afxcmn.h"


// CDlgInfo dialog

class CDlgInfo : public CDialog
{
	DECLARE_DYNAMIC(CDlgInfo)

public:
	CDlgInfo(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgInfo();

// Dialog Data
	enum { IDD = IDD_FIND_CELL };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedButtonClose();
	CEdit m_EdCode;
	CButton m_BtCode;
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	void TestScanerData(void);
	CListCtrl m_ListInfo;
	virtual BOOL OnInitDialog();
	CButton m_btExit;
};
