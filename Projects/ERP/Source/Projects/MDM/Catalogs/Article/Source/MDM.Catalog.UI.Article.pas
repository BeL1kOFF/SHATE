unit MDM.Catalog.UI.Article;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  ERP.Package.CustomForm.TERPCustomForm,
  ERP.Package.ClientInterface.IERPClientData,
  ERP.Package.ClientInterface.IModuleInfo,
  ERP.Package.ClientInterface.IModuleAccess, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  dxBarBuiltInMenu, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, cxCheckBox, cxImage,
  MDM.Package.Components.CatalogAction, System.Actions, Vcl.ActnList, dxBar, cxClasses, Vcl.ImgList,
  MDM.Package.Components.CatalogCleanColumn, MDM.Package.Components.CatalogTableViewClean, cxSplitter, Vcl.OleCtrls,
  SHDocVw, ERP.Package.Components.TERPWebBrowser, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  MDM.Package.Components.CustomCatalogColumn, MDM.Package.Components.CatalogDraftColumn, cxGridCustomView,
  MDM.Package.Components.CustomCatalogTableView, MDM.Package.Components.CatalogTableViewDraft, cxGrid, cxPC, cxTextEdit,
  cxDBLookupComboBox, cxBarEditItem, cxLabel, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Menus, WebBrowserEx;

type
  TfrmMDMArticle = class(TERPCustomForm)
    pcArticle: TcxPageControl;
    tsDraft: TcxTabSheet;
    cxGridAD: TcxGrid;
    tblArticleDraft: TCatalogTableViewDraft;
    colDraftUserName: TCatalogDraftColumn;
    colDraftId_StatusDraft: TCatalogDraftColumn;
    colDraftStatusName: TCatalogDraftColumn;
    colDraftVersion: TCatalogDraftColumn;
    colDraftAnalysisIcon: TCatalogDraftColumn;
    colDraftCondition: TCatalogDraftColumn;
    colDraftConditionName: TCatalogDraftColumn;
    colDraftLabel: TCatalogDraftColumn;
    cxLevelAD: TcxGridLevel;
    barDockDraft: TdxBarDockControl;
    wbDraftDetails: TERPWebBrowser;
    cxSplitter1: TcxSplitter;
    tsClean: TcxTabSheet;
    cxGridAC: TcxGrid;
    tblArticleClean: TCatalogTableViewClean;
    colCleanId_Article: TCatalogCleanColumn;
    colCleanTradeMarkName: TCatalogCleanColumn;
    colCleanNumber: TCatalogCleanColumn;
    colCleanNumberShort: TCatalogCleanColumn;
    colCleanVersion: TCatalogCleanColumn;
    colCleanEnabled: TCatalogCleanColumn;
    colCleanCountDraft: TCatalogCleanColumn;
    cxLevelAC: TcxGridLevel;
    barDockTM: TdxBarDockControl;
    wbCleanDetails: TERPWebBrowser;
    cxSplitter2: TcxSplitter;
    ilImage32: TcxImageList;
    dxBarManager: TdxBarManager;
    barDraft: TdxBar;
    barTM: TdxBar;
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
    colDraftId_ArticleDraft: TCatalogDraftColumn;
    colDraftNumber: TCatalogDraftColumn;
    colDraftNumberShort: TCatalogDraftColumn;
    colDraftTradeMarkName: TCatalogDraftColumn;
    colDraftId_Article: TCatalogDraftColumn;
    dxBarManagerBar1: TdxBar;
    dxBarDockControl1: TdxBarDockControl;
    cmbTradeMark: TcxBarEditItem;
    cxBarEditItem3: TcxBarEditItem;
    dsTradeMark: TDataSource;
    memTradeMark: TFDMemTable;
    dxBarLargeButton1: TdxBarLargeButton;
    procedure FormShow(Sender: TObject);
    procedure pcArticleChange(Sender: TObject);
    procedure cmbTradeMarkChange(Sender: TObject);
    procedure dxBarLargeButton1Click(Sender: TObject);
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
  MDM.Catalog.Article.Logic.Consts,
  MDM.Catalog.Article.Logic.TArticleDraft,
  MDM.Catalog.Article.Logic.TArticleClean;

const
  MODULE_NAME            = 'Артикулы';
  MODULE_GUID: TGUID     = '{C93562E0-9364-4652-8AF2-0FAEAAA7638D}';
  MODULE_TYPEDB          = TYPE_DATABASE_MDM;

function CreateForm(aERPClientData: IERPClientData): THandle;
var
  frmForm: TfrmMDMArticle;
begin
  frmForm := TfrmMDMArticle.Create(aERPClientData);
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

{ TfrmMDMArticle }

procedure TfrmMDMArticle.AssignToolBarImages;

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

procedure TfrmMDMArticle.cmbTradeMarkChange(Sender: TObject);
begin
  RefreshData();
end;

constructor TfrmMDMArticle.Create(aERPClientData: IERPClientData);
begin
  inherited Create(MODULE_NAME, aERPClientData);

  AssignToolBarImages();
  tblArticleDraft.CatalogTableViewController.Controller := TArticleDraft.Create(Self, tblArticleDraft);
  tblArticleClean.CatalogTableViewController.Controller := TArticleClean.Create(Self, tblArticleClean);
end;

procedure TfrmMDMArticle.dxBarLargeButton1Click(Sender: TObject);
begin
  wbCleanDetails.SetActiveTemplate('Test2');
//  wbCleanDetails.ERPOptions.TemplateList.Add;
end;

procedure TfrmMDMArticle.FillTradeMark;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(Self);
  try
    Query.Connection := FDConnection;
    Query.SQL.Text := 'a_trademarklist_sel';
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

procedure TfrmMDMArticle.FormShow(Sender: TObject);
begin
  FillTradeMark();
end;

function TfrmMDMArticle.GetIsActiveDraft: Boolean;
begin
  Result := pcArticle.ActivePage = tsDraft;
end;

procedure TfrmMDMArticle.pcArticleChange(Sender: TObject);
begin
  RefreshData();
end;

procedure TfrmMDMArticle.RefreshData;
begin
  if IsActiveDraft then
    btnDraftRefresh.Click()
  else
  begin
    tblArticleClean.CatalogTableViewController.ActionUpdate(acCleanRefresh);
    btnCleanRefresh.Click();
  end;
end;

end.
