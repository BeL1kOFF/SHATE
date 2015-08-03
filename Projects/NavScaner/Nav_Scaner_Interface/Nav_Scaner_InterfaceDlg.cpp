// Nav_Scaner_InterfaceDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner_Interface.h"
#include "Nav_Scaner_InterfaceDlg.h"
#include "DlgDatabase.h"
#include "DlgNewDoc.h"
#include "BulkRecordset.h"
#include "ServerRecordset.h"
#include "DlgAddTest.h"
#include "DlgEditDoc.h"
#include "DLgEditGroup.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CNav_Scaner_InterfaceDlg dialog




CNav_Scaner_InterfaceDlg::CNav_Scaner_InterfaceDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CNav_Scaner_InterfaceDlg::IDD, pParent)
	, Main_Menu(NULL)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	dwThreadID = 0;
	bTerminate = FALSE;
	menuAction = NULL;
}

void CNav_Scaner_InterfaceDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_COMBO_LOCATION, m_ComboLocation);
	DDX_Control(pDX, IDC_LIST_DOCS, m_ListDocs);
	DDX_Control(pDX, IDC_STATIC_LOCATION, m_stLocation);
	DDX_Control(pDX, IDC_STATIC_DOCS, m_stDocs);
	DDX_Control(pDX, IDC_BUTTON_FILTER, m_btFilter);
	DDX_Control(pDX, IDC_COMBO_FILTER, m_ComboFilterField);
	DDX_Control(pDX, IDC_COMBO_FILTER_OPERATION, m_ComboFilterOperation);
	DDX_Control(pDX, IDC_EDIT_FILTER_VALUE, m_EdFilterValue);
	DDX_Control(pDX, IDC_CHECK_DISTIN, m_btDistinOnly);
	DDX_Control(pDX, IDC_TREE_TASK, m_TreeAsk);
	DDX_Control(pDX, IDC_STATIC_TASK, m_stTask);
	DDX_Control(pDX, IDC_STATIC_GROUP, m_StGroup);
	DDX_Control(pDX, IDC_COMBO_GROUP, m_ComboGroup);
	DDX_Control(pDX, IDC_BUTTON_EDIT_GROUP, m_BtEditGroup);
}

BEGIN_MESSAGE_MAP(CNav_Scaner_InterfaceDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_COMMAND(ID_DATABASE, OnDataBaseSetting)
	ON_COMMAND(ID_CREATE_DOC, OnCreateDoc)
	ON_COMMAND(ID_EXPORT_DOC, OnExportDoc)
	
	//ID_CREATE_DOC
	//}}AFX_MSG_MAP
	ON_CBN_SELCHANGE(IDC_COMBO_LOCATION, &CNav_Scaner_InterfaceDlg::OnCbnSelchangeComboLocation)
	ON_LBN_SELCHANGE(IDC_LIST_DOCS, &CNav_Scaner_InterfaceDlg::OnLbnSelchangeListDocs)
	//OnSelectedPos
	ON_NOTIFY(GVN_SELCHANGED, IDC_GRID_POS, OnSelectedPos)
	ON_WM_SIZE()
	ON_BN_CLICKED(IDC_BUTTON_FILTER, &CNav_Scaner_InterfaceDlg::OnBnClickedButtonFilter)
	ON_NOTIFY(TVN_SELCHANGED, IDC_TREE_TASK, &CNav_Scaner_InterfaceDlg::OnTvnSelchangedTreeTask)
	ON_LBN_DBLCLK(IDC_LIST_DOCS, &CNav_Scaner_InterfaceDlg::OnLbnDblclkListDocs)
	ON_BN_CLICKED(IDC_BUTTON_EDIT_GROUP, &CNav_Scaner_InterfaceDlg::OnBnClickedButtonEditGroup)
	ON_CBN_SELCHANGE(IDC_COMBO_GROUP, &CNav_Scaner_InterfaceDlg::OnCbnSelchangeComboGroup)
END_MESSAGE_MAP()


// CNav_Scaner_InterfaceDlg message handlers

BOOL CNav_Scaner_InterfaceDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	
	/*CWnd *Win = GetDesktopWindow();
	SetParent(Win);

	CRect rec;
	Win->GetClientRect(rec);
	MoveWindow(rec);*/
	SetIcon(m_hIcon, TRUE);
	SetIcon(m_hIcon, FALSE);

	Main_Menu = new CMenu;
	Main_Menu->LoadMenu(IDR_MAINMENU);
	this->SetMenu(Main_Menu);

	ShowWindow(SW_MAXIMIZE);

	m_ComboFilterField.InsertString(0,_T("Номер"));
	m_ComboFilterField.InsertString(1,_T("Бренд"));
	m_ComboFilterField.InsertString(2,_T("Номер НАВ"));
	m_ComboFilterField.SetCurSel(0);

	m_ComboFilterOperation.InsertString(0,_T("равно"));
	m_ComboFilterOperation.InsertString(1,_T("содержит"));

	m_ComboFilterOperation.SetCurSel(0);

	



	CRect rec;
	GetClientRect(rec);

	rec.left = rec.right/2;
	rec.bottom = rec.bottom/2;
	GridPosition.Create(rec,this,IDC_GRID_POS,WS_VISIBLE|WS_CHILD);
	
	rec.top  = rec.bottom +10;
	rec.bottom  = rec.bottom +rec.top ;

	GridLog.Create(rec,this,IDC_GRID_LOG,WS_VISIBLE|WS_CHILD);
	GridLog.SetRowCount(1);
	GridLog.SetColumnCount(5);

	
	CImageList *ImageList;
	ImageList = new CImageList;
	ImageList->Create(MAKEINTRESOURCE(IDB_BITMAP), 12, 1, RGB(255,255,255));
	
	GridLog.SetImageList(ImageList);
	GridLog.SetItemText(0,0,_T(""));
	GridLog.SetItemText(0,1,_T("Дате"));
	GridLog.SetItemText(0,2,_T("Ячейка"));
	GridLog.SetItemText(0,3,_T("Кол.во"));
	GridLog.SetItemText(0,4,_T("Пользователь"));
	GridLog.SetFixedColumnCount(1);
	GridLog.SetEditable(FALSE);
	GridLog.SetListMode(TRUE);
	GridLog.SetSingleRowSelection(TRUE);
	GridLog.SetFixedRowCount(1);


	GridPosition.SetRowCount(1);
	GridPosition.SetColumnCount(12);
	
	GridPosition.SetItemText(0,1,_T("Номер"));
	GridPosition.SetItemText(0,2,_T("Бренд"));
	GridPosition.SetItemText(0,3,_T("Кол.в уп."));
	GridPosition.SetItemText(0,4,_T("Описание"));
	GridPosition.SetItemText(0,5,_T("Ед.Изм."));
	GridPosition.SetItemText(0,6,_T("Кол-во"));
	GridPosition.SetItemText(0,7,_T("Проверенно"));
	GridPosition.SetItemText(0,8,_T("Код НАВ"));
	GridPosition.SetItemText(0,9,_T("Ячейка"));
	GridPosition.SetItemText(0,10,_T("Зона"));
	GridPosition.SetItemText(0,11,_T("Проверил"));
	GridPosition.SetFixedColumnCount(1);
	GridPosition.SetEditable(FALSE);
	GridPosition.SetListMode(TRUE);
	GridPosition.SetSingleRowSelection(TRUE);
	GridPosition.SetFixedRowCount(1);
	//GridPosition.SetCanDraw(TRUE);

	/*
	HWND hwndToolBar=FindWindowEx(NULL, NULL, "Shell_TrayWnd", NULL);
	*/
	Resize();
	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();

	if(pApp->dBaseNav != NULL)
	{
		CreateThread(NULL, NULL, (LPTHREAD_START_ROUTINE)UpdateThread, (void*)this, NULL, &dwThreadID);
	}
	//return TRUE;
	LoadLocation();
	LoadGroup();
	//LoadInvDoc();
	return TRUE;
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CNav_Scaner_InterfaceDlg::OnPaint()
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
HCURSOR CNav_Scaner_InterfaceDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


void CNav_Scaner_InterfaceDlg::OnOK()
{
	
}


void CNav_Scaner_InterfaceDlg::OnDataBaseSetting(void)
{
	CDlgDatabase dialog;
	dialog.DoModal();
}
void CNav_Scaner_InterfaceDlg::OnExportDoc()
{
	HRESULT hRes;
	Excel::_ApplicationPtr appExcel;
	hRes = appExcel.CreateInstance( _T("Excel.Application"));
	Excel::WorkbooksPtr ExcelBooks;
	Excel::_WorkbookPtr ExcelBook;
	Excel::_WorksheetPtr ExcelSheet;
	Excel::RangePtr range;
	VARIANT bTRUE;
	bTRUE.vt = 11;
	bTRUE.boolVal = TRUE;
	appExcel->Visible[0] = FALSE;
	ExcelBook= appExcel->Workbooks->Add();
	ExcelSheet = ExcelBook->Worksheets->Item[1];

	int i;
	int j;
	for(i=0;i<GridPosition.GetRowCount();i++)
	{
		range = ExcelSheet->Range[ExcelSheet->Cells->Item[i+1, 1],ExcelSheet->Cells->Item[i+1, GridPosition.GetColumnCount()]];
		range->NumberFormat =_T("@");
		for(j=0;j<GridPosition.GetColumnCount();j++)
		{
			ExcelSheet->Cells->Item[i+1, j+1] = GridPosition.GetItemText(i,j).AllocSysString();
		}
	}
	appExcel->Visible[0] = TRUE;
	appExcel = NULL;
	AfxMessageBox(_T("Выполненно!"));
}

void CNav_Scaner_InterfaceDlg::OnCreateDoc()
{
	if(m_ComboLocation.GetCurSel()<0)
	{
		return;
	}

	CString sLocation;
	m_ComboLocation.GetLBText(m_ComboLocation.GetCurSel(),sLocation);
	if(sLocation.GetLength()<1)
		return;

	CDlgNewDoc NewDoc;
	NewDoc.sLocation = sLocation;
	NewDoc.DoModal();

	LoadInvDoc();
}

DWORD CNav_Scaner_InterfaceDlg::UpdateThread(LPVOID param)
{
	CNav_Scaner_InterfaceDlg * Param;
	Param = (CNav_Scaner_InterfaceDlg*)param;
	Param->UpdateData();
		
	Param->dwThreadID = 0;
	return 0L;
}

void CNav_Scaner_InterfaceDlg::UpdateData(void)
{
	CIniReader IniReader;
	CString sSQL;
	CArray <stUpdate*,stUpdate*> aUpdate;
	stUpdate* NewElement;

	CNewDatabase* dBase;
	CNewDatabase* dBaseNav;
	dBase = new(CNewDatabase);
	dBaseNav = new(CNewDatabase);
	try
	{
		CString sServer;
		CString sName;
		sServer = IniReader.ReadFromIni(_T("DB_NAV"),_T("SERVER"),_T("LOCALHOST"));
		sName = IniReader.ReadFromIni(_T("DB_NAV"),_T("NAME"),_T("Database"));

		CString sConnect;
		sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sName);
		#ifdef _DEBUG
			sConnect.Format(_T("DSN=Spbypril0777;UID=Admin2;PWD=Admin2;"));			
		#endif
		dBaseNav->OpenEx(sConnect,CDatabase::noOdbcDialog);
		sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
		dBaseNav->ExecuteSQL(sConnect);
		dBaseNav->SetQueryTimeout(0);

		
		sServer = IniReader.ReadFromIni(_T("DB"),_T("SERVER"),_T("LOCALHOST"));
		sName = IniReader.ReadFromIni(_T("DB"),_T("NAME"),_T("Database"));
		sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sName);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		dBase->SetQueryTimeout(0);
	}
	catch(CDBException *exp = NULL)
	{
		exp->Delete();
		if(dBase->IsOpen())
			dBase->Close();
		if(dBaseNav->IsOpen())
			dBaseNav->Close();
		delete(dBaseNav);
		delete(dBase);
		return;
	}

	try
	{
		
		CString sFirm = IniReader.ReadFromIni(_T("DB_NAV"),_T("FIRM"),_T("Shate-M"));	
		CNewRecordset Query_Prog(dBase);
		CNewRecordset QueryNav(dBaseNav);
		CDBVariant dbValue;
		sSQL.Format(_T("SELECT [TableName],[LastUpdate],[NAV_Name],[SQL Field],[INSERT_SQL],[UPDATE_SQL] FROM [UPDATE]"));
		Query_Prog.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);

		int iField;

		while(!Query_Prog.IsEOF())
		{
			if(bTerminate)
				break;
			NewElement = new(stUpdate);
			for(iField = 0; iField < 6;iField++)
			{
				Query_Prog.GetFieldValue(iField, dbValue);
				switch(iField)
				{
				case 0:
					NewElement->sTableName = GetValue(&dbValue);
					break;

				case 1:
					NewElement->sVersion = GetValue(&dbValue);
					break;

				case 2:
					NewElement->sNavName.Format(GetValue(&dbValue),sFirm);
					break;

				case 3:
					NewElement->sSQL = GetValue(&dbValue);
					break;
				
				case 4:
					NewElement->sInsertSQL = GetValue(&dbValue);
					break;

				case 5:
					NewElement->sUpdateSQL = GetValue(&dbValue);
					break;
				}
			}
			aUpdate.Add(NewElement);
			Query_Prog.MoveNext();
		}
		Query_Prog.Close();

		CString sField;

		CString sSQL_Insert;
		CString sSQL_Update;
		CString sVersion;

		while(aUpdate.GetCount()>0)
		{
			Sleep(1000);
			if(bTerminate)
				break;
			NewElement = aUpdate.ElementAt(0);
			sVersion = NewElement->sVersion;
			while(true)
			{
				if(bTerminate)
					break;

				sSQL.Format(_T("select %s from [%s] where convert(bigint,[timestamp]) > %s order by [timestamp] "),NewElement->sSQL,NewElement->sNavName,sVersion);
				QueryNav.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
				if(QueryNav.IsEOF())
				{
					QueryNav.Close();
					break;
				}
				while(!QueryNav.IsEOF())
				{
					sSQL_Insert = NewElement->sInsertSQL;
					sSQL_Update = NewElement->sUpdateSQL;
					for(iField = 0; iField < QueryNav.GetODBCFieldCount();iField++)
					{
						QueryNav.GetFieldValue(iField, dbValue);
						if(iField == 0)
						{
							sVersion = GetValue(&dbValue);
						}
						sField.Format(_T("%%Field_%d%%"),iField);
						sSQL_Insert.Replace(sField,GetValue(&dbValue));
						sSQL_Update.Replace(sField,GetValue(&dbValue));
					}
		
					try
					{
						dBase->ExecuteSQL(sSQL_Insert);
					}
					catch(CDBException *expt)
					{
						expt->Delete();
						if(sSQL_Update.GetLength()>0)
							dBase->ExecuteSQL(sSQL_Update);
					}
					QueryNav.MoveNext();
					
				}
			sSQL.Format(_T("UPDATE [UPDATE] SET [LastUpdate] = '%s' WHERE [TableName] = '%s'"),sVersion,NewElement->sTableName);
			dBase->ExecuteSQL(sSQL);
			Sleep(1000);
			QueryNav.Close();
				
			}
			delete(NewElement);
			aUpdate.RemoveAt(0,1);
		}
	}
	catch(CDBException *expt)
	{
		CString sError;
		sError.Format(_T("%s %s"),expt->m_strError,sSQL);
		expt->Delete();
	}

	while(aUpdate.GetCount()>0)
	{
		NewElement = aUpdate.ElementAt(0);
		delete(NewElement);
		aUpdate.RemoveAt(0,1);
	}
	if(dBase->IsOpen())
			dBase->Close();
	
	if(dBaseNav->IsOpen())
			dBaseNav->Close();
	
	delete(dBaseNav);
	delete(dBase);
}

void CNav_Scaner_InterfaceDlg::LoadLocation(void)
{
	while(m_ListDocs.GetCount()>0)
	{
		m_ListDocs.DeleteString(0);
	}

	while(m_ComboLocation.GetCount()>0)
	{
		m_ComboLocation.DeleteItem(0);
	}

	CString sSQL;

	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	if(pApp->dBaseProg == NULL)
		return;

	try
	{
		CNewRecordset Query_Prog(pApp->dBaseProg);
		CDBVariant dbValue;
		sSQL.Format(_T("select distinct [Location code] from dbo.USERS as us left join [Warehouse Employee] as we on us.[USER ID] = we.[User ID] where us.[USER ID] = '%s' and (us.[TYPE] %% 11 = 0 or we.[TYPE] %% 11 = 0)"),GetWinUserName());
		Query_Prog.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
		int iField;

		iField = 0;	
		while(!Query_Prog.IsEOF())
		{
			Query_Prog.GetFieldValue(iField, dbValue);
			m_ComboLocation.AddString(GetValue(&dbValue));
			Query_Prog.MoveNext();
		}
		Query_Prog.Close();
		

	}
	catch(CDBException *expt)
	{
		CString sError;
		sError.Format(_T("%s %s"),expt->m_strError,sSQL);
		
		expt->Delete();
		AfxMessageBox(sError);
	}

	if(m_ComboLocation.GetCount() > 0)
	{
		m_ComboLocation.SetCurSel(0);
	}
}

void CNav_Scaner_InterfaceDlg::OnCbnSelchangeComboLocation()
{
	LoadInvDoc();
}

void CNav_Scaner_InterfaceDlg::LoadInvDoc(void)
{
	
	GridLog.SetRowCount(1);
	GridPosition.SetRowCount(1);

	long lGroup;
	lGroup = m_ComboGroup.GetCurSel();
	if(lGroup<0)
	{
		lGroup = m_ComboGroup.GetItemData(lGroup);
	}

	if(m_ComboLocation.GetCurSel()<0)
	{
		return;
	}

	CString sLocation;
	m_ComboLocation.GetLBText(m_ComboLocation.GetCurSel(),sLocation);
	if(sLocation.GetLength()<1)
		return;

	while(m_ListDocs.GetCount()>0)
	{
		m_ListDocs.DeleteString(0);
	}

	

	lGroup = m_ComboGroup.GetCurSel();


	CString sSQL;

	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	if(pApp->dBaseProg == NULL)
		return;

	try
	{
		CNewRecordset Query_Prog(pApp->dBaseProg);
		CDBVariant dbValue;
		sSQL.Format(_T("select  ([DATE]+'   '+[DESCRIPTION]) as tex, [ID] from [Inventary Doc Header] as idh where idh.[Location Code] = '%s' and idh.ID_GROUP = %d order by [ID]"),sLocation,lGroup);
		Query_Prog.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
		int iField;

		
		int iItem;
		iItem = 0;
		while(!Query_Prog.IsEOF())
		{
			iField = 0;	
			Query_Prog.GetFieldValue(iField, dbValue);
			m_ListDocs.InsertString(iItem,GetValue(&dbValue));
			

			iField++;
			Query_Prog.GetFieldValue(iField, dbValue);
			m_ListDocs.SetItemData(iItem, _wtoi(GetValue(&dbValue)));
			iItem++;
			Query_Prog.MoveNext();
		}
		Query_Prog.Close();
		

	}
	catch(CDBException *expt)
	{
		CString sError;
		sError.Format(_T("%s %s"),expt->m_strError,sSQL);
		
		expt->Delete();
		AfxMessageBox(sError);
	}

	if(m_ListDocs.GetCount() > 0)
	{
		long lData;
		
		m_ListDocs.SetCurSel(m_ListDocs.GetCount()-1);
		//m_TreeAsk.DeleteAllItems();
		lData = m_ListDocs.GetItemData(m_ListDocs.GetCount()-1);
		if(lData > 0)
			LoadTreeTask(lData);
		LoadInvDocData();
	}
}


BOOL CNav_Scaner_InterfaceDlg::PreTranslateMessage(MSG* pMsg)
{
	if (pMsg->message == WM_RBUTTONDOWN)
	{
		if(pMsg->hwnd == GridLog.m_hWnd)
		{
			if(menuAction != NULL)
			{
				menuAction->DestroyMenu();
				delete(menuAction);
				menuAction = NULL;
			}


			menuAction = new CMenu;
			menuAction->CreatePopupMenu();
			POINT point;
			GetCursorPos(&point);
			if(GridPosition.GetSelectRow()>0)
			menuAction->AppendMenuW(MF_POPUP | MF_ENABLED , WM_ACTION,_T("Проверить")); 
			if(GridLog.GetSelectRow()>0)
				menuAction->AppendMenuW(MF_POPUP | MF_ENABLED , WM_ACTION+1,_T("Отменить")); 
			menuAction->TrackPopupMenu(TPM_LEFTALIGN | TPM_RIGHTBUTTON, point.x, point.y,(CWnd*)this);
		}
	}
	
	if (pMsg->message == WM_KEYDOWN)
	{
		if(pMsg->hwnd == m_EdFilterValue)
		{
			if(VK_RETURN  == pMsg->wParam)
			{
				LoadInvDoc();
				return TRUE;
			}
		}
	
		
	}
	if (pMsg->message == WM_COMMAND)
	{
		if(pMsg->wParam == WM_ACTION+1)
		{
			CancelTest();
			return TRUE;		
		}

		if(pMsg->wParam == WM_ACTION)
		{
			TestPosition();
			return TRUE;		
		}
		//DlgAddTest
	}

	return CDialog::PreTranslateMessage(pMsg);
}

void CNav_Scaner_InterfaceDlg::TestPosition()
{
	int iRowPosition;

	if(GridPosition.GetSelectRow()<1)
	{
		return;
	}

	int iLine;
	iRowPosition = GridPosition.GetSelectRow();
	iLine = GridPosition.GetItemData(iRowPosition,0);
	int lDoc;
	lDoc = m_ListDocs.GetCurSel();
	if(lDoc < 0)
		return;

	lDoc = m_ListDocs.GetItemData(lDoc);

	if(lDoc < 1)
		return;

	CStringArray stArray;
	stArray.Add(GridPosition.GetItemText(iRowPosition, 1));
	stArray.Add(GridPosition.GetItemText(iRowPosition, 2));
	stArray.Add(GridPosition.GetItemText(iRowPosition, 4));
	stArray.Add(GridPosition.GetItemText(iRowPosition, 3));
	CDlgAddTest Dialog(NULL,&stArray);
	if(Dialog.DoModal()!=IDOK)
	{
		return;
	}
	
	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	if(pApp->dBaseProg == NULL)
	{
		AfxMessageBox(_T("Не доступна БД!"));
		return;
	}


	CString sSQL;
	try
	{
		pApp->dBaseProg->BeginTrans();
		COleDateTime oDateTime;
		oDateTime = COleDateTime::GetCurrentTime();
		sSQL.Format(_T("INSERT INTO [Inventary Log] ([Doc_id],[Line_id],[Test_id],[Item],[Cell],[Count],[User],[Date],[Type]) VALUES (%d ,%d,(select coalesce(MAX(Test_id),0)+1 from [Inventary Log] where [Doc_id] = %d and [Line_id] = %d),%s,'%s',%s,'%s','%s',0)"),lDoc,iLine,lDoc,iLine,GridPosition.GetItemText(iRowPosition, 8),Dialog.sCell,Dialog.sCount,GetWinUserName(),oDateTime.Format(_T("%Y%m%d%H%M%S")));
		pApp->dBaseProg->ExecuteSQL(sSQL);
		sSQL.Format(_T("update [Inventary Doc Line] set [Test_Count] = [Test_Count] + %s where Doc_id = %d and Line_id = %d"),Dialog.sCount,lDoc,iLine);
		pApp->dBaseProg->ExecuteSQL(sSQL);
		pApp->dBaseProg->CommitTrans();
	}
	catch(CDBException *expt)
	{
		pApp->dBaseProg->Rollback();
		CString sError = expt->m_strError+sSQL;
		expt->Delete();
		AfxMessageBox(sError);
	}
	LoadInvDocData();
}


void CNav_Scaner_InterfaceDlg::CancelTest()
{
	int iRow, iRowPosition;

	if(GridPosition.GetSelectRow()<1)
	{
		return;
	}

	iRowPosition = GridPosition.GetSelectRow();

	if(GridLog.GetSelectRow()<1)
	{
		return;
	}
	iRow = GridLog.GetSelectRow();

	int lDoc;
	lDoc = m_ListDocs.GetCurSel();
	if(lDoc < 0)
		return;

	lDoc = m_ListDocs.GetItemData(lDoc);

	if(lDoc < 1)
		return;

	CString sAction;
	switch(GridLog.GetItemData(iRow,0))
	{
	case 0:	
		sAction = _T(" проверка ");
		break;

	case 1:	
		sAction = _T(" отмена ");
		break;
	}

	if (AfxMessageBox(_T("Отменить")+sAction+_T("товара \"")+GridPosition.GetItemText(iRowPosition, 1)+_T("_")+GridPosition.GetItemText(iRowPosition, 2)+_T("\" ячейки ")+GridLog.GetItemText(iRow, 2)+_T(" в кол-ве ")+GridLog.GetItemText(iRow, 3),MB_YESNO,IDNO) == IDNO)
	{
		return;
	}

	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	if(pApp->dBaseProg == NULL)
	{
		AfxMessageBox(_T("Не доступна БД!"));
		return;
	}


	CString sSQL;
	int iType;
	iType = GridLog.GetItemImage(iRow,0);
	switch(iType)
	{
	case 0:	
			try
			{
				pApp->dBaseProg->BeginTrans();
				sSQL.Format(_T("update [Inventary Log] set [Type] = 2 where Doc_id = %d and Line_id = %d and Test_id = %d"),lDoc,GridLog.GetItemData(iRow,0),GridLog.GetItemData(iRow,1));
				pApp->dBaseProg->ExecuteSQL(sSQL);
				sSQL.Format(_T("update [Inventary Doc Line] set [Test_Count] = [Test_Count] - %s where Doc_id = %d and Line_id = %d"),GridLog.GetItemText(iRow, 3),lDoc,GridLog.GetItemData(iRow,0));
				pApp->dBaseProg->ExecuteSQL(sSQL);
				pApp->dBaseProg->CommitTrans();
			}
			catch(CDBException *expt)
			{
				pApp->dBaseProg->Rollback();
				CString sError = expt->m_strError+sSQL;
				expt->Delete();
				AfxMessageBox(sError);
			}
		break;

	case 1:	
		


		break;
	}
	LoadInvDocData();

}
void CNav_Scaner_InterfaceDlg::OnLbnSelchangeListDocs()
{
	/*
	
	if(lDoc < 0)
		return;

	
	*/
	int lDoc;
	lDoc = m_ListDocs.GetCurSel();
	if(lDoc > -1)
	{
		lDoc = m_ListDocs.GetItemData(lDoc);
		if(lDoc >0)
			LoadTreeTask(lDoc);
	}
	LoadInvDocData();
}

void CNav_Scaner_InterfaceDlg::LoadTreeTask(long lDoc)
{
	m_TreeAsk.DeleteAllItems();
	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	if(pApp->dBaseProg == NULL)
		return;

	CString sSQL;
	try
	{
		sSQL.Format(_T("SELECT  [ID_ZONE],[CELL],[ID_USER] FROM [Inventary Doc Tasc] where [ID_DOC] = %d"),lDoc);
		CBulkRecordset Query_Prog(pApp->dBaseProg);
		Query_Prog.SetRowsetSize(500);

		Query_Prog.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly|CRecordset::useMultiRowFetch);
		int rowsFetched;
		CString sValue;
		HTREEITEM hItem,hItemLevel1,hItemGlobal;
		hItemGlobal = NULL;
		hItem = NULL;
		hItemLevel1 = NULL;
		
		CDBVariant dbValue;
		CString sOldLevel1,sOldLevel2;
		sOldLevel1 = "";
		int rowCount;
		sOldLevel2 = "";

		hItemGlobal = m_TreeAsk.InsertItem(_T("ВСЕ"),NULL,NULL);
		while(!Query_Prog.IsEOF())
		{
			rowsFetched = (int)Query_Prog.GetRowsFetched();
			for(rowCount = 0; rowCount < rowsFetched; rowCount++ )
			{	
				//Query_Prog.GetValue(rowCount,0));

				
				sValue = Query_Prog.GetValue(rowCount,0);
				if(sOldLevel1 != sValue)
				{
					sOldLevel1 = sValue;
					hItemLevel1 = m_TreeAsk.InsertItem(sOldLevel1,hItemGlobal,NULL);
				}

				sValue = Query_Prog.GetValue(rowCount,1);
				if(sOldLevel2 != sValue)
				{
					sOldLevel2 = sValue;
					m_TreeAsk.InsertItem(sOldLevel2,hItemLevel1,NULL);
				}
			}
			Query_Prog.MoveNext();
		}

		Query_Prog.Close();

		if(m_TreeAsk.GetChildItem(hItemGlobal)==NULL)
		{
			m_TreeAsk.DeleteItem(hItemGlobal);
		}

	}
	catch(CDBException * Except)
	{
		CString sError;
		sError.Format(_T("%s %s"),Except->m_strError, sSQL);
		Except->Delete();
		AfxMessageBox(sError);
	}
}

void CNav_Scaner_InterfaceDlg::LoadInvDocData(void)
{
	//
	

	GridLog.SetRowCount(1);
	GridPosition.SetRowCount(1);
	int lDoc;
	lDoc = m_ListDocs.GetCurSel();
	if(lDoc < 0)
		return;

	lDoc = m_ListDocs.GetItemData(lDoc);

	if(lDoc < 1)
		return;

	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	if(pApp->dBaseProg == NULL)
		return;

	CString sTreeFiler;
	HTREEITEM hTree;
	hTree = NULL;
	sTreeFiler = "";
	if(m_TreeAsk.GetCount()>0)
	{
		hTree = m_TreeAsk.GetSelectedItem();
		if(hTree == NULL)
		{
			return;
		}

		if(m_TreeAsk.GetParentItem(hTree) != NULL)
		{
			if(m_TreeAsk.GetChildItem(hTree) != NULL)
			{
				sTreeFiler.Format(_T(" and idl.[ID_ZONE] = '%s' "),m_TreeAsk.GetItemText(hTree));
			}
			else
				sTreeFiler.Format(_T(" and idl.[Cell] = '%s' "),m_TreeAsk.GetItemText(hTree));
		}
	}

	
	CString sSQL;
	try
	{
		int iField;
		CBulkRecordset Query_Prog(pApp->dBaseProg);
		Query_Prog.SetRowsetSize(1000);
		
		CDBVariant dbValue;
		
		CString sFilter;

		sFilter = GetFilterString();
		if(sFilter.GetLength()>0)
			sFilter = _T(" and ") + sFilter;
		sFilter = sTreeFiler +sFilter;
		iField = 0;

		
		GridPosition.SetCanDraw(FALSE);
		GridPosition.SetRowCount(1);

		//sSQL.Format(_T("select top 10 [Line_ID],[No_ 2],[Manufacturer Code],[Quantity in Individual Package],[Description],[Sales Unit of Measure],idl.[Count],idl.[Test_Count],[No_],[Cell],[ID_ZONE] from [Inventary Doc Line] as idl left join [Items] as it on it.[No_] =  idl.Item where idl.[Doc_ID] = %d %s order by [No_ 2]"),lDoc,sFilter);
		sSQL.Format(_T("select idl.[Line_ID],[No_ 2],[Manufacturer Code],[Quantity in Individual Package],[Description],[Sales Unit of Measure],idl.[Count],idl.[Test_Count],[No_],task.[Cell],task.[ID_ZONE],coalesce(task.ID_USER, lo.[User]) from [Inventary Doc Line] as idl left join [Items] as it on it.[No_] =  idl.Item left join [Inventary Doc Tasc] as task on task.ID_DOC = idl.Doc_ID and task.[ID_ZONE] = idl.[ID_ZONE] and task.CELL = idl.CELL left join [Inventary Log] as lo on   lo.Doc_id = idl.Doc_ID and idl.[Line_ID] = lo.[Line_ID] and Test_id = 1 where idl.[Doc_ID] = %d %s  order by [No_ 2]"),lDoc,sFilter);
			Query_Prog.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly|CRecordset::useMultiRowFetch);

		int iItem;
		int rowsFetched;
		iItem = 1;
		int rowCount;
		
		CString sValue;
		
		while(!Query_Prog.IsEOF())
		{
			rowsFetched = (int)Query_Prog.GetRowsFetched();
			GridPosition.SetRowCount(GridPosition.GetRowCount()+rowsFetched);
			for(rowCount = 0; rowCount < rowsFetched; rowCount++ )
			{	
				GridPosition.SetItemData(iItem,0, _wtoi(Query_Prog.GetValue(rowCount,0)));
				GridPosition.SetItemText(iItem,1, Query_Prog.GetValue(rowCount,1));
				GridPosition.SetItemText(iItem,2, Query_Prog.GetValue(rowCount,2));
				GridPosition.SetItemText(iItem,3, Query_Prog.GetValue(rowCount,3));
				GridPosition.SetItemText(iItem,4, Query_Prog.GetValue(rowCount,4));
				GridPosition.SetItemText(iItem,5, Query_Prog.GetValue(rowCount,5));
				GridPosition.SetItemText(iItem,6, Query_Prog.GetValue(rowCount,6));
				GridPosition.SetItemText(iItem,7, Query_Prog.GetValue(rowCount,7));
				GridPosition.SetItemText(iItem,8, Query_Prog.GetValue(rowCount,8));
				GridPosition.SetItemText(iItem,9, Query_Prog.GetValue(rowCount,9));
				GridPosition.SetItemText(iItem,10, Query_Prog.GetValue(rowCount,10));
				GridPosition.SetItemText(iItem,11, Query_Prog.GetValue(rowCount,11));
				iItem++;
			}
			Query_Prog.MoveNext();
		}

		Query_Prog.Close();
		GridPosition.SetCanDraw(TRUE);
		
	}
	catch(CDBException *expt)
	{
		CString sError;
		sError.Format(_T("%s %s %s"),expt->m_strError,sSQL,pApp->dBaseProg->sSQL);
		GridPosition.SetCanDraw(TRUE);
		expt->Delete();
		AfxMessageBox(sError);
	}

}

void CNav_Scaner_InterfaceDlg::OnCancel()
{
	if(dwThreadID > 0)
	{
		if(AfxMessageBox(_T("Выполняеться обновление. Прервать?"),MB_YESNO,IDNO) == IDNO)
		{
			return;
		}
		bTerminate = TRUE;
		return;
	}

	CDialog::OnCancel();
}

void CNav_Scaner_InterfaceDlg::OnSelectedPos(NMHDR* pNMHDR, LRESULT* pResult)
{
	NM_GRIDVIEW * nm_Grid; 
	nm_Grid = (NM_GRIDVIEW *)pNMHDR;
	
	CString sPos;
	sPos = "";
	if(nm_Grid->iRow > 0)
	{
		sPos.Format(_T("%d"), GridPosition.GetItemData(nm_Grid->iRow,0));
	}

	if(sPos.GetLength()<1)
		return;
	GridLog.SetRowCount(1);
	
	int lDoc;
	lDoc = m_ListDocs.GetCurSel();
	if(lDoc < 0)
		return;

	lDoc = m_ListDocs.GetItemData(lDoc);

	if(lDoc < 1)
		return;
	
	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	if(pApp->dBaseProg == NULL)
		return;

	CString sSQL;
	try
	{
		CBulkRecordset Query_Prog(pApp->dBaseProg);
		Query_Prog.SetRowsetSize(50);
	
		int iField;
		iField = 0;
		GridPosition.SetCanDraw(FALSE);
		
		/*
		,[Line_id]
      ,[Test_id]
		*/


		sSQL.Format(_T("SELECT [Line_id],[Test_id],[Type],[Date],Cell,[Count],[User]  FROM [WMS].[dbo].[Inventary Log]  where [Doc_id] = %d  and [Line_id] = %s  order by Test_id"),lDoc,sPos);
		Query_Prog.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly|CRecordset::useMultiRowFetch);

		int iItem;
		int rowsFetched;
		iItem = 1;
		int rowCount;
		
		
		CString sValue;
		
		while(!Query_Prog.IsEOF())
		{
			GridLog.SetRowCount(iItem+1);
			rowsFetched = (int)Query_Prog.GetRowsFetched();
			for(rowCount = 0; rowCount < rowsFetched; rowCount++ )
			{	

				GridLog.SetItemData(iItem,0, _wtoi(Query_Prog.GetValue(rowCount,0)));
				GridLog.SetItemData(iItem,1, _wtoi(Query_Prog.GetValue(rowCount,1)));
				GridLog.SetItemImage(iItem, 0,_wtoi(Query_Prog.GetValue(rowCount,2)));
				GridLog.SetItemText(iItem,1, Query_Prog.GetValue(rowCount,3));
				GridLog.SetItemText(iItem,2, Query_Prog.GetValue(rowCount,4));
				GridLog.SetItemText(iItem,3, Query_Prog.GetValue(rowCount,5));
				GridLog.SetItemText(iItem,4, Query_Prog.GetValue(rowCount,6));
				
				iItem++;
			}

			Query_Prog.MoveNext();
		}

		Query_Prog.Close();
		GridPosition.SetCanDraw(TRUE);
	}
	catch(CDBException *expt)
	{
		CString sError;
		sError.Format(_T("%s %s"),expt->m_strError, sSQL);
		GridPosition.SetCanDraw(TRUE);
		expt->Delete();
		AfxMessageBox(sError);
	}

}
void CNav_Scaner_InterfaceDlg::OnSize(UINT nType, int cx, int cy)
{
	CDialog::OnSize(nType, cx, cy);
	Resize();
}

void CNav_Scaner_InterfaceDlg::Resize(void)
{
	if(GridPosition.m_hWnd == NULL)
		return;

	CRect rec, recnew;
	GetClientRect(rec);

	recnew = rec;
	
	recnew.left = 10;
	recnew.right = 200;
	recnew.top = 10;
	recnew.bottom = 25;
	m_stLocation.MoveWindow(recnew);

	recnew.top = 25;
	recnew.bottom = 200;

	m_ComboLocation.MoveWindow(recnew);

	recnew.top = 50;
	recnew.bottom = 65;
	m_StGroup.MoveWindow(recnew);

	recnew.top = 65;
	recnew.bottom = 200;

	CRect bt;
	bt = recnew;

	bt.right = bt.right - 25;
	m_ComboGroup.MoveWindow(bt);

	
	

	bt.left = bt.right+5;
	bt.right = bt.left+20;
	bt.bottom=bt.top + 20;
	m_BtEditGroup.MoveWindow(bt);

	recnew.top = 85;
	recnew.bottom = 100;

	m_stDocs.MoveWindow(recnew);

	

	recnew.top = 100;
	recnew.bottom = rec.bottom/2 - 10;

	m_ListDocs.MoveWindow(recnew);

	recnew.top = rec.bottom/2;
	recnew.bottom = recnew.top + 20;

	m_stTask.MoveWindow(recnew);

	recnew.top = recnew.bottom;
	recnew.bottom = rec.bottom - 10;

	m_TreeAsk.MoveWindow(recnew);






	recnew = rec;

	recnew.top = 40;
	recnew.left = 310;
	recnew.right = recnew.left+200;
	m_ComboFilterField.MoveWindow(recnew);

	recnew.left = recnew.right+5;
	recnew.right = recnew.left+200;
	m_ComboFilterOperation.MoveWindow(recnew);

	recnew.left = recnew.right+5;
	recnew.right = recnew.left+200;
	recnew.bottom = recnew.top +20;
	m_EdFilterValue.MoveWindow(recnew);

	recnew.left = recnew.right+5;
	recnew.right = recnew.left+70;
	m_btFilter.MoveWindow(recnew);

	recnew.left = recnew.right+5;
	recnew.right = recnew.left+140;
	m_btDistinOnly.MoveWindow(recnew);
	recnew = rec;

	recnew.left = 210;
	recnew.top = 80;
	recnew.right = rec.right-10;
	recnew.bottom = rec.bottom/2;
	GridPosition.MoveWindow(recnew);
	
	recnew.top  = recnew.bottom +10;
	recnew.bottom  = rec.bottom - 10;

	GridLog.MoveWindow(recnew);

}

CString CNav_Scaner_InterfaceDlg::GetFilterString(void)
{
	CString sRet;
	sRet = "";

	m_EdFilterValue.GetWindowTextW(sRet);
	sRet.Replace(_T("'"),_T("''"));
	if(sRet.GetLength()>0)
	{
		switch(m_ComboFilterOperation.GetCurSel())
		{
		case 0:
			sRet = _T(" = '")+sRet+_T("'");
			break;

		case 1:
			sRet = _T(" like '%")+sRet+_T("%'");
			break;
		}

		switch(m_ComboFilterField.GetCurSel())
		{
		case 0:
			sRet = _T("[No_ 2]")+sRet;
			break;

		case 1:
			sRet = _T("[Manufacturer Code]")+sRet;
			break;

		case 2:
			sRet = _T("[No_]")+sRet;
			break;
		}
	}

	if(m_btDistinOnly.GetCheck())
	{
		if(sRet.GetLength()>0)
		{
			sRet = sRet + _T(" and idl.[Count] <> idl.[Test_Count]");
		}
		else
			sRet = _T("idl.[Count] <> idl.[Test_Count]");
	}
	return sRet;
}

void CNav_Scaner_InterfaceDlg::OnBnClickedButtonFilter()
{
	LoadInvDocData();
}

void CNav_Scaner_InterfaceDlg::OnTvnSelchangedTreeTask(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMTREEVIEW pNMTreeView = reinterpret_cast<LPNMTREEVIEW>(pNMHDR);
	// TODO: Add your control notification handler code here
	*pResult = 0;
	LoadInvDocData();
}

void CNav_Scaner_InterfaceDlg::OnLbnDblclkListDocs()
{
	int iPos;
	iPos = m_ListDocs.GetCurSel();

	int lDoc;
	lDoc = m_ListDocs.GetCurSel();
	if(lDoc < 0)
		return;

	lDoc = m_ListDocs.GetItemData(lDoc);

	
	CDlgEditDoc dlg;
	dlg.lID = lDoc;
	if(dlg.DoModal() == IDOK)
	{
	
	}
	LoadInvDoc();
}

void CNav_Scaner_InterfaceDlg::OnBnClickedButtonEditGroup()
{
	CDLgEditGroup dialog;
	dialog.DoModal();
	LoadGroup();
}

void CNav_Scaner_InterfaceDlg::LoadGroup(void)
{
	CString sSQL;
	long lGroup = 0;
	try
	{
		CNav_Scaner_InterfaceApp *pApp;
		pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
		CRecordset Query_Prog(pApp->dBaseProg);
		CDBVariant dbValue;
		
		while(m_ComboGroup.GetCount())
			m_ComboGroup.DeleteString(0);

		sSQL.Format(_T("SELECT [Name],[ID] FROM [Group] order by [Name]"));
		Query_Prog.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
		int iPos;
		if(Query_Prog.IsEOF())
		{
			Query_Prog.Close();

			sSQL.Format(_T("INSERT INTO [Group] ([ID],[Name]) VALUES (0,'Активные')"));
			pApp->dBaseProg->ExecuteSQL(sSQL);

			sSQL.Format(_T("SELECT [Name],[ID] FROM [Group] order by [Name]"));
		Query_Prog.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
		
		}

		iPos = 0;
		int iField;
		while(!Query_Prog.IsEOF())
		{
			iField = 0;
			Query_Prog.GetFieldValue(iField, dbValue);
			m_ComboGroup.AddString(GetValue(&dbValue));
			

			iField++;
			Query_Prog.GetFieldValue(iField, dbValue);
			m_ComboGroup.SetItemData(iPos, _wtoi(GetValue(&dbValue)));
			if(lGroup == _wtoi(GetValue(&dbValue)))
			{
				m_ComboGroup.SetCurSel(iPos);
			}
			Query_Prog.MoveNext();
			iPos++;
			
		}
		Query_Prog.Close();




	}
	catch(CDBException * expt)
	{
		CString sError;
		sError.Format(_T("%s %s"),expt->m_strError,sSQL);
		AfxMessageBox(sError);
		return;
	}

	LoadInvDoc();
}

void CNav_Scaner_InterfaceDlg::OnCbnSelchangeComboGroup()
{
	LoadInvDoc();
}
