// DlgAddTest.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner_Interface.h"
#include "DlgAddTest.h"


// CDlgAddTest dialog

IMPLEMENT_DYNAMIC(CDlgAddTest, CDialog)

CDlgAddTest::CDlgAddTest(CWnd* pParent,CStringArray* stArray)
	: CDialog(CDlgAddTest::IDD, pParent)
{

	if(stArray != NULL)
	{
		if(stArray->GetCount() > 3)
		{
			sNo2 = stArray->ElementAt(0);
			sBrand = stArray->ElementAt(1);
			sDescr = stArray->ElementAt(2);
			sCountInTare= stArray->ElementAt(3);
		}
	}
}

CDlgAddTest::~CDlgAddTest()
{
}

void CDlgAddTest::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_STATIC_ITEM_NO_, m_stNo2);
	DDX_Control(pDX, IDC_STATIC_BRAND, m_stBrand);
	DDX_Control(pDX, IDC_STATIC_DESC, m_stDescr);
	DDX_Control(pDX, IDC_EDIT_COUNT, m_edCount);
	DDX_Control(pDX, IDC_STATIC_COUNT_IN_TARE, m_CountInTare);
	DDX_Control(pDX, IDC_EDIT_CELL, m_edCell);
}


BEGIN_MESSAGE_MAP(CDlgAddTest, CDialog)
	ON_BN_CLICKED(IDOK, &CDlgAddTest::OnBnClickedOk)
END_MESSAGE_MAP()


// CDlgAddTest message handlers

void CDlgAddTest::OnBnClickedOk()
{
	
	m_edCell.GetWindowTextW(sCell);
	if(sCell.GetLength()<1)
	{
		AfxMessageBox(_T("Не указанна ячейка!"));
		return;
	}
	m_edCount.GetWindowTextW(sCount);
	sCount.Replace(_T(" "),_T(""));
	if(sCount <= _T("0"))
	{
		AfxMessageBox(_T("Не указанно кол-во!"));
		return;
	}
	
	// TODO: Add your control notification handler code here
	OnOK();
}

BOOL CDlgAddTest::OnInitDialog()
{
	CDialog::OnInitDialog();

	m_stNo2.SetWindowTextW(sNo2);
	m_stBrand.SetWindowTextW(sBrand);
	m_stDescr.SetWindowTextW(sDescr);
	m_edCount.SetWindowTextW(_T("0"));
	m_CountInTare.SetWindowTextW(sCountInTare);
	return TRUE;  // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}
