// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CTrendline wrapper class

class CTrendline : public COleDispatchDriver
{
public:
	CTrendline(){} // Calls COleDispatchDriver default constructor
	CTrendline(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CTrendline(const CTrendline& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Trendline methods
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

	// Trendline properties
public:
	VARIANT GetBackward()
	{
		VARIANT result;
		GetProperty(0xb9, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBackward(VARIANT &propVal)
	{
		SetProperty(0xb9, VT_VARIANT, &propVal);
	}
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
	VARIANT GetDataLabel()
	{
		VARIANT result;
		GetProperty(0x9e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDataLabel(VARIANT &propVal)
	{
		SetProperty(0x9e, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayEquation()
	{
		VARIANT result;
		GetProperty(0xbe, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayEquation(VARIANT &propVal)
	{
		SetProperty(0xbe, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayRSquared()
	{
		VARIANT result;
		GetProperty(0xbd, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayRSquared(VARIANT &propVal)
	{
		SetProperty(0xbd, VT_VARIANT, &propVal);
	}
	VARIANT GetForward()
	{
		VARIANT result;
		GetProperty(0xbf, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetForward(VARIANT &propVal)
	{
		SetProperty(0xbf, VT_VARIANT, &propVal);
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
	VARIANT GetIntercept()
	{
		VARIANT result;
		GetProperty(0xba, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetIntercept(VARIANT &propVal)
	{
		SetProperty(0xba, VT_VARIANT, &propVal);
	}
	VARIANT GetInterceptIsAuto()
	{
		VARIANT result;
		GetProperty(0xbb, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetInterceptIsAuto(VARIANT &propVal)
	{
		SetProperty(0xbb, VT_VARIANT, &propVal);
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
	VARIANT GetNameIsAuto()
	{
		VARIANT result;
		GetProperty(0xbc, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetNameIsAuto(VARIANT &propVal)
	{
		SetProperty(0xbc, VT_VARIANT, &propVal);
	}
	VARIANT GetOrder()
	{
		VARIANT result;
		GetProperty(0xc0, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOrder(VARIANT &propVal)
	{
		SetProperty(0xc0, VT_VARIANT, &propVal);
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
	VARIANT GetPeriod()
	{
		VARIANT result;
		GetProperty(0xb8, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPeriod(VARIANT &propVal)
	{
		SetProperty(0xb8, VT_VARIANT, &propVal);
	}
	VARIANT GetType()
	{
		VARIANT result;
		GetProperty(0x6c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetType(VARIANT &propVal)
	{
		SetProperty(0x6c, VT_VARIANT, &propVal);
	}

};
