unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ADODB, DB, ComCtrls, ExtCtrls, dbisamtb;

type
  TFormMain = class(TForm)
    connService: TADOConnection;
    insertQuery: TADOCommand;
    pb: TProgressBar;
    lbProgressInfo: TLabel;
    btAbort: TButton;
    msQuery: TADOQuery;
    btFill_Des: TButton;
    pnConnect: TPanel;
    Label2: TLabel;
    rbConnectionLocal: TRadioButton;
    rbConnectionServer: TRadioButton;
    btTestConnectMS: TButton;
    pnData: TPanel;
    cbLoadCatalog: TCheckBox;
    cbLoadAnalog: TCheckBox;
    cbLoadOE: TCheckBox;
    edFileCatalog: TEdit;
    btOpenFileCatalog: TButton;
    edFileAnalog: TEdit;
    btOpenFileAnalog: TButton;
    edFileOE: TEdit;
    btOpenFileOE: TButton;
    lbStatusCatalog: TLabel;
    lbStatusAnalog: TLabel;
    lbStatusOE: TLabel;
    Label1: TLabel;
    cbPrevRelease: TComboBox;
    Label3: TLabel;
    Bevel1: TBevel;
    btMoveToRelease: TButton;
    Button6: TButton;
    _Brand: TADOTable;
    _Group: TADOTable;
    _GroupBrand: TADOTable;
    GroupBrand: TADODataSet;
    Brand: TADODataSet;
    Group: TADODataSet;
    lbProgressPercent: TLabel;
    DBISAMEngine: TDBISAMEngine;
    Button8: TButton;
    memCatalog: TDBISAMTable;
    memCatalogCAT_ID: TIntegerField;
    memCatalogCODE2: TStringField;
    memCatalogBRAND_ID: TIntegerField;
    memAnalog: TDBISAMTable;
    IntegerField1: TIntegerField;
    memAnalogAN_CODE: TStringField;
    Button7: TButton;
    memBrand: TDBISAMTable;
    memBrandBRAND_ID: TIntegerField;
    memBrandDESCRIPTION: TStringField;
    memGroup: TDBISAMTable;
    memGroupGROUP_ID: TIntegerField;
    memGroupGROUP_DESCR: TStringField;
    memGroupSUBGROUP_ID: TIntegerField;
    memGroupSUBGROUP_DESCR: TStringField;
    btConnect: TButton;
    btDisconnect: TButton;
    OD: TOpenDialog;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    MemoCreateTemplate: TMemo;
    procedure btAbortClick(Sender: TObject);
    procedure btTestConnectMSClick(Sender: TObject);
    procedure btFill_DesClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure btDisconnectClick(Sender: TObject);
    procedure btOpenFileCatalogClick(Sender: TObject);
    procedure btOpenFileAnalogClick(Sender: TObject);
    procedure btOpenFileOEClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbLoadCatalogClick(Sender: TObject);
    procedure cbLoadAnalogClick(Sender: TObject);
    procedure cbLoadOEClick(Sender: TObject);
    procedure btMoveToReleaseClick(Sender: TObject);
  private
    fAborted: Boolean;
    fLockedBrands: TStrings;
    function GetAppDir: string;

    procedure Validate;
    procedure DBConnect(aTest: Boolean = False);
    procedure DBDisconnect;
    procedure DoAfterConnect;

    procedure UpdateStatusAll;
    procedure FillReleases;

    procedure SaveINI;
    procedure LoadINI;

    //DB utils
    function GetLastTableID(const aTableName: string): Integer;
    function GetTableRecordCount(const aTableName: string; const aWHERE: string = ''): Integer;
    function GetTableRecord(const aTableName: string; const aKey: string; const aWHERE: string = ''): string;
    function ExecuteSimpleSelectMS(const aSQL: string; aParams: array of Variant): string;
    function ExecuteQuery(const aSQL: string; aParams: array of Variant): Integer;
    procedure ClearTable(const aTableName: string; aResetGenerator: Boolean = True);
    procedure RenameTable(const OldName, NewName: string);
    function IsTableExists(const aTableName: string): Boolean;

    //load
    procedure LoadCatalog(const aFileName: string);
    procedure LoadGroupBrand(const aFileName: string);
    procedure LoadTitles(aCatID: integer);
    procedure LoadAnalogs(const aFileName: string);
    procedure LoadOE(const aFileName: string);

    procedure RenameAllTables(const aOldPrefix, aNewPrefix: string);
    procedure CreateAllTables(aForce: Boolean; const aPrefix: string = '');

    function LoadLockedBrands: Boolean;
    function IsBrandLocked(const aBrand: string): Boolean;

    //cache
    procedure CacheBrand(aForce: Boolean = False);
    procedure CacheGroup(aForce: Boolean = False);
    procedure CacheCatalog(aForce: Boolean = False);
    procedure CacheAnalog(aForce: Boolean = False);
  public
    procedure UpdateProgress(aPos: Integer; const aCaption: string = '');
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  IniFiles, 
  uSysGlobal, _CSVReader, uReleaseInfo;

{ TFormMain }

//******************************************************************************
(*

AT+CMGF=1 // перевод в текстовый режим
>OK
AT+CMGS=+7xxxxxxxxxx // здесь номер телефона
>
message   // надо дождаться приглашения '>' и после писать сообщение. Конец сообщения символ $1B вроде.
OK //после будет ещё какой-то код :)
*)

function MakeSearchCode(const s: string): string;
const
  Ign_chars = ' _';
var
  i: integer;
begin
  Result := AnsiUpperCase(s);
  for i := 1 to Length(Ign_chars) do
    Result := StringReplace(Result, Ign_chars[i], '', [rfReplaceAll]);
end;

function CreateShortCode(const aCode: string):string;
var
  sCode: string;
  sRes: string;
  i: Integer;
begin
  try
    sRes := '';
    sCode := AnsiUpperCase(aCode);
    if Length(sCode) > 0 then
    for I := 0 to Length(sCode) do
    begin
      if ((sCode[i]<='Z')and(sCode[i]>='A'))
         or((sCode[i]<='Я')and(sCode[i]>='А'))
         or((sCode[i]<='9')and(sCode[i]>='0'))
      then
        sRes := sRes + sCode[i];
    end;

    Result := sRes;
  except
    on E: Exception do
      MessageDlg('CreateShortCode - ' + aCode + ' - ' + E.Message, mtError, [mbOK], 0);
  end;
end;

function DecodeCodeBrand(const aCode_Brand: string; var aCode, aBrand: string; aMakeSearchCode: Boolean = True): Boolean;
var
  aPos: Integer;
begin
  aPos := Pos('_', aCode_Brand);
  if aPos > 0 then
  begin
    aCode := Copy(aCode_Brand, 1,  aPos - 1);
    aBrand := Copy(aCode_Brand, aPos + 1, MaxInt);
    if aMakeSearchCode then
      aCode := MakeSearchCode(aCode);
  end
  else
  begin
    aCode := '';
    aBrand := '';
  end;

  Result := (aCode <> '') and (aBrand <> '');
end;

function StrToFloatDefUnic(const aValue: string; aDef: Extended): Double;
var
  aNorm: string;
begin
  aNorm := aValue;
  if DecimalSeparator <> '.' then
    aNorm := StringReplace(aNorm, '.', DecimalSeparator, [rfReplaceAll]);
  if DecimalSeparator <> ',' then
    aNorm := StringReplace(aNorm, ',', DecimalSeparator, [rfReplaceAll]);
  Result := StrToFloatDef(aNorm, aDef);
end;

function TFormMain.GetAppDir: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  fLockedBrands := TStringList.Create;
  LoadINI;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveINI;
end;


procedure TFormMain.btConnectClick(Sender: TObject);
begin
  DBConnect;
end;

procedure TFormMain.btDisconnectClick(Sender: TObject);
begin
  DBDisconnect;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  fLockedBrands.Free;
  if connService.Connected then
    connService.Connected := False;
end;

procedure TFormMain.UpdateProgress(aPos: Integer; const aCaption: string);
begin
  if pb.Position <> aPos then
  begin
    pb.Position := aPos;
    lbProgressPercent.Caption := IntToStr(aPos) + '%';
  end;
  if aCaption <> '' then
    lbProgressInfo.Caption := aCaption;
  Application.ProcessMessages;
end;

procedure TFormMain.UpdateStatusAll;
  procedure ApplyTableStatus(const aTableName: string; aStatusLabel: TLabel);
  var
    aCount: Integer;
  begin
    aCount := GetTableRecordCount(aTableName);
    if aCount > 0 then
    begin
      aStatusLabel.Font.Color := clBlue;
      aStatusLabel.Caption := Format('%d зап.', [aCount]);
    end
    else
    begin
      aStatusLabel.Font.Color := clBlack;
      aStatusLabel.Caption := 'Не загружен';
    end;
  end;
begin
  ApplyTableStatus('CATALOG', lbStatusCatalog);
  ApplyTableStatus('ANALOG', lbStatusAnalog);
  ApplyTableStatus('OE', lbStatusOE);
end;

procedure TFormMain.FillReleases;
var
  aQuery: TADOQuery;
begin
  cbPrevRelease.Clear;
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text :=
      ' SELECT OBJECT_NAME(OBJECT_ID) AS TableName ' +
      ' FROM sys.objects ' +
      ' WHERE type = ''U'' and SCHEMA_NAME(schema_id) = ''dbo'' and OBJECT_NAME(OBJECT_ID) LIKE ''%CATALOG''';
    aQuery.Open;
    while not aQuery.Eof do
    begin
      if aQuery.Fields[0].AsString <> 'CATALOG' then //skip current
        cbPrevRelease.Items.Add(Copy(aQuery.Fields[0].AsString, 1, 6));
      aQuery.Next;
    end;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;


procedure TFormMain.Validate;
begin
  if (not cbLoadCatalog.Checked) and
     (not cbLoadAnalog.Checked) and
     (not cbLoadOE.Checked) then
    raise Exception.Create('Ни одно из действий не выбрано');

  if cbLoadAnalog.Checked and not FileExists(GetAppDir + 'LockedBrand.txt') then
    raise Exception.Create('Файл LockedBrand.txt не найден!');

  if cbPrevRelease.ItemIndex = -1 then
    if not MsgBoxYN('Внимание! Вы не указали предыдущую сборку.'#13#10 +
                    'В этом случае Вы не сможете получить правильное частичное обновление.'#13#10 +
                    'Хотите продолжить?') then
      Abort;

  //..
end;

procedure TFormMain.btAbortClick(Sender: TObject);
begin
  fAborted := True;
end;

procedure TFormMain.SaveINI;
var
  aIni: TIniFile;
begin
  aIni := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try
    aIni.WriteString('MAIN', 'FileCatalog', edFileCatalog.Text);
    aIni.WriteString('MAIN', 'FileAnalog', edFileAnalog.Text);
    aIni.WriteString('MAIN', 'FileOE', edFileOE.Text);
  finally
    aIni.Free;
  end;
end;

procedure TFormMain.LoadINI;
var
  aIni: TIniFile;
begin
  aIni := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));
  try
    edFileCatalog.Text := aIni.ReadString('MAIN', 'FileCatalog', edFileCatalog.Text);
    edFileAnalog.Text := aIni.ReadString('MAIN', 'FileAnalog', edFileAnalog.Text);
    edFileOE.Text := aIni.ReadString('MAIN', 'FileOE', edFileOE.Text);
  finally
    aIni.Free;
  end;
end;

procedure TFormMain.DBConnect(aTest: Boolean);
begin
  if connService.Connected then
    Exit;

  if rbConnectionLocal.Checked then
    connService.ConnectionString := 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SERVICE;Data Source=DOYNIKOV\SQLEXPRESS'
  else
    connService.ConnectionString := 'Provider=SQLOLEDB.1;Password=Admin;Persist Security Info=False;User ID=Admin;Initial Catalog=SERVICE;Data Source=AMD';
  connService.LoginPrompt := rbConnectionServer.Checked;
  connService.Connected := True;

  if not aTest then
    DoAfterConnect;
end;

procedure TFormMain.DBDisconnect;
begin
  connService.Connected := False;
  pnData.Visible := False;
end;

procedure TFormMain.DoAfterConnect;
begin
  pnData.Visible := True;
  if not IsTableExists('CATALOG') then
    CreateAllTables(False);
  FillReleases;
  UpdateStatusAll;
end;

function TFormMain.GetLastTableID(const aTableName: string): Integer;
var
  aQuery: TADOQuery;
begin
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT MAX(ID) MAXID FROM ' + aTableName;
    aQuery.Open;
    Result := aQuery.FieldByName('MAXID').AsInteger;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;

function TFormMain.GetTableRecord(const aTableName, aKey,
  aWHERE: string): string;
var
  aQuery: TADOQuery;
begin
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT ' + aKey + ' FROM ' + aTableName;
    if aWHERE <> '' then
      aQuery.SQL.Add(' WHERE ' + aWHERE);
    aQuery.Open;
    Result := aQuery.Fields[0].AsString;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;

function TFormMain.GetTableRecordCount(const aTableName: string; const aWHERE: string): Integer;
var
  aQuery: TADOQuery;
begin
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT COUNT(*) FROM ' + aTableName;
    if aWHERE <> '' then
      aQuery.SQL.Add(' WHERE ' + aWHERE);
    aQuery.Open;
    Result := aQuery.Fields[0].AsInteger;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;


function TFormMain.IsBrandLocked(const aBrand: string): Boolean;
begin
  Result := fLockedBrands.IndexOf(AnsiUpperCase(aBrand)) >= 0;
end;

function TFormMain.ExecuteSimpleSelectMS(const aSQL: string;
  aParams: array of Variant): string;
var
  i: Integer;
  aQuery: TADOQuery;
begin
  Result := '';
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := aSQL;

    for i := Low(aParams) to High(aParams) do
      aQuery.Parameters[i].Value := aParams[i];

    aQuery.Open;
    Result := aQuery.Fields[0].AsString;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;

function TFormMain.ExecuteQuery(const aSQL: string;
  aParams: array of Variant): Integer;
var
  i: Integer;
  aQuery: TADOQuery;
begin
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := aSQL;

    for i := Low(aParams) to High(aParams) do
      aQuery.Parameters[i].Value := aParams[i];

    Result := aQuery.ExecSQL;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;

procedure TFormMain.ClearTable(const aTableName: string;
  aResetGenerator: Boolean);
begin
  ExecuteQuery('DELETE FROM ' + aTableName, []);
  if aResetGenerator then
    ExecuteQuery('DBCC CHECKIDENT (' + aTableName + ', RESEED, 2000000) ', []);

//  ExecuteQuery('SET IDENTITY_INSERT ' + aTableName + ' ON ', []);
end;

function TFormMain.IsTableExists(const aTableName: string): Boolean;
begin
  Result := ExecuteSimpleSelectMS(
    ' SELECT OBJECT_NAME(OBJECT_ID) AS TableName ' +
    ' FROM sys.objects ' +
    ' WHERE type = :type and OBJECT_NAME(OBJECT_ID) = :TABLE_NAME ',
    ['U', aTableName]
  ) <> '';
end;

procedure TFormMain.RenameTable(const OldName, NewName: string);
var
  aQuery: TAdoQuery;
  aOldConstrName, aNewConstrName: string;
begin
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text :=
      ' SELECT OBJECT_NAME(OBJECT_ID) AS NameofConstraint, ' +
      ' SCHEMA_NAME(schema_id) AS SchemaName, ' +
      ' OBJECT_NAME(parent_object_id) AS TableName, ' +
      ' type_desc AS ConstraintType ' +
      ' FROM sys.objects ' +
      ' WHERE type_desc LIKE ''%CONSTRAINT'' AND OBJECT_NAME(parent_object_id) = ''' + OldName + ''' ';
    aQuery.Open;

    //переименовываем таблицу
    ExecuteQuery(
      Format(' sp_rename ''%s'', ''%s'' ', [OldName, NewName]),
      []
    );
    //переименовываем ограничения
    while not aQuery.Eof do
    begin
      aOldConstrName := aQuery.Fields[0].AsString;
      aNewConstrName := StringReplace(aOldConstrName, '_' + OldName, '_' + NewName, [rfReplaceAll]);
      ExecuteQuery(
        Format(' sp_rename ''%s'', ''%s'' ', [aOldConstrName, aNewConstrName]),
        []
      );

      aQuery.Next;
    end;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;

procedure TFormMain.btTestConnectMSClick(Sender: TObject);
begin
  DBConnect(True {aTest});
  if connService.Connected then
    ShowMessage('OK');
  DBDisconnect;
end;

procedure TFormMain.CacheBrand(aForce: Boolean);
var
  aQuery: TADOQuery;
  i, iMax: Integer;
begin
  if not memBrand.Exists then
    memBrand.CreateTable
  else
    if aForce then
      memBrand.EmptyTable
    else
      Exit;

  UpdateProgress(0, 'Кэширование брендов...');

  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT BRAND_ID, DESCRIPTION FROM BRANDS';
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.Open;

    i := 0;
    iMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT Count(BRAND_ID) FROM BRANDS', []), 0);
    memBrand.Open;
    while not aQuery.Eof do
    begin
      memBrand.Append;
      memBrand.FieldByName('BRAND_ID').AsInteger := aQuery.FieldByName('BRAND_ID').AsInteger;
      memBrand.FieldByName('DESCRIPTION').AsString := aQuery.FieldByName('DESCRIPTION').AsString;
      memBrand.Post;

      aQuery.Next;

      Inc(i);
      if i mod 1000 = 0 then
        UpdateProgress(i * 100 div iMax, 'Кэширование брендов...' + IntToStr(i));
      if fAborted then
        Break;
    end;
    memBrand.Close;

    aQuery.Close;
  finally
    UpdateProgress(0, ' ');
    aQuery.Free;
  end;
end;

procedure TFormMain.CacheGroup(aForce: Boolean);
var
  aQuery: TADOQuery;
  i, iMax: Integer;
begin
  if not memGroup.Exists then
    memGroup.CreateTable
  else
    if aForce then
      memGroup.EmptyTable
    else
      Exit;

  UpdateProgress(0, 'Кэширование групп...');

  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT GROUP_ID, GROUP_DESCR, SUBGROUP_ID, SUBGROUP_DESCR FROM GROUPS';
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.Open;

    i := 0;
    iMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT Count(GROUP_ID) FROM GROUPS', []), 0);
    memGroup.Open;
    while not aQuery.Eof do
    begin
      memGroup.Append;
      memGroup.FieldByName('GROUP_ID').AsInteger := aQuery.FieldByName('GROUP_ID').AsInteger;
      memGroup.FieldByName('GROUP_DESCR').AsString := aQuery.FieldByName('GROUP_DESCR').AsString;
      memGroup.FieldByName('SUBGROUP_ID').AsInteger := aQuery.FieldByName('SUBGROUP_ID').AsInteger;
      memGroup.FieldByName('SUBGROUP_DESCR').AsString := aQuery.FieldByName('SUBGROUP_DESCR').AsString;
      memGroup.Post;

      aQuery.Next;

      Inc(i);
      if i mod 1000 = 0 then
        UpdateProgress(i * 100 div iMax, 'Кэширование групп...' + IntToStr(i));
      if fAborted then
        Break;
    end;
    memGroup.Close;

    aQuery.Close;
  finally
    UpdateProgress(0, ' ');
    aQuery.Free;
  end;
end;

procedure TFormMain.cbLoadCatalogClick(Sender: TObject);
begin
  edFileCatalog.Visible := cbLoadCatalog.Checked;
  btOpenFileCatalog.Visible := cbLoadCatalog.Checked;
end;

procedure TFormMain.cbLoadAnalogClick(Sender: TObject);
begin
  edFileAnalog.Visible := cbLoadAnalog.Checked;
  btOpenFileAnalog.Visible := cbLoadAnalog.Checked;
end;

procedure TFormMain.cbLoadOEClick(Sender: TObject);
begin
  edFileOE.Visible := cbLoadOE.Checked;
  btOpenFileOE.Visible := cbLoadOE.Checked;
end;

procedure TFormMain.CacheCatalog(aForce: Boolean);
var
  aQuery: TADOQuery;
  i, iMax: Integer;
begin
  if not memCatalog.Exists then
    memCatalog.CreateTable
  else
    if aForce then
      memCatalog.EmptyTable
    else
      Exit;

  UpdateProgress(0, 'Кэширование каталога...');

  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT CAT_ID, CODE2, BRAND_ID FROM CATALOG WHERE CODE2 <> '''' AND CODE2 IS NOT NULL';
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.Open;

    i := 0;
    iMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT COUNT (ID) FROM CATALOG WHERE CODE2 <> '''' AND CODE2 IS NOT NULL', []), 0);
    memCatalog.Open;
    while not aQuery.Eof do
    begin
      memCatalog.Append;
      memCatalog.FieldByName('CAT_ID').AsInteger := aQuery.FieldByName('CAT_ID').AsInteger;
      memCatalog.FieldByName('CODE2').AsString := aQuery.FieldByName('CODE2').AsString;
      memCatalog.FieldByName('BRAND_ID').AsInteger := aQuery.FieldByName('BRAND_ID').AsInteger;
      memCatalog.Post;

      aQuery.Next;

      Inc(i);
      if i mod 1000 = 0 then
        UpdateProgress(i * 100 div iMax, 'Кэширование каталога...' + IntToStr(i));
      if fAborted then
        Break;
    end;
    memCatalog.Close;

    aQuery.Close;
  finally
    UpdateProgress(0, ' ');
    aQuery.Free;
  end;
end;

procedure TFormMain.CacheAnalog(aForce: Boolean);
var
  aQuery: TADOQuery;
  i, iMax: Integer;
begin
  if not memAnalog.Exists then
    memAnalog.CreateTable
  else
    if aForce then
      memAnalog.EmptyTable
    else
      Exit;

  UpdateProgress(0, 'Кэширование аналогов...');

  aQuery := TADOQuery.Create(nil);      
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT CAT_ID, AN_CODE FROM ANALOG';
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.Open;

    i := 0;
    iMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT Count(CAT_ID) FROM ANALOG', []), 0);
    memAnalog.Open;
    while not aQuery.Eof do
    begin
      memAnalog.Append;
      memAnalog.FieldByName('CAT_ID').AsInteger := aQuery.FieldByName('CAT_ID').AsInteger;
      memAnalog.FieldByName('AN_CODE').AsString := aQuery.FieldByName('AN_CODE').AsString;
      memAnalog.Post;

      aQuery.Next;

      Inc(i);
      if i mod 1000 = 0 then
        UpdateProgress(i * 100 div iMax, 'Кэширование аналогов...' + IntToStr(i));
      if fAborted then
        Break;
    end;
    memAnalog.Close;

    aQuery.Close;
  finally
    UpdateProgress(0, ' ');
    aQuery.Free;
  end;
end;

procedure TFormMain.btMoveToReleaseClick(Sender: TObject);
begin
  // todo: открыть окно с настройками
  RenameAllTables('', '110822_');
end;

procedure TFormMain.Button6Click(Sender: TObject);
var
  t: Cardinal;
begin
  Validate;

  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;
  t := GetTickCount;
  try
    if not fAborted then
      if cbLoadCatalog.Checked then
        LoadCatalog(edFileCatalog.Text);

    if not fAborted then
      if cbLoadAnalog.Checked then
        LoadAnalogs(edFileAnalog.Text);

    if not fAborted then
      if cbLoadOE.Checked then
        LoadOE(edFileOE.Text);
  finally
    (Sender as TButton).Caption := IntToStr((GetTickCount - t) div 1000);
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;

    UpdateStatusAll;
  end;
end;

procedure TFormMain.Button7Click(Sender: TObject);
begin
  CacheAnalog();
end;

procedure TFormMain.Button8Click(Sender: TObject);
begin
  CacheCatalog();
end;

procedure TFormMain.btFill_DesClick(Sender: TObject);
var
  i, iMax, p: Integer;
  aBeginFrom_DES: Integer;
begin
(*
  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;

  aBeginFrom_DES := 0;

  //TecdocConnect;
  try
    insertQuery.CommandText :=
      ' INSERT INTO TD_DES (DES_ID, TEX_TEXT) VALUES ( :DES_ID, :TEX_TEXT ) ';
    insertQuery.Prepared := True;  

    p := GetLastTableID('TD_DES');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT DES_ID FROM TD_DES WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_DES := msQuery.FieldByName('DES_ID').AsInteger;
      msQuery.Close;
    end;

    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(DISTINCT DES_ID) ' +
      ' FROM TOF_DESIGNATIONS INNER JOIN TOF_DES_TEXTS ON DES_TEX_ID=TEX_ID ' +
      ' WHERE ((DES_LNG_ID = 16) OR (DES_LNG_ID = 255)) AND DES_ID > :DES_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_DES;
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;

    UpdateProgress(0, 'Tecdoc query...');
    tdQuery.SQL.Text :=
      ' SELECT DES_ID, MAX(DISTINCT TEX_TEXT) AS TEX_TEXT ' +
      ' FROM TOF_DESIGNATIONS INNER JOIN TOF_DES_TEXTS ON DES_TEX_ID=TEX_ID ' +
      ' WHERE ((DES_LNG_ID = 16) OR (DES_LNG_ID = 255)) AND DES_ID > :DES_ID ' +
      ' GROUP BY DES_ID ' +
      ' ORDER BY DES_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_DES;
    tdQuery.Open;

    i := 0;
    UpdateProgress(0, 'Импорт [' + IntToStr(iMax) + ']... ');
    while not tdQuery.Eof do
    begin
      insertQuery.Parameters[0].Value := tdQuery.FieldByName('DES_ID').AsInteger;
      insertQuery.Parameters[1].Value := Copy(tdQuery.FieldByName('TEX_TEXT').AsString, 1, 256);
      insertQuery.Execute;

      tdQuery.Next;

      Inc(i);
      if i mod 100 = 0 then
        UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
      if fAborted then
        Break;
    end;
    tdQuery.Close;

  finally
    TecdocDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
*)  
end;

procedure TFormMain.btOpenFileCatalogClick(Sender: TObject);
begin
  OD.FileName := edFileCatalog.Text;
  if OD.Execute then
    edFileCatalog.Text := OD.FileName;
end;

procedure TFormMain.btOpenFileAnalogClick(Sender: TObject);
begin
  OD.FileName := edFileAnalog.Text;
  if OD.Execute then
    edFileAnalog.Text := OD.FileName;
end;

procedure TFormMain.btOpenFileOEClick(Sender: TObject);
begin
  OD.FileName := edFileOE.Text;
  if OD.Execute then
    edFileOE.Text := OD.FileName;
end;

procedure TFormMain.LoadCatalog(const aFileName: string);
var
  i, iMax, p: Integer;
  aReader: TCSVReader;

  aBrand, aGroup, aSubGroup, aCode, aCode2, aName, aDescr: string;
  aPrice: Double;
  sale_fl, new_fl, usa_fl, mult: Integer;
  aCatID, aBrandID, aGroupID, aSubGroupID: Integer;

  procedure AddToTable;
  var
    pict_id, typ_id, param_id, td_id: Integer;
    bExists: Boolean;
  begin
    td_id := 0;
    pict_id := 0;
    typ_id := 0;
    param_id := 0;

    memBrand.FindKey([aBrand]);
    aBrandID := memBrand.FieldByName('Brand_id').AsInteger;
    memGroup.FindKey([aGroup, aSubGroup]);
    aGroupID := memGroup.FieldByName('Group_id').AsInteger;
    aSubGroupID := memGroup.FieldByName('Subgroup_id').AsInteger;

    bExists := False;
  {  bExists := GetTableRecord(
      'CATALOG', 'ID',
      Format('UPPER(CODE2) = UPPER(''%s'') AND BRAND_ID = %d', [aCode2, aBrandID])
    ) <> '';
   }
    bExists := memCatalog.FindKey([aCode2, aBrandID]);
    if not bExists then
    begin
      Inc(aCatID);
      with insertQuery do
      begin
        Parameters[0].Value := aCatID;
        Parameters[1].Value := aBrandID;
        Parameters[2].Value := aGroupID;
        Parameters[3].Value := aSubGroupID;
        Parameters[4].Value := aCode;
        Parameters[5].Value := CreateShortCode(aCode);
        Parameters[6].Value := aCode2;
        Parameters[7].Value := Copy(aName, 1, 100);
        Parameters[8].Value := Copy(aDescr, 1, 250);
        Parameters[9].Value := aPrice;
        Parameters[10].Value := 1;
        Parameters[11].Value := 1;
        Parameters[12].Value := td_id;
        Parameters[13].Value := new_fl;
        Parameters[14].Value := sale_fl;
        Parameters[15].Value := mult;
        Parameters[16].Value := usa_fl;
        Parameters[17].Value := 0{IDouble};
        Parameters[18].Value := pict_id;
        Parameters[19].Value := typ_id;
        Parameters[20].Value := param_id;

        Execute;

        memCatalog.Append;
        memCatalog.FieldByName('CAT_ID').AsInteger := aCatID;
        memCatalog.FieldByName('CODE2').AsString := aCode2;
        memCatalog.FieldByName('BRAND_ID').AsInteger := aBrandID;
        memCatalog.Post;
      end;
    end;
  end;

  procedure ProcessDups;
  var
    aQuery: TADOQuery;
  begin
    aQuery := TADOQuery.Create(nil);
    try
    //удаляем дубли
      aQuery.Connection := msQuery.Connection;
      aQuery.SQL.Text :=
        ' SELECT Min(ID), Count(CAT_ID), BRAND_ID, CODE2 ' +
        ' FROM CATALOG ' +
        ' GROUP BY BRAND_ID, CODE2 ' +
        ' HAVING Count(CAT_ID) > 1 ';
      aQuery.Open;
      while not aQuery.Eof do
      begin
        ExecuteQuery(
          'DELETE FROM CATALOG WHERE CODE2 = :CODE2 AND BRAND_ID = :BRAND_ID AND ID <> :ID',
          [aQuery.Fields[3].AsString, aQuery.Fields[2].AsInteger, aQuery.Fields[0].AsInteger]
        );
        aQuery.Next;
      end;
      aQuery.Close;

    //помечаем дубли по Code2
      ExecuteQuery(
        ' UPDATE CATALOG SET IDOUBLE = 1 WHERE ID IN ( ' +
        '   SELECT c1.ID FROM CATALOG c1 ' +
        '   WHERE EXISTS ( select c2.ID from CATALOG c2 where c2.Code2 = c1.Code2 and c2.ID <> c1.ID ) ' +
        ' ) ', []
      );

    //помечаем дубли по ShortCode
      ExecuteQuery(
        ' UPDATE CATALOG SET IDOUBLE = 2 WHERE ID IN ( ' +
        '   SELECT c1.ID FROM CATALOG c1 ' +
        '   WHERE c1.IDOUBLE <> 1 AND EXISTS ( select c2.ID from CATALOG c2 where c2.ShortCode = c1.ShortCode and c2.ID <> c1.ID ) ' +
        ' ) ', []
      );
            
    finally
      aQuery.Free;
    end;
  end;

var
  aErrs: TStrings;
begin
  UpdateProgress(0, 'Очистка каталога...');
  ClearTable('CATALOG');
  UpdateProgress(0, 'Очистка аналогов...');
  ClearTable('ANALOG');
  UpdateProgress(0, 'Очистка OE...');
  ClearTable('OE');

  LoadGroupBrand(aFileName);

  memBrand.IndexName := 'Descr';
  memBrand.Open;
  memGroup.IndexName := 'GrDescr';
  memGroup.Open;

  CacheCatalog(True);
  memCatalog.IndexName := 'CODEBRAND';
  memCatalog.Open;

  aReader := TCSVReader.Create;
  aErrs := TStringList.Create;
  try
    if fAborted then
      Exit;

    insertQuery.CommandText :=
      ' INSERT INTO CATALOG ( Cat_id,  Brand_id,  Group_id,  Subgroup_id,  Code,  ShortCode,  Code2,  Name,  Description,  Price,  T1,  T2,  Tecdoc_id,  New,  Sale,  Mult,  Usa,  IDouble,  pict_id,  typ_tdid,  param_tdid) ' +
      '              VALUES (:Cat_id, :Brand_id, :Group_id, :Subgroup_id, :Code, :ShortCode, :Code2, :Name, :Description, :Price, :T1, :T2, :Tecdoc_id, :New, :Sale, :Mult, :Usa, :IDouble, :pict_id, :typ_tdid, :param_tdid)';
    insertQuery.Prepared := True;

    p := GetLastTableID('CATALOG');
    aCatID := 0;
    i := 0;

    UpdateProgress(0, 'Загрузка каталога...');
    aReader.Open(aFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;

      aBrand    := aReader.Fields[0];
      aGroup    := aReader.Fields[5];
      aSubGroup   := aReader.Fields[6];
      aCode  := AnsiUpperCase(aReader.Fields[1]);
      aCode2 := MakeSearchCode(aCode);
      aName   := aReader.Fields[4];
      aDescr := aReader.Fields[7];
      aPrice := StrToFloatDefUnic(aReader.Fields[2], 0);
      sale_fl := Integer(aReader.Fields[9] = '1');
      new_fl  := Integer(aReader.Fields[10] = '1');
      mult    := StrToIntDef(aReader.Fields[11], 0);
      usa_fl  := Integer(aReader.Fields[12] = '1');
      AddToTable;
      Inc(i);

      if i mod 100 = 0 then
      begin
        UpdateProgress(aReader.FilePosPercent, 'Загрузка каталога... ' + IntToStr(i));
      end;

      if fAborted then
        Break;
    end;
    aReader.Close;

    //aErrs.SaveToFile('d:\CatalogLoad.Log');
    if fAborted then
      Exit;

    UpdateProgress(100, 'Загрузка каталога... обработка дублей');
    ProcessDups;
    UpdateProgress(100, 'Загрузка каталога... добавление заголовков');    
    LoadTitles(aCatID + 1);

  finally
    memBrand.Close;
    memGroup.Close;
    aErrs.Free;
    aReader.Free;
  end;
end;

procedure TFormMain.LoadGroupBrand(const aFileName: string);
var
  i, j, iMax, iPos: integer;
  s, aGroup, aSubGroup, aBrand: string;
  sSale_fl,sNew_fl,sUSA:string;
  bSale,bNew,bUSA:boolean;
  aReader: TCSVReader;

  procedure AddToTable;
  begin
    if not memBrand.FindKey([aBrand]) then
    begin
      memBrand.Append;
      memBrand.FieldByName('Description').Value := aBrand;
      memBrand.Post;
    end;

    if not memGroup.FindKey([aGroup, aSubGroup]) then
    begin
      memGroup.Append;
      memGroup.FieldByName('Group_descr').Value    := aGroup;
      memGroup.FieldByName('Subgroup_descr').Value := aSubGroup;
      memGroup.Post;
    end;
  end;

begin
  ClearTable('BRANDS');
  CacheBrand(True);
  memBrand.Open;
  memBrand.IndexName := 'Descr';

  ClearTable('GROUPS');
  CacheGroup(True);
  memGroup.Open;
  memGroup.IndexName := 'GrDescr';

  Brand.Open;
  Group.Open;
  i := 0;
  aReader := TCSVReader.Create;
  try
    UpdateProgress(0, 'Загрузка классификатора...');
    aReader.Open(aFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;

      aBrand    := aReader.Fields[0];
      aGroup    := aReader.Fields[5];
      aSubGroup := aReader.Fields[6];
      AddToTable;
      inc(i);
      if i mod 1000 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Загрузка классификатора...' + IntToStr(i));
      if fAborted then
        Break;
    end;
    aReader.Close;

    UpdateProgress(0, 'Перенумерация классификатора...');

    memBrand.IndexName := 'Descr';
    memBrand.First;
    i := 1;
    iMax := memBrand.RecordCount;
    while not memBrand.Eof do
    begin
      memBrand.Edit;
      memBrand.FieldByName('Brand_id').Value := i;
      memBrand.Post;

      Brand.Append;
      Brand.FieldByName('Brand_id').Value := i;
      Brand.FieldByName('Description').Value := memBrand.FieldByName('Description').Value;
      Brand.Post;

      memBrand.Next;

      Inc(i);
      if i mod 10 = 0 then
        UpdateProgress(i * 100 div iMax, 'Перенумерация классификатора [брэнды]...');
      if fAborted then
        Exit;
    end;


    memGroup.IndexName := 'GrDescr';
    memGroup.First;
    i := 1;
    iPos := 0;
    iMax := memGroup.RecordCount;
    while not memGroup.Eof do
    begin
      aGroup := memGroup.FieldByName('Group_descr').AsString;
      j := 1;
      while (not memGroup.Eof) and (memGroup.FieldByName('Group_descr').AsString = aGroup) do
      begin
        memGroup.Edit;
        memGroup.FieldByName('Group_id').Value := i;
        memGroup.FieldByname('Subgroup_id').Value := j;
        memGroup.Post;

        Group.Append;
        Group.FieldByName('Group_id').Value := i;
        Group.FieldByname('Subgroup_id').Value := j;
        Group.FieldByName('Group_descr').Value := memGroup.FieldByName('Group_descr').Value;
        Group.FieldByname('Subgroup_descr').Value := memGroup.FieldByname('Subgroup_descr').Value;
        Group.Post;
        
        memGroup.Next;
        Inc(j);
        Inc(iPos);

        if iPos mod 10 = 0 then
          UpdateProgress(iPos * 100 div iMax, 'Перенумерация классификатора [группы]...');
        if fAborted then
          Exit;
      end;
      Inc(i);
    end;

  finally
    aReader.Free;
    Brand.Close;
    Group.Close;
  end;
end;

function TFormMain.LoadLockedBrands: Boolean;
var
  i: Integer;
begin
  Result := False;
  fLockedBrands.Clear;
  if FileExists(GetAppDir + 'LockedBrand.txt') then
  begin
    fLockedBrands.LoadFromFile(GetAppDir + 'LockedBrand.txt');
    for i := 0 to fLockedBrands.Count - 1 do
      fLockedBrands[i] := AnsiUpperCase(fLockedBrands[i]);
    Result := True;
  end;
end;

procedure TFormMain.LoadTitles(aCatID: integer);
var
  i, gr, sgr, br: integer;
begin
  i := aCatID;

  ClearTable('GROUPBRAND');
  ExecuteQuery(
    ' insert into groupbrand (Group_id, Subgroup_id, Brand_id) ' +
    ' select distinct Group_id, Subgroup_id, Brand_id from catalog ',
    []
  );

  memBrand.IndexName := 'Brand_Id';
  memBrand.Open;

  memGroup.IndexName := 'GrId';
  memGroup.Open;

  //IndexName := 'GrBrand';
  GroupBrand.Close;
  GroupBrand.CommandText := 'SELECT * FROM GROUPBRAND ORDER BY GROUP_ID, SUBGROUP_ID, BRAND_ID';
  GroupBrand.Open;

  with memGroup do
  begin
    First;
    while not Eof do
    begin
      gr := FieldByName('Group_id').AsInteger;

      ExecuteQuery(
        ' INSERT INTO CATALOG ( CAT_ID,  GROUP_ID,  Subgroup_id,  Brand_id,  Description,  T1,  T2,  Title) ' +
        '              VALUES (:CAT_ID, :GROUP_ID, :Subgroup_id, :Brand_id, :Description, :T1, :T2, :Title)',
        [i, gr, 0, 0, memGroup.FieldByName('Group_descr').AsString, 1, 0, 1]
      );
      Inc(i);

      while (not Eof) and (FieldByName('Group_id').AsInteger = gr) do
      begin
        sgr := FieldByName('Subgroup_id').AsInteger;
        ExecuteQuery(
          ' INSERT INTO CATALOG ( CAT_ID,  GROUP_ID,  Subgroup_id,  Brand_id,  Description,  T1,  T2,  Title) ' +
          '              VALUES (:CAT_ID, :GROUP_ID, :Subgroup_id, :Brand_id, :Description, :T1, :T2, :Title)',
          [i, gr, sgr, 0, memGroup.FieldByName('Subgroup_descr').AsString, 1, 0, 1]
        );
        Inc(i);

        with GroupBrand do
        begin
          Filter := Format('group_id = %d and subgroup_id = %d', [gr, sgr]);
          Filtered := True;
          First;
          while not Eof do
          begin
            br := GroupBrand.FieldByName('Brand_id').AsInteger;
            memBrand.Locate('Brand_id', br, []);
            ExecuteQuery(
              ' INSERT INTO CATALOG ( CAT_ID,  GROUP_ID,  Subgroup_id,  Brand_id,  Description,  T1,  T2,  Title) ' +
              '              VALUES (:CAT_ID, :GROUP_ID, :Subgroup_id, :Brand_id, :Description, :T1, :T2, :Title)',
              [i, gr, sgr, br, memBrand.FieldByName('Description').AsString, 1, 0, 1]
            );
            Inc(i);

            Next;
          end;
          Filtered := False;
        end;
        
        Next;
      end;
    end;
  end;

  //IndexName := 'BrGroup';
  GroupBrand.Close;
  GroupBrand.CommandText := 'SELECT * FROM GROUPBRAND ORDER BY BRAND_ID, GROUP_ID, SUBGROUP_ID';
  GroupBrand.Open;
  with memBrand do
  begin
    First;
    while not Eof do
    begin
      br := FieldByName('Brand_id').AsInteger;

      ExecuteQuery(
        ' INSERT INTO CATALOG ( CAT_ID,  GROUP_ID,  Subgroup_id,  Brand_id,  Description,  T1,  T2,  Title) ' +
        '              VALUES (:CAT_ID, :GROUP_ID, :Subgroup_id, :Brand_id, :Description, :T1, :T2, :Title)',
        [i, 0, 0, br, memBrand.FieldByname('Description').AsString, 0, 1, 1]
      );
      Inc(i);

      with GroupBrand do
      begin
        Filter := Format('brand_id = %d', [br]);
        Filtered := True;
        First;
        while not Eof do
        begin
          gr  := FieldByName('Group_id').AsInteger;
          while (not Eof) and (FieldByName('Group_id').AsInteger = gr) do
          begin
            sgr := FieldByName('Subgroup_id').AsInteger;
            memGroup.FindKey([gr, sgr]);
            ExecuteQuery(
              ' INSERT INTO CATALOG ( CAT_ID,  GROUP_ID,  Subgroup_id,  Brand_id,  Description,  T1,  T2,  Title) ' +
              '              VALUES (:CAT_ID, :GROUP_ID, :Subgroup_id, :Brand_id, :Description, :T1, :T2, :Title)',
              [i, br, gr, sgr, memGroup.FieldByName('Subgroup_descr').AsString, 0, 1, 1]
            );
            Inc(i);

            Next;
          end;
        end;
        Filtered := False;
      end;

      Next;
    end;
  end;
end;

procedure TFormMain.RenameAllTables(const aOldPrefix, aNewPrefix: string);
begin
  RenameTable(aOldPrefix + 'CATALOG',    aNewPrefix + 'CATALOG');
  RenameTable(aOldPrefix + 'ANALOG',     aNewPrefix + 'ANALOG');
  RenameTable(aOldPrefix + 'OE',         aNewPrefix + 'OE');
  RenameTable(aOldPrefix + 'GROUPS',     aNewPrefix + 'GROUPS');
  RenameTable(aOldPrefix + 'BRANDS',     aNewPrefix + 'BRANDS');
  RenameTable(aOldPrefix + 'GROUPBRAND', aNewPrefix + 'GROUPBRAND');
end;

procedure TFormMain.CreateAllTables(aForce: Boolean; const aPrefix: string);
var
  i: Integer;
  aSQL: TStrings;
  aSQLPart: string;
begin
  aSQL := TStringList.Create;
  try
    aSQL.Text := MemoCreateTemplate.Text;
    aSQL.Text := StringReplace(aSQL.Text, '#CATALOG#', aPrefix + 'CATALOG', [rfReplaceAll]);
    aSQL.Text := StringReplace(aSQL.Text, '#ANALOG#', aPrefix + 'ANALOG', [rfReplaceAll]);
    aSQL.Text := StringReplace(aSQL.Text, '#OE#', aPrefix + 'OE', [rfReplaceAll]);
    aSQL.Text := StringReplace(aSQL.Text, '#GROUPS#', aPrefix + 'GROUPS', [rfReplaceAll]);
    aSQL.Text := StringReplace(aSQL.Text, '#BRANDS#', aPrefix + 'BRANDS', [rfReplaceAll]);
    aSQL.Text := StringReplace(aSQL.Text, '#GROUPBRAND#', aPrefix + 'GROUPBRAND', [rfReplaceAll]);

    aSQLPart := '';
    for i := 0 to aSQL.Count - 1 do
    begin
      if (aSQL[i] = 'GO') then
      begin
        insertQuery.CommandText := aSQLPart;
        insertQuery.Execute;
        aSQLPart := '';
      end
      else
        aSQLPart := aSQLPart + #13#10 + aSQL[i]
    end;

    if aSQLPart <> '' then
    begin
      insertQuery.CommandText := aSQLPart;
      insertQuery.Execute;
    end;

  finally
    aSQL.Free;
  end;
end;


procedure TFormMain.LoadAnalogs(const aFileName: string);
var
  i: integer;
  cat_br_str, an_br_str, cat_code, an_code: string;
  cat_br_id, an_br_id, cat_id, an_id: integer;
  sID, anInsBrand: string;
  anInsLocked: Integer;

  Prev_cat_br_id: Integer;
  Prev_cat_br_str: string;

  procedure AddToTable;
  begin
    if cat_br_str = Prev_cat_br_str then
      cat_br_id := Prev_cat_br_id
    else
    begin
      if memBrand.Locate('DESCRIPTION', cat_br_str, []) then
        cat_br_id := memBrand.FieldByName('Brand_id').AsInteger
      else
      begin
        //* WLog('Бренд не распознан <' + Cat_br_str + '> в строке ' + IntToStr(i));
        cat_br_id := 0;
      end;
      Prev_cat_br_str := cat_br_str;
      Prev_cat_br_id := cat_br_id;
    end;

    if memBrand.Locate('DESCRIPTION', An_br_str, []) then
      an_br_id := memBrand.FieldByName('Brand_id').AsInteger
    else
    begin
      //WLog('Бренд не распознан <' + Cat_br_str + '> в строке ' + IntToStr(i));
      an_br_id := 0;
    end;

    //with LoadCatTable do
    begin

{      sID := GetTableRecord(
        'CATALOG', 'CAT_ID',
        Format('CODE2 = ''%s'' AND BRAND_ID = %d', [MakeSearchCode(cat_code), cat_br_id])
      );
}
      if memCatalog.FindKey([MakeSearchCode(cat_code), cat_br_id]) then
        cat_id := memCatalog.FieldByName('CAT_ID').AsInteger
//      if sID <> '' then
//        cat_id := StrToIntDef(sID, 0)
      else
      begin
        //WLog('Базовая позиция не идентифицирована <' +
        //      Cat_code + ' / ' + Cat_br_str + '> в строке ' + IntToStr(i));
        cat_id := 0;
      end;
{
      sID := GetTableRecord(
        'CATALOG', 'CAT_ID',
        Format('CODE2 = ''%s'' AND BRAND_ID = %d', [MakeSearchCode(an_code), an_br_id])
      );
}
      if memCatalog.FindKey([MakeSearchCode(an_code), an_br_id]) then
        an_id := memCatalog.FieldByName('CAT_ID').AsInteger
//      if sID <> '' then
//        an_id := StrToIntDef(sID, 0)
      else
      begin
        //WLog('Позиция аналога не идентифицирована <' +
        //      Cat_code + ' / ' + Cat_br_str + '> в строке ' + IntToStr(i));
        an_id := 0;
      end;
    end;
    
    //with LoadAnTable do
    begin
      if cat_id = 0 then
      begin
        if (an_id <> 0) then
        begin
{
          sID := GetTableRecord(
            'ANALOG', 'CAT_ID',
            Format(' CAT_ID = %d AND AN_CODE = ''%s'' ', [an_id, cat_code])
          );
}
//          if sID = '' then
          if not memAnalog.FindKey([an_id, cat_code]) then
          begin
            if IsBrandLocked(Cat_br_str) then
            begin
              anInsBrand := '';
              anInsLocked := 1;
            end
            else
            begin
              anInsBrand := cat_br_str;
              anInsLocked := 0;
            end;

            insertQuery.Parameters[0].Value := an_id;
            insertQuery.Parameters[1].Value := cat_code;
            insertQuery.Parameters[2].Value := CreateShortCode(cat_code);
            insertQuery.Parameters[3].Value := 0;
            insertQuery.Parameters[4].Value := anInsBrand;
            insertQuery.Parameters[5].Value := anInsLocked;
            insertQuery.Execute;

            memAnalog.Append;
            memAnalog.FieldByName('CAT_ID').AsInteger := an_id;
            memAnalog.FieldByName('AN_CODE').AsString := cat_code;
            memAnalog.Post;
          end
          else
          begin
            //WLog('Повтор позиции <' +
            //    Cat_code + ' / ' + Cat_br_str + '> в строке ' + IntToStr(i));
          end;
        end;
      end
      else
      begin
{
        sID := GetTableRecord(
          'ANALOG', 'CAT_ID',
          Format(' CAT_ID = %d AND AN_CODE = ''%s'' ', [cat_id, an_code])
        );
}

//        if sID = '' then
        if not memAnalog.FindKey([cat_id, an_code]) then
        begin
          if IsBrandLocked(Cat_br_str) then
          begin
            anInsBrand := '';
            anInsLocked := 1;
          end
          else
          begin
            anInsBrand := an_br_str;
            anInsLocked := 0;
          end;

          insertQuery.Parameters[0].Value := cat_id;
          insertQuery.Parameters[1].Value := an_code;
          insertQuery.Parameters[2].Value := CreateShortCode(an_code);
          insertQuery.Parameters[3].Value := an_id;
          insertQuery.Parameters[4].Value := anInsBrand;
          insertQuery.Parameters[5].Value := anInsLocked;
          insertQuery.Execute;

          memAnalog.Append;
          memAnalog.FieldByName('CAT_ID').AsInteger := cat_id;
          memAnalog.FieldByName('AN_CODE').AsString := an_code;
          memAnalog.Post;

        end
        else
        begin
          //WLog('Повтор аналога <' +
            //    An_code + ' / ' + An_br_str + '> в строке ' + IntToStr(i));
        end;

      end;
    end;
  end;

var
  aReader: TCSVReader;
begin
  UpdateProgress(0, 'Загрузка аналогов...');

  if not LoadLockedBrands then
    raise Exception.Create('Файл LockedBrand.txt не найден!');

  insertQuery.CommandText :=
    'INSERT INTO ANALOG ( CAT_ID,  AN_CODE,  AN_SHORTCODE,  AN_ID,  AN_BRAND,  LOCKED) ' +
    '            VALUES (:CAT_ID, :AN_CODE, :AN_SHORTCODE, :AN_ID, :AN_BRAND, :LOCKED)';
  insertQuery.Prepared := True;

  ClearTable('ANALOG');
  CacheAnalog(True);
  memAnalog.IndexName := 'IDCODE';
  memAnalog.Open;

  CacheCatalog;
  memCatalog.IndexName := 'CODEBRAND';
  memCatalog.Open;

  CacheBrand;
  memBrand.Open;

  aReader := TCSVReader.Create;
  try
    i := 0;
    aReader.Open(aFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;

      cat_br_str := aReader.Fields[0];
      cat_code   := aReader.Fields[1];
      an_br_str  := aReader.Fields[2];
      an_code    := aReader.Fields[3];
      AddToTable;
      Inc(i);

      if i mod 1000 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Загрузка аналогов... ' + IntToStr(i));
      if fAborted then
        Break;
    end;
  finally
    aReader.Free;
    Brand.Close;

    memCatalog.Close;
    memAnalog.Close;
  end;
end;

procedure TFormMain.LoadOE(const aFileName: string);
var
  i, brand_id: integer;
  cb, cat_code, cat_brand, oe_code, short_oe_code: string;


  procedure AddToTable;
  begin
    if memBrand.Locate('DESCRIPTION', Cat_brand, []) then
      brand_id := memBrand.FieldByName('Brand_id').AsInteger
    else
    begin
      //WLog('Бренд не распознан <' + Cat_brand + '> в строке ' + IntToStr(i));
      brand_id := 0;
    end;

    if (cat_code <> '') and memCatalog.FindKey([cat_code, brand_id]) then
    begin
      insertQuery.Parameters[0].Value := memCatalog.FieldByName('Cat_id').AsInteger;
      insertQuery.Parameters[1].Value := AnsiUpperCase(oe_code);
      insertQuery.Parameters[2].Value := MakesearchCode(oe_code);
      insertQuery.Parameters[3].Value := short_oe_code;
      insertQuery.Execute;
    end
    else
    begin
      //WLog('Поз. не найдена <' + Cat_code + ' / ' + Cat_brand + '> в строке ' + IntToStr(i));
    end;
  end;

var
  aReader: TCSVReader;
begin
  UpdateProgress(0, 'Загрузка OE...');

  insertQuery.CommandText :=
    ' INSERT INTO OE ( CAT_ID,  CODE,  CODE2,  SHORTOE) ' +
    '         VALUES (:CAT_ID, :CODE, :CODE2, :SHORTOE) ';
  insertQuery.Prepared := True;

  ClearTable('OE');
  CacheCatalog;
  memCatalog.IndexName := 'CODEBRAND';
  memCatalog.Open;

  CacheBrand;
  memBrand.Open;

  aReader := TCSVReader.Create;
  try
    i := 0;
    aReader.Open(aFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      cb := aReader.Fields[0];
      DecodeCodeBrand(cb, cat_code, cat_brand);
      oe_code   := aReader.Fields[1];
      short_oe_code := CreateShortCode(oe_code);
      if short_oe_code <> '' then
        AddToTable;

      Inc(i);

      if i mod 1000 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Загрузка ОЕ... ' + IntToStr(i));
      if fAborted then
        Break;
    end;

  finally
    aReader.Free;
    memBrand.Close;
    memCatalog.Close;
  end;
end;



end.
{
сброс счетчика автоинкремента
  DBCC CHECKIDENT (<table name>, RESEED, <new value>)
}

{
включение возможности инсертить в автоинкрементное поле
  SET IDENTITY_INSERT <table name> ON
}

{
получить список таблиц
  SELECT OBJECT_NAME(OBJECT_ID) AS TableName
  FROM sys.objects
  WHERE type = 'U' and SCHEMA_NAME(schema_id) = 'dbo'
}
