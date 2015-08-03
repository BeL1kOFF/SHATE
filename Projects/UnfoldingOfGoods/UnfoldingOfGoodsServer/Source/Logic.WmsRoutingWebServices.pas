// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://svbyprisd011:7047/DynamicsNAV/WS/Shate-M/Codeunit/WmsRoutingWebServices
//  >Import : http://svbyprisd011:7047/DynamicsNAV/WS/Shate-M/Codeunit/WmsRoutingWebServices>0
// (20.06.2015 15:45:23 - - $Rev: 70145 $)
// ************************************************************************ //

unit Logic.WmsRoutingWebServices;

interface

uses Soap.InvokeRegistry, Soap.SOAPHTTPClient, System.Types, Soap.XSBuiltIns;

const
  IS_REF  = $0080;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Embarcadero types; however, they could also
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:boolean         - "http://www.w3.org/2001/XMLSchema"[Gbl]



  // ************************************************************************ //
  // Namespace : urn:microsoft-dynamics-schemas/codeunit/WmsRoutingWebServices
  // soapAction: urn:microsoft-dynamics-schemas/codeunit/WmsRoutingWebServices:%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // use       : literal
  // binding   : WmsRoutingWebServices_Binding
  // service   : WmsRoutingWebServices
  // port      : WmsRoutingWebServices_Port
  // URL       : http://svbyprisd011:7047/DynamicsNAV/WS/Shate-M/Codeunit/WmsRoutingWebServices
  // ************************************************************************ //
  WmsRoutingWebServices_Port = interface(IInvokable)
  ['{F0F50834-CCAF-3208-70A2-232BE5906B32}']
    function  ReqReceiveTarget(const locationCode: string; const tareId: string; const scanerCode: string): string; stdcall;
    function  RegBlockTarget(const locationCode: string; const targetBinCode: string; const block: Boolean): Boolean; stdcall;
    function  ReqFreeTarget(const locationCode: string; const targetBinCode: string): Boolean; stdcall;
    function  LoginUser(const prUserID: string; const prUserLocation: string; var prUserName: string): Boolean; stdcall;
    function  GetDocPlacement(const prDocNo: string; var prBigTextXml: string): Boolean; stdcall;
    function  RegisterPlacement(var prBigTextXml: string): Boolean; stdcall;
    function  GetDocNumbers(const prLocationCode: string; var prBigTextXml: string): Boolean; stdcall;
    function  GetBinContent(const prLocationCode: string; const prItemNo: string; var prBigTextXml: string): Boolean; stdcall;
  end;

function GetWmsRoutingWebServices_Port: WmsRoutingWebServices_Port;


implementation

uses
  System.SysUtils,
  Logic.Options,
  Logic.InitUnit;

function GetWmsRoutingWebServices_Port: WmsRoutingWebServices_Port;
var
  RIO: THTTPRIO;
begin
  TLog.LogMethod(nil, 'GetWmsRoutingWebServices_Port');
  RIO := THTTPRIO.Create(nil);
  RIO.HTTPWebNode.UserName := 'Shate\ord-q';
  RIO.HTTPWebNode.Password := 'yjdsqord101';
  RIO.HTTPWebNode.ConnectTimeout := TOptions.Options.Server.WebService.ConnectTimeout;
  RIO.HTTPWebNode.SendTimeout := TOptions.Options.Server.WebService.SendTimeout;
  RIO.HTTPWebNode.ReceiveTimeout := TOptions.Options.Server.WebService.ReceiveTimeout;
  RIO.URL := TOptions.Options.Server.WebService.URL;
  Result := (RIO as WmsRoutingWebServices_Port);
end;


initialization
  { WmsRoutingWebServices_Port }
  InvRegistry.RegisterInterface(TypeInfo(WmsRoutingWebServices_Port), 'urn:microsoft-dynamics-schemas/codeunit/WmsRoutingWebServices', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(WmsRoutingWebServices_Port), 'urn:microsoft-dynamics-schemas/codeunit/WmsRoutingWebServices:%operationName%');
  InvRegistry.RegisterInvokeOptions(TypeInfo(WmsRoutingWebServices_Port), ioDocument);
  { WmsRoutingWebServices_Port.ReqReceiveTarget }
  InvRegistry.RegisterMethodInfo(TypeInfo(WmsRoutingWebServices_Port), 'ReqReceiveTarget', '',
                                 '[ReturnName="return_value"]');
  { WmsRoutingWebServices_Port.RegBlockTarget }
  InvRegistry.RegisterMethodInfo(TypeInfo(WmsRoutingWebServices_Port), 'RegBlockTarget', '',
                                 '[ReturnName="return_value"]');
  { WmsRoutingWebServices_Port.ReqFreeTarget }
  InvRegistry.RegisterMethodInfo(TypeInfo(WmsRoutingWebServices_Port), 'ReqFreeTarget', '',
                                 '[ReturnName="return_value"]');
  { WmsRoutingWebServices_Port.LoginUser }
  InvRegistry.RegisterMethodInfo(TypeInfo(WmsRoutingWebServices_Port), 'LoginUser', '',
                                 '[ReturnName="return_value"]');
  { WmsRoutingWebServices_Port.GetDocPlacement }
  InvRegistry.RegisterMethodInfo(TypeInfo(WmsRoutingWebServices_Port), 'GetDocPlacement', '',
                                 '[ReturnName="return_value"]');
  { WmsRoutingWebServices_Port.RegisterPlacement }
  InvRegistry.RegisterMethodInfo(TypeInfo(WmsRoutingWebServices_Port), 'RegisterPlacement', '',
                                 '[ReturnName="return_value"]');
  { WmsRoutingWebServices_Port.GetDocNumbers }
  InvRegistry.RegisterMethodInfo(TypeInfo(WmsRoutingWebServices_Port), 'GetDocNumbers', '',
                                 '[ReturnName="return_value"]');
  { WmsRoutingWebServices_Port.GetBinContent }
  InvRegistry.RegisterMethodInfo(TypeInfo(WmsRoutingWebServices_Port), 'GetBinContent', '',
                                 '[ReturnName="return_value"]');

end.
