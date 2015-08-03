// DlgReport.cpp : implementation file
//

#include "stdafx.h"
#include "RepScan.h"
#include "DlgReport.h"

// CDlgReport dialog

IMPLEMENT_DYNAMIC(CDlgReport, CDialog)

CDlgReport::CDlgReport(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgReport::IDD, pParent)
{
	bAssemble = 1;

}

CDlgReport::~CDlgReport()
{
}

void CDlgReport::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_EDIT_START, m_EdStart);
	DDX_Control(pDX, IDC_EDIT_END, m_EdEnd);
}


BEGIN_MESSAGE_MAP(CDlgReport, CDialog)
	ON_BN_CLICKED(IDOK, &CDlgReport::OnBnClickedOk)
END_MESSAGE_MAP()


// CDlgReport message handlers

BOOL CDlgReport::OnInitDialog()
{
	CDialog::OnInitDialog();

	m_EdStart.setMask(_T("ЧЧ.ЧЧ.ЧЧЧЧ"));
	COleDateTime date;
	date = COleDateTime::GetCurrentTime();
	m_EdStart.SetWindowText(date.Format(_T("%d%m%Y")));
	//m_EdEnd
	
	m_EdEnd.setMask(_T("ЧЧ.ЧЧ.ЧЧЧЧ"));
	m_EdEnd.SetWindowText(date.Format(_T("%d%m%Y")));


	return TRUE;  // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgReport::OnBnClickedOk()
{
	CString sStart, sEnd;

	m_EdEnd.GetWindowText(sEnd);
	m_EdStart.GetWindowText(sStart);

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
	
	COleDateTimeSpan ts = 1; 

	if(bAssemble == 1)
	{
		CRepScanApp *pApp;
		pApp = (CRepScanApp*)AfxGetApp();
		if(pApp->dBase == NULL)
			return ;
		
		try
		{
			/*CString sSQL;
			CRecordset Query(pApp->dBase);
			CDBVariant oValue;
			sSQL.Format(_T("select name, (Right(left(name,8),4)+Right(left(name,4),2)+left(name,2)) as dat from sysobjects where  Right(name,3) = '_BQ'"));
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			sSQL = _T("");
			CString NewDate;
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("name"),oValue);
				CString sDate;
				sDate = GetValue(&oValue);
				sDate = sDate.Left(8);
				NewDate = sDate.Right(4);
				sDate = sDate.Left(4);
				NewDate = NewDate + sDate.Right(2)+sDate.Left(2);
				if((NewDate>=datStart.Format(_T("%Y%m%d")))&&(NewDate<=datEnd.Format(_T("%Y%m%d"))))
				{
					if(sSQL =="")
						sSQL = _T("select '111' as Employee, count(*) as ConDay, '")+NewDate+_T("' as dat from    (select ID_DOC,ID_ZONE,task,BOX from [")+GetValue(&oValue)+_T("] group by ID_DOC,ID_ZONE,task,BOX) as testtab  ");
					else
						sSQL = sSQL + _T("\n union select '111' as Employee, count(*) as ConDay, '")+NewDate+_T("' as dat from    (select ID_DOC,ID_ZONE,task,BOX from [")+GetValue(&oValue)+_T("] group by ID_DOC,ID_ZONE,task,BOX) as testtab  ");
				}
				Query.MoveNext();	
			}
			Query.Close();
		
			if(sSQL.GetLength()<1)
				return;

			sSQL = _T("select Employee, ConDay, dat from (")+sSQL+_T(") as testday order by Employee, dat");
			Excel::WorkbooksPtr ExcelBooks;
			Excel::_WorkbookPtr ExcelBook;
			Excel::_WorksheetPtr ExcelSheet;
			Excel::RangePtr range;

			appExcel.CreateInstance(_T("Excel.Application"));
			VARIANT bTRUE;
		    bTRUE.vt = 11;
			bTRUE.boolVal = TRUE;
			appExcel->Visible[0] = TRUE;
			ExcelBook= appExcel->Workbooks->Add();
			ExcelSheet = ExcelBook->Worksheets->Item[1];
			
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);

			int iRow;

			iRow = 1;

			CString sName;
			CString oldMan;
			int iCol;

			iCol=2;
			cDate = datStart;
			CString sDat;

			sDat = _T("Сборщики");
			ExcelSheet->Cells->Item[1,1] = sDat.AllocSysString();
			
			while(cDate<=datEnd)
			{
				sDat = cDate.Format(_T("%d.%m.%Y"));
				ExcelSheet->Cells->Item[1,iCol] = sDat.AllocSysString();
				cDate = cDate + ts;
				iCol++;
			}

			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("Employee"),oValue);
				if(GetValue(&oValue)!=oldMan)
				{
					iRow++;
					sName = GetValue(&oValue);
					ExcelSheet->Cells->Item[iRow,1] = sName.AllocSysString();
					oldMan = sName;
				}
				
				cDate = datStart;
				iCol = 2;

				Query.GetFieldValue(_T("ConDay"),oValue);
				sName = GetValue(&oValue);

				Query.GetFieldValue(_T("dat"),oValue);

				sDat = _T("");

				while(cDate<=datEnd)
				{
					sDat = cDate.Format(_T("%Y%m%d"));
					if(sDat==GetValue(&oValue))
					{
						ExcelSheet->Cells->Item[iRow,iCol] = sName.AllocSysString();
						break;
					}
					sDat = GetValue(&oValue);
					cDate = cDate + ts;
					iCol++;
				}
				Query.MoveNext();
			}
			Query.Close();

			/*CString sSQL;
			CRecordset Query(pApp->dBase);
			sSQL.Format(_T("select name, (Right(left(name,8),4)+Right(left(name,4),2)+left(name,2)) as dat from sysobjects where  Right(name,3) = '_BQ'"));

			CDBVariant oValue;
			//for(datStart.Start)
			//sSQL.Format(_T("select ID_DOC,docData from DOC_MAP where DocNumberVis = '%s'"),sBarCode);
			
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			sSQL = _T("");
			CString NewDate;
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("name"),oValue);
				CString sDate;
				sDate = GetValue(&oValue);
				sDate = sDate.Left(8);
				NewDate = sDate.Right(4);
				sDate = sDate.Left(4);
				NewDate = NewDate + sDate.Right(2)+sDate.Left(2);
				if((NewDate>=datStart.Format(_T("%Y%m%d")))&&(NewDate<=datEnd.Format(_T("%Y%m%d"))))
				{
					if(sSQL =="")
						sSQL = _T("select Employee, count(test.con) as ConDay, '")+NewDate+_T("'  as dat from (select Employee,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("] group by Employee,id_doc,sort,task)  as test group by Employee");
					else
						sSQL = sSQL + _T("\n union select Employee, count(test.con), '")+NewDate+_T("' as dat from (select Employee,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("] group by Employee,id_doc,sort,task)  as test  group by Employee");
				}
				Query.MoveNext();	
			}
			Query.Close();
		
			if(sSQL.GetLength()<1)
				return;


			sSQL = _T("select Employee, ConDay, dat from (")+sSQL+_T(") as testday order by Employee, dat");
			Excel::WorkbooksPtr ExcelBooks;
			Excel::_WorkbookPtr ExcelBook;
			Excel::_WorksheetPtr ExcelSheet;
			Excel::RangePtr range;

			appExcel.CreateInstance(_T("Excel.Application"));
			VARIANT bTRUE;
		    bTRUE.vt = 11;
			bTRUE.boolVal = TRUE;
			appExcel->Visible[0] = TRUE;
			ExcelBook= appExcel->Workbooks->Add();
			ExcelSheet = ExcelBook->Worksheets->Item[1];
			
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);

			int iRow;

			iRow = 1;

			CString sName;
			CString oldMan;
			int iCol;

			iCol=2;
			cDate = datStart;
			CString sDat;

			sDat = _T("Сборщики");
			ExcelSheet->Cells->Item[1,1] = sDat.AllocSysString();
			
			while(cDate<=datEnd)
			{
				sDat = cDate.Format(_T("%d.%m.%Y"));
				ExcelSheet->Cells->Item[1,iCol] = sDat.AllocSysString();
				cDate = cDate + ts;
				iCol++;
			}

			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("Employee"),oValue);
				if(GetValue(&oValue)!=oldMan)
				{
					iRow++;
					sName = GetValue(&oValue);
					ExcelSheet->Cells->Item[iRow,1] = sName.AllocSysString();
					oldMan = sName;
				}
				
				cDate = datStart;
				iCol = 2;

				Query.GetFieldValue(_T("ConDay"),oValue);
				sName = GetValue(&oValue);

				Query.GetFieldValue(_T("dat"),oValue);

				sDat = _T("");

				while(cDate<=datEnd)
				{
					sDat = cDate.Format(_T("%Y%m%d"));
					if(sDat==GetValue(&oValue))
					{
						ExcelSheet->Cells->Item[iRow,iCol] = sName.AllocSysString();
						break;
					}
					sDat = GetValue(&oValue);
					cDate = cDate + ts;
					iCol++;
				}
				Query.MoveNext();
			}
			Query.Close();*/

		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError);
			exsept->Delete();
			return ;
		}
		return;
	}
	
	if(bAssemble == 0)
	{
		CRepScanApp *pApp;
		pApp = (CRepScanApp*)AfxGetApp();
		if(pApp->dBase == NULL)
			return ;
		
		try
		{
			CString sSQL;
			CRecordset Query(pApp->dBase);
			
			CDBVariant oValue;
			sSQL.Format(_T("select  [Operation User] as UserName, Count(*) as ConDay, Left(CONVERT ( nchar , [Checked Date], 112),10) as dat from (select [Operation User], [Shipment No_],[Item No_],[Whse_ Document No_],[Checked Date] from [%s$Shipment Check Register] where Left(CONVERT ( nchar , [Checked Date], 112),8) >= '%s' and Left(CONVERT ( nchar , [Checked Date], 112),8) <= '%s' group by [Operation User], [Shipment No_],[Item No_],[Whse_ Document No_],[Checked Date]) as TestTab group by  [Operation User],[Checked Date] ORDER BY  [Operation User],[Checked Date]"), sDatabase,datStart.Format(_T("%Y%m%d")),datEnd.Format(_T("%Y%m%d")));
			
			/*
			sSQL.Format(_T("select name, (Right(left(name,8),4)+Right(left(name,4),2)+left(name,2)) as dat from sysobjects where  Right(name,8) = '_DocsDet'"));
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			sSQL = _T("");
			CString NewDate;
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("name"),oValue);
				CString sDate;
				sDate = GetValue(&oValue);
				sDate = sDate.Left(8);
				NewDate = sDate.Right(4);
				sDate = sDate.Left(4);
				NewDate = NewDate + sDate.Right(2)+sDate.Left(2);
				if((NewDate>=datStart.Format(_T("%Y%m%d")))&&(NewDate<=datEnd.Format(_T("%Y%m%d"))))
				{
					if(sSQL =="")
						sSQL = _T("select tUser,(select NAME from USERS where tUser = USERS.ID) as UserName, count(testTab.con) as ConDay, '")+NewDate+_T("'  as dat from (select tUser,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("] group by tUser,id_doc,sort,task)  as testTab group by tUser");
					else
						sSQL = sSQL + _T("\n union select tUser,(select NAME from USERS where tUser = USERS.ID) as UserName, count(testTab.con), '")+NewDate+_T("' as dat from (select tUser,id_doc, sort,task, count(*) as con from [")+GetValue(&oValue)+_T("] group by tUser,id_doc,sort,task)  as testTab  group by tUser");
				}
				Query.MoveNext();	
			}
			Query.Close();
		
			if(sSQL.GetLength()<1)
				return;


			sSQL = _T("select UserName, ConDay, dat from (")+sSQL+_T(") as testday order by UserName, dat");
			*/
			Excel::WorkbooksPtr ExcelBooks;
			Excel::_WorkbookPtr ExcelBook;
			Excel::_WorksheetPtr ExcelSheet;
			Excel::RangePtr range;

			appExcel.CreateInstance( _T("Excel.Application"));
			VARIANT bTRUE;
		    bTRUE.vt = 11;
			bTRUE.boolVal = TRUE;
			appExcel->Visible[0] = TRUE;
			ExcelBook= appExcel->Workbooks->Add();
			ExcelSheet = ExcelBook->Worksheets->Item[1];
			
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);

			int iRow;

			iRow = 1;

			CString sName;
			CString oldMan;
			int iCol;

			iCol=2;
			cDate = datStart;
			CString sDat;

			sDat = _T("Проверка");
			ExcelSheet->Cells->Item[1,1] = sDat.AllocSysString();
			
			while(cDate<=datEnd)
			{
				sDat = cDate.Format(_T("%d.%m.%Y"));
				ExcelSheet->Cells->Item[1,iCol] = sDat.AllocSysString();
				cDate = cDate + ts;
				iCol++;
			}

			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("UserName"),oValue);
				if(GetValue(&oValue)!=_T(""))
				{
					if(GetValue(&oValue)!=oldMan)
					{
						iRow++;
						sName = GetValue(&oValue);
						ExcelSheet->Cells->Item[iRow,1] = sName.AllocSysString();
						oldMan = sName;
					}
				
					cDate = datStart;
					iCol = 2;
	
					Query.GetFieldValue(_T("ConDay"),oValue);
					sName = GetValue(&oValue);
		
					Query.GetFieldValue(_T("dat"),oValue);
	
					sDat = _T("");
					while(cDate<=datEnd)
					{
						sDat = cDate.Format(_T("%Y%m%d"));
						if(sDat==GetValue(&oValue))
						{
							ExcelSheet->Cells->Item[iRow,iCol] = sName.AllocSysString();
							break;
						}
						sDat = GetValue(&oValue);
						cDate = cDate + ts;
						iCol++;
					}
				}
				Query.MoveNext();
			}
			Query.Close();
		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError);
			exsept->Delete();
			return ;
		}
		return;
	}

	if(bAssemble == 2)
	{
		CRepScanApp *pApp;
		pApp = (CRepScanApp*)AfxGetApp();
		if(pApp->dBase == NULL)
			return ;
		
		try
		{

			CString sSQL;
			CRecordset Query(pApp->dBase);
			/*
			datStart.ParseDateTime(sStart);
			datEnd.ParseDateTime(sEnd);
			*/

			VARIANT bTRUE;
		    bTRUE.vt = 11;
			bTRUE.boolVal = TRUE;
			Excel::WorkbooksPtr ExcelBooks;
			Excel::_WorkbookPtr ExcelBook;
			Excel::_WorksheetPtr ExcelSheet;
			Excel::RangePtr range;
			

			appExcel.CreateInstance( _T("Excel.Application"));
			appExcel->Visible[0] = TRUE;
			ExcelBook= appExcel->Workbooks->Add();
			ExcelSheet = ExcelBook->Worksheets->Item[1];
			
			
			sSQL.Format(_T("select DT, LogData from dbo.Analis_Log where TYPE = 1 and left(DT,8) >= '%s' and left(DT,8) <= '%s' order by DT"),datStart.Format(_T("%Y%m%d")),datEnd.Format(_T("%Y%m%d")));
			CDBVariant oValue;
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			sSQL = _T("");
			CString sDat;
			CString sNewData;

			//ExcelSheet->Cells->Item[1,1] = sDat.AllocSysString();
			int iColumn = 1;
			int iRow;
			int iRowStartAss;

			int iFind;
			bool bAss;
			iRowStartAss = 0;
			int iAssemblers;
			ExcelSheet->Cells->Item[3,1] = _T("Всего выпущенно");
			ExcelSheet->Cells->Item[4,1] = _T("Очередь");
			ExcelSheet->Cells->Item[5,1] = _T("   Д/Н");
			ExcelSheet->Cells->Item[6,1] = _T("   Экспресс");
			ExcelSheet->Cells->Item[7,1] = _T("   Регион");
			ExcelSheet->Cells->Item[8,1] = _T("Кол-во сборщиков");
			ExcelSheet->Cells->Item[9,1] = _T("Кол-во проверяющих");
			ExcelSheet->Cells->Item[10,1] = _T("Собранно за отчетный период");
			ExcelSheet->Cells->Item[11,1] = _T("Проверенно за отчетный период");
			ExcelSheet->Cells->Item[12,1] = _T("Средняя сборка");
			ExcelSheet->Cells->Item[13,1] = _T("Средняя проверка");
			CString sVal;
			int iTasks;
			int iStrings;
			int iOldAss;
			int iOldTest;
			iOldAss = 0;
			
			iOldTest = 0;
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("DT"),oValue);
				sDat = GetValue(&oValue);
				iColumn++;
				sNewData = _T(".")+sDat.Left(4);
				sNewData = _T(".")+sDat.Left(6).Right(2)+sNewData;
				sNewData = sDat.Left(8).Right(2)+sNewData;
				ExcelSheet->Cells->Item[1,iColumn] = sNewData.AllocSysString();
				sNewData = sDat.Right(6).Left(2);
				sNewData = sNewData+_T(":")+sDat.Right(4).Left(2);
				ExcelSheet->Cells->Item[2,iColumn] = sNewData.AllocSysString();
				
				Query.GetFieldValue(_T("LogData"),oValue);
				sDat = GetValue(&oValue);
				
				iFind = sDat.Find(_T("\n"),0);
				bAss = FALSE;
				iAssemblers = 0;
				//ExcelSheet->Cells->Item[3,iColumn] = _T("0");
				ExcelSheet->Cells->Item[3,iColumn] = _T("0");
				ExcelSheet->Cells->Item[4,iColumn] = _T("0");
				ExcelSheet->Cells->Item[5,iColumn] = _T("0");
				ExcelSheet->Cells->Item[6,iColumn] = _T("0");
				ExcelSheet->Cells->Item[7,iColumn] = _T("0");
				ExcelSheet->Cells->Item[8,iColumn] = _T("0");
				ExcelSheet->Cells->Item[9,iColumn] = _T("0");
				ExcelSheet->Cells->Item[10,iColumn] = _T("0");
				ExcelSheet->Cells->Item[11,iColumn] = _T("0");
				
				range = ExcelSheet->Cells->Item[12,iColumn];
				range->PutFormula(_T("=R[-2]C/R[-4]C"));
				range = ExcelSheet->Cells->Item[13,iColumn];
				range->PutFormula(_T("=R[-2]C/R[-4]C"));



				int Val;
				
				while(iFind > 0)
				{
					sNewData = sDat.Left(iFind);
					sDat = sDat.Right(sDat.GetLength()-iFind-1);
					iFind = sDat.Find(_T("\n"),0);
					Val = 0;
					iRow = GetRowPos(&sNewData,&Val);
					if(iRow > 1)
					{	
						/*sVal.Format(_T("%d"),Val);
						ExcelSheet->Cells->Item[iRow,iColumn] = sVal.AllocSysString();*/

						sVal.Format(_T("%d"),Val);
						if(iRow == 10)
						{
							//iOldAss
							ExcelSheet->Cells->Item[20,iColumn] = sVal.AllocSysString();
							if(iOldAss < Val)
							{
								sVal.Format(_T("%d"),Val-iOldAss);
							}
							else
							{
								sVal.Format(_T("%d"),Val);
							}
							iOldAss = Val;

						}
						//iOldTest
						if(iRow == 11)
						{
							//iOldAss
							ExcelSheet->Cells->Item[21,iColumn] = sVal.AllocSysString();
							if(iOldTest < Val)
							{
								sVal.Format(_T("%d"),Val-iOldTest);
							}
							else
							{
								sVal.Format(_T("%d"),Val);
							}
							iOldTest = Val;

						}
						ExcelSheet->Cells->Item[iRow,iColumn] = sVal.AllocSysString();
						
					}
					iRow = GetRowsZones(&sNewData, &sDat,&iTasks, &iStrings,&iAssemblers);
					if(iRow > 0)
					{	
						sVal.Format(_T("%d"),iAssemblers);
						ExcelSheet->Cells->Item[8,iColumn] = sVal.AllocSysString();
					}
					//GetRowsLines
					iRow = GetRowsLines(&sNewData, &sDat,&iTasks, &iStrings,&iAssemblers);
					if(iRow > 0)
					{	
						sVal.Format(_T("%d"),iAssemblers);
						ExcelSheet->Cells->Item[9,iColumn] = sVal.AllocSysString();
					}


					
					iFind = sDat.Find(_T("\n"),0);
				}
				

				Query.MoveNext();	
			}
			Query.Close();
		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError);
			exsept->Delete();
			return ;
		}
		return;
	}

	if(bAssemble == 3)
	{
		CRepScanApp *pApp;
		pApp = (CRepScanApp*)AfxGetApp();
		if(pApp->dBase == NULL)
			return ;
		
		try
		{

			CString sSQL;
			CRecordset Query(pApp->dBase);
		
			VARIANT bTRUE;
		    bTRUE.vt = 11;
			bTRUE.boolVal = TRUE;
			Excel::WorkbooksPtr ExcelBooks;
			Excel::_WorkbookPtr ExcelBook;
			Excel::_WorksheetPtr ExcelSheet;
			Excel::RangePtr range;
			

			appExcel.CreateInstance( _T("Excel.Application"));
			appExcel->Visible[0] = TRUE;
			ExcelBook= appExcel->Workbooks->Add();
			ExcelSheet = ExcelBook->Worksheets->Item[1];
			
			COleDateTimeSpan ts1 = 1; 
			datEnd = datEnd + ts1;
			sSQL.Format(_T("select TYPE, LogData, DT from Analis_Log  where TYPE <> 1 and DT >= '%s' and DT <= '%s' order by id"),datStart.Format(_T("%Y%m%d%H%M%S")),datEnd.Format(_T("%Y%m%d%H%M%S")));
			CDBVariant oValue;
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			sSQL = _T("");
			CString sDat;
			CString sNewData;

			int iColumn = 1;
						
			ExcelSheet->Cells->Item[2,1] = _T("Проверяющие");
			range = ExcelSheet->Cells->Item[2,1];
			range->PutColumnWidth(20);

			cDate = datStart;
			COleDateTimeSpan ts(0,0,10, 0); 

			
			COleDateTime cDate;
			cDate = datStart;
			iColumn = 2;
			
			

			while(cDate<datEnd)
			{
				sDat = cDate.Format(_T("%d.%m.%Y"));
				ExcelSheet->Cells->Item[1,iColumn] = sDat.AllocSysString();
				range = ExcelSheet->Cells->Item[2,iColumn];
				range->PutColumnWidth(1);
				sDat = cDate.Format(_T("'%H:%M"));
				ExcelSheet->Cells->Item[2,iColumn] = sDat.AllocSysString();
				cDate = cDate + ts;
				iColumn++;
			}

			_variant_t oVal;
			CString sUserName;
			int iRow;
			while(!Query.IsEOF())
			{
				Query.GetFieldValue(_T("TYPE"),oValue);
				if(GetValueID(&oValue)==3)
				{
					Query.GetFieldValue(_T("LogData"),oValue);
					sUserName = GetValue(&oValue);
					
					
					iRow = 3;
					range = ExcelSheet->Cells->Item[iRow,1];
					
					oVal = range->GetValue2();
					CString sOld;
					while(oVal.vt != 0)
					{
						sOld.Format(_T("%s"),oVal.bstrVal);
						if(sOld == sUserName.AllocSysString())
						{
							break;
						}
						iRow++;
						range = ExcelSheet->Cells->Item[iRow,1];
						oVal = range->GetValue2();
					}

					if(oVal.vt == 0)
					{
						ExcelSheet->Cells->Item[iRow,1] = sUserName.AllocSysString();
					}
					
					Query.GetFieldValue(_T("DT"),oValue);
					CString sDate, sDateFormat;
					sDate = GetValue(&oValue);
					
					sNewData = _T(".")+sDate.Left(4);
					sNewData = _T(".")+sDate.Left(6).Right(2)+sNewData;
					sNewData = sDate.Left(8).Right(2)+sNewData;
					iColumn = 2;
					
					range = ExcelSheet->Cells->Item[1,iColumn];
					oVal = range->GetValue2();
					while(oVal.vt != 0)
					{
						sOld.Format(_T("%s"),oVal.bstrVal);
						if(sOld == sNewData.AllocSysString())
						{
							break;
						}
						iColumn++;
						range = ExcelSheet->Cells->Item[1,iColumn];
						oVal = range->GetValue2();
					}
					
					if(oVal.vt != 0)
					{
						sNewData = sDate.Right(6).Left(2);
						sNewData = sNewData+_T(":")+sDate.Right(4).Left(2);

						range = ExcelSheet->Cells->Item[2,iColumn];
						oVal = range->GetValue2();
						CString sOld;
						while(oVal.vt != 0)
						{
							sOld.Format(_T("%s"),oVal.bstrVal);
							if(sOld >= sNewData.AllocSysString())
							{	
								break;
							}
							iColumn++;
							range = ExcelSheet->Cells->Item[2,iColumn];
							oVal = range->GetValue2();
						}

					}
					
					iColumn--;
					if(iColumn < 2)
						iColumn = 2;
					
					ExcelSheet->Cells->Item[iRow,iColumn] = _T("X");
				}
				else
				if(GetValueID(&oValue)==2)
				{
					Query.GetFieldValue(_T("LogData"),oValue);
					sUserName = GetValue(&oValue);
					
					int iRow;
					iRow = 3;
					range = ExcelSheet->Cells->Item[iRow,1];
					_variant_t oVal;
					oVal = range->GetValue2();
					CString sOld;
					if(sUserName ==_T("|32|"))
					{
						iRow = iRow;
					}
					while(oVal.vt != 0)
					{
						sOld.Format(_T("%s"),oVal.bstrVal);
						if(sOld == sUserName.AllocSysString())
						{
							break;
						}
						iRow++;
						range = ExcelSheet->Cells->Item[iRow,1];
						oVal = range->GetValue2();
					}

					if(oVal.vt == 0)
					{
						ExcelSheet->Cells->Item[iRow,1] = sUserName.AllocSysString();
					}
					
					Query.GetFieldValue(_T("DT"),oValue);
					CString sDate, sDateFormat;
					sDate = GetValue(&oValue);
					
					sNewData = _T(".")+sDate.Left(4);
					sNewData = _T(".")+sDate.Left(6).Right(2)+sNewData;
					sNewData = sDate.Left(8).Right(2)+sNewData;
					iColumn = 2;
					
					range = ExcelSheet->Cells->Item[1,iColumn];
					oVal = range->GetValue2();
					while(oVal.vt != 0)
					{
						sOld.Format(_T("%s"),oVal.bstrVal);
						if(sOld == sNewData.AllocSysString())
						{

							break;
						}
						iColumn++;
						range = ExcelSheet->Cells->Item[1,iColumn];
						oVal = range->GetValue2();
					}
					
					if(oVal.vt != 0)
					{
						sNewData = sDate.Right(6).Left(2);
						sNewData = sNewData+_T(":")+sDate.Right(4).Left(2);

						range = ExcelSheet->Cells->Item[2,iColumn];
						oVal = range->GetValue2();
						CString sOld;
						while(oVal.vt != 0)
						{
							sOld.Format(_T("%s"),oVal.bstrVal);
							if(sOld >= sNewData.AllocSysString())
							{	
								break;
							}
							iColumn++;
							range = ExcelSheet->Cells->Item[2,iColumn];
							oVal = range->GetValue2();
						}

					}
					
					iColumn--;
					while(iColumn > 1)
					{
						range = ExcelSheet->Cells->Item[iRow,iColumn];
						oVal = range->GetValue2();
						if(oVal.vt != 0)
						{
							break;
						}
						ExcelSheet->Cells->Item[iRow,iColumn] = _T("X");
						iColumn--;
					}

				}
				Query.MoveNext();	
			}
			Query.Close();


			iRow = 3;
			while(iColumn > 1)
			{
				range = ExcelSheet->Cells->Item[iRow,1];
				oVal = range->GetValue2();
				if(oVal.vt == 0)
				{
					break;
				}
				sDat.Format(_T("%s"),oVal.bstrVal);
				sDat = sDat.Right(sDat.GetLength()-1);
				if(sDat.Find(_T("|"),0) > 0)
					sDat = sDat.Left(sDat.Find(_T("|"),0));
				sSQL.Format(_T("select name from users where id = %s"),sDat);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				if(!Query.IsEOF())
				{
					Query.GetFieldValue(_T("name"),oValue);
					sDat = GetValue(&oValue);
					ExcelSheet->Cells->Item[iRow,1] = sDat.AllocSysString();
				}
				Query.Close();
				iRow++;
			}


		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError);
			exsept->Delete();
			return ;
		}
		return;
	}

}

int CDlgReport::GetRowPos(CString* sData, int* Val)
{
	int iRet;
	iRet = 0;
	int iFind;
	iFind = sData->Find(_T("-"),0);
	CString sVal;
	sVal = sData->Left(iFind);
	/*
		ExcelSheet->Cells->Item[3,1] = _T("Всего выпущенно");
		ExcelSheet->Cells->Item[4,1] = _T("Очередь");
		ExcelSheet->Cells->Item[5,1] = _T("   Д/Н");
		ExcelSheet->Cells->Item[6,1] = _T("   Экспресс");
		ExcelSheet->Cells->Item[7,1] = _T("   Регион");
		ExcelSheet->Cells->Item[8,1] = _T("Кол-во сборщиков");
		ExcelSheet->Cells->Item[9,1] = _T("Кол-во проверяющих");
		ExcelSheet->Cells->Item[10,1] = _T("Собранно за отчетный период");
		ExcelSheet->Cells->Item[11,1] = _T("Проверенно за отчетный период");
		ExcelSheet->Cells->Item[12,1] = _T("Средняя сборка");
		ExcelSheet->Cells->Item[13,1] = _T("Средняя проверка");
	*/
	if(iFind > -1)
	{
		if(sVal == _T("Строк для сборки "))
		{
			*Val = _wtoi(sData->Right(sData->GetLength()-2-iFind));
			iRet = 4;			
		}

		if(sVal == _T("Собранно "))
		{
			*Val = _wtoi(sData->Right(sData->GetLength()-2-iFind));
			iRet = 10;
		}

		if(sVal == _T("Проверенно "))
		{
			*Val = _wtoi(sData->Right(sData->GetLength()-2-iFind));
			iRet = 11;
		}

		if(sVal == _T("Д/Н "))
		{
			*Val = _wtoi(sData->Right(sData->GetLength()-2-iFind));
			iRet = 5;
		}

		if(sVal == _T("Д/Н "))
		{
			*Val = _wtoi(sData->Right(sData->GetLength()-2-iFind));
			iRet = 5;
		}

		if(sVal == _T("Экспресс "))
		{
			*Val = _wtoi(sData->Right(sData->GetLength()-2-iFind));
			iRet = 6;
		}

		if(sVal == _T("Регион "))
		{
			*Val = _wtoi(sData->Right(sData->GetLength()-2-iFind));
			iRet = 7;
		}
	}

	
	return iRet;
}

int CDlgReport::GetRowsZones(CString* sString, CString* sData, int* iTasks,int* iStrings,int* iAssemblers)
{
	int iRet = 0;
	
	*iTasks = 0;
	*iStrings = 0;
	*iAssemblers = 0;
	CString sNewData;
	int iFind;
	if(*sString == _T("Зона\tЗаданий\tСтрок\tСборщиков"))
	{
		iRet = 1;
		iFind = sData->Find(_T("\n"),0);
		int iFinrt;
		while(iFind > -1)
		{
			sNewData = sData->Left(iFind);
			if(sNewData == _T("Ручей\tЗаданий\tПроверяющих"))
				break;
			*sData = sData->Right(sData->GetLength()-1-iFind);
			iFind = sData->Find(_T("\n"),0);
			
			iFinrt = sNewData.Find(_T("\t"));
			sNewData = sNewData.Right(sNewData.GetLength()-iFinrt-1);

			iFinrt = sNewData.Find(_T("\t"));
			if(iFinrt>0)
			{
				*iTasks = *iTasks + _wtoi(sNewData.Left(iFinrt));
			}
			sNewData = sNewData.Right(sNewData.GetLength()-iFinrt-1);

			iFinrt = sNewData.Find(_T("\t"));
			if(iFinrt>0)
			{
				*iStrings = *iStrings + _wtoi(sNewData.Left(iFinrt));
			}
			sNewData = sNewData.Right(sNewData.GetLength()-iFinrt-1);

			iFinrt = sNewData.GetLength();
			if(iFinrt>0)
			{
				*iAssemblers = *iAssemblers + _wtoi(sNewData.Left(iFinrt));
			}
			sNewData = sNewData.Right(sNewData.GetLength()-iFinrt-1);
		}
		
	}
	return iRet;
}

int CDlgReport::GetRowsLines(CString* sString, CString* sData, int* iLine,int* iTasc,int* iTested)
{
	int iRet = 0;
	*iTasc = 0;
	*iLine = 0;
	*iTested = 0;
	CString sNewData;
	int iFind;
	if(*sString == _T("Ручей\tЗаданий\tПроверяющих"))
	{
		iRet = 1;
		iFind = sData->Find(_T("\n"),0);
		int iFinrt;
		while(iFind > -1)
		{
			sNewData = sData->Left(iFind);
			/*if(sNewData == _T("Ручей\tЗаданий\tПроверяющих"))
				break;*/
			*sData = sData->Right(sData->GetLength()-1-iFind);
			iFind = sData->Find(_T("\n"),0);
			
			iFinrt = sNewData.Find(_T("\t"));
			if(iFinrt>0)
			{
				//*iLine = *iLine + _wtoi(sNewData.Left(iFinrt));
			}
			sNewData = sNewData.Right(sNewData.GetLength()-iFinrt-1);

			iFinrt = sNewData.Find(_T("\t"));
			if(iFinrt>0)
			{
				*iTasc = *iTasc + _wtoi(sNewData.Left(iFinrt));
			}
			sNewData = sNewData.Right(sNewData.GetLength()-iFinrt-1);

			iFinrt = sNewData.GetLength();
			if(iFinrt>0)
			{
				*iTested = *iTested + _wtoi(sNewData.Left(iFinrt));
			}
			sNewData = sNewData.Right(sNewData.GetLength()-iFinrt-1);
		}
		
	}
	return iRet;
}