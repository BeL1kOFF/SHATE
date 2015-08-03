// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CPageSetup wrapper class

class CPageSetup : public COleDispatchDriver
{
public:
	CPageSetup(){} // Calls COleDispatchDriver default constructor
	CPageSetup(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CPageSetup(const CPageSetup& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// PageSetup methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// PageSetup properties
public:
	VARIANT GetBlackAndWhite()
	{
		VARIANT result;
		GetProperty(0x3f1, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBlackAndWhite(VARIANT &propVal)
	{
		SetProperty(0x3f1, VT_VARIANT, &propVal);
	}
	VARIANT GetBottomMargin()
	{
		VARIANT result;
		GetProperty(0x3ea, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBottomMargin(VARIANT &propVal)
	{
		SetProperty(0x3ea, VT_VARIANT, &propVal);
	}
	VARIANT GetCenterFooter()
	{
		VARIANT result;
		GetProperty(0x3f2, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCenterFooter(VARIANT &propVal)
	{
		SetProperty(0x3f2, VT_VARIANT, &propVal);
	}
	VARIANT GetCenterHeader()
	{
		VARIANT result;
		GetProperty(0x3f3, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCenterHeader(VARIANT &propVal)
	{
		SetProperty(0x3f3, VT_VARIANT, &propVal);
	}
	VARIANT GetCenterHorizontally()
	{
		VARIANT result;
		GetProperty(0x3ed, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCenterHorizontally(VARIANT &propVal)
	{
		SetProperty(0x3ed, VT_VARIANT, &propVal);
	}
	VARIANT GetCenterVertically()
	{
		VARIANT result;
		GetProperty(0x3ee, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCenterVertically(VARIANT &propVal)
	{
		SetProperty(0x3ee, VT_VARIANT, &propVal);
	}
	VARIANT GetChartSize()
	{
		VARIANT result;
		GetProperty(0x3f4, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetChartSize(VARIANT &propVal)
	{
		SetProperty(0x3f4, VT_VARIANT, &propVal);
	}
	VARIANT GetCreator()
	{
		VARIANT result;
		GetProperty(0x95, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCreator(VARIANT &propVal)
	{
		SetProperty(0x95, VT_VARIANT, &propVal);
	}
	VARIANT GetDraft()
	{
		VARIANT result;
		GetProperty(0x3fc, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDraft(VARIANT &propVal)
	{
		SetProperty(0x3fc, VT_VARIANT, &propVal);
	}
	VARIANT GetFirstPageNumber()
	{
		VARIANT result;
		GetProperty(0x3f0, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFirstPageNumber(VARIANT &propVal)
	{
		SetProperty(0x3f0, VT_VARIANT, &propVal);
	}
	VARIANT GetFitToPagesTall()
	{
		VARIANT result;
		GetProperty(0x3f5, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFitToPagesTall(VARIANT &propVal)
	{
		SetProperty(0x3f5, VT_VARIANT, &propVal);
	}
	VARIANT GetFitToPagesWide()
	{
		VARIANT result;
		GetProperty(0x3f6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFitToPagesWide(VARIANT &propVal)
	{
		SetProperty(0x3f6, VT_VARIANT, &propVal);
	}
	VARIANT GetFooterMargin()
	{
		VARIANT result;
		GetProperty(0x3f7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFooterMargin(VARIANT &propVal)
	{
		SetProperty(0x3f7, VT_VARIANT, &propVal);
	}
	VARIANT GetHeaderMargin()
	{
		VARIANT result;
		GetProperty(0x3f8, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHeaderMargin(VARIANT &propVal)
	{
		SetProperty(0x3f8, VT_VARIANT, &propVal);
	}
	VARIANT GetLeftFooter()
	{
		VARIANT result;
		GetProperty(0x3f9, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLeftFooter(VARIANT &propVal)
	{
		SetProperty(0x3f9, VT_VARIANT, &propVal);
	}
	VARIANT GetLeftHeader()
	{
		VARIANT result;
		GetProperty(0x3fa, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLeftHeader(VARIANT &propVal)
	{
		SetProperty(0x3fa, VT_VARIANT, &propVal);
	}
	VARIANT GetLeftMargin()
	{
		VARIANT result;
		GetProperty(0x3e7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLeftMargin(VARIANT &propVal)
	{
		SetProperty(0x3e7, VT_VARIANT, &propVal);
	}
	VARIANT GetOrder()
	{
		VARIANT result;
		GetProperty(0xc0, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOrder(VARIANT &propVal)
	{
		SetProperty(0xc0, VT_VARIANT, &propVal);
	}
	VARIANT GetOrientation()
	{
		VARIANT result;
		GetProperty(0x86, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOrientation(VARIANT &propVal)
	{
		SetProperty(0x86, VT_VARIANT, &propVal);
	}
	VARIANT GetPaperSize()
	{
		VARIANT result;
		GetProperty(0x3ef, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPaperSize(VARIANT &propVal)
	{
		SetProperty(0x3ef, VT_VARIANT, &propVal);
	}
	VARIANT GetParent()
	{
		VARIANT result;
		GetProperty(0x96, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetParent(VARIANT &propVal)
	{
		SetProperty(0x96, VT_VARIANT, &propVal);
	}
	VARIANT GetPrintArea()
	{
		VARIANT result;
		GetProperty(0x3fb, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrintArea(VARIANT &propVal)
	{
		SetProperty(0x3fb, VT_VARIANT, &propVal);
	}
	VARIANT GetPrintGridlines()
	{
		VARIANT result;
		GetProperty(0x3ec, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrintGridlines(VARIANT &propVal)
	{
		SetProperty(0x3ec, VT_VARIANT, &propVal);
	}
	VARIANT GetPrintHeadings()
	{
		VARIANT result;
		GetProperty(0x3eb, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrintHeadings(VARIANT &propVal)
	{
		SetProperty(0x3eb, VT_VARIANT, &propVal);
	}
	VARIANT GetPrintNotes()
	{
		VARIANT result;
		GetProperty(0x3fd, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrintNotes(VARIANT &propVal)
	{
		SetProperty(0x3fd, VT_VARIANT, &propVal);
	}
	VARIANT GetPrintQuality()
	{
		VARIANT result;
		GetProperty(0x3fe, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrintQuality(VARIANT &propVal)
	{
		SetProperty(0x3fe, VT_VARIANT, &propVal);
	}
	VARIANT GetPrintTitleColumns()
	{
		VARIANT result;
		GetProperty(0x3ff, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrintTitleColumns(VARIANT &propVal)
	{
		SetProperty(0x3ff, VT_VARIANT, &propVal);
	}
	VARIANT GetPrintTitleRows()
	{
		VARIANT result;
		GetProperty(0x400, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrintTitleRows(VARIANT &propVal)
	{
		SetProperty(0x400, VT_VARIANT, &propVal);
	}
	VARIANT GetRightFooter()
	{
		VARIANT result;
		GetProperty(0x401, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRightFooter(VARIANT &propVal)
	{
		SetProperty(0x401, VT_VARIANT, &propVal);
	}
	VARIANT GetRightHeader()
	{
		VARIANT result;
		GetProperty(0x402, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRightHeader(VARIANT &propVal)
	{
		SetProperty(0x402, VT_VARIANT, &propVal);
	}
	VARIANT GetRightMargin()
	{
		VARIANT result;
		GetProperty(0x3e8, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRightMargin(VARIANT &propVal)
	{
		SetProperty(0x3e8, VT_VARIANT, &propVal);
	}
	VARIANT GetTopMargin()
	{
		VARIANT result;
		GetProperty(0x3e9, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTopMargin(VARIANT &propVal)
	{
		SetProperty(0x3e9, VT_VARIANT, &propVal);
	}
	VARIANT GetZoom()
	{
		VARIANT result;
		GetProperty(0x297, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetZoom(VARIANT &propVal)
	{
		SetProperty(0x297, VT_VARIANT, &propVal);
	}

};
