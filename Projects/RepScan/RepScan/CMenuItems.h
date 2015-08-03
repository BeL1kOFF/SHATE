// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CMenuItems wrapper class

class CMenuItems : public COleDispatchDriver
{
public:
	CMenuItems(){} // Calls COleDispatchDriver default constructor
	CMenuItems(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CMenuItems(const CMenuItems& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// MenuItems methods
public:
	VARIANT _NewEnum()
	{
		VARIANT result;
		InvokeHelper(0x2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Add(VARIANT& Caption, VARIANT& OnAction, VARIANT& ShortcutKey, VARIANT& Before, VARIANT& Restore, VARIANT& StatusBar, VARIANT& HelpFile, VARIANT& HelpContextID)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xb5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Caption, &OnAction, &ShortcutKey, &Before, &Restore, &StatusBar, &HelpFile, &HelpContextID);
		return result;
	}
	VARIANT AddMenu(VARIANT& Caption, VARIANT& Before, VARIANT& Restore)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x256, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Caption, &Before, &Restore);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Item(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xaa, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}

	// MenuItems properties
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
