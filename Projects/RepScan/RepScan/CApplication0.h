// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

////#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CApplication0 wrapper class

class CApplication0 : public COleDispatchDriver
{
public:
	CApplication0(){} // Calls COleDispatchDriver default constructor
	CApplication0(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CApplication0(const CApplication0& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Application methods
public:
	VARIANT _WSFunction(VARIANT& Range, VARIANT& Arg1, VARIANT& Arg2, VARIANT& Arg3, VARIANT& Arg4, VARIANT& Arg5, VARIANT& Arg6, VARIANT& Arg7, VARIANT& Arg8, VARIANT& Arg9, VARIANT& Arg10, VARIANT& Arg11, VARIANT& Arg12, VARIANT& Arg13, VARIANT& Arg14, VARIANT& Arg15, VARIANT& Arg16, VARIANT& Arg17, VARIANT& Arg18, VARIANT& Arg19, VARIANT& Arg20, VARIANT& Arg21, VARIANT& Arg22, VARIANT& Arg23, VARIANT& Arg24, VARIANT& Arg25, VARIANT& Arg26, VARIANT& Arg27, VARIANT& Arg28, VARIANT& Arg29, VARIANT& Arg30)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xa9, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Range, &Arg1, &Arg2, &Arg3, &Arg4, &Arg5, &Arg6, &Arg7, &Arg8, &Arg9, &Arg10, &Arg11, &Arg12, &Arg13, &Arg14, &Arg15, &Arg16, &Arg17, &Arg18, &Arg19, &Arg20, &Arg21, &Arg22, &Arg23, &Arg24, &Arg25, &Arg26, &Arg27, &Arg28, &Arg29, &Arg30);
		return result;
	}
	VARIANT Acos()
	{
		VARIANT result;
		InvokeHelper(0x4063, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Acosh()
	{
		VARIANT result;
		InvokeHelper(0x40e9, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ActivateMicrosoftApp(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x447, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT AddChartAutoFormat(VARIANT& Chart, VARIANT& Name, VARIANT& Description)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xd8, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Chart, &Name, &Description);
		return result;
	}
	VARIANT AddCustomList(VARIANT& ListArray, VARIANT& ByRow)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x30c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &ListArray, &ByRow);
		return result;
	}
	VARIANT AddIns(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x225, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT And()
	{
		VARIANT result;
		InvokeHelper(0x4024, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Asin()
	{
		VARIANT result;
		InvokeHelper(0x4062, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Asinh()
	{
		VARIANT result;
		InvokeHelper(0x40e8, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Atan2()
	{
		VARIANT result;
		InvokeHelper(0x4061, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Atanh()
	{
		VARIANT result;
		InvokeHelper(0x40ea, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT AveDev()
	{
		VARIANT result;
		InvokeHelper(0x410d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Average()
	{
		VARIANT result;
		InvokeHelper(0x4005, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT BetaDist()
	{
		VARIANT result;
		InvokeHelper(0x410e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT BetaInv()
	{
		VARIANT result;
		InvokeHelper(0x4110, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT BinomDist()
	{
		VARIANT result;
		InvokeHelper(0x4111, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Calculate()
	{
		VARIANT result;
		InvokeHelper(0x117, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Ceiling()
	{
		VARIANT result;
		InvokeHelper(0x4120, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Cells(VARIANT& RowIndex, VARIANT& ColumnIndex)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xee, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &RowIndex, &ColumnIndex);
		return result;
	}
	VARIANT CentimetersToPoints(VARIANT& Centimeters)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x43e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Centimeters);
		return result;
	}
	VARIANT Charts(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x79, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT CheckSpelling(VARIANT& Word, VARIANT& CustomDictionary, VARIANT& IgnoreUppercase)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1f9, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Word, &CustomDictionary, &IgnoreUppercase);
		return result;
	}
	VARIANT ChiDist()
	{
		VARIANT result;
		InvokeHelper(0x4112, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ChiInv()
	{
		VARIANT result;
		InvokeHelper(0x4113, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ChiTest()
	{
		VARIANT result;
		InvokeHelper(0x4132, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Choose()
	{
		VARIANT result;
		InvokeHelper(0x4064, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Clean()
	{
		VARIANT result;
		InvokeHelper(0x40a2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Columns(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xf1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Combin()
	{
		VARIANT result;
		InvokeHelper(0x4114, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Confidence()
	{
		VARIANT result;
		InvokeHelper(0x4115, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ConvertFormula(VARIANT& Formula, VARIANT& FromReferenceStyle, VARIANT& ToReferenceStyle, VARIANT& ToAbsolute, VARIANT& RelativeTo)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x145, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Formula, &FromReferenceStyle, &ToReferenceStyle, &ToAbsolute, &RelativeTo);
		return result;
	}
	VARIANT Correl()
	{
		VARIANT result;
		InvokeHelper(0x4133, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Cosh()
	{
		VARIANT result;
		InvokeHelper(0x40e6, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Count()
	{
		VARIANT result;
		InvokeHelper(0x4000, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT CountA()
	{
		VARIANT result;
		InvokeHelper(0x40a9, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT CountBlank()
	{
		VARIANT result;
		InvokeHelper(0x415b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT CountIf()
	{
		VARIANT result;
		InvokeHelper(0x415a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Covar()
	{
		VARIANT result;
		InvokeHelper(0x4134, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT CritBinom()
	{
		VARIANT result;
		InvokeHelper(0x4116, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DAverage()
	{
		VARIANT result;
		InvokeHelper(0x402a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Days360()
	{
		VARIANT result;
		InvokeHelper(0x40dc, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Db()
	{
		VARIANT result;
		InvokeHelper(0x40f7, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DCount()
	{
		VARIANT result;
		InvokeHelper(0x4028, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DCountA()
	{
		VARIANT result;
		InvokeHelper(0x40c7, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Ddb()
	{
		VARIANT result;
		InvokeHelper(0x4090, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DDEExecute(VARIANT& Channel, VARIANT& String)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x14d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Channel, &String);
		return result;
	}
	VARIANT DDEInitiate(VARIANT& App, VARIANT& Topic)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x14e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &App, &Topic);
		return result;
	}
	VARIANT DDEPoke(VARIANT& Channel, VARIANT& Item, VARIANT& Data)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x14f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Channel, &Item, &Data);
		return result;
	}
	VARIANT DDERequest(VARIANT& Channel, VARIANT& Item)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x150, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Channel, &Item);
		return result;
	}
	VARIANT DDETerminate(VARIANT& Channel)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x151, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Channel);
		return result;
	}
	VARIANT Degrees()
	{
		VARIANT result;
		InvokeHelper(0x4157, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DeleteChartAutoFormat(VARIANT& Name)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xd9, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Name);
		return result;
	}
	VARIANT DeleteCustomList(VARIANT& ListNum)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x30f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &ListNum);
		return result;
	}
	VARIANT DevSq()
	{
		VARIANT result;
		InvokeHelper(0x413e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DGet()
	{
		VARIANT result;
		InvokeHelper(0x40eb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Dialogs(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x2f9, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT DialogSheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x2fc, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT DMax()
	{
		VARIANT result;
		InvokeHelper(0x402c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DMin()
	{
		VARIANT result;
		InvokeHelper(0x402b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Dollar()
	{
		VARIANT result;
		InvokeHelper(0x400d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DoubleClick()
	{
		VARIANT result;
		InvokeHelper(0x15d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DProduct()
	{
		VARIANT result;
		InvokeHelper(0x40bd, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DStDev()
	{
		VARIANT result;
		InvokeHelper(0x402d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DStDevP()
	{
		VARIANT result;
		InvokeHelper(0x40c3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DSum()
	{
		VARIANT result;
		InvokeHelper(0x4029, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DVar()
	{
		VARIANT result;
		InvokeHelper(0x402f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT DVarP()
	{
		VARIANT result;
		InvokeHelper(0x40c4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
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
	VARIANT Even()
	{
		VARIANT result;
		InvokeHelper(0x4117, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Excel4IntlMacroSheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x245, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Excel4MacroSheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x243, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT ExecuteExcel4Macro(VARIANT& String)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x15e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &String);
		return result;
	}
	VARIANT ExponDist()
	{
		VARIANT result;
		InvokeHelper(0x4118, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Fact()
	{
		VARIANT result;
		InvokeHelper(0x40b8, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT FDist()
	{
		VARIANT result;
		InvokeHelper(0x4119, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Find()
	{
		VARIANT result;
		InvokeHelper(0x407c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT FindB()
	{
		VARIANT result;
		InvokeHelper(0x40cd, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT FindFile()
	{
		VARIANT result;
		InvokeHelper(0x42c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT FInv()
	{
		VARIANT result;
		InvokeHelper(0x411a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Fisher()
	{
		VARIANT result;
		InvokeHelper(0x411b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT FisherInv()
	{
		VARIANT result;
		InvokeHelper(0x411c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Fixed()
	{
		VARIANT result;
		InvokeHelper(0x400e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Floor()
	{
		VARIANT result;
		InvokeHelper(0x411d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Forecast()
	{
		VARIANT result;
		InvokeHelper(0x4135, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Frequency()
	{
		VARIANT result;
		InvokeHelper(0x40fc, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT FTest()
	{
		VARIANT result;
		InvokeHelper(0x4136, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Fv()
	{
		VARIANT result;
		InvokeHelper(0x4039, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT GammaDist()
	{
		VARIANT result;
		InvokeHelper(0x411e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT GammaInv()
	{
		VARIANT result;
		InvokeHelper(0x411f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT GammaLn()
	{
		VARIANT result;
		InvokeHelper(0x410f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT GeoMean()
	{
		VARIANT result;
		InvokeHelper(0x413f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT GetCustomListContents(VARIANT& ListNum)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x312, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &ListNum);
		return result;
	}
	VARIANT GetCustomListNum(VARIANT& ListArray)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x311, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &ListArray);
		return result;
	}
	VARIANT GetOpenFilename(VARIANT& FileFilter, VARIANT& FilterIndex, VARIANT& Title, VARIANT& ButtonText, VARIANT& MultiSelect)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x433, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &FileFilter, &FilterIndex, &Title, &ButtonText, &MultiSelect);
		return result;
	}
	VARIANT GetSaveAsFilename(VARIANT& InitialFilename, VARIANT& FileFilter, VARIANT& FilterIndex, VARIANT& Title, VARIANT& ButtonText)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x434, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &InitialFilename, &FileFilter, &FilterIndex, &Title, &ButtonText);
		return result;
	}
	VARIANT Goto(VARIANT& Reference, VARIANT& Scroll)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1db, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Reference, &Scroll);
		return result;
	}
	VARIANT Growth()
	{
		VARIANT result;
		InvokeHelper(0x4034, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT HarMean()
	{
		VARIANT result;
		InvokeHelper(0x4140, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Help(VARIANT& HelpFile, VARIANT& HelpContextID)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x162, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &HelpFile, &HelpContextID);
		return result;
	}
	VARIANT HLookup()
	{
		VARIANT result;
		InvokeHelper(0x4065, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT HypGeomDist()
	{
		VARIANT result;
		InvokeHelper(0x4121, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT InchesToPoints(VARIANT& Inches)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x43f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Inches);
		return result;
	}
	VARIANT Index()
	{
		VARIANT result;
		InvokeHelper(0x401d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT InputBox(VARIANT& Prompt, VARIANT& Title, VARIANT& Default, VARIANT& Left, VARIANT& Top, VARIANT& HelpFile, VARIANT& HelpContextID, VARIANT& Type)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x165, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Prompt, &Title, &Default, &Left, &Top, &HelpFile, &HelpContextID, &Type);
		return result;
	}
	VARIANT Intercept()
	{
		VARIANT result;
		InvokeHelper(0x4137, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Intersect(VARIANT& Arg1, VARIANT& Arg2, VARIANT& Arg3, VARIANT& Arg4, VARIANT& Arg5, VARIANT& Arg6, VARIANT& Arg7, VARIANT& Arg8, VARIANT& Arg9, VARIANT& Arg10, VARIANT& Arg11, VARIANT& Arg12, VARIANT& Arg13, VARIANT& Arg14, VARIANT& Arg15, VARIANT& Arg16, VARIANT& Arg17, VARIANT& Arg18, VARIANT& Arg19, VARIANT& Arg20, VARIANT& Arg21, VARIANT& Arg22, VARIANT& Arg23, VARIANT& Arg24, VARIANT& Arg25, VARIANT& Arg26, VARIANT& Arg27, VARIANT& Arg28, VARIANT& Arg29, VARIANT& Arg30)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x2fe, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Arg1, &Arg2, &Arg3, &Arg4, &Arg5, &Arg6, &Arg7, &Arg8, &Arg9, &Arg10, &Arg11, &Arg12, &Arg13, &Arg14, &Arg15, &Arg16, &Arg17, &Arg18, &Arg19, &Arg20, &Arg21, &Arg22, &Arg23, &Arg24, &Arg25, &Arg26, &Arg27, &Arg28, &Arg29, &Arg30);
		return result;
	}
	VARIANT Ipmt()
	{
		VARIANT result;
		InvokeHelper(0x40a7, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Irr()
	{
		VARIANT result;
		InvokeHelper(0x403e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT IsErr()
	{
		VARIANT result;
		InvokeHelper(0x407e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT IsError()
	{
		VARIANT result;
		InvokeHelper(0x4003, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT IsLogical()
	{
		VARIANT result;
		InvokeHelper(0x40c6, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT IsNA()
	{
		VARIANT result;
		InvokeHelper(0x4002, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT IsNonText()
	{
		VARIANT result;
		InvokeHelper(0x40be, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT IsNumber()
	{
		VARIANT result;
		InvokeHelper(0x4080, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Ispmt()
	{
		VARIANT result;
		InvokeHelper(0x415e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT IsText()
	{
		VARIANT result;
		InvokeHelper(0x407f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Kurt()
	{
		VARIANT result;
		InvokeHelper(0x4142, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Large()
	{
		VARIANT result;
		InvokeHelper(0x4145, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT LinEst()
	{
		VARIANT result;
		InvokeHelper(0x4031, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Ln()
	{
		VARIANT result;
		InvokeHelper(0x4016, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Log()
	{
		VARIANT result;
		InvokeHelper(0x406d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Log10()
	{
		VARIANT result;
		InvokeHelper(0x4017, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT LogEst()
	{
		VARIANT result;
		InvokeHelper(0x4033, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT LogInv()
	{
		VARIANT result;
		InvokeHelper(0x4123, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT LogNormDist()
	{
		VARIANT result;
		InvokeHelper(0x4122, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Lookup()
	{
		VARIANT result;
		InvokeHelper(0x401c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT MacroOptions(VARIANT& Macro, VARIANT& Description, VARIANT& HasMenu, VARIANT& MenuText, VARIANT& HasShortcutKey, VARIANT& ShortcutKey, VARIANT& Category, VARIANT& StatusBar, VARIANT& HelpContextID, VARIANT& HelpFile)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x46f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Macro, &Description, &HasMenu, &MenuText, &HasShortcutKey, &ShortcutKey, &Category, &StatusBar, &HelpContextID, &HelpFile);
		return result;
	}
	VARIANT MailLogoff()
	{
		VARIANT result;
		InvokeHelper(0x3b1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT MailLogon(VARIANT& Name, VARIANT& Password, VARIANT& DownloadNewMail)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x3af, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Name, &Password, &DownloadNewMail);
		return result;
	}
	VARIANT Match()
	{
		VARIANT result;
		InvokeHelper(0x4040, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Max()
	{
		VARIANT result;
		InvokeHelper(0x4007, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT MDeterm()
	{
		VARIANT result;
		InvokeHelper(0x40a3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Median()
	{
		VARIANT result;
		InvokeHelper(0x40e3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT MenuBars(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x24d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Min()
	{
		VARIANT result;
		InvokeHelper(0x4006, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT MInverse()
	{
		VARIANT result;
		InvokeHelper(0x40a4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT MIrr()
	{
		VARIANT result;
		InvokeHelper(0x403d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT MMult()
	{
		VARIANT result;
		InvokeHelper(0x40a5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Mode()
	{
		VARIANT result;
		InvokeHelper(0x414a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Modules(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x246, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Names(VARIANT& Index, VARIANT& IndexLocal, VARIANT& RefersTo)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1ba, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index, &IndexLocal, &RefersTo);
		return result;
	}
	VARIANT NegBinomDist()
	{
		VARIANT result;
		InvokeHelper(0x4124, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT NextLetter()
	{
		VARIANT result;
		InvokeHelper(0x3cc, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT NormDist()
	{
		VARIANT result;
		InvokeHelper(0x4125, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT NormInv()
	{
		VARIANT result;
		InvokeHelper(0x4127, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT NormSDist()
	{
		VARIANT result;
		InvokeHelper(0x4126, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT NormSInv()
	{
		VARIANT result;
		InvokeHelper(0x4128, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT NPer()
	{
		VARIANT result;
		InvokeHelper(0x403a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Npv()
	{
		VARIANT result;
		InvokeHelper(0x400b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Odd()
	{
		VARIANT result;
		InvokeHelper(0x412a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT OnKey(VARIANT& Key, VARIANT& Procedure)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x272, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Key, &Procedure);
		return result;
	}
	VARIANT OnRepeat(VARIANT& Text, VARIANT& Procedure)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x301, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Text, &Procedure);
		return result;
	}
	VARIANT OnTime(VARIANT& EarliestTime, VARIANT& Procedure, VARIANT& LatestTime, VARIANT& Schedule)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x270, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &EarliestTime, &Procedure, &LatestTime, &Schedule);
		return result;
	}
	VARIANT OnUndo(VARIANT& Text, VARIANT& Procedure)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x302, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Text, &Procedure);
		return result;
	}
	VARIANT Or()
	{
		VARIANT result;
		InvokeHelper(0x4025, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Pearson()
	{
		VARIANT result;
		InvokeHelper(0x4138, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Percentile()
	{
		VARIANT result;
		InvokeHelper(0x4148, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT PercentRank()
	{
		VARIANT result;
		InvokeHelper(0x4149, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Permut()
	{
		VARIANT result;
		InvokeHelper(0x412b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Pi()
	{
		VARIANT result;
		InvokeHelper(0x4013, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Pmt()
	{
		VARIANT result;
		InvokeHelper(0x403b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Poisson()
	{
		VARIANT result;
		InvokeHelper(0x412c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Power()
	{
		VARIANT result;
		InvokeHelper(0x4151, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Ppmt()
	{
		VARIANT result;
		InvokeHelper(0x40a8, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Prob()
	{
		VARIANT result;
		InvokeHelper(0x413d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Product()
	{
		VARIANT result;
		InvokeHelper(0x40b7, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Proper()
	{
		VARIANT result;
		InvokeHelper(0x4072, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Pv()
	{
		VARIANT result;
		InvokeHelper(0x4038, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Quartile()
	{
		VARIANT result;
		InvokeHelper(0x4147, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Quit()
	{
		VARIANT result;
		InvokeHelper(0x12e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Radians()
	{
		VARIANT result;
		InvokeHelper(0x4156, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Range(VARIANT& Cell1, VARIANT& Cell2)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xc5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Cell1, &Cell2);
		return result;
	}
	VARIANT Rank()
	{
		VARIANT result;
		InvokeHelper(0x40d8, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Rate()
	{
		VARIANT result;
		InvokeHelper(0x403c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT RecordMacro(VARIANT& BasicCode, VARIANT& XlmCode)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x305, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &BasicCode, &XlmCode);
		return result;
	}
	VARIANT RegisterXLL(VARIANT& Filename)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename);
		return result;
	}
	VARIANT Repeat()
	{
		VARIANT result;
		InvokeHelper(0x12d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Replace()
	{
		VARIANT result;
		InvokeHelper(0x4077, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ReplaceB()
	{
		VARIANT result;
		InvokeHelper(0x40cf, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Rept()
	{
		VARIANT result;
		InvokeHelper(0x401e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ResetTipWizard()
	{
		VARIANT result;
		InvokeHelper(0x3a0, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Roman()
	{
		VARIANT result;
		InvokeHelper(0x4162, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Round()
	{
		VARIANT result;
		InvokeHelper(0x401b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT RoundDown()
	{
		VARIANT result;
		InvokeHelper(0x40d5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT RoundUp()
	{
		VARIANT result;
		InvokeHelper(0x40d4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Rows(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x102, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT RSq()
	{
		VARIANT result;
		InvokeHelper(0x4139, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Run(VARIANT& Macro, VARIANT& Arg1, VARIANT& Arg2, VARIANT& Arg3, VARIANT& Arg4, VARIANT& Arg5, VARIANT& Arg6, VARIANT& Arg7, VARIANT& Arg8, VARIANT& Arg9, VARIANT& Arg10, VARIANT& Arg11, VARIANT& Arg12, VARIANT& Arg13, VARIANT& Arg14, VARIANT& Arg15, VARIANT& Arg16, VARIANT& Arg17, VARIANT& Arg18, VARIANT& Arg19, VARIANT& Arg20, VARIANT& Arg21, VARIANT& Arg22, VARIANT& Arg23, VARIANT& Arg24, VARIANT& Arg25, VARIANT& Arg26, VARIANT& Arg27, VARIANT& Arg28, VARIANT& Arg29, VARIANT& Arg30)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x103, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Macro, &Arg1, &Arg2, &Arg3, &Arg4, &Arg5, &Arg6, &Arg7, &Arg8, &Arg9, &Arg10, &Arg11, &Arg12, &Arg13, &Arg14, &Arg15, &Arg16, &Arg17, &Arg18, &Arg19, &Arg20, &Arg21, &Arg22, &Arg23, &Arg24, &Arg25, &Arg26, &Arg27, &Arg28, &Arg29, &Arg30);
		return result;
	}
	VARIANT Save(VARIANT& Filename)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x11b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename);
		return result;
	}
	VARIANT Search()
	{
		VARIANT result;
		InvokeHelper(0x4052, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT SearchB()
	{
		VARIANT result;
		InvokeHelper(0x40ce, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT SendKeys(VARIANT& Keys, VARIANT& Wait)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x17f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Keys, &Wait);
		return result;
	}
	VARIANT SetDefaultChart(VARIANT& FormatName)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xdb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &FormatName);
		return result;
	}
	VARIANT Sheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1e5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT ShortcutMenus(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x308, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Sinh()
	{
		VARIANT result;
		InvokeHelper(0x40e5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Skew()
	{
		VARIANT result;
		InvokeHelper(0x4143, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Sln()
	{
		VARIANT result;
		InvokeHelper(0x408e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Slope()
	{
		VARIANT result;
		InvokeHelper(0x413b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Small()
	{
		VARIANT result;
		InvokeHelper(0x4146, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Standardize()
	{
		VARIANT result;
		InvokeHelper(0x4129, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT StDev()
	{
		VARIANT result;
		InvokeHelper(0x400c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT StDevP()
	{
		VARIANT result;
		InvokeHelper(0x40c1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT StEyx()
	{
		VARIANT result;
		InvokeHelper(0x413a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Substitute()
	{
		VARIANT result;
		InvokeHelper(0x4078, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Subtotal()
	{
		VARIANT result;
		InvokeHelper(0x4158, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Sum()
	{
		VARIANT result;
		InvokeHelper(0x4004, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT SumIf()
	{
		VARIANT result;
		InvokeHelper(0x4159, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT SumProduct()
	{
		VARIANT result;
		InvokeHelper(0x40e4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT SumSq()
	{
		VARIANT result;
		InvokeHelper(0x4141, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT SumX2MY2()
	{
		VARIANT result;
		InvokeHelper(0x4130, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT SumX2PY2()
	{
		VARIANT result;
		InvokeHelper(0x4131, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT SumXMY2()
	{
		VARIANT result;
		InvokeHelper(0x412f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Syd()
	{
		VARIANT result;
		InvokeHelper(0x408f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Tanh()
	{
		VARIANT result;
		InvokeHelper(0x40e7, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT TDist()
	{
		VARIANT result;
		InvokeHelper(0x412d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Text()
	{
		VARIANT result;
		InvokeHelper(0x4030, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT TInv()
	{
		VARIANT result;
		InvokeHelper(0x414c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Toolbars(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x228, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Transpose()
	{
		VARIANT result;
		InvokeHelper(0x4053, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Trend()
	{
		VARIANT result;
		InvokeHelper(0x4032, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Trim()
	{
		VARIANT result;
		InvokeHelper(0x4076, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT TrimMean()
	{
		VARIANT result;
		InvokeHelper(0x414b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT TTest()
	{
		VARIANT result;
		InvokeHelper(0x413c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Undo()
	{
		VARIANT result;
		InvokeHelper(0x12f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Union(VARIANT& Arg1, VARIANT& Arg2, VARIANT& Arg3, VARIANT& Arg4, VARIANT& Arg5, VARIANT& Arg6, VARIANT& Arg7, VARIANT& Arg8, VARIANT& Arg9, VARIANT& Arg10, VARIANT& Arg11, VARIANT& Arg12, VARIANT& Arg13, VARIANT& Arg14, VARIANT& Arg15, VARIANT& Arg16, VARIANT& Arg17, VARIANT& Arg18, VARIANT& Arg19, VARIANT& Arg20, VARIANT& Arg21, VARIANT& Arg22, VARIANT& Arg23, VARIANT& Arg24, VARIANT& Arg25, VARIANT& Arg26, VARIANT& Arg27, VARIANT& Arg28, VARIANT& Arg29, VARIANT& Arg30)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x30b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Arg1, &Arg2, &Arg3, &Arg4, &Arg5, &Arg6, &Arg7, &Arg8, &Arg9, &Arg10, &Arg11, &Arg12, &Arg13, &Arg14, &Arg15, &Arg16, &Arg17, &Arg18, &Arg19, &Arg20, &Arg21, &Arg22, &Arg23, &Arg24, &Arg25, &Arg26, &Arg27, &Arg28, &Arg29, &Arg30);
		return result;
	}
	VARIANT USDollar()
	{
		VARIANT result;
		InvokeHelper(0x40cc, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Var()
	{
		VARIANT result;
		InvokeHelper(0x402e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT VarP()
	{
		VARIANT result;
		InvokeHelper(0x40c2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Vdb()
	{
		VARIANT result;
		InvokeHelper(0x40de, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT VLookup()
	{
		VARIANT result;
		InvokeHelper(0x4066, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Volatile(VARIANT& Volatile)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x314, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Volatile);
		return result;
	}
	VARIANT Wait(VARIANT& Time)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x189, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Time);
		return result;
	}
	VARIANT Weekday()
	{
		VARIANT result;
		InvokeHelper(0x4046, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Weibull()
	{
		VARIANT result;
		InvokeHelper(0x412e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Windows(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1ae, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Workbooks(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x23c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Worksheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1ee, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT ZTest()
	{
		VARIANT result;
		InvokeHelper(0x4144, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// Application properties
public:
	VARIANT GetActiveCell()
	{
		VARIANT result;
		GetProperty(0x131, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveCell(VARIANT &propVal)
	{
		SetProperty(0x131, VT_VARIANT, &propVal);
	}
	VARIANT GetActiveChart()
	{
		VARIANT result;
		GetProperty(0xb7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveChart(VARIANT &propVal)
	{
		SetProperty(0xb7, VT_VARIANT, &propVal);
	}
	VARIANT GetActiveDialog()
	{
		VARIANT result;
		GetProperty(0x32f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveDialog(VARIANT &propVal)
	{
		SetProperty(0x32f, VT_VARIANT, &propVal);
	}
	VARIANT GetActiveMenuBar()
	{
		VARIANT result;
		GetProperty(0x2f6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveMenuBar(VARIANT &propVal)
	{
		SetProperty(0x2f6, VT_VARIANT, &propVal);
	}
	VARIANT GetActivePrinter()
	{
		VARIANT result;
		GetProperty(0x132, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActivePrinter(VARIANT &propVal)
	{
		SetProperty(0x132, VT_VARIANT, &propVal);
	}
	VARIANT GetActiveSheet()
	{
		VARIANT result;
		GetProperty(0x133, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveSheet(VARIANT &propVal)
	{
		SetProperty(0x133, VT_VARIANT, &propVal);
	}
	VARIANT GetActiveWindow()
	{
		VARIANT result;
		GetProperty(0x2f7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveWindow(VARIANT &propVal)
	{
		SetProperty(0x2f7, VT_VARIANT, &propVal);
	}
	VARIANT GetActiveWorkbook()
	{
		VARIANT result;
		GetProperty(0x134, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetActiveWorkbook(VARIANT &propVal)
	{
		SetProperty(0x134, VT_VARIANT, &propVal);
	}
	VARIANT GetAlertBeforeOverwriting()
	{
		VARIANT result;
		GetProperty(0x3a2, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAlertBeforeOverwriting(VARIANT &propVal)
	{
		SetProperty(0x3a2, VT_VARIANT, &propVal);
	}
	VARIANT GetAltStartupPath()
	{
		VARIANT result;
		GetProperty(0x139, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAltStartupPath(VARIANT &propVal)
	{
		SetProperty(0x139, VT_VARIANT, &propVal);
	}
	VARIANT GetAskToUpdateLinks()
	{
		VARIANT result;
		GetProperty(0x3e0, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAskToUpdateLinks(VARIANT &propVal)
	{
		SetProperty(0x3e0, VT_VARIANT, &propVal);
	}
	VARIANT GetAutoCorrect()
	{
		VARIANT result;
		GetProperty(0x479, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAutoCorrect(VARIANT &propVal)
	{
		SetProperty(0x479, VT_VARIANT, &propVal);
	}
	VARIANT GetBuild()
	{
		VARIANT result;
		GetProperty(0x13a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBuild(VARIANT &propVal)
	{
		SetProperty(0x13a, VT_VARIANT, &propVal);
	}
	VARIANT GetCalculateBeforeSave()
	{
		VARIANT result;
		GetProperty(0x13b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCalculateBeforeSave(VARIANT &propVal)
	{
		SetProperty(0x13b, VT_VARIANT, &propVal);
	}
	VARIANT GetCalculation()
	{
		VARIANT result;
		GetProperty(0x13c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCalculation(VARIANT &propVal)
	{
		SetProperty(0x13c, VT_VARIANT, &propVal);
	}
	VARIANT GetCaller()
	{
		VARIANT result;
		GetProperty(0x13d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCaller(VARIANT &propVal)
	{
		SetProperty(0x13d, VT_VARIANT, &propVal);
	}
	VARIANT GetCanPlaySounds()
	{
		VARIANT result;
		GetProperty(0x13e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCanPlaySounds(VARIANT &propVal)
	{
		SetProperty(0x13e, VT_VARIANT, &propVal);
	}
	VARIANT GetCanRecordSounds()
	{
		VARIANT result;
		GetProperty(0x13f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCanRecordSounds(VARIANT &propVal)
	{
		SetProperty(0x13f, VT_VARIANT, &propVal);
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
	VARIANT GetCellDragAndDrop()
	{
		VARIANT result;
		GetProperty(0x140, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCellDragAndDrop(VARIANT &propVal)
	{
		SetProperty(0x140, VT_VARIANT, &propVal);
	}
	VARIANT GetClipboardFormats()
	{
		VARIANT result;
		GetProperty(0x141, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetClipboardFormats(VARIANT &propVal)
	{
		SetProperty(0x141, VT_VARIANT, &propVal);
	}
	VARIANT GetColorButtons()
	{
		VARIANT result;
		GetProperty(0x16d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetColorButtons(VARIANT &propVal)
	{
		SetProperty(0x16d, VT_VARIANT, &propVal);
	}
	VARIANT GetCommandUnderlines()
	{
		VARIANT result;
		GetProperty(0x143, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCommandUnderlines(VARIANT &propVal)
	{
		SetProperty(0x143, VT_VARIANT, &propVal);
	}
	VARIANT GetConstrainNumeric()
	{
		VARIANT result;
		GetProperty(0x144, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetConstrainNumeric(VARIANT &propVal)
	{
		SetProperty(0x144, VT_VARIANT, &propVal);
	}
	VARIANT GetCopyObjectsWithCells()
	{
		VARIANT result;
		GetProperty(0x3df, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCopyObjectsWithCells(VARIANT &propVal)
	{
		SetProperty(0x3df, VT_VARIANT, &propVal);
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
	VARIANT GetCursor()
	{
		VARIANT result;
		GetProperty(0x489, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCursor(VARIANT &propVal)
	{
		SetProperty(0x489, VT_VARIANT, &propVal);
	}
	VARIANT GetCustomListCount()
	{
		VARIANT result;
		GetProperty(0x313, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCustomListCount(VARIANT &propVal)
	{
		SetProperty(0x313, VT_VARIANT, &propVal);
	}
	VARIANT GetCutCopyMode()
	{
		VARIANT result;
		GetProperty(0x14a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCutCopyMode(VARIANT &propVal)
	{
		SetProperty(0x14a, VT_VARIANT, &propVal);
	}
	VARIANT GetDataEntryMode()
	{
		VARIANT result;
		GetProperty(0x14b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDataEntryMode(VARIANT &propVal)
	{
		SetProperty(0x14b, VT_VARIANT, &propVal);
	}
	VARIANT GetDDEAppReturnCode()
	{
		VARIANT result;
		GetProperty(0x14c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDDEAppReturnCode(VARIANT &propVal)
	{
		SetProperty(0x14c, VT_VARIANT, &propVal);
	}
	VARIANT GetDefaultFilePath()
	{
		VARIANT result;
		GetProperty(0x40e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDefaultFilePath(VARIANT &propVal)
	{
		SetProperty(0x40e, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayAlerts()
	{
		VARIANT result;
		GetProperty(0x157, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayAlerts(VARIANT &propVal)
	{
		SetProperty(0x157, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayClipboardWindow()
	{
		VARIANT result;
		GetProperty(0x142, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayClipboardWindow(VARIANT &propVal)
	{
		SetProperty(0x142, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayExcel4Menus()
	{
		VARIANT result;
		GetProperty(0x39f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayExcel4Menus(VARIANT &propVal)
	{
		SetProperty(0x39f, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayFormulaBar()
	{
		VARIANT result;
		GetProperty(0x158, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayFormulaBar(VARIANT &propVal)
	{
		SetProperty(0x158, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayFullScreen()
	{
		VARIANT result;
		GetProperty(0x425, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayFullScreen(VARIANT &propVal)
	{
		SetProperty(0x425, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayInfoWindow()
	{
		VARIANT result;
		GetProperty(0x2fd, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayInfoWindow(VARIANT &propVal)
	{
		SetProperty(0x2fd, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayNoteIndicator()
	{
		VARIANT result;
		GetProperty(0x159, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayNoteIndicator(VARIANT &propVal)
	{
		SetProperty(0x159, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayRecentFiles()
	{
		VARIANT result;
		GetProperty(0x39e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayRecentFiles(VARIANT &propVal)
	{
		SetProperty(0x39e, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayScrollBars()
	{
		VARIANT result;
		GetProperty(0x15a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayScrollBars(VARIANT &propVal)
	{
		SetProperty(0x15a, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayStatusBar()
	{
		VARIANT result;
		GetProperty(0x15b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayStatusBar(VARIANT &propVal)
	{
		SetProperty(0x15b, VT_VARIANT, &propVal);
	}
	VARIANT GetEditDirectlyInCell()
	{
		VARIANT result;
		GetProperty(0x3a1, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEditDirectlyInCell(VARIANT &propVal)
	{
		SetProperty(0x3a1, VT_VARIANT, &propVal);
	}
	VARIANT GetEnableAnimations()
	{
		VARIANT result;
		GetProperty(0x49c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEnableAnimations(VARIANT &propVal)
	{
		SetProperty(0x49c, VT_VARIANT, &propVal);
	}
	VARIANT GetEnableAutoComplete()
	{
		VARIANT result;
		GetProperty(0x49b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEnableAutoComplete(VARIANT &propVal)
	{
		SetProperty(0x49b, VT_VARIANT, &propVal);
	}
	VARIANT GetEnableCancelKey()
	{
		VARIANT result;
		GetProperty(0x448, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEnableCancelKey(VARIANT &propVal)
	{
		SetProperty(0x448, VT_VARIANT, &propVal);
	}
	VARIANT GetEnableTipWizard()
	{
		VARIANT result;
		GetProperty(0x428, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEnableTipWizard(VARIANT &propVal)
	{
		SetProperty(0x428, VT_VARIANT, &propVal);
	}
	VARIANT GetFileConverters()
	{
		VARIANT result;
		GetProperty(0x3a3, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFileConverters(VARIANT &propVal)
	{
		SetProperty(0x3a3, VT_VARIANT, &propVal);
	}
	VARIANT GetFixedDecimal()
	{
		VARIANT result;
		GetProperty(0x15f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFixedDecimal(VARIANT &propVal)
	{
		SetProperty(0x15f, VT_VARIANT, &propVal);
	}
	VARIANT GetFixedDecimalPlaces()
	{
		VARIANT result;
		GetProperty(0x160, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFixedDecimalPlaces(VARIANT &propVal)
	{
		SetProperty(0x160, VT_VARIANT, &propVal);
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
	VARIANT GetIgnoreRemoteRequests()
	{
		VARIANT result;
		GetProperty(0x164, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetIgnoreRemoteRequests(VARIANT &propVal)
	{
		SetProperty(0x164, VT_VARIANT, &propVal);
	}
	VARIANT GetInteractive()
	{
		VARIANT result;
		GetProperty(0x169, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetInteractive(VARIANT &propVal)
	{
		SetProperty(0x169, VT_VARIANT, &propVal);
	}
	VARIANT GetInternational()
	{
		VARIANT result;
		GetProperty(0x16a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetInternational(VARIANT &propVal)
	{
		SetProperty(0x16a, VT_VARIANT, &propVal);
	}
	VARIANT GetIteration()
	{
		VARIANT result;
		GetProperty(0x16b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetIteration(VARIANT &propVal)
	{
		SetProperty(0x16b, VT_VARIANT, &propVal);
	}
	VARIANT GetLargeButtons()
	{
		VARIANT result;
		GetProperty(0x16c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLargeButtons(VARIANT &propVal)
	{
		SetProperty(0x16c, VT_VARIANT, &propVal);
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
	VARIANT GetLibraryPath()
	{
		VARIANT result;
		GetProperty(0x16e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLibraryPath(VARIANT &propVal)
	{
		SetProperty(0x16e, VT_VARIANT, &propVal);
	}
	VARIANT GetMailSession()
	{
		VARIANT result;
		GetProperty(0x3ae, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMailSession(VARIANT &propVal)
	{
		SetProperty(0x3ae, VT_VARIANT, &propVal);
	}
	VARIANT GetMailSystem()
	{
		VARIANT result;
		GetProperty(0x3cb, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMailSystem(VARIANT &propVal)
	{
		SetProperty(0x3cb, VT_VARIANT, &propVal);
	}
	VARIANT GetMathCoprocessorAvailable()
	{
		VARIANT result;
		GetProperty(0x16f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMathCoprocessorAvailable(VARIANT &propVal)
	{
		SetProperty(0x16f, VT_VARIANT, &propVal);
	}
	VARIANT GetMaxChange()
	{
		VARIANT result;
		GetProperty(0x170, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMaxChange(VARIANT &propVal)
	{
		SetProperty(0x170, VT_VARIANT, &propVal);
	}
	VARIANT GetMaxIterations()
	{
		VARIANT result;
		GetProperty(0x171, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMaxIterations(VARIANT &propVal)
	{
		SetProperty(0x171, VT_VARIANT, &propVal);
	}
	VARIANT GetMemoryFree()
	{
		VARIANT result;
		GetProperty(0x172, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMemoryFree(VARIANT &propVal)
	{
		SetProperty(0x172, VT_VARIANT, &propVal);
	}
	VARIANT GetMemoryTotal()
	{
		VARIANT result;
		GetProperty(0x173, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMemoryTotal(VARIANT &propVal)
	{
		SetProperty(0x173, VT_VARIANT, &propVal);
	}
	VARIANT GetMemoryUsed()
	{
		VARIANT result;
		GetProperty(0x174, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMemoryUsed(VARIANT &propVal)
	{
		SetProperty(0x174, VT_VARIANT, &propVal);
	}
	VARIANT GetMouseAvailable()
	{
		VARIANT result;
		GetProperty(0x175, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMouseAvailable(VARIANT &propVal)
	{
		SetProperty(0x175, VT_VARIANT, &propVal);
	}
	VARIANT GetMoveAfterReturn()
	{
		VARIANT result;
		GetProperty(0x176, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMoveAfterReturn(VARIANT &propVal)
	{
		SetProperty(0x176, VT_VARIANT, &propVal);
	}
	VARIANT GetMoveAfterReturnDirection()
	{
		VARIANT result;
		GetProperty(0x478, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMoveAfterReturnDirection(VARIANT &propVal)
	{
		SetProperty(0x478, VT_VARIANT, &propVal);
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
	VARIANT GetNetworkTemplatesPath()
	{
		VARIANT result;
		GetProperty(0x184, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetNetworkTemplatesPath(VARIANT &propVal)
	{
		SetProperty(0x184, VT_VARIANT, &propVal);
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
	VARIANT GetOnWindow()
	{
		VARIANT result;
		GetProperty(0x26f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnWindow(VARIANT &propVal)
	{
		SetProperty(0x26f, VT_VARIANT, &propVal);
	}
	VARIANT GetOperatingSystem()
	{
		VARIANT result;
		GetProperty(0x177, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOperatingSystem(VARIANT &propVal)
	{
		SetProperty(0x177, VT_VARIANT, &propVal);
	}
	VARIANT GetOrganizationName()
	{
		VARIANT result;
		GetProperty(0x178, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOrganizationName(VARIANT &propVal)
	{
		SetProperty(0x178, VT_VARIANT, &propVal);
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
	VARIANT GetPath()
	{
		VARIANT result;
		GetProperty(0x123, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPath(VARIANT &propVal)
	{
		SetProperty(0x123, VT_VARIANT, &propVal);
	}
	VARIANT GetPathSeparator()
	{
		VARIANT result;
		GetProperty(0x179, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPathSeparator(VARIANT &propVal)
	{
		SetProperty(0x179, VT_VARIANT, &propVal);
	}
	VARIANT GetPreviousSelections()
	{
		VARIANT result;
		GetProperty(0x17a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPreviousSelections(VARIANT &propVal)
	{
		SetProperty(0x17a, VT_VARIANT, &propVal);
	}
	VARIANT GetPromptForSummaryInfo()
	{
		VARIANT result;
		GetProperty(0x426, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPromptForSummaryInfo(VARIANT &propVal)
	{
		SetProperty(0x426, VT_VARIANT, &propVal);
	}
	VARIANT GetRecordRelative()
	{
		VARIANT result;
		GetProperty(0x17b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRecordRelative(VARIANT &propVal)
	{
		SetProperty(0x17b, VT_VARIANT, &propVal);
	}
	VARIANT GetReferenceStyle()
	{
		VARIANT result;
		GetProperty(0x17c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetReferenceStyle(VARIANT &propVal)
	{
		SetProperty(0x17c, VT_VARIANT, &propVal);
	}
	VARIANT GetRegisteredFunctions()
	{
		VARIANT result;
		GetProperty(0x307, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRegisteredFunctions(VARIANT &propVal)
	{
		SetProperty(0x307, VT_VARIANT, &propVal);
	}
	VARIANT GetScreenUpdating()
	{
		VARIANT result;
		GetProperty(0x17e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetScreenUpdating(VARIANT &propVal)
	{
		SetProperty(0x17e, VT_VARIANT, &propVal);
	}
	VARIANT GetSelection()
	{
		VARIANT result;
		GetProperty(0x93, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSelection(VARIANT &propVal)
	{
		SetProperty(0x93, VT_VARIANT, &propVal);
	}
	VARIANT GetSheetsInNewWorkbook()
	{
		VARIANT result;
		GetProperty(0x3e1, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSheetsInNewWorkbook(VARIANT &propVal)
	{
		SetProperty(0x3e1, VT_VARIANT, &propVal);
	}
	VARIANT GetShowToolTips()
	{
		VARIANT result;
		GetProperty(0x183, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetShowToolTips(VARIANT &propVal)
	{
		SetProperty(0x183, VT_VARIANT, &propVal);
	}
	VARIANT GetStandardFont()
	{
		VARIANT result;
		GetProperty(0x39c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetStandardFont(VARIANT &propVal)
	{
		SetProperty(0x39c, VT_VARIANT, &propVal);
	}
	VARIANT GetStandardFontSize()
	{
		VARIANT result;
		GetProperty(0x39d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetStandardFontSize(VARIANT &propVal)
	{
		SetProperty(0x39d, VT_VARIANT, &propVal);
	}
	VARIANT GetStartupPath()
	{
		VARIANT result;
		GetProperty(0x181, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetStartupPath(VARIANT &propVal)
	{
		SetProperty(0x181, VT_VARIANT, &propVal);
	}
	VARIANT GetStatusBar()
	{
		VARIANT result;
		GetProperty(0x182, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetStatusBar(VARIANT &propVal)
	{
		SetProperty(0x182, VT_VARIANT, &propVal);
	}
	VARIANT GetTemplatesPath()
	{
		VARIANT result;
		GetProperty(0x17d, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTemplatesPath(VARIANT &propVal)
	{
		SetProperty(0x17d, VT_VARIANT, &propVal);
	}
	VARIANT GetThisWorkbook()
	{
		VARIANT result;
		GetProperty(0x30a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetThisWorkbook(VARIANT &propVal)
	{
		SetProperty(0x30a, VT_VARIANT, &propVal);
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
	VARIANT GetTransitionMenuKey()
	{
		VARIANT result;
		GetProperty(0x136, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTransitionMenuKey(VARIANT &propVal)
	{
		SetProperty(0x136, VT_VARIANT, &propVal);
	}
	VARIANT GetTransitionMenuKeyAction()
	{
		VARIANT result;
		GetProperty(0x137, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTransitionMenuKeyAction(VARIANT &propVal)
	{
		SetProperty(0x137, VT_VARIANT, &propVal);
	}
	VARIANT GetTransitionNavigKeys()
	{
		VARIANT result;
		GetProperty(0x138, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTransitionNavigKeys(VARIANT &propVal)
	{
		SetProperty(0x138, VT_VARIANT, &propVal);
	}
	VARIANT GetUsableHeight()
	{
		VARIANT result;
		GetProperty(0x185, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetUsableHeight(VARIANT &propVal)
	{
		SetProperty(0x185, VT_VARIANT, &propVal);
	}
	VARIANT GetUsableWidth()
	{
		VARIANT result;
		GetProperty(0x186, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetUsableWidth(VARIANT &propVal)
	{
		SetProperty(0x186, VT_VARIANT, &propVal);
	}
	VARIANT GetUserName()
	{
		VARIANT result;
		GetProperty(0x187, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetUserName(VARIANT &propVal)
	{
		SetProperty(0x187, VT_VARIANT, &propVal);
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
	VARIANT GetVersion()
	{
		VARIANT result;
		GetProperty(0x188, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetVersion(VARIANT &propVal)
	{
		SetProperty(0x188, VT_VARIANT, &propVal);
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
	VARIANT GetWindowsForPens()
	{
		VARIANT result;
		GetProperty(0x18b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWindowsForPens(VARIANT &propVal)
	{
		SetProperty(0x18b, VT_VARIANT, &propVal);
	}
	VARIANT GetWindowState()
	{
		VARIANT result;
		GetProperty(0x18c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWindowState(VARIANT &propVal)
	{
		SetProperty(0x18c, VT_VARIANT, &propVal);
	}

};
// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CApplication0 wrapper class

