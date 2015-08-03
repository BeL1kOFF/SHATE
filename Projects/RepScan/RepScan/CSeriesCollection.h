// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CSeriesCollection wrapper class

class CSeriesCollection : public COleDispatchDriver
{
public:
	CSeriesCollection(){} // Calls COleDispatchDriver default constructor
	CSeriesCollection(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CSeriesCollection(const CSeriesCollection& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// SeriesCollection methods
public:
	VARIANT _NewEnum()
	{
		VARIANT result;
		InvokeHelper(0x2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Add(VARIANT& Source, VARIANT& Rowcol, VARIANT& SeriesLabels, VARIANT& CategoryLabels, VARIANT& Replace)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xb5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Source, &Rowcol, &SeriesLabels, &CategoryLabels, &Replace);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Extend(VARIANT& Source, VARIANT& Rowcol, VARIANT& CategoryLabels)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xe3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Source, &Rowcol, &CategoryLabels);
		return result;
	}
	VARIANT Item(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xaa, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Paste(VARIANT& Rowcol, VARIANT& SeriesLabels, VARIANT& CategoryLabels, VARIANT& Replace, VARIANT& NewSeries)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xd3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Rowcol, &SeriesLabels, &CategoryLabels, &Replace, &NewSeries);
		return result;
	}

	// SeriesCollection properties
public:
	VARIANT GetCount()
	{
		VARIANT result;
		GetProperty(0x76, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCount(VARIANT &propVal)
	{
		SetProperty(0x76, VT_VARIANT, &propVal);
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

};
