// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// Cnterior wrapper class

class Cnterior : public COleDispatchDriver
{
public:
	Cnterior(){} // Calls COleDispatchDriver default constructor
	Cnterior(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	Cnterior(const Cnterior& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Interior methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// Interior properties
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
	VARIANT GetPattern()
	{
		VARIANT result;
		GetProperty(0x5f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPattern(VARIANT &propVal)
	{
		SetProperty(0x5f, VT_VARIANT, &propVal);
	}
	VARIANT GetPatternColor()
	{
		VARIANT result;
		GetProperty(0x64, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPatternColor(VARIANT &propVal)
	{
		SetProperty(0x64, VT_VARIANT, &propVal);
	}
	VARIANT GetPatternColorIndex()
	{
		VARIANT result;
		GetProperty(0x62, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPatternColorIndex(VARIANT &propVal)
	{
		SetProperty(0x62, VT_VARIANT, &propVal);
	}

};
