unit MDM.Catalog.Article.Logic.TArticleClean;

interface

uses
  FireDAC.Stan.Param,
  MDM.Package.Classes.TCatalogCleanController;

type
  TArticleClean = class(TCatalogCleanController)
  protected
    function UpdateRefresh: Boolean; override;
    procedure InitCatalogAccess; override;
    procedure InitSQL; override;
    procedure SetRefreshParams(aParams: TFDParams); override;
  end;

implementation

uses
  System.Variants,
  Data.DB,
  cxBarEditItem,
  cxDBLookupComboBox,
  MDM.Catalog.Article.Logic.Consts,
  MDM.Catalog.UI.Article;

{ TArticleClean }

procedure TArticleClean.InitCatalogAccess;
begin
  CatalogAccess.MoveToDraft := A11_TODRAFT;
  CatalogAccess.CopyFrom := A12_COPY;
  CatalogAccess.Restore := A13_RESTORE;
  CatalogAccess.ExportClean := A14_EXPORT;
end;

procedure TArticleClean.InitSQL;
begin
  SQLProc.SQLRefreshSelect := 'a_itemlist_sel :Id_TradeMark';
  SQLProc.SQLMoveToDraftSelect := 'a_todraft_upd :UserName';
  SQLProc.SQLMoveToDraftCheck := 'a_todraft_check :UserName';
  SQLProc.SQLCopyFromSelect := 'a_copyfrom_ins :UserName';
  SQLProc.SQLRestoreSelect := 'a_restore_upd';
  SQLProc.SQLExportMeta := 'a_itemlist_export_meta';
  SQLProc.SQLExport := 'a_itemlist_export';
end;

procedure TArticleClean.SetRefreshParams(aParams: TFDParams);
var
  ComboBox: TcxBarEditItem;
begin
  ComboBox := (ERPForm as TfrmMDMArticle).cmbTradeMark;
  if VarIsNull(ComboBox.EditValue) then
    aParams.ParamByName('Id_TradeMark').DataType := ftInteger;
  aParams.ParamByName('Id_TradeMark').Value := ComboBox.EditValue;
end;

function TArticleClean.UpdateRefresh: Boolean;
var
  ComboBox: TcxBarEditItem;
begin
  ComboBox := (ERPForm as TfrmMDMArticle).cmbTradeMark;
  Result := inherited UpdateRefresh() and
    ((ComboBox.Properties as TcxLookupComboBoxProperties).DataController.FindRecordIndexByKey(ComboBox.EditValue) > -1);
end;

end.
