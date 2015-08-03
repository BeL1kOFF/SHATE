unit MDM.Catalog.UI.TradeMarkSynonymDetails;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MDM.Package.Classes.TCustomFormDetail,
  MDM.Package.Interfaces.ICatalogDraftController, Vcl.ExtCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList,
  MDM.Catalog.Logic.TTradeMarkSynonymDraft, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, cxTextEdit, cxLabel, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, cxCheckBox;

type
  TfrmTradeMarkSynonymDetails = class(TCustomFormDetail)
    Panel1: TPanel;
    Panel2: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    ActionList: TActionList;
    acCancel: TAction;
    acSave: TAction;
    cxLabel1: TcxLabel;
    edtName: TcxTextEdit;
    lbWarning: TcxLabel;
    cxLabel4: TcxLabel;
    edtVersion: TcxTextEdit;
    edtIdTradeMarkSynonym: TcxTextEdit;
    cxLabel2: TcxLabel;
    cmbTradeMark: TcxLookupComboBox;
    dsTradeMark: TDataSource;
    memTradeMark: TFDMemTable;
    cbShowUI: TcxCheckBox;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure edtNameExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FOldName: string;
    FUserName: string;
    FIsSaveEnabled: Boolean;
    function GetTradeMarkSynonymDraft: TTradeMarkSynonymDraft;
    function IsLogicExists: Boolean;
    function Save: Boolean;
    procedure FillTradeMark;
    property TradeMarkSynonymDraft: TTradeMarkSynonymDraft read GetTradeMarkSynonymDraft;
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
  PROC_TMS_DRAFT_ITEM_CHECK  = 'tms_draft_item_check :UserName, :Name';

{ TfrmTradeMarkSynonymDetails }

procedure TfrmTradeMarkSynonymDetails.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmTradeMarkSynonymDetails.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmTradeMarkSynonymDetails.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtName.Text <> '') and (cmbTradeMark.ItemIndex > -1) and FIsSaveEnabled;
end;

procedure TfrmTradeMarkSynonymDetails.AfterInitItem;
begin
  inherited AfterInitItem();
  FOldName := edtName.Text;
  edtName.SetFocus();
end;

procedure TfrmTradeMarkSynonymDetails.BeforeInitItem;
begin
  inherited BeforeInitItem();
  FillTradeMark();
end;

constructor TfrmTradeMarkSynonymDetails.Create(aOwner: TComponent; aCatalogDraftController: ICatalogDraftController;
  const aUserName: string);
begin
  inherited Create(aOwner, aCatalogDraftController);
  Caption := (aOwner as TForm).Caption;
  FUserName := aUserName;
end;

procedure TfrmTradeMarkSynonymDetails.edtNameExit(Sender: TObject);
begin
  if (TradeMarkSynonymDraft.IsNewItem()) or (FOldName <> edtName.Text) then
    lbWarning.Visible := IsLogicExists()
  else
    lbWarning.Visible := False;
end;

procedure TfrmTradeMarkSynonymDetails.FillTradeMark;
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(Self);
  try
    Query.Connection := FDConnection;
    Query.SQL.Text := 'tms_draft_item_trademarklist_sel';
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

procedure TfrmTradeMarkSynonymDetails.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

function TfrmTradeMarkSynonymDetails.GetTradeMarkSynonymDraft: TTradeMarkSynonymDraft;
begin
  Result := inherited CatalogDraftController as TTradeMarkSynonymDraft;
end;

procedure TfrmTradeMarkSynonymDetails.InitEditItem;
begin
  inherited InitEditItem();
  cmbTradeMark.ItemIndex := cmbTradeMark.Properties.DataController.FindRecordIndexByKey(TradeMarkSynonymDraft.Item.Id_TradeMark);
  edtName.Text := TradeMarkSynonymDraft.Item.Name;
  cbShowUI.Checked := TradeMarkSynonymDraft.Item.ShowUI;
  edtVersion.EditValue := TradeMarkSynonymDraft.Item.Version;
  edtIdTradeMarkSynonym.EditValue := TradeMarkSynonymDraft.Item.Id_TradeMarkSynonym;
  FIsSaveEnabled := True;
end;

procedure TfrmTradeMarkSynonymDetails.InitNewItem;
begin
  inherited InitNewItem();
  FIsSaveEnabled := False;
  cmbTradeMark.ItemIndex := -1;
  edtName.Text := '';
  cbShowUI.Checked := False;
  edtVersion.EditValue := Null();
  edtIdTradeMarkSynonym.EditValue := Null();
end;

function TfrmTradeMarkSynonymDetails.IsLogicExists: Boolean;
var
  QueryResult: TERPQueryResult;
begin
  QueryResult := TERPQueryHelp.Check(FDConnection, PROC_TMS_DRAFT_ITEM_CHECK, [TERPParamValue.Create(FUserName),
                                                                               TERPParamValue.Create(edtName.Text)]);
  lbWarning.Caption := QueryResult.Text;
  FIsSaveEnabled := (QueryResult.Status <> QUERY_RESULT_ERROR) or not (VarIsNull(edtIdTradeMarkSynonym.EditValue));
  Result := QueryResult.Status <> QUERY_RESULT_OK;
end;

function TfrmTradeMarkSynonymDetails.Save: Boolean;
begin
  CreateSQLCursor();
  TradeMarkSynonymDraft.Item.Id_TradeMark := cmbTradeMark.EditValue;
  TradeMarkSynonymDraft.Item.Name := edtName.Text;
  TradeMarkSynonymDraft.Item.ShowUI := cbShowUI.Checked;
  Result := TradeMarkSynonymDraft.Save();
end;

end.
