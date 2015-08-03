// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CSeries wrapper class

class CSeries : public COleDispatchDriver
{
public:
	CSeries(){} // Calls COleDispatchDriver default constructor
	CSeries(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CSeries(const CSeries& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Series methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ApplyDataLabels(VARIANT& Type, VARIANT& LegendKey)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x97, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Type, &LegendKey);
		return result;
	}
	VARIANT ClearFormats()
	{
		VARIANT result;
		InvokeHelper(0x70, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Copy()
	{
		VARIANT result;
		InvokeHelper(0x227, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DataLabels(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x9d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Delete()
	{
		VARIANT result;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ErrorBar(VARIANT& Direction, VARIANT& Include, VARIANT& Type, VARIANT& Amount, VARIANT& MinusValues)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x98, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Direction, &Include, &Type, &Amount, &MinusValues);
		return result;
	}
	VARIANT Paste()
	{
		VARIANT result;
		InvokeHelper(0xd3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Points(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x46, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Select()
	{
		VARIANT result;
		InvokeHelper(0xeb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Trendlines(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x9a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}

	// Series properties
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
	VARIANT GetBorder()
	{
		VARIANT result;
		GetProperty(0x80, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBorder(VARIANT &propVal)
	{
		SetProperty(0x80, VT_VARIANT, &propVal);
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
	VARIANT GetErrorBars()
	{
		VARIANT result;
		GetProperty(0x9f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetErrorBars(VARIANT &propVal)
	{
		SetProperty(0x9f, VT_VARIANT, &propVal);
	}
	VARIANT GetExplosion()
	{
		VARIANT result;
		GetProperty(0xb6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetExplosion(VARIANT &propVal)
	{
		SetProperty(0xb6, VT_VARIANT, &propVal);
	}
	VARIANT GetFormula()
	{
		VARIANT result;
		GetProperty(0x105, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFormula(VARIANT &propVal)
	{
		SetProperty(0x105, VT_VARIANT, &propVal);
	}
	VARIANT GetFormulaLocal()
	{
		VARIANT result;
		GetProperty(0x107, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFormulaLocal(VARIANT &propVal)
	{
		SetProperty(0x107, VT_VARIANT, &propVal);
	}
	VARIANT GetFormulaR1C1()
	{
		VARIANT result;
		GetProperty(0x108, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFormulaR1C1(VARIANT &propVal)
	{
		SetProperty(0x108, VT_VARIANT, &propVal);
	}
	VARIANT GetFormulaR1C1Local()
	{
		VARIANT result;
		GetProperty(0x109, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFormulaR1C1Local(VARIANT &propVal)
	{
		SetProperty(0x109, VT_VARIANT, &propVal);
	}
	VARIANT GetHasDataLabels()
	{
		VARIANT result;
		GetProperty(0x4e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasDataLabels(VARIANT &propVal)
	{
		SetProperty(0x4e, VT_VARIANT, &propVal);
	}
	VARIANT GetHasErrorBars()
	{
		VARIANT result;
		GetProperty(0xa0, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasErrorBars(VARIANT &propVal)
	{
		SetProperty(0xa0, VT_VARIANT, &propVal);
	}
	VARIANT GetInterior()
	{
		VARIANT result;
		GetProperty(0x81, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetInterior(VARIANT &propVal)
	{
		SetProperty(0x81, VT_VARIANT, &propVal);
	}
	VARIANT GetInvertIfNegative()
	{
		VARIANT result;
		GetProperty(0x84, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetInvertIfNegative(VARIANT &propVal)
	{
		SetProperty(0x84, VT_VARIANT, &propVal);
	}
	VARIANT GetMarkerBackgroundColor()
	{
		VARIANT result;
		GetProperty(0x49, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMarkerBackgroundColor(VARIANT &propVal)
	{
		SetProperty(0x49, VT_VARIANT, &propVal);
	}
	VARIANT GetMarkerBackgroundColorIndex()
	{
		VARIANT result;
		GetProperty(0x4a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMarkerBackgroundColorIndex(VARIANT &propVal)
	{
		SetProperty(0x4a, VT_VARIANT, &propVal);
	}
	VARIANT GetMarkerForegroundColor()
	{
		VARIANT result;
		GetProperty(0x4b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMarkerForegroundColor(VARIANT &propVal)
	{
		SetProperty(0x4b, VT_VARIANT, &propVal);
	}
	VARIANT GetMarkerForegroundColorIndex()
	{
		VARIANT result;
		GetProperty(0x4c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMarkerForegroundColorIndex(VARIANT &propVal)
	{
		SetProperty(0x4c, VT_VARIANT, &propVal);
	}
	VARIANT GetMarkerStyle()
	{
		VARIANT result;
		GetProperty(0x48, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMarkerStyle(VARIANT &propVal)
	{
		SetProperty(0x48, VT_VARIANT, &propVal);
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
	VARIANT GetPictureType()
	{
		VARIANT result;
		GetProperty(0xa1, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPictureType(VARIANT &propVal)
	{
		SetProperty(0xa1, VT_VARIANT, &propVal);
	}
	VARIANT GetPictureUnit()
	{
		VARIANT result;
		GetProperty(0xa2, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPictureUnit(VARIANT &propVal)
	{
		SetProperty(0xa2, VT_VARIANT, &propVal);
	}
	VARIANT GetPlotOrder()
	{
		VARIANT result;
		GetProperty(0xe4, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPlotOrder(VARIANT &propVal)
	{
		SetProperty(0xe4, VT_VARIANT, &propVal);
	}
	VARIANT GetSmooth()
	{
		VARIANT result;
		GetProperty(0xa3, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSmooth(VARIANT &propVal)
	{
		SetProperty(0xa3, VT_VARIANT, &propVal);
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
	VARIANT GetXValues()
	{
		VARIANT result;
		GetProperty(0x457, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetXValues(VARIANT &propVal)
	{
		SetProperty(0x457, VT_VARIANT, &propVal);
	}

};
