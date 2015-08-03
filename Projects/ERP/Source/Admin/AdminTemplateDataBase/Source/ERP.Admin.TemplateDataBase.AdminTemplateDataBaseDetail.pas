unit ERP.Admin.TemplateDataBase.AdminTemplateDataBaseDetail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel,
  cxTextEdit, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ActnList, cxMaskEdit,
  System.Actions, FireDAC.Comp.Client, cxCheckBox;

type
  TfrmAdminTemplateDataBaseDetail = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    Panel2: TPanel;
    edtIdTemplateDataBase: TcxTextEdit;
    edtName: TcxTextEdit;
    cxLabel1: TcxLabel;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    ActionList: TActionList;
    acSave: TAction;
    acCancel: TAction;
    meTypeDB: TcxMaskEdit;
    cbVisible: TcxCheckBox;
    procedure acSaveUpdate(Sender: TObject);
    procedure acCancelExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    FFDConnection: TFDConnection;
    FId_TemplateDataBase: Integer;
    function Save: Boolean;
    procedure Init;
    procedure ReadItem;
  public
    constructor Create(aId_TemplateDataBase: Integer; aConnection: TFDConnection; aOwner: TComponent); reintroduce;
  end;

implementation

{$R *.dfm}

uses
  ERP.Package.CustomInterface.ICustomCursor,
  ERP.Package.CustomGlobalFunctions.UserFunctions;

const
  PROC_ADM_TDB_SEL_ITEM = 'adm_tdb_sel_item :Id_TemplateDataBase';
  PROC_ADM_TDB_INS_ITEM = 'adm_tdb_ins_item :Name, :TypeDB, :Visible';
  PROC_ADM_TDB_UPD_ITEM = 'adm_tdb_upd_item :Id_TemplateDataBase, :Name, :TypeDB, :Visible';

  FLD_NAME = 'Name';
  FLD_TYPEDB = 'TypeDB';
  FLD_VISIBLE = 'Visible';

{ TfrmAdminTemplateDataBaseDetail }

procedure TfrmAdminTemplateDataBaseDetail.acCancelExecute(Sender: TObject);
begin
  Close();
end;

procedure TfrmAdminTemplateDataBaseDetail.acSaveExecute(Sender: TObject);
begin
  if Save() then
    Close();
end;

procedure TfrmAdminTemplateDataBaseDetail.acSaveUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := (edtName.Text <> '') and (meTypeDB.Text <> '');
end;

constructor TfrmAdminTemplateDataBaseDetail.Create(aId_TemplateDataBase: Integer; aConnection: TFDConnection;
  aOwner: TComponent);
begin
  inherited Create(aOwner);
  FId_TemplateDataBase := aId_TemplateDataBase;
  FFDConnection := aConnection;
end;

procedure TfrmAdminTemplateDataBaseDetail.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
    #13:
      btnSave.Click();
    #27:
      btnCancel.Click();
  end;
end;

procedure TfrmAdminTemplateDataBaseDetail.FormShow(Sender: TObject);
begin
  Init();
  edtName.SetFocus();
end;

procedure TfrmAdminTemplateDataBaseDetail.Init;
begin
  CreateSQLCursor();
  if FId_TemplateDataBase = -1 then
  begin
    edtIdTemplateDataBase.Text := '';
    edtName.Text := '';
    meTypeDB.Text := '';
    cbVisible.Checked := False;
  end
  else
    ReadItem();
end;

procedure TfrmAdminTemplateDataBaseDetail.ReadItem;
begin
  edtIdTemplateDataBase.Text := IntToStr(FId_TemplateDataBase);
  TERPQueryHelp.ReadItem(FFDConnection, PROC_ADM_TDB_SEL_ITEM, [TERPParamValue.Create(FId_TemplateDataBase)],
    [TERPControlValue.Create(edtName, FLD_NAME),
     TERPControlValue.Create(meTypeDB, FLD_TYPEDB),
     TERPControlValue.Create(cbVisible, FLD_VISIBLE)], nil);
end;

function TfrmAdminTemplateDataBaseDetail.Save: Boolean;
begin
  CreateSQLCursor();
  if FId_TemplateDataBase = -1 then
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_TDB_INS_ITEM,
      [TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(meTypeDB.Text),
       TERPParamValue.Create(cbVisible.Checked)])
  else
    Result := TERPQueryHelp.Open(FFDConnection, PROC_ADM_TDB_UPD_ITEM,
      [TERPParamValue.Create(FId_TemplateDataBase),
       TERPParamValue.Create(edtName.Text),
       TERPParamValue.Create(meTypeDB.Text),
       TERPParamValue.Create(cbVisible.Checked)]);
end;

end.
