// ExportShellDlg.cpp : implementation file
//

#include "stdafx.h"
#include "ExportShell.h"
#include "ExportShellDlg.h"
#include "IniReader.h"
#include "locale.h"
#include "XMLReader.h"
#include "DirDialog.h"
#include "ZIP\ZipArchive.h"
#include "afxinet.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// CExportShellDlg dialog




CExportShellDlg::CExportShellDlg(CWnd* pParent /*=NULL*/)
	: CDialog(CExportShellDlg::IDD, pParent)
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
	dwThreadID = 0;
	bStateProcess = FALSE;
}

void CExportShellDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_STATIC_INFO, m_stInfo);
	DDX_Control(pDX, IDC_COMBO_MOUNTH, m_ComboMounth);
	DDX_Control(pDX, IDC_EDIT_YEAR, m_edYear);
	DDX_Control(pDX, IDC_EDIT_DIR, m_edDir);
}

BEGIN_MESSAGE_MAP(CExportShellDlg, CDialog)
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	//}}AFX_MSG_MAP
	ON_BN_CLICKED(IDC_BUTTON1, &CExportShellDlg::OnBnClickedButton1)
	ON_BN_CLICKED(IDC_BUTTON2, &CExportShellDlg::OnBnClickedButton2)
	ON_BN_CLICKED(IDC_BUTTON_OPEN_DIR, &CExportShellDlg::OnBnClickedButtonOpenDir)
END_MESSAGE_MAP()


// CExportShellDlg message handlers

BOOL CExportShellDlg::OnInitDialog()
{
	CDialog::OnInitDialog();

	CIniReader iniRider;
	m_edDir.SetWindowTextW(iniRider.ReadFromIni(_T("TEMP"),_T("DIR"),iniRider.GetFilePath()));

	m_ComboMounth.InsertString(0,_T("Январь"));
	m_ComboMounth.InsertString(1,_T("Февраль"));
	m_ComboMounth.InsertString(2,_T("Март"));
	m_ComboMounth.InsertString(3,_T("Апрель"));
	m_ComboMounth.InsertString(4,_T("Май"));
	m_ComboMounth.InsertString(5,_T("Июнь"));
	m_ComboMounth.InsertString(6,_T("Июль"));
	m_ComboMounth.InsertString(7,_T("Август"));
	m_ComboMounth.InsertString(8,_T("Сентябрь"));
	m_ComboMounth.InsertString(9,_T("Октябрь"));
	m_ComboMounth.InsertString(10,_T("Ноябрь"));
	m_ComboMounth.InsertString(11,_T("Декабрь"));

	COleDateTime oData;
	oData = COleDateTime::GetCurrentTime();
	m_ComboMounth.SetCurSel(oData.GetMonth()-1);
	CString sYear;
	sYear.Format(_T("%d"),oData.GetYear());
	m_edYear.SetWindowTextW(sYear);

	// Set the icon for this dialog.  The framework does this automatically
	//  when the application's main window is not a dialog
	SetIcon(m_hIcon, TRUE);			// Set big icon
	SetIcon(m_hIcon, FALSE);		// Set small icon

	
	return TRUE;  // return TRUE  unless you set the focus to a control
}

// If you add a minimize button to your dialog, you will need the code below
//  to draw the icon.  For MFC applications using the document/view model,
//  this is automatically done for you by the framework.

void CExportShellDlg::OnPaint()
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
HCURSOR CExportShellDlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}


void CExportShellDlg::OnOK()
{
	
}

void CExportShellDlg::OnCancel()
{
	
}

void CExportShellDlg::OnBnClickedButton1()
{
	if(dwThreadID > 0)
	{
		if(AfxMessageBox(_T("Найдена активная выгрузка, перед завершением ее необходимо прервать. Прервать сейчас?"), MB_YESNO)==IDYES)
		{
			bStateProcess = TRUE;
		}
		return;
	}
	CDialog::OnCancel();
}

BOOL CExportShellDlg::CreateExport(CString sStartDate, CString sEndDate,BOOL* bTerminate, CStatic *stInfo)
{

	CIniReader iniReader;
	CArray<stPostCode*,stPostCode*> PostArray;
	stPostCode * tsPost; 
	int iCount;
	CString sMess;
	iCount = _wtoi(iniReader.ReadFromIni(_T("POSTCODE"), _T("COUNT"),CString(_T("0"))));
	CString sDir;
	sDir = iniReader.ReadFromIni(_T("TEMP"),_T("DIR"),_T(""));

	CString sServerFTP,sUserFTP,sPassFTP,sFtpAdress;

	sServerFTP = iniReader.ReadFromIni(_T("FTP"),_T("SERVER"),_T(""));
	sUserFTP = iniReader.ReadFromIni(_T("FTP"),_T("USER"),_T(""));
	sPassFTP = iniReader.ReadFromIni(_T("FTP"),_T("PASS"),_T(""));
	sFtpAdress = iniReader.ReadFromIni(_T("FTP"),_T("ADRESS"),_T(""));

	while(iCount > 0)
	{
		iCount--;
		sMess.Format(_T("POST_%d_"),iCount);
		tsPost = new(stPostCode);
		tsPost->sValue = iniReader.ReadFromIni(_T("POSTCODE"), sMess+_T("VALUE"),CString(_T("")));
		tsPost->iMax =  sReplaceLeftSynmbol(iniReader.ReadFromIni(_T("POSTCODE"), sMess+_T("END"),CString(_T("0"))));
		tsPost->iMin = sReplaceLeftSynmbol(iniReader.ReadFromIni(_T("POSTCODE"), sMess+_T("START"),CString(_T("0"))));
		PostArray.Add(tsPost);
	}

	
	setlocale(LC_ALL,"Russian");
	CItem ItemsTerra;
	CItem ItemsClient;
	CItem ItemsSal;
	ItemsSal.AddSummField(7);
	ItemsSal.AddSummField(8);
	//ItemsSal.AddSummField(9);
	CItem ItemsSalSold;
	
	
	
	CString sServer = iniReader.ReadFromIni(_T("DB"), _T("SERVER"),CString(_T("SVBYMINSSQ3")));
	CString sDatabase = iniReader.ReadFromIni(_T("DB"), _T("DB"),CString(_T("Shate-M-8")));
	CString sFirm = iniReader.ReadFromIni(_T("DB"), _T("FIRM"),CString(_T("Shate-M-8")));
	CString sMaker = iniReader.ReadFromIni(_T("DB"), _T("MAKER"),CString(_T("SHELL")));
	CString sVendor = iniReader.ReadFromIni(_T("DB"), _T("VENDOR"),CString(_T("V438")));
	//Mnsk3_01
	CString sTerraNode = iniReader.ReadFromIni(_T("SHELL"), _T("TERRANODE"),CString(_T("Mnsk3_01")));
	//Mnsk3_ShateM
	CString sFirmCode = iniReader.ReadFromIni(_T("SHELL"), _T("FIRMCODE"),CString(_T("Mnsk3_ShateM")));

	CDatabase* dBase;
	dBase = NULL;
	dBase = new(CDatabase);
	CString sConnect;
	CString sError;
	
	try
	{
		sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
		dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
		dBase->ExecuteSQL(sConnect);
		dBase->SetQueryTimeout(0);
		
	}
	catch(CDBException * error)
	{
		if(dBase!=NULL)
		{
			if(dBase->IsOpen())
				dBase->Close();
		}

		sError.Format(_T("%s\n%s"),error->m_strError);
		error->Delete();
		delete(dBase);
		dBase = NULL;
		if(stInfo != NULL)
			stInfo->SetWindowTextW(sError);

		while(PostArray.GetCount()>0)
		{
			tsPost = PostArray.ElementAt(0);
			delete(tsPost);
			PostArray.RemoveAt(0,1);
		}
		return FALSE;
	}

	CString sSQL;
	try
	{
		
		CRecordset Query(dBase);
		CStringArray saDocs;
		int iField;
		CDBVariant dbValue;
		
		sSQL.Format(_T("select distinct * from (select distinct Left(CONVERT ( nchar , sih.[Posting Date], 112),8) as dat, sih.[No_],'1'  as w from [%s$Sales Invoice Header] as sih "),sFirm);
		sSQL = sSQL + _T("join [") + sFirm + _T("$Sales Invoice Line] as sil on sih.[No_] = sil.[Document No_]");
		sSQL = sSQL + _T("join [") + sFirm + _T("$Item] as it on sil.[No_] = it.[No_] and it.[Vendor No_] = '");
		sSQL = sSQL + sVendor + _T("' join [tm] on it.[TM Code] = tm.[Trade Mark Code] and [tm].[TM Full Name] = '");
		sSQL = sSQL + sMaker + _T("' where Left(CONVERT ( nchar , sih.[Posting Date], 112),8) >= '");
		sSQL = sSQL + sStartDate + _T("' and Left(CONVERT ( nchar , sih.[Posting Date], 112),8) <= '");
		sSQL = sSQL + sEndDate + _T("' union select distinct Left(CONVERT ( nchar , sih.[Posting Date], 112),8) as dat, sih.[No_],'2'  as w from [");
		sSQL = sSQL + sFirm + _T("$Sales Cr_Memo Header] as sih join [");
		sSQL = sSQL + sFirm + _T("$Sales Cr_Memo Line] as sil on sih.[No_] = sil.[Document No_] join [");
		sSQL = sSQL + sFirm + _T("$Item] as it on sil.[No_] = it.[No_] and it.[Vendor No_] = '");
		sSQL = sSQL + sVendor + _T("' join [tm] on it.[TM Code] = tm.[Trade Mark Code] and [tm].[TM Full Name] = '");
		sSQL = sSQL + sMaker + _T("' where Left(CONVERT ( nchar , sih.[Posting Date], 112),8) >= '");
		sSQL = sSQL + sStartDate + _T("' and Left(CONVERT ( nchar , sih.[Posting Date], 112),8) <= '");
		sSQL = sSQL + sEndDate + _T("') as tab order by dat");
		

		saDocs.RemoveAll();
		sMess.Format(_T("Формирование списка документов для обработки"));
		if(stInfo != NULL)
			stInfo->SetWindowTextW(sMess);
		Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
		iField = 1;
		while(!Query.IsEOF())
		{
			if(*bTerminate)
				break;
			Query.GetFieldValue(iField, dbValue);
			sSQL = GetValue(&dbValue);
			saDocs.Add(sSQL);

			Query.MoveNext();
		}
		Query.Close();

		
		CStringArray saArray, saArrayClient,saArraySal,saArraySalSold;
		double dPer;
		while(saDocs.GetCount()>0)
		{
			
			if(*bTerminate)
				break;
			if(saDocs.GetCount() % 20 == 0)
			{
				//sMess.Format(_T("Формирование результатов, осталось обработать(%s)"),saDocs.ElementAt(0));
				sMess.Format(_T("Формирование результатов, осталось обработать(%d)"),saDocs.GetCount());
				if(stInfo != NULL)
					stInfo->SetWindowTextW(sMess);
			}
			
			sSQL.Format(_T("select '%s', coalesce((select top 1 [Cross-Reference No_] from [%s$Item Cross Reference] as icr where icr.[Item No_] = it.[No_] and icr.[Cross-Reference Type] = 2),'Error: - нет перекрестной - '+it.[No_ 2]),5,(select top 1 [Code] from  [Post Code] as pt where [City Code] = sih.[Bill-to City] and [Code] > '000000'),'%s'+sih.[Bill-to Customer No_],sih.[Bill-to Name],sih.[VAT Registration No_],'%s','%s'+sih.[Bill-to Customer No_],'','',CONVERT ( nchar , sih.[Posting Date],104),it.[No_ 2],sil.[Quantity],sil.[Discount Unit Price],(select top 1 [Exchange Rate Amount] from [%s$Currency Exchange Rate] as cer where cer.[Currency Code] = sih.[Currency Code] and cer.[Starting date] <= sih.[Posting Date] order by cer.[Starting date] desc),(select top 1 [Exchange Rate Amount] from [%s$Currency Exchange Rate] as cer where cer.[Currency Code] = 'BYR' and cer.[Starting date] <= sih.[Posting Date] order by cer.[Starting date] desc),'4',(select top 1 ss.[code] from [%s$Strukture Sold] as ss join [%s$Customer] as cust on [Sold Canal Code] = ss.[Code] where cust.[No_] = sih.[Bill-to Customer No_]),'%s'+sih.[Bill-to Customer No_], sih.[Country_Region Code] from (select top 1 s.[No_], coalesce(ct3.[City],ct1.[City]) as [Bill-to City],coalesce(ct3.[No_],ct1.[No_]) as [Bill-to Customer No_],coalesce(ct3.[Name],ct1.[Name]) as [Bill-to Name],coalesce(ct3.[VAT Registration No_],ct1.[VAT Registration No_]) as [VAT Registration No_],s.[Currency Code],s.[Posting Date],(coalesce(ct.[Country_Region Code],'1111')+'_'+s.[Bill-to Customer No_]) as [Country_Region Code]  from [%s$Sales Invoice Header]  as s left join [%s$Customer] as ct on ct.[No_] = s.[Bill-to Customer No_] and ct.[VAT Registration No_] <> '' and ct.[VAT Registration No_] <> '100219673' and (ct.[Country_Region Code] = 'BY' or ct.[Country_Region Code] = '') left join [%s$Customer] as ct1 on ct1.[No_] = 'S1' left join [%s$Customer] as ct3 on ct.[VAT Registration No_] = ct3.[VAT Registration No_] AND ct3.[Country_Region Code] <> 'RU' where s.[No_] = '%s' order by CONVERT(int,Right([ct3].[No_],len([ct3].[No_])-1))) as sih join [%s$Sales Invoice line] as sil on sil.[Document nO_] = sih.[No_] join [%s$Item] as it on sil.[No_] = it.[No_] AND it.[Vendor No_] = '%s' LEFT JOIN [%s$Item Item Group] smig ON smig.[Item No_] = it.No_ AND smig.[Item Group Type Code] = 'ТОВЛИНИЯ' AND smig.[Item Group Node Id] LIKE '119%%' join [tm] on it.[TM Code] = tm.[Trade Mark Code] and [tm].[TM Full Name] = '%s' WHERE smig.[Item No_] IS NULL"),sFirmCode,sFirm,sTerraNode,sTerraNode,sTerraNode,sFirm,sFirm,sFirm,sFirm,sTerraNode,sFirm,sFirm,sFirm,sFirm,saDocs.ElementAt(0),sFirm, sFirm, sVendor, sFirm, sMaker);

			Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			if(Query.IsEOF())
			{
				Query.Close();
				sSQL.Format(_T("select '%s', coalesce((select top 1 [Cross-Reference No_] from [%s$Item Cross Reference] as icr where icr.[Item No_] = it.[No_] and icr.[Cross-Reference Type] = 2),'Error: - нет перекрестной -'+it.[No_ 2]),5,(select top 1 [Code] from  [Post Code] as pt where [City Code] = sih.[Bill-to City] and [Code] > '000000'),'%s'+sih.[Bill-to Customer No_],sih.[Bill-to Name],sih.[VAT Registration No_],'%s','%s'+sih.[Bill-to Customer No_],'','',CONVERT ( nchar , sih.[Posting Date],104),it.[No_ 2],-1*sil.[Quantity],sil.[Discount Unit Price],(select top 1 [Exchange Rate Amount] from [%s$Currency Exchange Rate] as cer where cer.[Currency Code] = sih.[Currency Code] and cer.[Starting date] <= sih.[Posting Date] order by cer.[Starting date] desc),(select top 1 [Exchange Rate Amount] from [%s$Currency Exchange Rate] as cer where cer.[Currency Code] = 'BYR' and cer.[Starting date] <= sih.[Posting Date] order by cer.[Starting date] desc),'4',(select top 1 ss.[code] from [%s$Strukture Sold] as ss join [%s$Customer] as cust on [Sold Canal Code] = ss.[Code] where cust.[No_] = sih.[Bill-to Customer No_]),'%s'+sih.[Bill-to Customer No_],sih.[Country_Region Code] from (select top 1 s.[No_], coalesce(ct3.[City],ct1.[City]) as [Bill-to City],coalesce(ct3.[No_],ct1.[No_]) as [Bill-to Customer No_],coalesce(ct3.[Name],ct1.[Name]) as [Bill-to Name],coalesce(ct3.[VAT Registration No_],ct1.[VAT Registration No_]) as [VAT Registration No_],s.[Currency Code],s.[Posting Date],(coalesce(ct.[Country_Region Code],'1111')+'_'+s.[Bill-to Customer No_]) as [Country_Region Code]  from [%s$Sales Cr_Memo Header] as s left join [%s$Customer] as ct on ct.[No_] = s.[Bill-to Customer No_] and ct.[VAT Registration No_] <> '' and ct.[VAT Registration No_] <> '100219673' and (ct.[Country_Region Code] = 'BY' or ct.[Country_Region Code] = '') left join [%s$Customer] as ct1 on ct1.[No_] = 'S1' left join [%s$Customer] as ct3 on ct.[VAT Registration No_] = ct3.[VAT Registration No_] AND ct3.[Country_Region Code] <> 'RU' where s.[No_] = '%s' order by CONVERT(int,Right([ct3].[No_],len([ct3].[No_])-1))) as sih join [%s$Sales Cr_Memo line] as sil on sil.[Document nO_] = sih.[No_] join [%s$Item] as it on sil.[No_] = it.[No_] AND it.[Vendor No_] = '%s' LEFT JOIN [%s$Item Item Group] smig ON smig.[Item No_] = it.No_ AND smig.[Item Group Type Code] = 'ТОВЛИНИЯ' AND smig.[Item Group Node Id] LIKE '119%%' join [tm] on it.[TM Code] = tm.[Trade Mark Code] and [tm].[TM Full Name] = '%s' WHERE smig.[Item No_] IS NULL"),sFirmCode,sFirm,sTerraNode,sTerraNode,sTerraNode,sFirm,sFirm,sFirm,sFirm,sTerraNode,sFirm,sFirm,sFirm,sFirm,saDocs.ElementAt(0),sFirm, sFirm, sVendor, sFirm, sMaker);
				Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
			}
			double dCount, dPrice,dCurr1,dCurr2;
			while(!Query.IsEOF())
			{
				saArray.RemoveAll();
				saArrayClient.RemoveAll();
				saArraySal.RemoveAll();
				saArraySalSold.RemoveAll();
				if(*bTerminate)
				{
					break;
				}
				for(iField = 0;iField<21;iField++)
				{
					Query.GetFieldValue(iField, dbValue);
					switch(iField)
					{
						case 0:
							saArraySal.Add(sReplaceLeftSynmbol(GetValue(&dbValue)));
							break;

						case 1:
							saArraySal.Add(sReplaceLeftSynmbol(GetValue(&dbValue)));
							break;

						case 2:
							saArray.Add(sReplaceLeftSynmbol(GetValue(&dbValue)));
							break;

						case 4:
							saArray.Add(sReplaceLeftSynmbol(GetValue(&dbValue)));
							saArrayClient.Add(sReplaceLeftSynmbol(GetValue(&dbValue)));
							break;							
						
						case 3:
						iCount = 0;
						sMess = GetValue(&dbValue);
						if(sMess.GetLength()<3)
						{
							saArray.Add(_T(""));
							saArraySal.Add(_T(""));
							break;
						}
						while(iCount < PostArray.GetCount())
						{
							tsPost = PostArray.ElementAt(iCount);
							
							if(sMess>=tsPost->iMin)
								if(sMess<=tsPost->iMax)
							{
								saArray.Add(tsPost->sValue);
								saArraySal.Add(tsPost->sValue);
								break;
							}

							iCount++;
						}


						if(iCount == PostArray.GetCount())
						{
							saArray.Add(_T(""));
							saArraySal.Add(_T(""));
						}
						break;

						case 5:
							saArrayClient.Add(sReplaceLeftSynmbol(GetValue(&dbValue)));
							break;

						case 6:
							saArrayClient.Add(GetValue(&dbValue));
							break;

						case 7:
							saArrayClient.Add(GetValue(&dbValue));
							break;

						case 8:
						case 9:
						case 10:
							saArraySal.Add(GetValue(&dbValue));
							break;
						case 11:
							sMess.Format(_T("01-%s-%s"),sStartDate.Right(4).Left(2),sStartDate.Left(4));
							saArraySal.Add(sMess);
							break;
						
						case 12:
							sMess = GetValue(&dbValue);
							sMess.MakeUpper();
							if(sMess.Left(3)==_T("1L "))
							{
								while(sMess.Find(_T("/"),0)>-1)
								{
									sMess =sMess.Right(sMess.GetLength()-1-sMess.Find(_T("/"),0));
								}
								dPer = _wtof(sMess);
								dPer = 1/dPer; 
							}
							else
							{
								dPer = 1;
							}
							break;

						case 13:
							dCount = _wtof(GetValue(&dbValue));
							//dPer
							sMess.Format(_T("%f"),dCount*dPer);
							saArraySal.Add(sMess);
							break;

						//dPrice,dCurr1,dCurr2;
						case 14:
							dPrice = _wtof(GetValue(&dbValue));
							break;

						case 15:
							dCurr1 = _wtof(GetValue(&dbValue));
							if(dCurr1 == 0)
								dCurr1 = 1;
							break;

						case 16:
							
							dCurr2 = _wtof(GetValue(&dbValue));
							dCurr1 = dCurr2/dCurr1;
							dPrice = int(dPrice*100+0.5);
							dPrice = dPrice/100;
							dPrice = int(dCurr1*dPrice+0.5);
							dPrice = int(dPrice*dCount+0.5);
							sMess.Format(_T("%.0f"),dPrice);
							saArraySal.Add(sMess);
							break;

						case 17:
						case 18:
						case 19:
							saArraySalSold.Add(sReplaceLeftSynmbol(GetValue(&dbValue)));
							break;
							/**/
							//Amount Including VAT (LCY)
						case 20:
						/*	saArraySal.Add(GetValue(&dbValue));
							break;
						case 21:*/
							saArray.Add(GetValue(&dbValue));
							break;

					default:
						//saArray.Add(sReplaceLeftSynmbol(GetValue(&dbValue)));
						break;
					}
					
					
				}
				ItemsTerra.Add(saArray.ElementAt(2),&saArray);
				ItemsClient.Add(saArrayClient.ElementAt(0),&saArrayClient);
				ItemsSal.Add(saArraySal.ElementAt(0)+_T("\t")+saArraySal.ElementAt(3)+_T("\t")+saArraySal.ElementAt(1),&saArraySal);
				ItemsSalSold.Add(saArraySalSold.ElementAt(2),&saArraySalSold);

				Query.MoveNext();			
			}
			Query.Close();
			
			
			
			
			
			
			saDocs.RemoveAt(0,1);
		}
		/*
		Mnsk3_011311_КЛ_ТЕРР.csv
		*/
		
		/*
		ItemsTerra
		*/
		CStringArray sError;
		CString sFileName;
		stItem *Item;
		
		sFileName.Format(_T("%s%s%s_КЛ_ТЕРР.csv"),sTerraNode,sStartDate.Left(4).Right(2),sStartDate.Right(4).Left(2));
		sFileName = sDir + sFileName;
		int i;
		CStdioFile stFile;
		if(stFile.Open(sFileName,CFile::modeCreate|CFile::modeWrite))
		{
			int iFind;
			stFile.WriteString(_T("LEVEL;PARENT;NODE\n"));
			for(i=0;i<ItemsTerra.m_Item.GetCount();i++)
			{
				if(*bTerminate)
					break;
		
				if(i%100 == 0)
				{
					sMess.Format(_T("Сохранение в файл %s (%d / %d)"),sFileName,i,ItemsTerra.m_Item.GetCount());
					if(stInfo != NULL)
						stInfo->SetWindowTextW(sMess);
				}		
				Item = ItemsTerra.GetItem(i);
				if(Item->sArray.ElementAt(1).GetLength()<1)
					sError.Add(_T("КЛ_ТЕРР\t")+Item->sArray.ElementAt(2)+_T("\tне определен код территории"));
				
				sSQL = Item->sArray.ElementAt(Item->sArray.GetCount()-1);
				iFind = sSQL.Find(_T("_"),0);
				if(iFind < 1)
				{
					sError.Add(_T("КЛ_ТЕРР\t")+sSQL+_T("\tне задан код страны"));
				}
				Item->sArray.RemoveAt(Item->sArray.GetCount()-1,1);

				while(Item->sArray.GetCount()>1)
				{
					stFile.WriteString(Item->sArray.ElementAt(0)+_T(";"));
					Item->sArray.RemoveAt(0,1);
				}

				if(Item->sArray.GetCount()>0)
				{
					stFile.WriteString(Item->sArray.ElementAt(0)+_T("\n"));
				}
				Item->sArray.RemoveAll();
				
			}
			stFile.Close();
		}
		//ItemsClient
		sFileName.Format(_T("%s%s%s_КЛИЕНТЫ.csv"),sTerraNode,sStartDate.Left(4).Right(2),sStartDate.Right(4).Left(2));
		sFileName = sDir + sFileName;
		if(stFile.Open(sFileName,CFile::modeCreate|CFile::modeWrite))
		{
			/**/
			
			stFile.WriteString(_T("CODE;VALUE;ИНН;СИСТЕМ\n"));
			for(i=0;i<ItemsClient.m_Item.GetCount();i++)
			{
				if(*bTerminate)
					break;
		
				if(i%100 == 0)
				{
					sMess.Format(_T("Сохранение в файл %s (%d / %d)"),sFileName,i,ItemsTerra.m_Item.GetCount());
					if(stInfo != NULL)
						stInfo->SetWindowTextW(sMess);
				}		
				Item = ItemsClient.GetItem(i);

				

				while(Item->sArray.GetCount()>1)
				{
					stFile.WriteString(Item->sArray.ElementAt(0)+_T(";"));
					Item->sArray.RemoveAt(0,1);
				}

				if(Item->sArray.GetCount()>0)
				{
					stFile.WriteString(Item->sArray.ElementAt(0)+_T("\n"));
				}
				Item->sArray.RemoveAll();

				
			}
			stFile.Close();
		}
		
		sFileName.Format(_T("%s%s%s_ПРОД_ДИСТР.csv"),sTerraNode,sStartDate.Left(4).Right(2),sStartDate.Right(4).Left(2));
		sFileName = sDir + sFileName;
		int iCol;
		if(stFile.Open(sFileName,CFile::modeCreate|CFile::modeWrite))
		{
			stFile.WriteString(_T("ЮР_ЛИЦО;ПРОД;ТЕРР;КЛИЕНТ;ИНВЕСТ_ПРОЕКТ;БРЕНД;ПЕРИОД;ОБЪЕМ;ОБОРОТ\n"));
			for(i=0;i<ItemsSal.m_Item.GetCount();i++)
			{
				if(*bTerminate)
					break;
		
				if(i%100 == 0)
				{
					sMess.Format(_T("Сохранение в файл %s (%d / %d)"),sFileName,i,ItemsTerra.m_Item.GetCount());
					if(stInfo != NULL)
						stInfo->SetWindowTextW(sMess);
				}		
				Item = ItemsSal.GetItem(i);
				if(_wtof(Item->sArray.ElementAt(7)) == 0)
				{
					continue;
				}
				iCol = 0;
				while(Item->sArray.GetCount()>1)
				{
					iCol++;
					if(iCol == 2)
					{
						if(Item->sArray.ElementAt(0).Left(6) == _T("Error:"))
						{
							sError.Add(Item->sArray.ElementAt(0));
						}
					}
					stFile.WriteString(Item->sArray.ElementAt(0)+_T(";"));
					Item->sArray.RemoveAt(0,1);
				}

				if(Item->sArray.GetCount()>0)
				{
					stFile.WriteString(Item->sArray.ElementAt(0)+_T("\n"));
				}
				Item->sArray.RemoveAll();
			}
			stFile.Close();
		}

		sFileName.Format(_T("%s%s%s_СТРУКТ_СБ.csv"),sTerraNode,sStartDate.Left(4).Right(2),sStartDate.Right(4).Left(2));
		sFileName = sDir + sFileName;
		if(stFile.Open(sFileName,CFile::modeCreate|CFile::modeWrite))
		{
			stFile.WriteString(_T("LEVEL;PARENT;NODE\n"));
			for(i=0;i<ItemsSalSold.m_Item.GetCount();i++)
			{
				if(*bTerminate)
					break;
		
				if(i%100 == 0)
				{
					sMess.Format(_T("Сохранение в файл %s (%d / %d)"),sFileName,i,ItemsTerra.m_Item.GetCount());
					if(stInfo != NULL)
						stInfo->SetWindowTextW(sMess);
				}		
				Item = ItemsSalSold.GetItem(i);
				if(Item->sArray.ElementAt(1).GetLength()<1)
					sError.Add(_T("СТРУКТ_СБ\t")+Item->sArray.ElementAt(2)+_T("\tне заполнено поле рынок сбыта в карточке клиента"));
				while(Item->sArray.GetCount()>1)
				{
					stFile.WriteString(Item->sArray.ElementAt(0)+_T(";"));
					Item->sArray.RemoveAt(0,1);
				}

				if(Item->sArray.GetCount()>0)
				{
					stFile.WriteString(Item->sArray.ElementAt(0)+_T("\n"));
				}
				Item->sArray.RemoveAll();
			}
			stFile.Close();

			
		}
		
		if((sError.GetCount()>0)&&(!(*bTerminate)))
		{
			/**/

			int iPos, iPos1;
			iPos = 0;
			while(iPos < sError.GetCount())
			{
				sFileName = sError.ElementAt(iPos);
				iPos1 = iPos+1;
				while(iPos1 < sError.GetCount())
				{
					if(sError.ElementAt(iPos1) == sFileName)
					{
						sError.RemoveAt(iPos1,1);
					}
					else
						iPos1++;
				}
				iPos++;
			}


			sFileName.Format(_T("log.txt"));
			sFileName = sDir + sFileName;
			if(stFile.Open(sFileName,CFile::modeCreate|CFile::modeWrite))
			{
				while(sError.GetCount()>0)
					{
						stFile.WriteString(sError.ElementAt(0)+_T("\n"));
						sError.RemoveAt(0,1);
					}
				
				stFile.Close();

				STARTUPINFO si = {sizeof(si)};
				PROCESS_INFORMATION pi;
				sFileName = _T("notepad.exe ")+sFileName;
				CreateProcess(NULL, sFileName.GetBuffer(), NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi);
			}
			else
			{
				AfxMessageBox(_T("Ошибка при сохранение LOG файла!"));
			}
			sError.RemoveAll();
			return FALSE;
		}

		if(*bTerminate)
		{
			return FALSE;
		}
		CXMLReader XMLReader;
		stXMLElemet* stXMLParent;
		stXMLElemet* stXMLRef;
		stXMLElemet* stXMLClassifier;
		XMLReader.ClearTree();

		stXMLParent = XMLReader.AddElement(_T("?xml"),_T(""),NULL);
		XMLReader.AddProperty(_T("version"),_T("\"1.0\""),stXMLParent);
		XMLReader.AddProperty(_T("encoding"),_T("\"WINDOWS-1251\""),stXMLParent);
		XMLReader.AddProperty(_T("standalone"),_T("\"yes\""),stXMLParent);
		XMLReader.SetSeparator(_T("?"),stXMLParent);
		stXMLParent = XMLReader.AddElement(_T("CSVPackage"),_T(""),NULL);
		XMLReader.AddElement(_T("Separator"),_T(";"),stXMLParent);
		stXMLRef = XMLReader.AddElement(_T("References"),_T(""),stXMLParent);
		stXMLRef = XMLReader.AddElement(_T("Reference"),_T(""),stXMLRef);
		XMLReader.AddProperty(_T("code"),_T("\"КЛИЕНТЫ\""),stXMLRef);
		XMLReader.AddProperty(_T("file"),_T("\"")+sTerraNode+sStartDate.Left(4).Right(2)+sStartDate.Right(4).Left(2)+ _T("_КЛИЕНТЫ.csv\""),stXMLRef);
		stXMLRef = XMLReader.AddElement(_T("Classifiers"),_T(""),stXMLParent);
		stXMLClassifier = XMLReader.AddElement(_T("Classifier"),_T(""),stXMLRef);
		XMLReader.AddProperty(_T("code"),_T("\"СТРУКТ_СБ\""),stXMLClassifier);
		XMLReader.AddProperty(_T("file"),_T("\"")+sTerraNode+sStartDate.Left(4).Right(2)+sStartDate.Right(4).Left(2)+ _T("_СТРУКТ_СБ.csv\""),stXMLClassifier);
		stXMLClassifier = XMLReader.AddElement(_T("Classifier"),_T(""),stXMLRef);
		XMLReader.AddProperty(_T("code"),_T("\"КЛ_ТЕРР\""),stXMLClassifier);
		XMLReader.AddProperty(_T("file"),_T("\"")+sTerraNode+sStartDate.Left(4).Right(2)+sStartDate.Right(4).Left(2)+ _T("_КЛ_ТЕРР.csv\""),stXMLClassifier);
		stXMLRef = XMLReader.AddElement(_T("SeriesDataList"),_T(""),stXMLParent);
		stXMLClassifier = XMLReader.AddElement(_T("SeriesData"),_T(""),stXMLRef);
		XMLReader.AddProperty(_T("code"),_T("\"ПРОД_ДИСТР\""),stXMLClassifier);
		XMLReader.AddProperty(_T("file"),_T("\"")+sTerraNode+sStartDate.Left(4).Right(2)+sStartDate.Right(4).Left(2)+ _T("_ПРОД_ДИСТР.csv\""),stXMLClassifier);
		XMLReader.AddElement(_T("Period"),_T("01-")+sStartDate.Right(4).Left(2)+_T("-")+sStartDate.Left(4) ,stXMLClassifier);
		XMLReader.AddElement(_T("DataProvider"),sTerraNode,stXMLClassifier);

		sFileName.Format(_T("%s%s%s.xml"),sTerraNode,sStartDate.Left(4).Right(2),sStartDate.Right(4).Left(2));
		sFileName = sDir + sFileName;
		XMLReader.WriteToFile(sFileName);

		if(*bTerminate)
		{
			return FALSE;
		}
		CZipArchive archiv;
		//Mnsk3_011311.zip
		
		sFileName.Format(_T("%s%s%s"),sTerraNode,sStartDate.Left(4).Right(2),sStartDate.Right(4).Left(2));
		//sFileName = sFileName;
		archiv.Open(sDir+sFileName+_T(".zip"),CZipArchive::create);
		archiv.AddNewFile(sDir+sFileName+_T("_КЛ_ТЕРР.csv"),5,FALSE);
		archiv.AddNewFile(sDir+sFileName+_T("_КЛИЕНТЫ.csv"),5,FALSE);
		archiv.AddNewFile(sDir+sFileName+_T("_ПРОД_ДИСТР.csv"),5,FALSE);
		archiv.AddNewFile(sDir+sFileName+_T("_СТРУКТ_СБ.csv"),5,FALSE);
		archiv.AddNewFile(sDir+sFileName+_T(".xml"),5,FALSE);
		archiv.Close();
		
		if(*bTerminate)
		{
			return FALSE;
		}
		CInternetSession* session;
		session = new CInternetSession(_T("FTP UPDATE"));
		CFtpConnection *cp;
		cp = NULL;
		try
		{
			cp=session->GetFtpConnection(sServerFTP,sUserFTP,sPassFTP,INTERNET_INVALID_PORT_NUMBER,FALSE);
		}	
		catch(...)
		{
			AfxMessageBox(_T("Не доступно FTP подключение."));
			session->Close(); 
			delete session;
			return FALSE;
		}

		if(*bTerminate)
		{
			cp->Close();
			delete cp; 
			session->Close(); 
			delete session;
			return FALSE;
		}

		CFtpFileFind ftpFindFile(cp);
		cp->SetCurrentDirectory(sFtpAdress);
		try
		{
			if(!cp->PutFile(sDir+sFileName+_T(".zip"),sFtpAdress+sFileName+_T(".zip")))
			{
				AfxMessageBox(_T("не передали файл по FTP -") +sFtpAdress+sFileName+_T(".zip"));
			}
		}
		catch(...)
		{
			AfxMessageBox(_T("не передали файл по FTP -") +sFtpAdress+sFileName+_T(".zip"));
		}
		cp->Close();
		delete cp; 
		session->Close(); 
		delete session;
	}
	catch(CDBException *exsept)
	{
		sMess.Format(_T("%s\n%s"),exsept->m_strError);
		exsept->Delete();
		if(stInfo != NULL)
			stInfo->SetWindowTextW(sMess);
		
		if(dBase != NULL)
		{
			if(dBase->IsOpen())
			{
				dBase->Close();
			}
			delete(dBase);
		}
		dBase = NULL;

		while(PostArray.GetCount()>0)
		{
			tsPost = PostArray.ElementAt(0);
			delete(tsPost);
			PostArray.RemoveAt(0,1);
		}

		return FALSE;
	}
	

	while(PostArray.GetCount()>0)
	{
		tsPost = PostArray.ElementAt(0);
		delete(tsPost);
		PostArray.RemoveAt(0,1);
	}

	if(dBase!=NULL)
		{
			if(dBase->IsOpen())
				dBase->Close();
			delete(dBase);

			dBase = NULL;
		}

	
	return TRUE;
}

DWORD CExportShellDlg::StartOperation(LPVOID param)
{
	StParam * Param;
	Param = (StParam *)param;
	BOOL bok;
	bok = FALSE;
	
	bok = CreateExport(Param->sStartDate,Param->sEndDate,Param->bStateProcess,Param->stMess);
	

	if(bok)
		Param->stMess->SetWindowTextW(_T("Выполненно!"));
	else
		Param->stMess->SetWindowTextW(_T("Не выполненно!"));
	
	*(Param->bStateProcess) = FALSE;
	*(Param->dwThreadID) = 0;
	delete(Param);

	return 0L;
}

void CExportShellDlg::OnBnClickedButton2()
{

	CString sDir;
	m_edDir.GetWindowTextW(sDir);
	if(sDir.GetLength()<1)
	{
		AfxMessageBox(_T("Не указанна дирректория выгрузки"));
		return;
	}

	

	if(dwThreadID > 0)	
		return;

	CString sYear;
	m_edYear.GetWindowTextW(sYear);

	COleDateTime datStart,datEnd, cDate;
	//sYear	
	datStart.SetDate(_wtoi(sYear),m_ComboMounth.GetCurSel()+1,1);
	datEnd.SetDate(_wtoi(sYear),m_ComboMounth.GetCurSel()+1,1);
	
	COleDateTimeSpan ts;
	ts = 1;
	
	while(datStart.GetMonth() == datEnd.GetMonth())
	{
		datEnd = datEnd + ts;
	}
		datEnd = datEnd - ts;
	
	CString sStart,sEnd;
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

	StParam * Param;
	Param = new(StParam);
	Param->stMess = &m_stInfo;
	Param->dwThreadID = &dwThreadID;
	Param->bStateProcess=&bStateProcess;
	Param->sStartDate = sStart;
	Param->sEndDate = sEnd;

	CreateThread(NULL, NULL, (LPTHREAD_START_ROUTINE)StartOperation, (void*)Param, NULL, &dwThreadID);
}

void CExportShellDlg::OnBnClickedButtonOpenDir()
{
	BROWSEINFO bi;
    memset(&bi, 0, sizeof(bi));

    bi.ulFlags   = BIF_STATUSTEXT;
    bi.hwndOwner = m_hWnd;
    bi.lpszTitle = _T("Укажите папку для экпортов");
//    bi.lpfn = "";
    LPITEMIDLIST pidl=SHBrowseForFolder(&bi);
    if(pidl != NULL)
    {
        // Create a buffer to store the path, then 
      // get the path.
      wchar_t buffer[_MAX_PATH] = {'0'};
      if(::SHGetPathFromIDList(pidl, buffer) != 0)
      {
         // Обрабатываешь переменную buffer как тебе заблагорасудиться    
      }

      // free the item id list
      CoTaskMemFree(pidl);
	  m_edDir.SetWindowTextW(buffer);
	  CString sDir;
	  sDir = buffer;
	  if(sDir.Right(1)!=_T("\\"))
	  {
		sDir = sDir + _T("\\");
	  }
	  CIniReader iniRider;
	  iniRider.WriteToIni(_T("TEMP"),_T("DIR"),sDir);
   }
}
