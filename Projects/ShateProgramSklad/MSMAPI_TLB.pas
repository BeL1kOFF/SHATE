unit MSMAPI_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// $Rev: 8291 $
// File generated on 16.07.2010 9:21:41 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINDOWS\system32\MSMAPI32.OCX (1)
// LIBID: {20C62CAE-15DA-101B-B9A8-444553540000}
// LCID: 0
// Helpfile: C:\WINDOWS\system32\MAPI98.CHM
// HelpString: Microsoft MAPI Controls 6.0
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  MSMAPIMajorVersion = 1;
  MSMAPIMinorVersion = 1;

  LIBID_MSMAPI: TGUID = '{20C62CAE-15DA-101B-B9A8-444553540000}';

  IID_IMapiSession: TGUID = '{F49AC0B0-DF74-11CF-8E74-00A0C90F26F8}';
  DIID_MAPISessionEvents: TGUID = '{20C62CA2-15DA-101B-B9A8-444553540000}';
  CLASS_MAPISession: TGUID = '{20C62CA0-15DA-101B-B9A8-444553540000}';
  IID_IMapiMessages: TGUID = '{F49AC0B2-DF74-11CF-8E74-00A0C90F26F8}';
  DIID_MAPIMessagesEvents: TGUID = '{20C62CAD-15DA-101B-B9A8-444553540000}';
  CLASS_MAPIMessages: TGUID = '{20C62CAB-15DA-101B-B9A8-444553540000}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum DeleteConstants
type
  DeleteConstants = TOleEnum;
const
  mapMessageDelete = $00000000;
  mapRecipientDelete = $00000001;
  mapAttachmentDelete = $00000002;

// Constants for enum MessagesActionConstants
type
  MessagesActionConstants = TOleEnum;
const
  mapFetch = $00000001;
  mapSendDialog = $00000002;
  mapSend = $00000003;
  mapSave = $00000004;
  mapCopy = $00000005;
  mapCompose = $00000006;
  mapReply = $00000007;
  mapReplyAll = $00000008;
  mapForward = $00000009;
  mapDelete = $0000000A;
  mapShowAddressBook = $0000000B;
  mapShowRecipDetails = $0000000C;
  mapResolveName = $0000000D;
  mapDeleteRecip = $0000000E;
  mapDeleteAttachment = $0000000F;

// Constants for enum MAPIErrors
type
  MAPIErrors = TOleEnum;
const
  mapSuccessSuccess = $00007D00;
  mapUserAbort = $00007D01;
  mapFailure = $00007D02;
  mapLoginFail = $00007D03;
  mapDiskFull = $00007D04;
  mapInsufficientMem = $00007D05;
  mapAccessDenied = $00007D06;
  mapGeneralFailure = $00007D07;
  mapTooManySessions = $00007D08;
  mapTooManyFiles = $00007D09;
  mapTooManyRecipients = $00007D0A;
  mapAttachmentNotFound = $00007D0B;
  mapAttachmentOpenFailure = $00007D0C;
  mapAttachmentWriteFailure = $00007D0D;
  mapUnknownRecipient = $00007D0E;
  mapBadRecipType = $00007D0F;
  mapNoMessages = $00007D10;
  mapInvalidMessage = $00007D11;
  mapTextTooLarge = $00007D12;
  mapInvalidSession = $00007D13;
  mapTypeNotSupported = $00007D14;
  mapAmbiguousRecipient = $00007D15;
  mapMessageInUse = $00007D16;
  mapNetworkFailure = $00007D17;
  mapInvalidEditFields = $00007D18;
  mapInvalidRecips = $00007D19;
  mapNotSupported = $00007D1A;
  mapSessionExist = $00007D32;
  mapInvalidBuffer = $00007D33;
  mapInvalidReadBufferAction = $00007D34;
  mapNoSession = $00007D35;
  mapInvalidRecipient = $00007D36;
  mapInvalidComposeBufferAction = $00007D37;
  mapControlFailure = $00007D38;
  mapNoRecipients = $00007D39;
  mapNoAttachment = $00007D3A;

// Constants for enum ErrorConstants
type
  ErrorConstants = TOleEnum;
const
  mpeOutOfMemory = $00000007;
  mpeErrorLoadingMAPI = $00000030;
  mpeInvalidPropertyValue = $0000017C;
  mpeInvalidPropertyArrayIndex = $0000017D;
  mpeSetNotSupported = $0000017F;
  mpeGetNotSupported = $0000018A;
  mpeUserCancelled = $00007D01;
  mpeUnspecifiedFailure = $00007D02;
  mpeLoginFailed = $00007D03;
  mpeDiskFull = $00007D04;
  mpeInsufficientMemory = $00007D05;
  mpeAccessDenied = $00007D06;
  mpeMAPIFailure = $00007D07;
  mpeTooManySessions = $00007D08;
  mpeTooManyFiles = $00007D09;
  mpeTooManyRecipients = $00007D0A;
  mpeAttachmentNotFound = $00007D0B;
  mpeFailedOpeningAttachment = $00007D0C;
  mpeFailedWritingAttachment = $00007D0D;
  mpeUnknownRecipient = $00007D0E;
  mpeInvalidRecipientType = $00007D0F;
  mpeNoMessages = $00007D10;
  mpeInvalidMessage = $00007D11;
  mpeTextTooLarge = $00007D12;
  mpeInvalidSession = $00007D13;
  mpeTypeNotSupported = $00007D14;
  mpeAmbiguousRecipient = $00007D15;
  mpeMessageInUse = $00007D16;
  mpeNetworkFailure = $00007D17;
  mpeInvalidEditFields = $00007D18;
  mpeInvalidRecipients = $00007D19;
  mpeNotSupported = $00007D1A;
  mpeUserAbortedAction = $00007D1B;
  mpeMAPIMissing = $00007D30;
  mpeLogonFailure = $00007D32;
  mpePropertyIsReadOnly = $00007D33;
  mpeInvalidAction = $00007D34;
  mpeNoValidSessionID = $00007D35;
  mpeNoOriginator = $00007D36;
  mpeActionNotValid = $00007D37;
  mpeNoMessageList = $00007D38;
  mpeNoRecipients = $00007D39;
  mpeNoAttachments = $00007D3A;

// Constants for enum RecipTypeConstants
type
  RecipTypeConstants = TOleEnum;
const
  mapOrigList = $00000000;
  mapToList = $00000001;
  mapCcList = $00000002;
  mapBccList = $00000003;

// Constants for enum AttachTypeConstants
type
  AttachTypeConstants = TOleEnum;
const
  mapData = $00000000;
  mapEOLE = $00000001;
  mapSOLE = $00000002;

// Constants for enum SessionActionConstants
type
  SessionActionConstants = TOleEnum;
const
  mapSignOn = $00000001;
  mapSignOff = $00000002;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IMapiSession = interface;
  IMapiSessionDisp = dispinterface;
  MAPISessionEvents = dispinterface;
  IMapiMessages = interface;
  IMapiMessagesDisp = dispinterface;
  MAPIMessagesEvents = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  MAPISession = IMapiSession;
  MAPIMessages = IMapiMessages;


// *********************************************************************//
// Interface: IMapiSession
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {F49AC0B0-DF74-11CF-8E74-00A0C90F26F8}
// *********************************************************************//
  IMapiSession = interface(IDispatch)
    ['{F49AC0B0-DF74-11CF-8E74-00A0C90F26F8}']
    function Get_DownLoadMail: WordBool; safecall;
    procedure Set_DownLoadMail(pbDownloadMail: WordBool); safecall;
    function Get_LogonUI: WordBool; safecall;
    procedure Set_LogonUI(pbLogonUI: WordBool); safecall;
    function Get_NewSession: WordBool; safecall;
    procedure Set_NewSession(pbNewSession: WordBool); safecall;
    function Get_Action: Smallint; safecall;
    procedure Set_Action(psAction: Smallint); safecall;
    function Get_SessionID: Integer; safecall;
    procedure Set_SessionID(plSessionID: Integer); safecall;
    function Get_Password: WideString; safecall;
    procedure Set_Password(const pbstrPassword: WideString); safecall;
    function Get_UserName: WideString; safecall;
    procedure Set_UserName(const pbstrUserName: WideString); safecall;
    procedure SignOn; safecall;
    procedure SignOff; safecall;
    procedure AboutBox; safecall;
    property DownLoadMail: WordBool read Get_DownLoadMail write Set_DownLoadMail;
    property LogonUI: WordBool read Get_LogonUI write Set_LogonUI;
    property NewSession: WordBool read Get_NewSession write Set_NewSession;
    property Action: Smallint read Get_Action write Set_Action;
    property SessionID: Integer read Get_SessionID write Set_SessionID;
    property Password: WideString read Get_Password write Set_Password;
    property UserName: WideString read Get_UserName write Set_UserName;
  end;

// *********************************************************************//
// DispIntf:  IMapiSessionDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {F49AC0B0-DF74-11CF-8E74-00A0C90F26F8}
// *********************************************************************//
  IMapiSessionDisp = dispinterface
    ['{F49AC0B0-DF74-11CF-8E74-00A0C90F26F8}']
    property DownLoadMail: WordBool dispid 1;
    property LogonUI: WordBool dispid 2;
    property NewSession: WordBool dispid 3;
    property Action: Smallint dispid 4;
    property SessionID: Integer dispid 5;
    property Password: WideString dispid 6;
    property UserName: WideString dispid 7;
    procedure SignOn; dispid 8;
    procedure SignOff; dispid 9;
    procedure AboutBox; dispid -552;
  end;

// *********************************************************************//
// DispIntf:  MAPISessionEvents
// Flags:     (4240) Hidden NonExtensible Dispatchable
// GUID:      {20C62CA2-15DA-101B-B9A8-444553540000}
// *********************************************************************//
  MAPISessionEvents = dispinterface
    ['{20C62CA2-15DA-101B-B9A8-444553540000}']
  end;

// *********************************************************************//
// Interface: IMapiMessages
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {F49AC0B2-DF74-11CF-8E74-00A0C90F26F8}
// *********************************************************************//
  IMapiMessages = interface(IDispatch)
    ['{F49AC0B2-DF74-11CF-8E74-00A0C90F26F8}']
    function Get_AddressCaption: WideString; safecall;
    procedure Set_AddressCaption(const pbstrAddressCaption: WideString); safecall;
    function Get_AddressEditFieldCount: Smallint; safecall;
    procedure Set_AddressEditFieldCount(psAddressEditFieldCount: Smallint); safecall;
    function Get_AddressLabel: WideString; safecall;
    procedure Set_AddressLabel(const pbstrAddressLabel: WideString); safecall;
    function Get_AddressModifiable: WordBool; safecall;
    procedure Set_AddressModifiable(pbAddressModifiable: WordBool); safecall;
    function Get_AddressResolveUI: WordBool; safecall;
    procedure Set_AddressResolveUI(pbAddressResolveUI: WordBool); safecall;
    function Get_AttachmentCount: Integer; safecall;
    procedure Set_AttachmentCount(plAttachmentCount: Integer); safecall;
    function Get_AttachmentIndex: Integer; safecall;
    procedure Set_AttachmentIndex(plAttachmentIndex: Integer); safecall;
    function Get_AttachmentName: WideString; safecall;
    procedure Set_AttachmentName(const pbstrAttachmentName: WideString); safecall;
    function Get_AttachmentPathName: WideString; safecall;
    procedure Set_AttachmentPathName(const pbstrAttachmentPathName: WideString); safecall;
    function Get_AttachmentPosition: Integer; safecall;
    procedure Set_AttachmentPosition(plAttachmentPosition: Integer); safecall;
    function Get_AttachmentType: Smallint; safecall;
    procedure Set_AttachmentType(psAttachmentType: Smallint); safecall;
    function Get_FetchMsgType: WideString; safecall;
    procedure Set_FetchMsgType(const pbstrFetchMsgType: WideString); safecall;
    function Get_FetchSorted: WordBool; safecall;
    procedure Set_FetchSorted(pbFetchSorted: WordBool); safecall;
    function Get_FetchUnreadOnly: WordBool; safecall;
    procedure Set_FetchUnreadOnly(pbFetchUnreadOnly: WordBool); safecall;
    function Get_MsgConversationID: WideString; safecall;
    procedure Set_MsgConversationID(const pbstrMsgConversationID: WideString); safecall;
    function Get_MsgCount: Integer; safecall;
    procedure Set_MsgCount(plMsgCount: Integer); safecall;
    function Get_MsgDateReceived: WideString; safecall;
    procedure Set_MsgDateReceived(const pbstrMsgDateReceived: WideString); safecall;
    function Get_MsgID: WideString; safecall;
    procedure Set_MsgID(const pbstrMsgID: WideString); safecall;
    function Get_MsgIndex: Integer; safecall;
    procedure Set_MsgIndex(plMsgIndex: Integer); safecall;
    function Get_MsgNoteText: WideString; safecall;
    procedure Set_MsgNoteText(const pbstrMsgNoteText: WideString); safecall;
    function Get_MsgOrigAddress: WideString; safecall;
    procedure Set_MsgOrigAddress(const pbstrMsgOrigAddress: WideString); safecall;
    function Get_MsgOrigDisplayName: WideString; safecall;
    procedure Set_MsgOrigDisplayName(const pbstrMsgOrigDisplayName: WideString); safecall;
    function Get_MsgRead: WordBool; safecall;
    procedure Set_MsgRead(pbMsgRead: WordBool); safecall;
    function Get_MsgReceiptRequested: WordBool; safecall;
    procedure Set_MsgReceiptRequested(pbMsgReceiptRequested: WordBool); safecall;
    function Get_MsgSent: WordBool; safecall;
    procedure Set_MsgSent(pbMsgSent: WordBool); safecall;
    function Get_RecipAddress: WideString; safecall;
    procedure Set_RecipAddress(const pbstrRecipAddress: WideString); safecall;
    function Get_RecipCount: Integer; safecall;
    procedure Set_RecipCount(plRecipCount: Integer); safecall;
    function Get_RecipDisplayName: WideString; safecall;
    procedure Set_RecipDisplayName(const pbstrRecipDisplayName: WideString); safecall;
    function Get_RecipIndex: Integer; safecall;
    procedure Set_RecipIndex(plRecipIndex: Integer); safecall;
    function Get_RecipType: Smallint; safecall;
    procedure Set_RecipType(psRecipType: Smallint); safecall;
    function Get_SessionID: Integer; safecall;
    procedure Set_SessionID(plSessionID: Integer); safecall;
    function Get_MsgSubject: WideString; safecall;
    procedure Set_MsgSubject(const pbstrMsgSubject: WideString); safecall;
    function Get_MsgType: WideString; safecall;
    procedure Set_MsgType(const pbstrMsgType: WideString); safecall;
    function Get_Action: Smallint; safecall;
    procedure Set_Action(psAction: Smallint); safecall;
    procedure Compose; safecall;
    procedure Copy; safecall;
    procedure Delete(vObj: OleVariant); safecall;
    procedure Fetch; safecall;
    procedure Forward; safecall;
    procedure Reply; safecall;
    procedure ReplyAll; safecall;
    procedure ResolveName; safecall;
    procedure Save; safecall;
    procedure Show(vDetails: OleVariant); safecall;
    procedure AboutBox; safecall;
    procedure Send(vDialog: OleVariant); safecall;
    property AddressCaption: WideString read Get_AddressCaption write Set_AddressCaption;
    property AddressEditFieldCount: Smallint read Get_AddressEditFieldCount write Set_AddressEditFieldCount;
    property AddressLabel: WideString read Get_AddressLabel write Set_AddressLabel;
    property AddressModifiable: WordBool read Get_AddressModifiable write Set_AddressModifiable;
    property AddressResolveUI: WordBool read Get_AddressResolveUI write Set_AddressResolveUI;
    property AttachmentCount: Integer read Get_AttachmentCount write Set_AttachmentCount;
    property AttachmentIndex: Integer read Get_AttachmentIndex write Set_AttachmentIndex;
    property AttachmentName: WideString read Get_AttachmentName write Set_AttachmentName;
    property AttachmentPathName: WideString read Get_AttachmentPathName write Set_AttachmentPathName;
    property AttachmentPosition: Integer read Get_AttachmentPosition write Set_AttachmentPosition;
    property AttachmentType: Smallint read Get_AttachmentType write Set_AttachmentType;
    property FetchMsgType: WideString read Get_FetchMsgType write Set_FetchMsgType;
    property FetchSorted: WordBool read Get_FetchSorted write Set_FetchSorted;
    property FetchUnreadOnly: WordBool read Get_FetchUnreadOnly write Set_FetchUnreadOnly;
    property MsgConversationID: WideString read Get_MsgConversationID write Set_MsgConversationID;
    property MsgCount: Integer read Get_MsgCount write Set_MsgCount;
    property MsgDateReceived: WideString read Get_MsgDateReceived write Set_MsgDateReceived;
    property MsgID: WideString read Get_MsgID write Set_MsgID;
    property MsgIndex: Integer read Get_MsgIndex write Set_MsgIndex;
    property MsgNoteText: WideString read Get_MsgNoteText write Set_MsgNoteText;
    property MsgOrigAddress: WideString read Get_MsgOrigAddress write Set_MsgOrigAddress;
    property MsgOrigDisplayName: WideString read Get_MsgOrigDisplayName write Set_MsgOrigDisplayName;
    property MsgRead: WordBool read Get_MsgRead write Set_MsgRead;
    property MsgReceiptRequested: WordBool read Get_MsgReceiptRequested write Set_MsgReceiptRequested;
    property MsgSent: WordBool read Get_MsgSent write Set_MsgSent;
    property RecipAddress: WideString read Get_RecipAddress write Set_RecipAddress;
    property RecipCount: Integer read Get_RecipCount write Set_RecipCount;
    property RecipDisplayName: WideString read Get_RecipDisplayName write Set_RecipDisplayName;
    property RecipIndex: Integer read Get_RecipIndex write Set_RecipIndex;
    property RecipType: Smallint read Get_RecipType write Set_RecipType;
    property SessionID: Integer read Get_SessionID write Set_SessionID;
    property MsgSubject: WideString read Get_MsgSubject write Set_MsgSubject;
    property MsgType: WideString read Get_MsgType write Set_MsgType;
    property Action: Smallint read Get_Action write Set_Action;
  end;

// *********************************************************************//
// DispIntf:  IMapiMessagesDisp
// Flags:     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID:      {F49AC0B2-DF74-11CF-8E74-00A0C90F26F8}
// *********************************************************************//
  IMapiMessagesDisp = dispinterface
    ['{F49AC0B2-DF74-11CF-8E74-00A0C90F26F8}']
    property AddressCaption: WideString dispid 1;
    property AddressEditFieldCount: Smallint dispid 2;
    property AddressLabel: WideString dispid 3;
    property AddressModifiable: WordBool dispid 4;
    property AddressResolveUI: WordBool dispid 5;
    property AttachmentCount: Integer dispid 6;
    property AttachmentIndex: Integer dispid 7;
    property AttachmentName: WideString dispid 8;
    property AttachmentPathName: WideString dispid 9;
    property AttachmentPosition: Integer dispid 10;
    property AttachmentType: Smallint dispid 11;
    property FetchMsgType: WideString dispid 12;
    property FetchSorted: WordBool dispid 13;
    property FetchUnreadOnly: WordBool dispid 14;
    property MsgConversationID: WideString dispid 15;
    property MsgCount: Integer dispid 16;
    property MsgDateReceived: WideString dispid 17;
    property MsgID: WideString dispid 18;
    property MsgIndex: Integer dispid 19;
    property MsgNoteText: WideString dispid 20;
    property MsgOrigAddress: WideString dispid 21;
    property MsgOrigDisplayName: WideString dispid 22;
    property MsgRead: WordBool dispid 23;
    property MsgReceiptRequested: WordBool dispid 24;
    property MsgSent: WordBool dispid 25;
    property RecipAddress: WideString dispid 26;
    property RecipCount: Integer dispid 27;
    property RecipDisplayName: WideString dispid 28;
    property RecipIndex: Integer dispid 29;
    property RecipType: Smallint dispid 30;
    property SessionID: Integer dispid 31;
    property MsgSubject: WideString dispid 32;
    property MsgType: WideString dispid 33;
    property Action: Smallint dispid 34;
    procedure Compose; dispid 35;
    procedure Copy; dispid 36;
    procedure Delete(vObj: OleVariant); dispid 45;
    procedure Fetch; dispid 37;
    procedure Forward; dispid 38;
    procedure Reply; dispid 39;
    procedure ReplyAll; dispid 40;
    procedure ResolveName; dispid 41;
    procedure Save; dispid 42;
    procedure Show(vDetails: OleVariant); dispid 44;
    procedure AboutBox; dispid -552;
    procedure Send(vDialog: OleVariant); dispid 43;
  end;

// *********************************************************************//
// DispIntf:  MAPIMessagesEvents
// Flags:     (4240) Hidden NonExtensible Dispatchable
// GUID:      {20C62CAD-15DA-101B-B9A8-444553540000}
// *********************************************************************//
  MAPIMessagesEvents = dispinterface
    ['{20C62CAD-15DA-101B-B9A8-444553540000}']
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TMAPISession
// Help String      : Microsoft MAPI Session Control
// Default Interface: IMapiSession
// Def. Intf. DISP? : No
// Event   Interface: MAPISessionEvents
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TMAPISession = class(TOleControl)
  private
    FIntf: IMapiSession;
    function  GetControlInterface: IMapiSession;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure SignOn;
    procedure SignOff;
    procedure AboutBox;
    property  ControlInterface: IMapiSession read GetControlInterface;
    property  DefaultInterface: IMapiSession read GetControlInterface;
  published
    property Anchors;
    property DownLoadMail: WordBool index 1 read GetWordBoolProp write SetWordBoolProp stored False;
    property LogonUI: WordBool index 2 read GetWordBoolProp write SetWordBoolProp stored False;
    property NewSession: WordBool index 3 read GetWordBoolProp write SetWordBoolProp stored False;
    property Action: Smallint index 4 read GetSmallintProp write SetSmallintProp stored False;
    property SessionID: Integer index 5 read GetIntegerProp write SetIntegerProp stored False;
    property Password: WideString index 6 read GetWideStringProp write SetWideStringProp stored False;
    property UserName: WideString index 7 read GetWideStringProp write SetWideStringProp stored False;
  end;


// *********************************************************************//
// OLE Control Proxy class declaration
// Control Name     : TMAPIMessages
// Help String      : Microsoft MAPI Messages Control
// Default Interface: IMapiMessages
// Def. Intf. DISP? : No
// Event   Interface: MAPIMessagesEvents
// TypeFlags        : (38) CanCreate Licensed Control
// *********************************************************************//
  TMAPIMessages = class(TOleControl)
  private
    FIntf: IMapiMessages;
    function  GetControlInterface: IMapiMessages;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
  public
    procedure Compose;
    procedure Copy;
    procedure Delete; overload;
    procedure Delete(vObj: OleVariant); overload;
    procedure Fetch;
    procedure Forward;
    procedure Reply;
    procedure ReplyAll;
    procedure ResolveName;
    procedure Save;
    procedure Show; overload;
    procedure Show(vDetails: OleVariant); overload;
    procedure AboutBox;
    procedure Send; overload;
    procedure Send(vDialog: OleVariant); overload;
    property  ControlInterface: IMapiMessages read GetControlInterface;
    property  DefaultInterface: IMapiMessages read GetControlInterface;
  published
    property Anchors;
    property AddressCaption: WideString index 1 read GetWideStringProp write SetWideStringProp stored False;
    property AddressEditFieldCount: Smallint index 2 read GetSmallintProp write SetSmallintProp stored False;
    property AddressLabel: WideString index 3 read GetWideStringProp write SetWideStringProp stored False;
    property AddressModifiable: WordBool index 4 read GetWordBoolProp write SetWordBoolProp stored False;
    property AddressResolveUI: WordBool index 5 read GetWordBoolProp write SetWordBoolProp stored False;
    property AttachmentCount: Integer index 6 read GetIntegerProp write SetIntegerProp stored False;
    property AttachmentIndex: Integer index 7 read GetIntegerProp write SetIntegerProp stored False;
    property AttachmentName: WideString index 8 read GetWideStringProp write SetWideStringProp stored False;
    property AttachmentPathName: WideString index 9 read GetWideStringProp write SetWideStringProp stored False;
    property AttachmentPosition: Integer index 10 read GetIntegerProp write SetIntegerProp stored False;
    property AttachmentType: Smallint index 11 read GetSmallintProp write SetSmallintProp stored False;
    property FetchMsgType: WideString index 12 read GetWideStringProp write SetWideStringProp stored False;
    property FetchSorted: WordBool index 13 read GetWordBoolProp write SetWordBoolProp stored False;
    property FetchUnreadOnly: WordBool index 14 read GetWordBoolProp write SetWordBoolProp stored False;
    property MsgConversationID: WideString index 15 read GetWideStringProp write SetWideStringProp stored False;
    property MsgCount: Integer index 16 read GetIntegerProp write SetIntegerProp stored False;
    property MsgDateReceived: WideString index 17 read GetWideStringProp write SetWideStringProp stored False;
    property MsgID: WideString index 18 read GetWideStringProp write SetWideStringProp stored False;
    property MsgIndex: Integer index 19 read GetIntegerProp write SetIntegerProp stored False;
    property MsgNoteText: WideString index 20 read GetWideStringProp write SetWideStringProp stored False;
    property MsgOrigAddress: WideString index 21 read GetWideStringProp write SetWideStringProp stored False;
    property MsgOrigDisplayName: WideString index 22 read GetWideStringProp write SetWideStringProp stored False;
    property MsgRead: WordBool index 23 read GetWordBoolProp write SetWordBoolProp stored False;
    property MsgReceiptRequested: WordBool index 24 read GetWordBoolProp write SetWordBoolProp stored False;
    property MsgSent: WordBool index 25 read GetWordBoolProp write SetWordBoolProp stored False;
    property RecipAddress: WideString index 26 read GetWideStringProp write SetWideStringProp stored False;
    property RecipCount: Integer index 27 read GetIntegerProp write SetIntegerProp stored False;
    property RecipDisplayName: WideString index 28 read GetWideStringProp write SetWideStringProp stored False;
    property RecipIndex: Integer index 29 read GetIntegerProp write SetIntegerProp stored False;
    property RecipType: Smallint index 30 read GetSmallintProp write SetSmallintProp stored False;
    property SessionID: Integer index 31 read GetIntegerProp write SetIntegerProp stored False;
    property MsgSubject: WideString index 32 read GetWideStringProp write SetWideStringProp stored False;
    property MsgType: WideString index 33 read GetWideStringProp write SetWideStringProp stored False;
    property Action: Smallint index 34 read GetSmallintProp write SetSmallintProp stored False;
  end;

procedure Register;

resourcestring
  dtlServerPage = '(none)';

  dtlOcxPage = '(none)';

implementation

uses ComObj;

procedure TMAPISession.InitControlData;
const
  CLicenseKey: array[0..36] of Word = ( $006D, $0067, $006B, $0067, $0074, $0067, $006E, $006E, $006D, $006E, $006D
    , $006E, $0069, $006E, $0069, $0067, $0074, $0068, $006B, $0067, $006F
    , $0067, $0067, $0067, $0076, $006D, $006B, $0068, $0069, $006E, $006A
    , $0067, $0067, $006E, $0076, $006D, $0000);
  CControlData: TControlData2 = (
    ClassID: '{20C62CA0-15DA-101B-B9A8-444553540000}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TMAPISession.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IMapiSession;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TMAPISession.GetControlInterface: IMapiSession;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TMAPISession.SignOn;
begin
  DefaultInterface.SignOn;
end;

procedure TMAPISession.SignOff;
begin
  DefaultInterface.SignOff;
end;

procedure TMAPISession.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure TMAPIMessages.InitControlData;
const
  CLicenseKey: array[0..36] of Word = ( $006D, $0067, $006B, $0067, $0074, $0067, $006E, $006E, $006D, $006E, $006D
    , $006E, $0069, $006E, $0069, $0067, $0074, $0068, $006B, $0067, $006F
    , $0067, $0067, $0067, $0076, $006D, $006B, $0068, $0069, $006E, $006A
    , $0067, $0067, $006E, $0076, $006D, $0000);
  CControlData: TControlData2 = (
    ClassID: '{20C62CAB-15DA-101B-B9A8-444553540000}';
    EventIID: '';
    EventCount: 0;
    EventDispIDs: nil;
    LicenseKey: @CLicenseKey;
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
end;

procedure TMAPIMessages.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IMapiMessages;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TMAPIMessages.GetControlInterface: IMapiMessages;
begin
  CreateControl;
  Result := FIntf;
end;

procedure TMAPIMessages.Compose;
begin
  DefaultInterface.Compose;
end;

procedure TMAPIMessages.Copy;
begin
  DefaultInterface.Copy;
end;

procedure TMAPIMessages.Delete;
begin
  DefaultInterface.Delete(EmptyParam);
end;

procedure TMAPIMessages.Delete(vObj: OleVariant);
begin
  DefaultInterface.Delete(vObj);
end;

procedure TMAPIMessages.Fetch;
begin
  DefaultInterface.Fetch;
end;

procedure TMAPIMessages.Forward;
begin
  DefaultInterface.Forward;
end;

procedure TMAPIMessages.Reply;
begin
  DefaultInterface.Reply;
end;

procedure TMAPIMessages.ReplyAll;
begin
  DefaultInterface.ReplyAll;
end;

procedure TMAPIMessages.ResolveName;
begin
  DefaultInterface.ResolveName;
end;

procedure TMAPIMessages.Save;
begin
  DefaultInterface.Save;
end;

procedure TMAPIMessages.Show;
begin
  DefaultInterface.Show(EmptyParam);
end;

procedure TMAPIMessages.Show(vDetails: OleVariant);
begin
  DefaultInterface.Show(vDetails);
end;

procedure TMAPIMessages.AboutBox;
begin
  DefaultInterface.AboutBox;
end;

procedure TMAPIMessages.Send;
begin
  DefaultInterface.Send(EmptyParam);
end;

procedure TMAPIMessages.Send(vDialog: OleVariant);
begin
  DefaultInterface.Send(vDialog);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TMAPISession, TMAPIMessages]);
end;

end.
