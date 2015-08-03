unit MDM.Catalog.UI.ArticleDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  MDM.Package.Interfaces.ICatalogDraftController,
  MDM.Package.Classes.TCustomFormDetail, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, System.Actions, Vcl.ActnList, Vcl.StdCtrls, cxLabel, cxTextEdit, Vcl.ExtCtrls, cxMaskEdit, cxDropDownEdit,
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, cxMemo,
  MDM.Catalog.Article.Logic.TArticleDraft, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TfrmMDMArticleDetail = class(TCustomFormDetail)
    Panel2: TPanel;
    edtVersion: TcxTextEdit;
    cxLabel4: TcxLabel;
    lbWarning: TcxLabel;
    edtIdArticle: TcxTextEdit;
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acCancel: TAction;
    acSave: TAction;
    cxLabel1: TcxLabel;
    cmbTradeMark: TcxLookupComboBox;
    edtNumber: TcxTextEdit;
    edtNumberShort: TcxTextEdit;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel5: TcxLabel;
    edtName: TcxTextEdit;
    cxLabel6: TcxLabel;
    mDescription: TcxMemo;
    memTradeMark: TFDMemTable;
    dsTradeMark: TDataSource;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edtNumberExit(Sender: TObject);
  private
    FUserName: string;
    FOldNumber: string;
    FIsSaveEnabled: Boolean;
    function GetArticleDraft: TArticleDraft;
    function IsLogicExists: Boolean;
    function Save: Boolean;
    procedure FillTradeMark;
    property ArticleDraft: TArticleDraft read GetArticleDraft;
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
  PROC_A_DRAFT_ITEM_CHECK  = 'a_draft_item_check :UserName, :Number';

{ TfrmMDMArticleDetail }

procedure TfrmMDMArticleDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmMDMArticleDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmMDMArticleDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtNumber.Text <> '') and (cmbTradeMark.ItemIndex > -1) and FIsSaveEnabled;
end;

procedure TfrmMDMArticleDetail.AfterInitItem;
begin
  inherited AfterInitItem();
  FOldNumber := edtNumber.Text;
  edtNumber.SetFocus();
end;

procedure TfrmMDMArticleDetail.BeforeInitItem;
begin
  inherited BeforeInitItem();
  FillTradeMark();
end;

constructor TfrmMDMArticleDetail.Create(aOwner: TComponent; aCatalogDraftController: ICatalogDraftController;
  const aUserName: string);
begin
  inherited Create(aOwner, aCatalogDraftController);
  FUserName := aUserName;
end;

procedure TfrmMDMArticleDetail.edtNumberExit(Sender: TObject);
begin
  if (ArticleDraft.IsNewItem()) or (FOldNumber <> edtNumber.Text) then
    lbWarning.Visible := IsLogicExists()
  else
    lbWarning.Visible := False;
end;

procedure TfrmMDMArticleDetail.FillTradeMark;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(Self);
  try
    Query.Connection := FDConnection;
    Query.SQL.Text := 'a_draft_item_trademarklist_sel';
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

procedure TfrmMDMArticleDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

function TfrmMDMArticleDetail.GetArticleDraft: TArticleDraft;
begin
  Result := inherited CatalogDraftController as TArticleDraft;
end;

procedure TfrmMDMArticleDetail.InitEditItem;
begin
  inherited InitEditItem();
  cmbTradeMark.ItemIndex := cmbTradeMark.Properties.DataController.FindRecordIndexByKey(ArticleDraft.Item.Id_TradeMark);
  edtNumber.Text := ArticleDraft.Item.Number;
  edtNumberShort.Text := ArticleDraft.Item.NumberShort;
  edtName.Text := ArticleDraft.Item.Name;
  mDescription.Lines.Text := ArticleDraft.Item.Description;
  edtVersion.EditValue := ArticleDraft.Item.Version;
  edtIdArticle.EditValue := ArticleDraft.Item.Id_Article;
  FIsSaveEnabled := True;
end;

procedure TfrmMDMArticleDetail.InitNewItem;
begin
  inherited InitNewItem();
  FIsSaveEnabled := False;
  cmbTradeMark.ItemIndex := -1;
  edtNumber.Clear();
  edtNumberShort.Clear();
  edtName.Clear();
  edtVersion.Clear();
  edtIdArticle.Clear();
end;

function TfrmMDMArticleDetail.IsLogicExists: Boolean;
var
  QueryResult: TERPQueryResult;
begin
  QueryResult := TERPQueryHelp.Check(FDConnection, PROC_A_DRAFT_ITEM_CHECK, [TERPParamValue.Create(FUserName),
                                                                             TERPParamValue.Create(edtNumber.Text)]);
  lbWarning.Caption := QueryResult.Text;
  FIsSaveEnabled := (QueryResult.Status <> QUERY_RESULT_ERROR) or not (VarIsNull(edtIdArticle.EditValue));
  Result := QueryResult.Status <> QUERY_RESULT_OK;
end;

function TfrmMDMArticleDetail.Save: Boolean;
begin
  CreateSQLCursor();
  ArticleDraft.Item.Id_TradeMark := cmbTradeMark.EditValue;
  ArticleDraft.Item.Number := edtNumber.Text;
  ArticleDraft.Item.NumberShort := edtNumberShort.Text;
  ArticleDraft.Item.Name := edtName.Text;
  ArticleDraft.Item.Description := mDescription.Lines.Text;
  Result := ArticleDraft.Save();
end;

end.
