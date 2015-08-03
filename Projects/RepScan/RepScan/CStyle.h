// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CStyle wrapper class

class CStyle : public COleDispatchDriver
{
public:
	CStyle(){} // Calls COleDispatchDriver default constructor
	CStyle(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CStyle(const CStyle& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Style methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Borders(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1b3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Delete()
	{
		VARIANT result;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// Style properties
public:
	VARIANT GetAddIndent()
	{
		VARIANT result;
		GetProperty(0x427, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAddIndent(VARIANT &propVal)
	{
		SetProperty(0x427, VT_VARIANT, &propVal);
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
	VARIANT GetFont()
	{
		VARIANT result;
		GetProperty(0x92, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFont(VARIANT &propVal)
	{
		SetProperty(0x92, VT_VARIANT, &propVal);
	}
	VARIANT GetFormulaHidden()
	{
		VARIANT result;
		GetProperty(0x106, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFormulaHidden(VARIANT &propVal)
	{
		SetProperty(0x106, VT_VARIANT, &propVal);
	}
	VARIANT GetHorizontalAlignment()
	{
		VARIANT result;
		GetProperty(0x88, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHorizontalAlignment(VARIANT &propVal)
	{
		SetProperty(0x88, VT_VARIANT, &propVal);
	}
	VARIANT GetIncludeAlignment()
	{
		VARIANT result;
		GetProperty(0x19d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetIncludeAlignment(VARIANT &propVal)
	{
		SetProperty(0x19d, VT_VARIANT, &propVal);
	}
	VARIANT GetIncludeBorder()
	{
		VARIANT result;
		GetProperty(0x19e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetIncludeBorder(VARIANT &propVal)
	{
		SetProperty(0x19e, VT_VARIANT, &propVal);
	}
	VARIANT GetIncludeFont()
	{
		VARIANT result;
		GetProperty(0x19f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetIncludeFont(VARIANT &propVal)
	{
		SetProperty(0x19f, VT_VARIANT, &propVal);
	}
	VARIANT GetIncludeNumber()
	{
		VARIANT result;
		GetProperty(0x1a0, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetIncludeNumber(VARIANT &propVal)
	{
		SetProperty(0x1a0, VT_VARIANT, &propVal);
	}
	VARIANT GetIncludePatterns()
	{
		VARIANT result;
		GetProperty(0x1a1, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetIncludePatterns(VARIANT &propVal)
	{
		SetProperty(0x1a1, VT_VARIANT, &propVal);
	}
	VARIANT GetIncludeProtection()
	{
		VARIANT result;
		GetProperty(0x1a2, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetIncludeProtection(VARIANT &propVal)
	{
		SetProperty(0x1a2, VT_VARIANT, &propVal);
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
	VARIANT GetLocked()
	{
		VARIANT result;
		GetProperty(0x10d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLocked(VARIANT &propVal)
	{
		SetProperty(0x10d, VT_VARIANT, &propVal);
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
	VARIANT GetNumberFormatLocal()
	{
		VARIANT result;
		GetProperty(0x449, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetNumberFormatLocal(VARIANT &propVal)
	{
		SetProperty(0x449, VT_VARIANT, &propVal);
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
	VARIANT GetVerticalAlignment()
	{
		VARIANT result;
		GetProperty(0x89, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetVerticalAlignment(VARIANT &propVal)
	{
		SetProperty(0x89, VT_VARIANT, &propVal);
	}
	VARIANT GetWrapText()
	{
		VARIANT result;
		GetProperty(0x114, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWrapText(VARIANT &propVal)
	{
		SetProperty(0x114, VT_VARIANT, &propVal);
	}

};
