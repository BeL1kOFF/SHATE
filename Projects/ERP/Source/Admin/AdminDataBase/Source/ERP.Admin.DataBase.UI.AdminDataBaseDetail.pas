unit ERP.Admin.DataBase.UI.AdminDataBaseDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Vcl.ActnList, Vcl.StdCtrls, cxTextEdit, cxCheckBox, Vcl.ExtCtrls, cxMaskEdit, cxDropDownEdit,
  cxLabel, Data.DB, System.Actions, FireDAC.Comp.Client, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet;

type
  TfrmAdminDataBaseDetail = class(TForm)
    Panel2: TPanel;
    chbEnabled: TcxCheckBox;
    edtIdDataBase: TcxTextEdit;
    edtDataBase: TcxTextEdit;
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    cmbServer: TcxComboBox;
    cxLabel1: TcxLabel;
    cxLabel2: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    edtDataBaseName: TcxTextEdit;
    cxLabel5: TcxLabel;
    cmbTemplate: TcxComboBox;
    qrQuery: TFDQuery;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
  private
    FFDConnection: TFDConnection;
    FId_DataBase: Integer;
    function Save: Boolean;
    function CallBackClassNotFound(aControl: TControl; aField: TField): Boolean;
    procedure FillServers(aId_Server: Integer);
    procedure FillTemplates(aId_Template: Integer);
    procedure Init;
    procedure ReadItem;
  public
    constructor Create(aId_DataBase: Integer; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_ADM_DB_SEL_ITEM = 'adm_db_sel_item :Id_DataBase';
  PROC_ADM_DB_INS_ITEM = 'adm_db_ins_item :Id_Server, :Id_TemplateDataBase, :DataBase, :DataBaseName, :Enabled';
  PROC_ADM_DB_UPD_ITEM = 'adm_db_upd_item :Id_DataBase, :Id_Server, :Id_TemplateDataBase, :DataBase, :DataBaseName,' +
    ' :Enabled';
  PROC_ADM_DB_SEL_SERVERLIST = 'adm_db_sel_serverlist :Id_Server';
  PROC_ADM_DB_SEL_TEMPLATELIST = 'adm_db_sel_templatelist';

  FLD_ID_DATABASE      = 'Id_DataBase';
  FLD_ID_SERVER        = 'Id_Server';
  FLD_ID_TEMPLATEDATABASE = 'Id_TemplateDataBase';
  FLD_DATABASE         = 'DataBase';
  FLD_DATABASENAME     = 'DataBaseName';
  FLD_ENABLED          = 'Enabled';

  FLD_SRV_ID_SERVER = 'Id_Server';
  FLD_SRV_SERVERNAME = 'ServerName';

  FLD_TMPL_ID_TEMPLATEDATABASE = 'Id_TemplateDataBase';
  FLD_TMPL_NAME = 'Name';

  PARAM_SRV_ID_SERVER = 'Id_Server';

{ TfrmAdminDataBaseDetail }

procedure TfrmAdminDataBaseDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAdminDataBaseDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmAdminDataBaseDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtDataBase.Text <> '') and (edtDataBaseName.Text <> '') and
    (cmbServer.ItemIndex > -1) and (cmbTemplate.ItemIndex > -1);
end;

function TfrmAdminDataBaseDetail.CallBackClassNotFound(aControl: TControl; aField: TField): Boolean;
begin
  Result := True;
  if aControl.Name = 'cmbServer' then
    FillServers(aField.AsInteger)
  else
    if aControl.Name = 'cmbTemplate' then
      FillTemplates(aField.AsInteger)
    else
      Result := False;
end;

constructor TfrmAdminDataBaseDetail.Create(aId_DataBase: Integer; aConnection: TFDConnection; aOwner: TComponent);
begin
  inherited Create(aOwner);
  FId_DataBase := aId_DataBase;
  FFDConnection := aConnection;
end;

procedure TfrmAdminDataBaseDetail.FillServers(aId_Server: Integer);
var
  k: Integer;
begin
  cmbServer.Properties.Items.Clear();
  qrQuery.SQL.Text := PROC_ADM_DB_SEL_SERVERLIST;
  qrQuery.Params.ParamValues[PARAM_SRV_ID_SERVER] := aId_Server;
  try
    qrQuery.Open();
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cmbServer.Properties.Items.AddObject(qrQuery.FieldByName(FLD_SRV_SERVERNAME).AsString,
        TObject(qrQuery.FieldByName(FLD_SRV_ID_SERVER).AsInteger));
      qrQuery.Next();
    end;
    cmbServer.ItemIndex := cmbServer.Properties.Items.IndexOfObject(TObject(aId_Server));
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminDataBaseDetail.FillTemplates(aId_Template: Integer);
var
  k: Integer;
begin
  cmbTemplate.Properties.Items.Clear();
  qrQuery.SQL.Text := PROC_ADM_DB_SEL_TEMPLATELIST;
  try
    qrQuery.Open();
    qrQuery.First();
    for k := 0 to qrQuery.RecordCount - 1 do
    begin
      cmbTemplate.Properties.Items.AddObject(qrQuery.FieldByName(FLD_TMPL_NAME).AsString,
        TObject(qrQuery.FieldByName(FLD_TMPL_ID_TEMPLATEDATABASE).AsInteger));
      qrQuery.Next();
    end;
    cmbTemplate.ItemIndex := cmbTemplate.Properties.Items.IndexOfObject(TObject(aId_Template));
  finally
    qrQuery.Close();
  end;
end;

procedure TfrmAdminDataBaseDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmAdminDataBaseDetail.FormShow(Sender: TObject);
begin
  Init();
  edtDataBase.SetFocus();
end;

procedure TfrmAdminDataBaseDetail.Init;
begin
  CreateSQLCursor();
  qrQuery.Connection := FFDConnection;
  if FId_DataBase = -1 then
  begin
    edtIdDataBase.Text := '';
    edtDataBase.Text := '';
    edtDataBaseName.Text := '';
    chbEnabled.Checked := False;
    FillServers(-1);
    FillTemplates(-1);
  end
  else
    ReadItem();
end;

procedure TfrmAdminDataBaseDetail.ReadItem;
begin
  edtIdDataBase.Text := IntToStr(FId_DataBase);
  TERPQueryHelp.ReadItem(FFDConnection, PROC_ADM_DB_SEL_ITEM, [TERPParamValue.Create(FId_DataBase)],
    [TERPControlValue.Create(edtDataBase, FLD_DATABASE),
     TERPControlValue.Create(edtDataBaseName, FLD_DATABASENAME),
     TERPControlValue.Create(chbEnabled, FLD_ENABLED),
     TERPControlValue.Create(cmbServer, FLD_ID_SERVER),
     TERPControlValue.Create(cmbTemplate, FLD_ID_TEMPLATEDATABASE)], CallBackClassNotFound);
end;

function TfrmAdminDataBaseDetail.Save: Boolean;
begin
  CreateSQLCursor();
  if FId_DataBase = -1 then
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_DB_INS_ITEM,
      [TERPParamValue.Create(Integer(cmbServer.Properties.Items.Objects[cmbServer.ItemIndex])),
       TERPParamValue.Create(Integer(cmbTemplate.Properties.Items.Objects[cmbTemplate.ItemIndex])),
       TERPParamValue.Create(edtDataBase.Text),
       TERPParamValue.Create(edtDataBaseName.Text),
       TERPParamValue.Create(chbEnabled.Checked)])
  else
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_DB_UPD_ITEM,
      [TERPParamValue.Create(FId_DataBase),
       TERPParamValue.Create(Integer(cmbServer.Properties.Items.Objects[cmbServer.ItemIndex])),
       TERPParamValue.Create(Integer(cmbTemplate.Properties.Items.Objects[cmbTemplate.ItemIndex])),
       TERPParamValue.Create(edtDataBase.Text),
       TERPParamValue.Create(edtDataBaseName.Text),
       TERPParamValue.Create(chbEnabled.Checked)]);
end;

end.
