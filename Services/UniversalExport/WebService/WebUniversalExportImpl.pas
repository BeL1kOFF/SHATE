{ Invokable implementation File for TWebUniversalExport which implements IWebUniversalExport }

unit WebUniversalExportImpl;

interface

uses InvokeRegistry, Types, XSBuiltIns, WebUniversalExportIntf,
 Unit3WebManager, Unit5MD5, SysUtils, UnitEventslog;

type

  { TWebUniversalExport }
  TWebUniversalExport = class(TInvokableClass, IWebUniversalExport)
  public
    function Multiply(Num1: LongInt; Num2: LongInt): Longint; stdcall;


    function getExportsMask(Domain: integer; ClientNAV: string; var email: string; var CY: string; webfilter: boolean): Integer; stdcall;
    function setExportsMask(Mask: integer; Domain: integer; ClientNAV: string; var email: string; var CY: string; webfilter: boolean): Integer; stdcall;
    function getUserExportsMask(Domain: integer; HASH,Login: string; var email: string; var CY: string; var Templ: integer): Integer; stdcall;
    function setUserExportsMask(Mask, Domain: Integer; HASH,Login: string; var email: string; var CY: string; var Templ: integer): Integer; stdcall;

    function InitInteractiveExport(Domain: integer; HASH,   Login: string; var ClientID, PriceGroup: integer): boolean; stdcall;
    function InteractiveExport(Domain: integer; HASH,   Login: string; idwh: integer; cy, zipname: string): boolean; stdcall;
  end;

implementation
  const UNITNO = 2;
//function TMult.Multiply(Num1: LongInt; Num2: LongInt): Longint;
//begin
// Result:=Num1*Num2;
//end;

{ TWebUniversalExport }

function TWebUniversalExport.getExportsMask(Domain: integer; ClientNAV: string;
  var email: string; var CY: string; webfilter: boolean): Integer;
  var   Templ: Integer;
begin
  WebManager.Connect;
  RESULT:=WebManager.WebExportsMaskRequest(Domain,ClientNAV,email,CY,Templ,false);
  WebManager.Disconnect;
end;

function TWebUniversalExport.getUserExportsMask(Domain: integer; HASH,Login: string;
  var email, CY: string; var Templ: integer): Integer;
begin
  if md5(Login+WebManager.getSALT)<>UpperCase(HASH) then exit;
  WebManager.Connect;
  RESULT:=WebManager.WebUserExportsMaskRequest(Domain,Login,email,CY, Templ);
  WebManager.Disconnect;
end;

function TWebUniversalExport.InitInteractiveExport(Domain: integer; HASH,   Login: string; var ClientID, PriceGroup: integer): boolean;
begin
  if md5(Login+WebManager.getSALT)<>UpperCase(HASH) then exit;
  WebManager.Connect;
  RESULT:=WebManager.WebUserInteractiveExport(Domain,Login,ClientID,PriceGroup);
  WebManager.Disconnect;
end;


function TWebUniversalExport.InteractiveExport(Domain: integer; HASH, Login: string; idwh: integer;  cy, zipname: string): boolean;
begin
  if md5(Login+WebManager.getSALT)<>UpperCase(HASH) then exit;
  WebManager.Connect;
  RESULT:=WebManager.WebUserInteractiveExport(Domain,Login,IDwh,cy, zipname);
  WebManager.Disconnect;
end;

function TWebUniversalExport.Multiply(Num1, Num2: Integer): Longint;
begin
   Result:=Num1*Num2;
end;

function TWebUniversalExport.setExportsMask(Mask: integer; Domain: integer; ClientNAV: string;
  var email: string; var CY: string;  webfilter: boolean): Integer;
  var Templ: integer;
begin
  WebManager.Connect;
  RESULT:=WebManager.WebExportsMaskReconfig(Mask, Domain,ClientNAV,email,CY,Templ,false);
  WebManager.Disconnect;
end;

function TWebUniversalExport.setUserExportsMask(Mask, Domain: Integer;
  HASH,Login: string; var email, CY: string; var Templ: integer): Integer;
begin
  if md5(Login+WebManager.getSALT)<>UpperCase(HASH) then exit;
  WebManager.Connect;
  RESULT:=WebManager.WebUserExportsMaskReconfig(Mask, Domain,Login,email,CY,Templ);//false
  WebManager.Disconnect;
end;

initialization
{ Invokable classes must be registered }
try
     InvRegistry.RegisterInvokableClass(TWebUniversalExport);
except on E: Exception do
  EventsLog.AddEvent(CATEGORY_Init,UNITNO,E.Message)
end;
end.

