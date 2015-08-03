// Nav_ExportCustomsDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_ExportCustoms.h"
#include "Nav_ExportCustomsDlg.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CNav_ExportCustomsDlg dialog




CNav_ExportCustomsDlg::CNav_ExportCustomsDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CNav_ExportCustomsDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	SecondThread  = NULL;
}

void CNav_ExportCustomsDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_GTD_NUMBER, m_EdGTDNUMBER);
	DDX_Control(pDX, IDC_EDIT_START, m_StartDate);
	DDX_Control(pDX, IDC_EDIT_END, m_EndDate);
	DDX_Control(pDX, IDOK, m_BtOK);
	DDX_Control(pDX, IDC_STATIC_STATE, m_stState);
}

BEGIN_MESSAGE_MAP(CNav_ExportCustomsDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDOK, &CNav_ExportCustomsDlg::OnBnClickedOk)
END_MESSAGE_MAP()


// CNav_ExportCustomsDlg message handlers

BOOL CNav_ExportCustomsDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	// TODO: Add extra initialization here
	m_StartDate.setMask(_T("ЧЧ.ЧЧ.ЧЧЧЧ"));
	m_EndDate.setMask(_T("ЧЧ.ЧЧ.ЧЧЧЧ"));
	COleDateTime date;
	date = COleDateTime::GetCurrentTime();
	m_StartDate.SetWindowText(date.Format(_T("%d%m%Y")));
	m_EndDate.SetWindowText(date.Format(_T("%d%m%Y")));
	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CNav_ExportCustomsDlg::OnPaint()
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
HCURSOR CNav_ExportCustomsDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


void CNav_ExportCustomsDlg::OnBnClickedOk()
{
	CString sStart, sEnd;

	m_EndDate.GetWindowText(sEnd);
	m_StartDate.GetWindowText(sStart);

	COleDateTime datStart,datEnd, cDate;
	datStart.ParseDateTime(sStart);
	datEnd.ParseDateTime(sEnd);
	
	if((datStart.invalid != 1)
		||(datEnd.invalid !=1))
	{
		AfxMessageBox(_T("Введен не корректный интервал!"),0);
		return;
	}

	if(datStart>datEnd)
	{
		AfxMessageBox(_T("Введен не корректный интервал!"),0);
		return;
	}
	CString sGTD;
	m_EdGTDNUMBER.GetWindowText(sGTD);
	if(sGTD.GetLength()<2)
	{
		AfxMessageBox(_T("не указанна ГТД"));
		return;
	}
	m_BtOK.ShowWindow(0);
	CNav_ExportCustomsDlg *Dialog;
	Dialog = this;
	SecondThread = AfxBeginThread(ExportData, (void*)Dialog);
}

UINT CNav_ExportCustomsDlg::ExportData(LPVOID p)
{
	
	HRESULT hRes;
	Excel::_ApplicationPtr appExcel;
	hRes = appExcel.CreateInstance( _T("Excel.Application"));

	CNav_ExportCustomsDlg *Dialog;
	Dialog = (CNav_ExportCustomsDlg*)p;

	if(Dialog != NULL)
	{
		

		CString sStart, sEnd;
		Dialog->m_EndDate.GetWindowText(sEnd);
		Dialog->m_StartDate.GetWindowText(sStart);

		CString sGTD;
		Dialog->m_EdGTDNUMBER.GetWindowText(sGTD);
		COleDateTime datStart,datEnd, cDate;
		datStart.ParseDateTime(sStart);
		datEnd.ParseDateTime(sEnd);
	
		CString sConnect;
		CString sServer, sDatabase;
		sServer = sReadFromIni(_T("DB"),_T("SERVER"),_T("svbyminssq3"));
		//sWriteToIni(_T("DB"),_T("SERVER"),sServer);
		sDatabase = sReadFromIni(_T("DB"),_T("DATABASE"),_T("SHATE-M-8"));
		//sWriteToIni(_T("DB"),_T("DATABASE"),sDatabase);


		
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

		sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
		CDatabase* dBase;
		dBase = NULL;
		try
		{
			dBase = new(CDatabase);
			dBase->SetQueryTimeout(600);
			dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
			sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
			dBase->ExecuteSQL(sConnect);
		}
		catch(CDBException *exsept)
		{
			appExcel->Visible[0] = TRUE;
			Dialog->m_stState.SetWindowTextW(exsept->m_strError);
			exsept->Delete();
			if(dBase != NULL)
			{
				if(dBase->IsOpen())
				{
					dBase->Close();
				}
				delete(dBase);
			}
			dBase = NULL;
			Dialog->m_BtOK.ShowWindow(1);
			Dialog->SecondThread = NULL;
			return 0;
		}
		CString sSQL;
		try
		{
			

			CRecordset Query(dBase);
		
			int iField;
			CDBVariant dbValue;
			Dialog->m_stState.SetWindowTextW(_T("Формирование"));
			sGTD = sGTD + _T("'");
			sSQL = _T("select distinct SIH.[Posting Date],(SIL.[TTN Series]+SIL.[TTN Number]) AS TTN,SIL.[Item No_ 2], SIH.[Bill-to Name] ");
			sSQL = sSQL + _T(" from [")+sDatabase;
			sSQL = sSQL + _T("$Sales Invoice Header] as SIH join [");
			sSQL = sSQL + sDatabase;
			sSQL = sSQL + _T("$Sales Invoice Line] as SIL on SIL.[Document No_] = SIH.[No_] and SIL.[No_] is not null and SIL.[No_] <> ''  and SIL.[TTN Series] <> '' and SIL.[TTN Number] <> '' join [");
			sSQL = sSQL + sDatabase;
			sSQL = sSQL + _T("$Custom Declaration Relation] as CDR on CDR.[Item No_] = SIL.[No_] and CDR.[Document Type] = 5 and CDR.[CD No_] = '") + sGTD;
			sSQL = sSQL + _T(" where [Sales Process Type Code] = 'Б/Н_ДОСТАВКА' and Left(CONVERT ( nchar , SIH.[Posting Date], 112),8) >= '")+ datStart.Format(_T("%Y%m%d"))+_T("'");
			sSQL = sSQL + _T(" and Left(CONVERT ( nchar , SIH.[Posting Date], 112),8) <= '")+ datEnd.Format(_T("%Y%m%d"))+_T("'");
			//sSQL = sSQL + _T(" and CDR.[CD No_] = '") + sGTD;

			CString sDat;
			int iRow;
			iRow = 1;
			sDat = _T("Дата учета продажи");
			ExcelSheet->Cells->Item[iRow,2] = sDat.AllocSysString();
			sDat = _T("Номер ТТН, ТН");
			ExcelSheet->Cells->Item[iRow,3] = sDat.AllocSysString();
			sDat = _T("Код проданного товара (код товара2)");
			ExcelSheet->Cells->Item[iRow,4] = sDat.AllocSysString();
			sDat = _T("Клиент");
			ExcelSheet->Cells->Item[iRow,5] = sDat.AllocSysString();
	

			
			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				iRow++;
				
				if((iRow -2) % 100 == 0)
				{
					sSQL.Format(_T("Обработанно %d"),iRow-2);
					Dialog->m_stState.SetWindowTextW(sSQL);
				}
				iField = 0;
				Query.GetFieldValue(iField, dbValue);
				sDat = GetValue(&dbValue);
				ExcelSheet->Cells->Item[iRow,2] = sDat.AllocSysString();

				iField = 1;
				Query.GetFieldValue(iField, dbValue);
				sDat = GetValue(&dbValue);
				ExcelSheet->Cells->Item[iRow,3] = sDat.AllocSysString();

				iField = 2;
				Query.GetFieldValue(iField, dbValue);
				sDat = GetValue(&dbValue);
				ExcelSheet->Cells->Item[iRow,4] = sDat.AllocSysString();

				iField = 3;
				Query.GetFieldValue(iField, dbValue);
				sDat = GetValue(&dbValue);
				ExcelSheet->Cells->Item[iRow,5] = sDat.AllocSysString();

				Query.MoveNext();
			}
			Query.Close();

		}
		catch(CDBException *exsept)
		{
			/*appExcel->Visible[0] = TRUE;
			appExcel = NULL;*/
			appExcel->Visible[0] = TRUE;
			Dialog->m_stState.SetWindowTextW(exsept->m_strError);
			Dialog->m_EdError.SetWindowTextW(sSQL);
			
			exsept->Delete();
			if(dBase != NULL)
			{
				if(dBase->IsOpen())
				{
					dBase->Close();
				}
				delete(dBase);
			}
			Dialog->m_BtOK.ShowWindow(1);
			Dialog->SecondThread = NULL;
			dBase = NULL;

			return 0;
		}


		Dialog->m_stState.SetWindowTextW(_T("Выполненно"));
		Dialog->m_BtOK.ShowWindow(1);
	}
	appExcel->Visible[0] = TRUE;
	Dialog->SecondThread = NULL;
	return 1;
}
