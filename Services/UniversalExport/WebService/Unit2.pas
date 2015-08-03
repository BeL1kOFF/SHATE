unit Unit2;

interface

uses
  SysUtils, Classes, HTTPApp, InvokeRegistry, WSDLIntf, TypInfo, WebServExp,
  WSDLBind, XMLSchema, WSDLPub, SOAPPasInv, SOAPHTTPPasInv, SOAPHTTPDisp,
  WebBrokerSOAP, UnitEventsLog;

type
  TWebModule2 = class(TWebModule)
    HTTPSoapDispatcher1: THTTPSoapDispatcher;
    HTTPSoapPascalInvoker1: THTTPSoapPascalInvoker;
    WSDLHTMLPublish1: TWSDLHTMLPublish;
    procedure WebModule2DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure HTTPSoapPascalInvoker1BeforeDispatchEvent(
      const MethodName: string; const Request: TStream);
    procedure HTTPSoapPascalInvoker1BeforeDispatchEvent2(
      const MethodName: string; const Request: TStream; Response: TStream;
      var BindingType: TWebServiceBindingType; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModule2: TWebModule2;

implementation

uses WebReq;

{$R *.dfm}

procedure TWebModule2.HTTPSoapPascalInvoker1BeforeDispatchEvent(
  const MethodName: string; const Request: TStream);
  var mn: string;
begin
  mn:=Trim(MethodName);
end;

procedure TWebModule2.HTTPSoapPascalInvoker1BeforeDispatchEvent2(
  const MethodName: string; const Request: TStream; Response: TStream;
  var BindingType: TWebServiceBindingType; var Handled: Boolean);
begin
  Handled:=Handled;
end;

procedure TWebModule2.WebModule2DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  WSDLHTMLPublish1.ServiceInfo(Sender, Request, Response, Handled);
end;

initialization
try
    WebRequestHandler.WebModuleClass := TWebModule2;
except on E: Exception do
  EventsLog.AddEvent(CATEGORY_Init,MSG_ERR_WebModule,E.Message);
end;

end.
