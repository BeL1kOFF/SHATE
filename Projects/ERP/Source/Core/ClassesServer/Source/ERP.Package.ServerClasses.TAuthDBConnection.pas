unit ERP.Package.ServerClasses.TAuthDBConnection;

interface

uses
  ERP.Package.CustomClasses.TCustomDBConnection;

type
  TAuthDBConnection = class(TCustomDBConnection)
  public
    constructor Create; override;
  end;

implementation

uses
  System.SysUtils,
  Vcl.Forms,
  ERP.Package.ServerClasses.ERPAuthOptions;

function GetOptions: IXMLOptionsType;
begin
  Result := LoadOptions(ExtractFilePath(Application.ExeName) + 'ERPAuth.xml');
end;

{ TAuthDBConnection }

constructor TAuthDBConnection.Create;
begin
  inherited Create;
  Server := PChar(GetOptions().Connection.Server);
  DataBase := PChar(GetOptions().Connection.DataBase);
end;

end.
