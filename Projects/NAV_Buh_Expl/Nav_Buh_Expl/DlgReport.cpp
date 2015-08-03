// DlgReport.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Buh_Expl.h"
#include "DlgReport.h"
#include "DlgName.h"

// CDlgReport dialog

IMPLEMENT_DYNAMIC(CDlgReport, CDialog)

CDlgReport::CDlgReport(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgReport::IDD, pParent)
{
	dBase = NULL;
	iCurrReport = 0;
}

CDlgReport::~CDlgReport()
{
	CloseDatabase();
}

void CDlgReport::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_LIST_REPORT_NAME, m_ListReportName);
	DDX_Control(pDX, IDC_LIST_REPORT_FIELD, m_ListField);
	DDX_Control(pDX, IDC_COMBO_CURR, m_ComboCurr);
	DDX_Control(pDX, IDC_EDIT_FLOAT_NUMBER, m_EdFlNum);
}


BEGIN_MESSAGE_MAP(CDlgReport, CDialog)
	ON_BN_CLICKED(IDC_BUTTON_NEW, &CDlgReport::OnBnClickedButtonNew)
	ON_LBN_SELCHANGE(IDC_LIST_REPORT_NAME, &CDlgReport::OnLbnSelchangeListReportName)
	ON_BN_CLICKED(IDC_BUTTON_DEL, &CDlgReport::OnBnClickedButtonDel)
	ON_NOTIFY(LVN_ITEMCHANGED, IDC_LIST_REPORT_FIELD, &CDlgReport::OnLvnItemchangedListReportField)
	ON_WM_CLOSE()
	ON_CBN_SELCHANGE(IDC_COMBO_CURR, &CDlgReport::OnCbnSelchangeComboCurr)
	ON_EN_CHANGE(IDC_EDIT_FLOAT_NUMBER, &CDlgReport::OnEnChangeEditFloatNumber)
END_MESSAGE_MAP()


// CDlgReport message handlers

void CDlgReport::OnBnClickedButtonNew()
{
	CDlgName dialog;
	if(dialog.DoModal()!= IDOK)
	{
		return;
	}

	int iCount;
	iCount = _wtoi(sReadFromIni(_T("REPORT"),_T("COUNT"),_T("0")));
	//iCount
	CString sRep;
	sRep.Format(_T("REPORT_%d"),iCount);

	sWriteToIni(sRep,_T("NAME"),dialog.sName);
	sWriteToIni(sRep,_T("TYPE"),_T("2"));
	sWriteToIni(sRep,_T("FILTER_COUNT"),_T("0"));

	iCount++;
	sRep.Format(_T("%d"),iCount);
	sWriteToIni(_T("REPORT"),_T("COUNT"),sRep);
	
	LoadReports(iCount--);
}

BOOL CDlgReport::OnInitDialog()
{
	
	CDialog::OnInitDialog();
	m_ComboCurr.InsertString(0,_T("BYR"));
	m_ComboCurr.InsertString(1,_T("EUR"));
	m_ListField.SetExtendedStyle(m_ListField.GetExtendedStyle()|LVS_EX_CHECKBOXES);
	LVCOLUMN col;
	
	col.pszText = _T("");
	col.cx = 10;
	m_ListField.InsertColumn(0,&col);
	m_ListField.SetColumnWidth(0,30);

	col.cx = 20;
	col.pszText =_T("Значение");
	m_ListField.InsertColumn(1,&col);
	m_ListField.SetColumnWidth(1,247);
	LoadReports();
	return TRUE;  
}
void CDlgReport::SaveReport(int iReport)
{
	int i;
	int	iCount;
	CString sCell, sFilter, sName;
	sCell.Format(_T("REPORT_%d"),iReport);
	iCount = _wtoi(sReadFromIni(sCell,_T("FILTER_COUNT"),_T("0")));
	while(iCount > 0)
	{
		
		sFilter.Format(_T("FILTER_%d"),iCount);
		sWriteToIni(sCell,sFilter,_T(""));
		iCount--;
	}

	iCount = 0;
	for(i=0;i<m_ListField.GetItemCount();i++)
	{
		if(m_ListField.GetCheck(i))
		{
			iCount++;
			sFilter.Format(_T("FILTER_%d"),iCount);
			sName = m_ListField.GetItemText(i,1);
			sWriteToIni(sCell,sFilter,sName);
			
		}
	}
	sName.Format(_T("%d"),iCount);
	sWriteToIni(sCell,_T("FILTER_COUNT"),sName);

	sName.Format(_T("%d"),m_ComboCurr.GetCurSel());
	sWriteToIni(sCell,_T("CURENCY"),sName);

	m_EdFlNum.GetWindowTextW(sName);
	sWriteToIni(sCell,_T("FLOAT_NUMBER"),sName);
}

int CDlgReport::LoadReport()
{
	if(iCurrReport > 0)
	{
		if(AfxMessageBox(_T("Сохранить изменения?"),MB_YESNO)==IDYES)
		{
			SaveReport(iCurrReport);
		}
	}
	m_ListField.DeleteAllItems();
	int iReport;
	iReport = m_ListReportName.GetCurSel();
	if(iReport < 0)
		return 0;

	iReport = m_ListReportName.GetItemData(iReport);
	if(iReport < 0)
		return 0;

	
	dBase = NULL;

	CString sError;
	if((dBase = OpenDatabase(&sError))==NULL)
	{
		AfxMessageBox(sError);
		return 0;
	}
	try
	{
		int iFilter;
		CRecordset Query(dBase);
		CString sWareHouse, sFirm;
		sWareHouse = sReadFromIni(_T("DB"),_T("WAREHOUSE"),_T("WRITE_OFF"));
		sWriteToIni(_T("DB"),_T("WAREHOUSE"),sWareHouse);
		sFirm = sReadFromIni(_T("DB"),_T("FIRM"),_T("Shate-M"));

		CString sSQL;
		sSQL.Format(_T("select [Description] from [%s$Bin] where [Location Code] = '%s' order by [Description]"),sFirm,sWareHouse);
		CDBVariant dbVar;
		int iFind;
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		LVITEM Item;
		int iPos;
		iPos = 0;
		int iFirld;
		iFirld = 0;

		CString sOld,sCell,sPos;
		sCell.Format(_T("REPORT_%d"),iReport);
		while(!Query.IsEOF())
		{
			Query.GetFieldValue(iFirld,dbVar);
			sSQL = GetValue(&dbVar);
			if((sSQL.Left(1) >= _T("0"))&&(sSQL.Left(1) <= _T("9")))
			{
				iFind = sSQL.Find(_T(" "),0);
				if(iFind > -1)
				{
					sSQL = sSQL.Left(iFind);
				}
				iPos++;
				Item.iItem = iPos;
				if(sSQL != sOld)
				{
					sOld = sSQL;
					iPos = m_ListField.InsertItem(LVIF_TEXT | LVIF_STATE, iPos, _T(""), 0, 0, 0,0);
					m_ListField.SetItemText(iPos,1,sSQL.GetBuffer());
					m_ListField.SetCheck(iPos,0);
					
					iFilter = _wtoi(sReadFromIni(sCell,_T("FILTER_COUNT"),_T("0")));
					while(iFilter > 0)
					{
						
						sPos.Format(_T("FILTER_%d"),iFilter);
						sPos = sReadFromIni(sCell,sPos,_T(""));
						if(sPos == sSQL)
						{
							m_ListField.SetCheck(iPos,1);
							break;
						}
						iFilter--;
					}
				}
			}
			Query.MoveNext();
		}
		Query.Close();

		iFilter = _wtoi(sReadFromIni(sCell,_T("CURENCY"),_T("0")));
		m_EdFlNum.SetWindowText(sReadFromIni(sCell,_T("FLOAT_NUMBER"),_T("1")));
		m_ComboCurr.SetCurSel(iFilter);
	}
	catch(CDBException *exp)
	{
		CString sError;
		sError.Format(_T("%s\n%s"),exp->m_strError);
		exp->Delete();
		CloseDatabase();
		AfxMessageBox(sError);
		return 0;
	}
	CloseDatabase();
	iCurrReport = -iReport;
	return 0;
}

int CDlgReport::LoadReports(int iPos)
{
	while(m_ListReportName.GetCount()>0)
		m_ListReportName.DeleteString(0);

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

	while(iReport > 0)
	{
		CString sCell;
		sCell.Format(_T("REPORT_%d"),iReport);
		m_ListReportName.InsertString(0,sReadFromIni(sCell,_T("NAME"),_T("")));
		m_ListReportName.SetItemData(0,iReport);
		iReport--;
	}
	
	if (m_ListReportName.GetCount()>0)
	{
		if(iPos < m_ListReportName.GetCount())
			m_ListReportName.SetCurSel(iPos);
		else
			m_ListReportName.SetCurSel(iPos);
		LoadReport();
	}

	return 0;
}

void CDlgReport::OnLbnSelchangeListReportName()
{
	LoadReport();
}

CDatabase* CDlgReport::OpenDatabase(CString * sError)
{
	CDatabase* dBase;
	dBase = NULL;
	if(CloseDatabase(sError))
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
		CloseDatabase();
		return dBase;
	}
	return dBase;
}

CDatabase* CDlgReport::CloseDatabase(CString * sError)
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

void CDlgReport::OnBnClickedButtonDel()
{
	int iReport;
	iReport = m_ListReportName.GetCurSel();
	if(iReport < 0)
		return;

	CString sName;
	m_ListReportName.GetText(iReport,sName);

	iReport = m_ListReportName.GetItemData(iReport);
	if(iReport < 0)
		return;

	

	if(AfxMessageBox(_T("Удалить отчет - ")+sName+_T("?"),MB_YESNO) != IDYES)
	{

		return;
	}

	int iReportNew;
	iReportNew = 0;
	CString sRepNew, sRep;
	int iCount;
	CString sFilter;
	for(int i=0;i<m_ListReportName.GetCount();i++)
	{
		if(iReport != m_ListReportName.GetItemData(i))
		{
			if(iReportNew != m_ListReportName.GetItemData(i))
			{
				sRepNew.Format(_T("REPORT_%d"),iReportNew);
				sRep.Format(_T("REPORT_%d"),m_ListReportName.GetItemData(iReport));
				sWriteToIni(sRepNew,_T("NAME"),sReadFromIni(sRep,_T("NAME"),_T("")));
				sWriteToIni(sRepNew,_T("TYPE"),sReadFromIni(sRep,_T("TYPE"),_T("")));
				sWriteToIni(sRepNew,_T("FILTER_COUNT"),sReadFromIni(sRep,_T("FILTER_COUNT"),_T("")));
				sWriteToIni(sRepNew,_T("CURENCY"),sReadFromIni(sRep,_T("CURENCY"),_T("")));
				sWriteToIni(sRepNew,_T("FLOAT_NUMBER"),sReadFromIni(sRep,_T("FLOAT_NUMBER"),_T("")));
				
				iCount = _wtoi(sReadFromIni(sRep,_T("FILTER_COUNT"),_T("0")));
				while(iCount > 0)
				{
					sFilter.Format(_T("FILTER_%d"),iCount);
					sWriteToIni(sRepNew,sFilter,sReadFromIni(sRep,sFilter,_T("")));
					iCount--;
				}
				
			}
			iReportNew++;
		}
	}
	sName.Format(_T("%d"),iReportNew);
	sWriteToIni(_T("REPORT"),_T("COUNT"),sName);
	LoadReports();
}

void CDlgReport::OnLvnItemchangedListReportField(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMLISTVIEW pNMLV = reinterpret_cast<LPNMLISTVIEW>(pNMHDR);
	// TODO: Add your control notification handler code here
	*pResult = 0;
	if(iCurrReport < 0)
	{
		iCurrReport = -iCurrReport;
	}
}

void CDlgReport::OnClose()
{
	if(iCurrReport > 0)
	{
		if(AfxMessageBox(_T("Сохранить изменения?"),MB_YESNO)==IDYES)
		{
			SaveReport(iCurrReport);
		}
	}

	CDialog::OnClose();
}

void CDlgReport::OnCbnSelchangeComboCurr()
{
	if(iCurrReport < 0)
	{
		iCurrReport = -iCurrReport;
	}
}

void CDlgReport::OnEnChangeEditFloatNumber()
{
	if(iCurrReport < 0)
	{
		iCurrReport = -iCurrReport;
	}
}
