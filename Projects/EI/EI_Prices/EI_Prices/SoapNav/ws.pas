// ************************************************************************ //
// The types declared in this file were generated from data read from the
// WSDL File described below:
// WSDL     : http://svbyprisa0012:7049/DynamicsNAV/WS/Shate-M/Codeunit/ServiceProg
//  >Import : http://svbyprisa0012:7049/DynamicsNAV/WS/Shate-M/Codeunit/ServiceProg:0
// (18.06.2014 11:44:43 - - $Rev: 10138 $)
// ************************************************************************ //

unit ws;

interface

uses InvokeRegistry, SOAPHTTPClient, Types, XSBuiltIns;

const
  IS_REF  = $0080;


type

  // ************************************************************************ //
  // The following types, referred to in the WSDL document are not being represented
  // in this file. They are either aliases[@] of other types represented or were referred
  // to but never[!] declared in the document. The types from the latter category
  // typically map to predefined/known XML or Borland types; however, they could also 
  // indicate incorrect WSDL documents that failed to declare or import a schema type.
  // ************************************************************************ //
  // !:string          - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:decimal         - "http://www.w3.org/2001/XMLSchema"[Gbl]
  // !:dateTime        - "http://www.w3.org/2001/XMLSchema"[Gbl]



  // ************************************************************************ //
  // Namespace : urn:microsoft-dynamics-schemas/codeunit/ServiceProg
  // soapAction: urn:microsoft-dynamics-schemas/codeunit/ServiceProg:%operationName%
  // transport : http://schemas.xmlsoap.org/soap/http
  // style     : document
  // binding   : ServiceProg_Binding
  // service   : ServiceProg
  // port      : ServiceProg_Port
  // URL       : http://svbyprisa0012:7049/DynamicsNAV/WS/Shate-M/Codeunit/ServiceProg
  // ************************************************************************ //
  ServiceProg_Port = interface(IInvokable)
  ['{F5A63251-FE4A-D7F6-65A3-109C262D891E}']
    procedure ImportXML(const xMLText: WideString); stdcall;
    procedure Warmup; stdcall;
    procedure ItemExport; stdcall;
    procedure SubstituteExport; stdcall;
    procedure OENumberExport; stdcall;
    procedure StockExport; stdcall;
    procedure PriceExport; stdcall;
    procedure CurrencyExport; stdcall;
    procedure CustPasswordExport; stdcall;
    procedure ShipAddressExport; stdcall;
    procedure CustDiscountExport; stdcall;
    procedure CustAgreementExport; stdcall;
    procedure ReturnCreditMemoExport; stdcall;
    procedure DeleteSalesReturnExport; stdcall;
    function  GetItemStock(const itemNo2_TM: WideString): WideString; stdcall;
    function  GetItemPurchase(const itemNo2_TM: WideString): WideString; stdcall;
    procedure ImportWaitingList(const customerId: WideString; const itemCode: WideString; const brand: WideString; const quantity: TXSDecimal; const documentDate: TXSDateTime); stdcall;
    function  GetSalesPrice(var itemNo2: WideString; const tMName: WideString; const serviceProgUsrID: WideString; const agreementNo: WideString; const currCode: WideString): WideString; stdcall;
  end;

function GetServiceProg_Port(UseWSDL: Boolean=System.False; Addr: string=''; HTTPRIO: THTTPRIO = nil): ServiceProg_Port;


implementation
  uses SysUtils, IniFiles;

function GetServiceProg_Port(UseWSDL: Boolean; Addr: string; HTTPRIO: THTTPRIO): ServiceProg_Port;
const
  defWSDL = 'http://svbyprisa0012:7049/DynamicsNAV/WS/Shate-M/Codeunit/ServiceProg';
  defSvc  = 'ServiceProg';
  defPrt  = 'ServiceProg_Port';
var
  RIO: THTTPRIO;
  ini: TIniFile;
  urlWSDL: string;
  Path: string;
begin
  Result := nil;
  Path := ExtractFilePath(ParamStr(0));
  ini := TIniFile.Create(Path + 'ws.ini');
  try
    urlWSDL := '';
    urlWSDL := ini.ReadString('WebService', 'URL', '');
  finally
    ini.Free;
  end;
  if (Addr = '') then
  begin
    if UseWSDL then
      Addr := defWSDL
    else
      Addr := urlWSDL;
  end;
  if HTTPRIO = nil then
    RIO := THTTPRIO.Create(nil)
  else
    RIO := HTTPRIO;
  try
    RIO.HTTPWebNode.UserName := 'Shate\ord-q';
    RIO.HTTPWebNode.Password := 'yjdsqord101';
    Result := (RIO as ServiceProg_Port);
    if UseWSDL then
    begin
      RIO.WSDLLocation := Addr;
      RIO.Service := defSvc;
      RIO.Port := defPrt;
    end else
      RIO.URL := Addr;
  finally
    if (Result = nil) and (HTTPRIO = nil) then
      RIO.Free;
  end;
end;


initialization
  InvRegistry.RegisterInterface(TypeInfo(ServiceProg_Port), 'urn:microsoft-dynamics-schemas/codeunit/ServiceProg', '');
  InvRegistry.RegisterDefaultSOAPAction(TypeInfo(ServiceProg_Port), 'urn:microsoft-dynamics-schemas/codeunit/ServiceProg:%operationName%');
  InvRegistry.RegisterReturnParamNames(TypeInfo(ServiceProg_Port), ';;;' +
                                                                   ';;;' +
                                                                   ';;;' +
                                                                   ';;;' +
                                                                   ';;;return_value' +
                                                                   ';return_value;;return_value');
  InvRegistry.RegisterInvokeOptions(TypeInfo(ServiceProg_Port), ioDocument);

end.
