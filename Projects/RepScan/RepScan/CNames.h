// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CNames wrapper class

class CNames : public COleDispatchDriver
{
public:
	CNames(){} // Calls COleDispatchDriver default constructor
	CNames(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CNames(const CNames& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Names methods
public:
	VARIANT _NewEnum()
	{
		VARIANT result;
		InvokeHelper(0x2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Add(VARIANT& Name, VARIANT& RefersTo, VARIANT& Visible, VARIANT& MacroType, VARIANT& ShortcutKey, VARIANT& Category, VARIANT& NameLocal, VARIANT& RefersToLocal, VARIANT& CategoryLocal, VARIANT& RefersToR1C1, VARIANT& RefersToR1C1Local)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xb5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Name, &RefersTo, &Visible, &MacroType, &ShortcutKey, &Category, &NameLocal, &RefersToLocal, &CategoryLocal, &RefersToR1C1, &RefersToR1C1Local);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Item(VARIANT& Index, VARIANT& IndexLocal, VARIANT& RefersTo)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xaa, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index, &IndexLocal, &RefersTo);
		return result;
	}

	// Names properties
public:
	VARIANT GetCount()
	{
		VARIANT result;
		GetProperty(0x76, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCount(VARIANT &propVal)
	{
		SetProperty(0x76, VT_VARIANT, &propVal);
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

};
