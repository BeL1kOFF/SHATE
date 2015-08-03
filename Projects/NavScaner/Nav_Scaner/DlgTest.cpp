// DlgTest.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner.h"
#include "DlgTest.h"


// CDlgTest dialog

IMPLEMENT_DYNAMIC(CDlgTest, CDialog)

CDlgTest::CDlgTest(CString sUser1, CString sDoc1, CWnd* pParent /*=NULL*/)
	: CDialog(CDlgTest::IDD, pParent)
{
	sUser = sUser1;
	sDoc = sDoc1;
	//SetTextColor
	m_stCountInTare.SetTextColor(RGB(255,0,0));
	sDetNo_ = "";
	iRandom = _T("-1");
}

CDlgTest::~CDlgTest()
{
}

void CDlgTest::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_BARCODE, m_edBarCode);
	DDX_Control(pDX, IDC_EDIT_COUNT, m_EdCount);
	DDX_Control(pDX, IDC_STATIC_ITEM_NO_, m_StItemNo);
	DDX_Control(pDX, IDC_STATIC_BRAND, m_stBrand);
	DDX_Control(pDX, IDC_STATIC_COUNT_IN_BOX, m_stCountInTare);
	DDX_Control(pDX, IDC_STATIC_DESC, m_stDescr);
	DDX_Control(pDX, IDC_STATIC_ITEM_NO_TEXT, m_stItemNoText);
	DDX_Control(pDX, IDC_STATIC_BRAND_TEXT, m_StBrandText);
	DDX_Control(pDX, IDC_STATIC_DESCR_TEXT, m_StDescrText);
	DDX_Control(pDX, IDC_STATIC_COUNT, m_StCount);
	DDX_Control(pDX, IDC_BUTTON_SAVE, m_BtSave);
	DDX_Control(pDX, IDC_CHECK_NUMBER, m_CheckNumber);
	DDX_Control(pDX, IDC_LIST_ITEMS, m_ListItems);
	DDX_Control(pDX, IDC_STATIC_ITEMS, m_StInfo);
	
}


BEGIN_MESSAGE_MAP(CDlgTest, CDialog)
	ON_EN_UPDATE(IDC_EDIT_COUNT, &CDlgTest::OnEnUpdateEditCount)
	ON_BN_CLICKED(IDC_BUTTON_SAVE, &CDlgTest::OnBnClickedButtonSave)
	ON_EN_KILLFOCUS(IDC_EDIT_COUNT, &CDlgTest::OnEnKillfocusEditCount)
	ON_NOTIFY(HDN_ITEMDBLCLICK, 0, &CDlgTest::OnHdnItemdblclickListItems)
	ON_NOTIFY(NM_DBLCLK, IDC_LIST_ITEMS, &CDlgTest::OnNMDblclkListItems)
END_MESSAGE_MAP()


// CDlgTest message handlers

BOOL CDlgTest::OnInitDialog()
{
	CDialog::OnInitDialog();
	ShowWindow(SW_SHOWMAXIMIZED);
	SetWindowTextW(sDoc+_T(" ")+sCell);

	CRect rect,rectGl;
	GetClientRect(rectGl);

	int iVert, iHor, iSep;

	iHor = 40;
	iVert = 100;
	iSep = 5;

	

	m_stCountInTare.GetWindowRect(rect);
	m_stCountInTare.MoveWindow(rectGl.right-(rect.right-rect.left)-iSep,rectGl.top+10,(rect.right-rect.left),rectGl.top+10+rect.bottom-rect.top);

	m_StCount.GetWindowRect(rect);
	m_StCount.MoveWindow(rectGl.left+iSep,iVert,iHor-iSep,rect.bottom-rect.top);

	m_EdCount.GetWindowRect(rect);
	m_EdCount.MoveWindow(iHor+iSep,iVert,rectGl.right-50-iHor-iSep,rect.bottom-rect.top);

	m_BtSave.MoveWindow(rectGl.right-50+iSep,iVert,rectGl.right-(rectGl.right-50),rect.bottom-rect.top);
	
	iVert = iVert+rect.bottom-rect.top+iSep;
	m_stItemNoText.GetWindowRect(rect);
	m_stItemNoText.MoveWindow(rectGl.left+iSep,iVert,iHor-iSep,rect.bottom-rect.top);

	m_StItemNo.GetWindowRect(rect);
	m_StItemNo.MoveWindow(iHor+iSep,iVert,rectGl.right-iSep*2-iHor,rect.bottom-rect.top);

	iVert = iVert+rect.bottom-rect.top+iSep;
	
	m_StBrandText.GetWindowRect(rect);
	m_StBrandText.MoveWindow(rectGl.left+iSep,iVert,iHor-iSep,rect.bottom-rect.top);

	m_stBrand.GetWindowRect(rect);
	m_stBrand.MoveWindow(iHor+iSep,iVert,rectGl.right-iSep*2-iHor,rect.bottom-rect.top);

	iVert = iVert+rect.bottom-rect.top+iSep;
	
	m_StDescrText.GetWindowRect(rect);
	m_StDescrText.MoveWindow(rectGl.left+iSep,iVert,iHor-iSep,rect.bottom-rect.top);

	iVert = iVert+rect.bottom-rect.top+iSep;

	m_stDescr.GetWindowRect(rect);
	m_stDescr.MoveWindow(iSep,iVert,rectGl.right-iSep*2,rectGl.bottom-iSep-iVert);

	m_StInfo.SetWindowTextW(_T("Не обходимо выбрать позицию:"));

	DWORD dwNewStyle = LVS_EX_GRIDLINES |  LVS_EX_FULLROWSELECT;    
    m_ListItems.SetExtendedStyle(dwNewStyle);

	GetWindowRect(rect);
	rect.bottom = rect.top + 20;
	m_StInfo.MoveWindow(rect);
	
	GetWindowRect(rect);

	rect.left = rect.left+5;
	rect.right = rect.right-10;
	rect.top = rect.top + 25;
	rect.bottom = rect.bottom - 25;
	m_ListItems.MoveWindow(rect);

	/*
	[No_],
	[No_ 2],
	[Manufacturer Code],
	[Quantity in Individual Package],
	[Description],
	coalesce(idl.[Line_ID],-1),
	coalesce(idl.[Count],0)
	*/
	m_ListItems.InsertColumn(0,_T("Номер"));
	m_ListItems.InsertColumn(1,_T("Бренд"));
	m_ListItems.InsertColumn(2,_T("Номер2"));
	m_ListItems.InsertColumn(3,_T("Наименование"));
	m_ListItems.InsertColumn(4,_T("Колво в инд. уп."));
	m_ListItems.InsertColumn(5,_T("Колво проверенно"));
	m_ListItems.InsertColumn(6,_T("Строка"));
	
	

	m_ListItems.GetClientRect(rect);
	m_ListItems.SetColumnWidth(0,(rect.right-rect.left)/2);
	m_ListItems.SetColumnWidth(1,rect.right-rect.left - (rect.right-rect.left)/2);
	m_ListItems.SetColumnWidth(2,(rect.right-rect.left)/2);
	m_ListItems.SetColumnWidth(3,(rect.right-rect.left)/2);
	m_ListItems.SetColumnWidth(4,(rect.right-rect.left)/2);
	m_ListItems.SetColumnWidth(5,(rect.right-rect.left)/2);
	m_ListItems.SetColumnWidth(6,(rect.right-rect.left)/2);
	SetVisible(0);

	
	return TRUE;  // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgTest::OnEnUpdateEditCount()
{
	
}

void CDlgTest::OnBnClickedButtonSave()
{
	AddInventaryPos();
}

BOOL CDlgTest::PreTranslateMessage(MSG* pMsg)
{
	if (pMsg->message == WM_KEYDOWN)
	{
		if((pMsg->hwnd != m_edBarCode.m_hWnd)&&(pMsg->hwnd != m_EdCount.m_hWnd))
		{
			if((m_edBarCode.IsWindowVisible()))
			{
				m_edBarCode.SetFocus();
				pMsg->hwnd = m_edBarCode.m_hWnd;
				return CDialog::PreTranslateMessage(pMsg);
			}
		}

		if(VK_RETURN  == pMsg->wParam)
		{
			if(pMsg->hwnd == m_edBarCode.m_hWnd) 
				{
					TestScanerData();
				}
			return TRUE;	
		}
	}

	return CDialog::PreTranslateMessage(pMsg);
}

void CDlgTest::TestScanerData(void)
{
	int iColumnCount = 7;
	CString sCode;
	m_edBarCode.GetWindowText(sCode);
	sCode.MakeUpper();
	m_edBarCode.SetWindowTextW(_T(""));
	if(sCode.Left(4)==_T("CELL"))
	{
		if(sCode.GetLength()<5)
		{
			m_edBarCode.TestState(FALSE);
			return;
		}

		if(sDetNo_.GetLength()>0)
		{
			if(!AddInventaryPos())
			{
				return;
			}
		}
		sCell = sCode;
		SetWindowTextW(sDoc+_T(" ")+sCell);
		return;
	}
	if(sCell.GetLength()<5)
	{
		AfxMessageBox(_T("Необходимо указать ячейку!"));
		return;
	}
	
	if(sDetNo_ == sCode)
	{
		CString sCount;
		m_EdCount.GetWindowTextW(sCount);
		int iVal;
		iVal = _wtoi(sCount);
		m_stCountInTare.GetWindowText(sCount);
		iVal = iVal + _wtoi(sCount);
		sCount.Format(_T("%d"),iVal);
		m_EdCount.SetWindowTextW(sCount);
		return;
	}
	else
	{
		if(sDetNo_.GetLength()>0)
		{
			if(!AddInventaryPos())
			{
				return;
			}
		}
	}
	CNav_ScanerApp *pApp;
	pApp = (CNav_ScanerApp*)AfxGetApp();

	CStringA buf, type;

	sCode.Replace(_T("_"),_T(" "));
	sCode.Format(_T("%s_%d_%s_"),sCode,m_CheckNumber.GetState(),sDoc);
	buf = pApp->csClientSocket.Translate(sCode);
	type.Format("GIBB_%s_GIBB",buf);

	HCURSOR Cursor;
	Cursor = GetCursor();
	SetCursor(LoadCursor(NULL,IDC_WAIT));
	CStringA sRet;
	sRet = pApp->csClientSocket.SendData(type,5);
	SetCursor(Cursor);
	
	if(sRet.GetLength()<2)
	{
		m_edBarCode.TestState(FALSE);
		return;
	}
	
	if(sRet.Left(5) == "GIBB_")
		sRet = sRet.Right(sRet.GetLength()-5);	
	if(sRet.Right(5) == "_GIBB")
		sRet = sRet.Left(sRet.GetLength()-5);
	
	
	
	CString sLocation;
	sLocation = pApp->csClientSocket.Translate(sRet);
	
	int iRow,iCol;
	int iFind;
	iRow = 0;
	iCol = 0;
	sLocation.Replace(_T("\n"),_T(""));
	iFind = sLocation.Find(_T("|"),0);
	CString sString;
	if(iFind > 0)
	{
		CStringArray sArray;
		sArray.RemoveAll();
		sString = "";
		while(sLocation.GetLength()>0)
		{
			sArray.Add(sLocation.Left(iFind));
			sLocation = sLocation.Right(sLocation.GetLength()-iFind-1);
			iFind = sLocation.Find(_T("|"),0);
			iCol++;
		}

		if((sArray.GetCount()<1)||(sArray.GetCount()%iColumnCount!=0))
		{
			AfxMessageBox(_T("Ошибка передачи данных!"));
			return;
		}
		
		if(sArray.GetCount()>iColumnCount)
		{
			iFind = 0;
			while(iFind < sArray.GetCount())
			{
				m_ListItems.InsertItem((iFind/iColumnCount),sArray.ElementAt(iFind+1));
				m_ListItems.SetItemText((iFind/iColumnCount),1,sArray.ElementAt(iFind+2));
				m_ListItems.SetItemText((iFind/iColumnCount),2,sArray.ElementAt(iFind));
				m_ListItems.SetItemText((iFind/iColumnCount),3,sArray.ElementAt(iFind+4));
				m_ListItems.SetItemText((iFind/iColumnCount),4,sArray.ElementAt(iFind+3));
				m_ListItems.SetItemText((iFind/iColumnCount),5,sArray.ElementAt(iFind+6));
				m_ListItems.SetItemText((iFind/iColumnCount),6,sArray.ElementAt(iFind+5));

				iFind = iFind+iColumnCount;
			}
			SetVisible(1);
			
		}
		else
		{
			sDetNo_ = sArray.ElementAt(0);
			m_StItemNo.SetWindowTextW(sArray.ElementAt(1));
			m_stBrand.SetWindowTextW(sArray.ElementAt(2));
			m_stCountInTare.SetWindowTextW(sArray.ElementAt(3));
			m_EdCount.SetWindowText(sArray.ElementAt(3));
			m_stDescr.SetWindowTextW(sArray.ElementAt(4));
			sLine = sArray.ElementAt(6);
			//sLine = SetWindowTextW(sArray.ElementAt(5));
		}
		sArray.RemoveAll();


	}
	else
	{
		AfxMessageBox(sLocation,0,0);
	}
	iRandom = GetRandomValue();
}

void CDlgTest::OnEnKillfocusEditCount()
{
	TestCountData();
}

void CDlgTest::TestCountData(void)
{
	CString sCount;
	m_EdCount.GetWindowTextW(sCount);
	sCount = ReplaceLeftSymbols(sCount,0);
	while(sCount.Left(1)==_T("0"))
	{
		sCount= sCount.Right(sCount.GetLength()-1);
	}
	if(sCount.GetLength()<1)
		sCount = _T("0");
	m_EdCount.SetWindowText(sCount);
}

BOOL CDlgTest::AddInventaryPos(void)
{	

	if(sDetNo_.GetLength()<1)
	{
		ClearAll();
		return TRUE;
	}

	CString sCount;
	//TestCountData();
	m_EdCount.GetWindowTextW(sCount);
	
	int iCount;
	iCount = _wtoi(sCount);
	if(iCount < 0)
	{
		ClearAll();
		return TRUE;
	}

	CString sMess;

	sMess.Format(_T("%s_%s_%s_%s_%d_%s_%s_"),sUser,sDoc,sCell,sDetNo_,iCount, iRandom,sLine);

	CNav_ScanerApp *pApp;
	pApp = (CNav_ScanerApp*)AfxGetApp();

	CStringA buf, type;
	buf = pApp->csClientSocket.Translate(sMess);
	type.Format("WTLI_%s_WTLI",buf);

	HCURSOR Cursor;
	Cursor = GetCursor();
	SetCursor(LoadCursor(NULL,IDC_WAIT));
	CStringA sRet;
	sRet = pApp->csClientSocket.SendData(type,5);
	SetCursor(Cursor);

	if(sRet == "WTLI_0_WTLI")
	{
		ClearAll();
		return TRUE;
	}
	else
	{

		if(sRet.Left(5) == "WTLI_")
			sRet = sRet.Right(sRet.GetLength()-5);	
		if(sRet.Right(5) == "_WTLI")
			sRet = sRet.Left(sRet.GetLength()-5);
		
		CString sLocation;
		sLocation = pApp->csClientSocket.Translate(sRet);
		AfxMessageBox(sLocation);
		return FALSE;
	}
}

void CDlgTest::ClearAll(void)
{
	sDetNo_ = "";
	sLine = "";
	m_StItemNo.SetWindowTextW(sDetNo_);
	m_stBrand.SetWindowTextW(sDetNo_);
	m_stCountInTare.SetWindowTextW(sDetNo_);
	m_EdCount.SetWindowText(sDetNo_);
	m_stDescr.SetWindowTextW(sDetNo_);
	iRandom = _T("0");
}



int CDlgTest::SetVisible(int iVisible)
{
	switch(iVisible)
	{
	case 0:
		m_ListItems.ShowWindow(0);
		m_StInfo.ShowWindow(0);

		m_edBarCode.ShowWindow(1);
		m_EdCount.ShowWindow(1);
		m_StItemNo.ShowWindow(1);
		m_stBrand.ShowWindow(1);
		m_stCountInTare.ShowWindow(1);
		m_stDescr.ShowWindow(1);
		m_stItemNoText.ShowWindow(1);
		m_StBrandText.ShowWindow(1);
		m_StDescrText.ShowWindow(1);
		m_StCount.ShowWindow(1);
		m_BtSave.ShowWindow(1);
		m_CheckNumber.ShowWindow(1);


		break;

	case 1:
		m_edBarCode.ShowWindow(0);
		m_EdCount.ShowWindow(0);
		m_StItemNo.ShowWindow(0);
		m_stBrand.ShowWindow(0);
		m_stCountInTare.ShowWindow(0);
		m_stDescr.ShowWindow(0);
		m_stItemNoText.ShowWindow(0);
		m_StBrandText.ShowWindow(0);
		m_StDescrText.ShowWindow(0);
		m_StCount.ShowWindow(0);
		m_BtSave.ShowWindow(0);
		m_CheckNumber.ShowWindow(0);

		m_ListItems.ShowWindow(1);
		m_StInfo.ShowWindow(1);

		break;
	
	}
	return 0;
}

void CDlgTest::OnHdnItemdblclickListItems(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMHEADER phdr = reinterpret_cast<LPNMHEADER>(pNMHDR);
	*pResult = 0;

	/*if( phdr->iItem > -1)
	{
		sDetNo_ = m_ListItems.GetItemText(phdr->iItem,2);
		m_StItemNo.SetWindowTextW(m_ListItems.GetItemText(phdr->iItem,0));
		m_stBrand.SetWindowTextW(m_ListItems.GetItemText(phdr->iItem,2));
		m_stCountInTare.SetWindowTextW(m_ListItems.GetItemText(phdr->iItem,3));
		m_EdCount.SetWindowText(m_ListItems.GetItemText(phdr->iItem,3));
		m_stDescr.SetWindowTextW(m_ListItems.GetItemText(phdr->iItem,4));
		SetVisible(0);
	}*/
}

void CDlgTest::OnNMDblclkListItems(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMHEADER phdr = reinterpret_cast<LPNMHEADER>(pNMHDR);
	*pResult = 0;

	if( phdr->iItem > -1)
	{
		sDetNo_ = m_ListItems.GetItemText(phdr->iItem,2);
		m_StItemNo.SetWindowTextW(m_ListItems.GetItemText(phdr->iItem,0));
		m_stBrand.SetWindowTextW(m_ListItems.GetItemText(phdr->iItem,1));
		m_stCountInTare.SetWindowTextW(m_ListItems.GetItemText(phdr->iItem,4));
		m_EdCount.SetWindowText(m_ListItems.GetItemText(phdr->iItem,4));
		m_stDescr.SetWindowTextW(m_ListItems.GetItemText(phdr->iItem,3));
		sLine = m_ListItems.GetItemText(phdr->iItem,6);
		SetVisible(0);
	}
}
