unit _Updater;

interface

uses
  Windows, Classes, SysUtils, dbisamtb, VCLUnZip;

const
  cUpdateErrorsLogFile = 'UpdateErrs.log';
  cVersionFileName = '0'; //имя файла с версиями внутри пакета

  cERR_REQUIRED_PACKAGE_NEED = 'Не установлено необходимое для этого пакета обновление';
  cERR_REQUIRED_FILE_NOT_FOUND = 'Не найден необходимый файл в пакете';
  cERR_UNPACK = 'Ошибка распаковки пакета';
  cERR_VERSION_NOT_FOUND = 'Неизвестная версия пакета, установка невозможна';

type
  TUpdateResult = (
    urFail,
    urFully,
    urPartially,
    urAborted
  );

  TUpdatePackageType = (
    wupUnknown,
    wupData,
    wupDataDiscret,
    wupNews,
    wupQuants,

    wupPictsDiscret,
    wupTyp,
    wupTires
  );

  TUpdatePackageTypeSet = set of TUpdatePackageType;

const
  cWebUpdateTypeCodes: array[TUpdatePackageType] of string = (
    '?unknown?',
    'data',
    'data_d',
    'news',
    'quants',

    'picts_d',
    'typ_d',
    'tires'
  );

  cWebUpdateTypeDescr: array[TUpdatePackageType] of string = (
    '?нераспознанный пакет?',
    'Пакет обновления - данные',
    'Пакет обновления - данные(частичное)',
    'Пакет обновления - новости',
    'Пакет обновления - остатки и цены',

    'Пакет обновления - картинки(частичное)', {new}
    'Пакет обновления - применяемость',
    'Пакет обновления - шины'
  );

  //обязательность версии для каждого типа пакета (defaults)
  cWebUpdateTypeVersionRequired: array[TUpdatePackageType] of Boolean = (
    False,  //wupUnknown
    True,   //wupData
    True,   //wupDataDiscret
    False,  //wupNews
    False,  //wupQuants

    True,    //wupPictsDiscret
    False,   //wupTyp
    False     //wupTires
  );

type
  TUpdateQueueItem = class; //определен ниже
  TUpdateQueue = class; //определен ниже

  //ошибка при обновлении - возбуждать если ошибка известна
  //и ее можно показать пользователю (перехватчик положит ее в код завершения пакета и запишет в лог),
  //иначе возбуждать любой другой класс Exception (он будет записан только в лог)
  EUpdateException = class(Exception)
  private
    fErrCode: Integer;
  public
    constructor Create(aErrCode: Integer; const aMessage: string);

    //можно использовать для анализа в основном потоке,
    //будет записан перехватчиком в TUpdateQueueItem.UpdateResultCode
    property ErrorCode: Integer read fErrCode;
  end;

  ESQLException = class(Exception)
  private
    fSQL: string;
  public
    constructor Create(const aSQL: string; const aMessage: string);

    property SQL: string read fSQL;
  end;

  //проводит обновление (непосредственно импорт в БД)
  TUpdateDataThrd = class(TThread)
  private
    //переданные настройки
    fOwnerHandle: HWnd;
    fTmpPath: string;
    fUnZipper: TVCLUnZip;

    fInitialized: Boolean;
    fQueue: TUpdateQueue; //очередь пакетов обновлений
    fUpdateResult: TUpdateResult;
    fErrorMsg: string;
    fErrorLogEnabled: Boolean;

    //progress
    fCurProgress: Integer;
    fPrevProgress: Integer;
    fProgressMessage: string;

    //DBISAM components (for thread-safe work)
    fLocalSession: TDBISAMSession;
    fLocalDatabase: TDBISAMDatabase;

    fLockUpdateTecdoc: Boolean; //блокировка обновлений ссылок на тикдок и данных тикдока

    procedure CallProgress(aPos: Integer);
    procedure SetPosProgress;
    procedure ShowProgressBase;
    procedure HideProgressBase;
    procedure CurrProgressBase;

    //распаковка
    function Unpack(const aSourceZip, aDestDir, aPassword: string): Boolean;
    procedure UnpackProgress(Sender: TObject; Percent: Integer);
    procedure QueryProgress(Sender: TObject; PercentDone: Word; var Abort: Boolean);
    function CheckVersionFileFound(const aSourceZip: string): Boolean;

    procedure ArtTypIndexProgress(Sender: TObject; PercentDone: Word);

    function InstallPackage(aPackage: TUpdateQueueItem): Boolean;

    //установка пакетов каждого типа
    function DoInstall_Data: Boolean;
    function DoInstall_DataDiscret: Boolean;
    function DoInstall_News: Boolean;
    function DoInstall_Quants: Boolean;
    function DoInstall_PictsDiscret: Boolean;
    function DoInstall_Tires: Boolean;
    function DoInstall_Typ: Boolean;

    procedure LogError(const aError: string; aClearLog: Boolean = False);
//    function WebUpdateExecute: Integer;
//    function DiskUpdateExecute: Integer;

    function DoImportBase(Path: string = ''): Boolean;
    procedure ImportTableBase(tbl: TDBISAMTable; fname, info: string; flds: string = '');
    procedure ImportDescriptionTable(Table: TDBISAMTable; const aFileName: string);
    procedure TableExpImpProgress(Sender: TObject; PercentDone: Word);
//    procedure LoadPrimenMemo(tbl: TDBISAMTable);
    procedure LoadFullPrimen(const aFileName: string; aDestTable: TDBISamTable);
    function DoUpdate(Path: string = ''): Boolean;

    function DoUpdateQuantsNew(const aPath: string): Boolean;

    function DoUpdatePictsDiscret(const aPath: string): Boolean;
    function DoUpdateTires(const aPath: string): Boolean;
    function DoUpdateTyp(const aPath: string): Boolean;


    procedure makeTableForUpdate(anUpdateTable, aSourceTable: TDBISAMTable);
    procedure ExecQuery(const aSql: string; aQuery: TDBISAMQuery; aShowProgress: Boolean = False);
    procedure ExecQuerySafe(const aSql: string; aShowProgress: Boolean = False);
    function  makeSafeTable(const aTableName: string): TDBISAMTable;
    function  makeSafeQuery: TDBISamQuery;
    procedure makeSafeDBISAMData;
    procedure CopyTableBase(const aTableName, aNewTableName: string);

    function  GetTableSize(const aTableName: string): Int64;
    procedure CheckFreeSpaceForUpdate(const aTableNames: array of string);

  protected
    procedure Execute; override;

  public
    constructor Create(aOwnerHandle: HWND);
    destructor Destroy; override;
    procedure Init(aQueue: TUpdateQueue; const aTempPath: string);

    property OwnerHandle: HWND read fOwnerHandle;
    property UpdateResult: TUpdateResult read fUpdateResult;
    property ErrorMessage: string read fErrorMsg;
    property ErrorLogEnabled: Boolean read fErrorLogEnabled write fErrorLogEnabled;

    property TmpPath: string read fTmpPath;
  end;


  //очередь(сценарий) обновления (список TUpdateQueueItem)
  TUpdateQueue = class
  private
    fList: TList;
    FCurrentItem: TUpdateQueueItem;

    function GetItems(Index: Integer): TUpdateQueueItem;
    function GetCount: Integer;
    function FindPackageByType(aUpdateType: TUpdatePackageType): Integer{Index}; //поиск пакета заданного типа
  private
  public
    constructor Create;
    destructor Destroy; override;
    function ContainsPackage(aUpdateType: TUpdatePackageType): Boolean; //содержит пакет заданного типа
    function PackageInstalled(aUpdateType: TUpdatePackageType): Boolean;//проинсталлирован пакет заданного типа

    procedure Clear;
    function Add(aItem: TUpdateQueueItem): Integer; overload;
    function Add: TUpdateQueueItem; overload;
    procedure Delete(aIndex: Integer);

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TUpdateQueueItem read GetItems; default;
    property CurrentItem: TUpdateQueueItem read FCurrentItem;
  end;

  //описавает пакет обновления
  TUpdateQueueItem = class
  private
    fOwner: TUpdateQueue;

    fPackageDescription: string; //описание пакета
    fPackageType: TUpdatePackageType; //тип обновления (распознается по коду fPackageTypeCode)
    fPackageTypeCode: string;    //код типа обновления (data, data_d, news, quants)
    fNewVersions: TStrings;      //инфа о новых версиях
    fZipFile: string;            //Zip-файл с данными пакета
    fVersionsInside: Boolean;    //версии должны быть считаны после распаковки из файла '0'

    fUpdateInProgress: Boolean;  //пакет сейчас устанавливается
    fTryInstalled: Boolean;      //пакет начинал установку
    fInstalled: Boolean;         //результат обновления OK/ERR
    fUpdateResultCode: Integer;  //результат обновления (код завершения)
    fUpdateError: string;        //текст ошибки при обновлении, если была
    fRequires: TUpdatePackageTypeSet;//типы пакетов кот. должны быть установлены перед этим
    fGetVersionRequiredAsDef: Boolean;

    procedure SetPackageTypeCode(const Value: string);
    procedure SetPackageType(const Value: TUpdatePackageType);
    function GetPackageDescription: string;
    procedure SetPackageDescription(const Value: string);
  private
    fVersionsRequired: Boolean;
    procedure UpdateRequires; //пересчитать зависимости этого пакета
    function GetVersionsRequired: Boolean;
    procedure SetVersionsRequired(const Value: Boolean);
  protected
    function CheckRequiresInstalled: Boolean; //проверяет что необходимые пакеты установлены
    //связка начало/конец установки - управляют флагами состояния
    procedure BeginInstall;
    procedure EndInstall;

    //пока не используется извне, если нужно - перенести в public секцию
    property UpdateInProgress: Boolean read fUpdateInProgress; //пакет сейчас устанавливается
    property TryInstalled: Boolean read fTryInstalled;         //установка пакета начиналась
  public
    constructor Create(aOwner: TUpdateQueue);
    destructor Destroy; override;

    property PackageDescription: string read GetPackageDescription write SetPackageDescription;
    property PackageTypeCode: string read fPackageTypeCode write SetPackageTypeCode;
    property PackageType: TUpdatePackageType read fPackageType write SetPackageType;
    property NewVersions: TStrings read fNewVersions;
    property VersionsInside: Boolean read fVersionsInside write fVersionsInside;
    property VersionsRequired: Boolean read GetVersionsRequired write SetVersionsRequired;
    property ZipFile: string read fZipFile write fZipFile;
    property Requires: TUpdatePackageTypeSet read fRequires;

    property Installed: Boolean read fInstalled;
    property UpdateResultCode: Integer read fUpdateResultCode;
    property UpdateError: string read fUpdateError;
  end;


{ Global }

//распознает тип файла обновления по строковому коду
function RecognizeWebUpdateType(const aCode: string): TUpdatePackageType;

//возбуждает исключение EUpdateException (служит для удобства использования)
procedure raiseUpdateErr(const aMessage: string; aErrCode: Integer = 0);

implementation

uses
  _Main, _Data, _CSVReader, BSDbiUt, BSStrUt, AdvOfficeStatusBar, kpZipObj,
  Variants, DB;

  
{ Global }

function RecognizeWebUpdateType(const aCode: string): TUpdatePackageType;
begin
  for Result := wupData to High(TUpdatePackageType) do
    if SameText(cWebUpdateTypeCodes[Result], aCode) then
      Exit;

  Result := wupUnknown;
end;

procedure raiseUpdateErr(const aMessage: string; aErrCode: Integer);
begin
  raise EUpdateException.Create(aErrCode, aMessage);
end;

//возвращает позицию в процентах (для прогресса)
function GetPercent(aPos, aMax: Cardinal): Integer;
begin
  if aMax = 0 then
    Result := 100
  else
    Result := (aPos * 100) div aMax;
end;


{ EUpdateException }

constructor EUpdateException.Create(aErrCode: Integer; const aMessage: string);
begin
  inherited Create(aMessage);
  fErrCode := aErrCode;
end;

{ ESQLException }
constructor ESQLException.Create(const aSQL, aMessage: string);
begin
  inherited Create(aMessage);
  fSQL := aSQL;
end;


{ TUpdateDataThrd }

{создаем по-умолчанию приостановленный, саморазрушаемый, с низким приоритетом}
constructor TUpdateDataThrd.Create(aOwnerHandle: HWND);
begin
  inherited Create(True{CreateSuspended});
  Self.Priority := tpLowest;
  Self.FreeOnTerminate := True;

  fOwnerHandle := aOwnerHandle;
  fErrorLogEnabled := True;

  fUnZipper := TVCLUnZip.Create(nil);
  fUnZipper.DoProcessMessages := False; //в потоке не нужен Application.ProcessMessages
  fUnZipper.RecreateDirs := True;
  fUnZipper.OverwriteMode := Always;
  fUnZipper.OnTotalPercentDone := UnpackProgress;

  makeSafeDBISAMData;

//  fLockUpdateTecdoc := True; //!debug test!
end;

destructor TUpdateDataThrd.Destroy;
begin
  fUnZipper.Free;
  fLocalSession.Free;
  fLocalDatabase.Free;

  inherited;
end;

//OK
procedure TUpdateDataThrd.LoadFullPrimen(const aFileName: string;
  aDestTable: TDBISamTable);

const
  cBufSize = 1024 * 8; //8 Kb

var
  aStream: TMemoryStream;
  aType, anArt: Integer;
  aFirst: Boolean;
begin
  fProgressMessage := 'Загрузка применяемости...';
  Synchronize(ShowProgressBase);

  aFirst := True;
//  aStream := TFileStream.Create(aFileName, fmOpenRead);
  aStream := TMemoryStream.Create;
  aStream.LoadFromFile(aFileName);
  aStream.Position := 0;
  try
    aDestTable.Exclusive := True;
    aDestTable.Open;
    while aStream.Position < aStream.Size do
    begin
      if Terminated then
        Abort;

      if aFirst then
      begin
        aStream.Read(aType, SizeOf(Integer));
        aFirst := False;
      end;
      aStream.Read(anArt, SizeOf(Integer));

      if anArt <> -1 then
      begin
        aDestTable.Append;
        aDestTable.FieldByName('TYP_ID').AsInteger := aType;
        aDestTable.FieldByName('ART_ID').AsInteger := anArt;
        aDestTable.Post;
      end
      else
        aFirst := True;

      CallProgress(GetPercent(aStream.Position, aStream.Size));
    end;
    aDestTable.Close;
    aDestTable.Exclusive := False;
  finally
    aStream.Free;
  end;

  Synchronize(HideProgressBase);
end;

{procedure TUpdateDataThrd.LoadPrimenMemo(tbl: TDBISAMTable);
var
  s: string;
  UpdateTable: TDBISAMTable;
begin
  UpdateTable := TDBISAMTable.Create(nil);
  try
    UpdateTable.TableName := Data.CatalogTable.TableName + '_New';
    UpdateTable.DatabaseName := fLocalDatabase.DatabaseName;

    Data.LoadArtTypTable.Open;
    fProgressMessage := 'Загрузка применяемости в каталог...';
    Synchronize(ShowProgressBase);

    tbl.Open;
    with UpdateTable do
    begin
      Open;
      First;
      while not Eof do
      begin
        if Terminated then //check terminated
          Abort;

        if (FieldByName('typ_tdid').AsInteger <> 0) and (FieldByName('Primen').AsString = '') then
        begin
          s := '';
          with Data.LoadArtTypTable do
          begin
            SetRange([UpdateTable.FieldByName('typ_tdid').AsInteger], [UpdateTable.FieldByName('typ_tdid').AsInteger]);
            First;
            while not Eof do
            begin
              if tbl.Locate('Type_ID', Data.LoadArtTypTable.FieldByName('Typ_id').AsInteger, []) then
              begin
                s := s + Data.LoadArtTypTable.FieldByName('Typ_id').AsString + ',';
                tbl.Edit;
                if tbl.FieldByName('Cat_ID').AsString <> '' then
                  tbl.FieldByName('Cat_ID').AsString:= tbl.FieldByName('Cat_ID').AsString +','+ UpdateTable.FieldByName('Cat_ID').AsString
                else
                  tbl.FieldByName('Cat_ID').AsString:= UpdateTable.FieldByName('Cat_ID').AsString;
                tbl.Post;
              end;
              Next;
            end;
            CancelRange;
            UpdateTable.Edit;
            UpdateTable.FieldByName('Primen').Value := s;
            UpdateTable.Post;
          end;
        end;

        CallProgress( GetPercent(RecNo, RecordCount) );
        Next;
      end;
    end;

    UpdateTable.Close;
    tbl.Close;
    Data.LoadArtTypTable.Close;
  finally
    UpdateTable.Free;
  end;
end;     }

procedure TUpdateDataThrd.LogError(const aError: string; aClearLog: Boolean);
var
  fLogFile: TextFile;
begin
{$I-} //отключаем I/O exceptions
  if fErrorLogEnabled then
  begin
    AssignFile(fLogFile, GetAppDir + cUpdateErrorsLogFile);
    if aClearLog or not FileExists(GetAppDir + cUpdateErrorsLogFile) then
      Rewrite(fLogFile)
    else
      Append(fLogFile);
    Writeln(fLogFile, aError);
    CloseFile(fLogFile);
  end;
{$I+}
end;

//OK
procedure TUpdateDataThrd.TableExpImpProgress(Sender: TObject; PercentDone: Word);
begin
  if Terminated then
    Abort;
  CallProgress(PercentDone);
end;


procedure TUpdateDataThrd.ImportDescriptionTable(Table: TDBISAMTable; const aFileName: string);//импорт!
var
  descr: string;
  aReader: TCSVReader;
begin
  aReader := TCSVReader.Create;
  Table.Open;
  try
    fProgressMessage := 'Загрузка текстовых описаний...';
    Synchronize(ShowProgressBase);
    aReader.Open(aFileName);
    while not aReader.Eof do
    begin
      aReader.ReturnLine;
      Table.Append;
      Table.FieldByName('ID').asString := aReader.Fields[0];
      Table.FieldByName('CAT_ID').asString := aReader.Fields[1];
      descr := aReader.Fields[2];
      descr := StringReplace(descr,'~13',#13,[rfReplaceAll]);
      descr := StringReplace(descr,'~59',';',[rfReplaceAll]);
      Table.FieldByName('Description').asString :=descr;
      Table.Post;
      CallProgress(aReader.FilePosPercent);
    end;
  finally
    aReader.Free;
    Synchronize(HideProgressBase);
  end;
end;

procedure TUpdateDataThrd.ImportTableBase(tbl: TDBISAMTable; fname, info: string; flds: string = '');
var
  fld_list: TStringList;
  i: Integer;
  s: string;
begin
  fProgressMessage := info;
  tbl.OnImportProgress := TableExpImpProgress;
  Synchronize(ShowProgressBase);
  tbl.EmptyTable;
  fld_list := TStringList.Create;
  try
    //exception raised when tbl.ImportTable process empty file
    if GetFileSize_Internal(fname) = 0 then
      Exit;

    if flds <> '' then
    begin
      i := 1;
      while True do
      begin
        s := ExtractDelimited(i,  flds, [';']);
        if s = '' then
          Break;
        fld_list.Add(s);
        Inc(i);
      end;
      tbl.ImportTable(fname, ';', False, fld_list);
    end
    else
      tbl.ImportTable(fname, ';');

  finally
    fld_list.Free;
    Synchronize(HideProgressBase);
    tbl.OnImportProgress := nil;
  end;
end;

procedure TUpdateDataThrd.Init(aQueue: TUpdateQueue; const aTempPath: string);
begin
  fQueue := aQueue;
  fTmpPath := aTempPath;
  fInitialized := True;
end;

procedure TUpdateDataThrd.makeTableForUpdate(anUpdateTable, aSourceTable: TDBISAMTable);
begin
  anUpdateTable.DatabaseName := fLocalDatabase.DatabaseName;
  anUpdateTable.SessionName := fLocalSession.SessionName;
  anUpdateTable.TableName := aSourceTable.TableName + '_New';
  Data.CopyMaketTable(anUpdateTable, aSourceTable);
  TestTable(anUpdateTable);
end;

procedure TUpdateDataThrd.ExecQuery(const aSql: string; aQuery: TDBISAMQuery; aShowProgress: Boolean);
var
  aNeedFreeQuery: Boolean;
  aProgressProc: TAbortProgressEvent;
begin
  if not Assigned(aQuery) then
  begin
    aQuery := TDBISAMQuery.Create(nil);
    aQuery.SessionName := fLocalSession.SessionName;
    aQuery.DatabaseName := fLocalDatabase.DatabaseName;
    aNeedFreeQuery := True;
  end
  else
    aNeedFreeQuery := False;

  try

    try
      aQuery.Close;
      aQuery.SQL.Text := aSql;
      try
        if aShowProgress then
        begin
          aProgressProc := aQuery.OnQueryProgress;
          aQuery.OnQueryProgress := QueryProgress;
        end;
        aQuery.ExecSQL;
      finally
        if aShowProgress then
        begin
          aQuery.OnQueryProgress := aProgressProc;
        end;
      end;
      aQuery.Close;
    except
      on E: Exception do
      begin
        raise ESQLException.Create(aSql, E.Message);
      end;
    end;

  finally
    if aNeedFreeQuery then
      aQuery.Free;
  end;
end;

procedure TUpdateDataThrd.ExecQuerySafe(const aSql: string; aShowProgress: Boolean);
var
  LocalQuery:    TDBISAMQuery;
begin
  fLocalDatabase.Connected := True;
  LocalQuery := TDBISAMQuery.Create(nil);
  try
    LocalQuery.SessionName := fLocalSession.SessionName;
    LocalQuery.DatabaseName := fLocalDatabase.DatabaseName;
    ExecQuery(aSql, LocalQuery, aShowProgress);
  finally
    LocalQuery.Free;
    fLocalDatabase.Connected := False;
  end;
end;

procedure TUpdateDataThrd.makeSafeDBISAMData;
begin
  fLocalSession := TDBISAMSession.Create(nil);
  fLocalSession.SessionName := 'UpdateSession' + IntToStr(GetCurrentThreadId + Random(1000));

  fLocalDatabase := TDBISAMDatabase.Create(nil);
  fLocalDatabase.SessionName := fLocalSession.SessionName;
  fLocalDatabase.DatabaseName := 'UpdateData';
  fLocalDatabase.Directory := Data.Database.Directory;
end;

function TUpdateDataThrd.makeSafeQuery: TDBISamQuery;
begin
  Result := TDBISAMQuery.Create(nil);
  Result.SessionName := fLocalSession.SessionName;
  Result.DatabaseName := fLocalDatabase.DatabaseName;
end;

function TUpdateDataThrd.makeSafeTable(const aTableName: string): TDBISAMTable;
begin
  Result := TDBISAMTable.Create(nil);
  Result.SessionName := fLocalSession.SessionName;
  Result.DatabaseName := fLocalDatabase.DatabaseName;
  Result.TableName := aTableName;
end;



//OK
function TUpdateDataThrd.DoImportBase(Path: string = ''): Boolean;
var
  i: Integer;
  fname, aCatExportFields: string;
  UpdateTable: TDBISAMTable;
begin
  Result := False;
  Data.RemoveTableFromBase(Data.SysParamTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.BrandTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.GroupTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.GroupBrandTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.CatalogTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.OEDescrTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.OEIDTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.TableCarFilter.TableName + '_New');
  Data.RemoveTableFromBase(Data.ArtTypTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.KitTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.OOTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.DescriptionTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.AnalogIDTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.AnalogMainTable_1.TableName + '_New');
  Data.RemoveTableFromBase(Data.AnalogMainTable_2.TableName + '_New');
  Data.RemoveTableFromBase(Data.AnalogMainTable_3.TableName + '_New');
  Data.RemoveTableFromBase(Data.AnalogMainTable_4.TableName + '_New');
  Data.RemoveTableFromBase(Data.AnalogMainTable_5.TableName + '_New');

  Data.RemoveTableFromBase(Data.ManufacturersTable.TableName + '_New');

  //проверить хватит ли места для обновления
  CheckFreeSpaceForUpdate
  (
    [
      Data.SysParamTable.TableName,
      Data.BrandTable.TableName,
      Data.GroupTable.TableName,
      Data.GroupBrandTable.TableName,
      Data.CatalogTable.TableName,
     // Data.AnalogTable.TableName,
     // Data.OETable.TableName,
      Data.OEIDTable.TableName,
      Data.OEDescrTable.TableName,
      
      Data.TableCarFilter.TableName,
      Data.ArtTypTable.TableName,
      Data.KitTable.TableName,
      Data.OOTable.TableName,

      Data.DescriptionTable.TableName,
      Data.AnalogIDTable.TableName,
      Data.AnalogMainTable_1.TableName,
      Data.AnalogMainTable_2.TableName,
      Data.AnalogMainTable_3.TableName,
      Data.AnalogMainTable_4.TableName,
      Data.AnalogMainTable_5.TableName,

      Data.ManufacturersTable.TableName
    ]
  );

  SetCurrentDir(Data.Data_Path);
  fname := Path + 'sys.csv';
  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.SysParamTable);

    if FileExists(fname) then
      ImportTableBase(UpdateTable, fname, 'Загрузка настроек...', SYS_IMPEXP_FIELDS);

    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;

  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.BrandTable);

    fname := Path + 'bra.csv';
    if FileExists(fname) then
      ImportTableBase(UpdateTable, fname, 'Загрузка брендов...', BRA_UP_IMPEXP_FIELDS);

    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;

  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.GroupTable);

    fname := Path + 'gru.csv';
    if FileExists(fname) then
      ImportTableBase(UpdateTable, fname, 'Загрузка групп...', GRU_UP_IMPEXP_FIELDS);

    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;

  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.GroupBrandTable);

    fname := Path + 'grb.csv';
    if FileExists(fname) then
      ImportTableBase(UpdateTable, fname, 'Загрузка дерева классификатора...', GRB_UP_IMPEXP_FIELDS);

    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;

  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.CatalogTable);

    fname := Path + 'cat.csv';
    if FileExists(fname) then
    begin
      aCatExportFields := Data.CatFieldsForExport;

      ImportTableBase(UpdateTable, fname, 'Загрузка каталога...', aCatExportFields);

// !!! -------------------------------------------------------------------------
      fProgressMessage:= 'Обновление записей каталогa...';
      Synchronize(ShowProgressBase);

      if fLockUpdateTecdoc then
      begin
        UpdateTable.Open;
        UpdateTable.First;
        while not UpdateTable.Eof do
        begin
          UpdateTable.Edit;
          UpdateTable.FieldByName('Tecdoc_id').AsInteger := 0;
          UpdateTable.FieldByName('pict_id').AsInteger := 0;
          UpdateTable.FieldByName('typ_tdid').AsInteger := 0;
          UpdateTable.FieldByName('param_tdid').AsInteger := 0;
          UpdateTable.Post;

          UpdateTable.Next;
          CallProgress(UpdateTable.RecNo * 100 div UpdateTable.RecordCount);
        end;
      end;

      Synchronize(HideProgressBase);
//------------------------------------------------------------------------------

    end;
    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;
   
  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.KitTable);

    fname := Path + 'kit.csv';
    if FileExists(fname) then
      ImportTableBase(UpdateTable, fname, 'Загрузка комплектов...', KIT_IMP_FIELDS);

    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;
//>>
{  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.ArtTypTable);

    fname := Path + 'typ.csv';
    if FileExists(fname) then
      ImportTableBase(UpdateTable, fname, 'Загрузка применяемости...', KIT_IMP_FIELDS);

    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;
 }

  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.OOTable);

    fname := Path + 'OO.csv';
    if FileExists(fname) then
      ImportTableBase(UpdateTable, fname, 'Загрузка товаров под заказ...', OO_IMP_FIELDS);

    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;

 //Текстовые описания-----------------------------------------------------------------
  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.DescriptionTable);
    fname := Path + 'descr.csv';
    if FileExists(fname) then
      ImportDescriptionTable(UpdateTable, fname);

    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;

 //Доп. парамметры-----------------------------------------------------------------
 { UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.CatParTable);
    fname := Path + 'param.csv';
    if FileExists(fname) then
      ImportDescriptionTable(UpdateTable, fname);

    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;}

// !!! -------------------------------------------------------------------------
if not fLockUpdateTecdoc then
begin

//применяемость по-новому ------------------------------------------------------
  //binary file (of Integer): <TYP_ID><ART_ID><ART_ID>...-1<TYP_ID><ART_ID><ART_ID>...-1
  fname := Path + 'typ.csv';
  if FileExists(fname) then
  begin
    UpdateTable := makeSafeTable('023_new');
    try
      Data.CopyMaketTable(UpdateTable, Data.ArtTypTable);
      //оставляем только первичный ключ
      if UpdateTable.IndexDefs.IndexOf('Art') >= 0 then
        UpdateTable.IndexDefs.Delete(UpdateTable.IndexDefs.IndexOf('Art'));
      if UpdateTable.IndexDefs.IndexOf('Typ') >= 0 then
        UpdateTable.IndexDefs.Delete(UpdateTable.IndexDefs.IndexOf('Typ'));

      TestTable(UpdateTable);

      //makeTableForUpdate(UpdateTable, Data.ArtTypTable);
      LoadFullPrimen(fName, UpdateTable);

      UpdateTable.Exclusive := True;

      UpdateTable.OnIndexProgress := ArtTypIndexProgress;
      for i := 0 to Data.ArtTypTable.IndexDefs.Count - 1 do
        if (Data.ArtTypTable.IndexDefs[i].Name <> '') and
           (UpdateTable.IndexDefs.IndexOf(Data.ArtTypTable.IndexDefs[i].Name) = -1) then
        begin
          fProgressMessage := 'Обновление привязок к авто...';
          Synchronize(ShowProgressBase);

          UpdateTable.AddIndex(
            Data.ArtTypTable.IndexDefs[i].Name,
            Data.ArtTypTable.IndexDefs[i].Fields,
            Data.ArtTypTable.IndexDefs[i].Options
          );

          Synchronize(HideProgressBase);
        end;
      UpdateTable.Exclusive := False;

//      Data.CopyMaketTable(UpdateTable, Data.ArtTypTable);
//      TestTable(UpdateTable);
      //ImportTableBase(UpdateTable, 'c:\023_.csv', 'Загрузка авто...', 'ART_ID;TYP_ID'); //6 мин - 15%
    finally
      UpdateTable.Free;
    end;
  end;
//------------------------------------------------------------------------------
end;
//------------------------------------------------------------------------------


  //перестроение списка номенклатуры (NomList)
{
  fProgressMessage := 'Перестроение списка номенклатуры...';
  Synchronize(CurrProgressBase);
  RecreateNomList;
  Synchronize(HideProgressBase);
}  


  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.AnalogTable);

    fname := Path + 'ana.csv';
    if FileExists(fname) then
    begin
      ImportTableBase(UpdateTable, fname, 'Заполнение базы аналогов...', ANA_UP_IMPEXP_FIELDS);
      //LoadAnMemo;
    end;

    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;

  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.OETable);

    fname := Path + 'oem.csv';
    if FileExists(fname) then
      ImportTableBase(UpdateTable, fname, 'Заполнение базы OE-номеров...', OEM_UP_IMPEXP_FIELDS);

    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;

  Result := True;
end;


function TUpdateDataThrd.DoInstall_Data: Boolean;
{var
  f: TextFile;
  aLine: string;
}  
begin
  Result := DoImportBase(fTmpPath);

  DeleteFile(Data.Import_Path + 'UpdateInfo.csv');
  if FileExists(fTmpPath + 'UpdateInfo.csv') then
    CopyFile(PCHAR(fTmpPath + 'UpdateInfo.csv'), PCHAR(Data.Import_Path + 'UpdateInfo.csv'), False);
end;

function TUpdateDataThrd.DoInstall_DataDiscret: Boolean;
begin
  Result := DoUpdate(fTmpPath);

  DeleteFile(Data.Import_Path + 'UpdateInfo.csv');
  if FileExists(fTmpPath + 'UpdateInfo.csv') then
    CopyFile(PCHAR(fTmpPath + 'UpdateInfo.csv'), PCHAR(Data.Import_Path + 'UpdateInfo.csv'), False);

end;

function TUpdateDataThrd.DoInstall_News: Boolean;
begin
  //загрузка бегущей строки - в основном потоке
  //кроме распаковки здесь ничего не требуется
  Result := True;
end;

function TUpdateDataThrd.DoInstall_PictsDiscret: Boolean;
begin
  Result := DoUpdatePictsDiscret(fTmpPath);
end;

function TUpdateDataThrd.DoInstall_Quants: Boolean;
begin
  Result := DoUpdateQuantsNew(fTmpPath);
end;

function TUpdateDataThrd.DoInstall_Tires: Boolean;
begin
  Result := DoUpdateTires(fTmpPath);
end;

function TUpdateDataThrd.DoInstall_Typ: Boolean;
begin
  Result := DoUpdateTyp(fTmpPath);
end;

//дискретное обновление
function TUpdateDataThrd.DoUpdate(Path: string = ''): Boolean;
  //нормализует строковое значение для вставки в БД (средствами DBISAM-движка)
  function Quoted(const aValue: string): string;
  begin
    Result := Data.DBEngine.QuotedSQLStr(aValue);
  end;

  procedure SetDefIfEmpty(var aValue: string; const aDefValue: string);
  begin
    if aValue = '' then
      aValue := aDefValue;
  end;

  function IsRecordExists(aQuery: TDBISamQuery; const aTableName, aKeyField, aKeyValue: string): Boolean;
  begin
    aQuery.Close;
    aQuery.SQL.Text := ' SELECT ' + aKeyField + ' FROM [' + aTableName + '] WHERE ' + aKeyField + ' = ' + aKeyValue;
    aQuery.Open;
    Result := not aQuery.Eof;
    aQuery.Close;
  end;

var
  sId, sArtId, sBrand_id, sBrandDescription: string;
  sGroup_id, sGroup_descr, sSubgroup_id, sSubgroup_descr: string;
  sCode, sCode2, sName, sDescription: string;
  sT1, sT2, sTecdoc_id, sNew, sSale: string;
  sMult, sUsa, sPrice, sTitle: string;
  sCat_id, sAn_code, sAn_brand, sAn_id, sAnShortCode, sLocked, sShortOE, sDescr: string;
  sAction: string;
  iCat_id, aSimbOE: Integer;
  TestQuery, SelectQuery: TDBISAMQuery;
  UpdateTable: TDBISAMTable;
  sGen_Id: string;//analogs

  aReader: TCSVReader;
  anIDs: TStrings;
  aPictID, aTypTDID, aParamTDID, aIDouble: string;
  sLine: string;

  dup0, dup1, dup2: TStrings;
  cdup0, cdup1, cdup2: Integer;
  aReaderEof: Boolean;
  sChild_Code, sChild_Brand, sChild_id, sQuantity: string;

   procedure MakeDeleting(Field4Delete, TableName,FileName, Msg: string );
   begin
     if (_Data.GetFileSize_Internal(Path + FileName) > 0) then
     begin
        fProgressMessage:= Msg;
        Synchronize(ShowProgressBase);

        // переписно на удаление пачками
        anIDs.Clear;
        aReader.Open(Path + FileName);
        while not aReader.Eof do
        begin
          if Terminated then //check terminated
           Abort;
          aReader.ReturnLine;

          sAction := aReader.Fields[0];
          sID := aReader.Fields[1];

          anIDs.Add(sID);
          if (anIDs.Count >= cDeleteBatchCount) or (aReader.Eof) then
          begin
            ExecQuery('DELETE from ' + TableName +' WHERE ' + Field4Delete + ' IN (' + anIDs.CommaText + ')', TestQuery);
            anIDs.Clear;
          end;

          CallProgress(aReader.FilePosPercent);
        end;
        aReader.Close;
        Synchronize(HideProgressBase);
     end;
   end;

  procedure MakeAddingAnalog(TableName,FileName, Msg: string );
  begin
    if (_Data.GetFileSize_Internal(Path + FileName) > 0) then
    begin
      fProgressMessage:= Msg;
      Synchronize(ShowProgressBase);
      UpdateTable := makeSafeTable(TableName);
      try
        aReader.Open(Path + FileName);
        UpdateTable.Open;
        anIDs.Clear;
        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;
          aReader.ReturnLine;

          sAn_code     := aReader.Fields[1];
          sAn_brand    := aReader.Fields[2];
          sAn_id       := aReader.Fields[3];
          sLocked      := aReader.Fields[4];
          sGen_Id      := aReader.Fields[5];
          sAnShortCode := aReader.Fields[6];

          if not UpdateTable.Locate('Gen_An_Id', sGen_Id, []) then
          begin
            UpdateTable.Append;
            UpdateTable.FieldByName('Gen_An_id').AsString := sGen_Id;
            UpdateTable.FieldByName('An_code').AsString := sAn_code;
            UpdateTable.FieldByName('An_brand').AsString := sAn_brand;
            UpdateTable.FieldByName('An_id').AsString := sAn_id;
            UpdateTable.FieldByName('An_ShortCode').AsString := sAnShortCode;
            UpdateTable.FieldByName('Locked').AsString := sLocked;
            UpdateTable.Post;
          end;
          CallProgress(aReader.FilePosPercent);
        end;

        aReader.Close;
        UpdateTable.Close;
      finally
        UpdateTable.Free;
      end;
    end;
  end;

begin
  Result := False;

  Data.RemoveTableFromBase(Data.SysParamTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.BrandTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.GroupTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.GroupBrandTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.CatalogTable.TableName + '_New');
//  Data.RemoveTableFromBase(Data.AnalogTable.TableName + '_New');
//  Data.RemoveTableFromBase(Data.OETable.TableName + '_New');

  Data.RemoveTableFromBase(Data.OEDescrTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.OEIDTable.TableName + '_New');
  
  Data.RemoveTableFromBase(Data.TableCarFilter.TableName + '_New');
  Data.RemoveTableFromBase(Data.ArtTypTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.KitTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.OOTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.DescriptionTable.TableName + '_New');

  Data.RemoveTableFromBase(Data.AnalogIDTable.TableName + '_New');
  Data.RemoveTableFromBase(Data.AnalogMainTable_1.TableName + '_New');
  Data.RemoveTableFromBase(Data.AnalogMainTable_2.TableName + '_New');
  Data.RemoveTableFromBase(Data.AnalogMainTable_3.TableName + '_New');
  Data.RemoveTableFromBase(Data.AnalogMainTable_4.TableName + '_New');
  Data.RemoveTableFromBase(Data.AnalogMainTable_5.TableName + '_New');
  
  Data.RemoveTableFromBase(Data.ManufacturersTable.TableName + '_New');
  //проверить удалились ли файлы
  //..

  //проверить хватит ли места для обновления
  CheckFreeSpaceForUpdate
  (
    [
      Data.SysParamTable.TableName,
      Data.BrandTable.TableName,
      Data.GroupTable.TableName,
      Data.GroupBrandTable.TableName,
      Data.CatalogTable.TableName,
     // Data.AnalogTable.TableName,
     // Data.OETable.TableName,
      Data.OEIDTable.TableName,
      Data.OEDescrTable.TableName,
      
      Data.TableCarFilter.TableName,
      Data.ArtTypTable.TableName,
      Data.KitTable.TableName,
      Data.OOTable.TableName,

      Data.DescriptionTable.TableName,
      Data.AnalogIDTable.TableName,
      Data.AnalogMainTable_1.TableName,
      Data.AnalogMainTable_2.TableName,
      Data.AnalogMainTable_3.TableName,
      Data.AnalogMainTable_4.TableName,
      Data.AnalogMainTable_5.TableName,

      Data.ManufacturersTable.TableName
    ]
  );

  SetCurrentDir(Data.Data_Path);

  TestQuery := makeSafeQuery;
  SelectQuery := makeSafeQuery;
  
  aReader := TCSVReader.Create;
  anIDs := TStringList.Create;
  try //finally

    //Поиск по авто (бреныд)
    if (_Data.GetFileSize_Internal(Path + 'manuf.csv') > 0) then
    begin
      fProgressMessage:= 'Копирование брендов...';
      Synchronize(CurrProgressBase);
      CopyTableBase('020', '020_New');
      fProgressMessage := 'Обновление брендов...';
      Synchronize(ShowProgressBase);
      UpdateTable := makeSafeTable('020_New');
      try
        UpdateTable.EmptyTable;
        aReader.Open(Path + 'manuf.csv');
        UpdateTable.Open;
        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;
          aReader.ReturnLine;
          UpdateTable.Append;
          UpdateTable.FieldByName('MFA_ID').Value := aReader.Fields[0];
          UpdateTable.FieldByName('MFA_BRAND').Value := aReader.Fields[1];
          UpdateTable.FieldByName('HIDE').Value := aReader.Fields[2] = '1';
          UpdateTable.Post;
        end;
        UpdateTable.Close;
        aReader.Close;
      finally
        UpdateTable.Free;
      end;
    end;

    // Коды ОЕ ---------------------------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'oe_0.csv') > 0) or
       (_Data.GetFileSize_Internal(Path + 'oe_1.csv') > 0)
       then
    begin
      fProgressMessage:= 'Копирование ОЕ...';
      Synchronize(CurrProgressBase);
      CopyTableBase('016_1m', '016_1m_New');
      CopyTableBase('016_2', '016_2_New');
    end;

    // OE (удаление ID)----------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'OE_0.csv') > 0) then
    begin
      fProgressMessage := 'Удаление OE...';
      Synchronize(ShowProgressBase);
      anIDs.Clear;
      aReader.Open(Path + 'OE_0.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated
          Abort;
        aReader.ReturnLine;

        sAction := aReader.Fields[0];
        sCat_id := aReader.Fields[1];
        sGen_Id := aReader.Fields[2];

        ExecQuery('DELETE FROM [016_2_New] WHERE GEN_OE_ID = ' + sGen_Id + ' and CAT_ID=' +  sCat_id , TestQuery);
        CallProgress(aReader.FilePosPercent);
      end;
      aReader.Close;
      Synchronize(HideProgressBase);
    end;

    // OE (удаление DESCR------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'OE_0_descr.csv') > 0) then
      MakeDeleting('GEN_OE_ID', '[016_1m_new]','OE_0_descr.csv', 'Удаление привязок [1]...');


   // OE (Добавление ID)
    if (_Data.GetFileSize_Internal(Path + 'OE_1.csv') > 0) then
    begin
      fProgressMessage:= 'Добавление ОЕ...';
      Synchronize(ShowProgressBase);
      UpdateTable := makeSafeTable('016_2_new');
      try
        UpdateTable.Open;
        aReader.Open(Path + 'OE_1.csv');

        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;

          aReader.ReturnLine;
          sCat_id  := aReader.Fields[1];
          sGen_id := aReader.Fields[2];

          if not UpdateTable.Locate('gen_oe_id;cat_id',  VarArrayOf([sGen_Id, sCat_id]), []) then
          begin
            UpdateTable.Append;
            UpdateTable.FieldByName('Gen_oe_Id').AsString := sGen_Id;
            UpdateTable.FieldByName('Cat_id').AsString := sCat_id;
            UpdateTable.Post;
          end;

          CallProgress(aReader.FilePosPercent);
        end;
        
        aReader.Close;
        UpdateTable.Close;
      finally
        UpdateTable.Free;
      end;
      Synchronize(HideProgressBase);
    end;


  // OE (Добавление desr)
    if (_Data.GetFileSize_Internal(Path + 'OE_1_descr.csv') > 0) then
    begin
      fProgressMessage:= 'Добавление привязок...';
      Synchronize(ShowProgressBase);
      UpdateTable := makeSafeTable('016_1m_new');
      try
        aReader.Open(Path + 'OE_1_descr.csv');
        UpdateTable.Open;
        anIDs.Clear;
        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;
          aReader.ReturnLine;

          sCode := aReader.Fields[1];
          sShortOE := aReader.Fields[2];
          sGen_Id := aReader.Fields[3];
          if sShortOE <> '' then
            aSimbOE := Ord(sShortOE[1])
          else
            aSimbOE := Ord('?');

          if not UpdateTable.Locate('Gen_OE_Id', sGen_Id, []) then
          begin
            UpdateTable.Append;
            UpdateTable.FieldByName('Gen_OE_id').AsString := sGen_Id;
            UpdateTable.FieldByName('Code').AsString := sCode;
            UpdateTable.FieldByName('ShortOE').AsString := sShortOE;
            UpdateTable.FieldByName('SIMB').AsInteger := aSimbOE;
            UpdateTable.Post;
          end;
          CallProgress(aReader.FilePosPercent);
        end;

        aReader.Close;
        UpdateTable.Close;
      finally
        UpdateTable.Free;
      end;
    end;




//АНАЛОГИ
    if (_Data.GetFileSize_Internal(Path + 'ana_0.csv') > 0) or
       (_Data.GetFileSize_Internal(Path + 'ana_0_descr.csv') > 0) or
       (_Data.GetFileSize_Internal(Path + 'ana_1.csv') > 0) or
       (_Data.GetFileSize_Internal(Path + 'ana_1_descr.csv') > 0) then
    begin
      fProgressMessage := 'Копирование аналогов...';
      Synchronize(CurrProgressBase);
      CopyTableBase('007_1m', '007_1m_New');
      CopyTableBase('007_2m', '007_2m_New');
      CopyTableBase('007_3m', '007_3m_New');
      CopyTableBase('007_4m', '007_4m_New');
      CopyTableBase('007_5m', '007_5m_New');
      CopyTableBase('007_2', '007_2_New');      
    end;

    // Аналоги (удаление ID)----------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'ana_0.csv') > 0) then
    begin
      fProgressMessage := 'Удаление аналогов...';
      Synchronize(ShowProgressBase);
      anIDs.Clear;
      aReader.Open(Path + 'ana_0.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated
          Abort;
        aReader.ReturnLine;

        sAction := aReader.Fields[0];
        sCat_id := aReader.Fields[1];
        sGen_Id := aReader.Fields[2];

        ExecQuery('DELETE FROM [007_2_New] WHERE GEN_AN_ID = ' + sGen_Id + ' and CAT_ID=' +  sCat_id , TestQuery);
        CallProgress(aReader.FilePosPercent);
      end;
      aReader.Close;
      Synchronize(HideProgressBase);
    end;

    // Аналоги (удаление DESCR------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'ana_0_descr1.csv') > 0) then
      MakeDeleting('GEN_AN_ID', '[007_1m_new]','ana_0_descr1.csv', 'Удаление привязок [1]...');
    if (_Data.GetFileSize_Internal(Path + 'ana_0_descr2.csv') > 0) then
      MakeDeleting('GEN_AN_ID', '[007_2m_new]','ana_0_descr2.csv', 'Удаление привязок [2]...');
    if (_Data.GetFileSize_Internal(Path + 'ana_0_descr3.csv') > 0) then
      MakeDeleting('GEN_AN_ID', '[007_3m_new]','ana_0_descr3.csv', 'Удаление привязок [3]...');
    if (_Data.GetFileSize_Internal(Path + 'ana_0_descr4.csv') > 0) then
      MakeDeleting('GEN_AN_ID', '[007_4m_new]','ana_0_descr4.csv', 'Удаление привязок [4]...');
    if (_Data.GetFileSize_Internal(Path + 'ana_0_descr5.csv') > 0) then
      MakeDeleting('GEN_AN_ID', '[007_5m_new]','ana_0_descr5.csv', 'Удаление привязок [5]...');

    // Аналоги (Добавление ID)
    if (_Data.GetFileSize_Internal(Path + 'ana_1.csv') > 0) then
    begin
      fProgressMessage:= 'Добавление аналогов...';
      Synchronize(ShowProgressBase);
      UpdateTable := makeSafeTable('007_2_new');
      try
        UpdateTable.Open;
        aReader.Open(Path + 'ana_1.csv');

        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;

          aReader.ReturnLine;
          sCat_id  := aReader.Fields[1];
          sGen_id := aReader.Fields[2];

          if not UpdateTable.Locate('gen_an_id;cat_id',  VarArrayOf([sGen_Id, sCat_id]), []) then
          begin
            UpdateTable.Append;
            UpdateTable.FieldByName('Gen_An_Id').AsString := sGen_Id;
            UpdateTable.FieldByName('Cat_id').AsString := sCat_id;
            UpdateTable.Post;
          end;

          CallProgress(aReader.FilePosPercent);
        end;
        
        aReader.Close;
        UpdateTable.Close;
      finally
        UpdateTable.Free;
      end;
      Synchronize(HideProgressBase);
    end;
    
    // Аналоги (Добавление desr)
    if (_Data.GetFileSize_Internal(Path + 'ana_1_descr1.csv') > 0) then
      MakeAddingAnalog('007_1m_new','ana_1_descr1.csv', 'Добавление привязок [1]...');
    if (_Data.GetFileSize_Internal(Path + 'ana_1_descr2.csv') > 0) then
      MakeAddingAnalog('007_2m_new','ana_1_descr2.csv', 'Добавление привязок [2]...');
    if (_Data.GetFileSize_Internal(Path + 'ana_1_descr3.csv') > 0) then
      MakeAddingAnalog('007_3m_new','ana_1_descr3.csv', 'Добавление привязок [3]...');
    if (_Data.GetFileSize_Internal(Path + 'ana_1_descr4.csv') > 0) then
      MakeAddingAnalog('007_4m_new','ana_1_descr4.csv', 'Добавление привязок [4]...');
    if (_Data.GetFileSize_Internal(Path + 'ana_1_descr5.csv') > 0) then
      MakeAddingAnalog('007_5m_new','ana_1_descr5.csv', 'Добавление привязок [5]...');


    //EXIT;// УБРАТЬ!!!!!!!!!!!!!!!!

    // бренды ----------------------------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'bra.csv') > 0) then
    begin
      fProgressMessage := 'Копирование брендов...';
      Synchronize(CurrProgressBase);
      CopyTableBase('003', '003_New');

      fProgressMessage := 'Загрузка брендов...';
      Synchronize(ShowProgressBase);
      aReader.Open(Path + 'bra.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated
          Abort;

        aReader.ReturnLine;
        sAction := aReader.Fields[0];
        sID := aReader.Fields[1];
        if sAction = '0' then //новые
        begin
          sBrand_id := aReader.Fields[2];
          sBrandDescription := aReader.Fields[3];

          if not IsRecordExists(SelectQuery, '003_New', 'ID', sID) then
            ExecQuery(
              'INSERT INTO [003_New] (ID, Brand_id, Description) VALUES (' +
              sID + ', ' + sBrand_id + ', ' + Quoted(sBrandDescription) + ')',
              TestQuery
            );
        end
        else
          if sAction = '1' then //удаленные
            ExecQuery(
              'DELETE from [003_New] WHERE ID = ' + sID,
              TestQuery
            );
        CallProgress(aReader.FilePosPercent);
      end; //while
      aReader.Close;
      Synchronize(HideProgressBase);
    end;


    if (_Data.GetFileSize_Internal(Path + 'gru.csv') > 0) then
    begin
      // группы ----------------------------------------------------------------
      fProgressMessage := 'Копирование групп...';
      Synchronize(CurrProgressBase);
      CopyTableBase('004', '004_New');

      fProgressMessage := 'Загрузка групп...';
      Synchronize(ShowProgressBase);
      aReader.Open(Path + 'gru.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated
          Abort;
        aReader.ReturnLine;

        sAction := aReader.Fields[0];
        sID := aReader.Fields[1];
        if sAction = '0' then
        begin
          sGroup_id := aReader.Fields[2];
          sGroup_descr := aReader.Fields[3];
          sSubgroup_id := aReader.Fields[4];
          sSubgroup_descr := aReader.Fields[5];

          if not IsRecordExists(SelectQuery, '004_New', 'ID', sID) then
            ExecQuery(
              'INSERT INTO [004_New] (ID, Group_id, Group_descr, Subgroup_id, Subgroup_descr) VALUES (' +
              sID + ', ' + sGroup_id + ', ' + Quoted(sGroup_descr) + ', ' + sSubgroup_id + ', ' + Quoted(sSubgroup_descr) + ')',
              TestQuery
            );
        end
        else
          if sAction = '1' then
            ExecQuery(
              'DELETE from [004_New] WHERE ID = ' + sID,
              TestQuery
            );

        CallProgress(aReader.FilePosPercent);
      end;
      aReader.Close;
      Synchronize(HideProgressBase);
    end;

    if (_Data.GetFileSize_Internal(Path + 'grb.csv') > 0) then
    begin
      // группы (дерево) -------------------------------------------------------
      fProgressMessage := 'Копирование групп/бренд...';
      Synchronize(CurrProgressBase);
      CopyTableBase('005', '005_New');

      fProgressMessage := 'Загрузка групп/бренд...';
      Synchronize(ShowProgressBase);
      aReader.Open(Path + 'grb.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated
          Abort;
        aReader.ReturnLine;

        sAction := aReader.Fields[0];
        sID := aReader.Fields[1];
        if sAction = '0' then
        begin
          sGroup_id := aReader.Fields[2];
          sSubgroup_id := aReader.Fields[3];
          sBrand_id := aReader.Fields[4];

          if not IsRecordExists(SelectQuery, '005_New', 'ID', sID) then
            ExecQuery(
              'INSERT INTO [005_New] (ID, Group_id, Subgroup_id, Brand_id) VALUES (' +
              sID + ', ' + sGroup_id + ', ' + sSubgroup_id + ', ' + sBrand_id + ')',
              TestQuery
            );
        end
        else
          if sAction = '1' then
            ExecQuery(
              'DELETE from [005_New] WHERE ID =' + sID,
              TestQuery
            );

        CallProgress(aReader.FilePosPercent);
      end;
      aReader.Close;
      Synchronize(HideProgressBase);
    end;

    //каталог (удаленные) ---------------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'cat_1.csv') > 0) or
         (_Data.GetFileSize_Internal(Path + 'cat_2.csv') > 0) or
           (_Data.GetFileSize_Internal(Path + 'cat_3.csv') > 0) or
             (_Data.GetFileSize_Internal(Path + 'cat_4.csv') > 0) or
               (_Data.GetFileSize_Internal(Path + 'cat_5.csv') > 0) or
                 (_Data.GetFileSize_Internal(Path + 'cat_6.csv') > 0) or
                   (_Data.GetFileSize_Internal(Path + 'cat_7.csv') > 0) then
    begin
      fProgressMessage := 'Копирование каталога...';
      Synchronize(CurrProgressBase);
      CopyTableBase('002', '002_New');

      if (_Data.GetFileSize_Internal(Path + 'cat_1.csv') > 0) then
      begin
        fProgressMessage := 'Очистка каталогa...';
        Synchronize(ShowProgressBase);
        ExecQuery('DELETE from [002_New] WHERE CODE2 = ''''', TestQuery); //удаление категорий
      end;
      // переписно на удаление пачками
      anIDs.Clear;
      aReader.Open(Path + 'cat_0.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated
          Abort;
        aReader.ReturnLine;
        sAction := aReader.Fields[0];
        sID := aReader.Fields[1];
        anIDs.Add(sID);
        if (anIDs.Count >= cDeleteBatchCount) or (aReader.Eof) then
        begin
          ExecQuery('DELETE from [002_New] WHERE CAT_ID IN (' + anIDs.CommaText + ')', TestQuery);
          anIDs.Clear;
        end;
        CallProgress(aReader.FilePosPercent);
      end;
      aReader.Close;
      Synchronize(HideProgressBase);


      // каталог (цены) --------------------------------------------------------
      fProgressMessage := 'Обновление цен каталогa...';
      Synchronize(ShowProgressBase);
      aReader.Open(Path + 'cat_2.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated
          Abort;
        aReader.ReturnLine;

        sAction := aReader.Fields[0];
        sID := aReader.Fields[1];
        sPrice := ReplaceStr(aReader.Fields[2], ',', '.');
        if length(sPrice) = 0 then
          ExecQuery('UPDATE [002_New] SET Price = NULL WHERE CAT_ID = ' + sID, TestQuery)
        else
          ExecQuery('UPDATE [002_New] SET Price = ' + sPrice + ' WHERE CAT_ID = ' + sID, TestQuery);

        CallProgress(aReader.FilePosPercent);
      end;
      aReader.Close;
      Synchronize(HideProgressBase);


      // каталог (новые) -------------------------------------------------------
      fProgressMessage := 'Добавление новых позиций...';
      Synchronize(ShowProgressBase);
      aReader.Open(Path + 'cat_1.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated                   
          Abort;
        aReader.ReturnLine;

        sAction := aReader.Fields[0];
        sID := aReader.Fields[1];
        sBrand_id := aReader.Fields[2];
        sGroup_id := aReader.Fields[3];
        sSubgroup_id := aReader.Fields[4];
        sCode := aReader.Fields[5];
        sCode2 := aReader.Fields[6];
        sName := aReader.Fields[7];
        sDescription := aReader.Fields[8];
        sPrice := aReader.Fields[9];
        sT1 := aReader.Fields[10];
        sT2 := aReader.Fields[11];
        sTecdoc_id := aReader.Fields[12];
        sNew := aReader.Fields[13];
        sSale := aReader.Fields[14];
        sMult := aReader.Fields[15];
        sUsa := aReader.Fields[16];
        sTitle := aReader.Fields[17];
        //новые поля после реструктуризации
        aPictID := aReader.Fields[18];
        aTypTDID := aReader.Fields[19];
        aParamTDID := aReader.Fields[20];

        aIDouble := aReader.Fields[21];

        SetDefIfEmpty(sBrand_id, '0');
        SetDefIfEmpty(sGroup_id, '0');
        SetDefIfEmpty(sPrice, '0.0');
        SetDefIfEmpty(sTecdoc_id, '0');
        SetDefIfEmpty(sNew, '0');
        SetDefIfEmpty(sSale, '0');
        SetDefIfEmpty(sMult, '0');
        SetDefIfEmpty(sUsa, '0');
        SetDefIfEmpty(sTitle, '0');
        SetDefIfEmpty(aPictID, '0');
        SetDefIfEmpty(aTypTDID, '0');
        SetDefIfEmpty(aParamTDID, '0');
        SetDefIfEmpty(aIDouble, '0');

        sPrice := ReplaceStr(sPrice, ',', '.');
        sDescription := ReplaceStr(sDescription, '''', '.');


  // !!! -------------------------------------------
        if fLockUpdateTecdoc then
        begin
          sTecdoc_id := '0';
          aPictID := '0';
          aTypTDID := '0';
          aParamTDID := '0';
        end;
  //------------------------------------------------

        if not IsRecordExists(SelectQuery, '002_New', 'Cat_id', sID) then
          ExecQuery(
            'INSERT INTO [002_New] ' +
            '( ' +
            '  Cat_id, ' +
            '  Brand_id, ' +
            '  Group_id, ' +
            '  Subgroup_id, ' +
            '  Code, ' +
            '  Code2, ' +
            '  Name, ' +
            '  Description, ' +
            '  Price, ' +
            '  T1, ' +
            '  T2, ' +
            '  Tecdoc_id, ' +
            '  New, ' +
            '  Sale, ' +
            '  Mult, ' +
            '  Usa, ' +
            '  Title, ' +
            '  ShortCode, ' +
            '  pict_id, ' +
            '  typ_tdid, ' +
            '  param_tdid, ' +
            '  IDouble ' +
            ') ' +
            'VALUES ' +
            '( ' +
            sID + ', ' +
            sBrand_id + ', ' +
            sGroup_id + ', ' +
            sSubgroup_id + ', ' +
            Quoted(sCode) + ', ' +
            Quoted(sCode2) + ', ' +
            Quoted(sName) + ', ' +
            Quoted(sDescription) + ', ' +
            sPrice + ', ' +
            sT1 + ', ' +
            sT2 + ', ' +
            sTecdoc_id + ', ' +
            Quoted(sNew) + ', ' +
            Quoted(sSale) + ', ' +
            sMult + ', ' +
            Quoted(sUsa) + ', ' +
            sTitle + ', ' +
            Quoted(Data.CreateShortCode(sCode)) + ', ' +
            aPictID + ', ' +
            aTypTDID + ', ' +
            aParamTDID + ', ' +
            aIDouble +
            ') ',
            TestQuery
          );

        CallProgress(aReader.FilePosPercent);
      end;
      aReader.Close;
      Synchronize(HideProgressBase);


      // каталог (измененные) --------------------------------------------------
      fProgressMessage:= 'Обновление записей каталогa...';
      Synchronize(ShowProgressBase);
      aReader.Open(Path + 'cat_3.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated
          Abort;
        aReader.ReturnLine;

        sAction := aReader.Fields[0];
        sID := aReader.Fields[1];
        sBrand_id := aReader.Fields[2];
        sGroup_id := aReader.Fields[3];
        sSubgroup_id := aReader.Fields[4];
        sCode := aReader.Fields[5];
        sCode2 := aReader.Fields[6];
        sName := aReader.Fields[7];
        sDescription := aReader.Fields[8];
        sPrice := aReader.Fields[9];
        sT1 := aReader.Fields[10];
        sT2 := aReader.Fields[11];
        sTecdoc_id := aReader.Fields[12];
        sNew := aReader.Fields[13];
        sSale := aReader.Fields[14];
        sMult := aReader.Fields[15];
        sUsa := aReader.Fields[16];
        sTitle := aReader.Fields[17];
        //новые поля после реструктуризации
        aPictID := aReader.Fields[18];
        aTypTDID := aReader.Fields[19];
        aParamTDID := aReader.Fields[20];
        aIDouble := aReader.Fields[21];

        SetDefIfEmpty(sBrand_id, '0');
        SetDefIfEmpty(sGroup_id, '0');
        SetDefIfEmpty(sPrice, '0.0');
        SetDefIfEmpty(sTecdoc_id, '0');
        SetDefIfEmpty(sNew, '0');
        SetDefIfEmpty(sSale, '0');
        SetDefIfEmpty(sMult, '0');
        SetDefIfEmpty(sUsa, '0');
        SetDefIfEmpty(sTitle, '0');
        SetDefIfEmpty(aPictID, '0');
        SetDefIfEmpty(aTypTDID, '0');
        SetDefIfEmpty(aParamTDID, '0');
        SetDefIfEmpty(aIDouble, '0');

        sPrice := ReplaceStr(sPrice, ',', '.');
        sDescription := ReplaceStr(sDescription, '''', '.');

  // !!! -------------------------------------------
        if fLockUpdateTecdoc then
        begin
          sTecdoc_id := 'Tecdoc_id';
          aPictID := 'pict_id';
          aTypTDID := 'typ_tdid';
          aParamTDID := 'param_tdid';
        end;
  //------------------------------------------------


        ExecQuery(
          'UPDATE [002_new] Set ' +
          '  Brand_id = ' + sBrand_id +
          ', Group_id = ' + sGroup_id +
          ', Subgroup_id = ' + sSubgroup_id +
          ', Code = ' + Quoted(sCode) +
          ', Code2 = ' + Quoted(sCode2) +
          ', Name = ' + Quoted(sName) +
          ', Description = ' + Quoted(sDescription) +
          ', Price = ' + sPrice +
          ', T1 = ' + sT1 +
          ', T2 = ' + sT2 +
          ', Tecdoc_id = ' + sTecdoc_id +
          ', New = ' + Quoted(sNew) +
          ', Sale = ' + Quoted(sSale) +
          ', Mult = ' + sMult +
          ', Usa = ' + Quoted(sUsa) +
          ', Title = ' + sTitle +
          ', ShortCode = ' + Quoted(Data.CreateShortCode(sCode)) +
          ', pict_id = ' + aPictID +
          ', typ_tdid = ' + aTypTDID +
          ', param_tdid = ' + aParamTDID +
          ', IDouble = ' + aIDouble +
          ' WHERE CAT_ID = ' + sID,
          TestQuery
        );
        CallProgress(aReader.FilePosPercent);
      end;
      aReader.Close;
      Synchronize(HideProgressBase);


      // каталог (перегруппировка) ---------------------------------------------
      fProgressMessage := 'Перегруппировка каталогa...';
      Synchronize(ShowProgressBase);
      aReader.Open(Path + 'cat_4.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated
          Abort;
        aReader.ReturnLine;

        sAction := aReader.Fields[0];
        sID := aReader.Fields[1];
        sGroup_id := aReader.Fields[2];
        sSubgroup_id := aReader.Fields[3];
        ExecQuery(
          'UPDATE [002_New] SET Group_id = ' + sGroup_id + ', Subgroup_id = ' + sSubgroup_id + ' WHERE CAT_ID = ' + sID,
          TestQuery
        );

        CallProgress(aReader.FilePosPercent);
      end;
      aReader.Close;
      Synchronize(HideProgressBase);


      // каталог (имена и описания) --------------------------------------------
      fProgressMessage:= 'Обновление описаний...';
      Synchronize(ShowProgressBase);
      aReader.Open(Path + 'cat_5.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated
          Abort;
        aReader.ReturnLine;

        sAction := aReader.Fields[0];
        sID := aReader.Fields[1];
        sName := aReader.Fields[2];
        sDescription := aReader.Fields[3];

        ExecQuery(
          'UPDATE [002_New] SET Name = ' + Quoted(sName) + ', Description = ' + Quoted(sDescription) + ' WHERE CAT_ID = ' + sID,
          TestQuery
        );
        CallProgress(aReader.FilePosPercent);
      end;
      aReader.Close;
      Synchronize(HideProgressBase);

  // !!! -------------------------------------------
      if not fLockUpdateTecdoc then
      begin

        // каталог (ссылки на tecdoc) ----------------------------------------------
        fProgressMessage:= 'Обновление привязок подробностей...';
        Synchronize(ShowProgressBase);
        aReader.Open(Path + 'cat_6.csv');
        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;
          aReader.ReturnLine;

          sAction := aReader.Fields[0];
          sID := aReader.Fields[1];
          sTecdoc_id := aReader.Fields[2];
          //новые поля после реструктуризации
          aPictID := aReader.Fields[3];
          aTypTDID := aReader.Fields[4];
          aParamTDID := aReader.Fields[5];

          SetDefIfEmpty(sID, '0');
          SetDefIfEmpty(sTecdoc_id, '0');
          SetDefIfEmpty(aPictID, '0');
          SetDefIfEmpty(aTypTDID, '0');
          SetDefIfEmpty(aParamTDID, '0');

          ExecQuery(
            'UPDATE [002_New] SET ' +
            '  Tecdoc_id = ' + sTecdoc_id +
            ', pict_id = ' + aPictID +
            ', typ_tdid = ' + aTypTDID +
            ', param_tdid = ' + aParamTDID +
            ' WHERE CAT_ID = ' + sID,
            TestQuery
          );
          CallProgress(aReader.FilePosPercent);
        end;
        aReader.Close;
        Synchronize(HideProgressBase);
      end;
  //------------------------------------------------


      // каталог (пометка дубликатов) --------------------------------------------
      if FileExists(Path + 'cat_7.csv') then
      begin
        fProgressMessage:= 'Пометка дубликатов...';
        Synchronize(ShowProgressBase);
        aReader.Open(Path + 'cat_7.csv');

        dup0 := TStringList.Create; cdup0 := 0;
        dup1 := TStringList.Create; cdup1 := 0;
        dup2 := TStringList.Create; cdup2 := 0;

        try
          while not aReader.Eof do
          begin
            if Terminated then //check terminated
              Abort;
            aReader.ReturnLine;
            aReaderEof := aReader.Eof;

            case StrToIntDef(aReader.Fields[2], 0) of
              0: begin dup0.Add(aReader.Fields[1]); Inc(cdup0); end;
              1: begin dup1.Add(aReader.Fields[1]); Inc(cdup1); end;
              2: begin dup2.Add(aReader.Fields[1]); Inc(cdup2); end;
            end;

            if (cdup0 >= cUpdateBatchCount) or (aReaderEof and (cdup0 > 0)) then
            begin
              ExecQuery(
                'UPDATE [002_New] SET IDouble = 0 WHERE CAT_ID IN (' + dup0.CommaText + ')',
                TestQuery
              );
              dup0.Clear;
              cdup0 := 0;
            end;

            if (cdup1 >= cUpdateBatchCount) or (aReaderEof and (cdup1 > 0)) then
            begin
              ExecQuery(
                'UPDATE [002_New] SET IDouble = 1 WHERE CAT_ID IN (' + dup1.CommaText + ')',
                TestQuery
              );
              dup1.Clear;
              cdup1 := 0;
            end;

            if (cdup2 >= cUpdateBatchCount) or (aReaderEof and (cdup2 > 0)) then
            begin
              ExecQuery(
                'UPDATE [002_New] SET IDouble = 2 WHERE CAT_ID IN (' + dup2.CommaText + ')',
                TestQuery
              );
              dup2.Clear;
              cdup2 := 0;
            end;

            CallProgress(aReader.FilePosPercent);
          end;
          aReader.Close;
          Synchronize(HideProgressBase);

        finally
          dup0.Free;
          dup1.Free;
          dup2.Free;
        end;
      end;
    end;
// !!! -------------------------------------------
     if not fLockUpdateTecdoc then
    begin

      // Применяемость по-новому ----------------------
      if (_Data.GetFileSize_Internal(Path + 'typ.csv') > 0) then
      //if FileExists(Path + 'typ.csv') then
      begin
        fProgressMessage := 'Копирование применяемости...';
        Synchronize(CurrProgressBase);
        CopyTableBase('023', '023_New');

        fProgressMessage := 'Обновление применяемости...';
        Synchronize(ShowProgressBase);
        aReader.Open(Path + 'typ.csv');

        UpdateTable := makeSafeTable('023_new');
        try
          UpdateTable.Exclusive := True;
          UpdateTable.Open;
          //<COMMAND>;<ART_ID>;<TYP_ID> (command: 0-append, 1-delete)
          while not aReader.Eof do
          begin
            if Terminated then //check terminated
              Abort;
            aReader.ReturnLine;

            sAction := aReader.Fields[0];
            sArtId := aReader.Fields[1];
            sID := aReader.Fields[2];

            if sAction = '0' then
            begin
              //insert if not exists
              if not UpdateTable.Locate('ART_ID;TYP_ID', VarArrayOf([sArtId, sID]), []) then
              begin
                UpdateTable.Append;
                UpdateTable.FieldByName('ART_ID').AsString := sArtId;
                UpdateTable.FieldByName('TYP_ID').AsString := sId;
                UpdateTable.Post;
              end;
            end
            else
              if sAction = '1' then
                if UpdateTable.Locate('ART_ID;TYP_ID', VarArrayOf([sArtId, sID]), []) then
                  UpdateTable.Delete;

            CallProgress(aReader.FilePosPercent);
          end;
        finally
          UpdateTable.Close;
          UpdateTable.Free;
        end;


        aReader.Close;
        Synchronize(HideProgressBase);
      end;
      // -----------------------------------------
    end;
//------------------------------------------------
              
 // Текстовые описания---------------------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'descr_0.csv') > 0) or
       (_Data.GetFileSize_Internal(Path + 'descr_1.csv') > 0) or
       (_Data.GetFileSize_Internal(Path + 'descr_2.csv') > 0) then
    begin
      fProgressMessage := 'Копирование текстовых описаний...';
      Synchronize(CurrProgressBase);
      CopyTableBase('013', '013_New');
    end;
 // удаление ---------------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'descr_0.csv') > 0) then
    begin
      fProgressMessage:= 'Удаление текстовых описаний...';
      Synchronize(ShowProgressBase);
      // переписно на удаление пачками
      anIDs.Clear;
      aReader.Open(Path + 'descr_0.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated
          Abort;
        aReader.ReturnLine;

        sAction := aReader.Fields[0];
        sID := aReader.Fields[1];
        anIDs.Add(sID);

        if (anIDs.Count >= cDeleteBatchCount) or (aReader.Eof) then
        begin
          ExecQuery('DELETE from [013_New] WHERE CAT_ID in (' + anIDs.CommaText + ')', TestQuery);
          anIDs.Clear;
        end;

        CallProgress(aReader.FilePosPercent);
      end;
      aReader.Close;
      Synchronize(HideProgressBase);
    end;
// измененные --------------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'descr_2.csv') > 0) then
    begin
      fProgressMessage:= 'Обновление текстовых описаний...';
      Synchronize(ShowProgressBase);
      UpdateTable := makeSafeTable('013_new');
      try
        UpdateTable.Open;

        aReader.Open(Path + 'descr_2.csv');
        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;
          aReader.ReturnLine;

          sAction := aReader.Fields[0];
          sID := aReader.Fields[1];
          sDescr := StringReplace(aReader.Fields[2], '~13', #13, [rfReplaceAll]);
          sDescr := StringReplace(sDescr, '~59', ';', [rfReplaceAll]);

          if UpdateTable.Locate('CAT_ID', sID, []) then
          begin
            UpdateTable.Edit;
            UpdateTable.FieldByName('description').AsString := sDescr;
            UpdateTable.Post;
          end;
          CallProgress(aReader.FilePosPercent);
        end;
        aReader.Close;

        UpdateTable.Close;
      finally
        UpdateTable.Free;
      end;
      Synchronize(HideProgressBase);
    end;
    // новые-------------------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'descr_1.csv') > 0) then
    begin
      fProgressMessage:= 'Добавление текстовых описаний...';
      Synchronize(ShowProgressBase);
      UpdateTable := makeSafeTable('013_new');
      try
        UpdateTable.Open;

        aReader.Open(Path + 'descr_1.csv');
        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;
          sLine := aReader.ReturnLine;

          sAction := aReader.Fields[0];
          sID := aReader.Fields[1];
          sDescr := aReader.Fields[2];
          sDescr := StringReplace(sDescr,'~13',#13,[rfReplaceAll]);
		  sDescr := StringReplace(sDescr,'~59',';',[rfReplaceAll]);
		  
          if not UpdateTable.Locate('CAT_ID', sID, []) then
          begin
            UpdateTable.Append;
            UpdateTable.FieldByName('CAT_ID').AsString := sID;
            UpdateTable.FieldByName('description').AsString := sDescr;
            UpdateTable.Post;
          end;
          CallProgress(aReader.FilePosPercent);
        end;
        aReader.Close;
        UpdateTable.Close;
      finally
        UpdateTable.Free;
      end;
      Synchronize(HideProgressBase);
    end;
 //* комплекты ******************************************************************
    if (_Data.GetFileSize_Internal(Path + 'kit_0.csv') > 0) or
       (_Data.GetFileSize_Internal(Path + 'kit_1.csv') > 0) or
       (_Data.GetFileSize_Internal(Path + 'kit_2.csv') > 0) then
    begin
      fProgressMessage := 'Копирование комплектов...';
      Synchronize(CurrProgressBase);
      CopyTableBase('041', '041_New');
    end;

    // Комплекты (удаленные) ---------------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'kit_0.csv') > 0) then
    begin
      fProgressMessage:= 'Удаление комплектов...';
      Synchronize(ShowProgressBase);

      // переписно на удаление пачками
      anIDs.Clear;
      aReader.Open(Path + 'kit_0.csv');
      while not aReader.Eof do
      begin
        if Terminated then //check terminated
          Abort;
        aReader.ReturnLine;

        sAction := aReader.Fields[0];
        sID := aReader.Fields[1];

        anIDs.Add(sID);
        if (anIDs.Count >= cDeleteBatchCount) or (aReader.Eof) then
        begin
          ExecQuery('DELETE from [041_New] WHERE ID IN (' + anIDs.CommaText + ')', TestQuery);
          anIDs.Clear;
        end;

        CallProgress(aReader.FilePosPercent);
      end;
      aReader.Close;
      Synchronize(HideProgressBase);
    end;


    // Комплекты (измененные) --------------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'kit_2.csv') > 0) then
    begin
      fProgressMessage:= 'Обновление комплектов...';
      Synchronize(ShowProgressBase);
      UpdateTable := makeSafeTable('041_new');
      try
        UpdateTable.Open;

        aReader.Open(Path + 'kit_2.csv');
        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;
          aReader.ReturnLine;
          //  0         1     2           3
          //['Action', 'ID', 'CHILD_ID', 'QUANTITY']
          sAction := aReader.Fields[0];
          sID := aReader.Fields[1];
          sChild_id := aReader.Fields[2];
          sQuantity := aReader.Fields[3];
          if sQuantity = '' then
            sQuantity := '0';

          if UpdateTable.Locate('ID', sID, []) then
          begin
            UpdateTable.Edit;
            UpdateTable.FieldByName('CHILD_ID').AsString := sChild_id;
            UpdateTable.FieldByName('QUANTITY').AsString := sQuantity;
            UpdateTable.Post;
          end;

          CallProgress(aReader.FilePosPercent);
        end;
        aReader.Close;

        UpdateTable.Close;
      finally
        UpdateTable.Free;
      end;
      Synchronize(HideProgressBase);
    end;


    // Комплекты (новые) -------------------------------------------------------
    if (_Data.GetFileSize_Internal(Path + 'kit_1.csv') > 0) then
    begin
      fProgressMessage:= 'Добавление комплектов...';
      Synchronize(ShowProgressBase);
      UpdateTable := makeSafeTable('041_new');
      try
        UpdateTable.Open;

        aReader.Open(Path + 'kit_1.csv');
        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;
          sLine := aReader.ReturnLine;
          //  0         1     2         3             4              5           6
          //['Action', 'ID', 'CAT_ID', 'CHILD_CODE', 'CHILD_BRAND', 'CHILD_ID', 'QUANTITY']
          sAction := aReader.Fields[0];
          sID := aReader.Fields[1];
          sCat_id  := aReader.Fields[2];
          sChild_Code := aReader.Fields[3];
          sChild_Brand := aReader.Fields[4];
          sChild_id := aReader.Fields[5];
          sQuantity := aReader.Fields[6];
          if sQuantity = '' then
            sQuantity := '0';

          if not UpdateTable.Locate('ID', sID, []) then
          begin
            UpdateTable.Append;
            UpdateTable.FieldByName('ID').AsString := sID;
            UpdateTable.FieldByName('CAT_ID').AsString := sCat_id;
            UpdateTable.FieldByName('CHILD_CODE').AsString := sChild_Code;
            UpdateTable.FieldByName('CHILD_BRAND').AsString := sChild_Brand;
            UpdateTable.FieldByName('CHILD_ID').AsString := sChild_id;
            UpdateTable.FieldByName('QUANTITY').AsString := sQuantity;
            UpdateTable.Post;
          end;

          CallProgress(aReader.FilePosPercent);
        end;
        aReader.Close;

        UpdateTable.Close;
      finally
        UpdateTable.Free;
      end;
      Synchronize(HideProgressBase);
    end;
//******************************************************************************


// Товары "под заказ" **********************************************************
    if (_Data.GetFileSize_Internal(Path + 'oo.csv') > 0) then
    begin
      fProgressMessage := 'Копирование признаков...';
      Synchronize(CurrProgressBase);
      CopyTableBase('042', '042_New');

      fProgressMessage := 'Загрузка заказных позиций...';
      Synchronize(ShowProgressBase);
      UpdateTable := makeSafeTable('042_new');
      try
        UpdateTable.Open;

        aReader.Open(Path + 'oo.csv');
        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;

          aReader.ReturnLine;
          sAction := aReader.Fields[0];
          sCat_id := aReader.Fields[1];

          if sAction = '0' then //новые
          begin
            if not UpdateTable.Locate('CAT_ID', sCat_id, []) then
            begin
              UpdateTable.Append;
              UpdateTable.FieldByName('CAT_ID').AsString := sCat_id;
              UpdateTable.Post;
            end;
          end
          else
            if sAction = '1' then //удаленные
            begin
              if UpdateTable.Locate('CAT_ID', sCat_id, []) then
              begin
                UpdateTable.Delete;
              end;
            end;

          CallProgress(aReader.FilePosPercent);
        end; //while
        aReader.Close;

        UpdateTable.Close;
      finally
        UpdateTable.Free;
      end;
      Synchronize(HideProgressBase);
    end;
//******************************************************************************


  
  finally
    anIDs.Free;
    aReader.Free;
    TestQuery.Free;
    SelectQuery.Free;
  end;

  if (_Data.GetFileSize_Internal(Path + 'sys.csv') > 0) then
  begin
    UpdateTable := makeSafeTable(Data.SysParamTable.TableName + '_New');
    try
      Data.CopyMaketTable(UpdateTable, Data.SysParamTable);
      TestTable(UpdateTable);
      if FileExists(Path + 'sys.csv') then
        ImportTableBase(UpdateTable, Path + 'sys.csv', 'Загрузка настроек...', SYS_IMPEXP_FIELDS);
      UpdateTable.Close;
    finally
      UpdateTable.Free;
    end;
  end;

  Result := True;
end;

function TUpdateDataThrd.DoUpdatePictsDiscret(const aPath: string): Boolean;
var
  aReader: TCSVReader;
  aTable: TDBISamTable;
  aPictId: Integer;
begin
  Result := True;
  SetCurrentDir(Data.Data_Path);

  if (_Data.GetFileSize_Internal(aPath + 'picts.csv') > 0) then
  begin
    fProgressMessage := 'Загрузка картинок...';
    Synchronize(ShowProgressBase);

    aReader := TCSVReader.Create;
    aTable := makeSafeTable('027');
    try
      aReader.Open(aPath + 'picts.csv');
      aTable.Open;

      while not aReader.Eof do
      begin
        aReader.ReturnLine;
        CallProgress(aReader.FilePosPercent);

        aPictId := StrToIntDef(aReader.Fields[0], 0);
        if aPictId = 0 then
          Continue;

        if aTable.Locate('PICT_ID', aPictId, []) then
          aTable.Edit
        else
        begin
          aTable.Append;
          aTable.FieldByName('PICT_ID').AsInteger := aPictId;
        end;

        try
          TBlobField(aTable.FieldByName('Pict_data')).LoadFromFile(aPath + 'Picts\' + aReader.Fields[0] + '.jpg');
        except
          //ignore exceptions
        end;
        aTable.Post;
      end;

      aTable.Close;
      aReader.Close;
      Synchronize(HideProgressBase);
    finally
      aTable.Free;
      aReader.Free;
    end;
  end;
end;

procedure TUpdateDataThrd.ArtTypIndexProgress(Sender: TObject;
  PercentDone: Word);
begin
  if Terminated then
    Abort;
  CallProgress(PercentDone);
end;

procedure TUpdateDataThrd.CallProgress(aPos: Integer);
begin
  if aPos = -1 then
    fPrevProgress := -1
  else
    if aPos <> fPrevProgress then
    begin
      fCurProgress := aPos;
      fPrevProgress := aPos;
      Synchronize(SetPosProgress);
    end;
end;

procedure TUpdateDataThrd.ShowProgressBase;
begin
  if Terminated then
    Exit;
  fPrevProgress := -1;
  Main.StatusBar.Panels[5].Style              := psProgress;
  Main.StatusBar.Panels[5].Progress.Position  := 0;
  Main.StatusBar.Panels[5].Progress.Max       := 100;
  Main.StatusBar.Panels[6].Text               := '  ' + fProgressMessage;
end;

procedure TUpdateDataThrd.HideProgressBase;
begin
  if Main.StatusBar.Panels.Count > 6 then
  begin
    Main.StatusBar.Panels[5].Style := psHTML;
    Main.StatusBar.Panels[5].Text  := '';
    Main.StatusBar.Panels[6].Text  := '';
  end;
end;

procedure TUpdateDataThrd.CurrProgressBase;
begin
  if Main.StatusBar.Panels.Count > 6 then
  begin
    Main.StatusBar.Panels[5].Style := psHTML;
    Main.StatusBar.Panels[5].Text  := '';
    Main.StatusBar.Panels[6].Text  := '  ' + fProgressMessage;
  end;
end;

procedure TUpdateDataThrd.SetPosProgress;
begin
  if Main.StatusBar.Panels.Count > 6 then
  begin
    if Main.StatusBar.Panels[5].Style <> psProgress then
      Main.StatusBar.Panels[5].Style := psProgress;

    if Main.StatusBar.Panels[5].Progress.Max <> 100 then
      Main.StatusBar.Panels[5].Progress.Max := 100;

    Main.StatusBar.Panels[5].Progress.Position := fCurProgress;
  end;
end;

//OK
(*
function TUpdateDataThrd.DoUpdateQuants(const aPath: string): Boolean;
var
  UpdateTable: TDBISAMTable;
  cb, cat_code, cat_brand: string;
  p: integer;
  aReader: TCSVReader;
begin
  Result := False;

  SetCurrentDir(Data.Data_Path);

  if Data.ParamTable.FieldByName('bUpdateKursesWithQuants').AsBoolean and
     FileExists(aPath + 'Rates.csv') then
  begin
    aReader := TCSVReader.Create;
    try
      aReader.Open(aPath + 'Rates.csv');
      with Data.ParamTable do
      begin
        Edit;
        aReader.ReturnLine;
        FieldByName('Eur_usd_rate').Value := Main.AToFloat(aReader.Fields[1]);

        aReader.ReturnLine;
        FieldByName('Eur_rate').Value := Main.AToFloat(aReader.Fields[1]);

        aReader.ReturnLine;
        if aReader.Fields[1] <> '' then
          FieldByName('Eur_RUB_rate').Value := Main.AToFloat(aReader.Fields[1]);
        Post;
      end;
      aReader.Close;
    finally
      aReader.Free;
    end;
  end;

  Main.sIDs := '';
  Data.RemoveTableFromBase(Data.QuantTable.TableName + '_New');
  Data.NomList.Open;
  Data.NomList.First;

  if not FileExists(aPath + 'qnt.csv') then
    raiseUpdateErr(cERR_REQUIRED_FILE_NOT_FOUND + ' "qnt.csv"');

  TestTable(Data.UpdateQuant, Data.data_psw);
  UpdateTable := TDBISAMTable.Create(nil);
  try //finally
    UpdateTable.DatabaseName := Data.Database.DatabaseName;
    UpdateTable.TableName := Data.QuantTable.TableName + '_New';
    Data.CopyMaketTable(UpdateTable, Data.QuantTable);
    TestTable(UpdateTable);

    if Terminated then //check terminated
      Abort;

    with Data.UpdateQuant do
    begin
      IndexName := '';
      Open;

      fProgressMessage := 'Загрузка файла остатков...';
      Synchronize(ShowProgressBase);

      aReader := TCSVReader.Create;
      try
        aReader.Open(aPath + 'qnt.csv');
        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;

          aReader.ReturnLine;
          cb := aReader.Fields[0];
          p := Pos('_', cb);
          cat_code  := Data.MakeSearchCode(Copy(cb, 1,  p - 1));
          cat_brand := Copy(cb, p + 1, MaxInt);

          Append;
            FieldByName('sCode').AsString := cat_code;
            FieldByName('sBrand').AsString := cat_brand;
            FieldByName('Quants').AsString := aReader.Fields[1];
            FieldByName('PRICE').AsString := aReader.Fields[2];
            FieldByName('SALE').AsString := aReader.Fields[3];
            FieldByName('QuantNew').AsString := aReader.Fields[5];
          Post;

          CallProgress( aReader.FilePosPercent );
        end;

        Synchronize(HideProgressBase);
      finally
        aReader.Free;
      end;

      IndexName := 'Code';
      Data.NomList.IndexName := 'Code2';

      //-------------------------------
      fProgressMessage := 'Загрузка остатков и цен...';
      Synchronize(ShowProgressBase);

      First;
      Data.NomList.First;
      UpdateTable.Open;
      while not Data.NomList.EOF do
      begin
        if Terminated then //check terminated
          Abort;

        CallProgress( GetPercent(Data.NomList.RecNo, Data.NomList.RecordCount) );

        //Main.sIDs
        if Data.NomList.FieldByName('Code2').AsString = FieldByName('sCode').AsString then
        begin
          while Data.NomList.FieldByName('sBrand').AsString > Data.UpdateQuant.FieldByName('sBrand').AsString do
          begin
            Data.UpdateQuant.Next;
            if Data.UpdateQuant.Eof then
              Break;
            if Data.NomList.FieldByName('Code2').AsString <> FieldByName('sCode').AsString then
              Break;
          end;

          if Data.NomList.FieldByName('Code2').AsString = FieldByName('sCode').AsString then
          begin
            if Data.NomList.FieldByName('sBrand').AsString = FieldByName('sBrand').AsString then
            begin
              UpdateTable.Append;
              UpdateTable.FieldByName('Cat_id').Value   := Data.NomList.FieldByName('Cat_id').AsInteger;
              UpdateTable.FieldByName('Quantity').Value := FieldByName('Quants').AsString;
              if (FieldByName('Quants').AsString <> '') and (FieldByName('Quants').AsString <> '0') then
              begin
                if Main.sIDs <> '' then
                  Main.sIDs := Main.sIDs +','+ UpdateTable.FieldByName('Cat_id').AsString
                else
                  Main.sIDs := UpdateTable.FieldByName('Cat_id').AsString;
              end;

              if Trim(FieldByName('PRICE').AsString) <> '' then
              begin
                UpdateTable.FieldByName('Price').Value := Main.AToCurr(FieldByName('PRICE').AsString);
              end
              else
                UpdateTable.FieldByName('Price').Value := Main.AToCurr('0');
              if FieldByName('SALE').AsString = '1' then
                UpdateTable.FieldByName('Sale').Value := '1'
              else
                UpdateTable.FieldByName('Sale').Value := '0';

              UpdateTable.FieldByName('QuantNew').AsString := FieldByName('QuantNew').AsString;
              UpdateTable.Post;
              Next;
              Data.NomList.Next;

              if Data.UpdateQuant.EOF then
                Break;
            end
            else
              Data.NomList.Next;
          end
          else
            if Data.NomList.FieldByName('Code2').AsString < FieldByName('sCode').AsString then
              Data.NomList.Next;
        end
        else
          if Data.NomList.FieldByName('Code2').AsString > FieldByName('sCode').AsString then
          begin
            Next;
            if EOF then
              Break;
          end
          else
            Data.NomList.Next;
      end; //while not Data.NomList.EOF

      Data.NomList.Close;
      Data.UpdateQuant.Close;
      Data.UpdateQuant.EmptyTable;
      UpdateTable.Close;
    end; //with Data.UpdateQuant

  finally
    UpdateTable.Free;
    Synchronize(HideProgressBase);
  end;

  if Length(Main.sIDs) > 0 then
    Main.sIDs := '(Cat_id IN ('+Main.sIDs+'))';  //видимо, обновленные ID'шки

  Result := True;
end;
*)

function TUpdateDataThrd.DoUpdateQuantsNew(const aPath: string): Boolean;
var
  UpdateTable: TDBISAMTable;
  cb, cat_code, cat_brand, Sale: string;
  Price, priceOptRf: Currency;
  p: integer;
  aReader: TCSVReader;
  aQuerySel: TDBISAMQuery;
  dir, SaleOptRF : string;
begin
  Result := False;

  SetCurrentDir(Data.Data_Path);

  {if Data.ParamTable.FieldByName('bUpdateKursesWithQuants').AsBoolean and
     FileExists(aPath + 'Rates.csv') then
  begin
    aReader := TCSVReader.Create;
    try
      aReader.Open(aPath + 'Rates.csv');
      with Data.ParamTable do
      begin
        Edit;
        aReader.ReturnLine;
        FieldByName('Eur_usd_rate').Value := Main.AToFloat(aReader.Fields[1]);

        aReader.ReturnLine;
        FieldByName('Eur_rate').Value := Main.AToFloat(aReader.Fields[1]);

        aReader.ReturnLine;
        if aReader.Fields[1] <> '' then
          FieldByName('Eur_RUB_rate').Value := Main.AToFloat(aReader.Fields[1]);
        Post;
      end;
      aReader.Close;
    finally
      aReader.Free;
    end;
  end;   }

  Main.sIDs := '';
  //удалить _new
  Data.RemoveTableFromBase(Data.QuantTable.TableName + '_New',True);

  if not FileExists(aPath + 'qnt.csv') then
    raiseUpdateErr(cERR_REQUIRED_FILE_NOT_FOUND + ' "qnt.csv"');

  if Data.memBrand.Exists and Data.memBrand.Active then
    Data.memBrand.Close;
  TestTable(Data.memBrand, Data.data_psw);
  Data.memBrand.EmptyTable;
  ExecQuerySafe(
    ' INSERT INTO "MEMORY\memBrand" ' +
    ' SELECT BRAND_ID, DESCRIPTION FROM [003] '
  );

//>> -------------------------------------------
  if Main.fLocalMode then
  begin
    SetCurrentDir(Data.GetDomainName);
    dir := fLocalDatabase.Directory;
    fLocalDatabase.Directory := Data.GetDomainName;
  end;
// ---------------------------------------------

  if Data.memQuants.Exists and Data.memQuants.Active then
    Data.memQuants.Close;

  {$IFNDEF LOCAL}
   Data.SetCurrencyByRegionCode(fLocalDatabase.SessionName, fLocalDatabase.DatabaseName);
  {$ENDIF}

  UpdateTable := TDBISAMTable.Create(nil);
  try //finally
    UpdateTable.DatabaseName := fLocalDatabase.DatabaseName;
    UpdateTable.TableName := Data.QuantTable.TableName + '_New';
    Data.CopyMaketTable(UpdateTable, Data.QuantTable);
    TestTable(UpdateTable);

    if Terminated then //check terminated
      Abort;

// ---------------------------------------------
    if Main.fLocalMode then
    begin
      fLocalDatabase.Directory := dir;
      SetCurrentDir(Data.Data_Path);
    end;
// ---------------------------------------------

//******************************************************************************
    fProgressMessage := 'Загрузка номенклатуры...';
    Synchronize(ShowProgressBase);

    if Data.Nom.Exists then
    begin
      Data.Nom.Close;
      Data.Nom.EmptyTable;
    end
    else
      Data.Nom.CreateTable;

    Data.Nom.Exclusive := True;
    if Data.CatMemoryUsed then
      ExecQuerySafe(
        ' SELECT Cat_id, Code2, Brand_id ' +
        ' INTO "MEMORY\nom" FROM "MEMORY\CatFilterTable" ',
        True {aShowProgress}
      )
    else
      ExecQuerySafe(
        ' SELECT Cat_id, Code2, Brand_id ' +
        ' INTO "MEMORY\nom" FROM [002] ',
        True {aShowProgress}
      );

    Data.Nom.AddIndex('Code2', 'Code2;Brand_id');
    Data.Nom.Exclusive := False;
    Data.Nom.Open;
//******************************************************************************

    fProgressMessage := 'Обновление остатков...';
    Data.memBrand.IndexName := 'Descr';
    Data.memBrand.Open;
    UpdateTable.Open;

      fProgressMessage := 'Загрузка файла остатков...';
      Synchronize(ShowProgressBase);

      aReader := TCSVReader.Create;
      try
        aReader.Open(aPath + 'qnt.csv');
        while not aReader.Eof do
        begin
          if Terminated then //check terminated
            Abort;

          aReader.ReturnLine;
          cb := aReader.Fields[0];
          p := Pos('_', cb);
          cat_code  := Data.MakeSearchCode(Copy(cb, 1,  p - 1));
          cat_brand := Copy(cb, p + 1, MaxInt);
          if Trim(aReader.Fields[2]) <> '' then
            Price := Main.AToCurr(aReader.Fields[2])
          else
            Price := Main.AToCurr('0');

          if Trim(aReader.Fields[7]) <> '' then
            priceOptRf := Main.AToCurr(aReader.Fields[7])
          else
            priceOptRf := Main.AToCurr('0');

          if aReader.Fields[3] = '1' then
            Sale := '1'
          else
            Sale := '0';

          if aReader.Fields[8] = '1' then
            SaleOptRF := '1'
          else
            SaleOptRF := '0';

          if Data.memBrand.FindKey([cat_brand]) then
            if Data.Nom.Locate('Code2;Brand_id',
                                VarArrayOf([cat_code,Data.memBrand.FieldByName('Brand_id').AsInteger]), []) then
            begin
              UpdateTable.Append;
              UpdateTable.FieldByName('Cat_id').AsInteger := Data.Nom.FieldByName('Cat_id').AsInteger;
              UpdateTable.FieldByName('Quantity').AsString := aReader.Fields[1];
              UpdateTable.FieldByName('SALE').AsString := sale;;
              UpdateTable.FieldByName('PRICE').Value := price;
              UpdateTable.FieldByName('PriceOptRF').Value := priceOptRf;
              UpdateTable.FieldByName('SaleOptRF').Value := SaleOptRF;             
              UpdateTable.FieldByName('QuantNew').AsString := aReader.Fields[5];
              UpdateTable.FieldByName('Latest').AsInteger := 0;
              UpdateTable.Post;

              if (aReader.Fields[1] <> '') and (aReader.Fields[1] <> '0') then
              begin
                if Main.sIDs <> '' then
                  Main.sIDs := Main.sIDs + ',' + Data.Nom.FieldByName('Cat_id').AsString
                else
                  Main.sIDs := Data.Nom.FieldByName('Cat_id').AsString;
              end;
              
            end;
          CallProgress( aReader.FilePosPercent );
        end;
        Synchronize(HideProgressBase);
      finally
        aReader.Free;
      end;

    Data.memBrand.Close;
    Data.memBrand.EmptyTable;

    Synchronize(ShowProgressBase);

    Data.Nom.Close;
    Data.Nom.EmptyTable;

    UpdateTable.Close;

  finally
    UpdateTable.Free;
    Synchronize(HideProgressBase);
  end;

  if Length(Main.sIDs) > 0 then
    Main.sIDs := '(Cat_id IN ('+Main.sIDs+'))';  //видимо, обновленные ID'шки

  Result := True;
end;

function TUpdateDataThrd.DoUpdateTires(const aPath: string): Boolean;
var
  fname: string;
  UpdateTable: TDBISAMTable;
begin
  Data.RemoveTableFromBase(Data.TiresCarMake.TableName + '_New');
  Data.RemoveTableFromBase(Data.TiresCarModel.TableName + '_New');
  Data.RemoveTableFromBase(Data.TiresCarEngine.TableName + '_New');
  Data.RemoveTableFromBase(Data.TiresDimensions.TableName + '_New');

  CheckFreeSpaceForUpdate( [ Data.TiresCarMake.TableName,
                             Data.TiresCarModel.TableName,
                             Data.TiresCarEngine.TableName,
                             Data.TiresDimensions.TableName
                           ]);


  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.TiresCarMake);
    fname := aPath + '1.csv';
    if FileExists(fname) then
      ImportTableBase(UpdateTable, fname, 'Загрузка производителей...', TIRES_MARKS_IMPEXP_FIELDS);
    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;

  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.TiresCarModel);
    fname := aPath + '2.csv';
    if FileExists(fname) then
      ImportTableBase(UpdateTable, fname, 'Загрузка моделей...', TIRES_MODEL_IMPEXP_FIELDS);
    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;

  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.TiresCarEngine);
    fname := aPath + '3.csv';
    if FileExists(fname) then
      ImportTableBase(UpdateTable, fname, 'Загрузка авто...', TIRES_ENGINE_IMPEXP_FIELDS);
    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;

  UpdateTable := TDBISAMTable.Create(nil);
  try
    makeTableForUpdate(UpdateTable, Data.TiresDimensions);
    fname := aPath + '4.csv';
    if FileExists(fname) then
      ImportTableBase(UpdateTable, fname, 'Загрузка привязок...', TIRES_DIMENSIONS_IMPEXP_FIELDS);
    UpdateTable.Close;
  finally
    UpdateTable.Free;
  end;

  Result := True;
end;

function TUpdateDataThrd.DoUpdateTyp(const aPath: string): Boolean;
var
  sAction,sId, sArtId : string;
  UpdateTable: TDBISAMTable;
  aReader: TCSVReader;
begin
    Result := False;
    if not fLockUpdateTecdoc then
    begin
      Result := True;
      aReader := TCSVReader.Create;
      // Применяемость по-новому ----------------------
      if (_Data.GetFileSize_Internal(aPath + 'typ.csv') > 0) then
      if FileExists(aPath + 'typ.csv') then
      begin
        fProgressMessage := 'Копирование применяемости...';
        Synchronize(CurrProgressBase);
        CopyTableBase('023', '023_New');

        fProgressMessage := 'Обновление применяемости...';
        Synchronize(ShowProgressBase);
        aReader.Open(aPath + 'typ.csv');

        UpdateTable := makeSafeTable('023_new');
        try
          UpdateTable.Exclusive := True;
          UpdateTable.Open;
          //<COMMAND>;<ART_ID>;<TYP_ID> (command: 0-append, 1-delete)
          while not aReader.Eof do
          begin
            if Terminated then //check terminated
              Abort;
            aReader.ReturnLine;

            sAction := aReader.Fields[0];
            sArtId := aReader.Fields[1];
            sID := aReader.Fields[2];

            if sAction = '0' then
            begin
              //insert if not exists
              if not UpdateTable.Locate('ART_ID;TYP_ID', VarArrayOf([sArtId, sID]), []) then
              begin
                UpdateTable.Append;
                UpdateTable.FieldByName('ART_ID').AsString := sArtId;
                UpdateTable.FieldByName('TYP_ID').AsString := sId;
                UpdateTable.Post;
              end;
            end
            else
              if sAction = '1' then
                if UpdateTable.Locate('ART_ID;TYP_ID', VarArrayOf([sArtId, sID]), []) then
                  UpdateTable.Delete;

            CallProgress(aReader.FilePosPercent);
          end;
        finally
          UpdateTable.Close;
          UpdateTable.Free;
        end;
        aReader.Close;
        Synchronize(HideProgressBase);
      end;
      // -----------------------------------------
    end;
end;

(*
function TUpdateDataThrd.DiskUpdateExecute: Integer;
var
  f: TextFile;
  sRead, aPassword: string;
begin
  Result := 1; //err

  //полное обновление данных с диска
  if fFullUpdate then
  begin
    Main.UnZipper.DestDir  := fTmpPath;
    Main.UnZipper.ZipName  := fFileName;
    Main.UnZipper.Password := UPD_PWD;
    if Main.UnZipper.UnZip < 1 then
      Exit;

    {
    DeleteFile(Data.Import_Path + 'UpdateInfo.csv');
    if FileExists(fTmpPath + 'UpdateInfo.csv') then
      CopyFile(PCHAR(fTmpPath + 'UpdateInfo.csv'), PCHAR(Data.Import_Path + 'UpdateInfo.csv'), False);
    }
    
    if not DoImportBase(fTmpPath) then
      Exit;

    try //except
      AssignFile(f, fTmpPath + '0');
      Reset(f);
      try //finally
        Readln(f, sRead);
        fNewDataVersion := sRead;
        Readln(f, sRead);
        fNewDescretVersion := sRead;
      finally

        CloseFile(f);
      end;
    except
      Exit;
    end;

    Result := 3; //OK
  end //if fFullUpdate
  else
  //частичное обновление данных с диска
  begin
    Main.UnZipper.DestDir  := fTmpPath;
    Main.UnZipper.ZipName  := fFileName;
    aPassword := Main.StrRight(fFileName, 12);
    aPassword := Main.StrLeft(aPassword, 8);
    Main.UnZipper.Password := UPD_PWD + '-' + aPassword;
    if Main.UnZipper.UnZip < 1 then
      Exit;

    if not DoUpdate(fTmpPath) then
      Exit;

    try
      AssignFile(f, fTmpPath + '0');
      Reset(f);
      try
        Readln(f, sRead);
        Main.NewDataVersion := sRead;
        Readln(f, sRead);
        Main.NewDescretVersion := sRead;
      finally
        CloseFile(f);
      end;
    except
      Exit;
    end;

    Result := 3; //OK
  end;
end;


function TUpdateDataThrd.WebUpdateExecute: Integer;
var
  iMessageType: Integer;
  sPassword: string;
  fileBat: TextFile;
  aInstr: string;
  sFileName: string;
  sGr: string;

  aInstructions: TStrings;
begin
  Result := 1; //err
  iMessageType := 0;

  aInstructions := TStringList.Create;
  try //finally
    aInstructions.LoadFromFile(fFileName);
    DeleteFile(fFileName);

    while aInstructions.Count > 0 do
    begin
      aInstr := aInstructions[0]; aInstructions.Delete(0);
      if aInstr = '' then
        Continue;

      case RecognizeWebUpdateType(aInstr) of
        wupUnknown:
        begin
          //???
        end;

        wupData:
        begin
          aInstr := aInstructions[0]; aInstructions.Delete(0);
          Main.UnZipper.DestDir  := fTmpPath;
          Main.UnZipper.ZipName  := aInstr;
          Main.UnZipper.Password := UPD_PWD;

          if Main.UnZipper.UnZip < 1 then
          begin
            Result := 1;
            Exit;
          end;
          {
          DeleteFile(Data.Import_Path + 'UpdateInfo.csv');
          if FileExists(tmp_path + 'UpdateInfo.csv') then
            CopyFile(PCHAR(tmp_path + 'UpdateInfo.csv'), PCHAR(Data.Import_Path + 'UpdateInfo.csv'), False);
          }
          if not DoImportBase(fTmpPath) then
          begin
            Result := 1;
            Exit;
          end;

          aInstr := aInstructions[0]; aInstructions.Delete(0);
          fNewDataVersion := aInstr;
          aInstr := aInstructions[0]; aInstructions.Delete(0);
          fNewDescretVersion := aInstr;
          iMessageType := iMessageType + 3;
          Result := iMessageType;
          Continue;
        end;

        wupDataDiscret:
        begin
          aInstr := aInstructions[0]; aInstructions.Delete(0);
          Main.UnZipper.DestDir  := fTmpPath;
          Main.UnZipper.ZipName  := aInstr;
          sPassword := Main.StrRight(aInstr, 12);
          sPassword := Main.StrLeft(sPassword, 8);
          Main.UnZipper.Password := UPD_PWD + '-' + sPassword;
          if Main.UnZipper.UnZip < 1 then
          begin
            Result := 1;
            Exit;
          end;

          DeleteFile(Data.Import_Path + 'UpdateInfo.csv');
          if FileExists(fTmpPath + 'UpdateInfo.csv') then
            CopyFile(PCHAR(fTmpPath + 'UpdateInfo.csv'), PCHAR(Data.Import_Path + 'UpdateInfo.csv'), False);

          if not DoUpdate(fTmpPath) then
          begin
            Result := 1;
            Exit;
          end;

          aInstr := aInstructions[0]; aInstructions.Delete(0);
          fNewDataVersion := aInstr;
          aInstr := aInstructions[0]; aInstructions.Delete(0);
          fNewDescretVersion := aInstr;
          iMessageType := iMessageType + 3;
          Result := iMessageType;
          Continue;
        end;

        wupNews:
        begin
          aInstr := aInstructions[0]; aInstructions.Delete(0);
          Main.UnZipper.DestDir  := GetAppDir;
          Main.UnZipper.ZipName  := aInstr;
          Main.UnZipper.Password := UPD_PWD;
          Main.UnZipper.DoAll := True;
          if Main.UnZipper.UnZip < 1 then
          begin
            Result := 1;
            Exit;
          end;

          //[kri] !!! перенести в основной поток !!!
          sFileName := GetAppDir + 'RunningLine';
          if FileExists(sFileName) then
          begin
            AssignFile(FileBat, sFileName);
            Reset(FileBat);
            try
              while not EOF(FileBat) do
              begin
                Readln(FileBat, sGr);
                Main.JvScrollText.Items.Add(sGr);
              end;
            finally
              CloseFile(FileBat);
            end;
          end;
          //---

          aInstr := aInstructions[0]; aInstructions.Delete(0);
          fNewNewsVersion := aInstr;
          //[kri] !!! перенести в основной поток !!!
          Data.VersionTable.Edit;
          Data.VersionTable.FieldbyName('NewsVersion').Value := aInstr;
          Data.VersionTable.Post;
          //---

          aInstr := aInstructions[0]; aInstructions.Delete(0);
          Result := iMessageType;
          Continue;
        end;

        wupQuants:
        begin
          aInstr := aInstructions[0]; aInstructions.Delete(0);
          if not DoUpdateQuants(fTmpPath) then
          begin
            Result := 1;
            Exit;
          end;
          aInstr := aInstructions[0]; aInstructions.Delete(0);
          fNewQuantVersion := aInstr;
          aInstr := aInstructions[0]; aInstructions.Delete(0);

          iMessageType := iMessageType + 2;
          Result := iMessageType;
        end;
      end;//case
    end; //while

  finally
    aInstructions.Free;
  end;
end;
*)

function TUpdateDataThrd.Unpack(const aSourceZip, aDestDir,
  aPassword: string): Boolean;
begin
// !!! здесь нельзя чистить папку-получатель, т.к. это может быть папка приложения

  fUnZipper.ZipName := aSourceZip;
  fUnZipper.DestDir := aDestDir;
  fUnZipper.DoAll := True;
  fUnZipper.Password := aPassword;

  fProgressMessage := 'Распаковка ' + ExtractFileName(aSourceZip) + '...';
  Synchronize(ShowProgressBase);
  try
    try //возможно этот компонент эксептит
      Result := fUnZipper.UnZip >= 1;
    except
      on E: Exception do
      begin
        LogError(Format(fProgressMessage + ': ошибка распаковщика "%s"', [E.Message]));
        Result := False;
      end;
    end;
  finally
    Synchronize(HideProgressBase);
  end;
end;

{aTableNames - список таблиц которые будут резервироваться}
procedure TUpdateDataThrd.CheckFreeSpaceForUpdate(const aTableNames: array of string);
var
  i: Integer;

  aNeedUpdateSize: Int64;
  i64FreeBytesToCaller: Int64;
  i64TotalBytes: Int64;
  i64FreeBytes: TLargeInteger;
  aDrive: string;
begin
  aNeedUpdateSize := 0;
  for i := Low(aTableNames) to High(aTableNames) do
    aNeedUpdateSize := aNeedUpdateSize + GetTableSize(aTableNames[i]);

  aDrive := ExtractFileDrive(Data.Data_Path);
  if GetDiskFreeSpaceEx(PChar(aDrive), i64FreeBytesToCaller, i64TotalBytes, @i64FreeBytes) then
  begin
    aNeedUpdateSize := aNeedUpdateSize + 1024*1024*50; //потребуем на 50мб больше на всякий случай
    if i64FreeBytes < aNeedUpdateSize then
      raiseUpdateErr(Format('Недостаточно свободного места на диске %s - требуется: %s, доступно: %s', [aDrive, _Data.GetFileSizeStr(aNeedUpdateSize), _Data.GetFileSizeStr(i64FreeBytes)]));
  end;
end;

function TUpdateDataThrd.CheckVersionFileFound(const aSourceZip: string): Boolean;
var
  i: Integer;
begin
  Result := False;

  fUnZipper.ZipName := aSourceZip;
  fUnZipper.ReadZip;
  for i := 0 to fUnZipper.Count - 1 do
    if SameText(fUnZipper.Filename[i], cVersionFileName) then
    begin
      Result := True;
      Exit;
    end;
end;

procedure TUpdateDataThrd.CopyTableBase(const aTableName,
  aNewTableName: string);
var
  aTable: TDBISamTable;
begin
  Data.CopyTableBase(aTableName, aNewTableName);
  Exit;

  fLocalDatabase.Open;
  aTable := makeSafeTable(aTableName);
  try
    aTable.CopyTable(fLocalDatabase.Directory, aNewTableName);
  finally
    aTable.Free;
  end;
  fLocalDatabase.Close;
end;

procedure TUpdateDataThrd.UnpackProgress(Sender: TObject; Percent: Integer);
begin
  if Terminated then
    Abort;
  CallProgress(Percent);
end;

procedure TUpdateDataThrd.QueryProgress(Sender: TObject; PercentDone: Word;
  var Abort: Boolean);
begin
  Abort := Terminated;
  CallProgress(PercentDone);
end;

function TUpdateDataThrd.InstallPackage(aPackage: TUpdateQueueItem): Boolean;

  procedure ReadVersions(const aFileName: string; aPackage: TUpdateQueueItem);
  var
    f: TextFile;
    aLine: string;
  begin
    aPackage.NewVersions.Clear;
    AssignFile(f, aFileName);
    {x$I-}
    try
      Reset(f);
      try //finally
        while not EOF(f) do
        begin
          Readln(f, aLine);
          aPackage.NewVersions.Add(aLine);
        end;
      finally
        CloseFile(f);
      end;
    except
      // do nothing - ignore
    end;
    {x$I+}
  end;

var
  aPass, aDestDir: string;
begin
  Result := False;
  fPrevProgress := -1;

  if Terminated then //check terminated
    Abort;

  aPackage.BeginInstall;
  try
    if not aPackage.CheckRequiresInstalled then
      raiseUpdateErr(cERR_REQUIRED_PACKAGE_NEED);

    //очищаем временную папку
    EraseDirFiles(fTmpPath, False);

    //проверка наличия файла с версиями - до распаковки, чтоб не распаковывать зря
    if aPackage.VersionsRequired and aPackage.VersionsInside then
      if not CheckVersionFileFound(aPackage.ZipFile) then
        raiseUpdateErr(cERR_VERSION_NOT_FOUND);

    //распаковка
    if aPackage.PackageType in [wupDataDiscret, wupPictsDiscret, wupTyp] then
      aPass := UPD_PWD + '-' + Copy(aPackage.ZipFile, pos('_d', aPackage.ZipFile) + 2,  pos('.zip', aPackage.ZipFile) - pos('_d', aPackage.ZipFile) -2) // вырезаем версию: data_d[110624.1].zip
    else if aPackage.PackageType = wupTires then
      aPass := UPD_PWD + 't'
    else
      aPass := UPD_PWD;

    if aPackage.PackageType = wupNews then
      aDestDir := GetAppDir
    else
      aDestDir := fTmpPath;

    if not Unpack(aPackage.ZipFile, aDestDir, aPass) then
      raiseUpdateErr(cERR_UNPACK);


    //версии внутри пакета
    if aPackage.VersionsInside then
      ReadVersions(aDestDir + '0', aPackage);

    //проверка есть ли версии
    if aPackage.VersionsRequired and (aPackage.NewVersions.Count = 0) then
      raiseUpdateErr(cERR_VERSION_NOT_FOUND);

// !!! -------------------------------------------------------------------------
    if Data.fTecdocOldest then
      if aPackage.PackageType in [wupData, wupDataDiscret] then
      begin
        if aPackage.NewVersions.Count > 0 then
          //если новая версия больше последней старой сборки и тикдок старый - ограниченное обновление
          if Data.CheckVersions('120625.1', aPackage.NewVersions[0]) > 0 then
          begin
            fLockUpdateTecdoc := True;
          end;
      end;
//------------------------------------------------------------------------------

    //установка обновления
    //DoInstall_XXX должны работать только с распакованными файлами в папке
    case aPackage.PackageType of
      wupData:         Result := DoInstall_Data;
      wupDataDiscret:  Result := DoInstall_DataDiscret;
      wupNews:         Result := DoInstall_News;
      wupQuants:       Result := DoInstall_Quants;
      //... возможно другие виды пакетов в будущем
      wupPictsDiscret: Result := DoInstall_PictsDiscret;
      wupTyp:          Result := DoInstall_Typ;
      wupTires:        Result := DoInstall_Tires;
    else
      Result := False;
    end;

    aPackage.fInstalled := Result;
  finally
    aPackage.EndInstall;
  end;
end;

procedure TUpdateDataThrd.Execute;
var
  i: Integer;
  aInstalledCount: Integer;
begin
  fUpdateResult := urFail; //error

  Assert(fInitialized, 'TUpdateDataThrd: поток не инициализирован (метод Init() не был вызван)!');
  if not fInitialized then
    Exit;

  DeleteFile(GetAppDir + cUpdateErrorsLogFile);

  aInstalledCount := 0;
  for i := 0 to fQueue.Count - 1 do
  begin
    try

      if InstallPackage(fQueue[i]) then
        Inc(aInstalledCount);

    except
      on E: EAbort do
        if Terminated then //поток принудительно завершили
        begin
          fUpdateResult := urAborted;
          fErrorMsg := 'Прервано';
          Exit; //не продолжаем дальше
        end; //else - пропуск только этого пакета

      //известная ошибка при обновлении
      on E: EUpdateException do
      begin
        fQueue[i].fUpdateError := E.Message;
        fQueue[i].fUpdateResultCode := E.ErrorCode;
        LogError(Format('Установка пакета "%s", ошибка: "%s"', [fQueue[i].ZipFile, E.Message]));
      end;

      on E: ESQLException do
      begin
        fErrorMsg := E.Message; //???
        fQueue[i].fUpdateError := E.Message;
        LogError(Format('Установка пакета "%s", исключение: "%s", SQL: "%s"', [fQueue[i].ZipFile, E.Message, E.SQL]));
      end;

      //неизвестная ошибка - запись только в лог
      on E: Exception do
      begin
        fErrorMsg := E.Message; //???
        fQueue[i].fUpdateError := E.Message;
        LogError(Format('Установка пакета "%s", исключение: "%s"', [fQueue[i].ZipFile, E.Message]));
      end;
    end;
  end;

  if aInstalledCount = 0 then
    fUpdateResult := urFail
  else
    if aInstalledCount = fQueue.Count then
      fUpdateResult := urFully
    else
      fUpdateResult := urPartially;
(*
    if not fReadFromScenary then
      fUpdateResult := DiskUpdateExecute //ZIP-пакет с обновлением
    else
      fUpdateResult := WebUpdateExecute; //WEB-обновление (читаем инструкции из файла "update")
*)

end;

function TUpdateDataThrd.GetTableSize(const aTableName: string): Int64;
begin
  Result := _Data.GetFileSize_Internal(Data.Data_Path + aTableName + '.1') +
            _Data.GetFileSize_Internal(Data.Data_Path + aTableName + '.2') +
            _Data.GetFileSize_Internal(Data.Data_Path + aTableName + '.3');
end;

{ TUpdateQueue }

constructor TUpdateQueue.Create;
begin
  fList := TList.Create;
end;

destructor TUpdateQueue.Destroy;
begin
  Clear;
  fList.Free;
  
  inherited;
end;


function TUpdateQueue.Add(aItem: TUpdateQueueItem): Integer;
begin
  aItem.fOwner := Self;
  Result := fList.Add(aItem);
end;

function TUpdateQueue.Add: TUpdateQueueItem;
begin
  Result := TUpdateQueueItem.Create(Self);
  Add(Result);
end;

procedure TUpdateQueue.Clear;
begin
  while Count > 0 do
    Delete(0);
end;

function TUpdateQueue.FindPackageByType(aUpdateType: TUpdatePackageType): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if Self.Items[i].PackageType = aUpdateType then
    begin
      Result := i;
      Break;
    end;
end;

function TUpdateQueue.ContainsPackage(aUpdateType: TUpdatePackageType): Boolean;
begin
  Result := FindPackageByType(aUpdateType) >= 0;
end;

function TUpdateQueue.PackageInstalled(aUpdateType: TUpdatePackageType): Boolean;
var
  aInd: Integer;
begin
  aInd := FindPackageByType(aUpdateType);
  Result := (aInd >= 0) and (Items[aInd].Installed);
end;

procedure TUpdateQueue.Delete(aIndex: Integer);
begin
  TUpdateQueueItem(fList[aIndex]).Free;
  fList.Delete(aIndex);
end;

function TUpdateQueue.GetCount: Integer;
begin
  Result := fList.Count;
end;

function TUpdateQueue.GetItems(Index: Integer): TUpdateQueueItem;
begin
  Result := fList[Index];
end;

{ TUpdateQueueItem }

constructor TUpdateQueueItem.Create(aOwner: TUpdateQueue);
begin
  fOwner := aOwner;
  fNewVersions := TStringList.Create;
  fGetVersionRequiredAsDef := True; //взять VersionRequired для пакета из defaults - сбрасывается если вызывалось SetVersionRequired
end;

destructor TUpdateQueueItem.Destroy;
begin
  fNewVersions.Free;
  inherited;
end;

procedure TUpdateQueueItem.BeginInstall;
begin
  fInstalled := False;
  fUpdateResultCode := 0;
  fUpdateError := '';
  
  fTryInstalled := True;
  fUpdateInProgress := True;
end;

procedure TUpdateQueueItem.EndInstall;
begin
  fUpdateInProgress := False;
end;

function TUpdateQueueItem.CheckRequiresInstalled: Boolean;
var
  i: TUpdatePackageType;
begin
  Result := True;
  for i := Low(TUpdatePackageType) to High(TUpdatePackageType) do
    if i in fRequires then
    begin
      //нужный пакет есть в обновлении, но не был проинсталлирован
      if fOwner.ContainsPackage(i) and not fOwner.PackageInstalled(i) then
      begin
        Result := False;
        Break;
      end;
    end;
end;

function TUpdateQueueItem.GetPackageDescription: string;
begin
  if fPackageDescription <> '' then
    Result := fPackageDescription
  else //если описание не задано, возвращаем описание для типа
    Result := cWebUpdateTypeDescr[fPackageType];
end;

procedure TUpdateQueueItem.SetPackageDescription(const Value: string);
begin
  fPackageDescription := Value;
end;

procedure TUpdateQueueItem.SetPackageType(const Value: TUpdatePackageType);
begin
  fPackageType := Value;
  fPackageTypeCode := cWebUpdateTypeCodes[fPackageType]; //пересчитываем код
  UpdateRequires; //пересчитываем зависимости
end;

procedure TUpdateQueueItem.SetPackageTypeCode(const Value: string);
begin
  fPackageTypeCode := Value;
  fPackageType := RecognizeWebUpdateType(fPackageTypeCode); //распознаем тип по коду
  UpdateRequires; //пересчитываем зависимости
end;

procedure TUpdateQueueItem.UpdateRequires;
begin
  case fPackageType of
    wupData: fRequires := [];
    wupDataDiscret: fRequires := [];
    wupNews: fRequires := [];
    wupQuants: fRequires := [wupData, wupDataDiscret];
    
    wupPictsDiscret: fRequires := [];
    wupTyp: fRequires := [];
    wupTires: fRequires := [];
  else
    fRequires := [];
  end;
end;

function TUpdateQueueItem.GetVersionsRequired: Boolean;
begin
  if fGetVersionRequiredAsDef then //пока не вызывали сеттер - возвращаем по умолчанию для этого типа пакета
    Result := cWebUpdateTypeVersionRequired[fPackageType]
  else
    Result := fVersionsRequired;
end;

procedure TUpdateQueueItem.SetVersionsRequired(const Value: Boolean);
begin
  fGetVersionRequiredAsDef := False;
  fVersionsRequired := Value;
end;


end.
