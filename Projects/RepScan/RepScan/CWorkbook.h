// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CWorkbook wrapper class

class CWorkbook : public COleDispatchDriver
{
public:
	CWorkbook(){} // Calls COleDispatchDriver default constructor
	CWorkbook(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CWorkbook(const CWorkbook& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Workbook methods
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
	VARIANT BuiltinDocumentProperties(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x498, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT ChangeFileAccess(VARIANT& Mode, VARIANT& WritePassword, VARIANT& Notify)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x3dd, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Mode, &WritePassword, &Notify);
		return result;
	}
	VARIANT ChangeLink(VARIANT& Name, VARIANT& NewName, VARIANT& Type)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x322, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Name, &NewName, &Type);
		return result;
	}
	VARIANT Charts(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x79, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Close(VARIANT& SaveChanges, VARIANT& Filename, VARIANT& RouteWorkbook)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x115, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &SaveChanges, &Filename, &RouteWorkbook);
		return result;
	}
	VARIANT CustomDocumentProperties(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x499, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT DeleteNumberFormat(VARIANT& NumberFormat)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x18d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &NumberFormat);
		return result;
	}
	VARIANT DialogSheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x2fc, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
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
	VARIANT ExclusiveAccess()
	{
		VARIANT result;
		InvokeHelper(0x490, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ForwardMailer()
	{
		VARIANT result;
		InvokeHelper(0x3cd, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT LinkInfo(VARIANT& Name, VARIANT& LinkInfo, VARIANT& Type, VARIANT& EditionRef)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x327, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Name, &LinkInfo, &Type, &EditionRef);
		return result;
	}
	VARIANT LinkSources(VARIANT& Type)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x328, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Type);
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
	VARIANT NewWindow()
	{
		VARIANT result;
		InvokeHelper(0x118, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT OpenLinks(VARIANT& Name, VARIANT& ReadOnly, VARIANT& Type)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x323, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Name, &ReadOnly, &Type);
		return result;
	}
	VARIANT Post(VARIANT& DestName)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x48e, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &DestName);
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
	VARIANT Protect(VARIANT& Password, VARIANT& Structure, VARIANT& Windows)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x11a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Password, &Structure, &Windows);
		return result;
	}
	VARIANT Reply()
	{
		VARIANT result;
		InvokeHelper(0x3d1, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT ReplyAll()
	{
		VARIANT result;
		InvokeHelper(0x3d2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Route()
	{
		VARIANT result;
		InvokeHelper(0x3b2, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT RunAutoMacros(VARIANT& Which)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x27a, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Which);
		return result;
	}
	VARIANT Save()
	{
		VARIANT result;
		InvokeHelper(0x11b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT SaveAs(VARIANT& Filename, VARIANT& FileFormat, VARIANT& Password, VARIANT& WriteResPassword, VARIANT& ReadOnlyRecommended, VARIANT& CreateBackup, VARIANT& AccessMode, VARIANT& ConflictResolution)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x11c, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename, &FileFormat, &Password, &WriteResPassword, &ReadOnlyRecommended, &CreateBackup, &AccessMode, &ConflictResolution);
		return result;
	}
	VARIANT SaveCopyAs(VARIANT& Filename)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0xaf, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename);
		return result;
	}
	VARIANT SendMail(VARIANT& Recipients, VARIANT& Subject, VARIANT& ReturnReceipt)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x3b3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Recipients, &Subject, &ReturnReceipt);
		return result;
	}
	VARIANT SendMailer(VARIANT& FileFormat, VARIANT& Priority)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x3d4, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &FileFormat, &Priority);
		return result;
	}
	VARIANT SetLinkOnData(VARIANT& Name, VARIANT& Procedure)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x329, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Name, &Procedure);
		return result;
	}
	VARIANT Sheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1e5, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Styles(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1ed, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Unprotect(VARIANT& Password)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x11d, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Password);
		return result;
	}
	VARIANT UpdateFromFile()
	{
		VARIANT result;
		InvokeHelper(0x3e3, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT UpdateLink(VARIANT& Name, VARIANT& Type)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT VTS_VARIANT ;
		InvokeHelper(0x324, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Name, &Type);
		return result;
	}
	VARIANT Windows(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1ae, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}
	VARIANT Worksheets(VARIANT& Index)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x1ee, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Index);
		return result;
	}

	// Workbook properties
public:
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
	VARIANT GetAuthor()
	{
		VARIANT result;
		GetProperty(0x23e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetAuthor(VARIANT &propVal)
	{
		SetProperty(0x23e, VT_VARIANT, &propVal);
	}
	VARIANT GetColors()
	{
		VARIANT result;
		GetProperty(0x11e, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetColors(VARIANT &propVal)
	{
		SetProperty(0x11e, VT_VARIANT, &propVal);
	}
	VARIANT GetComments()
	{
		VARIANT result;
		GetProperty(0x23f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetComments(VARIANT &propVal)
	{
		SetProperty(0x23f, VT_VARIANT, &propVal);
	}
	VARIANT GetContainer()
	{
		VARIANT result;
		GetProperty(0x4a6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetContainer(VARIANT &propVal)
	{
		SetProperty(0x4a6, VT_VARIANT, &propVal);
	}
	VARIANT GetCreateBackup()
	{
		VARIANT result;
		GetProperty(0x11f, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCreateBackup(VARIANT &propVal)
	{
		SetProperty(0x11f, VT_VARIANT, &propVal);
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
	VARIANT GetDate1904()
	{
		VARIANT result;
		GetProperty(0x193, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDate1904(VARIANT &propVal)
	{
		SetProperty(0x193, VT_VARIANT, &propVal);
	}
	VARIANT GetDisplayDrawingObjects()
	{
		VARIANT result;
		GetProperty(0x194, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDisplayDrawingObjects(VARIANT &propVal)
	{
		SetProperty(0x194, VT_VARIANT, &propVal);
	}
	VARIANT GetFileFormat()
	{
		VARIANT result;
		GetProperty(0x120, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFileFormat(VARIANT &propVal)
	{
		SetProperty(0x120, VT_VARIANT, &propVal);
	}
	VARIANT GetFullName()
	{
		VARIANT result;
		GetProperty(0x121, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetFullName(VARIANT &propVal)
	{
		SetProperty(0x121, VT_VARIANT, &propVal);
	}
	VARIANT GetHasMailer()
	{
		VARIANT result;
		GetProperty(0x3d0, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasMailer(VARIANT &propVal)
	{
		SetProperty(0x3d0, VT_VARIANT, &propVal);
	}
	VARIANT GetHasPassword()
	{
		VARIANT result;
		GetProperty(0x122, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasPassword(VARIANT &propVal)
	{
		SetProperty(0x122, VT_VARIANT, &propVal);
	}
	VARIANT GetHasRoutingSlip()
	{
		VARIANT result;
		GetProperty(0x3b6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetHasRoutingSlip(VARIANT &propVal)
	{
		SetProperty(0x3b6, VT_VARIANT, &propVal);
	}
	VARIANT GetKeywords()
	{
		VARIANT result;
		GetProperty(0x241, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetKeywords(VARIANT &propVal)
	{
		SetProperty(0x241, VT_VARIANT, &propVal);
	}
	VARIANT GetMailer()
	{
		VARIANT result;
		GetProperty(0x3d3, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMailer(VARIANT &propVal)
	{
		SetProperty(0x3d3, VT_VARIANT, &propVal);
	}
	VARIANT GetMultiUserEditing()
	{
		VARIANT result;
		GetProperty(0x491, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMultiUserEditing(VARIANT &propVal)
	{
		SetProperty(0x491, VT_VARIANT, &propVal);
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
	VARIANT GetOnSave()
	{
		VARIANT result;
		GetProperty(0x49a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetOnSave(VARIANT &propVal)
	{
		SetProperty(0x49a, VT_VARIANT, &propVal);
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
	VARIANT GetPrecisionAsDisplayed()
	{
		VARIANT result;
		GetProperty(0x195, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetPrecisionAsDisplayed(VARIANT &propVal)
	{
		SetProperty(0x195, VT_VARIANT, &propVal);
	}
	VARIANT GetProtectStructure()
	{
		VARIANT result;
		GetProperty(0x24c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetProtectStructure(VARIANT &propVal)
	{
		SetProperty(0x24c, VT_VARIANT, &propVal);
	}
	VARIANT GetProtectWindows()
	{
		VARIANT result;
		GetProperty(0x127, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetProtectWindows(VARIANT &propVal)
	{
		SetProperty(0x127, VT_VARIANT, &propVal);
	}
	VARIANT GetReadOnly()
	{
		VARIANT result;
		GetProperty(0x128, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetReadOnly(VARIANT &propVal)
	{
		SetProperty(0x128, VT_VARIANT, &propVal);
	}
	VARIANT GetReadOnlyRecommended()
	{
		VARIANT result;
		GetProperty(0x129, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetReadOnlyRecommended(VARIANT &propVal)
	{
		SetProperty(0x129, VT_VARIANT, &propVal);
	}
	VARIANT GetRevisionNumber()
	{
		VARIANT result;
		GetProperty(0x494, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRevisionNumber(VARIANT &propVal)
	{
		SetProperty(0x494, VT_VARIANT, &propVal);
	}
	VARIANT GetRouted()
	{
		VARIANT result;
		GetProperty(0x3b7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRouted(VARIANT &propVal)
	{
		SetProperty(0x3b7, VT_VARIANT, &propVal);
	}
	VARIANT GetRoutingSlip()
	{
		VARIANT result;
		GetProperty(0x3b5, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRoutingSlip(VARIANT &propVal)
	{
		SetProperty(0x3b5, VT_VARIANT, &propVal);
	}
	VARIANT GetSaved()
	{
		VARIANT result;
		GetProperty(0x12a, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSaved(VARIANT &propVal)
	{
		SetProperty(0x12a, VT_VARIANT, &propVal);
	}
	VARIANT GetSaveLinkValues()
	{
		VARIANT result;
		GetProperty(0x196, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSaveLinkValues(VARIANT &propVal)
	{
		SetProperty(0x196, VT_VARIANT, &propVal);
	}
	VARIANT GetShowConflictHistory()
	{
		VARIANT result;
		GetProperty(0x493, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetShowConflictHistory(VARIANT &propVal)
	{
		SetProperty(0x493, VT_VARIANT, &propVal);
	}
	VARIANT GetSubject()
	{
		VARIANT result;
		GetProperty(0x3b9, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSubject(VARIANT &propVal)
	{
		SetProperty(0x3b9, VT_VARIANT, &propVal);
	}
	VARIANT GetTitle()
	{
		VARIANT result;
		GetProperty(0xc7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTitle(VARIANT &propVal)
	{
		SetProperty(0xc7, VT_VARIANT, &propVal);
	}
	VARIANT GetUpdateRemoteReferences()
	{
		VARIANT result;
		GetProperty(0x19b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetUpdateRemoteReferences(VARIANT &propVal)
	{
		SetProperty(0x19b, VT_VARIANT, &propVal);
	}
	VARIANT GetUserStatus()
	{
		VARIANT result;
		GetProperty(0x495, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetUserStatus(VARIANT &propVal)
	{
		SetProperty(0x495, VT_VARIANT, &propVal);
	}
	VARIANT GetWriteReserved()
	{
		VARIANT result;
		GetProperty(0x12b, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWriteReserved(VARIANT &propVal)
	{
		SetProperty(0x12b, VT_VARIANT, &propVal);
	}
	VARIANT GetWriteReservedBy()
	{
		VARIANT result;
		GetProperty(0x12c, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWriteReservedBy(VARIANT &propVal)
	{
		SetProperty(0x12c, VT_VARIANT, &propVal);
	}

};
