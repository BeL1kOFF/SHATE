// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CMenuItem wrapper class

class CMenuItem : public COleDispatchDriver
{
public:
	CMenuItem(){} // Calls COleDispatchDriver default constructor
	CMenuItem(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CMenuItem(const CMenuItem& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// MenuItem methods
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

	// MenuItem properties
public:
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
	VARIANT GetChecked()
	{
		VARIANT result;
		GetProperty(0x257, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetChecked(VARIANT &propVal)
	{
		SetProperty(0x257, VT_VARIANT, &propVal);
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
	VARIANT GetEnabled()
	{
		VARIANT result;
		GetProperty(0x258, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEnabled(VARIANT &propVal)
	{
		SetProperty(0x258, VT_VARIANT, &propVal);
	}
	VARIANT GetHelpContextID()
	{
		VARIANT result;
		GetProperty(0x163, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHelpContextID(VARIANT &propVal)
	{
		SetProperty(0x163, VT_VARIANT, &propVal);
	}
	VARIANT GetHelpFile()
	{
		VARIANT result;
		GetProperty(0x168, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHelpFile(VARIANT &propVal)
	{
		SetProperty(0x168, VT_VARIANT, &propVal);
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
	VARIANT GetOnAction()
	{
		VARIANT result;
		GetProperty(0x254, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnAction(VARIANT &propVal)
	{
		SetProperty(0x254, VT_VARIANT, &propVal);
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
	VARIANT GetStatusBar()
	{
		VARIANT result;
		GetProperty(0x182, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetStatusBar(VARIANT &propVal)
	{
		SetProperty(0x182, VT_VARIANT, &propVal);
	}

};
