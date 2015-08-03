// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CAutoCorrect wrapper class

class CAutoCorrect : public COleDispatchDriver
{
public:
	CAutoCorrect(){} // Calls COleDispatchDriver default constructor
	CAutoCorrect(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CAutoCorrect(const CAutoCorrect& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// AutoCorrect methods
public:
	VARIANT AddReplacement(VARIANT& What, VARIANT& Replacement)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x47a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &What, &Replacement);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DeleteReplacement(VARIANT& What)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x47b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &What);
		return result;
	}

	// AutoCorrect properties
public:
	VARIANT GetCapitalizeNamesOfDays()
	{
		VARIANT result;
		GetProperty(0x47e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCapitalizeNamesOfDays(VARIANT &propVal)
	{
		SetProperty(0x47e, VT_VARIANT, &propVal);
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
	VARIANT GetReplacementList()
	{
		VARIANT result;
		GetProperty(0x47f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetReplacementList(VARIANT &propVal)
	{
		SetProperty(0x47f, VT_VARIANT, &propVal);
	}
	VARIANT GetReplaceText()
	{
		VARIANT result;
		GetProperty(0x47c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetReplaceText(VARIANT &propVal)
	{
		SetProperty(0x47c, VT_VARIANT, &propVal);
	}
	VARIANT GetTwoInitialCapitals()
	{
		VARIANT result;
		GetProperty(0x47d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTwoInitialCapitals(VARIANT &propVal)
	{
		SetProperty(0x47d, VT_VARIANT, &propVal);
	}

};
