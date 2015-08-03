// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CBorders wrapper class

class CBorders : public COleDispatchDriver
{
public:
	CBorders(){} // Calls COleDispatchDriver default constructor
	CBorders(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CBorders(const CBorders& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Borders methods
public:
	VARIANT _NewEnum()
	{
		VARIANT result;
		InvokeHelper(0x2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
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

	// Borders properties
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
	VARIANT GetValue()
	{
		VARIANT result;
		GetProperty(0x6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetValue(VARIANT &propVal)
	{
		SetProperty(0x6, VT_VARIANT, &propVal);
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
