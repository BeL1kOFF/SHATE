unit MDM.Catalog.UI.TradeMarkSynonym;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ERP.Package.CustomForm.TERPCustomForm, ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, dxBarBuiltInMenu, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxPC, cxStyles, dxBar, Vcl.OleCtrls, SHDocVw, ERP.Package.Components.TERPWebBrowser,
  cxSplitter, cxClasses, cxGridLevel, cxGrid, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, MDM.Package.Components.CustomCatalogTableView,
  MDM.Package.Components.CatalogTableViewClean, System.Actions, Vcl.ActnList, MDM.Package.Components.CatalogAction,
  MDM.Package.Components.CustomCatalogColumn, MDM.Package.Components.CatalogCleanColumn, Data.DB, cxDBData,
  cxGridDBTableView, MDM.Package.Components.CatalogTableViewDraft, MDM.Package.Components.CatalogDraftColumn,
  cxDBLookupComboBox, cxBarEditItem, cxLabel, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  cxDropDownEdit, cxCheckBox, cxImage, Vcl.ImgList;

type
  TfrmTradeMarkSynonym = class(TERPCustomForm)
    pcTradeMarkSynonym: TcxPageControl;
    tsDraft: TcxTabSheet;
    tsClean: TcxTabSheet;
    cxLevelTMS: TcxGridLevel;
    cxGridTMS: TcxGrid;
    cxSplitter1: TcxSplitter;
    wbCleanDetails: TERPWebBrowser;
    barDockClean: TdxBarDockControl;
    tblTradeMarkSynonymClean: TCatalogTableViewClean;
    BarManager: TdxBarManager;
    barSTM: TdxBar;
    btnRefresh: TdxBarLargeButton;
    dxBarLargeButton2: TdxBarLargeButton;
    dxBarLargeButton3: TdxBarLargeButton;
    dxBarLargeButton4: TdxBarLargeButton;
    dxBarLargeButton5: TdxBarLargeButton;
    ActionList: TActionList;
    acCleanRefresh: TCatalogAction;
    acCleanMoveToDraft: TCatalogAction;
    acCleanCopyFrom: TCatalogAction;
    acCleanRestore: TCatalogAction;
    acCleanExport: TCatalogAction;
    colCleanId_TradeMarkSynonym: TCatalogCleanColumn;
    colCleanTradeMarkName: TCatalogCleanColumn;
    colCleanName: TCatalogCleanColumn;
    colCleanShowUI: TCatalogCleanColumn;
    colCleanVersion: TCatalogCleanColumn;
    colCleanEnabled: TCatalogCleanColumn;
    colCleanCountDraft: TCatalogCleanColumn;
    wbDraftDetails: TERPWebBrowser;
    cxSplitter2: TcxSplitter;
    cxLevelDraftTMS: TcxGridLevel;
    cxGridDraftTMS: TcxGrid;
    tblTradeMarkSynonymDraft: TCatalogTableViewDraft;
    colDraftId_TradeMarkSynonymDraft: TCatalogDraftColumn;
    colDraftId_TradeMarkSynonym: TCatalogDraftColumn;
    colDraftTradeMarkName: TCatalogDraftColumn;
    colDraftName: TCatalogDraftColumn;
    colDraftShowUI: TCatalogDraftColumn;
    colDraftUserName: TCatalogDraftColumn;
    colDraftId_StatusDraft: TCatalogDraftColumn;
    colDraftStatusName: TCatalogDraftColumn;
    colDraftVersion: TCatalogDraftColumn;
    colDraftCondition: TCatalogDraftColumn;
    colDraftConditionName: TCatalogDraftColumn;
    colDraftLabel: TCatalogDraftColumn;
    barDockDraft: TdxBarDockControl;
    BarManagerBar1: TdxBar;
    btnDraftRefresh: TdxBarLargeButton;
    acDraftRefresh: TCatalogAction;
    btnDraftAdd: TdxBarLargeButton;
    btnDraftEdit: TdxBarLargeButton;
    btnDraftDelete: TdxBarLargeButton;
    acDraftAdd: TCatalogAction;
    acDraftEdit: TCatalogAction;
    acDraftDelete: TCatalogAction;
    BarManagerBar2: TdxBar;
    dxBarDockControl1: TdxBarDockControl;
    cmbTradeMark: TcxBarEditItem;
    cxBarEditItem2: TcxBarEditItem;
    dsTradeMark: TDataSource;
    memTradeMark: TFDMemTable;
    dxBarLargeButton1: TdxBarLargeButton;
    dxBarLargeButton6: TdxBarLargeButton;
    dxBarLargeButton7: TdxBarLargeButton;
    acDraftStatusReset: TCatalogAction;
    acDraftStatusReady: TCatalogAction;
    acDraftStatusDelete: TCatalogAction;
    dxBarLargeButton8: TdxBarLargeButton;
    dxBarLargeButton9: TdxBarLargeButton;
    dxBarLargeButton10: TdxBarLargeButton;
    acDraftMerge: TCatalogAction;
    acDraftAnalysis: TCatalogAction;
    acDraftApprove: TCatalogAction;
    colDraftAnalysisIcon: TCatalogDraftColumn;
    dxBarLargeButton11: TdxBarLargeButton;
    acDraftImport: TCatalogAction;
    ilImage32: TcxImageList;
    procedure tblTradeMarkSynonymDraftCellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure pcTradeMarkSynonymChange(Sender: TObject);
  private
    function GetIsActiveDraft: Boolean;
    procedure AssignToolBarImages;
    procedure FillTradeMark;
    procedure RefreshData;
    procedure RefreshTradeMarkSynonym;
    procedure RefreshTradeMarkSynonymDraft;
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
  ERP.Package.CustomClasses.Consts,
  ERP.Package.GlobalData.DataModule,
  MDM.Catalog.Logic.TTradeMarkSynonymClean,
  MDM.Catalog.Logic.TTradeMarkSynonymDraft,
  MDM.Catalog.Logic.STM.Consts;

const
  MODULE_NAME            = 'Синонимы торговых маркок';
  MODULE_GUID: TGUID     = '{81808DF5-3274-47C3-A988-DCFB40CAF6F5}';
  MODULE_TYPEDB          = TYPE_DATABASE_MDM;

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmTradeMarkSynonym;
begin
  frmForm := TfrmTradeMarkSynonym.Create(aERPClientData);
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

{ TfrmMDMSynonymTradeMark }

procedure TfrmTradeMarkSynonym.AssignToolBarImages;

  function CopyIL(aImageList: TcxImageList; aIndex: Integer): Integer;
  var
    Icon: TIcon;
  begin
    Icon := TIcon.Create();
    try
      aImageList.GetIcon(aIndex, Icon);
      Result := ilImage32.AddIcon(Icon);
    finally
      Icon.Free();
    end;
  end;

begin
  acCleanRefresh.ImageIndex := CopyIL(GDDM.ilGlobal32, IL_REFRESH);
  acCleanMoveToDraft.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_DRAFT);
  acCleanCopyFrom.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_COPY);
  acCleanRestore.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_RESTORE);
  acCleanExport.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_EXPORT);
  acDraftRefresh.ImageIndex := acCleanRefresh.ImageIndex;

  acDraftAdd.ImageIndex := CopyIL(GDDM.ilGlobal32, IL_ADD);
  acDraftEdit.ImageIndex := CopyIL(GDDM.ilGlobal32, IL_EDIT);
  acDraftDelete.ImageIndex := CopyIL(GDDM.ilGlobal32, IL_DELETE);
  acDraftStatusReset.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_STATUSRESET);
  acDraftStatusReady.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_STATUSREADY);
  acDraftStatusDelete.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_STATUSDELETE);
  acDraftMerge.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_MERGE);
  acDraftAnalysis.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_ANALYSIS);
  acDraftApprove.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_APPROVE);
  acDraftImport.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_IMPORT);
end;

constructor TfrmTradeMarkSynonym.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);

  AssignToolBarImages();
  tblTradeMarkSynonymClean.CatalogTableViewController.Controller := TSynonymTradeMarkClean.Create(Self, tblTradeMarkSynonymClean);
  tblTradeMarkSynonymDraft.CatalogTableViewController.Controller := TTradeMarkSynonymDraft.Create(Self, tblTradeMarkSynonymDraft);
end;

procedure TfrmTradeMarkSynonym.FillTradeMark;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(Self);
  try
    Query.Connection := FDConnection;
    Query.SQL.Text := 'tms_draft_trademarklist_sel';
    Query.Open();
    try
      memTradeMark.Data := Query.Data;
    finally
      Query.Close();
    end;
  finally
    Query.Free();
  end;
end;

procedure TfrmTradeMarkSynonym.FormShow(Sender: TObject);
begin
  FillTradeMark();
  RefreshData();
end;

function TfrmTradeMarkSynonym.GetIsActiveDraft: Boolean;
begin
  Result := pcTradeMarkSynonym.ActivePage = tsDraft;
end;

procedure TfrmTradeMarkSynonym.pcTradeMarkSynonymChange(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmTradeMarkSynonym.RefreshData;
begin
  if IsActiveDraft then
    RefreshTradeMarkSynonymDraft()
  else
    RefreshTradeMarkSynonym();
end;

procedure TfrmTradeMarkSynonym.RefreshTradeMarkSynonym;
begin
  btnRefresh.Click();
end;

procedure TfrmTradeMarkSynonym.RefreshTradeMarkSynonymDraft;
begin
  btnDraftRefresh.Click();
end;

procedure TfrmTradeMarkSynonym.tblTradeMarkSynonymDraftCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnDraftEdit.Click();
end;

end.
