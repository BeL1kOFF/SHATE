// DlgTestTask.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner.h"
#include "DlgTestTask.h"
#include "DlgInfo.h"


// CDlgTestTask dialog

IMPLEMENT_DYNAMIC(CDlgTestTask, CDialog)

CDlgTestTask::CDlgTestTask(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgTestTask::IDD, pParent)
	, sUserNav(_T(""))
	, sDoc(_T(""))
	, sZone(_T(""))
	, bDecSort(FALSE)
	, sCell(_T(""))
	, iCurrRow(0)
{
	bBizy = TRUE;
	
	m_StCountInTare.SetTextColor(RGB(255,0,0));
	CBitmap bm, bm1;
	m_BigImageList.Create(MAKEINTRESOURCE(IDB_BITMAP_ASK_TASK), 20, 1, RGB(255,255,255));
	bm.LoadBitmap(IDB_BITMAP_EXIT);
	m_BigImageList.Add(&bm, RGB(255, 255, 255));

	bm1.LoadBitmap(IDB_BITMAP_INFO);
	m_BigImageList.Add(&bm1, RGB(255, 255, 255));

}

CDlgTestTask::~CDlgTestTask()
{
	stElement * Elem;
	while(aElem.GetCount()>0)
	{
		Elem = aElem.ElementAt(0);
		delete(Elem);
		aElem.RemoveAt(0,1);
	}

	if(hThredTestTask)
		{
			TerminateThread(hThredTestTask,0);
		}
}

void CDlgTestTask::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_STATIC_MESS, m_stMess);
	DDX_Control(pDX, IDC_STATIC_CURRENT_LINE, m_stCurrLine);
	DDX_Control(pDX, IDC_STATIC_CURR_VALUE, m_stCurrValue);
	DDX_Control(pDX, IDC_STATIC_COUNT_IN_TARE, m_StCountInTare);
	DDX_Control(pDX, IDC_EDIT_BARCODE, m_EdBarCode);
	DDX_Control(pDX, IDC_STATIC_COUNT_TEXT, m_stCountText);
	DDX_Control(pDX, IDC_EDIT_COUNT, m_EdCount);
	DDX_Control(pDX, IDC_STATIC_INFO, m_stInfo);
}


BEGIN_MESSAGE_MAP(CDlgTestTask, CDialog)
	ON_NOTIFY(BM_CLICK, IDC_BUTTON_ASC_TASK, OnAscTask)
	ON_NOTIFY(BM_CLICK, IDC_END_TASK, OnExit)
	ON_NOTIFY(BM_CLICK, IDC_INFO, OnInfo)
	ON_MESSAGE(WM_SEND_ASC, Mess_AscTask)
	ON_MESSAGE(WM_SEND_CONNECT_STATE, Mess_Connect)
	ON_NOTIFY(GVN_SELCHANGED, IDC_GRID_FO_TEST, OnGridFoTest)
END_MESSAGE_MAP()


// CDlgTestTask message handlers

BOOL CDlgTestTask::OnInitDialog()
{
	CDialog::OnInitDialog();
	ShowWindow(SW_SHOWMAXIMIZED);
	
	hThredTestTask = CreateThread(NULL, NULL, (LPTHREAD_START_ROUTINE)TestTask, (void*)this, NULL, &dwThreadID); 
	CRect rect,rectGl;
	GetClientRect(rectGl);

	int iSep;
	iSep = 5;
	int iStaticWidth;
	iStaticWidth = 20;
	m_StCountInTare.MoveWindow(rectGl.right-iStaticWidth-iSep,rectGl.top+iSep,iStaticWidth,iStaticWidth);
	
	rectGl.left = rectGl.left+iSep;
	rectGl.top = rectGl.top+iSep;
	rectGl.right = rectGl.right - iSep;
	m_EdBarCode.MoveWindow(rectGl.left,rectGl.top,rectGl.left+60,rectGl.top+15);
	
	rect.left = rectGl.left+iSep+60;
	rect.right = (rectGl.right-iStaticWidth-iSep - iSep) - rect.left;
	rect.top = rectGl.top;
	rect.bottom = rectGl.top+iStaticWidth+2;

	rect.left = rect.left+(rect.right-iStaticWidth)/2-2;
	rect.right = rect.left+iStaticWidth+2;

	ImageOK.Create(rect,this,IDC_BUTTON_ASC_TASK,WS_VISIBLE|WS_CHILD|WS_BORDER);
	ImageOK.SetImage(&m_BigImageList,0);

	rect.left = rect.left+iStaticWidth+10;
	rect.right = rect.left+iStaticWidth+2;

	Exit.Create(rect,this,IDC_END_TASK,WS_VISIBLE|WS_CHILD|WS_BORDER);
	Exit.SetImage(&m_BigImageList,1);

	rect.left = rect.left+iStaticWidth+10;
	rect.right = rect.left+iStaticWidth+2;

	Info.Create(rect,this,IDC_INFO,WS_VISIBLE|WS_CHILD|WS_BORDER);
	Info.SetImage(&m_BigImageList,2);

	//ExitInfo

	rectGl.top = rectGl.top+iStaticWidth+iSep+iSep;
	m_stCurrLine.MoveWindow(rectGl.left,rectGl.top,rectGl.left+60,iStaticWidth);
	m_stCurrValue.MoveWindow(rectGl.left+60+iSep,rectGl.top,rectGl.right-(rectGl.left+60+iSep),iStaticWidth);

	rectGl.top = rectGl.top+iStaticWidth+iSep;
	m_stCountText.MoveWindow(rectGl.left,rectGl.top,rectGl.left+60,iStaticWidth);
	m_EdCount.MoveWindow(rectGl.left+60+iSep,rectGl.top,rectGl.right-(rectGl.left+60+iSep),iStaticWidth);

	rectGl.top = rectGl.top+iStaticWidth+iSep;
	m_stInfo.MoveWindow(rectGl.left,rectGl.top,rectGl.right-iSep,3*iStaticWidth);

	rectGl.top = rectGl.top+3*iStaticWidth+iSep;
	GetClientRect(rect);
	rect.bottom = rect.bottom - 5;
	rect.top = rectGl.top;
	rect.left = 5;
	rect.right = rect.right - 10;

	GridFoTest.Create(rect,(CWnd*)this,IDC_GRID_FO_TEST,WS_CHILD|WS_BORDER);
	GridFoTest.SetColumnCount(7);
	GridFoTest.SetRowCount(1);
	GridFoTest.SetFixedRowCount(1);
	GridFoTest.SetEditable(FALSE);
	GridFoTest.SetItemText(0,0,_T("Код"));
	GridFoTest.SetItemText(0,1,_T("Кол-во"));
	GridFoTest.SetItemText(0,2,_T("Проверенно"));
	GridFoTest.SetItemText(0,3,_T("BarCode"));
	GridFoTest.SetItemText(0,4,_T("Кол-во в упаковке"));
	GridFoTest.SetItemText(0,5,_T("Описание"));
	GridFoTest.SetItemText(0,6,_T("Номер"));
	GridFoTest.iBarCodeColumn = 3;

	SetCaption();
	m_stMess.SetWindowTextW(_T("Начало работы"));
	SetVisible(0);

	GridFoTest.GetClientRect(rect);
	GridFoTest.SetColumnWidth(0,3*(rect.right - rect.left)/5);
	GridFoTest.SetColumnWidth(1,(rect.right - rect.left)/5);
	GridFoTest.SetColumnWidth(2,(rect.right - rect.left) - 4*(rect.right - rect.left)/5);
	GridFoTest.SetColumnWidth(3, (rect.right - rect.left)/5);
	GridFoTest.SetColumnWidth(4, (rect.right - rect.left)/5);
	GridFoTest.SetColumnWidth(5, 3*(rect.right - rect.left)/5);
	GridFoTest.SetColumnWidth(6, (rect.right - rect.left)/5);

	return TRUE;  // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}

int CDlgTestTask::SetCaption(void)
{
	SetWindowText(sUserNav+_T(" ")+sDoc+_T(" ")+sCell+_T(" "));
	return 0;
}

int CDlgTestTask::SetVisible(int iType)
{
	if(iType == 0)
	{
		bBizy = FALSE;
		m_stCurrLine.ShowWindow(0);
		m_stInfo.ShowWindow(0);
		m_EdBarCode.ShowWindow(0);
		m_StCountInTare.ShowWindow(0);
		m_stCurrValue.ShowWindow(0);
		m_stCountText.ShowWindow(0);
		m_EdCount.ShowWindow(0);
		GridFoTest.ShowWindow(0);
		ImageOK.ShowWindow(0);
		Exit.ShowWindow(0);
		Info.ShowWindow(0);

		
		m_stMess.ShowWindow(1);
		return 0; 
	}

	if(iType == 1)
	{
		m_stMess.ShowWindow(0);

		m_stInfo.ShowWindow(1);
		m_stCurrLine.ShowWindow(1);
		m_StCountInTare.ShowWindow(1);
		m_EdBarCode.ShowWindow(1);
		m_stCurrValue.ShowWindow(1);
		m_stCountText.ShowWindow(1);
		m_EdCount.ShowWindow(1);
		GridFoTest.ShowWindow(1);
		ImageOK.ShowWindow(1);
		Exit.ShowWindow(1);
		Info.ShowWindow(1);
		
		return 0;	
	}
	return 0;
}

DWORD CDlgTestTask::TestTask(DWORD someparam)
{
	CDlgTestTask* dlg;
	dlg = (CDlgTestTask*)someparam;
	if(dlg!=NULL)
	{
		CNav_ScanerApp *pApp;
		pApp = (CNav_ScanerApp*)AfxGetApp();
		while(true)
		{
			if(!dlg->bBizy)
			{
				if(pApp->csClientSocket.bStarted)
				{
					if(dlg->m_hWnd!=NULL)
					{
						dlg->PostMessage(WM_SEND_CONNECT_STATE,0,1);	
						dlg->PostMessage(WM_SEND_ASC,0,0);		
					}
				}
				else
				{
					if(dlg->m_hWnd!=NULL)
					{
						dlg->PostMessage(WM_SEND_CONNECT_STATE,0,0);	
						dlg->PostMessage(WM_SEND_ASC,0,0);		
					}
				}
			}
			Sleep(1000);
		}
	}
	return 0l;
}

LRESULT CDlgTestTask::Mess_Connect(WPARAM wParam, LPARAM lParam)
{
	CString sName;
	CString sOld;
	m_stMess.GetWindowText(sName);
	sOld = "";
	int ipos;
	ipos = sName.Find(_T("\n"),0);
	if(ipos>-1)
	{
		sOld = sName.Left(ipos);
		sName = sName.Right(sName.GetLength()-ipos-1);
	}
	if(lParam==1)
	{
		if(sOld != _T("Подключен к серверу"))
		{
			sName = _T("Подключен к серверу\n")+sName;
			m_stMess.SetWindowText(sName);
			m_stMess.ShowWindow(0);
			m_stMess.ShowWindow(1);	
		}
	}
	else
	{
		if(sOld != _T("Непоключен к серверу"))
		{
			sName = _T("Непоключен к серверу\n")+sName;
			m_stMess.SetWindowText(sName);
			m_stMess.ShowWindow(0);
			m_stMess.ShowWindow(1);
		}
	}
	return 0L;
}

LRESULT CDlgTestTask::Mess_AscTask(WPARAM wParam, LPARAM lParam)
{
	if(bBizy)
		return 0L;
	iCurrRow = 0;
	sCell = "";
	bBizy = TRUE;
	CNav_ScanerApp *pApp;
	pApp = (CNav_ScanerApp*)AfxGetApp();
	
	CStringA type;
	CString sBuf;
	//sUserNav,sDoc,sZone,bDecSort);
	sBuf.Format(_T("%s_%s_%s_%d"),sUserNav,sDoc,sZone,bDecSort);
	type.Format("GTTI_%s_GTTI",pApp->csClientSocket.Translate(sBuf));
	HCURSOR Cursor;
	Cursor = GetCursor();
	SetCursor(LoadCursor(NULL,IDC_WAIT));
	CStringA sRet;
	sRet = pApp->csClientSocket.SendData(type,5);
	SetCursor(Cursor);

	if(sRet.Left(5) == "GTTI_")
			sRet = sRet.Right(sRet.GetLength()-5);	
	if(sRet.Right(5) == "_GTTI")
			sRet = sRet.Left(sRet.GetLength()-5);
	
	CString sValue;
	sValue = pApp->csClientSocket.Translate(sRet);
	//AfxMessageBox(sLocation);
	CString sType;
	int iFind;
	iFind =  sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sType = sValue.Left(iFind);
		if(sType == _T("-1"))
		{
			sAddMessage(_T("По данной зоне работа завершена!"));
			return 0L;
		}
		if(sType == _T("1"))
		{
			sValue = sValue.Right(sValue.GetLength()-iFind-1);
			sCell = sValue;
			SetCaption();
		}

		if(sType ==  _T("2"))
		{
			sValue = sValue.Right(sValue.GetLength()-iFind-1);
			sCell = sValue;
			SetCaption();

			sBuf.Format(_T("%s_%s_%s_%s"),sUserNav,sDoc,sZone,sCell);
			type.Format("GPTI_%s_GPTI",pApp->csClientSocket.Translate(sBuf));
			Cursor = GetCursor();
			SetCursor(LoadCursor(NULL,IDC_WAIT));
			CStringA sRet;
			sRet = pApp->csClientSocket.SendData(type,5);
			SetCursor(Cursor);
			if(sRet.Left(5) == "GPTI_")
				sRet = sRet.Right(sRet.GetLength()-5);	
			if(sRet.Right(5) == "_GPTI")
				sRet = sRet.Left(sRet.GetLength()-5);
			sValue = pApp->csClientSocket.Translate(sRet);
			stElement * Elem;
			while(aElem.GetCount()>0)
			{
				Elem = aElem.ElementAt(0);
				delete(Elem);
				aElem.RemoveAt(0,1);
			}
			Elem = NULL;
			CStringArray sa;
			
			while(sValue.GetLength()>0)
			{
				iFind = sValue.Find(_T("|"),0);
				if(iFind > -1)
				{
					sa.Add(sValue.Left(iFind));
					sValue = sValue.Right(sValue.GetLength()-iFind-1);
				}
				else
				{
					sa.Add(sValue);
					sValue = "";
				}
			}
			while(sa.GetCount()>=POS_FIELD)
			{
				if(Elem!=NULL)
				{
					if(Elem->sNo == sa.ElementAt(0))
					{
						Elem->sBarCode = Elem->sBarCode + sa.ElementAt(7)+_T("|");
						sa.RemoveAt(0,POS_FIELD);
						continue;
					}
				}
				Elem = new(stElement);
				Elem->sNo = sa.ElementAt(0);	
				Elem->sNo2 = sa.ElementAt(1);
				Elem->sMan = sa.ElementAt(2);
				Elem->sQInPack = _wtoi(sa.ElementAt(3));
				Elem->sDecr = sa.ElementAt(4);
				Elem->iLine = _wtoi(sa.ElementAt(5));
				Elem->Qnt = _wtoi(sa.ElementAt(6));
				Elem->sBarCode = _T("|")+sa.ElementAt(7)+_T("|");
				sa.RemoveAt(0,POS_FIELD);
				aElem.Add(Elem);

			}
			if(sa.GetCount() > 0)
			{
				sAddMessage(_T("ошибка при получении данных"));
			}
			else
			{
				GridFoTest.SetRowCount(aElem.GetCount()+1);
				int i;
				for(i=0;i<aElem.GetCount();i++)
				{
					Elem = aElem.ElementAt(i);
					GridFoTest.SetItemText(i+1,0,Elem->sNo2+_T("_")+Elem->sMan);
					GridFoTest.SetItemData(i+1,0,Elem->iLine);
					sValue.Format(_T("%d"),Elem->Qnt);
					GridFoTest.SetItemText(i+1,1,sValue);
					GridFoTest.SetItemText(i+1,2,_T("0"));
					sValue.Format(_T("%d"),Elem->sQInPack);
					GridFoTest.SetItemText(i+1,4,sValue);
					GridFoTest.SetItemText(i+1,5,Elem->sDecr);
					GridFoTest.SetItemText(i+1,6,Elem->sNo);
					GridFoTest.SetItemText(i+1,GridFoTest.iBarCodeColumn,Elem->sBarCode);
				}
				iRandom = GetRandomValue(); 
				SetVisible(1);
				return 0L;
			}
		}
	}
	else
	{
		sAddMessage(sValue);
	}

	if(sCell.GetLength() > 0)
	{
		
	
	}
	bBizy = FALSE;
	return 0L;
}
void CDlgTestTask::sAddMessage(CString sMess)
{
	int ipos;
	CString sName;
	m_stMess.GetWindowTextW(sName);
	ipos = sName.Find(_T("\n"),0);
	if(ipos>-1)
	{
		sName = sName.Left(ipos);
	}
	m_stMess.SetWindowText(sName + _T("\n")+sMess);
}


void CDlgTestTask::OnGridFoTest(NMHDR *pNotifyStruct, LRESULT* pResult)
{
    NM_GRIDVIEW* pItem = (NM_GRIDVIEW*) pNotifyStruct;
    *pResult = 0;
	if(pItem->iRow<1)
		return;
	
	LoadDataByGrid(pItem->iRow);
	
}
BOOL CDlgTestTask::LoadDataByGrid(int iRow, BOOL bAdd)
{
	if((iRow < 0)||(iRow > GridFoTest.GetRowCount()-1))
	{
		return FALSE;
	}
	if(iCurrRow > 0)
	{
		CString sValue;
		m_EdCount.GetWindowTextW(sValue);
		GridFoTest.SetItemText(iCurrRow,2, sValue);
		
		iCurrRow = 0;
		m_stCurrValue.SetWindowTextW(_T(""));
		m_stInfo.SetWindowTextW(_T(""));
		m_EdCount.SetWindowTextW(_T(""));
		GridFoTest.Invalidate();
	}
	
	if(iRow > 0)
	{
		iCurrRow = iRow;
		m_stCurrValue.SetWindowTextW(GridFoTest.GetItemText(iRow,0));
		m_stInfo.SetWindowTextW(GridFoTest.GetItemText(iRow,5));
		if(bAdd)
		{
			CString sValue;
			sValue.Format(_T("%d"),_wtoi(GridFoTest.GetItemText(iRow,2))+_wtoi(GridFoTest.GetItemText(iRow,4)));
			m_EdCount.SetWindowTextW(sValue);
		}
		else
			m_EdCount.SetWindowTextW(GridFoTest.GetItemText(iRow,2));
			
		m_StCountInTare.SetWindowTextW(GridFoTest.GetItemText(iRow,4));
		GridFoTest.SelectRow(iRow);

		
	}
	return TRUE;
}

void CDlgTestTask::OnOK()
{
	
}

BOOL CDlgTestTask::PreTranslateMessage(MSG* pMsg)
{
	if (pMsg->message == WM_KEYDOWN)
	{
		if(VK_F5 == pMsg->wParam)
		{
			if((m_EdBarCode.IsWindowVisible()))
			{
				OnAscTask();
				m_EdBarCode.SetFocus();
				return TRUE;	
			}
		}

		if(VK_F10 == pMsg->wParam)
		{
			if((m_EdBarCode.IsWindowVisible()))
			{
				OnExit();
				return TRUE;	
			}
		}

		if((pMsg->hwnd != m_EdBarCode.m_hWnd)&&(pMsg->hwnd != m_EdCount.m_hWnd))
		{
			if((m_EdBarCode.IsWindowVisible()))
			{
				m_EdBarCode.SetFocus();
				pMsg->hwnd = m_EdBarCode.m_hWnd;
				return CDialog::PreTranslateMessage(pMsg);
			}
		}

		if(VK_RETURN  == pMsg->wParam)
		{
			if(pMsg->hwnd == m_EdBarCode.m_hWnd) 
				{
					TestScanerData();
					m_EdBarCode.SetFocus();
				}

			if(pMsg->hwnd == m_EdCount.m_hWnd) 
				{
					LoadDataByGrid(0);
					m_EdBarCode.SetFocus();
				}

			
			return TRUE;	
		}

		
	}

	return CDialog::PreTranslateMessage(pMsg);
}

int CDlgTestTask::TestScanerData(void)
{
	CString sCode;
	m_EdBarCode.GetWindowText(sCode);
	sCode.MakeUpper();
	m_EdBarCode.SetWindowTextW(_T(""));
	CString sValue;
	int i=1;
	while(i<GridFoTest.GetRowCount())
	{
		sValue = GridFoTest.GetItemText(i,GridFoTest.iBarCodeColumn);
		if(sValue.Find(_T("|")+sCode+_T("|"),0)>-1)
		{
			LoadDataByGrid(i, TRUE);
			m_EdBarCode.TestState(TRUE);
			return 0;
		}
		i++;
	}

	m_EdBarCode.TestState(FALSE);
	return 0;
}

void CDlgTestTask::OnAscTask(void)
{
	LoadDataByGrid(0);
	CString sValue;
	CString sError;
	sError = "";
	CString sMess;
	int i;
	for(i = 1;i< GridFoTest.GetRowCount();i++)
	{
		if(GridFoTest.GetItemText(i,2)!=GridFoTest.GetItemText(i,1))
		{
			sError = sError+_T(" ")+GridFoTest.GetItemText(i,0)+_T("(")+GridFoTest.GetItemText(i,1)+_T("\\")+GridFoTest.GetItemText(i,2)+_T(")");
		}
		sValue.Format(_T("%s_%s_%s_%s_%s_%s_%d_"),
			sUserNav,sDoc,sCell,GridFoTest.GetItemText(i,6),GridFoTest.GetItemText(i,2),iRandom,GridFoTest.GetItemData(i,0));
		sMess = sMess+sValue;
		
	}

	if(sError.GetLength()>0)
	{
		if(AfxMessageBox(_T("Найдены отличия в ")+sError+_T(".Продолжить?"),MB_YESNO,IDNO)==IDNO)
			return;
	}

	CStringA type;
	CString sBuf;
	//sUserNav,sDoc,sZone,bDecSort);
	CNav_ScanerApp *pApp;
		pApp = (CNav_ScanerApp*)AfxGetApp();

	
	
	//type.Format("WPDI_%s_WPDI",pApp->csClientSocket.Translate(sMess));
	HCURSOR Cursor;
	Cursor = GetCursor();
	SetCursor(LoadCursor(NULL,IDC_WAIT));
	CStringA sRet;
	sRet = pApp->csClientSocket.SendData(sMess,"WPDI",5*GridFoTest.GetRowCount());
	//sRet = pApp->csClientSocket.SendData(type,5*GridFoTest.GetRowCount(),sMess.GetLength()+10);
	SetCursor(Cursor);
	

	if(sRet != _T("WPDI_OK_WPDI"))
	{
		if(sRet.Left(5) == "WPDI_")
			sRet = sRet.Right(sRet.GetLength()-5);	
		if(sRet.Right(5) == "_WPDI")
			sRet = sRet.Left(sRet.GetLength()-5);

		CString sValue;
		sValue = pApp->csClientSocket.Translate(sRet);
		AfxMessageBox(sValue);
		return;
	}
	SetVisible(0);
}

void CDlgTestTask::OnExit(void)
{
	LoadDataByGrid(0);
	CString sValue;
	CString sError;
	sError = "";
	CString sMess;
	int i;
	for(i = 1;i< GridFoTest.GetRowCount();i++)
	{
		if(GridFoTest.GetItemText(i,2)!=GridFoTest.GetItemText(i,1))
		{
			sError = sError+_T(" ")+GridFoTest.GetItemText(i,0)+_T("(")+GridFoTest.GetItemText(i,1)+_T("\\")+GridFoTest.GetItemText(i,2)+_T(")");
		}
		sValue.Format(_T("%s_%s_%s_%s_%s_%s_%d_"),
			sUserNav,sDoc,sCell,GridFoTest.GetItemText(i,6),GridFoTest.GetItemText(i,2),iRandom,GridFoTest.GetItemData(i,0));
		sMess = sMess+sValue;
		
	}

	if(sError.GetLength()>0)
	{
		if(AfxMessageBox(_T("Найдены отличия в ")+sError+_T(".Продолжить?"),MB_YESNO,IDNO)==IDNO)
			return;
	}

	CStringA type;
	CString sBuf;
	//sUserNav,sDoc,sZone,bDecSort);
	CNav_ScanerApp *pApp;
		pApp = (CNav_ScanerApp*)AfxGetApp();

	
	
	//type.Format("WPDI_%s_WPDI",pApp->csClientSocket.Translate(sMess));
	HCURSOR Cursor;
	Cursor = GetCursor();
	SetCursor(LoadCursor(NULL,IDC_WAIT));
	CStringA sRet;
	sRet = pApp->csClientSocket.SendData(sMess,"WPDI",5*GridFoTest.GetRowCount());
	//sRet = pApp->csClientSocket.SendData(type,5*GridFoTest.GetRowCount(),sMess.GetLength()+10);
	SetCursor(Cursor);
	

	if(sRet != _T("WPDI_OK_WPDI"))
	{
		if(sRet.Left(5) == "WPDI_")
			sRet = sRet.Right(sRet.GetLength()-5);	
		if(sRet.Right(5) == "_WPDI")
			sRet = sRet.Left(sRet.GetLength()-5);

		CString sValue;
		sValue = pApp->csClientSocket.Translate(sRet);
		AfxMessageBox(sValue);
		return;
	}
	SetVisible(0);
	OnCancel();
}


void CDlgTestTask::OnInfo(void)
{
	CDlgInfo info;
	info.DoModal();
}