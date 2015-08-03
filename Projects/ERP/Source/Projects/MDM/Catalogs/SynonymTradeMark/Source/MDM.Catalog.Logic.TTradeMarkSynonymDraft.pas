unit MDM.Catalog.Logic.TTradeMarkSynonymDraft;

interface

uses
  Data.DB,
  FireDAC.Stan.Param,
  MDM.Package.Classes.TCustomFormDetail,
  MDM.Package.Classes.TCatalogDraftController,
  MDM.Catalog.Logic.STM.Consts,
  MDM.Catalog.Logic.TTradeMarkSynonymDraftItem;

type
  TTradeMarkSynonymDraft = class(TCatalogDraftController)
  private
    FItem: TTradeMarkSynonymDraftItem;
  protected
    function GetFormDetial(aNew: Boolean): TCustomFormDetail; override;
    procedure EditReadItemDataSet(aDataSet: TDataSet); override;
    procedure InitCatalogAccess; override;
    procedure InitSQL; override;
    procedure SetEditReadItemParams(aParams: TFDParams); override;
    procedure SetSaveParams(aParams: TFDParams); override;
  public
    function IsNewItem: Boolean; override;
    property Item: TTradeMarkSynonymDraftItem read FItem write FItem;
  end;

implementation

uses
  MDM.Package.Components.Types,
  MDM.Catalog.UI.TradeMarkSynonymDetails;

{ TTradeMarkSynonymDraft }

procedure TTradeMarkSynonymDraft.EditReadItemDataSet(aDataSet: TDataSet);
begin
  FItem.Id_TradeMarkSynonym := aDataSet.FieldByName('Id_TradeMarkSynonym').AsVariant;
  FItem.Id_TradeMark := aDataSet.FieldByName('Id_TradeMark').AsInteger;
  FItem.Name := aDataSet.FieldByName('Name').AsString;
  FItem.ShowUI := aDataSet.FieldByName('ShowUI').AsBoolean;
  FItem.Version := aDataSet.FieldByName('Version').AsVariant;
end;

function TTradeMarkSynonymDraft.GetFormDetial(aNew: Boolean): TCustomFormDetail;
begin
  FItem.SetDefault();
  if aNew then
    FItem.Id_TradeMarkSynonymDraft := -1
  else
    FItem.Id_TradeMarkSynonymDraft := GridTableView.Controller.FocusedRecord.Values[GetGridColumnFromServiceType(stPK).Index];
  Result := TfrmTradeMarkSynonymDetails.Create(ERPForm, Self, GetUser());
end;

procedure TTradeMarkSynonymDraft.InitCatalogAccess;
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

procedure TTradeMarkSynonymDraft.InitSQL;
begin
  SQLProc.SQLRefreshSelect := 'tms_draft_itemlist_sel :UserName';
  SQLProc.SQLInsert := 'tms_draft_item_ins :UserName, :Id_TradeMark, :Name, :ShowUI';
  SQLProc.SQLEditReadItem := 'tms_draft_item_sel :Id_TradeMarkSynonymDraft';
  SQLProc.SQLUpdate := 'tms_draft_item_upd :UserName, :Id_TradeMarkSynonymDraft, :Id_TradeMark, :Name, :ShowUI';
  SQLProc.SQLDelete := 'tms_draft_del';
  SQLProc.SQLChangeStatus := 'tms_draft_status_change :Id_StatusDraft';
  SQLProc.SQLMergeMeta := 'tms_draft_merge_meta';
  SQLProc.SQLMergeSelect := 'tms_draft_merge_sel :Id_TradeMarkSynonymDraft';
  SQLProc.SQLMerge := 'tms_draft_merge :UserName, :Version';
  SQLProc.SQLAnalysis := 'tms_draft_analysis';
  SQLProc.SQLApprove := 'tms_draft_approve';
  SQLProc.SQLImportMeta := 'tms_draft_import_meta';
  SQLProc.SQLImportCheck := 'tms_draft_import_check :UserName';
  SQLProc.SQLImport := 'tms_draft_import :UserName, :Label';
end;

function TTradeMarkSynonymDraft.IsNewItem: Boolean;
begin
  Result := FItem.Id_TradeMarkSynonymDraft = -1;
end;

procedure TTradeMarkSynonymDraft.SetEditReadItemParams(aParams: TFDParams);
begin
  aParams.ParamByName('Id_TradeMarkSynonymDraft').AsInteger := FItem.Id_TradeMarkSynonymDraft;
end;

procedure TTradeMarkSynonymDraft.SetSaveParams(aParams: TFDParams);
begin
  if not IsNewItem() then
    aParams.ParamByName('Id_TradeMarkSynonymDraft').AsInteger := FItem.Id_TradeMarkSynonymDraft;
  aParams.ParamByName('UserName').AsString := GetUser();
  aParams.ParamByName('Id_TradeMark').AsInteger := FItem.Id_TradeMark;
  aParams.ParamByName('Name').AsString := FItem.Name;
  aParams.ParamByName('ShowUI').AsBoolean := FItem.ShowUI;
end;

end.
