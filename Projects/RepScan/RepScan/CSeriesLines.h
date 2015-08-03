// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CSeriesLines wrapper class

class CSeriesLines : public COleDispatchDriver
{
public:
	CSeriesLines(){} // Calls COleDispatchDriver default constructor
	CSeriesLines(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CSeriesLines(const CSeriesLines& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// SeriesLines methods
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
	VARIANT Select()
	{
		VARIANT result;
		InvokeHelper(0xeb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// SeriesLines properties
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

};
