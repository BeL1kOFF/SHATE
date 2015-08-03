unit MDM.Catalog.Crosses.UI.Details;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  MDM.Package.Interfaces.ICatalogDraftController,
  MDM.Package.Classes.TCustomFormDetail, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Actions,
  Vcl.ActnList, Vcl.StdCtrls, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, cxLabel,
  cxTextEdit, Vcl.ExtCtrls,
  MDM.Catalog.Crosses.Logic.TCrossesDraft;

type
  TfrmMDMCrossesDetail = class(TCustomFormDetail)
    Panel2: TPanel;
    edtVersion: TcxTextEdit;
    cxLabel4: TcxLabel;
    lbWarning: TcxLabel;
    edtIdCross: TcxTextEdit;
    cxLabel1: TcxLabel;
    cmbTradeMark1: TcxLookupComboBox;
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acCancel: TAction;
    acSave: TAction;
    memTradeMark1: TFDMemTable;
    dsTradeMark1: TDataSource;
    cxLabel3: TcxLabel;
    cmbTradeMark2: TcxLookupComboBox;
    cxLabel2: TcxLabel;
    cmbArticle1: TcxLookupComboBox;
    cxLabel5: TcxLabel;
    cmbArticle2: TcxLookupComboBox;
    memTradeMark2: TFDMemTable;
    dsTradeMark2: TDataSource;
    memArticle1: TFDMemTable;
    memArticle2: TFDMemTable;
    dsArticle1: TDataSource;
    dsArticle2: TDataSource;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure cmbTradeMark1PropertiesChange(Sender: TObject);
    procedure cmbTradeMark2PropertiesChange(Sender: TObject);
    procedure cmbArticle1PropertiesChange(Sender: TObject);
    procedure cmbArticle2PropertiesChange(Sender: TObject);
  private
    FUserName: string;
    FOldArticle1: Integer;
    FOldArticle2: Integer;
    FIsSaveEnabled: Boolean;
    function Save: Boolean;
    procedure CheckArticleExists;
    procedure FillTradeMark;
    procedure FillArticle(aId_TradeMark: Integer; aArticleMemTable: TFDMemTable);
    function GetCrossDraft: TCrossesDraft;
    function IsLogicExists: Boolean;
    property CrossDraft: TCrossesDraft read GetCrossDraft;
  protected
    procedure AfterInitItem; override;
    procedure BeforeInitItem; override;
    procedure InitEditItem; override;
    procedure InitNewItem; override;
  public
    constructor Create(aOwner: TComponent; aCatalogDraftController: ICatalogDraftController;
      const aUserName: string); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_C_DRAFT_ITEM_CHECK  = 'c_draft_item_check :UserName, :Id_Article1, :Id_Article2';

{ TForm1 }

procedure TfrmMDMCrossesDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmMDMCrossesDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmMDMCrossesDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cmbArticle1.ItemIndex > -1) and (cmbArticle2.ItemIndex > -1) and FIsSaveEnabled;
end;

procedure TfrmMDMCrossesDetail.AfterInitItem;
begin
  inherited AfterInitItem();
  if cmbArticle1.ItemIndex > -1 then
    FOldArticle1 := cmbArticle1.EditValue
  else
    FOldArticle1 := -1;
  if cmbArticle2.ItemIndex > -1 then
    FOldArticle2 := cmbArticle2.EditValue
  else
    FOldArticle2 := -1;
  CheckArticleExists();
end;

procedure TfrmMDMCrossesDetail.BeforeInitItem;
begin
  inherited BeforeInitItem();
  FillTradeMark();
end;

procedure TfrmMDMCrossesDetail.CheckArticleExists;
begin
  if (cmbArticle1.ItemIndex = -1) or (cmbArticle2.ItemIndex = -1) or
     (VarIsNull(cmbArticle1.EditValue)) or (VarIsNull(cmbArticle2.EditValue)) then
  begin
    lbWarning.Visible := False;
    Exit;
  end;

  if ((CrossDraft.IsNewItem()) or (FOldArticle1 <> cmbArticle1.EditValue) or (FOldArticle2 <> cmbArticle2.EditValue)) then
    lbWarning.Visible := IsLogicExists()
  else
    lbWarning.Visible := False;
end;

procedure TfrmMDMCrossesDetail.cmbArticle1PropertiesChange(Sender: TObject);
begin
  CheckArticleExists();
end;

procedure TfrmMDMCrossesDetail.cmbArticle2PropertiesChange(Sender: TObject);
begin
  CheckArticleExists();
end;

procedure TfrmMDMCrossesDetail.cmbTradeMark1PropertiesChange(Sender: TObject);
begin
  FillArticle(cmbTradeMark1.EditValue, memArticle1);
end;

procedure TfrmMDMCrossesDetail.cmbTradeMark2PropertiesChange(Sender: TObject);
begin
  FillArticle(cmbTradeMark2.EditValue, memArticle2);
end;

constructor TfrmMDMCrossesDetail.Create(aOwner: TComponent; aCatalogDraftController: ICatalogDraftController;
  const aUserName: string);
begin
  inherited Create(aOwner, aCatalogDraftController);
  FUserName := aUserName;
end;

procedure TfrmMDMCrossesDetail.FillArticle(aId_TradeMark: Integer; aArticleMemTable: TFDMemTable);
var
  Query: TFDQuery;
begin
  if aArticleMemTable.Active then
    aArticleMemTable.Close();
  Query := TFDQuery.Create(Self);
  try
    Query.Connection := FDConnection;
    Query.SQL.Text := 'c_draft_item_articlelist_sel :Id_TradeMark';
    Query.Params.ParamValues['Id_TradeMark'] := aId_TradeMark;
    Query.Open();
    try
      aArticleMemTable.Data := Query.Data;
    finally
      Query.Close();
    end;
  finally
    Query.Free();
  end;
end;

procedure TfrmMDMCrossesDetail.FillTradeMark;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(Self);
  try
    Query.Connection := FDConnection;
    Query.SQL.Text := 'c_draft_item_trademarklist_sel';
    Query.Open();
    try
      memTradeMark1.Data := Query.Data;
      memTradeMark2.Data := Query.Data;
    finally
      Query.Close();
    end;
  finally
    Query.Free();
  end;
end;

function TfrmMDMCrossesDetail.GetCrossDraft: TCrossesDraft;
begin
  Result := inherited CatalogDraftController as TCrossesDraft;
end;

procedure TfrmMDMCrossesDetail.InitEditItem;
begin
  inherited InitEditItem();
  cmbTradeMark1.ItemIndex := cmbTradeMark1.Properties.DataController.FindRecordIndexByKey(CrossDraft.Item.Id_TradeMark1);
  cmbTradeMark2.ItemIndex := cmbTradeMark2.Properties.DataController.FindRecordIndexByKey(CrossDraft.Item.Id_TradeMark2);
  cmbArticle1.ItemIndex := cmbArticle1.Properties.DataController.FindRecordIndexByKey(CrossDraft.Item.Id_Article1);
  cmbArticle2.ItemIndex := cmbArticle2.Properties.DataController.FindRecordIndexByKey(CrossDraft.Item.Id_Article2);
  edtVersion.EditValue := CrossDraft.Item.Version;
  edtIdCross.EditValue := CrossDraft.Item.Id_Cross;
  FIsSaveEnabled := True;
end;

procedure TfrmMDMCrossesDetail.InitNewItem;
begin
  inherited InitNewItem();
  FIsSaveEnabled := False;
  cmbTradeMark1.ItemIndex := -1;
  cmbTradeMark2.ItemIndex := -1;
  cmbArticle1.ItemIndex := -1;
  cmbArticle2.ItemIndex := -1;
  edtVersion.Clear();
  edtIdCross.Clear();
end;

function TfrmMDMCrossesDetail.IsLogicExists: Boolean;
var
  QueryResult: TERPQueryResult;
begin
  QueryResult := TERPQueryHelp.Check(FDConnection, PROC_C_DRAFT_ITEM_CHECK, [TERPParamValue.Create(FUserName),
                                                                             TERPParamValue.Create(Integer(cmbArticle1.EditValue)),
                                                                             TERPParamValue.Create(Integer(cmbArticle2.EditValue))]);
  lbWarning.Caption := QueryResult.Text;
  FIsSaveEnabled := (QueryResult.Status <> QUERY_RESULT_ERROR) or not (VarIsNull(edtIdCross.EditValue));
  Result := QueryResult.Status <> QUERY_RESULT_OK;
end;

function TfrmMDMCrossesDetail.Save: Boolean;
begin
  CreateSQLCursor();
  CrossDraft.Item.Id_Article1 := cmbArticle1.EditValue;
  CrossDraft.Item.Id_Article2 := cmbArticle2.EditValue;
  Result := CrossDraft.Save();
end;

end.
