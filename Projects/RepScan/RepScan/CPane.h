// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CPane wrapper class

class CPane : public COleDispatchDriver
{
public:
	CPane(){} // Calls COleDispatchDriver default constructor
	CPane(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CPane(const CPane& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Pane methods
public:
	VARIANT Activate()
	{
		VARIANT result;
		InvokeHelper(0x130, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT LargeScroll(VARIANT& Down, VARIANT& Up, VARIANT& ToRight, VARIANT& ToLeft)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x223, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Down, &Up, &ToRight, &ToLeft);
		return result;
	}
	VARIANT SmallScroll(VARIANT& Down, VARIANT& Up, VARIANT& ToRight, VARIANT& ToLeft)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x224, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Down, &Up, &ToRight, &ToLeft);
		return result;
	}

	// Pane properties
public:
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

};
