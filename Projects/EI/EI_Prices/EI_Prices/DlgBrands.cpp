// DlgBrands.cpp : implementation file
//

#include "stdafx.h"
#include "EI_Prices.h"
#include "DlgBrands.h"
#include "DlgBrand.h"


// CDlgBrands dialog

IMPLEMENT_DYNAMIC(CDlgBrands, CDialog)

CDlgBrands::CDlgBrands(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgBrands::IDD, pParent)
{
	dBase = NULL;
	lID_Client = -1;
}

CDlgBrands::~CDlgBrands()
{
}

void CDlgBrands::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_LIST_BRANDS, m_ListBrands);
}


BEGIN_MESSAGE_MAP(CDlgBrands, CDialog)
	ON_BN_CLICKED(IDC_BUTTON_NEW_BRAND, &CDlgBrands::OnBnClickedButtonNewBrand)
	ON_BN_CLICKED(IDC_BUTTON_EDIT_BRAND, &CDlgBrands::OnBnClickedButtonEditBrand)
	ON_BN_CLICKED(IDC_BUTTON_DEL, &CDlgBrands::OnBnClickedButtonDel)
END_MESSAGE_MAP()


// CDlgBrands message handlers

void CDlgBrands::OnBnClickedButtonNewBrand()
{
	CString sError;
	CDlgBrand dialog;
	if(dialog.DoModal() == IDOK)
	{
		int iItem;
		try
		{
			iItem = m_ListBrands.GetItemCount();
			iItem = m_ListBrands.InsertItem(iItem,dialog.sBrandShate);
			m_ListBrands.SetItemText(iItem,1,dialog.sBrand);
			dialog.sBrand.Replace(_T("'"),_T("''"));
			dialog.sBrandShate.Replace(_T("'"),_T("''"));
			sError.Format(_T("INSERT INTO [REBRAND] ([CLI_ID],[BRAND],[BRAND_EXPORT]) VALUES (%d, '%s', '%s')"),lID_Client,dialog.sBrandShate,dialog.sBrand);
			dBase->ExecuteSQL(sError);
		}
		catch(CDBException * error)
		{
			m_ListBrands.DeleteItem(iItem);
			sError.Format(_T("%s\n%s"),sError,error->m_strError);
			error->Delete();
			AfxMessageBox(sError);
			return ;
		}
	}
}

BOOL CDlgBrands::OnInitDialog()
{
	CDialog::OnInitDialog();

	LVCOLUMN   column;
	column.mask  = LVCF_TEXT | LVCF_WIDTH;
	column.fmt      = LVCFMT_LEFT;
	column.cx       = 200;
	column.pszText  = _T("Бренд Шате");
	column.iSubItem = 0;

	m_ListBrands.InsertColumn(0, &column);
	
	column.pszText  = _T("Бренд");
	column.iSubItem = 1;
	m_ListBrands.InsertColumn(1, &column);

	CRect rec;
	m_ListBrands.GetClientRect(rec);
	m_ListBrands.SetColumnWidth(0,(rec.right - rec.left) / 2);
	m_ListBrands.SetColumnWidth(1,rec.right - rec.left-(rec.right - rec.left) / 2);
	
	m_ListBrands.SetExtendedStyle(m_ListBrands.GetExtendedStyle() | LVS_EX_GRIDLINES|LVS_EX_FULLROWSELECT);
	LoadBrands();
	
	return TRUE;  // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgBrands::LoadBrands(void)
{
	if(m_ListBrands.GetItemCount()>0)
		m_ListBrands.DeleteAllItems();

	if((dBase != NULL)&&(lID_Client > 0))
	{
		CString sSQL;
		try
		{
		CRecordset Query(dBase);
		
		
		sSQL.Format(_T("SELECT BRAND,BRAND_EXPORT  FROM [REBRAND] WHERE CLI_ID = %d"),lID_Client);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		sSQL = "";
		
		short i;
		CDBVariant dbVar;
		int iItem;
		int iItem0;
		iItem0 = 0;
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			iItem0++;
			iItem = m_ListBrands.InsertItem(iItem0,GetValue(&dbVar));

			i = 1;
			Query.GetFieldValue(i,dbVar);
			m_ListBrands.SetItemText(iItem,1,GetValue(&dbVar));
			Query.MoveNext();
		}
		Query.Close();
		}
	catch(CDBException * error)
	{
		CString sError;
		sError.Format(_T("%s\n%s"),sSQL,error->m_strError);
		AfxMessageBox(sError);
		error->Delete();
		return;
	}

	}

}

void CDlgBrands::OnBnClickedButtonEditBrand()
{
	//LVIS_SELECTED
	int iItem=0;
	while(iItem<m_ListBrands.GetItemCount())
	{
		if(m_ListBrands.GetItemState(iItem,LVIS_SELECTED)==LVIS_SELECTED)
		{
			break;
		}
		iItem++;
	}

	if(iItem >= m_ListBrands.GetItemCount())
		return;


	CString sError;
	CDlgBrand dialog;

	CString s1,s2;
	
	s2 = m_ListBrands.GetItemText(iItem,1);
	dialog.sBrand = m_ListBrands.GetItemText(iItem,1);
	s1 = m_ListBrands.GetItemText(iItem,0);
	dialog.sBrandShate = m_ListBrands.GetItemText(iItem,0);

	if(dialog.DoModal() == IDOK)
	{
		try
		{
			
			m_ListBrands.SetItemText(iItem,0,dialog.sBrandShate);
			m_ListBrands.SetItemText(iItem,1,dialog.sBrand);
			dialog.sBrand.Replace(_T("'"),_T("''"));
			dialog.sBrandShate.Replace(_T("'"),_T("''"));
			s2.Replace(_T("'"),_T("''"));
			s1.Replace(_T("'"),_T("''"));
			sError.Format(_T("UPDATE [REBRAND] SET [CLI_ID] = %d,[BRAND] = '%s',[BRAND_EXPORT] = '%s' WHERE [CLI_ID] = %d AND BRAND_EXPORT = '%s' AND BRAND = '%s'"),lID_Client,dialog.sBrandShate,dialog.sBrand,lID_Client,s2,s1);
			dBase->ExecuteSQL(sError);
		}
		catch(CDBException * error)
		{
			sError.Format(_T("%s\n%s"),sError,error->m_strError);
			error->Delete();
			AfxMessageBox(sError);
			return ;
		}
	}
}

void CDlgBrands::OnBnClickedButtonDel()
{
	int iItem=0;
	while(iItem<m_ListBrands.GetItemCount())
	{
		if(m_ListBrands.GetItemState(iItem,LVIS_SELECTED)==LVIS_SELECTED)
		{
			break;
		}
		iItem++;
	}

	if(iItem >= m_ListBrands.GetItemCount())
		return;


	CString sError;
	CDlgBrand dialog;

	CString s1,s2;
	
	s2 = m_ListBrands.GetItemText(iItem,1);
	dialog.sBrand = m_ListBrands.GetItemText(iItem,1);
	s1 = m_ListBrands.GetItemText(iItem,0);
	dialog.sBrandShate = m_ListBrands.GetItemText(iItem,0);

	if(AfxMessageBox(_T("Удалить привязку -")+s1+_T("  ")+s2+_T("?"),MB_YESNO,0) == IDYES)
	{
		try
		{
			sError.Format(_T("DELETE FROM [REBRAND] WHERE [CLI_ID] = %d AND BRAND_EXPORT = '%s' AND BRAND = '%s'"),lID_Client,s2,s1);
			dBase->ExecuteSQL(sError);
			m_ListBrands.DeleteItem(iItem);
		}
		catch(CDBException * error)
		{
			sError.Format(_T("%s\n%s"),sError,error->m_strError);
			error->Delete();
			AfxMessageBox(sError);
			return ;
		}
	}
}
