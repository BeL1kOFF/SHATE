unit MDM.Catalog.Crosses.UI.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxBarBuiltInMenu, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, cxImage, cxCheckBox,
  cxDBLookupComboBox, cxLabel, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  System.Actions, Vcl.ActnList, MDM.Package.Components.CatalogAction, dxBar, cxBarEditItem, cxClasses, Vcl.ImgList,
  MDM.Package.Components.CatalogCleanColumn, MDM.Package.Components.CatalogTableViewClean, cxSplitter, Vcl.OleCtrls,
  SHDocVw, ERP.Package.Components.TERPWebBrowser, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  MDM.Package.Components.CustomCatalogColumn, MDM.Package.Components.CatalogDraftColumn, cxGridCustomView,
  MDM.Package.Components.CustomCatalogTableView, MDM.Package.Components.CatalogTableViewDraft, cxGrid, cxPC;

type
  TfrmMDMCrosses = class(TERPCustomForm)
    pcCross: TcxPageControl;
    tsDraft: TcxTabSheet;
    cxGridCD: TcxGrid;
    tblCrossDraft: TCatalogTableViewDraft;
    colDraftUserName: TCatalogDraftColumn;
    colDraftId_StatusDraft: TCatalogDraftColumn;
    colDraftStatusName: TCatalogDraftColumn;
    colDraftVersion: TCatalogDraftColumn;
    colDraftAnalysisIcon: TCatalogDraftColumn;
    colDraftCondition: TCatalogDraftColumn;
    colDraftConditionName: TCatalogDraftColumn;
    colDraftLabel: TCatalogDraftColumn;
    cxLevelCD: TcxGridLevel;
    barDockDraft: TdxBarDockControl;
    wbDraftDetails: TERPWebBrowser;
    cxSplitter1: TcxSplitter;
    tsClean: TcxTabSheet;
    cxGridСC: TcxGrid;
    tblCrossClean: TCatalogTableViewClean;
    colCleanVersion: TCatalogCleanColumn;
    colCleanEnabled: TCatalogCleanColumn;
    colCleanCountDraft: TCatalogCleanColumn;
    cxLevelСC: TcxGridLevel;
    barDockTM: TdxBarDockControl;
    wbCleanDetails: TERPWebBrowser;
    cxSplitter2: TcxSplitter;
    dxBarDockControl1: TdxBarDockControl;
    ilImage32: TcxImageList;
    dxBarManager: TdxBarManager;
    barDraft: TdxBar;
    barTM: TdxBar;
    dxBarManagerBar1: TdxBar;
    btnDraftRefresh: TdxBarLargeButton;
    btnDraftAdd: TdxBarLargeButton;
    btnDraftEdit: TdxBarLargeButton;
    btnDraftDelete: TdxBarLargeButton;
    btnDraftApprove: TdxBarLargeButton;
    btnCleanToDraft: TdxBarLargeButton;
    btnCleanExport: TdxBarLargeButton;
    btnDraftImport: TdxBarLargeButton;
    btnDraftReady: TdxBarLargeButton;
    btnCleanRestore: TdxBarLargeButton;
    btnCleanRefresh: TdxBarLargeButton;
    btnDraftReset: TdxBarLargeButton;
    btnDraftAnalysis: TdxBarLargeButton;
    btnDraftToDelete: TdxBarLargeButton;
    btnDraftMerge: TdxBarLargeButton;
    btnCleanCopyFrom: TdxBarLargeButton;
    cmbTradeMark: TcxBarEditItem;
    cxBarEditItem3: TcxBarEditItem;
    ActionList: TActionList;
    acCleanRefresh: TCatalogAction;
    acCleanMoveToDraft: TCatalogAction;
    acCleanCopyFrom: TCatalogAction;
    acCleanRestore: TCatalogAction;
    acCleanExport: TCatalogAction;
    acDraftRefresh: TCatalogAction;
    acDraftAdd: TCatalogAction;
    acDraftEdit: TCatalogAction;
    acDraftDelete: TCatalogAction;
    acDraftReset: TCatalogAction;
    acDraftReady: TCatalogAction;
    acDraftToDelete: TCatalogAction;
    acDraftMerge: TCatalogAction;
    acDraftAnalysis: TCatalogAction;
    acDraftApprove: TCatalogAction;
    acDraftImport: TCatalogAction;
    dsTradeMark: TDataSource;
    memTradeMark: TFDMemTable;
    colCleanId_Cross: TCatalogCleanColumn;
    colCleanId_Article1: TCatalogCleanColumn;
    colCleanId_Article2: TCatalogCleanColumn;
    colCleanArticle1Name: TCatalogCleanColumn;
    colCleanArticle2Name: TCatalogCleanColumn;
    colDraftId_CrossDraft: TCatalogDraftColumn;
    colDraftId_Cross: TCatalogDraftColumn;
    colDraftId_Article1: TCatalogDraftColumn;
    colDraftId_Article2: TCatalogDraftColumn;
    colDraftArticle1Number: TCatalogDraftColumn;
    colDraftArticle2Number: TCatalogDraftColumn;
    colDraftId_LogCross: TCatalogDraftColumn;
    colDraftHistoryLog: TCatalogDraftColumn;
    procedure FormShow(Sender: TObject);
    procedure pcCrossChange(Sender: TObject);
    procedure cmbTradeMarkChange(Sender: TObject);
    procedure tblCrossDraftCellDblClick(Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
      AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
  private
    function GetIsActiveDraft: Boolean;
    procedure AssignToolBarImages;
    procedure FillTradeMark;
    procedure RefreshData;
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
  MDM.Catalog.Crosses.Logic.TCrossesDraft,
  MDM.Catalog.Crosses.Logic.TCrossesClean;

const
  MODULE_NAME            = 'Кроссы';
  MODULE_GUID: TGUID     = '{A797EC3F-FFA0-4728-AFD7-488C7976A5C9}';
  MODULE_TYPEDB          = TYPE_DATABASE_MDM;

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmMDMCrosses;
begin
  frmForm := TfrmMDMCrosses.Create(aERPClientData);
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
  aModuleAccess.Add('Черновик. Создание', 1);
  aModuleAccess.Add('Черновик. Редактирование', 2);
  aModuleAccess.Add('Черновик. Удаление', 3);
  aModuleAccess.Add('Черновик. Сброс статуса', 4);
  aModuleAccess.Add('Черновик. Статус готов', 5);
  aModuleAccess.Add('Черновик. Статус к удалению', 6);
  aModuleAccess.Add('Черновик. Слияние', 7);
  aModuleAccess.Add('Черновик. Анализ', 8);
  aModuleAccess.Add('Черновик. Утверждение', 9);
  aModuleAccess.Add('Черновик. Импорт', 10);
  aModuleAccess.Add('Чистовик. Перенос в черновик', 11);
  aModuleAccess.Add('Чистовик. Копия из', 12);
  aModuleAccess.Add('Чистовик. Восстановление', 13);
  aModuleAccess.Add('Чистовик. Экспорт', 14);
  aModuleAccess.Add('Просмотр всего черновика', 15);
end;

{ TfrmMDMCrosses }

procedure TfrmMDMCrosses.AssignToolBarImages;

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
  acDraftReset.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_STATUSRESET);
  acDraftReady.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_STATUSREADY);
  acDraftToDelete.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_STATUSDELETE);
  acDraftMerge.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_MERGE);
  acDraftAnalysis.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_ANALYSIS);
  acDraftApprove.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_APPROVE);
  acDraftImport.ImageIndex := CopyIL(GDDM.ilGlobalMDMCatalog32, IL_MDMC_IMPORT);
end;

procedure TfrmMDMCrosses.cmbTradeMarkChange(Sender: TObject);
begin
  RefreshData();
end;

constructor TfrmMDMCrosses.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);

  AssignToolBarImages();
  tblCrossDraft.CatalogTableViewController.Controller := TCrossesDraft.Create(Self, tblCrossDraft);
  tblCrossClean.CatalogTableViewController.Controller := TCrossesClean.Create(Self, tblCrossClean);
end;

procedure TfrmMDMCrosses.FillTradeMark;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(Self);
  try
    Query.Connection := FDConnection;
    Query.SQL.Text := 'c_trademarklist_sel';
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

procedure TfrmMDMCrosses.FormShow(Sender: TObject);
begin
  FillTradeMark();
end;

function TfrmMDMCrosses.GetIsActiveDraft: Boolean;
begin
  Result := pcCross.ActivePage = tsDraft;
end;

procedure TfrmMDMCrosses.pcCrossChange(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmMDMCrosses.RefreshData;
begin
  if IsActiveDraft then
    btnDraftRefresh.Click()
  else
  begin
    tblCrossClean.CatalogTableViewController.ActionUpdate(acCleanRefresh);
    btnCleanRefresh.Click();
  end;
end;

procedure TfrmMDMCrosses.tblCrossDraftCellDblClick(Sender: TcxCustomGridTableView;
  ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
begin
  btnDraftEdit.Click();
end;

end.
