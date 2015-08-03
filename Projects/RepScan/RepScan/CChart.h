// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CChart wrapper class

class CChart : public COleDispatchDriver
{
public:
	CChart(){} // Calls COleDispatchDriver default constructor
	CChart(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CChart(const CChart& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Chart methods
public:
	VARIANT Activate()
	{
		VARIANT result;
		InvokeHelper(0x130, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
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
	VARIANT Arcs(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x2f8, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT AreaGroups(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x9, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT AutoFormat(VARIANT& Gallery, VARIANT& Format)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x72, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Gallery, &Format);
		return result;
	}
	VARIANT Axes(VARIANT& Type, VARIANT& AxisGroup)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x17, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Type, &AxisGroup);
		return result;
	}
	VARIANT BarGroups(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xa, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Buttons(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x22d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT ChartGroups(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x8, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT ChartObjects(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x424, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT ChartWizard(VARIANT& Source, VARIANT& Gallery, VARIANT& Format, VARIANT& PlotBy, VARIANT& CategoryLabels, VARIANT& SeriesLabels, VARIANT& HasLegend, VARIANT& Title, VARIANT& CategoryTitle, VARIANT& ValueTitle, VARIANT& ExtraTitle)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xc4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Source, &Gallery, &Format, &PlotBy, &CategoryLabels, &SeriesLabels, &HasLegend, &Title, &CategoryTitle, &ValueTitle, &ExtraTitle);
		return result;
	}
	VARIANT CheckBoxes(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x338, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT CheckSpelling(VARIANT& CustomDictionary, VARIANT& IgnoreUppercase, VARIANT& AlwaysSuggest)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1f9, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &CustomDictionary, &IgnoreUppercase, &AlwaysSuggest);
		return result;
	}
	VARIANT ColumnGroups(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Copy(VARIANT& Before, VARIANT& After)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x227, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Before, &After);
		return result;
	}
	VARIANT CopyPicture(VARIANT& Appearance, VARIANT& Format, VARIANT& Size)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xd5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Appearance, &Format, &Size);
		return result;
	}
	VARIANT CreatePublisher(VARIANT& Edition, VARIANT& Appearance, VARIANT& Size, VARIANT& ContainsPICT, VARIANT& ContainsBIFF, VARIANT& ContainsRTF, VARIANT& ContainsVALU)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1ca, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Edition, &Appearance, &Size, &ContainsPICT, &ContainsBIFF, &ContainsRTF, &ContainsVALU);
		return result;
	}
	VARIANT Delete()
	{
		VARIANT result;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Deselect()
	{
		VARIANT result;
		InvokeHelper(0x460, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DoughnutGroups(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xe, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT DrawingObjects(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x58, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Drawings(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x304, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT DropDowns(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x344, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT _Evaluate(VARIANT& Name)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Name);
		return result;
	}
	VARIANT Evaluate(VARIANT& Name)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xfffffffb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Name);
		return result;
	}
	VARIANT GroupBoxes(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x342, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT GroupObjects(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x459, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Labels(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x349, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT LineGroups(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xc, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Lines(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x2ff, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT ListBoxes(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x340, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Move(VARIANT& Before, VARIANT& After)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x27d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Before, &After);
		return result;
	}
	VARIANT OLEObjects(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x31f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT OptionButtons(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x33a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Ovals(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x321, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Paste(VARIANT& Type)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xd3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Type);
		return result;
	}
	VARIANT Pictures(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x303, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT PieGroups(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xd, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT PrintOut(VARIANT& From, VARIANT& To, VARIANT& Copies, VARIANT& Preview, VARIANT& ActivePrinter, VARIANT& PrintToFile, VARIANT& Collate)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x389, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &From, &To, &Copies, &Preview, &ActivePrinter, &PrintToFile, &Collate);
		return result;
	}
	VARIANT PrintPreview()
	{
		VARIANT result;
		InvokeHelper(0x119, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Protect(VARIANT& Password, VARIANT& DrawingObjects, VARIANT& Contents, VARIANT& Scenarios, VARIANT& UserInterfaceOnly)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x11a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Password, &DrawingObjects, &Contents, &Scenarios, &UserInterfaceOnly);
		return result;
	}
	VARIANT RadarGroups(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xf, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Rectangles(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x306, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT SaveAs(VARIANT& Filename, VARIANT& FileFormat, VARIANT& Password, VARIANT& WriteResPassword, VARIANT& ReadOnlyRecommended, VARIANT& CreateBackup)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x11c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename, &FileFormat, &Password, &WriteResPassword, &ReadOnlyRecommended, &CreateBackup);
		return result;
	}
	VARIANT ScrollBars(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x33e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Select(VARIANT& Replace)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xeb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Replace);
		return result;
	}
	VARIANT SeriesCollection(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x44, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT SetBackgroundPicture(VARIANT& Filename)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x4a4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename);
		return result;
	}
	VARIANT Spinners(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x346, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT TextBoxes(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x309, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Unprotect(VARIANT& Password)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x11d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Password);
		return result;
	}
	VARIANT XYGroups(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x10, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}

	// Chart properties
public:
	VARIANT GetArea3DGroup()
	{
		VARIANT result;
		GetProperty(0x11, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetArea3DGroup(VARIANT &propVal)
	{
		SetProperty(0x11, VT_VARIANT, &propVal);
	}
	VARIANT GetAutoScaling()
	{
		VARIANT result;
		GetProperty(0x6b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAutoScaling(VARIANT &propVal)
	{
		SetProperty(0x6b, VT_VARIANT, &propVal);
	}
	VARIANT GetBar3DGroup()
	{
		VARIANT result;
		GetProperty(0x12, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBar3DGroup(VARIANT &propVal)
	{
		SetProperty(0x12, VT_VARIANT, &propVal);
	}
	VARIANT GetChartArea()
	{
		VARIANT result;
		GetProperty(0x50, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetChartArea(VARIANT &propVal)
	{
		SetProperty(0x50, VT_VARIANT, &propVal);
	}
	VARIANT GetChartTitle()
	{
		VARIANT result;
		GetProperty(0x51, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetChartTitle(VARIANT &propVal)
	{
		SetProperty(0x51, VT_VARIANT, &propVal);
	}
	VARIANT GetColumn3DGroup()
	{
		VARIANT result;
		GetProperty(0x13, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetColumn3DGroup(VARIANT &propVal)
	{
		SetProperty(0x13, VT_VARIANT, &propVal);
	}
	VARIANT GetCorners()
	{
		VARIANT result;
		GetProperty(0x4f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCorners(VARIANT &propVal)
	{
		SetProperty(0x4f, VT_VARIANT, &propVal);
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
	VARIANT GetDepthPercent()
	{
		VARIANT result;
		GetProperty(0x30, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDepthPercent(VARIANT &propVal)
	{
		SetProperty(0x30, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayBlanksAs()
	{
		VARIANT result;
		GetProperty(0x5d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayBlanksAs(VARIANT &propVal)
	{
		SetProperty(0x5d, VT_VARIANT, &propVal);
	}
	VARIANT GetElevation()
	{
		VARIANT result;
		GetProperty(0x31, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetElevation(VARIANT &propVal)
	{
		SetProperty(0x31, VT_VARIANT, &propVal);
	}
	VARIANT GetFloor()
	{
		VARIANT result;
		GetProperty(0x53, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFloor(VARIANT &propVal)
	{
		SetProperty(0x53, VT_VARIANT, &propVal);
	}
	VARIANT GetGapDepth()
	{
		VARIANT result;
		GetProperty(0x32, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetGapDepth(VARIANT &propVal)
	{
		SetProperty(0x32, VT_VARIANT, &propVal);
	}
	VARIANT GetHasAxis()
	{
		VARIANT result;
		GetProperty(0x34, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasAxis(VARIANT &propVal)
	{
		SetProperty(0x34, VT_VARIANT, &propVal);
	}
	VARIANT GetHasLegend()
	{
		VARIANT result;
		GetProperty(0x35, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasLegend(VARIANT &propVal)
	{
		SetProperty(0x35, VT_VARIANT, &propVal);
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
	VARIANT GetHeightPercent()
	{
		VARIANT result;
		GetProperty(0x37, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHeightPercent(VARIANT &propVal)
	{
		SetProperty(0x37, VT_VARIANT, &propVal);
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
	VARIANT GetLegend()
	{
		VARIANT result;
		GetProperty(0x54, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLegend(VARIANT &propVal)
	{
		SetProperty(0x54, VT_VARIANT, &propVal);
	}
	VARIANT GetLine3DGroup()
	{
		VARIANT result;
		GetProperty(0x14, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLine3DGroup(VARIANT &propVal)
	{
		SetProperty(0x14, VT_VARIANT, &propVal);
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
	VARIANT GetNext()
	{
		VARIANT result;
		GetProperty(0x1f6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetNext(VARIANT &propVal)
	{
		SetProperty(0x1f6, VT_VARIANT, &propVal);
	}
	VARIANT GetOnDoubleClick()
	{
		VARIANT result;
		GetProperty(0x274, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnDoubleClick(VARIANT &propVal)
	{
		SetProperty(0x274, VT_VARIANT, &propVal);
	}
	VARIANT GetOnSheetActivate()
	{
		VARIANT result;
		GetProperty(0x407, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnSheetActivate(VARIANT &propVal)
	{
		SetProperty(0x407, VT_VARIANT, &propVal);
	}
	VARIANT GetOnSheetDeactivate()
	{
		VARIANT result;
		GetProperty(0x439, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnSheetDeactivate(VARIANT &propVal)
	{
		SetProperty(0x439, VT_VARIANT, &propVal);
	}
	VARIANT GetPageSetup()
	{
		VARIANT result;
		GetProperty(0x3e6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPageSetup(VARIANT &propVal)
	{
		SetProperty(0x3e6, VT_VARIANT, &propVal);
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
	VARIANT GetPerspective()
	{
		VARIANT result;
		GetProperty(0x39, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPerspective(VARIANT &propVal)
	{
		SetProperty(0x39, VT_VARIANT, &propVal);
	}
	VARIANT GetPie3DGroup()
	{
		VARIANT result;
		GetProperty(0x15, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPie3DGroup(VARIANT &propVal)
	{
		SetProperty(0x15, VT_VARIANT, &propVal);
	}
	VARIANT GetPlotArea()
	{
		VARIANT result;
		GetProperty(0x55, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPlotArea(VARIANT &propVal)
	{
		SetProperty(0x55, VT_VARIANT, &propVal);
	}
	VARIANT GetPlotVisibleOnly()
	{
		VARIANT result;
		GetProperty(0x5c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPlotVisibleOnly(VARIANT &propVal)
	{
		SetProperty(0x5c, VT_VARIANT, &propVal);
	}
	VARIANT GetPrevious()
	{
		VARIANT result;
		GetProperty(0x1f7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrevious(VARIANT &propVal)
	{
		SetProperty(0x1f7, VT_VARIANT, &propVal);
	}
	VARIANT GetProtectContents()
	{
		VARIANT result;
		GetProperty(0x124, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetProtectContents(VARIANT &propVal)
	{
		SetProperty(0x124, VT_VARIANT, &propVal);
	}
	VARIANT GetProtectDrawingObjects()
	{
		VARIANT result;
		GetProperty(0x125, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetProtectDrawingObjects(VARIANT &propVal)
	{
		SetProperty(0x125, VT_VARIANT, &propVal);
	}
	VARIANT GetProtectionMode()
	{
		VARIANT result;
		GetProperty(0x487, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetProtectionMode(VARIANT &propVal)
	{
		SetProperty(0x487, VT_VARIANT, &propVal);
	}
	VARIANT GetRightAngleAxes()
	{
		VARIANT result;
		GetProperty(0x3a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRightAngleAxes(VARIANT &propVal)
	{
		SetProperty(0x3a, VT_VARIANT, &propVal);
	}
	VARIANT GetRotation()
	{
		VARIANT result;
		GetProperty(0x3b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRotation(VARIANT &propVal)
	{
		SetProperty(0x3b, VT_VARIANT, &propVal);
	}
	VARIANT GetSizeWithWindow()
	{
		VARIANT result;
		GetProperty(0x5e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSizeWithWindow(VARIANT &propVal)
	{
		SetProperty(0x5e, VT_VARIANT, &propVal);
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
	VARIANT GetSurfaceGroup()
	{
		VARIANT result;
		GetProperty(0x16, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSurfaceGroup(VARIANT &propVal)
	{
		SetProperty(0x16, VT_VARIANT, &propVal);
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
	VARIANT GetWalls()
	{
		VARIANT result;
		GetProperty(0x56, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWalls(VARIANT &propVal)
	{
		SetProperty(0x56, VT_VARIANT, &propVal);
	}
	VARIANT GetWallsAndGridlines2D()
	{
		VARIANT result;
		GetProperty(0xd2, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWallsAndGridlines2D(VARIANT &propVal)
	{
		SetProperty(0xd2, VT_VARIANT, &propVal);
	}

};
