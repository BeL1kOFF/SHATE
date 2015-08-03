// MyImage.cpp : implementation file
//


#include "stdafx.h"
#include "MyImage.h"


// CMyImage

IMPLEMENT_DYNAMIC(CMyImage, CWnd)

CMyImage::CMyImage()
{
	RegisterWindowClass();
	m_ImageList = NULL;
	iImage = -1;
	bClicked = FALSE;
	/*
	BOOL CTestImageDlg::InsertIcon()
{
HICON hIcon;
hIcon=::LoadIcon(AfxGetResourceHandle(),MAKEINTRESOURCE(IDI_ICON1)); 
if (hIcon!=NULL) 
{
     if (cl.Add(hIcon)==-1) return FALSE;
}
else return FALSE;
hIcon=::LoadIcon(AfxGetResourceHandle(),MAKEINTRESOURCE(IDI_ICON2)); 
if (hIcon!=NULL) 
{
     if (cl.Add(hIcon)==-1) return FALSE;
}
else return FALSE;
hIcon=::LoadIcon(AfxGetResourceHandle(),MAKEINTRESOURCE(IDI_ICON3)); 
if (hIcon!=NULL) 
{
     if (cl.Add(hIcon)==-1) return FALSE;
}
else return FALSE;
return TRUE;
}

	*/
}

CMyImage::~CMyImage()
{
	
}


BEGIN_MESSAGE_MAP(CMyImage, CWnd)
	 ON_WM_PAINT()
	 ON_WM_LBUTTONUP()
	 ON_WM_LBUTTONDOWN()
	 ON_WM_MOUSELEAVE()
END_MESSAGE_MAP()



// CMyImage message handlers
BOOL CMyImage::Create(const RECT& rect, CWnd* pParentWnd, UINT nID, DWORD dwStyle)
{
    ASSERT(pParentWnd->GetSafeHwnd());
    if (!CWnd::Create(MYIMAGE_CLASSNAME, NULL, dwStyle, rect, pParentWnd, nID))
	{
			int iCode;
			iCode = GetLastError();
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
			CString s;
			TRACE(_T("ошибка: %d -  %s"),iCode,res);
			LocalFree(cstr);	
			return FALSE;
	}

    return TRUE;
}

void CMyImage::OnPaint() 
{
	if((iImage<0)||(m_ImageList==NULL))
		return;
	CPaintDC dc(this); 
	CRect rect;
	GetClientRect(rect);
	if(!bClicked)
	{
		CPoint p(rect.left + 1,rect.top+1);
		m_ImageList->Draw(&dc, iImage, p, ILD_NORMAL);
	}
	else
	{
		CPoint p(rect.left + 2,rect.top+2);
		m_ImageList->Draw(&dc, iImage, p, ILD_NORMAL);
	}


	CPen BlackPen(PS_SOLID,1,RGB(0,0,0));
	dc.SelectObject(BlackPen);
	dc.MoveTo(rect.left,rect.top);
	dc.LineTo(rect.right,rect.top);
	dc.MoveTo(rect.left,rect.top);
	dc.LineTo(rect.left,rect.bottom);
	if(bClicked)
	{
		dc.MoveTo(rect.left,rect.top+1);
		dc.LineTo(rect.right,rect.top+1);
		dc.MoveTo(rect.left+1,rect.top);
		dc.LineTo(rect.left+1,rect.bottom);

		CPen WhitePen(PS_SOLID,1,RGB(255,255,255));
		dc.SelectObject(WhitePen);
		dc.MoveTo(rect.left,rect.bottom-1);
		dc.LineTo(rect.right-1,rect.bottom-1);
		dc.LineTo(rect.right-1,rect.top);
	}
	else
	{
		dc.MoveTo(rect.left,rect.bottom-1);
		dc.LineTo(rect.right-1,rect.bottom-1);
		dc.LineTo(rect.right-1,rect.top);
	}

}

BOOL CMyImage::RegisterWindowClass()
{
    WNDCLASS wndcls;
    HINSTANCE hInst = AfxGetInstanceHandle();
   // HINSTANCE hInst = AfxGetResourceHandle(); 

    if (!(::GetClassInfo(hInst, MYIMAGE_CLASSNAME, &wndcls)))
    {
        // otherwise we need to register a new class
        wndcls.style            = CS_DBLCLKS | CS_HREDRAW | CS_VREDRAW;
        wndcls.lpfnWndProc      = ::DefWindowProc;
        wndcls.cbClsExtra       = wndcls.cbWndExtra = 0;
        wndcls.hInstance        = hInst;
        wndcls.hIcon            = NULL;
        wndcls.hCursor          = AfxGetApp()->LoadStandardCursor(IDC_ARROW);
        wndcls.hbrBackground    = (HBRUSH) (COLOR_3DFACE + 1);
        wndcls.lpszMenuName     = NULL;
        wndcls.lpszClassName    = MYIMAGE_CLASSNAME;

        if (!AfxRegisterClass(&wndcls)) {
            AfxThrowResourceException();
            return FALSE;
        }
    }
    return TRUE;
}

BOOL CMyImage::SetImage(CImageList* List, int iImageNumber)
{
	if(List==NULL)
		return FALSE;

	if(iImageNumber < 0)
		return FALSE;
	if(List->GetImageCount()<1)
		return FALSE;
	if(List->GetImageCount()<iImageNumber+1)
		return FALSE;
	iImage = iImageNumber;
	m_ImageList = List;
	return TRUE;
}

void CMyImage::OnLButtonDown(UINT nFlags, CPoint point)
{
	bClicked = TRUE;
	Invalidate();
	SetCapture();
}

void CMyImage::OnMouseLeave()
{	
	if(bClicked)
	{
		ReleaseCapture();
		bClicked = FALSE;
		Invalidate();
	}
}

void CMyImage::OnLButtonUp(UINT nFlags, CPoint point)
{
	ReleaseCapture();
	bClicked = FALSE;
	Invalidate();
	SendMessageToParent(BM_CLICK);
}

LRESULT CMyImage::SendMessageToParent(int nMessage)
{
    if (!IsWindow(m_hWnd))
        return 0;
    NMHDR hdr;
	hdr.hwndFrom = m_hWnd;
    hdr.idFrom   = GetDlgCtrlID();
    hdr.code     = nMessage;
    CWnd *pOwner = GetOwner();
    if (pOwner && IsWindow(pOwner->m_hWnd))
        return pOwner->SendMessage(WM_NOTIFY, GetDlgCtrlID(), (LPARAM)&hdr);
    else
        return 0;
}