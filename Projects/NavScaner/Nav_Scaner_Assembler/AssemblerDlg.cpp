// AssemblerDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner_Assembler.h"
#include "AssemblerDlg.h"
#include "DlgSetting.h"


#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// CAssemblerDlg dialog

CAssemblerDlg::CAssemblerDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CAssemblerDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CAssemblerDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_STATIC_USER, m_stUser);
	DDX_Control(pDX, IDC_STATIC_LOCATION, m_stLocation);
	DDX_Control(pDX, IDC_STATIC_ZONE, m_stZone);
	DDX_Control(pDX, IDC_STATIC_CONFIRM_QUANTITY, m_stConfirm);
	DDX_Control(pDX, IDC_STATIC_NUMBER, m_stNumber);
	DDX_Control(pDX, IDC_STATIC_LAST_CONNECT, m_stLastConnect);
	DDX_Control(pDX, IDC_BUTTON_SETTING, m_btSetting);
	DDX_Control(pDX, IDC_STATIC_USER_TEXT, m_stUserText);
	DDX_Control(pDX, IDC_STATIC_LOCATION_TEXT, m_stLocationText);
	DDX_Control(pDX, IDC_STATIC_ZONE_TEXT, m_stZoneText);
	DDX_Control(pDX, IDC_STATIC_BC_TEXT, m_stBRText);
	DDX_Control(pDX, IDC_STATIC_TURN_TEXT, m_stTurnText);
	DDX_Control(pDX, IDC_STATIC_CONNECT_TEXT, m_stConnectText);
	DDX_Control(pDX, IDC_STATIC_STATE_TEXT, m_stStateText);
	DDX_Control(pDX, IDC_STATIC_STATE, m_stState);
}

BEGIN_MESSAGE_MAP(CAssemblerDlg, CDialog)
#if defined(_DEVICE_RESOLUTION_AWARE) && !defined(WIN32_PLATFORM_WFSP)
	ON_WM_SIZE()
#endif
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BUTTON_SETTING, &CAssemblerDlg::OnBnClickedButtonSetting)
END_MESSAGE_MAP()


// CAssemblerDlg message handlers

BOOL CAssemblerDlg::OnInitDialog()
{
	iVisible = 0;
	CDialog::OnInitDialog();
	m_btSetting.SetWindowTextW(_T("Настройки"));
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	ShowWindow(SW_SHOWMAXIMIZED);
	SetForegroundWindow();
	SetVisible(TRUE);
	return TRUE;  // return TRUE  unless you set the focus to a control
}

#if defined(_DEVICE_RESOLUTION_AWARE) && !defined(WIN32_PLATFORM_WFSP)
void CAssemblerDlg::OnSize(UINT /*nType*/, int /*cx*/, int /*cy*/)
{
	if (AfxIsDRAEnabled())
	{
		DRA::RelayoutDialog(
			AfxGetResourceHandle(), 
			this->m_hWnd, 
			DRA::GetDisplayMode() != DRA::Portrait ? 
			MAKEINTRESOURCE(IDD_NAV_SCANER_ASSEMBLER_DIALOG_WIDE) : 
			MAKEINTRESOURCE(IDD_NAV_SCANER_ASSEMBLER_DIALOG));
	}
}
#endif


void CAssemblerDlg::OnBnClickedButtonSetting()
{
	CDlgSetting Dialog;
	Dialog.DoModal();
}

void CAssemblerDlg::SetVisible(bool bPos)
{
	if(bPos)
	{
		CRect rec, movrec;
		int iLen;
		int iTop;
		int iWidth;
		iLen = 5;
		iWidth = 25;
		GetClientRect(rec);

		iTop = 5;
		movrec.left = rec.left + iLen;
		movrec.right = 95;
		movrec.bottom = movrec.top+iWidth;

		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stUserText.MoveWindow(movrec);
		
		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stLocationText.MoveWindow(movrec);
		
		
		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stZoneText.MoveWindow(movrec);
		
		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stBRText.MoveWindow(movrec);
		
		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stTurnText.MoveWindow(movrec);
		
		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stConnectText.MoveWindow(movrec);
				
		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stStateText.MoveWindow(movrec);
		

		iTop = 5;
		GetClientRect(rec);
		movrec.top = iTop;
		movrec.left = 105;
		movrec.right = rec.right-iLen;
		movrec.bottom = movrec.top+iWidth;

		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stUser.MoveWindow(movrec);
		
		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stLocation.MoveWindow(movrec);
		
		
		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stZone.MoveWindow(movrec);
		
		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stConfirm.MoveWindow(movrec);
		
		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stNumber.MoveWindow(movrec);
		
		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stLastConnect.MoveWindow(movrec);
				
		movrec.top = iTop;
		movrec.bottom = movrec.top+iWidth;
		iTop = movrec.bottom+iLen;
		m_stState.MoveWindow(movrec);

		//GetClientRect(rec)
		rec.top = rec.bottom - 30;
		rec.bottom = rec.top + 25;

		rec.left = rec.right/2-40;
		rec.right = rec.left+ 80;

		m_btSetting.MoveWindow(rec);

	}

	if(iVisible == 0)
	{
		m_stUser.ShowWindow(1);
		m_stLocation.ShowWindow(1);
		m_stZone.ShowWindow(1);
		m_stConfirm.ShowWindow(1);
		m_stNumber.ShowWindow(1);
		m_stLastConnect.ShowWindow(1);
		m_btSetting.ShowWindow(1);
		m_stUserText.ShowWindow(1);
		m_stLocationText.ShowWindow(1);
		m_stZoneText.ShowWindow(1);
		m_stBRText.ShowWindow(1);
		m_stTurnText.ShowWindow(1);
		m_stConnectText.ShowWindow(1);
		m_stStateText.ShowWindow(1);
		m_stState.ShowWindow(1);
	}
	else
	{
		m_stUser.ShowWindow(0);
		m_stLocation.ShowWindow(0);
		m_stZone.ShowWindow(0);
		m_stConfirm.ShowWindow(0);
		m_stNumber.ShowWindow(0);
		m_stLastConnect.ShowWindow(0);
		m_btSetting.ShowWindow(0);
		m_stUserText.ShowWindow(0);
		m_stLocationText.ShowWindow(0);
		m_stZoneText.ShowWindow(0);
		m_stBRText.ShowWindow(0);
		m_stTurnText.ShowWindow(0);
		m_stConnectText.ShowWindow(0);
		m_stStateText.ShowWindow(0);
		m_stState.ShowWindow(0);
	}



}

BOOL CAssemblerDlg::PreTranslateMessage(MSG* pMsg)
{
	if (pMsg->message == WM_KEYDOWN)
	{
		if(m_stUser.IsWindowVisible())
		{
			m_stUser.SetFocus();
			pMsg->hwnd = m_stUser.m_hWnd;
			return CDialog::PreTranslateMessage(pMsg);
		}

		if(VK_RETURN  == pMsg->wParam)
		{
			if(pMsg->hwnd == m_stUser.m_hWnd) 
				{
					TestUserName();
				}
			return TRUE;	
		}
	}

	return CDialog::PreTranslateMessage(pMsg);
}

void CAssemblerDlg::TestUserName(void)
{
	CAssemblerApp *pApp;
	pApp = (CAssemblerApp*)AfxGetApp();
	
	CString sUserName;
	m_stUser.GetWindowText(sUserName);
	
	CStringA buf, type;
	buf = pApp->csClientSocket.Translate(sUserName);
	type.Format("AUTR_%s_AUTR",buf);

	HCURSOR Cursor;
	Cursor = GetCursor();
	SetCursor(LoadCursor(NULL,IDC_WAIT));
	CStringA sRet;
	sRet = pApp->csClientSocket.SendData(type,2);
	SetCursor(Cursor);

	if(sRet.GetLength()<2)
	{
		AfxMessageBox(_T("Авторизация пользователя ")+sUserName+_T(" - не выполненна!"));
		return;
	}
	
	if(sRet != type)
	{
		sRet = sRet.Left(sRet.GetLength()-5);
		sRet = sRet.Right(sRet.GetLength()-5);
		AfxMessageBox(pApp->csClientSocket.Translate(sRet),0,0);
		return;
	}
	else
	{
		AfxMessageBox(pApp->csClientSocket.Translate(sRet),0,0);
	}

}


void CAssemblerDlg::TestScanerData(void)
{
}

void CAssemblerDlg::OnOK()
{
	
}
