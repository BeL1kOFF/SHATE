// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CWorksheet wrapper class

class CWorksheet : public COleDispatchDriver
{
public:
	CWorksheet(){} // Calls COleDispatchDriver default constructor
	CWorksheet(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CWorksheet(const CWorksheet& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Worksheet methods
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
	VARIANT Arcs(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x2f8, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Buttons(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x22d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Calculate()
	{
		VARIANT result;
		InvokeHelper(0x117, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Cells(VARIANT& RowIndex, VARIANT& ColumnIndex)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xee, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &RowIndex, &ColumnIndex);
		return result;
	}
	VARIANT ChartObjects(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x424, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
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
	VARIANT ClearArrows()
	{
		VARIANT result;
		InvokeHelper(0x3ca, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Columns(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xf1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Copy(VARIANT& Before, VARIANT& After)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x227, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Before, &After);
		return result;
	}
	VARIANT Delete()
	{
		VARIANT result;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
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
	VARIANT Names(VARIANT& Index, VARIANT& IndexLocal, VARIANT& RefersTo)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1ba, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index, &IndexLocal, &RefersTo);
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
	VARIANT Paste(VARIANT& Destination, VARIANT& Link)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xd3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Destination, &Link);
		return result;
	}
	VARIANT PasteSpecial(VARIANT& Format, VARIANT& Link, VARIANT& DisplayAsIcon, VARIANT& IconFileName, VARIANT& IconIndex, VARIANT& IconLabel)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x403, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Format, &Link, &DisplayAsIcon, &IconFileName, &IconIndex, &IconLabel);
		return result;
	}
	VARIANT Pictures(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x303, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT PivotTables(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x2b2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT PivotTableWizard(VARIANT& SourceType, VARIANT& SourceData, VARIANT& TableDestination, VARIANT& TableName, VARIANT& RowGrand, VARIANT& ColumnGrand, VARIANT& SaveData, VARIANT& HasAutoFormat, VARIANT& AutoPage, VARIANT& Reserved)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x2ac, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &SourceType, &SourceData, &TableDestination, &TableName, &RowGrand, &ColumnGrand, &SaveData, &HasAutoFormat, &AutoPage, &Reserved);
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
	VARIANT Range(VARIANT& Cell1, VARIANT& Cell2)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xc5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Cell1, &Cell2);
		return result;
	}
	VARIANT Rectangles(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x306, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Rows(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x102, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT SaveAs(VARIANT& Filename, VARIANT& FileFormat, VARIANT& Password, VARIANT& WriteResPassword, VARIANT& ReadOnlyRecommended, VARIANT& CreateBackup)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x11c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename, &FileFormat, &Password, &WriteResPassword, &ReadOnlyRecommended, &CreateBackup);
		return result;
	}
	VARIANT Scenarios(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x38c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
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
	VARIANT SetBackgroundPicture(VARIANT& Filename)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x4a4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename);
		return result;
	}
	VARIANT ShowAllData()
	{
		VARIANT result;
		InvokeHelper(0x31a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ShowDataForm()
	{
		VARIANT result;
		InvokeHelper(0x199, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
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

	// Worksheet properties
public:
	VARIANT GetAutoFilterMode()
	{
		VARIANT result;
		GetProperty(0x318, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAutoFilterMode(VARIANT &propVal)
	{
		SetProperty(0x318, VT_VARIANT, &propVal);
	}
	VARIANT GetCircularReference()
	{
		VARIANT result;
		GetProperty(0x42d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCircularReference(VARIANT &propVal)
	{
		SetProperty(0x42d, VT_VARIANT, &propVal);
	}
	VARIANT GetConsolidationFunction()
	{
		VARIANT result;
		GetProperty(0x315, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetConsolidationFunction(VARIANT &propVal)
	{
		SetProperty(0x315, VT_VARIANT, &propVal);
	}
	VARIANT GetConsolidationOptions()
	{
		VARIANT result;
		GetProperty(0x316, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetConsolidationOptions(VARIANT &propVal)
	{
		SetProperty(0x316, VT_VARIANT, &propVal);
	}
	VARIANT GetConsolidationSources()
	{
		VARIANT result;
		GetProperty(0x317, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetConsolidationSources(VARIANT &propVal)
	{
		SetProperty(0x317, VT_VARIANT, &propVal);
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
	VARIANT GetDisplayAutomaticPageBreaks()
	{
		VARIANT result;
		GetProperty(0x283, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayAutomaticPageBreaks(VARIANT &propVal)
	{
		SetProperty(0x283, VT_VARIANT, &propVal);
	}
	VARIANT GetEnableAutoFilter()
	{
		VARIANT result;
		GetProperty(0x484, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEnableAutoFilter(VARIANT &propVal)
	{
		SetProperty(0x484, VT_VARIANT, &propVal);
	}
	VARIANT GetEnableOutlining()
	{
		VARIANT result;
		GetProperty(0x485, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEnableOutlining(VARIANT &propVal)
	{
		SetProperty(0x485, VT_VARIANT, &propVal);
	}
	VARIANT GetEnablePivotTable()
	{
		VARIANT result;
		GetProperty(0x486, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEnablePivotTable(VARIANT &propVal)
	{
		SetProperty(0x486, VT_VARIANT, &propVal);
	}
	VARIANT GetFilterMode()
	{
		VARIANT result;
		GetProperty(0x320, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFilterMode(VARIANT &propVal)
	{
		SetProperty(0x320, VT_VARIANT, &propVal);
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
	VARIANT GetOnCalculate()
	{
		VARIANT result;
		GetProperty(0x271, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnCalculate(VARIANT &propVal)
	{
		SetProperty(0x271, VT_VARIANT, &propVal);
	}
	VARIANT GetOnData()
	{
		VARIANT result;
		GetProperty(0x275, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnData(VARIANT &propVal)
	{
		SetProperty(0x275, VT_VARIANT, &propVal);
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
	VARIANT GetOnEntry()
	{
		VARIANT result;
		GetProperty(0x273, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnEntry(VARIANT &propVal)
	{
		SetProperty(0x273, VT_VARIANT, &propVal);
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
	VARIANT GetOutline()
	{
		VARIANT result;
		GetProperty(0x66, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOutline(VARIANT &propVal)
	{
		SetProperty(0x66, VT_VARIANT, &propVal);
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
	VARIANT GetProtectScenarios()
	{
		VARIANT result;
		GetProperty(0x126, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetProtectScenarios(VARIANT &propVal)
	{
		SetProperty(0x126, VT_VARIANT, &propVal);
	}
	VARIANT GetStandardHeight()
	{
		VARIANT result;
		GetProperty(0x197, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetStandardHeight(VARIANT &propVal)
	{
		SetProperty(0x197, VT_VARIANT, &propVal);
	}
	VARIANT GetStandardWidth()
	{
		VARIANT result;
		GetProperty(0x198, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetStandardWidth(VARIANT &propVal)
	{
		SetProperty(0x198, VT_VARIANT, &propVal);
	}
	VARIANT GetTransitionExpEval()
	{
		VARIANT result;
		GetProperty(0x191, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTransitionExpEval(VARIANT &propVal)
	{
		SetProperty(0x191, VT_VARIANT, &propVal);
	}
	VARIANT GetTransitionFormEntry()
	{
		VARIANT result;
		GetProperty(0x192, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTransitionFormEntry(VARIANT &propVal)
	{
		SetProperty(0x192, VT_VARIANT, &propVal);
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
	VARIANT GetUsedRange()
	{
		VARIANT result;
		GetProperty(0x19c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetUsedRange(VARIANT &propVal)
	{
		SetProperty(0x19c, VT_VARIANT, &propVal);
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

};
