unit ERP.Package.CustomClasses.TCustomPackageScan;

interface

uses
  System.Generics.Collections;

type
  TCustomPackageItem = class
  strict private
    FFileName: string;
    FHandle: HMODULE;
    function IsLibrary: Boolean;
  protected
    function CheckForExportedFunctions: Boolean; virtual; abstract;
    function IsExistsProc(const aProcName: string): Boolean;
  public
    destructor Destroy; override;
    function Open: Boolean; virtual;
    procedure Close; virtual;
    property Handle: HMODULE read FHandle;
    property FileName: string read FFileName write FFileName;
  end;

  TCustomPackageScanOnScanEvent = procedure (aIndex, aCount: Integer; const aFileName: string) of object;
  TCustomPackageScanOnErrorEvent = procedure (const aFileName, aError: string) of object;

  TCustomPackageScan = class
  strict private
    FCheckDuplicate: Boolean;
    FItems: TList<TCustomPackageItem>;
    FMultiMask: string;
    FMultiPath: string;
    FOnPackageScanOnScanEvent: TCustomPackageScanOnScanEvent;
    FOnPackageScanOnErrorEvent: TCustomPackageScanOnErrorEvent;
    function CheckForDuplicate(const aPackageName: string): Boolean;
    function GetCount: Integer;
    function GetPackageItem(aIndex: Integer): TCustomPackageItem;
    procedure Scan(const aPath, aMask: string; aIsOpen: Boolean);
  protected
    function CreateItem: TCustomPackageItem; virtual; abstract;
    property CheckDuplicate: Boolean read FCheckDuplicate write FCheckDuplicate;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    procedure Close;
    procedure MultiScan(aIsOpen: Boolean);
    property Count: Integer read GetCount;
    property Items[aIndex: Integer]: TCustomPackageItem read GetPackageItem; default;
    property MultiMask: string read FMultiMask write FMultiMask;
    property MultiPath: string read FMultiPath write FMultiPath;
    property OnPackageScanOnScanEvent: TCustomPackageScanOnScanEvent read FOnPackageScanOnScanEvent write FOnPackageScanOnScanEvent;
    property OnPackageScanOnErrorEvent: TCustomPackageScanOnErrorEvent read FOnPackageScanOnErrorEvent write FOnPackageScanOnErrorEvent;
  end;

implementation

uses
  Winapi.Windows,
  System.Types,
  System.SysUtils,
  System.Rtti,
  System.IOUtils,
  System.Classes;

{ TCustomPackageScan }

function TCustomPackageScan.CheckForDuplicate(const aPackageName: string): Boolean;
var
  RttiContext: TRttiContext;
  RttiPackage: TRttiPackage;
begin
  Result := False;
  if FCheckDuplicate then
  begin
    RttiContext := TRttiContext.Create();
    for RttiPackage in RttiContext.GetPackages() do
      if AnsiSameText(ExtractFileName(RttiPackage.Name), aPackageName) then
      begin
        Result := True;
        Break;
      end;
    RttiContext.Free();
  end;
end;

procedure TCustomPackageScan.Clear;
var
  PackageItem: TCustomPackageItem;
begin
  for PackageItem in FItems do
    PackageItem.Free();
  FItems.Clear();
end;

procedure TCustomPackageScan.Close;
var
  PackageItem: TCustomPackageItem;
begin
  for PackageItem in FItems do
    PackageItem.Close();
end;

constructor TCustomPackageScan.Create;
begin
  FMultiMask := '*.*';
  FMultiPath := '';
  FCheckDuplicate := False;
  FItems := TList<TCustomPackageItem>.Create();
  FOnPackageScanOnScanEvent := nil;
  FOnPackageScanOnErrorEvent := nil;
end;

destructor TCustomPackageScan.Destroy;
begin
  Clear();
  FItems.Free();
  inherited Destroy();
end;

function TCustomPackageScan.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TCustomPackageScan.GetPackageItem(aIndex: Integer): TCustomPackageItem;
begin
  Result := FItems.Items[aIndex];
end;

procedure TCustomPackageScan.MultiScan(aIsOpen: Boolean);
var
  tmpPathList: TStringList;
  tmpMaskList: TStringList;
  k, i: Integer;
begin
  tmpPathList := TStringList.Create();
  tmpMaskList := TStringList.Create();
  try
    tmpPathList.Text := FMultiPath;
    tmpMaskList.Text := FMultiMask;
    for k := 0 to tmpPathList.Count - 1 do
      for i := 0 to tmpMaskList.Count - 1 do
        Scan(tmpPathList.Strings[k], tmpMaskList.Strings[i], aIsOpen);
  finally
    tmpMaskList.Free();
    tmpPathList.Free();
  end;
end;

procedure TCustomPackageScan.Scan(const aPath, aMask: string; aIsOpen: Boolean);
var
  FileList: TStringDynArray;
  Item: TCustomPackageItem;
  k: Integer;
begin
  if TDirectory.Exists(IncludeTrailingPathDelimiter(aPath)) then
    FileList := TDirectory.GetFiles(IncludeTrailingPathDelimiter(aPath), aMask)
  else
    SetLength(FileList, 0);
  for k := 0 to Length(FileList) - 1 do
    if not CheckForDuplicate(ExtractFileName(FileList[k])) then
    begin
      Item := CreateItem();
      try
        Item.FileName := FileList[k];
        if Item.Open() then
        begin
          if not aIsOpen then
            Item.Close();
          if Assigned(FOnPackageScanOnScanEvent) then
            FOnPackageScanOnScanEvent(k + 1, Length(FileList), FileList[k]);
          FItems.Add(Item);
        end
        else
          Item.Free();
      except on E: Exception do
      begin
        Item.Free();
        if Assigned(FOnPackageScanOnErrorEvent) then
          FOnPackageScanOnErrorEvent(FileList[k], E.Message)
        else
          raise;
      end;
      end;
    end;
end;

{ TCustomPackageItem }

procedure TCustomPackageItem.Close;
begin
  if FHandle > 0 then
  begin
    if IsLibrary() then
      FreeLibrary(FHandle)
    else
      UnloadPackage(FHandle);
    FHandle := 0;
  end;
end;

destructor TCustomPackageItem.Destroy;
begin
  Close();
  inherited Destroy();
end;

function TCustomPackageItem.IsExistsProc(const aProcName: string): Boolean;
begin
  Result := GetProcAddress(FHandle, PChar(aProcName)) <> nil;
end;

function TCustomPackageItem.IsLibrary: Boolean;
begin
  Result := SameText(ExtractFileExt(FFileName), '.dll');
end;

function TCustomPackageItem.Open: Boolean;
begin
  if IsLibrary() then
    FHandle := LoadLibrary(PChar(FFileName))
  else
    FHandle := LoadPackage(FFileName);
  Result := FHandle > 0;
  if Result then
    Result := CheckForExportedFunctions();
end;

end.
