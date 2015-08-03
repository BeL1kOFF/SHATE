unit ERP.Package.ClientClasses.TModuleInfo;

interface

uses
  ERP.Package.ClientInterface.IModuleInfo;

type
  TModuleInfo = class(TInterfacedObject, IModuleInfo)
  private
    FBarName: string;
    FGUID: TGUID;
    FName: string;
    FPageName: string;
    FTypeDB: Integer;
    FTypeGUID: TGUID;

    function GetGUID: TGUID;
    function GetName: PChar;
    function GetTypeDB: Integer;
    function GetTypeGuid: TGUID;

    procedure SetGUID(const aValue: TGUID);
    procedure SetName(const aValue: PChar);
    procedure SetTypeDB(const aValue: Integer);
    procedure SetTypeGuid(const aValue: TGUID);
  public
    constructor Create;
  end;

implementation

{ TModuleInfo }

constructor TModuleInfo.Create;
begin
  FBarName := 'Неизвестно';
  FPageName := 'Неизвестно';
  FGUID.Empty;
  FName := 'Неизвестно';
  FTypeDB := 0;
end;

function TModuleInfo.GetGUID: TGUID;
begin
  Result := FGUID;
end;

function TModuleInfo.GetName: PChar;
begin
  Result := PChar(FName);
end;

function TModuleInfo.GetTypeDB: Integer;
begin
  Result := FTypeDB;
end;

function TModuleInfo.GetTypeGuid: TGUID;
begin
  Result := FTypeGUID;
end;

procedure TModuleInfo.SetGUID(const aValue: TGUID);
begin
  FGUID := aValue;
end;

procedure TModuleInfo.SetName(const aValue: PChar);
begin
  FName := aValue;
end;

procedure TModuleInfo.SetTypeDB(const aValue: Integer);
begin
  FTypeDB := aValue;
end;

procedure TModuleInfo.SetTypeGuid(const aValue: TGUID);
begin
  FTypeGUID := aValue;
end;

end.
