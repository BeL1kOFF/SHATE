#pragma once
#include "afxwin.h"
#include "scaneredit.h"
#include "MyStatic.h"
#include "GridNotCopying.h"
#include "MyImage.h"

const int WM_SEND_CONNECT_STATE = WM_USER+1002; 
const int WM_SEND_ASC = WM_USER+1001; 
// CDlgTestTask dialog
#define POS_FIELD 8
struct stElement
{
	CString sNo;	
	CString sNo2;
	CString sMan;
	int sQInPack;
	CString sDecr;
	int iLine;
	int Qnt;
	CString sBarCode;
};

class CDlgTestTask : public CDialog
{
	DECLARE_DYNAMIC(CDlgTestTask)

public:
	CDlgTestTask(CWnd* pParent = NULL);   // standard constructor
	virtual ~CDlgTestTask();

// Dialog Data
	enum { IDD = IDD_DLG_TEST_TAST };

protected:
	CString sTask;
	BOOL bBizy;
	HANDLE hThredTestTask;
	DWORD dwThreadID; 
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support
	LRESULT Mess_Connect(WPARAM wParam, LPARAM lParam);
	LRESULT Mess_AscTask(WPARAM wParam, LPARAM lParam);
	static DWORD TestTask(DWORD someparam);
	void OnGridFoTest(NMHDR *pNotifyStruct, LRESULT* pResult);
	DECLARE_MESSAGE_MAP()
public:
	CString iRandom;
	CImageList m_BigImageList;
	CArray<stElement*,stElement*> aElem;
	CString sUserNav;
	CString sDoc;
	BOOL bDecSort;
	CMyImage ImageOK;
	CMyImage Exit;
	CMyImage Info;
	CString sZone;
	virtual BOOL OnInitDialog();
	CString sCell;
	int SetCaption(void);
	int SetVisible(int iType);
	CStatic m_stMess;

	void sAddMessage(CString sMess);
	CStatic m_stCurrLine;
	CStatic m_stCurrValue;
	CMyStatic m_StCountInTare;
	CScanerEdit m_EdBarCode;
	CStatic m_stCountText;
	CEdit m_EdCount;
	CGridNotCopying GridFoTest;
	BOOL LoadDataByGrid(int iRow, BOOL bAdd = FALSE);
	CStatic m_stInfo;
protected:
	virtual void OnOK();
public:
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	int TestScanerData(void);
	int iCurrRow;
	void OnAscTask(void);
	void OnExit(void);
	void OnInfo(void);
};
