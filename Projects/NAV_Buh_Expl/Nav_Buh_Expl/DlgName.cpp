// DlgName.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Buh_Expl.h"
#include "DlgName.h"


// CDlgName dialog

IMPLEMENT_DYNAMIC(CDlgName, CDialog)

CDlgName::CDlgName(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgName::IDD, pParent)
{

}

CDlgName::~CDlgName()
{
}

void CDlgName::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT1, m_edName);
}


BEGIN_MESSAGE_MAP(CDlgName, CDialog)
	ON_BN_CLICKED(IDOK, &CDlgName::OnBnClickedOk)
END_MESSAGE_MAP()


// CDlgName message handlers

void CDlgName::OnBnClickedOk()
{
	m_edName.GetWindowTextW(sName);
	if(sName.GetLength()<0)
		AfxMessageBox(_T("¬ведите название!"));

	int iReport;
	iReport = _wtoi(sReadFromIni(_T("REPORT"),_T("COUNT"),_T("0")));
	sName.MakeUpper();
	while(iReport > 0)
	{
		iReport--;
		CString sCell;
		sCell.Format(_T("REPORT_%d"),iReport);
		sCell.MakeUpper();
		if(sCell == sName)
		{
			AfxMessageBox(_T("ќтчет с таким именем уже существует!"));
			return;
		}
	}
	OnOK();
}
