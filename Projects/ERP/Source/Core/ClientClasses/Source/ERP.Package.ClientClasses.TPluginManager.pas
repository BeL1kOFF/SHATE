unit ERP.Package.ClientClasses.TPluginManager;

interface

uses
  System.Classes,
  System.Generics.Collections,
  cxGraphics,
  dxRibbon,
  ERP.Package.ClientClasses.TPackageModuleScan,
  ERP.Package.ClientClasses.TMenuDesignManager;

type
  PAccessModuleList = ^TAccessModuleList;
  TAccessModuleList = packed record
    GUID: TGUID;
    Access: string;
  end;

  TPluginManager = class
  private
    FPackageModuleScan: TPackageModuleScan;
    FAccessModuleList: TList<PAccessModuleList>;{ TODO 1 : Может выделить отдельный класс??? }
    FMenuDesignManager: TMenuDesignManager;
    FRibbonTabs: TDictionary<Integer, TdxRibbonTab>;
    FRibbonTabGroups: TDictionary<Integer, TdxRibbonTabGroup>;
    function AddIconToImageList(acxImageList: TcxImageList; aHandle: THandle): Integer;
    function IsAccessGuid(aGuid: TGUID): Integer;
    procedure ClearRibbon(adxRibbon: TdxRibbon);
    procedure CreateRibbonTab(adxRibbon: TdxRibbon; aMenuDesign: TMenuDesignItem);
    procedure CreateRibbonTabGroup(adxRibbon: TdxRibbon; aMenuDesign: TMenuDesignItem);
    procedure CreateLargeButton(adxRibbon: TdxRibbon; aMenuDesign: TMenuDesignItem; acxImageList: TcxImageList;
      aOnLargeButtonClick: TNotifyEvent);
  public
    constructor Create;
    destructor Destroy; override;

    procedure ClearAccessModuleList;
    procedure CreateMenu(adxRibbon: TdxRibbon; acxImageList: TcxImageList; aOnLargeButtonClick: TNotifyEvent);
    procedure LoadPluginList;
    property PackageModuleScan: TPackageModuleScan read FPackageModuleScan;
    property AccessModuleList: TList<PAccessModuleList> read FAccessModuleList;
    property MenuDesignManager: TMenuDesignManager read FMenuDesignManager;
  end;

implementation

uses
  Winapi.Messages,
  Winapi.Windows,
  System.SysUtils,
  Vcl.Graphics,
  Vcl.Forms,
  dxBar,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.ClientClasses.ERPOptions;

function GetOptions: IXMLOptionsType;
begin
  Result := LoadOptions(ExtractFilePath(Application.ExeName) + 'ERP.xml');
end;

{ TPluginManager }

function TPluginManager.AddIconToImageList(acxImageList: TcxImageList; aHandle: THandle): Integer;
var
  icon: TIcon;
begin
  Result := -1;
  if aHandle > 0 then
  begin
    icon := TIcon.Create();
    try
      icon.SetSize(32, 32);
      icon.Handle := aHandle;
      Result := acxImageList.AddIcon(icon);
    finally
      icon.Free();
    end;
  end;
end;

procedure TPluginManager.ClearAccessModuleList;
var
  k: Integer;
begin
  for k := 0 to FAccessModuleList.Count - 1 do
    Dispose(FAccessModuleList.Items[k]);
  FAccessModuleList.Clear();
end;

procedure TPluginManager.ClearRibbon(adxRibbon: TdxRibbon);
var
  k, i, j: Integer;
begin
  for k := adxRibbon.Tabs.Count - 1 downto 0 do
  begin
    for i := adxRibbon.Tabs.Items[k].Groups.Count - 1 downto 0 do
    begin
      for j := adxRibbon.Tabs.Items[k].Groups.Items[i].ToolBar.ItemLinks.Count - 1 downto 0 do
        adxRibbon.Tabs.Items[k].Groups.Items[i].ToolBar.ItemLinks.Items[j].Free();
      adxRibbon.Tabs.Items[k].Groups.Items[i].ToolBar.Free();
    end;
    adxRibbon.Tabs.Items[k].Free();
  end;
end;

constructor TPluginManager.Create;
begin
  FPackageModuleScan := TPackageModuleScan.Create();
  FAccessModuleList := TList<PAccessModuleList>.Create();
  FMenuDesignManager := TMenuDesignManager.Create();
  FRibbonTabs := TDictionary<Integer, TdxRibbonTab>.Create();
  FRibbonTabGroups := TDictionary<Integer, TdxRibbonTabGroup>.Create();
end;

procedure TPluginManager.CreateLargeButton(adxRibbon: TdxRibbon; aMenuDesign: TMenuDesignItem;
  acxImageList: TcxImageList; aOnLargeButtonClick: TNotifyEvent);
var
  PackageModuleItem: TPackageModuleItem;
  IndexAccessModule: Integer;
  LargeImageIndex: Integer;
  BarLargeButton: TdxBarLargeButton;
  RibbonTabGroup: TdxRibbonTabGroup;

  function GetRibbonTabGroup(const aId_MenuDesign: Integer): TdxRibbonTabGroup;
  begin
    if not FRibbonTabGroups.TryGetValue(aId_MenuDesign, Result) then
    begin
      Result := nil;
    end;
  end;

begin
  PackageModuleItem := FPackageModuleScan.Items[aMenuDesign.Guid];
  if Assigned(PackageModuleItem) then
  begin
    if not PackageModuleItem.IsCorrupt then
      try
        if PackageModuleItem.Open() then
        begin
          IndexAccessModule := IsAccessGuid(aMenuDesign.Guid);
          if IndexAccessModule > -1 then
          begin
            LargeImageIndex := AddIconToImageList(acxImageList, PackageModuleItem.GetIcon(32));
            BarLargeButton := TdxBarLargeButton.Create(adxRibbon);
            BarLargeButton.Caption := aMenuDesign.Caption;
            BarLargeButton.LargeImageIndex := LargeImageIndex;
            PackageModuleItem.Access := FAccessModuleList.Items[IndexAccessModule]^.Access;
            BarLargeButton.Data := PackageModuleItem;
            BarLargeButton.OnClick := aOnLargeButtonClick;
            RibbonTabGroup := GetRibbonTabGroup(aMenuDesign.Id_MenuDesignParent);
            RibbonTabGroup.ToolBar.ItemLinks.Add.Item := BarLargeButton;
          end;
          PackageModuleItem.Close();
        end
        else
          PackageModuleItem.IsCorrupt := True;
      except
      begin
        PackageModuleItem.IsCorrupt := True;
        PackageModuleItem.Close();
      end;
      end;
  end;
end;

procedure TPluginManager.CreateMenu(adxRibbon: TdxRibbon; acxImageList: TcxImageList; aOnLargeButtonClick: TNotifyEvent);
var
  k: Integer;
begin
  CreateSQLCursor();
  ClearRibbon(adxRibbon);
  for k := 0 to FMenuDesignManager.Count - 1 do
  begin
    case FMenuDesignManager.Items[k].Level of
      1:
        CreateRibbonTab(adxRibbon, FMenuDesignManager.Items[k]);
      2:
        CreateRibbonTabGroup(adxRibbon, FMenuDesignManager.Items[k]);
      3:
        CreateLargeButton(adxRibbon, FMenuDesignManager.Items[k], acxImageList, aOnLargeButtonClick);
    end;
  end;
end;

procedure TPluginManager.CreateRibbonTab(adxRibbon: TdxRibbon; aMenuDesign: TMenuDesignItem);
var
  RibbonTab: TdxRibbonTab;
begin
  RibbonTab := adxRibbon.Tabs.Add();
  RibbonTab.Caption := aMenuDesign.Caption;
  FRibbonTabs.AddOrSetValue(aMenuDesign.Id_MenuDesign, RibbonTab);
end;

procedure TPluginManager.CreateRibbonTabGroup(adxRibbon: TdxRibbon; aMenuDesign: TMenuDesignItem);
var
  RibbonTab: TdxRibbonTab;
  RibbonTabGroup: TdxRibbonTabGroup;

  function GetRibbonTab(const aId_MenuDesign: Integer): TdxRibbonTab;
  begin
    if not FRibbonTabs.TryGetValue(aId_MenuDesign, Result) then
    begin
      Result := nil;
    end;
  end;

begin
  RibbonTab := GetRibbonTab(aMenuDesign.Id_MenuDesignParent);

  if Assigned(RibbonTab) then
  begin
    RibbonTabGroup := RibbonTab.Groups.Add;
    RibbonTabGroup.ToolBar := (RibbonTab.GetParentComponent as TdxRibbon).BarManager.AddToolBar();
    RibbonTabGroup.CanCollapse := False;
    RibbonTabGroup.Caption := aMenuDesign.Caption;
    FRibbonTabGroups.AddOrSetValue(aMenuDesign.Id_MenuDesign, RibbonTabGroup);
  end;
end;

destructor TPluginManager.Destroy;
begin
  FRibbonTabGroups.Free();
  FRibbonTabs.Free();
  FMenuDesignManager.Free();
  ClearAccessModuleList();
  FAccessModuleList.Free();
  FPackageModuleScan.Free();
  inherited Destroy();
end;

function TPluginManager.IsAccessGuid(aGuid: TGUID): Integer;
var
  k: Integer;
  tmpGuid: TGUID;
begin
  Result := -1;
  for k := 0 to FAccessModuleList.Count - 1 do
  begin
    tmpGuid := FAccessModuleList.Items[k]^.GUID;
    if tmpGuid = aGuid then
    begin
      Result := k;
      Break;
    end;
  end;
end;

procedure TPluginManager.LoadPluginList;
var
  k: Integer;
  tmpString: string;
begin
  tmpString := '';
  for k := 0 to GetOptions().Packages.Count - 1 do
    tmpString := tmpString + ExtractFilePath(Application.ExeName) + GetOptions().Packages.Path[k] + #13#10;
  Delete(tmpString, Length(tmpString) - 1, 2);
  FPackageModuleScan.MultiPath := tmpString;
  FPackageModuleScan.MultiMask := '*.bpl'#13#10'*.dll';
  FPackageModuleScan.Clear();
  FPackageModuleScan.MultiScan(False);
end;

end.
