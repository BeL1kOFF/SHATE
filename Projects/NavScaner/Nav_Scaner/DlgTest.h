#pragma once

#include "ScanerEdit.h"
#include "afxwin.h"
#include "MyStatic.h"
// CDlgTest dialog

class CDlgTest : public CDialog
{
	DECLARE_DYNAMIC(CDlgTest)

public:
	CDlgTest(CString sUser1, CString sDoc1, CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgTest();

// Dialog Data
	enum { IDD = IDD_DLG_TEST };

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

	DECLARE_MESSAGE_MAP()
public:
	CString sUser;
	CString sDoc;
	CString sCell;
	virtual BOOL OnInitDialog();
	CScanerEdit m_edBarCode;
	CEdit m_EdCount;
	afx_msg void OnEnUpdateEditCount();
	afx_msg void OnBnClickedButtonSave();
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	void TestScanerData(void);

	//CMyStatic m_EdStatic;
	CMyStatic m_StItemNo;
	CMyStatic m_stBrand;
	CMyStatic m_stCountInTare;
	CMyStatic m_stDescr;
	CStatic m_stItemNoText;
	CStatic m_StBrandText;
	CStatic m_StDescrText;
	CStatic m_StInfo;
	CString iRandom;

	CString sDetNo_;
	CString sLine;

	afx_msg void OnEnKillfocusEditCount();
	void TestCountData(void);
	CStatic m_StCount;
	CButton m_BtSave;
	BOOL AddInventaryPos(void);
	void ClearAll(void);
	
	CButton m_CheckNumber;
	int SetVisible(int iVisible);
	CListCtrl m_ListItems;
	afx_msg void OnHdnItemdblclickListItems(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnNMDblclkListItems(NMHDR *pNMHDR, LRESULT *pResult);
};
