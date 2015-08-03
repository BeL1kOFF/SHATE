unit ConfigPackage.Logic.TCustomSection;

interface

uses
  ConfigPackage.Logic.TDefaultValueAttribute,
  System.IniFiles,
  System.Rtti;

type
  TCustomSection = class(TObject)
  strict private
    FRttiContext: TRttiContext;
    FIniFile: TCustomIniFile;
    FSectionName: string;
  strict protected
    function GetDefaultAttribute(const ARttiProperty: TRttiProperty): TDefaultValueAttribute;

    function GetProperty(const AIndex: Integer): TRttiProperty;

    function GetGenericValue<T>(const AIndex: Integer): T;
    procedure SetGenericValue<T>(const AIndex: Integer; const AValue: T);

    function GetBooleanValue(const AIndex: Integer): Boolean; virtual;
    function GetIntegerValue(const AIndex: Integer): Integer; virtual;
    function GetStringValue(const AIndex: Integer): string; virtual;

    procedure SetBooleanValue(const AIndex: Integer; const AValue: Boolean); virtual;
    procedure SetIntegerValue(const AIndex: Integer; const AValue: Integer); virtual;
    procedure SetStringValue(const AIndex: Integer; const AValue: string); virtual;

  public
    constructor Create(const AIniFile: TCustomIniFile); reintroduce;
    destructor Destroy(); override;
  end;

resourcestring
  RsUndefinedPropertyName = 'Undefined property name';

implementation

uses
  System.TypInfo,
  System.SysUtils,
  System.Classes,
  ConfigPackage.Logic.TSectionAttribute;

resourcestring
  RsPropertyDoesNotExists = 'Property %d does not exists.';

constructor TCustomSection.Create(const AIniFile: TCustomIniFile);
var
  Ctx: TRttiContext;
  Attr: TCustomAttribute;
  RttiType: TRttiType;
begin
  inherited Create();
  FIniFile := AIniFile;

  FRttiContext := TRttiContext.Create();

  RttiType := Ctx.GetType(Self.ClassType);
  for Attr in RttiType.GetAttributes() do
  begin
    if Attr is TSectionAttribute then
    begin
      FSectionName := (Attr as TSectionAttribute).Name;
    end;
  end;
end;

destructor TCustomSection.Destroy();
begin
  FRttiContext.Free();
  inherited;
end;

function TCustomSection.GetProperty(const AIndex: Integer): TRttiProperty;
var
  RttiType: TRttiType;
  Props: TArray<TRttiProperty>;
begin
  RttiType := FRttiContext.GetType(Self.ClassType);
  Props := RttiType.GetProperties();
  if AIndex > Length(Props) then
  begin
    raise EArgumentOutOfRangeException.Create(Format(RsPropertyDoesNotExists, [AIndex]));
  end;

  Result := Props[AIndex];
end;

function TCustomSection.GetDefaultAttribute(const ARttiProperty: TRttiProperty): TDefaultValueAttribute;
var
  Attr: TCustomAttribute;
begin
  Result := nil;
  for Attr in ARttiProperty.GetAttributes() do
  begin
    if Attr is TDefaultValueAttribute then
    begin
      Result := Attr as TDefaultValueAttribute;
    end;
  end;
end;

function TCustomSection.GetGenericValue<T>(const AIndex: Integer): T;
var
  Prop: TRttiProperty;
  Def: TDefaultValueAttribute;
  Val: TValue;
begin
  Prop := GetProperty(AIndex);
  if not Assigned(Prop) then
  begin
    raise Exception.Create(RsUndefinedPropertyName);
  end;

  Def := GetDefaultAttribute(Prop);

  if FIniFile.ValueExists(FSectionName, Prop.Name) then
  begin
    case Prop.PropertyType.TypeKind of
      tkInteger:
        begin
          Val := FIniFile.ReadInteger(FSectionName, Prop.Name, Def.Value.AsInteger());
        end;
      tkString, tkUString:
        begin
          Val := FIniFile.ReadString(FSectionName, Prop.Name, Def.Value.AsString());
        end;
      tkEnumeration:
        begin
          Val := FIniFile.ReadInteger(FSectionName, Prop.Name, ord(Def.Value.AsBoolean())) <> 0;
        end;
    end;
    Result := Val.AsType<T>();
  end
  else
  begin
    if Assigned(Def) then
    begin
      Result := Def.Value.AsType<T>();
    end
    else
    begin
      Result := System.Default(T);
    end;
  end;
end;

function TCustomSection.GetIntegerValue(const AIndex: Integer): Integer;
begin
  Result := GetGenericValue<Integer>(AIndex);
end;

function TCustomSection.GetBooleanValue(const AIndex: Integer): Boolean;
begin
  Result := GetGenericValue<Boolean>(AIndex);
end;

function TCustomSection.GetStringValue(const AIndex: Integer): string;
begin
  Result := GetGenericValue<string>(AIndex);
end;

procedure TCustomSection.SetGenericValue<T>(const AIndex: Integer; const AValue: T);
var
  Prop: TRttiProperty;
  Val: TValue;
  sl: TStringList;
begin
  Prop := GetProperty(AIndex);
  if not Assigned(Prop) then
  begin
    raise Exception.Create(RsUndefinedPropertyName);
  end;

  Val := TValue.From<T>(AValue);

  sl := TStringList.Create();
  try
    case PTypeInfo(TypeInfo(T)).Kind of
      tkInteger:
        begin
          if GetDefaultAttribute(Prop).Value.AsInteger() <> Val.AsInteger() then
          begin
            FIniFile.WriteInteger(FSectionName, Prop.Name, Val.AsInteger());
          end
          else
          begin
            FIniFile.DeleteKey(FSectionName, Prop.Name);
          end;
        end;
      tkString, tkUString:
        begin
          if GetDefaultAttribute(Prop).Value.AsString() <> Val.AsString() then
          begin
            FIniFile.WriteString(FSectionName, Prop.Name, Val.AsString());
          end
          else
          begin
            FIniFile.DeleteKey(FSectionName, Prop.Name);
          end;
        end;
      tkEnumeration:
        begin
          if GetDefaultAttribute(Prop).Value.AsBoolean() <> Val.AsBoolean() then
          begin
            FIniFile.WriteBool(FSectionName, Prop.Name, Val.AsBoolean());
          end
          else
          begin
            FIniFile.DeleteKey(FSectionName, Prop.Name);
          end;
        end;
    end;
    FIniFile.ReadSectionValues(FSectionName, sl);
    if sl.Count = 0 then
    begin
      FIniFile.EraseSection(FSectionName);
    end;
  finally
    sl.Free();
  end;
end;

procedure TCustomSection.SetBooleanValue(const AIndex: Integer; const AValue: Boolean);
begin
  SetGenericValue<Boolean>(AIndex, AValue);
end;

procedure TCustomSection.SetIntegerValue(const AIndex, AValue: Integer);
begin
  SetGenericValue<Integer>(AIndex, AValue);
end;

procedure TCustomSection.SetStringValue(const AIndex: Integer; const AValue: string);
begin
  SetGenericValue<string>(AIndex, AValue);
end;

end.
