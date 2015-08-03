unit ERP.Package.MainForm.UI.Main;

interface

uses
  System.Types,
  Winapi.Windows,
  Winapi.Messages,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  dxBar,
  dxRibbonSkins,
  cxClasses,
  dxRibbon,
  dxSkinsCore,
  dxSkinCaramel,
  dxSkinsdxNavBarPainter,
  dxSkinsdxBarPainter,
  dxSkinsForm,
  dxSkinsdxRibbonPainter,
  dxRibbonBackstageView,
  cxContainer,
  cxEdit,
  cxLabel,
  cxTextEdit,
  cxMaskEdit,
  cxDropDownEdit,
  ERP.Package.CustomClasses.Consts, cxBarEditItem, cxPCdxBarPopupMenu, cxPC, dxSkinscxPCPainter, cxSplitter, cxImageComboBox,
  Vcl.ImgList, Vcl.AppEvnts, Vcl.ActnList,
  dxRibbonCustomizationForm, dxBarBuiltInMenu, System.Actions,
  System.Win.ScktComp,
  ERP.Package.MainForm.UI.Splash,
  ERP.Package.ClientClasses.TERPSocketClient,
  ERP.Package.ClientClasses.TPackageModuleScan,
  ERP.Package.ClientClasses.Types;

type
  TfrmMain = class(TForm)
    dxBarManager: TdxBarManager;
    dxRibbon: TdxRibbon;
    dxSkinController: TdxSkinController;
    dxRibbonBackstageView: TdxRibbonBackstageView;
    tbQuickAccess: TdxBar;
    dxRibbonBackstageViewTabSheet1: TdxRibbonBackstageViewTabSheet;
    cbDBList: TcxComboBox;
    cxLabel1: TcxLabel;
    cxLookAndFeelController: TcxLookAndFeelController;
    lDataBaseName: TcxBarEditItem;
    pcWindowManager: TcxPageControl;
    splMain: TcxSplitter;
    cxImageList: TcxImageList;
    ApplicationEvents: TApplicationEvents;
    btnRefresh: TButton;
    ActionList: TActionList;
    acRefresh: TAction;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cbDBListPropertiesChange(Sender: TObject);
    procedure splMainMoved(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplicationEventsMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure dxRibbonBackstageViewPopup(Sender: TObject);
    procedure dxRibbonBackstageViewCloseUp(Sender: TObject);
    procedure acRefreshExecute(Sender: TObject);
    procedure acRefreshUpdate(Sender: TObject);
    procedure dxRibbonResize(Sender: TObject);
  private
    FSplash: TfrmSplash;
    function GetTabFromPackage(aModuleItem: TPackageModuleItem): TdxRibbonTab;
    procedure DoCommand(aCommand: Integer);
    procedure DoError(Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DoLogger(const aEvent: TClientConnectionLoggerEventType; Socket: TCustomWinSocket);
    procedure EnabledUserControls(aValue: Boolean);
    procedure ERPShowError(const aMessage: string);
    procedure ERPShowWarning(const aMessage: string);
    procedure Init;
    procedure LoadPlugin;
    procedure OnLargeButtonClick(aSender: TObject);
    procedure OpenModule(aId_DataBase: Integer; aModuleItem: TPackageModuleItem; const aTabCaption: string);
    procedure NotifyResize;

    procedure WMChildClose(var aMessage: TMessage); message ERPM_CHILD_CLOSE;
    procedure WMERPAppGetClientRect(var aMessage: TMessage); message ERPM_APP_GET_CLIENTRECT;
    procedure WMERPAppModuleOpen(var aMessage: TMessage); message ERPM_APP_MODULE_OPEN;
    procedure WMMove(var aMessage: TWMMove); message WM_MOVE;
  public
    function GetMainSize: TRect;
  end;

function RegisterMainForm: TFormClass; stdcall;

exports RegisterMainForm;

implementation

{$R *.dfm}

uses
  System.SysUtils,
  dxNavBarCollns,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.ClientClasses.Variable,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.ClientInterface.IERPApplication,
  ERP.Package.ClientClasses.TERPApplication;

resourcestring
  RsError = 'Ошибка';
  RsWarning = 'Предупреждение';
  RsConnectFailed = 'Подключение к серверу не доступно!'#13#10'Приложение будет закрыто';
  RsLimitOpenWindows = 'Достигнут лимит открытых окон!';
  RsFormNotLoad = 'Форма %s не может быть загружена.' + #13#10'Ошибка: %s';
  RsModuleNotFound = 'Модуль %s не найден.';
  RsNotSupportOpenDB = 'Поддержка открытия модуля в отличной от текущей БД не поддерживается.'#13#10'Текущая: %d'#13#10'Требуемая: %d';

function RegisterMainForm: TFormClass;
begin
  Result := TfrmMain;
end;

{ TfrmMain }

procedure TfrmMain.acRefreshExecute(Sender: TObject);
begin
  EnabledUserControls(False);
  CreateSQLCursor();
  ClientManager.WindowManager.CloseAll();
  ClientManager.PluginManager.PackageModuleScan.OnPackageScanOnScanEvent := nil;
  ClientManager.PluginManager.PackageModuleScan.OnPackageScanOnErrorEvent := nil;
  ClientManager.PluginManager.LoadPluginList();
  LoadPlugin();
end;

procedure TfrmMain.acRefreshUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := cbDBList.ItemIndex > -1;
end;

procedure TfrmMain.ApplicationEventsMessage(var Msg: tagMSG; var Handled: Boolean);
begin
  if (Msg.message = ERPM_CHILD_CLOSE) and (Msg.hwnd = Application.Handle) then
  begin
    SendMessage(Handle, Msg.message, Msg.wParam, Msg.lParam);
    Handled := True;
  end;
end;

procedure TfrmMain.cbDBListPropertiesChange(Sender: TObject);
var
  id_DataBase: Integer;
begin
  EnabledUserControls(False);
  id_DataBase := Integer((Sender as TcxComboBox).Properties.Items.Objects[(Sender as TcxComboBox).ItemIndex]);
  ClientManager.DBConnectionManager.SetActiveConnection(id_DataBase);
  lDataBaseName.Caption := ClientManager.DBConnectionManager.ActiveConnection.DataBaseCaption;
  LoadPlugin();
end;

procedure TfrmMain.splMainMoved(Sender: TObject);
begin
  NotifyResize();
end;

procedure TfrmMain.DoCommand(aCommand: Integer);
begin
  case aCommand of
    SERVER_COMMAND_RESULTMENU:
    begin
      ClientManager.PluginManager.CreateMenu(dxRibbon, cxImageList, OnLargeButtonClick);
      EnabledUserControls(True);
    end;
  end;
end;

procedure TfrmMain.DoError(Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  ERPShowError(SysErrorMessage(ErrorCode));
  ErrorCode := 0;
end;

procedure TfrmMain.DoLogger(const aEvent: TClientConnectionLoggerEventType; Socket: TCustomWinSocket);
begin
  case aEvent of
    ccletDisconnect:
    begin
      ERPShowError(RsConnectFailed);
      Close();
    end;
  end;
end;

procedure TfrmMain.dxRibbonBackstageViewCloseUp(Sender: TObject);
begin
  ClientManager.WindowManager.VisibleAll(True);
end;

procedure TfrmMain.dxRibbonBackstageViewPopup(Sender: TObject);
begin
  ClientManager.WindowManager.VisibleAll(False);
end;

procedure TfrmMain.dxRibbonResize(Sender: TObject);
begin
  NotifyResize();
end;

procedure TfrmMain.EnabledUserControls(aValue: Boolean);
begin
  dxRibbon.Enabled := aValue;
  dxRibbonBackstageView.Enabled := aValue;
  if aValue then
  begin
    FSplash.Close();
    FSplash.Free();
    dxRibbonBackstageView.EndUpdate();
    dxBarManager.EndUpdate();
    Cursor := crDefault;
  end
  else
  begin
    Cursor := crHourGlass;
    dxBarManager.BeginUpdate();
    dxRibbonBackstageView.BeginUpdate();
    FSplash := TfrmSplash.Create(Self);
    FSplash.Show();
  end;
end;

procedure TfrmMain.ERPShowError(const aMessage: string);
begin
  Application.MessageBox(PChar(aMessage), PChar(RsError), MB_OK or MB_ICONERROR);
end;

procedure TfrmMain.ERPShowWarning(const aMessage: string);
begin
  Application.MessageBox(PChar(aMessage), PChar(RsWarning), MB_OK or MB_ICONWARNING);
end;

procedure TfrmMain.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  if (NewWidth < pcWindowManager.Width + pcWindowManager.Left + Screen.Width * 0.3) or (NewHeight < dxRibbon.Height + dxRibbon.Top + Screen.Height * 0.3) then
    Resize := False;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClientManager.WindowManager.CloseAll();
  PostMessage(Handle, WM_DESTROY, 0, 0); //Без этой строки, если открыто 1 дочернее окно, то приложение может не закрыться.
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Application.CreateForm(TGDDM, GDDM);
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  NotifyResize();
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  Init();
end;

function TfrmMain.GetMainSize: TRect;
var
  WidthBorder: Integer;
  HeightBorder: Integer;
  HeightCaption: Integer;
  TopLeft: TPoint;
begin
  WidthBorder := (Width - ClientWidth) div 2;
  HeightBorder := WidthBorder;
  HeightCaption := Height - ClientHeight - HeightBorder;
  TopLeft.Create(WidthBorder + splMain.Left + splMain.Width, HeightCaption + dxRibbon.Top + dxRibbon.Height);
  Result.Create(TopLeft,
                Width - TopLeft.X - WidthBorder,
                Height - TopLeft.Y - HeightBorder);
end;

function TfrmMain.GetTabFromPackage(aModuleItem: TPackageModuleItem): TdxRibbonTab;
var
  k, i, j: Integer;
begin
  for k := 0 to dxRibbon.Tabs.Count - 1 do
    for i := 0 to dxRibbon.Tabs.Items[k].Groups.Count - 1 do
      for j := 0 to dxRibbon.Tabs.Items[k].Groups.Items[i].ToolBar.ItemLinks.Count - 1 do
        if dxRibbon.Tabs.Items[k].Groups.Items[i].ToolBar.ItemLinks[j].Item.Data = aModuleItem then
          Exit(dxRibbon.Tabs.Items[k]);
  Result := nil;
end;

procedure TfrmMain.Init;
var
  k: Integer;
begin
  ClientManager.SocketClient.SetSocketEvent(DoError, DoLogger, DoCommand);
  cbDBList.Properties.Items.Clear();
  for k := 0 to ClientManager.DBConnectionManager.Count - 1 do
    cbDBList.Properties.Items.AddObject(ClientManager.DBConnectionManager.Items[k].DataBaseCaption, TObject(ClientManager.DBConnectionManager.Items[k].Id_DataBase));
end;

procedure TfrmMain.LoadPlugin;
begin
  ClientManager.SocketClient.SendForLoadModule(ClientManager.DBConnectionManager.Id_User, ClientManager.DBConnectionManager.ActiveConnection.Id_DataBase);
end;

procedure TfrmMain.NotifyResize;
begin
  ClientManager.WindowManager.ResizeAll();
end;

procedure TfrmMain.OnLargeButtonClick(aSender: TObject);
var
  LargeButton: TdxBarLargeButton;
  PackageModuleItem: TPackageModuleItem;
  Caption: string;
begin
  CreateSQLCursor();
  LargeButton := aSender as TdxBarLargeButton;
  PackageModuleItem := LargeButton.Data as TPackageModuleItem;
  Caption := (LargeButton.ClickItemLink.BarControl as TdxRibbonGroupBarControl).Group.Tab.Caption;
  OpenModule(ClientManager.DBConnectionManager.ActiveConnection.Id_DataBase, PackageModuleItem, Caption);
end;

procedure TfrmMain.OpenModule(aId_DataBase: Integer; aModuleItem: TPackageModuleItem; const aTabCaption: string);
var
  FormHandle: HWND;
begin
  FormHandle := ClientManager.WindowManager.ChildForm[aId_DataBase, aModuleItem.GetModuleInfo().GUID];
  if FormHandle = 0 then
  begin
    try{ TODO 1 : В будущем заменить значение 15 на константу из настроек }
      if ClientManager.WindowManager.Count < 15 then
      begin
        ClientManager.WindowManager.AddModule(aModuleItem, ClientManager.DBConnectionManager.GetDBConnectionEx(aId_DataBase), aTabCaption);
        ClientManager.WindowManager.Refresh(pcWindowManager, aId_DataBase);
      end
      else
        ERPShowWarning(RsLimitOpenWindows);
    except on E: Exception do
      ERPShowError(Format(RsFormNotLoad, [aModuleItem.FileName, E.ToString]));
    end;
  end
  else
  begin
    SetWindowPos(FormHandle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
    ClientManager.WindowManager.Refresh(pcWindowManager, aId_DataBase);
  end;
end;

procedure TfrmMain.WMChildClose(var aMessage: TMessage);
begin
  ClientManager.WindowManager.RemoveModule(aMessage.WParam);
  ClientManager.WindowManager.Refresh(pcWindowManager, pcWindowManager.ActivePage.Tag);
end;

procedure TfrmMain.WMERPAppGetClientRect(var aMessage: TMessage);
var
  RectClient: TRect;
begin
  RectClient := GetMainSize();
  PRect(aMessage.WParam)^.Create(RectClient.Left + Left, RectClient.Top + Top, RectClient.Right + Left, RectClient.Bottom + Top);
  aMessage.Result := aMessage.WParam;
end;

procedure TfrmMain.WMERPAppModuleOpen(var aMessage: TMessage);
var
  ModuleItem: TPackageModuleItem;
  Id_DataBase: Integer;
  Guid: TGUID;
begin
  Id_DataBase := TOpenModuleInfo(Pointer(aMessage.WParam)^).Id_DataBase;
  if Id_DataBase = ClientManager.DBConnectionManager.ActiveConnection.Id_DataBase then
  begin
    Guid := TOpenModuleInfo(Pointer(aMessage.WParam)^).Guid;
    ModuleItem := ClientManager.PluginManager.PackageModuleScan.Items[Guid];
    if Assigned(ModuleItem) then
      OpenModule(Id_DataBase, ModuleItem, GetTabFromPackage(ModuleItem).Caption)
    else
      ERPShowError(Format(RsModuleNotFound, [GUIDToString(Guid)]));
  end
  else
    ERPShowError(Format(RsNotSupportOpenDB, [ClientManager.DBConnectionManager.ActiveConnection.Id_DataBase, Id_DataBase]));
end;

procedure TfrmMain.WMMove(var aMessage: TWMMove);
begin
  NotifyResize();
end;

end.
