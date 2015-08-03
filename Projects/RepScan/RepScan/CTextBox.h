// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CTextBox wrapper class

class CTextBox : public COleDispatchDriver
{
public:
	CTextBox(){} // Calls COleDispatchDriver default constructor
	CTextBox(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CTextBox(const CTextBox& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// TextBox methods
public:
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
	VARIANT CheckSpelling(VARIANT& CustomDictionary, VARIANT& IgnoreUppercase, VARIANT& AlwaysSuggest)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1f9, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &CustomDictionary, &IgnoreUppercase, &AlwaysSuggest);
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

	// TextBox properties
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
	VARIANT GetAutoSize()
	{
		VARIANT result;
		GetProperty(0x266, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAutoSize(VARIANT &propVal)
	{
		SetProperty(0x266, VT_VARIANT, &propVal);
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
	VARIANT GetBottomRightCell()
	{
		VARIANT result;
		GetProperty(0x267, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBottomRightCell(VARIANT &propVal)
	{
		SetProperty(0x267, VT_VARIANT, &propVal);
	}
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
	VARIANT GetIndex()
	{
		VARIANT result;
		GetProperty(0x1e6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetIndex(VARIANT &propVal)
	{
		SetProperty(0x1e6, VT_VARIANT, &propVal);
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
	VARIANT GetLockedText()
	{
		VARIANT result;
		GetProperty(0x268, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLockedText(VARIANT &propVal)
	{
		SetProperty(0x268, VT_VARIANT, &propVal);
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
	VARIANT GetRoundedCorners()
	{
		VARIANT result;
		GetProperty(0x26b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRoundedCorners(VARIANT &propVal)
	{
		SetProperty(0x26b, VT_VARIANT, &propVal);
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
	VARIANT GetTopLeftCell()
	{
		VARIANT result;
		GetProperty(0x26c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTopLeftCell(VARIANT &propVal)
	{
		SetProperty(0x26c, VT_VARIANT, &propVal);
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
