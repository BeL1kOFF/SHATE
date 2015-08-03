// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CDrawingObjects wrapper class

class CDrawingObjects : public COleDispatchDriver
{
public:
	CDrawingObjects(){} // Calls COleDispatchDriver default constructor
	CDrawingObjects(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CDrawingObjects(const CDrawingObjects& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// DrawingObjects methods
public:
	VARIANT _NewEnum()
	{
		VARIANT result;
		InvokeHelper(0x2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT AddItem(VARIANT& Text, VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x353, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Text, &Index);
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
	VARIANT LinkCombo(VARIANT& Link)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x358, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Link);
		return result;
	}
	VARIANT RemoveAllItems()
	{
		VARIANT result;
		InvokeHelper(0x355, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT RemoveItem(VARIANT& Index, VARIANT& Count)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x354, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index, &Count);
		return result;
	}
	VARIANT Reshape(VARIANT& Vertex, VARIANT& Insert, VARIANT& Left, VARIANT& Top)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x25c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Vertex, &Insert, &Left, &Top);
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
	VARIANT Ungroup()
	{
		VARIANT result;
		InvokeHelper(0xf4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// DrawingObjects properties
public:
	VARIANT GetAccelerator()
	{
		VARIANT result;
		GetProperty(0x34e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAccelerator(VARIANT &propVal)
	{
		SetProperty(0x34e, VT_VARIANT, &propVal);
	}
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
	VARIANT GetArrowHeadLength()
	{
		VARIANT result;
		GetProperty(0x263, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetArrowHeadLength(VARIANT &propVal)
	{
		SetProperty(0x263, VT_VARIANT, &propVal);
	}
	VARIANT GetArrowHeadStyle()
	{
		VARIANT result;
		GetProperty(0x264, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetArrowHeadStyle(VARIANT &propVal)
	{
		SetProperty(0x264, VT_VARIANT, &propVal);
	}
	VARIANT GetArrowHeadWidth()
	{
		VARIANT result;
		GetProperty(0x265, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetArrowHeadWidth(VARIANT &propVal)
	{
		SetProperty(0x265, VT_VARIANT, &propVal);
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
	VARIANT GetCancelButton()
	{
		VARIANT result;
		GetProperty(0x35a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCancelButton(VARIANT &propVal)
	{
		SetProperty(0x35a, VT_VARIANT, &propVal);
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
	VARIANT GetDefaultButton()
	{
		VARIANT result;
		GetProperty(0x359, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDefaultButton(VARIANT &propVal)
	{
		SetProperty(0x359, VT_VARIANT, &propVal);
	}
	VARIANT GetDismissButton()
	{
		VARIANT result;
		GetProperty(0x35b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDismissButton(VARIANT &propVal)
	{
		SetProperty(0x35b, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplay3DShading()
	{
		VARIANT result;
		GetProperty(0x462, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplay3DShading(VARIANT &propVal)
	{
		SetProperty(0x462, VT_VARIANT, &propVal);
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
	VARIANT GetDropDownLines()
	{
		VARIANT result;
		GetProperty(0x350, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDropDownLines(VARIANT &propVal)
	{
		SetProperty(0x350, VT_VARIANT, &propVal);
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
	VARIANT GetHelpButton()
	{
		VARIANT result;
		GetProperty(0x35c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHelpButton(VARIANT &propVal)
	{
		SetProperty(0x35c, VT_VARIANT, &propVal);
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
	VARIANT GetLargeChange()
	{
		VARIANT result;
		GetProperty(0x34d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLargeChange(VARIANT &propVal)
	{
		SetProperty(0x34d, VT_VARIANT, &propVal);
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
	VARIANT GetLinkedCell()
	{
		VARIANT result;
		GetProperty(0x422, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLinkedCell(VARIANT &propVal)
	{
		SetProperty(0x422, VT_VARIANT, &propVal);
	}
	VARIANT GetList()
	{
		VARIANT result;
		GetProperty(0x35d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetList(VARIANT &propVal)
	{
		SetProperty(0x35d, VT_VARIANT, &propVal);
	}
	VARIANT GetListFillRange()
	{
		VARIANT result;
		GetProperty(0x34f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetListFillRange(VARIANT &propVal)
	{
		SetProperty(0x34f, VT_VARIANT, &propVal);
	}
	VARIANT GetListIndex()
	{
		VARIANT result;
		GetProperty(0x352, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetListIndex(VARIANT &propVal)
	{
		SetProperty(0x352, VT_VARIANT, &propVal);
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
	VARIANT GetMax()
	{
		VARIANT result;
		GetProperty(0x34a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMax(VARIANT &propVal)
	{
		SetProperty(0x34a, VT_VARIANT, &propVal);
	}
	VARIANT GetMin()
	{
		VARIANT result;
		GetProperty(0x34b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMin(VARIANT &propVal)
	{
		SetProperty(0x34b, VT_VARIANT, &propVal);
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
	VARIANT GetMultiSelect()
	{
		VARIANT result;
		GetProperty(0x20, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMultiSelect(VARIANT &propVal)
	{
		SetProperty(0x20, VT_VARIANT, &propVal);
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
	VARIANT GetPhoneticAccelerator()
	{
		VARIANT result;
		GetProperty(0x461, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPhoneticAccelerator(VARIANT &propVal)
	{
		SetProperty(0x461, VT_VARIANT, &propVal);
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
	VARIANT GetSelected()
	{
		VARIANT result;
		GetProperty(0x463, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSelected(VARIANT &propVal)
	{
		SetProperty(0x463, VT_VARIANT, &propVal);
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
	VARIANT GetSmallChange()
	{
		VARIANT result;
		GetProperty(0x34c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSmallChange(VARIANT &propVal)
	{
		SetProperty(0x34c, VT_VARIANT, &propVal);
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
	VARIANT GetVertices()
	{
		VARIANT result;
		GetProperty(0x26d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetVertices(VARIANT &propVal)
	{
		SetProperty(0x26d, VT_VARIANT, &propVal);
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
