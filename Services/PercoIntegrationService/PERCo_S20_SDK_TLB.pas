unit PERCo_S20_SDK_TLB;

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
// File generated on 27.01.2015 12:06:35 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Users\shingarev\Documents\RAD Studio\Projects\PercoDataLoader\PERCo_S20_SDK.dll (1)
// LIBID: {87ABE103-1E07-4151-BDB6-6EA4165277FC}
// LCID: 0
// Helpfile: 
// HelpString: Библиотека SDK
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\system32\stdole2.tlb)
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

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  PERCo_S20_SDKMajorVersion = 1;
  PERCo_S20_SDKMinorVersion = 0;

  LIBID_PERCo_S20_SDK: TGUID = '{87ABE103-1E07-4151-BDB6-6EA4165277FC}';

  IID_IExchangeMain: TGUID = '{BC06511A-BE09-477B-8BC3-22D80191225E}';
  CLASS_CoExchangeMain: TGUID = '{E74FA501-350F-43CF-8C15-D831778FD465}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IExchangeMain = interface;
  IExchangeMainDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CoExchangeMain = IExchangeMain;


// *********************************************************************//
// Interface: IExchangeMain
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BC06511A-BE09-477B-8BC3-22D80191225E}
// *********************************************************************//
  IExchangeMain = interface(IDispatch)
    ['{BC06511A-BE09-477B-8BC3-22D80191225E}']
    function SetConnect(const AHost: WideString; const APort: WideString; const ALogin: WideString; 
                        const APassword: WideString): Integer; safecall;
    function DisConnect: Integer; safecall;
    function GetErrorDescription(const AErorr: IDispatch): Integer; safecall;
    function SendData(const AData: IDispatch): Integer; safecall;
    function GetData(const AData: IDispatch): Integer; safecall;
    function GetDataForReport(const AData: IDispatch): Integer; safecall;
    function TestGenerateEvents(const AData: IDispatch): Integer; safecall;
    function UpdateData(const AData: IDispatch): Integer; safecall;
    function GetEvents(const AData: IDispatch): Integer; safecall;
    function CheckVersion(out AVersionDB: WideString; out AVersionDll: WideString): Integer; safecall;
    function CheckSynchronization: Integer; safecall;
    function ExecuteCommand(const AData: IDispatch): Integer; safecall;
    function ExecuteAccessCardsAction(const AData: IDispatch): Integer; safecall;
    function Withdraw_Access(const AData: IDispatch): Integer; safecall;
    function Append_Access(const AData: IDispatch): Integer; safecall;
    function GetGlobalReaderProtocol(const AData: IDispatch): Integer; safecall;
    function GetOneEmploy(const AData: IDispatch): Integer; safecall;
    function GetUser(const AUser: WideString; out APassw: WideString): Integer; safecall;
  end;

// *********************************************************************//
// DispIntf:  IExchangeMainDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {BC06511A-BE09-477B-8BC3-22D80191225E}
// *********************************************************************//
  IExchangeMainDisp = dispinterface
    ['{BC06511A-BE09-477B-8BC3-22D80191225E}']
    function SetConnect(const AHost: WideString; const APort: WideString; const ALogin: WideString; 
                        const APassword: WideString): Integer; dispid 201;
    function DisConnect: Integer; dispid 202;
    function GetErrorDescription(const AErorr: IDispatch): Integer; dispid 203;
    function SendData(const AData: IDispatch): Integer; dispid 204;
    function GetData(const AData: IDispatch): Integer; dispid 205;
    function GetDataForReport(const AData: IDispatch): Integer; dispid 206;
    function TestGenerateEvents(const AData: IDispatch): Integer; dispid 207;
    function UpdateData(const AData: IDispatch): Integer; dispid 208;
    function GetEvents(const AData: IDispatch): Integer; dispid 209;
    function CheckVersion(out AVersionDB: WideString; out AVersionDll: WideString): Integer; dispid 210;
    function CheckSynchronization: Integer; dispid 211;
    function ExecuteCommand(const AData: IDispatch): Integer; dispid 212;
    function ExecuteAccessCardsAction(const AData: IDispatch): Integer; dispid 213;
    function Withdraw_Access(const AData: IDispatch): Integer; dispid 214;
    function Append_Access(const AData: IDispatch): Integer; dispid 215;
    function GetGlobalReaderProtocol(const AData: IDispatch): Integer; dispid 216;
    function GetOneEmploy(const AData: IDispatch): Integer; dispid 217;
    function GetUser(const AUser: WideString; out APassw: WideString): Integer; dispid 218;
  end;

// *********************************************************************//
// The Class CoCoExchangeMain provides a Create and CreateRemote method to          
// create instances of the default interface IExchangeMain exposed by              
// the CoClass CoExchangeMain. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCoExchangeMain = class
    class function Create: IExchangeMain;
    class function CreateRemote(const MachineName: string): IExchangeMain;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TCoExchangeMain
// Help String      : CoExchangeMain Object
// Default Interface: IExchangeMain
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TCoExchangeMainProperties= class;
{$ENDIF}
  TCoExchangeMain = class(TOleServer)
  private
    FIntf: IExchangeMain;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps: TCoExchangeMainProperties;
    function GetServerProperties: TCoExchangeMainProperties;
{$ENDIF}
    function GetDefaultInterface: IExchangeMain;
  protected
    procedure InitServerData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IExchangeMain);
    procedure Disconnect; override;
    function SetConnect(const AHost: WideString; const APort: WideString; const ALogin: WideString; 
                        const APassword: WideString): Integer;
    function DisConnect1: Integer;
    function GetErrorDescription(const AErorr: IDispatch): Integer;
    function SendData(const AData: IDispatch): Integer;
    function GetData(const AData: IDispatch): Integer;
    function GetDataForReport(const AData: IDispatch): Integer;
    function TestGenerateEvents(const AData: IDispatch): Integer;
    function UpdateData(const AData: IDispatch): Integer;
    function GetEvents(const AData: IDispatch): Integer;
    function CheckVersion(out AVersionDB: WideString; out AVersionDll: WideString): Integer;
    function CheckSynchronization: Integer;
    function ExecuteCommand(const AData: IDispatch): Integer;
    function ExecuteAccessCardsAction(const AData: IDispatch): Integer;
    function Withdraw_Access(const AData: IDispatch): Integer;
    function Append_Access(const AData: IDispatch): Integer;
    function GetGlobalReaderProtocol(const AData: IDispatch): Integer;
    function GetOneEmploy(const AData: IDispatch): Integer;
    function GetUser(const AUser: WideString; out APassw: WideString): Integer;
    property DefaultInterface: IExchangeMain read GetDefaultInterface;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TCoExchangeMainProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TCoExchangeMain
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TCoExchangeMainProperties = class(TPersistent)
  private
    FServer:    TCoExchangeMain;
    function    GetDefaultInterface: IExchangeMain;
    constructor Create(AServer: TCoExchangeMain);
  protected
  public
    property DefaultInterface: IExchangeMain read GetDefaultInterface;
  published
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = '(none)';

  dtlOcxPage = '(none)';

implementation

uses ComObj;

class function CoCoExchangeMain.Create: IExchangeMain;
begin
  Result := CreateComObject(CLASS_CoExchangeMain) as IExchangeMain;
end;

class function CoCoExchangeMain.CreateRemote(const MachineName: string): IExchangeMain;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CoExchangeMain) as IExchangeMain;
end;

procedure TCoExchangeMain.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{E74FA501-350F-43CF-8C15-D831778FD465}';
    IntfIID:   '{BC06511A-BE09-477B-8BC3-22D80191225E}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TCoExchangeMain.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IExchangeMain;
  end;
end;

procedure TCoExchangeMain.ConnectTo(svrIntf: IExchangeMain);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TCoExchangeMain.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TCoExchangeMain.GetDefaultInterface: IExchangeMain;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call "Connect" or "ConnectTo" before this operation');
  Result := FIntf;
end;

constructor TCoExchangeMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TCoExchangeMainProperties.Create(Self);
{$ENDIF}
end;

destructor TCoExchangeMain.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TCoExchangeMain.GetServerProperties: TCoExchangeMainProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TCoExchangeMain.SetConnect(const AHost: WideString; const APort: WideString; 
                                    const ALogin: WideString; const APassword: WideString): Integer;
begin
  Result := DefaultInterface.SetConnect(AHost, APort, ALogin, APassword);
end;

function TCoExchangeMain.DisConnect1: Integer;
begin
  Result := DefaultInterface.DisConnect;
end;

function TCoExchangeMain.GetErrorDescription(const AErorr: IDispatch): Integer;
begin
  Result := DefaultInterface.GetErrorDescription(AErorr);
end;

function TCoExchangeMain.SendData(const AData: IDispatch): Integer;
begin
  Result := DefaultInterface.SendData(AData);
end;

function TCoExchangeMain.GetData(const AData: IDispatch): Integer;
begin
  Result := DefaultInterface.GetData(AData);
end;

function TCoExchangeMain.GetDataForReport(const AData: IDispatch): Integer;
begin
  Result := DefaultInterface.GetDataForReport(AData);
end;

function TCoExchangeMain.TestGenerateEvents(const AData: IDispatch): Integer;
begin
  Result := DefaultInterface.TestGenerateEvents(AData);
end;

function TCoExchangeMain.UpdateData(const AData: IDispatch): Integer;
begin
  Result := DefaultInterface.UpdateData(AData);
end;

function TCoExchangeMain.GetEvents(const AData: IDispatch): Integer;
begin
  Result := DefaultInterface.GetEvents(AData);
end;

function TCoExchangeMain.CheckVersion(out AVersionDB: WideString; out AVersionDll: WideString): Integer;
begin
  Result := DefaultInterface.CheckVersion(AVersionDB, AVersionDll);
end;

function TCoExchangeMain.CheckSynchronization: Integer;
begin
  Result := DefaultInterface.CheckSynchronization;
end;

function TCoExchangeMain.ExecuteCommand(const AData: IDispatch): Integer;
begin
  Result := DefaultInterface.ExecuteCommand(AData);
end;

function TCoExchangeMain.ExecuteAccessCardsAction(const AData: IDispatch): Integer;
begin
  Result := DefaultInterface.ExecuteAccessCardsAction(AData);
end;

function TCoExchangeMain.Withdraw_Access(const AData: IDispatch): Integer;
begin
  Result := DefaultInterface.Withdraw_Access(AData);
end;

function TCoExchangeMain.Append_Access(const AData: IDispatch): Integer;
begin
  Result := DefaultInterface.Append_Access(AData);
end;

function TCoExchangeMain.GetGlobalReaderProtocol(const AData: IDispatch): Integer;
begin
  Result := DefaultInterface.GetGlobalReaderProtocol(AData);
end;

function TCoExchangeMain.GetOneEmploy(const AData: IDispatch): Integer;
begin
  Result := DefaultInterface.GetOneEmploy(AData);
end;

function TCoExchangeMain.GetUser(const AUser: WideString; out APassw: WideString): Integer;
begin
  Result := DefaultInterface.GetUser(AUser, APassw);
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TCoExchangeMainProperties.Create(AServer: TCoExchangeMain);
begin
  inherited Create;
  FServer := AServer;
end;

function TCoExchangeMainProperties.GetDefaultInterface: IExchangeMain;
begin
  Result := FServer.DefaultInterface;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TCoExchangeMain]);
end;

end.
