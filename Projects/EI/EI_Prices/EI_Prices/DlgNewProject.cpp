// DlgNewProject.cpp : implementation file
//

#include "stdafx.h"
#include "EI_Prices.h"
#include "DlgNewProject.h"


// CDlgNewProject dialog

IMPLEMENT_DYNAMIC(CDlgNewProject, CDialog)

CDlgNewProject::CDlgNewProject(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgNewProject::IDD, pParent)
{

}

CDlgNewProject::~CDlgNewProject()
{
}

void CDlgNewProject::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_NEW_PROJECT_NAME, m_EdProjectName);
}


BEGIN_MESSAGE_MAP(CDlgNewProject, CDialog)
	ON_BN_CLICKED(IDOK, &CDlgNewProject::OnBnClickedOk)
END_MESSAGE_MAP()


// CDlgNewProject message handlers

void CDlgNewProject::OnBnClickedOk()
{
	m_EdProjectName.GetWindowTextW(sNewProjectName);
	if(sNewProjectName.GetLength()>0)
		OnOK();
}
