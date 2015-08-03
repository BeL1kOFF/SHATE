// DlgReportMounth.cpp : implementation file
//

#include "stdafx.h"
#include "RepScan.h"
#include "DlgReportMounth.h"
#include <locale.h>


// CDlgReportMounth dialog

IMPLEMENT_DYNAMIC(CDlgReportMounth, CDialog)

CDlgReportMounth::CDlgReportMounth(CWnd* pParent /*=NULL*/)
	: CDialog(CDlgReportMounth::IDD, pParent)
{

}

CDlgReportMounth::~CDlgReportMounth()
{
}

void CDlgReportMounth::DoDataExchange(CDataExchange* pDX)
{
	CDialog::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_COMBO_MOUNTH, m_ComboMounth);
	DDX_Control(pDX, IDC_COMBO_YEAR, m_ComboYear);
}


BEGIN_MESSAGE_MAP(CDlgReportMounth, CDialog)
	ON_BN_CLICKED(IDOK, &CDlgReportMounth::OnBnClickedOk)
END_MESSAGE_MAP()


// CDlgReportMounth message handlers

BOOL CDlgReportMounth::OnInitDialog()
{
	CDialog::OnInitDialog();

	setlocale(LC_ALL,"Russian");
	COleDateTime oData;
	int iVal, iYear;
	int i;
	int iMount;
	oData = COleDateTime::GetCurrentTime();
	iMount = oData.GetMonth();
	iYear = oData.GetYear();
	for(i = 1;i<13;i++)
	{
		oData.SetDate(2011,i,1);
		iVal = m_ComboMounth.InsertString(i-1,oData.Format(_T("%B")));
		if(iMount==i)
		{
		iMount = iVal;
		}
		m_ComboMounth.SetItemData(iVal,i);
	}
	m_ComboMounth.SetCurSel(iMount);

	CString sVal;
	for(i = 2000;i<2020;i++)
	{
		sVal.Format(_T("%d"),i);
		iVal = m_ComboYear.InsertString(i-2000,sVal);
		if(iYear == i)
		{
			iYear = iVal;
		}
		m_ComboYear.SetItemData(iVal,i);
	}
	m_ComboYear.SetCurSel(iYear);
	return TRUE;  // return TRUE unless you set the focus to a control
	// EXCEPTION: OCX Property Pages should return FALSE
}

void CDlgReportMounth::OnBnClickedOk()
{
	CString sStart, sEnd;

	if(m_ComboYear.GetCurSel()<0)
	{
		AfxMessageBox(_T("Не выбран год"));
		return;
	}
	int iYear;
	iYear = m_ComboYear.GetItemData(m_ComboYear.GetCurSel());
	if((iYear < 2000)||(iYear>2019))
	{
		AfxMessageBox(_T("Ошибка в программе"));
		return;
	}
	if(m_ComboMounth.GetCurSel()<0)
	{
		AfxMessageBox(_T("Не выбранн месяц"));
		return;
	}
	int iMounth;
	iMounth = m_ComboMounth.GetItemData(m_ComboMounth.GetCurSel());
	if((iMounth < 1)||(iMounth>12))
	{
		AfxMessageBox(_T("Ошибка в программе"));
		return;
	}
	

	CRepScanApp *pApp;
	pApp = (CRepScanApp*)AfxGetApp();
	if(pApp->dBase == NULL)
	{
		AfxMessageBox(_T("Нет доступа к БД"));
		return ;
	}

	CString sSelectDate;
	if(iMounth < 10)
		sSelectDate.Format(_T("%d0%d"),iYear,iMounth);
	else
		sSelectDate.Format(_T("%d%d"),iYear,iMounth);

		
	try
		{
			CString sSQL;
			CRecordset Query(pApp->dBase);
			CDBVariant oValue;


			/*sSQL.Format(_T("select name, (Right(left(name,8),4)+Right(left(name,4),2)+left(name,2)) as dat from sysobjects where  Right(name,9) = '%s_BQ'"),sSelectDate);
			
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
				if(sSQL =="")
					sSQL = _T("select Employee, count(test.con) as ConDay,id_zone, '")+NewDate+_T("'  as dat from (select Employee,id_doc,id_zone, sort,task, 1 as con from [")+GetValue(&oValue)+_T("] group by Employee,id_doc,id_zone,sort,task)  as test group by Employee ,id_zone");
				else
					sSQL = sSQL + _T("\n union select Employee, count(test.con) as ConDay,id_zone, '")+NewDate+_T("' as dat from (select Employee,id_doc,id_zone, sort,task, 1 as con from [")+GetValue(&oValue)+_T("] group by Employee,id_doc,id_zone,sort,task)  as test group by Employee ,id_zone");
				Query.MoveNext();	
			}
			Query.Close();
		
			if(sSQL.GetLength()<1)
				return;


			sSQL = _T("select Employee, id_zone,ConDay, dat from (")+sSQL+_T(") as testday order by Employee, dat, id_zone");
			*/
			/*
			Registered Whse. Activity Line
			*/
			
			/*sSQL = _T("select [Assigned User ID] as Employee,[Zone Code] as id_zone,count(*) as ConDay from ( SELECT [Source Document No_],[Pick No_],[Assigned User ID],[Item No_],[Zone Code],[From Bin Code]  FROM [")+sDatabase;
			sSQL = sSQL + _T("$Picking Operation Register]  join [")+sDatabase;
			sSQL = sSQL + _T("$bin] on [code] = [From Bin Code]  where 	Left(CONVERT ( nchar , [Entry Date], 112),6) = '")+sSelectDate;
			sSQL = sSQL + _T("' group by [Source Document No_],[Pick No_],[Assigned User ID],[Item No_],[Zone Code],[From Bin Code] ) as TestTab group by [Assigned User ID],[Zone Code]order by Employee,id_zone");
			*/

			sSQL = _T("select [Assigned User ID] as Employee ,[Zone Code] as id_zone, count(*) as ConDay from (select [Assigned User ID], hd.[No_],[Line No_],ln.[Zone Code] from [")+sDatabase;
			sSQL = sSQL +_T("$Warehouse Zone Employee] join[")+sDatabase;
			sSQL = sSQL + _T("$Registered Whse_ Activity Hdr_] as hd on [User ID] =[Assigned User ID] join [")+sDatabase;
			sSQL = sSQL + _T("$Registered Whse_ Activity Line] as ln on ln.[No_] = hd.[No_] and [Action Type] = 1 where Left(CONVERT ( nchar , [Registering Date], 112),6) = '")+sSelectDate;
			sSQL = sSQL + _T("' and  [Type] = 2 group by [Assigned User ID],hd.[No_],[Line No_],ln.[Zone Code]) as Test group by [Assigned User ID],[Zone Code] order by [Assigned User ID],[Zone Code]");

				
			Excel::WorkbooksPtr ExcelBooks;
			Excel::_WorkbookPtr ExcelBook;
			Excel::_WorksheetPtr ExcelSheet;
			Excel::RangePtr range;

			appExcel.CreateInstance( _T("Excel.Application"));
			VARIANT bTRUE;
		    bTRUE.vt = 11;
			bTRUE.boolVal = TRUE;
			appExcel->Visible[0] = FALSE;
			ExcelBook= appExcel->Workbooks->Add();
			ExcelSheet = ExcelBook->Worksheets->Item[1];
			
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);

			int iRow;

			iRow = 1;

			CString sName;
			CString oldMan;
			int iCol;
			int iValue;
			iCol=2;
			CString sDat;

			sDat = _T("Сборщики");
			ExcelSheet->Cells->Item[1,1] = sDat.AllocSysString();
			sDat = _T("Зона1");
			ExcelSheet->Cells->Item[1,2] = sDat.AllocSysString();
			sDat = _T("Зона2");
			ExcelSheet->Cells->Item[1,3] = sDat.AllocSysString();
			sDat = _T("Зона3");
			ExcelSheet->Cells->Item[1,4] = sDat.AllocSysString();
			sDat = _T("Зона4");
			ExcelSheet->Cells->Item[1,5] = sDat.AllocSysString();
			sDat = _T("Зона5");
			ExcelSheet->Cells->Item[1,6] = sDat.AllocSysString();

			sDat = _T("Зона1нс");
			ExcelSheet->Cells->Item[1,7] = sDat.AllocSysString();
			sDat = _T("Зона2нс");
			ExcelSheet->Cells->Item[1,8] = sDat.AllocSysString();
			sDat = _T("Зона3нс");
			ExcelSheet->Cells->Item[1,9] = sDat.AllocSysString();
			sDat = _T("Зона4нс");
			ExcelSheet->Cells->Item[1,10] = sDat.AllocSysString();
			sDat = _T("Зона5нс");
			ExcelSheet->Cells->Item[1,11] = sDat.AllocSysString();

			sDat = _T("Неизвестная зона");
			ExcelSheet->Cells->Item[1,12] = sDat.AllocSysString();
			sDat = _T("Сумма строк");
			ExcelSheet->Cells->Item[1,13] = sDat.AllocSysString();
			sDat = _T("USD");
			ExcelSheet->Cells->Item[1,14] = sDat.AllocSysString();

			Excel::BordersPtr borders;
			sDat = _T("Ставки");
			ExcelSheet->Cells->Item[1,16] = sDat.AllocSysString();
			range = ExcelSheet->GetRange(ExcelSheet->Cells->Item[1,16],ExcelSheet->Cells->Item[2,27]);
			borders = range->GetBorders();
			borders->PutLineStyle(Excel::xlContinuous);
			borders->PutWeight(Excel::xlThin);
			borders->PutColorIndex(Excel::xlAutomatic);


//Ставки 1 Зона   2 Зона    3 Зона    4 Зона    5 Зона     Неизвестная зона
//       0.08775  0.053625  0.053625  0.053625  0			
//Ставки Зона1нс  Зона2нс   Зона3нс   Зона4нс   Зона5нс
//		 0.08775  0.053625  0.053625  0.053625  0.053625
			sDat = _T("1 Зона");
			ExcelSheet->Cells->Item[1,17] = sDat.AllocSysString();
			//sDat = _T("0.08775");
			sDat = sReadFromIni(_T("Rate"),_T("Z01"),_T("0"));
			ExcelSheet->Cells->Item[2,17] = sDat.AllocSysString();

			sDat = _T("2 Зона");
			ExcelSheet->Cells->Item[1,18] = sDat.AllocSysString();
			//sDat = _T("0.053625");
			sDat = sReadFromIni(_T("Rate"),_T("Z02"),_T("0"));
			ExcelSheet->Cells->Item[2,18] = sDat.AllocSysString();

			sDat = _T("3 Зона");
			ExcelSheet->Cells->Item[1,19] = sDat.AllocSysString();
			//sDat = _T("0.053625");
			sDat = sReadFromIni(_T("Rate"),_T("Z03"),_T("0"));
			ExcelSheet->Cells->Item[2,19] = sDat.AllocSysString();

			sDat = _T("4 Зона");
			ExcelSheet->Cells->Item[1,20] = sDat.AllocSysString();
			//sDat = _T("0.053625");
			sDat = sReadFromIni(_T("Rate"),_T("Z04"),_T("0"));
			ExcelSheet->Cells->Item[2,20] = sDat.AllocSysString();

			sDat = _T("5 Зона");
			ExcelSheet->Cells->Item[1,21] = sDat.AllocSysString();
			//sDat = _T("0");
			sDat = sReadFromIni(_T("Rate"),_T("PAL"),_T("0"));
			ExcelSheet->Cells->Item[2,21] = sDat.AllocSysString();

			sDat = _T("1нс Зона");
			ExcelSheet->Cells->Item[1,22] = sDat.AllocSysString();
			//sDat = _T("0.08775");
			sDat = sReadFromIni(_T("Rate"),_T("MZ01"),_T("0"));
			ExcelSheet->Cells->Item[2,22] = sDat.AllocSysString();

			sDat = _T("2нс Зона");
			ExcelSheet->Cells->Item[1,23] = sDat.AllocSysString();
			//sDat = _T("0.053625");
			sDat = sReadFromIni(_T("Rate"),_T("MZ02"),_T("0"));
			ExcelSheet->Cells->Item[2,23] = sDat.AllocSysString();

			sDat = _T("3нс Зона");
			ExcelSheet->Cells->Item[1,24] = sDat.AllocSysString();
			//sDat = _T("0.053625");
			sDat = sReadFromIni(_T("Rate"),_T("MZ03"),_T("0"));
			ExcelSheet->Cells->Item[2,24] = sDat.AllocSysString();

			sDat = _T("4нс Зона");
			ExcelSheet->Cells->Item[1,25] = sDat.AllocSysString();
			//sDat = _T("0.053625");
			sDat = sReadFromIni(_T("Rate"),_T("MZ04"),_T("0"));
			ExcelSheet->Cells->Item[2,25] = sDat.AllocSysString();

			sDat = _T("5нс Зона");
			ExcelSheet->Cells->Item[1,26] = sDat.AllocSysString();
			//sDat = _T("0.053625");
			sDat = sReadFromIni(_T("Rate"),_T("MZ05"),_T("0"));
			ExcelSheet->Cells->Item[2,26] = sDat.AllocSysString();

			sDat = _T("Неизвестная зона");
			ExcelSheet->Cells->Item[1,27] = sDat.AllocSysString();
			//sDat = _T("0.053625");
			sDat = sReadFromIni(_T("Rate"),_T("UNKNOWN"),_T("0"));
			ExcelSheet->Cells->Item[2,27] = sDat.AllocSysString();


			COleDateTime cDate,datEnd;
			_variant_t oVal;
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
				
				//id_zone
				Query.GetFieldValue(_T("id_zone"),oValue);
				sName = GetValue(&oValue);
				iCol = -1;
				if(sName == _T("Z01"))
				{
					iCol = 2;
				}

				if(sName == _T("Z02"))
				{
					iCol = 3;
				}

				if(sName == _T("Z03"))
				{
					iCol = 4;
				}

				if(sName == _T("Z04"))
				{
					iCol = 5;
				}

				if(sName == _T("PAL"))
				{
					iCol = 6;
				}
				
				if(sName == _T("MZ01"))
				{
					iCol = 7;
				}

				if(sName == _T("MZ02"))
				{
					iCol = 8;
				}

				if(sName == _T("MZ03"))
				{
					iCol = 9;
				}

				if(sName == _T("MZ04"))
				{
					iCol = 10;
				}

				if(sName == _T("MZ05"))
				{
					iCol = 11;
				}

				if(iCol < 0)
				{
					iCol = 12;
				}
				

				Query.GetFieldValue(_T("ConDay"),oValue);
				iValue = GetValueID(&oValue);

				//ExcelSheet->Cells->Item[iRow,iCol] = sName.AllocSysString();
				
				range = ExcelSheet->Cells->Item[iRow,iCol];
				
				oVal = range->GetValue2();
				if(oVal.vt != 0)
				{
					oVal.ChangeType(VT_I8);
					iValue = iValue+oVal.lVal; 				
				}
				sName.Format(_T("%d"),iValue);
				ExcelSheet->Cells->Item[iRow,iCol] = sName.AllocSysString();
				range = ExcelSheet->Cells->Item[iRow, 13];
				range->PutFormula(_T("=SUM(RC[-11]:RC[-1])"));


				sName.Format(_T("=RC[-12]*R[-%d]C17 + RC[-11]*R[-%d]C18 + RC[-10]*R[-%d]C19 + RC[-9]*R[-%d]C20 + RC[-8]*R[-%d]C21 + RC[-7]*R[-%d]C22 + RC[-6]*R[-%d]C23 + RC[-5]*R[-%d]C24 + RC[-4]*R[-%d]C25 + RC[-3]*R[-%d]C26 + RC[-2]*R[-%d]C27"),iRow-2,iRow-2,iRow-2,iRow-2,iRow-2,iRow-2,iRow-2,iRow-2,iRow-2,iRow-2,iRow-2);
				/*
				=RC[-6]*R[-2]C12+RC[-5]*R[-2]C13+RC[-4]*R[-2]C14
				*/
				range = ExcelSheet->Cells->Item[iRow, 14];
				range->PutFormula(sName.AllocSysString());
				Query.MoveNext();
			}
			Query.Close();
			//=СУММ(R[-169]C:R[-1]C)
			if(iRow > 1)
			{
				iRow++;
				sName.Format(_T("Итого:"));
				ExcelSheet->Cells->Item[iRow, 1] = sName.AllocSysString();
				
				sName.Format(_T("=SUM(R[-%d]C:R[-1]C)"),iRow-2);
				range = ExcelSheet->Cells->Item[iRow,2];
				range->PutFormula(sName.AllocSysString());
				range = ExcelSheet->Cells->Item[iRow,3];
				range->PutFormula(sName.AllocSysString());
				range = ExcelSheet->Cells->Item[iRow,4];
				range->PutFormula(sName.AllocSysString());
				range = ExcelSheet->Cells->Item[iRow,5];
				range->PutFormula(sName.AllocSysString());
				range = ExcelSheet->Cells->Item[iRow,6];
				range->PutFormula(sName.AllocSysString());
				range = ExcelSheet->Cells->Item[iRow,7];
				range->PutFormula(sName.AllocSysString());
				range = ExcelSheet->Cells->Item[iRow,8];
				range->PutFormula(sName.AllocSysString());
				range = ExcelSheet->Cells->Item[iRow,9];
				range->PutFormula(sName.AllocSysString());
				range = ExcelSheet->Cells->Item[iRow,10];
				range->PutFormula(sName.AllocSysString());
				range = ExcelSheet->Cells->Item[iRow,11];
				range->PutFormula(sName.AllocSysString());
				range = ExcelSheet->Cells->Item[iRow,12];
				range->PutFormula(sName.AllocSysString());
				range = ExcelSheet->Cells->Item[iRow,13];
				range->PutFormula(sName.AllocSysString());
				range = ExcelSheet->Cells->Item[iRow,14];
				range->PutFormula(sName.AllocSysString());


				range = ExcelSheet->GetRange(ExcelSheet->Cells->Item[1, 1], ExcelSheet->Cells->Item[iRow, 14]);
				//range->PutFormula(sName.AllocSysString());
				borders = range->GetBorders();
				borders->PutLineStyle(Excel::xlContinuous);
				borders->PutWeight(Excel::xlThin);
				borders->PutColorIndex(Excel::xlAutomatic);

				range = ExcelSheet->GetRange(ExcelSheet->Cells->Item[2, 14], ExcelSheet->Cells->Item[iRow, 14]);
				range->Interior->Color = RGB(200, 160, 35);


			}
			appExcel->Visible[0] = TRUE;

		}
		catch(CDBException *exsept)
		{
			AfxMessageBox(exsept->m_strError);
			exsept->Delete();
			return ;
		}

	OnOK();
}
