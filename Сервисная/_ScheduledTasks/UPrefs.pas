unit UPrefs;

interface

uses
  Classes;

type
  IPrefValue = interface
  ['{9E3BC2F0-F945-47B3-8702-9E95601CFE37}']
    function AsStringDef(const aDefault: string = ''): string;
    function AsIntDef(const aDefault: Integer = 0): Integer;
    function AsDoubleDef(const aDefault: Double = 0.0): Double;
    function AsBoolDef(const aDefault: Boolean = False): Boolean;

    function GetAsString: string;
    function GetAsInt: Integer;
    function GetAsDouble: Double;
    function GetAsBool: Boolean;

    procedure SetAsString(const aValue: string);
    procedure SetAsInt(const aValue: Integer);
    procedure SetAsDouble(const aValue: Double);
    procedure SetAsBool(const aValue: Boolean);

    function Exists: Boolean;

    property AsString: string read GetAsString write SetAsString;
    property AsInt: Integer read GetAsInt write SetAsInt;
    property AsDouble: Double read GetAsDouble write SetAsDouble;
    property AsBool: Boolean read GetAsBool write SetAsBool;
  end;

  TPreferences = class
  private
    fPrefs: TStrings;
    fModified: Boolean;
    FPrefix: string;
    function GetItems(const aName: string): IPrefValue;

    function GetValue(const aPrefName: string; var aValue: string): Boolean;
    function IsPrefExists(const aPrefName: string): Boolean;
    procedure SetValue(const aPrefName, aValue: string);
    procedure SetPrefix(const Value: string);
    function GetNames(Index: Integer): string;
    function GetCount: Integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    function  IsModified: Boolean;
    procedure ClearModified;
    procedure Clear;
    function  GetAsText: string;
    procedure SetAsText(const aValues: string; aRemovePrefix: Boolean = True);

    procedure SaveToFile(const aFileName: string);
    procedure LoadFromFile(const aFileName: string);

    property Items[const aName: string]: IPrefValue read GetItems; default;
    property Names[Index: Integer]: string read GetNames;
    property Count: Integer read GetCount;
    property Prefix: string read FPrefix write SetPrefix;
  end;

  TStoredPreferences = class(TPreferences)
  private
    fFileName: string;
  public
    constructor Create(const aFileName: string);
    procedure Save;
    procedure Load;
  end;

implementation

uses
  SysUtils;

type
  TPrefValue = class(TInterfacedObject, IPrefValue)
  private
    fOwner: TPreferences;
    fPrefName: string;
  protected
    function GetValue(var aValue: string): Boolean;
    procedure SetValue(const aValue: string);
  public
    constructor Create(aOwner: TPreferences; const aName: string);

    { IPrefValue }
    function AsStringDef(const aDefault: string = ''): string;
    function AsIntDef(const aDefault: Integer = 0): Integer;
    function AsDoubleDef(const aDefault: Double = 0.0): Double;
    function AsBoolDef(const aDefault: Boolean = False): Boolean;

    function GetAsString: string;
    function GetAsInt: Integer;
    function GetAsDouble: Double;
    function GetAsBool: Boolean;

    procedure SetAsString(const aValue: string);
    procedure SetAsInt(const aValue: Integer);
    procedure SetAsDouble(const aValue: Double);
    procedure SetAsBool(const aValue: Boolean);

    function Exists: Boolean;

    property AsString: string read GetAsString write SetAsString;
    property AsInt: Integer read GetAsInt write SetAsInt;
    property AsDouble: Double read GetAsDouble write SetAsDouble;
    property AsBool: Boolean read GetAsBool write SetAsBool;
  end;


{ TPrefValue }

constructor TPrefValue.Create(aOwner: TPreferences; const aName: string);
begin
  inherited Create;
  fOwner := aOwner;
  fPrefName := aName;
end;

function TPrefValue.AsBoolDef(const aDefault: Boolean): Boolean;
var
  s: string;
begin
  if not GetValue(s) then
    Result := aDefault
  else
    Result := (s <> '0') and (s <> '');
end;

function TPrefValue.AsDoubleDef(const aDefault: Double): Double;
var
  s: string;
begin
  if not GetValue(s) then
    Result := aDefault
  else
    Result := StrToFloatDef(s, aDefault);
end;

function TPrefValue.AsIntDef(const aDefault: Integer): Integer;
var
  s: string;
begin
  if not GetValue(s) then
    Result := aDefault
  else
    Result := StrToIntDef(s, aDefault);
end;

function TPrefValue.AsStringDef(const aDefault: string): string;
var
  s: string;
begin
  if not GetValue(s) then
    Result := aDefault
  else
    Result := s;
end;

function TPrefValue.GetValue(var aValue: string): Boolean;
begin
  Result := fOwner.GetValue(fPrefName, aValue);
end;

procedure TPrefValue.SetValue(const aValue: string);
begin
  fOwner.SetValue(fPrefName, aValue);
end;

procedure TPrefValue.SetAsBool(const aValue: Boolean);
begin
  SetValue(IntToStr(Integer(aValue)));
end;

procedure TPrefValue.SetAsDouble(const aValue: Double);
begin
  SetValue(FloatToStr(aValue));
end;

procedure TPrefValue.SetAsInt(const aValue: Integer);
begin
  SetValue(IntToStr(aValue));
end;

procedure TPrefValue.SetAsString(const aValue: string);
begin
  SetValue(aValue);
end;

function TPrefValue.GetAsBool: Boolean;
begin
  Result := AsBoolDef;
end;

function TPrefValue.GetAsDouble: Double;
begin
  Result := AsDoubleDef;
end;

function TPrefValue.GetAsInt: Integer;
begin
  Result := AsIntDef;
end;

function TPrefValue.GetAsString: string;
begin
  Result := AsStringDef;
end;

function TPrefValue.Exists: Boolean;
begin
  Result := fOwner.IsPrefExists(fPrefName);
end;

{ TPreferences }

constructor TPreferences.Create;
begin
  fModified := False;
  fPrefs := TStringList.Create;
end;

destructor TPreferences.Destroy;
begin
  fPrefs.Free;
  inherited;
end;

function TPreferences.IsModified: Boolean;
begin
  Result := fModified;
end;

procedure TPreferences.ClearModified;
begin
  fModified := False;
end;

procedure TPreferences.Clear;
begin
  fPrefs.Clear;
end;

procedure TPreferences.SaveToFile(const aFileName: string);
begin
  fPrefs.SaveToFile(aFileName);
end;

procedure TPreferences.LoadFromFile(const aFileName: string);
begin
  fPrefs.LoadFromFile(aFileName);
end;

function TPreferences.GetItems(const aName: string): IPrefValue;
begin
  Result := TPrefValue.Create(Self, aName);
end;

function TPreferences.GetValue(const aPrefName: string;
  var aValue: string): Boolean;
begin
  Result := fPrefs.IndexOfName(aPrefName) >= 0;
  if Result then
    aValue := fPrefs.Values[aPrefName]
  else
    aValue := '';
end;

procedure TPreferences.SetValue(const aPrefName, aValue: string);
begin
  fModified := True;
  fPrefs.Values[aPrefName] := aValue;
end;

function TPreferences.IsPrefExists(const aPrefName: string): Boolean;
begin
  Result := fPrefs.IndexOfName(aPrefName) >= 0;
end;

function TPreferences.GetAsText: string;
var
  sl: TStrings;
  i: Integer;
begin
  sl := TStringList.Create;
  try
    sl.Assign(fPrefs);
    for i := 0 to sl.Count - 1 do
      sl[i] := fPrefix + sl[i];
    Result := sl.Text;
  finally
    sl.Free;
  end;
end;

procedure TPreferences.SetAsText(const aValues: string; aRemovePrefix: Boolean = True);
var
  i: Integer;
  s: string;
  aPrefLen: Integer;
begin
  fPrefs.Text := aValues;
  if not aRemovePrefix then
    Exit;
     
  aPrefLen := Length(FPrefix);
  for i := 0 to fPrefs.Count - 1 do
  begin
    s := fPrefs[i];
    if Copy(s, 1, aPrefLen) = FPrefix then
      fPrefs[i] := Copy(s, aPrefLen + 1, MaxInt);
  end;
end;

procedure TPreferences.SetPrefix(const Value: string);
begin
  FPrefix := Value;
end;

function TPreferences.GetNames(Index: Integer): string;
begin
  Result := fPrefs.Names[Index];
end;

function TPreferences.GetCount: Integer;
begin
  Result := fPrefs.Count;
end;

{ TStoredPreferences }

constructor TStoredPreferences.Create(const aFileName: string);
begin
  inherited Create;
  fFileName := aFileName;
end;

procedure TStoredPreferences.Load;
begin
  try
    LoadFromFile(fFileName);
  except
    //
  end;  
end;

procedure TStoredPreferences.Save;
begin
  SaveToFile(fFileName);
end;

end.
