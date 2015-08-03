// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CToolbarButton wrapper class

class CToolbarButton : public COleDispatchDriver
{
public:
	CToolbarButton(){} // Calls COleDispatchDriver default constructor
	CToolbarButton(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CToolbarButton(const CToolbarButton& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// ToolbarButton methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Copy(VARIANT& Toolbar, VARIANT& Before)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x227, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Toolbar, &Before);
		return result;
	}
	VARIANT CopyFace()
	{
		VARIANT result;
		InvokeHelper(0x3c6, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Delete()
	{
		VARIANT result;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Edit()
	{
		VARIANT result;
		InvokeHelper(0x232, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Move(VARIANT& Toolbar, VARIANT& Before)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x27d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Toolbar, &Before);
		return result;
	}
	VARIANT PasteFace()
	{
		VARIANT result;
		InvokeHelper(0x3c7, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Reset()
	{
		VARIANT result;
		InvokeHelper(0x22b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// ToolbarButton properties
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
	VARIANT GetBuiltInFace()
	{
		VARIANT result;
		GetProperty(0x22a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBuiltInFace(VARIANT &propVal)
	{
		SetProperty(0x22a, VT_VARIANT, &propVal);
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
	VARIANT GetId()
	{
		VARIANT result;
		GetProperty(0x23a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetId(VARIANT &propVal)
	{
		SetProperty(0x23a, VT_VARIANT, &propVal);
	}
	VARIANT GetIsGap()
	{
		VARIANT result;
		GetProperty(0x231, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetIsGap(VARIANT &propVal)
	{
		SetProperty(0x231, VT_VARIANT, &propVal);
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
	VARIANT GetPushed()
	{
		VARIANT result;
		GetProperty(0x230, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPushed(VARIANT &propVal)
	{
		SetProperty(0x230, VT_VARIANT, &propVal);
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
