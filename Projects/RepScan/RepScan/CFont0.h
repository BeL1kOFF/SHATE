// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CFont0 wrapper class

class CFont0 : public COleDispatchDriver
{
public:
	CFont0(){} // Calls COleDispatchDriver default constructor
	CFont0(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CFont0(const CFont0& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Font methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// Font properties
public:
	VARIANT GetBackground()
	{
		VARIANT result;
		GetProperty(0xb4, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBackground(VARIANT &propVal)
	{
		SetProperty(0xb4, VT_VARIANT, &propVal);
	}
	VARIANT GetBold()
	{
		VARIANT result;
		GetProperty(0x60, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBold(VARIANT &propVal)
	{
		SetProperty(0x60, VT_VARIANT, &propVal);
	}
	VARIANT GetColor()
	{
		VARIANT result;
		GetProperty(0x63, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetColor(VARIANT &propVal)
	{
		SetProperty(0x63, VT_VARIANT, &propVal);
	}
	VARIANT GetColorIndex()
	{
		VARIANT result;
		GetProperty(0x61, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetColorIndex(VARIANT &propVal)
	{
		SetProperty(0x61, VT_VARIANT, &propVal);
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
	VARIANT GetFontStyle()
	{
		VARIANT result;
		GetProperty(0xb1, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFontStyle(VARIANT &propVal)
	{
		SetProperty(0xb1, VT_VARIANT, &propVal);
	}
	VARIANT GetItalic()
	{
		VARIANT result;
		GetProperty(0x65, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetItalic(VARIANT &propVal)
	{
		SetProperty(0x65, VT_VARIANT, &propVal);
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
	VARIANT GetOutlineFont()
	{
		VARIANT result;
		GetProperty(0xdd, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOutlineFont(VARIANT &propVal)
	{
		SetProperty(0xdd, VT_VARIANT, &propVal);
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
	VARIANT GetShadow()
	{
		VARIANT result;
		GetProperty(0x67, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetShadow(VARIANT &propVal)
	{
		SetProperty(0x67, VT_VARIANT, &propVal);
	}
	VARIANT GetSize()
	{
		VARIANT result;
		GetProperty(0x68, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSize(VARIANT &propVal)
	{
		SetProperty(0x68, VT_VARIANT, &propVal);
	}
	VARIANT GetStrikethrough()
	{
		VARIANT result;
		GetProperty(0x69, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetStrikethrough(VARIANT &propVal)
	{
		SetProperty(0x69, VT_VARIANT, &propVal);
	}
	VARIANT GetSubscript()
	{
		VARIANT result;
		GetProperty(0xb3, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSubscript(VARIANT &propVal)
	{
		SetProperty(0xb3, VT_VARIANT, &propVal);
	}
	VARIANT GetSuperscript()
	{
		VARIANT result;
		GetProperty(0xb2, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSuperscript(VARIANT &propVal)
	{
		SetProperty(0xb2, VT_VARIANT, &propVal);
	}
	VARIANT GetUnderline()
	{
		VARIANT result;
		GetProperty(0x6a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetUnderline(VARIANT &propVal)
	{
		SetProperty(0x6a, VT_VARIANT, &propVal);
	}

};
