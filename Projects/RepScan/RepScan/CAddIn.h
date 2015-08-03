// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CAddIn wrapper class

class CAddIn : public COleDispatchDriver
{
public:
	CAddIn(){} // Calls COleDispatchDriver default constructor
	CAddIn(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CAddIn(const CAddIn& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// AddIn methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// AddIn properties
public:
	VARIANT GetAuthor()
	{
		VARIANT result;
		GetProperty(0x23e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAuthor(VARIANT &propVal)
	{
		SetProperty(0x23e, VT_VARIANT, &propVal);
	}
	VARIANT GetComments()
	{
		VARIANT result;
		GetProperty(0x23f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetComments(VARIANT &propVal)
	{
		SetProperty(0x23f, VT_VARIANT, &propVal);
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
	VARIANT GetFullName()
	{
		VARIANT result;
		GetProperty(0x121, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFullName(VARIANT &propVal)
	{
		SetProperty(0x121, VT_VARIANT, &propVal);
	}
	VARIANT GetInstalled()
	{
		VARIANT result;
		GetProperty(0x226, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetInstalled(VARIANT &propVal)
	{
		SetProperty(0x226, VT_VARIANT, &propVal);
	}
	VARIANT GetKeywords()
	{
		VARIANT result;
		GetProperty(0x241, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetKeywords(VARIANT &propVal)
	{
		SetProperty(0x241, VT_VARIANT, &propVal);
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
	VARIANT GetPath()
	{
		VARIANT result;
		GetProperty(0x123, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPath(VARIANT &propVal)
	{
		SetProperty(0x123, VT_VARIANT, &propVal);
	}
	VARIANT GetSubject()
	{
		VARIANT result;
		GetProperty(0x3b9, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSubject(VARIANT &propVal)
	{
		SetProperty(0x3b9, VT_VARIANT, &propVal);
	}
	VARIANT GetTitle()
	{
		VARIANT result;
		GetProperty(0xc7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTitle(VARIANT &propVal)
	{
		SetProperty(0xc7, VT_VARIANT, &propVal);
	}

};
