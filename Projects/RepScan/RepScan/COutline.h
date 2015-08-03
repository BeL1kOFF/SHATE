// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// COutline wrapper class

class COutline : public COleDispatchDriver
{
public:
	COutline(){} // Calls COleDispatchDriver default constructor
	COutline(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	COutline(const COutline& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Outline methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ShowLevels(VARIANT& RowLevels, VARIANT& ColumnLevels)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x3c0, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &RowLevels, &ColumnLevels);
		return result;
	}

	// Outline properties
public:
	VARIANT GetAutomaticStyles()
	{
		VARIANT result;
		GetProperty(0x3bf, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAutomaticStyles(VARIANT &propVal)
	{
		SetProperty(0x3bf, VT_VARIANT, &propVal);
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
	VARIANT GetSummaryColumn()
	{
		VARIANT result;
		GetProperty(0x3c1, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSummaryColumn(VARIANT &propVal)
	{
		SetProperty(0x3c1, VT_VARIANT, &propVal);
	}
	VARIANT GetSummaryRow()
	{
		VARIANT result;
		GetProperty(0x386, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSummaryRow(VARIANT &propVal)
	{
		SetProperty(0x386, VT_VARIANT, &propVal);
	}

};
