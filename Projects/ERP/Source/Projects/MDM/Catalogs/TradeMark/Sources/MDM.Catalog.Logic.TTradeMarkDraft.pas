unit MDM.Catalog.Logic.TTradeMarkDraft;

interface

uses
  Data.DB,
  FireDAC.Stan.Param,
  MDM.Package.Classes.TCatalogDraftController,
  MDM.Package.Classes.TCustomFormDetail,
  MDM.Catalog.Logic.TTradeMarkDraftItem;

type
  TTradeMarkDraft = class(TCatalogDraftController)
  private
    FItem: TTradeMarkDraftItem;
  protected
    function GetFormDetial(aNew: Boolean): TCustomFormDetail; override;
    procedure InitCatalogAccess; override;
    procedure InitSQL; override;
    procedure SetEditReadItemParams(aParams: TFDParams); override;
    procedure SetSaveParams(aParams: TFDParams); override;
    procedure EditReadItemDataSet(aDataSet: TDataSet); override;
    procedure LoadDetailsParserField(aField: TField; var aDocument: string; var aHandled: Boolean); override;
  public
    function IsNewItem: Boolean; override;
    property Item: TTradeMarkDraftItem read FItem write FItem;
  end;

implementation

uses
  Winapi.ActiveX,
  System.Variants,
  System.Classes,
  System.SysUtils,
  MDM.Package.Components.Types,
  MDM.Catalog.UI.TradeMarkDetail,
  MDM.Catalog.Logic.Consts;

{ TTradeMarkDraft }

procedure TTradeMarkDraft.EditReadItemDataSet(aDataSet: TDataSet);
begin
  FItem.Id_TradeMark := aDataSet.FieldByName('Id_TradeMark').AsVariant;
  FItem.Name := aDataSet.FieldByName('Name').AsString;
  FItem.FullName := aDataSet.FieldByName('FullName').AsString;
  FItem.Description := aDataSet.FieldByName('Description').AsString;
  FItem.IsOriginal := aDataSet.FieldByName('IsOriginal').AsBoolean;
  FItem.Logo := aDataSet.FieldByName('Logo').AsVariant;
  FItem.URLSite := aDataSet.FieldByName('URLSite').AsString;
  FItem.URLCatalog := aDataSet.FieldByName('URLCatalog').AsString;
  FItem.Version := aDataSet.FieldByName('Version').AsVariant;
end;

function TTradeMarkDraft.GetFormDetial(aNew: Boolean): TCustomFormDetail;
begin
  FItem.SetDefault();
  if aNew then
    FItem.Id_TradeMarkDraft := -1
  else
    FItem.Id_TradeMarkDraft := GridTableView.Controller.FocusedRecord.Values[GetGridColumnFromServiceType(stPK).Index];
  Result := TfrmMDMTradeMarkDetail.Create(ERPForm, Self, GetUser());
end;

procedure TTradeMarkDraft.InitCatalogAccess;
begin
  CatalogAccess.Add          := A1_DRAFTCREATE;
  CatalogAccess.Edit         := A2_DRAFTEDIT;
  CatalogAccess.Delete       := A3_DRAFTDELETE;
  CatalogAccess.StatusReset  := A4_DRAFTRESET;
  CatalogAccess.StatusReady  := A5_DRAFTREADY;
  CatalogAccess.StatusDelete := A6_DRAFTTODELETE;
  CatalogAccess.Merge        := A7_DRAFTMERGE;
  CatalogAccess.Analysis     := A8_DRAFTANALYSIS;
  CatalogAccess.Approve      := A9_DRAFTAPPROVE;
  CatalogAccess.ImportDraft  := A10_DRAFTIMPORT;
  CatalogAccess.ViewAll      := A15_VIEWALLDRAFT;
end;

procedure TTradeMarkDraft.InitSQL;
begin
//  SQLProc.SQLMetaSelect := 'tm_meta_sel';
  SQLProc.SQLRefreshSelect        := PROC_TM_DRAFT_ITEMLIST_SEL;
  SQLProc.SQLEditReadItem         := PROC_TM_DRAFT_ITEM_SEL;
  SQLProc.SQLInsert               := PROC_TM_DRAFT_ITEM_INS;
  SQLProc.SQLUpdate               := PROC_TM_DRAFT_ITEM_UPD;
  SQLProc.SQLDelete               := PROC_TM_DRAFT_DEL;
  SQLProc.SQLChangeStatus         := PROC_TM_DRAFT_STATUS_CHANGE;
  SQLProc.SQLMergeMeta            := PROC_TM_DRAFT_MERGE_META;
  SQLProc.SQLMergeSelect          := PROC_TM_DRAFT_MERGE_SEL;
  SQLProc.SQLMerge                := PROC_TM_DRAFT_MERGE;
  SQLProc.SQLAnalysis             := PROC_TM_DRAFT_ANALYSIS;
  SQLProc.SQLApprove              := PROC_TM_DRAFT_APPROVE;
  SQLProc.SQLImportMeta := 'tm_draft_import_meta';
  SQLProc.SQLImportCheck := 'tm_draft_import_check :UserName';
  SQLProc.SQLImport := 'tm_draft_import :UserName, :Label';

  SetLength(SQLProc.SQLRefreshDetailsSelect, 1);
  SQLProc.SQLRefreshDetailsSelect[0] := PROC_TM_DRAFT_ITEMLIST_DETAILS_SEL;
end;

function TTradeMarkDraft.IsNewItem: Boolean;
begin
  Result := FItem.Id_TradeMarkDraft = -1;
end;

procedure TTradeMarkDraft.LoadDetailsParserField(aField: TField; var aDocument: string; var aHandled: Boolean);
var
  TempStream: TBytesStream;
  Stream: IStream;
begin
  if aField.FieldName = 'Logo' then
  begin
    TempStream := TBytesStream.Create();
    TempStream.Write(aField.AsBytes[0], Length(aField.AsBytes));
    Stream := TStreamAdapter.Create(TempStream, soOwned);
    Stream._AddRef();
    aDocument := StringReplace(aDocument, '<!-- #' + aField.FieldName + '# -->', Format('<img width="100" src="myhttp://%d" itemprop="image">', [Integer(Stream)]), [rfReplaceAll, rfIgnoreCase]);
    aHandled := True;
  end;
end;

procedure TTradeMarkDraft.SetEditReadItemParams(aParams: TFDParams);
begin
  aParams.ParamByName('Id_TradeMarkDraft').Value := FItem.Id_TradeMarkDraft;
end;

procedure TTradeMarkDraft.SetSaveParams(aParams: TFDParams);
begin
  if not IsNewItem() then
    aParams.ParamByName('Id_TradeMarkDraft').AsInteger := FItem.Id_TradeMarkDraft;
  aParams.ParamByName('UserName').AsString := GetUser();
  aParams.ParamByName('Name').AsString := FItem.Name;
  aParams.ParamByName('FullName').AsString := FItem.FullName;
  aParams.ParamByName('Description').Value := FItem.Description;
  aParams.ParamByName('IsOriginal').AsBoolean := FItem.IsOriginal;
  if VarIsNull(FItem.Logo) then
    aParams.ParamByName('Logo').DataType := ftBlob;
  aParams.ParamByName('Logo').Value := FItem.Logo;
  aParams.ParamByName('URLSite').Value := FItem.URLSite;
  aParams.ParamByName('URLCatalog').Value := FItem.URLCatalog;
end;

end.
