// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CRange wrapper class

class CRange : public COleDispatchDriver
{
public:
	CRange(){} // Calls COleDispatchDriver default constructor
	CRange(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CRange(const CRange& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Range methods
public:
	VARIANT _Dummy(VARIANT& Activate, VARIANT& DirectObject)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x0, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Activate, &DirectObject);
		return result;
	}
	VARIANT _NewEnum()
	{
		VARIANT result;
		InvokeHelper(0x2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Activate()
	{
		VARIANT result;
		InvokeHelper(0x130, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Address(VARIANT& RowAbsolute, VARIANT& ColumnAbsolute, VARIANT& ReferenceStyle, VARIANT& External, VARIANT& RelativeTo)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xec, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &RowAbsolute, &ColumnAbsolute, &ReferenceStyle, &External, &RelativeTo);
		return result;
	}
	VARIANT AddressLocal(VARIANT& RowAbsolute, VARIANT& ColumnAbsolute, VARIANT& ReferenceStyle, VARIANT& External, VARIANT& RelativeTo)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1b5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &RowAbsolute, &ColumnAbsolute, &ReferenceStyle, &External, &RelativeTo);
		return result;
	}
	VARIANT AdvancedFilter(VARIANT& Action, VARIANT& CriteriaRange, VARIANT& CopyToRange, VARIANT& Unique)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x36c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Action, &CriteriaRange, &CopyToRange, &Unique);
		return result;
	}
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ApplyNames(VARIANT& Names, VARIANT& IgnoreRelativeAbsolute, VARIANT& UseRowColumnNames, VARIANT& OmitColumn, VARIANT& OmitRow, VARIANT& Order, VARIANT& AppendLast)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1b9, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Names, &IgnoreRelativeAbsolute, &UseRowColumnNames, &OmitColumn, &OmitRow, &Order, &AppendLast);
		return result;
	}
	VARIANT ApplyOutlineStyles()
	{
		VARIANT result;
		InvokeHelper(0x1c0, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Areas(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x238, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT AutoComplete(VARIANT& String)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x4a1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &String);
		return result;
	}
	VARIANT AutoFill(VARIANT& Destination, VARIANT& Type)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1c1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Destination, &Type);
		return result;
	}
	VARIANT AutoFilter(VARIANT& Field, VARIANT& Criteria1, VARIANT& Operator, VARIANT& Criteria2)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x319, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Field, &Criteria1, &Operator, &Criteria2);
		return result;
	}
	VARIANT AutoFit()
	{
		VARIANT result;
		InvokeHelper(0xed, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT AutoFormat(VARIANT& Format, VARIANT& Number, VARIANT& Font, VARIANT& Alignment, VARIANT& Border, VARIANT& Pattern, VARIANT& Width)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x72, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Format, &Number, &Font, &Alignment, &Border, &Pattern, &Width);
		return result;
	}
	VARIANT AutoOutline()
	{
		VARIANT result;
		InvokeHelper(0x40c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT BorderAround(VARIANT& LineStyle, VARIANT& Weight, VARIANT& ColorIndex, VARIANT& Color)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x42b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &LineStyle, &Weight, &ColorIndex, &Color);
		return result;
	}
	VARIANT Borders(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1b3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
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
	VARIANT Clear()
	{
		VARIANT result;
		InvokeHelper(0x6f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ClearContents()
	{
		VARIANT result;
		InvokeHelper(0x71, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ClearFormats()
	{
		VARIANT result;
		InvokeHelper(0x70, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ClearNotes()
	{
		VARIANT result;
		InvokeHelper(0xef, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ClearOutline()
	{
		VARIANT result;
		InvokeHelper(0x40d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ColumnDifferences(VARIANT& Comparison)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1fe, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Comparison);
		return result;
	}
	VARIANT Columns(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xf1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Consolidate(VARIANT& Sources, VARIANT& Function, VARIANT& TopRow, VARIANT& LeftColumn, VARIANT& CreateLinks)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1e2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Sources, &Function, &TopRow, &LeftColumn, &CreateLinks);
		return result;
	}
	VARIANT Copy(VARIANT& Destination)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x227, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Destination);
		return result;
	}
	VARIANT CopyFromRecordset(VARIANT& Data, VARIANT& MaxRows, VARIANT& MaxColumns)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x480, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Data, &MaxRows, &MaxColumns);
		return result;
	}
	VARIANT CopyPicture(VARIANT& Appearance, VARIANT& Format)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xd5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Appearance, &Format);
		return result;
	}
	VARIANT CreateNames(VARIANT& Top, VARIANT& Left, VARIANT& Bottom, VARIANT& Right)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1c9, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Top, &Left, &Bottom, &Right);
		return result;
	}
	VARIANT CreatePublisher(VARIANT& Edition, VARIANT& Appearance, VARIANT& ContainsPICT, VARIANT& ContainsBIFF, VARIANT& ContainsRTF, VARIANT& ContainsVALU)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1ca, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Edition, &Appearance, &ContainsPICT, &ContainsBIFF, &ContainsRTF, &ContainsVALU);
		return result;
	}
	VARIANT Cut(VARIANT& Destination)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x235, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Destination);
		return result;
	}
	VARIANT DataSeries(VARIANT& Rowcol, VARIANT& Type, VARIANT& Date, VARIANT& Step, VARIANT& Stop, VARIANT& Trend)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1d0, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Rowcol, &Type, &Date, &Step, &Stop, &Trend);
		return result;
	}
	VARIANT Delete(VARIANT& Shift)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x75, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Shift);
		return result;
	}
	/*VARIANT DialogBox()
	{
		VARIANT result;
		InvokeHelper(0xf5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}*/
	VARIANT End(VARIANT& Direction)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1f4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Direction);
		return result;
	}
	VARIANT FillDown()
	{
		VARIANT result;
		InvokeHelper(0xf8, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT FillLeft()
	{
		VARIANT result;
		InvokeHelper(0xf9, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT FillRight()
	{
		VARIANT result;
		InvokeHelper(0xfa, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT FillUp()
	{
		VARIANT result;
		InvokeHelper(0xfb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Find(VARIANT& What, VARIANT& After, VARIANT& LookIn, VARIANT& LookAt, VARIANT& SearchOrder, VARIANT& SearchDirection, VARIANT& MatchCase, VARIANT& MatchByte)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x18e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &What, &After, &LookIn, &LookAt, &SearchOrder, &SearchDirection, &MatchCase, &MatchByte);
		return result;
	}
	VARIANT FindNext(VARIANT& After)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x18f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &After);
		return result;
	}
	VARIANT FindPrevious(VARIANT& After)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x190, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &After);
		return result;
	}
	VARIANT FunctionWizard()
	{
		VARIANT result;
		InvokeHelper(0x23b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT GoalSeek(VARIANT& Goal, VARIANT& ChangingCell)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1d8, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Goal, &ChangingCell);
		return result;
	}
	VARIANT Group(VARIANT& Start, VARIANT& End, VARIANT& By, VARIANT& Periods)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x2e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Start, &End, &By, &Periods);
		return result;
	}
	VARIANT Insert(VARIANT& Shift)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xfc, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Shift);
		return result;
	}
	VARIANT Item(VARIANT& RowIndex, VARIANT& ColumnIndex)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xaa, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &RowIndex, &ColumnIndex);
		return result;
	}
	VARIANT Justify()
	{
		VARIANT result;
		InvokeHelper(0x1ef, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ListNames()
	{
		VARIANT result;
		InvokeHelper(0xfd, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT NavigateArrow(VARIANT& TowardPrecedent, VARIANT& ArrowNumber, VARIANT& LinkNumber)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x408, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &TowardPrecedent, &ArrowNumber, &LinkNumber);
		return result;
	}
	VARIANT NoteText(VARIANT& Text, VARIANT& Start, VARIANT& Length)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x467, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Text, &Start, &Length);
		return result;
	}
	VARIANT Offset(VARIANT& RowOffset, VARIANT& ColumnOffset)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xfe, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &RowOffset, &ColumnOffset);
		return result;
	}
	VARIANT Parse(VARIANT& ParseLine, VARIANT& Destination)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1dd, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &ParseLine, &Destination);
		return result;
	}
	VARIANT PasteSpecial(VARIANT& Paste, VARIANT& Operation, VARIANT& SkipBlanks, VARIANT& Transpose)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x403, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Paste, &Operation, &SkipBlanks, &Transpose);
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
	VARIANT Range(VARIANT& Cell1, VARIANT& Cell2)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xc5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Cell1, &Cell2);
		return result;
	}
	VARIANT RemoveSubtotal()
	{
		VARIANT result;
		InvokeHelper(0x373, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Replace(VARIANT& What, VARIANT& Replacement, VARIANT& LookAt, VARIANT& SearchOrder, VARIANT& MatchCase, VARIANT& MatchByte)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0xe2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &What, &Replacement, &LookAt, &SearchOrder, &MatchCase, &MatchByte);
		return result;
	}
	VARIANT Resize(VARIANT& RowSize, VARIANT& ColumnSize)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x100, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &RowSize, &ColumnSize);
		return result;
	}
	VARIANT RowDifferences(VARIANT& Comparison)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1ff, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Comparison);
		return result;
	}
	VARIANT Rows(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x102, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Run(VARIANT& Arg1, VARIANT& Arg2, VARIANT& Arg3, VARIANT& Arg4, VARIANT& Arg5, VARIANT& Arg6, VARIANT& Arg7, VARIANT& Arg8, VARIANT& Arg9, VARIANT& Arg10, VARIANT& Arg11, VARIANT& Arg12, VARIANT& Arg13, VARIANT& Arg14, VARIANT& Arg15, VARIANT& Arg16, VARIANT& Arg17, VARIANT& Arg18, VARIANT& Arg19, VARIANT& Arg20, VARIANT& Arg21, VARIANT& Arg22, VARIANT& Arg23, VARIANT& Arg24, VARIANT& Arg25, VARIANT& Arg26, VARIANT& Arg27, VARIANT& Arg28, VARIANT& Arg29, VARIANT& Arg30)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x103, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Arg1, &Arg2, &Arg3, &Arg4, &Arg5, &Arg6, &Arg7, &Arg8, &Arg9, &Arg10, &Arg11, &Arg12, &Arg13, &Arg14, &Arg15, &Arg16, &Arg17, &Arg18, &Arg19, &Arg20, &Arg21, &Arg22, &Arg23, &Arg24, &Arg25, &Arg26, &Arg27, &Arg28, &Arg29, &Arg30);
		return result;
	}
	VARIANT Select()
	{
		VARIANT result;
		InvokeHelper(0xeb, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Show()
	{
		VARIANT result;
		InvokeHelper(0x1f0, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ShowDependents(VARIANT& Remove)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x36d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Remove);
		return result;
	}
	VARIANT ShowErrors()
	{
		VARIANT result;
		InvokeHelper(0x36e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ShowPrecedents(VARIANT& Remove)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x36f, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Remove);
		return result;
	}
	VARIANT Sort(VARIANT& Key1, VARIANT& Order1, VARIANT& Key2, VARIANT& Type, VARIANT& Order2, VARIANT& Key3, VARIANT& Order3, VARIANT& Header, VARIANT& OrderCustom, VARIANT& MatchCase, VARIANT& Orientation)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x370, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Key1, &Order1, &Key2, &Type, &Order2, &Key3, &Order3, &Header, &OrderCustom, &MatchCase, &Orientation);
		return result;
	}
	VARIANT SortSpecial(VARIANT& SortMethod, VARIANT& Key1, VARIANT& Order1, VARIANT& Type, VARIANT& Key2, VARIANT& Order2, VARIANT& Key3, VARIANT& Order3, VARIANT& Header, VARIANT& OrderCustom, VARIANT& MatchCase, VARIANT& Orientation)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x371, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &SortMethod, &Key1, &Order1, &Type, &Key2, &Order2, &Key3, &Order3, &Header, &OrderCustom, &MatchCase, &Orientation);
		return result;
	}
	VARIANT SpecialCells(VARIANT& Type, VARIANT& Value)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x19a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Type, &Value);
		return result;
	}
	VARIANT SubscribeTo(VARIANT& Edition, VARIANT& Format)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1e1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Edition, &Format);
		return result;
	}
	VARIANT Subtotal(VARIANT& GroupBy, VARIANT& Function, VARIANT& TotalList, VARIANT& Replace, VARIANT& PageBreaks, VARIANT& SummaryBelowData)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x372, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &GroupBy, &Function, &TotalList, &Replace, &PageBreaks, &SummaryBelowData);
		return result;
	}
	VARIANT Table(VARIANT& RowInput, VARIANT& ColumnInput)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x1f1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &RowInput, &ColumnInput);
		return result;
	}
	VARIANT TextToColumns(VARIANT& Destination, VARIANT& DataType, VARIANT& TextQualifier, VARIANT& ConsecutiveDelimiter, VARIANT& Tab, VARIANT& Semicolon, VARIANT& Comma, VARIANT& Space, VARIANT& Other, VARIANT& OtherChar, VARIANT& FieldInfo)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x410, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Destination, &DataType, &TextQualifier, &ConsecutiveDelimiter, &Tab, &Semicolon, &Comma, &Space, &Other, &OtherChar, &FieldInfo);
		return result;
	}
	VARIANT Ungroup()
	{
		VARIANT result;
		InvokeHelper(0xf4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Worksheet()
	{
		VARIANT result;
		InvokeHelper(0x15c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// Range properties
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
	VARIANT GetColumn()
	{
		VARIANT result;
		GetProperty(0xf0, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetColumn(VARIANT &propVal)
	{
		SetProperty(0xf0, VT_VARIANT, &propVal);
	}
	VARIANT GetColumnWidth()
	{
		VARIANT result;
		GetProperty(0xf2, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetColumnWidth(VARIANT &propVal)
	{
		SetProperty(0xf2, VT_VARIANT, &propVal);
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
	VARIANT GetCurrentArray()
	{
		VARIANT result;
		GetProperty(0x1f5, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCurrentArray(VARIANT &propVal)
	{
		SetProperty(0x1f5, VT_VARIANT, &propVal);
	}
	VARIANT GetCurrentRegion()
	{
		VARIANT result;
		GetProperty(0xf3, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCurrentRegion(VARIANT &propVal)
	{
		SetProperty(0xf3, VT_VARIANT, &propVal);
	}
	VARIANT GetDependents()
	{
		VARIANT result;
		GetProperty(0x21f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDependents(VARIANT &propVal)
	{
		SetProperty(0x21f, VT_VARIANT, &propVal);
	}
	VARIANT GetDirectDependents()
	{
		VARIANT result;
		GetProperty(0x221, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDirectDependents(VARIANT &propVal)
	{
		SetProperty(0x221, VT_VARIANT, &propVal);
	}
	VARIANT GetDirectPrecedents()
	{
		VARIANT result;
		GetProperty(0x222, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDirectPrecedents(VARIANT &propVal)
	{
		SetProperty(0x222, VT_VARIANT, &propVal);
	}
	VARIANT GetEntireColumn()
	{
		VARIANT result;
		GetProperty(0xf6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEntireColumn(VARIANT &propVal)
	{
		SetProperty(0xf6, VT_VARIANT, &propVal);
	}
	VARIANT GetEntireRow()
	{
		VARIANT result;
		GetProperty(0xf7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEntireRow(VARIANT &propVal)
	{
		SetProperty(0xf7, VT_VARIANT, &propVal);
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
	VARIANT GetFormulaArray()
	{
		VARIANT result;
		GetProperty(0x24a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFormulaArray(VARIANT &propVal)
	{
		SetProperty(0x24a, VT_VARIANT, &propVal);
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
	VARIANT GetFormulaLocal()
	{
		VARIANT result;
		GetProperty(0x107, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFormulaLocal(VARIANT &propVal)
	{
		SetProperty(0x107, VT_VARIANT, &propVal);
	}
	VARIANT GetFormulaR1C1()
	{
		VARIANT result;
		GetProperty(0x108, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFormulaR1C1(VARIANT &propVal)
	{
		SetProperty(0x108, VT_VARIANT, &propVal);
	}
	VARIANT GetFormulaR1C1Local()
	{
		VARIANT result;
		GetProperty(0x109, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFormulaR1C1Local(VARIANT &propVal)
	{
		SetProperty(0x109, VT_VARIANT, &propVal);
	}
	VARIANT GetHasArray()
	{
		VARIANT result;
		GetProperty(0x10a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasArray(VARIANT &propVal)
	{
		SetProperty(0x10a, VT_VARIANT, &propVal);
	}
	VARIANT GetHasFormula()
	{
		VARIANT result;
		GetProperty(0x10b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasFormula(VARIANT &propVal)
	{
		SetProperty(0x10b, VT_VARIANT, &propVal);
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
	VARIANT GetHidden()
	{
		VARIANT result;
		GetProperty(0x10c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHidden(VARIANT &propVal)
	{
		SetProperty(0x10c, VT_VARIANT, &propVal);
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
	VARIANT GetListHeaderRows()
	{
		VARIANT result;
		GetProperty(0x4a3, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetListHeaderRows(VARIANT &propVal)
	{
		SetProperty(0x4a3, VT_VARIANT, &propVal);
	}
	VARIANT GetLocationInTable()
	{
		VARIANT result;
		GetProperty(0x2b3, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetLocationInTable(VARIANT &propVal)
	{
		SetProperty(0x2b3, VT_VARIANT, &propVal);
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
	VARIANT GetOutlineLevel()
	{
		VARIANT result;
		GetProperty(0x10f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOutlineLevel(VARIANT &propVal)
	{
		SetProperty(0x10f, VT_VARIANT, &propVal);
	}
	VARIANT GetPageBreak()
	{
		VARIANT result;
		GetProperty(0xff, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPageBreak(VARIANT &propVal)
	{
		SetProperty(0xff, VT_VARIANT, &propVal);
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
	VARIANT GetPivotField()
	{
		VARIANT result;
		GetProperty(0x2db, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPivotField(VARIANT &propVal)
	{
		SetProperty(0x2db, VT_VARIANT, &propVal);
	}
	VARIANT GetPivotItem()
	{
		VARIANT result;
		GetProperty(0x2e4, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPivotItem(VARIANT &propVal)
	{
		SetProperty(0x2e4, VT_VARIANT, &propVal);
	}
	VARIANT GetPivotTable()
	{
		VARIANT result;
		GetProperty(0x2cc, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPivotTable(VARIANT &propVal)
	{
		SetProperty(0x2cc, VT_VARIANT, &propVal);
	}
	VARIANT GetPrecedents()
	{
		VARIANT result;
		GetProperty(0x220, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrecedents(VARIANT &propVal)
	{
		SetProperty(0x220, VT_VARIANT, &propVal);
	}
	VARIANT GetPrefixCharacter()
	{
		VARIANT result;
		GetProperty(0x1f8, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrefixCharacter(VARIANT &propVal)
	{
		SetProperty(0x1f8, VT_VARIANT, &propVal);
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
	VARIANT GetRow()
	{
		VARIANT result;
		GetProperty(0x101, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRow(VARIANT &propVal)
	{
		SetProperty(0x101, VT_VARIANT, &propVal);
	}
	VARIANT GetRowHeight()
	{
		VARIANT result;
		GetProperty(0x110, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRowHeight(VARIANT &propVal)
	{
		SetProperty(0x110, VT_VARIANT, &propVal);
	}
	VARIANT GetShowDetail()
	{
		VARIANT result;
		GetProperty(0x249, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetShowDetail(VARIANT &propVal)
	{
		SetProperty(0x249, VT_VARIANT, &propVal);
	}
	VARIANT GetSoundNote()
	{
		VARIANT result;
		GetProperty(0x394, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSoundNote(VARIANT &propVal)
	{
		SetProperty(0x394, VT_VARIANT, &propVal);
	}
	VARIANT GetStyle()
	{
		VARIANT result;
		GetProperty(0x104, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetStyle(VARIANT &propVal)
	{
		SetProperty(0x104, VT_VARIANT, &propVal);
	}
	VARIANT GetSummary()
	{
		VARIANT result;
		GetProperty(0x111, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSummary(VARIANT &propVal)
	{
		SetProperty(0x111, VT_VARIANT, &propVal);
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
	VARIANT GetUseStandardHeight()
	{
		VARIANT result;
		GetProperty(0x112, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetUseStandardHeight(VARIANT &propVal)
	{
		SetProperty(0x112, VT_VARIANT, &propVal);
	}
	VARIANT GetUseStandardWidth()
	{
		VARIANT result;
		GetProperty(0x113, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetUseStandardWidth(VARIANT &propVal)
	{
		SetProperty(0x113, VT_VARIANT, &propVal);
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
