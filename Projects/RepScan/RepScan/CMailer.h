// Machine generated IDispatch wrapper class(es) created with Add Class from Typelib Wizard

//#import "C:\\Program Files\\Microsoft Office\\Office12\\XL5EN32.OLB" no_namespace
// CMailer wrapper class

class CMailer : public COleDispatchDriver
{
public:
	CMailer(){} // Calls COleDispatchDriver default constructor
	CMailer(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	CMailer(const CMailer& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

	// Attributes
public:

	// Operations
public:


	// Mailer methods
public:
	VARIANT Application()
	{
		VARIANT result;
		InvokeHelper(0x94, DISPATCH_METHOD, VT_VARIANT, (void*)&result, NULL);
		return result;
	}

	// Mailer properties
public:
	VARIANT GetBCCRecipients()
	{
		VARIANT result;
		GetProperty(0x3d7, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetBCCRecipients(VARIANT &propVal)
	{
		SetProperty(0x3d7, VT_VARIANT, &propVal);
	}
	VARIANT GetCCRecipients()
	{
		VARIANT result;
		GetProperty(0x3d6, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetCCRecipients(VARIANT &propVal)
	{
		SetProperty(0x3d6, VT_VARIANT, &propVal);
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
	VARIANT GetEnclosures()
	{
		VARIANT result;
		GetProperty(0x3d8, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetEnclosures(VARIANT &propVal)
	{
		SetProperty(0x3d8, VT_VARIANT, &propVal);
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
	VARIANT GetReceived()
	{
		VARIANT result;
		GetProperty(0x3da, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetReceived(VARIANT &propVal)
	{
		SetProperty(0x3da, VT_VARIANT, &propVal);
	}
	VARIANT GetSendDateTime()
	{
		VARIANT result;
		GetProperty(0x3db, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSendDateTime(VARIANT &propVal)
	{
		SetProperty(0x3db, VT_VARIANT, &propVal);
	}
	VARIANT GetSender()
	{
		VARIANT result;
		GetProperty(0x3dc, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetSender(VARIANT &propVal)
	{
		SetProperty(0x3dc, VT_VARIANT, &propVal);
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
	VARIANT GetToRecipients()
	{
		VARIANT result;
		GetProperty(0x3d5, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetToRecipients(VARIANT &propVal)
	{
		SetProperty(0x3d5, VT_VARIANT, &propVal);
	}
	VARIANT GetWhichAddress()
	{
		VARIANT result;
		GetProperty(0x3ce, VT_VARIANT, (void*)&result);
		return result;
	}
	void SetWhichAddress(VARIANT &propVal)
	{
		SetProperty(0x3ce, VT_VARIANT, &propVal);
	}

};
