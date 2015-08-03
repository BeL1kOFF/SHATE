// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CPivotItem wrapper class

class CPivotItem : public COleDispatchDriver
{
public:
	CPivotItem(){} // Calls COleDispatchDriver default constructor
	CPivotItem(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CPivotItem(const CPivotItem& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// PivotItem methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// PivotItem properties
public:
	VARIANT GetChildItems()
	{
		VARIANT result;
		GetProperty(0x2da, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetChildItems(VARIANT &propVal)
	{
		SetProperty(0x2da, VT_VARIANT, &propVal);
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
	VARIANT GetDataRange()
	{
		VARIANT result;
		GetProperty(0x2d0, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDataRange(VARIANT &propVal)
	{
		SetProperty(0x2d0, VT_VARIANT, &propVal);
	}
	VARIANT GetLabelRange()
	{
		VARIANT result;
		GetProperty(0x2cf, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLabelRange(VARIANT &propVal)
	{
		SetProperty(0x2cf, VT_VARIANT, &propVal);
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
	VARIANT GetParentItem()
	{
		VARIANT result;
		GetProperty(0x2e5, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetParentItem(VARIANT &propVal)
	{
		SetProperty(0x2e5, VT_VARIANT, &propVal);
	}
	VARIANT GetParentShowDetail()
	{
		VARIANT result;
		GetProperty(0x2e3, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetParentShowDetail(VARIANT &propVal)
	{
		SetProperty(0x2e3, VT_VARIANT, &propVal);
	}
	VARIANT GetPosition()
	{
		VARIANT result;
		GetProperty(0x85, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPosition(VARIANT &propVal)
	{
		SetProperty(0x85, VT_VARIANT, &propVal);
	}
	VARIANT GetShowDetail()
	{
		VARIANT result;
		GetProperty(0x249, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetShowDetail(VARIANT &propVal)
	{
		SetProperty(0x249, VT_VARIANT, &propVal);
	}
	VARIANT GetSourceName()
	{
		VARIANT result;
		GetProperty(0x2d1, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSourceName(VARIANT &propVal)
	{
		SetProperty(0x2d1, VT_VARIANT, &propVal);
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
