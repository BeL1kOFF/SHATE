// DlgDatabase.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner_Interface.h"
#include "DlgDatabase.h"


// CDlgDatabase dialog

IMPLEMENT_DYNAMIC(CDlgDatabase, CDialog)

CDlgDatabase::CDlgDatabase(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgDatabase::IDD, pParent)
{

}

CDlgDatabase::~CDlgDatabase()
{
}

void CDlgDatabase::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_DB_PROG_SERVER_TEXT, m_edServerDB);
	DDX_Control(pDX, IDC_EDIT2, m_EdDBName);
	DDX_Control(pDX, IDC_EDIT_DB_NAV_SERVER_TEXT2, m_edDBNav_Server);
	DDX_Control(pDX, IDC_EDIT3, m_edDBNav_Name);
}


BEGIN_MESSAGE_MAP(CDlgDatabase, CDialog)
	ON_BN_CLICKED(IDC_BUTTON_SAVE_DB_PROG, &CDlgDatabase::OnBnClickedButtonSaveDbProg)
	ON_BN_CLICKED(IDC_BUTTON_DB_PROG_CANCEL, &CDlgDatabase::OnBnClickedButtonDbProgCancel)
	ON_BN_CLICKED(IDC_BUTTON_DB_NAV_CANCEL, &CDlgDatabase::OnBnClickedButtonDbNavCancel)
	ON_BN_CLICKED(IDC_BUTTON_DB_NAV_SAVE, &CDlgDatabase::OnBnClickedButtonDbNavSave)
END_MESSAGE_MAP()


// CDlgDatabase message handlers

BOOL CDlgDatabase::OnInitDialog()
{
	CDialog::OnInitDialog();

	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	m_edServerDB.SetWindowTextW(pApp->IniReader.ReadFromIni(_T("DB"),_T("SERVER"),_T("LOCALHOST")));
	m_EdDBName.SetWindowTextW(pApp->IniReader.ReadFromIni(_T("DB"),_T("NAME"),_T("Database")));

	m_edDBNav_Server.SetWindowTextW(pApp->IniReader.ReadFromIni(_T("DB_NAV"),_T("SERVER"),_T("LOCALHOST")));
	m_edDBNav_Name.SetWindowTextW(pApp->IniReader.ReadFromIni(_T("DB_NAV"),_T("NAME"),_T("Database")));
	return TRUE;  // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgDatabase::OnBnClickedButtonSaveDbProg()
{
	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	CString sServer;
	CString sDatabase;
	m_edServerDB.GetWindowTextW(sServer);
	m_EdDBName.GetWindowTextW(sDatabase);

	if((sServer.GetLength()<1)||(sDatabase.GetLength()<1))
	{
		AfxMessageBox(_T("Введены не все параметры"));
		return ;
	}
	
	CString sOldServer;
	CString sOldName;
	sOldServer = pApp->IniReader.ReadFromIni(_T("DB"),_T("SERVER"),_T("LOCALHOST"));
	sOldName = pApp->IniReader.ReadFromIni(_T("DB"),_T("NAME"),_T("Database"));

	pApp->IniReader.WriteToIni(_T("DB"),_T("SERVER"),sServer);
	pApp->IniReader.WriteToIni(_T("DB"),_T("NAME"),sDatabase);

	CString sError;
	if(!pApp->OpenDBProg(&sError))
	{
		pApp->IniReader.WriteToIni(_T("DB"),_T("SERVER"),sOldServer);
		pApp->IniReader.WriteToIni(_T("DB"),_T("NAME"),sOldName);
		AfxMessageBox(sError);
		return;
	}
	AfxMessageBox(_T("Выполненно!"));
}

void CDlgDatabase::OnBnClickedButtonDbProgCancel()
{
	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	m_edServerDB.SetWindowTextW(pApp->IniReader.ReadFromIni(_T("DB"),_T("SERVER"),_T("LOCALHOST")));
	m_EdDBName.SetWindowTextW(pApp->IniReader.ReadFromIni(_T("DB"),_T("NAME"),_T("Database")));
}

void CDlgDatabase::OnBnClickedButtonDbNavCancel()
{
	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	m_edDBNav_Server.SetWindowTextW(pApp->IniReader.ReadFromIni(_T("DB_NAV"),_T("SERVER"),_T("LOCALHOST")));
	m_edDBNav_Name.SetWindowTextW(pApp->IniReader.ReadFromIni(_T("DB_NAV"),_T("NAME"),_T("Database")));
}

void CDlgDatabase::OnBnClickedButtonDbNavSave()
{
	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	CString sServer;
	CString sDatabase;
	m_edDBNav_Server.GetWindowTextW(sServer);
	m_edDBNav_Name.GetWindowTextW(sDatabase);

	if((sServer.GetLength()<1)||(sDatabase.GetLength()<1))
	{
		AfxMessageBox(_T("Введены не все параметры"));
		return ;
	}
	
	CString sOldServer;
	CString sOldName;
	sOldServer = pApp->IniReader.ReadFromIni(_T("DB_NAV"),_T("SERVER"),_T("LOCALHOST"));
	sOldName = pApp->IniReader.ReadFromIni(_T("DB_NAV"),_T("NAME"),_T("Database"));

	pApp->IniReader.WriteToIni(_T("DB_NAV"),_T("SERVER"),sServer);
	pApp->IniReader.WriteToIni(_T("DB_NAV"),_T("NAME"),sDatabase);

	CString sError;
	if(!pApp->OpenDBNav(&sError))
	{
		pApp->IniReader.WriteToIni(_T("DB_NAV"),_T("SERVER"),sOldServer);
		pApp->IniReader.WriteToIni(_T("DB_NAV"),_T("NAME"),sOldName);
		AfxMessageBox(sError);
		return;
	}
	AfxMessageBox(_T("Выполненно!"));
}
