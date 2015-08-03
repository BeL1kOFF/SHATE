// Nav_Buh_ExplDlg.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Buh_Expl.h"
#include "Nav_Buh_ExplDlg.h"
#include "DlgReport.h"



#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CNav_Buh_ExplDlg dialog

CNav_Buh_ExplDlg::CNav_Buh_ExplDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CNav_Buh_ExplDlg::IDD, pParent)
	, vAktNum(_T(""))
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CNav_Buh_ExplDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_FROM, m_edFrom);
	DDX_Control(pDX, IDC_EDIT_TO, m_edTo);
	DDX_Control(pDX, IDC_COMBO_TYPE, m_ComboType);
	//DDX_Control(pDX, IDC_STATIC_SELECT_GROUP, m_stSelCell);
	//DDX_Control(pDX, IDC_COMBO_CELSS, m_ComboSelCell);
	DDX_Control(pDX, IDCANCEL, m_btExit);
	DDX_Control(pDX, IDOK, m_btStart);
	DDX_Control(pDX, IDC_STATIC_TYPE, m_stType);
	DDX_Control(pDX, IDC_STATIC_TO, m_stFrom);
	DDX_Control(pDX, IDC_STATIC_FROM, m_stTo);
	DDX_Control(pDX, IDC_BUTTON_STOP, m_btTerninate);
	DDX_Control(pDX, IDC_STATIC_INFO, m_stInfo);
	DDX_Control(pDX, IDC_CHECK_NO_ZERO, m_btNoZero);
	DDX_Control(pDX, IDC_CHECK_PRINT_AKT, m_ButPrintAkt);
	DDX_Control(pDX, IDC_CHECK_WITH_UPD_SS, m_btWithUPRSS);
	DDX_Control(pDX, IDC_BUTTON_EDIT_REPORT, m_btEditReport);
	DDX_Control(pDX, IDC_CHECK_BUH, m_btBuhSS);
	DDX_Text(pDX, IDC_EDIT1, vAktNum);
	DDX_Control(pDX, IDC_EDIT1, edAktNum);
	DDX_Control(pDX, IDC_STATIC1, l_act);
}

BEGIN_MESSAGE_MAP(CNav_Buh_ExplDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDOK, &CNav_Buh_ExplDlg::OnBnClickedOk)
	ON_WM_HELPINFO()
	ON_BN_CLICKED(IDCANCEL, &CNav_Buh_ExplDlg::OnBnClickedCancel)
//	ON_CBN_SELCHANGE(IDC_COMBO_CELSS, &CNav_Buh_ExplDlg::OnCbnSelchangeComboCelss)
	ON_CBN_SELCHANGE(IDC_COMBO_TYPE, &CNav_Buh_ExplDlg::OnCbnSelchangeComboType)
	ON_BN_CLICKED(IDC_BUTTON_STOP, &CNav_Buh_ExplDlg::OnBnClickedButtonStop)
//	ON_BN_CLICKED(IDC_BUTTON1, &CNav_Buh_ExplDlg::OnBnClickedButton1)
ON_BN_CLICKED(IDC_BUTTON_EDIT_REPORT, &CNav_Buh_ExplDlg::OnBnClickedButtonEditReport)
END_MESSAGE_MAP()


// CNav_Buh_ExplDlg message handlers

BOOL CNav_Buh_ExplDlg::OnInitDialog()
{
	bTerminate = FALSE;
	
	bExit = FALSE;
	
	CDialog::OnInitDialog();
	
	LoadReports();

	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	m_edFrom.setMask(_T("ЧЧ.ЧЧ.ЧЧЧЧ"));
	COleDateTime date;
	date = COleDateTime::GetCurrentTime();
	m_edFrom.SetWindowText(date.Format(_T("%d%m%Y")));
	
	
	m_edTo.setMask(_T("ЧЧ.ЧЧ.ЧЧЧЧ"));
	m_edTo.SetWindowText(date.Format(_T("%d%m%Y")));

	int IsShowAct = _wtoi(sReadFromIni(_T("APPLICATION"), _T("USEACT"), _T("0")));
	if (IsShowAct == 1){
		l_act.ShowWindow(SW_SHOW);
		edAktNum.ShowWindow(SW_SHOW);
	}else{
		l_act.ShowWindow(SW_HIDE);
		edAktNum.ShowWindow(SW_HIDE);
	}

	m_btBuhSS.SetCheck(true);
	LoadCells();
	SetVisible(this, 0);

	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CNav_Buh_ExplDlg::OnPaint()
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
HCURSOR CNav_Buh_ExplDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


void CNav_Buh_ExplDlg::OnBnClickedOk()
{
	if((!m_btBuhSS.GetCheck())&&(!m_btWithUPRSS.GetCheck()))
	{
		AfxMessageBox(_T("Не выбрана ни одна себестоимость"));
		return;
	}
	CString sStart;
	CString sEnd;

	m_edTo.GetWindowText(sEnd);
	m_edFrom.GetWindowText(sStart);

	COleDateTime datStart,datEnd, cDate;
	datStart.ParseDateTime(sStart);
	datEnd.ParseDateTime(sEnd);
	
	sStart = datStart.Format(_T("%Y%m%d"));
	sEnd = datEnd.Format(_T("%Y%m%d"));

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

	DWORD dwThreadID;
	int iType = m_ComboType.GetCurSel();
	if(iType < 0)
		return;
	iType = m_ComboType.GetItemData(iType);
	if(iType < 0)
		return;
	
	CString sREPORT;
	
	sREPORT.Format(_T("REPORT_%d"),iType);
	iType = _wtoi(sReadFromIni(sREPORT,_T("TYPE"),_T("0")));
	if(((iType < 0)||(iType > 2))&&(iType!=10))
		return;

	switch(iType)
	{
		case 0:
			CreateThread(NULL, NULL, (LPTHREAD_START_ROUTINE)StartExport_CurrentQuants, (void*)this, NULL, &dwThreadID); 
			break;

		case 1:
			CreateThread(NULL, NULL, (LPTHREAD_START_ROUTINE)StartExport_All, (void*)this, NULL, &dwThreadID); 
			break;

		case 2:
			CreateThread(NULL, NULL, (LPTHREAD_START_ROUTINE)StartExport_Auto, (void*)this, NULL, &dwThreadID); 
			break;

		case 10:
			CreateThread(NULL, NULL, (LPTHREAD_START_ROUTINE)StartExport_Auto_AKT, (void*)this, NULL, &dwThreadID); 
			break;
		
		default :
			break;
	}


}


BOOL CNav_Buh_ExplDlg::OnHelpInfo(HELPINFO* pHelpInfo)
{
	return FALSE;
}

void CNav_Buh_ExplDlg::OnBnClickedCancel()
{
	// TODO: Add your control notification handler code here
	bExit = TRUE;
	OnCancel();
}

void CNav_Buh_ExplDlg::OnCancel()
{
	if(bExit)
	{
		CDialog::OnCancel();
	}
}

void CNav_Buh_ExplDlg::SetVisible(CNav_Buh_ExplDlg* dlg, int iType)
{
	if(dlg == NULL)
		return;
	
	if(iType == 0)
	{   dlg->m_ButPrintAkt.ShowWindow(1);
		dlg->m_btTerninate.ShowWindow(0);
		dlg->m_btExit.ShowWindow(1);
		dlg->m_btStart.ShowWindow(1);
		dlg->m_ComboType.ShowWindow(1);
		dlg->m_stType.ShowWindow(1);
		dlg->m_edTo.ShowWindow(1);
		dlg->m_edFrom.ShowWindow(1);
		dlg->m_stTo.ShowWindow(1);
		dlg->m_stFrom.ShowWindow(1);
		dlg->m_stInfo.ShowWindow(0);

		dlg->m_btNoZero.ShowWindow(1);
		dlg->m_btWithUPRSS.ShowWindow(1);
		dlg->m_btBuhSS.ShowWindow(1);

		dlg->m_btEditReport.ShowWindow(1);
		

		return;
	}

	if(iType == 1)
	{
		dlg->m_btEditReport.ShowWindow(0);
		dlg->m_ButPrintAkt.ShowWindow(0);
		dlg->m_stInfo.ShowWindow(1);
		dlg->m_btTerninate.ShowWindow(1);
		dlg->m_btExit.ShowWindow(0);
		dlg->m_btStart.ShowWindow(0);
		dlg->m_ComboType.ShowWindow(0);
		//dlg->m_ComboSelCell.ShowWindow(0);
		//dlg->m_stSelCell.ShowWindow(0);
		dlg->m_stType.ShowWindow(0);
		dlg->m_edTo.ShowWindow(0);
		dlg->m_edFrom.ShowWindow(0);
		dlg->m_stTo.ShowWindow(0);
		dlg->m_stFrom.ShowWindow(0);
		dlg->m_btNoZero.ShowWindow(0);
		dlg->m_btWithUPRSS.ShowWindow(0);
		dlg->m_btBuhSS.ShowWindow(0);
		return;
	}
}
void CNav_Buh_ExplDlg::OnCbnSelchangeComboCelss()
{
	// TODO: Add your control notification handler code here
}

void CNav_Buh_ExplDlg::OnCbnSelchangeComboType()
{
	SetVisible(this, 0);
}

CDatabase* CNav_Buh_ExplDlg::OpenDatabase(CString * sError)
{
	CDatabase* dBase;
	dBase = NULL;
	if(CloseDatabase(dBase,sError))
	{
		return false;	
	}

	dBase = new(CDatabase);
	CString sConnect;
	try
	{
		CString sServer,sDatabase,sUser;
		sServer = sReadFromIni(_T("DB"),_T("SERVER"),_T("SVBYMINSSQ3"));
		sWriteToIni(_T("DB"),_T("SERVER"),sServer);
		sDatabase = sReadFromIni(_T("DB"),_T("DB"),_T("Shate-M-8"));
		sWriteToIni(_T("DB"),_T("DB"),sDatabase);
		sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
		dBase->ExecuteSQL(sConnect);
		dBase->SetQueryTimeout(0);
		
	}
	catch(CDBException * error)
	{
		sError->Format(_T("%s\n%s"),error->m_strError,sConnect);
		error->Delete();
		dBase = CloseDatabase(dBase);
		return dBase;
	}
	return dBase;
}

CDatabase* CNav_Buh_ExplDlg::CloseDatabase(CDatabase* dBase,CString * sError)
{
	if(dBase == NULL)
	{
		return dBase;
	}

	try
	{
		if(dBase->IsOpen())
		{
			dBase->Close();
		}
	}
	catch(CDBException * ex)
	{
		if(sError!=NULL)
			sError->Format(_T("Error - %d - %s"),ex->m_nRetCode,ex->m_strError);
		ex->Delete();
		return dBase;
	}
	delete(dBase);
	dBase = NULL;
	return dBase;
}

bool CNav_Buh_ExplDlg::LoadCells(void)
{
/*	CDatabase* dBase;
	dBase = NULL;
	while(m_ComboSelCell.GetCount()>0)
	{
		m_ComboSelCell.DeleteItem(0);
	}
	CString sWareHouse, sFirm;
	sWareHouse = sReadFromIni(_T("DB"),_T("WAREHOUSE"),_T("WRITE_OFF"));
	sWriteToIni(_T("DB"),_T("WAREHOUSE"),sWareHouse);
	sFirm = sReadFromIni(_T("DB"),_T("FIRM"),_T("Shate-M"));
	sWriteToIni(_T("DB"),_T("FIRM"),sFirm);

	CString sError;
	if((dBase = OpenDatabase(&sError))==NULL)
	{
		AfxMessageBox(sError);
		return false;
	}

	CString sSQL;
	try
	{
		CDBVariant dbValue;
		sSQL.Format(_T("select [Code] from [%s$Bin] where [Location Code] = 'WRITE_OFF' order by [Code]"),sFirm,sWareHouse);
		CRecordset Query(dBase);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		int i;
		i=0;
		while(!Query.IsEOF())
		{
			Query.GetFieldValue(i, dbValue);
			m_ComboSelCell.AddString(GetValue(&dbValue));
			Query.MoveNext();
		}
		Query.Close();
		if(m_ComboSelCell.GetCount()>0)
			m_ComboSelCell.SetCurSel(0);
	}
	catch(CDBException * ex)
	{
		sError.Format(_T("Error - %d - %s\n%s"),ex->m_nRetCode,ex->m_strError,sSQL);
		ex->Delete();
		CloseDatabase(dBase);
		AfxMessageBox(sError);
		return false;
	}
	CloseDatabase(dBase);*/
	return true;
}
/**/
void CNav_Buh_ExplDlg::CreateExcelAkt(DWORD someparam,CItem * Items, CString sDocNumber, CString sDate)
{
	CNav_Buh_ExplDlg * Dlg;
	Dlg = (CNav_Buh_ExplDlg*)someparam;
	if(Dlg == NULL)	
	{
		return;
	}

	if(Items == NULL)
		return;

	Excel::_ApplicationPtr appExcel;
	Excel::WorkbooksPtr ExcelBooks;
	Excel::_WorkbookPtr ExcelBook;
	Excel::_WorksheetPtr ExcelSheet;
	Excel::RangePtr range;
	Excel::HPageBreaksPtr page_breaks;
	Excel::HPageBreakPtr pagebreak;
	Excel::BordersPtr borders;

	HRESULT hRes;
	hRes = appExcel.CreateInstance( _T("Excel.Application"));
	
	Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
	VARIANT bTRUE;
	bTRUE.vt = 11;
	bTRUE.boolVal = TRUE;
	appExcel->Visible[0] = FALSE;
	appExcel->DisplayAlerts[0] = FALSE;
	
	int i;
	stItem *Item;
	//Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
	int iCount;
	iCount = Items->GetCount();
	
	
	
	CStringArray sa;
	CString sVal;
	
	int iList;

	Excel::_WorkbookPtr ExcelBookAkt;
	Excel::_WorksheetPtr ExcelSheetAkt;


	CString sAktSh;
	CString sAktFileName;
	sAktSh = sReadFromIni(_T("EXCEL"),_T("AKT_FILE"),_T(""));
	
	if(sAktSh.Find(_T("\\"),0)<0)
	{
		sAktSh = GetPath()+sAktSh;
	}
	sAktFileName = sReadFromIni(_T("EXCEL"),_T("AKT_LIST"),_T(""));
	if((sAktSh.GetLength()>0)&&(sAktFileName.GetLength()>0))		
	{
		ExcelBookAkt = appExcel->Workbooks->Open(sAktSh.AllocSysString());
		iList = 1;
			
		CString sName;
		while(iList < ExcelBookAkt->Worksheets->Count+1)
		{
			ExcelSheetAkt = ExcelBookAkt->Worksheets->Item[iList];
			sName.Format(_T("%s"), ExcelSheetAkt->Name.GetBSTR());
			if(sName == sAktFileName.AllocSysString())
			{
				break;
			}
			iList++;
		}

		if(iList > ExcelBookAkt->Worksheets->Count)
		{
			appExcel->Visible[0] = TRUE;
			return;
		}
	}
	else
	{
		appExcel->Visible[0] = TRUE;
		return;
	}
		ExcelBook = appExcel->Workbooks->Add();
		
		
		while (ExcelBook->Worksheets->Count > 1){
			((Excel::_WorksheetPtr)ExcelBook->Worksheets->Item[1])->Delete();
		}
		

		
			int iString;
			iString = _wtoi(sReadFromIni(_T("EXCEL"),_T("AKT_STRING"),_T("0")));

			_variant_t var;
			ExcelSheet = ExcelBook->Worksheets->Item[1];
			var = (IDispatch*)ExcelSheet;
			ExcelSheetAkt->Copy(vtMissing, var);
			ExcelBookAkt->Close();

			CString sName;
			iList = 1;
			
			while(iList < ExcelBook->Worksheets->Count+1)
			{
				ExcelSheetAkt = ExcelBook->Worksheets->Item[iList];
				sName.Format(_T("%s"), ExcelSheetAkt->Name.GetBSTR());
				if(sName == sAktFileName.AllocSysString())
				{
					break;
				}
				else
				{
					ExcelSheetAkt->Delete();
				}
				
			}

			Excel::RangePtr CurrRange;
			CurrRange = ExcelSheetAkt->UsedRange;


			int iMinCol,iMinRow,iMaxCol, iMaxRow;
			
			iMinRow = CurrRange->Row;
			iMinCol = CurrRange->Column;
			iMaxCol = iMinCol + CurrRange->Columns->Count;
			iMaxRow= iMinRow + CurrRange->Rows->Count;

			Excel::RangePtr RangeStr;
			
			CString sFormula;
			sFormula.Format(_T("%d"),iString);

			int iRowCount;
			iRowCount = _wtoi(sReadFromIni(_T("EXCEL"),_T("AKT_LINE_COUNT"),_T("30")));
			int iRowWidth;
			for(i=0;i<iCount;i++)
			{
				if(Dlg->bTerminate)
				{
					break;
				}
		
				if(i%100 == 0)
				{
					sVal.Format(_T("Формирование Excel (%d / %d)"),i,iCount);
					Dlg->m_stInfo.SetWindowTextW(sVal);
				}	

				Item = Items->GetItem(i);
				if(Item != NULL)
				{

					RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iString, iMinCol],ExcelSheetAkt->Cells->Item[iString, iMaxCol]];
					
					if(i>0)
					{
						RangeStr->Insert(Excel::xlShiftDown,FALSE);
					}
					else
					{
						iRowWidth = RangeStr->GetRowHeight();
					}

					CString sName;
					sName = Item->szCode;
					if(sName.Find(_T("\t"),0)>-1)
					{
						sName = sName.Left(sName.Find(_T("\t"),0));
					}
					sName =sName+ _T(" ")+Item->szDesc;
					ExcelSheetAkt->Cells->Item[iString, 2] = sName.AllocSysString();
					ExcelSheetAkt->Cells->Item[iString, 3] = _T("796");
					ExcelSheetAkt->Cells->Item[iString, 4] = _T("шт.");
					ExcelSheetAkt->Cells->Item[iString, 5] = Item->iQuant;
					ExcelSheetAkt->Cells->Item[iString, 6] = Item->dS/Item->iQuant;
					ExcelSheetAkt->Cells->Item[iString, 7] = Item->dS;
					ExcelSheetAkt->Cells->Item[iString, 10] = Item->sSupplier.AllocSysString();
					RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iString, iMinCol],ExcelSheetAkt->Cells->Item[iString, iMaxCol-1]];
					RangeStr->RowHeight =iRowWidth ;
				
					borders = RangeStr->GetBorders();
					borders->PutLineStyle(Excel::xlContinuous);
					borders->PutWeight(Excel::xlThin);
					borders->PutColorIndex(Excel::xlAutomatic);
					iString++;

					/*if(iString % iRowCount == 0)
					{
						RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iString, iMinCol],ExcelSheetAkt->Cells->Item[iString, iMaxCol]];
						
						RangeStr->Insert(Excel::xlShiftDown,FALSE);
						RangeStr->Insert(Excel::xlShiftDown,FALSE);
						RangeStr->Insert(Excel::xlShiftDown,FALSE);
						RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iString, iMinCol],ExcelSheetAkt->Cells->Item[iString, iMaxCol]];
						RangeStr->PageBreak = TRUE;

						int iRow;
						iRow = _wtoi(sReadFromIni(_T("EXCEL"),_T("AKT_STRING"),_T("0")));
						RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iRow-3, iMinCol],ExcelSheetAkt->Cells->Item[iRow-1, iMaxCol]];
						RangeStr->Copy();

						RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iString, iMinCol],ExcelSheetAkt->Cells->Item[iString+3, iMaxCol]];
						RangeStr->Select();
						ExcelSheetAkt->Paste();

						iString = iString+3;

					}*/
				}
			}

			ExcelSheetAkt->Cells->Item[_wtoi(sReadFromIni(_T("EXCEL"),_T("AKT_NUM_STR"),_T("1"))), _wtoi(sReadFromIni(_T("EXCEL"),_T("AKT_NUM_COL"),_T("1")))] = sDocNumber.AllocSysString();
			ExcelSheetAkt->Cells->Item[_wtoi(sReadFromIni(_T("EXCEL"),_T("AKT_DATE_STR"),_T("1"))), _wtoi(sReadFromIni(_T("EXCEL"),_T("AKT_DATE_COL"),_T("1")))] = sDate.AllocSysString();

			//RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iString, iMinCol],ExcelSheetAkt->Cells->Item[iString, iMaxCol]];
			//RangeStr->Delete(Excel::xlShiftUp);
			

			sVal.Format(_T("=SUM(G%s:G%d)"),sFormula,iString-1);
			range = ExcelSheetAkt->Cells->Item[iString,7];
			range->PutFormula(sVal.AllocSysString());

			sVal.Format(_T("=SUM(E%s:E%d)"),sFormula,iString-1);
			range = ExcelSheetAkt->Cells->Item[iString,5];
			range->PutFormula(sVal.AllocSysString());
			//ExcelSheetAkt->Cells->Item[iString, 7] = sFormula.AllocSysString();
			
			range = ExcelSheetAkt->Cells->Item[iString, 7];
			var = range->Value2;

			ExcelSheetAkt->Cells->Item[iString+2, 2] =GetSummPropis(int(var.dblVal)).AllocSysString();

			
			
			
			
			/*int iRow;
			iRow = _wtoi(sReadFromIni(_T("EXCEL"),_T("AKT_STRING"),_T("0")));
			appExcel->Visible[0] = TRUE;
			while(iRow < iString)
			{
				RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iRow, iMinCol],ExcelSheetAkt->Cells->Item[iRow, iMaxCol]];
				
				//RangeStr->PageBreak = TRUE;
				if(RangeStr->PageBreak)
				{
					CString sVal;
					sVal.Format(_T("%d"),iRow);
					AfxMessageBox(sVal);
					
				}
			
				iRow++;
			}
			
			
			/*RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iRow-3, iMinCol],ExcelSheetAkt->Cells->Item[iRow-1, iMaxCol]];
			RangeStr->Copy();
			

			/*iCount = 1;
			ExcelSheetAkt->ResetAllPageBreaks();
			page_breaks = ExcelSheetAkt->HPageBreaks;
			appExcel->Visible[0] = TRUE;
			
			iCount = page_breaks->GetCount();
			int iPos;
			iPos = 1;
			while(iPos < iCount )
			{
				
				pagebreak = page_breaks->Get_NewEnum();
				iPos++;
				
				/*iRow = pagebreak->Location->Row;
				//RangeStr->Insert(
				
				if(iCount>0)
				{
					//Excel::xlShiftDown
					RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iRow, iMinCol],ExcelSheetAkt->Cells->Item[iRow, iMaxCol]];
					RangeStr->Select();
					ExcelSheetAkt->Paste();
				}
				
				//RangeStr->Insert(Excel::xlShiftDown,FALSE);


				
				page_breaks = ExcelSheetAkt->HPageBreaks;
				//iCount++;

				ExcelSheetAkt->ResetAllPageBreaks();
				page_breaks = ExcelSheetAkt->HPageBreaks;
				iCount = page_breaks->GetCount();
			}
			
	*/



		CString sTRFileName;
		sAktSh = sReadFromIni(_T("EXCEL"),_T("TR_FILE"),_T(""));
		if(sAktSh.Find(_T("\\"),0)<0)
		{
			sAktSh = GetPath()+sAktSh;
		}
		sTRFileName = sReadFromIni(_T("EXCEL"),_T("TR_LIST"),_T(""));
		
		if((sAktSh.GetLength()>0)&&(sTRFileName.GetLength()>0))		
		{
			ExcelBookAkt = appExcel->Workbooks->Open(sAktSh.AllocSysString());
			
			iList = 1;
			
			CString sName;
			while(iList < ExcelBookAkt->Worksheets->Count+1)
			{
				ExcelSheetAkt = ExcelBookAkt->Worksheets->Item[iList];
				sName.Format(_T("%s"), ExcelSheetAkt->Name.GetBSTR());
				if(sName == sTRFileName.AllocSysString())
				{
					break;
				}
				iList++;
			}

			if(iList > ExcelBookAkt->Worksheets->Count)
			{
				appExcel->Visible[0] = TRUE;
				return;
			}
			


		}
		else
		{
			appExcel->Visible[0] = TRUE;
			return;
		}
		
		
			iString = _wtoi(sReadFromIni(_T("EXCEL"),_T("TR_STRING"),_T("0")));

			
			ExcelSheet = ExcelBook->Worksheets->Item[1];
			var = (IDispatch*)ExcelSheet;
			ExcelSheetAkt->Copy(vtMissing, var);
			ExcelBookAkt->Close();

			
			iList = 1;
			while(iList < ExcelBook->Worksheets->Count+1)
			{
				ExcelSheetAkt = ExcelBook->Worksheets->Item[iList];
				sName.Format(_T("%s"), ExcelSheetAkt->Name.GetBSTR());
				if(sName == sTRFileName.AllocSysString())
				{
					break;
				}
				iList++;
			}

			if(iList > ExcelBook->Worksheets->Count)
			{
				appExcel->Visible[0] = TRUE;
				return;
			}
			
			CurrRange = ExcelSheetAkt->UsedRange;


			
			
			iMinRow = CurrRange->Row;
			iMinCol = CurrRange->Column;
			iMaxCol = iMinCol + CurrRange->Columns->Count;
			iMaxRow= iMinRow + CurrRange->Rows->Count;

			
			
			
			sFormula.Format(_T("=SUM(G%d:"),iString);

			iRowCount = _wtoi(sReadFromIni(_T("EXCEL"),_T("TR_LINE_COUNT"),_T("30")));
			for(i=0;i<iCount;i++)
			{
				if(Dlg->bTerminate)
				{
					break;
				}
		
				if(i%100 == 0)
				{
					sVal.Format(_T("Формирование Excel (%d / %d)"),i,iCount);
					Dlg->m_stInfo.SetWindowTextW(sVal);
				}	

				Item = Items->GetItem(i);
				if(Item != NULL)
				{

					RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iString, iMinCol],ExcelSheetAkt->Cells->Item[iString, iMaxCol]];
					if(i>0)
						RangeStr->Insert(Excel::xlShiftDown,FALSE);
					else
						iRowWidth = RangeStr->GetRowHeight();
					CString sName;
					sName = Item->szCode;
					if(sName.Find(_T("\t"),0)>-1)
					{
						sName = sName.Left(sName.Find(_T("\t"),0));
					}
					sName =sName+ _T(" ")+Item->szDesc;
					RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iString, 3],ExcelSheetAkt->Cells->Item[iString, 5]];
					RangeStr->Merge();
					ExcelSheetAkt->Cells->Item[iString, 3] = sName.AllocSysString();
					sName.Format(_T("44.1.1"));

					ExcelSheetAkt->Cells->Item[iString, 1] = sName.AllocSysString();
					ExcelSheetAkt->Cells->Item[iString, 6] = _T("796");
					ExcelSheetAkt->Cells->Item[iString, 7] = _T("шт.");
					ExcelSheetAkt->Cells->Item[iString, 8] = Item->iQuant;
					ExcelSheetAkt->Cells->Item[iString, 9] = Item->iQuant;
					ExcelSheetAkt->Cells->Item[iString, 10] = Item->dS/Item->iQuant;
					ExcelSheetAkt->Cells->Item[iString, 11] = Item->dS;
					RangeStr->RowHeight =iRowWidth ;
					iString++;

					/*if(iString % iRowCount == 0)
					{
						RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iString, iMinCol],ExcelSheetAkt->Cells->Item[iString, iMaxCol]];
						
						RangeStr->Insert(Excel::xlShiftDown,FALSE);
						RangeStr->Insert(Excel::xlShiftDown,FALSE);
						RangeStr->Insert(Excel::xlShiftDown,FALSE);
						RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iString, iMinCol],ExcelSheetAkt->Cells->Item[iString, iMaxCol]];
						RangeStr->PageBreak = TRUE;

						

						int iRow;
						iRow = _wtoi(sReadFromIni(_T("EXCEL"),_T("TR_STRING"),_T("0")));
						RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iRow-3, iMinCol],ExcelSheetAkt->Cells->Item[iRow-1, iMaxCol]];
						RangeStr->Copy();

						RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iString, iMinCol],ExcelSheetAkt->Cells->Item[iString+3, iMaxCol]];
						RangeStr->Select();
						ExcelSheetAkt->Paste();

						iString = iString+3;

					}*/
				}
			}

			
			RangeStr = ExcelSheetAkt->Range[ExcelSheetAkt->Cells->Item[iString, iMinCol],ExcelSheetAkt->Cells->Item[iString, iMaxCol]];
			RangeStr->Delete(Excel::xlShiftUp);
			

			/*sVal.Format(_T("G%d)"),iString-1);
			sFormula = sFormula+sVal;
			range = ExcelSheetAkt->Cells->Item[iString,7];
			range->PutFormula(sFormula.AllocSysString());*/
			//ExcelSheetAkt->Cells->Item[iString, 7] = sFormula.AllocSysString();
			ExcelSheetAkt->Cells->Item[_wtoi(sReadFromIni(_T("EXCEL"),_T("TR_NUM_STR"),_T("1"))), _wtoi(sReadFromIni(_T("EXCEL"),_T("TR_NUM_COL"),_T("1")))] = sDocNumber.AllocSysString();
			//ExcelSheetAkt->Cells->Item[_wtoi(sReadFromIni(_T("EXCEL"),_T("TR_DATE_STR"),_T("1"))), _wtoi(sReadFromIni(_T("EXCEL"),_T("TR_DATE_COL"),_T("1")))] = sDate.AllocSysString();
		
	appExcel->Visible[0] = TRUE;
}


DWORD CNav_Buh_ExplDlg::StartExport_All(DWORD someparam)
{

	CStringArray sReplaseDocs;
	int iReplDoc;
	
	iReplDoc = _wtoi(sReadFromIni(_T("DELETE_DOCS"),_T("COUNT"),_T("0")));
	CString sDelDocVal;
	while(iReplDoc > 0)
	{
		sDelDocVal.Format(_T("DOC_%d"),iReplDoc);
		sReplaseDocs.Add(sReadFromIni(_T("DELETE_DOCS"),sDelDocVal,_T("")));
		iReplDoc--;
	}

	
	CItem Items;
	CNav_Buh_ExplDlg * Dlg;
	Dlg = (CNav_Buh_ExplDlg*)someparam;

	if(Dlg == NULL)	
	{
		return 0L;
	}

	int iType = Dlg->m_ComboType.GetCurSel();
	if(iType < 0)
		return 0l;

	iType = Dlg->m_ComboType.GetItemData(iType);
	if(iType < 0)
		return 0l;

	double fFloatNumbers;
	int iCURENCY;
	CString sCell;
	sCell.Format(_T("REPORT_%d"),iType);
	fFloatNumbers = _wtof(sReadFromIni(sCell,_T("FLOAT_NUMBER"),_T("1")));
	fFloatNumbers = 1/fFloatNumbers;
	iCURENCY = _wtoi(sReadFromIni(sCell,_T("CURENCY"),_T("0")));
	//CString sExcelShablon;
	
	
	
	
	CString sStart;
	CString sEnd;

	Dlg->m_edTo.GetWindowText(sEnd);
	Dlg->m_edFrom.GetWindowText(sStart);

	COleDateTime datStart,datEnd, cDate;
	datStart.ParseDateTime(sStart);
	datEnd.ParseDateTime(sEnd);
	
	sStart = datStart.Format(_T("%Y%m%d"));
	sEnd = datEnd.Format(_T("%Y%m%d"));

	Dlg->SetVisible(Dlg,1);
	CString sWareHouse, sFirm;
	sWareHouse = sReadFromIni(_T("DB"),_T("WAREHOUSE"),_T("WRITE_OFF"));
	sWriteToIni(_T("DB"),_T("WAREHOUSE"),sWareHouse);
	sFirm = sReadFromIni(_T("DB"),_T("FIRM"),_T("Shate-M"));
	sWriteToIni(_T("DB"),_T("FIRM"),sFirm);


	CDatabase* dBase;
	dBase = NULL;

	CString sError;
	if((dBase = OpenDatabase(&sError))==NULL)
	{
		AfxMessageBox(sError);
		return false;
	}

	CString sSQL;
	Dlg->m_stInfo.SetWindowTextW(_T("Формирование списка документов перемещения"));
	try
	{

		CDBVariant dbValue;
		CStringArray saDocs;
		saDocs.RemoveAll();
		CRecordset Query(dBase);
		CRecordset Query1(dBase);

		int i;
		sSQL.Format(_T("select [No_],Left(CONVERT ( nchar , ish.[Posting Date], 112),6),Left(CONVERT ( nchar , ish.[Posting Date], 112),8) from [%s$Item Shipment Header] as ish where Left(CONVERT ( nchar , ish.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , ish.[Posting Date], 112),8) <= '%s' and [Location Code] = '%s' order by [Posting Date]"),sFirm,sStart,sEnd,sWareHouse);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		while(!Query.IsEOF())
		{
			i=0;
			Query.GetFieldValue(i, dbValue);
			sSQL = GetValue(&dbValue);

			iReplDoc = 0;
			while(iReplDoc < sReplaseDocs.GetCount())
			{
				if(sReplaseDocs.ElementAt(iReplDoc) == sSQL)
				{
					break;
				}
				else
					iReplDoc++;
			}

			if(iReplDoc != sReplaseDocs.GetCount())
			{
				Query.MoveNext();
				continue;
			}
			saDocs.Add(sSQL);

			

			i=1;
			Query.GetFieldValue(i, dbValue);
			sSQL = GetValue(&dbValue);
			saDocs.Add(sSQL);

			i=2;
			Query.GetFieldValue(i, dbValue);
			sSQL = GetValue(&dbValue);
			saDocs.Add(sSQL);


			Query.MoveNext();
		}
		Query.Close();

		CStringArray sa;
		double dSumm,dVal, dSummUPR;
		CString sValue;
		int iCount;
		CString sDoc;
		CString sSS;
		CString sOld;
		while(saDocs.GetCount()>0)
		{
			Dlg->m_stInfo.SetWindowTextW(_T("Обработка документа ")+saDocs.ElementAt(0));
			switch(iCURENCY)
			{
				case 1:
					sSQL.Format(_T("select ile.[CD No_],ile.[CD Line No_], (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode, it.[Description],-1*ile.[Quantity],ish.[Item No_], ish.[Unit of Measure Code], ish.[Bin Code],ish.[Unit Cost] from [%s$Item Shipment line] as ish left join [%s$Item Ledger Entry] as ile on ile.[Document No_] = ish.[Document No_] and ile.[Document Line No_] = ish.[Line No_] Left join [%s$Item] as it on it.[No_] = ile.[Item No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] where ish.[Document No_] = '%s'	"),sFirm,sFirm,sFirm,saDocs.ElementAt(0));
					break;
				default:
					sSQL.Format(_T("select ile.[CD No_],ile.[CD Line No_], (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode, it.[Description],-1*ile.[Quantity],ish.[Item No_], ish.[Unit of Measure Code], ish.[Bin Code],(ish.[Unit Cost]*cr.[Exchange Rate Amount]) from [%s$Item Shipment line] as ish left join [%s$Item Ledger Entry] as ile on ile.[Document No_] = ish.[Document No_] and ile.[Document Line No_] = ish.[Line No_] Left join [%s$Item] as it on it.[No_] = ile.[Item No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] join (select top 1 [Exchange Rate Amount],[Currency Code] from [%s$Currency Exchange Rate] as cer where cer.[Currency Code] = 'BYR' and Left(CONVERT ( nchar , cer.[Starting Date], 112),6)  <= '%s' order by cer.[Starting Date] desc) as cr on cr.[Currency Code] = 'BYR'	where ish.[Document No_] = '%s'	"),sFirm,sFirm,sFirm,sFirm,saDocs.ElementAt(1),saDocs.ElementAt(0));
					break;
			}


			Query.Open(CRecordset::snapshot,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sa.RemoveAll();
				if(Dlg->bTerminate)
					{
						break;
					}

				for(i = 0;i<8;i++)
				{
					Query.GetFieldValue(i, dbValue);
					sa.Add(GetValue(&dbValue));
				}
			

				Query.GetFieldValue(i, dbValue);

				dSummUPR = _wtof(GetValue(&dbValue));
				

				dSumm = 0.0;
				dVal = 0.0;
				iCount = 0;

				sSQL.Format(_T("select cdr.[Line No_],[Item Charge No_],[Acc_ Cost per Unit] from [%s$Custom Declaration Relation] as cdr  join [%s$Value Entry] as ve on (ve.[Item Ledger Entry Type] = 0 or ve.[Item Ledger Entry Type] = 1 or ve.[Item Ledger Entry Type] = 2)  and ve.[Item Ledger Entry No_] = cdr.[Source Item Ledger Entry No_]  and  ve.[Expected Cost] = 0 and ve.[Entry Type] = 0   left join [%s$Item Charge] as ic on  ic.[No_] = ve.[Item Charge No_]  where ((ic.[Include in Accounting Cost] = 1)  or(ve.[Item Charge No_] = ''))   and ( (ve.[Item Ledger Entry Type] = 0) OR(	(ve.[Item Ledger Entry Type] = 1) AND(ve.[Document Type] = 4) ) OR  ((	(ve.[Document Type] = 14) OR (ve.[Document Type] = 16))   AND	(ve.[Item Ledger Entry Type] = 2)) OR ((ve.[Item Ledger Entry Type] = 2)  AND (ve.[Document No_] = 'START STOCK'))) and (cdr.[Document type] = '0' or cdr.[Document type] = 5) and cdr.[CD Line No_] = %s and cdr.[CD No_] = '%s' order by  cdr.[Line No_],ve.[Item Charge No_]"),sFirm,sFirm,sFirm,sa.ElementAt(1),sa.ElementAt(0));
				sOld = "";
				Query1.Open(CRecordset::snapshot ,sSQL,CRecordset::readOnly);
				while(!Query1.IsEOF())
				{
					if(Dlg->bTerminate)
					{
						break;			
					}
					

					i=0;
					Query1.GetFieldValue(i, dbValue);
					if(sOld.GetLength()>0)
					{
						if(sOld != GetValue(&dbValue))
						{
							break;
						}
					}
					else
					{
						sOld = GetValue(&dbValue);
					}
		
					i++;
					Query1.GetFieldValue(i, dbValue);
					sValue = GetValue(&dbValue);
					i++;
					if(sValue.GetLength()<1)
						{
							Query1.GetFieldValue(i, dbValue);
							sValue = GetValue(&dbValue);
							dVal = dVal+ _wtof(GetValue(&dbValue));
							iCount++;
						}
						else
						{
							Query1.GetFieldValue(i, dbValue);
							dSumm = dSumm+  _wtof(GetValue(&dbValue));
						}		
							Query1.MoveNext();
				}
				Query1.Close();	
				if(iCount != 0)
					dSumm = dSumm + dVal/iCount;
				dSumm = (int)(dSumm+0.5);
				
				dSummUPR = (dSummUPR*fFloatNumbers+0.5);
				dSummUPR = (int)dSummUPR;
				dSummUPR = dSummUPR/fFloatNumbers;	
	
				if(!Dlg->m_btWithUPRSS.GetCheck())
					dSummUPR = 0;

				sSS.Format(_T("\t%.0f_%.2f"),dSumm,dSummUPR);
				//
				if((!Dlg->m_btNoZero.GetCheck())||(dSumm > 0.0))
				{
					Items.Add(
						saDocs.ElementAt(1) + _T("_") + sa.ElementAt(2) + sSS,
						sa.ElementAt(2) + sSS,
						sa.ElementAt(3),
						sa.ElementAt(7),
						sa.ElementAt(5),
						sa.ElementAt(6),
						saDocs.ElementAt(1),
						_T(""),
						_wtoi(sa.ElementAt(4)),
						_wtoi(sa.ElementAt(4)) * dSumm,
						_wtoi(sa.ElementAt(4)) * dSummUPR);
				}
				Query.MoveNext();
			}
			
			Query.Close();
			saDocs.RemoveAt(0,3);			
		}
	}
	catch(CDBException * ex)
	{
		sError.Format(_T("Error - %d - %s\n%s"),ex->m_nRetCode,ex->m_strError,sSQL);
		ex->Delete();
		CloseDatabase(dBase);
		AfxMessageBox(sError);
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return false;
	}
	CloseDatabase(dBase);

	if(Dlg->bTerminate)
	{
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}

	if(Dlg->m_ButPrintAkt.GetCheck())
	{
		CreateExcelAkt(someparam,&Items, datStart.Format(_T("%m")), datEnd.Format(_T("%d.%m.%Y")));
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}

	Excel::_ApplicationPtr appExcel;
	Excel::WorkbooksPtr ExcelBooks;
	Excel::_WorkbookPtr ExcelBook;
	Excel::_WorksheetPtr ExcelSheet;
	Excel::RangePtr range;

	HRESULT hRes;
	hRes = appExcel.CreateInstance( _T("Excel.Application"));
	
	Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
	VARIANT bTRUE;
	bTRUE.vt = 11;
	bTRUE.boolVal = TRUE;
	appExcel->Visible[0] = FALSE;
	
	
	int i;
	stItem *Item;
	//Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
	int iCount;
	iCount = Items.GetCount();
	
	int iMaxRow;
	int iRow;
	CStringArray sa;
	int iKof;
	CString sVal;

	ExcelBook= appExcel->Workbooks->Add();
		ExcelSheet = ExcelBook->Worksheets->Item[1];
	


		sVal = _T("Отчет");
		ExcelSheet->Cells->Item[2,1] = sVal.AllocSysString();
		sVal = _T("Экспл. расходы");
		ExcelSheet->Cells->Item[2,2] = sVal.AllocSysString();
	
	
		sVal = _T("Сформирован");
		ExcelSheet->Cells->Item[3,1] = sVal.AllocSysString();
		sVal = GetWinUserName();
		ExcelSheet->Cells->Item[3,2] = sVal.AllocSysString();

		COleDateTime date;
		date = COleDateTime::GetCurrentTime();
	
		sVal = _T("Дата формирования");
		ExcelSheet->Cells->Item[4,1] = sVal.AllocSysString();
		sVal = date.Format(_T("%d.%m.%y"));
		ExcelSheet->Cells->Item[4,2] = sVal.AllocSysString();
	
		sVal = _T("По товару");
		range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[6, 1]];
		range->Merge();
		ExcelSheet->Cells->Item[5,1] = sVal.AllocSysString();

		sVal = _T("Кол-во");
		ExcelSheet->Cells->Item[6,2] = sVal.AllocSysString();


		int iCountColumn;
		iCountColumn = 1;
		if(Dlg->m_btBuhSS.GetCheck())
		{
			iCountColumn++;
			sVal = _T("Бух. себестоимость");
			ExcelSheet->Cells->Item[6,iCountColumn+1] = sVal.AllocSysString();
		}

		
		if(Dlg->m_btWithUPRSS.GetCheck())
		{
			iCountColumn++;
			sVal = _T("Упр. себестоимость");
			ExcelSheet->Cells->Item[6,iCountColumn+1] = sVal.AllocSysString();
		}
		/*else
			iCountColumn = 2;
		*/

		
		


		

		
		iRow = 0;
	
		CString sOld;
		sOld = "";
		
		iKof = 2;
		sVal = _T("Кол-во");
				
	
		
		
		iMaxRow = 0;
		sOld = "";
		
		for(i=0;i<iCount;i++)
		{
			if(Dlg->bTerminate)
			{
				break;
			}
		
			if(i%100 == 0)
			{
				sVal.Format(_T("Формирование Excel (%d / %d)"),i,iCount);
				Dlg->m_stInfo.SetWindowTextW(sVal);
			}

			Item = Items.GetItem(i);
			if(Item != NULL)
			{
				if(sOld.GetLength()<1)
				{

					sOld = Item->sDate;
					range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,iKof],ExcelSheet->Cells->Item[5, iKof+iCountColumn-1]];
					range->Merge();
					ExcelSheet->Cells->Item[5,iKof] = sOld.AllocSysString();
				}

				if(sOld != Item->sDate)
				{
					sOld = Item->sDate;
					iKof = iKof+iCountColumn;
					
					iRow = 0;	

					sVal = _T("Кол-во");
				
					range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,iKof],ExcelSheet->Cells->Item[5, iKof+iCountColumn-1]];
					range->Merge();
					ExcelSheet->Cells->Item[5,iKof] = sOld.AllocSysString();
				

					sVal = _T("Кол-во");
					ExcelSheet->Cells->Item[6,iKof] = sVal.AllocSysString();

					sVal = _T("Бух. себестоимость");
					ExcelSheet->Cells->Item[6,iKof+1] = sVal.AllocSysString();

					if(Dlg->m_btWithUPRSS.GetCheck())
					{
						sVal = _T("Упр. себестоимость");
						ExcelSheet->Cells->Item[6,iKof+2] = sVal.AllocSysString();
						sOld = Item->sDate;
					}
				}

				while(iRow < sa.GetCount())
				{
					if(Item->szCode == sa.ElementAt(iRow))
					{
						break;
					}	

					if(Item->szCode < sa.ElementAt(iRow))
					{
						sa.InsertAt(iRow,Item->szCode);
						
						Excel::RangePtr r = ExcelSheet->Range[ExcelSheet->Cells->Item[iRow+7, 1],ExcelSheet->Cells->Item[iRow+7, iKof+iCountColumn-1]];
						r->Insert(Excel::xlShiftDown,FALSE);
						CString sName;
						sName = Item->szCode;
						if(sName.Find(_T("\t"),0)>-1)
						{
							sName = sName.Left(sName.Find(_T("\t"),0));
						}
						sName =sName+ _T(" ")+Item->szDesc;
						ExcelSheet->Cells->Item[iRow+7,1] = sName.AllocSysString();
						break;
					}
					iRow++;
				}

				if(iRow == sa.GetCount())
				{
					sa.InsertAt(iRow,Item->szCode);		
					
					CString sName;
					sName = Item->szCode;
					if(sName.Find(_T("\t"),0)>-1)
					{
						sName = sName.Left(sName.Find(_T("\t"),0));
					}
					sName =sName+ _T(" ")+Item->szDesc;
					ExcelSheet->Cells->Item[iRow+7,1] = sName.AllocSysString();

					ExcelSheet->Cells->Item[iRow+7,iKof] = 0;
					ExcelSheet->Cells->Item[iRow+7,iKof+1] = 0;
					if(iCountColumn==3)
					{
						ExcelSheet->Cells->Item[iRow+7,iKof+2] = 0;
					}
				}
				ExcelSheet->Cells->Item[iRow+7,iKof] = Item->iQuant;
				if(iCountColumn == 2)
				{
					if(Dlg->m_btWithUPRSS.GetCheck())
						ExcelSheet->Cells->Item[iRow+7,iKof+1] = Item->dSUPR;
					else
						ExcelSheet->Cells->Item[iRow+7,iKof+1] = Item->dS;
				}
				else
					ExcelSheet->Cells->Item[iRow+7,iKof+1] = Item->dS;

				if(iCountColumn==3)
					ExcelSheet->Cells->Item[iRow+7,iKof+2] = Item->dSUPR;
				iRow++;
				
				if(iMaxRow<iRow)
				{
					iMaxRow = iRow;
				}
			}
		}
	
	

	if(Dlg->bTerminate)
	{
		appExcel->Visible[0] = TRUE;
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}

//	if(bPrintAkt)
	{
		iMaxRow = sa.GetCount();
		iMaxRow = iMaxRow +7;

		iKof = iKof+iCountColumn-1;
		
		
		
		range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[6, iKof]];
		range->Interior->Color = RGB(200,200,200);

	//iMaxRow
		range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[iMaxRow, 1]];
		range->Interior->Color = RGB(200,200,200);

		sVal = _T("Итого");
		ExcelSheet->Cells->Item[iMaxRow,1] = sVal.AllocSysString();
	
		/*if(Dlg->m_btWithUPRSS.GetCheck())
			range = ExcelSheet->Range[ExcelSheet->Cells->Item[iMaxRow,1],ExcelSheet->Cells->Item[iMaxRow, iKof]];
		else*/
			range = ExcelSheet->Range[ExcelSheet->Cells->Item[iMaxRow,1],ExcelSheet->Cells->Item[iMaxRow, iKof]];
		range->Interior->Color = RGB(200,200,200);

		sVal.Format(_T("=SUM(R[-%d]C:R[-1]C)"),iMaxRow-7);
		for(i=2; i<= iKof;i++)
		{
			range = ExcelSheet->Cells->Item[iMaxRow,i];
			range->PutFormula(sVal.AllocSysString());	
		}

		
			range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[iMaxRow, iKof]];
		
		Excel::BordersPtr borders;
		borders = range->GetBorders();
		borders->PutLineStyle(Excel::xlContinuous);
		borders->PutWeight(Excel::xlThin);
		borders->PutColorIndex(Excel::xlAutomatic);
		ExcelSheet->Select();
		range->EntireColumn->AutoFit();
	}
	


	appExcel->Visible[0] = TRUE;
	

	Dlg->SetVisible(Dlg,0);
	Dlg->bTerminate = FALSE;
	return 0L;
}


//StartExport_CurrentQuants
DWORD CNav_Buh_ExplDlg::StartExport_CurrentQuants(DWORD someparam)
{
	

	CItem Items;
	CNav_Buh_ExplDlg * Dlg;
	Dlg = (CNav_Buh_ExplDlg*)someparam;

	if(Dlg == NULL)	
	{
		return 0L;
	}

	int iFilter;
	int iType = Dlg->m_ComboType.GetCurSel();
	if(iType < 0)
		return 0l;

	iType = Dlg->m_ComboType.GetItemData(iType);
	if(iType < 0)
		return 0l;

	CString sCell,sCellFilter,sPos,sDelDocVal;
	sCell.Format(_T("REPORT_%d"),iType);
	iFilter = _wtoi(sReadFromIni(sCell,_T("FILTER_COUNT"),_T("0")));
	sCellFilter = _T("");
	//sDelDocVal
	
	while(iFilter > 0)
	{
		sCell.Format(_T("REPORT_%d"),iType);

		sPos.Format(_T("FILTER_%d"),iFilter);
		sPos = sReadFromIni(sCell,sPos,_T(""));

		if(sPos.GetLength()>0)
		{
			sDelDocVal.Format(_T(" and [Bin Code] <> '%s'"),sPos);
			sCellFilter = sCellFilter + sDelDocVal;
		}
		iFilter--;
	}
	
	if(sCellFilter.GetLength()>0)
	{
		sCellFilter = sCellFilter.Right(sCellFilter.GetLength()-4);
		sCellFilter = _T(" and (")+sCellFilter+_T(")");
	}


	Excel::_ApplicationPtr appExcel;
	Dlg->SetVisible(Dlg,1);
	CString sWareHouse, sFirm;
	sWareHouse = sReadFromIni(_T("DB"),_T("WAREHOUSE"),_T("WRITE_OFF"));
	sWriteToIni(_T("DB"),_T("WAREHOUSE"),sWareHouse);
	sFirm = sReadFromIni(_T("DB"),_T("FIRM"),_T("Shate-M"));
	sWriteToIni(_T("DB"),_T("FIRM"),sFirm);

	CDatabase* dBase;
	dBase = NULL;

	CString sError;
	if((dBase = OpenDatabase(&sError))==NULL)
	{
		AfxMessageBox(sError);
		return false;
	}

	CString sSQL;
	Dlg->m_stInfo.SetWindowTextW(_T("Формирование остатков"));
	try
	{
		CDBVariant dbValue;
		CStringArray saDocs;
		saDocs.RemoveAll();
		CRecordset Query(dBase);
		CRecordset Query1(dBase);

		int i;

		if(sCellFilter.GetLength()>0)
			sSQL.Format(_T("select * from(select bin.Description,we.[Bin Code], we.[Item No_],SUM(Quantity) as qnt from [%s$Warehouse Entry] as we left join [%s$Bin] as bin on bin.[Code] = we.[Bin Code] and we.[Location Code]=bin.[Location Code] where we.[Location Code] = '%s' group by bin.Description,we.[Bin Code], we.[Item No_]) as tab where tab.qnt > 0 %s ORDER BY tab.[Description]"),sFirm,sFirm,sWareHouse,sCellFilter);
		else
			sSQL.Format(_T("select * from(select bin.Description,we.[Bin Code], we.[Item No_],SUM(Quantity) as qnt from [%s$Warehouse Entry] as we left join [%s$Bin] as bin on bin.[Code] = we.[Bin Code] and we.[Location Code]=bin.[Location Code] where we.[Location Code] = '%s' group by bin.Description,we.[Bin Code], we.[Item No_]) as tab where tab.qnt > 0 ORDER BY tab.[Description]"),sFirm,sFirm,sWareHouse);
		
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		CString sType;
		CString sOldFile;

		HRESULT hRes;
		hRes = appExcel.CreateInstance( _T("Excel.Application"));

		Excel::WorkbooksPtr ExcelBooks;
		Excel::_WorkbookPtr ExcelBook;
		Excel::_WorksheetPtr ExcelSheet;
		Excel::RangePtr range;

		//range
		//ExcelBook= appExcel->Workbooks->Add();
	
		Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
		VARIANT bTRUE;
		bTRUE.vt = 11;
		bTRUE.boolVal = TRUE;
		appExcel->Visible[0] = FALSE;
		appExcel->DisplayAlerts[0] = FALSE;
		ExcelBook= appExcel->Workbooks->Add();
		ExcelSheet = ExcelBook->Worksheets->Item[1];

		while (ExcelBook->Worksheets->Count > 1){
			((Excel::_WorksheetPtr)ExcelBook->Worksheets->Item[1])->Delete();
		}

		CString sOldType;
		sOldType = "";
		int iRow;
		iRow = 1;
		CString sVal;
		while(!Query.IsEOF())
		{
			if(iRow%100 == 0)
			{
				sVal.Format(_T("Формирование Excel (%d)"),i);
				Dlg->m_stInfo.SetWindowTextW(sVal);
			}

			if(Dlg->bTerminate)
			{
				break;
			}
			i=0;
			Query.GetFieldValue(i, dbValue);
			sType = GetValue(&dbValue);
			if(sType.Find(_T(" "),0)>-1)
			{
				sType = sType.Left(sType.Find(_T(" "),0));
			}

			if(sType.Right(1)==_T("A"))
			{
				sType = sType.Left(sType.GetLength()-1);
			}

			if(sOldType != sType)
			{
				ExcelSheet = ExcelBook->Worksheets->Add();
				ExcelSheet->Name = sType.AllocSysString();
				iRow = 1;
				sOldType = sType;
			}


			i=1;
			Query.GetFieldValue(i, dbValue);
			ExcelSheet->Cells->Item[iRow,3] = GetValue(&dbValue).AllocSysString();

			i=2;
			
			
			
			Query.GetFieldValue(i, dbValue);
			
			range = ExcelSheet->Range[ExcelSheet->Cells->Item[iRow, 1],ExcelSheet->Cells->Item[iRow, 1]];
			range->NumberFormat =_T("@");
			ExcelSheet->Cells->Item[iRow,1] = GetValue(&dbValue).AllocSysString();

			i=3;
			Query.GetFieldValue(i, dbValue);
			ExcelSheet->Cells->Item[iRow,2] = GetValue(&dbValue).AllocSysString();
			
			ExcelSheet->Cells->Item[iRow,4] = 0;
			ExcelSheet->Cells->Item[iRow,5] = sType.AllocSysString();

			iRow++;
			Query.MoveNext();
		}
		Query.Close();
		
	}
	catch(CDBException * ex)
	{
		appExcel->Visible[0] = TRUE;
		sError.Format(_T("Error - %d - %s\n%s"),ex->m_nRetCode,ex->m_strError,sSQL);
		ex->Delete();
		CloseDatabase(dBase);
		AfxMessageBox(sError);
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return false;
	}
	CloseDatabase(dBase);
	
	appExcel->Visible[0] = TRUE;
	Dlg->SetVisible(Dlg,0);
	Dlg->bTerminate = FALSE;
	
	return 0l;
}




DWORD CNav_Buh_ExplDlg::StartExport_NotAuto(DWORD someparam)
{
	CStringArray sReplaseDocs;

	int iReplDoc;
	//_T("DB"),_T("WAREHOUSE"),_T("WRITE_OFF")
	iReplDoc = _wtoi(sReadFromIni(_T("DELETE_DOCS"),_T("COUNT"),_T("0")));
	CString sDelDocVal;
	while(iReplDoc > 0)
	{
		sDelDocVal.Format(_T("DOC_%d"),iReplDoc);
		sReplaseDocs.Add(sReadFromIni(_T("DELETE_DOCS"),sDelDocVal,_T("")));
		iReplDoc--;
	}

	CString sPos;
	CStringArray cellNoAuto;
	cellNoAuto.RemoveAll();
	int iAuto;
	iAuto = _wtoi(sReadFromIni(_T("DB"),_T("AUTO"),0));
	while(iAuto > 0)
	{
		sPos.Format(_T("AUTO_%d"),iAuto);
		cellNoAuto.Add(sReadFromIni(_T("DB"),sPos,_T("")));
		iAuto--;
	}


CItem Items;
	CNav_Buh_ExplDlg * Dlg;
	Dlg = (CNav_Buh_ExplDlg*)someparam;

	if(Dlg == NULL)	
	{
		return 0L;
	}

	CString sStart;
	CString sEnd;

	Dlg->m_edTo.GetWindowText(sEnd);
	Dlg->m_edFrom.GetWindowText(sStart);

	COleDateTime datStart,datEnd, cDate;
	datStart.ParseDateTime(sStart);
	datEnd.ParseDateTime(sEnd);
	
	sStart = datStart.Format(_T("%Y%m%d"));
	sEnd = datEnd.Format(_T("%Y%m%d"));

	/*if(datStart.GetMonth()!=datEnd.GetMonth())
	{
		AfxMessageBox(_T("Дата начала и конца в разных месяцах"));
		return 0l;
	}*/
	Dlg->SetVisible(Dlg,1);
	CString sWareHouse, sFirm;
	sWareHouse = sReadFromIni(_T("DB"),_T("WAREHOUSE"),_T("WRITE_OFF"));
	sWriteToIni(_T("DB"),_T("WAREHOUSE"),sWareHouse);
	sFirm = sReadFromIni(_T("DB"),_T("FIRM"),_T("Shate-M"));
	sWriteToIni(_T("DB"),_T("FIRM"),sFirm);

	CDatabase* dBase;
	dBase = NULL;

	CString sError;
	if((dBase = OpenDatabase(&sError))==NULL)
	{
		AfxMessageBox(sError);
		return false;
	}

	CString sSQL;
	Dlg->m_stInfo.SetWindowTextW(_T("Формирование списка документов перемещения"));
	try
	{

		CDBVariant dbValue;
		CStringArray saDocs;
		saDocs.RemoveAll();
		CRecordset Query(dBase);
		CRecordset Query1(dBase);

		int i;
		sSQL.Format(_T("select [No_],Left(CONVERT ( nchar , ish.[Posting Date], 112),6) from [%s$Item Shipment Header] as ish where Left(CONVERT ( nchar , ish.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , ish.[Posting Date], 112),8) <= '%s' and [Location Code] = '%s' order by [Posting Date]"),sFirm,sStart,sEnd,sWareHouse);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		while(!Query.IsEOF())
		{
			i=0;
			Query.GetFieldValue(i, dbValue);
			sSQL = GetValue(&dbValue);
			iReplDoc = 0;
			while(iReplDoc < sReplaseDocs.GetCount())
			{
				if(sReplaseDocs.ElementAt(iReplDoc) == sSQL)
				{
					break;
				}
				else
					iReplDoc++;
			}

			if(iReplDoc != sReplaseDocs.GetCount())
			{
				Query.MoveNext();
				continue;
			}
			saDocs.Add(sSQL);

			i=1;
			Query.GetFieldValue(i, dbValue);
			sSQL = GetValue(&dbValue);

			saDocs.Add(sSQL);
			Query.MoveNext();
		}
		Query.Close();

		CStringArray sa;
		double dSumm,dVal;
		CString sValue;
		int iCount;
		CString sDoc;
		CString sSS;
		CString sOld;
		while(saDocs.GetCount()>0)
		{
			Dlg->m_stInfo.SetWindowTextW(_T("Обработка документа ")+saDocs.ElementAt(0));

			
			
			sSQL.Format(_T("select ile.[CD No_],ile.[CD Line No_], (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode, it.[Description],-1*ile.[Quantity],ish.[Item No_], ish.[Unit of Measure Code], ish.[Bin Code] from [%s$Item Shipment line] as ish left join [%s$Item Ledger Entry] as ile on ile.[Document No_] = ish.[Document No_] and ile.[Document Line No_] = ish.[Line No_] Left join [%s$Item] as it on it.[No_] = ile.[Item No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] where ish.[Document No_] = '%s'	"),sFirm,sFirm,sFirm,saDocs.ElementAt(0));
			Query.Open(CRecordset::snapshot,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sa.RemoveAll();
				if(Dlg->bTerminate)
					{
						break;
					}

				for(i = 0;i<8;i++)
				{
					Query.GetFieldValue(i, dbValue);
					sa.Add(GetValue(&dbValue));
				}
			

				dSumm = 0.0;
				dVal = 0.0;
				iCount = 0;

				sSQL.Format(_T("select cdr.[Line No_],[Item Charge No_],[Acc_ Cost per Unit] from [%s$Custom Declaration Relation] as cdr  join [%s$Value Entry] as ve on (ve.[Item Ledger Entry Type] = 0 or ve.[Item Ledger Entry Type] = 1 or ve.[Item Ledger Entry Type] = 2)  and ve.[Item Ledger Entry No_] = cdr.[Source Item Ledger Entry No_]  and  ve.[Expected Cost] = 0 and ve.[Entry Type] = 0   left join [%s$Item Charge] as ic on  ic.[No_] = ve.[Item Charge No_]  where ((ic.[Include in Accounting Cost] = 1)  or(ve.[Item Charge No_] = ''))   and ( (ve.[Item Ledger Entry Type] = 0) OR(	(ve.[Item Ledger Entry Type] = 1) AND(ve.[Document Type] = 4) ) OR  ((	(ve.[Document Type] = 14) OR (ve.[Document Type] = 16))   AND	(ve.[Item Ledger Entry Type] = 2)) OR ((ve.[Item Ledger Entry Type] = 2)  AND (ve.[Document No_] = 'START STOCK'))) and (cdr.[Document type] = '0' or cdr.[Document type] = 5) and cdr.[CD Line No_] = %s and cdr.[CD No_] = '%s' order by  cdr.[Line No_],ve.[Item Charge No_]"),sFirm,sFirm,sFirm,sa.ElementAt(1),sa.ElementAt(0));
				sOld = "";
				Query1.Open(CRecordset::snapshot ,sSQL,CRecordset::readOnly);
				while(!Query1.IsEOF())
				{
					if(Dlg->bTerminate)
					{
						break;
					}
					
					i=0;
					Query1.GetFieldValue(i, dbValue);
					if(sOld.GetLength()>0)
					{
						if(sOld != GetValue(&dbValue))
						{
							break;
						}
					}
					else
					{
						sOld = GetValue(&dbValue);
					}
		
					i++;
					Query1.GetFieldValue(i, dbValue);
					sValue = GetValue(&dbValue);
					i++;
					if(sValue.GetLength()<1)
						{
							Query1.GetFieldValue(i, dbValue);
							sValue = GetValue(&dbValue);
							dVal = dVal+ _wtof(GetValue(&dbValue));
							iCount++;
						}
						else
						{
							Query1.GetFieldValue(i, dbValue);
							dSumm = dSumm+  _wtof(GetValue(&dbValue));
						}		
							Query1.MoveNext();
				}
				Query1.Close();	
				if(iCount != 0)
					dSumm = dSumm + dVal/iCount;
				dSumm = (int)(dSumm+0.5);
	
				
				sSS.Format(_T("\t%.0f"),dSumm);
				if((!Dlg->m_btNoZero.GetCheck())||(dSumm > 0.0))
				{
					Items.Add(
						sa.ElementAt(7) + _T("_") + saDocs.ElementAt(1) + _T("_") + sa.ElementAt(2) + sSS,
						sa.ElementAt(2) + sSS,
						sa.ElementAt(3),
						sa.ElementAt(7),
						sa.ElementAt(5),
						sa.ElementAt(6),
						saDocs.ElementAt(1),
						_T(""),
						_wtoi(sa.ElementAt(4)),
						_wtoi(sa.ElementAt(4)) * dSumm);
				}
				Query.MoveNext();
			}
			
			Query.Close();
			saDocs.RemoveAt(0,2);			
		}
	}
	catch(CDBException * ex)
	{
		sError.Format(_T("Error - %d - %s\n%s"),ex->m_nRetCode,ex->m_strError,sSQL);
		ex->Delete();
		CloseDatabase(dBase);
		AfxMessageBox(sError);
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return false;
	}
	CloseDatabase(dBase);
	if(Dlg->bTerminate)
	{
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}

	if(Dlg->m_ButPrintAkt.GetCheck())
	{
		CreateExcelAkt(someparam,&Items, datStart.Format(_T("%m")), datEnd.Format(_T("%d.%m.%Y")));
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}


	Excel::_ApplicationPtr appExcel;
	Excel::WorkbooksPtr ExcelBooks;
	Excel::_WorkbookPtr ExcelBook;
	Excel::_WorksheetPtr ExcelSheet;
	//Excel::_WorksheetPtr ExcelSheet1;
	Excel::RangePtr range;

	HRESULT hRes;
	hRes = appExcel.CreateInstance( _T("Excel.Application"));
	
	Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
	VARIANT bTRUE;
	bTRUE.vt = 11;
	bTRUE.boolVal = TRUE;
	appExcel->Visible[0] = FALSE;
	ExcelBook= appExcel->Workbooks->Add();
	ExcelSheet = ExcelBook->Worksheets->Item[1];
	
	int i;
	stItem *Item;
	//Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
	int iCount;
	iCount = Items.GetCount();
	

	CString sVal;

	sVal = _T("Отчет");
	ExcelSheet->Cells->Item[2,1] = sVal.AllocSysString();
	sVal = _T("Экспл. расходы");
	ExcelSheet->Cells->Item[2,2] = sVal.AllocSysString();
	
	
	sVal = _T("Сформирован");
	ExcelSheet->Cells->Item[3,1] = sVal.AllocSysString();
	sVal = GetWinUserName();
	ExcelSheet->Cells->Item[3,2] = sVal.AllocSysString();

	COleDateTime date;
		date = COleDateTime::GetCurrentTime();
	
	sVal = _T("Дата формирования");
	ExcelSheet->Cells->Item[4,1] = sVal.AllocSysString();
	sVal = date.Format(_T("%d.%m.%y"));
	ExcelSheet->Cells->Item[4,2] = sVal.AllocSysString();
	
	sVal = _T("По товару");
	range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[6, 1]];
	range->Merge();
	ExcelSheet->Cells->Item[5,1] = sVal.AllocSysString();


	sVal = _T("Кол-во");
	ExcelSheet->Cells->Item[6,2] = sVal.AllocSysString();

	sVal = _T("Бух. себестоимость");
	ExcelSheet->Cells->Item[6,3] = sVal.AllocSysString();

	


	int iRow;
	iRow = 0;
	
	CString sOld;
	sOld = "";
	int iKof;
	iKof = 0;
	CStringArray sa;
	int iMaxRow;
	iMaxRow = 0;
	
	for(i=0;i<iCount;i++)
	{
		if(Dlg->bTerminate)
		{
			break;
		}
		if(i%100 == 0)
		{
			sVal.Format(_T("Формирование Excel (%d / %d)"),i,iCount);
			Dlg->m_stInfo.SetWindowTextW(sVal);
		}
		Item = Items.GetItem(i);
		if(Item != NULL)
		{
			
			if(sOld != Item->sDate+Item->szCell)
			{
				iAuto = cellNoAuto.GetCount()-1;
				while(iAuto > -1)
				{
					if(cellNoAuto.ElementAt(iAuto)==Item->szCell)
					{
						break;
					}
					iAuto--;
				}
				if(iAuto == -1)
				{
					continue;
				}

				sOld = Item->szCell+datEnd.Format(_T("    %m %Y"));
				iKof = iKof+2;
				iRow = 0;

				sVal = _T("Кол-во");
				
				//sOld = datEnd.Format(_T("%m %Y"));
				range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,iKof],ExcelSheet->Cells->Item[5, iKof+1]];
				range->Merge();
				sOld = Item->sDate+_T("   ")+Item->szCell;
				ExcelSheet->Cells->Item[5,iKof] = sOld.AllocSysString();
				sOld = Item->sDate+Item->szCell;

				sVal = _T("Кол-во");
				ExcelSheet->Cells->Item[6,iKof] = sVal.AllocSysString();

				sVal = _T("Бух. себестоимость");
				ExcelSheet->Cells->Item[6,iKof+1] = sVal.AllocSysString();

			}

			while(iRow < sa.GetCount())
			{
				if(Item->szCode == sa.ElementAt(iRow))
				{
					break;
				}

				if(Item->szCode < sa.ElementAt(iRow))
				{
					sa.InsertAt(iRow,Item->szCode);
					
					//if(iRow > 0)
					{
						Excel::RangePtr r = ExcelSheet->Range[ExcelSheet->Cells->Item[iRow+7, 1],ExcelSheet->Cells->Item[iRow+7, iKof+3]];
						r->Insert(Excel::xlShiftDown,FALSE);

						CString sName;
					sName = Item->szCode;
					if(sName.Find(_T("\t"),0)>-1)
					{
						sName = sName.Left(sName.Find(_T("\t"),0));
					}
					sName =sName+ _T(" ")+Item->szDesc;
						ExcelSheet->Cells->Item[iRow+7,1] = sName.AllocSysString();
					}
					//ExcelSheet->Rows->EntireRow->Insert(
					//ExcelSheet->InsertRow(iRow,1);
					break;
				}
				iRow++;
			}

			if(iRow == sa.GetCount())
			{
				sa.InsertAt(iRow,Item->szCode);			
				CString sName;
					sName = Item->szCode;
					if(sName.Find(_T("\t"),0)>-1)
					{
						sName = sName.Left(sName.Find(_T("\t"),0));
					}
					sName =sName+ _T(" ")+Item->szDesc;
				ExcelSheet->Cells->Item[iRow+7,1] = sName.AllocSysString();

				ExcelSheet->Cells->Item[iRow+7,iKof] = 0;
				ExcelSheet->Cells->Item[iRow+7,iKof+1] = 0;
			}
			
			ExcelSheet->Cells->Item[iRow+7,iKof] = Item->iQuant;
			ExcelSheet->Cells->Item[iRow+7,iKof+1] = Item->dS;
			iRow++;
			if(iMaxRow<iRow)
			{
				iMaxRow = iRow;
			}

/*			Excel::RangePtr r = ExcelSheet1->Range[ExcelSheet1->Cells->Item[1, 1],ExcelSheet1->Cells->Item[1, 10]];
			r->Insert(Excel::xlShiftDown,FALSE);
			sVal.Format(_T("@"));
			r = ExcelSheet1->Range[ExcelSheet1->Cells->Item[1, 1],ExcelSheet1->Cells->Item[1, 10]];
			r->NumberFormat = sVal.AllocSysString();


			ExcelSheet1->Cells->Item[1,1] = Item->sCodeNav.AllocSysString();
			ExcelSheet1->Cells->Item[1,2] = Item->iQuant;
			ExcelSheet1->Cells->Item[1,3] = Item->sMesure.AllocSysString();
			ExcelSheet1->Cells->Item[1,4] = Item->dS;
			ExcelSheet1->Cells->Item[1,5] = Item->szCell.AllocSysString();*/
		}
		//break;

	}

	if(Dlg->bTerminate)
	{
		appExcel->Visible[0] = TRUE;
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}
	iMaxRow = sa.GetCount();
	iMaxRow = iMaxRow +7;

	range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[6, iKof+1]];
	range->Interior->Color = RGB(200,200,200);

	//iMaxRow
	range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[iMaxRow, 1]];
	range->Interior->Color = RGB(200,200,200);

	sVal = _T("Итого");
	ExcelSheet->Cells->Item[iMaxRow,1] = sVal.AllocSysString();

	/*
	range = ExcelSheet->Cells->Item[iRow,9];
	*/
	
	
	range = ExcelSheet->Range[ExcelSheet->Cells->Item[iMaxRow,1],ExcelSheet->Cells->Item[iMaxRow, iKof+1]];
	range->Interior->Color = RGB(200,200,200);

	sVal.Format(_T("=SUM(R[-%d]C:R[-1]C)"),iMaxRow-7);
	for(i=2; i<= iKof+1;i++)
	{
		range = ExcelSheet->Cells->Item[iMaxRow,i];
		range->PutFormula(sVal.AllocSysString());	
	}


	range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[iMaxRow, iKof+1]];

	Excel::BordersPtr borders;
	borders = range->GetBorders();
	borders->PutLineStyle(Excel::xlContinuous);
	borders->PutWeight(Excel::xlThin);
	borders->PutColorIndex(Excel::xlAutomatic);

	//range = range->Columns();
	range->EntireColumn->AutoFit();

	ExcelSheet->Select();
	appExcel->Visible[0] = TRUE;
	Dlg->SetVisible(Dlg,0);
	Dlg->bTerminate = FALSE;
	return 0l;
}

DWORD CNav_Buh_ExplDlg::StartExport_Auto(DWORD someparam)
{
	CStringArray sReplaseDocs;
	
	int iReplDoc;
	//_T("DB"),_T("WAREHOUSE"),_T("WRITE_OFF")
	iReplDoc = _wtoi(sReadFromIni(_T("DELETE_DOCS"),_T("COUNT"),_T("0")));

	float fFloatNumbers;
	iReplDoc = _wtoi(sReadFromIni(_T("DELETE_DOCS"),_T("COUNT"),_T("0")));
	

	CString sDelDocVal;
	while(iReplDoc > 0)
	{
		sDelDocVal.Format(_T("DOC_%d"),iReplDoc);
		sReplaseDocs.Add(sReadFromIni(_T("DELETE_DOCS"),sDelDocVal,_T("")));
		iReplDoc--;
	}

	CString sPos;
	
	CItem Items;
	CNav_Buh_ExplDlg * Dlg;
	Dlg = (CNav_Buh_ExplDlg*)someparam;

	CString sCellFilter;
	int iFilter;
	int iCURENCY;
	CString sCell;
	

	int iType = Dlg->m_ComboType.GetCurSel();
	if(iType < 0)
		return 0l;

	iType = Dlg->m_ComboType.GetItemData(iType);
	if(iType < 0)
		return 0l;

	sCell.Format(_T("REPORT_%d"),iType);
	fFloatNumbers = _wtof(sReadFromIni(sCell,_T("FLOAT_NUMBER"),_T("1")));
	fFloatNumbers = 1/fFloatNumbers;
	iCURENCY = _wtoi(sReadFromIni(sCell,_T("CURENCY"),_T("0")));
	iFilter = _wtoi(sReadFromIni(sCell,_T("FILTER_COUNT"),_T("0")));
	
	sCellFilter = _T("");
	//sDelDocVal
	
	while(iFilter > 0)
	{
		sCell.Format(_T("REPORT_%d"),iType);

		sPos.Format(_T("FILTER_%d"),iFilter);
		sPos = sReadFromIni(sCell,sPos,_T(""));

		if(sPos.GetLength()>0)
		{
			sDelDocVal.Format(_T(" or left(Bin.[Description],%d) = '%s '"),sPos.GetLength()+1,sPos);
			sCellFilter = sCellFilter + sDelDocVal;
		}
		iFilter--;
	}
	
	if(sCellFilter.GetLength()>0)
	{
		sCellFilter = sCellFilter.Right(sCellFilter.GetLength()-3);
		sCellFilter = _T(" and (")+sCellFilter+_T(")");
	}


	if(Dlg == NULL)	
	{
		return 0L;
	}

	CString sStart;
	CString sEnd;

	Dlg->m_edTo.GetWindowText(sEnd);
	Dlg->m_edFrom.GetWindowText(sStart);

	COleDateTime datStart,datEnd, cDate;
	datStart.ParseDateTime(sStart);
	datEnd.ParseDateTime(sEnd);
	
	sStart = datStart.Format(_T("%Y%m%d"));
	sEnd = datEnd.Format(_T("%Y%m%d"));

	Dlg->SetVisible(Dlg,1);
	CString sWareHouse, sFirm;
	sWareHouse = sReadFromIni(_T("DB"),_T("WAREHOUSE"),_T("WRITE_OFF"));
	sWriteToIni(_T("DB"),_T("WAREHOUSE"),sWareHouse);
	sFirm = sReadFromIni(_T("DB"),_T("FIRM"),_T("Shate-M"));
	sWriteToIni(_T("DB"),_T("FIRM"),sFirm);

	CDatabase* dBase;
	dBase = NULL;

	CString sError;
	if((dBase = OpenDatabase(&sError))==NULL)
	{
		AfxMessageBox(sError);
		return false;
	}

	CString sSQL;
	
	try
	{

		Dlg->m_stInfo.SetWindowTextW(_T("Формирование списка ячеек"));


		CDBVariant dbValue;
		CStringArray saDocs;
		saDocs.RemoveAll();
		CRecordset Query(dBase);
		CRecordset Query1(dBase);
		CRecordset Query2(dBase);
		
		





		/*int i;
		sSQL.Format(_T("select [No_],Left(CONVERT ( nchar , ish.[Posting Date], 112),6) from [%s$Item Shipment Header] as ish where Left(CONVERT ( nchar , ish.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , ish.[Posting Date], 112),8) <= '%s' and [Location Code] = '%s' order by [Posting Date]"),sFirm,sStart,sEnd,sWareHouse);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		*/

		Dlg->m_stInfo.SetWindowTextW(_T("Формирование списка документов перемещения"));
		int i;
		sSQL.Format(_T("select [No_],Left(CONVERT ( nchar , ish.[Posting Date], 112),6),Left(CONVERT ( nchar , ish.[Posting Date], 112),8) from [%s$Item Shipment Header] as ish where Left(CONVERT ( nchar , ish.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , ish.[Posting Date], 112),8) <= '%s' and [Location Code] = '%s' order by [Posting Date]"),sFirm,sStart,sEnd,sWareHouse);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		while(!Query.IsEOF())
		{
			i=0;
			Query.GetFieldValue(i, dbValue);
			sSQL = GetValue(&dbValue);

			iReplDoc = 0;
			while(iReplDoc < sReplaseDocs.GetCount())
			{
				if(sReplaseDocs.ElementAt(iReplDoc) == sSQL)
				{
					break;
				}
				else
					iReplDoc++;
			}

			if(iReplDoc != sReplaseDocs.GetCount())
			{
				Query.MoveNext();
				continue;
			}
			saDocs.Add(sSQL);

			

			i=1;
			Query.GetFieldValue(i, dbValue);
			sSQL = GetValue(&dbValue);
			saDocs.Add(sSQL);

			i=2;
			Query.GetFieldValue(i, dbValue);
			sSQL = GetValue(&dbValue);
			saDocs.Add(sSQL);


			Query.MoveNext();
		}
		Query.Close();

		CStringArray sa;
		double dSumm,dVal,dSummUPR;
		CString sValue;
		int iCount;
		CString sDoc;
		CString sSS;
		CString sOld;
		while(saDocs.GetCount()>0)
		{
			Dlg->m_stInfo.SetWindowTextW(_T("Обработка документа ")+saDocs.ElementAt(0));

			//sSQL.Format(_T("select ile.[CD No_],ile.[CD Line No_], (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode, it.[Description],-1*ile.[Quantity],ish.[Item No_], ish.[Unit of Measure Code], (bin.[Description]),(ish.[Unit Cost]) from [%s$Item Shipment line] as ish left join [%s$Item Ledger Entry] as ile on ile.[Document No_] = ish.[Document No_] and ile.[Document Line No_] = ish.[Line No_] Left join [%s$Item] as it on it.[No_] = ile.[Item No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] join (select top 1 [Exchange Rate Amount],[Currency Code] from [%s$Currency Exchange Rate] as cer where cer.[Currency Code] = 'BYR' and Left(CONVERT ( nchar , cer.[Starting Date], 112),6)  <= '%s' order by cer.[Starting Date] desc) as cr on cr.[Currency Code] = 'BYR' left join [%s$Bin] as bin on bin.[CODE] = ish.[Bin Code]	where ish.[Document No_] = '%s'	%s"),sFirm,sFirm,sFirm,sFirm,saDocs.ElementAt(1),sFirm,saDocs.ElementAt(0),sCellFilter);
			switch(iCURENCY)
			{
				case 1:
					sSQL.Format(_T("select ile.[CD No_],ile.[CD Line No_], (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode, it.[Description],-1*ile.[Quantity],ish.[Item No_], ish.[Unit of Measure Code], (bin.[Description]), (ile.[Entry No_]), (ish.[Unit Cost]) from [%s$Item Shipment line] as ish left join [%s$Item Ledger Entry] as ile on ile.[Document No_] = ish.[Document No_] and ile.[Document Line No_] = ish.[Line No_] Left join [%s$Item] as it on it.[No_] = ile.[Item No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] join (select top 1 [Exchange Rate Amount],[Currency Code] from [%s$Currency Exchange Rate] as cer where cer.[Currency Code] = 'BYR' and Left(CONVERT ( nchar , cer.[Starting Date], 112),6)  <= '%s' order by cer.[Starting Date] desc) as cr on cr.[Currency Code] = 'BYR' left join [%s$Bin] as bin on bin.[CODE] = ish.[Bin Code]	where ish.[Document No_] = '%s'	%s"),sFirm,sFirm,sFirm,sFirm,saDocs.ElementAt(1),sFirm,saDocs.ElementAt(0),sCellFilter);
					break;
				default:
					sSQL.Format(_T("select ile.[CD No_],ile.[CD Line No_], (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode, it.[Description],-1*ile.[Quantity],ish.[Item No_], ish.[Unit of Measure Code], (bin.[Description]), (ile.[Entry No_]), (ish.[Unit Cost]*cr.[Exchange Rate Amount]) from [%s$Item Shipment line] as ish left join [%s$Item Ledger Entry] as ile on ile.[Document No_] = ish.[Document No_] and ile.[Document Line No_] = ish.[Line No_] Left join [%s$Item] as it on it.[No_] = ile.[Item No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] join (select top 1 [Exchange Rate Amount],[Currency Code] from [%s$Currency Exchange Rate] as cer where cer.[Currency Code] = 'BYR' and Left(CONVERT ( nchar , cer.[Starting Date], 112),6)  <= '%s' order by cer.[Starting Date] desc) as cr on cr.[Currency Code] = 'BYR' left join [%s$Bin] as bin on bin.[CODE] = ish.[Bin Code]	where ish.[Document No_] = '%s'	%s"),sFirm,sFirm,sFirm,sFirm,saDocs.ElementAt(1),sFirm,saDocs.ElementAt(0),sCellFilter);
					break;
			}
			Query.Open(CRecordset::snapshot,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sa.RemoveAll();
				if(Dlg->bTerminate)
					{
						break;
					}

				for(i = 0;i<9;i++)
				{
					Query.GetFieldValue(i, dbValue);
					sa.Add(GetValue(&dbValue));
				}
				
				Query.GetFieldValue(i, dbValue);

				dSummUPR = _wtof(GetValue(&dbValue));
				
				dSummUPR = (dSummUPR*fFloatNumbers+0.5);
				dSummUPR = (int)dSummUPR;
				dSummUPR = dSummUPR/fFloatNumbers;	
				//dSummUPR = (int)(100*dSummUPR+0.5);
				//dSummUPR = dSummUPR/100;


				dSumm = 0.0;
				dVal = 0.0;
				iCount = 0;

				CString tmpStr = _T("");
				short ii = 0;
				sSQL.Format(_T("SELECT smcl.Comment FROM [Shate-M$Item Application Entry] smae JOIN [Shate-M$Item Ledger Entry] smle ON smle.[Entry No_] = smae.[Inbound Item Entry No_] JOIN [Shate-M$Inventory Comment Line] smcl ON smcl.No_ = smle.[Document No_] WHERE smae.[Item Ledger Entry No_] = %s"), sa.ElementAt(8));
				Query2.Open(CRecordset::snapshot, sSQL, CRecordset::readOnly);
				while (!Query2.IsEOF()){
					Query2.GetFieldValue(ii, dbValue);
					tmpStr = tmpStr + GetValue(&dbValue) + _T("; ");
					ii++;
					Query2.MoveNext();
				}
				sa.Add(tmpStr);
				Query2.Close();

				sSQL.Format(_T("select cdr.[Line No_], [Item Charge No_],[Acc_ Cost per Unit] from [%s$Custom Declaration Relation] as cdr  join [%s$Value Entry] as ve on (ve.[Item Ledger Entry Type] = 0 or ve.[Item Ledger Entry Type] = 1 or ve.[Item Ledger Entry Type] = 2)  and ve.[Item Ledger Entry No_] = cdr.[Source Item Ledger Entry No_]  and  ve.[Expected Cost] = 0 and ve.[Entry Type] = 0   left join [%s$Item Charge] as ic on  ic.[No_] = ve.[Item Charge No_]  where ((ic.[Include in Accounting Cost] = 1)  or(ve.[Item Charge No_] = ''))   and ( (ve.[Item Ledger Entry Type] = 0) OR(	(ve.[Item Ledger Entry Type] = 1) AND(ve.[Document Type] = 4) ) OR  ((	(ve.[Document Type] = 14) OR (ve.[Document Type] = 16))   AND	(ve.[Item Ledger Entry Type] = 2)) OR ((ve.[Item Ledger Entry Type] = 2)  AND (ve.[Document No_] = 'START STOCK'))) and (cdr.[Document type] = '0' or cdr.[Document type] = 5) and cdr.[CD Line No_] = %s and cdr.[CD No_] = '%s' order by  cdr.[Line No_],ve.[Item Charge No_]"),sFirm,sFirm,sFirm,sa.ElementAt(1),sa.ElementAt(0));
				sOld = "";
				Query1.Open(CRecordset::snapshot, sSQL, CRecordset::readOnly);
				while(!Query1.IsEOF())
				{
					if(Dlg->bTerminate)	
					{
						break;
					}
					
					i=0;
					Query1.GetFieldValue(i, dbValue);
					if(sOld.GetLength()>0)
					{
						if(sOld != GetValue(&dbValue))
						{
							break;
						}
					}
					else
					{
						sOld = GetValue(&dbValue);
					}
		
					i++;
					Query1.GetFieldValue(i, dbValue);
					sValue = GetValue(&dbValue);
					i++;
					if(sValue.GetLength()<1)
						{
							Query1.GetFieldValue(i, dbValue);
							sValue = GetValue(&dbValue);
							dVal = dVal+ _wtof(GetValue(&dbValue));
							iCount++;
						}
						else
						{
							Query1.GetFieldValue(i, dbValue);
							dSumm = dSumm+  _wtof(GetValue(&dbValue));
						}		
							Query1.MoveNext();
				}
				Query1.Close();	
				if(iCount != 0)
					dSumm = dSumm + dVal/iCount;
				dSumm = (int)(dSumm+0.5);
	
				if(!Dlg->m_btWithUPRSS.GetCheck())
					dSummUPR = 0;
				sSS.Format(_T("\t%.0f_%.0f"),dSumm,dSummUPR);
			
				
				if((!Dlg->m_btNoZero.GetCheck())||(dSumm > 0.0))
				{
					Items.Add(
						sa.ElementAt(7) + _T("_") + saDocs.ElementAt(1) + _T("_") + sa.ElementAt(2) + sSS,
						sa.ElementAt(2) + sSS,
						sa.ElementAt(3),
						sa.ElementAt(7),
						sa.ElementAt(5),
						sa.ElementAt(6),
						saDocs.ElementAt(1),
						sa.ElementAt(9),
						_wtoi(sa.ElementAt(4)),
						_wtoi(sa.ElementAt(4)) * dSumm,
						_wtoi(sa.ElementAt(4)) * dSummUPR);
				}
				Query.MoveNext();
			}
			
			Query.Close();
			saDocs.RemoveAt(0,3);			
		}
	}
	catch(CDBException * ex)
	{
		sError.Format(_T("Error - %d - %s\n%s"),ex->m_nRetCode,ex->m_strError,sSQL);
		ex->Delete();
		CloseDatabase(dBase);
		AfxMessageBox(sError);
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return false;
	}
	CloseDatabase(dBase);
	if(Dlg->bTerminate)
	{
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}
	
	if(Dlg->m_ButPrintAkt.GetCheck())
	{
		CreateExcelAkt(someparam,&Items, datStart.Format(_T("%m")), datEnd.Format(_T("%d.%m.%Y")));
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}


	Excel::_ApplicationPtr appExcel;
	Excel::WorkbooksPtr ExcelBooks;
	Excel::_WorkbookPtr ExcelBook;
	Excel::_WorksheetPtr ExcelSheet;
	//Excel::_WorksheetPtr ExcelSheet1;
	Excel::RangePtr range;

	HRESULT hRes;
	hRes = appExcel.CreateInstance( _T("Excel.Application"));
	
	Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
	VARIANT bTRUE;
	bTRUE.vt = 11;
	bTRUE.boolVal = TRUE;
	appExcel->Visible[0] = FALSE;
	ExcelBook= appExcel->Workbooks->Add();
	ExcelSheet = ExcelBook->Worksheets->Item[1];
	
	int i;
	stItem *Item;
	//Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
	int iCount;
	iCount = Items.GetCount();
	

	CString sVal;

	sVal = _T("Отчет");
	ExcelSheet->Cells->Item[2,1] = sVal.AllocSysString();
	sVal = _T("Экспл. расходы");
	ExcelSheet->Cells->Item[2,2] = sVal.AllocSysString();
	
	
	sVal = _T("Сформирован");
	ExcelSheet->Cells->Item[3,1] = sVal.AllocSysString();
	sVal = GetWinUserName();
	ExcelSheet->Cells->Item[3,2] = sVal.AllocSysString();

	COleDateTime date;
		date = COleDateTime::GetCurrentTime();
	
	sVal = _T("Дата формирования");
	ExcelSheet->Cells->Item[4,1] = sVal.AllocSysString();
	sVal = date.Format(_T("%d.%m.%y"));
	ExcelSheet->Cells->Item[4,2] = sVal.AllocSysString();
	
	sVal = _T("По товару");
	range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[6, 1]];
	range->Merge();
	ExcelSheet->Cells->Item[5,1] = sVal.AllocSysString();


	sVal = _T("Кол-во");
	ExcelSheet->Cells->Item[6,2] = sVal.AllocSysString();

	

	


	int iRow;
	iRow = 0;
	
	CString sOld;
	sOld = "";
	int iKof;
	iKof = -1;
	CStringArray sa;
	int iMaxRow;
	iMaxRow = 0;

	int iCountColumn;
	iCountColumn = 1;
	
	if(Dlg->m_btBuhSS.GetCheck())
	{
		iCountColumn++;
		sVal = _T("Бух. себестоимость");
		ExcelSheet->Cells->Item[6,iCountColumn+1] = sVal.AllocSysString();
	}

	if(Dlg->m_btWithUPRSS.GetCheck())
	{
		iCountColumn++;
		sVal = _T("Упр. себестоимость");
		ExcelSheet->Cells->Item[6,iCountColumn+1] = sVal.AllocSysString();
	}
	
	for(i=0;i<iCount;i++)
	{
		if(Dlg->bTerminate)
		{
			break;
		}
		if(i%100 == 0)
		{
			sVal.Format(_T("Формирование Excel (%d / %d)"),i,iCount);
			Dlg->m_stInfo.SetWindowTextW(sVal);
		}
		Item = Items.GetItem(i);
		if(Item != NULL)
		{
			if(sOld != Item->sDate+Item->szCell)
			{
				sOld = Item->szCell+datEnd.Format(_T("    %m %Y"));
				iRow = 0;

				if(iKof < 0)
					iKof = 2;
				else
					iKof=iKof+iCountColumn;
				sVal = _T("Кол-во");
				
				range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,iKof],ExcelSheet->Cells->Item[5, iKof+iCountColumn-1]];
				range->Merge();
				sOld = Item->sDate+_T("   ")+Item->szCell;
				ExcelSheet->Cells->Item[5,iKof] = sOld.AllocSysString();
				sOld = Item->sDate+Item->szCell;

				sVal = _T("Кол-во");
				ExcelSheet->Cells->Item[6,iKof] = sVal.AllocSysString();

				if(iCountColumn == 2)
				{
					if(Dlg->m_btWithUPRSS.GetCheck())
					{
						sVal = _T("Упр. себестоимость");
						ExcelSheet->Cells->Item[6,iKof+1] = sVal.AllocSysString();
					}
					else
					{
						sVal = _T("Бух. себестоимость");
						ExcelSheet->Cells->Item[6,iKof+1] = sVal.AllocSysString();
					}
				}
				else
				{
					sVal = _T("Бух. себестоимость");
					ExcelSheet->Cells->Item[6,iKof+1] = sVal.AllocSysString();
				}

				if(iCountColumn==3)
				{
					sVal = _T("Упр. себестоимость");
					ExcelSheet->Cells->Item[6,iKof+2] = sVal.AllocSysString();	
				}
			}

			while(iRow < sa.GetCount())
			{
				if(Item->szCode == sa.ElementAt(iRow))
				{
					break;
				}

				if(Item->szCode < sa.ElementAt(iRow))
				{
					sa.InsertAt(iRow,Item->szCode);
					
					Excel::RangePtr r = ExcelSheet->Range[ExcelSheet->Cells->Item[iRow+7, 1],ExcelSheet->Cells->Item[iRow+7, iKof+iCountColumn]];
					r->Insert(Excel::xlShiftDown,FALSE);
					
					CString sName;
					sName = Item->szCode;
					if(sName.Find(_T("\t"),0)>-1)
					{
						sName = sName.Left(sName.Find(_T("\t"),0));
					}	
					sName =sName+ _T(" ")+Item->szDesc;
						ExcelSheet->Cells->Item[iRow+7,1] = sName.AllocSysString();
										
					break;
				}
				iRow++;
			}

			if(iRow == sa.GetCount())
			{
				sa.InsertAt(iRow,Item->szCode);			
				CString sName;
					sName = Item->szCode;
					if(sName.Find(_T("\t"),0)>-1)
					{
						sName = sName.Left(sName.Find(_T("\t"),0));
					}
					sName =sName+ _T(" ")+Item->szDesc;
				ExcelSheet->Cells->Item[iRow+7,1] = sName.AllocSysString();

				ExcelSheet->Cells->Item[iRow+7,iKof] = 0;
				ExcelSheet->Cells->Item[iRow+7,iKof+1] = 0;
				if(iCountColumn==3)
				{
					ExcelSheet->Cells->Item[iRow+7,iKof+2] = 0;
				}
			}
			
			ExcelSheet->Cells->Item[iRow+7,iKof] = Item->iQuant;
			
			if(iCountColumn==2)
			{
				if(Dlg->m_btWithUPRSS.GetCheck())
					{
						ExcelSheet->Cells->Item[iRow+7,iKof+1] = Item->dSUPR;
					}
					else
					{
						ExcelSheet->Cells->Item[iRow+7,iKof+1] = Item->dS;
					}
			}
			else
			{
				ExcelSheet->Cells->Item[iRow+7,iKof+1] = Item->dS;
				ExcelSheet->Cells->Item[iRow+7,iKof+2] = Item->dSUPR;
			}
			iRow++;
			if(iMaxRow<iRow)
			{
				iMaxRow = iRow;
			}
		}
	
	}
	if(Dlg->bTerminate)
	{
		appExcel->Visible[0] = TRUE;
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}

	iMaxRow = sa.GetCount();
	iMaxRow = iMaxRow +7;
	if(iKof < 0)
					iKof = 2;

	range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[6, iKof+iCountColumn-1]];
	range->Interior->Color = RGB(200,200,200);

	range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[iMaxRow, 1]];
	range->Interior->Color = RGB(200,200,200);

	sVal = _T("Итого");
	ExcelSheet->Cells->Item[iMaxRow,1] = sVal.AllocSysString();

	range = ExcelSheet->Range[ExcelSheet->Cells->Item[iMaxRow,1],ExcelSheet->Cells->Item[iMaxRow, iCountColumn-1]];
	range->Interior->Color = RGB(200,200,200);
	
	CString sFormula1,sFormula2,sFormula3;

	if(iCountColumn>2)
	{
		sFormula1.Format(_T("=IF(MOD(COLUMN(R[-%d]C),3)=2,1,0)*R[-%d]C"),1,1);
		sFormula2.Format(_T("=IF(MOD(COLUMN(R[-%d]C),3)=0,1,0)*R[-%d]C"),2,2);
		sFormula3.Format(_T("=IF(MOD(COLUMN(R[-%d]C),3)=1,1,0)*R[-%d]C"),3,3);
	}
	else
	{
		sFormula1.Format(_T("=IF(MOD(COLUMN(R[-%d]C),2)=0,1,0)*R[-%d]C"),1,1);
		sFormula2.Format(_T("=IF(MOD(COLUMN(R[-%d]C),2)=1,1,0)*R[-%d]C"),2,2);
	}
	sVal.Format(_T("=SUM(R[-%d]C:R[-1]C)"),iMaxRow-7);
	for(i=2; i<= iKof+iCountColumn-1;i++)
	{
		
		range = ExcelSheet->Cells->Item[iMaxRow,i];
		range->PutFormula(sVal.AllocSysString());

		
		
		range = ExcelSheet->Cells->Item[iMaxRow+1,i];
		range->PutFormula(sFormula1.AllocSysString());

		
		range = ExcelSheet->Cells->Item[iMaxRow+2,i];
		range->PutFormula(sFormula2.AllocSysString());

		if(iCountColumn > 2)
		{
			range = ExcelSheet->Cells->Item[iMaxRow+3,i];
			range->PutFormula(sFormula3.AllocSysString());
		}
		
	}

	sFormula1.Format(_T("=SUM(R[-%d]C:R[-%d]C[%d])"),6,6,iKof+iCountColumn-1);
	sFormula2.Format(_T("=SUM(R[-%d]C:R[-%d]C[%d])"),6,6,iKof+iCountColumn-1);
	ExcelSheet->Cells->Item[iMaxRow+7,1] = _T("Итого кол-во");
	if(iCountColumn>2)
	{
		sFormula3.Format(_T("=SUM(R[-%d]C:R[-%d]C[%d])"),6,6,iKof+iCountColumn-1);
		ExcelSheet->Cells->Item[iMaxRow+8,1] = _T("Итого бух.с/с");
		ExcelSheet->Cells->Item[iMaxRow+9,1] = _T("Итого упр.с/с");
	}
	else
	{
		ExcelSheet->Cells->Item[iMaxRow+8,1] = _T("C/c");
	}

	
		
	
	range = ExcelSheet->Cells->Item[iMaxRow+7,2];
	range->PutFormula(sFormula1.AllocSysString());
	
	range = ExcelSheet->Cells->Item[iMaxRow+8,2];
	range->PutFormula(sFormula2.AllocSysString());
	if(iCountColumn>2)
	{
		range = ExcelSheet->Cells->Item[iMaxRow+9,2];
		range->PutFormula(sFormula3.AllocSysString());
	}
	

	//range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[iMaxRow, iKof+2]];
	
	range = ExcelSheet->Rows->Item[iMaxRow+1];
	range->RowHeight = 0;

	range = ExcelSheet->Rows->Item[iMaxRow+2];
	range->RowHeight = 0;

	range = ExcelSheet->Rows->Item[iMaxRow+3];
	range->RowHeight = 0;

	range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[iMaxRow, iKof+iCountColumn-1]];

	/**/

	//iMaxRow+1
	

	
	//ExcelSheet->Cells->Item[iMaxRow+5,2] = _T("Итого бух.с/с");
	//ExcelSheet->Cells->Item[iMaxRow+6,2] = _T("Итого упр.с/с");

	Excel::BordersPtr borders;
	borders = range->GetBorders();
	borders->PutLineStyle(Excel::xlContinuous);
	borders->PutWeight(Excel::xlThin);
	borders->PutColorIndex(Excel::xlAutomatic);

	//range = range->Columns();
	range->EntireColumn->AutoFit();
	ExcelSheet->Select();
	appExcel->Visible[0] = TRUE;
	Dlg->SetVisible(Dlg,0);
	Dlg->bTerminate = FALSE;
	return 0L;
}


void CNav_Buh_ExplDlg::OnBnClickedButtonStop()
{
	bTerminate = TRUE;
}

DWORD CNav_Buh_ExplDlg::StartExcel_All(DWORD someparam)
{
	CNav_Buh_ExplDlg * Dlg;
	Dlg = (CNav_Buh_ExplDlg*)someparam;
	Dlg->SetVisible(Dlg,1);

	Excel::_ApplicationPtr appExcel;
	Excel::WorkbooksPtr ExcelBooks;
	Excel::_WorkbookPtr ExcelBook;
	Excel::_WorksheetPtr ExcelSheet;
	Excel::_WorksheetPtr ExcelSheet1;
	Excel::RangePtr range;

	HRESULT hRes;
	hRes = appExcel.CreateInstance( _T("Excel.Application"));
	
	Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
	VARIANT bTRUE;
	bTRUE.vt = 11;
	bTRUE.boolVal = TRUE;
	appExcel->Visible[0] = FALSE;
	ExcelBook= appExcel->Workbooks->Open(_T("C:\\AKT.xlsx"));
	ExcelSheet = ExcelBook->Worksheets->Item[1];
	
	
	Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
	CString sVal;

	int iRow;
	iRow = 1;
	sVal = ExcelSheet->Cells->Item[iRow,1]; 
	CString sOld;
	sOld = "";

	while(sVal.GetLength() > 0)
	{
		if(iRow%10 == 0)
		{
			sVal.Format(_T("Формирование Excel ( %d )"),iRow);
			Dlg->m_stInfo.SetWindowTextW(sVal);
		}
		
		
		//sVal = ExcelSheet->Cells->Item[iRow,7]; 
		//ExcelSheet->Cells->Item[iRow,9] = sVal.AllocSysString();


		ExcelSheet->Cells->Item[iRow,4] = 0;
		sOld = sReadFromIni(_T("ARTICLE"),ExcelSheet->Cells->Item[iRow,3],sReadFromIni(_T("ARTICLE"),_T("DEFAULT"),_T("")));
			ExcelSheet->Cells->Item[iRow,5] = sOld.AllocSysString();
		
		if(sOld != sVal)
			{
				
				
			}


	/*	Excel::RangePtr r = ExcelSheet1->Range[ExcelSheet1->Cells->Item[1, 1],ExcelSheet1->Cells->Item[1, 10]];
		r->Insert(Excel::xlShiftDown,FALSE);
		sVal.Format(_T("@"));
		r = ExcelSheet1->Range[ExcelSheet1->Cells->Item[1, 1],ExcelSheet1->Cells->Item[1, 10]];
		r->NumberFormat = sVal.AllocSysString();

		ExcelSheet1->Cells->Item[1,1] = ExcelSheet->Cells->Item[iRow,1];
		ExcelSheet1->Cells->Item[1,2] = ExcelSheet->Cells->Item[iRow,6];
		ExcelSheet1->Cells->Item[1,3] = ExcelSheet->Cells->Item[iRow,5];
		ExcelSheet1->Cells->Item[1,4] = 0;
		ExcelSheet1->Cells->Item[1,5] = ExcelSheet->Cells->Item[iRow,7];
		*/

		

		iRow++;
		sVal = ExcelSheet->Cells->Item[iRow,1]; 
		
	}
	if(Dlg->bTerminate)
	{
		appExcel->Visible[0] = TRUE;
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}

	
	ExcelSheet->Select();
	appExcel->Visible[0] = TRUE;
	Dlg->SetVisible(Dlg,0);
	Dlg->bTerminate = FALSE;
	return 0L;

}
 

void CNav_Buh_ExplDlg::OnBnClickedButton1()
{
	DWORD dwThreadID;
	CreateThread(NULL, NULL, (LPTHREAD_START_ROUTINE)StartExcel_All, (void*)this, NULL, &dwThreadID); 
}

CString CNav_Buh_ExplDlg::GetPath(void)
{
	CString sPath;
	wchar_t cBuffer[MAX_PATH];
    ::GetModuleFileName(NULL, cBuffer, MAX_PATH);
    sPath = cBuffer;
    sPath = sPath.Left(sPath.ReverseFind('\\'));
	if (sPath.Right(1)!="\\") sPath += "\\";
	return sPath;
}

void CNav_Buh_ExplDlg::OnBnClickedButtonEditReport()
{
	CDlgReport dialog;
	dialog.DoModal();
	LoadReports();
}

int CNav_Buh_ExplDlg::LoadReports(void)
{
	while(m_ComboType.GetCount()>0)
	{	
		m_ComboType.DeleteString(0);
	}

	int iReport;
	iReport = _wtoi(sReadFromIni(_T("REPORT"),_T("COUNT"),_T("0")));
	if(iReport < 1)
	{
		sWriteToIni(_T("REPORT"),_T("COUNT"),_T("1"));
		sWriteToIni(_T("REPORT_0"),_T("NAME"),_T("Остатки"));
		sWriteToIni(_T("REPORT_0"),_T("TYPE"),_T("0"));
		sWriteToIni(_T("REPORT_0"),_T("FILTER_COUNT"),_T("2"));
		sWriteToIni(_T("REPORT_0"),_T("FILTER_1"),_T("RESERVATION"));
		sWriteToIni(_T("REPORT_0"),_T("FILTER_2"),_T("REKLAMA"));
		iReport = 0;
	}
	else
		iReport--;

	while(iReport > -1)
	{
		CString sCell;
		sCell.Format(_T("REPORT_%d"),iReport);
		m_ComboType.InsertString(0,sReadFromIni(sCell,_T("NAME"),_T("")));
		m_ComboType.SetItemData(0,iReport);
		iReport--;
	}
	
	if (m_ComboType.GetCount()>0)
	{
		m_ComboType.SetCurSel(0);
	}
	

	return 0;
}

DWORD CNav_Buh_ExplDlg::StartExport_Auto_AKT(DWORD someparam)
{
	CNav_Buh_ExplDlg * Dlg;
	Dlg = (CNav_Buh_ExplDlg*)someparam;

	CString sAKT;
	Dlg->edAktNum.GetWindowText(sAKT);
	if (sAKT.GetLength() == 0)
	{
  	  AfxMessageBox(_T("Номер акта не указан!"));
	  return -1;
	}

	CStringArray sReplaseDocs;
	
	int iReplDoc;
	//_T("DB"),_T("WAREHOUSE"),_T("WRITE_OFF")
	iReplDoc = _wtoi(sReadFromIni(_T("DELETE_DOCS"),_T("COUNT"),_T("0")));

	float fFloatNumbers;
	iReplDoc = _wtoi(sReadFromIni(_T("DELETE_DOCS"),_T("COUNT"),_T("0")));
	

	CString sDelDocVal;
	while(iReplDoc > 0)
	{
		sDelDocVal.Format(_T("DOC_%d"),iReplDoc);
		sReplaseDocs.Add(sReadFromIni(_T("DELETE_DOCS"),sDelDocVal,_T("")));
		iReplDoc--;
	}

	CString sPos;
	
	CItem Items;

	CString sCellFilter;
	int iFilter;
	int iCURENCY;
	CString sCell;
	

	int iType = Dlg->m_ComboType.GetCurSel();
	if(iType < 0)
		return 0l;

	iType = Dlg->m_ComboType.GetItemData(iType);
	if(iType < 0)
		return 0l;

	sCell.Format(_T("REPORT_%d"),iType);
	fFloatNumbers = _wtof(sReadFromIni(sCell,_T("FLOAT_NUMBER"),_T("1")));
	fFloatNumbers = 1/fFloatNumbers;
	iCURENCY = _wtoi(sReadFromIni(sCell,_T("CURENCY"),_T("0")));
	iFilter = _wtoi(sReadFromIni(sCell,_T("FILTER_COUNT"),_T("0")));
	
	sCellFilter = _T("");
	//sDelDocVal
	
	while(iFilter > 0)
	{
		sCell.Format(_T("REPORT_%d"),iType);

		sPos.Format(_T("FILTER_%d"),iFilter);
		sPos = sReadFromIni(sCell,sPos,_T(""));

		if(sPos.GetLength()>0)
		{
			sDelDocVal.Format(_T(" or left(Bin.[Description],%d) = '%s '"),sPos.GetLength()+1,sPos);
			sCellFilter = sCellFilter + sDelDocVal;
		}
		iFilter--;
	}
	
	if(sCellFilter.GetLength()>0)
	{
		sCellFilter = sCellFilter.Right(sCellFilter.GetLength()-3);
		sCellFilter = _T(" and (")+sCellFilter+_T(")");
	}


	if(Dlg == NULL)	
	{
		return 0L;
	}

	CString sStart;
	CString sEnd;

	Dlg->m_edTo.GetWindowText(sEnd);
	Dlg->m_edFrom.GetWindowText(sStart);

	COleDateTime datStart,datEnd, cDate;
	datStart.ParseDateTime(sStart);
	datEnd.ParseDateTime(sEnd);
	
	sStart = datStart.Format(_T("%Y%m%d"));
	sEnd = datEnd.Format(_T("%Y%m%d"));

	Dlg->SetVisible(Dlg,0);
	CString sWareHouse, sFirm;
	sWareHouse = sReadFromIni(_T("DB"),_T("WAREHOUSE"),_T("WRITE_OFF"));
	sWriteToIni(_T("DB"),_T("WAREHOUSE"),sWareHouse);
	sFirm = sReadFromIni(_T("DB"),_T("FIRM"),_T("Shate-M"));
	sWriteToIni(_T("DB"),_T("FIRM"),sFirm);

	CDatabase* dBase;
	dBase = NULL;

	CString sError;
	if((dBase = OpenDatabase(&sError))==NULL)
	{
		AfxMessageBox(sError);
		return false;
	}

	CString sSQL;
	
	try
	{

		Dlg->m_stInfo.SetWindowTextW(_T("Формирование списка ячеек"));


		CDBVariant dbValue;
		CStringArray saDocs;
		saDocs.RemoveAll();
		CRecordset Query(dBase);
		CRecordset Query1(dBase);
		
		





		/*int i;
		sSQL.Format(_T("select [No_],Left(CONVERT ( nchar , ish.[Posting Date], 112),6) from [%s$Item Shipment Header] as ish where Left(CONVERT ( nchar , ish.[Posting Date], 112),8) >= '%s' and Left(CONVERT ( nchar , ish.[Posting Date], 112),8) <= '%s' and [Location Code] = '%s' order by [Posting Date]"),sFirm,sStart,sEnd,sWareHouse);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		*/

		Dlg->m_stInfo.SetWindowTextW(_T("Формирование списка документов перемещения"));
		int i;

		sSQL.Format(_T("select [No_],Left(CONVERT ( nchar , ish.[Posting Date], 112),6),Left(CONVERT ( nchar , ish.[Posting Date], 112),8) from [%s$Item Shipment Header] as ish where ish.[No_] = '%s' order by [Posting Date]"),sFirm,sAKT);

//		AfxMessageBox(sSQL);

		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		while(!Query.IsEOF())
		{
			i=0;
			Query.GetFieldValue(i, dbValue);
			sSQL = GetValue(&dbValue);

			iReplDoc = 0;
			while(iReplDoc < sReplaseDocs.GetCount())
			{
				if(sReplaseDocs.ElementAt(iReplDoc) == sSQL)
				{
					break;
				}
				else
					iReplDoc++;
			}

			if(iReplDoc != sReplaseDocs.GetCount())
			{
				Query.MoveNext();
				continue;
			}
			saDocs.Add(sSQL);

			

			i=1;
			Query.GetFieldValue(i, dbValue);
			sSQL = GetValue(&dbValue);
			saDocs.Add(sSQL);

			i=2;
			Query.GetFieldValue(i, dbValue);
			sSQL = GetValue(&dbValue);
			saDocs.Add(sSQL);


			Query.MoveNext();
		}
		Query.Close();

		CStringArray sa;
		double dSumm,dVal,dSummUPR;
		CString sValue;
		int iCount;
		CString sDoc;
		CString sSS;
		CString sOld;
		while(saDocs.GetCount()>0)
		{
			Dlg->m_stInfo.SetWindowTextW(_T("Обработка документа ")+saDocs.ElementAt(0));

			//sSQL.Format(_T("select ile.[CD No_],ile.[CD Line No_], (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode, it.[Description],-1*ile.[Quantity],ish.[Item No_], ish.[Unit of Measure Code], (bin.[Description]),(ish.[Unit Cost]) from [%s$Item Shipment line] as ish left join [%s$Item Ledger Entry] as ile on ile.[Document No_] = ish.[Document No_] and ile.[Document Line No_] = ish.[Line No_] Left join [%s$Item] as it on it.[No_] = ile.[Item No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] join (select top 1 [Exchange Rate Amount],[Currency Code] from [%s$Currency Exchange Rate] as cer where cer.[Currency Code] = 'BYR' and Left(CONVERT ( nchar , cer.[Starting Date], 112),6)  <= '%s' order by cer.[Starting Date] desc) as cr on cr.[Currency Code] = 'BYR' left join [%s$Bin] as bin on bin.[CODE] = ish.[Bin Code]	where ish.[Document No_] = '%s'	%s"),sFirm,sFirm,sFirm,sFirm,saDocs.ElementAt(1),sFirm,saDocs.ElementAt(0),sCellFilter);
			switch(iCURENCY)
			{
				case 1:
					sSQL.Format(_T("select ile.[CD No_],ile.[CD Line No_], (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode, it.[Description],-1*ile.[Quantity],ish.[Item No_], ish.[Unit of Measure Code], (bin.[Description]), sm.Name, (ish.[Unit Cost]) from [%s$Item Shipment line] as ish left join [%s$Item Ledger Entry] as ile on ile.[Document No_] = ish.[Document No_] and ile.[Document Line No_] = ish.[Line No_] Left join [%s$Item] as it on it.[No_] = ile.[Item No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] join (select top 1 [Exchange Rate Amount],[Currency Code] from [%s$Currency Exchange Rate] as cer where cer.[Currency Code] = 'BYR' and Left(CONVERT ( nchar , cer.[Starting Date], 112),6)  <= '%s' order by cer.[Starting Date] desc) as cr on cr.[Currency Code] = 'BYR' left join [%s$Bin] as bin on bin.[CODE] = ish.[Bin Code] LEFT JOIN [%s$Custom Declaration Header] smdh ON smdh.[Custom Declaration No_] = ile.[CD No_] LEFT JOIN [%s$Vendor] sm ON sm.No_ = smdh.[Source No_]	where ish.[Document No_] = '%s'	%s"),sFirm,sFirm,sFirm,sFirm,saDocs.ElementAt(1),sFirm, sFirm, sFirm, saDocs.ElementAt(0),sCellFilter);
					break;
				default:
					sSQL.Format(_T("select ile.[CD No_],ile.[CD Line No_], (it.[No_ 2]+'_'+[tm].[Trade Mark Name]) as ServCode, it.[Description],-1*ile.[Quantity],ish.[Item No_], ish.[Unit of Measure Code], (bin.[Description]), sm.Name, (ish.[Unit Cost]*cr.[Exchange Rate Amount]) from [%s$Item Shipment line] as ish left join [%s$Item Ledger Entry] as ile on ile.[Document No_] = ish.[Document No_] and ile.[Document Line No_] = ish.[Line No_] Left join [%s$Item] as it on it.[No_] = ile.[Item No_] left join [tm] on it.[TM Code] = tm.[Trade Mark Code] join (select top 1 [Exchange Rate Amount],[Currency Code] from [%s$Currency Exchange Rate] as cer where cer.[Currency Code] = 'BYR' and Left(CONVERT ( nchar , cer.[Starting Date], 112),6)  <= '%s' order by cer.[Starting Date] desc) as cr on cr.[Currency Code] = 'BYR' left join [%s$Bin] as bin on bin.[CODE] = ish.[Bin Code] LEFT JOIN [%s$Custom Declaration Header] smdh ON smdh.[Custom Declaration No_] = ile.[CD No_] LEFT JOIN [%s$Vendor] sm ON sm.No_ = smdh.[Source No_]	where ish.[Document No_] = '%s'	%s"),sFirm,sFirm,sFirm,sFirm,saDocs.ElementAt(1),sFirm, sFirm, sFirm, saDocs.ElementAt(0),sCellFilter);
					break;
			}
			Query.Open(CRecordset::snapshot,sSQL,CRecordset::readOnly);
			while(!Query.IsEOF())
			{
				sa.RemoveAll();
				if(Dlg->bTerminate)
					{
						break;
					}

				for(i = 0; i < 9; i++)
				{
					Query.GetFieldValue(i, dbValue);
					sa.Add(GetValue(&dbValue));
				}

				Query.GetFieldValue(i, dbValue);

				dSummUPR = _wtof(GetValue(&dbValue));
				
				dSummUPR = (dSummUPR*fFloatNumbers+0.5);
				dSummUPR = (int)dSummUPR;
				dSummUPR = dSummUPR/fFloatNumbers;	
				//dSummUPR = (int)(100*dSummUPR+0.5);
				//dSummUPR = dSummUPR/100;


				dSumm = 0.0;
				dVal = 0.0;
				iCount = 0;

				sSQL.Format(_T("select cdr.[Line No_], [Item Charge No_],[Acc_ Cost per Unit] from [%s$Custom Declaration Relation] as cdr  join [%s$Value Entry] as ve on (ve.[Item Ledger Entry Type] = 0 or ve.[Item Ledger Entry Type] = 1 or ve.[Item Ledger Entry Type] = 2)  and ve.[Item Ledger Entry No_] = cdr.[Source Item Ledger Entry No_]  and  ve.[Expected Cost] = 0 and ve.[Entry Type] = 0   left join [%s$Item Charge] as ic on  ic.[No_] = ve.[Item Charge No_]  where ((ic.[Include in Accounting Cost] = 1)  or(ve.[Item Charge No_] = ''))   and ( (ve.[Item Ledger Entry Type] = 0) OR(	(ve.[Item Ledger Entry Type] = 1) AND(ve.[Document Type] = 4) ) OR  ((	(ve.[Document Type] = 14) OR (ve.[Document Type] = 16))   AND	(ve.[Item Ledger Entry Type] = 2)) OR ((ve.[Item Ledger Entry Type] = 2)  AND (ve.[Document No_] = 'START STOCK'))) and (cdr.[Document type] = '0' or cdr.[Document type] = 5) and cdr.[CD Line No_] = %s and cdr.[CD No_] = '%s' order by  cdr.[Line No_],ve.[Item Charge No_]"),sFirm,sFirm,sFirm,sa.ElementAt(1),sa.ElementAt(0));
				sOld = "";
				Query1.Open(CRecordset::snapshot ,sSQL,CRecordset::readOnly);
				while(!Query1.IsEOF())
				{
					if(Dlg->bTerminate)
					{
						break;
					}
					
					i=0;
					Query1.GetFieldValue(i, dbValue);
					if(sOld.GetLength()>0)
					{
						if(sOld != GetValue(&dbValue))
						{
							break;
						}
					}
					else
					{
						sOld = GetValue(&dbValue);
					}
		
					i++;
					Query1.GetFieldValue(i, dbValue);
					sValue = GetValue(&dbValue);
					i++;
					if(sValue.GetLength()<1)
						{
							Query1.GetFieldValue(i, dbValue);
							sValue = GetValue(&dbValue);
							dVal = dVal+ _wtof(GetValue(&dbValue));
							iCount++;
						}
						else
						{
							Query1.GetFieldValue(i, dbValue);
							dSumm = dSumm+  _wtof(GetValue(&dbValue));
						}		
							Query1.MoveNext();
				}
				Query1.Close();	
				if(iCount != 0)
					dSumm = dSumm + dVal/iCount;
				dSumm = (int)(dSumm+0.5);
	
				if(!Dlg->m_btWithUPRSS.GetCheck())
					dSummUPR = 0;
				sSS.Format(_T("\t%.0f_%.0f"),dSumm,dSummUPR);
			
				
				if((!Dlg->m_btNoZero.GetCheck())||(dSumm > 0.0))
				{
					Items.Add(
						sa.ElementAt(7) + _T("_") + saDocs.ElementAt(1) + _T("_") + sa.ElementAt(2) + sSS,
						sa.ElementAt(2) + sSS,
						sa.ElementAt(3),
						sa.ElementAt(7),
						sa.ElementAt(5),
						sa.ElementAt(6),
						saDocs.ElementAt(1),
						sa.ElementAt(8),
						_wtoi(sa.ElementAt(4)),
						_wtoi(sa.ElementAt(4)) * dSumm,
						_wtoi(sa.ElementAt(4)) * dSummUPR);
				}
				Query.MoveNext();
			}
			
			Query.Close();
			saDocs.RemoveAt(0,3);			
		}
	}
	catch(CDBException * ex)
	{
		sError.Format(_T("Error - %d - %s\n%s"),ex->m_nRetCode,ex->m_strError,sSQL);
		ex->Delete();
		CloseDatabase(dBase);
		AfxMessageBox(sError);
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return false;
	}
	CloseDatabase(dBase);
	if(Dlg->bTerminate)
	{
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}
	
	if(Dlg->m_ButPrintAkt.GetCheck())
	{
		CreateExcelAkt(someparam,&Items, datStart.Format(_T("%m")), datEnd.Format(_T("%d.%m.%Y")));
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}


	Excel::_ApplicationPtr appExcel;
	Excel::WorkbooksPtr ExcelBooks;
	Excel::_WorkbookPtr ExcelBook;
	Excel::_WorksheetPtr ExcelSheet;
	//Excel::_WorksheetPtr ExcelSheet1;
	Excel::RangePtr range;

	HRESULT hRes;
	hRes = appExcel.CreateInstance( _T("Excel.Application"));
	
	Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
	VARIANT bTRUE;
	bTRUE.vt = 11;
	bTRUE.boolVal = TRUE;
	appExcel->Visible[0] = FALSE;
	ExcelBook= appExcel->Workbooks->Add();
	ExcelSheet = ExcelBook->Worksheets->Item[1];
	
	int i;
	stItem *Item;
	//Dlg->m_stInfo.SetWindowTextW(_T("Формирование Excel "));
	int iCount;
	iCount = Items.GetCount();
	

	CString sVal;

	sVal = _T("Отчет");
	ExcelSheet->Cells->Item[2,1] = sVal.AllocSysString();
	sVal = _T("Экспл. расходы");
	ExcelSheet->Cells->Item[2,2] = sVal.AllocSysString();
	
	
	sVal = _T("Сформирован");
	ExcelSheet->Cells->Item[3,1] = sVal.AllocSysString();
	sVal = GetWinUserName();
	ExcelSheet->Cells->Item[3,2] = sVal.AllocSysString();

	COleDateTime date;
		date = COleDateTime::GetCurrentTime();
	
	sVal = _T("Дата формирования");
	ExcelSheet->Cells->Item[4,1] = sVal.AllocSysString();
	sVal = date.Format(_T("%d.%m.%y"));
	ExcelSheet->Cells->Item[4,2] = sVal.AllocSysString();
	
	sVal = _T("По товару");
	range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[6, 1]];
	range->Merge();
	ExcelSheet->Cells->Item[5,1] = sVal.AllocSysString();


	sVal = _T("Кол-во");
	ExcelSheet->Cells->Item[6,2] = sVal.AllocSysString();

	

	


	int iRow;
	iRow = 0;
	
	CString sOld;
	sOld = "";
	int iKof;
	iKof = -1;
	CStringArray sa;
	int iMaxRow;
	iMaxRow = 0;

	int iCountColumn;
	iCountColumn = 1;
	
	if(Dlg->m_btBuhSS.GetCheck())
	{
		iCountColumn++;
		sVal = _T("Бух. себестоимость");
		ExcelSheet->Cells->Item[6,iCountColumn+1] = sVal.AllocSysString();
	}

	if(Dlg->m_btWithUPRSS.GetCheck())
	{
		iCountColumn++;
		sVal = _T("Упр. себестоимость");
		ExcelSheet->Cells->Item[6,iCountColumn+1] = sVal.AllocSysString();
	}
	
	for(i=0;i<iCount;i++)
	{
		if(Dlg->bTerminate)
		{
			break;
		}
		if(i%100 == 0)
		{
			sVal.Format(_T("Формирование Excel (%d / %d)"),i,iCount);
			Dlg->m_stInfo.SetWindowTextW(sVal);
		}
		Item = Items.GetItem(i);
		if(Item != NULL)
		{
			if(sOld != Item->sDate+Item->szCell)
			{
				sOld = Item->szCell+datEnd.Format(_T("    %m %Y"));
				iRow = 0;

				if(iKof < 0)
					iKof = 2;
				else
					iKof=iKof+iCountColumn;
				sVal = _T("Кол-во");
				
				range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,iKof],ExcelSheet->Cells->Item[5, iKof+iCountColumn-1]];
				range->Merge();
				sOld = Item->sDate+_T("   ")+Item->szCell;
				ExcelSheet->Cells->Item[5,iKof] = sOld.AllocSysString();
				sOld = Item->sDate+Item->szCell;

				sVal = _T("Кол-во");
				ExcelSheet->Cells->Item[6,iKof] = sVal.AllocSysString();

				if(iCountColumn == 2)
				{
					if(Dlg->m_btWithUPRSS.GetCheck())
					{
						sVal = _T("Упр. себестоимость");
						ExcelSheet->Cells->Item[6,iKof+1] = sVal.AllocSysString();
					}
					else
					{
						sVal = _T("Бух. себестоимость");
						ExcelSheet->Cells->Item[6,iKof+1] = sVal.AllocSysString();
					}
				}
				else
				{
					sVal = _T("Бух. себестоимость");
					ExcelSheet->Cells->Item[6,iKof+1] = sVal.AllocSysString();
				}

				if(iCountColumn==3)
				{
					sVal = _T("Упр. себестоимость");
					ExcelSheet->Cells->Item[6,iKof+2] = sVal.AllocSysString();	
				}
			}

			while(iRow < sa.GetCount())
			{
				if(Item->szCode == sa.ElementAt(iRow))
				{
					break;
				}

				if(Item->szCode < sa.ElementAt(iRow))
				{
					sa.InsertAt(iRow,Item->szCode);
					
					Excel::RangePtr r = ExcelSheet->Range[ExcelSheet->Cells->Item[iRow+7, 1],ExcelSheet->Cells->Item[iRow+7, iKof+iCountColumn]];
					r->Insert(Excel::xlShiftDown,FALSE);
					
					CString sName;
					sName = Item->szCode;
					if(sName.Find(_T("\t"),0)>-1)
					{
						sName = sName.Left(sName.Find(_T("\t"),0));
					}	
					sName =sName+ _T(" ")+Item->szDesc;
						ExcelSheet->Cells->Item[iRow+7,1] = sName.AllocSysString();
										
					break;
				}
				iRow++;
			}

			if(iRow == sa.GetCount())
			{
				sa.InsertAt(iRow,Item->szCode);			
				CString sName;
					sName = Item->szCode;
					if(sName.Find(_T("\t"),0)>-1)
					{
						sName = sName.Left(sName.Find(_T("\t"),0));
					}
					sName =sName+ _T(" ")+Item->szDesc;
				ExcelSheet->Cells->Item[iRow+7,1] = sName.AllocSysString();

				ExcelSheet->Cells->Item[iRow+7,iKof] = 0;
				ExcelSheet->Cells->Item[iRow+7,iKof+1] = 0;
				if(iCountColumn==3)
				{
					ExcelSheet->Cells->Item[iRow+7,iKof+2] = 0;
				}
			}
			
			ExcelSheet->Cells->Item[iRow+7,iKof] = Item->iQuant;
			
			if(iCountColumn==2)
			{
				if(Dlg->m_btWithUPRSS.GetCheck())
					{
						ExcelSheet->Cells->Item[iRow+7,iKof+1] = Item->dSUPR;
					}
					else
					{
						ExcelSheet->Cells->Item[iRow+7,iKof+1] = Item->dS;
					}
			}
			else
			{
				ExcelSheet->Cells->Item[iRow+7,iKof+1] = Item->dS;
				ExcelSheet->Cells->Item[iRow+7,iKof+2] = Item->dSUPR;
			}
			iRow++;
			if(iMaxRow<iRow)
			{
				iMaxRow = iRow;
			}
		}
	
	}
	if(Dlg->bTerminate)
	{
		appExcel->Visible[0] = TRUE;
		Dlg->SetVisible(Dlg,0);
		Dlg->bTerminate = FALSE;
		return 0L;
	}

	iMaxRow = sa.GetCount();
	iMaxRow = iMaxRow +7;
	if(iKof < 0)
					iKof = 2;

	range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[6, iKof+iCountColumn-1]];
	range->Interior->Color = RGB(200,200,200);

	range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[iMaxRow, 1]];
	range->Interior->Color = RGB(200,200,200);

	sVal = _T("Итого");
	ExcelSheet->Cells->Item[iMaxRow,1] = sVal.AllocSysString();

	range = ExcelSheet->Range[ExcelSheet->Cells->Item[iMaxRow,1],ExcelSheet->Cells->Item[iMaxRow, iCountColumn-1]];
	range->Interior->Color = RGB(200,200,200);
	
	CString sFormula1,sFormula2,sFormula3;

	if(iCountColumn>2)
	{
		sFormula1.Format(_T("=IF(MOD(COLUMN(R[-%d]C),3)=2,1,0)*R[-%d]C"),1,1);
		sFormula2.Format(_T("=IF(MOD(COLUMN(R[-%d]C),3)=0,1,0)*R[-%d]C"),2,2);
		sFormula3.Format(_T("=IF(MOD(COLUMN(R[-%d]C),3)=1,1,0)*R[-%d]C"),3,3);
	}
	else
	{
		sFormula1.Format(_T("=IF(MOD(COLUMN(R[-%d]C),2)=0,1,0)*R[-%d]C"),1,1);
		sFormula2.Format(_T("=IF(MOD(COLUMN(R[-%d]C),2)=1,1,0)*R[-%d]C"),2,2);
	}
	sVal.Format(_T("=SUM(R[-%d]C:R[-1]C)"),iMaxRow-7);
	for(i=2; i<= iKof+iCountColumn-1;i++)
	{
		
		range = ExcelSheet->Cells->Item[iMaxRow,i];
		range->PutFormula(sVal.AllocSysString());

		
		
		range = ExcelSheet->Cells->Item[iMaxRow+1,i];
		range->PutFormula(sFormula1.AllocSysString());

		
		range = ExcelSheet->Cells->Item[iMaxRow+2,i];
		range->PutFormula(sFormula2.AllocSysString());

		if(iCountColumn > 2)
		{
			range = ExcelSheet->Cells->Item[iMaxRow+3,i];
			range->PutFormula(sFormula3.AllocSysString());
		}
		
	}

	sFormula1.Format(_T("=SUM(R[-%d]C:R[-%d]C[%d])"),6,6,iKof+iCountColumn-1);
	sFormula2.Format(_T("=SUM(R[-%d]C:R[-%d]C[%d])"),6,6,iKof+iCountColumn-1);
	ExcelSheet->Cells->Item[iMaxRow+7,1] = _T("Итого кол-во");
	if(iCountColumn>2)
	{
		sFormula3.Format(_T("=SUM(R[-%d]C:R[-%d]C[%d])"),6,6,iKof+iCountColumn-1);
		ExcelSheet->Cells->Item[iMaxRow+8,1] = _T("Итого бух.с/с");
		ExcelSheet->Cells->Item[iMaxRow+9,1] = _T("Итого упр.с/с");
	}
	else
	{
		ExcelSheet->Cells->Item[iMaxRow+8,1] = _T("C/c");
	}

	
		
	
	range = ExcelSheet->Cells->Item[iMaxRow+7,2];
	range->PutFormula(sFormula1.AllocSysString());
	
	range = ExcelSheet->Cells->Item[iMaxRow+8,2];
	range->PutFormula(sFormula2.AllocSysString());
	if(iCountColumn>2)
	{
		range = ExcelSheet->Cells->Item[iMaxRow+9,2];
		range->PutFormula(sFormula3.AllocSysString());
	}
	

	//range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[iMaxRow, iKof+2]];
	
	range = ExcelSheet->Rows->Item[iMaxRow+1];
	range->RowHeight = 0;

	range = ExcelSheet->Rows->Item[iMaxRow+2];
	range->RowHeight = 0;

	range = ExcelSheet->Rows->Item[iMaxRow+3];
	range->RowHeight = 0;

	range = ExcelSheet->Range[ExcelSheet->Cells->Item[5,1],ExcelSheet->Cells->Item[iMaxRow, iKof+iCountColumn-1]];

	/**/

	//iMaxRow+1
	

	
	//ExcelSheet->Cells->Item[iMaxRow+5,2] = _T("Итого бух.с/с");
	//ExcelSheet->Cells->Item[iMaxRow+6,2] = _T("Итого упр.с/с");

	Excel::BordersPtr borders;
	borders = range->GetBorders();
	borders->PutLineStyle(Excel::xlContinuous);
	borders->PutWeight(Excel::xlThin);
	borders->PutColorIndex(Excel::xlAutomatic);

	//range = range->Columns();
	range->EntireColumn->AutoFit();
	ExcelSheet->Select();
	appExcel->Visible[0] = TRUE;
	Dlg->SetVisible(Dlg,0);
	Dlg->bTerminate = FALSE;
	return 0L;
}

