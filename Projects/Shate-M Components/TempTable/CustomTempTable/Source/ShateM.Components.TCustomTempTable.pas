unit ShateM.Components.TCustomTempTable;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  ShateM.Utils.MSSQL;

type
  TFieldTableTypeAttribute = (fttaRequired, fttaAutoIncrement);
  TFieldTableTypeAttributes = set of TFieldTableTypeAttribute;

  TMSSQLFieldTable = class(TCollectionItem)
  strict private
    FAttributes: TFieldTableTypeAttributes;
    FMSSQLDataType: TMSSQLFieldType;
    FFieldName: string;
    FPrecision: Word;
    FScale: Word;
    FSize: Integer;
    procedure SetMSSQLDataType(const aValue: TMSSQLFieldType);
    procedure SetPrecision(const aValue: Word);
    procedure SetScale(const aValue: Word);
    procedure SetSize(const aValue: Integer);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(aCollection: TCollection); override;
    procedure SetSizeScalePrecision(aSizeScale: Integer; aPrecision: Word = 0);
  published
    property Attributes: TFieldTableTypeAttributes read FAttributes write FAttributes default [];
    property MSSQLDataType: TMSSQLFieldType read FMSSQLDataType write SetMSSQLDataType default mftInt;
    property FieldName: string read FFieldName write FFieldName;
    property Precision: Word read FPrecision write SetPrecision default 10;
    property Scale: Word read FScale write SetScale default 0;
    property Size: Integer read FSize write SetSize default 4;
  end;

  TFieldTableCollection = class(TOwnedCollection)
  private
    function GetItem(aIndex: Integer): TMSSQLFieldTable;
    procedure SetItem(aIndex: Integer; const aValue: TMSSQLFieldTable);
  public
    constructor Create(aOwner: TPersistent);
    function Add: TMSSQLFieldTable;
    function IndexOfFieldName(const aValue: string): TMSSQLFieldTable;
    property Items[aIndex: Integer]: TMSSQLFieldTable read GetItem write SetItem; default;
  end;

  TFieldValue = record
  private
    FFieldName: string;
    FValue: Variant;
  public
    constructor Create(const aFieldName: string; const aValue: Variant);
    property FieldName: string read FFieldName;
    property Value: Variant read FValue;
  end;

  TCustomTempTable = class(TComponent)
  private
    FDataSet: TDataSet;
    FFields: TFieldTableCollection;
    FIsCreated: Boolean;
    FTableName: string;
    function GetStringFields: string;
    procedure SetFields(const aValue: TFieldTableCollection);
  protected
    function CreateDataSet: TDataSet; virtual; abstract;
    function GetFieldByName(const aName: string): TFieldType;
    function GetStringCreate: string;
    function GetStringDelete: string;
    function GetStringInsert(const aValueList: array of TFieldValue): string;
    property DataSet: TDataSet read FDataSet write FDataSet;
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    class function GetCrossDataType(aMSSQLFieldType: TMSSQLFieldType): TFieldType; virtual; abstract;
    class function GetCrossMSSQLDataType(aFieldType: TFieldType): TMSSQLFieldType; virtual; abstract;
    procedure CreateTempTable; virtual;
    procedure DropTempTable; virtual;
    property IsCreated: Boolean read FIsCreated;
  published
    property Fields: TFieldTableCollection read FFields write SetFields;
    property TableName: string read FTableName write FTableName;
  end;

  EMSSQLFieldTable = class(Exception);
  ECustomTempTable = class(Exception);

implementation

uses
  System.TypInfo,
  System.Math;

type
  TDefaultFieldTableType = record
    Precision: Word;
    Scale: Word;
    Size: Integer;
  end;

const
  DEFAULT_FIELD_TABLE_TYPE: array[TMSSQLFieldType] of TDefaultFieldTableType =
    ((Precision: 0;  Scale: 0;  Size: 0),     //mftUnknown
     (Precision: 3;  Scale: 0;  Size: 1),     //mftTinyInt
     (Precision: 5;  Scale: 0;  Size: 2),     //mftSmallInt
     (Precision: 10; Scale: 0;  Size: 4),     //mftInt
     (Precision: 19; Scale: 0;  Size: 8),     //mftBigInt
     (Precision: 38; Scale: 38; Size: 17),    //mftDecimal
     (Precision: 38; Scale: 38; Size: 17),    //mftNumeric
     (Precision: 1;  Scale: 0;  Size: 1),     //mftBit
     (Precision: 10; Scale: 4;  Size: 4),     //mftSmallMoney
     (Precision: 19; Scale: 4;  Size: 8),     //mftMoney
     (Precision: 53; Scale: 0;  Size: 8),     //mftFloat
     (Precision: 24; Scale: 0;  Size: 4),     //mftReal
     (Precision: 10; Scale: 0;  Size: 3),     //mftDate
     (Precision: 16; Scale: 7;  Size: 5),     //mftTime
     (Precision: 16; Scale: 0;  Size: 4),     //mftSmallDateTime
     (Precision: 23; Scale: 3;  Size: 8),     //mftDateTime
     (Precision: 27; Scale: 7;  Size: 8),     //mftDateTime2
     (Precision: 34; Scale: 7;  Size: 10),    //mftDateTimeOffset
     (Precision: 0;  Scale: 0;  Size: 8000),  //mftChar
     (Precision: 0;  Scale: 0;  Size: 8000),  //mftVarChar
     (Precision: 0;  Scale: 0;  Size: 4000),  //mftNChar
     (Precision: 0;  Scale: 0;  Size: 4000),  //mftNVarChar
     (Precision: 0;  Scale: 0;  Size: 8000),  //mftBinary
     (Precision: 0;  Scale: 0;  Size: 8000),  //mftVarBinary
     (Precision: 0;  Scale: 0;  Size: 16),    //mftUniqueidentifier
     (Precision: 0;  Scale: 0;  Size: 16),    //mftImage
     (Precision: 0;  Scale: 0;  Size: 16),    //mftText
     (Precision: 0;  Scale: 0;  Size: 16));   //mftNText

resourcestring
  RsExceptionPrecision = 'Значение точности должно быть от 1 до %d.';
  RsExceptionScale     = 'Значение масштаба должно находиться в диапазоне от 0 до %d.';
  RsExceptionSize      = 'Значение длины должно находиться в диапазоне от 1 до %d.';

{ TCustomTempTable }

constructor TCustomTempTable.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FDataSet := CreateDataSet();
  FFields := TFieldTableCollection.Create(Self);
  FIsCreated := False;
  FTableName := '';
end;

procedure TCustomTempTable.CreateTempTable;
begin
  FIsCreated := True;
end;

destructor TCustomTempTable.Destroy;
begin
  if FIsCreated then
    DropTempTable();
  FreeAndNil(FFields);
  FreeAndNil(FDataSet);
  inherited Destroy();
end;

procedure TCustomTempTable.DropTempTable;
begin
  FIsCreated := False;
end;

function TCustomTempTable.GetFieldByName(const aName: string): TFieldType;
var
  Field: TMSSQLFieldTable;
begin
  Field := Fields.IndexOfFieldName(aName);
  Result := GetCrossDataType(Field.MSSQLDataType);
end;

function TCustomTempTable.GetStringCreate: string;
begin
  Result := Format('CREATE TABLE [#%s] (%s)', [TableName, GetStringFields()]);
end;

function TCustomTempTable.GetStringDelete: string;
begin
  Result := Format('DROP TABLE [#%s]', [TableName]);
end;

function TCustomTempTable.GetStringFields: string;
var
  k: Integer;
  Field: TMSSQLFieldTable;
begin
  if Fields.Count = 0 then
    raise ECustomTempTable.Create('Не заданы поля!');
  Result := '';
  for k := 0 to Fields.Count - 1 do
  begin
    Field := Fields[k];
    case Field.MSSQLDataType of
      mftTinyInt:
        Result := Result + Format('[%s] TINYINT', [Field.FieldName]);
      mftSmallInt:
        Result := Result + Format('[%s] SMALLINT', [Field.FieldName]);
      mftInt:
        Result := Result + Format('[%s] INT', [Field.FieldName]);
      mftBigInt:
        Result := Result + Format('[%s] BIGINT', [Field.FieldName]);
      mftDecimal:
        Result := Result + Format('[%s] DECIMAL(%d, %d)', [Field.FieldName, Field.Precision, Field.Scale]);
      mftNumeric:
        Result := Result + Format('[%s] NUMERIC(%d, %d)', [Field.FieldName, Field.Precision, Field.Scale]);
      mftBit:
        Result := Result + Format('[%s] BIT', [Field.FieldName]);
      mftSmallMoney:
        Result := Result + Format('[%s] SMALLMONEY', [Field.FieldName]);
      mftMoney:
        Result := Result + Format('[%s] MONEY', [Field.FieldName]);
      mftFloat:
        Result := Result + Format('[%s] FLOAT', [Field.FieldName]);
      mftReal:
        Result := Result + Format('[%s] REAL', [Field.FieldName]);
      mftDate:
        Result := Result + Format('[%s] DATE', [Field.FieldName]);
      mftTime:
        Result := Result + Format('[%s] TIME(%d)', [Field.FieldName, Field.Scale]);
      mftSmallDateTime:
        Result := Result + Format('[%s] SMALLDATETIME', [Field.FieldName]);
      mftDateTime:
        Result := Result + Format('[%s] DATETIME', [Field.FieldName]);
      mftDateTime2:
        Result := Result + Format('[%s] DATETIME2(%d)', [Field.FieldName, Field.Scale]);
      mftDateTimeOffset:
        Result := Result + Format('[%s] DATETIMEOFFSET(%d)', [Field.FieldName, Field.Scale]);
      mftChar:
        Result := Result + Format('[%s] CHAR(%d)', [Field.FieldName, Field.Size]);
      mftVarChar:
        if Field.Size = -1 then
          Result := Result + Format('[%s] VARCHAR(MAX)', [Field.FieldName])
        else
          Result := Result + Format('[%s] VARCHAR(%d)', [Field.FieldName, Field.Size]);
      mftNChar:
        Result := Result + Format('[%s] NCHAR(%d)', [Field.FieldName, Field.Size]);
      mftNVarChar:
        if Field.Size = -1 then
          Result := Result + Format('[%s] NVARCHAR(MAX)', [Field.FieldName])
        else
          Result := Result + Format('[%s] NVARCHAR(%d)', [Field.FieldName, Field.Size]);
      mftBinary:
        Result := Result + Format('[%s] BINARY(%d)', [Field.FieldName, Field.Size]);
      mftVarBinary:
        if Field.Size = -1 then
          Result := Result + Format('[%s] VARBINARY(MAX)', [Field.FieldName])
        else
          Result := Result + Format('[%s] VARBINARY(%d)', [Field.FieldName, Field.Size]);
    end;

    if fttaAutoIncrement in Field.Attributes then
      Result := Result + ' IDENTITY(1, 1)';

    if fttaRequired in Field.Attributes then
      Result := Result + ' NOT NULL';

    if k < Fields.Count - 1 then
      Result := Result + ', ';
  end;
end;

function TCustomTempTable.GetStringInsert(const aValueList: array of TFieldValue): string;
var
  k: Integer;
  tmpString: string;
begin
  tmpString := '';
  for k := 0 to Length(aValueList) - 1 do
    tmpString := tmpString + Format(':%s, ', [aValueList[k].FieldName]);
  Delete(tmpString, Length(tmpString) - 1, 2);
  Result := Format('INSERT INTO [#%s]'#13#10'VALUES (%s)', [TableName, tmpString]);
end;

procedure TCustomTempTable.SetFields(const aValue: TFieldTableCollection);
begin
  FFields.Assign(aValue);
end;

{ TFieldTableCollection }

function TFieldTableCollection.Add: TMSSQLFieldTable;
begin
  Result := TMSSQLFieldTable(inherited Add());
end;

constructor TFieldTableCollection.Create(aOwner: TPersistent);
begin
  inherited Create(aOwner, TMSSQLFieldTable);
end;

function TFieldTableCollection.GetItem(aIndex: Integer): TMSSQLFieldTable;
begin
  Result := TMSSQLFieldTable(inherited GetItem(aIndex));
end;

function TFieldTableCollection.IndexOfFieldName(const aValue: string): TMSSQLFieldTable;
var
  k: Integer;
begin
  for k := 0 to Count - 1 do
    if SameText(Items[k].FieldName, aValue) then
      Exit(Items[k]);
  Result := nil;
end;

procedure TFieldTableCollection.SetItem(aIndex: Integer; const aValue: TMSSQLFieldTable);
begin
  inherited SetItem(aIndex, aValue);
end;

{ TMSSQLFieldTable }

constructor TMSSQLFieldTable.Create(aCollection: TCollection);
begin
  inherited Create(aCollection);
  FFieldName := '';
  MSSQLDataType := mftInt;
end;

function TMSSQLFieldTable.GetDisplayName: string;
begin
  Result := FFieldName;
end;

procedure TMSSQLFieldTable.SetMSSQLDataType(const aValue: TMSSQLFieldType);
begin
  if FMSSQLDataType <> aValue then
  begin
    FMSSQLDataType := aValue;
    FPrecision := DEFAULT_FIELD_TABLE_TYPE[FMSSQLDataType].Precision;
    FScale := DEFAULT_FIELD_TABLE_TYPE[FMSSQLDataType].Scale;
    FSize := DEFAULT_FIELD_TABLE_TYPE[FMSSQLDataType].Size;
    Changed(False);
  end;
end;

procedure TMSSQLFieldTable.SetPrecision(const aValue: Word);
begin
  if (FMSSQLDataType in [mftDecimal, mftNumeric]) and (FPrecision <> aValue) then
    if (aValue >= 1) and (aValue <= DEFAULT_FIELD_TABLE_TYPE[FMSSQLDataType].Precision) then
    begin
      FPrecision := aValue;
      if FPrecision < FScale then
        FScale := FPrecision;
    end
    else
      raise EMSSQLFieldTable.CreateFmt(RsExceptionPrecision, [DEFAULT_FIELD_TABLE_TYPE[FMSSQLDataType].Precision]);
end;

procedure TMSSQLFieldTable.SetScale(const aValue: Word);
begin
  if (FMSSQLDataType in [mftDateTime2, mftDateTimeOffset, mftDecimal, mftNumeric, mftTime]) and
     (FScale <> aValue) then
    if aValue <= Min(DEFAULT_FIELD_TABLE_TYPE[FMSSQLDataType].Scale, FPrecision) then
      FScale := aValue
    else
      raise EMSSQLFieldTable.CreateFmt(RsExceptionScale, [Min(DEFAULT_FIELD_TABLE_TYPE[FMSSQLDataType].Scale, FPrecision)]);
end;

procedure TMSSQLFieldTable.SetSize(const aValue: Integer);
begin
  if (FMSSQLDataType in [mftBinary, mftChar, mftNChar, mftNVarChar, mftVarBinary, mftVarChar]) and
     (FSize <> aValue) then
  begin
    if ((aValue >= 1) and (aValue <= DEFAULT_FIELD_TABLE_TYPE[FMSSQLDataType].Size)) or
       ((aValue = -1) and (FMSSQLDataType in [mftNVarChar, mftVarBinary, mftVarChar])) then
      FSize := aValue
    else
      raise EMSSQLFieldTable.CreateFmt(RsExceptionSize, [DEFAULT_FIELD_TABLE_TYPE[FMSSQLDataType].Size]);
  end;
end;

procedure TMSSQLFieldTable.SetSizeScalePrecision(aSizeScale: Integer; aPrecision: Word);
begin
  case FMSSQLDataType of
    mftBinary, mftChar, mftNChar, mftNVarChar, mftVarBinary, mftVarChar:
      Size := aSizeScale;
    mftDateTime2, mftDateTimeOffset, mftTime:
      Scale := aSizeScale;
    mftDecimal, mftNumeric:
      begin
        Precision := aPrecision;
        Scale := aSizeScale;
      end;
  end;
end;

{ TFieldValue }

constructor TFieldValue.Create(const aFieldName: string; const aValue: Variant);
begin
  Self.FFieldName := aFieldName;
  Self.FValue := aValue;
end;

end.
