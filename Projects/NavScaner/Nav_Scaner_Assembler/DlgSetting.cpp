// DlgSetting.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner_Assembler.h"
#include "DlgSetting.h"
#include "Nav_Scaner_Assembler.h"


// CDlgSetting dialog

IMPLEMENT_DYNAMIC(CDlgSetting, CDialog)

CDlgSetting::CDlgSetting(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgSetting::IDD, pParent)
{

}

CDlgSetting::~CDlgSetting()
{
}

void CDlgSetting::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_SERVER, m_EditIP);
	DDX_Control(pDX, IDC_EDIT_PORT, m_EditPort);
}


BEGIN_MESSAGE_MAP(CDlgSetting, CDialog)
	ON_BN_CLICKED(IDOK, &CDlgSetting::OnBnClickedOk)
END_MESSAGE_MAP()


// CDlgSetting message handlers

void CDlgSetting::OnBnClickedOk()
{
	CString sIP, sPort;
	m_EditIP.GetWindowTextW(sIP);
	m_EditPort.GetWindowTextW(sPort);
	if((sIP.GetLength()<0)||(sPort.GetLength()<0))
	{
		AfxMessageBox(_T("Введены не все парметры!"),0,0);
		return;
	}
	try
	{
		int i;
		i = _wtoi(sPort);
		sPort.Format(_T("%d"),i);
		m_EditPort.SetWindowTextW(sPort);
	}
	catch(CException *e)
	{
		int iCode;
		iCode = GetLastError();
		CString s;
		s.Format(_T("ошибка: %d -  s"),iCode,GetErrorText(iCode));
		AfxMessageBox(s, MB_OK,0);	
		e->Delete();
		return;
	}
	WriteStringToIni(_T("CONNECT"),_T("IP"),sIP);
	WriteStringToIni(_T("CONNECT"),_T("PORT"),sPort);
	CAssemblerApp *pApp;
	pApp = (CAssemblerApp*)AfxGetApp();
	pApp->csClientSocket.sMessage = "";
	pApp->csClientSocket.sProtokol = "TCP";
	pApp->csClientSocket.iPort = _wtoi(ReadStringFromIni(_T("CONNECT"),_T("PORT"),_T("0")));
	pApp->csClientSocket.sIP = ReadStringFromIni(_T("CONNECT"),_T("IP"),_T("127.0.0.1"));
	if (!pApp->csClientSocket.StartServer()) 	
		{
			AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+pApp->csClientSocket.sMessage, MB_OK,0);	
			pApp->csClientSocket.CloseSocket();
			return;
		}
	OnOK();
}

BOOL CDlgSetting::OnInitDialog()
{
	CDialog::OnInitDialog();

	CAssemblerApp *pApp;
	pApp = (CAssemblerApp*)AfxGetApp();
	m_EditIP.SetWindowTextW(ReadStringFromIni(_T("CONNECT"),_T("IP"),_T("127.0.0.1")));
	m_EditPort.SetWindowTextW(ReadStringFromIni(_T("CONNECT"),_T("PORT"),_T("0")));
	return TRUE;  // return TRUE unless you set the focus to a control
}
