// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CPoint0 wrapper class

class CPoint0 : public COleDispatchDriver
{
public:
	CPoint0(){} // Calls COleDispatchDriver default constructor
	CPoint0(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CPoint0(const CPoint0& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Point methods
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
	VARIANT Delete()
	{
		VARIANT result;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Paste()
	{
		VARIANT result;
		InvokeHelper(0xd3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Select()
	{
		VARIANT result;
		InvokeHelper(0xeb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// Point properties
public:
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
	VARIANT GetDataLabel()
	{
		VARIANT result;
		GetProperty(0x9e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDataLabel(VARIANT &propVal)
	{
		SetProperty(0x9e, VT_VARIANT, &propVal);
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
	VARIANT GetHasDataLabel()
	{
		VARIANT result;
		GetProperty(0x4d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasDataLabel(VARIANT &propVal)
	{
		SetProperty(0x4d, VT_VARIANT, &propVal);
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

};
