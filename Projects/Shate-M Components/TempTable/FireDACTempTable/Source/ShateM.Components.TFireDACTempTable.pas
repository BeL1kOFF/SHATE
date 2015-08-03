unit ShateM.Components.TFireDACTempTable;

interface

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Comp.Client,
  ShateM.Utils.MSSQL,
  ShateM.Components.TCustomTempTable;

type
  TsmFireDACTempTable = class(TCustomTempTable)
  private
    FConnection: TFDConnection;
    function GetDataSet: TFDQuery;
    procedure SetConnection(const aValue: TFDConnection);
    property DataSet: TFDQuery read GetDataSet;
  protected
    function CreateDataSet: TDataSet; override;
  public
    class function GetCrossDataType(aMSSQLFieldType: TMSSQLFieldType): TFieldType; override;
    class function GetCrossMSSQLDataType(aFieldType: TFieldType): TMSSQLFieldType; override;
    procedure CreateTempTable; override;
    procedure InsertTempTable(const aValueList: array of TFieldValue);
    procedure DropTempTable; override;
  published
    property Connection: TFDConnection read FConnection write SetConnection;
  end;

  EFireDACTempTable = class(Exception);

implementation

uses
  FireDAC.Stan.Param;

const
  CROSS_DATATYPE: array[TMSSQLFieldType] of TFieldType = (ftUnknown, ftByte, ftSmallint, ftInteger, ftLargeint, ftFMTBcd,
    ftFMTBcd, ftBoolean, ftCurrency, ftCurrency, ftFloat, TFieldType.ftSingle, ftDate, ftTime, ftTimeStamp, ftTimeStamp,
    ftTimeStamp, ftString, ftString, ftMemo, ftWideString, ftWideMemo, ftBytes, ftBlob, ftGuid, ftBlob, ftMemo, ftWideMemo);

  CROSS_DATATYPE_BACK: array[TFieldType] of TMSSQLFieldType = (mftUnknown, mftChar, mftSmallInt, mftInt, mftUnknown,
    mftBit, mftFloat, mftMoney, mftUnknown, mftDate, mftTime, mftUnknown, mftBinary, mftUnknown, mftUnknown,
    mftVarBinary, mftVarChar, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown,
    mftNChar, mftBigInt, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown,
    mftUnknown, mftUnknown, mftUniqueidentifier, mftDateTime2, mftDecimal, mftUnknown, mftNVarChar, mftUnknown,
    mftUnknown, mftUnknown, mftUnknown, mftTinyInt, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown,
    mftUnknown, mftUnknown);

{ TsmFireDACTempTable }

function TsmFireDACTempTable.CreateDataSet: TDataSet;
begin
  Result := TFDQuery.Create(Self);
end;

procedure TsmFireDACTempTable.CreateTempTable;
begin
  if not Assigned(FConnection) then
    raise EFireDACTempTable.Create('Connection не задан');
  DataSet.SQL.Text := GetStringCreate();
  DataSet.ExecSQL();
  inherited CreateTempTable();
end;

procedure TsmFireDACTempTable.DropTempTable;
begin
  if not Assigned(FConnection) then
    raise EFireDACTempTable.Create('Connection не задан');
  DataSet.SQL.Text := GetStringDelete();
  DataSet.ExecSQL();
  inherited DropTempTable();
end;

class function TsmFireDACTempTable.GetCrossDataType(aMSSQLFieldType: TMSSQLFieldType): TFieldType;
begin
  Result := CROSS_DATATYPE[aMSSQLFieldType];
end;

class function TsmFireDACTempTable.GetCrossMSSQLDataType(aFieldType: TFieldType): TMSSQLFieldType;
begin
  Result := CROSS_DATATYPE_BACK[aFieldType];
end;

function TsmFireDACTempTable.GetDataSet: TFDQuery;
begin
  Result := inherited DataSet as TFDQuery;
end;

procedure TsmFireDACTempTable.InsertTempTable(const aValueList: array of TFieldValue);
var
  k: Integer;
  Parameter: TFDParam;
begin
  if not Assigned(FConnection) then
    raise EFireDACTempTable.Create('Connection не задан');
  DataSet.SQL.Text := GetStringInsert(aValueList);
  for k := Low(aValueList) to High(aValueList) do
  begin
    Parameter := DataSet.Params.ParamByName(aValueList[k].FieldName);
    Parameter.DataType := GetFieldByName(aValueList[k].FieldName);
    Parameter.Value := aValueList[k].Value;
  end;
  DataSet.ExecSQL();
end;

procedure TsmFireDACTempTable.SetConnection(const aValue: TFDConnection);
begin
  if FConnection <> aValue then
  begin
    FConnection := aValue;
    DataSet.Connection := aValue;
  end;
end;

end.
