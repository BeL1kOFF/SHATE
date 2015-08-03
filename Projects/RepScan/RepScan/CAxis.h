// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CAxis wrapper class

class CAxis : public COleDispatchDriver
{
public:
	CAxis(){} // Calls COleDispatchDriver default constructor
	CAxis(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CAxis(const CAxis& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Axis methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Delete()
	{
		VARIANT result;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Select()
	{
		VARIANT result;
		InvokeHelper(0xeb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// Axis properties
public:
	VARIANT GetAxisBetweenCategories()
	{
		VARIANT result;
		GetProperty(0x2d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAxisBetweenCategories(VARIANT &propVal)
	{
		SetProperty(0x2d, VT_VARIANT, &propVal);
	}
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
	VARIANT GetAxisTitle()
	{
		VARIANT result;
		GetProperty(0x52, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAxisTitle(VARIANT &propVal)
	{
		SetProperty(0x52, VT_VARIANT, &propVal);
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
	VARIANT GetCategoryNames()
	{
		VARIANT result;
		GetProperty(0x9c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCategoryNames(VARIANT &propVal)
	{
		SetProperty(0x9c, VT_VARIANT, &propVal);
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
	VARIANT GetCrosses()
	{
		VARIANT result;
		GetProperty(0x2a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCrosses(VARIANT &propVal)
	{
		SetProperty(0x2a, VT_VARIANT, &propVal);
	}
	VARIANT GetCrossesAt()
	{
		VARIANT result;
		GetProperty(0x2b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCrossesAt(VARIANT &propVal)
	{
		SetProperty(0x2b, VT_VARIANT, &propVal);
	}
	VARIANT GetHasMajorGridlines()
	{
		VARIANT result;
		GetProperty(0x18, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasMajorGridlines(VARIANT &propVal)
	{
		SetProperty(0x18, VT_VARIANT, &propVal);
	}
	VARIANT GetHasMinorGridlines()
	{
		VARIANT result;
		GetProperty(0x19, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasMinorGridlines(VARIANT &propVal)
	{
		SetProperty(0x19, VT_VARIANT, &propVal);
	}
	VARIANT GetHasTitle()
	{
		VARIANT result;
		GetProperty(0x36, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasTitle(VARIANT &propVal)
	{
		SetProperty(0x36, VT_VARIANT, &propVal);
	}
	VARIANT GetMajorGridlines()
	{
		VARIANT result;
		GetProperty(0x59, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMajorGridlines(VARIANT &propVal)
	{
		SetProperty(0x59, VT_VARIANT, &propVal);
	}
	VARIANT GetMajorTickMark()
	{
		VARIANT result;
		GetProperty(0x1a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMajorTickMark(VARIANT &propVal)
	{
		SetProperty(0x1a, VT_VARIANT, &propVal);
	}
	VARIANT GetMajorUnit()
	{
		VARIANT result;
		GetProperty(0x25, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMajorUnit(VARIANT &propVal)
	{
		SetProperty(0x25, VT_VARIANT, &propVal);
	}
	VARIANT GetMajorUnitIsAuto()
	{
		VARIANT result;
		GetProperty(0x26, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMajorUnitIsAuto(VARIANT &propVal)
	{
		SetProperty(0x26, VT_VARIANT, &propVal);
	}
	VARIANT GetMaximumScale()
	{
		VARIANT result;
		GetProperty(0x23, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMaximumScale(VARIANT &propVal)
	{
		SetProperty(0x23, VT_VARIANT, &propVal);
	}
	VARIANT GetMaximumScaleIsAuto()
	{
		VARIANT result;
		GetProperty(0x24, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMaximumScaleIsAuto(VARIANT &propVal)
	{
		SetProperty(0x24, VT_VARIANT, &propVal);
	}
	VARIANT GetMinimumScale()
	{
		VARIANT result;
		GetProperty(0x21, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMinimumScale(VARIANT &propVal)
	{
		SetProperty(0x21, VT_VARIANT, &propVal);
	}
	VARIANT GetMinimumScaleIsAuto()
	{
		VARIANT result;
		GetProperty(0x22, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMinimumScaleIsAuto(VARIANT &propVal)
	{
		SetProperty(0x22, VT_VARIANT, &propVal);
	}
	VARIANT GetMinorGridlines()
	{
		VARIANT result;
		GetProperty(0x5a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMinorGridlines(VARIANT &propVal)
	{
		SetProperty(0x5a, VT_VARIANT, &propVal);
	}
	VARIANT GetMinorTickMark()
	{
		VARIANT result;
		GetProperty(0x1b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMinorTickMark(VARIANT &propVal)
	{
		SetProperty(0x1b, VT_VARIANT, &propVal);
	}
	VARIANT GetMinorUnit()
	{
		VARIANT result;
		GetProperty(0x27, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMinorUnit(VARIANT &propVal)
	{
		SetProperty(0x27, VT_VARIANT, &propVal);
	}
	VARIANT GetMinorUnitIsAuto()
	{
		VARIANT result;
		GetProperty(0x28, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMinorUnitIsAuto(VARIANT &propVal)
	{
		SetProperty(0x28, VT_VARIANT, &propVal);
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
	VARIANT GetReversePlotOrder()
	{
		VARIANT result;
		GetProperty(0x2c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetReversePlotOrder(VARIANT &propVal)
	{
		SetProperty(0x2c, VT_VARIANT, &propVal);
	}
	VARIANT GetScaleType()
	{
		VARIANT result;
		GetProperty(0x29, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetScaleType(VARIANT &propVal)
	{
		SetProperty(0x29, VT_VARIANT, &propVal);
	}
	VARIANT GetTickLabelPosition()
	{
		VARIANT result;
		GetProperty(0x1c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTickLabelPosition(VARIANT &propVal)
	{
		SetProperty(0x1c, VT_VARIANT, &propVal);
	}
	VARIANT GetTickLabels()
	{
		VARIANT result;
		GetProperty(0x5b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTickLabels(VARIANT &propVal)
	{
		SetProperty(0x5b, VT_VARIANT, &propVal);
	}
	VARIANT GetTickLabelSpacing()
	{
		VARIANT result;
		GetProperty(0x1d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTickLabelSpacing(VARIANT &propVal)
	{
		SetProperty(0x1d, VT_VARIANT, &propVal);
	}
	VARIANT GetTickMarkSpacing()
	{
		VARIANT result;
		GetProperty(0x1f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTickMarkSpacing(VARIANT &propVal)
	{
		SetProperty(0x1f, VT_VARIANT, &propVal);
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

};
