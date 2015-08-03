#pragma once

#include "SPMaskEdit.h"
#include "afxwin.h"
#include "afxcmn.h"
#include "MyTreeCtrl.h"

// CDlgNewDoc dialog

class CDlgNewDoc : public CDialog
{
	DECLARE_DYNAMIC(CDlgNewDoc)

public:
	CDlgNewDoc(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgNewDoc();

// Dialog Data
	enum { IDD = IDD_DIALOG_NEW_DOC };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	SPMaskEdit m_EdDate;
	virtual BOOL OnInitDialog();
	afx_msg void OnBnClickedOk();
	CEdit m_EdDescr;
	CString sLocation;
	void LoadData(void);
	CComboBox m_ComboBrand;
	CMyTreeCtrl m_TreeGroup;
	afx_msg void OnTvnSelchangedTreeGroup(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnTvnItemChangedTreeGroup(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnNMTVStateImageChangingTreeGroup(NMHDR *pNMHDR, LRESULT *pResult);
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	afx_msg void OnCaptureChanged(CWnd *pWnd);
	afx_msg void OnNMChangeState(NMHDR *pNMHDR, LRESULT *pResult);
	CButton m_BtSelectAll;
	afx_msg void OnBnClickedCheckSelectAll();
	CButton m_btNotFilter;
	CComboBox m_ComboCellStart;
	CComboBox m_ComboCellEnd;
	afx_msg void OnEnChangeEdit2();
	afx_msg void OnEnKillfocusEdit2();
};
