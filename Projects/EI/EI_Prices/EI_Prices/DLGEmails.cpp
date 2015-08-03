// DLGEmails.cpp : implementation file
//

#include "stdafx.h"
#include "EI_Prices.h"
#include "DLGEmails.h"
#include "DlgEmail.h"


// CDLGEmails dialog

IMPLEMENT_DYNAMIC(CDLGEmails, CDialog)

CDLGEmails::CDLGEmails(CWnd* pParent /*=NULL*/)
	: CDialog(CDLGEmails::IDD, pParent)
{
	dBase = NULL;
	lID_Client = 0;
	sEmails = "";
}

CDLGEmails::~CDLGEmails()
{
}

void CDLGEmails::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_LIST_EMAILS, m_ListEmails);
}


BEGIN_MESSAGE_MAP(CDLGEmails, CDialog)
	ON_BN_CLICKED(IDC_BUTTON_ADD_EMAIL, &CDLGEmails::OnBnClickedButtonAddEmail)
	ON_BN_CLICKED(IDC_BUTTON_EDIT, &CDLGEmails::OnBnClickedButtonEdit)
	ON_BN_CLICKED(IDC_BUTTON_DEL, &CDLGEmails::OnBnClickedButtonDel)
	ON_WM_CLOSE()
END_MESSAGE_MAP()


// CDLGEmails message handlers

void CDLGEmails::OnBnClickedButtonAddEmail()
{
	CDlgEmail dialog;
	if(dialog.DoModal()==IDOK)
	{
		if(dialog.sEmail.GetLength()>0)
			m_ListEmails.AddString(dialog.sEmail);
	}
}

BOOL CDLGEmails::OnInitDialog()
{
	CDialog::OnInitDialog();

	if((dBase != NULL)&&(lID_Client > 0))
	{
		CRecordset Query(dBase);
		CString sSQL;
		
		sSQL.Format(_T("SELECT [EMAIL] FROM [CLIENTS_EMAILS] WHERE CLI_ID  = %d"),lID_Client);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		sSQL = "";
		
		short i;
		CDBVariant dbVar;
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);

			sEmails = sEmails+GetValue(&dbVar)+_T(", ");
			m_ListEmails.AddString(GetValue(&dbVar));
			Query.MoveNext();
		}
		Query.Close();

		if(sEmails.GetLength() > 2)
			sEmails = sEmails.Left(sEmails.GetLength()-2);
	}

	return TRUE;  // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}

void CDLGEmails::OnBnClickedButtonEdit()
{
	int iSel = m_ListEmails.GetCurSel();
	if(iSel<0)
		return;
	
	CDlgEmail dialog;
	CString sEmail;
	m_ListEmails.GetText(iSel,sEmail);
	dialog.sEmail = sEmail;
	if(dialog.DoModal()==IDOK)
	{
		if(dialog.sEmail.GetLength()>0)
		{
			m_ListEmails.DeleteString(iSel);
			m_ListEmails.InsertString(iSel,dialog.sEmail);
		}
	}
}

void CDLGEmails::OnBnClickedButtonDel()
{
	int iSel = m_ListEmails.GetCurSel();
	if(iSel<0)
		return;
	
	
	CString sEmail;
	m_ListEmails.GetText(iSel,sEmail);
	if(AfxMessageBox(_T("Удалить - ")+sEmail,MB_YESNO, IDYES)==IDNO)
		return;
	m_ListEmails.DeleteString(iSel);
}

void CDLGEmails::OnClose()
{
	int i;
	i =0;


	CString sSQL;
	CString sNewEmails;
	sNewEmails = "";
	while(i<m_ListEmails.GetCount())
	{
		m_ListEmails.GetText(i,sSQL);
		sNewEmails = sNewEmails+sSQL+_T(", ");
		i++;
	}
		
	if(sNewEmails.GetLength() > 2)
		sNewEmails = sNewEmails.Left(sNewEmails.GetLength()-2);

	if(sEmails !=  sNewEmails)
	{
		if(AfxMessageBox(_T("Сохранить изменения?"),MB_YESNO, IDYES)==IDYES)
		{
			sSQL.Format(_T("DELETE FROM [CLIENTS_EMAILS] WHERE CLI_ID  = %d"),lID_Client);
			dBase->ExecuteSQL(sSQL);

			i =0;
			while(i<m_ListEmails.GetCount())
			{
				m_ListEmails.GetText(i,sNewEmails);
				sNewEmails.Replace(_T("'"),_T(""));
				sSQL.Format(_T("INSERT INTO [CLIENTS_EMAILS] ([EMAIL],[CLI_ID]) VALUES ('%s',%d)"),sNewEmails,lID_Client);
				dBase->ExecuteSQL(sSQL);
				i++;
			}
			/*sSQL.Format(_T("SELECT [EMAIL] FROM [CLIENTS_EMAILS] WHERE CLI_ID  = %d"),lID_Client);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		sSQL = "";
		
		short i;
		CDBVariant dbVar;
		while(!Query.IsEOF())
		{
			i = 0;
			Query.GetFieldValue(i,dbVar);
			sEmails = sEmails+GetValue(&dbVar)+_T(", ");
			Query.MoveNext();
		}
		Query.Close();*/
		
		}
	}
	CDialog::OnClose();
}

void CDLGEmails::OnOK()
{
	
}
