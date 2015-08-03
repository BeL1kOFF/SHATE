// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CWorkbooks wrapper class

class CWorkbooks : public COleDispatchDriver
{
public:
	CWorkbooks(){} // Calls COleDispatchDriver default constructor
	CWorkbooks(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CWorkbooks(const CWorkbooks& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Workbooks methods
public:
	VARIANT _NewEnum()
	{
		VARIANT result;
		InvokeHelper(0x2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Add(VARIANT& Template)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xb5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Template);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Close()
	{
		VARIANT result;
		InvokeHelper(0x115, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Item(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xaa, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Open(VARIANT& Filename, VARIANT& UpdateLinks, VARIANT& ReadOnly, VARIANT& Format, VARIANT& Password, VARIANT& WriteResPassword, VARIANT& IgnoreReadOnlyRecommended, VARIANT& Origin, VARIANT& Delimiter, VARIANT& Editable, VARIANT& Notify, VARIANT& Converter)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x2aa, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename, &UpdateLinks, &ReadOnly, &Format, &Password, &WriteResPassword, &IgnoreReadOnlyRecommended, &Origin, &Delimiter, &Editable, &Notify, &Converter);
		return result;
	}
	VARIANT OpenText(VARIANT& Filename, VARIANT& Origin, VARIANT& StartRow, VARIANT& DataType, VARIANT& TextQualifier, VARIANT& ConsecutiveDelimiter, VARIANT& Tab, VARIANT& Semicolon, VARIANT& Comma, VARIANT& Space, VARIANT& Other, VARIANT& OtherChar, VARIANT& FieldInfo)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x2ab, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename, &Origin, &StartRow, &DataType, &TextQualifier, &ConsecutiveDelimiter, &Tab, &Semicolon, &Comma, &Space, &Other, &OtherChar, &FieldInfo);
		return result;
	}

	// Workbooks properties
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
