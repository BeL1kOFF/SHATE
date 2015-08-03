// SPMaskEdit.cpp : implementation file
//

#include "stdafx.h"
#include "RepScan.h"
#include "SPMaskEdit.h"


// SPMaskEdit

SPMaskEdit::SPMaskEdit()
{
	m_bLastKeyWasDelete = false;
	m_bLastKeyWasBackspace = false;
	m_cPlaceHolder = '_';
}

SPMaskEdit::~SPMaskEdit()
{
}

void SPMaskEdit::setMask(LPCTSTR pszMask, char cPlaceHolder)
{
	m_strMaskText = pszMask;

	m_strSaveText.Empty();

	int nIndex = 0;
	while (nIndex < m_strMaskText.GetLength())
	{
		if (isMaskChar(nIndex))
			m_strSaveText += m_strMaskText[nIndex];
		else
			m_strSaveText += m_cPlaceHolder;

		nIndex++;
	}

	CWnd::SetWindowText(m_strSaveText);

}

void SPMaskEdit::SetWindowText(LPCTSTR pszText)
{
	setText(pszText);
}

void SPMaskEdit::setText(LPCTSTR pszText)
{
	CString strText(pszText);

	m_strSaveText.Empty();

	int nMaskIndex = 0;
	int nTextIndex = 0;

	while (nMaskIndex < m_strMaskText.GetLength())
	{
		if (!isMaskChar(nMaskIndex))
		{
			if (nTextIndex < strText.GetLength())
				m_strSaveText += strText[nTextIndex++];
			else
				m_strSaveText += m_cPlaceHolder;
		}
		else
			m_strSaveText += m_strMaskText[nMaskIndex];

		nMaskIndex++;
	}

	CWnd::SetWindowText(m_strSaveText);
}

CString SPMaskEdit::getText()
{
	CString strText;

	int nMaskIndex = 0;
	while (nMaskIndex < m_strMaskText.GetLength())
	{
		if (!isMaskChar(nMaskIndex))
			strText += m_strSaveText[nMaskIndex];

		nMaskIndex++;
	}
	return strText;
}


BEGIN_MESSAGE_MAP(SPMaskEdit, CEdit)
	//{{AFX_MSG_MAP(SPMaskEdit)
	ON_CONTROL_REFLECT(EN_UPDATE, OnUpdate)
	ON_WM_KEYDOWN()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

/////////////////////////////////////////////////////////////////////////////
// SPMaskEdit message handlers

bool SPMaskEdit::isMaskChar(int nPos)
{
	ASSERT(nPos < m_strMaskText.GetLength());
	return (m_strMaskText[nPos] != _T('×')); // Add new masks as needed
}

bool SPMaskEdit::getReplacementChar(int nPos, wchar_t cWant, wchar_t& cGet)
{
	if (nPos >= m_strMaskText.GetLength())
		return false;

	switch (m_strMaskText[nPos])
	{
	case _T('×'):
		if ((cWant < '0')||(cWant>'9'))
			return false;

		cGet = cWant;
		break;
	default:
		cGet = m_strMaskText[nPos];
		break;
		
	}

	return true;
}

int SPMaskEdit::gotoNextEntryChar(int nPos)
{
	if (m_bLastKeyWasBackspace)
	{
		nPos--;

		while (nPos >= 0 && isMaskChar(nPos))
			nPos--;

		nPos++;
	}
	else
	{
		while (nPos < m_strMaskText.GetLength() && isMaskChar(nPos))
			nPos++;
	}
	return nPos;
}

void SPMaskEdit::OnUpdate() 
{
	int nStart, nEnd;
	GetSel(nStart, nEnd);

	CString strEditText;
	GetWindowText(strEditText);

	if (strEditText == m_strSaveText)
		return;

	if (m_bLastKeyWasBackspace)
	{
		m_strSaveText.SetAt(nStart, isMaskChar(nStart) ? m_strMaskText[nStart] : m_cPlaceHolder);

		CWnd::SetWindowText(m_strSaveText);
		int nNext = gotoNextEntryChar(nStart);
		SetSel(nNext, nNext);
	}
	else if (m_bLastKeyWasDelete)
	{
		if((nStart==0)&&(nEnd==0))
		{
			for(int i=0;i<m_strSaveText.GetLength();i++)
			{
			m_strSaveText.SetAt(i, isMaskChar(i) ? m_strMaskText[i] : m_cPlaceHolder);	
			}
			m_strSaveText.SetAt(nStart, isMaskChar(nStart) ? m_strMaskText[nStart] : m_cPlaceHolder);
			CWnd::SetWindowText(m_strSaveText);
			int nNext = gotoNextEntryChar(nStart);
			SetSel(nNext, nNext);
		}
		else
		{
			m_strSaveText.SetAt(nStart, isMaskChar(nStart) ? m_strMaskText[nStart] : m_cPlaceHolder);
			CWnd::SetWindowText(m_strSaveText);
			int nNext = gotoNextEntryChar(nStart + 1);
			SetSel(nNext, nNext);
		}
	}
	else
	{
		if (nStart - 1 < 0)
			return;

		wchar_t cWanted = strEditText[nStart - 1];

		wchar_t cReplace = 0;

		CString sOld;
		sOld = m_strSaveText;
		if (getReplacementChar(nStart - 1, cWanted, cReplace))
		{
			if (m_strSaveText.GetLength() < nStart)
				m_strSaveText.GetBufferSetLength(nStart);

			m_strSaveText.SetAt(nStart - 1, cReplace);
			m_strSaveText.ReleaseBuffer();
		}
		
		
		COleDateTime dat;
		dat.ParseDateTime(m_strSaveText);
		
		/*if(dat.Format(_T("%d.%m.%Y"))!= m_strSaveText)
		{
			m_strSaveText = sOld;	
			CWnd::SetWindowText(m_strSaveText);
			SetSel(nStart-1, nStart-1);
		}
		else
		{*/
			CWnd::SetWindowText(m_strSaveText);
			int nNext = gotoNextEntryChar(nStart);
			SetSel(nNext, nNext);
	//	}
	}
}

void SPMaskEdit::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags) 
{
	m_bLastKeyWasDelete = (VK_DELETE == nChar);
	m_bLastKeyWasBackspace = (VK_BACK == nChar);
	CEdit::OnKeyDown(nChar, nRepCnt, nFlags);
}


