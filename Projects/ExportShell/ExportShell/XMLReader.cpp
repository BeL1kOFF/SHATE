#include "StdAfx.h"
#include "XMLReader.h"

CXMLReader::CXMLReader(void)
{
	p_Buffer = NULL;
	XMLGlobal = NULL;
	
}

CXMLReader::~CXMLReader(void)
{
	if(p_Buffer != NULL)
	{
		delete(p_Buffer);
		p_Buffer = NULL;
	}

	if(XMLGlobal != NULL)
	{
		ClearTree();
	}
}

BOOL CXMLReader::ReadFromFile(CString sFileName)
{
	ClearTree();
	setlocale(LC_ALL,"Russian");
	if(p_Buffer != NULL)
	{
		delete(p_Buffer);
		p_Buffer = NULL;
	}

	if(sFileName.GetLength()<1)
		return FALSE;

	CFile m_File;
	if(!m_File.Open(sFileName, CFile::modeRead))
	{
		return FALSE;
	}
	lWidth = m_File.GetLength();
	char * pByteByffer;
	pByteByffer = new char[lWidth];
	if(!m_File.Read(pByteByffer,lWidth))
	{
		m_File.Close();
		delete(pByteByffer);
		return FALSE;
	}
	p_Buffer = new wchar_t[lWidth];
	mbstowcs(p_Buffer,pByteByffer,  lWidth);
	
	m_File.Close();
	return TRUE;
}

BOOL CXMLReader::ParseBuffer()
{
	long i;
	CString sValue;
	sValue = "";
	ClearTree();
	
	stXMLElemet* Element;
	Element = NULL;

	for(i=0;i<lWidth;i++)
	{
		if(p_Buffer[i] == _T('<'))
		{
			while(sValue.Right(1)==_T(" "))
				sValue = sValue.Left(sValue.GetLength()-1);
			if(sValue.GetLength() > 0)
			{
				Element = AddParseElement(sValue,Element);
			}
			sValue = _T('<');
			continue;
		}

		if(p_Buffer[i] == _T('>'))
		{
			if(sValue.GetLength() > 0)
			{
				Element = AddParseElement(sValue+p_Buffer[i],Element);
			}
			sValue = "";
			continue;
		}
		if(p_Buffer[i] != _T('\n'))
			if(p_Buffer[i] != _T('\r'))
		sValue = sValue +p_Buffer[i];
		
	}
	return TRUE;
}


int CXMLReader::ClearTree(void)
{
	if(XMLGlobal != NULL)
	{
		stXMLElemet* Element;
		stXMLElemet* Element1;
		Element = XMLGlobal->Next;
		delete(XMLGlobal);
		XMLGlobal = NULL;
		while(Element != NULL)
		{
			Element1 = Element;
			Element = Element->Next;
			delete(Element1);
		}
	}
	return 0;
}

stXMLElemet* CXMLReader::AddParseElement(CString sValue,stXMLElemet *Element)
{
	stXMLElemet * NewElement;
	NewElement = NULL;

	NewElement = new(stXMLElemet);
	if(sValue.Right(2)==_T("?>"))
	{
		NewElement->wc_Separator = '?';
	}
	else
	{
		NewElement->wc_Separator = '/';
	}
	NewElement->Next = NULL;
	NewElement->Parent = NULL;
	if(XMLGlobal == NULL)
	{
		XMLGlobal = new(stXMLElemet);
		XMLGlobal->Parent = NULL;
		XMLGlobal->sValue = "";
		XMLGlobal->Next = NULL;
		
	}
	if(Element == NULL)
		Element = XMLGlobal;

	if(sValue.Left(2)==_T("</"))
	{
		sValue = sValue.Right(sValue.GetLength()-2);
		sValue = sValue.Left(sValue.GetLength()-1);
		delete(NewElement);
		NewElement = Element;
		while(NewElement != NULL)
		{
			if(NewElement->sName == sValue)
			{
				NewElement = NewElement->Parent;
				break;
			}
			NewElement = NewElement->Parent;
		}

	}
	else
	{
		if(sValue.Left(1)==_T("<"))
		{
			sValue = sValue.Right(sValue.GetLength()-1);
			if((sValue.Right(2)==_T("/>"))||(sValue.Right(2)==_T("?>")))
			{
				
				sValue = sValue.Left(sValue.GetLength()-2);
				if(sValue.Find(_T(" "),0)>-1)
				{
					int iFind;
					iFind = sValue.Find(_T(" "),0);
					NewElement->sName = sValue.Left(iFind);
					sValue = sValue.Right(sValue.GetLength()-1-iFind);
					while(sValue.Left(1)==_T(" "))
						sValue = sValue.Right(sValue.GetLength()-1);
					iFind = sValue.Find(_T("="),0);
					stXMLPropesty * Prop;
					CString wchSeparator;

					while(sValue.GetLength()>0)
					{
						Prop = new(stXMLPropesty);
						Prop->sName = sValue.Left(iFind);
						while(Prop->sName.Left(1)==_T(" "))
						{
							Prop->sName = Prop->sName.Right(Prop->sName.GetLength()-1);
						}

						sValue = sValue.Right(sValue.GetLength()-1-iFind);
						while(sValue.Left(1)==_T(" "))
						{
							sValue =sValue.Right(sValue.GetLength()-1);
						}
						
						if(sValue.Left(1)==_T("\""))
						{
							wchSeparator = _T("\"");
						}
						else
						{
							wchSeparator = _T(" ");
						}
						iFind = sValue.Find(wchSeparator,1);	
						if(iFind > 0)
						{
							Prop->sValue = sValue.Left(iFind+1);
							sValue = sValue.Right(sValue.GetLength()-1-iFind);
						}
						else
						{
							Prop->sValue = sValue;
							sValue = "";
						}

						iFind = sValue.Find(_T("="),0);
						NewElement->aPropertes.Add(Prop);
						if(iFind < 1)
							break;
						
					}
				}
				else
					NewElement->sName = sValue;
				NewElement->Parent = Element;
				while(Element->Next!=NULL)
				{
					Element = Element->Next;
				}
				Element->Next = NewElement;
				NewElement = NewElement->Parent;

			}
			else
			{
				sValue = sValue.Left(sValue.GetLength()-1);
				if(sValue.Find(_T(" "),0)>-1)
				{
					int iFind;
					iFind = sValue.Find(_T(" "),0);
					NewElement->sName = sValue.Left(iFind);
					sValue = sValue.Right(sValue.GetLength()-1-iFind);
					iFind = sValue.Find(_T("="),0);
					stXMLPropesty * Prop;
					CString wchSeparator;
					while(sValue.GetLength()>0)
					{
						Prop = new(stXMLPropesty);
						Prop->sName = sValue.Left(iFind);
						sValue = sValue.Right(sValue.GetLength()-1-iFind);
						while(sValue.Left(1)==_T(" "))
						{
							sValue =sValue.Right(sValue.GetLength()-1);
						}
						if(sValue.Left(1)==_T("\""))
						{
							wchSeparator = _T("\"");
						}
						else
						{
							wchSeparator = _T(" ");
						}
						iFind = sValue.Find(wchSeparator,1);	
						if(iFind > 0)
						{
							Prop->sValue = sValue.Left(iFind+1);
							sValue = sValue.Right(sValue.GetLength()-1-iFind);
						}
						else
						{
							Prop->sValue = sValue;
							sValue = "";
						}
						NewElement->aPropertes.Add(Prop);
						iFind = sValue.Find(_T("="),0);
						if(iFind < 1)
							break;
						
					}
				}
				else
					NewElement->sName = sValue;
				NewElement->Parent = Element;
				while(Element->Next!=NULL)
				{
					Element = Element->Next;
				}
				Element->Next = NewElement;
			}
			
			
		}
		else
		{
			Element->sValue = sValue;
			delete(NewElement);
			NewElement = Element;
		}
	}
	


	return NewElement;
}

BOOL CXMLReader::WriteToFile(CString sFileName)
{
	if(XMLGlobal==NULL)
		return FALSE;
	setlocale(LC_ALL,"Russian");
	stXMLElemet * NewElement;
	stXMLElemet * ParentElement;
	NewElement = XMLGlobal->Next;

	CStdioFile oFile;
	
	if(!oFile.Open(sFileName,CFile::modeCreate|CFile::modeWrite))
	{
		return FALSE;
	}


	
	int iPos;
	stXMLPropesty * Prop;
	while(NewElement!=NULL)
	{
		oFile.WriteString(_T("<")+NewElement->sName);
		iPos = 0;
		while(iPos < NewElement->aPropertes.GetCount())
		{
			Prop = NewElement->aPropertes.ElementAt(iPos);
			oFile.WriteString(_T(" ")+Prop->sName+_T(" = ")+Prop->sValue+_T(" "));
			iPos++;
		}
		
		if(NewElement->sValue.GetLength()>0)
		{
			oFile.WriteString(_T(">"));
			oFile.WriteString(NewElement->sValue);
			if(NewElement->Next != NULL)
			{
				if(NewElement->Next->Parent != NewElement)
				{
					
					oFile.WriteString(_T("<")+NewElement->wc_Separator+NewElement->sName+_T(">"));
				}
				oFile.WriteString(_T("\n"));
			}
			else
			{
				oFile.WriteString(_T("<")+NewElement->wc_Separator+NewElement->sName+_T(">\n"));
				ParentElement = NewElement->Parent;
				while(ParentElement != NULL)
				{
					if(ParentElement->sName.GetLength()>0)
						oFile.WriteString(_T("<")+ParentElement->wc_Separator+ParentElement->sName+_T(">\n"));
					ParentElement = ParentElement->Parent;
				}
			}
		}
		else
		{
			if(NewElement->Next != NULL)
			{
				if(NewElement->Next->Parent != NewElement)
				{
					oFile.WriteString(NewElement->wc_Separator+_T(">\n"));
					ParentElement = NewElement->Parent;
					while(ParentElement != NULL)
					{
						if(ParentElement==NewElement->Next->Parent)
							break;
						oFile.WriteString(_T("<")+ParentElement->wc_Separator+ParentElement->sName+_T(">\n"));
						ParentElement = ParentElement->Parent;
					}


				}
				else
					oFile.WriteString(_T(">\n"));
				
			}
			else
			{
				oFile.WriteString(NewElement->wc_Separator+ _T(">\n"));
				ParentElement = NewElement->Parent;
				while(ParentElement != NULL)
				{
					oFile.WriteString(_T("<")+ParentElement->wc_Separator+ParentElement->sName+_T(">\n"));
					ParentElement = ParentElement->Parent;
				}
			}
		}
		
		
		NewElement = NewElement->Next;
	}
	oFile.Close();
	return TRUE;
}

stXMLElemet* CXMLReader::AddElement(CString sName,CString sValue,stXMLElemet *Element)
{
	stXMLElemet* NewElement;
	stXMLElemet* StartParent;
	NewElement = NULL;
		
	if(XMLGlobal == NULL)
	{
		XMLGlobal = new(stXMLElemet);
		XMLGlobal->Parent = NULL;
		XMLGlobal->sValue = "";
		XMLGlobal->Next = NULL;
	}
		
	if(Element == NULL)
		Element = XMLGlobal;

	StartParent = Element;
	
	while(Element != NULL)
	{
		if(Element->Next == NULL)
		{
			NewElement = new(stXMLElemet);
			NewElement->Next = NULL;
			NewElement->sName = sName;
			NewElement->sValue = sValue;
			NewElement->Parent = StartParent;
			NewElement->wc_Separator = _T("/");
			NewElement->sValue;
			Element->Next = NewElement;
			break;
		}
		if(StartParent->Parent == Element->Next->Parent)
		{
			NewElement = new(stXMLElemet);
			NewElement->Next = Element->Next;
			Element->Next = NewElement;
			NewElement->sName = sName;
			NewElement->sValue = sValue;
			NewElement->Parent = StartParent;
			NewElement->wc_Separator = _T("/");
		}
			
		Element = Element->Next;
	}
	return NewElement;
}

BOOL CXMLReader::AddProperty(CString sName,CString sValue,stXMLElemet *Element)
{
	if(Element == NULL)
		return FALSE;
	stXMLPropesty * Prop;
	int iPos = 0;
	while(iPos < Element->aPropertes.GetCount())
	{
		Prop = Element->aPropertes.ElementAt(iPos);
		if(Prop->sName == sName)
		{
			Prop->sValue = sValue;
			return TRUE;
		}
		iPos++;
	}
	Prop = new(stXMLPropesty);
	Prop->sName = sName;
	Prop->sValue = sValue;
	Element->aPropertes.Add(Prop);

	return TRUE;
}

BOOL CXMLReader::SetSeparator(CString sValue,stXMLElemet *Element)
{
	if(Element == NULL)
		return FALSE;

	Element->wc_Separator = sValue;
	return TRUE;
}