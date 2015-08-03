// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CScenario wrapper class

class CScenario : public COleDispatchDriver
{
public:
	CScenario(){} // Calls COleDispatchDriver default constructor
	CScenario(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CScenario(const CScenario& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Scenario methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ChangeScenario(VARIANT& ChangingCells, VARIANT& Values)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x390, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &ChangingCells, &Values);
		return result;
	}
	VARIANT Delete()
	{
		VARIANT result;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Show()
	{
		VARIANT result;
		InvokeHelper(0x1f0, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// Scenario properties
public:
	VARIANT GetChangingCells()
	{
		VARIANT result;
		GetProperty(0x38f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetChangingCells(VARIANT &propVal)
	{
		SetProperty(0x38f, VT_VARIANT, &propVal);
	}
	VARIANT GetComment()
	{
		VARIANT result;
		GetProperty(0x38e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetComment(VARIANT &propVal)
	{
		SetProperty(0x38e, VT_VARIANT, &propVal);
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
	VARIANT GetHidden()
	{
		VARIANT result;
		GetProperty(0x10c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHidden(VARIANT &propVal)
	{
		SetProperty(0x10c, VT_VARIANT, &propVal);
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
	VARIANT GetLocked()
	{
		VARIANT result;
		GetProperty(0x10d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLocked(VARIANT &propVal)
	{
		SetProperty(0x10d, VT_VARIANT, &propVal);
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
	VARIANT GetValues()
	{
		VARIANT result;
		GetProperty(0xa4, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetValues(VARIANT &propVal)
	{
		SetProperty(0xa4, VT_VARIANT, &propVal);
	}

};
