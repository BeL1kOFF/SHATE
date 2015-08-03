unit MDM.Catalog.UI.TradeMark;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Actions,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.ActnList,
  Vcl.Menus,
  Vcl.ImgList,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  FireDAC.Stan.Async,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  cxClasses,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxStyles,
  cxCustomData,
  cxFilter,
  cxData,
  cxDataStorage,
  cxEdit,
  cxNavigator,
  cxGridCustomView,
  cxGridCustomTableView,
  cxGridTableView,
  cxGridLevel,
  cxGrid,
  cxCheckBox,
  cxImage,
  cxGridCustomPopupMenu,
  cxGridPopupMenu,
  cxPC,
  dxBar,
  dxBarBuiltInMenu,
  ShateM.Components.TsmGridColumnHide,
  ShateM.Components.TCustomTempTable,
  ShateM.Components.TFireDACTempTable,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess,
  MDM.Package.Components.CustomCatalogTableView,
  MDM.Package.Components.CatalogTableViewClean,
  MDM.Package.Components.CatalogAction, MDM.Package.Components.CustomCatalogColumn,
  MDM.Package.Components.CatalogCleanColumn, MDM.Package.Components.CatalogTableViewDraft,
  MDM.Package.Components.CatalogDraftColumn, Vcl.OleCtrls, SHDocVw, ERP.Package.Components.TERPWebBrowser, cxSplitter;

type
  TfrmMDMTradeMark = class(TERPCustomForm)
    dxBarManager: TdxBarManager;
    btnDraftRefresh: TdxBarLargeButton;
    gpmTradeMarkDraft: TcxGridPopupMenu;
    pmGridHeaderTMDraft: TPopupMenu;
    miTMDraftColumn: TMenuItem;
    btnDraftAdd: TdxBarLargeButton;
    btnDraftEdit: TdxBarLargeButton;
    btnDraftDelete: TdxBarLargeButton;
    btnDraftApprove: TdxBarLargeButton;
    pcTradeMark: TcxPageControl;
    tsDraft: TcxTabSheet;
    cxGridTMD: TcxGrid;
    cxLevelTMD: TcxGridLevel;
    tsClean: TcxTabSheet;
    btnTMToDraft: TdxBarLargeButton;
    btnTMExport: TdxBarLargeButton;
    btnDraftImport: TdxBarLargeButton;
    btnDraftReady: TdxBarLargeButton;
    cxGridTM: TcxGrid;
    cxLevelTM: TcxGridLevel;
    btnTMRestore: TdxBarLargeButton;
    gpmTradeMark: TcxGridPopupMenu;
    pmGridHeaderTM: TPopupMenu;
    miTMColumn: TMenuItem;
    ilImage32: TcxImageList;
    barDraft: TdxBar;
    barTM: TdxBar;
    barDockDraft: TdxBarDockControl;
    barDockTM: TdxBarDockControl;
    btnTMRefresh: TdxBarLargeButton;
    btnDraftReset: TdxBarLargeButton;
    gchTradeMark: TsmGridColumnHide;
    gchTradeMarkDraft: TsmGridColumnHide;
    ActionList: TActionList;
    acTMDColumns: TAction;
    acTMColumns: TAction;
    btnDraftAnalysis: TdxBarLargeButton;
    btnDraftToDelete: TdxBarLargeButton;
    btnMerge: TdxBarLargeButton;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    tblTradeMarkClean: TCatalogTableViewClean;
    acTMRefresh: TCatalogAction;
    acTMMoveToDraft: TCatalogAction;
    acTMCopyFrom: TCatalogAction;
    acTMRestore: TCatalogAction;
    colCleanId_TradeMark: TCatalogCleanColumn;
    colCleanName: TCatalogCleanColumn;
    colCleanFullName: TCatalogCleanColumn;
    colCleanIsOriginal: TCatalogCleanColumn;
    colCleanEnabled: TCatalogCleanColumn;
    colCleanCountDraft: TCatalogCleanColumn;
    colCleanVersion: TCatalogCleanColumn;
    acDraftRefresh: TCatalogAction;
    tblTradeMarkDraft: TCatalogTableViewDraft;
    colDraftId_TradeMark: TCatalogDraftColumn;
    colDraftId_TradeMarkDraft: TCatalogDraftColumn;
    colDraftName: TCatalogDraftColumn;
    colDraftFullName: TCatalogDraftColumn;
    colDraftIsOriginal: TCatalogDraftColumn;
    colDraftUserName: TCatalogDraftColumn;
    colDraftId_StatusDraft: TCatalogDraftColumn;
    colDraftStatusName: TCatalogDraftColumn;
    colDraftVersion: TCatalogDraftColumn;
    colDraftAnalysisIcon: TCatalogDraftColumn;
    acDraftAdd: TCatalogAction;
    acDraftEdit: TCatalogAction;
    acDraftDelete: TCatalogAction;
    acDraftReset: TCatalogAction;
    acDraftReady: TCatalogAction;
    acDraftToDelete: TCatalogAction;
    acDraftMerge: TCatalogAction;
    acDraftAnalysis: TCatalogAction;
    acDraftApprove: TCatalogAction;
    wbDraftDetails: TERPWebBrowser;
    cxSplitter1: TcxSplitter;
    wbCleanDetails: TERPWebBrowser;
    cxSplitter2: TcxSplitter;
    colDraftCondition: TCatalogDraftColumn;
    colDraftConditionName: TCatalogDraftColumn;
    acDraftImport: TCatalogAction;
    acTMExport: TCatalogAction;
    colDraftLabel: TCatalogDraftColumn;
    procedure FormShow(Sender: TObject);
    procedure acTMDColumnsExecute(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure pcTradeMarkChange(Sender: TObject);
    procedure acTMColumnsExecute(Sender: TObject);
    procedure tblTradeMarkDraftCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
  private
    function GetActiveTableView: TcxGridTableView;
    function GetIsActiveDraft: Boolean;

    procedure AssignToolBarImages;
    procedure RefreshData;
    procedure RefreshTradeMark;
    procedure RefreshTradeMarkDraft;

    property ActiveTableView: TcxGridTableView read GetActiveTableView;
    property IsActiveDraft: Boolean read GetIsActiveDraft;
  public
    constructor Create(aERPClientData: IERPClientData); reintroduce;
  end;

function CreateForm(aERPClientData: IERPClientData): THandle; stdcall;
procedure RegisterAccess(aModuleAccess: IModuleAccess); stdcall;
procedure SetModuleInfo(aModuleInfo: IModuleInfo); stdcall;

exports CreateForm;
exports RegisterAccess;
exports SetModuleInfo;

implementation

{$R *.dfm}
{$R Resource\Icon.res}

uses
  idoc,
  System.IOUtils,
  ShateM.Utils.Windows,
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.GlobalData.DataModule,
  ERP.Package.CustomClasses.Consts,
  ERP.Package.CustomGlobalFunctions.UserFunctions,
  ERP.Package.CustomGlobalFunctions.ExcelFunctions,
  MDM.CustomCatalogForm.TERPCatalogMergeForm,
  MDM.Catalog.Logic.TTradeMarkClean,
  MDM.Catalog.Logic.TTradeMarkDraft,
  MDM.Catalog.Logic.Consts;

const
  MODULE_NAME            = 'Торговая марка';
  MODULE_GUID: TGUID     = '{0A0D9B70-7BE5-4C33-9131-CE91F3BFEFCE}';
  MODULE_TYPEDB          = TYPE_DATABASE_MDM;

  TMDRAFT_COL_TMDBIT            = 13;

  TM_COL_ID_TRADEMARK           = 0;
  TM_COL_NAME                   = 1;
  TM_COL_FULLNAME               = 2;
  TM_COL_ORIGINAL               = 3;
  TM_COL_LOGO                   = 4;
  TM_COL_DELETE                 = 5;
  TM_COL_COUNTDRAFT             = 6;
  TM_COL_IMG_TYPE               = 7;
  TM_COL_CHANGEDATE             = 8;

resourcestring
  rsDelete               = 'Удаление';
  rsDeleteConfirm        = 'Вы уверенны, что хотите удалить выделенные записи?';
  rsRestore              = 'Восстановление';

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmMDMTradeMark;
begin
  frmForm := TfrmMDMTradeMark.Create(aERPClientData);
  Result := frmForm.Handle;
end;

procedure SetModuleInfo(aModuleInfo: IModuleInfo);
begin
  aModuleInfo.GUID := MODULE_GUID;
  aModuleInfo.Name := MODULE_NAME;
  aModuleInfo.TypeDB := MODULE_TYPEDB;
  aModuleInfo.TypeGuid := TYPEMODULE_CATALOGS;
end;

procedure RegisterAccess(aModuleAccess: IModuleAccess);
begin
  aModuleAccess.Add('Черновик. Создание', A1_DRAFTCREATE);
  aModuleAccess.Add('Черновик. Редактирование', A2_DRAFTEDIT);
  aModuleAccess.Add('Черновик. Удаление', A3_DRAFTDELETE);
  aModuleAccess.Add('Черновик. Сброс статуса', A4_DRAFTRESET);
  aModuleAccess.Add('Черновик. Статус готов', A5_DRAFTREADY);
  aModuleAccess.Add('Черновик. Статус к удалению', A6_DRAFTTODELETE);
  aModuleAccess.Add('Черновик. Слияние', A7_DRAFTMERGE);
  aModuleAccess.Add('Черновик. Анализ', A8_DRAFTANALYSIS);
  aModuleAccess.Add('Черновик. Утверждение', A9_DRAFTAPPROVE);
  aModuleAccess.Add('Черновик. Импорт', A10_DRAFTIMPORT);
  aModuleAccess.Add('Чистовик. Перенос в черновик', A11_TODRAFT);
  aModuleAccess.Add('Чистовик. Копия из', A12_COPY);
  aModuleAccess.Add('Чистовик. Восстановление', A13_RESTORE);
  aModuleAccess.Add('Чистовик. Экспорт', A14_EXPORT);
  aModuleAccess.Add('Просмотр всего черновика', A15_VIEWALLDRAFT);
end;

{ TfrmMDMTradeMark }

procedure TfrmMDMTradeMark.acTMColumnsExecute(Sender: TObject);
begin
  gchTradeMark.ShowUserColumnForm(TWindows.GetUserName(), GUIDToString(MODULE_GUID));
end;

procedure TfrmMDMTradeMark.acTMDColumnsExecute(Sender: TObject);
begin
  gchTradeMarkDraft.ShowUserColumnForm(TWindows.GetUserName(), GUIDToString(MODULE_GUID));
end;

procedure TfrmMDMTradeMark.AssignToolBarImages;

  function CopyIL(aIndex: Integer): Integer;
  var
    Icon: TIcon;
  begin
    Icon := TIcon.Create();
    try
      GDDM.ilGlobal32.GetIcon(aIndex, Icon);
      Result := ilImage32.AddIcon(Icon);
    finally
      Icon.Free();
    end;
  end;

begin
  acDraftAdd.ImageIndex := CopyIL(IL_ADD);
  acDraftEdit.ImageIndex := CopyIL(IL_EDIT);
  acDraftDelete.ImageIndex := CopyIL(IL_DELETE);
  acDraftRefresh.ImageIndex := CopyIL(IL_REFRESH);
  acDraftReset.ImageIndex := 5;
  acDraftReady.ImageIndex := 1;
  acDraftToDelete.ImageIndex := 9;
  acDraftMerge.ImageIndex := 10;
  acDraftAnalysis.ImageIndex := 8;
  acDraftApprove.ImageIndex := 2;
  acDraftImport.ImageIndex := 7;
  acTMRefresh.ImageIndex := acDraftRefresh.ImageIndex;
  acTMMoveToDraft.ImageIndex := 0;
  acTMCopyFrom.ImageIndex := 11;
  acTMRestore.ImageIndex := 4;
  acTMExport.ImageIndex := 6;
  dxBarManager.LargeImages := ilImage32;
end;

constructor TfrmMDMTradeMark.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);
  AssignToolBarImages();
  gchTradeMark.FileXMLName := IncludeTrailingPathDelimiter(TPath.GetDocumentsPath()) + 'ERPGridColumns.xml';
  gchTradeMarkDraft.FileXMLName := IncludeTrailingPathDelimiter(TPath.GetDocumentsPath()) + 'ERPGridColumns.xml';

  wbDraftDetails.ERPOptions.TemplateList.Items[0].TemplateFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Templates\1.html';
  tblTradeMarkClean.CatalogTableViewController.Controller := TTradeMarkClean.Create(Self, tblTradeMarkClean);
  tblTradeMarkDraft.CatalogTableViewController.Controller := TTradeMarkDraft.Create(Self, tblTradeMarkDraft);
end;

procedure TfrmMDMTradeMark.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
var
  Key: Word;
  Shift: TShiftState;
begin
  ShortCutToKey(ShortCutFromMessage(Msg), Key, Shift);
  if [ssCtrl] = Shift then
  begin
    case Key of
      VK_ADD:
        if ActiveTableView.OptionsView.DataRowHeight < 100 then
          ActiveTableView.OptionsView.DataRowHeight := ActiveTableView.OptionsView.DataRowHeight + 10;
      VK_SUBTRACT:
        if ActiveTableView.OptionsView.DataRowHeight > 0 then
          ActiveTableView.OptionsView.DataRowHeight := ActiveTableView.OptionsView.DataRowHeight - 10;
    end;
  end;
end;

procedure TfrmMDMTradeMark.FormShow(Sender: TObject);
begin
  gchTradeMark.RefreshColumn(TWindows.GetUserName(), GUIDToString(MODULE_GUID));
  gchTradeMarkDraft.RefreshColumn(TWindows.GetUserName(), GUIDToString(MODULE_GUID));
  RefreshData();
end;

function TfrmMDMTradeMark.GetActiveTableView: TcxGridTableView;
begin
  if IsActiveDraft then
    Result := tblTradeMarkDraft
  else
    Result := tblTradeMarkClean;
end;

function TfrmMDMTradeMark.GetIsActiveDraft: Boolean;
begin
  Result := pcTradeMark.ActivePage = tsDraft;
end;

procedure TfrmMDMTradeMark.pcTradeMarkChange(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmMDMTradeMark.RefreshData;
begin
  if IsActiveDraft then
    RefreshTradeMarkDraft()
  else
    RefreshTradeMark();
end;

procedure TfrmMDMTradeMark.RefreshTradeMark;
begin
  btnTMRefresh.Click();
end;

procedure TfrmMDMTradeMark.RefreshTradeMarkDraft;
begin
  btnDraftRefresh.Click();
end;

procedure TfrmMDMTradeMark.tblTradeMarkDraftCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnDraftEdit.Click();
end;

end.
