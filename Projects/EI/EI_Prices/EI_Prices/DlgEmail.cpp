// DlgEmail.cpp : implementation file
//

#include "stdafx.h"
#include "EI_Prices.h"
#include "DlgEmail.h"


// CDlgEmail dialog

IMPLEMENT_DYNAMIC(CDlgEmail, CDialog)

CDlgEmail::CDlgEmail(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgEmail::IDD, pParent)
{
	sEmail = _T("");
}

CDlgEmail::~CDlgEmail()
{
}

void CDlgEmail::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_EMAIL, m_EdEmail);
}


BEGIN_MESSAGE_MAP(CDlgEmail, CDialog)
	ON_BN_CLICKED(IDOK, &CDlgEmail::OnBnClickedOk)
END_MESSAGE_MAP()


// CDlgEmail message handlers

void CDlgEmail::OnBnClickedOk()
{
	m_EdEmail.GetWindowTextW(sEmail);
	OnOK();
}

BOOL CDlgEmail::OnInitDialog()
{
	CDialog::OnInitDialog();
	m_EdEmail.SetWindowTextW(sEmail);
	return TRUE;  // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}
