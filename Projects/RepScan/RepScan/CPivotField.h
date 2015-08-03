// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CPivotField wrapper class

class CPivotField : public COleDispatchDriver
{
public:
	CPivotField(){} // Calls COleDispatchDriver default constructor
	CPivotField(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CPivotField(const CPivotField& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// PivotField methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT PivotItems(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x2e1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}

	// PivotField properties
public:
	VARIANT GetBaseField()
	{
		VARIANT result;
		GetProperty(0x2de, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBaseField(VARIANT &propVal)
	{
		SetProperty(0x2de, VT_VARIANT, &propVal);
	}
	VARIANT GetBaseItem()
	{
		VARIANT result;
		GetProperty(0x2df, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBaseItem(VARIANT &propVal)
	{
		SetProperty(0x2df, VT_VARIANT, &propVal);
	}
	VARIANT GetCalculation()
	{
		VARIANT result;
		GetProperty(0x13c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCalculation(VARIANT &propVal)
	{
		SetProperty(0x13c, VT_VARIANT, &propVal);
	}
	VARIANT GetChildField()
	{
		VARIANT result;
		GetProperty(0x2e0, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetChildField(VARIANT &propVal)
	{
		SetProperty(0x2e0, VT_VARIANT, &propVal);
	}
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
	VARIANT GetCurrentPage()
	{
		VARIANT result;
		GetProperty(0x2e2, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCurrentPage(VARIANT &propVal)
	{
		SetProperty(0x2e2, VT_VARIANT, &propVal);
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
	VARIANT GetDataType()
	{
		VARIANT result;
		GetProperty(0x2d2, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDataType(VARIANT &propVal)
	{
		SetProperty(0x2d2, VT_VARIANT, &propVal);
	}
	VARIANT GetFunction()
	{
		VARIANT result;
		GetProperty(0x383, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFunction(VARIANT &propVal)
	{
		SetProperty(0x383, VT_VARIANT, &propVal);
	}
	VARIANT GetGroupLevel()
	{
		VARIANT result;
		GetProperty(0x2d3, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetGroupLevel(VARIANT &propVal)
	{
		SetProperty(0x2d3, VT_VARIANT, &propVal);
	}
	VARIANT GetHiddenItems()
	{
		VARIANT result;
		GetProperty(0x2d8, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHiddenItems(VARIANT &propVal)
	{
		SetProperty(0x2d8, VT_VARIANT, &propVal);
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
	VARIANT GetParentField()
	{
		VARIANT result;
		GetProperty(0x2dc, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetParentField(VARIANT &propVal)
	{
		SetProperty(0x2dc, VT_VARIANT, &propVal);
	}
	VARIANT GetParentItems()
	{
		VARIANT result;
		GetProperty(0x2d9, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetParentItems(VARIANT &propVal)
	{
		SetProperty(0x2d9, VT_VARIANT, &propVal);
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
	VARIANT GetSubtotals()
	{
		VARIANT result;
		GetProperty(0x2dd, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSubtotals(VARIANT &propVal)
	{
		SetProperty(0x2dd, VT_VARIANT, &propVal);
	}
	VARIANT GetTotalLevels()
	{
		VARIANT result;
		GetProperty(0x2d4, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTotalLevels(VARIANT &propVal)
	{
		SetProperty(0x2d4, VT_VARIANT, &propVal);
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
	VARIANT GetVisibleItems()
	{
		VARIANT result;
		GetProperty(0x2d7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetVisibleItems(VARIANT &propVal)
	{
		SetProperty(0x2d7, VT_VARIANT, &propVal);
	}

};
