// EI_PricesDlg.cpp : implementation file
//

#include "stdafx.h"
#include "EI_Prices.h"
#include "EI_PricesDlg.h"
#include "locale.h"
#include "SMTP\SMTPClass.h"
#include "DLGEmails.h"
#include "DlgBrands.h"
#include    <time.h>
#include "DlgNewProject.h"

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


// CEI_PricesDlg dialog




CEI_PricesDlg::CEI_PricesDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CEI_PricesDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	dBase = NULL;
	lID_Client = -1;
	iStyle = 0;
}

void CEI_PricesDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_COMBO_CLIENTS, m_ComboClients);
	DDX_Control(pDX, IDC_EDIT_NAME, m_EdName);
	DDX_Control(pDX, IDC_EDIT2, m_EdFrom);
	DDX_Control(pDX, IDC_EDIT_SUBJECT, m_EdSubject);
	DDX_Control(pDX, IDC_EDIT_ERROR_MAIL, m_EdErrorMail);
	DDX_Control(pDX, IDC_COMBO_FORMATS, m_ComboFormats);
	DDX_Control(pDX, IDC_COMBO_TYPE_EXPORT, m_ComboTypeExport);
	DDX_Control(pDX, IDC_EDIT_ED_CODEPEOGRAMM, m_EdCodeProgramm);
	DDX_Control(pDX, IDC_COMBO_TYPE_ORDER, m_ComboTypeOrder);
	DDX_Control(pDX, IDC_COMBO_CURRENCY, m_ComboCyrrency);
	DDX_Control(pDX, IDC_COMBO_DELIVERY, m_ComboDelivery);
	DDX_Control(pDX, IDC_EDIT6, m_EdDate);
	DDX_Control(pDX, IDC_COMBO_TYPE_FILE_IMPORT, m_ComboTypeFileImport);
	DDX_Control(pDX, IDC_EDIT_FIRST_STRING, m_EdFirstString);
	DDX_Control(pDX, IDC_EDIT_COLUMN_BRAND, m_EdColBrand);
	DDX_Control(pDX, IDC_EDIT_COLUMN_NUMBER, m_edColNumber);
	DDX_Control(pDX, IDC_EDIT_COLUMN_QUANT, m_EdColQuant);
	DDX_Control(pDX, IDC_EDIT_ORDER_TO, m_edOrderTo);
	DDX_Control(pDX, IDC_EDIT_MAILS, m_EdMails);
	DDX_Control(pDX, IDC_BUTTON_LOAD_FILE, m_ButtonLoad);
	DDX_Control(pDX, IDC_EDIT_FROM_EXPORT, m_EdFromExport);
	DDX_Control(pDX, IDC_EDIT_DOG, m_EdDog);
	DDX_Control(pDX, IDC_EDIT_DEL_CODE, m_EdDelCode);

	DDX_Control(pDX, IDC_BUTTON_BRANDS, m_btShowBreand);
	DDX_Control(pDX, IDC_BUTTON_ANALOGS, m_btAnalogs_Export);
	DDX_Control(pDX, IDC_BUTTON_REPLACE, m_btAnalogsReplace);
	DDX_Control(pDX, IDC_BUTTON_ADD_ANALOGS, m_btAnalogsAdd);
	DDX_Control(pDX, IDC_STATIC_PODMENU, m_PanelReplace);
	DDX_Control(pDX, IDC_EDIT_FILE_IMPORT, m_EdFileImport);
	DDX_Control(pDX, IDC_EDIT_ATTACH, m_EdAttachFile);


	DDX_Control(pDX, IDC_CHECK_ZIP, m_btZip);
	DDX_Control(pDX, IDC_COMBO_TYPE_NAV, m_ComboNavTypeFile);
	DDX_Control(pDX, IDC_EDIT_COLUMN_QUANT2, m_EdColPrice);
	DDX_Control(pDX, IDC_EDIT_COLUMN_QUANT3, m_EdColBasePrice);
}

BEGIN_MESSAGE_MAP(CEI_PricesDlg, CDialog)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_WM_CLOSE()
	ON_CBN_SELCHANGE(IDC_COMBO_CLIENTS, &CEI_PricesDlg::OnCbnSelchangeComboClients)
	ON_BN_CLICKED(IDC_BUTTON_LOAD_FILE, &CEI_PricesDlg::OnBnClickedButtonLoadFile)
	ON_BN_CLICKED(IDC_BUTTON_NEW_CLIENT, &CEI_PricesDlg::OnBnClickedButtonNewClient)
	ON_BN_CLICKED(IDC_BUTTON_BRANDS, &CEI_PricesDlg::OnBnClickedButtonBrands)
	ON_BN_CLICKED(IDC_BUTTON_ANALOGS, &CEI_PricesDlg::OnBnClickedButtonAnalogs)
	ON_BN_CLICKED(IDC_BUTTON_REPLACE, &CEI_PricesDlg::OnBnClickedButtonReplace)
	ON_BN_CLICKED(IDC_BUTTON_ADD_ANALOGS, &CEI_PricesDlg::OnBnClickedButtonAddAnalogs)
	ON_BN_CLICKED(IDC_BUTTON_VIEW, &CEI_PricesDlg::OnBnClickedButtonView)
	ON_BN_CLICKED(IDC_BUTTON_MANUAL_LOADFILE, &CEI_PricesDlg::OnBnClickedButtonManualLoadfile)
END_MESSAGE_MAP()


// CEI_PricesDlg message handlers

BOOL CEI_PricesDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	setlocale(LC_ALL,"Russian");
	

	iStyle = _wtoi(sReadFromIni(_T("PARAMETRS"),_T("STYLE"),_T("0")));
	// Add "About..." menu item to system menu.

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
	



	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon
	
	LoadFormats();
	LoadComboClient();
	
	if(iStyle < 1)
	{
		CWnd * Win;
		Win = this->GetTopWindow();
		while(Win != NULL)
		{
			if((Win->m_hWnd != m_ComboNavTypeFile.m_hWnd)&&(Win->m_hWnd != m_ComboClients.m_hWnd)&&(m_ButtonLoad.m_hWnd != Win->m_hWnd )&&(m_edOrderTo.m_hWnd != Win->m_hWnd))
			{	
				Win->ShowWindow(0);
			}
			
			Win = Win->GetNextWindow();
		}
		CRect rec;
		m_ComboClients.GetWindowRect(rec);
		rec.left =rec.right + 10;
		rec.right = rec.left+100;
		rec.top = 10;
		rec.bottom = 30;
		m_ButtonLoad.MoveWindow(rec);

		m_ComboClients.GetWindowRect(rec);
		
		rec.left = rec.left - 3;
		rec.right = rec.right -3;
		
		rec.top = 40;
		rec.bottom = 60;

		m_edOrderTo.MoveWindow(rec);

		//m_ComboNavTypeFile
		

		GetWindowRect(rec);

		rec.right = rec.left + 350;
		rec.bottom = rec.top + 100;
		MoveWindow(rec);


	}
	if(iStyle == 1)
	{
		m_btShowBreand.ShowWindow(0);
		m_btAnalogs_Export.ShowWindow(0);
		m_btAnalogsReplace.ShowWindow(0);
		m_btAnalogsAdd.ShowWindow(0);
		m_PanelReplace.ShowWindow(0);
	}
	// TODO: Add extra initialization here

	return TRUE;  // return TRUE  unless you set the focus to a control
}

void CEI_PricesDlg::OnSysCommand(UINT nID, LPARAM lParam)
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

void CEI_PricesDlg::OnPaint()
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
HCURSOR CEI_PricesDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


void CEI_PricesDlg::OnOK()
{
	
}


void CEI_PricesDlg::CloseDatabase(void)
{
	if(dBase != NULL)
	{
		if(dBase->IsOpen())
		{
			dBase->Close();
		}
		delete(dBase);
		dBase = NULL;
	}
}

void CEI_PricesDlg::OnClose()
{
	if(!SaveDate())
	{
		return;
	}	
	CDialog::OnClose();
	CloseDatabase();
}

BOOL CEI_PricesDlg::OpenDataBase(CString* sError)
{
	BOOL bOk;
	bOk = FALSE;
	if(dBase != NULL)
	{
		CloseDatabase();
	}
	dBase = new(CDatabase);
	CString sConnect;
	try
	{
		CString sServer,sDatabase,sUser;
		sServer = sReadFromIni(_T("SERVER"),_T("NAME"),_T(""));
		sDatabase = sReadFromIni(_T("SERVER"),_T("DB"),_T(""));
		sUser = sReadFromIni(_T("SERVER"),_T("USER"),_T(""));
		sConnect.Format(_T("Driver={SQL Server};SERVER=%s;DATABASE=%s;LANGUAGE=русский;Network=DBMSSOCN;UID=%s;PWD=%s;Address=%s"),sServer,sDatabase,sUser,sUser,sServer);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		dBase->SetQueryTimeout(0);
		bOk = TRUE;
	}
	catch(CDBException * error)
	{
		if(dBase!=NULL)
		{
			if(dBase->IsOpen())
				dBase->Close();
		}
		sError->Format(_T("%s\n%s"),error->m_strError);
		error->Delete();
		delete(dBase);
		dBase = NULL;
		return FALSE;
	}
	return bOk;
}

void CEI_PricesDlg::LoadComboClient(void)
{
	long lData;
	long lSelect;		
	lData = -1;
	lSelect = 0;
	if(m_ComboClients.GetCurSel()>-1)
	{
		lData = m_ComboClients.GetCurSel();
		lData = m_ComboClients.GetItemData(lData);
	}

	while(m_ComboClients.GetCount() > 0)
	{
		m_ComboClients.DeleteString(0);
	}
	
	CString sError;
	CString sSQL;
	if(!OpenDataBase(&sError))
	{
		AfxMessageBox(sError);
		return;
	}
	try
	{
		CDBVariant dbVar;
		sSQL.Format(_T("select NAME,id from dbo.CLIENTS order by NAME"));
		CRecordset Query(dBase);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		short i;
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			i = m_ComboClients.AddString(GetValue(&dbVar));
			Query.GetFieldValue(1,dbVar);
			if(lData == GetValueID(&dbVar))
			{
				lSelect = i;
			}
			m_ComboClients.SetItemData(i,GetValueID(&dbVar));
			Query.MoveNext();		
		}
		Query.Close();
	}
	catch(CDBException * error)
	{
		AfxMessageBox(sSQL+_T("\n")+error->m_strError);
		CloseDatabase();
		return ;
	}
	//lSelect
	if(m_ComboClients.GetCount()>0)
	{
		m_ComboClients.SetCurSel(lSelect);
		OnCbnSelchangeComboClients();
	}
}

void CEI_PricesDlg::OnCbnSelchangeComboClients()
{
	if(!SaveDate())
	{
		return;
	}	
	long lData;
	lData = -1;
	
	if(m_ComboClients.GetCurSel()>-1)
	{
		lData = m_ComboClients.GetCurSel();
		lData = m_ComboClients.GetItemData(lData);
	}
	if(lData < 1)
		return;

	LoadClientData(lData);

	
}

void CEI_PricesDlg::LoadFormats(void)
{
	while(m_ComboFormats.GetCount() > 0)
		m_ComboFormats.DeleteString(0);

	while(m_ComboTypeExport.GetCount() > 0)
		m_ComboTypeExport.DeleteString(0);

	while(m_ComboTypeOrder.GetCount() > 0)
		m_ComboTypeOrder.DeleteString(0);

	while(m_ComboCyrrency.GetCount() > 0)
		m_ComboCyrrency.DeleteString(0);
//m_ComboDelivery
	while(m_ComboDelivery.GetCount() > 0)
		m_ComboDelivery.DeleteString(0);

	while(m_ComboTypeFileImport.GetCount() > 0)
		m_ComboTypeFileImport.DeleteString(0);
	//m_ComboTypeFileImport

	while(m_ComboNavTypeFile.GetCount() > 0)
		m_ComboNavTypeFile.DeleteString(0);
	
	
	
	
	CString sError;
	CString sSQL;
	if(!OpenDataBase(&sError))
	{
		AfxMessageBox(sError);
		return;
	}
	try
	{
		CRecordset Query(dBase);
		CDBVariant dbVar;

		sSQL.Format(_T("SELECT name,VALUE FROM [CLIENTS_SYS_PARAM] where type = 1 order by name"));
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		short i;
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			i = m_ComboFormats.AddString(GetValue(&dbVar));
			Query.GetFieldValue(1,dbVar);
			m_ComboFormats.SetItemData(i,GetValueID(&dbVar));
			Query.MoveNext();		
		}
		Query.Close();

		//m_ComboTypeExport
		sSQL.Format(_T("SELECT name,VALUE FROM [CLIENTS_SYS_PARAM] where type = 2 order by name"));
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			i = m_ComboTypeExport.AddString(GetValue(&dbVar));
			Query.GetFieldValue(1,dbVar);
			m_ComboTypeExport.SetItemData(i,GetValueID(&dbVar));
			Query.MoveNext();		
		}
		Query.Close();

		sSQL.Format(_T("SELECT name,ID FROM [CLIENTS_SYS_PARAM] where type = 3 order by name"));
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			i = m_ComboTypeOrder.AddString(GetValue(&dbVar));
			Query.GetFieldValue(1,dbVar);
			m_ComboTypeOrder.SetItemData(i,GetValueID(&dbVar));
			Query.MoveNext();		
		}
		Query.Close();
		
		sSQL.Format(_T("SELECT name,VALUE FROM [CLIENTS_SYS_PARAM] where type = 4 order by name"));
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			i = m_ComboCyrrency.AddString(GetValue(&dbVar));
			Query.GetFieldValue(1,dbVar);
			m_ComboCyrrency.SetItemData(i,GetValueID(&dbVar));
			Query.MoveNext();		
		}
		Query.Close();

		//m_ComboDelivery

		sSQL.Format(_T("SELECT name,ID FROM [CLIENTS_SYS_PARAM] where type = 5 order by name"));
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			i = m_ComboDelivery.AddString(GetValue(&dbVar));
			Query.GetFieldValue(1,dbVar);
			m_ComboDelivery.SetItemData(i,GetValueID(&dbVar));
			Query.MoveNext();		
		}
		Query.Close();

		sSQL.Format(_T("SELECT name,VALUE FROM [CLIENTS_SYS_PARAM] where type = 6 order by name"));
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			i = m_ComboTypeFileImport.AddString(GetValue(&dbVar));
			Query.GetFieldValue(1,dbVar);
			m_ComboTypeFileImport.SetItemData(i,GetValueID(&dbVar));
			Query.MoveNext();		
		}
		Query.Close();

		/*
		m_ComboNavTypeFile
		*/
		sSQL.Format(_T("SELECT name,VALUE FROM [CLIENTS_SYS_PARAM] where type = 7 order by name"));
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			i = m_ComboNavTypeFile.AddString(GetValue(&dbVar));
			Query.GetFieldValue(1,dbVar);
			m_ComboNavTypeFile.SetItemData(i,GetValueID(&dbVar));
			Query.MoveNext();		
		}
		Query.Close();
		

	}
	catch(CDBException * error)
	{
		AfxMessageBox(sSQL+_T("\n")+error->m_strError);
		CloseDatabase();
		return ;
	}
	

}

void CEI_PricesDlg::OnBnClickedButtonLoadFile()
{
	ExecuteRun(true, false);
}

BOOL CEI_PricesDlg::Import_XLS_Vendors(CString sFileName, CString sFileOUT)
{
	CString sError;
	CString sSQL;
	if(!OpenDataBase(&sError))
	{
		AfxMessageBox(sError);
		return FALSE;
	}

	BOOL bOk = TRUE;
	Excel::_ApplicationPtr appExcel;
	try
	{
		appExcel.CreateInstance(_T("Excel.Application"));
		if(appExcel == NULL)
		{
			AfxMessageBox(GetLastErrorText());
			return FALSE;
		}
	}
	catch(_com_error& er) 
	{
		CString sError;
		sError.Format(_T("Error : %08lX - %s %s %s\n"),er.Error(),(LPCTSTR)_bstr_t(er.ErrorMessage()),(LPCTSTR)_bstr_t(er.Description()),(LPCTSTR)_bstr_t(er.Source()));
		AfxMessageBox(sError, MB_OK,0);
		return FALSE;
	}
	
	VARIANT bTRUE;
	bTRUE.vt = 11;
	bTRUE.boolVal = TRUE;
		
	try
	{
		Excel::WorkbooksPtr ExcelBooks;
		Excel::_WorkbookPtr ExcelBook,ExcelBook2;
		Excel::_WorksheetPtr ExcelSheet,ExcelSheet2;
		Excel::RangePtr range;

		appExcel->Visible[0] = FALSE;
		ExcelBook= appExcel->Workbooks->Open(sFileName.AllocSysString());
		ExcelSheet = ExcelBook->Worksheets->Item[1];

		ExcelBook2= appExcel->Workbooks->Add();
		ExcelSheet2 = ExcelBook2->Worksheets->Item[1];
	
		int iString;
		iString = iFirstString;
		CString sNumber,sBrand,sQuant;
		CString sNumberOld,sBrandOld;

		VARIANT arr;
		int iNewString;
		int iRow;
		iRow = 0;
		long rgIndices [2];
		VARIANT pvData; 
		CString sValue;
		while(iString < 65537)
		{
			if(iRow % 500 == 0)
			{
				 arr.vt = VT_ARRAY | VT_VARIANT;
				{
					SAFEARRAYBOUND sab[2];
					sab[0].lLbound = 1; 
					sab[0].cElements = 500;
					sab[1].lLbound = 1; 
					sab[1].cElements = 4;
					arr.parray = SafeArrayCreate(VT_VARIANT, 2, sab);
				}
			}
			iRow++;

			_variant_t value;
			range = ExcelSheet->GetRange(ExcelSheet->Cells->Item[iString,iColNumber],ExcelSheet->Cells->Item[iString,iColNumber]);
			value = range->NumberFormat;
				
			sNumber = ExcelSheet->Cells->Item[iString,iColNumber];
			sBrand = ExcelSheet->Cells->Item[iString,iColBrand];
			sNumberOld = sNumber;
			sBrandOld = sBrand;
			sQuant = ExcelSheet->Cells->Item[iString,iColQuant];
			if(sNumber.GetLength()<1)
				break;
				
			if(!GetOurBrand(&sBrand))
			{
				bOk = FALSE;
				break;
			}
				
			if(!GetOurCode(&sBrand, &sNumber))
			{
				bOk = FALSE;
				break;
			}
			
			sNumberOld.Format(_T("A%d:Z%d"),iString,iString);
			try
			{
				CRecordset Query(dBase);
				CDBVariant dbVar;
				sNumber.Replace(_T("'"),_T("''"));
				sBrand.Replace(_T("'"),_T("''"));
				sSQL.Format(_T("select top 1 ART_ARTICLE_NR,SHATE_NAME from ARTICLES left join BRANDS on BRANDS.ID = ART_SUP_ID where ART_ARTICLE_SHORT = '%s' and SHATE_NAME = '%s' AND ARTICLES.CAT_ID = 3"),ReplaceLeftSymbol(sNumber),sBrand);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				short i;
				if(!Query.IsEOF())
				{
					i = 0;
					Query.GetFieldValue(i,dbVar);
					sNumber = GetValue(&dbVar);
					i = 1;
					Query.GetFieldValue(i,dbVar);
					sBrand = GetValue(&dbVar);
					ExcelSheet->Range[sNumberOld.AllocSysString()]->Interior->Color=RGB(0,255,0);
				}
				else
				{
					sNumber.Replace(_T("''"),_T("'"));
					sBrand.Replace(_T("''"),_T("'"));
					ExcelSheet->Range[sNumberOld.AllocSysString()]->Interior->Color=RGB(255,0,0);
				}
				Query.Close();

				rgIndices[0] = iRow % 500;
				rgIndices[1] = 1; 
                pvData.bstrVal = sNumber.AllocSysString();
				pvData.vt = VT_BSTR;
				SafeArrayPutElement (arr.parray, rgIndices, (void **) &pvData); 
            
				rgIndices[0] = iRow % 500;
				rgIndices[1] = 2; 
				pvData.bstrVal = sQuant.AllocSysString();
				pvData.vt = VT_BSTR;
				SafeArrayPutElement (arr.parray, rgIndices, (void **) &pvData); 

				rgIndices[0] = iRow % 500;
				rgIndices[1] = 3; 
				pvData.bstrVal = sBrand.AllocSysString();
				pvData.vt = VT_BSTR;
				SafeArrayPutElement (arr.parray, rgIndices, (void **) &pvData); 


				sBrand = _T("V1");
				rgIndices[0] = iRow % 500;
				rgIndices[1] = 4; 
				pvData.bstrVal = sBrand.AllocSysString();
				pvData.vt = VT_BSTR;
                    
				SafeArrayPutElement (arr.parray, rgIndices, (void **) &pvData);

				if(iRow % 500 == 0)
				{
					try
					{
						range = ExcelSheet2->GetRange(ExcelSheet2->Cells->Item[iRow-500+1,1],ExcelSheet2->Cells->Item[iRow,4]);						
						sValue = _T("@");
						range->NumberFormat = sValue.AllocSysString();
						range->Value2=arr;
						VariantClear(&arr);
					}
					catch(_com_error& er) 
					{			
						CString sError;
						sError.Format(_T("Error : %08lX - %s %s %s\n"),er.Error(),(LPCTSTR)_bstr_t(er.ErrorMessage()),(LPCTSTR)_bstr_t(er.Description()),(LPCTSTR)_bstr_t(er.Source()));
						AfxMessageBox(sError, MB_OK,0);
						break;
					}
				}


			}
			catch(CDBException * error)
			{
				AfxMessageBox(sSQL+_T("\n")+error->m_strError);
			}
			iString++;
		}
		if(iRow % 500 != 0)
		{
			try
			{
				range = ExcelSheet2->GetRange(ExcelSheet2->Cells->Item[iRow-iRow % 500+1,1],ExcelSheet2->Cells->Item[iRow,4]);
				sValue = _T("@");
				range->NumberFormat = sValue.AllocSysString();
				range->Value2=arr;
				VariantClear(&arr);
			}
			catch(_com_error& er) 
			{			
				CString sError;
				sError.Format(_T("Error : %08lX - %s %s %s\n"),er.Error(),(LPCTSTR)_bstr_t(er.ErrorMessage()),(LPCTSTR)_bstr_t(er.Description()),(LPCTSTR)_bstr_t(er.Source()));
				AfxMessageBox(sError, MB_OK,0);
			}
		}

		sValue = "";
		pvData.bstrVal = sValue.AllocSysString();
		pvData.vt = VT_BSTR;
		ExcelBook2->SaveAs(sFileOUT.AllocSysString(),Excel::xlAddIn8,pvData,pvData,NULL,NULL,Excel::XlSaveAsAccessMode::xlNoChange,NULL,NULL,NULL,NULL,0);
		appExcel->Visible[0] = TRUE;
	}
	catch(_com_error& er) 
	{
		CString sError;
		appExcel->Quit();
		sError.Format(_T("Error : %08lX - %s %s %s\n"),er.Error(),(LPCTSTR)_bstr_t(er.ErrorMessage()),(LPCTSTR)_bstr_t(er.Description()),(LPCTSTR)_bstr_t(er.Source()));
		AfxMessageBox(sError, MB_OK,0);
		return FALSE;
	}		
	return bOk;
}

BOOL CEI_PricesDlg::Import_XLS(CString sFileName, long lRandom, CStdioFile *File, bool aShowMail)
{
	setlocale(LC_ALL,"Russian");
	CString sError;
	CString sSQL;
	if(!OpenDataBase(&sError))
	{
		AfxMessageBox(sError);
		return FALSE;
	}

	
	CString sType, sCurr, sDelyv;
	try
	{
		CRecordset Query(dBase);
		CDBVariant dbVar;
		sSQL.Format(_T("SELECT [VALUE] FROM [CLIENTS_SYS_PARAM] where id = %d"),iTypeOrder);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		short i;
		if(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			sType = GetValue(&dbVar);
			Query.Close();
		}
		else
		{
			Query.Close();
			return FALSE;
		}

		sCurr.Format(_T("%d"),iCurrency);
		sSQL.Format(_T("SELECT [VALUE] FROM [CLIENTS_SYS_PARAM] where id = %d"),iDelivery);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		
		if(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			sDelyv = GetValue(&dbVar);
			Query.Close();
		}
		else
		{
			Query.Close();
			return FALSE;
		}
		
	}
	catch(CDBException * error)
	{
		AfxMessageBox(sSQL+_T("\n")+error->m_strError);
		CloseDatabase();
		return FALSE;
	}

		CString sWrite;
		CString sDate;
		m_EdDate.GetWindowTextW(sDate);

		if(iDelivery == 11)
			sWrite.Format(_T("%s;%s;%d;%s;%s;%s;;NAV;%s;%s;1\n"),sCodeProgramm,sDate,lRandom,sType,sCurr,sDelyv,sDog,sDelCode);
		else
			sWrite.Format(_T("%s;%s;%d;%s;%s;%s;;NAV;%s;%s;\n"),sCodeProgramm,sDate,lRandom,sType,sCurr,sDelyv,sDog,sDelCode);
		File->WriteString(sWrite);

	BOOL bOk = TRUE;
	
		Excel::_ApplicationPtr appExcel;
		try
		{

			appExcel.CreateInstance(_T("Excel.Application"));
			if(appExcel == NULL)
			{
				AfxMessageBox(GetLastErrorText());
				return FALSE;
			}
		}
		catch(_com_error& er) 
		{
			CString sError;
			sError.Format(_T("Error : %08lX - %s %s %s\n"),er.Error(),(LPCTSTR)_bstr_t(er.ErrorMessage()),(LPCTSTR)_bstr_t(er.Description()),(LPCTSTR)_bstr_t(er.Source()));
			AfxMessageBox(sError, MB_OK,0);
			return FALSE;
		}
		VARIANT bTRUE;
		bTRUE.vt = 11;
		bTRUE.boolVal = TRUE;
		
		try
		{
			
			Excel::_WorkbookPtr ExcelBook;
			Excel::_WorksheetPtr ExcelSheet;

			Excel::_WorkbookPtr ExcelBookOutput;
			Excel::_WorksheetPtr ExcelSheetOutput;

			appExcel->Visible[0] = FALSE;
			ExcelBook = appExcel->Workbooks->Open(sFileName.AllocSysString());
			ExcelSheet = ExcelBook->Worksheets->Item[1];
	
			if (aShowMail == true)
			{
				ExcelBookOutput = appExcel->Workbooks->Add();
				ExcelSheetOutput = ExcelBookOutput->Worksheets->Item[1];
			}

			int iString;
			iString = iFirstString;
			CString sNumber,sBrand,sQuant;
			CString sNumberOld,sBrandOld;
			int ExcelRowIndex;
			ExcelRowIndex = 1;

			while(iString < 65537)
			{
				sNumber = ExcelSheet->Cells->Item[iString,iColNumber];
				
				sBrand = ExcelSheet->Cells->Item[iString,iColBrand];
				sNumberOld = sNumber;
				sBrandOld = sBrand;
				sQuant = ExcelSheet->Cells->Item[iString,iColQuant];
				if(sNumber.GetLength()<1)
					break;
				
				if(!GetOurBrand(&sBrand))
				{
					bOk = FALSE;
					break;
				}
				
				if(!GetOurCode(&sBrand, &sNumber))
				{
					bOk = FALSE;
					break;
				}
				
				bool isFind;

				sNumberOld.Format(_T("A%d:Z%d"),iString,iString);
				try
				{
					CRecordset Query(dBase);
					CDBVariant dbVar;
					sNumber.Replace(_T("'"),_T("''"));
					sBrand.Replace(_T("'"),_T("''"));
					sSQL.Format(_T("select top 1 ART_ARTICLE_NR,SHATE_NAME from ARTICLES left join BRANDS on BRANDS.ID = ART_SUP_ID where ART_ARTICLE_SHORT = '%s' and SHATE_NAME = '%s' AND ARTICLES.CAT_ID = 3"),ReplaceLeftSymbol(sNumber),sBrand);
					Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
					short i;
					if(!Query.IsEOF())
					{
						i = 0;
						Query.GetFieldValue(i,dbVar);
						sNumber = GetValue(&dbVar);
						i = 1;
						Query.GetFieldValue(i,dbVar);
						sBrand = GetValue(&dbVar);
						ExcelSheet->Range[sNumberOld.AllocSysString()]->Interior->Color=RGB(0,255,0);
						
						if (aShowMail == false)
						{

							CString tmpServiceProgUserID = sCodeProgramm;
							CString tmpAgreementNo = sDog;
							CString tmpCurrency;

							int iCurr = m_ComboCyrrency.GetCurSel();
							m_ComboCyrrency.GetLBText(iCurr, tmpCurrency);
							if (tmpCurrency == "RUR")
							{
								tmpCurrency.Empty();
								tmpCurrency.Format(_T("%s"), _T("RUB"));
							};
							if (tmpCurrency == "EUR")
							{
								tmpCurrency.Empty();
								tmpCurrency.Format(_T("%s"), _T(""));
							};

							LPTSTR pszItemNo2 = sNumber.GetBuffer(sNumber.GetLength() * 2);
							LPTSTR pszTMName = sBrand.GetBuffer(sBrand.GetLength() * 2);
							LPTSTR pszServiceProgUserID = tmpServiceProgUserID.GetBuffer(tmpServiceProgUserID.GetLength() * 2);
							LPTSTR pszAgreementNo = tmpAgreementNo.GetBuffer(tmpAgreementNo.GetLength() * 2);
							LPTSTR pszCurrency = tmpCurrency.GetBuffer(tmpCurrency.GetLength() * 2);

							USES_CONVERSION;
							char* tmpCharsItemNo2 = T2A(pszItemNo2);
							char* tmpCharsTMName = T2A(pszTMName);
							char* tmpCharsServiceProgUserID = T2A(pszServiceProgUserID);
							char* tmpCharsAgreementNo = T2A(pszAgreementNo);
							char* tmpCharsCurrency = T2A(pszCurrency);

							char *Err = new char[1000];
							ZeroMemory(Err, 1000);
							char *NavPrice = new char[100];
							ZeroMemory(NavPrice, 100);
							int tmpResult = GetItemPrice(tmpCharsItemNo2, tmpCharsTMName, tmpCharsServiceProgUserID, tmpCharsAgreementNo, tmpCharsCurrency, NavPrice, Err);
							if (tmpResult == -1){
								((Excel::RangePtr)ExcelSheet->Cells->Item[iString, iColPrice])->FormulaR1C1 = Err;
							}else{
								((Excel::RangePtr)ExcelSheet->Cells->Item[iString, iColPrice])->FormulaR1C1 = NavPrice;
							}

							sNumber.ReleaseBuffer(sNumber.GetLength() * 2);
							sBrand.ReleaseBuffer(sBrand.GetLength() * 2);
							tmpServiceProgUserID.ReleaseBuffer(tmpServiceProgUserID.GetLength() * 2);
							tmpAgreementNo.ReleaseBuffer(tmpAgreementNo.GetLength() * 2);
							tmpCurrency.ReleaseBuffer(tmpCurrency.GetLength() * 2);

							CString tmpValue1 = ((Excel::RangePtr)ExcelSheet->Cells->Item[iString, iColBasePrice])->FormulaR1C1;
							
							LPTSTR pszValue1 = tmpValue1.GetBuffer(tmpValue1.GetLength() * 2);

							char* tmpCharsValue1 = T2A(pszValue1);

							ZeroMemory(Err, 1000);
							char *PriceRatio = new char[100];
							ZeroMemory(PriceRatio, 100);
							tmpResult = GetPriceRatio(tmpCharsValue1, NavPrice, PriceRatio, Err);
							
							if (tmpResult == -1){
								((Excel::RangePtr)ExcelSheet->Cells->Item[iString, iColPrice + 1])->FormulaR1C1 = Err;
							}else{
								((Excel::RangePtr)ExcelSheet->Cells->Item[iString, iColPrice + 1])->FormulaR1C1 = PriceRatio;
							}

							tmpValue1.ReleaseBuffer(tmpValue1.GetLength() * 2);
						}
						isFind = true;
					}
					else
					{
						sNumber.Replace(_T("''"),_T("'"));
						sBrand.Replace(_T("''"),_T("'"));
						ExcelSheet->Range[sNumberOld.AllocSysString()]->Interior->Color=RGB(255,0,0);
						isFind = false;
					}

				Query.Close();
		
		
				}
				catch(CDBException * error)
				{
					AfxMessageBox(sSQL+_T("\n")+error->m_strError);
				}

				if (aShowMail == false)
				{
					CString tmpWrite;
					tmpWrite.Format(_T("%s_%s;%s\n"), sNumber, sBrand, sQuant);
					File->WriteString(tmpWrite);
				}
				else
				{
					CString tmpValue1 = ((Excel::RangePtr)ExcelSheet->Cells->Item[iString, iColBasePrice])->FormulaR1C1;
					
					CString tmpStringNumber;
					CString tmpStringBrand;
					tmpStringNumber.Format(_T("'%s"), sNumber);
					tmpStringBrand.Format(_T("'%s"), sBrand);

					((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 1])->FormulaR1C1 = tmpStringNumber.AllocSysString();
					((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 2])->FormulaR1C1 = sQuant.AllocSysString();
					((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 4])->FormulaR1C1 = tmpStringBrand.AllocSysString();
					((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 5])->FormulaR1C1 = tmpValue1.AllocSysString();
					if (isFind == false)
					{
						((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 1])->Interior->Color = RGB(255, 0, 0);
						((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 2])->Interior->Color = RGB(255, 0, 0);
						((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 3])->Interior->Color = RGB(255, 0, 0);
						((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 4])->Interior->Color = RGB(255, 0, 0);
						((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 5])->Interior->Color = RGB(255, 0, 0);
					}
					else
					{
						((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 1])->Interior->Color = RGB(0, 255, 0);
						((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 2])->Interior->Color = RGB(0, 255, 0);
						((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 3])->Interior->Color = RGB(0, 255, 0);
						((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 4])->Interior->Color = RGB(0, 255, 0);
						((Excel::RangePtr)ExcelSheetOutput->Cells->Item[ExcelRowIndex, 5])->Interior->Color = RGB(0, 255, 0);
					}
				}
				iString++;
				ExcelRowIndex++;
				
			}
			//ExcelBook->Save();
			
			if (aShowMail == true)
				ExcelBook->Close(false);

			appExcel->Visible[0] = TRUE;

		}
		catch(_com_error& er) 
		{
			CString sError;
			appExcel->Quit();
			sError.Format(_T("Error : %08lX - %s %s %s\n"),er.Error(),(LPCTSTR)_bstr_t(er.ErrorMessage()),(LPCTSTR)_bstr_t(er.Description()),(LPCTSTR)_bstr_t(er.Source()));
			AfxMessageBox(sError, MB_OK,0);
			return FALSE;
		}		
	return bOk;
}

BOOL CEI_PricesDlg::GetOurBrand(CString * sBrand)
{
	CString sNewBrand;
	sNewBrand = *sBrand;
	CString sSQL;
	try
	{
		CRecordset Query(dBase);
		CDBVariant dbVar;
		sNewBrand.Replace(_T("'"),_T("''"));
		
		sSQL.Format(_T("SELECT top 1 [BRAND] FROM [REBRAND] where [BRAND_EXPORT] = '%s' and CLI_ID = %d"),sNewBrand,lID_Client);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		short i;
		if(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			sBrand->Format(_T("%s"),GetValue(&dbVar));
		}
		Query.Close();
	}
	catch(CDBException * error)
	{
		AfxMessageBox(sSQL+_T("\n")+error->m_strError);
		CloseDatabase();
		return FALSE;
	}

	return TRUE;
}

BOOL CEI_PricesDlg::GetOurCode(CString* sBrand, CString* sCode)
{
	CString sNewBrand;
	sNewBrand = *sBrand;
	CString sSQL;
	try
	{
		CRecordset Query(dBase);
		CDBVariant dbVar;
		sNewBrand.Replace(_T("'"),_T("''"));
		
		sSQL.Format(_T("SELECT top 1 CODE FROM [RECODE] where BRAND = '%s'AND [CODE_EXPORT] = '%s' and CLI_ID = %d"),sNewBrand,*sCode,lID_Client);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		short i;
		if(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			sCode->Format(_T("%s"),GetValue(&dbVar));
		}
		Query.Close();
	}
	catch(CDBException * error)
	{
		AfxMessageBox(sSQL+_T("\n")+error->m_strError);
		CloseDatabase();
		return FALSE;
	}

	return TRUE;
}
BOOL CEI_PricesDlg::SaveDate(void)
{
	if(iStyle < 1)
		return TRUE;

	if(lID_Client < 1)
		return TRUE;

	BOOL bSave;
	bSave = FALSE;
	CString sFields;
	CString sDate;
	m_EdName.GetWindowText(sDate);
	sFields = "";
	
	if(sName != sDate)
	{
		bSave = TRUE;
		sDate.Replace(_T("'"),_T("''"));
		sFields = sFields + _T(", NAME = '")+ sDate+_T("'");
	}
	
	m_EdFrom.GetWindowText(sDate);
	if(sDate != sFrom)
	{
		bSave = TRUE;
		sDate.Replace(_T("'"),_T("''"));
		sFields = sFields + _T(", [FROM] = '")+ sDate+_T("'");
	}

	m_EdErrorMail.GetWindowText(sDate);
	if(sDate != sERROR_MAIL)
	{
		bSave = TRUE;
		sDate.Replace(_T("'"),_T("''"));
		sFields = sFields + _T(", [ERROR_MAIL] = '")+ sDate+_T("'");
	}

	m_EdSubject.GetWindowText(sDate);
	if(sDate != sSubject)
	{
		bSave = TRUE;
		sDate.Replace(_T("'"),_T("''"));
		sFields = sFields + _T(", [SUBJECT] = '")+ sDate+_T("'");
	}


	m_EdAttachFile.GetWindowText(sDate);
	if(sDate != sAttach)
	{
		bSave = TRUE;
		sDate.Replace(_T("'"),_T("''"));
		sFields = sFields + _T(", [AT_NAME] = '")+ sDate+_T("'");
	}

	if(m_btZip.GetCheck())
	{
		sDate = _T("1");
	}
	else
	{
		sDate = _T("0");
	}

	if(sDate != sArchiv)
	{
		bSave = TRUE;
		sFields = sFields + _T(", [ARCHIV] = ")+ sDate;
	}

	m_EdCodeProgramm.GetWindowText(sDate);
	if(sDate != sCodeProgramm)
	{
		bSave = TRUE;
		sDate.Replace(_T("'"),_T("''"));
		sFields = sFields + _T(", [CODE_PROGRAMM] = '")+ sDate+_T("'");
	}
	//m_EdFileImport.SetWindowTextW(sPRICE_FILE);
	m_EdFileImport.GetWindowText(sDate);
	if(sDate != sPRICE_FILE)
	{
		bSave = TRUE;
		sDate.Replace(_T("'"),_T("''"));
		sFields = sFields + _T(", [PRICE_FILE] = '")+ sDate+_T("'");
	}

	m_edOrderTo.GetWindowText(sDate);
	if(sDate != sOrderTO)
	{
		bSave = TRUE;
		sDate.Replace(_T("'"),_T("''"));
		sFields = sFields + _T(", [ORDER_TO] = '")+ sDate+_T("'");
	}
	//CString sPRICE_FILE;
	m_EdFromExport.GetWindowTextW(sDate);
	if(sFromExport != sDate)
	{
		bSave = TRUE;
		sDate.Replace(_T("'"),_T("''"));
		sFields = sFields + _T(", [FROM_EXPORT] = '")+ sDate+_T("'");
	}


	m_EdDog.GetWindowTextW(sDate);
	if(sDog != sDate)
	{
		bSave = TRUE;
		sDate.Replace(_T("'"),_T("''"));
		sFields = sFields + _T(", [DOG] = '")+ sDate+_T("'");
	}

	m_EdDelCode.GetWindowTextW(sDate);
	if(sDelCode != sDate)
	{
		bSave = TRUE;
		sDate.Replace(_T("'"),_T("''"));
		sFields = sFields + _T(", [DEL_CODE] = '")+ sDate+_T("'");
	}

	/*
	CEdit m_EdDog;
	CEdit m_EdDelCode;
	*/
	
	long lFind;
		
	lFind =	m_ComboTypeOrder.GetCurSel();
	if(lFind > -1)
	if(m_ComboTypeOrder.GetItemData(lFind) != iTypeOrder)
	{
		bSave = TRUE;
		sDate.Format(_T("%d"),m_ComboTypeOrder.GetItemData(lFind));
		sFields = sFields + _T(", [TYPEORDER] = ")+ sDate;
	}
	
	lFind =	m_ComboCyrrency.GetCurSel();
	if(lFind > -1)
	if(m_ComboCyrrency.GetItemData(lFind) != iCurrency)
	{
		bSave = TRUE;
		sDate.Format(_T("%d"),m_ComboCyrrency.GetItemData(lFind));
		sFields = sFields + _T(", [CURRENCY] = ")+ sDate;
	}
	lFind =	m_ComboDelivery.GetCurSel();
	if(lFind > -1)
	if(m_ComboDelivery.GetItemData(lFind) != iDelivery)
	{
		bSave = TRUE;
		sDate.Format(_T("%d"),m_ComboDelivery.GetItemData(lFind));
		sFields = sFields + _T(", [DELIVERY] = ")+ sDate;
	}
	lFind =	m_ComboTypeFileImport.GetCurSel();
	if(lFind > -1)
	if(m_ComboTypeFileImport.GetItemData(lFind) != iImportTypeFile)
	{
		bSave = TRUE;
		sDate.Format(_T("%d"),m_ComboTypeFileImport.GetItemData(lFind));
		sFields = sFields + _T(", [IMPORT_TYPE_FILE] = ")+ sDate;
	}
	//m_ComboNavTypeFile

	lFind =	m_ComboNavTypeFile.GetCurSel();
	if(lFind > -1)
	if(m_ComboNavTypeFile.GetItemData(lFind) != iNavTypeFile)
	{
		bSave = TRUE;
		sDate.Format(_T("%d"),m_ComboNavTypeFile.GetItemData(lFind));
		sFields = sFields + _T(", [IMPORT_NAV_TYPE] = ")+ sDate;
	}
	
	lFind =	m_ComboTypeExport.GetCurSel();
	if(lFind > -1)
	if(m_ComboTypeExport.GetItemData(lFind) != lEXPORT_TYPE)
	{
		bSave = TRUE;
		sDate.Format(_T("%d"),m_ComboTypeExport.GetItemData(lFind));
		sFields = sFields + _T(", [EXPORT_TYPE] = ")+ sDate;
	}

	lFind =	m_ComboFormats.GetCurSel();
	if(lFind > -1)
	if(m_ComboFormats.GetItemData(lFind) != lEXPORT_FILE_TYPE)
	{
		bSave = TRUE;
		sDate.Format(_T("%d"),m_ComboFormats.GetItemData(lFind));
		sFields = sFields + _T(", [EXPORT_FILE_TYPE] = ")+ sDate;
	}
	
	m_EdFirstString.GetWindowText(sDate);
	if((_wtoi(sDate) != iFirstString)&&(_wtoi(sDate)>0))
	{
		bSave = TRUE;
		sDate.Format(_T("%d"),_wtoi(sDate));
		sFields = sFields + _T(", [FIRST_STRING] = ")+ sDate;
	}

	m_EdColBrand.GetWindowText(sDate);
	if((_wtoi(sDate) != iColBrand)&&(_wtoi(sDate)>0))
	{
		bSave = TRUE;
		sDate.Format(_T("%d"),_wtoi(sDate));
		sFields = sFields + _T(", [COL_BRAND] = ")+ sDate;
	}
	
	m_edColNumber.GetWindowText(sDate);
	if((_wtoi(sDate) != iColNumber)&&(_wtoi(sDate)>0))
	{
		bSave = TRUE;
		sDate.Format(_T("%d"),_wtoi(sDate));
		sFields = sFields + _T(", [COL_NUMBER] = ")+ sDate;
	}
	
	m_EdColQuant.GetWindowText(sDate);
	if((_wtoi(sDate) != iColQuant)&&(_wtoi(sDate)>0))
	{
		bSave = TRUE;
		sDate.Format(_T("%d"),_wtoi(sDate));
		sFields = sFields + _T(", [COL_QUANT] = ")+ sDate;
	}

	m_EdColPrice.GetWindowText(sDate);
	if ((_wtoi(sDate) != iColPrice) && (_wtoi(sDate) > 0))
	{
		bSave = TRUE;
		sDate.Format(_T("%d"), _wtoi(sDate));
		sFields = sFields + _T(", [COL_PRICE] = ") + sDate;
	}
	m_EdColBasePrice.GetWindowText(sDate);
	if ((_wtoi(sDate) != iColBasePrice) && (_wtoi(sDate) > 0))
	{
		bSave = TRUE;
		sDate.Format(_T("%d"), _wtoi(sDate));
		sFields = sFields + _T(", [COL_BASEPRICE] = ") + sDate;
	}

	if(!bSave)
	{
		return TRUE;
	}

	if(AfxMessageBox(_T("Сохранить изменения?"),MB_YESNO,IDNO)==IDYES)
	{
		CString sError;
		CString sSQL;
		if(!OpenDataBase(&sError))
		{
			AfxMessageBox(sError);
			return FALSE;
		}

		try
		{
			sFields = sFields.Right(sFields.GetLength()-1);
			CDBVariant dbVar;
			sSQL.Format(_T("UPDATE CLIENTS SET %s WHERE ID = %d"),sFields,lID_Client);
			dBase->ExecuteSQL(sSQL);
		}
		catch(CDBException * error)
		{
			AfxMessageBox(sSQL+_T("\n")+error->m_strError);
			CloseDatabase();
			return FALSE;
		}
		LoadClientData(lID_Client);
	
	}
	return TRUE;
}

void CEI_PricesDlg::OnStnDblclickStaticMailsClint()
{
	CString sError;
	if(!OpenDataBase(&sError))
		{
			AfxMessageBox(sError);
			return;
		}
	CDLGEmails dialog;	 
	dialog.dBase = dBase;
	dialog.lID_Client = lID_Client;
	dialog.DoModal();
	CString sSQL;
	try
	{
		
		CRecordset Query(dBase);
		sSQL.Format(_T("SELECT [EMAIL] FROM [CLIENTS_EMAILS] WHERE CLI_ID  = %d"),lID_Client);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		sSQL = "";
		short i;
		CDBVariant dbVar;
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			sSQL = sSQL+GetValue(&dbVar)+_T(", ");
			Query.MoveNext();
		}
		Query.Close();
		if(sSQL.GetLength() > 2)
			sSQL = sSQL.Left(sSQL.GetLength()-2);
		m_EdMails.SetWindowTextW(sSQL);
	}
	catch(CDBException * error)
		{
			AfxMessageBox(sSQL+_T("\n")+error->m_strError);
			CloseDatabase();
			return;
		}
}

BOOL CEI_PricesDlg::PreTranslateMessage(MSG* pMsg)
{
	if(pMsg->message == WM_LBUTTONDBLCLK)
	{
		if((pMsg->hwnd == m_EdMails.m_hWnd))
		{
			OnStnDblclickStaticMailsClint();
			return TRUE;
		}
	}
	return CDialog::PreTranslateMessage(pMsg);
}

void CEI_PricesDlg::OnBnClickedButtonNewClient()
{
	SaveDate();
	
	CDlgNewProject dialog;
	if(dialog.DoModal()!=IDOK)
		return;

	
	CString sError;
	if(!OpenDataBase(&sError))
		{
			AfxMessageBox(sError);
			return;
		}
	CString sSQL;
	try
	{
		
		dialog.sNewProjectName.Replace(_T("'"),_T("''"));
		CRecordset Query(dBase);
		sSQL.Format(_T("SELECT ID FROM [CLIENTS] WHERE [NAME] = '%s' "),dialog.sNewProjectName);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		sSQL = "";
		
		CDBVariant dbVar;
		if(!Query.IsEOF())
		{
			Query.Close();
			
			AfxMessageBox(_T("Уже занято - ")+dialog.sNewProjectName+_T("!"));
			return;
		}
		Query.Close();

		sSQL.Format(_T("if(not exists (select id from CLIENTS where name = '%s')) INSERT INTO [CLIENTS]([NAME]) VALUES ('%s')"),dialog.sNewProjectName,dialog.sNewProjectName);
		dBase->ExecuteSQL(sSQL);
	}
	catch(CDBException * error)
		{
			AfxMessageBox(sSQL+_T("\n")+error->m_strError);
			CloseDatabase();
			return;
		}

	CloseDatabase();
	LoadComboClient();

	int iFind;
	iFind = m_ComboClients.FindString(-1,dialog.sNewProjectName);
	if(iFind > 0)
	{
		m_ComboClients.SetCurSel(iFind);
		OnCbnSelchangeComboClients();
	}
}

void CEI_PricesDlg::OnBnClickedButtonBrands()
{
	CString sError;
	if(!OpenDataBase(&sError))
		{
			AfxMessageBox(sError);
			return;
		}
	CDlgBrands dialog;
	dialog.dBase = dBase;
	dialog.lID_Client = lID_Client;
	dialog.DoModal();
}

void CEI_PricesDlg::OnBnClickedButtonAnalogs()
{
	if(lID_Client < 1)
		return;

	TCHAR Filter[]=_T("*.csv|*.csv|");
	CString sFile;
	CFileDialog d(FALSE,_T("*.csv"),NULL,OFN_HIDEREADONLY,Filter,NULL);
	int k=d.DoModal();
	if(k==2) return;
	sFile=d.GetPathName();
	
	CString sError;
	if(!OpenDataBase(&sError))
		{
			AfxMessageBox(sError);
			return;
		}

	CString sSQL;	
	CStdioFile oFile;
	try
	{
		
		
		if(!oFile.Open(sFile,CFile::modeCreate|CFile::modeWrite))
			return;
		CRecordset Query(dBase);
		
		sSQL.Format(_T("SELECT [BRAND],[CODE],[CODE_EXPORT] FROM [RECODE] where CLI_ID = %d"),lID_Client);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		
		short i;
		CDBVariant dbVar;

		while(!Query.IsEOF())
		{
			sSQL = "";
			i = 0;
			while(i<3)
			{
				Query.GetFieldValue(i,dbVar);
				sSQL = sSQL+_T("'")+GetValue(&dbVar)+_T("';");
				i++;
			}
			oFile.WriteString(sSQL+_T("\n"));
			Query.MoveNext();
		}
		Query.Close();
		oFile.Close();
	}
	catch(CDBException * error)
		{
			AfxMessageBox(sSQL+_T("\n")+error->m_strError);
			CloseDatabase();
			oFile.Close();
			return;
		}
	AfxMessageBox(_T("Выполненно!"));
}

void CEI_PricesDlg::OnBnClickedButtonReplace()
{
	if(lID_Client < 1)
		return;

	TCHAR Filter[]=_T("*.csv|*.csv|");
	CString sFile;
	CFileDialog d(TRUE,_T("*.csv"),NULL,OFN_HIDEREADONLY,Filter,NULL);
	int k=d.DoModal();
	if(k==2) return;
	sFile=d.GetPathName();
	
	CString sError;
	if(!OpenDataBase(&sError))
		{
			AfxMessageBox(sError);
			return;
		}

	CString sSQL;	
	CStdioFile oFile;
	try
	{
		sSQL.Format(_T("DELETE FROM [RECODE] where CLI_ID = %d"),lID_Client);
		if(!oFile.Open(sFile,CFile::modeRead))
			return;
		dBase->ExecuteSQL(sSQL);
		CString sData;
		//if(not exists (select id from CLIENTS where name = 'Новый клиент')) INSERT INTO [CLIENTS]([NAME]) VALUES ('Новый клиент') "))
		int iFind;
		CString sBrand, sCoDeShate, sCodeBrand;
		while(oFile.ReadString(sData))
		{
			
			if(sData.GetLength()<1)
				continue;
			sBrand = "";
			sData=sData+_T(";");
			iFind = sData.Find(_T(";"),0);
			sCodeBrand = "";
			sCoDeShate = "";

			if(iFind < 1 )
				continue;
			
			sBrand = GetFormatedBrand_Code(sData.Left(iFind));
			sData = sData.Right(sData.GetLength()-iFind-1);

			if(sBrand.GetLength()<1)
				continue;

			iFind = sData.Find(_T(";"),0);
			if(iFind < 1 )
				continue;
			sCoDeShate = GetFormatedBrand_Code(sData.Left(iFind));
			sData = sData.Right(sData.GetLength()-iFind-1);

			if(sCoDeShate.GetLength()<1)
				continue;

			iFind = sData.Find(_T(";"),0);
			if(iFind < 1 )
				continue;
			sCodeBrand = GetFormatedBrand_Code(sData.Left(iFind));
			sData = sData.Right(sData.GetLength()-iFind-1);
			if(sCodeBrand.GetLength()<1)
				continue;

			sSQL.Format(_T("if(not exists (select [CLI_ID] from RECODE where [CLI_ID] = %d AND [BRAND] = '%s' AND [CODE] = '%s' AND [CODE_EXPORT] = '%s'))  INSERT INTO [RECODE] ([CLI_ID],[BRAND],[CODE],[CODE_EXPORT]) VALUES(%d,'%s','%s','%s')"),lID_Client,sBrand,sCoDeShate,sCodeBrand,lID_Client,sBrand,sCoDeShate,sCodeBrand);
			dBase->ExecuteSQL(sSQL);
			
			

		}
		oFile.Close();
	}
	catch(CDBException * error)
		{
			AfxMessageBox(sSQL+_T("\n")+error->m_strError);
			CloseDatabase();
			oFile.Close();
			return;
		}
	AfxMessageBox(_T("Выполненно!"));
}

CString CEI_PricesDlg::GetFormatedBrand_Code(CString sCode)
{
	CString sRet;
	sRet = sCode;

	if(sRet.Left(1)==_T("'"))
	{
		sRet = sRet.Right(sRet.GetLength()-1);
	}

	if(sRet.Right(1)==_T("'"))
	{
		sRet = sRet.Left(sRet.GetLength()-1);
	}

	while(sRet.Right(1)==_T(" "))
	{
		sRet = sRet.Left(sRet.GetLength()-1);
	}

	while(sRet.Left(1)==_T(" "))
	{
		sRet = sRet.Right(sRet.GetLength()-1);
	}
	sRet.Replace(_T("'"),_T("''"));
	return sRet;
}


void CEI_PricesDlg::OnBnClickedButtonAddAnalogs()
{
	if(lID_Client < 1)
		return;

	TCHAR Filter[]=_T("*.csv|*.csv|");
	CString sFile;
	CFileDialog d(TRUE,_T("*.csv"),NULL,OFN_HIDEREADONLY,Filter,NULL);
	int k=d.DoModal();
	if(k==2) return;
	sFile=d.GetPathName();
	
	CString sError;
	if(!OpenDataBase(&sError))
		{
			AfxMessageBox(sError);
			return;
		}

	CString sSQL;	
	CStdioFile oFile;
	try
	{
		if(!oFile.Open(sFile,CFile::modeRead))
			return;

		CString sData;
		//if(not exists (select id from CLIENTS where name = 'Новый клиент')) INSERT INTO [CLIENTS]([NAME]) VALUES ('Новый клиент') "))
		int iFind;
		CString sBrand, sCoDeShate, sCodeBrand;
		while(oFile.ReadString(sData))
		{
			
			if(sData.GetLength()<1)
				continue;
			sBrand = "";
			sData=sData+_T(";");
			iFind = sData.Find(_T(";"),0);
			sCodeBrand = "";
			sCoDeShate = "";

			if(iFind < 1 )
				continue;
			
			sBrand = GetFormatedBrand_Code(sData.Left(iFind));
			sData = sData.Right(sData.GetLength()-iFind-1);

			if(sBrand.GetLength()<1)
				continue;

			iFind = sData.Find(_T(";"),0);
			if(iFind < 1 )
				continue;
			sCoDeShate = GetFormatedBrand_Code(sData.Left(iFind));
			sData = sData.Right(sData.GetLength()-iFind-1);

			if(sCoDeShate.GetLength()<1)
				continue;

			iFind = sData.Find(_T(";"),0);
			if(iFind < 1 )
				continue;
			sCodeBrand = GetFormatedBrand_Code(sData.Left(iFind));
			sData = sData.Right(sData.GetLength()-iFind-1);
			if(sCodeBrand.GetLength()<1)
				continue;

			sSQL.Format(_T("if(not exists (select [CLI_ID] from RECODE where [CLI_ID] = %d AND [BRAND] = '%s' AND [CODE] = '%s' AND [CODE_EXPORT] = '%s'))  INSERT INTO [RECODE] ([CLI_ID],[BRAND],[CODE],[CODE_EXPORT]) VALUES(%d,'%s','%s','%s')"),lID_Client,sBrand,sCoDeShate,sCodeBrand,lID_Client,sBrand,sCoDeShate,sCodeBrand);
			dBase->ExecuteSQL(sSQL);
			
			

		}
		oFile.Close();
	}
	catch(CDBException * error)
		{
			AfxMessageBox(sSQL+_T("\n")+error->m_strError);
			CloseDatabase();
			oFile.Close();
			return;
		}
	AfxMessageBox(_T("Выполненно!"));
}

void CEI_PricesDlg::LoadClientData(long lData)
{
	if(lData < 1)
		return;
	CString sSQL;
	CString sError;
	if(!OpenDataBase(&sError))
	{
		AfxMessageBox(sError);
		return;
	}

	try
	{
		CDBVariant dbVar;
		sSQL.Format(_T("select * from CLIENTS where id  = %d"),lData);
		CRecordset Query(dBase);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		short i;
		if(!Query.IsEOF())
		{
			i = 0;
			int fieldCount = Query.GetODBCFieldCount();
			while(i < fieldCount)
			{
				Query.GetFieldValue(i,dbVar);
				switch(i)
				{
					case 0:
						lID_Client = GetValueID(&dbVar);
						break;

					case 1:
						sName = GetValue(&dbVar);
						break;

					case 2:
						sFrom = GetValue(&dbVar);
						break;

					case 3:
						sERROR_MAIL = GetValue(&dbVar);
						break;

					case 4:
						lEXPORT_TYPE = GetValueID(&dbVar);
						break;

					case 5:
						lEXPORT_FILE_TYPE = GetValueID(&dbVar);
						break;

					case 6:
						sPRICE_FILE = GetValue(&dbVar);
						break;

					case 7:
						sSubject = GetValue(&dbVar);
						break;

					case 8:
						sCodeProgramm = GetValue(&dbVar);
						break;

					case 9:
						iTypeOrder = GetValueID(&dbVar);
						break;

					case 10:
						iCurrency = GetValueID(&dbVar);
						break;

					case 11:
						iDelivery = GetValueID(&dbVar);
						break;

					case 12:
						iImportTypeFile = GetValueID(&dbVar);
						break;

					case 13:
						iFirstString = GetValueID(&dbVar);
						break;

					case 14:
						iColBrand = GetValueID(&dbVar);
						break;

					case 15:
						iColNumber = GetValueID(&dbVar);
						break;

					case 16:
						iColQuant = GetValueID(&dbVar);
						break;

					case 17:
						sOrderTO = GetValue(&dbVar);
						break;

					case 18:
						sFromExport = GetValue(&dbVar);
						break;

					case 19:
						sDog = GetValue(&dbVar);
						break;

					case 20:
						sDelCode = GetValue(&dbVar);
						break;

					
					case 21:
						sAttach = GetValue(&dbVar);
						break;

					case 22:
						sArchiv = GetValue(&dbVar);
						break;

					case 23:
						iNavTypeFile = GetValueID(&dbVar);
						break;
					
					case 24:
						iColPrice = GetValueID(&dbVar);
						break;

					case 25:
						iColBasePrice = GetValueID(&dbVar);
						break;
				}
				i++;
			}
				
		}
		Query.Close();

		sSQL.Format(_T("SELECT [EMAIL] FROM [CLIENTS_EMAILS] WHERE CLI_ID  = %d"),lData);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		sSQL = "";
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			sSQL = sSQL+GetValue(&dbVar)+_T(", ");
			Query.MoveNext();
		}
		Query.Close();
		if(sSQL.GetLength() > 2)
			sSQL = sSQL.Left(sSQL.GetLength()-2);
		m_EdMails.SetWindowTextW(sSQL);
		

	}
	catch(CDBException * error)
	{
		lID_Client = 0;
		AfxMessageBox(sSQL+_T("\n")+error->m_strError);
		CloseDatabase();
		return ;
	}
	CloseDatabase();
	m_EdName.SetWindowTextW(sName);
	m_EdFrom.SetWindowTextW(sFrom);
	m_EdSubject.SetWindowTextW(sSubject);
	m_EdErrorMail.SetWindowTextW(sERROR_MAIL);
	m_EdCodeProgramm.SetWindowTextW(sCodeProgramm);
	m_EdFileImport.SetWindowTextW(sPRICE_FILE);
	m_EdAttachFile.SetWindowTextW(sAttach);

	if(sArchiv == _T("1"))
	{
		m_btZip.SetCheck(TRUE);
	}
	else
	{
		m_btZip.SetCheck(FALSE);
	}
	if(lEXPORT_TYPE > -1)
	{
		long lFind;
		lFind = 0;
		m_ComboTypeExport.SetCurSel(-1);
		while(lFind < m_ComboTypeExport.GetCount())
		{
			if(m_ComboTypeExport.GetItemData(lFind) == lEXPORT_TYPE)
			{
				m_ComboTypeExport.SetCurSel(lFind);
				break;
			}
			lFind++;
		}
	}

	if(lEXPORT_FILE_TYPE > -1)
	{
		long lFind;
		lFind = 0;
		m_ComboFormats.SetCurSel(-1);
		while(lFind < m_ComboFormats.GetCount())
		{
			if(m_ComboFormats.GetItemData(lFind) == lEXPORT_FILE_TYPE)
			{
				m_ComboFormats.SetCurSel(lFind);
				break;
			}
			lFind++;
		}
	
	}

	if( iTypeOrder > -1)
	{
		long lFind;
		lFind = 0;
		m_ComboTypeOrder.SetCurSel(-1);
		while(lFind < m_ComboTypeOrder.GetCount())
		{
			if(m_ComboTypeOrder.GetItemData(lFind) == iTypeOrder)
			{
				m_ComboTypeOrder.SetCurSel(lFind);
				break;
			}
			lFind++;
		}
	
	}
	//m_ComboCyrrency

	if( iCurrency > -1)
	{
		long lFind;
		lFind = 0;
		m_ComboCyrrency.SetCurSel(-1);
		while(lFind < m_ComboCyrrency.GetCount())
		{
			if(m_ComboCyrrency.GetItemData(lFind) == iCurrency)
			{
				m_ComboCyrrency.SetCurSel(lFind);
				break;
			}
			lFind++;
		}
	
	}

	if( iDelivery > -1)
	{
		long lFind;
		lFind = 0;
		m_ComboDelivery.SetCurSel(-1);
		while(lFind < m_ComboDelivery.GetCount())
		{
			if(m_ComboDelivery.GetItemData(lFind) == iDelivery)
			{
				m_ComboDelivery.SetCurSel(lFind);
				break;
			}
			lFind++;
		}
	
	}

	if( iImportTypeFile > -1)
	{
		long lFind;
		lFind = 0;
		m_ComboTypeFileImport.SetCurSel(-1);
		while(lFind < m_ComboTypeFileImport.GetCount())
		{
			if(m_ComboTypeFileImport.GetItemData(lFind) == iImportTypeFile)
			{
				m_ComboTypeFileImport.SetCurSel(lFind);
				break;
			}
			lFind++;
		}
	
	}

	if(iNavTypeFile > -1)
	{
		long lFind;
		lFind = 0;
		m_ComboNavTypeFile.SetCurSel(-1);
		while(lFind < m_ComboNavTypeFile.GetCount())
		{
			if(m_ComboNavTypeFile.GetItemData(lFind) == iNavTypeFile)
			{
				m_ComboNavTypeFile.SetCurSel(lFind);
				break;
			}
			lFind++;
		}
	}
	//iImportTypeFile
	m_EdSubject.SetWindowTextW(sSubject);

	CString sValue;
	sValue.Format(_T("%d"),iFirstString);
	m_EdFirstString.SetWindowTextW(sValue);

	sValue.Format(_T("%d"),iColBrand);
	m_EdColBrand.SetWindowTextW(sValue);

	sValue.Format(_T("%d"),iColNumber);
	m_edColNumber.SetWindowTextW(sValue);

	sValue.Format(_T("%d"),iColQuant);
	m_EdColQuant.SetWindowTextW(sValue);

	sValue.Format(_T("%d"), iColPrice);
	m_EdColPrice.SetWindowTextW(sValue);

	sValue.Format(_T("%d"), iColBasePrice);
	m_EdColBasePrice.SetWindowTextW(sValue);

	m_edOrderTo.SetWindowTextW(sOrderTO);

	COleDateTime oData;
	oData = COleDateTime::GetCurrentTime();
	m_EdDate.SetWindowTextW(oData.Format(_T("%d.%m.%Y")));

	m_EdFromExport.SetWindowTextW(sFromExport);

	m_EdDog.SetWindowTextW(sDog);
	m_EdDelCode.SetWindowTextW(sDelCode);
}


void CEI_PricesDlg::CreateServiseVendorFile(CString sFile, int iType)
{
	//sFileFilter.Format(_T("*.%s|*.%s|"),sFile,sFile);
	CString sFileNameOUT;
	CFileDialog d(FALSE,_T(".xls"),NULL,OFN_HIDEREADONLY,_T("*.xls|*.xls|"),NULL);
	int k=d.DoModal();
	if(k==2) return;
	sFileNameOUT = d.GetPathName();

	CFile cFile;
	if(cFile.Open(sFileNameOUT,CFile::modeRead))
	{
		cFile.Close();
		if(AfxMessageBox(_T("Файл - ")+sFileNameOUT+_T(" - уже существует. Перезаписать?"),MB_YESNO)==IDNO)
			return;
		if(!DeleteFile(sFileNameOUT))
		{
			AfxMessageBox(GetLastErrorText());
			return;
		}
	}
	else
	{
		if(GetLastError()!=2)
		{
			AfxMessageBox(GetLastErrorText());
			return;
		}
	}
	

	switch(iType)
	{
		case 1:
			CoInitializeEx(0, COINIT_MULTITHREADED);
			if(!Import_XLS_Vendors(sFile,sFileNameOUT))
			{
				CoUninitialize();
				return;
			}
			CoUninitialize();
			break;
	}
	AfxMessageBox(_T("Выполненно"));
}


void CEI_PricesDlg::CreateServiseProgFile(CString sFile, int iType, bool isMail, bool aShowMail)
{
	CString sPath;
	wchar_t cBuffer[MAX_PATH];
    //::GetModuleFileName(NULL, cBuffer, MAX_PATH);
	DWORD BufSize;
	BufSize = MAX_PATH;
	::GetTempPath(BufSize, cBuffer);
    sPath = cBuffer;
	sPath = sPath.Left(sPath.ReverseFind('\\'));
    
	if (sPath.Right(1)!="\\") sPath += "\\";


	CString sFileNameOUT;
	long lRandom;
	lRandom = 0;
	srand ( time(NULL) );
	lRandom = 1000000 + rand()%1000000;
	CString sRand;
	sRand.Format(_T("%d"),lRandom);
	m_EdDate.GetWindowTextW(sFileNameOUT);
	sFileNameOUT = sPath + sCodeProgramm+_T("_")+sRand+_T("_")+sFileNameOUT+_T(".csv");
	CStdioFile stFile;
	if(!stFile.Open(sFileNameOUT,CFile::modeCreate|CFile::modeWrite))
	{
		AfxMessageBox(GetLastError());
		return;
	}

	switch(iType)
	{
		case 1:
			CoInitializeEx(0, COINIT_MULTITHREADED);
			if(!Import_XLS(sFile,lRandom,&stFile, aShowMail))
			{
				CoUninitialize();
				stFile.Close();
				return;
			}
			CoUninitialize();
			break;
	}
	
	stFile.Close();

	if (isMail == true)
	{

		CString sEmail;
		m_edOrderTo.GetWindowTextW(sEmail);
		if(sEmail.GetLength())
		{
			CSMTPConnection smtp;
			smtp.SetTimeout(_wtoi(sReadFromIni(_T("SMTP"),_T("TIMEOUT"),_T("50000"))));
			if (!smtp.Connect(sReadFromIni(_T("SMTP"),_T("SERVER"),_T("10.0.1.152")),_wtoi(sReadFromIni(_T("SMTP"),_T("POR"),_T("25")))))
			{
				CString sResponse = smtp.GetLastCommandResponse();
				return;
			}
			

		/*	if(!smtp.SendAutorization("Shate-info@internal.shate-m.com","SSD887dss"))
			{
				CString sResponse = smtp.GetLastCommandResponse();
				AfxMessageBox(sResponse);
				smtp.Disconnect();
				return;
			}
		*/	
			CSMTPMessage m;
			if(sFromExport.GetLength()<3)
			{
				smtp.Disconnect();
				AfxMessageBox(_T("Не заполнен отправитель!"));
				DeleteFile(sFileNameOUT);
				return;
				
			}
			
			CSMTPAddress From(sFromExport); //Change these values to your settings
				
			
			m.m_From = From;
			CSMTPAddress To(sEmail);   //Change these values to your settings
			m.AddRecipient(To, CSMTPMessage::TO);
			CSMTPAttachment attachment;
			m.m_sSubject = sFileNameOUT;
			attachment.Attach(sFileNameOUT);
			m.AddAttachment(&attachment);
			
			
			if (!smtp.SendMessage(m))
			{
				smtp.Disconnect();
				DeleteFile(sFileNameOUT);
				
				CString sResponse = smtp.GetLastCommandResponse();
				AfxMessageBox(sResponse);
				return;
			}
			
			smtp.Disconnect();
		}
	}
	DeleteFile(sFileNameOUT);
	AfxMessageBox(_T("Выполненно"));
}

void CEI_PricesDlg::OnBnClickedButtonView()
{
	ExecuteRun(false, false);
}

void CEI_PricesDlg::ExecuteRun(bool isMail, bool aShowMail)
{
	SaveDate();
	if(lID_Client < 0)
	{
		AfxMessageBox(_T("Не выбран клиент"));
		return;
	}
	if((iFirstString < 1)||(iColBrand<1)||(iColNumber<1)||(iColQuant < 0) || (iColPrice < 1) || (iColBasePrice < 1))
	{
		AfxMessageBox(_T("не установленны параметры"));
		return;
	}

	CString sFromMail;
	sFromMail = sFromExport; 
	sFromMail.Replace(_T(" "),_T(""));
	sFromMail.MakeLower();
	if((sFromMail == _T("request@shate-m.com"))||(sFromMail.GetLength()<0))
	{
		AfxMessageBox(_T("Введите адрес для ответа на заказ!"));
		return;
	}
	int iType;
	iType = m_ComboTypeFileImport.GetCurSel();
	if(iType < 0)
	{
		AfxMessageBox(_T("Необходимо выбрать тип файла!"));
		return;
	}

	int iTypeNav;
	iTypeNav = m_ComboNavTypeFile.GetCurSel();
	if(iTypeNav < 0)
	{
		AfxMessageBox(_T("Необходимо выбрать тип файла!"));
		return;
	}
	
	CString sFile;
	m_ComboTypeFileImport.GetLBText(iType, sFile);

	CString sFileFilter;
	sFileFilter.Format(_T("*.%s|*.%s|"),sFile,sFile);
	
	CString a;
	CFileDialog d(TRUE,_T(".")+sFile,NULL,OFN_HIDEREADONLY,sFileFilter,NULL);
	int k=d.DoModal();
	if(k==2) return;
	sFile = d.GetPathName();
	iType = m_ComboTypeFileImport.GetItemData(iType);

	//1111111111111111111111111111
	iTypeNav = m_ComboNavTypeFile.GetItemData(iTypeNav); 
	switch(iTypeNav)
	{
		case 1:
			CreateServiseProgFile(sFile, iType, isMail, aShowMail);
			break;

		case 2:
			CreateServiseVendorFile(sFile, iType);
			break;

		default:
			AfxMessageBox(_T("Неопределен итоговый файл"));
			return;
	}
}

int CEI_PricesDlg::GetItemPrice(char* aItemNo2, char* aTMName, char* aServiceProgUsrID, char* aAgreementNo, char* aCurrCode, char *aNavPrice, char *aErr)
{
	typedef int (__stdcall *MYPROC)(char*, char*, char*, char*, char*, char*, char*);

	HINSTANCE hinstLib;
	MYPROC ProcAdd;
	hinstLib = LoadLibrary(TEXT("SoapNav.dll"));
	int result = -1;
	if (hinstLib != NULL)
	{
		ProcAdd = (MYPROC)GetProcAddress(hinstLib, "GetSalesPrice");
		if (NULL != ProcAdd)
		{
			char* s1 = aItemNo2;
			char* s2 = aTMName;
			char* s3 = aServiceProgUsrID;
			char* s4 = aAgreementNo;
			char* s5 = aCurrCode;
			result = (ProcAdd)(s1, s2, s3, s4, s5, aNavPrice, aErr);
		}
		FreeLibrary(hinstLib);
	}

	return result;
}

int CEI_PricesDlg::GetPriceRatio(char* aValue1, char* aValue2, char *aPriceRatio, char *aErr)
{
	typedef int (__stdcall *MYPROC)(char*, char*, char*, char*);

	HINSTANCE hinstLib;
	MYPROC ProcAdd;
	hinstLib = LoadLibrary(TEXT("SoapNav.dll"));
	int result = -1;
	if (hinstLib != NULL)
	{
		ProcAdd = (MYPROC)GetProcAddress(hinstLib, "GetPriceRatio");
		if (NULL != ProcAdd)
		{
			char* s1 = aValue1;
			char* s2 = aValue2;
			result = (ProcAdd)(s1, s2, aPriceRatio, aErr);
		}
		FreeLibrary(hinstLib);
	}

	return result;
}

void CEI_PricesDlg::OnBnClickedButtonManualLoadfile()
{
  ExecuteRun(false, true);
}