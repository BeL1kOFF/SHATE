unit ERP.Admin.AccessTable.UI.AdminAccessTableDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, System.Actions, Vcl.ActnList, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxLabel, FireDAC.Comp.Client, Data.DB;

type
  TfrmAdminAccessTableDetail = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    cxLabel1: TcxLabel;
    cmbTemplateDB: TcxComboBox;
    cxLabel2: TcxLabel;
    edtId: TcxTextEdit;
    cxLabel3: TcxLabel;
    edtTableName: TcxTextEdit;
    cxLabel4: TcxLabel;
    edtFieldId: TcxTextEdit;
    cxLabel5: TcxLabel;
    edtCode: TcxTextEdit;
    cxLabel6: TcxLabel;
    edtTableCaption: TcxTextEdit;
    cxLabel7: TcxLabel;
    edtFieldCaption: TcxTextEdit;
    cxLabel8: TcxLabel;
    edtFieldName: TcxTextEdit;
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FConnection: TFDConnection;
    FId_AccessTable: Integer;
    function CallBackClassNotFound(aControl: TControl; aField: TField): Boolean;
    function Save: Boolean;
    procedure Init;
    procedure ReadItem;
    procedure FillTemplatesDB(aId_TemplateDB: Integer);
  public
    constructor Create(aOwner: TComponent; aConnection: TFDConnection; aId_AccessTable: Integer); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_ADM_AT_SEL_TEMPLATELIST = 'adm_at_sel_templatelist';
  PROC_ADM_AT_SEL_ITEM = 'adm_at_sel_item :Id_AccessTable';
  PROC_ADM_AT_INS_ITEM = 'adm_at_ins_item :Id_TemplateDataBase, :TableName, :TableCaption, :FieldId, :FieldName, :FieldCaption, :AccessCode';
  PROC_ADM_AT_UPD_ITEM = 'adm_at_upd_item :Id_AccessTable, :Id_TemplateDataBase, :TableName, :TableCaption, :FieldId, :FieldName, :FieldCaption, :AccessCode';

  FLD_TMPL_ID_TEMPLATEDATABASE = 'Id_TemplateDataBase';
  FLD_TMPL_NAME = 'Name';

  FLD_TABLENAME = 'TableName';
  FLD_TABLECAPTION = 'TableCaption';
  FLD_FIELDID = 'FieldId';
  FLD_FIELDNAME = 'FieldName';
  FLD_FIELDCAPTION = 'FieldCaption';
  FLD_ACCESSCODE = 'AccessCode';
  FLD_ID_TEMPLATEDATABASE = 'Id_TemplateDataBase';

procedure TfrmAdminAccessTableDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAdminAccessTableDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmAdminAccessTableDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (cmbTemplateDB.ItemIndex > -1) and (edtTableName.Text <> '') and
    (edtFieldName.Text <> '') and (edtCode.Text <> '') and (edtTableCaption.Text <> '') and
    (edtFieldCaption.Text <> '') and (edtFieldId.Text <> '');
end;

function TfrmAdminAccessTableDetail.CallBackClassNotFound(aControl: TControl; aField: TField): Boolean;
begin
  Result := True;
  if aControl.Name = 'cmbTemplateDB' then
    FillTemplatesDB(aField.AsInteger)
  else
    Result := False;
end;

constructor TfrmAdminAccessTableDetail.Create(aOwner: TComponent; aConnection: TFDConnection; aId_AccessTable: Integer);
begin
  inherited Create(aOwner);
  FConnection := aConnection;
  FId_AccessTable := aId_AccessTable;
end;

procedure TfrmAdminAccessTableDetail.FillTemplatesDB(aId_TemplateDB: Integer);
begin
  TERPQueryHelp.FillStrings(cmbTemplateDB.Properties.Items, FConnection, PROC_ADM_AT_SEL_TEMPLATELIST, [],
    FLD_TMPL_ID_TEMPLATEDATABASE, FLD_TMPL_NAME);
  cmbTemplateDB.ItemIndex := cmbTemplateDB.Properties.Items.IndexOfObject(TObject(aId_TemplateDB));
end;

procedure TfrmAdminAccessTableDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmAdminAccessTableDetail.FormShow(Sender: TObject);
begin
  Init();
  edtTableName.SetFocus();
end;

procedure TfrmAdminAccessTableDetail.Init;
begin
  CreateSQLCursor();
  if FId_AccessTable = -1 then
  begin
    edtId.Text := '';
    edtTableName.Text := '';
    edtTableCaption.Text := '';
    edtFieldId.Text := '';
    edtFieldName.Text := '';
    edtFieldCaption.Text := '';
    edtCode.Text := '';
    FillTemplatesDB(-1);
  end
  else
    ReadItem();
end;

procedure TfrmAdminAccessTableDetail.ReadItem;
begin
  edtId.Text := IntToStr(FId_AccessTable);
  TERPQueryHelp.ReadItem(FConnection, PROC_ADM_AT_SEL_ITEM, [TERPParamValue.Create(FId_AccessTable)],
    [TERPControlValue.Create(edtTableName, FLD_TABLENAME),
     TERPControlValue.Create(edtTableCaption, FLD_TABLECAPTION),
     TERPControlValue.Create(edtFieldId, FLD_FIELDID),
     TERPControlValue.Create(edtFieldName, FLD_FIELDNAME),
     TERPControlValue.Create(edtFieldCaption, FLD_FIELDCAPTION),
     TERPControlValue.Create(edtCode, FLD_ACCESSCODE),
     TERPControlValue.Create(cmbTemplateDB, FLD_ID_TEMPLATEDATABASE, False)], CallBackClassNotFound);
end;

function TfrmAdminAccessTableDetail.Save: Boolean;
begin
  CreateSQLCursor();
  if FId_AccessTable = -1 then
    Result := TERPQueryHelp.Open(FConnection, PROC_ADM_AT_INS_ITEM,
      [TERPParamValue.Create(Integer(cmbTemplateDB.Properties.Items.Objects[cmbTemplateDB.ItemIndex])),
       TERPParamValue.Create(edtTableName.Text),
       TERPParamValue.Create(edtTableCaption.Text),
       TERPParamValue.Create(edtFieldId.Text),
       TERPParamValue.Create(edtFieldName.Text),
       TERPParamValue.Create(edtFieldCaption.Text),
       TERPParamValue.Create(edtCode.Text)])
  else
    Result := TERPQueryHelp.Open(FConnection, PROC_ADM_AT_UPD_ITEM,
      [TERPParamValue.Create(FId_AccessTable),
       TERPParamValue.Create(Integer(cmbTemplateDB.Properties.Items.Objects[cmbTemplateDB.ItemIndex])),
       TERPParamValue.Create(edtTableName.Text),
       TERPParamValue.Create(edtTableCaption.Text),
       TERPParamValue.Create(edtFieldId.Text),
       TERPParamValue.Create(edtFieldName.Text),
       TERPParamValue.Create(edtFieldCaption.Text),
       TERPParamValue.Create(edtCode.Text)]);
end;

end.
