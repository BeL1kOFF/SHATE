// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CPivotTable wrapper class

class CPivotTable : public COleDispatchDriver
{
public:
	CPivotTable(){} // Calls COleDispatchDriver default constructor
	CPivotTable(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CPivotTable(const CPivotTable& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// PivotTable methods
public:
	VARIANT AddFields(VARIANT& RowFields, VARIANT& ColumnFields, VARIANT& PageFields, VARIANT& AddToTable)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x2c4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &RowFields, &ColumnFields, &PageFields, &AddToTable);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT PivotFields(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x2ce, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT RefreshTable()
	{
		VARIANT result;
		InvokeHelper(0x2cd, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ShowPages(VARIANT& PageField)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x2c2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &PageField);
		return result;
	}

	// PivotTable properties
public:
	VARIANT GetColumnFields()
	{
		VARIANT result;
		GetProperty(0x2c9, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetColumnFields(VARIANT &propVal)
	{
		SetProperty(0x2c9, VT_VARIANT, &propVal);
	}
	VARIANT GetColumnGrand()
	{
		VARIANT result;
		GetProperty(0x2b6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetColumnGrand(VARIANT &propVal)
	{
		SetProperty(0x2b6, VT_VARIANT, &propVal);
	}
	VARIANT GetColumnRange()
	{
		VARIANT result;
		GetProperty(0x2be, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetColumnRange(VARIANT &propVal)
	{
		SetProperty(0x2be, VT_VARIANT, &propVal);
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
	VARIANT GetDataBodyRange()
	{
		VARIANT result;
		GetProperty(0x2c1, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDataBodyRange(VARIANT &propVal)
	{
		SetProperty(0x2c1, VT_VARIANT, &propVal);
	}
	VARIANT GetDataFields()
	{
		VARIANT result;
		GetProperty(0x2cb, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDataFields(VARIANT &propVal)
	{
		SetProperty(0x2cb, VT_VARIANT, &propVal);
	}
	VARIANT GetDataLabelRange()
	{
		VARIANT result;
		GetProperty(0x2c0, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDataLabelRange(VARIANT &propVal)
	{
		SetProperty(0x2c0, VT_VARIANT, &propVal);
	}
	VARIANT GetHasAutoFormat()
	{
		VARIANT result;
		GetProperty(0x2b7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasAutoFormat(VARIANT &propVal)
	{
		SetProperty(0x2b7, VT_VARIANT, &propVal);
	}
	VARIANT GetHiddenFields()
	{
		VARIANT result;
		GetProperty(0x2c7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHiddenFields(VARIANT &propVal)
	{
		SetProperty(0x2c7, VT_VARIANT, &propVal);
	}
	VARIANT GetInnerDetail()
	{
		VARIANT result;
		GetProperty(0x2ba, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetInnerDetail(VARIANT &propVal)
	{
		SetProperty(0x2ba, VT_VARIANT, &propVal);
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
	VARIANT GetPageFields()
	{
		VARIANT result;
		GetProperty(0x2ca, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPageFields(VARIANT &propVal)
	{
		SetProperty(0x2ca, VT_VARIANT, &propVal);
	}
	VARIANT GetPageRange()
	{
		VARIANT result;
		GetProperty(0x2bf, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPageRange(VARIANT &propVal)
	{
		SetProperty(0x2bf, VT_VARIANT, &propVal);
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
	VARIANT GetRefreshDate()
	{
		VARIANT result;
		GetProperty(0x2b8, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRefreshDate(VARIANT &propVal)
	{
		SetProperty(0x2b8, VT_VARIANT, &propVal);
	}
	VARIANT GetRefreshName()
	{
		VARIANT result;
		GetProperty(0x2b9, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRefreshName(VARIANT &propVal)
	{
		SetProperty(0x2b9, VT_VARIANT, &propVal);
	}
	VARIANT GetRowFields()
	{
		VARIANT result;
		GetProperty(0x2c8, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRowFields(VARIANT &propVal)
	{
		SetProperty(0x2c8, VT_VARIANT, &propVal);
	}
	VARIANT GetRowGrand()
	{
		VARIANT result;
		GetProperty(0x2b5, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRowGrand(VARIANT &propVal)
	{
		SetProperty(0x2b5, VT_VARIANT, &propVal);
	}
	VARIANT GetRowRange()
	{
		VARIANT result;
		GetProperty(0x2bd, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRowRange(VARIANT &propVal)
	{
		SetProperty(0x2bd, VT_VARIANT, &propVal);
	}
	VARIANT GetSaveData()
	{
		VARIANT result;
		GetProperty(0x2b4, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSaveData(VARIANT &propVal)
	{
		SetProperty(0x2b4, VT_VARIANT, &propVal);
	}
	VARIANT GetSourceData()
	{
		VARIANT result;
		GetProperty(0x2ae, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSourceData(VARIANT &propVal)
	{
		SetProperty(0x2ae, VT_VARIANT, &propVal);
	}
	VARIANT GetTableRange1()
	{
		VARIANT result;
		GetProperty(0x2bb, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTableRange1(VARIANT &propVal)
	{
		SetProperty(0x2bb, VT_VARIANT, &propVal);
	}
	VARIANT GetTableRange2()
	{
		VARIANT result;
		GetProperty(0x2bc, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTableRange2(VARIANT &propVal)
	{
		SetProperty(0x2bc, VT_VARIANT, &propVal);
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
	VARIANT GetVisibleFields()
	{
		VARIANT result;
		GetProperty(0x2c6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetVisibleFields(VARIANT &propVal)
	{
		SetProperty(0x2c6, VT_VARIANT, &propVal);
	}

};
