// Nav_ScanerDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner.h"
#include "Nav_ScanerDlg.h"
#include "DlgTest.h"
#include "DlgTestTask.h"
#include "WinBase.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#endif

// CNav_ScanerDlg dialog

CNav_ScanerDlg::CNav_ScanerDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CNav_ScanerDlg::IDD, pParent)
	, sUserName(_T(""))
{
	sUserNav = "";
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CNav_ScanerDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_STATIC_USER, m_StUser);
	DDX_Control(pDX, IDC_EDIT1, m_EdUser);
	DDX_Control(pDX, IDC_BUTTON_OK, m_btOk);
	DDX_Control(pDX, IDC_BUTTON_CLOSE, m_btCancel);
	DDX_Control(pDX, IDC_BUTTON_SETTING, m_BtSetting);
	DDX_Control(pDX, IDC_STATIC_IP, m_StaticIP);
	DDX_Control(pDX, IDC_STATIC_PORT, m_StaticPort);
	DDX_Control(pDX, IDC_BUTTON_CONNECT, m_ButtonConnect);
	DDX_Control(pDX, IDC_EDIT_IP, m_EditIP);
	DDX_Control(pDX, IDC_EDIT_PORT, m_EditPort);
	DDX_Control(pDX, IDC_COMBO_LOCATION, m_ComboLocation);
	DDX_Control(pDX, IDC_STATIC_LOCATION, m_StLocation);
	DDX_Control(pDX, IDC_LIST1, m_ListInventory);
	DDX_Control(pDX, IDC_STATIC_LIST_INVENTORY, m_stListInvetory);
	DDX_Control(pDX, IDC_COMBO_INV_DOC, m_ComboInvDoc);
	DDX_Control(pDX, IDC_BUTTON_START, m_btStart);
	DDX_Control(pDX, IDC_COMBO_ZONE, m_ComboZone);
	DDX_Control(pDX, IDC_CHECK_SORT, m_BtSort);
}

BEGIN_MESSAGE_MAP(CNav_ScanerDlg, CDialog)
#if defined(_DEVICE_RESOLUTION_AWARE) && !defined(WIN32_PLATFORM_WFSP)
	ON_WM_SIZE()
#endif
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BUTTON_SETTING, &CNav_ScanerDlg::OnBnClickedButtonSetting)
	ON_BN_CLICKED(IDC_BUTTON_CLOSE, &CNav_ScanerDlg::OnBnClickedButtonClose)
	ON_BN_CLICKED(IDC_BUTTON_CONNECT, &CNav_ScanerDlg::OnBnClickedButtonConnect)
	ON_CBN_SELCHANGE(IDC_COMBO_LOCATION, &CNav_ScanerDlg::OnCbnSelchangeComboLocation)
	ON_BN_CLICKED(IDC_BUTTON_START, &CNav_ScanerDlg::OnBnClickedButtonStart)
	ON_CBN_SELCHANGE(IDC_COMBO_INV_DOC, &CNav_ScanerDlg::OnCbnSelchangeComboInvDoc)
	ON_BN_CLICKED(IDC_BUTTON_OK, &CNav_ScanerDlg::OnBnClickedButtonOk)
END_MESSAGE_MAP()


// CNav_ScanerDlg message handlers

BOOL CNav_ScanerDlg::OnInitDialog()
{
	OSVERSIONINFO osvi;
	ZeroMemory(&osvi, sizeof(OSVERSIONINFO));
	osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
	GetVersionEx((OSVERSIONINFO*)&osvi);

	sWinVersion.Format(_T("%d"),osvi.dwMajorVersion);

	iVisible = 0;
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	
	ShowWindow(SW_SHOWMAXIMIZED);
	SetForegroundWindow();
	SetVisible();

	CNav_ScanerApp *pApp;
	pApp = (CNav_ScanerApp*)AfxGetApp();
	m_EditIP.SetWindowTextW(pApp->csClientSocket.sIP);
	m_EditPort.SetWindowTextW(ReadStringFromIni(_T("CONNECT"),_T("PORT"),_T("0")));

	m_ListInventory.InsertColumn(0,_T("Дата"));
	m_ListInventory.InsertColumn(1,_T("Номер"));
	m_ListInventory.InsertColumn(2,_T("Описание"));
	return TRUE;  // return TRUE  unless you set the focus to a control
}

#if defined(_DEVICE_RESOLUTION_AWARE) && !defined(WIN32_PLATFORM_WFSP)
void CNav_ScanerDlg::OnSize(UINT /*nType*/, int /*cx*/, int /*cy*/)
{
	if (AfxIsDRAEnabled())
	{
		DRA::RelayoutDialog(
			AfxGetResourceHandle(), 
			this->m_hWnd, 
			DRA::GetDisplayMode() != DRA::Portrait ? 
			MAKEINTRESOURCE(IDD_NAV_SCANER_DIALOG_WIDE) : 
			MAKEINTRESOURCE(IDD_NAV_SCANER_DIALOG));
	}
}
#endif


void CNav_ScanerDlg::OnBnClickedButtonSetting()
{
	if(iVisible == 0)
	{
		iVisible = 1;
		SetVisible();
	}
	else
	if(iVisible == 1)
	{
		iVisible = 0;
		SetVisible();
	}
}

void CNav_ScanerDlg::SetVisible(void)
{
	switch(iVisible)
	{
		case 0:
			//0000000
			
			m_StUser.ShowWindow(1);
			m_EdUser.ShowWindow(1);
			m_btOk.ShowWindow(1);
			m_btCancel.ShowWindow(1);
			m_BtSetting.ShowWindow(1);
			//1111111
			m_BtSetting.SetWindowTextW(_T(">> Настройки"));
			m_StaticIP.ShowWindow(0);
			m_StaticPort.ShowWindow(0);
			m_ButtonConnect.ShowWindow(0);
			m_EditIP.ShowWindow(0);
			m_EditPort.ShowWindow(0);
			//222222
			m_ComboLocation.ShowWindow(0);
			m_ComboZone.ShowWindow(0);
			m_BtSort.ShowWindow(0);
			m_StLocation.ShowWindow(0);
			m_ListInventory.ShowWindow(0);
			m_stListInvetory.ShowWindow(0);
			m_ComboInvDoc.ShowWindow(0);
			m_btStart.ShowWindow(0);
			break;

		case 1:
			//0000000
			m_StUser.ShowWindow(1);
			m_EdUser.ShowWindow(1);
			m_btOk.ShowWindow(1);
			m_btCancel.ShowWindow(1);
			m_BtSetting.ShowWindow(1);
			//1111111
			m_BtSetting.SetWindowTextW(_T("<< Настройки"));
			m_StaticIP.ShowWindow(1);
			m_StaticPort.ShowWindow(1);
			m_ButtonConnect.ShowWindow(1);
			m_EditIP.ShowWindow(1);
			m_EditPort.ShowWindow(1);
			//222
			m_ComboLocation.ShowWindow(0);
			m_ComboZone.ShowWindow(0);
			m_BtSort.ShowWindow(0);
			m_StLocation.ShowWindow(0);
			m_ListInventory.ShowWindow(0);
			m_stListInvetory.ShowWindow(0);
			m_ComboInvDoc.ShowWindow(0);
			m_btStart.ShowWindow(0);
			break;

		case 2:
			//0000000
			m_StUser.ShowWindow(0);
			m_EdUser.ShowWindow(0);
			m_btOk.ShowWindow(0);
			m_btCancel.ShowWindow(0);
			m_BtSetting.ShowWindow(0);
			//1111111
			m_StaticIP.ShowWindow(0);
			m_StaticPort.ShowWindow(0);
			m_ButtonConnect.ShowWindow(0);
			m_EditIP.ShowWindow(0);
			m_EditPort.ShowWindow(0);

			//2222222
			m_ComboLocation.ShowWindow(1);


			if(m_ComboInvDoc.GetCurSel()>-1)
			{
				int iData = m_ComboInvDoc.GetCurSel();
				if(m_ComboInvDoc.GetItemData(iData) > 0)
				{
					m_ComboZone.ShowWindow(1);
					m_BtSort.ShowWindow(1);
				}
				else
				{
					m_ComboZone.ShowWindow(0);
					m_BtSort.ShowWindow(0);
				}
			}
			
			
			m_StLocation.ShowWindow(1);
			m_ListInventory.ShowWindow(0);
			m_stListInvetory.ShowWindow(1);
			m_ComboInvDoc.ShowWindow(1);
			m_btStart.ShowWindow(1);
			break;

		case 3:
			//0000000
			m_StUser.ShowWindow(0);
			m_EdUser.ShowWindow(0);
			m_btOk.ShowWindow(0);
			m_btCancel.ShowWindow(0);
			m_BtSetting.ShowWindow(0);
			//1111111
			m_StaticIP.ShowWindow(0);
			m_StaticPort.ShowWindow(0);
			m_ButtonConnect.ShowWindow(0);
			m_EditIP.ShowWindow(0);
			m_EditPort.ShowWindow(0);

			//2222222
			m_ComboLocation.ShowWindow(0);
			m_StLocation.ShowWindow(0);
			m_ListInventory.ShowWindow(0);
			m_stListInvetory.ShowWindow(0);
			m_ComboInvDoc.ShowWindow(0);
			
			m_btStart.ShowWindow(0);
			m_BtSort.ShowWindow(0);
			m_ComboZone.ShowWindow(0);
			
			//3333333
			
			



			break;

	}
}

void CNav_ScanerDlg::OnBnClickedButtonClose()
{
	CDialog::OnCancel();
}

void CNav_ScanerDlg::OnBnClickedButtonConnect()
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
	CNav_ScanerApp *pApp;
	pApp = (CNav_ScanerApp*)AfxGetApp();
	pApp->csClientSocket.sMessage = "";
	pApp->csClientSocket.sProtokol = "TCP";
	pApp->csClientSocket.iPort = _wtoi(ReadStringFromIni(_T("CONNECT"),_T("PORT"),_T("0")));
	pApp->csClientSocket.sIP = ReadStringFromIni(_T("CONNECT"),_T("IP"),_T("127.0.0.1"));
	if (!pApp->csClientSocket.StartServer()) 	
		{
			AfxMessageBox(_T("Подключение не выполненно проверте настройки!" )+pApp->csClientSocket.sMessage, MB_OK,0);	
			pApp->csClientSocket.CloseSocket();
		}

}

void CNav_ScanerDlg::SendAutorization(void)
{
	CNav_ScanerApp *pApp;
	pApp = (CNav_ScanerApp*)AfxGetApp();

	m_EdUser.GetWindowTextW(sUserName);
	if(sUserName.GetLength()<2)
		return;
	CStringA buf, type;
	buf = pApp->csClientSocket.Translate(sUserName+_T("_")+sWinVersion);
	type.Format("AUTR_%s_AUTR",buf);

	HCURSOR Cursor;
	Cursor = GetCursor();
	SetCursor(LoadCursor(NULL,IDC_WAIT));
	CStringA sRet;
	sRet = pApp->csClientSocket.SendData(type,20);
	SetCursor(Cursor);

	if(sRet.GetLength()<2)
	{
		AfxMessageBox(_T("Авторизация пользователя ")+sUserName+_T(" - не выполненна!"));
		return;
	}
	
	if(sRet.Left(type.GetLength()-5) != type.Left(type.GetLength()-5))
	{
		if(sRet.Left(5) == "AUTR_")
				sRet = sRet.Right(sRet.GetLength()-5);	
		if(sRet.Right(5) == "_AUTR")
				sRet = sRet.Left(sRet.GetLength()-5);
		AfxMessageBox(pApp->csClientSocket.Translate(sRet),0,0);
		return;
	
	}
	if(sRet.Left(5) == "AUTR_")
		sRet = sRet.Right(sRet.GetLength()-5);	
	if(sRet.Right(5) == "_AUTR")
		sRet = sRet.Left(sRet.GetLength()-5);
	//sRet = sRet.Right(sRet.GetLength() - type.GetLength()+9);

	CString sTran;
	sTran = pApp->csClientSocket.Translate(sRet);

	int iFind;
	iFind = sTran.Find(_T("_"));
	
	CString sVersion;
	CString sDate;
	CString sBions;
	sDate = "";
	sVersion = "";
	sTran = sTran + _T("______");
	iFind = sTran.Find(_T("_"),0);
	if(iFind>0)
	{
		sUserNav = sTran.Left(iFind);
		sTran = sTran.Right(sTran.GetLength()-1-iFind);
		
		iFind = sTran.Find(_T("_"),0);
		sVersion = sTran.Left(iFind);
		sTran = sTran.Right(sTran.GetLength()-1-iFind);

		iFind = sTran.Find(_T("_"),0);
		sVersion = sTran.Left(iFind);
		sTran = sTran.Right(sTran.GetLength()-1-iFind);

		iFind = sTran.Find(_T("_"),0);
		sDate = sTran.Left(iFind);
		sTran = sTran.Right(sTran.GetLength()-1-iFind);

		iFind = sTran.Find(_T("_"),0);
		sBions = sTran.Left(iFind);
		sTran = sTran.Right(sTran.GetLength()-1-iFind);

		

		//sDate
		
		if(sDate.GetLength()==14)
		{
			int iYear;
			int iMouth;
			int iDay;

			int iH;
			int iM;
			int iS;

			COleDateTime oDate;
			SYSTEMTIME time;
			GetSystemTime(&time);

			oDate.SetDateTime(time.wYear,time.wMonth,time.wDay,time.wHour,time.wMinute,time.wSecond);
			iYear = _wtoi(sDate)-_wtoi(oDate.Format(_T("%Y%m%d%H%M%S")));
			if((iYear>10)||(iYear < 10))
			{
				iYear = _wtoi(sDate.Left(4));
				sDate = sDate.Right(sDate.GetLength()-4);
				
				iMouth = _wtoi(sDate.Left(2));
				sDate = sDate.Right(sDate.GetLength()-2);

				iDay = _wtoi(sDate.Left(2));
				sDate = sDate.Right(sDate.GetLength()-2);

				iH = _wtoi(sDate.Left(2));
				sDate = sDate.Right(sDate.GetLength()-2);

				iM = _wtoi(sDate.Left(2));
				sDate = sDate.Right(sDate.GetLength()-2);

				iS = _wtoi(sDate.Left(2));
				sDate = sDate.Right(sDate.GetLength()-2);


				//oDate.SetDateTime(iYear,iMouth,iDay,iH,iM,iS);
				time.wYear = iYear;
				time.wMonth = iMouth;
				time.wDay = iDay;
				time.wHour = iH;
				time.wMinute = iM;
				time.wSecond = iS;

				TIME_ZONE_INFORMATION inf;
				GetTimeZoneInformation(&inf);
				inf.Bias = _wtoi(sBions);
				if(!SetTimeZoneInformation(&inf))
				{
					CString sError;
					sError.Format(_T("%d"),GetLastError());
					AfxMessageBox(sError);
				}

				if(!SetSystemTime(&time))
				{
					CString sError;
					sError.Format(_T("%d"),GetLastError());
					AfxMessageBox(sError);
				}
			}

		}

		if(sVersion != pApp->GetVersion())
		{
			if(AfxMessageBox(_T("Найдена новая версия программы обновить?"),MB_YESNO,IDYES) == IDYES)
			{
				CStringA buf, type;
				buf = pApp->csClientSocket.Translate(sWinVersion);
				type.Format("GNFP_%s_GNFP",buf);

				CString sFileName;
				wchar_t cBuffer[MAX_PATH];
				::GetModuleFileName(NULL, cBuffer, MAX_PATH);
				sFileName = cBuffer;
				sFileName = sFileName + _T("_");

				if(pApp->csClientSocket.SaveFile(type,sFileName,2))
				{
					sFileName =	sFileName+_T(".bat");
					sFileName = cBuffer;
					DeleteFile(sFileName+_T("_old"));
					
					CFile::Rename(sFileName,sFileName+_T("_old"));
					CFile::Rename(sFileName+_T("_"),sFileName);
					AfxMessageBox(_T("Выполненно обновление перезапустите программу!"));
					OnOK();
					return;
				}
				else
				{
					AfxMessageBox(_T("Обновление не выполненно!"));
				}

			}
		}
	}
	
	iVisible = 2;
	SetVisible();
	while(m_ComboLocation.GetCount()>0)
	{
		m_ComboLocation.DeleteString(0);
	}
	LoadLocation();
}

int CNav_ScanerDlg::LoadLocation(void)
{
	m_BtSort.SetCheck(FALSE);
	if(m_ComboLocation.GetCount()>0)
	{
		return 0;
	}

	CNav_ScanerApp *pApp;
	pApp = (CNav_ScanerApp*)AfxGetApp();

	CStringA buf, type;
	buf = pApp->csClientSocket.Translate(sUserNav);
	type.Format("LLLU_%s_LLLU",buf);

	HCURSOR Cursor;
	Cursor = GetCursor();
	SetCursor(LoadCursor(NULL,IDC_WAIT));
	CStringA sRet;
	sRet = pApp->csClientSocket.SendData(type,5);
	SetCursor(Cursor);

	if(sRet.GetLength()<2)
	{
		return 0;
	}
	
	if(sRet.Left(5) == "LLLU_")
		sRet = sRet.Right(sRet.GetLength()-5);	
	if(sRet.Right(5) == "_LLLU")
		sRet = sRet.Left(sRet.GetLength()-5);
	CString sLocation;
	sLocation = pApp->csClientSocket.Translate(sRet);
	int iFind;
	iFind = sLocation.Find(_T("|"),0);
	if(iFind > 1)
	{
		while(iFind > 1)
		{
			m_ComboLocation.AddString(sLocation.Left(iFind));
			sLocation = sLocation.Right(sLocation.GetLength()-1-iFind);
			iFind = sLocation.Find(_T("|"),0);
		}
	}
	else
	{
		AfxMessageBox(sLocation,0,0);
	}
	return 1;
}

void CNav_ScanerDlg::OnCbnSelchangeComboLocation()
{
	while(m_ComboZone.GetCount()>0)
	{
		m_ComboZone.DeleteString(0);
	}
	while(m_ComboInvDoc.GetCount()>0)
	{
		m_ComboInvDoc.DeleteString(0);
	}

	if(m_ComboLocation.GetCurSel()<0)
		return;

	CString sLocation;
	m_ComboLocation.GetLBText(m_ComboLocation.GetCurSel(),sLocation);

	CNav_ScanerApp *pApp;
	pApp = (CNav_ScanerApp*)AfxGetApp();

	CStringA buf, type;
	buf = pApp->csClientSocket.Translate(sLocation);
	type.Format("LLDL_%s_LLDL",buf);

	HCURSOR Cursor;
	Cursor = GetCursor();
	SetCursor(LoadCursor(NULL,IDC_WAIT));
	CStringA sRet;
	sRet = pApp->csClientSocket.SendData(type,5);
	SetCursor(Cursor);

	if(sRet.GetLength()<2)
	{
		return;
	}
	
	if(sRet.Left(5) == "LLDL_")
		sRet = sRet.Right(sRet.GetLength()-5);	
	if(sRet.Right(5) == "_LLDL")
		sRet = sRet.Left(sRet.GetLength()-5);
	
	sLocation = pApp->csClientSocket.Translate(sRet);
	int iRow,iCol;
	int iFind;
	iRow = 0;
	iCol = 0;
	iFind = sLocation.Find(_T("|"),0);
	CString sString;
	if(iFind > 0)
	{
		while(iFind>0)
		{
			iCol = 0;
			sString = "";
			while(iCol < 3)
			{
				sString = sString+ sLocation.Left(iFind)+_T(" ");
				sLocation = sLocation.Right(sLocation.GetLength()-iFind-1);
				iFind = sLocation.Find(_T("|"),0);
				iCol++;
			}
			m_ComboInvDoc.InsertString(iRow,sString);
			m_ComboInvDoc.SetItemData(iRow,_wtoi(sLocation.Left(iFind)));
			sLocation = sLocation.Right(sLocation.GetLength()-iFind-1);
			iFind = sLocation.Find(_T("|"),0);
			iRow++;
		}
	}
	else
	{
		AfxMessageBox(sLocation);
	}

	return;


}

void CNav_ScanerDlg::OnBnClickedButtonStart()
{
	CString sDoc;
	if(m_ComboInvDoc.GetCurSel()<0)
		return;

	m_ComboInvDoc.GetLBText(m_ComboInvDoc.GetCurSel(),sDoc);
	int iFind;
	iFind = sDoc.Find(_T(" "));
	if(iFind > 0)
		sDoc = sDoc.Left(iFind);

	CString sZone;
	
	if(m_ComboZone.IsWindowVisible())
	{
		if(m_ComboZone.GetCurSel()<0)
		{
			AfxMessageBox(_T("Не выбранна зона!"));
			return;
		}
		m_ComboZone.GetLBText(m_ComboZone.GetCurSel(),sZone);
	}
	
	if(m_ComboInvDoc.GetItemData(m_ComboInvDoc.GetCurSel())<1)
	{
		CDlgTest dialog(sUserNav,sDoc);
		dialog.DoModal();
	}
	else
	{
		BOOL bSort;
		bSort = TRUE;
		if(!m_BtSort.GetCheck())
		{
			bSort = FALSE;
		}
		CDlgTestTask dialog;
		dialog.sUserNav = sUserNav;
		dialog.sDoc = sDoc;
		dialog.sZone = sZone;
		dialog.bDecSort = bSort;

		dialog.DoModal();
	}
}

BOOL CNav_ScanerDlg::PreTranslateMessage(MSG* pMsg)
{
	if (pMsg->message == WM_KEYDOWN)
	{
		if(VK_RETURN  == pMsg->wParam)
		{
			if(pMsg->hwnd == m_EdUser.m_hWnd) 
				{
					SendAutorization();
					return TRUE;		
				}	
		}
	}
	return CDialog::PreTranslateMessage(pMsg);
}
void CNav_ScanerDlg::OnCbnSelchangeComboInvDoc()
{
	iVisible = 2;
	SetVisible();

	int iData;
	iData = m_ComboInvDoc.GetCurSel();
	if(iData < 0)
		return;

	if(m_ComboInvDoc.GetItemData(iData) < 1)
		return;

	CString sDoc;
	m_ComboInvDoc.GetLBText(iData,sDoc);
	int iFind;
	iFind = sDoc.Find(_T(" "));
	if(iFind > 0)
		sDoc = sDoc.Left(iFind);

	CNav_ScanerApp *pApp;
	pApp = (CNav_ScanerApp*)AfxGetApp();

	CStringA buf, type;
	buf = pApp->csClientSocket.Translate(sDoc);
	type.Format("LDZL_%s_LDZL",buf);

	HCURSOR Cursor;
	Cursor = GetCursor();
	SetCursor(LoadCursor(NULL,IDC_WAIT));
	CStringA sRet;
	sRet = pApp->csClientSocket.SendData(type,5);
	SetCursor(Cursor);

	if(sRet.GetLength()<2)
	{
		return;
	}
	
	if(sRet.Left(5) == "LDZL_")
		sRet = sRet.Right(sRet.GetLength()-5);	
	if(sRet.Right(5) == "_LDZL")
		sRet = sRet.Left(sRet.GetLength()-5);
	
	CString sLocation;
	sLocation = pApp->csClientSocket.Translate(sRet);
	int iRow,iCol;

	iRow = 0;
	iCol = 0;
	iFind = sLocation.Find(_T("|"),0);
	CString sString;
	if(iFind > 0)
	{
		while(iFind>0)
		{
			iCol = 0;
			sString = "";
			sString = sLocation.Left(iFind);
			sLocation = sLocation.Right(sLocation.GetLength()-iFind-1);
			iFind = sLocation.Find(_T("|"),0);
			m_ComboZone.InsertString(iRow,sString);
			iRow++;
		}
	}
	else
	{
		AfxMessageBox(sLocation);
	}

	if(m_ComboZone.GetCount()>0)
		m_ComboZone.SetCurSel(0);
	return;

	
}

void CNav_ScanerDlg::OnBnClickedButtonOk()
{
	SendAutorization();
}

void CNav_ScanerDlg::OnOK()
{
	

}
