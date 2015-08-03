// DlgBrand.cpp : implementation file
//

#include "stdafx.h"
#include "EI_Prices.h"
#include "DlgBrand.h"


// CDlgBrand dialog

IMPLEMENT_DYNAMIC(CDlgBrand, CDialog)

CDlgBrand::CDlgBrand(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgBrand::IDD, pParent)
{

	sBrandShate = "";
	sBrand = "";
}

CDlgBrand::~CDlgBrand()
{
}

void CDlgBrand::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_BRAND_SHATE, m_EdBrandShate);
	DDX_Control(pDX, IDC_EDIT_BRAND, m_EdBrand);
}


BEGIN_MESSAGE_MAP(CDlgBrand, CDialog)
	ON_BN_CLICKED(IDOK, &CDlgBrand::OnBnClickedOk)
END_MESSAGE_MAP()


// CDlgBrand message handlers

void CDlgBrand::OnBnClickedOk()
{
	m_EdBrand.GetWindowTextW(sBrand);
	m_EdBrandShate.GetWindowTextW(sBrandShate);
	if((sBrand.GetLength()<1)||(sBrandShate.GetLength()<1))
	{
		AfxMessageBox(_T("Не заполненны все параметы!"));
		return;
	}
	
	OnOK();
}

BOOL CDlgBrand::OnInitDialog()
{
	CDialog::OnInitDialog();

	m_EdBrand.SetWindowTextW(sBrand);
	m_EdBrandShate.SetWindowTextW(sBrandShate);

	return TRUE;  // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}
