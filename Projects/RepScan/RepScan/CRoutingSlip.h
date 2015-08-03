// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CRoutingSlip wrapper class

class CRoutingSlip : public COleDispatchDriver
{
public:
	CRoutingSlip(){} // Calls COleDispatchDriver default constructor
	CRoutingSlip(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CRoutingSlip(const CRoutingSlip& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// RoutingSlip methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}
	VARIANT Reset()
	{
		VARIANT result;
		InvokeHelper(0x22b, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// RoutingSlip properties
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
	VARIANT GetDelivery()
	{
		VARIANT result;
		GetProperty(0x3bb, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetDelivery(VARIANT &propVal)
	{
		SetProperty(0x3bb, VT_VARIANT, &propVal);
	}
	VARIANT GetMessage()
	{
		VARIANT result;
		GetProperty(0x3ba, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetMessage(VARIANT &propVal)
	{
		SetProperty(0x3ba, VT_VARIANT, &propVal);
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
	VARIANT GetRecipients()
	{
		VARIANT result;
		GetProperty(0x3b8, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetRecipients(VARIANT &propVal)
	{
		SetProperty(0x3b8, VT_VARIANT, &propVal);
	}
	VARIANT GetReturnWhenDone()
	{
		VARIANT result;
		GetProperty(0x3bc, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetReturnWhenDone(VARIANT &propVal)
	{
		SetProperty(0x3bc, VT_VARIANT, &propVal);
	}
	VARIANT GetStatus()
	{
		VARIANT result;
		GetProperty(0x3be, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetStatus(VARIANT &propVal)
	{
		SetProperty(0x3be, VT_VARIANT, &propVal);
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
	VARIANT GetTrackStatus()
	{
		VARIANT result;
		GetProperty(0x3bd, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetTrackStatus(VARIANT &propVal)
	{
		SetProperty(0x3bd, VT_VARIANT, &propVal);
	}

};
