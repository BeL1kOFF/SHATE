// Nav_Scaner_Server.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "Nav_Scaner_Server.h"
#include "..\Modul\Service.h"
#include "..\Modul\ServerSocket.h"
#include "..\Modul\IniReader.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// The one and only application object

CWinApp theApp;

using namespace std;
CService m_Service(_T("Nav_scaner_service"));

CStringW GetWinUserName()
{
	wchar_t buffer[257];		// буфер
	DWORD size;			// размер
	size=sizeof(buffer);		// размер буфера
	if (GetUserName(buffer,&size)==0)
		throw "Error GetWinUserName";	// при ошибке функция вернет 0
	return buffer;
}

CDatabase* OpenDatabase(CDatabase* dClientBase)
{
	if(dClientBase == NULL)
	{
		WriteToLog(_T("NULL база"));	
		return NULL;
	}

	try
	{
		if(dClientBase!=NULL)
		{
			if(dClientBase->IsOpen())
				dClientBase->Close();
		}
	}
	catch(CDBException *exsept)
	{
		WriteToLog(exsept->m_strError);	
		exsept->Delete();
		return dClientBase;
	}

	CIniReader iniReader;
	CString sConnect;

	CString sServer, sDatabase;
	sServer = iniReader.ReadFromIni(_T("DB"),_T("SERVER"),_T("svbyminssq3"));
	sDatabase = iniReader.ReadFromIni(_T("DB"),_T("DATABASE"),_T("SHATE-M-8"));
	
	try
	{

		
		sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
		
	#ifdef _DEBUG
		sConnect.Format(_T("DSN=Spbypril0777;UID=Admin2;PWD=Admin2;"));			
	#endif
		

			
		
		dClientBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
		//sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
		//dClientBase->ExecuteSQL(sConnect);
		dClientBase->SetQueryTimeout(0);
		
		
	}
	catch(CDBException *exsept)
	{
		WriteToLog(sConnect);	
		WriteToLog(exsept->m_strError);	
		exsept->Delete();
	}
	return dClientBase;
}

int GetTaskPosToTest(CDatabase *dClientBase, CStringA* saValue, SOCKET* sok)
{
	int lUser;
	lUser = 0;
	CString sValue,sUserNav,sDoc,sZone,sCell;
	CServerSocet socet;
	*saValue = saValue->Right(saValue->GetLength()-5);
	*saValue = saValue->Left(saValue->GetLength()-5);
	sValue = socet.Translate(*saValue);
	sValue = sValue + _T("_______");
	//sUserNav,sDoc,sZone,sCell);

	int iFind;
	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sUserNav = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	
	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sDoc = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	

	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sZone = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	

	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sCell = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	if((sUserNav.GetLength()<1)
		||(sDoc.GetLength()<1)
		||(sZone.GetLength()<1)
		||(sCell.GetLength()<1))
	{
		CStringA sValue;
		sValue.Format("GPTI_%s_GPTI",socet.Translate(_T("Ошибка при передаче полей!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	if(!dClientBase->IsOpen())
	{
		
		CStringA sValue;
		sValue.Format("GPTI_%s_GPTI",socet.Translate(_T("Не подключились к БД!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return -1;
	}

	CString sSQL;
	try
	{
		CString sNewUser;
		CRecordset Query(dClientBase);
		sUserNav.Replace(_T("'"),_T("''"));
		sSQL.Format(_T("select [No_],[No_ 2], [Manufacturer Code],[Quantity in Individual Package],[Description], coalesce(line.[Line_ID],-1) as [Line_ID],coalesce(line.[Count],0) as Qnt, coalesce(Barcode,Items.No_) from [Inventary Doc Tasc] as tasc join [Inventary Doc Line] as line on line.DOC_ID = tasc.ID_DOC and line.ID_ZONE = tasc.ID_ZONE and line.Cell = tasc.Cell join [Items] on line.Item = Items.No_ left join [Barcodes] as bc on bc.Item = Items.No_ where tasc.ID_DOC = %s and tasc.ID_ZONE = '%s' and tasc.CELL = '%s' and tasc.[state] =2"),sDoc,sZone,sCell);
		CDBVariant dbValue;
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		if(Query.IsEOF())
		{
			Query.Close();
			CStringA sValue;
			sValue.Format("GPTI_%s_GPTI",socet.Translate(_T("-1"))); 
			send(*sok,sValue,sValue.GetLength()+1,0);
			sSQL.Format(_T("update [Inventary Doc Tasc] set [state] = 3 where id_doc = %s and [id_zone] = '%s' and [cell] = '%s' and ([state] = 0 or [state] is null)"),sDoc,sZone,sCell);
			dClientBase->ExecuteSQL(sSQL);
		}
		else
		{
			sValue = "";
			int i;
			i=0;
			CStringA sValue;
			CStringW sWValue;
			sWValue = "";
			while(!Query.IsEOF())
			{
				for(i=0;i<Query.GetODBCFieldCount();i++)
				{
					Query.GetFieldValue(i,dbValue);
					sWValue = sWValue+ ReplaceLeftSymbols(GetValue(&dbValue),2)+_T("|");
				}
				Query.MoveNext();
			}
			Query.Close();
			
			lUser = 1;
			
			
			sValue.Format("GPTI_%s_GPTI",socet.Translate(sWValue)); 
			WriteToLog(sWValue);
			send(*sok,sValue,sValue.GetLength()+1,0);
		}
	}
	catch(CDBException *exsept)
	{
		WriteToLog(exsept->m_strError+sSQL);
		CStringA sValue;
		sSQL = exsept->m_strError + sSQL;
		sSQL.Replace(_T("_"),_T(" "));
		sValue.Format("GPTI_%s_GPTI",sSQL); 
		exsept->Delete();
		
		send(*sok,sValue,sValue.GetLength()+1,0);
	}

	return lUser;
}

int GetTaskToTest(CDatabase *dClientBase, CStringA* saValue, SOCKET* sok)
{
	int lUser;
	lUser = 0;
	CString sValue,sUserNav,sDoc,sZone,sDecSort;
	CServerSocet socet;
	*saValue = saValue->Right(saValue->GetLength()-5);
	*saValue = saValue->Left(saValue->GetLength()-5);
	sValue = socet.Translate(*saValue);
	sValue = sValue + _T("_______");
	//WriteToLog(sValue);
	//sUserNav,sDoc,sZone,sCell);

	int iFind;
	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sUserNav = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	
	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sDoc = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	

	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sZone = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	

	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sDecSort = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	if((sUserNav.GetLength()<1)
		||(sDoc.GetLength()<1)
		||(sZone.GetLength()<1)
		||(sDecSort.GetLength()!=1))
	{
		CStringA sValue;
		sValue.Format("GTTI_%s_GTTI",socet.Translate(_T("Ошибка при передаче полей!"))); 
		//WriteToLog(_T("Ошибка при передаче полей!"));
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	if(!dClientBase->IsOpen())
	{
		
		CStringA sValue;
		sValue.Format("GTTI_%s_GTTI",socet.Translate(_T("Не подключились к БД!"))); 
		//WriteToLog(_T("Не подключились к БД!"));
		send(*sok,sValue,sValue.GetLength()+1,0);
		return -1;
	}

	CString sSQL;
	try
	{
		CString sCell, sNewUser;
		CRecordset Query(dClientBase);
		sUserNav.Replace(_T("'"),_T("''"));
		if(sDecSort == _T("1"))
			sSQL.Format(_T("select top 1 [CELL],[ID_USER],[COL],[STATE] from [Inventary Doc Tasc] where [ID_ZONE] = '%s' and (ID_USER = '' or ID_USER is null or ID_USER = '%s') and ([state] < 3 or [state] is null) and [ID_DOC] = %s order by ID_USER DESC, CELL DESC"),sZone,sUserNav,sDoc);
		else
			sSQL.Format(_T("select top 1 [CELL],[ID_USER],[COL],[STATE] from [Inventary Doc Tasc] where [ID_ZONE] = '%s' and (ID_USER = '' or ID_USER is null or ID_USER = '%s') and ([state] < 3 or [state] is null) and [ID_DOC] = %s order by ID_USER DESC, CELL"),sZone,sUserNav,sDoc);
		int iField;
		WriteToLog(sSQL);
		CDBVariant dbValue;
		CString sCol;
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		if(Query.IsEOF())
		{
			Query.Close();
			CStringA sValue;
			sValue.Format("GTTI_%s_GTTI",socet.Translate(_T("-1_")));  
			send(*sok,sValue,sValue.GetLength()+1,0);
		}
		else
		{
			iField = 0;
			Query.GetFieldValue(iField,dbValue);
			sCell = GetValue(&dbValue);

			iField = 1;
			Query.GetFieldValue(iField,dbValue);
			sNewUser = GetValue(&dbValue);
			//sCol
			iField = 2;
			Query.GetFieldValue(iField,dbValue);
			sCol = GetValue(&dbValue);

			iField = 3;
			Query.GetFieldValue(iField,dbValue);
			Query.Close();

			if(sNewUser.GetLength()>0)
			{
				
				sSQL.Format(_T("update [Inventary Doc Tasc] set [state] = 1 where id_doc = %s and [id_zone] = '%s' and [cell] = '%s' and ([state] = 0 or [state] is null)"),sDoc,sZone,sCell);
				dClientBase->ExecuteSQL(sSQL);
				CStringA sValue;
				sValue.Format("GTTI_%s_GTTI",socet.Translate(GetValue(&dbValue)+_T("_")+sCell)); 
				send(*sok,sValue,sValue.GetLength()+1,0);
			}
			else
			{
				if(sCol.GetLength()>0)
				{
					sSQL.Format(_T("update [Inventary Doc Tasc] set [ID_USER] = '%s' where id_doc = %s and [id_zone] = '%s' and [COL] = '%s'  and ([ID_USER] is NULL or [ID_USER] = '')"),sUserNav,sDoc,sZone,sCol);	
					dClientBase->ExecuteSQL(sSQL);
				}
				else
				{
					sSQL.Format(_T("update [Inventary Doc Tasc] set [ID_USER] = '%s' where id_doc = %s and [id_zone] = '%s' and [cell] = '%s'  and ([ID_USER] is NULL or [ID_USER] = '')"),sUserNav,sDoc,sZone,sCell);	
					dClientBase->ExecuteSQL(sSQL);
				}

				sSQL.Format(_T("select top 1 [STATE] from [Inventary Doc Tasc]  where [ID_USER] = '%s' and id_doc = %s and [id_zone] = '%s' and [cell] = '%s'"),sUserNav,sDoc,sZone,sCell);	
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				if(Query.IsEOF())
				{
					Query.Close();
					CStringA sValue;
					sValue.Format("GTTI_0_1_GTTI"); 
					//WriteToLog(_T("GTTI_0_1_GTTI"));
					send(*sok,sValue,sValue.GetLength()+1,0);
				}
				else
				{
					iField = 0;
					Query.GetFieldValue(iField,dbValue);
					Query.Close();
					CStringA sValue;
					sValue.Format("GTTI_%s_GTTI",socet.Translate(GetValue(&dbValue)+_T("_")+sCell)); 
					send(*sok,sValue,sValue.GetLength()+1,0);
					sSQL.Format(_T("update [Inventary Doc Tasc] set [state] = 1 where id_doc = %s and [id_zone] = '%s' and [cell] = '%s'"),sDoc,sZone,sCell);
					//WriteToLog(sSQL);
					dClientBase->ExecuteSQL(sSQL);
				}
				
			}
			
		}
	}
	catch(CDBException *exsept)
	{
		WriteToLog(exsept->m_strError+sSQL);
		CStringA sValue;
		sSQL = exsept->m_strError + sSQL;
		sSQL.Replace(_T("_"),_T(" "));
		sValue.Format("GTTI_%s_GTTI",sSQL); 
		exsept->Delete();
		
		send(*sok,sValue,sValue.GetLength()+1,0);
	}

	return 0;
}
//WriteToLogTable2
int GetDataByCode(CDatabase *dClientBase, CStringA* saValue, SOCKET* sok)
{
	//GIBD
	//GetDataByCode(saValue);
	//WriteToLog(_T("GetDataByCode"));
	bool bStart;
	bStart = FALSE;
	CDBVariant dbValue;
	CIniReader iniReader;
	CString sValue;
	long lUser;
	lUser = 0;
	CServerSocet socet;
	
	CString sType,sCode;

	*saValue = saValue->Right(saValue->GetLength()-5);
	*saValue = saValue->Left(saValue->GetLength()-5);
	sValue = socet.Translate(*saValue);
	sValue = sValue + _T("_");
	

	int iFind;
	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sType = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	else
	{
		CStringA sValue;
		sValue.Format("GIBD_%s_GIBD",socet.Translate(_T("Ошибка полей!"))); 

		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sCode = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	else
	{
		CStringA sValue;
		sValue.Format("GIBD_%s_GIBD",socet.Translate(_T("Ошибка полей!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	CString sSQL;
	


	CDatabase * dBase;
	dBase = new(CDatabase);
	CString sFirm,sServer,sDatabase;
	sFirm = iniReader.ReadFromIni(_T("NAV"),_T("FIRM"),_T("Shate-M"));
	sServer = iniReader.ReadFromIni(_T("NAV"),_T("SERVER"),_T("svbyminssq3"));
	sDatabase = iniReader.ReadFromIni(_T("NAV"),_T("DATABASE"),_T("SHATE-M-8"));
	CString GetDefLocation = iniReader.ReadFromIni(_T("NAV"),_T("DEF_LOCATION"),_T("SHATE-S01"));
	try
	{
		sSQL.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
		
		#ifdef _DEBUG
			sSQL.Format(_T("DSN=svbyprisa0018;UID=RomanK;PWD=bskQWErty432;"));		
		#endif
		
		dBase->OpenEx(sSQL,CDatabase::noOdbcDialog);
		sSQL.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
		dBase->ExecuteSQL(sSQL);
		dBase->SetQueryTimeout(0);
		dBase->SetQueryTimeout(0);
	}
	catch(CDBException *exsept)
	{
		CStringA sValue;
		sValue.Format("GIBD_%s_GIBD",socet.Translate(exsept->m_strError+sSQL)); 
		WriteToLog(exsept->m_strError+sSQL);
		exsept->Delete();
		if(dBase->IsOpen())
			dBase->Close();
		delete(dBase);
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}
	sCode.Replace(_T("'"),_T(""));

	if(sType == _T("1"))
		sSQL.Format(_T("select [No_ 2],it.[Manufacturer Code],[Bin Code] from [Shate-M$Item] as it left join [Shate-M$Bin Content] on [Item No_] = [No_]   where [No_ 2] = '%s' and [Location Code] = 'SHATE-S01' order by [No_]"),sCode,GetDefLocation);
	else
		sSQL.Format(_T("select [No_ 2],it.[Manufacturer Code],[Bin Code] from [Shate-M$Item] as it left join [Shate-M$Bin Content] on [Item No_] = [No_]   where [No_] = '%s' and [Location Code] = 'SHATE-S01' order by [No_]"),sCode,GetDefLocation);
	
	try
	{
		CString sRet;
		CRecordset Query(dBase);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		while(!Query.IsEOF())
		{
			for(int iField=0;iField<3;iField++)
			{
				Query.GetFieldValue(iField,dbValue);
				sRet = sRet +GetValue(&dbValue)+_T("|");
			}
			Query.MoveNext();
		}
		Query.Close();
		CStringA saValue;
		saValue.Format("GIBD_%s_GIBD",socet.Translate(sRet)); 
		send(*sok,saValue,saValue.GetLength()+1,0);
	}
	catch(CDBException *exsept)
	{
		CStringA sValue;
		sValue.Format("GIBD_%s_GIBD",socet.Translate(exsept->m_strError+sSQL)); 
		exsept->Delete();
		if(dBase->IsOpen())
			dBase->Close();
		delete(dBase);
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}


	if(dBase->IsOpen())
			dBase->Close();
		delete(dBase);
	return lUser;
}

int WriteToLogTable2(CDatabase *dClientBase, CStringA* saValue, SOCKET* sok)
{
	bool bStart;
	bStart = FALSE;
	CDBVariant dbValue;
	CIniReader iniReader;
	CString sValue;
	long lUser;
	lUser = 0;
	CServerSocet socet;
	
	CString sUser,sDoc,sCell,sDetNo_,sCount, sRandom;

	*saValue = saValue->Right(saValue->GetLength()-5);
	*saValue = saValue->Left(saValue->GetLength()-5);
	sValue = socet.Translate(*saValue);
	//sValue = sValue + _T("_");


	int iFind;
	iFind = sValue.Find(_T("_"),0);
	CStringArray sa;
	sa.RemoveAll();
	while(iFind>-1)
	{
		sa.Add(sValue.Left(iFind));
		sValue = sValue.Right(sValue.GetLength()-1-iFind);
		iFind = sValue.Find(_T("_"),0);
	}

	int iColumnCount;
	iColumnCount = 7;
	if(sa.GetCount() % iColumnCount !=0)
	{
		CStringA sValue;
		sValue.Format("WPDI_%s_WPDI",socet.Translate(_T("Ошибка передачи полей!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	

	CString sName, sPassword;
	sName = sValue;
	if(!dClientBase->IsOpen())
	{
		
		CStringA sValue;
		sValue.Format("WPDI_%s_WPDI",socet.Translate(_T("Не подключились к БД!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	CString sSQL;
	try
	{
		bStart = TRUE;
		/*
		0 - sUserNav
		1 - sDoc
		2 - sCell
		3 - Item No_
		4 - TestCount
		5 - iRandom
		6 - iLine
		*/
		CString sSQL;
		CStringArray saSQL;
		saSQL.RemoveAll();
		sSQL.Format(_T("UPDATE [Inventary Doc Tasc] set [STATE] = 3 WHERE [ID_DOC] = %s and [CELL] = '%s'"),sa.ElementAt(1),sa.ElementAt(2));
		saSQL.Add(sSQL);	
		while(sa.GetCount()>0)
		{
			sSQL.Format(_T("UPDATE [Inventary Doc Line]  SET [Test_Count] = %s WHERE [Doc_ID] = %s and [Line_ID] = %s"),
				sa.ElementAt(4),sa.ElementAt(1),sa.ElementAt(6));
			saSQL.Add(sSQL);

			sSQL.Format(_T("INSERT INTO [Inventary Log] ([Doc_id],[Line_id],[Test_id],[Item],[Cell],[Count],[User],[Date],[Type]) VALUES (%s ,%s,(select coalesce(MAX(Test_id),0)+1 from [Inventary Log] where [Doc_id] = %s and [Line_id] = %s),%s,'%s',%s,'%s','%s',0)"),
				sa.ElementAt(1),sa.ElementAt(6),sa.ElementAt(1),sa.ElementAt(6),sa.ElementAt(3),sa.ElementAt(2),sa.ElementAt(4),sa.ElementAt(0),sa.ElementAt(5));
			saSQL.Add(sSQL);
			sa.RemoveAt(0,iColumnCount);
		}
		
		//UPDATE [Inventary Doc Tasc] set [STATE] = 3 WHERE [ID_DOC] = %s and [CELL] = '%s'
		dClientBase->BeginTrans();

		while(saSQL.GetCount()>0)
		{
			sSQL= saSQL.ElementAt(0);
			dClientBase->ExecuteSQL(sSQL);
			saSQL.RemoveAt(0,1);
		}
			
			
		dClientBase->CommitTrans();
		lUser = 1;
		CStringA sValue;
		sValue.Format("WPDI_OK_WPDI"); 
		send(*sok,sValue,sValue.GetLength()+1,0);
	}
	catch(CDBException *exsept)
	{
		if(bStart)
		{
			dClientBase->Rollback();
		}
		CStringA sValue;
		sValue.Format("WPDI_%s_WPDI",socet.Translate(exsept->m_strError+sSQL)); 
		exsept->Delete();
		send(*sok,sValue,sValue.GetLength()+1,0);
	}
	return lUser;
}

int WriteToLogTable(CDatabase *dClientBase, CStringA* saValue, SOCKET* sok)
{
	bool bStart;
	bStart = FALSE;
	CDBVariant dbValue;
	CIniReader iniReader;
	CString sValue;
	long lUser;
	lUser = 0;
	CServerSocet socet;
	
	CString sUser,sDoc,sCell,sDetNo_,sCount, sRandom;

	*saValue = saValue->Right(saValue->GetLength()-5);
	*saValue = saValue->Left(saValue->GetLength()-5);
	sValue = socet.Translate(*saValue);
	sValue = sValue + _T("_");


	int iFind;
	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sUser = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	else
	{
		CStringA sValue;
		sValue.Format("WTLI_%s_WTLI",socet.Translate(_T("Ошибка полей!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sDoc = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	else
	{
		CStringA sValue;
		sValue.Format("WTLI_%s_WTLI",socet.Translate(_T("Ошибка полей!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sCell = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	else
	{
		CStringA sValue;
		sValue.Format("WTLI_%s_WTLI",socet.Translate(_T("Ошибка полей!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sDetNo_ = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	else
	{
		CStringA sValue;
		sValue.Format("WTLI_%s_WTLI",socet.Translate(_T("Ошибка полей!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}


	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sCount = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	else
	{
		CStringA sValue;
		sValue.Format("WTLI_%s_WTLI",socet.Translate(_T("Ошибка полей!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}
	
	//sRandom
	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sRandom = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	else
	{
		CStringA sValue;
		sValue.Format("WTLI_%s_WTLI",socet.Translate(_T("Ошибка полей!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}
	CString sLine;
	int iLine;
	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sLine = sValue.Left(iFind);
		iLine = _wtoi(sLine);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	else
	{

		CStringA sValue;
		sValue.Format("WTLI_%s_WTLI",socet.Translate(_T("Ошибка полей!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	

	CString sName, sPassword;
	sName = sValue;
	if(!dClientBase->IsOpen())
	{
		
		CStringA sValue;
		sValue.Format("WTLI_%s_WTLI",socet.Translate(_T("Не подключились к БД!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	CString sSQL;
	try
	{
		CRecordset Query(dClientBase);
		
		sName.Replace(_T("'"),_T(""));
		int iField;
		iField = 0;
		if(iLine < 0)
		{
			CString sCellBase;
			if(sCell.Left(4)==_T("CELL"))
			{
				sCellBase = _T("none");
			}

			sSQL.Format(_T("select top 1 [Line_ID] from [Inventary Doc Line] where [Doc_ID] = %s and [Item] = '%s' and Cell = '%s'"),sDoc,sDetNo_,sCell);
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			if(!Query.IsEOF())
			{
				Query.GetFieldValue(iField,dbValue);
				iLine = _wtoi(GetValue(&dbValue));
			}
			Query.Close();
			
			if(iLine  < 0)
			{
				sSQL.Format(_T("select coalesce(MAX(Line_ID),0)+1 from [Inventary Doc Line] where Doc_ID = %s"),sDoc);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				if(!Query.IsEOF())
				{
					Query.GetFieldValue(iField,dbValue);
					iLine = _wtoi(GetValue(&dbValue));
				}
				Query.Close();
				sSQL.Format(_T("INSERT INTO [Inventary Doc Line] ([Doc_ID],[Line_ID],[Item],[Cell],[Count],[Test_Count]) VALUES (%s,%d,'%s','%s',0,0)"),sDoc,iLine,sDetNo_,sCell,sCount);
				dClientBase->ExecuteSQL(sSQL);
			}	
		
			if(iLine  < 0)
			{
				CStringA sValue;
				sValue.Format("WTLI_%s_WTLI",_T("Ошибка в БД")); 
				send(*sok,sValue,sValue.GetLength()+1,0);
				return -1;
			}
		}

		sSQL.Format(_T("select top 1 [Count],[Test_id] from [Inventary Log] where [User] = '%s' and [Doc_ID] = '%s' and [Line_id] = %d and [Cell] = '%s' and [Item] = '%s' and [Date] = '%s'"),sUser,sDoc,iLine,sCell,sDetNo_,sRandom);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		if(Query.IsEOF())
		{
			Query.Close();

			bStart = TRUE;
			dClientBase->BeginTrans();
			sSQL.Format(_T("INSERT INTO [Inventary Log] ([Doc_id],[Line_id],[Test_id],[Item],[Cell],[Count],[User],[Date],[Type]) VALUES (%s ,%d,(select coalesce(MAX(Test_id),0)+1 from [Inventary Log] where [Doc_id] = %s and [Line_id] = %d),%s,'%s',%s,'%s','%s',0)"),sDoc,iLine,sDoc,iLine,sDetNo_,sCell,sCount,sUser,sRandom);
			dClientBase->ExecuteSQL(sSQL);
			sSQL.Format(_T("update [Inventary Doc Line] set [Test_Count] = [Test_Count] + %s where Doc_id = %s and Line_id = %d"),sCount,sDoc,iLine);
			dClientBase->ExecuteSQL(sSQL);
			dClientBase->CommitTrans();
		}
		else
		{
			CString sOldCount,sTest;
			Query.GetFieldValue(iField,dbValue);
			sOldCount = GetValue(&dbValue);
			iField++;
			Query.GetFieldValue(iField,dbValue);
			sTest = GetValue(&dbValue);

			Query.Close();

			bStart = TRUE;
			dClientBase->BeginTrans();
			sSQL.Format(_T("update [Inventary Log] set [Count] = [Count] + %s - %s where Doc_id = %s and Line_id = %d and Test_id = %s"),sCount,sOldCount,sDoc,iLine,sTest);
			dClientBase->ExecuteSQL(sSQL);

			sSQL.Format(_T("update [Inventary Doc Line] set [Test_Count] = [Test_Count] + %s - %s where Doc_id = %s and Line_id = %d"),sCount,sOldCount,sDoc,iLine);
			dClientBase->ExecuteSQL(sSQL);
			
			dClientBase->CommitTrans();
			
		}
		


		
		lUser = 1;
		CStringA sValue;
		sValue.Format("WTLI_0_WTLI"); 
		send(*sok,sValue,sValue.GetLength()+1,0);
	}
	catch(CDBException *exsept)
	{
		if(bStart)
		{
			dClientBase->Rollback();
		}
		CStringA sValue;
		sValue.Format("WTLI_%s_WTLI",socet.Translate(exsept->m_strError+sSQL)); 
		exsept->Delete();
		send(*sok,sValue,sValue.GetLength()+1,0);
	}
	return lUser;
}


int LoadItemDataByBarcode(CDatabase *dClientBase, CStringA* saValue, SOCKET* sok)
{
	CDBVariant dbValue;
	CIniReader iniReader;
	CString sValue;
	long lUser;
	lUser = 0;
	CServerSocet socet;
	lUser = 0;
	
	*saValue = saValue->Right(saValue->GetLength()-5);
	*saValue = saValue->Left(saValue->GetLength()-5);
	sValue = socet.Translate(*saValue);
	
	CString sFindType;
	int iFind;
	lUser = sValue.Find(_T("_"),0);
	sFindType = _T("0");

	CString sName, sDoc;
	sName = "";
	sDoc = "";

	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sName = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}
	
	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sFindType = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}

	iFind = sValue.Find(_T("_"),0);
	if(iFind > 0)
	{
		sDoc = sValue.Left(iFind);
		sValue = sValue.Right(sValue.GetLength() - iFind - 1);
	}


	if(!dClientBase->IsOpen())
	{
		
		CStringA sValue;
		sValue.Format("GIBB_%s_GIBB",socet.Translate(_T("Не подключились к БД!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	try
	{
		CRecordset Query(dClientBase);
		CString sSQL;
		sName.Replace(_T("'"),_T(""));
		//sSQL.Format(_T("select [No_],[No_ 2], [Manufacturer Code],[Quantity in Individual Package],[Description] from [%s$Item] where [No_] = '%s'"),sFirm,sName);
		if(sFindType == _T("1"))
		{
			sSQL.Format(_T("select [No_],[No_ 2], [Manufacturer Code],[Quantity in Individual Package],[Description], coalesce(idl.[Line_ID],-1),coalesce(idl.[Count],0) from [Items] left join [Inventary Doc Line] as idl on [Item] = [No_] and [Doc_ID] = %s where [No_ 2] = '%s'"),sDoc,sName);
		}
		else
		{
			sSQL.Format(_T("select [No_],[No_ 2], [Manufacturer Code],[Quantity in Individual Package],[Description],coalesce(idl.[Line_ID],-1),coalesce(idl.[Count],0) from [Barcodes] join [Items] on [Item] = [No_] left join [Inventary Doc Line] as idl on idl.[Item] = [No_] and [Doc_ID] = %s where [Barcode] = '%s'"),sDoc,sName);
		}

		//
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		if(Query.IsEOF())
		{
			Query.Close();
			CStringA sValue;
			sValue.Format("GIBB_%s_GIBB",socet.Translate(_T("Штрихкод не опознан!"))); 
			send(*sok,sValue,sValue.GetLength()+1,0);
		}
		else
		{
			sValue = "";
			int i;
			i=0;
			CStringA sValue;
			CStringW sWValue;

			while(!Query.IsEOF())
			{
				for(i=0;i<7;i++)
				{
					Query.GetFieldValue(i,dbValue);
					sWValue = sWValue+ ReplaceLeftSymbols(GetValue(&dbValue),2)+_T("|");
				}
				//sWValue = sWValue +_T("\n");
				Query.MoveNext();
			}
			Query.Close();
			
			lUser = 1;
			
			
			sValue.Format("GIBB_%s_GIBB",socet.Translate(sWValue)); 
			send(*sok,sValue,sValue.GetLength()+1,0);
		}
		
	}
	catch(CDBException *exsept)
	{
		exsept->Delete();
	}
	return lUser;
}

int LoadDocZoneList(CDatabase *dClientBase, CStringA* saValue, SOCKET* sok)
{
	CDBVariant dbValue;
	CIniReader iniReader;
	CString sValue;
	long lUser;
	lUser = 0;
	CServerSocet socet;
	
	*saValue = saValue->Right(saValue->GetLength()-5);
	*saValue = saValue->Left(saValue->GetLength()-5);
	sValue = socet.Translate(*saValue);
	
	CString sName, sPassword;
	sName = sValue;
	if(!dClientBase->IsOpen())
	{
		
		CStringA sValue;
		sValue.Format("LDZL_%s_LDZL",socet.Translate(_T("Не подключились к БД!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	try
	{
		CRecordset Query(dClientBase);
		CString sSQL;
		sName.Replace(_T("'"),_T(""));
		
		sSQL.Format(_T("SELECT DISTINCT [ID_ZONE] FROM [Inventary Doc Tasc] WHERE [ID_DOC] = %s"),sName);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		if(Query.IsEOF())
		{
			Query.Close();
			CStringA sValue;
			sValue.Format("LDZL_%s_LDZL",socet.Translate(_T("Не найдено зон склада!"))); 
			send(*sok,sValue,sValue.GetLength()+1,0);
		}
		else
		{
			sValue = "";
			int i;
			i=0;
			CStringA sValue;
			CStringW sWValue;

			while(!Query.IsEOF())
			{
				Query.GetFieldValue(i,dbValue);
				sWValue = sWValue+GetValue(&dbValue)+_T("|");
				Query.MoveNext();
			}
			Query.Close();
			
			lUser = 1;
			sValue.Format("LDZL_%s_LDZL",socet.Translate(sWValue)); 
			send(*sok,sValue,sValue.GetLength()+1,0);
		}
		
	}
	catch(CDBException *exsept)
	{
		exsept->Delete();
	}
	return lUser;
}

int LoadInvDocsByLocation(CDatabase *dClientBase, CStringA* saValue, SOCKET* sok)
{
	CDBVariant dbValue;
	CIniReader iniReader;
	CString sValue;
	long lUser;
	lUser = 0;
	CServerSocet socet;
	
	*saValue = saValue->Right(saValue->GetLength()-5);
	*saValue = saValue->Left(saValue->GetLength()-5);
	sValue = socet.Translate(*saValue);
	
	CString sName, sPassword;
	sName = sValue;
	if(!dClientBase->IsOpen())
	{
		
		CStringA sValue;
		sValue.Format("LLDL_%s_LLDL",socet.Translate(_T("Не подключились к БД!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	try
	{
		CRecordset Query(dClientBase);
		CString sSQL;
		sName.Replace(_T("'"),_T(""));
		
		//sSQL.Format(_T("select ID,[Date],[Description] from [Inventary Doc Header] where [Location Code] = '%s' order by [ID]"),sName);
		sSQL.Format(_T("select ID,[Date],[Description], coalesce((select top 1 1 from [Inventary Doc Tasc] as idt where idt.[ID_DOC] = idh.[ID]),0) as [Type] from [Inventary Doc Header] as idh where [Location Code] = '%s' and [ID_GROUP] = 0 order by [ID]"),sName);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		if(Query.IsEOF())
		{
			Query.Close();
			CStringA sValue;
			sValue.Format("LLDL_%s_LLDL",socet.Translate(_T("Не найдено ни одного документа!"))); 
			send(*sok,sValue,sValue.GetLength()+1,0);
		}
		else
		{
			sValue = "";
			int i;
			i=0;
			CStringA sValue;
			CStringW sWValue;

			while(!Query.IsEOF())
			{
				for(i=0;i<4;i++)
				{
					Query.GetFieldValue(i,dbValue);
					sWValue = sWValue+GetValue(&dbValue)+_T("|");
				}
				Query.MoveNext();
			}
			Query.Close();
			
			lUser = 1;
			

			sValue.Format("LLDL_%s_LLDL",socet.Translate(sWValue)); 
			send(*sok,sValue,sValue.GetLength()+1,0);
		}
		
	}
	catch(CDBException *exsept)
	{
		exsept->Delete();
	}
	return lUser;
}

int LoadLocationListByUser(CDatabase *dClientBase, CStringA* saValue, SOCKET* sok)
{
	CDBVariant dbValue;
	CIniReader iniReader;
	CString sValue;
	long lUser;
	lUser = 0;
	CServerSocet socet;
	
	*saValue = saValue->Right(saValue->GetLength()-5);
	*saValue = saValue->Left(saValue->GetLength()-5);
	sValue = socet.Translate(*saValue);
	
	CString sName, sPassword;
	sName = sValue;
	if(!dClientBase->IsOpen())
	{
		
		CStringA sValue;
		sValue.Format("LLLU_%s_LLLU",socet.Translate(_T("Не подключились к БД!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	try
	{
		CRecordset Query(dClientBase);
		CString sSQL;
		sName.Replace(_T("'"),_T(""));
		//sSQL.Format(_T("select distinct [Location code] from [%s$Warehouse Employee] join [%s$Location] as l on [Location code] = [code] and [Location Type] = 'ФИЗ' where [User ID]  = '%s'"),sFirm,sFirm,sName);
		//select distinct [Location code] from [Warehouse Employee] where [User ID]  = '%s'
		sSQL.Format(_T("select distinct [Location code] from [Warehouse Employee] where [User ID]  = '%s'"),sName);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		if(Query.IsEOF())
		{
			Query.Close();
			CStringA sValue;
			sValue.Format("LLLU_%s_LLLU",socet.Translate(_T("Не найдено ни одного склада!"))); 
			send(*sok,sValue,sValue.GetLength()+1,0);
		}
		else
		{
			sValue = "";
			int i;
			i=0;
			CStringA sValue;
			CStringW sWValue;

			while(!Query.IsEOF())
			{
				Query.GetFieldValue(i,dbValue);
				sWValue = sWValue+GetValue(&dbValue)+_T("|");
				Query.MoveNext();
			}
			Query.Close();
			
			lUser = 1;
			

			sValue.Format("LLLU_%s_LLLU",socet.Translate(sWValue)); 
			send(*sok,sValue,sValue.GetLength()+1,0);
		}
		
	}
	catch(CDBException *exsept)
	{
		exsept->Delete();
	}
	return lUser;
}
int SendNewProgVersion(CDatabase *dClientBase, CStringA* saValue, SOCKET* sok)
{
	long lUser;
	lUser = 0;

	CIniReader iniReader;
	CString sVal;

	CServerSocet socet;
	
	*saValue = saValue->Right(saValue->GetLength()-5);
	*saValue = saValue->Left(saValue->GetLength()-5);
	sVal = socet.Translate(*saValue);

	if(sVal.GetLength()<1)
	{
		CStringA sValue;
		sValue.Format("0_"); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	CString sCurrVersion,sFile;
	sCurrVersion.Format(_T("TAD_PROG_%s"),sVal);
	sFile = iniReader.ReadFromIni(_T("SERVICE"),sCurrVersion,_T(""));
	
	if(sFile.GetLength()<1)
	{
		CStringA sValue;
		sValue.Format("0_"); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}
	CFile mFile;
	
	if(!mFile.Open(sFile,CFile::modeRead))
	{
		CString sError;
		sError.Format(_T("%d"),GetLastError());
		WriteToLog(sError);
		CStringA sValue;
		sValue.Format("0_"); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	CStringA sValue;
	sValue.Format("%d_", mFile.GetLength()); 
	send(*sok,sValue,sValue.GetLength()+1,0);

	char *ch;
	ch = new(char[mFile.GetLength()]);
	mFile.Read(ch,mFile.GetLength());
	send(*sok,ch,mFile.GetLength()+1,0);
	mFile.Close();

	

	return lUser;
}


int SendAutorization(CDatabase *dClientBase, CStringA* saValue, SOCKET* sok)
{
	CIniReader iniReader;
	CString sValue;
	long lUser;
	lUser = 0;
	CServerSocet socet;
	
	*saValue = saValue->Right(saValue->GetLength()-5);
	*saValue = saValue->Left(saValue->GetLength()-5);
	sValue = socet.Translate(*saValue);
	
	CString sName, sVersion,sCurrVersion;
	int iFind;
	iFind = sValue.Find(_T("_"));
	if(iFind > 0)
	{
		sName = sValue.Left(iFind);
		sVersion = sValue.Right(sValue.GetLength()-iFind-1);
	}
	else
	{
		CStringA sValue;
		sValue.Format("AUTR_%s_AUTR",socet.Translate(_T("Ошибка передачи!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	if(!dClientBase->IsOpen())
	{
		
		CStringA sValue;
		sValue.Format("AUTR_%s_AUTR",socet.Translate(_T("Не подключились к БД!"))); 
		send(*sok,sValue,sValue.GetLength()+1,0);
		return lUser;
	}

	try
	{
		CRecordset Query(dClientBase);
		CString sSQL;
		sName.Replace(_T("'"),_T(""));
		//sSQL.Format(_T("SELECT 1 as ID FROM [%s$Warehouse Employee] WHERE [User ID] = '%s'"),sFirm,sName);
		sSQL.Format(_T("SELECT top 1 1 as ID FROM [Warehouse Employee] WHERE [User ID] = '%s'"),sName);
		Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
		if(Query.IsEOF())
		{
			Query.Close();
			CStringA sValue;
			sValue.Format("AUTR_%s_AUTR",socet.Translate(_T("Пользователь не найден!"))); 
			send(*sok,sValue,sValue.GetLength()+1,0);
		}
		else
		{
			Query.Close();
			
			lUser = 1;

			sCurrVersion.Format(_T("TAD_VESION_%s"),sVersion);

			sVersion = iniReader.ReadFromIni(_T("SERVICE"),sCurrVersion,_T(""));
			
			SYSTEMTIME time;
			GetSystemTime(&time);

			TIME_ZONE_INFORMATION inf;
			GetTimeZoneInformation(&inf);
			sName.Format(_T("_%d"),inf.Bias);

			COleDateTime oDate;
			oDate.SetDateTime(time.wYear,time.wMonth,time.wDay,time.wHour,time.wMinute,time.wSecond);
			sName = _T("_")+sVersion+_T("_")+oDate.Format(_T("%Y%m%d%H%M%S"))+sName;
			CStringA sValue;
			sValue.Format("AUTR_%s%s_AUTR",*saValue,socet.Translate(sName)); 
			send(*sok,sValue,sValue.GetLength()+1,0);
			return lUser;
		}
		
	}
	catch(CDBException *exsept)
	{
		CString sError;
		sError.Format(_T(""),exsept->m_strError);
		exsept->Delete();
		CStringA sValue;
		sValue.Format("AUTR_%s_AUTR",socet.Translate(sError)); 
		send(*sok,sValue,sValue.GetLength()+1,0);
	}
	return lUser;
}

LPTHREAD_START_ROUTINE ClientEventHandlerProc(LPVOID pparam)
{
	HANDLE hSocketEvent;
	WSANETWORKEVENTS NetworkEvents;
	hSocketEvent = WSACreateEvent();
	SOCKET sok;
	CServerSocet socet;
	CDatabase *dClientBase;
	dClientBase = NULL;
	CurrSocet *stCurrSocet = (CurrSocet*)pparam;
	sok = *stCurrSocet->sSocet->sokClientSocket[stCurrSocet->CurrPos]->sok;
	dClientBase = stCurrSocet->sSocet->sokClientSocket[stCurrSocet->CurrPos]->dBase;
	WSAEventSelect(sok, hSocketEvent, FD_CLOSE|FD_CONNECT|FD_READ);
	BOOL bSend;
	bSend = FALSE;
	CString sValue;
	CString sWrite;
	ULONG val = TRUE;
	if (SOCKET_ERROR == ioctlsocket(sok, FIONBIO, &val)) 
	{
		sWrite.Format(_T("Not Started Error %d"),WSAGetLastError());
		WriteToLog(sWrite);
		return 0L;
	}	

	
	CStringArray sDocsPos;
	CString sConnect;
	CStringA saValue;
	while (true) 
		{   
			WaitForSingleObject(hSocketEvent, INFINITE);
			WSAEnumNetworkEvents(sok, hSocketEvent, &NetworkEvents);
			if(NetworkEvents.lNetworkEvents == FD_CLOSE)
			{
				return 0L;
			}
			
			if(NetworkEvents.lNetworkEvents == FD_READ)
			{
				saValue = "";
				char gettext[100];
				int iRead;
				CStringA sa1;
				//int iTimeOut;
				
				while((iRead = recv(sok,gettext,100,0))!=SOCKET_ERROR)
				{

					/*if(iRead== SOCKET_ERROR)
					{
						iRead = WSAGetLastError();
						if(WSAGetLastError()!=10035)
						{
							sWrite.Format(_T("Error %d"),WSAGetLastError());
							WriteToLog(sWrite);
							break;

						}

						fd_set fdset;
						struct timeval tv = {0,100};
						FD_ZERO(&fdset); 
						FD_SET(sok,&fdset);
						iRead = select(FD_SETSIZE,&fdset,NULL,NULL,&tv); 
						if (iRead < 1)
						{
							break;
						}
						else
							continue;

		
		
					
					}*/
					sa1 = gettext;
					sa1 = sa1.Left(iRead);

					saValue = saValue +sa1;
				}
				sWrite = saValue;
				WriteToLog(sWrite);
				CString s;
				s = saValue;
				
				if(dClientBase == NULL)
				{
					return 0L;
				}
				
				if(!dClientBase->IsOpen())
					{
						dClientBase = OpenDatabase(stCurrSocet->sSocet->sokClientSocket[stCurrSocet->CurrPos]->dBase);
						stCurrSocet->sSocet->sokClientSocket[stCurrSocet->CurrPos]->dBase = dClientBase;
						if(!dClientBase->IsOpen())
							continue; 	
					}

				//AUTR Авторизация
				if((saValue.Left(5) == "AUTR_")&&(saValue.Right(5)=="_AUTR"))
				{
					SendAutorization(dClientBase,&saValue, &sok);
					continue;
				}
				//GNFP Новая версия проги
				if((saValue.Left(5) == "GNFP_")&&(saValue.Right(5)=="_GNFP"))
				{
					SendNewProgVersion(dClientBase,&saValue, &sok);
					continue;
				}

				//LLLU Список складов
				if((saValue.Left(5) == "LLLU_")&&(saValue.Right(5)=="_LLLU"))
				{
					LoadLocationListByUser(dClientBase,&saValue, &sok);
					continue;
				}

				//LLDL Список документов инветаризации по складу
				if((saValue.Left(5) == "LLDL_")&&(saValue.Right(5)=="_LLDL"))
				{
					LoadInvDocsByLocation(dClientBase,&saValue, &sok);
					continue;
				}
				//LDZL Список зон по документу
				if((saValue.Left(5) == "LDZL_")&&(saValue.Right(5)=="_LDZL"))
				{
					LoadDocZoneList(dClientBase,&saValue, &sok);
					continue;
				}
				//GIBB Загрузка информации по штрихкоду
				if((saValue.Left(5) == "GIBB_")&&(saValue.Right(5)=="_GIBB"))
				{
					LoadItemDataByBarcode(dClientBase,&saValue, &sok);
					continue;
				}
				//WTLI Запись в лог таблицу файл информации о проверке
				if((saValue.Left(5) == "WTLI_")&&(saValue.Right(5)=="_WTLI"))
				{

					WriteToLogTable(dClientBase,&saValue, &sok);
					continue;
				}
				//GTTI - получить задание для проверки
				if((saValue.Left(5) == "GTTI_")&&(saValue.Right(5)=="_GTTI"))
				{
					GetTaskToTest(dClientBase,&saValue, &sok);
					continue;
				}

				//GPTI Получить позиции для инвентаризации
				if((saValue.Left(5) == "GPTI_")&&(saValue.Right(5)=="_GPTI"))
				{

					GetTaskPosToTest(dClientBase,&saValue, &sok);
					continue;
				}

				//WPDI Записать проверку задания
				if((saValue.Left(5) == "WPDI_")&&(saValue.Right(5)=="_WPDI"))
				{
					WriteToLogTable2(dClientBase,&saValue, &sok);
					continue;
				}
				//GIBD Получить информацию по ячейкам хранения
				if((saValue.Left(5) == "GIBD_")&&(saValue.Right(5)=="_GIBD"))
				{
					
					GetDataByCode(dClientBase,&saValue, &sok);
					continue;
				}
				
			}				
		}
	return 0l;
}
static DWORD TestTask(DWORD someparam)
{
	CIniReader iniReader;
	CDatabase * dBase;
	dBase = new(CDatabase);
	CDatabase * dBaseNav;
	dBaseNav = new(CDatabase);
	CStringArray sTask;
	CDBVariant dbValue;
	CString sFirm;
	CStringArray saSQL;
	sFirm = iniReader.ReadFromIni(_T("NAV"),_T("FIRM"),_T("Shate-M"));
	CString sItem;
	while(m_Service.GetStatus() != SERVICE_STOPPED)
	{
		Sleep(1000);
		if(!dBase->IsOpen())
		{
			CString sConnect;
			CString sServer, sDatabase;
			sServer = iniReader.ReadFromIni(_T("DB"),_T("SERVER"),_T("svbyminssq3"));
			sDatabase = iniReader.ReadFromIni(_T("DB"),_T("DATABASE"),_T("SHATE-M-8"));
			try
			{
				sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
				#ifdef _DEBUG
					sConnect.Format(_T("DSN=Spbypril0777;UID=Admin2;PWD=Admin2;"));			
				#endif
				dBase->OpenEx(sConnect,CDatabase::noOdbcDialog);
				dBase->SetQueryTimeout(0);
			}				
			catch(CDBException *exsept)
			{
				COleDateTime oDate;
				oDate = COleDateTime::GetCurrentTime();
				iniReader.WriteToIni(_T("DB"),_T("LAST_ERROR_TIME"),oDate.Format(_T("%Y%m%d%H%M%S")));
				iniReader.WriteToIni(_T("DB"),_T("LAST_ERROR_SQL"),sConnect);
				iniReader.WriteToIni(_T("DB"),_T("LAST_ERROR_TEXT"),exsept->m_strError);
				exsept->Delete();
				if(dBase->IsOpen())
					dBase->Close();
			}

		}
		if(!dBase->IsOpen())
			continue;

		sTask.RemoveAll();
		CString sSQL;
		try
		{
			CRecordset Query(dBase);
			
			sSQL.Format(_T("select top 20 [Location Code], [id_doc], [id_zone], [cell] from  [Inventary Doc Tasc] left join [Inventary Doc Header] on [ID_DOC] = ID where [state] = 1"));
			Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
			int iField;
			while(!Query.IsEOF())
			{
				for(iField = 0;iField< Query.GetODBCFieldCount();iField++)
				{
					
					Query.GetFieldValue(iField,dbValue);
					sTask.Add(GetValue(&dbValue));
				}
				Query.MoveNext();
			}
			Query.Close();
		}				
		catch(CDBException *exsept)
		{
			
			COleDateTime oDate;
			oDate = COleDateTime::GetCurrentTime();
			iniReader.WriteToIni(_T("DB"),_T("LAST_ERROR_TIME"),oDate.Format(_T("%Y%m%d%H%M%S")));
			iniReader.WriteToIni(_T("DB"),_T("LAST_ERROR_SQL"),sSQL);
			iniReader.WriteToIni(_T("DB"),_T("LAST_ERROR_TEXT"),exsept->m_strError);
			exsept->Delete();
			dBase->Close();
		}

		if(sTask.GetCount()<1)
			continue;
		if(!dBaseNav->IsOpen())
		{
			CString sConnect;
			try
			{
				CString sServer,sDatabase,sUser;
				sServer = iniReader.ReadFromIni(_T("NAV"),_T("SERVER"),_T("SVBYPRISA0012"));
				sDatabase = iniReader.ReadFromIni(_T("NAV"),_T("DATABASE"),_T("Shate-M-sdev"));
				sConnect.Format(_T("DRIVER=SQL Server;SERVER=%s;UID=;WSID=%s;Trusted_Connection=Yes;DATABASE=%s;LANGUAGE=русский"),sServer,GetWinUserName(),sDatabase);
				#ifdef _DEBUG
					sConnect.Format(_T("DSN=svbyprisa0018;UID=RomanK;PWD=bskQWErty432;"));					
				#endif
				dBaseNav->OpenEx(sConnect,CDatabase::noOdbcDialog);
				sConnect.Format(_T("EXEC [sp_setapprole] '%s', '%s', 'none', 0, 0"),_T("$ndo$shadow"),_T("FF5EC4E40F67BD4EDF3D04F8B84364DAD0")); 
				dBaseNav->ExecuteSQL(sConnect);
				dBaseNav->SetQueryTimeout(0);
			}				
			catch(CDBException *exsept)
			{
				COleDateTime oDate;
				oDate = COleDateTime::GetCurrentTime();
				iniReader.WriteToIni(_T("NAV"),_T("LAST_ERROR_TIME"),oDate.Format(_T("%Y%m%d%H%M%S")));
				iniReader.WriteToIni(_T("NAV"),_T("LAST_ERROR_SQL"),sConnect);
				iniReader.WriteToIni(_T("NAV"),_T("LAST_ERROR_TEXT"),exsept->m_strError);
				exsept->Delete();
				if(dBaseNav->IsOpen())
					dBaseNav->Close();
			}
		}

		if(!dBaseNav->IsOpen())
			continue;

		while(sTask.GetCount()>0)
		{
			CString sLocation = sTask.ElementAt(0);
			sTask.RemoveAt(0,1);
			if(sTask.GetCount() < 1)
				break;
			CString sDoc = sTask.ElementAt(0);
			sTask.RemoveAt(0,1);
			if(sTask.GetCount() < 1)
				break;
			CString sZone = sTask.ElementAt(0);
			sTask.RemoveAt(0,1);
			if(sTask.GetCount() < 1)
				break;
			CString sCell = sTask.ElementAt(0);
			sTask.RemoveAt(0,1);

			if((sLocation.GetLength()<1)||
				(sDoc.GetLength()<1)||
				(sZone.GetLength()<1)||
				(sCell.GetLength()<1))
			{
				continue;
			}

			saSQL.RemoveAll();
			try
			{
				
				sSQL.Format(_T("UPDATE [Inventary Doc Line] SET [Count] = 0 WHERE  [DOC_ID] = %s and [ID_ZONE] = '%s' and [Cell] = '%s'"),sDoc,sZone,sCell);
				saSQL.Add(sSQL);

				CRecordset Query(dBaseNav);
				sSQL.Format(_T("select * from (select [Item No_],Sum(Quantity) as qnt from [%s$Warehouse Entry] where [Location Code] = '%s' and [Zone Code] = '%s' and [Bin Code] = '%s' group by [Item No_]) as tab where qnt > 0"),sFirm,sLocation,sZone,sCell);
				Query.Open(CRecordset::forwardOnly,sSQL,CRecordset::readOnly);
				int iField;
				while(!Query.IsEOF())
				{
					iField = 0;
					Query.GetFieldValue(iField,dbValue);
					sItem = GetValue(&dbValue);
					
					iField = 1;
					Query.GetFieldValue(iField,dbValue);

					sSQL.Format(_T("UPDATE [Inventary Doc Line] SET [Count] = %s WHERE  [DOC_ID] = %s and [ID_ZONE] = '%s' and [Cell] = '%s' and [Item] = '%s'"),GetValue(&dbValue),sDoc,sZone,sCell,sItem);
					saSQL.Add(sSQL);
					Query.MoveNext();
				}
				Query.Close();

				sSQL.Format(_T("UPDATE [Inventary Doc Tasc] SET [STATE] = 2 WHERE  [ID_DOC] = %s and [ID_ZONE] = '%s' and [CELL] = '%s'"),sDoc,sZone,sCell);
				saSQL.Add(sSQL);
			}
			catch(CDBException *exsept)
			{
				COleDateTime oDate;
				oDate = COleDateTime::GetCurrentTime();
				iniReader.WriteToIni(_T("NAV"),_T("LAST_ERROR_TIME"),oDate.Format(_T("%Y%m%d%H%M%S")));
				iniReader.WriteToIni(_T("NAV"),_T("LAST_ERROR_SQL"),sSQL);
				iniReader.WriteToIni(_T("NAV"),_T("LAST_ERROR_TEXT"),exsept->m_strError);
				exsept->Delete();
				if(dBaseNav->IsOpen())
					dBaseNav->Close();
			}

			try
			{
				dBase->BeginTrans();
				while(saSQL.GetCount()>0)
				{
					sSQL = saSQL.ElementAt(0);
					dBase->ExecuteSQL(sSQL);
					saSQL.RemoveAt(0,1);
				}
				dBase->CommitTrans();
			}
			catch(CDBException *exsept)
			{
				dBase->Rollback();
				COleDateTime oDate;
				oDate = COleDateTime::GetCurrentTime();
				iniReader.WriteToIni(_T("DB"),_T("LAST_ERROR_TIME"),oDate.Format(_T("%Y%m%d%H%M%S")));
				iniReader.WriteToIni(_T("DB"),_T("LAST_ERROR_SQL"),sSQL);
				iniReader.WriteToIni(_T("DB"),_T("LAST_ERROR_TEXT"),exsept->m_strError);
				exsept->Delete();
				dBase->Close();
			}

			//sFirm
			/*
			
			*/




		}

	}
	delete(dBase);
	delete(dBaseNav);
	return 0L;
}

void Run()
{
	HANDLE hThreadNav;
	CIniReader iniReader;
	hThreadNav = NULL;
	DWORD dwThreadID; 
	
	while(hThreadNav==NULL)
	{
		hThreadNav = CreateThread(NULL, NULL, (LPTHREAD_START_ROUTINE)TestTask, NULL, NULL, &dwThreadID); 
		if(hThreadNav == NULL)
		{
			WriteToLog(_T("Не создан дочерний поток!"));
		}
		Sleep(2000);
	}

	CServerSocet ServerSocket;
	CString sError;
	CString sVal;
	


	while(m_Service.GetStatus() != SERVICE_STOPPED)
	{
		if(!ServerSocket.GetState())
		{
			ServerSocket.sProtokol = iniReader.ReadFromIni(_T("SERVER"),_T("PROTOCOL"),_T("TCP"));
			ServerSocket.iPort = _wtoi(iniReader.ReadFromIni(_T("SERVER"),_T("PORT"),_T("6010")));
			ServerSocket.iMaxCol = _wtoi(iniReader.ReadFromIni(_T("SERVER"),_T("USER_COUNT"),_T("100")));
			if(ServerSocket.iMaxCol>1)
			{
				sError = "";
				if(!ServerSocket.StartServer(&sError))
				{
					iniReader.WriteToIni(_T("SERVER"),_T("LAST_ERROR"),_T("Описание в логе"));
				}
				else
					iniReader.WriteToIni(_T("SERVER_LOG"),_T("ERROR"),_T(""));
				int iFind;
				iFind = sError.Find(_T("\n"),0);
				
				while(iFind >0)
				{
					sVal = sError.Left(iFind);
					sError = sError.Right(sError.GetLength()-iFind-1);
					iFind = sVal.Find(_T("\t"),0);
					iniReader.WriteToIni(_T("SERVER_LOG"),sVal.Left(iFind),sVal.Right(sVal.GetLength()-iFind-1));
					iFind = sError.Find(_T("\n"),0);
				}
			}
			else
			{
				COleDateTime oDate;
				oDate = COleDateTime::GetCurrentTime();
				iniReader.WriteToIni(_T("SERVER"),_T("LAST_ERROR_TIME"),oDate.Format(_T("%d.%m.%Y %H:%M:%S")));
				iniReader.WriteToIni(_T("SERVER"),_T("LAST_ERROR"),_T("Не корректное число USER_COUNT"));
			}
			
		}
		else
		{
			MSG msg;
			//ClientEventHandlerProc
			ServerSocket.m_ClientTread = &ClientEventHandlerProc;
			while(GetMessage( &msg, ServerSocket.SocWin->m_hWnd, 0, 0 ) )
			{
				TranslateMessage(&msg);
				DispatchMessage(&msg);
			}

			if(iniReader.ReadFromIni(_T("SERVER"),_T("RESTART"),_T("0"))==_T("1"))
			{
				ServerSocket.CloseSocket();
			}
		}
		#ifdef _DEBUG
			if(iniReader.ReadFromIni(_T("DEBUG"),_T("STOP"),_T("0"))==_T("1"))
				break;
		#endif
		Sleep(500);	
	}
	
	if(hThreadNav)
	{
		TerminateThread(hThreadNav,0);
	}
}

int _tmain(int argc, TCHAR* argv[], TCHAR* envp[])
{
	int nRetCode = 0;
	CString sValue;
	if (!AfxWinInit(::GetModuleHandle(NULL), NULL, ::GetCommandLine(), 0))
	{
		nRetCode = 1;
		return nRetCode;
	}
	CString sFileName =argv[0];
	sFileName.MakeLower();
	if(sFileName.Right(4)!=_T(".ini"))
	{
		sFileName = sFileName.Left(sFileName.GetLength()-4);
		sFileName = sFileName + _T(".ini");
	}
	free((void*)AfxGetApp()->m_pszProfileName);
	AfxGetApp()->m_pszProfileName = _tcsdup(sFileName);

	
	
	
	
	m_Service.LoadFromIni();
	m_Service.SetHelpInfo(_T("Сервис сервера ТСД для ведения инвентаризаций"));

	if (argc > 1)
	{
		CString sValue = argv[1];
		sValue.MakeLower();

		if (sValue == _T("/install"))
		{
			
			if(!m_Service.Install(&sValue))			
				AfxMessageBox(sValue);
			else
				AfxMessageBox(_T("install"));
		}
		else if (sValue == _T("/uninstall"))
		{
			if(!m_Service.Uninstall(&sValue))			
				AfxMessageBox(sValue);
			else
				AfxMessageBox(_T("uninstall"));
		}
		else
		{
			m_Service.DisplayHelp();
		}
		return 0;
	}
	m_Service.SetClientFunction(&Run);
	m_Service.Run();
	return nRetCode;
}
