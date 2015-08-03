unit ShateM.Components.TADOTempTable;

interface

uses
  Data.DB,
  Data.Win.ADODB,
  ShateM.Utils.MSSQL,
  ShateM.Components.TCustomTempTable;

type
  TsmADOTempTable = class(TCustomTempTable)
  private
    FConnection: TADOConnection;
    function GetDataSet: TADOQuery;
    procedure SetConnection(const aValue: TADOConnection);
    property DataSet: TADOQuery read GetDataSet;
  protected
    function CreateDataSet: TDataSet; override;
  public
    class function GetCrossDataType(aMSSQLFieldType: TMSSQLFieldType): TFieldType; override;
    class function GetCrossMSSQLDataType(aFieldType: TFieldType): TMSSQLFieldType; override;
    procedure CreateTempTable; override;
    procedure InsertTempTable(const aValueList: array of TFieldValue);
    procedure DropTempTable; override;
  published
    property Connection: TADOConnection read FConnection write SetConnection;
  end;

implementation

const
  CROSS_DATATYPE: array[TMSSQLFieldType] of TFieldType = (ftUnknown, ftWord, ftSmallint, ftInteger, ftLargeint, ftFMTBcd,
    ftFMTBcd, ftBoolean, ftBCD, ftBCD, ftFloat, ftFloat, ftWideString, ftWideString, ftDateTime, ftDateTime, ftWideString,
    ftWideString, ftString, ftMemo, ftWideString, ftWideMemo, ftBytes, ftBlob, ftGuid, ftBlob, ftMemo, ftWideMemo);

  CROSS_DATATYPE_BACK: array[TFieldType] of TMSSQLFieldType = (mftUnknown, mftVarChar, mftSmallInt, mftInt, mftTinyInt,
    mftBit, mftFloat, mftUnknown, mftDecimal, mftUnknown, mftUnknown, mftDateTime2, mftBinary, mftVarBinary, mftUnknown,
    mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown,
    mftNVarChar, mftBigInt, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown,
    mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown,
    mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown, mftUnknown,
    mftUnknown);

{ TsmADOTempTable }

function TsmADOTempTable.CreateDataSet: TDataSet;
begin
  Result := TADOQuery.Create(Self);
end;

procedure TsmADOTempTable.CreateTempTable;
begin
  DataSet.SQL.Text := GetStringCreate();
  DataSet.ExecSQL();
  inherited CreateTempTable();
end;

procedure TsmADOTempTable.DropTempTable;
begin
  DataSet.SQL.Text := GetStringDelete();
  DataSet.ExecSQL();
  inherited DropTempTable();
end;

class function TsmADOTempTable.GetCrossDataType(aMSSQLFieldType: TMSSQLFieldType): TFieldType;
begin
  Result := CROSS_DATATYPE[aMSSQLFieldType];
end;

class function TsmADOTempTable.GetCrossMSSQLDataType(aFieldType: TFieldType): TMSSQLFieldType;
begin
  Result := CROSS_DATATYPE_BACK[aFieldType];
end;

function TsmADOTempTable.GetDataSet: TADOQuery;
begin
  Result := inherited DataSet as TADOQuery;
end;

procedure TsmADOTempTable.InsertTempTable(const aValueList: array of TFieldValue);
var
  k: Integer;
  Parameter: TParameter;
begin
  DataSet.SQL.Text := GetStringInsert(aValueList);
  for k := Low(aValueList) to High(aValueList) do
  begin
    Parameter := DataSet.Parameters.ParamByName(aValueList[k].FieldName);
    Parameter.DataType := GetFieldByName(aValueList[k].FieldName);
    Parameter.Value := aValueList[k].Value;
  end;
  DataSet.ExecSQL();
end;

procedure TsmADOTempTable.SetConnection(const aValue: TADOConnection);
begin
  if FConnection <> aValue then
  begin
    FConnection := aValue;
    DataSet.Connection := aValue;
  end;
end;

end.
