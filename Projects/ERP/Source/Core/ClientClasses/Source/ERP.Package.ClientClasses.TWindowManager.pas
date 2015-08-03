unit ERP.Package.ClientClasses.TWindowManager;

interface

uses
  System.Types,
  System.Generics.Collections,
  Vcl.Forms,
  cxGraphics,
  dxNavBarCollns,
  dxNavBar,
  dxSkinsdxNavBarPainter,
  cxPC,
  ERP.Package.ClientClasses.TPackageModuleScan,
  ERP.Package.ClientClasses.TPackageModuleOpen,
  ERP.Package.ClientInterface.IDBConnectionEx;

type
  TWindowManager = class
  private
    FFormList: TList<TPackageModuleOpen>;
    FPackageModuleOpenComparer: TPackageModuleOpenComparer;
    FcxImageList: TcxImageList;
    function AddIconToImageList(aHandle: THandle): Integer;
    function CreateGetGroup(adxNavBar: TdxNavBar; aName: string): TdxNavBarGroup;
    function GetChildForm(aIndexDBConnection: Integer; aGuid: TGUID): THandle;
    function GetCount: Integer;
    function GetIndexOfHandle(aHandle: THandle): Integer;
    procedure AddWindow(aPackageModuleOpen: TPackageModuleOpen);
    procedure RemoveWindow(aIndex: Integer);
    procedure OnNavBarItemClick(aSender: TObject);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddModule(aModuleItem: TPackageModuleItem; aDBConnectionEx: IDBConnectionEx;
      const aPageName: string);
    procedure CloseAll;
    procedure RemoveModule(aHandleForm: THandle);
    procedure Refresh(acxPageControl: TcxPageControl; aId_DataBase: Integer);
    procedure ResizeAll;
    procedure VisibleAll(aVisible: Boolean);
    property ChildForm[aIndexDBConnection: Integer; aGuid: TGUID]: THandle read GetChildForm; default;
    property Count: Integer read GetCount;
  end;

implementation

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  Vcl.Graphics,
  Vcl.Controls,
  ERP.Package.CustomClasses.Consts;

type
  ExceptionWindowManager = class(Exception);

{ TWindowManager }

function TWindowManager.AddIconToImageList(aHandle: THandle): Integer;
var
  icon: TIcon;
begin
  Result := -1;
  if aHandle > 0 then
  begin
    icon := TIcon.Create();
    try
      icon.SetSize(16, 16);
      icon.Handle := aHandle;
      Result := FcxImageList.AddIcon(icon);
    finally
      icon.Free();
    end;
  end;
end;

procedure TWindowManager.AddModule(aModuleItem: TPackageModuleItem; aDBConnectionEx: IDBConnectionEx;
  const aPageName: string);
var
  PackageModuleOpen: TPackageModuleOpen;
  Buffer: TBytes;
  k: Integer;
begin
  PackageModuleOpen := TPackageModuleOpen.Create(aDBConnectionEx);
  PackageModuleOpen.FileName := aModuleItem.FileName;
  PackageModuleOpen.PageName := aPageName;
  try
    if PackageModuleOpen.Open() then
    begin
      SetLength(buffer, Length(aModuleItem.Access));
      for k := 1 to Length(aModuleItem.Access) do
        Buffer[k - 1] := StrToInt(aModuleItem.Access[k]);
      if PackageModuleOpen.GetRegisterAccess.Count <> Length(Buffer) then
        raise ExceptionWindowManager.Create('В Модуле обнаружены не зарегистрированные права доступа.');
      PackageModuleOpen.CreateForm(Buffer);
      PackageModuleOpen.SendMainResize();
      AnimateWindow(PackageModuleOpen.FormHandle, 200, AW_ACTIVATE or AW_CENTER);
      AddWindow(PackageModuleOpen);
    end
    else
      PackageModuleOpen.Free();
  except
  begin
    PackageModuleOpen.Close();
    PackageModuleOpen.Free();
    raise;
  end;
  end;
end;

procedure TWindowManager.AddWindow(aPackageModuleOpen: TPackageModuleOpen);
begin
  FFormList.Add(aPackageModuleOpen);
end;

procedure TWindowManager.CloseAll;
var
  k: Integer;
begin
  for k := FFormList.Count - 1 downto 0 do
    SendMessage(FFormList[k].FormHandle, WM_CLOSE, 0, 0);
end;

constructor TWindowManager.Create;
begin
  FFormList := TList<TPackageModuleOpen>.Create();
  FcxImageList := TcxImageList.Create(nil);
  FcxImageList.SetSize(16, 16);
end;

function TWindowManager.CreateGetGroup(adxNavBar: TdxNavBar; aName: string): TdxNavBarGroup;
var
  k: Integer;
begin
  for k := 0 to adxNavBar.Groups.Count - 1 do
    if SameText(adxNavBar.Groups.Items[k].Caption, aName) then
    begin
      Result := adxNavBar.Groups.Items[k];
      Exit;
    end;
  Result := adxNavBar.Groups.Add;
  Result.Caption := aName;
end;

destructor TWindowManager.Destroy;
begin
  FcxImageList.Free();
  FFormList.Free();
  inherited Destroy();
end;

function TWindowManager.GetChildForm(aIndexDBConnection: Integer; aGuid: TGUID): THandle;
var
  k: Integer;
begin
  Result := 0;
  for k := 0 to FFormList.Count - 1 do
    if (FFormList.Items[k].ERPClientData.ERPApplication.ModuleConnection.Id_DataBase = aIndexDBConnection) and
       (FFormList.Items[k].GetModuleInfo.Guid = aGuid) then
    begin
      Result := FFormList.Items[k].FormHandle;
      Break;
    end;
end;

function TWindowManager.GetCount: Integer;
begin
  Result := FFormList.Count;
end;

function TWindowManager.GetIndexOfHandle(aHandle: THandle): Integer;
var
  k: Integer;
begin
  Result := -1;
  for k := 0 to FFormList.Count - 1 do
    if FFormList.Items[k].FormHandle = aHandle then
    begin
      Result := k;
      Break;
    end;
end;

procedure TWindowManager.OnNavBarItemClick(aSender: TObject);
var
  FormHandle: THandle;
begin
  FormHandle := TdxNavBarItem(aSender).Tag;
  SetWindowPos(FormHandle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
end;

procedure TWindowManager.Refresh(acxPageControl: TcxPageControl; aId_DataBase: Integer);
var
  k: Integer;
  indexPage: Integer;
  dxNavBar: TdxNavBar;
  dxNavBarGroup: TdxNavBarGroup;
  dxNavBarItem: TdxNavBarItem;
  smallImageIndex: Integer;
  cxTabSheet: TcxTabSheet;
  ActiveIndexPage: Integer;
  PackageModuleOpen: TPackageModuleOpen;

  function GetIndexPageFromDB(aId_DataBase: Integer): Integer;
  var
    k: Integer;
  begin
    Result := -1;
    for k := 0 to acxPageControl.PageCount - 1 do
      if acxPageControl.Pages[k].Tag = aId_DataBase then
      begin
        Result := k;
        Break;
      end;
  end;

begin
  for k := acxPageControl.PageCount - 1 downto 0 do
    acxPageControl.Pages[k].Free();
  FcxImageList.Clear();
  ActiveIndexPage := -1;
  FPackageModuleOpenComparer := TPackageModuleOpenComparer.Create();
  try
    FFormList.Sort(FPackageModuleOpenComparer);
  finally
    FPackageModuleOpenComparer.Free();
  end;
  for k := 0 to FFormList.Count - 1 do
  begin
    PackageModuleOpen := FFormList.Items[k];
    indexPage := GetIndexPageFromDB(PackageModuleOpen.ERPClientData.ERPApplication.ModuleConnection.Id_DataBase);
    if indexPage = -1 then
    begin
      cxTabSheet := TcxTabSheet.Create(acxPageControl);
      cxTabSheet.Caption := PackageModuleOpen.ERPClientData.ERPApplication.ModuleConnection.DataBaseCaption;
      cxTabSheet.Tag := PackageModuleOpen.ERPClientData.ERPApplication.ModuleConnection.Id_DataBase;
      cxTabSheet.Parent := acxPageControl;
      indexPage := acxPageControl.PageCount - 1;
      dxNavBar := TdxNavBar.Create(acxPageControl.Pages[indexPage]);
      dxNavBar.Name := 'dxNavBar';
      dxNavBar.Parent := acxPageControl.Pages[indexPage];
    end
    else
      dxNavBar := acxPageControl.Pages[indexPage].FindComponent('dxNavBar') as TdxNavBar;
    if acxPageControl.Pages[indexPage].Tag = aId_DataBase then
      ActiveIndexPage := indexPage;
    dxNavBar.Align := alClient;
    dxNavBar.OptionsImage.SmallImages := FcxImageList;
    dxNavBar.OptionsView.NavigationPane.ShowOverflowPanel := False;
    dxNavBar.ViewStyle := TdxNavBarSkinExplorerBarPainter.Create(dxNavBar);
    dxNavBar.BeginUpdate();
    try
      smallImageIndex := AddIconToImageList(PackageModuleOpen.GetIcon(16));
      dxNavBarGroup := CreateGetGroup(dxNavBar, PackageModuleOpen.PageName);
      dxNavBarItem := dxNavBar.Items.Add;
      dxNavBarItem.SmallImageIndex := smallImageIndex;
      dxNavBarItem.Caption := PackageModuleOpen.GetModuleInfo.Name;
      dxNavBarItem.OnClick := OnNavBarItemClick;
      dxNavBarItem.Tag := PackageModuleOpen.FormHandle;
      dxNavBarGroup.CreateLink(dxNavBarItem);
    finally
      dxNavBar.EndUpdate();
    end;
  end;
  if ActiveIndexPage <> -1 then
    acxPageControl.ActivePageIndex := ActiveIndexPage
  else
    if acxPageControl.PageCount > 0 then
      acxPageControl.ActivePageIndex := 0;
end;

procedure TWindowManager.RemoveModule(aHandleForm: THandle);
var
  index: Integer;
begin
  index := GetIndexOfHandle(aHandleForm);
  FFormList.Items[index].Close();
  FFormList.Items[index].Free();
  RemoveWindow(index);
end;

procedure TWindowManager.RemoveWindow(aIndex: Integer);
begin
  FFormList.Delete(aIndex);
end;

procedure TWindowManager.ResizeAll;
var
  k: Integer;
begin
  for k := 0 to FFormList.Count - 1 do
    FFormList[k].SendMainResize();
end;

procedure TWindowManager.VisibleAll(aVisible: Boolean);
var
  k: Integer;
  WindowPosType: Cardinal;
begin
  WindowPosType := SWP_NOSIZE or SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE;
  if aVisible then
    WindowPosType := WindowPosType or SWP_SHOWWINDOW
  else
    WindowPosType := WindowPosType or SWP_HIDEWINDOW;
  for k := 0 to FFormList.Count - 1 do
    SetWindowPos(FFormList[k].FormHandle, 0, 0, 0, 0, 0, WindowPosType);
end;

end.
