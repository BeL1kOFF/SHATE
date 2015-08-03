unit ERP.Package.Components.TERPWebBrowser;

interface

uses
  Winapi.Windows,
  Winapi.ActiveX,
  System.Classes,
  System.Generics.Collections,
  Vcl.Menus,
  MSHTML,
  SHDocVw,
  idoc,
  ERP.Package.Components.TERPWebBrowserOptions;

type
  TERPWebBrowserServiceEvent = (seTemplateCheck);

  TERPWebBrowser = class(TWebBrowser, IDocHostUIHandler)
  // *****Работа с внутренним PopupMenu*****
  private
    FInnerPopupMenu: TPopupMenu;

    // Имя внутреннего PopupMenu
    function GetInnerPopupMenuName: TComponentName;
    // Имя внутреннего MenuItem Шаблоны
    function GetInnerPopupMenuTemplateName: TComponentName;
    // MenuItem Шаблоны
    function GetInnerPopupMenuTemplate: TMenuItem;

    // Создание внутреннего PopupMenu
    procedure CreateInnerPopupMenu;
    // Создание Шаблона в PopupMenu
    procedure CreateInnerPopupMenuTemplateItem(aMenuItem: TMenuItem; aWebBrowserTemplateItem: TCollectionItem);

    // Инициализация элементов PopupMenu
    procedure InitInnerPopupMenu;
    // Инициализация элементов MenuItem Шаблоны в PopupMenu
    procedure InitInnerPopupMenuTemplateList;

    // Событие появления PopupMenu
    procedure OnInnerPopupMenuPopup(aSender: TObject);
    // Событие выбора шаблона
    procedure OnInnerPopupMenuTemplateClick(aSender: TObject);

  // *****Работа с Шаблонами*****
  public
    // Установить активный шаблон
    procedure SetActiveTemplate(const aTemplateName: string);

  // *****Прочие методы*****
  private
    FERPOptions: TERPWebBrowserOptions;
    FServiceEventList: TDictionary<TERPWebBrowserServiceEvent, TList<TNotifyEvent>>;
    procedure SetERPOptions(aValue: TERPWebBrowserOptions);

    procedure InvokeServiceEvent(aServiceEvent: TERPWebBrowserServiceEvent; aSender: TObject);
  private // IDocHostUIHandler
    function ShowContextMenu(dwID: UINT; ppt: PtagPOINT; const pcmdtReserved: IUnknown;
                             const pdispReserved: IDispatch): HResult; stdcall;
    function GetHostInfo(var pInfo: _DOCHOSTUIINFO): HResult; stdcall;
    function ShowUI(dwID: UINT; const pActiveObject: IOleInPlaceActiveObject;
                    const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame;
                    const pDoc: IOleInPlaceUIWindow): HResult; stdcall;
    function HideUI: HResult; stdcall;
    function UpdateUI: HResult; stdcall;
    function EnableModeless(fEnable: Integer): HResult; stdcall;
    function OnDocWindowActivate(fActivate: Integer): HResult; stdcall;
    function OnFrameWindowActivate(fActivate: Integer): HResult; stdcall;
    function ResizeBorder(var prcBorder: tagRECT; const pUIWindow: IOleInPlaceUIWindow;
                          fRameWindow: Integer): HResult; stdcall;
    function TranslateAccelerator(var lpmsg: tagMSG; var pguidCmdGroup: TGUID; nCmdID: UINT): HResult; stdcall;
    function GetOptionKeyPath(out pchKey: PWideChar; dw: UINT): HResult; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HResult; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HResult; stdcall;
    function TranslateUrl(dwTranslate: UINT; pchURLIn: PWideChar; out ppchURLOut: PWideChar): HResult; stdcall;
    function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HResult; stdcall;
  protected
    procedure InvokeEvent(aDispID: TDispID; var aParams: TDispParams); override;
    procedure Loaded; override;
    procedure SetName(const aNewName: TComponentName); override;
    property PopupMenu; // Скрываем т.к. в нашем браузере будет свой popup
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure Navigate(aStreamAdapter: IStream); overload;

    procedure RegisterServiceEvent(aServiceEvent: TERPWebBrowserServiceEvent; aNotifyEvent: TNotifyEvent);
  published
    property ERPOptions: TERPWebBrowserOptions read FERPOptions write SetERPOptions;
  end;

implementation

uses
  System.SysUtils,
  ERP.Package.Components.TERPWebBrowserCollections;

{ TERPWebBrowser }

procedure TERPWebBrowser.AfterConstruction;
begin
  inherited AfterConstruction;
  if not (csDesigning in ComponentState) then
    inherited Navigate('about:blank');
end;

constructor TERPWebBrowser.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FERPOptions := TERPWebBrowserOptions.Create(Self);
  if csDesigning in ComponentState then
    FInnerPopupMenu := TPopupMenu.Create(Self)
  else
    FInnerPopupMenu := TPopupMenu.Create(Self.Owner);
  FInnerPopupMenu.OnPopup := OnInnerPopupMenuPopup;
  FServiceEventList := TDictionary<TERPWebBrowserServiceEvent, TList<TNotifyEvent>>.Create();
end;

procedure TERPWebBrowser.CreateInnerPopupMenu;
var
  MenuItem: TMenuItem;
begin
  MenuItem := FInnerPopupMenu.CreateMenuItem();
  MenuItem.Name := GetInnerPopupMenuTemplateName();
  MenuItem.Caption := 'Шаблоны';
  FInnerPopupMenu.Items.Add(MenuItem);
end;

procedure TERPWebBrowser.CreateInnerPopupMenuTemplateItem(aMenuItem: TMenuItem; aWebBrowserTemplateItem: TCollectionItem);
var
  MenuItem: TMenuItem;
begin
  MenuItem := FInnerPopupMenu.CreateMenuItem();
  MenuItem.RadioItem := True;
  MenuItem.GroupIndex := 1;
  MenuItem.Caption := (aWebBrowserTemplateItem as TERPWebBrowserTemplate).TemplateName;
  MenuItem.OnClick := OnInnerPopupMenuTemplateClick;
  MenuItem.Tag := Integer(aWebBrowserTemplateItem);
  if aWebBrowserTemplateItem.Index = FERPOptions.TemplateList.ActiveIndex then
    MenuItem.Checked := True;
  aMenuItem.Add(MenuItem);
end;

destructor TERPWebBrowser.Destroy;
var
  Pair: TPair<TERPWebBrowserServiceEvent, TList<TNotifyEvent>>;
begin
  for Pair in FServiceEventList do
    Pair.Value.Free();
  FServiceEventList.Free();
  FInnerPopupMenu.Free();
  FERPOptions.Free();
  inherited Destroy;
end;

function TERPWebBrowser.EnableModeless(fEnable: Integer): HResult;
begin
  Result := S_OK;
end;

function TERPWebBrowser.FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HResult;
begin
  Result := S_OK;
end;

function TERPWebBrowser.GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HResult;
begin
  Result := S_OK;
end;

function TERPWebBrowser.GetExternal(out ppDispatch: IDispatch): HResult;
begin
  Result := S_OK;
end;

function TERPWebBrowser.GetHostInfo(var pInfo: _DOCHOSTUIINFO): HResult;
begin
  Result := S_OK;
end;

function TERPWebBrowser.GetInnerPopupMenuName: TComponentName;
begin
  Result := TComponent(Self).Name + 'pmInnerPopupMenu';
end;

function TERPWebBrowser.GetInnerPopupMenuTemplate: TMenuItem;
var
  MenuItem: TMenuItem;
begin
  for MenuItem in FInnerPopupMenu.Items do
    if MenuItem.Name = GetInnerPopupMenuTemplateName() then
      Exit(MenuItem);
  Result := nil;
end;

function TERPWebBrowser.GetInnerPopupMenuTemplateName: TComponentName;
begin
  Result := FInnerPopupMenu.Name + 'miTemplateList';
end;

function TERPWebBrowser.GetOptionKeyPath(out pchKey: PWideChar; dw: UINT): HResult;
begin
  Result := S_OK;
end;

function TERPWebBrowser.HideUI: HResult;
begin
  Result := S_OK;
end;

procedure TERPWebBrowser.InitInnerPopupMenu;
begin
  CreateInnerPopupMenu();
end;

procedure TERPWebBrowser.InitInnerPopupMenuTemplateList;
var
  WebBrowserTemplate: TCollectionItem;
  MenuTemplate: TMenuItem;
begin
  MenuTemplate := GetInnerPopupMenuTemplate();
  if Assigned(MenuTemplate) then
  begin
    MenuTemplate.Clear();
    for WebBrowserTemplate in FERPOptions.TemplateList do
      CreateInnerPopupMenuTemplateItem(MenuTemplate, WebBrowserTemplate);
  end;
end;

procedure TERPWebBrowser.InvokeEvent(aDispID: TDispID; var aParams: TDispParams);
begin
  inherited InvokeEvent(aDispID, aParams);
  if aDispID = 259 then
    if Integer(DefaultInterface) = Integer(TVarData(aParams.rgvarg^[1]).VPointer) then
      FERPOptions.AppStop();
end;

procedure TERPWebBrowser.InvokeServiceEvent(aServiceEvent: TERPWebBrowserServiceEvent; aSender: TObject);
var
  Pair: TPair<TERPWebBrowserServiceEvent, TList<TNotifyEvent>>;
  ServiceEvent: TNotifyEvent;
begin
  for Pair in FServiceEventList do
    if Pair.Key = seTemplateCheck then
    begin
      for ServiceEvent in Pair.Value do
        ServiceEvent(aSender);
      Break;
    end;
end;

procedure TERPWebBrowser.Loaded;
begin
  inherited Loaded();
  InitInnerPopupMenu();
end;

procedure TERPWebBrowser.Navigate(aStreamAdapter: IStream);
begin
  FERPOptions.AppStart();
  (Document as IPersistStreamInit).Load(aStreamAdapter);
end;

function TERPWebBrowser.OnDocWindowActivate(fActivate: Integer): HResult;
begin
  Result := S_OK;
end;

function TERPWebBrowser.OnFrameWindowActivate(fActivate: Integer): HResult;
begin
  Result := S_OK;
end;

procedure TERPWebBrowser.OnInnerPopupMenuPopup(aSender: TObject);
begin
  InitInnerPopupMenuTemplateList();
end;

procedure TERPWebBrowser.OnInnerPopupMenuTemplateClick(aSender: TObject);
begin
  if not (aSender as TMenuItem).Checked then
  begin
    FERPOptions.TemplateList.ActiveIndex := TERPWebBrowserTemplate(Pointer((aSender as TMenuItem).Tag)).Index;
    InvokeServiceEvent(seTemplateCheck, Self);
  end;
end;

procedure TERPWebBrowser.RegisterServiceEvent(aServiceEvent: TERPWebBrowserServiceEvent; aNotifyEvent: TNotifyEvent);
var
  List: TList<TNotifyEvent>;
begin
  if not FServiceEventList.ContainsKey(aServiceEvent) then
  begin
    List := TList<TNotifyEvent>.Create();
    FServiceEventList.Add(aServiceEvent, List);
  end
  else
    List := FServiceEventList.Items[aServiceEvent];
  List.Add(aNotifyEvent);
end;

function TERPWebBrowser.ResizeBorder(var prcBorder: tagRECT; const pUIWindow: IOleInPlaceUIWindow;
  fRameWindow: Integer): HResult;
begin
  Result := S_OK;
end;

procedure TERPWebBrowser.SetActiveTemplate(const aTemplateName: string);
var
  WebBrowserTemplate: TERPWebBrowserTemplate;
begin
  for WebBrowserTemplate in FERPOptions.TemplateList do
    if WebBrowserTemplate.TemplateName.Equals(aTemplateName) then
    begin
      FERPOptions.TemplateList.ActiveIndex := WebBrowserTemplate.Index;
      Break;
    end;
end;

procedure TERPWebBrowser.SetERPOptions(aValue: TERPWebBrowserOptions);
begin
  FERPOptions.Assign(aValue);
end;

procedure TERPWebBrowser.SetName(const aNewName: TComponentName);
begin
  inherited SetName(aNewName);
  FInnerPopupMenu.Name := GetInnerPopupMenuName();
end;

function TERPWebBrowser.ShowContextMenu(dwID: UINT; ppt: PtagPOINT; const pcmdtReserved: IInterface;
  const pdispReserved: IDispatch): HResult;
var
  Handled: Boolean;
begin
  Handled := False;
  DoContextPopup(Point(ppt.x, ppt.y), Handled);
  if not Handled then
  begin
    if FInnerPopupMenu.AutoPopup then
    begin
      SendCancelMode(nil);
      FInnerPopupMenu.PopupComponent := Self;
      FInnerPopupMenu.Popup(ppt.x, ppt.y);
      Result := S_OK;
    end
    else
    begin
      Result := S_FALSE;
{      if Assigned(FOnShowContextMenu) then
        FOnShowContextMenu(Self, dwID, ppt, pcmdtReserved, pdispReserved, Result);}
    end;
  end
  else
    Result := S_OK;
end;

function TERPWebBrowser.ShowUI(dwID: UINT; const pActiveObject: IOleInPlaceActiveObject;
  const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HResult;
begin
  Result := S_OK;
end;

function TERPWebBrowser.TranslateAccelerator(var lpmsg: tagMSG; var pguidCmdGroup: TGUID; nCmdID: UINT): HResult;
begin
  Result := S_OK;
end;

function TERPWebBrowser.TranslateUrl(dwTranslate: UINT; pchURLIn: PWideChar; out ppchURLOut: PWideChar): HResult;
begin
  Result := S_OK;
end;

function TERPWebBrowser.UpdateUI: HResult;
begin
  Result := S_OK;
end;

end.
