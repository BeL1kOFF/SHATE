// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CToolbar wrapper class

class CToolbar : public COleDispatchDriver
{
public:
	CToolbar(){} // Calls COleDispatchDriver default constructor
	CToolbar(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CToolbar(const CToolbar& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Toolbar methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Delete()
	{
		VARIANT result;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Reset()
	{
		VARIANT result;
		InvokeHelper(0x22b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ToolbarButtons(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x3c4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}

	// Toolbar properties
public:
	VARIANT GetBuiltIn()
	{
		VARIANT result;
		GetProperty(0x229, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBuiltIn(VARIANT &propVal)
	{
		SetProperty(0x229, VT_VARIANT, &propVal);
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
	VARIANT GetName()
	{
		VARIANT result;
		GetProperty(0x6e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetName(VARIANT &propVal)
	{
		SetProperty(0x6e, VT_VARIANT, &propVal);
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
	VARIANT GetPosition()
	{
		VARIANT result;
		GetProperty(0x85, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPosition(VARIANT &propVal)
	{
		SetProperty(0x85, VT_VARIANT, &propVal);
	}
	VARIANT GetProtection()
	{
		VARIANT result;
		GetProperty(0xb0, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetProtection(VARIANT &propVal)
	{
		SetProperty(0xb0, VT_VARIANT, &propVal);
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

};
