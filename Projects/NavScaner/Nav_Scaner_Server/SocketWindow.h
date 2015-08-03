#pragma once
#include "Message.h"

const int WM_SERVER_ACCEPT = WM_USER+1;



class CSocketWindow : public CDialog
{
	DECLARE_DYNAMIC(CSocketWindow)
	
public:
	CSocketWindow();
	virtual ~CSocketWindow();
	CMessage *Socket;
	

protected:
	DECLARE_MESSAGE_MAP()
public:
	virtual BOOL PreTranslateMessage(MSG* pMsg);
	afx_msg LRESULT OnServerAccept(WPARAM wParam, LPARAM lParam);
	void SetFunction(CMessage * Soc);
	
};


