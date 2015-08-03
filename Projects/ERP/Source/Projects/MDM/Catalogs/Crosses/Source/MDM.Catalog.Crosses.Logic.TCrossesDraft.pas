unit MDM.Catalog.Crosses.Logic.TCrossesDraft;

interface

uses
  Data.DB,
  FireDAC.Stan.Param,
  MDM.Package.Classes.TCatalogDraftController,
  MDM.Package.Classes.TCustomFormDetail,
  MDM.Catalog.Crosses.Logic.TCrossDraftItem;

type
  TCrossesDraft = class(TCatalogDraftController)
  private
    FItem: TCrossDraftItem;
  protected
    function GetFormDetial(aNew: Boolean): TCustomFormDetail; override;
    procedure EditReadItemDataSet(aDataSet: TDataSet); override;
    procedure InitCatalogAccess; override;
    procedure InitSQL; override;
    procedure SetEditReadItemParams(aParams: TFDParams); override;
  public
    function IsNewItem: Boolean; override;
    property Item: TCrossDraftItem read FItem write FItem;
  end;

implementation

uses
  MDM.Package.Components.Types,
  MDM.Catalog.Crosses.UI.Details;

{ TCrossesDraft }

procedure TCrossesDraft.EditReadItemDataSet(aDataSet: TDataSet);
begin
  FItem.Id_Cross := aDataSet.FieldByName('Id_Cross').AsVariant;
  FItem.Id_TradeMark1 := aDataSet.FieldByName('Id_TradeMark1').AsInteger;
  FItem.Id_TradeMark2 := aDataSet.FieldByName('Id_TradeMark2').AsInteger;
  FItem.Id_Article1 := aDataSet.FieldByName('Id_Article1').AsInteger;
  FItem.Id_Article2 := aDataSet.FieldByName('Id_Article2').AsInteger;
  FItem.Version := aDataSet.FieldByName('Version').AsVariant;
end;

function TCrossesDraft.GetFormDetial(aNew: Boolean): TCustomFormDetail;
begin
  FItem.SetDefault();
  if aNew then
    FItem.Id_CrossDraft := -1
  else
    FItem.Id_CrossDraft := GridTableView.Controller.FocusedRecord.Values[GetGridColumnFromServiceType(stPK).Index];
  Result := TfrmMDMCrossesDetail.Create(ERPForm, Self, GetUser());
end;

procedure TCrossesDraft.InitCatalogAccess;
begin
  CatalogAccess.Add           := 1;
  CatalogAccess.Edit          := 2;
  CatalogAccess.Delete        := 3;
  CatalogAccess.StatusReset   := 4;
  CatalogAccess.StatusReady   := 5;
  CatalogAccess.StatusDelete  := 6;
  CatalogAccess.Merge         := 7;
  CatalogAccess.Analysis      := 8;
  CatalogAccess.Approve       := 9;
  CatalogAccess.ImportDraft   := 10;
  CatalogAccess.ViewAll       := 15;
end;

procedure TCrossesDraft.InitSQL;
begin
  SQLProc.SQLRefreshSelect := 'c_draft_itemlist_sel :UserName';
  SQLProc.SQLImportMeta := 'c_draft_import_meta';
  SQLProc.SQLImportCheck := 'c_draft_import_check :UserName';
  SQLProc.SQLImport := 'c_draft_import :UserName, :Label';
  SQLProc.SQLChangeStatus := 'c_draft_status_change :Id_StatusDraft';
  SQLProc.SQLMergeMeta := 'c_draft_merge_meta';
  SQLProc.SQLMergeSelect := 'c_draft_merge_sel :Id_CrossDraft';
  SQLProc.SQLMerge := 'c_draft_merge :UserName, :Version';
  SQLProc.SQLAnalysis := 'c_draft_analysis';
  SQLProc.SQLApprove := 'c_draft_approve';
  SQLProc.SQLEditReadItem := 'c_draft_item_sel :Id_CrossDraft';
  SQLProc.SQLDelete := 'c_draft_del';
  SQLProc.SQLInsert := 'c_draft_item_ins :UserName, :Id_Article1, :Id_Article2';
  SQLProc.SQLUpdate := 'c_draft_item_upd :UserName, :Id_CrossDraft, :Id_Article1, :Id_Article2';
end;

function TCrossesDraft.IsNewItem: Boolean;
begin
  Result := FItem.Id_CrossDraft = -1;
end;

procedure TCrossesDraft.SetEditReadItemParams(aParams: TFDParams);
begin
  aParams.ParamByName('Id_CrossDraft').AsInteger := FItem.Id_CrossDraft;
end;

end.
