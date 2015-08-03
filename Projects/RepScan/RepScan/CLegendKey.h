// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CLegendKey wrapper class

class CLegendKey : public COleDispatchDriver
{
public:
	CLegendKey(){} // Calls COleDispatchDriver default constructor
	CLegendKey(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CLegendKey(const CLegendKey& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// LegendKey methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ClearFormats()
	{
		VARIANT result;
		InvokeHelper(0x70, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Delete()
	{
		VARIANT result;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Select()
	{
		VARIANT result;
		InvokeHelper(0xeb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// LegendKey properties
public:
	VARIANT GetBorder()
	{
		VARIANT result;
		GetProperty(0x80, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBorder(VARIANT &propVal)
	{
		SetProperty(0x80, VT_VARIANT, &propVal);
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
	VARIANT GetInterior()
	{
		VARIANT result;
		GetProperty(0x81, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetInterior(VARIANT &propVal)
	{
		SetProperty(0x81, VT_VARIANT, &propVal);
	}
	VARIANT GetInvertIfNegative()
	{
		VARIANT result;
		GetProperty(0x84, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetInvertIfNegative(VARIANT &propVal)
	{
		SetProperty(0x84, VT_VARIANT, &propVal);
	}
	VARIANT GetMarkerBackgroundColor()
	{
		VARIANT result;
		GetProperty(0x49, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMarkerBackgroundColor(VARIANT &propVal)
	{
		SetProperty(0x49, VT_VARIANT, &propVal);
	}
	VARIANT GetMarkerBackgroundColorIndex()
	{
		VARIANT result;
		GetProperty(0x4a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMarkerBackgroundColorIndex(VARIANT &propVal)
	{
		SetProperty(0x4a, VT_VARIANT, &propVal);
	}
	VARIANT GetMarkerForegroundColor()
	{
		VARIANT result;
		GetProperty(0x4b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMarkerForegroundColor(VARIANT &propVal)
	{
		SetProperty(0x4b, VT_VARIANT, &propVal);
	}
	VARIANT GetMarkerForegroundColorIndex()
	{
		VARIANT result;
		GetProperty(0x4c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMarkerForegroundColorIndex(VARIANT &propVal)
	{
		SetProperty(0x4c, VT_VARIANT, &propVal);
	}
	VARIANT GetMarkerStyle()
	{
		VARIANT result;
		GetProperty(0x48, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMarkerStyle(VARIANT &propVal)
	{
		SetProperty(0x48, VT_VARIANT, &propVal);
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
	VARIANT GetSmooth()
	{
		VARIANT result;
		GetProperty(0xa3, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSmooth(VARIANT &propVal)
	{
		SetProperty(0xa3, VT_VARIANT, &propVal);
	}

};
