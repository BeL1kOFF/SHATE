// stdafx.cpp : source file that includes just the standard includes
// Nav_Export.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"

// TODO: reference any additional headers you need in STDAFX.H
// and not in this file
double _wtofmy(CString sVal)
{	
	
	while(sVal.Right(1)==_T('0'))
	{
		sVal = sVal.Left(sVal.GetLength()-1);
	}
	double dVal = 0.0;
	double dValMin = 0.0;
	int iPos;
	iPos = 0;
	if(sVal[0]==_T('-'))
	{
		iPos++;
	}
	while(iPos < sVal.GetLength())
	{
		if((sVal[iPos]==_T('.'))||(sVal[iPos]==_T(',')))
			break;

		dVal = dVal*10+(sVal[iPos]-_T('0'));
		iPos++;
	}

	
	int NewPos;
	for(NewPos = sVal.GetLength()-1;NewPos>iPos;NewPos--)
	{
		dValMin = (dValMin+(sVal[NewPos]-_T('0')))/10;
	}
	if(sVal[0]==_T('-'))
		dVal = -1*(dVal+dValMin);
	else
		dVal = dVal+dValMin;
	return dVal;
}