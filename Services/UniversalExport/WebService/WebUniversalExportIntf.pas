{ Invokable interface IWebUniversalExport }

unit WebUniversalExportIntf;

interface

uses InvokeRegistry, Types, XSBuiltIns;

type

  { Invokable interfaces must derive from IInvokable }
  IWebUniversalExport = interface(IInvokable)
  ['{EC4BAE45-7384-4835-8464-89E0DE034BD8}']
    function Multiply(Num1: LongInt; Num2: LongInt): Longint; stdcall;
    { Methods of Invokable interface must not use the default }
    { calling convention; stdcall is recommended }
    function getExportsMask(Domain: integer; ClientNAV: string; var email: string; var CY: string; webfilter: boolean): Integer; stdcall;
    function setExportsMask(Mask: integer; Domain: integer; ClientNAV: string; var email: string; var CY: string; webfilter: boolean): Integer; stdcall;

    function getUserExportsMask(Domain: integer; HASH, Login: string; var email: string; var CY: string; var Templ: integer): Integer; stdcall;
    function setUserExportsMask(Mask, Domain: Integer; HASH, Login: string; var email: string; var CY: string; var Templ: integer): Integer; stdcall;

    function InitInteractiveExport(Domain: integer; HASH,   Login: string; var ClientID, PriceGroup: integer): boolean; stdcall;
    function InteractiveExport(Domain: integer; HASH,   Login: string; idwh: integer;cy, zipname: string): boolean; stdcall;
  end;

implementation

initialization
  { Invokable interfaces must be registered }
  InvRegistry.RegisterInterface(TypeInfo(IWebUniversalExport));

end.
