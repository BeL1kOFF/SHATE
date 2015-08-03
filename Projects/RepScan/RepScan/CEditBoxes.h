// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CEditBoxes wrapper class

class CEditBoxes : public COleDispatchDriver
{
public:
	CEditBoxes(){} // Calls COleDispatchDriver default constructor
	CEditBoxes(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CEditBoxes(const CEditBoxes& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// EditBoxes methods
public:
	VARIANT _NewEnum()
	{
		VARIANT result;
		InvokeHelper(0x2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Add(VARIANT& Left, VARIANT& Top, VARIANT& Width, VARIANT& Height)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xb5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Left, &Top, &Width, &Height);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT BringToFront()
	{
		VARIANT result;
		InvokeHelper(0x25a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Characters(VARIANT& Start, VARIANT& Length)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x25b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Start, &Length);
		return result;
	}
	VARIANT Copy()
	{
		VARIANT result;
		InvokeHelper(0x227, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT CopyPicture(VARIANT& Appearance, VARIANT& Format)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xd5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Appearance, &Format);
		return result;
	}
	VARIANT Cut()
	{
		VARIANT result;
		InvokeHelper(0x235, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Delete()
	{
		VARIANT result;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Duplicate()
	{
		VARIANT result;
		InvokeHelper(0x40f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Group()
	{
		VARIANT result;
		InvokeHelper(0x2e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Item(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xaa, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Select(VARIANT& Replace)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xeb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Replace);
		return result;
	}
	VARIANT SendToBack()
	{
		VARIANT result;
		InvokeHelper(0x25d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// EditBoxes properties
public:
	VARIANT GetCaption()
	{
		VARIANT result;
		GetProperty(0x8b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCaption(VARIANT &propVal)
	{
		SetProperty(0x8b, VT_VARIANT, &propVal);
	}
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
	VARIANT GetDisplayVerticalScrollBar()
	{
		VARIANT result;
		GetProperty(0x39a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayVerticalScrollBar(VARIANT &propVal)
	{
		SetProperty(0x39a, VT_VARIANT, &propVal);
	}
	VARIANT GetEnabled()
	{
		VARIANT result;
		GetProperty(0x258, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEnabled(VARIANT &propVal)
	{
		SetProperty(0x258, VT_VARIANT, &propVal);
	}
	VARIANT GetHeight()
	{
		VARIANT result;
		GetProperty(0x7b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHeight(VARIANT &propVal)
	{
		SetProperty(0x7b, VT_VARIANT, &propVal);
	}
	VARIANT GetInputType()
	{
		VARIANT result;
		GetProperty(0x356, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetInputType(VARIANT &propVal)
	{
		SetProperty(0x356, VT_VARIANT, &propVal);
	}
	VARIANT GetLeft()
	{
		VARIANT result;
		GetProperty(0x7f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLeft(VARIANT &propVal)
	{
		SetProperty(0x7f, VT_VARIANT, &propVal);
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
	VARIANT GetMultiLine()
	{
		VARIANT result;
		GetProperty(0x357, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMultiLine(VARIANT &propVal)
	{
		SetProperty(0x357, VT_VARIANT, &propVal);
	}
	VARIANT GetOnAction()
	{
		VARIANT result;
		GetProperty(0x254, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnAction(VARIANT &propVal)
	{
		SetProperty(0x254, VT_VARIANT, &propVal);
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
	VARIANT GetPasswordEdit()
	{
		VARIANT result;
		GetProperty(0x48a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPasswordEdit(VARIANT &propVal)
	{
		SetProperty(0x48a, VT_VARIANT, &propVal);
	}
	VARIANT GetPlacement()
	{
		VARIANT result;
		GetProperty(0x269, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPlacement(VARIANT &propVal)
	{
		SetProperty(0x269, VT_VARIANT, &propVal);
	}
	VARIANT GetPrintObject()
	{
		VARIANT result;
		GetProperty(0x26a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrintObject(VARIANT &propVal)
	{
		SetProperty(0x26a, VT_VARIANT, &propVal);
	}
	VARIANT GetText()
	{
		VARIANT result;
		GetProperty(0x8a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetText(VARIANT &propVal)
	{
		SetProperty(0x8a, VT_VARIANT, &propVal);
	}
	VARIANT GetTop()
	{
		VARIANT result;
		GetProperty(0x7e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTop(VARIANT &propVal)
	{
		SetProperty(0x7e, VT_VARIANT, &propVal);
	}
	VARIANT GetVisible()
	{
		VARIANT result;
		GetProperty(0x22e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetVisible(VARIANT &propVal)
	{
		SetProperty(0x22e, VT_VARIANT, &propVal);
	}
	VARIANT GetWidth()
	{
		VARIANT result;
		GetProperty(0x7a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWidth(VARIANT &propVal)
	{
		SetProperty(0x7a, VT_VARIANT, &propVal);
	}
	VARIANT GetZOrder()
	{
		VARIANT result;
		GetProperty(0x26e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetZOrder(VARIANT &propVal)
	{
		SetProperty(0x26e, VT_VARIANT, &propVal);
	}

};
