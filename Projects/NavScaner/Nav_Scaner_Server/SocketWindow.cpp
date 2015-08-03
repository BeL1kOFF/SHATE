// SocketWindow.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner_Server.h"
#include "SocketWindow.h"


// CSocketWindow

IMPLEMENT_DYNAMIC(CSocketWindow, CWnd)

CSocketWindow::CSocketWindow()
{
	Socket = NULL;
}

CSocketWindow::~CSocketWindow()
{
}


BEGIN_MESSAGE_MAP(CSocketWindow, CWnd)
	ON_MESSAGE(WM_SERVER_ACCEPT,OnServerAccept)
END_MESSAGE_MAP()



// CSocketWindow message handlers



BOOL CSocketWindow::PreTranslateMessage(MSG* pMsg)
{
	// TODO: Add your specialized code here and/or call the base class
	
	return CDialog::PreTranslateMessage(pMsg);
}

afx_msg LRESULT CSocketWindow::OnServerAccept(WPARAM wParam, LPARAM lParam)
{
	if(Socket != NULL)
		Socket->AddClient(lParam);
	return 0L;
}

void CSocketWindow::SetFunction(CMessage * Soc)
{
	Socket = Soc;
}

