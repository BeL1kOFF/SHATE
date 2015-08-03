// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CTickLabels wrapper class

class CTickLabels : public COleDispatchDriver
{
public:
	CTickLabels(){} // Calls COleDispatchDriver default constructor
	CTickLabels(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CTickLabels(const CTickLabels& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// TickLabels methods
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

	// TickLabels properties
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
	VARIANT GetFont()
	{
		VARIANT result;
		GetProperty(0x92, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFont(VARIANT &propVal)
	{
		SetProperty(0x92, VT_VARIANT, &propVal);
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
	VARIANT GetNumberFormat()
	{
		VARIANT result;
		GetProperty(0xc1, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetNumberFormat(VARIANT &propVal)
	{
		SetProperty(0xc1, VT_VARIANT, &propVal);
	}
	VARIANT GetNumberFormatLinked()
	{
		VARIANT result;
		GetProperty(0xc2, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetNumberFormatLinked(VARIANT &propVal)
	{
		SetProperty(0xc2, VT_VARIANT, &propVal);
	}
	VARIANT GetOrientation()
	{
		VARIANT result;
		GetProperty(0x86, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOrientation(VARIANT &propVal)
	{
		SetProperty(0x86, VT_VARIANT, &propVal);
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
