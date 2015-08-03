// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CSoundNote wrapper class

class CSoundNote : public COleDispatchDriver
{
public:
	CSoundNote(){} // Calls COleDispatchDriver default constructor
	CSoundNote(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CSoundNote(const CSoundNote& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// SoundNote methods
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
	VARIANT Import(VARIANT& Filename)
	{
		VARIANT result;
		static BYTE parms[] = VTS_VARIANT ;
		InvokeHelper(0x395, DISPATCH_METHOD, VT_VARIANT, (void*)&result, parms, &Filename);
		return result;
	}
	VARIANT Play()
	{
		VARIANT result;
		InvokeHelper(0x396, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Record()
	{
		VARIANT result;
		InvokeHelper(0x397, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// SoundNote properties
public:
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
