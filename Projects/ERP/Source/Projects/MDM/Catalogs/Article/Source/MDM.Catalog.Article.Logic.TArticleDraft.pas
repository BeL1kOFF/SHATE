unit MDM.Catalog.Article.Logic.TArticleDraft;

interface

uses
  Data.DB,
  FireDAC.Stan.Param,
  MDM.Package.Classes.TCatalogDraftController,
  MDM.Package.Classes.TCustomFormDetail,
  MDM.Catalog.Article.Logic.TArticleDraftItem;

type
  TArticleDraft = class(TCatalogDraftController)
  private
    FItem: TArticleDraftItem;
  protected
    function GetFormDetial(aNew: Boolean): TCustomFormDetail; override;
    procedure EditReadItemDataSet(aDataSet: TDataSet); override;
    procedure InitCatalogAccess; override;
    procedure InitSQL; override;
    procedure SetEditReadItemParams(aParams: TFDParams); override;
    procedure SetSaveParams(aParams: TFDParams); override;
  public
    function IsNewItem: Boolean; override;
    property Item: TArticleDraftItem read FItem write FItem;
  end;

implementation

uses
  System.Variants,
  MDM.Package.Components.Types,
  MDM.Catalog.Article.Logic.Consts,
  MDM.Catalog.UI.ArticleDetail;

{ TArticleDraft }

procedure TArticleDraft.EditReadItemDataSet(aDataSet: TDataSet);
begin
  FItem.Id_Article := aDataSet.FieldByName('Id_Article').AsVariant;
  FItem.Id_TradeMark := aDataSet.FieldByName('Id_TradeMark').AsInteger;
  FItem.Number := aDataSet.FieldByName('Number').AsString;
  FItem.NumberShort := aDataSet.FieldByName('NumberShort').AsString;
  FItem.Id_ArticleNorm := aDataSet.FieldByName('Id_ArticleNorm').AsVariant;
  FItem.Name := aDataSet.FieldByName('Name').AsString;
  FItem.Description := aDataSet.FieldByName('Description').AsString;
  FItem.Version := aDataSet.FieldByName('Version').AsVariant;
end;

function TArticleDraft.GetFormDetial(aNew: Boolean): TCustomFormDetail;
begin
  FItem.SetDefault();
  if aNew then
    FItem.Id_ArticleDraft := -1
  else
    FItem.Id_ArticleDraft := GridTableView.Controller.FocusedRecord.Values[GetGridColumnFromServiceType(stPK).Index];
  Result := TfrmMDMArticleDetail.Create(ERPForm, Self, GetUser());
end;

procedure TArticleDraft.InitCatalogAccess;
begin
  CatalogAccess.Add           := A1_DRAFTCREATE;
  CatalogAccess.Edit          := A2_DRAFTEDIT;
  CatalogAccess.Delete        := A3_DRAFTDELETE;
  CatalogAccess.StatusReset   := A4_DRAFTRESET;
  CatalogAccess.StatusReady   := A5_DRAFTREADY;
  CatalogAccess.StatusDelete  := A6_DRAFTTODELETE;
  CatalogAccess.Merge         := A7_DRAFTMERGE;
  CatalogAccess.Analysis      := A8_DRAFTANALYSIS;
  CatalogAccess.Approve       := A9_DRAFTAPPROVE;
  CatalogAccess.ImportDraft   := A10_DRAFTIMPORT;
  CatalogAccess.ViewAll       := A15_VIEWALLDRAFT;
end;

procedure TArticleDraft.InitSQL;
begin
  SQLProc.SQLEditReadItem := 'a_draft_item_sel :Id_ArticleDraft';
  SQLProc.SQLInsert := 'a_draft_item_ins :UserName, :Id_TradeMark, :Number, :NumberShort, :Id_ArticleNorm, :Name, :Description';
  SQLProc.SQLUpdate := 'a_draft_item_upd :UserName, :Id_ArticleDraft, :Id_TradeMark, :Number, :NumberShort, :Id_ArticleNorm, :Name, :Description';
  SQLProc.SQLDelete := 'a_draft_del';
  SQLProc.SQLChangeStatus := 'a_draft_status_change :Id_StatusDraft';
  SQLProc.SQLMergeMeta := 'a_draft_merge_meta';
  SQLProc.SQLMergeSelect := 'a_draft_merge_sel :Id_ArticleDraft';
  SQLProc.SQLMerge := 'a_draft_merge :UserName, :Version';
  SQLProc.SQLAnalysis := 'a_draft_analysis';
  SQLProc.SQLApprove := 'a_draft_approve';
  SQLProc.SQLRefreshSelect := 'a_draft_itemlist_sel :UserName';
  SQLProc.SQLImportMeta := 'a_draft_import_meta';
  SQLProc.SQLImportCheck := 'a_draft_import_check :UserName';
  SQLProc.SQLImport := 'a_draft_import :UserName, :Label';
end;

function TArticleDraft.IsNewItem: Boolean;
begin
  Result := FItem.Id_ArticleDraft = -1;
end;

procedure TArticleDraft.SetEditReadItemParams(aParams: TFDParams);
begin
  aParams.ParamByName('Id_ArticleDraft').AsInteger := FItem.Id_ArticleDraft;
end;

procedure TArticleDraft.SetSaveParams(aParams: TFDParams);
begin
  if not IsNewItem() then
    aParams.ParamByName('Id_ArticleDraft').AsInteger := FItem.Id_ArticleDraft;
  aParams.ParamByName('UserName').AsString := GetUser();
  aParams.ParamByName('Id_TradeMark').AsInteger := FItem.Id_TradeMark;
  aParams.ParamByName('Number').AsString := FItem.Number;
  aParams.ParamByName('NumberShort').AsString := FItem.NumberShort;
  if VarIsNull(FItem.Id_ArticleNorm) then
    aParams.ParamByName('Id_ArticleNorm').DataType := ftInteger;
  aParams.ParamByName('Id_ArticleNorm').Value := FItem.Id_ArticleNorm;
  aParams.ParamByName('Name').AsString := FItem.Name;
  aParams.ParamByName('Description').AsWideMemo := FItem.Description;
end;

end.
