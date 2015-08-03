// stdafx.cpp : source file that includes just the standard includes
// Nav_Scaner_Assembler.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"


CString GetErrorText(int iCode)
{
	void* cstr;
	FormatMessage(
	FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
	NULL,
	iCode,
	MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), // Default language
	(LPTSTR) &cstr,
	0,
	NULL
	);
	CString res((char*)cstr);
	LocalFree(cstr);
	return res;
}

CString ReadStringFromIni(CString sGroupe, CString sNameValue, CString sDefaulValue)
{
	CString sRet;
	sRet = sDefaulValue;
	CString sFileName;
	wchar_t cBuffer[MAX_PATH];
    ::GetModuleFileName(NULL, cBuffer, MAX_PATH);
    sFileName = cBuffer;
    sFileName = sFileName.Left(sFileName.ReverseFind('\\'));
	


	CWinApp *myap = AfxGetApp();
	if(myap!=NULL)
	{
		if (sFileName.Right(1)!="\\") sFileName += "\\";
			sFileName = sFileName+myap->m_pszProfileName;
		if(sFileName.Right(4)!=_T(".ini"))
			sFileName = sFileName+_T(".ini");


		CStdioFile stFile;
		if(stFile.Open(sFileName,CFile::modeRead))
		{
			CString sValue;
			CString sFindGroupe;
			CString sFindValue;
			sFindValue = sNameValue;
			while(sFindValue.Left(1) == _T(" "))
				sFindValue = sFindValue.Right(sFindValue.GetLength()-1);

			while(sFindValue.Right(1)==_T(" "))
				sFindValue = sFindValue.Left(sFindValue.GetLength()-1);
			
			CString sStrValue;

			sFindGroupe = _T("[")+sGroupe+_T("]");
			while(stFile.ReadString(sValue))
				{
					if(sValue == sFindGroupe)
					{
						int iPos;
						while(stFile.ReadString(sValue))
						{
							iPos = sValue.Find(_T("="));
							if(iPos>0)
							{
								sStrValue = sValue.Left(iPos);
								while(sStrValue.Right(1)==_T(" "))
									sStrValue = sStrValue.Left(sStrValue.GetLength()-1);

								if(sFindValue == sStrValue)
								{
									sRet = sValue.Right(sValue.GetLength()-1-iPos);
									while(sRet.Left(1) == _T(" "))
										sRet = sRet.Right(sRet.GetLength()-1);

									while(sRet.Right(1)==_T(" "))
										sRet = sRet.Left(sRet.GetLength()-1);

									stFile.Close();
									return sRet;
								}
							}
							
							
							//sFindValue
						}
						stFile.Close();
						return sRet;
					}
				}
			stFile.Close();
		}
	}
	return sRet;
}

BOOL WriteStringToIni(CString sGroupe, CString sNameValue, CString sNewValue)
{
	CWinApp *myap = AfxGetApp();
	if(myap==NULL)
		return FALSE;
	
	CString sFileName;
	wchar_t cBuffer[MAX_PATH];
    ::GetModuleFileName(NULL, cBuffer, MAX_PATH);
    sFileName = cBuffer;
    sFileName = sFileName.Left(sFileName.ReverseFind('\\'));
	
	if (sFileName.Right(1)!="\\") sFileName += "\\";
			sFileName = sFileName+myap->m_pszProfileName;
	
	if(sFileName.Right(4)!=_T(".ini"))
			sFileName = sFileName+_T(".ini");


	CStdioFile stFile;
	CStringArray saFileStrings;
	CString sFindGroupe;
	sFindGroupe = _T("[")+sGroupe+_T("]");

	int iFindGr;
	iFindGr = 0;

	saFileStrings.RemoveAll();
	int iPos;
		iPos = 0;

	CString sFindValue;
	sFindValue = sNameValue;
	while(sFindValue.Left(1) == _T(" "))
		sFindValue = sFindValue.Right(sFindValue.GetLength()-1);
	while(sFindValue.Right(1)==_T(" "))
		sFindValue = sFindValue.Left(sFindValue.GetLength()-1);

	if(stFile.Open(sFileName,CFile::modeRead))
	{
		CString sValue;
		
		while(stFile.ReadString(sValue))
		{
			if(sValue.Left(1)==_T("["))
			{
				if(sFindGroupe==sValue)
				{
					
					saFileStrings.InsertAt(iPos,sFindGroupe);
					iPos++;
					
					
					CString sStrValue;
					int iPost;
					BOOL iFind;
					while(stFile.ReadString(sValue))
					{
						iFind = TRUE;
						if(sValue.Left(1)==_T("["))
						{
							saFileStrings.InsertAt(iPos,sFindValue+_T("=")+sValue);
							iPos++;
							break;
						}
						else
							{
								iPost = sValue.Find(_T("="));
								if(iPost>0)
								{
									sStrValue = sValue.Left(iPost);
									while(sStrValue.Left(1) == _T(" "))
										sStrValue = sStrValue.Right(sStrValue.GetLength()-1);

									while(sStrValue.Right(1)==_T(" "))
										sStrValue = sStrValue.Left(sStrValue.GetLength()-1);
									
									if(sStrValue==sFindValue)	
									{
										sValue = sFindValue+_T("=")+sNewValue;
										iFindGr = iPos;
										break;
									}
									else
									{
										if(sStrValue>sFindValue)	
											{
												saFileStrings.InsertAt(iPos,sFindValue+_T("=")+sNewValue);
												iPos++;
												break;
											}
										else
											{
												saFileStrings.InsertAt(iPos,sValue);
												iPos++;
											}
										iFind = FALSE;
									}
								}
							}
					}

					if(!iFind)
					{
						iFindGr = 1;
						saFileStrings.InsertAt(iPos,sFindValue+_T("=")+sNewValue);
						iPos++;
					}




				}
				
				if((iFindGr<1)&&(sFindGroupe<sValue))
				{
					iFindGr = iPos;
					saFileStrings.InsertAt(iPos,sFindGroupe);
					iPos++;
					CString sFindValue;
					sFindValue = sNameValue+_T("=");
					while(sFindValue.Left(1) == _T(" "))
						sFindValue = sFindValue.Right(sFindValue.GetLength()-1);

					while(sFindValue.Right(1)==_T(" "))
						sFindValue = sFindValue.Left(sFindValue.GetLength()-1);

					saFileStrings.InsertAt(iPos,sFindValue+_T("=")+sNewValue);
					iPos++;
				}
			}
			if(sValue.GetLength()>0)
			{
				saFileStrings.InsertAt(iPos,sValue);
				iPos++;
			}
			
		}
		stFile.Close();
	}
	
	if(iFindGr<1)
	{
		saFileStrings.InsertAt(iPos,sFindGroupe);
		iPos++;
		while(sFindValue.Left(1) == _T(" "))
			sFindValue = sFindValue.Right(sFindValue.GetLength()-1);

		while(sFindValue.Right(1)==_T(" "))
			sFindValue = sFindValue.Left(sFindValue.GetLength()-1);

		saFileStrings.InsertAt(iPos,sFindValue+_T("=")+sNewValue);
	}

	if(stFile.Open(sFileName,CFile::modeCreate|CFile::modeWrite))
	{
		for(int i=0;i<saFileStrings.GetCount();i++)
		{
			stFile.WriteString(saFileStrings.ElementAt(i));
		}
		stFile.Close();
		saFileStrings.RemoveAll();
	}
	return TRUE;
}


CString ReplaceLeftSymbols(CString sValue,int iType)
{
	CString sRet;
	int i;
	switch(iType)
	{
		case 0:
			for(i=0;i<sValue.GetLength()-1;i++)
			{
				if(sValue[i] >= _T('0')&&(sValue[i] <= _T('9')))
					sRet = sValue[i];
			}
		break;
	
	}
	return sRet;
}