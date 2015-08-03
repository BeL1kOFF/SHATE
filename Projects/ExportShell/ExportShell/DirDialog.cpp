// DirDialog.cpp : implementation file
//

#include "stdafx.h"
#include "ExportShell.h"
#include "DirDialog.h"


// CDirDialog

IMPLEMENT_DYNAMIC(CDirDialog, CFileDialog)

CDirDialog::CDirDialog(BOOL bOpenFileDialog, LPCTSTR lpszDefExt, LPCTSTR lpszFileName,
		DWORD dwFlags, LPCTSTR lpszFilter, CWnd* pParentWnd) :
		CFileDialog(bOpenFileDialog, lpszDefExt, lpszFileName, dwFlags, lpszFilter, pParentWnd)
{

}

CDirDialog::~CDirDialog()
{
}


BEGIN_MESSAGE_MAP(CDirDialog, CFileDialog)
END_MESSAGE_MAP()



// CDirDialog message handlers



BOOL CDirDialog::OnInitDialog()
{
	CFileDialog::OnInitDialog();

	

	
	return TRUE;  
}
