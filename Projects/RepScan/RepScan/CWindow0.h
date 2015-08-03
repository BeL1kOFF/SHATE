// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CWindow0 wrapper class

class CWindow0 : public COleDispatchDriver
{
public:
	CWindow0(){} // Calls COleDispatchDriver default constructor
	CWindow0(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CWindow0(const CWindow0& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Window methods
public:
	VARIANT Activate()
	{
		VARIANT result;
		InvokeHelper(0x130, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ActivateNext()
	{
		VARIANT result;
		InvokeHelper(0x45b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ActivatePrevious()
	{
		VARIANT result;
		InvokeHelper(0x45c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Close(VARIANT& SaveChanges, VARIANT& Filename, VARIANT& RouteWorkbook)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x115, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &SaveChanges, &Filename, &RouteWorkbook);
		return result;
	}
	VARIANT LargeScroll(VARIANT& Down, VARIANT& Up, VARIANT& ToRight, VARIANT& ToLeft)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x223, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Down, &Up, &ToRight, &ToLeft);
		return result;
	}
	VARIANT NewWindow()
	{
		VARIANT result;
		InvokeHelper(0x118, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Panes(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x28d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT PrintOut(VARIANT& From, VARIANT& To, VARIANT& Copies, VARIANT& Preview, VARIANT& ActivePrinter, VARIANT& PrintToFile, VARIANT& Collate)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x389, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &From, &To, &Copies, &Preview, &ActivePrinter, &PrintToFile, &Collate);
		return result;
	}
	VARIANT PrintPreview()
	{
		VARIANT result;
		InvokeHelper(0x119, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ScrollWorkbookTabs(VARIANT& Sheets, VARIANT& Position)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x296, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Sheets, &Position);
		return result;
	}
	VARIANT SetInfoDisplay(VARIANT& Cell, VARIANT& Formula, VARIANT& Value, VARIANT& Format, VARIANT& Protection, VARIANT& Names, VARIANT& Precedents, VARIANT& Dependents, VARIANT& Note)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x413, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Cell, &Formula, &Value, &Format, &Protection, &Names, &Precedents, &Dependents, &Note);
		return result;
	}
	VARIANT SmallScroll(VARIANT& Down, VARIANT& Up, VARIANT& ToRight, VARIANT& ToLeft)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x224, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Down, &Up, &ToRight, &ToLeft);
		return result;
	}

	// Window properties
public:
	VARIANT GetActiveCell()
	{
		VARIANT result;
		GetProperty(0x131, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveCell(VARIANT &propVal)
	{
		SetProperty(0x131, VT_VARIANT, &propVal);
	}
	VARIANT GetActiveChart()
	{
		VARIANT result;
		GetProperty(0xb7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveChart(VARIANT &propVal)
	{
		SetProperty(0xb7, VT_VARIANT, &propVal);
	}
	VARIANT GetActivePane()
	{
		VARIANT result;
		GetProperty(0x282, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActivePane(VARIANT &propVal)
	{
		SetProperty(0x282, VT_VARIANT, &propVal);
	}
	VARIANT GetActiveSheet()
	{
		VARIANT result;
		GetProperty(0x133, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveSheet(VARIANT &propVal)
	{
		SetProperty(0x133, VT_VARIANT, &propVal);
	}
	VARIANT GetCaption()
	{
		VARIANT result;
		GetProperty(0x8b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCaption(VARIANT &propVal)
	{
		SetProperty(0x8b, VT_VARIANT, &propVal);
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
	VARIANT GetDisplayFormulas()
	{
		VARIANT result;
		GetProperty(0x284, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayFormulas(VARIANT &propVal)
	{
		SetProperty(0x284, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayGridlines()
	{
		VARIANT result;
		GetProperty(0x285, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayGridlines(VARIANT &propVal)
	{
		SetProperty(0x285, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayHeadings()
	{
		VARIANT result;
		GetProperty(0x286, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayHeadings(VARIANT &propVal)
	{
		SetProperty(0x286, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayHorizontalScrollBar()
	{
		VARIANT result;
		GetProperty(0x399, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayHorizontalScrollBar(VARIANT &propVal)
	{
		SetProperty(0x399, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayOutline()
	{
		VARIANT result;
		GetProperty(0x287, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayOutline(VARIANT &propVal)
	{
		SetProperty(0x287, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayRightToLeft()
	{
		VARIANT result;
		GetProperty(0x288, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayRightToLeft(VARIANT &propVal)
	{
		SetProperty(0x288, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayVerticalScrollBar()
	{
		VARIANT result;
		GetProperty(0x39a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayVerticalScrollBar(VARIANT &propVal)
	{
		SetProperty(0x39a, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayWorkbookTabs()
	{
		VARIANT result;
		GetProperty(0x39b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayWorkbookTabs(VARIANT &propVal)
	{
		SetProperty(0x39b, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayZeros()
	{
		VARIANT result;
		GetProperty(0x289, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayZeros(VARIANT &propVal)
	{
		SetProperty(0x289, VT_VARIANT, &propVal);
	}
	VARIANT GetFreezePanes()
	{
		VARIANT result;
		GetProperty(0x28a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFreezePanes(VARIANT &propVal)
	{
		SetProperty(0x28a, VT_VARIANT, &propVal);
	}
	VARIANT GetGridlineColor()
	{
		VARIANT result;
		GetProperty(0x28b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetGridlineColor(VARIANT &propVal)
	{
		SetProperty(0x28b, VT_VARIANT, &propVal);
	}
	VARIANT GetGridlineColorIndex()
	{
		VARIANT result;
		GetProperty(0x28c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetGridlineColorIndex(VARIANT &propVal)
	{
		SetProperty(0x28c, VT_VARIANT, &propVal);
	}
	VARIANT GetHeight()
	{
		VARIANT result;
		GetProperty(0x7b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHeight(VARIANT &propVal)
	{
		SetProperty(0x7b, VT_VARIANT, &propVal);
	}
	VARIANT GetIndex()
	{
		VARIANT result;
		GetProperty(0x1e6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetIndex(VARIANT &propVal)
	{
		SetProperty(0x1e6, VT_VARIANT, &propVal);
	}
	VARIANT GetLeft()
	{
		VARIANT result;
		GetProperty(0x7f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLeft(VARIANT &propVal)
	{
		SetProperty(0x7f, VT_VARIANT, &propVal);
	}
	VARIANT GetOnWindow()
	{
		VARIANT result;
		GetProperty(0x26f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnWindow(VARIANT &propVal)
	{
		SetProperty(0x26f, VT_VARIANT, &propVal);
	}
	VARIANT GetPageSetup()
	{
		VARIANT result;
		GetProperty(0x3e6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPageSetup(VARIANT &propVal)
	{
		SetProperty(0x3e6, VT_VARIANT, &propVal);
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
	VARIANT GetRangeSelection()
	{
		VARIANT result;
		GetProperty(0x4a5, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRangeSelection(VARIANT &propVal)
	{
		SetProperty(0x4a5, VT_VARIANT, &propVal);
	}
	VARIANT GetScrollColumn()
	{
		VARIANT result;
		GetProperty(0x28e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetScrollColumn(VARIANT &propVal)
	{
		SetProperty(0x28e, VT_VARIANT, &propVal);
	}
	VARIANT GetScrollRow()
	{
		VARIANT result;
		GetProperty(0x28f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetScrollRow(VARIANT &propVal)
	{
		SetProperty(0x28f, VT_VARIANT, &propVal);
	}
	VARIANT GetSelectedSheets()
	{
		VARIANT result;
		GetProperty(0x290, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSelectedSheets(VARIANT &propVal)
	{
		SetProperty(0x290, VT_VARIANT, &propVal);
	}
	VARIANT GetSelection()
	{
		VARIANT result;
		GetProperty(0x93, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSelection(VARIANT &propVal)
	{
		SetProperty(0x93, VT_VARIANT, &propVal);
	}
	VARIANT GetSplit()
	{
		VARIANT result;
		GetProperty(0x291, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSplit(VARIANT &propVal)
	{
		SetProperty(0x291, VT_VARIANT, &propVal);
	}
	VARIANT GetSplitColumn()
	{
		VARIANT result;
		GetProperty(0x292, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSplitColumn(VARIANT &propVal)
	{
		SetProperty(0x292, VT_VARIANT, &propVal);
	}
	VARIANT GetSplitHorizontal()
	{
		VARIANT result;
		GetProperty(0x293, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSplitHorizontal(VARIANT &propVal)
	{
		SetProperty(0x293, VT_VARIANT, &propVal);
	}
	VARIANT GetSplitRow()
	{
		VARIANT result;
		GetProperty(0x294, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSplitRow(VARIANT &propVal)
	{
		SetProperty(0x294, VT_VARIANT, &propVal);
	}
	VARIANT GetSplitVertical()
	{
		VARIANT result;
		GetProperty(0x295, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSplitVertical(VARIANT &propVal)
	{
		SetProperty(0x295, VT_VARIANT, &propVal);
	}
	VARIANT GetTabRatio()
	{
		VARIANT result;
		GetProperty(0x2a1, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTabRatio(VARIANT &propVal)
	{
		SetProperty(0x2a1, VT_VARIANT, &propVal);
	}
	VARIANT GetTop()
	{
		VARIANT result;
		GetProperty(0x7e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTop(VARIANT &propVal)
	{
		SetProperty(0x7e, VT_VARIANT, &propVal);
	}
	VARIANT GetType()
	{
		VARIANT result;
		GetProperty(0x6c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetType(VARIANT &propVal)
	{
		SetProperty(0x6c, VT_VARIANT, &propVal);
	}
	VARIANT GetUsableHeight()
	{
		VARIANT result;
		GetProperty(0x185, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetUsableHeight(VARIANT &propVal)
	{
		SetProperty(0x185, VT_VARIANT, &propVal);
	}
	VARIANT GetUsableWidth()
	{
		VARIANT result;
		GetProperty(0x186, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetUsableWidth(VARIANT &propVal)
	{
		SetProperty(0x186, VT_VARIANT, &propVal);
	}
	VARIANT GetVisible()
	{
		VARIANT result;
		GetProperty(0x22e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetVisible(VARIANT &propVal)
	{
		SetProperty(0x22e, VT_VARIANT, &propVal);
	}
	VARIANT GetVisibleRange()
	{
		VARIANT result;
		GetProperty(0x45e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetVisibleRange(VARIANT &propVal)
	{
		SetProperty(0x45e, VT_VARIANT, &propVal);
	}
	VARIANT GetWidth()
	{
		VARIANT result;
		GetProperty(0x7a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWidth(VARIANT &propVal)
	{
		SetProperty(0x7a, VT_VARIANT, &propVal);
	}
	VARIANT GetWindowNumber()
	{
		VARIANT result;
		GetProperty(0x45f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWindowNumber(VARIANT &propVal)
	{
		SetProperty(0x45f, VT_VARIANT, &propVal);
	}
	VARIANT GetWindowState()
	{
		VARIANT result;
		GetProperty(0x18c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWindowState(VARIANT &propVal)
	{
		SetProperty(0x18c, VT_VARIANT, &propVal);
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
