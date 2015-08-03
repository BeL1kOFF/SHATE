// RepScanDlg.h : header file
//

#pragma once
#include "afxcmn.h"
#include "mystatic.h"
#include "CalendarEdit.h"
#include "ListDocs.h"
#include "ColorTree.h"
#include "GridDocs.h"
#include "afxwin.h"
#include "ScanerEdit.h"
#include "DateCombo.h"
#include "spmaskedit.h"
#include "PrintListBox.h"
const int WM_USER_PRINT = WM_USER+1500;

const int iAssemlePage = 0;
const int iTestPage = 1;
const int iDocPage = 2;
const int iGoodsPage = 3;

struct stDoc
{
	long lID;
	CString sData;
};

// CRepScanDlg dialog
class CRepScanDlg : public CDialog
{
// Construction
public:
	CRepScanDlg(CWnd* pParent = NULL);	// standard constructor

// Dialog Data
	enum { IDD = IDD_REPSCAN_DIALOG };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV support


// Implementation
protected:
	CMenu * MainMenu;
	CMenu   PopMenu;
	HICON m_hIcon;
	CListDocs m_ListZones;
	// Generated message map functions
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	DECLARE_MESSAGE_MAP()
public:
	CString sServer;
	CString sDatabase;
	SPMaskEdit m_EdDate;
	CGridDocs DocPosGrid;
	CGridDocs BoxGrid;
	CGridDocs GridDocs;
	CGridDocs BoxQuantGrid;
	CPrintListBox m_listLog;
	CTabCtrl m_Tab;
	CScanerEdit m_BarCode;
	CImageList m_ImageList;
	CCalendarEdit m_EdStart;
	void SetVisible(int iVisible);
	CColorTree m_TreeAssemble;
	CColorTree m_TreeTest;
	void LoadAssembleData();
	afx_msg void OnTvnItemexpandingTreeAssemble(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnNMDblclkTreeAssemble(NMHDR *pNMHDR, LRESULT *pResult);
	bool bOpenDoc(CString sTableName, int iDocID);
	bool bSelectDoc(CString sTableName, int iDocID);
	afx_msg void OnTcnSelchangeTab(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnSize(UINT nType, int cx, int cy);
	void OnSelectedListZone(NMHDR* pNMHDR, LRESULT* pResult);
	afx_msg void OnNMClickListZones(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnOpenBox(NMHDR *pNotifyStruct, LRESULT* pResult);
	afx_msg void OpenDoc(NMHDR *pNotifyStruct, LRESULT* pResult);
	afx_msg void OnTvnItemexpandedTreeTest(NMHDR *pNMHDR, LRESULT *pResult);
	afx_msg void OnNMDblclkTreeTest(NMHDR *pNMHDR, LRESULT *pResult);
	void CloseDoc();
	void TestScanerData(void);
	bool LoadDocData(CString sBarCode);
	bool FindDocDetail(CString sBarCode);
	
protected:
	virtual void OnCancel();
	virtual void OnOK();
public:
	afx_msg void OnClose();
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	void OnExit(void);
	void OnReportAssemble();
	void OnReportTest();
	void OnIdleTime();
	void OnReportLog();
	void OnReportAssembleMounth();
	void Mess_Print();
	//CDateCombo m_StartDate;
	CButton m_bSeachInLog;
	void OnBnClickedCheck1();
};
