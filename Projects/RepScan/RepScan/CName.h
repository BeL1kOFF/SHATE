// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CName wrapper class

class CName : public COleDispatchDriver
{
public:
	CName(){} // Calls COleDispatchDriver default constructor
	CName(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CName(const CName& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Name methods
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

	// Name properties
public:
	VARIANT GetCategory()
	{
		VARIANT result;
		GetProperty(0x3a6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCategory(VARIANT &propVal)
	{
		SetProperty(0x3a6, VT_VARIANT, &propVal);
	}
	VARIANT GetCategoryLocal()
	{
		VARIANT result;
		GetProperty(0x3a7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCategoryLocal(VARIANT &propVal)
	{
		SetProperty(0x3a7, VT_VARIANT, &propVal);
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
	VARIANT GetMacroType()
	{
		VARIANT result;
		GetProperty(0x3a8, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMacroType(VARIANT &propVal)
	{
		SetProperty(0x3a8, VT_VARIANT, &propVal);
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
	VARIANT GetNameLocal()
	{
		VARIANT result;
		GetProperty(0x3a9, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetNameLocal(VARIANT &propVal)
	{
		SetProperty(0x3a9, VT_VARIANT, &propVal);
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
	VARIANT GetRefersTo()
	{
		VARIANT result;
		GetProperty(0x3aa, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRefersTo(VARIANT &propVal)
	{
		SetProperty(0x3aa, VT_VARIANT, &propVal);
	}
	VARIANT GetRefersToLocal()
	{
		VARIANT result;
		GetProperty(0x3ab, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRefersToLocal(VARIANT &propVal)
	{
		SetProperty(0x3ab, VT_VARIANT, &propVal);
	}
	VARIANT GetRefersToR1C1()
	{
		VARIANT result;
		GetProperty(0x3ac, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRefersToR1C1(VARIANT &propVal)
	{
		SetProperty(0x3ac, VT_VARIANT, &propVal);
	}
	VARIANT GetRefersToR1C1Local()
	{
		VARIANT result;
		GetProperty(0x3ad, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRefersToR1C1Local(VARIANT &propVal)
	{
		SetProperty(0x3ad, VT_VARIANT, &propVal);
	}
	VARIANT GetRefersToRange()
	{
		VARIANT result;
		GetProperty(0x488, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRefersToRange(VARIANT &propVal)
	{
		SetProperty(0x488, VT_VARIANT, &propVal);
	}
	VARIANT GetShortcutKey()
	{
		VARIANT result;
		GetProperty(0x255, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetShortcutKey(VARIANT &propVal)
	{
		SetProperty(0x255, VT_VARIANT, &propVal);
	}
	VARIANT GetValue()
	{
		VARIANT result;
		GetProperty(0x6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetValue(VARIANT &propVal)
	{
		SetProperty(0x6, VT_VARIANT, &propVal);
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
