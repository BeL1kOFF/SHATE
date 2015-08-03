// DLgEditGroup.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner_Interface.h"
#include "DLgEditGroup.h"


// CDLgEditGroup dialog

IMPLEMENT_DYNAMIC(CDLgEditGroup, CDialog)

CDLgEditGroup::CDLgEditGroup(CWnd* pParent /*=NULL*/)
	: CDialog(CDLgEditGroup::IDD, pParent)
{
	iCurrGroup = -1;
}

CDLgEditGroup::~CDLgEditGroup()
{
}

void CDLgEditGroup::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_LIST1, m_ListGroup);
	DDX_Control(pDX, IDC_EDIT_DESCR, m_EdDecr);
}


BEGIN_MESSAGE_MAP(CDLgEditGroup, CDialog)
	ON_LBN_SELCANCEL(IDC_LIST1, &CDLgEditGroup::OnLbnSelcancelList1)
	ON_LBN_SELCHANGE(IDC_LIST1, &CDLgEditGroup::OnLbnSelchangeList1)
	ON_BN_CLICKED(IDC_BUTTON_EDIT, &CDLgEditGroup::OnBnClickedButtonEdit)
	ON_BN_CLICKED(IDC_BUTTON2, &CDLgEditGroup::OnBnClickedButton2)
END_MESSAGE_MAP()


// CDLgEditGroup message handlers

BOOL CDLgEditGroup::OnInitDialog()
{
	CDialog::OnInitDialog();

	LoadGroup();
	

	return TRUE;  // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}

void CDLgEditGroup::OnLbnSelcancelList1()
{
	
}

void CDLgEditGroup::OnLbnSelchangeList1()
{
	int iPos;
	CString sValue;
	iPos = m_ListGroup.GetCurSel();
	if(iPos < 0)
		return;

	if(iCurrGroup != m_ListGroup.GetItemData(iPos))
	{
		iCurrGroup = m_ListGroup.GetItemData(iPos);
	}

	m_ListGroup.GetText(iPos,sValue);
	sValue = sValue.Right(sValue.GetLength()-1);
	sValue = sValue.Left(sValue.GetLength()-1);
	m_EdDecr.SetWindowTextW(sValue);
}

void CDLgEditGroup::OnBnClickedButtonEdit()
{
	// TODO: Add your control notification handler code here
	CString sValue;
	sValue.Replace(_T("'"),_T("''"));
	m_EdDecr.GetWindowTextW(sValue);
	if(iCurrGroup == -1)
	{
		CString sSQL;
		try
		{
			CNav_Scaner_InterfaceApp *pApp;
			pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
			
			sSQL.Format(_T("INSERT INTO [Group] ([ID],[Name]) VALUES ((select max([ID])+1 from [Group]),'%s')"),sValue);
			pApp->dBaseProg->ExecuteSQL(sSQL);
		}
		catch(CDBException * expt)
		{
			CString sError;
			sError.Format(_T("%s %s"),expt->m_strError,sSQL);
			AfxMessageBox(sError);
			return;
		}
	}
	else
	{
		CString sSQL;
		try
		{
			CNav_Scaner_InterfaceApp *pApp;
			pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
			
			sSQL.Format(_T("UPDATE [Group] set [Name] = '%s' where [ID] = %d"),sValue,iCurrGroup);
			pApp->dBaseProg->ExecuteSQL(sSQL);
		}
		catch(CDBException * expt)
		{
			CString sError;
			sError.Format(_T("%s %s"),expt->m_strError,sSQL);
			AfxMessageBox(sError);
			return;
		}
	}

	LoadGroup();
}

int CDLgEditGroup::LoadGroup(void)
{
	m_EdDecr.SetWindowTextW(_T(""));
	iCurrGroup = -1;
	while(m_ListGroup.GetCount() > 0)
		m_ListGroup.DeleteString(0);
	CString sSQL;
	try
	{
		CNav_Scaner_InterfaceApp *pApp;
		pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
		CRecordset Query_Prog(pApp->dBaseProg);
		CDBVariant dbValue;
		
		while(m_ListGroup.GetCount())
			m_ListGroup.DeleteString(0);

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
			m_ListGroup.AddString(_T("[")+GetValue(&dbValue)+_T("]"));
			

			iField++;
			Query_Prog.GetFieldValue(iField, dbValue);
			m_ListGroup.SetItemData(iPos, _wtoi(GetValue(&dbValue)));
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

void CDLgEditGroup::OnBnClickedButton2()
{
	CString sValue;
	sValue.Replace(_T("'"),_T("''"));
	m_EdDecr.GetWindowTextW(sValue);
	CString sSQL;
		try
		{
			CNav_Scaner_InterfaceApp *pApp;
			pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
			
			sSQL.Format(_T("INSERT INTO [Group] ([ID],[Name]) VALUES ((select max([ID])+1 from [Group]),'%s')"),sValue);
			pApp->dBaseProg->ExecuteSQL(sSQL);
		}
		catch(CDBException * expt)
		{
			CString sError;
			sError.Format(_T("%s %s"),expt->m_strError,sSQL);
			AfxMessageBox(sError);
			return;
		}
	LoadGroup();
}
