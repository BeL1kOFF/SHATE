unit Logic.UserFunctions;

interface

uses
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  UI.InputBox;

function InputBoxRevision(aOwner: TForm; aCaption, aText: string; var aValue: string): TModalResult;
function GenerateScriptName(aBody: TStrings): string;
function GetUserName: string;
procedure QueryExec(aFDConnection: TFDConnection; const aQuerySQL: string; const aParam: array of Variant);
procedure CheckDBRevision(aQuery: TFDQuery);
procedure CreateTempTable(aFDConnection: TFDConnection; const aName: string; aColumn: array of const);
procedure DropTempTable(aFDConnection: TFDConnection; const aName: string);
procedure InsertTempTable(aFDConnection: TFDConnection; const aName: string; aColumn: array of Variant);

implementation

uses
  Winapi.Windows,
  System.SysUtils,
  Logic.ScriptName.IInstructionFactory,
  Logic.ScriptName.TInstructionFactory,
  Logic.ScriptName.IInstruction;

function GenerateScriptName(aBody: TStrings): string;
var
  InstructionFactory: IInstructionFactory;
  Instruction: IInstruction;
begin
  InstructionFactory := TInstructionFactory.Create(aBody);
  Instruction := InstructionFactory.GetInstruction();
  if Assigned(Instruction) then
    Result := Instruction.GetScriptName()
  else
    Result := '';
end;

function InputBoxRevision(aOwner: TForm; aCaption, aText: string; var aValue: string): TModalResult;
var
  frmInputBox: TfrmInputBox;
begin
  frmInputBox := TfrmInputBox.Create(aOwner, aCaption, aText, aValue);
  try
    Result := frmInputBox.ShowModal();
    if Result = mrOk then
      aValue := frmInputBox.ValueText;
  finally
    frmInputBox.Free();
  end;
end;

function GetUserName: string;
type
  EXTENDED_NAME_FORMAT = (NameUnknown = 0, NameFullyQualifiedDN = 1, NameSamCompatible = 2, NameDisplay = 3,
                          NameUniqueId = 6, NameCanonical = 7, NameUserPrincipal = 8, NameCanonicalEx = 9,
                          NameServicePrincipal = 10, NameDnsDomain = 12);

  TFuncGetUserNameEx = function (NameFormat: EXTENDED_NAME_FORMAT; lpNameBuffer: LPWSTR; lpnSize: PULONG): BOOL; stdcall;
var
  H: THandle;
  GetUserNameEx: TFuncGetUserNameEx;
  lnName: ULONG;
begin
  Result := '';
  H := LoadLibrary('secur32.dll');
  if H <> 0 then
    try
      GetUserNameEx := GetProcAddress(H, 'GetUserNameExW');
      if @GetUserNameEx <> nil then
      begin
        lnName := 256;
        SetLength(Result, lnName);
        if GetUserNameEx(NameSamCompatible, PChar(Result), @lnName).ToInteger() = 0 then
          SetLength(Result, 0)
        else
          SetLength(Result, lnName);
      end;
    finally
      FreeLibrary(H);
    end;
end;

procedure QueryExec(aFDConnection: TFDConnection; const aQuerySQL: string; const aParam: array of Variant);
var
  Query: TFDQuery;
  k: Integer;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := aFDConnection;
    Query.SQL.Text := aQuerySQL;
    for k := 0 to Length(aParam) - 1 do
      Query.Params.Items[k].Value := aParam[k];
    Query.ExecSQL();
  finally
    Query.Free();
  end;
end;

procedure CheckDBRevision(aQuery: TFDQuery);
begin
  aQuery.SQL.Text := 'IF OBJECT_ID(''DBRevision'') IS NULL'#13#10 +
                     'BEGIN'#13#10 +
                     'CREATE TABLE DBRevision (Id_Template INT NOT NULL, [Index] INT NOT NULL, Id_SQLScriptCommited INT NOT NULL)'#13#10 +
                     'ALTER TABLE DBRevision ADD CONSTRAINT PK_DBRevision PRIMARY KEY CLUSTERED'#13#10 +
                     '([Index] ASC)'#13#10 +
                     'END';
  aQuery.ExecSQL();
end;

procedure CreateTempTable(aFDConnection: TFDConnection; const aName: string; aColumn: array of const);
var
  tmpText: string;
  tmpTextColumn: string;
  k: Integer;
  Query: TFDQuery;
begin
  tmpTextColumn := '';
  for k := 1 to Length(aColumn) do
    tmpTextColumn := tmpTextColumn + '%s, ';
  Delete(tmpTextColumn, Length(tmpTextColumn) - 1, 2);
  tmpTextColumn := Format(tmpTextColumn, aColumn);
  tmpText := Format('CREATE TABLE #%s (%s)', [aName, tmpTextColumn]);
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := aFDConnection;
    Query.SQL.Text := tmpText;
    Query.ExecSQL;
  finally
    Query.Free();
  end;
end;

procedure InsertTempTable(aFDConnection: TFDConnection; const aName: string; aColumn: array of Variant);
var
  tmpText: string;
  tmpTextColumns: string;
  k: Integer;
  Query: TFDQuery;
begin
  tmpTextColumns := '';
  for k := 0 to Length(aColumn) - 1 do
    tmpTextColumns := tmpTextColumns + Format(':v%d, ', [k]);
  Delete(tmpTextColumns, Length(tmpTextColumns) - 1, 2);
  tmpText := Format('INSERT INTO #%s' + #13#10 + 'VALUES(%s)', [aName, tmpTextColumns]);
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := aFDConnection;
    Query.SQL.Text := tmpText;
    for k := 0 to Length(aColumn) - 1 do
      Query.Params.ParamValues[Format('v%d', [k])] := aColumn[k];
    Query.ExecSQL;
  finally
    Query.Free();
  end;
end;

procedure DropTempTable(aFDConnection: TFDConnection; const aName: string);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := aFDConnection;
    Query.SQL.Text := Format('DROP TABLE #%s', [aName]);
    Query.ExecSQL;
  finally
    Query.Free();
  end;
end;

end.
