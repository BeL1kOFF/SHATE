// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CModule wrapper class

class CModule : public COleDispatchDriver
{
public:
	CModule(){} // Calls COleDispatchDriver default constructor
	CModule(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CModule(const CModule& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Module methods
public:
	VARIANT Activate()
	{
		VARIANT result;
		InvokeHelper(0x130, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Copy(VARIANT& Before, VARIANT& After)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x227, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Before, &After);
		return result;
	}
	VARIANT Delete()
	{
		VARIANT result;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT InsertFile(VARIANT& Filename, VARIANT& Merge)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x248, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename, &Merge);
		return result;
	}
	VARIANT Move(VARIANT& Before, VARIANT& After)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x27d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Before, &After);
		return result;
	}
	VARIANT PrintOut(VARIANT& From, VARIANT& To, VARIANT& Copies, VARIANT& Preview, VARIANT& ActivePrinter, VARIANT& PrintToFile, VARIANT& Collate)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x389, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &From, &To, &Copies, &Preview, &ActivePrinter, &PrintToFile, &Collate);
		return result;
	}
	VARIANT Protect(VARIANT& Password, VARIANT& DrawingObjects, VARIANT& Contents, VARIANT& Scenarios, VARIANT& UserInterfaceOnly)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x11a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Password, &DrawingObjects, &Contents, &Scenarios, &UserInterfaceOnly);
		return result;
	}
	VARIANT SaveAs(VARIANT& Filename, VARIANT& FileFormat, VARIANT& Password, VARIANT& WriteResPassword, VARIANT& ReadOnlyRecommended, VARIANT& CreateBackup)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x11c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename, &FileFormat, &Password, &WriteResPassword, &ReadOnlyRecommended, &CreateBackup);
		return result;
	}
	VARIANT Select(VARIANT& Replace)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xeb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Replace);
		return result;
	}
	VARIANT Unprotect(VARIANT& Password)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x11d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Password);
		return result;
	}

	// Module properties
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
	VARIANT GetNext()
	{
		VARIANT result;
		GetProperty(0x1f6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetNext(VARIANT &propVal)
	{
		SetProperty(0x1f6, VT_VARIANT, &propVal);
	}
	VARIANT GetOnDoubleClick()
	{
		VARIANT result;
		GetProperty(0x274, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnDoubleClick(VARIANT &propVal)
	{
		SetProperty(0x274, VT_VARIANT, &propVal);
	}
	VARIANT GetOnSheetActivate()
	{
		VARIANT result;
		GetProperty(0x407, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnSheetActivate(VARIANT &propVal)
	{
		SetProperty(0x407, VT_VARIANT, &propVal);
	}
	VARIANT GetOnSheetDeactivate()
	{
		VARIANT result;
		GetProperty(0x439, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnSheetDeactivate(VARIANT &propVal)
	{
		SetProperty(0x439, VT_VARIANT, &propVal);
	}
	VARIANT GetPageSetup()
	{
		VARIANT result;
		GetProperty(0x3e6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPageSetup(VARIANT &propVal)
	{
		SetProperty(0x3e6, VT_VARIANT, &propVal);
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
	VARIANT GetPrevious()
	{
		VARIANT result;
		GetProperty(0x1f7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrevious(VARIANT &propVal)
	{
		SetProperty(0x1f7, VT_VARIANT, &propVal);
	}
	VARIANT GetProtectContents()
	{
		VARIANT result;
		GetProperty(0x124, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetProtectContents(VARIANT &propVal)
	{
		SetProperty(0x124, VT_VARIANT, &propVal);
	}
	VARIANT GetProtectionMode()
	{
		VARIANT result;
		GetProperty(0x487, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetProtectionMode(VARIANT &propVal)
	{
		SetProperty(0x487, VT_VARIANT, &propVal);
	}
	VARIANT GetVisible()
	{
		VARIANT result;
		GetProperty(0x22e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetVisible(VARIANT &propVal)
	{
		SetProperty(0x22e, VT_VARIANT, &propVal);
	}

};
