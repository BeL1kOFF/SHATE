unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ADODB, DB, ComCtrls, ExtCtrls, dbisamtb, Buttons,
  Menus, VCLUnZip, VCLZip, AdvOfficePager, AdvOfficePagerStylers, ImgList,
  CheckLst, JvExExtCtrls, JvImage;

const
  UPD_PWD = 'shatem+';
  cLocalConnectionString = 'Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=SERVICE;Data Source=DOYNIKOV\SQLEXPRESS;';
//  cLocalConnectionString = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=SERVICE;Data Source=KRIBOOK\SQLEXPRESS';
  cAMDConnectionString = 'Provider=SQLOLEDB.1;Persist Security Info=False;Initial Catalog=SERVICE;Data Source=svbyminsd10;';//test-sql
  cWindowsAutorityParams = 'Integrated Security=SSPI;';
  cCustomAutorityParams = 'User ID=%s;Password=%s;';

  cLockedGoodsFileName = 'LockedGoods.csv';
  cLockedAnalogsFileName = 'LockedAnalogs.csv';
  cJoinedAnalogsFileName = 'JoinedAnalogs.csv';
  cFormatBulkInsertFileName = 'FormatAna.fmt';

  cSrezTables: array[0..13] of string = (
    'CATALOG',
    'ANALOG',
    'OE',
    'GROUPS',
    'BRANDS',
    'GROUPBRAND',
    'AT',
    'PICTS',
    'KIT',
    'DSC',
    'PARAMS',
    'DETAILS',
    'DET',
    'DET_TYP'
  );

type
  TGetFieldValueEvent = procedure (const aFieldName: string; var aValue: string) of object;

  TBuildInfo = record
    Version: string;
    Num: Integer;
    ParentVersion: string;
    Note: string;

    CatalogCount: Integer;
    AnalogCount: Integer;
    OECount: Integer;
    KITCount: Integer;
  end;

  TFormMain = class(TForm)
    connService: TADOConnection;
    insertQuery: TADOCommand;
    lbProgressInfo: TLabel;
    msQuery: TADOQuery;
    pnConnect: TPanel;
    Label2: TLabel;
    rbConnectionLocal: TRadioButton;
    rbConnectionServer: TRadioButton;
    btTestConnectMS: TButton;
    pnData: TPanel;
    GroupBrand: TADODataSet;
    Brand: TADODataSet;
    Group: TADODataSet;
    lbProgressPercent: TLabel;
    memCatalog: TDBISAMTable;
    memCatalogCAT_ID: TIntegerField;
    memCatalogCODE2: TStringField;
    memCatalogBRAND_ID: TIntegerField;
    memAnalog: TDBISAMTable;
    IntegerField1: TIntegerField;
    memAnalogAN_CODE: TStringField;
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
    memCatalogPrev: TDBISAMTable;
    IntegerField2: TIntegerField;
    StringField1: TStringField;
    IntegerField3: TIntegerField;
    memGroupPrev: TDBISAMTable;
    IntegerField4: TIntegerField;
    StringField2: TStringField;
    IntegerField5: TIntegerField;
    StringField3: TStringField;
    memBrandPrev: TDBISAMTable;
    memBrandPrevBRAND_ID: TIntegerField;
    memBrandPrevDESCRIPTION: TStringField;
    memGroupID: TIntegerField;
    memGroupPrevID: TIntegerField;
    memBrandID: TIntegerField;
    memBrandPrevID: TIntegerField;
    memAnalogID: TIntegerField;
    memAnalogAN_BRAND: TStringField;
    memAnalogPrev: TDBISAMTable;
    IntegerField6: TIntegerField;
    IntegerField7: TIntegerField;
    StringField4: TStringField;
    StringField5: TStringField;
    memOE: TDBISAMTable;
    memOEID: TIntegerField;
    memOECODE: TStringField;
    memOEPrev: TDBISAMTable;
    memOEPrevID: TIntegerField;
    memOEPrevCODE: TStringField;
    DBISAMEngine: TDBISAMEngine;
    DBISAMDB: TDBISAMDatabase;
    DBITable: TDBISAMTable;
    memCatalogCODE: TStringField;
    memCatalogPrevCODE: TStringField;
    memOECAT_ID: TIntegerField;
    memOEPrevCAT_ID: TIntegerField;
    pmActions: TPopupMenu;
    N0: TMenuItem;
    miFillFromService: TMenuItem;
    N2: TMenuItem;
    miMoveToCurrent: TMenuItem;
    Bevel2: TBevel;
    N4: TMenuItem;
    edUser: TEdit;
    Label9: TLabel;
    edPassword: TEdit;
    pnLog: TPanel;
    MemoLog: TMemo;
    Label10: TLabel;
    Panel2: TPanel;
    pb: TProgressBar;
    Bevel3: TBevel;
    btAbort: TButton;
    N5: TMenuItem;
    N6: TMenuItem;
    cbWindowsAutority: TCheckBox;
    Zipper: TVCLZip;
    PageStyler: TAdvOfficePagerOfficeStyler;
    OfficePager: TAdvOfficePager;
    OfficePage: TAdvOfficePage;
    MemoCreateTemplate: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    lbParentInfo: TLabel;
    Label7: TLabel;
    lbCurVersion: TLabel;
    Label8: TLabel;
    lbCurNum: TLabel;
    Label11: TLabel;
    BitBtn1: TBitBtn;
    btOtherActions: TButton;
    pnNote: TPanel;
    lbNote: TLabel;
    lbReleases: TLabel;
    Panel3: TPanel;
    lbStatusCatalog: TLabel;
    lbStatusAnalog: TLabel;
    lbStatusOE: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Bevel1: TBevel;
    cbLoadCatalog: TCheckBox;
    cbLoadAnalog: TCheckBox;
    cbLoadOE: TCheckBox;
    edFileCatalog: TEdit;
    btOpenFileCatalog: TButton;
    edFileOE: TEdit;
    btOpenFileOE: TButton;
    btLoadFiles: TBitBtn;
    btLoadToService: TBitBtn;
    Bevel4: TBevel;
    Memo1: TMemo;
    Button1: TButton;
    CSVShatemagby1: TMenuItem;
    memDES: TDBISAMTable;
    memDESDES_ID: TIntegerField;
    memDESTEX_TEXT: TStringField;
    miMoveToTemp: TMenuItem;
    miLoadPricesOnly: TMenuItem;
    Button2: TButton;
    connClient: TADOConnection;
    miMakeUpdatePicts: TMenuItem;
    edTecdocSource: TEdit;
    Label3: TLabel;
    miMakeATFull: TMenuItem;
    lbStatusKIT: TLabel;
    Label13: TLabel;
    cbLoadKIT: TCheckBox;
    edFileKIT: TEdit;
    btOpenFileKIT: TButton;
    memKIT: TDBISAMTable;
    memKITID: TIntegerField;
    memKITCAT_ID: TIntegerField;
    memKITCHILD_CODE: TStringField;
    memKITCHILD_BRAND: TStringField;
    memKITPrev: TDBISAMTable;
    memKITPrevID: TIntegerField;
    memKITPrevCAT_ID: TIntegerField;
    memKITPrevCHILD_CODE: TStringField;
    memKITPrevCHILD_BRAND: TStringField;
    Button3: TButton;
    Button4: TButton;
    btAnaNew2Old: TButton;
    pnFilesAnalog: TPanel;
    edFileAnalog: TEdit;
    btOpenFileAnalog: TButton;
    edFileAnalog_CROSS: TEdit;
    btOpenFileAnalog_CROSS: TButton;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    edFileAnalog_UNI: TEdit;
    btOpenFileAnalog_UNI: TButton;
    Label16: TLabel;
    edFileAnalog_LOCKED: TEdit;
    btOpenFileAnalog_LOCKED: TButton;
    miMakeUpdateWeb: TMenuItem;
    btMakeSrez: TButton;
    Label17: TLabel;
    edFilePircePodolsk: TEdit;
    btOpenFilePricePodolsk: TButton;
    Button5: TButton;
    miMakePictsNav: TMenuItem;
    JvImage1: TJvImage;
    Database: TDBISAMDatabase;
    Label18: TLabel;
    BulkInsertQuery: TDBISAMQuery;
    Button6: TButton;
    UpdateTable: TDBISAMTable;
    UpdateTableq1: TIntegerField;
    UpdateTableq2: TIntegerField;
    UpdateTableq3: TStringField;
    UpdateTableq4: TStringField;
    UpdateTableq6: TIntegerField;
    UpdateTableq5: TIntegerField;
    miMakePictsPortal: TMenuItem;
    Button7: TButton;
    Edit1: TEdit;
    procedure btAbortClick(Sender: TObject);
    procedure btTestConnectMSClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure btDisconnectClick(Sender: TObject);
    procedure btOpenFileCatalogClick(Sender: TObject);
    procedure btOpenFileAnalogClick(Sender: TObject);
    procedure btOpenFileOEClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbLoadCatalogClick(Sender: TObject);
    procedure cbLoadAnalogClick(Sender: TObject);
    procedure cbLoadOEClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure N0Click(Sender: TObject);
    procedure miFillFromServiceClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure miMoveToCurrentClick(Sender: TObject);
    procedure btLoadFilesClick(Sender: TObject);
    procedure btLoadToServiceClick(Sender: TObject);
    procedure btOtherActionsClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure cbWindowsAutorityClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ZipperTotalPercentDone(Sender: TObject; Percent: Integer);
    procedure lbReleasesClick(Sender: TObject);
    procedure edPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure CSVShatemagby1Click(Sender: TObject);
    procedure miMoveToTempClick(Sender: TObject);
    procedure miLoadPricesOnlyClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure miMakeUpdatePictsClick(Sender: TObject);
    procedure miMakeATFullClick(Sender: TObject);
    procedure cbLoadKITClick(Sender: TObject);
    procedure btOpenFileKITClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btAnaNew2OldClick(Sender: TObject);
    procedure miMakeUpdateWebClick(Sender: TObject);
    procedure btMakeSrezClick(Sender: TObject);
    procedure btOpenFilePricePodolskClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure miMakePictsNavClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure miMakePictsPortalClick(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    fAborted: Boolean;
    fLockedBrands: TStrings;
    fReplBrands: TStrings;
    fReleasePrefix: string;
    fUseRelease: Boolean;
    fBuildInfo: TBuildInfo;
    fCurrUser: string;
    fUserLoginLogAdded: Boolean;
    fUserLoginAt: TDateTime;

    fCurrentConnectionString: string;
    fTecdocDB: string;
//    fExcludedBrands: TStrings;

    function GetAppDir: string;

    procedure Validate;
    procedure ValidateSrez;
    procedure DBConnect(aTest: Boolean = False);
    procedure DBDisconnect;
    procedure DoAfterConnect;

    function LoadLockedBrands: Boolean;
    function IsBrandLocked(const aBrand: string): Boolean;

    function LoadReplBrands: Boolean;
    function GetReplBrand(const aBrand: string): string;

    procedure UpdateStatusAll(aBuildInfoOnly: Boolean = False);
    function GetBuildInfo(out aBuildInfo: TBuildInfo; aBuildVersion: string = ''): Boolean;

    procedure SaveINI;
    procedure LoadINI;

    //Resize Picts
    procedure resizePictsAndSave(const path2save: string; const blobField: TBlobField);


    //load
    procedure ExportLockedGoods(const aPrefix, aFileName, aJoinWithFile: string);
    procedure ExportLockedAnalogs(const aPrefix, aFileName, aJoinWithFile: string);

    procedure LoadCatalog(const aFileName: string);
    procedure LoadPrice(const aFileName, FieldName, MsgRegion: string );
    procedure LoadGroupBrand(const aFileName: string);
    procedure LoadTitles(aCatID: integer);

    procedure LoadAnalogs(const aFileName: string);
    procedure LoadAnalogsNew(const aFileName: string);

    procedure LoadOE(const aFileName: string);
    procedure LoadOENew();

    procedure LoadKIT(const aFileName: string);
    function  JoinAllAnalogsFiles: string;

    procedure makeNewCurrent;
    procedure RecognizeTecdoc;
    procedure LoadFromService;
    procedure LoadToService;

    procedure MakeUpdate(aPriceFieldName: string);
    procedure CuttingAnalogFile(aPAth, FileName, iNumOperation: string; iFieldIndexNum: integer);
    procedure WriteAnalog(const aFileName: string; const aOperationCode: string;
    const aFieldsOut: array of string; aRewriteFile: Boolean; aCurrentRecOnly: Boolean = False);
    procedure MakeUpdatePicts;
    procedure MakeFullPrimen;

    procedure makeSrez_Descr;
    procedure makeSrez_Primen;
    procedure makeSrez_Picts;
    procedure makeSrez_Det;
    procedure makeSrez_DetTyp;
    

    //cache
    procedure CacheCatalog(aForce: Boolean = False);
    procedure CacheCatalogEx(const aPrefix: string; aTable: TDBISamTable; aForce: Boolean = False);

    procedure CacheBrand(aForce: Boolean = False);
    procedure CacheBrandEx(const aPrefix: string; aTable: TDBISamTable; aForce: Boolean = False);

    procedure CacheGroup(aForce: Boolean = False);
    procedure CacheGroupEx(const aPrefix: string; aTable: TDBISamTable; aForce: Boolean = False);

    procedure CacheAnalog(aForce: Boolean = False);
    procedure CacheAnalogEx(const aPrefix: string; aTable: TDBISamTable; aForce: Boolean = False);

    procedure CacheOE(aForce: Boolean = False);
    procedure CacheOEEx(const aPrefix: string; aTable: TDBISamTable; aForce: Boolean = False);

    procedure CacheKIT(aForce: Boolean = False);
    procedure CacheKITEx(const aPrefix: string; aTable: TDBISamTable; aForce: Boolean = False);


    procedure CacheTD_DES(aTable: TDBISamTable; aForce: Boolean = False);

    function GetIsAdminPermission: Boolean;
    procedure ApplyUserRights;
  public
    //DB utils
    function GetLastTableID(const aTableName: string; const aFieldName: string = 'ID'): Integer;
    function GetTableRecordCount(const aTableName: string; const aWHERE: string = ''): Integer;
    function GetTableRecord(const aTableName: string; const aKey: string; const aWHERE: string = ''): string;
    function ExecuteSimpleSelectMS(const aSQL: string; aParams: array of Variant): string;
    function ExecuteSimpleSelectMS2(const aSQL: string; aParams: array of Variant): TstringList;
    function ExecuteQuery(const aSQL: string; aParams: array of Variant; aTimeOut: Integer = 300): Integer;
    procedure ClearTable(const aTableName: string; aResetGenerator: Boolean = True);
    procedure RenameTable(const OldName, NewName: string);
    function IsTableExists(const aTableName: string): Boolean;

    procedure CreateAllTables(aForce: Boolean; const aPrefix: string = '');
    procedure RenameAllTables(const aOldPrefix, aNewPrefix: string);
    procedure DeleteAllTables(const aPrefix: string);


    procedure ExportTableEx(const aToFile, aFromQuery: string; const aFields: array of string;
      aDefIsNull: string = ''; aRewriteFile: Boolean = True;
      const aProgressCaption: string = ''; const aProgressCalcSQL: string = '';
      OnGetFieldValueProc: TGetFieldValueEvent = nil; aUseServerCursor: Boolean = False);

    procedure UpdateProgress(aPos: Integer; const aCaption: string = '');
    procedure WriteBuildLog(const aText: string;
      anIncludeDate: Boolean = False; anIncludeTime: Boolean = True);

    property IsAdminPermission: Boolean read GetIsAdminPermission;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}
{$R XPManifest.res}

uses
  IniFiles,
  uSysGlobal, _CSVReader, uReleaseInfo, OpenDirDialog, uOutParams, ReleaseProp,
  Math, uOutParamsSite, uOutParamsSite2, MD5, uSrezParams, 
  Imaging, ImagingClasses, ImagingTypes, ImagingComponents;

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
  Result := IncludeTrailingPathDelimiter( ExtractFilePath(ParamStr(0)) );
end;

 function GetCurrentUserName(var CurrentUserName: string): Boolean;
 var
   BufferSize: DWORD;
   pUser: PChar;
 begin
   BufferSize := 0;
   GetUserName(nil, BufferSize);
   pUser := StrAlloc(BufferSize);
   try
     Result := GetUserName(pUser, BufferSize);
     CurrentUserName := StrPas(pUser);
   finally
     StrDispose(pUser);
   end;
 end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  aUserName, Data_path: string;
begin
  cbWindowsAutority.Checked := True;

  fLockedBrands := TStringList.Create;
  fReplBrands := TStringList.Create;
  LoadINI;

  if GetCurrentUserName(aUserName) then
    edUser.Text := aUserName;

 { fExcludedBrands := TStringList.Create;
  fExcludedBrands.Add('ADRIAUTO');
  fExcludedBrands.Add('ARAL');
  fExcludedBrands.Add('CIFAM');
  fExcludedBrands.Add('EAI');
  fExcludedBrands.Add('FCK');
  fExcludedBrands.Add('FEBI BILSTEIN');
  fExcludedBrands.Add('HI-GEAR');
  fExcludedBrands.Add('KOYO');
  fExcludedBrands.Add('LANG');
  fExcludedBrands.Add('LIZARTE');
  fExcludedBrands.Add('NISSENS');
  fExcludedBrands.Add('NSK');
  fExcludedBrands.Add('REMSA');
  fExcludedBrands.Add('TAVRIDA');
  fExcludedBrands.Add('WALKER');}

  {new}
  Data_path := ExtractFileDir(Application.ExeName)+ '\Tables';
  if not DirectoryExists(Data_path) then
    CreateDir(Data_path);

  with Database do
  begin
    Connected := FALSE;
    Directory := Data_path;
    Connected := TRUE;
  end;

 { if not memAnalogPrev.Exists then
    memAnalogPrev.CreateTable;
  memAnalogPrev.EmptyTable;

  if not memAnalog.Exists then
    memAnalog.CreateTable;
  memAnalog.EmptyTable;     }
  {***}
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
  fReplBrands.Free;
  if connService.Connected then
    connService.Connected := False;
//  fExcludedBrands.Free;  
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  if cbWindowsAutority.Checked then
  begin
    if Self.Showing and btConnect.CanFocus then btConnect.SetFocus;
  end
  else
    if Self.Showing and edUser.CanFocus then edUser.SetFocus;
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

procedure TFormMain.UpdateStatusAll(aBuildInfoOnly: Boolean = False);
  function ApplyTableStatus(const aTableName: string; aStatusLabel: TLabel): Integer;
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
    Result := aCount;
  end;
              
begin
  GetBuildInfo(fBuildInfo);
  lbParentInfo.Caption := fBuildInfo.ParentVersion;
  lbCurVersion.Caption := fBuildInfo.Version;
  lbCurNum.Caption := IntToStr(fBuildInfo.Num);
  lbNote.Caption := fBuildInfo.Note;
  MemoLog.Text := ExecuteSimpleSelectMS(' SELECT LOGS FROM BUILDS WHERE ISCUR = 1 ', []);

  if aBuildInfoOnly then
    Exit;

  fBuildInfo.CatalogCount := ApplyTableStatus('CATALOG', lbStatusCatalog);
  fBuildInfo.AnalogCount  := ApplyTableStatus('ANALOG', lbStatusAnalog);
  fBuildInfo.OECount      := ApplyTableStatus('OE', lbStatusOE);
  fBuildInfo.KITCount     := ApplyTableStatus('KIT', lbStatusKIT);
end;

procedure TFormMain.Validate;
begin
  if (not cbLoadCatalog.Checked) and
     (not cbLoadAnalog.Checked) and
     (not cbLoadOE.Checked) and
     (not cbLoadKIT.Checked) then
    raise Exception.Create('Ни одно из действий не выбрано');

  if (cbLoadCatalog.Checked) and not FileExists(edFileCatalog.Text) then
    raise Exception.CreateFmt('Файл не найден "%s"', [edFileCatalog.Text]);

  if (cbLoadAnalog.Checked) then
  begin
//    if (edFilePircePodolsk.Text <> '') and not FileExists(edFilePircePodolsk.Text) then
//      raise Exception.CreateFmt('Файл не найден "%s"', [edFilePircePodolsk.Text]);
    if (edFileAnalog.Text <> '') and not FileExists(edFileAnalog.Text) then
      raise Exception.CreateFmt('Файл не найден "%s"', [edFileAnalog.Text]);
    if (edFileAnalog_CROSS.Text <> '') and not FileExists(edFileAnalog_CROSS.Text) then
      raise Exception.CreateFmt('Файл не найден "%s"', [edFileAnalog_CROSS.Text]);

    if (edFileAnalog_UNI.Text <> '') and not FileExists(edFileAnalog_UNI.Text) then
      raise Exception.CreateFmt('Файл не найден "%s"', [edFileAnalog_UNI.Text]);

    if (edFileAnalog_LOCKED.Text <> '') and not FileExists(edFileAnalog_LOCKED.Text) then
      raise Exception.CreateFmt('Файл не найден "%s"', [edFileAnalog_LOCKED.Text]);

    if (edFileAnalog.Text = '') and
       (edFileAnalog_CROSS.Text = '') and
       (edFileAnalog_UNI.Text = '') and
       (edFileAnalog_LOCKED.Text = '') then
      raise Exception.Create('Не задан ни один из файлов аналогов');
  end;

  if (cbLoadOE.Checked) and not FileExists(edFileOE.Text) then
    raise Exception.CreateFmt('Файл не найден "%s"', [edFileOE.Text]);

  if (cbLoadKIT.Checked) and not FileExists(edFileKIT.Text) then
    raise Exception.CreateFmt('Файл не найден "%s"', [edFileKIT.Text]);

  if cbLoadAnalog.Checked and not FileExists(GetAppDir + 'LockedBrand.txt') then
    raise Exception.Create('Файл LockedBrand.txt не найден!');

  if cbLoadCatalog.Checked and not LoadReplBrands then
    raise Exception.Create('Файл BrandRpl.txt не найден');

  if cbLoadOE.Checked and not LoadReplBrands then
    raise Exception.Create('Файл BrandRpl.txt не найден');


  if fBuildInfo.ParentVersion = '' then
    if not MsgBoxYN('Внимание! Вы не указали предыдущую сборку.'#13#10 +
                    'В этом случае Вы не сможете получить правильное частичное обновление.'#13#10 +
                    'Хотите продолжить?') then
      Abort;

  //..
end;

procedure TFormMain.ValidateSrez;
var
  aFail: Boolean;
begin
  aFail := False;
  
  if not aFail then
    aFail := ExecuteSimpleSelectMS('SELECT TOP 1 ID FROM AT', []) = '';
  if not aFail then
    aFail := ExecuteSimpleSelectMS('SELECT TOP 1 ID FROM PICTS', []) = '';
  if not aFail then
    aFail := ExecuteSimpleSelectMS('SELECT TOP 1 ID FROM DSC', []) = '';
  if not aFail then
    aFail := ExecuteSimpleSelectMS('SELECT TOP 1 ID FROM DET', []) = '';
  if not aFail then
    aFail := ExecuteSimpleSelectMS('SELECT TOP 1 ID FROM DET_TYP', []) = '';
  
  if aFail then
    if Application.MessageBox(
         PChar('Внимание, текущий срез данных не построен или построен не до конца! Дискретное обновление может быть неверным.'#13#10'Все равно продолжить?'), 
         'Подтверждение', 
         MB_YESNO or MB_ICONWARNING
    ) <> IDYES then
      Abort;
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
    aIni.WriteString('MAIN', 'FileAnalog_CROSS', edFileAnalog_CROSS.Text);
    aIni.WriteString('MAIN', 'FileAnalog_UNI', edFileAnalog_UNI.Text);
    aIni.WriteString('MAIN', 'FileAnalog_LOCKED', edFileAnalog_LOCKED.Text);

    aIni.WriteString('MAIN', 'FileOE', edFileOE.Text);
    aIni.WriteString('MAIN', 'FileKIT', edFileKIT.Text);
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
    edFileAnalog_CROSS.Text := aIni.ReadString('MAIN', 'FileAnalog_CROSS', edFileAnalog_CROSS.Text);
    edFileAnalog_UNI.Text := aIni.ReadString('MAIN', 'FileAnalog_UNI', edFileAnalog_UNI.Text);
    edFileAnalog_LOCKED.Text := aIni.ReadString('MAIN', 'FileAnalog_LOCKED', edFileAnalog_LOCKED.Text);

    edFileOE.Text := aIni.ReadString('MAIN', 'FileOE', edFileOE.Text);
    edFileKIT.Text := aIni.ReadString('MAIN', 'FileKIT', edFileKIT.Text);
  finally
    aIni.Free;
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

function TFormMain.IsBrandLocked(const aBrand: string): Boolean;
begin
  Result := fLockedBrands.IndexOf(AnsiUpperCase(aBrand)) >= 0;
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


procedure TFormMain.DBConnect(aTest: Boolean);
begin
  if connService.Connected then
    Exit;


  if rbConnectionLocal.Checked then
    fCurrentConnectionString := cLocalConnectionString
  else
    fCurrentConnectionString := cAMDConnectionString;

  if cbWindowsAutority.Checked then
    fCurrentConnectionString := fCurrentConnectionString + cWindowsAutorityParams
  else
    fCurrentConnectionString := fCurrentConnectionString + Format(cCustomAutorityParams, [edUser.Text, edPassword.Text]);

  connService.ConnectionString := fCurrentConnectionString;
  connService.LoginPrompt :=False;// rbConnectionServer.Checked;
  connService.Connected := True;

  if not aTest and connService.Connected then
  begin
    pnConnect.Visible := False;
    fCurrUser := edUser.Text;
    DoAfterConnect;
  end;
end;

procedure TFormMain.DBDisconnect;
begin
  connService.Connected := False;
  pnConnect.Visible := True;
  pnData.Visible := False;
end;

procedure TFormMain.DoAfterConnect;
begin
  fUserLoginLogAdded := False;
  fUserLoginAt := Now;

  pnData.Visible := True;
  makeNewCurrent;
  UpdateStatusAll;
  ApplyUserRights;

  fTecdocDB := edTecdocSource.Text;
  Caption := Caption + ' - Logged as ' + fCurrUser + ' - Tecdoc DB: ' + fTecdocDB;
end;

procedure TFormMain.edPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    Key := 0;
    DBConnect;
  end;
end;

function TFormMain.GetLastTableID(const aTableName: string; const aFieldName: string): Integer;
var
  aQuery: TADOQuery;
begin
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT MAX(' + aFieldName + ') MAXID FROM [' + aTableName + ']';
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
    aQuery.SQL.Text := 'SELECT ' + aKey + ' FROM [' + aTableName + ']';
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
    aQuery.SQL.Text := 'SELECT COUNT(*) FROM [' + aTableName + ']';
    if aWHERE <> '' then
      aQuery.SQL.Add(' WHERE ' + aWHERE);
    aQuery.Open;
    Result := aQuery.Fields[0].AsInteger;
    aQuery.Close;
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
    aQuery.CommandTimeout := 300;
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

function TFormMain.ExecuteSimpleSelectMS2(const aSQL: string;
  aParams: array of Variant): TStringList;
var
  i: Integer;
  aQuery: TADOQuery;
  Descr : TStringList;
begin
  Descr := TStringList.create();
  Result := Descr;
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.CommandTimeout := 300;
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := aSQL;

    for i := Low(aParams) to High(aParams) do
      aQuery.Parameters[i].Value := aParams[i];

    aQuery.Open;
    while not aQuery.Eof do
    begin
      descr.Append(aQuery.Fields[1].AsString);
      descr.Append(aQuery.Fields[0].AsString);
      aQuery.next;
    end;
    aQuery.Close;
  finally
    aQuery.Free;
    Result := descr;
//    Descr.free;
  end;
end;

procedure TFormMain.ExportLockedAnalogs(const aPrefix, aFileName,
  aJoinWithFile: string);
var
  i, iMax: Integer;
  aQuery: TADOQuery;
  f, fSource: TextFile;
  s, aBrand: string;
begin
  UpdateProgress(0, 'Выгрузка заблокированных аналогов...');

  aQuery := TADOQuery.Create(nil);
  AssignFile(f, aFileName);
  Rewrite(f);
  try
    if (aJoinWithFile <> '') and FileExists(aJoinWithFile) then
    begin
      UpdateProgress(0, 'Объединение файлов...');
      AssignFile(fSource, aJoinWithFile);
      Reset(fSource);
      try
        while not EOF(fSource) do
        begin
          Readln(fSource, s);
          Writeln(f, s);
        end;
      finally
        CloseFile(fSource);
      end;
    end;

    UpdateProgress(0, 'Выгрузка заблокированных аналогов...');
    aQuery.Connection := msQuery.Connection;

    i := 0;
    iMax := StrToIntDef(
      ExecuteSimpleSelectMS('SELECT Count(ID) FROM [' + aPrefix + 'ANALOG] WHERE DEL_LOCKED = 1 ', []),
      0
    );

    aQuery.SQL.Text :=
      ' SELECT b.DESCRIPTION CAT_BRAND, c.CODE CAT_CODE, a.AN_BRAND, a.AN_CODE, a.LOCKED FROM [' + aPrefix + 'ANALOG] a ' +
      ' LEFT JOIN [' + aPrefix + 'CATALOG] c on (c.CAT_ID = a.CAT_ID) ' +
      ' LEFT JOIN [' + aPrefix + 'BRANDS] b on (b.BRAND_ID = c.BRAND_ID) ' +
      ' WHERE a.DEL_LOCKED = 1 ';
    aQuery.Open;
    while not aQuery.Eof do
    begin
      aBrand := aQuery.FieldByName('AN_BRAND').AsString;
      if {(aBrand = '') and }(aQuery.FieldByName('LOCKED').AsInteger = 1) then
        aBrand := fLockedBrands[0];

      s :=
        aQuery.FieldByName('CAT_BRAND').AsString + ';' + //0
        aQuery.FieldByName('CAT_CODE').AsString + ';' + //1
        aBrand + ';' + //2
        aQuery.FieldByName('AN_CODE').AsString;
      Writeln(f, s);
      
      aQuery.Next;

      Inc(i);
      if i mod 500 = 0 then
        UpdateProgress(i * 100 div iMax, 'Выгрузка заблокированных аналогов...');
    end;

    aQuery.Close;

  finally
    CloseFile(f);
    UpdateProgress(0, ' ');
    aQuery.Free;
  end;
end;

procedure TFormMain.ExportLockedGoods(const aPrefix, aFileName, aJoinWithFile: string);
var
  i, iMax: Integer;
  aQuery: TADOQuery;
  f, fSource: TextFile;
  s: string;
begin
  UpdateProgress(0, 'Выгрузка заблокированных товаров...');

  aQuery := TADOQuery.Create(nil);
  AssignFile(f, aFileName);
  Rewrite(f);
  try
    if (aJoinWithFile <> '') and FileExists(aJoinWithFile) then
    begin
      UpdateProgress(0, 'Объединение файлов...');
      AssignFile(fSource, aJoinWithFile);
      Reset(fSource);
      try
        while not EOF(fSource) do
        begin
          Readln(fSource, s);
          Writeln(f, s);
        end;
      finally
        CloseFile(fSource);
      end;
    end;

    UpdateProgress(0, 'Выгрузка заблокированных товаров...');
    aQuery.Connection := msQuery.Connection;

    i := 0;
    iMax := StrToIntDef(
      ExecuteSimpleSelectMS('SELECT Count(CAT_ID) FROM [' + aPrefix + 'CATALOG] WHERE TITLE = 0 AND LOCKED = 1 ', []),
      0
    );

    aQuery.SQL.Text :=
      ' SELECT c.*, b.DESCRIPTION BRAND_NAME, g.GROUP_DESCR, g.SUBGROUP_DESCR FROM [' + aPrefix + 'CATALOG] c ' +
      ' LEFT JOIN [' + aPrefix + 'BRANDS] b ON (c.BRAND_ID = b.BRAND_ID) ' +
      ' LEFT JOIN [' + aPrefix + 'GROUPS] g ON (c.GROUP_ID = g.GROUP_ID AND c.SUBGROUP_ID = g.SUBGROUP_ID) ' +
      ' WHERE c.TITLE = 0 AND c.LOCKED = 1 ';
    aQuery.Open;
    while not aQuery.Eof do
    begin
      s :=
        aQuery.FieldByName('BRAND_NAME').AsString + ';' + //0
        aQuery.FieldByName('CODE').AsString + ';' + //1
        aQuery.FieldByName('PRICE').AsString + ';' + //2
        'EUR;' + //3
        aQuery.FieldByName('NAME').AsString + ';' + //4
        aQuery.FieldByName('GROUP_DESCR').AsString + ';' + //5
        aQuery.FieldByName('SUBGROUP_DESCR').AsString + ';' + //6
        aQuery.FieldByName('DESCRIPTION').AsString + ';' + //7
        aQuery.FieldByName('CODE').AsString + '_' + aQuery.FieldByName('BRAND_NAME').AsString + ';' + //8
        aQuery.FieldByName('SALE').AsString + ';' + //9
        aQuery.FieldByName('NEW').AsString + ';' + //10
        aQuery.FieldByName('MULT').AsString + ';' + //11
        aQuery.FieldByName('USA').AsString + ';' + //12
        aQuery.FieldByName('CATEGORY').AsString; //13
      Writeln(f, s);
      {

      aBrand    := aReader.Fields[0];
      aGroup    := aReader.Fields[5];
      aSubGroup := aReader.Fields[6];
      aCode     := aReader.Fields[1];
      aCode2    := MakeSearchCode(aCode);
      aName     := TrimRight(aReader.Fields[4]);
      aDescr    := TrimRight(aReader.Fields[7]);
      aPrice    := StrToFloatDefUnic(aReader.Fields[2], 0);
      sale_fl   := Integer(aReader.Fields[9] = '1');
      new_fl    := Integer(aReader.Fields[10] = '1');
      mult      := StrToIntDef(aReader.Fields[11], 0);
      usa_fl    := Integer(aReader.Fields[12] = '1');
      aCategory := aReader.Fields[13];


 0     METELLI;
 1     01-2577;
 2     ,4;
 3     EUR;
 4     Втулка клапана;
 5     Детали двигателя;
 6     Направляющие втулки клапанов;
 7     NISSAN: 100 NX 90-94 2.0, 200 SX 93-99 2.0, ALMERA I Hatchback 96-00 2.0, ALMERA TINO 00- 2.0, PRIMERA 90-96 2.0, SERENA 92- 2.0, SUNNY III Hatchback 90-95 2.0 ;
 8     01-2577_METELLI;
 9     0;
 10    0;
 11    1;
 12    0;
 13    010
}

      aQuery.Next;

      Inc(i);
      if i mod 500 = 0 then
        UpdateProgress(i * 100 div iMax, 'Выгрузка заблокированных товаров...');
    end;

    aQuery.Close;

  finally
    CloseFile(f);
    UpdateProgress(0, ' ');
    aQuery.Free;
  end;
end;

function TFormMain.ExecuteQuery(const aSQL: string;
  aParams: array of Variant; aTimeOut: Integer = 300): Integer;
var
  i: Integer;
  aQuery: TADOQuery;
begin
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.CommandTimeout := aTimeOut;
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
    ExecuteQuery('DBCC CHECKIDENT (' + aTableName + ', RESEED, 0) ', []);

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

procedure TFormMain.resizePictsAndSave(const path2save: string;
  const blobField: TBlobField);
var
  aStream: TMemoryStream;
  ext: string;
  si: TSingleImage;
  bm: TBitmap;
  aPicW, aPicH, aNewW, aNewH: Integer;
begin
  aStream := TMemoryStream.Create;
  try
    blobField.SaveToStream(aStream);
    aStream.Position := 0;
    if DetermineStreamFormat(aStream) <> '' then
    begin
      si := TSingleImage.CreateFromStream(aStream);

      aPicW := si.Width;
      aPicH := si.Height;
      if (si.Width > 600) or (si.Height > 600) then
      begin
        if aPicW > aPicH then
        begin
          aNewW := 600;
          aNewH := Round( aPicH * (aNewW/aPicW) );
        end
        else
        begin
          aNewH := 600;
          aNewW := Round( aPicW * (aNewH/aPicH) );
        end;
        si.Resize(aNewW, aNewH, rfBicubic);
      end;
      si.SaveToFile(path2save);
    end;

    finally
      aStream.Free;
      aStream:=nil;
      try
        si.Free;
        si:=nil;
      except
        //
      end;
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
begin
  CacheBrandEx('', memBrand, aForce);
end;

procedure TFormMain.CacheBrandEx(const aPrefix: string; aTable: TDBISamTable; aForce: Boolean = False);
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

  aTableName := '[' + aPrefix + 'BRANDS]';
  UpdateProgress(0, Format('Кэширование %s...', [aTableName]));

  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT ID, BRAND_ID, DESCRIPTION FROM ' + aTableName;
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
      aTable.FieldByName('BRAND_ID').AsInteger := aQuery.FieldByName('BRAND_ID').AsInteger;
      aTable.FieldByName('DESCRIPTION').AsString := AnsiUpperCase(aQuery.FieldByName('DESCRIPTION').AsString);
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

procedure TFormMain.CacheGroup(aForce: Boolean);
begin
  CacheGroupEx('', memGroup, aForce);
end;

procedure TFormMain.CacheGroupEx(const aPrefix: string; aTable: TDBISamTable; aForce: Boolean = False);
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

  aTableName := '[' + aPrefix + 'GROUPS]';
  UpdateProgress(0, Format('Кэширование %s...', [aTableName]));

  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT ID, GROUP_ID, GROUP_DESCR, SUBGROUP_ID, SUBGROUP_DESCR FROM ' + aTableName;
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
      aTable.FieldByName('GROUP_ID').AsInteger := aQuery.FieldByName('GROUP_ID').AsInteger;
      aTable.FieldByName('GROUP_DESCR').AsString := aQuery.FieldByName('GROUP_DESCR').AsString;
      aTable.FieldByName('SUBGROUP_ID').AsInteger := aQuery.FieldByName('SUBGROUP_ID').AsInteger;
      aTable.FieldByName('SUBGROUP_DESCR').AsString := aQuery.FieldByName('SUBGROUP_DESCR').AsString;
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

procedure TFormMain.cbLoadCatalogClick(Sender: TObject);
begin
  edFileCatalog.Visible := cbLoadCatalog.Checked;
  btOpenFileCatalog.Visible := cbLoadCatalog.Checked;
end;

procedure TFormMain.cbLoadAnalogClick(Sender: TObject);
begin
{
  edFileAnalog.Visible := cbLoadAnalog.Checked;
  btOpenFileAnalog.Visible := cbLoadAnalog.Checked;
}
  pnFilesAnalog.Visible := cbLoadAnalog.Checked;
end;

procedure TFormMain.cbLoadOEClick(Sender: TObject);
begin
  edFileOE.Visible := cbLoadOE.Checked;
  btOpenFileOE.Visible := cbLoadOE.Checked;
end;

procedure TFormMain.cbLoadKITClick(Sender: TObject);
begin
  edFileKIT.Visible := cbLoadKIT.Checked;
  btOpenFileKIT.Visible := cbLoadKIT.Checked;
end;

procedure TFormMain.cbWindowsAutorityClick(Sender: TObject);
begin
  edUser.Enabled := not cbWindowsAutority.Checked;
  edPassword.Enabled := not cbWindowsAutority.Checked;
  if cbWindowsAutority.Checked then
  begin
    if Self.Showing and btConnect.CanFocus then btConnect.SetFocus;
  end
  else
    if Self.Showing and edUser.CanFocus then edUser.SetFocus;
end;

procedure TFormMain.CacheCatalog(aForce: Boolean);
begin
  CacheCatalogEx('', memCatalog, aForce);
end;

procedure TFormMain.CacheCatalogEx(const aPrefix: string; aTable: TDBISamTable; aForce: Boolean = False);
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

  aTableName := '[' + aPrefix + 'CATALOG]';
  UpdateProgress(0, Format('Кэширование %s...', [aTableName]));

  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT CAT_ID, CODE, CODE2, BRAND_ID FROM ' + aTableName + ' WHERE CODE2 <> '''' AND CODE2 IS NOT NULL';
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.Open;

    i := 0;
    iMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT COUNT (ID) FROM ' + aTableName + ' WHERE CODE2 <> '''' AND CODE2 IS NOT NULL', []), 0);
    aTable.Open;
    while not aQuery.Eof do
    begin
      aTable.Append;
      aTable.FieldByName('CAT_ID').AsInteger := aQuery.FieldByName('CAT_ID').AsInteger;
      aTable.FieldByName('CODE').AsString := aQuery.FieldByName('CODE').AsString;
      aTable.FieldByName('CODE2').AsString := aQuery.FieldByName('CODE2').AsString;
      aTable.FieldByName('BRAND_ID').AsInteger := aQuery.FieldByName('BRAND_ID').AsInteger;
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

procedure TFormMain.CacheAnalog(aForce: Boolean);
begin
  CacheAnalogEx('', memAnalog, aForce);
end;

procedure TFormMain.CacheAnalogEx(const aPrefix: string; aTable: TDBISamTable; aForce: Boolean = False);
var
  aQuery: TADOQuery;
  i, iMax: Integer;
  aTableName: string;
  tFile: TextFile;
begin
  if not aTable.Exists then
    aTable.CreateTable
  else
    if aForce then
      aTable.EmptyTable
    else
      Exit;

  aTableName := '[' + aPrefix + 'ANALOG]';
  UpdateProgress(0, Format('Кэширование %s...', [aTableName]));

  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT ID, CAT_ID, AN_CODE, AN_BRAND FROM ' + aTableName;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.Open;
    aQuery.DisableControls;
    i := 0;
    iMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT Count(ID) FROM ' + aTableName, []), 0);

    aTable.Open;
    while not aQuery.Eof do
    begin
      aTable.Append;
      aTable.FieldByName('ID').AsInteger := aQuery.FieldByName('ID').AsInteger;
      aTable.FieldByName('CAT_ID').AsInteger := aQuery.FieldByName('CAT_ID').AsInteger;
      aTable.FieldByName('AN_CODE').AsString := AnsiUpperCase(aQuery.FieldByName('AN_CODE').AsString);
      aTable.FieldByName('AN_BRAND').AsString := AnsiUpperCase(aQuery.FieldByName('AN_BRAND').AsString);
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
    aQuery.EnableControls;
    aQuery.Free;
  end;
end;

procedure TFormMain.CacheOE(aForce: Boolean);
begin
  CacheOEEx('', memOE, aForce);
end;

procedure TFormMain.CacheOEEx(const aPrefix: string; aTable: TDBISamTable;
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

  aTableName := '[' + aPrefix + 'OE]';
  UpdateProgress(0, Format('Кэширование %s...', [aTableName]));

  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT ID, CAT_ID, CODE FROM ' + aTableName;
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
      aTable.FieldByName('CAT_ID').AsInteger := aQuery.FieldByName('CAT_ID').AsInteger;
      aTable.FieldByName('CODE').AsString := AnsiUpperCase(aQuery.FieldByName('CODE').AsString);
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

procedure TFormMain.CacheKIT(aForce: Boolean);
begin
  CacheKITEx('', memKIT, aForce);
end;

procedure TFormMain.CacheKITEx(const aPrefix: string; aTable: TDBISamTable;
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

  aTableName := '[' + aPrefix + 'KIT]';
  UpdateProgress(0, Format('Кэширование %s...', [aTableName]));

  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT ID, CAT_ID, CHILD_CODE, CHILD_BRAND FROM ' + aTableName;
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
      aTable.FieldByName('CAT_ID').AsInteger := aQuery.FieldByName('CAT_ID').AsInteger;
      aTable.FieldByName('CHILD_CODE').AsString := AnsiUpperCase(aQuery.FieldByName('CHILD_CODE').AsString);
      aTable.FieldByName('CHILD_BRAND').AsString := AnsiUpperCase(aQuery.FieldByName('CHILD_BRAND').AsString);
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


procedure TFormMain.CacheTD_DES(aTable: TDBISamTable; aForce: Boolean);
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

  aTableName := '[' + fTecdocDB + '].[DBO].[TD_DES]';
  UpdateProgress(0, Format('Кэширование %s...', [aTableName]));

  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT DES_ID, TEX_TEXT FROM ' + aTableName;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.Open;

    i := 0;
    iMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT Count(ID) FROM ' + aTableName, []), 0);
    aTable.Open;
    while not aQuery.Eof do
    begin
      aTable.Append;
      aTable.FieldByName('DES_ID').AsInteger := aQuery.FieldByName('DES_ID').AsInteger;
      aTable.FieldByName('TEX_TEXT').AsString := aQuery.FieldByName('TEX_TEXT').AsString;
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

procedure TFormMain.btOpenFileCatalogClick(Sender: TObject);
begin
  OD.FileName := edFileCatalog.Text;
  if OD.Execute then
    edFileCatalog.Text := OD.FileName;
end;

procedure TFormMain.btOpenFileAnalogClick(Sender: TObject);
var
  aEdit: TEdit;
begin
  aEdit := nil;
   
  if Sender = btOpenFileAnalog then
    aEdit := edFileAnalog
  else if Sender = btOpenFileAnalog_CROSS then
    aEdit := edFileAnalog_CROSS
  else if Sender = btOpenFileAnalog_UNI then
    aEdit := edFileAnalog_UNI
  else if Sender = btOpenFileAnalog_LOCKED then
    aEdit := edFileAnalog_LOCKED;

  if not Assigned(aEdit) then
    Exit;

  OD.FileName := aEdit.Text;
  if OD.Execute then
    aEdit.Text := OD.FileName;
end;

procedure TFormMain.btOpenFileOEClick(Sender: TObject);
begin
  OD.FileName := edFileOE.Text;
  if OD.Execute then
    edFileOE.Text := OD.FileName;
end;

procedure TFormMain.btOpenFilePricePodolskClick(Sender: TObject);
begin
  OD.FileName := edFilePircePodolsk.Text;
  if OD.Execute then
    edFilePircePodolsk.Text := OD.FileName;
end;

procedure TFormMain.btOpenFileKITClick(Sender: TObject);
begin
  OD.FileName := edFileKIT.Text;
  if OD.Execute then
    edFileKIT.Text := OD.FileName;
end;

procedure TFormMain.LoadCatalog(const aFileName: string);
var
  i: Integer;
  aReader: TCSVReader;

  aBrand, aGroup, aSubGroup, aCode, aCode2, aName, aDescr, aCategory, aCategoryTM, No: string;
  aPrice: Double;
  sale_fl, new_fl, usa_fl, mult, aOrderOnly: Integer;
  aNewID, aCatID, aBrandID, aGroupID, aSubGroupID: Integer;

  procedure AddToTable;
  var
    pict_id, typ_id, param_id, td_id: Integer;
    bExists: Boolean;
  begin
    td_id := 0;
    pict_id := 0;
    typ_id := 0;
    param_id := 0;

    memBrand.FindKey([AnsiUpperCase(aBrand)]);
    aBrandID := memBrand.FieldByName('Brand_id').AsInteger;
    memGroup.FindKey([aGroup, aSubGroup]);
    aGroupID := memGroup.FieldByName('Group_id').AsInteger;
    aSubGroupID := memGroup.FieldByName('Subgroup_id').AsInteger;

   // bExists := False;
  {  bExists := GetTableRecord(
      'CATALOG', 'ID',
      Format('UPPER(CODE2) = UPPER(''%s'') AND BRAND_ID = %d', [aCode2, aBrandID])
    ) <> '';
   }
    bExists := memCatalog.FindKey([aCode2, aBrandID]);
    if not bExists then
    begin
      if fUseRelease and memCatalogPrev.FindKey([AnsiUpperCase(aCode), aBrandID]) then
      begin
        aCatID := memCatalogPrev.FieldByName('CAT_ID').AsInteger;
      end
      else
      begin
        Inc(aNewID);
        aCatID := aNewID;
      end;

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
        Parameters[21].Value := aCategory;
        Parameters[22].Value := aOrderOnly;
        Parameters[23].Value := aCategoryTM;
        Parameters[24].Value := No;

        Execute;

        memCatalog.Append;
        memCatalog.FieldByName('CAT_ID').AsInteger := aCatID;
        memCatalog.FieldByName('CODE').AsString := AnsiUpperCase(aCode);
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
  aFileNameEnd: string;
begin
  aFileNameEnd := aFileName;
  WriteBuildLog('Загрузка каталога из ' + aFileNameEnd);
  if fUseRelease then
  begin
//    ExportLockedGoods(fReleasePrefix, GetAppDir + cLockedGoodsFileName, aFileName);
//    aFileNameEnd := GetAppDir + cLockedGoodsFileName;
    CacheCatalogEx(fReleasePrefix, memCatalogPrev, True);
    memCatalogPrev.IndexName := 'CODEBRAND';
    memCatalogPrev.Open;
  end;


  UpdateProgress(0, 'Очистка каталога...');
  ClearTable('CATALOG');
  UpdateProgress(0, 'Очистка аналогов...');
  ClearTable('ANALOG');
  UpdateProgress(0, 'Очистка OE...');
  ClearTable('OE');

  LoadGroupBrand(aFileNameEnd);

  memBrand.IndexName := 'Descr';
  memBrand.Open;
  memGroup.IndexName := 'GrDescr';
  memGroup.Open;

  CacheCatalog(True);
  memCatalog.IndexName := 'CODE2BRAND';
  memCatalog.Open;

  aReader := TCSVReader.Create;
  aErrs := TStringList.Create;
  try
    if fAborted then
      Exit;

    //добавляем столбец с категориями лотуса
    ExecuteQuery(
      ' IF COLUMNPROPERTY(OBJECT_ID(''[SERVICE].[dbo].[CATALOG]'',''U''),''CATEGORY'',''AllowsNull'') IS NULL ' +
      '   ALTER TABLE [SERVICE].[dbo].[CATALOG] ADD ' +
      '     CATEGORY [varchar](32) COLLATE Cyrillic_General_CI_AS NULL ',
      []
    );

    //добавляем столбец с категориями по брендам
    ExecuteQuery(
      ' IF COLUMNPROPERTY(OBJECT_ID(''[SERVICE].[dbo].[CATALOG]'',''U''),''CATEGORY_TM'',''AllowsNull'') IS NULL ' +
      '   ALTER TABLE [SERVICE].[dbo].[CATALOG] ADD ' +
      '     CATEGORY_TM [varchar](32) COLLATE Cyrillic_General_CI_AS NULL ',
      []
    );

    //добавляем столбец цен Подольска
    ExecuteQuery(
      ' IF COLUMNPROPERTY(OBJECT_ID(''[SERVICE].[dbo].[CATALOG]'',''U''),''PRICE_PODOLSK'',''AllowsNull'') IS NULL ' +
      '   ALTER TABLE [SERVICE].[dbo].[CATALOG] ADD ' +
      '     PRICE_PODOLSK [float] NULL ',
      []
    );

    //добавляем столбец штрих код
    ExecuteQuery(
      ' IF COLUMNPROPERTY(OBJECT_ID(''[SERVICE].[dbo].[CATALOG]'',''U''),''No_'',''AllowsNull'') IS NULL ' +
      '   ALTER TABLE [SERVICE].[dbo].[CATALOG] ADD ' +
      '     No_ [varchar](50) COLLATE Cyrillic_General_CI_AS NULL ',
      []
    );



    insertQuery.CommandText :=
      ' INSERT INTO CATALOG ( Cat_id,  Brand_id,  Group_id,  Subgroup_id,  Code,  ShortCode,  Code2,  Name,  Description, ' +
        ' Price,  T1,  T2,  Tecdoc_id,  New,  Sale,  Mult,  Usa,  IDouble,  pict_id,  typ_tdid,  param_tdid, TITLE, CATEGORY,  ORDER_ONLY,  CATEGORY_TM, No_) ' +
      '              VALUES (:Cat_id, :Brand_id, :Group_id, :Subgroup_id, :Code, :ShortCode, :Code2, :Name, :Description, ' +
        ':Price, :T1, :T2, :Tecdoc_id, :New, :Sale, :Mult, :Usa, :IDouble, :pict_id, :typ_tdid, :param_tdid, 0,    :CATEGORY, :ORDER_ONLY, :CATEGORY_TM, :No_) ';
    insertQuery.Prepared := True;

    if fUseRelease then
      aNewID := GetLastTableID(fReleasePrefix + 'CATALOG', 'CAT_ID')
    else
      aNewID := 0;
    i := 0;

    UpdateProgress(0, 'Загрузка каталога...');
    aReader.DosToAnsiEncode := True;
    aReader.Open(aFileNameEnd);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;

{      
0  Брэнд
1  Код
2  Цена 
3  Наименование
4  Группа
5  Подгруппа
6  Описание
7  Код_Бренд
8  Флаг «Распродажа»
9  Кратность
10 Категория товара (ТОВЛИНИЯ)
11 Категория товара (ТМ)
12 Признак "Под заказ"
13 Основной код товара
14 Штрих код
}

      
      aBrand     := aReader.Fields[0];
      aGroup     := aReader.Fields[4];
      aSubGroup  := aReader.Fields[5];
      aCode      := aReader.Fields[1];
      aCode2     := MakeSearchCode(aCode);
      aName      := TrimRight(aReader.Fields[3]);
      aDescr     := TrimRight(aReader.Fields[6]);
      aPrice     := StrToFloatDefUnic(aReader.Fields[2], 0);
      sale_fl    := Integer(aReader.Fields[8] = '1');
      new_fl     := 1;
      mult       := StrToIntDef(aReader.Fields[9], 0);
      usa_fl     := 1;
      aCategory  := aReader.Fields[10];
      aCategoryTM := aReader.Fields[11];

      aOrderOnly := StrToIntDef(aReader.Fields[12], 0);
      No := aReader.Fields[13];
      
      if (aReader.Fields[7] = '') and
         (aReader.Fields[8] = '') and
         (aReader.Fields[9] = '') then
      begin
        WriteBuildLog('!Перевод строки в описании товара ' + aCode + '_' + aBrand);
        aReader.ReturnLine; //следующая cтрока тоже запорота
        Continue;
      end;

//      if aCategory = '9999' then
//        Continue;

      if aBrand = 'RENAU' then
        aBrand := 'RENAULT';
      if aBrand = 'MITSU' then
        aBrand := 'MITSUBISHI';

      if IsBrandLocked(aBrand) then
        Continue;
//      if fExcludedBrands.IndexOf(aBrand) >= 0 then
//        Continue;

      try   
        AddToTable;
      except
        on E: Exception do 
        begin
          WriteBuildLog('!Exception: ' + E.Message + ' в строке "' + aReader.CurrentLine + '"');
          raise;
        end; 
      end;
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
    //если все позиции товаров совпали, титлы все равно должны быть с новыми CAT_ID
    LoadTitles( aNewID + 1{GetLastTableID('CATALOG', 'CAT_ID')} );
    UpdateProgress(100, 'Загрузка каталога... пометка заблокированных');
    ExecuteQuery('UPDATE [CATALOG] SET LOCKED = 1 WHERE CAT_ID IN ( SELECT c.CAT_ID FROM [' + fReleasePrefix + 'CATALOG] c WHERE c.LOCKED = 1)', []);

  finally
    if fAborted then
      WriteBuildLog('...прервано пользователем'#13#10)
    else
      WriteBuildLog('...загружен'#13#10);

    memCatalog.Close;
    if fUseRelease then
      memCatalogPrev.Close;
    memBrand.Close;
    memGroup.Close;
    aErrs.Free;
    aReader.Free;
  end;
end;

procedure TFormMain.LoadGroupBrand(const aFileName: string);
var
  i, j, iMax, iPos: integer;
  aGroup, aSubGroup, aBrand: string;
  aReader: TCSVReader;
  aNewID, aNewBrandID, aNewGroupID, aNewSubGroupID, anID, aBrandID, aGroupID, aSubGroupID: Integer;

  procedure AddToTable;
  begin
    if not memBrand.FindKey([AnsiUpperCase(aBrand)]) then
    begin
      memBrand.Append;
      memBrand.FieldByName('Description').Value := AnsiUpperCase(aBrand);
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
  if fUseRelease then
  begin
    CacheBrandEx(fReleasePrefix, memBrandPrev, True);
    memBrandPrev.IndexName := 'Descr';
    memBrandPrev.Open;

    CacheGroupEx(fReleasePrefix, memGroupPrev, True);
    memGroupPrev.IndexName := 'GrDescr';
    memGroupPrev.Open;
  end;

  ClearTable('BRANDS');
  CacheBrand(True);
  memBrand.Open;
  memBrand.IndexName := 'Descr';

  ClearTable('GROUPS');
  CacheGroup(True);
  memGroup.Open;
  memGroup.IndexName := 'GrDescr';

{  Brand.Open;
  Group.Open; }
  i := 0;
  aReader := TCSVReader.Create;
  try
    UpdateProgress(0, 'Загрузка классификатора...');
    aReader.DosToAnsiEncode := True;
    aReader.Open(aFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;

      aBrand    := aReader.Fields[0];

      if aBrand = 'RENAU' then
        aBrand := 'RENAULT';
      if aBrand = 'MITSU' then
        aBrand := 'MITSUBISHI';
//      if fExcludedBrands.IndexOf(aBrand) >= 0 then
//        Continue;

      if IsBrandLocked(aBrand) then
        Continue;

      aGroup    := aReader.Fields[4];
      aSubGroup := aReader.Fields[5];
      AddToTable;
      inc(i);
      if i mod 1000 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Загрузка классификатора...' + IntToStr(i));
      if fAborted then
        Break;
    end;
    aReader.Close;

    UpdateProgress(0, 'Перенумерация классификатора...');


//*** бренды *** 

    if fUseRelease then
    begin
      aNewID := GetLastTableID(fReleasePrefix + 'BRANDS', 'ID');
      aNewBrandID := GetLastTableID(fReleasePrefix + 'BRANDS', 'BRAND_ID');
    end
    else
    begin
      aNewID := 0;
      aNewBrandID := 0;
    end;

    ExecuteQuery('SET IDENTITY_INSERT BRANDS ON ', []);
    insertQuery.CommandText :=
      ' INSERT INTO BRANDS ( id,  Brand_id,  Description) ' +
      '             VALUES (:id, :Brand_id, :Description)';
    insertQuery.Prepared := True;

    memBrand.IndexName := 'Descr';
    memBrand.First;
    i := 1;
    iMax := memBrand.RecordCount;
    while not memBrand.Eof do
    begin
      if fUseRelease and memBrandPrev.FindKey([memBrand.FieldByName('Description').Value]) then
      begin
        anID := memBrandPrev.FieldByName('ID').AsInteger;
        aBrandID := memBrandPrev.FieldByName('BRAND_ID').AsInteger;
      end
      else
      begin
        Inc(aNewID);
        Inc(aNewBrandID);
        anID := aNewID;
        aBrandID := aNewBrandID;
      end;

      memBrand.Edit;
      memBrand.FieldByName('id').Value := anID;
      memBrand.FieldByName('Brand_id').Value := aBrandID;
      memBrand.Post;

      insertQuery.Parameters[0].Value := anID;
      insertQuery.Parameters[1].Value := aBrandID;
      insertQuery.Parameters[2].Value := memBrand.FieldByName('Description').Value;
      insertQuery.Execute;
      {
      Brand.Append;
      Brand.FieldByName('ID').Value := anID;
      Brand.FieldByName('Brand_id').Value := aBrandID;
      Brand.FieldByName('Description').Value := memBrand.FieldByName('Description').Value;
      Brand.Post;
      }
      memBrand.Next;

      Inc(i);
      if i mod 10 = 0 then
        UpdateProgress(i * 100 div iMax, 'Перенумерация классификатора [брэнды]...');
      if fAborted then
        Exit;
    end;
    ExecuteQuery('SET IDENTITY_INSERT BRANDS OFF ', []);

    
//*** группы *** 

    if fUseRelease then
    begin
      aNewID := GetLastTableID(fReleasePrefix + 'GROUPS', 'ID');
      aNewGroupID := GetLastTableID(fReleasePrefix + 'GROUPS', 'GROUP_ID');
      aNewSubGroupID := GetLastTableID(fReleasePrefix + 'GROUPS', 'SUBGROUP_ID');
    end
    else
    begin
      aNewID := 0;
      aNewGroupID := 0;
      aNewSubGroupID := 0;
    end;

    ExecuteQuery('SET IDENTITY_INSERT GROUPS ON ', []);
    insertQuery.CommandText :=
      ' INSERT INTO GROUPS ( id,  Group_id,  Subgroup_id,  Group_descr,  Subgroup_descr) ' +
      '             VALUES (:id, :Group_id, :Subgroup_id, :Group_descr, :Subgroup_descr)';
    insertQuery.Prepared := True;

    memGroup.IndexName := 'GrDescr';
    memGroup.First;
    i := 1;
    iPos := 0;
    iMax := memGroup.RecordCount;
    while not memGroup.Eof do
    begin
      aGroup := memGroup.FieldByName('Group_descr').AsString;
      j := 1;
      aGroupID := -1;
      while (not memGroup.Eof) and (memGroup.FieldByName('Group_descr').AsString = aGroup) do
      begin
        if fUseRelease and memGroupPrev.FindKey([memGroup.FieldByName('Group_descr').Value, memGroup.FieldByName('Subgroup_descr').Value]) then
        begin
          anID := memGroupPrev.FieldByName('ID').AsInteger;
          aGroupID := memGroupPrev.FieldByName('GROUP_ID').AsInteger;
          aSubGroupID := memGroupPrev.FieldByName('SUBGROUP_ID').AsInteger;
        end
        else
        begin
          Inc(aNewID);
          anID := aNewID;
          
          if fUseRelease and memGroupPrev.FindKey([memGroup.FieldByName('Group_descr').Value]) then
            aGroupID := memGroupPrev.FieldByName('GROUP_ID').AsInteger;

            
          
          if aGroupID = -1 then
          begin
            Inc(aNewGroupID);
            aGroupID := aNewGroupID;
          end;
          

          Inc(aNewSubGroupID);
          aSubGroupID := aNewSubGroupID;
        end;


        memGroup.Edit;
        memGroup.FieldByName('id').Value := anID;
        memGroup.FieldByName('Group_id').Value := aGroupID;
        memGroup.FieldByname('Subgroup_id').Value := aSubGroupID;
        memGroup.Post;

        insertQuery.Parameters[0].Value := anID;
        insertQuery.Parameters[1].Value := aGroupID;
        insertQuery.Parameters[2].Value := aSubGroupID;
        insertQuery.Parameters[3].Value := memGroup.FieldByName('Group_descr').Value;
        insertQuery.Parameters[4].Value := memGroup.FieldByname('Subgroup_descr').Value;
        insertQuery.Execute;
        {
        Group.Append;
        Group.FieldByName('ID').Value := anID;
        Group.FieldByName('Group_id').Value := aGroupID;
        Group.FieldByname('Subgroup_id').Value := aSubGroupID;
        Group.FieldByName('Group_descr').Value := memGroup.FieldByName('Group_descr').Value;
        Group.FieldByname('Subgroup_descr').Value := memGroup.FieldByname('Subgroup_descr').Value;
        Group.Post;
        }
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
    ExecuteQuery('SET IDENTITY_INSERT GROUPS OFF ', []);

  finally
    aReader.Free;
    Brand.Close;
    Group.Close;

    if fUseRelease then
    begin
      memBrandPrev.Close;
      memGroupPrev.Close;
    end;
  end;
end;

procedure TFormMain.LoadTitles(aCatID: integer);
var
  i, gr, sgr, br: integer;
  aQuery: TAdoQuery;
  aNewID, aGBID: Integer;
  s: string;
begin
  i := aCatID + 1;

  ClearTable('GROUPBRAND');
  if fUseRelease then
    aNewID := GetLastTableID(fReleasePrefix + 'GROUPBRAND', 'ID')
  else
    aNewID := 0;

  ExecuteQuery('SET IDENTITY_INSERT [GROUPBRAND] ON ', []);
  aQuery := TADOQuery.Create(nil);
  try
    //aQuery.CursorLocation := clUseServer;
    //aQuery.CursorType := ctOpenForwardOnly;
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := ' select distinct Group_id, Subgroup_id, Brand_id from [catalog] ';
    aQuery.Open;

    while not aQuery.Eof do
    begin
      aGBID := -1;
      if fUseRelease then
      begin
        s := ExecuteSimpleSelectMS(
          ' SELECT ID FROM [' + fReleasePrefix + 'GROUPBRAND] ' +
          ' WHERE Group_id = :Group_id AND Subgroup_id = :Subgroup_id AND Brand_id = :Brand_id ',
          [aQuery.Fields[0].AsInteger, aQuery.Fields[1].AsInteger, aQuery.Fields[2].AsInteger]
        );
        aGBID := StrToIntDef(s, -1);
      end;

      if aGBID = -1 then
      begin
        Inc(aNewID);
        aGBID := aNewID;
      end;

      ExecuteQuery(
        ' INSERT INTO GROUPBRAND (id, Group_id, Subgroup_id, Brand_id) VALUES (:id, :Group_id, :Subgroup_id, :Brand_id)',
        [aGBID, aQuery.Fields[0].AsInteger, aQuery.Fields[1].AsInteger, aQuery.Fields[2].AsInteger]
      );

      aQuery.Next;
    end;
    aQuery.Close;
  finally
    aQuery.Free;
  end;
  ExecuteQuery('SET IDENTITY_INSERT [GROUPBRAND] OFF ', []);
{
  ExecuteQuery(
    ' insert into groupbrand (Group_id, Subgroup_id, Brand_id) ' +
    ' select distinct Group_id, Subgroup_id, Brand_id from catalog ',
    []
  );
}  

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
              [i, gr, sgr, br, memGroup.FieldByName('Subgroup_descr').AsString, 0, 1, 1]
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

procedure TFormMain.CreateAllTables(aForce: Boolean; const aPrefix: string);
var
  i: Integer;
  aSQL: TStrings;
  aSQLPart: string;
begin
  aSQL := TStringList.Create;
  try
    aSQL.Text := MemoCreateTemplate.Text;

    for i := Low(cSrezTables) to High(cSrezTables) do
      aSQL.Text := StringReplace(aSQL.Text, '#' + cSrezTables[i] + '#', aPrefix + cSrezTables[i], [rfReplaceAll]);

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

procedure TFormMain.DeleteAllTables(const aPrefix: string);
var
  i: Integer;
begin
  for i := Low(cSrezTables) to High(cSrezTables) do
    if IsTableExists(aPrefix + cSrezTables[i]) then
      FormMain.ExecuteQuery('DROP TABLE [' + aPrefix + cSrezTables[i] + ']', []);
end;

procedure TFormMain.RenameAllTables(const aOldPrefix, aNewPrefix: string);
var
  i: Integer;
begin
  for i := Low(cSrezTables) to High(cSrezTables) do
    if IsTableExists(aOldPrefix + cSrezTables[i]) then
      RenameTable(aOldPrefix + cSrezTables[i], aNewPrefix + cSrezTables[i]);
end;

procedure TFormMain.LoadAnalogs(const aFileName: string);

  //скрываем все бренды, кот нет в каталоге
 { function IsBrandLockedNew(const aBrand: string): Boolean;
  begin
    Result := not memBrand.Locate('DESCRIPTION', AnsiUpperCase(aBrand), []);
  end; }
  
var
  i: integer;
  cat_br_str, an_br_str, cat_code, an_code: string;
  cat_br_id, an_br_id, cat_id, an_id: integer;
  aID, aNewID: Integer;
  anInsBrand: string;
  anInsLocked: Integer;

  Prev_cat_br_id: Integer;
  Prev_cat_br_str: string;

  Prev_cat_id: Integer;
  Prev_cat_code: string;

  Prev_an_br_str: string;
  Prev_an_br_id: Integer;

  str2Write: string;

  procedure AddToTable;
  begin
    if cat_br_str = Prev_cat_br_str then
      cat_br_id := Prev_cat_br_id
    else
    begin
      if memBrand.Locate('DESCRIPTION', AnsiUpperCase(cat_br_str), []) then
        cat_br_id := memBrand.FieldByName('Brand_id').AsInteger
      else
        cat_br_id := 0;

      Prev_cat_br_str := cat_br_str;
      Prev_cat_br_id := cat_br_id;
    end;

{    if An_br_str = Prev_an_br_str then
      an_br_id := Prev_an_br_id
    else
    begin
      if memBrand.Locate('DESCRIPTION', AnsiUpperCase(An_br_str), []) then
        an_br_id := memBrand.FieldByName('Brand_id').AsInteger
      else
        an_br_id := 0;

      Prev_an_br_str := an_br_str;
      Prev_an_br_id := an_br_id;
    end; }
    if memBrand.Locate('DESCRIPTION', AnsiUpperCase(An_br_str), []) then
      an_br_id := memBrand.FieldByName('Brand_id').AsInteger
    else
      an_br_id := 0;


    if cat_code = Prev_cat_code then
      cat_id := Prev_cat_id
    else
    begin
      if memCatalog.FindKey([MakeSearchCode(cat_code), cat_br_id]) then
        cat_id := memCatalog.FieldByName('CAT_ID').AsInteger
      else
        cat_id := 0;

      Prev_cat_code := cat_code;
      Prev_cat_id := cat_id;
    end;

    if memCatalog.FindKey([MakeSearchCode(an_code), an_br_id]) then
      an_id := memCatalog.FieldByName('CAT_ID').AsInteger
    else
      an_id := 0;


    if cat_id = 0 then
    begin
      if (an_id <> 0) then
      begin
        if not memAnalog.FindKey([an_id, AnsiUpperCase(cat_code)]) then
        begin
          //if IsBrandLocked(Cat_br_str) then
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

          //получить ID из релиза
          if fUseRelease and memAnalogPrev.Locate('Cat_id;An_Code;An_Brand', VarArrayOf([an_id, AnsiUpperCase(cat_code), AnsiUpperCase(anInsBrand)]), []) then
            aID := memAnalogPrev.FieldByName('ID').AsInteger
          else
          begin
            Inc(aNewID);
            aID := aNewID;
          end;

          insertQuery.Parameters[0].Value := aID;
          insertQuery.Parameters[1].Value := an_id;
          insertQuery.Parameters[2].Value := cat_code;
          insertQuery.Parameters[3].Value := CreateShortCode(cat_code);
          insertQuery.Parameters[4].Value := 0;
          insertQuery.Parameters[5].Value := anInsBrand;
          insertQuery.Parameters[6].Value := anInsLocked;
          insertQuery.Execute;

          memAnalog.Append;
          memAnalog.FieldByName('ID').AsInteger := aID;
          memAnalog.FieldByName('CAT_ID').AsInteger := an_id;
          memAnalog.FieldByName('AN_CODE').AsString := AnsiUpperCase(cat_code); //AnsiUpperCase - чтобы не делать нечувствительный индекс

          memAnalog.Post;
        end
      end;
    end

    else
    begin
      if not memAnalog.FindKey([cat_id, AnsiUpperCase(an_code)]) then
      begin
        //if IsBrandLocked(Cat_br_str) then
        if IsBrandLocked(an_br_str) then
        begin
          anInsBrand := '';
          anInsLocked := 1;
        end
        else
        begin
          anInsBrand := an_br_str;
          anInsLocked := 0;
        end;

        //получить ID из релиза
        if fUseRelease and memAnalogPrev.Locate('Cat_id;An_Code;An_Brand', VarArrayOf([cat_id, AnsiUpperCase(an_code), AnsiUpperCase(anInsBrand)]), []) then
          aID := memAnalogPrev.FieldByName('ID').AsInteger
        else
        begin
          Inc(aNewID);
          aID := aNewID;
        end;

        insertQuery.Parameters[0].Value := aID;
        insertQuery.Parameters[1].Value := cat_id;
        insertQuery.Parameters[2].Value := an_code;
        insertQuery.Parameters[3].Value := CreateShortCode(an_code);
        insertQuery.Parameters[4].Value := an_id;
        insertQuery.Parameters[5].Value := anInsBrand;
        insertQuery.Parameters[6].Value := anInsLocked;
        insertQuery.Execute;

        memAnalog.Append;
        memAnalog.FieldByName('ID').AsInteger := aID;
        memAnalog.FieldByName('CAT_ID').AsInteger := cat_id;
        memAnalog.FieldByName('AN_CODE').AsString := AnsiUpperCase(an_code); //AnsiUpperCase - чтобы не делать нечувствительный индекс
        memAnalog.Post;     

      end
    end;
  end;

var
  aReader: TCSVReader;
  aExceptionText: string;
  aFileNameEnd: string;
begin
  aFileNameEnd := aFileName;
  WriteBuildLog('Загрузка аналогов из ' + aFileNameEnd);
  UpdateProgress(0, 'Загрузка аналогов...');

  if not LoadLockedBrands then
    raise Exception.Create('Файл LockedBrand.txt не найден!');

  if fUseRelease then
  begin
    //ExportLockedAnalogs(fReleasePrefix, GetAppDir + cLockedAnalogsFileName, aFileName);
    //aFileNameEnd := GetAppDir + cLockedAnalogsFileName;
    CacheAnalogEx(fReleasePrefix, memAnalogPrev, True);
    memAnalogPrev.IndexName := 'IDCODE';
    memAnalogPrev.Open;

    aNewID := GetLastTableID(fReleasePrefix + 'ANALOG', 'ID')
  end
  else
    aNewID := 0;

  insertQuery.CommandText :=
    'INSERT INTO ANALOG ( ID,  CAT_ID,  AN_CODE,  AN_SHORTCODE,  AN_ID,  AN_BRAND,  LOCKED) ' +
    '            VALUES (:ID, :CAT_ID, :AN_CODE, :AN_SHORTCODE, :AN_ID, :AN_BRAND, :LOCKED)';
  insertQuery.Prepared := True;

  ClearTable('ANALOG');
  CacheAnalog(True);
  memAnalog.IndexName := 'IDCODE';
  memAnalog.Open;

  CacheCatalog;
  memCatalog.IndexName := 'CODE2BRAND';
  memCatalog.Open;

  CacheBrand;
  memBrand.Open;

  ExecuteQuery('SET IDENTITY_INSERT ANALOG ON ', []);
  aReader := TCSVReader.Create;
  try
    i := 0;
    Prev_cat_code := '';
    Prev_cat_br_str := '';

    //aReader.DosToAnsiEncode := True;
    aReader.Open(aFileNameEnd);

    while not aReader.Eof do
    begin
      aReader.ReturnLine;

      cat_br_str := aReader.Fields[0];
      if cat_br_str = 'RENAU' then
        cat_br_str := 'RENAULT';
      if cat_br_str = 'MITSU' then
        cat_br_str := 'MITSUBISHI';

      
      cat_code   := aReader.Fields[1];
      an_br_str  := aReader.Fields[2];
      if an_br_str = 'RENAU' then
        an_br_str := 'RENAULT';
      if an_br_str = 'MITSU' then
        an_br_str := 'MITSUBISHI';
        
      an_code    := aReader.Fields[3];
      try
        if not SameText(Copy(an_br_str, 1, 7), 'Ошибка!') then
          AddToTable
        else
          WriteBuildLog('Кривой брэнд аналога в строке: ' + aReader.CurrentLine);
      except
        on E: Exception do
        begin
          aExceptionText := '!Exception: ' + E.Message + #13#10'в строке: ' + aReader.CurrentLine;
          WriteBuildLog(aExceptionText);
          //raise;
        end;
      end;
{
      if (Length(cat_br_str)> 49) or
      (Length(cat_code)> 49) or
      (Length(an_br_str)> 49) or
      (Length(an_code)> 49) then
      Memo1.Lines.add(aReader.CurrentLine);
}
      Inc(i);

      if i mod 1000 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Загрузка аналогов... ' + IntToStr(i));
      if fAborted then
        Break;
    end;
    aReader.Close;
    
  finally
    aReader.Free;
    ExecuteQuery('SET IDENTITY_INSERT ANALOG OFF ', []);
    Brand.Close;

    if fAborted then
      WriteBuildLog('...прервано пользователем'#13#10)
    else
      WriteBuildLog('...загружено'#13#10);

    if fUseRelease then
      memAnalogPrev.Close;
    memCatalog.Close;
    memAnalog.Close;
  end;
end;

procedure TFormMain.LoadAnalogsNew(const aFileName: string);
var
s:tstrings;
aQuery: tadoquery;
b,e: cardinal;
sLockedBrands, sMaxGenAnId: string;

  function modifyAnalogFile4BulkInsert(const aFileNameServ, aNewFileNameLocal : string): bool;
  var
    aReader: TCSVReader;
    F: textfile;
    str: TStringList;
    buf, short_cat_code, short_an_code, an_br_descr, cat_br_descr, locked: string;

  begin
    WriteBuildLog(' Rename Analog ');
    aReader := TCSVReader.Create;
    str := TStringList.Create;
    AssignFile(F, aNewFileNameLocal);

    try
      aReader.Open(aFileNameServ);
      Rewrite(F);

      while not aReader.Eof do
      begin
        aReader.ReturnLine;
        short_cat_code := StringReplace(StringReplace(aReader.Fields[1], ' ', '', [rfReplaceAll]), '_', '', [rfReplaceAll]);
        short_an_code := StringReplace(StringReplace(aReader.Fields[3], ' ', '', [rfReplaceAll]), '_', '', [rfReplaceAll]);

        cat_br_descr := aReader.Fields[0];
        an_br_descr := aReader.Fields[2];
        locked := '0';

        if IsBrandLocked(aReader.Fields[0]) then
        begin
          cat_br_descr := '';
          locked := '1';
        end;
        if IsBrandLocked(aReader.Fields[2]) then
        begin
          an_br_descr := '';
          locked := '1';
        end;

        str.Append(cat_br_descr   + ';' + aReader.Fields[1] + ';' +
                   an_br_descr    + ';' + aReader.Fields[3] + ';' +
                   short_cat_code + ';' + short_an_code     + ';' +
                   locked);

        if str.Count mod 1000 = 0 then
        begin
          Write(F, str.Text);
          str.Clear;
        end;
      end;
      if str.Count > 0 then
        Writeln(F, str.Text);

    finally
      aReader.Free;
      str.Free;
      CloseFile(F);
    end;

    RenameFile(aFileNameServ, aFileNameServ + '_Old');
    RenameFile(aNewFileNameLocal, aFileNameServ);
    WriteBuildLog(' Rename Analog --- OK!!!');
  end;                                                                            

begin
  
//fBuildInfo.Version
//fBuildInfo.ParentVersion
  WriteBuildLog('Загрузка аналогов из ' + aFileName);
  UpdateProgress(0, 'Загрузка аналогов...');
  if not LoadLockedBrands then
    raise Exception.Create('Файл LockedBrand.txt не найден!');
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := connService;
    aQuery.CommandTimeout := 1600;
    WriteBuildLog(' Поиск MAX(GEN_AN_ID) ');
    aQuery.SQL.Clear;
    aQuery.SQL.Text := ' SELECT max(gen_an_id) FROM [FULL_ANALOG_' + fBuildInfo.ParentVersion + ']';
    aQuery.Open;
    if not aQuery.Eof then
      sMaxGenAnId := aQuery.Fields[0].AsString;

    try
      aQuery.sql.Clear;
      aQuery.SQL.Text := 'DROP TABLE [ANALOG_BUF]';
      aQuery.ExecSQL;
    except
      WriteBuildLog(' !!! EXCEPTION !!! -> DROP [ANALOG_BUF] ');
    end;

    try
      WriteBuildLog(' CREATE [ANALOG_BUF] ');
      aQuery.sql.Clear;
      aQuery.SQL.Text := ' CREATE TABLE [ANALOG_BUF]( ' +
                         ' [cat_br_descr] [varchar](50) DEFAULT ('''') NOT NULL, ' +
                         ' [cat_code] [varchar](50) NULL, ' +
                         ' [an_br_descr] [varchar](50) DEFAULT ('''') NOT NULL, ' +
                         ' [an_code] [varchar](50) NULL, ' +
                         ' [short_cat_code] [varchar](50) NULL, ' +
                         ' [short_an_code] [varchar](50) NULL, ' +
                         ' [locked] [smallint] DEFAULT ((0)) NOT NULL , ' +
                         ' [gen_an_id] [int] NULL ' +
                         ') ON [PRIMARY]; ';
      aQuery.ExecSQL;
    except
        on E: Exception do
        begin
          WriteBuildLog(' !!! EXCEPTION !!! -> CREATE [ANALOG_BUF] ' + '!Exception: ' + E.Message);
          raise;
        end;


    end;

    modifyAnalogFile4BulkInsert(aFileName, aFileName+ '_fix_');

    try
      aQuery.SQL.Clear;
      WriteBuildLog(' Массовый импорт в ANALOG_BUF ');
      aQuery.SQL.Text := ' BULK INSERT [ANALOG_BUF] ' +
                         ' FROM ''' + aFileName + '''' +
                         ' WITH (FORMATFILE = ''' + ExtractFilePath(Application.ExeName) + cFormatBulkInsertFileName  + ''')';
      aQuery.ExecSQL;
    except
        on E: Exception do
        begin
          WriteBuildLog(' !!! EXCEPTION !!! -> BULK INSERT [ANALOG_BUF] ' + '!Exception: ' + E.Message);
          raise;
        end;
    end;
    {
    WriteBuildLog(' Добавление ShorCode ');
    aQuery.SQL.Text := ' UPDATE [ANALOG_BUF] SET short_cat_code = replace(replace(cat_code,:prob,:free), :par1, :free) , short_an_code = replace(replace(an_code,:prob,:free), :par1, :free) ';
    aQuery.SQL.Text := StringReplace(aQuery.SQL.Text,':prob', ''' ''', [rfReplaceAll]);
    aQuery.SQL.Text := StringReplace(aQuery.SQL.Text,':free', '''''', [rfReplaceAll]);
    aQuery.SQL.Text := StringReplace(aQuery.SQL.Text,':par1', '''_''', [rfReplaceAll]);
    aQuery.ExecSQL;

    aQuery.sql.Clear;
    WriteBuildLog(' Блокировка запрещенных брендов аналогов ');
    aQuery.SQL.Text := ' UPDATE [ANALOG_BUF] SET cat_br_descr = '''', locked = 1 WHERE cat_br_descr in ' + sLockedBrands;
    aQuery.ExecSQL;
    aQuery.sql.Clear;
    aQuery.SQL.Text := ' UPDATE [ANALOG_BUF] SET an_br_descr = '''',  locked = 1 WHERE an_br_descr in ' + sLockedBrands;
    aQuery.ExecSQL;
      }
    try
      WriteBuildLog(' DROP [FULL_ANALOG_' + fBuildInfo.Version + ']');
      aQuery.sql.Clear;
      aQuery.SQL.Text := 'DROP TABLE [FULL_ANALOG_' + fBuildInfo.Version + ']';
      aQuery.ExecSQL;
    except
      WriteBuildLog(' !!! EXCEPTION !!! -> DROP [FULL_ANALOG_' + fBuildInfo.Version + ']');
    end;

    aQuery.sql.Clear;
    WriteBuildLog(' Импорт в [FULL_ANALOG_' + fBuildInfo.Version + ']');
    aQuery.SQL.Text :=
           ' SELECT t.cat_id, t.an_code , t.an_brand, t.an_id, t.locked, a.gen_an_id ' +
           ' INTO [FULL_ANALOG_' + fBuildInfo.Version + ']' +
           ' FROM [FULL_ANALOG_' + fBuildInfo.ParentVersion + ']'+ ' a RIGHT JOIN ( ' +
           '      SELECT c1.Cat_id as cat_id, a.cat_code as an_code , a.cat_br_descr as an_brand, 0 as an_id, a.locked, a.gen_an_id ' +
           '      FROM [ANALOG_BUF] a '+
           '        LEFT JOIN [BRANDS] b on  (b.description = a.cat_br_descr) '+
           '        LEFT JOIN [catalog]c on  (c.code2 = a.short_cat_code and c.brand_id = b.brand_id) '+
           '        LEFT JOIN [BRANDS] b1 on  (b1.description = a.an_br_descr) '+
           '        LEFT JOIN [catalog] c1 on  (c1.code2 = a.short_an_code and c1.brand_id = b1.brand_id) '+
           '      WHERE c.code is NULL and c1.Cat_id is NOT NULL ' +
           '      UNION ' +
           '      SELECT c.Cat_id, a.an_code, a.an_br_descr, COALESCE(c1.cat_id,0), a.locked, a.gen_an_id '+
           '      FROM [ANALOG_BUF] a ' +
           '        LEFT JOIN [BRANDS] b on  (b.description = a.cat_br_descr) '+
           '        LEFT JOIN [catalog]c on  (c.code2 = a.short_cat_code and c.brand_id = b.brand_id) '+
           '        LEFT JOIN [BRANDS] b1 on  (b1.description = a.an_br_descr) '+
           '        LEFT JOIN [catalog] c1 on  (c1.code2 = a.short_an_code and c1.brand_id = b1.brand_id) '+
           '      WHERE c.Cat_id is NOT NULL '+
           '      )t on (a.cat_id = t.cat_id and a.an_code = t.an_code and a.an_brand = t.an_brand and t.an_id = a.an_id) ';
    aQuery.ExecSQL;

    aQuery.sql.Clear;
    WriteBuildLog(' Генерируем GEN_AN_ID в [FULL_ANALOG_' + fBuildInfo.Version + ']');
    aQuery.SQL.Text :=
           ' UPDATE [FULL_ANALOG_' + fBuildInfo.Version + ']' +
           ' SET gen_an_id = COALESCE(gen_an_id,(SELECT MAX(gen_an_id) ' +
           '                                     FROM [FULL_ANALOG_' + fBuildInfo.Version + '] an ' +
           '                                     WHERE An.gen_an_id is not null and ' +
           '                                     [FULL_ANALOG_' + fBuildInfo.Version + '].an_code = An.An_code and ' +
           '                                     [FULL_ANALOG_' + fBuildInfo.Version + '].an_brand = An.an_brand and ' +
           '                                     [FULL_ANALOG_' + fBuildInfo.Version + '].an_id = An.an_id) ' +
           '                          )WHERE gen_an_id is NULL ';

    aQuery.ExecSQL;
       
    aQuery.SQL.Clear;
    WriteBuildLog(' Генерируем GEN_AN_ID в [FULL_ANALOG_' + fBuildInfo.Version + ']');
    aQuery.SQL.Text :=
           ' UPDATE [FULL_ANALOG_' + fBuildInfo.Version + ']' +
           ' SET gen_an_id = ' + sMaxGenAnId +  ' + rez.rown ' +
           ' FROM (select ' +
           ' 		a.an_code, ' +
           ' 		a.an_brand, ' +
           ' 		a.an_id,' +
           ' 		a.gen_an_id, ' +
           ' 		row_number() over (order by a.an_code, ' +
           ' 		a.an_brand, '+
           ' 		a.an_id, '+
           ' 		a.gen_an_id) as rown ' +
           ' 	FROM ' +
           ' 		[FULL_ANALOG_' + fBuildInfo.Version + '] as a ' +
           ' 	GROUP BY ' +
           ' 		a.an_code, ' +
           ' 		a.an_brand, ' +
           ' 		a.an_id, ' +
           ' 		a.gen_an_id ' +
           '	 HAVING ' +
           '	  	a.gen_an_id IS NULL) rez ' +
           '  WHERE ' +
           '	 rez.an_code = [FULL_ANALOG_' + fBuildInfo.Version + '].an_code and ' +
           '	 rez.an_brand = [FULL_ANALOG_' + fBuildInfo.Version + '].an_brand and ' +
           '	 rez.an_id = [FULL_ANALOG_' + fBuildInfo.Version + '].an_id ';
    aQuery.ExecSQL;             
    WriteBuildLog(' Успешно завершено!!!!!!!!!!');

  finally
    aQuery.Free;
  end;

end;

procedure TFormMain.LoadOE(const aFileName: string);
var
  i, brand_id, aID, aNewID: Integer;
  cb, cat_code, cat_brand, oe_code, short_oe_code: string;
  prevBrand: string;
  prevBrandID: Integer;



  procedure AddToTable;
  begin
    if Cat_brand = prevBrand then
      brand_id := prevBrandID
    else
    begin
      if memBrand.Locate('DESCRIPTION', AnsiUpperCase(Cat_brand), []) then
        brand_id := memBrand.FieldByName('Brand_id').AsInteger
      else
      begin
        //WLog('Бренд не распознан <' + Cat_brand + '> в строке ' + IntToStr(i));
        brand_id := 0;
      end;
      prevBrand := Cat_brand;
      prevBrandID := brand_id;
    end;

    //oe_code - alwais uppercase
    if memCatalog.FindKey([cat_code, brand_id]) then
    begin
      if (not memOE.FindKey([memCatalog.FieldByName('Cat_id').AsInteger, oe_code])) then
      begin
        if fUseRelease and memOEPrev.FindKey([memCatalog.FieldByName('Cat_id').AsInteger, oe_code]) then
          aID := memOEPrev.FieldByName('ID').AsInteger
        else
        begin
          Inc(aNewID);
          aID := aNewID;
        end;

        insertQuery.Parameters[0].Value := aID;
        insertQuery.Parameters[1].Value := memCatalog.FieldByName('Cat_id').AsInteger;
        insertQuery.Parameters[2].Value := oe_code;
        insertQuery.Parameters[3].Value := MakesearchCode(oe_code);
        insertQuery.Parameters[4].Value := short_oe_code;
        insertQuery.Execute;

        memOE.Append;
        memOE.FieldByName('ID').AsInteger := aID;
        memOE.FieldByName('CAT_ID').AsInteger := memCatalog.FieldByName('Cat_id').AsInteger;
        memOE.FieldByName('CODE').AsString := oe_code;
        memOE.Post;
      end;
    end
    else
    begin
      //WLog('Поз. не найдена <' + Cat_code + ' / ' + Cat_brand + '> в строке ' + IntToStr(i));
    end;
  end;

var
  aReader: TCSVReader;
begin
  WriteBuildLog('Загрузка OE из ' + aFileName);
  UpdateProgress(0, 'Загрузка OE...');

  if fUseRelease then
  begin
    CacheOeEx(fReleasePrefix, memOePrev, True);
    memOePrev.IndexName := 'CODE';
    memOePrev.Open;
    aNewID := GetLastTableID(fReleasePrefix + 'OE', 'ID')
  end
  else
    aNewID := 0;

  insertQuery.CommandText :=
    ' INSERT INTO OE ( ID,  CAT_ID,  CODE,  CODE2,  SHORTOE) ' +
    '         VALUES (:ID, :CAT_ID, :CODE, :CODE2, :SHORTOE) ';
  insertQuery.Prepared := True;

  ClearTable('OE');
  CacheOE(True);
  memOE.IndexName := 'CODE';
  memOE.Open;

  CacheCatalog;
  memCatalog.IndexName := 'CODE2BRAND';
  memCatalog.Open;

  CacheBrand;
  memBrand.Open;

  ExecuteQuery('SET IDENTITY_INSERT OE ON ', []);
  aReader := TCSVReader.Create;
  try
    i := 0;
    //aReader.DosToAnsiEncode := True;
    aReader.Open(aFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      cb := aReader.Fields[0];
      DecodeCodeBrand(cb, cat_code, cat_brand);
      //cat_brand := GetReplBrand(cat_brand); //тут может быть тикдочный бренд
      oe_code := AnsiUpperCase(aReader.Fields[1]);
      short_oe_code := CreateShortCode(oe_code);
      if (short_oe_code <> '') and (cat_code <> '') then
        AddToTable;

      Inc(i);

      if i mod 1000 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Загрузка ОЕ... ' + IntToStr(i));
      if fAborted then
        Break;
    end;

  finally
    ExecuteQuery('SET IDENTITY_INSERT OE OFF ', []);
    aReader.Free;

    if fAborted then
      WriteBuildLog('...прервано пользователем'#13#10)
    else
      WriteBuildLog('...загружено'#13#10);

    if fUseRelease then
      memOEPrev.Close;

    memOE.Close;
    memBrand.Close;
    memCatalog.Close;
  end;
end;

procedure TFormMain.LoadOENew;
var
  aQuery: tadoquery;
  sMaxGenOEId: string;
begin
    aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := connService;
    aQuery.CommandTimeout := 600;

    try
      aQuery.SQL.Text := ' DROP TABLE [OE_BUF_' + fBuildInfo.Version + ']';
      aQuery.ExecSQL;
    except
      //>>
    end;

    WriteBuildLog(' Импорт ОЕ...');
    aQuery.SQL.Clear;
    aQuery.SQL.Text :=
       ' select dOE.Cat_id, dOE.code, dOE.shortOE, noe.gen_oe_id ' +
       ' into [OE_BUF_' + fBuildInfo.Version + ']' +
       ' from [OE] dOE ' +
       ' left join [OE_BUF_' + fBuildInfo.ParentVersion + '] nOE on (noe.cat_id = dOE.CAT_ID and doe.CODE = noe.CODE) ';
    aQuery.ExecSQL;

    WriteBuildLog(' Поиск MAX(GEN_ОЕ_ID) ');
    aQuery.SQL.Clear;
    aQuery.SQL.Text := ' SELECT MAX(gen_oe_id) FROM [OE_BUF_' + fBuildInfo.Version + ']';
    aQuery.Open;
    if not aQuery.Eof then
      sMaxGenOEId :=  aQuery.Fields[0].AsString
    else
      sMaxGenOEId := '0';

    aQuery.sql.Clear;
    WriteBuildLog(' Генерируем GEN_OE_ID в [OE_BUF_' + fBuildInfo.Version + ']');
    aQuery.SQL.Text :=
           ' UPDATE [OE_BUF_' + fBuildInfo.Version + ']' +
           ' SET gen_oe_id = COALESCE(gen_oe_id,(SELECT MAX(gen_oe_id) ' +
           '                                     FROM [OE_BUF_' + fBuildInfo.Version + '] oe ' +
           '                                     WHERE oe.gen_oe_id is not null and ' +
           '                                     [OE_BUF_' + fBuildInfo.Version + '].code = oe.code and ' +
           '                                     [OE_BUF_' + fBuildInfo.Version + '].ShortOE = oe.ShortOE ' +
           '                          ))WHERE gen_oe_id is NULL ';

    aQuery.ExecSQL;
       
    aQuery.SQL.Clear;
    WriteBuildLog(' Генерируем GEN_OE_ID в [OE_BUF_' + fBuildInfo.Version + ']');
    aQuery.SQL.Text :=
           ' UPDATE [OE_BUF_' + fBuildInfo.Version + ']' +
           ' SET gen_oe_id = ' + sMaxGenOEId +  ' + rez.rown ' +
           ' FROM (select ' +
           ' 		a.code, ' +
           ' 		a.ShortOE, ' +
           ' 		a.gen_oe_id, ' +
           ' 		row_number() over (order by a.code, ' +
           ' 		a.ShortOE, '+
           ' 		a.gen_oe_id) as rown ' +
           ' 	FROM ' +
           ' 		[OE_BUF_' + fBuildInfo.Version + '] as a ' +
           ' 	GROUP BY ' +
           ' 		a.code, ' +
           ' 		a.ShortOE, ' +
           ' 		a.gen_oe_id ' +
           '	 HAVING ' +
           '	  	a.gen_oe_id IS NULL) rez ' +
           '  WHERE ' +
           '	 rez.code = [OE_BUF_' + fBuildInfo.Version + '].code and ' +
           '	 rez.ShortOE = [OE_BUF_' + fBuildInfo.Version + '].ShortOE ';
    aQuery.ExecSQL;             
    WriteBuildLog(' Успешно завершено!!!!!!!!!!');

  finally
    aQuery.Free;
  end;

end;

procedure TFormMain.LoadPrice(const aFileName, FieldName, MsgRegion: string);
var
  aReader: TCSVReader;
  Code2, NextBrandDescr, BrandDescr: string;
  Brand_Id, cat_id, i, iMax: integer;
  fLocateBrand: Boolean;
begin
  WriteBuildLog(MsgRegion);
  aReader := TCSVReader.Create;
  CacheBrand;
  CacheCatalog;
  memBrand.Open;
  memCatalog.Open;
  aReader.Open(aFileName);
  i := 0;
  iMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT COUNT (ID) FROM CATALOG WHERE CODE2 <> '''' AND CODE2 IS NOT NULL', []), 0);
  try
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      DecodeCodeBrand(aReader.Fields[0], Code2, NextBrandDescr, TRUE);
      if BrandDescr <> NextBrandDescr then
      begin
        BrandDescr := NextBrandDescr;
        fLocateBrand := true;
      end
      else
        fLocateBrand := False;

      insertQuery.CommandText := ' UPDATE [CATALOG] SET ' + FieldName + ' = :Price WHERE cat_id = :ID ';
      insertQuery.Prepared := True;
      try
        if fLocateBrand then
        begin
          if memBrand.Locate('DESCRIPTION', BrandDescr, []) then
            Brand_Id := memBrand.FieldByName('brand_id').AsInteger
          else
            Brand_Id := 0;
        end;

        if memCatalog.Locate('CODE2;BRAND_ID', VarArrayOf([Code2,Brand_id]), []) then
          Cat_id := memCatalog.FieldByName('cat_id').AsInteger
        else
          Cat_id := 0;

        insertQuery.Parameters[0].Value := StrToFloatDefUnic(aReader.Fields[2], 0);
        insertQuery.Parameters[1].Value := Cat_id;
        insertQuery.Execute;
        Inc(i);
        if i mod 1000 = 0 then
          UpdateProgress(i * 100 div iMax,MsgRegion + IntToStr(i) + ' из ' + IntToStr(iMax));
        if fAborted then
         Break;

      except
        on E: Exception do
        begin
          WriteBuildLog('!Exception: ' + E.Message + ' в строке "' + aReader.CurrentLine + '"');
          raise;
        end;
      end;
    end;//end while
  finally
    memBrand.Close;
    memCatalog.Close;
    if fAborted then
      WriteBuildLog('...прервано пользователем'#13#10)
    else
      WriteBuildLog('...загружен'#13#10);
    aReader.Free;
  end;
end;


procedure TFormMain.LoadKIT(const aFileName: string);
var
  i, cat_id, brand_id, child_cat_id, child_brand_id, aID, aNewID: Integer;
  cat_code, cat_brand, child_code, child_brand: string;
  aQuantity: Integer;
  prevBrand: string;
  prevBrandID: Integer;


  procedure AddToTable;
  begin
    //поиск кода комплекта в каталоге
    if Cat_brand = prevBrand then
      brand_id := prevBrandID
    else
    begin
      if memBrand.Locate('DESCRIPTION', AnsiUpperCase(Cat_brand), []) then
        brand_id := memBrand.FieldByName('Brand_id').AsInteger
      else
      begin
        //WLog('Бренд не распознан <' + Cat_brand + '> в строке ' + IntToStr(i));
        brand_id := 0;
      end;
      prevBrand := Cat_brand;
      prevBrandID := brand_id;
    end;

    if brand_id = 0 then
      Exit;

    //поиск кода позиции комплекта в каталоге
    child_cat_id := 0;
    if memBrand.Locate('DESCRIPTION', AnsiUpperCase(child_brand), []) then
      if memCatalog.FindKey([MakeSearchCode(child_code), memBrand.FieldByName('Brand_id').AsInteger]) then
        child_cat_id := memCatalog.FieldByName('Cat_id').AsInteger;

    if memCatalog.FindKey([MakeSearchCode(cat_code), brand_id]) then
    begin
      cat_id := memCatalog.FieldByName('Cat_id').AsInteger;
      if (not memKIT.FindKey([cat_id, AnsiUpperCase(child_code)])) then
      begin
        if fUseRelease and memKITPrev.FindKey([cat_id, AnsiUpperCase(child_code)]) then
          aID := memKITPrev.FieldByName('ID').AsInteger
        else
        begin
          Inc(aNewID);
          aID := aNewID;
        end;

        //:ID, :CAT_ID, :CHILD_CODE, :CHILD_BRAND, :CHILD_ID, :QUANTITY
        insertQuery.Parameters[0].Value := aID;
        insertQuery.Parameters[1].Value := cat_id;
        insertQuery.Parameters[2].Value := child_code;
        insertQuery.Parameters[3].Value := AnsiUpperCase(child_brand);
        insertQuery.Parameters[4].Value := child_cat_id;
        insertQuery.Parameters[5].Value := aQuantity;
        insertQuery.Execute;

        memKIT.Append;
        memKIT.FieldByName('ID').AsInteger := aID;
        memKIT.FieldByName('CAT_ID').AsInteger := cat_id;
        memKIT.FieldByName('CHILD_CODE').AsString := AnsiUpperCase(child_code);
        memKIT.FieldByName('CHILD_BRAND').AsString := AnsiUpperCase(child_brand);
        memKIT.Post;
      end;
    end
    else
    begin
      //дубль позиции по коду (бренд не проверяем)
    end;
  end;

var
  aReader: TCSVReader;
begin
  WriteBuildLog('Загрузка комплектов из ' + aFileName);
  UpdateProgress(0, 'Загрузка комплектов...');

  if fUseRelease then
  begin
    CacheKitEx(fReleasePrefix, memKitPrev, True);
    memKitPrev.IndexName := 'IDCODE';
    memKitPrev.Open;
    aNewID := GetLastTableID(fReleasePrefix + 'KIT', 'ID')
  end
  else
    aNewID := 0;

  insertQuery.CommandText :=
    ' INSERT INTO KIT ( ID,  CAT_ID,  CHILD_CODE,  CHILD_BRAND,  CHILD_ID,  QUANTITY) ' +
    '          VALUES (:ID, :CAT_ID, :CHILD_CODE, :CHILD_BRAND, :CHILD_ID, :QUANTITY) ';
  insertQuery.Prepared := True;

  ClearTable('KIT');
  CacheKIT(True);                                                  
  memKIT.IndexName := 'IDCODE';
  memKIT.Open;

  CacheCatalog;
  memCatalog.IndexName := 'CODE2BRAND';
  memCatalog.Open;

  CacheBrand;
  memBrand.Open;

  ExecuteQuery('SET IDENTITY_INSERT KIT ON ', []);
  aReader := TCSVReader.Create;
  try
    i := 0;
    aReader.Open(aFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      if not DecodeCodeBrand(aReader.Fields[0], cat_code, cat_brand, False) then
      begin
        WriteBuildLog('Кривой КОД_БРЕНД комплекта в строке: ' + aReader.CurrentLine);
        Continue;
      end;
      if not DecodeCodeBrand(aReader.Fields[1], child_code, child_brand, False) then
      begin
        WriteBuildLog('Кривой КОД_БРЕНД позиции комплекта в строке: ' + aReader.CurrentLine);
        Continue;
      end;
      aQuantity := StrToIntDef(aReader.Fields[2], 0);
      if aQuantity <= 0 then
      begin
        WriteBuildLog('Неверное количество в комплекте в строке: ' + aReader.CurrentLine);
        Continue;
      end;

      try
        AddToTable;
      except
        on E: Exception do
        begin
          WriteBuildLog('!Exception: ' + E.Message + #13#10'в строке: ' + aReader.CurrentLine);
        end;
      end;


      Inc(i);
      if i mod 1000 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Загрузка комплектов... ' + IntToStr(i));
      if fAborted then
        Break;
    end;

  finally
    ExecuteQuery('SET IDENTITY_INSERT KIT OFF ', []);
    aReader.Free;

    if fAborted then
      WriteBuildLog('...прервано пользователем'#13#10)
    else
      WriteBuildLog('...загружено'#13#10);

    if fUseRelease then
      memKITPrev.Close;

    memKIT.Close;
    memBrand.Close;
    memCatalog.Close;
  end;
end;

procedure TFormMain.RecognizeTecdoc;
var
  aQuery: TADOQuery;
  aQueryUpdate: TAdoCommand;
  i, iMax: Integer;
  aConnection: TAdoConnection;
begin
  if not LoadReplBrands then
    raise Exception.Create('Файл BrandRpl.txt не найден');

  WriteBuildLog('Сопоставление по TecDoc...');
  UpdateProgress(0, 'Сопоставление по TecDoc...');

  //добавляем столбец с оригинальным названием бренда для JOIN'а с ART
  ExecuteQuery(
    ' IF COLUMNPROPERTY(OBJECT_ID(''[SERVICE].[dbo].[BRANDS]'',''U''),''BRAND_REPL'',''AllowsNull'') IS NULL ' +
    '   ALTER TABLE [SERVICE].[dbo].[BRANDS] ADD ' +
    '     BRAND_REPL [varchar](100) COLLATE Cyrillic_General_CI_AS NULL ',
    []
  );
  //заполняем его
  UpdateProgress(0, 'Сопоставление по TecDoc... обновление оригинальных брендов');
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.SQL.Text := 'SELECT ID, DESCRIPTION FROM [SERVICE].[dbo].[BRANDS]';
    aQuery.Open;
    while not aQuery.Eof do
    begin
      ExecuteQuery(
        ' UPDATE [SERVICE].[dbo].[BRANDS] SET BRAND_REPL = :BRAND_REPL WHERE ID = :ID ',
        [GetReplBrand(aQuery.FieldByName('DESCRIPTION').AsString), aQuery.FieldByName('ID').AsInteger]
      );
      aQuery.Next;
    end;
    aQuery.Close;
  finally
    aQuery.Free;
  end;

  UpdateProgress(0, 'Сопоставление по TecDoc... очистка привязок');
  ExecuteQuery(' UPDATE [SERVICE].[dbo].[CATALOG] SET TECDOC_ID = 0, TYP_TDID = 0, PARAM_TDID = 0, PICT_ID = 0 ', []);

  iMax := 0;
  UpdateProgress(0, 'Сопоставление по TecDoc...');
  aQuery := TADOQuery.Create(nil);
  aQueryUpdate := TAdoCommand.Create(nil);
  aConnection := TAdoConnection.Create(nil);
  try
    aQuery.Connection := msQuery.Connection;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.SQL.Text :=
      ' SELECT Count(cat.CAT_ID) ' +
      ' FROM [SERVICE].[dbo].[CATALOG] cat ' +
      ' INNER JOIN [SERVICE].[dbo].[BRANDS] br ON (cat.BRAND_ID = br.BRAND_ID) ' +
      ' INNER JOIN [' + fTecdocDB + '].[dbo].[ART] art ON (cat.CODE2 = art.ART_LOOK and art.SUP_BRAND = br.BRAND_REPL) ';
    aQuery.Open;
    iMax := aQuery.Fields[0].AsInteger;
    aQuery.Close;

    aQuery.SQL.Text :=
      ' SELECT art.ART_ID, art.TYP_ID, art.PARAM_ID, art.CUR_PICT, cat.ID ' +
      ' FROM [SERVICE].[dbo].[CATALOG] cat ' +
      ' INNER JOIN [SERVICE].[dbo].[BRANDS] br ON (cat.BRAND_ID = br.BRAND_ID) ' +
      ' INNER JOIN [' + fTecdocDB + '].[dbo].[ART] art ON (cat.CODE2 = art.ART_LOOK and art.SUP_BRAND = br.BRAND_REPL) ';
    aQuery.Open;

    aConnection.Provider :=  connService.Provider;
    aConnection.LoginPrompt := connService.LoginPrompt;
    aConnection.CursorLocation := connService.CursorLocation;
    aConnection.ConnectionString := fCurrentConnectionString;
    aConnection.Connected := True;

    aQueryUpdate.Connection := aConnection;
    aQueryUpdate.CommandText :=
      ' UPDATE [SERVICE].[dbo].[CATALOG] ' +
      ' SET TECDOC_ID = :TECDOC_ID, TYP_TDID = :TYP_TDID, PARAM_TDID = :PARAM_TDID, PICT_ID = :PICT_ID ' +
      ' WHERE ID = :ID';
    aQueryUpdate.Prepared := True;
    i := 0;
    while not aQuery.Eof do
    begin
      aQueryUpdate.Parameters[0].Value := aQuery.Fields[0].AsInteger;
      aQueryUpdate.Parameters[1].Value := aQuery.Fields[1].AsInteger;
      aQueryUpdate.Parameters[2].Value := aQuery.Fields[2].AsInteger;
      aQueryUpdate.Parameters[3].Value := aQuery.Fields[3].AsInteger;
      aQueryUpdate.Parameters[4].Value := aQuery.Fields[4].AsInteger;
      aQueryUpdate.Execute;

      aQuery.Next;

      Inc(i);
      if i mod 100 = 0 then
        UpdateProgress(i * 100 div iMax, 'Сопоставление по TecDoc [' + IntToStr(iMax) + ']... ' + IntToStr(i));
      if fAborted then
        Break;
    end;
    aQuery.Close;
    aConnection.Connected := False;

  finally
    if fAborted then
      WriteBuildLog('...прервано пользователем'#13#10)
    else
      WriteBuildLog('...распознано ' + IntToStr(iMax) + ' позиций'#13#10);

    aQueryUpdate.Free;
    aQuery.Free;
    aConnection.Free;
    UpdateProgress(0, 'finish');
  end;

{225847
SELECT cat.CAT_ID, cat.CODE, br.DESCRIPTION, /*art.ART_ID, art.ART_LOOK, art.SUP_BRAND, */br.ID, cat.TITLE
FROM [SERVICE].[dbo].[CATALOG] cat
INNER JOIN [SERVICE].[dbo].[BRANDS] br ON (cat.BRAND_ID = br.BRAND_ID)
INNER JOIN [TECDOC].[dbo].[TD_ART] art ON (cat.CODE = art.ART_LOOK and art.SUP_BRAND = br.DESCRIPTION)
WHERE cat.Title IS NULL
}

{225847
SELECT cat.CAT_ID, cat.CODE
FROM [SERVICE].[dbo].[CATALOG] cat
  INNER JOIN

    (select a.ART_LOOK, b.BRAND_ID from [TECDOC].[dbo].[TD_ART] a INNER JOIN [SERVICE].[dbo].[BRANDS] b ON (a.SUP_BRAND = b.DESCRIPTION)) artbr

  ON (cat.CODE = artbr.ART_LOOK and cat.BRAND_ID = artbr.BRAND_ID)
}
end;

procedure TFormMain.LoadFromService;
  procedure CopyTable(const aFrom, aTo: string; const aFieldsMap: array of string;
    aDefIsNull: string = ''; aClearBefore: Boolean = True);
  var
    i: Integer;
    aFields, aParams, aFieldName: string;
    aNeedEnabeInsertID: Boolean;
    aField: TField;
    aDefs: TStrings;
  begin
    if fAborted then
      Exit;

    if aClearBefore then
    begin
      UpdateProgress(0, 'Очистка ' + aTo + '...');
      ClearTable(aTo);
    end;

    UpdateProgress(0, 'Импорт: ' + aFrom + '->' + aTo);
    aFields := '';
    aParams := '';
    aNeedEnabeInsertID := False;
    for i := Low(aFieldsMap) to High(aFieldsMap) do
    begin
      aFieldName := StrGetValue(aFieldsMap[i]);
      if aFieldName = '' then
        aFieldName := aFieldsMap[i];

      if SameText(aFieldName, 'ID') then
        aNeedEnabeInsertID := True;

      if aFields = '' then
        aFields := aFieldName
      else
        aFields := aFields + ', ' + aFieldName;

      if aParams = '' then
        aParams := ':' + aFieldName
      else
        aParams := aParams + ', :' + aFieldName;
    end;

    aDefs := TStringList.Create;
    aDefs.Text := aDefIsNull;
    if aNeedEnabeInsertID then
      ExecuteQuery('SET IDENTITY_INSERT [' + aTo + '] ON ', []);
    try
      insertQuery.CommandText :=
        Format(' INSERT INTO [%s] (%s) VALUES (%s) ', [aTo, aFields, aParams]);
      insertQuery.Prepared := True;

      DBITable.TableName := aFrom;
      DBITable.Open;
      while not DBITable.Eof do
      begin
        for i := Low(aFieldsMap) to High(aFieldsMap) do
        begin
          aFieldName := StrGetName(aFieldsMap[i]);
          aField := DBITable.FieldByName(aFieldName);
          if aField.IsNull and (aDefs.IndexOfName(aFieldName) >= 0) then
            insertQuery.Parameters[i].Value := aDefs.Values[aFieldName]
          else
            if (aField is TBooleanField) then
            begin
              if aField.AsBoolean then
                insertQuery.Parameters[i].Value := 1
              else
                insertQuery.Parameters[i].Value := 0;
            end
            else
              insertQuery.Parameters[i].Value := aField.Value;
        end;
        insertQuery.Execute;

        DBITable.Next;

        if DBITable.RecNo mod 500 = 0 then
          UpdateProgress(DBITable.RecNo * 100 div DBITable.RecordCount, 'Импорт: ' + aFrom + '->' + aTo + ' [' + IntToStr(DBITable.RecordCount) + ']... ' + IntToStr(DBITable.RecNo));
        if fAborted then
          Break;
      end;
      DBITable.Close;

    finally
      if aNeedEnabeInsertID then
        ExecuteQuery('SET IDENTITY_INSERT [' + aTo + '] OFF ', []);
      aDefs.Free;

      UpdateProgress(0, 'finish');
    end;
  end;

var
  aPath: string;
begin
  if not OpenDirDialog.OpenDirExecute(aPath) then
    Exit;
{
  if SelectDirectory.Execute then
    aPath := SelectDirectory.Directory
  else
    Exit;
}
  WriteBuildLog('Загрузка напрямую из БД сервисной "' + aPath + '"');
  DBISAMDB.Directory := aPath;
  DBISAMDB.Open;
  try
    CopyTable(
      '002', 'CATALOG',
      [  'CAT_ID'
        ,'BRAND_ID'
        ,'GROUP_ID'
        ,'SUBGROUP_ID'
        ,'CODE'
        ,'CODE2'
        ,'SHORTCODE'
        ,'NAME'
        ,'DESCRIPTION'
        ,'PRICE'
        ,'T1'
        ,'T2'
        ,'NEW'
        ,'SALE'
        ,'MULT'
        ,'USA'
        ,'TITLE'
        ,'IDOUBLE'
        ,'TECDOC_ID'
        ,'PICT_ID'
        ,'TYP_TDID'
        ,'PARAM_TDID'
      ],
      'TECDOC_ID=0'#13#10'TITLE=0'#13#10'IDOUBLE=0'#13#10'DESCRIPTION='
    );

    CopyTable(
      '003', 'BRANDS',
      [  'ID'
        ,'BRAND_ID'
        ,'DESCRIPTION'
        ,'DISCOUNT'
        ,'MY_BRAND']
    );

    CopyTable(
      '004', 'GROUPS',
      [  'ID'
        ,'GROUP_ID'
        ,'GROUP_DESCR'
        ,'SUBGROUP_ID'
        ,'SUBGROUP_DESCR'
        ,'DISCOUNT']
    );

    CopyTable(
      '005', 'GROUPBRAND',
      [  'ID'
        ,'GROUP_ID'
        ,'SUBGROUP_ID'
        ,'BRAND_ID']
    );

    CopyTable(
      '007', 'ANALOG',
      [  'ID'
        ,'CAT_ID'
        ,'AN_CODE'
        ,'AN_BRAND'
        ,'AN_ID'
        ,'LOCKED'
        ,'AN_SHORTCODE']
    );

    CopyTable(
      '016', 'OE',
      [  'ID'
        ,'CAT_ID'
        ,'CODE'
        ,'CODE2'
        ,'SHORTOE']
    );

  finally
    if fAborted then
      WriteBuildLog('...прервано пользователем'#13#10)
    else
      WriteBuildLog('...загружен'#13#10);

    DBISAMDB.Close;
  end;
end;

procedure TFormMain.ZipperTotalPercentDone(Sender: TObject; Percent: Integer);
begin
  if fAborted then
  begin
    UpdateProgress(Percent, 'Упаковка прервана');
    Abort;
  end;

  if Percent = 100 then
    UpdateProgress(0, 'Упаковка ' + (Sender as TVCLZip).ZipName + '... OK')
  else
    UpdateProgress(Percent, 'Упаковка ' + (Sender as TVCLZip).ZipName + '...');
end;

procedure TFormMain.LoadToService;

  procedure ImportOEToService();
  var
    aQuery: TAdoQuery;
    iMax, iPos, numTable: integer;
  begin
    aQuery := TAdoQuery.Create(nil);
      try
      numTable := 1;
      DBITable.TableName := '016_1m';
      iPos := 0;
      iMax := StrToIntDef( ExecuteSimpleSelectMS('Select count(distinct [gen_oe_id]) from OE_BUF_' + fBuildInfo.Version , []), 0 );
      UpdateProgress(0, 'Экспорт: OE Описания  [' + IntToStr(iMax) + ']... ');

      aQuery.Connection := connService;
      aQuery.CommandTimeout := 60 * 5;
      aQuery.SQL.Text :=
          ' SELECT distinct [code] ,[gen_oe_id], [shortoe] ' +
          ' FROM [OE_BUF_' + fBuildInfo.Version + '] ' +
          ' order by gen_oe_id ';

      aQuery.DisableControls;
      aQuery.Open;

      DBITable.Exclusive := True;
      DBITable.DisableControls;
      DBITable.Open;
      DBITable.EmptyTable;
      while not aQuery.Eof do
      begin
        DBITable.Append;
        DBITable.FieldByName('CODE').Value := aQuery.FieldByName('CODE').AsString;
        DBITable.FieldByName('gen_oe_id').Value := aQuery.FieldByName('gen_oe_id').AsString;
        DBITable.FieldByName('SHORTOE').Value := aQuery.FieldByName('SHORTOE').AsString;
        DBITable.Post;
        aQuery.Next;
        Inc(iPos);

        if iPos mod 500 = 0 then
          if iMax > 0 then
            UpdateProgress(iPos * 100 div iMax, 'Экспорт: OE Описания[' + IntToStr(iMax) + ']... ' + IntToStr(iPos))
          else
            UpdateProgress(0, 'Экспорт: OE Описания... ' + IntToStr(iPos));
        if fAborted then
          Break;
      end;
      DBITable.Close;
      DBITable.Exclusive := False;
      aQuery.Close;


      DBITable.TableName := '016_2';
      iPos := 0;
      iMax := StrToIntDef( ExecuteSimpleSelectMS('Select count(*) from OE_BUF_' + fBuildInfo.Version , []), 0 );
      UpdateProgress(0, 'Экспорт: OE ID  [' + IntToStr(iMax) + ']... ');
      aQuery.SQL.Text :=
          ' SELECT [cat_id] ,[gen_oe_id] ' +
          ' FROM [OE_BUF_' + fBuildInfo.Version + '] ' +
          ' order by gen_oe_id ';

      aQuery.DisableControls;
      aQuery.Open;

      DBITable.Exclusive := True;
      DBITable.DisableControls;
      DBITable.Open;
      DBITable.EmptyTable;
      while not aQuery.Eof do
      begin
        DBITable.Append;
        DBITable.FieldByName('cat_id').Value := aQuery.FieldByName('cat_id').AsString;
        DBITable.FieldByName('gen_oe_id').Value := CreateShortCode(aQuery.FieldByName('gen_oe_id').AsString);
        DBITable.Post;
        aQuery.Next;
        Inc(iPos);

        if iPos mod 500 = 0 then
          if iMax > 0 then
            UpdateProgress(iPos * 100 div iMax, 'Экспорт: OE ID [' + IntToStr(iMax) + ']... ' + IntToStr(iPos))
          else
            UpdateProgress(0, 'Экспорт: OE ID... ' + IntToStr(iPos));
        if fAborted then
          Break;
      end;
      DBITable.Close;
      DBITable.Exclusive := False;
      aQuery.Close;

      finally
        aQuery.Free;
        aQuery.EnableControls;
      end;
  end;

  procedure ImportAnalogToService();
  var
    aQuery: TAdoQuery;
    iMax, iPos, numTable: integer;
  begin
    aQuery := TAdoQuery.Create(nil);
      try
      numTable := 1;
      DBITable.TableName := '007_1m';
      iPos := 0;
      iMax := StrToIntDef( ExecuteSimpleSelectMS('Select count(distinct [gen_an_id]) from FULL_ANALOG_' + fBuildInfo.Version , []), 0 );
      UpdateProgress(0, 'Экспорт: Аналоги Описания  [' + IntToStr(iMax) + ']... ');

      aQuery.Connection := connService;
      aQuery.CommandTimeout := 60 * 5;
      aQuery.SQL.Text :=
          ' SELECT distinct [an_code] ' +
          ' ,[an_brand] ' +
          ' ,[an_id] ' +
          ' ,[locked] ' +
          ' ,[gen_an_id] ' +
          ' FROM [FULL_ANALOG_' + fBuildInfo.Version + '] ' +
          ' order by gen_an_id ';

      aQuery.DisableControls;
      aQuery.Open;

      DBITable.Exclusive := True;
      DBITable.DisableControls;
      DBITable.Open;
      DBITable.EmptyTable;
      while not aQuery.Eof do
      begin
        DBITable.Append;
        DBITable.FieldByName('gen_an_id').Value := CreateShortCode(aQuery.FieldByName('gen_an_id').AsString);
        DBITable.FieldByName('AN_CODE').Value := aQuery.FieldByName('AN_CODE').AsString;
        DBITable.FieldByName('AN_BRAND').Value := aQuery.FieldByName('AN_BRAND').AsString;
        DBITable.FieldByName('AN_ID').Value := aQuery.FieldByName('AN_ID').AsString;
        DBITable.FieldByName('LOCKED').Value := aQuery.FieldByName('LOCKED').AsString;
        DBITable.FieldByName('AN_SHORTCODE').Value := CreateShortCode(aQuery.FieldByName('AN_CODE').AsString);
        DBITable.Post;
        aQuery.Next;
        Inc(iPos);

        if iPos mod 500 = 0 then
          if iMax > 0 then
            UpdateProgress(iPos * 100 div iMax, 'Экспорт: Аналоги Описания[' + IntToStr(iMax) + ']... ' + IntToStr(iPos))
          else
            UpdateProgress(0, 'Экспорт: Аналоги Описания... ' + IntToStr(iPos));
        if fAborted then
          Break;

        if (iPos mod 350000 = 0) and (iPos < 1500000) then
        begin
          DBITable.Close;
          DBITable.Exclusive := False;
          inc(numTable);
          DBITable.TableName := '007_' + IntToStr(numTable) +'m';
          DBITable.Exclusive := True;
          DBITable.DisableControls;
          DBITable.Open;
          DBITable.EmptyTable;
        end;

      end;
      DBITable.Close;
      DBITable.Exclusive := False;
      aQuery.Close;


      DBITable.TableName := '007_2';
      iPos := 0;
      iMax := StrToIntDef( ExecuteSimpleSelectMS('Select count(*) from FULL_ANALOG_' + fBuildInfo.Version , []), 0 );
      UpdateProgress(0, 'Экспорт: Аналоги ID  [' + IntToStr(iMax) + ']... ');
      aQuery.SQL.Text :=
          ' SELECT [cat_id] ,[gen_an_id] ' +
          ' FROM [FULL_ANALOG_' + fBuildInfo.Version + '] ' +
          ' order by gen_an_id ';

      aQuery.DisableControls;
      aQuery.Open;

      DBITable.Exclusive := True;
      DBITable.DisableControls;
      DBITable.Open;
      DBITable.EmptyTable;
      while not aQuery.Eof do
      begin
        DBITable.Append;
        DBITable.FieldByName('cat_id').Value := aQuery.FieldByName('cat_id').AsString;
        DBITable.FieldByName('gen_an_id').Value := CreateShortCode(aQuery.FieldByName('gen_an_id').AsString);
        DBITable.Post;
        aQuery.Next;
        Inc(iPos);

        if iPos mod 500 = 0 then
          if iMax > 0 then
            UpdateProgress(iPos * 100 div iMax, 'Экспорт: Аналоги ID [' + IntToStr(iMax) + ']... ' + IntToStr(iPos))
          else
            UpdateProgress(0, 'Экспорт: Аналоги ID... ' + IntToStr(iPos));
        if fAborted then
          Break;
      end;
      DBITable.Close;
      DBITable.Exclusive := False;
      aQuery.Close;

      finally
        aQuery.Free;
        aQuery.EnableControls;
      end;     
  end;

  procedure CopyTableEx(const aFromQuery, aTo: string; const aFieldsMap: array of string;
    aDefIsNull: string = ''; aClearBefore: Boolean = True;
    const aProgressCaption: string = ''; const aProgressCalcSQL: string = ''; aUseServerCursor: Boolean = False);
  var
    i, iPos, iMax: Integer;
    aFieldNameFrom, aFieldNameTo: string;
    aFieldFrom, aFieldTo: TField;
    aDefs: TStrings;
    aQuery: TAdoQuery;
    t: Cardinal;
    aStream: TMemoryStream;
  begin
    if fAborted then
      Exit;

    MemoLog.Lines.Add('');
    MemoLog.Lines.Add(aProgressCaption + '...');
    t := GetTickCount;

    DBITable.TableName := aTo;
    if aClearBefore then
    begin
      UpdateProgress(0, 'Очистка ' + aTo + '...');
      DBITable.EmptyTable;
    end;

    UpdateProgress(0, 'Экспорт: ' + aProgressCaption);

    aStream := TMemoryStream.Create;
    aDefs := TStringList.Create;
    aDefs.Text := aDefIsNull;
    aQuery := TAdoQuery.Create(nil);
    try
      iPos := 0;
      if aProgressCalcSQL <> '' then
      begin
        iMax := StrToIntDef( ExecuteSimpleSelectMS(aProgressCalcSQL, []), 0 );
        UpdateProgress(0, 'Экспорт: ' + aProgressCaption + ' [' + IntToStr(iMax) + ']... ');
      end
      else
        iMax := 0;

      aQuery.Connection := connService;
      if aUseServerCursor then
      begin
        aQuery.CursorLocation := clUseServer;
        aQuery.CursorType := ctOpenForwardOnly;
      end;
      aQuery.CommandTimeout := 60 * 5;
      aQuery.SQL.Text := aFromQuery;

      aQuery.DisableControls;
      aQuery.Open;


      DBITable.Exclusive := True;
      DBITable.DisableControls;
      DBITable.Open;
      while not aQuery.Eof do
      begin
        DBITable.Append;

        for i := Low(aFieldsMap) to High(aFieldsMap) do
        begin
          aFieldNameFrom := StrGetName(aFieldsMap[i]);
          aFieldNameTo := StrGetValue(aFieldsMap[i]);
          if aFieldNameTo = '' then
            aFieldNameTo := aFieldNameFrom;

          aFieldFrom := aQuery.FieldByName(aFieldNameFrom);
          aFieldTo := DBITable.FieldByName(aFieldNameTo);
          if aFieldFrom.IsNull and (aDefs.IndexOfName(aFieldNameFrom) >= 0) then
            aFieldTo.Value := aDefs.Values[aFieldNameFrom]
          else
            if (aFieldTo is TBooleanField) then
            begin
              if aFieldFrom.AsInteger = 0 then
                aFieldTo.AsBoolean := False
              else
                aFieldTo.AsBoolean := True;
            end
            else
              if (aFieldTo is TBlobField) then
              begin
                TBlobField(aFieldFrom).SaveToStream(aStream);
                TBlobField(aFieldTo).LoadFromStream(aStream);
                aStream.Clear;
              end
              else
                aFieldTo.Value := aFieldFrom.Value;
        end;
        DBITable.Post;
        aQuery.Next;
        Inc(iPos);

        if iPos mod 500 = 0 then
          if iMax > 0 then
            UpdateProgress(iPos * 100 div iMax, 'Экспорт: ' + aProgressCaption + ' [' + IntToStr(iMax) + ']... ' + IntToStr(iPos))
          else
            UpdateProgress(0, 'Экспорт: ' + aProgressCaption + '... ' + IntToStr(iPos));
        if fAborted then
          Break;
      end;
      DBITable.Close;
      DBITable.Exclusive := False;

      aQuery.Close;
      
    finally
      aQuery.Free;
      aDefs.Free;
      aStream.Free;
      UpdateProgress(0, 'finish');

      MemoLog.Lines.Add('exec time: ' + IntToStr(GetTickCount - t));
    end;
  end;

  procedure CopyTable(const aFromTable, aToTable: string; const aFieldsMap: array of string;
    aDefIsNull: string = ''; aClearBefore: Boolean = True);
  var
    aFromTableNorm: string;
  begin
    if Copy(aFromTable, 1, 1) = '[' then
      aFromTableNorm := aFromTable
    else
      aFromTableNorm := '[' + aFromTable + ']';

    CopyTableEx(
      ' SELECT * FROM ' + aFromTableNorm,
      aToTable,
      aFieldsMap,
      aDefIsNull,
      aClearBefore,
      aFromTable + '->' + aToTable,
      ' SELECT Count(*) FROM ' + aFromTableNorm
    );
  end;

  procedure DBISamExecuteSQL(const aSQL: string);
  var
    aQuery: TDBISAMQuery;
  begin
    aQuery := TDBISAMQuery.Create(nil);
    try
      aQuery.DatabaseName := DBISAMDB.DatabaseName;
      aQuery.SQL.Text := aSQL;
      aQuery.ExecSQL;
    finally
      aQuery.Free;
    end;
  end;

  procedure BuildPrimen;
  var
    aQuery: TAdoQuery;
    s: string;
    iPos, iMax: Integer;
  begin
    UpdateProgress(0, 'Построение применяемости...');

    //построить таблицу отфильтрованных типов
    ExecuteQuery(' DELETE FROM [' + fTecdocDB + '].[dbo].[TD_TYPES_FILT] ', []);
    ExecuteQuery(
      ' INSERT INTO [' + fTecdocDB + '].[dbo].[TD_TYPES_FILT] (TYP_ID) ' +
      ' SELECT DISTINCT t.TYP_ID FROM [' + fTecdocDB + '].[dbo].[TD_TYPES] t ' +
      ' INNER JOIN [' + fTecdocDB + '].[dbo].[TD_MODELS] m ON (t.MOD_ID = m.MOD_ID) ' +
      ' INNER JOIN [' + fTecdocDB + '].[dbo].[TD_MANUFACTURERS] ma ON (m.MFA_ID = ma.MFA_ID and ma.HIDE = 0) ',
      []
    );

{
    //стереть применяемость в каталоге
    ExecuteQuery(' UPDATE [SERVICE].[dbo].[CATALOG] SET PRIMEN = NULL ', []);
}

    aQuery := TADOQuery.Create(nil);
    try
      aQuery.Connection := connService;
      aQuery.CursorLocation := clUseServer;
      aQuery.CursorType := ctOpenForwardOnly;
      aQuery.CommandTimeout := 60 * 5;


      //перебор записей каталога с заданной ссылкой на тип
      DBITable.Close;
      DBITable.TableName := '002';
      DBITable.Exclusive := True;
      DBITable.Open;
      iPos := 0;
      iMax := DBITable.RecordCount;
      UpdateProgress(0, 'Загрузка применяемости в каталог...');
      try
        DBITable.First;
        while not DBITable.Eof do
        begin
          DBITable.Edit;
          DBITable.FieldByName('PRIMEN').Value := NULL;

          if DBITable.FieldByName('TYP_TDID').AsInteger > 0 then
          begin
            aQuery.SQL.Text :=
              ' SELECT at.TYP_ID ' +
              ' FROM [' + fTecdocDB + '].[dbo].[ART_TYP] at ' +
              ' WHERE at.ART_ID = :ART_ID and Exists ( ' +
              '   SELECT tf.TYP_ID FROM [' + fTecdocDB + '].[DBO].[TD_TYPES_FILT] tf WHERE tf.TYP_ID = at.TYP_ID ' +
              ' ) ';
            aQuery.Parameters[0].Value := DBITable.FieldByName('TYP_TDID').AsInteger;
            aQuery.Open;
            s := '';
            while not aQuery.Eof do
            begin
              if s = '' then
                s := aQuery.Fields[0].AsString
              else
                s := s + ',' + aQuery.Fields[0].AsString;
              aQuery.Next;
            end;
                         
            if s = '' then
              DBITable.FieldByName('PRIMEN').Value := NULL
            else
              DBITable.FieldByName('PRIMEN').Value := s;
          end;

          Inc(iPos);
          if iPos mod 100 = 0 then
            UpdateProgress(iPos * 100 div iMax, 'Загрузка применяемости в каталог... [' + IntToStr(iMax) + ']... ' + IntToStr(iPos));
          if fAborted then
            Break;

          DBITable.Post;
          DBITable.Next;
        end;
      finally
        DBITable.Close;
        DBITable.Exclusive := False;
      end;

    finally
      aQuery.Free;
      UpdateProgress(0, 'finish');
    end;
  end;

var
  aPath: string;
  aParams: array of Boolean;
  aHasParams, aNeedMakeUpdate, aNeedBuildPrimen: Boolean;
  aParamsForm: TOutParamsForm;
  i: Integer;
begin
{
  if SelectDirectory.Execute then
    aPath := SelectDirectory.Directory
  else
    Exit;
}
  aHasParams := False;
  aNeedMakeUpdate := False;
  aParamsForm := TOutParamsForm.Create(Self);
  try
    if aParamsForm.ShowModal = mrOK then
    begin
      aNeedMakeUpdate := aParamsForm.cbMakeUpdate.Checked;
      aNeedBuildPrimen := aParamsForm.cbBuildPrimen.Checked;
      SetLength(aParams, aParamsForm.cbParams.Count);
      for i := 0 to aParamsForm.cbParams.Count - 1 do
      begin
        aParams[i] := aParamsForm.cbParams.Checked[i];
        aHasParams := aHasParams or aParams[i];
      end;
    end
    else
      Exit;
  finally
    aParamsForm.Free;
  end;

  if aHasParams then
  begin
    if not OpenDirDialog.OpenDirExecute(aPath, 'Укажите папку с данными сервисной программы') then
    begin
      aParams := nil;
      Exit;
    end;

    DBISAMDB.Directory := aPath;
    DBISAMDB.Open;
    try
   //ImportOEToService;
  // ImportAnalogToService;
  // exit;
  if aParams[0] then
  begin
      CopyTable(
        'CATALOG',
        '002',
        [  'CAT_ID'
          ,'BRAND_ID'
          ,'GROUP_ID'
          ,'SUBGROUP_ID'
          ,'CODE'
          ,'CODE2'
          ,'SHORTCODE'
          ,'NAME'
          ,'DESCRIPTION'
          ,'PRICE'
          ,'T1'
          ,'T2'
          ,'NEW'
          ,'SALE'
          ,'MULT'
          ,'USA'
          ,'TITLE'
          ,'IDOUBLE'
          ,'TECDOC_ID'
          ,'PICT_ID'
          ,'TYP_TDID'
          ,'PARAM_TDID'
        ]
      );

      CopyTable(
        'BRANDS',
        '003',
        [  'ID'
          ,'BRAND_ID'
          ,'DESCRIPTION'
          //,'DISCOUNT'
          ,'MY_BRAND']
      );

      CopyTable(
        'GROUPS',
        '004',
        ['ID'
          ,'GROUP_ID'
          ,'GROUP_DESCR'
          ,'SUBGROUP_ID'
          ,'SUBGROUP_DESCR'
          {,'DISCOUNT'}]
      );

      CopyTable(
        'GROUPBRAND',
        '005',
        ['ID'
          ,'GROUP_ID'
          ,'SUBGROUP_ID'
          ,'BRAND_ID']
      );

      //комплекты
      CopyTable(
        'KIT',
        '041',
        ['ID'
          ,'CAT_ID'
          ,'CHILD_CODE'
          ,'CHILD_BRAND'
          ,'CHILD_ID'
          ,'QUANTITY']
      );

      //товары под заказ
      CopyTableEx(
        ' SELECT CAT_ID FROM [CATALOG] WHERE ORDER_ONLY = 1 ',
        '042',
        ['CAT_ID'],
        '',
        True,
        'товары под заказ [042]',
        ' SELECT Count(CAT_ID) FROM [CATALOG] WHERE ORDER_ONLY = 1 '
      );
  end;

  if aParams[1] then
  begin
    ImportAnalogToService;
    { CopyTable(
        'ANALOG',
        '007',
        ['ID'
          ,'CAT_ID'
          ,'AN_CODE'
          ,'AN_BRAND'
          ,'AN_ID'
          ,'LOCKED'
          ,'AN_SHORTCODE']
      );
      CopyTable(
        'FULL_ANALOG_' + fBuildInfo.Version,
        '007_2',
        [
          'GEN_AN_ID',
          'CAT_ID'
        ]
      )   }
  end;

  if aParams[2] then
  begin
    ImportOEToService;
  {    CopyTable(
        'OE',
        '016',
        ['ID'
          ,'CAT_ID'
          ,'CODE'
          ,'CODE2'
          ,'SHORTOE']
      );

        CopyTable(
        'OE',
        '016_2',
        [
          'GEN_OE_ID',
          'CAT_ID'
        ]
      );
       CopyTable(
        'OE',
        '016_1m',
        [
          'GEN_OE_ID',
          'CODE',
          'SHORTOE'
        ]
      )
  }
  end;

  //*** статика - не зависит от каталога ***
  //- DES, CDS -
  if aParams[3] then
  begin
      CopyTable(
        '[' + fTecdocDB + '].[DBO].[TD_DES]',
        '024',
        ['DES_ID', 'TEX_TEXT']
      );
      CopyTable(
        '[' + fTecdocDB + '].[DBO].[TD_CDS]',
        '025',
        ['CDS_ID', 'TEX_TEXT']
      );
  end;


  // TD_PARAMS -> [015]
  if aParams[4] then
  begin
      CopyTable(
        '[' + fTecdocDB + '].[DBO].[TD_PARAMS]',
        '015',
        ['PARAM_ID', 'DESCR', 'DESCRIPTION', 'TYPE', 'INTERV', 'PARAM_ID2']
      );
  end;

  // TD_TYPES -> [022]
  {
  [OK] !!! выгрузить только те TD_TYPES, которые не скрыты в TD_MANUFACTURERS
       !!! (связка TD_TYPES.MOD_ID -> TD_MODELS.MFA_ID -> TD_MANUFACTURERS.HIDE)
  !!! выгрузить в [032] только TYP_ID, которые не скрыты в TD_MANUFACTURERS
  !!! перестроить применяемость в [032]
  !!! перестроить применяемость в [002]
  }
  if aParams[5] then
  begin
    //выгрузить только те TD_TYPES, которые не скрыты в TD_MANUFACTURERS
    CopyTableEx(
      ' SELECT t.* FROM [' + fTecdocDB + '].[dbo].[TD_TYPES] t ' +
      ' INNER JOIN [' + fTecdocDB + '].[dbo].[TD_MODELS] m ON (t.MOD_ID = m.MOD_ID) ' +
      ' INNER JOIN [' + fTecdocDB + '].[dbo].[TD_MANUFACTURERS] ma ON (m.MFA_ID = ma.MFA_ID and ma.HIDE = 0) ',
      '022',
      ['TYP_ID', 'MOD_ID', 'CDS_ID', 'MMT_CDS_ID', 'SORT', 'PCON_START', 'PCON_END', 'KW_FROM', 'KW_UPTO', 'HP_FROM', 'HP_UPTO', 'CCM', 'CYLINDERS', 'DOORS', 'TANK', 'VOLTAGE_DES_ID', 'ABS_DES_ID', 'ASR_DES_ID', 'ENGINE_DES_ID', 'BRAKE_TYPE_DES_ID', 'BRAKE_SYST_DES_ID', 'FUEL_DES_ID', 'CATALYST_DES_ID', 'BODY_DES_ID', 'STEERING_DES_ID', 'STEERING_SIDE_DES_ID', 'MAX_WEIGHT', 'DRIVE_DES_ID', 'TRANS_DES_ID', 'FUEL_SUPPLY_DES_ID', 'VALVES', 'ENG_CODES'],
      '',
      True,
      'TD_TYPES -> [022]',
      ' SELECT Count(t.ID) FROM [' + fTecdocDB + '].[dbo].[TD_TYPES] t ' +
      ' INNER JOIN [' + fTecdocDB + '].[dbo].[TD_MODELS] m ON (t.MOD_ID = m.MOD_ID) ' +
      ' INNER JOIN [' + fTecdocDB + '].[dbo].[TD_MANUFACTURERS] ma ON (m.MFA_ID = ma.MFA_ID and ma.HIDE = 0) '
    );
{
      CopyTable(
        '[' + fTecdocDB + '].[dbo].[TD_TYPES]',
        '022',
        ['TYP_ID', 'MOD_ID', 'CDS_ID', 'MMT_CDS_ID', 'SORT', 'PCON_START', 'PCON_END', 'KW_FROM', 'KW_UPTO', 'HP_FROM', 'HP_UPTO', 'CCM', 'CYLINDERS', 'DOORS', 'TANK', 'VOLTAGE_DES_ID', 'ABS_DES_ID', 'ASR_DES_ID', 'ENGINE_DES_ID', 'BRAKE_TYPE_DES_ID', 'BRAKE_SYST_DES_ID', 'FUEL_DES_ID', 'CATALYST_DES_ID', 'BODY_DES_ID', 'STEERING_DES_ID', 'STEERING_SIDE_DES_ID', 'MAX_WEIGHT', 'DRIVE_DES_ID', 'TRANS_DES_ID', 'FUEL_SUPPLY_DES_ID', 'VALVES', 'ENG_CODES']
      );
}
  end;

  // TD_MODELS -> [021]
  if aParams[6] then
  begin
    CopyTableEx(
      ' SELECT * FROM [' + fTecdocDB + '].[dbo].[TD_MODELS] m ' +
      ' WHERE EXISTS (SELECT ID FROM [' + fTecdocDB + '].[dbo].[TD_TYPES] t WHERE t.MOD_ID = m.MOD_ID) ',
      '021',
      ['MOD_ID', 'MFA_ID', 'PCON_START', 'PCON_END', 'TEX_TEXT'],
      '',
      True,
      'TD_MODELS -> [021]',
      ' SELECT Count(ID) FROM [' + fTecdocDB + '].[dbo].[TD_MODELS] m ' +
      ' WHERE EXISTS (SELECT ID FROM [' + fTecdocDB + '].[dbo].[TD_TYPES] t WHERE t.MOD_ID = m.MOD_ID) '
    );
  end;

  // TD_MANUFACTURERS -> [020]
  if aParams[7] then
  begin
    CopyTableEx(
      ' SELECT * FROM [' + fTecdocDB + '].[dbo].[TD_MANUFACTURERS] m ' +
      ' WHERE EXISTS (SELECT ID FROM [' + fTecdocDB + '].[dbo].[TD_MODELS] t WHERE t.MFA_ID = m.MFA_ID) ',
      '020',
      ['MFA_ID', 'MFA_BRAND', 'HIDE'],
      '',
      True,
      'TD_MANUFACTURERS -> [020]',
      ' SELECT Count(ID) FROM [' + fTecdocDB + '].[dbo].[TD_MANUFACTURERS] m ' +
      ' WHERE EXISTS (SELECT ID FROM [' + fTecdocDB + '].[dbo].[TD_MODELS] t WHERE t.MFA_ID = m.MFA_ID) '
    );
  end;




  //*** динамика - зависит от каталога ***

  // DESCRIPTIONS -> [013]
  if aParams[8] then
  begin
    CopyTableEx(
      ' SELECT cat.CAT_ID, d.DESCRIPTION FROM [' + fTecdocDB + '].[DBO].[DESCRIPTIONS] d ' +
      ' INNER JOIN [SERVICE].[DBO].[BRANDS] b ON (b.DESCRIPTION = d.BRAND) ' +
      ' INNER JOIN [SERVICE].[DBO].[CATALOG] cat ON (cat.CODE2 = d.CODE and cat.BRAND_ID = b.BRAND_ID) ',
      '013',
      ['CAT_ID', 'DESCRIPTION'],
      '',
      True,
      'DESCRIPTIONS -> [013]',
      ' SELECT Count(cat.CAT_ID) FROM [' + fTecdocDB + '].[DBO].[DESCRIPTIONS] d ' +
      ' INNER JOIN [SERVICE].[DBO].[BRANDS] b ON (b.DESCRIPTION = d.BRAND) ' +
      ' INNER JOIN [SERVICE].[DBO].[CATALOG] cat ON (cat.CODE2 = d.CODE and cat.BRAND_ID = b.BRAND_ID) '
    );
  end;

  // ART_TYP -> [023]
  if aParams[9] then
  begin
    CopyTableEx(
      ' SELECT ART_ID, TYP_ID FROM AT ',
      '023',
      ['ART_ID', 'TYP_ID'],
      '',
      True,
      'ART_TYP -> [023]',
      ' SELECT Count(*) FROM AT '
    );
  end;

{
  if aParams[9] then
  begin
    CopyTableEx(
      ' SELECT at.ART_ID, at.TYP_ID ' +
      ' FROM [' + fTecdocDB + '].[dbo].[ART_TYP] at ' +
      ' WHERE EXISTS ( ' +
      '   SELECT cat.ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE cat.TYP_TDID = at.ART_ID ' +
      ' ) ',
      '023',
      ['ART_ID', 'TYP_ID'],
      '',
      True,
      'ART_TYP -> [023]',
      ' SELECT Count(at.ID) ' +
      ' FROM [' + fTecdocDB + '].[dbo].[ART_TYP] at ' +
      ' WHERE EXISTS ( ' +
      '   SELECT cat.ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE cat.TYP_TDID = at.ART_ID ' +
      ' ) '
    );
  end;
}

  // TD_DETAILS -> [014]
  if aParams[10] then
  begin
    CopyTableEx(
      ' SELECT d.ART_ID, d.SORT, d.PARAM_ID, d.PARAM_VALUE ' +
      ' FROM [' + fTecdocDB + '].[DBO].[TD_DETAILS] d ' +
      ' WHERE EXISTS ( ' +
      '   SELECT cat.ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE cat.PARAM_TDID = d.ART_ID ' +
      ' ) ',
      '014',
      ['ART_ID=TECDOC_ID', 'SORT', 'PARAM_ID', 'PARAM_VALUE'],
      '',
      True,
      'TD_DETAILS -> [014]',
      ' SELECT count(d.ID) ' +
      ' FROM [' + fTecdocDB + '].[dbo].[TD_DETAILS] d ' +
      ' WHERE EXISTS ( ' +
      '   SELECT cat.ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE cat.PARAM_TDID = d.ART_ID ' +
      ' ) '
    );
  end;

  //типы с привязкой к каталогу
  (*  CopyTableEx(
      ' SELECT * FROM [' + fTecdocDB + '].[dbo].[TD_TYPES] WHERE TYP_ID IN ' +
      ' ( ' +
      '   SELECT DISTINCT at.TYP_ID ' +
      '   FROM [' + fTecdocDB + '].[dbo].[ART_TYP] at ' +
      '   INNER JOIN [SERVICE].[dbo].[CATALOG] cat ON (cat.TYP_TDID = at.ART_ID) ' +
      ' ) ',
      '022',
      ['TYP_ID', 'MOD_ID', 'CDS_ID', 'MMT_CDS_ID', 'SORT', 'PCON_START', 'PCON_END', 'KW_FROM', 'KW_UPTO', 'HP_FROM', 'HP_UPTO', 'CCM', 'CYLINDERS', 'DOORS', 'TANK', 'VOLTAGE_DES_ID', 'ABS_DES_ID', 'ASR_DES_ID', 'ENGINE_DES_ID', 'BRAKE_TYPE_DES_ID', 'BRAKE_SYST_DES_ID', 'FUEL_DES_ID', 'CATALYST_DES_ID', 'BODY_DES_ID', 'STEERING_DES_ID', 'STEERING_SIDE_DES_ID', 'MAX_WEIGHT', 'DRIVE_DES_ID', 'TRANS_DES_ID', 'FUEL_SUPPLY_DES_ID', 'VALVES', 'ENG_CODES'],
      '',
      True,
      'TD_TYPES -> [022]',
      ' SELECT Count(ID) FROM [' + fTecdocDB + '].[dbo].[TD_TYPES] WHERE TYP_ID IN ' +
      ' ( ' +
      '   SELECT DISTINCT at.TYP_ID ' +
      '   FROM [' + fTecdocDB + '].[dbo].[ART_TYP] at ' +
      '   INNER JOIN [SERVICE].[dbo].[CATALOG] cat ON (cat.TYP_TDID = at.ART_ID) ' +
      ' ) '
    );
  *)



  // TD_DETAILS_TYP -> [028]
  if aParams[11] then
  begin
    CopyTableEx(
      ' SELECT dt.ART_ID, dt.TYP_ID, dt.SORT, dt.PARAM_ID, dt.PARAM_VALUE FROM [' + fTecdocDB + '].[DBO].[TD_DETAILS_TYP] dt ' +
      ' WHERE EXISTS ( ' +
//      '   SELECT cat.ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE cat.PARAM_TDID = dt.ART_ID ' +
      '   SELECT cat.ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE cat.TYP_TDID = dt.ART_ID ' +
      ' ) ',
      '028',
      ['ART_ID=TECDOC_ID', 'TYP_ID', 'SORT', 'PARAM_ID', 'PARAM_VALUE'],
      '',
      True,
      'TD_DETAILS_TYP -> [028]',
      ' SELECT COUNT(dt.ID) FROM [' + fTecdocDB + '].[DBO].[TD_DETAILS_TYP] dt ' +
      ' WHERE EXISTS ( ' +
//      '   SELECT cat.ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE cat.PARAM_TDID = dt.ART_ID ' +
      '   SELECT cat.ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE cat.TYP_TDID = dt.ART_ID ' +
      ' ) ',
      True
    );
  end;


  // TD_PICTS -> [027]
  if aParams[12] then
  begin
    CopyTableEx(
      ' SELECT p.PICT_ID, p.PICT_DATA FROM [' + fTecdocDB + '].[DBO].[TD_PICTS] p ' +
      ' WHERE EXISTS ( ' +
      '   SELECT cat.PICT_ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE (cat.PICT_ID = p.PICT_ID) ' +
      ' ) ',
      '027',
      ['PICT_ID', 'PICT_DATA'],
      '',
      True,
      'TD_PICTS -> [027]',
      ' SELECT Count(p.PICT_ID) FROM [' + fTecdocDB + '].[DBO].[TD_PICTS] p ' +
      ' WHERE EXISTS ( ' +
      '   SELECT cat.PICT_ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE (cat.PICT_ID = p.PICT_ID) ' +
      ' ) ',
      True
    );
  end;

  if aParams[13] then
  begin
    DBISamExecuteSQL(
      'UPDATE [098] SET ' +
      ' DataVersion = ''' + fBuildInfo.Version + '.1'', ' +
      ' AssemblyVersion = ''' + fBuildInfo.Version + '.1'', ' +
      ' DiscretNumberVersion = ' + IntToStr(fBuildInfo.Num)
    );
  end;

  if not fAborted and aNeedBuildPrimen then
    BuildPrimen;

    finally
      aParams := nil;
      DBISAMDB.Close;
    end;
  end; //if aHasParams

  //Временно подрезано!!!!!!!!!!!!!!!!!!
  {  if not fAborted and aNeedMakeUpdate then
    MakeUpdate;}


//заливка в сервисную
{
 - каталог -------------
* CATALOG -> [002]
* BRANDS -> [003]
* GROUPS -> [004]
* GROUPBRAND -> [005]

 - аналоги -------------
* ANALOG -> [007]

 - OE ------------------
* OE -> [016]


* DES -> [024]
* CDS -> [025]

 - с join'ом на каталог -
* TD_DETAILS -> [014]
* TD_PARAMS -> [015]
* ART_TYP -> [023]
* TD_TYPES -> [022]
* TD_PICTS -> [027]

*  DESCRIPTIONS -> [013]
*  LoadArtTyp_opt2(lUpdate);   //ART_TYP -> [023]
*  LoadTypes(lUpdate);         //TD_TYPES -> [022]
*  LoadModels(lUpdate);        //TD_MODELS -> [021]
*  LoadManufacturers(lUpdate); //TD_MANUFACTURERS -> [020]
*  LoadCatDet(lUpdate);        //TD_DETAILS -> [014]
*  LoadCatTypDet(lUpdate);     //TD_DETAILS_TYP -> [028]
*  LoadCatParam(lUpdate);      //TD_PARAMS -> [015]
  LoadCatPict_opt(lUpdate);   //коды картинок
*  LoadPict(lUpdate);          //TD_PICTS


  
  LoadPrimenMemo;
(*

CREATE FUNCTION ConcatItems(@GroupId INT)
   RETURNS VARCHAR(4096)
AS
BEGIN
    DECLARE @ItemList varchar(4096)
    SET @ItemList = ''
 
    SELECT @ItemList = @ItemList + ',' + CAST(TYP_ID AS VARCHAR(16))
    FROM [' + fTecdocDB + '].[dbo].[ART_TYP] 
    WHERE ART_ID = @GroupId
 
    RETURN @ItemList
END
 
GO

 
SELECT cat.CAT_ID, at.ART_ID, dbo.ConcatItems(at.ART_ID) ItemList
FROM [' + fTecdocDB + '].[dbo].[ART_TYP] at
INNER JOIN [SERVICE].[dbo].[CATALOG] cat ON (cat.TYP_TDID = at.ART_ID)
GROUP BY cat.CAT_ID, at.ART_ID
ORDER BY at.ART_ID
*)
}

end;


procedure TFormMain.makeNewCurrent;
begin
  if not IsTableExists('CATALOG') then
  begin
    ExecuteQuery('BEGIN TRAN', []);
    try
      CreateAllTables(False);
      ExecuteQuery('INSERT INTO BUILDS (ISCUR) VALUES (1)', []);
      ExecuteQuery('COMMIT TRAN', []);
    except
      ExecuteQuery('ROLLBACK TRAN', []);
    end;


    UpdateStatusAll;
    Application.ProcessMessages;

    with TFormReleaseInfo.Create(Application) do
    try
      Caption := 'Новая сборка';
      Init(fBuildInfo, True);
      if ShowModal = mrOK then
      begin
        ExecuteQuery(
          ' UPDATE BUILDS SET VERSION = :VERSION, PARENT_VER = :PARENT_VER, NUM = :NUM, NOTE = :NOTE ' +
          ' WHERE ISCUR = 1 ',
          [Version, ParentVersion, DiscretVersion, Note]
        );
        UpdateStatusAll(True);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TFormMain.MakeUpdate(aPriceFieldName: string);
type
  TCompareType = (ctNew, ctDeleted, ctJoin);

  function CompareTablesSQL(aCompareType: TCompareType; const aCurTable, aParentTable: string;
    aConditions: string; aSelectFields, aCompareFields: array of string; const aCompareConditions: string = ''): string;
  const
    cDefCompareSQL =
      ' SELECT %s FROM [%s] c ' +
      ' WHERE %s NOT EXISTS ( ' +
      '  SELECT pc.* FROM [%s] pc WHERE (%s) ' +
      ' ) ';

    cDefJoinSQL =
      ' SELECT %s FROM [%s] c ' +
      ' INNER JOIN [%s] pc ON (%s) ';

  var
    i: Integer;
    sCompareFields: string;
    sSelectFields, sSelectFieldsJoin: string;
    sConditions: string;
  begin
    sCompareFields := '';
    for i := Low(aCompareFields) to High(aCompareFields) do
    begin
      if sCompareFields = '' then
        sCompareFields := Format('c.%s = pc.%s', [aCompareFields[i], aCompareFields[i]])
      else
        sCompareFields := sCompareFields + ' AND ' + Format('c.%s = pc.%s', [aCompareFields[i], aCompareFields[i]]);
    end;

    sSelectFields := '';
    sSelectFieldsJoin := '';
    for i := Low(aSelectFields) to High(aSelectFields) do
    begin
      if sSelectFields = '' then
        sSelectFields := 'c.' + aSelectFields[i]
      else
        sSelectFields := sSelectFields + ', c.' + aSelectFields[i];
      if sSelectFieldsJoin = '' then
        sSelectFieldsJoin := Format('c.%s %s1, pc.%s %s2', [aSelectFields[i], aSelectFields[i], aSelectFields[i], aSelectFields[i]])
      else
        sSelectFieldsJoin := sSelectFieldsJoin + ', ' + Format('c.%s %s1, pc.%s %s2', [aSelectFields[i], aSelectFields[i], aSelectFields[i], aSelectFields[i]]);
    end;

    if aConditions <> '' then
      sConditions := '(' + aConditions + ') AND '
    else
      sConditions := '';

    if aCompareConditions <> '' then
      sCompareFields := '(' + sCompareFields + ') AND (' + aCompareConditions + ')';

    case aCompareType of
      ctNew:
        Result := Format(cDefCompareSQL, [sSelectFields, aCurTable, sConditions, aParentTable, sCompareFields]);
      ctDeleted:
        Result := Format(cDefCompareSQL, [sSelectFields, aParentTable, sConditions, aCurTable, sCompareFields]);
      ctJoin:
      begin
        if aConditions <> '' then
          sConditions := ' WHERE ' + aConditions
        else
          sConditions := '';
        Result := Format(cDefJoinSQL, [sSelectFieldsJoin, aCurTable, aParentTable, sCompareFields]) + sConditions;
      end;
    end;
{
    'SELECT c.CAT_ID FROM [CATALOG] c ' +
    'WHERE c.TITLE IS NULL AND NOT EXISTS ( ' +
    '  SELECT pc.ID FROM [110810_CATALOG] pc WHERE (c.CODE2 = pc.CODE2 AND c.BRAND_ID = pc.BRAND_ID) ' +
    ') ';
}    
  end;

  function makeCsvRec(const aValues: array of string; aDelimitter: Char = ';'): string;
  var
    i: Integer;
  begin
    Result := '';
    for i := Low(aValues) to High(aValues) do
      Result := Result + aValues[i] + aDelimitter;
  end;

  procedure DoWriteUpdate(const aFileName: string; const aOperationCode: string;
    const aFieldsOut: array of string; aRewriteFile: Boolean; aCurrentRecOnly: Boolean = False);
  var
    fileCSV: TextFile;
    s: string;
    i: Integer;
    aStartProgressCaption: string;
    iRec: Integer;
  begin
    aStartProgressCaption := lbProgressInfo.Caption;

    AssignFile(fileCSV, aFileName);
    if aRewriteFile or (not FileExists(aFileName)) then
      Rewrite(fileCSV)
    else
      Append(fileCSV);

    if not aCurrentRecOnly then
      msQuery.Open;

    iRec := 0;
    while not msQuery.Eof do
    begin
      s := aOperationCode + ';';
      for i := Low(aFieldsOut) to High(aFieldsOut) do
        s := s + msQuery.FieldByName(aFieldsOut[i]).AsString + ';';
      Writeln(fileCSV, s);

      if not aCurrentRecOnly then
        msQuery.Next
      else
        Break;
      Inc(iRec);
      UpdateProgress(0, aStartProgressCaption + ' ' + IntToStr(iRec));
    end;

    if not aCurrentRecOnly then
      msQuery.Close;
    CloseFile(fileCSV);
  end;

  procedure AddFirstSimbol(filename: string);
  var
    aReader: TCSVReader;
    line, s: string;
    SL: TStringList;
  begin
    aReader := TCSVReader.Create;
    SL := TStringList.Create;
    try
    aReader.Open(FileName);
    while not aReader.Eof do
    begin
      line := aReader.ReturnLine;
      s := aReader.Fields[1];
      SL.Append(line  + IntTostr(Ord(s[1])));
    end;
    SL.SaveToFile(filename + '_new');
    finally
      aReader.Free;
      SL.Free;
    end;
  end;

var
  i,j: Integer;
  anOutDir, s, Descr : string;

  aPriceChanged, aGroupChanged,
  aNameChanged, aLinksChanged,
  aIDoubleChanged, aRecChanged: Boolean;

  fileCSV: TextFile;
  slVersions: TStrings;
  sl, ST: TStrings;
begin
  fReleasePrefix := fBuildInfo.ParentVersion;
  fUseRelease := fReleasePrefix <> '';
  if fUseRelease then
    fReleasePrefix := fReleasePrefix + '_';

  anOutDir := GetAppDir + 'Update\' + aPriceFieldName + '\';
  if not DirectoryExists(anOutDir) then
    ForceDirectories(anOutDir);

  DeleteFile(anOutDir + 'bra.csv');
  DeleteFile(anOutDir + 'gru.csv');
  DeleteFile(anOutDir + 'grb.csv');
  DeleteFile(anOutDir + 'cat_0.csv');
  DeleteFile(anOutDir + 'cat_1.csv');
  DeleteFile(anOutDir + 'cat_2.csv');
  DeleteFile(anOutDir + 'cat_3.csv');
  DeleteFile(anOutDir + 'cat_4.csv');
  DeleteFile(anOutDir + 'cat_5.csv');
  DeleteFile(anOutDir + 'cat_6.csv');
  DeleteFile(anOutDir + 'cat_7.csv');

  DeleteFile(anOutDir + 'oo.csv'); //товары "под заказ"

  DeleteFile(anOutDir + 'typ.csv'); //применяемость

  DeleteFile(anOutDir + 'ana_0.csv');
  DeleteFile(anOutDir + 'ana_0_descr1.csv');
  DeleteFile(anOutDir + 'ana_0_descr2.csv');
  DeleteFile(anOutDir + 'ana_0_descr3.csv');
  DeleteFile(anOutDir + 'ana_0_descr4.csv');
  DeleteFile(anOutDir + 'ana_0_descr5.csv');

  DeleteFile(anOutDir + 'ana_1.csv');
  DeleteFile(anOutDir + 'ana_1_descr1.csv');
  DeleteFile(anOutDir + 'ana_1_descr2.csv');
  DeleteFile(anOutDir + 'ana_1_descr3.csv');
  DeleteFile(anOutDir + 'ana_1_descr4.csv');
  DeleteFile(anOutDir + 'ana_1_descr5.csv');


  DeleteFile(anOutDir + 'oe_0.csv');
  DeleteFile(anOutDir + 'oe_0_descr.csv');
  DeleteFile(anOutDir + 'oe_1.csv');
  DeleteFile(anOutDir + 'oe_1_descr.csv');


  DeleteFile(anOutDir + 'kit_0.csv');
  DeleteFile(anOutDir + 'kit_1.csv');
  DeleteFile(anOutDir + 'kit_2.csv');

  DeleteFile(anOutDir + 'descr_0.csv');
  DeleteFile(anOutDir + 'descr_1.csv');
  DeleteFile(anOutDir + 'descr_2.csv');

// DeleteFile(anOutDir + 'sys.csv');
  DeleteFile(anOutDir + 'UpdateInfo.csv');
  DeleteFile(anOutDir + '0');


  //OE ----------------------------------------------------------------------
  UpdateProgress(0, 'Выгрузка OE [новые ID]...');
  msQuery.SQL.Clear;
  msQuery.SQL.Text :=
          ' SELECT main.cat_id as CAT_ID, main.gen_oe_id as GEN_OE_ID FROM [OE_BUF_' + fBuildInfo.Version + '] main ' +
          ' LEFT JOIN [OE_BUF_' + fBuildInfo.ParentVersion + '] j ON (main.gen_oe_id = j.gen_oe_id AND main.cat_id = j.cat_id) ' +
          ' WHERE j.gen_oe_id IS NULL ' +
          ' ORDER BY cat_id  ';
  msQuery.ExecSQL;
  DoWriteUpdate(anOutDir + 'OE_1.csv', '1', ['CAT_ID', 'GEN_OE_ID'], True);


  UpdateProgress(0, 'Выгрузка OE [новые DESCRIPTION]...');
  msQuery.SQL.Clear;
  msQuery.SQL.Text :=
           ' SELECT DISTINCT main.code as CODE, main.shortoe as SHORTOE, main.gen_oe_id as GEN_OE_ID '+
           ' FROM [OE_BUF_' + fBuildInfo.Version + '] main '+
           ' LEFT JOIN [OE_BUF_' + fBuildInfo.ParentVersion + '] j on (main.gen_oe_id = j.gen_oe_id and main.cat_id = j.cat_id) ' +
           ' WHERE j.gen_oe_id is null and main.gen_oe_id > (select max(gen_oe_id) FROM [OE_BUF_' + fBuildInfo.ParentVersion + ']) ' +
           ' ORDER BY gen_oe_id ';
  msQuery.ExecSQL;
  DoWriteUpdate(anOutDir + 'OE_1_descr.csv', '1', ['CODE', 'SHORTOE', 'GEN_OE_ID'], True);
  AddFirstSimbol(anOutDir + 'OE_1_descr.csv');
  DeleteFile(anOutDir + 'OE_1_descr.csv');
  RenameFile(anOutDir + 'OE_1_descr.csv_new', anOutDir + 'OE_1_descr.csv');

  UpdateProgress(0, 'Выгрузка OE [удаленные ID]...');
  msQuery.SQL.Clear;
  msQuery.SQL.Text :=
            ' SELECT j.cat_id as CAT_ID, j.gen_oe_id as GEN_OE_ID FROM [OE_BUF_' + fBuildInfo.Version + '] main ' +
            ' RIGHT JOIN [OE_BUF_' + fBuildInfo.ParentVersion + '] j ON (main.gen_oe_id = j.gen_oe_id and main.cat_id = j.cat_id) ' +
            ' WHERE main.gen_oe_id IS NULL ' +
            ' ORDER BY cat_id ';
  msQuery.ExecSQL;
  DoWriteUpdate(anOutDir + 'OE_0.csv', '0', ['CAT_ID', 'GEN_OE_ID'], True);


  UpdateProgress(0, 'Выгрузка OE [удаленные DESCRIPTION]...');
  msQuery.SQL.Clear;
  msQuery.SQL.Text :=
            'SELECT a1.gen_oe_id AS GEN_OE_ID FROM [OE_BUF_' + fBuildInfo.Version + '] a1 ' +
            ' GROUP BY a1.gen_oe_id HAVING count(*) = 1 and '+
						'			a1.gen_oe_id in (select t.old from ' +
						'						(SELECT distinct j.gen_oe_id as old, main.gen_oe_id as new from [OE_BUF_' + fBuildInfo.Version + '] main ' +
						'						RIGHT JOIN [OE_BUF_' + fBuildInfo.ParentVersion + '] j on (main.gen_oe_id = j.gen_oe_id and main.cat_id = j.cat_id) ' +
						'						WHERE main.gen_oe_id IS NULL ) t '+
            ' GROUP BY t.old HAVING count(*) = 1 ) ' +
            '	ORDER BY a1.gen_oe_id ';
  msQuery.ExecSQL;
  DoWriteUpdate(anOutDir + 'OE_0_descr.csv', '0', ['GEN_OE_ID'], True);

  


//аналоги ----------------------------------------------------------------------
  UpdateProgress(0, 'Выгрузка аналогов [новые ID]...');
  msQuery.SQL.Clear;
  msQuery.SQL.Text :=
          ' SELECT main.cat_id as CAT_ID, main.gen_an_id as GEN_AN_ID FROM [FULL_ANALOG_' + fBuildInfo.Version + '] main ' +
          ' LEFT JOIN [FULL_ANALOG_' + fBuildInfo.ParentVersion + '] j ON (main.gen_an_id = j.gen_an_id AND main.cat_id = j.cat_id) ' +
          ' WHERE j.gen_an_id IS NULL ' +
          ' ORDER BY cat_id ';
  msQuery.ExecSQL;
  DoWriteUpdate(anOutDir + 'ana_1.csv', '1', ['CAT_ID', 'GEN_AN_ID'], True);
            
  UpdateProgress(0, 'Выгрузка аналогов [новые DESCRIPTION]...');
  msQuery.SQL.Clear;
  msQuery.SQL.Text :=
           ' SELECT DISTINCT main.an_code as AN_CODE, main.an_brand as AN_BRAND, main.an_id as AN_ID, main.locked as LOCKED, main.gen_an_id as GEN_AN_ID ' +
           ' FROM [FULL_ANALOG_' + fBuildInfo.Version + '] main ' +
           ' LEFT JOIN [FULL_ANALOG_' + fBuildInfo.ParentVersion + '] j on (main.gen_an_id = j.gen_an_id and main.cat_id = j.cat_id) ' +
           ' WHERE j.gen_an_id is null and main.gen_an_id > (select max(gen_an_id) FROM [FULL_ANALOG_' + fBuildInfo.ParentVersion + ']) '+
           ' ORDER BY gen_an_id ';
  msQuery.ExecSQL;
  WriteAnalog(anOutDir + 'ana_1_descr.csv', '1', ['AN_CODE', 'AN_BRAND', 'AN_ID','LOCKED','GEN_AN_ID'], True);
  CuttingAnalogFile(anOutDir, 'ana_1_descr.csv', '1', 5);

  UpdateProgress(0, 'Выгрузка аналогов [удаленные ID]...');
  msQuery.SQL.Clear;
  msQuery.SQL.Text :=
            ' SELECT j.cat_id as CAT_ID, j.gen_an_id as GEN_AN_ID FROM [FULL_ANALOG_' + fBuildInfo.Version + '] main '+
            ' RIGHT JOIN [FULL_ANALOG_' + fBuildInfo.ParentVersion + '] j ON (main.gen_an_id = j.gen_an_id and main.cat_id = j.cat_id) ' +
            ' WHERE main.gen_an_id IS NULL ' +
            ' ORDER BY cat_id ';
  msQuery.ExecSQL;
  DoWriteUpdate(anOutDir + 'ana_0.csv', '0', ['CAT_ID', 'GEN_AN_ID'], True);

  UpdateProgress(0, 'Выгрузка аналогов [удаленные DESCRIPTION]...');
  msQuery.SQL.Clear;
  msQuery.SQL.Text :=
            ' SELECT a1.gen_an_id AS GEN_AN_ID FROM [FULL_ANALOG_' + fBuildInfo.Version + '] a1 ' +
            ' GROUP BY a1.gen_an_id HAVING count(*) = 1 and a1.gen_an_id in (select t.old from '+
            ' (SELECT distinct j.gen_an_id as old, main.gen_an_id as new from [FULL_ANALOG_' + fBuildInfo.Version + '] main ' +
            ' RIGHT JOIN [FULL_ANALOG_' + fBuildInfo.ParentVersion + '] j on (main.gen_an_id = j.gen_an_id and main.cat_id = j.cat_id) ' +
            ' WHERE main.gen_an_id IS NULL ) t '+
            ' GROUP BY t.old HAVING count(*) = 1 ) '+
            '	ORDER BY a1.gen_an_id ';
  msQuery.ExecSQL;
  DoWriteUpdate(anOutDir + 'ana_0_descr.csv', '0', ['GEN_AN_ID'], True);
  CuttingAnalogFile(anOutDir, 'ana_0_descr.csv', '0', 1);



  //список изменений -----------------------------------------------------------------------
  UpdateProgress(0, 'Выгрузка изменений [новые]...');
  msQuery.SQL.Text := Format(
    ' SELECT g.SUBGROUP_DESCR, b.DESCRIPTION, c.CODE, c.NAME FROM [%sCATALOG] c ' +
    ' LEFT JOIN [%sBRANDS] b ON (c.BRAND_ID = b.BRAND_ID) ' +
    ' LEFT JOIN [%sGROUPS] g ON (c.SUBGROUP_ID = g.SUBGROUP_ID AND c.GROUP_ID = g.GROUP_ID) ' +
    ' WHERE c.TITLE = 0 AND NOT EXISTS ( ' +
    '   SELECT pc.ID FROM [%sCATALOG] pc WHERE (c.CAT_ID = pc.CAT_ID) ' +
    ' ) ' +
    ' ORDER BY ' +
    ' g.SUBGROUP_DESCR, b.DESCRIPTION ',
    ['', '', '', fReleasePrefix]
  );
  DoWriteUpdate(anOutDir + 'UpdateInfo.csv', '0', ['SUBGROUP_DESCR', 'DESCRIPTION', 'CODE', 'NAME'], True);

  UpdateProgress(0, 'Выгрузка изменений [удаленные]...');
  msQuery.SQL.Text := Format(
    ' SELECT g.SUBGROUP_DESCR, b.DESCRIPTION, c.CODE, c.NAME FROM [%sCATALOG] c ' +
    ' LEFT JOIN [%sBRANDS] b ON (c.BRAND_ID = b.BRAND_ID) ' +
    ' LEFT JOIN [%sGROUPS] g ON (c.SUBGROUP_ID = g.SUBGROUP_ID AND c.GROUP_ID = g.GROUP_ID) ' +
    ' WHERE c.TITLE = 0 AND NOT EXISTS ( ' +
    '   SELECT pc.ID FROM [%sCATALOG] pc WHERE (c.CAT_ID = pc.CAT_ID) ' +
    ' ) ' +
    ' ORDER BY ' +
    ' g.SUBGROUP_DESCR, b.DESCRIPTION ',
    [fReleasePrefix, fReleasePrefix, fReleasePrefix, '']
  );
  DoWriteUpdate(anOutDir + 'UpdateInfo.csv', '1', ['SUBGROUP_DESCR', 'DESCRIPTION', 'CODE', 'NAME'], False);

//Текстовые описания--------------------------
  ST := TstringList.Create();
  try
    UpdateProgress(0, 'Выгрузка текстовых описаний [измененные]...');
    AssignFile(fileCSV, anOutDir + 'descr_2.csv');
    Rewrite(fileCSV);
    ST.AddStrings(ExecuteSimpleSelectMS2
     (' select descr.description, cat.[cat_id] from ' + fTecdocDB +'.[dbo].[DESCRIPTIONS] descr ' +
      ' INNER JOIN [SERVICE].[dbo].[CATALOG] cat on (cat.code2 = descr.code) ' +
      ' INNER JOIN [SERVICE].[dbo].[BRANDS] br on (br.description = descr.brand and cat.BRAND_ID = br.BRAND_ID) ' +
      ' where descr.hash in (SELECT d1.hash FROM [SERVICE].[dbo].[DSC] d1, [SERVICE].[dbo].['+ fReleasePrefix +'DSC] d2 '+
      ' where d1.cat_id = d2.cat_id and d1.hash<>d2.hash )',[]));
    j:=0;
    while ST.Count > j do
    begin
      ST.Strings[j+1] := StringReplace(ST.Strings[j+1],#13,'~13',[rfReplaceAll]);
      ST.Strings[j+1] := StringReplace(ST.Strings[j+1],';','~59',[rfReplaceAll]);
      s := '2' + ';' + ST.Strings[j] + ';' + ST.Strings[j+1];
      Writeln(fileCSV,s);
      j := j+2;
    end;
    ST.Clear;
    closefile(fileCSV);

    UpdateProgress(0, 'Выгрузка текстовых описаний [новые]...');
    AssignFile(fileCSV, anOutDir + 'descr_1.csv');
    Rewrite(fileCSV);
    ST.AddStrings(ExecuteSimpleSelectMS2
     (' select descr.description, cat.[cat_id] from ' + fTecdocDB +'.[dbo].[DESCRIPTIONS] descr ' +
      ' INNER JOIN [SERVICE].[dbo].[CATALOG] cat on (cat.code2 = descr.code) ' +
      ' INNER JOIN [SERVICE].[dbo].[BRANDS] br on (br.description = descr.brand and cat.BRAND_ID = br.BRAND_ID) ' +
      ' WHERE hash in ( ' +
      ' SELECT d1.hash FROM [SERVICE].[dbo].[DSC] d1 '+
      ' where d1.cat_id not in (select d2.cat_id from [SERVICE].[dbo].['+ fReleasePrefix +'DSC] d2)) ',[]));

    j := 0;
    while ST.Count > j do
    begin
      ST.Strings[j + 1] := StringReplace(ST.Strings[j + 1], #13, '~13', [rfReplaceAll]);
      ST.Strings[j + 1] := StringReplace(ST.Strings[j + 1], ';', '~59', [rfReplaceAll]);
      s := '1' + ';' + ST.Strings[j] + ';' + ST.Strings[j + 1];
      Writeln(fileCSV, s);
      j := j + 2;
    end;
  finally
    ST.Free;
  end;
  CloseFile(fileCSV);

  UpdateProgress(0, 'Выгрузка описаний [удаленные]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctDeleted,
    'DSC',
    fReleasePrefix + 'DSC',
    '',
    ['ID', 'CAT_ID'],
    ['CAT_ID']
  );
  DoWriteUpdate(anOutDir + 'descr_0.csv', '0', ['CAT_ID'], TRUE);


//брэнды -----------------------------------------------------------------------
  UpdateProgress(0, 'Выгрузка брендов [новые]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctNew,
    'BRANDS',
    fReleasePrefix + 'BRANDS',
    '',
    ['ID', 'Brand_id', 'Description'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'bra.csv', '0', ['ID', 'Brand_id', 'Description'], True);

  UpdateProgress(0, 'Выгрузка брендов [удаленные]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctDeleted,
    'BRANDS',
    fReleasePrefix + 'BRANDS',
    '',
    ['ID'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'bra.csv', '1', ['ID'], False);


//группы -----------------------------------------------------------------------
  UpdateProgress(0, 'Выгрузка групп [новые]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctNew,
    'GROUPS',
    fReleasePrefix + 'GROUPS',
    '',
    ['ID', 'Group_id', 'Group_descr', 'Subgroup_id', 'Subgroup_descr'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'gru.csv', '0', ['ID', 'Group_id', 'Group_descr', 'Subgroup_id', 'Subgroup_descr'], True);

  UpdateProgress(0, 'Выгрузка групп [удаленные]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctDeleted,
    'GROUPS',
    fReleasePrefix + 'GROUPS',
    '',
    ['ID'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'gru.csv', '1', ['ID'], False);


//дерево -----------------------------------------------------------------------
  UpdateProgress(0, 'Выгрузка дерева [новые]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctNew,
    'GROUPBRAND',
    fReleasePrefix + 'GROUPBRAND',
    '',
    ['ID', 'Group_id', 'Subgroup_id', 'Brand_id'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'grb.csv', '0', ['ID', 'Group_id', 'Subgroup_id', 'Brand_id'], True);

  UpdateProgress(0, 'Выгрузка дерева [удаленные]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctDeleted,
    'GROUPBRAND',
    fReleasePrefix + 'GROUPBRAND',
    '',
    ['ID'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'grb.csv', '1', ['ID'], False);





//каталог ----------------------------------------------------------------------
  UpdateProgress(0, 'Выгрузка каталога [удаленные]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctDeleted,
    'CATALOG',
    fReleasePrefix + 'CATALOG',
    'TITLE = 0',
    ['CAT_ID'],
    ['CAT_ID']
  );
  DoWriteUpdate(anOutDir + 'cat_0.csv', '0', ['CAT_ID'], True);

  UpdateProgress(0, 'Выгрузка каталога [новые]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctNew,
    'CATALOG',
    fReleasePrefix + 'CATALOG',
    '',//'title = 0',
    [
      'Cat_id',
      'Brand_id',
      'Group_id',
      'Subgroup_id',
      'Code',
      'Code2',
      'Name',
      'Description',
       aPriceFieldName,
      'T1',
      'T2',
      'Tecdoc_id',
      'New',
      'Sale',
      'Mult',
      'Usa',
      'Title',
      'pict_id',
      'typ_tdid',
      'param_tdid',
      'IDouble'
    ],
    ['CAT_ID'],
    ''
  );
  DoWriteUpdate(
    anOutDir + 'cat_1.csv',
    '1',
    [
      'Cat_id',
      'Brand_id',
      'Group_id',
      'Subgroup_id',
      'Code',
      'Code2',
      'Name',
      'Description',
       aPriceFieldName,
      'T1',
      'T2',
      'Tecdoc_id',
      'New',
      'Sale',
      'Mult',
      'Usa',
      'Title',
      'pict_id',
      'typ_tdid',
      'param_tdid',
      'IDouble'
    ],
    True
  );

//статусы "под заказ"-----------------------------------------------------------
  UpdateProgress(0, 'Выгрузка товаров "под заказ" [новые]...');
  DeleteFile(anOutDir + 'oo.csv');
  AssignFile(fileCSV, anOutDir + 'oo.csv');
  Rewrite(fileCSV);
  CloseFile(fileCSV);
  msQuery.SQL.Text := CompareTablesSQL(
    ctNew,
    'CATALOG',
    fReleasePrefix + 'CATALOG',
    'ORDER_ONLY = 1',
    ['CAT_ID'],
    ['CAT_ID']
  );
  DoWriteUpdate(anOutDir + 'oo.csv', '0', ['CAT_ID'], True);

  UpdateProgress(0, 'Выгрузка товаров "под заказ" [удаленные]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctDeleted,
    'CATALOG',
    fReleasePrefix + 'CATALOG',
    'ORDER_ONLY = 1',
    ['CAT_ID'],
    ['CAT_ID']
  );
  DoWriteUpdate(anOutDir + 'oo.csv', '1', ['CAT_ID'], False);
//------------------------------------------------------------------------------


  UpdateProgress(0, 'Выгрузка каталога [измененные]...');
  DeleteFile(anOutDir + 'cat_2.csv');
  AssignFile(fileCSV, anOutDir + 'cat_2.csv');
  Rewrite(fileCSV);
  CloseFile(fileCSV);

  DeleteFile(anOutDir + 'cat_3.csv');
  AssignFile(fileCSV, anOutDir + 'cat_3.csv');
  Rewrite(fileCSV);
  CloseFile(fileCSV);

  DeleteFile(anOutDir + 'cat_4.csv');
  AssignFile(fileCSV, anOutDir + 'cat_4.csv');
  Rewrite(fileCSV);
  CloseFile(fileCSV);

  DeleteFile(anOutDir + 'cat_5.csv');
  AssignFile(fileCSV, anOutDir + 'cat_5.csv');
  Rewrite(fileCSV);
  CloseFile(fileCSV);

  DeleteFile(anOutDir + 'cat_6.csv');
  AssignFile(fileCSV, anOutDir + 'cat_6.csv');
  Rewrite(fileCSV);
  CloseFile(fileCSV);

  DeleteFile(anOutDir + 'cat_7.csv');
  AssignFile(fileCSV, anOutDir + 'cat_7.csv');
  Rewrite(fileCSV);
  CloseFile(fileCSV);

  msQuery.SQL.Text := CompareTablesSQL(
    ctJoin,
    'CATALOG',
    fReleasePrefix + 'CATALOG',
    'c.TITLE = 0',
    [
      'Cat_id',
      'Brand_id',
      'Group_id',
      'Subgroup_id',
      'Code',
      'Code2',
      'Name',
      'Description',
       aPriceFieldName,
      'T1',
      'T2',
      'Tecdoc_id',
      'New',
      'Sale',
      'Mult',
      'Usa',
      'Title',
      'pict_id',
      'typ_tdid',
      'param_tdid',
      'IDouble',
      'ORDER_ONLY'
    ],
    ['CAT_ID']
  );
  msQuery.Open;
  i := 0;


  while not msQuery.Eof do
  begin
    aRecChanged := False;
(*
    if sl.IndexOf(msQuery.FieldByName('cat_id1').AsString) >= 0 then
      aRecChanged := True;
*)

    aPriceChanged := msQuery.FieldByName(aPriceFieldName + '1').Value <> msQuery.FieldByName(aPriceFieldName + '2').Value;

    aGroupChanged := (msQuery.FieldByName('Group_id1').Value <> msQuery.FieldByName('Group_id2').Value) or
                     (msQuery.FieldByName('SubGroup_id1').Value <> msQuery.FieldByName('SubGroup_id2').Value);

    //сравнивать через AsString, т.к. при заливке из сервисной может быть NULL
    aNameChanged  := (msQuery.FieldByName('Name1').AsString <> msQuery.FieldByName('Name2').AsString) or
                     (msQuery.FieldByName('Description1').AsString <> msQuery.FieldByName('Description2').AsString);

    aLinksChanged := (msQuery.FieldByName('Tecdoc_id1').Value <> msQuery.FieldByName('Tecdoc_id2').Value) or
                     (msQuery.FieldByName('Pict_id1').Value <> msQuery.FieldByName('Pict_id2').Value) or
                     (msQuery.FieldByName('typ_tdid1').Value <> msQuery.FieldByName('typ_tdid2').Value) or
                     (msQuery.FieldByName('param_tdid1').Value <> msQuery.FieldByName('param_tdid2').Value);

    aIDoubleChanged := msQuery.FieldByName('IDouble1').Value <> msQuery.FieldByName('IDouble2').Value;

    if msQuery.FieldByName('CODE1').AsString <> msQuery.FieldByName('CODE2').AsString then
      aRecChanged := True;

    if msQuery.FieldByName('Mult1').AsInteger <> msQuery.FieldByName('Mult2').AsInteger then
      aRecChanged := True;

    if ( aNameChanged and (aPriceChanged or aGroupChanged) ) or
       ( aLinksChanged and (aGroupChanged or aPriceChanged or aNameChanged) ) or
       ( aPriceChanged and aGroupChanged ) or
       aRecChanged then
    begin
      aRecChanged := True;
      aPriceChanged := False;
      aGroupChanged := False;
      aNameChanged := False;
      aLinksChanged := False;
      aIDoubleChanged := False;
    end;

    //товары под заказ - отдельным файлом---------------------------------------
    if msQuery.FieldByName('ORDER_ONLY1').AsInteger <> msQuery.FieldByName('ORDER_ONLY2').AsInteger then
      if msQuery.FieldByName('ORDER_ONLY1').AsInteger = 1 then //новый
        DoWriteUpdate(anOutDir + 'oo.csv', '0', ['Cat_id1'], False, True)
      else //удаленный
        DoWriteUpdate(anOutDir + 'oo.csv', '1', ['Cat_id1'], False, True);
    //-------------------------

    if aPriceChanged then
      DoWriteUpdate(anOutDir + 'cat_2.csv', '2', ['Cat_id1', aPriceFieldName + '1'], False, True);

    if aGroupChanged then
      DoWriteUpdate(anOutDir + 'cat_4.csv', '4', ['Cat_id1', 'Group_id1', 'Subgroup_id1'], False, True);

    if aNameChanged then
      DoWriteUpdate(anOutDir + 'cat_5.csv', '5', ['Cat_id1', 'Name1', 'Description1'], False, True);

    if aLinksChanged then
      DoWriteUpdate(anOutDir + 'cat_6.csv', '6', ['Cat_id1', 'Tecdoc_id1', 'pict_id1', 'typ_tdid1', 'param_tdid1'], False, True);

    if aIDoubleChanged then
      DoWriteUpdate(anOutDir + 'cat_7.csv', '7', ['Cat_id1', 'IDouble1'], False, True);


    if aRecChanged then
      DoWriteUpdate(
        anOutDir + 'cat_3.csv',
        '3',
        [
          'Cat_id1',
          'Brand_id1',
          'Group_id1',
          'Subgroup_id1',
          'Code1',
          'Code21',
          'Name1',
          'Description1',
           aPriceFieldName + '1',
          'T11',
          'T21',
          'Tecdoc_id1',
          'New1',
          'Sale1',
          'Mult1',
          'Usa1',
          'Title1',
          'pict_id1',
          'typ_tdid1',
          'param_tdid1',
          'IDouble1'
        ],
        False,
        True
      );

    msQuery.Next;

    Inc(i);
    UpdateProgress(0, 'Выгрузка каталога [измененные]... ' + IntToStr(i));
    if fAborted then
      Break;
  end;
  msQuery.Close;


//применяемость ----------------------------------------------------------------
  UpdateProgress(0, 'Выгрузка применяемости [новые]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctNew,
    'AT',
    fReleasePrefix + 'AT',
    '',
    ['ART_ID', 'TYP_ID'],
    ['ART_ID', 'TYP_ID']
  );

  try
    ExecuteQuery(' DROP TABLE AT_TMP ', []);
  except
    //ignore
  end;

  msQuery.SQL.Text := StringReplace(msQuery.SQL.Text, ' FROM', ' INTO AT_TMP FROM', [rfIgnoreCase]);
  ExecuteQuery(msQuery.SQL.Text, []);
  msQuery.SQL.Text := ' SELECT ART_ID, TYP_ID FROM AT_TMP ';

  DoWriteUpdate(anOutDir + 'typ.csv', '0', ['ART_ID', 'TYP_ID'], True);

  UpdateProgress(0, 'Выгрузка применяемости [удаленные]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctDeleted,
    'AT',
    fReleasePrefix + 'AT',
    '',
    ['ART_ID', 'TYP_ID'],
    ['ART_ID', 'TYP_ID']
  );

  ExecuteQuery(' DROP TABLE AT_TMP ', []);
  msQuery.SQL.Text := StringReplace(msQuery.SQL.Text, ' FROM', ' INTO AT_TMP FROM', [rfIgnoreCase]);
  ExecuteQuery(msQuery.SQL.Text, []);
  msQuery.SQL.Text := ' SELECT ART_ID, TYP_ID FROM AT_TMP ';

  DoWriteUpdate(anOutDir + 'typ.csv', '1', ['ART_ID', 'TYP_ID'], False);

  ExecuteQuery(' DROP TABLE AT_TMP ', []);

//------------------------------------------------------------------------------



  {UpdateProgress(0, 'Выгрузка аналогов [новые]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctNew,
    'ANALOG',
    fReleasePrefix + 'ANALOG',
    '',
    ['Id', 'Cat_id', 'An_code', 'An_brand', 'An_id', 'Locked'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'ana_1.csv', '1', ['Id', 'Cat_id', 'An_code', 'An_brand', 'An_id', 'Locked'], True);

  UpdateProgress(0, 'Выгрузка аналогов [удаленные]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctDeleted,
    'ANALOG',
    fReleasePrefix + 'ANALOG',
    '',
    ['ID'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'ana_0.csv', '0', ['ID'], True);

  UpdateProgress(0, 'Выгрузка аналогов [измененные]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctJoin,
    'ANALOG',
    fReleasePrefix + 'ANALOG',
    'c.AN_ID <> pc.AN_ID',
    ['ID', 'An_id', 'Cat_id', 'An_code', 'An_brand', 'Locked'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'ana_2.csv', '1', ['ID1', 'Cat_id1', 'An_code1', 'An_brand1', 'An_id1', 'Locked1'], True);
  }

//OE ---------------------------------------------------------------------------
{  UpdateProgress(0, 'Выгрузка OE [новые]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctNew,
    'OE',
    fReleasePrefix + 'OE',
    '',
    ['ID', 'Cat_id', 'Code', 'Code2'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'oe_1.csv', '1', ['ID', 'Cat_id', 'Code', 'Code2'], True);

  UpdateProgress(0, 'Выгрузка OE [удаленные]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctDeleted,
    'OE',
    fReleasePrefix + 'OE',
    '',
    ['ID'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'oe_0.csv', '0', ['ID'], True);  }


//комплекты ----------------------------------------------------------------------
  UpdateProgress(0, 'Выгрузка комплектов [новые]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctNew,
    'KIT',
    fReleasePrefix + 'KIT',
    '',
    ['ID', 'CAT_ID', 'CHILD_CODE', 'CHILD_BRAND', 'CHILD_ID', 'QUANTITY'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'kit_1.csv', '1', ['ID', 'CAT_ID', 'CHILD_CODE', 'CHILD_BRAND', 'CHILD_ID', 'QUANTITY'], True);

  UpdateProgress(0, 'Выгрузка комплектов [удаленные]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctDeleted,
    'KIT',
    fReleasePrefix + 'KIT',
    '',
    ['ID'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'kit_0.csv', '0', ['ID'], True);

  UpdateProgress(0, 'Выгрузка комплектов [измененные]...');
  msQuery.SQL.Text := CompareTablesSQL(
    ctJoin,
    'KIT',
    fReleasePrefix + 'KIT',
    'c.CHILD_ID <> pc.CHILD_ID OR c.QUANTITY <> pc.QUANTITY',
    ['ID', 'CHILD_ID', 'QUANTITY'],
    ['ID']
  );
  DoWriteUpdate(anOutDir + 'kit_2.csv', '1', ['ID1', 'CHILD_ID1', 'QUANTITY1'], True);



  UpdateProgress(0, 'Упаковка...');
  slVersions := TStringList.Create;
  slVersions.Add(fBuildInfo.Version + '.1');
  slVersions.Add(IntToStr(fBuildInfo.Num));
  slVersions.SaveToFile(anOutDir + '0');
  slVersions.Free;
  with Zipper do
  begin
    RootDir := IncludeTrailingPathDelimiter(anOutDir);
    ZipName := anOutDir + 'data_d' + fBuildInfo.Version + '.1.zip';
    Password := 'shatem+' + '-' + fBuildInfo.Version + '.1';

    if FileExists(ZipName) then
      SysUtils.DeleteFile(ZipName);

    FilesList.Clear;
    FilesList.Add(anOutDir + 'bra.csv');
    FilesList.Add(anOutDir + 'gru.csv');
    FilesList.Add(anOutDir + 'grb.csv');
    FilesList.Add(anOutDir + 'cat_0.csv');
    FilesList.Add(anOutDir + 'cat_1.csv');
    FilesList.Add(anOutDir + 'cat_2.csv');
    FilesList.Add(anOutDir + 'cat_3.csv');
    FilesList.Add(anOutDir + 'cat_4.csv');
    FilesList.Add(anOutDir + 'cat_5.csv');
    FilesList.Add(anOutDir + 'cat_6.csv');
    FilesList.Add(anOutDir + 'cat_7.csv');
    FilesList.Add(anOutDir + 'oo.csv');
    FilesList.Add(anOutDir + 'typ.csv');
    FilesList.Add(anOutDir + 'ana_0.csv');
    FilesList.Add(anOutDir + 'ana_0_descr1.csv');
    FilesList.Add(anOutDir + 'ana_0_descr2.csv');
    FilesList.Add(anOutDir + 'ana_0_descr3.csv');
    FilesList.Add(anOutDir + 'ana_0_descr4.csv');
    FilesList.Add(anOutDir + 'ana_0_descr5.csv');
    FilesList.Add(anOutDir + 'ana_1.csv');
    FilesList.Add(anOutDir + 'ana_1_descr1.csv');
    FilesList.Add(anOutDir + 'ana_1_descr2.csv');
    FilesList.Add(anOutDir + 'ana_1_descr3.csv');
    FilesList.Add(anOutDir + 'ana_1_descr4.csv');
    FilesList.Add(anOutDir + 'ana_1_descr5.csv');

    FilesList.Add(anOutDir + 'OE_1.csv');
    FilesList.Add(anOutDir + 'OE_1_descr.csv');
    FilesList.Add(anOutDir + 'OE_0.csv');
    FilesList.Add(anOutDir + 'OE_0_descr.csv');

    //    FilesList.Add(anOutDir + 'ana_2.csv');
//    FilesList.Add(anOutDir + 'oe_0.csv');
//    FilesList.Add(anOutDir + 'oe_1.csv');

    FilesList.Add(anOutDir + 'kit_0.csv');
    FilesList.Add(anOutDir + 'kit_1.csv');
    FilesList.Add(anOutDir + 'kit_2.csv');

    FilesList.Add(anOutDir + 'sys.csv');
    FilesList.Add(anOutDir + 'UpdateInfo.csv');

    FilesList.Add(anOutDir + 'descr_0.csv');
    FilesList.Add(anOutDir + 'descr_1.csv');
    FilesList.Add(anOutDir + 'descr_2.csv');

    FilesList.Add(anOutDir + '0');
    StorePaths := False;
    Zip;
  end;

  UpdateProgress(0, 'finish');
end;

//[kri]
{ рекурсивно чистит директорию с поддиректориями                               }
{ aDeleteDir - нужно ли удалить переданную директорию aPath                    }
function EraseDirFiles(aPath: string; aDeleteDir: Boolean): Boolean;
const
{$IFDEF WIN32}
  cFileNotFound = 18;
{$ELSE}
  cFileNotFound = -18;
{$ENDIF}
var
  aFileInfo: TSearchRec;
  aFound: Integer;
begin
  Result := DirectoryExists(aPath);
  if not Result then
    Exit;

  aPath := IncludeTrailingPathDelimiter(aPath);
  aFound := FindFirst(aPath + '*.*', faAnyFile, aFileInfo);
  try
    while aFound = 0 do begin
      if (aFileInfo.Name[1] <> '.') and (aFileInfo.Attr <> faVolumeID) then
      begin
        if (aFileInfo.Attr and faDirectory = faDirectory) then
          Result := EraseDirFiles(aPath + aFileInfo.Name, aDeleteDir) and Result
        else if (aFileInfo.Attr and faVolumeID <> faVolumeID) then begin
          if (aFileInfo.Attr and SysUtils.faReadOnly = SysUtils.faReadOnly) then
            FileSetAttr(aPath + aFileInfo.Name, faArchive);
          Result := SysUtils.DeleteFile(aPath + aFileInfo.Name) and Result;
        end;
      end;
      aFound := FindNext(aFileInfo);
    end;
  finally
    SysUtils.FindClose(aFileInfo);
  end;

  //папка пустая и это не корень диска
  if aDeleteDir and Result and (aFound = cFileNotFound) and
    not ( (Length(aPath) = 2) and (aPath[2] = ':') ) then
  begin
    RemoveDir(aPath);
    Result := (IOResult = 0) and Result;
  end;
end;

procedure TFormMain.MakeUpdatePicts;
var
  anOutDir, anOutDirPicts: string;
  aQuery: TAdoQuery;
  aReader: TCSVReader;
  slVersions: TStrings;
begin
  anOutDir := GetAppDir + 'Update\';
  if not DirectoryExists(anOutDir) then
    ForceDirectories(anOutDir);

  anOutDirPicts := anOutDir + 'Picts\';
  if not DirectoryExists(anOutDirPicts) then
    ForceDirectories(anOutDirPicts);

  fReleasePrefix := fBuildInfo.ParentVersion;
  fUseRelease := fReleasePrefix <> '';
  if fUseRelease then
    fReleasePrefix := fReleasePrefix + '_';

  DeleteFile(anOutDir + 'picts.csv');

  UpdateProgress(0, 'Очистка целевой директории...');
  EraseDirFiles(anOutDirPicts, False);

  //новые
  ExportTableEx(
    anOutDir + 'picts.csv',
    ' SELECT p.PICT_ID FROM [PICTS] p ' +
    ' WHERE NOT EXISTS ( ' +
    '  SELECT pc.ID FROM [' + fReleasePrefix + 'PICTS] pc WHERE (p.PICT_ID = pc.PICT_ID) ' +
    ' ) ',
    ['PICT_ID'],
    '0',
    True,
    'Экспорт списка картинок (новые)',
    ' SELECT Count(p.PICT_ID) FROM [PICTS] p ' +
    ' WHERE NOT EXISTS ( ' +
    '  SELECT pc.ID FROM [' + fReleasePrefix + 'PICTS] pc WHERE (p.PICT_ID = pc.PICT_ID) ' +
    ' ) '
  );

  //плюс измененные
  ExportTableEx(
    anOutDir + 'picts.csv',
    ' SELECT p.PICT_ID FROM [PICTS] p ' +
    ' INNER JOIN [' + fReleasePrefix + 'PICTS] pc ON (p.PICT_ID = pc.PICT_ID and p.HASH <> pc.HASH) where p.PICT_ID <> 0',
    ['PICT_ID'],
    '0',
    False, //дописать
    'Экспорт списка картинок (измененные)',
    ' SELECT Count(p.PICT_ID) FROM [PICTS] p ' +
    ' INNER JOIN [' + fReleasePrefix + 'PICTS] pc ON (p.PICT_ID = pc.PICT_ID and p.HASH <> pc.HASH) where p.PICT_ID <> 0 '
  );


  //----------------------------------------------------------------------------
  UpdateProgress(0, 'Экспорт картинок... ');

  aQuery := TAdoQuery.Create(nil);
  aQuery.DisableControls;
  aQuery.Connection := connService;
//  aQuery.CursorLocation := clUseServer;
//  aQuery.CursorType := ctOpenForwardOnly;
  aQuery.CommandTimeout := 60 * 5;
  aQuery.SQL.Text :=
    ' SELECT p.PICT_ID, p.PICT_DATA FROM [' + fTecdocDB + '].[DBO].[TD_PICTS] p ' +
    ' WHERE p.PICT_ID = :PICT_ID ';
  aQuery.Prepared := True;

  aReader := TCSVReader.Create;
  try
    aReader.Open(anOutDir + 'picts.csv');
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      if aReader.LineNum mod 50 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Экспорт картинок... ' + IntToStr(aReader.LineNum));
      if fAborted then
        Break;

      aQuery.Parameters[0].Value := aReader.Fields[0];
      aQuery.Open;
      if not aQuery.Eof then
        TBlobField(aQuery.Fields[1]).SaveToFile(anOutDirPicts + aQuery.Fields[0].AsString + '.jpg');
      aQuery.Close;
    end;

  finally
    aReader.Free;
    aQuery.Free;
    UpdateProgress(0, 'finish');
  end;

  UpdateProgress(0, 'Упаковка...');
  slVersions := TStringList.Create;
  slVersions.Add(fBuildInfo.Version + '.1');
  slVersions.Add(IntToStr(fBuildInfo.Num));
  slVersions.SaveToFile(anOutDir + '0');
  slVersions.Free;

  with Zipper do
  begin
    RootDir := IncludeTrailingPathDelimiter(anOutDir);
    ZipName := anOutDir + 'picts_d' + fBuildInfo.Version + '.1.zip';
    Password := 'shatem+' + '-' + fBuildInfo.Version + '.1';

    if FileExists(ZipName) then
      SysUtils.DeleteFile(ZipName);

    FilesList.Clear;
    FilesList.Add(anOutDirPicts + '*.*');
    FilesList.Add(anOutDir + 'picts.csv');
    FilesList.Add(anOutDir + '0');
    StorePaths := True;
    RelativePaths := True;
    Zip;
  end;

  UpdateProgress(0, 'finish');
end;

function TFormMain.GetBuildInfo(out aBuildInfo: TBuildInfo; aBuildVersion: string = ''): Boolean;
var
  aQuery: TAdoQuery;
  aWhere: string;
begin
  Result := False;
  ZeroMemory(@aBuildInfo, SizeOf(Result));

  if aBuildVersion = '' then
    aWhere := ' WHERE ISCUR = 1'
  else
    aWhere := ' WHERE VERSION = ''' + aBuildVersion + ''' ';

  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := connService;
    aQuery.SQL.Text := ' SELECT * FROM BUILDS ' + aWhere;
    aQuery.Open;
    if not aQuery.EOF then
    begin
      aBuildInfo.Version := aQuery.FieldByName('VERSION').AsString;
      aBuildInfo.ParentVersion := aQuery.FieldByName('PARENT_VER').AsString;
      aBuildInfo.Num := aQuery.FieldByName('NUM').AsInteger;
      aBuildInfo.Note := aQuery.FieldByName('NOTE').AsString;
      Result := True;
    end;
  finally
    aQuery.Free;
  end;
end;

function TFormMain.GetIsAdminPermission: Boolean;
begin
  Result := SameText(fCurrUser, 'Admin');
end;

procedure TFormMain.ApplyUserRights;
var
  anAdmin: Boolean;
begin
  anAdmin := GetIsAdminPermission;
  miFillFromService.Visible := anAdmin;
  miMoveToCurrent.Visible := anAdmin;
  Button1.Visible := anAdmin;
end;

procedure TFormMain.BitBtn1Click(Sender: TObject);
begin
  // todo: открыть окно с настройками
  with TFormReleaseInfo.Create(Application) do
  try
    Init(fBuildInfo, false);
    if ShowModal = mrOK then
    begin
      ExecuteQuery(
        ' UPDATE BUILDS SET VERSION = :VERSION, PARENT_VER = :PARENT_VER, NUM = :NUM, NOTE = :NOTE ' +
        ' WHERE ISCUR = 1 ',
        [Version, ParentVersion, DiscretVersion, Note]
      );
      UpdateStatusAll(True);
    end;
  finally
    Free;
  end;

end;

procedure TFormMain.N0Click(Sender: TObject);
begin
  RecognizeTecdoc;
end;

procedure TFormMain.miFillFromServiceClick(Sender: TObject);
begin
  LoadFromService;
  UpdateStatusAll;
end;


procedure TFormMain.N2Click(Sender: TObject);
var
  i: integer;
  PriceFieldList: TStrings;
begin
{  PriceFieldList := TStringList.Create;
  PriceFieldList.Add('Price');
  PriceFieldList.Add('Price_PODOLSK');
  for i:=0 to PriceFieldList.Count -1 do
    MakeUpdate(PriceFieldList[i]);}
  MakeUpdate('Price');
  ValidateSrez;

 // PriceFieldList.Free;
end;

procedure TFormMain.miMakeATFullClick(Sender: TObject);
begin
  makeFullPrimen;
end;

procedure TFormMain.miMakeUpdatePictsClick(Sender: TObject);
begin
  MakeUpdatePicts;
end;

procedure TFormMain.miMoveToCurrentClick(Sender: TObject);
begin
  RenameAllTables(fBuildInfo.ParentVersion + '_', '');
end;

procedure TFormMain.miMoveToTempClick(Sender: TObject);
var
  aTableName: string;
  aTmpIndex: Integer;
begin
  if MsgBoxYN('Перенести во временные сборки?') then
  begin
    ExecuteQuery('BEGIN TRAN', []);
    try
      aTmpIndex := 0;
      repeat
        Inc(aTmpIndex);
        aTableName := 'tmp' + IntToStr(aTmpIndex) + '_CATALOG';
      until not IsTableExists(aTableName);

      RenameAllTables('', 'tmp' + IntToStr(aTmpIndex) + '_');
      WriteBuildLog('Перенесено во временные сборки');

      ExecuteQuery(
        ' UPDATE BUILDS SET VERSION = :VERSION ' +
        ' WHERE ISCUR = 1 ',
        ['tmp' + IntToStr(aTmpIndex)]
      );
      ExecuteQuery('UPDATE BUILDS SET ISCUR = 0 WHERE ISCUR = 1', []);
      ExecuteQuery('COMMIT TRAN', []);
      MsgBoxInfo('Перенос выполнен');
    except
      ExecuteQuery('ROLLBACK TRAN', []);
      if IsTableExists('tmp' + IntToStr(aTmpIndex) + '_CATALOG') then
        MsgBoxErr('Ошибка: временная сборка ' + '"tmp' + IntToStr(aTmpIndex) + '" уже существует');
    end;
    makeNewCurrent;
    WriteBuildLog('*** Пользователь: ' + fCurrUser + ' ***', True);
    UpdateStatusAll;
  end;
end;

//склейка всех файлов аналогов в один (с конвертированием)
function TFormMain.JoinAllAnalogsFiles: string;

  procedure CopyFileContent(const aFileFrom, aFileTo: string; aRewriteFile: Boolean);
  var
    aFrom, aTo: TextFile;
    s: string;
  begin
    AssignFile(aFrom, aFileFrom);
    AssignFile(aTo, aFileTo);

    Reset(aFrom);
    if aRewriteFile or (not FileExists(aFileTo)) then
      Rewrite(aTo)
    else
      Append(aTo);

    try
      while not Eof(aFrom) do
      begin
        Readln(aFrom, s);
        Writeln(aTo, s);
      end;
    finally
      CloseFile(aTo);
      CloseFile(aFrom);
    end;
  end;

  procedure CrossToAnalogs(const aFileFrom, aFileTo: string; aRewriteFile: Boolean);
  var
    aReader: TCSVReader;
    aCode1, aBrand1, aCode2, aBrand2: string;
    aTo: TextFile;
  begin
    AssignFile(aTo, aFileTo);
    if aRewriteFile or (not FileExists(aFileTo)) then
      Rewrite(aTo)
    else
      Append(aTo);

    aReader := TCSVReader.Create;
    try
      aReader.Open(aFileFrom);
      while not aReader.Eof do
      begin
        aReader.ReturnLine;
        if not DecodeCodeBrand(aReader.Fields[0], aCode1, aBrand1, False) then
          Continue;
        if not DecodeCodeBrand(aReader.Fields[1], aCode2, aBrand2, False) then
          Continue;
        Writeln(aTo, aBrand1 + ';' + aCode1 + ';' + aBrand2 + ';' + aCode2);
      end;

    finally
      aReader.Free;
      CloseFile(aTo);
    end;

  end;

  procedure UniversalCodeToAnalogs(const aFileFrom, aFileTo: string; aRewriteFile: Boolean);
  var
    aReader: TCSVReader;
    anCodePrev, aGoods, anCode, anGoods: string;
    aCode1, aBrand1, aCode2, aBrand2: string;
    fOut: TextFile;
    sl: TStrings;
    i, j: Integer;

    aQuery: TAdoQuery;
  begin

    AssignFile(fOut, aFileTo);
    if aRewriteFile or (not FileExists(aFileTo)) then
      Rewrite(fOut)
    else
      Append(fOut);

    aQuery := TAdoQuery.Create(nil);
    aReader := TCSVReader.Create;
    try

      //заливаем файл во временную таблицу ANA_TMP
      if IsTableExists('ANA_TMP') then
        ExecuteQuery(' DROP TABLE ANA_TMP ', []);

      ExecuteQuery(
        ' CREATE TABLE [dbo].[ANA_TMP]( ' +
        '  [CODE_BRAND] [varchar](250) COLLATE Cyrillic_General_CI_AS NULL, ' +
        '  [NUM] [varchar](16) COLLATE Cyrillic_General_CI_AS NULL ' +
        ' ) ON [PRIMARY] ',
        []
      );

      aQuery.Connection := connService;
      aQuery.CursorLocation := clUseClient;
      aQuery.CursorType := ctStatic;

      aQuery.SQL.Text := ' INSERT INTO ANA_TMP (CODE_BRAND, NUM) VALUES (:CODE_BRAND, :NUM) ';
      aQuery.Prepared := True;

      aReader.Open(aFileFrom);
      while not aReader.Eof do
      begin
        aReader.ReturnLine;
        UpdateProgress(aReader.FilePosPercent);

        if aReader.Fields[1] = '' then
          Continue;

        aQuery.Parameters[0].Value := aReader.Fields[0];
        aQuery.Parameters[1].Value := aReader.Fields[1];
        aQuery.ExecSQL;
      end;
      aReader.Close;


      //селектим сортируя по номеру аналога и выгружаем во временный файл
      aQuery.SQL.Text := ' SELECT NUM, CODE_BRAND FROM ANA_TMP ORDER BY NUM, CODE_BRAND ';
      aQuery.Open;

      //пишем в правильном формате
      sl := makeStrings;
      try
        anCodePrev := '';
        while not aQuery.Eof do
        begin
          if anCodePrev = '' then
            anCodePrev := aQuery.Fields[0].AsString;

          anCode := aQuery.Fields[0].AsString;
          anGoods := aQuery.Fields[1].AsString;
          aQuery.Next;

          if (anCodePrev <> anCode) or aQuery.Eof then
          begin
            if aQuery.Eof then
              sl.Add(anGoods);

            if sl.Count > 1 then
              for i := 0 to sl.Count - 2 do
              begin
                for j := i + 1 to sl.Count - 1 do
                begin
                  if not DecodeCodeBrand(sl[i], aCode1, aBrand1, False) then
                    Continue;
                  if not DecodeCodeBrand(sl[j], aCode2, aBrand2, False) then
                    Continue;
                  Writeln(fOut, aBrand1 + ';' + aCode1 + ';' + aBrand2 + ';' + aCode2);
                  Writeln(fOut, aBrand2 + ';' + aCode2 + ';' + aBrand1 + ';' + aCode1);
                end;
              end;
            sl.Clear;
          end;
          sl.Add(anGoods);
          anCodePrev := anCode;

          UpdateProgress(aReader.FilePosPercent);
        end;
      finally
        sl.Free;
      end;

      aQuery.Close;
      ExecuteQuery(' DROP TABLE ANA_TMP ', []);
    finally
      aQuery.Free;
      aReader.Free;
      CloseFile(fOut);
    end;
  end;

var
  outFileName: string;
begin
  outFileName := GetAppDir + cJoinedAnalogsFileName;
  DeleteFile(outFileName);

  if edFileAnalog.Text <> '' then
  begin
//    WriteBuildLog('Объединение аналогов - аналоги Лотус из ' + edFileAnalog.Text);

    UpdateProgress(0, 'Объединение аналогов - аналоги Лотус');
    CopyFileContent(edFileAnalog.Text, outFileName, False);
  end;

  if edFileAnalog_LOCKED.Text <> '' then
  begin
//    WriteBuildLog('Объединение аналогов - заблокированные аналоги из ' + edFileAnalog_LOCKED.Text);

    UpdateProgress(0, 'Объединение аналогов - заблокированные аналоги');
    CopyFileContent(edFileAnalog_LOCKED.Text, outFileName, False);
  end;

  if edFileAnalog_UNI.Text <> '' then
  begin
//    WriteBuildLog('Объединение аналогов - универсальный код аналога из ' + edFileAnalog_UNI.Text);

    UpdateProgress(0, 'Объединение аналогов - универсальный код аналога');
    UniversalCodeToAnalogs(edFileAnalog_UNI.Text, outFileName, False);
  end;

  if edFileAnalog_CROSS.Text <> '' then
  begin
//    WriteBuildLog('Объединение аналогов - аналоги CROSS из ' + edFileAnalog_CROSS.Text);

    UpdateProgress(0, 'Объединение аналогов - аналоги CROSS');
    CrossToAnalogs(edFileAnalog_CROSS.Text, outFileName, False);
  end;

  UpdateProgress(0, ' ');
  Result := outFileName;
end;

procedure TFormMain.btLoadFilesClick(Sender: TObject);
var
  t: Cardinal;
  aFileName: string;
begin
  Validate;

  fAborted := False;
  UpdateProgress(0, ' ');
  (Sender as TButton).Enabled := False;
  btLoadToService.Enabled := False;
  btOtherActions.Enabled := False;

  t := GetTickCount;
  try
    fReleasePrefix := fBuildInfo.ParentVersion;
    fUseRelease := fReleasePrefix <> '';
    if fUseRelease then
      fReleasePrefix := fReleasePrefix + '_';

    if not LoadLockedBrands then
      raise Exception.Create('Файл LockedBrand.txt не найден!');

    if not fAborted then
      if cbLoadCatalog.Checked then
      begin
        LoadCatalog(edFileCatalog.Text);
       // LoadPrice(edFilePircePodolsk.Text,'PRICE_PODOLSK','Импорт цен для Подольска: ');
        if not fAborted then
          RecognizeTecdoc;
      end;

    if not fAborted then
      if cbLoadAnalog.Checked then
//        LoadAnalogs(edFileAnalog.Text);
        LoadAnalogsNew(edFileAnalog.Text);

    if not fAborted then
      if cbLoadOE.Checked then
      begin
        LoadOE(edFileOE.Text);
        LoadOENew;
      end;

    if not fAborted then
      if cbLoadKIT.Checked then
        LoadKIT(edFileKIT.Text);

  finally
    UpdateProgress(0, 'finish, exec time: ' + IntToStr((GetTickCount - t) div 1000));
    (Sender as TButton).Enabled := True;
    btLoadToService.Enabled := True;
    btOtherActions.Enabled := True;

    UpdateStatusAll;
  end;
end;

procedure TFormMain.btLoadToServiceClick(Sender: TObject);
begin
  if fBuildInfo.CatalogCount = 0 then
    raise Exception.Create('Каталог пуст');

  btLoadFiles.Enabled := False;
  btLoadToService.Enabled := False;
  btOtherActions.Enabled := False;
  try
    LoadToService;
  finally
    btLoadFiles.Enabled := True;
    btLoadToService.Enabled := True;
    btOtherActions.Enabled := True;
  end;
end;


procedure TFormMain.btOtherActionsClick(Sender: TObject);
begin
  pmActions.Popup(btOtherActions.ClientOrigin.X + btOtherActions.Width, btOtherActions.ClientOrigin.Y + btOtherActions.Height);
end;

procedure TFormMain.N4Click(Sender: TObject);
begin
  if fBuildInfo.Version = '' then
  begin
    MsgBoxWarn('Не задана версия сборки.');
    Exit;
  end;

  if MsgBoxYN('Перенести в готовые сборки?') then
  begin
    ExecuteQuery('BEGIN TRAN', []);
    try
      RenameAllTables('', fBuildInfo.Version + '_');
      WriteBuildLog('Перенесено в готовые сборки');
      ExecuteQuery('UPDATE BUILDS SET ISCUR = 0 WHERE ISCUR = 1', []);
      ExecuteQuery('COMMIT TRAN', []);
      MsgBoxInfo('Перенос выполнен');
    except
      ExecuteQuery('ROLLBACK TRAN', []);
      if IsTableExists(fBuildInfo.Version + '_CATALOG') then
        MsgBoxErr('Ошибка: сборка с версией ' + fBuildInfo.Version + ' уже существует');
    end;
    makeNewCurrent;
    WriteBuildLog('*** Пользователь: ' + fCurrUser + ' ***', True);
    UpdateStatusAll;
  end;
end;

procedure TFormMain.WriteAnalog(const aFileName: string; const aOperationCode: string;
    const aFieldsOut: array of string; aRewriteFile: Boolean; aCurrentRecOnly: Boolean = False);
  var
    fileCSV: TextFile;
    s: string;
    i: Integer;
    aStartProgressCaption: string;
    iRec: Integer;
  begin
    aStartProgressCaption := lbProgressInfo.Caption;

    AssignFile(fileCSV, aFileName);
    if aRewriteFile or (not FileExists(aFileName)) then
      Rewrite(fileCSV)
    else
      Append(fileCSV);

    if not aCurrentRecOnly then
      msQuery.Open;
    msQuery.DisableControls;
    iRec := 0;
    while not msQuery.Eof do
    begin
      s := aOperationCode + ';';
      for i := Low(aFieldsOut) to High(aFieldsOut) do
        s := s + StringReplace(msQuery.FieldByName(aFieldsOut[i]).AsString, #$D#$A, '',[rfReplaceAll]) + ';';
      Writeln(fileCSV, s + CreateShortCode(msQuery.FieldByName('AN_CODE').AsString));

      if not aCurrentRecOnly then
        msQuery.Next
      else
        Break;
      Inc(iRec);
      UpdateProgress(0, aStartProgressCaption + ' ' + IntToStr(iRec));
    end;

    if not aCurrentRecOnly then
      msQuery.Close;
    msQuery.EnableControls;  
    CloseFile(fileCSV);
  end;

procedure TFormMain.WriteBuildLog(const aText: string;
  anIncludeDate: Boolean = False; anIncludeTime: Boolean = True);
var
  s, sAdd: string;
begin
  //при первой записи в лог добавляем запись о времени и логине пользователя
  if not fUserLoginLogAdded then
  begin
    sAdd := FormatDateTime('dd.mm.yyyy ', fUserLoginAt);
    sAdd := sAdd + FormatDateTime('hh:nn:ss ', fUserLoginAt);
    sAdd := sAdd + '- ' + '*** Пользователь: ' + fCurrUser + ' ***';

    s := ExecuteSimpleSelectMS(' SELECT LOGS FROM BUILDS WHERE ISCUR = 1 ', []) + #13#10 + sAdd;
    ExecuteQuery(' UPDATE BUILDS SET LOGS = :LOGS WHERE ISCUR = 1 ', [s]);
    MemoLog.Lines.Add(sAdd);
    fUserLoginLogAdded := True;
  end;


  sAdd := '';
  if anIncludeDate then
    sAdd := FormatDateTime('dd.mm.yyyy ', Now);
  if anIncludeTime then
    sAdd := sAdd + FormatDateTime('hh:nn:ss ', Now);

  if sAdd <> '' then
    sAdd := sAdd + '- ' + aText
  else
    sAdd := Text;

  s := ExecuteSimpleSelectMS(' SELECT LOGS FROM BUILDS WHERE ISCUR = 1 ', []) + #13#10 + sAdd;
  ExecuteQuery(' UPDATE BUILDS SET LOGS = :LOGS WHERE ISCUR = 1 ', [s]);
  MemoLog.Lines.Add(sAdd);
end;

procedure TFormMain.N6Click(Sender: TObject);
begin
  if not MsgBoxYN('Все загруженные данные будут удалены, продолжить?') then
    Exit;
    
  ExecuteQuery('UPDATE BUILDS SET LOGS = NULL WHERE ISCUR = 1', []);

  UpdateProgress(0, 'Очистка каталога...');
  ClearTable('CATALOG');
  UpdateProgress(0, 'Очистка брэндов...');
  ClearTable('BRANDS');
  UpdateProgress(0, 'Очистка групп...');
  ClearTable('GROUPS');
  ClearTable('GROUPBRAND');

  UpdateProgress(0, 'Очистка аналогов...');
  ClearTable('ANALOG');

  UpdateProgress(0, 'Очистка OE...');
  ClearTable('OE');
  UpdateProgress(0, ' ');

  UpdateProgress(0, 'Очистка комплектов...');
  ClearTable('KIT');
  UpdateProgress(0, ' ');

  UpdateProgress(0, 'Очистка среза применяемости...');
  ClearTable('AT');
  UpdateProgress(0, ' ');

  UpdateProgress(0, 'Очистка среза картинок...');
  ClearTable('PICTS');
  UpdateProgress(0, ' ');

  WriteBuildLog('*** Пользователь: ' + fCurrUser + ' ***', True);
  UpdateStatusAll;
end;


procedure TFormMain.lbReleasesClick(Sender: TObject);
begin
  with TForm1.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
  UpdateStatusAll;
end;

procedure TFormMain.Button1Click(Sender: TObject);
var
  aQuery: TAdoQuery;
  anUpdatedCount: Integer;
begin
  fReleasePrefix := fBuildInfo.ParentVersion;
  fUseRelease := fReleasePrefix <> '';
  if fUseRelease then
    fReleasePrefix := fReleasePrefix + '_';


  anUpdatedCount := 0;
  aQuery := TAdoQuery.Create(nil);
  try
    aQuery.Connection := connService;
    aQuery.SQL.Text :=
      'SELECT c.ID, pc.tecdoc_id, pc.TYP_TDID, pc.PARAM_TDID, pc.PICT_ID ' +
      'FROM [CATALOG] c ' +
      'INNER JOIN [' + fReleasePrefix + 'CATALOG] pc ON (c.CAT_ID = pc.CAT_ID) ' +
      'WHERE c.tecdoc_id <> pc.tecdoc_id and pc.tecdoc_id > 0 and c.tecdoc_id = 0 ' +
      'order by pc.tecdoc_id ';
    aQuery.Open;

    while not aQuery.Eof do
    begin
      ExecuteQuery(
        ' UPDATE [SERVICE].[dbo].[CATALOG] ' +
        ' SET TECDOC_ID = :TECDOC_ID, TYP_TDID = :TYP_TDID, PARAM_TDID = :PARAM_TDID, PICT_ID = :PICT_ID ' +
        ' WHERE ID = :ID',
        [aQuery.Fields[1].AsInteger, aQuery.Fields[2].AsInteger, aQuery.Fields[3].AsInteger, aQuery.Fields[4].AsInteger, aQuery.Fields[0].AsInteger]
      );

      aQuery.Next;
      Inc(anUpdatedCount);
    end;
    aQuery.Close;
  finally
    aQuery.Free;
  end;

  ShowMessage('Обновлено: ' + IntToStr(anUpdatedCount));

//
{

SELECT c.CAT_ID, c.CODE, c.tecdoc_id,
       pc.CAT_ID, pc.CODE, pc.tecdoc_id
FROM [CATALOG] c
INNER JOIN [110919_CATALOG] pc ON (c.CAT_ID = pc.CAT_ID)
WHERE c.tecdoc_id <> pc.tecdoc_id and pc.tecdoc_id > 0 and c.tecdoc_id = 0
order by pc.tecdoc_id
}
end;


procedure TFormMain.Button2Click(Sender: TObject);
var
  aFileName: string;
  aReader: TCSVReader;
  aCount: Integer;
begin
  OD.FileName := '';
  if OD.Execute then
    aFileName := OD.FileName
  else
    Exit;

  ExecuteQuery('UPDATE CATALOG SET LOCKED = 0', []);

  aReader := TCSVReader.Create;
  aReader.Open(aFileName);
  aCount := 0;
  while not aReader.Eof do
  begin
    aReader.ReturnLine;
    ExecuteQuery('UPDATE CATALOG SET LOCKED = 1 WHERE CATEGORY = :CATEGORY', [aReader.Fields[0]]);
    UpdateProgress(aReader.FilePosPercent, 'блокировка товаров...');
  end;
  aReader.Free;

  UpdateProgress(0, 'блокировка аналогов...');
  ExecuteQuery(
    ' update analog set del_locked = 1 where cat_id in ( ' +
    '   select c.cat_id from catalog c where c.Locked = 1 ' +
    ' ) ',
    []
  );
  UpdateProgress(50, 'блокировка аналогов...');
  ExecuteQuery(
    ' update analog set del_locked = 1 where an_id in ( ' +
    '   select c.cat_id from catalog c where c.Locked = 1 ' +
    ' ) ',
    []
  );

  UpdateProgress(0, ' ');
end;

procedure TFormMain.makeSrez_Primen;
var
  aQuery: TADOQuery;
begin
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := connService;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.CommandTimeout := 60 * 20; //timeout 10 min


    UpdateProgress(0, 'Построение применяемости - очистка...');
    aQuery.SQL.Text := ' DROP TABLE AT ';
    aQuery.ExecSQL;

    aQuery.SQL.Text :=
      ' CREATE TABLE [dbo].[AT]( ' +
      ' [ID] [int] IDENTITY(1,1) NOT NULL, ' +
      ' [ART_ID] [int] NULL, ' +
      ' [TYP_ID] [int] NULL, ' +
      '  CONSTRAINT [PK_AT] PRIMARY KEY CLUSTERED ' +
      ' ( ' +
      ' [ID] ASC ' +
      ' )WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY] ' +
      ' ) ON [PRIMARY] ';
    aQuery.ExecSQL;

    aQuery.SQL.Text :=
      ' CREATE NONCLUSTERED INDEX [ART] ON [dbo].[AT] ' +
      ' ( [ART_ID] ASC ) ' +
      ' WITH (PAD_INDEX  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] ';
    aQuery.ExecSQL;

    aQuery.SQL.Text :=
      ' CREATE NONCLUSTERED INDEX [TYP] ON [dbo].[AT] ' +
      ' ( [TYP_ID] ASC ) ' +
      ' WITH (PAD_INDEX  = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY] ';
    aQuery.ExecSQL;



    //построить таблицу отфильтрованных типов
    UpdateProgress(30, 'Построение применяемости - отфильтрованные авто...');
    aQuery.SQL.Text := ' DELETE FROM [' + fTecdocDB + '].[dbo].[TD_TYPES_FILT] ';
    aQuery.ExecSQL;

    aQuery.SQL.Text :=
      ' INSERT INTO [' + fTecdocDB + '].[dbo].[TD_TYPES_FILT] (TYP_ID) ' +
      ' SELECT DISTINCT t.TYP_ID FROM [' + fTecdocDB + '].[dbo].[TD_TYPES] t ' +
      ' INNER JOIN [' + fTecdocDB + '].[dbo].[TD_MODELS] m ON (t.MOD_ID = m.MOD_ID) ' +
      ' INNER JOIN [' + fTecdocDB + '].[dbo].[TD_MANUFACTURERS] ma ON (m.MFA_ID = ma.MFA_ID and ma.HIDE = 0) ';
    aQuery.ExecSQL;


    //заполняем артикула к типам в сервисной (собираем только те артикула и типы которые есть в сборке)
    UpdateProgress(60, 'Построение применяемости - заливка...');
    aQuery.SQL.Text :=
      ' INSERT INTO AT (ART_ID, TYP_ID)  ' +
      ' SELECT at.ART_ID, at.TYP_ID ' +
      ' FROM [' + fTecdocDB + '].[dbo].[ART_TYP] at ' +
      ' WHERE EXISTS ( ' +
      '   SELECT cat.ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE cat.TYP_TDID = at.ART_ID ' +
      ' ) ' +
      ' AND ' +
      ' at.TYP_ID IN ( ' +
      '   SELECT t.TYP_ID FROM [' + fTecdocDB + '].[dbo].[TD_TYPES_FILT] t ' +
      ' ) ';
    aQuery.ExecSQL;
  finally
    aQuery.Free;
  end;
  UpdateProgress(0, ' ');
end;


//картинки
procedure TFormMain.makeSrez_Picts;
var
  aQuery: TADOQuery;
begin
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.Connection := connService;
    aQuery.CursorLocation := clUseServer;
    aQuery.CursorType := ctOpenForwardOnly;
    aQuery.CommandTimeout := 60 * 5; //timeout 5m

    
    UpdateProgress(0, 'Построение картинок - очистка...');
    aQuery.SQL.Text := ' DROP TABLE PICTS ';
    try
      aQuery.ExecSQL;
    except
      //таблицы может не быть
    end;

    aQuery.Close;
    aQuery.SQL.Text :=
      ' CREATE TABLE [dbo].[PICTS]( ' +
      ' [ID] [int] IDENTITY(1,1) NOT NULL, ' +
      ' [PICT_ID] [int] NULL, ' +
      ' [HASH] [char](32) COLLATE Cyrillic_General_CI_AS NULL, ' +
      '  CONSTRAINT [PK_PICTS] PRIMARY KEY CLUSTERED ' +
      ' ( ' +
      ' [ID] ASC ' +
      ' )WITH (PAD_INDEX  = OFF, IGNORE_DUP_KEY = OFF) ON [PRIMARY] ' +
      ' ) ON [PRIMARY] ';
    aQuery.ExecSQL;

    //заполняем хэши картинок в сервисной (собираем только те которые есть в сборке)
    UpdateProgress(30, 'Построение картинок - заливка...');
    aQuery.SQL.Text :=
      ' INSERT INTO PICTS (PICT_ID, HASH) ' +
      ' SELECT tp.PICT_ID, tp.HASH FROM [' + fTecdocDB + '].[dbo].[TD_PICTS] tp ' +
      ' WHERE EXISTS ( ' +
      '   SELECT cat.ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE cat.PICT_ID = tp.PICT_ID ' +
      ' ) ';
     aQuery.ExecSQL;
  finally
    aQuery.Free;
  end;
  UpdateProgress(0, ' ');
end;

procedure TFormMain.makeSrez_Descr;
var
  i, cnt: Integer;
  aQuery: TADOQuery;
  iHash, iId , text: string;
begin
  i := 0;
  aQuery := TADOQuery.Create(nil);
  try
    UpdateProgress(0, 'Загрузка текстовых описаний...');

    aQuery.CommandTimeout := 3000;
    aQuery.Connection := msQuery.Connection;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctStatic;
    aQuery.SQL.Text := ' SELECT description, id FROM [' + fTecdocDB + '].[dbo].[DESCRIPTIONS]';
    aQuery.Open;
    cnt :=  aQuery.RecordCount;
    while not (aQuery.Eof) do
    begin
      iHash := MD5DigestToStr(MD5String(aQuery.FieldByName('description').AsString));
      iId :=aQuery.FieldByName('id').AsString;
      ExecuteQuery
        (' UPDATE [' + fTecdocDB + '].[dbo].[DESCRIPTIONS]  set HASH = :iHash WHERE ID= :iId'
        ,[iHash,iId]);
      aQuery.next;

      Inc(i);
      if i mod 100 = 0 then
        UpdateProgress(i*100 div cnt, 'Загрузка тектовых описаний... ' + IntToStr(i));
      if fAborted then
        Break;
    end;
   aQuery.Close;


   ExecuteQuery('DELETE from [SERVICE].[dbo].[DSC]', []);
   ExecuteQuery(
     ' INSERT into [SERVICE].[dbo].[DSC] (CAT_ID, HASH) ' +
     '   SELECT cat.[cat_id], descr.[hash] ' +
     '   FROM [' + fTecdocDB + '].[dbo].[DESCRIPTIONS] descr ' +
     '   INNER JOIN [SERVICE].[dbo].[BRANDS] br on (br.description = descr.brand) ' +
     '   INNER JOIN [SERVICE].[dbo].[CATALOG] cat on (cat.code2 = descr.code and cat.BRAND_ID = br.BRAND_ID) ',
     []
   );
   finally
    UpdateProgress(0, 'Текстовые описания загружены...');
    aQuery.Free;
  end;

(*
  try
    UpdateProgress(0, 'Загрузка табличных описаний...');
    ExecuteQuery('DELETE from [SERVICE].[dbo].[PARAMS]', []);
    ExecuteQuery(
      ' INSERT into [SERVICE].[dbo].[PARAMS] (PARAM_ID, DESCRIPTION) ' +
      ' SELECT TD_PARAMS.[PARAM_ID], TD_PARAMS.[DESCRIPTION] ' +
      ' FROM [' + fTecdocDB + '].[dbo].[TD_PARAMS] ',[]);


    ExecuteQuery('DELETE from [SERVICE].[dbo].[DETAILS]', []);

    ExecuteQuery(
      ' INSERT into [SERVICE].[dbo].[DETAILS] (ART_ID, SORT, PARAM_ID, PARAM_VALUE) ' +
      ' SELECT d.[art_id], d.[sort], d.[param_id], d.[param_value] FROM [' + fTecdocDB + '].[dbo].[TD_DETAILS] ' +
      ' WHERE exists (select * from [service].[dbo].[catalog] c where c.param_tdid = d.art_id) '
      ,[]);

  finally
    UpdateProgress(0, 'Табличные описания загружены...');
  end;
*)
end;



procedure TFormMain.makeSrez_Det;
var
  i, aMax, ArtId, ArtIdPrev: Integer;
  aQuery: TADOQuery;
  iHash, iId , text: string;
begin
  i := 0;

  UpdateProgress(0, 'Загрузка табличных описаний - очистка...');
  
  ExecuteQuery(' DELETE from DET ', []);
  try
    ExecuteQuery(' DROP TABLE DET_TMP ', []);
  except
    //таблицы может не быть
  end;

  UpdateProgress(0, 'Загрузка табличных описаний - заливка...');
  ExecuteQuery(
    ' SELECT ' +
    '   d.ART_ID, ' +
    '   CHECKSUM(d.SORT, p.DESCRIPTION, d.PARAM_VALUE) REC_HASH ' +
    ' INTO [DET_TMP] ' +
    ' FROM [TECDOC2014].[dbo].[TD_DETAILS] d ' +
    ' LEFT JOIN [TECDOC2014].[dbo].[td_params] p on (p.PARAM_ID = d.PARAM_ID) ' +
    ' WHERE EXISTS ( ' +
    '   SELECT c.CAT_ID FROM [CATALOG] c WHERE c.PARAM_TDID = d.ART_ID ' +
    ' ) ' +
    ' ORDER BY d.ART_ID, d.SORT, d.PARAM_ID, d.PARAM_VALUE ',
    []
  );

  UpdateProgress(0, 'Загрузка табличных описаний - пересчет хэш...');
  ExecuteQuery(
    ' INSERT INTO [DET] (ART_ID, PARAMS_CHECKSUM) ' +
    '   SELECT ART_ID, CHECKSUM_AGG(REC_HASH) ' +
    '   FROM [DET_TMP] ' +
    '   GROUP BY ART_ID ',
    []
  );

  ExecuteQuery(' DROP TABLE DET_TMP ', []);
  UpdateProgress(0, 'finish');
Exit;














  
{
  ExecuteQuery(
    ' SELECT d.ART_ID, d.SORT, p.DESCRIPTION PARAM_NAME, d.PARAM_VALUE ' +
    ' INTO DET_TMP ' +
    ' FROM [' + fTecdocDB + '].[dbo].[TD_DETAILS] d ' +
    ' LEFT JOIN [' + fTecdocDB + '].[dbo].[TD_PARAMS] p on (p.PARAM_ID = d.PARAM_ID) ' +
    ' WHERE EXISTS ( ' +
    '   SELECT c.CAT_ID FROM [CATALOG] c WHERE c.PARAM_TDID = d.ART_ID ' +
    ' ) ' +
    ' ORDER BY d.ART_ID, d.SORT, d.PARAM_ID ',
    []
  );
  
  UpdateProgress(0, 'Загрузка табличных описаний - пересчет хэша...');
}  
  aQuery := TADOQuery.Create(nil);
  try
    aQuery.CommandTimeout := 300;
    aQuery.Connection := msQuery.Connection;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctStatic;
    aQuery.SQL.Text := 
      ' SELECT d.ART_ID, HASHBYTES( ''MD5'', Str(d.SORT) + p.DESCRIPTION + d.PARAM_VALUE) as REC_HASH ' +
      //' INTO DET_TMP ' +
      ' FROM [' + fTecdocDB + '].[dbo].[TD_DETAILS] d ' +
      ' LEFT JOIN [' + fTecdocDB + '].[dbo].[TD_PARAMS] p on (p.PARAM_ID = d.PARAM_ID) ' +
      ' WHERE EXISTS ( ' +
      '   SELECT c.CAT_ID FROM [CATALOG] c WHERE c.PARAM_TDID = d.ART_ID ' +
      ' ) ' +
      ' ORDER BY d.ART_ID, d.SORT, d.PARAM_ID, d.PARAM_VALUE ';
    aQuery.Open;
    aMax := StrToIntDef(
      ExecuteSimpleSelectMS(
        ' SELECT Count(d.ART_ID) FROM [' + fTecdocDB + '].[dbo].[TD_DETAILS] d ' +
        ' WHERE EXISTS ( ' +
        '   SELECT c.CAT_ID FROM [CATALOG] c WHERE c.PARAM_TDID = d.ART_ID ' +
        ' ) ', []
      ), 
      0
    );
    
    iHash := '';
    i := 0;
    ArtIdPrev := aQuery.Fields[0].AsInteger;
    ArtId := ArtIdPrev;
    while not (aQuery.Eof) do
    begin
      iHash := iHash + aQuery.Fields[1].AsString;
      ArtIdPrev := ArtId;
      aQuery.Next;
      
      ArtId := aQuery.Fields[0].AsInteger;
      if aQuery.Eof or (ArtId <> ArtIdPrev)then
      begin
        iHash := MD5DigestToStr(MD5String(iHash));
        ExecuteQuery(
          ' INSERT INTO DET (ART_ID, PARAMS_HASH) VALUES (:ART_ID, :PARAMS_HASH) ',
          [ArtIdPrev, iHash]
        );
        iHash := '';
      end;

      Inc(i);
      if i mod 100 = 0 then
        UpdateProgress(i*100 div aMax, 'Загрузка табличных описаний... ' + IntToStr(i));
      if fAborted then
        Break;
    end;
    aQuery.Close;

  finally
    UpdateProgress(0, 'Табличные описания загружены...');
    aQuery.Free;
  end;
end;

procedure TFormMain.makeSrez_DetTyp;
begin
  UpdateProgress(0, 'Загрузка ограничений - очистка...');
  
  ExecuteQuery(' DELETE from DET_TYP ', []);
  try
    ExecuteQuery(' DROP TABLE DET_TYP_TMP ', []);
  except
    //таблицы может не быть
  end;

  UpdateProgress(0, 'Загрузка ограничений - заливка...');
  ExecuteQuery(
    ' SELECT ' +
    '   d.ART_ID, ' +
    '   d.TYP_ID, ' +
    '   CHECKSUM(d.SORT, p.DESCRIPTION, d.PARAM_VALUE) REC_HASH ' +
    ' INTO [DET_TYP_TMP] ' +
    ' FROM [TECDOC2014].[dbo].[TD_DETAILS_TYP] d ' +
    ' LEFT JOIN [TECDOC2014].[dbo].[td_params] p on (p.PARAM_ID = d.PARAM_ID) ' +
    ' WHERE EXISTS ( ' +
    '   SELECT c.CAT_ID FROM [CATALOG] c WHERE c.TYP_TDID = d.ART_ID ' +
    ' ) AND EXISTS ( ' +
    '   SELECT tf.TYP_ID FROM [TECDOC2014].[DBO].[TD_TYPES_FILT] tf WHERE d.TYP_ID = tf.TYP_ID ' +
    ' ) ' +
    ' ORDER BY d.ART_ID, d.TYP_ID, d.SORT, d.PARAM_ID, d.PARAM_VALUE ',
    [],
    6000 {aTimeout}
  );

  UpdateProgress(0, 'Загрузка ограничений - пересчет хэш...');
  ExecuteQuery(
    ' INSERT INTO [DET_TYP] (ART_ID, TYP_ID, PARAMS_CHECKSUM) ' +
    '   SELECT ART_ID, TYP_ID, CHECKSUM_AGG(REC_HASH) ' +
    '   FROM [DET_TYP_TMP] ' +
    '   GROUP BY ART_ID, TYP_ID ',
    []
  );

  ExecuteQuery(' DROP TABLE DET_TYP_TMP ', []);
  UpdateProgress(0, 'finish');
end;

procedure TFormMain.btMakeSrezClick(Sender: TObject);
begin
  with TSrezParamsForm.Create(Self) do
  try
    if ShowModal <> mrOK then
      Exit;
      
    fAborted := False;  
    if cbParam_Primen.Checked and (not fAborted) then
      makeSrez_Primen;
      
    if cbParam_Picts.Checked and (not fAborted) then
      makeSrez_Picts;

    if cbParam_Descr.Checked and (not fAborted) then
      makeSrez_Descr;

    if cbParam_Det.Checked and (not fAborted) then
      makeSrez_Det;
      
    if cbParam_DetTyp.Checked and (not fAborted) then
      makeSrez_DetTyp;
      
  finally
    Free;
  end;
end;

type
  TExportOut = class
  private
    fOwner: TFormMain;
    fPictIDs: TStrings;
  public
    CurrentCodeBrand: string;
    SitePathPicts: string;

    constructor Create(aOwner: TFormMain);
    destructor Destroy; override;

    property PictIDs: TStrings read fPictIDs;
    
    procedure GetValueAnalog(const aFieldName: string; var aValue: string);
    procedure GetValueCars(const aFieldName: string; var aValue: string);
    procedure GetValueDetTyp(const aFieldName: string; var aValue: string);
    procedure GetValueDet(const aFieldName: string; var aValue: string);
    procedure GetValuePict(const aFieldName: string; var aValue: string);
  end;

constructor TExportOut.Create(aOwner: TFormMain);
begin
  fOwner := aOwner;
  fPictIDs := makeStrings;
end;

destructor TExportOut.Destroy;
begin
  fPictIDs.Free;
  inherited;
end;

procedure TExportOut.GetValueAnalog(const aFieldName: string; var aValue: string);
begin
  if SameText(aFieldName, 'AN_CODE_BRAND') then
  begin
    if Copy(aValue, Length(aValue), 1) = '_' then
      aValue := aValue + 'CROSS';//'STELLOX';
  end
  else if SameText(aFieldName, 'LOCKED') then
    if aValue = '0' then
      aValue := '1'
    else
      aValue := '0';
end;

procedure TExportOut.GetValueCars(const aFieldName: string; var aValue: string);

  function GetDesText(aDesID: Integer): string;
  begin
//    Result := fOwner.ExecuteSimpleSelectMS('SELECT TEX_TEXT FROM [' + fTecdocDB + '].[DBO].[TD_DES] WHERE DES_ID = :DES_ID', [aDesID]);
    if fOwner.memDES.FindKey([aDesID]) then
      Result := fOwner.memDES.FieldByName('TEX_TEXT').AsString
    else
      Result := '';
  end;

begin
  if SameText(aFieldName, 'years') then
  begin
    if Length(aValue) = 15 then
      aValue := Copy(aValue, 1, 4) + '/' + Copy(aValue, 5, 9) + '/' + Copy(aValue, 14, 2)
    else if Length(aValue) = 10 then //201009 - 0
      aValue := Copy(aValue, 1, 4) + '/' + Copy(aValue, 5, MaxInt);
  end
  else if SameText(aFieldName, 'CCM_ROUND') then
  begin
    aValue := FormatFloat( '0.0', RoundTo( StrToIntDef(aValue, 0) / 1000, -1));
  end
  else if SameText(aFieldName, 'BODY_DES_ID') then
  begin
    aValue := GetDesText(StrToIntDef(aValue, 0));
  end
  else if SameText(aFieldName, 'ENGINE_DES_ID') then
  begin
    aValue := GetDesText(StrToIntDef(aValue, 0));
  end
  else if SameText(aFieldName, 'FUEL_SUPPLY_DES_ID') then
  begin
    aValue := GetDesText(StrToIntDef(aValue, 0));
  end
  else if SameText(aFieldName, 'CATALYST_DES_ID') then
  begin
    aValue := GetDesText(StrToIntDef(aValue, 0));
  end
  else if SameText(aFieldName, 'DRIVE_DES_ID') then
  begin
    aValue := GetDesText(StrToIntDef(aValue, 0));
  end
  else if SameText(aFieldName, 'BRAKE_SYST_DES_ID') then
  begin
    aValue := GetDesText(StrToIntDef(aValue, 0));
  end
  else if SameText(aFieldName, 'BRAKE_TYPE_DES_ID') then
  begin
    aValue := GetDesText(StrToIntDef(aValue, 0));
  end
  else if SameText(aFieldName, 'ABS_DES_ID') then
  begin
    aValue := GetDesText(StrToIntDef(aValue, 0));
  end
  else if SameText(aFieldName, 'ASR_DES_ID') then
  begin
    aValue := GetDesText(StrToIntDef(aValue, 0));
  end;
end;

procedure TExportOut.GetValueDetTyp(const aFieldName: string; var aValue: string);
begin
  if SameText(aFieldName, 'CODE_BRAND') then
    aValue := CurrentCodeBrand;
end;

procedure TExportOut.GetValueDet(const aFieldName: string; var aValue: string);
begin
  if SameText(aFieldName, 'CODE_BRAND') then
    aValue := CurrentCodeBrand;
end;

procedure TExportOut.GetValuePict(const aFieldName: string; var aValue: string);
begin
  if SameText(aFieldName, 'PICT_ID') then
  begin
    PictIDs.Add(aValue);
    aValue := SitePathPicts + IntToStr(StrToIntDef(aValue, 0) div 1000) + '/' + aValue + '.jpg';
  end;
end;


procedure TFormMain.ExportTableEx(const aToFile, aFromQuery: string; const aFields: array of string;
  aDefIsNull: string = ''; aRewriteFile: Boolean = True;
  const aProgressCaption: string = ''; const aProgressCalcSQL: string = '';
  OnGetFieldValueProc: TGetFieldValueEvent = nil; aUseServerCursor: Boolean = False);
var
  i, iPos, iMax: Integer;
  aFieldNameFrom: string;
  aFieldFrom: TField;
  aDefs: TStrings;
  aQuery: TAdoQuery;
  t: Cardinal;
  aStream: TMemoryStream;
  fileCSV: TextFile;
  anOutValue, anOutLine: string;
  aWithProgress: Boolean;
begin
  if fAborted then
    Exit;

  aWithProgress := aProgressCalcSQL <> '';
  if aWithProgress or (aProgressCaption <> '') then
  begin
    MemoLog.Lines.Add('');
    MemoLog.Lines.Add(aProgressCaption + '...');
  end;
  t := GetTickCount;


  AssignFile(fileCSV, aToFile);
  if aRewriteFile or (not FileExists(aToFile)) then
    Rewrite(fileCSV)
  else
    Append(fileCSV);

  if aWithProgress or (aProgressCaption <> '') then
    UpdateProgress(0, 'Экспорт: ' + aProgressCaption);

  aStream := TMemoryStream.Create;
  aDefs := TStringList.Create;
  aDefs.Text := aDefIsNull;
  aQuery := TAdoQuery.Create(nil);
  aQuery.DisableControls;
  try
    iPos := 0;
    if aWithProgress then
    begin
      iMax := StrToIntDef( ExecuteSimpleSelectMS(aProgressCalcSQL, []), 0 );
      UpdateProgress(0, 'Экспорт: ' + aProgressCaption + ' [' + IntToStr(iMax) + ']... ');
    end
    else
      iMax := 0;

    aQuery.Connection := connService;
    if aUseServerCursor then
    begin
      aQuery.CursorLocation := clUseServer;
      aQuery.CursorType := ctOpenForwardOnly;
    end;
    aQuery.CommandTimeout := 60 * 10;
    aQuery.SQL.Text := aFromQuery;
    aQuery.Open;

    while not aQuery.Eof do
    begin
      anOutLine := '';

      for i := Low(aFields) to High(aFields) do
      begin
        aFieldNameFrom := aFields[i];
        anOutValue := '';

        aFieldFrom := aQuery.FieldByName(aFieldNameFrom);
        if aFieldFrom.IsNull and (aDefs.IndexOfName(aFieldNameFrom) >= 0) then
          anOutValue := aDefs.Values[aFieldNameFrom]
        else
        {
          if (aFieldFrom is TBlobField) then
          begin
            TBlobField(aFieldFrom).SaveToStream(aStream);
            TBlobField(aFieldTo).LoadFromStream(aStream);
            aStream.Clear;
          end
          else
        }
            anOutValue := aFieldFrom.AsString;
        if Assigned(OnGetFieldValueProc) then
          OnGetFieldValueProc(aFieldNameFrom, anOutValue);
        anOutLine := anOutLine + anOutValue + ';';
      end;
      Writeln(fileCSV, anOutLine);
      aQuery.Next;
      Inc(iPos);

      if (iPos mod 500 = 0) or (aQuery.Eof) then
        if aWithProgress and (iMax > 0) then
          UpdateProgress(iPos * 100 div iMax, 'Экспорт: ' + aProgressCaption + ' [' + IntToStr(iMax) + ']... ' + IntToStr(iPos))
        else
          UpdateProgress(0, 'Экспорт: ' + aProgressCaption + '... ' + IntToStr(iPos));
      if fAborted then
        Break;
    end;
    aQuery.Close;

  finally
    CloseFile(fileCSV);
    aQuery.Free;
    aDefs.Free;
    aStream.Free;

    if aWithProgress then
    begin
      UpdateProgress(0, 'finish');
      MemoLog.Lines.Add('exec time: ' + IntToStr(GetTickCount - t));
    end;
  end;
end;

procedure TFormMain.CSVShatemagby1Click(Sender: TObject);

  function IsJP2Image(aStream: TStream): Boolean;
  var
    aBuf: array[0..7] of Char;
  begin
    aStream.Position := 16;
    aStream.Read(aBuf, 7);
    aBuf[7] := #0;
    Result := StrPas(aBuf) = 'ftypjp2';
  end;

  procedure ZipFile(const aZipName, aDir: string; const aFileNames: array of string);
  var
    anOutDir: string;
    i: Integer;
  begin
    anOutDir := aDir;
    with Zipper do
    begin
      RootDir := IncludeTrailingPathDelimiter(anOutDir);
      ZipName := anOutDir + aZipName;

      if FileExists(ZipName) then
        SysUtils.DeleteFile(ZipName);

      FilesList.Clear;
      for i := Low(aFileNames) to High(aFileNames) do
        FilesList.Add(anOutDir + aFileNames[i]);
      StorePaths := False;
      Zip;
    end;
  end;

var
  i: Integer;
  aPath, anOutPathPicts, aCurPathPicts, aPrevPathPicts: string;
  aQuery: TAdoQuery;
  aRecNo, aRecMax: Integer;

  anExportOut: TExportOut;

  aParams: array of Boolean;
  aHasParams: Boolean;
  aParamsForm: TOutParamsSiteForm;
  aZipEach: Boolean;
  aZipAll: Boolean;
  aZipAllFileName: string;

  aStream: TMemoryStream;
  fOutFile: TextFile;
  aZipFiles: TStrings;
  aZipFilesAr: array of string;
begin
  fAborted := False;
  if fBuildInfo.CatalogCount = 0 then
    raise Exception.Create('Каталог пуст');
  aPath := ExtractFilePath(ParamStr(0));
  if not OpenDirDialog.OpenDirExecute(aPath, 'Укажите папку для сохранения файлов') then
    Exit;
  aPath := IncludeTrailingPathDelimiter(aPath);

  aParamsForm := TOutParamsSiteForm.Create(Self);
  try
    if aParamsForm.ShowModal = mrOK then
    begin
      SetLength(aParams, aParamsForm.cbParams.Count);
      aHasParams := False;
      for i := 0 to aParamsForm.cbParams.Count - 1 do
      begin
        aParams[i] := aParamsForm.cbParams.Checked[i];
        aHasParams := aHasParams or aParams[i];
      end;
      aZipEach := aParamsForm.cbZipEach.Checked;
      aZipAll := aParamsForm.cbZipAll.Checked;
      aZipAllFileName := aParamsForm.edZipName.Text;
    end
    else
      Exit;
  finally
    aParamsForm.Free;
  end;

  if not aHasParams then
    Exit;

anExportOut := TExportOut.Create(Self);
aZipFiles := TStringList.Create;
try

// *** каталог -------------------------------------------------------------------
  //Группа;Подгруппа;Бренд;Номер;Наименование;Описание;кратность
  if aParams[0] then
  begin
    ExportTableEx(
      aPath + 'items.csv',
      ' SELECT g.GROUP_DESCR, g.SUBGROUP_DESCR, b.DESCRIPTION BRAND_DESCR, c.CODE, c.NAME, c.DESCRIPTION, c.MULT ' +
      ' FROM [CATALOG] c ' +
      ' LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      ' LEFT JOIN [GROUPS] g ON (g.GROUP_ID = c.GROUP_ID AND g.SUBGROUP_ID = c.SUBGROUP_ID) ' +
      ' WHERE c.TITLE = 0 OR c.TITLE IS NULL ',
      ['GROUP_DESCR', 'SUBGROUP_DESCR', 'BRAND_DESCR', 'CODE', 'NAME', 'DESCRIPTION', 'MULT'],
      '',
      True,
      'Экспорт каталога',
      ' SELECT Count(*) FROM [CATALOG] WHERE TITLE = 0 OR TITLE IS NULL '
    );

    if not fAborted then
    begin
      if aZipEach then
        ZipFile('items.zip', aPath, ['items.csv']);
      if aZipAll then
        aZipFiles.Add('items.csv');
    end;
  end;

// *** аналоги -------------------------------------------------------------------
  //Номер позиции_бренд позиции;номер аналога_бренд аналога;Отображать
  if aParams[1] then
  begin
    ExportTableEx(
      aPath + 'analogs.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, AN_CODE + ''_'' + AN_BRAND AN_CODE_BRAND, a.LOCKED ' +
      ' FROM [ANALOG] a ' +
      ' LEFT JOIN [CATALOG] c ON (c.CAT_ID = a.CAT_ID) ' +
      ' LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ',
      ['CODE_BRAND', 'AN_CODE_BRAND', 'LOCKED'],
      '',
      True,
      'Экспорт аналогов',
      ' SELECT Count(*) FROM [ANALOG] ',
      anExportOut.GetValueAnalog
    );
    if not fAborted then
    begin
      if aZipEach then
        ZipFile('analogs.zip', aPath, ['analogs.csv']);
      if aZipAll then
        aZipFiles.Add('analogs.csv');
    end;    
  end;

// *** OE ------------------------------------------------------------------------
  //Номер позиции_бренд позиции;номер OE
  if aParams[2] then
  begin
    ExportTableEx(
      aPath + 'OE.csv',
      ' select c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, o.CODE OE_CODE ' +
      ' FROM [OE] o ' +
      ' LEFT JOIN [CATALOG] c ON (c.CAT_ID = o.CAT_ID) ' +
      ' LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ',
      ['CODE_BRAND', 'OE_CODE'],
      '',
      True,
      'Экспорт OE',
      ' SELECT Count(*) FROM [OE] '
    );

    if not fAborted then
    begin
      if aZipEach then
        ZipFile('OE.zip', aPath, ['OE.csv']);
      if aZipAll then
        aZipFiles.Add('OE.csv');
    end;    
  end;

// *** список автомобилей
  //3822;ALFA ROMEO;145 (930);1.4 i.e.;1994/07 - 1996/12;66;90;1351;1,4;4;Наклонная задняя часть;0;Бензиновый двигатель;Впрыскивание во впускной коллектор/Карбюратор;2;с регулируемым катализатором (3-х ступенчатый);AR 33501;Привод на передние колеса;гидравлический;;;;
  if aParams[3] then
  begin
    CacheTD_DES(memDES);
    memDES.Open;
    try
      ExportTableEx(
        aPath + 'cars.csv',
        ' SELECT t.TYP_ID, ' +
        '        ma.MFA_BRAND, ' +
        '        m.TEX_TEXT model, ' +
        '        t1.TEX_TEXT submodel, ' +
        '        CAST(t.PCON_START as varchar(10)) + '' - '' + CAST(t.PCON_END as varchar(10)) years, ' +
        '        t.KW_FROM, ' +
        '        t.HP_FROM, ' +
        '        t.CCM, ' +
        '        t.CCM CCM_ROUND, ' +
        '        t.CYLINDERS, ' +
        '        t.BODY_DES_ID, ' +
        '        t.DOORS, ' +
        '        t.ENGINE_DES_ID, ' +
        '        t.FUEL_SUPPLY_DES_ID, ' +
        '        t.VALVES, ' +
        '        t.CATALYST_DES_ID, ' +
        '        t.ENG_CODES, ' +
        '        t.DRIVE_DES_ID, ' +
        '        t.BRAKE_SYST_DES_ID, ' +
        '        t.BRAKE_TYPE_DES_ID, ' +
        '        t.ABS_DES_ID, ' +
        '        t.ASR_DES_ID ' +
        ' FROM [' + fTecdocDB + '].[DBO].[TD_TYPES] t ' +
        ' LEFT JOIN [' + fTecdocDB + '].[DBO].[TD_MODELS] m ON (t.MOD_ID = m.MOD_ID) ' +
        ' INNER JOIN [' + fTecdocDB + '].[DBO].[TD_MANUFACTURERS] ma ON (ma.MFA_ID = m.MFA_ID and ma.HIDE = 0) ' +
        ' LEFT JOIN [' + fTecdocDB + '].[DBO].[TD_CDS] t1 ON (t1.CDS_ID = t.CDS_ID) ',
        [
         'TYP_ID',
         'MFA_BRAND',
         'model',
         'submodel',
         'years',
         'KW_FROM',
         'HP_FROM',
         'CCM',
         'CCM_ROUND',
         'CYLINDERS',
         'BODY_DES_ID',
         'DOORS',
         'ENGINE_DES_ID',
         'FUEL_SUPPLY_DES_ID',
         'VALVES',
         'CATALYST_DES_ID',
         'ENG_CODES',
         'DRIVE_DES_ID',
         'BRAKE_SYST_DES_ID',
         'BRAKE_TYPE_DES_ID',
         'ABS_DES_ID',
         'ASR_DES_ID'
        ],
        '',
        True,
        'Экспорт авто',
        ' SELECT Count(t.ID) ' +
        ' FROM [' + fTecdocDB + '].[DBO].[TD_TYPES] t ' +
        ' INNER JOIN [' + fTecdocDB + '].[DBO].[TD_MODELS] m ON (t.MOD_ID = m.MOD_ID) ' +
        ' INNER JOIN [' + fTecdocDB + '].[DBO].[TD_MANUFACTURERS] ma ON (ma.MFA_ID = m.MFA_ID and ma.HIDE = 0) ',
        anExportOut.GetValueCars
      );
    finally
      memDES.Close;
    end;

    if not fAborted then
    begin
      if aZipEach then
        ZipFile('cars.zip', aPath, ['cars.csv']);
      if aZipAll then
        aZipFiles.Add('cars.csv');
    end;
  end;

// *** применяемость к машине
  //Номер_Бренд;IDCAR
  if aParams[4] then
  begin
    ExportTableEx(
      aPath + 'apply.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, at.TYP_ID ' +
      ' FROM [CATALOG] c ' +
      '   LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      '   LEFT JOIN [' + fTecdocDB + '].[DBO].[ART_TYP] at on (at.ART_ID = c.TYP_TDID) ' +
      ' WHERE c.TYP_TDID > 0 AND at.TYP_ID IS NOT NULL ',
      ['CODE_BRAND', 'TYP_ID'],
      '',
      True,
      'Экспорт применяемости',
      ' SELECT Count(c.ID) ' +
      ' FROM [CATALOG] c ' +
      '   LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      '   LEFT JOIN [' + fTecdocDB + '].[DBO].[ART_TYP] at on (at.ART_ID = c.TYP_TDID) ' +
      ' WHERE c.TYP_TDID > 0 AND at.TYP_ID IS NOT NULL ',
      nil, 
      True {UseServerCursor}
    );

    if not fAborted then
    begin
      if aZipEach then
        ZipFile('apply.zip', aPath, ['apply.csv']);
      if aZipAll then
        aZipFiles.Add('apply.csv');
    end;
  end;

// *** ограничения по машине
  //IDCAR;Номер_Бренд;Название параметра=значение
  if aParams[5] then
  begin
    DeleteFile(aPath + 'limits.csv');

    aRecMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT COUNT(*) FROM [CATALOG] WHERE TYP_TDID > 0', []), 0);

    aQuery := TAdoQuery.Create(nil);
    try
      aQuery.Connection := connService;
      aQuery.CursorLocation := clUseServer;
      aQuery.CursorType := ctOpenForwardOnly;
      aQuery.CommandTimeout := 60 * 5;
      aQuery.SQL.Text :=
        ' SELECT c.TYP_TDID, c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND ' +
        ' FROM [CATALOG] c ' +
        '   LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
        ' WHERE c.TYP_TDID > 0 ';
      aQuery.Open;
      aRecNo := 1;
      while not aQuery.Eof do
      begin
        anExportOut.CurrentCodeBrand := aQuery.Fields[1].AsString;

        //экспортим пачками по одному артикулу
        ExportTableEx(
          aPath + 'limits.csv',
          ' SELECT dt.TYP_ID, 1 CODE_BRAND, p.DESCRIPTION + ''='' + dt.PARAM_VALUE PARAM ' +
          ' FROM [' + fTecdocDB + '].[DBO].[TD_DETAILS_TYP] dt ' +
          '   LEFT JOIN [' + fTecdocDB + '].[DBO].[TD_PARAMS] p on (p.PARAM_ID = dt.PARAM_ID) ' +
          ' WHERE dt.ART_ID = ' + aQuery.Fields[0].AsString,
           ['TYP_ID', 'CODE_BRAND', 'PARAM'],
          '',
          False,
          '',
          '',
          anExportOut.GetValueDetTyp
        );

        Inc(aRecNo);
        aQuery.Next;
        if aRecNo mod 100 = 0 then
          UpdateProgress(aRecNo * 100 div aRecMax, 'Экспорт ограничений [' + IntToStr(aRecNo) + ' из ' + IntToStr(aRecMax) + ']');
        if fAborted then
          Exit;
      end;
      aQuery.Close;
    finally
      aQuery.Free;
      UpdateProgress(0, 'finish');
    end;

    if not fAborted then
    begin
      if aZipEach then
        ZipFile('limits.zip', aPath, ['limits.csv']);
      if aZipAll then
        aZipFiles.Add('limits.csv');
    end;
  end;

// *** описания
  //Номер_Бренд;Название параметра=значение
  if aParams[6] then
  begin
    DeleteFile(aPath + 'descriptions.csv');

    aRecMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT COUNT(*) FROM [CATALOG] WHERE PARAM_TDID > 0', []), 0);

    aQuery := TAdoQuery.Create(nil);
    try
      aQuery.Connection := connService;
      aQuery.CursorLocation := clUseServer;
      aQuery.CursorType := ctOpenForwardOnly;
      aQuery.CommandTimeout := 60 * 5;
      aQuery.SQL.Text :=
        ' SELECT c.PARAM_TDID, c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND ' +
        ' FROM [CATALOG] c ' +
        '   LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
        ' WHERE c.PARAM_TDID > 0 ';
      aQuery.Open;
      aRecNo := 1;
      while not aQuery.Eof do
      begin
        anExportOut.CurrentCodeBrand := aQuery.Fields[1].AsString;

        //экспортим пачками по одному артикулу
        ExportTableEx(
          aPath + 'descriptions.csv',
          ' SELECT 1 CODE_BRAND, p.DESCRIPTION + ''='' + d.PARAM_VALUE PARAM ' +
          ' FROM [' + fTecdocDB + '].[DBO].[TD_DETAILS] d ' +
          '   LEFT JOIN [' + fTecdocDB + '].[DBO].[TD_PARAMS] p on (p.PARAM_ID = d.PARAM_ID) ' +
          ' WHERE d.ART_ID  = ' + aQuery.Fields[0].AsString,
           ['CODE_BRAND', 'PARAM'],
          '',
          False,
          '',
          '',
          anExportOut.GetValueDet
        );

        Inc(aRecNo);
        aQuery.Next;
        if aRecNo mod 100 = 0 then
          UpdateProgress(aRecNo * 100 div aRecMax, 'Экспорт описаний [' + IntToStr(aRecNo) + ' из ' + IntToStr(aRecMax) + ']');
        if fAborted then
          Exit;
      end;
      aQuery.Close;
    finally
      aQuery.Free;
      UpdateProgress(0, 'finish');
    end;

    if not fAborted then
    begin
      if aZipEach then
        ZipFile('descriptions.zip', aPath, ['descriptions.csv']);
      if aZipAll then
        aZipFiles.Add('descriptions.csv');
    end;
  end;

// *** картинки (список)
  //Номер_Бренд;Путь к картинке
  if aParams[7] then
  begin
    anExportOut.SitePathPicts := 'http://www.shate-mag.by/data/service/picts/';

    ExportTableEx(
      aPath + 'picts.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, c.PICT_ID ' +
      ' FROM [CATALOG] c ' +
      '   LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      ' WHERE c.PICT_ID > 0 ' +
      ' ORDER BY c.PICT_ID ',
      ['CODE_BRAND', 'PICT_ID'],
      '',
      True,
      'Экспорт списка картинок',
      ' SELECT Count(*) FROM [CATALOG] WHERE PICT_ID > 0 ',
      anExportOut.GetValuePict
    );
    if fAborted then
      Exit;

    if not fAborted then
    begin
      if aZipEach then
        ZipFile('picts.zip', aPath, ['picts.csv']);
      if aZipAll then
        aZipFiles.Add('picts.csv');
    end;

  // *** картинки (файлы)
    aRecMax := StrToIntDef(
      ExecuteSimpleSelectMS(
        ' SELECT Count(p.PICT_ID) FROM [' + fTecdocDB + '].[DBO].[TD_PICTS] p ' +
        ' WHERE EXISTS ( ' +
        '   SELECT cat.PICT_ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE (cat.PICT_ID = p.PICT_ID) ' +
        ' ) ',
        []
      ), 0);

    UpdateProgress(0, 'Экспорт картинок [' + IntToStr(aRecMax) + ']... ');

    anOutPathPicts := aPath + 'picts\';
    if not DirectoryExists(anOutPathPicts) then
      ForceDirectories(anOutPathPicts);

    aQuery := TAdoQuery.Create(nil);
    try
      aQuery.Connection := connService;
      aQuery.CursorLocation := clUseServer;
      aQuery.CursorType := ctOpenForwardOnly;
      aQuery.CommandTimeout := 60 * 5;
      aQuery.SQL.Text :=
        ' SELECT p.PICT_ID, p.PICT_DATA FROM [' + fTecdocDB + '].[DBO].[TD_PICTS] p ' +
        ' WHERE EXISTS ( ' +
        '   SELECT cat.PICT_ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE (cat.PICT_ID = p.PICT_ID) ' +
        ' ) ';
      aQuery.Open;
      aRecNo := 0;
      aPrevPathPicts := '';
      while not aQuery.Eof do
      begin
        aCurPathPicts := anOutPathPicts + IntToStr(aQuery.Fields[0].AsInteger div 1000) + '\';
        if aPrevPathPicts <> aCurPathPicts then
        begin
          aPrevPathPicts := aCurPathPicts;
          if not DirectoryExists(aCurPathPicts) then
            ForceDirectories(aCurPathPicts);
        end;

        TBlobField(aQuery.Fields[1]).SaveToFile(aCurPathPicts + aQuery.Fields[0].AsString + '.jpg');

        aQuery.Next;
        Inc(aRecNo);

        if (aRecNo mod 100 = 0) or (aQuery.Eof) then
          UpdateProgress(aRecNo * 100 div aRecMax, 'Экспорт картинок [' + IntToStr(aRecMax) + ']... ' + IntToStr(aRecNo));

        if fAborted then
          Exit;
      end;
      aQuery.Close;
    finally
      aQuery.Free;
      UpdateProgress(0, 'finish');
    end;
  end;
                
// *** картинки (список формата JP2)
  //Номер_Бренд;Путь к картинке
  if aParams[8] then
  begin
    DeleteFile(aPath + 'picts_jp2.csv');
    AssignFile(fOutFile, aPath + 'picts_jp2.csv');

    anExportOut.SitePathPicts := 'http://www.shate.by/data/service/picts/';

  // *** картинки (файлы)
    aRecMax := StrToIntDef(
      ExecuteSimpleSelectMS(
        ' SELECT Count(p.PICT_ID) FROM [' + fTecdocDB + '].[DBO].[TD_PICTS] p ' +
        ' WHERE EXISTS ( ' +
        '   SELECT cat.PICT_ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE (cat.PICT_ID = p.PICT_ID) ' +
        ' ) ',
        []
      ), 0);

    UpdateProgress(0, 'Экспорт списка картинок JP2 [' + IntToStr(aRecMax) + ']... ');
    aQuery := TAdoQuery.Create(nil);
    aStream := TMemoryStream.Create;
    Rewrite(fOutFile);
    try
      aQuery.Connection := connService;
      aQuery.CursorLocation := clUseServer;
      aQuery.CursorType := ctOpenForwardOnly;
      aQuery.CommandTimeout := 60 * 5;
      aQuery.SQL.Text :=
        ' SELECT p.PICT_ID, p.PICT_DATA FROM [' + fTecdocDB + '].[DBO].[TD_PICTS] p ' +
        ' WHERE EXISTS ( ' +
        '   SELECT cat.PICT_ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE (cat.PICT_ID = p.PICT_ID) ' +
        ' ) ';
      aQuery.Open;
      aRecNo := 0;
      while not aQuery.Eof do
      begin
        aStream.Clear;
        TBlobField(aQuery.Fields[1]).SaveToStream(aStream);
        if IsJP2Image(aStream) then
          Writeln(fOutFile, anExportOut.SitePathPicts + IntToStr(aQuery.Fields[0].AsInteger div 1000) + '/' + aQuery.Fields[0].AsString + '.jpg');

        aQuery.Next;
        Inc(aRecNo);

        if (aRecNo mod 100 = 0) or (aQuery.Eof) then
          UpdateProgress(aRecNo * 100 div aRecMax, 'Экспорт списка картинок JP2 [' + IntToStr(aRecMax) + ']... ' + IntToStr(aRecNo));

        if fAborted then
          Exit;
      end;
      aQuery.Close;
    finally
      CloseFile(fOutFile);
      aStream.Free;
      aQuery.Free;
      UpdateProgress(0, 'finish');
    end;

    if not fAborted then
    begin
      if aZipEach then
        ZipFile('picts_jp2.zip', aPath, ['picts_jp2.csv']);
      if aZipAll then
        aZipFiles.Add('picts_jp2.csv');
    end;
  end;

  //* упаковка ********************//
  if aZipAll then
  begin
    aZipFilesAr := nil;
    for i := 0 to aZipFiles.Count - 1 do
    begin
      SetLength(aZipFilesAr, Length(aZipFilesAr) + 1);
      aZipFilesAr[High(aZipFilesAr)] := aZipFiles[i];
    end;
    ZipFile(aZipAllFileName, aPath, aZipFilesAr);
    aZipFilesAr := nil;
  end;

finally
  aZipFiles.Free;
  anExportOut.Free;
end;

end;

procedure TFormMain.CuttingAnalogFile(aPath, FileName, iNumOperation: string; iFieldIndexNum: integer);
const
  MAX_CNT_FROM_ANALOG = 350000;
var
  aReader: TCSVReader;
  sLine : string;
  iGEN_AN_ID, iPrev_Gen_an_id: integer;
  Strings4Save: TStrings;
  LastSaveFileName: string;
begin
//>>  'AN_CODE', 'AN_BRAND', 'AN_ID','LOCKED','GEN_AN_ID'
  aReader := TCSVReader.Create;
  Strings4Save := TStringList.Create;
  try
    aReader.Open(aPath + FileName);
    iPrev_Gen_an_id := 0;
    while not aReader.Eof do
    begin
      sLine := aReader.ReturnLine;
      iGEN_AN_ID := StrToIntDef(aReader.Fields[iFieldIndexNum], 0);

      if iGEN_AN_ID < MAX_CNT_FROM_ANALOG then
      begin
        Strings4Save.Add(sLine);
        LastSaveFileName := 'ana_' + iNumOperation + '_descr1.csv';
      end

      else if iGEN_AN_ID < MAX_CNT_FROM_ANALOG * 2 then
      begin
        if (iPrev_Gen_an_id < MAX_CNT_FROM_ANALOG) and (iPrev_Gen_an_id > 0) then
        begin
          Strings4Save.SaveToFile(aPath + LastSaveFileName);
          Strings4Save.Clear;
        end;
        Strings4Save.Add(sLine);
        LastSaveFileName := 'ana_' + iNumOperation + '_descr2.csv';
      end

      else if iGEN_AN_ID < MAX_CNT_FROM_ANALOG * 3 then
      begin
        if (iPrev_Gen_an_id < MAX_CNT_FROM_ANALOG * 2) and (iPrev_Gen_an_id > 0) then
        begin
          Strings4Save.SaveToFile(aPath + LastSaveFileName);
          Strings4Save.Clear;
        end;
        Strings4Save.Add(sLine);
        LastSaveFileName := 'ana_' + iNumOperation + '_descr3.csv';
      end

      else if iGEN_AN_ID < MAX_CNT_FROM_ANALOG * 4 then
      begin
        if (iPrev_Gen_an_id < MAX_CNT_FROM_ANALOG * 3) and (iPrev_Gen_an_id > 0) then
        begin
          Strings4Save.SaveToFile(aPath + LastSaveFileName);
          Strings4Save.Clear;
        end;
        Strings4Save.Add(sLine);
        LastSaveFileName := 'ana_' + iNumOperation + '_descr4.csv';
      end

      else if iGEN_AN_ID > MAX_CNT_FROM_ANALOG * 4 then
      begin
        if (iPrev_Gen_an_id < MAX_CNT_FROM_ANALOG * 4) and (iPrev_Gen_an_id > 0)  then
        begin
          Strings4Save.SaveToFile(aPath + LastSaveFileName);
          Strings4Save.Clear;
        end;
        Strings4Save.Add(sLine);
        LastSaveFileName := 'ana_' + iNumOperation + '_descr5.csv';
      end;
      iPrev_Gen_an_id := iGEN_AN_ID;
    end;
    
    if Strings4Save.Count > 0 then
      Strings4Save.SaveToFile(aPath + LastSaveFileName);

  finally
    aReader.Free;
    Strings4Save.Free;
  end;

end;

procedure TFormMain.miLoadPricesOnlyClick(Sender: TObject);
var
  aReader: TCSVReader;
  anUpdated, anAll: Integer;
  aCode, aBrand: string;
  aBrandID, aCatID: Integer;
begin
  if not OD.Execute then
    Exit;

  UpdateProgress(0, 'Импорт цен...');

  aReader := TCSVReader.Create;
  try
    aReader.Open(OD.FileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      Inc(anAll);
      UpdateProgress(aReader.FilePosPercent, 'Импорт цен...');

      if not DecodeCodeBrand(aReader.Fields[0], aCode, aBrand) then
        Continue;

      aBrandID := StrToIntDef(
        ExecuteSimpleSelectMS('SELECT BRAND_ID FROM BRANDS WHERE DESCRIPTION = :DESCRIPTION', [aBrand]),
        0
      );
      if aBrandID = 0 then
        Continue;

      aCatID := StrToIntDef(
        ExecuteSimpleSelectMS('SELECT CAT_ID FROM CATALOG WHERE BRAND_ID = :BRAND_ID AND CODE2 = :CODE2', [aBrandID, aCode]),
        0
      );
      if aCatID = 0 then
        Continue;

      Inc(
        anUpdated,
        ExecuteQuery('UPDATE CATALOG SET PRICE = :PRICE WHERE CAT_ID = :CAT_ID', [StrToFloatDefUnic(aReader.Fields[1], 0), aCatID])
      );
    end;

  finally
    aReader.Free;
    UpdateProgress(0, 'Импорт цен...OK');
  end;

  ShowMessage( Format('Обновлено %d из %d', [anUpdated, anAll]) );
end;

procedure TFormMain.MakeFullPrimen;
var
  aQuery: TAdoQuery;
  //f: TextFile;
  f: file of Integer;
  aType, aArt: Integer;
  i, iMax: Integer;
  aFirst: Boolean;
  anOutDir: string;
begin
  anOutDir := GetAppDir + 'Update\';
  if not DirectoryExists(anOutDir) then
    ForceDirectories(anOutDir);

  UpdateProgress(0, 'Выгрузка привязок к машинам...');

  aQuery := TAdoQuery.Create(nil);
  aQuery.DisableControls;
  try
    aQuery.Connection := connService;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctStatic;
    aQuery.CommandTimeout := 60 * 5;

    aQuery.SQL.Text :=
    ' SELECT Count(at.ART_ID) ' +
    ' FROM [SERVICE].[dbo].[AT] at ';
    aQuery.Open;
    iMax := aQuery.Fields[0].AsInteger;
    aQuery.Close;

    aQuery.SQL.Text :=
    ' SELECT at.TYP_ID, at.ART_ID ' +
    ' FROM [SERVICE].[dbo].[AT] at ' +
    ' ORDER BY at.TYP_ID, at.ART_ID ';
    aQuery.Open;

    AssignFile(f, anOutDir + 'typ_full.csv');
    Rewrite(f);
    i := 0;
    aType := aQuery.Fields[0].AsInteger;
    aFirst := True;
    while not aQuery.Eof do
    begin
      aArt := aQuery.Fields[1].AsInteger;
      if aFirst then
      begin
        Write(f, aType);
        aFirst := False;
      end;
      Write(f, aArt);

      aQuery.Next;

      if (aType <> aQuery.Fields[0].AsInteger) or aQuery.Eof then
      begin
        aArt := -1;
        Write(f, aArt);
        aFirst := True;

        aType := aQuery.Fields[0].AsInteger;
      end;

      Inc(i);
      if i mod 1000 = 0 then
        UpdateProgress( i * 100 div iMax, Format('Выгрузка привязок к машинам... [%d из %d]', [i, iMax]) );
    end;
    CloseFile(f);
  finally
    aQuery.Free;
  end;

  UpdateProgress(0, ' ');
end;


procedure TFormMain.Button3Click(Sender: TObject);
var
  aQuery: TAdoQuery;
  f: TextFile;
  i: Integer;
  aReader: TCSVReader;
  cat_br_str, cat_code, an_br_str, an_code: string;
begin
  if not OD.Execute then
    Exit;

  fAborted := False;
  UpdateProgress(0, 'Чистка удаленных аналогов...');

  aReader := TCSVReader.Create;
  aQuery := TAdoQuery.Create(nil);
  aQuery.DisableControls;
  AssignFile(f, OD.FileName + '_new');
  Rewrite(f);
  try
    aQuery.Connection := connService;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctStatic;
    aQuery.CommandTimeout := 60 * 5;

    aReader.Open(OD.FileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      Inc(i);
      if i mod 100 = 0 then
      begin
        UpdateProgress( aReader.FilePosPercent, Format('Чистка удаленных аналогов... [%d]', [i]) );
        if fAborted then
          Exit;
      end;

      cat_br_str := AnsiUpperCase(aReader.Fields[0]);
      cat_code   := MakeSearchCode(aReader.Fields[1]);
      an_br_str  := AnsiUpperCase(aReader.Fields[2]);
      an_code    := MakeSearchCode(aReader.Fields[3]);

      aQuery.Close;
      aQuery.SQL.Text :=
        ' SELECT c.LOCKED FROM [CATALOG] c ' +
        ' INNER JOIN BRANDS b ON (b.BRAND_ID = c.BRAND_ID) ' +
        ' WHERE c.CODE2 = :CODE2 and b.DESCRIPTION = :BRAND ';

      //если товар залочен или не найден - переписываем
      aQuery.Parameters[0].Value := cat_code;
      aQuery.Parameters[1].Value := cat_br_str;
      aQuery.Open;
      if aQuery.Eof or (aQuery.Fields[0].AsInteger = 1) then
      begin
        aQuery.Close;
        Writeln(f, aReader.CurrentLine);
        Continue;
      end;

      //если аналог залочен или не найден - переписываем
      aQuery.Close;
      aQuery.SQL.Text :=
        ' SELECT c.LOCKED FROM [CATALOG] c ' +
        ' INNER JOIN BRANDS b ON (b.BRAND_ID = c.BRAND_ID) ' +
        ' WHERE c.CODE2 = :CODE2 and b.DESCRIPTION = :BRAND ';
      aQuery.Parameters[0].Value := an_code;
      aQuery.Parameters[1].Value := an_br_str;
      aQuery.Open;
      if aQuery.Eof or (aQuery.Fields[0].AsInteger = 1) then
      begin
        Writeln(f, aReader.CurrentLine);
        aQuery.Close;
        Continue;
      end;
      aQuery.Close;
    end;
  finally
    CloseFile(f);
    aReader.Free;
    aQuery.Free;
  end;

  UpdateProgress(0, ' ');
end;



procedure TFormMain.Button4Click(Sender: TObject);
var
  aReader: TCSVReader;
  aCode1, aBrand1, aCode2, aBrand2: string;
  f: TextFile;
begin
  if not OD.Execute then
    Exit;

  AssignFile(f, OD.FileName + '_new');
  Rewrite(f);
  aReader := TCSVReader.Create;
  try
    aReader.Open(OD.FileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      if not DecodeCodeBrand(aReader.Fields[0], aCode1, aBrand1, False) then
        Continue;
      if not DecodeCodeBrand(aReader.Fields[1], aCode2, aBrand2, False) then
        Continue;
      Writeln(f, aBrand1 + ';' + aCode1 + ';' + aBrand2 + ';' + aCode2);
    end;

  finally
    aReader.Free;
    CloseFile(f);
  end;

end;


procedure TFormMain.Button5Click(Sender: TObject);
begin
  LoadPrice(edFilePircePodolsk.Text,'Price_PODOLSK','Импорт цен для Подольска: ');
end;

procedure TFormMain.Button6Click(Sender: TObject);
var
  sLocked, sAn_id, sID, sAction, sCat_id, sAn_code, sAn_brand, sLine: string;
  i,k: integer;
  aReader: TCSVReader;
  UpdateTable: TDBISAMTable;
  s: TStrings;

  anOutDir, anOutDirPicts: string;
  aQuery: TAdoQuery;
  slVersions, sPict_id : TStrings;
  filename, pict_id, brand: string;



function  CreateShortCode(Code: string; const aLiveSymbols: string = ''):string;
var sCode:string;
    sRes:string;
    i:integer;
    s: TStrings;
begin
try
   sRes := '';
   sCode := AnsiUpperCase(Code);
   if Length(sCode) > 0 then
   for I := 0 to Length(sCode) do
   begin
      if ((sCode[i]<='Z')and(sCode[i]>='A'))
         or((sCode[i]<='Я')and(sCode[i]>='А'))
         or((sCode[i]<='9')and(sCode[i]>='0'))
         or(POS(sCode[i], aLiveSymbols) > 0) //не игнорировать эти символы
      then
      begin
        sRes := sRes + sCode[i];
      end;
   end;

   CreateShortCode := sRes;
    except
     On E:Exception do
      MessageDlg('CreateShortCode - '+Code+'-'+ E.Message, mtError, [mbOK],0);
  end;
end;

begin
{  aQuery := TAdoQuery.Create(nil);
  aQuery.DisableControls;
  aQuery.Connection := connService;
  aQuery.CommandTimeout := 60 * 5;
  aQuery.SQL.Text :=
    ' SELECT p.PICT_ID, p.PICT_DATA FROM [tecdoc2012].[DBO].[TD_PICTS] p ' +
    ' WHERE p.PICT_ID = :PICT_ID ';
  aQuery.Prepared := True;


      aQuery.Parameters[0].Value := Edit1.text;
      aQuery.Open;
      if not aQuery.Eof then
        TBlobField(aQuery.Fields[1]).SaveToFile('E:\picts1111.jpg');
      aQuery.Close;






  exit;
  if OD.Execute then
    filename := OD.FileName;
  aQuery := TAdoQuery.Create(nil);
  aQuery.DisableControls;
  aQuery.Connection := connService;
//  aQuery.CursorLocation := clUseServer;
//  aQuery.CursorType := ctOpenForwardOnly;
  aQuery.CommandTimeout := 60 * 5;
  aQuery.SQL.Text :=
    ' UPDATE [' + fTecdocDB + '].[DBO].[ART] SET CUR_PICT = :CUR_PICT WHERE ID = :ID  and PICT_ID = :PICT_ID';
  aQuery.Prepared := True;
  aReader := TCSVReader.Create;
  try
    aReader.Open(filename);
    aReader.ReturnLine;
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      aQuery.Parameters[0].Value := aReader.Fields[0];
      aQuery.Parameters[1].Value := aReader.Fields[1];
      aQuery.Parameters[2].Value := aReader.Fields[2];
      aQuery.ExecSQL;
    end;
  finally
    aReader.Free;
  end;

  EXIT;

  if OD.Execute then
    filename := OD.FileName;

  s := TStringList.Create;
  s.LoadFromFile(filename);

  aReader := TCSVReader.Create;
  try
    aReader.Open('e:\11111111111111111111.csv');
    aReader.ReturnLine;
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      s.text := StringReplace(s.text, 'Пакет изображений [140624.' +  aReader.Fields[1] + ']',
                              'Пакет изображений по бренду ' + aReader.Fields[0], [rfReplaceAll]);
    end;
    s.SaveToFile('e:\NewUpd');
  finally

  end;



  exit;
  }
  if OD.Execute then
    filename := OD.FileName
  else
    exit;
  i := 1;
  sPict_id := TStringList.Create;
  anOutDirPicts := ExtractFilePath(Application.ExeName) + 'FullPicts_new\Picts\';
  UpdateProgress(0, 'Экспорт картинок... ');

  aQuery := TAdoQuery.Create(nil);
  aQuery.DisableControls;
  aQuery.Connection := connService;
//  aQuery.CursorLocation := clUseServer;
//  aQuery.CursorType := ctOpenForwardOnly;
  aQuery.CommandTimeout := 60 * 5;
  aQuery.SQL.Text :=
    ' SELECT p.PICT_ID, p.PICT_DATA FROM [' + fTecdocDB + '].[DBO].[TD_PICTS] p ' +
    ' WHERE p.PICT_ID = :PICT_ID ';
  aQuery.Prepared := True;
  brand := 'PATRON';
  aReader := TCSVReader.Create;
  try
    aReader.Open(filename);
    aReader.ReturnLine;
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      pict_id := aReader.Fields[0];

      if aReader.LineNum mod 50 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Экспорт картинок... ' + IntToStr(aReader.LineNum));

     {if brand <> aReader.Fields[1] then
      begin

          if not DirectoryExists(anOutDirPicts + IntToStr(i)) then
            ForceDirectories(anOutDirPicts + IntToStr(i));
          UpdateProgress(0, 'Упаковка...');
          slVersions := TStringList.Create;
          slVersions.Add('140624.' + IntToStr(i));
          slVersions.Add(IntToStr(114 + i));
          slVersions.SaveToFile(anOutDirPicts + IntToStr(i) + '\'+ '0');
          slVersions.Free;
          sPict_id.SaveToFile(anOutDirPicts + IntToStr(i) + '\'+ 'picts.csv');

          with Zipper do
          begin
            RootDir := IncludeTrailingPathDelimiter(anOutDirPicts + IntToStr(i) + '\');
            ZipName := anOutDirPicts + 'picts_d140624.' + IntToStr(i) +'.zip';
            Password := 'shatem+-140624.' + IntToStr(i);

            if FileExists(ZipName) then
              SysUtils.DeleteFile(ZipName);

            FilesList.Clear;
            FilesList.Add(anOutDirPicts + IntToStr(i) + '\picts\' + '*.*');
            FilesList.Add(anOutDirPicts + IntToStr(i) + '\' + 'picts.csv');
            FilesList.Add(anOutDirPicts + IntToStr(i) + '\' + '0');
            StorePaths := True;
            RelativePaths := True;
            Zip;
          end;
        brand := aReader.Fields[1];
        inc(i);
        sPict_id.Clear;

      end; }

      if fAborted then
        Break;

      aQuery.Parameters[0].Value := aReader.Fields[0];
      aQuery.Open;
      if not aQuery.Eof then
      begin
    //    if not DirectoryExists(anOutDirPicts + IntToStr(i) + '\picts\') then
   //       ForceDirectories(anOutDirPicts + IntToStr(i) + '\picts\');
        TBlobField(aQuery.Fields[1]).SaveToFile( 'd:\MainProjects\ServiceFill\FullPicts_new\Spec\' + aReader.Fields[2] + '_' + aReader.Fields[1] + '.jpg'); //поменять на aQuery.Fields[0]
        sPict_id.Add(aReader.Fields[2]); //поменять на aReader.Fields[0]
      end;
      aQuery.Close;

    end;
  finally
     sPict_id.Free;
  end;

  exit;
  aReader := TCSVReader.Create;
  s := TStringList.Create;
  i:=0;
       aReader.Open('E:\qnt.csv');
       aReader.ReturnLine;
        while not aReader.Eof do
        begin
          sLine := aReader.ReturnLine;
          s.add(StringReplace(sLine,'NULL','',[rfReplaceAll]));
          inc(i);
          if i mod 100 = 0 then
            UpdateProgress(-1,'Обработано: ' + IntToStr(i));
        end;
        s.SaveToFile('E:\NEWQNT.csv');

ShowMEssage('end!');
end;

procedure TFormMain.Button7Click(Sender: TObject);
var
s:tstrings;
aQuery, bQuery : tadoquery;
b,e: cardinal;
aFileName, filename, sLockedBrands, sMaxGenAnId, line, ShortOE, code, brand: string;
aReader: TCSVReader;
str: TStringList;
fReplBrands: tstrings;
i: integer;

begin
  i:=0;
  
 if OD.Execute then
    filename := OD.FileName;
  aQuery := TAdoQuery.Create(nil);
  aQuery.DisableControls;
  aQuery.Connection := connService;

  bQuery := TAdoQuery.Create(nil);
  bQuery.DisableControls;
  bQuery.Connection := connService;

//  aQuery.CursorLocation := clUseServer;
//  aQuery.CursorType := ctOpenForwardOnly;
  aQuery.CommandTimeout := 60 * 5;
  aQuery.SQL.Text :=
    ' UPDATE [tecdoc2014].[DBO].ART SET ART_ID = :ART_ID, PARAM_ID = :PARAM_ID, TYP_ID = :TYP_ID, PICT_ID = :PICT_ID, CUR_PICT = coalesce(:CUR_PICT, 0) ' +
    ' WHERE SUP_BRAND = :br and ART_LOOK = :art ';
  aQuery.Prepared := True;

  bQuery.SQL.Text :=
    ' SELECT top 1 t1.art_id, art_look, sup_brand, t2.PICT_ID FROM [tecdoc2014].[DBO].[TD_ART] t1 ' +
    ' left join [tecdoc2014].[DBO].[ART_PICTS] t2 on (t1.ART_ID = t2.ART_ID) ' +
    ' where SUP_BRAND = :SUP_BRAND and ART_LOOK = :ART_LOOK '+
    ' order by SORT desc ';
  bQuery.Prepared := True;

  aReader := TCSVReader.Create;
  try
    aReader.Open(filename);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      DecodeCodeBrand(aReader.Fields[1], code, brand);
      bQuery.Parameters[0].Value := brand;
      bQuery.Parameters[1].Value := code;
      bQuery.Open;

      if not bQuery.eof then
      begin
        aQuery.Parameters[0].Value := bQuery.FieldByName('ART_ID').AsString;
        aQuery.Parameters[1].Value := bQuery.FieldByName('ART_ID').AsString;
        aQuery.Parameters[2].Value := bQuery.FieldByName('ART_ID').AsString;
        aQuery.Parameters[3].Value := bQuery.FieldByName('ART_ID').AsString;
        if bQuery.FieldByName('PICT_ID').Value = NULL then
          aQuery.Parameters[4].Value := 0
        else
          aQuery.Parameters[4].Value := bQuery.FieldByName('PICT_ID').AsString;
        aQuery.Parameters[5].Value := brand;
        aQuery.Parameters[6].Value := code;
        aQuery.ExecSQL;
      end;
      if i mod 10 = 0 then
        UpdateProgress(i,'Update..' + IntToStr(i) );

      inc(i);
      bQuery.Close;
    end;
  finally
    aReader.Free;
  end;


  exit;


  aReader := TCSVReader.Create;
  aReader.Open('E:\OE_DESCR.csv');
  str := TStringList.Create;
  aReader.ReturnLine;
  while not aReader.Eof do
  begin
    line := aReader.ReturnLine;
    ShortOE := aReader.Fields[1];
    str.Add(line + ';' + IntToStr(Ord(ShortOE[1])));
  end;
  str.SaveToFile('E:\OEE.CSV');
  exit;


//fBuildInfo.Version
//fBuildInfo.ParentVersion
    aFileName := edFileAnalog.Text;
    WriteBuildLog('Загрузка аналогов из ' + aFileName);
    UpdateProgress(0, 'Загрузка аналогов...');
    if not LoadLockedBrands then
      raise Exception.Create('Файл LockedBrand.txt не найден!');
    aQuery := TAdoQuery.Create(nil);
    try
      aQuery.Connection := connService;
      aQuery.CommandTimeout := 600;
      WriteBuildLog(' Поиск MAX(GEN_AN_ID) ');
      aQuery.SQL.Clear;
      aQuery.SQL.Text := ' SELECT max(gen_an_id) FROM [FULL_ANALOG_' + fBuildInfo.ParentVersion + ']';
      aQuery.Open;
      if not aQuery.Eof then
        sMaxGenAnId := aQuery.Fields[0].AsString;

      WriteBuildLog(' Очистка ANALOG_BUF ');
      aQuery.SQL.Text := ' DELETE FROM [ANALOG_BUF] ';
      aQuery.ExecSQL;


      aQuery.SQL.Clear;
      WriteBuildLog(' Массовый импорт в ANALOG_BUF ');
      aQuery.SQL.Text := ' BULK INSERT [ANALOG_BUF] ' +
                         ' FROM ''' + aFileName + '''' +
                         ' WITH (FORMATFILE = ''' + ExtractFilePath(Application.ExeName) + cFormatBulkInsertFileName  + ''')';
      aQuery.ExecSQL;

      WriteBuildLog(' Добавление ShorCode ');
      aQuery.SQL.Text := ' UPDATE [ANALOG_BUF] SET short_cat_code = replace(replace(cat_code,:prob,:free), :par1, :free) , short_an_code = replace(replace(an_code,:prob,:free), :par1, :free) ';
      aQuery.SQL.Text := StringReplace(aQuery.SQL.Text,':prob', ''' ''', [rfReplaceAll]);
      aQuery.SQL.Text := StringReplace(aQuery.SQL.Text,':free', '''''', [rfReplaceAll]);
      aQuery.SQL.Text := StringReplace(aQuery.SQL.Text,':par1', '''_''', [rfReplaceAll]);
      aQuery.ExecSQL;

      aQuery.sql.Clear;
      WriteBuildLog(' Блокировка запрещенных брендов аналогов ');
      aQuery.SQL.Text := ' UPDATE [ANALOG_BUF] SET cat_br_descr = '''', locked = 1 WHERE cat_br_descr in ' + sLockedBrands;
      aQuery.ExecSQL;
      aQuery.sql.Clear;
      aQuery.SQL.Text := ' UPDATE [ANALOG_BUF] SET an_br_descr = '''',  locked = 1 WHERE an_br_descr in ' + sLockedBrands;
      aQuery.ExecSQL;

      aQuery.sql.Clear;
      WriteBuildLog(' Импорт в [FULL_ANALOG_' + fBuildInfo.Version + ']');
      aQuery.SQL.Text :=
             ' SELECT t.cat_id, t.an_code , t.an_brand, t.an_id, t.locked, a.gen_an_id ' +
             ' INTO [FULL_ANALOG_' + fBuildInfo.Version + ']' +
             ' FROM [FULL_ANALOG_' + fBuildInfo.ParentVersion + ']'+ ' a RIGHT JOIN ( ' +
             '      SELECT c1.Cat_id as cat_id, a.cat_code as an_code , a.cat_br_descr as an_brand, 0 as an_id, a.locked, a.gen_an_id ' +
             '      FROM [ANALOG_BUF] a '+
             '        LEFT JOIN [BRANDS] b on  (b.description = a.cat_br_descr) '+
             '        LEFT JOIN [catalog]c on  (c.code2 = a.short_cat_code and c.brand_id = b.brand_id) '+
             '        LEFT JOIN [BRANDS] b1 on  (b1.description = a.an_br_descr) '+
             '        LEFT JOIN [catalog] c1 on  (c1.code2 = a.short_an_code and c1.brand_id = b1.brand_id) '+
             '      WHERE c.code is NULL and c1.Cat_id is NOT NULL ' +
             '      UNION ' +
             '      SELECT c.Cat_id, a.an_code, a.an_br_descr, COALESCE(c1.cat_id,0), a.locked, a.gen_an_id '+
             '      FROM [ANALOG_BUF] a ' +
             '        LEFT JOIN [BRANDS] b on  (b.description = a.cat_br_descr) '+
             '        LEFT JOIN [catalog]c on  (c.code2 = a.short_cat_code and c.brand_id = b.brand_id) '+
             '        LEFT JOIN [BRANDS] b1 on  (b1.description = a.an_br_descr) '+
             '        LEFT JOIN [catalog] c1 on  (c1.code2 = a.short_an_code and c1.brand_id = b1.brand_id) '+
             '      WHERE c.Cat_id is NOT NULL '+
             '      )t on (a.cat_id = t.cat_id and a.an_code = t.an_code and a.an_brand = t.an_brand and t.an_id = a.an_id) ';
      aQuery.ExecSQL;

      aQuery.sql.Clear;
      WriteBuildLog(' Генерируем GEN_AN_ID в [FULL_ANALOG_' + fBuildInfo.Version + ']');
      aQuery.SQL.Text :=
             ' UPDATE [FULL_ANALOG_' + fBuildInfo.Version + ']' +
             ' SET gen_an_id = COALESCE(gen_an_id,(SELECT MAX(gen_an_id) ' +
             '                                     FROM [FULL_ANALOG_' + fBuildInfo.Version + '] an ' +
             '                                     WHERE An.gen_an_id is not null and ' +
             '                                     [FULL_ANALOG_' + fBuildInfo.Version + '].an_code = An.An_code and ' +
             '                                     [FULL_ANALOG_' + fBuildInfo.Version + '].an_brand = An.an_brand and ' +
             '                                     [FULL_ANALOG_' + fBuildInfo.Version + '].an_id = An.an_id) ' +
             '                          )WHERE gen_an_id is NULL ';

      aQuery.ExecSQL;

      aQuery.SQL.Clear;
      WriteBuildLog(' Генерируем GEN_AN_ID в [FULL_ANALOG_' + fBuildInfo.Version + ']');
      aQuery.SQL.Text :=
             ' UPDATE [FULL_ANALOG_' + fBuildInfo.Version + ']' +
             ' SET gen_an_id = 0 + rez.rown ' +
             ' FROM (select ' +
             ' 		a.an_code, ' +
             ' 		a.an_brand, ' +
             ' 		a.an_id,' +
             ' 		a.gen_an_id, ' +
             ' 		row_number() over (order by a.an_code, ' +
             ' 		a.an_brand, '+
             ' 		a.an_id, '+
             ' 		a.gen_an_id) as rown ' +
             ' 	FROM ' +
             ' 		[FULL_ANALOG_' + fBuildInfo.Version + '] as a ' +
             ' 	GROUP BY ' +
             ' 		a.an_code, ' +
             ' 		a.an_brand, ' +
             ' 		a.an_id, ' +
             ' 		a.gen_an_id ' +
             '	 HAVING ' +
             '	  	a.gen_an_id IS NULL) rez ' +
             '  WHERE ' +
             '	 rez.an_code = [FULL_ANALOG_' + fBuildInfo.Version + '].an_code and ' +
             '	 rez.an_brand = [FULL_ANALOG_' + fBuildInfo.Version + '].an_brand and ' +
             '	 rez.an_id = [FULL_ANALOG_' + fBuildInfo.Version + '].an_id ';
      aQuery.ExecSQL;             
      WriteBuildLog(' Успешно завершено!!!!!!!!!!');

    finally
      aQuery.Free;
    end;

end;

procedure TFormMain.btAnaNew2OldClick(Sender: TObject);
var
  aReader: TCSVReader;
  anCodePrev, aGoods: string;
  aCode1, aBrand1, aCode2, aBrand2: string;
  f: TextFile;
  sl: TStrings;
  i, j: Integer;
begin
  if not OD.Execute then
    Exit;

  UpdateProgress(0, 'Конверт аналогов...');

  AssignFile(f, OD.FileName + '_new');
  Rewrite(f);

  anCodePrev := '';
  aReader := TCSVReader.Create;
  sl := makeStrings;
  try
    aReader.Open(OD.FileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      if anCodePrev = '' then
        anCodePrev := aReader.Fields[0];

      if (anCodePrev <> aReader.Fields[0]) or aReader.Eof then
      begin
        if aReader.Eof then
          sl.Add(aReader.Fields[1]);

        if sl.Count > 1 then
          for i := 0 to sl.Count - 2 do
          begin
            for j := i + 1 to sl.Count - 1 do
            begin
              if not DecodeCodeBrand(sl[i], aCode1, aBrand1, False) then
                Continue;
              if not DecodeCodeBrand(sl[j], aCode2, aBrand2, False) then
                Continue;
              Writeln(f, aBrand1 + ';' + aCode1 + ';' + aBrand2 + ';' + aCode2);
              Writeln(f, aBrand2 + ';' + aCode2 + ';' + aBrand1 + ';' + aCode1);
            end;
          end;
        sl.Clear;
      end;
      sl.Add(aReader.Fields[1]);
      anCodePrev := aReader.Fields[0];

      UpdateProgress(aReader.FilePosPercent);
    end;

  finally
    sl.Free;
    aReader.Free;
    CloseFile(f);
    UpdateProgress(100, 'Конверт аналогов... OK');
  end;

end;


procedure TFormMain.miMakeUpdateWebClick(Sender: TObject);

  procedure ZipFile(const aZipName, aDir: string; const aFileNames: array of string; aStoreRelativePath: Boolean = False);
  var
    anOutDir: string;
    i: Integer;
  begin
    anOutDir := aDir;
    with Zipper do
    begin
      Password := '';
      RootDir := IncludeTrailingPathDelimiter(anOutDir);
      ZipName := anOutDir + aZipName;

      if FileExists(ZipName) then
        SysUtils.DeleteFile(ZipName);

      FilesList.Clear;
      for i := Low(aFileNames) to High(aFileNames) do
        FilesList.Add(anOutDir + aFileNames[i]);
      StorePaths := aStoreRelativePath;
      RelativePaths := aStoreRelativePath;
      Zip;
    end;
  end;

  
var
  i: Integer;
  aPath, anOutPathPicts, aCurPathPicts, aPrevPathPicts: string;
  aQuery: TAdoQuery;
  aRecNo, aRecMax: Integer;

  anExportOut: TExportOut;

  aParamsF: array of Boolean;
  aParamsD: array of Boolean;
  aHasParams: Boolean;
  aParamsForm: TOutParamsSiteForm2;
  aZipEach: Boolean;
  aZipAll: Boolean;
  aZipAllFileName: string;
  aZipShateby: Boolean;
  aZipShatebyFileName: string;

  aStream: TMemoryStream;
  fOutFile: TextFile;
  aZipFiles: TStrings;
  aZipFilesAr: array of string;
  aStrings: TStrings;
begin
  ValidateSrez;

  fAborted := False;


  fReleasePrefix := fBuildInfo.ParentVersion;
  fUseRelease := fReleasePrefix <> '';
  if fUseRelease then
    fReleasePrefix := fReleasePrefix + '_';
  
  if fBuildInfo.CatalogCount = 0 then
    raise Exception.Create('Каталог пуст');
  aPath := ExtractFilePath(ParamStr(0));
  if not OpenDirDialog.OpenDirExecute(aPath, 'Укажите папку для сохранения файлов') then
    Exit;
  aPath := IncludeTrailingPathDelimiter(aPath);
  
  
  aParamsForm := TOutParamsSiteForm2.Create(Self);
  try
    aParamsForm.edZipName.Text := 'datamag_d' + fBuildInfo.Version + '.1.zip';
    aParamsForm.edZipName_shateby.Text := FormatDateTime('dd.mm.yyyy', Date()) + '_1.zip';
    if aParamsForm.ShowModal = mrOK then
    begin
      SetLength(aParamsD, aParamsForm.memParams.RecordCount);
      SetLength(aParamsF, aParamsForm.memParams.RecordCount);
      aHasParams := False;
      
      aParamsForm.memParams.First;
      i := 0;
      while not aParamsForm.memParams.Eof do
      begin
        aParamsF[i] := aParamsForm.memParamsUP_F.Value;
        aParamsD[i] := aParamsForm.memParamsUP_D.Value;
        aHasParams := aHasParams or aParamsF[i] or aParamsD[i];
        Inc(i);
        aParamsForm.memParams.Next;
      end;
      aZipEach := aParamsForm.cbZipEach.Checked;
      aZipAll := aParamsForm.cbZipAll.Checked;
      aZipAllFileName := aParamsForm.edZipName.Text;
      aZipShateby := aParamsForm.cbZip_shateby.Checked;
      aZipShatebyFileName := aParamsForm.edZipName_shateby.Text;
    end
    else
      Exit;
  finally
    aParamsForm.Free;
  end;

  if not aHasParams then
    Exit;

aStrings := makeStrings;    
anExportOut := TExportOut.Create(Self);
aZipFiles := TStringList.Create;
try

// *** каталог -------------------------------------------------------------------
  //Группа;Подгруппа;Бренд;Номер;Наименование;Описание;кратность
  if aParamsD[0] then
  begin
    //* новые *
    ExportTableEx(
      aPath + 'items_add.csv',
      ' SELECT g.GROUP_DESCR, g.SUBGROUP_DESCR, b.DESCRIPTION BRAND_DESCR, c.CODE, c.NAME, c.DESCRIPTION, c.MULT , c.No_ ' +
      ' FROM [CATALOG] c ' +
      ' LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      ' LEFT JOIN [GROUPS] g ON (g.GROUP_ID = c.GROUP_ID AND g.SUBGROUP_ID = c.SUBGROUP_ID) ' +
      ' WHERE (c.TITLE = 0 OR c.TITLE IS NULL) ' + 
      ' AND NOT EXISTS ( ' + 
      '  SELECT pc.* FROM [' + fReleasePrefix + 'CATALOG] pc WHERE (c.CAT_ID = pc.CAT_ID) ' +
      ' ) ' ,
      ['GROUP_DESCR', 'SUBGROUP_DESCR', 'BRAND_DESCR', 'CODE', 'NAME', 'DESCRIPTION', 'MULT', 'No_'],
      '',
      True,
      'Экспорт каталога - новые'
    );

    //* +измененные *
    ExportTableEx(
      aPath + 'items_add.csv',
      ' SELECT g.GROUP_DESCR, g.SUBGROUP_DESCR, b.DESCRIPTION BRAND_DESCR, c.CODE, c.NAME, c.DESCRIPTION, c.MULT, c.No_ ' +
      ' FROM [CATALOG] c ' +
      ' LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      ' LEFT JOIN [GROUPS] g ON (g.GROUP_ID = c.GROUP_ID AND g.SUBGROUP_ID = c.SUBGROUP_ID) ' +

      ' INNER JOIN [' + fReleasePrefix + 'CATALOG] pc on (c.CAT_ID = pc.CAT_ID) ' +
      ' LEFT JOIN [' + fReleasePrefix + 'BRANDS] pb ON (pb.BRAND_ID = pc.BRAND_ID) ' +
      ' LEFT JOIN [' + fReleasePrefix + 'GROUPS] pg ON (pg.GROUP_ID = pc.GROUP_ID AND pg.SUBGROUP_ID = pc.SUBGROUP_ID) ' +
      
      ' WHERE ' +
      '   (c.TITLE = 0 OR c.TITLE IS NULL) AND ' + 
      '   g.GROUP_DESCR <> pg.GROUP_DESCR OR ' + 
      '   g.SUBGROUP_DESCR <> pg.SUBGROUP_DESCR OR ' +
      '   b.DESCRIPTION <> pb.DESCRIPTION OR ' +
      '   c.CODE <> pc.CODE OR ' +
      '   c.NAME <> pc.NAME OR ' +
      '   c.DESCRIPTION <> pc.DESCRIPTION OR ' +
      '   c.MULT <> pc.MULT ',
      ['GROUP_DESCR', 'SUBGROUP_DESCR', 'BRAND_DESCR', 'CODE', 'NAME', 'DESCRIPTION', 'MULT', 'No_'],
      '',
      False,
      'Экспорт каталога - измененные'
    );
    

    //* удаленные *
    ExportTableEx(
      aPath + 'items_del.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND ' +
      ' FROM [' + fReleasePrefix + 'CATALOG] c ' +
      ' LEFT JOIN [' + fReleasePrefix + 'BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      ' WHERE (c.TITLE = 0 OR c.TITLE IS NULL) ' + 
      ' AND NOT EXISTS ( ' + 
      '  SELECT pc.* FROM [CATALOG] pc WHERE (c.CAT_ID = pc.CAT_ID) ' +
      ' ) ' ,
      ['CODE_BRAND'],
      '',
      True,
      'Экспорт каталога - удаленные'
    );

    if not fAborted then
    begin
      if aZipEach then
      begin
        ZipFile('items_add.zip', aPath, ['items_add.csv']);
        ZipFile('items_del.zip', aPath, ['items_del.csv']);
      end;  
      if aZipAll then
      begin
        aZipFiles.Add('items_add.csv');
        aZipFiles.Add('items_del.csv');
      end;  
    end;
  end
  else
    if aParamsF[0] then
    begin
      ExportTableEx(
        aPath + 'items.csv',
        ' SELECT g.GROUP_DESCR, g.SUBGROUP_DESCR, b.DESCRIPTION BRAND_DESCR, c.CODE, c.NAME, c.DESCRIPTION, c.MULT, c.No_ ' +
        ' FROM [CATALOG] c ' +
        ' LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
        ' LEFT JOIN [GROUPS] g ON (g.GROUP_ID = c.GROUP_ID AND g.SUBGROUP_ID = c.SUBGROUP_ID) ' +
        ' WHERE c.TITLE = 0 OR c.TITLE IS NULL ',
        ['GROUP_DESCR', 'SUBGROUP_DESCR', 'BRAND_DESCR', 'CODE', 'NAME', 'DESCRIPTION', 'MULT', 'No_'],
        '',
        True,
        'Экспорт каталога',
        ' SELECT Count(*) FROM [CATALOG] WHERE TITLE = 0 OR TITLE IS NULL '
      );

      if not fAborted then
      begin
        if aZipEach then
          ZipFile('items.zip', aPath, ['items.csv']);
        if aZipAll then
          aZipFiles.Add('items.csv');
      end;
    end;
  

{
SELECT DISTINCT
  O.CODE OE_CODE, 
  C.CODE, 
  C.BRAND, 
  V.NAME 
from OE_CODES o  
INNER join dbo.OE_ART_LINK al on (al.OE_ID = o.ID)  
INNER join dbo.CATALOG c on (c.CAT_ID = al.CAT_ID)
INNER JOIN dbo.EO_VENDORGROUP_LINK vl on (o.ID = vl.OE_ID)  
INNER JOIN VENDORS v ON (vl.VENDOR_GROUP_ID = v.GROUP_ID) 
where v.active = 1

}  
  
// *** аналоги -------------------------------------------------------------------
  //Номер позиции_бренд позиции;номер аналога_бренд аналога;Отображать
  if aParamsD[1] then
  begin
    //* новые *
    ExportTableEx(
      aPath + 'analogs_add.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, a.AN_CODE + ''_'' + a.AN_BRAND AN_CODE_BRAND, a.LOCKED ' +
      ' FROM [ANALOG] a ' +
      ' LEFT JOIN [CATALOG] c ON (c.CAT_ID = a.CAT_ID) ' +
      ' LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' + 
      ' WHERE NOT EXISTS ( ' + 
      '   SELECT pa.* FROM [' + fReleasePrefix + 'ANALOG] pa WHERE (a.ID = pa.ID) ' +
      ' ) ',
      ['CODE_BRAND', 'AN_CODE_BRAND', 'LOCKED'],
      '',
      True,
      'Экспорт аналогов - новые',
      '',
      anExportOut.GetValueAnalog
    );

    //* +измененные *
    ExportTableEx(
      aPath + 'analogs_add.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, a.AN_CODE + ''_'' + a.AN_BRAND AN_CODE_BRAND, a.LOCKED ' +
      ' FROM [ANALOG] a ' +
      ' LEFT JOIN [CATALOG] c ON (c.CAT_ID = a.CAT_ID) ' +
      ' LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +

      ' INNER JOIN [' + fReleasePrefix + 'ANALOG] pa ON (a.ID = pa.ID) ' +
      ' WHERE a.LOCKED <> pa.LOCKED ',
      
      ['CODE_BRAND', 'AN_CODE_BRAND', 'LOCKED'],
      '',
      False,
      'Экспорт аналогов - измененные',
      '',
      anExportOut.GetValueAnalog
    );
    
    //* удаленные *
    ExportTableEx(
      aPath + 'analogs_del.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, a.AN_CODE + ''_'' + a.AN_BRAND AN_CODE_BRAND ' +
      ' FROM [' + fReleasePrefix + 'ANALOG] a ' +
      ' LEFT JOIN [' + fReleasePrefix + 'CATALOG] c ON (c.CAT_ID = a.CAT_ID) ' +
      ' LEFT JOIN [' + fReleasePrefix + 'BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' + 
      ' WHERE NOT EXISTS ( ' + 
      '   SELECT pa.* FROM [ANALOG] pa WHERE (a.ID = pa.ID) ' +
      ' ) ',
      ['CODE_BRAND', 'AN_CODE_BRAND'],
      '',
      True,
      'Экспорт аналогов - удаленные',
      '',
      anExportOut.GetValueAnalog
    );

    if not fAborted then
    begin
      if aZipEach then
      begin
        ZipFile('analogs_add.zip', aPath, ['analogs_add.csv']);
        ZipFile('analogs_del.zip', aPath, ['analogs_del.csv']);
      end;  
      if aZipAll then
      begin
        aZipFiles.Add('analogs_add.csv');
        aZipFiles.Add('analogs_del.csv');
      end;  
      if aZipShateby then
      begin
        ZipFile('analogsadd_' + aZipShatebyFileName, aPath, ['analogs_add.csv']);
        ZipFile('analogsdel_' + aZipShatebyFileName, aPath, ['analogs_del.csv']);
      end;  
    end;    
  end
  else  
    if aParamsF[1] then
    begin
      ExportTableEx(
        aPath + 'analogs.csv',
        ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, AN_CODE + ''_'' + AN_BRAND AN_CODE_BRAND, a.LOCKED ' +
        ' FROM [FULL_ANALOG_' + fBuildInfo.Version + '] a ' +
        ' LEFT JOIN [CATALOG] c ON (c.CAT_ID = a.CAT_ID) ' +
        ' LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ',
        ['CODE_BRAND', 'AN_CODE_BRAND', 'LOCKED'],
        '',
        True,
        'Экспорт аналогов',
        ' SELECT Count(*) FROM [ANALOG] ',
        anExportOut.GetValueAnalog
      );    
      
      if not fAborted then
      begin
        if aZipEach then
          ZipFile('analogs.zip', aPath, ['analogs.csv']);
        if aZipAll then
          aZipFiles.Add('analogs.csv');
        if aZipShateby then
        begin
          ZipFile('analogs_' + aZipShatebyFileName, aPath, ['analogs.csv']);
        end;
      end;    
    end;
    

// *** OE ------------------------------------------------------------------------
  //Номер позиции_бренд позиции;номер OE
  if aParamsD[2] then
  begin
    //* новые *
    ExportTableEx(
      aPath + 'oe_add.csv',
      ' select c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, o.CODE OE_CODE ' +
      ' FROM [OE] o ' +
      ' LEFT JOIN [CATALOG] c ON (c.CAT_ID = o.CAT_ID) ' +
      ' LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      ' WHERE NOT EXISTS ( ' +
      '   SELECT po.* FROM [' + fReleasePrefix + 'OE] po WHERE (o.ID = po.ID) ' +
      ' ) ',
      ['CODE_BRAND', 'OE_CODE'],
      '',
      True,
      'Экспорт OE - новые'
    );

    //* удаленные *
    ExportTableEx(
      aPath + 'oe_del.csv',
      ' select c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, o.CODE OE_CODE ' +
      ' FROM [' + fReleasePrefix + 'OE] o ' +
      ' LEFT JOIN [' + fReleasePrefix + 'CATALOG] c ON (c.CAT_ID = o.CAT_ID) ' +
      ' LEFT JOIN [' + fReleasePrefix + 'BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' + 
      ' WHERE NOT EXISTS ( ' + 
      '   SELECT po.* FROM [OE] po WHERE (o.ID = po.ID) ' +
      ' ) ',
      ['CODE_BRAND', 'OE_CODE'],
      '',
      True,
      'Экспорт OE - удаленные'
    );

    if not fAborted then
    begin
      if aZipEach then
      begin
        ZipFile('oe_add.zip', aPath, ['oe_add.csv']);
        ZipFile('oe_del.zip', aPath, ['oe_del.csv']);
      end;  
      if aZipAll then
      begin
        aZipFiles.Add('oe_add.csv');
        aZipFiles.Add('oe_del.csv');
      end;  
      if aZipShateby then
      begin
        ZipFile('oeadd_' + aZipShatebyFileName, aPath, ['oe_add.csv']);
        ZipFile('oedel_' + aZipShatebyFileName, aPath, ['oe_del.csv']);
      end;  
    end;    
  end
  else
    if aParamsF[2] then
    begin
      ExportTableEx(
        aPath + 'oe.csv',
        ' select c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, o.CODE OE_CODE ' +
        ' FROM [OE_BUF_' + fBuildInfo.Version + '] o ' +
        ' LEFT JOIN [CATALOG] c ON (c.CAT_ID = o.CAT_ID) ' +
        ' LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ',
        ['CODE_BRAND', 'OE_CODE'],
        '',
        True,
        'Экспорт OE',
        ' SELECT Count(*) FROM [OE] '
      );

//для shate-m.by выгружаем другие ОЕ (с производителями)
      if aZipShateby then
      begin
        ExportTableEx(
          aPath + 'oe_full.csv',
          

          ' select  ' +
          '   c.CODE + ''_'' + c.BRAND CODE_BRAND, ' +
          '   o.CODE OE_CODE, ' +
          '   v.Name VENDOR' +
          ' from [NOM].[dbo].[OE_CODES] o ' +
          ' INNER join [NOM].[dbo].[OE_ART_LINK] al on (al.OE_ID = o.ID) ' +
          ' INNER join [NOM].[dbo].[CATALOG] c on (c.CAT_ID = al.CAT_ID) ' +
          ' LEFT JOIN [NOM].[dbo].[EO_VENDORGROUP_LINK] vl on (o.ID = vl.OE_ID) ' +
          ' INNER JOIN [NOM].[dbo].[VENDORS] v ON (vl.VENDOR_GROUP_ID = v.GROUP_ID and v.MAIN = 1) ' +
          ' union ' +
          ' select ' +
          '   c.CODE + ''_'' + c.BRAND CODE_BRAND, ' +
          '   o.CODE OE_CODE, ' +
          '   ''OE'' VENDOR ' +
          ' from [NOM].[dbo].[OE_CODES] o ' +
          ' INNER join [NOM].[dbo].[OE_ART_LINK] al on (al.OE_ID = o.ID) ' +
          ' INNER join [NOM].[dbo].[CATALOG] c on (c.CAT_ID = al.CAT_ID) ' +
          ' LEFT JOIN [NOM].[dbo].[EO_VENDORGROUP_LINK] vl on (o.ID = vl.OE_ID) ' +
          ' where vl.OE_ID IS NULL ',
        
          ['CODE_BRAND', 'OE_CODE', 'VENDOR'],
          '',
          True,
          'Экспорт OE для shate-m.by',
          '',
          nil,
          True {UseServerCursor}
        );
      end;   
//---------------------------------------------------------      

      if not fAborted then
      begin
        if aZipEach then
          ZipFile('oe.zip', aPath, ['oe.csv']);
        if aZipAll then
          aZipFiles.Add('oe.csv');
        if aZipShateby then
        begin
          ZipFile('oe_' + aZipShatebyFileName, aPath, ['oe_full.csv']);
        end;  
      end;    
    end;
  

// *** список автомобилей
  //3822;ALFA ROMEO;145 (930);1.4 i.e.;1994/07 - 1996/12;66;90;1351;1,4;4;Наклонная задняя часть;0;Бензиновый двигатель;Впрыскивание во впускной коллектор/Карбюратор;2;с регулируемым катализатором (3-х ступенчатый);AR 33501;Привод на передние колеса;гидравлический;;;;
  if aParamsD[3] then
  begin
    //>>>>>>>>>>>>>>>>>>>>>>>
    //ничего не делаем для частичного - машины обычно не меняются
    //при изменении выкладываем полное
  end
  else
    if aParamsF[3] then
    begin
      CacheTD_DES(memDES);
      memDES.Open;
      try
        ExportTableEx(
          aPath + 'cars.csv',
          ' SELECT t.TYP_ID, ' +
          '        ma.MFA_BRAND, ' +
          '        m.TEX_TEXT model, ' +
          '        t1.TEX_TEXT submodel, ' +
          '        CAST(t.PCON_START as varchar(10)) + '' - '' + CAST(t.PCON_END as varchar(10)) years, ' +
          '        t.KW_FROM, ' +
          '        t.HP_FROM, ' +
          '        t.CCM, ' +
          '        t.CCM CCM_ROUND, ' +
          '        t.CYLINDERS, ' +
          '        t.BODY_DES_ID, ' +
          '        t.DOORS, ' +
          '        t.ENGINE_DES_ID, ' +
          '        t.FUEL_SUPPLY_DES_ID, ' +
          '        t.VALVES, ' +
          '        t.CATALYST_DES_ID, ' +
          '        t.ENG_CODES, ' +
          '        t.DRIVE_DES_ID, ' +
          '        t.BRAKE_SYST_DES_ID, ' +
          '        t.BRAKE_TYPE_DES_ID, ' +
          '        t.ABS_DES_ID, ' +
          '        t.ASR_DES_ID ' +
          ' FROM [' + fTecdocDB + '].[DBO].[TD_TYPES] t ' +
          ' LEFT JOIN [' + fTecdocDB + '].[DBO].[TD_MODELS] m ON (t.MOD_ID = m.MOD_ID) ' +
          ' INNER JOIN [' + fTecdocDB + '].[DBO].[TD_MANUFACTURERS] ma ON (ma.MFA_ID = m.MFA_ID and ma.HIDE = 0) ' +
          ' LEFT JOIN [' + fTecdocDB + '].[DBO].[TD_CDS] t1 ON (t1.CDS_ID = t.CDS_ID) ',
          [
           'TYP_ID',
           'MFA_BRAND',
           'model',
           'submodel',
           'years',
           'KW_FROM',
           'HP_FROM',
           'CCM',
           'CCM_ROUND',
           'CYLINDERS',
           'BODY_DES_ID',
           'DOORS',
           'ENGINE_DES_ID',
           'FUEL_SUPPLY_DES_ID',
           'VALVES',
           'CATALYST_DES_ID',
           'ENG_CODES',
           'DRIVE_DES_ID',
           'BRAKE_SYST_DES_ID',
           'BRAKE_TYPE_DES_ID',
           'ABS_DES_ID',
           'ASR_DES_ID'
          ],
          '',
          True,
          'Экспорт авто',
          ' SELECT Count(t.ID) ' +
          ' FROM [' + fTecdocDB + '].[DBO].[TD_TYPES] t ' +
          ' INNER JOIN [' + fTecdocDB + '].[DBO].[TD_MODELS] m ON (t.MOD_ID = m.MOD_ID) ' +
          ' INNER JOIN [' + fTecdocDB + '].[DBO].[TD_MANUFACTURERS] ma ON (ma.MFA_ID = m.MFA_ID and ma.HIDE = 0) ',
          anExportOut.GetValueCars
        );
      finally
        memDES.Close;
      end;

      if not fAborted then
      begin
        if aZipEach then
          ZipFile('cars.zip', aPath, ['cars.csv']);
        if aZipAll then
          aZipFiles.Add('cars.csv');
      end;
    end;

// *** применяемость к машине
  //Номер_Бренд;IDCAR
  if aParamsD[4] then
  begin
    //* новые *
    ExportTableEx(
      aPath + 'apply_add.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, at.TYP_ID ' +
      ' FROM [CATALOG] c ' +
      '   INNER JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      '   INNER JOIN [AT] at on (at.ART_ID = c.TYP_TDID) ' +
      ' WHERE NOT EXISTS ( ' +
      '   SELECT pat.* FROM [' + fReleasePrefix + 'AT] pat WHERE (at.ART_ID = pat.ART_ID AND at.TYP_ID = pat.TYP_ID) ' +
      ' ) ',
      ['CODE_BRAND', 'TYP_ID'],
      '',
      True,
      'Экспорт применяемости - новые'
    );

    //* удаленные *
    ExportTableEx(
      aPath + 'apply_del.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, a.TYP_ID ' +
      ' FROM [' + fReleasePrefix + 'CATALOG] c ' +
      '   INNER JOIN [' + fReleasePrefix + 'BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      '   INNER JOIN [' + fReleasePrefix + 'AT] a on (a.ART_ID = c.TYP_TDID) ' +
      ' WHERE NOT EXISTS ( ' +
      '   SELECT pa.* FROM [AT] pa WHERE (a.ART_ID = pa.ART_ID AND a.TYP_ID = pa.TYP_ID) ' +
      ' ) ',
      ['CODE_BRAND', 'TYP_ID'],
      '',
      True,
      'Экспорт применяемости - удаленные'
    );

    if not fAborted then
    begin
      if aZipEach then
      begin
        ZipFile('apply_add.zip', aPath, ['apply_add.csv']);
        ZipFile('apply_del.zip', aPath, ['apply_del.csv']);
      end;  
      if aZipAll then
      begin
        aZipFiles.Add('apply_add.csv');
        aZipFiles.Add('apply_del.csv');
      end;
    end;
    
  end
  else
    if aParamsF[4] then
    begin
      ExportTableEx(
        aPath + 'apply.csv',
        ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, at.TYP_ID ' +
        ' FROM [CATALOG] c ' +
        '   INNER JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
        '   INNER JOIN [AT] at on (at.ART_ID = c.TYP_TDID) where  (c.CODE is not null  or b.DESCRIPTION is not null) and at.ART_ID > 0 ',
        ['CODE_BRAND', 'TYP_ID'],
        '',
        True,
        'Экспорт применяемости',
        ' SELECT Count(*) FROM [AT] ',
        nil,
        True {UseServerCursor}
      );

      if not fAborted then
      begin
        if aZipEach then
          ZipFile('apply.zip', aPath, ['apply.csv']);
        if aZipAll then
          aZipFiles.Add('apply.csv');
      end;
    end;

// *** ограничения по машине
  //IDCAR;Номер_Бренд;Название параметра=значение
  if aParamsD[5] then
  begin
    //* новые *  ok
    ExportTableEx(
      aPath + 'limits_add.csv',
      ' SELECT dt.TYP_ID, c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, p.DESCRIPTION + ''='' + dt.PARAM_VALUE PARAM ' +
      ' FROM [' + fTecdocDB + '].[DBO].[TD_DETAILS_TYP] dt ' +
      '   INNER JOIN [CATALOG] c ON (c.TYP_TDID = dt.ART_ID) ' +
      '   INNER JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      '   INNER JOIN [' + fTecdocDB + '].[DBO].[TD_PARAMS] p on (p.PARAM_ID = dt.PARAM_ID) ' +
      '   INNER JOIN DET_TYP det ON (det.ART_ID = dt.ART_ID AND det.TYP_ID = dt.TYP_ID) ' +
      ' WHERE NOT EXISTS ( ' +
      '   SELECT pdet.* FROM [' + fReleasePrefix + 'DET_TYP] pdet WHERE (det.ART_ID = pdet.ART_ID AND det.TYP_ID = pdet.TYP_ID) ' +
      ' ) ORDER BY dt.TYP_ID, c.CODE, b.DESCRIPTION ',
      ['CODE_BRAND', 'PARAM'],
      '',
      True,
      'Экспорт ограничений - новые'
    );

    //* +измененные *
    ExportTableEx(
      aPath + 'limits_add.csv',
      ' SELECT dt.TYP_ID, c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, p.DESCRIPTION + ''='' + dt.PARAM_VALUE PARAM ' +
      ' FROM [' + fTecdocDB + '].[DBO].[TD_DETAILS_TYP] dt ' +
      '   INNER JOIN [CATALOG] c ON (c.TYP_TDID = dt.ART_ID) ' +
      '   INNER JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      '   INNER JOIN [' + fTecdocDB + '].[DBO].[TD_PARAMS] p on (p.PARAM_ID = dt.PARAM_ID) ' +

      '   INNER JOIN DET_TYP det ON (det.ART_ID = dt.ART_ID AND det.TYP_ID = dt.TYP_ID) ' +
      '   INNER JOIN [' + fReleasePrefix + 'DET_TYP] pdet ON (det.ART_ID = pdet.ART_ID AND det.TYP_ID = pdet.TYP_ID) ' +
      ' WHERE det.PARAMS_CHECKSUM <> pdet.PARAMS_CHECKSUM ' + 
      ' ORDER BY dt.TYP_ID, c.CODE, b.DESCRIPTION ',
      ['CODE_BRAND', 'PARAM'],
      '',
      False,
      'Экспорт ограничений - измененные'
    );
    
    //* удаленные *
    ExportTableEx(
      aPath + 'limits_del.csv',
      ' SELECT det.TYP_ID, c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND ' +
      ' FROM [' + fReleasePrefix + 'CATALOG] c ' +
      '   INNER JOIN [' + fReleasePrefix + 'BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      '   INNER JOIN [' + fReleasePrefix + 'DET_TYP] det ON (det.ART_ID = c.TYP_TDID) ' +
      ' WHERE NOT EXISTS ( ' +
      '   SELECT pdet.* FROM [DET_TYP] pdet WHERE (det.ART_ID = pdet.ART_ID AND det.TYP_ID = pdet.TYP_ID) ' +
      ' ) ',
      ['CODE_BRAND'],
      '',
      True,
      'Экспорт ограничений - удаленные'
    );
    
    if not fAborted then
    begin
      if aZipEach then
      begin
        ZipFile('limits_add.zip', aPath, ['limits_add.csv']);
        ZipFile('limits_del.zip', aPath, ['limits_del.csv']);
      end;  
      if aZipAll then
      begin
        aZipFiles.Add('limits_add.csv');
        aZipFiles.Add('limits_del.csv');
      end;
    end;
  end
  else
    if aParamsF[5] then
    begin
      DeleteFile(aPath + 'limits.csv');

      aRecMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT COUNT(*) FROM [CATALOG] WHERE TYP_TDID > 0', []), 0);

      aQuery := TAdoQuery.Create(nil);
      try
        aQuery.Connection := connService;
        aQuery.CursorLocation := clUseServer;
        aQuery.CursorType := ctOpenForwardOnly;
        aQuery.CommandTimeout := 60 * 5;
        aQuery.SQL.Text :=
          ' SELECT c.TYP_TDID, c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND ' +
          ' FROM [CATALOG] c ' +
          '   LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
          ' WHERE c.TYP_TDID > 0 ';
        aQuery.Open;
        aRecNo := 1;
        while not aQuery.Eof do
        begin
          anExportOut.CurrentCodeBrand := aQuery.Fields[1].AsString;

          //экспортим пачками по одному артикулу
          ExportTableEx(
            aPath + 'limits.csv',
            ' SELECT dt.TYP_ID, 1 CODE_BRAND, p.DESCRIPTION + ''='' + dt.PARAM_VALUE PARAM ' +
            ' FROM [' + fTecdocDB + '].[DBO].[TD_DETAILS_TYP] dt ' +
            '   LEFT JOIN [' + fTecdocDB + '].[DBO].[TD_PARAMS] p on (p.PARAM_ID = dt.PARAM_ID) ' +
            ' WHERE dt.ART_ID = ' + aQuery.Fields[0].AsString,
             ['TYP_ID', 'CODE_BRAND', 'PARAM'],
            '',
            False,
            '',
            '',
            anExportOut.GetValueDetTyp
          );

          Inc(aRecNo);
          aQuery.Next;
          if aRecNo mod 100 = 0 then
            UpdateProgress(aRecNo * 100 div aRecMax, 'Экспорт ограничений [' + IntToStr(aRecNo) + ' из ' + IntToStr(aRecMax) + ']');
          if fAborted then
            Exit;
        end;
        aQuery.Close;
      finally
        aQuery.Free;
        UpdateProgress(0, 'finish');
      end;

      if not fAborted then
      begin
        if aZipEach then
          ZipFile('limits.zip', aPath, ['limits.csv']);
        if aZipAll then
          aZipFiles.Add('limits.csv');
      end;
    end;

// *** описания
  //Номер_Бренд;Название параметра=значение
  if aParamsD[6] then
  begin
    //* новые *
    ExportTableEx(
      aPath + 'descriptions_add.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, p.DESCRIPTION + ''='' + d.PARAM_VALUE PARAM ' +
      ' FROM [' + fTecdocDB + '].[DBO].[TD_DETAILS] d ' +
      '   INNER JOIN [CATALOG] c ON (c.PARAM_TDID = d.ART_ID) ' +
      '   INNER JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      '   INNER JOIN [' + fTecdocDB + '].[DBO].[TD_PARAMS] p on (p.PARAM_ID = d.PARAM_ID) ' +
      ' WHERE NOT EXISTS ( ' +
      '   SELECT pd.* FROM [' + fReleasePrefix + 'DET] pd WHERE (d.ART_ID = pd.ART_ID) ' +
      ' ) ',
      ['CODE_BRAND', 'PARAM'],
      '',
      True,
      'Экспорт описаний - новые'
    );

    //* +измененные *
    ExportTableEx(
      aPath + 'descriptions_add.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, p.DESCRIPTION + ''='' + d.PARAM_VALUE PARAM ' +
      ' FROM [' + fTecdocDB + '].[DBO].[TD_DETAILS] d ' +
      '   INNER JOIN [CATALOG] c ON (c.PARAM_TDID = d.ART_ID) ' +
      '   INNER JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      '   INNER JOIN [' + fTecdocDB + '].[DBO].[TD_PARAMS] p on (p.PARAM_ID = d.PARAM_ID) ' +

      '   INNER JOIN [DET] det ON (det.ART_ID = c.PARAM_TDID) ' +
      '   INNER JOIN [' + fReleasePrefix + 'DET] pdet ON (det.ART_ID = pdet.ART_ID) ' +
      ' WHERE det.PARAMS_CHECKSUM <> pdet.PARAMS_CHECKSUM ',
      ['CODE_BRAND', 'PARAM'],
      '',
      False,
      'Экспорт описаний - измененные'
    );
    
    //* удаленные *
    ExportTableEx(
      aPath + 'descriptions_del.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND ' +
      ' FROM [' + fReleasePrefix + 'CATALOG] c ' +
      '   INNER JOIN [' + fReleasePrefix + 'BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      '   INNER JOIN [' + fReleasePrefix + 'DET] d on (d.ART_ID = c.PARAM_TDID) ' +
      ' WHERE NOT EXISTS ( ' +
      '   SELECT pd.* FROM [DET] pd WHERE (d.ART_ID = pd.ART_ID) ' +
      ' ) ',
      ['CODE_BRAND'],
      '',
      True,
      'Экспорт описаний - удаленные'
    );

    if not fAborted then
    begin
      if aZipEach then
      begin
        ZipFile('descriptions_add.zip', aPath, ['descriptions_add.csv']);
        ZipFile('descriptions_del.zip', aPath, ['descriptions_del.csv']);
      end;  
      if aZipAll then
      begin
        aZipFiles.Add('descriptions_add.csv');
        aZipFiles.Add('descriptions_del.csv');
      end;
    end;
  end
  else
    if aParamsF[6] then
    begin
      DeleteFile(aPath + 'descriptions.csv');

      aRecMax := StrToIntDef(ExecuteSimpleSelectMS('SELECT COUNT(*) FROM [CATALOG] WHERE PARAM_TDID > 0', []), 0);

      aQuery := TAdoQuery.Create(nil);
      try
        aQuery.Connection := connService;
        aQuery.CursorLocation := clUseServer;
        aQuery.CursorType := ctOpenForwardOnly;
        aQuery.CommandTimeout := 60 * 5;
        aQuery.SQL.Text :=
          ' SELECT c.PARAM_TDID, c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND ' +
          ' FROM [CATALOG] c ' +
          '   LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
          ' WHERE c.PARAM_TDID > 0 ';
        aQuery.Open;
        aRecNo := 1;
        while not aQuery.Eof do
        begin
          anExportOut.CurrentCodeBrand := aQuery.Fields[1].AsString;

          //экспортим пачками по одному артикулу
          ExportTableEx(
            aPath + 'descriptions.csv',
            ' SELECT 1 CODE_BRAND, p.DESCRIPTION + ''='' + d.PARAM_VALUE PARAM ' +
            ' FROM [' + fTecdocDB + '].[DBO].[TD_DETAILS] d ' +
            '   LEFT JOIN [' + fTecdocDB + '].[DBO].[TD_PARAMS] p on (p.PARAM_ID = d.PARAM_ID) ' +
            ' WHERE d.ART_ID  = ' + aQuery.Fields[0].AsString,
             ['CODE_BRAND', 'PARAM'],
            '',
            False,
            '',
            '',
            anExportOut.GetValueDet
          );

          Inc(aRecNo);
          aQuery.Next;
          if aRecNo mod 100 = 0 then
            UpdateProgress(aRecNo * 100 div aRecMax, 'Экспорт описаний [' + IntToStr(aRecNo) + ' из ' + IntToStr(aRecMax) + ']');
          if fAborted then
            Exit;
        end;
        aQuery.Close;
      finally
        aQuery.Free;
        UpdateProgress(0, 'finish');
      end;

      if not fAborted then
      begin
        if aZipEach then
          ZipFile('descriptions.zip', aPath, ['descriptions.csv']);
        if aZipAll then
          aZipFiles.Add('descriptions.csv');
      end;
    end;

// *** картинки (список)
  //Номер_Бренд;Путь к картинке
  if aParamsD[7] then
  begin
    //>>>>>>>>>>>>>>>>>>>>>>>
    anExportOut.SitePathPicts := 'http://www.shate-mag.by/data/service/picts/';
    anExportOut.PictIDs.Clear;
    //* новые *
    ExportTableEx(
      aPath + 'picts_add.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, p.PICT_ID FROM [PICTS] p ' +
      ' INNER JOIN [CATALOG] c ON (c.PICT_ID = p.PICT_ID) ' +
      ' INNER JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      ' WHERE NOT EXISTS ( ' +
      '  SELECT pc.ID FROM [' + fReleasePrefix + 'PICTS] pc WHERE (p.PICT_ID = pc.PICT_ID) ' +
      ' ) ',
      ['CODE_BRAND', 'PICT_ID'],
      '0',
      True,
      'Экспорт списка картинок - новые',
      ' SELECT Count(p.PICT_ID) FROM [PICTS] p ' +
      ' WHERE NOT EXISTS ( ' +
      '  SELECT pc.ID FROM [' + fReleasePrefix + 'PICTS] pc WHERE (p.PICT_ID = pc.PICT_ID) ' +
      ' ) ',
      anExportOut.GetValuePict
    );

    //* +измененные *
    ExportTableEx(
      aPath + 'picts_add.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, p.PICT_ID FROM [PICTS] p ' +
      ' INNER JOIN [CATALOG] c ON (c.PICT_ID = p.PICT_ID) ' +
      ' INNER JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      ' INNER JOIN [' + fReleasePrefix + 'PICTS] pc ON (p.PICT_ID = pc.PICT_ID and p.HASH <> pc.HASH) ',
      ['CODE_BRAND', 'PICT_ID'],
      '0',
      False, //дописать
      'Экспорт списка картинок - измененные',
      ' SELECT Count(p.PICT_ID) FROM [PICTS] p ' +
      ' INNER JOIN [' + fReleasePrefix + 'PICTS] pc ON (p.PICT_ID = pc.PICT_ID and p.HASH <> pc.HASH) ',
      anExportOut.GetValuePict
    );
    aStrings.Assign(anExportOut.PictIDs);

    //* удаленные *
    ExportTableEx(
      aPath + 'picts_del.csv',
      ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, p.PICT_ID ' +
      ' FROM [' + fReleasePrefix + 'PICTS] p ' +
      ' INNER JOIN [' + fReleasePrefix + 'CATALOG] c ON (c.PICT_ID = p.PICT_ID) ' +
      ' INNER JOIN [' + fReleasePrefix + 'BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
      ' WHERE NOT EXISTS ( ' +
      '  SELECT pc.ID FROM [PICTS] pc WHERE (p.PICT_ID = pc.PICT_ID) ' +
      ' ) ',
      ['CODE_BRAND', 'PICT_ID'],
      '0',
      True,
      'Экспорт списка картинок - удаленные',
      ' SELECT Count(p.PICT_ID) FROM [' + fReleasePrefix + 'PICTS] p ' +
      ' WHERE NOT EXISTS ( ' +
      '  SELECT pc.ID FROM [PICTS] pc WHERE (p.PICT_ID = pc.PICT_ID) ' +
      ' ) ',
      anExportOut.GetValuePict
    );
    
    if fAborted then
      Exit;

    if not fAborted then
    begin
      if aZipEach then
      begin
        ZipFile('picts_add.zip', aPath, ['picts_add.csv']);
        ZipFile('picts_del.zip', aPath, ['picts_del.csv']);
      end;  
      if aZipAll then
      begin
        aZipFiles.Add('picts_add.csv');
        aZipFiles.Add('picts_del.csv');
      end;  
    end;

  // *** картинки (файлы)
(*  
    aRecMax := StrToIntDef(
      ExecuteSimpleSelectMS(
        ' SELECT Count(p.PICT_ID) FROM [PICTS] p ' +
        ' WHERE NOT EXISTS ( ' +
        '   SELECT pc.ID FROM [' + fReleasePrefix + 'PICTS] pc WHERE (p.PICT_ID = pc.PICT_ID) ' +
        ' ) ' +
        ' OR EXISTS ( ' +
        '   SELECT pc1.ID FROM [' + fReleasePrefix + 'PICTS] pc1 WHERE (p.PICT_ID = pc1.PICT_ID and p.HASH <> pc1.HASH) ' +
        ' ) ',
        []
      ), 0);
*)
    aRecMax := aStrings.Count;
    UpdateProgress(0, 'Экспорт картинок [' + IntToStr(aRecMax) + ']... ');

    anOutPathPicts := aPath + 'picts\';
    if not DirectoryExists(anOutPathPicts) then
      ForceDirectories(anOutPathPicts);
    EraseDirFiles(anOutPathPicts, False);  

    aQuery := TAdoQuery.Create(nil);
    try
      aQuery.Connection := connService;
      aQuery.CursorLocation := clUseClient;
      aQuery.CursorType := ctStatic;
      aQuery.CommandTimeout := 60 * 5;
      aQuery.SQL.Text :=
        ' SELECT pp.PICT_ID, pp.PICT_DATA FROM [' + fTecdocDB + '].[DBO].[TD_PICTS] pp ' +
        ' WHERE pp.PICT_ID = :PICT_ID ';

      aRecNo := 0;
      aPrevPathPicts := '';
      for aRecNo := 0 to aRecMax - 1 do
      begin
        aQuery.Parameters[0].Value := aStrings[aRecNo];
        aQuery.Open;
        aCurPathPicts := anOutPathPicts + IntToStr(aQuery.Fields[0].AsInteger div 1000) + '\';
        if aPrevPathPicts <> aCurPathPicts then
        begin
          aPrevPathPicts := aCurPathPicts;
          if not DirectoryExists(aCurPathPicts) then
            ForceDirectories(aCurPathPicts);
        end;

        //TBlobField(aQuery.Fields[1]).SaveToFile(aCurPathPicts + aQuery.Fields[0].AsString + '.jpg');
        resizePictsAndSave(aCurPathPicts + aQuery.Fields[0].AsString + '.jpg', TBlobField(aQuery.Fields[1]));
        aQuery.Close;

        if (aRecNo mod 100 = 0) or (aRecNo = aRecMax - 1) then
          UpdateProgress(aRecNo * 100 div aRecMax, 'Экспорт картинок [' + IntToStr(aRecMax) + ']... ' + IntToStr(aRecNo));
        
        if fAborted then
          Exit;
      end;
      
    finally
      aQuery.Free;
      UpdateProgress(0, 'finish');
    end;

  end
  else
    if aParamsF[7] then  
    begin
      anExportOut.SitePathPicts := 'http://www.shate-mag.by/data/service/picts/';
                       
      ExportTableEx(
        aPath + 'picts.csv',
        ' SELECT c.CODE + ''_'' + b.DESCRIPTION CODE_BRAND, c.PICT_ID ' +
        ' FROM [CATALOG] c ' +
        '   LEFT JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
        ' WHERE c.PICT_ID > 0 ' +
        ' ORDER BY c.PICT_ID ',
        ['CODE_BRAND', 'PICT_ID'],
        '',
        True,
        'Экспорт списка картинок',
        ' SELECT Count(*) FROM [CATALOG] WHERE PICT_ID > 0 ',
        anExportOut.GetValuePict
      );
      if fAborted then
        Exit;

      if not fAborted then
      begin
        if aZipEach then
          ZipFile('picts.zip', aPath, ['picts.csv']);
        if aZipAll then
          aZipFiles.Add('picts.csv');
      end;

    // *** картинки (файлы)
      aRecMax := StrToIntDef(
        ExecuteSimpleSelectMS(
          ' SELECT Count(p.PICT_ID) FROM [' + fTecdocDB + '].[DBO].[TD_PICTS] p ' +
          ' WHERE EXISTS ( ' +
          '   SELECT cat.PICT_ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE (cat.PICT_ID = p.PICT_ID) ' +
          ' )',
          []
        ), 0);

      UpdateProgress(0, 'Экспорт картинок [' + IntToStr(aRecMax) + ']... ');

      anOutPathPicts := aPath + 'picts\';
      if not DirectoryExists(anOutPathPicts) then
        ForceDirectories(anOutPathPicts);

      aQuery := TAdoQuery.Create(nil);
      try
        aQuery.Connection := connService;
        aQuery.CursorLocation := clUseServer;
        aQuery.CursorType := ctOpenForwardOnly;
        aQuery.CommandTimeout := 60 * 5;
        aQuery.SQL.Text :=
          ' SELECT p.PICT_ID, p.PICT_DATA FROM [' + fTecdocDB + '].[DBO].[TD_PICTS] p ' +
          ' WHERE EXISTS ( ' +
          '   SELECT cat.PICT_ID FROM [SERVICE].[dbo].[CATALOG] cat WHERE (cat.PICT_ID = p.PICT_ID) ' +
          ' )';
        aQuery.Open;
        aRecNo := 0;
        aPrevPathPicts := '';
        while not aQuery.Eof do
        begin
          aCurPathPicts := anOutPathPicts + IntToStr(aQuery.Fields[0].AsInteger div 1000) + '\';
          if aPrevPathPicts <> aCurPathPicts then
          begin
            aPrevPathPicts := aCurPathPicts;
            if not DirectoryExists(aCurPathPicts) then
              ForceDirectories(aCurPathPicts);
          end;

         // TBlobField(aQuery.Fields[1]).SaveToFile(aCurPathPicts + aQuery.Fields[0].AsString + '.jpg');
          resizePictsAndSave(aCurPathPicts + aQuery.Fields[0].AsString + '.jpg', TBlobField(aQuery.Fields[1]));
          aQuery.Next;
          Inc(aRecNo);

          if (aRecNo mod 100 = 0) or (aQuery.Eof) then
            UpdateProgress(aRecNo * 100 div aRecMax, 'Экспорт картинок [' + IntToStr(aRecMax) + ']... ' + IntToStr(aRecNo));

          if fAborted then
            Exit;
        end;
        aQuery.Close;
      finally
        aQuery.Free;
        UpdateProgress(0, 'finish');
      end;
    end;

  //* упаковка ********************//


  aStrings.Clear;
  aStrings.Add(fBuildInfo.Version + '.1');
  aStrings.Add(IntToStr(fBuildInfo.Num));
  aStrings.SaveToFile(aPath + '0');
  
  if aZipAll then
  begin
  
    aZipFilesAr := nil;
    for i := 0 to aZipFiles.Count - 1 do
    begin
      SetLength(aZipFilesAr, Length(aZipFilesAr) + 1);
      aZipFilesAr[High(aZipFilesAr)] := aZipFiles[i];
    end;

    SetLength(aZipFilesAr, Length(aZipFilesAr) + 1);
    aZipFilesAr[High(aZipFilesAr)] := '0';
    
    SetLength(aZipFilesAr, Length(aZipFilesAr) + 1);
    aZipFilesAr[High(aZipFilesAr)] := 'picts\*.*';
    
    ZipFile(aZipAllFileName, aPath, aZipFilesAr, True);
    aZipFilesAr := nil;
  end;

finally
  aZipFiles.Free;
  anExportOut.Free;
end;


{ *** для shate-m.by ***

10:19] имяПроцесса_дата_порядковыйНомер.zip

analogsadd_18.10.2012_1.zip внутри 1 файл добавления аналогов
analogsdel_18.10.2012_1.zip внутри 1 файл удаления аналогов
analogs_18.10.2012_1.zip внутри 1 файл полной замены аналогов

oeadd_18.10.2012_1.zip внутри 1 файл добавления аналогов
oedel_18.10.2012_1.zip внутри 1 файл удаления аналогов
oe_18.10.2012_1.zip внутри 1 файл полной замены аналогов

имя файла внутри архива может быть любым

[10:19] во втором случае не аналогов а ое

}

end;





//выгрузка картинок для NAV
procedure TFormMain.miMakePictsNavClick(Sender: TObject);

  function IsJP2Image(aStream: TStream): Boolean;
  var
    aBuf: array[0..7] of Char;
  begin
    aStream.Position := 16;
    aStream.Read(aBuf, 7);
    aBuf[7] := #0;
    Result := StrPas(aBuf) = 'ftypjp2';
  end;

var
  aNavConnection: TAdoConnection;
  aNavQuery: TAdoQuery;
  
  function GetNavPartId(const aCode, aBrand: string): Integer;
  begin
    Result := 0;
    //query to NAV
    
    aNavQuery.SQL.Text :=
      ' SELECT i.[Part ID] ' +
      ' FROM  [Shate-M$Item] i ' +
      '   inner join tm t on i.[TM Code] = t.[Trade Mark Code] ' +
      ' WHERE i.[No_ 2] = :CODE and t.[Trade Mark Name] = :BRAND ';
    aNavQuery.Prepared := True;
    aNavQuery.Parameters[0].Value := aCode;
    aNavQuery.Parameters[1].Value := aBrand;
    aNavQuery.Open;
    if not aNavQuery.Eof then
      Result := aNavQuery.Fields[0].AsInteger;
    aNavQuery.Close;  
  end;
  
var
  aRecNo, aRecMax: Integer;
  aPath, aPrevPathPicts, aCurPathPicts, anOutPathPicts, aCurFileName: string;
  aQuery: TAdoQuery;
  aStream: TMemoryStream;
  ext: string;
  si: TSingleImage;
  bm: TBitmap;
  aPicW, aPicH, aNewW, aNewH: Integer;
  aPartId, aLastCatId: Integer;
begin
// *** картинки (файлы)
  aRecMax := StrToIntDef(
    ExecuteSimpleSelectMS(
      ' SELECT Count(*) FROM [CATALOG] WHERE PICT_ID > 0 ',
      []
    ), 0);

  UpdateProgress(0, 'Экспорт картинок [' + IntToStr(aRecMax) + ']... ');

  aPath := GetAppDir;
  anOutPathPicts := aPath + 'picts\';
  if not DirectoryExists(anOutPathPicts) then
    ForceDirectories(anOutPathPicts);


  aNavConnection := TAdoConnection.Create(nil);
  aNavQuery := TAdoQuery.Create(nil);
  aQuery := TAdoQuery.Create(nil);
  aStream := TMemoryStream.Create;
  try
    //NAV
    aNavConnection.ConnectionString := 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=Shate-M;Data Source=svbyminssq1';
    aNavConnection.LoginPrompt := False;
    aNavConnection.Connected := True;
    
    aNavQuery.Connection := aNavConnection;
    aNavQuery.CursorLocation := clUseClient;
    aNavQuery.CursorType := ctStatic;

    aNavQuery.Close;
    aNavQuery.SQL.Text := ' EXEC [sp_setapprole] ''$ndo$shadow'', ''FF5EC4E40F67BD4EDF3D04F8B84364DAD0'', ''none'', 0, 0 ';
    aNavQuery.ExecSQL;
    

  
    //SERVICE
    aQuery.Connection := connService;
    aQuery.CursorLocation := clUseClient;
    aQuery.CursorType := ctStatic;
    aQuery.CommandTimeout := 60 * 5;
      
    aRecNo := 0;
    aLastCatId := 0;
    aPrevPathPicts := '';
    while True do    
    begin
//      ShowMessage(aQuery.Connection.ConnectionString);
      aQuery.SQL.Text :=
        ' SELECT TOP 10000 c.CODE, b.DESCRIPTION BRAND, c.CAT_ID, p.PICT_DATA, c.No_ ' +
        ' FROM [CATALOG] c ' +
        '   INNER JOIN [BRANDS] b ON (b.BRAND_ID = c.BRAND_ID) ' +
        '   INNER JOIN [' + fTecdocDB + '].[DBO].[TD_PICTS] p on (p.PICT_ID = c.PICT_ID) ' +
        ' WHERE c.PICT_ID > 0 AND c.CAT_ID > ' + IntToStr(aLastCatId) +
        ' ORDER BY c.CAT_ID ';
      aQuery.Open;
      if aQuery.Eof then
        Break;


      while not aQuery.Eof do
      begin
        Inc(aRecNo);
        if (aRecNo mod 10 = 0) or (aQuery.Eof) then
          UpdateProgress(aRecNo * 100 div aRecMax, 'Экспорт картинок [' + IntToStr(aRecMax) + ']... ' + IntToStr(aRecNo));


        aLastCatId := aQuery.Fields[2].AsInteger;
        aPartId := aQuery.Fields[4].AsInteger;
        //GetNavPartId(aQuery.Fields[0].AsString, aQuery.Fields[1].AsString);
        if aPartId = 0 then
        begin
          aQuery.Next;
          Continue;
        end;

        aCurPathPicts := anOutPathPicts + IntToStr(aPartId div 10000) + '\';
        if aPrevPathPicts <> aCurPathPicts then
        begin
          aPrevPathPicts := aCurPathPicts;
          if not DirectoryExists(aCurPathPicts) then
            ForceDirectories(aCurPathPicts);
        end;
        aCurFileName := aCurPathPicts + IntToStr(aPartId) + '_1.JPG';
        if FileExists(aCurFileName) then
        begin
          aQuery.Next;
          Continue;
        end;


        try
          aStream.Clear;
          TBlobField(aQuery.Fields[3]).SaveToStream(aStream);
          aStream.Position := 0;
          if DetermineStreamFormat(aStream) <> '' then
          begin
            si := TSingleImage.CreateFromStream(aStream);
            try
              aPicW := si.Width;
              aPicH := si.Height;
              if (si.Width > 600) or (si.Height > 600) then
              begin
                if aPicW > aPicH then
                begin
                  aNewW := 600;
                  aNewH := Round( aPicH * (aNewW/aPicW) );
                end
                else
                begin
                  aNewH := 600;
                  aNewW := Round( aPicW * (aNewH/aPicH) );
                end;

                si.Resize(aNewW, aNewH, rfBicubic);
              end;

              si.SaveToFile(aCurFileName);
            finally
              si.Free;
            end;
          end;
        except
          on E: Exception do
            MemoLog.Lines.Add(aQuery.Fields[0].AsString + '_' + aQuery.Fields[1].AsString + ' - !Exception: ' + E.Message)
        end;


          //Convert to JPG
          //Resize
          //Save

        //TBlobField(aQuery.Fields[1]).SaveToFile(aCurPathPicts + aQuery.Fields[0].AsString + '.jpg');



        aQuery.Next;

        if fAborted then
          Exit;
      end;
      aQuery.Close;
    end; //while True do

    aNavConnection.Close;

{    with Zipper do
    begin
      RootDir := IncludeTrailingPathDelimiter(anOutDir);
      ZipName := anOutDir + 'picts_d' + fBuildInfo.Version + '.1.zip';
      Password := 'shatem+' + '-' + fBuildInfo.Version + '.1';

      if FileExists(ZipName) then
        SysUtils.DeleteFile(ZipName);

      FilesList.Clear;
      FilesList.Add(anOutDirPicts + '*.*');
      FilesList.Add(anOutDir + 'picts.csv');
      FilesList.Add(anOutDir + '0');
      StorePaths := True;
      RelativePaths := True;
      Zip;
    end;}

  finally
    aStream.Free;
    aQuery.Free;
    aNavQuery.Free;
    aNavConnection.Free;
    UpdateProgress(0, 'finish');
  end;
end;


procedure TFormMain.miMakePictsPortalClick(Sender: TObject);
var
  anOutDir, anOutDirPicts, aCurPathPicts, aCurFileName, aPrevPathPicts: string;
  aQuery: TAdoQuery;
  aReader: TCSVReader;
  slVersions: TStrings;

  aStream: TMemoryStream;
  ext: string;
  si: TSingleImage;
  bm: TBitmap;
  aPicW, aPicH, aNewW, aNewH: Integer;
  aPartId, aLastCatId: Integer;
begin
  aStream := TMemoryStream.Create;
  anOutDir := GetAppDir + 'Update\';
  if not DirectoryExists(anOutDir) then
    ForceDirectories(anOutDir);

  anOutDirPicts := anOutDir + 'Picts4Portal\';
  if not DirectoryExists(anOutDirPicts) then
    ForceDirectories(anOutDirPicts);

  fReleasePrefix := fBuildInfo.ParentVersion;
  fUseRelease := fReleasePrefix <> '';
  if fUseRelease then
    fReleasePrefix := fReleasePrefix + '_';

  DeleteFile(anOutDir + 'pictsPortal.csv');

  UpdateProgress(0, 'Очистка целевой директории...');
  EraseDirFiles(anOutDirPicts, False);

  //новые
  ExportTableEx(
    anOutDir + 'pictsPortal.csv',
    ' SELECT p.PICT_ID, c.No_ FROM [PICTS] p ' +
    ' LEFT JOIN [SERVICE].[dbo].[CATALOG] c ON (p.[PICT_ID] = c.[PICT_ID]) ' +
    ' WHERE NOT EXISTS (SELECT pc.ID FROM [' + fReleasePrefix + 'PICTS] pc WHERE (p.PICT_ID = pc.PICT_ID)) ',
    ['PICT_ID', 'NO_'],
    '0',
    True,
    'Экспорт списка картинок (новые)',
    ' SELECT Count(p.PICT_ID) FROM [PICTS] p ' +
    ' LEFT JOIN [SERVICE].[dbo].[CATALOG] c ON (p.[PICT_ID] = c.[PICT_ID]) ' +
    ' WHERE NOT EXISTS (SELECT pc.ID FROM [' + fReleasePrefix + 'PICTS] pc WHERE (p.PICT_ID = pc.PICT_ID))'
  );

  //плюс измененные
  ExportTableEx(
    anOutDir + 'pictsPortal.csv',
    ' SELECT p.PICT_ID, c.No_ FROM [PICTS] p ' +
    ' INNER JOIN [' + fReleasePrefix + 'PICTS] pc ON (p.PICT_ID = pc.PICT_ID and p.HASH <> pc.HASH) ' +
    ' LEFT JOIN [SERVICE].[dbo].[CATALOG] c ON (p.[PICT_ID] = c.[PICT_ID]) ' ,
    ['PICT_ID', 'NO_'],
    '0',
    False, //дописать
    'Экспорт списка картинок (измененные)',
    ' SELECT Count(p.PICT_ID) FROM [PICTS] p ' +
    ' INNER JOIN [' + fReleasePrefix + 'PICTS] pc ON (p.PICT_ID = pc.PICT_ID and p.HASH <> pc.HASH) ' + 
    ' LEFT JOIN [SERVICE].[dbo].[CATALOG] c ON (p.[PICT_ID] = c.[PICT_ID]) '
  );


  //----------------------------------------------------------------------------
  UpdateProgress(0, 'Экспорт картинок... ');

  aQuery := TAdoQuery.Create(nil);
  aQuery.DisableControls;
  aQuery.Connection := connService;
//  aQuery.CursorLocation := clUseServer;
//  aQuery.CursorType := ctOpenForwardOnly;
  aQuery.CommandTimeout := 60 * 5;
  aQuery.SQL.Text :=
    ' SELECT p.PICT_ID, p.PICT_DATA FROM [' + fTecdocDB + '].[DBO].[TD_PICTS] p ' +
    ' WHERE p.PICT_ID = :PICT_ID ';
  aQuery.Prepared := True;

  aPrevPathPicts := '';
  aReader := TCSVReader.Create;
  try
    aReader.Open(anOutDir + 'pictsPortal.csv');

    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      if aReader.LineNum mod 50 = 0 then
        UpdateProgress(aReader.FilePosPercent, 'Экспорт картинок... ' + IntToStr(aReader.LineNum));
      if fAborted then
        Break;

      aQuery.Parameters[0].Value := aReader.Fields[0];
      aPartId := StrToIntDef(aReader.Fields[1],0);
      
      aQuery.Open;
      while not aQuery.Eof do //begin
      begin
        if aPartId = 0 then
        begin
          aQuery.Next;
          Continue;
        end;

        aCurPathPicts := anOutDirPicts + IntToStr(aPartId div 10000) + '\';
        if aPrevPathPicts <> aCurPathPicts then
        begin
          aPrevPathPicts := aCurPathPicts;
          if not DirectoryExists(aCurPathPicts) then
            ForceDirectories(aCurPathPicts);
        end;

        aCurFileName := aCurPathPicts + IntToStr(aPartId) + '_1.JPG';
        if FileExists(aCurFileName) then
        begin
          aQuery.Next;
          Continue;
        end;

        try
          aStream.Clear;
          TBlobField(aQuery.Fields[1]).SaveToStream(aStream);
          aStream.Position := 0;
          if DetermineStreamFormat(aStream) <> '' then
          begin
            si := TSingleImage.CreateFromStream(aStream);
            try
              aPicW := si.Width;
              aPicH := si.Height;
              if (si.Width > 600) or (si.Height > 600) then
              begin
                if aPicW > aPicH then
                begin
                  aNewW := 600;
                  aNewH := Round( aPicH * (aNewW/aPicW) );
                end
                else
                begin
                  aNewH := 600;
                  aNewW := Round( aPicW * (aNewH/aPicH) );
                end;

                si.Resize(aNewW, aNewH, rfBicubic);
              end;

              si.SaveToFile(aCurFileName);
            finally
              si.Free;
            end;
          end;
          aQuery.Next;
        except
          on E: Exception do
            MemoLog.Lines.Add( 'FAIL PICT_ID -> '+ aReader.Fields[0] +  ' - !Exception: ' + E.Message)
        end;
        //TBlobField(aQuery.Fields[1]).SaveToFile(anOutDirPicts + aQuery.Fields[0].AsString + '.jpg');
      end;
      aQuery.Close;
  end;

  finally
    aReader.Free;
    aQuery.Free;
    aStream.Free;
    UpdateProgress(0, 'finish');
  end;

  UpdateProgress(0, 'Упаковка...');
  slVersions := TStringList.Create;
  slVersions.Add(fBuildInfo.Version + '.1');
  slVersions.Add(IntToStr(fBuildInfo.Num));
  slVersions.SaveToFile(anOutDir + '0');
  slVersions.Free;

  with Zipper do
  begin
    RootDir := IncludeTrailingPathDelimiter(anOutDir);
    ZipName := anOutDir + 'picts_B2B_d' + fBuildInfo.Version + '.1.zip';
//    Password := 'shatem+' + '-' + fBuildInfo.Version + '.1';

    if FileExists(ZipName) then
      SysUtils.DeleteFile(ZipName);

    FilesList.Clear;
    FilesList.Add(anOutDirPicts + '*.*');
    FilesList.Add(anOutDir + 'pictsPortal.csv');
    FilesList.Add(anOutDir + '0');
    StorePaths := True;
    RelativePaths := True;
    Zip;
  end;

  UpdateProgress(0, 'finish');

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


(*
USE [SERVICE]
GO
/****** Object:  Table [dbo].[BUILDS]    Script Date: 09/25/2011 21:28:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BUILDS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[VERSION] [varchar](20) NULL,
	[NUM] [int] NULL,
	[PARENT_VER] [varchar](20) NULL,
	[NOTE] [varchar](250) NULL,
	[LOGS] [text] NULL,
	[ISCUR] [smallint] NOT NULL CONSTRAINT [DF_BUILDS_ISCUR]  DEFAULT ((0)),
 CONSTRAINT [PK_BUILDS] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF





insert into [limits] (car_id, cat_id, name)
SELECT dt.TYP_ID, c.CAT_ID, p.DESCRIPTION + '=' + dt.PARAM_VALUE PARAM
FROM [' + fTecdocDB + '].[DBO].[TD_DETAILS_TYP] dt
   LEFT JOIN [' + fTecdocDB + '].[DBO].[TD_PARAMS] p on (p.PARAM_ID = dt.PARAM_ID)
   inner join [service].[dbo].[catalog] c on (c.typ_tdid = dt.art_id)

*)


{
//обрезание лога
Backup log [service] with truncate_only;
DBCC SHRINKFILE(SERVICE_LOG, 10)

//restore из сети
RESTORE DATABASE TECDOC2014
from DISK='\\VBOXSVR\Backup\TECDOC2014.bak'
WITH RECOVERY,
MOVE 'TECDOC2014' TO 'C:\DB\TECDOC2014.MDF',
MOVE 'TECDOC2014_LOG' TO 'C:\DB\TECDOC2014_LOG.LDF'
}
