// DlgInfo.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner.h"
#include "DlgInfo.h"


// CDlgInfo dialog

IMPLEMENT_DYNAMIC(CDlgInfo, CDialog)

CDlgInfo::CDlgInfo(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgInfo::IDD, pParent)
{

}

CDlgInfo::~CDlgInfo()
{
}

void CDlgInfo::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_CODE, m_EdCode);
	DDX_Control(pDX, IDC_CHECK_CODE, m_BtCode);
	DDX_Control(pDX, IDC_LIST_INFO, m_ListInfo);
	DDX_Control(pDX, IDC_BUTTON_CLOSE, m_btExit);
}


BEGIN_MESSAGE_MAP(CDlgInfo, CDialog)
	ON_BN_CLICKED(IDC_BUTTON_CLOSE, &CDlgInfo::OnBnClickedButtonClose)
END_MESSAGE_MAP()


// CDlgInfo message handlers

void CDlgInfo::OnBnClickedButtonClose()
{
	OnCancel();
}

BOOL CDlgInfo::PreTranslateMessage(MSG* pMsg)
{
	if (pMsg->message == WM_KEYDOWN)
	{
		
		if((pMsg->hwnd != m_EdCode.m_hWnd)&&(pMsg->hwnd != m_EdCode.m_hWnd))
		{
			if((m_EdCode.IsWindowVisible()))
			{
				m_EdCode.SetFocus();
				pMsg->hwnd = m_EdCode.m_hWnd;
				return CDialog::PreTranslateMessage(pMsg);
			}
		}

		if(VK_RETURN  == pMsg->wParam)
		{
			if(pMsg->hwnd == m_EdCode.m_hWnd) 
				{
					TestScanerData();
					m_EdCode.SetFocus();
				}		
			return TRUE;	
		}

		
	}

	return CDialog::PreTranslateMessage(pMsg);
}

void CDlgInfo::TestScanerData(void)
{
	CNav_ScanerApp *pApp;
	pApp = (CNav_ScanerApp*)AfxGetApp();
	m_ListInfo.DeleteAllItems();
	CString sCode;
	m_EdCode.GetWindowText(sCode);
	sCode.MakeUpper();
	m_EdCode.SetWindowTextW(_T(""));
	sCode.Replace(_T("'"),_T(""));
	
	CStringA type;
	CString sBuf;
	if (m_BtCode.GetState())
		sBuf.Format(_T("1_%s"),sCode);
	else
		sBuf.Format(_T("0_%s"),sCode);
	type.Format("GIBD_%s_GIBD",pApp->csClientSocket.Translate(sBuf));
	
	HCURSOR Cursor;
	Cursor = GetCursor();
	SetCursor(LoadCursor(NULL,IDC_WAIT));
	CStringA sRet;
	sRet = pApp->csClientSocket.SendData(type,5);
	SetCursor(Cursor);
	
	if(sRet.Left(5) == "GIBD_")
			sRet = sRet.Right(sRet.GetLength()-5);	
	if(sRet.Right(5) == "_GIBD")
			sRet = sRet.Left(sRet.GetLength()-5);
	
	CString sValue;
	sValue = pApp->csClientSocket.Translate(sRet);

	if(sValue.GetLength()<5)
	{
		AfxMessageBox(_T("Ничего не найдено!"));
		return;
	}

	int iPos;
	iPos = sValue.Find(_T("|"),0);
	int iLine;
	iLine = 0;
	while(iPos > -1)
	{
		m_ListInfo.InsertItem(iLine,sValue.Left(iPos));
		sValue = sValue.Right(sValue.GetLength()-1-iPos);
        iPos = sValue.Find(_T("|"),0);
		m_ListInfo.SetItemText(iLine,1,sValue.Left(iPos));
		sValue = sValue.Right(sValue.GetLength()-1-iPos);
        iPos = sValue.Find(_T("|"),0);
		m_ListInfo.SetItemText(iLine,2,sValue.Left(iPos));
		sValue = sValue.Right(sValue.GetLength()-1-iPos);
		iLine++;
		iPos = sValue.Find(_T("|"),0);
	}
	
}

BOOL CDlgInfo::OnInitDialog()
{
	CDialog::OnInitDialog();
	ShowWindow(SW_SHOWMAXIMIZED);
	DWORD dwNewStyle = LVS_EX_GRIDLINES |  LVS_EX_FULLROWSELECT;    
    m_ListInfo.SetExtendedStyle(dwNewStyle);

	CRect rec;
	GetClientRect(rec);
	rec.top = rec.top+40;
	rec.left = rec.left +5;
	rec.right = rec.right -10;
	rec.bottom = rec.bottom-30;
	m_ListInfo.MoveWindow(rec);

	rec.top = rec.bottom+5;
	rec.bottom = rec.top +20;

	rec.left = rec.right/2-30;
	rec.right = rec.left +60;
	m_btExit.MoveWindow(rec);

	m_ListInfo.InsertColumn(0,_T("Номер"));
	m_ListInfo.InsertColumn(1,_T("Бренд"));
	m_ListInfo.InsertColumn(2,_T("Ячейка"));
	CRect rect;
	m_ListInfo.GetClientRect(rect);
	m_ListInfo.SetColumnWidth(0,2*((rect.right-rect.left)/5));
	m_ListInfo.SetColumnWidth(1,(rect.right-rect.left)/5);
	m_ListInfo.SetColumnWidth(2,(rect.right-rect.left)-3*((rect.right-rect.left)/5));
	
	

	return TRUE;  // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}
