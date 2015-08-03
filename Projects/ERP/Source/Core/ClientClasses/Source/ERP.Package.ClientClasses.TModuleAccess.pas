unit ERP.Package.ClientClasses.TModuleAccess;

interface

uses
  System.Generics.Collections,
  ERP.Package.ClientInterface.IModuleAccess;

type
  TModuleAccess = class(TInterfacedObject, IModuleAccess)
  private
    FRunModule: Boolean;
    FList: TDictionary<Integer, PAccessCaption>;
    function ContainsBit(aBit: Integer): Boolean;
    function GetBit(aIndex: Integer): Integer;
    function GetCount: Integer;
    function GetItems(aBit: Integer): PAccessCaption;
    procedure Add(aCaption: PChar; aBit: Integer); overload;
    procedure Clear;
  public
    constructor Create(aRunModule: Boolean);
    destructor Destroy; override;
    procedure Add(aBit: Integer; aValue: Boolean); overload;
  end;

implementation

uses
  System.SysUtils;

type
  EModuleAccessException = class(Exception);

{ TModuleAccess }

procedure TModuleAccess.Add(aCaption: PChar; aBit: Integer);
var
  AccessCaption: PAccessCaption;
begin
  if FRunModule then
    raise EModuleAccessException.Create('«апрещено добавл€ть доступы во врем€ работы модул€!!!')
  else
  begin
    New(AccessCaption);
    AccessCaption^.Caption := aCaption;
    AccessCaption^.Access := False;
    FList.AddOrSetValue(aBit, AccessCaption);
  end;
end;

procedure TModuleAccess.Add(aBit: Integer; aValue: Boolean);
var
  AccessCaption: PAccessCaption;
begin
  New(AccessCaption);
  AccessCaption^.Caption := '';
  AccessCaption^.Access := aValue;
  FList.AddOrSetValue(aBit, AccessCaption);
end;

procedure TModuleAccess.Clear;
var
  k: Integer;
begin
  for k := 0 to FList.Count - 1 do
    Dispose(FList.Values.ToArray[k]);
  FList.Clear();
end;

function TModuleAccess.ContainsBit(aBit: Integer): Boolean;
begin
  Result := FList.ContainsKey(aBit);
end;

constructor TModuleAccess.Create(aRunModule: Boolean);
begin
  FRunModule := aRunModule;
  FList := TDictionary<Integer, PAccessCaption>.Create();
end;

destructor TModuleAccess.Destroy;
begin
  Clear();
  FList.Free();
  inherited Destroy();
end;

function TModuleAccess.GetBit(aIndex: Integer): Integer;
begin
  Result := FList.Keys.ToArray[aIndex];
end;

function TModuleAccess.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TModuleAccess.GetItems(aBit: Integer): PAccessCaption;
begin
  Result := FList.Items[aBit];
end;

end.
