// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CFloor wrapper class

class CFloor : public COleDispatchDriver
{
public:
	CFloor(){} // Calls COleDispatchDriver default constructor
	CFloor(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CFloor(const CFloor& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Floor methods
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
	VARIANT Select()
	{
		VARIANT result;
		InvokeHelper(0xeb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// Floor properties
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
