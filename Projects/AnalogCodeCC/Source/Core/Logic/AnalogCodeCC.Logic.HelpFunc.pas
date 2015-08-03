unit AnalogCodeCC.Logic.HelpFunc;

interface

uses
  Data.Win.ADODB;

procedure CreateTempTable(aQuery: TADOQuery; aName: string; aColumn: array of const);
procedure DropTempTable(aQuery: TADOQuery; aName: string);
procedure InsertTempTable(aQuery: TADOQuery; aName: string; aColumn: array of Variant);

implementation

uses
  System.SysUtils;

procedure CreateTempTable(aQuery: TADOQuery; aName: string; aColumn: array of const);
var
  tmpText: string;
  tmpTextColumn: string;
  k: Integer;
begin
  tmpTextColumn := '';
  for k := 1 to Length(aColumn) do
    tmpTextColumn := tmpTextColumn + '%s, ';
  Delete(tmpTextColumn, Length(tmpTextColumn) - 1, 2);
  tmpTextColumn := Format(tmpTextColumn, aColumn);
  tmpText := Format('CREATE TABLE #%s (%s)', [aName, tmpTextColumn]);
  aQuery.SQL.Text := tmpText;
  aQuery.ExecSQL;
end;

procedure DropTempTable(aQuery: TADOQuery; aName: string);
begin
  aQuery.SQL.Text := Format('DROP TABLE #%s', [aName]);
  aQuery.ExecSQL;
end;

procedure InsertTempTable(aQuery: TADOQuery; aName: string; aColumn: array of Variant);
var
  tmpText: string;
  tmpTextColumns: string;
  k: Integer;
begin
  tmpTextColumns := '';
  for k := 0 to Length(aColumn) - 1 do
    tmpTextColumns := tmpTextColumns + Format(':v%d, ', [k]);
  Delete(tmpTextColumns, Length(tmpTextColumns) - 1, 2);
  tmpText := Format('INSERT INTO #%s' + #13#10 + 'VALUES(%s)', [aName, tmpTextColumns]);
  aQuery.SQL.Text := tmpText;
  for k := 0 to Length(aColumn) - 1 do
    aQuery.Parameters.ParamValues[Format('v%d', [k])] := aColumn[k];
  aQuery.ExecSQL;
end;

end.
