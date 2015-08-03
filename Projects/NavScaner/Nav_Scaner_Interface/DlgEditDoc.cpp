// DlgEditDoc.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner_Interface.h"
#include "DlgEditDoc.h"
#include "DLgEditGroup.h"


// CDlgEditDoc dialog

IMPLEMENT_DYNAMIC(CDlgEditDoc, CDialog)

CDlgEditDoc::CDlgEditDoc(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgEditDoc::IDD, pParent)
{

}

CDlgEditDoc::~CDlgEditDoc()
{
}

void CDlgEditDoc::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_DESCR, m_EdDescr);
	DDX_Control(pDX, IDC_STATIC_DATA, m_StDate);
	DDX_Control(pDX, IDC_STATIC_LOCATION, m_StLocation);
	DDX_Control(pDX, IDC_COMBO_GROUP, m_ComboGroup);
}


BEGIN_MESSAGE_MAP(CDlgEditDoc, CDialog)
	ON_BN_CLICKED(IDC_BUTTON_EDIT_GROUP, &CDlgEditDoc::OnBnClickedButtonEditGroup)
	ON_CBN_SELCHANGE(IDC_COMBO_GROUP, &CDlgEditDoc::OnCbnSelchangeComboGroup)
	ON_BN_CLICKED(IDOK, &CDlgEditDoc::OnBnClickedOk)
	ON_EN_KILLFOCUS(IDC_EDIT_DESCR, &CDlgEditDoc::OnEnKillfocusEditDescr)
	ON_EN_CHANGE(IDC_EDIT_DESCR, &CDlgEditDoc::OnEnChangeEditDescr)
END_MESSAGE_MAP()


// CDlgEditDoc message handlers

BOOL CDlgEditDoc::OnInitDialog()
{
	CDialog::OnInitDialog();

	CString sSQL;
	lGroup =0;
	try
	{
		CNav_Scaner_InterfaceApp *pApp;
		pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
		CRecordset Query_Prog(pApp->dBaseProg);
		CDBVariant dbValue;
		
		sSQL.Format(_T("SELECT [Date],[Description],[Location Code],[ID_GROUP] FROM [Inventary Doc Header] where [ID] = %d"),lID);
		Query_Prog.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);

		int iField;
		
		CString sValue;
		
		if(!Query_Prog.IsEOF())
		{
			iField = 0;
			Query_Prog.GetFieldValue(iField, dbValue);
			m_StDate.SetWindowTextW(_T("Дата\t")+GetValue(&dbValue));

			iField++;
			Query_Prog.GetFieldValue(iField, dbValue);
			m_EdDescr.SetWindowTextW(GetValue(&dbValue));

			iField++;
			Query_Prog.GetFieldValue(iField, dbValue);
			m_StLocation.SetWindowTextW(_T("Склад\t")+GetValue(&dbValue));

			iField++;
			Query_Prog.GetFieldValue(iField, dbValue);
			lGroup = _wtoi(GetValue(&dbValue));
			
		}
		Query_Prog.Close();

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
		return TRUE;
	}
	

	return TRUE;  
	
}

void CDlgEditDoc::OnBnClickedButtonEditGroup()
{
	CDLgEditGroup dialog;
	dialog.DoModal();
	LoadGroup();
}

int CDlgEditDoc::LoadGroup(void)
{
	CString sSQL;
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
		return TRUE;
	}
	return 0;
}

void CDlgEditDoc::OnCbnSelchangeComboGroup()
{
	lGroup = m_ComboGroup.GetCurSel();
	lGroup = m_ComboGroup.GetItemData(lGroup);
}

void CDlgEditDoc::OnBnClickedOk()
{
	CString sSQL;
	CString sValue;
	m_EdDescr.GetWindowTextW(sValue);
	sValue.Replace(_T("'"),_T("''"));
	try
	{
		CNav_Scaner_InterfaceApp *pApp;
		pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
		
		sSQL.Format(_T("UPDATE [Inventary Doc Header] SET [Description] = '%s', [ID_GROUP] = %d WHERE [ID] = %d"),sValue,lGroup,lID);
		pApp->dBaseProg->ExecuteSQL(sSQL);
	}
	catch(CDBException * expt)
	{
		CString sError;
		sError.Format(_T("%s %s"),expt->m_strError,sSQL);
		AfxMessageBox(sError);
		return;
	}



	OnOK();
}

void CDlgEditDoc::OnEnKillfocusEditDescr()
{
	CString sValue;
	m_EdDescr.GetWindowTextW(sValue);
	sValue =ReplaceLeftSymbols(sValue,3);
	m_EdDescr.SetWindowTextW(sValue);
}

void CDlgEditDoc::OnEnChangeEditDescr()
{
	// TODO:  If this is a RICHEDIT control, the control will not
	// send this notification unless you override the CDialog::OnInitDialog()
	// function and call CRichEditCtrl().SetEventMask()
	// with the ENM_CHANGE flag ORed into the mask.

	// TODO:  Add your control notification handler code here
}
