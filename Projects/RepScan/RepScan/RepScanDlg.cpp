// RepScanDlg.cpp : implementation file
//

#include "stdafx.h"
#include "RepScan.h"
#include "RepScanDlg.h"
#include "DlgReport.h"
#include "DlgReportMounth.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CAboutDlg dialog used for App About

class CAboutDlg : public CDialog
{
public:
	CAboutDlg();

// Dialog Data
	enum { IDD = IDD_ABOUTBOX };

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV support

// Implementation
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialog(CAboutDlg::IDD)
{

}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialog)
END_MESSAGE_MAP()


// CRepScanDlg dialog




CRepScanDlg::CRepScanDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CRepScanDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	m_TreeAssemble.hFirst = NULL;
	m_TreeTest.hFirst = NULL;
	MainMenu = NULL;
}

void CRepScanDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_TAB, m_Tab);
	DDX_Control(pDX, IDC_TREE_ASSEMBLE, m_TreeAssemble);
	DDX_Control(pDX, IDC_TREE_TEST,m_TreeTest);
	DDX_Control(pDX, IDC_LIST_ZONES, m_ListZones);
	DDX_Control(pDX, IDG_POD, DocPosGrid);
	DDX_Control(pDX, IDG_BOX, BoxGrid);
	DDX_Control(pDX, IDC_LIST_LOG, m_listLog);
	DDX_Control(pDX, IDG_BOX_QUANT, BoxQuantGrid);
	DDX_Control(pDX, IDG_DOCS, GridDocs);
	//
	DDX_Control(pDX, IDC_EDIT_DOCNUMBER, m_BarCode);
	//	DDX_Control(pDX, IDC_EDIT_START, m_StartDate);
	DDX_Control(pDX, IDC_CHECK_SEACH_LOG, m_bSeachInLog);
	DDX_Control(pDX, IDC_EDIT_DATE, m_EdDate);

}

BEGIN_MESSAGE_MAP(CRepScanDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_COMMAND(ID_CLOSE, OnExit)
	ON_COMMAND(ID_REP_ASS, OnReportAssemble)
	ON_COMMAND(ID_REPORT_TEST, OnReportTest)
	ON_COMMAND(ID_REPORT_LOG, OnReportLog)
	ON_COMMAND(ID_IDLE_TIME, OnIdleTime)
	ON_COMMAND(ID_REP_ASS_MOUNTH ,OnReportAssembleMounth)
	//OnReportTest 
	ON_NOTIFY(TVN_ITEMEXPANDING, IDC_TREE_ASSEMBLE, &CRepScanDlg::OnTvnItemexpandingTreeAssemble)
	ON_NOTIFY(NM_DBLCLK, IDC_TREE_ASSEMBLE, &CRepScanDlg::OnNMDblclkTreeAssemble)
	ON_NOTIFY(TCN_SELCHANGE, IDC_TAB, &CRepScanDlg::OnTcnSelchangeTab)
	ON_NOTIFY(NCLD_SELECTED, IDC_LIST_ZONES,OnSelectedListZone)
	ON_WM_SIZE()
	ON_NOTIFY(NM_CLICK, IDC_LIST_ZONES, &CRepScanDlg::OnNMClickListZones)
	ON_NOTIFY(GVN_SELCHANGED, IDG_BOX, OnOpenBox)
	ON_NOTIFY(GVN_SELCHANGED, IDG_DOCS, OpenDoc)
	ON_NOTIFY(TVN_ITEMEXPANDED, IDC_TREE_TEST, &CRepScanDlg::OnTvnItemexpandedTreeTest)
	ON_NOTIFY(NM_DBLCLK, IDC_TREE_TEST, &CRepScanDlg::OnNMDblclkTreeTest)
	ON_COMMAND(WM_USER_PRINT, Mess_Print)
	ON_WM_CLOSE()



END_MESSAGE_MAP()


// CRepScanDlg message handlers

BOOL CRepScanDlg::OnInitDialog()
{
	CDialog::OnInitDialog();
	m_EdDate.setMask(_T("ЧЧ.ЧЧ.ЧЧЧЧ"));

	COleDateTime date;
	date = COleDateTime::GetCurrentTime();
	m_EdDate.SetWindowText(date.Format(_T("%d%m%Y")));
	m_EdDate.SetReadOnly(TRUE);
	//m_EdDate.SetWindowTextW(
	// Add "About..." menu item to system menu.
	MainMenu = new CMenu;
	MainMenu->LoadMenu(IDR_MAIN_MENU);
	this->SetMenu(MainMenu);



	// IDM_ABOUTBOX must be in the system command range.
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != NULL)
	{
		CString strAboutMenu;
		strAboutMenu.LoadString(IDS_ABOUTBOX);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	m_bSeachInLog.SetParent(&m_Tab);
	m_EdDate.SetParent(&m_Tab);

	
	m_Tab.InsertItem(iAssemlePage,_T("Сборка   "));
	m_Tab.InsertItem(iTestPage,_T("Проверка "));
	//m_Tab.InsertItem(iDocPage,_T("Документы"));
	//m_Tab.InsertItem(iGoodsPage,_T("Товар    "));


	m_TreeAssemble.SetParent(&m_Tab);
	
	m_TreeTest.SetParent(&m_Tab);
	m_BarCode.SetParent(&m_Tab);
//	m_StartDate.SetParent(&m_Tab);
	m_ListZones.SetParent(&m_Tab);
	m_ListZones.InsertColumn(0, _T("Зона"));
	m_ListZones.InsertColumn(1, _T("Выполнение"));
	m_ListZones.InsertColumn(2, _T("Сотрудник"));
	m_ListZones.SetExtendedStyle(m_ListZones.GetExtendedStyle() |LVS_EX_FULLROWSELECT| LVS_EX_GRIDLINES);

	DocPosGrid.SetRowCount(1);
	DocPosGrid.SetFixedRowCount(1);
	DocPosGrid.SetFixedColumnCount(1);
	DocPosGrid.SetColumnCount(6);
	DocPosGrid.SetItemText(0,1,_T("Позиция"));
	DocPosGrid.SetItemText(0,2,_T("Требуеться"));
	DocPosGrid.SetItemText(0,3,_T("Проверенно"));
	DocPosGrid.SetItemText(0,4,_T("Ед. изм."));
	DocPosGrid.SetItemText(0,5,_T("Наименование"));
	DocPosGrid.SetEditable(FALSE);
	DocPosGrid.SetParent(&m_Tab);

	m_listLog.SetParent(&m_Tab);

	PopMenu.CreatePopupMenu();
	PopMenu.AppendMenuW(MF_POPUP | MF_ENABLED , WM_USER_PRINT,_T("Печать"));
	m_listLog.Menu = &PopMenu;

	BoxQuantGrid.SetRowCount(1);
	BoxQuantGrid.SetFixedRowCount(1);
	BoxQuantGrid.SetFixedColumnCount(1);
	BoxQuantGrid.SetColumnCount(4);
	BoxQuantGrid.SetItemText(0,1,_T("Позиция"));
	BoxQuantGrid.SetItemText(0,2,_T("Кол-во"));
	BoxQuantGrid.SetItemText(0,3,_T("Собранно"));
	BoxQuantGrid.SetEditable(FALSE);
	BoxQuantGrid.SetParent(&m_Tab);

	
	
	BoxGrid.SetRowCount(1);
	BoxGrid.SetFixedRowCount(1);
	BoxGrid.SetFixedColumnCount(1);
	BoxGrid.SetColumnCount(4);
	BoxGrid.SetItemText(0,1,_T("Короб"));
	BoxGrid.SetItemText(0,2,_T("Собрал"));
	BoxGrid.SetItemText(0,3,_T("Проверил"));
	BoxGrid.SetEditable(FALSE);
	BoxGrid.SetParent(&m_Tab);

	GridDocs.SetRowCount(1);
	GridDocs.SetColumnCount(12);
	GridDocs.SetFixedRowCount(1);
	GridDocs.SetFixedColumnCount(1);
	GridDocs.SetEditable(FALSE);
	GridDocs.SetItemText(0,1,_T("Номер"));
	GridDocs.SetItemText(0,2,_T("Дата"));
	GridDocs.SetItemText(0,3,_T("Тип"));
	GridDocs.SetItemText(0,4,_T("Палета"));
	GridDocs.SetItemText(0,5,_T("Подсклад"));
	GridDocs.SetItemText(0,6,_T("Оператор"));
	GridDocs.SetItemText(0,7,_T("Кол-во позиций"));
	GridDocs.SetItemText(0,8,_T("Линия"));
	GridDocs.SetItemText(0,9,_T("Маршрут"));
	GridDocs.SetItemText(0,10,_T("Проверяет"));
	GridDocs.SetItemText(0,11,_T("Ручей"));
	GridDocs.SetParent(&m_Tab);

	SetVisible(iAssemlePage);

	CString sConnect;
	


	//sConnect.Format(_T("Driver={SQL Server};SERVER=%s;DATABASE=ScanerDatabase;LANGUAGE=русский;Network=DBMSSOCN;UID=Admin;PWD=Admin;Address=%s,6009"),_T("10.0.1.244"),_T("10.0.1.244"));
	sServer = sReadFromIni(_T("DB"),_T("SERVER"),_T("svbyminssq3"));
	sWriteToIni(_T("DB"),_T("SERVER"),sServer);
	sDatabase = sReadFromIni(_T("DB"),_T("DATABASE"),_T("SHATE-M-8"));
	sWriteToIni(_T("DB"),_T("DATABASE"),sDatabase);

	sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
	sDatabase = sReadFromIni(_T("DB"),_T("FIRM"),sDatabase);
	CRepScanApp * App;
	App =(CRepScanApp*)AfxGetApp();
	try
	{
		if(App->dBase != NULL)
			{
				if(App->dBase->IsOpen())
					App->dBase->Close();
				delete(App->dBase);
				App->dBase = NULL;
			}
		App->dBase = new(CDatabase);
		App->dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		App->dBase->SetQueryTimeout(180);
		sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
		App->dBase->ExecuteSQL(sConnect);
	}
	catch(CDBException *exsept)
	{
		AfxMessageBox(exsept->m_strError,0,0);
		exsept->Delete();
		if(App->dBase->IsOpen())
		{
			App->dBase->Close();
		}
		delete(App->dBase);
		App->dBase = NULL;
		return TRUE;
	}

	//m_TreeAssemble.
	
	

	m_ImageList.Create(MAKEINTRESOURCE(IDB_IMAGES), 16, 1, RGB(255,255,255));
	m_TreeAssemble.SetImageList(&m_ImageList,TVSIL_NORMAL);
	m_TreeTest.SetImageList(&m_ImageList,TVSIL_NORMAL);
	LoadAssembleData();
	
	
	ShowWindow(SW_MAXIMIZE);
	return TRUE;  
}

void CRepScanDlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialog::OnSysCommand(nID, lParam);
	}
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CRepScanDlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // device context for painting

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// Center icon in client rectangle
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// Draw the icon
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialog::OnPaint();
	}
}

// The system calls this function to obtain the cursor to display while the user drags
//  the minimized window.
HCURSOR CRepScanDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

void CRepScanDlg::SetVisible(int iVisible)
{
	if(iAssemlePage == iVisible)
	{
//		m_StartDate.ShowWindow(0);
		m_bSeachInLog.ShowWindow(0);
		m_EdDate.ShowWindow(0);
		m_ListZones.ShowWindow(0);
		GridDocs.ShowWindow(0);
		DocPosGrid.ShowWindow(0);
		m_listLog.ShowWindow(0);
		BoxGrid.ShowWindow(0);
		BoxQuantGrid.ShowWindow(0);
		m_TreeTest.ShowWindow(0);
		m_BarCode.ShowWindow(0);
		m_TreeAssemble.ShowWindow(1);
		
	}

	if(iDocPage == iVisible)
	{
//		m_StartDate.ShowWindow(0);

		m_TreeTest.ShowWindow(0);
		m_TreeAssemble.ShowWindow(0);
		m_ListZones.ShowWindow(1);
		DocPosGrid.ShowWindow(1);
		m_listLog.ShowWindow(1);
		BoxGrid.ShowWindow(1);
		BoxQuantGrid.ShowWindow(1);
		m_BarCode.ShowWindow(1);
		m_bSeachInLog.ShowWindow(1);
		m_EdDate.ShowWindow(1);
		GridDocs.ShowWindow(1);
	}

	if(iTestPage == iVisible)
	{
//		m_StartDate.ShowWindow(0);
		m_bSeachInLog.ShowWindow(0);
		m_EdDate.ShowWindow(0);
		m_TreeAssemble.ShowWindow(0);
		m_ListZones.ShowWindow(0);
		DocPosGrid.ShowWindow(0);
		m_listLog.ShowWindow(0);
		BoxGrid.ShowWindow(0);
		BoxQuantGrid.ShowWindow(0);
		m_BarCode.ShowWindow(0);
		GridDocs.ShowWindow(0);
		m_TreeTest.ShowWindow(1);
	}

	if(iGoodsPage == iVisible)
	{
		m_TreeAssemble.ShowWindow(0);
		m_TreeTest.ShowWindow(0);
	

		m_ListZones.ShowWindow(1);
		DocPosGrid.ShowWindow(1);
		m_listLog.ShowWindow(1);
		BoxGrid.ShowWindow(1);
		BoxQuantGrid.ShowWindow(1);
		GridDocs.ShowWindow(1);
		m_BarCode.ShowWindow(1);
		GridDocs.SetRowCount(1);
		m_bSeachInLog.ShowWindow(0);
		m_EdDate.ShowWindow(0);
		CloseDoc();
//		m_StartDate.ShowWindow(1);
	}

	//m_StartDate
}


void CRepScanDlg::LoadAssembleData()
{
	CRepScanApp * App;
	App =(CRepScanApp*)AfxGetApp();
	if(App->dBase == NULL)
		return;
	try
	{
		m_TreeAssemble.DeleteAllItems();
		m_TreeTest.DeleteAllItems();
		m_TreeTest.hFirst = NULL;
		m_TreeAssemble.hFirst = NULL;
		HTREEITEM hItem, hItemTest;
		
		
		
		CRecordset Query(App->dBase);
		CString sSQL;
		//sSQL.Format(_T("SELECT DISTINCT Left(CONVERT ( nchar , [Entry Date], 112),4)  as DocYear  FROM [%s$Picking Operation Register] order by DocYear"),sDatabase);
		sSQL.Format(_T("SELECT DISTINCT Left(CONVERT ( nchar , [Registering Date], 112),4)  as DocYear  FROM [%s$Registered Whse_ Activity Hdr_] order by DocYear"),sDatabase);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		CDBVariant oValue;
		sSQL = _T("");
		CString sYear;
		HTREEITEM hNoData;
		while(!Query.IsEOF())
		{
			Query.GetFieldValue(_T("DocYear"),oValue);
			sYear = GetValue(&oValue);

			hItem = m_TreeAssemble.InsertItem(sYear.Left(4));
			if(m_TreeAssemble.hFirst == NULL)
				m_TreeAssemble.hFirst = hItem;
			m_TreeAssemble.SetItemData(hItem,0);
			hNoData = m_TreeAssemble.InsertItem(_T("Нет данных"),hItem);

			hItemTest = m_TreeTest.InsertItem(sYear.Left(4));
			if(m_TreeTest.hFirst == NULL)
				m_TreeTest.hFirst = hItemTest;
			m_TreeTest.SetItemData(hItemTest,0);
			hNoData = m_TreeTest.InsertItem(_T("Нет данных"),hItemTest);

			Query.MoveNext();	
		}
		Query.Close();

		/*sSQL.Format(_T("select distinct Right(name,7) as DocYear from sysobjects where Right(name,3) = '_BQ' order by DocYear DESC"));
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		CDBVariant oValue;
		sSQL = _T("");
		CString sYear;
		HTREEITEM hNoData;
		while(!Query.IsEOF())
		{
			Query.GetFieldValue(_T("DocYear"),oValue);
			sYear = GetValue(&oValue);

			hItem = m_TreeAssemble.InsertItem(sYear.Left(4));
			if(m_TreeAssemble.hFirst == NULL)
				m_TreeAssemble.hFirst = hItem;
			m_TreeAssemble.SetItemData(hItem,0);
			hNoData = m_TreeAssemble.InsertItem(_T("Нет данных"),hItem);

			hItemTest = m_TreeTest.InsertItem(sYear.Left(4));
			if(m_TreeTest.hFirst == NULL)
				m_TreeTest.hFirst = hItemTest;
			m_TreeTest.SetItemData(hItemTest,0);
			hNoData = m_TreeTest.InsertItem(_T("Нет данных"),hItemTest);

			Query.MoveNext();	
		}
		Query.Close();
		*/

	}
	catch(CDBException *exsept)
	{
		AfxMessageBox(exsept->m_strError,0,0);
		exsept->Delete();
		return;
	}
}
void CRepScanDlg::OnTvnItemexpandingTreeAssemble(NMHDR *pNMHDR, LRESULT *pResult)
{
	

	LPNMTREEVIEW pNMTreeView = reinterpret_cast<LPNMTREEVIEW>(pNMHDR);
	
	*pResult = 0;

	CRepScanApp * App;
	App =(CRepScanApp*)AfxGetApp();
	if(App->dBase == NULL)
		return;

	int iData = m_TreeAssemble.GetItemData(pNMTreeView->itemNew.hItem);

	if(pNMTreeView->action==1)
	{
		HTREEITEM hNoData;
		hNoData = m_TreeAssemble.GetChildItem(pNMTreeView->itemNew.hItem);
		while(hNoData!=NULL)
		{
			if(m_TreeAssemble.GetParentItem(hNoData)!= pNMTreeView->itemNew.hItem)
				return;
			m_TreeAssemble.DeleteItem(hNoData);
			hNoData = m_TreeAssemble.GetChildItem(pNMTreeView->itemNew.hItem);
		}
		m_TreeAssemble.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
		return;
	}

	
	HTREEITEM hNoData = m_TreeAssemble.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
    if ("Нет данных"!=m_TreeAssemble.GetItemText(hNoData))
		 return;

	if(iData == 0)
	{
		m_TreeAssemble.DeleteItem(hNoData);
		CString sYear;
		sYear = m_TreeAssemble.GetItemText(pNMTreeView->itemNew.hItem);
		
		try
		{
			CRecordset Query(App->dBase);
			CString sSQL;

			sSQL.Format(_T("SELECT DISTINCT Left(CONVERT ( nchar , [Registering Date], 112),6)  as DocYear FROM [%s$Registered Whse_ Activity Hdr_] where  Left(CONVERT ( nchar , [Registering Date], 112),4) = '%s' order by DocYear"),sDatabase,sYear);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			CDBVariant oValue;
			sSQL = _T("");
			CString sYear;
			HTREEITEM hNoData;
			HTREEITEM hItem;
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("DocYear"),oValue);
				sYear = GetValue(&oValue);
				hItem = m_TreeAssemble.InsertItem(sMounthName(sYear.Right(2)),pNMTreeView->itemNew.hItem);
				m_TreeAssemble.SetItemData(hItem,1);
				hNoData = m_TreeAssemble.InsertItem(_T("Нет данных"),hItem);
				Query.MoveNext();	
			}
			Query.Close();
				
		/*
			sSQL.Format(_T("select distinct Right(name,9) as DocYear from sysobjects where Right(name,7) = '%s_BQ' order by DocYear"),sYear);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		CDBVariant oValue;
		sSQL = _T("");
		CString sYear;
		HTREEITEM hNoData;
		HTREEITEM hItem;
		while(!Query.IsEOF())
		{
			Query.GetFieldValue(_T("DocYear"),oValue);
			sYear = GetValue(&oValue);
			hItem = m_TreeAssemble.InsertItem(sMounthName(sYear.Left(2)),pNMTreeView->itemNew.hItem);
			m_TreeAssemble.SetItemData(hItem,1);
			hNoData = m_TreeAssemble.InsertItem(_T("Нет данных"),hItem);
			Query.MoveNext();	
		}
		Query.Close();

			

			hNoData = m_TreeAssemble.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeAssemble.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}*/
		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError,0,0);
			exsept->Delete();
			return;
		}
		
	}

	if(iData == 1)
	{
		m_TreeAssemble.DeleteItem(hNoData);
		
		HTREEITEM hParentItem;

		hParentItem = m_TreeAssemble.GetParentItem(pNMTreeView->itemNew.hItem);
		CString sYear;
		sYear = m_TreeAssemble.GetItemText(hParentItem);
		
		CString sMonth;
		sMonth = m_TreeAssemble.GetItemText(pNMTreeView->itemNew.hItem);
		
		sMonth = GetMountID(sMonth);
		sMonth = sYear+sMonth;
		if(sMonth.GetLength()!= 6)
		{
			return;
		}
		try
		{
			CDBVariant oValue;
			HTREEITEM hItem;
			CRecordset Query(App->dBase);
			CString sSQL;
			/*
			sSQL.Format(_T("select  [Assigned User ID] as Employee, count(*) as ConMouth from (SELECT [Source Document No_],[Pick No_],[Assigned User ID],[Item No_],[From Bin Code] FROM [%s$Picking Operation Register] where Left(CONVERT ( nchar , [Registering Date], 112),6) = '%s'  group by [Source Document No_],[Pick No_],[Assigned User ID],[Item No_],[From Bin Code]) as TestDay group by [Assigned User ID]"),sDatabase,sMonth);
			*/

			sSQL.Format(_T("select [Assigned User ID] as Employee , count(*) as ConMouth from( select [Assigned User ID], hd.[No_],[Line No_],ln.[Zone Code] from [%s$Warehouse Zone Employee]  join [%s$Registered Whse_ Activity Hdr_] as hd on [User ID] =[Assigned User ID] join [%s$Registered Whse_ Activity Line] as ln on ln.[No_] = hd.[No_] and [Action Type] = 1 where Left(CONVERT ( nchar , [Registering Date], 112),6) = '%s' and [Type] = 2 group by [Assigned User ID],hd.[No_],[Line No_],ln.[Zone Code]) as Test group by [Assigned User ID] order by [Assigned User ID]"),sDatabase,sDatabase,sDatabase,sMonth);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("Employee"),oValue);
				sYear = GetValue(&oValue);

				Query.GetFieldValue(_T("ConMouth"),oValue);
				sYear = sYear + _T("\t") + GetValue(&oValue);

				hItem = m_TreeAssemble.InsertItem(sYear,pNMTreeView->itemNew.hItem);
				m_TreeAssemble.SetItemData(hItem,2);


				hNoData = m_TreeAssemble.InsertItem(_T("Нет данных"),hItem);
				Query.MoveNext();
			}
			Query.Close();

			hNoData = m_TreeAssemble.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeAssemble.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}
			else
			{
			
			}
			
			
			/*sSQL.Format(_T("select name from sysobjects where name like '%%%s_BQ' order by name"),sMonth);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			CDBVariant oValue;
			HTREEITEM hItem;
			sSQL = _T("");

			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("name"),oValue);
		
				if(sSQL =="")
					sSQL = _T("select Employee, count(test.con) as ConDay,'")+GetValue(&oValue)+_T("' as dat from (select Employee,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("] group by Employee,id_doc,sort,task)  as test group by Employee");
				else
					sSQL = sSQL + _T("\n union select Employee, count(test.con) as ConDay,'")+GetValue(&oValue)+_T("' as dat from (select Employee,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("] group by Employee,id_doc,sort,task)  as test group by Employee");

				Query.MoveNext();	
			}
			Query.Close();
			
			if(sSQL == "")
			{
				hNoData = m_TreeAssemble.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
				if (NULL==hNoData)
				{
					m_TreeAssemble.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
				}
				return;
			}
			sSQL = _T("select Employee, Sum(TestDay.ConDay) as ConMouth from (")+sSQL+_T(") as TestDay group by Employee order by Employee");
			
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("Employee"),oValue);
				sYear = GetValue(&oValue);

				Query.GetFieldValue(_T("ConMouth"),oValue);
				sYear = sYear + _T("\t") + GetValue(&oValue);

				hItem = m_TreeAssemble.InsertItem(sYear,pNMTreeView->itemNew.hItem);
				m_TreeAssemble.SetItemData(hItem,2);


				hNoData = m_TreeAssemble.InsertItem(_T("Нет данных"),hItem);
				Query.MoveNext();
			}
			Query.Close();

			hNoData = m_TreeAssemble.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeAssemble.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}
			else
			{
			
			}*/
		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError,0,0);
			exsept->Delete();
			return;
		}
	}

	if(iData == 2)
	{
		m_TreeAssemble.DeleteItem(hNoData);
	
		HTREEITEM hMounthItem, hYearItem;
		hMounthItem = m_TreeAssemble.GetParentItem(pNMTreeView->itemNew.hItem);
		CString sUser;

		sUser = m_TreeAssemble.GetItemText(pNMTreeView->itemNew.hItem);

		if(sUser.Find(_T("\t"))>-1)
		{
			sUser = sUser.Left(sUser.Find(_T("\t")));
		}

		CString sMonth;
		sMonth = m_TreeAssemble.GetItemText(hMounthItem);


		CString sYear;
		hYearItem = m_TreeAssemble.GetParentItem(hMounthItem);
		
		sYear = m_TreeAssemble.GetItemText(hYearItem);
		
		
		sMonth = GetMountID(sMonth);
		sMonth = sYear+sMonth;
		if(sMonth.GetLength()!= 6)
		{
			return;
		}
		try
		{
			CRecordset Query(App->dBase);
			CString sSQL;
			
			CDBVariant oValue;
			HTREEITEM hItem;
			//sSQL.Format(_T("select Left(CONVERT ( nchar , [Entry Date], 104),2) as dat,count(*) as ConDay from ( SELECT [Source Document No_],[Pick No_],[Entry Date],[Item No_],[From Bin Code]  FROM [%s$Picking Operation Register]  where 	Left(CONVERT ( nchar , [Entry Date], 112),6) = '%s'	AND [Assigned User ID] = '%s' group by [Source Document No_],[Pick No_],[Entry Date],[Item No_],[From Bin Code] ) as TestTab group by [Entry Date]"),sDatabase,sMonth,sUser);
			sSQL.Format(_T("select	[Date] as dat,count(*) as ConDay from (select [Assigned User ID], hd.[No_],[Line No_],ln.[Zone Code],Left(CONVERT ( nchar , [Registering Date], 112),8) as [Date] from [%s$Registered Whse_ Activity Hdr_] as hd join [%s$Registered Whse_ Activity Line] as ln on ln.[No_] = hd.[No_] and [Action Type] = 1 where [Assigned User ID] = '%s' AND Left(CONVERT ( nchar , [Registering Date], 112),6) = '%s' and [Type] = 2 group by [Assigned User ID],hd.[No_],[Line No_],ln.[Zone Code],[Registering Date]) as Test group by [Date] order by [Date]"),sDatabase,sDatabase,sUser,sMonth);
			
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("dat"),oValue);
				sYear = GetValue(&oValue);
				sYear = sYear.Right(2);

				Query.GetFieldValue(_T("ConDay"),oValue);
				sYear = sYear + _T("\t") + GetValue(&oValue);

				hItem = m_TreeAssemble.InsertItem(sYear,pNMTreeView->itemNew.hItem);
				m_TreeAssemble.SetItemData(hItem,3);


				hNoData = m_TreeAssemble.InsertItem(_T("Нет данных"),hItem);
				Query.MoveNext();
			}
			Query.Close();

			hNoData = m_TreeAssemble.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeAssemble.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}
			else
			{
				
			}	
				/*sSQL.Format(_T("select name from sysobjects where name like '%%%s_BQ' order by name"),sMonth);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			CDBVariant oValue;
			HTREEITEM hItem;
			sSQL = _T("");
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("name"),oValue);
				if(sSQL =="")
					sSQL = _T("select Employee, count(test.con) as ConDay, '")+GetValue(&oValue)+_T("'  as dat from (select Employee,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("]  where Employee = '")+sUser+_T("' group by Employee,id_doc,sort,task)  as test group by Employee");
				else
					sSQL = sSQL + _T("\n union select Employee, count(test.con), '")+GetValue(&oValue)+_T("' as dat from (select Employee,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("] where Employee = '")+sUser+_T("' group by Employee,id_doc,sort,task)  as test  group by Employee");

				Query.MoveNext();	
			}
			Query.Close();
			
			if(sSQL == "")
			{
				hNoData = m_TreeAssemble.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
				if (NULL==hNoData)
				{
					m_TreeAssemble.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
				}
				return;
			}
			
			sSQL= _T("select dat,ConDay from (")+sSQL+_T(") as days order by dat");
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("dat"),oValue);
				sYear = GetValue(&oValue);
				sYear = sYear.Left(2);

				Query.GetFieldValue(_T("ConDay"),oValue);
				sYear = sYear + _T("\t") + GetValue(&oValue);

				hItem = m_TreeAssemble.InsertItem(sYear,pNMTreeView->itemNew.hItem);
				m_TreeAssemble.SetItemData(hItem,3);


				hNoData = m_TreeAssemble.InsertItem(_T("Нет данных"),hItem);
				Query.MoveNext();
			}
			Query.Close();

			hNoData = m_TreeAssemble.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeAssemble.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}
			else
			{
				
			}*/
		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError,0,0);
			exsept->Delete();
			return;
		}
	}

	if(iData == 3)
	{
		m_TreeAssemble.DeleteItem(hNoData);
		CString sDay;
		HTREEITEM hUser, hMounthItem, hYearItem;
		sDay = m_TreeAssemble.GetItemText(pNMTreeView->itemNew.hItem);
		if(sDay.Find(_T("\t"))>-1)
		{
			sDay = sDay.Left(sDay.Find(_T("\t")));
		}

		hUser = m_TreeAssemble.GetParentItem(pNMTreeView->itemNew.hItem);

		hMounthItem = m_TreeAssemble.GetParentItem(hUser);
		CString sUser;
		sUser = m_TreeAssemble.GetItemText(hUser);

		if(sUser.Find(_T("\t"))>-1)
		{
			sUser = sUser.Left(sUser.Find(_T("\t")));
		}

		CString sMonth;
		sMonth = m_TreeAssemble.GetItemText(hMounthItem);


		CString sYear;
		hYearItem = m_TreeAssemble.GetParentItem(hMounthItem);
		
		sYear = m_TreeAssemble.GetItemText(hYearItem);
		sMonth = GetMountID(sMonth);
		sMonth = sMonth;
		sDay = sYear+sMonth+sDay;
		if(sDay.GetLength()!= 8)
		{
			return;
		}
		try
		{
			CRecordset Query(App->dBase);
			
			CString sSQL;
			CDBVariant oValue;
			HTREEITEM hItem;

			sSQL.Format(_T("select [No_] as DocVis,count(*) as ConDay,0 as doc from (select [Assigned User ID], hd.[No_],[Line No_],ln.[Zone Code] from [%s$Registered Whse_ Activity Hdr_] as hd join [%s$Registered Whse_ Activity Line] as ln on ln.[No_] = hd.[No_] and [Action Type] = 1 where [Assigned User ID] = '%s' AND Left(CONVERT ( nchar , [Registering Date], 112),8) = '%s' and [Type] = 2 group by [Assigned User ID],hd.[No_],[Line No_],ln.[Zone Code],[Registering Date]) as Test group by [No_] order by [No_]"),sDatabase,sDatabase,sUser,sDay);
			
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("DocVis"),oValue);
				sYear = GetValue(&oValue);

				Query.GetFieldValue(_T("ConDay"),oValue);
				sYear = sYear + _T("\t") + GetValue(&oValue);

				Query.GetFieldValue(_T("doc"),oValue);
				sYear = sYear + _T("\n") + GetValue(&oValue);

				hItem = m_TreeAssemble.InsertItem(sYear,pNMTreeView->itemNew.hItem);
				m_TreeAssemble.SetItemData(hItem,4);

				Query.MoveNext();
			}
			Query.Close();

			hNoData = m_TreeAssemble.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeAssemble.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}
			else
			{
				
			}
			
			
			/*sSQL = _T("select (select DocNumberVis from [")+sDay;
			sSQL = sSQL + _T("_Docs] where id = doc ) as DocVis ,count(test.con) as ConDay,doc from (select Employee,id_doc as doc, sort,task, count(*) as con from [");
			sSQL = sSQL + sDay + _T("_BQ] where Employee = '");
			sSQL = sSQL + sUser + _T("' group by Employee,id_doc,sort,task) as test group by doc");
			if(sSQL == "")
			{
				hNoData = m_TreeAssemble.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
				if (NULL==hNoData)
				{
					m_TreeAssemble.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
				}
				return;
			}
			
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("DocVis"),oValue);
				sYear = GetValue(&oValue);

				Query.GetFieldValue(_T("ConDay"),oValue);
				sYear = sYear + _T("\t") + GetValue(&oValue);

				Query.GetFieldValue(_T("doc"),oValue);
				sYear = sYear + _T("\n") + GetValue(&oValue);

				hItem = m_TreeAssemble.InsertItem(sYear,pNMTreeView->itemNew.hItem);
				m_TreeAssemble.SetItemData(hItem,4);

				Query.MoveNext();
			}
			Query.Close();

			hNoData = m_TreeAssemble.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeAssemble.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}
			else
			{
				
			}*/
		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError,0,0);
			exsept->Delete();
			return;
		}
	}
}

void CRepScanDlg::OnNMDblclkTreeAssemble(NMHDR *pNMHDR, LRESULT *pResult)
{
	return;
	CloseDoc();
	*pResult = 1;
	CPoint pos;
	GetCursorPos(&pos);

	CRect rec;
	m_TreeAssemble.GetWindowRect(rec);

	pos.x = pos.x - rec.left;
	pos.y = pos.y - rec.top;

	HTREEITEM hItem;
	hItem = m_TreeAssemble.GetFirstVisibleItem();


	CString sName;

	while(hItem != NULL)
	{
		m_TreeAssemble.GetItemRect(hItem,rec,FALSE);
		if((rec.left <= pos.x)
			&&(rec.right >= pos.x)
			&&(rec.bottom >= pos.y)
			&&(rec.top <= pos.y)
			)
		{
			if(m_TreeAssemble.GetItemData(hItem)!=4)
				return;

			CString sDay;
			CString sDocNumber;
			HTREEITEM hUser, hMounthItem, hYearItem, hDay;

			sDocNumber = m_TreeAssemble.GetItemText(hItem);
			if(sDocNumber.Find(_T("\n"))>-1)
			{
				sDocNumber = sDocNumber.Right(sDocNumber.GetLength() - 1 - sDocNumber.Find(_T("\n")));
			}

			hDay = m_TreeAssemble.GetParentItem(hItem);

			sDay = m_TreeAssemble.GetItemText(hDay);
			if(sDay.Find(_T("\t"))>-1)
			{
				sDay = sDay.Left(sDay.Find(_T("\t")));
			}

			hUser = m_TreeAssemble.GetParentItem(hDay);
			hMounthItem = m_TreeAssemble.GetParentItem(hUser);
	
			CString sMonth;
			sMonth = m_TreeAssemble.GetItemText(hMounthItem);

			CString sYear;
			hYearItem = m_TreeAssemble.GetParentItem(hMounthItem);
		
			sYear = m_TreeAssemble.GetItemText(hYearItem);
			sMonth = GetMountID(sMonth);
			sMonth = sMonth;
			sDay = sDay+sMonth+sYear;

			if(sDay.GetLength()!= 8)
			{
				return;
			}
			if(bOpenDoc(sDay,_wtoi(sDocNumber)))
			{
				m_Tab.SetCurSel(iDocPage);
				SetVisible(iDocPage);
			}
			break;
		}
		hItem = m_TreeAssemble.GetNextVisibleItem(hItem);
	}
}

bool CRepScanDlg::bOpenDoc(CString sTableName, int iDocID)
{
	CloseDoc();
	CRepScanApp *pApp;
	pApp = (CRepScanApp*)AfxGetApp();
	if(pApp->dBase == NULL)
		return FALSE;
	try
	{
		CString sSQL;
		CRecordset Query(pApp->dBase);
		CString docRoute;
		CDBVariant cdVar;
		stDoc* NewPos; 
		NewPos = new(stDoc);
		NewPos->lID = iDocID;
		NewPos->sData = sTableName;
		GridDocs.SetRowCount(1);

		
		int lRow;
		long lID;
		lRow = 1;
		if(NewPos->sData.GetLength()<1)
			{
				sSQL.Format(_T("select ID,	DocNumberVis,docSendTime,docMode,DocPalete,	docDivision,docOperator,docItemsCount,DocLine,docRoute,(select NAME from dbo.USERS where TUser = dbo.USERS.ID) as UserName, iDocAssembleLine from NotCollectedDocs where id = %d"),NewPos->lID);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				
				if(!Query.IsEOF())
				{
					lRow++;
				GridDocs.SetRowCount(lRow);
					Query.GetFieldValue(_T("ID"), cdVar);
					lID = GetValueID(&cdVar);

					GridDocs.SetItemData(lRow,0,lID);
					for(short j = 1;j<12;j++)
					{
						Query.GetFieldValue(j, cdVar);
						GridDocs.SetItemText(lRow-1,j,GetValue(&cdVar));
					}
				}
				Query.Close();
			}
			else
			{
				sSQL.Format(_T("select ID,	DocNumberVis,docSendTime,docMode,DocPalete,	docDivision,docOperator,docItemsCount,DocLine,docRoute,(select NAME from dbo.USERS where TUser = dbo.USERS.ID) as UserName, iDocAssembleLine from [%s_Docs] where id = %d"),NewPos->sData,NewPos->lID);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				
				if(!Query.IsEOF())
				{
					lRow++;
					GridDocs.SetRowCount(lRow);
					Query.GetFieldValue(_T("ID"), cdVar);
					lID = GetValueID(&cdVar);
					GridDocs.SetItemData(lRow-1,0,lID);
					GridDocs.SetItemData(lRow-1,1,_wtoi(NewPos->sData));
					for(short j = 1;j<12;j++)
					{
					
						Query.GetFieldValue(j, cdVar);
						
						
						
						GridDocs.SetItemText(lRow-1,j,GetValue(&cdVar));
					}
				}
				Query.Close();
			}
		
	}
	catch(CDBException *exsept)
	{
		AfxMessageBox(exsept->m_strError);
		exsept->Delete();
		return FALSE;
	}

	if(GridDocs.GetRowCount()<2)
	{
		return FALSE;
	}
	GridDocs.SelectItem(1);
	return TRUE;
}
bool CRepScanDlg::bSelectDoc(CString sTableName, int iDocID)
{
	CloseDoc();
	m_ListZones.DeleteAllItems();

	if(iDocID<1)
		return FALSE;

	CRepScanApp * pApp;
	pApp =(CRepScanApp*)AfxGetApp();
	if(pApp->dBase == NULL)
	{
		DocPosGrid.SetCanreDraw(FALSE);
		DocPosGrid.SetRowCount(1);
		
		return FALSE;
	}
	
	try
	{
		CString sSQL;
		CRecordset Query(pApp->dBase);

		CDBVariant cdVar;
		if(sTableName.GetLength()>0)
			sSQL.Format(_T("select  [NAME],ID_ZONE,TASK, READY, Employee  from [%s_DFA] left join ZONES on ID_ZONE = ID where ID_DOC = %d ORDER BY ID_ZONE,TASK"),sTableName,iDocID);
		else
			sSQL.Format(_T("select  [NAME],ID_ZONE,TASK, READY, Employee  from DemandsForAssemblage left join ZONES on ID_ZONE = ID where ID_DOC = %d ORDER BY ID_ZONE,TASK"),iDocID);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);		

		long iPos;
		CString sValue;
		sValue = "";
		iPos = 0;
		m_ListZones.iDoc = iDocID;
		m_ListZones.sDate = sTableName;
		m_ListZones.InsertItem(iPos,_T("Весь документ"));
		m_ListZones.SetItemData(iPos,0);
		iPos++;
		int i;
		int iData;
		while(!Query.IsEOF())
		{
			i=0;
			Query.GetFieldValue(i, cdVar);
			sValue = GetValue(&cdVar);
			m_ListZones.InsertItem(iPos,sValue);
			
			i++;
			Query.GetFieldValue(i, cdVar);
			iData = GetValueID(&cdVar)*10000;
			
			i++;
			Query.GetFieldValue(i, cdVar);
			iData = iData + GetValueID(&cdVar);
			m_ListZones.SetItemData(iPos,iData);
			i++;
			Query.GetFieldValue(i, cdVar);
			sValue = GetValue(&cdVar);
			if(sValue == _T("101"))
			{
				m_ListZones.SetItemText(iPos,1,_T("Собран"));
			}
			else
			if(sValue == _T("102"))
			{
				m_ListZones.SetItemText(iPos,1,_T("Проверен"));
			}
			else
				if(sValue == _T("-1"))
				{
					m_ListZones.SetItemText(iPos,1,_T(""));
				}
				else
				{
					sValue = sValue + _T("%");
					m_ListZones.SetItemText(iPos,1,sValue);
				}
			
			i++;
			Query.GetFieldValue(i, cdVar);
			sValue = GetValue(&cdVar);
			m_ListZones.SetItemText(iPos,2,sValue);
				
			iPos++;
			Query.MoveNext();
			}
		Query.Close();

		CRect rec;
		m_ListZones.GetClientRect(rec);
		int iWidth;	
		iWidth = (rec.right - rec.left)/3;
		m_ListZones.SetColumnWidth(0,iWidth);	
		m_ListZones.SetColumnWidth(1,iWidth);
		m_ListZones.SetColumnWidth(2,(rec.right - rec.left) - 2*iWidth);

		DocPosGrid.GetClientRect(rec);
		if(DocPosGrid.GetColumnCount()>1)
		{
			DocPosGrid.SetColumnWidth(0,20);
			int iWidth = (rec.right - rec.left-20)/(DocPosGrid.GetColumnCount()-2);
			if(iWidth>0)
			{
				DocPosGrid.SetColumnWidth(1,iWidth);
				DocPosGrid.SetColumnWidth(2,iWidth/3);
				DocPosGrid.SetColumnWidth(3,iWidth/3);
				DocPosGrid.SetColumnWidth(4,iWidth - 2*iWidth/3);
				if((rec.right - rec.left-20)-2*iWidth>0)
					DocPosGrid.SetColumnWidth(5,(rec.right - rec.left-20)-2*iWidth);
				else
					DocPosGrid.SetColumnWidth(5,iWidth);
			}
		}
		DocPosGrid.SetCanreDraw(TRUE);
		BoxQuantGrid.GetClientRect(rec);
		if(BoxQuantGrid.GetColumnCount()>1)
			{
				BoxQuantGrid.SetColumnWidth(0,20);
				if(rec.right - rec.left-20>0)
				{
					BoxQuantGrid.SetColumnWidth(1,(rec.right - rec.left-20)/3);
					BoxQuantGrid.SetColumnWidth(2,(rec.right - rec.left-20)/3);
					BoxQuantGrid.SetColumnWidth(3,(rec.right - rec.left-20)/3);
				}
			}

		

		BoxGrid.GetClientRect(rec);
		if(BoxGrid.GetColumnCount()>1)
			{
				BoxGrid.SetColumnWidth(0,20);
				if(rec.right - rec.left-20>0)
				{
					BoxGrid.SetColumnWidth(1,(rec.right - rec.left-20)/3);
					BoxGrid.SetColumnWidth(2,(rec.right - rec.left-20)/3);
					BoxGrid.SetColumnWidth(3,(rec.right - rec.left-20)/3);
				}
			}

		if(m_ListZones.GetItemCount()>0)
		{
			m_ListZones.SelectItem(0);
		}
	}
	catch(CDBException *exsept)
	{
		AfxMessageBox(exsept->m_strError,0,0);
		exsept->Delete();
		DocPosGrid.SetCanreDraw(TRUE);
		return FALSE;
	}
	
	return TRUE;
}
void CRepScanDlg::OnTcnSelchangeTab(NMHDR *pNMHDR, LRESULT *pResult)
{
	*pResult = 0;

	int i = m_Tab.GetCurSel();
	SetVisible(i);
}

void CRepScanDlg::OnSize(UINT nType, int cx, int cy)
{
	int iTopLen;

	iTopLen = 160;

	CDialog::OnSize(nType, cx, cy);

	CWnd *pWnd;
	if (NULL==(pWnd=GetDlgItem(IDC_TAB)))
	{
		return;
	}
	else
	{
		CRect rec;
		GetClientRect(rec);
		rec.left = rec.left+3;
		rec.right = rec.right-6;
		rec.top = rec.top +3;
		rec.bottom = rec.bottom-3;
		m_Tab.MoveWindow(rec);
	}

	
	if (NULL!=(pWnd=m_Tab.GetDlgItem(IDC_LIST_ZONES)))
    {
		CRect rec;
		m_Tab.GetClientRect(rec);
		rec.top = iTopLen;
		rec.right = rec.right/4-5;
		rec.bottom = (rec.bottom -5+iTopLen)/2-2;
		//rec.bottom = rec.bottom -2;
		rec.left = rec.left +5;
		m_ListZones.MoveWindow(rec);

		int iWidth;
		m_ListZones.GetClientRect(rec);

		iWidth = (rec.right - rec.left)/3;
		if(iWidth < 5)
			iWidth = 10;
		
		m_ListZones.SetColumnWidth(0,iWidth);
		m_ListZones.SetColumnWidth(1,iWidth);
		m_ListZones.SetColumnWidth(2,(rec.right - rec.left) - 2*iWidth);
	}

	if (NULL!=(pWnd=m_Tab.GetDlgItem(IDC_TREE_ASSEMBLE)))
    {
		CRect rec;
		m_Tab.GetClientRect(rec);
		rec.top = rec.top + 22;
		rec.right = rec.right - 4;
		rec.left = rec.left + 2;
		rec.bottom = rec.bottom -2;
		m_TreeAssemble.MoveWindow(rec);
		if (NULL!=(pWnd=m_Tab.GetDlgItem(IDC_TREE_TEST)))
			m_TreeTest.MoveWindow(rec);
	}

	if (NULL!=(pWnd=m_Tab.GetDlgItem(IDC_LIST_LOG)))
    {
		CRect rec;
		m_Tab.GetClientRect(rec);
		rec.top = iTopLen;
		rec.left = rec.right/4;
		rec.bottom = rec.bottom -5;
		rec.left = rec.left + (rec.right-rec.left)/2;
		rec.right = rec.right -5;
		m_listLog.MoveWindow(rec);
	}
	//m_BarCode

	if (NULL!=(pWnd=m_Tab.GetDlgItem(IDG_DOCS)))
    {
		CRect rec;
		m_Tab.GetClientRect(rec);
		rec.top = 60;
		rec.bottom =  150;
		rec.left = rec.left + 5;
		rec.right = rec.right - 10;
		GridDocs.MoveWindow(rec);
		
		
		if(GridDocs.GetColumnCount()>0)
		{
			GridDocs.GetClientRect(rec);
			int iColWidthClient;
			GridDocs.SetColumnWidth(0,10);
			iColWidthClient = (rec.right -rec.left-10)/(GridDocs.GetColumnCount()-1);
			if(iColWidthClient>0)
			{
				for(int i=1;i<GridDocs.GetColumnCount();i++)
					{
						GridDocs.SetColumnWidth(i,iColWidthClient);
					}
			}
			else
			{
				for(int i=1;i<GridDocs.GetColumnCount();i++)
					{
						GridDocs.SetColumnWidth(i,20);
					}
			}
			iColWidthClient = (rec.right-rec.left-10) -((GridDocs.GetColumnCount()-2)*(iColWidthClient));
			if(iColWidthClient>0)
				GridDocs.SetColumnWidth(GridDocs.GetColumnCount()-1,iColWidthClient);
			else
				GridDocs.SetColumnWidth(GridDocs.GetColumnCount()-1,20);
		}
	}

	if (NULL!=(pWnd=m_Tab.GetDlgItem(IDC_EDIT_DOCNUMBER)))
    {
		CRect rec;
		m_Tab.GetClientRect(rec);
		rec.left = 5;
		rec.right = rec.right/4-5;
		rec.top = 27;
		rec.bottom = 47;
		m_BarCode.MoveWindow(rec);

		rec.left = rec.right + 10;
		rec.right = rec.left + 100;
		if(NULL!=(pWnd=m_Tab.GetDlgItem(IDC_CHECK_SEACH_LOG)))
		{//IDC_CHECK_SEACH_LOG
			//m_bSeachInLog
			m_bSeachInLog.MoveWindow(rec);
			
		}

		if(NULL!=(pWnd=m_Tab.GetDlgItem(IDC_EDIT_DATE)))
		{
			rec.left = rec.right + 10;
			rec.right = rec.left + 70;
			m_EdDate.MoveWindow(rec);
		}
	}

	if (NULL!=(pWnd=m_Tab.GetDlgItem(IDG_POD)))
    {
		CRect rec;
		m_Tab.GetClientRect(rec);
		rec.top = iTopLen;
		rec.bottom = (rec.bottom -5+iTopLen)/2-2;

		rec.left = rec.right/4;
		rec.right = rec.left + (rec.right-rec.left)/2-5;
		DocPosGrid.MoveWindow(rec);

		DocPosGrid.GetClientRect(rec);
		if(DocPosGrid.GetColumnCount()>1)
		{
			DocPosGrid.SetColumnWidth(0,20);
			int iWidth = (rec.right - rec.left-20)/(DocPosGrid.GetColumnCount()-2);
			if(iWidth<10)
				iWidth = 10;
			
			DocPosGrid.SetColumnWidth(1,iWidth);
			DocPosGrid.SetColumnWidth(2,iWidth/3);
			DocPosGrid.SetColumnWidth(3,iWidth/3);
			DocPosGrid.SetColumnWidth(4,iWidth - 2*iWidth/3);
			if((rec.right - rec.left-20)-2*iWidth>0)
				DocPosGrid.SetColumnWidth(5,(rec.right - rec.left-20)-2*iWidth);
			else
				DocPosGrid.SetColumnWidth(5,iWidth);
		}
	}

	if (NULL!=(pWnd=m_Tab.GetDlgItem(IDG_BOX)))
    {
		CRect rec;
		m_Tab.GetClientRect(rec);
		rec.top = (rec.bottom -5+iTopLen)/2;
		rec.left = rec.left +5;
		rec.bottom = rec.bottom -5;
		rec.right = rec.right/4-5;
		BoxGrid.MoveWindow(rec);
		BoxGrid.GetClientRect(rec);
		if(BoxGrid.GetColumnCount()>1)
		{
			if((rec.right - rec.left-20)/2>0)
			{
				BoxGrid.SetColumnWidth(0,20);
				BoxGrid.SetColumnWidth(1,(rec.right - rec.left-20)/3);
				BoxGrid.SetColumnWidth(2,(rec.right - rec.left-20)/3);
				BoxGrid.SetColumnWidth(3,(rec.right - rec.left-20)/3);
			}
		}
	}

	if (NULL!=(pWnd=m_Tab.GetDlgItem(IDG_BOX_QUANT)))
    {
		CRect rec;
		m_Tab.GetClientRect(rec);
		rec.top = (rec.bottom -5+iTopLen)/2;
		rec.bottom = rec.bottom -5;
		rec.left = rec.right/4;
		rec.right = rec.left + (rec.right-rec.left)/2-5;
		BoxQuantGrid.MoveWindow(rec);
		BoxQuantGrid.GetClientRect(rec);
		if(BoxQuantGrid.GetColumnCount()>1)
		{
			if((rec.right - rec.left-20)/2>0)
			{
				BoxQuantGrid.SetColumnWidth(0,20);
				BoxQuantGrid.SetColumnWidth(1,(rec.right - rec.left-20)/3);
				BoxQuantGrid.SetColumnWidth(2,(rec.right - rec.left-20)/3);
				BoxQuantGrid.SetColumnWidth(3,(rec.right - rec.left-20)/3);
			}
		}
	}
}

void CRepScanDlg::OnSelectedListZone(NMHDR* pNMHDR, LRESULT* pResult)
{
	//m_listLog.ShowWindow(0);
	BoxQuantGrid.SetRowCount(1);
	BoxGrid.SetRowCount(1);
	while(m_listLog.GetCount()>0)
		m_listLog.DeleteString(0);
	
	if(m_ListZones.lSelRow<0)
		return;
	DocPosGrid.SetCanreDraw(FALSE);
	DocPosGrid.SetRowCount(1);
	CRepScanApp * App;
	App =(CRepScanApp*)AfxGetApp();
	if(App->dBase==NULL)
	{
		DocPosGrid.SetCanreDraw(TRUE);
		return;
	}

	int lDoc = m_ListZones.iDoc;
	if(lDoc<1)
	{
		DocPosGrid.SetCanreDraw(TRUE);
		return;
	}
	
	long lData, lTask;
	lData = -1;
	lData = m_ListZones.GetItemData(m_ListZones.lSelRow);
	lTask = lData % 10000;
	lData = (lData-lTask)/10000;

	CString sSQL;
	if(m_ListZones.sDate.GetLength()>0)
	{
		if(lData < 1)
			sSQL.Format(_T("select LogData FROM [%s_Docs] WHERE ID = %d"),m_ListZones.sDate,lDoc);
		else
			sSQL.Format(_T("select LogData FROM [%s_DFA] WHERE ID_ZONE = %d AND ID_DOC = %d and TASK = %d"),m_ListZones.sDate,lData,lDoc,lTask);
	}
	else
	{
		if(lData < 1)
			sSQL.Format(_T("select LogData FROM NotCollectedDocs WHERE ID = %d"),lDoc);
		else
			sSQL.Format(_T("select LogData FROM DemandsForAssemblage WHERE ID_ZONE = %d AND ID_DOC = %d and TASK = %d"),lData,lDoc,lTask);
	}
	
	try
	{
		CRecordset Query(App->dBase);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		CDBVariant oValue;
		CString sValue;
		short i;
		i=0;
		sValue = "";
		if(!Query.IsEOF())
			{
				Query.GetFieldValue(i, oValue);
				sValue = GetValue(&oValue);
			}
		Query.Close();

		i=0;
		int iPos;
		while(sValue.GetLength()>0)
			{
				iPos = sValue.Find(_T("\n"));
					if(iPos>0)	
					{
						m_listLog.InsertString(i,sValue.Left(iPos));
						sValue = sValue.Right(sValue.GetLength()-iPos-1);
					}
					else
					{
						m_listLog.InsertString(i,sValue);
						sValue = "";
					}
				i++;
			}

		if(lData == 0)
		{
			if(m_ListZones.sDate.GetLength()>0)
				sSQL.Format(_T("select COUNT(Sort) as Con from [%s_DocsDet] where id_doc = %d"),m_ListZones.sDate,lDoc);
			else
				sSQL.Format(_T("select COUNT(Sort) as Con from NotCollectedDocsDet where id_doc = %d"),lDoc);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			if(Query.IsEOF())
			{
				DocPosGrid.SetRowCount(1);
			}
			else
			{
				Query.GetFieldValue(_T("Con"), oValue);
				DocPosGrid.SetRowCount(GetValueID(&oValue)+1);
			}
			Query.Close();

			if(m_ListZones.sDate.GetLength()>0)
				sSQL.Format(_T("select CatalogNumber,ItemQnty,docQntyTest,Measure,Name, ID_LEVEL,Measure from [%s_DocsDet] where id_doc = %d order by ID_LEVEL DESC "),m_ListZones.sDate,lDoc);
			else
				sSQL.Format(_T("select CatalogNumber,ItemQnty,docQntyTest,Measure,Name, ID_LEVEL,Measure from NotCollectedDocsDet where id_doc = %d order by ID_LEVEL DESC "),lDoc);

		}
		else
		{
			if(m_ListZones.sDate.GetLength()>0)
			{
				sSQL.Format(_T("select COUNT(Sort) as Con  from [%s_DocsDet] WHERE ID_ZONE = %d AND ID_DOC = %d and TASK = %d"),m_ListZones.sDate,lData,lDoc, lTask);
			}
			else
			{			
				sSQL.Format(_T("select COUNT(Sort) as Con  from NotCollectedDocsDet WHERE ID_ZONE = %d AND ID_DOC = %d and TASK = %d"),lData,lDoc, lTask);
			}
			
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			if(Query.IsEOF())
			{
				DocPosGrid.SetRowCount(1);
			}
			else
			{
				Query.GetFieldValue(_T("Con"), oValue);
				DocPosGrid.SetRowCount(GetValueID(&oValue)+1);
			}
			Query.Close();
			if(m_ListZones.sDate.GetLength()>0)
			{
				sSQL.Format(_T("select CatalogNumber,ItemQnty,docQntyTest,Measure,Name, ID_LEVEL from [%s_DocsDet] WHERE ID_ZONE = %d AND ID_DOC = %d and TASK = %d"),m_ListZones.sDate,lData,lDoc, lTask);
			}
			else
			{	
				sSQL.Format(_T("select CatalogNumber,ItemQnty,docQntyTest,Measure,Name, ID_LEVEL from NotCollectedDocsDet WHERE ID_ZONE = %d AND ID_DOC = %d and TASK = %d"),lData,lDoc, lTask);
			}
		}

		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		i=0;
		sValue = "";
		int lRow = 1;
		while(!Query.IsEOF())
			{
				for(i = 0;i<5;i++)
				{
					Query.GetFieldValue(i, oValue);
					sValue = GetValue(&oValue);
					DocPosGrid.SetItemText(lRow,i+1,sValue);
				}
				if(DocPosGrid.GetItemText(lRow,3)==_T(""))
					DocPosGrid.SetItemText(lRow,3,_T("0"));
				if(_wtoi(DocPosGrid.GetItemText(lRow,3))>_wtoi(DocPosGrid.GetItemText(lRow,2)))
					{
						DocPosGrid.SetRowColor(lRow,RGB(255,100,100));
					}
				if(_wtoi(DocPosGrid.GetItemText(lRow,3))==_wtoi(DocPosGrid.GetItemText(lRow,2)))
					{
						DocPosGrid.SetRowColor(lRow,RGB(100,255,100));
					}
				
				i = 5;
				Query.GetFieldValue(i, oValue);
				
			
				if(_wtoi(DocPosGrid.GetItemText(lRow,2))==0)
				{
					DocPosGrid.SetRowColor(lRow,RGB(220,220,100));
				}

				

				lRow++;
				Query.MoveNext();
			}
		Query.Close();

		

		if(lData == 0)
		{
			if(m_ListZones.sDate.GetLength()>0)
			{
				sSQL.Format(_T("select distinct BOX, Employee,(select name from users where id = test) as sUser, ID_ZONE,Task  from [%s_BQ] where ID_DOC = %d ORDER BY ID_ZONE,Task"),m_ListZones.sDate,lDoc);
			}
			else
			{
				sSQL.Format(_T("select distinct BOX, Employee,(select name from users where id = test) as sUser, ID_ZONE,Task  from BOX_QUANT where ID_DOC = %d ORDER BY ID_ZONE,Task"),lDoc);
			}
		}
		else
		{
			if(m_ListZones.sDate.GetLength()>0)
			{
				sSQL.Format(_T("select distinct BOX, Employee,(select name from users where id = test) as sUser, ID_ZONE,Task from [%s_BQ] where ID_ZONE = %d AND ID_DOC = %d and TASK = %d ORDER BY ID_ZONE,Task"),m_ListZones.sDate,lData,lDoc, lTask);
			}
			else
			{
				sSQL.Format(_T("select distinct BOX, Employee,(select name from users where id = test) as sUser, ID_ZONE,Task from BOX_QUANT where ID_ZONE = %d AND ID_DOC = %d and TASK = %d ORDER BY ID_ZONE,Task"),lData,lDoc, lTask);
			}
		}
		
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		i=0;
		sValue = "";
		lRow = 1;
		while(!Query.IsEOF())
			{
				BoxGrid.SetRowCount(lRow+1);
				short i = 0;	
				Query.GetFieldValue(i, oValue);
				sValue = GetValue(&oValue);
				BoxGrid.SetItemText(lRow,1,sValue);
				i++;
				Query.GetFieldValue(i, oValue);
				sValue = GetValue(&oValue);
				BoxGrid.SetItemText(lRow,2,sValue);

				i++;
				Query.GetFieldValue(i, oValue);
				sValue = GetValue(&oValue);
				BoxGrid.SetItemText(lRow,3,sValue);
				if(sValue.GetLength()>0)
				{
					BoxGrid.SetRowColor(lRow,RGB(100,255,100));
				}

				
				i++;
				Query.GetFieldValue(i, oValue);
				BoxGrid.SetItemData(lRow,0,GetValueID(&oValue));

				i++;
				Query.GetFieldValue(i, oValue);
				BoxGrid.SetItemData(lRow,1,GetValueID(&oValue));
				

				lRow++;
				Query.MoveNext();
			}
		Query.Close();

		if(BoxGrid.GetRowCount()>1)
		{
			BoxGrid.SelectItem(1,1);
		}
	}
	catch(CDBException *exsept)
		{
			DocPosGrid.SetCanreDraw(TRUE);
			AfxMessageBox(exsept->m_strError,0,0);
			exsept->Delete();
			return;
		}
	DocPosGrid.SetCanreDraw(TRUE);
}
void CRepScanDlg::OnNMClickListZones(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMITEMACTIVATE pNMLV = reinterpret_cast<LPNMITEMACTIVATE>(pNMHDR);

	*pResult = 0;
	if(pNMLV==NULL)
		{
			return;
		}
	if(pNMLV->iItem<0)
		return;
	m_ListZones.SelectItem(pNMLV->iItem);
}

void CRepScanDlg::OnOpenBox(NMHDR* pNMHDR, LRESULT* pResult)
{
	BoxQuantGrid.SetRowCount(1);
	if(BoxGrid.iSelRow<1)
	{
		return;
	}

	if(m_ListZones.lSelRow<0)
		return;
	
	CRepScanApp * App;
	App =(CRepScanApp*)AfxGetApp();
	if(App->dBase==NULL)
	{
		return;
	}

	int lDoc = m_ListZones.iDoc;
	if(lDoc<1)
	{
		return;
	}
	
	long lZone, lTask;
	lZone = -1;
	lZone =  BoxGrid.GetItemData(BoxGrid.iSelRow,0);
	lTask =  BoxGrid.GetItemData(BoxGrid.iSelRow,1);	

	CString sSQL;
	if(m_ListZones.sDate.GetLength()>0)
	{
		//select CatalogNumber,QUANT,hand from [25062011_BQ] as tbox ,[25062011_DocsDet] as tDoc where   tbox.ID_doc = 3289
		sSQL.Format(_T("select CatalogNumber,QUANT,hand from [%s_BQ] as tbox ,[%s_DocsDet] as tDoc WHERE tbox.ID_doc = tDoc.id_doc and tbox.sort = tDoc.sort and tbox.ID_DOC = %d AND tbox.ID_ZONE = %d AND tbox.Task = %d and tbox.BOX = '%s'"),m_ListZones.sDate,m_ListZones.sDate,lDoc, lZone, lTask,BoxGrid.GetItemText(BoxGrid.iSelRow,1));
	}
	else
	{
		sSQL.Format(_T("select CatalogNumber,QUANT,hand from BOX_QUANT as tbox ,NotCollectedDocsDet as tDoc WHERE tbox.ID_doc = tDoc.id_doc and tbox.sort = tDoc.sort and tbox.ID_DOC = %d AND tbox.ID_ZONE = %d AND tbox.Task = %d and tbox.BOX = '%s'"),lDoc, lZone, lTask,BoxGrid.GetItemText(BoxGrid.iSelRow,1));
	}
	
	try
	{
		BoxQuantGrid.SetRowCount(1);
		CRecordset Query(App->dBase);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		CDBVariant oValue;
		CString sValue;
		short i;
		i=0;
		sValue = "";
		long lRow = 1;
		while(!Query.IsEOF())
			{
				BoxQuantGrid.SetRowCount(lRow+1);
				short i = 0;	
				Query.GetFieldValue(i, oValue);
				sValue = GetValue(&oValue);
				BoxQuantGrid.SetItemText(lRow,1,sValue);
				i++;

				Query.GetFieldValue(i, oValue);
				sValue = GetValue(&oValue);
				BoxQuantGrid.SetItemText(lRow,2,sValue);
				i++;

				Query.GetFieldValue(i, oValue);
				
				if(GetValueID(&oValue) == 1)
				{
					BoxQuantGrid.SetItemText(lRow,3,_T("сканированно"));
					BoxQuantGrid.SetRowColor(lRow,RGB(100,250,100));
				}
				else
				{
					BoxQuantGrid.SetItemText(lRow,3,_T("вручную"));
				}
				i++;
				lRow++;
				Query.MoveNext();
			}	
		Query.Close();

	}
	catch(CDBException *exsept)
		{
			DocPosGrid.SetCanreDraw(TRUE);
			AfxMessageBox(exsept->m_strError,0,0);
			exsept->Delete();
			return;
		}
}
void CRepScanDlg::OnTvnItemexpandedTreeTest(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMTREEVIEW pNMTreeView = reinterpret_cast<LPNMTREEVIEW>(pNMHDR);
	*pResult = 0;

	CRepScanApp * App;
	App =(CRepScanApp*)AfxGetApp();
	if(App->dBase == NULL)
		return;

	int iData = m_TreeTest.GetItemData(pNMTreeView->itemNew.hItem);

	if(pNMTreeView->action==1)
	{
		HTREEITEM hNoData;
		hNoData = m_TreeTest.GetChildItem(pNMTreeView->itemNew.hItem);
		while(hNoData!=NULL)
		{
			if(m_TreeTest.GetParentItem(hNoData)!= pNMTreeView->itemNew.hItem)
				return;
			m_TreeTest.DeleteItem(hNoData);
			hNoData = m_TreeTest.GetChildItem(pNMTreeView->itemNew.hItem);
		}
		m_TreeTest.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
		return;
	}

	
	HTREEITEM hNoData = m_TreeTest.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
    if ("Нет данных"!=m_TreeTest.GetItemText(hNoData))
		 return;

	if(iData == 0)
	{
		m_TreeTest.DeleteItem(hNoData);
		CString sYear;
		sYear = m_TreeTest.GetItemText(pNMTreeView->itemNew.hItem);
		
		try
		{
			CRecordset Query(App->dBase);
			CString sSQL;
			CDBVariant oValue;
			

			sSQL = _T("");
			sSQL.Format(_T("select distinct Left(CONVERT ( nchar , [Checked Date], 112),6)  as DocYear from [%s$Shipment Check Register] where  Left(CONVERT ( nchar , [Checked Date], 112),4) = '%s' order by DocYear"),sDatabase,sYear);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			
			
			
			
			HTREEITEM hNoData;
			HTREEITEM hItem;
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("DocYear"),oValue);
				sYear = GetValue(&oValue);
				hItem = m_TreeTest.InsertItem(sMounthName(sYear.Right(2)),pNMTreeView->itemNew.hItem);
				m_TreeTest.SetItemData(hItem,1);
				hNoData = m_TreeTest.InsertItem(_T("Нет данных"),hItem);
				Query.MoveNext();	
			}
			Query.Close();

			hNoData = m_TreeTest.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeTest.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}

			/*sSQL.Format(_T("select distinct Right(name,14) as DocYear from sysobjects where Right(name,12) = '%s_DocsDet' order by DocYear"),sYear);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			
			sSQL = _T("");
			
			
			HTREEITEM hNoData;
			HTREEITEM hItem;
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("DocYear"),oValue);
				sYear = GetValue(&oValue);
				hItem = m_TreeTest.InsertItem(sMounthName(sYear.Left(2)),pNMTreeView->itemNew.hItem);
				m_TreeTest.SetItemData(hItem,1);
				hNoData = m_TreeTest.InsertItem(_T("Нет данных"),hItem);
				Query.MoveNext();	
			}
			Query.Close();

			hNoData = m_TreeTest.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeTest.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}*/
		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError,0,0);
			exsept->Delete();
			return;
		}
	}

	if(iData == 1)
	{
		m_TreeTest.DeleteItem(hNoData);
		
		HTREEITEM hParentItem;

		hParentItem = m_TreeTest.GetParentItem(pNMTreeView->itemNew.hItem);
		CString sYear;
		sYear = m_TreeTest.GetItemText(hParentItem);
		
		CString sMonth;
		sMonth = m_TreeTest.GetItemText(pNMTreeView->itemNew.hItem);
		
		sMonth = GetMountID(sMonth);
		sMonth = sYear+sMonth;
		if(sMonth.GetLength()!= 6)
		{
			return;
		}
		try
		{
			CRecordset Query(App->dBase);
			CString sSQL;
			CDBVariant oValue;
			HTREEITEM hItem;
			sSQL = _T("");

			sSQL.Format(_T("select [Operation User] as UserName, Count(*) as ConMouth from (select [Operation User], [Shipment No_],[Item No_],[Whse_ Document No_] from [%s$Shipment Check Register] where  Left(CONVERT ( nchar , [Checked Date], 112),6) = '%s' group by [Operation User], [Shipment No_],[Item No_],[Whse_ Document No_],[Checked Date]) as TestTab group by [Operation User] order by [Operation User]"),sDatabase,sMonth);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				
				Query.GetFieldValue(_T("UserName"),oValue);
				sYear = GetValue(&oValue);

				Query.GetFieldValue(_T("ConMouth"),oValue);
				sYear = sYear + _T("\t") + GetValue(&oValue);



				hItem = m_TreeTest.InsertItem(sYear,pNMTreeView->itemNew.hItem);
				m_TreeTest.SetItemData(hItem,2);


				hNoData = m_TreeTest.InsertItem(_T("Нет данных"),hItem);
				Query.MoveNext();
			}
			Query.Close();

			hNoData = m_TreeTest.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeTest.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}
			else
			{
			
			}


/*			sSQL.Format(_T("select name from sysobjects where name like '%%%s_DocsDet' order by name"),sMonth);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("name"),oValue);
		
				if(sSQL =="")
					sSQL = _T("select tUser, count(test.con) as ConDay, '")+GetValue(&oValue)+_T("' as dat from (select tUser,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("] where id_level = 4 group by tUser,id_doc,sort,task)  as test group by tUser");
				else
					sSQL = sSQL + _T("\n union select tUser, count(test.con) as ConDay, '")+GetValue(&oValue)+_T("' as dat from (select tUser,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("] where id_level = 4  group by tUser,id_doc,sort,task)  as test group by tUser");

				Query.MoveNext();	
			}
			Query.Close();
			
			if(sSQL == "")
			{
				hNoData = m_TreeTest.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
				if (NULL==hNoData)
				{
					m_TreeTest.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
				}
				return;
			}

			sSQL = _T("select tUser, Sum(TestDay.ConDay) as ConMouth, (select NAME from USERS where tUser = USERS.ID) as UserName from (")+sSQL+_T(") as TestDay group by tUser order by UserName");
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("tUser"),oValue);
				sYear = _T("\n")+GetValue(&oValue);

				
				Query.GetFieldValue(_T("ConMouth"),oValue);
				sYear = _T("\t") + GetValue(&oValue)+sYear;

				Query.GetFieldValue(_T("UserName"),oValue);
				sYear = GetValue(&oValue)+sYear;


				hItem = m_TreeTest.InsertItem(sYear,pNMTreeView->itemNew.hItem);
				m_TreeTest.SetItemData(hItem,2);


				hNoData = m_TreeTest.InsertItem(_T("Нет данных"),hItem);
				Query.MoveNext();
			}
			Query.Close();

			hNoData = m_TreeTest.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeTest.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}
			else
			{
			
			}*/
		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError,0,0);
			exsept->Delete();
			return;
		}
	}

	if(iData == 2)
	{
		m_TreeTest.DeleteItem(hNoData);
	
		HTREEITEM hMounthItem, hYearItem;
		hMounthItem = m_TreeTest.GetParentItem(pNMTreeView->itemNew.hItem);
		CString sUser;

		sUser = m_TreeTest.GetItemText(pNMTreeView->itemNew.hItem);

		/*if(sUser.Find(_T("\n"))>-1)
		{
			sUser = sUser.Right(sUser.GetLength()- sUser.Find(_T("\n"))-1);
		}
		*/

		if(sUser.Find(_T("\t"))>-1)
		{
			sUser = sUser.Left(sUser.Find(_T("\t")));
		}

		CString sMonth;
		sMonth = m_TreeTest.GetItemText(hMounthItem);


		CString sYear;
		hYearItem = m_TreeTest.GetParentItem(hMounthItem);
		
		sYear = m_TreeTest.GetItemText(hYearItem);
		
		
		sMonth = GetMountID(sMonth);
		sMonth = sYear+sMonth;
		if(sMonth.GetLength()!= 6)
		{
			return;
		}
		try
		{
			CRecordset Query(App->dBase);
			CString sSQL;
			CDBVariant oValue;
			HTREEITEM hItem;
			sSQL = _T("");
			
			sSQL.Format(_T("select Left(CONVERT ( nchar , [Checked Date], 112),8) as dat , Count(*) as ConDay from (select [Operation User], [Shipment No_],[Item No_],[Whse_ Document No_],[Checked Date] from [%s$Shipment Check Register] where  Left(CONVERT ( nchar , [Checked Date], 112),6) = '%s' and [Operation User] = '%s' group by [Operation User], [Shipment No_],[Item No_],[Whse_ Document No_],[Checked Date]) as TestTab group by [Checked Date]"),sDatabase, sMonth, sUser);
			
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("dat"),oValue);
				sYear = GetValue(&oValue);
				sYear = sYear.Right(2);

				Query.GetFieldValue(_T("ConDay"),oValue);
				sYear = sYear + _T("\t") + GetValue(&oValue);

				hItem = m_TreeTest.InsertItem(sYear,pNMTreeView->itemNew.hItem);
				m_TreeTest.SetItemData(hItem,3);


				hNoData = m_TreeTest.InsertItem(_T("Нет данных"),hItem);
				Query.MoveNext();
			}
			Query.Close();

			hNoData = m_TreeTest.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeTest.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}
			else
			{
				
			}

			
			
			/*sSQL.Format(_T("select name from sysobjects where name like '%%%s_DocsDet' order by name"),sMonth);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("name"),oValue);
				if(sSQL =="")
				{
					if(sUser.GetLength() > 0)
						sSQL = _T("select tUser, count(test.con) as ConDay, '")+GetValue(&oValue)+_T("'  as dat from (select tUser,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("]  where id_level = 4  and tUser = '")+sUser+_T("' group by tUser,id_doc,sort,task)  as test group by tUser");
					else
						sSQL = _T("select tUser, count(test.con) as ConDay, '")+GetValue(&oValue)+_T("'  as dat from (select tUser,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("]  where id_level = 4  and tUser is Null group by tUser,id_doc,sort,task)  as test group by tUser");
				}		
				else
				{
					if(sUser.GetLength() > 0)
						sSQL = sSQL + _T("\n union select tUser, count(test.con), '")+GetValue(&oValue)+_T("' as dat from (select tUser,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("] where id_level = 4  and  tUser = '")+sUser+_T("' group by tUser,id_doc,sort,task)  as test  group by tUser");
					else
						sSQL = sSQL + _T("\n union select tUser, count(test.con), '")+GetValue(&oValue)+_T("' as dat from (select tUser,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("] where id_level = 4  and  tUser is Null group by tUser,id_doc,sort,task)  as test  group by tUser");
				}

				Query.MoveNext();	
			}
			Query.Close();
			
			if(sSQL == "")
			{
				hNoData = m_TreeTest.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
				if (NULL==hNoData)
				{
					m_TreeTest.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
				}
				return;
			}
			
			sSQL= _T("select dat,ConDay from (")+sSQL+_T(") as days order by dat");
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("dat"),oValue);
				sYear = GetValue(&oValue);
				sYear = sYear.Left(2);

				Query.GetFieldValue(_T("ConDay"),oValue);
				sYear = sYear + _T("\t") + GetValue(&oValue);

				hItem = m_TreeTest.InsertItem(sYear,pNMTreeView->itemNew.hItem);
				m_TreeTest.SetItemData(hItem,3);


				hNoData = m_TreeTest.InsertItem(_T("Нет данных"),hItem);
				Query.MoveNext();
			}
			Query.Close();

			hNoData = m_TreeTest.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeTest.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}
			else
			{
				
			}
			*/
		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError,0,0);
			exsept->Delete();
			return;
		}
	}

	if(iData == 3)
	{
		m_TreeTest.DeleteItem(hNoData);
		CString sDay;
		HTREEITEM hUser, hMounthItem, hYearItem;
		sDay = m_TreeTest.GetItemText(pNMTreeView->itemNew.hItem);
		if(sDay.Find(_T("\t"))>-1)
		{
			sDay = sDay.Left(sDay.Find(_T("\t")));
		}

		hUser = m_TreeTest.GetParentItem(pNMTreeView->itemNew.hItem);

		hMounthItem = m_TreeTest.GetParentItem(hUser);
		CString sUser;
		sUser = m_TreeTest.GetItemText(hUser);

		/*if(sUser.Find(_T("\n"))>-1)
		{
			sUser = sUser.Right(sUser.GetLength()- sUser.Find(_T("\n"))-1);
		}
		*/

		if(sUser.Find(_T("\t"))>-1)
		{
			sUser = sUser.Left(sUser.Find(_T("\t")));
		}


		CString sMonth;
		sMonth = m_TreeTest.GetItemText(hMounthItem);


		CString sYear;
		hYearItem = m_TreeTest.GetParentItem(hMounthItem);
		
		sYear = m_TreeTest.GetItemText(hYearItem);
		sMonth = GetMountID(sMonth);
		sMonth = sMonth;
		sDay = sYear+sMonth+sDay;
		if(sDay.GetLength()!= 8)
		{
			return;
		}
		try
		{
			CRecordset Query(App->dBase);
			
			CString sSQL;
			CDBVariant oValue;
			HTREEITEM hItem;
			sSQL.Format(_T("select  [Shipment No_] as DocVis, Count(*) as ConDay, [Shipment No_] as doc from (select [Operation User], [Shipment No_],[Item No_],[Whse_ Document No_],[Checked Date] from [%s$Shipment Check Register] where  Left(CONVERT ( nchar , [Checked Date], 112),8) = '%s' and [Operation User] = '%s' group by [Operation User], [Shipment No_],[Item No_],[Whse_ Document No_],[Checked Date]) as TestTab group by [Shipment No_]"),sDatabase, sDay, sUser);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("DocVis"),oValue);
				sYear = GetValue(&oValue);

				Query.GetFieldValue(_T("ConDay"),oValue);
				sYear = sYear + _T("\t") + GetValue(&oValue);

				Query.GetFieldValue(_T("doc"),oValue);
				sYear = sYear + _T("\n") + GetValue(&oValue);

				hItem = m_TreeTest.InsertItem(sYear,pNMTreeView->itemNew.hItem);
				m_TreeTest.SetItemData(hItem,4);

				Query.MoveNext();
			}
			Query.Close();

			hNoData = m_TreeTest.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeTest.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}
			else
			{
				
			}

			//tUser
			
			/*sSQL = _T("select (select DocNumberVis from [")+sDay;
			sSQL = sSQL + _T("_Docs] where id = doc ) as DocVis ,count(test.con) as ConDay,doc from (select tUser,id_doc as doc, sort,task, count(*) as con from [");
			sSQL = sSQL + sDay + _T("_DocsDet] where id_level = 4  and  ");
			if(sUser.GetLength()>0)
				sSQL = sSQL + _T(" tUser = ")+sUser + _T(" group by tUser,id_doc,sort,task) as test group by doc");
			else
				sSQL = sSQL + _T(" tUser is Null group by tUser,id_doc,sort,task) as test group by doc");

			if(sSQL == "")
			{
				hNoData = m_TreeTest.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
				if (NULL==hNoData)
				{
					m_TreeTest.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
				}
				return;
			}
			
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("DocVis"),oValue);
				sYear = GetValue(&oValue);

				Query.GetFieldValue(_T("ConDay"),oValue);
				sYear = sYear + _T("\t") + GetValue(&oValue);

				Query.GetFieldValue(_T("doc"),oValue);
				sYear = sYear + _T("\n") + GetValue(&oValue);

				hItem = m_TreeTest.InsertItem(sYear,pNMTreeView->itemNew.hItem);
				m_TreeTest.SetItemData(hItem,4);

				Query.MoveNext();
			}
			Query.Close();

			hNoData = m_TreeTest.GetNextItem(pNMTreeView->itemNew.hItem, TVGN_CHILD);
			if (NULL==hNoData)
			{
				m_TreeTest.InsertItem(_T("Нет данных"),pNMTreeView->itemNew.hItem);
			}
			else
			{
				
			}
			*/
		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError,0,0);
			exsept->Delete();
			return;
		}
	}
}

void CRepScanDlg::OnNMDblclkTreeTest(NMHDR *pNMHDR, LRESULT *pResult)
{
	return;
	CloseDoc();
	*pResult = 1;
	CPoint pos;
	GetCursorPos(&pos);

	CRect rec;
	m_TreeTest.GetWindowRect(rec);

	pos.x = pos.x - rec.left;
	pos.y = pos.y - rec.top;

	HTREEITEM hItem;
	hItem = m_TreeTest.GetFirstVisibleItem();


	CString sName;

	while(hItem != NULL)
	{
		m_TreeTest.GetItemRect(hItem,rec,FALSE);
		if((rec.left <= pos.x)
			&&(rec.right >= pos.x)
			&&(rec.bottom >= pos.y)
			&&(rec.top <= pos.y)
			)
		{
			if(m_TreeTest.GetItemData(hItem)!=4)
				return;

			CString sDay;
			CString sDocNumber;
			HTREEITEM hUser, hMounthItem, hYearItem, hDay;

			sDocNumber = m_TreeTest.GetItemText(hItem);
			if(sDocNumber.Find(_T("\n"))>-1)
			{
				sDocNumber = sDocNumber.Right(sDocNumber.GetLength() - 1 - sDocNumber.Find(_T("\n")));
			}

			hDay = m_TreeTest.GetParentItem(hItem);

			sDay = m_TreeTest.GetItemText(hDay);
			if(sDay.Find(_T("\t"))>-1)
			{
				sDay = sDay.Left(sDay.Find(_T("\t")));
			}

			hUser = m_TreeTest.GetParentItem(hDay);
			hMounthItem = m_TreeTest.GetParentItem(hUser);
	
			CString sMonth;
			sMonth = m_TreeTest.GetItemText(hMounthItem);

			CString sYear;
			hYearItem = m_TreeTest.GetParentItem(hMounthItem);
		
			sYear = m_TreeTest.GetItemText(hYearItem);
			sMonth = GetMountID(sMonth);
			sMonth = sMonth;
			sDay = sDay+sMonth+sYear;

			if(sDay.GetLength()!= 8)
			{
				return;
			}
			if(bOpenDoc(sDay,_wtoi(sDocNumber)))
			{
				m_Tab.SetCurSel(iDocPage);
				SetVisible(iDocPage);
			}
			break;
		}
		hItem = m_TreeTest.GetNextVisibleItem(hItem);
	}
}

void CRepScanDlg::OnCancel()
{
	
}

void CRepScanDlg::OnOK()
{
	
}

void CRepScanDlg::OnClose()
{
	CDialog::OnCancel();
}

BOOL CRepScanDlg::PreTranslateMessage(MSG* pMsg)
{
	if (pMsg->message == WM_KEYDOWN)
	{
		if(VK_RETURN  == pMsg->wParam)
		{
			if(pMsg->hwnd == m_BarCode.m_hWnd) 
				{
					TestScanerData();
					m_BarCode.SetWindowTextW(_T(""));
					m_BarCode.SetFocus();
				}				
			return TRUE;		
		}

		
	}

	if ( WM_LBUTTONUP == pMsg->message )
		{
			if ( pMsg->hwnd == m_bSeachInLog.m_hWnd )
			{
				OnBnClickedCheck1();

			}
		}

	return CDialog::PreTranslateMessage(pMsg);
}


void CRepScanDlg::TestScanerData(void)
{
	CString sBarCode;
	m_BarCode.GetWindowTextW(sBarCode);
	sBarCode.MakeUpper();
	if(m_Tab.GetCurSel() == iDocPage)
		m_BarCode.TestState(LoadDocData(sBarCode));
	else
		m_BarCode.TestState(FindDocDetail(sBarCode));
}

bool CRepScanDlg::FindDocDetail(CString sBarCode)
{
	if(sBarCode.GetLength()< 1)
		return FALSE;
	
	CloseDoc();
	CRepScanApp *pApp;
	pApp = (CRepScanApp*)AfxGetApp();
	if(pApp->dBase == NULL)
		return FALSE;
	try
	{
		CString sSQL;
		CRecordset Query(pApp->dBase);
		CString docRoute;
		CDBVariant cdVar;
		
		sSQL.Format(_T("select distinct name as DocYear, (Right(left(name,8),4)+Right(left(name,4),2)+left(name,2)) as sort from sysobjects where Right(name,8) = '_DocsDet' order by sort"));
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		sSQL = _T("");
		CStringArray sNameTables; 
		sNameTables.RemoveAll();
		while(!Query.IsEOF())
		{
			Query.GetFieldValue(_T("DocYear"),cdVar);
			sNameTables.Add(GetValue(&cdVar));
			Query.MoveNext();
		}
		Query.Close();

		CString sTableName;
		GridDocs.SetRowCount(1);
		GridDocs.SetCanreDraw(FALSE);
		int lRow;
		long lID;
		lRow = 1;
		while(sNameTables.GetCount()>0)
		{
			sTableName = sNameTables.ElementAt(0);
			sTableName = sTableName.Left(8);
			sSQL = _T("select distinct ID,	DocNumberVis,docSendTime,docMode,DocPalete,	docDivision,docOperator,docItemsCount,DocLine,docRoute,(select NAME from dbo.USERS where [")+sTableName+_T("_Docs].TUser = dbo.USERS.ID) as UserName, iDocAssembleLine from [")+sTableName+_T("_DocsDet] join [")+sTableName+_T("_Docs] on [")+sTableName+_T("_Docs].ID = [")+sTableName+_T("_DocsDet].ID_DOC where CatalogNumber = '")+sBarCode+_T("'");
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				lRow++;
				GridDocs.SetRowCount(lRow);
				Query.GetFieldValue(_T("ID"), cdVar);
				lID = GetValueID(&cdVar);
				GridDocs.SetItemData(lRow-1,0,lID);
				GridDocs.SetItemData(lRow-1,1,_wtoi(sTableName));
				for(short j = 1;j<12;j++)
				{
					Query.GetFieldValue(j, cdVar);
					GridDocs.SetItemText(lRow-1,j,GetValue(&cdVar));
				}
				Query.MoveNext();
			}
			Query.Close();
			sNameTables.RemoveAt(0,1);
			
		}
		GridDocs.SetCanreDraw(TRUE);
	}
	catch(CDBException *exsept)
	{
		AfxMessageBox(exsept->m_strError);
		exsept->Delete();
		return FALSE;
	}

	if(GridDocs.GetRowCount()<2)
	{
		return FALSE;
	}
	GridDocs.SelectItem(1);
	return TRUE;
}

bool CRepScanDlg::LoadDocData(CString sBarCode)
{
	CloseDoc();
	CRepScanApp *pApp;
	pApp = (CRepScanApp*)AfxGetApp();
	if(pApp->dBase == NULL)
		return FALSE;
	try
	{
		CString sSQL;
		CRecordset Query(pApp->dBase);
		CString docRoute;
		CDBVariant cdVar;
		if(m_bSeachInLog.GetCheck())
		{
			CString sData;
			m_EdDate.GetWindowTextW(sData);
			sBarCode.Replace(_T("'"),_T(""));
			sBarCode.Replace(_T(" "),_T("%"));
			sBarCode.Replace(_T("%%"),_T("%"));
			sData.Replace(_T("."),_T(""));
			sSQL.Format(_T("select id as ID_DOC, '%s' as docData from [%s_Docs] where LogData like '%%%s%%'"),sData,sData,sBarCode);
		}
		else
		{
			sSQL.Format(_T("select ID_DOC,docData from DOC_MAP where DocNumberVis = '%s'"),sBarCode);
		}
		CArray<stDoc*,stDoc*> arrItem;
		arrItem.RemoveAll();
		stDoc* NewPos; 
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		while(!Query.IsEOF())
		{
			NewPos = new(stDoc);
			Query.GetFieldValue(_T("ID_DOC"),cdVar);
			NewPos->lID = GetValueID(&cdVar);
			Query.GetFieldValue(_T("docData"),cdVar);
			NewPos->sData = GetValue(&cdVar);
			arrItem.Add(NewPos);
			Query.MoveNext();
		}
		Query.Close();
		
		GridDocs.SetRowCount(1);

		if(arrItem.GetCount()==0)
		{
			arrItem.RemoveAll();
			return FALSE;
		}

		
		int lRow;
		long lID;
		lRow = 1;
		for(int i=0;i<arrItem.GetCount();i++)
		{
			NewPos = arrItem.ElementAt(i);
			if(NewPos->sData.GetLength()<1)
			{
				sSQL.Format(_T("select ID,	DocNumberVis,docSendTime,docMode,DocPalete,	docDivision,docOperator,docItemsCount,DocLine,docRoute,(select NAME from dbo.USERS where TUser = dbo.USERS.ID) as UserName, iDocAssembleLine from NotCollectedDocs where id = %d"),NewPos->lID);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				
				if(!Query.IsEOF())
				{
					lRow++;
				GridDocs.SetRowCount(lRow);
					Query.GetFieldValue(_T("ID"), cdVar);
					lID = GetValueID(&cdVar);

					GridDocs.SetItemData(lRow,0,lID);
					for(short j = 1;j<12;j++)
					{
						Query.GetFieldValue(j, cdVar);
						GridDocs.SetItemText(lRow-1,j,GetValue(&cdVar));
					}
				}
				Query.Close();
			}
			else
			{
				sSQL.Format(_T("select ID,	DocNumberVis,docSendTime,docMode,DocPalete,	docDivision,docOperator,docItemsCount,DocLine,docRoute,(select NAME from dbo.USERS where TUser = dbo.USERS.ID) as UserName, iDocAssembleLine from [%s_Docs] where id = %d"),NewPos->sData,NewPos->lID);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				
				if(!Query.IsEOF())
				{
					lRow++;
					GridDocs.SetRowCount(lRow);
					Query.GetFieldValue(_T("ID"), cdVar);
					lID = GetValueID(&cdVar);
					GridDocs.SetItemData(lRow-1,0,lID);
					GridDocs.SetItemData(lRow-1,1,_wtoi(NewPos->sData));
					for(short j = 1;j<12;j++)
					{
					
						Query.GetFieldValue(j, cdVar);
						
						
						
						GridDocs.SetItemText(lRow-1,j,GetValue(&cdVar));
					}
				}
				Query.Close();
			}
		}
	}
	catch(CDBException *exsept)
	{
		AfxMessageBox(exsept->m_strError);
		exsept->Delete();
		return FALSE;
	}

	if(GridDocs.GetRowCount()<2)
	{
		return FALSE;
	}
	GridDocs.SelectItem(1);
	return TRUE;
}

//if(bSelectDoc(sDay,_wtoi(sDocNumber)))

void CRepScanDlg::OpenDoc(NMHDR* pNMHDR, LRESULT* pResult)
{
	if(GridDocs.iSelRow<1)
	{
		return;
	}

	CString sData;
	sData.Format(_T("%d"),GridDocs.GetItemData(GridDocs.iSelRow,1));
	while(sData.GetLength()<8)
	{
		sData = _T("0")+sData ;
	}

	bSelectDoc(sData,GridDocs.GetItemData(GridDocs.iSelRow,0));
}

void CRepScanDlg::CloseDoc()
{
	//Deleet;
	m_ListZones.DeleteAllItems();
	DocPosGrid.SetRowCount(1);
	BoxQuantGrid.SetRowCount(1);
	BoxGrid.SetRowCount(1);
	while(m_listLog.GetCount()>0)
		m_listLog.DeleteString(0);
}

void CRepScanDlg::OnExit()
{
	PostMessage(WM_CLOSE,0,0);
}

void CRepScanDlg::OnReportAssemble()
{
	CDlgReport dialog;
	dialog.bAssemble = 1;
	dialog.sDatabase = sDatabase; 
	dialog.DoModal();
}

/**/

//OnIdleTime
void CRepScanDlg::OnIdleTime()
{
	CDlgReport dialog;
	dialog.bAssemble = 3;
	dialog.sDatabase = sDatabase; 
	dialog.DoModal();
	
}


void CRepScanDlg::OnReportTest()
{
	CDlgReport dialog;
	dialog.bAssemble = 0;
	dialog.sDatabase = sDatabase; 
	dialog.DoModal();
	
}

void CRepScanDlg::OnReportLog()
{
	CDlgReport dialog;
	dialog.bAssemble = 2;
	dialog.sDatabase = sDatabase; 
	dialog.DoModal();
	
}
void CRepScanDlg::OnBnClickedCheck1()
{
	m_EdDate.SetReadOnly(m_bSeachInLog.GetCheck());
}

void CRepScanDlg::OnReportAssembleMounth()
{
	CDlgReportMounth dialog;
	dialog.sDatabase =sDatabase;
	dialog.DoModal();
}

//
void CRepScanDlg::Mess_Print()
{
	int i;
	CString sValue;
	Excel::_ApplicationPtr appExcel;
	Excel::WorkbooksPtr ExcelBooks;
	Excel::_WorkbookPtr ExcelBook;
	Excel::_WorksheetPtr ExcelSheet;
	Excel::RangePtr range;

	appExcel.CreateInstance( _T("Excel.Application"));
	VARIANT bTRUE;
	bTRUE.vt = 11;
	bTRUE.boolVal = TRUE;
	appExcel->Visible[0] = FALSE;
	ExcelBook= appExcel->Workbooks->Add();
	ExcelSheet = ExcelBook->Worksheets->Item[1];
	for(i=0; i < m_listLog.GetCount();i++)
	{
		m_listLog.GetText(i, sValue);
		ExcelSheet->Cells->Item[i+1,1] = sValue.AllocSysString();
	}
	appExcel->Visible[0] = TRUE;
}