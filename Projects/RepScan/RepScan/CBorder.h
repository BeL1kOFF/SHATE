// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CBorder wrapper class

class CBorder : public COleDispatchDriver
{
public:
	CBorder(){} // Calls COleDispatchDriver default constructor
	CBorder(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CBorder(const CBorder& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Border methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// Border properties
public:
	VARIANT GetColor()
	{
		VARIANT result;
		GetProperty(0x63, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetColor(VARIANT &propVal)
	{
		SetProperty(0x63, VT_VARIANT, &propVal);
	}
	VARIANT GetColorIndex()
	{
		VARIANT result;
		GetProperty(0x61, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetColorIndex(VARIANT &propVal)
	{
		SetProperty(0x61, VT_VARIANT, &propVal);
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
	VARIANT GetLineStyle()
	{
		VARIANT result;
		GetProperty(0x77, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLineStyle(VARIANT &propVal)
	{
		SetProperty(0x77, VT_VARIANT, &propVal);
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
	VARIANT GetWeight()
	{
		VARIANT result;
		GetProperty(0x78, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWeight(VARIANT &propVal)
	{
		SetProperty(0x78, VT_VARIANT, &propVal);
	}

};
