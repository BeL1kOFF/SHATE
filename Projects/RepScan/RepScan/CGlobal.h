// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CGlobal wrapper class

class CGlobal : public COleDispatchDriver
{
public:
	CGlobal(){} // Calls COleDispatchDriver default constructor
	CGlobal(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CGlobal(const CGlobal& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// _Global methods
public:
	VARIANT AddIns(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x225, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Calculate()
	{
		VARIANT result;
		InvokeHelper(0x117, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Cells(VARIANT& RowIndex, VARIANT& ColumnIndex)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xee, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &RowIndex, &ColumnIndex);
		return result;
	}
	VARIANT Charts(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x79, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Columns(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xf1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT DDEExecute(VARIANT& Channel, VARIANT& String)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x14d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Channel, &String);
		return result;
	}
	VARIANT DDEInitiate(VARIANT& App, VARIANT& Topic)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x14e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &App, &Topic);
		return result;
	}
	VARIANT DDEPoke(VARIANT& Channel, VARIANT& Item, VARIANT& Data)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x14f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Channel, &Item, &Data);
		return result;
	}
	VARIANT DDERequest(VARIANT& Channel, VARIANT& Item)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x150, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Channel, &Item);
		return result;
	}
	VARIANT DDETerminate(VARIANT& Channel)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x151, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Channel);
		return result;
	}
	VARIANT DialogSheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x2fc, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT _Evaluate(VARIANT& Name)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Name);
		return result;
	}
	VARIANT Evaluate(VARIANT& Name)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xfffffffb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Name);
		return result;
	}
	VARIANT Excel4IntlMacroSheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x245, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Excel4MacroSheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x243, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT ExecuteExcel4Macro(VARIANT& String)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x15e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &String);
		return result;
	}
	VARIANT Intersect(VARIANT& Arg1, VARIANT& Arg2, VARIANT& Arg3, VARIANT& Arg4, VARIANT& Arg5, VARIANT& Arg6, VARIANT& Arg7, VARIANT& Arg8, VARIANT& Arg9, VARIANT& Arg10, VARIANT& Arg11, VARIANT& Arg12, VARIANT& Arg13, VARIANT& Arg14, VARIANT& Arg15, VARIANT& Arg16, VARIANT& Arg17, VARIANT& Arg18, VARIANT& Arg19, VARIANT& Arg20, VARIANT& Arg21, VARIANT& Arg22, VARIANT& Arg23, VARIANT& Arg24, VARIANT& Arg25, VARIANT& Arg26, VARIANT& Arg27, VARIANT& Arg28, VARIANT& Arg29, VARIANT& Arg30)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x2fe, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Arg1, &Arg2, &Arg3, &Arg4, &Arg5, &Arg6, &Arg7, &Arg8, &Arg9, &Arg10, &Arg11, &Arg12, &Arg13, &Arg14, &Arg15, &Arg16, &Arg17, &Arg18, &Arg19, &Arg20, &Arg21, &Arg22, &Arg23, &Arg24, &Arg25, &Arg26, &Arg27, &Arg28, &Arg29, &Arg30);
		return result;
	}
	VARIANT MenuBars(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x24d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Modules(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x246, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Names(VARIANT& Index, VARIANT& IndexLocal, VARIANT& RefersTo)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1ba, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index, &IndexLocal, &RefersTo);
		return result;
	}
	VARIANT Range(VARIANT& Cell1, VARIANT& Cell2)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xc5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Cell1, &Cell2);
		return result;
	}
	VARIANT Rows(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x102, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Run(VARIANT& Macro, VARIANT& Arg1, VARIANT& Arg2, VARIANT& Arg3, VARIANT& Arg4, VARIANT& Arg5, VARIANT& Arg6, VARIANT& Arg7, VARIANT& Arg8, VARIANT& Arg9, VARIANT& Arg10, VARIANT& Arg11, VARIANT& Arg12, VARIANT& Arg13, VARIANT& Arg14, VARIANT& Arg15, VARIANT& Arg16, VARIANT& Arg17, VARIANT& Arg18, VARIANT& Arg19, VARIANT& Arg20, VARIANT& Arg21, VARIANT& Arg22, VARIANT& Arg23, VARIANT& Arg24, VARIANT& Arg25, VARIANT& Arg26, VARIANT& Arg27, VARIANT& Arg28, VARIANT& Arg29, VARIANT& Arg30)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x103, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Macro, &Arg1, &Arg2, &Arg3, &Arg4, &Arg5, &Arg6, &Arg7, &Arg8, &Arg9, &Arg10, &Arg11, &Arg12, &Arg13, &Arg14, &Arg15, &Arg16, &Arg17, &Arg18, &Arg19, &Arg20, &Arg21, &Arg22, &Arg23, &Arg24, &Arg25, &Arg26, &Arg27, &Arg28, &Arg29, &Arg30);
		return result;
	}
	VARIANT SendKeys(VARIANT& Keys, VARIANT& Wait)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x17f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Keys, &Wait);
		return result;
	}
	VARIANT Sheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1e5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT ShortcutMenus(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x308, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Toolbars(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x228, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Union(VARIANT& Arg1, VARIANT& Arg2, VARIANT& Arg3, VARIANT& Arg4, VARIANT& Arg5, VARIANT& Arg6, VARIANT& Arg7, VARIANT& Arg8, VARIANT& Arg9, VARIANT& Arg10, VARIANT& Arg11, VARIANT& Arg12, VARIANT& Arg13, VARIANT& Arg14, VARIANT& Arg15, VARIANT& Arg16, VARIANT& Arg17, VARIANT& Arg18, VARIANT& Arg19, VARIANT& Arg20, VARIANT& Arg21, VARIANT& Arg22, VARIANT& Arg23, VARIANT& Arg24, VARIANT& Arg25, VARIANT& Arg26, VARIANT& Arg27, VARIANT& Arg28, VARIANT& Arg29, VARIANT& Arg30)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x30b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Arg1, &Arg2, &Arg3, &Arg4, &Arg5, &Arg6, &Arg7, &Arg8, &Arg9, &Arg10, &Arg11, &Arg12, &Arg13, &Arg14, &Arg15, &Arg16, &Arg17, &Arg18, &Arg19, &Arg20, &Arg21, &Arg22, &Arg23, &Arg24, &Arg25, &Arg26, &Arg27, &Arg28, &Arg29, &Arg30);
		return result;
	}
	VARIANT Windows(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1ae, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Workbooks(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x23c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Worksheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1ee, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}

	// _Global properties
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
	VARIANT GetActiveDialog()
	{
		VARIANT result;
		GetProperty(0x32f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveDialog(VARIANT &propVal)
	{
		SetProperty(0x32f, VT_VARIANT, &propVal);
	}
	VARIANT GetActiveMenuBar()
	{
		VARIANT result;
		GetProperty(0x2f6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveMenuBar(VARIANT &propVal)
	{
		SetProperty(0x2f6, VT_VARIANT, &propVal);
	}
	VARIANT GetActivePrinter()
	{
		VARIANT result;
		GetProperty(0x132, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActivePrinter(VARIANT &propVal)
	{
		SetProperty(0x132, VT_VARIANT, &propVal);
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
	VARIANT GetActiveWindow()
	{
		VARIANT result;
		GetProperty(0x2f7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveWindow(VARIANT &propVal)
	{
		SetProperty(0x2f7, VT_VARIANT, &propVal);
	}
	VARIANT GetActiveWorkbook()
	{
		VARIANT result;
		GetProperty(0x134, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveWorkbook(VARIANT &propVal)
	{
		SetProperty(0x134, VT_VARIANT, &propVal);
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
	VARIANT GetDDEAppReturnCode()
	{
		VARIANT result;
		GetProperty(0x14c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDDEAppReturnCode(VARIANT &propVal)
	{
		SetProperty(0x14c, VT_VARIANT, &propVal);
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
	VARIANT GetThisWorkbook()
	{
		VARIANT result;
		GetProperty(0x30a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetThisWorkbook(VARIANT &propVal)
	{
		SetProperty(0x30a, VT_VARIANT, &propVal);
	}

};
