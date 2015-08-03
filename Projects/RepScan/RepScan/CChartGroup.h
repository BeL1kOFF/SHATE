// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CChartGroup wrapper class

class CChartGroup : public COleDispatchDriver
{
public:
	CChartGroup(){} // Calls COleDispatchDriver default constructor
	CChartGroup(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CChartGroup(const CChartGroup& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// ChartGroup methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT SeriesCollection(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x44, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}

	// ChartGroup properties
public:
	VARIANT GetAxisGroup()
	{
		VARIANT result;
		GetProperty(0x2f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAxisGroup(VARIANT &propVal)
	{
		SetProperty(0x2f, VT_VARIANT, &propVal);
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
	VARIANT GetDoughnutHoleSize()
	{
		VARIANT result;
		GetProperty(0x466, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDoughnutHoleSize(VARIANT &propVal)
	{
		SetProperty(0x466, VT_VARIANT, &propVal);
	}
	VARIANT GetDownBars()
	{
		VARIANT result;
		GetProperty(0x8d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDownBars(VARIANT &propVal)
	{
		SetProperty(0x8d, VT_VARIANT, &propVal);
	}
	VARIANT GetDropLines()
	{
		VARIANT result;
		GetProperty(0x8e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDropLines(VARIANT &propVal)
	{
		SetProperty(0x8e, VT_VARIANT, &propVal);
	}
	VARIANT GetFirstSliceAngle()
	{
		VARIANT result;
		GetProperty(0x3f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFirstSliceAngle(VARIANT &propVal)
	{
		SetProperty(0x3f, VT_VARIANT, &propVal);
	}
	VARIANT GetGapWidth()
	{
		VARIANT result;
		GetProperty(0x33, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetGapWidth(VARIANT &propVal)
	{
		SetProperty(0x33, VT_VARIANT, &propVal);
	}
	VARIANT GetHasDropLines()
	{
		VARIANT result;
		GetProperty(0x3d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasDropLines(VARIANT &propVal)
	{
		SetProperty(0x3d, VT_VARIANT, &propVal);
	}
	VARIANT GetHasHiLoLines()
	{
		VARIANT result;
		GetProperty(0x3e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasHiLoLines(VARIANT &propVal)
	{
		SetProperty(0x3e, VT_VARIANT, &propVal);
	}
	VARIANT GetHasRadarAxisLabels()
	{
		VARIANT result;
		GetProperty(0x40, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasRadarAxisLabels(VARIANT &propVal)
	{
		SetProperty(0x40, VT_VARIANT, &propVal);
	}
	VARIANT GetHasSeriesLines()
	{
		VARIANT result;
		GetProperty(0x41, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasSeriesLines(VARIANT &propVal)
	{
		SetProperty(0x41, VT_VARIANT, &propVal);
	}
	VARIANT GetHasUpDownBars()
	{
		VARIANT result;
		GetProperty(0x42, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasUpDownBars(VARIANT &propVal)
	{
		SetProperty(0x42, VT_VARIANT, &propVal);
	}
	VARIANT GetHiLoLines()
	{
		VARIANT result;
		GetProperty(0x8f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHiLoLines(VARIANT &propVal)
	{
		SetProperty(0x8f, VT_VARIANT, &propVal);
	}
	VARIANT GetOverlap()
	{
		VARIANT result;
		GetProperty(0x38, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOverlap(VARIANT &propVal)
	{
		SetProperty(0x38, VT_VARIANT, &propVal);
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
	VARIANT GetRadarAxisLabels()
	{
		VARIANT result;
		GetProperty(0x90, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRadarAxisLabels(VARIANT &propVal)
	{
		SetProperty(0x90, VT_VARIANT, &propVal);
	}
	VARIANT GetSeriesLines()
	{
		VARIANT result;
		GetProperty(0x91, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSeriesLines(VARIANT &propVal)
	{
		SetProperty(0x91, VT_VARIANT, &propVal);
	}
	VARIANT GetSubType()
	{
		VARIANT result;
		GetProperty(0x6d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSubType(VARIANT &propVal)
	{
		SetProperty(0x6d, VT_VARIANT, &propVal);
	}
	VARIANT GetType()
	{
		VARIANT result;
		GetProperty(0x6c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetType(VARIANT &propVal)
	{
		SetProperty(0x6c, VT_VARIANT, &propVal);
	}
	VARIANT GetUpBars()
	{
		VARIANT result;
		GetProperty(0x8c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetUpBars(VARIANT &propVal)
	{
		SetProperty(0x8c, VT_VARIANT, &propVal);
	}
	VARIANT GetVaryByCategories()
	{
		VARIANT result;
		GetProperty(0x3c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetVaryByCategories(VARIANT &propVal)
	{
		SetProperty(0x3c, VT_VARIANT, &propVal);
	}

};
