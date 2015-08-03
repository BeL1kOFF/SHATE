unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ADODB, DB, ComCtrls, JvBaseDlg, JvSelectDirectory,
  adoDBUtils, dbisamtb, ActnList, GridsEh, DBGridEh, ExtCtrls, GIFImg;

const
  cLocalConnectionString = 'Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=TECDOC2015;Data Source=svbyminsd10;';
  cWindowsAutorityParams = 'Integrated Security=SSPI;';
  cCustomAutorityParams = 'User ID=%s;Password=%s;';

type
  TFormMain = class(TForm)
    adoOLEDB: TADOConnection;
    insertQuery: TADOCommand;
    btImport_ARTTYP: TButton;
    msQuery: TADOQuery;
    btFill_PictCodes: TButton;
    btFill_PictData: TButton;
    tdConnection: TADOConnection;
    tdQuery: TADOQuery;
    btFill_Arts: TButton;
    btFill_Typ: TButton;
    Label1: TLabel;
    Label2: TLabel;
    rbConnectionLocal: TRadioButton;
    rbConnectionServer: TRadioButton;
    Button1: TButton;
    Button2: TButton;
    btFill_Des: TButton;
    btFill_Cds: TButton;
    btFill_Models: TButton;
    btFill_Manufacturers: TButton;
    btFill_Params: TButton;
    btFill_ParamsByTypes: TButton;
    btImport_ARTTYP2: TButton;
    btFill_ParamNames: TButton;
    btFill_ParamsByTypes2: TButton;
    btAddPictDir: TButton;
    btAddArt: TButton;
    SelectDirectory: TJvSelectDirectory;
    OpenDialog: TOpenDialog;
    btFill_PictHash: TButton;
    btAddAllFromService: TButton;
    DBISAMEngine: TDBISAMEngine;
    DBIQuery: TDBISAMQuery;
    DBISAMDB: TDBISAMDatabase;
    Button3: TButton;
    memART: TDBISAMTable;
    memARTART_ID: TIntegerField;
    memARTART_LOOK: TStringField;
    memARTSUP_BRAND: TStringField;
    memARTPARAM_ID: TIntegerField;
    memARTTYP_ID: TIntegerField;
    memARTCUR_PICT: TIntegerField;
    memARTID: TIntegerField;
    Button4: TButton;
    btLoadHidedManufacturers: TButton;
    Button5: TButton;
    rbConnectionServerNew: TRadioButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Memo1: TMemo;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    btPicturesFix: TButton;
    btFill_KITs_IDs: TButton;
    Button13: TButton;
    btFill_KITs: TButton;
    Button14: TButton;
    Button15: TButton;
    Memo2: TMemo;
    Button16: TButton;
    Button17: TButton;
    AnalogIDTable: TDBISAMTable;
    AnalogIDTableGen_An_id: TIntegerField;
    AnalogIDTableCat_id: TIntegerField;
    AnalogMainTable: TDBISAMTable;
    AnalogMainTableGen_An_id: TIntegerField;
    AnalogMainTableAn_code: TStringField;
    AnalogMainTableAn_brand: TStringField;
    AnalogMainTableAn_id: TIntegerField;
    AnalogMainTableDescription: TStringField;
    AnalogMainTablePrice: TCurrencyField;
    AnalogMainTablePrice_koef: TCurrencyField;
    AnalogMainTableAn_group_id: TIntegerField;
    AnalogMainTableAn_subgroup_id: TIntegerField;
    AnalogMainTableQuantity: TStringField;
    AnalogMainTableAn_sale: TStringField;
    AnalogMainTableAn_new: TStringField;
    AnalogMainTableAn_usa: TStringField;
    AnalogMainTableSale: TStringField;
    AnalogMainTableNew: TStringField;
    AnalogMainTableName: TStringField;
    AnalogMainTableName_Descr: TStringField;
    AnalogMainTableAn_Brand_id: TIntegerField;
    AnalogMainTableMult: TIntegerField;
    AnalogMainTablePrice_koef_eur: TCurrencyField;
    AnalogMainTableOrdQuantity: TFloatField;
    AnalogMainTableOrdQuantityStr: TStringField;
    AnalogMainTablePrice_pro: TCurrencyField;
    AnalogMainTableUsa: TStringField;
    AnalogMainTablesaleQCalc: TStringField;
    AnalogMainTableSaleQ: TStringField;
    AnalogMainTablePriceItog: TCurrencyField;
    AnalogMainTablePriceQuant: TCurrencyField;
    AnalogMainTableLocked: TIntegerField;
    AnalogMainTableAn_ShortCode: TStringField;
    AnalogMainTableAn_brand_repl: TStringField;
    AnalogMainTableQuantLatest: TIntegerField;
    AnalogMainTableOrderOnly: TBooleanField;
    Panel1: TPanel;
    edUser: TEdit;
    edPassword: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    btAddPictList: TButton;
    btAddParams: TButton;
    btAddDescriptions: TButton;
    btAddPrimen: TButton;
    btAbort: TButton;
    cbWindowsAutority: TCheckBox;
    pb: TProgressBar;
    Panel3: TPanel;
    btPatrialFillDataInTecdoc: TButton;
    ChBoxPicts: TCheckBox;
    ChBoxPrimen: TCheckBox;
    ChBoxDescr: TCheckBox;
    MemLog: TMemo;
    Label5: TLabel;
    Button18: TButton;
    lbProgressInfo: TLabel;
    Button19: TButton;
    procedure btImport_ARTTYPClick(Sender: TObject);
    procedure btAbortClick(Sender: TObject);
    procedure btFill_PictCodesClick(Sender: TObject);
    procedure btFill_PictDataClick(Sender: TObject);
    procedure btFill_ArtsClick(Sender: TObject);
    procedure btFill_TypClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btFill_DesClick(Sender: TObject);
    procedure btFill_CdsClick(Sender: TObject);
    procedure btFill_ModelsClick(Sender: TObject);
    procedure btFill_ManufacturersClick(Sender: TObject);
    procedure btFill_ParamsClick(Sender: TObject);
    procedure btFill_ParamsByTypesClick(Sender: TObject);
    procedure btImport_ARTTYP2Click(Sender: TObject);
    procedure btFill_ParamNamesClick(Sender: TObject);
    procedure btFill_ParamsByTypes2Click(Sender: TObject);
    procedure btAddPictListClick(Sender: TObject);
    procedure btAddPictDirClick(Sender: TObject);
    procedure btAddParamsClick(Sender: TObject);
    procedure btAddDescriptionsClick(Sender: TObject);
    procedure btAddArtClick(Sender: TObject);
    procedure btAddPrimenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btFill_PictHashClick(Sender: TObject);
    procedure btAddAllFromServiceClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btLoadHidedManufacturersClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure btPicturesFixClick(Sender: TObject);
    procedure btFill_KITs_IDsClick(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure btFill_KITsClick(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure cbWindowsAutorityClick(Sender: TObject);
    procedure btPatrialFillDataInTecdocClick(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
  private
    fAborted: Boolean;
    fReplBrands: TStrings;
    fCurrentConnectionString: string;

    procedure DBConnect;
    procedure DBDisconnect;

    procedure TecdocConnect;
    procedure TecdocDisconnect;

    function GetLastTableID(const aTableName: string): Integer;
    function ExecuteSimpleSelectMS(const aSQL: string; aParams: array of Variant): string;
    function ExecuteSimpleSelectTD(const aSQL: string; aParams: array of Variant): string;
    procedure ExecQueryMS(const aSQL: string; aParams: array of Variant);


    //дозаливки из файлов
 {*}procedure LoadAddPicturesBath;
 {*}function LoadAddPictures(aDir: string = ''; aSilent: Boolean = False): Integer;
 {*}procedure LoadAddPictures2Bath;
 {*}function LoadAddPictures2(aFile: string = ''; aSilent: Boolean = False): Integer;
 {*}function  LoadAddPictureFromFile(const aPictureFileName, aCode, aBrand: string): Boolean;

 {*}procedure LoadAddTDArt(fname: string = ''; aRecognizeTecdoc: Boolean = False; fPatrialFill: Boolean = False);
    procedure LoadAddTDArt2(fname: string = ''; aRecognizeTecdoc: Boolean = False; fPatrialFill: Boolean = False);

    procedure LoadAddTDParamBath;
 {*}function LoadAddTDParam(fname: string=''; aSilent: Boolean = False): Integer;

 {*}procedure LoadAddTDPrimenBath;
 {*}function LoadAddTDPrimen(fname: string=''; aSilent: Boolean = False): Integer;

    procedure LoadDescriptionBath;
    function LoadDescription(sFileName: string = ''; aSilent: Boolean = False): Integer;

    //supports functs
    function LoadReplBrands: Boolean;
    function GetReplBrand(const aBrand: string): string;
    function DecodeCodeBrand(const aCode_Brand: string; var aCode, aBrand: string; aMakeSearchCode: Boolean = True): Boolean;
    function GetNewTecdocID: Integer;
    function GetNewPictID: Integer;


    function NewTD_GetArtMap(anArtIdOld: Integer): Integer;
    function NewTD_GetTypMap(aTypIdOld: Integer): Integer;

    procedure NewTD_LoadArt_New(const aFileName: string);
    procedure NewTD_LoadArt_Mod(const aFileName: string);
    procedure NewTD_LoadArt_NewMod(const aFileName: string);
    procedure NewTD_LoadArt_NewMod2(const aFileName: string);

    procedure NewTD_LoadArtPicts_New(const aFileName: string);
    procedure NewTD_LoadDetails_New(const aFileName: string);
    procedure NewTD_LoadArtTyp_New(const aFileName: string);
  public
    procedure UpdateProgress(aPos: Integer; const aCaption: string = '');
    function GetAppDir: string;
    function makeQueryMS(const aSQL: string = ''): IQuery;

    procedure CacheARTEx(const aPrefix: string; aTable: TDBISamTable; aForce: Boolean);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  _BatchSelectorForm, _CSVReader, MD5, uSysGlobal;

{ TFormMain }

function TFormMain.makeQueryMS(const aSQL: string): IQuery;
begin
  Result := makeIQuery(adoOLEDB, aSQL, clUseClient);
end;


//******************************************************************************
(*

AT+CMGF=1 // перевод в текстовый режим
>OK
AT+CMGS=+7xxxxxxxxxx // здесь номер телефона
>
message   // надо дождаться приглашения '>' и после писать сообщение. Конец сообщения символ $1B вроде.
OK //после будет ещё какой-то код :)
*)

function TFormMain.GetAppDir: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

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

procedure TFormMain.UpdateProgress(aPos: Integer; const aCaption: string);
begin
  pb.Position := aPos;
  if aCaption <> '' then
    lbProgressInfo.Caption := aCaption;
  Application.ProcessMessages;
end;


procedure TFormMain.btAbortClick(Sender: TObject);
begin
  fAborted := True;
end;

procedure TFormMain.DBConnect;
begin
 // if rbConnectionLocal.Checked then
    fCurrentConnectionString := cLocalConnectionString;
 // else
 //   fCurrentConnectionString := cAMDConnectionString;

  if cbWindowsAutority.Checked then
    fCurrentConnectionString := fCurrentConnectionString + cWindowsAutorityParams
  else
    fCurrentConnectionString := fCurrentConnectionString + Format(cCustomAutorityParams, [edUser.Text, edPassword.Text]);

  adoOLEDB.ConnectionString := fCurrentConnectionString;
  adoOLEDB.LoginPrompt :=False;
  adoOLEDB.Connected := True;
end;

procedure TFormMain.DBDisconnect;
begin
//  adoNative.Connected := False;
  adoOLEDB.Connected := False;
end;

procedure TFormMain.TecdocConnect;
begin
  tdConnection.Connected := True;
end;

procedure TFormMain.TecdocDisconnect;
begin
  tdConnection.Connected := False;
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


procedure TFormMain.ExecQueryMS(const aSQL: string;
  aParams: array of Variant);
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

    aQuery.ExecSQL;
  finally
    aQuery.Free;
  end;
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
    if not aQuery.Eof then
      Result := aQuery.Fields[0].AsWideString;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
end;

function TFormMain.ExecuteSimpleSelectTD(const aSQL: string;
  aParams: array of Variant): string;
var
  i: Integer;
  aQuery: TADOQuery;
begin
  Result := '';
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := tdQuery.Connection;
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

procedure TFormMain.FormCreate(Sender: TObject);
var
  s: string;
begin
  fReplBrands := TStringList.Create;
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  fReplBrands.Free;
end;


procedure TFormMain.Button1Click(Sender: TObject);
begin
  DBConnect;
  if adoOLEDB.Connected then
    ShowMessage('OK');
  DBDisconnect;
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  tecdocConnect;
  if tdConnection.Connected then
    ShowMessage('OK');
  tecdocDisconnect;
end;


procedure TFormMain.Button3Click(Sender: TObject);
var
  i, iMax: Integer;
  prevArt: Integer;
  aConnection: TAdoConnection;
begin
  DBConnect;

  aConnection := TADOConnection.Create(nil);
  try
    aConnection.Provider :=  adoOLEDB.Provider;
    aConnection.LoginPrompt := adoOLEDB.LoginPrompt;
    aConnection.CursorLocation := adoOLEDB.CursorLocation;
    aConnection.ConnectionString := fCurrentConnectionString;
    aConnection.Connected := True;

    insertQuery.Connection := aConnection;
    insertQuery.CommandText := 'UPDATE ART SET CUR_PICT = :CUR_PICT WHERE PICT_ID = :PICT_ID';
    insertQuery.Prepared := True;

    UpdateProgress(0, 'Query count...');
//    msQuery.SQL.Text := ' select count(ART_ID) from art_picts ';
//    msQuery.Open;
    iMax := 16410;//msQuery.Fields[0].AsInteger;
    msQuery.Close;

    UpdateProgress(0, 'Update ART...');
    msQuery.SQL.Text :=
      ' select ap.ART_ID, ap.SORT, ap.PICT_ID from art_picts ap ' +
      ' left join art a on (a.ART_ID = ap.ART_ID) ' +
      ' where a.cur_pict = 0 ' +
      ' order by ART_ID, SORT ';
    msQuery.Open;

    i := 0;
    prevArt := -1;
    while not msQuery.Eof do
    begin
      if prevArt <> msQuery.Fields[0].AsInteger then
      begin
        prevArt := msQuery.Fields[0].AsInteger;
        insertQuery.Parameters[0].Value := msQuery.Fields[2].AsInteger;
        insertQuery.Parameters[1].Value := msQuery.Fields[0].AsInteger;
        insertQuery.Execute;
      end;
      msQuery.Next;

      Inc(i);
      if i mod 500 = 0 then
       UpdateProgress(i * 100 div iMax, 'Update ART [' + IntToStr(iMax) + ']... ' + IntToStr(i));
      if fAborted then
        Break;
    end;

  finally
    aConnection.Close;
    aConnection.Free;
    DBDisconnect;
    insertQuery.Connection := adoOLEDB;
    UpdateProgress(0, 'finish');
  end;
end;

procedure TFormMain.Button4Click(Sender: TObject);
var
s:tstrings;
aQuery: tadoquery;
b,e: cardinal;
aFileName, sLockedBrands, sMaxGenAnId, line, ShortOE: string;
aReader: TCSVReader;
str: TStringList;
i:integer;
//aQuery: TADOQuery;

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


begin
i:=4296455;
{  msQuery.SQL.Text := ' SELECT [ART_ID] ' +
      ' ,[ART_LOOK] ' +
      ' ,[SUP_BRAND] ' +
      ' ,[ART_ID] as PARAM_ID ' +
      ' ,[ART_ID] as TYP_ID '+
      ' ,[ART_ID] as PICT_ID '+
      ' ,0 as CUR_PICT '+
      ' ,0 as UPDATED '+
  ' FROM [TD_ART] where sup_brand = :brand ';

  msQuery.Prepared := TRUE;
  msQuery.Parameters[0].Value := 'LEMFORDER';
  msQuery.Open;
  UpdateProgress(0, 'Do querty...');            }
  if not OpenDialog.Execute then
   Exit;

  DBConnect;
//  TecdocConnect;
  UpdateProgress(0, 'connect...');
  try

    insertQuery.CommandText :=
      ' INSERT INTO ART ( ART_ID,  ART_LOOK,  SUP_BRAND, PARAM_ID, TYP_ID, PICT_ID, ID, CUR_PICT, UPDATED) ' +
      '          VALUES (:ART_ID, :ART_LOOK, :SUP_BRAND,:PARAM_ID,:TYP_ID,:PICT_ID,:ID, 0, 0) ';
    insertQuery.Prepared := True;

{    while not msQuery.Eof do
    begin
      insertQuery.Parameters[0].Value := msQuery.FieldByName('ART_ID').AsInteger;
      insertQuery.Parameters[1].Value := msQuery.FieldByName('ART_LOOK').AsString;
      insertQuery.Parameters[2].Value := msQuery.FieldByName('SUP_BRAND').AsString;
      insertQuery.Parameters[3].Value := msQuery.FieldByName('ART_ID').AsInteger;
      insertQuery.Parameters[4].Value := msQuery.FieldByName('ART_ID').AsInteger;
      insertQuery.Parameters[5].Value := msQuery.FieldByName('ART_ID').AsInteger;
      insertQuery.Execute;
      msQuery.Next;
      inc(i);
      if i mod 100 = 0 then
        UpdateProgress(0, 'insert...' + inttostr(i));
    end;    }


  aReader := TCSVReader.Create;
  aReader.Open(OpenDialog.FileName);
  aReader.ReturnLine;
  while not aReader.Eof do
  begin
      aReader.ReturnLine;
      insertQuery.Parameters[0].Value := aReader.Fields[0];
      insertQuery.Parameters[1].Value := aReader.Fields[1];
      insertQuery.Parameters[2].Value := aReader.Fields[2];
      insertQuery.Parameters[3].Value := aReader.Fields[0];
      insertQuery.Parameters[4].Value := aReader.Fields[0];
      insertQuery.Parameters[5].Value := aReader.Fields[0];
      insertQuery.Parameters[6].Value := i;
      insertQuery.Execute;
      inc(i);
      if i mod 100 = 0 then
        UpdateProgress(0, 'insert...' + inttostr(i));
    end;


  finally

  end;



  exit;


  aReader := TCSVReader.Create;
  aReader.Open('E:\AN_DESCR.csv');
  str := TStringList.Create;
  aReader.DosToAnsiEncode := TRUE;
  aReader.ReturnLine;
  while not aReader.Eof do
  begin
    line := aReader.ReturnLine;
    str.Add(line + ';' + CreateShortCode(aReader.Fields[0]));
  end;
  str.SaveToFile('E:\ANE.CSV');
  exit;
end;

procedure TFormMain.Button5Click(Sender: TObject);
begin
  DBConnect;
  try
    LoadAddTDArt('', True);
  finally
    DBDisconnect;
  end;
end;

procedure TFormMain.btImport_ARTTYPClick(Sender: TObject);
var
  f: TextFile;
  aValue: string;
  i, p: Integer;
  aFound: Boolean;
  aBeginFrom: string;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  btImport_ARTTYP.Enabled := False;

  aBeginFrom := '';

  DBConnect;
  try
    p := GetLastTableID('ART_TYP');
    msQuery.SQL.Text := 'SELECT * FROM ART_TYP WHERE ID = ' + IntToStr(p);
    msQuery.Open;
    aBeginFrom := msQuery.FieldByName('ART_ID').AsString + ';' + msQuery.FieldByName('TYP_ID').AsString;
    msQuery.Close;

    i := 0;
    UpdateProgress(0, 'поиск старта...');
    aFound := False;
    AssignFile(f, 'd:\ART_TYP.csv');
    ReSet(f);
    try
      if aBeginFrom <> '' then
      begin
        while not System.Eof(f) do
        begin
          ReadLn(f, aValue);
          if aValue = aBeginFrom then
          begin
            aFound := True;
            Break;
          end;
          Inc(i);
          if i mod 10000 = 0 then
            UpdateProgress(0, 'поиск старта...' + IntToStr(i));
        end;
      end
      else
        aFound := True;

      if not aFound then
      begin
        ShowMessage(aBeginFrom + ' line not found in file');
        Exit;
      end;

      insertQuery.CommandText :=
        ' INSERT INTO ART_TYP (ART_ID, TYP_ID) VALUES ( :ART_ID, :TYP_ID ) ';
      insertQuery.Prepared := True;

      UpdateProgress(0, 'импорт...');
      while not Eof(f) do
      begin
        ReadLn(f, aValue);
        p := POS(';', aValue);
        insertQuery.Parameters[0].Value := Copy(aValue, 1, p - 1);
        insertQuery.Parameters[1].Value := Copy(aValue, p + 1, MaxInt);
        insertQuery.Execute;
        Inc(i);
        if i mod 500 = 0 then
          UpdateProgress(0, 'импорт... ' + IntToStr(i));

        if fAborted then
          Break;
      end;
    finally
      CloseFile(f);
    end;

  finally
    DBDisconnect;
    UpdateProgress(0, 'finish');
    btImport_ARTTYP.Enabled := True;
  end;

end;

procedure TFormMain.btLoadHidedManufacturersClick(Sender: TObject);
var
  aReader: TCSVReader;
begin
 if not OpenDialog.Execute then
   Exit;

 DBConnect;
 aReader := TCSVReader.Create;
 try
   aReader.Open(OpenDialog.FileName);

   aReader.ReturnLine;
   while not aReader.Eof do
   begin
     aReader.ReturnLine;
     ExecQueryMS(' UPDATE TD_MANUFACTURERS SET HIDE = 1 WHERE MFA_BRAND = :MFA_BRAND ', [aReader.Fields[1]]);
   end;
   aReader.Close;
 finally
   aReader.Free;
   DBDisconnect;
 end;
end;

procedure TFormMain.btImport_ARTTYP2Click(Sender: TObject);
const
  cArtBatchCount = 100000;
var
  i, iMax, p: Cardinal;
  aBeginFrom_ART: Cardinal;
  aPrevART: Cardinal;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;

  aBeginFrom_ART := 0;

  DBConnect;
  TecdocConnect;
  try
    insertQuery.CommandText :=
      ' INSERT INTO ART_TYP (LA_ID, ART_ID, TYP_ID) VALUES (:LA_ID, :ART_ID, :TYP_ID ) ';
    insertQuery.Prepared := True;

    p := GetLastTableID('ART_TYP');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT LA_ID FROM ART_TYP WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_ART := msQuery.FieldByName('LA_ID').AsInteger;
      msQuery.Close;
    end;

//    iMax := 74161995 - p;
    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT DISTINCT Count(*) ' +
      ' FROM TOF_LINK_LA_TYP INNER JOIN TOF_LINK_ART ON LAT_LA_ID=LA_ID ' +
      ' WHERE LA_ID > :ART_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_ART;
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;

    i := 0;
    //селектим пачками для cArtBatchCount артикулов
    while True do
    begin
      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i) + ' - tecdoc query...');
{
      tdQuery.SQL.Text :=
        ' SELECT DISTINCT LA_ID, LA_ART_ID, LAT_TYP_ID ' +
        ' FROM TOF_LINK_LA_TYP INNER JOIN TOF_LINK_ART ON LAT_LA_ID=LA_ID ' +
        ' WHERE LA_ART_ID > :ART_ID1 AND LA_ART_ID <= :ART_ID2 ' +
        ' ORDER BY LA_ART_ID, LA_ID, LAT_TYP_ID ';
}
      tdQuery.SQL.Text :=
        ' SELECT DISTINCT LA_ID, LA_ART_ID, LAT_TYP_ID ' +
        ' FROM TOF_LINK_LA_TYP INNER JOIN TOF_LINK_ART ON LAT_LA_ID=LA_ID ' +
        ' WHERE LA_ID > :ART_ID1 AND LA_ID <= :ART_ID2 ' +
        ' ORDER BY LA_ID, LA_ART_ID, LAT_TYP_ID ';

      tdQuery.Parameters[0].Value := aBeginFrom_ART;
      tdQuery.Parameters[1].Value := aBeginFrom_ART + cArtBatchCount;
      tdQuery.Open;
      if tdQuery.Eof then
        Break;

      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
      while not tdQuery.Eof do
      begin
        //перебираем записи для одного артикула
        aPrevART := tdQuery.FieldByName('LA_ID').AsInteger;
        while (not tdQuery.Eof) and (aPrevART = tdQuery.FieldByName('LA_ID').AsInteger) do
        begin
          //LA_ID, LA_ART_ID, LAT_TYP_ID
          insertQuery.Parameters[0].Value := tdQuery.FieldByName('LA_ID').AsInteger;
          insertQuery.Parameters[1].Value := tdQuery.FieldByName('LA_ART_ID').AsInteger;
          insertQuery.Parameters[2].Value := tdQuery.FieldByName('LAT_TYP_ID').AsInteger;
          insertQuery.Execute;
          tdQuery.Next;

          Inc(i);
          if i mod 500 = 0 then
            UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
        end;

        if fAborted then
          Break;
      end;
      tdQuery.Close;

      if fAborted then
        Break;

      Inc(aBeginFrom_ART, cArtBatchCount);
    end;

  finally
    TecdocDisconnect;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;

procedure TFormMain.btFill_PictCodesClick(Sender: TObject);
var
  i, iMax, p: Integer;
  aBeginFrom_ART, aBeginFrom_PICT: Integer;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  btFill_PictCodes.Enabled := False;

  aBeginFrom_ART := 0;
  aBeginFrom_PICT := 0;

  DBConnect;
  TecdocConnect;
  try
    p := GetLastTableID('ART_PICTS');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT * FROM ART_PICTS WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_ART := msQuery.FieldByName('ART_ID').AsInteger;
      aBeginFrom_PICT := msQuery.FieldByName('PICT_ID').AsInteger;
      msQuery.Close;
    end;

    insertQuery.CommandText :=
      ' INSERT INTO ART_PICTS ( ART_ID,  PICT_ID,  SORT,  PICT_NR) ' +
      '                VALUES (:ART_ID, :PICT_ID, :SORT, :PICT_NR) ';
    insertQuery.Prepared := True;


    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT COUNT(LGA_ART_ID) ' +
      ' FROM TOF_LINK_GRA_ART INNER JOIN TOF_GRAPHICS ON LGA_GRA_ID = GRA_ID ' +
      ' WHERE (GRA_GRD_ID IS NOT NULL) AND (LGA_ART_ID >= :ART_ID) ' +
      ' ORDER BY LGA_ART_ID, GRA_GRD_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_ART;
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;

    UpdateProgress(0, 'Tecdoc query...');
    tdQuery.SQL.Text :=
      ' SELECT LGA_ART_ID, LGA_SORT, GRA_GRD_ID, GRA_TAB_NR ' +
      ' FROM TOF_LINK_GRA_ART INNER JOIN TOF_GRAPHICS ON LGA_GRA_ID = GRA_ID ' +
      ' WHERE (GRA_GRD_ID IS NOT NULL) AND (LGA_ART_ID >= :ART_ID) ' +
      ' ORDER BY LGA_ART_ID, GRA_GRD_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_ART;
    tdQuery.Open;

    i := 0;
    //ищем последнюю добавленную картинку
    if aBeginFrom_PICT > 0 then
      while not tdQuery.Eof do
      begin
        Inc(i);
        if tdQuery.FieldByName('GRA_GRD_ID').AsInteger = aBeginFrom_PICT then
        begin
          tdQuery.Next;
          Break;
        end;
        tdQuery.Next;
      end;

    UpdateProgress(0, 'Импорт [' + IntToStr(iMax) + ']... ');
    while not tdQuery.Eof do
    begin
      insertQuery.Parameters[0].Value := tdQuery.FieldByName('LGA_ART_ID').AsInteger;
      insertQuery.Parameters[1].Value := tdQuery.FieldByName('GRA_GRD_ID').AsInteger;
      insertQuery.Parameters[2].Value := tdQuery.FieldByName('LGA_SORT').AsInteger;
      insertQuery.Parameters[3].Value := tdQuery.FieldByName('GRA_TAB_NR').AsInteger;
      insertQuery.Execute;

      tdQuery.Next;

      Inc(i);
      if i mod 500 = 0 then
        UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
      if fAborted then
        Break;
    end;
    tdQuery.Close;

  finally
    TecdocDisconnect;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    btFill_PictCodes.Enabled := True;
  end;
end;

procedure TFormMain.btFill_PictDataClick(Sender: TObject);
var
  i, iMax, p: Integer;
  aBeginFrom_PICT: Integer;
  aStream: TMemoryStream;
begin
  fAborted := False;
  btFill_PictData.Enabled := False;
  UpdateProgress(0, ' ');

  aBeginFrom_PICT := 0;

  DBConnect;
  TecdocConnect;
  aStream := TMemoryStream.Create;
  try
    p := GetLastTableID('TD_PICTS');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT * FROM TD_PICTS WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_PICT := msQuery.FieldByName('PICT_ID').AsInteger;
      msQuery.Close;
    end;

    insertQuery.CommandText :=
//      ' update TD_PICTS set PICT_DATA = :PICT_DATA, HASH = :HASH where PICT_ID = :PICT_ID ' ;
      ' INSERT INTO TD_PICTS ( PICT_ID,  PICT_DATA,  HASH) ' +
      '               VALUES (:PICT_ID, :PICT_DATA, :HASH) ';
    insertQuery.Prepared := True;

    UpdateProgress(0, 'Query count...');
    msQuery.SQL.Text := 'SELECT COUNT(DISTINCT PICT_ID) FROM ART_PICTS WHERE PICT_ID > :PICT_ID';
    msQuery.Parameters[0].Value := aBeginFrom_PICT;
    msQuery.Open;
    iMax := msQuery.Fields[0].AsInteger;
    msQuery.Close;

    UpdateProgress(0, 'Query pictures IDs...');
    msQuery.SQL.Text := 'SELECT DISTINCT PICT_ID, PICT_NR FROM ART_PICTS WHERE PICT_ID > :PICT_ID ORDER BY PICT_ID';
    msQuery.Parameters[0].Value := aBeginFrom_PICT;
    msQuery.Open;

    i := 0;
    UpdateProgress(0, 'Импорт [' + IntToStr(iMax) + ']... ');
    while not msQuery.Eof do
    begin
      tdQuery.SQL.Text :=
        ' SELECT GRD_ID, GRD_GRAPHIC ' +
        ' FROM TOF_GRA_DATA_' + msQuery.FieldByName('PICT_NR').AsString +
        ' WHERE GRD_ID = ' + msQuery.FieldByName('PICT_ID').AsString;
      tdQuery.Open;

      insertQuery.Parameters[0].Value := tdQuery.FieldByName('GRD_ID').AsInteger;
      TBlobField(tdQuery.FieldByName('GRD_GRAPHIC')).SaveToStream(aStream);
      insertQuery.Parameters[1].LoadFromStream(aStream, ftBlob);
      insertQuery.Parameters[2].Value := md5.MD5DigestToStr( md5.MD5Stream(aStream) );
      aStream.Clear;
      insertQuery.Execute;
      //Button4Click(nil);
      msQuery.Next;

      Inc(i);
      if i mod 100 = 0 then
        UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
      if fAborted then
        Break;
    end;
    msQuery.Close;

  finally
    aStream.Free;
    TecdocDisconnect;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    btFill_PictData.Enabled := True;
  end;
end;


procedure TFormMain.btFill_PictHashClick(Sender: TObject);
var
  i, iMax, p: Integer;
  aBeginFrom_ID: Integer;
  aHash: string;
  aStream: TMemoryStream;
  sl: TStrings;
begin
  fAborted := False;
  (Sender as TButton).Enabled := False;
  UpdateProgress(0, ' ');

  aBeginFrom_ID := 0;

  DBConnect;
  aStream := TMemoryStream.Create;
  sl := TStringList.Create;
  try
    insertQuery.CommandText :=
      ' UPDATE TD_PICTS SET HASH = :HASH WHERE ID = :ID ';
    insertQuery.Prepared := True;

    UpdateProgress(0, 'Query count...');
    msQuery.SQL.Text := ' SELECT COUNT(ID) FROM TD_PICTS WHERE HASH IS NULL';
    msQuery.Open;
    iMax := msQuery.Fields[0].AsInteger;
    msQuery.Close;

    i := 0;
    UpdateProgress(0, 'Подсчет хэш-сумм [' + IntToStr(iMax) + ']... ');
    while True do
    begin
      msQuery.SQL.Text := ' SELECT TOP 100 ID, PICT_DATA, PICT_ID FROM TD_PICTS WHERE HASH IS NULL AND ID > :ID ORDER BY ID';
      msQuery.Parameters[0].Value := aBeginFrom_ID;
      msQuery.Open;

      if msQuery.Eof then
        Break;

      sl.Clear;
      while not msQuery.Eof do
      begin
//      TBlobField(msQuery.FieldByName('PICT_DATA')).SaveTofile('d:\!_Test\_td_picts\'+msQuery.FieldByName('PICT_ID').AsString+'.jpg');
        TBlobField(msQuery.FieldByName('PICT_DATA')).SaveToStream(aStream);
        aHash := md5.MD5DigestToStr( md5.MD5Stream(aStream) );
        aStream.Clear;
        sl.Add(msQuery.FieldByName('ID').AsString  + '=' + aHash);
        msQuery.Next;


        Inc(aBeginFrom_ID);
      end;
      msQuery.Close;

      for p := 0 to sl.Count - 1 do
      begin
        insertQuery.Parameters[0].Value := StrGetValue(sl[p]); //hash
        insertQuery.Parameters[1].Value := StrGetName(sl[p]);  //id
        insertQuery.Execute;

        Inc(i);
        if i mod 100 = 0 then
          UpdateProgress(i * 100 div iMax, 'Подсчет хэш-сумм [' + IntToStr(iMax) + ']... ' + IntToStr(i));
        if fAborted then
          Break;
      end;

      if fAborted then
        Break;
    end; //while True
    msQuery.Close;
    
  finally
    sl.Free;
    aStream.Free;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;

procedure TFormMain.btFill_ArtsClick(Sender: TObject);

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

var
  i, iMax, p: Integer;
  aBeginFrom_ART: Integer;
  aBeginFrom_LOOK: string;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  btFill_Arts.Enabled := False;
  i:=0;
  aBeginFrom_ART := 0;
  aBeginFrom_LOOK := '';

  DBConnect;
  TecdocConnect;
  try
    insertQuery.CommandText :=
      ' INSERT INTO TD_ART ( ART_ID,  ART_LOOK,  SUP_BRAND ) ' +
      '             VALUES (:ART_ID, :ART_LOOK, :SUP_BRAND ) ';
    insertQuery.Prepared := True;

   { p := GetLastTableID('TD_ART');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT * FROM TD_ART WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_ART := msQuery.FieldByName('ART_ID').AsInteger;
      aBeginFrom_LOOK := msQuery.FieldByName('ART_LOOK').AsString;
      msQuery.Close;
    end;  }

    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(ART_ID) ' +
      ' FROM TOF_ARTICLES INNER JOIN TOF_SUPPLIERS ON ART_SUP_ID = SUP_ID ';

      {      ' SELECT Count(ART_ID) ' +
      ' FROM TOF_ARTICLES INNER JOIN TOF_SUPPLIERS ON ART_SUP_ID = SUP_ID ' +
      ' WHERE ART_ID >= :ART_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_ART;}
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;

    UpdateProgress(0, 'Tecdoc query...');
    tdQuery.SQL.Text :=
      ' SELECT ART_ID, ART_ARTICLE_NR, ART_SUP_ID, SUP_BRAND ' +
      ' FROM TOF_ARTICLES INNER JOIN TOF_SUPPLIERS ON ART_SUP_ID = SUP_ID ' +
      ' ORDER BY ART_ID, ART_ARTICLE_NR ';

      {      ' SELECT ART_ID, ART_ARTICLE_NR, ART_SUP_ID, SUP_BRAND ' +
      ' FROM TOF_ARTICLES INNER JOIN TOF_SUPPLIERS ON ART_SUP_ID = SUP_ID ' +
      ' WHERE ART_ID >= :ART_ID ' +
      ' ORDER BY ART_ID, ART_ARTICLE_NR ';
    tdQuery.Parameters[0].Value := aBeginFrom_ART;}
    tdQuery.Open;

    {i := 0;
    //ищем последнюю добавленную
    if aBeginFrom_LOOK <> '' then
      while not tdQuery.Eof do
      begin
        Inc(i);
        if MakeSearchCode(tdQuery.FieldByName('ART_ARTICLE_NR').AsString) = aBeginFrom_LOOK then
        begin
          tdQuery.Next;
          Break;
        end;
        tdQuery.Next;
      end;    }

    UpdateProgress(0, 'Импорт [' + IntToStr(iMax) + ']... ');
    while not tdQuery.Eof do
    begin
      insertQuery.Parameters[0].Value := tdQuery.FieldByName('ART_ID').AsInteger;
      insertQuery.Parameters[1].Value := MakeSearchCode(tdQuery.FieldByName('ART_ARTICLE_NR').AsString);
      insertQuery.Parameters[2].Value := AnsiUpperCase(tdQuery.FieldByName('SUP_BRAND').AsString);
      insertQuery.Execute;

      tdQuery.Next;

      Inc(i);
      if i mod 500 = 0 then
        UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
      if fAborted then
        Break;
    end;
    tdQuery.Close;

  finally
    TecdocDisconnect;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    btFill_Arts.Enabled := True;
  end;

end;

procedure TFormMain.btFill_TypClick(Sender: TObject);

  function GetEngCodes(aTypeID: Integer): string;
  var
    aQuery: TADOQuery;
  begin
    Result := '';
    aQuery := TADOQuery.Create(nil);
    try
      aQuery.Connection := tdQuery.Connection;
      aQuery.SQL.Text :=
        'SELECT ENG_CODE FROM TOF_LINK_TYP_ENG ' +
        'JOIN TOF_ENGINES ON LTE_ENG_ID = ENG_ID ' +
        'WHERE LTE_TYP_ID = :TYP_ID';
      aQuery.Parameters[0].Value := aTypeID;

      aQuery.Open;
      while not aQuery.Eof do
      begin
        if Result <> '' then
          Result := Result + ', ';
        Result := Result + aQuery.FieldByName('ENG_CODE').AsString;
        aQuery.Next;
      end;
      aQuery.Close;

    finally
      aQuery.Free;
    end;
  end;

var
  i, iMax, p: Integer;
  aBeginFrom_TYPE: Integer;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  btFill_Typ.Enabled := False;

  aBeginFrom_TYPE := 0;

  DBConnect;
  TecdocConnect;
  try
    insertQuery.CommandText :=
      ' INSERT INTO TD_TYPES ( ' +
      ' TYP_ID, ' +
      ' MOD_ID, ' +
      ' CDS_ID, ' +
      ' MMT_CDS_ID, ' +
      ' SORT, ' +
      ' PCON_START, ' +
      ' PCON_END, ' +
      ' KW_FROM, ' +
      ' KW_UPTO, ' +
      ' HP_FROM, ' +
      ' HP_UPTO, ' +
      ' CCM, ' +
      ' CYLINDERS, ' +
      ' DOORS, ' +
      ' TANK, ' +
      ' VOLTAGE_DES_ID, ' +
      ' ABS_DES_ID, ' +
      ' ASR_DES_ID, ' +
      ' ENGINE_DES_ID, ' +
      ' BRAKE_TYPE_DES_ID, ' +
      ' BRAKE_SYST_DES_ID, ' +
      ' FUEL_DES_ID, ' +
      ' CATALYST_DES_ID, ' +
      ' BODY_DES_ID, ' +
      ' STEERING_DES_ID, ' +
      ' STEERING_SIDE_DES_ID, ' +
      ' MAX_WEIGHT, ' +
      ' DRIVE_DES_ID, ' +
      ' TRANS_DES_ID, ' +
      ' FUEL_SUPPLY_DES_ID, ' +
      ' VALVES, ' +
      ' ENG_CODES ' +
      ' ) VALUES ( ' +
      ' :TYP_ID, ' +
      ' :MOD_ID, ' +
      ' :CDS_ID, ' +
      ' :MMT_CDS_ID, ' +
      ' :SORT, ' +
      ' :PCON_START, ' +
      ' :PCON_END, ' +
      ' :KW_FROM, ' +
      ' :KW_UPTO, ' +
      ' :HP_FROM, ' +
      ' :HP_UPTO, ' +
      ' :CCM, ' +
      ' :CYLINDERS, ' +
      ' :DOORS, ' +
      ' :TANK, ' +
      ' :VOLTAGE_DES_ID, ' +
      ' :ABS_DES_ID, ' +
      ' :ASR_DES_ID, ' +
      ' :ENGINE_DES_ID, ' +
      ' :BRAKE_TYPE_DES_ID, ' +
      ' :BRAKE_SYST_DES_ID, ' +
      ' :FUEL_DES_ID, ' +
      ' :CATALYST_DES_ID, ' +
      ' :BODY_DES_ID, ' +
      ' :STEERING_DES_ID, ' +
      ' :STEERING_SIDE_DES_ID, ' +
      ' :MAX_WEIGHT, ' +
      ' :DRIVE_DES_ID, ' +
      ' :TRANS_DES_ID, ' +
      ' :FUEL_SUPPLY_DES_ID, ' +
      ' :VALVES, ' +
      ' :ENG_CODES )';
    insertQuery.Prepared := True;

   { p := GetLastTableID('TD_TYPES');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT TYP_ID FROM TD_TYPES WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_TYPE := msQuery.FieldByName('TYP_ID').AsInteger;
      msQuery.Close;
    end;

    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(TYP_ID) FROM TOF_TYPES ' +
      ' WHERE TYP_ID > :TYP_ID ' +
      ' ORDER BY TYP_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_TYPE;
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;
    }
    UpdateProgress(0, 'Tecdoc query...');
    tdQuery.SQL.Text :=
      ' SELECT * FROM TOF_TYPES ' +
      ' ORDER BY TYP_ID ';
{      ' SELECT * FROM TOF_TYPES ' +
      ' WHERE TYP_ID > :TYP_ID ' +
      ' ORDER BY TYP_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_TYPE;    }
    tdQuery.Open;

    i := 0;
    UpdateProgress(0, 'Импорт [' + IntToStr(iMax) + ']... ');
    while not tdQuery.Eof do
    begin
      insertQuery.Parameters.ParamByName('TYP_ID').Value :=               tdQuery.FieldByName('TYP_ID').AsInteger;
      insertQuery.Parameters.ParamByName('MOD_ID').Value :=               tdQuery.FieldByName('TYP_MOD_ID').AsInteger;
      insertQuery.Parameters.ParamByName('CDS_ID').Value :=               tdQuery.FieldByName('TYP_CDS_ID').AsInteger;
      insertQuery.Parameters.ParamByName('MMT_CDS_ID').Value :=           tdQuery.FieldByName('TYP_MMT_CDS_ID').AsInteger;
      insertQuery.Parameters.ParamByName('SORT').Value :=                 tdQuery.FieldByName('TYP_SORT').AsInteger;
      insertQuery.Parameters.ParamByName('PCON_START').Value :=           tdQuery.FieldByName('TYP_PCON_START').AsInteger;
      insertQuery.Parameters.ParamByName('PCON_END').Value :=             tdQuery.FieldByName('TYP_PCON_END').AsInteger;
      insertQuery.Parameters.ParamByName('KW_FROM').Value :=              tdQuery.FieldByName('TYP_KW_FROM').AsInteger;
      insertQuery.Parameters.ParamByName('KW_UPTO').Value :=              tdQuery.FieldByName('TYP_KW_UPTO').AsInteger;
      insertQuery.Parameters.ParamByName('HP_FROM').Value :=              tdQuery.FieldByName('TYP_HP_FROM').AsInteger;
      insertQuery.Parameters.ParamByName('HP_UPTO').Value :=              tdQuery.FieldByName('TYP_HP_UPTO').AsInteger;
      insertQuery.Parameters.ParamByName('CCM').Value :=                  tdQuery.FieldByName('TYP_CCM').AsInteger;
      insertQuery.Parameters.ParamByName('CYLINDERS').Value :=            tdQuery.FieldByName('TYP_CYLINDERS').AsInteger;
      insertQuery.Parameters.ParamByName('DOORS').Value :=                tdQuery.FieldByName('TYP_DOORS').AsInteger;
      insertQuery.Parameters.ParamByName('TANK').Value :=                 tdQuery.FieldByName('TYP_TANK').AsInteger;
      insertQuery.Parameters.ParamByName('VOLTAGE_DES_ID').Value :=       tdQuery.FieldByName('TYP_KV_VOLTAGE_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('ABS_DES_ID').Value :=           tdQuery.FieldByName('TYP_KV_ABS_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('ASR_DES_ID').Value :=           tdQuery.FieldByName('TYP_KV_ASR_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('ENGINE_DES_ID').Value :=        tdQuery.FieldByName('TYP_KV_ENGINE_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('BRAKE_TYPE_DES_ID').Value :=    tdQuery.FieldByName('TYP_KV_BRAKE_TYPE_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('BRAKE_SYST_DES_ID').Value :=    tdQuery.FieldByName('TYP_KV_BRAKE_SYST_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('FUEL_DES_ID').Value :=          tdQuery.FieldByName('TYP_KV_FUEL_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('CATALYST_DES_ID').Value :=      tdQuery.FieldByName('TYP_KV_CATALYST_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('BODY_DES_ID').Value :=          tdQuery.FieldByName('TYP_KV_BODY_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('STEERING_DES_ID').Value :=      tdQuery.FieldByName('TYP_KV_STEERING_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('STEERING_SIDE_DES_ID').Value := tdQuery.FieldByName('TYP_KV_STEERING_SIDE_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('MAX_WEIGHT').Value :=           tdQuery.FieldByName('TYP_MAX_WEIGHT').AsFloat;
      insertQuery.Parameters.ParamByName('DRIVE_DES_ID').Value :=         tdQuery.FieldByName('TYP_KV_DRIVE_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('TRANS_DES_ID').Value :=         tdQuery.FieldByName('TYP_KV_TRANS_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('FUEL_SUPPLY_DES_ID').Value :=   tdQuery.FieldByName('TYP_KV_FUEL_SUPPLY_DES_ID').AsInteger;
      insertQuery.Parameters.ParamByName('VALVES').Value :=               tdQuery.FieldByName('TYP_VALVES').AsInteger;
      insertQuery.Parameters.ParamByName('ENG_CODES').Value := GetEngCodes(tdQuery.FieldByName('TYP_ID').AsInteger);
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
    DBDisconnect;
    UpdateProgress(0, 'finish');
    btFill_Typ.Enabled := True;
  end;

end;

procedure TFormMain.btFill_DesClick(Sender: TObject);
var
  i, iMax, p: Integer;
  aBeginFrom_DES: Integer;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;

  aBeginFrom_DES := 0;

  DBConnect;
  TecdocConnect;
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
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;



procedure TFormMain.btFill_CdsClick(Sender: TObject);
var
  i, iMax, p: Integer;
  aBeginFrom_CDS: Integer;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;

  aBeginFrom_CDS := 0;

  DBConnect;
  TecdocConnect;
  try
    insertQuery.CommandText :=
      ' INSERT INTO TD_CDS (CDS_ID, TEX_TEXT) VALUES ( :CDS_ID, :TEX_TEXT ) ';
    insertQuery.Prepared := True;

    p := GetLastTableID('TD_CDS');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT CDS_ID FROM TD_CDS WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_CDS := msQuery.FieldByName('CDS_ID').AsInteger;
      msQuery.Close;
    end;

    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(DISTINCT CDS_ID) ' +
      ' FROM TOF_COUNTRY_DESIGNATIONS INNER JOIN TOF_DES_TEXTS ON CDS_TEX_ID=TEX_ID ' +
      ' WHERE ((CDS_LNG_ID = 16) OR (CDS_LNG_ID = 255)) AND (CDS_CTM Subrange(185 cast integer) = 1) AND CDS_ID > :CDS_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_CDS;
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;

    UpdateProgress(0, 'Tecdoc query...');
    tdQuery.SQL.Text :=
      ' SELECT CDS_ID, MAX(DISTINCT TEX_TEXT) AS TEX_TEXT ' +
      ' FROM TOF_COUNTRY_DESIGNATIONS INNER JOIN TOF_DES_TEXTS ON CDS_TEX_ID=TEX_ID ' +
      ' WHERE ((CDS_LNG_ID = 16) OR (CDS_LNG_ID = 255)) AND (CDS_CTM Subrange(185 cast integer) = 1) AND CDS_ID > :CDS_ID ' +
      ' GROUP BY CDS_ID ' +
      ' ORDER BY CDS_ID ';


    tdQuery.Parameters[0].Value := aBeginFrom_CDS;
    tdQuery.Open;

    i := 0;
    UpdateProgress(0, 'Импорт [' + IntToStr(iMax) + ']... ');
    while not tdQuery.Eof do
    begin
      insertQuery.Parameters[0].Value := tdQuery.FieldByName('CDS_ID').AsInteger;
      insertQuery.Parameters[1].Value := Copy(tdQuery.FieldByName('TEX_TEXT').AsString, 1, 128);
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
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;

procedure TFormMain.btFill_ModelsClick(Sender: TObject);
var
  i, iMax, p: Integer;
  aBeginFrom_MOD: Integer;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;

  aBeginFrom_MOD := 0;

  DBConnect;
  TecdocConnect;
  try
    insertQuery.CommandText :=
      ' INSERT INTO TD_MODELS ( MOD_ID,  MFA_ID,  PCON_START,  PCON_END,  CDS_ID,  TEX_TEXT) ' +
      '                VALUES (:MOD_ID, :MFA_ID, :PCON_START, :PCON_END, :CDS_ID, :TEX_TEXT) ';
    insertQuery.Prepared := True;

    {p := GetLastTableID('TD_MODELS');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT MOD_ID FROM TD_MODELS WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_MOD := msQuery.FieldByName('MOD_ID').AsInteger;
      msQuery.Close;
    end;

    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(MOD_ID) FROM TOF_MODELS WHERE MOD_ID > :MOD_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_MOD;
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;   }
    tdQuery.Close;

    UpdateProgress(0, 'Tecdoc query...');
    tdQuery.SQL.Text :=
      ' SELECT MOD_ID, MOD_MFA_ID, MOD_PCON_START, MOD_PCON_END, MOD_CDS_ID FROM TOF_MODELS ' +
      ' ORDER BY MOD_ID ';
    {      ' SELECT MOD_ID, MOD_MFA_ID, MOD_PCON_START, MOD_PCON_END, MOD_CDS_ID FROM TOF_MODELS ' +
      ' WHERE MOD_ID > :MOD_ID ' +
      ' ORDER BY MOD_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_MOD;  }
    tdQuery.Open;

    i := 0;
    UpdateProgress(0, 'Импорт [' + IntToStr(iMax) + ']... ');
    while not tdQuery.Eof do
    begin
      //MOD_ID,  MFA_ID,  PCON_START,  PCON_END,  CDS_ID,  TEX_TEXT
      insertQuery.Parameters[0].Value := tdQuery.FieldByName('MOD_ID').AsInteger;
      insertQuery.Parameters[1].Value := tdQuery.FieldByName('MOD_MFA_ID').AsInteger;
      insertQuery.Parameters[2].Value := tdQuery.FieldByName('MOD_PCON_START').AsInteger;
      insertQuery.Parameters[3].Value := tdQuery.FieldByName('MOD_PCON_END').AsInteger;
      insertQuery.Parameters[4].Value := tdQuery.FieldByName('MOD_CDS_ID').AsInteger;
      //lookup to TD_CDS.TEX_TEXT
      insertQuery.Parameters[5].Value :=
        ExecuteSimpleSelectMS('SELECT TEX_TEXT FROM TD_CDS WHERE CDS_ID = :CDS_ID', [tdQuery.FieldByName('MOD_CDS_ID').AsInteger]);
      insertQuery.Execute;

      tdQuery.Next;

      Inc(i);
      if i mod 50 = 0 then
        UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
      if fAborted then
        Break;
    end;
    tdQuery.Close;

  finally
    TecdocDisconnect;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;

//TD_MANUFACTURERS
procedure TFormMain.btFill_ManufacturersClick(Sender: TObject);

  function FixManufacturerName(const aName: string): string;
  begin
    if SameText(aName, 'CITRO?N') then
      Result := 'CITROEN'
    else
      Result := AnsiUpperCase(aName);
  end;

var
  i, iMax, p: Integer;
  aBeginFrom_MFA: Integer;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;

  aBeginFrom_MFA := 0;

  DBConnect;
  TecdocConnect;
  try
    insertQuery.CommandText :=
      ' INSERT INTO TD_MANUFACTURERS ( MFA_ID,  MFA_BRAND,  HIDE) ' +
      '                       VALUES (:MFA_ID, :MFA_BRAND, :HIDE) ';
    insertQuery.Prepared := True;

    p := GetLastTableID('TD_MANUFACTURERS');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT MFA_ID FROM TD_MANUFACTURERS WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_MFA := msQuery.FieldByName('MFA_ID').AsInteger;
      msQuery.Close;
    end;

    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(MFA_ID) FROM TOF_MANUFACTURERS WHERE MFA_ID > :MFA_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_MFA;
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;

    UpdateProgress(0, 'Tecdoc query...');
    tdQuery.SQL.Text :=
      ' SELECT MFA_ID, MFA_BRAND FROM TOF_MANUFACTURERS ' +
      ' WHERE MFA_ID > :MFA_ID ' +
      ' ORDER BY MFA_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_MFA;
    tdQuery.Open;

    i := 0;
    UpdateProgress(0, 'Импорт [' + IntToStr(iMax) + ']... ');
    while not tdQuery.Eof do
    begin
      insertQuery.Parameters[0].Value := tdQuery.FieldByName('MFA_ID').AsInteger;
      insertQuery.Parameters[1].Value := FixManufacturerName(tdQuery.FieldByName('MFA_BRAND').AsString);
      insertQuery.Parameters[2].Value := 0;
      insertQuery.Execute;

      tdQuery.Next;

      Inc(i);
      if i mod 50 = 0 then
        UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
      if fAborted then
        Break;
    end;
    tdQuery.Close;

  finally
    TecdocDisconnect;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;

procedure TFormMain.btFill_ParamsClick(Sender: TObject);
const
  cArtBatchCount = 5000;
var
  i, iMax, p: Integer;
  aBeginFrom_ART: Integer;
  aPrevART: Integer;
  anAddedList: TStrings;
  aRecMap: string;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;

  aBeginFrom_ART := 0;

  DBConnect;
  TecdocConnect;
  anAddedList := TStringList.Create;
  try
    insertQuery.CommandText :=
      ' INSERT INTO TD_DETAILS ( ART_ID,  SORT,  PARAM_ID,  PARAM_VALUE) ' +
      '                 VALUES (:ART_ID, :SORT, :PARAM_ID, :PARAM_VALUE) ';
    insertQuery.Prepared := True;

    p := GetLastTableID('TD_DETAILS');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT ART_ID FROM TD_DETAILS WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_ART := msQuery.FieldByName('ART_ID').AsInteger;
      msQuery.Close;
    end;

    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(ACR_ART_ID) FROM TOF_ARTICLE_CRITERIA WHERE ACR_ART_ID > :ART_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_ART;
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;

    i := 0;
    //селектим пачками для cArtBatchCount артикулов
  if iMax > 0 then
    while True do
    begin
      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i) + ' - tecdoc query...');
      tdQuery.SQL.Text :=
        ' SELECT ACR_ART_ID, ACR_SORT, ACR_CRI_ID, ACR_KV_DES_ID, ACR_VALUE ' +
        ' FROM TOF_ARTICLE_CRITERIA ' +
        ' WHERE ACR_ART_ID > :ACR_ART_ID1 AND ACR_ART_ID <= :ACR_ART_ID2 ' +
        ' ORDER BY ACR_ART_ID, ACR_SORT ';
      tdQuery.Parameters[0].Value := aBeginFrom_ART;
      tdQuery.Parameters[1].Value := aBeginFrom_ART + cArtBatchCount;
      tdQuery.Open;
      if tdQuery.Eof and (i = iMax) then
        Break;

      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ');
      while not tdQuery.Eof do
      begin
        //перебираем записи для одного артикула
        anAddedList.Clear;
        aPrevART := tdQuery.FieldByName('ACR_ART_ID').AsInteger;
        while (not tdQuery.Eof) and (aPrevART = tdQuery.FieldByName('ACR_ART_ID').AsInteger) do
        begin
          aRecMap := tdQuery.FieldByName('ACR_CRI_ID').AsString + ';' +
                     tdQuery.FieldByName('ACR_KV_DES_ID').AsString + ';' +
                     tdQuery.FieldByName('ACR_VALUE').AsString;
          if anAddedList.IndexOf(aRecMap) = -1 then
          begin
            //ART_ID, SORT, PARAM_ID, PARAM_VALUE
            insertQuery.Parameters[0].Value := tdQuery.FieldByName('ACR_ART_ID').AsInteger;
            insertQuery.Parameters[1].Value := tdQuery.FieldByName('ACR_SORT').AsInteger;
            insertQuery.Parameters[2].Value := tdQuery.FieldByName('ACR_CRI_ID').AsInteger;
            if tdQuery.FieldByName('ACR_KV_DES_ID').AsInteger <> 0 then
            begin
              insertQuery.Parameters[3].Value :=
                Copy(ExecuteSimpleSelectMS('SELECT TEX_TEXT FROM TD_DES WHERE DES_ID = :DES_ID', [tdQuery.FieldByName('ACR_KV_DES_ID').AsInteger]), 1, 128);
            end
            else
              insertQuery.Parameters[3].Value := tdQuery.FieldByName('ACR_VALUE').AsString;
            insertQuery.Execute;
            anAddedList.Add(aRecMap);
          end;

          tdQuery.Next;

          Inc(i);
          if i mod 100 = 0 then
            UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
        end;

        if fAborted then
          Break;
      end;
      tdQuery.Close;

      if fAborted then
        Break;

      Inc(aBeginFrom_ART, cArtBatchCount);
    end;

  finally
    anAddedList.Free;
    TecdocDisconnect;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;

procedure TFormMain.btFill_ParamsByTypesClick(Sender: TObject);
const
  cArtBatchCount = 5000;
var
  i, iMax, p: Integer;
  aBeginFrom_ART: Integer;
  aPrevART: Integer;
  anAddedList: TStrings;
  aRecMap: string;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;

  aBeginFrom_ART := 0;

  DBConnect;
  TecdocConnect;
  anAddedList := TStringList.Create;
  try
    insertQuery.CommandText :=
      ' INSERT INTO TD_DETAILS_TYP ( ART_ID,  TYP_ID,  SORT,  PARAM_ID,  PARAM_VALUE) ' +
      '                     VALUES (:ART_ID, :TYP_ID, :SORT, :PARAM_ID, :PARAM_VALUE) ';
    insertQuery.Prepared := True;

    p := GetLastTableID('TD_DETAILS_TYP');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT ART_ID FROM TD_DETAILS_TYP WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_ART := msQuery.FieldByName('ART_ID').AsInteger;
      msQuery.Close;
    end;

    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(LA_ART_ID) ' +
      ' FROM TOF_LINK_LA_TYP ' +
      ' JOIN TOF_LA_CRITERIA ON LAT_LA_ID = LAC_LA_ID ' +
      ' JOIN TOF_LINK_ART ON LAT_LA_ID = LA_ID ' +
      ' WHERE LA_ART_ID > :ART_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_ART;
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;
    i := 0;
    //iMax := 1;
    //селектим пачками для cArtBatchCount артикулов
  if iMax > 0 then
    while True do
    begin
      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i) + ' - tecdoc query...');
      tdQuery.SQL.Text :=
        ' SELECT LA_ART_ID, LAT_TYP_ID, LAC_SORT, LAC_CRI_ID, LAC_VALUE, LAC_KV_DES_ID ' +
        ' FROM TOF_LINK_LA_TYP ' +
        '   JOIN TOF_LA_CRITERIA ON LAT_LA_ID = LAC_LA_ID ' +
        '   JOIN TOF_LINK_ART ON LAT_LA_ID = LA_ID ' +
        ' WHERE LA_ART_ID > :ACR_ART_ID1 AND LA_ART_ID <= :ACR_ART_ID2 ' +
        ' ORDER BY LA_ART_ID, LAT_TYP_ID, LAC_SORT ';
      tdQuery.Parameters[0].Value := aBeginFrom_ART;
      tdQuery.Parameters[1].Value := aBeginFrom_ART + cArtBatchCount;
      tdQuery.Open;
      if tdQuery.Eof and (i = iMax) then
        Break;


      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ');
      while not tdQuery.Eof do
      begin
        //перебираем записи для одного артикула
        anAddedList.Clear;
        aPrevART := tdQuery.FieldByName('LA_ART_ID').AsInteger;
        while (not tdQuery.Eof) and (aPrevART = tdQuery.FieldByName('LA_ART_ID').AsInteger) do
        begin
          aRecMap := tdQuery.FieldByName('LAC_CRI_ID').AsString + ';' +
                     tdQuery.FieldByName('LAT_TYP_ID').AsString + ';' +
                     tdQuery.FieldByName('LAC_KV_DES_ID').AsString + ';' +
                     tdQuery.FieldByName('LAC_VALUE').AsString;
          if anAddedList.IndexOf(aRecMap) = -1 then
          begin
            //ART_ID, SORT, PARAM_ID, PARAM_VALUE
            insertQuery.Parameters[0].Value := tdQuery.FieldByName('LA_ART_ID').AsInteger;
            insertQuery.Parameters[1].Value := tdQuery.FieldByName('LAT_TYP_ID').AsInteger;
            insertQuery.Parameters[2].Value := tdQuery.FieldByName('LAC_SORT').AsInteger;
            insertQuery.Parameters[3].Value := tdQuery.FieldByName('LAC_CRI_ID').AsInteger;
            if tdQuery.FieldByName('LAC_KV_DES_ID').AsInteger <> 0 then
            begin
              insertQuery.Parameters[4].Value :=
                Copy(ExecuteSimpleSelectMS('SELECT TEX_TEXT FROM TD_DES WHERE DES_ID = :DES_ID', [tdQuery.FieldByName('LAC_KV_DES_ID').AsInteger]), 1, 128);
            end
            else
              insertQuery.Parameters[4].Value := tdQuery.FieldByName('LAC_VALUE').AsString;
            insertQuery.Execute;
            anAddedList.Add(aRecMap);
          end;
          
          tdQuery.Next;

          Inc(i);
          if i mod 100 = 0 then
            UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
        end;

        if fAborted then
          Break;
      end;
      tdQuery.Close;
      
      if fAborted then
        Break;

      Inc(aBeginFrom_ART, cArtBatchCount);
    end;

  finally
    anAddedList.Free;
    TecdocDisconnect;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;

procedure TFormMain.btFill_ParamsByTypes2Click(Sender: TObject);
const
  cLABatchCount = 100000;
var
  i, iMax, p: Integer;
  aBeginFrom_LA: Integer;
  aPrevLA: Integer;
  anAddedList: TStrings;
  aRecMap: string;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;

  aBeginFrom_LA := 0;

  DBConnect;
  TecdocConnect;
  anAddedList := TStringList.Create;
  try
    insertQuery.CommandText :=
      ' INSERT INTO TD_DETAILS_TYP2 ( LA_ID,  SORT,  PARAM_ID,  PARAM_VALUE) ' +
      '                      VALUES (:LA_ID, :SORT, :PARAM_ID, :PARAM_VALUE) ';
    insertQuery.Prepared := True;

    p := GetLastTableID('TD_DETAILS_TYP2');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT LA_ID FROM TD_DETAILS_TYP2 WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_LA := msQuery.FieldByName('LA_ID').AsInteger;
      msQuery.Close;
    end;

    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(LAC_LA_ID) ' +
      ' FROM TOF_LA_CRITERIA ' +
      ' WHERE LAC_LA_ID > :LA_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_LA;
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;

    i := 0;
    //селектим пачками для cLABatchCount артикулов
  if iMax > 0 then  
    while True do
    begin
      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i) + ' - tecdoc query...');
      tdQuery.SQL.Text :=
        ' SELECT * ' +
        ' FROM TOF_LA_CRITERIA ' +
        ' WHERE LAC_LA_ID > :LA_ID1 AND LAC_LA_ID <= :LA_ID2 ' +
        ' ORDER BY LAC_LA_ID, LAC_CRI_ID, LAC_SORT ';
      tdQuery.Parameters[0].Value := aBeginFrom_LA;
      tdQuery.Parameters[1].Value := aBeginFrom_LA + cLABatchCount;
      tdQuery.Open;
      if tdQuery.Eof and (i = iMax) then
        Break;


      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
      while not tdQuery.Eof do
      begin
        //перебираем записи для одного артикула
        anAddedList.Clear;
        aPrevLA := tdQuery.FieldByName('LAC_LA_ID').AsInteger;
        while (not tdQuery.Eof) and (aPrevLA = tdQuery.FieldByName('LAC_LA_ID').AsInteger) do
        begin
          aRecMap := tdQuery.FieldByName('LAC_CRI_ID').AsString + ';' +
                     tdQuery.FieldByName('LAC_KV_DES_ID').AsString + ';' +
                     tdQuery.FieldByName('LAC_VALUE').AsString;
          if anAddedList.IndexOf(aRecMap) = -1 then
          begin
            //LA_ID,  SORT,  PARAM_ID,  PARAM_VALUE
            insertQuery.Parameters[0].Value := tdQuery.FieldByName('LAC_LA_ID').AsInteger;
            insertQuery.Parameters[1].Value := tdQuery.FieldByName('LAC_SORT').AsInteger;
            insertQuery.Parameters[2].Value := tdQuery.FieldByName('LAC_CRI_ID').AsInteger;
            if tdQuery.FieldByName('LAC_KV_DES_ID').AsInteger <> 0 then
            begin
              insertQuery.Parameters[3].Value :=
                Copy(ExecuteSimpleSelectMS('SELECT TEX_TEXT FROM TD_DES WHERE DES_ID = :DES_ID', [tdQuery.FieldByName('LAC_KV_DES_ID').AsInteger]), 1, 128);
            end
            else
              insertQuery.Parameters[3].Value := tdQuery.FieldByName('LAC_VALUE').AsString;
            insertQuery.Execute;
            anAddedList.Add(aRecMap);
          end;
          
          tdQuery.Next;

          Inc(i);
          if i mod 100 = 0 then
            UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
        end;

        if fAborted then
          Break;
      end;
      tdQuery.Close;
      
      if fAborted then
        Break;

      Inc(aBeginFrom_LA, cLABatchCount);
    end;

  finally
    anAddedList.Free;
    TecdocDisconnect;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;

procedure TFormMain.btFill_ParamNamesClick(Sender: TObject);
var
  i, iMax, p: Integer;
  aBeginFrom_PAR: Integer;
begin
  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;

  aBeginFrom_PAR := 0;

  DBConnect;
  TecdocConnect;
  try
    insertQuery.CommandText :=
      ' INSERT INTO TD_PARAMS ( PARAM_ID,  DESCR,  DESCRIPTION,  TYPE,  INTERV,  PARAM_ID2) ' +
      '                VALUES (:PARAM_ID, :DESCR, :DESCRIPTION, :TYPE, :INTERV, :PARAM_ID2) ';
    insertQuery.Prepared := True;

    p := GetLastTableID('TD_PARAMS');
    if p > 0 then
    begin
      msQuery.SQL.Text := 'SELECT PARAM_ID FROM TD_PARAMS WHERE ID = ' + IntToStr(p);
      msQuery.Open;
      aBeginFrom_PAR := msQuery.FieldByName('PARAM_ID').AsInteger;
      msQuery.Close;
    end;

    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(*) FROM TOF_CRITERIA ' +
      ' WHERE CRI_ID > :PARAM_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_PAR;
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;

    UpdateProgress(0, 'Tecdoc query...');
    tdQuery.SQL.Text :=
      ' SELECT * FROM TOF_CRITERIA ' +
      ' WHERE CRI_ID > :PARAM_ID ' +
      ' ORDER BY CRI_ID ';
    tdQuery.Parameters[0].Value := aBeginFrom_PAR;
    tdQuery.Open;

    i := 0;
    UpdateProgress(0, 'Импорт [' + IntToStr(iMax) + ']... ');
    while not tdQuery.Eof do
    begin
      //PARAM_ID,  DESCR,  DESCRIPTION,  TYPE,  INTERV,  PARAM_ID2
      insertQuery.Parameters[0].Value := tdQuery.FieldByName('CRI_ID').AsInteger;

      //lookup to TD_DES.TEX_TEXT 
      insertQuery.Parameters[1].Value :=
        Copy( ExecuteSimpleSelectMS('SELECT TEX_TEXT FROM TD_DES WHERE DES_ID = :DES_ID', [tdQuery.FieldByName('CRI_SHORT_DES_ID').AsInteger]), 1, 32);

      //lookup to TD_DES.TEX_TEXT 
      insertQuery.Parameters[2].Value :=
        Copy( ExecuteSimpleSelectMS('SELECT TEX_TEXT FROM TD_DES WHERE DES_ID = :DES_ID', [tdQuery.FieldByName('CRI_DES_ID').AsInteger]), 1, 128);

      insertQuery.Parameters[3].Value := Copy(tdQuery.FieldByName('CRI_TYPE').AsString, 1, 1);
      insertQuery.Parameters[4].Value := Integer(tdQuery.FieldByName('CRI_IS_INTERVAL').AsInteger = 1);
      insertQuery.Parameters[5].Value := tdQuery.FieldByName('CRI_SUCCESSOR').AsInteger;
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
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;

//------------------------------------------------------------------------------
procedure TFormMain.btAddPictListClick(Sender: TObject);
begin
  DBConnect;
  try
    LoadAddPictures2Bath;
  finally
    DBDisconnect;
  end;
end;

procedure TFormMain.btAddPictDirClick(Sender: TObject);
begin
  DBConnect;
  try
    LoadAddPicturesBath;
  finally
    DBDisconnect;
  end;
end;

procedure TFormMain.btAddParamsClick(Sender: TObject);
begin
  DBConnect;
  try
    LoadAddTDParamBath;
  finally
    DBDisconnect;
  end;
end;

procedure TFormMain.btAddDescriptionsClick(Sender: TObject);
begin
  DBConnect;
  try
    LoadDescriptionBath;
  finally
    DBDisconnect;
  end;
end;

procedure TFormMain.btAddArtClick(Sender: TObject);
begin
  DBConnect;
  try
    LoadAddTDArt;
  finally
    DBDisconnect;
  end;
end;


procedure TFormMain.btAddPrimenClick(Sender: TObject);
begin
  DBConnect;
  try
    LoadAddTDPrimenBath;
  finally
    DBDisconnect;
  end;
end;

//------------------------------------------------------------------------------
function TFormMain.GetNewPictID: Integer;
var
  q: IQuery;
begin
  ExecQueryMS(' UPDATE SYS_PARAMS SET PICT_ID = PICT_ID + 1 ', []);
  q := makeQueryMS(' SELECT PICT_ID FROM SYS_PARAMS ');
  q.Open;
  Result := q.Fields[0].AsInteger;
  q.Close;
end;

function TFormMain.GetNewTecdocID: Integer;
var
  q: IQuery;
begin
  ExecQueryMS(' UPDATE SYS_PARAMS SET TECDOC_ID = TECDOC_ID + 1 ', []);
  q := makeQueryMS(' SELECT TECDOC_ID FROM SYS_PARAMS ');
  q.Open;
  Result := q.Fields[0].AsInteger;
  q.Close;
end;

function TFormMain.DecodeCodeBrand(const aCode_Brand: string; var aCode,
  aBrand: string; aMakeSearchCode: Boolean): Boolean;
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

function TFormMain.LoadReplBrands: Boolean;
var
  i, p: Integer;
  s1, s2: string;
begin
  Result := False;
  fReplBrands.Clear;
  if FileExists(GetAppDir + 'BrandRpl.txt') then
  begin
    fReplBrands.LoadFromFile(GetAppDir + 'BrandRpl.txt');
    for i := 0 to fReplBrands.Count - 1 do
    begin
      p := POS(';', fReplBrands[i]);
      s1 := Copy(fReplBrands[i], 1, p - 1);
      s2 := Copy(fReplBrands[i], p + 1, MaxInt);
      fReplBrands[i] := s2 + '=' + s1;
    end;
    Result := True;
  end;
end;


function TFormMain.GetReplBrand(const aBrand: string): string;
var
  aIndex: Integer;
begin
  aIndex := fReplBrands.IndexOfName(aBrand);
  if aIndex >= 0 then
    Result := StrGetValue(fReplBrands[aIndex])
  else
    Result := aBrand;
end;


procedure TFormMain.LoadAddPicturesBath;
var
  aRes: TStrings;
  i: Integer;
  anAddedCount: Integer;
begin
  aRes := TStringList.Create;
  try
    if TBatchSelectorForm.Execute(aRes, False, 'ПАПКИ КАРТИНОК') then
    begin
      anAddedCount := 0;
      for i := 0 to aRes.Count - 1 do
        anAddedCount := anAddedCount + LoadAddPictures(aRes[i], True);
      MessageDlg('Загружено картинок: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
    end;
  finally
    aRes.Free;
  end;
end;

procedure TFormMain.LoadAddPictures2Bath;
var
  aRes: TStrings;
  i: Integer;
  anAddedCount: Integer;
begin
  aRes := TStringList.Create;
  try
    if TBatchSelectorForm.Execute(aRes, True {FilesMode}, 'CSV для картинок', '*.csv') then
    begin
      anAddedCount := 0;
      for i := 0 to aRes.Count - 1 do
        anAddedCount := anAddedCount + LoadAddPictures2(aRes[i], True);
      MessageDlg('Загружено картинок: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
    end;
  finally
    aRes.Free;
  end;
end;

function TFormMain.LoadAddPictures(aDir: string; aSilent: Boolean): Integer;
var
  aFound: integer;
  SearchRec: TSearchRec;
  aPath, ext, nam: string;
  anAddedCount, aProcessedCount: Integer;
  code, brand: string;
begin
  Result := 0;

  if aDir = '' then
    if SelectDirectory.Execute then
      aDir := SelectDirectory.Directory
    else
      Exit;

  LoadReplBrands;

  anAddedCount := 0;
  aProcessedCount := 0;
  UpdateProgress(0, 'Дозагрузка картинок(new): 0');
  try //finally
    aPath := IncludeTrailingPathDelimiter(aDir);
    aFound := FindFirst(aPath + '*.*', faAnyFile - faDirectory, SearchRec);
    while aFound = 0 do
    begin
      ext := UpperCase(ExtractFileExt(aPath + SearchRec.Name));
      if (ext = '.JPG') or (ext = '.JP2') or (ext = '.PNG') or (ext = '.BMP') or
         (ext = '.JPEG') or (ext = '.GIF') or (ext = '.PCX') or (ext = '.WMF') then
      begin
        nam := ChangeFileExt(SearchRec.Name, '');
        if not DecodeCodeBrand(nam, code, brand) then
          Continue;

        if LoadAddPictureFromFile(aPath + SearchRec.Name, code, brand) then
          Inc(anAddedCount);
        Inc(aProcessedCount);

        if aProcessedCount mod 50 = 0 then
          UpdateProgress(0, 'Дозагрузка картинок(new): ' + IntToStr(aProcessedCount) + ' ' + brand);
      end;
      aFound := FindNext(SearchRec);
    end;
    SysUtils.FindClose(SearchRec);

  finally
    UpdateProgress(0, 'finish');
  end;
  
  if not aSilent then
    MessageDlg('Загружено картинок: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
    
  Result := anAddedCount;
end;

function TFormMain.LoadAddPictures2(aFile: string; aSilent: Boolean): Integer;
var
  anAddedCount, aProcessedCount: Integer;
  code_brand, code, brand: string;
  aFileName: string;
  aReader: TCSVReader;
begin
  Result := 0;

  if aFile = '' then
    if OpenDialog.Execute then
      aFile := OpenDialog.FileName
    else
      Exit;

  LoadReplBrands;

  anAddedCount := 0;
  aProcessedCount := 0;
  UpdateProgress(0, 'Дозагрузка картинок(new): 0');
  aReader := TCSVReader.Create;
  try //finally
    aReader.Open(aFile);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      code_brand := aReader.Fields[0];
      aFileName  := aReader.Fields[1];

      if (code_brand = '') or (aFileName = '') then
        Continue;

      if not DecodeCodeBrand(code_brand, code, brand) then
        Continue;

      //если задан относительный путь или просто имя файла, то добавляем путь откуда брали файл списка
      if (Copy(aFileName, 2, 1) <> ':') and (Copy(aFileName, 1, 2) <> '\\') then
        aFileName := ExtractFilePath(aFile) + aFileName;

      if LoadAddPictureFromFile(aFileName, code, brand) then
        Inc(anAddedCount);
      Inc(aProcessedCount);

      if aProcessedCount mod 10 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Дозагрузка картинок(new): ' + IntToStr(aProcessedCount) + ' ' + brand);
    end;
    aReader.Close;

  finally
    aReader.Free;
    UpdateProgress(0, 'finish');
  end;

  if not aSilent then
    MessageDlg('Загружено картинок: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
  Result := anAddedCount;
end;


function TFormMain.LoadAddPictureFromFile(const aPictureFileName, aCode,
  aBrand: string): Boolean;
var
  tecdoc_id, pict_id, cur_pict, id_art: Integer;
  rp, aHash: string;
  isNewRec: Boolean;
  aQuery: IQuery;
begin
  Result := False;
  if not FileExists(aPictureFileName) then
    Exit;

  rp := GetReplBrand(aBrand);

  //ищем код/бренд в артикулах
  aQuery := makeQueryMS('SELECT * FROM ART WHERE ART_LOOK = :ART_LOOK AND SUP_BRAND = :SUP_BRAND');
  aQuery.Parameters[0].Value := aCode;
  aQuery.Parameters[1].Value := rp;
  aQuery.Open;
  //нашли - забираем IDшки картинки
  if not aQuery.EOF then
  begin
    id_art := aQuery.FieldByName('ID').AsInteger;
    pict_id := aQuery.FieldByName('PICT_ID').AsInteger;
    cur_pict := aQuery.FieldByName('CUR_PICT').AsInteger;
    isNewRec := False;
  end
  else
    isNewRec := True;
  aQuery := nil;

  //не нашли - добавляем картинку в новый tecdoc_id
  if isNewRec then
  begin
    tecdoc_id := GetNewTecdocID;
    pict_id := tecdoc_id;
    cur_pict := GetNewPictID;

    //новая запись в артикулах
    ExecQueryMS(
      ' INSERT INTO ART ( ART_ID,  ART_LOOK,  SUP_BRAND,  PARAM_ID,  TYP_ID,  PICT_ID,  CUR_PICT ) ' +
      '          VALUES (:ART_ID, :ART_LOOK, :SUP_BRAND, :PARAM_ID, :TYP_ID, :PICT_ID, :CUR_PICT ) ',
      [tecdoc_id, aCode, rp, tecdoc_id, tecdoc_id, tecdoc_id, cur_pict]
    );

    //новая запись в привязках картинок
    ExecQueryMS(
      ' INSERT INTO ART_PICTS ( ART_ID,  PICT_ID,  SORT,  PICT_NR ) ' +
      '                VALUES (:ART_ID, :PICT_ID, :SORT, :PICT_NR ) ',
      [tecdoc_id, cur_pict, 0, 0]
    );

    //вычисляем хэш файла с картинкой
    aHash := md5.MD5DigestToStr( md5.MD5File(aPictureFileName) );

    //новая запись в картинках
    aQuery := makeQueryMS(
      ' INSERT INTO TD_PICTS ( PICT_ID,  PICT_DATA,  HASH ) ' +
      '               VALUES (:PICT_ID, :PICT_DATA, :HASH ) ');
    aQuery.Parameters[0].Value := cur_pict;
    aQuery.Parameters[1].LoadFromFile(aPictureFileName, ftBlob);
    aQuery.Parameters[2].Value := aHash;
    aQuery.Execute;

    Result := True;
    Exit;
  end;


  //вычисляем хэш файла с картинкой
  aHash := md5.MD5DigestToStr( md5.MD5File(aPictureFileName) );

  //берем все картинки для сета pict_id
  //сравниваем по хэшу с добавляемой
  aQuery := makeQueryMS(
    ' SELECT ART_PICTS.PICT_ID FROM ART_PICTS ' +
    ' INNER JOIN TD_PICTS ON (ART_PICTS.PICT_ID = TD_PICTS.PICT_ID) ' +
    ' WHERE ART_PICTS.ART_ID = :ART_ID AND TD_PICTS.HASH = :HASH '
  );
  aQuery.Parameters[0].Value := pict_id;
  aQuery.Parameters[1].Value := aHash;
  aQuery.Open;

  //если нашли картинку с тем же хэшем то устанавливаем ее текущей
  if not aQuery.EOF then
  begin
    if cur_pict <> aQuery.Fields[0].AsInteger then
    begin
      cur_pict := aQuery.Fields[0].AsInteger;
      ExecQueryMS(
        ' UPDATE ART SET CUR_PICT = :CUR_PICT WHERE ID = :ID ',
        [cur_pict, id_art]
      );
      Result := True;
    end;
    aQuery := nil;
  end
  else //если не нашли - добавляем в сет и устанавливаем текущей
  begin
    aQuery := nil;
    cur_pict := GetNewPictID;
    //новая запись в привязках картинок
    ExecQueryMS(
      ' INSERT INTO ART_PICTS ( ART_ID,  PICT_ID,  SORT,  PICT_NR ) ' +
      '                VALUES (:ART_ID, :PICT_ID, :SORT, :PICT_NR ) ',
      [pict_id, cur_pict, 0, 0]
    );

    //новая запись в картинках
    aQuery := makeQueryMS(
      ' INSERT INTO TD_PICTS ( PICT_ID,  PICT_DATA,  HASH ) ' +
      '               VALUES (:PICT_ID, :PICT_DATA, :HASH ) ');
    aQuery.Parameters[0].Value := cur_pict;
    aQuery.Parameters[1].LoadFromFile(aPictureFileName, ftBlob);
    aQuery.Parameters[2].Value := aHash;
    aQuery.Execute;

    //устанавливаем текущей
    ExecQueryMS(
      ' UPDATE ART SET CUR_PICT = :CUR_PICT WHERE ID = :ID ',
      [cur_pict, id_art]
    );

    Result := True;
  end;
end;


procedure TFormMain.LoadAddTDArt(fname: string; aRecognizeTecdoc, fPatrialFill: Boolean);
var
  aReader: TCSVReader;
  cntAdded: integer;
  code_brand, code, brand, rp: string;
  pict_id, typ_id, param_id, cur_pict, id_art: Integer;
  td_id_int: Integer;
  anInsert: Boolean;
  aQuery: IQuery;
  


  procedure CheckPatrialParams(fNeed2FillPrimen, fNeed2FillPicts, fNeed2FillDescr : boolean; var pict_id ,cur_pict, typ_id, param_id: integer; fFindValue: boolean);
  begin
   if (not ChBoxPicts.Checked) then
   begin
     pict_id := 0;
     cur_pict:= 0;
   end;
   if (not ChBoxPrimen.Checked) then
     typ_id  := td_id_int;
   if (not ChBoxDescr.Checked) then
     param_id:= td_id_int;
  end;

  
begin
  if fname = '' then
  begin
    if not OpenDialog.Execute then
      exit;
    fname := OpenDialog.FileName;
  end;

  //!!!в подмене бренда лежат как наши названия брендов так и тикдоковские
  //сравнивать и ложить в таблицу надо только как тикдоковские
  LoadReplBrands;

  MemLog.Clear;
  cntAdded := 0;
  UpdateProgress(0, 'Дозагрузка артикулов: 0');

{  aQuery := makeQueryMS(' SELECT MAX(ID) as Max FROM ART ');
  aQuery.Open;
  MaxID := aQuery.FieldByName('Max').AsInteger;}

  aReader := TCSVReader.Create;
  try
    aReader.Open(fname);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      code_brand  := aReader.Fields[0];

      if aRecognizeTecdoc then //во втором столбце лежит тоже КОД_БРЕНД
      begin
        DecodeCodeBrand(aReader.Fields[1], code, brand);
        rp := GetReplBrand(brand);

        //ищем код/бренд
        aQuery := makeQueryMS(
          ' SELECT ID, ART_ID FROM ART WHERE ART_LOOK = :CODE AND SUP_BRAND = :BRAND '
        );
        aQuery.Parameters[0].Value := code;
        aQuery.Parameters[1].Value := rp;
        aQuery.Open;
        if not aQuery.Eof then
          td_id_int := aQuery.FieldByName('Art_id').AsInteger
        else
          td_id_int := -1;
        aQuery.Close;
      end
      else
        td_id_int := StrToIntDef(aReader.Fields[1], -1);

      if td_id_int < 0 then
      begin
        MemLog.Lines.Append(aReader.Fields[0] + ';' + aReader.Fields[1]);
        Continue;
      end;

      DecodeCodeBrand(code_brand, code, brand);
      rp := GetReplBrand(brand);

      //ищем код/бренд
      aQuery := makeQueryMS(
        ' SELECT ID, ART_ID FROM ART WHERE ART_LOOK = :CODE AND SUP_BRAND = :BRAND '
      );
      aQuery.Parameters[0].Value := code;
      aQuery.Parameters[1].Value := rp;
      aQuery.Open;

      if aQuery.EOF then
      begin
        anInsert := True;
      end
      else
      begin //хотим перебить привязку
        anInsert := False;
        if td_id_int = aQuery.FieldByName('Art_id').AsInteger then
        begin
          if aReader.LineNum mod 10 = 0 then
            UpdateProgress(aReader.FilePosPercent, 'Дозагрузка артикулов: ' + IntToStr(cntAdded) + '/' + IntToStr(aReader.LineNum));

          Continue; //такая привязка уже добавлялась - пропускаем
        end;
        id_art := aQuery.FieldByName('ID').AsInteger;
      end;
      aQuery.Close;
      aQuery := nil;


      //ищем запись к которой хотим привязать и забираем данные
        aQuery := makeQueryMS(' SELECT pict_id, typ_id, param_id, cur_pict FROM ART WHERE ART_ID = :ART_ID ');
        aQuery.Parameters[0].Value := td_id_int;
        aQuery.Open;
        if not aQuery.EOF then
        begin
          pict_id := aQuery.FieldByName('pict_id').AsInteger;
          cur_pict:= aQuery.FieldByName('cur_pict').AsInteger;
          typ_id  := aQuery.FieldByName('typ_id').AsInteger;
          param_id:= aQuery.FieldByName('param_id').AsInteger;
        end
        else
        begin
          pict_id := 0;
          cur_pict:= 0;
          typ_id  := td_id_int;
          param_id:= td_id_int;
        end;

        aQuery.Close;
        aQuery := nil;


      if anInsert then
      begin
//        inc(MaxID);
        ExecQueryMS(
          ' INSERT INTO ART (ART_ID, ART_LOOK,  SUP_BRAND,  PARAM_ID,  TYP_ID,  PICT_ID,  CUR_PICT ) ' +
          '             VALUES (:ART_ID, :ART_LOOK, :SUP_BRAND, :PARAM_ID, :TYP_ID, :PICT_ID, :CUR_PICT ) ',
          [td_id_int, code, rp, param_id, typ_id, pict_id, cur_pict]
        );


      end
      else
        ExecQueryMS(
          ' UPDATE ART SET ART_ID = :ART_ID, ART_LOOK = :ART_LOOK, SUP_BRAND = :SUP_BRAND, PARAM_ID = :PARAM_ID, TYP_ID = :TYP_ID, PICT_ID = :PICT_ID, CUR_PICT = :CUR_PICT WHERE ID = :ID ',
          [td_id_int, code, rp, param_id, typ_id, pict_id, cur_pict, id_art]
        );

      Inc(cntAdded);
      if aReader.LineNum mod 10 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Дозагрузка артикулов: ' + IntToStr(cntAdded) + '/' + IntToStr(aReader.LineNum));
    end;
    aReader.Close;

  finally
    aReader.Free;
  end;

  MessageDlg('Загружено позиций(new): ' + IntToStr(cntAdded), mtInformation, [mbOK], 0);
end;

procedure TFormMain.LoadAddTDArt2(fname: string; aRecognizeTecdoc,
  fPatrialFill: Boolean);
var
  aReader: TCSVReader;
  cntAdded, NewTecdocID, NewPictTecdocID : integer;
  code_brand, code, brand, rp: string;
  pict_id, typ_id, param_id, cur_pict, id_art: Integer;
  td_id_int: Integer;
  anInsert: Boolean;
  aQuery: IQuery;
  td_pict_id, td_typ_id, td_param_id, td_cur_pict: Integer;


  procedure CheckPatrialParams(fNeed2FillPrimen, fNeed2FillPicts, fNeed2FillDescr : boolean; fInsert: boolean);
  const
      sSqlInsert = 'INSERT INTO ART (ART_ID, ART_LOOK,  SUP_BRAND,  PARAM_ID,  TYP_ID,  PICT_ID,  CUR_PICT ) VALUES (:ART_ID, :ART_LOOK, :SUP_BRAND, :PARAM_ID, :TYP_ID, :PICT_ID, :CUR_PICT ) ';
      sSqlUpdate = ' UPDATE ART SET PARAM_ID = :PARAM_ID, TYP_ID = :TYP_ID, PICT_ID = :PICT_ID, CUR_PICT = :CUR_PICT WHERE ID = :ID ';
  var
    SQL: string;
    arOfVariant: array of Variant;

  begin
    if not fInsert then // для выбора инструкции
      SQL := sSqlUpdate
    else
      SQL := sSqlInsert;

    if not fInsert then //если не новая запись, то проверяем что нужно обновлять
    begin
      SetLength(arOfVariant, 0);
      if not fNeed2FillDescr then // далее проверяем по плану были ли выбраны поля для обновления
        SQL := StringReplace(SQL, 'PARAM_ID = :PARAM_ID, ', '', [rfReplaceAll])
      else
      begin
         SetLength(arOfVariant, length(arOfVariant) + 1);
         arOfVariant[length(arOfVariant)-1] := td_param_id;
      end;

      if not fNeed2FillPrimen then
        SQL := StringReplace(SQL, 'TYP_ID = :TYP_ID, ', '', [rfReplaceAll])
      else
      begin
        SetLength(arOfVariant, length(arOfVariant) + 1);
        arOfVariant[length(arOfVariant)-1] := td_typ_id;
      end;

      // далее проверяем по плану были ли выбраны поля для обновления
      if not fNeed2FillPicts then
      begin
        SQL := StringReplace(SQL, ', PICT_ID = :PICT_ID, CUR_PICT = :CUR_PICT', '', [rfReplaceAll]);
        SQL := StringReplace(SQL, 'PICT_ID = :PICT_ID, CUR_PICT = :CUR_PICT', '', [rfReplaceAll]);
      end
      else
      begin
        SetLength(arOfVariant, length(arOfVariant) + 1);
        arOfVariant[length(arOfVariant)-1] := td_pict_id;
        SetLength(arOfVariant, length(arOfVariant) + 1);
        arOfVariant[length(arOfVariant)-1] := td_cur_pict;
      end;

      //при update добавляем последний парамметр id_art
    //  SQL := StringReplace(SQL, ', WHERE', ' WHERE', [rfReplaceAll]);
      SetLength(arOfVariant, length(arOfVariant) + 1);
      arOfVariant[length(arOfVariant)-1] := id_art;
    end

    else //если новая, то в любом случае необходимо заполнить применяемость и описание
    begin
      //обязателньо все импортить из-за применяемости и доп.параметров
      SetLength(arOfVariant, 7);
      arOfVariant[0] := td_id_int;
      arOfVariant[1] := code;
      arOfVariant[2] := rp;

      //если хотябы 1 привязка не выбрана генерируем новый TEcDoc ID
      if (not fNeed2FillDescr) or (not fNeed2FillDescr) or (not fNeed2FillDescr) then
        NewTecdocID := GetNewTecdocID;

      if not fNeed2FillDescr then // далее проверяем по плану были ли выбраны поля для обновления
        arOfVariant[3] := NewTecdocID
      else
        arOfVariant[3] := td_param_id;

      if not fNeed2FillPrimen then
         arOfVariant[4] := NewTecdocID
      else
         arOfVariant[4] := td_typ_id;


      if not fNeed2FillPicts then
      begin
 {походу не надо}
 //генерируем новый pict_id
//        NewTecdocID := GetNewPictID;
        arOfVariant[5] := NewTecdocID;
        arOfVariant[5] := 0;
      end
      else
      begin
        arOfVariant[5] := td_pict_id;
        arOfVariant[6] := td_cur_pict; //всегда зануляем cur_pict (проставится во время заливки картинки
      end;  
    end;

    ExecQueryMS(SQL, arOfVariant);
    SetLength(arOfVariant, 0);
  end;



begin
  //формат файла {код_бренд к чему вязать; код_бренд что вязать}
  if fname = '' then
  begin
    if not OpenDialog.Execute then
      exit;
    fname := OpenDialog.FileName;
  end;

  //!!!в подмене бренда лежат как наши названия брендов так и тикдоковские
  //сравнивать и ложить в таблицу надо только как тикдоковские
  LoadReplBrands;

  MemLog.Clear;
  cntAdded := 0;
  id_art := 0;
  UpdateProgress(0, 'Дозагрузка артикулов: 0');

  aReader := TCSVReader.Create;
  try
    aReader.Open(fname);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      code_brand  := aReader.Fields[0];

      if aRecognizeTecdoc then //во втором столбце лежит тоже КОД_БРЕНД
      begin
        DecodeCodeBrand(aReader.Fields[1], code, brand);
        rp := GetReplBrand(brand);

        //ищем код/бренд
        aQuery := makeQueryMS(
          ' SELECT ID, ART_ID, cur_pict, pict_id, typ_id, param_id FROM ART WHERE ART_LOOK = :CODE AND SUP_BRAND = :BRAND '
        );
        aQuery.Parameters[0].Value := code;
        aQuery.Parameters[1].Value := rp;
        aQuery.Open;
        if not aQuery.Eof then
        begin
          td_pict_id := aQuery.FieldByName('pict_id').AsInteger;
          td_typ_id :=  aQuery.FieldByName('typ_id').AsInteger;
          td_param_id := aQuery.FieldByName('param_id').AsInteger;
          td_cur_pict := aQuery.FieldByName('cur_pict').AsInteger;
          td_id_int := aQuery.FieldByName('Art_id').AsInteger;
        end
        else
          td_id_int := -1;
        aQuery.Close;
      end;
//      else
//        td_id_int := StrToIntDef(aReader.Fields[1], -1);

      if td_id_int < 0 then
      begin
        MemLog.Lines.Append(aReader.Fields[0] + ';' + aReader.Fields[1]);
        Continue;
      end;


      DecodeCodeBrand(code_brand, code, brand);
      rp := GetReplBrand(brand);
      //ищем код/бренд
      aQuery := makeQueryMS(
        ' SELECT ID, ART_ID FROM ART WHERE ART_LOOK = :CODE AND SUP_BRAND = :BRAND '
      );
      aQuery.Parameters[0].Value := code;
      aQuery.Parameters[1].Value := rp;
      aQuery.Open;
      if aQuery.EOF then
        anInsert := True
      else
      begin //хотим перебить привязку
        anInsert := False;
        id_art := aQuery.FieldByName('ID').AsInteger;
      end;
      aQuery.Close;
      aQuery := nil;

      //Здесь выполняеся основная логика + выполнение Insert или Update
      CheckPatrialParams(ChBoxPrimen.Checked, ChBoxPicts.Checked, ChBoxDescr.Checked, anInsert);

      Inc(cntAdded);
      if aReader.LineNum mod 10 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Дозагрузка артикулов: ' + IntToStr(cntAdded) + '/' + IntToStr(aReader.LineNum));
    end;

    aReader.Close;
  finally
    aReader.Free;
  end;

  MessageDlg('Загружено позиций(new): ' + IntToStr(cntAdded), mtInformation, [mbOK], 0);
end;

procedure TFormMain.LoadAddTDParamBath;
var
  aRes: TStrings;
  i: Integer;
  anAddedCount: Integer;
begin
  aRes := TStringList.Create;
  try
    if TBatchSelectorForm.Execute(aRes, True {FilesMode}, 'Доп. параметры - таблица', '*.csv') then
    begin
      anAddedCount := 0;
      for i := 0 to aRes.Count - 1 do
        anAddedCount := anAddedCount + LoadAddTDParam(aRes[i], True);
      MessageDlg('Загружено параметров: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
    end;
  finally
    aRes.Free;
  end;
end;

function TFormMain.LoadAddTDParam(fname: string; aSilent: Boolean): Integer;

  //находит параметр по имени (или добавляет, если такого еще нет)
  function GetParamIdByName(const aParamName: string): Integer;
  var
    s: string;
  begin
    s := ExecuteSimpleSelectMS(' SELECT PARAM_ID FROM TD_PARAMS WHERE DESCR = :DESCR ', [aParamName]);
    if s = '' then
    begin
      s := ExecuteSimpleSelectMS(' SELECT MAX(PARAM_ID) FROM TD_PARAMS ', []);
      Result := StrToIntDef(s, 0) + 1; //get next ID
      ExecQueryMS(
        ' INSERT INTO TD_PARAMS (PARAM_ID, DESCR, DESCRIPTION) VALUES (:PARAM_ID, :DESCR, :DESCRIPTION) ',
        [Result, Copy(aParamName, 1, 32), Copy(aParamName, 1, 128)]
      );
    end
    else
      Result := StrToIntDef(s, 0);
  end;

var
  cnt: integer;
  tecdoc_id, srt, id_art: integer;
  code_brand, code, brand, rp,
  param_str, param_name, param_value, s: string;
  lFound: boolean;

  aParamID, aParamSetID: Integer;
  aFirstTecdocID: Integer;
  aReader: TCSVReader;
  aQuery: IQuery;

  aDeleteList: TStrings;
begin
  Result := 0;

  if fname = '' then
  begin
    if not OpenDialog.Execute then
      exit;
    fname := OpenDialog.FileName;
  end;

  LoadReplBrands;

  aFirstTecdocID := StrToIntDef( ExecuteSimpleSelectMS(' SELECT TECDOC_ID FROM SYS_PARAMS ', []), 0);

  cnt := 0;
  UpdateProgress(0, 'Дозагрузка подробностей(new)');
  aReader := TCSVReader.Create;
  aDeleteList := TStringList.Create;
  try //finally
    aReader.Open(fname);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      code_brand  := aReader.Fields[0];
      if not DecodeCodeBrand(code_brand, code, brand) then
        continue;

      param_str   := aReader.Fields[1];
      param_name  := StrGetName(param_str);
      param_value := StrGetValue(param_str);
      rp := GetReplBrand(brand);

      //ищем в артикулах код/бренд
      aQuery := makeQueryMS(
        ' SELECT ID, ART_ID, PARAM_ID FROM ART WHERE ART_LOOK = :CODE AND SUP_BRAND = :BRAND '
      );
      aQuery.Parameters[0].Value := code;
      aQuery.Parameters[1].Value := rp;
      aQuery.Open;

      //не нашли - добавляем
      if aQuery.EOF then
      begin
        aQuery := nil;
        tecdoc_id := GetNewTecdocID;

        ExecQueryMS(
          ' INSERT INTO ART ( ART_ID,  ART_LOOK,  SUP_BRAND,  PARAM_ID,  TYP_ID,  PICT_ID,  CUR_PICT ) ' +
          '          VALUES (:ART_ID, :ART_LOOK, :SUP_BRAND, :PARAM_ID, :TYP_ID, :PICT_ID, :CUR_PICT ) ',
          [tecdoc_id, code, rp, tecdoc_id, tecdoc_id, tecdoc_id, 0]
        );

        aParamSetID := tecdoc_id;
      end
      else //нашли - нужно добавить новую группу параметров, но
      begin
        aParamSetID := aQuery.FieldByName('PARAM_ID').AsInteger;
        id_art := aQuery.FieldByName('ID').AsInteger;
        aQuery := nil;
        //если еще не добавляли tecdoc_id для этого кода/бренда в этом файле
        if aParamSetID <= 5000000 {FirstTecdocID} then
        begin
          aParamSetID := GetNewTecdocID;
          ExecQueryMS(
            ' UPDATE ART SET PARAM_ID = :PARAM_ID WHERE ID = :ID ',
            [aParamSetID, id_art]
          );
          //tecdoc_id оставляем тот же
        end;
      end;

      //находим или добавляем параметр, если такого еще нет
      aParamID := GetParamIdByName(param_name);

      //заливаем значения параметров - добавляем в текущий набор
      //нужно ли заменять значение если имя параметра совпадает???

      //удаляем все параметры для art_id (если еще не удаляли)
      if aDeleteList.IndexOf(code + '_' + brand) = -1 then
      begin
        aDeleteList.Add(code + '_' + brand);
        ExecQueryMS(' DELETE FROM TD_DETAILS WHERE ART_ID = :ART_ID ', [aParamSetID]);
      end;


      //select Max(SORT) from td_details where art_id = :art_id
      //select * from td_details where art_id = :art_id
      lFound := ExecuteSimpleSelectMS(
        'select art_id from TD_DETAILS where art_id = :art_id AND PARAM_ID = :PARAM_ID ' ,
        [aParamSetID, aParamID]
      ) <> '';
      if not lFound then
      begin
        s := ExecuteSimpleSelectMS(' select Max(SORT) from TD_DETAILS where art_id = :art_id ', [aParamSetID]);
        srt := StrToIntDef(s, -1) + 1;
        ExecQueryMS(
          ' INSERT INTO TD_DETAILS ( ART_ID,  SORT,  PARAM_ID,  PARAM_VALUE) ' +
          '                 VALUES (:ART_ID, :SORT, :PARAM_ID, :PARAM_VALUE) ',
          [aParamSetID, srt, aParamID, Copy(param_value, 1, 128)]
        );
        Inc(cnt);
      end;

      UpdateProgress(aReader.FilePosPercent);
    end;
    aReader.Close;

    //чистка мусора - удаляем старые параметры если на них никто не ссылается
//    Database.Execute('DELETE FROM [014] WHERE Tecdoc_id NOT IN ( SELECT param_id FROM [110] )');
  finally
    aDeleteList.Free;
    aReader.Free;
    UpdateProgress(0, 'finish');
  end;

  if not aSilent then
    MessageDlg('Загружено позиций(new): ' + IntToStr(cnt), mtInformation, [mbOK], 0);
  Result := cnt;
end;

procedure TFormMain.LoadAddTDPrimenBath;
var
  aRes: TStrings;
  i: Integer;
  anAddedCount: Integer;
begin
  aRes := TStringList.Create;
  try
    if TBatchSelectorForm.Execute(aRes, True {FilesMode}, 'Применяемость', '*.csv') then
    begin
      anAddedCount := 0;
      for i := 0 to aRes.Count - 1 do
        anAddedCount := anAddedCount + LoadAddTDPrimen(aRes[i], True);
      MessageDlg('Загружено позиций: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
    end;
  finally
    aRes.Free;
  end;
end;

function TFormMain.LoadAddTDPrimen(fname: string; aSilent: Boolean): Integer;
var
  anAddedCount: Integer;
  tecdoc_id, typ_id, id_art: integer;
  s, code_brand, code, brand, rp: string;
  lFound: boolean;
  TypSetID: Integer;
  aReader: TCSVReader;
  aFirstTecdocID: Integer;
  aQuery: IQuery;
begin
  Result := 0;
  
  if fname = '' then
    if OpenDialog.Execute then
      fname := OpenDialog.FileName
    else
      Exit;

  LoadReplBrands;
  anAddedCount := 0;

  //применяемость идет несортированная, используем aFirstTecdocID чтобы знать
  //добавлялся ли новый tecdoc_id для группы типов
  aFirstTecdocID := StrToIntDef( ExecuteSimpleSelectMS(' SELECT TECDOC_ID FROM SYS_PARAMS ', []), 0);

  UpdateProgress(0, 'Дозагрузка применяемости');
  aReader := TCSVReader.Create;
  try //finally
    aReader.Open(fname);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      code_brand  := aReader.Fields[0];
      if not DecodeCodeBrand(code_brand, code, brand) then
        Continue;

      typ_id := StrToIntDef(aReader.Fields[1], -1);
      rp := GetReplBrand(brand);

      //ищем в артикулах код/бренд
      aQuery := makeQueryMS(
        ' SELECT ID, ART_ID, TYP_ID FROM ART WHERE ART_LOOK = :CODE AND SUP_BRAND = :BRAND '
      );
      aQuery.Parameters[0].Value := code;
      aQuery.Parameters[1].Value := rp;
      aQuery.Open;

      //не нашли - добавляем
      if aQuery.EOF then
      begin
        aQuery := nil;
        tecdoc_id := GetNewTecdocID;

        ExecQueryMS(
          ' INSERT INTO ART ( ART_ID,  ART_LOOK,  SUP_BRAND,  PARAM_ID,  TYP_ID,  PICT_ID,  CUR_PICT ) ' +
          '          VALUES (:ART_ID, :ART_LOOK, :SUP_BRAND, :PARAM_ID, :TYP_ID, :PICT_ID, :CUR_PICT ) ',
          [tecdoc_id, code, rp, tecdoc_id, tecdoc_id, tecdoc_id, 0]
        );

        TypSetID := tecdoc_id;
      end
      else //нашли - заводим новый ID для набора применяемости, но
      begin
        TypSetID := aQuery.FieldByName('TYP_ID').AsInteger;
        id_art := aQuery.FieldByName('ID').AsInteger;
        aQuery := nil;
        //если еще не добавляли tecdoc_id для этого кода/бренда в этом файле
        if TypSetID <= aFirstTecdocID then
        begin
          TypSetID := GetNewTecdocID;
          ExecQueryMS(
            ' UPDATE ART SET TYP_ID = :TYP_ID WHERE ID = :ID ',
            [TypSetID, id_art]
          );
          //tecdoc_id оставляем тот же
        end;
      end;

      //добавляем ссылку на тип, если такого еще нет
      begin
        s := ExecuteSimpleSelectMS(
          ' SELECT ID FROM ART_TYP WHERE ART_ID = :ART_ID AND TYP_ID = :TYP_ID ',
          [TypSetID, typ_id]
        );
        lFound := s <> '';

        if not lFound then
        begin
          ExecQueryMS(
            ' INSERT INTO ART_TYP ( ART_ID,  TYP_ID) ' +
            '              VALUES (:ART_ID, :TYP_ID) ',
            [TypSetID, typ_id]
          );
          Inc(anAddedCount);
        end;
      end;

       UpdateProgress(aReader.FilePosPercent);
    end;
    aReader.Close;

    //чистка мусора - удаляем записи на кот. никто не ссылается
//    Database.Execute('DELETE FROM [023] WHERE art_id NOT IN ( SELECT typ_id FROM [110] )');
  finally
    aReader.Free;
    UpdateProgress(0, 'finish'); 
  end;

  if not aSilent then
    MessageDlg('Загружено позиций(new): ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
  Result := anAddedCount;
end;

procedure TFormMain.LoadDescriptionBath;
var
  aRes: TStrings;
  i: Integer;
  anAddedCount: Integer;
begin
  aRes := TStringList.Create;
  try
    if TBatchSelectorForm.Execute(aRes, True {FilesMode}, 'Описания', '*.csv') then
    begin
      anAddedCount := 0;
      for i := 0 to aRes.Count - 1 do
        anAddedCount := anAddedCount + LoadDescription(aRes[i], True);
      MessageDlg('Загружено позиций: ' + IntToStr(anAddedCount), mtInformation, [mbOK], 0);
    end;
  finally
    aRes.Free;
  end;
end;                               

function TFormMain.LoadDescription(sFileName: string;
  aSilent: Boolean): Integer;
var
  sCode, sBrand, sDescription, aDescr: string;
  aQuery: IQuery;
  anID: Integer;
  aReader: TCSVReader;
begin
  Result := 0;

  if sFileName = '' then
    if OpenDialog.Execute then
      sFileName := OpenDialog.FileName
    else
      Exit;

  UpdateProgress(0, 'Загрузка описаний...');
//  DBConnect;
  aReader := TCSVReader.Create;
  try
    aReader.Open(sFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;

      if not DecodeCodeBrand(aReader.Fields[0], sCode, sBrand) then
        Continue;

      UpdateProgress(aReader.FilePosPercent, 'Загрузка описаний... ' + sBrand);

      sDescription := aReader.Fields[1];
      if SameText(sDescription, 'DELETE') then
        ExecQueryMS(' DELETE FROM [DESCRIPTIONS] WHERE CODE = :CODE AND BRAND = :BRAND ', [sCode, sBrand])
      else
      begin
        aQuery := makeQueryMS(' SELECT ID, DESCRIPTION FROM [DESCRIPTIONS] WHERE CODE = :CODE AND BRAND = :BRAND ');
        aQuery.Parameters[0].Value := sCode;
        aQuery.Parameters[1].Value := sBrand;
        aQuery.Open;
        if not aQuery.EOF then
        begin
          anID := aQuery.FieldByName('ID').AsInteger;
          aDescr := aQuery.FieldByName('DESCRIPTION').AsString + #13 + sDescription;
          aQuery := nil;
          ExecQueryMS(' UPDATE [DESCRIPTIONS] SET DESCRIPTION = :DESCRIPTION WHERE ID = :ID ',
                      [aDescr, anID]);
        end
        else
        begin
          aQuery := nil;
          ExecQueryMS(' INSERT INTO [DESCRIPTIONS] ( CODE,  BRAND,  DESCRIPTION) '+
                      '                     VALUES (:CODE, :BRAND, :DESCRIPTION)',
                      [sCode, sBrand, sDescription]);
        end;
        Inc(Result);
      end;
    end;
    aReader.Close;

  finally
    aReader.Free;
//    DBDisconnect;
    UpdateProgress(0, 'finish');
  end;

  if not aSilent then
    MessageDlg('Загрузка завершена', mtInformation, [mbOk], 0);
end;


procedure TFormMain.btAddAllFromServiceClick(Sender: TObject);
var
  aDBIPath: string;
  aQuery: IQuery;
  id_art: Integer;
  aCountInserted, aCountUpdated: Integer;
  aTable: TDBISamTable;
  aStream: TMemoryStream;
begin
  //нужно получить IDшки дозаливок такие же как в сервисной
  //до этого !ОБЯЗАТЕЛЬНО! выполнить дозагрузку артикулов

  if SelectDirectory.Execute then
    aDBIPath := SelectDirectory.Directory
  else
    Exit;

  DBISAMDB.Directory := aDBIPath;
  DBISAMDB.Open;
  DBConnect;

  try
{*** params ***}

    //1. переносим все из 014 в TD_DETAILS, если ART_ID >= 5000000
{    UpdateProgress(0, 'переносим все из 014 в TD_DETAILS');
    insertQuery.CommandText :=
      ' INSERT INTO TD_DETAILS ( ART_ID,  SORT,  PARAM_ID,  PARAM_VALUE) ' +
      '                 VALUES (:ART_ID, :SORT, :PARAM_ID, :PARAM_VALUE) ';
    insertQuery.Prepared := True;

    DBIQuery.SQL.Text := ' SELECT * FROM [014] WHERE TECDOC_ID >= 5000000 ';
    DBIQuery.Open;
    while not DBIQuery.Eof do
    begin
      insertQuery.Parameters[0].Value := DBIQuery.FieldByName('Tecdoc_id').Value;
      insertQuery.Parameters[1].Value := DBIQuery.FieldByName('Sort').Value;
      insertQuery.Parameters[2].Value := DBIQuery.FieldByName('param_id').Value;
      insertQuery.Parameters[3].Value := DBIQuery.FieldByName('param_value').AsString;
      insertQuery.Execute;

      DBIQuery.Next;
      if DBIQuery.EOF or (DBIQuery.RecNo mod 100 = 0) then
        UpdateProgress(0, 'переносим все из 014 в TD_DETAILS: ' + IntToStr(DBIQuery.RecNo) + ' из ' + IntToStr(DBIQuery.RecordCount));
    end;
    DBIQuery.Close;    }

    //2. переносим все из 015 в TD_PARAMS, если PARAM_ID > 1510
    UpdateProgress(0, 'переносим все из 015 в TD_PARAMS');
    insertQuery.CommandText :=
      ' INSERT INTO TD_PARAMS ( PARAM_ID,  DESCR,  DESCRIPTION) ' +
      '                VALUES (:PARAM_ID, :DESCR, :DESCRIPTION) ';
    insertQuery.Prepared := True;

    DBIQuery.SQL.Text := ' SELECT * FROM [015] WHERE PARAM_ID > 1510 ';
    DBIQuery.Open;
    while not DBIQuery.Eof do
    begin
      insertQuery.Parameters[0].Value := DBIQuery.FieldByName('PARAM_ID').Value;
      insertQuery.Parameters[1].Value := DBIQuery.FieldByName('DESCR').Value;
      insertQuery.Parameters[2].Value := DBIQuery.FieldByName('DESCRIPTION').Value;
      insertQuery.Execute;

      DBIQuery.Next;
      if DBIQuery.EOF or (DBIQuery.RecNo mod 100 = 0) then
        UpdateProgress(0, 'переносим все из 015 в TD_PARAMS: ' + IntToStr(DBIQuery.RecNo) + ' из ' + IntToStr(DBIQuery.RecordCount));
    end;
    DBIQuery.Close;


{*** types ***}
    //3. переносим все из 023 в ART_TYP, если ART_ID >= 5000000
    UpdateProgress(0, 'переносим все из 023 в ART_TYP');
    insertQuery.CommandText :=
      ' INSERT INTO ART_TYP (ART_ID, TYP_ID) VALUES ( :ART_ID, :TYP_ID ) ';
    insertQuery.Prepared := True;

    DBIQuery.SQL.Text := ' SELECT * FROM [023] WHERE ART_ID >= 5000000 ';
    DBIQuery.Open;
    while not DBIQuery.Eof do
    begin
      insertQuery.Parameters[0].Value := DBIQuery.FieldByName('ART_ID').Value;
      insertQuery.Parameters[1].Value := DBIQuery.FieldByName('TYP_ID').Value;
      insertQuery.Execute;

      DBIQuery.Next;
      if DBIQuery.EOF or (DBIQuery.RecNo mod 100 = 0) then
        UpdateProgress(0, 'переносим все из 023 в ART_TYP: ' + IntToStr(DBIQuery.RecNo) + ' из ' + IntToStr(DBIQuery.RecordCount));
    end;
    DBIQuery.Close;


{*** picts ***}
    //4. переносим все из 027 в TD_PICTS, если PICT_ID >= 5000000
    UpdateProgress(0, 'переносим все из 027 в TD_PICTS');
    insertQuery.CommandText :=
      ' INSERT INTO TD_PICTS ( PICT_ID,  PICT_DATA) ' +
      '               VALUES (:PICT_ID, :PICT_DATA) ';
    insertQuery.Prepared := True;

    aTable := TDBISamTable.Create(nil);
    aStream := TMemoryStream.Create;
    try
      aTable.DatabaseName := DBISAMDB.DatabaseName;
      aTable.TableName := '027';
      aTable.Open;
      while not aTable.Eof do
      begin
        if aTable.FieldByName('PICT_ID').AsInteger >= 5000000 then
        begin
          insertQuery.Parameters[0].Value := aTable.FieldByName('PICT_ID').Value;
          TBlobField(aTable.FieldByName('PICT_DATA')).SaveToStream(aStream);
          insertQuery.Parameters[1].LoadFromStream(aStream, ftBlob);
          aStream.Clear;
          insertQuery.Execute;
        end;

        aTable.Next;
        if aTable.EOF or (aTable.RecNo mod 100 = 0) then
          UpdateProgress(0, 'переносим все из 027 в TD_PICTS: ' + IntToStr(aTable.RecNo) + ' из ' + IntToStr(aTable.RecordCount));
      end;
      aTable.Close;
    finally
      aStream.Free;
      aTable.Free;
    end;
 (*
//    DBIQuery.SQL.Text := ' SELECT * FROM [027] WHERE PICT_ID >= 5000000 ';
//    DBIQuery.Open;
//    while not DBIQuery.Eof do
//    begin
//      insertQuery.Parameters[0].Value := DBIQuery.FieldByName('PICT_ID').Value;
//      insertQuery.Parameters[1].Value := DBIQuery.FieldByName('PICT_DATA').Value;
//      insertQuery.Execute;
//
//      DBIQuery.Next;
//      if DBIQuery.EOF or (DBIQuery.RecNo mod 100 = 0) then
//        UpdateProgress(0, 'переносим все из 027 в TD_PICTS: ' + IntToStr(DBIQuery.RecNo) + ' из ' + IntToStr(DBIQuery.RecordCount));
//    end;
//    DBIQuery.Close;


{*** art ***}
    CacheARTEx('', memART, True);
    memART.IndexName := 'look';
    memART.Open;

    aCountInserted := 0;
    aCountUpdated := 0;
    //5. переносим все из 110 в ART
    UpdateProgress(0, 'переносим все из 110 в ART');
    insertQuery.CommandText :=
      ' INSERT INTO ART ( ART_ID,  ART_LOOK,  SUP_BRAND,  PARAM_ID,  TYP_ID,  PICT_ID,  CUR_PICT ) ' +
      '          VALUES (:ART_ID, :ART_LOOK, :SUP_BRAND, :PARAM_ID, :TYP_ID, :PICT_ID, :CUR_PICT ) ';
    insertQuery.Prepared := True;

    aTable := TDBISamTable.Create(nil);
    try
      aTable.DatabaseName := DBISAMDB.DatabaseName;
      aTable.TableName := '110';
      aTable.Open;
    while not aTable.Eof do
    begin
      //записи нет - либо ART_ID > 5000000 либо это наша перебивка
      if not memART.FindKey([aTable.FieldByName('ART_ID').AsInteger, aTable.FieldByName('ART_LOOK').AsString, AnsiUpperCase(aTable.FieldByName('SUP_BRAND').AsString)]) then
      begin
        insertQuery.Parameters[0].Value := aTable.FieldByName('ART_ID').Value;
        insertQuery.Parameters[1].Value := aTable.FieldByName('ART_LOOK').Value;
        insertQuery.Parameters[2].Value := aTable.FieldByName('SUP_BRAND').Value;
        insertQuery.Parameters[3].Value := aTable.FieldByName('PARAM_ID').Value;
        insertQuery.Parameters[4].Value := aTable.FieldByName('TYP_ID').Value;
        insertQuery.Parameters[5].Value := aTable.FieldByName('ART_ID').Value;
        insertQuery.Parameters[6].Value := aTable.FieldByName('PICT_ID').Value;
        insertQuery.Execute;
        Inc(aCountInserted);

        //если задана картинка, то добавить привязку картинки к ART.PICT_ID в ART_PICTS
        if aTable.FieldByName('PICT_ID').AsInteger > 0 then
        begin
          //привязка картинки уже может существовать если это наша перебивка артикула
          if ExecuteSimpleSelectMS(' SELECT ID FROM ART_PICTS WHERE ART_ID = :ART_ID AND PICT_ID = :PICT_ID ', [aTable.FieldByName('ART_ID').Value, aTable.FieldByName('PICT_ID').Value]) = '' then
          begin

            ExecQueryMS(
              ' INSERT INTO ART_PICTS ( ART_ID,  PICT_ID,  SORT,  PICT_NR) ' +
              '                VALUES (:ART_ID, :PICT_ID, :SORT, :PICT_NR) ',
              [aTable.FieldByName('ART_ID').Value, aTable.FieldByName('PICT_ID').Value, 0, aTable.FieldByName('PICT_NR').Value]
            );

          end;
        end;
      end
      else //запись есть - сверяем поля насчет перебивок параметров, типов или картинок
      begin
        if ((memART.FieldByName('PARAM_ID').AsInteger <> aTable.FieldByName('PARAM_ID').AsInteger) and (aTable.FieldByName('PARAM_ID').AsInteger > 0)) or
           ((memART.FieldByName('TYP_ID').AsInteger <> aTable.FieldByName('TYP_ID').AsInteger) and (aTable.FieldByName('TYP_ID').AsInteger > 0)) or
           ((memART.FieldByName('CUR_PICT').AsInteger <> aTable.FieldByName('PICT_ID').AsInteger) and (aTable.FieldByName('PICT_ID').AsInteger > 0)) then
        begin
          id_art := memArt.FieldByName('ID').AsInteger;

          //UPDATE

          ExecQueryMS(
            ' UPDATE ART SET PARAM_ID = :PARAM_ID, TYP_ID = :TYP_ID, PICT_ID = :PICT_ID, CUR_PICT = :CUR_PICT WHERE ID = :ID ',
            [aTable.FieldByName('PARAM_ID').Value, aTable.FieldByName('TYP_ID').Value, aTable.FieldByName('ART_ID').Value, aTable.FieldByName('PICT_ID').Value, id_art]
          );

          Inc(aCountUpdated);

          //привязка картинки уже может существовать если это наша перебивка артикула
          if ExecuteSimpleSelectMS(' SELECT ID FROM ART_PICTS WHERE ART_ID = :ART_ID AND PICT_ID = :PICT_ID ', [aTable.FieldByName('ART_ID').Value, aTable.FieldByName('PICT_ID').Value]) = '' then
          begin

            ExecQueryMS(
              ' INSERT INTO ART_PICTS ( ART_ID,  PICT_ID,  SORT,  PICT_NR) ' +
              '                VALUES (:ART_ID, :PICT_ID, :SORT, :PICT_NR) ',
              [aTable.FieldByName('ART_ID').Value, aTable.FieldByName('PICT_ID').Value, 0, aTable.FieldByName('PICT_NR').Value]
            );
            
          end;
        end;
      end;

      aTable.Next;
      if aTable.EOF or (aTable.RecNo mod 100 = 0) then
        UpdateProgress(0, 'переносим все из 110 в ART: ' + IntToStr(aTable.RecNo) + ' из ' + IntToStr(aTable.RecordCount));
      if fAborted then
        Break;  
    end;
    aTable.Close;
    finally
      aTable.Free;
    end;
 
    ShowMessage(Format('Добавлено в ART: %d'#13#10'Обновлено в ART: %d', [aCountInserted, aCountUpdated]));
*)
  finally
    DBISAMDB.Close;
    DBDisconnect;
  end;


(*
    aCountInserted := 0;
    aCountUpdated := 0;
    //5. переносим все из 110 в ART
    UpdateProgress(0, 'переносим все из 110 в ART');
    insertQuery.CommandText :=
      ' INSERT INTO ART ( ART_ID,  ART_LOOK,  SUP_BRAND,  PARAM_ID,  TYP_ID,  PICT_ID,  CUR_PICT ) ' +
      '          VALUES (:ART_ID, :ART_LOOK, :SUP_BRAND, :PARAM_ID, :TYP_ID, :PICT_ID, :CUR_PICT ) ';
    insertQuery.Prepared := True;

    aTable := TDBISamTable.Create(nil);
    try
      aTable.DatabaseName := DBISAMDB.DatabaseName;
      aTable.TableName := '110';
      aTable.Open;
      while not aTable.Eof do
    begin
      aQuery := makeQueryMS(
        ' SELECT * FROM ART ' +
        ' WHERE ART_ID = :ART_ID AND ART_LOOK = :ART_LOOK AND SUP_BRAND = :SUP_BRAND '
      );
      aQuery.Parameters[0].Value := aTable.FieldByName('ART_ID').Value;
      aQuery.Parameters[1].Value := aTable.FieldByName('ART_LOOK').Value;
      aQuery.Parameters[2].Value := aTable.FieldByName('SUP_BRAND').Value;
      aQuery.Open;
      //записи нет - либо ART_ID > 5000000 либо это наша перебивка
      if aQuery.EOF then
      begin
        aQuery := nil;
        insertQuery.Parameters[0].Value := aTable.FieldByName('ART_ID').Value;
        insertQuery.Parameters[1].Value := aTable.FieldByName('ART_LOOK').Value;
        insertQuery.Parameters[2].Value := aTable.FieldByName('SUP_BRAND').Value;
        insertQuery.Parameters[3].Value := aTable.FieldByName('PARAM_ID').Value;
        insertQuery.Parameters[4].Value := aTable.FieldByName('TYP_ID').Value;
        insertQuery.Parameters[5].Value := aTable.FieldByName('ART_ID').Value;
        insertQuery.Parameters[6].Value := aTable.FieldByName('PICT_ID').Value;
        //insertQuery.Execute;
        Inc(aCountInserted);

        //если задана картинка, то добавить привязку картинки к ART.PICT_ID в ART_PICTS
        if aTable.FieldByName('PICT_ID').AsInteger > 0 then
        begin
          //привязка картинки уже может существовать если это наша перебивка артикула
          if ExecuteSimpleSelectMS(' SELECT ID FROM ART_PICTS WHERE ART_ID = :ART_ID AND PICT_ID = :PICT_ID ', [aTable.FieldByName('ART_ID').Value, aTable.FieldByName('PICT_ID').Value]) = '' then
          begin
            {
            ExecQueryMS(
              ' INSERT INTO ART_PICTS ( ART_ID,  PICT_ID,  SORT,  PICT_NR) ' +
              '                VALUES (:ART_ID, :PICT_ID, :SORT, :PICT_NR) ',
              [aTable.FieldByName('ART_ID').Value, aTable.FieldByName('PICT_ID').Value, 0, aTable.FieldByName('PICT_NR').Value]
            );
            }
          end;
        end;
      end
      else //запись есть - сверяем поля насчет перебивок параметров, типов или картинок
      begin
        if ((aQuery.FieldByName('PARAM_ID').AsInteger <> aTable.FieldByName('PARAM_ID').AsInteger) and (aTable.FieldByName('PARAM_ID').AsInteger > 0)) or
           ((aQuery.FieldByName('TYP_ID').AsInteger <> aTable.FieldByName('TYP_ID').AsInteger) and (aTable.FieldByName('TYP_ID').AsInteger > 0)) or
           ((aQuery.FieldByName('CUR_PICT').AsInteger <> aTable.FieldByName('PICT_ID').AsInteger) and (aTable.FieldByName('PICT_ID').AsInteger > 0)) then
        begin
          id_art := aQuery.FieldByName('ID').AsInteger;
          aQuery := nil;

          //UPDATE
          {
          ExecQueryMS(
            ' UPDATE ART SET PARAM_ID = :PARAM_ID, TYP_ID = :TYP_ID, PICT_ID = :PICT_ID, CUR_PICT = :CUR_PICT WHERE ID = :ID ',
            [aTable.FieldByName('PARAM_ID').Value, aTable.FieldByName('TYP_ID').Value, aTable.FieldByName('ART_ID').Value, aTable.FieldByName('PICT_ID').Value, id_art]
          );
          }
          Inc(aCountUpdated);

          //привязка картинки уже может существовать если это наша перебивка артикула
          if ExecuteSimpleSelectMS(' SELECT ID FROM ART_PICTS WHERE ART_ID = :ART_ID AND PICT_ID = :PICT_ID ', [aTable.FieldByName('ART_ID').Value, aTable.FieldByName('PICT_ID').Value]) = '' then
          begin
            {
            ExecQueryMS(
              ' INSERT INTO ART_PICTS ( ART_ID,  PICT_ID,  SORT,  PICT_NR) ' +
              '                VALUES (:ART_ID, :PICT_ID, :SORT, :PICT_NR) ',
              [aTable.FieldByName('ART_ID').Value, aTable.FieldByName('PICT_ID').Value, 0, aTable.FieldByName('PICT_NR').Value]
            );
            }
          end;
        end
        else
          aQuery := nil;
      end;

      aTable.Next;
      if aTable.EOF or (aTable.RecNo mod 100 = 0) then
        UpdateProgress(0, 'переносим все из 110 в ART: ' + IntToStr(aTable.RecNo) + ' из ' + IntToStr(aTable.RecordCount));
      if fAborted then
        Break;  
    end;
    aTable.Close;
    finally
      aTable.Free;
    end;
*)
end;

procedure TFormMain.btFill_KITs_IDsClick(Sender: TObject);
var
  i, iMax, p: Integer;
  aBeginFrom_KIT, aBeginFrom_KIT_Det: Integer;
  f: TextFile;
begin
  if not OpenDialog.Execute(Handle) then
    Exit;

  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;

  aBeginFrom_KIT := 0;
  aBeginFrom_KIT_Det := 0;

  AssignFile(f, OpenDialog.FileName);
  Rewrite(f);

  DBConnect;
  TecdocConnect;
  tdQuery.DisableControls;
  try
//    insertQuery.CommandText :=
//      ' INSERT INTO TD_CDS (CDS_ID, TEX_TEXT) VALUES ( :CDS_ID, :TEX_TEXT ) ';
//    insertQuery.Prepared := True;

//    p := GetLastTableID('TD_CDS');
//    if p > 0 then
//    begin
//      msQuery.SQL.Text := 'SELECT CDS_ID FROM TD_CDS WHERE ID = ' + IntToStr(p);
//      msQuery.Open;
//      aBeginFrom_CDS := msQuery.FieldByName('CDS_ID').AsInteger;
//      msQuery.Close;
//    end;

    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(*) ' +
      ' FROM TOF_ARTICLE_LISTS ';
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;
    i := 0;

//    while True do
    begin
      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i) + ' query... ');
      tdQuery.SQL.Text :=
        ' SELECT l.ALI_ART_ID, l.ALI_ART_ID_COMPONENT, l.ALI_QUANTITY, l.ALI_SORT, a2.art_article_nr CODE, a.art_article_nr CODE_DET ' +
        ' FROM TOF_ARTICLE_LISTS l ' +
        ' left join tof_articles a on (a.art_id = l.ALI_ART_ID_COMPONENT) ' +
        ' left join tof_articles a2 on (a2.art_id = l.ALI_ART_ID) ' +
//        ' WHERE ALI_ART_ID > :ALI_ART_ID ' +
        ' ORDER BY l.ALI_ART_ID, l.ALI_SORT ';
        //' ORDER BY ALI_ART_ID, ALI_ART_ID_COMPONENT ' +
        //' FIRST(1000) ';

//      tdQuery.Parameters[0].Value := aBeginFrom_KIT;
      tdQuery.Open;

//      if tdQuery.EOF then
  //      Break;
  //    if i = iMax then
    //    Break;

//      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ');
      while not tdQuery.Eof do
      begin
//        if tdQuery.FieldByName('ALI_ART_ID').AsInteger = aBeginFrom_KIT then
//          if tdQuery.FieldByName('ALI_ART_ID_COMPONENT').AsInteger <= aBeginFrom_KIT_Det then
//          begin
//            tdQuery.Next;
//            Continue;
//          end;

  //      insertQuery.Parameters[0].Value := tdQuery.FieldByName('CDS_ID').AsInteger;
  //      insertQuery.Parameters[1].Value := Copy(tdQuery.FieldByName('TEX_TEXT').AsString, 1, 128);
  //      insertQuery.Execute;

        // ALI_ART_ID, ALI_SORT, ALI_ART_ID_COMPONENT, ALI_QUANTITY
        Writeln(
          f,
          tdQuery.Fields[0].AsString + ';' +
          tdQuery.Fields[1].AsString + ';' +
          tdQuery.Fields[2].AsString + ';' +
          tdQuery.Fields[3].AsString + ';' +
          tdQuery.Fields[4].AsString + ';' +
          tdQuery.Fields[5].AsString
        );
        aBeginFrom_KIT := tdQuery.FieldByName('ALI_ART_ID').AsInteger;
        aBeginFrom_KIT_Det := tdQuery.FieldByName('ALI_ART_ID_COMPONENT').AsInteger;

        tdQuery.Next;

        Inc(i);
        if i mod 100 = 0 then
          UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
        if fAborted then
          Break;
      end;
      tdQuery.Close;
    end; //while

  finally
    tdQuery.EnableControls;
    CloseFile(f);
    TecdocDisconnect;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;

procedure TFormMain.btFill_KITsClick(Sender: TObject);
var
  i, iMax, p: Integer;
  aBeginFrom_KIT, aBeginFrom_KIT_Det: Integer;
  f: TextFile;
begin
  if not OpenDialog.Execute(Handle) then
    Exit;

  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;

  aBeginFrom_KIT := 0;
  aBeginFrom_KIT_Det := 0;

  AssignFile(f, OpenDialog.FileName);
  Rewrite(f);

  DBConnect;
  TecdocConnect;
  tdQuery.DisableControls;
  try
    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(*) ' +
      ' FROM TOF_ARTICLE_LISTS ';
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;
    i := 0;

//    while True do
    begin
      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i) + ' query... ');
      tdQuery.SQL.Text :=
        ' SELECT l.ALI_ART_ID, l.ALI_ART_ID_COMPONENT, l.ALI_QUANTITY, l.ALI_SORT, ' +
        '        ap.art_article_nr CODE, ad.art_article_nr CODE_DET, bp.SUP_BRAND BRAND, bd.SUP_BRAND BRAND_DET ' +
        ' FROM TOF_ARTICLE_LISTS l ' +
        ' left join tof_articles ap on (ap.art_id = l.ALI_ART_ID) ' +
        ' left join tof_articles ad on (ad.art_id = l.ALI_ART_ID_COMPONENT) ' +
        ' INNER JOIN TOF_SUPPLIERS bp ON ap.ART_SUP_ID = bp.SUP_ID ' +
        ' INNER JOIN TOF_SUPPLIERS bd ON ad.ART_SUP_ID = bd.SUP_ID ' +
//        ' WHERE ALI_ART_ID > :ALI_ART_ID ' +
        ' ORDER BY l.ALI_ART_ID, l.ALI_SORT ';
        //' ORDER BY ALI_ART_ID, ALI_ART_ID_COMPONENT ' +
        //' FIRST(1000) ';

//      tdQuery.Parameters[0].Value := aBeginFrom_KIT;
      tdQuery.Open;

//      if tdQuery.EOF then
  //      Break;
  //    if i = iMax then
    //    Break;

//      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ');
      while not tdQuery.Eof do
      begin
//        if tdQuery.FieldByName('ALI_ART_ID').AsInteger = aBeginFrom_KIT then
//          if tdQuery.FieldByName('ALI_ART_ID_COMPONENT').AsInteger <= aBeginFrom_KIT_Det then
//          begin
//            tdQuery.Next;
//            Continue;
//          end;

  //      insertQuery.Parameters[0].Value := tdQuery.FieldByName('CDS_ID').AsInteger;
  //      insertQuery.Parameters[1].Value := Copy(tdQuery.FieldByName('TEX_TEXT').AsString, 1, 128);
  //      insertQuery.Execute;

        // ALI_ART_ID, ALI_SORT, ALI_ART_ID_COMPONENT, ALI_QUANTITY
        Writeln(
          f,
          tdQuery.Fields[0].AsString + ';' +
          tdQuery.Fields[1].AsString + ';' +
          tdQuery.Fields[2].AsString + ';' +
          tdQuery.Fields[3].AsString + ';' +
          tdQuery.Fields[4].AsString + ';' +
          tdQuery.Fields[5].AsString
        );
        aBeginFrom_KIT := tdQuery.FieldByName('ALI_ART_ID').AsInteger;
        aBeginFrom_KIT_Det := tdQuery.FieldByName('ALI_ART_ID_COMPONENT').AsInteger;

        tdQuery.Next;

        Inc(i);
        if i mod 100 = 0 then
          UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
        if fAborted then
          Break;
      end;
      tdQuery.Close;
    end; //while

  finally
    tdQuery.EnableControls;
    CloseFile(f);
    TecdocDisconnect;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;


procedure TFormMain.CacheARTEx(const aPrefix: string; aTable: TDBISamTable;
  aForce: Boolean);
var
  aQuery: TADOQuery;
  i, iMax: Integer;
  aTableName: string;
begin
  if not aTable.Exists then
    aTable.CreateTable
  else
    if aForce then
      aTable.EmptyTable
    else
      Exit;

  aTableName := '[' + aPrefix + 'ART]';
  UpdateProgress(0, Format('Кэширование %s...', [aTableName]));

  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT * FROM ' + aTableName;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.Open;

    i := 0;
    iMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT Count(ID) FROM ' + aTableName, []), 0);
    aTable.Open;
    while not aQuery.Eof do
    begin
      aTable.Append;
      aTable.FieldByName('ID').AsInteger := aQuery.FieldByName('ID').AsInteger;
      aTable.FieldByName('ART_ID').AsInteger := aQuery.FieldByName('ART_ID').AsInteger;
      aTable.FieldByName('ART_LOOK').AsString := aQuery.FieldByName('ART_LOOK').AsString;
      aTable.FieldByName('SUP_BRAND').AsString := AnsiUpperCase(aQuery.FieldByName('SUP_BRAND').AsString);
      aTable.FieldByName('PARAM_ID').AsInteger := aQuery.FieldByName('PARAM_ID').AsInteger;
      aTable.FieldByName('TYP_ID').AsInteger := aQuery.FieldByName('TYP_ID').AsInteger;
      aTable.FieldByName('CUR_PICT').AsInteger := aQuery.FieldByName('CUR_PICT').AsInteger;
      aTable.Post;

      aQuery.Next;

      Inc(i);
      if i mod 1000 = 0 then
        UpdateProgress(i * 100 div iMax, Format('Кэширование %s...%d', [aTableName, i]));
      if fAborted then
        Break;
    end;
    aTable.Close;

    aQuery.Close;
  finally
    UpdateProgress(0, ' ');
    aQuery.Free;
  end;


end;

procedure TFormMain.cbWindowsAutorityClick(Sender: TObject);
begin
  Panel1.Visible := not cbWindowsAutority.Checked;
  if not Panel1.Visible then
    Height := Height - Panel1.Height
  else
    Height := Height + Panel1.Height;
end;

procedure TFormMain.Button6Click(Sender: TObject);

  procedure ExportQuery(q: IQuery; const aFileName: string; const aProgress: string = '');
  var
    i, aRec: Integer;
    s: string;
    f: TextFile;
  begin
    UpdateProgress(0, aProgress);
    if not q.Active then
      q.Open;

    AssignFile(f, aFileName);
    Rewrite(f);
    try
      aRec := 0;
      while not q.EOF do
      begin
        s := '';
        for i := 0 to q.Fields.Count - 1 do
          s := s + q.Fields[i].AsString + ';';

        Writeln(f, s);
        
        q.Next;
        Inc(aRec);
        if aRec mod 100 = 0 then
          UpdateProgress(0, aProgress + ' - ' + IntToStr(aRec));
      end;
    finally
      CloseFile(f);
    end;

    q.Close;
    UpdateProgress(100, aProgress + ' - finish');
  end;

var
  aDir: string;
  q: IQuery;
  i: Integer;
begin
  if SelectDirectory.Execute then
    aDir := SelectDirectory.Directory
  else
    Exit;

  aDir := IncludeTrailingPathDelimiter(aDir);
{
  DBConnect;
  q := makeQueryMS(
    ' select a.ART_ID, a.ART_LOOK, a.SUP_BRAND, a.PARAM_ID, a.TYP_ID, a.PICT_ID, a.CUR_PICT from art a ' +
    ' where not exists ( ' +
    '   select ta.ID from TD_ART ta where ta.art_look = a.art_look and ta.sup_brand = a.sup_brand ' +
    ' ) ' +
    ' order by a.art_id '
  );
  ExportQuery(q, aDir + 'ART-NEW2.CSV', 'Выгрузка добавленных артикулов');
}

{
  q := makeQueryMS(
    ' select ART_ID, ART_LOOK, SUP_BRAND, PARAM_ID, TYP_ID, PICT_ID, CUR_PICT from ART ' +
    ' where art_id >= 5000000 '
  );
  ExportQuery(q, aDir + 'ART-NEW.CSV', 'Выгрузка добавленных артикулов');
}
{
  q := makeQueryMS(
    ' select ART_ID, ART_LOOK, SUP_BRAND, PARAM_ID, TYP_ID, PICT_ID, CUR_PICT from ART ' +
    ' where art_id < 5000000 and (param_id <> art_id or typ_id <> art_id or pict_id <> art_id) '
  );
  ExportQuery(q, aDir + 'ART-NEW-MOD.CSV', 'Выгрузка добавленных и привязанных артикулов');
}
{
  q := makeQueryMS(
    ' select ' +
    '   t.ART_LOOK, ' +
    '   t.SUP_BRAND, ' +
    '   t.ART_ID ART_ID_OLD, ' +
    '   a.ART_ID ART_ID_NEW, ' +
    '   a.PARAM_ID, ' +
    '   a.TYP_ID, ' +
    '   a.PICT_ID, ' +
    '   a.CUR_PICT ' +
    ' from dbo.ART a ' +
    ' left join dbo.TD_ART t on (a.ART_LOOK = t.ART_LOOK and a.SUP_BRAND = t.SUP_BRAND) ' +
    ' where ' +
    '   t.art_id <> a.ART_ID or ' +
    '   t.art_id <> a.PARAM_ID or ' +
    '   t.art_id <> a.TYP_ID or ' +
    '   t.art_id <> a.PICT_ID '
  );
  ExportQuery(q, aDir + 'ART-MOD.CSV', 'Выгрузка измененных артикулов');
}

{
  q := makeQueryMS(
    ' select ART_ID, PICT_ID from art_picts ' +
    ' where pict_id >= 5000000 '
  );
  ExportQuery(q, aDir + 'ART_PICTS-NEW.CSV', 'Выгрузка новых картинок');

  UpdateProgress(0, 'Выгрузка данных картинок');
  ForceDirectories(aDir + 'PICTS\');
  q := makeQueryMS(
    ' select PICT_ID, PICT_DATA from TD_PICTS ' +
    ' where PICT_ID >= 5000000 '
  );
  q.Open;
  i := 0;
  while not q.EOF do
  begin
    TBlobField( q.FieldByName('PICT_DATA') ).SaveToFile(aDir + 'PICTS\' + q.FieldByName('PICT_ID').AsString + '.JPG');
    q.Next;

    Inc(i);
    if i mod 50 = 0 then
      UpdateProgress(0, 'Выгрузка данных картинок - ' + IntToStr(i));
  end;
  UpdateProgress(100, 'Выгрузка данных картинок - finish');


  q := makeQueryMS(
    ' select d.ART_ID, d.SORT, d.PARAM_ID, p.DESCR, p.DESCRIPTION, d.PARAM_VALUE, a.ART_LOOK, a.SUP_BRAND ' +
    ' from TD_DETAILS d ' +
    ' left join TD_PARAMS p on (d.PARAM_ID = p.PARAM_ID) ' +
    ' left join ART a on (d.ART_ID = a.PARAM_ID) ' +
    ' where d.ART_ID >= 5000000 '
  );
  ExportQuery(q, aDir + 'TD_DETAILS-NEW.CSV', 'Выгрузка добавленных параметров');


  q := makeQueryMS(
    ' select at.ART_ID, at.TYP_ID, a.ART_LOOK, a.SUP_BRAND ' +
    ' from ART_TYP at ' +
    ' left join ART a on (at.ART_ID = a.TYP_ID) ' +
    ' where at.ART_ID > 5000000 '
  );
  ExportQuery(q, aDir + 'ART_TYP-NEW.CSV', 'Выгрузка добавленных привязок к машинам');
}


//------------------------------------------------------------------------------

  DBDisconnect;
end;

procedure TFormMain.Button7Click(Sender: TObject);
begin
  DBConnect;

  UpdateProgress(0, 'очистка');
  try
    makeQueryMS(' DROP TABLE [TECDOC].[DBO].[ART_MAP] ').Execute;
  except
    //таблицы может не быть
  end;

  UpdateProgress(0, 'построение мапки артикулов...');
  //мапка артикулов
  makeQueryMS(
    ' select o.ART_ID ART_ID_OLD, n.ART_ID ART_ID_NEW, o.ART_LOOK, o.SUP_BRAND ' +
    ' into [TECDOC].[DBO].[ART_MAP] ' +
    ' from [TECDOC].[DBO].[TD_ART] o ' +
    ' left join [TECDOC2012].[DBO].[TD_ART] n ON (n.Art_look = o.Art_look and n.Old_Brand = o.Sup_Brand) ' +
    ' where n.ID is not null ' +
    ' order by o.SUP_BRAND'
  ).Execute;
  UpdateProgress(0, 'finish');

  DBDisconnect;
end;

procedure TFormMain.Button8Click(Sender: TObject);
begin
  //мапка машин
  DBConnect;

  UpdateProgress(0, 'очистка');
  try
    makeQueryMS(' DROP TABLE [TECDOC].[DBO].[TYP_MAP] ').Execute;
  except
    //таблицы может не быть
  end;

  UpdateProgress(0, 'построение мапки машин...');
  //мапка артикулов
  makeQueryMS(
    'CREATE TABLE [TECDOC].[DBO].[TYP_MAP]( ' +
    '  [TYP_ID_OLD] [int] NULL, ' +
    '  [TYP_ID_NEW] [int] NULL ' +
    ') ON [PRIMARY] '
  ).Execute;

  UpdateProgress(0, 'finish');

  DBDisconnect;

{
/* таблица с машинами с вытянутыми описаниями */
select
  t.TYP_ID, 
  ma.MFA_BRAND,
  --t.MOD_ID,
  m.TEX_TEXT model,
  --t.CDS_ID, 
  c1.TEX_TEXT sub_model, 
  --t.MMT_CDS_ID, 
  c2.TEX_TEXT MMT, 
  t.SORT, 
  t.PCON_START, 
  t.PCON_END, 
  t.KW_FROM, 
  t.KW_UPTO, 
  t.HP_FROM, 
  t.HP_UPTO, 
  t.CCM, 
  t.CYLINDERS, 
  t.DOORS, 
  t.TANK, 
  --t.VOLTAGE_DES_ID, 
  d1.TEX_TEXT VOLTAGE_DES, 
  --t.ABS_DES_ID,
  d2.TEX_TEXT ABS_DES, 
  --t.ASR_DES_ID, 
  d3.TEX_TEXT ASR_DES, 
  --t.ENGINE_DES_ID, 
  d4.TEX_TEXT ENGINE_DES, 
  --t.BRAKE_TYPE_DES_ID, 
  d5.TEX_TEXT BRAKE_TYPE_DES, 
  --t.BRAKE_SYST_DES_ID, 
  d6.TEX_TEXT BRAKE_SYST_DES,
  --t.FUEL_DES_ID, 
  d7.TEX_TEXT FUEL_DES,
  --t.CATALYST_DES_ID, 
  d8.TEX_TEXT CATALYST_DES,
  --t.BODY_DES_ID, 
  d9.TEX_TEXT BODY_DES,
  --t.STEERING_DES_ID, 
  d10.TEX_TEXT STEERING_DES,
  --t.STEERING_SIDE_DES_ID, 
  d11.TEX_TEXT STEERING_SIDE_DES,
  t.MAX_WEIGHT, 
  --t.DRIVE_DES_ID, 
  d12.TEX_TEXT DRIVE_DES,
  --t.TRANS_DES_ID, 
  d13.TEX_TEXT TRANS_DES,
  --t.FUEL_SUPPLY_DES_ID, 
  d14.TEX_TEXT FUEL_SUPPLY_DES,
  t.VALVES, 
  t.ENG_CODES 

into [TECDOC2012].[DBO].[TD_TYPES_FULL]

from [TECDOC2012].[DBO].[TD_TYPES] t
LEFT JOIN [TECDOC2012].[DBO].[TD_MODELS] m ON (t.MOD_ID = m.MOD_ID)
INNER JOIN [TECDOC2012].[DBO].[TD_MANUFACTURERS] ma ON (ma.MFA_ID = m.MFA_ID)
LEFT JOIN [TECDOC2012].[DBO].[TD_CDS] c1 ON (c1.CDS_ID = t.CDS_ID) 
LEFT JOIN [TECDOC2012].[DBO].[TD_CDS] c2 ON (c2.CDS_ID = t.MMT_CDS_ID) 
LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d1 ON (d1.DES_ID = t.VOLTAGE_DES_ID) 
LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d2 ON (d2.DES_ID = t.ABS_DES_ID) 
LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d3 ON (d3.DES_ID = t.ASR_DES_ID) 
LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d4 ON (d4.DES_ID = t.ENGINE_DES_ID) 

LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d5 ON (d5.DES_ID = t.BRAKE_TYPE_DES_ID) 
LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d6 ON (d6.DES_ID = t.BRAKE_SYST_DES_ID) 
LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d7 ON (d7.DES_ID = t.FUEL_DES_ID) 
LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d8 ON (d8.DES_ID = t.CATALYST_DES_ID) 
LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d9 ON (d9.DES_ID = t.BODY_DES_ID) 
LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d10 ON (d10.DES_ID = t.STEERING_DES_ID)
LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d11 ON (d11.DES_ID = t.STEERING_SIDE_DES_ID)

LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d12 ON (d12.DES_ID = t.DRIVE_DES_ID)
LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d13 ON (d13.DES_ID = t.TRANS_DES_ID)
LEFT JOIN [TECDOC2012].[DBO].[TD_DES] d14 ON (d14.DES_ID = t.FUEL_SUPPLY_DES_ID)


order by ma.MFA_BRAND, m.TEX_TEXT, t.sort
}

end;

procedure TFormMain.Button9Click(Sender: TObject);


(*
  function GetArtMapBath(const OldIds: array of Integer; ): Integer;{return new ART_ID; -1 if not found in map}
  begin
    Result := -1;
    //..
  end;
*)

var
  aDir, aHash: string;
  q, qs: IQuery;
  i: Integer;
  aReader: TCSVReader;

  anID, anArtIdOld, anArtId, aParamId, aTypeId, aPictId: Integer;
begin
  if SelectDirectory.Execute then
    aDir := SelectDirectory.Directory
  else
    Exit;

  aDir := IncludeTrailingPathDelimiter(aDir);
//  NewTD_LoadArt_New(aDir + 'ART-NEW.CSV');
//  NewTD_LoadArt_Mod(aDir + 'ART-MOD.CSV');
//  NewTD_LoadArt_NewMod(aDir + 'ART-NEW-MOD.CSV');
//  NewTD_LoadArtPicts_New(aDir + 'ART_PICTS-NEW.CSV');
//  NewTD_LoadDetails_New(aDir + 'TD_DETAILS-NEW.CSV');
//  NewTD_LoadArtTyp_New(aDir + 'ART_TYP-NEW.CSV');

//  NewTD_LoadArt_NewMod2(aDir + 'ART-NEW3.CSV');

{

  q := makeQueryMS(
    ' select at.ART_ID, at.TYP_ID, a.ART_LOOK, a.SUP_BRAND ' +
    ' from ART_TYP at ' +
    ' left join ART a on (at.ART_ID = a.TYP_ID) ' +
    ' where at.ART_ID > 5000000 '
  );
  ExportQuery(q, aDir + 'ART_TYP-NEW.CSV', 'Выгрузка добавленных привязок к машинам');
}


//------------------------------------------------------------------------------

end;


function TFormMain.NewTD_GetArtMap(anArtIdOld: Integer): Integer;{return new ART_ID; -1 if not found in map}
var
  q: IQuery;
begin
  Result := -1;

  q := makeQueryMS('SELECT ART_ID_NEW FROM [TECDOC].[DBO].[ART_MAP] WHERE ART_ID_OLD = :ID');
  q.Parameters[0].Value := anArtIdOld;
  q.Open;
  if not q.EOF then
    Result := q.Fields[0].AsInteger;
  q.Close;
end;

function TFormMain.NewTD_GetTypMap(aTypIdOld: Integer): Integer;
var
  q: IQuery;
begin
  //Result := aTypIdOld;
  //Exit;
  
  Result := -1;

  q := makeQueryMS('SELECT TYP_ID_NEW FROM TYP_MAP WHERE TYP_ID_OLD = :ID');
  q.Parameters[0].Value := aTypIdOld;
  q.Open;
  if not q.EOF then
    Result := q.Fields[0].AsInteger;
  q.Close;
end;

procedure TFormMain.NewTD_LoadArt_New(const aFileName: string);
var
  q: IQuery;
  aReader: TCSVReader;
begin
  DBConnect;

// загружаем новые артикула ----------
  q := makeQueryMS(
    ' INSERT INTO [TECDOC2012].[DBO].[ART] ( ART_ID,  ART_LOOK,  SUP_BRAND,  PARAM_ID,  TYP_ID,  PICT_ID,  CUR_PICT) ' +
    '                               VALUES (:ART_ID, :ART_LOOK, :SUP_BRAND, :PARAM_ID, :TYP_ID, :PICT_ID, :CUR_PICT) '
  );

  aReader := TCSVReader.Create;
  aReader.Open(aFileName);
  while not aReader.Eof do
  begin
    aReader.ReturnLine;
    //ART_ID;ART_LOOK;SUP_BRAND;PARAM_ID;TYP_ID;PICT_ID;CUR_PICT

    if ( StrToIntDef(aReader.Fields[0], -1) < 5000000 ) or
       ( StrToIntDef(aReader.Fields[3], -1) < 5000000 ) or
       ( StrToIntDef(aReader.Fields[4], -1) < 5000000 ) or
       ( StrToIntDef(aReader.Fields[5], -1) < 5000000 ) then
    begin
      raise Exception.Create('Map needed: ' + aReader.CurrentLine);
    end;


    q.Parameters[0].Value := aReader.Fields[0]; //:ART_ID
    q.Parameters[1].Value := aReader.Fields[1]; //:ART_LOOK
    q.Parameters[2].Value := aReader.Fields[2]; //:SUP_BRAND
    q.Parameters[3].Value := aReader.Fields[3]; //:PARAM_ID
    q.Parameters[4].Value := aReader.Fields[4]; //:TYP_ID
    q.Parameters[5].Value := aReader.Fields[5]; //:PICT_ID
    q.Parameters[6].Value := aReader.Fields[6]; //:CUR_PICT
    q.Execute;
    q.Close;

    UpdateProgress(aReader.FilePosPercent, 'загружаем новые артикула... ' + IntToStr(aReader.LineNum));
  end;
  aReader.Close;
  aReader.Free;

  DBDisconnect;
end;

procedure TFormMain.NewTD_LoadArt_Mod(const aFileName: string);
var
  q, qs: IQuery;
  aReader: TCSVReader;
  anID, anArtIdOld, anArtId, aParamId, aTypeId, aPictId, aCurPict: Integer;
begin
  DBConnect;

// загружаем измененные артикула ----------
  q := makeQueryMS(
    ' UPDATE [TECDOC2012].[DBO].[ART] SET ' +
    '   UPDATED = 1, ' +
    '   ART_LOOK = :ART_LOOK, ' +
    '   SUP_BRAND = :SUP_BRAND, ' +
    '   ART_ID = :ART_ID, ' +
    '   PARAM_ID = :PARAM_ID, ' +
    '   TYP_ID = :TYP_ID, ' +
    '   PICT_ID = :PICT_ID ' +
    ' WHERE ID = :ID '
  );

  qs := makeQueryMS(
    ' SELECT ID, ART_ID, PARAM_ID, TYP_ID, PICT_ID FROM [TECDOC2012].[DBO].[ART] WHERE ART_ID = :ART_ID '
  );

  //ART_LOOK;SUP_BRAND;ART_ID_OLD;ART_ID_NEW;PARAM_ID;TYP_ID;PICT_ID;CUR_PICT
  aReader := TCSVReader.Create;
  aReader.Open(aFileName);
  while not aReader.Eof do
  begin
    aReader.ReturnLine;

    //ищем запись в новой БД, которую надо изменить
    anArtIdOld := NewTD_GetArtMap( StrToIntDef(aReader.Fields[2], -1) );
    if anArtIdOld = -1 then
    begin
      //log..
      Memo1.Lines.Add('NO MAP FIELD[2]: ' + aReader.CurrentLine);
      Continue;
    end;

    qs.Close;
    qs.Parameters[0].Value := anArtIdOld; //ART_ID_OLD
    qs.Open;
    anID := qs.Fields[0].AsInteger;
//    qs.Close;

    if anID = 0 then
    begin
      //log..
      Memo1.Lines.Add('NO ART_ID record for ' + IntToStr(anArtIdOld));
      Continue;
    end;

    //получаем промапленные IDшки, если они не наши (<5000000)
    anArtId := StrToIntDef(aReader.Fields[3], -1);
    if (anArtId > 0) and (anArtId < 5000000) then //ноль не мапиццо - оставить 0
      anArtId := NewTD_GetArtMap(anArtId);
    if anArtId < 0 then //не найден в мапке - оставляем тот что был
    begin
      Memo1.Lines.Add('NO MAP FIELD[3]: ' + aReader.CurrentLine);
      anArtId := qs.Fields[1].AsInteger;
    end;

    if aReader.Fields[3] = aReader.Fields[4] then
      aParamId := anArtId
    else
    begin
      aParamId := StrToIntDef(aReader.Fields[4], -1);
      if (aParamId > 0) and (aParamId < 5000000) then
        aParamId := NewTD_GetArtMap(aParamId);
      if aParamId < 0 then
      begin
        Memo1.Lines.Add('NO MAP FIELD[4]: ' + aReader.CurrentLine);
        aParamId := qs.Fields[2].AsInteger;
      end;
    end;

    if aReader.Fields[3] = aReader.Fields[5] then
      aTypeId := anArtId
    else
    begin
      aTypeId := StrToIntDef(aReader.Fields[5], -1);
      if (aTypeId > 0) and (aTypeId < 5000000) then
        aTypeId := NewTD_GetArtMap(aTypeId);
      if aTypeId < 0 then
      begin
        Memo1.Lines.Add('NO MAP FIELD[5]: ' + aReader.CurrentLine);
        aTypeId := qs.Fields[3].AsInteger;
      end;
    end;

    if aReader.Fields[3] = aReader.Fields[6] then
      aPictId := anArtId
    else
    begin
      aPictId := StrToIntDef(aReader.Fields[6], -1);
      if (aPictId > 0) and (aPictId < 5000000) then
        aPictId := NewTD_GetArtMap(aPictId);

      if aPictId < 0 then
      begin
        Memo1.Lines.Add('NO MAP FIELD[6]: ' + aReader.CurrentLine);
        aPictId := qs.Fields[4].AsInteger;
      end;
    end;
    {//картинки там уже должны быть проставлены
    aCurPict := StrToIntDef(aReader.Fields[7], -1);
    if (aCurPict > 0) and (aCurPict < 5000000) then
    begin
      aCurPict := 0;
      if aPictId > 0 then
        aCurPict := StrToIntDef(
          ExecuteSimpleSelectMS('SELECT CUR_PICT FROM [TECDOC2012].[DBO].[ART] WHERE ART_ID = :ART_ID AND CUR_PICT > 0 AND ID <> :ID', [aPictId, anID]),
          0
        );
    end;
    }
    qs.Close;

    q.Parameters[0].Value := aReader.Fields[0]; //:ART_LOOK
    q.Parameters[1].Value := aReader.Fields[1]; //:SUP_BRAND

    q.Parameters[2].Value := anArtId; //:ART_ID
    q.Parameters[3].Value := aParamId; //:PARAM_ID
    q.Parameters[4].Value := aTypeId; //:TYP_ID
    q.Parameters[5].Value := aPictId; //:PICT_ID
    q.Parameters[6].Value := anID; //:ID
    q.Execute;
    q.Close;

    UpdateProgress(aReader.FilePosPercent, 'загружаем измененные артикула... ' + IntToStr(aReader.LineNum));
  end;
  aReader.Close;
  aReader.Free;

  DBDisconnect;
end;

procedure TFormMain.NewTD_LoadArt_NewMod(const aFileName: string);
var
  q: IQuery;
  aReader: TCSVReader;
  anID, anArtId, aParamId, aTypeId, aPictId, aCurPict: Integer;
begin
  DBConnect;

// загружаем новые привязанные артикула ----------
  q := makeQueryMS(
    ' INSERT INTO [TECDOC2012].[DBO].[ART] ' +
    '        ( UPDATED,  ART_LOOK,  SUP_BRAND,  ART_ID,  PARAM_ID,  TYP_ID,  PICT_ID,  CURT_PICT) ' +
    ' VALUES (       1, :ART_LOOK, :SUP_BRAND, :ART_ID, :PARAM_ID, :TYP_ID, :PICT_ID, :CURT_PICT) '
  );

  //ART_ID;ART_LOOK;SUP_BRAND;PARAM_ID;TYP_ID;PICT_ID;CUR_PICT
  aReader := TCSVReader.Create;
  aReader.Open(aFileName);
  while not aReader.Eof do
  begin
    aReader.ReturnLine;

    //получаем промапленные IDшки, если они не наши (<5000000)
    anArtId := StrToIntDef(aReader.Fields[0], -1);
    if (anArtId > 0) and (anArtId < 5000000) then //ноль не мапиццо - оставить 0
      anArtId := NewTD_GetArtMap(anArtId);
    if anArtId < 0 then //не найден в мапке - оставляем без привязки
    begin
      Memo1.Lines.Add('Привязка не найдена для ART_ID: ' + aReader.CurrentLine);
      anArtId := 0;
    end;

    if aReader.Fields[0] = aReader.Fields[3] then
      aParamId := anArtId
    else
    begin
      aParamId := StrToIntDef(aReader.Fields[3], -1);
      if (aParamId > 0) and (aParamId < 5000000) then
        aParamId := NewTD_GetArtMap(aParamId);
      if aParamId < 0 then
      begin
        Memo1.Lines.Add('Привязка не найдена для PARAM_ID: ' + aReader.CurrentLine);
        aParamId := 0;
      end;
    end;

    if aReader.Fields[0] = aReader.Fields[4] then
      aTypeId := anArtId
    else
    begin
      aTypeId := StrToIntDef(aReader.Fields[4], -1);
      if (aTypeId > 0) and (aTypeId < 5000000) then
        aTypeId := NewTD_GetArtMap(aTypeId);
      if aTypeId < 0 then
      begin
        Memo1.Lines.Add('Привязка не найдена для TYP_ID: ' + aReader.CurrentLine);
        aTypeId := 0;
      end;
    end;

    if aReader.Fields[0] = aReader.Fields[5] then
      aPictId := anArtId
    else
    begin
      aPictId := StrToIntDef(aReader.Fields[5], -1);
      if (aPictId > 0) and (aPictId < 5000000) then
        aPictId := NewTD_GetArtMap(aPictId);
      if aPictId < 0 then
      begin
        Memo1.Lines.Add('Привязка не найдена для PICT_ID: ' + aReader.CurrentLine);
        aPictId := 0;
      end;
    end;

    //не наши картинки вытягиваем
    aCurPict := StrToIntDef(aReader.Fields[6], -1);
    if (aCurPict > 0) and (aCurPict < 5000000) then
    begin
      aCurPict := 0;
      if aPictId > 0 then
        aCurPict := StrToIntDef(
          ExecuteSimpleSelectMS('SELECT CUR_PICT FROM [TECDOC2012].[DBO].[ART] WHERE ART_ID = :ART_ID AND CUR_PICT > 0 AND ID <> :ID', [aPictId, anID]),
          0
        );
    end;



    q.Parameters[0].Value := aReader.Fields[1]; //:ART_LOOK
    q.Parameters[1].Value := aReader.Fields[2]; //:SUP_BRAND

    q.Parameters[2].Value := anArtId; //:ART_ID
    q.Parameters[3].Value := aParamId; //:PARAM_ID
    q.Parameters[4].Value := aTypeId; //:TYP_ID
    q.Parameters[5].Value := aPictId; //:PICT_ID
    q.Parameters[6].Value := aCurPict; //:CUR_PICT

    q.Execute;
    q.Close;

    UpdateProgress(aReader.FilePosPercent, 'загружаем новые привязанные артикула... ' + IntToStr(aReader.LineNum));
  end;
  aReader.Close;
  aReader.Free;

  DBDisconnect;
end;


procedure TFormMain.NewTD_LoadArt_NewMod2(const aFileName: string);
var
  q: IQuery;
  aReader: TCSVReader;
  anID, anArtId, aParamId, aTypeId, aPictId, aCurPict: Integer;
begin
  DBConnect;

// загружаем новые артикула ----------
  q := makeQueryMS(
    ' INSERT INTO [TECDOC2012].[DBO].[ART] ' +
    '        ( UPDATED,  ART_LOOK,  SUP_BRAND,  ART_ID,  PARAM_ID,  TYP_ID,  PICT_ID,  CUR_PICT) ' +
    ' VALUES (       1, :ART_LOOK, :SUP_BRAND, :ART_ID, :PARAM_ID, :TYP_ID, :PICT_ID, :CUR_PICT) '
  );

  //ART_ID;ART_LOOK;SUP_BRAND;PARAM_ID;TYP_ID;PICT_ID;CUR_PICT
  aReader := TCSVReader.Create;
  aReader.Open(aFileName);
  while not aReader.Eof do
  begin
    aReader.ReturnLine;

    //получаем промапленные IDшки, если они не наши (<5000000)
    anArtId := StrToIntDef(aReader.Fields[0], -1);
    if (anArtId > 0) and (anArtId < 5000000) then //ноль не мапиццо - оставить 0
      anArtId := NewTD_GetArtMap(anArtId);
    if anArtId < 0 then //не найден в мапке - оставляем без привязки
    begin
      Memo1.Lines.Add('Привязка не найдена для ART_ID: ' + aReader.CurrentLine);
      anArtId := 0;
      Continue;
    end;

    if aReader.Fields[0] = aReader.Fields[3] then
      aParamId := anArtId
    else
    begin
      aParamId := StrToIntDef(aReader.Fields[3], -1);
      if (aParamId > 0) and (aParamId < 5000000) then
        aParamId := NewTD_GetArtMap(aParamId);
      if aParamId < 0 then
      begin
        Memo1.Lines.Add('Привязка не найдена для PARAM_ID: ' + aReader.CurrentLine);
        aParamId := 0;
      end;
    end;

    if aReader.Fields[0] = aReader.Fields[4] then
      aTypeId := anArtId
    else
    begin
      aTypeId := StrToIntDef(aReader.Fields[4], -1);
      if (aTypeId > 0) and (aTypeId < 5000000) then
        aTypeId := NewTD_GetArtMap(aTypeId);
      if aTypeId < 0 then
      begin
        Memo1.Lines.Add('Привязка не найдена для TYP_ID: ' + aReader.CurrentLine);
        aTypeId := 0;
      end;
    end;

    if aReader.Fields[0] = aReader.Fields[5] then
      aPictId := anArtId
    else
    begin
      aPictId := StrToIntDef(aReader.Fields[5], -1);
      if (aPictId > 0) and (aPictId < 5000000) then
        aPictId := NewTD_GetArtMap(aPictId);
      if aPictId < 0 then
      begin
        Memo1.Lines.Add('Привязка не найдена для PICT_ID: ' + aReader.CurrentLine);
        aPictId := 0;
      end;
    end;

    //не наши картинки - вытягиваем
    aCurPict := StrToIntDef(aReader.Fields[6], -1);
    if (aCurPict > 0) and (aCurPict < 5000000) then
    begin
      aCurPict := 0;
      if (aPictId > 0) and (aPictId < 5000000) then
        aCurPict := StrToIntDef(
          ExecuteSimpleSelectMS('select TOP 1 PICT_ID from [TECDOC2012].[DBO].[ART_PICTS] WHERE ART_ID = :ART_ID order by SORT', [aPictId]),
          0
        );
    end;



    q.Parameters[0].Value := aReader.Fields[1]; //:ART_LOOK
    q.Parameters[1].Value := aReader.Fields[2]; //:SUP_BRAND

    q.Parameters[2].Value := anArtId; //:ART_ID
    q.Parameters[3].Value := aParamId; //:PARAM_ID
    q.Parameters[4].Value := aTypeId; //:TYP_ID
    q.Parameters[5].Value := aPictId; //:PICT_ID
    q.Parameters[6].Value := aCurPict; //:CUR_PICT

    q.Execute;
    q.Close;
              
    UpdateProgress(aReader.FilePosPercent, 'загружаем новые артикула... ' + IntToStr(aReader.LineNum));
  end;
  aReader.Close;
  aReader.Free;

  DBDisconnect;
end;


procedure TFormMain.NewTD_LoadArtPicts_New(const aFileName: string);
var
  q: IQuery;
  aReader: TCSVReader;

  anArtId: Integer;
  aHash, aDirPicts: string;
begin
  DBConnect;

//загружаем картинки
  aReader := TCSVReader.Create;
  aReader.Open(aFileName);
  while not aReader.Eof do
  begin
    //ART_ID;PICT_ID
    aReader.ReturnLine;

    anArtId := StrToIntDef(aReader.Fields[0], -1);
    //новая запись в привязках картинок
    ExecQueryMS(
      ' INSERT INTO [TECDOC2012].[DBO].[ART_PICTS] ( ART_ID,  PICT_ID,  SORT,  PICT_NR ) ' +
      '                                     VALUES (:ART_ID, :PICT_ID, :SORT, :PICT_NR ) ',
      [anArtId, aReader.Fields[1], 0, 0]
    );

    //вычисляем хэш файла с картинкой
    aDirPicts := ExtractFilePath(aFileName) + 'PICTS\';
    aHash := md5.MD5DigestToStr( md5.MD5File(aDirPicts + aReader.Fields[1] + '.JPG') );

    //новая запись в картинках
    q := makeQueryMS(
      ' INSERT INTO [TECDOC2012].[DBO].[TD_PICTS] ( PICT_ID,  PICT_DATA,  HASH ) ' +
      '                                    VALUES (:PICT_ID, :PICT_DATA, :HASH ) ');
    q.Parameters[0].Value := aReader.Fields[1];
    q.Parameters[1].LoadFromFile(aDirPicts + aReader.Fields[1] + '.JPG', ftBlob);
    q.Parameters[2].Value := aHash;
    q.Execute;

    //устанавливаем текущей
    ExecQueryMS(
      ' UPDATE [TECDOC2012].[DBO].[ART] SET CUR_PICT = :CUR_PICT WHERE PICT_ID = :PICT_ID ',
      [aReader.Fields[1], anArtId]
    );
    UpdateProgress(aReader.FilePosPercent, 'загружаем картинки... ' + IntToStr(aReader.LineNum));
  end;
  aReader.Close;
  aReader.Free;

  DBDisconnect;
end;

procedure TFormMain.NewTD_LoadDetails_New(const aFileName: string);

  //находит параметр по имени (или добавляет, если такого еще нет)
  function GetParamIdByName(const aParamName: string): Integer;
  var
    s: string;
  begin
    s := ExecuteSimpleSelectMS(' SELECT PARAM_ID FROM [TECDOC2012].[DBO].[TD_PARAMS] WHERE DESCRIPTION = :DESCRIPTION ', [aParamName]);
    if s = '' then
    begin
      s := ExecuteSimpleSelectMS(' SELECT MAX(PARAM_ID) FROM [TECDOC2012].[DBO].[TD_PARAMS] ', []);
      Result := StrToIntDef(s, 0) + 1; //get next ID
      ExecQueryMS(
        ' INSERT INTO [TECDOC2012].[DBO].[TD_PARAMS] (PARAM_ID, DESCR, DESCRIPTION) VALUES (:PARAM_ID, :DESCR, :DESCRIPTION) ',
        [Result, Copy(aParamName, 1, 32), Copy(aParamName, 1, 128)]
      );
    end
    else
      Result := StrToIntDef(s, 0);
  end;

var
  q: IQuery;
  aReader: TCSVReader;
  anArtId, aParamID, aSort: Integer;
  param_name, param_value, s: string;
  lFound: Boolean;
begin
  DBConnect;
//загружаем параметры

  //ART_ID;SORT;PARAM_ID;DESCR;DESCRIPTION;PARAM_VALUE;ART_LOOK;SUP_BRAND
  //здесь ART_ID всегда >=5000000 - т.е. нужно только инсертить без ремапа
  aReader := TCSVReader.Create;
  aReader.Open(aFileName);
  while not aReader.Eof do
  begin
    aReader.ReturnLine;

    anArtId := StrToIntDef(aReader.Fields[0], -1);
    param_name := aReader.Fields[4];
    param_value := aReader.Fields[5];

    //находим или добавляем параметр, если такого еще нет
    aParamID := GetParamIdByName(param_name);

    lFound := ExecuteSimpleSelectMS(
      'select art_id from [TECDOC2012].[DBO].[TD_DETAILS] where art_id = :art_id AND PARAM_ID = :PARAM_ID ' ,
      [anArtId, aParamID]
    ) <> '';

    if not lFound then
    begin
      s := ExecuteSimpleSelectMS(' select Max(SORT) from [TECDOC2012].[DBO].[TD_DETAILS] where art_id = :art_id ', [anArtId]);
      aSort := StrToIntDef(s, -1) + 1;
      ExecQueryMS(
        ' INSERT INTO [TECDOC2012].[DBO].[TD_DETAILS] ( ART_ID,  SORT,  PARAM_ID,  PARAM_VALUE) ' +
        '                                      VALUES (:ART_ID, :SORT, :PARAM_ID, :PARAM_VALUE) ',
        [anArtId, aSort, aParamID, Copy(param_value, 1, 128)]
      );
    end;

    UpdateProgress(aReader.FilePosPercent, 'загружаем доп. параметры... ' + IntToStr(aReader.LineNum));
  end;

  DBDisconnect;
end;

procedure TFormMain.NewTD_LoadArtTyp_New(const aFileName: string);
var
  q: IQuery;
  aReader: TCSVReader;
  anArtId, aTypId: Integer;
  s: string;
begin
  DBConnect;
//загружаем привязки к машинам

  //ART_ID;TYP_ID;ART_LOOK;SUP_BRAND
  //здесь ART_ID всегда >=5000000 - т.е. нужно только инсертить без ремапа
  aReader := TCSVReader.Create;
  aReader.Open(aFileName);
  while not aReader.Eof do
  begin
    aReader.ReturnLine;
    UpdateProgress(aReader.FilePosPercent, 'загружаем добавленные привязки к машинам... ' + IntToStr(aReader.LineNum));

    anArtId := StrToIntDef(aReader.Fields[0], -1);
    aTypId := StrToIntDef(aReader.Fields[1], -1);

    //есть ли такая машина в новом тикдоке
    s := ExecuteSimpleSelectMS(
      ' select Count(typ_id) from [TECDOC2012].[DBO].[TD_TYPES] ' +
      ' where typ_id = :typ_id ', [aTypId]);

    //если нет - ищем в мапке
    if StrToIntDef(s, 0) = 0 then
      aTypId := NewTD_GetTypMap(aTypId);

    if aTypId = -1 then
    begin
      Memo1.Lines.Add('Привязка авто не найдена: ' + aReader.CurrentLine);
      Continue;
    end;

    ExecQueryMS(
      ' INSERT INTO [TECDOC2012].[DBO].[ART_TYP] ( ART_ID,  TYP_ID) ' +
      '                                   VALUES (:ART_ID, :TYP_ID) ',
      [anArtId, aTypId]
    );

    UpdateProgress(aReader.FilePosPercent, 'загружаем добавленные привязки к машинам... ' + IntToStr(aReader.LineNum));
  end;


{
  q := makeQueryMS(
    ' select at.ART_ID, at.TYP_ID, a.ART_LOOK, a.SUP_BRAND ' +
    ' from ART_TYP at ' +
    ' left join ART a on (at.ART_ID = a.TYP_ID) ' +
    ' where at.ART_ID > 5000000 '
  );
  ExportQuery(q, aDir + 'ART_TYP-NEW.CSV', 'Выгрузка добавленных привязок к машинам');
}
end;

//скрытие авто
procedure TFormMain.Button10Click(Sender: TObject);
var
  aReader: TCSVReader;
begin
 if not OpenDialog.Execute then
   Exit;

 DBConnect;
 aReader := TCSVReader.Create;
 try
   aReader.Open(OpenDialog.FileName);

   while not aReader.Eof do
   begin
     //BRAND;HIDE
     aReader.ReturnLine;
     ExecQueryMS(' UPDATE [TECDOC2015].[DBO].[TD_MANUFACTURERS] SET HIDE = 1 WHERE MFA_BRAND = :MFA_BRAND ', [aReader.Fields[0]]);
   end;
   aReader.Close;
 finally
   aReader.Free;
   DBDisconnect;
 end;
end;




//загрузка мапки машин
procedure TFormMain.Button11Click(Sender: TObject);
var
  aReader: TCSVReader;
begin
 if not OpenDialog.Execute then
   Exit;

 DBConnect;
 aReader := TCSVReader.Create;
 try
   aReader.Open(OpenDialog.FileName);

   while not aReader.Eof do
   begin
     //TYP_ID_OLD;TYP_ID_NEW
     aReader.ReturnLine;
     UpdateProgress(aReader.FilePosPercent , 'загрузка... [' + IntToStr(aReader.LineNum) + ']');

     if (aReader.Fields[0] <> '') and (aReader.Fields[1] <> '') then
       ExecQueryMS(' INSERT INTO [TECDOC].[DBO].[TYP_MAP] ( TYP_ID_OLD,  TYP_ID_NEW) ' +
                   '                               VALUES (:TYP_ID_OLD, :TYP_ID_NEW) ',
                   [aReader.Fields[0], aReader.Fields[1]]
                 );
   end;
   aReader.Close;
 finally
   aReader.Free;
   DBDisconnect;
 end;
end;

//загрузка мапки артикулов
procedure TFormMain.Button12Click(Sender: TObject);
var
  aReader: TCSVReader;
begin
 if not OpenDialog.Execute then
   Exit;

 DBConnect;
 aReader := TCSVReader.Create;
 try
   aReader.Open(OpenDialog.FileName);

   while not aReader.Eof do
   begin
     //CODE_BRAND OLD;CODE_BRAND NEW
     aReader.ReturnLine;
     UpdateProgress(aReader.FilePosPercent , 'загрузка... [' + IntToStr(aReader.LineNum) + ']');
(*
     if (aReader.Fields[0] <> '') and (aReader.Fields[1] <> '') then
       ExecQueryMS(' INSERT INTO [TECDOC].[DBO].[TYP_MAP] ( TYP_ID_OLD,  TYP_ID_NEW) ' +
                   '                               VALUES (:TYP_ID_OLD, :TYP_ID_NEW) ',
                   [aReader.Fields[0], aReader.Fields[1]]
                 );
*)
   end;
   aReader.Close;
 finally
   aReader.Free;
   DBDisconnect;
 end;
end;


procedure TFormMain.Button13Click(Sender: TObject);
var
  q: IQuery;
  i: Integer;
begin
  DBConnect;
  try
    q := makeIQuery(adoOLEDB, ' SELECT ID, CODE, CHILD_CODE FROM KIT WHERE CODE2 IS NULL ');
    q.Query.CursorLocation := clUseClient;
    q.Query.CursorType := ctStatic;
    q.Query.DisableControls;
    q.Open;
    i := 0;
    while not q.EOF do
    begin
      ExecQueryMS(
        ' UPDATE KIT SET CODE2 = :CODE2, CHILD_CODE2 = :CHILD_CODE2 WHERE ID = :ID ',
        [MakeSearchCode(q.Fields[1].AsString), MakeSearchCode(q.Fields[2].AsString), q.Fields[0].AsInteger]
      );

      q.Next;
      Inc(i);

      if i mod 100 = 0 then
        UpdateProgress(0, 'updated: ' + IntToStr(i));
    end;

  finally
    DBDisconnect;
  end;
end;

procedure TFormMain.Button14Click(Sender: TObject);
var
  sqlRez, DelLines: integer;
begin
  adoOLEDB.Connected := False;
 // adoOLEDB.ConnectionString := cNewConnectionString;
  adoOLEDB.Connected := True;

  sqlRez := 1;
  try
  while sqlRez > 0 do
  begin
    msQuery.CursorLocation := clUseClient;
    msQuery.SQL.Text := ' DELETE FROM [TECDOC2015].[dbo].[TD_DETAILS_TYP] WHERE id IN ( ' +
                        ' SELECT TOP 50000 max(id) FROM [TECDOC2015].[dbo].[TD_DETAILS_TYP] ' +
                        ' GROUP BY [ART_ID] ,[TYP_ID] ,[SORT] ,[PARAM_ID] ,[PARAM_VALUE] ' +
                        ' HAVING count(art_id)>1 ) ';
    sqlRez := msQuery.ExecSQL;
    inc(DelLines,sqlRez);
    UpdateProgress(0, 'DELETED: ' + IntToStr(DelLines));
  end;
  finally
    UpdateProgress(0, 'END! Deleted: ' + IntToStr(DelLines));
    Memo1.Text := IntToStr(DelLines);
  end;

end;

procedure TFormMain.Button15Click(Sender: TObject);
var
  sql, TD2013_OLD_ART_ID, ART2013_NEW_ART_ID: string;
  q : IQuery;
  cntUpd, iMax: integer;

begin
  cntUpd := 0;
  DBConnect;
  UpdateProgress(0, 'Tecdoc query count...');
  q := makeQueryMS(' SELECT count(art.art_id) FROM [TECDOC2012].[dbo].[ART] ' +
                   ' Left join [TECDOC2012].[dbo].[TD_ART] td on ' +
                   ' (td.ART_LOOK = art.ART_LOOK and art.SUP_BRAND = td.SUP_BRAND) ' +
                   ' where ART.art_id < 5000000 and (td.art_id <> art.art_id or td.art_id <> art.PARAM_ID or ' +
								   ' td.art_id <> art.TYP_ID or td.art_id <>art.PICT_ID)');
  q.Open;
  iMax := q.Fields[0].AsInteger;
  q.Close;

  q := makeQueryMS(' SELECT art.ART_LOOK as code, art.SUP_BRAND as br, art.art_id as new, td.art_id as old FROM [TECDOC2012].[dbo].[ART] ' +
                   ' Left join [TECDOC2012].[dbo].[TD_ART] td on ' +
                   ' (td.ART_LOOK = art.ART_LOOK and art.SUP_BRAND = td.SUP_BRAND) ' +
                   ' where ART.art_id < 5000000 and (td.art_id <> art.art_id or td.art_id <> art.PARAM_ID or ' +
								   ' td.art_id <> art.TYP_ID or td.art_id <>art.PICT_ID) order by br');
  q.Open;
  while not q.EOF do
  begin

    sql := ' select top 1 ART_ID_NEW as NewUpd, ' +
           ' ( select top 1  ART_ID_NEW from [TECDOC2015].[dbo].ART_MAP ' +
           ' where  art_id_old = :OLD) as OldUpd FROM [TECDOC2015].[dbo].ART_MAP ' +
           ' where art_id_old = :NEW';
    sql := StringReplace(sql, ':OLD', q.FieldByName('old').AsString, [rfReplaceAll]);
    sql := StringReplace(sql, ':NEW', q.FieldByName('new').AsString, [rfReplaceAll]);
    msQuery.SQL.Text := sql;

    {
    msQuery.SQL.Text := ' select top 1 ART_ID_NEW as NewUpd, ' +
                        ' ( select top 1  ART_ID_NEW from [TECDOC2015].[dbo].ART_MAP ' +
                        ' where  art_id_old = :OLD) as OldUpd FROM [TECDOC2015].[dbo].ART_MAP ' +
                        ' where art_id_old = :NEW';
    msQuery.Parameters[0].Value := q.FieldByName('old').AsInteger;
    msQuery.Parameters[1].Value := q.FieldByName('new').AsInteger;}
    msQuery.Open;

    if not msQuery.EOF then
    begin
      try
      ExecQueryMS( ' UPDATE [TECDOC2015].[dbo].[ART] SET ART_ID = :NEW1,  param_id = :NEW2, TYP_ID = :NEW3, PICT_ID = :NEW4 WHERE ART_ID = :OLD',
                  [msQuery.FieldByName('NewUpd').Value, msQuery.FieldByName('NewUpd').Value,
                   msQuery.FieldByName('NewUpd').Value, msQuery.FieldByName('NewUpd').Value,
                   msQuery.FieldByName('OldUpd').Value] );
      inc(cntUpd);
      except
        memo2.Lines.Add(q.FieldByName('old').AsString +  '***' + q.FieldByName('new').AsString)
      end;
    end;
    UpdateProgress(cntUpd * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(cntUpd) + ' - tecdoc query...');
    msQuery.Close;
    q.Next;
  end;
  q.Close;
  UpdateProgress(0, 'finish '+ IntToStr(cntUpd) + ' из ' + IntToStr(iMax));
  DBDisconnect;
end;

procedure TFormMain.Button16Click(Sender: TObject);

var
  sql, ART_ID_OLD, ART_ID_NEW: string;
  q : IQuery;
  cntUpd, iMax, i: integer;


  function CalculateNewParam(Param: string): string;
  begin
    if (Param = ART_ID_OLD) then
      result := ART_ID_NEW
    else
    begin
      msQuery.Close;
      msQuery.SQL.Text := ' SELECT TOP 1 ART_ID_NEW FROM [TECDOC2015].[dbo].ART_MAP WHERE art_id_old = ' + Param;
      msQuery.Open;
      if msQuery.EOF then
        result := param
      else
        result := msQuery.FieldByName('ART_ID_NEW').AsString;
    end;
  end;


var
  NEW_TYP_ID, NEW_PICT_ID, NEW_PARAM_ID: string;
begin
  cntUpd := 0; i:=0;
  DBConnect;
  UpdateProgress(0, 'Tecdoc query count...');
  q := makeQueryMS(' SELECT count(id) FROM [TECDOC2012].[dbo].[ART]  where ' +
                   ' (art_id <> PARAM_ID or art_id <> TYP_ID or art_id <> PICT_ID) ' +
                   ' and art_id < 5000000');
  q.Open;
  iMax := q.Fields[0].AsInteger;
  q.Close;

  q := makeQueryMS(' SELECT ART_ID, TYP_ID, PICT_ID, PARAM_ID FROM [TECDOC2012].[dbo].[ART]  where ' +
                   ' (art_id <> PARAM_ID or art_id <> TYP_ID or art_id <> PICT_ID) ' +
                   ' and art_id < 5000000  order by id ');
  q.Open;

  while not q.EOF do
  begin
    inc(i);
    ART_ID_OLD := q.FieldByName('ART_ID').AsString;
    msQuery.SQL.Text := ' SELECT TOP 1 ART_ID_NEW FROM [TECDOC2015].[dbo].ART_MAP WHERE art_id_old = ' + ART_ID_OLD;
    msQuery.Open;

    if msQuery.Eof then {Если не удалось примапиться берем следующую}
    begin
      msQuery.Close;
      q.Next;
      Continue;
    end
    else
      ART_ID_NEW := msQuery.FieldByName('ART_ID_NEW').AsString;

    NEW_TYP_ID := CalculateNewParam(q.FieldByName('TYP_ID').AsString);
    NEW_PICT_ID := CalculateNewParam(q.FieldByName('PICT_ID').AsString);
    NEW_PARAM_ID := CalculateNewParam(q.FieldByName('PARAM_ID').AsString);

    try
      ExecQueryMS( ' UPDATE [TECDOC2015].[dbo].[ART] SET PARAM_ID = :PARAM_ID, TYP_ID = :TYP_ID, PICT_ID = :PICT_ID WHERE ART_ID = :ART_ID',
                  [NEW_PARAM_ID, NEW_TYP_ID, NEW_PICT_ID, ART_ID_NEW] );
      inc(cntUpd);
    except
      memo2.Lines.Add(' СТрока:' + IntToStr(i))
    end;

    UpdateProgress(cntUpd * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(cntUpd) + ' - tecdoc query...');
    msQuery.Close;
    q.Next;
  end;
  q.Close;
  UpdateProgress(0, 'finish '+ IntToStr(cntUpd) + ' из ' + IntToStr(iMax));
  DBDisconnect;
end;

procedure TFormMain.Button17Click(Sender: TObject);
var
  i, iMax, p: Integer;
begin
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;


  DBConnect;
  TecdocConnect;
  tdQuery.DisableControls;
  try
    insertQuery.CommandText :=
      ' INSERT [TECDOC2015].[dbo].[KIT]( [ART_ID],	[ART_CHILD_ID],	[QUANTITY],	[ORDER],	[CODE],	[CODE2],	[CHILD_CODE],	[CHILD_CODE2] )  ' +
      '          VALUES (:ART_ID,	:ART_CHILD_ID, :QUANTITY, :ORDER,	:CODE, :CODE2, :CHILD_CODE,	:CHILD_CODE2 ) ';
    insertQuery.Prepared := True;


    UpdateProgress(0, 'Tecdoc query count...');
    tdQuery.SQL.Text :=
      ' SELECT Count(*) ' +
      ' FROM TOF_ARTICLE_LISTS ';
    tdQuery.Open;
    iMax := tdQuery.Fields[0].AsInteger;
    tdQuery.Close;
    i := 0;

//    while True do
//    begin
      UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i) + ' query... ');
      tdQuery.SQL.Text :=
        ' SELECT l.ALI_ART_ID, l.ALI_ART_ID_COMPONENT, l.ALI_QUANTITY, l.ALI_SORT, a2.art_article_nr CODE, a.art_article_nr CODE_DET ' +
        ' FROM TOF_ARTICLE_LISTS l ' +
        ' left join tof_articles a on (a.art_id = l.ALI_ART_ID_COMPONENT) ' +
        ' left join tof_articles a2 on (a2.art_id = l.ALI_ART_ID) ' +
        ' ORDER BY l.ALI_ART_ID, l.ALI_SORT ';
      tdQuery.Open;
      while not tdQuery.Eof do
      begin
        insertQuery.Parameters[0].Value := tdQuery.Fields[0].AsString;
        insertQuery.Parameters[1].Value := tdQuery.Fields[1].AsString;
        insertQuery.Parameters[2].Value := tdQuery.Fields[2].AsString;
        insertQuery.Parameters[3].Value := tdQuery.Fields[3].AsString;
        insertQuery.Parameters[4].Value := tdQuery.Fields[4].AsString;
        insertQuery.Parameters[5].Value := MakeSearchCode(tdQuery.Fields[4].AsString);
        insertQuery.Parameters[6].Value := tdQuery.Fields[5].AsString;
        insertQuery.Parameters[7].Value := MakeSearchCode(tdQuery.Fields[5].AsString);
        insertQuery.Execute;
        tdQuery.Next;


        Inc(i);
        if i mod 100 = 0 then
          UpdateProgress(i * 100 div iMax, 'Импорт [' + IntToStr(iMax) + ']... ' + IntToStr(i));
        if fAborted then
          Break;
      end;
      tdQuery.Close;
   // end; //while

  finally
    tdQuery.EnableControls;
    TecdocDisconnect;
    DBDisconnect;
    UpdateProgress(0, 'finish');
    (Sender as TButton).Enabled := True;
  end;
end;

procedure TFormMain.Button18Click(Sender: TObject);
var
  i,cntAdded, ID, anAddedCount, aProcessedCount, pict_id, cur_pict, new_cur_pict: Integer;
  aFile, brand: string;
  aFileName: string;
  aReader: TCSVReader;
  s: tstringList;
  searchResult: TSearchRec;
begin
  { ***Закинули все в файл***
  s := TStringList.Create;
  if FindFirst('E:\public\patron_pict\*.jpg', faAnyFile, searchResult) = 0 then
  begin
    repeat
      s.append(searchResult.Name);
    until FindNext(searchResult) <> 0;
    FindClose(searchResult);
    s.SaveToFile('E:\public\patron_pict\allPicts.csv');
  end;  }
  i := 0;
  while i < 10 do
  begin
    if i = 0 then
    begin
      ShowMEssage('s*1' + IntToStr(i));
      i := 2 + i;
    end
    else
    begin
      ShowMEssage('s*1' + IntToStr(i));
      i := 2 + i;
    end;
  end;
  exit;

   s := TStringList.Create;
   s.SaveToFile('oooooooooooooo.csv');
   
  if OpenDialog.Execute then
    aFile := OpenDialog.FileName
  else
    Exit;

   cntAdded := 0;

  UpdateProgress(0, 'Update: 0');
  aReader := TCSVReader.Create;
  try //finally
    aReader.Open(aFile);
    aReader.ReturnLine;
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      pict_id := StrToInt(aReader.Fields[0]);
      cur_pict := StrToInt(aReader.Fields[1]);
      ID := StrToInt(aReader.Fields[2]);
      new_cur_pict := GetNewPictID;

      ExecQueryMS(
        ' UPDATE TD_PICTS SET PICT_ID = :NEW_CUR_PICT WHERE ID = :ID',
        [new_cur_pict, ID]
      );

      ExecQueryMS(
        ' UPDATE ART_PICTS SET PICT_ID = :CUR_PICT WHERE PICT_ID = :CUR_PICT AND ART_ID = :PICT_ID ',
        [new_cur_pict, cur_pict, pict_id]
      );

      ExecQueryMS(
        ' UPDATE ART SET CUR_PICT = :CUR_PICT WHERE PICT_ID = :PICT_ID AND CUR_PICT = :CUR_PICT ',
        [new_cur_pict, pict_id, cur_pict]
      );
      inc(cntAdded);
      if aReader.LineNum mod 10 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'UPDATE: ' + IntToStr(cntAdded) + '/' + IntToStr(aReader.LineNum));

    end;
  finally

  end;
end;

procedure TFormMain.Button19Click(Sender: TObject);
begin
  DBConnect;
  TecdocConnect;
  ShowMEssage(adoOLEDB.ConnectionString);
  ShowMEssage(tdConnection.ConnectionString);
end;

procedure TFormMain.btPatrialFillDataInTecdocClick(Sender: TObject);
begin
  DBConnect;
  try
    if (ChBoxPicts.Checked) or (ChBoxPrimen.Checked) or (ChBoxDescr.Checked) then
    begin
      LoadAddTDArt2('', TRUE, TRUE);
      ChBoxPicts.Checked := FALSE;
      ChBoxPrimen.Checked := FALSE;
      ChBoxDescr.Checked := FALSE;
    end
    else
      MessageDlg('Должен быть выбран один из типов данных(картинки, применяемость, описания)!!!', mtWarning , [mbOK], 1);
  finally
    DBDisconnect;
  end;
end;

procedure TFormMain.btPicturesFixClick(Sender: TObject);
var
  q, qs: IQuery;
  aReader: TCSVReader;

  i, anArtId_old, anArtId_new, aPictID, aPictID_True: Integer;
  aHash, aDirPicts: string;
  aPictsList: TStrings;
begin
  DBConnect;

  //получаем список картинок с неправильно замапленными ART_ID
  aPictsList := makeStrings;
  qs := makeQueryMS(
    ' SELECT ART_ID, PICT_ID FROM [TECDOC2012].[DBO].[ART_PICTS] ' +
    ' WHERE PICT_ID >= 5000000 AND ART_ID < 5000000 '
  );
  qs.Open;
  while not qs.EOF do
  begin
    aPictsList.Add(qs.Fields[0].AsString + '=' + qs.Fields[1].AsString);
    qs.Next;
  end;
  qs.Close;
  qs := nil;

  aPictsList.SaveToFile('c:\PICTS_REMAP.txt');

  for i := 0 to aPictsList.Count - 1 do
  begin
    anArtId_old := StrToInt( aPictsList.Names[i] );
    aPictID := StrToInt(aPictsList.ValueFromIndex[i]);

    //берем перемапленный ART_ID для нового тикдока
    anArtId_New := NewTD_GetArtMap(anArtId_old);
    if anArtId_New = -1 then
    begin
      Memo1.Lines.Add('#Мап не найден для ART_ID=' + IntToStr(anArtId_old));
      Continue;
    end;

    //перемапливаем привязку картинки по ART_ID в новом тикдоке (таблица ART_PICTS)
    ExecQueryMS(
      ' UPDATE [TECDOC2012].[DBO].[ART_PICTS] SET ART_ID = :ART_ID_NEW ' +
      ' WHERE ART_ID = :ART_ID_OLD AND PICT_ID = :PICT_ID ',
      [anArtId_New, anArtId_Old, aPictID]
    );
    Memo1.Lines.Add(Format('перемап PICT_ID=%d; ART_ID(%d->%d)', [aPictID, anArtId_Old, anArtId_New]));

    //устанавливаем картинку текущей для перемапленного ART если до этого была 0
    //..

    //находим правильную картинку для артикула где была неправильная
    qs := makeQueryMS(
      ' SELECT TOP 1 PICT_ID FROM [TECDOC2012].[dbo].[ART_PICTS] WHERE ART_ID = :ART_ID ORDER BY SORT ');
    qs.Parameters[0].Value := anArtId_Old;
    qs.Open;
    if not qs.Eof then
    begin
      aPictID_True := qs.Fields[0].AsInteger;
      qs.Close;

      // обновляем ART - устанавливаем ссылку на правильную картинку
      ExecQueryMS(
        ' UPDATE [TECDOC2012].[DBO].[ART] SET CUR_PICT = :CUR_PICT ' +
        ' WHERE PICT_ID = :ART_ID_OLD AND CUR_PICT = :CUR_PICT_OLD ',
        [aPictID_True, anArtId_Old, aPictID]
      );
      Memo1.Lines.Add(Format('правильная картинка для ART_ID=%d; PICT_ID(%d->%d); ', [anArtId_Old, aPictID, anArtId_New]));
    end;
    qs.Close;
    qs := nil;
  end;

  Memo1.Lines.SaveToFile('c:\PICTS_REMAP.log');

  DBDisconnect;
end;

end.
//в сервисной есть нехватка доп. параметров например по артикулу - 1273004676

{ /* урезание лог-файла */
backup log MyDB with no_log
go

dbcc shrinkfile ('Имя файла лога транзакций', [размер в байтах до которого уменьшить])
go
}

{
сброс счетчика автоинкремента
  DBCC CHECKIDENT (<table name>, RESEED, <new value>)
}

{
включение возможности инсертить в автоинкрементное поле
  SET IDENTITY_INSERT <table name> ON
}



{ * ПЛАН ПЕРЕХОДА НА НОВЫЙ TECDOC * }
{
  1. заливаем в новую БД весь новый TECDOC
    TD_ART            - артикула
    ART_TYP           - артикула к машинам

    TD_DETAILS        - доп параметры
    TD_DETAILS_TYP    - доп параметры по машинам (ограничения)

    TD_TYPES          - машины
    TD_MANUFACTURERS  - производители
    TD_MODELS         - модели

    ART_PICTS         - картинки к артикулам
    TD_PICTS          - сами картинки

    TD_CDS            - текстовые описания
    TD_DES            - текстовые описания
    TD_PARAMS         - описания параметров

    DESCRIPTIONS      - наши текстовые описания

  2. в текущей БД ищем артикула, которые мы добавили или перебили:
    мы добавили (запись новая):
      в ART поле ART_ID >= 5000000
    мы перебили:
      сопоставляем ART и TD_ART по полям ART_LOOK и SUP_BRAND
      - если TD_ART.ART_ID не совпадает с любым из (ART.ART_ID, ART.PARAM_ID, ART.TYP_ID, ART.PICT_ID)

    анализируем все поля (ART.ART_ID, ART.PARAM_ID, ART.TYP_ID, ART.PICT_ID), если значение < 5000000,
    то строим мапку старых ART_ID на новые и заливаем в новую БД промапленные

  3. переносим картинки:
    если ART_PICTS.PICT_ID >= 5000000 то
     - переносим связку в ART_PICTS (ART_ID - промапить если < 5000000)
     - переносим картинку в новую БД


  4. переносим  подробности:
    переносим  TD_DETAILS, если ART_ID >= 5000000
    ссылки на PARAM_ID найти по имени в новой БД и перемапить или добавить свои

  5. переносим TD_PARAMS, если PARAM_ID > 1510
     по-идее, все должно перенестись вместе с TD_DETAILS

  7. привязка к машинам ART_TYP
    перелить наши привязки к машинам
    - как определить наши привязки?
    (привязка в старой БД есть, а в новой нет..)
    (ART_TYP.ART_ID > 5000000)

    - сопоставить машины старой и новой БД по описанию и сделать мапку
      залить наши привязки к машинам промапленные

  6. ссылки на DES и CDS ?


  ссылки на DES и CDS уплывут
  ссылки на доп. параметры уплывут
  ссылки на типы?
  ссылки на картинки уплывут
}







//--------------------
{ переименованные бренды
select distinct OLD_BRAND + ' -> ' + SUP_BRAND from td_art where sup_brand <> old_brand
-------------
MAL? -> MALO
D?NMEZ -> DONMEZ
EBERSP?CHER -> EBERSPACHER
LESJ?FORS -> LESJOFORS
K?HLER SCHNEIDER -> KUHLER SCHNEIDER
L?BRO -> LOBRO
LUO?S -> LUO'S
LEMF?RDER -> LEMFORDER
SCHL?TTER TURBOLADER -> SCHLUTTER TURBOLADER
TURBO?S HOET -> TURBO' S HOET
H?CO -> HUCO
N?RAL -> NURAL
SPAHN GL?HLAMPEN -> SPAHN GLUHLAMPEN
}
{
построение мапки брендов

drop table TECDOC.dbo.TD_BRANDS
drop table TECDOC2012.dbo.TD_BRANDS

select distinct sup_brand into TECDOC.dbo.TD_BRANDS from TECDOC.dbo.TD_ART
select distinct old_brand sup_brand into TECDOC2012.dbo.TD_BRANDS from TECDOC2012.dbo.TD_ART

*******

//бренды кот. есть в старом но нет в новом - удаленные
select sup_brand from [TECDOC].[DBO].[TD_BRANDS]
where sup_brand not in (
  select sup_brand from [TECDOC2012].[DBO].[TD_BRANDS]
)
order by sup_brand


//бренды кот. есть в новом но нет в старом - добавленные
select sup_brand from [TECDOC2012].[DBO].[TD_BRANDS]
where sup_brand not in (
  select sup_brand from [TECDOC].[DBO].[TD_BRANDS]
)
order by sup_brand


*****

//переименование бренда для соответствия
update TD_ART SET OLD_BRAND = 'TURBO?S HOET' WHERE SUP_BRAND = 'TURBO'' S HOE

}

{ /* перегенерация артикулов - сброс по тикдоку */
delete from art
go

DBCC CHECKIDENT (art, RESEED, 0)
go

insert into art (ART_ID, ART_LOOK, SUP_BRAND, PARAM_ID, TYP_ID, PICT_ID)
select ART_ID, ART_LOOK, SUP_BRAND, ART_ID, ART_ID, ART_ID from td_art
}

{
/* машины для сопоставления санкевичу */
SELECT t.[TYP_ID]
      ,t.[MFA_BRAND]
      ,t.[model]
      ,t.[sub_model]
      ,t.[MMT]
      --,t.[SORT]
      ,t.[PCON_START]
      ,t.[PCON_END]
      ,t.[KW_FROM]
      ,t.[ENG_CODES]
/*      ,tn.[TYP_ID]
      ,tn.[MFA_BRAND]
      ,tn.[model]
      ,tn.[sub_model]
      ,tn.[MMT]
      ,tn.[SORT]
      ,tn.[PCON_START]
      ,tn.[PCON_END]
      ,tn.[KW_FROM]
      ,tn.[ENG_CODES]
*/

FROM [TECDOC2012].[dbo].[TD_TYPES_FULL] t
LEFT JOIN [TECDOC].[dbo].[TD_TYPES_FULL] tn on (t.MMT = tn.MMT and t.PCON_START = t.PCON_START and t.KW_FROM = tn.KW_FROM)
where
  tn.[TYP_ID] is null

order by t.MMT

}

{
/* дубли в артикулах */
select * from [TECDOC2012].[dbo].[TD_ART] WHERE ART_ID IN (

  SELECT a1.ART_ID FROM [TECDOC2012].[dbo].[TD_ART] a1
  WHERE EXISTS (
    select a2.ID from [TECDOC2012].[dbo].[TD_ART] a2
    where a2.ART_LOOK = a1.ART_LOOK and a2.SUP_BRAND = a1.SUP_BRAND and a2.ID <> a1.ID
  )

)
order by sup_brand, art_look
}

{
/* машины которых нет в новом ТД и на которые ссылается сервисная */
SELECT
       t.[TYP_ID]
      ,t.[MFA_BRAND]
      ,t.[model]
      ,t.[sub_model]
      ,t.[MMT]
      ,t.[PCON_START]
      ,t.[PCON_END]
      ,t.[KW_FROM]
      ,t.[ENG_CODES]

FROM [TECDOC].[dbo].[TD_TYPES_FULL] t
LEFT JOIN [TECDOC2012].[dbo].[TD_TYPES_FULL] tn on (t.MMT = tn.MMT and t.PCON_START = t.PCON_START and t.KW_FROM = tn.KW_FROM)
where
  tn.[TYP_ID] is null and
  t.[TYP_ID] in
  (
    select distinct atc.TYP_ID from [service].[dbo].[AT] atc
  )


order by t.MMT
}

{ /* перегенерация ART */
delete from art
go

DBCC CHECKIDENT (ART, RESEED, 0)
go

insert into art (ART_ID, ART_LOOK, SUP_BRAND, PARAM_ID, TYP_ID, PICT_ID)
select ART_ID, ART_LOOK, SUP_BRAND, ART_ID, ART_ID, ART_ID from td_art
}

{/*отвалилась привязка к тикдоку*/
select c.CODE + '_' + b.description from [120528_catalog] c
left join brands b on (b.brand_id = c.brand_id)
where c.tecdoc_id > 0 and c.cat_id in (
  select cc.cat_id from [catalog] cc where cc.tecdoc_id = 0
)
order by b.description
}
