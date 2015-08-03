// DlgNewDoc.cpp : implementation file
//

#include "stdafx.h"
#include "Nav_Scaner_Interface.h"
#include "DlgNewDoc.h"
#include "BulkRecordset.h"


// CDlgNewDoc dialog

IMPLEMENT_DYNAMIC(CDlgNewDoc, CDialog)

CDlgNewDoc::CDlgNewDoc(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgNewDoc::IDD, pParent)
	, sLocation(_T(""))
{

}

CDlgNewDoc::~CDlgNewDoc()
{
}

void CDlgNewDoc::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT1, m_EdDate);
	DDX_Control(pDX, IDC_EDIT2, m_EdDescr);
	DDX_Control(pDX, IDC_COMBO_BRAND, m_ComboBrand);
	DDX_Control(pDX, IDC_TREE_GROUP, m_TreeGroup);
	DDX_Control(pDX, IDC_CHECK_SELECT_ALL, m_BtSelectAll);
	DDX_Control(pDX, IDC_CHECK_NOT_FILTER, m_btNotFilter);
	DDX_Control(pDX, IDC_COMBO_CELL_START, m_ComboCellStart);
	DDX_Control(pDX, IDC_COMBO_CELL_END, m_ComboCellEnd);
}


BEGIN_MESSAGE_MAP(CDlgNewDoc, CDialog)
	ON_BN_CLICKED(IDOK, &CDlgNewDoc::OnBnClickedOk)
	ON_NOTIFY(TVN_SELCHANGED, IDC_TREE_GROUP, &CDlgNewDoc::OnTvnSelchangedTreeGroup)
	ON_NOTIFY(TVN_ITEMCHANGED, IDC_TREE_GROUP, &CDlgNewDoc::OnTvnItemChangedTreeGroup)
	ON_NOTIFY(NM_TVSTATEIMAGECHANGING, IDC_TREE_GROUP, &CDlgNewDoc::OnNMTVStateImageChangingTreeGroup)
	ON_WM_CAPTURECHANGED()
	ON_NOTIFY(MYM_CHECKITEMSSATE, IDC_TREE_GROUP, &CDlgNewDoc::OnNMChangeState)
	ON_BN_CLICKED(IDC_CHECK_SELECT_ALL, &CDlgNewDoc::OnBnClickedCheckSelectAll)
	ON_EN_CHANGE(IDC_EDIT2, &CDlgNewDoc::OnEnChangeEdit2)
	ON_EN_KILLFOCUS(IDC_EDIT2, &CDlgNewDoc::OnEnKillfocusEdit2)
END_MESSAGE_MAP()


// CDlgNewDoc message handlers

BOOL CDlgNewDoc::OnInitDialog()
{
	CDialog::OnInitDialog();

	COleDateTime date;
	date = COleDateTime::GetCurrentTime();
	m_EdDate.setMask(_T("ЧЧ.ЧЧ.ЧЧЧЧ"));
	m_EdDate.SetWindowText(date.Format(_T("%d%m%Y")));
	//sLocation
	CString sWinName;
	GetWindowText(sWinName);
	SetWindowText(sWinName + _T(" ")+ sLocation);
	LoadData();

	return TRUE;  
	
}

void CDlgNewDoc::OnBnClickedOk()
{
	CString sDescr;
	m_EdDescr.GetWindowText(sDescr);
	sDescr.Replace(_T("'"),_T("''"));
	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	if(pApp->dBaseProg == NULL)
	{
		AfxMessageBox(_T("Неподключены к БД!"));
		return;
	}
	BOOL bStart;
	bStart = FALSE;
	CString sDate;
	m_EdDate.GetWindowTextW(sDate);
	COleDateTime datDate;
	datDate.ParseDateTime(sDate);
	BOOL bCanExit;
	bCanExit = TRUE;
	if(datDate.invalid!= 1)
	{
		AfxMessageBox(_T("Введена не коррекная дата!"));
		return;
	}

	CString sStartCell;
	CString sEndCell;
	sStartCell = "";
	sEndCell = "";
	if(m_ComboCellStart.GetCurSel() > -1)
	{
		m_ComboCellStart.GetLBText(m_ComboCellStart.GetCurSel(),sStartCell);
	}

	
	if(m_ComboCellEnd.GetCurSel() > -1)
	{
		m_ComboCellEnd.GetLBText(m_ComboCellEnd.GetCurSel(),sEndCell);
	}

	
	if(sStartCell > sEndCell)
	{
		AfxMessageBox(_T("Не корректно указан интервал ячеек!"));
		return;
	}

	if(sEndCell.GetLength()>0)
	{
		sEndCell = _T(" and bc.[Bin Code] <='")+sEndCell+_T("' ");
	}

	if(sStartCell.GetLength()>0)
	{
		sStartCell = _T(" and bc.[Bin Code] >='")+sStartCell+_T("' ");
	}

	CString sID;
	sID = "";
	if(m_BtSelectAll.GetCheck()>1)
	{
		sID = m_TreeGroup.GetSelectID();
		if(sID.GetLength()>0)
		{
			sID = _T(" and iig.[Item Group Node Id] in (")+sID+_T(") ");
		}
	}

	CString sBrand;
	sBrand = "";
	if(m_ComboBrand.GetCurSel()>-1)
	{
		m_ComboBrand.GetLBText(m_ComboBrand.GetCurSel(),sBrand);
		sBrand.Replace(_T("'"),_T("''"));
		sBrand = _T(" and it.[Manufacturer Code] = '")+sBrand+_T("' ");
	}

	if((!m_btNotFilter.GetCheck())&&(sID.GetLength()<1)&&(sStartCell.GetLength()<1)&&(sEndCell.GetLength()<1)&&(sBrand.GetLength()<1))
	{
		if(AfxMessageBox(_T("Не установлены фильтры! Продолжить?"),MB_YESNO,IDNO)==IDNO)
			return;
	}

	CString sSQL;
	try
		{
			CString sFirm = pApp->IniReader.ReadFromIni(_T("DB_NAV"),_T("FIRM"),_T("Shate-M"));
			CBulkRecordset QueryNav(pApp->dBaseNav);
			
			if(m_btNotFilter.GetCheck())
			{
				sSQL = _T("select * from (select qt.[Item No_],Sum(Quantity)  as qnt, 'NONE' as bin, 'NONE' as zone ");
				sSQL = sSQL+_T("from [")+sFirm+_T("$Item Ledger Entry] as qt "); 
				sSQL = sSQL+_T("join [")+sFirm+_T("$Item] as it on it.[No_] = qt.[Item No_]")+sBrand;
				sSQL = sSQL+_T("join [")+sFirm+_T("$Item Item Group] as iig on iig.[Item No_] = it.[No_] and [Item Group Type Code] = 'ТОВЛИНИЯ'")+sID;
				sSQL = sSQL+_T("where qt.[Location Code] = '")+sLocation+_T("' group by qt.[Item No_],iig.[Item Group Node Id]) as tab where qnt > 0");
			}
			else
			{
				/*sSQL = _T("select * from (select we.[Item No_],	Sum([Quantity])  as summ ,[Bin Code],[Zone Code] ");
				sSQL = sSQL+_T("from [")+sFirm+_T("$Warehouse Entry] as we ");
				sSQL = sSQL+_T("join [")+sFirm+_T("$Item] as it on it.[No_] = we.[Item No_] ")+sBrand;
				sSQL = sSQL+_T("join [")+sFirm+_T("$Item Item Group] as iig on iig.[Item No_] = it.[No_] and [Item Group Type Code] = 'ТОВЛИНИЯ'") + sID;
				sSQL = sSQL+_T("where 	[Location Code] = '")+sLocation+("' ")+sStartCell+sEndCell;		
				sSQL = sSQL+_T("group by [Location Code],[Zone Code],we.[Item No_],[Bin Code]) as tab where summ > 0");*/
				
				sSQL = _T("select bc.[Item No_],coalesce(summ,0) ,bc.[Bin Code],bc.[Zone Code] "); 
				sSQL = sSQL+_T(" from [")+sFirm+_T("$Bin Content] as bc "); 
				sSQL = sSQL+_T(" left join (select we.[Item No_],	Sum([Quantity])  as summ ,[Bin Code],[Zone Code],we.[Location Code] "); 
				sSQL = sSQL+_T(" from [")+sFirm+_T("$Warehouse Entry] as we "); 
				sSQL = sSQL+_T(" where [Location Code] = '")+sLocation+_T("' ");	
				sSQL = sSQL+_T(" group by [Location Code],[Zone Code],we.[Item No_],[Bin Code]) as tab"); 
				sSQL = sSQL+_T(" on bc.[Item No_] = tab.[Item No_] and  bc.[Location Code] = tab.[Location Code]"); 
				sSQL = sSQL+_T(" and bc.[Bin Code] = tab.[Bin Code]");
				sSQL = sSQL+_T(" join [")+sFirm+_T("$Item] as it on it.[No_] = bc.[Item No_]")+sBrand; 
				sSQL = sSQL+_T(" join [")+sFirm+_T("$Item Item Group] as iig on iig.[Item No_] = it.[No_] and [Item Group Type Code] = 'ТОВЛИНИЯ'") + sID; 
				sSQL = sSQL+_T(" where bc.[Location Code] = '")+sLocation+_T("' ")+sStartCell+sEndCell;	
				
			}
			QueryNav.SetRowsetSize(10);
			QueryNav.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly|CRecordset::useMultiRowFetch);
			if(QueryNav.IsEOF())
			{
				QueryNav.Close();
				AfxMessageBox(_T("Не найден товар удовлетворяющий условиям!"));
				bCanExit = FALSE;
			}
			else
			{
				CStringArray saSQL;
				saSQL.RemoveAll();
				sSQL.Format(_T("delete from [Inventary Doc Line] where [DOC_ID] = _LDOC_"));		
				saSQL.Add(sSQL);
				int rowsFetched,rowCount;
				int iLine,iField;
				iLine = 0;
				CString sField;
				while(!QueryNav.IsEOF())
				{
					rowsFetched = (int)QueryNav.GetRowsFetched();
					for(rowCount = 0; rowCount < rowsFetched; rowCount++ )
					{
						sSQL.Format(_T("INSERT INTO [Inventary Doc Line] ([Doc_ID],[Line_ID],[Item],[Cell],[Count],[Test_Count],[ID_ZONE])  VALUES (_LDOC_,%d,'%%Field_0%%','%%Field_2%%',%%Field_1%%,0,'%%Field_3%%')"),iLine,sLocation);
						for(iField = 0; iField < QueryNav.GetODBCFieldCount();iField++)
						{
							sField.Format(_T("%%Field_%d%%"),iField);
							sSQL.Replace(sField,QueryNav.GetValue(rowCount,iField));
						}
						saSQL.Add(sSQL);
						iLine++;
					}
					QueryNav.MoveNext();
				}
				QueryNav.Close();
				sSQL.Format(_T("insert into  [Inventary Doc Tasc] (ID_DOC,ID_ZONE,CELL,COL) select distinct _LDOC_,ID_ZONE, Cell,(left([CELL],CHARINDEX('-',[CELL],CHARINDEX('-',[CELL],1)+1))) from [Inventary Doc Line] where Doc_ID = _LDOC_ and ID_ZONE <> 'NONE'"));		
				saSQL.Add(sSQL);
				bStart = TRUE;
				pApp->dBaseProg->BeginTrans();
				

				CNewRecordset Query(pApp->dBaseProg);
				sSQL.Format(_T("INSERT INTO [Inventary Doc Header] ([Date],[Description],[Location Code]) VALUES ('%s' ,'%s','%s')"),sDate,sDescr,sLocation);
				pApp->dBaseProg->ExecuteSQL(sSQL);

				long lDoc;
				lDoc = 0;
				CDBVariant dbValue;
				sSQL.Format(_T("select top 1 ID from [Inventary Doc Header] where [Date] = '%s' and [Description] = '%s' and [Location Code] = '%s' order by ID desc"),sDate,sDescr,sLocation);
				Query.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly);
				iField = 0;
				if(!Query.IsEOF())
				{
					
					Query.GetFieldValue(iField, dbValue);
					lDoc = _wtoi(GetValue(&dbValue));
				}
				Query.Close();
				if(lDoc < 1)
				{
					AfxMessageBox(_T("Не создан документ!"));
					bCanExit = FALSE;
					bStart = FALSE;
					pApp->dBaseProg->Rollback();
				}
				else
				{
					CString sDoc;
					sDoc.Format(_T("%d"),lDoc);
					while(saSQL.GetCount()>0)
					{
						sSQL = saSQL.ElementAt(0);
						sSQL.Replace(_T("_LDOC_"),sDoc);
						pApp->dBaseProg->ExecuteSQL(sSQL);
						saSQL.RemoveAt(0,1);
					}
					pApp->dBaseProg->CommitTrans();
				}
			}
			
		}
	catch(CDBException * exp)
	{
		if(bStart)
				pApp->dBaseProg->Rollback();
		AfxMessageBox(exp->m_strError+sSQL);
		exp->Delete();
		return;
	}


	if(bCanExit)
		OnOK();
}

void CDlgNewDoc::LoadData(void)
{
	//return;
	while(m_ComboBrand.GetCount()>0)
		m_ComboBrand.DeleteString(0);
	
	while(m_ComboCellStart.GetCount()>0)
		m_ComboCellStart.DeleteString(0);

	while(m_ComboCellEnd.GetCount()>0)
		m_ComboCellEnd.DeleteString(0);

	CNav_Scaner_InterfaceApp *pApp;
	pApp = (CNav_Scaner_InterfaceApp*)AfxGetApp();
	if(pApp->dBaseProg == NULL)
	{
		AfxMessageBox(_T("Неподключены к БД!"));
		return;
	}

	CString sSQL;
	CDBVariant dbValue;
	try
		{
			CString sFirm = pApp->IniReader.ReadFromIni(_T("DB_NAV"),_T("FIRM"),_T("Shate-M"));
			sSQL.Format(_T("select distinct [Manufacturer Code] from [%s$Item]"),sFirm);
			CBulkRecordset QueryNav(pApp->dBaseNav);
			QueryNav.SetRowsetSize(10);
			QueryNav.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly|CRecordset::useMultiRowFetch);
			int iField;
			iField = 0;
			int rowsFetched,rowCount;
			while(!QueryNav.IsEOF())
			{
				rowsFetched = (int)QueryNav.GetRowsFetched();
				for(rowCount = 0; rowCount < rowsFetched; rowCount++ )
				{
					m_ComboBrand.AddString(QueryNav.GetValue(rowCount,0));
				}
				QueryNav.MoveNext();
			}
			QueryNav.Close();

			sSQL.Format(_T("select [Code] from [%s$Bin] where [Location Code] = '%s' order by Code"),sFirm,sLocation);
			QueryNav.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly|CRecordset::useMultiRowFetch);
			QueryNav.SetRowsetSize(10);
			iField = 0;
			m_ComboCellStart.AddString(_T(""));
			m_ComboCellEnd.AddString(_T(""));
			while(!QueryNav.IsEOF())
			{
				rowsFetched = (int)QueryNav.GetRowsFetched();
				for(rowCount = 0; rowCount < rowsFetched; rowCount++ )
				{
					m_ComboCellStart.AddString(QueryNav.GetValue(rowCount,0));
					m_ComboCellEnd.AddString(QueryNav.GetValue(rowCount,0));
				}
				QueryNav.MoveNext();
			}
			QueryNav.Close();

			
			iField = 0;

			sSQL.Format(_T("select ig1.nodeid,ig1.Code+' '+ig1.[Description],ig2.nodeid,ig2.Code+' '+ig2.[Description],ig3.nodeid,ig3.Code+' '+ig3.[Description] from [%s$Item Group] as ig1 left join [%s$Item Group] as ig2 on ig1.nodeid = ig2.[parentid] left join [%s$Item Group] as ig3 on ig2.nodeid = ig3.[parentid] where ig1.[Item Group Type Code] = 'ТОВЛИНИЯ' and ig1.[parentid] = 0 order by ig1.nodeid,ig2.nodeid,ig3.nodeid"),sFirm,sFirm,sFirm);
			HTREEITEM hItemFirstLevel,hItemSecondLevel,hItemThirdLevel;
			hItemFirstLevel = NULL;
			hItemSecondLevel = NULL;
			hItemThirdLevel = NULL;
			CString sOldFirstLevel,sOldSecondLevel,sOldThirdLevel;
			sOldFirstLevel = "";
			sOldSecondLevel = "";
			
			CBulkRecordset QueryNav1(pApp->dBaseNav);
			QueryNav1.SetRowsetSize(10);
			QueryNav1.Open(CRecordset::snapshot,sSQL, CRecordset::readOnly|CRecordset::useMultiRowFetch);
			
			CString sValue;
			while(!QueryNav1.IsEOF())
			{
				
				rowsFetched = (int)QueryNav1.GetRowsFetched();
				for(rowCount = 0; rowCount < rowsFetched; rowCount++ )
				{
					iField = 0;
					while(iField < QueryNav1.GetODBCFieldCount())
					{
						/*
						m_TreeGroup.InsertItem();
						*/
						sValue = QueryNav1.GetValue(rowCount,iField);
						switch(iField)
						{
							case 0:
								iField++;
								if(sOldFirstLevel != sValue)
								{
									sOldFirstLevel = sValue;
									sValue = QueryNav1.GetValue(rowCount,iField);
									hItemFirstLevel = m_TreeGroup.InsertItem(sValue,NULL,hItemFirstLevel);
									hItemSecondLevel = NULL;
									m_TreeGroup.SetItemData(hItemFirstLevel, _wtoi(sOldFirstLevel));
									//m_TreeGroup.SetCheck(hItemFirstLevel,TRUE);
								}
								break;

							case 2:
								iField++;
								if(sOldSecondLevel != sValue)
								{
									sOldSecondLevel = sValue;
									sValue = QueryNav1.GetValue(rowCount,iField);
									hItemSecondLevel = m_TreeGroup.InsertItem(sValue,hItemFirstLevel,hItemSecondLevel);
									m_TreeGroup.SetItemData(hItemSecondLevel, _wtoi(sOldSecondLevel));
									hItemThirdLevel = NULL;
									//m_TreeGroup.SetCheck(hItemSecondLevel,TRUE);
								}
								break;


							case 4:
								iField++;
								if(sOldThirdLevel != sValue)
								{
									sOldThirdLevel = sValue;
									sValue = QueryNav1.GetValue(rowCount,iField);
									hItemThirdLevel = m_TreeGroup.InsertItem(sValue,hItemSecondLevel,hItemThirdLevel);
									m_TreeGroup.SetItemData(hItemThirdLevel, _wtoi(sOldThirdLevel));
									//m_TreeGroup.SetCheck(hItemThirdLevel,TRUE);
								}
								break;
						
						}
						iField++;
					}
				}
				QueryNav1.MoveNext();
			}
			QueryNav1.Close();
	}
	catch(CDBException * exp)
		{
			AfxMessageBox(exp->m_strError);
			exp->Delete();
			return;
		}
}

void CDlgNewDoc::OnTvnSelchangedTreeGroup(NMHDR *pNMHDR, LRESULT *pResult)
{
	LPNMTREEVIEW pNMTreeView = reinterpret_cast<LPNMTREEVIEW>(pNMHDR);
	// TODO: Add your control notification handler code here
	*pResult = 0;
}

void CDlgNewDoc::OnTvnItemChangedTreeGroup(NMHDR *pNMHDR, LRESULT *pResult)
{
	
}


void CDlgNewDoc::OnNMTVStateImageChangingTreeGroup(NMHDR *pNMHDR, LRESULT *pResult)
{
	// TODO: Add your control notification handler code here
	*pResult = 0;
}

BOOL CDlgNewDoc::PreTranslateMessage(MSG* pMsg)
{
	return CDialog::PreTranslateMessage(pMsg);
}

void CDlgNewDoc::OnCaptureChanged(CWnd *pWnd)
{
	CDialog::OnCaptureChanged(pWnd);
}

void CDlgNewDoc::OnNMChangeState(NMHDR *pNMHDR, LRESULT *pResult)
{
	*pResult = 0;

	NM_TREEVIEW_MY *nmTree =  (NM_TREEVIEW_MY *)pNMHDR;
	m_BtSelectAll.SetCheck(nmTree->iValue);
}

void CDlgNewDoc::OnBnClickedCheckSelectAll()
{
	BOOL bCheck = m_BtSelectAll.GetCheck();
	if(bCheck > 1)
		bCheck = 0;
	if(m_TreeGroup.CheckAll(bCheck)>0)
	{
		m_BtSelectAll.SetCheck(TRUE);
	}
	else
	{
		m_BtSelectAll.SetCheck(FALSE);
	}
	
}

void CDlgNewDoc::OnEnChangeEdit2()
{
	
}

void CDlgNewDoc::OnEnKillfocusEdit2()
{
	CString sValue;
	m_EdDescr.GetWindowTextW(sValue);
	sValue =ReplaceLeftSymbols(sValue,3);
	m_EdDescr.SetWindowTextW(sValue);
}
